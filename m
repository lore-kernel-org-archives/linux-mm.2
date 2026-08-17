Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B711C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 15:14:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFC496B00E4; Mon, 17 Aug 2026 11:14:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED36F6B0161; Mon, 17 Aug 2026 11:14:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0FD16B060B; Mon, 17 Aug 2026 11:14:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B81526B00E4
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 11:14:28 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 35FFE1206E9
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:14:28 +0000 (UTC)
X-FDA: 85111107816.22.EE28818
Received: from mta0.migadu.com (out-224.mta0.migadu.com [91.218.175.224])
	by imf26.hostedemail.com (Postfix) with ESMTP id CE8A614000C
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:14:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uk6XiQ57;
	spf=pass (imf26.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.224 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786979666;
	b=H2uW2wvsuKFjXRnNRHMDoiC8wFO6v/hb275s/S2lPU4pi21sqZXWX++P/ixyJpI2nxhl1K
	xgArzC7ldYF3vK9/jugc/TtHWl15q41BgqvTlQtWocyxmSV20X1bLStOUzJrpFX097ash2
	Lcqbbz54ESLt3AhtIOgUASngDRHa6WQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uk6XiQ57;
	spf=pass (imf26.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.224 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786979666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=woTtNTgamjU8QhTcw8i2fyCAO0vg9Ld3pwEtZLfaYsA=;
	b=cjXef5c0s9v7+FYSzTiMMkCl8B62fiUcifxVLvK/10MkPyy8RZw/IaHx5Ry1pdotryFZA5
	lQ3+IQuMoHIt+kkFmu8Ov0Kc4SGV0T4WDEO7lYvnYvt9IfrRzUB1KilGifVzXHpbRe5IQm
	cpad46i4s3RsvpsFdqQ0/fymlF7WNOI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/kpJHgkNpi750FH/SGpyKpVgqGqCSp4Wcpe2Zcb2oTU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786979664; v=1; x=1787584464;
 b=uk6XiQ57o1D6iibPFn5TKPWCDhnmKhFXuHkfhwAfmPyXniTm8i72E8hoRSgSS6FxCFvtJatD
 kUmnfMkBx9oLsAHHiig6ksIVwQO3iIA/8ohr2/mwK3ZKLP8lPZNwYrmBTas2k/yJBioKWe+JgDx
 DjSVklLEX0StH/n1O0kQZ3Bc=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (212.133.41.51)
	by smtp.migadu.com with ESMTPS id b6551f00886cde4e;
	Mon, 17 Aug 2026 15:14:23 +0000
X-Migadu-Flow: FLOW_OUT
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 17 Aug 2026 17:14:19 +0200
Message-Id: <DKRBF6LQY1L7.13CIBHAU0A87D@linux.dev>
Cc: =?utf-8?q?Adrian_Barna=C5=9B?= <abarnas@google.com>, "Albert Ou"
 <aou@eecs.berkeley.edu>, "Alexander Gordeev" <agordeev@linux.ibm.com>,
 "Alexandre Ghiti" <alex@ghiti.fr>, "Andy Lutomirski" <luto@kernel.org>,
 "Borislav Petkov" <bp@alien8.de>, "Brendan Jackman"
 <brendan.jackman@linux.dev>, "Catalin Marinas" <catalin.marinas@arm.com>,
 "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Dave Hansen"
 <dave.hansen@linux.intel.com>, "David Hildenbrand" <david@kernel.org>,
 "Gerald Schaefer" <gerald.schaefer@linux.ibm.com>, "Heiko Carstens"
 <hca@linux.ibm.com>, "Huacai Chen" <chenhuacai@kernel.org>, "Ingo Molnar"
 <mingo@redhat.com>, "Len Brown" <lenb@kernel.org>, "Palmer Dabbelt"
 <palmer@dabbelt.com>, "Paul Walmsley" <pjw@kernel.org>, "Pavel Machek"
 <pavel@kernel.org>, "Peter Zijlstra" <peterz@infradead.org>, "H. Peter
 Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rafael@kernel.org>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Sven Schnelle" <svens@linux.ibm.com>,
 "Thomas Gleixner" <tglx@kernel.org>, "Uladzislau Rezki" <urezki@gmail.com>,
 "Vasily Gorbik" <gor@linux.ibm.com>, "WANG Xuerui" <kernel@xen0n.name>,
 "Will Deacon" <will@kernel.org>, <x86@kernel.org>,
 <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-pm@vger.kernel.org>,
 <linux-riscv@lists.infradead.org>, <linux-s390@vger.kernel.org>,
 <loongarch@lists.linux.dev>, <yosry@kernel.org>
Subject: Re: [PATCH 6/6] Revert "arch: introduce
 set_direct_map_valid_noflush()"
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>
X-Mailer: aerc 0.21.0
References: <20260816-execmem-set-vm-perms-v0-2-v1-0-90944a3ad43f@kernel.org> <20260816-execmem-set-vm-perms-v0-2-v1-6-90944a3ad43f@kernel.org>
In-Reply-To: <20260816-execmem-set-vm-perms-v0-2-v1-6-90944a3ad43f@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CE8A614000C
X-Stat-Signature: 4bdjmbyfntwr9o57f89q3rbo7y1itpmq
X-HE-Tag: 1786979665-514057
X-HE-Meta: U2FsdGVkX18z5ykCo48Sx5fwGooY8+4Nxg/ZkbPl2mxZx+Gfxtx76rMLNlSqrWUogVVfQhKZPLDLFdcpst1Q/Y3bAfZHKw9DW0UzKE9KMVMhTKTCdQcTrm0V+vU2ZU/Nmq0HCOoDGyTp5xHx7dkWwP+Ozg6DLMf7YVcI1jay1yI5NhY6qxTT+t18dLx1NhsUu7Djg0FchTNsJqXC6CazdvGPGQj5Z3qB+Ew3XFkOvhci8i7kdaywFZdzDL8o+QyRwsdlJuOJa/eA7Oe9r10nEVc+kXiSoqvbv389UnZNHm9iQ47x+WbTXRPJsr1vOO8hro+0Zi60M5ByJM+vtZ4Q3jCTI6RvQHTJRABAjXZjuKheTfQr73D7UgvJDwvqDDpq/9D83E6i3Th9JSlA12cw+QV70DeU1PQkCJomXOR8eBc2DNLw05zPlJjdbbYYrdrXr88lTmtPPxsqcPcSzvXmQEEe88sek/nlkfGlC9go0AQHGoZF8wgXG657aVC8/0Qs9fcAx9WbYXCzmSqqQUX1nIJ+nUCxV5ql/NmZt9SCPpFlRqnQDYy7BNIwt9HqjHHR6N+ROoOnqcHD+M8jkDqrtRD83omJA2DabI7boPfXUSkRfdfaMIf80JsocEyDl5u0Pk99gM8ZJgAnTcH+Tbkc0CGWgVRSxxksNauIjKP9hqe0msO8c8kQhQr/pMxm5LqC/b9D9g3jYn+b6HCazzr8gwAcY+07bB/vwxTE/eLtnjoAuHjO6rDw9VSij6+y7K1Vrl/zoBLz+2tYZL5FpcjWJ3Rq3NszWQn3OcPuSkSsyGCarcyUYUQePLLr9NzhtZzwD/O7Mpgmn4Tcyf7LwgDKtJmSY0ag7HXQ8ry4Z6ijGxMNNPywIUEtAvbRXCL85cNoB6DoTfOF0Q+h9PCdp7HMgnasYkL6blqCVHGmQD/tf7vxP0ZqqqDcznDHwEz4hIuzsEumpgI8/Ad1FssN/9g
 SG7iIv9U
 4bYK0mJ2kF8XkWEx+LbZUZOGAAwTSBIWyMP0mkVhZ5jJus2SfA/6PnkTbYDetHOAvwv60gw3dPZj8kqv7wKbh1ppsNLHTUFdUkH5KrysCSmmFKfL775r47DMcsP27uiQDHqOYliOUkJ7vq2t7wLJ8PO7kX70aJI4NJ+cpNqQVuqXXBKi/gZQeoeJpCLhwpp0t0XAFvga66skL21RdDzNVpmLj9Bl7yCzeZdLv6oE/8aJdF1odqHF6/9kmTZB+ahxP7aD+7Qebj1515eLZjVFIzUmbOgfLcWDgTsfeyiE5+r0LeMX+7+AXN+OnkmWW/cmZdFzHORcUjDoKKaiyK/YxGL/XArSRelVpL2BeGT/XdcfOzRCcMIe7rLvXursPNOFd4ylk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun Aug 16, 2026 at 12:59 PM CEST, Mike Rapoport (Microsoft) wrote:
> Commit 0c6378a71574 ("arch: introduce set_direct_map_valid_noflush()")
> added set_direct_map_valid_noflush() to allow updating the direct map
> for a physically contiguous range in execmem.
>
> As Brendan recently pointed out [1], this API is confusing because on
> arm64 it means that is sets VALID bit in ptes, while on other
> architectures it is an analog of set_direct_map_default_noflush().
>
> The only user of set_direct_map_valid_noflush() was execmem's ROX cache
> freeing path and it was switched to utilize VM_FLUSH_RESET_PERMS for
> resetting permissions of the direct map alias.
>
> With the last user gone and with set_direct_map_{invalid,default}_noflush=
()
> accepting number of pages as a parameter, set_direct_map_valid_noflush()
> become a copy of set_memory_valid() on arm64 and a duplicate of
> set_direct_map_{invalid,default}_noflush() on other architecture, it is
> safe to remove set_direct_map_valid_noflush().
>
> Also drop a stale comment in arm64::__kernel_map_pages() that Linus
> bothered to add when merging changes containing set_direct_map_valid_nofl=
ush()
> to his tree.
>
> This reverts commit 0c6378a71574daa6cd1534ad42a956e3262756c7.
>
> [1] https://lore.kernel.org/all/DJ69RCVRBO0Y.3JCYSW50IC4RC@linux.dev
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Quick dump of my understanding (ignoring the NG bit on arm64)

- set_direct_map_invalid_noflush():

    x86: clear P and RW (and DIRTY)
    arm64: clear VALID

  So these look out of sync to me

- set_direct_map_default_noflush():

    x86: set P and RW
    arm64: set VALID and WRITE, clear RDONLY

- set_direct_map_valid_noflush(..., true):

    x86: exactly the same as set_direct_map_default_noflush()
         (but with a `nr` arg)
    arm64: set VALID

- set_direct_map_valid_noflush(..., false):

    both archs: exactly the same as set_direct_map_invalid_noflush()
         (but with a `nr` arg)

So basically the big issue here is specifically that
set_direct_map_valid_noflush(..., true) is special on arm64 and not x86.

And we fix that by jut deleting the API. SGTM!

The other issue I can see here is that set_direct_map_invalid_noflush()
clears RW on x86 but doesn't set RDONLY on arm64. So if you unmap
something using set_direct_map_invalid_noflush(), then map it again
using something other than set_direct_map_default_noflush(), you get
different behaviour between the archs.

I think the answer to that is probably: doing that is a bug, i.e.
_invalid_noflush() and _default_noflush() are a pair that you have to
use together. But I haven't checked if this is currently the case. Maybe
it would still make sense to just align these fully?

Anyway, aside from all this yapping, getting rid of _valid_noflush()
seems like an unambiguous win here so thanks for the cleanup!

Reviewed-by: Brendan Jackman <brendan.jackman@linux.dev>

