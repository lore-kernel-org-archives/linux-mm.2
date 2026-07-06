Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3A4EC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 14:07:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43F6F6B00DB; Mon,  6 Jul 2026 10:06:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CE5F6B00DC; Mon,  6 Jul 2026 10:06:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 294EB6B00E0; Mon,  6 Jul 2026 10:06:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EAF676B00DC
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 10:06:44 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 79960168B52
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:06:44 +0000 (UTC)
X-FDA: 84958527528.20.4C232B3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id E963116000C
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:06:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jQOChcpT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783346802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d/v/dE+FlmtwJgj5yRteS0MOxCozSQuxW5M8Uj1RzSo=;
	b=cVjmjWPvRmYu3gF8iS1yalNZrulDRD6KLzouvETeFoYirGzwqQEEHMgLz3c99rqm5Vl9Yh
	7Wz5vf57/iraLwyyuwndGAOUcYNNqA5pC7uy35YTihgmpYofJ4YKRIiQMbvMFsXcrok+oO
	QMPgoBg2PpuDKpLiPRgxJLW4aV27Ks0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jQOChcpT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783346802;
	b=YqYcepd9kzAPWZV882U2KkYwUzxZt3qLdIoLhzZSjTaKR+cg2hVadu6VOK3d2mqdUcU5+L
	is/CMRRhxXIBIldbydwq58JaY+qWsC/4XnmyN9l/9Ve3jlXeewjr+X+PBcJx6gpt0jboUK
	ZZyo0Rr/aKPgJnKvOWtI52ZOZf/4HoI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BBAB861836;
	Mon,  6 Jul 2026 14:06:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A7041F000E9;
	Mon,  6 Jul 2026 14:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783346802;
	bh=d/v/dE+FlmtwJgj5yRteS0MOxCozSQuxW5M8Uj1RzSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jQOChcpTl2TPuqL9zsUDGZ+EjokiOJc2Lp4UUOjGoOpJACafr4jv+G24ulD/GEY3D
	 e6qeQ2UmdhpK23fM9NNdmtACbucaJv223j4TYOfLiDCsMuR8NwexSo5CjPLAw6Feso
	 YL8NIhbGa5/6GfD/Od5elw6DycyAj3zNnEsOfkL+CU17dSVrdujevoxKZtjTuQFTTn
	 Q0iiMBIwLhXffJu59g7xXgaQIcabcA6MuWFajO7i+87YQuyLKu+YgZvHheXRvLA90D
	 OUvBwTs45z9o3I0SJ36jKKJNepVgplwYY9ANu8/B4h6hiidNTbU4rIok4j/jXyPI4M
	 5oy0VYb4dhgEw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 11/11] samples/damon/prcl: do not stop DAMON for damon_call() failure
Date: Mon,  6 Jul 2026 07:06:26 -0700
Message-ID: <20260706140628.87414-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260706140628.87414-1-sj@kernel.org>
References: <20260706140628.87414-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E963116000C
X-Stat-Signature: zdhhuemz15d3zdqubgmequcxthbhtoc3
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783346802-887476
X-HE-Meta: U2FsdGVkX19OSqfg6fzj5ZU4YjjiQYxh/FpAMsUMdPc8raropTUYPC0Tz+OXf5eTXr+eaE7/ITDzp3Syme7PQ/cGfdEw4JeYC9hrN6gjRY9zJ33LZefNEPwPBlJqSm7z9a04P/3b1eUDhFXb2KfPCgCGDrNWQbff9bNr6iTzx38+bjWJZFt5ERuQja09Bmo5Xwm5H9VG4GyGcBENyK9wR/+hL+nm2jAaDxZZb2gNwdnqAbcCwxrtRpHBxe/kim+2tQ1agueG4/DBtOw6PqNWrsoK0FtbkfpwkkW/m0m2D9bC6LnbBFDuPFHw4qShWGyuYIzrMA5gVc9PxpesS+s4X2gOzp9SZO1Uyd+z339EylelM+9fRRxcE30LJy9+xZLkYOLqL/J6Zu34XKu9paSDiFrtnnOwz/HI8oa9rW8Zla/UzqFZ6UtgfaAs7tiX2o4xy+ukmwRR28jpGuRur6YdkQFmgkur9tF2bklm2VhqiJ0yaPQ7tBPHkV0virYxEKSGhM/dpoh2PEQ+Hh1Brle/oWkx31NI0sY7k7NA+7n7LDjqBVfWYyRLDu2mgHeBIPI9idkel/9qoPYnoDa49Gm/5xYsKxyGtxJQZZSofeVVcU9deL0+TZJlWP+2ycJUKOyg0Wd50g6YxmgRFkuRANmSkOwXnOr/Zws3wl0YkKCTfAu1DobnO/OVrnOBiFsq0koJv8WBYrnfsn2Z/t9IiMIn8Pyynk2iDTzylMXmoSKDBaF1T1dlSWq/YRPRJ1nHGBiQnfV7GgCMYnvgx1rYbFTiU53+Uxrf3O5bBS+eLGGb7YlGw+P9rb0XPaUgynXL9EzNHV1SA6Ibtnck4dl452ua44Rjpwyxas9FBSeTM60Tfm/9srVawiym/iylJ5Rs1595ZfFJV5UmG9GRRW+V9z5AOnh1p6A5xxhdevDsVrSKc4/Lt6yXXcUMru6yGJtdrWrIMh4aYOX+P3EAuCRNzU9
 7BqCb9dk
 rPCPucDjk3z+NI4CFUCTSgXn5ieGl0KivvbwZalU1vtL+w9D9FPQIt4yMByCRvGm/a/4Hue2Sn/EFxG6LiYEFZ+IjlAdlsAza6S0PYDQCfW3cbRhQFXolvp8us8UrJ/v7y8fsPmvq3gid76YW/MmT731tfAdfTepYJGc2ouImcV5z/WT+8s9lVHyXeesN7zFmZuSEVxI3jeq3mOQafhK/ZHoUHPJ+vuNNf5X7tkQLs/i0ggq6cwKne1hwCIQmJHDA2GwGjsiePUegJPtfEl03jpIO7Q==
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
 samples/damon/prcl.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/samples/damon/prcl.c b/samples/damon/prcl.c
index edeae145c4a8a..842099bd62286 100644
--- a/samples/damon/prcl.c
+++ b/samples/damon/prcl.c
@@ -113,10 +113,8 @@ static int damon_sample_prcl_start(void)
 
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

