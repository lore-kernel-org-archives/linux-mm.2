Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22114CA5FF0
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 12:21:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D51DF6B00A2; Mon,  5 Oct 2026 08:21:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D02416B00A3; Mon,  5 Oct 2026 08:21:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA2BD6B00A4; Mon,  5 Oct 2026 08:21:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 81CA26B00A2
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 08:21:28 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E8F49A659C
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 12:21:22 +0000 (UTC)
X-FDA: 85288482804.14.59DBBC2
Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	by imf03.hostedemail.com (Postfix) with ESMTP id 30CC920007
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 12:21:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="V5k21f/4";
	spf=pass (imf03.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.227.171 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791202881;
	b=FSdSh9n58fFcP+Fgc0lH5aAfijgJakUzjhinJ2W8u2Phzsck/0YUNQ4JJbeh5QU7GbK3sA
	NQcMIE46eLuN2vR9TRLMeQJiEBzCcRYb0hEtuICIz5uRtgVVNlPICqq7zW5ogkjmUuCl9s
	WlQ1HmcJZ7wcc9yaqSwEGpjPzHG3BY8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="V5k21f/4";
	spf=pass (imf03.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.227.171 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791202881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lBooGZSw2IxfoAxzLlFw+KVKnhFoUqum4OQR7iUI4RU=;
	b=4lw1oksLqoRe8ouq5HeT0/AVMGhU5B3Pyg3woPTpPkV9wG8IWKFh4eFXgNKcURsBHoHVbg
	SzHw/6hyT/rTJqzlNReM8dnjXouoBZ6nxgLjr6CGUmBCYYHlTpk0QKYCxsUPJPFfzI79n1
	BUI5UP8dVOZfIg4TrSLMjdWego1oGpo=
Received: by mail-pj2-f43.google.com with SMTP id 98e67ed59e1d1-396ccb652d7so866159a91.0
        for <linux-mm@kvack.org>; Mon, 05 Oct 2026 05:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1791202880; x=1791807680; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lBooGZSw2IxfoAxzLlFw+KVKnhFoUqum4OQR7iUI4RU=;
        b=V5k21f/4toKevRdy8KNM8oWNbCq1NmgAglKRvlzh6cHpjn0NhsFG7dM0KLJ+DU7j94
         gJjkNS3W6CKHWnXVIA3D9LCPa8P6pAzs7mHVqj/HtsyUwul1LvoBAlxZNcTQjpP/+StZ
         V5VOHSMsZspb1N/Vm2SorWOPZKLTo1TSbBa6A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791202880; x=1791807680;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lBooGZSw2IxfoAxzLlFw+KVKnhFoUqum4OQR7iUI4RU=;
        b=ZTyLDVUVNNsgQWZ8nq22VkuNHhPHElxwpyyorgKJ46br+oz/etx7X1AUtyNaivwWWU
         GoIdoHZ8AqShklhH2vNw9zkqYfMLi9Uyk8UO97op67Id6dYW0BdfujXNED1TLU/6XCUi
         T78qXAtB3nSjfj46Z+u2jNpFt8hpt/MM+Z1tNKLHZzhSudlZ9L8d6BmcKFXFFUxTqPQl
         5EM17a3xs9JWq3HcfDopfqC9pA+d86Pcb2NU3YdLSDkZIDPdzqfSbLrUlSiPr8mrRCFh
         p8vvCZgGiDuV+vjwZwJTuVbBkEVC7FQ0RP7D3HrqOKFymR76/U7d2s0SuFUhUGsgKVCR
         p5Lg==
X-Forwarded-Encrypted: i=1; AKwUvBw2agRAmGJeH9LfXNCX84y/LOl4B7OVUrPnUFYSL8C1OAHFQvdGR/3qmKbPf15KP0lRdKxdqqNNxw==@kvack.org
X-Gm-Message-State: AFq9FYLwh9x8x2+iJNK9W0VdgOx3ckbxJr4hd/N3vIQ3exczOqg+3AKE
	Z2TeK8kIWKHjsJWlaNAdIcy5wzaJfEYxWDzkRI1PKaOuQE2tDJPJwx16Y2chpRP8oq0YxjX0raV
	04bo=
X-Gm-Gg: AYBFou2JSsJlhwWlh2OOTme0C8GP9N5k0lJGoLIy9zY4NTSANUlvhlbP/kgO1LZEd/w
	/APCC8MoK8lyheHQ1wzO+mevIHIOWm4ak/6CqsX9DPUpChOqVmTZT2dp5qtEx912eswoDyreXfe
	FkJWTNzZaskyz41Ot9IWQeFDVKXVv08aMRlpqQbG1kXxRxEBE3oJVwBq7/GTj7aeNx4kMCYoNWO
	1fFOb1oKKfDYe76DUXopC1Lr0IKIgENQWHOLieBVjVOQu13Vxi4ekT6gVI/o7tKGJFH40xkG3KL
	88ZO/bWtR02KGrqS7qtQlLqCnZV55Zkown3eFy0eTGChqdGYG7OGASVlNJodL+i3BHLaWdHCzBn
	hC/doUT2F7r7Bj9sMF7cD6loGi6lDVMLvXIppa6eK6fJgu6YbPAvD8cjeeuIVv+wlq7H34tg8h2
	kNX95zne9RQqYVoRWGHlQyU38Tp9KFrDbnY5YCA9G3p/CL3dpI+arwVtKR1YeQrbCIRmLMy7bmo
	4nPv4hXVVB3LOYJhAUHDO3pYvXIiFaMU3hDaJXsVA5jXoTB/q+l7r7t87k7qi4=
X-Received: by 2002:a17:90a:fc45:b0:3a4:945e:bc33 with SMTP id 98e67ed59e1d1-3a6ce82bf0dmr6782414a91.47.1791202879907;
        Mon, 05 Oct 2026 05:21:19 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:9211:ddf0:3c6a:bf9e])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a7e4b00de6sm3342997a91.1.2026.10.05.05.21.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 05:21:18 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 07/10] zram: zstd: do not use kvzalloc() for zstd allocations
