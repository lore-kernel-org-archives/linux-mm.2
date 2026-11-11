Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14F6C60A3829
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 15:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=JG/SU1Jf
Received: by kanga.kvack.org (Postfix)
	id F228E6B05CB; Wed, 11 Nov 2026 10:36:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E84E46B05CC; Wed, 11 Nov 2026 10:36:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC27D6B05CD; Wed, 11 Nov 2026 10:36:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BAA566B05CB
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:36:02 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5A54FC0336
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:36:02 +0000 (UTC)
X-FDA: 85423238964.08.647D82F
Received: from mta0.migadu.com (out-115.mta0.migadu.com [91.218.175.115])
	by imf11.hostedemail.com (Postfix) with ESMTP id 514794000D
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:36:00 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="JG/SU1Jf";
	spf=pass (imf11.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.115 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794411360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ymrbQazdLeg+pCGWurk8n0D0XL5o29ESgMmIKPn6rw0=;
	b=VqUvnFqcCrIaUJTioujOPDrBR1iTXbU4I7nSdlSnemUtkpsuPVkIX6jrnLS9JEriIUmBst
	NLROhVUlYJwz0OHztJPG2Va+MZefQKd78FT4g3pBmvGJpBsAddu0AsTVyBwRp82HGMFPZG
	Kb4C6r0C19awze0hF9uw2Q+vIRItO1A=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="JG/SU1Jf";
	spf=pass (imf11.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.115 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794411360;
	b=rJ7ER9yb+FhiSW/gX0uhRSiw76NYdRAvj6IumAHk0FE+jpzfkoy6joornR1SRNtgntGtTk
	VmsQ7E3jilYYSXf39TUNjWyHRxE+/R+MtK5sj0RVslkYdcOSy8MyliHT3eFSlLOGOWoK8r
	/vSXXMz0uExuLkJWqU7MFWjveDSytmY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=B4avA2HMujRiEbRvCpZxZXa2sgy7oVdlWYyRAX8qanU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794411359; v=1; x=1795016159;
 b=JG/SU1JfyZfJp6rRj2Cg0JsuugkZ86L8wxwJDSTG6D/eGP8A18fshrbwthMgADSH4ICWAktQ
 3f6/j1ihVo+FJ/xBdXoKuJCEELyDoXF+ewJqE9rMVZf96wY9lSiXwoYPdiQzxLs569sLSAgOOWq
 7efZrvHX2EzQbuWCALmtJV5Y=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 9c1c4dea31d188d1;
	Wed, 11 Nov 2026 15:35:59 +0000
X-Mizu-Trace-ID: 9c1c4dea31d188d1
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	davem@davemloft.net,
	terrelln@fb.com,
	dsterba@suse.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-crypto@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kernel-team@meta.com
Cc: Usama Arif <usama.arif@linux.dev>
Subject: [PATCH 2/2] crypto: deflate - use vmalloc() for stream workspaces
Date: Wed, 11 Nov 2026 07:07:40 -0800
Message-ID: <20261111153532.1036709-3-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261111153532.1036709-1-usama.arif@linux.dev>
References: <20261111153532.1036709-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ax494y8wi7j9k13h7cdcjji6cqdcx93w
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 514794000D
X-HE-Tag: 1794411360-692219
X-HE-Meta: U2FsdGVkX18i6QayywVJsludDg6wMrKbJeVGGWYBfXHRUq4Ief8/o/6q7kqk/7GKVvSGahuK+TZQGu5Fw2Kt1wrvBxGe85EVzMGV0qjmBv/iwF5t6Hi5aJA5xNGghGSmWpZKG+HH+isK9wEcLV6QMfbTfqP4fqeSAIKfoQHeh+rJGPgTxaANQuCugZzrszNtyYEgwytrI05KNs0qhNRJx82wlaE013a2gE1XGcCfw1yGex7QZkICPdCmG+DSIQWCdEhiDva5TSa3ib5l24ACw5VTklhvS55qnSOsGpjLYLPxS1yVguUF/f/CYFzankFc6GsjVxXcRIWpFYKtsfHz9vFKCfg//GQ61PLw/BazbXOa7uYIEo6wF4UxEvYDg455dmd+QH6cgymO4tNMG0+k9cbthfdDjjrGv09LXjsHDMEimMIThaUttxyoFby7jKdAacfhHlgdz7nF8jmVqM2B1eDtlJ38GW1TFbOMm84vL8wJA12gFuFCxSUw8vZFgznceJm4+quw3ecA8zm13WF42Z74v1B384g/ZPytLFXWFrDXpGZv5LUOSLPdeS2oatTpaJ/78zoA0dJ+w9Y2a8dBiK5li2mWlK7ZAEnZ2JtVGnRj0GGo9ftXvOtvBC2UFQT9NUMuLMMTXIZsjUEsLj0GmOxuvmYhemhA1E61X5Zs53co3Tye4yvlVW7GY1VmM3YaEfz5Acin3ELAMvAVkrKaFPLlQatB7deKa+5+FH41+rhb4L2IyCb+rO2VYt0DPnhAFjDN+rUIWvKriJ81lE8ZJSLnufPGY8tOioZ0icTq+m0JcU9/6YXwNVcaniOkTwdxBBgXojTuiSbJ+HS2LrKKjEY0Zuc95Qhv5rIOJuYUdiHTvuzkzYof3d8AkEJYhrRoGtVw8bI5JB/s03Txl1XsH91yN+CqUMFc+YNgK0RjLCb3199R3+V5aK4oostR5g6wmVZWvb4sfKaSdkHpZQe
 +zqGNko1
 QET4nCW5k2wrPUT+D4GF5x7dfwayiG0FWU+r7H7kAvncsYqA4RZbWlvrx9YnMituMUizGXt63VmwQ8M82PxNIX5DqVNUPsqNMAQh2jSlb1Fl8J33jpnC1ApQpUEZSnFQdV6Zhyj8vWE8Qgtnb8DU1vrmvVXdeTUFq+1gNaM87xmxkNYE/+JD8dhu0E9s+7NMm3g6uWRzekNhp5ANeu1QD1YuB5hfFb89ET8tk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The deflate acomp streams outlive the transforms that use them. One
stream is allocated during transform initialization; additional
per-CPU streams are allocated on demand. They are freed only when
the algorithm is unregistered.

In a 4 KiB-page x86-64 build, each stream requests 145,320 bytes.
If kvmalloc() succeeds via kmalloc(), it occupies an order-6 block
(256 KiB). vmalloc() needs 36 backing pages (144 KiB), 112 KiB fewer
per stream. Across 384 populated streams, that is 42 MiB less
workspace backing if all would have used kmalloc(). There is no such
gain when kvmalloc() already falls back to vmalloc().

Use vmalloc() and vfree() directly, as the crypto lz4 implementations
already do. This uses vmalloc address space, page tables and
bookkeeping; the figures above compare workspace backing only.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 crypto/deflate.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/crypto/deflate.c b/crypto/deflate.c
index 710ebba7ce850..a8692532a65da 100644
--- a/crypto/deflate.c
+++ b/crypto/deflate.c
@@ -20,6 +20,7 @@
 #include <linux/scatterlist.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
+#include <linux/vmalloc.h>
 #include <linux/zlib.h>
 
 #define DEFLATE_DEF_LEVEL		Z_DEFAULT_COMPRESSION
@@ -40,7 +41,7 @@ static void *deflate_alloc_stream(void)
 						     DEFLATE_DEF_MEMLEVEL));
 	struct deflate_stream *ctx;
 
-	ctx = kvmalloc_flex(*ctx, workspace, size);
+	ctx = vmalloc(struct_size(ctx, workspace, size));
 	if (!ctx)
 		return ERR_PTR(-ENOMEM);
 
@@ -51,7 +52,7 @@ static void *deflate_alloc_stream(void)
 
 static void deflate_free_stream(void *ctx)
 {
-	kvfree(ctx);
+	vfree(ctx);
 }
 
 static struct crypto_acomp_streams deflate_streams = {
-- 
2.53.0-Meta


