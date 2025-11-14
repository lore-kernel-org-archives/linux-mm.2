Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 562CACE8D6F
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 19:00:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 836D28E0028; Fri, 14 Nov 2025 14:00:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E9038E0023; Fri, 14 Nov 2025 14:00:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63A8F8E0028; Fri, 14 Nov 2025 14:00:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 501198E0023
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:00:24 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 120B913B226
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:00:24 +0000 (UTC)
X-FDA: 84110128368.29.30FAEEB
Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	by imf26.hostedemail.com (Postfix) with ESMTP id 23542140013
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:00:21 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=hJzrH+gR;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763146822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=01MmDex2Pd6rSH6pN9DP4qcg9OhX2+hS8KGFIWtKr/Y=;
	b=So5mFXDsklL/CZ/PR5DhztTzHao75WRx8bPbbNWqilnl0+GqosgiGm5EHzloAZknt2H2zy
	aTe9Lr7eeAQ8UCmUdRJo01uhbK9P/r/YhTeCqCVF+cg8DG6Svv/HyDX7LzS6XsStn06WUZ
	bKNhzwQo0NCaHULOfgPK0bjpd9WN1uI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763146822; a=rsa-sha256;
	cv=none;
	b=cQaJrfbVzXS2F9Bk0VgDpl7meGlFwY8XxsSTyF27KohsTRBX5ZwfX50kziJsHMGdHe2925
	hpND/hvXClNsygE/fu7Ua5ib5DBrVK10Gr7YNfsUJwAOmXFG+n6aAllOuFVGvne3/UBjM7
	xFDtOhiKlyn1lYM7vNKqd6IMWygLx7Y=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=hJzrH+gR;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-640b4a05c1cso3068910d50.3
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:00:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763146821; x=1763751621; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=01MmDex2Pd6rSH6pN9DP4qcg9OhX2+hS8KGFIWtKr/Y=;
        b=hJzrH+gRaoBVho6oYmxtrEcQ6P603FNGlrHMkJKfb+1lSp+KmJpFx780KdgghnQ5AI
         oF97hariYKZN3CKpWA5w1YZvlerU+VKgVUUugSSTfWGFsyE/f88jNveSuDqv8zSlJ6p6
         4BP/k2QVcOXcVfTbmoGL6JNzKB7ZrN8FRwShqoA1pW7tsgsOVgiz3wWtFZg1Jh+SXfHI
         idXwSus3RG1Wf+zvvE757g+pL4M5gxQrQEFsZwUqdLnv/lAI0Qj68AH4XdtY1+YYgRSS
         4rGkZAQ5ZZ3qGqEKBppeWDrhCoy1sGz1C7LUR5BG52c+pe/8B+TFwLkq1/6erdqvdfdz
         4gmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763146821; x=1763751621;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=01MmDex2Pd6rSH6pN9DP4qcg9OhX2+hS8KGFIWtKr/Y=;
        b=iNMsWkw+xQ81QTV47IrP38QuIjAf0DdK6i+Yu4nH31pjL/uyfJ5D/kWT2A7oVNG1D7
         L0qPqcOs8QJk/LmGfBp4/32iBlWnrsyplXAvGgBNz8yJ0l96r5nKbfmECoNjBSTS0P4x
         tlV4PgClzeYXTVrtHGCMaEsC9+L9CtPWp5BiqiXv7zlyDCH6W8ZCugys8ykcWbt2K9kS
         ef7ybVrogioTRkav7YwccIed8O3i0bB4zfTEAJ1rEGTYWHtvUgjlmDcF1fwq0h+YXAcr
         RtbbNlVnHuDCCoLuRg9Q7jPSOza/AgogI4AlomLHIGDmnrYClYhBDUnXlkRjJWjWBkd6
         MlTA==
X-Forwarded-Encrypted: i=1; AJvYcCUvKE1IivkVM8B5TT2rtn5KNDnaVXKj7MJjc1vikSVFIm2F7+xmjUNxkuzfplFG8nOyB6RebtTfEA==@kvack.org
X-Gm-Message-State: AOJu0Yyu3IZcBlduWgcECbUfisX9rmhDZC/7UC8XnYfvDSBz5HIRadW7
	kdwNXRl0EjQBoRWPlKHapA7E4hgGhq8a21k+G8iBJVh/WzON8xy7LcKSyLNL9/wsnqo=
