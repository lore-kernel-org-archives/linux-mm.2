Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A543C98318
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 10:14:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 765E86B0088; Sat, 17 Jan 2026 05:14:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7143A6B0089; Sat, 17 Jan 2026 05:14:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6122B6B008A; Sat, 17 Jan 2026 05:14:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 503436B0088
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 05:14:58 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8CAEA1403D3
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 10:14:57 +0000 (UTC)
X-FDA: 84341047434.27.30B8EF2
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf12.hostedemail.com (Postfix) with ESMTP id D56C640002
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 10:14:55 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Y3hglikK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of maainnewkin59@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=maainnewkin59@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768644895; a=rsa-sha256;
	cv=none;
	b=vmVKwighte6S0U3Z3ks8svzw4NbRqXLQTel1yya4ugknKzpqqcQN+B/W4MJiIuaNn5zuji
	168fK5ueLz1Ss4d713y5ZkmMp+fvUy3l7Pze+6w8TUTi2CoI17PAzfeQSVO9niMrnUA8pP
	TfHbuBhtcArQoy6CxJtnPa7WAZBrrBE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Y3hglikK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of maainnewkin59@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=maainnewkin59@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768644895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=TGWGM0UMbqQQA1qYWeTulU9eorodHJQC1p9ZrPxNCC0=;
	b=ZyHfSY3Vh/GxvLwFovHMvopDbKV89DVNz3YnZo7rVdOjEbNSEFT8vtg42Npb3nCaYfhLCN
	8Dyz4t93NBnlmsVC2RvNR2JUYkzi/7x7i6s0JSw2bLc05JNiFtqIHVkNIkZTSELuQRgEOV
	ZetmP7WwRH4dx9RxNwkxc7xlS10+JiU=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2a0d52768ccso18366865ad.1
        for <linux-mm@kvack.org>; Sat, 17 Jan 2026 02:14:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768644895; x=1769249695; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TGWGM0UMbqQQA1qYWeTulU9eorodHJQC1p9ZrPxNCC0=;
        b=Y3hglikKkw4Tp52y6Q/Ar3/aVJIqiRaPFt7mqlArdWyPMzrgE4mB2auF/VTKN4RwbQ
         CsCqFKk3JOtNR/qBdN036bykDxmvh2NMrhR6SxlKFxr9wcZLXk4rfr7uSk3lSm6OmvHa
         Qr2hrIvPigos+h2Gka2gwd38SW8SslDqsPZW5l0DbFvJ9iqAbEx+ObGb87HrzDFGVEmf
         NMDSms9Grv4xGOsisK7uXlaOpnRNsC3ZWuAhqrjR2UgbuHr/5LTiQ6/HlASlLXFhs7t6
         7MsVeSy1BNQbvhEQG1B/LT52KdtWVtqdHGX1l8zEE2JQaoINFe+7UoBuQ1VfePAEnlpz
         60iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768644895; x=1769249695;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TGWGM0UMbqQQA1qYWeTulU9eorodHJQC1p9ZrPxNCC0=;
        b=awSdSNukmGBuh8q00CGEnbNYqlcpR9YMF2vq1ljCJBrHMY/GB7R72oAKHZEjI8E/dk
         M70lQ1rICj/kJomzEpeEMO1cM/aU0l2BQt6Z0oFFHuKX0mAsIhBwSXSObnXkT1Vdj2W8
         Ygb3Z6RS4R8ylaplX+3kFCqFjOiecasMfuw7l6e4yw2niMvhH7WyBQKTOIYznK5kzElG
         PYEq0EE6iGmW4s/sQDb+RwsTTTUx+Ez/EmqtIGqbD6obQaHsh9M0Qf0hNarJwcJ+PS+X
         iWHKSaXmGaX1Yhsl/oThquZmeo5oOFxXJ2ZQxxIJWiaKknudvTFiMnsidTDxZMNFXfJP
         2XTA==
X-Gm-Message-State: AOJu0YwhU0OXkN6JIemgNLB0/JOP4qyfHKJOe5R8GwXMJnB9qy8DYafI
	dI07H2bTH/pjbD6gkpjxGfYtFnX4FCB/xR896aVllEJfmQDxUAPLnhZbrAQ59QkY
X-Gm-Gg: AY/fxX5V8a44ubyY434WkbXVX3n6v9WfigR+Jolvevv3kE/kRBAMQa293ZO5DZWld5J
	O06vB6DVdGl1IDMoAY4t8Mja9jhVQlYVugWjx6UNERDkdloNP48zcUUUQ5sLeJEPVCY6mi6qzR3
	ARWbYD4iFNmPdk6YenS3v+Qw/twnteJEsvSxaeWO+CaYwmA2TTA44tbH+Ei9PfwSwYbh8p+hOYK
	fgkIycXg03vTD8y3tIMd2rmKY4uPoupXxO6G1IkRXqiIQIKyb5dyb6YeySOc/YDk5o8b4aOBT/B
	+Kxomms+tMawXaJRI8umA7dZey6sysVdHx6nJe2WRWMuSRVohfozoe++Xw67kANWdZfF2kW8jXC
	eIi1KKP+OclpGINDam6h0XhYqKGIsv/z4GjcOW/lCWgzac3wyqukp1u1Smq3YIHdgGigRlyx62d
	UeBJG/rX75Gp6TNbwOq4w=
