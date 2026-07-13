Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3ADCC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 23:45:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1463C6B0005; Mon, 13 Jul 2026 19:45:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F75C6B0088; Mon, 13 Jul 2026 19:45:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F03D26B008A; Mon, 13 Jul 2026 19:45:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B90EA6B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 19:45:44 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3E0CBA0195
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 23:45:44 +0000 (UTC)
X-FDA: 84985388208.20.9F3620A
Received: from fhigh-b7-smtp.messagingengine.com (fhigh-b7-smtp.messagingengine.com [202.12.124.158])
	by imf17.hostedemail.com (Postfix) with ESMTP id 43B3A40009
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 23:45:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="j frxqIh";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=FzgXiVZe;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783986342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VrQ+955Mhao6xQZoL6uljG/95v6TMiuQHwTATw9a67A=;
	b=iocfeKCWBUAIx6S5TQrm+Oavy9GSDFUZFgvtkVSu+6atHETlf3aoP2HCirIvDoJcbKYHEc
	xvYh7qlfV4WCp9FNCV2HOxpq1V+VrLaW2Lt/AqBqGmUwPfbSO2w+4Bum+g5ncBkmA2O+2j
	wsskVjyAIhDhk+H5D5jztIhRx/vH/cQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="j frxqIh";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=FzgXiVZe;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783986342;
	b=R1wNK5K2z17fcSMNIQgVJK41IcioXliUQl8N30G0DkANBBwfCsdE+nM/pF7BT2/MTZfehw
	k/Vy1KC+prV8GD7jZYeoLvAOk3uuUUK+SY6PXJMAajr+qxhFiHwfz/DpDsy15dn6B2e02T
	duTjFIRBvVj+BTVjrADCLyIo7o1/1mY=
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfhigh.stl.internal (Postfix) with ESMTP id BA2077A00EE;
	Mon, 13 Jul 2026 19:45:40 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-10.internal (MEProxy); Mon, 13 Jul 2026 19:45:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1783986340; x=
	1784072740; bh=VrQ+955Mhao6xQZoL6uljG/95v6TMiuQHwTATw9a67A=; b=j
	frxqIhbjwK3BfoLSXujJBE6K8kMuqrBzd08zOSlwiSLPIrjhRm95J8KNzqh0Jmwi
	CZ7qwJrMib96bL76SAQb6BaL0s0lbWX7sbSciwEpU8vfVbIz6cyY7k/BAE7ylRVa
	Io+hQLuwV63LD7rqPQZR4Pvj0AfAKZKqF8aNgFCU88Ui0UrEG2homUhJnMqi9q4M
	wJLtyiBL3nI5s5ZMt981jT1yBu1fcBVnXEtNSrPpZNF+O9pZ1evqxuFRMCL06sp7
	U51lWGULXKuN94yF116GzunF7tDhS72Wd1VaEwawRsRSrfJiquo4i5f82KER7v50
	dV8dv9YcGFc9IX+6uyHhA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1783986340; x=1784072740; bh=VrQ+955Mhao6xQZoL6uljG/95v6TMiuQHwT
	ATw9a67A=; b=FzgXiVZeQBltyfp6nso/GKvXzGuPfo6S0L6TiOmBZ2pktXJ0dGL
	mS4t7C4877NF0SpSVvBf6PvOqfktudesZxEGqOqWmORCDss62t0t/dMak4EtkyXq
	ntHDkYcoJfs7+N1ubk3jNSIhWdZuS8wSl6QhHGY24So94Tv6XxN9g+Gkd7jLtPub
	il4sfbEDTkZyWIvIFdn5jND93KfXcbYZAFkZzJ0FcZnpsBEoz/PDC2bNwYo1bDAJ
	OPH/cyl2uoYyrJNdWs8LHpt5qVJlZOFsror6fH4ZTJl0jjbDTRsprDItVUQCO6U2
	h95STcDAQc8VeNz899dwVKC0utt1Mfri87A==
X-ME-Sender: <xms:onhVavHzUhTCIV5GMP_OVvsWml5qo8uv9TXW10sq3ByZ17mOuwCfLQ>
    <xme:onhVauoHoqsggGB7U-cm-ONdyrOFiZ5I5uDv7O8zqlaDDRlwfwJctTH80Z3U9QvCe
    oQZ8eYdg_1TEhl-5N1XXeHPiLZ25J6FgkwhV9Wrolgq-gVx0HhaU5U>
