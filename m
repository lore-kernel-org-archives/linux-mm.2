Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54129C5DF7E
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 11:50:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A7316B0184; Tue, 18 Aug 2026 07:50:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 457B06B0295; Tue, 18 Aug 2026 07:50:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 345C16B059B; Tue, 18 Aug 2026 07:50:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0CEBB6B0184
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 07:50:05 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9A1198094A
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 11:50:04 +0000 (UTC)
X-FDA: 85114221528.26.0BE2813
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf14.hostedemail.com (Postfix) with ESMTP id DC8F910000C
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 11:50:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jxf20WoX;
	spf=pass (imf14.hostedemail.com: domain of hemanth.selam@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=hemanth.selam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787053802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=l1U5ZWa2tue/tT4u4ftKlc77EC64ZThcLUHsYap/X3I=;
	b=8a87k4GIYkBWyZMcWd0QoZLjlpNbJhnxnEV1DArr/SQ2LjGdd8BZe/FBCSOh8uoTKpv9hL
	q2LwrGzHltwuJVuNZYZpzydAak59/YbBxwbOXUKhdhhYBnQQJ9P96KlBsEtBs+2c4F065W
	GyUMC7wVBlabzveoGXV2LvKXaNhy5SQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jxf20WoX;
	spf=pass (imf14.hostedemail.com: domain of hemanth.selam@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=hemanth.selam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787053802;
	b=YwQTh1XN+sRrnt3iqJafJkabmc+opj8QDKtOpfBsXwMx/oTzyk7tRl4dkYA/HKdnIPkO27
	+1r2jB5hTXHRQrmDZQqzg4V3CQ3lLKuHc10TINY1JhyHFELeOIOk+/XGqQWdC7N2oVe4y7
	amJI3/tWNQQMqGDmF3xoaES+FDd9Vc8=
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-ca00f126b7eso2987596a12.2
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 04:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787053802; x=1787658602; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=l1U5ZWa2tue/tT4u4ftKlc77EC64ZThcLUHsYap/X3I=;
        b=jxf20WoXfuY9WPRgtSNVqlyoxNuQUGJRT6pQ3Cd+6FoMxmfoAc0B9+zOFTOFmk9b7h
         3VVY8k26hLgaKgCrzE/HoVW6husJcNN9js0mdhVI5YR4kMUViQ/pBi46LG4FsmjHTs4B
         7lzR2NxIIEwtrPpsP2cXoyanlVF4f27vr0rHqEk/COfZ+1nL6z5V7QuqEYJkZsprD1pz
         BwTg6PFnguMfzL9OpcaY5K2P8ZZjOsNTQUOAzIfyEH+kB6OXen63hxz2AJ01uXg+Fl3j
         DeJ8gh8ZjwiRfSE/EFJO5OiZltU6Kp+xqmkA/SyQuUxBN2LuZ0C/1rYtD+7h5bDpsI7f
         lT0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787053802; x=1787658602;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=l1U5ZWa2tue/tT4u4ftKlc77EC64ZThcLUHsYap/X3I=;
        b=hu3Z5VtlXfIr6H4uJdcZ9EFrPvBRpQjuXd40nSY+s8ZT5eH77bsmGeyq5w5FSn0/Gm
         TVUyekaLGYVbW73RvTh0US3tUKw3qMtvlUmfwIRqZbh36RzyKK4sNFWCidevZ6Y/QxMT
         JnO37MePu1TsI8TOUIC0o1W5OIIY8jo94H1nYCqKu3znTFLn6Z4/XMLa2JQvYuMAhndI
         YI9QbJGrANc60rsfYJ/LA+zUOUVWtPY3F1tbQzwoxWboP1uOXd2Np0omB2lQ4xqnj9T6
         nAXYd4JULaVmmReAhZ4Mgjw8XCCy7p5i3tnX5qZXEOdAiqq19tm0AXS+cXaYKm4xSz/W
         5+IA==
X-Forwarded-Encrypted: i=1; AHgh+RpXXJEBxZx13yDEnixJbIa3MfVfHnwKiYWEJYbGwJaPQ5j+FkR2Q6XHn5HUoszxu5v7kbhR/Ky2Yw==@kvack.org
X-Gm-Message-State: AOJu0YwdIYH4zh3C07Te4UXxD9bp5tw3hNgojIgZfngwIHB64/TD4w++
	j4mc6Z9Bnv52mcRKUOtNa3DkC/LROtygGxALRAYwjgjksN6K4XkU5sYO
X-Gm-Gg: AR+sD13O/E+idAw6oFiMGdkF+rnzZ4ZqrNiZZLJVzu9RCIQJFQPVx1BFJoXhS3v8VRn
	Ix56fs6/BXDJUK7B816H4XUsm8AHGpRHX1LEb2ExislzCSENjcK4ncwnft9vXp/fTE59TXamHD+
	sZBZUJY6sTLNsDl1SbySFTLPLArkSTb6QMPRwRae3zYLbLSOALBXvYPx1TcLjysBlxgpj+NnYkd
	aXoGs9g9U3qAjeA1JpKnZbLJHw2AjeR6JdQHfFh9ruo5+OWPkf5YFtho7lZkFvsxUFrj3RiJoQa
	P4kUOqMsIGhO3V1lYOPIWBxR4Ej5ilpen/UfOlKi1zOgDTCdijx8+TOBzA1ruxtf3pALtFnLTdg
	OeHgP8O0in8R94jak3g8wA7I4mTRzhO4jYQN0aR+uLml+Os6VKqGk/wyjwg/ddxo/jGzKDmtQhl
	viBlXKo56EQOT0n4tm10a/4ERVfl1oAN1kxkS7L/WQnUfHGpc3w6lTNI3nCbS4kWDnbNCxQcE8m
	xBa925L2zQ55hAiGu+5Pw==
X-Received: by 2002:a05:6a20:da0d:b0:3c3:97fc:93e1 with SMTP id adf61e73a8af0-3cc71e2b434mr41265772637.15.1787053801602;
        Tue, 18 Aug 2026 04:50:01 -0700 (PDT)
Received: from volcano9f8e-host.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-32678dceb20sm14736628eec.3.2026.08.18.04.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 04:50:01 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Shuah Khan <shuah@kernel.org>
Cc: Yury Khrustalev <yury.khrustalev@arm.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hemanth Selam <hemanth.selam@gmail.com>
Subject: [PATCH] selftests/mm: remove the local PKEY_UNRESTRICTED fallback
Date: Tue, 18 Aug 2026 17:19:45 +0530
Message-ID: <20260818114945.1312987-1-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.43.7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: d3j8qdxf44prij7pq8pew8p96h4qa683
X-Rspamd-Queue-Id: DC8F910000C
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787053802-767903
X-HE-Meta: U2FsdGVkX19qd07e1nOc4XiCWgI23VVjHa3AC/9Hfwjn87AFprs/P+j5e8tkuOuB3Hwd+HLKjZHkQdcu9F7mqCDQ5Is+3GOg0AFzQ8u8z6qDSUy1PNIeWi368vK9OVuWrEL0qBN+mHnqCLxQlPiwxK+QIgzM58foyNhYHKRO+WgHDPV/l0NwtiVSe++jr3k0S/1UjKaV0ysku4r59+klLEIDK2e3CHXXG2lf2OrmXcV19tKUheXn8WGTkPQseu+AWcCw9KFVqL/CAqUOt8q8gG/dMAuzK4sjINgpf0A8unaRE2nRrSzHex606MFVcXTGxKeqJ6kjnMiuSdyqsLAwD5Wvlw+l2Fh5QYtAjVO/iBDmshY6+JaI2o81K9Y6x3SBnOtap2jo0vPvlQUZows3c9v13IOXBL9nuWn51ZRSiwb9f7SimFXbeNkHK8htS2jMNK7yC4K8J14xYSfOpNd6VSTTHSOyJWyNe6007FtP76POmgefNe7YoVYjQD8azQWc9ROa+jDZqIYGGujM8MoT/tMjnNCg/b0QiyNE9BlZUJDuVbxpUDxJOnlMtt0x9HL1h4pZxbVQM5RtpcKt451KGF+qIhvfyh28CDeM8CPyXOHzAUTCzHlA7dwlh7oTgIMzATnEtLzZoMd4JqdO/L53UVnwiLSZbos+2O628RSaPKoIImS+3zJ3+vraNwmNy8kMqB1Gjm746Aq4RqP2QP0TW1HptJJtzj4xWjxV1T+icmeZVDreC0cKcM6NAKhyQC4IyTDT6RMkCb93B1vmJD7Ji4BNwdr1hoCrAoY9Wu9DKMi+LrzYXrLR+fhhc5OlQL5m2/1C4lWXjHRlvkCNMD+wi/jZXWabpGLKZVtUKp2ON8GlCRAS4QTkuWUlfiw2jpIjeXeEvUEfiFMmyu5W5+Scu6h1rLrDJJ13Wg5fdIIHLD5j/dWOO6bIg1wlwiRPOc1t2GyKi2XpX6E3S8EsNRH
 MzoaLQv5
 MERmD6SCVcE7YWUAy5raq2+nwDsoWt1Uy056fZNVvyAPl9tZOjSpAPYtmTiuRlwvUYfQnOokIs4/4Lnz8/sEnCI/3znozhPMMyHoz6taTw44WUZgK4L/P0dxuk5/9nr8Z0DaoXsYBtEYk19HsB9TWlsWPQ1ZdfP1VFU0jZug84YmhaJ61RNwNwJkKywdM5DrU4CI8rT9grGV5Xl2GckEJIkp8BnrrzpyNch7txAZw5vS7PwTgjDuLZ9DxE6TeH5NRrZm10RTUAeN6n4YpFSxK47LmsufSQIO+XZ3Mj+XzUC09z6p2vdAyXmwHuDayPlByhz7P+FNHhCqHQIffRCQfsH1Q2OyVT7itfuJBBpZ2mad7lH3XplGFGNr+aQk9iKLsWIyNzrXFsFK+lJsu1a4UK0SG2XIjD5YD0Rx6RsClDwsghdrdq+QXG5uyZaMyzWR1APVuXOv0KOL5J97KYywdGRrrnl5QpYHaS3tvrQytPJxDuU4nkqL8OReP1ko6tDoyI9+EnGHfB/S/rKIp/RZt2C04KYAn9lpLvb3U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pkey-helpers.h defines PKEY_UNRESTRICTED itself when the macro is not
already known, a stopgap from when the generic definition was still
under review.  It has been merged since, commit 6d61527d931b ("mm/pkey:
Add PKEY_UNRESTRICTED macro"), and pkey-helpers.h already includes
<linux/mman.h>, so the guard is never taken.  Honour the FIXME and drop
it.

The mm selftests build against the headers of the kernel source, see
Documentation/dev-tools/kselftest.rst.  Building them without "make
headers", against system headers predating the macro, now fails to
compile instead of quietly falling back.

No functional change intended.

Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 tools/testing/selftests/mm/pkey-helpers.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/tools/testing/selftests/mm/pkey-helpers.h b/tools/testing/selftests/mm/pkey-helpers.h
index 2c377f4e9df1..626c2e1655dc 100644
--- a/tools/testing/selftests/mm/pkey-helpers.h
+++ b/tools/testing/selftests/mm/pkey-helpers.h
@@ -112,13 +112,6 @@ void record_pkey_malloc(void *ptr, long size, int prot);
 #define PKEY_MASK	(PKEY_DISABLE_ACCESS | PKEY_DISABLE_WRITE)
 #endif
 
-/*
- * FIXME: Remove once the generic PKEY_UNRESTRICTED definition is merged.
- */
-#ifndef PKEY_UNRESTRICTED
-#define PKEY_UNRESTRICTED 0x0
-#endif
-
 #ifndef set_pkey_bits
 static inline u64 set_pkey_bits(u64 reg, int pkey, u64 flags)
 {
-- 
2.43.7


