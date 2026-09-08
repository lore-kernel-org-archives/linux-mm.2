Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93015C79F9F
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 03:06:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B44486B0096; Mon,  7 Sep 2026 23:06:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF4B76B00C1; Mon,  7 Sep 2026 23:06:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0A926B00C2; Mon,  7 Sep 2026 23:06:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 868F76B0096
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 23:06:07 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 22383C0364
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:06:07 +0000 (UTC)
X-FDA: 85189105974.26.73A42DF
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf13.hostedemail.com (Postfix) with ESMTP id A68A220003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:06:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=tczGJAsk;
	spf=pass (imf13.hostedemail.com: domain of sourabhjain@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sourabhjain@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788836764;
	b=F8G5zh1XORZ19MmadYvjAPnC4k822baNm0D7ilQm2RsF7HshmC0qJJwCsjfRrcLt/7Gn37
	M1xR1haPIMV4Vkhr3YQ1TBSI9lSzsTrfDzX1u0floDsM0zhQkU9yaDnMCmqAOECPCS4ZAx
	wCH7w2PVGin7hc/jLiXceygmNqvzJqI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=tczGJAsk;
	spf=pass (imf13.hostedemail.com: domain of sourabhjain@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sourabhjain@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788836764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JI1gDaiGExfkFf7o12oBro86gar1gFBU0XgxjnWY3FE=;
	b=kRlYxXUR2C8nSt98mwMtANsLTxBZALDAXEpldHSq2zjD3Vf5Yje6GXAcGnxH746NfSSyE/
	okxgIfdeLM+j4A2vwNC0fxWZjGFPYLlT+f8FArkOJ8wBzwcxLdU3r4oJZTsDdWzQaeigkb
	0NIR500gas1SY9M2GV2Jdf0mf9+TFBs=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68801pt63372633;
	Tue, 8 Sep 2026 03:05:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=JI1gDa
	iGExfkFf7o12oBro86gar1gFBU0XgxjnWY3FE=; b=tczGJAskUn5OHyfNYj9711
	w3rh84Sz65UGBIwENufTX/4E4Jj28t6+Yi9+zSR+yldPAvk6sjRdL3BJip1UmM7Y
	zDDfqo094aU/rCaWDHvk/mDPdF4ytY8n+2wodLkVUaCzthVJEiGV4uJai9tJdqKB
	O70Sfsv7QAw45NMKqXqYvBklV2JDCnAhqNmtv/1GVU5x44+9ft+XJror/7uSIWTl
	0L6Txy8QqLHi8EU1jRlDPW9nfH7HtpbjkahFqZt1Lew43WzgS4Yl/cPW87f5W+2u
	OaWCMxWo/jzYawegUSw2TSQfAldcqCyPqHukDvtbzetu4a2TF+n5V/xFfXWwAGyQ
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ggbhkm4v2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 08 Sep 2026 03:05:58 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6882uDAI006500;
	Tue, 8 Sep 2026 03:05:57 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ggxdjs9bv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 08 Sep 2026 03:05:57 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68835tdS43057662
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 8 Sep 2026 03:05:55 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6456F20049;
	Tue,  8 Sep 2026 03:05:55 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6B68B20040;
	Tue,  8 Sep 2026 03:05:52 +0000 (GMT)
Received: from [9.123.14.142] (unknown [9.123.14.142])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  8 Sep 2026 03:05:52 +0000 (GMT)
Message-ID: <0e8d8903-069f-413d-b96c-5c8c501fb5cf@linux.ibm.com>
Date: Tue, 8 Sep 2026 08:35:51 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] liveupdate: kho: calculate per-node scratch sizes
 before allocation
To: George Guo <dongtai.guo@linux.dev>, Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
        Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>,
        changyuanl@google.com, akpm@linux-foundation.org,
        Huacai Chen <chenhuacai@kernel.org>, Kexin Liu <liukexin@kylinos.cn>,
        guodongtai@kylinos.cn, kexec@lists.infradead.org, linux-mm@kvack.org,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260904025101.9959-1-dongtai.guo@linux.dev>
 <ap3IFd2FVvfKkHkV@kernel.org> <20260907102414.18958-1-dongtai.guo@linux.dev>
Content-Language: en-US
From: Sourabh Jain <sourabhjain@linux.ibm.com>
In-Reply-To: <20260907102414.18958-1-dongtai.guo@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDAzMSBTYWx0ZWRfX8qhb1C1IzXnz
 PiQg8OpyvvK19tWxryma6GZPvHA7uePRzIcUnEjmAo1PirYBBKUJA7L/Eni32ft8eMaSipjP4it
 vl1qWUudZDYk4jnRx2RP+ayqlJMy0Sc=
X-Proofpoint-ORIG-GUID: L0d-Rs4RpZmoKJ_MI1mk07mjPeNv8GNW
X-Authority-Analysis: v=2.4 cv=NMDlPU6g c=1 sm=1 tr=0 ts=6a9f7b97 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8
 a=gLbRH2pEsQEO1hv6ekEA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDAzMSBTYWx0ZWRfX81vxZP+gH7sU
 B552ica4WgKl4/n31BNLO4r/I8rZ3hhu2zvYSN5f5/AWGBJGTnvbzn0cgqJ9KzCcO0lWxplCbtn
 kdaQD4j1zlJ2KKB7CdcQnUv2AeQLkqZide2n5plIoh7QrSt/PZxTwIbil5wKF+grAk8ALKuLBhr
 huES++m+OQmzUzqG/6MwBz8ZMMwqP67Zrf7WOhPcBzjWHHV2xmqB+QB85OQyDhEaHH9LVScmHcA
 P27nQ7PM6NZpoZ+/p3m1QOYMbOrV0rpENDavcS/4ic0gLOfT6J1Ii9usiUjnn5xoYg4y+5bTub7
 hRuBBKP5th1PS1C+0lcA7vJcF2Aik9XujxduKRNjtdn/fh+Wd331a+vPy983ZATiUy442K41RYT
 kD5R0CJh19vy+G85kPx1sE4ia/bGka/Z0Ti3YUQfKyVrsGRgebXv2I6Y3KT11Xgc89oomUu7j+u
 f5O7kNXZFp9Kw3OY1Vg==
X-Proofpoint-GUID: I9LhQLXtjZsXJNKbCckjExOK-cgk-eyn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_07,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 spamscore=0 lowpriorityscore=0 clxscore=1011 adultscore=0
 impostorscore=0 bulkscore=0 malwarescore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609080031
X-Rspam-User: 
X-Stat-Signature: 3466kzdcguzt6yaqj1t79s1zw3nf6j1o
X-Rspamd-Queue-Id: A68A220003
X-Rspamd-Server: rspam06
X-HE-Tag: 1788836764-559119
X-HE-Meta: U2FsdGVkX1/lf1pIDFwOXI3LfQt5LYN8EuMdf1BlFOgwvMgbKIJ7VesG/noG7v6K1ahcIC2S09SofLypFtWXcoeWVuJsDincWOHjXT22gHMcNMSlhFDEGvA355/HEWle82N953AumSlW3AfbnTin7gpR0IyImi0d/9OwRB9jDb80E2NhpkDQO9HU3vs/54n5aBS4zWjePklUQrr0TII+6uEy5eBxBdB4GYbtc03IPC09T2+xCdaJ6Bd5SXeWR/rwiSe7fZSQUs/iem6eheFr1USPTRo2L5XqRA+jDHcj+lzAsxqKuxHsow19RrkizvUvVMZ5Tkt1ZIk2LmljlMHTG5kQQ9u0tOY8S9nB8s51KyDHAto7BwIfibIzajw1FISg6RbXxLrGazNz4zwSiaxoK3zt5H3GRV9fqh0S/0XoNAKVgJBNkKmDQpWK0Gg5lrYBDdmp6zwsk/m+1sV7QOEc0BQEaiF8tG5h7S06rnETtTWVhnwkgQGpmxH3EDEubkpICsg5S8tGkyZYrnhQfouSexCd61mwq+cQKgVy25aMLGhW+SYKc8TwlpYDxmu1BuYzVtTioPVG/BuIrAg/vvSWfM2hhiq4+jql9ZWAECc1EHAXU6Z99PLncDSFzMH95Rxo5J3k1fMrsN2ouo772UkkRUTsBMHXrklnrpoam9qDZrqa/ozbBFdD2QsB9fgxip5X92NwYsddeCucqAlIuqxrkzEp2g8F7gZyJxkduZcs3nHadtz8hVxIU06G+qtcS7Lj0YFpgT9APVnOa3EV5VZCScSUBJQEZcqm99K11d9QwIkD690pNZv3CXjrOsCk8EwFqjDbJ8wdp8Qa5WWHWPxg4LbWPLV/d23/XUmkC0zlRT5ymTwmbCr0hf+t2Z8EbuqOjtGLgExgTzdNdCP4gTt2QgjtKCAPYlpbeWdE/clfW3HOQYYFlUnBgEh0G0SqjM1ZRiwUpCwnQLiog/0ML4z
 BQdpBVTo
 XBaoVU92LFU9T1eUDhtexrd4SKIUvzAzfqlEm5lPcSfamlcH+0Z8bAwwxLNRP7xMGJ32wU9g7VIOhOI8AVquyEGsKgC7Og4Zv8mL6a/LcDq/OKJsg2P0aDh9ITa7SEHQhhz04wMYwXRS3VFPA4KWE6W63eOdNKmEiW4qheDRvUjtmbHsym1kE6G8PcqEBbk1KuUrsphJzRyWdSlS9eGkAVkUKtxe/bsmRLQfUr6l8G14o0Dw4YUCwEa1dn226nlUgMlz7aefmXelu4/fybkDuinz0Sw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 07/09/26 15:54, George Guo wrote:
> Hi Mike,
>
>> This reads as LLM-generated text. Please add LLM attribution as per
>>
>> https://docs.kernel.org/process/coding-assistants.html#attribution
> I'll add the Assisted-by tag.
>
>> Can't we just calculated all the sizes first and than do the allocations?
> Yes, I'll rework this to calculate all scratch sizes together before
> allocating the scratch areas.
>
> Adding Sourabh to Cc, since this relates to the scratch-sizing discussion
> in the PowerPC KHO thread.
>
> Sourabh, this patch prevents newly allocated scratch areas from being
> counted in the per-node baseline. It does not address the overlap between
> global and per-node accounting. Could you review this approach as well?

Sure I will review your patch.

- Sourabh Jain


