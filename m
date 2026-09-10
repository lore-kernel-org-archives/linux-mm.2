Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC200C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 04:03:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAF7D6B0095; Thu, 10 Sep 2026 00:03:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B600B6B0099; Thu, 10 Sep 2026 00:03:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9D296B009D; Thu, 10 Sep 2026 00:03:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8A8E26B0095
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 00:03:32 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 616421403E2
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:03:30 +0000 (UTC)
X-FDA: 85196508180.11.EB109FC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id C256B1A0002
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:03:28 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bED307cl;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789013008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dxxa5wP8u6+NzrCeSUKIx091CaUINS3Abxx04SVxcHc=;
	b=TlKEQfXdAuIYxVsw7cfuEAHenFFS4D/D8IVnYsWPiieFsZPXEXUbofSJIloMKttFs9yVAN
	zK1UQLSEir5lB+mH1RjEeMOsTQTH8uxF0MrgO1jb0OgFXoX3zOkP4EUc1V8GGzNkwDvhmv
	YrBXke1NTmj+hPRzpuhIW6koNvlLiXc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bED307cl;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789013008;
	b=uuWKuezi4USpo8Hngrh9WehcJVjaDJr3Pa9bPeEsMdAsXNGs55DbncTCEY+b2ItG42ys7N
	xiZqZw6NYDuO2wUBZQRZM4ku/E51wVyCo/yHfrv9/+QMtooUWK881E8FgnLepAJ45Eqh5Y
	2I60pFGkhEDkZlvl9mItr+x4ANQPFqE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E475243CBE
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:03:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADEB61F00898;
	Thu, 10 Sep 2026 04:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789013007;
	bh=Dxxa5wP8u6+NzrCeSUKIx091CaUINS3Abxx04SVxcHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bED307cl2sGFNZVAYrK7mZrmuxaml4iPTXDqeapjKFViFL6kmH3sQRTJl48Z2odWI
	 1oagjsJAHT9Y6CP7yw3k4mXNKxeSXFoBneEroJgN1yvmRAdDFEvNrLOCCXgQPS7Cck
	 M62s6v0bEiSxmCqFp4uXuaBlIaB1SqJkBtGBfZ748kk9eRqeOi0Pmmvv0E54rs0880
	 jBDhMU2UBBsFojRmjOECPuo3BOM9gnvpHUMBgKumhvcblwRI3XBzC7P6Az67p9262S
	 JTef2bK8K4zy5vQz27rxJm6svm1tlMW3+noOsjhIl2x1S0niNHa9ePrVGItZReqzO4
	 M5bZd8U18EsIQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.1 1/7] mm/damon/api: introduce DAMOS_FILTER_TYPE_PROBE_HITS_WSUM
