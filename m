Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CF1FEA7940
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 19:20:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 916546B0099; Wed,  4 Feb 2026 14:20:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D7376B009B; Wed,  4 Feb 2026 14:20:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7ECD86B009D; Wed,  4 Feb 2026 14:20:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6DF986B0099
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 14:20:09 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 38F9E1402D7
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 19:20:09 +0000 (UTC)
X-FDA: 84407739738.13.887C1B1
Received: from mail-244123.protonmail.ch (mail-244123.protonmail.ch [109.224.244.123])
	by imf21.hostedemail.com (Postfix) with ESMTP id 43ED81C0004
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 19:20:06 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=CcDWouom;
	spf=pass (imf21.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.123 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770232807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RmRX77ZIo9OEQe/UggGwGsoPALdXiYThzLUG8/anAWw=;
	b=qN/Ln7FG3/ouy5KFbPCszNjaphQAb8r4xRo6sGbZUZnM8ZRvU3xCNJPD5GXKAWO8Gw5kUk
	ZWgYZKQbJS3muAllb1c6GP9rV2Q2N0SW+NGKZIrSrFQmp1TlVAzxEFV7uZXksfqpvxwHNW
	oS9wVH9wgHUosKKmAEVh6PLSxDnbOhE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=CcDWouom;
	spf=pass (imf21.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.123 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770232807; a=rsa-sha256;
	cv=none;
	b=AAAVTgGl5FKpoJrC8YTGTZ0ckwY8o1BqIKpeVnYUIgYEMDkrsiczy+qSxmsNT7boER326U
	PqgmBNK3AETSQ4DnrD7NuPo9Ot1Ip5PrCLmt4iVW41gVeodx3yQy9w+bN+G0YPbDb/vy56
	sirQqWyvApLU/sjh4DRfNKU6+DbXwm8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1770232805; x=1770492005;
	bh=RmRX77ZIo9OEQe/UggGwGsoPALdXiYThzLUG8/anAWw=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=CcDWouomo0M7ZpE+hyJRfvbl5GANIZtOfXmCKpQMMIwcdJrsm2Z/xEqBAvuIKt1ml
	 LzXeeCLz6R41xOPV9s8BByhlorMEwe0ndTQvV9NSx6brRrvtmEpqVFmGRbwDEJSA6L
	 4Dp76Hcfhi4yMRFGwhWGyACwJC+OrGdDTbZ39PV9tm1KO9qOk616tHmDGdLbCp008K
	 KrEUh4YGgYKUsRfg/UGdRRgOGy2bhqZFS3AxalbLPjtMzDeUrScdxKiv4uiPyfjpi9
	 6PRG6i7OgdkyXf9TrUeITzDH1HDFGHPmOEznY+7Qw/UuHtNJZANi6F3EBPNTW/v3U8
	 LDqu07jFBzN+g==
Date: Wed, 04 Feb 2026 19:20:01 +0000
To: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, Uladzislau Rezki <urezki@gmail.com>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: m.wieczorretman@pm.me, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, Alexander Potapenko <glider@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH v10 06/13] mm/execmem: Untag addresses in EXECMEM_ROX related pointer arithmetic
Message-ID: <98bfdbf081127ff064565a2c8b72c363f4fc0d5d.1770232424.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1770232424.git.m.wieczorretman@pm.me>
References: <cover.1770232424.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 1a4149de5a9cbe996829c30ae1db0bbbc1b883c3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 43ED81C0004
X-Rspamd-Server: rspam07
X-Stat-Signature: 93t13fxdsd4xxigy1zsn9s16hqhargi4
X-HE-Tag: 1770232806-785622
X-HE-Meta: U2FsdGVkX19xSW+X2cdvA4bgGSeuhrKgUfXYf1qIxHVZhMd6GQDsAiGzC+srJeFUU6oXIJR9rOncJcopVttwD6s1++dDCj5meaBdrhjG5vCfmfrseAHwI2pSZw5qBLPF1YpdLVkUFbUDWcpuOLDuJPRRzYHsyqCAlXMCO13nsKZBjKjfA1fJ0MhbmIC66gEjtG6mO/sJyXCYGqInfRxmiNCs0nPd2UhIAOqiYeKEt61uuPGgEmsCOvFEKmjqELTH5kOx8zrxNwyl5kDrv8kBUV31mkt/wfE+5Ns1594UqPaUL0DKEbOEzJpqKvblOn3O9cISoaPq6dgVlOsVwVvrKH5L3Bf9/M8ajou3JTV57a9Aqzfp3l2rvdHjmDQS9cqILe9ZnlpJFvbLJ3HJiM6MaMwJaJSYKV0xxZSqg4PkTw3oKqDGw3OgeAuTa/wEhwco5UVWlqyQxAjA3I7ZuWng3Pv9HH2TAgTAxMaHYzDVUv9Cg+SdTx8QDw+iQ4lbfbGU6uLwfgQN1Ls43eVoES2CGcwaabCLyMYZZ/lfN2w+AWP42muasG3T8+/AM3d6yp8MpQQy3mZkK3Cu+OD7MQ6NIKPfOti4NiD6e+7tLjZS2Q3Hh3fYxzlfMxQREs1lbuc02N0Oft1Vuy37HWnzEKkguBPd8otoyOUnjA9lwx3jMaF2bu8yt1e+huO38F8hlhv/ZipljVPOvGRdVpipAGSthyP+ej0iBYnw7G+FQZddUfj9/Zzkoa+VRnBjZK3DejqW0d96aM5D3gmzELVRnqGwhGhaZWerS31I9PGT8pQseBvxkSdMjS0I1PIgugRmITH5gluA134MNTTPdw5EbE3jGeUAhdL1KsG36kXrSYey4fv7I0kZYdXFd5Cbnhqn8+beL5kAQy6RvWHCO7/MGyKk9NsEWStlwCgl0iWKT2sPHTrr6ibm+zrIMTuKo4ymsF5puOsYrBtPGoNuDOql9NZ
 sfmHjT25
 uHUTDk52nMFJb6bGbrfeyWlZN7zX9ddzRx3PoMkCIwF0HN+g19RSewanq0wreYdhyihkzkzmA0IW2Q1jh7FB2plGdFPsr+B3fYpYjnU0i13cwASR5aMKvtaVjsi6hDmik9i9VC/3IH81NlV+T4ZGk6lff2IdHSpv2FknxHhSGfujgXE3F9CRssBwpuOaRDcwPn0PdGZ5sWmKHrqcUdJTh9Mh1no5SOvGdjtFvAbxEvR8RPMlXeQ1QO5FBMqgKEHzuiFt1k7nPacaS+k1S0b7b0wgMBaBX3bj+XWZNhRcybl3h0ZEnKVQ435RY/2DsUuA8KwhMK5l73o9r2l8=
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
index e286c2d2068c..2304d095c579 100644
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
2.53.0



