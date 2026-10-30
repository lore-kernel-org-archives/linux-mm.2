Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DA55606A320
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 21:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=UYqilgg+
Received: by kanga.kvack.org (Postfix)
	id 62FC66B05B1; Fri, 30 Oct 2026 17:08:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E0C86B05B2; Fri, 30 Oct 2026 17:08:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A8446B05B3; Fri, 30 Oct 2026 17:08:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1F7626B05B1
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 17:08:19 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F16D3120838
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 21:08:16 +0000 (UTC)
X-FDA: 85380530592.21.1E2AF3C
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf09.hostedemail.com (Postfix) with ESMTP id 75652140006
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 21:08:14 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UYqilgg+;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf09.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793394494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VuNZ7cfgkn64XZBhopOwYjZ4PrGgE6PweZ/cwTmJkNg=;
	b=5ESfC/VsQaVP9ZgeObAEXcMZ7jjNkrE1vYW9o4dLPARD6pfmGvZfszV4nJzEp+CIjhL1DR
	T3ExqQLRuHkEOhvXjYIrKpf/qe7olIb80uxtijCpHcmnknQSf6lgi1xj6neJwlpo9d5pfD
	RY7trpilhHEqM5BGMZTFC3vESmyk7hI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UYqilgg+;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf09.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793394494;
	b=sDxwjtylibLJNfT0kaRw2tfV56/7FkoWjDx/nB9YyLA6iEXHF4XHbP3bldbwgpd22MWGGD
	5XZEomaHOlq1BdlGi6OMOGtgoexsPUZmwq17bOUMHP/MFhOnlZbW/16KdQsuhMl7VJWEQk
	TsPUwANeR3TWzNp/VvRDcfU33uEmLGY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793394495; x=1824930495;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=JfsC+5Gm92RBF81R+5io695VP7oyD4ZIWHKa/oplgeQ=;
  b=UYqilgg+EDYe+jV53fi680Pr2cVIMXhNYtyFOvIjxxtJACH+NR9YvsZZ
   kslHvCA2iDwPtWLYRl++r9tACaBAbcJA+3OY9ewJgYe+Bul0EgfiPSYFz
   jlV1u8keyYah8q+vx6+YLo7P6HllGPRMV7F1VVXkAx3LSAdka7vfSSN85
   XP0WhsOccqdLbd8RFY1lh37IMtr51cJSsmtZerVZyGGgMHR6D9Hixrg9U
   YJIn5RcUtE/58rx2HDITm5bpXQdJQLz8xaohzdb3fYTOziKqqhqlQJiJK
   ekyjCJbk1fTOjrWGQc3V3IcdA95+aqSrQkAmJgcDmDBkns+ddIThBYCYf
   g==;
X-CSE-ConnectionGUID: ZpZhZXtqQRmLHsULyA6a+Q==
X-CSE-MsgGUID: H9jXaBXkQsy4WWQp1yTOEw==
X-IronPort-AV: E=McAfee;i="6800,10657,11951"; a="2170686"
X-IronPort-AV: E=Sophos;i="6.27,186,1787036400"; 
   d="scan'208";a="2170686"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2026 14:08:13 -0700
X-CSE-ConnectionGUID: j6W+B9UvRdWl0vyRtc/1ZA==
X-CSE-MsgGUID: dnK4t5d2T0+au4hpgrffAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,186,1787036400"; 
   d="scan'208";a="5622615"
Received: from schen9-mobl4.amr.corp.intel.com (HELO [10.125.109.99]) ([10.125.109.99])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2026 14:08:13 -0700
Message-ID: <6f2aac82469fe90c8902e6e018b6259e3503fee7.camel@linux.intel.com>
Subject: Re: [PATCH] mm/hugetlb_vmemmap: Fix usemap overrun on nodes with
 multiple ranges
From: Tim Chen <tim.c.chen@linux.intel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton
	 <akpm@linux-foundation.org>, Muchun Song <muchun.song@linux.dev>, Oscar
 Salvador <osalvador@suse.de>
Cc: Frank van der Linden <fvdl@google.com>, Mike Rapoport <rppt@kernel.org>,
 	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
 Mohini Narkhede <mohini.narkhede@intel.com>, Pooja Jain
 <pooja.jain@intel.com>, Doug Nelson <doug.nelson@intel.com>
