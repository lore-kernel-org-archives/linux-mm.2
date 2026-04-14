Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1D87F9D0F1
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 21:11:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5AB36B0088; Tue, 14 Apr 2026 17:11:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0BAA6B0089; Tue, 14 Apr 2026 17:11:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFA836B0092; Tue, 14 Apr 2026 17:11:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B88826B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 17:11:17 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 63C76139BC0
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 21:11:17 +0000 (UTC)
X-FDA: 84658406994.13.7F6C44B
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf30.hostedemail.com (Postfix) with ESMTP id B936F80011
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 21:11:14 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=QG0GQTbN;
	spf=pass (imf30.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776201075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AuEHnX7kWxd/FJTGvaPpHXaoXjFIOX0QyT6a184ATdM=;
	b=gy7Wue7ux8Arq7j3WY6RNYw7xNrY87MBAQLkumGpCVYtCfMstpbaXlF0lOvGSDce9T+tIV
	5u8Qy4GaQ4MNFo/EUllPzoYK3/LSh8jS6LbdlKfFdmJ5SiPduXBO3JfcRcod7SZ7Sx4HWZ
	SNsbaki2omR0JHBMBYuB/5uOc+oN6aM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=QG0GQTbN;
	spf=pass (imf30.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776201075; a=rsa-sha256;
	cv=none;
	b=So1kYs2KYCpl4Q5AG4UWodq4oWMZQIxuohQN0N9Y5nDxbSyCr2xjgucpwx8KIu26+9vcSi
	b7q9Hgqwip5nF2AwzlaK3CcRaahu5FpnBBIXgIyyzE+Vv654N38rlhpK8PrYIamz2WUltt
	RiZkYGqcLdNAVc/IAGuQ3lPRnQE+DAE=
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63EKtuhj1405470
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 17:11:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=AuEH
	nX7kWxd/FJTGvaPpHXaoXjFIOX0QyT6a184ATdM=; b=QG0GQTbNnyHpwda/t77d
	6fq+HVtXWEJrsdQVu/03mkSTpwxi87OUzza7DZOWRzZ+ogd8K9baJGr5E4/tWb4e
	6lxpVsFVmJ1bwsq0f9L3t8DsPQXPwQcFI1/GC4wzG3IPN6Z4xBOdw2JegcVXBtJ2
	mRiVPTwwgvinYm7bNB4L+DwGVyID7zpDDp4tpYpnSpEIp6huYzhGcY3eVKGkfAkI
	PEWyzwSBPHH+dWdOKV2jlvoLTPM+GZyCrXcSX//oNog7aU+j8TUpT7d55gssU1Dz
	fSR5aglc/ibAsYWkIAI5TTbJr7BL+1hneXKgwTD6YLzC/cAqghgylgEbIgNbt6pU
	VQ==
Received: from mail-qk1-f168.google.com (mail-qk1-f168.google.com [209.85.222.168])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4dh85frh8n-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 17:11:13 -0400 (EDT)
Received: by mail-qk1-f168.google.com with SMTP id af79cd13be357-8d7522f0ecdso1162405185a.3
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 14:11:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776201073; x=1776805873;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AuEHnX7kWxd/FJTGvaPpHXaoXjFIOX0QyT6a184ATdM=;
        b=f1xtEpY5US1zpbZgLJZCFj/fxaDMR1+nCDb8i14x3wA36I2TtOL7BFFIGnyLEUwnHi
         blDizFWm+AmcXGIp/ugMB4Eld/jBNthXSD1ip4Jnt4o5l3yb+3twYb05575lkH4QvPmm
         ILBMDurM/i5PCzPkDLtCD+fhitdBszODfBcaFgdNY4PsjD1lhQ3UI5Yuky/eLuCxyUZL
         vlK1rqFW3WXQX6M1gTXK8VomrFsc/1MXNSi9yg1KvCosvHh0BCRCxomqPK+uCe4KnfKy
         ys062UppHoLWhvJZjQlf4zakJBJZlBeNrQcK2QjSxVtJOpTU4VbmLLFtmzI6JPdwnOkC
         bvoQ==
X-Forwarded-Encrypted: i=1; AFNElJ/be4RTEW7E0gjWRqOXJQwLlR3a4t9IPvHVWXvvQ0jcWXXpkrixkAUlFG1f3pwQcW+89QdvIpFHmA==@kvack.org
X-Gm-Message-State: AOJu0YzLCpUuJCwqBPiV2iUC9BZFb75oiHKCvfatErx/dJWRvoJt4Xp3
	0gVr2ZDL0kWzL62t8SAgBMC06bcgtwdYR0nFtcixtenFKld2omFrrGArv0pCFXm6Nvl4hNInObv
	A+ypDRPCOo7m+YfL3dlNt11NpbEC/+g8yMXPxi+8jcOdL+qq7
X-Gm-Gg: AeBDiespTV4OAXc4lzmG3qByqy2d/tnjN1oObwy5BEOtQHqM9rTCjrw1sdvXVlBJHLq
	OxD8USZ1fvFRYIHEqu8o2qryMNrtV7Ae+N1k5pVG9MOZJHPqRN8yRMu5CNge68UeaEwhROBg+mp
	Udfns6nOBil7Eazl7TVo6lshjB5yvA2ARWjaTHIuipVXOfgZtl3M+xqecQYQAtqRVXQ4uos8nba
	+eJyh77Ve04LPRmA8FOLUvhYYwD+HawoXwxbV9iT2kWnBIJ9zAe9TavROnqPMz8cMGnMyLS95oC
	S4f78QGEIb1NcTVe/06EYr+c96hhPNeA8TPPPoRl71hIRf+BuKLRV7IERqHDI7RJmm03bI8tc8y
	DWg+mMvYjn/wMIRlkC+crAcJZNJ7hjAMhH73ikUFpHCQHLIozf8DLZa3dZGDtDKtNZVPcKW8=
X-Received: by 2002:a05:620a:31a3:b0:8cf:d579:4aff with SMTP id af79cd13be357-8ddcd602be5mr2722041885a.16.1776201072740;
        Tue, 14 Apr 2026 14:11:12 -0700 (PDT)
X-Received: by 2002:a05:620a:31a3:b0:8cf:d579:4aff with SMTP id af79cd13be357-8ddcd602be5mr2722034285a.16.1776201072103;
        Tue, 14 Apr 2026 14:11:12 -0700 (PDT)
Received: from [192.168.1.62] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8ddb915b738sm1204569985a.32.2026.04.14.14.11.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2026 14:11:11 -0700 (PDT)
Message-ID: <d002a0dc-c54a-4d91-98ce-75154363b7f5@columbia.edu>
Date: Tue, 14 Apr 2026 17:11:10 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Towards Unified and Extensible Memory Reclaim
 (reclaim_ext)
To: Gregory Price <gourry@gourry.net>
Cc: Matthew Wilcox <willy@infradead.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        lsf-pc@lists.linux-foundation.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        David Hildenbrand <david@kernel.org>,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Chen Ridong <chenridong@huaweicloud.com>,
        Emil Tsalapatis <emil@etsalapatis.com>,
        Alexei Starovoitov <ast@kernel.org>, Yuanchu Xie <yuanchu@google.com>,
        Wei Xu <weixugc@google.com>, Kairui Song <ryncsn@gmail.com>,
        Nhat Pham <nphamcs@gmail.com>, Barry Song <21cnbao@gmail.com>,
        David Stevens <stevensd@google.com>, Vernon Yang <vernon2gm@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Kalesh Singh <kaleshsingh@google.com>,
        wangzicheng <wangzicheng@honor.com>,
        "T . J . Mercier" <tjmercier@google.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Meta kernel team <kernel-team@meta.com>, bpf@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260325210637.3704220-1-shakeel.butt@linux.dev>
 <20260325190547.abb7309fb63473b57b7a90a0@linux-foundation.org>
 <acTaRgusrxfCoKqe@tiehlicka>
 <ac05d923-7871-4691-8d26-eff41b3a3db0@lucifer.local>
 <CAJHvVchSfGDubPhir0SgZfr_BcpN5oq_7AY4AZ587_ucgY4Apw@mail.gmail.com>
 <acWXdvHx9mYqvT2w@gourry-fedora-PF4VCD3F>
 <CAJHvVciAmX9OFLBSahwvXL=E+3xnDsL2aE4WKfDBFqaT1Gu+Qg@mail.gmail.com>
 <acX8_XMQYA0-NGUW@casper.infradead.org>
 <6f40c513-af3e-45b6-9000-c61494a23bd3@columbia.edu>
 <acbd5lKEh8xa1IQk@gourry-fedora-PF4VCD3F>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <acbd5lKEh8xa1IQk@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: C8_wZ-wWAPzE8xbPb-B-t7YDn7TFMUGz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE0MDE5NyBTYWx0ZWRfX8++vzOFWCoKW
 ExUMH4heVi39d6tppk09LK5UFIZaqh31rGR78U4+ISNseAiT95LA35BnAIVr8lOdeTX3C96+FyZ
 D8v1xpIF1XYX4GFpNuAQheIW6/57pCmvXghxeHkDpAbhpdIqhO4n29T5TLgQsBPvgeIpKydgl7b
 HSSrmWSdtYTpNqd2V82nf3NZUXC/cju6clIIY+gMafHmvcSLPvhVWWS1FsLu7mXAD7ej0h8Y5n5
 IX75jlxK2maMKYoosf/1SEUV4ta/YMd97GGr5CL2nYrC7dPxdSssTWR2lqT0evdHjyaMUQroALP
 PzpDlfb28uOsnUdgXTJ4cuYkIoGzC3tW+cyYrybADQF4cVdrz0LQQ/w67g4hJ2PcBcW8BDz91oz
 5WZID21aBkKFbzl3E9D8/snHoyttWjqTcMqGny01dsC8++JPUNCHSjCb7H8RFWByckI7F027X6b
 /5ARZlC6Jp26KvjcVUA==
X-Proofpoint-ORIG-GUID: C8_wZ-wWAPzE8xbPb-B-t7YDn7TFMUGz
X-Authority-Analysis: v=2.4 cv=PoWjqQM3 c=1 sm=1 tr=0 ts=69dead71 cx=c_pps
 a=zwWbXilFUbXn88m9aJbCnw==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=BpGzv1V74M3SfeTrGa8v:22
 a=mJhthyEqkmu8OjK3UDMA:9 a=QEXdDO2ut3YA:10 a=t-zOcvtzNAFHAFCEYl37:22
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11759
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=10 clxscore=1015 malwarescore=0 spamscore=0 impostorscore=10
 bulkscore=10 suspectscore=0 phishscore=0 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604140197
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B936F80011
X-Stat-Signature: cat6hine6rraytgou7wuk598wx18msu4
X-HE-Tag: 1776201074-555875
X-HE-Meta: U2FsdGVkX19UMgBOyOykck51XEGoUZODRW+qeWlmkPIOIHErHcECO8T/R8LZ9hoEb6/KgbkfJ63TA/pEiu0kViayqLC56KhJpOd1dJl1oixq+pxDAul+1MDO7+kXUNmxFUhLOar+5TBsHQ0aG2n9UYGetrL+3iJey/YVWk8lg5Rwr4gKT3IYia1npiMy62+h2oeLPe27mkcygbzRlfwTdcJFU4P4+QM4CmD30naWTUq+Eq0yx2IdcZLOfLmC158KJoguMiOgy2GpE2sdEkts4R+WuTn8KWLFkfRQIe0HBjyga7BrGmFAaOzOAt2TUfl4mZ794hNf3TBbjxIA390JizNZyuJaeGrDwC/ghIl8qNg1vgIJeY66oQeLZEAIEPOTdMEdE6i9YEXNMtm8h4dtpaN7WI29Qpni9drBMil9Q68dYRTPEpxKyLJiKrXpQXj3Izc3sVponnx8hrD1RE7EtSVNdJ5/NefvHuo1IAdkn5m1Q/AZltoSTL74IjTyT0c0wmCD74Z5J3JkVpCxjr9qDCKC/CJzz2sc9LpChhJY6kYyH3vmcpq3Q+lW1caxFLi6mkRcd2l9kNbC96noEoWfX9RXo5hVqq/I+7b5e6ik+GrKi93JUt+AyEieH9qhASmJE4j1SwYy1+grJaqP5ugImaVk7HL9cq/O6SACeHfT/+Tufq3R75YiZRSSf6pV35zrj+lF3dmKAkKUfPyQjHEo91Rhb1EEw55eWKBHcxw0MqZ8Pue5KA8HvG0/W2t9vRYg2dok7aUhVIaK+yaU52wqxPipA49Rk+E+pgzaFuxTM6KMq8jnZJsnyGy33KZEDJ/DvKehdtUqSA4HUVdGwGXmOhyZRT+8N5l87zc7ysmFNOgcx+gWyyIJ1mgrqAqzmS8jnsgXtNAzkrFNQBsSaNaJecCDTjqqMoJxg2YiN5T5Iji1GPrs7qb1eGArXto1HLWx7n7tvFvN0sU9I58PyAx
 SXgRTxUS
 YT8EhLG2Qno5tvJOYyjyCk9/AtAURryUH/czUcyCi/7J7i8Y3to2F+qN3aJ4nPAm9+azFLjb958baENZiJBjsJw+HtrkJ1+rBs5QiFEd0cbIzqfA9uAeWN2guq+zyZR6W4ikBGjwAmV8NXpD10dhXA3sHKuZVb/kHLJBnWtKcj581QYhksGphBZV5PbAukc55n3oduGNmMMR/h5xRNSP9/J6BRcn4s2/++ndRd5RpJaacxbMlQnIcyA+2O4/tjQiP+sCCm2iPDItrQ+DRVvOK8cC96TN/6gRQC+7rrl2Euw+5oW4bc1MCFu7Y3p9xz1Y9UZfVn2V4qfcLiNhfS4Jc6biUDMan3uhHrEsQOoVqX8tw28dpNiCO9CIEJ4ncsP3aHxPI960MVzcn6yk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/27/26 3:43 PM, Gregory Price wrote:
> On Fri, Mar 27, 2026 at 03:12:16PM -0400, Tal Zussman wrote:
>> 
>> It's been well-known in the academic realm for a while that there isn't
>> really a "one-size-fits-all" policy that works *best* for all workloads.
>> Yes, you can make a general policy that works *well*, but if you really care
>> about a workload's performance and want to squeeze out the last 10-20% (or
>> more) of performance, you need to be able to (1) experiment and (2) take
>> advantage of application-level insights. Being able to extend reclaim (in
>> our case with eBPF) enables that.
>>
> 
> This just makes me think going all the way to reclaim_ext and re-writing
> MGLRU as an eBPF extension in an effort to simplify the code/maintenance
> and keep what works working is the least-worst option.

That may very well be true, at least on the policy side. In fact, we
implemented an MGLRU policy in eBPF. The infrastructure side is a different
story, as Shakeel has pointed out.

> But this is a naive take, i'm sure making that interface stable would be
> even worse than just maintaining both LRU/MGLRU.

Putting eBPF aside for a second, I'm of the opinion that separating reclaim
policy from infrastructure and creating such an interface would actually be
beneficial for maintenance long-term. There's no clean separation between
policy and infrastructure right now, making the code less readable and
potentially affecting performance. I'm in the process of collecting some
instances of such overlap and assessing what their impact is.

Now, once you have such an interface... eBPF falls into place pretty
nicely...

Thanks,
Tal


