Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B15B0CAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 22:12:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14B938E000A; Thu, 11 Sep 2025 18:12:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FCD38E0001; Thu, 11 Sep 2025 18:12:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 012338E000A; Thu, 11 Sep 2025 18:12:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E14418E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 18:12:07 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 830F11DF321
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 22:12:07 +0000 (UTC)
X-FDA: 83878368294.22.0F8F632
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id D889940009
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 22:12:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UKOSrtqK;
	spf=pass (imf17.hostedemail.com: domain of deller@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=deller@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757628725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XWpJWV64GYdcAD/E/BiNmSu3qUiBBTsmA09VhnsQlGk=;
	b=1zpnJ/aDDQTmNVJ8tAPfI+sfIufxUo7f0HmdhBM/2d1DP075aHtCxzRShQL1N4/UOhUbko
	ipKtTDIOjsDVaA1rxP0r6rceV3tAdIsU1BeHsEUSGfzKOPlhBlWxICpKbDN4RSe5F5qE8V
	BIK0dMzGhTjjfxGW6mdl1KwWRGEeG9I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757628725; a=rsa-sha256;
	cv=none;
	b=BhaFEvhy6vAjFmyf+Z/BKwfMe76qGJY/GKQifahFPxdknXbWZNHgNr4Ujk3MBnI0EG9MLc
	gTZAwGMJ8k+RAuKhBqh8x2EoizAe2uPKsBtZAc/cZOIbmhwacsJUVpnpQ98e3s5nF7HwyX
	YzlrgEdM+gGFW+A2LQzsNIXC+/hclCQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UKOSrtqK;
	spf=pass (imf17.hostedemail.com: domain of deller@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=deller@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3755D601DC;
	Thu, 11 Sep 2025 22:12:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C6CC4CEF0;
	Thu, 11 Sep 2025 22:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757628724;
	bh=DeLh3i9NlJmc/TaFuy9SbAsEHHq0KJslJKPRhSgnwfo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UKOSrtqKQVZlMs9z6RnoiO9/kj9V+A1VDufGQhBGin6cryYHGL/O1aOqMXF6oTedS
	 sN84d+io1JlNFB2WR8QI54FM8QBQ/VHw7p/P27Q2eKjxZq+cnxIHQo7MLHcshuzxSb
	 Hsb/Fu9WaI01ggTmvYxCHPwvdrOM7wD9BPqsd6pXT5p5KpnpmoZ9HvT5ajYfZjD5jl
	 yUgVi/BBU2LCg61hR1oOYCyb2V9LCWCMuPmoMsLFlqeUg+bD7+ssp6bzXF2+0skMcc
	 Ouo0jKTC/WjXgm64Wsp2dt8HRkJBOTOUG7o6JhVDWkPnq7OyhLhoLx3EbHdDYtw5sg
	 tJoFqPr+ek1xA==
Date: Fri, 12 Sep 2025 00:12:00 +0200
From: Helge Deller <deller@kernel.org>
To: Toke =?iso-8859-15?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Linux Kernel Development <linux-kernel@vger.kernel.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-parisc <linux-parisc@vger.kernel.org>
Cc: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>,
	Helge Deller <deller@gmx.de>
Subject: boot failure because of inaccurate page_pool_page_is_pp() on 32-bit
 kernels
Message-ID: <aMNJMFa5fDalFmtn@p100>
References: <5a004aef-9df1-4126-b167-1aae27d4240d@gmx.de>
 <1756327287@msgid.manchmal.in-ulm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1756327287@msgid.manchmal.in-ulm.de>
X-Stat-Signature: sthx5idmsinmu61spxxakczetwj4g4sf
X-Rspamd-Queue-Id: D889940009
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757628725-740264
X-HE-Meta: U2FsdGVkX19OzbHPCyEzlj8FZPuVJ6k9UGdzdk6hLMIMvuKk1To5seg3JyVmIjDBsmAQiSaaAc1fCBQyhsIh6CPR9jH2Wr28mVtiD9j0FGceZ9ftBE7SZ1Uudkt6qo7d28s5vrPOSVmgrzNZEV7toyOH0Jbj8YTI73NHgS6rKhc/VvOfVOU8csd2g7lplvLL52L2Qqdd2C5pxOxfSB0XR4I32L5PnP2UWASr5MMVcy5kSP7O1gfUmKetConD49q+DKoNML/lDlHqQhmr26/dEi3K/s6pZeRS2ZVdlYra/At9rWKpTISKT4j+bbYT6/wsfLt9n6FPvsoRxDIG2jbx0a+ES07l4VMYfj7aImDTpzmXHEO7ryzBQYVAD0FSx67KYTMo/adVFXxhQlznsSJTv2d8rTd1zfFKY9UOYB3SMZEdFP7j3sIj7kpIDok6hI1K4Sgkm7gJ+765AEG/yIwWY4xjJMWxekIPdRuDj8Ulvm3NnK9YWbrm0yg90HeJrj3st1jhWU2hLgnfp0vYIMpmrD9vPFO6Aepb7nrfHnDS13Sk2vXNUl0drgehGi/L+N+h/Tpoe826LOe31bzq9gBVVUz0cTGGTH6AOYK5SWTSbenTiCBNtBMLMd8uSdY0N/5q4C3q3Cclnly+syBqei7bhKx15OG5X6/tZuK64gxcSg+uffIuupJwFDseDZvA9dfcA5CBJtI/c4HTpmW5zS/okhqmgsmDU7QYHUQd8R2oDIzm+yBTCnYYrk7MZvhRLvwc/nWr7XA3HqAtzdPbtQuhrHpMBGwuh/RLskmB4p5K8udBIfYkG6ZUYv5a294LVdm20c0euAW4CHX5BJHNDJM3p5Nok5eYnHhl80yT8XYnxFw1wUzMMJhnwzHE/oc/taVbT9ARtkilhSfjJ+n1Yh/0h1gJ8i9loUH8vSpVYu5AHr4Orxk8WPGfXKcCaXhmusr1msyT9kSRvlcqOwV+egU
 zyi+wOkQ
 5zVoMKrBU1S/vIItobdz+UBBs7FcuEYm5E2ZUS3IFQURGTwqj72JYTrg6iTwU0Ttcux6a7j25UmDS3YPzZwpNJ/bdTMKvB3/bEIhAgjoAODkupZGxHlkrsIrQgCUH00kolU64PvSeZjOdeDZ/kzSil8CQgidHxIQVhw5aI4Nk95GeJLBmT162UywNECE5s3t31KLkKyCVHno9Ak+MYYHJADxS/T04rvNU3d/scJTQ1ApNBtizadcQ/3V4kmQR7Os15QAq//fGo1ylp0BsLq++7S4aVv/ay1+HudyIWXsbjMB7+qakAcH52WKxLUBWt2SmXdEdaN6s86rM6lCffgZAaKBY9ju6F1Clonya1zB5QHmxVboOas1+WvdNi7sB5Tb5Ur6N
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As reported earlier in this mail thread, all 32-bit Linux kernels since v6.16
fail to boot on the parisc architecture like this:

 BUG: Bad page state in process swapper  pfn:000f7
 page: refcount:0 mapcount:0 mapping:00000000 index:0x0 pfn:0xf7
 flags: 0x0(zone=0)
 raw: 00000000 118022c0 118022c0 00000000 00000000 00000000 ffffffff 00000000
 raw: 00000000
 page dumped because: page_pool leak
 Modules linked in:
 CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 6.15.0-rc1-32bit+ #2730 NONE
 Hardware name: 9000/778/B160L
 Backtrace:
  [<106ece88>] bad_page+0x14c/0x17c
  [<10406c50>] free_page_is_bad.part.0+0xd4/0xec
  [<106ed180>] free_page_is_bad+0x80/0x88
  [<106ef05c>] __free_pages_ok+0x374/0x508
  [<1011d34c>] __free_pages_core+0x1f0/0x218
  [<1011a2f0>] memblock_free_pages+0x68/0x94
  [<10120324>] memblock_free_all+0x26c/0x310
  [<1011a4d8>] mm_core_init+0x18c/0x208
  [<10100e88>] start_kernel+0x4ec/0x7a0
  [<101054d0>] start_parisc+0xb4/0xc4

git bisecting leads to this patch which triggers the crash:

 commit ee62ce7a1d909ccba0399680a03c2dee83bcae95
 Author: Toke Høiland-Jørgensen <toke@redhat.com>
 Date:   Wed Apr 9 12:41:37 2025 +0200
    page_pool: Track DMA-mapped pages and unmap them when destroying the pool

It turns out that the patch itself isn't wrong.

But it's the culprit which leads to the kernel bug since it modifies
PP_MAGIC_MASK for 32-bit kernels from:

-#define PP_MAGIC_MASK ~0x3UL
+#define PP_MAGIC_MASK ~(PP_DMA_INDEX_MASK | 0x3UL)

Function page_pool_page_is_pp() needs to unambiguously identify page pool
pages (using PP_MAGIC_MASK), but since the patch now reduced the valid bits to
check in PP_MAGIC_MASK from 0xFFFFFFFC to 0xc000007c, the remaining bits are
not sufficient to unambiguously identify such pages any longer.

Because of that, page_pool_page_is_pp() sometimes wrongly reports pages as
page pool pages and as such triggers the kernel BUG as it believes it found a
page pool leak.

IMHO this is a generic 32-bit kernel issue, not just affecting parisc.

Do you see any options other than:
a) revert the patch (ee62ce7a1d90), or:
b) return false in page_pool_page_is_pp() when !defined(CONFIG_64BIT),
   which means to effectively disable the page pool page test on 32bit
   machines

Helge

