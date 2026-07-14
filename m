Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED6F5C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 10:29:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9892B6B0088; Tue, 14 Jul 2026 06:29:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 960906B0092; Tue, 14 Jul 2026 06:29:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 879756B0093; Tue, 14 Jul 2026 06:29:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 51C4B6B0088
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 06:29:45 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B6386A036A
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:29:44 +0000 (UTC)
X-FDA: 84987011088.27.3A6308C
Received: from fout-b6-smtp.messagingengine.com (fout-b6-smtp.messagingengine.com [202.12.124.149])
	by imf25.hostedemail.com (Postfix) with ESMTP id CCB1FA000D
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:29:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="d PIydHw";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=XC07vfoK;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784024982;
	b=SkkHuuFujcs64ToKYkH79wVYNLM4RayTOge9oWCF0wmzgnTSq7lgNEihQYaol6OPDLVOl7
	WQiUkPt0q3LJwmv8JoB+asFAumLUnuely7OUQ6Rr1k/6EhA7Tu+0rpKAm1l7DhOWmdi5jm
	nHYiRJ4xkHaWXkItIKWsj1ruqPBmTHk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="d PIydHw";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=XC07vfoK;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784024982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D/druKhd9IvNef2J0pJK27qVVVk4qI3tVilOxadA1e8=;
	b=Js9zA5aFPHeuZsUKucjUe0DyZX35LRTJfO7ntpMkDA0HB0lUjzK8pvHafGcHDzPDSYVT/5
	JPz0pGBd9gaLehEl7uDJzumimxxpE7YcCTW5PPWxsjlC2BlZI2otjdBDGuZfVZYEJGPAda
	4ksKYhkjm6jrwtcGYyJJDLC/Y28mHcU=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id 77E2B1D000B0;
	Tue, 14 Jul 2026 06:29:41 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Tue, 14 Jul 2026 06:29:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1784024981; x=
	1784111381; bh=D/druKhd9IvNef2J0pJK27qVVVk4qI3tVilOxadA1e8=; b=d
	PIydHwDr3/Tg+Hi3OkA+1QoItUIckCj1nhbg0b9h5NSTS4gYSsFuoy2CSmb4AQNM
	orGtwGN9bp1pQGPWIkLrQmBvjxz/NV2ZrMw1GV6Atuw959cnU4Bia6H95pTC7kSJ
	JzIs7af1KEx3MvzY287uWhUdNSmtKeDz5ma+OkrFdlEwji5qjGk1KpSRekLidyF4
	bmLmHz8OxCYK3sJ9DOlFXi+J1mLwXkiX2KAwTr5DbggRxxCG8NIVadPs2FIUMW4U
	pyr2yRot8Ueq1amRdyxZwkfgYgXtdJL2Otk+h3Ko2716sMcgQj0od8BYId6LdphJ
	NCjWM730NBRX2Oxc667Ug==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1784024981; x=1784111381; bh=D/druKhd9IvNef2J0pJK27qVVVk4qI3tVil
	OxadA1e8=; b=XC07vfoK4nsA+cBeBnFTMekbPtk+TK+HRAQIT64nptDzo2nmP/4
	vHUAPC58ZBZNMt4eSuuAKUz5bcsw55FSa0JZg7cYxxqujb7XJEUZkghyao8C5n1S
	BXco/DxCGNkmV7Zx59nQlrsGdcdJsVZiHpgA3HwEOlzJ//PYL+t8sPWZAkdPFAaP
	40iYrCS4A3lZtcciy8lT+msxcyDWHOUzT8+BusKWb5jnH0XjlR78NhQuA0QMHKSL
	sIMhBja/Dpu23e0OhjfutuCMCclE6g2HRfKjtu1ccUM/T/4ddH5fC8A1eVq30/bP
	tX95DSxT7eOfAec1VoEdK6nX95dTIaEvzXA==
X-ME-Sender: <xms:kw9Wat9C2QTeHF6-ePmUCQcBAUFGKePfFf5wh5wss2uh9V_8HVHPKQ>
    <xme:kw9WakB3I-eXBfmkWnUSUpQvDP3B5aduq9oh3HB8yYqObfBCvx8fhp7D6vjgoiRPC
    B4WbGVlmjbHEveoWiXwg622qP_Y-N1u-LaAxUbC_MMtElP8Nf1y3I4>
