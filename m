Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2473E674A9
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 14:18:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 613BB6B0089; Mon, 22 Dec 2025 09:18:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DDFA6B008A; Mon, 22 Dec 2025 09:18:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DD0A6B008C; Mon, 22 Dec 2025 09:18:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D7C96B0089
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 09:18:52 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E31D8C0271
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 14:18:51 +0000 (UTC)
X-FDA: 84247313262.10.34B65C5
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf06.hostedemail.com (Postfix) with ESMTP id 26A56180009
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 14:18:49 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OG94cblD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of klourencodev@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=klourencodev@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766413130; a=rsa-sha256;
	cv=none;
	b=l+kMxX6qBVvuSDRICxVUIK/uGzFs+QehcHoo5aVm9WA3mUfagQxbduvGWFyi8ZQ7IHSW/D
	0LEV4ZgCfyEpa03plbr1rinCafLq8kmMHBOY5G8hDNcY2Cy7dT6Znmhz757K5szLNIRuF6
	oBKfUlG0+uQ7SZYHYJoI3y7tP2sXfIo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OG94cblD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of klourencodev@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=klourencodev@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766413130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=oabgOpu1w4pBns2E8adFByEDsNIerdSwDprQD0X/ik4=;
	b=et45eCDdqCLhCRbhcRfLOZA//IgQQwlh00WDwEys7kYOGVOxtP/Y2oE5dRzo2tZMPRgMgw
	o1dWCw5haUBtFHOXgzXaTStGAyJSBVBroVCtS/BgwGmOJllYVO3czUxTBSo597/L45rMMp
	64kXWiMR6MqC+N6U2MU8S/EdsFTV4Z8=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4779a4fc95aso24357035e9.1
        for <linux-mm@kvack.org>; Mon, 22 Dec 2025 06:18:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766413128; x=1767017928; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oabgOpu1w4pBns2E8adFByEDsNIerdSwDprQD0X/ik4=;
        b=OG94cblDHrx6XJ7N2RHx5KgxdLWhekTMoUXeUEGf63ZPdsekGvNQWkLIaVY49mtS+m
         xJiqRJaE3O7V2X+jm3ctlJEWfs1Fh7jTEQIpkFzHl3gjDJ/ZcC8MrwPOnPj0h1wWj9x3
         qJ9ZXxrjmM8Gp9GY8shk2EZ9Wviz0qMCRnySIo1ywfF3jNino+UPPdqekrk58/O1i5sH
         /YH9L39cWSG86bQTFJ8zEGh7fJ9Ep4Ny5o++I1IH4LnnckKhOuNMgHn0OEVdjrIIkXZX
         +yiwEiDb1zWzjwOFTWzyNYkO+rvo7OfCGinBgi5+qFTGxclDRhAE+5uc5icLKTHqU3D/
         tqfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766413128; x=1767017928;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oabgOpu1w4pBns2E8adFByEDsNIerdSwDprQD0X/ik4=;
        b=TFTpAr4Bq0r+XXyEd0v3luYmPuNG6unKVQO4Mw0+UjGaeoLf94xfEuGPex0v6cuuYT
         VfYg0fURLIZQQGA871y2pN7Ku0cKeDWJ1DG8C5QRqnG/jcGIY8kiyNvMdFjVY+vUhPlL
         xw2cbc2bDzDR2eHdZ+KxG6uvbKhbq8anqgiNQ5Vwypon5V6V0hS2loMppuhFgSVCoPe2
         DNG+D/k0GLyhwnVwEWB57fUKz2Zi6EG7EP2BQKXdxMctMHOxZEyezOhxWqX0G9tn9diq
         4nESEKFVuPAgtcD8SPP4yvY+HBA3lAZOpDTSihVEn5iOuuQnCu03NhgFA1sXtp6X18ns
         8JhA==
X-Gm-Message-State: AOJu0Yxfa7e8KuWbqF0UVC/mbem3IkyA27QkVv827RzfsnMqoYn6Cdh+
	GfjkRpFGwbq4EaSw5A9WWzNDBuFA8IclNX5hlhPWMgkzEM3XemhX33BHTsiS/Q==
X-Gm-Gg: AY/fxX6/SXcuULhbqPRsx96yt9X+NWMUmJMjuz3SpN5rOyn9o1VCXli+XtTGkxeqIDL
	7k+z/dkYF10xUY/mx0YE0C5NItkCWe34UrEfLLnXAFepL4d6RLamL2c3YkHXpXTx9o9+Zjxe1Jz
	LQBSYFfOdVulMoBqm/WVQx3CZtfbWNvdFSKNKgoSEgkjA3TEmrFy8Gcph+93iQlG6hBSnmyTXOa
	BUy0lSXDVky3jP9ZUjnlsLw1AF5jFdeIhUV3MQ4TPOozKPAEd+/xYqys2vFfhBR+3sJcXEhZVtz
	nZqG5JE2yx7V+t6zOinkOWFmaCA2RJiKV/wJtqE8HnapBct0GdSj+CXIamUkd2auF+jpaFpX0PE
	aN4YphLQFudwK4+HmoFNP+uInJRO67XRZ+Xi0khrU//O0bhjxiNGmz1lVAxhEKI1fZxtISxJLh7
	thaRVi51lWEMudl6NuUGqgmMnng9m5T85EaT3DGd0u6q+ToOZZU/wsTQw7+2xcH54bPycTbV3Cu
	KLtYaA6qKKdKaTfCuFl8wTEfzqR
X-Google-Smtp-Source: AGHT+IHv8WV0o/yD6IfLqCxEw4VFW00AimYJD4g+t0fO4yGCawqC2y58ETmYy7XR3Zo5Pwk8jS+/MA==
X-Received: by 2002:a5d:5f53:0:b0:429:d3c9:b8af with SMTP id ffacd0b85a97d-4324e42eac2mr12146385f8f.25.1766413128067;
        Mon, 22 Dec 2025 06:18:48 -0800 (PST)
