Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F472CD3430
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 13:38:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE6CF6B0005; Mon,  4 May 2026 09:38:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A97AD6B008A; Mon,  4 May 2026 09:38:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 986846B008C; Mon,  4 May 2026 09:38:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 859DF6B0005
	for <linux-mm@kvack.org>; Mon,  4 May 2026 09:38:09 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2EE7E1C00AC
	for <linux-mm@kvack.org>; Mon,  4 May 2026 13:38:09 +0000 (UTC)
X-FDA: 84729841098.04.E6F9ABF
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	by imf11.hostedemail.com (Postfix) with ESMTP id C20EE40006
	for <linux-mm@kvack.org>; Mon,  4 May 2026 13:38:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=nmZ8O9mw;
	spf=pass (imf11.hostedemail.com: domain of arun.george@samsung.com designates 203.254.224.25 as permitted sender) smtp.mailfrom=arun.george@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777901887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K5X6546rG8Q7CDMgHYe0dMLLoA8JVhsjJIJ+l/s2c4Y=;
	b=76i+F3M29H03ivMcZn3D4NrwSxiUdC+Sz3mFgdJm+WC/bXkXwJXnBTwCWCJEIS38L2hnse
	vfkDadOtbVHBBUhoF1i2pU0pRCLKurhyF4K3Npm379P7IW+woFe6GWn+vCr2ziQg9y48iJ
	PHqfH860K2Zph+sEyjVLPsFI9gBcUvA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777901887; a=rsa-sha256;
	cv=none;
	b=20ve3KJ+LQE7sLF9xwGg//VkXa/wMcknB+RLe9lFUNFf5OnlJO0mY+z6NR3BQULbaD+Nfs
	I1I3OCb7eSngjiNZvTlBAa5dqZtQfnPsth6A+JDWOLcwBusnvRhQG4/uSBbvJDGBTDAaJw
	AzoUOjj3xdrLWL/injxIZyX5QTV8b5g=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=nmZ8O9mw;
	spf=pass (imf11.hostedemail.com: domain of arun.george@samsung.com designates 203.254.224.25 as permitted sender) smtp.mailfrom=arun.george@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260504133802epoutp02b4fe67eaaad6b60cdae9efe8d85f925e~sYFeNTetM0577405774epoutp02e;
	Mon,  4 May 2026 13:38:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260504133802epoutp02b4fe67eaaad6b60cdae9efe8d85f925e~sYFeNTetM0577405774epoutp02e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1777901882;
	bh=K5X6546rG8Q7CDMgHYe0dMLLoA8JVhsjJIJ+l/s2c4Y=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=nmZ8O9mwkiw6Qc3oNT26vkjmnNlI2wukd5FwCDzd9H7xY8AuXai7IIgT3MUN5KTvU
	 zuWhH4yfS4vIWtH7ZZm3cCd5duET+79RK+Yll2CLppi9ZAF+JaB3VR+AtIpQLJzfYp
	 kuHf8nA1xhwKYRz7MOqFl4cYZJ66wHOLsJP//U40=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20260504133801epcas5p2868c041e3779e42e6e5fde3d36dba3a3~sYFd4KT8O2899328993epcas5p29;
	Mon,  4 May 2026 13:38:01 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4g8N4n4bV1z2SSKX; Mon,  4 May
	2026 13:38:01 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260504130907epcas5p29c41fc288662c37cd8ad7241772a53f8~sXsPFsdos2990329903epcas5p2Z;
	Mon,  4 May 2026 13:09:07 +0000 (GMT)
Received: from [107.122.10.65] (unknown [107.122.10.65]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260504130855epsmtip2f74fac9944e13b661bd91b5d97d7c8d2~sXsD4QdS72669726697epsmtip2P;
	Mon,  4 May 2026 13:08:55 +0000 (GMT)
Message-ID: <1891546521.01777901881625.JavaMail.epsvc@epcpadp2new>
Date: Mon, 4 May 2026 18:38:54 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC][RFC PATCH v4 00/27] Private Memory Nodes (w/
 Compressed RAM)
