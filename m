Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2FE2C79F8C
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 13:38:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C86BD6B0088; Sun,  6 Sep 2026 09:37:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C109C6B008A; Sun,  6 Sep 2026 09:37:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADBBD6B008C; Sun,  6 Sep 2026 09:37:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8A13A6B0088
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 09:37:59 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2857A1A0523
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 13:37:59 +0000 (UTC)
X-FDA: 85183440678.27.35381EB
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0C73940003
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 13:37:54 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=D7WLmSTp;
	spf=pass (imf17.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788701877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4wH2Hl6u4i2ZJUFiprb5sPHmqLHW9cEhxm4g3fOPW5Y=;
	b=5GbzBBcfGXs3ShrfFqGUelFBxRabaNUJkFayoQht9NbohKC/xOUZaXKNirY+Y0V8l7LsHd
	LabNLmbHxikZ0JrZgw1KLbwvFuGmXqUdyxTitHquol6OspnueB/cEaH1qCfQCXafo/39i8
	GIK7pEwciTyp52kQi+l8cNE/ZbGVTZ4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=D7WLmSTp;
	spf=pass (imf17.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788701877;
	b=n93iNGaV/l0Iz37ioX3t1XgLubEvydlApWlGXdp/eJOv/UagWrcdPmwF02qrk0rwb6pCFr
	5+v+a5p1fIPnR/7hx9e+mdhoV4yCjXYof6/NzuUPp0FWm3TXN1gbR639FEoqa1Dx6RU5W1
	TAyvx/zDeo2y7q4hW3cy6twI9DhNnhk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=4w
	H2Hl6u4i2ZJUFiprb5sPHmqLHW9cEhxm4g3fOPW5Y=; b=D7WLmSTp80ueoSt5Jm
	2coHQ3w/50geMEGOu+XzElrCX4TxPf5EDatK6hWGEsRjIEK2xwWQqLvJYTWESMRp
	an+06PaUyybq08gGJZ3y0DDxRIwQnVG78veERPORgdNsOn/Jst2d/h2xCVWMpoJ3
	HNM2rqPxZr2GlEDV9TC1VATdE=
Received: from XLL-9950X.localdomain (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgD3xv2UbJ1q9P8GRQ--.42576S2;
	Sun, 06 Sep 2026 21:37:26 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: yosry@kernel.org
Cc: akpm@linux-foundation.org,
	chengming.zhou@linux.dev,
	hannes@cmpxchg.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	nphamcs@gmail.com,
	stable@vger.kernel.org,
	xialonglong2025@163.com,
	xialonglong@kylinos.cn
Subject: [PATCH v2 1/1] mm/zswap: enable zswap_ever_enabled in zswap_pool_create()
Date: Sun,  6 Sep 2026 21:36:01 +0800
Message-ID: <20260906133601.3563324-1-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <CAO9r8zPC4v_S80Gn5M7iiAujebP9QHdRur9fL1ECh8ZDxOov7Q@mail.gmail.com>
References: <CAO9r8zPC4v_S80Gn5M7iiAujebP9QHdRur9fL1ECh8ZDxOov7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgD3xv2UbJ1q9P8GRQ--.42576S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kr4rXFy5uF47JrWkuryUKFg_yoW8KrWkpr
	W8Was3Kr48Xr1xG3yUAF40kFy5t397Gr43KryUGw48Z3Z8Cr1FyFWxKr98ta1qvayvkayY
	vFs7ArnrJr1Yk3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JUUhL8UUUUU=
X-Originating-IP: [2409:8d1e:1b11:5c8:f7ec:75d1:bec3:9f48]
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC3BdCO2qdbJepfQAA3q
X-Stat-Signature: iap3rwdnxdczg7c9rkzqe1544du6ho9o
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0C73940003
X-Rspam-User: 
X-HE-Tag: 1788701874-934417
X-HE-Meta: U2FsdGVkX19suEMQuFFtFR7nCfro/ZFnL38N7XW6A7NYZcDgPyzw9UzJjytOk0HVYSlL/SYI8T+Tx8G37QhfbufvGFF7O7OKzGkFOyK853ZlxZ9mMjjcU2OBmkCH4Tv6Pwq5XDIge4gnS0CCo7XCzLXprIcVsDAWKNVwxo5NgsaJoe4ks69LwxYzbpSa9zzdZFTeeYt3ueHx36ieLrHEVsNwqfHwDL+pOCtD/ks5SP3rBHbiBnwOa/5DxEsVtrPD2id1xS2aEjdr5W3m3HzvToLdoarz+AoGjbP/9TKRvswbLT6j/Kq6ahb6uqwomQ7cRhj/ii++MMzXSaZ2VOAFQXH2G4jZ/Ikd4uh0iRgmVa0jSfVkVaOaNGmwzW/mMZiBWjbX1xgCRpmKCdhaJvRuKNFaWkO7YSyxsZPyOUXjfXcdh9Edue7+95jG6x2Qz32vEZdiNhNQrj7Gmaxt44upX2x7V8q68wjlqq77o9N8e8oEFUJyXxqHom3rt40met6w9NU2rNLZLGwihNJxLUgie3c2nzSxm0Lj0YvQ8cCYVk7HSzoBKFCsy6yNQJbgxeMvDt7SFbJrR+D4HKAApxiIVqoWIQDRLPxpJWaMpPoYdaRudSuGGtqeWcaK7AK9wgd91DXuJfpAXm0LVsYbu6TVWr4hx5w73IMA99DGANjmcgc9NEYD8kY9j21izU/C3UueXUzJ46LKPofkQlQ6yCmypkII2aVUipuGpWad3pRKUPdsXWJp2xAQ86QA5QdwHq6K/XlB/5AeDioQEQaLk1aanPcc0wroytA4bp6QADv7LPPtr7F/e0ksWH/eksxUKIiPQDDtjHx1IPCoxozNYG4uysw6BC47euj/aa/4wzsLK5uiP70bHx2QBGPj6KoYes0g41p9i+KJ8TNotjTQUOrQahR9a190WBk4SvHbCcqGQYdjUJvTVT3k0v1UCt+OcIMFNPKv7AzL4M8bccTvzvY
 VnVosWTI
 tEX39+bv3Nwr3FSUIbSaYKyA4wqtrb8X81zJy4ttfIHI72zfEVC90KurtxCnm2Bb12M1glNis62RGoEaKO6SQA50vz5NAfxkNVXh9Jk+1ZNx/j8UngkCYnYlMRWuiM/YITRQJsKtQ/A7QHqutA9fFWeCnb0fRT13Sq1M6UrW5Lp/mM7msVY04n224FDLLu2IHYZ3QVjubcN3EybsgftwySRkYoRQ79vQcec6IiFigy6L4ff41R6fQPoZoHSXhsDHfPhb4WLkZRcPj4nhdeJQV18Cmos1XxZrZO0gTnH/ahljy+TXpSMTjsToxu6fMJlCp0CTWlC/ZBTjxzyewxOGqdESN/TK2EmkpGrc1j8UtInrYGdlDswg8AoGuZxMmXETWeGf1jIU9yi83Ex5IBOZPtenb3e5717CT+ej3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Longlong Xia <xialonglong@kylinos.cn>

If zswap is enabled by default at boot and pool creation fails, then a
pool is later created by updating the compressor, data written to
zswap is corrupted on swapin.

Enable the static key in zswap_pool_create(), covering boot-time and
runtime pool creation with a single site.

Verified with fault injection on a stock kernel (compressor builtin,
CONFIG_ZSWAP_DEFAULT_ON=n):

  1. Boot with zswap.enabled=1; pool creation fails, init completes
     pool-less (static key off).
  2. Echo an available compressor name to zswap.compressor.
  3. Enable zswap.
  4. madvise(MADV_PAGEOUT) a pattern-verified 512 MiB region, then
     fault it back in and verify.

Step 4 reads back 131072/131072 zeroed pages (zswpin=0, zswpout=131072)
without this patch; all pages intact (zswpin=131072) with it.

Fixes: 2d4d2b1cfb85 ("mm: zswap: add zswap_never_enabled()")
Suggested-by: Yosry Ahmed <yosry@kernel.org>
Cc: stable@vger.kernel.org
Assisted-by: Zcode:GLM-5.3
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
---
Changes in v2:
- Enable the static key in zswap_pool_create() instead of adding a
  second site next to the compressor parameter update, as suggested
  by Yosry; boot-time and runtime pool creation are now covered by a
  single site, and the zswap_setup() site is gone.
- Use the high-level description from Yosry's reply to Andrew for the
  corruption scenario, and rename the subject accordingly.

Link: https://lore.kernel.org/r/20260905125101.2970456-1-xialonglong2025@163.com

 mm/zswap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 37f34e406c8e3..6dfb6ae709e97 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -324,6 +324,9 @@ static struct zswap_pool *zswap_pool_create(char *compressor)
 
 	zswap_pool_debug("created", pool);
 
+	/* Enable the key here so every pool creation path is covered. */
+	static_branch_enable(&zswap_ever_enabled);
+
 	return pool;
 
 ref_fail:
@@ -1805,7 +1808,6 @@ static int zswap_setup(void)
 		pr_info("loaded using pool %s\n", pool->tfm_name);
 		list_add(&pool->list, &zswap_pools);
 		zswap_has_pool = true;
-		static_branch_enable(&zswap_ever_enabled);
 	} else {
 		pr_err("pool creation failed\n");
 		zswap_enabled = false;
-- 
2.43.0


