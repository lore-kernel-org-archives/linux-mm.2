Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D83D0C55171
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 16:21:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E9136B008A; Sun,  2 Aug 2026 12:21:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C0BA6B0092; Sun,  2 Aug 2026 12:21:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D9056B0096; Sun,  2 Aug 2026 12:21:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 43B156B008A
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 12:21:01 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2B1301604FD
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 16:20:59 +0000 (UTC)
X-FDA: 85056843438.16.1D12761
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8E9EDA0003
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 16:20:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TSq0UYct;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785687657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jjY62t0IWaBhzTuKFbAdxLlz/gg8XTsDxaNCLSSWaXE=;
	b=opuN5XPL5IVpXbuZE4jxYju23ynt7q9fxQmHBBNpq105WTo4/UQQNLxFAtz3TIqMK08Qfs
	GnlUj+JyKkKpnZNGs9mKX5lsyu2pqFpr2lW48eh3gUgBJs1IhNsEQHTbwlXhGVdd4GxxpP
	ojDNs3lCLI4E9pWw91wPtCc4sLYTDJk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TSq0UYct;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785687657;
	b=rYeoN5tEwroXYw8MuJzuUo+68ycKZqy1eAueX6yfrobsEBsP2QLKorc4zPdb1H2tOrU7TZ
	/rvwqZ7+Ilccau7FAFKchh3/tveUQ6W39s3y8sPvBfNtMwG2xSXhdPLXfO2xaL3Se8ZBuJ
	GNLh7oNtX7iJfOMK32A9y30u6uSsocE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A76E640DA2;
	Sun,  2 Aug 2026 16:20:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 533861F00A3D;
	Sun,  2 Aug 2026 16:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785687656;
	bh=jjY62t0IWaBhzTuKFbAdxLlz/gg8XTsDxaNCLSSWaXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TSq0UYct4CsaLWaMcHePVWRxZ9TID5ACYmfWlfMlJRaKzXP6iN+dtu3Ddk8ksPpgF
	 591qY0pyf6QPHkLh08YiqZb2g9xJMsp199h7NLKnFqIG3nF1z92suMOM39BDiiHqlI
	 5sok9cvQifjsOQ1QW4EB2MV19BgAjTZlRSBXBDYWuZeChcdTDtWGwm8C5piKuTPs7Q
	 v9vQEymECJvEOs5vCs+mru1znHuFQEZuoGC5RqIVjYrP90EKe1lhXyfRcAdbuDNzXP
	 Wgbh/kRB31e6ECaEL5ckR+pcqgpq+8I4qpEqThvdEjvHV5iPjSPerXuj/wt00X3/ga
	 qj+FLomyNI8pQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Yunjeong Mun <yunjeong.mun@sk.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 1/2] samples/damon/mtier: error out for zero quota goal target values