Date: Fri, 30 Oct 2026 14:08:12 -0700
In-Reply-To: <6086c386-3903-476f-ba55-bd6c21072f72@kernel.org>
References: <20261029212137.3141875-1-tim.c.chen@linux.intel.com>
	 <6086c386-3903-476f-ba55-bd6c21072f72@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.1 (3.58.1-1.fc43) 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Queue-Id: 75652140006
X-Rspam-User: 
X-Stat-Signature: jzmwcysk8qxp6eqaji191cgydhjxgqsj
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793394494-684730
X-HE-Meta: U2FsdGVkX19CKYrlFywBTGNZyli+/91rG/AQK5iOR4F0kHxNLHsnk9IYWUElWBtMoW2wfOh0LMier7hZ2F+E0eZtdlyXSqf+8TSxcrh4yeUEAhhwkfSOaB70HwhEemAr1iqQIbOE63LAJ9Sh09qbS85kz3ZZ96+efR+40PMIQOEIhXegFDrFb0hB4DuRGFxNRD6oOXxXndThMyUp6pQAj4oTf9s2Viqc/L4PDzyMZpaeoZT/bv8gHqMSKBRc5qftovvV1XLmK8p3ed1vZwVXQIkZEoOjR73alnBSHxYxJW+88KNF2tdQkT+HpGRjj2sYSiKahf7DLGn/hRmggOIbj/FZVZsTbDfXbiCRUC8glaS7FdLHx1BjpCl9daxxiGJucTAw2Owqx7k4v10cdni4dmQrLzS/nP2DpH7JUnqN1oOzalGI6ICzgq8vnluBDUTTG6xTPvfMcugV6BmRHAx93oDpv2r0am+JU7Yq+dO8y1iHSSBhx/TQhVmEOadndi+iB4JZSvMbqxIQ83r2N/VUVEdSH+Fm+8W5ryEBF84NAvpAdj66HZlEJug0ru+v25G1Fz4ZmsvABjukEFVRN6R1koXgAsWGg7pL3lsRXsr60CVgLInKj42KeJhXjBKdkUgiMUfjxxSkx2AUU9eqeqa0uO1kHVrrtP80xb05XuYiVb4qV7zU11iA5bL4oANKdy3OE9T0UYt4RrPLuklB3L+wm4rFun62lT1JC+5oeAqcvdZIB/yBMnZGFUrQH7Wd9OCOtKbLf51OaFlEJM2KgpLcLD+jAVYAbxugCJtq8NO+bOZ05R3ppyr1VdKziyMQgQ3f21L3W6kIf9BAj/NQ8AH5BPB3iZhKJM59yQIn9IQnE+D1Gauc7klYzdVqMVb/hGOv2TUGoyhmh2C93Xq9w/rjL5UpBsUss1PbPr/0UAK8KzTiLwDOI8AcRE3I5xp2M357ozFC7pPILCn1XIQYgm8
 i6w8rzSZ
 uwbS/hmQ5zfml96rrVw0sXDBKZNpHdfcAgagWoLl/KtfGiNhpl1ClTkGhEIcviAv27PvbTcitAvj0s5wfkiGYYBptd/QCTb12h3GhrhibYMJmQSum5bSI6ffusagu/8CVHbaAge/zzjhu8GYkHwGJFoI2A2GARpLHinDaouZEqMT7QpQQ5Vf7Gl54QpS/43gIZHpT9LG91XnINE/d3J3K/vd5SiHHp2qj78kvRM8tngnx66rHnA8JXlgEggXqXaQKZts9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 2026-10-30 at 09:58 +0100, David Hildenbrand (Arm) wrote:
