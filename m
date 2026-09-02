Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56CB3C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 06:14:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 474496B0088; Wed,  2 Sep 2026 02:14:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CE526B008A; Wed,  2 Sep 2026 02:14:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 296FD6B008C; Wed,  2 Sep 2026 02:14:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ED4B66B0088
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 02:14:11 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8015F8072F
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:14:11 +0000 (UTC)
X-FDA: 85167807102.15.73840C8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id BE48320005
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:14:09 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J0HEzdLc;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788329649;
	b=DLe1ExQa4gC/vm7uHFUZi1EWbV5uog1Om3cKtXlxAq8oZs0fDT3aXYnesTVynLoRckTePi
	lKYAipRqF7c3v2iLOM/cY5EzycUaSitxWNA+ZcePHmRBrKxLKVZlwZR+8S9cR9SeGxvYUo
	89+V33KSAkhZ2VtrylpOE0YCHKB1BN4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J0HEzdLc;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788329649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K5x2CbYRmNV3MA8rM8UuqBOVvPVm0QxSLiJJvUd4pl4=;
	b=UmzyX13JQmC/Uo9aLsThrxQ2kRiIVTXzI30ZfVDb8iwkou3MZiropKpiq6prr3AIsg4M1n
	NJ9k6v2GSxTJx1rH/X+dE8PdsCW7zoa/qq18ZHA1ZSys8Ol2HxGrgweWQkcRa57b3lZ38T
	O2KlQFGNqEyv0QuIUMRuSNtjV2+krV8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AB58940A8C;
	Wed,  2 Sep 2026 06:14:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 672511F000E9;
	Wed,  2 Sep 2026 06:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788329648;
	bh=K5x2CbYRmNV3MA8rM8UuqBOVvPVm0QxSLiJJvUd4pl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J0HEzdLcQyh+gjzjo4CoIOYJFrANeLY4gXMg1LyNcjFr6rWcrj0m/Hafy9aqPlCSF
	 ALFYGKLVhJmI+q6ot5Cvvenug3O+vhPsA5Dig7YijlgHp48jO1apupvCWM5RxwsPR0
	 ZSmAYVD1chgBRb3d4X+RsEKZqmhvo0CQ5h1gNXbLTMHitAkbG19K+nc/GFekZmLVww
	 CZRdawX6Kt4Qdf4noDfuKuFk0CoGYSs4ghtC2riWMDu603LGfoKn6YxOve03JgNrgD
	 Zwttkptd+C2o5Nk2KWES1+sZ78juWyiHPYDlVnZHYopac3ztyAQhZKdwJrgKdp7thx
	 xte1xVh8i/GBQ==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 02/12] mm/damon/core: remove debug messages
Date: Tue,  1 Sep 2026 23:14:00 -0700
Message-ID: <20260902061401.104419-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260902054747.99370-3-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BE48320005
X-Stat-Signature: eyrt7cyhmar64hmncycfaiei5t1szqmm
X-Rspam-User: 
X-HE-Tag: 1788329649-493691
X-HE-Meta: U2FsdGVkX1+bG0iQiTx71g8nubHJTSLODHGo+J8wSEACXJrxcpzYeCOdLhRj0qw1hUfbt3fseTCi1IAJpiocu11/Z94K61MFfJ82UNFYSLVcry5ebSws0UxXh4VBGqRq7wW8Ejo6GL4WFOG7vGpi9CYCKcildQVAnOBuN0eKW50DKgcm9eukKxjqk5TvFdY/mkAgJNaEBtvBB9yNFTp93K3AIe+H/qYieppeI6xNOAIsV6ki2dk+q0KQOY/tAc1z24Q6T4LpD1A7aoCXiW0BuwyFRpBwkxI7YRpMXZdqdY1nmxTPUrUkROPAimtyMYxzWwiu6mLreax04PXN1HwUPSxqfSKWr+Ca7g2JlaFEMRH5Ni4/v4vxw1myGThJnW9ajdcEITcKTKVLPhX1TvF6TRzcTFy7F7Azwsgrer7IsbQn5jX4fxlLKsr3ITG3XhehM7Uvp/x7B2pBEWzSLsARRGE4mdiDIaClY0XBxNapmp8i9f6EvA/LE0dUuFgsTZjyO1qisamk6ZkjJAErXs13aWzqNgbZYWN2ZrXgdusS4aiB6idmEZrWVbHBOzdiG5G00iSMrwvT1brod0XS2OJ3djo1xtQpF2yKXCyyziWftCc28QqfyJVFMflWFQn1fRFrnW8Wy2h8xIsTTO/OfoZZYureGZf4WM1uSY+2wiIDxXb3IL2xeNuYdfMJmHlutW9V1RAp8vlJkRe7C2SkaeLoQyMGbhkryPRGoHudH32C3PEylcOGOjPP8cPuj2Tr3XjE3FPng75udElPbttg1rRtX9TpVslZ5LJWN0ctOke9+WHZVRU1x9h4XVUe4hM5Z3MseW68LurpjVsayDneDwCofga9dXW7Vaq7mpYbTv2sssFSB2hyKmdsSlHYJcWwhguUJE0BD6Iu1AvYdv020LSKuNFfw3B2K5RFC+A22tqpLinbcCmi0XDu3OgnGFVQsd4pYGOYsv01gBdmtu3fdt1
 RXbIm3is
 Oue6hW2P3TQiImFcX0eds0LQIEFj5o8no3c+Yal0q5iFttu0/+F9/uvpuWXCD5HemvJcmUxoMU/LHEADosCQQYS2TLA532OZjF3J5miiJk6WpzYJqcew7YK9Kml7qxLafiGR5jZxLMV7K8HRrzXOD7vZz4jrzT2ReliserZTQ2tevfI2qp6ybd3LUgc1og/mxsSH8xJEgmTol3wrBlp4lZHLvm5gjcYZmgvg5CyjDYmTVuppTG/kSjj3cU8Wsn1omH5+qynX0YP3VhPg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  1 Sep 2026 22:47:35 -0700 SJ Park <sj@kernel.org> wrote:

> There are a few debug messages in DAMON core.  Those have not really
> been used in a meaningful way for the last few years, though.  Remove
> those.

Hi Andrew,


Sashiko found with this patch, string_choices.h can also be excluded.  It is
the only finding.  I guess reposting entire series for the small change is too
much?  Could you please add below attaching fixup patch when you pick this?
Let me know if you prefer reposting.


Thanks,
SJ

=== >8 ===
From b9c86e50efd30bab8c5cb99b3063bd823184b033 Mon Sep 17 00:00:00 2001
From: SJ Park <sj@kernel.org>
Date: Tue, 1 Sep 2026 23:08:16 -0700
Subject: [PATCH] mm/damon/core: remove string_choices.h include

It is no more being used.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index a7ed7724c85af..84f6bc634f377 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -15,7 +15,6 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/string.h>
-#include <linux/string_choices.h>

 /* for damon_get_folio() used by node eligible memory metrics */
 #include "ops-common.h"
--
2.47.3


