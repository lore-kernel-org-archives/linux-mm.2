Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D7F2CCF9EE
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 19:08:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A8FE8E00DB; Wed, 29 Oct 2025 15:08:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97D648E00B2; Wed, 29 Oct 2025 15:08:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BB628E00DB; Wed, 29 Oct 2025 15:08:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 73F968E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:08:02 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4075DBBEB4
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 19:08:02 +0000 (UTC)
X-FDA: 84052086804.03.6FD2922
Received: from mail-24418.protonmail.ch (mail-24418.protonmail.ch [109.224.244.18])
	by imf20.hostedemail.com (Postfix) with ESMTP id 698051C0010
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 19:08:00 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=IJcPNw3y;
	spf=pass (imf20.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.18 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761764880; a=rsa-sha256;
	cv=none;
	b=RAHc/Gc3aYtzqtJSsmkeDtStMOKLTwkEAlBuI65Nqfbb2jx+3vD3i8If34NB3EDbwNqqAd
	1/0OO5IIIeQa8+PIhllIbLgVOttXqwU7e/sbY3T9CmI9mv4cCkCPdzmUh7Mmvx4bUKsBb/
	9f5HDR/5DRIH1GTFrpjDg12oz38XnzQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=IJcPNw3y;
	spf=pass (imf20.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.18 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761764880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wC6RWC0BysYEjK4tLyl5sRrziRZnxpuWzjQ8a6tBeM4=;
	b=tbofVJqM6bCj6EGDFO3OuI2QB2kW6sQ57q5d3YdkDGaJL6IN/nvaC9oSUu6lUIDWsE3904
	SMV5btDaTanXNY/wRoGDgW+fL7nbwKAZGjyK5ZQaqtq5wc6PmkYYaenfmX6aHMraLNKewj
	CSFwK2ZOOyPLPRs5U0yriOFtPQnLAwM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1761764878; x=1762024078;
	bh=wC6RWC0BysYEjK4tLyl5sRrziRZnxpuWzjQ8a6tBeM4=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=IJcPNw3yh2TNHyjZf2+7PCXVO4q2xt+d6RxGzTh3Nu9x6lPPz5KLDRfUUfHQdlsKV
	 wpWXVbuGFSvXG6l3dJVLam23As54rJ+3MbI3AG03fI4SYHJDfUZql6kA9SeuWdefRC
	 5+jMHJpl7Ynw68PwkNnrvsAcORWvFbm1k8DSjDHbQ+xpmJaeKE1oSCduAyYgtUMcxp
	 5c/Y6liDXu9mw7a4gi1lz/+DQQLpT0qHscmGiFFf4YATArppuRqPL0lVDXIuQMCAOk
	 bN6yhswOyjHR0i79XSrB7Y/Xm+Xr4dmniCQDAvXrEx+6zarj5Hj/TzoELeXGT328Cw
	 zjj5lDm5ggAKQ==
Date: Wed, 29 Oct 2025 19:07:50 +0000
To: xin@zytor.com, peterz@infradead.org, kaleshsingh@google.com, kbingham@kernel.org, akpm@linux-foundation.org, nathan@kernel.org, ryabinin.a.a@gmail.com, dave.hansen@linux.intel.com, bp@alien8.de, morbo@google.com, jeremy.linton@arm.com, smostafa@google.com, kees@kernel.org, baohua@kernel.org, vbabka@suse.cz, justinstitt@google.com, wangkefeng.wang@huawei.com, leitao@debian.org, jan.kiszka@siemens.com, fujita.tomonori@gmail.com, hpa@zytor.com, urezki@gmail.com, ubizjak@gmail.com, ada.coupriediaz@arm.com, nick.desaulniers+lkml@gmail.com, ojeda@kernel.org, brgerst@gmail.com, elver@google.com, pankaj.gupta@amd.com, glider@google.com, mark.rutland@arm.com, trintaeoitogc@gmail.com, jpoimboe@kernel.org, thuth@redhat.com, pasha.tatashin@soleen.com, dvyukov@google.com, jhubbard@nvidia.com, catalin.marinas@arm.com, yeoreum.yun@arm.com, mhocko@suse.com, lorenzo.stoakes@oracle.com, samuel.holland@sifive.com, vincenzo.frascino@arm.com, bigeasy@linutronix.de, surenb@google.com,
	ardb@kernel.org, Liam.Howlett@oracle.com, nicolas.schier@linux.dev, ziy@nvidia.com, kas@kernel.org, tglx@linutronix.de, mingo@redhat.com, broonie@kernel.org, corbet@lwn.net, andreyknvl@gmail.com, maciej.wieczor-retman@intel.com, david@redhat.com, maz@kernel.org, rppt@kernel.org, will@kernel.org, luto@kernel.org
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, x86@kernel.org, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, linux-doc@vger.kernel.org, m.wieczorretman@pm.me
Subject: [PATCH v6 09/18] mm/execmem: Untag addresses in EXECMEM_ROX related pointer arithmetic
Message-ID: <d6443aca65c3d36903eb9715d37811eed1931cc1.1761763681.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1761763681.git.m.wieczorretman@pm.me>
References: <cover.1761763681.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 63b0d2f639705dfa0c06cb457ca2d9660abebfed
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: y6hsu8fs8dc4p8oixakj6ikrho4tza1r
X-Rspamd-Queue-Id: 698051C0010
X-Rspamd-Server: rspam09
X-HE-Tag: 1761764880-719661
X-HE-Meta: U2FsdGVkX18a7X4kSAY2WdlsrFaiEVDckPJOCwadz8dnUJsVUI2xboZ1dtWf+KYZr+3cSfIU8tAhQ7vhtWwxBRSBRF+EoWFJhflhfOMOgcqLCNIjVdjy+OO1A2KvKPZ+TDaPIBibhUMQss+OryTdJtULyran8ps1ZHvngxKS603EMmqKfumKtf7zjb4Q0+JAsQ2nIFR0G0fRKItGzDQJydB4I7dAmsiscqFC4rMGAwzVKgDhVD4S/Vj35H46QTVPLiMejABoqkQeCOjEbIQt8F9YPDwWNehXQt365Evb6z1WshQEfuXg2zqFrty0cc41wkclG3gIW0VZZtEeG2psxo2IT+zeevNHON0Fvy9vSLD3WWvUYX2SeWX7bAyrAKnYFvaO+ECIP7BvvZLDYVuG5HoWFj3Qy1ETdB8wy5VjQk2dhg2I4w9LB0vJqQsHbIkBLlDmGxQxLuiCjSsKzWmlJdHGgXba3N2MwIusgI4sPc6sZtdeqCplrPU/xvbQsOnTDVKOaD6HeRfE4eEAN69Q2ULXEsj0kiXXnQXBhj9JQvuSDneH1gorRgboK+f5ewIcGJwsDbVq7brPQBHBuo4fjdO2xZj8GC/1MEaLg0x2SHdiZaDmbXAsBQwCzCUTgL65d9Ea1a4ciX9K7M2FBXuMm927yn780c7mvwQj1xXYftDQFEx4box1mlkenTUEq5++p1bMOUSFCXHRMq3FtxQ8bqnuQMZGz+4bnYvcIYXmwHWTL+vjLKr6Zp2ndS8/r8iEw7JzkErYGoyGm0XseJJnb7ud48IDez02//qPdGaaanEucgTVWagtGYtBLKiB460kTclpHe0puNcBQKwicpMwynD2w+LrCqqJCiOXirsU4uwP1Tn6HcW/hOyy9I7G3xmor2fxRPjJyjTUu7dzif2RXIjhkklxXCv4cEYddtVQAcj3xpv9HTnez69ABG8qlSsFekGCruLQqE/vMsXECtK
 adNUGti7
 YM7UHr6rv8T93NDglX6zZsdX+CJwIzZDjmSsHxmrvfKhAJt4dWyjKbtpKQFlM/SANacXJdhSlpUEHsi1jaH1b/DZABoibU5RWOHedrguqkjs/n98IuraR64MwbIRiKSrpcS3g+U2xXWK1SiDIp6R8xjKg7IleOPSWJ6zBBrXwP7ID5X+7DQ8aT3REHX9SO/3RvNNx2bEhLc02hQT0aRcXARIVtXFO0VraLrK8Zcw6amWAdOMQ71oCkm95uWNflzci1zL9yxXS7yfch9B/83ZbH1rTA1DHflrm/c+rnapiur+XU1sj1QBWg6uA5SYcUOVBF85A1cmN7setBlJSWC8sGYmCFDeJVEXgrLn1neEot/gAMdY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>

ARCH_HAS_EXECMEM_ROX was re-enabled in x86 at Linux 6.14 release.
vm_reset_perms() calculates range's start and end addresses using min()
and max() functions. To do that it compares pointers but, with KASAN
software tags mode enabled, some are tagged - addr variable is, while
start and end variables aren't. This can cause the wrong address to be
chosen and result in various errors in different places.

Reset tags in the address used as function argument in min(), max().

execmem_cache_add() adds tagged pointers to a maple tree structure,
which then are incorrectly compared when walking the tree. That results
in different pointers being returned later and page permission violation
errors panicking the kernel.

Reset tag of the address range inserted into the maple tree inside
execmem_vmalloc() which then gets propagated to execmem_cache_add().

Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
---
Changelog v6:
- Move back the tag reset from execmem_cache_add() to execmem_vmalloc()
  (Mike Rapoport)
- Rewrite the changelogs to match the code changes from v6 and v5.

Changelog v5:
- Remove the within_range() change.
- arch_kasan_reset_tag -> kasan_reset_tag.

Changelog v4:
- Add patch to the series.

 mm/execmem.c | 2 +-
 mm/vmalloc.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/execmem.c b/mm/execmem.c
index 810a4ba9c924..fd11409a6217 100644
--- a/mm/execmem.c
+++ b/mm/execmem.c
@@ -59,7 +59,7 @@ static void *execmem_vmalloc(struct execmem_range *range,=
 size_t size,
 =09=09return NULL;
 =09}
=20
-=09return p;
+=09return kasan_reset_tag(p);
 }
=20
 struct vm_struct *execmem_vmap(size_t size)
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 934c8bfbcebf..392e3863d7d0 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3328,7 +3328,7 @@ static void vm_reset_perms(struct vm_struct *area)
 =09 * the vm_unmap_aliases() flush includes the direct map.
 =09 */
 =09for (i =3D 0; i < area->nr_pages; i +=3D 1U << page_order) {
-=09=09unsigned long addr =3D (unsigned long)page_address(area->pages[i]);
+=09=09unsigned long addr =3D (unsigned long)kasan_reset_tag(page_address(a=
rea->pages[i]));
=20
 =09=09if (addr) {
 =09=09=09unsigned long page_size;
--=20
2.51.0



