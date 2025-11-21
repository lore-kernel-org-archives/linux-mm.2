Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B53ACCFC29F
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 19:49:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1C296B0010; Fri, 21 Nov 2025 14:49:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCC126B0012; Fri, 21 Nov 2025 14:49:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE2696B00A3; Fri, 21 Nov 2025 14:49:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9398E6B0012
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 14:49:22 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 062CB13B9F7
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 19:49:19 +0000 (UTC)
X-FDA: 84135653238.28.52C7EF6
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4F3A8120004
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 19:49:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=X1jEslEw;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763754557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=TBLkqxECVt6vh2mVEDg9DRa+tt0xvbOVF5f6m7yl2VI=;
	b=NL61c4HleQdI8GshticMMeY7c3KQHhiWedPliZS5EqnkFfmHp4wC2BjWDG8kCm6a+6yPwI
	4xs1z3PtBrUnkJAcnszJbaTE9sW08x7pR3FEqKg/dsPQoJE7F3USdecFrGA20FpKxkAeHG
	nVAoiugJUOmjZXqDU6/7GhdmvwSYHmQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=X1jEslEw;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763754557; a=rsa-sha256;
	cv=none;
	b=10O/Pk8tp50JgwkZmGHTMdFy9icceM3DlznulaPfdwbu9pak6SrVBy27koDw0JsZdvTR5c
	SsrfYkeYTn0kpMXvn/gLw7Z6/cJ9gC3Bi90zO91mruQ1sGOkC6fKsCvsNBN7IUVNpXE5Bm
	EKWABEig90ud+L1opHCNzRuEfzDX9D0=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4ee19b1fe5dso31664671cf.0
        for <linux-mm@kvack.org>; Fri, 21 Nov 2025 11:49:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1763754556; x=1764359356; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TBLkqxECVt6vh2mVEDg9DRa+tt0xvbOVF5f6m7yl2VI=;
        b=X1jEslEwwIm5biVhLPJLjNesDqV3hzhUj5gTDhOBPSGZeRRxBYhhNvOGcVs2muMIEG
         AJeSND4AR++EDmM75gKO2i3iUSPIo0Z3fU4xq+2FQiy9Rt52TEAA1bTRMBZYVQT+Z8DN
         59iNSjZsi484SCbs6XWbs05zoT6T1HjGGVttFc+IhjS5zjFRwhddgF2eMa4qFafJwSVd
         5jFTmlx5ycSsCe2QOn50bqTCvrh0OAxuLjs2gpuPlJiGRNZREhRbdSJFY+k056YKf6Am
         ZA3pkh88cUlUN6XDm5VYVzagfZpIifYZSmxq9jvciEayJePdePn5mCPLDvIkB6IaAt0N
         sj+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763754556; x=1764359356;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TBLkqxECVt6vh2mVEDg9DRa+tt0xvbOVF5f6m7yl2VI=;
        b=LwouETuTuuP7jZ/ovdGo0KkG4dfhNJHiTrjeaaO5FCzdL/tM1njZR7vx1q20A3o+53
         8tNGpy4iWmlu/JQacYH8RrOYBCsDOU+ldCBaJyAIDXK2iXA9kiqAKRA+pcXQjM+HJAQ4
         gcfkXH5xme2dnYiwZRHtt1cKymyaoX5v2bQRQv7I3Y4rqWDTYGcjRug/1QVkDsqhLAsS
         Nj7J25X+f+rvSqIhZC/I81lv8Rc5S530zWmyYs9m3hoZPXzMtyxMSD4SKJEtcI11ZDfF
         SVjdDBpjdINHrxPfIljo/ysrjrHaejqXY93/bhWf+QgKrmFvVUOUbRrFMtQ+GY/ebk7X
         +nGA==
X-Gm-Message-State: AOJu0Yz5OZd2MqbMjLBdtGvnnehR/Ix1LWikhyl2UU4cKKXDwjXy93Xc
	ex2X17EyXPGzUWQuwr1hLpjRdTSUe/2yJ2M5vExAz8bCKyaFK8EVRe+/L2Toq+b9hK5pN156sJ+
	pFVv/
X-Gm-Gg: ASbGncvRDLhehG92vGwBpe+itdwfPeI7MdNwuSNW4K7CV3HGd/XpmGFRjABzZ2P5u1K
	hd6elasVsZKiWIPNoew7Q1vInrdhrXdSbShGF93fNprcT3nsNZek+bFDVYTNkk1F3Glo31dnqOL
	r8Gk53rt51EOxCD2QPUOQLgzm2xR85uuoWPuGfu/TjPOkRSA2iRcyEGNZDQiklM/aIhk59lIjZs
	RmrdYc+uapc5JdTGJXwLLCIRTVPDvlhlR1gG3WwIk4lcsCkyEDiuvERIbswT22rVWxO6VdGSqX+
	4yMbvb8ZPXpW/PqYURJxs0rWZxYxWig44kIK6Fp34//lvyMCMsZXd5ufQJoWSVYksq/2GmiJ0PZ
	Ji6JDPMBFpzLRaNWK9daHi/9NFMnrBNVkLWrPi66ETUhlSu5rol179xykud+gtKzjqaOoYfCcnp
	MhlEtIpISMpbNlGXxKMqyU73TnRzCDrIt827qZhUAcRf6ceHWh1dA4D2pBNK+E/dFzf2uAWjgdV
	zQ=
