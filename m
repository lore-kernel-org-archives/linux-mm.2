Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FBCDCE8D6F
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 19:00:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F56B8E001B; Fri, 14 Nov 2025 14:00:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A5218E0023; Fri, 14 Nov 2025 14:00:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06AC68E001B; Fri, 14 Nov 2025 14:00:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E1C618E001B
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:00:21 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B389A13B22B
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:00:21 +0000 (UTC)
X-FDA: 84110128242.17.12EB179
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	by imf05.hostedemail.com (Postfix) with ESMTP id DA3E5100011
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:00:19 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QbtIEbIx;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763146819; a=rsa-sha256;
	cv=none;
	b=y20VF+tB49Ss5dzMdMxtf5+cijcF/Z9B9gD8i0uTujxnH9GwKdxHlJdrdTrGadrMrwCQtN
	PEuDrIWIqGU6qN2W/e63pu9z7EkHSTMTg78CXZytRyc3zA8xCMhCMkClzm2lqtPAkOLEhi
	Dl8zBpWzNafkWmpa5JMEoSqUxPD4pVw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QbtIEbIx;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763146819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=osro0vvPDoUw7oalQJZ+pquNaUniT3EqRQtsUW/shDY=;
	b=QJO9Qijyey3977FwIQolxXS3J/sZoVXLBCX1tf8GkemKm5qjTGUyEqPvtltpM9u+mpiJuY
	X8w6vWaxoJh4x9DJB6kF2+VznofvFXPnN85eK+6Qn33X/tKhgkYX+7pnkirqZOIUmUmvPj
	JrDQHVQGmfLlnNTDNcJE8J/u7B8WwXI=
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-787da30c50fso23588597b3.3
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:00:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763146819; x=1763751619; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=osro0vvPDoUw7oalQJZ+pquNaUniT3EqRQtsUW/shDY=;
        b=QbtIEbIxvqPomkli/UGYHqlMY0dBNDA0wP4EqrUmfr17rn/U0Dr+OHlqE78ntHXka0
         T0NHDwLE+iSCsp0iBDJhE9D5VmycxrFG1f6AUwNuwukN3PNqFkIvocFjs2dS4yUeT1tJ
         Dy2eCyOcejR/7ASrxsRHW6Fy4rImHyv0bTqS+Jpgjh+QIHRScA7RqYxhyMD6VUP8q/mp
         v67b07HYly7VFHY9+pFlSbOhqZMpZKiZLuJSoSnvVZkKHKJUVdtpOeqxyPO/5+7zPIVG
         X3j9tI/S0FlhHNNY2raCct4JtwKTC0IOSahpSABV0xvwPhQzZ3v7baZbSYzPdlNhJdcL
         slSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763146819; x=1763751619;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=osro0vvPDoUw7oalQJZ+pquNaUniT3EqRQtsUW/shDY=;
        b=qrTAa5wOzRF18MWP4u52z8nm22xXE5GqfqNlS+WDW13E+oJTnxop/N8TURuFZDyVWG
         mdX/Ud/cRA9XxeBl7YebNfImOYDfzFhRPcvHH3zKWWwZfXEOae1AYwtF1Yf3S1S4w2H6
         iNk9WYmagFpZCBtT5Gs7DeuWXUorMXI/wR15crb+8pi3JF5xp/Uh6gCA9SoRx/K1dtkh
         7UZZuEn/Xzn/vMNi1iq7RHUPIHOhp3B+u5OXHi46ducFA4EzpnXBq4ruZPvMwMeDfSXo
         JSZVrJcR3wpNxg85WlRYFKELB081SsYcG3JUTDQBxNrlKmQreLcdVtIUHaVrJfJ2phJG
         ZUkw==
X-Forwarded-Encrypted: i=1; AJvYcCWzXToQU4HCHVBf5+6tzvJcwuPUx7YHWByIV/UA5IdXJWds6pNsh68XrwEZS5BJxbrtRTG7b36j6Q==@kvack.org
X-Gm-Message-State: AOJu0YzHh5ndQb/fllnTcF+kyrDZgRCvg6V0vCgcwkehL3x0LbRhxWFr
	m0epFunTYmxulDYlcInUHE28uKN3AzZzTD1iio/3sQBV2PG7gqtyk7uEnKGqZgX1FVI=
X-Gm-Gg: ASbGncsIF/dE4BU48b2WgLSx70rLI6xRSSsLSQ1AY49vF5PJaYvGDDqDMlW+1kkJNdC
	+G2Wib5xb5NpKNw0LzmWC9qkgUlwpadbFv+m9C9+oTlMjtu2HQb5gZP5Pw0qGNVkTWibnxQTGTz
	iHwIIKg/l0KMeP3jYolrmPs7nG7k4xlYdPW23QR5WCy6CMsvaVf51D4VRt5URDsxqCWuwZgVEeI
	GxsZmakg/xgeZglplEZ/y3TXJf8IlqWlEolFeqIKad5HfzK8r9GZOcXJFIz7+JmszTp9pu0kYyY
	SXMQj3I5jshWAP++Up2coDsjUTRBJYr3kAjuwfe6keHAPK3IfHrdXKrIxv0m7ttZ9VVL9rgHBeB
	UyujMk7DTbVpbDSvJxf+6Aw8e8mTDUoVMJWa+AbAJBCG5C2UBuCW8tgYsVrdWnGc6+JcyUk2zPZ
	/nKxxrL4TWkqnlhwETZLkmsLcWKENyTbxZbDA7XKFSbNP5s0tC0NvK3/AECPUKf1JhgJbbKjeXW
	QQWEYM=
