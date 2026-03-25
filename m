Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF873106B534
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 21:15:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D8906B008A; Wed, 25 Mar 2026 17:15:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 189EA6B008C; Wed, 25 Mar 2026 17:15:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0791F6B0092; Wed, 25 Mar 2026 17:15:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E4B026B008A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 17:15:43 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 918B21A0AE5
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 21:15:43 +0000 (UTC)
X-FDA: 84585842166.03.94BF6E6
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf21.hostedemail.com (Postfix) with ESMTP id 51F1B1C0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 21:15:41 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=MBcQ1lW5;
	spf=pass (imf21.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=MBcQ1lW5;
	spf=pass (imf21.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774473341; a=rsa-sha256;
	cv=none;
	b=SpFtPUJAGdPOxx16iFmXxWZJIAo91d468jlN7PdBxpj5aD2IoTEUnMfAT4yJVAglp+06W2
	EIaxhzOkVFMQeL68F7TIG9QVGR6kE1Vn6ogvM4Yzr/DUqa3RpVzjl0sM8UKFrzvK7lCTIC
	/gpCGnMsZu7pzUcUC7uJPqzm7nEC070=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774473341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=zLtBhFz0tdAolnQY96/OAWUhS/Hnuk9T/3HN0+aXwAw=;
	b=5VYbdzSW/9bk3qfvTeDCUioSfp9jZUB75UJ5iH2BzYZ3A72hU2rZRvkxFDrEXTKq64uDJQ
	Pwr533QlfMZh1HhJ9kpOLxs2OmZyyRdIPessAWgpMbFNU4bUkdb00oitInfe7YaLk1iRat
	+yw1xSMBabEUSHVVzEMLzaHWYfnezws=
Received: from pps.filterd (m0167073.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62PKkXVP1628271
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 17:15:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=zLtBhFz0tdAolnQY96/OAWUhS/
	Hnuk9T/3HN0+aXwAw=; b=MBcQ1lW5ktV0V3ftxYgPOMu8E4zJtlRnAtgS5YcJ2f
	nvVZ7bbfl9TNgbJw4spKguFBqSujds/jwmtsvUm4Pv2p9XPO8sUu1noNx1NpCNlo
	cRICfQx21CbbbVDH9kKZnpHkSaOGeDkW8USydSm6heuZc3Isd3YmDq9J5Uu5TPkF
	3C0hxh4RKLLZC3SvCNEHS9S2+8vjZHZ4UdQBr1/FwLI52X+xlpLEG7Qv/HMfmcxf
	o520kLJFATpq+jWhnu0KUG83rEhx2tzhMdOvU2zKTlwMJwnA3wMBNNQwcsws5dbv
	8Je6cQwo9wp+H5TtcQyA41BfJ06quDPJWXg+uYluoZ5Q==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4d3wxhttgf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 17:15:39 -0400 (EDT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-5090e08dcfcso8337051cf.0
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:15:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774473339; x=1775078139;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zLtBhFz0tdAolnQY96/OAWUhS/Hnuk9T/3HN0+aXwAw=;
        b=QPMg5iGHFGKZeCkC+isi6EUil0YrYF9LQdJQBIwcmYnBYw2iKMI/4DFFwgTSZk8sCt
         Bys7rcEFf/lElRiRL9cvKBnBm3Z8ZX6AWkUenT4On/RHpPiRsPPQri5oYjz5FZaB68nm
         uFiKhAwFwIaqJ51pOYoxRYeHNESz2qhuL3ofIJRwsebzA88+fF3dxBkGYcPh+5HQkuXt
         IdbneNDn0iQvYKRHh9ZPzFnGe9YKet9BbvhvXsospDfgATfSXnIm1fe5BhaBmqCvRgoD
         f1chULlbYK2nVETfNjlYbSppdgAx/kCGCHwZAWm8e/xST5sUK5bAAGgdEq7RMC+V6mVK
         zTPA==
X-Gm-Message-State: AOJu0YwbqDUGoNTKscSHrg9WdBwWnJrwYdukvIMDs4jlxJ1isaQ2AUVQ
	eHTmejMYwUucImi+VxJLNrzkcwh7XeSu/YAx3XZAhUD1dRcbvJjgjcYVD7UsP/sVj4X5y3l5xVR
	/s79w/gGHIOHXsa9nrNKoTONHe9Or4dABsZiyPQPu5r5sPtdO
X-Gm-Gg: ATEYQzzWEgjCybXysFUGY7yuDaGleiw1Wd3qg1Of3AeV/AdcXjZ4WCFbOXOzm+wrHDY
	ZsWn+zAaT+vtYwwHRMRmZpnpWIwbHu1fKDCsViYFcXZKi+jLBFCNpErs5qA2NWQl/VopB9I4b6u
	G0cV+zuwUkFcYIPPjBcyv35ZjtEuH0opi3R4riVuyObHhxf7zhCvJUU6VHkyxPKu8hB0UDzwzZs
	WYcU/mBBnbK5xh4sxBB/AMYL1WpP8roKfq343b9CRlhkgrHk1HEsqqjnJPdzUqU8izewTpDp5A+
	zz15DSIIw0dZafrCwR1Ygo5SAOc68VwDvkKt5Gf1ARPKbIVL5vVXjowuuKGyboyIb4b9EUcZneW
	yDUA5hCgUQuM9LmA9Mx1e6S9aYST3OaIEgugKZCqm3rXc
X-Received: by 2002:a05:622a:2294:b0:50b:1e21:174f with SMTP id d75a77b69052e-50b80aff737mr78589321cf.0.1774473339039;
        Wed, 25 Mar 2026 14:15:39 -0700 (PDT)
X-Received: by 2002:a05:622a:2294:b0:50b:1e21:174f with SMTP id d75a77b69052e-50b80aff737mr78588551cf.0.1774473338313;
        Wed, 25 Mar 2026 14:15:38 -0700 (PDT)
Received: from [10.206.160.184] ([129.236.226.199])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50b92136161sm7879901cf.7.2026.03.25.14.15.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Mar 2026 14:15:37 -0700 (PDT)
Message-ID: <0b1293ca-7a1f-4358-bc20-15784452238d@columbia.edu>
Date: Wed, 25 Mar 2026 17:15:37 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: lsf-pc@lists.linux-foundation.org
Cc: linux-mm@kvack.org, bpf@vger.kernel.org,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Emil Tsalapatis
 <emil@etsalapatis.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Josh Don <joshdon@google.com>, Greg Thelen <gthelen@google.com>,
        david@kernel.org
From: Tal Zussman <tz2294@columbia.edu>
Subject: [LSF/MM/BPF TOPIC] Upstreaming cache_ext: Custom Page Cache Eviction
 with eBPF
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI1MDE1NiBTYWx0ZWRfX+sWl7uiT8+5T
 j2Km84GxWb8muI6c4lbgRNVhntNAIaHcbmmITZTDCOBk4T3TonFVb+Hu3kBff0A8hoVaN5TB56D
 CGuYQvOjVpUff1/ZqeU2RQDBuRVBoXIq1bZyBz0JLCtrFYBy9qAhcIeY7lzoJgasAlmNK3HtrB6
 fekQtnr2hl/x0bSk7TaTU3aDuH0d9tyu/mQ0MInBRFccCmJ1NiW8u2IHzn0Yh8cImjfaze64Vrc
 tPV6ihVCD2EsYzIkSsy0isecfTY4XdOZN8x7kfPVIizMpa4bqOiiZV5nnkllx3/Z0hqFJeRNfo3
 GJnqxM41ParZhiE70+BvZKW9PsGv+S4dIcdqWfbP4dvbOnnOG2tElQf/cVcJweU3sQ4Rp3Aa4uA
 OXYWCQiFgkwfUhaRIaVvBEloBbOs+D9Goj9lZN1yXgL/Eh3opMhouvDxK5U2fWtZbRDLplCrtLY
 7QYktl0RS6HWRw4x8fQ==
X-Proofpoint-GUID: vBRVbm4QyVBf0jDYhG3JiaCspwcgjIn4
X-Authority-Analysis: v=2.4 cv=V7NwEOni c=1 sm=1 tr=0 ts=69c4507b cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=QOUmeeuX5y9IvSxXHa6D2A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=jHxIr1HyPKZ_Q5_91PL3:22
 a=UVq9kkz1AAAA:8 a=OGjWj8McAAAA:8 a=NEAV23lmAAAA:8 a=VwQbUJbxAAAA:8
 a=H0umD5oqAAAA:8 a=ZOhZhaf62XQlCQ4KXVUA:9 a=QEXdDO2ut3YA:10
 a=dawVfQjAaf238kedN5IG:22 a=UYjydHh6ynBBc6_pBLvz:22 a=du2hvLAJtKcNxoDMbUSS:22
X-Proofpoint-ORIG-GUID: vBRVbm4QyVBf0jDYhG3JiaCspwcgjIn4
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11740
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 phishscore=0 impostorscore=10 adultscore=0
 bulkscore=10 spamscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603250156
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 51F1B1C0005
X-Stat-Signature: pye5n6d33yhd6d6uktcbos5wjuj9emip
X-Rspam-User: 
X-HE-Tag: 1774473341-314672
X-HE-Meta: U2FsdGVkX18bEqx9XCefo2D7q1v2gUfYeu9CJJOJ3UDvi/8ih2bOzBPelt3e2HrfJesRDLej1ItwZArv5v0qkdD80YDleUPZKnlQS/fq5MmNuaMtmZETixHqI8qLAisVFf/RSf899LPFykxJqXQKsNfNXHAF8zQFQEW44q0Ez3Cw0WkjA/Sk146p6+SxChXhkM7gOqRm9HATkWecXjX1jbCCP78MdTD7LV/rPEvw4XBCdZuzoWk2XFjdQ4Cb4DB11oW+MM1mDnOKMtAJOKccW8zUJ33DdcXgfVftfc2FIH5TAB4FJ1GwEX0I2qYeGEl40TO9bd14DIPzbaFc7nMl3eun0rymkEw0qn33I8UkJ3QtwQD5bjagoH4sW2tpjg0IeQoqNNsMkzUR6Uxkb2jjyGBvEAKiQuS2IS8cQhvbo24Loi53Ys6yfb95/yWvqyy4WkDpZwG/X7hmtPt5J5lwk3S+r0yianDNjSYa1JkQwFx51VIAMxwIAy+MhoVIVQFPzmv8t5dFIK4z/tJZME+AAPqv6d8Nj7mM3NvIBfrEh6bzye0ncsb/gL8OwAdx/P3hTyvcAGNpZ2PSkSFTFhs7UG846JJX/bejsM53bVlXkITnd5CXvA2lxcTb4EUq8y0KOICT19o1l1ezrXaoH76xetP/WzPXF4NoE38DxMs7QX8e9xIkVJP2TX4oaSWERtD/5mASgCknPUAg8+byTAUviUVyjXpoXGUWSA11EuGLqkj6Baps6xhXjPGyeV9ilGmf0kL+dS5ctWowZC9+z3NnSFrIlkHLkTUznVv7GzeiVpISvLraX7IEd0UL62CN+ttKDIbMnr1/ZsPSq37gtquA4diFhlLPPD9mwpEmz6NrxdtAgehpfoB6yLmI8FGWkDSqbZJ3VGeeNJzibth3bOZDdolV3jFcOZYHSYsDBGVmyiecbgbzacubNLpkVIGAfUJwrXFhgSR1spCz93ys1z6
 JO5C31BE
 tZ1KuDQEc9ZFQf5rFzfjhVrihum3KdBVgymkKZWxoEZ84ZGJ7Xkov9A1clJwLedoW99C9acGAnl/qZbuuQNhA8GDy+6z4ns0KyRxLENk6GsLqe85IXXfKvjABIoyCHTHBVxVJ8QAqOfiXW/Pv/Ih1+/3i+ly2ZsJh05NYQ7VoUZd7THK7ZnYa16La7PbA/VIjHVn1c1EUCXQcef5yj3VRwuXzbBC32t0DDpOlcQ/YUtWr0rIZmgDnHvp4PTht4irM6Uhpl/mK0lOpyP42GkZCIrKb+Yn+ueaA75w1qbMO3QfoL0V+GWLRMssCGe+k4nv6vlLA7ZByHz9wetuBvKuiydCIYHgItkEeWpdTtv3iN+yYiUAILn8a74flw7Q9hW1E9ukzukrt354lI13USYPMz2Ck2bNBNw3TPROslz5c2GS2KvcH54DbJ7eCGKj57SL9le5akENy0P4jBgomEMEKc7yA1UZN0q/sd05TRNh2IFfVQKEqtQeqlPMJnlZPbykJUUuAHapBYsI+Nil4gmAQ9P/fGDJW8fPoDPCSn6pYDF/G6Kza2MHwv9EG7cmvB41TLpZheBx7SGYIJV1YHhFrynbDbydZIa4Iriaw8AT9mDrcmcqXiODwrLdIRTjJnRU1u7AQmMYFlrIpoFpQPizqW/5wfcCTzQxrY1wvQK2VbdCSEO6UgtrQZw1VnLcHQ9/IujVsZD/gM8RCwcgwNA58plcci11MnExPpc52rjeSXMQOG7c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

This proposal is late, but I've been encouraged by a few people to submit
it, so hopefully it's not *too* late...

I would like to propose a session to discuss cache_ext, a framework that
allows applications to customize page cache eviction policies using eBPF.
This work was published at SOSP'25 [1] and presented at LPC in the eBPF
track [2]. The preliminary code is available at [3].

This topic spans both MM and BPF, so it might fit best as part of the joint
BPF+MM session that Roman and Shakeel have mentioned [4].

Background
----------

The kernel offers two built-in page cache eviction options: Active/Inactive
LRU and MGLRU. Neither is optimal for all workloads, and the existing
customization interfaces (fadvise, madvise, sysctl) are limited and often do
not behave as expected. Applications that need better caching behavior today
are stuck either living with the default policy or implementing their own
userspace caches, which are hard to share across processes and often still
rely on the page cache as a second tier.

What cache_ext does
-------------------

cache_ext uses eBPF struct_ops to let applications define custom eviction
policies that run in the kernel. Inspired by sched_ext, it provides:

  - Six policy function hooks: init, evict_folios, folio_added,
    folio_accessed, folio_removed, and admit_folio (admission filtering).

  - An eviction list API (kfuncs) for creating and manipulating
    variable-sized linked lists of folios. Policies can use multiple
    lists.

  - A batched eviction candidate interface: policies propose up to 32 folios
    per eviction request; the kernel validates and evicts them.

  - Per-cgroup isolation: each cgroup can run its own policy without
    interfering with others using per-cgroup struct_ops programs.

We have implemented eight policies on cache_ext, from simple (FIFO, LFU,
MRU) to sophisticated (S3-FIFO, LHD, MGLRU), as well as application-informed
policies. Our evaluation shows that matching the policy to the workload can
improve throughput by up to 1.7x and reduce P99 latency by up to 58%, and
that, in general, no single policy is best for all workloads.

The kernel changes in our prototype are roughly 2000 lines total, of which
only about 210 lines modify core page cache code, 80 lines touch the
verifier, and 80 lines touch cgroup code. The rest is self-contained
cache_ext functionality (eviction list kfuncs and registry operations),
but much of this can and will be simplified.

Discussion Topics
-----------------

1. Interface design

   Right now the page cache is not modularized. cache_ext adds hooks into
   the page cache in an ad hoc fashion, inserting struct_ops callbacks at
   six points in the page cache. Is this the right abstraction? Are there
   page cache events we are missing? A longer-term goal could be a more
   systematic modularization of the page cache to make it amenable to
   extensibility, but that is a much larger effort -- we would like to
   discuss what a practical first step looks like.

2. Relationship with MGLRU

   cache_ext is currently built on top of the active/inactive lists
   infrastructure. Can we instead make use of MGLRU's infrastructure (e.g.,
   the access bit scanning)? This also raises the question of whether we can
   split MGLRU into reusable infrastructure and policy, so that policies
   could build on MGLRU's infrastructure while replacing its policy logic.

3. Eviction list data structures

   cache_ext implements eviction lists as kernel-managed linked lists
   exposed via kfuncs. Could we use BPF arenas instead, as sched_ext does?
   And how would arenas affect the ability to fall back to the kernel's
   default policy when a BPF policy misbehaves or fails to propose enough
   eviction candidates?  Are the eviction interface and data structures
   powerful enough as-is?

4. Path to upstreaming

   cache_ext was developed on Linux v6.6. We are currently working on
   rebasing to the latest kernel and should have more progress in the next
   month. There are a few other issues we plan to fix and clean up along the
   way, but in general, what does the path towards upstreaming cache_ext
   look like?

5. Future extensions

   Beyond file-backed page eviction, there are natural next steps that could
   be explored down the line. Prefetching customization has been looked at
   before (FetchBPF [5]). Extending cache_ext to cover anonymous memory and
   swap decisions has also been mentioned as a natural extension. This
   could also have interesting interactions with Shakeel's memcg_ext
   proposal [6].

Links
-----

[1] https://doi.org/10.1145/3731569.3764820 (SOSP'25 paper)
[2] https://lpc.events/event/19/contributions/2165/ (LPC talk)
[3] https://github.com/cache-ext/cache_ext
[4] https://lore.kernel.org/lkml/aa9SB6OzocfwL9kO@linux.dev/
[5] https://www.usenix.org/conference/atc24/presentation/cao
[6] https://lore.kernel.org/lkml/20260307182424.2889780-1-shakeel.butt@linux.dev/

Thanks,
Tal