Date: Wed,  9 Sep 2026 21:03:12 -0700
Message-ID: <20260910040319.147037-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260910040319.147037-1-sj@kernel.org>
References: <20260910040319.147037-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 4a4ur464ho684xtgxdwjtifni7uyiotp
X-Rspamd-Queue-Id: C256B1A0002
X-Rspamd-Server: rspam07
X-HE-Tag: 1789013008-13882
X-HE-Meta: U2FsdGVkX1/xp2vxN0kKKN4toRVoMoUr3ywfEFHva+oP9RbwEU/5nqrYXdBDMPjC6RasrDIEAAsu5v8BT9S/q06adyM1CDla7KYmrw/CXJ2u29TiB/P1V7tNdZTYwIK7I5G+6BZOwQ1pOwGV2HypcdQmMZSvUu43ZGz4rV6E4VanpAwPTl4s4VhlhBmgZkf6YfYLfc0AkfWMYjzR3+TqeJQdIUAvVwZaZCDUd3Rzmq/9w6vD7IJpL14pvIh7iGXZbDX/EWfPePUa1xj7UwdRfOagZ2/Xs54vHgybSXCSml81D1U1XvEv6GcQ+UqqLd/wI54y5NGRumADu4r/E3f1jl6LFE62kKR88l1oxc3YszLH81cVbd8HZxdihGs6Hiu1GptXUU+SBivYRvUIXyxOOyYCYOZWuDTJ/Z5XluxlSAxSY9Fzav27TeDo3wYxk0lKhgjxW3FWxbQy+pjtZoXONL1PzVrVIYkSY5jhTxaXfkIvY6vYRvJT0sZQLHL4YM4Jr8l2/fN1s1UVqrh4ZBI6JTS5Xd8sUtEqpWDkZzQb9C/NK1m9pu/x0ApUg1nOC72byRFH4yacGwtR5lf81WYS9Zacs+DbB1+Rs5XWpUxUUOJZENbpo4QHWOWAtnccK1fyPb1fzzK+H6/trHFoOK8+K122Acsb5zEGuLZfsPy4BElUN2gak6ROz9XXjk4cs9991/GXJx4OtnkSft6cnrNdcDSHgdmMk4MmKC8XBQdbTUSUoDesNgQYk0Ms10H5Gdb0LzvQf/uDZlwYzQD0LZHwMpJrgA6FnbGMvayIQoVXA42mpVMOG58dUNWtHTquRe024OVInK2FZpSqUm32tiwBX07yZl3OLUshG/UTR6XpwLuJea1ot+UntBHgMpioZ8F31f0fPrR5QLw/DU0UVjaOWzZWNA8UNQrkmeSO3d/6VZx6LMcD0e1dA7gxaqADX8tf+EcgMSPbCIdts5kJXvI
 868HcFDT
 3qU5SgBj8rjdN9cyzRn+MYZ+dX9/kqOKAfXHHffxLU8LIn22dVoSimdfNERPmdWEng2iBlLs5QD5LxVycqe4d3BgC9/EYxQP3Sp7JfKpqJ3G/D42WmJ3F0IqH5Img+gg3NxUKANL2sicNL79SZj0WDrb2wCSMB4ujsuw7tZk8QJTKfOnUm1si52EmFTYO+saN88pn0Q5HLLvR6wEcbQHGhtDSyLnFPxdy7ATxiQ+7x/wAB7VQINhp8/1u3Oc7WVny4MmiEFSONduJKwHK62imRSJXx3CsczP5i1/sLBdL8dP3Bfclpohlwq4kXIJXtfoeDDfyjk7O1hULRwjAw+sImPH5/pyWRump2lHx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON kernel API to introduce new DAMOS core filter type,
PROBE_HITS_WSUM.  It will allow API callers to describe the DAMOS action
target regions based on their probe_hits weighted sum.  For describing
the filtering target weighted sum range, add two type-dependent union
fields to damos_filter.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 871d26adf6ae5..1deda16bb70b5 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -399,6 +399,7 @@ struct damos_stat {
  * @DAMOS_FILTER_TYPE_UNMAPPED:	Unmapped pages.
  * @DAMOS_FILTER_TYPE_ADDR:	Address range.
  * @DAMOS_FILTER_TYPE_TARGET:	Data Access Monitoring target.
+ * @DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:	probe_hits weighted sum range.
  * @NR_DAMOS_FILTER_TYPES:	Number of filter types.
  *
  * All types except &DAMOS_FILTER_TYPE_ADDR and &DAMOS_FILTER_TYPE_TARGET
@@ -420,6 +421,7 @@ enum damos_filter_type {
 	DAMOS_FILTER_TYPE_UNMAPPED,
 	DAMOS_FILTER_TYPE_ADDR,
 	DAMOS_FILTER_TYPE_TARGET,
+	DAMOS_FILTER_TYPE_PROBE_HITS_WSUM,
 	NR_DAMOS_FILTER_TYPES,
 };
 
@@ -434,6 +436,8 @@ enum damos_filter_type {
  *		&damon_ctx->adaptive_targets if @type is
  *		DAMOS_FILTER_TYPE_TARGET.
  * @sz_range:	Size range if @type is DAMOS_FILTER_TYPE_HUGEPAGE_SIZE.
+ * @range_min:	Minimum value of range arguments.
+ * @range_max:	Maximum value of range arguments.
  *
  * Before applying the &damos->action to a memory region, DAMOS checks if each
  * byte of the region matches to this given condition and avoid applying the
@@ -450,6 +454,10 @@ struct damos_filter {
 		struct damon_addr_range addr_range;
 		int target_idx;
 		struct damon_size_range sz_range;
+		struct {
+			unsigned long range_min;
+			unsigned long range_max;
+		};
 	};
 /* private: */
 	/* List head for siblings. */
-- 
2.47.3

