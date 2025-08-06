Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A8ABC87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 23:43:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B31B6B0096; Wed,  6 Aug 2025 19:43:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 263866B0098; Wed,  6 Aug 2025 19:43:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 152256B0099; Wed,  6 Aug 2025 19:43:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 02E326B0096
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 19:43:16 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C753D81510
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 23:43:15 +0000 (UTC)
X-FDA: 83747961150.27.FCC9BB8
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0A20120006
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 23:43:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DKIcqLm+;
	spf=pass (imf03.hostedemail.com: domain of bijan311@gmail.com designates 209.85.219.169 as permitted sender) smtp.mailfrom=bijan311@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754523794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=cfT15tOepazFTL2Lg8MMF8cCYjiRwORhTnogRj+tN3g=;
	b=f0ylVYR7nNuAqcawTdF6ceb8Bf68B8Ebgc6gISQVibH+fDLZruHhQLyzNrY0xPOO10v2a0
	GCq0iHhoKHDkX6/sSEq3wR0uVUbfz+fGZiqAgRwY/xjCA2eOJW4A7eYdY4ksaQOKndDlbL
	ZK1C1jF1il0C5BvMByKijUFE8mThK60=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DKIcqLm+;
	spf=pass (imf03.hostedemail.com: domain of bijan311@gmail.com designates 209.85.219.169 as permitted sender) smtp.mailfrom=bijan311@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754523794; a=rsa-sha256;
	cv=none;
	b=l3lAz2/SZdE+o/a/QeVp+R+3PwcNOIX1EoH6ZuuMSeXxUhRvQZ6/EvQDqPXpdl2BEpwpY7
	22QuXPNZi9SoXFuQjuNAANM45SrEexvUudN8TNNHMDTDlma2SWW+8CTmPfVbAHsXTglgfq
	lDK0pXYyIyegS7dlEaJCrFYHrslM0+I=
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-e7311e66a8eso389519276.2
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 16:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754523793; x=1755128593; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cfT15tOepazFTL2Lg8MMF8cCYjiRwORhTnogRj+tN3g=;
        b=DKIcqLm+ARwUTgwnEHIF8CiFWFzRJaqD+FJi1AD5oGD6x8NbQk32xhVXgqmAptK9vR
         HorbzILhj5+5L0qiVTMyAzCBNQaZDXN9QMuL55RduWk8irSOXRKiFGkPT6Elz4HF9ETv
         LIQQBKpyTfUCRmzz1TO04Bqe60Hw0lptvPCfcN/yXOKyOK9ZmgIWJB/gt6M6xN1FtrOQ
         psONIfLZe+S2Df0omNFWw85h+MjWZ2oVpPOVYQUYayvBolj7X1V4XTGER4/EEyPN9jX7
         XpoD8pMoTFmy7wUUnykhvPIZe4bSZ8hoiy02MbFsiX3vunGREU6xGUuy9mQOy/zI4eaT
         k09w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754523793; x=1755128593;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cfT15tOepazFTL2Lg8MMF8cCYjiRwORhTnogRj+tN3g=;
        b=L9MxlOHe8/GbOJ35kGAIo7KQXAcLgapdNBv8WS4EZ6h9u0OmaZTZoEBG4b3le00fAT
         Dp31yVr8orryYNajNICxaCVQlOZXgsiZ+u5WgxzSrrGGxEI36ccHewQXY2oY1X+kdWpq
         i4ICMYNSyihFv+tm7seouTs3xw0D13DCE8yYcKcWo4OfEURTdSfKGfFFpMkgjisys4s1
         zeDPS3uWhlixQgIecrSyDvJUjtB/CxCQnuNdeLD8SIemRsHXiVaUdI2SnuSM2DkUEd/5
         8wWtrrznlCXeMwml1+mq8B7sbdUwEmYmoPSBGX3Sb4/fcoJnBwDbIdqXcF9Rms6E9vSx
         TBpA==