Received: from desktop-mu90jgd.home (2a01cb0006769b001185461c960a9b50.ipv6.abo.wanadoo.fr. [2a01:cb00:676:9b00:1185:461c:960a:9b50])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324ea82f6asm22735051f8f.27.2025.12.22.06.18.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Dec 2025 06:18:47 -0800 (PST)
From: klourencodev@gmail.com
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	Kevin Lourenco <klourencodev@gmail.com>,
	Kevin Lourenco <k.lourenco@criteo.com>
Subject: [PATCH] mm/fadvise: validate offset in generic_fadvise
Date: Mon, 22 Dec 2025 15:18:17 +0100
Message-ID: <20251222141817.13335-1-klourencodev@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 26A56180009
X-Rspamd-Server: rspam10
X-Stat-Signature: 6hk87ens5qtqzps7owkwung4wbxqrdrr
X-HE-Tag: 1766413129-856751
X-HE-Meta: U2FsdGVkX185WfkTuqgE+FVV56Gg4vyAY4Ni/JTHv/g2ZLYoAzOlzbdpfpg/BJH6sLOguR3H7VOVVs2CrTTsFupolZ3Y2HiOQwbnDAJT3Cp34UO3DRNublTrtqqNjMdsj8+XWyU94vyUdnWgrvKFWeSKW4T0X3lvSVSgAk+lYrFc3pLcuNEdR2CnEAijeb/H5kuHdZ+n/VmlEdCI57R7YeE352fFBo66XPAiC/z4OdUUgHilUIUOdIHaP9uw2LFpgG9fTYYln/AARlAuGIQfFALCmm6DdFbK4SYzpMdaiA1AUyvchfDeW2LPIDvNjGZycp45G+g1+E2MA0KhxsvQNxMG7XKMBAPa6mQHeMGe5wOZ9dzy2iiFk6hI3X3rVVKOVt0kMS4UJ4a4c13jcIpN1BZiEgKYjO0YG8Sl+o2OUM3aUg6OiKtiUNm5o4Eb2i51QXI8T8RSrM2e3wxMjAotucijeV3kCvzWESJpNLO/9J8mk9U5i/7HWEEAZUxoZmBnPQVI1OD5QHvjCmbeXVleYqwDqGo5UIOLH+m8r99ES6bZnOj3tvM2hrd/GMHSuANySCZIpGs3A8r6iGNRNBG7/l0EMit0mj4/YAgcMLmU6kp1Emm1Yez64btf0dEnH9L/Oq4aR9wOS1OOXvuLYImi0/k9tt9I3agRx5YVGtaREi5jt2g+h2N/uZN4p61lXDHD9VhkLjHl2PGLGnZQh0iiHXpzBGOuuFf0rrCPdQ49PNGEENw66pcbFxu+4xT3l+ZBREslmhYV2NQ7Ru8oJkvLcFAmwaDLsKoWCTuJaXzmHtxaXkQq8e1tYuZQagopJUpqq1CCgb0ivp8jaZrl8gM5IGYE9YFgETeNVDcaibXL0+MWjYTn1cn7KruBGo2f80jK40WWwl+/fdccNqrWHxPGJDkgVIYJMP64hmYxQwwd9nK+aiBA38wFc3W+Ny3GBC7UWiZE/q5qRN5l8glpxdA
 AG/OnFNK
 WwVVXb8mTLXK3Hps9+S5sniqqMzOCFVRHgFhGJMhQwbFhGASe0yal+VI1qutc3uCwv/ME645cgeczEN/4J7x5eqAg8oNgFFuLn6mWcaBPmLXYg0/U7Lg2aDZLt8CVwZj5Oa9YdwrkJ6yF5Szanz5oZsQAmB28xb7r8tfA+Sfcau+3+5E0jOs4x9QadSZ07tUJdWZbJD/VxDwc3W303G6LsOzQiR5eNZqToE00vL2XlhSyTROxdoQ2Z3G5Y7udZ0g/y4h/mFAZyzeuUL0TIhB+bx6idVxFIgO2hULCXT//c9oPAn7Q3e++sklXtNaVk2ug7cu3/ztGrc/cr8nLXi7Xda2XUFVXQvVj6vkLD3DVNh53lzoKyidGiTUFGgQ8uF52+Ad/DHAHNm/6+4BbqEg55HjmN7W9qVITPyk9p27rY3Oe8o/tFt54prXSSwV4Zgy0JitCfwmS7Ik9quws/hebc158bjr5ZTcM5CcrBKTK7twbA0Lcl0l/a/6DEn5NkZHmBBhM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000013, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kevin Lourenco <klourencodev@gmail.com>

When converted to (u64) for page calculations, a negative offset
can produce extremely large page indices. This may lead to issues in certain advice modes (excessive readahead or
cache invalidation)

offsets are normally non-negative, but the API does not guarantee this. Since 'len' is already
validated, checking 'offset' here is reasonable to prevent potential system instability.

Signed-off-by: Kevin Lourenco <k.lourenco@criteo.com>
---
 mm/fadvise.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/fadvise.c b/mm/fadvise.c
index 67028e30aa91..b63fe21416ff 100644
--- a/mm/fadvise.c
+++ b/mm/fadvise.c
@@ -43,7 +43,7 @@ int generic_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
 		return -ESPIPE;
 
 	mapping = file->f_mapping;
-	if (!mapping || len < 0)
+	if (!mapping || len < 0 || offset < 0)
 		return -EINVAL;
 
 	bdi = inode_to_bdi(mapping->host);
-- 
2.47.3


