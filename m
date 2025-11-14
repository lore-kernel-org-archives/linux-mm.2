Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F1EECE8D4B
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 15:54:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B4298E003A; Fri, 14 Nov 2025 10:54:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 464F18E0029; Fri, 14 Nov 2025 10:54:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 306458E003A; Fri, 14 Nov 2025 10:54:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 101F98E0029
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:54:18 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BE1561A040B
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:54:17 +0000 (UTC)
X-FDA: 84109659354.22.7BA4898
Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	by imf24.hostedemail.com (Postfix) with ESMTP id EA14618001D
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:54:15 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=CyikO7p5;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763135656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iTGqBwhVIw9stl5AxN+42Iq44gONjHHbYM4Z4BBnC/g=;
	b=LsgaZxbsTZ9U7xvmLk4zR6UFa72g1e6f1fe08WXNa8Pl4GT1HPrL/H48vr33/BF1YR9Z6O
	d0N7urg06IpnOOJglwEcQ/ljfYI+2SZUzyrY15SZqhpTkVlkP5NTRnOoF+UXl4UGchimH1
	24qx6V/2CugY2BW3ahZ6EJbm2W2gIrQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=CyikO7p5;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763135656; a=rsa-sha256;
	cv=none;
	b=2TpG5CWoxuCyEVS8YNkPdeQrUNOnhnkBTpGtE+KnljBdS2u+Q1Jpw6kSC4KMa2lEew6mTc
	/UEDaGsKwntym3Qbdg0B3t5dg0R6Ew4JoNNMlYNVhLYk0KIEVKEm8bS4p86E4lcguCSF1i
	W5GmES0WJLlEi/2NaGyaVQJSSrqmW3E=
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-63f97c4eccaso2111053d50.2
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 07:54:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763135655; x=1763740455; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iTGqBwhVIw9stl5AxN+42Iq44gONjHHbYM4Z4BBnC/g=;
        b=CyikO7p5GN6DKM/Ls5lUXPLFGbR1mDMaGY6M512attFvHlCXCrexnV4jVysnsfXy/W
         t6ZqOUbI+DXkbUCK1W1W+L4gJDm4WsVB1CK+BcerHdT3x6z5WP9LKy27UpEjZqXfEAdn
         qg1aMlRXM1gKDakIY5dXg9u/+JqBKU5KFtjfWsnjXcAU3u/BPEYKg1dVKucVYTogYSZg
         SXEXpQY0UvUiWJbmo9Z7wJ4uY2b/MVgnAKDSrs6KiSxPsRfEizIjWu39g+vPpuRO9/VU
         2PkvdNw9qOApckHUbPkuFtwL/Wdm5JclLRmb+m7I1vtUS7xw7a6xR7GrZ6GNNU5ZX8Vo
         cvng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763135655; x=1763740455;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iTGqBwhVIw9stl5AxN+42Iq44gONjHHbYM4Z4BBnC/g=;
        b=SISVMIQU3xdMMNuNtI5f/cjB0kQFWo688BsydODmQs8W1ic/VYd+YxuLEiNsZy7G5o
         4uPiIffkwDIy8DUOhnJDVea8XU2dqcy/rWvABqnb8ejQIPl+3zoulZPuXS5GUivOxOJh
         hhVl0rYApz8JmVJaHfxi32cKiHS+TJzlYpCvGkTkNfR8Pmv2UmxjttvTcRFOvit1wo9w
         TZXgCSGAEDnKbkBH9pWJLVOINLeIluk7o0/XDzBKQ/5BfIohOmpq9UVasc3heaXv6LOR
         HoJrg/u4Y2w1y5KIdypgZ0dP6ghk104pnec9PU/g9eDW/eT9BdQ9G7Zdmy5RnP5fU6l2
         g3wQ==
X-Forwarded-Encrypted: i=1; AJvYcCX5iUdwEYUIbbIkzdvDyhpmN/i5fn8NGxXU4IxbwGvCdRUIB6d+V5iSX2sy0uygmN7Kqzncs1yLoQ==@kvack.org
X-Gm-Message-State: AOJu0YwYJku3HcYG2No+ZJ/A5m8eVigIn2fHz7aNAZpyIhBqvWYHfH22
	agaTlGvrf/dprJG4SIjWm7InG3utI7b8EPPD9oFkHkqQjMiNMT28V0uHhxZZlzbalA8=
X-Gm-Gg: ASbGncuSIVJjzAlvuyv8UcfYjlD/xdLaIkP6fE+SMHjm9RuxXD4NYJ+VCZnx1YntnF+
	L4JYsL6V0RJKQkD7ltKesM46cJUT9a8RhWlF9BRODnXmupzHf9B3hoOAxACCm+/mC1dqSX+NsNO
	KrXdV4y4S9K14oRCbbOnDbYuwsuAeVxpDTHeqHhZn1Ukr08r/iS707oXcu2+d0KCSEoQZNhTj3e
	OVfsdnVtBE6qY+J25xNGrSYLz4KOiU1Sm07bDf5LyIqauaoy7BAp16yse+eCITB6rrDuzJbva8R
	2lh49RxyHElzFh8Xjwpcd+BHpjA5KZnMCFGlLCINZ6mSMexWwZn8iJAHa91qHgb5zfiFtUWXd7g
	DQJw2esNyaFbi8gBj7fl2c3nxRQRNdFRAGoOoTypHJ8bmYUI6pBOggVL3Q2NMVhjAZgVSDcFPka
	hAslh1qNHyvLFeFZzJoxxevDMZ73bXBCFfB8TnsSayya2OthS7gb+Mn5VIiBHxPGs9um6NM8Z+P
	Zz2+3k=
