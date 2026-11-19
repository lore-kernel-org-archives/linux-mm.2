Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F049D606C445
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 08:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cvHspsQE
Received: by kanga.kvack.org (Postfix)
	id 7EAF66B05D2; Thu, 19 Nov 2026 03:41:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C12E6B05D3; Thu, 19 Nov 2026 03:41:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FEC06B05D4; Thu, 19 Nov 2026 03:41:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 413906B05D2
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 03:41:27 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B155E4099D
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:41:26 +0000 (UTC)
X-FDA: 85451224572.05.1594F15
Received: from mail-pj2-f9.google.com (mail-pj2-f9.google.com [74.125.227.137])
	by imf14.hostedemail.com (Postfix) with ESMTP id CD5A1100006
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:41:24 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=cvHspsQE;
	spf=pass (imf14.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.137 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795077684;
	b=qOYvkgnqD0zDajSFOpCcGzp6Ose4qAdN9qojxNvwq76yDvnqL4NamgQfcrv4LDfQBO8JnP
	rlmPoWD9o7nsVsbFrmty0SdN+Cn+rc+7pyaRTUMzc+QczlI12/3eTCIsXADbHhs9yS8Bz3
	yy9IRvq7QLwFajbkO8GCeMLbr5sygoM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795077684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6nZw4QgVcRxFqgBQwwralrt/ynUXiZOfhv4EehzkIqE=;
	b=ulfn/jTXWBId6II5aurkJxL8tAwT1EJReXJ0hJyEp5IgZBzYtPMZMSZvPiIM6/ArkhurSg
	7WtOvwAqYReatjPG5Ks6iEECO0AkeTJ3yOajs8BWi+PUNbxI27QPDnZE+WkXdU9yh59CSk
	j1dKLVgXTw5m+E+cztch0VXkT3TeS3M=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=cvHspsQE;
	spf=pass (imf14.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.137 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f9.google.com with SMTP id d9443c01a7336-2e97ddaf3c4so4633215ad.1
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 00:41:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795077683; x=1795682483; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=6nZw4QgVcRxFqgBQwwralrt/ynUXiZOfhv4EehzkIqE=;
        b=cvHspsQERWNDO+25c8G5M4YIYJsK3Bd1uMuTcqjboK0/AoVcA0mltpmaS5/WkEq4u8
         tXtt0TGy6wukfkT6G95mcxbEqXzOdr81/K4xzpucxo6ZZ/ND4D1/nfewygR8aaJ5ytpz
         CnsfEfr7FvecI5YUdLYG2Z0KjOWM/zrAUUl2DgSRa+RQqz8ZDTbJ7wO6QRWa43k3kJgG
         tr7SZdVnNFLTStSaCZ3V7hi3O/Nu6oNkQN7dG4vamhJPyAYmQPqm1NpA6ZCNlj7fwhZE
         YNNoXP8X4De+5ajDfRbjxVcGoOZJmHX9jEGb7M8rN3Y5S/B/Ju9eooa7qIm/OJty2nAA
         6vVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795077683; x=1795682483;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=6nZw4QgVcRxFqgBQwwralrt/ynUXiZOfhv4EehzkIqE=;
        b=J0gAIdRGyz3V7td2Y6SJWtWFNAvULZxHoVSxEDo7LafgINO2LlLt+v3IPNrv9i4jag
         Lim21BswJ6xThsWm97I7Dc6BUdgkyswn21rDsJ1wgXms4b9r7fPmNlBw7fne6Zc3MpSi
         CAH8vCNR/rlYox+ABKHqsHmlbmk4k2BFI27DvX11H2JPoe7IlmiVytL5CjGLyd7XrsBv
         AMkJQCcpR0PyeJaJJ4RgSk0QGWXirkL53220EGhfNHN55tU9BJFBDOBv00KfGTeU1YdU
         TTasxiTwdEhV4V9aT+dpYWTooIOVmZT2KzcBWeNNCN+xIVOQJTZlaeKBDttxSenENpyP
         SLlg==
X-Forwarded-Encrypted: i=1; AL+hErFH4RklFuJOmj44gs21wQUwRIM7jedIgdSPPvYwthitFieLT5hDshAj6Y4nu8ebEoBY0vhohT8gKQ==@kvack.org
X-Gm-Message-State: APuU4Z8ts+aZJO38f8NHFRLyAsH+TgUkJgrMvf2vutGvMkZ7HtKA+xXF
	/xlypebwg8qXjG49KCSYikt4R0hDq5/m3jvgwddzddoX+shtJbyBc/FN
X-Gm-Gg: AZFdTZcgSGGhi7Q22r0HzJrUnuLxX0fMyJNBnLApI62xu/Xeoir411A2cMQ5FuiADqr
	W95w7Fa6NN3pvrxKmoKMEEgei6OJPH2x8o8Z0CKJqcC+ceXWcfNww7nb5mpJ05vtdxtU9wjaHQ+
	wDdg13Bzb7CHIXHny4afaMHskqeUSM5FvPpUgnWvP35j/3b+ymsAvfEQGdhGrj5r3LUZke60u3O
	D04VSo6IkI3f2MRdQ4hdO+/mL5jf8KAXFFM3OvFj7pHQ+tR5uWuGUw7daaM0di2mYC79Q3g4/XY
	XgrjgO7goiZtS1mzj+Z9MId+Y65pm/f5hQD7jIsLF4UANgnM25gXqEJoTAEiwQG9bD8OYsRaMMC
	fSaS8Z4Wbto3nxXf+LPucrEyPdJNhoilICcm9ER89zJ1F4WfNT6oGxP7WwSt8rUEJl9bSZUfs5O
	dxrRH84ZGgcZPlnCkIhJ2Aw8a3gKwX8y/wfqVEwRkCHHITahzjGez2louf+XgK9dBheCisn+Wfg
	fatFzlxzBiGCbd56143e69jQPOJZw/mAZmvkpnMKPfiV3dAjgBU+R5l6JcNO6gbPe4pO0Kemj6V
	rtGA/HKuPNaE6GEBVj+3Nqi+dHLqxCNZb9Z5sUrCxcKirVRlLuG7eJWBdtkz87GK2g5/oo+3UXv
	8yqAi+2VCTWsXnB9Sp7e5ba4Av1oGR+P/h8Jr3dWRm2OXK6F2BRiAwKNwavDJlFA=
X-Received: by 2002:a17:90b:4a8d:b0:3b3:b417:607e with SMTP id 98e67ed59e1d1-3b3d07a4c86mr5491576a91.44.1795077683292;
        Thu, 19 Nov 2026 00:41:23 -0800 (PST)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b402aa8555sm933646a91.3.2026.11.19.00.41.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 00:41:23 -0800 (PST)
From: Aveline Noir <jm5905938@gmail.com>
Date: Thu, 19 Nov 2026 19:39:24 +1100
Subject: [PATCH] mm/damon/core: skip apply_probes() when no probes are
 installed
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261119-damon-skip-empty-probes-20261119-v1-1-ec3e81c1f26b@gmail.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/3WNyw6CMBBFf4XM2kkohoL+imHRxyjVtDQdfIXw7
 7aasHN5bm7OWYApOWI4Vgskejh2U8ggdhWYUYULobOZoakbKYQ4oFV+Csg3F5F8nN8Y06SJcTu
 0vbSdFF3f7mvImpjo7F7fxGn4Md/1lcxcvOWhFRPqpIIZy/Sv4D0Gem4hWNcPn/85qL4AAAA=
X-Change-ID: 20261119-damon-skip-empty-probes-20261119-586d76178530
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CD5A1100006
X-Rspam-User:
X-Stat-Signature: 13y7y9kdswp7pziczuo8t6k4shpxjouj
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795077684-628699
X-HE-Meta: U2FsdGVkX19o+oQ2Ym8/WxXUYRhJu6sy136+uDrf2vcqy+LpUnECPXlLnSaPqpd6WScgfm3YrrxbBuVXALX+nZhRtMFZevTFpbkDKzqkQ7gvqOS3/0jaOVwC9L6V373F5AdvfRaXJarszdf1+2wVQW7MVNU7uYIw7mPJAWPqEnjPH3G2Xcne0hjiSXabt1m51DTG8Gn+fo8KsAGeuO9UzEGprDw6SRCLvQPjeTFCHLaGULkjWTB3IBI+qmHWKN6rVmbLBbqI1lsWV3GMo0Xo/TMGH82CcRvZPDk4fbtbsqacVOOiUJe4HW+VhhXdTH8WMxMeyY1CaBYKFW9oymvTT+KKep8UxrNTVmVP2zRdqy2gVmsgXwebLtua9Mwp+3KlHCmwirqDK0Kj4MQMSB+GP0rmpm+K/3QC7svlFJzFb4B8HU527ZwuIS641lP53jYLMGqyg9la8X1kYJGnFFJbE3/Y5md+lUliCnj6qhnWEAYgJPGSO5CDlAsTwjOGPQe1dMvW5E9Ts6r39fpWJ4zCsX6ko0MHkrqlLkxDG1Ls3YiQOE19p7AYfDM4lsGunK4sk5RkBejD3oRNbRJvmewM5EiDxD8IWOq6ONv6gRODBc7nSnnGDkGdBo+4HirYYilLu/e2fRUVqfM4scdvrR9pqMrAqkFs0nZPFnxlLY4k2evB4dUcJbJAv45/6tVuuSVh8wkOoO322DR9azq+5Bmq4bhfQWSrC9Exhlq6fXgbDIAc63OmyfESvTgSB/4wqr3NvIu8CDXo3aXaiJHxrBJQyR9AfoqUJSvqtabYrsdhgbKsJNuLNoVG0wLaDeUa9Vvwxkk4asiHuTExiH70Tz23aKMotGnPtlRHNy/ZNJEavfpo4oIaE26u3VpXma2bS3vTFSoQwSvDl2ySWsau8ljC1QgiHLH4u52JVF5PQ0YKX5v65Sukq3uEwdvnC9XPK0huOc03DQjWYhzjnFSydTu
 RBPsstle
 Lg5+jM1Toj7omnFgrCbY9UmhElz7zR+pCKgcVSg625ypLejXdQdu/RHguWI0Ovq2Ev6lZzbwkTNQVhvo0Mo+EUxKIAcfv4OiSiXyUTojZfTfJRuZ2jTOsE/6Zv8VbGVPCQ8rJgocI5Gg0Me9AmzzKEk04vDTSW7g+PmsBxmaeSVI2gMBAdPE4k0qrb1vHbzZtF0YgI9uKKOWVOjE8/THq8yFDCnEp5BSzrX0jkedbwYk1ui3ksHchhvOdLwZ06mR/ZVJkR1YenUHwKWhK15cug1VWNx5xCkQfSd/4Gmhl3ZZM2MhzSlBdDDxMCKtIhfd4LDO7mGeOWfkdxI3iBGmUwMAwfUkfpiPFQNcO/v9ClFNnosrn5ZPPog80d0r93Q7wGvSAhXyeww1s8Pkk5xOG48rs0qemSHbaJuJKA8DRaFGq7ZFXHn3x5+UPEmVKifnopkufBYpvTeVK7xFs6apC7Dm9lTNns32mJSOHbTS+NBn9x7YeRygX5wiGyQQ4X9biwgJjcgtfjs1ss51Aq1BPu7qo+GUj+Q6tSc6d2Zj6zy6QxkEJSsw/uovdUliqFxnplBfoCk3aorMR3rk1OJiguKww42FBH04diz5tv4wyG22CDZnLGYuBWYIUbOdfcTec0MpnQzSov3aCEraRtyvlc7poEADSh0YYgMrSEwEITvbrCZAx3ACDlYk4X7nThZZtHoGxUTmd6aDM3XulMCfN6mKAIHLxskxz4SG/8ur70SfzxdM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

While measuring vaddr monitoring overhead, I noticed that kdamond calls
apply_probes() every sampling interval even if no probes are installed.
The vaddr callback walks the page tables for each region's sample, and
paddr looks up a folio and takes a reference if it can. There are no
probe hits to count in either case.

Skip the callback when the probe list is empty. Ordinary access checks
still run, and installed probes with zero weight are still applied.

Signed-off-by: Aveline Noir <jm5905938@gmail.com>
---
Tested in x86-64 KVM on 067c5c24cef2. All fvaddr probe checks passed.
---
 mm/damon/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 986404b547eb..df711b6a8d03 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -4089,7 +4089,7 @@ static int kdamond_fn(void *data)
 
 		if (!access_check_disabled && ctx->ops.check_accesses)
 			max_merge_score = ctx->ops.check_accesses(ctx);
-		if (ctx->ops.apply_probes) {
+		if (ctx->ops.apply_probes && !list_empty(&ctx->probes)) {
 			if (time_after_eq(ctx->passed_sample_intervals,
 						next_aggregation_sis) &&
 					access_check_disabled)

---
base-commit: 9f004372ebeb18fdeb699f9880a0e472df90135b
change-id: 20261119-damon-skip-empty-probes-20261119-586d76178530

-- 
Thanks,
Aveline Noir


