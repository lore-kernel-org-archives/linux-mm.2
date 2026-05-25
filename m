Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6556DCD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 15:07:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B52BC6B00A3; Mon, 25 May 2026 11:07:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B03A06B00A4; Mon, 25 May 2026 11:07:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F3BA6B00A5; Mon, 25 May 2026 11:07:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8B37A6B00A3
	for <linux-mm@kvack.org>; Mon, 25 May 2026 11:07:17 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 50C4D400D0
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:07:17 +0000 (UTC)
X-FDA: 84806270514.12.5EF0038
Received: from flow-b8-smtp.messagingengine.com (flow-b8-smtp.messagingengine.com [202.12.124.143])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5E07A180002
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:07:15 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=WpI2EQqD;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="B XxFzs2";
	spf=pass (imf16.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.143 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779721635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uAidWM6Doq45YyDIJ9vNykdRKZ6pZRCuWvsWl5/kGY0=;
	b=ICWbKq9Ht2RkvrJRrLqAwTo2QgwJQ/BAXNcVotnKEETjQb6Gq7+lLlCVwKhnCyxYwDN4+W
	3U6TmTI4jrkUFu9A9br3pHG+RGsFkHFN4jTr0WO8ByPo2h7N9mEeLTDckUVSeeG4BN8vvS
	pszC4A3Rz2kj8Q6jTUsG6v/13q6pwTY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=WpI2EQqD;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="B XxFzs2";
	spf=pass (imf16.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.143 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779721635; a=rsa-sha256;
	cv=none;
	b=FJlM6UJ0onU7VdcMWxjaygYe76ypLvylotMTYFzY7l/9J1Ys1AfnapdxyOC8KEXz3tUAwn
	yuFeA95YVDcifxmXVTX4fhTlRRowJc9JJUB0GxTtyNarmmSWOP1ijTgs/poTMRK4YPsyfK
	QbGeg5ZbKhxRO6WWTAZbXU6cH6WGTHI=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.stl.internal (Postfix) with ESMTP id 9CBC7130008E;
	Mon, 25 May 2026 11:07:13 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Mon, 25 May 2026 11:07:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm2;
	 t=1779721633; x=1779728833; bh=uAidWM6Doq45YyDIJ9vNykdRKZ6pZRCu
	WvsWl5/kGY0=; b=WpI2EQqD3KdHEhNORbaivt4Q+1uoPK3Ptik61wbnki/TNXgk
	DPsueiRGhrIrrTohPXSGRvR+9ljCVGqcuKveph4iozn63Z9pVkUprdRrx4VsbTJN
	sD0h9rWO0MbzaejG8F3JE/HJTQsLE4/7hhEnOI2d+NuKKfvqZqzlz2+ny/IIoHN7
	x1HMCoXMW8SXnaa5KObbhLpRAIbry6PwLIUSsq613F2hHQ/LWL45PuC5NFKuCgim
	iV/XNVZsm6uDAIZqdXifBthHagdNTLoS9yL4jFjXZT7Kj5H9tygGiXyGCMZ/DujR
	KwsT9h+O8nrJifDDxrD5xlwjFEUAHOcYp//Pgw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1779721633; x=
	1779728833; bh=uAidWM6Doq45YyDIJ9vNykdRKZ6pZRCuWvsWl5/kGY0=; b=B
	XxFzs2zLaoaWnVdwDc5fsZINnBlxl9Kc1W9cjcuydSQHHCYnY8i02gLLEw/mDIVO
	gwGVCvGT/Z1AtMc2l+ivcyFNoaVaqRYlK9WuuvdcpotFxAW4aK4EYGUcp18QQ9yY
	PIMHcALFgGmOutJW2Ik5DY0NKpvu6LtUEglSRq2L86+1yu8F1E0XwMomXdC77nid
	Zw/3JJvZ88D1u6jK/DcC5A2fTU/19CEV9utQBsRxCTTUIvXZDoOrU0vAR90WUuXs
	2nGlcPUYsiFnJNJijxDUPu5V3er1y/9GGvtovctQkkv3JHDcmxpcSPZXZKVuhwld
	s8VRtHnzUJm5SqOWXB19Q==
X-ME-Sender: <xms:oWUUaiiJg3wedLIBJXxAg8dtSyayUwOUW_8zr4lc-MuxTXwLniymLA>
    <xme:oWUUas-bUvNQlkfGct1kYO5OibY67aMblHq_t3LUn6SV5Uoh0oOoSSGcm2l9UIoxd
    vCgrAU_RhpmRxFN62J0kem0NvYBThGyjXBkutCx-8FE0nRN-wPofQ>
X-ME-Received: <xmr:oWUUar9a2w79LoCtksjcgi9ffwFzqqLtBqEeWKkc_IClW0Ss1J6XdYQZQclbDA>
X-ME-Proxy-Cause: dmFkZTGnpAt4CiHCyPTK6atUDW6Ap5BN6576PdSsNRxIfR9OLkTNxdWc/36L65rTm4FQQi
    AlsasK3LZv8na3UgGW8gg+TKNFQHq5YhdDER8acTyNZhfVi13mzWReyF+yKJtF52wOwlcm
    1OaIHPF6Vc8i/O8qHpyiq9/tiViU2krgg16edKKT1FifhzD7dn1Ea6FZ/NcGPXgZH4hK2s
    LcU0EVoGSrwDAXL/qTsfsDrj1g3mG8lUZWNVzcAFv90d+1/Dqcy21YzJvJbC2EQ8/5uMXW
    CaM0y6ulu+VhZhvFdbYag20GIGuRYzZYwoqZ1kNudYxpTbjZkExfOtGaMgWuOmTuduAUZ1
    8Q9cWcnq/uMqXiPXUZNZtjnKDGHkyXgwEov6X/j58Qldv0ZjGZB/6StaUxJZNYMA+32uMg
    LEYUeK5ONOQvE5PcPpNclWQuLC3uX0oesJoek11zME/1yNV+7cADt94x5zQAxNZS7VQXrh
    iyyI8F5aaIJEYnzHQCOp3Ps9vdTnKrmRNd5A3G9dyO0AUHDud8lgs4mOcJmOCHRFoWK0AK
    dvxRUgktYCOUK/AUc9dvFnuGx5Xx6srvn5ho9JpG2k7GwIkPYZlPBLahxnOH46AxT9hw1o
    mDx1bLFoFkKkl3EWDmKqocV+P5M8/vNePvuUNUJdZGTiTKvvCCK3ruGT0OKQ
X-ME-Proxy: <xmx:oWUUamu8CIfKsjHUZhft3KQ1DObnoH6vUzLm7d4AMZmQg8PBDPjT6g>
    <xmx:oWUUapI7AH6rPVndOZ3BKhirUp4AP-_QTJDU2IxJIj9KR77g7ieh4Q>
    <xmx:oWUUap1wxdD8oqLriycEAnz3rkbxxjCeIgqw4KLhZ_T_OHBWgBBlSA>
    <xmx:oWUUapnjankROHxLh3VsyKE53JR30E7C0_TwA-QReq2AXlWARDr-qw>
    <xmx:oWUUao2Q0gF820oz_MoBAJZByMlpe7MmUDblNIPfiXqgwaf_5NKuotSU>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 25 May 2026 11:07:12 -0400 (EDT)
Date: Mon, 25 May 2026 16:07:11 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: sashiko-reviews@lists.linux.dev
Cc: kvm@vger.kernel.org, akpm@linux-foundation.org, rppt@kernel.org, 
	peterx@redhat.com, david@kernel.org, ljs@kernel.org, surenb@google.com, 
	vbabka@kernel.org, Liam.Howlett@oracle.com, ziy@nvidia.com, corbet@lwn.net, 
	skhan@linuxfoundation.org, seanjc@google.com, pbonzini@redhat.com, jthoughton@google.com, 
	aarcange@redhat.com, sj@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v4 06/14] mm: preserve RWP marker across PTE rewrites
Message-ID: <ahRk5tphnTx_CVnA@thinkstation>
References: <20260525113737.1942478-7-kas@kernel.org>
 <20260525120819.C18561F000E9@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260525120819.C18561F000E9@smtp.kernel.org>
X-Rspamd-Queue-Id: 5E07A180002
X-Stat-Signature: i6cyyzsao4ij7atkqp7rqeuwrgcsc8c8
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779721635-434362
X-HE-Meta: U2FsdGVkX18jA8WXboNYyBYsUb1QwmAJ3x00vBGUfFH8XIdh0J/aQ8GMI7t8VgpwDrHLjSpjEo+gXtxEBU8HXrsVML+seNi2U/jJD9LQBPjnjClPVEXinOoyUHqtd90MUz5yFfXCDPy43qpKAFodYGhSLNjNQmLEMveK044GNNpFSrtGdvvtd5HGiJhSi+P6UE5t21dNk8wwNaEyknNN5pLKFwXvSrzVPpPGjLCm15HUOic7S/1ucd+S/9CPeH34QW2uOJIWEIlYWzjD7PHhhJYPaPgUR6MjsSK9wYx6igYiqpyv4cCYEdgoN94YN8S57+jYNX7ry3DxPPPaydGD4LXeduE8GmbyMgXNISTxFVtC47gKwR+ezobNPV33eSDSvGnMmen6cYJQJi1VEfV041gCUE9SeHSeHaqUrXD22fdxBTo26VZVdMj3QBkjW+i6v111cVL+IGi/4iWniwo+J1M+0od4J4UWIJfdEjH+9d2KlpPG6kmoe4+ZRxPuIoXjI4UP6AWJ72V5cu8FEoZ1imZWPWAIMXireJibFLGl8sEVgGQqwlTR3J0pz/bEFGGsr16IKNmPbgHL60tpz9FUyZMit//epU+oI1P3uVeKIAJJLNBrN7ml9l3TR90HqC/W0McraxiFR5H5GJiZcItV5wJGtjA0eHrU6E5jP1zdaQhiyR3smwKzXI+ZOHZkxMuChHn2pGUVsEtOBh3xqZ3J5G0xer0SmLo6ti6JB5wOitMegxgPV2+6YiwStbTEXjpMtOUAYW7212D2h9QpAZVDrHTiN8nRD+isVlomg2wUEQjZY3l7uav/knlYWuH6x4q8Mt7uFLWpNgG1fctjVyA3eJLoJDeq6uk/0MPUmVAPHKMk2iskTV9cWZpOhRzNvVCfWX5+T+/cOP2zVqZ/mSA1HscomNu+BmqS+a1oPueVrLy5N8LhmWFqkKz7G6vQP88BXYBMtgCPFduJt/lbiQp
 W/DiPhIr
 z9V6RZLfbhYG6MLc8YZErTscfWZ/zRVGAC1U3NpF1Cc/cilCG1oiJMs/IVMjHP5XQ5fZj0Fa1JmdnopNy/flHVfWszWlj4SyCOtwqhBC/R6Lubp/B0hXHxsW0Eyekail0YSvASYQwhV4srsKmAM6E2Jy3hKaLuZUeGKJ39v0qz75XXLadAdRDkJ7bmMS/5Z7lxjrmI5JpTooUFq61EAnkKrcvhHwsEfWRHh4U0ytIt/E5q+BQW/kQm3hmlkjmCwUjP4sWtTcXhDGNJoq5AD7AOnKvaJiEahTpGzoOIVtUSHDuCJyKHh+FqWJttG+feC7/7K37hl+c/XOyMmyrYwNZst7QLDXkvX8xr1N0k6o1/4x/LjuMwZQuUtl6ann4wMK4o2juWc1pTcOJjVKdtxnq/1VpmO0ZL0idtpOW9p6PrXxoGjxk24BxnKMH1xGktIhMG+G03XT6j1cw/lD7ow4+S/tJg6NV18FWVanVFr3QlfvjJvt9i7B4qmUv/cInGDCZEPIg7maklBTMOliXYpyXThGf2pNCi0OPeRNzJ4l/xTaZnJQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 25, 2026 at 12:08:19PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> 
> New issues:
> - [Critical] Unconditional normalization of all PTEs to
> vma->vm_page_prot destroys granular protections and creates invalid
> clean+writable PTEs for shared mappings.

Confirmed for the NUMA-balancing PROT_NONE case: a non-RWP PROT_NONE PTE
in the src VMA gets its hint stripped on the fork-disarm rewrite. Will
fix in v5 by gating on pte_uffd(pte), so only RWP-armed entries (the
ones that actually carry the marker) get the protection restored:

      -       if (userfaultfd_rwp(src_vma))
      +       if (userfaultfd_rwp(src_vma) && pte_uffd(pte))
                      pte = pte_modify(pte, dst_vma->vm_page_prot);

Same gate for the sibling sites in copy_huge_pmd(), move_ptes() and
copy_hugetlb_page_range().

The MAP_SHARED writenotify subclaim doesn't materialise: writenotify
is baked into vm_page_prot via vma_set_page_prot(), so pte_modify(pte,
vm_page_prot) preserves the read-only bit when needed.

> - [High] Applying pte_mkwrite() to a PAGE_NONE PTE breaks UFFD RWP
> trap semantics and creates accessible Write-Only PTEs.

After pte_modify(pte, PAGE_NONE), can_change_pte_writable() calls
maybe_change_pte_writable() which checks pte_protnone() and returns
false, skipping pte_mkwrite().

> Pre-existing issues:
> - [High] Failure to write-protect the destination PTE in
> copy_present_page() completely bypasses UFFD_WP tracking for pinned
> pages.

Confirmed and pre-existing -- copy_present_page() builds the dest PTE
with maybe_mkwrite(pte_mkdirty(pte), dst_vma) and only adds the UFFD
bit, never wrprotects. Will address in a separate fix after this
series.

> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260525113737.1942478-1-kas@kernel.org?part=6

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

