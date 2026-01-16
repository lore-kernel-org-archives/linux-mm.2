Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE344C982EB
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 18:44:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BFDC6B0005; Fri, 16 Jan 2026 13:44:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36DF86B0088; Fri, 16 Jan 2026 13:44:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24F606B0089; Fri, 16 Jan 2026 13:44:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 13E066B0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 13:44:30 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BF99216020A
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 18:44:29 +0000 (UTC)
X-FDA: 84338702658.29.75D0A1C
Received: from mail-dl1-f74.google.com (mail-dl1-f74.google.com [74.125.82.74])
	by imf29.hostedemail.com (Postfix) with ESMTP id 18A1F120009
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 18:44:27 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sLQNOVKF;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 3CodqaQYKCBUDFCz8w19916z.x97638FI-775Gvx5.9C1@flex--surenb.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=3CodqaQYKCBUDFCz8w19916z.x97638FI-775Gvx5.9C1@flex--surenb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768589068; a=rsa-sha256;
	cv=none;
	b=hi9YOdp2hs7GG7YYP7REzkgANIuO3detT9W8tmGiCDGll0eHpoM1GWQK0y+ayciNJw6n5J
	3prl7xXlLY+8FC2h5RGtBEvR5TIUNHYkIoYK/c/Xxrg8M/m3q9gDRcqFlmyUrRw1b/PAwe
	yixupjE1LaL0QPH8ku5ulj4eACfBBDo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sLQNOVKF;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 3CodqaQYKCBUDFCz8w19916z.x97638FI-775Gvx5.9C1@flex--surenb.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=3CodqaQYKCBUDFCz8w19916z.x97638FI-775Gvx5.9C1@flex--surenb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768589068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=vR+hsRwa2XjjiaLZeoNzi5LCSQhiLxUxHN38JIbsMBo=;
	b=MM3iT8pikHtrsxDOWfr6Edb6Jb9GI2p40Ilh5O5KO10m/HQIFEnFvANaJWSK8KgS1Bip78
	4TG+ELn/w336SwH9AQA/X0okdaBKyGpwm3Ae0Z95YcCPXgESN9jDgchXKLbUmYCcIKusFI
	G3GeY/HYJ1z6poP5pK4ddRdeTz12uR0=
Received: by mail-dl1-f74.google.com with SMTP id a92af1059eb24-1233b91de6bso4302335c88.1
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:44:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768589067; x=1769193867; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vR+hsRwa2XjjiaLZeoNzi5LCSQhiLxUxHN38JIbsMBo=;
        b=sLQNOVKFMZZBxlW2SEanR4mZUsj0zFikg/aZbovP7C16Dzg1R5mtu9xEMCftwtNHry
         GjgmhGTbciEv7Hi2PPEcVvQQC+skWN8DbfRKtyRxiv9HzJCpe+w+tw7mIsMtRw234FS3
         MQ8tQS7mupRFVW8J4IiPlaLHHYEGR8tDN/YSRwDa6j1mRnhwdGAwIE+s1iJvZe/26+yB
         IYYay4GoA3/1nHd7wIOHPjoCDZVR3NqaVSSJLV2E21nQ8JAcvPR4CFrKrFDzOVXfVX1z
         O/MfzjkAeAjlV1WevsH746ng/8Mjgix7g5ZNSVTjjRl4Z+RQ4spSURMEOW1X8tJnFymS
         Qr6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768589067; x=1769193867;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vR+hsRwa2XjjiaLZeoNzi5LCSQhiLxUxHN38JIbsMBo=;
        b=diw+Ik7RhezZp4j7AMKs3YP2wRcLeMhyi8oOHbqIFZWlaWlF2zKoU7zsD6PJPLOb3p
         LP+Mu6vctKEULHhuFt8zNu8zKPs0pnVbyEWzReiiW6XFKyHKt6vvsaEFUPNgpD9nha2b
         IHCWeWwNMbATUQhmFCQAi51n6EshcJPQSzDaR5ZNQG9W+8ruJUzvr3MS4jnaPLXfxSYR
         epzKAg6zSXz28zANBDfRv/9OnMamT30fq15u3POWA+mi1HzFbF9TX4//aZHJ7pY63LNy
         5g0X5zSalprst52fBfOHRvAVcMFgmCRmQdl+1ysEx/6eXXDf8BQv5E/F2qxfsY6mJrLw
         9hyg==
