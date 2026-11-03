Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECD0E606D809
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 11:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=k1e81ZKb
Received: by kanga.kvack.org (Postfix)
	id 24B006B05B4; Tue,  3 Nov 2026 06:17:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FC5C6B05B6; Tue,  3 Nov 2026 06:17:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EB816B05B7; Tue,  3 Nov 2026 06:17:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D70446B05B4
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:17:40 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8FE68A7CDB
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:17:39 +0000 (UTC)
X-FDA: 85393557438.24.49FE128
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf01.hostedemail.com (Postfix) with ESMTP id D868140002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:17:37 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=k1e81ZKb;
	spf=pass (imf01.hostedemail.com: domain of xiaoleiwangxiaolei@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=xiaoleiwangxiaolei@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793704657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=rO8PyIeQTJjW9jZC3eDavQXhSeNQrxCH5KHGWPFOq/g=;
	b=C5VI5MLP87V5g4j9IgXdIkAORJ5Ow1pW/k+yah4cit6huzXxcz1IUOePjs7zJnjXpMrpQy
	tLR3o67rHTyinOUcse4nFBDAcjDT1fVpxTtpjVrKW6ePtrFj4Udl+06W9Wv2TXFwJjmbky
	CiFRo7wwmeiy8sjZj9C+CXSyxdh/+7Y=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=k1e81ZKb;
	spf=pass (imf01.hostedemail.com: domain of xiaoleiwangxiaolei@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=xiaoleiwangxiaolei@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793704657;
	b=b/Mia7t/tND/woHwn6JnzmIKUij0cWZGpECEF1z3HQoevJwZKPLpaX0xPOeB6YmN2swe5D
	+nf4C//iv0+9MlTA8+umF2wMjkSUQIryK/DiQ7kaL9wP/78BQ0xS27QwYG2mjgNUjx1+MS
	3N/ildmozcqMsjnE9S4fkCWfXCwDP68=
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-cdac6d19ddaso1599470a12.2
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 03:17:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793704657; x=1794309457; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=rO8PyIeQTJjW9jZC3eDavQXhSeNQrxCH5KHGWPFOq/g=;
        b=k1e81ZKbmVr0kLedX98UeegqhxZH3If0VNtPHq1KzBgSwN9bv1G+OyHc77pN8tBoMX
         +YpBeBzybc0iW4YC80/Ttxuc8sE5BgqFKlKkaFw3VNXyLkGaPHT0XBKM7QXTdwqd3BJZ
         x5mQcV6V6misXQeNgaF2scKtM7PCQ65X8Q1zzFv+UN4Pauh4syG1f8NTbvhxMlgImXd8
         CNvPSUYt9bJp6sNDaoZ9em+BCQyfUxNO/JdSKQlDggrOe14iNMh3frsV1d4sGRmt8QtW
         az/Fh978TJWTlErhVg+Nl2kH+OeXtr2J0WOCCTHVtiftwKHHlxw2FhVxGVU16QjjTko5
         yXxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793704657; x=1794309457;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rO8PyIeQTJjW9jZC3eDavQXhSeNQrxCH5KHGWPFOq/g=;
        b=vzcHP+Z2U8qDj2ID5lNWbEra5rjD3dBQPZtffKmMMcsYPkof+6b2CW7iazHq0RogCv
         IhpIPmPqrOCm1woHR6+6VjIhYy5ov3bvJmGZOuyi22CWTmQbUPSwd6PJgTE8iERWGPkB
         6OEr2MFAv2hY6oT9QgM4otXDDtX3aiKCVBNazs6HB3ozTg5Jd5LbQT8unNqNQM2lf+UZ
         9KzF/sacjDKVwcoFwg/XtYi38c5emZE5lEGY4PozumLYkNINxMpIV8EIw5NFLz4bDFN+
         MEnd/4cKKhXcB0mHi0WtlDNJq5zmf8uHtd1lb0n3AIqx15AuR5Nwv2J9LvCvrMJqlzLA
         wawQ==
X-Forwarded-Encrypted: i=1; AKwUvByfzEC71E+JKxMbEK6X7SEkLrQXItN2twzAGL7ascz5poyYVhrW1tOVVoKbgiLh0xyVYYVrfLUI4g==@kvack.org
X-Gm-Message-State: APuU4Z9OcM36wLBQJEbvj9ng8Udxen15647q1o0St5t/UHZG897/wStt
	mauEWX90T4aQd5GQUtiPo4VOQIDaxpBwX26kz5pKJ0zAoFO0Qo14ohJr
X-Gm-Gg: AYBFou2qrMP5KG5ABdHceYpWZ+ekufidygyAVpxaxtCKXJapwrqZE9NyW4UFxZaJ4Xu
	Dd5NjnnsUEI8SZnS3mhJWLvkn0F/Qq4wsl8WZ6gvYsAvrSRycxEeHybMak1blRd+ysgTkCZs0yu
	wMJMI6eyHUuKwNyNWD9dMU+F12f5o1kFUJrxVEzVC8cwZYsnZskFJL9TUmrifre2XKsgSHkcPk5
	UJkQ/nCROFvfM4nfBCHdpRooXijE8vEJsGt5eROT/evuWeziSLLJWQz36HmzimBY14SX02RnVIr
	JaFlWfyQDxShLTZtrZcIofIf9JQZ5Cu5KHKUmJXKduLijKBFG/Vpi2YeZ7nFpfpL+9wWV/IqU6D
	wL9WRC3nHcmsnbDGYmZUwyB1+RdUKYuIVUWzYiVeo/XLkwzEPLfyGfcl0brD9th1mmKzM5974Ih
	B0NNqmh3ZpLSiTIuiPuAQ3Hks74kEOPqW2j3PnPEyUEFzOAfiSG6RrURo05fc14VTyx2yqnOB2Q
	Ya+QPLWUh6EhV31GOGJC/nvrtwNnphuwme/xYBfQ9hMeS5pDDY5jtQ5jIWGXcnuZqtPQlPMWMZ8
	9m4wJKqm21fdX+A17fBped8uuIAl5/s3fkKiKsfrQXSB0hFytlfIrE9YkWsLArWbxZTJ
X-Received: by 2002:a05:6a21:3216:b0:3e2:ad49:b24f with SMTP id adf61e73a8af0-3e928e47524mr11186434637.68.1793704656472;
        Tue, 03 Nov 2026 03:17:36 -0800 (PST)
Received: from xiaolei-VMware-Virtual-Platform ([219.142.21.190])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8aadaf82a66sm3065147b3a.56.2026.11.03.03.17.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 03:17:36 -0800 (PST)
From: "Xiaolei Wang (Kaihong)" <xiaoleiwangxiaolei@gmail.com>
To: sj@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	error27@gmail.com,
	xiaoleiwangxiaolei@gmail.com
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	"Liam R. Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: [PATCH] mm/damon/core: reject empty access pattern intervals on scheme commit
Date: Tue,  3 Nov 2026 18:54:18 +0800
Message-ID: <20261103105418.362459-1-xiaoleiwangxiaolei@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3z3hn4jgpuhkzi1sp4tnt89eux1acuhy
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: D868140002
X-HE-Tag: 1793704657-804803
X-HE-Meta: U2FsdGVkX18r4lXKRG24gHmjovtRbF70bMeSXQEKxUEIzE+mZQovP2Nikc1Wx2VXmff8oTAbUwaX+WiQOlseY+NNxg5gBlY/fPfadeN+AJQ5vi3ko5IMDzCx0ZSDbnF//OxWK5CHUQ5ik/bQ/Enrdq8/FY4HA7eDJt0ujrUSIJ2Zsk6QTh6e0y91i4fb+lCEdPfJ9RifCKDUmvhlwSgOBZWG0WrmwN7AsUoDopC0fBSeD29U39Kx8jO5f32Uq+OuxKBY2we4eXgY6OAWIuSD88ZWXB1Q19bNwDH+mAeym0tY1b59gWbzYuVV7bGfbUENDfcGv7Pb8npPS9T/+wwjaq4oyjyShPy+2mO85hYBpw34Ff71hmlvuMXBTloARashcV3eqaBEJUuAnydZRy9yb8kO+NE9mOZSaub52HoMWprvitEJUkPqk1Uky/tfXCI+S2FBrkSD4GjdIcx4oO9EpkOEyIoKoNXbz3TtoV7OU9bLL+m+/1k6jG5z8CyIJfSCPABF1oALdI7UV30Gzm+6nseCVazuW9DUJ8kjRZJPCkPH9wgEZfMsGI9QQuKceI7yvJUyO/kqvyQJjDkH4xBLpjTMoYJBDHoqiYfj4B77hyZrmGEy17aejKBl2pGpOD3gV6gqaTm5rF2+Pd1dVeAwde0A8NR2hKspPnvnQB5wNhRj5MWIFjytNoQKeBNlcr/n4KhOd6aOQJQOlNco8fm1bQ4+nmiHetNIoCcHez43OXF4ReELr7eFPXTiXCZiQ+3x8ZnhRLMVob8YogDIURor4lXFkdXxz0h2JQZoipJIQHtEZCVbRRClfvwC3L3IduCSwcTzb6Uui/udLqZeVz1lcKYQJy1qEE2kl7z8woFWy6is3XDyF/sRjLs1BRDRU+ubMH7+K6zj5X4FL0KwcdxitZMLSaJZ5xuVm/qi99Uh54NmarHFZ7g5TdWlmmecYTrhaZ+d7AvnwjXbv4h/leX
 aIdlmRUh
 Mqg/jmJ23mRK9+uEg9r/Lnyg4DH+7EoIDLejwVhn7gsHBFM0qPlRoyTsnLaP7NWr80wvVJH1nbmTwd6eQac0N4fdN/4wWIUMh8MAVGQj5qBHzQkjCMFtFdHnaLTExX3m5mWihf5Hplduj2I3bc4Ep8QrwJdxemSJid4U21hL3jRkOnZeLYAqCm6QJ10Ob8cVXjKA43WLdhmO0H9qtpLgJPpBV7hE55hgnDHgQXDOeMYvJwW5lybkORs7D50Q/Gj6BS8o9T/VqFtxy6PQxlfu7akf5dXmqEPbknDANFASZWX6lByW7JIK397sIjjHfHjlxuHwsokuU4roCsE1SLR1EScUXJxrVkRuASOcGudXaLM18hdzTIt7p2os/FrbmxFKrMwgHfTIA0DghD/OF/DWi9FPy4aAYJlXMSgSFBpjz4+dW7PwWaLM2CwBkrtfQ6Asy1kQuUT1ZMxxIVkd0Z9TrQI+d47xFSd4ZOst1o+pUpELfT9zK8akwbqOpo57khnQyegBbIAbGWLsV2DT+7bXTAFUMumf0wJpdgArQY0FQWl7JqGuBezD7fwHh1/UjlSBgNwapG1OaGJC56WI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

DAMOS schemes accept access pattern bounds with min > max (e.g.
min_sz_region > max_sz_region).  No input path validates the bounds:
damon_new_scheme() stores the pattern as is, and the sysfs ul_range
stores are plain kstrtoul().

At runtime __damos_valid_target() evaluates "min <= x <= max" for each
of the three pattern dimensions.  A reversed interval is an empty set,
so every region fails the check and the scheme silently never matches
anything: nr_tried stays zero forever while the kdamond keeps running
normally.

With such a reversed interval, damo starts normally (rc=0, kdamond
state=on), but nr_tried and nr_applied stay zero forever and the target
RSS does not drop.

The same holds for the watermarks thresholds, which must be monotonic
(low <= mid <= high).

Validate the access pattern and watermarks at the beginning of
damos_commit(), through which both new schemes (damo start) and online
updates (damo tune) pass.

Fixes: 1f366e421c8f ("mm/damon/core: implement DAMON-based Operation Schemes (DAMOS)")
Cc: stable@vger.kernel.org
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Xiaolei Wang (Kaihong) <xiaoleiwangxiaolei@gmail.com>
---
 mm/damon/core.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index eb1fcdabc007..865627bda240 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1566,10 +1566,29 @@ static struct damos *damon_nth_scheme(int n, struct damon_ctx *ctx)
 	return NULL;
 }
 
+static int damos_validate_scheme(struct damos *s)
+{
+	struct damos_access_pattern *p = &s->pattern;
+	struct damos_watermarks *wmarks = &s->wmarks;
+
+	if (p->min_sz_region > p->max_sz_region ||
+	    p->min_nr_accesses > p->max_nr_accesses ||
+	    p->min_age_region > p->max_age_region)
+		return -EINVAL;
+	if (wmarks->metric != DAMOS_WMARK_NONE &&
+	    (wmarks->low > wmarks->mid || wmarks->mid > wmarks->high))
+		return -EINVAL;
+	return 0;
+}
+
 static int damos_commit(struct damos *dst, struct damos *src)
 {
 	int err;
 
+	err = damos_validate_scheme(src);
+	if (err)
+		return err;
+
 	dst->pattern = src->pattern;
 	dst->action = src->action;
 	dst->apply_interval_us = src->apply_interval_us;
-- 
2.53.0