X-ME-Received: <xmr:kw9WapujENMK8sn9Fr1bprk9NFRT9_p6wahvM-bDtzBN1p_D0fb45Dta8x2J7A>
X-ME-Proxy-Cause: dmFkZTEjQddmFbvKigDMQdRqPJ9XSi1XrBW+ZC8BP7zhnCiYnrJnKj9UHprC+RU4ycuqir
    wV2GJTTRlRcTN/CyiH+ODp1oFJ0eBsmClA3QYKTzOlBg+03PAxve7QMoYT1uOexdoEKBHl
    3D2PiTA4kPq9gZAetGrReve0e9NbA5Lj5KTZMrwybItPm9IQH5qiiBz+sOFqdOHWjvibSB
    uSjuhGtKEyH8YUM4yLTvaYcQLtEM6zfk6b3p8QJ2wQ+x/1luB8vJvYj2DuGjcrEsBkbwnh
    Tl3VozsJM7BFQNSjYATBTvTc+zLxNS4S+NSy5bPvx9nbwkiBt9JqIEcfzhOy7t9Q1qEdJC
    OYTpVUjelx4tRsH9EaKnse8jHJMVDHuw96Z5hTUcOva+qHMp6m+4X0XhgabBRrbWtC5Y1B
    1PUTKJNyvqBrC0azgWq2E85ld4QJ+i4cOEUmlVbbiXDaV4jBYbyDT1SVC0MZnraB/ySvuq
    wYzDVHnqNvCWXcHdlJNN7gp9qY8Vtv6eg5N6I6fv/47U/dWmMoilKh+2iZv/HfFYqjXUE2
    D47+tLGrxVKSAZzXNcmzQZjcbgAzKp4mem39Zv51sEXOWi6fgdxfHybzU4lAuLTR4UfUy2
    2872xGer3gtOh6wB2hmMtPVmX4SnCARpvYsE1jSvz8F50O6wO7gpFY9xb6JQ
X-ME-Proxy: <xmx:kw9WauYAJIfJyg9M4SXs_Nme2bzDJoeSCD2CPzGuUIGS9gmopEAAbA>
    <xmx:kw9Wav0ivMgNKptookebq9rZ9_P4eP_h7ViSgZpv68k0bLYrL9z8wQ>
    <xmx:kw9WarnjlVZo4mEjG2GzGSVUxalHgCW_BhhAiXbwWn6bXLqcTjy_cg>
    <xmx:kw9War9Ba-_ihxLsCURfA7Y5LobYraL9QZ7ZtLpo1QVRbaMPs093xA>
    <xmx:lQ9Wap6J8O2PmRR8gtF5rczRAW_O-D6kQgsOgb-g7nQ06yXGRKFH30Kn>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Jul 2026 06:29:38 -0400 (EDT)
Date: Tue, 14 Jul 2026 11:29:38 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Hao Zhang <hao_zhang_kdev@163.com>, 
	Hao Zhang <zhanghao1@kylinos.cn>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm: thp: pin the inode across a file folio split
Message-ID: <alYPE1CDJE4HaP1J@thinkstation>
References: <20260713170915.239819-1-kirill@shutemov.name>
 <20260713161341.eefb7ad32bca25ffc8f3390a@linux-foundation.org>
 <alV3oLwvbeQsagsA@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alV3oLwvbeQsagsA@thinkstation>
X-Rspamd-Queue-Id: CCB1FA000D
X-Rspam-User: 
X-Stat-Signature: acronhi9darojwc1p9bg9pix9gx8wp5m
X-Rspamd-Server: rspam03
X-HE-Tag: 1784024982-77826
X-HE-Meta: U2FsdGVkX18whmJjr2XxIzLZKCn1neE9GY6rDtE6gVtmEaoHijS7ScANoS+FkiNA4Ba1OHhrxXzoJvfwKQbYzfmpmdybVHqXziDFbudFmn58h5wDz4S4o3zLc5lXJGEr9O2rUkuH9Zoid+xXUNpPlfq6gWu4/dJVyuPSfIjcIwpO6+VU4Yd+CeQ/CujM+hcw9hfSR87HJjXIerWLbHaoGxvMwMTrj3D2rdrzmAGQUDjd4geJuLWaXMiVg3fxNcexsvLBaomh190g2+GG7d1Ng71I02/3mxO5aW82gzAYqWUAb+YIxfAVX1azNpYiH3UY21dT0D6NC26p9d4ry/Ox5UuQAeaONSIOn3OM5BgRZbCIlSSnptA0DVNUr09IU1QlPT93QjzZSXEdTKxZQU7bT6fo4GI5cHMSF2suU4gH76ZBoX/sH01qtAimyIhusDdv7jq5Q1yhg6XKqJujiw3FvKgoRT9vYG6H58LPA30FTW9vMFZYDUyVHMGFETcMeGffxd/9lGYRYArrRA9LWadSkCBSgXNoGa8WHXFfNJ/FoGxDFPUevT9ha67BTleevvrAzWOdzaQPUnJi8a3X9tEDUt7rhA9eNGaREjsC2tIfukfxLf2NVVFTrQumt5rbkbsiBZpA26nSDWgEk7Vs3SR93/L+pDao6yZsTfQjM9hisH3SvfyEx+VjwnhPIy4xGN3PBgZBIZ47eaFRWBzaNk4z4+j2qKWlGadPEhkSN1YJJ81R8dASRkbBIrNA9l1yHLVOfmWhFgvDo6/Q+mnfjpELbBZ2sZ4D10E3LUgrU08Tqg3EhJhxxLqSIpA1Kj1OwiiAs5WOCy3OJg82h6vb+BvD8ZA25CXqzFx7yBZznue+aTLncBCgKKsBXkiXsX7IF7jqOrj7F5XD/fPqPTevpwMx0n0DRfV/fXJWCQBFTwtJBCzcUpPaALl9Oi7duPZ0TSp1sotvLMUlZKV528Ok3YV
 5M+3ax+c
 Qn+SbYc2IHyvfqxx+uykeN6AjZGItvmpaTSXQFXcpwnTrzcV6hO/pptxOLlJdEC1tZRIVLd+EyIgr2bHeoka/9AwHpmDpRIA5YLZYhOSRhFfc5f9YkNkYszXIYNA/dZkGhe9t+LOnr8yqIJQSuyKFHC5C/rCYQiz+uoBf1iU+iRaid996sI7a5/CbzdDJpkhRV+LwqWLp1RUy8jCdU3ms8MgxNcC3X+TL4DP9t+Xy2pwWkS8iqMgPetY4+2F/zMu3iKqDfeKp/EZI6ssL/+2Cp2ELAQOKhThqN0XQ7TU9i6RpsEPeIGPpZCwutkwKSDbqBWB77Pnip9dLgeBQWWpME8ONz74avgLW7I0Tjux2FVNtvlcIK/vcH7XioY86fSOyXeN8SxL2/CX6d/hp9QjyBtivuTfrOLUYjUt4JjiGUofUE4GvTCaUXqgnfoHkSyfukEM9vUh7iqdjMf6X1iBCiDk4cT1gU7Lb+E7WjGG1/upxVV9BwImqev4BsFiEw8wki5oAl/B+5AZNPnJ42xY0hG0FAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 12:45:41AM +0100, Kiryl Shutsemau wrote:
