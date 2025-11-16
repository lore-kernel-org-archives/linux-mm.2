Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E08BCEACEF
	for <linux-mm@archiver.kernel.org>; Sun, 16 Nov 2025 05:42:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 215F28E0029; Sun, 16 Nov 2025 00:42:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EDA28E0005; Sun, 16 Nov 2025 00:42:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 103898E0029; Sun, 16 Nov 2025 00:42:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E75778E0005
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 00:42:22 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 57EA2160820
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 05:42:22 +0000 (UTC)
X-FDA: 84115374924.12.C1E9702
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf29.hostedemail.com (Postfix) with ESMTP id 541D8120004
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 05:42:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=vjti.ac.in header.s=google header.b=agan4HwJ;
	dmarc=pass (policy=quarantine) header.from=vjti.ac.in;
	spf=none (imf29.hostedemail.com: domain of ssrane_b23@ee.vjti.ac.in has no SPF policy when checking 209.85.216.50) smtp.mailfrom=ssrane_b23@ee.vjti.ac.in
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763271740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FTWCYfcDkOpbvWX4/d8dth0aaIAROH9noLyncWa3asY=;
	b=g3guyHZ8IT03LAL1TGlaThK7UGxLEvSqhy5pGwS/ub9frFxfwyEfR+ffK2xH6p4vuRjswd
	RO5wlaQmwnWbbefVpghaAL9hwfKYnQsegJBZfT/ecmvr/rbjvvr/c9u8gNNfd4RREHg7Ob
	JmHNJ6RdZZZ6HW2OfRvLjKn1J27chrg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763271740; a=rsa-sha256;
	cv=none;
	b=5+Y8XNZJ+bS3ZGJxKNDtM0wSrDM+nfyzmZ7K6j+4gG3n7sHqvj70rRWQuF1vEY0ncDdq2k
	EqFuZJCZHLRqQxSp9NYQArPCfCoP6LI+pW+ePsthR5jaOhCtv64BBxw2oL/1IyXXST1ylo
	lUud3uSveavioabLasXPI65IVBm4QkA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=vjti.ac.in header.s=google header.b=agan4HwJ;
	dmarc=pass (policy=quarantine) header.from=vjti.ac.in;
	spf=none (imf29.hostedemail.com: domain of ssrane_b23@ee.vjti.ac.in has no SPF policy when checking 209.85.216.50) smtp.mailfrom=ssrane_b23@ee.vjti.ac.in
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-340ba29d518so2329081a91.3
        for <linux-mm@kvack.org>; Sat, 15 Nov 2025 21:42:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vjti.ac.in; s=google; t=1763271739; x=1763876539; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FTWCYfcDkOpbvWX4/d8dth0aaIAROH9noLyncWa3asY=;
        b=agan4HwJTKfy8JM1YuK+iN7t8ICzAdBrcI9VbkfxGDxbs1H3YvcK5LZLgIguzPa9Jh
         ZNKD1dm+fSUWNlWVR4/8utb0FXaHCrwuOwyPyPIUMKJrwCKjBRxb6j9Gq1jz+wIZ8Nve
         +EKlxd/HpAVdy2zpFbc/phaPyChPctoaNy4ws=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763271739; x=1763876539;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FTWCYfcDkOpbvWX4/d8dth0aaIAROH9noLyncWa3asY=;
        b=PPhFB+MgjD1sEj85g+DXMU8nz5URiCYOjWGtVXD5Gvbda6PXImuEokBe35UXgC3VmI
         q4hxBkBVkuWYQGjLzSXbnrMGxpS3ofjdUZSxpgc23fs9Kkr34x0bs4kUz3XkUQQZTQpw
         TitUBLMFugexZvepmdFWaNnkNOhSnXAlheNJXKtQnBdNSMp66LvEirZVH/M8AcK0slhw
         ZnVPCxeaMhhS6/wmbTZHSM7rosqYxXa0VATQy39xKpYE5lb8afCh5szi6cKDryGncR+0
         bQq40yZJ9PnlxNb5C2db1/UGBEnLf0XMxIeEWC1A+b43+PkJdHpmLz4smJaEgxW4admF
         F6Hg==
X-Forwarded-Encrypted: i=1; AJvYcCWIP353uKT4HRbXPHH9M5Iw04ziKovhvQ0VloVDhXrTPzewM1ZDQZvtNvfe0KC5mL2pCnJAf9eM+A==@kvack.org
X-Gm-Message-State: AOJu0YxEcKUTkwagMFvyo28TIH6HXc7jZ93ODUqEZUzma6LeoPuswetD
	7u2WOjtjSoJM/sWEg4gv4LDP1Z8xWdHVzVY/frudCt5un/sURGYfRog5dhTJ190QKlA=
