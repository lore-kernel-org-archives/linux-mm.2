Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 138E5CCFA04
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 14:49:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72F278E014B; Tue,  4 Nov 2025 09:49:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DFC58E0124; Tue,  4 Nov 2025 09:49:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61D178E014B; Tue,  4 Nov 2025 09:49:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5220C8E0124
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:49:55 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DEEA0140517
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 14:49:54 +0000 (UTC)
X-FDA: 84073209108.28.2224130
Received: from mail-24417.protonmail.ch (mail-24417.protonmail.ch [109.224.244.17])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2A8844000C
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 14:49:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=Q45ZqZeY;
	spf=pass (imf07.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.17 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762267793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6toufJLKljGqaHG5WZqQpO38Yv3Ls2e+KAx9dPrtmiw=;
	b=FkxgVnuoEgB+VXNR4VLleKshItUvIvdJKpAEIqo2TUiRBu1UEydEGYmtdPyZUb8+z0a0iO
	3LVfnWpD1ecqG2uhxU+oI/Ch9G3kXTvfyL/aFon3QfaxuF3AN78BDRpsDNnqnGuBhbDBcB
	+BL1Hb+eb+e8SSzIsEivppd3WeLkbtY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=Q45ZqZeY;
	spf=pass (imf07.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.17 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762267793; a=rsa-sha256;
	cv=none;
	b=WrCR3DLBLMiCtVbbtb3G8GZxEc0W+rXqJes1w8l6MsNsbXxK55HPy9sOf9YaOAS0QQhiqB
	mSG4l3vIRmNkjIVCvkxMFmKxbh5leFiTq3y24X3z9oo5wLV+xyc5c+n833uje7/JMBcuaL
	vHvBGD4QCeMvZFMYYgKEruTqKS/JwNQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1762267790; x=1762526990;
	bh=6toufJLKljGqaHG5WZqQpO38Yv3Ls2e+KAx9dPrtmiw=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=Q45ZqZeYIfexXEzPHWV37QQFzHBmhcuTm8m95wIVxjojEDFnCiwaBpmE4GfVtQpIG
	 Xv+yKdzj99Vix3uQc3UtOqhz0NSwhIIm96fewaISwkdgNrC8SGUAqz5Mu1NqmwqJqB
	 dCQe+XFuWcws2LHUcgn/Lf3r+FckwwwnuuSSJGpJoC0MUnw58rxw/syptWo5sJDVx+
	 tYVn2zN+Gn5L9UnDqHa1hPX9ZqgpL+2U8Qm5+MaR8w1aLLYp8onv/IKmigRlkS/6Oq
	 rLG8qtXFMv9PbZKAMIAh9mJQnCYRk9WQusCfXFE5Bh7s53iuerfhX3vx6OpeWf0WEP
	 vT0fOHegElP4Q==
Date: Tue, 04 Nov 2025 14:49:48 +0000
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Marco Elver <elver@google.com>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: m.wieczorretman@pm.me, stable@vger.kernel.org, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, Baoquan He <bhe@redhat.com>, kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 2/2] kasan: Unpoison vms[area] addresses with a common tag
Message-ID: <cf8fe0ffcdbf54e06d9df26c8473b123c4065f02.1762267022.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1762267022.git.m.wieczorretman@pm.me>
References: <cover.1762267022.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 55cd5ebacaac83958431436550ff0c47705cb95d
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 2A8844000C
X-Stat-Signature: gm6g59sx9757yyk6sedfpuy1348cz71q
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762267792-131823
X-HE-Meta: U2FsdGVkX1+9WnkHEdquFROPoP+WEFrFXlCr2RgaF1s7gc/aYrOA1stiHu4Fbq0f/LUvhpCy0aqQjE+rSjS/7YMpRQ/pRbgY1eC8+wv+9ACMijnuexBZG8eoZN1xlPpD52MXDQckY3Df51yWC52/u3Q/6aDvC8An3Hyg0xcEu08p37jbB0gaL/7TGXlnf0utPCTJ04d2nqDGGdYkrcmNnV2lW2HjocZplv7qU/cMkXUuJwuB64As5+yx4trkVUFcLCbuheU0czGp57UaN8fTjeSb7NEDqm3qRMicFQ/pQCN2HAgBCa+Ldij3TLOHUUbkSYNp7GSPp2r4z/rfcFrKsqHKrF9hM0tgkxcfKNdfFeLbmOFREHq3/7x/80rl+Vbr+iv/yDzNjGxem6HxFmbGko7+cW7eJF1baQjgQhDNkV2DOHhiybo8WzPRS0OJ1WWCsgGfsv4Dp988U9cBOakX8pYuLtaujDrdFFi8jaZ7U2qR/QVjUt9hY5CmzzAj+Xvfus6dCIW5JHSCeQztqeyZH7QW2/YWw6IbjHsNCYClbdHIz5x9N85U9U6RXeJgjZjXjl0pFNbhovlFkq/5xXVhRA1fEXSrHIutKUrCIF8VBRG2EJVeCWobkc0Yexs+vDwrSCeZC0LQ9KfOpHyY/gKcpeQWo7AEDTBwDj1TVnWySFUzxjOXclKsXODH52XGbZsL7+zHfAf+cVHlnUo6Xq19X1Q3Cf4GM28cWjMT1lffyLZuB2mb5nls757wM33gtV2vIUDhhI4KCTBrgX5+ajSfD77vVlgofv4C7IJmSM73h6XW1o9BiqFMQMDGwlFlgyBTxqmPToO50vWX+yodwx3THcGnYnj96fO4gIq/Xsaa4fRLiwEAEkjIEkYFV6WGmUxDQ/h6TCDxXPlqpcBWXTqFxkdcxq00vH5jUpanvfV6ByTegDWJuAz1WM00/oS+4AL+aPgYHH+SYzYqn4Gd1Qo
 DDaaC3mJ
 DwOvGMJA+W4le1OLKmuR6XN6fgNdGFChvs8i7vjdQSfkZ+42Xl1OIs17yfQ3FvwehFUkCf6sv975EBIXbf/6hygoYvoaXTwo/jtZdrlyq9G60W20g0tQJudLJ2bJkR0nB4VMEE9bjSPo0E2l4bi6ck4hdxV7gJCTV5+TDEoemwdatyOMRlhCxKQ3mSDD5xNDgszriq60jfmajGwhhv/EsLiyfZ3NJDYbg7erGiMLTVXrv1ux0k/fGBO0bUh1h0g94OMp0Z8WYR528GYaxSbCcVby1svngxf9q4PvAnCxYWoGmNMatqi2UrhxEiiPBE1axoSpzaWoKhjX9vJlvea1X3XNpVrUe9pFnko9N
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>

A KASAN tag mismatch, possibly causing a kernel panic, can be observed
on systems with a tag-based KASAN enabled and with multiple NUMA nodes.
It was reported on arm64 and reproduced on x86. It can be explained in
the following points:

=091. There can be more than one virtual memory chunk.
=092. Chunk's base address has a tag.
=093. The base address points at the first chunk and thus inherits
=09   the tag of the first chunk.
=094. The subsequent chunks will be accessed with the tag from the
=09   first chunk.
=095. Thus, the subsequent chunks need to have their tag set to
=09   match that of the first chunk.

Unpoison all vm_structs after allocating them for the percpu allocator.
Use the same tag to resolve the pcpu chunk address mismatch.

Fixes: 1d96320f8d53 ("kasan, vmalloc: add vmalloc tagging for SW_TAGS")
Cc: <stable@vger.kernel.org> # 6.1+
Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Tested-by: Baoquan He <bhe@redhat.com>
---
Changelog v1 (after splitting of from the KASAN series):
- Rewrite the patch message to point at the user impact of the issue.
- Move helper to common.c so it can be compiled in all KASAN modes.

 mm/kasan/common.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/mm/kasan/common.c b/mm/kasan/common.c
index c63544a98c24..a6bbc68984cd 100644
--- a/mm/kasan/common.c
+++ b/mm/kasan/common.c
@@ -584,12 +584,20 @@ bool __kasan_check_byte(const void *address, unsigned=
 long ip)
 =09return true;
 }
=20
+/*
+ * A tag mismatch happens when calculating per-cpu chunk addresses, becaus=
e
+ * they all inherit the tag from vms[0]->addr, even when nr_vms is bigger
+ * than 1. This is a problem because all the vms[]->addr come from separat=
e
+ * allocations and have different tags so while the calculated address is
+ * correct the tag isn't.
+ */
 void __kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms)
 {
 =09int area;
=20
 =09for (area =3D 0 ; area < nr_vms ; area++) {
 =09=09kasan_poison(vms[area]->addr, vms[area]->size,
-=09=09=09     arch_kasan_get_tag(vms[area]->addr), false);
+=09=09=09     arch_kasan_get_tag(vms[0]->addr), false);
+=09=09arch_kasan_set_tag(vms[area]->addr, arch_kasan_get_tag(vms[0]->addr)=
);
 =09}
 }
--=20
2.51.0



