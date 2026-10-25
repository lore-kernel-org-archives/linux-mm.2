Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76F6560A2607
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 02:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=D5LmZzR1
Received: by kanga.kvack.org (Postfix)
	id A89E36B05BA; Sat, 24 Oct 2026 22:19:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A60F56B05BB; Sat, 24 Oct 2026 22:19:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 950826B05BC; Sat, 24 Oct 2026 22:19:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6E97B6B05BA
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 22:19:02 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E9577160458
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 02:19:01 +0000 (UTC)
X-FDA: 85359540882.14.37D2AAD
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	by imf02.hostedemail.com (Postfix) with ESMTP id 371C980005
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 02:19:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=D5LmZzR1;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf02.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.51 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792894740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m/5b7j8QNKagV6FrH9MtDrAVHWRcPhsXwfAR70xb0Ug=;
	b=vN4UV7yDFxh/NbENjEaQauQYWrWPzV8lvEhW9rFBhmVJtc2K3armPnxZ/pW1fJRwlXrFj7
	6h9g7JFEskDj2EcUCfVdVZFEDGg+/4DuKiYk6AgWuieAuBnRkk9LNHvNcUedQit3P/y/hL
	yZke5N93CR//MVMr53fmKD0z8nNwgL0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=D5LmZzR1;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf02.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.51 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792894740;
	b=3syKgKqdCvvqzMFQ9tZXgk6wSWJGsHDR4muxmh2YCuitx9PnEvEHhXsjFnNoJGm9jRKxvb
	uhmtnwyuL0iyLYTum3OG3L/HKiGFtE3D7aRpqnV9jrpRRRBbmkjnykTaCbXLds+mJR2xBo
	hXxMo3FNPsd8lGxQgefRm6vCc4ZkztI=
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-18cdcfc05ffso2323945c88.1
        for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792894739; x=1793499539; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=m/5b7j8QNKagV6FrH9MtDrAVHWRcPhsXwfAR70xb0Ug=;
        b=D5LmZzR1QZ3K3R0pVoKLr2kVa2DXAEjIV8JeTYtFA78uVspqeUJU5Z5/e2lYn0LwfH
         i//ewn4hH9IR7rKvCvxZCHrMMGkx9LNKGo2r7b4mrj/Pl98tbaUoRiXTcYmdY29rQdO0
         3PyT3lTWedIT2UAPbYcSuLK1KjrOnBuyALDt8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792894739; x=1793499539;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=m/5b7j8QNKagV6FrH9MtDrAVHWRcPhsXwfAR70xb0Ug=;
        b=Ke6Jy57XfWvnb84/b23vZOXdhcLYZ43vtxpC1nXBCy8iNR5Dca0fLhIUo+pKMJHubp
         6Jgi3CvFax/z5XiXu5uOW9rQG1Bk/IDWpwljMAVaE2e7q5n1YD374oBVNkRfqTJN3e+4
         zSrFG5XdTdiSFwwU1ublxLzqvM+IV5lrm+f2vxfeE0pkjHV//XY6Wio/pvq6QTdt4go3
         GEXeiL9HGdD35egPj0kN5GaaBjG5R75oKqG6O3oyUPELzSUe0+mCahYDJ6KHpJfI7QyX
         JFyOx+wDQr2VjPCkAyepuRM48GEzcyDiOjl/0vDbTyTXwY0vP4oWirGhPxZl7eyYHuSy
         KJ3g==
X-Forwarded-Encrypted: i=1; AKwUvBwh1FkZ8OW43XQuTuDIE6wRbJ3pa3zUGMewcEvg0c4I4RF4dvZ2Gf3qm85xncwv06ltOBV1ysXSDA==@kvack.org
X-Gm-Message-State: AFq9FYLt6zxWf6yyr7njnUhG+TXEaKNMAHnuyPkJ5Tkb8EC4IFkfMdHV
	HMoV0mScLd1LlFw9cV1GV0iX8xteUuw6kwyXeuCVqA9eCicxuUInhU/C8n1ixLQ7WKByzP7J7BC
	A6xk=
X-Gm-Gg: AYBFou2nAel8ymSQpyS+iPbImnqKzZ0FK2u/oWqvv9FO4sJUpNmhx0FRSaIbE0qkHUL
	2KioAAC/jVm/Nbe5X7J1/X9gTgQBU7Vhk5+NrjJ6HJLb2lEs/yzROTlizrzjAhCqcFCW3YcPUze
	b/jGaOR4knhadQ3VeXIRYAQQRdJss2JNG5QKfPpd0lCedgSKn7sCBrC5MycAJFtPJn6C58kDq6B
	1oUuhFs+SxQpSLTxPFcHwfrUunjh3KN67S0amX4D4ub5GamiB57B+7O0fvZog5LXFtTeIzlTioN
	F/pf420sYGYHB45KT4nG04YXA0gJiCZmAD+jgi2lM3E5wuiXyaJ232o4/PeRKPj8myyHiZp0X7b
	6b9IEOvxA3fz+UnaLLRfH0jUgWHWXZN+Un1Z10tDyANN7RGdjbPfvgWMvfgh7Y6UvyDGx6n4NlB
	+68qyhfIjimRPt6G2OlNn/0672gI4oNtfJh+IWVrt3pvp6GSTJ0JRxRdzEr+K/x4hAjhviht9ZS
	0PGdYmlLGAGpYWLcVEpT6qygJ1BbZP93U8WA5Nw+aNvP/t8QY3M92o9knEg2A3g5iF6oJHKijx4
	VNSFF7oqoPpaUKzZuXlOFcCUbFQl/2AWs5ETQv0mrUL8
