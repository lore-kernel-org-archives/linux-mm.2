Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA6EBFCB618
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 15:29:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F6516B008A; Fri,  6 Mar 2026 10:29:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05D076B0093; Fri,  6 Mar 2026 10:29:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC5956B0089; Fri,  6 Mar 2026 10:29:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D3F186B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:29:24 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 98C948BB52
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:29:24 +0000 (UTC)
X-FDA: 84516022248.04.B590102
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1277620005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:29:22 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NoYtOTvO;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772810963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZvN4Jfj3z//9NPzBmcPPm+BAzS1gyEqEJKzXFsTsaUY=;
	b=5hVTEafZ+sgN3HH5iQ7hTuy71TlLNm/Zo/dXST3m6VjRCKHfVvq9BDQBqhNRDGwHTfcVj5
	vrU69XShzShhL4fZXiq07hctd0FTaFpEGRsODzCWZs05Ra07oToWG82JOFTQjA/diEeEFo
	UPymMcFBLJ/n8wkeYO/O5SfYY65ccYA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NoYtOTvO;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772810963; a=rsa-sha256;
	cv=none;
	b=IRF7PtuINNcF9HYubANb081/QWPMtcDJhsEapGMTMf3p7LMVhtNAFT/VKKY8OH3ndub5fj
	Zvh5PPZj/2/uig5mlpbkI5+KKIDmJ2TJwfxYXFwg41AZGQTAI6JUhhatf14Mfes4blTRF/
	M0ZYaDh01YH1RfKl/7JyUg5MnBempzo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 86BB160132;
	Fri,  6 Mar 2026 15:29:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 213C7C2BC86;
	Fri,  6 Mar 2026 15:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772810962;
	bh=mPwVqtgK5FXF6rtx4eARff1DBvg92YGlSMSnRp8dVoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NoYtOTvOVdC5NHLliOnNupYdNTkqPbZgtHYp4eZWZRLRjj+sT0vgd3NGm3Z7OkdXo
	 rKPM/tXPBq+UsQAhdBk1ugO0+QbWCSO4Nf5IZAPyQOLpHEyfEeUTTandpLri/LpULR
	 RrVLfe2koKp0GWNHZSWNf0Rc6D17Gxt1c77HpJWH8zzSHfcO4DrdmfIxA0PBHQIV4W
	 dzklFvANhadVEAmtaG4XJVeNn/5ncrsGTq9neksEvWoa2BQnU0JcHkZW5TrMI0p/18
	 w4nkLr5pAv8YO/7r2gGs4iovBuKznQ4BlAZ5bAv4b/N4bob1eR5jXCfhklTT8NJYHz
	 RzaHfQC2kVR8g==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 01/10] mm/damon: add CONFIG_DAMON_DEBUG_SANITY
Date: Fri,  6 Mar 2026 07:29:04 -0800
Message-ID: <20260306152914.86303-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260306152914.86303-1-sj@kernel.org>
References: <20260306152914.86303-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1277620005
X-Stat-Signature: m7cqiwy4zkbr6kk7c1ppumn4cmucxmxb
X-Rspam-User: 
X-HE-Tag: 1772810962-248754
X-HE-Meta: U2FsdGVkX18HN2Xw/hINn9YmPnR+iRYmfWZTEtVaZ5g7D+9cMQ2QjBpv30GXSH9TRT+BHAjE6V2u/vAmNjeGAF2EJHGx//hepHuUqMm7PA5gHX2wcwT+Lw57r0cS6/R7KsvbzumSq7SREM+xJYWSnqUs4r1JGoIGHzPam5vFtCjcBXUnfvkaMAD10jkstGmKBHQXNFTffqcVG4hMkqMWW64uellbVVVk8zPBI9nNpWpWnUukAu4LtUzpExDTbkRajZNHaoIW2tuvaj+JevJRjqpp/je8tEz2J0VCAhK1ycABzq2TlM2+ZSOWOHjdy8+qAsH8KLgU0COU+jNDmQBrnQ56d/RQwi2o87q+WUxhAtdMstCrkutti92+2f1CGjcfWDQ6cPZdHK2xYSHLssXgZTystWExqLbvPFm8aKyPZn6qrbz0mjyGkN10/FGmT+gzEW1meYRTbOVqMz59k5C71GTtolWbB9Ks+eOGYPzUBThFvvM3ZgZHThrXpjETZENnCLtXFzBfvxi7RFPrUtu0TREAptX8y7nnVpGdwYlJDlpQX63MKdL2WaQgKX9EIw6jQEe1LQSg8ZKcJ/ecM8/jEJjrjXSVRaLY9qxssM2DkYsm/0RzU/CM47zBPV1+tPZ1xSb5+XKxUabeHNWs1O8jXHJkBpKeYPI15PS9FJTJI7c+E6HttJnPM+83O964TVX3/TPOfGuqfcDpBXmrM3YBN47rli9iDV1hz20yB76GrQDSzZWf8ALoKbDXH9Ma6p9833DhXUgLLRUOuT/SKHTM9pcgO0aavXO6cp793EsGrxvV5s/jhQ/xntVNmTZSIfyq9QpUgNvdkzikYpIaTykhpe5GZ5ShXc6gYBNbyOvC8BW3oGtfhA1CZmo+s9AlNBWs81dWBrEd0LjXHZ3oDNVp0MVAHNR+aweXbhE0+ksVzKs77QygJPa8iZpHuqnV9qgq4nB1J4kC4pCgZ07ZYxL
 PY/YfcjE
 apZnmkOip7gE1OHWxOXtDowN0UBLDQ4vpKAu76igbQbCVKn3He1TnvvmLmhd9B0PgD6ALACeTLy9y32QnsqNLvRQxNKbBkA4ELF17ILypz/ykXDUXkoj3XbQeRBrJXUat9Z09ntRFRthRxf69xSf8+PfkyJaMXOqwIQthq0Y+Le91lET7y3tox2Dp4Bams8HIlsBf5bipJ09Q1Uv6ANHL3WWI2rna2clSew0FECbCOgiF1OAb1dzaTsBd0CqeEfRufHpz5QPNBJrMJHplPGvdC2nStw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new build config that will enable additional DAMON sanity checks.
It is recommended to be enabled on only development and test setups,
since it can impose additional overhead.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/Kconfig | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/damon/Kconfig b/mm/damon/Kconfig
index 8c868f7035fce..34631a44cdecb 100644
--- a/mm/damon/Kconfig
+++ b/mm/damon/Kconfig
@@ -12,6 +12,17 @@ config DAMON
 	  See https://www.kernel.org/doc/html/latest/mm/damon/index.html for
 	  more information.
 
+config DAMON_DEBUG_SANITY
+	bool "Check sanity of DAMON code"
+	depends on DAMON
+	help
+	  This enables additional DAMON debugging-purpose sanity checks in
+	  DAMON code.  This can be useful for finding bugs, but impose
+	  additional overhead.  This is therefore recommended to be enabled on
+	  only development and test setups.
+
+	  If unsure, say N.
+
 config DAMON_KUNIT_TEST
 	bool "Test for damon" if !KUNIT_ALL_TESTS
 	depends on DAMON && KUNIT=y
-- 
2.47.3

