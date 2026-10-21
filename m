Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9530A606A31D
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 20:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=kDRd/9ax
Received: by kanga.kvack.org (Postfix)
	id AB82D6B07B6; Wed, 21 Oct 2026 16:57:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A68E06B07B7; Wed, 21 Oct 2026 16:57:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 958706B07B8; Wed, 21 Oct 2026 16:57:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 655A76B07B6
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 16:57:28 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DD78AC06AF
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:57:27 +0000 (UTC)
X-FDA: 85347844134.27.757B2CF
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by imf20.hostedemail.com (Postfix) with ESMTP id 31A691C0003
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:57:26 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="kDRd/9ax";
	spf=pass (imf20.hostedemail.com: domain of 3NCfZagsKCEUz1zllukyhuinvvnsl.jvtspu14-ttr2hjr.vyn@flex--suseendranb.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3NCfZagsKCEUz1zllukyhuinvvnsl.jvtspu14-ttr2hjr.vyn@flex--suseendranb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792616246;
	b=XZImL9/6V/sEXilmFOojHFAXmqzBlWPP0NmztWagNdybuDQLy6iZKy3knTwDbskqHMRowr
	oNc8s5UCK16Ktje8fWlC60jXB4bDnAqpkHlJhLDy9cFnXsopCRG7qrIlM6L8JGRAZ3gqN3
	pfDy08xOG/rAfrJFRMqjfzHQkDy0T8w=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="kDRd/9ax";
	spf=pass (imf20.hostedemail.com: domain of 3NCfZagsKCEUz1zllukyhuinvvnsl.jvtspu14-ttr2hjr.vyn@flex--suseendranb.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3NCfZagsKCEUz1zllukyhuinvvnsl.jvtspu14-ttr2hjr.vyn@flex--suseendranb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792616246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AMF4QHAGquMqZj2Vy845rVn3rz16W/4eYJ+XdOmh9/k=;
	b=moaQ6TZNQHXJ8drSCofiamdF9mVUXUTp5Y2MKx8A9fHusWzLINW7ccp6pnZCNMHCNiZxIk
	BNEHOKykhQ+rCS+I0QDAOS7rCTbVFmhyTAqk7nljCluZWvcplF0xGKvYTS4yfowt4lIENb
	b6gpraD8L7TS2TzaAEnEngmOMs6YJvM=
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cc7e0321ec1so1124523a12.0
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 13:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792616245; x=1793221045; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AMF4QHAGquMqZj2Vy845rVn3rz16W/4eYJ+XdOmh9/k=;
        b=kDRd/9ax3r4yve9X2l5QJdr8MVUPiud7xJdZWMedUxR9N7Qe6Jsv9in3cVRbYoPBmT
         lZi6n2n7XWNvJ1FbrKHSiIThfrS8XeS3mO7IIVtA7BvwTIAAHz5FaNo7MS28D5twxmrN
         zVGrKxUdvqhA5L1jaYpnB543VEr/GvB19PgTIb5BjGp/w/0yyNaZgnfdq8kMDYLfgOzV
         rLbHrH/74ETQV0EU/WnmTYSu1tOOgldwvn0LEJBUd7pmw3fB+7y5R2Ua5rZNZeOSczAL
         jWRYJ3xTofD0PDUt2auq+uXMSNZsHRUrOnqT6kMLGa7fmv0bE5HQfk8+/xvyQuTPzPio
         infg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792616245; x=1793221045;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AMF4QHAGquMqZj2Vy845rVn3rz16W/4eYJ+XdOmh9/k=;
        b=ZwmWaPqNKBQ7niHcyP1LRi8O3stLYK+TAugopKoOoBd2LVsdgHL5G2LvQWo3VpTWiF
         11my8DoRQQZNZs5XNm1ZSFC3YN+r0RvrYOfPT+Ne+C5/u7bFVpu3i9zC4dwYh+uy+jJb
         c+hBHxVZzCzhN6KEev2femxAukvSZExQMq7LB5UDky3yyw+kW1eYB37+0BQV5sorDhOd
         CLc7ZXHcaUGveYoX8r/N/22tW+hA5IdQNaM1nFTQeMxKeGjONAPcRxMy6H/DwnYGfuam
         5NTIlidsbsG7Y3Zkh1tKxV93LzDIKIskhMqd9ho/uHVDdhZpZQe1nmPEzEDDN/NaVoWa
         Ki2w==
X-Forwarded-Encrypted: i=1; AKwUvBxUu8kWdYPEueApG/JVGo7ikB5rmFRihFwQDTNUdJvT1ON37TfmcrSdREzDBDhtgJn+YYwAo7+SAQ==@kvack.org
X-Gm-Message-State: AFq9FYLG6Zq0MXtHKtq0bKt6Qr0cn1S6TtFxYZ5If1kBAywdU7dBPsGB
	Hr1dSKRlI8GbiJDlBvDPJbKORnUXCoO0d9rRqBlRNDVfhoKt4fJc9WzYyTgttqBfcNMWNDgx1ks
	Xg1/MvFSIlpaFH3THUi/vS0A5YQ==
X-Received: from pgbj24-n1.prod.google.com ([2002:a05:6a02:61d8:10b0:cd6:9a6f:2802])
 (user=suseendranb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:3d08:b0:3c3:6f6c:aa21 with SMTP id adf61e73a8af0-3e287dd5c8dmr2833277637.11.1792616244847;
 Wed, 21 Oct 2026 13:57:24 -0700 (PDT)
Date: Wed, 21 Oct 2026 20:56:26 +0000
In-Reply-To: <20261021205626.3286270-1-suseendranb@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261021205626.3286270-1-suseendranb@google.com>
X-Mailer: git-send-email 2.56.0.218.g1ec904b173-goog
Message-ID: <20261021205626.3286270-3-suseendranb@google.com>
Subject: [PATCH 2/2] mm/zswap: classify compression dst overflow as poor compression
From: Suseendran Bhaskaran <suseendranb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S . Miller" <davem@davemloft.net>, Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>, Nick Terrell <terrelln@fb.com>, 
	David Sterba <dsterba@suse.com>, SJ Park <sj@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>, 
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>, linux-crypto@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Suseendran Bhaskaran <suseendranb@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 31A691C0003
X-Stat-Signature: yukghrunpo3gdb13a3m8ktba9mm3ehnk
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792616246-449256
X-HE-Meta: U2FsdGVkX19iDAfejmNoyGXvPeGHegjr7fWDj7qJTLfmq/qbWGFbx9R/BlTJfzD4IgFrOKw7xt0S4T8VIeCAq8mgA9G3P9fhemLDxEGRQP6pVOfCFh/NOWhSOpefZAdAfXc/ihWW2fKGZ5iVqBp9KHC9TIZYeDatVAi2WlEZ9yt/Xy0sxRR5WLAxkY49zAVDzGoxwfWEG47SjkEJ5NyR97sbhbKHefGPNsWZkNm3Fj+4a/af8zfYF/WxQMnDsuTPrfwL1g6pZnxxE6/I25hHf2rXQQRmXFAO1LLE7aCBZgv+7dsK7Ed4UZdd9JXhF0JxHUIajMjPNC7GpXene6gQvYBGXU40jYeTa1UmCJbvtT1lAqZsPUpYLh6wISYobqQgCck8G8JrxbziuuGqIBPUVKVn73s/8IEenjWtMlV5QmdpJkcHIMVNVtPiYnqhDvmjFQTsYm7ql1fsiPYjRNcZnle/AOB+fg0Jh0nNtNiUk6LxzMdhRFIkCs5ein8sFENmkHFZa7WO/tHIfdqrg4RB6yBc+McTxMKaM3CwR8TNPEDssUHSgUic7VO0Y+WRHjV/x57NO4odFMbcUF8Be5y6qH2DiGGoUDAPPV1o2T6AbuQnScu5uZysuVpy6xgXCAOAWAEFHPZAwO1eulJqyUsT4ySxAm0VLfbgc1xYep0q9BMZ/gUvI9CI6ZFqIARkRxWtQoZpD8bYQjhAewOjoqyJ/F2EcaRlQSDCWreC3ZrwzbGzxLuTuBsCq2VCs6tfWS6Xe6iMpyYc987qu+RMQaE1/FIrS5UpgqWlRwJpSbf0IAQuPDQK8Cl6awZ7DoqNKoij7cMRa8w3XqT6Xzte3f9QC18ZEPWVj4mKK6kk4I757hgeOOmiCeEuRW3CXzeRbSB3qtkWywqJrhy3sUpeqPzKOojAqTClq31u8FCCjUhIour3M3z0FrUYjAS27axL21NVbotXPtf4cz7yxFQk4Dg
 eM+u2S9e
 /aPT2MuKA5pkIcJ+0nMWJkW4kpaiN9lUqcolwdvkPezRUl0aHCPESLQmNlGaHMryj3gzgSrL8ePMLTUun2dR0xKGwHBXUlvmeofEM+YQuAUC1SqgwVspOJzPEMbincpZY7YB5bMP1k4azT+ldkBgWCj+1f/kvSp3lCiw3ycgoaKNpflFWxxrQEj0hQcu3IicpxgG3JbkobFTiBgq0JCdmZwwC5qKRV52ptDQxR3SxY7G/3+GCUj58XefD/arKvJYXELaLdFC2kWORmiSJCfQaBGPNW/HxRcF36Q46lhMF1Znwpqoq56teORnIvb/SvDOePqLoUI3CX6wcEo19AxTukZi+BzVUWb2GKPLOx71RdU+BtGZ/iKXtLNur70LaWTVKLEcuaURzZJ03dzfEin4FbMv9qx5MLk/UbetngrCIBKQ9PUce68/j1jL+fPeOkpmystkk/xOSK2HYarT9TlpJ+8CGHUQJtjkuJoE4nRj5Fa86MQpB0+EAgrJmzG9RK2G0S2xFtDwEa+buM82mXUMTMXC6LoDI9FEHnl159jbgMBdzNEKZjfwJO2djAI1sRIUfNRkWM6bmeK+xpVeYdTv0tNpMZ2y3Hdlhe/Y3PkKbaQO1f1ejV1fZKz4Taw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Commit dca4437a5861 ("mm/zswap: store <PAGE_SIZE compression failed page
as-is") and commit 0b1bf60c324a ("mm/zswap: reduce the size of the
compression buffer to a single page") updated zswap_compress() to pass a
PAGE_SIZE destination buffer to crypto_acomp_compress() (so
incompressible pages typically overflow the PAGE_SIZE buffer due to
compressor metadata overhead) and check:

    if (comp_ret || !dlen || dlen >= PAGE_SIZE)

Because crypto_acomp_compress() previously returned -EINVAL on
destination buffer overflow, this check conflated destination buffer
overflow (incompressible page) with unexpected compressor failures and
did not set comp_ret = -ENOSPC when rejecting incompressible pages,
resulting in two user-facing issues:

1. When zswap writeback is disabled (e.g. memory.zswap.writeback = 0),
   zswap_compress() sets 'comp_ret = comp_ret ? comp_ret : -EINVAL' and
   jumps to unlock. Whether the compressor fails on destination overflow
   with -EINVAL or succeeds with dlen == PAGE_SIZE, comp_ret becomes
   -EINVAL. Consequently, incompressible pages are misaccounted in
   debugfs under reject_compress_fail instead of reject_compress_poor
   (leaving reject_compress_poor stuck at 0 and triggering false
   compressor failure alerts on normal incompressible workloads).

2. When zswap writeback is enabled, any non-zero comp_ret (such as
   -EINVAL from an invalid compressor context, -ENOMEM, or a hardware
   accelerator error) is treated identically to an incompressible page:
   comp_ret is cleared to 0 and the raw page is stored uncompressed in
   zsmalloc. This silently masks genuine compressor failures
   (reject_compress_fail is never incremented) and miscounts pages that
   encountered a compressor error under stored_incompressible_pages.

Update zswap_compress() to treat only comp_ret == -ENOSPC or
(!comp_ret && dlen >= PAGE_SIZE) as an incompressible page (storing it
uncompressed in zswap when writeback is enabled to preserve LRU order,
or rejecting it with comp_ret = -ENOSPC when writeback is disabled so
zswap_reject_compress_poor is incremented), while jumping to unlock on
unexpected compressor errors (comp_ret || !dlen) so
zswap_reject_compress_fail is properly incremented.

Fixes: dca4437a5861 ("mm/zswap: store <PAGE_SIZE compression failed page as-is")
Signed-off-by: Suseendran Bhaskaran <suseendranb@google.com>
---
 mm/zswap.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 37f34e406c8e..5f2a941fcaf1 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -881,12 +881,12 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	 * only adds metadata overhead.  swap_writeout() will put the page back
 	 * to the active LRU list in the case.
 	 */
-	if (comp_ret || !dlen || dlen >= PAGE_SIZE) {
+	if (comp_ret == -ENOSPC || (!comp_ret && dlen >= PAGE_SIZE)) {
 		rcu_read_lock();
 		if (!mem_cgroup_zswap_writeback_enabled(
 					folio_memcg(page_folio(page)))) {
 			rcu_read_unlock();
-			comp_ret = comp_ret ? comp_ret : -EINVAL;
+			comp_ret = -ENOSPC;
 			goto unlock;
 		}
 		rcu_read_unlock();
@@ -894,6 +894,9 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 		dlen = PAGE_SIZE;
 		dst = kmap_local_page(page);
 		mapped = true;
+	} else if (comp_ret || !dlen) {
+		comp_ret = comp_ret ? comp_ret : -EINVAL;
+		goto unlock;
 	}
 
 	gfp = GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABLE;
-- 
2.56.0.218.g1ec904b173-goog