X-Google-Smtp-Source: AGHT+IFLOrJTopaAw5MhJtVqGP6gbzxwPQYNb8a53b1o+eW05OysW1/6xOfJXXJMrzgOtkpfdWfX0g==
X-Received: by 2002:a05:622a:44:b0:4ee:1bc7:9d7b with SMTP id d75a77b69052e-4ee588cb852mr54670911cf.39.1763754556056;
        Fri, 21 Nov 2025 11:49:16 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8846e574918sm44510266d6.46.2025.11.21.11.49.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 11:49:15 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: kernel-team@meta.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	david@redhat.com,
	linux-kernel@vger.kernel.org
Subject: [RESEND PATCH 1/2] hugetlb.h: flatten logic in arch_hugetlb_migration_supported
Date: Fri, 21 Nov 2025 14:48:58 -0500
Message-ID: <20251121194859.265259-1-gourry@gourry.net>
X-Mailer: git-send-email 2.51.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4F3A8120004
X-Stat-Signature: ofr8jijj57kzb51yfg6h9xroumox57jn
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763754557-892068
X-HE-Meta: U2FsdGVkX1+KShA9vih7SwRKYWPUbQA4oud6zw0jg1m3KvImLmJI8b9Jp7YnH2c5ZHWTwB4eUTe5svCd37iL2OmvRcXLc7uBslvgyhsNUr4nT9IJvxNHmDgsEX94N+rCUHh8YrPepmN3pTvycfCONMeWYkMCC0lp6uyOVRbSMzIsPxOkdCgckIeqEi6LX7VwsRNGJWEG7C+Ra5iJaOmi+tQa5zR+NABZvn4dxEuAZXa0U89nzXuCKXzogFkh2YslVQTwWaHwPftp3V4/xbIatAxB12AYaFy7KjLYrEAi34Zewx1jJ3pxUe3C7Izu7B1H6bE0mZ7aBwpP9PVgzboHXuHqkt/JikM2P+qnCrNoZG5R3KotPtH/Potshs5oKrk8F+oxRfF6ky1XsKotUAXYAh0iJA5g+kzjfaxV73IeC10ErUNSj1y61dWnfOCg/gxfPAF2wgebh9iSsFqLBFePUbT/EvnOmVyGvnA70oGgV8ubtXyQ2sDbSyFXHs15Ya9gHdy6tpJyA1DlO4BAZ6KnWKVYZMJWNEdSJOyNSjp4T5nqeUd7HDRi5gLsSVAMMsILjayCBeKqWbcoJtQ5GAnFg++amPVBWdQlxO14XPnRumGOOk5B3lPM2XXqXlNJjNzS+NcCB6SmsrL7GWyAKrKjCUeyTMq7w9qRTddSZZXZUcwAmV945YJf5yLSeMs7h0ikP18gFhr6WjfHnlI1HtPezE/E1c5sdEsGjEL5dKb+gJa1B9OygG7s3qjL5n+8jy0aomjbP82CK5me1E8YtuZnMLm0PtepEKPll+jDQT+iFoOWrOtQ6yFihmtqUg8mSx5PS4iTdY7D4Z1uHc8BZ0fWOd87C4Btaf6TiI7Lfpe+TVxxKl7V3bOSZSp2pf+E9/+oRQDsqDQhfTdpyoWXG7iDMju75UmBdHPZ60ggEdLfwtXns2zMHyHMhHp132r+VK+o/7eOGtwKsgvssZFw6RX
 V9YcwW+t
 ALvzVhYfI9f5J4P40Hn9ZnebVlb2hTcEMe/BvHeF4R6tiA/wkkFYLSz180FKZoYoMJGLbJycyiSxjPNGWNnYhFNiOp9WV8WM+z9CVLlyi/VPG6H3Z9qFZ/hmFiMa7KZNBKM7XP5Zbcjh5IUoWy6zbXjGP4cKd3EZPhof3FE3lD1DTiEB3jkbVeVEDBU5O3HPmpnesjjtE57I7QFvZ/728OWJZ0c4d0GiuVp/RzX6j4b8/d/fkJTWttWPyEbc99PXnQRDI0XrfKGxRRVlzQ8AL1KsHTNw63/AOxRvVpsSn1kuoSafAy0TZSZP7DZMh22N8pg3P1AwOaX+rvzHpWzgNL5QMkmwjVk3oxUj56M8pjjIva/RVYspIeL/z3ve6iEvgGrFwwRKN0VNGZGARqClZldHmGw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Simplify if-true-return-true-else-false logic.

Signed-off-by: Gregory Price <gourry@gourry.net>
Acked-by: David Hildenbrand <david@redhat.com>
---
 include/linux/hugetlb.h | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index eb21619206af..d5282d52493b 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -876,12 +876,9 @@ static inline void folio_clear_hugetlb_hwpoison(struct folio *folio)
 #ifndef arch_hugetlb_migration_supported
 static inline bool arch_hugetlb_migration_supported(struct hstate *h)
 {
-	if ((huge_page_shift(h) == PMD_SHIFT) ||
+	return ((huge_page_shift(h) == PMD_SHIFT) ||
 		(huge_page_shift(h) == PUD_SHIFT) ||
-			(huge_page_shift(h) == PGDIR_SHIFT))
-		return true;
-	else
-		return false;
+		(huge_page_shift(h) == PGDIR_SHIFT));
 }
 #endif
 #else
-- 
2.51.1