X-Forwarded-Encrypted: i=1; AJvYcCWlPA9xRF7eWXiGFZ1NkihDmcxwfVWn5bx/Xn1mJZ3lBC+Fhkut6mnrnCrj1dhaAHnqceoTRngihg==@kvack.org
X-Gm-Message-State: AOJu0YygMP0vioPMhL55+vbLICXkQM/sBq/nNBa9r7+xe6kftRwVjPN6
	lBCs7wXA69P87CkJtBufjsojWEcNf7V8xJBx6m2iEJXj8PGc++Dt7IVH
X-Gm-Gg: ASbGnctLJhoU12u0aJGlkeLtfRMyVPWV9cSM0syl1h7fsu8E8TD1n0qZ6TmXIaHCCT8
	uId0cgZHiTnC+vLxUiWcAA5OWz868HQ43izbZWFyCkLLVhsKBaj4p+S2SOCMBdtRwTgjk+m8ECp
	xfLEr+SclUIT7HrShJxh6BRCVKnROXFYZyje+blm/42Qv3e199an55a7+kdD73NGuTUbb+p67CL
	saBjXY1eNZfQAYDoqrgI2VQbQ7RKXrnjhCwaAOd2CdRqDvfHhRRetU6+G+a6YiMbHpquAtk00AN
	kvwxXiNyXhLXpXGWQIZ5hh5/2q3ntcvtIOO0L8JNpDKQY9sT/kkDieo415EUruTVs9O5h+XvnmJ
	GlZO53i19Rk/suSmXVLXjjMWHeUzK69liABi5bAveUUfgVDeu1GFG
X-Google-Smtp-Source: AGHT+IErqUmAYFMk9ex7yBFNFktwhE0CW7kYKo02zKyww8eNDXZVT5/FhMr+He7/ul7nzCXLh9hJVw==
X-Received: by 2002:a05:6902:4389:b0:e90:235f:6c1 with SMTP id 3f1490d57ef6-e902ac7df0amr4638106276.25.1754523792936;
        Wed, 06 Aug 2025 16:43:12 -0700 (PDT)
Received: from bijan-laptop.attlocal.net ([2600:1700:680e:c000:9e66:4583:8a9c:a62])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e900da4155csm2593946276.39.2025.08.06.16.43.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 16:43:12 -0700 (PDT)
From: Bijan Tabatabai <bijan311@gmail.com>
To: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: sj@kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Bijan Tabatabai <bijantabatab@micron.com>,
	Bijan Tabatabai <bijan311@gmail.com>
Subject: [PATCH v2] mm/damon/core: skip needless update of damon_attrs in damon_commit_ctx()
Date: Wed,  6 Aug 2025 18:42:54 -0500
Message-ID: <20250806234254.10572-1-bijan311@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: te7a8uw5ypxpuqdxdz3zo6wa9mxhxkj1
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0A20120006
X-Rspam-User: 
X-HE-Tag: 1754523793-260818
X-HE-Meta: U2FsdGVkX1+ZEt2ba9lTQXytJV3sBHoD2XNEvxeIGDTuDIRg0Au5OiGRgTlNqLNHZwuh8A+sBXJNLqD8GwjxdiH03ptUqIStSkYfpA6mlw9sTKF8fmenq2OgYGdq3UuJ/b3Dp6gTQiEwS9hXOBpWZqXams7cz/kQ/MwrqG4mCHdY/kSGPk/lwHOXov75BQ6Lk3qL9EVSfTluDdnNv/khfO2nv/s6kwqvKnszwZUhav36dIuD4qCmW+O/jD3QKvJGEpZntMqOD/I79rA1ytLYkA59VjM4s9Tp8WKviqXSHC8npB6bSIbdOsComkjFLp6HiKNkvEuu+m5eM6bmxOU8rOocXxkMOluSxU34NLk2NIESMMr5u+zYS0du4F9zi1medgDTaR1UHLTrYpFzG9HTPCpZ8O+tPyErWSCreffLFDN3UqdKZMZ2KP4tBiAfIKqcr3YC6JQvRC47npIq3soXxuTuyZ1Q+F2Eeq++ysr09AX944PgsRQU0aiD2NuOEIZ96Vr11++Un6/LNEWrIXOQg5FYWyusAw+iOj/nxXYUrSZROBC4EF2NmY0vIeFUxKT31xUQPBr9bf5SfI/jg9a+UZV35K5/Y60BZ2AnwENXcib/rCF9otWtNkyalKa4nc3BieaCLtDfCV9YS1bndSXhGO8L5HEcLKdRt2h3Mn5tgRyVQeoK20SACVP8iAe1GIsmN92x9iJDENNLWdeb/3sMQ+NMo/uS9Kizx0wawcKonAoPAAHEmTs/7++fsaH2FNbNv2KXx3XdJQPRZso/Uz2BQKtDHUR/eVXYbrX3R0+hkEKGik4gzbNaA0IBFXigLt7qQ/pLH+c1YRi8+NBXiC6tlPzXHSlzMcTHE2cHLsmSbQHEMnnWj2oRT2wAs9ajbVdSki46/hu93E6LTEWP5+KjJitJgYeJpTWMG9ZVfvWG/APXOZwH7HNG47KE+HaSAd28tTOmdxC7skgHyCCOe2/
 xPy4WoT0
 rMSRCgUAy1TqVYP4/JANDd6e0AZS+5kq8v1O19xzHREm2iijDaRerSHoWqynhyYGVlxaBXHKYzQzeclw3M/65mo1rwaX1YMsgADvq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bijan Tabatabai <bijantabatab@micron.com>

