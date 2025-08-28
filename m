Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 793FCC8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 17:12:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF63E8E001D; Thu, 28 Aug 2025 13:12:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA5B58E0008; Thu, 28 Aug 2025 13:12:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C37A78E001D; Thu, 28 Aug 2025 13:12:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9B3C88E0008
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 13:12:51 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5DF321A02EC
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 17:12:51 +0000 (UTC)
X-FDA: 83826810942.30.4DE6A1C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8B59D4000E
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 17:12:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jaUpxdvz;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756401169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DaqtcVliYPCqULfyUkpBIKvNkuzGKsyjMeyolaEiQhE=;
	b=PgYhNiE6pOzG3h01zidg2+6c+hFfzlWrGOVPa/XguLlE6Iw50YVRWnB7tmikiTBTMUt3V+
	lc0bi7LZPbjmlo3UdGCMmELM1Avod1E+Lz9+/lMqI/GRFk3QxKVzFP1LunBWvbQxmrsELr
	A6MqFPBnWaSkBSr5lDDMFGMWOHh4Bwg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jaUpxdvz;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756401169; a=rsa-sha256;
	cv=none;
	b=r85xMBSYlLZ4mQ7ptHYqSDPD9NyZs3pIRnOXGMpRPRr8fkuguhjRm9Euy/NcxH05Oek5Sl
	vbD0aWz+LvllUi9rZkV0cw//rxBVP+e8QK4Trk1Xp7czlVoo+CLZSOE47e0fPOdwb/iBFs
	Mg4ijEjHMZWFwY9Iovi+Rm3YMAuZUA8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D50B460139;
	Thu, 28 Aug 2025 17:12:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66073C4CEED;
	Thu, 28 Aug 2025 17:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756401168;
	bh=V00Ezz8Ti9dBe1Ak1a5KDdHP0ELwfwe8yMUv7LlWbPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jaUpxdvzwwym0dlXeMFT+KGkRyAyLcOmfh1XaxJ6PQ2LFMXvXYB06OBDEQdbjg4o/
	 fF9cV3X0q+tdhnJaLYSTQ6gPIeQX615Jskmq5ZEqz3AgoKz87zh8HndeImZRRCQ9JO
	 Z7sCkYsdwdS92Q5unjCX+cvUTbu2ynw9OTkrdmDQ9YCuF9vN0WQHKVnKlav/EYb+cA
	 ZOhCiPJhMHs0k2UD0Obf7mN2rq4gQsEwYt/icehBaA5sz3A+83wEcDg0BzFhQ9q9q1
	 xYEv36Vn+4vPlN8grelrrG3aVTrfKo3cSkBDOC54Eq3tOzdDG4GHkeY9wwfmTxBjmf
	 T5+YPJY6kiyJg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: [PATCH v3 01/11] mm/damon/core: add damon_ctx->addr_unit
