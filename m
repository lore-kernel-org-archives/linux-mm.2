Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6ADDAFD065C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 08:43:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E4106B0089; Wed, 11 Mar 2026 04:43:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98EEB6B008A; Wed, 11 Mar 2026 04:43:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 871816B008C; Wed, 11 Mar 2026 04:43:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 64F3F6B0089
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 04:43:35 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0804A13B4DC
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:43:35 +0000 (UTC)
X-FDA: 84533143590.12.83C2367
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2C939A0004
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:43:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=cMKC+mH9;
	spf=pass (imf15.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773218613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=opLhtgMBHI5PHBJ/QKK1QZfBQHPqKZenu2IgsOh/g3c=;
	b=yLUY8dU9quy0lGHDKSImy+lxpJ5F0cgKowbphj2zpClI6syFgyf1OJa7sTVKQTjptn00gV
	FiX7gzuLsikR3g6dLY7gPHNV7YiGRuqh727/LaSydXeZWPUPNUtPh3CHUfSASKyWW9Mz2k
	Qss6A8FdRygdKtrS5OZO/Ul+ASlW8sY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=cMKC+mH9;
	spf=pass (imf15.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773218613; a=rsa-sha256;
	cv=none;
	b=G2VzoEA0Prvvzdmn8po/3GPfR6ypuhPIHUxFQ0sUgGDhLwG9uIXS24kLLVUZg+SP0U8l+c
	9YRD//bILHrvdJB0i6HY+f8+FXO/or1WqB0tFKiQtb7TNUTmyfy6IxG8/bAkvOotqnCb/Z
	WORFL6LsgQgQ+61tX4gjl0O8LdhL+v4=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ae43042ea7so115667455ad.0
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 01:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1773218612; x=1773823412; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=opLhtgMBHI5PHBJ/QKK1QZfBQHPqKZenu2IgsOh/g3c=;
        b=cMKC+mH9vIR12S1sANsalGbOjN3kOOzeht2ps8anDeHHjjHCOE5JfI9yR5Hb+OHnxO
         oycMLjlkLqv8H/S2fqSxJzhRw+XQmFX/2KDoHm/ep8P6lvEAxvSsB8+9CRghAJOaeZgi
         //PuxYiY96ry99vKsEl/+iGNV12VjC6ksFjg0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773218612; x=1773823412;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=opLhtgMBHI5PHBJ/QKK1QZfBQHPqKZenu2IgsOh/g3c=;
        b=HRrkBI0IZ0M+nz7IVJoRm9NbmfwrJpih+0HD+1vg+gXkwQmCSHndN+MNFdiskRfnPC
         xemSl6BdpR6fdZnaCzq//ztDNJEtpUFUDaXGB9n/LJ+QDVboz6Y1/vEXditGNUg4q/W7
         kgj6USwAmt1qf8bmwrLls4ragCrmRTIbXK4VIiXdKHF4qUJid19dtOee99QPwY0zyY6R
         UJY47S9MZzOMUyIW1HDgIjMIJbfkN+825t2k0QKyjSwe8TqGrYC92/Uzgj4DwY4TuGk6
         eOSdS1JbkxNzBFq7Hn4sEgCMKOApZ3YmXYcKLTWqaFKJjH54uTDv+m2dFICkfof31noK
         n50Q==
X-Forwarded-Encrypted: i=1; AJvYcCUVnVs4FXeQBJUcSFXT1CsB+6Gn8jXVtrchunKTnHzyLGzZffdLwF3fOqbc+bDEaTGoofOwHEswnA==@kvack.org
X-Gm-Message-State: AOJu0YxqHWMHyHf1NqYUuPK3Dvv8Cp0tWwOkz/l0088rzTgLK603nyLs
	3Q+EvzXpjD/ChF3x1cHlEMdqRz2GFnpoXZYThvotdvNfZpnaJ0BNc11iJu6pDHamPA==
X-Gm-Gg: ATEYQzwGvTk4GJJFExtzeXn/xsE+zKsUMlx58u1CJNpTBTOlugrLS/wHv7RL8ocvbyO
	j8VaTa+dTks9VXFg6c6qygBBKd+YHiSydt8IalBjnaQdM+LayqC5RBlKH5AWglUCW9eNh1zgxKc
	f9OGGuJjGafNHIFGOwldoERbDRjU5XE1jZuTQ6dgHApY5WMwxOEo0k57T7WHIQX6w2aED+gS/g3
	Ux2s6UgvNgd2h1s9lYBCzdNfEU3tKxsvN7TaPbTEEDxFzy9eRTdQ4qocQQF3FFh1rWeUHZDkHwn
	mvvOuNejVrXJub5ka2yn5zXwWF9jYCf7CwnJE/3BJ+CayAWKcXg5vzFxjO010WMIcdRjOmaWmK5
	Ji6hFodPN2u2i7Osni92eqbeyh+FekOwL/dWgfS7jPGaZLg4k/uqwbFT3wJBafmEzv46Z7YQNcB
	q3WJuJ739uPurC/NbThqEb/Vvx5H/G0xE55LyW5Ha0DBx3MEbVLZDp+r+WIPTcGdbKmZwpBgDtu
	mDQg/SKTKvFiw==
X-Received: by 2002:a17:902:cece:b0:2ae:3dcc:eb1d with SMTP id d9443c01a7336-2aeae7b425cmr18071985ad.18.1773218612065;
        Wed, 11 Mar 2026 01:43:32 -0700 (PDT)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:93a4:8281:fe98:426a])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aeae261077sm16062035ad.40.2026.03.11.01.43.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 01:43:31 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>,
	Brian Geffon <bgeffon@google.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	gao xu <gaoxu2@honor.com>