X-Received: by 2002:a17:902:d484:b0:29d:9755:9bd8 with SMTP id d9443c01a7336-2a7175473a5mr54225985ad.22.1768644894620;
        Sat, 17 Jan 2026 02:14:54 -0800 (PST)
Received: from sinoka.tailf65001.ts.net ([2a09:bac5:473a:155::22:121])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a7193dc83dsm43514535ad.50.2026.01.17.02.14.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jan 2026 02:14:54 -0800 (PST)
From: Taeyang Kim <maainnewkin59@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Taeyang Kim <maainnewkin59@gmail.com>
Subject: [PATCH] mm: update kernel-doc for __swap_cache_clear_shadow()
Date: Sat, 17 Jan 2026 19:14:28 +0900
Message-ID: <20260117101428.113154-1-maainnewkin59@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D56C640002
X-Stat-Signature: k4rnbbxw6okptrpgs4wh436owc7soy4w
X-Rspam-User: 
X-HE-Tag: 1768644895-452671
X-HE-Meta: U2FsdGVkX19sS7ZEUUVf35FhDLRq24moE0lcIdJT72fJ2FI0uvtu4IikeZINvqUiMaS/VevzI09LC2EFqbhJyq2geQUgLp+IeCS8spN8Do9LaOvhsaAPwIzUNLESZNzH9qbJEJLYCTecIb787WxSWHBU0n74qwGgFj3+YOWh7XeuZWbIdztiCCw2EryMk6F+9KFWbb7CGv39zMam8MVuOK4cO3UmT6yXr8A54vwN8i35dHKfql+q1JPqJTM9G1S0Swp7pw95Yf1mAWwB/2DMry5eU9cz05KCZ4yHVp4ztOlWuX5F4pVTcKVpVEnuemq7s+KGYLy8cgb4KsVMSrzgYCz4rPhDuatuD+gE2pvcrRXBJda3X3EIiXO5lP2K+kjs8VHvlVoLYt0YOBVRDBCwptyI2pWAcqBy65zxb5jAX2j+NTC6u+ubx8owPl6LiQHLZGhCnB+T8ZFUicbIVswnqn1FulcTNNpM4NsUmaVYAff5s+DJc1DnjCXSjNHEO4U72NQvpBEI3RWl34j2l/XPRnPiaLIRoaZwxb3XUBZ5PIuwNjzGoUDlGeWoPx1ZQ7YyiA0ryS/iEx+t0VAZim+kMMn7b2p+OQMCxTCcvtS0nNVNh8SRxPuQ50aYMEp+iRKuoiUspwpw/KG/T6upMiDj1DCTnaaKVR0B8v1kzZ1TVy6LmacDoTUHvfD9tFvOZF0EjEehId0kAs3MWnN6U4+Ea+IC/DUJQ1t6VhXiKwt9NaRBjYLnznJrXBWaMl6L6pxhFKiuPi39drA8CXydfaEj6Er++7HeGVOHV5y3hUqW1tYvXn5Ty/8jj3/XqKzlUXJ5xM+HvmIFEfpO0LCLkWC9up6yMzqOGJYeqUhwaIWW4UakglD1UwEVfD9e33IeVqzC8mwoo89P95olLyOReP6iPnXhKyh16sPTjw2DCoq8vPmM+5jBYnVWm8JVulPWRXyiFCvsRr9V4dB6CX54itO
 sBaeW09R
 IRjCdkDLRvMeh3Pl85XSWQJw5qhwnzMJcDmJaDDy0C3fVDtJdcL5IE/t3C9iPPcDVLldQw+IhLiW40BNVjK0ox1bgmOeRt+n6wJLMsqj44eaL8jRWS7pHlaRB5lRVoP2UF7PObAEvEvp31C9wVfnf0OHAwJ7uNuNK/kPEHreRV9PK8qFTLXP09d8R/jqzrltPbIs+9VQYM29vToe14QwaqzLDBucxOtirpf0cifvUnkn+NsKvdD5bKkPZxlW32IQvMFjbwLOAEJHXX5PbRwZ0W7BgVZfRgbypI5DAU0mU/3dAB037VSQQyhZUqrQO1D09qIok8/ab3RXX+hHz9NeRk4H4c6p3+cgNL9+3pPMiBCRBFi8d7Qe7cNrleqT4KxP47mNOIlQs98flebsLC8jTzWEHW+mGExgaSJubKDGXOWY6bgVGBjDIPaKPNcajiTB23cA5W95TZ6mTlXnHnhKjgm+9kXKpqtkFAy/D3AuE8wRk2ddNuGVhv0ZRoICeNBuNm3ilHe6PDXumPk3DzhJr/Ft890tHKecY7PWRA+sLcp7a8IU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.001668, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The kernel-doc comment referred to swap_cache_clear_shadow(),
but the actual function name is __swap_cache_clear_shadow().

Update the comment to match the function name.

Signed-off-by: Taeyang Kim <maainnewkin59@gmail.com>
---
 mm/swap_state.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/swap_state.c b/mm/swap_state.c
index 5f97c6ae70a2..19b67d0447fc 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -284,7 +284,7 @@ void __swap_cache_replace_folio(struct swap_cluster_info *ci,
 }
 
 /**
- * swap_cache_clear_shadow - Clears a set of shadows in the swap cache.
+ * __swap_cache_clear_shadow - Clears a set of shadows in the swap cache.
  * @entry: The starting index entry.
  * @nr_ents: How many slots need to be cleared.
  *
-- 
2.43.0


