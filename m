Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4BAAC43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 16:02:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 045B96B00B8; Sun,  5 Jul 2026 12:01:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8DCF6B00B7; Sun,  5 Jul 2026 12:01:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D07496B00BA; Sun,  5 Jul 2026 12:01:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 95E866B00B8
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 12:01:58 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D4B82C04D7
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 16:01:57 +0000 (UTC)
X-FDA: 84955189074.06.F124D85
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4618714000D
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 16:01:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j44vOO7k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783267316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uJKL9EayamVjhe1Npp/S+XhWMj93f4Odi2+yyGbNAgU=;
	b=8JDrJ7kYMj3zG7uAEdo/CprXYQiLra+Cmm6e3F2nKGX0EIzdT/xQCIQrjPCfNrDTUgoU/p
	hp+mJAuRt90RDMGaSIcXuK0qg6Qex9xKOf6+U5MwmiCul/hSwrI/d12PpxulOZ/HIq/QHH
	mJusO+Wot4moVI5g8un7CaFEw1eycRA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j44vOO7k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783267316;
	b=z6ZRVb/jIEv6qUJSxIsA6/XtXiFSriGFuo085AkelDiotESPaOGE+NALHwPodlto19UiNG
	FjxNV8TndJLjqmLK7rEe4M1rutQM4pO3NoCvZztWCprHIFfRGgyo3SqLZNgwORXQQtl32k
	eoikgDjEjtyM9Rl19sI4LVqY0VAE5Y4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9826E43C4C
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 16:01:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E79C1F00A3F;
	Sun,  5 Jul 2026 16:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783267315;
	bh=uJKL9EayamVjhe1Npp/S+XhWMj93f4Odi2+yyGbNAgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j44vOO7kQjAviWEITHTfruBjxIkGUmjYfFahmebFenaPcWLmgkypq6CaixJw48xUk
	 gT1udXlgeWutyObvHy7QbGSjS+wcn7PnmNPC9c3pCpCj1MCDFaT9tGGuPki2S7I0Oj
	 ddfYPk4BIrkS0WWa7u6xC+gfEwGVngGKk7W9/QCI20/21I5FW6K6HZQi3ScLpCpfqv
	 FoLvcVTwHIbKDFwte9mzin7gLhSp+77/tMRVGJSDUHZ0LVzjaUsko9SuB/bCKZsD0Q
	 qw0aFibpXm+5R9YGdGnLYsWF9Kl3reDBs/+RgJagFZbhYq28OjlWWOkXg/dir5/9DA
	 u46JbaVm/b7ww==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 10/11] samples/damon/wsse: do not stop ctx for damon_call() failure
Date: Sun,  5 Jul 2026 09:01:37 -0700
Message-ID: <20260705160142.97308-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260705160142.97308-1-sj@kernel.org>
References: <20260705160142.97308-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4618714000D
X-Stat-Signature: x7tefsahgrwb7u8gy41xqu9puxczyu6s
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783267316-792488
X-HE-Meta: U2FsdGVkX1/h+yxGvVNe/Yt1UTIJ3z6CqMCnXPwi4qOfl+3kKsm7n1d89JdCEJlq3vV5Cay5cqlZQQ8dyJH4QWmJLDIApwudUR5V9FyQ8Pr+YKM4kAYhvJ5NIQSIs5zZZS7lm33NHWsUQDH/8hG4/Zm/QxXjP39M3SxLWQolMn61WrHWHskbGKUHVdQEYATLrlXJi8PhiWuzGEP9WSGXYn0c+T1xY/hhvK1bLM8yil4CwcfRk9TevpBwAs3ZtfTs7f5wh4/a39Gup/28C0L8zXaaB6cOMOubyoHLz3MVcy8BSXH3YDRfaO7H2PN4iJK34mHjR/WqHerkao0BkpTwLqGe/rpB/kFM3s/9rBnpbe+eEBLI/7Ve4kZy+ZuDOtDQeSWw8J+I71GJWyI0FF9lDq8R8ZRhZ7Vqcq4Glrcd8M+qafxS/3FudJNXiepIylnrNzFsKnYhqMQGcnr3c1zuhS9RyFGJJq82TcoT2swWJ3Tc9M9Fp2yah1BGt9xVmBKkqrwGEQRfSkZ8l++c+umxkLI3PmXsy8NFxSQF/MJ8mxDSZT4BAZ/yOnglBL8QQTYuoGVyPVkw4ScBWcjVyenPd7Bxu1pVR31S7ruIrbdokVppcyBUqIqoSgXTZPZqpht8Sc29GTqriWDcUR3qmQZcDb8U3T2oWWWKRCBplbOiZrInrWyZ9BT3gXelxtpiFzPVfUg+XzAQ3wLunj1ofIroYCJX/kEGWBWGBJLlLSrh5dG6fCVTxc4hfwWYhAlqLct9rDOk8NCKIWnebJGdJ2CGCpSz6nrFHFaDwuEoehIVbth00y74WMenTO/POsO1OgjEWpWJG+lFdHhQhWbsj9nPSCYi4d0kbeQtjtm9EVrc0EACkaqwE14xIrWhK5KidB5siK5tFpgQKN6XG59FHnwEPoihHsmOa9lJthUe1LdIYMjAMVYtrEWFrATtKxFmLc7se9lFbuuVS+uvDQ1XlcS
 0HXvvFYM
 tjFnmbxZr+iV6PUFRCarbMtlIYOagxqrZMRpFKCtEuslouhdssmAvQFk2QqQW+52Eh8cpkT071nwMtH0ZQ6AK2D0o9ZwU4k4wotJUHMqalnuGV7yjYkFq8DUVKyrcyaHH7zO8APLhd6hVtexYK9sHqRkJfVx+jt//27Ff+ZnnXieNYLlPGnuJMiMnb2pMv+N/pWC08rmfoub/7uS31TrC7LbcY5my3wS7goyG4BOVROvX/2fNSNTntnY6fyZpinlmT342GwgArPnK/x3KW2+seC2INq96michvH6lLrfx3uNg2qHugWpCvzDEZGbOCosCtpX1jEsBI96VD/3g3OIQJK8bs8zV7GZ8gI5N
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

