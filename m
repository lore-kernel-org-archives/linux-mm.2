Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A586606A323
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 04:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Jrg1eVLP
Received: by kanga.kvack.org (Postfix)
	id 3E0D66B0648; Thu, 12 Nov 2026 23:10:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B8246B0664; Thu, 12 Nov 2026 23:10:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F5FB6B0682; Thu, 12 Nov 2026 23:10:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DF8A16B0648
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 23:10:46 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3F0F9A080A
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 04:10:46 +0000 (UTC)
X-FDA: 85428769692.24.AC00976
Received: from mta0.migadu.com (out-152.mta0.migadu.com [91.218.175.152])
	by imf15.hostedemail.com (Postfix) with ESMTP id 092EAA0002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 04:10:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Jrg1eVLP;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.152 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794543044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vPOPOrVJDtbv3g8f3odyGjF+HpV+rwXLNAe2t5z1/I0=;
	b=301/UzWeU2+gElrHASWI5LI1S3iZdMCZD6oc0FNnUxTCHFQZkmsGz1mveP3Y311VGPDG9a
	pDCywNjPeRTWvBb3G5w/5l2c5PbOA45Hsn3aX+YHm6eGMGgizlu05pBWgjhCg5QAhE/M5z
	FuPnnzf4FYs6RV86xqEMuNgBUIwsSbA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794543044;
	b=dwi3dlh8paBsH63PaHq2c29C41t6vwg17gzCXmxoim/brTFy2NZkaoFwla4EXh/50aD8IN
	tLk2nBPIhpxwTm1XrbhGYf4gqebMSTpEVKGCZq2HuPORXg2o8Qxua7J4MYz7WlRyj76UXo
	7AqQeSQ1xetb8Th7bj6OmUpViKwRcaY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Jrg1eVLP;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.152 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=RbVZ7SIC7l2VU0WGvHLgOHP9LnYSWkJv2RkUhwjLIXg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794543042; v=1; x=1795147842;
 b=Jrg1eVLPHDJerYWZ4NPcyfdFNSBuAJj53dawejHT2FPYsi24eXMwSMRC9cRLEF3ho2suN7wS
 vV2T7zfxqv5dTOvHvi21U+vfSt6EaT+lGJYVHvPljBxxENakMn1eCrrNhOlcGMf+wCzD9/QZHzW
 KgU5g2QkFOQ6/BGK45KPTq9w=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 135ab794c57a1a37;
	Fri, 13 Nov 2026 04:10:30 +0000
X-Mizu-Trace-ID: 135ab794c57a1a37
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v2 02/14] mm/hugetlb: optimize bootmem hugepage tail
 vmemmap init
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <sashiko-outbox-212147@kernel.org>
Date: Fri, 13 Nov 2026 12:10:13 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>,
 Li Zhe <lizhe.67@bytedance.com>,
 Andrew Popple <apopple@nvidia.com>,
 Balbir Singh <balbirs@nvidia.com>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 James Houghton <jthoughton@google.com>,
 Lance Yang <lance.yang@linux.dev>,
 Qi Zheng <qi.zheng@linux.dev>,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <D1F34237-066F-43E8-89F5-2D7A6217D72B@linux.dev>
References: <20261113033442.62970-1-songmuchun@bytedance.com>
 <20261113033442.62970-3-songmuchun@bytedance.com>
 <sashiko-outbox-212147@kernel.org>
