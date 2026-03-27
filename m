Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2247B10F2867
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 19:12:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E4306B008C; Fri, 27 Mar 2026 15:12:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BB6F6B0095; Fri, 27 Mar 2026 15:12:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AA5A6B0096; Fri, 27 Mar 2026 15:12:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 28FA36B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 15:12:23 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CA2B51A0ECC
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 19:12:22 +0000 (UTC)
X-FDA: 84592788924.30.1BD3B7C
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7BDCCA000E
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 19:12:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=pHEHuKoL;
	spf=pass (imf25.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774638740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wSs7LoklCS7ghay0+uBwQU5R4fTsrDEUffYAtAgQcNw=;
	b=uaxTgFepL2rk2VIEG5J+EucrX12GABm5rQuSV29JS8ucVf7Pls6lnaNqYzhSDAlDLo69Qw
	eWcdh/uQDMybDxiZTwpjoZlVGhgqJU0NVdKpgx+iB30nShSWvruEHm5RtToGaQlm9aEdGe
	tyl7PXXfcuE6miKhkQNhhVQYs/HpOQA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=pHEHuKoL;
	spf=pass (imf25.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774638740; a=rsa-sha256;
	cv=none;
	b=i8gjfbsRAt8maSuVA/k2Irwqe9aJBNMIDs6tXREPnbYE/JrTlZDUOQy1fFTWxU2ePOtOZ9
	7rcoe+3hrd9G4F1N018VzlcIQT9DNOuMR8USEpr1puNlq2y6m/fnv55oDxUXQYsMroEmjZ
	IoR4Oh+jvauT+bAz+RyYGHJjh+1vYeU=
Received: from pps.filterd (m0167076.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62RIjDkd3120964
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 15:12:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=wSs7
	LoklCS7ghay0+uBwQU5R4fTsrDEUffYAtAgQcNw=; b=pHEHuKoLkH6PQUV9Psn8
	ai+/QfIz7KPO+U0xJU0AKdKn8ABVeQ/Cw9Jv2uj6vQUGF/XPcdPFcFYYnWKm86wr
	tS154faYFIDct0CtBpvZdbmHKqclSYCdhG0vofPxB5TYiBXh1YZtMI0oPK4v9jBO
	HCSyU5k5OgoDQbEfkJo2A0B9/NKVeo4L4IXHOaZZKNSb6QnBXXjj2JH+oNXUeBEl
	N5BM7tSKcNX/zKIh642ErJKq3hgpe5rXLE19okB/F8qrk7crvTM60W9S5iO5HwEV
	iyqT6EgJj4B7ZVwMwJYNzqmBPPuX50qlrv+DJBKGksukh9879DO7a9IbhdlX43VO
	gQ==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4d5wgj175h-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 15:12:19 -0400 (EDT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8cfcebeb1f3so375344685a.0
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:12:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774638738; x=1775243538;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wSs7LoklCS7ghay0+uBwQU5R4fTsrDEUffYAtAgQcNw=;
        b=cHnE0sRMc86OPzVjk+/w9ECN1oTYTvDGQiGLyg6y4mIBXcnkpQHoC3+pkUdZnl0791
         /z6bV2YADrckoTMoWH057kLiy0d30xzf8cWKPiVVtDUKlyJV7FBHvGLOB0D39WCMijPg
         GQcD7g9jTloF4M+HjtTDZt9m7gHzvISi0VUtcBCvKVLlFqmzVMUsauK7MoYGeYaS01Rd
         k86ZKn2W5Cvoa/VPxdXbuhgPrr/EC9mwVk8Ub66LiA9CzUbRKCDK0OvNk2NAkR8Fkn8t
         LXLC3vWTB8ANFbUf224ttekcCp7yJ1MkOD5vr9jI9PG4dRC41V5mpy9rVuCxegqsIopu
         MhAg==
X-Forwarded-Encrypted: i=1; AJvYcCVjmkUHG0tbyNtP/ktrKWFcwhIdREOv+rxHgz77mLL+hqV7SqGSa6Mu16W/OkL+OVLMlbUDYoaE3w==@kvack.org
X-Gm-Message-State: AOJu0YzwVUnmMy3xbWipcpLNvUl9KhL1xGmKF4nuFqMB0wKC6dfDVpcP
	Kv2LVYSkyQ5IYgC7CZNH/iZP1Q8LaQfED9u9EWyM+H5nuAdrZefDcp1gI0CDg/gBswnHqRwqcRV
	vsREqiVobMNAGWYQp8mtWH+eTuGj24uqsM5Z02ZIRJokR45hI
X-Gm-Gg: ATEYQzyPasEvkxSAPs7plztV7SNNGeaT7gqMH55WZjTm40L84ECS12a+dqsrXhdS8tO
	WrWx6qfIcS/U1du79gWRRVbO4Y8cil5j7gqIZ+zI8aCKeMjxuO4toYg+Wle6IwXF6IZucvMS8HQ
	dAz8KxsJwvcu7s62AQP4xa+1mh9bpXbRUZ85WFakQDd6d0+IY0heS8FAwWYCawvUySnCVjVea0k
	L4cCm/OIKwWnlqpNsKSZ60FQRoQJRgv5gANcMSx0FNpN7rRWjVwrk+RDj9VqTdL0DN5vbwUVCmB
	H4JyUsmaD3iH19n0gb3FnUNH7a2j4XziUu/zf1NEp7wmq3T7brdIZX86fUZYGUyWEPtVJHwAdeo
	yNoH3Y6KAQolmt8ElJsiYaxOsehNIDlwdgbw=
X-Received: by 2002:a05:620a:1a0d:b0:8cf:f2ec:c52c with SMTP id af79cd13be357-8d01c5bdfc6mr513892685a.7.1774638738540;
        Fri, 27 Mar 2026 12:12:18 -0700 (PDT)
X-Received: by 2002:a05:620a:1a0d:b0:8cf:f2ec:c52c with SMTP id af79cd13be357-8d01c5bdfc6mr513885685a.7.1774638737754;
        Fri, 27 Mar 2026 12:12:17 -0700 (PDT)
Received: from [10.206.53.25] ([129.236.228.75])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8d00e52db60sm605598185a.46.2026.03.27.12.12.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Mar 2026 12:12:17 -0700 (PDT)
Message-ID: <6f40c513-af3e-45b6-9000-c61494a23bd3@columbia.edu>
Date: Fri, 27 Mar 2026 15:12:16 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Towards Unified and Extensible Memory Reclaim
 (reclaim_ext)
To: Matthew Wilcox <willy@infradead.org>,
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
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <acX8_XMQYA0-NGUW@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI3MDEzMyBTYWx0ZWRfX4O1ENmi+95H2
 hpl1fx3obCljW6CtsekpCI8qvG459YKMSpraWI/aQd4y8wn+Or+BClif8Gt76VhaCv4qRZdz9O4
 tDJEyF6Wjd8IAyMQkOFV5ypwLj7WksCVLqEGV29aVi7/4lyHMTd5Xmi6gPwL2kknq1PU/Mrm2LD
 TKoPGkPFoBFdqdFZey42YMB/FmvvgHGI5WkkuvlXgRUydvv63VUU9gQ9ptVkVgineIRDZ+xWD/q
 /ln90foxL9GTMcFFYVFVqdfJqQZej07DeJHO0Ra0jYSVXVbbOnxK0uplTB0SWoLnmfRYukmotpd
 hO+4DebTpcIMDOipI730tusX280YgvjW5tmFORIv19HbNV3OdCyeSwmfJxavlHDr40ocWDfHTNy
 trwE18NIiAO7ehtLbzJ/VMdmjLPxHmMaxdFFcT6MUfZWdmQ48wK3Iae2WsVPrlZ5XfDs0poLZ3d
 VandbCwHnCyyXB1DmNw==
X-Authority-Analysis: v=2.4 cv=A5th/qWG c=1 sm=1 tr=0 ts=69c6d693 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=i0E64eHTdvG+y2bc1TXZ9Q==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=Qm0qsxP7aFY2tkT6R2MF:22
 a=N54-gffFAAAA:8 a=tHa68p0SAAAA:8 a=bNtxNjT4IcQ00HAFgbQA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=bTQJ7kPSJx9SKPbeHEYW:22 a=ufIsyHvWW7FwcMbVRpPq:22
X-Proofpoint-ORIG-GUID: 3IVxaGhpiRvidfLbpaqBfmSTR8hGGltX
X-Proofpoint-GUID: 3IVxaGhpiRvidfLbpaqBfmSTR8hGGltX
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11742
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 spamscore=0 clxscore=1015 suspectscore=0
 lowpriorityscore=10 bulkscore=10 impostorscore=10 malwarescore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603270133
X-Rspam-User: 
X-Rspamd-Queue-Id: 7BDCCA000E
X-Stat-Signature: r1yapgxxzp9ah8h3nj9sscuigjk4ked9
X-Rspamd-Server: rspam06
X-HE-Tag: 1774638740-211187
X-HE-Meta: U2FsdGVkX1/10Wy/PwDp6AJ75eA8HpEPeWV/zKE9A+90wMHTpUm9pgiBs2QzVa49LDjlngkZZVYAYLN4s7nZqP3nD9NXGPq6YqHB5Be50xpIHncpgiMsLoMjGkzRQn4dhFaLy56s7p3hr5vefA17OQtyPHcnedteJd9UeROXkEvsYm8/qEHPGScEhYDR4xBYuzBSNDmQmug4bftRNAhKREDswi4zuXc8CcH2ce8lh2vOozfcpLfsds0/EWBuow5kFH76saPWSZTc4Ye9E/4Hn2mnwwYSX4toLlHYQjFcSIroBcT6zgRJe0uaPnC50yopgBat/WDbXs2UKa7n33MHy7cWSuy8B1YTGWyrCUYZvMis5TwpKrjFg/v+QiEK4kntSNpuJGhN3En18HXRAWE0fUAxl4Lvm2U8fMNufwMA5ZO6aqDpV4/gFcXqj//F932onwvUYBNRLi7gHgZmvvxL/U0x88Ty6Q097jtRiEGNEq5UlxbEMJUX3Eq4bV4Qp+qzZKJ285wjoYpKrAj3BcZL0oublwrladlJOWWaonLoGxW9qrZfX6is1RHiwxXBETgOb24lYXc1/3wFO/FjPEs+k4Pbkgkh3NSCV+JO4iz8hUFOGVHN7ezmT5j6ubrjGIBwVFoVsVqZJAInQ37Bg8LsmTiFZk4+cHH8tYyDpENT6XVGt2sXMvbG64IPAMZ8c3JUWaGSVcWnBRQYRtdboHTYLs+32jadPaGOv8ujmLcXbzoLy0y6dHbZsH34Ss5YdsvVXim3RgLbR6s62j9cLf7wht4Gp2IYNBkpigXWs42em8q8gCh8jnKr7385lTpuwhhLNpavMVzVycvZywPIzv1mKFCWed8ODqHnJoWam0BhpcSNsHOr7jqDTVhiZZaDqAQ3OQomdTpMf2VVFk/2gQkFLxb/j/8suOsNJNJnnGhxboGe/QAX71vG+RKmM0GQFsRP7M6RQAgDwDs2JoiWHl2
 yDHMs+se
 GJJkTXlQIwHL1STqSiF2/342Ouv0Wdk1lQfmnIAj62gKvF9YtbR2bkFUUqFrFIiBQ+bN2s7lqA1mpJGgKeUl7CL8fl8wWOpZTVunRCG+sTb2gEqGtJFz6q/xukgVRt8k+3hN9iXzD+DKk3cFlKj3cqxase066AIr0Xt78ZHQK9xgC4Ak=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/26/26 11:43 PM, Matthew Wilcox wrote:
> On Thu, Mar 26, 2026 at 01:47:43PM -0700, Axel Rasmussen wrote:
>> On Thu, Mar 26, 2026 at 1:30 PM Gregory Price <gourry@gourry.net> wrote:
>> >
>> > On Thu, Mar 26, 2026 at 01:02:02PM -0700, Axel Rasmussen wrote:
>> > >
>> > > I think one thing we all agree on at least is, long term, there isn't
>> > > really a good argument for having > 1 LRU implementation. E.g., we
>> > > don't believe there are just irreconcilable differences, where one
>> > > impl is better for some workloads, and another is better for others,
>> > > and there is no way the two can be converged.
>> > >
>> >
>> > I absolutely believe there are irreconcilable differences - but not in
>> > the sense that one is better or worse, but in the sense that features
>> > from one cannot work in the other.
>> 
>> Right, agreed. I mean a case where we have workloads A and B, such
>> that there does not exist an implementation that can serve both well.
>> If such workloads were "common" to me that would justify a reclaim_ops
>> / pluggable abstraction layer. My thesis is that they are "not
>> common", so I'm a bit skeptical the abstraction is worth it.
> 
> That isn't what Tal was telling me at Plumbers.  Adding him to cc so
> he can dispute you in his own words, rather than my clumsy paraphrasing
> of what he said.
> 

Yeah, unfortunately it's not so straightforward. As a simple illustrative
example, consider a file-search workload, where you search through a large
number of files over and over again (e.g., a poor kernel developer trying to
understand how the page cache works). This follows an MRU, rather than LRU,
pattern, and readahead doesn't help much, leading the active/inactive and
MGLRU policies to have similar performance (~40s runtime in a specific
benchmark we ran). In comparison, using cache_ext (our eBPF-based caching
framework), we can run an MRU policy and it goes down to 20s.

This is also true for more complex workloads, like an HTAP-like database
workload, where we have lots of small GET-like requests and a few large SCAN
requests. We find that the SCAN requests pollute the cache for both
policies, leading to eviction of the (small) GET data and degrading
performance. fadvise() doesn't help much, but using a custom policy that
separates the GET and SCAN data into two different queues can yield a 70%
throughput increase for GET requests. This was tested on Linux v6.6, so it's
possible that various MGLRU behaviors have been improved, but the underlying
structure remains.

It's been well-known in the academic realm for a while that there isn't
really a "one-size-fits-all" policy that works *best* for all workloads.
Yes, you can make a general policy that works *well*, but if you really care
about a workload's performance and want to squeeze out the last 10-20% (or
more) of performance, you need to be able to (1) experiment and (2) take
advantage of application-level insights. Being able to extend reclaim (in
our case with eBPF) enables that.

We wrote a paper about this that was published a few months ago [1]. Happy
to answer any questions and continue the discussion!

Thanks,
Tal

[1] https://dl.acm.org/doi/pdf/10.1145/3731569.3764820

