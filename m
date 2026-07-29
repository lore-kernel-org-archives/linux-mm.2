Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AC53C53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 03:58:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D4C86B0093; Tue, 28 Jul 2026 23:58:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75E256B0095; Tue, 28 Jul 2026 23:58:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 626986B0096; Tue, 28 Jul 2026 23:58:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1E4256B0093
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 23:58:35 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9D0464040B
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:58:34 +0000 (UTC)
X-FDA: 85040457348.13.D42F70D
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf19.hostedemail.com (Postfix) with ESMTP id D179F1A0007
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:58:32 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Zm226M2x;
	spf=pass (imf19.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.46 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785297512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AheFru43gQWGPPuujNoti5N0XT3IQznbkDZJX2JAMsM=;
	b=dCKBLFMe3mQmvbp5ruuvr2WWNDqrZR++ZVdFrns1zQuVjmb6+VIq0T2n9nb48gRjtUlyr2
	29TUPNrL3pn8+HCG/iXChO9pdmgRUexKF4XcjQSZfIvRY/SxSOARg7dNmGC8xfydTH7uxA
	JTV141PH110fI79XUSe7i6SVzH8QXYw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Zm226M2x;
	spf=pass (imf19.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.46 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785297512;
	b=DKCiA+84sJT8LN6uMlzGbjWf8xnjcP2EFny5P56YxtK7qwky6kV/O4XRDGM+tVPBhXxlZX
	BOdQC1EuQfX7EDBc8F9wMft8qBzhJZrONKkUYT9wEY+NUpJ6DNdo8dQYkTc69Mi/CC50vA
	nqTQOiOVxd7H0hQ35DP9ogTOyZe9d/M=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-38dfe7eb825so403772a91.0
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1785297512; x=1785902312; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AheFru43gQWGPPuujNoti5N0XT3IQznbkDZJX2JAMsM=;
        b=Zm226M2xDOAopYo5K7FndgJtc9nyR4uFKSW0zaMCFsRfUQUyX9nqNJc5K3noJ71owg
         XwUjGKUaZe1N6mYe2YtM3G6Fe/fP/jZzimfVkWKj3N0dqKoE7r+i+F5XsHAewFcBIuem
         UWB18y2o5fNvCPW1y8wo4z4gyB5IqppezvXdY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785297512; x=1785902312;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=AheFru43gQWGPPuujNoti5N0XT3IQznbkDZJX2JAMsM=;
        b=QLKBU+CEI8oqfihKtPGnctC84HeolyldtWcmaCxCKqov0SCkHN57Q/SB6P1cNDoCxO
         TVrZPvU/zZ+xPVg33tNZuWlMrS7clsOVzYHolcMyHgC9NXT29jjvsKC2Y+m+5PD5YO/X
         VwI9U7tYAZ0/H+zvSHgJUZrTrY1nSDkW/QKf/rVdkwyR0+8mGRt8RbtKuXwiuORPsV1J
         F6xcd5hF6mxCbFvZGGo7+3DUNNwGwKOR01/QYkKc6L8nf/K0JHHu3pmxCfN6Iql5Qkt2
         6cHh8lpUeVa/2Kd2fMLIElcYWACJDdNYzg4QpPfa65hFsCEipMR21K3DxTeYOpi+8E9C
         EqZw==
X-Forwarded-Encrypted: i=1; AHgh+RrG7dosd5zZxxTDysuXk6LrdMBr4ZK43/bzkUKkJbP/XWvjCwPYjZ/3mIipiKZSj+zm7hpxSqCI/Q==@kvack.org
X-Gm-Message-State: AOJu0YxRmFFQylokErd6nV5rdbNUIZ6llVMxiahMlzXOOL8KsiUzBy3a
	RnVV5JYg0voG/PNxce+LaEQCWTdgidllxCTriyBuGAbuMLme4Oe/+rr1W0ya4O+GtQ==
X-Gm-Gg: AR+sD10pk8FZGhkCPkOeU0mp2lAkIqJa7RJ6nUyXBsq7LsdRH6QdfwObZtBOHYYLPWp
	nFJEKU2Cvnpd2u2fp3oP4uxvuEyhNBREH3BilnwQRGPnHsW6Jt7zoNjGxFWIxCAFfHIy85dKLKf
	z6Wz8v4Ynrr6NBuKUvs+TWzDKSHVen1vCWSSvzVCo6d92OULgjrqYqXi0gmPk7csbAZtwKbHrYe
	fkOxpump3Og41D2lzqEJ3r8mvsCPiBOxYMa1GqauRm8j2/w7/SRI/KhYz+J+Lfy7j7NURI+fltw
	47UPd65sZPz3DXeox2twjShkv8YoXjWUoQApp4I/JFl+KlhzWG8p4svPZUQNLPhf6c0ZVOqMZuz
	+jJZNbfb3LLqsKVqjdvTrqZmhzsmjtIKFtcT8LkkqBh5IrZvKQKDZ2UVZu4JuiFgFxiuzJLHFr8
	ha/aSb7Rg/DIXQZTdKGbhgCSAod4q+7t+ORq5v6AnCYihanIi0G4gyXWTvcZDeggx3PPYf4vtub
	0164jkgohu+/7qqb+Ijd/P3jPdEIay+Ighqiw0/EkPRfs76U/4=
X-Received: by 2002:a17:90b:270c:b0:38e:5e2:6dce with SMTP id 98e67ed59e1d1-38f6a5aa922mr5609043a91.39.1785297511770;
        Tue, 28 Jul 2026 20:58:31 -0700 (PDT)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:65c1:52a3:f6d3:37dc])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f7eef9c5asm722087a91.0.2026.07.28.20.58.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 20:58:31 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>,
	Haoqin Huang <haoqinhuang7@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	stable@vger.kernel.org
