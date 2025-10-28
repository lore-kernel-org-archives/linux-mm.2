Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D90F6CCF9EE
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 09:17:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D5CE8012C; Tue, 28 Oct 2025 05:17:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 187E98E018F; Tue, 28 Oct 2025 05:17:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 000298012C; Tue, 28 Oct 2025 05:17:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DAE158E018F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 05:17:25 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A46FF1A03EB
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 09:17:25 +0000 (UTC)
X-FDA: 84046969650.29.42B8D85
Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	by imf11.hostedemail.com (Postfix) with ESMTP id E40AC40013
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 09:17:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=weissschuh.net header.s=mail header.b=RkSCx4Jk;
	dmarc=pass (policy=quarantine) header.from=weissschuh.net;
	spf=pass (imf11.hostedemail.com: domain of linux@weissschuh.net designates 159.69.126.157 as permitted sender) smtp.mailfrom=linux@weissschuh.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761643044; a=rsa-sha256;
	cv=none;
	b=2K9Y0It7WmU6/5GcEWVJJEof+eDcef47fphRS3N0RSSAF3/h544SLNBdg7mcnqsPOjlQ+B
	rTcxsZLJ73Y/BmEny06rp4JOk2z0i45ZzWOJTKhf4n+h5hulE9Ff+MjU1B+hbks5LTWxkP
	fo2YMRyyM54+i9/kez5M4nnUZwNQpLw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=weissschuh.net header.s=mail header.b=RkSCx4Jk;
	dmarc=pass (policy=quarantine) header.from=weissschuh.net;
	spf=pass (imf11.hostedemail.com: domain of linux@weissschuh.net designates 159.69.126.157 as permitted sender) smtp.mailfrom=linux@weissschuh.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761643044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3DYDyl1jRFommQZs0Hn+zTZFO0zr3qtFmo87urpSaDo=;
	b=T/O4Aidjnvz4Mbqc9rs8S5F3kS5F2RIlCjsLHiL9i7E3GBQtJ0gG86vlubZ7eyL7ljCJ3T
	wel7GH2orzuDStnuCAJ7LkAOl2tmbUAY0cLwyZfajJ+IleRPo/JztOHtFEdCFQdjg9NE8X
	c63wErYV6ThA++xDsbQrUi1hqufsaaE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1761643039;
	bh=//QBJKcVdfGqAssYU8JT7yXYBZT3MIx6+94MEhcclCI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=RkSCx4JkyF5lLQUNeM42rFHtDmCXVpviOOcGrnETa/0HpC4Zdw2nuYjdH/4PFl6LC
	 M37gJsTtA9t48ctKGxpR9J+cgERSI2OA89fLXif/TGCIYqkwtsOm90oGVGKh+3v7/O
	 FWcQuK43JhS2hqil05ihbYlwxNee1T0QddlgMNzU=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
Date: Tue, 28 Oct 2025 10:15:42 +0100
Subject: [PATCH 07/10] um: Remove redundant range check from
 __access_ok_vsyscall()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20251028-uml-remove-32bit-pseudo-vdso-v1-7-e930063eff5f@weissschuh.net>
References: <20251028-uml-remove-32bit-pseudo-vdso-v1-0-e930063eff5f@weissschuh.net>
In-Reply-To: <20251028-uml-remove-32bit-pseudo-vdso-v1-0-e930063eff5f@weissschuh.net>
To: Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>, 
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Kees Cook <kees@kernel.org>
Cc: linux-um@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761643036; l=919;
 i=linux@weissschuh.net; s=20221212; h=from:subject:message-id;
 bh=//QBJKcVdfGqAssYU8JT7yXYBZT3MIx6+94MEhcclCI=;
 b=Pyl9VMqLf2pp8Ulil0iQPsRNz8apL+lyucc74Nzhhix207oGH6tlAC45ZUnY4VWNUjWWKJQcx
 j1dxaqoDJmUBaathXH3i6r4J3xVGEUN8K6MC7Th5us+FKD8hWjRUdLv