> On Mon, Jul 13, 2026 at 04:13:41PM -0700, Andrew Morton wrote:
> > On Mon, 13 Jul 2026 18:09:15 +0100 Kiryl Shutsemau <kirill@shutemov.name> wrote:
> > 
> > > From: "Kiryl Shutsemau (Meta)" <kirill@shutemov.name>
> > > 
> > > __folio_split() looks up mapping = folio->mapping for a file-backed
> > > folio and keeps dereferencing it after the split completes:
> > > shmem_uncharge(mapping->host) for folios dropped beyond EOF and
> > > i_mmap_unlock_read(mapping) on the way out.
> > > 
> > > Nothing holds an inode reference for that duration. The split relies on
> > > the folio the caller keeps locked (@lock_at) to pin the inode through
> > > the page cache: while it is locked and present,
> > > truncate_inode_pages_final() in evict() cannot make progress. But the
> > > split drops @lock_at from the page cache when it falls beyond EOF (the
> > > @end handling in __folio_freeze_and_split_unmapped()), while keeping it
> > > locked for the caller. That removes the last pin, and a concurrent final
> > > iput() can then evict and RCU-free the inode before __folio_split() is
> > > done touching mapping.
> > > 
> > > This is reachable from memory_failure(): poisoning a tail page of a
> > > shmem THP that straddles EOF makes try_to_split_thp_page() split at that
> > > page, so the dropped @lock_at is the folio returned locked. The result
> > > is a use-after-free, e.g.:
> > > 
> > >   BUG: KASAN: slab-use-after-free in __up_read+0x634/0x790
> > >    i_mmap_unlock_read include/linux/fs.h:537 [inline]
> > >    __folio_split+0x732/0x1640 mm/huge_memory.c:4100
> > >    try_to_split_thp_page+0xab/0x390 mm/memory-failure.c:1675
> > >    memory_failure+0x1394/0x26e0 mm/memory-failure.c:2470
> > > 
> > >   Freed by task 4601:
> > >    shmem_free_in_core_inode+0x54/0xb0 mm/shmem.c:5177
> > >    i_callback+0x4c/0xa0 fs/inode.c:326
> > >    destroy_inode+0x144/0x1e0 fs/inode.c:402
> > >    evict+0x57f/0xac0 fs/inode.c:870
> > > 
> > > Pin the inode with igrab() before the split and drop the reference with
> > > iput() after the last mapping dereference. igrab() returns NULL only if
> > > the inode is already being evicted (i_count 0 and I_FREEING set), which
> > > a split racing eviction can observe; there is nothing safe to split
> > > then, so return -EBUSY, which callers already handle.
> > 
> > Sashiko is worried about iput() while holding folio_lock():
> > 
> > 	https://sashiko.dev/#/patchset/20260713170915.239819-1-kirill@shutemov.name
> 
> Sashiko is right. If iput() drops the last reference and
> @lock_at is still in page cache we would self-deadlock.
> 
> I don't see an obvious solution. Will think more tomorrow.

Andrew, please drop the patch. Zi and I are discussing possible
alternatives.

https://lore.kernel.org/all/alYNlDNMQy0Fl2VB@thinkstation/

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