> On 10/29/26 22:21, Tim Chen wrote:
> > sparse_init_nid() allocates one usemap slot (struct mem_section_usage)
> > per present section in [pnum_begin, pnum_end), and
> > sparse_init_early_section() hands them out in order, with a BUG_ON() wh=
en
> > they run out. hugetlb_vmemmap_init_early(nid) however initializes the
> > sections of every bootmem gigantic page on the node, including pages
> > outside the range being initialized. If a node's memory is split into
> > more than one range, sparse_init() calls sparse_init_nid() once per ran=
ge,
> > and this takes more slots than were allocated. The same happens if a
> > gigantic page straddles a node boundary.
> >=20
> > For example, with this SRAT layout every node has a small range below 4=
G
> > and a large range above 4G:
> >=20
> >   Node 0 PXM 0 [mem 0x00000000-0x2fffffff]          768 MB  (low)
> >   Node 0 PXM 0 [mem 0x100000000-0x80cfffffff]               (high)
> >   Node 1 PXM 1 [mem 0x30000000-0x5fffffff]          768 MB  (low)
> >   ...
> >=20
> > In 128 MB memory sections (x86_64 SECTION_SIZE_BITS =3D 27), node 0's l=
ow
> > range is sections 0x00-0x05 (6 present sections) and its high range is
> > sections 0x20-0x1019. The low ranges of the other nodes are 4 or 6
> > sections, all smaller than the 8 sections of a 1G page.
> >=20
> > Node 0's first range has 6 sections, so 6 slots. With "hugepagesz=3D1G
> > hugepages=3D400", hugetlb_vmemmap_init_early(0) then initializes node 0=
's
> > 1G page at 0x67c0000000 (sections 0xcf8-0xcff, in its high range), and
> > the 7th section hits the BUG_ON() (seen on v7.2.6):
> >=20
> >   kernel BUG at mm/sparse.c:268!
> >   RIP: 0010:sparse_init_early_section+0x9f/0xb0
> >   RAX: 0000000000200000 RBX: 0000000000000cfe RCX: 0000000000000020
> >   RDX: 0000000000000cfe RSI: ffd7e1d09fc00000 RDI: ff252cb28ffb3f50
> >   R10: ff252cb28ffb3d40 R13: 0000000000000d00
> >   Call Trace:
> >    hugetlb_vmemmap_init_early+0xe1/0x140
> >    sparse_init_nid+0x56/0x370
> >    sparse_init+0x192/0x2b0
> >    free_area_init+0x7f/0x690
> >    start_kernel+0x64/0x540
> >=20
> > Here RDX is the section number, and R10/RDI are 6 slots apart: the star=
t
> > of the usemap buffer and its current position, which is the end.
> >=20
> > Pass the section range to hugetlb_vmemmap_init_early() and only pre-HVO=
 a
> > page whose sections are all present and within it. Ranges are disjoint,
> > so each page is handled once, in its own range.
> >=20
> > Skipped pages are not marked HUGE_BOOTMEM_HVO. Their sections get a
> > regular memmap from sparse_init_nid(), and the pages are optimized late=
r
> > by hugetlb_vmemmap_optimize_bootmem_folios().
> >=20
> > Fixes: b1222550fbf7 ("mm/hugetlb: do pre-HVO for bootmem allocated page=
s")
> > Cc: stable@vger.kernel.org
> > Reported-by: Mohini Narkhede <mohini.narkhede@intel.com>
> > Tested-by: Pooja Jain <pooja.jain@intel.com>
> > Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> > ---
> >  include/linux/mmzone.h |  9 ++++++---
> >  mm/hugetlb_vmemmap.c   | 38 ++++++++++++++++++++++++++++++++++----
> >  mm/hugetlb_vmemmap.h   |  7 +++++--
> >  mm/sparse-vmemmap.c    | 16 +++++++++-------
> >  mm/sparse.c            |  2 +-
> >  5 files changed, 55 insertions(+), 17 deletions(-)
> >=20
> > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > index 94f9c3ff54160..da17dae8b057b 100644
> > --- a/include/linux/mmzone.h
> > +++ b/include/linux/mmzone.h
> > @@ -2167,13 +2167,16 @@ static inline int preinited_vmemmap_section(con=
st struct mem_section *section)
> >  		(section->section_mem_map & SECTION_IS_VMEMMAP_PREINIT));
> >  }
> > =20
> > -void sparse_vmemmap_init_nid_early(int nid);
> > +void sparse_vmemmap_init_nid_early(int nid, unsigned long pnum_begin,
> > +				   unsigned long pnum_end);
> >  #else
> >  static inline int preinited_vmemmap_section(const struct mem_section *=
section)
> >  {
> >  	return 0;
> >  }
> > -static inline void sparse_vmemmap_init_nid_early(int nid)
> > +static inline void sparse_vmemmap_init_nid_early(int nid,
> > +						 unsigned long pnum_begin,
> > +						 unsigned long pnum_end)
>=20
> Two tab indent please in all cases here that you are touching, thanks.
>=20

Thanks David. Sent out a v2 patch with this format update.

Tim

