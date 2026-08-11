Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02E88C5CFCF
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 10:18:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 664366B0095; Tue, 11 Aug 2026 06:18:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 615CB6B0096; Tue, 11 Aug 2026 06:18:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DECE6B0098; Tue, 11 Aug 2026 06:18:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1DCCC6B0095
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 06:18:53 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A9D3FA03E7
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 10:18:52 +0000 (UTC)
X-FDA: 85088590104.18.7849E52
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf11.hostedemail.com (Postfix) with ESMTP id 014D740008
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 10:18:50 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=neWomt2i;
	spf=pass (imf11.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786443531;
	b=0n+x5a3KvNQ+P0Ep3t+wGfugj1rP5ABdjmmRrpubVL9p3z+ZAsw9mR9VZxkSHcvkS4qONt
	9+N16lKOoAOGAaqQ0C0F7gNrI4WruOSt8as0hUVffk1yAHVz5nnw7zDGMRi+KZXA2lmlX3
	FY6whlbDX8dLuqElQL9UsLDq7SLIiek=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=neWomt2i;
	spf=pass (imf11.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786443531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I31AMd/F7pqHT/q95Yi0izk7wYmZR/DesQa+ulu0/Xk=;
	b=8S/Z8O64rKKYqlBsuOGyjN9LR+Ux9gRxHermL+vYHhIIlmZPGmh+lAKzA9CKWvHqvTS6vG
	XtqO2xJ29yv6NrWqODs9g70X65zxqqLzZg2t7uUUrXUKGSQiM9txnV854/prmQOz8TYDqt
	uZU83+cqVdF8jtjYjlvfDcfGWsQv0/c=
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-c9d1fff21edso528031a12.1
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 03:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786443530; x=1787048330; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=I31AMd/F7pqHT/q95Yi0izk7wYmZR/DesQa+ulu0/Xk=;
        b=neWomt2iprWpMf7XLXv1GzLMywCdjsAfpYlN2EzxveHdYVXUan4+hBwL7dSYnNaenO
         nxyyLRG5CuNKvwpBfKgLK/WoXxCYPt4XIqp5WeKfUw3bjtGT2YFUw25Zxk4kKWEVuWnV
         WVkpM4/WKRJcg2HwDp4ZDHVF8Q4eXuPjpwnlzNWlY6sdxYIL7kKsT3qaICs6TB1Nq77M
         dvdwnA9Uytpm7ItUvPz7Rs3MePEJeL/qKfx2ZC7OzUSo/GZ+czNIXsFagCJqZcUozSk/
         IvZ44Eq0eo9UzZ8Nff1BfdR0CESeY8H9PaNPLWPIVswXNBYJqniF+o18gxjUrAA9psaN
         Mc0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786443530; x=1787048330;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=I31AMd/F7pqHT/q95Yi0izk7wYmZR/DesQa+ulu0/Xk=;
        b=OSWg05hBsn+clakv206MfOiYodJ8ULZ5pq0QG1fsuF5yiotlLzEwRgk5KjjhVVc1VX
         ZTJlOgGWWiGjHvCug90dg6zJ9TtQbJigq3WuDOdRn1P93XGA6YWOSJh8dOIIsFnpnxuV
         6e8pfx99yAjlgfiev8atHXoqk68ZI6QXTEFbKEGE4vsPua1NodpwlJwHnlvEGVe8NMB7
         2DySsOAcZgjqj923wCiUjaTCg2l7nR4sg5mfv5PjCtm8t8jCN5D8QaAZ254H4c2782jd
         wolhxUnNAGydEcgyWxN0bdiTT9lhtEyH4bGeX4HGFsjgVVMueJl1ElocqQ0dhiAnJ474
         JsGg==
X-Forwarded-Encrypted: i=1; AHgh+RrpK5McBx3ExaBnKlqzT3HhVI3r51gFAqyN69WSyKwoKCvylUI1hIUNYr0yOcvzk0Is76oEQYf4Zw==@kvack.org
X-Gm-Message-State: AOJu0YwQn4cEE6+NOBwTiyZvzzU0m1I5ex3B5fz9t4+ccZgXuKenRVbf
	0WNX25HaiOVZbpaHP9uAQu417KogZ/yeL3aFKpy/9OlZtef2P9KPVoml
X-Gm-Gg: AR+sD13P3+EkyDOB8f+qHNSzveNVgJjTgyku9xL7+eSPrFchPyB+5LxHjrePYO2LUr7
	Z0uLrRY1bW5Hw7PkTSsR5uHhMxcev1tjmqyS/CMkpAVW/8vMx7lp1KzXpTxtk2T+0nMQiCvyu7P
	TSIzwi+gQZpfQ7NinBwf+w2n9QKakDfjl2e7NH4j+K2yKliFSYbl9JuurukqKk00dKQkJd5Ixp9
	X6yUUCbOH3juCCP6jqCCVztwiCNos91dG8oCoiOWXEfOXoJyEkuLHRMGbc2IFPnSLU1HHl4mRJe
	hPWIbWNOr88jcZAIrJVJwB6lXsBCGvhS0nMr9pp8nguS0Nd9NzU50K26KOeHDzYeD+QpA1geuLh
	Ol+F9WUfxlZXrSIVmleI9sSrnIqXzef9ZkFuRk7Gk0/XDLrLEZlZyhf6oykD7hM5tD7TVQRmBeC
	GAbNLMAgGqYv1XrDKWA0XHSC8X027I2ZoI7t//4m88DOfOIpQKR2J9sMVHkZ2szRs=
X-Received: by 2002:a17:90b:3842:b0:38e:c7b0:84ad with SMTP id 98e67ed59e1d1-392ec13bb9bmr1723772a91.0.1786443529788;
        Tue, 11 Aug 2026 03:18:49 -0700 (PDT)
Received: from celestia ([2402:1980:85a:5c46:85a5:ec7:8aa8:72be])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1412042dd37sm3752328c88.11.2026.08.11.03.18.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 03:18:49 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	Liew Rui Yan <aethernet65535@gmail.com>
Subject: [PATCH 3/3] docs/mm/damon/design: fix typo of max_nr_snapshots
Date: Tue, 11 Aug 2026 18:18:41 +0800
Message-ID: <20260811101841.804596-4-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260811101841.804596-1-aethernet65535@gmail.com>
References: <20260811101841.804596-1-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 014D740008
X-Stat-Signature: idmisepz4ge8hoi177oau9bbq4wx77c6
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786443530-398471
X-HE-Meta: U2FsdGVkX1+zLR5AqKhkjsDCGfCXgbZXv/fgCpxokAvHE2WXcjA4nruhtW/MbBhTs/bbAMUFjH2gMiWrn9WrOz/D9JP/BaQEWrfjMB95KOLZTgU9XeOvjedXNNlnNtJ5Rk0+0LuShQYO0U+E95bD7OjzgLzROJtFN1ho9WP7u+cgV0//qkJ7yzQv5CenlTcNglZk/Zy7z6FBbsLFtjBRwuK+J6I7sz0PXRqnjNd1lC1UdNDlN8hKgW/BRjLtwVV38NSiG0JJIsli9fPTQCtAyemKTbp29pAk5VdB2HcmG/oIObfnSZVgWmRs4VSExuRuITOxPtW3haGTflpdpu5UD/X/D7xGfASkP3xtaHHWY6aYHh3p5mVpAD6FCP0xkKIK/cJaP7GQ4h3rJ63HgR8H0gjbs+pZ86FAxxLP4slc/aBveUU8YDN93pvbvioZ1XJF1JwgVpXI853BgKRcEKHUwWGm43EHecZ6aUfX3sDG9NoMQT8br7du8kOqrvMjEhW9KwW1lsDx0ccEXZ4bfelxfBrL83+FeT+i/qH2uEEjOPsfrs49IF0zcYWaBwnwzE9ymVvvy0iXkW5jmzPlDRSiFuOqCOMs803Ypl7ACxUg977H+PkMP29+GQZLiIkoQk40jY0ohlaILf6LL08UhkHN2HH6iYxLmhOfB+pSWn3YRtqMbpi2u5EHMQE/eqlKt5WXh/Z+z93mU8d3wEaGsx0JAy5CaESMPi+j/TVqVan7o4B0uKqeZOs0p4Afia9dZob4hmsrJrhEzAynImxR08VaKz3s2WnGh3Gb39WP0GhQD7wHvqjME8DDkqh/2kPEV0tWzFGO5aU6us2ttbJdzicrZmRfADnVOuwRVcw6X1J8hP89xEMYrEwCFfcpI/WwzXMgafYTQHiev3RRSAmR23hlEWVa9Ly1sNLev9F3ni5S9MYjyar1c8OCuDog5s4WlV+VjdfnePH4po4mUhnU0AK
 GngkS/Wi
 fjpz8LCQAiJm+Mb5m0bXTS33wiac/y4r/QdFDDOhWz2uqT7PS5ssRKE5tvBHmfsJtnX6LQqH7faUCIB/NI6cJHPazZ88LMoccnXbFx5oH0Q68ITglA9CrGH32V9qL1MiUD08W3moZeWLH2qc7O6Snv5XXAWnljU2ePRIn/8TCBAqlfT9Y9IaIdZ1mZkABGizn9Fyb7It9BaIxuyJiGRahFEchtFtEN5aYMuRhS28x2VcBkZa4EbjuXGtfTDaPpege9697HidnM6jqP7eU31P0BwimVZ2PXHPwpHtTnmzS4uI3eTDjCdYngFKzAmNEQCTase05MGZnSEbbPSdt9VwBPPERjPZdYBKx1HYsI4ZlCCNc3YyFjU449XtvXr+b6OJA4sM0Y4oXV88ZjzqyBtDxgCeBHceGvu+SIYyCAqxBpfvS7BqqqHWrWJf6Du0hAeAl6m9jUDMBzjOu7o7f+Uj9gIbTNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fixes a typo (nr_snapshots -> max_nr_snapshots) and corrects a grammar
error.

Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
---
 Documentation/mm/damon/design.rst | 4 ++--
 include/linux/damon.h             | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 1fcf0b8c044b..62ba6cc2e999 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -871,8 +871,8 @@ action is ``pageout`` while all pages of the region are unreclaimable, applying
 the action to the region will fail.
 
 Unlike normal stats, ``max_nr_snapshots`` is set by users.  If it is set as
-non-zero and ``nr_snapshots`` be same to or greater than ``nr_snapshots``, the
-scheme is deactivated. Note that, unlike watermarks, even if a scheme's
+non-zero and ``nr_snapshots`` equals or is greater than ``max_nr_snapshots``,
+the scheme is deactivated. Note that, unlike watermarks, even if a scheme's
 ``nr_snapshots`` reaches ``max_nr_snapshots``, monitoring will not stop.
 
 To know how user-space can read the stats via :ref:`DAMON sysfs interface
diff --git a/include/linux/damon.h b/include/linux/damon.h
index d642ce4fc83c..75ece3d03be2 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -549,7 +549,7 @@ struct damos_migrate_dests {
  *
  * After applying the &action to each region, &stat is updated.
  *
- * If &max_nr_snapshots is set as non-zero and &stat.nr_snapshots be same to or
+ * If &max_nr_snapshots is set as non-zero and &stat.nr_snapshots equals or is
  * greater than it, the scheme is deactivated.
  */
 struct damos {
-- 
2.55.0


