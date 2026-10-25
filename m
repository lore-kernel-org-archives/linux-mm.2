Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FCD4606A33B
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 02:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=UGYF48go
Received: by kanga.kvack.org (Postfix)
	id 50AB56B05C0; Sat, 24 Oct 2026 22:19:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BCCF6B05C1; Sat, 24 Oct 2026 22:19:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35CE96B05C2; Sat, 24 Oct 2026 22:19:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CC97E6B05C0
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 22:19:11 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4C358160544
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 02:19:11 +0000 (UTC)
X-FDA: 85359541302.08.E8E3E99
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8C1BA140006
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 02:19:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=UGYF48go;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf26.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.46 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792894749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q3okMCYlIonzi2nM46q+sdWA0XzhR4Jh1qbkbieycoA=;
	b=6QD7Y7F2Au65KEg3LDfkjbDKtIuo59kHKZfifeg/nt/TItWYemkW1Dj5ruGQvhJ2Vw0sPN
	Kpf29Tl+rLrJIKPtXO5ch2mDFlO/f/zIe2GhHkm/F3WBYZTwwxt9DacP5cx0tsf6ED/Cui
	QRyS+vAt04idCPdo4SqUIiox//cFrtg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=UGYF48go;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf26.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.46 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792894749;
	b=rJuArh0m5/+fwvuGJPLDW13U9C+Hd+YB/WSKWfbkWfuGGgX5lDR7cjmyNGMjzLoaER17x0
	KdB/DiagTK0GU580SlqTwdxWo37PfeynuS2Xuxtvt5t+yL9Tz4lpbyWXIwVHDdIvAFwf6j
	UDfLt701l069XkjpNDKYg6bLNrvcUvY=
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-1931ff67a29so4064143c88.1
        for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792894748; x=1793499548; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=q3okMCYlIonzi2nM46q+sdWA0XzhR4Jh1qbkbieycoA=;
        b=UGYF48goKbISIcMNKb2R0inUWRsQb/m3OziuOkxkyuihRLrjxTevwIeB+yHFp70lYJ
         qZLaFpWSscb1qOoJ2tAKBcDi+1L2dl/0tHamrZOXrWysG3MMPyXLaiOOVzLtenO1JDWe
         zJcUoPoKls0+Ueox3GvWc8XCT3spB7CPHCG5o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792894748; x=1793499548;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=q3okMCYlIonzi2nM46q+sdWA0XzhR4Jh1qbkbieycoA=;
        b=AQymiOrgr2P8Gz4aIq0roPWv52IsrbHCFgMPyk71w5w/vOkg8jhRzoIVFwvU5guecE
         x+u/eUmNV35nJke9iOK46M+07TRdf6YoB85o8c2Gv019thWxZpQ9Lj0ajF+X74umGEGT
         VWzH+oHtHXBVnwsJxybwCJSknBVBABdvv6hTKxDFE6SDcfep4cG18imgF00PnOzO8NTQ
         rwpQfzL+uGzsoYI1dkBONqeKSfIYcGahIN7R1rSItDupsd0IzfzA+5FkE86gEdJBZdpi
         0HNpSNitSdApNwJzLqJG+lh6gyS/ypjWVvMw6ZrYSZDMi027DvEh0o+F7IG934YG3H0s
         Q0Og==
X-Forwarded-Encrypted: i=1; AKwUvBzpO4WhvJDHnp/OmHq/Y4moDL5tKXGsdPZUM2YdJv8Hw2TY6izSmW/PiadN9IzPRQ4Q04EvLUTkxg==@kvack.org
X-Gm-Message-State: AFq9FYL3SQUkpX0DiQ4DAzuuRda9ETQKmVtxaSKp3cn7EFyzKWePkPD5
	5jemJ9xjOUS3O9Tu+9P6TiZWwFXBy13LvbKQcj6kJLqllT3yjQS6iKGQ+Kk0sK0x9g==
X-Gm-Gg: AYBFou2IoE+R/7IAB3/RLs+Evhuze37wxTLvsaqtnfq6a3mNDJIxMwv2D5st4WGsCi8
	57Igxgi/JWs+e/S4okNDb347/YfxT+GWJ5ubUHqkCXd5TKxWvFfmJzapzrReI7VdUa1AqLHX3em
	4PGNTM5HJ9fiHC594G3yMwHRPNGIqScZkHv7dr1YjV+kBRtVoAju4vJdoQZ2djEELLUU6kT6Frz
	sP0/7vzJ48P+eTEgOyxnJvAUueZPYjPhekvkQ6gXQvn83pSkrRYS8/jjOHAG+U5749Tu8BtO0FP
	ZtSjRw5ILbCmrPGpo3bhMM8viR0CfEmcU8G+DTyqeSxec1R1H1PzsWEQpqPJY9bylw9S5s/Y9u3
	E7y8MYxVWpd/+tItePRp9hIldWQr1k+lGCbvjo4UpFt+AIbR45TGbdoIi0/ZIXiSNwDc9NRNEYK
	dBZVqThvCqZ77cy2f5NyDSDjb6hTqzPGlNrZApE90l7jH8zFNbbYcVVlJbrI8QwsD80fS27paRs
	cUxY3bGdF094cudOofsiO2VpQE94++Vcf0qw+tSGAvLQAISWKQOQVB/Z4IJQnK9gnGvxb0sgaE9
	Co12nWfsAHvwLE0fek5kuxk24wJO//XcGU/KWNr30b2bEo/vjHuy95ENBmrNoHRFnT/qoaJIMow
	tgpAFi3JvmDud7s9pMg==
