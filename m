Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40170D767F7
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 11:46:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 993366B008A; Fri, 19 Dec 2025 06:46:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9409E6B008C; Fri, 19 Dec 2025 06:46:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84CA16B0092; Fri, 19 Dec 2025 06:46:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 74A276B008A
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 06:46:15 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 104A51A0597
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:46:15 +0000 (UTC)
X-FDA: 84236042310.12.ED4A149
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf08.hostedemail.com (Postfix) with ESMTP id 12BA716000D
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:46:12 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Bf1Vw9GC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766144773; a=rsa-sha256;
	cv=none;
	b=Dqm56f5AtIYdJUBMStjZdrfEYnNJszmWpd0Dmb0OXQ8Uh/qXEF6u4JLfNTVuaWqvOWVicm
	zutXtWGIztceWXGfOHIMENp5OFeGhrKxtquQdoWVzZuF0RE4NKyPYxnNVaRjVp5G11in5m
	krYr8g3Dw3UI1no1NjeJzPTLhVgd3gU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Bf1Vw9GC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766144773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=rl/HhfNUmBpNdPZ4Vhl3wzuhLZQ6/j34huusrLevL3I=;
	b=STSQijL2JZMxIvVUEkC5H2cHymDp5cmABCw7zY8+SZZWjKhBSK6gSLVj8TGn4aHA5pOLMp
	JXMvYjRil7AQhABuf2kNls3Z1BL7Yy/UnN6raEjChY5dRkwDDcOM2toAQp2jrNK8c9Jc9h
	4mkc116AHt7WjFH2i53uipyZ5cb2aJ0=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7f1243792f2so1169407b3a.1
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 03:46:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766144772; x=1766749572; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rl/HhfNUmBpNdPZ4Vhl3wzuhLZQ6/j34huusrLevL3I=;
        b=Bf1Vw9GCUvGSY9kQi8BCPwCIt9TyqRxsQCIKdCo7i940usECM0XGStRZSI8n+VVIOP
         yvYek9W5QyqZRGxxFfrj8fTpNrk4A9SUzDMCqakphVYofIGfm0uIdzXS0jdvGEjqMfCP
         1tU32arMqxgefY0suOINjPSHxvoo/SgstbxiIu7o49E+7sJtTTCR8zn6Mej8DeGZYX3T
         zxgDSDxl1OYNpltzc2hh4cPweb5P332oJqxfd1w1LOeY/SH+uEg8byUzi0w8RBMiIPOf
         sLHIFJ4AIfIshPkUjZWCBuld4TBCtgNVyaHg6FAG4Cx2fM7zDLnQymU8h0qykNwcppN4
         sr+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766144772; x=1766749572;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rl/HhfNUmBpNdPZ4Vhl3wzuhLZQ6/j34huusrLevL3I=;
        b=s8r1gEhUNciKg3zww5wFNxhCmJ02N7ZbUf4GBS+wS456s+zUKhiK5IbbHiQJvrQiEe
         +m3MowbxfoKot6DbYHK8Rt0NU4hmsHHChkSv9pKqAm+AmVnCGADWDFFwqLD5nqJLg+C4
         HnnhoVy/ywfl+RJPaB6w2ZLzEoAnDqmmOxjnr2zEJ9mxN7R9rPQqqetf3SrEuUoxHIwd
         Zw3SivB60aZkOKcRhRrn7iViXIbSdJtf7pIM/UDwUirwGmE6dSg7wCn/prZKSxV2v6cs
         TKDzppqZrWIKzpfscCkftHwDh8Sqqd4J1K8dIY6rbB0+49yChj9rPpUZL7k7kyU+D4hq
         GLow==
X-Gm-Message-State: AOJu0Yz5teErUuidrsKr38CGNXRBu4hO4wVJD0qEWoWu+ehxSSqV8Eg1
	ZRUFVYz1KmNQ5g12Nxgc5RiCue6j9YApEBpbY/fh/fa+238Z9TRwR1Is