Subject: [PATCH 2/2] zram: validate deflate params
Date: Wed, 29 Jul 2026 12:50:33 +0900
Message-ID: <20260729035820.751990-3-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
In-Reply-To: <20260729035820.751990-1-senozhatsky@chromium.org>
References: <20260729035820.751990-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D179F1A0007
X-Stat-Signature: c9ho3wy7rkwbni84s3rr4a1p6k3jo19t
X-HE-Tag: 1785297512-713858
X-HE-Meta: U2FsdGVkX1+aOF77mriec+xJP8r0UeeCiIOHhLqgl8jZQgi4kg+8I1pLxFM68y2YbMu+XwEXJImJiJV/bqR3o5i8CsTVVBXk2CLhZZyrd4AKhp8JVv0mkDycvBiQeRgzG0Uhp9M/0VtE/5wVXFEoNiSrsWYYT/9U22DtVx+s3KFZL/2EMSPvmoXbpksyVKneNQOP2AxQuoJycA1e7ixfigzNfvzhKJxe+hMK8Zkylz4YkRfeFbyEltF5wxXHuEQl5PIFHeyOVns9E2/rBA506uFDZezYde7q25slxwv7xeh3OLxcUHqjdUJTKRL7eQlUnB1ApV8e2IMR1O3/ILhh4Frt5xZvGYtLxmlvg+Z+LNQU+Ci1v/vSX7xIxkyMwyJdIuPAwzg0rlD3uHGerf9hEDUa6nKCnV1UFuJndSiTUBrD5a7j/UIZiH4/E7+DudB4gdlcjquyKzHlzU1Yd9NPrAiT5ZEAYTIagH0ADt4PABn0kVLXbNUe7kanitWVF/hlc5oNwWt2p04WgmJ1hX5B62setgp0eQNygks1fZdCO+S6s+xbAArwKFSDnTvfnu9kFVC027cw7dPJoOI4wNx6pTEX4hQZt+2ygu71QJjGkhtVfjsD4pYPuEuHCoFwBsA4NVPrkWEy5POHxtFmJTnBdbYNPAJflHFhk9QTOLbegbD3Wc0wEv72xC4GEfDl49B/gKmqJaO5a6FmrYpP+IQmqqedZRflrJ9RkW1iE6FZrEST0i+fWqlW8XaK3w+7Oon9J0cR+10/AGe3AUn9eXKOSq0f5/5jWwISak6nSrY3/l8rTTANbPhUWQu8FZF3HaNr04ovLx3HryZBvfTU41FsgGZFqXsRKhNvbKTBaDFubYSdLE2+0oSDoBxLkiRIsgi9lVkKcK9fkSqyz+NQ/jF7myBqf1RFO3Ksy8hr8fwgsqpjQVaU4ETTvE03mq1sFTqjcZrYkC/qzYLnFnSEY9E
 Hvjst7yf
 bU4H8VyLG4Vcav88P6tOghnzSGpqPWFWR78duzMhLMeWBRXIah8ZG6GeOa/BQkf7SML3lqj83QJ/DSMpZIPAryv7C54Bl9uXVyeaXOGr4qJwPL4+G1L7OW0SFzrbzSDMHXusrLi5t5MyrjWgXyYEidgBCum5pjfeOXKF8oJkHBfhTU4QlV12bXtJGKrCdjDkIUEFlMHiee33pamahqcwPpCbViHmkxnI9T+rPxksX1VAoSzGeLH1dF6J7WqAiEKgPVEmUvx69BepuLk2yEz72XhuF+oYD5nsQvjSf2wlcj1gy2NUpaejsCbHkvLdIg7eLH3R597iqkSHxfmdUtEYkYsNLE+/WkswFyEIyE3eb9V+CxLgRPrwC9EBwLeB6Oj8elQSibu0Wsqnk5MHb8mCJcp7kuszbNn7bEJ1z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We must validate user-supplied deflate winbits before we
pass it to zlib_deflate_workspacesize(), which triggers
BUG_ON() if winbits value is outside of valid ranges.

Fixes: dc75a0d93bd5 ("zram: support deflate-specific params")
Link: https://sashiko.dev/#/patchset/20260728092935.31139-1-haoqinhuang7@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/backend_deflate.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/block/zram/backend_deflate.c b/drivers/block/zram/backend_deflate.c
index f92a52a720d1..729ac734dd6c 100644
--- a/drivers/block/zram/backend_deflate.c
+++ b/drivers/block/zram/backend_deflate.c
@@ -24,8 +24,14 @@ static int deflate_setup_params(struct zcomp_params *params)
 {
 	if (params->level == ZCOMP_PARAM_NOT_SET)
 		params->level = Z_DEFAULT_COMPRESSION;
-	if (params->deflate.winbits == ZCOMP_PARAM_NOT_SET)
+	if (params->deflate.winbits == ZCOMP_PARAM_NOT_SET) {
 		params->deflate.winbits = DEFLATE_DEF_WINBITS;
+	} else {
+		s32 wb = params->deflate.winbits;
+
+		if ((wb < -15 || wb > -9) && (wb < 9 || wb > 15))
+			return -EINVAL;
+	}
 
 	return 0;
 }
-- 
2.55.0.508.g3f0d502094-goog