Subject: [PATCH v2 1/6] zram: do not permit params change after init
Date: Wed, 11 Mar 2026 17:42:44 +0900
Message-ID: <20260311084312.1766036-2-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
In-Reply-To: <20260311084312.1766036-1-senozhatsky@chromium.org>
References: <20260311084312.1766036-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2C939A0004
X-Stat-Signature: 5j1tyapqw47k4s16d5oxnsyps1y94wqh
X-Rspam-User: 
X-HE-Tag: 1773218612-509276
X-HE-Meta: U2FsdGVkX1/LXQNP0SGDOu2iguF3ficLJ0CWDtTsZzZy8jEUrIf8TiV0eQry9Sg3xhM5ydhN0Fgewk3L1p3h/vNEBv46xGQgKedcGk/hNG/oSf0/Qv61aNXX16nUkgYQsHzzp+Xr8r3gFcA2ACdu57hsi3D7pnbXIQafpVgbSeRsPPcbIjjqK0noLlv2jWSbobcz97cnixxfUu+k2f6LOBJYP3ZtGW8znV6j6ApRnNcPuMDsfDpyP+5gt8ZP8/djKblORKXR6PbUT0lDYw2Bv7GmGH1t29M5lzBSk91gikuk/AuUJFhVRDLwxANLubEaIBt9S0TKLf8RclFtpGzpoE/gK5F916u86XuCOKPX5rCS79clGXnEjmFTt+b96udSTxxeIXsRj2+qRn8ehxhnjoAAfFzyDVBKIro71vgo1AzXN/mVcdiGP/1flN/0SfugxWwdVRtIQ3E+AMK08FKJCwc3h/V5FhElX4xGkvrhmPj0wLlBVGQ6gdte/qDg7RDOQ46tlBb8sodP2JqoNHj91pVrjnxoEQPIuGRr4JnczeAyAx2XasDF76QVDVMdyl8YVJOSYcd2LH+RB2MJImnVTDQQ0Ag06dBqmb8mwx2/fm8sSduXQ47+B7EsOyUuu2nR/2P+8wdNlt7Q23CZTpn5tyG/SjJ5Ra72iLF11CUD+TCHbYhesdd4MSGYr5Tbi4zQPzm9FGJ7LABQhHXyhnhQlEh9X38wGg7VLbA1YT3BUGr2Nq1Xqr2yfsPpewxPfFuhtVegiVCfldKobMWh0OcbkTr9zyqrdDRRDTOL/ygqBr2p3Z+FfXrlzag/bX2fz2jUgX2zIuL7t9GJ0Ms6TDd1RWHxgKGgqpBsxB+CL97aijM5m4g6OD/DsusCu3JyTb+Px/1buah2MPqZLF4qfBahpVvEwiBkPBuDwqSwRp/CmsQ4IxtIerLUqzroA6Fa/EYuLF95cK4141ycOqJyI5S
 UM4cVrUJ
 ORNJ6a+d5iVBr26hr8DLeyJoyV957ADxl8A1nFHsitBndjc74N1I9LMO3apitSl0JZFAVBKF4qrE+d41wgp09hBEO3U0B6bpfOzeDdRQDcT9bQoT+HIN8w9uO5z7fkiHxUPPci+0cEAGSLrXxmR8FH5BUpq5SRWJkvWT+cRyOMHr+rxJweOOEwhrA55xW8yP65XZqcAtOl2d/80Wj97+9nn6WQv10JmaCnKxHNqyh/zTGXkABexdANUdRmlXyyjR0RjV49ENXpgoIrAm5GcR34Hgiemwba7Gsz+aDBkcUMwxD4rRZf3ASTJomkVVgdRCNfEYb0zXPf2yLfmGhLwPx4bqy2fmuPMrpXtbr7muIPtC/2So+qFpioopuAuXobJNuVkUT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

First, algorithm_params_store(), like any sysfs handler,
should grab device lock.

Second, like any write() sysfs handler, it should grab
device lock in exclusive mode.

Third, it should not permit change of algos' parameters
after device init, as this doesn't make sense - we cannot
compress with one C/D dict and then just change C/D dict
to a different one, for example.

Another thing to notice is that algorithm_params_store()
accesses device's ->comp_algs for algo priority lookup,
which should be protected by device lock in exclusive
mode in general.

Fixes: 4eac932103a5d ("zram: introduce algorithm_params device attribute")
Acked-by: Brian Geffon <bgeffon@google.com>
Cc: gao xu <gaoxu2@honor.com>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index fa38d26119ec..db862179cf59 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1750,6 +1750,10 @@ static ssize_t algorithm_params_store(struct device *dev,
 		}
 	}
 
+	guard(rwsem_write)(&zram->dev_lock);
+	if (init_done(zram))
+		return -EBUSY;
+
 	/* Lookup priority by algorithm name */
 	if (algo) {
 		s32 p;
-- 
2.53.0.473.g4a7958ca14-goog