X-Gm-Gg: AY/fxX6W4xVgqoHPYXe8ts29FhrCKtTBv+GWPYylHGjEfpL35pYo592sQy+wugDTXHT
	hUoDU8h6lk1wDG2ETVqDiapbAy3C00FXvJJz3GPPJjC/vl12TWJmlOY0Rrz3hkTmia3aw7ltRAu
	DdNBA8SoDv+oX6ckZYXz0cdP6b3MMu+qI4vyId0zy9lODBP8N3y5tui45a/Eyc4Tm68s3uhVd5a
	eHRrALmj8wkWIT0vN443kwrGPiJHrjl6l0Xfg3RXgWajuTjHBbvP2zJaHMLyJt0N6PgUNhH0uYX
	IGjr7t4+0FuKiWpGkDz0AV3PbuClMtBSpdMrFhxliQIxZeMIDNUHzbt4zwWA13Kzyz7aqtp8XU2
	NbFXY6xv4699aZ03gmsYblzYhUllnbjzWMzd/ZCQXobdsCPCFnpjz396sJ+Ivi8I1fOk6K3jHQR
	MWN53itdePdGlueIHexXY4r/5CsU5iyOukHRM3i3Pj+VtBp8dS/mq6gYZJQ/igaQ==
X-Google-Smtp-Source: AGHT+IHzCGGOJMbQVjU+hHPeRVwjO5kFs5Ts9BqZjo3kbiC4p8MmrtBR6zUkgvgBtrq1eN6zOAJ73A==
X-Received: by 2002:a05:6a00:430d:b0:7a4:f552:b522 with SMTP id d2e1a72fcca58-7ff659964b9mr2333866b3a.27.1766144771692;
        Fri, 19 Dec 2025 03:46:11 -0800 (PST)
Received: from [127.0.0.1] ([43.132.141.21])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7dfac28fsm2201725b3a.32.2025.12.19.03.46.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 03:46:11 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 19 Dec 2025 19:46:00 +0800
Subject: [PATCH] mm/gup: remove no longer used gup_fast_undo_dev_pagemap
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251219-gup-cleanup-v1-1-348a70d9eecb@tencent.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDI1NDI0NL3fTSAt3knNTEPCBtYWhilmRhYWFibGqoBNRRUJSallkBNi06trY
 WAKFW6S9dAAAA
