Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3FB1606A33D
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 09:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P/4uSXe3
Received: by kanga.kvack.org (Postfix)
	id E7EC76B05BA; Mon,  9 Nov 2026 04:41:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2FD16B05BB; Mon,  9 Nov 2026 04:41:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1E696B05BC; Mon,  9 Nov 2026 04:41:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B312C6B05BA
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 04:41:17 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4C28616060B
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:41:17 +0000 (UTC)
X-FDA: 85415087394.21.CA5B811
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id AA63D160005
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:41:15 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="P/4uSXe3";
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794217275;
	b=A9HQZxYgxBEMhIqTkykGLUeMnfEfxYEWIo7gSI6YQSYrXrYiTU8gC+gMpef1o6R69ni0pV
	mC/voGwEkwZFA5pogKsCtAtwszNFs9lHBGpify29NXKCXiaa0o0n7+X2JIH9lbnJwLBtpZ
	omVCigTI8Q0kKG61HwBqwyRwo6inTrw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="P/4uSXe3";
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794217275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Bm1+eUEK+FHSD+EcDQEDqDRX6+druzmbz7a8/C2NzM=;
	b=o+KDv0pRtQVulPe4DszvGWq26IEIlusNPNFqmy6Ogsx2OhX6Pt/8qD4BTBSy3vh5OBfXSJ
	WYOW6e1ZgruvRtHeRB+XwE8UZlbdaAv2b0aZDFEMWMnkVXV3FEH1fgDJv+qPrtVvRckBG+
	QFOnJFC+Esnge58WOAvblQV4bVLZi+M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2F28260142;
	Mon,  9 Nov 2026 09:41:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECE4B1F008A1;
	Mon,  9 Nov 2026 09:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794217274;
	bh=2Bm1+eUEK+FHSD+EcDQEDqDRX6+druzmbz7a8/C2NzM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=P/4uSXe3euy2p0f/uGxCs0nP5wZK8Wjy988o6H9jf6+IHycHdQkyMlZBCI+OemLGh
	 HdnxgiG7WBtzVaM7RJfaACyZ1LkbSys/EEAc1pKixLmyxgk4clYaEa1yI/ibME/cmR
	 73sIhcFe628fL24tNi1nmyQG6/y2XsUkES662ZExlcV2P3WLAyHLbhx1Js8nlF+PI7
	 Wpo9SX2fJsRxUx4xoPrEAv0pYnjvnVCMAc61PwBzl/uy9uNCLfJZAGfdL3Fb8yTsSm
	 bflhB89PTYiDbNVBwE7kWZo375vuHS8Ab6pBAUPt900QcWpxfG80hK5jDCuzPzD6fv
	 N66HTRB1UqEHA==
Date: Mon, 9 Nov 2026 11:41:08 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: Balbir Singh <balbirs@nvidia.com>, muchun.song@linux.dev,
	osalvador@suse.de, david@kernel.org, akpm@linux-foundation.org,
	apopple@nvidia.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/hugetlb: optimize bootmem hugepage tail vmemmap
 init
Message-ID: <avGVNISvj-v8IN3g@kernel.org>
References: <20261105120615.16817-1-lizhe.67@bytedance.com>
 <20261105120615.16817-3-lizhe.67@bytedance.com>
 <au2qhlsxQt3SRwIu@parvat>
 <ca38db3a-a8fe-47c3-8813-5c3b0ac4b7ac@bytedance.com>
 <3e5a9f27-ea35-4557-95d1-70ce359e4c92@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3e5a9f27-ea35-4557-95d1-70ce359e4c92@bytedance.com>
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AA63D160005
X-Stat-Signature: nxdox6ptw484chinyohtzzs5ozhmb6cq
X-Rspam-User: 
X-HE-Tag: 1794217275-37702
X-HE-Meta: U2FsdGVkX19OUpO+FLlM1hD4NO7XKleKk0r7Qs+zp7cAcQVVXrfnLnd1kxI1OwoRczmmMMiSqmMMExnH8wtvZrWyOkx1Y2IhkhXPFK1h3MyEnnp8BVGKwC+HBN79RMcit+/3kXt5HZ5ZyWJzILJPLQMtyxHiRnS56XGFAb+lmfujx8a4+9wkQ3Icv+WJqYkj9Hd6UvHOIHqUEPJaKSSR5lSbVFhn2IC6gRZ3BmO0OZTUvyIrWxjxkUUCfei+3cI8oUvyAIE/ewGNdnQD4by4YC7AagOc4vcgNtCJw0qgaLPZBbpS5QjHJNJNMMbQxAwLzD0QTEjJD3+MmIUIV0KUIgYkhe0oCorudufhgS+Xu8cSvAc88lcU6LpdNPA+sbMU46Gd95d8FVeUCW7HefFTybTlB+zf5FR5NzRCuyn+I2pIQDWgno+EpITNcoAz5+fJU2ou0g5lrvKRbe+voKAdvevccY+I4d6FXdxTdfWs4A7pBjfcloDiHpiUHMNmtPFzw8MkCDCzwlHe+jJfikcnPfK4SYZZs6joqDqgZnn0OIxWCoFaW+Ppo7BbUi3bPN3kz6GRAZUQ+OvLp1enujLrA9NVKReOBmF4J7Kke0Kto+mQm59Xk8tykpIi8YTwdWVUv53xAyt1xXjdstvTKWbQncE/HpM6A9k8dBkaZ06wMJjg9TyfujKgVomfcopYpU9nf9peD4i27EF0WoNO+ohAWgv5LgX3JbK6hoQaktBUljOmSg1fXSoo/6PEh/qgbVxR8VN1IrsJL0mzq0C3ralDsyii6GIr6e4wdz1Kh3RbB6ZUENL/uqTzSVlYl2cHfnpahIJuUkfgEnt9YZpLjsC53wRsXfwpDRTFAzs7DDBfM5B3gMp2LQUADua9qrAnUzGVx66lGOo/0E2hyI2MkXkWCdIO31RgIDpOo58BZdU+5qSM9r7j//7girFMdoulu6dnbANXQ6+l3UlLEIMY4L9
 xgjjSiRu
 uTqPFLbGavNdwrOo68wxKadP5nZCljDCSfkzlHjARqePTFfXx200SzJ1gj+GejE9ZuumkEz4J/6cxDuFPmxp6Kq3+xhP9AOwEmmFkuzKSbHEMcbVcNOFQR8e0JFkhAyPJLeg++KtsKtpWhCxgjeneXvRWBSkls4/kx+qoZWf9QOdvLp3RNVUxhokaiGX8JP0A2rGLFvuby/qny7WVDQHIg2dEUbQFqE2gUKkADk51yRPmJyOwbR+VGreDDa44r+83yPuH9gs0RFqHSRqS6kinUTVhuCxgOgvOjvDO6xjha4tMjC4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