To: Gregory Price <gourry@gourry.net>
Cc: lsf-pc@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org, damon@lists.linux.dev,
	kernel-team@meta.com, gregkh@linuxfoundation.org, rafael@kernel.org,
	dakr@kernel.org, dave@stgolabs.net, jonathan.cameron@huawei.com,
	dave.jiang@intel.com, alison.schofield@intel.com, vishal.l.verma@intel.com,
	ira.weiny@intel.com, longman@redhat.com, akpm@linux-foundation.org,
	david@kernel.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	osalvador@suse.de, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	ying.huang@linux.alibaba.com, apopple@nvidia.com, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com,
	linux@rasmusvillemoes.dk, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, tj@kernel.org, hannes@cmpxchg.org,
	mkoutny@suse.com, jackmanb@google.com, sj@kernel.org,
	baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
	muchun.song@linux.dev, xu.xin16@zte.com.cn, chengming.zhou@linux.dev,
	jannh@google.com, linmiaohe@huawei.com, nao.horiguchi@gmail.com,
	pfalcato@suse.de, rientjes@google.com, shakeel.butt@linux.dev,
	riel@surriel.com, harry.yoo@oracle.com, cl@gentwo.org,
	roman.gushchin@linux.dev, chrisl@kernel.org, kasong@tencent.com,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
	zhengqi.arch@bytedance.com, terry.bowman@amd.com, gost.dev@samsung.com,
	arungeorge05@gmail.com, cpgs@samsung.com
Content-Language: en-US
From: Arun George/Arun George <arun.george@samsung.com>
In-Reply-To: <afIKxG5mJZE6QgpR@gourry-fedora-PF4VCD3F>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260504130907epcas5p29c41fc288662c37cd8ad7241772a53f8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20260427123800epcas5p1e1a2fed257091b31e2e6c3a7d1b0c2b0
References: <20260222084842.1824063-1-gourry@gourry.net>
	<CGME20260427123800epcas5p1e1a2fed257091b31e2e6c3a7d1b0c2b0@epcas5p1.samsung.com>
	<1983025922.01777297382206.JavaMail.epsvc@epcpadp2new>
	<ae_i9IlIndumJWN3@gourry-fedora-PF4VCD3F>
	<1891546521.01777455002601.JavaMail.epsvc@epcpadp1new>
	<afIKxG5mJZE6QgpR@gourry-fedora-PF4VCD3F>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C20EE40006
