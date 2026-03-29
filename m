Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56592F3D60A
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 15:31:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D024E6B0096; Sun, 29 Mar 2026 11:30:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8C896B0098; Sun, 29 Mar 2026 11:30:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B44F06B0099; Sun, 29 Mar 2026 11:30:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 955666B0096
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 11:30:59 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 613A2E0704
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 15:30:59 +0000 (UTC)
X-FDA: 84599488638.12.3EF8451
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id BFF7C100019
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 15:30:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sQ3jiknN;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774798257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Dl4zfhc00FENn2m4/i+m8sN2nUQudqw6BFS5jwFkg0=;
	b=w8mW1TDht1Lsz9aCnVePkev7WGPMgNwwgguSfl/ohNG65/3Rf+YSVrFETJOm/jADZLjjGP
	Vl1/lh5MhHWCeYDrG5X8Df0MO2G1y9kKM5lYrHzyPdA/Go9th8gKc5TtBVrKnbBFX/vE8M
	EXVU061HBw9/pNlB4I2JJI4AUZzqvIU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sQ3jiknN;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774798257; a=rsa-sha256;
	cv=none;
	b=1sOpcLD/JIowVyoHtho+iLRatzNCmU/2lexoqURpVMyF52+yfFjtVTl4GW4gCogSUtzyOt
	i0097uXgd9NWCLit9kp2EvoqmsHWqRRqM5rLMVPbtREhx6LNZOdfJRwx02Mt2zls66hQa/
	jvdbS/By/30drjP5nJwdGppLpfshv+A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D29FE434DA;
	Sun, 29 Mar 2026 15:30:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51584C2BCB4;
	Sun, 29 Mar 2026 15:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774798256;
	bh=tRNlEMv0ruZEjgp3hUkdZRIIDy2crutD+t3ITCmsKN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sQ3jiknN8dKCDMzg6pOFYzJCFuMom0mN/Xcs6w3kJU5woVWMcOmWEi806jwJHoxQr
	 rvT9XBCkEcrze7BHkEcXzwCcXitHHAUFU0CxTlsnwFtMMnIMzE5XL48iBhx4jCtZil
	 kqMoMqCetKaWyIK/awzCmVgBhpQfoMojfJ0HBdYjH8LqaXerGZNLJlqhOkci8krc0w
	 bI2KewWlAIttNkGmzdzOwhF0Hy1hcIjy3+VEfu0MQ1eitGPlwLA5xy3SNCB64a4/yl
	 RuTUMomwgOXUyUB1qzTZW644uFFG5YGmcprtPTJrKRo1WRokOIN2N0mrMK92yMkudn
	 fGosc6Y0wlSig==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"# 6 . 0 . x" <stable@vger.kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/2] Docs/admin-guide/mm/damon/lru_sort: warn commit_inputs vs param updates race
