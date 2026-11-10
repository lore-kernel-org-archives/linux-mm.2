Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DF67606A33F
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 01:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dh2V6PGU
Received: by kanga.kvack.org (Postfix)
	id 50A5D6B00EF; Mon,  9 Nov 2026 20:06:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BA026B05B1; Mon,  9 Nov 2026 20:06:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F6506B05B2; Mon,  9 Nov 2026 20:06:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 178D16B00EF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 20:06:09 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 96100A75FC
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 01:06:08 +0000 (UTC)
X-FDA: 85417418016.28.408B4D3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id E1FEAA0007
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 01:06:06 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dh2V6PGU;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794272767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IaqtXb4shYGXU3OlBPma0gsoGJmW9Ovcsn7uO7R5/hM=;
	b=1FGNU/UNqBQjnWNCH9hf+i1o/n5NBkpD48UxkEkE82ihfyT6L+haIFIojnQtwEhXuc007O
	YgfWOVdd3YFjSo762ravB+Tk8yzfbsTTFxkkFHm/0nLmGClxYVxLj/cN+QwHr7NDcTYEp8
	q7bs+9se00Y6dt3UG1jXMSi0/Q3E9Os=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dh2V6PGU;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794272767;
	b=rfrPTG6LXJYhNCTuhyoRSKDeVU0j08+ntH3D3pA1gRICSXhPyRgsjKYIit2+0/L8HqrDXh
	YX7JdvjF0X6D6+7TQ+6J+/eaQb10T3lSAXgfkjcn/s57wrB/bWp9J9RDQZBMP1kC3xNcKx
	3epMIO+YIS0N1yl/7Ry69h9K4eUTSps=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 37E3D45C09;
	Tue, 10 Nov 2026 01:06:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF8251F008A2;
	Tue, 10 Nov 2026 01:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794272766;
	bh=IaqtXb4shYGXU3OlBPma0gsoGJmW9Ovcsn7uO7R5/hM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dh2V6PGUWulUa8ThTycgn1OccsBy/dik+PQbHjhi/G9GKGlFgdI4i/xkKdNuIXbla
	 GiKlPNTpVbwlnOjEkUPJwmD64BQlEqaVe+NeS/tW1alC39C+jDDaOx4sVhPeduY0Dw
	 Z1V7E8chFZcQXFPa5xvOhWXipZ1vNhAaeJl9HW7RFMbJgOqoJlGN5Jkrn5Mih8M0bA
	 sF30AeBSuTERVAiHlGSvZ9gte5FjR/lNCMJCSCXWyiRKhARUACxME9iQXEWiqBIh2t
	 MruiGM6AiWR09vS9bG0iVQy/a44zAq1KZUOFJpYb/+NgjFDRaQu6MS5HX61Fc5/yBg
	 ukAKRenSjF4FQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Enze Li <lienze@kylinos.cn>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/2] mm/damon/core: use list_{next,prev}_entry() in damon_{next,prev}_region()
Date: Mon,  9 Nov 2026 17:05:56 -0800
Message-ID: <20261110010558.104905-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261110010558.104905-1-sj@kernel.org>
References: <20261110010558.104905-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pmaqqoy3teoasrxooek3ink9zy1peb11
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: E1FEAA0007
X-HE-Tag: 1794272766-775324
X-HE-Meta: U2FsdGVkX1+KjPmVarRSehCTOv4BnypfT5yFthdBxtb10+51UUpYKhglssfPH/rht8Hw8N7yxYFqlyfMzJjCFXZHpQeToKluSTbOechkzZWKGFdH/eeQpO9iL7UcSE2sj3IVxvBgJH2xHvXwzVpNWk0DEXhKUgDbK+CU/GJJYTBNQOt+wI7H2zK1MiYFA+uv87fVBFpVS2RVGtwSDvekzjxEwzOJYiq82QmOiEYwXop9BSl10Aq46Yy96DQIa+lluA6QUG+FdQB0l5CciTWR0FNXdAHFK3QSmbolibXvg3maRrSM3uaMWCEdHc6vaG4jrip/Adjsus4GU3XG4VXqVISn8lOFIzkrLqeLSI8eaFZTkYz44EzfvItKaOed/990JjJHEk9fClyB61WLw9zsj2EYGnDSaC4o3/KQfm9WsmWRNCHBLSkQhZoFsK67ByRcXQR58tHxfeB5PnXay063SXc3d+R3NOsJkBa4re2zlGWUzX72uMv73AhgcUxDcs5a/M3F8l99qnPG5qvXcGJdjh/cW7khl2yXByChV+ZLXtSR2mNe9dN7hHW2iWx05cYLvK0MAUb51hJ65I23eECqMJQNr2DWUj0/GiPf6rhlx5d4nLQscY3cEi3PZ8SMRVll6RTmcs0H0jrazAs3ESoZ7THxtIOpSktcl+lMSGu6Aix8TC9zs9TlP8jjmIVp33TOKqEvZq+l6b125sLZxz8jlra8p25mcicnDUcJ3nIyg2HnXfZNI4UA3u2OjDw53P03LdqGvRjzhufE6PK4t4Gl1nJx4mvVl4kB+TZoL8+SX0r69zZBmpkk5Rx8YSR+3LxFJKzMd2ZZ+BBox9M6ey9Fifv8NBNx73niBKtZcKVj5E5YGNKg4R5ZPIa9ZuQjCsp8P+Sq+ou7JiJg4Hoz/hK5FrP5VDKy3Em24xRQx3MiY07KnAO70J+m6J/dkXZXCNCLJBO2CzrOaPNGJKMaG+S
 nKA5/mlk
 2DQOcNobaFx9S/R0idRMWw7RDRSPp8dq9GJBK1PflZ2RnAQftavfOJ1X5AvmATDm01GKqg5WhbH+TFnnU/NdbL/uCK+LRaNT3xdkNCpLkyWbhqyxTC6Wk/IP1EFolr2j5WuEV8q/v3ISSA7vIhCkEyrKtGPWq8IHALe65fwKyr7sXF8DIghI+byxGNYSLrFljNZ1UJ07sk077al1KrPqqbZVkrI5X9EfdSYmpAfnmtmIgr4g2SooUo45ZNFOMvSrFJ+yR4jmoOai565NG56DVgqYfWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Enze Li <lienze@kylinos.cn>

damon_next_region() and damon_prev_region() manually do container_of()
type casting to fetch the next and previous region from the linked
list.  Use the dedicated list.h helpers, list_next_entry() and
list_prev_entry(), as damon_first_region() and damon_last_region() do.

Signed-off-by: Enze Li <lienze@kylinos.cn>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v1
- v1: https://lore.kernel.org/20261103100714.70742-1-lienze@kylinos.cn
- Collect R-b: from SJ.
- Rebase to the latest mm-new.

 include/linux/damon.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 1302ffb6f0bcb..c32ef79c3acea 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -992,12 +992,12 @@ static inline unsigned long damon_rand(struct damon_ctx *ctx,
 
 static inline struct damon_region *damon_next_region(struct damon_region *r)
 {
-	return container_of(r->list.next, struct damon_region, list);
+	return list_next_entry(r, list);
 }
 
 static inline struct damon_region *damon_prev_region(struct damon_region *r)
 {
-	return container_of(r->list.prev, struct damon_region, list);
+	return list_prev_entry(r, list);
 }
 
 static inline struct damon_region *damon_last_region(struct damon_target *t)
-- 
2.47.3