X-Received: by 2002:a05:7022:fa02:b0:166:37d2:3b72 with SMTP id a92af1059eb24-1993686f496mr5842218c88.27.1792894738959;
        Sat, 24 Oct 2026 19:18:58 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:9f87:66fc:8c85:11bb])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1989ff2ee5asm10387242c88.8.2026.10.24.19.18.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 19:18:58 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>,
	Barry Song <baohua@kernel.org>,
	Bo Zhang <zhangbo0325@gmail.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v7 06/15] zram: zstd: do not allocate empty C/D-dictionaries
Date: Sun, 25 Oct 2026 11:18:22 +0900
Message-ID: <20261025021839.1542805-7-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
In-Reply-To: <20261025021839.1542805-1-senozhatsky@chromium.org>
References: <20261025021839.1542805-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 371C980005
X-Stat-Signature: gtcwksme83owjnhb9hb81a11tzd439cg
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792894740-167577
X-HE-Meta: U2FsdGVkX1/KYcBs8e/yMZntPM7T2uCeoqQB627XICIBEdMRaF4Wd6gc1QMdbAgH2ClgwSGWsi0QeFkOddghaDzdR+rNHrFmbGoebBoTyLJ1ib1OyGTviFiyuZpWg2BUYN2VTVBBzafEJx6gmyHmz7TgjndpWFmeYnJx7G4FycCFB3MS2Fm37/dHd/KSk5t/BN4qrqvH3QflsKwf64/zKy+MeJ/+s8Vt6VUsKNWQKMSBx/Jutd6JvNYeV8K7Wr/t0nbyZ74l+RnrXqJCMeM9TCLJSwn1yetrIs5jIxBxDF4rKFm2jiaMLkjbn2/I3vUlK+wohsihXZeXAzWwxV9dVD7Ah86YjvKWeyTYrsqXKhMeM5oPEU1yoSnpOQsrC004Zd41P/VQsFyJgT5g7NQbLohaoxP8ZuHjW570WJH1TSatIf1J3ebPMpQqRIFtAhSEbSNL9LILcXE4f0Wdt/kw2L8TK5WuhuO2QLzJscBW66QeoTur1jno7RYgHBUcZeYSXb1j4xvDJPUMU4+Csvsn52NgbGnZG3qKVrf+A2dvuFBnsty7GOBsG2o804B+t7KYbqV/XBqS1KTgdUyMjSesUJA3kOzv3wMp8uvb+lONuY/fo3omP7pi6V3KnizXq43jURLZSIgKcYoqtgL6F5jgLJaK+UiMcKSWAfurELIhTuE5x1TXD7AL1zyxs/mGYm5D0QHbPGFSC09UKyHSd5Ebvb7Kfhag+K3GjT9ubxITEL+ZpZZYaN+X9KZL5vgZJtKVzUA/4zrCAeE9+NedcPedl5yyZGUMyX159hnCWWWekWaoKtQYVxZb8LcSXS7xf9IdOQqCzqn3fOnVmOcdj7/CKl2eeve1G2a2wn115ZIlJA9tf1mbBiGK0IT40C+IkoKceRTbpiOHUDG+/W3Qikcmp6TrA1R8m2b+RDtGGJLfxa1iDQatRkRxQ86uQ0mJFiABzU+Bll+UQyth5crllyI
 5m1M2g1W
 8iXEetntn8Q2Bua3zkb2O7Ys/T9cgUo4m1a1cxZqlCK6ojWpuqFXYokBidJMZ5+uzrfpQmQAXFHHRIXH0k7tKSyxvA8Zdvi0zy14dKIXmmFozJR+WiUknhVsubLt/e9w0yzSMj1G5NZ55uxu+tudXESCnRbwQvPSqH+PDNs3XHeLS1zIM8i5pFnKM1ymXJAeOqotR2k3m3uC3kfDZE4nCVxhQE67sa7apDC3xjpYZ8FyyM/tfEBzNjkcyVQaKPO1q9rUHJaE1D+Oy0TBy3vXzSTfd8ytmHz5I0E6WIKt3RqRQU9M2LxpV7chHpw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Do not zstd_create_cdict_byreference() / zstd_create_ddict_byreference()
C/D dictionaries when no dictionary was provided in the first place,
because zstd still allocates internal memory for such calls (~96 KB at
default level 3, and ~160 KB at levels 9+ on x86_64).

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/backend_zstd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/block/zram/backend_zstd.c b/drivers/block/zram/backend_zstd.c
index 127976b5455b..b367049f131d 100644
--- a/drivers/block/zram/backend_zstd.c
+++ b/drivers/block/zram/backend_zstd.c
@@ -76,6 +76,9 @@ static int zstd_setup_params(struct zcomp_params *params)
 	prm = zstd_get_cparams(params->level, PAGE_SIZE,
 			       params->dict_sz);
 
+	if (!params->dict || !params->dict_sz)
+		return 0;
+
 	zp->cdict = zstd_create_cdict_byreference(params->dict,
 						  params->dict_sz,
 						  prm,
-- 
2.56.0.257.gf7497c7d27-goog


