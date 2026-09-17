Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF668C982D1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 13:48:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 914906B0095; Thu, 17 Sep 2026 09:47:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EEDB6B0098; Thu, 17 Sep 2026 09:47:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 803626B0099; Thu, 17 Sep 2026 09:47:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 56F636B0095
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:47:59 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DC3E8160365
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 13:47:58 +0000 (UTC)
X-FDA: 85223382636.09.20282A1
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf15.hostedemail.com (Postfix) with ESMTP id 236B4A0006
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 13:47:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=BecBOv0w;
	spf=pass (imf15.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789652877;
	b=FMKk7sNN19XTj3P+XANTgZEsdE8ZxAjZku6e3hJqJ4rgJiVrw80FFSVvQ9jDjV3QpUYAvV
	LYWjVNTsXdDD0ObBywMA2W3vdoVvV9OTIAvKOd2jOHIme89h1v0susxN02JzLHVEINp/o7
	qBa1OTjTbVJ3t+1Oet9xUq+OZjiIgK0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=BecBOv0w;
	spf=pass (imf15.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789652877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ji3axTtoFrhEc5dq8UvC0E5lffT8DbwX5FXf+6BtpwQ=;
	b=2Joihl4aJk54hQkgTI1Va7qu3YoH67ju3QeAKxo0x34c2GmdXCzNzWFrR/cFg7HL2x5rOT
	CoG5Zq52fd4YqSHxK4FKtctDaJAmdHTDL2cK9bx/evPHSWes4G8lv/yG6h+ES60nRMstzV
	hyboxOIDF+XSJhytHj0jA3rbKw1BaEY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=ji3axTtoFrhEc5dq8UvC0E5lffT8DbwX5FXf+6BtpwQ=; b=BecBOv0wr+SJF33yEWPpz0/lMS
	gBxdtd8yD0JdprD/49mqCczN8hQ3BEurmxw6+WMWwErUzDW60qgneU0sHcYFAjVah7z+5Jloou/9W
	e007wRt8/l4ZhXcN4N7g7AZcugEUaG7MRQATtIVt0s+Dfk/c0LhI2lf/sasaSmjh7vvvWMWa62NIp
	onpD8v9ep1WwTvmBTssezDx4p3/ouj7G9qGBXo8IeLeByjutW4b2druAlW+/0ZETzXIZWjlRwxSzb
	BjvcyOQsC0iFAnzQPPRkVMzvZufT9ceGzaWJujWj6ReKXqBfjcj9UuAIi4HFhktLdM7cmIL59LzU8
	ro77G/2w==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x7CSm-005zB7-19;
	Thu, 17 Sep 2026 13:47:44 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH 0/3] kmemleak: fix stale documentation and raise the
 verbose default
Date: Thu, 17 Sep 2026 06:47:34 -0700
Message-Id: <20260917-b4-kmemleak-doc-v1-0-84fde6d1f749@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAHbvq2oC/yXMTQ5EQBBA4atIrVWiSyNcRSxohfKfbjORiLvrG
 ctv8d4Fjq2wgyK4wPJXnGyrhwoDMEO99ozSegNFlEa5yrDROC28zFxP2G4GFcWU6LTTRAn4arf
 cyfk/ltVr92lGNsdvA/f9AJ8ZQpdzAAAA
X-Change-ID: 20260917-b4-kmemleak-doc-1232546f4225
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: workflows@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Breno Leitao <leitao@debian.org>, kernel-team@meta.com
X-Mailer: b4 0.15-dev-47773
X-Developer-Signature: v=1; a=openpgp-sha256; l=988; i=leitao@debian.org;
 h=from:subject:message-id; bh=Y3/WTQ/l4oRXIFqoGJBY3yM0W6YAM9UCtn+ZY5zlgfU=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqq+97r6e00yIzYT04C5vSbseQ6yBFaKFGQ29FI
 1qWzRuSQLeJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaqvvewAKCRA1o5Of/Hh3
 bcXwEACGgqN4ui4VMPS+2k7A/7QdcBjYupp4IXS6chcEBFTfSfHOtyqJ/C2WSs3QFIbYcfomw5D
 1p2gZP6HGsjulqcvr0m9OMb9jE4BfSEF6jEybbzFfznX8MGXK+FMuaPx7jxSgPqVVyeKh+Maf8c
 TZAD7dmgyeo2tBPzT7tvVWU7vKc4NVwp2byLDpR1J/vYIhg3Rmq3QNus/mX1tu1r2mA6P2aUf3u
 4hdez/xTA6w7mqycS3j4w1LAAfmybNhLZoEOy0hILrvfIUCUbChX1S8u4+mrXRRCJSiVZ8mWla7
 qOI02wYiz7CqlrHNDfRniuPsVl8BCbS84z1Rpu0X5/VcCKwPNk2rDnyWsM5Nn7GeWxXkrPgrEJp
 2gKAlZC8BICqoRsEja61yHYVOHD6LSAh0fWZIZh2yjP+4BfutoBhYLiCfesNiZzsVyOY+7k/jXu
 f1nIFUhUpolaO2IyAVTTKg0ydMAqXTPb2iCw0FTsoGNQ+088ib/YM94qHoGgjqgK2Gr8B5Vzo4Z
 DEDs9caQpC5dibRK35vSqkBQJ1r5FDYe9tavCCH86x7pPsayDyBUvUJTqEiYHrJT7KCUZ83fFc2
 rfJ+mU1vGmmWqJxlzaEdZzmHIMITKmjaychD1W6ncZmqYz0Gj9rscR5ZIW4cgIu6KZPrRbvbtl8
 V8ELmV/ENTkYQWg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 236B4A0006
X-Rspam-User: 
X-Stat-Signature: fk9nmrgpkqqj4uuwfckit64z1h6iuprk
X-HE-Tag: 1789652876-638855
X-HE-Meta: U2FsdGVkX19YQMl+hhB/oJTHEK/gNsMpRzFywAy5KLlENv1vZcZbbBFtTlNq+w8XPHvxyndkr98GXJldsB7qvw3gCu2u25M+ZjMahWGy8leNDDCUfKLokzvpoRQMTruKJURJLeVRr7VbIQc0jB2MAvaJDrKQ+1OLpK09rqHZW+yKC8m/DuiOYvLxIWlqVI6TFHIr8auDh7UXaJMkmchYOyLBvj1DbGCStNJqUp8DykGevVeOb2jF6OGliE/4Supw73XctGTLrUCJJar6h2Xi9KYsa6AVtr8vgn7b71wJgSWy1tRZGZVDq4fXkdFjCIdtGzvssm2LFyTn1Ir96hi9IRJ/NQ1Q9HJHBgIqAf1ZZ3ba9PKRO8FQjBygjr379n2WLaZS55iV3cTZunaZAdsqmdEn/EV14vq2V7ksTBY/ngnS3UkUBe2HhKY7M4SxG3Wxc1wwtkHq0lpkw/2G81C+qCOa626UW5o60jcuV8XkJvyRALBednpzDG4rBQ2iLJGq2D7VeRWfG0NkhyPcKgbd98DA5dKL35pX/AjzTWPEdKUepYqC9GRAUq5VsJhUt4QjOyhdAElxXeECWLJ2+4KBV7OX5aNuU5AAinbCtweTZDkQNC0qQIw00zpMI7HSB4kt1ryb4MPWQQuCf61PLquT1n06PwUTwOcOEN6uzu96GzxHtZ0SzQkK/cGNYFHMg6pV9u7PrBpsmGebd8Zmla02B3v9SnrFUP//znNclUMY19g+ZzmDcPn1qfg6qCrjbtVsEqYXeGkMBoYNVE621U1eA47w8lV+pdi1lWDce31/5qGirSTxXAyaUKw1biqqHs0TKl670w/DshIll6j1kBdQhjotLWIEKn96RiUU5d9QwsbBrPePwRId/9vZr+uGMUd7KzS9zrJ7mgTb6CludZEJxg3Cq2UfJHJVq2akUJSlApxjoP4if10pACvz7Iho9XtE67sgmI3VvJ6gIxnRDsW
 AsX4Ov6o
 6W16ltY++aJJK/2ZqIanqzqq4fRuLrR+kIZY1dq+DDvJ/OtO9ek+ZLmxYwPJvXQvkzu3sxlYRGH+tDWfckntqtRhpPVs3nVobs5wQkyOGhjon4092cMyQuBZY0KxYf5MNsTiFjKigMCTZK5dVmh74h9K1gAAqUbfYtU2LTd1eQINeuH8rVsmWQZV0MAWrPhD3UIbN+jOwch59JS9vxXFPfUZTgBLv1lXPoJGx+saKzwiMuzgvx3ETr+5W36hwB7HpkcPPr5fFY/Th5pZZKJolLi77jhtxE57a/Jb4DO24L5oGIZqAnPC+TywW2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The first two patches fix statements in
Documentation/dev-tools/kmemleak.rst that do not match mm/kmemleak.c.

The third requires one more consecutive unreferenced scan before a
CONFIG_DEBUG_KMEMLEAK_VERBOSE kernel reports a leak on the console, to
avoid the last false positives I am seeing when running
CONFIG_DEBUG_KMEMLEAK_VERBOSE on a daily basis.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
Breno Leitao (3):
      Documentation: kmemleak: describe the metadata pool, not the early log
      Documentation: kmemleak: fix stale statements about scanning
      mm: kmemleak: raise min_unref_scans to 3 for verbose auto-scan

 Documentation/dev-tools/kmemleak.rst | 24 ++++++++++++++++--------
 mm/kmemleak.c                        |  2 +-
 2 files changed, 17 insertions(+), 9 deletions(-)
---
base-commit: 587858367581b9c55c3690f4e63382ad622719d4
change-id: 20260917-b4-kmemleak-doc-1232546f4225

Best regards,
--  
Breno Leitao <leitao@debian.org>


