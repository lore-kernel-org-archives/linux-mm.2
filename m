Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5287FFF60FF
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 11:00:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84F5E6B0095; Tue, 31 Mar 2026 07:00:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B1746B0099; Tue, 31 Mar 2026 07:00:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62B416B0096; Tue, 31 Mar 2026 07:00:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 529C56B0095
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:00:40 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F204E1B9370
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:00:39 +0000 (UTC)
X-FDA: 84606064998.18.DE77BB0
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf20.hostedemail.com (Postfix) with ESMTP id 30D211C000C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:00:37 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=I6HMSAwt
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774954838; a=rsa-sha256;
	cv=none;
	b=4+h2qiX/nashobmjILwmswpp7St65xBsYHhXQjt12DAdvZEiXGqgeoq3i964GM0PQfG9tJ
	MJ4xoWWGjRKO/npaZ7hULuNZPByfd6Yp0qRPCzZQIVC5pMawQ7k1RmEBFiJmQDvR3z7GEp
	tmnmfe6nNqssnUI652AC8rv2SoRse2o=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=I6HMSAwt;
	dmarc=none;
	spf=none (imf20.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774954838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D3oi2WL9aVMRGCDxrM3eE/b0NGQJJRrFO3ofQ0V/e2I=;
	b=voHjOdE7sEiQjQkKG7lTm3A+uLAnCclZqLDrZoEmugh16P+udlj3U4N1ggADxNOpTfuNpb
	tRiCAAeyIzMz5odFJnr1cY+WgPRnnYslhW/+rU9NF3PIcSiMfkticocmRIDrPcfJuyiThj
	BO03v7BvBWYTiHSyq3kNTdyoJU1fGcU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=D3oi2WL9aVMRGCDxrM3eE/b0NGQJJRrFO3ofQ0V/e2I=; b=I6HMSAwtXrXIBW/RtXa5KMCct0
	RFhBLw/Ml8GEnRdD3jC5twXHbmCG9n7R9uen9ldHC8fOfReSvGMHw5JtfyJazu6CzXf3YZrUSC97t
	p7u0lWe1mycrtaaIPzyEEu792zso3aLoEzUZ4nBSKP48J1tmhaLAaCvapG1sRkcDEPzAeFLixZg2H
	tYd+POTt26PJwTgmrv3XMa9WAIbTXPJsru0AV+ypvGe8yGBkjJGhSiVAewkTu1xjsINvAqErakkej
	qvKwgQs1qcOWgsCGQgnl1CSaDY/wyw9eitLI65I73sqy5x4o0GR89OZPkYY/usqQANopiz4q6zDpt
	ZrH5GjIw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1w7Wpl-002Aan-26;
	Tue, 31 Mar 2026 11:00:32 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 31 Mar 2026 04:00:16 -0700
Subject: [PATCH v2 1/3] mm/memory-failure: report MF_MSG_KERNEL for
 reserved pages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260331-ecc_panic-v2-1-9e40d0f64f7a@debian.org>
References: <20260331-ecc_panic-v2-0-9e40d0f64f7a@debian.org>
In-Reply-To: <20260331-ecc_panic-v2-0-9e40d0f64f7a@debian.org>
To: Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, Breno Leitao <leitao@debian.org>, 
 kernel-team@meta.com
X-Mailer: b4 0.16-dev-453a6
X-Developer-Signature: v=1; a=openpgp-sha256; l=1010; i=leitao@debian.org;
 h=from:subject:message-id; bh=LQ8JPJu4hVwXA6ZBcwhWKH4JmrXxTSQbw/JmwDUjF4Y=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpy6lIlRQLIv0IYw8ryV6vm0jHNbCVtjXc3Xeou
 /NgiA8DHsSJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCacupSAAKCRA1o5Of/Hh3
 bYf6D/4o0UQMOnG1ClcQ3eCmn9QhVYwmpu9MYpIjydSGaoNVYxGa307x7T1pueq49fEWNJ/Zusc
 k980fbsdTXIiyklHxWai/4hiFUtmg01JLk2KriPOc2K0Q7JNfu0avc9hQYBBXD2jQTwFIaPNgUt
 7SUUSAu5uVIUbZstjQH5ocHkK5Gaa0OCLw6N6zxFHDrVecwDugein1NEM66fDdwSBXf/HsSYldJ
 ftIR0ktUz1CYQ54sGy88qX74FGO3EHVOukUtQhAHeTt5nobKW41ZSRBPpNkjRRF5yBEpyx/RspP
 ZQ1g/5FVwH7h86wDMky/6fjO7lRwkOQnqt4LnuU7hrF7m9eMkPJQqCRJHSodFMU0AEVnChPNNpA
 sKo8IhZazArTBvbBhU1weDQccic99JUABt2gdmlaAWQU4NLRl1jm8jvAcilIlpCETZkPmowXHfc
 hSrI3tadNC4ub6cXy/Zxrgf0GEeyJjf55eXGhPm+0bhohkNau5Wrde/X9UllEZUncsQNG80egzT
 kfUXdZ1+eIln4sPROep8qcrAiYzzb+2URoK9gXl7/e4XOCnlbO7erdsUcnWZ0BA+BMbJAeBbf7t
 viXIr8vpg6o0AMMCAHcGm+7IDPuxN9KLNV16eNGys8Xuz26T9/GbAnudITUEXAI5ehn4Ux9br/R
 yioz27gGZ/S+V2Q==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Queue-Id: 30D211C000C
X-Stat-Signature: d8fa6j9o4iaggfiswodko9zdy6mw71nz
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774954837-784213
X-HE-Meta: U2FsdGVkX180hT92TyKJDf9eU4u252Hk7XcG2GFvVILz8BwHfWo5znJCIyyaKQREI9iFYKyvAONOSmu9wai0YJZhCruxyclEV11XYdKY5Cp35lKuYEoCTGiuZblSesJHIBvIDkWvv0XAZf0F9+hSstmNRXAKfhGVzDt+jEa8YLrVzNeE0G9IUZ54PT4dcehVfO25kHTvUipHk6sAEksmyopXa7JIq0VMqfTQ6v5FJhF5AyV64/OuQGcYXH/aYv0K0q9lTRyr6ENKg5jhcs+LrGn4roicOSfK36TjT0y/bWBouHuAuOS/6BBoQ8rPCDHybYxlxjK/tXaZzLfePkdIeTAJVcPo4MWIje9SY8WbB+UDW1nXFyoGwmQoeGMfc7HECw+GZUbLM4VbJx9GEBQ+2VLeA5Soi9rTUfx8AW5GDgPb48NU9TO9+gZvIA+HztkIvoykNSX7EhXh263WprC6SjB/JxzRwfxcUozjivcgb61/skKgdn9EhrchYf5rrV5pBx7vD0u24RGIctjpdQgoVwR5YS01ip8eCtvCyUpy33enTWDQUBPSav2j6zPC1IjhmFH4nE4dyPRzpE9d9POhSk2YV/F+l8suJVhNlmcpJtMozfah2s73sqIjrwxYhlLW7Z4UHJ/tl+abX72tt8D4R9JgP4O3NzF1A9n5zfihXLIppsJHWRCaUwDsRN29qrkaLRcU8ELXD6zP1VEZv0p3dJoOIgG6xeLbBjxQWGFltrVeQQv1sCW13Uub9ctNoSrEh+bv8/KrJ5NkHmdcmdZTu5Bk7n+ChDNOMaf1RPbcmH8JhEUHmxV/i9WYhJNbYKGv77U6FVvQDKCPYY+NXcvqfV41zkXH9E+r3N2++LnBCY3Qd5T8mu7U6aJOUbWCZfetzYdj55sOzEycGsC24LNw6zXgE1iPieJe4DSvbX8q6D8Yl1N0PITyuDqs7syyQGnTMp9GYaTIRVDdaTKd0me
 BnZ37AxT
 zCOhDvrNpyKD+NNlsa81t4LprEB5utR+ifqoxOxTjHkLjP+pWOodVWjWe3/crYakdMwktNgL3qpqEkc3x7KlT5H2klIfoamGFHKK5mubSuKxPDYVCSfnyIVDi3PH7FEjbeMA0W9Uc6osHtPjN+fcMTzeJCXzOlCcv0b5HbcrRsg13A7sMYExASxoOArD4FLfkb9GOgp4AxZqK2UW7Uxu3pTAebsAvLwMxRz22mJ4GnPmErL44x8VgwXuYFMqX6+kIf1Ld73ylirnx0k62RWlBbNBdyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When get_hwpoison_page() returns a negative value, distinguish
reserved pages from other failure cases by reporting MF_MSG_KERNEL
instead of MF_MSG_GET_HWPOISON. Reserved pages belong to the kernel
and should be classified accordingly for proper handling by the
panic_on_unrecoverable_memory_failure mechanism.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/memory-failure.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index ee42d4361309..6ff80e01b91a 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2432,7 +2432,11 @@ int memory_failure(unsigned long pfn, int flags)
 		}
 		goto unlock_mutex;
 	} else if (res < 0) {
-		res = action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
+		if (PageReserved(p))
+			res = action_result(pfn, MF_MSG_KERNEL, MF_IGNORED);
+		else
+			res = action_result(pfn, MF_MSG_GET_HWPOISON,
+					    MF_IGNORED);
 		goto unlock_mutex;
 	}
 

-- 
2.52.0