Date: Mon,  5 Oct 2026 21:20:22 +0900
Message-ID: <20261005122036.718976-8-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
In-Reply-To: <20261005122036.718976-1-senozhatsky@chromium.org>
References: <20261005122036.718976-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 30CC920007
X-Rspam-User: 
X-Stat-Signature: rbyzch4bdeswdpi3bkh64b4dtfsj3ttq
X-HE-Tag: 1791202881-835339
X-HE-Meta: U2FsdGVkX19pYmI5sz97OYETfzSJGOFr8Lz1wkei4yzH25mh1MtVmdQNXFlzV25lbwddyA2yRSOnYEhfDRcRpSwNQLau5m406xRvRx5x9Xa/8U+cLbKCRFFfIhyhNg65eq4RWfGtNLTrAYyvVHL45D6VnDZM+7kjnuCYlInv4mNlgtVvYlRU8vDsVhxI4/QXzZnqX29cgMDEKWliDnxv/EOwj4IugBg+aUgf6qjp/MVvqJu9RkzlHrXiXtV1dGesUG5N/7Nl3X18CMcLo3ATP84o3fCPa7iLpwQrVeZGL0BgPbyoDgUAhiQ0CagOboaygT4rCIwDJ5h5mRMkKYfXM10pNaVKq5r6R8cWuwAJ27qjIMJKV6MjcoSqKwsRioT1wTymZ8SwvNumww2FCUEpNWA9pzPXAoPSlFnTBHhzgikLQtSYV4VvCOCugqCFUdR4vTnBhjICFTQyMMWRzkaa+rxkqpuH0hp23yx8aCc3zUaMnnYblLC1KArU35X6Fmh35ajMgSNqcNzyy9wCgacNbV05NIf5JxgMZYaG8bSA9CKXGaxehHkdoLUva8Zcx36FJWZf6laer82Hu2dHghJP2mOqTs2dUMHbQ3NTgFuyu7jgMPoORNPxyboyvdqYw99dx3RfDFHMqCPijBuEzQKqdW3AO/kPBXljg6zfsaaaDnYenYxzkSvDWZaJl4GMdz9jqInl1mIegOCBU29M8cKTytrDcKt8+iENx140o0laaHiQo2G+WDOia6nXRcWrm7jEQopR69uZghlnxst2t+udn5EjZ6/i62+TaN8yo/vui1ivMcLmjB6C36QGl+7djJoWmmfciUPKjkS/vqtKaTT1T41pkJiCeiMx+bOTH+9e50lkFwEqNlPOSb+eE9/p6VkLc/Z9ZvHWHLCFtmffrnPuK1Ibb5vaeNbo6EORmoqf3YtKCYGsGbn6CaovakadXYuM94Rj75VCvgL3a6jWaO/
 9DlIMmRP
 CVBMvYiaJunSihIG5Y/oOHWrfMg0J9TRXzileCeza6L/lJ33lTxectaeu8WR/1TnQU4Kf1yJyAoRYEKAKV0adeEo5tole5DjUR+paJZ9USzVZGd5RVyNcV4VE1BbLzWk0k/11bOPB1Gra2BNsYHCkuojwRzN3Zzm1C9SJzqzxe/TYa91xefFScJJW1D1WLzTohoxtXyJGLMJh24byV9JYj5MlGH7F8n1qS5Ciw7O5ETXasfCbOOxUIfYEcSq7o2CCCeWibUNx/ZA36YsaOUu+qP8JdtyCdsIkYaAQ1qCHUyFRWWg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a dictionary is configured, zstd allocates all of its memory (C/D
dictionaries, compression and decompression contexts and compression
workspaces) via zstd_custom_alloc().  zstd_custom_alloc() uses
kvzalloc(), which falls back to vmalloc() only when kmalloc() fails,
and kmalloc() rounds such sizes up to a power-of-two number of pages.