X-Rspam-User: 
X-Stat-Signature: u89of1z5z33ps9exp3j98fq9quhy6y8o
X-HE-Tag: 1777901885-182587
X-HE-Meta: U2FsdGVkX19uwIE8ukZA3Hj9XppvshYFCjYST5x3vK3BkGAD5wk0TulFfh99T7+FRVZKzUjrkKxDf5FT5dglWG4ADxhkw/DEXKPD2LTam2mcq5b2FT34tuBSlJLeRugv1IhkV9U+4labUhus4v+cSt66sNlMwANO9z339oeHpU+7v3ky+MhjoRk4sZOSbTCxaS5G1dB7i0IRVt+cSw0q5Yk2dPEuBCFMBjCZBGGXtp5N8jOFXy7VSSnOJrsIiAj8NjiPh/iPfGIcvdwUWpBRTSoGQZUZggZxgPppavchgNzQNApp9mKaoRb52dlNRH/9LANl9+Po33pu4X3oRfmiLP5qd67QeLlplqKJGkLsX+QN3vPY53CUCwkzjGdGnF9yj2bc+zTIfb1bni80Q5IcgmYV5R/cgkUbbmQCNks5nQQJzZbGJgqp09XksPGSsEoJsH4LQuwLWlieLnwEBSGdCkHBqJTiLcRdg5vMoXA3B+qhW17AVPiQySAxtwx46Qk75eEcjbXz39rLB/+p7ylyCcAAIhd9ZbK5GzjRGfvfGSh6PeD31I0H/adBiZsxEyYK9PZyik1VD5HsOZB19aj+HoXrCM3VwSQFyM8PLfrW/nGNNIWzV5L1dTnMytJRs6jhzToBQw93KnWuO5cijv672HM2SQFIWKYZhvM28rs52/KxJ1N4VoLkFZXE3GwcWTE3YyyPgcUaCcHsRrzkixxcsCdY/RaYbVVU8eieCTo6px7enncpiKtg5brlI/Qt6iljwG44d5u6h7t4mfxXjpRGB6kPOysGt8WUePjtz0mj+97skKxQ2og3+QNvpvSGXziI7Fpn1hYcKvDMIAR0H7Et8hsi5KA7bIQ8EYMDlWDzecY/MmYJJ/gCLka9zyIg0jGkBiDrDTyUnaw/VXdtZbsrsSUanlBCMaM/lmdF5kJ2IEVlIf+ZuncywcHMB3kKmKxqbkbRGLPTBR/dsG3V/AM
 ataahgM7
 vV7nPjndj7jkFZ45tbeD1j4waAHnaigHZzEsVtH8qDtYuV1dkwPQHbEvXpgkC9JzZhrRpNHbh9O4Ar0RPknngVu7KXhkixM0c8ElYYF/pAfyr7XZPxiEaYGGtFIcJd905vWF6FJg+/b44+ZS89EIB4shsQefW489tw5m53bwHKnpDfl/DKVFcTeTMo7hGsyRIGv9M
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29-04-2026 07:12 pm, Gregory Price wrote:
>>
>> Great! I believe "writable budget" could be an interesting idea which
>> can solve the 'bus error' sort of scenarios due to device not capable of
>> taking any more writes. The write budget could be replenished using the
>> control path and writes will not go ahead without the budget available,
>> right?>
>>
> 
> Write budget is simple
> 
> budget=1  (up to 1 page can be writable
>     1) swap 1 page ->  cram alloc 1 page, put VSWAP_CRAM in PTE
>     2) read-fault  ->  cram upgrades VSWAP_CRAM to R/O PTE
>     3) write-fault ->
>        a) if (writable_cnt < budget) { budget++; mkwrite(pte); }
>        b) else:  normal swap semantic -> promote to normal memory
> 
> Meanwhile - use ballooning and a simple shrinker to dynamically size the
> region to respond to real compression ratio.
> 
> 
> All said an done - you get something close to zswap but with R/O
> mappings for all entries, and optional R/W-mappings for administrators
> who know something about their workload and can afford to take the risk
> of some amount of capacity being written to uncontended in exchange for
> performance.
> 
> The writable-budget is a risk-dial:  How much do you trust your workload
> to now spew un/poorly-compressible memory?  The write-budget is a direct
> measure of that. (so take P99.99999 compression ratios, and you can make
> a good chunk of that writable).
> 
> ~Gregory
> 
> 
I believe we are converging. Agree to most points you mentioned.

I see this problem statement can be solved by 'write-control + write 
budget' approach similar to what you have described, whether we take 
swap path or not.

But I see this 'write budget' (budget in terms of number of write 
operations that can be handled by the device, not capacity) to be 
provided by the device in control plane; not by the workloads in the host.

The budget can be communicated by the device in the device control plane 
periodically (to be handled in the specific cram back-end driver; may be 
interpreting the device back-pressure indications into a write budget 
value). Even if the control plane breaks down, the host does not run 
into issues except that it will not write further.

I assume you see this value coming from the workloads. This might be a 
place where I have a different opinion.

There are multiple advantages of this value coming from the device:

  1) We can modulate the write budget depending on the actual 
compressibility in the device (and so workloads data). We don't have to 
do estimation based on the workloads.

  2) We don't have to do the capacity modulation - as in ballooning or 
shrinker.

  3) Even if the control path is broken, host can write only till the 
available 'write budget'; so it won't get into 'bus error' situations.

~Arun George





