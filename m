Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C7CFF9D0F6
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 20:35:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2CC46B0088; Tue, 14 Apr 2026 16:35:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DDF66B0089; Tue, 14 Apr 2026 16:35:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A5E56B0092; Tue, 14 Apr 2026 16:35:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 791576B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 16:35:26 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0EB7E16020D
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 20:35:26 +0000 (UTC)
X-FDA: 84658316652.18.74B441D
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8FE62120010
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 20:35:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=lRFBKYLM;
	spf=pass (imf29.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776198923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nLeTRRGmHX5BMpVtP+w58//ItyrkZ9dOA8UVe6ev+tk=;
	b=XYUE9admlNgo9fv9981l3DQMSzS64X+7BnnAXWiDvmDBkxj8CHPHLZMRt67T2KNhKQuSmM
	By6DIHoTaltz88SDuYaXpUez6dPqPaBKETTmhIDXxNBNqcPLYLG4q9uyTgik7Lnd9MAWVF
	fjq2w9WccCbIWNH/TRVilP7KXdu70DI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=lRFBKYLM;
	spf=pass (imf29.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776198923; a=rsa-sha256;
	cv=none;
	b=kTkY+TFt7Fo4fA9nF5Z06Qm3dZp0uHDyaGJTC8ZlwXqexvv5hY2vRCJlgSoVIOFj5UV+3S
	RSPFOBSNhIGixW+WV7z+G6PBPJtlluAKKMwpRvAyv54LeuoAP3rkOBt4AfUYguX2CWi3Ts
	wnV+PPqdRXdE0d2zWaa9zWdafgk3+NA=
Received: from pps.filterd (m0167073.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63EKRIDW4037642
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 16:35:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=nLeT
	RRGmHX5BMpVtP+w58//ItyrkZ9dOA8UVe6ev+tk=; b=lRFBKYLMi6M71+q2z04O
	PrgzuYcimOMwgpRqxfzegjL42voJYBu14rD6eghtLednwYVfY1arPN4h3/UUYcWg
	fpyO5gUQMknmKcePDV1qnAgnCGWC1S5BibH7IfdGD176gCMdNha0TKOaqDUMVz50
	6wNzTXwqXBaDcuOnVSQ/Uewn/tKDOMEq0g4RFr+0og+ZRoB3rwUx0zgVtXbSViRW
	JKoq3v5fZzippF3MJoFOvOIH0bdxJ1Ber868W0eEEnugnBkaxL5dZgOYHlU+G+z+
	cY521DDO7UJSxS4hBRY6MxiT6sxRO/2Mb5uQsJLhIxVSXJ+IrvOBMiGFsKLDa0vk
	4Q==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4dh85w0e3m-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 16:35:22 -0400 (EDT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8d3a8df9a52so1222668885a.1
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 13:35:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776198922; x=1776803722;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nLeTRRGmHX5BMpVtP+w58//ItyrkZ9dOA8UVe6ev+tk=;
        b=Q0cAhJUib3MJQ6/R3J0pc28c9pGDajuJCMgACf39R6/dSU851akUS0uZ7yBePp38vS
         TzpipY9A6h40/0DVC924N64l+Jcd6e5ZamFwqQNlqKqUXpdVdaHoYqHjp3i5AhR41sd7
         3/FPCGI15i+ODc/Mcey7hL4I1WrwcyaMVcvT8m02zeeVzpI/fNBOenGi77cPyX/amsZS
         g8JD0nhNm/5udSoYAz2CvwJxmbo2DqvLtvwqEOCRwka3vpqcLJQxDY1vej+tbSrUqIoe
         UqeBZmEa/zh2kVqigXxJVkZx8FizVT4vlVjuhJNrvJhVJAL9iS2inKJNLoiqGpe70vSg
         WfsQ==
X-Forwarded-Encrypted: i=1; AFNElJ9HeOCcVBRaK4fVcDspTJMHE7pB436pbxk37D2teU52FJh+qPolqBCNMHYJZcG50mwmGOhVFb21KA==@kvack.org
X-Gm-Message-State: AOJu0YzyZdgjrHg7P/LzVZRIa/FYyaoG7Wy82IfbD+xKRTkagpNbo2Ks
	tLV3u82W9s33D3zCKkPxVhBeMWS7MEkOTuXytfEqPHy1Pj5wq3eTMSXT4+dcjs9AQqGftsMIBiQ
	08fu/uBW/796wkLQIIqBUKrvgNOace0oov6/xKXMCf5BPWav6
X-Gm-Gg: AeBDieucdpl4vttOOABwF6k8e1e/glXWsNmCRVR3pfHQ1mp4ayY3oN47sBbrUx6dqNH
	vfA4fQTE2YgPe6i+8N31qra662e3nQ6MHOUky6MTmlgRuufpNZwgzQNO1+OIxBlbt2E0dsZUCTG
	aKKZlbFqh9lDOF462exi7ou+oYk+BPnIsaMI5/ynVaSO3GGVxVo/9d26IgGw8hRzIv5nUTtbMMX
	nwgjCEvBhkTHMfXHrY99pv9ooPFJQ2ZKCsV5E7qp8JX3M5TpGSSqrOvzmlwsYMw2S0qnVf07sQo
	Ik6WZ+ud64KNt0uqtZVusGbH+ouJr4tIOs9T2sRPGGPKIDi6ZSGECPWLXsBqD1WaSFvwbHzsffP
	0mRgkyE1wQ4sEdpbFlZlhFNY+LgvaT9vbggWCzRTozpk6ipc9Ik0NvSURHyNAzL8OchyiAD8=
X-Received: by 2002:a05:620a:468e:b0:8d8:2a0:e17a with SMTP id af79cd13be357-8ddcfcb2d46mr2770768885a.50.1776198921803;
        Tue, 14 Apr 2026 13:35:21 -0700 (PDT)
X-Received: by 2002:a05:620a:468e:b0:8d8:2a0:e17a with SMTP id af79cd13be357-8ddcfcb2d46mr2770761585a.50.1776198921305;
        Tue, 14 Apr 2026 13:35:21 -0700 (PDT)
Received: from [192.168.1.62] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8ddb915b46bsm1196176385a.33.2026.04.14.13.35.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2026 13:35:20 -0700 (PDT)
Message-ID: <7dc54b9c-ba2b-4044-8cb7-b95ce89f1e09@columbia.edu>
Date: Tue, 14 Apr 2026 16:35:19 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Towards Unified and Extensible Memory Reclaim
 (reclaim_ext)
To: John Hubbard <jhubbard@nvidia.com>, Matthew Wilcox <willy@infradead.org>,
        Axel Rasmussen <axelrasmussen@google.com>
Cc: Gregory Price <gourry@gourry.net>,
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
 <70fd648a-efa1-465a-8e6a-51411dfd50b8@nvidia.com>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <70fd648a-efa1-465a-8e6a-51411dfd50b8@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE0MDE5MiBTYWx0ZWRfX+Jrql8mCUZjJ
 ogl92IcaFssk/KhP+0z1sPMv1Q0kP8PVuBDaQtqIGB2BfTv41A4sByXoPTy5f8u8+Dkpc6wuqDS
 GHBY8rddazJP1RXdXrGbf+jP8br4en073e0OhEW31HrsYyCG6KBHPi8VSy1Sglo8Ko+PXqgGZ3O
 A6gP/+nxjywDHMzJ8AnPk9UWOa+gVcVm06u3LmuA2AhAf8QBMIqgROvh7u4UTK+7+Xy+wiVZ6MG
 iEdLVbC0/X5KFcjDUXKRwPV7efaGebpA/IavCnubos63x4Z2FKoxUYzvTD1QxKO6b3PnZztJe8W
 /ff6LAe7gjUJrUsjuJY8JkpDHM0Hzzuxe155khMOcg44oIetwL+PlsldnF8S2jN/bTUrqXTdVZv
 WQNyqdDLnb3kmeEGr6tVSycmFR6UZIVTpq0hmx//vAjqvry2hzxlnONqbPRmFSIYkzCNJOwJTtR
 O2+IudfbdOO4XTNVYfw==
X-Authority-Analysis: v=2.4 cv=aquCzyZV c=1 sm=1 tr=0 ts=69dea50a cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=jHxIr1HyPKZ_Q5_91PL3:22
 a=N54-gffFAAAA:8 a=tHa68p0SAAAA:8 a=zHSXLxmVE_XwShEkr-4A:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=PEH46H7Ffwr30OY-TuGO:22 a=ufIsyHvWW7FwcMbVRpPq:22
X-Proofpoint-ORIG-GUID: EGhlDoX-HqFvhJXzV1DSG5fJeundAkcn
X-Proofpoint-GUID: EGhlDoX-HqFvhJXzV1DSG5fJeundAkcn
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11759
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=10 bulkscore=10 phishscore=0 adultscore=0
 lowpriorityscore=10 suspectscore=0 priorityscore=1501 spamscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604070000
 definitions=main-2604140192
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8FE62120010
X-Stat-Signature: 49ifdwt8ecxxo1tj5zsexrtehgtwb4d1
X-Rspam-User: 
X-HE-Tag: 1776198923-416661
X-HE-Meta: U2FsdGVkX1/sHkTmywbfURcELYy2WCTddW+OlSx3u93LiNgoKgAfEmS2ux625FJQTFXKqluYZMS1ZGEsUBQaGcu81VVvZsZM1V3x7OCP1LS1qfoJ75e2mBybP+nyie3zV5tmjeZEZvTWbKHUt0y+50cW63eI5iEl3H1VzBQckcmNHtcfIqncqf0hs2GO0X3rWiYL1SA84OGXj6hu+htYEy6dB0Vg7XNRIsfPniJW+jzJcqzmSzqoASJcdR9wMfY+7tgomuubPC4VDMtsEWb9nr8dRb0HmWXLfCUdpSQv4WzExOHlx1yjVxngQYA1WBdiPIqj0cfnQFlY86j1sCXYzSkotOXOu4kkYk90I4eKwNcGJ5j7VBb1HGmmaCFqXL1yOnW0jMc1E/Nlm7ZoWsmdcj4H3v9QLMJhQC8IbWc0d1nofVlk4oXfQ9CShBSWUgGKm38sF85x7Jm4xwtLGevTdnYdGwlItPhaOwZcXzSKihp9Uvj0BW9IRX2Br9zPPVs0SpO2slzrQI3IDb0fGuB4edqv2XPCjxuibHZUGEBkydmDIN1GJGOCoyBM7c02q3nKzjBODqEOEOdxyRQnogUxTaMWV3BUSmJoa4I06K0rQ9EFpxHQ6bgTcw0pQyulnb1POt6y85N+J2TLGyksiYA6Kbl+e+NFX4TCmtqGWrd0i708ImMMkidJIavLdmh/7SE1RAvSD/4Pw3HnmHeGekD8zoZ9fpzwRYmCwkhsUTvdHllox/u867mAzl1bCefL2FDKjXxy3jbehv9JJcQHQffU9+Lk2d5NIBJOk7LDnFzsE13QWaFIWtNBw0v0DArLDIuhMM2NuUcdixbNrpVc9AGOWzBbHRo9JLVEoz0adgNhGgjp4rLVMgMvcxObZJQKcp7AuGrnsBgLnVXnlGb0L5xMkmjtQSU7tiQ+hf6gxN/X5bwocQU1tWuN5VX4zvl9acTYeSzMTuMeMHSmU+o4JD8
 98yHZQsK
 pKNRTPIcjAK1Ye9BkSDubfkF2Gp5BJOIu8s/0KJi959BvPaPy172RDLxQzs1DsBLs6ntqjs35LXBi+9bLqSgfAZaiBZP4QHeMQpbNLh3INfafE5+jy5STAo2jy8cT8s54pIlZcdnwSa3yIeeTugwRdA/7hziIyuU7GG2GcHV7dm86iO/P4rMt1kWPDtWG1mMPSmQttcyDNEkzV6K++kr6vSdvBK78RzZse/KXAkJ+0mNnynWEUT70/dVQdBR4Pu2k5Muf3Xy4ipIafE00SYRoZVNTZQVbJA4bdhguWDP8PoWS6xUjnTA5nlUd6f0zjVoG7fpqKN4jU6jymKWFZtLYHBRv+9RlmqV9YvzCIgQao9sDOGfKV/gOD9sdRCXuGXzfTGD3JeYgI/o15ZuDSnV5KJr1S6mFvkYBKSSZj3xfsXfQOSnhvp4VdR3XK27XYlzReoY1lwRD9GwG20QxhEN0RHxCErYcRV8vD+w9P1sR7gmLhuqeLNa9FP6PjFsp1VQFmouOSDxqRwMsLT3kHGyhJsLmArO5JtTQWTK+PBu0P0rEdKH6Wg4WqHWQmui3icIsYaQYAX2w4PWV+z7q14PZNYFU+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/8/26 8:21 PM, John Hubbard wrote:
> On 3/27/26 12:12 PM, Tal Zussman wrote:
>> On 3/26/26 11:43 PM, Matthew Wilcox wrote:
>>> On Thu, Mar 26, 2026 at 01:47:43PM -0700, Axel Rasmussen wrote:
>>>> On Thu, Mar 26, 2026 at 1:30 PM Gregory Price <gourry@gourry.net> wrote:
> ...
>> Yeah, unfortunately it's not so straightforward. As a simple illustrative
>> example, consider a file-search workload, where you search through a large
>> number of files over and over again (e.g., a poor kernel developer trying to
>> understand how the page cache works). This follows an MRU, rather than LRU,
>> pattern, and readahead doesn't help much, leading the active/inactive and
>> MGLRU policies to have similar performance (~40s runtime in a specific
>> benchmark we ran). In comparison, using cache_ext (our eBPF-based caching
>> framework), we can run an MRU policy and it goes down to 20s.
> 
> That's dramatic!
> 
> ...
>> It's been well-known in the academic realm for a while that there isn't
>> really a "one-size-fits-all" policy that works *best* for all workloads.
> 
> I think that that point has been less clear, outside of academia. In fact,
> MGRLU (to the extent that we believed we would eventually get rid of LRU,
> in favor of MGLRU) doubled down on the idea of one size fits all. So this
> is interesting.
> 
>> Yes, you can make a general policy that works *well*, but if you really care
>> about a workload's performance and want to squeeze out the last 10-20% (or
>> more) of performance, you need to be able to (1) experiment and (2) take
>> advantage of application-level insights. Being able to extend reclaim (in
>> our case with eBPF) enables that.
>> 
>> We wrote a paper about this that was published a few months ago [1]. Happy
>> to answer any questions and continue the discussion!
>> 
>> [1] https://dl.acm.org/doi/pdf/10.1145/3731569.3764820
>> 
> 
> Excellent work, I was delighted to find a well-balanced description of
> both older and more recent history of the Linux page cache there.
> 
> It's helpful to read this, even if we go with a non-eBPF approach.
> 

That's great to hear, thank you!

> 
> thanks,
> -- 
> John Hubbard
> 


