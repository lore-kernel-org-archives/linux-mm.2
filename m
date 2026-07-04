Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5381FC43458
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 18:12:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D49D46B00BE; Sat,  4 Jul 2026 14:11:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFAD96B00C1; Sat,  4 Jul 2026 14:11:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B74786B00BE; Sat,  4 Jul 2026 14:11:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 76DAA6B00C0
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 14:11:50 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D844D8EE7C
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 18:11:49 +0000 (UTC)
X-FDA: 84951887538.15.9B43C09
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 620A0100008
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 18:11:48 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kgXbNCGO;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783188708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uJKL9EayamVjhe1Npp/S+XhWMj93f4Odi2+yyGbNAgU=;
	b=CAmGeAIBqDnvpgPPW6Nv2WIoFYFPAPR+D0zogTmNmmT/oLxhbGkE6edNB+RmlFjdSDMxR3
	1CbsRKfljzG7p9e/Z88ew0LYJG+HgvHrfFCXe5ydtXyAL5l198I4xUOL/idhYagqP7kBrB
	YornoNOHkW9erWVZctAvByrBDV4inOQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kgXbNCGO;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783188708;
	b=t93HCTPRqgCTaWOQ5Yu66HuZOyCDk3MYrzVcqECSzDckZDdx9yC9qOoY09wd33+OwaXs7s
	ge3AoUOmdGkvokjds2xcxgoxYXNMPX1hMgY0i/6LrlU02Cpnedyil0hFTxvfX8FQZDFQyW
	54N/Gs5AJyW2G0ij4qAFZGe/R1gox10=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 09C7B61370
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 18:11:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B11351F00AC4;
	Sat,  4 Jul 2026 18:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783188707;
	bh=uJKL9EayamVjhe1Npp/S+XhWMj93f4Odi2+yyGbNAgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kgXbNCGOm5ALXRQ8EPPQPiz36VyBYekMMbNUnGoHo4zYOoY1e67anoLPe3EziZ8yQ
	 ex6x61jzDw+WzBY+GTMdkZ7EjnPoSSoRwbpdHr+gWQTSiYgdJog6IvwfkdgojHZJhU
	 /4Y3Ke89nj0d/xW+e43ePUZaNolbZP2GVrIhy6/ICp8jmWIeeVehZue7EgsONxFEno
	 6F+QbLZIixiRKHVCCqmMg+qSkHbngWX4noKnF3yjVWvELXeeRJtp/rMrxUNcM7HzG/
	 YEOTJMqywJwZf6Djwmmn/WQYzXTYqxHLcxg9WuElDj9z/om3h07t3nlst+LmtQ1NWZ
	 egFMuSQHsnEYg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 10/11] samples/damon/wsse: do not stop ctx for damon_call() failure
Date: Sat,  4 Jul 2026 11:11:33 -0700
Message-ID: <20260704181135.132956-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260704181135.132956-1-sj@kernel.org>
References: <20260704181135.132956-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: oo4a9wmzi63ybbksj9xs86gzb8xy1n8p
X-Rspamd-Queue-Id: 620A0100008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783188708-624362
X-HE-Meta: U2FsdGVkX1+InzDxIyagrR2rA2g0ZvMj7MOOKCTKRAV4WvxtFy5Y+ysJhZNnimVvlN6XGmT3eHB71+Bd11pGeYHmITBflhAAja56aCrUXg3ZaovkOBCV6J+FEKC9a1r01SLQGZcASKtXLCJ73p+R97dn8I+9zIeLuOFR6DeOVNbNvj0QIu6v8vcHGgFURkcua60KW4kwMXXLKNp02/k8fSLjP7A8rGY5swH/HuGOahJG3CPyWnA9oa91tsXcpDXtkJnU5M/69VAzDpllkt1W8bWZzDLgTQDtcK2cONYjAsxDmjqHnFTcX93+xIAyQS5jJsS3+uVb2gaVtgldAyVH3PeboMBqrYZ4aUWZzU+MpT0vLt+e8Xb8KRbu41/XbL2Mm2B+QQTfnAdGkAvc2Muxt5e/VZG5bf9XlKjDGSBjDSAzGJTCzUEJpNcXOQDzqc9REaTdQzzdyjlutlyTd7Yb3p98rgBzV/rxwC9rX/ygl/UDOmENlfCiViyzQDhk3jNxfLYqYWmMV6Y8IrVQTQooQgadmc7KIC320EhxcYsGK9hRzrzSUSLiAMDpD8kH9FguvJpKcQwW2nWRRY4Mjk9JHmmGv3vFrc9jl+94Rm0DxIwNVPpNPf2tSwfdtIoIRYRGAOxtw+o3Sh1QKY6EQF+PQmQZQhixQb3JHjg5mmgaPt1Dq3Qatyf7ZtN1yWAo6nFJp4e0wuy/vTNwyhdLn2C1TA8V0BRd6w6D0Rs3PWpydOBWCkmuCL4r8lZj6mOthfCLA3Irk4cftbXbjO4MFLr+ILrGC/ZeWMbMySeFfNigK9+ybmZ2yTj/COA1YG3ZO3pX4JQT27YlitoGoquMBIga1nr4PJ99pgj7rAiaVnOR+O5++ybUEl5iQO4bhO3C2k3l369Mivtun4UwIVeVDxKaSO/6tuY0RnW//HaS5duRMw5/WC7cuj6tV/0GgIVEUiz7ftaGD8DcXMWHkf7QgHI
 bMh822SE
 o1nobKZ18B1EhMmx4ALQt4kAQsajQjZvzHR0/8ax1w1P9WKU83NQXLYPmv88uh7cTTu8SlTk3uDBQaPSc1XnpcfsTBk+4CKlk6W1V8RQGoMNDAdSd9OIuJ+9CNwRWedUzmQjUSTGSM8x9WU785gWVZ15Cd65hHWrHFUcpVvnLdv0f15KsuYwsJeB0kx1peUgg2nO/WfDmmBCWkpy1Dn0J4cMCYPBsozxBfgEDhYHlXkxioM0k4tyYoJXk1NlUlsKib4HB/cDMu76cErvEPnmEip70b+d/s9+4q+8vjMgECpLSY8VbumQV0u1Pzcv/DpSllR6AdLyttoycXHVl/5JlMQafhagBJG3amWuA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_call() failure was causing the context to be stopped, but
asynchronously by the kdamond thread.  To handle the race,   the caller
had to stop the context.  damon_call() is updated to do the stop on its
own.  Remove the damon_stop() call from the damon_call() error handling.

Signed-off-by: SJ Park <sj@kernel.org>
---
 samples/damon/wsse.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/samples/damon/wsse.c b/samples/damon/wsse.c
index ff5e8a890f448..37fd5da201588 100644
--- a/samples/damon/wsse.c
+++ b/samples/damon/wsse.c
@@ -93,10 +93,8 @@ static int damon_sample_wsse_start(void)
 	}
 	repeat_call_control.data = ctx;
 	err = damon_call(ctx, &repeat_call_control);
-	if (err) {
-		damon_stop(&ctx, 1);
+	if (err)
 		damon_destroy_ctx(ctx);
-	}
 	return err;
 }
 
-- 
2.47.3

