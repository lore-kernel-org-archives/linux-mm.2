Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DC76606A32D
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 06:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=Acb2QyTS
Received: by kanga.kvack.org (Postfix)
	id 522766B05BE; Wed, 11 Nov 2026 01:47:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D2A86B05BF; Wed, 11 Nov 2026 01:47:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C2426B05C0; Wed, 11 Nov 2026 01:47:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1AA406B05BE
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:47:38 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A3E27C0220
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:47:37 +0000 (UTC)
X-FDA: 85421907354.30.3F8F192
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf17.hostedemail.com (Postfix) with ESMTP id D60B240007
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:47:35 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Acb2QyTS;
	spf=pass (imf17.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.41 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794379656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s901sm95u73URLyqX1tOE80ZT+B5IbZa2FXF/1v/wOc=;
	b=hVvgLQbciN5qZ9zaMTyC+MErpkxT8kalnYTCedW6Kz4utzf4yOKkCkmbYPHsOut6nyqeiJ
	gyohRgQJP6ZihZvBI4QnrmqiKgA+N2cxh667tr2uX3wr//hg3XjctrwleC3qQHo82Iavtj
	oAI9kw2aBmlbRCEM596kf1OV1LMMbbM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794379656;
	b=jk0+1dyPPu46KFS6uSPc53ubcAztrZmq9W1RmN6oXFq/hSVuJLnQtWKU/uXiGIYlViPbCR
	Zt2qwMNoLUbbgkj31ofJknBBPJLnDmo3zPi7XT7cbQ1IyLykXSUq/LkDt9ajhiduZnhAAy
	WUXVB1TNyTKgm9dKU4VqjkeWV/JRe2c=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Acb2QyTS;
	spf=pass (imf17.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.41 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3ace1f3897cso1608527a91.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:47:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794379655; x=1794984455; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s901sm95u73URLyqX1tOE80ZT+B5IbZa2FXF/1v/wOc=;
        b=Acb2QyTS+dfjFIwN9TxDMRu2G20Fof7s+U1YBQFFd5jYOT1K+6S6XAN/1sGbs97tIP
         SThhduVp8EmokV4iyTKyFtDAxH0OGbRk3LIYXoJDg2evfsazsfeMD5rOofu13SDwMvEm
         zbpQtFtDuMRGuR/dvuTwnUhZHSYDA8iclEx0s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794379655; x=1794984455;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=s901sm95u73URLyqX1tOE80ZT+B5IbZa2FXF/1v/wOc=;
        b=jTSvmHa6AqvgvHSmdujrTceHBm3LC/iauyBMvhOK+IW5bbOBeX8X67qThLnm0zMb93
         z34u+V4VZsQ4iyKAXZ5jvkcJte8GtGV4Fgyx0LesEnrfxXg5QBnrbOiyOmk3C+jF2RZY
         NoZwmTdWGaCNByk9hoCNYqzecd8zZGuWsCBYfkgBMA9cmzVIUhk8zsqMaDgSamw2jt/3
         GBb6ITi3uPYjqb46UBa+dNxnFU4erm+O9byYtRHW7PguaAP2pBgTMPyDcpL76dvD2i2t
         z7MRGLKXb/tX6wV5Ii07u30DGki+T0siXPSm8JFxwRzU7XAd12HI3R1mZBVxekZHbVEV
         ljkQ==
X-Forwarded-Encrypted: i=1; AL+hErF7Sbl9YpZimeR+K9C8FXvpE4bGOVXuVJxKHJFqumrXsz1gkyA+4zqejz3mnn6tx3O0nSFb8Damww==@kvack.org
X-Gm-Message-State: APuU4Z+LH7mqlfK7zDbWQVeXliM/Jm4qCet286v1IRwFB4Mu0O7uGyVe
	0DPzH1qyWgqBE8i0d2Kga3LMS6KCWaZyQOkHR5Q3u6UMApF1MSUMNmFBgpnQIRZIpg==
X-Gm-Gg: AYBFou0dQ+MkxvVVFHZrIVyttKu5movBy9G5iAQM9UcHnssAOA0UFHDkH1etkTvCivQ
	iwLXEPASNxuzzvY+arCN4LxR5m/OKVfPgEFLnFkhLTi8QvdbNbnLhYU5N5R33vWZvlrimpYxJz8
	TlGkN+pmGV94x0AIupVBKt97xKOIopZfDDQyVKbbtCMN/QZnX2L05FnN5sIEAJo4NiWN6mmfnVd
	3V3h3ZqHrksmipJyyGBwJ+OPcBqnrzSMC1W0sgrgEx3cPf5iqi83Epxfb/nUDWFXGT0Rqf94Ye1
	ZJEOvuF/uEotYhR5k25zyfujBayEhDhM3WkRPwz8IhktJTMPDcT2SRJvi/wwqzybLweznDF7Wnw
	Vie44JM8/LVja2+32RKPDjSDajqMDA5u4tF4oznxgCWPjfRmL6iSvy4STEqeWh45ppbrFj1lKup
	iL1It6NlPDRAUPvn1fuZCFCH3CoxX/d6fGpebohckC6ubAbuwDbwF3Nj00TEEAyzcqyLOH5yMjz
	03mtFQl3e8uGTW32fQCJUFdWcmfhPhrUY6T4/Uh+vtjW1hXHLfswRnBZy65d8pjSGHlHVF7+SKs
	lNG+wXo2NpE6DWPeg4dU3lFprXYiRMRlXrFdoqSMkCTF3eqp/f1r7Pp4vMo1yjz9K/wn3akmTaD
	FjWYK804i4bqKqxzDCg==
X-Received: by 2002:a17:90b:4a90:b0:3b0:aaed:48d0 with SMTP id 98e67ed59e1d1-3b182f5a300mr1674067a91.37.1794379654696;
        Tue, 10 Nov 2026 22:47:34 -0800 (PST)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:ad6a:b446:df00:78dc])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b17db85a9bsm3268666a91.14.2026.11.10.22.47.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 22:47:34 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH v3 07/11] zswap: do not free the entry if its pool is NULL
