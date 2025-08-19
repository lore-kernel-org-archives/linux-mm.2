Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B076CA0EE9
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 06:24:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 694E16B00FA; Tue, 19 Aug 2025 02:24:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6455A6B00FB; Tue, 19 Aug 2025 02:24:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5820F6B00FC; Tue, 19 Aug 2025 02:24:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 465826B00FA
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 02:24:57 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DD914140260
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 06:24:56 +0000 (UTC)
X-FDA: 83792518992.26.B0209CE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 524154000F
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 06:24:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rS8NUeI6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755584695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SSiURtfjwd6UpfzDPCXCbHqlMncPzkm0YvKX//Jlsw0=;
	b=W40c0VDLW2hNFe0RjdkpakYxmqd+WdsOK3A9m+Q2ui4MKZ9dEkdHvy8WFLRqzUxW5dcMT7
	UH1rLbxYEpO5At2TLasSpZ00k2umN33n8Fq3h3uZj7IuR8UfyC2MQLIuBtH+vaz40Hxm1X
	pWtcGswPEYmtyhSUVAhoQsSAYqcaM18=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rS8NUeI6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755584695; a=rsa-sha256;
	cv=none;
	b=pzdam/ZZxK5QXqPDxQcM1FZ/diI2rWVqFP8brGmz7lIPhA0CbPB1ceWvIviPKGYGLYGPl5
	cyxMRExZvMB+7D9rkJtujACUm1mC6s0Wk26paqw/0O/xL23pHErK8XcUabynKumlZjK2l4
	n8334l3NHwsObIKgG2b4E6SdOPB6keU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 85EA0601EE;
	Tue, 19 Aug 2025 06:24:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1630AC4CEF4;
	Tue, 19 Aug 2025 06:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755584694;
	bh=PmK866isOoMH40vJFW2CqVN9q5hJL/Ky2XXJJolQ5Xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rS8NUeI6mNOKxB80MNRrzJSoFqjKUnJrsDCeqQ1DolXlMGG/qUAbmqh5kUBBydsNs
	 rSHikRGaZMsITrZgqVyLaYkDafaU2vmt+kRhrLn/+NCzCdG8zbo0UoDYLHqwVhdIAg
	 7V00GbMyWr/X1DJzAwNT6HLePngPcJ0OoCxA0NTHz91/OEUwbt9hlo/JPQRVWvpQFd
	 1mNwOScDSycp8K1wn93YeerucJeDLPifvmbXkHCTbCS+qkkLYsykWKTwVpWiywSgeO
	 fC+Q5/SiALYPUL/GAgEfQpssUt9znQK5tb8TNto7S1zlsv04MEGShJ3MV7U4h78IUF
	 wkJBnF0EAfWvg==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [RFC PATCH -next 07/16] mm/damon/sysfs: implement addr_unit file under context dir
