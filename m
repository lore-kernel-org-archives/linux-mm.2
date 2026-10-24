Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2882606A31F
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 19:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EfoDNYpT
Received: by kanga.kvack.org (Postfix)
	id 7C0266B05B4; Sat, 24 Oct 2026 15:34:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74C756B05B8; Sat, 24 Oct 2026 15:34:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C3166B05B5; Sat, 24 Oct 2026 15:34:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 146CE6B05B6
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 15:34:03 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 871E18044D
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:34:02 +0000 (UTC)
X-FDA: 85358520324.13.239695C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id EF527140002
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:34:00 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EfoDNYpT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792870441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HjEsKHyDFKj7HHX5WZLrUS4CLP7wbTWvbErAlhp6Z7k=;
	b=3abx5fU5VPa9Q3XKTRCKOgCm2HGdTuwi7Gp7KkUv1gS5ZRfUe+aQtWVN9jy1NizA96GKOD
	+f2KkcV+OeF/59hTjZCuVSXOWQXVEcyH1Yo0ap6u43Om4c4E7yVJVJNVjw+oZP2SgfGfqz
	l1o3XTptLNoV5ZWFRJUS1rPPJKaxlQ0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EfoDNYpT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792870441;
	b=rCnOCKKJo/5z96aPIpp9SPLhOzV2KNw0BSxEClT4XRDDbyoj6NI5j8/JK3ENtZLDtPrW+B
	YJXo2NLO1wzWYMuqV7tsxdqVdYq4Wzcn/meMhJVvNeIdTQd5j4Si6J1BcCHwNNpHQAsa10
	kta3RDSSTLvQrMasGpgJCsJDw2vvsR0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4E9D74363F;
	Sat, 24 Oct 2026 19:34:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B951F01825;
	Sat, 24 Oct 2026 19:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792870440;
	bh=HjEsKHyDFKj7HHX5WZLrUS4CLP7wbTWvbErAlhp6Z7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EfoDNYpTX4r7251gPD043Z1N82zWoBSTl5aNvZtonOA4CjNZ3L1eLdV95xz2RfATx
	 2faEgGwhj0NbSZZr7VkX0Q8X4/3r4FCxr5Zh6LMv2YSYHUARHCPMkCR59uwDPDlZmc
	 1jQENf/ehnrpbH94glJSmQAZtY2FGFwBYC7vVXrCMTg6LZaHEMBRQ/7JFdgRTK/68q
	 U0NH2cctz0L7JkiXtwHihVPr3EyRbK4hBlBdndEytlIS2aY/x+Geg3w1oWM56MTmaD
	 G3g9mTg+opI83yKo93OuXV0A83hfzIYdrCe0ltAbLOaWcB72/prR4m/cUlsm2mRn+O
	 saIR+PzEetDKg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 3/3] mm/damon/core: move static variable rotation to damon_ctx
