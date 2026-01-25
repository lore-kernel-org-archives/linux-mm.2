Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29692E63CB1
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 17:58:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 918416B00A3; Sun, 25 Jan 2026 12:58:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D6176B00A5; Sun, 25 Jan 2026 12:58:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D8B26B00A6; Sun, 25 Jan 2026 12:58:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6ABEA6B00A3
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 12:58:52 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3192DD3573
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:58:52 +0000 (UTC)
X-FDA: 84371246904.20.AB138AA
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3A055C0009
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:58:50 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LlaTttEg;
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769363930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uQE8yyzGZiePeQPVynz0h/tnTx0LJ5DrJMXW3u+lBh4=;
	b=C89BQjWIqbJ4s7P8AXdxkwWvCXArkOCKSDDroYxwByPXykDwCsh2y5sQGMVlUiH5ND1W/b
	k8IYDD+D3LSEJvRnwE5r5nOrNYVB40wTzSJFTJp7er3V026ysxaErWRbYwosYUXvTHO1x2
	iKE/pYoW85eKY09+O/3x0HmKMxETFPM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LlaTttEg;
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769363930; a=rsa-sha256;
	cv=none;
	b=4GlBiWsIfzgdo6Idv1otOxhovKBNQ6kWkXSvEZywd9CDygM7iB3AsnCjW3ctep56SFUcGQ
	J1p7LtoAiTEJmgIQot12+WAC6FNmih/lbS8oqr7T1pcXdhy1GyEK58sCNy92ZKgAtUUImT
	IsqBWrbeBDNZDqV/Dppz/QFkevJBsCs=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-81c72659e6bso3612410b3a.0
        for <linux-mm@kvack.org>; Sun, 25 Jan 2026 09:58:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769363929; x=1769968729; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uQE8yyzGZiePeQPVynz0h/tnTx0LJ5DrJMXW3u+lBh4=;
        b=LlaTttEgyPyJdiIGGibVS6SVaJMFr3w+k+cllC7f33t4wrYXHbOehE+L6/3tO7Ha6Y
         Rvr7+HgzXutuuRp7/6uXJNhoQAodoj8eO6/FXxW5+UmGGptqcDE6k2zK1Xzak3KggIYN
         WKc9qLmeUHadZvzfYvp1x6ffptcK7LRsv2jZJnluLz48SuMDB8F+P7X4ow59MUPmHx7G
         jFkBqUq31oZBxUlLr1zWUD4TdaUNEl6p7CBZoQLWvjAnes6JYnAPhPhDuBMITcY0lEYW
         MQvGQuC5yqA8lhuJjzE6sYvWR2Eb2MaEayobhbnUhVW3iiw2upuM4LuUXeBAO3humpTB
         xbxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769363929; x=1769968729;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uQE8yyzGZiePeQPVynz0h/tnTx0LJ5DrJMXW3u+lBh4=;
        b=KNNut1TbD6wUJPW4U/vtT+mWAhAtfIgSqrccoLWTzgysIe/rZZg09z3DHpF8KgIiTO
         ESfdWw76MZMUQXzI+r/ZKJs14zCgJjOiyEYLgy022wNR14gYdz1tmr0iv3TVxS8A/Hl9
         oWEu1UGmpE1T6wKNFJ/LTmP29C7s5r1kXeYaWzEfb6/Qx5f0PKTUDsNipI13xO3dGVgz
         8EZ+yUk4rbNtvcpt+965xy/N4dM8ZtFoVTBLHQJDZ50X2PA/pdUProtfN0j4oKBKmiBx
         wHkBKVwJQTCdNFvP+c1LrRiwjs+PuwSIVB10HzpHKEPPmKUzzMR+le+ip5MCAJkgbxAi
         6vRg==
X-Gm-Message-State: AOJu0YxNWBxz4PODeWSlU4d4+mKtk9Ap6OoENN06JOw/IZD1UTAI0wug
	Y1wZqoQPRBjK82uKTe9p9BDdre31zAACAIPDp/ALPgp4xDL51tEbTxR2
X-Gm-Gg: AZuq6aLIr1FYmLfm2Vrdm1ovXNSKxnSWcKjRaem2KfIX17Bn/UOBVxx+yqfGA5RRA/3
	/9S8XSnbNX7YA8s480cWJx++Y7jX8rr5u/+puqBqpqzjAzZlJmls121XisBqJdqQP0rdO6AikRW
	weMhKy4CNyz93oz46OXog0mNnRGohpK8IIbuWe41vf2znVu7GAdhx8W+/CpLK0HX2vBYhTM+qCy
	Ho7jOy9F0Fs1pYLLnj7w6tvakfwZjHAIKAeQQvrW33uEgVWBPVBC/PojUWex8RMaQr+lr0An8un
	t+7MqutqSEw6+WNuYxFew/Sxl7tyP+TPv2YYyY8wy2wzkaI3rXzmw+PVTewr6Fzwx3T3J64/Mq2
	PDFM0WNb47EO0ZMmGmhcmglDfeC+zJO6ZpUQEngiJjcTHC3nYJ3DR3W0TV+QwNvqPasyZxGMVTF
	GHosE5dhqaJ4dF1u/49Fgquy9EW7kH8J4Rr+cq024p6KSKKqzC
X-Received: by 2002:a05:6a00:2e12:b0:81e:c91c:70c5 with SMTP id d2e1a72fcca58-82341213bdemr1724693b3a.29.1769363929082;
        Sun, 25 Jan 2026 09:58:49 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8231876e718sm7405963b3a.62.2026.01.25.09.58.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jan 2026 09:58:48 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 26 Jan 2026 01:57:33 +0800