To: sashiko-reviews@lists.linux.dev
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Stat-Signature: s1pnyi5rmquyax9dqaiddayntkfyku1q
X-Rspamd-Queue-Id: 092EAA0002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794543043-994520
X-HE-Meta: U2FsdGVkX1/tC+YqXukDkNUzmyKrSJXH5RcEaXxBsyZUWibKbCgFnqrDF1+xws64Ou5ntVxDp/klV1FsDFwKqE5di5MZI6Wu92bEqzL6avQ+5dJia06un3In3iVXc2dr1vYa5P4mk25mHkn+bofGRarDIQg2fB8hRHDsozgCvE5yc2PLj/gw0xNZsge6PqSFDulNB+qyf34N87Z+XyP7hv6aar6g84H2RX2VeGRnbepRkWLp7O66n4HlZCVJNGOMuGAL9/+KpkXM+Ej3/Ee6moWxgLCBWp1JRbMth9NiGHFUVQgzFboV3fQSmouiknus5GPWBhibyltjagkyKMqrqjudz2qQRF/lFmaNSO6TK8teyNRuAFm08ce4TjoyU9p5iObBGcoTOSE76VjDjk23vy0qk0+cnimz5XqCh7HJaTd6U3ARZkeOfuG0MwDqHu0qwOdHqNM2GTVMbZMTnLiaIJnHhGQ85AOQ2VEQzdLyAlD1dfTuYmunRG7pmfwpcEJih/fkDkrkxeOtujM01/IBbCkGV/kqEU9/vKAlBvPxY6o+0SzNEgYbns6q0EtOfTvtpnDTCV1VXbMn2RVVT4qNttqbpmMp2FTX7JqxXHJTKLGPQ9q0F3bfKETejUU7BFLg410a0hDNGqA6F4oOgBXTDcjnF2XH2QTIg1NQhYq0aKQAptRzB9CP12P9wRagO4mpurqdCgmJzlIfmN4Vq1VsWTsghPlNFM9Y+Y4IVFYsXl7qcWRLq9tjEOFdHcAHlVBeiBrK+avZGtKFlpZwcUEoTzQC+dpqPK1ME66wGt5PCsygXiNRost0ohIgyQ/EzUTRB63dQGbAmDEnPyXp5CjFNyPrRAol+SDoYPlK0wjXM+LptoKwIIPDG4ehFEPoGxWlyah/vSNI/iqsVYyATmB+oUcXUL8jqkqDq4IX9JnqipwU3TduKAqiNsnY1mLY9v0oInvI2wxyeMWH3qOl26q
 RyGuI+JR
 mdng3cPCqDeE/+//ADB4N5ncs0rg3EgW1eRGE0skYNV9HZCGg+CFuWO6korno065I7thH7VhjycQMsqwit3S3OBU68WFifQ2/7QpY92XhFEehz0/NNv09fVzdku9ZhstZ02YaxOeONG6w17Bm95UKUGRBFcDMFWbgwUBNSzAPIvfFQy6NSr8rdchav72t00f5227tXsnhEU3cjnGJusNnMFmriXKEh7TiLaYKeXSeBU4PwaM2ixGe9n61iER1q1fYfHweY2PvqcxECfTYUVnIm0lYX96OpgyLQMmG6bKC/mXONgo5ITM8n4e2DUEEgQYTGpWb3uq+ajEXwG63ddcgtf/w9UVxCRWxf05M9LAv7Cc3kOCKb+zVao+FtQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 13, 2026, at 12:07, sashiko-bot@kernel.org wrote:
>=20
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Low] mm/hugetlb: commit message mismatches
>  memmap_init_page_from_template()
> --
>=20
> commit 7cc97c08b2296fc2518d9ae6da5950cb731c48eb
> Author: Li Zhe <lizhe.67@bytedance.com>
>=20
> mm/hugetlb: optimize bootmem hugepage tail vmemmap init
>=20
> This commit speeds up boot-time HugeTLB tail page vmemmap =
initialization
> by seeding a template from the first tail page and initializing the
> remaining tail pages with memmap_init_page_from_template().
>=20
>> Initialize the first tail page normally, then initialize the =
remaining
>> tails with hugetlb_init_tail_page().  This copies the already
>> initialized first tail page with memcpy() and refreshes only the
>> PFN-dependent fields in the destination page, while avoiding the full
>> __init_single_page() and prep_compound_tail() sequence for state that =
is
>> identical across tail pages in the same huge page.
>=20
> [Severity: Low]
> This isn't a bug, but the commit message appears to describe an =
earlier
> version of the patch.  hugetlb_folio_init_tail_vmemmap() copies the =
first
> tail page into a stack template and calls =
memmap_init_page_from_template()
> (which refreshes the template before copying) rather than a
> hugetlb_init_tail_page() helper.  The commit message also omits the =
change
> in memmap_init_page_from_template() that restricts =
memcpy_nontemporal() to
> ZONE_DEVICE pages and uses memcpy() for other zones.

My bad. I forgot to update the commit message, the corrected commit =
message
is as follows:

Boot-time HugeTLB allocation has to initialize tail struct pages itself
when HugeTLB vmemmap optimization (HVO) is unavailable or fails.  For
gigantic pages, this can cover a large number of tail pages.  Most state
installed by __init_single_page() and prep_compound_tail() is identical
for every tail page in the same huge page, so repeating the full
initialization sequence for each tail page is unnecessary.

Initialize the first tail page normally and use it as a template for the
remaining tail pages.  Before each copy,
memmap_init_page_from_template() refreshes the PFN-dependent fields in
the template, avoiding repeated initialization of state shared by all
tail pages.

This extends memmap_init_page_from_template() from ZONE_DEVICE to normal
memory.  Keep memcpy_nontemporal() for ZONE_DEVICE pages and use
memcpy() for pages in other zones.  memcpy_nontemporal() was also tested
for the HugeTLB path, but did not provide a similar benefit; on x86-64,
memcpy() performed better for this workload.

The fallback path was measured on a v7.4-rc2 base with a temporary
jiffies-based printk modeled after the existing timing in
memmap_init_zone_device(), using 4K base pages and 64 boot-time 1G
hugepages.  HVO is unavailable on arm64; on x86-64,
hugetlb_free_vmemmap=3Doff was used to exercise the fallback path.

  arch    base      with this patch  reduction
  arm64   360.8 ms  256.0 ms         29.05%
  x86-64  171.0 ms  165.0 ms          3.51%

>=20
> --=20
> Sashiko AI review =C2=B7 =
https://sashiko.dev/#/patchset/20261113033442.62970-1-songmuchun@bytedance=
.com?part=3D2


