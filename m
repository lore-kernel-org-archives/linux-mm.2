Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B53EFCCF9EC
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 18:22:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8A788E0150; Sun, 26 Oct 2025 14:22:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3A928E0179; Sun, 26 Oct 2025 14:22:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C50808E0177; Sun, 26 Oct 2025 14:22:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B78F88E0150
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 14:22:26 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 82B05B7E8C
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 18:22:26 +0000 (UTC)
X-FDA: 84041085492.15.71368F0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0AF88C0003
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 18:22:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZoQDN6au;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761502945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nrrszNZXjtMbc2PSFFWuoPLZpcovlTV9nYua9FLHS8I=;
	b=Pljy3VK7ooImcgmC7zumQ+4+UlyTlk5AwSX7dfXM0OczgFqVM7qvAXAEiwAres5OoWg9Zb
	VxQCPG/+hDzv1ldCsOv4Cw1Ufs+5LlSjC1Mpsh1t2XOyEk6t7/8+1suqDmVJh4tN+N77dz
	O5JiiudlAYU0KIRosIxQcRuE7N3EjSs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZoQDN6au;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761502945; a=rsa-sha256;
	cv=none;
	b=Nr1U8fzw6+Ix2+AynIcJtg+w5grM251aRnYdAb/nnBdxQm5oylNGj5q5DUqrLII0CnTKrR
	mKPQc2qlSfHuh6cAZgX04xneVhmB8hXyHnBvwpaXFlsqZBx5mgx+icWhtNJ4fTVpwVBnj6
	iL/v4rryZtyTyJVULIsJ6olGf9lT/v0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9CE2C40BA3;
	Sun, 26 Oct 2025 18:22:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E3E3C113D0;
	Sun, 26 Oct 2025 18:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761502943;
	bh=1E84e4fabiNAb3ypwhroOSlt1p8IcxO3BF19toErg4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZoQDN6au+Tg5geccepd0n5jaQo5frnLxxevptxzekhIHdri4IX4MB83uqi4rbENvn
	 mKAML5NeJN7pF0s3WvoVuSHYhCv2xH4XXY7aMOJgONt12eB0tzjNvC/oezxe0O917r
	 L+aCZCAOP1i7uv5/qr55/PIbj16bGMKZqkJKtN3Q84ZjgCIvL8y73L2tdLJzM6Z1OQ
	 lfEalv6kLoQ1e1cGkuenIeTqRZROhxn6Pf8qFgNJbmZJCNpI6XxaofEb3N8KWAbphZ
	 MnnuoeRmKHsJYL2VdEcfWmO0Vmaetk91qylNGyU/ycyXaZ7+AHV2Ohnoz+p2mmHKkN
	 U6coEcNAa2a5g==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/8] mm/damon/core: fix wrong comment of damon_call() return timing
Date: Sun, 26 Oct 2025 11:22:06 -0700
Message-ID: <20251026182216.118200-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251026182216.118200-1-sj@kernel.org>
References: <20251026182216.118200-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0AF88C0003
X-Stat-Signature: kdgeo8r7z8kqomn59kh83iebjuu95hgs
X-Rspam-User: 
X-HE-Tag: 1761502944-490635
X-HE-Meta: U2FsdGVkX19UEJcgwL29eoTy3mqe1kG3pEFIrQ4yseY+zx8F3iBK0ORvzb2m3IP1QWh6JJ9s7LKtDYRa9bWGbGAkBsGc+SmTGufQeGuETrsuKNkj/nfeOtSTjfArqIWQoBxHhr8Mf0mDAfJaofVt9cycPITNa1e+zfvs8/Y0i5EhFsJeHkwMrOrtP7ay6a+2u+FOskBLQ5/3BBuoYkva0c8eC/Bs1lI+ldc/OL9WVXW7Z15yQSK0DdDSg1e5PJShkMtaomeMjolha6yHxjhGDgpKiHcgnz9ZojyHW7Xgtc5+VwooroCRVN+6+VGBmpAcZpd1/3hMSC3Vguv2yJ37KurFLfSuClT2C1HS/RLgKUO29oIVBofwvjNRuigRXOtjn+MX/uWu0mdnUJdkiEjjWGTupasycXD6W/ZY4oeswW5ImO+JeP1emlw+XrQsKVRfsEQlSQ+Y33MzNTgxfECyzby/LeiWBvn3R8Tn/kmkf4YDRvQpn9Qr1Xe861x1OBmBJYczojKOlXYUBybGW3nrr0MqljDz2c08RNESu0DWEsvMvyk9GaDDLL9C2pTV+w+2FLNsNMDvPTgYkEWpADUulbN3j0LuJpDrsvS/XqzJz6ORnAJn2kJqQHCEJRpqBr1qOuPZu1Lb7P4fEB+a2iq+UVBLhVTjgYWUXUMEV1D10KpiPNPVGxBk35H23AZHrpH8NZ++7DemJ5k5iWKOB9UPo9EOcwuRszW4BpJnwxuRHn0BIMMa9RQ9cFq5TsmwtjUrEol8y2rqW5b7e//qzxC00FZX2A6QNhW5k4CEndmJaFIzfIAxKanwBV8IbwaXe7SLrLEvk7N1h7VuHnqP5Od2JdNkOcRhiwSoFoqcRdLOE+NE1MVPOhQNEg6m/nx6nlSE2OP3044GGT25su/GLgsREy9K6C/58ZqYeIH+oAVx+gJy2AHOeb41IPFuTON7gfsSz9x6ihUa8jT5cyZNB9L
 N9tFllpp
 rV/1E
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_call() works asynchronously and synchronously for repeat and
non-repeat mode requests, respectively.  The comment about the behavior
is wrong, though.  Fix it.

The wrong comment was introduced together with the repeat mode, by
commit 43df7676e550 ("mm/damon/core: introduce repeat mode
damon_call()").

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index d78f4452e536..06ad359024ad 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1448,7 +1448,7 @@ bool damon_is_running(struct damon_ctx *ctx)
  * Ask DAMON worker thread (kdamond) of @ctx to call a function with an
  * argument data that respectively passed via &damon_call_control->fn and
  * &damon_call_control->data of @control.  If &damon_call_control->repeat of
- * @control is set, further wait until the kdamond finishes handling of the
+ * @control is unset, further wait until the kdamond finishes handling of the
  * request.  Otherwise, return as soon as the request is made.
  *
  * The kdamond executes the function with the argument in the main loop, just
-- 
2.47.3

