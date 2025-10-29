Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42F75CCF9E9
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 08:57:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 306238E0046; Wed, 29 Oct 2025 04:57:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC36A8E0041; Wed, 29 Oct 2025 04:57:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7D548E0044; Wed, 29 Oct 2025 04:57:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 95BD68E0044
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 04:57:07 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4C67A14062E
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 08:57:07 +0000 (UTC)
X-FDA: 84050547294.15.0143102
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2507312000C
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 08:57:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761728225; a=rsa-sha256;
	cv=none;
	b=eQHFpgc8qSmq5IiP+7heKNLGtWn97rljVqUu1mMjioh3n91WyIE28BNY0SsbFzHxSncdsS
	MMZAp3iFqlJ26aKqX1/RmafPrIeKXNVbe0hBq8cI+ppijCHsAFYvKzdLnbaHJK+x0N/xi7
	oFpHoM9d0mW3AEsgOmN4Ln6I+OqOP5M=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761728225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=boYvItXx16LcnT5D7NrHLzo8+BLrLbbNI2RQbzSjWSA=;
	b=sgDkbS+v4+NfTiQBmwddefMY++JFyF7WbfGAxv3VeWF+mfJSad/e0W+oZfQ4QEH7/MMYEr
	ihbqIRf6BrqAdhvhPj9kTJY+zz9ogSfOmo0DxLG0OGa56JvrhFcViBfw1m3XV08tzPU3Wf
	ci78lQVu2WURBTDfUXhbGoNJgHqLuBQ=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 29 Oct 2025 17:57:02 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	shikemeng@huaweicloud.com,
	kasong@tencent.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	chrisl@kernel.org,
	youngjun.park@lge.com,
	gunho.lee@lge.com
Subject: [PATCH 3/5] mm, swap: Remove redundant comment for read_swap_cache_async
Date: Wed, 29 Oct 2025 17:56:57 +0900
Message-Id: <20251029085659.2005942-4-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251029085659.2005942-1-youngjun.park@lge.com>
References: <20251029085659.2005942-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: k5fz7o7gotbthmbyidwhgh68eorent9a
X-Rspamd-Queue-Id: 2507312000C
X-Rspamd-Server: rspam09
X-HE-Tag: 1761728224-145797
X-HE-Meta: U2FsdGVkX1/1RkTyGGFYU7Hg0bwJOUyxbW7XxGRkgT0vAgCpLxSLgDUU9PEff02miscgwimQvpdXgOFJdc+/XSxgVXqi+LjK1um9XOsh8RBO0g/ra7pcaoEfqD9OHJmrKmKgaA1ECDt3BwHGtdbaI2Ds9VC+knbn5NFfdLgMQKKBRbgmAEWWu1/VtudZKFK1gNKwoC8yBiGgjo7p3Q/27CjB92YJv+ZQoUay7JQZCwmLPbOpyBXbksnC0yTJu9wG1bjzA/1OKfHo862N6TyeuDci/ecV/VVQWh6Dykcni7l0VoCCWQUiaTtvhoVCw068rVauxaWY8YnfJYxmi1aDLRnKOVSSIUAz7N7Ef6MbCWHa5QTF+yYt40RF04empqEbDUmYYXttnNgILAXLLtcdfGNjzBiBT56sp1m19CbIKAeoUP7pqpQ5QuKXDH49KR52OiXrrQsn4VKzZODZuSwNBX9Q7PtUFHQZJH3zu8xhHJwjMi6Cw9e9wZ7v4yNDDhrpGkXWx/ztpWfIBbw3+9DBG+T6gXSeiZq/bxixZF3IywQRmp9ihXSTf8eFrueC4WS7qmNNUOpD/D0EkgJt6KTlnhicnsuuWKF0SdCNEju5WCfZONYME9pZNRGX53UBhsAqUDYS+cDo/7TQ3cYz7NSOgUJJBc3/6XlF68d6ehva2UcERSAPURYQx8lRMhhx0GKLeXIuDDXy/wqn8z3t/MmWSWrHh3vpFey2c3ACAtr4cUZQpF0mBd5tCoJB4uDCNDd+A/SUmkbMml/7pv+iARN7je03GTMP7O80WkMZ1AbfXYNy7KhkUJ+CuVrBgrhIH/YnlFijHs98OXLi8VNhwbVjHn/GPVZNDoyprOCWyCpa0WtUoV2PM65HbwBfEnsppem3lpbLaaai7N9xfVU895O3Opi492oL+uSAd1ZMKz+Da0m89zYERMtv0wY/WOOBap+0bnQEncX/l5nBKypz6Ra
 Q6i7zSKn
 6+32itcJM7PSXiFOmhzyxeM+qChbYCUeiBjfWLyxp9l1XhvwwJa/BEnKf+vgSGiNZjFN1rSR6+EWKI026kx57i2gpF8IiwnE3/0E/NU0ViNAbhfQrZpxhcHlCuavbPDPAjuPGoeW7iXRlmoW72GS+oEByjmlsvMG3+vBNSaT7dcJcKJxljS8m8BRYOHqpyUXdRo1KD82cWrMN/KA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The function now manages get/put_swap_device() internally, making the
comment explaining this behavior to callers unnecessary.

Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 mm/swap_state.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/mm/swap_state.c b/mm/swap_state.c
index b13e9c4baa90..d20d238109f9 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -509,10 +509,6 @@ struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
  * and reading the disk if it is not already cached.
  * A failure return means that either the page allocation failed or that
  * the swap entry is no longer in use.
- *
- * get/put_swap_device() aren't needed to call this function, because
- * __read_swap_cache_async() call them and swap_read_folio() holds the
- * swap cache folio lock.
  */
 struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 		struct vm_area_struct *vma, unsigned long addr,
-- 
2.34.1


