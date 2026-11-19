Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 122BF60A2638
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 15:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=readmodwrite-com.20260707.gappssmtp.com header.i=@readmodwrite-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=EQiUIzXp
Received: by kanga.kvack.org (Postfix)
	id 3298A6B0688; Thu, 19 Nov 2026 10:32:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 301586B0689; Thu, 19 Nov 2026 10:32:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2161A6B068A; Thu, 19 Nov 2026 10:32:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E677B6B0688
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 10:32:07 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 76323C0B1C
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:32:07 +0000 (UTC)
X-FDA: 85452259494.27.4E9BD53
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf16.hostedemail.com (Postfix) with ESMTP id 914DA180011
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:32:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20260707.gappssmtp.com header.s=20260707 header.b=EQiUIzXp
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795102325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h8lSiLXtXZ1pZqJZBadUPNSQr+zfDoCDjw/Y8Qu2swI=;
	b=QTr+lzXBBFcMBovG9ZuiKt5fJL3t7jB8zzVrdsW7OiI+qhlg79E1/i99+CiZAMiq5lliI6
	P0V0bcM1968vSV8Lf0U1DbYMr58UiTSbPGu0I5NKAjTyauTq6kiwJemsamzybX9GT5aeWn
	e9oHucJip3PXonoMdtGb3ihSw6Ir7zA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795102325;
	b=JUjaBnAurloz9MdPNNKWNFZZSkIImJG7eFCFey+k8qj8/2FMWCLPbv/dKDOPz/DsQcjQBo
	PDYaaDCSpOAImSFafoexGBxXnpw1RCh4tuqr9qsnC3GDUr+ztDlEommr7Aw0eyta4n3CkP
	9AY3HQa2Vcj/FCBtUk5buFi5ruqT4Ek=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20260707.gappssmtp.com header.s=20260707 header.b=EQiUIzXp;
	spf=none (imf16.hostedemail.com: domain of matt@readmodwrite.com has no SPF policy when checking 209.85.221.52) smtp.mailfrom=matt@readmodwrite.com;
	dmarc=none
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-4a33359c1b3so1714484f8f.3
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:32:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=readmodwrite-com.20260707.gappssmtp.com; s=20260707; t=1795102324; x=1795707124; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=h8lSiLXtXZ1pZqJZBadUPNSQr+zfDoCDjw/Y8Qu2swI=;
        b=EQiUIzXpxNHHOpfcDJao4Vflli7FVtBYNnQsp+WWte2Bd6p5CE+E/k/8M9VSZ0+ok2
         IDdOWEHgoujS1FsuC8IItacBycarG62bvxd4RchCq9bQW4eDwiU5pEN7kwcTlv7yd7Lt
         MLB5NrvnUFBUE1ZguKyccZHBEqZTzmYf7Evyd6m/t93AAEs84lXkz/LuQ045P32wQdVd
         MCG8e0tMkrEFqfe8BPXZLEqhmbsp86tFo3dgUfSJ7gI7u5vB9ek+SRWfSn95Io8xV1C/
         o0o601MjHM6nGOl1OR6cwC3KW25b6cuNUGTzHZiIqxzOiYNWZClroMYTIlaU+LeVeKU7
         QGOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795102324; x=1795707124;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=h8lSiLXtXZ1pZqJZBadUPNSQr+zfDoCDjw/Y8Qu2swI=;
        b=yTMhXMnjJZzSCG4lj7zhARlm+wzQ7uiG+jrH08mpYiBY+ULHIPoHbAoLzh+luHgBRX
         tnL7XpDSemqUtz/FqsiB4pn/aeQ75PQ+mpU+dUD8Pyw3KIzVozupy2uNxM4jOdEjLw1l
         mWc95Vzcj6JtTHIabf3iT1cpMKO+nBcxbPlbDuYsLo3Vje9344crW0UI5JF0yNgvSW94
         3VyuQpjK9Bg3vJuKm7VJBGchs3G/yjJaXcXVWuFoQglEevUiLCx67L+zqJ79MdZLRvYV
         LnSHmoczaIQp7xs9B0/nIRJsWpHzjBtg8wVMB/sOh9D+Cv25olHp7QedZtF2V50Z8UHJ
         UQ0w==