X-ME-Received: <xmr:onhVav33pPscabYLF4rLUyV1nS0w3T0WRRGu2w7bb5yZZmAW1SHU-udPYfgBiQ>
X-ME-Proxy-Cause: dmFkZTGzcd7fELHA1Uwd4cZ6HoYyqGLPRUT63qXpsTSJ0yrBG7mPaQ3t9ryEFvgsjbwBuk
    h0ux5BqP/B3LH4CEFgsJ44aHyJew1sL/dBmL73bi6vZ0KIwGRS/JCYLLzi2CGOE0P70lzQ
    i269kHR4HI0qjMwI27+kygv3dzGtubLKJEqLIh7aqmab4Hh2iUT1cK2horAL/YZCQkaGnR
    H1DMPyAJUS0uF0dVWgXRUiwTZZvkU30yh5oWDsfb/Om4HIFSbGB96AODhwyrS5EMmVA0xB
    t0NePZ5mXrkd8c/zqpm9JJaTlnvmmj+oDnKlb4rqhk2BFkZ9UmvuOr7bbhcd9SGBS/UQZX
    9lwjqa7IJ5pOTY+eRuRJBbG3n33wyYJEHFuJTMR+HA6DiFKh75vKL2iFgBhDJd8J2aww2G
    83pZ11CTYMXizdt/7QB3w9cw0Qek/OhZqvPQRVptHvKtPSQQikCWzCwplWlap1QGqFtZd5
    xaP7uMGlgIGFY+y6aomC/2C96fEwHxlDtHBZITCsuohCLanyRrpp5O1A1yoGMBkwWfDuaE
    +qzlI1QrcqN9c9I5fQLuvEeLmCdmaQRJREw1eWElod9JetFGBV7lN963Ko+TYkGbvAOAwY
    4taMPCXUW3a4PBy0/98L7KmusyIrG9V9Miwuj4Y9GF78Um49P+ivwA2ltgVg
X-ME-Proxy: <xmx:onhVaqD6c9gf5inmPwBNVa6OdROhn2pLoBPB2uXI5UVrXjK5djyrRA>
    <xmx:onhVai-TnsU_lUoTs2SSZ45KtGZYWrW_uwS_RTUazvli8vxsJUUS6w>
    <xmx:onhVagOV5D3KtiZsmT56IILzBGsuZRyTv6tiionjc8hGHwS5feRcgA>
    <xmx:onhVakE6bbvczHlErUQDa8KRjkErDcAOjF4r2iiYbdm-4UvH5mBXSg>
    <xmx:pHhVahB1TCboJNlWMaQmHOs4yZkaQNyrGSANpi6CJ8pVqTIUto7j0fas>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 13 Jul 2026 19:45:38 -0400 (EDT)
Date: Tue, 14 Jul 2026 00:45:36 +0100
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
Message-ID: <alV3oLwvbeQsagsA@thinkstation>
References: <20260713170915.239819-1-kirill@shutemov.name>
 <20260713161341.eefb7ad32bca25ffc8f3390a@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713161341.eefb7ad32bca25ffc8f3390a@linux-foundation.org>
