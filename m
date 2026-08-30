Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 626B1C61DB9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 07:45:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A3056B0095; Sun, 30 Aug 2026 03:45:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 553C66B0096; Sun, 30 Aug 2026 03:45:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46D576B0098; Sun, 30 Aug 2026 03:45:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 201AB6B0095
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 03:45:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A75C98026B
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:45:51 +0000 (UTC)
X-FDA: 85157151702.24.17D2CF6
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf19.hostedemail.com (Postfix) with ESMTP id DC6991A0007
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:45:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AY2h6K6t;
	spf=pass (imf19.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788075949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kD6ccXy2Hx5CE4BbOgtcR+UVtjcpOs3L5NimT1wEmAU=;
	b=0zTDFIKNou+wTZpybvs5C0pc5m1n3Rf2IAMFkPxdSKpxaqnigw5yB7WJMF3mBX7bDwbxfK
	dOhT1H6Eai3RdsYc1nBfqGWGPQ8tiWjLTZNl1KJPJUPw7PI82EpU2VPRKAKKiDzTFDX+nT
	YU3srD3AI5OESzpp6XVjsWYihQEgtkE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788075949;
	b=8rs4vq8SsMd6kZhwZ68Zey1wPI/dHasntaKh0XpRbMlPxo9CgSxM30jLAdiNiowGq9D3x1
	YeR2rA/yCCwXuLZQWSJm/XceDT4OSTiYrNJn6aOIcb5kgulvjLn9crxkf2NbqN+GQ+j8vd
	EFfxxSk96nj0v2aCyiDG5J4f6SOhv0c=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AY2h6K6t;
	spf=pass (imf19.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2d032846c95so25809135ad.1
        for <linux-mm@kvack.org>; Sun, 30 Aug 2026 00:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788075949; x=1788680749; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kD6ccXy2Hx5CE4BbOgtcR+UVtjcpOs3L5NimT1wEmAU=;
        b=AY2h6K6tL3hW1YGzYolIRMGFz0c1IsgTsM1KwcleEPRWymo12/8wCes4jwbZ1/oWm2
         ImMSK/hBYqBTC7R2YBAlAbA+fj7bq4VCCwhWlmks9/WIyP5mKf4e3Jugpo5Pi9cKKbtf
         cDN/WjtNBrZ8vDd3Oo7p/yUSWwhkVco6yG1KdvDYzZJkaMYNipuVJU1gjuBwgq+kDtDQ
         97JWbepOT4WgrX+KV9a2HqwQZ/3V1o1Y+dfEOeHUs+Vbd3OPGnpf7ezXBN0vEH8ZKmp3
         2FA5BLF54uFVeaC0g5sbJQin8saTeH882jkw+F0vtoYjtdkb+MAxwlZSftSbRrKF5hbg
         XPhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788075949; x=1788680749;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=kD6ccXy2Hx5CE4BbOgtcR+UVtjcpOs3L5NimT1wEmAU=;
        b=mwCnX5zGvxuGA7F8PCFbGtvi21bW8JaxlUvHSbrDsyczVb5lQ3bSUPCFKP+YTs2Pm0
         yGKcTpwNwbjr+MZi0e476tHzEp4AGQDIgs/SgDl1b/rM3A7oIP9yZcOuBqO0kinvIaNG
         GhU08weZkn6uBNK9RYSashQ5eI1PC0gVeMjKn6WP1DSGAVRoIZO60UMgNNhe2zVIiQhp
         ts9RDZID2ipBa2/FjeQY2t88OlUs4IIoVwJ/o6Mh5yigXtkWUYEp15aKSPJx/1NH4b8O
         AB/qDjuqV59IxHgbH5/CfN9/ud2zd4cEHJjPB3Aq/7KUZPjYbn6rgscjiNx7Ciy8XBEM
         ZmAg==
X-Forwarded-Encrypted: i=1; AKwUvBy6OMjEoi16zaTzgYPhlePe7JUeQeMxUs8xHIhJuAR2W8CnN5/+vnxXyc4JajucVgXpOAiNrcIwNg==@kvack.org
X-Gm-Message-State: AFuF++mrVj9QzcRpgTJVSbQEBqdOSFidXGCejZyCZoFrjijk0yYEPh1U
	IC5/NAgaK8oFvcUQrzDt/0iulfNr1M3bqSPFVfZcDVN8zvgXScMyB/KS
X-Gm-Gg: AYBFou0FqGUsKHkx6kUihPpCp+fWWE2tWBShO/E6wpPK9KUBDLROI0qc2CVUZBqDoKq
	lufHIEmFxFIvBLzaWRW5KoX5kJ/kf0k9jJRevMQrwt0b8SEM5ZeAXiI48z9qrB21tTYuzoDbRjW
	cs690JK1L+5reerbzPDF9lCPf/aRXvCVCsvXDuj1JZ7kZQTRdc2W8dDV5+w4NCph82jIPz5/7aj
	ucN/gmLGkIRg4W8B4yQRk7TD2JNIyba/itWKiEvEv1Q2+mWvlx8hli+paChmR+XJA7rILF1HHMM
	uy4Md52dTvrgOFE91z3Joh71pHpRAvtiyxYUlMJKGeaTRa2L8n1u/O0/PGQxlmsp5eXaNr+yufH
	txfxVwHFkEP5ttM+kmU9X/buNVMFMMYWHWaahuG+bvBhhrVRl6alK7xU0l13JCVK5448xWwlMty
	zIDPy5O1eiPloVuvz1M/akAOjqccPyuYMPz67O2XAHEqtEzQQzDg6oQHjjkOJ8L3ySvVpUhw3y7
	xKsYNaWc60E811PzL2be0w1A/QmWNUk7oTjtjI=
X-Received: by 2002:a17:903:390f:b0:2d8:d4d1:313b with SMTP id d9443c01a7336-2d8d4d14bcdmr164252015ad.18.1788075948700;
        Sun, 30 Aug 2026 00:45:48 -0700 (PDT)
Received: from localhost.localdomain (vmi2317720.contaboserver.net. [84.247.152.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d75988cabasm20525495ad.65.2026.08.30.00.45.40
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 30 Aug 2026 00:45:48 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org,
	lianux.mm@gmail.com,
	axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	chenridong@xiaomi.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	stevensd@chromium.org,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: Re: [PATCH v2 7/7] mm/mglru: batch move folios to the second-oldest gen's LRU
Date: Sun, 30 Aug 2026 15:45:17 +0800
Message-ID: <20260830074531.79967-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260827234704.63163-8-baohua@kernel.org>
References: <20260827234704.63163-1-baohua@kernel.org> <20260827234704.63163-8-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yjaoysih84pbpjddken9qa5t3bmicnxj
X-Rspamd-Queue-Id: DC6991A0007
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788075949-961187
X-HE-Meta: U2FsdGVkX1/fal+1gPBJ3y31e1K2Knhk5WyVTmrxCmWbXQuwykzA4kVHXgUxY90cmVyya/W/4UCziazFZURTfn4pGlFflGxC51Q60OPBsjCdEj4J/Yym+qnW0H1PTBsa2QaB6Qm0V0/zU/qnW9LhqQhvqlsJqwzBWvHBidYLFVjPuachXpQySWMuKvOrdb8kXQnqkLTeI9487AYJzsF4ldadZZgbwvQgSxhffroLcjEm3QOcsJHUUE1q333CEfwNRskNx86VljAAhCMDubtWPEAyF8suHL/USls+XHD4hSU4skXKvWGqikdkah53f6LmIw4E/Eu/f2QeVpVDAJg1n5IC/+Xa5f1io4gNWcWMMNICvzkIWLxScubH1sJMsrLtZUgPB3epluY3lEYRi3s565jbmVfbePlyAstS4meVw6zM0AS64viW0QsXEpMEmaiT4INOV/XFe7OeraHJbMBxTW1RurC7g7Rxrhnv5OdAQsFZWTY3U85LbnFOOUx9cFaV8gZY0CIh2KcvBs5QYWuWsuAveol7t/E14eFYu9aK3G3quEIr0kvSsZFN2JHJqgliGtJ1CpGz29nQctyseQ9/lFbE6EUWPFW99Pu+KY1bYv3YIWkikQ6wO2PfjuQLlrhWgqlKlqtaUVjxgVlkrkcX5eKfwnHizkSMUoK6LzksA787F1A81rvc15Y6KIug0XgwCNPrHEGxivTZ6a2CMklpisXZS5L/7flTqrqq6oobVd7HlyYVvgB77lw8HmiYT6Xj2M6W527hYT9pxCXpyUTOcuw8kKGmNll5/Hrp95UVZpxXjgINgqaUSshLSMt6xk+9F1QT5+Hce47mMGukp+SHxPZzmEbvJKxP1It+6ulqM0Ifyl3ZiZLpq9/5dfcBveeNK+ptLGO8L7gz9Km3Yhd7APU6WO0YSSQfTb7QvCOau7jnxhdtMtHOF3pcQTm7L0MagE6cKwup66F7HpHjo5u
 PQsNaJ3x
 z4/FpVE2b1fejkSxkI5ZrUor9iGqZaXWdqFQOO9jlp6Dn6dnw84jSgW0kkPxAUl/clMq6nv4WkC5JlsheN/AUIBmcxkav2IqZTw3kt/VRS2zhgK2wuKIMAsABsOxR80A727mcz1x1pPVDyDaFZdJSsObmmlKVdqdqKTparUKBf8zpfAlfg3NNrMVDirICrQaQMMBkWz4BmDEylEPFOa+kL4E4aR0OWp4VpYLGVCbChS5YK/qdMwGYoiJIkvWF0oq8IHpOGTjrsOaGjm3kgglZbPlYgPCzbnFaFM9jLfpYD4Qff6LlxXHa+ASS6OfZoK50WEDTt6TyGWtrNGl3yMbyQaOdf3WDIOQfsVSDK7Com/uAgdDApk3EoCTITnHmBDbzp4WcllvBbhP4YN4jNmfEFIk5++lvNClzw/BID3GDdljr/l0MiYOZKlBKWpkyLOqMoGhxFrKDrnBYN5SgBRoJFvuJ6Od1FUDnrPqLLAMs9UsbM7Y6C0bkJMgtTlodyWNsBpn705aEg592bKA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 28 Aug 2026 07:47:04 +0800 "Barry Song (Xiaomi)" <baohua@kernel.org> wrote:

> Detect folios that need to move from the oldest generation to
> the second-oldest generation, and batch-move them together.
> This can significantly reduce the sys time of inc_min_seq(),
> especially when the other type is significantly behind the
> preferred type.
>
> Assisted-by: gemini:gemini-3.6-flash
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Reviewed-by: Baoquan He <baoquan.he@linux.dev>
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> ---
>  mm/vmscan.c | 20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 17524e96fe64..2b6f3f05ce60 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3931,6 +3931,19 @@ static void clear_mm_walk(void)
>  		kfree(walk);
>  }
>
> +static inline void flush_lru_batch(struct list_head *head, struct list_head **batch_end,
> +				   struct list_head *dst)
> +{
> +	LIST_HEAD(movable);
> +
> +	if (!*batch_end)
> +		return;
> +
> +	list_cut_position(&movable, head, *batch_end);
> +	list_splice_tail_init(&movable, dst);
> +	*batch_end = NULL;
> +}

This is safe because `batch_end` always marks a contiguous prefix of `head`:
the loop walks from head to tail and flushes the prefix before moving any folio
that was already promoted by aging.

> +
>  static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
>  {
>  	int zone;
> @@ -3953,8 +3966,10 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
>  			lru_gen_is_active(lruvec, target_gen));
>  	/* prevent cold/hot inversion if the type is evictable */
>  	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
> +		struct list_head *target_list = &lrugen->folios[target_gen][type][zone];
>  		struct list_head *head = &lrugen->folios[old_gen][type][zone];
>  		struct list_head *pos = head->next;
> +		struct list_head *batch_end = NULL;
>  		long delta = 0;
>
>  		while (pos != head) {
> @@ -3974,7 +3989,7 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
>  			new_gen = __folio_inc_gen(folio, old_gen, &gen_increased);
>  			if (gen_increased) {
>  				delta += nr_pages;
> -				list_move_tail(&folio->lru, &lrugen->folios[new_gen][type][zone]);
> +				batch_end = &folio->lru;
>
>  				/* don't count the workingset being lazily promoted */
>  				if (refs + workingset != BIT(LRU_REFS_WIDTH) + 1) {
> @@ -3984,11 +3999,14 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
>  						   lrugen->protected[hist][type][tier] + nr_pages);
>  				}
>  			} else {
> +				flush_lru_batch(head, &batch_end, target_list);
>  				list_move(&folio->lru, &lrugen->folios[new_gen][type][zone]);
>  			}
>  			if (!--remaining)
>  				break;
>  		}
> +		flush_lru_batch(head, &batch_end, target_list);

The flush in the `else` keeps every already-promoted folio ahead of the
normal old-to-target batch. This final flush also covers the batch-limit exit
before the counters are updated and the lock can be dropped.

> +
>  		WRITE_ONCE(lrugen->nr_pages[old_gen][type][zone],
>  			   lrugen->nr_pages[old_gen][type][zone] - delta);
>  		WRITE_ONCE(lrugen->nr_pages[target_gen][type][zone],
> --
> 2.34.1

The moved list entries and `delta` therefore cover the same folios, while the
relative order of each normal-folio run is preserved. Looks good to me.

Reviewed-by: Lian Wang <lianux.mm@gmail.com>

