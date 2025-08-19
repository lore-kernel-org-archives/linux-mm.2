Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFF41CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 06:22:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A9926B00F7; Tue, 19 Aug 2025 02:22:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 380AB6B00F9; Tue, 19 Aug 2025 02:22:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BD906B00FA; Tue, 19 Aug 2025 02:22:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B7E16B00F7
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 02:22:24 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 92147160286
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 06:22:23 +0000 (UTC)
X-FDA: 83792512566.19.A500910
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id F18974000A
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 06:22:21 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dMiTN6X7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755584542; a=rsa-sha256;
	cv=none;
	b=II4WGXX0FfVMtewmdsfTgD+uT5iA+0qhmryI2fMD5k8nhcWCDeATkDBl1jb6dyJizLWpdb
	2V0PUPcAhroUy2RUIRIGdXhWrLLSqGj7OM/VHYAYACXvpNJXk40w3sgGOr8aW4uEsDpcVi
	tYXtmrsOc+tmPJseHGoM27/a5vgCMY8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dMiTN6X7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755584542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UGKrj45hneLfxTzsfFEbqmXmWv9VA2PaaFAPFx/K9Iw=;
	b=XXP+S13UrzDaTfDU98Rmw0JIHetzdZwQKONrdhIqCBqqFMPQv1VkF9Ff81uw5GQytrzFHf
	ntUp7IRAEz+frAZ7/Am/6NlrL4n4/BP1dACkxgqEDiTMiuf+Wyxq//iembQ3NBz5HxCDlJ
	4OpWnS/As9ny3YU9CFp2vLrBKTbHGa4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 10379601EE;
	Tue, 19 Aug 2025 06:22:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E66BC113CF;
	Tue, 19 Aug 2025 06:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755584540;
	bh=3nbQrS/gkAUwokWSC86E2CAQasLgtUAgcgITiuqnb3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dMiTN6X75cP+4YuNRdwJhHmS8VD46UmR+wd5DAVqWWKRSILtGJzE4/TvX734lui2X
	 VpBDibWFhM2ExB1zHBE9+6kBFwbXvzMapkYL2+EltzQr7p2U6JCaiudL24O95atbQ0
	 OnBIyvWpF3hNLh0cn3AHgNGI0yKq+eM0b5w6NmFeIXmxG/SoOkT8jkHuXD1v6mdZaV
	 ZNT5ggRr22TZkNVBXV24pj/I7bVw0c1evAPOz8zD90PQCki/SDBP0WCpdPfn7hIoX2
	 wCaN0ETIF6zkdy7ZgNxkmpKosOXEiKAlpH0VSMJ34SKnU825glaBUWD1fODoWF4/Xa
	 SWLD6iHEn1UgQ==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [RFC PATCH -next 06/16] mm/damon/paddr: support addr_unit for DAMOS_STAT