On Mon, Nov 09, 2026 at 05:22:24PM +0800, Li Zhe wrote:
> On 11/9/26 11:01 AM, Li Zhe wrote:
> >
> > On 11/6/26 6:23 PM, Balbir Singh wrote:
> >> On Thu, Nov 05, 2026 at 08:06:15PM +0800, Li Zhe wrote:
> >>> Boot-time HugeTLB allocation has to initialize tail struct pages itself
> >>> when HugeTLB vmemmap optimization (HVO) is unavailable or fails.  For
> >>> gigantic pages, this can cover a large number of tail pages. Most state
> >>> installed by __init_single_page() and prep_compound_tail() is identical
> >>> for every tail page in the same huge page; only PFN-dependent fields
> >>> need refreshing.
> >>>
> >>> Initialize the first tail page normally, copy it into a local template,
> >>> then initialize the remaining tails from that template with
> >>> memmap_init_page_from_template().  This avoids repeatedly doing the 
> >>> full
> >>> __init_single_page() and prep_compound_tail() sequence for state 
> >>> that is
> >>> identical across tail pages in the same huge page.
> >>>
> >>> On an arm64 QEMU/KVM guest using 4K pages and 64 boot-time 1G hugepages
> >>> (HVO unavailable on arm64 in v7.4-rc1), the measured fallback tail
> >>> initialization time improved by 36.43%, measured with a temporary
> >>> jiffies-based printk modeled after the existing timing in
> >>> memmap_init_zone_device():
> >>>
> >>>    base:             318.4 ms
> >>>    with this patch:  202.4 ms
> >>>
> >>> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> >>> ---
> >>>   mm/hugetlb.c | 23 ++++++++++++++++++-----
> >>>   1 file changed, 18 insertions(+), 5 deletions(-)
> >>>
> >>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> >>> index da5d04edf7c1..987f16a5ea27 100644
> >>> --- a/mm/hugetlb.c
> >>> +++ b/mm/hugetlb.c
> >>> @@ -3219,19 +3219,32 @@ static void __init 
> >>> hugetlb_folio_init_tail_vmemmap(struct folio *folio,
> >>>       enum zone_type zone = folio_zonenum(folio);
> >>>       int nid = folio_nid(folio);
> >>>       struct page *page = folio_page(folio, start_page_number);
> >>> +    struct page template;
> >>>       unsigned long head_pfn = folio_pfn(folio);
> >>>       unsigned long pfn, end_pfn = head_pfn + end_page_number;
> >>>       unsigned int order = huge_page_order(h);
> >>>   +    if (start_page_number >= end_page_number)
> >>> +        return;
> >>> +
> >> Can this actually happen?
> >
> >
> > No, current callers always pass a non-empty range. I kept this to
> > preserve the old for-loop no-op semantics for an empty range, but it is
> > not needed here. I will remove it in v2.
> 
> 
> I need to correct this. A local Sashiko run pointed out that the bootmem
> fallback caller can pass an empty range on SuperH.
> 
> SuperH supports a 64M HugeTLB page size, and with 64K base pages
> pages_per_huge_page(h) is 1024. HUGETLB_VMEMMAP_RESERVE_PAGES is
> PAGE_SIZE / sizeof(struct page), which can also be 1024 or larger on a
> 32-bit SuperH configuration.

If the only difference is unnecessary initialization of the template on SuperH,
we don't care and you can drop that if.
 
> In that case the old for loop is a no-op. So I will keep the empty-range
> check in v2, before creating the seed template.
> 
> Thanks,
> Zhe

-- 
Sincerely yours,
Mike.

