Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32419D11183
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 14:11:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90D926B000D; Thu, 27 Nov 2025 09:11:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BD8F6B008C; Thu, 27 Nov 2025 09:11:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D3996B0092; Thu, 27 Nov 2025 09:11:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6B1AE6B000D
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 09:11:48 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3F15513018C
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:11:48 +0000 (UTC)
X-FDA: 84156575496.07.A7CB7BA
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4A4A540017
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:11:46 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Iq2yPUCq;
	spf=pass (imf11.hostedemail.com: domain of luxu.kernel@bytedance.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=luxu.kernel@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764252706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FPuxDa0NXAL0s5rvqqEK7cssEYmk0gHTIqKy/7wy1IU=;
	b=o9EKSs6t5QcxYMJn5mAi4angW6OEX3WrWl1pes0O4WYPsO1Fv/HEkxCCCaq8hm/gAl3tgN
	ZRsLvH6DhWfs4DC7i6q9lxRE0L9sp78KgI/F6gSix+o7mFg5bhspguHkT1SXcecZ88/fUc
	/bEZ13dYHWB0fhYNeCzGG6DxsOot+ls=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Iq2yPUCq;
	spf=pass (imf11.hostedemail.com: domain of luxu.kernel@bytedance.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=luxu.kernel@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764252706; a=rsa-sha256;
	cv=none;
	b=E1yBfoCVQPVwtHg+cT0GGkP6k4+VFXKVPqxVstw/xfjDEq3yZBDpBN11Q39ZXu4ZDlPYKy
	/DctOkpClSOqYqt2nfLV/5Nlf9Y94cwK/mgoaC2oT91gE39XjL/5v95ZWT2CGUfMlweQHt
	7gciKIX0/WEwINyrjVEEC1PF+j03YMY=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-34585428e33so941960a91.3
        for <linux-mm@kvack.org>; Thu, 27 Nov 2025 06:11:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1764252705; x=1764857505; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FPuxDa0NXAL0s5rvqqEK7cssEYmk0gHTIqKy/7wy1IU=;
        b=Iq2yPUCqVVoSOVy83H3HOP+uKCezbFa0CLv3xbvVv0/Jreon4LFr5dHog5BK+mYdn9
         SoNAwt0hGSjz1X8N7CqtxHzEHUY4ylR8N+MFEsUYja1lWa6CNIOggwI+yN1jL7pEnc7q
         fjh1HonMvuZyi+OIucRyfzuFyBOeuzo1yBC3fZALHfb3wF5uZ3Ior6pwvY8Tdzd784k6
         PPaTVF5xlJAb+I0Xv3CWBoZXGEl4rs+ORexLUSzyVLsWrE1z8DatOL87dsU3djM9XhUU
         ZfwXhO/wUPqhUXZNrxPKrtXrl7jGDnq5lTg2diMHfikMKrd6fNyTrypxx4N/Cel+pr1L
         AkZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764252705; x=1764857505;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FPuxDa0NXAL0s5rvqqEK7cssEYmk0gHTIqKy/7wy1IU=;
        b=gRw0t1iOWhbEJRpOmcnkMxYY1QKwEaZ+X7ICQzRzUcl5YJ88PY1p0QxHe6/cSm0iEI
         Yx+HIi6BfJOIZexib5UNbwbYm6mI/PcoffqwK0kUgHIn06um9gpW2itHI+L1pudVyo3F
         AJR8mWNdg4SKrGRWD7S3NY/CTD7+Of3ZNuX5lG6g9F7Oh5MxVv1jERnKqbAA21st/QfL
         RuPCUJMaCSIBNio0+XrAmh1KFQChsAJZ79tBByqW363olFCEeX/O1yQz3oVRQQixuK0a
         Osn0BgDmPF9glKeVLtDyO0ukCffR/eff2NaMW0qvdvNWd1BTNixFGoWgCgh+hSTarc+7
         ot8g==
X-Forwarded-Encrypted: i=1; AJvYcCUPv4lcQhF+y9jCQZvltV+cBkocphz3nYew6Wb3CN+6hxpOqPKEHXc4sgR315zTSPIBLj46mQGenw==@kvack.org
X-Gm-Message-State: AOJu0YzgQEkfvhe4S2ImHuQeYGmY+IQlO4W7/iWlWh1VvrhhPc5divf8
	ua96BPnTZ4S5+T+3Z2RMlJqnNdivrjTcbxKXj1Sk4QP2Kaqklwm5JwrYoIoWicWsGO8=
X-Gm-Gg: ASbGncu+x65s0p1fQCd8/S9Q9D+pfknB16ELS07AkXKGgDrKNXQmG0cWZk8K6ppk38I
	37oyjlGLnRQ2d/pmekJtP/Ob/JpNEeHpdFeOcl6KnECrRcbBTt9IxywHCo3vsPn3XvC4SwPDn0/
	sqawelSuukFiH/GLR89+lDCPdhmX54XLKsBYShboznrZIiQGX1BlGhvXb3Mj69A4D4mXfzTDlQG
	XkAgDfiqHoimuqRAQkxyVxMa/38VHq/JVleA+ANKBTYueiMbUKx4mI1pI/SImunATYzR4EYkAPb
	/1wdJ70Yye9ki+I6DJL9p6zYrpBE15rWQogSy/+naagx21yIwdh7QnldJy0bJPrhR00z2WCADcS
	a4nh/Y1ANCQGQRuUi8GV4CQQXZ6/lZpWnvItPvS1nLG4jrbcD6I/je2NtZTneUzqz6UjmzAxxj0
	RJFwv6F+z6QakFHNuLWtcywoL58pS+F88JD6HfMYDbOpakkcrR1ZyQeH23/ZZ8Hc0Mj6YdSt471
	Ow0MYuIXjdY
X-Google-Smtp-Source: AGHT+IHJ1zH4LIr+8ggxAx5kKu9ExeGv2qGaiXw+0rzT1l+A7YZxhx40PkhUi9yrE8Oc+3HdrnQIwA==
X-Received: by 2002:a17:90b:38c5:b0:343:6611:f21 with SMTP id 98e67ed59e1d1-34733e2ccf1mr21792000a91.1.1764252704720;
        Thu, 27 Nov 2025 06:11:44 -0800 (PST)
Received: from J9GPGXL7NT.bytedance.net ([61.213.176.58])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3477b7341d2sm2030249a91.11.2025.11.27.06.11.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 27 Nov 2025 06:11:44 -0800 (PST)
From: Xu Lu <luxu.kernel@bytedance.com>
To: pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	kees@kernel.org,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	akpm@linux-foundation.org,
	david@redhat.com,
	apatel@ventanamicro.com,
	guoren@kernel.org
Cc: linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Xu Lu <luxu.kernel@bytedance.com>
Subject: [RFC PATCH v2 1/9] riscv: Introduce RISCV_LAZY_TLB_FLUSH config
Date: Thu, 27 Nov 2025 22:11:09 +0800
Message-ID: <20251127141117.87420-2-luxu.kernel@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251127141117.87420-1-luxu.kernel@bytedance.com>
References: <20251127141117.87420-1-luxu.kernel@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4A4A540017
X-Stat-Signature: kirgpwbdy4nfafg1j7bea1qu7b97mqxd
X-Rspam-User: 
X-HE-Tag: 1764252706-36114
X-HE-Meta: U2FsdGVkX19+T7/pwsxQmGQD0wDO+zIsKId+TN+WbfK887Fwc1j1gggJMRLZB03BRplNb9kCJ655KneIkrOEXC1Em+onHR+zs5LIP2oOcnMKfz0ZVXDnNalHw1o4DzCTzcAabqnfFehqxGJJtcBBT8HqBSyfeEXEbN22as82+0yYCCNd/GIbVQbL3/pggTjovRvrC4iWwezBwlJ6PCS2drjShfN8PoVeb5RwEwx0vr4oXv7YMdkjR8K4TeeMOa+WqUmDVcHbVpKDvVooLFumGnD60T/DO4KtWpKg8fziwqe8Cnz34N3OInw8HAzfXTB1DBJ9zB35h/l2hJdTKZYO1/X8E9Di1xgO42vrHY/ksjOP7XxOLk3r1inCa1q1pQY5TYaiJOayU8qLTPKvMMxcg3BXQJy6yiTYgVdVjPeFfbirJFmS1UWJIk9x17J4Z/KonHiyypSC7KoL0Ip76E4RFGcpjIT8Wa6KYuta5Qn3Dk3v7q5S5tSrXxah8uf2L2vaDbua2Uar8hPYNqwU0YUYXPbLEOoFLZlBsxDAyuxTJm0kkUE6cj0tcH6Hof5uwHJ9j2kLX9zXSpw9YAK3uvf5zBkRHUzfEtpxemrf8RVBVJD2K1YXa4CRv5FhmvuvcMLytcoeH1WGVs34nyx9uc+xEWmdRVcyXp2KWrf+shkEjU7APNtghp7VFE8s1x54BhTUMHiRyyil8MmfIke9iQegiF8t6hCtW5l5L3iwbz3AJTd312B2xLNShIe+hvzSBu9R/wug3XkgzbouDTbyS45uX4bCdewJRTEkpMWPzC9PKxMV9mZEnUiwU/+az6ssmr7pHV3lGu1qzxAhAMNokj0Dp4H2KQygH/nqGrEALv5GUZFVYWC4ELqXiotj0huL/+aj6B0bmLfq0eID9Q1rF9GQ4PpO5hkQOZD34HJvSAJNQcGLlmi020dk2HmxbG1/zKAu3JgQo/awGxsgrjiJFP/
 1svpHsAC
 eAFNP0AUu68KAFsDs8n+x6wlE+3ISJH13jon9oJA3Mf11IADGXvJWCHoYmeuqsQL7lLI0Zg7FB1c2HeL3hdRGH50C3DmnB0OHQxR6jeU7q6XTM8bC8oUA9uukfzaPum3QGCVAadCXSWMOjItIG43IBuVsuQeAnlPObZDZaFras8dNdofQO6+/ekUx3u9LUwtLxk95NMLBuoIxCkdufO62+djUcRjMxxi4eX9aA4gsHIxYaJjKj2ycamqPgOkMT7FTTZ3XnQTotWerync6iW1JT1ntXO7ppNcCNLOYiWEYBjC/ZE8L7G0A1xtAkgYsD/9NMYCO+eLdTZ7Z/TbWwYl2UW051hFRdpQbjmIcmVISCFOtBus=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This feature avoids unnecessary TLB Flush IPIs. After memory mapping
modifications on certain mm_struct, instead of sending IPIs, this feature
records the TLB Flush information on percpu buffer, defer the TLB Flush
to the moment when target CPUs really load this mm_struct.

Signed-off-by: Xu Lu <luxu.kernel@bytedance.com>
---
 arch/riscv/Kconfig | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 22cda9c452d2a..d219c7f4b129e 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -925,6 +925,18 @@ config RISCV_VECTOR_MISALIGNED
 	help
 	  Enable detecting support for vector misaligned loads and stores.
 
+config RISCV_LAZY_TLB_FLUSH
+	bool "Defer TLB Flush to context switch to avoid IPIs"
+	depends on MMU && SMP
+	def_bool n
+	help
+	  This feature avoids unnecessary TLB Flush IPIs. After memory mapping
+	  modifications on certain mm_struct, instead of sending IPIs, this feature
+	  records the TLB Flush information on percpu buffer, defer the TLB Flush
+	  to the moment when target CPUs really load this mm_struct.
+
+	  If unsure what to do here, say N.
+
 choice
 	prompt "Unaligned Accesses Support"
 	default RISCV_PROBE_UNALIGNED_ACCESS
-- 
2.20.1