Date: Mon, 18 Aug 2025 23:22:17 -0700
Message-Id: <20250819062217.39729-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250813050706.1564229-7-yanquanmin1@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: F18974000A
X-Stat-Signature: 3zw7wudzfedwwqz8baqsj6b6xqw4rn1h
X-HE-Tag: 1755584541-735449
X-HE-Meta: U2FsdGVkX19gI2EFKnqKxLogZ3IJSZG3Vg8+F8CZr8qXaoGMU1lP9cs83kCUFYEZH2d855GIBThvtBhNheZN68j0BdPzLW2pWusL299kVPbsQthxH0g53VWsuKBVMyt0j2ilehzMS1zR/Fv/Y4eZyUv3vV0AYgafdNy8clfzpCpkOnwpH9VfgY3C9Uqo797eGD5L2XCm4jb4vQ4Pzd9slUwrFovQeg+1mBjVluK+a1qLs4eCFuUtvjiKrkiiXxSfl9udfAMksDh07sjdSOE/qyV+yTSye5mCT5OzsEq3PSkQ+peQTfa2BW5DzvuyhQC7QYvuAEepo5lQu8lPPYPn7Aq3FGN2dVEuuhstIf/+dOnmsLpKH96R8Vfk7K/doIjE7ItfTFzSr50blUZ5iL4CTUDSQeHOmllq+3zIm9p7UZhLDxFuk4d1cnBpCDFhndB2uJTrYXFlfvlWJv/BR0i/lnYhE4XxKcrIDJo1Ki+MJT6co4YTlkdpn/H3ZdFZI6+Nn8eEhg/68sl8uC9jIOJs1FantTV/yZIQSo1wruDJzfSotEzfwnoXLong4gM1wHmeawivsUsB2lRL650IEFOuIz5K81zOutzVgnijuNTr/fQr/2GZLFoN4x805uiXRc50gH6SkuHgLoAtTU6I/Tf7QdEj5afmygwnSsrlOm025L+d7BWMiN3jumNiPsPaCyKdmxWiWMJ20dcbRt8YIoaOSNNloMueZGvIAQTBdu6E46DNAMXpF6xlvuNLwZDiznj8OFPeqPURlQW7EOpJvCNmQKG51YZy0iblu6XFaTod5SwVVb9DA50w6RKlajK5UEN4fBH9g1mnTE7MW7Qp4hJbm9xpUbvAfWiPuxAG9f8iG3A7bMaPIeMj8xJq+P5j6iDt8cKL8gOp3Xcfq7jyYoEJnjDeVyCxdqkTGWAKyW63UC1GfUkQTZsvz2WYnTgaE1G1YOGjBqD91TbjYuDgBv7
 kl0kc8sN
 SqE7A02JoCY1xzqghm+7ecb7a1s+FgvfftrIWZNAARfdbtMDTOcaJqgRX6thJcYLtkCBqNlykQ2ll/8PXd3wVe2X/BJ3PUxktRWU3uh6etsQpqgEF14pTvWNTERFWN4+31L5ZNMzQbCC7keQY6Xc+YJRNnmL3We6TvYXTF2N5PL1kFOXDOdpXA+DmEMDQZfRqaOmpiHcjXdSEpu3o0DpCCw/V3QIW7jQfCqg/LIYkOeOL7Q1R6kP1CXrqjQxSozL0QZVATUjS8wl05hBtMJ64VRaJnOR17eBAiszeTCNSbZ/FAWI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Quanmin,

On Wed, 13 Aug 2025 13:06:56 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> From: SeongJae Park <sj@kernel.org>
> 
> Add support of addr_unit for DAMOS_STAT action handling from the DAMOS
> operation implementation for the physical address space.

As I suggested on another reply[1], please squash attaching patch to this one
when you post next version of this series.

[1] https://lore.kernel.org/0001-mm-damon-paddr-set-DAMOS_PAGEOUT-stat-in-core-addres.patch

[...]


Thanks,
SJ

==== Attachment 0 (0001-mm-damon-paddr-set-DAMOS_STAT-stat-in-core-address-u.patch) ====
From 30d5bccbebe4ff5ae4d7d73ad857526f1648e786 Mon Sep 17 00:00:00 2001
From: SeongJae Park <sj@kernel.org>
Date: Wed, 13 Aug 2025 21:29:05 -0700
Subject: [PATCH] mm/damon/paddr: set DAMOS_STAT stat in core address unit

Operations layer should set DAMOS stat in core layer address unit, but
paddr is returning that for STAT in paddr address unit.  Fix it.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/paddr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index beee3bfc503d..5fad2f9a99a0 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -296,7 +296,7 @@ static unsigned long damon_pa_stat(struct damon_region *r,
 		}
 
 		if (!damos_pa_filter_out(s, folio))
-			*sz_filter_passed += folio_size(folio);
+			*sz_filter_passed += folio_size(folio) / addr_unit;
 		addr += folio_size(folio);
 		folio_put(folio);
 	}
-- 
2.39.5


