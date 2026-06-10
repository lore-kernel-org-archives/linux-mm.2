Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C75E7CD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 08:45:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEA536B0005; Wed, 10 Jun 2026 04:45:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9AC36B0088; Wed, 10 Jun 2026 04:45:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB0716B008A; Wed, 10 Jun 2026 04:45:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B9F866B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 04:45:17 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 498AE1A08FE
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 08:45:17 +0000 (UTC)
X-FDA: 84863368674.09.1089008
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf07.hostedemail.com (Postfix) with ESMTP id A675A4000E
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 08:45:12 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Z3ILBt7g;
	spf=pass (imf07.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781081115;
	b=P7sz1nuwTkXX9eqfH/TkMIltpf2Zm+TkxQvTd+D/Gno5UpayWjzPvgHXxvgBOm1t32clSq
	Ow9WTUTWKZLc8Fzf0M25oVtgjLUW3XPZKsLobUDPlplD4RES06EJwU72iWhfLDBHU60xfP
	e/6RU6u99VQK4BdOsQPEiRO0vnFH/wI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Z3ILBt7g;
	spf=pass (imf07.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781081115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AQEpnm1qCy04PBYgpVHbcMk1PPswJBtmq9NpRzCamVs=;
	b=wWNSpO/nHixRJcovVj2sFZUl4uCdXNxVFkX4vV2S9R7BH0Ucr+g19pNUx6wPzFSaY4HGsl
	XWDkqbHS/GIpPAa88bLpDSEv81iEBOoTpBlcEsLGJeWhEUi6rWm5uU8KaVXmsoHMRBQ+Mm
	UTCRmvFnzkZCx/pGkHBBXaYbGMVEZwY=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781081107; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=AQEpnm1qCy04PBYgpVHbcMk1PPswJBtmq9NpRzCamVs=;
	b=Z3ILBt7g0kYvDp5cOeVdDqqd0WwVFj4Nq3t9RVt1wvRMENbWF2LmYIP02VFaXyAuKXlAQ6tP0mi1HYF8kPzd2Av+2lksiP+AxRyfJ87d3xx/xoyiHOzDuGVm6aNIdUq86xhpid0TSv9+OCTmYFTykNXvuHfJT2dRU6Q6Nnz0+F4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R841e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0X4a5o-R_1781081106;
Received: from 30.74.144.110(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X4a5o-R_1781081106 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 10 Jun 2026 16:45:06 +0800
Message-ID: <529db4e0-6635-4e3d-8ce5-f215ad9220cf@linux.alibaba.com>
Date: Wed, 10 Jun 2026 16:45:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] mm/mincore: present-PTE scan cost after pte_batch_hint()
 batching
To: Chengfeng Lin <chengfenglin@stu.xmu.edu.cn>,
 Pedro Falcato <pfalcato@suse.de>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Zi Yan <ziy@nvidia.com>
References: <5fb8bead.17483.19eab4626f5.Coremail.chengfenglin@stu.xmu.edu.cn>
 <74cdec57-67aa-4ae3-a416-e39846049ab1@kernel.org>
 <2780f0f6.176fd.19eacba49bb.Coremail.chengfenglin@stu.xmu.edu.cn>
 <106e71e4-975c-4337-aaff-a00628827477@kernel.org>
 <aih_dIMqIeKzvFh2@pedro-suse.lan>
 <307c2254.17b12.19eb0678f22.Coremail.chengfenglin@stu.xmu.edu.cn>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <307c2254.17b12.19eb0678f22.Coremail.chengfenglin@stu.xmu.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A675A4000E
X-Rspam-User: 
X-Stat-Signature: tupmtpsr5t36y3zz4fg96dabmfkd3g65
X-HE-Tag: 1781081112-643215
X-HE-Meta: U2FsdGVkX19sJDJBksF3SBjbcXEw4GwJMP8zukr/7D7h4btI6c8J9rJzv5b+W5SfCxA0+UV8D+ofVhml4ytEXBghNLK1Q7ozrCOB6R+KEiDgxqFuMem69m8Iz2oFJmPOMZyXAPblp1UW/UGQuUkR48KRdBdyiwWiUZGuGdbYUmqkxai/67JJE5jrCmZGLIixqxoUWxOQJiAP4AQHJswM+uf5OFIqJ3uU+hAW8YtQXdabvv7p5wovtF2QRPVLS30/nGh+3mcniU6DpRg/yfR7yp0C9RcXPcNxcOeQRdoky+9BjiZB/8MMmlom7oqxUnQ93oUgKKOAp/SowP5hGp7TKDPLsYmLs3+dyBTlYCfXEvlWb4IA/Z95VRqr3H4CWZjPDH6WO1fDBRtQR+Iy0oykOBsYQh14BjCVlIWXw9PmGdF8u21xSR+wtKNFEZXySllM82bm4LHMYjmfDC+1NpnLMGgPSC+FSuX3N1N4P/ZbBy/duDmv/hDGn+K/EXGf+5WCPUUBOcFppYnR9Sq8seXKTX1V1zI22tfw5wrbpHBLaIPS7MOgH4k62vcqcwllSHyv77DXsVKV8JwrwGBiO3oy7gCvrzD1YDmd2TyI7oPy0PJTpL03w/exY+rpaiVLte4yB48UzYr4yX30Rh6W8Te0C4tcyuF8XNGBecIGPcsNGXS/fEzMzZhL/KYo8QC4QsIrifRhpv7GU1mSA3Elyf3JRa41aHRsSRD/xOmp/e1F7q8ZST8RQc0WRx/+fTG3nF0TAwdBvbcRa6jQcJt4pka5FrdVdhKQGglE4wNSkDM0T7e75UbhZJkni7wkvX/tyJVybChru66UZrSZd4+Xqs1QPXg/64uD6PP/Jnh/tC+LKtadpcroGJtWSASdCunuvY6eROfOLqV4tG1PB8otccv8MaNrM+/uetTIGartRYpHV71Q6fihuaeVEjqd2Jngl0mU2yIATgJ3xlOI3Ci4XUL
 xYIkmToa
 /M7gT0pJ42rfFlCuUcAPR8DdRnDrsPw9rIWFRoH8NM4BaOr2U4Fo5uawY0WgBucsRUchE89UigQ4y0pP5/eDlzi7gKwwDlIH4Bp01ph99JKOINIdVwywXvXOZ66LfUQaDWJLoEDH+1Ga50U77W4t/zqlAlD1f8ckNBxmQexpLz/XQRY7iblIl+T++UqGFEYyEjakqSBM673QczPWWZVjSwP5PDZjNj+xauC7xOCR38oLNjN4fRWxUjicQZj4CJMQw+S+leX25wOc9so4Fyrd3VDWXiGSkAX+0C9vayCWi/p2Cd5aeg3D93h97qm/37tOnwQGfc3Av/wL++0Gb79UX1jPxoiG+ci4ajq/CQt67pPAJ66it16yjyBpce9qd5D5Fb+94rZH/15bgFNLgnIG2LdggOb3FVq7coYhtwgUYOp2lVpo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/10/26 3:20 PM, Chengfeng Lin wrote:
> Hi Pedro, David,
> 
> Thanks. I tried two newer GCC builds as well, using the same base config and
> the same mm/mincore.o build target.
> 
> The GCC 14.2 sizes were:
> 
>    v6.15 original:              0x1e8
>    v6.16 original:              0x229
>    v6.16 batch<=1 fastpath:     0x1d9
>    v6.16 with batching removed: 0x1d9
> 
> I also tried GCC 15.2 from the Ubuntu 25.10 (Questing) packages, extracted
> locally rather than installed system-wide:
> 
>    v6.15 original:              0x1e0
>    v6.16 original:              0x221
>    v6.16 batch<=1 fastpath:     0x1d1
>    v6.16 with batching removed: 0x1d1
> 
> So GCC 14.2 and GCC 15.2 match the GCC 13.3 direction: v6.16 original still
> does not collapse to the old x86 base-page shape, while the batch<=1 fastpath
> and the nobatch variant produce byte-identical `mincore_pte_range()` objdump
> output. Clang 18.1.3 behaves differently: all four checked variants produce
> byte-identical `mincore_pte_range()` objdump output there.
> 
> I also looked at the generated-code difference. It does not look like an
> obvious extra inlining decision. With GCC 13.3, GCC 14.2 and GCC 15.2, the
> original, fastpath, and nobatch builds all have the same external
> call/relocation targets:
> 
>    __pte_offset_map_lock
>    __pmd_trans_huge_lock
>    memset
>    __cond_resched
>    filemap_get_incore_folio
>    __folio_put
>    swapper_spaces
> 
> For GCC 15.2, I also saved focused optimization-dump snippets for
> mincore_pte_range(). They show the same direction before final assembly: the
> original build has more GCC intermediate code than the fastpath/nobatch builds
> (321 optimized-dump lines and 993 RTL-expand lines, compared with 299 and
> 921).
> 
> The visible difference is the PTE-loop layout. GCC keeps the v6.16 original
> `step`-based batching shape in the generated code, so the present-PTE hot path
> has an extra split/jump through a common advance block. The nobatch and
> batch<=1 fastpath builds produce a more compact, identical
> `mincore_pte_range()` objdump.
> 
> After Pedro's suggestion, I also tried forcing the default helper to
> `__always_inline`:
> 
>    static __always_inline unsigned int pte_batch_hint(pte_t *ptep, pte_t pte)
> 
> That did not change the result in this setup. For GCC 13.3, GCC 14.2 and
> GCC 15.2, the always-inline variant has the same size and normalized
> `mincore_pte_range()` objdump as v6.16 original, not the batch<=1 fastpath /
> nobatch shape.
> 
> I put the updated GCC14/GCC15 nm/objdump files, focused dump snippets, and a
> short side-by-side block note here:
> 
>    https://github.com/lcf0399/linux-mm-regression-evidence-2026-05/tree/444d66373b7be32f7a06b52b3d9ced7c2c53264f/mincore-present-pte-scan/codegen
> 
> One caveat: I have not rerun the timing part on bare metal. The timing signal
> I reported is still from the QEMU direct-boot lab, so I do not want to
> overstate that part. The codegen comparison above is static `mm/mincore.o`
> evidence and is not QEMU-dependent.
> 
> So the narrower result is that newer GCC did not make the codegen difference
> disappear in this check.
> 
> If there is another specific compiler/codegen detail that would be useful to
> check, I can look at that.

I quickly tested using your test cases (haven't reviewed your test code 
yet) on my x86 Xeon machine, and I didn't observe any obvious regression 
(tested 3 times, taking the average), and the data shows some noisy 
fluctuations:

test cases: ./mincore_present_pte_scan no_thp_pte_scan_64m 1
metric: mincore_ns_per_1k_pages, lower is better

base            revert 4df65651f7075
2675            2670

I still suspect it's an issue with your QEMU test environment. I'd 
suggest retesting on bare metals.