X-Stat-Signature: 5gt69x33rwhnj54ptku5idb3pyqmm3xk
X-Rspamd-Queue-Id: 43B3A40009
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783986342-734710
X-HE-Meta: U2FsdGVkX19F5R+CBNwZLDMWH2ZJkkE1m3VCBWT3WMgdEv+gM59QpGf1OKtBLX3lhdprvQiIoG8hWKu0phsT+66MCrP9nECorwKaOTR11Uxu8dD2ZFRMy36yfuWEL1wwRj6+Xyre9BZXU/PvIy0sHLFCz9yDKIp2JjSQ6bNyXX3N3UL9QEpzhX38csdU9mXd2VXOFu1Do6Z2JPjIlErWab5ETJXLnC/hgBSXeXvlDZr5nAhz5RWQ/oDN5VtFNRTAf3A1GmE+GYelJhvZe4HTfduouB+Tj19/Xy0mDUKaLEPcT7hrJdrdEo4jMNrEINs5kj7MFMTT+L6Ya7R39DmtKZyZNgVQjLApHSzr/IUT2jUHyTH+y/4FwCt8r8eiEOrxi3koCr5+MB81Zn6/MlullaFSqItCPkz/WpuHxkprrdHolK4kGNF0E8xvt1AB0lg3q0p7VTBg1eI9lPwgEiYVO82Kt4jtZN4gOXjrCLz+Kx3IZjx6ChVNn1Z80NzSAFW46uy7Q8l/gZF5mxk3PSC1PeNxcNtu+FhfM4qyYTKcNrpZYJbpisB8IEhnmlKw1XvovVv5+Hg+4IKkHaGL7JVVW4m/97HganN9DBSV0Ow//UgzLQgXMYHAqZuX5jF3+VvAIh5c78HxqVTwRMR10ip/K5w6I/9kxKvmwt4A/BS6IY+5SC8jzXozUTh4Sn3dB4Nra5ZUk5yoieB0dYKQFoYlLyLfe6LqiszGo98i/VW1Ipqs0BVuTTVysqrob8c66BZFS63oUrbud02Bk5W/fALEKnolsNOne33mtkimFvTo/24Qj6deBILnkQZpD+VXnTRKwRhPxNcfhPUmIY0kqFAu7lY7swT7Schm9Dk/bHD88KOkRxuNKP04/zs/FK7KVFwdnnckX5kNMPKuYuHgpVgREuUVF0SMCwfl28Yskjx0hMdO+jbdJR21qqPb9X3m4VGQhAFhHh93Mybl0J01w/2
 4Jhn+1+m
 UsZMHgkvFV1+kC9B3zUVOeg7uB8N7zep6nbA1woGth9dn58qUZKW2lolZebVgxpS1hVQfXqQMHH8ZPpbsr8DDStwYbGy7x6X8a8zZ/VT6SX/nOfkUh+IGjyl+mCF69+yGLOuxM7JYJdsY0nxilJtNJA2GUOwI8OGwn8tM/LlW8cwYGHEyhsTAVzhYFvuAkCBzfnPSzuFJofKBSMAnrNkw7frLVaoLsbJw9gLwoAnRsU4r523PitiKdxiuT1HXo5SgIKjks2QWK3irI3APG7QTBTiJCjvK55N9+gCWmctFAc4CtaH9chbvLwKUF9AfsxhzU0LA2vKvSeZ5vSPeO5cxaehbZ0NTCKAzF94uThKNkzPwYjhxvhDGJS6cH0I4SXKO6kb26i+41LQqRBSRjL/IlCKcW190eLhwJXQQNdi6Dqk34nlCqvGF81tVWyx74dgJo/nBcckcgiV3FcZkFkX0DkbahE3szl1yg9mbFJlg+q2UotqorA3lilg4Zw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 04:13:41PM -0700, Andrew Morton wrote:
> On Mon, 13 Jul 2026 18:09:15 +0100 Kiryl Shutsemau <kirill@shutemov.name> wrote:
> 
> > From: "Kiryl Shutsemau (Meta)" <kirill@shutemov.name>
> > 
> > __folio_split() looks up mapping = folio->mapping for a file-backed
> > folio and keeps dereferencing it after the split completes:
> > shmem_uncharge(mapping->host) for folios dropped beyond EOF and
> > i_mmap_unlock_read(mapping) on the way out.
> > 
> > Nothing holds an inode reference for that duration. The split relies on
> > the folio the caller keeps locked (@lock_at) to pin the inode through
> > the page cache: while it is locked and present,
> > truncate_inode_pages_final() in evict() cannot make progress. But the
> > split drops @lock_at from the page cache when it falls beyond EOF (the
> > @end handling in __folio_freeze_and_split_unmapped()), while keeping it
> > locked for the caller. That removes the last pin, and a concurrent final
> > iput() can then evict and RCU-free the inode before __folio_split() is
> > done touching mapping.
> > 
> > This is reachable from memory_failure(): poisoning a tail page of a
> > shmem THP that straddles EOF makes try_to_split_thp_page() split at that
> > page, so the dropped @lock_at is the folio returned locked. The result
> > is a use-after-free, e.g.:
> > 
> >   BUG: KASAN: slab-use-after-free in __up_read+0x634/0x790
> >    i_mmap_unlock_read include/linux/fs.h:537 [inline]
> >    __folio_split+0x732/0x1640 mm/huge_memory.c:4100
> >    try_to_split_thp_page+0xab/0x390 mm/memory-failure.c:1675
> >    memory_failure+0x1394/0x26e0 mm/memory-failure.c:2470
> > 
> >   Freed by task 4601:
> >    shmem_free_in_core_inode+0x54/0xb0 mm/shmem.c:5177
> >    i_callback+0x4c/0xa0 fs/inode.c:326
> >    destroy_inode+0x144/0x1e0 fs/inode.c:402
> >    evict+0x57f/0xac0 fs/inode.c:870
> > 
> > Pin the inode with igrab() before the split and drop the reference with
> > iput() after the last mapping dereference. igrab() returns NULL only if
> > the inode is already being evicted (i_count 0 and I_FREEING set), which
> > a split racing eviction can observe; there is nothing safe to split
> > then, so return -EBUSY, which callers already handle.
> 
> Sashiko is worried about iput() while holding folio_lock():
> 
> 	https://sashiko.dev/#/patchset/20260713170915.239819-1-kirill@shutemov.name

Sashiko is right. If iput() drops the last reference and
@lock_at is still in page cache we would self-deadlock.

I don't see an obvious solution. Will think more tomorrow.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

