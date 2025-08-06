Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A239CC87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 15:40:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 444AA6B00A3; Wed,  6 Aug 2025 11:40:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41CC26B00A4; Wed,  6 Aug 2025 11:40:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 332A86B00A5; Wed,  6 Aug 2025 11:40:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 243AC6B00A3
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 11:40:22 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B167D58637
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 15:40:21 +0000 (UTC)
X-FDA: 83746744242.14.0CDE0B5
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf10.hostedemail.com (Postfix) with ESMTP id DCA71C0002
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 15:40:19 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pJkY6n5a;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 3YneTaAYKCOkdfcPYMRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--surenb.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3YneTaAYKCOkdfcPYMRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--surenb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754494819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=/rcbJP9GsUTVLgzIeF6EjF73i2MBiTUObyAO9IzHFJw=;
	b=b1yOQAHts/jiZBfw3u/GN51mOi/mvZffcW2o8qUQFMeYw7cjIz5ThW9bsg9rtzaMG4cIVE
	0dlX3b1g4Rads+sermaMEhq3BPsDu1zyMOyC/z3WGlluAsE2PjxJRbhK82jV6Rz/vsJJsM
	QDf3CDZdzN8KQe+0aYwWcWhWrgyZdi0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754494820; a=rsa-sha256;
	cv=none;
	b=4okEfR7+pQEnbdvA/7KZGmt9KDjvFy0wPKOYwtzm/uWG/CB1gm09kGW/Zd54q8Lt2Ibqlv
	K2QYIED09gchm43VjB0SYCIe0G7a23HCzy1S2uJ1skE46FQhzIYkaAfDfojh64uUJ02jzw
	XGQAlr2GaeuDvrqsO1fhSa9sjRrPfGU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pJkY6n5a;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 3YneTaAYKCOkdfcPYMRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--surenb.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3YneTaAYKCOkdfcPYMRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--surenb.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-23fd8f85dd2so54716785ad.0
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 08:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754494819; x=1755099619; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/rcbJP9GsUTVLgzIeF6EjF73i2MBiTUObyAO9IzHFJw=;
        b=pJkY6n5a9F2D9BS9twZUrQOnhW/SpFS2v0hBVSE0nLzoazjrQ3XR9sX10nwwr3dze0
         KCEdMlX07eYxzHZTD2Ml75GYAz8NtxfFcbtgRbh0HY+NmY91VKM98ic/1H8hkKUmmKk/
         mufFOxYX4xYX6FYT8yAZlOJR71k2VIxkMOKAgQDRtJ7KT8HA6UtKcZHPxLQJ2ena3HzN
         HprFUhadaIpdvyLtCZ/LfKarJSeyCw+Gc6FdVFS7m5wjQJIHjZNjV/R+aefe6RlAcb1F
         Y8CSz4F2VQLqsyh7MrpPBTxgT9O8P/0m7RtWYgZid/L5OWiDE/4XAzoUBrl1UOD8MYOL
         6DBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754494819; x=1755099619;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/rcbJP9GsUTVLgzIeF6EjF73i2MBiTUObyAO9IzHFJw=;
        b=pCaZxYjtywOjM2QM1NbgzOtioy6/6BaqbfnaUpGMsTmdTO4J4r0VyW0zuf1B2XkpRp
         o8syNKCcGr/HlwHaNSeIcDiGL7wwTPCniArGXwFn8AHApRBYw+Nlk0xLKY71w1ncC3yi
         tLaupySOLruqzRCeXWQJBzE31zpXvqGqkR6vZ/ZFKie/9o8KeDkqR87zhP9Y5ly86NOh
         y7Mqq84LeIcbu5Wr+6QEeRB7fQvGrHxGmKLRMX9w2Imhlicv75js08wFQgVvzs/gV5R5
         IRCbhj5NDbltQD8GqO03+s3oySyZ2TrGooi2JwR5JB8jL1bwa0KRiUZCeuQKUukGpxWW
         scrg==