Date: Thu, 28 Aug 2025 10:12:32 -0700
Message-Id: <20250828171242.59810-2-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250828171242.59810-1-sj@kernel.org>
References: <20250828171242.59810-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5bwe4i71kbrp63xonhxeq6zxdcdhh8em
X-Rspam-User: 
X-Rspamd-Queue-Id: 8B59D4000E
X-Rspamd-Server: rspam01
X-HE-Tag: 1756401169-994545
X-HE-Meta: U2FsdGVkX1+0sMj5EnSyHhPlmethzXaizGPLSN0jbvAvARvRc9xQ0EsG9HFRxVCyA0Z0hjxOZa2XK5L/51TVzgzZ6kGkLnGtrbZTld3jMbhxOGOJV+pa/ME7ODrjSYymL7bp/zcOA3DVASvq8DrOGnoR/6NzmBHBDK+77yVraE3ZUtcYlFOhv3lZuSXyAQuLYmUPs2YO8o55IESnhNV4lK6BSI0tpK5PnjNGwwh56+L7G7uX2mxFOSGchC+8jVXJ24nowtahNOTFH50yLge660ex590bT0L5xxEMOhiyaWw1yUspJlN295TJXb6VxrSO4topNqFxDg7qszEvxplbhtsKtpA7jSPoaoQl4OhBvQhkscQB1xYseJwDjiuUf3csH1xvL2fYnn3OF9+praCJO88NfR5xCUBN7n2eFn9fyWMwqFH1oNQ8LbdFf/uDOJ3J2GdcrVNCvh+eSVGjtsE6pDkbzRskFmL7zp5kDIQ5RK7aOG1oc2+fW6xMZxmV2/fGBoPCwPTYoEgEBheNhZSgK7Gj4ERL+vqKXSt4GhkKU3uBUnh8WUFPSwMis6CevctIt5DEk2DviCFWcCOrgdY/0Nq19EC8qstyGB4B3ie5aTlkCwGEGhInDvCXBuhEir8Sggm0b04jtPxDj0ZAz9iQ/QcKEe7iTN6P4FMvV5QC3d+w4//8aJVrf8g35I1GIV14bjowVX/oguNnyaQ0iqrPXVqPoXOWXkK+F9k1eQbX3exkfcwOJm5FuAiW0pEo5FUi6SrrlYE90W5IeNVo+TIxms6s3Ismp+SWE5CS4oFUG9HIj1+0rJShSB9oAcMFR7oZYdBOOweAu6cSzBIMl4cR1GyXwrrs22KnWDbolisPerxLFdBMTvth9P9NJGiKvDwZSQJ9olJA45favJ3bE3G7IIUWPupknq6JKaxleNM5hJDd88o4uqQes9Jq+l785URUG/UOceHICx5WD/jCeLk
 G+xG0Zh5
 jXkZ+DvEMLEqrRxo8ayX05K0XnKOgof+SWSXJyGpkDUWnEp7v5lOcS+FxJi9S7vDvyXpI7Fouu8den4mXDk4eDYYp+seCYKU6ozxP6N5Zn2acHJTLm8kFsygBrxFZzutpoWoDT7xu4dITDGmz796aFMQ7SeoeO42npm52Yo02c03qTgAm5/cVRFy5kDG3IaTdO+VADo5yDVTyQVHZlzwcegU5EfTF8s+A0kIGMuQ/eZzopeNCwLWMrMTvagaqdJn5YFp2/9/Lp82bP0dY3HleaS+/sFcsn5s4YX6Sj0U+oHLXOjo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In some cases, some of the real address that handled by the underlying
operations set cannot be handled by DAMON since it uses only 'unsinged
long' as the address type.  Using DAMON for physical address space
monitoring of 32 bit ARM devices with large physical address extension
(LPAE) is one example[1].

Add a parameter name 'addr_unit' to core layer to help such cases.
DAMON core API callers can set it as the scale factor that will be used
by the operations set for translating the core layer's addresses to the
real address by multiplying the parameter value to the core layer
address.  Support of the parameter is up to each operations set layer.
The support from the physical address space operations set (paddr) will
be added with following commits.

[1] https://lore.kernel.org/20250408075553.959388-1-zuoze1@huawei.com

Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 3 ++-
 mm/damon/core.c       | 3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index d01bfee80bd6..6fa52f7495d9 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -746,7 +746,7 @@ struct damon_attrs {
  * Accesses to other fields must be protected by themselves.
  *
  * @ops:	Set of monitoring operations for given use cases.
- *
+ * @addr_unit:	Scale factor for core to ops address conversion.
  * @adaptive_targets:	Head of monitoring targets (&damon_target) list.
  * @schemes:		Head of schemes (&damos) list.
  */
@@ -788,6 +788,7 @@ struct damon_ctx {
 	struct mutex kdamond_lock;
 
 	struct damon_operations ops;
+	unsigned long addr_unit;
 
 	struct list_head adaptive_targets;
 	struct list_head schemes;
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 5ac1433860a3..acea2964b9cc 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -544,6 +544,8 @@ struct damon_ctx *damon_new_ctx(void)
 	ctx->attrs.min_nr_regions = 10;
 	ctx->attrs.max_nr_regions = 1000;
 
+	ctx->addr_unit = 1;
+
 	INIT_LIST_HEAD(&ctx->adaptive_targets);
 	INIT_LIST_HEAD(&ctx->schemes);
 
@@ -1245,6 +1247,7 @@ int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
 			return err;
 	}
 	dst->ops = src->ops;
+	dst->addr_unit = src->addr_unit;
 
 	return 0;
 }
-- 
2.39.5