X-Gm-Gg: ASbGncsCFLYM//igzKjqdP//9H/oVSMH2RJY+oYa3VoaJnQAXokAzpwA/aeGCqHApeH
	1Dmkgydcg3Nt9pPHlRLuX5avHxg6gcjPwaQRS75S8eQhxfO8p0OQ9CGiFKqgxlsmyIPnuDZIBOM
	EZWPYQPJaqH2hGktfATF6a0Icyg91SH6QyoBarmZqklfwb0CNh34a2cjOG+267Gqoj/XI43CykP
	0W/HGZgp77ObJ/CqSyE0puptFiqawoZXALu2EAvKgtItvkW8TZrGVWuZDmAChoAFsp4TEjKrdyE
	hp9aM7yfs72VgNMJ4TzQyi+gHgzRZwv0dYGNWAeCfA9OYN1Fz1c0b/0j6Ydj5okO/qI7XEyW7SH
	ueidFn5iG3J+B/9+Zz1OC7Nd0DaLnkhMV+THWDSyzFHuAh+NLpm5fL8GfnrMPAQuGcOdWtOi8kZ
	9911w26XyLnNaiSaYRNXRoXpTEY42HTCZTfUi6Ke1+2tr224FUsSiq8S+khjqjeo9nZ/MePw==
X-Google-Smtp-Source: AGHT+IG2K2QlmLfFxQbOUyvFX7GI+ZJKFUXmOL4E+Oy9wQTzgT+ZrGoudEvwXm4hz5A9Qo5blHBWsg==
X-Received: by 2002:a17:90b:180e:b0:340:bc27:97bd with SMTP id 98e67ed59e1d1-343f9e9f385mr8126097a91.9.1763271738957;
        Sat, 15 Nov 2025 21:42:18 -0800 (PST)
Received: from ranegod-HP-ENVY-x360-Convertible-13-bd0xxx.. ([2409:40c0:1035:4e2d:eebe:9df9:70d0:b210])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bc36ed72cd1sm8509995a12.11.2025.11.15.21.42.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Nov 2025 21:42:18 -0800 (PST)
From: ssrane_b23@ee.vjti.ac.in
X-Google-Original-From: ssranevjti@gmail.com
To: willy@infradead.org
Cc: akpm@linux-foundation.org,
	shakeel.butt@linux.dev,
	eddyz87@gmail.com,
	andrii@kernel.org,
	ast@kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com,
	khalid@kernel.org,
	syzbot+09b7d050e4806540153d@syzkaller.appspotmail.com,
	ssrane_b23@ee.vjti.ac.in
