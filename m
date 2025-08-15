Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09596CA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 09:41:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A52958E01E4; Fri, 15 Aug 2025 05:41:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A03258E0002; Fri, 15 Aug 2025 05:41:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 919508E01E4; Fri, 15 Aug 2025 05:41:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7F9BF8E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 05:41:11 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2AFED1DCF5E
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:41:11 +0000 (UTC)
X-FDA: 83778498342.21.DC41F67
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf18.hostedemail.com (Postfix) with ESMTP id 596BD1C0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:41:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=av4EdJGd;
	spf=pass (imf18.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755250869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=qnCA1VM+asfuHpYmdzDNHn/x6x6IZtGlY+YAl43FuEQ=;
	b=sq+qcAHlBHAidGpsWxJ+l4FJOggbhf2DexyScl6q9za6EebvsQmVlOSZ/D9Vy3dIz7G2c+
	3EjV4ukfDUlq/BaFL7vvyLZ6Ufc/k/VhhzYd1YOruxl20FNLm3GH7V8svIONWPu8j9NRnL
	SdChB70cIVnkPhZd7I4x0v1nggyWbek=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755250869; a=rsa-sha256;
	cv=none;
	b=Z8t0VFDZ+EhFGnmluZ76xUHSq0G8VG+x6RrFHTqglE8YPRGN2iPhSplzpDu7jOTS/7+2Oj
	gWPrJpL95ONqcUkuIUHheYWaRsmjQuI8smnF2fxpnFkfqZRZ8M9xvw8x8Ym/k7miucWVsa
	8jy7A7hiweOMFP4imlCo4+piUxAxleM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=av4EdJGd;
	spf=pass (imf18.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-32326e67c95so2328973a91.3
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 02:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755250868; x=1755855668; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qnCA1VM+asfuHpYmdzDNHn/x6x6IZtGlY+YAl43FuEQ=;
        b=av4EdJGdirznLmHLTl1TvVGaJYqFwc9DE1c/OSlNGhnQKtd4hVcso0ZCPpH1WkgJUq
         gNWhRwDlCwh+wHbb+7LKSfEMd33DooHacTgPdsPXAUoHJ0uenpcRMFMKBGDRtwwwYK6v
         SPyZDM05WOPW4+X4BEsvtZtkxrB6H37Q6R9HE3eUw6wSGdlqyWhfF925PGAOZfyCDptO
         iq8AAprjmel31lu2fL7Y2OoQFCjX9AzfneZ+UGy96cV1YlM3NcdqhvEAGjBaGz81cwN3
         EeBmbJ1kHouB7qjvLvkEqGURTfz84eejd4LATCCfssLb4dz2cK846UDPhoMkzzC6h0Rk
         rIBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755250868; x=1755855668;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qnCA1VM+asfuHpYmdzDNHn/x6x6IZtGlY+YAl43FuEQ=;
        b=D1J5jQhJ0sE8qhxwfEWk6Y+XI3qQmpcg1+uoqBZiowkszj3bRHXPBBZ65XfxXQDzsw
         ZeXwkGHa37gW4BEiAEzPw0uwblRGO4f6NG4poqYt+o2D/B7xbTa3XO5WMgkVCt9g9ahv
         /lWKzgVM8QSzssqq0LTkBo4jmI3yuWf5B0eNKQrhWCe9RAghE1IB/WKzOHt+i2YTlspL
         ge8roLs638++siTjpQoJDegJThTvoW0wsZ/RcF46ZVKLlCkSULJBcMj7dbMOSwrZFzAp
         y7y2aYUuxswHra5MTrSB/detiy4BfqV1+guX7ySitbqDloPy26I8ud4OUA1mg//HQGZx
         rE3A==
X-Forwarded-Encrypted: i=1; AJvYcCUjoAuKCzI6sgsVwk2bijibgJ7zDTxy2SDQm4pFhBVR5oax1FfBtHhKwD6PXwFxEv5RoQrVdhy2Cg==@kvack.org
X-Gm-Message-State: AOJu0YyfiKrQkzFHZsSCBaE+1/6JijZ1uq/drV0QhTifMJfxhUc9CEu9
	B0exospu0N5TCEwgw3cXc2+eg4bDPekxk1AGPfl562a1valuB+CWnpaw
X-Gm-Gg: ASbGncvCR0xKx3EAlEWLZMXDzMQrUzCAPJIJhyf4dy49EqlQTOWs6ZJ/Mqgej3BS1Lp
	evmrwo1kyh+Bc6G4MgQxCIdcw4WIemYnaQfkS2VrKGclsgfybxODT+D6FGCbELclIq3X2oltZlF
	HiP7DzAvJFFVpc8l+XraPknbWKy0YClHm5tSsP6JF6w61P6CT74BdObZGmp3JSgHd0AkWw3jmtY
	tIsDVow2l33/HAxVKK+hyI6kyXle3ubTKocKJKW9xY+I8DqO0+20NANt/RbVnSA9YBhnfpst9A1
	K6efAxrkql/7e91eyiv2S9lOm+7CPRKj8fif4bITwDgYY3m0clpa/Ja9QVJxKq8d6BliDkbfy/p
	nLEcbgzrMHufEMiOhal1LS+wBnC4=
X-Google-Smtp-Source: AGHT+IGi5VjkT2Rhq7RxXW3lFjC5bhu8alKN+idZM1ypx/MffzauBiNSkCHC63Sk7HA0r9Db5WVhTg==
X-Received: by 2002:a17:90a:dfc4:b0:31f:20a:b549 with SMTP id 98e67ed59e1d1-32341df9214mr2188860a91.7.1755250868037;
        Fri, 15 Aug 2025 02:41:08 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b472d73a736sm812448a12.29.2025.08.15.02.41.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 02:41:07 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: sj@kernel.org,
	honggyu.kim@sk.com
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: [PATCH] mm/damon/core: fix damos_commit_filter not changing allow
Date: Fri, 15 Aug 2025 18:40:59 +0900
Message-ID: <20250815094059.133769-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 596BD1C0002
X-Stat-Signature: k5aeem3jebkid9gqfbtwicqc13pmjxy6
X-HE-Tag: 1755250869-821620
X-HE-Meta: U2FsdGVkX18NlbPTjBY48U1sG++f09AK5btX9bbAtrBTm9sJs+6+js5hdTXPYoUiEE2D+QYi9JitsGQXSKlcrxZWxBVkzvdThmPRB/NNsJb+psxBmZuTNqOi/ciUk/Xkkd+uv35rZo3rf9IdOonPif8LFndEr/U/gK47v/hVHPpPZ5+U8cTcPlk6AjiVVduTM9nyj/NrZqjZ/JbbkMmubsVJv5XBnLp8UeKj1GG3xK7RHfSpU1yL/KG2VZIGhgx6n88ttxvfmKJ0GQRaZsFf7IqiROBdOEYrjgrRJpCnQBGNuBAkY1nQ7KpV18b0az11vS46tEBgJkLVf0AQURZdAbC0bbRa0FMNlPq5NCjG7fbdcDYT27yzuwG2+O+8E7m0FQUiJZVjNHS9dbab+ChLY0UBWNuuq5NX7j57WlIhl6Ngt3Agp4Lc1FwACFQqi106LFqO7o4Co/bSlqITYs8yu/KAxXQs/fZs8SHMFUCyCpc7ENVU/xtmnWxWXy+doLBzvlU6xD9Le7WF5B4hu3rqun2LR94+fhQU7r/fJEfSfq5PVAUzAACiSmK27b4WX/txq4zG0Z28kaMXSaIc808srlC/RxJmGz8e+7ng5EcWBwTS4wY1HD5/t5n0gEcuWANiQnd4ufbAtVfuqOF8aUUD98Iup1hhibVWq7t/vnEgPk1OtjculA5Y5bYxTrT+mjOUQgom80ZrEkffS+HR/evMq/t2ZiYElKaq3PYBi1vmTdC2KSDaMu3TltDvasPq/Dsb+2msvS3H1IyI/F1HSN+MyZHntGNuOj8WUCVFh92pBe2D4xetsc6KlEPTnfS8udmEv4aTXqlU4gJK060mKIQHvh60nlkRvyn9sK4VKMcpTYHVqjTbg+Byl891vl2HEpFOwvMthlx/uBAzoM+hLAFXdgR/iUpzuu2VO5MbOJ1REqfZyb9W985FTZFzWc9itN8CJh4sWMoXblGHUhFA34J
 G2rMrq7y
 z4PotAHypZMjTqaYjpP4vBCM3DCv0mffmUkIAcHuIjRXxCQt5nJXODc7QPzGL2y17xfcgGhT++bGrP+4F+cFGnCTK1a/MMTifkAt8zzzU55jDzVC2oDMMn4kDl6JFjuBOzUb7rS08OzO2Y1qcD6en8QTREktXlgel417Gqqp/H3WAvpaXES4gouGKB5WQMRHjiockeSb99VqpcuRKgZCxlDKK+3AqQyAc61q+oy6uOPV36BjDtY2r78awGX7t88gvdontoMWekeBVh/ZRuEl+VqQxjFX/x5vWG2bgRGCfxlPr9BcAT38K/BPpxrL6asLFVA4Kros+Azfsld/3NgRzrbjFNb7/1zpDylssHhAlMAQZ4AfIChC3tn/XhEFoLrtqWejVAmwuIeo+8lTzqnTpB7MFbJC0xMGLQjd5Eb6R9Ip/7kxB5lZcIs43JVDZUGN/FlPV8ERHfwET7y75QMCOJT26Ob44G007xPrW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Current damos_commit_filter() not persist allow value of filter. As a
result, changing allow value of filter and commit doesn't change
allow value.

Add the missing allow value update, so commit filter now persist changing
allow value well.

Fixes: 9cb3d0b9dfce ("mm/damon/core: implement DAMON context commit function")
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
While fixing kselftest, I found another bug and succeeded in
reproducing. I think this patch is similar with previeous patch [1].
Also instead of sending patch with test, should we check which is better:
a seperate patch or patchset?

[1] https://lore.kernel.org/damon/20250808220815.49644-1-sj@kernel.org/

---
 mm/damon/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 19c8f01fc81a..cb41fddca78c 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -900,6 +900,7 @@ static void damos_commit_filter(
 {
 	dst->type = src->type;
 	dst->matching = src->matching;
+	dst->allow = src->allow;
 	damos_commit_filter_arg(dst, src);
 }
 
-- 
2.43.0


