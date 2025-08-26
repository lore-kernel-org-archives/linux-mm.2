Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5ED33CA0FF0
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 23:16:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEDCC8E010C; Tue, 26 Aug 2025 19:16:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D99728E0105; Tue, 26 Aug 2025 19:16:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD5FE8E010C; Tue, 26 Aug 2025 19:16:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BD11E8E0105
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 19:16:40 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4C34F1A0378
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 23:16:40 +0000 (UTC)
X-FDA: 83820470160.06.1B221AF
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3BC9680004
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 23:16:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=DG1yVBHI;
	spf=pass (imf30.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756250198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=aK14C8WHtwfr9yBqD7cQYdKpQBzE143ZMlJ2OollMC0=;
	b=RHIn08+fK2zZNh+tReTdB0GbPtyOYNRmHNGu9N5GWYv0DxFE96WucUr8K+V3pjaT9z7IYu
	YRf7AZRPBhVWbpU63BwbhhHy8epyuyn5RfQMRPqFXfoCF4imI9Gez2/NPHk5my/ZB7elKi
	j9CWJSw6hg3aCdV1A6fMDAP+Yp8P6wk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=DG1yVBHI;
	spf=pass (imf30.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756250198; a=rsa-sha256;
	cv=none;
	b=wVCKgCpcK8606RBviI87fOI+8Iv6WGcV+iw2iugQ4xn/RK769g4W21YrX3prRAdnUE7fc+
	3J8yKIv1JXupGiGfFdYd5RoxmCB45V57aFotgJGEqjOpRZf2Tqj6Ks/6ZeprahBoaSehrs
	9XDe/nKSPjDGXeshcpcDEaJYJA31ds0=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-afebb6d3f2bso65905666b.1
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 16:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756250197; x=1756854997; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aK14C8WHtwfr9yBqD7cQYdKpQBzE143ZMlJ2OollMC0=;
        b=DG1yVBHIzJYJAYRA8VLqvK8vuQmKE3AXRk8NzqHUQ1cqL85/XaTbSoxJpbpwvrBylg
         zxV/iGAFXyJYK6EAFd8j+RJERMe/W0BxQ1UY68Z5FX7rb+4JR5kyKZmuLs0Vtap5AmDE
         AZTX0rS5JeGD3ZqI4SunH5B3HnF9vnfN7ZMD5mvMd0SgoT7RS/UQt+ap1Q0DRE/LfXRx
         //b3zDecBbV1Xs3Ai7BsfCvNzRECmZSEX2RrfcGBviyrKN1t/g+hITlDOCdu6ZO4pPvB
         tm+F0WnVsfCBoL4jCiTOEFZcgxRJLDAbCcVSG/PT4xoHvrXgVWAChli+adfbGDKK2mSL
         rC2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756250197; x=1756854997;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aK14C8WHtwfr9yBqD7cQYdKpQBzE143ZMlJ2OollMC0=;
        b=Nag9t8YoyD4u37l0MiVrsFzxEms4+fDzFGeqkkJ+loKV4gTZn5C3eexmzslcH2wMUL
         jS+eR2m1muskW2smRbzzOy1VID3esDMkjUplJMHSpfv1HmtrzYQotfWMBroIGQO11Lie
         1wl8Q3y8joDtyCey2/WY2+zJpTv2FTZUp9An8TgSGwQmcAAeUDPj4JYHdlpEImYEaEKJ
         KfOeQ8ZqAA1ef77HKhsMHGER9eHd34XJjKrmgV3mi1LCK/RJnOO3cmJ5wKtRY8uPqY7f
         iRp318u6dWccH64XpruMmEWBXIRJhnaewstKPwBclWEKoL6Mpf1wZjpkSwkS/RMXA+/a
         /sfQ==
X-Forwarded-Encrypted: i=1; AJvYcCVIHE3NfZyB/vKxK1UJ2mdUJ0kwtpjquBKhVfEBQ6XWJ2PWOJ/VNcxA8GfMsKoi/u6wwWtiH7011Q==@kvack.org
X-Gm-Message-State: AOJu0YwE1IohofogRLKeEer7gi/bKd20uzMWJhj2FTqeQE1ilzrM7UaH
	rcRNKWuP5UEMiduBIvOz03B8qKAUEcvypSM3zvY7xeguguKh3xY8Nd7DhR21gCSkPpc=
X-Gm-Gg: ASbGncslkHjCbd29cTjwNd89lc0Nr70hmdkNoa+ApF5e/BayGkqugGlEbZTE04GCz1A
	g375zcY8dnrn25xYhih1+5MH0AmwVh5A57ci45FiMZIzrBtafI36tTKoS9pMciBW34+O4onztq0
	+uYQTTT3gVNqLoUYHyUiJKHKpMuoOpJaetjSA6GJVeF/nrz3gxwoX8JDCPSWISMDWmKO5LVsc2v
	9mU/g+MHY+qmNtmp33074P3icvS6WrMKd9UGmDfyjLV+bs0AJ1goJ+kbNewIQz+BSRNqJBZ8g36
	Osg2N3PxiKH9+xCuLnKpLjn2GK8fzzFeZ1fPjZtb6huYaXmX+fmGEmPVwmEMf9EX/iVOPQQ1yOw
	9ed0zFLovssXpaZHa4UW0XIfyOP/RPk8WP6OGl5zgkVJYUihIXhuv+2tL92bZ9cjxSYB9mbK/Gk
	e3bvnjbNe+IjHJKCHOr0G0Ew==
X-Google-Smtp-Source: AGHT+IFiG6h5lI6W9GmtX6eyyZFaeAkkYu/4EvN9xMb66KhJPYTSBOh+0PHK7R6lz+1qTP8H7JPHOA==
X-Received: by 2002:a17:906:d511:b0:afe:8d25:770f with SMTP id a640c23a62f3a-afe8d25818bmr502309566b.3.1756250196702;
        Tue, 26 Aug 2025 16:16:36 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afec3251fdesm23170666b.77.2025.08.26.16.16.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 16:16:36 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	shikemeng@huaweicloud.com,
	kasong@tencent.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	chrisl@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH 1/2] huge_mm.h: is_huge_zero_folio(NULL) should return false
Date: Wed, 27 Aug 2025 01:16:24 +0200
Message-ID: <20250826231626.218675-1-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bw4ofbx3co1b4sbp4geiit68dzkmqxup
X-Rspam-User: 
X-Rspamd-Queue-Id: 3BC9680004
X-Rspamd-Server: rspam05
X-HE-Tag: 1756250198-839332
X-HE-Meta: U2FsdGVkX18+Rif2+Jaqn/fzhQBRXk6lMSyURvQHR/FXYlgwrw3XN6TVvIq1UGn04T9hyFXGEpZowjKs5mBX0BXPdv6sNfq9qDyZOjU83N7m2FNpDT+ZKaa7188LduEDDfhjzq3WmJms6XxffYy+Igifn0awkToebZUyYvDyV9DY9Il8SwPpF8MW8XNNCJYp7c0iQq0XOYfbV3hQzl5UgHP8Ryn42NabYcY7xs9aH4hZObvl+RGrslYqN0JLJVxKM6OF8W2E9peZtmZ41gSrjJ5bh3NNV6vhWjlieZIg2IKxsEoHVw7VX5PGqWdmUQ9eMWkTL8sxp70KI95aYgWjYk5A2NSbzdICMuc2ICtwM4RDVNjhYTTs0W/eqleSoWRkn4/GEJCLB8GU8pxA8T8Py9Gq5TqUlyNtIMGVM5atgi16Y0v5Rsm+oE8c8vHYNJ0lR6039+GKK6NX5OVyZSpIWZPeOTzWZQmbUBRWXEvFP0U7/PXlAj4COldVbzFH3c84lutJEkp3IGNusvQynO3sSU7WNlCRTBS10Zmqb6eVzHpPxxYWEaOzCQnt0Q0r/LxvnnG9GQmRamv8gVwYNUo7tmR2sDiDjpcvqu8R+t4RX7YwWArdwer81G3cypfhaZGHmJiJqnEocqV/GfO4FErQk+sznoP+JXNNQ00nqTXDuXIz6Vsje3rFov4/2T7A4JtUajuVpbNqCO9ViLbuCsWti687PQYaL7W7afU+fRR6N4p0xRAE1bZUzmS/l+44g48S0RGDzdB5feFAF7WTbS65d65HToekiEaM2aX1XUL+30U2ooa/I7X4yPI6gNjXj12U9/k9pCN9YQwHrREyZ6Kll92iQN2jZInD6wB2pQ3JUWiLjngXuuLi1GBRSeTatCYQZwEco+YJNVzBAImc/vcG8ENiY4zzOXTSPboWc/mzlcediZgmhH4+2ZS3tfCOUc/nMmuszFqbQCytS1moHSJ
 RLjVpyvx
 j476z+ub2bcJyeEIIbim9S58KraIoPH5vjJiINYIz5RcLY5lWaRObpCbwjlITkyVo2m+XJXe/UMPaKHlUMSUI1PWh91Gh1QAkwlVUyfm55aPuXnNp+gCULnDowMbRnQ8w3Wx7q7zDruTisRGdbVELnEYRwDXGW9X0HRso9wezIe0YY312g5VVM0JROT0pUAD6weggQOZtz27l/QSQhxr6aDRhE9sOjPj9jvRSE2lc2k+yVCXjd9fo2oyugUIKR3AQ/qd2WrVBNEarxuEOOsBtWTSBqGvyGxKSzbDDewyBfayCvP6ljBQWVZbt5yTpCICKoQT+azBAu0BRbf9wce/J83j8F8OKEFphz8TSepCc8j5+gVgzfQIhYnSFc8eXDEHc/z50
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Calling is_huge_zero_folio(NULL) should not be legal - it makes no
sense, and a different (theoretical) implementation may dereference
the pointer.  But currently, lacking any explicit documentation, this
call is legal.

But if somebody really passes NULL, the function should not return
true - this isn't the huge zero folio after all!  However, if the
`huge_zero_folio` hasn't been allocated yet, it's NULL, and
is_huge_zero_folio(NULL) just happens to return true, which is a lie.

I believe this is a negligible corner case and I don't want to add any
overhead for this; but in debugging kernels, it may be helpful to add
this check, therefore I put it inside an `#ifdef CONFIG_DEBUG_VM`.

This weird side effect prevented me from reproducing a kernel crash
that occurred when the elements of a folio_batch were NULL - since
folios_put_refs() skips huge zero folios, this sometimes causes a
crash, but sometimes does not.  For debugging, it is better to reveal
such bugs reliably and not hide them behind random preconditions like
"has the huge zero folio already been created?"

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 include/linux/huge_mm.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 7748489fde1b..e4c617c0b445 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -479,7 +479,12 @@ extern unsigned long huge_zero_pfn;
 
 static inline bool is_huge_zero_folio(const struct folio *folio)
 {
-	return READ_ONCE(huge_zero_folio) == folio;
+	const struct folio *hzf = READ_ONCE(huge_zero_folio);
+#ifdef CONFIG_DEBUG_VM
+	if (hzf == NULL)
+		return false;
+#endif
+	return hzf == folio;
 }
 
 static inline bool is_huge_zero_pfn(unsigned long pfn)
-- 
2.47.2