X-Forwarded-Encrypted: i=1; AJvYcCUIco34K0DAKg3x9vt2gq+vmSuc43LKRVg1zcdFy7ABN55rJQ1VSVoZQUqRsLrVo+EtVHRkzDYInw==@kvack.org
X-Gm-Message-State: AOJu0Yy8+AuaB3g1OuuzZpbs1A//vAvjwaU4qaKKbvOT3Z5lgXnkFJKb
	c+g/rwv49Q5QrPwUIjQlxKNVE5K3PFC+/hMryBH7elSFQxbNgiwDHYzweP6e5e3qnFSHazGbGcC
	lJuDCfA==
X-Google-Smtp-Source: AGHT+IGi3LZt6GUnUZOPcAyMejp52TBB0RjJh6S5HK/q7683T2GfXcCeCP9l0/WWit8jiCrja5/iLHKI5zY=
X-Received: from plbko5.prod.google.com ([2002:a17:903:7c5:b0:23f:e9a5:d20a])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f70e:b0:23f:fa2c:3aff
 with SMTP id d9443c01a7336-2429f5adf47mr38827855ad.52.1754494818714; Wed, 06
 Aug 2025 08:40:18 -0700 (PDT)
Date: Wed,  6 Aug 2025 08:40:15 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250806154015.769024-1-surenb@google.com>
Subject: [PATCH v3 1/1] userfaultfd: fix a crash in UFFDIO_MOVE with some
 non-present PMDs
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: peterx@redhat.com, david@redhat.com, aarcange@redhat.com, 
	lokeshgidra@google.com, surenb@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: DCA71C0002
X-Stat-Signature: 3377bb9ocdf7g159firhudr66u6rgn3c
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754494819-936834
X-HE-Meta: U2FsdGVkX1/USCXtuD6BeNFN44p+byEbs2LRB5yN9Efh2Jcly3av8Q5A3VeobkztLASbmSJczCUeKN154FXLJVA/D9OwpGzGcuQ2YzSuJXq+hFDdR3SeHrcpxYkvnUBGg7qV3CXoJPZHMhh8PFQ4umD9Y2f61x9csQETpXQd9aJiYYj4Px8Guyrgs3Kz8wcNmha3OEWsgp9pi8Z7CVBnWcvkqhgWP9wCluj8+ZZ0Pt1TSpROVR2dfNJnvNSLcr1Gn5PRGcvnxUCXbCqsPBKswqIQ72aUzu3wTgM/vaJirP7VagEz6nIkIAvt93t8Vt6PlXak0gSDMa+Piz7b54lRhAKHB48JoSdbcoaZZPSXqevfcoUIfozB/MgKIaahZ3xli5JXCn90kkfDNV2eDykZDgQ/jZKfOtGiEQULmPAlv49Orqsm1ko0ePo1k/8Ygi+WSuCMEm27NBxrb6uuz/BlXNVzwhNE83/pVL6VXVj/OS1wqSaGEaaTm7m37vfDcUqhsstpxdwpVl2UzCzkY6ffdFKmpUA1EUAyqmqNfFDzoX2Gr73hc5WZdTTTyNJob17N+5Hm1WnoVn+a6n3NON0yFxyylFcCdV+H3gsvEfefSJMBgGOpbu6KgOTvVp+ewai5P+blBgoJrTN8LC+mFg00glfQupPrwi8EQ4Qx+PwlhAuTyQVcbJQyLjPnKeThFxLJbuOX4vlGGmXUAb6S31q9bAeO6j8WpeS+MA61wnaQzeizPvVFiCN9wrmPJy/0ocj/mlSIw78eRp815HAaqaiIMg2vrakgNhFZJUOV148JZp4x1O+coPDWBREtVbyoHjtr4TY/R4vf7w7dJSwUeUkV5nuRXFrG7N5PUr+SR14AkUVGQiTb5h4NOQ16QkwcvGcWi6hcwMCYer6Q3+sSILgIUbk1gA/Z4fokWZdyGD89l/fdibpc+p9JCOIslG/9oxB8Mtjb6BTouVpiPUwYQ7O
 3I3DQ0Z3
 f/JEut0IcsXgAagmL3vpT4cMbp2ItIT1NisR+bkyoyFwYcq1baZAXFYPXOgIVYhAGQC+GcmOGwV9TsQb2sugkCZvBnT3onA4DGVPNXIidp6k02PH45tKh4p9fpJJgos/gpIAbyszVRJIho7hDhbKWmH1MgCZNvIPZtMYefQrAZUw2B7uV74+RAhwuGEOS2YmidH09bpvg7Ip9HUCplCfb7NPJqE8Zqmx/2j5drRieFVSQREHDK8vgfqRj2yw8PDal0LdZHJV0g0kef4fQ0+1hi+gyvYJ/7LzfPtvCLBEFZWezuollaHGLJqxjhANJqRWdoUPjo+eqSJMRM+A+LpJtgiCRP6W4nH0Vv40lvQ2pVR56Mj1ALujDXD+L3jsv4zEflJfDSaNlEGFGROpe+FLA2W9+q1o112gNKwKdxupyRVXcYdOh2E7UxpiJ7WPdzXhWhe6ioGMoVWyIpxRCmqvPjzCEozXcipdUxFl/vOyYTFQgrYD7/vFbkjk78VSvWyMgoEIukA3EgDHXoNaVvWlCTs1s6lUDtHUDRy58k58nF5E/MChXheZ9EBAm3tenqDMRUlshvoDFjhYpnqWNNoCoyniO23gNFcWXcYVWHpQYkBdlt1fPUFJeIrkxBHoIyIzFuftvPBVTygsWyD55ywA5UTwyqsGgJRLVcdUUk2modPry3fq3k/FFQ/bwsg6+0UTHV/nM6KaKHCrCF/I5qRxhXpMJZpzSE2go+3fp/9YBfFwzTS4CdEXKvyM/cKgniefuktXzZjZgt5XfnWi2DjqLenAOv25RNsruDaAqEzmlWndF7uDevY5u0Yq0Qg6BdI9GpgMk/fZ2+GGb9cw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When UFFDIO_MOVE is used with UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES and it