X-Forwarded-Encrypted: i=1; AJvYcCXiFrTDzGhN4uLeP0vh/1tM9zWFG9EuM4nylkaNwiFfn7TQc5MiT4fwlk6b9pe+fnCFAFE4xtkwHA==@kvack.org
X-Gm-Message-State: AOJu0YxSHWHGV1J2CHkGwgH9Gu39sehgU/vMvq0nbw4/EsypVtOgVwHv
	mja6WQuXUhclceUpjzVclZj2uoZWubkQ7X8tvP2vbhUDkcxZ3pQGAfTJqKq9HP0KxhYTpAqKd4C
	mVeAqtA==
X-Received: from dlbps11.prod.google.com ([2002:a05:7023:88b:b0:123:2dd9:db4])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:e16:b0:11a:342e:8a98
 with SMTP id a92af1059eb24-1244b282f14mr3555854c88.0.1768589066553; Fri, 16
 Jan 2026 10:44:26 -0800 (PST)
Date: Fri, 16 Jan 2026 10:44:23 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260116184423.2708363-1-surenb@google.com>
Subject: [PATCH v2 1/1] Docs/mm/allocation-profiling: describe sysctrl
 limitations in debug mode
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: kent.overstreet@linux.dev, corbet@lwn.net, willy@infradead.org, 
	sj@kernel.org, ranxiaokai627@163.com, ran.xiaokai@zte.com.cn, 
	surenb@google.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 18A1F120009
X-Rspamd-Server: rspam06
X-Stat-Signature: xnkgz9i8jorsbsot3f5np5qbddw8asox
X-Rspam-User: 
X-HE-Tag: 1768589067-480249
X-HE-Meta: U2FsdGVkX1/6itDmtd55hRqHRqDg8Ph7dM2HUkaatxeBSf6O/gVRZrxeQavVd0k1IUfLo49knXr3ngUaV6TH3yk4qxw8UJXVVqWJqcLXD2QsZ87FmMtSXghHbODAADM9YqIzMHmRuSxsUkOwt1iNXKIqawyD/yEKd49e8eQx/KZT4/P8PR9IqnLdiC9gI7EZGmesN//ucwDfveEa8YrXYMx9UEFbQD+syHPQe3j0wuf8uF42K0ZZjC+vSAgxVONVCmcml/9tfDOI/+JCpTB2ldpG0onCcQU3QeIIJdsU/okAPuWZ5wHKlVvXtxQsImMOcBg/lQ2dRdE34tjbBXNTBILlrWBqZF8Bqx8vGuy/tyD/ifCtn4JJSKDUvE42NrTAJU0G/ckWXBnXg3/0ejW0SXX4ZvajbC87OUEc9sXuRndLNxOwCDLa5A4NOugrm+vaBGDEfrKcLw8cLCB1oKddq3CWCr/3QUsSh3htNojQMCLab+n+TaDzk9GK2kYI6j+IkOOR3KpdNWvevIXp3yeW6xBA/uYtk19Fnan1FXrwQVqOH5QYAl+vR0aQCnVaZw23CS4JlAvl+bF5K6n4QjaXlVrS+g3TK9dC+FqQ4Ozi+rKv+ASnJUZj6OVDxKJp6VH012zLIYyGjq+Mi9rVZzdEV64DV2jG5Jz+oPdRWarFnR1aMuE0DVyiBSofnearuBNg+U50cnYKObwz5wDKrcHd76tANn/8YgRYB6XWDAZXbxUMn0Ael77UTForsVov9YNz1wygxNZa9bnF9Y1XpP5wI44vtgsp3nwgVFteHFosbphrDJ2gYzOCsWv4vCAp25rUuuY1Sr6EgfjTpolJHJMKzT8pavBRc9JTerovav1OIRXpSGImBlwK/OHliNPdBkifrrurbHbvaUAT6sPsI5t4kPStzGoxN0V1acVM+/G4Tasyg/lnvmZTa3idY+UAytp5WqytKJ4US9zfLcc/YGV
 FF2Je8rc
 37bNpbE7vVNlxKp+i3IqbPJlS4HAcElbz4Pvb1PQJq6g/HAT8h/HwoAmQ5BP1ujKoK/Xb8+6Sw3zNG+Ui5OgYt+8Pji0dLmewIWoGzXuoaL4SFftX8aomM8FBW68NEyezcs1Hchz0ZMOgGpL0aCLeEAxAMYvqSMI3f+GAmGVOxnAqSimZr0aT5uU9Q0f1PxFQzUfzhwywmTgbSLhPMnLoKJuvVoOD5eaxdrFe9lT6C3H/0xKQngz1wowqpqHzUUIgv5IOWaNvxhNr1xItp7jRFwMtpO/bXQJhjvgn5nlMehfgm+YYHbluKhwJD8vaQCYN8PAsb1w5ufXb25RrZ7yifhIIELqOOeDZqjhio5nIOlBP0eF+quPUiYDfOEtHTe7CD/m2Y4eSbk+NEjkujGH+IAjih6f5EvIVBGpeoOUVu6j1h5juM21/0V2O2QaFmsliaJbNczDk8/GAMTI2SeEfpD362YIiTwwW2aXV8X2CHmz9c2f/Ox//mIrJzJ0hSDVqzZoH9VYVZ2Tm9nR2yE62xJDAVdu/coAC4Pl3pv+ghMtTP4osAHWkb+8hEMowPvD2a2LPmUbq7c6Hm8uVzj+NXFR1MGQNxjrhrZskbVjrfzfJsytg91jXPU8NvMtj6e9+hhDpEEvUUQOmMILA+jeBNebsCQYtNN7ACRIF2/mXXvg3dXsDd0x5Q6P/zNHolfJeu87ktxqQNjkBy5Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When CONFIG_MEM_ALLOC_PROFILING_DEBUG=y, /proc/sys/vm/mem_profiling is