For example, on x86_64 with a 110K dictionary, switching from
kvzalloc() to __vmalloc() reduces allocations from:
- CDict (level 3):            512 KB -> 400 KB
- CDict (levels 12+):        2048 KB -> 1552 KB
- DCtx (per-CPU):             128 KB -> 96 KB
- CCtx workspace (level 3):   128 KB -> 84 KB (per-CPU)
- CCtx workspace (level 14+): 1024 KB -> 764 KB (per-CPU)

Use __vmalloc() for allocations larger than PAGE_SIZE (and kzalloc()
for smaller ones), which is also how zram allocates zstd workspaces
when no dictionary is configured.  zstd_custom_free() already uses
kvfree(), which handles both.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/backend_zstd.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/block/zram/backend_zstd.c b/drivers/block/zram/backend_zstd.c
index b367049f131d..7a8b5ff186f2 100644
--- a/drivers/block/zram/backend_zstd.c
+++ b/drivers/block/zram/backend_zstd.c
@@ -26,10 +26,17 @@ struct zstd_params {
 /*
  * For C/D dictionaries we need to provide zstd with zstd_custom_mem,
  * which zstd uses internally to allocate/free memory when needed.
+ *
+ * zstd allocations (C/D dictionaries and contexts) are large and
+ * long-lived.  Don't use kvzalloc() for them: when enough physically
+ * contiguous memory is available it serves them from kmalloc(), which
+ * rounds them up to a power-of-two number of pages.
  */
 static void *zstd_custom_alloc(void *opaque, size_t size)
 {
-	return kvzalloc(size, GFP_NOIO | __GFP_NOWARN);
+	if (size <= PAGE_SIZE)
+		return kzalloc(size, GFP_NOIO | __GFP_NOWARN);
+	return __vmalloc(size, GFP_NOIO | __GFP_NOWARN | __GFP_ZERO);
 }
 
 static void zstd_custom_free(void *opaque, void *address)
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