X-Gm-Gg: ASbGncsrjNfMXweXWo1tl+oA7PjlydKse5HCqYVNtxBeAxuXlVsdize+O2Yp/XG8f0/
	FKnrzo6f+84xn3X5BPgLyinjHJMj0khBaYXVK9YzsrdQGzUNEJq/KFkpIjd5yOIJyB01nfVg2c3
	g/N0sPm7IKVEozK6KQCQfS6Lgn41O+O+b/7d1azYBkUNYzvCwKUQvcCEqt3lkrDE4Lh36UILKJE
	qUi3Woy2fFnHVbH5KDx318vy3/PO6pJpRK08jWFSo8q2YFvz1IzKh5r8fxRKoKZ6kCrPlmxke4y
	7hn6yacsJAe33E0SjHSrTtUDWSmc/QRpY9PO5k0gtHDTAKz1wq0ORxPSkK9oRC6r/piamWeZN3v
	6tbKiKJpUj90+64h5ddQBl3v5eXWelbfFtEw7IfwnLpZq8YBsePQTMH6Dwww1ekb2yshso9m1yB
	XOsJJc/j/CtDpdI+PdEmO6lIiCsPV0thCKHKjliDOXJzt7WA78ydEIgCbqG83Lzk+AgAuqy9Vyv
	Z5LNoQ=
X-Google-Smtp-Source: AGHT+IEh8QcCgJsbND6ZreOs/yM1aLmQLxoU8QELH1/e0TqxBuMxcDBXrCAfWHESdHhM0I5QjIMNCg==
X-Received: by 2002:a05:690e:1581:10b0:63f:b366:98e3 with SMTP id 956f58d0204a3-641e75052bdmr3181860d50.23.1763146821080;
        Fri, 14 Nov 2025 11:00:21 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6410e8f4f2esm2014058d50.0.2025.11.14.11.00.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 11:00:20 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	bhe@redhat.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	jasonmiu@google.com,
	arnd@arndb.de,
	coxu@redhat.com,
	dave@vasilevsky.ca,
	ebiggers@google.com,
	graf@amazon.com,
	kees@kernel.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: [PATCH v2 13/13] kho: Add Kconfig option to enable KHO by default