X-Forwarded-Encrypted: i=1; AL+hErF2mKDA5NnKGja2tQLtdM1MDJhwl/vFQ0VjbH6hRoUVuZzcpt05xY7/JzwTEuRwRnVH2gL+nWVsYw==@kvack.org
X-Gm-Message-State: APuU4Z9HqAK1QrdfJf2y8I5A2YXxc9YmTyuGgMr9jougk+0kanS2NDQ4
	RcN0iTAmKikAZ/3WCJbYvlN+Cx49v7/J94U2szFoij80rsoBjl8lL8OuEA9bpk4r8TA=
X-Gm-Gg: AZFdTZeoTwKiB1sU013ekFIl9UeU5gTgd8y5XOkaVR+RzZxVMDL7Z9iparsko3hA3LZ
	V1b31Wljj9Mo9ylCFgPRYGfmtPKP5jl2Psd8h+4I2NHq4bBkoq/habKXEBWyCmo+AkhNIBm5M38
	ptLFlERCxYvlj7U7BLMco2fbxbCW3ugqUqn+yed+3ZcP0x6MkbmrkHeF2YsnAFBC+a8F+B3aoAS
	0NZm/AUC1H2IF1V1gjPJMCixrAr8buxTm2IeHSlX1O6egN6l5Lkc2F9zmnNw5P46//vGcQyPdqo
	qA4gZdo6oK6mKg6FwFqiiYSql9LUdIW6U2FHNmcAzNaeIiPthV85bF/ytx9v0+xRRsyWVg0T2Ox
	KKy0OoyUdSIrsFklu8q+bLPFE1UFGXBJAJOMi6yl/yuFE9n3CAhmJYHLTay5C6698hVpjCuOTFV
	J3uvhli8gIgu/bgwVK7URO2bhvKaaHWnMYi6oUgnuntC64m7BQ1oKAEwD4u98Dc6xEaal30691P
	e6vYVGdOFHGrXnXm04g/pZn3afwDgwBnGlptJqw/qItTF4IX73SyyHdLmmw+1SuqOlbyvf9u04E
	UmDsgzk90uh1SO8CRsMEMDdTH4fDAkaJ
X-Received: by 2002:a5d:5f44:0:b0:48f:bf71:2ad9 with SMTP id ffacd0b85a97d-4a63e9d06e2mr13962297f8f.41.1795102324246;
        Thu, 19 Nov 2026 07:32:04 -0800 (PST)