Date: Mon, 18 Aug 2025 23:24:51 -0700
Message-Id: <20250819062452.39889-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250813050706.1564229-8-yanquanmin1@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 524154000F
X-Stat-Signature: yrkbefr5sqcetu3ep1cw53gmojz4w4dm
X-Rspam-User: 
X-HE-Tag: 1755584695-94821
X-HE-Meta: U2FsdGVkX1+8HN99Xewn2Vf4P/f6H/7WG+K/GCvTHn3NB1Kj2fmPRo13kMU4/IpLrtkDGiMb2xdr1AzEJD1o6RsK9tTP77lzeYsx97b5y3KqMB9hPmz4CQhBvkjOU1vSkUK0/N/5e2i1/ioOQ0iz4tChoGN/cN9WJqumG+LkeKTAUEF6U+b+3ymJqbj+pZgZIFLKVDplpN2hWABuEGjEGBYCrPUJf4Zl9NrYy2uswJHmDQ7CDBlKk+Z1QeqITOp3QTeJwdUexRTOQmCEHxh3wjJUb2GlMCCjDQ43evIdApRvc0f840+e+G+YXr10Ls2nncTO1jlKWlObUq/VP+sXxHEf38XoTxP+luqs8u7u91C82F7iqb2x2fY5otNwGNS1ANfLouvNLYVIi5spIXEZZY6EOVuVCITEZ1ve8o10O5WDkDB2LC9PTKq7z4Zowac50TQVQCvvWDpXnPIb7JJkO3J72Qu3HyLv2ljam2bZ05HEDwCTRFu6EBHib6N8uUam7pMGMnvTfvSWG8a/1k64V5YB26NnlV9ZUnSm6kyMTLEt1IIrfYzedf0/qYjqIyJZAAfBNgPEv84mJrmaLKzsi5zSrUl6zqLPeZcZFU8YG7IXkabKyziyVDHj+e+nRkYE/sd83wh1w0YIOOA0B0/W8VTwjzYzlSaA74WqMh9b8Rs1atAthFzabHLOwBnnzM+abEJwYEpS0R4CYjCwL6meKA/WW3g9+Ntg90tjqBtXpAS6N42JmD0/gH9ENcwA7/UySFR0zB0kAmDq1QMBAzPK138MfFOSUiAM0AJzSqBZKLRkLj5+F1ifJ6w/LvyCXWRJ3EPwu83hMDwbBpABvdhE/PsBWDcsg3J/+ZWOsSRzpKJxJLqG5gNDkCw8zR8it6diUMNT71tL3smWD+dhn32GYioGgMbOfjjshurRHCJ17cISxn1oMHi+34zMFliyta4Rm7u23bRCNNxNbk1K3vK
 DQpZh+15
 YvdaF5OiT5RVH4Xan2Q/C4hCm0VN7HjW3wC5dUMuKJ6oi1LaQvDQPCI6nmupbQo3VLDnHgwOTbnlJBw6fXyE+Yz3FbdvN+Ebt+jbmei+g2s4KS9HfTygLSym9lY5hqZiV2WH9a1fI6GwqVbksHd2Y0MjTvbRC2dsxW8F+K6Kw/EJsM/woKnx+lZrzA5ps/5Ez88j5uXcjiQAcMZl1FYqjDdbhD0EdTVqiuCRDY4yM+d3PxnotPOgOr8j+NP0mnumoNSMEAkGOBEROw6ZmYNhx7VOSAdzqQQBqHeFMj/QrzvIPaQI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Quanmin,

On Wed, 13 Aug 2025 13:06:57 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> From: SeongJae Park <sj@kernel.org>
> 
> Only DAMON kernel API callers can use addr_unit parameter.  Implement a
> sysfs file to let DAMON sysfs ABI users use it.

As I suggested on another reply[1], please squash attaching patch to this one
when you post next version of this series.

[1] https://lore.kernel.org/20250813170224.6128-1-sj@kernel.org

[...]


Thanks,
SJ

==== Attachment 0 (0001-mm-damon-sysfs-return-EINVAL-for-zero-addr_unit.patch) ====
From e0a5aa5e571ecd0f58b0914f8fc8562a60014ae8 Mon Sep 17 00:00:00 2001
From: SeongJae Park <sj@kernel.org>
Date: Wed, 13 Aug 2025 21:17:03 -0700
Subject: [PATCH] mm/damon/sysfs: return -EINVAL for zero addr_unit

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index bea782b0a711..eb4269383bae 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1422,6 +1422,8 @@ static int damon_sysfs_apply_inputs(struct damon_ctx *ctx,
 	err = damon_select_ops(ctx, sys_ctx->ops_id);
 	if (err)
 		return err;
+	if (!sys_ctx->addr_unit)
+		return -EINVAL;
 	ctx->addr_unit = sys_ctx->addr_unit;
 	err = damon_sysfs_set_attrs(ctx, sys_ctx->attrs);
 	if (err)
-- 
2.39.5