Date: Sat, 24 Oct 2026 12:33:49 -0700
Message-ID: <20261024193351.87130-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261024193351.87130-1-sj@kernel.org>
References: <20261024193351.87130-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EF527140002
X-Stat-Signature: qwmou3czdwbwe8pnrw3ana8a5e5w9ugr
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792870440-485257
X-HE-Meta: U2FsdGVkX1/7UE2j55K/0VZBqocNYUmwj7FOgpeeVaR36nOngJ28BA2rEmsPkaBEv6bXQbvQwYlNkyLrlsLs0zPnqvuG31guWob4wMWgrPVKYHDKNHcAsagK9KG300afB96ayx2E+3XDfDjyPcBrMynvozJYLL4Pvn5dZ4fHWjWI+5Uam+cvRZiglZ0fim9uAL8x8dUctNBD2HZlNB6HCN3eDDIDHQANX4Vnq6FgS2FmaxtlUYUA88c5n0U3lliNk6I1CDNrTpx38nVQaIqhWSR+qtpO7m+JAiHIxXFO+tPZUl06GGSIuyK1YuVThCHj/SZtseMfE5HxtqW4DxSHreudzVdgvU+jdtNKyV6zDpiWCKpC+WtKxkDlmv9J3GD7njQRtBa2+cjaW9qhJ28pyTESmI88XwqrIE6HkMPVVvxsEzWs941ki4qn6OEVKwE1z9m3MsJ492fGfM31jlZkpgpSQbtTOJ0Ze8uwh0Gr5tXp0zuIRXNMe7Cbz35Kkg9VpUBm0c8Uip9JPuaDLxRnT6DNz9xFmTtiqC8rGRMaMZTJOZ6qJb7oVu55QAUZCLtDw66fmBMrDaOQZwKq6MWuenUXf7pLjVHsmKPHXbuDxeWCLSoYAHISq9qbnLcMIU5oYGEplCmlJ2mVtIZZQZQqGD88xWxfUcepjCYh90nCVtr7IElJOSs60yghQY0CFIKnpxaY7+eP4VQLFqpjw1bzdxEDiap6d1mTCZQsyg3r8zruBaCuVsbN3btDTN5iRc2M8GuYc6ybbYxCNssA5aXuVwAkzB/ckl0QUD9gpZeLNWAvnafZCEhg5OY4XPKHGLastcKE2jkEQp4FgYKPow8D6m7VDMDsvjdtX04ibTL/Q7n07IAu+c4mhB+JIc/W6IBeH4JmJuyFgKyU21HK3eNx86co7eAYoniuES56iJv3j65D2070xpH8HVzOaxKnzv2w2AMV9vRRfHjwG48t63j
 eRB9u1Fe
 XNtjpUV0j+P6l8OOYVf7Dlo+jgV3AE7c/ACJOXI7SbDAtEfooTKYAOW/ARm2jMNhAeiYCstWh6VH7lw6SmLnBnP+OSdhfxYYmN9/GD2pCFmSKVjg1L+JDx/SBCp9AGnQe3nCiFDBcknuEaqodXOIrl40+m/3llfwLcZwr9ZUEqBNXjs8ZYRe37SmQm+XBR8Xse5N50yLxGiqu32unOt9n2YfjP6gfJdmPQCpCADQmsAsvo5EB1pZuDaWxM/8OJbi2RCJIAs1eKrqIH6vyR0vpRA4pZ/+v6sX3dLyqQq/kFBEcz7lmi1hzWQDXLPoDHHghmKLQ62METd1hJu1RVPQaNcwu1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

damon_split_some_reigons() uses a static variable, rotation, to remember
how many times it was called.  It is again used to determine fair
selection of regions to split.  Since it is a static variable, it can be
indeterministic and therefore less fair.

The user impact is not critical.  No crash, no leak.  DAMON's
best-effort and indeterministic monitoring accuracy could be slightly
more indeterministic when multiple kdamonds are used in parallel.

Fix the problem by moving the static variable into the damon_ctx struct.

Fixes: 1a582e6e0174 ("mm/damon/core: split a fraction of regions when nr_regions exceeds max/2")
Cc: <stable@vger.kernel.org> # 7.3.x
Closes: https://sashiko.dev/#/bug/linux-eebfcdde-2881-48ef-8df1-e2019d2a47f2
Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 5 +++++
 mm/damon/core.c       | 5 +++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index cb6a50032a1eb..380f9cf6ddd82 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -963,6 +963,11 @@ struct damon_ctx {
 	 * for more details.
 	 */
 	unsigned long last_nr_regions;
+	/*
+	 * number of damon_split_some_regions() invocations for this context.
+	 * Read damon_split_some_regions() for more details.
+	 */
+	unsigned long region_split_rotation;
 };
 
 /* Get a random number in [@l, @r) using @ctx's lockless PRNG. */
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 09722257ce736..73b571b429cb3 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3753,12 +3753,13 @@ static void damon_split_regions_of(struct damon_ctx *ctx,
 static void damon_split_some_regions(struct damon_ctx *ctx,
 				     unsigned long split_step)
 {
-	static unsigned long rotation;
 	struct damon_target *t;
 	struct damon_region *r, *next;
-	unsigned long offset = rotation++ % split_step;
+	unsigned long offset;
 	unsigned long idx = 0;
 
+	offset = ctx->region_split_rotation++ % split_step;
+
 	damon_for_each_target(t, ctx) {
 		damon_for_each_region_safe(r, next, t) {
 			unsigned long sz_region, sz_sub;
-- 
2.47.3

