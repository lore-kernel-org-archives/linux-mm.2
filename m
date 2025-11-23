Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB747CFC518
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 18:44:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70D276B0032; Sun, 23 Nov 2025 13:43:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BDA46B0062; Sun, 23 Nov 2025 13:43:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AF546B008A; Sun, 23 Nov 2025 13:43:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 22BFA6B0062
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 13:43:49 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D1DFE1A016C
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 18:43:48 +0000 (UTC)
X-FDA: 84142745736.14.19904A4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2F919120004
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 18:43:46 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CiKQJhBJ;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763923427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M/pBh15MVvJ53SnhY35kazX8Y4DxLhwZP9KOa9nKXIo=;
	b=0m1ktMfA8ZPzqO0f4rxMbYpDBG82Aw22m9CgbAegscc8sjKpEHxb2Oiu3lKK5nA7JvFpB3
	zfWqPyWGvNDXYaTGoShbQjLQpS1wUTNYyOnEbarCubcLyGVGRcER+1wZtCoDM2Z29cCNRs
	TTaEA0KdIGVyn1lVvr0S4dXcLcQcbHQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763923427; a=rsa-sha256;
	cv=none;
	b=RWBAOApc9kn+NM2mjlm647LC9el5A8+CM2m3MCUN7qVHRv+mLVnJJPrYIH4BIGwGwk+53d
	+xx4d/95AKC6kXgqhFb02zqbgD5LKwU/kUs2cQz3YSGw9o+rssThc0Y08NO0alIEk6Xo8s
	jAFa3dnDvS8NyfUl53Qn+YurIPULWJ8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CiKQJhBJ;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4A62C44314
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 18:43:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17735C19424;
	Sun, 23 Nov 2025 18:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763923426;
	bh=dyfJoVaMw2se3otvFoArpX9pnB7yY+god8b9Qd1MKC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CiKQJhBJnI5WYFJRAhLILwwpHsC9nhrMXkusYL+OVgcRmrizUjeyJdmMOV37IwAon
	 aCMGlTOGfdHzxBUSBbxFb3r0wSmZ5x1Zmt0tlKVzgvdnp+DaDOnVFhdMCFFL5isEXS
	 fXm1K1xHzKBdq4Aqp4t1YqKrCxwwBlLA3YfHO7VmYgoztMUjTIylVBpo3BRrkQXMjM
	 G7em5Y2hkq1DEKThsHpm+Dn/xjpUVhJtIe2AAFpeCl5+Unzojr76w80P11kbGtzYEZ
	 wWgr/UxhM2nmamCpje4o5ECAj8yYufVlOmtAnCdeRkY/AaF/XjVN9/X4xiUNqeo72x
	 +wPJIKCQY8YqQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 06/12] mm/damon: update damos kerneldoc for stat field
Date: Sun, 23 Nov 2025 10:43:20 -0800
Message-ID: <20251123184329.85287-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251123184329.85287-1-sj@kernel.org>
References: <20251123184329.85287-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qs5motbjynqfd3jhdgq7uhifwn5hhw8u
X-Rspam-User: 
X-Rspamd-Queue-Id: 2F919120004
X-Rspamd-Server: rspam01
X-HE-Tag: 1763923426-794792
X-HE-Meta: U2FsdGVkX19f5bBIRoKZAd+NO1mN/hlcOk9OMdvrYoIjAfG1P12OOQRlhQKMUZ2dNNcyNszkt5YALwhjGbZt0fJVSOjZX0r+0OTdzBoTlWhj5skF8sh2G9FAm9eZyozxXnNdTAIrJUZ5Y8qpXH7DvnEN/NmuuKnIT428k3Po0eDRqNqiys+2vECzdyo4wwBzcKsyJmqYvGZz4JtGHfUZJcpy/fKG6bxyxQvVaYlkAd0o5OEgTAkLaQvh8A251q8Sf6qMk2SC9RN/eE4dh1HWEz0Repoqz6J73vJOa/rt9rk8UxlhQXOgD2oD2/5oUgaBXJoeGs/RjmoLWW7LqLpmdMHX1cCZNjXUrU8dYjt9Ui+DXNEbLlzut5EoraGJlgJFqbhIxNSXlrasV3ZBKp9RRHl/sAx8YnSgBrvZ6JUtWc7tg9fGa7BWPXZH40upV+L7zte3qXWWrdAYWAMaNIbxk4/Yf+MsiRPMcWcgrDD4TBnQ62lvSgsjgoNgyrcPQDrekvrglFufrF9KTlBMgVi3DZjsoMEWZNw1+nQjHZTy1Mz+5QH1wXvKfRxW5rFtdosEeMD1aCqatqGwMZ3jAtb0OVZusNV9EOAah6xlx1aWTUgV01eUlGWFX+Bjk1+F5ayzeBfOLq0wWb1JhlRzaOPxGedYkavTURJBy08ndozXiLfrzUrcH9FANq6JoKREHBnFOVunA6TbewuixBb3w86hS5AmdtRZi+k6BWe7E79+1cOuqIpXDly0F0mEF/66f1RnntN49ccihb24p/qomUui3azHyjzXrY3cie75FAWQijEEK/tH+RiLLHo4ulElgubwCOJd7vuPrFOrqKfyaRUI7T91VH7VOiG7f5aXbEl/LtJjid8sx/jThb1GEOhbvCtfEgfS8YBmjvQe7IfJAmv9Did51koZXBVx4AVoc5nRXhrSurODyFCGpEN2/nPqvRQLYRSyZjI3CY2gjHT5efb
 OH9Z7omM
 1VjxmyTeRWOhprSJtdCLciOL4KHwo0HSJnIH0ZdPYz7mGK8bMuaAIpJ+dFqGZxpxuo7dUaQle/hb/ExngFMYm94yttXMCQe0BkgxyukGbxhnmNH7nzyckOBQKYIt4ZLBeMRV6IBskkbQyvqgco6NOlRwoLFHafAhDyh93NW5SySPbDZzhIG4zFS5RKM5GW5XAhl03ozV/cHv1GlssM0x3vhLC4+JNKzWwCzVMxCNK2uUSIP94LygZzbdWQ97oEOpWtXbczCt9xDcJsVBvcQsnHkfl+EbfJRGCuS9ze/s1mVL8BHM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 0e92c2ee9f45 ("mm/damon/schemes: account scheme actions that
successfully applied") has replaced ->stat_count and ->stat_sz of
'struct damos' with ->stat.  The commit mistakenly did not update the
related kernel doc comment, though.  Update the comment.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 1d8a1515e75a..43dfbfe2292f 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -532,9 +532,7 @@ struct damos_migrate_dests {
  * unsets @last_applied when each regions walking for applying the scheme is
  * finished.
  *
- * After applying the &action to each region, &stat_count and &stat_sz is
- * updated to reflect the number of regions and total size of regions that the
- * &action is applied.
+ * After applying the &action to each region, &stat is updated.
  */
 struct damos {
 	struct damos_access_pattern pattern;
-- 
2.47.3

