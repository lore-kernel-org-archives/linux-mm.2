Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 989BBCD5BD1
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 06:11:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE48D6B0005; Thu, 28 May 2026 02:11:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A959C6B0088; Thu, 28 May 2026 02:11:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 983996B008C; Thu, 28 May 2026 02:11:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 85F5D6B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 02:11:18 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F23ADA04AF
	for <linux-mm@kvack.org>; Thu, 28 May 2026 06:11:17 +0000 (UTC)
X-FDA: 84815806194.19.33A1739
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7BF691C0006
	for <linux-mm@kvack.org>; Thu, 28 May 2026 06:11:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c7YGmvms;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779948676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=uGuuTi3QEXHp4Ch0W1P8wvpFXg0lxffEiocLYQhFz+g=;
	b=Xd2KPSLr6tXGbZlZ78Cw/swQz+hA7Zh5zOaBn+87eVU3akqsWkXcMCLG+Cbi6Vp9vODSrJ
	1rwFZxIyZj/eLETixuIcv5shu+pXbMRQbBwa93Zn0sAyIzshf9J4aafWJ2S5xVty9e0Ujb
	Yi/CnNudbdVEFXMv3/rqeznkXJGXBkM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c7YGmvms;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779948676; a=rsa-sha256;
	cv=none;
	b=kC51THj8CACU+TnEqBPBROKXlKs9Cm2fpqP6mph9Q2kPLeYFYadWJxfpApC7NDRKu6weBm
	L3+L9Fb1DTPjARTbrat9tL5askJ7dChkn+u8UWSJknMFy3FYauBonQSBKn583febo9TIkT
	igdpYr67CChcpbCppHfYKC3j+Qklmew=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D9E8D60103;
	Thu, 28 May 2026 06:11:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F01831F000E9;
	Thu, 28 May 2026 06:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779948675;
	bh=uGuuTi3QEXHp4Ch0W1P8wvpFXg0lxffEiocLYQhFz+g=;
	h=From:To:Cc:Subject:Date;
	b=c7YGmvmsEqxOZKvXhcQeMe4CjW1iX6UE5jFAApLcOFOiTQnmFgSUyRi7fY9R82ipr
	 hDZavK8E3ZJE3cbHrNupUy8ZtHTKKhPE8zJM3KkGmVVNj+srGMENb57MEuIY6NmOaa
	 qNxQSC1HEanFz13tDhMHmcNNu+PX3/hdpSlaz27B9+XqeVB3z8pabCrV4bHqOAzx5k
	 GYBb2m6yNpjsZX1dUoVOcY9h5HTtXvrWbua+z3syZAM4LUQXbVDI+0jfvGTx3w6Z3x
	 jTntY1iWPSdO169TGCE0Ic6S3Z/EIwiarfHXcVa16KrUZsJLDotfhPrZOpp3vBpqPD
	 PvQoU51GprsmA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 18 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 0/2] mm/damon/{reclaim,lru_sort}: handle ctx allocation failures
Date: Wed, 27 May 2026 23:11:07 -0700
Message-ID: <20260528061110.2172-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tha6ihmtm9wqg3tsizn1kft5k783fpxr
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7BF691C0006
X-Rspam-User: 
X-HE-Tag: 1779948676-783713
X-HE-Meta: U2FsdGVkX1+pV7n0W4JJH0fxd+KRMqfvh2gescUuUd6dCc/ikBovkRFVSSzlwKV6KmUZHy5F5FcYnEzXArXGF2iUa8Ydm2E/8Rz7Qr1oazUCNBQz5TUdNLVAfjrklCNXUEhZ8jxf+jRL6qqJXBhdgHo31Qn20W+83A6bVTRHgglQcQRCRksgxmgrteCS3EJqaRkaG+nq9er+eDjzvTwV8zwpBJreSDxW5k5f5f+ip2lFctgeWmvxUJbTm4FyKBzJEfUmFaWPIoCpwF2vUuuDvT7tMARln8CZtD2nFB+M1i89QuW7vIbiEK+aRd7Ys4vdtX9VraOYhkO0jk9EcYF1eoIzKBArGs/aGPhZMQNAfTFAYEPdhB8cCqy3a2zUsloAiJUh2/IgX+mv0a3Kzb2Aw6gtSiNGOfPZCzBX+bBL61fdLs/Pr3B3/xn9Bt16N99+7DpnLKZFs6rrbo+dr0Atu0/m82hop8qZP9nNtGBP5B+Xh2CalRIl3MQ822MJ2nFZh8sm5SW7YRWUOwCkL4p1Qd6xlk8fsVb4VEJahRQouqOfgfvVeFgIuRf9o+zxfO97Nl27Yibj+XL5Cklgq4uaefaOfui5QMMYGlQ599GVAc7pkfEpBSt51z0oLSzJEOJhNgeRxhCSX+tu3uTcNGesUJkGHJ5ZvFJ/2+Vh8Gc2AM587uBoIJsmNhzgVPZX2XBfhvqBoWJz65VokNQSWfQ9uCo65LsDRJnHp4ObWKVTxrogjBWed+ekZuulsBXk1mVhtyFncs/z6/qtA2i8iA45XS+o8H4HVZGU4pT3N29L41ZzPlZnZh4pgg5DhdMe4Z1zDSjHh8ji8JfiA8zLl2SoLl6jLLDzkDlWaT7gwToqezDQffLLOsd/WSYGGzcOgMT/ijUbbkFqjTcq34d3id4erGuobDTfVKlhUqqawQ6TAEa43/QXXOseFedqSHh0xqgVzzKqM6dpvToriXTpOfX
 X04cYdeX
 q0YKoJ3j9kNp4djS0nNBVpKqu480tLR4Fe6yIE+E4rFKG6bR0UNiWuk7w5oBNdu2MEKX3186sEcAv+6F4BX00a7i/iGmGv6fBs6SGZMCHF1OLhih65FgGL7C4g8a8JxwlyLwlubT/mDWdZhBE7fwpvRHQEwyGrPrPXbpk5hSBBm0O52HRcf+3BpO+7ItYdxRnCuaBFEcfx7ncOPgmwMgF2plIz5t+RIEgfhvTWvIoR3wm5J5vfifuB5GoTQcJqRBWwflDiQgTCVkIh19bZGTfGQHaHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_RECLAIM and DAMON_LRU_SORT could dereference NULL pointers if
their damon_ctx object allocations fail.  The bug is expected to happen
not frequently,, because the allocation is arguably too small to fail on
common setup.  But theoretically it is possible and the consequence is
bad.  Fix those.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260419014800.877-1-sj@kernel.org

SeongJae Park (2):
  mm/damon/reclaim: handle ctx allocation failure
  mm/damonn/lru_sort: handle ctx allocation failure

 mm/damon/lru_sort.c | 4 ++++
 mm/damon/reclaim.c  | 4 ++++
 2 files changed, 8 insertions(+)


base-commit: 3c18aac8c775b020a2c50e91051f106dc621ad3e
-- 
2.47.3

