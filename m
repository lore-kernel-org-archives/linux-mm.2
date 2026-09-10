Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7825C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 14:22:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC6176B009B; Thu, 10 Sep 2026 10:22:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D77C26B00AE; Thu, 10 Sep 2026 10:22:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB4006B00AF; Thu, 10 Sep 2026 10:22:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A33F26B009B
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:22:44 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C290416054F
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:22:43 +0000 (UTC)
X-FDA: 85198068606.17.7A2A9D2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3E530100010
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:22:42 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kRYtb3eO;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789050162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3ydmrqNiPvZ4mpbkkUedW3SpTRg9lnwme+IK1BHGVlU=;
	b=YGBL9G0SdrLKYZxtumk+leZgrSYu9nrsaTtT4PZzTOtH4VP5/nyDyqQR/8IMMzXvhLd/t0
	bu/7yN2DP6XUOcBqnTR639pzaaOuFyJOBS149OFBS6mYox7O8mQl4A4MsyxuZT5Di3M0/8
	zLVZ0RARxn7zSVsTlmC7PD8p8z7APcM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789050162;
	b=3YTQ+HNFM9lOa0EPEU1CfJ1kt6jIxewNhbff6XQx1sXaaCtE/LUxV1hjp7/rtqlaeAweQ/
	E7cHqCGE73w552bWnI8M0qlkcX+udirWSyH3R2HvyzOjvhRGnYItggzIRkwHru84E5ggNS
	ppWbR53EN7QSk9ciT5Hrqi/wnhLCzZY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kRYtb3eO;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C8CA960200;
	Thu, 10 Sep 2026 14:22:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 585201F00893;
	Thu, 10 Sep 2026 14:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789050161;
	bh=3ydmrqNiPvZ4mpbkkUedW3SpTRg9lnwme+IK1BHGVlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kRYtb3eOqKitNK80KezJoRPOPFZ8U4uxfCBnZtOA6sLTfFtxxFMgXJJt5n2IlRg4n
	 tBLuqMizz1b98n9NOUFzcVwzpRKbj6wI5DbUMqR8Z7s0DM569fsNCophlhPslONnSz
	 usvta/39C0dK3G3wCtTwL8D1oq0qob1k+DGvXJqjUdO2TXNY0rjwhmaTHw7FR55u4r
	 aFu9l5hWDgCyJcwz6BNFKI5uNkiIrxdBSuZm2r4HqXDfpmhSwytaYwvh1qa7vCu1cX
	 o9IEY7Qp9KOYlbwkAPjDKb2tp4xqYi0d4P8oXXEfabyXGwItFPexPrOI88EWL7wugi
	 SSN8fEYGbVgCg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/5] mm/damon/api: introduce DAMON_FILTER_TYPE_PGIDLE_SET
Date: Thu, 10 Sep 2026 07:22:28 -0700
Message-ID: <20260910142234.171562-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260910142234.171562-1-sj@kernel.org>
References: <20260910142234.171562-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3E530100010
X-Stat-Signature: a5du19ia14731zbgez6k4ppyhk5opxt8
X-Rspam-User: 
X-HE-Tag: 1789050162-327609
X-HE-Meta: U2FsdGVkX1/81ZLYxTQmWKnfgJronrHHkfVAAcsCQnBQBpDy04EFa69CPZYYi43DNPvcdVkznO8YCL6FWf0UG8nQ82S9Ocup9G15HDowQccaaaz15/Jcs22rtqu9LcffZUT4s0arSEuOWSq25J5XFv8jJmuOOqz1HPze1pX45emp4YyhUeqkGn09fp3ecP0vF9OIRDyiacE00OQei69Z1/He+Jh93f6LElPYySe0KDDJtSHfj/Fhl9x9YaxjxKZCRo7/ebjLSEpSAGP/fMtU5tI73gjt5RTq2ssx7WJkCtt6xxqqfA+YgqrA6ThNjwO4grCApzGfSKlq3TPv6sKv0Hr227jKmdfxQwA8aqeVjNvfYlO6w9/RFHBT0KgWOyWpq/8h7oTi2bQqfusjALSdtaeK/LUlbw1/IPrGScbtNXGh6NrTrf3UJsRRvYyjHxUUHNmGAp7ljydm6kNesbM5tkMw+Hu3bd246KBznomnbcBEoeI89F5t51p9/kG/SG6o1phOmG5nDNjNw2eZWaU1l2hahmGK1Yy0f/pLgM8An+Pl4k2X6ZfbUdtMvF4VhHg5A3O1uSw5gKW/1e9jSxZxHNxiEX60oG6OhibgTG0ww0aAGqXAdAWKfN1KPs4b6HSGX805zZnasWOYAHDIyvYmrdMCbJm2AiKBff1MHDSpukyh16qbQzh8iXW6P3QGdlm0/O7ZnmwtPXeff8QHMvyg1vADvmlJnCI1CvS7965Ka+NSaqdbiMk6/O5TKvLa2DyYmVqmdRVBK6hw1FiOAuWE4USl2z4syFaJKuJo2xCkmCJ2M3w+ez+a6f/DROP0UuCWJ1j5IPLv9iIeWq9JYN9ZvNSW2mcafMWxC06xbUwzp0y5sZmsXa8qLG2tivz+B1ECoFtAvUHCcGVnT26S3mW88LSeQPF1VY2ijM6/+hDRZr+tQJe7xfWr0JECMxNdE+1QS0ryHSf4q1JdjazSyKQ
 qPuFN11B
 UEwMSGYZQV8lI1UOSwF/g14AeVo8Ll/FuYTm5tSCLttYPFOo3O+TW9xKVWhb5F2neNEkUxTulZgQjj5MD14Q805QEzumhK2w5DYlr+xyUVV9OQ8cCSvlmBUDP6/DAACbOgXewXaUqpyKtV98Cd82EC/N3jUwozdRhAKNWVYdBmRlfxPpEeDEDYXguyAInjCCeU6e/cEmf2zo2oqglQwV2R3bo74/Q3AJ+aJCu/jEC2xMYdjeiETaYAs4dEC91xvCUjOsekEBw5UzI5adKFz+yXNIU5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_FILTER_TYPE_PGIDLE_UNSET matches only memory that was able to
confirm if it is marked as idle.  If the memory cannot be marked as
idle, it simply doesn't match.  Hence, finding memory that was marked as
idle with only DAMON_FILTER_TYPE_PGIDLE_UNSET is impossible.  Introduce
a new filter for the purpose, DAMON_FILTER_TYPE_PGIDLE_SET.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 4a36f344bbc7c..abb529771091c 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -782,11 +782,13 @@ struct damon_prep {
  * @DAMON_FILTER_TYPE_ANON:		Anonymous pages.
  * @DAMON_FILTER_TYPE_MEMCG:		Specific memcg's pages.
  * @DAMON_FILTER_TYPE_PGIDLE_UNSET:	Pgidle is unset.
+ * @DAMON_FILTER_TYPE_PGIDLE_SET:	Pgidle is set.
  */
 enum damon_filter_type {
 	DAMON_FILTER_TYPE_ANON,
 	DAMON_FILTER_TYPE_MEMCG,
 	DAMON_FILTER_TYPE_PGIDLE_UNSET,
+	DAMON_FILTER_TYPE_PGIDLE_SET,
 };
 
 /**
-- 
2.47.3

