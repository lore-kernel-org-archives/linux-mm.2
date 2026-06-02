Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0A82CD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 13:12:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2751C6B03B8; Tue,  2 Jun 2026 09:12:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2260E6B03BC; Tue,  2 Jun 2026 09:12:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13B4F6B03BE; Tue,  2 Jun 2026 09:12:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 018996B03B8
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 09:12:23 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BE60B120952
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 13:12:22 +0000 (UTC)
X-FDA: 84835011324.29.371ADC2
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf26.hostedemail.com (Postfix) with ESMTP id F0E7714000A
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 13:12:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HNuizOj6;
	spf=pass (imf26.hostedemail.com: domain of linuxoid@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=linuxoid@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780405941;
	b=IyVrmj6VpEwvL5oF+Xq2lFVvo5n/ZTBY1yxYpZxovWlVz+TM/iMtV54SGyq6ZPmW6kaM3H
	KOS1kuHUYtvcbCWCfUGsKeJevO9aWgT6GZfwuYjFXoaSiJyjt0QjLM+fN94CEpXDBdt+iI
	0WvjMyDHVAKgboISiN/DkaLb4rEordI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HNuizOj6;
	spf=pass (imf26.hostedemail.com: domain of linuxoid@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=linuxoid@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780405941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+MaPoAdcJpUD5zXv0uj/EISz2QKWf/USntIRhT5xYGc=;
	b=WyTl6qX2Sfu1H1zFPTluip7EnrGQdLPK69X5BZgWjBS1oaJ4BjJzCvP6E7vPu/BhjF5Vhx
	UiAZiHZ2Tm8C+lbxzSYLFbRR79xNL6QeVUUvYy6M+rp4fmZXgenqftZ3O+1trFAjhVJEZT
	KxXzt5CElA/4h6LkCWUjpDbBaug0HLI=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-45ef6565cfdso1891603f8f.0
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 06:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780405939; x=1781010739; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+MaPoAdcJpUD5zXv0uj/EISz2QKWf/USntIRhT5xYGc=;
        b=HNuizOj6HTAF3u5gFF66mgBBcAwzX+GvGaek95s1LcDREK6HtdOWi+cfP8e3onHZhK
         p0j8XuRxkMpfKeYSZvgT4QY/8O6vbkfWCZVgUmv5ZCFPuIB2gAfF+L9TXVuQR9/tmQvV
         XJLM9xKm0PGTNSLCWE2QP/poFd3ldhoycrN7cIx7Mwf2507hGLTirnuGeU7Ttemz1HRd
         2wDL8zorydopb3mVM+9u1t/TCA3h9WxlaGeUMA6sFTMUm5gyGBrAjdqP4jCie4vDMWj4
         ZhDD9uV34dh2MHPZQ2AC1HRH/JdsN6arogzW47VCz7WDRZBmep4M8oTw9ATB4FZEREO0
         04iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780405939; x=1781010739;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+MaPoAdcJpUD5zXv0uj/EISz2QKWf/USntIRhT5xYGc=;
        b=LzMC0pDqpExkEw+K/Q6uQvRoMElJqvpAxi7OfAdgTGAPABFity5J6gJWBUjZJlJ4nT
         zin37XOe7HfO43tVq/YFYyKtGTAQBwUfgvac80QzV+OQeWHdDnbcFgWMH1bAjGgpTEal
         FVpvP7QzsF8JvIyE3+thx8naGEHnMkOWOxeRek2z7Is2dEaJVMHtW5qtAWca3U1qZO+t
         FcXOgnMQB/HdUSs1oi4uTg6DNYfuJrCpK3l64439UAIaAg7HOgqeAmDOA1CYDb9ACZJC
         NwA8mPgGnV55AIEaRy+erLnbYpLEfyPA2U7zKtqhlXwBGeZu1Y0TP8yVQBGqtluqaoq+
         PZaw==
X-Forwarded-Encrypted: i=1; AFNElJ8ruVRqny72IgdBjyV+KgQDOvrh67Mhi7S1KnhVzr4Jw3/InFwhx3NHjntfhgT+GZCmjqGMrHIC4Q==@kvack.org
X-Gm-Message-State: AOJu0YwO+pXDjD0hoDYNGAq/xs8n8LGZ4oiPqER5OjLMv6czoj1u6KCb
	HZw6TCVYJ2S5ddjUYrkJB6NUCZtvswrLiB/NegEyA5XD9uxZ/KzQ4+0i
X-Gm-Gg: Acq92OFfgF2knu1+H3yQ49Ci7oSlcGJD5nUFCAbP3G/aFpdL/CEGsJmNVZW9D4DYWgY
	m85ZSMgXuPBdzFuBarhMaaBfsdHeAO2FLCZ0laWSHfut2qbfxj3uxraZzO63yBc5v2MseRE0CKm
	wotEzUtcuKjLyCR20/ML/4sf73zoRmFL9aKK98tM89Kst7YEgR0NJYhiCjsH+BZxP9mg8Qbv/hL
	NdFS6uhL3wEvP+G29FiCT1/k9F3l+KiKKQoBJv44LKUk85UK5EMQSDRBMy1Tse696Zz+0vP5M4J
	tUSp8JVrENk7nLfkfY8Trayfhu1djcYCIx0rTMZDPsM6/Y6Oc8tCsTckVqNiOoLkU5kosXocVRm
	4v2KdvFhv3+ZBJOs/PvcQq/RzmFAX7a2kju7rP+HaS598rH9WOnAnpvIaKLdQbKBC7F8wZxIxpa
	0/COleTZRqVblum8BWd4Hn+O7kY+9Q1ygs/KSOi3r3Bw==
X-Received: by 2002:adf:e008:0:20b0:460:18cb:8f9e with SMTP id ffacd0b85a97d-46018cb95f7mr5518471f8f.12.1780405938958;
        Tue, 02 Jun 2026 06:12:18 -0700 (PDT)
Received: from x1.tail0e71db.ts.net ([46.140.7.198])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45ef34c3081sm33234665f8f.15.2026.06.02.06.12.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 06:12:18 -0700 (PDT)
From: Ruslan Valiyev <linuxoid@gmail.com>
To: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linuxoid@gmail.com
Subject: [PATCH 0/2] selftests/damon: test kdamond refresh_ms
Date: Tue,  2 Jun 2026 15:12:15 +0200
Message-ID: <20260602131217.2210912-1-linuxoid@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F0E7714000A
X-Stat-Signature: ez4bwqckdjtzstx1toa4xbgn5pj81mwt
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780405940-378114
X-HE-Meta: U2FsdGVkX19oxQOmjsIkPo/k6AbH95SY4qluQeTPVGAUnuMCFqVYJMCsft82pCAxSl5afcrb2imfa3O2Imhmzy6503ddFOF1ZFpmiyz5rBmNyLutq6bSV0SzKu+wexKof3q+WxbEJPxZf7zUT9aTAWqJMeth0Bh0lv6C3lA4JB5KzIpJdiJk7vhJxe5ZekfftUyCvmtvr7qd8RIYm8cx7EaQaieEfOSRjgr3ZK27Z4wYCyTT2VzyQSD9mXyVBcu2mWFOoMY6dqLdL4GBS2mn3J+LgoE3rFkOaRd1+hx1RonWgA3iRmSFGq6J2DyOcsjQklKraTbH7YqkV+4QmxHgpDrQVjhDiEacdZc8Jb7U15hIxjcEh6mjPmHMw0cjIpP92cqdy5OyDBi19KdKZbwbDPFfGJHjZ5eFYfX3z2B9afOprXk0vibgxGSoNGLrudy3BJt8tOHcsYKstletDxeC//g4h6ROZ9WZ06V21DamzkhaImkJCAIWDORjkgSmE2rKaQ4lA6+51C+drPNcbTFT0qwlTXbU8UwTYQzf1G+eLiU7EIs7WWE6XIVJZRndH4TUzIB+YLZcKI2+2rnk6TN5Levgdr73rUipHfMLOB5m0WFe7Na6MwZPmfMhAw4RAIKnILnhWn/Uea3xQ2E+vwhQ7JlRgQ2tekbq3FuSC6GP74rGkyCTHZYIZaHnfrITOYWaHhljzrbt7rahnEYia716hsO+HN02LfbMIahs9XnTBPWiZtfnI7SQcRqGRA6GcSf1Cm5j8VvC4wR9P6FJb74bpJv5pDEWE20lKDIEae1nQNIw4SDE0OieteaRy/P8zhqPlqXGtaqr8N0OPwZhqgaTmNt6M7vBT5nFrtKxcdwh9BmqN6mCWZ3tukufxauY0jrwTcXSwjS8qkH/cUClgj1DCQ9x6mF/cs2sIQL/w4DKUwEW03EXDYuo5bvsJKovx+CLK8egbBMMRD5S1InOj8n
 nWgh4pmW
 obbBEp8U/N1JVKdRG3k2K2LOU1//BHKnV1zay9+Qj8RcFWtRAgHmi9ZSK2xZQv1iNcd43o74qqQ5sEUyUolajqWhPUWAMnY8tFgu+XJS167X2ra7AYmT8qIYtmi3KCwDOratIBKd5cAMPcI9I80J+uf6j4x3tQLJHKa5sHKnacHzwxuQtNjdWgyozHh0MLx5ofzIldYaWdZ+Q/DDwqW2hxvXhs4VVAyLt+G/BNI9Z7Hjq13jB+0nonNyr3TJuv3tx0SqD8URUADen8/UHko64l3lit37JTYXdpBU5uJdW52r4f0LKA9LBUiJVKLESdmqwhUVfbaBX8SCHJBfpa0MBEIGE1BQHeNFD7i+r56hFCwaD3rlNyNKIDOkyXPb53y0rYxZ11ItzbYKGWU7mysiUb8hhR7AyOcNoSPZKBFw1yZGGBWEiNnAVcRaBjg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The kdamond 'refresh_ms' sysfs file makes DAMON periodically update its
read-only sysfs files (DAMOS stats, tuned monitoring intervals and the
kdamond pid) on its own, so users don't have to write update keywords
such as 'update_schemes_stats' to the 'state' file.  It has no selftest
coverage.

The first patch adds refresh_ms support to the _damon_sysfs.py test
control module.  The second adds a test that sets refresh_ms and confirms
a scheme's stats are updated under sysfs without an explicit update
request; the test skips on kernels that predate the refresh_ms file.

Tested on current mainline under a DAMON-enabled kernel: the new test
passes and the existing DAMON selftests show no new failures.

Ruslan Valiyev (2):
  selftests/damon/_damon_sysfs: support kdamond refresh_ms
  selftests/damon/sysfs_refresh: test kdamond refresh_ms

 tools/testing/selftests/damon/Makefile        |  1 +
 tools/testing/selftests/damon/_damon_sysfs.py |  9 ++-
 .../testing/selftests/damon/sysfs_refresh.py  | 75 +++++++++++++++++++
 3 files changed, 84 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/damon/sysfs_refresh.py


base-commit: 174914ea551314c52a61713b9c4bde9e42d48073
-- 
2.43.0


