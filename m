Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0436CA5FFC
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 06:17:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3112C6B0096; Tue,  6 Oct 2026 02:17:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C1F76B0098; Tue,  6 Oct 2026 02:17:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D7E96B0099; Tue,  6 Oct 2026 02:17:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DF9EC6B0096
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 02:17:13 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5D13A16055F
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 06:17:13 +0000 (UTC)
X-FDA: 85291193946.05.A48ED37
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8A6B4A0003
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 06:17:11 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZOcOIef7;
	spf=pass (imf25.hostedemail.com: domain of adrianhuang0701@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=adrianhuang0701@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791267431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OoJmGRoqngODEsvXRKt/ZMhZp/J8z+h3M6E+QYGZLJw=;
	b=JukZH27s+hWXjQaYnDIlA3vm+T0pRZlEFUVheNJnV3VpkeixTDyylkhMME6OskxKuUDuf2
	5OwVjSUPlYBmk4UO5Z3PDzHHKJ34FA3JelWXmiKADxFtDqJWz0MQYmv/yOmYJoQuRW6HRO
	mA8FBmJ468VFBQxz8QSq2+P1deO+2og=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZOcOIef7;
	spf=pass (imf25.hostedemail.com: domain of adrianhuang0701@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=adrianhuang0701@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791267431;
	b=hhMziArpvjJh6n9tWMTnpIb9ujp4WeOamtFr9/jMasF19vGYOJ+s25my0GleXoEJDrvZ6u
	vo686GgB3opkiRkCVyhpYHH1cyLB0h0rSUbF6cfH7B0C4jidLMj1Ud+p2fW29EPYi86GdP
	RPXOcEXD8wbaC6FB34E2muBSRdlui80=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3a80e169311so357514a91.1
        for <linux-mm@kvack.org>; Mon, 05 Oct 2026 23:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791267430; x=1791872230; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OoJmGRoqngODEsvXRKt/ZMhZp/J8z+h3M6E+QYGZLJw=;
        b=ZOcOIef7DmaXKMguZ6ghYRnYr4gejUxqD+NPJOJlSG0i/jObPMa02y5H3t/LVoqMQ3
         yosu5IYYXj4op7KUN2ysWomH3Eg/KC8iUhs91DkwIaT6Yweten5Gl0nVW6qv5FEFKlTP
         lwbxsXD9u4eC7iNngUenQOINOQ/Q7QTUIeO247px7SpxVpfGrJQcETkKa3fp1VQnote+
         fjdWhcWarWji/Fo48TvtnUqxxWHaDDxG7k70Cd+iDPGAczWdVNPfAo/1ukNHYJxyjN5z
         7X07cTtVdOuwKi8y0AXm4JRyu+Tzsb32ZPGAuPZRBWNMkKnGQquCEfUJL96XHoh/JFlr
         8Bag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791267430; x=1791872230;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OoJmGRoqngODEsvXRKt/ZMhZp/J8z+h3M6E+QYGZLJw=;
        b=ams8akNr+ZfqX0goIgcBh9ErZi8JML+3O9EUbS5dIytZipib+/iuxJdque60fxz2JD
         Aj5IdKzOeSWi9635xOtG7RuMg+QxGD92pSeMXgJR6Dd4UmplP9rTNxVEwXfWfTCtLXlf
         pgijfRUE9d+PkOs04aCOum6DJethZd3+81/kLGodp/EjsIYdZjHfCdCkMgdEmrEj73XA
         u7GdbHqh9qEoG2aDznDzpZCGNlhDsdolifm2EKv5U4w+QG5UtbfZTACo0ukpqSOMDriK
         y7LCuwPpm25El+Nwyqtg8mSzKrFtFBzbb+xljO7KSK28Cu4YrJll/jQcQf55uGJmmV2g
         DsFw==
X-Forwarded-Encrypted: i=1; AKwUvBxhKi1LYM+ZvtBE4u90IdLVyThVJlQGUbtjtoHaI3PZiT4YM35KN8vh+ETwjBz4I7e8pXBIn8B54w==@kvack.org
X-Gm-Message-State: AFq9FYILYN55j17l5CCi2yeq5oem5OKK9jxIb9YeZixZ39KTHJ8PEG+2
	CB1fXkmO5Fc1URODCokqRMa/DpRdDIDm/LU9fbBCqzW/P9DJU7A9h7Qc
X-Gm-Gg: AYBFou3Zu3EOqMhD73qi23K9i49RHdcHcQ7f3klRfHjZ1rNHeIZxocW4n1fprhobIUB
	4Ce5G4kCm3CO4zqXuDOslSRSPGVQhSdkhzanyWLjf5KrbnoWKvFgwJtqQBavEl2YKFXDM1G31X+
	tinz5sbNOH/unasKwMTeV+JG1kcjZyse5Gs5w9WSrfBAAlhETWUyVNU83bRwKdB51O3Y035b2Gf
	Q3lv+6E8Bqu4VcIEqKMMWkJW7Du6cLNlSMqCzWBHMutatfF/ezBEi+vd/dVSDbDWhMQvDEqSZB3
	odg3V79oQSZw199s8Qm4dw7aPJuY3OLQDXuOh+2Or8U3LLGLF346OeaLstV2AuHpcJ+m62oPEYr
	ga4TkL4pahJFkqXRjQK9fsmraAOaFJz/vREr6Qu9IBUfq8MaLrLXwSpHHAz0SNtc8vhC9gOMe4u
	DDc5R7186TfB3fHyKeHEO9Z8HTrVluwNVxTPm3enFD74VwsPNYQSbLwzcy4hgsqdFtt5eK9AQTV
	/5a4v9MAsngjONu0gfsijrtSyq9F+G0udkpw9qJqehEjtsv4Z5JGJ5l/DNbTOPsZNWQ+uMIvhRD
	SyLWf8+k3tnZ4rImpqf+LnwtdWE=
X-Received: by 2002:a17:90b:2f88:b0:3a8:6b84:235b with SMTP id 98e67ed59e1d1-3a8726c1d9fmr135343a91.7.1791267430371;
        Mon, 05 Oct 2026 23:17:10 -0700 (PDT)
Received: from AHUANG12-3ZHH9X.lenovo.com (61-221-208-111.hinet-ip.hinet.net. [61.221.208.111])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a8533aba95sm3662789a91.2.2026.10.05.23.17.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 23:17:09 -0700 (PDT)
From: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
To: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	ahuang12@lenovo.com,
	"Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
Subject: [PATCH 2/3] Docs/admin-guide/mm/damon/lru_sort: Fix copy-paste mistakes
Date: Tue,  6 Oct 2026 14:15:48 +0800
Message-Id: <20261006061549.627-3-adrianhuang0701@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261006061549.627-1-adrianhuang0701@gmail.com>
References: <20261006061549.627-1-adrianhuang0701@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8A6B4A0003
X-Rspam-User: 
X-Stat-Signature: gqxneho8gizwox1y94co9i5sjcnqw6ym
X-HE-Tag: 1791267431-396030
X-HE-Meta: U2FsdGVkX19C472xcFEldF7L6/hNlWeTxnwvzLZQME9h9E2HCCFtwvi55fJyuxYrEBxdlbafJXx3+VWycmhOTMUd/aL2ZcmvGYJy+xRGqm/9hEZnNltywOl9kLdEPacVpgg1J85hs8es1nqKSgPpYw2niSt9KiTVTIasv92qx+py6bN4IKcnComx3+Q5ny8w3BfF7FWj2ULGPEhsAi9Wz2GAgpxtKom9Tqc1XbmTx74lMKOCgNreqXulV7cKmxTf4y12Tp9uVKsz0uJ2FJ0fmbSu1Ecp+UQokoT3gyVOugU+NAgwC0aA+YmsQElcuu37movb5YGPdCuYCnjekr16K14eVWNLmLHb34/ehCw2XaAXct4qu4oN5TOMjCtIoZo+QtjP4YUZIjg9OsLaTaufRhi9yeNGYsDxQiDxo/OunoZHxZ5F8IVmyyu8d0b3Y7t1YgzyUC3SkdXeJTxk1qbHTXCyt1HoiMgLOe+ieOp14hLas4sIpYldqfPM5tCW6rk2XMOepNoeaNb0z/eOkUcv0ySSSSTzKTP7GZaYQpwpNXHoSYfySc0BwiUVPyUU+TMWbKoENUqpumK95X/2OrL5AP+ITrwhsPWEN7ha4LlGj3AwuEFMWdYq2JZ74dRI6/3pELo/ZGs7W6wYlll/ImorYuHXwNW0au8MBXX8e3iWpNzdOYhbqBhhBCE8uavpCaZDCPdkawQkKANtmcGwMwW7zhJZPqdBSE7KL5O0SMrlv3PXt+IyFpnDsEsX8nFUsxxftjwLiyW6qkVjsweb9jphLKC+EVaCym7GiJUQ2oFzWSaIXZYhaKfMQ63mIZoSDy0uOpx1/HlLGrHZsWOTrCvx0TNSPS5gQYYE/ByTMbX1ya2eoXYvPHhGTWsBG2tT0cAY9AfZjc5k+M3OxMFrkfNhOaVRLZydMfD1WWYiIb5bx7ciyi/8/CcjDETPbrji363a30L+Ye+YalesuDzHOkc
 v1IvrGvU
 Gy03j4ccLBkaOODBXBRWBeT8/hIHrur9dR3ni9ooYc7iwQMCUjP8lUZJVeu4dFGqgaO5xsvtXQfFdKtw2fLdd1bumD/37loSgF1c+qNoJ64Y0Ft40Ltv7FYVzYtNXwNiDYaE7KxPxLNq3hHHEJUgOYzZpCFFJtum5vTJggb6jzn/U5cozz+KXDab/rh+tC+xl32OsIj6CCwysIoHBd8r+geR1nQA4Cj2B9NWE2pNt4xr/99eiKXG2v6NObUCu0NE9AN69Uc2zyK3nWc0D3SjEIRuosZ4BJosAF5e9elWYWG3ejneZkUhoPh5P1xtfyj0ybqFpDgZ+KvlrEaSDSRSwWdba844Utsh3hEHBuWQyfoyhbqo3mUgeqOH97/vfOY51x5FQ+CshDHixA2h1PCIOIX+cE0PSagcqBm+y2rdqv2A2MRCESbW1ALkfuYFg8uMgmnoVsWZ/SombKwDf1qXL/ztUWt6J1HDmjW9oMW/disvn7sF1AGF2XtFncA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The DAMON_LRU_SORT documentation mistakenly refers to DAMON_RECLAIM
in a few places.

Fix these copy-paste mistakes to correctly refer to DAMON_LRU_SORT.

Signed-off-by: Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>
---
 Documentation/admin-guide/mm/damon/lru_sort.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/lru_sort.rst b/Documentation/admin-guide/mm/damon/lru_sort.rst
index c3b688385681..0c04d238edc4 100644
--- a/Documentation/admin-guide/mm/damon/lru_sort.rst
+++ b/Documentation/admin-guide/mm/damon/lru_sort.rst
@@ -264,7 +264,7 @@ addr_unit
 A scale factor for memory addresses and bytes.
 
 This parameter is for setting and getting the :ref:`address unit
-<damon_design_addr_unit>` parameter of the DAMON instance for DAMON_RECLAIM.
+<damon_design_addr_unit>` parameter of the DAMON instance for DAMON_LRU_SORT.
 
 ``monitor_region_start`` and ``monitor_region_end`` should be provided in this
 unit.  For example, let's suppose ``addr_unit``, ``monitor_region_start`` and
@@ -347,7 +347,7 @@ memory regions that not accessed for 120 seconds.  The prioritization and
 deprioritization is limited to be done using only up to 1% CPU time to avoid
 DAMON_LRU_SORT consuming too much CPU time for the (de)prioritization.  It also
 asks DAMON_LRU_SORT to do nothing if the system's free memory rate is more than
-50%, but start the real works if it becomes lower than 40%.  If DAMON_RECLAIM
+50%, but start the real works if it becomes lower than 40%.  If DAMON_LRU_SORT
 doesn't make progress and therefore the free memory rate becomes lower than
 20%, it asks DAMON_LRU_SORT to do nothing again, so that we can fall back to
 the LRU-list based page granularity reclamation. ::
-- 
2.43.0


