Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16451D11183
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 09:24:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 681106B0012; Thu, 27 Nov 2025 04:24:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 632366B0022; Thu, 27 Nov 2025 04:24:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 547706B0024; Thu, 27 Nov 2025 04:24:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 416406B0012
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 04:24:17 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DB2D55B9E4
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 09:24:16 +0000 (UTC)
X-FDA: 84155850912.18.AB834A5
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf23.hostedemail.com (Postfix) with ESMTP id 78D53140015
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 09:24:14 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="Gid/SW5K";
	spf=pass (imf23.hostedemail.com: domain of jan.sokolowski@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=jan.sokolowski@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764235454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=SqQX9xTpcwqcS/Y1RsFRMtrNuBOMxy51eUWtAqeV+3k=;
	b=wkFv21TM96A+0Rpl67MABilrVRDAL0Uf44P+J8LyYZt4QeslRchIHwkuQ+43wnTOX2wDye
	JKQ72Wk3DiQK0ySLFnkpMxsIZFZlKvni6aTffnTnn3nVmDpk02rUz2xL8nP4e5WULyF0vL
	6YRO6NoSdvIP/nDOHjUIbFl2rym2VSo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764235454; a=rsa-sha256;
	cv=none;
	b=IgmO+Ne+Ym0wQ4ehE5EKp491Mc82NS474f4ZP5WNcfvF7Vil6fB9kk6EBSas4iS2RselLU
	nPxwN6vd5J2ZwNGcvVmwFuv0ggj65J3NcPUjJdGrQvGX2boU1OL41bq76mE6kJJuXyj209
	k5ONr7Wp+HK1ane29HCUO4xU7Dweis4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="Gid/SW5K";
	spf=pass (imf23.hostedemail.com: domain of jan.sokolowski@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=jan.sokolowski@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764235455; x=1795771455;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=TGD2mBSI2Nm525yY965kECMgewcZU2Vn20LzBqfECL8=;
  b=Gid/SW5K4Ahe2t3LppZIur1yOgeZOFT2/VGA1EhOrvUe3KzwZzhJErEX
   WtaTRAbJih7idinGe3ZOMplpSUy02bGjIu85ZXbJB1L7unWveUwXFnKw0
   b3E1uQLn0a+HpSe/NswpugE4kq2SH1RhUPRFFs9l1qWlp6XgycmNsZ/By
   Wv8UaVcJiUfELmAM4qeYhIUMLmIMFF8H4nqsU67ujdxa4u8yavu2HE01+
   xkzKA9PDsoCx+F9uAzr2t9NYApxxIXlY7rbImJN4Sqfvr+TitZ6dN+nVB
   IECWMkWrN2BWjvrykB8GDPWwFIxVkXlsGsqB1V+RIUIaS/UbRoIKjr8go
   g==;
X-CSE-ConnectionGUID: 3lsHu43VTBuV0hhtRNsi1w==
X-CSE-MsgGUID: VMC76L6xSsWFUEjtUGTzMw==
X-IronPort-AV: E=McAfee;i="6800,10657,11625"; a="66226339"
X-IronPort-AV: E=Sophos;i="6.20,230,1758610800"; 
   d="scan'208";a="66226339"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2025 01:24:13 -0800
X-CSE-ConnectionGUID: FmZim8WuRQWylPHqkM42lg==
X-CSE-MsgGUID: Pfg9esApRR+Pu2HVOvZauQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,230,1758610800"; 
   d="scan'208";a="223888045"
Received: from jsokolow-alderlakeclientplatform.igk.intel.com ([172.28.176.71])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2025 01:24:11 -0800
From: Jan Sokolowski <jan.sokolowski@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Jan Sokolowski <jan.sokolowski@intel.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 0/1] IDR fix for potential id mismatch
Date: Thu, 27 Nov 2025 10:27:31 +0100
Message-ID: <20251127092732.684959-1-jan.sokolowski@intel.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 78D53140015
X-Stat-Signature: tju97xmotf8hzsfb8cb1famr71mao44h
X-Rspam-User: 
X-HE-Tag: 1764235454-510260
X-HE-Meta: U2FsdGVkX1+8fCTaqlPKZudQrnfCIPtNOVbTygKNyXblnbSRkNPxsIWgU/dUgViyDFNopeGjiSAzpTZKaGo/aOU1UNILEljoAQFy7OOOh5IViJUCNJl0YS+SbU69kvcuYi1Mtg3lwWMJ0JpMugXYcOH/EkBCt7ZkdAKz2XOYM3gyDsE/RBytee/HixEz5/mRZtqO2WbB801GUDW24phqrDoRJL5gjQr+RQIlHxrrsJmSGbN9Os3M952wpI2cZ7IzGzZXzvPGlCo2vAsXq/jGco61ScWFlptCxvFGE5HdWSMlzouISVZHObBRkjqW51QnrLWLt/FwQh+34ItSKDrQXi/OFbS2PT83grsiLy2V4dyX5QNnyCNCOlr5+Mkh7KbFAl5tURFQUCBuZ96hW8cJC9UFuI40EQ4u5rFzc3xZxYv4VQPwlIm9mO8J4h2JNR/vaw8VTkfRpwm1InBe4rmvAN+oH/nOzwTRuX+I8nWGjzy0sq3oo0H3hj26+RzDrc3tmbk7pSLYP7Vn7sdtCp/ZBjaZ5ROhd+4+F3sWISPERTDy7ZW/ykWfNpfum5pzX1bPA/9ZrfLUJEa+D0P0V6hNiJDy5dEduME4FqZWD+bXBVrVBqfDNsQT434KzX+Jhub7jRQOLIIhVH4hKx1lT4RhFU6FnHu4Gyy8nxhYdYH4ey48E3+ArvAecbzG4arP49IO8OXqq7jKtVT+Ay2WYdRc8rs8ZBzC7Ra/gNokEt28r2Oiwitqtm7bcuVeyyjrwjGLDQ3UnuqjVrMPmNp09vaOBXaChpCzxvfPhLo81RsE/wcmvxwdTb0xP8YXY7+yCMVhkfYqxHqcNgUtHjZI2XYjxV6e2hhrYltjdD2Txwu1V+nnep9u2fdNElwpvsSRMLCEYweVG361ojI76pFImTPGwfNNwYBdbbVASGyo5n0tjGx7dEV3Z8PR3rj56gkYW+21o3jLDEtp8pRGWX8obeW
 CVc2sNEG
 CQN3MiGC/KqAC62MT0Kko/v0G8APgN1Ef0is7BHvMPne//1WjAspo//HhM7R6cPsgOM1mssLcpCR713Jnv+pCEuvi54MlY3o5plGSaYQwwAPjMdVH9mqRyNicOpY5mg7sN+S11JZZM5z2TH0WjabfIZyehM4doUr/kz8iU5hWlN3Cy212FSkZPg4bhPv1FUS+cKvLac+ds2a6W0wUbH+E3yLsRyk0lnqhgOOyx061NYos4YkSiD/GUS1ryH9fE/bDi89RUIQbSolDmdo7wcV6LkrGpGmIeUAuqtTRr9Ka6ePAFbdW0q8me/K3JluF+ZgsxKVTrSIgBZc8Eya7sxDbesGLSgzmPVikNyy+0JIa9InMiqiwPP3ACifVEDtqKLGahDm9DqE3AaLiuK1gC8+g5gLaxpkQdNgNaOxHLvE8SIW332Rcvy9Vf9yjMm4n4dqbnZoRJ/F+KTB365BFayMkjXnrPHf6ibiSg0bRcg4GlzPyMepvQItgUYD+2CJfhPbhaLtFoZFtMTQ+X90eDKyJ+K3BZX3M5i9RkTt7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When debugging an issue found in drm subsystem (link to the
discussion in Link tag), a bug was found in idr library
where requesting id in range would return id outside
requested range. Didn't see in documentation that this is how
idr should behave.

This is an RFC as this library is deprecated but still in use by other
subsystems. Is this fix proper?

Link: https://lists.freedesktop.org/archives/dri-devel/2025-November/538294.html
Cc: "Christian König" <christian.koenig@amd.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org

---
Jan Sokolowski (1):
  idr: do not create idr if new id would be outside given range

 lib/idr.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

-- 
2.43.0