Date: Wed, 11 Nov 2026 15:46:30 +0900
Message-ID: <20261111064707.2568433-8-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
In-Reply-To: <20261111064707.2568433-1-senozhatsky@chromium.org>
References: <20261111064707.2568433-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ab6iqneofzo3o6ugi17jndjyphdwnp4p
X-Rspamd-Queue-Id: D60B240007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794379655-952107
X-HE-Meta: U2FsdGVkX1+T9rS1bh4IlKOqW2s1M2khm4xuUWwN0p/CzWGS9bW6nzPI2fP67AkuKXy1KUasA24UxRDnve5X/Vy2LzszgaLJMcQxIPe2ZQsMSjm53896BDdCQo4cM+nmN1hb1Ck23i0wfssP9c6pEPzdesQfvqUuchbyWQh7KAFZjq2562jqXkVG8NrmcqiFQHYT7WdWZSnllG5K6gBn9EaHl3JgnqLTElYAYmvHfa65/AV6cJtANLR7NMWMqUS7vydgl26pyFwEbO29qrqwXf1UB9NK2rsKc4bcwG+N4KNczQgqPl7oMLgXvRjiAAmoHDzKlhNtKZts4xu44wOvhSZknGbtnKusjP1pqwL4JcYGfkeOgMcZPGKAgGtcEJ801Ghwzkqy/CEKrNDZtGda+g3JJUCKsSs3XPftHZLhI12tki4RM9NdCp96Rj2oq6VPhMXboAqAEzOp8BJZkc0pSwdmTXGYiaRbuJE5Zs70aVEN8ogaHu3sGmVJ57FiIaTN0mV1XMI3lqGloRy4Bj3rxd3vQ9vAYs9Iq7C5JAub8XanNPTNWsUrVWEmzXSX/fJ1sFlTnT09gAkeuC4OkPZmeLgCaGKs1HmDPdKBrrDDmWHvPrTTj5M/Z8tRwjm1HHTJZQ99fH9v2JqpDmzSOjJYx/W6Nvt95MRW3WEkTloXepQOAVWmsscCOWRSvCLQjglOTY+E8Yknj8y34ojUd5FpVa+LmUkyB9ZMJvmfRaqOJDXKcHrYoZlLzfCJhkiLLToF1HKtrGuSlCQpjLZPGEHWR57UwK4TMJez51rG1sV9ra9BIA95eDq2IsNb4rPMJ5KipaSGVssJOPgBqWwo7b0lJqB56T7z/GMjY6if8BsIOmWMnx0O1FC3BBO8FAYk7uBPgQXqThEL1AtFzQfvWDi8wZJL9bWjHMfptBz5Q17FNyq3DA1ODvp9najPaXMD4JSCKb+pWVUJqc9D1pZ1B6w
 AqzQ7s7A
 6ongezJWzrpYM3fm7bAL1u4HfGHdUvrlqsHvwbS1+a3NNpARBUyUK6ycjAlQKn0eZfxs6/hcZ5Cth96asam+1Q9N1NOq36C1HAzje0DsbqbZadgUyo/+GMnCIj6rjuMxngAQjt6JnjtXdnaQGPdIK0WtvfL41oSeKQDCrqvVr9rsnsGV7EATGzscDIrH16zWjgsrMPEJ6jo88xDtgc1rNianKWRW/Z+bSQYAiNteTtcQL/3knxDc0TTqCEXGbMcTRSBZR6YmF0JNXE2564Fz2LLs6wtkeoNhnYGViyoYu67VzFXEDeZuC78ZChyYWpNfR3jPrfCxlyMFUTwNQY9FORqifBjq8S0jZFPNZMBPk1NMxON0DkKujAmksb0YINHUB5adx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

zswap_entry_free() warns if the entry has no pool (which should never
happen), skips zs_free() and then frees the entry.  A subsequent patch
embeds zsmalloc handle into zswap_entry, so zsmalloc object will point
to the entry, and we cannot free the entry while the object is still
there.

Bail out early and leak the entry, its cgroup charge and stats instead.

Suggested-by: Yosry Ahmed <yosry@kernel.org>
Acked-by: Yosry Ahmed <yosry@kernel.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 mm/zswap.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 1160bd34e289..dc0400d7e1a3 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -787,10 +787,11 @@ static void zswap_entry_free(struct zswap_entry *entry)
 	struct zswap_pool *pool = zswap_entry_pool(entry);
 
 	zswap_lru_del(entry);
-	if (!WARN_ON_ONCE(!pool)) {
-		zs_free(pool->zs_pool, entry->handle);
-		zswap_pool_put(pool);
-	}
+	if (WARN_ON_ONCE(!pool))
+		return;
+
+	zs_free(pool->zs_pool, entry->handle);
+	zswap_pool_put(pool);
 	if (entry->objcg) {
 		obj_cgroup_uncharge_zswap(entry->objcg, entry->length);
 		obj_cgroup_put(entry->objcg);
-- 
2.56.0.542.g3ef89b7020-goog


