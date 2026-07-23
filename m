Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E355C531CC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 18:47:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2FD76B0092; Thu, 23 Jul 2026 14:47:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F075E6B0095; Thu, 23 Jul 2026 14:47:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E440E6B0096; Thu, 23 Jul 2026 14:47:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B4CCD6B0092
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 14:47:28 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2A62D1C0086
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 18:47:28 +0000 (UTC)
X-FDA: 85020924576.05.E12794F
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5D94B100008
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 18:47:26 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=a5jIUrYo;
	spf=pass (imf14.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784832446;
	b=c505VbC+y7hCKBv1qVfhnaYZHkRmXEPykbF7eA1AH4MxSdqvV24jaBsP2bxdLOixYG69gw
	vhiyQqiiNK0vzF+LrseaVHAdg83vL3USMGKjTHf6cGyQgJLvpzo9T2wtbhUGxHdC9YWD8E
	O3tXlmEGj4pqCUR4/7/DSQ6gvsfVhbc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=a5jIUrYo;
	spf=pass (imf14.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784832446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/nXlwcFamigkva6bDWgvzoIWdAmElQTTWvr7VWxupS0=;
	b=dt/G2O9HSjxzshSqq+PJXizIJJ2wEtMRuG8dVNBj/ct5YZpmUf83IgZaWT4FkTbUnDU+Uq
	YkD+GsiO6ZebNTswIhkfaVu45svnAivQzuAmW+G+EozSKz+j3X/CYXzSAPH26KmM1tikW+
	RytDWXKggcTgtP6IotuQsUEybLcJ5Vk=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-38dc4553f62so1054899a91.0
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 11:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784832445; x=1785437245; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/nXlwcFamigkva6bDWgvzoIWdAmElQTTWvr7VWxupS0=;
        b=a5jIUrYo3Sy1liwk9i+1CftnIeNi2gvLoCzaVyYFKf8CPaPkqnVqfBRSHnqBtYzifq
         9zdAl9MTbdb02p3Q+7zb4s2fX8htnKV/ZdpPLWKZLL63jAJp6smWpHm0SFssXWh3JKbU
         TvungNHZbo8oJ49dCojUwYoJWR6Tl52CMxQjALKQNtX3pSgymoeH84A8wKEV2MPn9P7m
         qZwAQyXBhoPE6xsSfxe04pSCtJyPYfKRqvOlt5VYEzhOM4NljaAAmuK2RlNdtTfjv+xh
         cBZFbmUuS5xl6KnOxdRcGGyFgRnH4aiHd33+0yivKdgT+MIRkS9XHV+UmkEKVj7fFZOB
         Ld7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784832445; x=1785437245;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/nXlwcFamigkva6bDWgvzoIWdAmElQTTWvr7VWxupS0=;
        b=ZlRtyxCSEX0pQ+m9vrCHpJO/cm5o1cNjbdqWf3PPMCyCR4eQy9T3gbtfoTv+F9Kmmj
         Iz/7uvNFaedbc6Td9bR/Cvyjv38rW5Llv/CRLb2IGp8/T7+HB1nt4kmCTlAq0owaBm5k
         29QbyvGxvVcUuR7roDGtsJZx4mqm1CGUsR+UQuKebo5FYcxanwiVEm4bN42UmyOFuL47
         yHvh/pM/F92hCewiAsEUm6cCb2KtZ8mmDvTOkP6eRutKzCCMSzSb7O+hQ6LMpilvJpmi
         yyLAA/U0qqpLXvPQyT3X/HalF0/Tr5V26NReYnCLrF4aPTr9keYwChHZK8VWSudJ3KLZ
         C+mQ==
X-Forwarded-Encrypted: i=1; AHgh+RqluL7DahDb6eBTnDmNolJuiCPIRIwqKtUfLzjqyFcA8iHhD6qOeSrmRS2gBfdx6yMK3aX5LPmG1w==@kvack.org
X-Gm-Message-State: AOJu0Yy7JoUqoMnE4FT2Z0CnFZYE46+cybM2JDWLohUWp25JFKTO+mC9
	Nbn4tuZTmDv+1gLJ7O/2mM9Rs60nn5WmQC0UMZuwguDvU7fAzScH0/4OKDHfJCLGDos=
X-Gm-Gg: AR+sD10VJB7/xbGfYcE2u4N9lCRFklg+bMz5MhHGkeY8rP2SObbSnJlgJ+MxslzYZC0
	w088zUbYa0PIiCCGQp0ZeNJ2GInaymNc8BnxNwTPZhkz84ycqUJocpRmdmYmdXq6iRtrlhkOKTT
	k/hQhoWX8SO6xnBE5j+41eg+SRynnRLAK1h+YEw9vNhw1MJvAszJNzdN3EU0hRbBcaVcz0hVa3/
	U16bq5/v9bEQXR5yFsusAFrL2PpgfgoFf9UNsysGEJV7zKuhYWLR2KMSTuhjdvxVX964aslu9BL
	xFMLQzL0BXmd1ZKXqfN3NRD6B57TmJ9sqQkvwX6R4TVpEZb611RvYYj8FDdEQ7PT2GfUV7yHn5W
	jInJConTXzzKDHow3oHlKuVaLhSJXY9v3y1ppAnW3LeRLeINPieb/dlCyc5NL50AoUH1S03Ln
X-Received: by 2002:a17:90b:1649:b0:38e:2e16:859b with SMTP id 98e67ed59e1d1-38ec65f37c0mr3966608a91.20.1784832445197;
        Thu, 23 Jul 2026 11:47:25 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f03af8a45sm308155a91.10.2026.07.23.11.47.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 11:47:24 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Julia.Lawall@inria.fr,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: cocci@inria.fr,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 36/36] memblock: remove conditional return with no effect
Date: Fri, 24 Jul 2026 03:45:38 +0900
Message-ID: <20260723184538.3888637-37-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260723184538.3888637-1-ekffu200098@gmail.com>
References: <20260723184538.3888637-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5D94B100008
X-Stat-Signature: 863sbf749ou4b6bwju1iat4y1ikkoung
X-Rspam-User: 
X-HE-Tag: 1784832446-446273
X-HE-Meta: U2FsdGVkX19tnh50ZD6Dt/kV0jkXbx7xUxoYTlVApsqZGtYulGuPfemNUPS/+j0ys10Bm7X7EAyvo7lOK6AqRZrIMTdpFa5p7SkeqTSs8bedFX3bF2cpRWYyg4ONQhnDZ7vho3yNASqWXusQ6PLB6L1dWneuf3jcRKeLtHP5bAFjMNl57Kf+NP44P/G3lfs6909zyLkl0D+VCL9x0JzwvW2YTGmqnxy98JqiAIxIe2CAG/cQELlC3kKlLVhHOwp/dyVWV3di49KiDTkCIBvQXkOJAMiVvAg9WKwGxn6OAsWnxbfr0rmzzoWyDMscF9JP6wGld1yl71mnU0ZqhvxOt/WPPYoIJdlMK2a0d0qR8aXYU+OBz4PE4nVYY+MoHfJk0coGYqRWYg4lOHl+lOhqx0cdFbwN8jM64mBmaOQASvwGKegbyR43qqRUdvtQj+2GXD61Xt3zsXaf2PHG5OLMCqnCYqNl+JHFpWmocKoKBArjPFgwQlSW2U4sBCkXLUsHnIonji/Yzn1whDnE4eRMVP0ayFYclbI2Aw5HpHrPMC0CgfV081R4Nn/QBYVbcVS+Y2lIj/Ge1L/dLl7iPCxOMBPkmiz4hjJBOAWvRfZZPquCTtiBTRWuaNASRTxAJSjSA1675WhLeYv5eYqnxyTOq58PVqGGE/GkMlNJKozJU2vI27ZbZReQSmr7W/9wQOCLGJc5c9Sl11O62EH4/iZ80AZGwy3TxD2QARvommOmtRo7Sv+qfyCMviSaF47ohnLIh5Lrbhkr0KDT4x3sknfBGeToinO/d0xSU1XsgZWl53hUPrLfQeqFtKJJoGi4nnHTjX8lF9mmiHnR37aTBSDZvg2i8/mqm80MyE7JSQ4cu4BlAgViVqgEPSPyMh4X7WmcQ3SF6Ibf+4kIccZ8zPA+ToWYnXPCfOAS0BgIfMBNYGNgESbxpL5GlQplmEE3cjbRGqNa7okT9pQqFOyMMN4
 MX0m5v31
 IunSxXs9xb61zlV5XggK8df23OY/UCt5DnKjXhAKD0iAKLIwcM3/UaRfh0y30OnPU2vE9qDZ4SVsAyuGSIgz7BzQMzLTWkOw9NO+9pcISFrzbLC+OUblx1FFPtu2ZwTCBoypocYBF1ECt/JDSv2103QW0neJHkL2iZ/5Ht1Ry6ZsoL7pCXT/GXwmq/kxcx1FK7rXVS03hZw2adVhKv2uJzrH0r4h7mqXqz4714z9aGT+w7ndauMwtuVbmT4v+AyO2Yy0TI3p1b+cFFRzN45tlwrR6RYpvEWfL6SAwSRgKaOm2reBpwnHSYlqlCxCK+ngaJyIVNb4d2z05hm9eVcTYeM+o/3uJLKmQ9fNdxbwKwxxOTcGqokIjqFGhYbeDGoWpctgqtGrbNGuaCvXU0lbV3dRseYe41GFtkskNhygbcF6D3Jlx+S3hy70EXunrFGhuNUdjOkV70pr7p6Lod4gsG9uy/oKuAur2eMWSSQ9opjmjTjI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Both branches of the check return the same value, so the check has
no effect. Remove it and return the value directly.

This is the result of running the Coccinelle script from
scripts/coccinelle/misc/cond_return_no_effect.cocci.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 mm/memblock.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 036316e9138b..6941fdaa3473 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2614,15 +2614,10 @@ static int __init prepare_kho_fdt(void)
 
 static int __init reserve_mem_init(void)
 {
-	int err;
-
 	if (!kho_is_enabled() || !reserved_mem_count)
 		return 0;
 
-	err = prepare_kho_fdt();
-	if (err)
-		return err;
-	return err;
+	return prepare_kho_fdt();
 }
 late_initcall(reserve_mem_init);
 
-- 
2.43.0