Date: Fri, 14 Nov 2025 14:00:02 -0500
Message-ID: <20251114190002.3311679-14-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251114190002.3311679-1-pasha.tatashin@soleen.com>
References: <20251114190002.3311679-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 23542140013
X-Stat-Signature: zbidykk6x86jt9uf8j375naem8kkkj1e
X-Rspam-User: 
X-HE-Tag: 1763146821-539800
X-HE-Meta: U2FsdGVkX1/87R9bwJxZrxbXb/eVdTzBAfLmZtoEZAoXZn97jgKqe/7f4AwjM1OqZUg4FhguSTUSVhe3EAk0VKlTpaQTZMihtKGOVUOdZxuh4yVeOaZ1YiHENPn3tdYTdcfKp8qsVOFpnAjFjKP7L/tPloEZmKzvGNadStkkg7Vi+MCWH62QvySMs+1FLE7w5BLRcK2MSIId6q6Pkn1JrW3mLLz14rI5lvfJfEZuIJdu7M3UcW1N95MerYcyiZBghItpc1uUGAte7KK4Z6VvH2A/53iS76W9vMB4WRLKPcBjQgD/JxAwgB9HQ4TjOQ3peW51MuToF2cQZxdprUYc289gPLoUdb3quBMMKIoH+RSP7sJCeEmItwmtXOkKtOYi1MfmLZQSvjoIPXfR5IgnUFXHZGQ3KY7ssmztSkvfsYRVLtPc3O2ikMDu/zDtV8tYk5W7pGVokkq5A+/O9pIwzZfGki58sB0z8cW/Mycmlu7gESdnml/l4NdEmAfpIA3vvgB0mf9Ii85Jsn1sHTA6srJk+FfGghiI0JV6byig6cnvhLW8aD/QEW91QpJHbSQS0cKlKUDBIYyG27tGry1gW/kgE4nG5c2LqvJZeTNbEb8TogZBUOPOJTDbNq9Yh17uG0Hqf+CI0XIwFJiEV9iqdGwViU45IOfNTVwsFBWQuWriFcCaehXaJIE2qWodZ+7R1jiTNzbFvR6miok4m/NXnfRorHjoPQhm4jFpoDnQP1hIENK+1/FCmNM7p23xNmANlOectfI1hOKn7DuzxZpTKgcwSNokG9xiGh6r64Pz4E51dmPbgBhDihHTgTzjOO3p5cQKPlItcvQDsnVVxUqUNEIe8BVa9IISj2I5FWQ11Hxg8rTvzhmzll8bCcBai9bWZpSWiUcuWNxHIHF4YvNN3TwOmgxqWmCBVxN9DMmwfrRYS1H7zBANFBKB3keIAchmX2L/lOV44di7OE8LZtO
 obLy6tEq
 yFfWi3GOiS4aHYaDHiVBr974AZUhlQcQmFDAeprrarJWMksZBlzjOMgkbqVGJDwuK+pYT+Y88qdi/qy9N+UvXQ2onJVVZxxrFuoKr+3lclIUYxXq5whCHCMtld9egkRxnF5EOeQcguj29bTRTFbHKg+dN+km71KeDgYAYWGihJyP9xPDvXpU0us1yTF1ZLYvkeIW5ZoVoO5wWLils5RAn1jCYN/InqyNTJK/P7NEpeypSLG3PX401H5rtbsKyCzb0Rda0+lIN1I5NQJuYHA9OJo0L++ZMphsajugYfrATdCSJtd/d8/XHH5YsIYxatkvCSK+g1pKXYyAdjTWkOLkqH0786Yqmhcxoqkts
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, Kexec Handover must be explicitly enabled via the kernel
command line parameter `kho=on`.

For workloads that rely on KHO as a foundational requirement (such as
the upcoming Live Update Orchestrator), requiring an explicit boot
parameter adds redundant configuration steps.

Introduce CONFIG_KEXEC_HANDOVER_ENABLE_DEFAULT. When selected, KHO
defaults to enabled. This is equivalent to passing kho=on at boot.
The behavior can still be disabled at runtime by passing kho=off.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 kernel/liveupdate/Kconfig          | 14 ++++++++++++++
 kernel/liveupdate/kexec_handover.c |  2 +-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
index eae428309332..a973a54447de 100644
--- a/kernel/liveupdate/Kconfig
+++ b/kernel/liveupdate/Kconfig
@@ -37,4 +37,18 @@ config KEXEC_HANDOVER_DEBUGFS
 	  Also, enables inspecting the KHO fdt trees with the debugfs binary
 	  blobs.
 
+config KEXEC_HANDOVER_ENABLE_DEFAULT
+	bool "Enable kexec handover by default"
+	depends on KEXEC_HANDOVER
+	help
+	  Enable Kexec Handover by default. This avoids the need to
+	  explicitly pass 'kho=on' on the kernel command line.
+
+	  This is useful for systems where KHO is a prerequisite for other
+	  features, such as Live Update, ensuring the mechanism is always
+	  active.
+
+	  The default behavior can still be overridden at boot time by
+	  passing 'kho=off'.
+
 endmenu
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index a7f876ece445..224bdf5becb6 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -52,7 +52,7 @@ union kho_page_info {
 
 static_assert(sizeof(union kho_page_info) == sizeof(((struct page *)0)->private));
 
-static bool kho_enable __ro_after_init;
+static bool kho_enable __ro_after_init = IS_ENABLED(CONFIG_KEXEC_HANDOVER_ENABLE_DEFAULT);
 
 bool kho_is_enabled(void)
 {
-- 
2.52.0.rc1.455.g30608eb744-goog