X-Developer-Key: i=linux@weissschuh.net; a=ed25519;
 pk=KcycQgFPX2wGR5azS7RhpBqedglOZVgRPfdFSPB1LNw=
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E40AC40013
X-Stat-Signature: dozhx147pny1ynop9ut4sj3jpj163e9c
X-HE-Tag: 1761643043-577158
X-HE-Meta: U2FsdGVkX198isNQc3cCR4lYLgki/XaHr4CiL97lyxy4zzqTEvDcrIfgaIuc8OqypHx6HCjdv6a+DMXUq8zGIjr9xypntMh+OIvjkS+igwQjLqC5fe0aqNDwwdGJa6YVqLqvhdYtXqe4uc3MVwWxaZPAYy17LwuleQlMWAd3Vr3TsNJDpw9kMk/unnz1/LcneLu768sXv4f6Kj0Tb9G7d7pBDwNajwrk1VK+L64qFf5hlLVVOQJGk0rLWhu+LJCrcPYNzkrrN8gery9p06rFdwL3bmBQNu8e2aQmGkm1HQnQ4KShEiGAXQzuKyU8wSOAMw/fp+JHqfwzqlRzutXLtcrUvVZ2WNnoPn7fQCtgxd/NBozisuHMJVwqHzzrGLms05MqssiIsaeL4sx8BRu8VxZyJkADkwLSHEbhyWkDcl2NEvDUqWZwypWPm/AAReaA/vt+Hh9lf8CCSAyU28vcqiNEbJZp+t+34zGe9PD7OYTaiiDW6fo+LU5FIDOSnKTJTonOSiSjJpe7tRZE2akrg0KT59AfwSVALOvy7uGzFcLLJvklkujQhLRtteiBRUodwZewUDPD6ERdMGJ6mCTIH3j38Ebpl9/xdCG4Q3rX8wVDfJjHrnoWmiWhiZuwpm+SlHAavvfIsBQEkCus3o1WFJrqt5yF2VtUth19TVUIBno4Pby1O3wWTVKybKMbC6Xox7OogninLBZb/EZlIpEsFaVhyoKGe/Ec1b6qYhfqgSwKpfc9dMOzOVqw1q4XdcEaTpq1YpXuEDwOLVVB+QccjCaDK2XiE0M+RwDb+HTT15sqC18feXGcpmUiS6jrZnhyG6uXvP0cKtBazhghzU+UUitMmhmfK3mnMx6/y0gn9Ajd0sHIrHTYU8s3y9Zm2F0ox90OxGSN4wR68yYSgwzJJok6AlwE+rGka5jaQ26KOUIKuHKwqJTGrh8yy1zzDdEOjfHdKruEkAb1EM84xAZ
 8Zub89mY
 Pvp39T6hxANJaz5Ccr67uzrHvSzLz3uxQCdMFv8LAjYBr8BCHWgH/DITXPO1N7bBOTU9rx0DIrBffk9iiHoT+mC9mpuyZoFaWZPWGb+ei+LLsvVRh6iaEHtPp6fJKPAwQJWNKSOev+q7NkJVIK142WCUeUS2g9CQ20aeYBwqZ93ktIuVKZuOwqzB3VJsz2Q4XRlO1o5yGf+m6bVi7ncg+5p/kvKMWBI7ZQzFey70BguWeyBhdA3meXSPLORHCjjw8GzwPt5RtT4fjOJdeuhSdsgePYPFKfikBbYnRtjqwfSk3PN4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The only caller __access_ok() is already doing the same check through
__addr_range_nowrap().

Remove the redundant check.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
---
 arch/um/include/asm/uaccess.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/um/include/asm/uaccess.h b/arch/um/include/asm/uaccess.h
index 1c6e0ae41b0c..3770bdeee100 100644
--- a/arch/um/include/asm/uaccess.h
+++ b/arch/um/include/asm/uaccess.h
@@ -17,8 +17,7 @@
 
 #define __access_ok_vsyscall(addr, size) \
 	  (((unsigned long) (addr) >= FIXADDR_USER_START) && \
-	  ((unsigned long) (addr) + (size) <= FIXADDR_USER_END) && \
-	  ((unsigned long) (addr) + (size) >= (unsigned long)(addr)))
+	  ((unsigned long) (addr) + (size) <= FIXADDR_USER_END))
 
 #define __addr_range_nowrap(addr, size) \
 	((unsigned long) (addr) <= ((unsigned long) (addr) + (size)))

-- 
2.51.1.dirty