X-Google-Smtp-Source: AGHT+IGvr9tG1xjF2akJwFSXf2zHKR6TH3Z9kXWzZ9fYjencDngFKKzCA89Ng2VGtn4u+YBqr0oiew==
X-Received: by 2002:a05:690c:a0aa:20b0:781:64f:2b18 with SMTP id 00721157ae682-78929f0ce7fmr58794497b3.58.1763146818865;
        Fri, 14 Nov 2025 11:00:18 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6410e8f4f2esm2014058d50.0.2025.11.14.11.00.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 11:00:18 -0800 (PST)
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
Subject: [PATCH v2 11/13] kho: Allow kexec load before KHO finalization
Date: Fri, 14 Nov 2025 14:00:00 -0500
Message-ID: <20251114190002.3311679-12-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251114190002.3311679-1-pasha.tatashin@soleen.com>
References: <20251114190002.3311679-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DA3E5100011
X-Stat-Signature: gwdnmdmo8irsd838cpcgadkgznad997z
X-HE-Tag: 1763146819-834332
X-HE-Meta: U2FsdGVkX19m1S0/U57uZoCCZOcPzOso2kUC3b1EuS3m0ani0gCZ94paHexOmfeSoZ2wD7xPw9gO1yn2o4WzSsCJg7FPRHkpYssiHLIE18pYueRtd/jdbBzI746H3wxj/x++ZFjk2SuTpdmZCfyKY/5FXzFvT3o+u8W/+RTvAQTqdG80PQuj99wY2/jJH+KHzKeRLNdznrsXJxLJQyeYHVIbG1AA2zoTeXnUp3yw9nw9FIeKjZ6HyfdHa3WT9qdzQSZvuxGrDKxKAmpWrII/9p1HbNyINItOOP+N8avbI+oe/4NVxHFlVaWAOqZgFOYZfAtnpMwWP/nPrd9JzeLPNE438X5lymeXi2nkC3AXmPsQKeiVPHTk/oco1KyEfvmMwyYtpjHqWkjbxeJcIel3C5Xb8HJ3oun6f2A+MFEj6TmTBfB+2cCmjDcEkt9kx4FUKvIZI54Hbp1E86qXwwysA/SXSoC+PpUj3G1nQJosBTHc1PFro76A6wbLVYE7ldbjHnCZpdaIsNtKu1GnYLwGtQFqmbdHjzRmlaQJIU2ODV5Xh+1SLIN3sTkW0661IiHX08CdfNwxLlPwIjv//34oDdNhrOctb486l9GQuAbYftTXI8bFF5IG0taVOh39LfYQVJCY8G8yugu9oMQHBnhj28q2SLkH+nCXtGDVF7tZkdJ6XPQxteS2Ehqp6rkIfONMXAmZpEUzdFYlF4bNvm4j0wN2mHftOzgZ3kSEIQSMonWIfniWGS0TB5RypQ7qJLhZuYMEBn1x8N+bL9S4AJboWoI+1IdqSGUByoo+u2q1Vex5XXPnkCpy7ka1fGgizA+NvFjqvDse1AjHeQRLXbXRzgpCKtkmujj746EJh+YF2hk0CQ1+NTBUxI3+0MAzjCisynR4CBVALqbYQxVv+hLkUho/FF2qtYCoXO+kZzAJJ+3+uXWd8bt7JEY1V28n7Kz/ScRQFvi6N858DZzjons
 tszdSKdK
 dm1V0MRMZg0jKzrSe1unapnxs7haPahUzIBg6Utcd13VeAyFD9605kEVYUGF+L4LtDtMAH12yUrUEqiuOW08j4xxs+3c1CWuNolqT5LCkYNGSuFp1k+7OUC9iEDQOAjzf9zs0vRFjB4uX02dQcLvkIw7GxxGfMdclx2IzhfvJpufmoVAQOZ5y6smkTXQljSuDMMkn1vgPA9Nx0R+Xgxz53nUZfd2hDAVBrsifYqBJekHp3lS3RwitOuz4eKSvddSWobdID/0E84B8OyP+S/DH3EthCWOWPWrd2Vl/61AIIeXLurvMnDIcNtvpmtyQe5/HVo+xLMrItHDkpcaSEycdkeUiwaRllDQqPH15Nz0Us2wnB94q05YlfBJBN3xfeJqQssDd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, kho_fill_kimage() checks kho_out.finalized and returns
early if KHO is not yet finalized. This enforces a strict ordering where
userspace must finalize KHO *before* loading the kexec image.

This is restrictive, as standard workflows often involve loading the
target kernel early in the lifecycle and finalizing the state (FDT)
only immediately before the reboot.

Since the KHO FDT resides at a physical address allocated during boot
(kho_init), its location is stable. We can attach this stable address
to the kimage regardless of whether the content has been finalized yet.

Relax the check to only require kho_enable, allowing kexec_file_load
to proceed at any time.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 461d96084c12..4596e67de832 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1550,7 +1550,7 @@ int kho_fill_kimage(struct kimage *image)
 	int err = 0;
 	struct kexec_buf scratch;
 
-	if (!kho_out.finalized)
+	if (!kho_enable)
 		return 0;
 
 	image->kho.fdt = virt_to_phys(kho_out.fdt);
-- 
2.52.0.rc1.455.g30608eb744-goog