read-only to avoid debug warnings in a scenario when an allocation is
made while profiling is disabled (allocation does not get an allocation
tag), then profiling gets enabled and allocation gets freed (warning due
to the allocation missing allocation tag).

Fixes: ebdf9ad4ca98 ("memprofiling: documentation")
Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: SeongJae Park <sj@kernel.org>
Cc: stable@vger.kernel.org
---
Based on mm-new

Changes since v1 [1]:
- Fixed a typo, per Matthew Wilcox
- Added Acked-by, per SeongJae Park

[1] https://lore.kernel.org/all/20260115054557.2127777-1-surenb@google.com/

 Documentation/admin-guide/sysctl/vm.rst   |  4 ++++
 Documentation/mm/allocation-profiling.rst | 10 ++++++++++
 2 files changed, 14 insertions(+)

diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
index 9096e2d77c2a..b98ccb5cb210 100644
--- a/Documentation/admin-guide/sysctl/vm.rst
+++ b/Documentation/admin-guide/sysctl/vm.rst
@@ -487,6 +487,10 @@ memory allocations.
 
 The default value depends on CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT.
 
+When CONFIG_MEM_ALLOC_PROFILING_DEBUG=y, this control is read-only to avoid
+warnings produced by allocations made while profiling is disabled and freed
+when it's enabled.
+
 
 memory_failure_early_kill
 =========================
diff --git a/Documentation/mm/allocation-profiling.rst b/Documentation/mm/allocation-profiling.rst
index 316311240e6a..5389d241176a 100644
--- a/Documentation/mm/allocation-profiling.rst
+++ b/Documentation/mm/allocation-profiling.rst
@@ -33,6 +33,16 @@ Boot parameter:
 sysctl:
   /proc/sys/vm/mem_profiling
 
+  1: Enable memory profiling.
+
+  0: Disable memory profiling.
+
+  The default value depends on CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT.
+
+  When CONFIG_MEM_ALLOC_PROFILING_DEBUG=y, this control is read-only to avoid
+  warnings produced by allocations made while profiling is disabled and freed
+  when it's enabled.
+
 Runtime info:
   /proc/allocinfo
 

base-commit: eeb33083cc4749bdb61582eaeb5c200702607703
-- 
2.52.0.457.g6b5491de43-goog


