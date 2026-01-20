Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF25DD2ECF7
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 14:41:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 570346B0432; Tue, 20 Jan 2026 09:41:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51DA56B0433; Tue, 20 Jan 2026 09:41:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45E0D6B0434; Tue, 20 Jan 2026 09:41:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3851E6B0432
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 09:41:51 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D7A5B140160
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 14:41:50 +0000 (UTC)
X-FDA: 84352606380.05.D4D5584
Received: from mail-43101.protonmail.ch (mail-43101.protonmail.ch [185.70.43.101])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1EACF100009
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 14:41:48 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b="iaSfVFV/";
	spf=pass (imf14.hostedemail.com: domain of m.wieczorretman@pm.me designates 185.70.43.101 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768920109; a=rsa-sha256;
	cv=none;
	b=ChKQRrv/R0ZRjkUdQa6afZiG7rJoQbkbM+nrJ6BklFD+5e0k1sjELSj450r3NMsErDnWBn
	xdDxgyLSFxXMdl/F2mj7//a7KjGE+c+G8XoH8EEv6ueafGpHiroZakkQoTL1pU3JNZu/Wk
	XREXoCxFi5RG1gQirzC5yVZoL2ZMMbM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b="iaSfVFV/";
	spf=pass (imf14.hostedemail.com: domain of m.wieczorretman@pm.me designates 185.70.43.101 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768920109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lQJLMP4Gv0lA08mztwDwUY7/t2r+QHQJpY7kM+Q6kDo=;
	b=enTwT4LQi8nzpikNJhxxK7Yct0Lhymx39HhTvwQ2aSAf/WUIpS9EI7KFYqpDSqMtvKHk7e
	ahX3PHgpJprNTUVKQJa+FoKXPIp6xK1TPRfvoi6XYIZLGYLbbhBGY2q5CnuiOhOe4ordQj
	iHZ3nV1h0uotZWe/nzyPJbqdP37CAc8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1768920107; x=1769179307;
	bh=lQJLMP4Gv0lA08mztwDwUY7/t2r+QHQJpY7kM+Q6kDo=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=iaSfVFV/73NRu7Xuo5uhg+qFjd9okscHF7pD1FvYAeXrGoJr29shiGEA+2X5zcsst
	 hlZZu9ZdTDiizFYjl8F30lH6vsmeNA4lirNhoSY5PLEoYVwZHcxo+Dhc7XefRn6iti
	 HWSz/1z7a441UcsTUbLC4NcxVd2mV+wV/MyboVYq7wT0JqCRu+z+q9FHNQEfUymTxc
	 lJdCACYxYernE8o0Iiwmgv96wGdTy5gyzMndwJwns0/qH1qO8Svf6RBysDFjL9eYuH
	 lVfbrWWvTGD4XP09mioW+oab37nPw+kJ/HbkzKVrdrwIaPUnfGC0CUMuAjhrD/c59s
	 rw1QzhdaieLbQ==
Date: Tue, 20 Jan 2026 14:41:43 +0000
To: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, Uladzislau Rezki <urezki@gmail.com>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: m.wieczorretman@pm.me, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, Alexander Potapenko <glider@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH v9 06/13] mm/execmem: Untag addresses in EXECMEM_ROX related pointer arithmetic
Message-ID: <50701245bae3d2c543f518d206539ba71367075c.1768845098.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1768845098.git.m.wieczorretman@pm.me>
References: <cover.1768845098.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 72074259788e0a13e140673de760fd8bafe7309f
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1EACF100009
X-Stat-Signature: w9yxgian5jyfkyh55xtm6jy4q68aip4g
X-Rspam-User: 
X-HE-Tag: 1768920108-745515
X-HE-Meta: U2FsdGVkX1+tR7g2sw39AaKxXiHrWMss5qwNVC+ksP5BerlYVFA447SpyPWgL3uI0Obx1MFgdAH+3mZcouG/2Y94loMSGlPlMTaJQwHuDsJnn/BFecfJwYey/Gq2i9ACbTfxMA/hCyPh8KNMnx7Q8tlxAdGmLQVIqZRLdlY24nyiDuYGgVElh2CasnXPWSJ5z9vIXgKRB2hinaWPoJsWPWc2fgWg5dwhrZJKsGLVDHu5cTbQ/VuoNCopAK0gTD1JqQEAyibQWfJQkk7elxDdRBzipBaMmvscKufskyITmVBamfz059GtMa/V+LwdpvKY9YMSO4OgSdiGVpVNd+aSFClyJewCx19waL0Ey8pQ38PFSnpyZ4E+dsmRpCgx2I17Ow9k9YXnfM2AqE7yZtftCBFg7a07SpLUQfRrPvtI+Trr8CJJ0Sp+TdVjAs2556vVaa7TunJyYPSx/ntCp1JsvusWApm74l11fAmPtD1WsvyqtoY21n03JxK8NJYRmPS0DaQLhLImy9aNnv57kB7qmE5d4wYZVcpmVmWpIodbmkoyE5FkV4IaM0XGEmB/OPbI0NzQXqFZXUKYg0qRXEO2xPX/WNYGU7yL1jqJ3nOsiOybPCRcTd6tWwGbmjConT0N5+BUUQ7TewtiKoAaeg79UqdAXSlZz6gnN1WP72THmx+z0HF3EWlMFk1q6m4q1wK7nCfNfarw+6HQ5oCElDnL7gUK1SlwCLlXAtoRb9dk315gdD1sABHMAjTHb2WlFHpxROIDtxwaoIXIu0os8i1J4t0pMuGKi4uwL1h6+14OhhJXsU1pv1NYQ1v18UCNTsD1Fg4Myu59ASqpyunIjrpBU+bB5gOkpur+qc7fSsmilWKEE4mMQSh5gdWxZQV45HRv
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
Acked-by: Alexander Potapenko <glider@google.com>
---
Changelog v7:
- Add Alexander's acked-by tag.
- Add comments on why these tag resets are needed (Alexander)

Changelog v6:
- Move back the tag reset from execmem_cache_add() to execmem_vmalloc()
  (Mike Rapoport)
- Rewrite the changelogs to match the code changes from v6 and v5.

Changelog v5:
- Remove the within_range() change.
- arch_kasan_reset_tag -> kasan_reset_tag.

Changelog v4:
- Add patch to the series.

 mm/execmem.c | 9 ++++++++-
 mm/vmalloc.c | 7 ++++++-
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/mm/execmem.c b/mm/execmem.c
index 810a4ba9c924..dc7422222cf7 100644
--- a/mm/execmem.c
+++ b/mm/execmem.c
@@ -59,7 +59,14 @@ static void *execmem_vmalloc(struct execmem_range *range=
, size_t size,
 =09=09return NULL;
 =09}
=20
-=09return p;
+=09/*
+=09 * Resetting the tag here is necessary to avoid the tagged address
+=09 * ending up in the maple tree structure. There it's linear address
+=09 * can be incorrectly compared with other addresses which can result in
+=09 * a wrong address being picked down the line and for example a page
+=09 * permission violation error panicking the kernel.
+=09 */
+=09return kasan_reset_tag(p);
 }
=20
 struct vm_struct *execmem_vmap(size_t size)
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 628f96e83b11..1479a7b362f4 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3354,7 +3354,12 @@ static void vm_reset_perms(struct vm_struct *area)
 =09 * the vm_unmap_aliases() flush includes the direct map.
 =09 */
 =09for (i =3D 0; i < area->nr_pages; i +=3D 1U << page_order) {
-=09=09unsigned long addr =3D (unsigned long)page_address(area->pages[i]);
+=09=09/*
+=09=09 * Addresses' tag needs resetting so it can be properly used in
+=09=09 * the min() and max() below. Otherwise the start or end values
+=09=09 * might be favoured.
+=09=09 */
+=09=09unsigned long addr =3D (unsigned long)kasan_reset_tag(page_address(a=
rea->pages[i]));
=20
 =09=09if (addr) {
 =09=09=09unsigned long page_size;
--=20
2.52.0