encounters a non-present PMD (migration entry), it proceeds with folio
access even though the folio is not present. Add the missing check and
let split_huge_pmd() handle migration entries.

Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Reported-by: syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68794b5c.a70a0220.693ce.0050.GAE@google.com/
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: stable@vger.kernel.org
---
Changes since v2 [1]
- Updated the title and changelog, per David Hildenbrand
- Removed extra checks for non-present not-migration PMD entries,
per Peter Xu

[1] https://lore.kernel.org/all/20250731154442.319568-1-surenb@google.com/

 mm/userfaultfd.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 5431c9dd7fd7..116481606be8 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1826,13 +1826,16 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 			/* Check if we can move the pmd without splitting it. */
 			if (move_splits_huge_pmd(dst_addr, src_addr, src_start + len) ||
 			    !pmd_none(dst_pmdval)) {
-				struct folio *folio = pmd_folio(*src_pmd);
-
-				if (!folio || (!is_huge_zero_folio(folio) &&
-					       !PageAnonExclusive(&folio->page))) {
-					spin_unlock(ptl);
-					err = -EBUSY;
-					break;
+				/* Can be a migration entry */
+				if (pmd_present(*src_pmd)) {
+					struct folio *folio = pmd_folio(*src_pmd);
+
+					if (!folio || (!is_huge_zero_folio(folio) &&
+						       !PageAnonExclusive(&folio->page))) {
+						spin_unlock(ptl);
+						err = -EBUSY;
+						break;
+					}
 				}
 
 				spin_unlock(ptl);

base-commit: 8e7e0c6d09502e44aa7a8fce0821e042a6ec03d1
-- 
2.50.1.565.gc32cd1483b-goog