Date: Sun, 29 Mar 2026 08:30:50 -0700
Message-ID: <20260329153052.46657-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260329153052.46657-1-sj@kernel.org>
References: <20260329153052.46657-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: BFF7C100019
X-Stat-Signature: 6ks8esxszwrmtqtbup51e7x79nejrfib
X-Rspamd-Server: rspam06
X-HE-Tag: 1774798257-998395
X-HE-Meta: U2FsdGVkX18zUkfIUQVUicRCaTVYi7dFGUO7oDweJ9zCTvYiTVBdwOEmVnAdGJETh5Rg491hOkbM+zs7yQ+FkzUg66riRlNlpKdlOScqtEbS9JwEoE+C1tQzYwlnztTiMUhE9Hgdr8roi0tOL5tGbRGwOIlG4zeBhptGTjwfLC4reOgOq3zcdaIVfXJHd98FkyA6XBU5qsJIapuPbKlYUMrhLg2vUbsKKym5isKlqx/G8TnGT6xmGL+BbeI2jTHTXStcbry5RF2kntk9VF+4hq1OXlsjhIF2PsDyEKZIhaLFuyI5HzwNMTmrwCKKCgZ2gVCTi/rwowsMAQijgy9qYWqgl4/yFezQzfXh7ZI/oEAAU3oBRK4pgIl5qkdbo1MeESdQxgB5vCWBH0DPr91jImsmrgqpZJ2NruEEJG0iry3KWOqZOp8htkcc14KzZpO9Xq84/KJdEMfkm20aByYkp1KpcWhfp+ni2FtscKEACU2zVQYhY31Oiuxs0YqlRYPndzvowEvOZkO+zet785yorIwIf2OKp9EohB0zs58TAYv/FjSCjK9ZvQSMSHtUIG0cZP+H3tQzqKhvjEjwwyERUrRxSCToIXN+E7mxTUntlvGiqzrxmiOLqfZRNN4EOAZEh6M7J9JcbX1/puLBFHm9MmKBC7rC37ZSMz4Lih5NKuxJzqOFMdcvDaLAoPcitJV9u35JsewdGjsqDqEDdk3lsv9fkSfBPd57PkEUOOcOWOZJIW6Tlya7Q7j5zhkNWY/9eqNumfXpVbi2sb/WRBsaOZb7Wip2sCgmj9/twa4qlPKDAE++rSt/rvJJr5vxH5hNumUIoGUYkUM6azqmp2oVUu7bdAV21IFGBuaLNVRenYBbspfCj5SooL3zY5CW7fxj20lK6AbbSw3pymGlBkVBh3OtkMhGXbApe13k4sxZSxCiOopB5I+gN4LtRBkhxvpkgj5QxfIqL9nOT4AdYqv
 pgme8jZg
 A5Uaa1a4ogmB3a6Ez6QTZpiR+QioZhV8Pvfm56TfI0KKwlQ/H1V3xNg7gm1moaD7Rs4jPBtW+9kjvj2vGsYf9mLVF5X6zBtripvaeuVCdCJo2PQdyuGWP7xrHSZCeLmr4H3RgJmio3Jo5FviRkBluoqRa92FPmo0y67/jPLcWjiL7c5SONGSVwk2FY25RUapWPjssPWvsic/OzXDtTh24n2V8PgdAUt+3+UPMjw+f9SA3b/O4YcaBOOnf2zEusvUXdWmAoqBeCadgPXQJbNyGdIenBS0HLpat4yIJ5JeWmKqm2jHtUAWxIRzSyDXgKBUiOfQjNSRoTtXKegfL/9PbBk7gXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_LRU_SORT handles commit_inputs request inside kdamond thread,
reading the module parameters.  If the user updates the module
parameters while the kdamond thread is reading those, races can happen.
To avoid this, the commit_inputs parameter shows whether it is still in
the progress, assuming users wouldn't update parameters in the middle of
the work.  Some users might ignore that.  Add a warning about the
behavior.

The issue was discovered [1] by sashiko.

[1] https://lore.kernel.org/20260319161620.189392-2-objecting@objecting.org

Fixes: 6acfcd0d7524 ("Docs/admin-guide/damon: add a document for DAMON_LRU_SORT")
Cc: <stable@vger.kernel.org> # 6.0.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/lru_sort.rst | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/admin-guide/mm/damon/lru_sort.rst b/Documentation/admin-guide/mm/damon/lru_sort.rst
index 797962a459e6..25e2f042a383 100644
--- a/Documentation/admin-guide/mm/damon/lru_sort.rst
+++ b/Documentation/admin-guide/mm/damon/lru_sort.rst
@@ -79,6 +79,10 @@ of parameters except ``enabled`` again.  Once the re-reading is done, this
 parameter is set as ``N``.  If invalid parameters are found while the
 re-reading, DAMON_LRU_SORT will be disabled.
 
+Once ``Y`` is written to this parameter, the user must not write to any
+parameters until reading ``commit_inputs`` again returns ``N``.  If users
+violate this rule, the kernel may exhibit undefined behavior.
+
 active_mem_bp
 -------------
 
-- 
2.47.3

