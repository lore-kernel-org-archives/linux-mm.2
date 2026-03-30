Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C7AD1061B00
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 14:34:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F3CB6B00A0; Mon, 30 Mar 2026 10:34:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CBAE6B00A1; Mon, 30 Mar 2026 10:34:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F238E6B00A2; Mon, 30 Mar 2026 10:33:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E2F9D6B00A0
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:33:59 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A883E1A080F
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:33:59 +0000 (UTC)
X-FDA: 84602973798.19.E01014C
Received: from mail-244121.protonmail.ch (mail-244121.protonmail.ch [109.224.244.121])
	by imf12.hostedemail.com (Postfix) with ESMTP id A4F064000A
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:33:57 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=od67eMOl;
	spf=pass (imf12.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.121 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774881238; a=rsa-sha256;
	cv=none;
	b=J8A3BAkNrXr06OW7g71EL97+4F4lE+Xw5Y+9gnAMl90cT4UNIe7eNUZmi/A/Wfg7+u/v6y
	e25GGjhhytkg3HskwhmAMzQPKYuANC6Fuk3dIGx3gE7BEUF9gfc7ZfhVnFrcn3K7ppvITn
	wF+/HIyYixlpsOFWdI6xgeWjaCMKOBY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774881238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gDBMQkfHnwQdapFOEWUlLxhTfDL9GpT+jCrwjbzqofU=;
	b=W8QP/pTuRCE9wgto7Bxp966J4eJQohkM8thZ3iSZs6+elfiHdrcmb2XyWd1AVhYfO286vc
	8yQQEw7zDrroCgKOYQSIKWQ/8QhR/4DlpoE0tQSYHZc2sVm8rcn7eLgddZPJdeCTSJcNdO
	lWBRBJzVn5Tl1EfJx6PcpAOemhbf1fw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=od67eMOl;
	spf=pass (imf12.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.121 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1774881235; x=1775140435;
	bh=gDBMQkfHnwQdapFOEWUlLxhTfDL9GpT+jCrwjbzqofU=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=od67eMOlQ+NaI/AYiqnm8BOOip9pxmsJUVxLQvmVWpte+3qlXsdTJZ25X9Spt8iZJ
	 qigfk8oZija7lIu+FhdZ3PNt4dZilS47LxLU/777CfjPV5uMeNlGatFZSx5N6kGJ9t
	 KAFvyzG+MURSpLwUsKleMb4jl5g3RrPx1q3tE5xXxUbgTJMXy1C08QtIs0JfAUp+9N
	 f713qUHe9tJoL3nzaPbt1kKPH4VcG83D4gLIgY5066Kpa7tH/p1Ra4T97XZvsC7DUT
	 zLF/YfQPaW+G25OJoJc9Govr3YcO1ewp00Qvka6aNfLQDkcvCTx2vdP7lfo9TLZBSr
	 exhlNxhFJ6y8w==
Date: Mon, 30 Mar 2026 14:33:50 +0000
To: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, Uladzislau Rezki <urezki@gmail.com>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: m.wieczorretman@pm.me, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, Alexander Potapenko <glider@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH v12 07/15] mm/execmem: Untag addresses in EXECMEM_ROX related pointer arithmetic
Message-ID: <4a07f48214b0cf5e5888d826183e76af55ffed77.1774872838.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1774872838.git.m.wieczorretman@pm.me>
References: <cover.1774872838.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 53838e2a6e7b5d98ce1845d28d58094b9833961a
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A4F064000A
X-Stat-Signature: zgym78cfnduwjsfjzx7tegn6s9ht78qu
X-HE-Tag: 1774881237-491394
X-HE-Meta: U2FsdGVkX1+6knh9JAZFdfS3AC44eUZIGJ2b2Tl89VoZi05VIrp6qeaYQC5b4panyG9VKC0Fb874CC6d4MYagHMVWO2h25MdgnW+6UC8Fxs3a7At0CFIGcn+2qrLB7vnaLq+pGR0lf80P7cTjsneRxRfnFhpBrKeJJhE+A/1W6gdE+6xwwVRUVZwVrU7/GEMlOo2pV9hSNWJpRT9E/CD/2IcSM6f2kk8O7TOWQhDaMFdBLGLk3VPp2nIAKIqBp/+/4ERqTgITC0NDxuOCoztGc/npJ6nC4zrfP2N5S/mLOyd/7GDQL4q7DxnklYVHU9VvyCNdxhArChXbE7Ipc/iXgY5YSrenZAdrNFJhDBF6CHkQosUMATNMkhFhnDceCfY250u4hDWNe1N4HkF6x3TL/XnRx5aHsdWbBF8uEAT69XMsL3pnIlByjVWGMlUVh+/S4AaoWvEL2v/CJ1HmRXrakhH+yQWizl7o9AoVtQhy89NxS3jy9etKNBoU2C5fEn8lMPeoHkAqtYHt5Rrg/BJ0QjAtvLzqJjozh0SwSJY/lA/9U0Y9xQ+jdZFEKYaMXvxZ5H77aUdoyrC9HCtJg3C3VVo5vQVjSaudEg6ngxChI/IPDmmLwAoN50KC3E5/0pNt/R88hv8kvH+LsGSxzx/mBA91Lpj5qFCKmvf1MMSDOhZcYpbJRufxaePqlvkHKox/VjsaAK+xV0T8ma1KlGbVdjBRKc8/LWRg7FWJSNcdbITVOIzChUoWb5NeZmz45knL00mW+6h/N7HfGsCwzeU8WfkQ3CLt7i9es3ZGjBvPRHH8n/rMO0xadJXdrthzvMGv4bTuar9sDxQ77zMCThoiDFXP8AOpFVm7p3qyz64Gf6+kAEI/9l8jFlSssi4OmkDPUExo3rin23HhYHWYpGK7GCVkC4QILnNhxTr9UG58uLwkjA8I6SR5NaVoUhBoJ+sFkB/9gtxqEot/D5cqnt
 VvW/T71T
 DMc9NgPnQzAIOE2xdxV5ioTIF2OG7pJXnQMEF63bJiQDqT+kc3dnqj5678/4ryH9ukHJSKlUZk201ARs4lgIRFz/hCAdMj14w7tb54saHBAo+3M4w6OpdNrBL70AIUn5evs0AF7t4NVHcb1IbqaNrn9ddPYoyAlteHad7m0ccvJLq/hCQubSTmOlSiMLPa/qPTFVTsWirHz8cqEEzIrRdauOmDQ297Jdr/JRdAKrxe8jChoR46a27R/E4ihuppsfg1es0W575G6qt8k2PAZ9XL+RJb7qBFfzO1CDHU342g9cG+idwcFABG3kANUOtehrWxYk1UvfqzLrSIsg=
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
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
Changelog v10:
- Add Mike's acked-by tag.

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
index 084a207e4278..047079efe379 100644
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
index b31b208f6ecb..b2adc1524bd1 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3361,7 +3361,12 @@ static void vm_reset_perms(struct vm_struct *area)
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
2.53.0