Subject: [PATCH v2] mm/filemap: fix NULL pointer dereference in do_read_cache_folio()
Date: Sun, 16 Nov 2025 11:12:05 +0530
Message-Id: <20251116054205.114412-1-ssranevjti@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <aReUv1kVACh3UKv-@casper.infradead.org>
References: <aReUv1kVACh3UKv-@casper.infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qpbuzzsbe9d64ccdixnmdrrqutbhdmec
X-Rspam-User: 
X-Rspamd-Queue-Id: 541D8120004
X-Rspamd-Server: rspam10
X-HE-Tag: 1763271740-750024
X-HE-Meta: U2FsdGVkX1/3z/Ya/LeIuTIWWBpj454j0ge3i4cAs2Dch912XpdexZLdv77p2mCQIWA7mKYxBqwLg7DOzZqy+7o/zSYtBH9gnEmXq5lKY19GuAo8hU36LytwXWrkuSObUHSIwazvGe82rMyPpssb/pCXxLhhopW3A2HBNtY4YlDMMRlxRkllN98neIwkHDcYo+VaNXSZFu+6GnBOkSPIW448vOZPLQhTWjaDVrlGYWcITWpHIuOYWeWE1l3IA9RMFbsqN9PTj23QNq/PqITThXOU0jCDMWKZsLx2pgfzJafHbn34Xjq8IBbNesbLNpSl18sO1ofkX9Zl0IAVm2vv+WpOK8qk5jr2plN7i/3RsSXgmtwHh2ydCbacrrLQpDJGFAu7A1nC8dcnJBxNZg6mOrYu2bgAWje8JfuyJY57+htYvXqQuM8mS0MEZe+MwvoutwbQz/yz6PLK285PyV8CUDG7AIS+DDL/C7381tryCmhGuOGC+I6AWr/x/ubmt5rhoABiJartntaEOUiJEKRfZNFaEElchex1TovwWJ1QV8puq567M+5HWPl5ijxDZmAPqkge9+KFffa1QP9KmesuoUA2eKSC3cuXDt3eBwaCkTJROUYMOjihXLq0NLu94UiufBWqpqzbrmLWRL3wgTVI/++fOwW84Ndxr5W0Og5pQzRN0b4/rgc23ECWZoDajztQDmkS4Prd6RMzH7AaO26Ux2WXy0f6ZdjQHec2UuRCR2ltZm3Or1FSqmA9ivYx0ziLAyGylGqDT/Wfs0e/oDmjS76tCQyMAVk5ykXWCHk1fwKAPd8uA149Sl/M4L3HdfdGXKFY12VK7bSuaAx7c2slGmuWQ6S7mGNTeRA3dZyKQVNtUT/tC1rTxEFNzVbH4OvuXIuonRIw3mFrObxjRjHnlx9sERqJYukjX6SWAKqExPd4ajH0hs559cIHV+rifmgwS+ghTLiWo8QjFFoVWpr
 UXjA+4JM
 mPDev9U+JRCKW8+trHnEzhMs7ndulcytNGTt+joKPDQP/EdJEW3BffgZpmRSwpR+2iRd/O8tNPPgWVNrQyu9puvkkQeI2H9PuVdg+W1NQrsg+S+p6uoqDUNxtGAtFWVh4K6hRATX6GgPEowneSQLy+1tEC/M/4PB/RoTm/UF5qmz7oqfladwSBvBdc760YUQ3uTyWNhAdlIv3sdEBTlybJ6Gfy2+xcYH9nX1FJ8Thi+wtve1H7j96II/eday/NpFDBJFYHWPNGp4ePU2vx58eaahzNuCskUeef31LzC5+IIPH/RGN3+/lWjzpYayQqTE0RggprVQ6kiWk+qEAUW8F0bo4Jrl+DnTXxS+REOfMTla4o7KT6mo4UtNyuY3+SHjhn2Z1XBg9uNprUYzRYu/92kMODNvwomvPvdZBhwf6q8QmH3qdGHvbx02QgfxvYb1DSMUgVQ1e960CZXJfM3YYitBnKk4PjOH74aHLODGlfDhOrSBGygZTJouzzq23NxHX8/Rbk+u0l77UVovfCzY4tDmzy+25dK5/YFGeqvsrpxYKOP1s69+3OGuq3w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shaurya Rane <ssrane_b23@ee.vjti.ac.in>

When read_cache_folio() is called with a NULL filler function on a mapping
that doesn't implement read_folio, a NULL pointer dereference occurs in
filemap_read_folio().

The crash occurs when:
1. build_id_parse() is called on a VMA backed by a file from a filesystem
   that doesn't implement address_space_operations.read_folio (e.g., procfs,
   sysfs, or other virtual filesystems)
2. read_cache_folio() is called with filler=NULL
3. do_read_cache_folio() sets filler = mapping->a_ops->read_folio (still NULL)
4. filemap_read_folio() calls filler() causing a NULL pointer dereference

The fix is to add a NULL check after the fallback assignment and return
-EIO, which is handled gracefully by the callers.

Reported-by: syzbot+09b7d050e4806540153d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=09b7d050e4806540153d
Fixes: ad41251c290d ("lib/buildid: implement sleepable build_id_parse() API")
Signed-off-by: Shaurya Rane <ssrane_b23@ee.vjti.ac.in>
---
Changes in v2:
- Add early read_folio check in __build_id_parse() for unsupported filesystems.
-Add defensive !filler check in do_read_cache_folio() to prevent NULL dereference.
---
 lib/buildid.c | 3 +++
 mm/filemap.c  | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/lib/buildid.c b/lib/buildid.c
index c4b0f376fb34..3136cc92010f 100644
--- a/lib/buildid.c
+++ b/lib/buildid.c
@@ -298,6 +298,9 @@ static int __build_id_parse(struct vm_area_struct *vma, unsigned char *build_id,
 	/* only works for page backed storage  */
 	if (!vma->vm_file)
 		return -EINVAL;
+	/* check if filesystem supports page cache operations */
+	if (!vma->vm_file->f_mapping->a_ops->read_folio)
+		return -EINVAL;
 
 	freader_init_from_file(&r, buf, sizeof(buf), vma->vm_file, may_fault);
 
diff --git a/mm/filemap.c b/mm/filemap.c
index 13f0259d993c..f700fe931d61 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3980,6 +3980,8 @@ static struct folio *do_read_cache_folio(struct address_space *mapping,
 
 	if (!filler)
 		filler = mapping->a_ops->read_folio;
+	if (!filler)
+		return ERR_PTR(-EIO);
 repeat:
 	folio = filemap_get_folio(mapping, index);
 	if (IS_ERR(folio)) {
-- 
2.34.1