X-Google-Smtp-Source: AGHT+IG4mQw8nEL1m3idlNaAXf7Kc5783jAJw1K5t9cvJ10mUhr5v9D0Cg51BzHrwu9IlD9mh5aUEA==
X-Received: by 2002:a53:d058:0:20b0:640:db91:33d6 with SMTP id 956f58d0204a3-641e74dc5d1mr2579255d50.8.1763135655068;
        Fri, 14 Nov 2025 07:54:15 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78822125317sm16468577b3.37.2025.11.14.07.54.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 07:54:14 -0800 (PST)
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
Subject: [PATCH v1 12/13] kho: Add Kconfig option to enable KHO by default
Date: Fri, 14 Nov 2025 10:53:57 -0500
Message-ID: <20251114155358.2884014-13-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
References: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EA14618001D
X-Stat-Signature: b1yj9oa7w4im88qoeredp4trh7z6m6sw
X-Rspam-User: 
X-HE-Tag: 1763135655-480930
X-HE-Meta: U2FsdGVkX19wKN6rnKU7m3efmx78+/sj4te1ll+rYYuIJsZkgwcMkcjXJmAagYnt7k5vC+1d4KQcab7kljffm0m1ZT/y8+GVcvmBInd7gMybHEkJhLFYE1WWpknPZeW0qhjIsW2evA2ELfc3sPU/3tKxC19SswoywyqI4gr5KJJD0m1ABVABtPevLmWS9eXo/z0B+zlD5RH/TnmlDCzcyKfn1Kb97Z4QlbP82I5WapD+ndxom+k3f+oIkfvXxGzFMoo7MIC38vhoni0uGRIVaDQpDIpPgXF3Dt+l0yb1RDqo7lGYiZPl2NSKgv0kFqkWvF1Sr869rfGy8X7YID94lGV8O3lirBRGdNRicsvD4TjYbp+OwUT+QTQfqBFl7TK5ip775TPH8Cn57l1x8x8ropAoPu427UgtlOvkVZ0PgA3O4taLGSs+0sIU7TgRfTB4tPL+RQ4zFqOnJ5zGXV9FbDNQjCa4xlDJ6YsOWqqeumNeW9tTeCjMfgtVyWY6nwf56iyurc9e5K0PVtSokaDlbVko2l2WtDlMwGP+jL6DYQQabyF6X1iLGghjCEJ9puWo7G1siYBJtyJb0K6c8a6rwAzxwZZNvpgEm3EOnIyuBZJjfg5WnzFFO6H/jw2/xd9JsMkadWP8A0sEAZIvFhBaEjrHd+fhXt0NYKLFTSsXICudsze8TvX5/o0xgq2gbLdSohzdJv9nIm+COaSj31BR/VYINHXAzJU0r/ZVd563IOkFJr8CcECbVTGHVypmhLBuVdef4lSazmco/b1NjrimE/KRyAMHLteaL8fJaqptikLKgcTWEAB+1s1fiwIDaAZtTCe4DIy3c7s8YRhFqzGIg7mWEk8Fea8iEpOAUCV36+LgTBhFelo+kQBybaVqK1QOrlNYAToyOg4Jt1FAh7T9/aCwCeoYman4iEIbog8MbPc3sRfn70XDEDiU/w97zYSa08lriGIZXKU734VhLI5
 //+qxvM5
 YXs3wmGTshVYgDzVAUHfiMeEWIpNW34vVuPw904kBHHHFjGavj+EIC1BpQaFAQ2E9N0httMM1wQQ5okb0DvAVCKZ+piYDj97JlPR2wMfvw3eQ5gRo5ouSyzFOX0zKXWj8HivQpoyXwfE/FFWhc1oBdAroXZfNGMQUCQZg41Zy8bUgVMzyOiBuKuy9o7xsR/5kGmnCA7mfcA9keUtSy8BtRpq0N6OXAO3Lszp0AzpyMZWwNf4SbkFTEHSLcd3EHQ/TCJ3dlykZkVMDS2VvAjxfvMHYsp62scdBK/8VH+nacSoI1td+YOzjKh95SUq5UuO3m+wEjbtgHAAGxjo=
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
index 87e9b488237d..a905bccf5f65 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -50,7 +50,7 @@ union kho_page_info {
 
 static_assert(sizeof(union kho_page_info) == sizeof(((struct page *)0)->private));
 
-static bool kho_enable __ro_after_init;
+static bool kho_enable __ro_after_init = IS_ENABLED(CONFIG_KEXEC_HANDOVER_ENABLE_DEFAULT);
 
 bool kho_is_enabled(void)
 {
-- 
2.52.0.rc1.455.g30608eb744-goog