Date: Sun,  2 Aug 2026 09:20:48 -0700
Message-ID: <20260802162050.89477-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260802162050.89477-1-sj@kernel.org>
References: <20260802162050.89477-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8E9EDA0003
X-Rspam-User: 
X-Stat-Signature: omfkfbnrx6ksy13qoso98z1rhj73zbnb
X-HE-Tag: 1785687657-718673
X-HE-Meta: U2FsdGVkX19ktrv7O/y2E4ukGUiQiU+YDmCg0u4BjXEyq65T4PXmN3FE+MCnAjrdkZlHil6jQuX63BLx8Nt+KCIDpSvmPLlwT3nX2+WAC/sTgukKo4AMgwY9KsCAUkMoL6/ccAt+QFVv6iwLfw8Fmn/o2yuiEWI3P6rqex2ai0/47hp8ojJjoRupVvX5vEr1uN8SW9i3Xjt6549bg+vEbt8T2JxpDkXQt3zGKukoElKQ0oZrntdWEcEPo6FEoKCUi9MRrYDM6LLyo24AqJ+vGpZuuuiWoH+erUOwpZlfNBD57M9sImui8eChiTYYw1tQeQRwUivS0ikB0C+A+NbBcA2Xh0mmFUmslHXaR/bgx7q0ohFXdb5SU8loF5+9CZKFoPFb8qy/k+cJF3NSIpNIEntO/okIsCMH5BRt+1e2cJAa8MNUqUpab1OhX62keRcsBVneh6Ob8Ts+oiqh8TYHLPA2sVvzuO462BclXaDVbU5zFV6nAm+XP9gz7BGRQCRLJwuSPQJCOM/QBU5Mzby8W6kYm0YmyzcZG5TJNzmLY+KU9xTeMjLzAoQ4l2nY2l7ycLrGifZv+a9VWBQzi4f/RGx/7Hgo+ItGOIF3qKoZLT9IrVGObCIfPTVfwXmI77qfSG8iJeAOtS9UJdAYlZhf2upvbN26JOnuaxCLILEWOzlJNKYpLE3mr3ql0Sf8kiuB8LMANFzj2J1LbuzFa/ZAOuEaEFqrHzO9Vi6yp1+vg9zDNpe/IuztJuWtOsIQMcjsBPLejuZeVEgE7Nz7ajBCicizL1dioaKgwCYrrtQ7xhiwSsNDi7TJAXV4+6Be6FfIWuxMz6XUtAm938cIeHlfpLvTJLP7F6iQt9Ruwc0xnOLoZ5ZZJsBKzuZNbe5HdMtoRmw0APLVNCkjFqlt5NUi9azbzHXXTiAPXdh/0M0ISbtNeoR3W3WkJQKjdFwMLFD4cNYsfrT30Esos9U/ufP
 cq1AdWrQ
 v5GYi4qSF1RFbksCNFzkM4fcXAKb+A6GCw1MvT+wmTp0cn+c/JbZYvClMqUJU6CIsr0kvJtQ8TlDvuyAngGM86aQ45zYMKVGp3+vECw0yfU8Fhw44483lyQ//kvgFiWZfkLuUnQqO89A6qeYwA74PnR0ibIsaIEtzqaWnKTtApk99r3nYWmYx6n1n1UvTXpSQN3WGGynnC7CQpJpOKPk7u2s6VTJXRYCospzaowuA0hxDyTY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_quota_score() can trigger division by zero if the target_value is
zero.  DAMON_SAMPLE_MTIER lets users set the target_value via
node0_mem_{used,free}_bp parameters.  It doesn't guard zero value case,
though.  As a result, users can trigger division by zero.  Fix the issue
by returning an error when the user tries to start DAMON with zero
node0_mem_{used,free}_bp parameter values.

DAMON_SAMPLE_MTIER is just a sample module, but the consequence is quite
bad.  Also the zero node0_mem_free_bp parameter might look like a
reasonable setup to some users.  Hence, the issue might really happen in
the real world.

One reliable way to reproduce the issue is like below:

    # cd /sys/module/damon_sample_mtier/parameters
    # echo 4096 > node0_start_addr
    # echo 8192 > node0_end_addr
    # echo 8192 > node1_start_addr
    # echo 81920 > node1_end_addr
    # echo 0 > node0_mem_free_bp
    # echo Y > enabled
    # dmesg -w
    [...]
    [18792.235916] Oops: divide error: 0000 [#1] SMP NOPTI
    [...]
    [18792.242787] RIP: 0010:damos_quota_score+0x6f/0x480
    [...]

This issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260801202657.117135-1-sj@kernel.org

Fixes: c5e67d40a102 ("samples/damon/mtier: add parameters for node0 memory usage")
Cc: <stable@vger.kernel.org> # 6.17.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 samples/damon/mtier.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/samples/damon/mtier.c b/samples/damon/mtier.c
index ac9c24b92ead8..d1123ebbfab90 100644
--- a/samples/damon/mtier.c
+++ b/samples/damon/mtier.c
@@ -156,6 +156,9 @@ static struct damon_ctx *damon_sample_mtier_build_ctx(bool promote)
 	if (!scheme)
 		goto free_out;
 	damon_set_schemes(ctx, &scheme, 1);
+	/* zero target value causes division by zero in damos_quota_store() */
+	if (!node0_mem_used_bp || !node0_mem_free_bp)
+		goto free_out;
 	quota_goal = damos_new_quota_goal(
 			promote ? DAMOS_QUOTA_NODE_MEM_USED_BP :
 			DAMOS_QUOTA_NODE_MEM_FREE_BP,
-- 
2.47.3