X-Change-ID: 20251219-gup-cleanup-8146b8884351
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Alistair Popple <apopple@nvidia.com>, linux-kernel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1766144768; l=1084;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=RA7i/WKYkPXoCVUQxPSGg2satJ4YPVo+ZVeopQrpnUY=;
 b=UVL/7+vIF/V8O1SDKoLPknoK7nXp18RY4NmbHGE9Fd46Me6gjufTrcWjLyzASiIBXh9Ux2Gwo
 eyjygctzBR3B3VWySHFX2zCZvji4198C2ubvjV1RbzlLHHflbfV1g7I
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspam-User: 
X-Rspamd-Queue-Id: 12BA716000D
X-Rspamd-Server: rspam10
X-Stat-Signature: 5xufchcxitnjmfthfd9a6dhyxeo4js3c
X-HE-Tag: 1766144772-377451
X-HE-Meta: U2FsdGVkX180N/cLF5r9ich6hVli3slrURKquQG6ZxuGMbqvmEEAZNuetr0wfObKsqcyYIPCtEQpi0oLqPGtF/ljx3XNI2ZmpdXY04iNNpDOUh3aKVkCUlRwduk05ndlluEZ3+9fAogQcsTSeVOZwfINpG9PFvuIbOKrE+we0imDPeyYqTvIwxnLAyUTfFfyirJmGCgZ1epNCmUgVPvhdUAEVtAq6i9tmXfSOR1vwWfDH9CnSCrPSernSQRK1dVSgMBF1i1ZbIu7cxm2/xEGnZq5Jg+noGYWf3tht54CqWZfuiu/705k6hNCQLFhuv78q2ROSi3DMNXQWeMqf9H8Y8CR26Rd69Ug3Sc2Qm4cvhfj2ZL5gEfA6WbAB5mDV0+MJbSxTjtyrO9ngwY4JrBleklfGyNqiSmhplnrzrQx7ZDZRD6mw1WxPMMWxUk7bYweO8FVH5eD/EldQ3pTdNLG8XfARlOqgRR7IRvdKx5WrrMU3snmvUyXsO2U8rgq3JFnLEf7fGvPZBBMMd2rQsYcS36ObPWeqmwBsYoM6Sh7rBLDqdSxDqCGJiLhSFs2Ary2yLg4pvvcAHiaLGcWelYEfftVLDcnOI54X9QGm7+/6JwvMrnqgJh1aN0KvVuawURrpcztL8IHTa65sbhJ0p8nCJigzk/C4ROv9x8NfT2TrG/wSL701AlxSmzAIzvjnD/36Yu0vBLqXcAvkCt4uwDicyHkH4rd2keLr5g3ZSpNdNrNfr9WBS5WvV9EmGzu85P6u1WdaRr/ac1mLk0tCPqYhi45jnSDTdL7BsZugauXahK7nxlWkJVNyKdOodd3trdSwhDUVIAJm209Qm9Yd7wGrcScDShN+eCJydyx9WVpr5a6i6dFD+IhASzdVgAnQ5lo/TVxdgMyMZkS8GTqTeB2tX6hgKQLf3sXZH09khFyifqy622oI7+nCZa87yyivotZKr3gvwBK57vmsNfuFoN
 PcLmu3aN
 3PUj1F0Dr/98O+W8TDzyZBUaf5vrS7KSonMRLl/7gEuxQiK73RIaBjSxH+I2ZBnzYCKsKX/nwlruuUdVaUrAT1G8X7YvTHCkRX+EyugrmLralugwfcawut2qOSxeYYo99Gu25sSqvd2gfN7+mLY2XuHzNVVSWOhtpw0foC3lJuJLlwRi6aa/aJWtcCsbd3DNR1idm9c486N2y+N6jxkA+tdL/Y4OfrHkbr4O0PtMymyG8mQLyuNxNAMLLc1N7FRMMS1Z2x4HLelO+3HGZNyqb8lKdLwI8BmbDk0x9B80n6cVam9xC+6O9C9Ok8QIZYEgRIGQ8H5hg1QLDSbXBZgwXzlCOj+dx1t765CDQLFus+V/uWTV6nOPvPXyCE6p1g/eqAeqVT9W51ulcI5Lw2iZIW1MsXYikOdP1bQmvSpJnuuYkjbLXI8uOHbm0TQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

This helper is no longer used after commit fd2825b0760a ("mm/gup: remove
pXX_devmap usage from get_user_pages()").

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/gup.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 95d948c8e86c..8e7dc2c6ee73 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2806,17 +2806,6 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
 	return !reject_file_backed || shmem_mapping(mapping);
 }
 
-static void __maybe_unused gup_fast_undo_dev_pagemap(int *nr, int nr_start,
-		unsigned int flags, struct page **pages)
-{
-	while ((*nr) - nr_start) {
-		struct folio *folio = page_folio(pages[--(*nr)]);
-
-		folio_clear_referenced(folio);
-		gup_put_folio(folio, 1, flags);
-	}
-}
-
 #ifdef CONFIG_ARCH_HAS_PTE_SPECIAL
 /*
  * GUP-fast relies on pte change detection to avoid concurrent pgtable

---
base-commit: 67a1f192fe6d4c1ee84e296e7d518bb881d03c94
change-id: 20251219-gup-cleanup-8146b8884351

Best regards,
-- 
Kairui Song <kasong@tencent.com>