Currently, damon_commit_ctx() always calls damon_set_attrs() even if the
attributes have not been changed. This can be problematic when the DAMON
state is committed relatively frequently because damon_set_attrs() resets
ctx->next_{aggregation,ops_update}_sis, causing aggregation and ops
update operations to be needlessly delayed.

This patch avoids this by only calling damon_set_attrs() in
damon_commit_ctx when the attributes have been changed.

Cc: Bijan Tabatabai <bijan311@gmail.com>
Signed-off-by: Bijan Tabatabai <bijantabatab@micron.com>
---
Changes from v1[1]:
  - Compare entirety of struct damon_attrs
  - Apply logic in damon_commit_ctx() instead of damon_set_attrs()

[1] https://lore.kernel.org/all/20250806164316.5728-1-bijan311@gmail.com/
---
 mm/damon/core.c | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 6a2fe1f2c952..80aaeb876bf2 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -570,6 +570,24 @@ void damon_destroy_ctx(struct damon_ctx *ctx)
 	kfree(ctx);
 }
 
+static bool damon_attrs_equals(const struct damon_attrs *attrs1,
+		const struct damon_attrs *attrs2)
+{
+	const struct damon_intervals_goal *ig1 = &attrs1->intervals_goal;
+	const struct damon_intervals_goal *ig2 = &attrs2->intervals_goal;
+
+	return attrs1->sample_interval == attrs2->sample_interval &&
+		attrs1->aggr_interval == attrs2->aggr_interval &&
+		attrs1->ops_update_interval == attrs2->ops_update_interval &&
+		attrs1->min_nr_regions == attrs2->min_nr_regions &&
+		attrs1->max_nr_regions == attrs2->max_nr_regions &&
+		ig1->access_bp == ig2->access_bp &&
+		ig1->aggrs == ig2->aggrs &&
+		ig1->min_sample_us == ig2->min_sample_us &&
+		ig1->max_sample_us == ig2->max_sample_us;
+
+}
+
 static unsigned int damon_age_for_new_attrs(unsigned int age,
 		struct damon_attrs *old_attrs, struct damon_attrs *new_attrs)
 {
@@ -1198,9 +1216,11 @@ int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
 	 * 2. ops update should be done after pid handling is done (target
 	 *    committing require putting pids).
 	 */
-	err = damon_set_attrs(dst, &src->attrs);
-	if (err)
-		return err;
+	if (!damon_attrs_equals(&dst->attrs, &src->attrs)) {
+		err = damon_set_attrs(dst, &src->attrs);
+		if (err)
+			return err;
+	}
 	dst->ops = src->ops;
 
 	return 0;
-- 
2.43.0


