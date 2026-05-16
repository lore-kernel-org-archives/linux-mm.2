Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 649A4CD4F3C
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 21:04:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44CF96B0095; Sat, 16 May 2026 17:04:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FE466B0093; Sat, 16 May 2026 17:04:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29D6A6B0095; Sat, 16 May 2026 17:04:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1D5AA6B0092
	for <linux-mm@kvack.org>; Sat, 16 May 2026 17:04:11 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CF081140315
	for <linux-mm@kvack.org>; Sat, 16 May 2026 21:04:10 +0000 (UTC)
X-FDA: 84774510660.13.A19BE7E
Received: from mail-yx1-f66.google.com (mail-yx1-f66.google.com [74.125.224.66])
	by imf09.hostedemail.com (Postfix) with ESMTP id CAC73140011
	for <linux-mm@kvack.org>; Sat, 16 May 2026 21:04:08 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gwAFI2Rh;
	spf=pass (imf09.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.66 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778965448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3O47MXZLACGVXkwBLvK8wvdJrmJyHZnllVL8QQ770hw=;
	b=6JLBEmQ0Nl3E21vjzOjus+qC3nhUKvzUS+X1DljBTKdwqLEWzw4qLrvW16MbRLMukx9DmJ
	vE9DA4uh9q6G/gIW6n0PJU0+rDbuI+LnpJ3ACdGREYRTEVbb1dhKFJpZ3itU6jcdQqRpWo
	nG7F4xbdW23wI3nGDAiqmby7/zI2fc8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778965448; a=rsa-sha256;
	cv=none;
	b=NfZQad3wuonZhQwmY5QuEpTInJCiOipYDSys1Ei/u9o04280UzoFVCz9GW7vDn5nFxNDrx
	4Bs97pOPJi1eMTYPyrps1CmOy4JSkWpg0Mcv/hZVfpkhfMSWLAfyDijy2FSR5oQfmZxthv
	EiO3bIMQpaBqSlK+RvG0JLvynxkEzfA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gwAFI2Rh;
	spf=pass (imf09.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.66 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yx1-f66.google.com with SMTP id 956f58d0204a3-65c3ea2ebf7so1510242d50.0
        for <linux-mm@kvack.org>; Sat, 16 May 2026 14:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778965448; x=1779570248; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3O47MXZLACGVXkwBLvK8wvdJrmJyHZnllVL8QQ770hw=;
        b=gwAFI2Rh2MqIljiSS71ksh/cPkQ51NR6RCg//hsWWb6tTGMo5YCWFMnJvOM154dkr4
         FJqUqK1VKIepiwCGQ+fjRt1tu1uP8sD3XVQz8OTQkxphfOtMwtgPXEWEitc+WRnwbnYy
         rV9ACtFFcQquNr/mJLlH/p9TJ1e5Ot2R+Cj56hGUeQvw57ET+7UgxcMfYpzXBukdtmcE
         jOXOoZkCTUDgInHhYgcAsHHOGj8nhHzOuEx3CcuBezeBwQH+0SFhg5jMQFYX4v2BoPd3
         FqYZvPjjPYu/IbKv0pO1zKpZ2kxwnSRkMfq+o6oT74UxAFT44/O5FoROkM9RQmrq0wWp
         GZIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778965448; x=1779570248;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3O47MXZLACGVXkwBLvK8wvdJrmJyHZnllVL8QQ770hw=;
        b=L7zdLdexlekxWVFKTnwjGMPm9m8xWPHDYBc1BPz1rMYNi4voCLSjCQ3p3wQR2NwtUc
         WZn1afCbWg1bmPn0wpfsDqZiuAGoAyB1voNTkjBc5LJB+3A+6H9W2jaajyeimisrAq8K
         rIf7sRF9h37/EXzcqOnoC1iZ5gde1Kw0HZdRiLXJKPHjuwPz/GVpXdnPOooXHdxkbzCK
         MXWCRK3mp9tRjlK+ro2LrlLLXb6BOSLPoXsqGpLprsMdcmE/WsXvPiNRul8dIdCJYCm9
         96WUlhvQvwCaiAItpB+sN6paQcar7dIQMCnckLZWJBrFxhzgXnAuusbaYoXmvQvCzrhG
         2Tsg==
X-Forwarded-Encrypted: i=1; AFNElJ85l7Lcmcn+EXkC4PXnfeY/AmhtkASescibH2NtN8kBA0Yp21gBlCfy6NtUF1pna5bR9wKogfAy9Q==@kvack.org
X-Gm-Message-State: AOJu0YxJbOySKzqygQUi/4hZ0tiN/GozX+W0rOCSgxajubyLyMvY1Xiz
	tO4EfTFiK+lMs1ecAl6PNHRId8S7NS0ATcah65MInyFpslaBHRZNUvo=
X-Gm-Gg: Acq92OHQC8eiUrsKxm4az1WRGyeqULC9eW/0lwypOlL8VTDeYlJBLCGaFk2qoyMBy92
	nyAXl91WxXewqH7aRcNDS6Xcvspndw0QEXvGS1FHlHzczE/2Qm83YRcARj3c+VNtttF0+FzAxBa
	mT66ycGrWOYfsRPTXoVYIrDdl9oBTsE64Gb9xPDxIiDdHxLPERF31nMyeYpYiUPkdWcITGk2I8S
	5hQlXi9yFyCZuJXn7JHL1XuaZfc5b/LsSGXaSbEgBxrEgCN/zGCyFQzT6SCkazo1pvDb+OEuuOM
	dPjaYX0gzy8CMFjmt57qDEHn1tmQnlBcBxw9zMnhWT73jLfBpOQ7Tr0tgxvHLMR4ER/Y680rPWz
	OOJx3XqGeKXPWOGzMOtzpn5io5GQrzROAAlxJnM7nRsMiAnAo/2jhF08+6LkKf5Us0RR7IuKuMJ
	50DG/g0G/5ZAB71iC0EPXdHxZKmJIDXUa7XPangEglz9pKeVTROgFVV9dGjptLCeroNDGWxet8L
	w==
X-Received: by 2002:a05:690e:c43:b0:65c:1302:ee48 with SMTP id 956f58d0204a3-65e2286ae3cmr9596405d50.54.1778965447840;
        Sat, 16 May 2026 14:04:07 -0700 (PDT)
Received: from localhost (23-116-43-216.lightspeed.sntcca.sbcglobal.net. [23.116.43.216])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-65e0d86bc02sm4342876d50.4.2026.05.16.14.04.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 May 2026 14:04:07 -0700 (PDT)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
To: sj@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	ravis.opensrc@gmail.com
Subject: [RFC PATCH 3/5] mm/damon/core: floor effective quota size at minimum region size
Date: Sat, 16 May 2026 14:03:55 -0700
Message-ID: <20260516210357.2247-4-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260516210357.2247-1-ravis.opensrc@gmail.com>
References: <20260516210357.2247-1-ravis.opensrc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CAC73140011
X-Stat-Signature: ahs8axhpkxfxsk7o3h33a9hxycwoqbz5
X-Rspam-User: 
X-HE-Tag: 1778965448-524183
X-HE-Meta: U2FsdGVkX1+e/VbtiDVLOKYEzkVrtog+2+Tj1eW6Ut3cL7U+3w6ax7M1lXx2u7tOoiwL+Ca2dI05mPSYtjm5Mg3ccHjKinoQuKcKCJUYEiy2hU+cZEnPCJHjipuj84Qb5+UVFLYvd6SYkmUZwyQEUP8jtpdlktg9JAKmt9VpjJUhmtSwJ+93VLpJMA3Zm6M8Qukb/H3JL6BTJr6qBJQDdMRlYK3PhY+2Sg7EUg0pHA3TTZdybWXnOBz9mmp0FLeMZSEL0zmGWa+HSoVeSgBX/m3+ALEheDLUPcEEF0kBGIByi6EfeYjp171qCDrwy7UPRxdZc2hcTxEdOtZKuMLgmgiX0iEH6gh9OuVpk2JfPKQq2vQd53jSP4FhO3AOgVRcMYqN5/BLQXoZb1lAbRLrOvovWOBkjfS7tmoiNhnaJHS+FpY4UedqDgC2Fw/LJxAVvBfoUbqRFHxi2fyNzr0lHTq7w6++Zbe9Y+ZJnen0L3QiFZGhl5ETbZjWSAwuG53kPV3xaMxktdUU2PVrY7H2jl7lH13e8/nc87hrIuNcOjMBKecCVIuVo5ic4UmDTKqMn8wBIQeoG7iJdpqZYMahAAHEhQvF6Lwjhq+rW7763Bw47nhza1aMQxWhqpuZ+p32YtXwJhZsDQQ5kyeY3niKRw8xRTiIq9YzSELnUfGedU1a2axKdf3jN+QzHL6ylIJmwKD4LuElVprgItCNy3DIHYWkknyB1uAAosV0iVkNtd11EsbzEdJi/9Q/zRNnvgvQMWiyJTy6n3BmEc5picaW9mYKfPAzcTpriagleeABY5BCKsltVv4j9urBsAO/rPghyyz1TufurU99wXetGNM+FC6seUe/HnfVzcTo3KdaXFJyW11YJSopFo1dy4dXdZmsYYNuytneiV8yMIubqzfJhebmryfKsgdgXsqsEqKdQ9WL0kYjNSBGtujIbcQP3jyvUjYa0MJHPRdQacZGPDO
 Fd72idoD
 4Bj9Y0UzmjoxPktbu1b7TP6jESDttg430J0xFvPSjoARhfgKmP95BMK3l3+4TmPse0q5UotcBdnMHp5q9cnJbZVkMwcjA9Y/xPnH5avzKxZ1UJ/3c0C0QolZ7Li82+dQ6/OfWQxfw6OTj24Zq9TX+KL8LQ6BYb86QJA7gfRoXsSownuADj48VWRE/f7hnn4IL9Fek1sH8Ztii0b5qdgYNZdgMBT8ZYnvfiJPws/R0v6pBLrMNOjnCeyFOFJMDRW7G+gQ9/80VLOyAe0+hMkA5sZX+oEOuZXIXcIpPjN18mFgy2wNNJSEdXJN10BnSkp2nuHyTWxa/sKeANYOrPfSV/OQa/BOvTpdJDp//WbQBQ3jq8D34qYcLYNMPAfcP38lbvTJCHjGB3oCWp/YJcUmWPyh8sDxNCh4gO0CuJjpFt04S6uONrkyltlZTZBEtBZ43igm35KyCG2pB8Pdkn/jun5kEee5y4OL/Sb6y7WF+92viVdwuileeiJi6kBYXsA0X22cYkeYAlmmPl2MmjsESacQsOufX/OX9/0arSooG6M91attjIrQBKm7zJUPZqGAUn2L8ulClxLutbKDaA8kqPvadcge7i0K+4ZDGP2GvhsaqaXDNN9DDu+8Egpmbn66CygPU9Xa8fMa4yS287Wrokg7En/Z35mC7CZfPNVpcPr2pLm8vbJwSpmoQ3EbbCXizWm8yjtAsOqx2R9e7Ukvds0RCkQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The CONSIST quota goal tuner initializes esz_bp to 0, producing an
effective quota size (esz) of 1 byte on the first tick.
damos_quota_is_full() rejects all regions when esz < min_region_sz
(default PAGE_SIZE = 4096), so no regions can be tried and no
feedback reaches the tuner — a bootstrapping deadlock.

Floor esz at ctx->min_region_sz after the tuner computes it, guarded
by an esz != 0 check.  The guard preserves the temporal tuner's
intentional stop behavior: when score >= 10000 (goal met), temporal
sets esz_bp = 0 to halt migration; the floor must not override that.

Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 mm/damon/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index fd1db234ca304..d33c4360cbd60 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2650,6 +2650,10 @@ static void damos_set_effective_quota(struct damon_ctx *ctx, struct damos *s)
 		esz = quota->esz_bp / 10000;
 	}
 
+	/* avoid cold-start deadlock, but respect tuner stop signal (esz=0) */
+	if (esz)
+		esz = max_t(unsigned long, esz, ctx->min_region_sz);
+
 	if (quota->ms) {
 		if (quota->total_charged_ns)
 			throughput = mult_frac(quota->total_charged_sz,
-- 
2.43.0