X-Received: by 2002:a05:701b:4544:20b0:190:f24b:9491 with SMTP id a92af1059eb24-19b5804d78amr2509222c88.12.1792894748124;
        Sat, 24 Oct 2026 19:19:08 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:9f87:66fc:8c85:11bb])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1989ff2ee5asm10387242c88.8.2026.10.24.19.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 19:19:07 -0700 (PDT)
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
Subject: [PATCH v7 10/15] zram: zstd: do not use kvzalloc() for zstd allocations
Date: Sun, 25 Oct 2026 11:18:26 +0900
Message-ID: <20261025021839.1542805-11-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
In-Reply-To: <20261025021839.1542805-1-senozhatsky@chromium.org>
References: <20261025021839.1542805-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8C1BA140006
X-Stat-Signature: qb7hkocrmpys8j8qsaatst36e7grswiz
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792894749-927815
X-HE-Meta: U2FsdGVkX18xbKvRDmDCbLM1T5sHGhGJdS8pDY2VO29Af20ojFgBbbWhTzgtDg/mQM9rKni/Gz2GyBURH0B4NH2IMhyM/zU31qFT2s2WMTQgeV1U+ziEvntvM7M6r87H9ozHdc+MOIbPzSHD0A6k46UJ6gQwl9P+aCYZdpyOcv8SacqFogscb8nDS7M0BoQ5EwN9puA/5Ykj3lQpiQgbziOKLo+Q653oJ8dBlGobQ01nG2EiVadXcPHat/zPsjfq0KqugzzabQAxKCaMRfXkZsqmX/Ax4Kd5/uqiO0HX1q3RnHMEzMz+dCGFynua0TI5Xk8UhzedPVIRUbnmOtJqd4TUN2tc+C2LoblYRLYbjfF2Ecg5W0LromM07kXmXM/1o4JNm840QL4vlC2JaYd612gaD3HMQer4zuBUp8MWSmMZ3xDUXL9MhbPJQBY5MsyatLoxR6+zA5I6xeAEjTTEiRI5DVoOkUEbsj2Q/pyArQDpWBDdXcnmqGESEmHwF9eLQ4+Fuh8YtnOb0R0WzCY44FNcbG5GXsVq/DoH1PGXZD24gYJLCPqdA22+sJkOQ6sD1MnFsshJxlLkB/1MKZdK5jw3br6YUl2mAnP0JHNORsxKlf9xgSWrEAM6k0lBXLMz7AjIcJjBTO90f1qEBWlT6yFSTxP3VVNZn1krbkpPj6QBRje20j50N3dimh7sLu+ag0jwnVsj+j+u3oMnPMFdeCK98ehE5kQnyg9I2d290ZOJuIm4uIqcGti7jOdyzB2SfQinH+HDC749Jjn2glp7DVvBkKsxgMRT1rGJMkJ0OTHIwmmMjYXnwPjA/XOfFdSqG3l0yqXx/M5mWi2h7SupTb8GmjGdhQyI43JaS5bRvp1a83nNdFqYiHxuWwe/+pDG4rrB9ZKC4n3bYApIJof8EqBpliYkpZyvNwz6YhF77c25tC9WitN61PQMTV8Iglf7rmOtqCcfOqWh5hzt4ib
 UpCzGVLA
 ufmIkTiGUQqtkneGBnkIb7/Xv15wZG1dW9dGQpVHdgrapw7RkRXr7k+xZhctZwaEXx+5To0H3TP/CyADTWhUWwCmb8Nt41gNFy8nE8RbW7IN7AH1u4V1hge2y5EHjlCrPh5TmpKBhmxFi6wpzvq7QSNYlHbdzoD1iozN+ESP4L3N8OmMjyzFUly9GwqRdjjwBH3J0RqIBTOtmdLTEMjf+iWCazTRvpLBVZ6opBfiPo9+INr5BHrvZYP7OL6Vh2aSS5gEz9Cc+LTuu0oA9Ik32tgx5W49ZPJpJddosdpJvzQyxnaQuR4jCyA+caFbWJihOK+/NplS5KS/w2jU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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

Acked-by: Brian Geffon <bgeffon@google.com>
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
2.56.0.257.gf7497c7d27-goog