Subject: [PATCH 10/12] mm, swap: no need to truncate the scan border
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260126-swap-table-p3-v1-10-a74155fab9b0@tencent.com>
References: <20260126-swap-table-p3-v1-0-a74155fab9b0@tencent.com>
In-Reply-To: <20260126-swap-table-p3-v1-0-a74155fab9b0@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-kernel@vger.kernel.org, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1769363877; l=1121;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=pq1GjIvtpTGgHlTDVRKdCpvcoSbubtPSJToL8CsvV0Q=;
 b=9Ka7MZr9XGk+rhRF3WNsZWfQXccbdJxuFEdCPU7riv3bXTdRHYfrGVzUs1h9iEOe8efMuv2HA
 Nd2Ymw1K5cGABeXNOlAyslHx7NJ26jpo2X3rH2J/njM608lHR7SBDKs
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Stat-Signature: qodej88eau31p6s1ndgpho5nwud8gq6d
X-Rspamd-Queue-Id: 3A055C0009
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769363930-944778
X-HE-Meta: U2FsdGVkX1/8Y55G+U+GFaDVo+EnvtIYaiTi3hk1OitSh6n16i0sHckFSg+SVIahTgCAxmAVSGOn62RM2Wr2OrAEq4NoY8E4sldA3LeZ7QecgeflW6h8jEYpcZZZukBoeGIM7AiJhGvojiD54iKGOtMyWnjoe3n0Ef1nf3hXQNzQXFxQGjAA4m6F5YerZzPfAnKmcwPHacAT8SWJOeo2sCtP6WpeIbI4mqpY3g+p/lXJjfU7DUqasAOhKl2AHn/QkPKrF2Sqtxxt6Zcyvl82sMxwuqqQEo2tttCfSr/3o68eENowQi24T0xqplBNcqSEBvSKdSwbiRjq7CpIfVbD5zXTia0zSZAck3mR5K4mPyXM6y6y7QFUgeuOSaeuywGFqa4RUxKik+L6un76vdUKukHlTz5pKcXU+pmGAqYkk/FVQjTEsScxzmtnjaaF50PnsaRwh/dKFVtgsF/ide4QdbykGpnbPfd9GtUrRaOV/PGsDz9BQRRyN6JVJYMh5UzZQ80CNZCZY84ES63zmiWym5jQXWVCbD+UfuX2IMm+h13hC4JlVReucM6sSY1g5FgK58OCQZcpAXxQVgG1l6nK6+Iho82Svsg2bJEicatiesGH5zUAKbhtvKZ4E8OtQusNLHWJpmV2N9iDN6NYAbjNWANy1d+cbzlDLvJKB1MqvzN5Lvvnyxb4yyKP+ZD0wfJN1ewEgGXMgjz4Apz8ldR+Qgyd7plMZNEmyp93NkiRSzCqFbIcu8i9qsAPQkJyEuf+Zt3/tU8e1Sne0eSJ2tOhA/Fqn1JVGahszZi9aVH1AzA4g0A+RCgjTaZblIwUxwYRX3cRRmeSboLH35q5THfw/NTYqU5mklUkJ5ePCbCikfGp8uODwzifQH5O/4ljyaGcA+yG8ask4wAYaWOgmz0Y3HZfAvF24L4g8+zhLiTP7g8cdKqAdiRY7vZBSpr2Mn0b8IEOpEECIlutfQlholP
 9mGvt/Ya
 QjOVp9HH2P9hMaZvc24B59HgCPId70GgoOjpCvzjCQj9zmX0rSXse340/426vqDgqFRfnWJPLmXRlmDYJ2ctmkOMYJnwOGCJO9HsaKmmyqccqJuaR0n+sZAQO/LI5I7dxOpDR4lgNrLV3d1akYDjclbkr1ORI6dn82qXG0pxZGeQTMin9Cwp/6HnwJEnpdFSaxgZFleCm/Pm5Og7oCwkNLLuQVvpmbgOK4MKHkWN5zkFOavcwr0vwwP6eb0zyDUxT9ZeBMAkU4bN+oVhGxT2Ue+5excHRzyIqfYibhLDfA+4g6y1LPSj9lI8l/x48BnfOLtxDKM3+TuOnx0bUAmq/LIRBaLcatjnxh3CAWcrdr17xvVe8+9xU0FZCQ55sGNTmspnFtkgjl1FI6KwE2RDg3ykOXb88wI7Q+pWLKj5N1JTY1Pu9XGKPzs96UA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

swap_map had a static flexible size, so the last cluster won't be fully
covered, hence the allocator needs to check the scan border to avoid
OOB. But the swap table has a fixed-sized swap table for each cluster,
and the slots beyond the device size are marked as bad slots. The
allocator can simply scan all slots as usual, and any bad slots will be
skipped.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 2febe868986e..1cf18761c0fd 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -945,8 +945,8 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 {
 	unsigned int next = SWAP_ENTRY_INVALID, found = SWAP_ENTRY_INVALID;
 	unsigned long start = ALIGN_DOWN(offset, SWAPFILE_CLUSTER);
-	unsigned long end = min(start + SWAPFILE_CLUSTER, si->max);
 	unsigned int order = likely(folio) ? folio_order(folio) : 0;
+	unsigned long end = start + SWAPFILE_CLUSTER;
 	unsigned int nr_pages = 1 << order;
 	bool need_reclaim, ret, usable;
 

-- 
2.52.0