Received: from matt-Precision-5490.. ([2a09:bac6:37a8:294b::41d:4e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab65cb41f4sm237463f8f.7.2026.11.19.07.32.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 07:32:03 -0800 (PST)
From: Matt Fleming <matt@readmodwrite.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@kernel.org>,
	Caleb Kan <calebkan1106@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	kernel-team@cloudflare.com,
	Caleb Kan <ckan@cloudflare.com>,
	Matt Fleming <mfleming@cloudflare.com>
Subject: [PATCH v4 02/10] mm/kmemleak: use stack_depot_fetch_into() for leak reports
Date: Thu, 19 Nov 2026 15:31:35 +0000
Message-ID: <20261119153143.4099483-3-matt@readmodwrite.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261119153143.4099483-1-matt@readmodwrite.com>
References: <20261119153143.4099483-1-matt@readmodwrite.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xqtmjpuwxf6n8rq7qcbsjgx8dwph3kb4
X-Rspam-User: 
X-Rspamd-Queue-Id: 914DA180011
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1795102325-628558
X-HE-Meta: U2FsdGVkX19XklE/iE0I+ot/U6EFxBATrtYTcDN5yUWafnkkHKznOSxsVmqh2qCCnumLOyMHVMaUlbShg94ZmETuL/oSb3fFf6zSylD6AWnsa4nq0oE5J/k6lw114iMpJvheaZxWI3r5SvJCkw0QGfU/6opqrkSEn8T8eRMCPBurdsTxeP/5cgoc1aUHy2RpY/cADANwiXZaUbQl3O3DJ5b999A/nDTIWBHXfhUyH0yUYd6DXJiI4Pbdb0jqnuaYwcbBaAQkMrqq0+z0/lG9ys0zCBl9r0u226Zg+it6SOpr5pWuKzKYbOy7oeMPuQDFg6wuBV0Nk5zaEF36Iuy+iK9fVC5LEbEGrxzXth/UnMP0kvu0GnAPeigGgwJuDxxM8POfq3ACl2BSQGo+Ydrd4sOGBRTCgHKznKY73q4rWl+CzWmc9wnzOH1Ymc5qGtaXaO0IjxNCe+9+jzUCVoVzl+t/xK/D38r/9RcnP6I7wtGTz9T/uT3IM3473XnxTfdnoe1gl2AC+O5t142JyH9qhz48ZlPhGdVPazOrLeIkRMM0h2jwkg1nSNL5b6Myz6ab2rRJvQ+8wBWZhMlhJMbi71Ncit+kqOVKE1Xjzl4f3ugx+O9veq2P9tTgNsUdWBkd8KZ7/D7720QngHFc3DmMLIUN4nu3aCx+x7S4cTpRQo/GzMUvezGWn+9YgdkERtM9gmfEAX0kXy/otrYwqrUWp7AWGOMDqy4vO6N20bQsuEUsodt/SGL8Amkca0WCmYJMxaiOnIlET1wQhHSuRQgvpzlBy+o8oJNVEGiI/9xtXZMocTnFhG4GhWxk/eQfSRhiaXgF0m3sMp8GZQqcCCT9xaj0Utd1cBlgqaseEDkMuM9QMge0wlB94EWb2KkCYabI1/v+KYcYoLkSkdd7eLTeeqONHeKglGXhUVoh6uUE11OTRZtxqoLtH49wJMBl94vYNjyT+V9Vgp2+u7y5Zhw
 USKU0YLr
 EyAKUH7IHhJ7lGKjDj/AG2Eu08UiEkvfp8x/2cOsmALqxwhIfm7sRDWT76BgN5C0Xopl9SReH5tJBLOg8ax07nap+k1Ccp5gEQO6eavaiZiRx3gc1EfOFbiOh3Qpr0mb6t2ySf8ZOTeP9WIB3kuIW4wjEFfrznkEq1HhsHA0MrYxY8gdoZ1UFRCgNEGbZX1tCwNpb2JBV1+QHVE36PkzC05ftY1rxV1dB1GnGLMcXR5dxeEHLBrP3YzkOHIaKZbbLcGY77/AXWY6NVan2uKHMexZcA/gPDdZruMMHTeWJ4QmS/UH09wqr9MHWJxnXDJ46VeayCm/2lfHCxHjA9tAQ6sWXqkl6UnwAY2YL5+0bMqfV1cayKs6cQ6vahGp5D7A41ZcU4I/xRIzFg3t52Jj2fMb11uJFT/RsMTao5gkIgl4xehBm0VwbKnjbzbR5YETEHkLN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Caleb Kan <ckan@cloudflare.com>

kmemleak stores allocation backtraces as persistent stack depot handles.
With compressed frames, stack_depot_fetch() cannot return a pointer
to unsigned long stack-record entries, so leak reports would omit the
saved backtrace.

Use stack_depot_fetch_into() with a MAX_TRACE-sized local array before
formatting the report. MAX_TRACE matches the save-side limit, so every
valid kmemleak trace fits without truncation. Preserve frame order and the
existing report format.

Signed-off-by: Caleb Kan <ckan@cloudflare.com>
[mfleming: reworded for compressed frames]
Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
---
 mm/kmemleak.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 20c0eb41c873..61ff4a10ce11 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -378,10 +378,10 @@ static void __print_unreferenced(struct seq_file *seq,
 				 bool hex_dump)
 {
 	int i;
-	unsigned long *entries;
+	unsigned long entries[MAX_TRACE];
 	unsigned int nr_entries;
 
-	nr_entries = stack_depot_fetch(object->trace_handle, &entries);
+	nr_entries = stack_depot_fetch_into(object->trace_handle, entries, ARRAY_SIZE(entries));
 	warn_or_seq_printf(seq, "unreferenced object%s 0x%08lx (size %zu):\n",
 			   __object_type_str(object),
 			   object->pointer, object->size);
-- 
2.43.0


