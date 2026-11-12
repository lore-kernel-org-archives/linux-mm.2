Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 489DA60A2609
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 10:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=TcCv8MYk
Received: by kanga.kvack.org (Postfix)
	id 5916A6B05B8; Thu, 12 Nov 2026 05:05:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 541C26B05BA; Thu, 12 Nov 2026 05:05:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 430F86B05BC; Thu, 12 Nov 2026 05:05:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0D1996B05B8
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:05:00 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 98C511C3C5B
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:04:59 +0000 (UTC)
X-FDA: 85426033518.06.3C61F02
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf31.hostedemail.com (Postfix) with ESMTP id B700E2000B
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:04:57 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=TcCv8MYk;
	spf=pass (imf31.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794477897;
	b=4HCh5cYCibvALJVbo0CvIRJfjWNWLImgoIADZWQNfZHiIE8SpgwPW5qr7Ncl014Va5p2+s
	AijoH3apzwqFcfNmtVOAPuCI8QO8kg51RNJdMeVTvPVaaetXS6G667DbBt9CLRn58dUTSD
	+50UqauC/CQiARfuAERINAca3I+bW7c=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=TcCv8MYk;
	spf=pass (imf31.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794477897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=srD7b7Ep/Si4Uv1VqcvOlOJ9O0diFeTtKplDChpFe6g=;
	b=nDIrgT0Ho7RN8gAEL9r4tklmRkC3ATXNznb56LWG0PPXwEnWxFGV9VpPPAjREXD+F71s2V
	hdJrQ+zuEu1k95R7Yy9isVrF8gcrbBhH1r6TfdFwAwGc2WJgqJ33L1g/7jYsG0ajTfSBul
	GmSj3PeBA4E8Qn/z5fjCEFR/Ho2rrN4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:
	Reply-To:Content-ID:Content-Description:In-Reply-To:References;
	bh=srD7b7Ep/Si4Uv1VqcvOlOJ9O0diFeTtKplDChpFe6g=; b=TcCv8MYkIVyCdESd9ViyissnNb
	ADAi+Ci5YmHVu2Vj55Ao1yjPViMWUCPBkeTLqb5YhOXzVq4rMEKaUPr4HA6FD0fDIziXWmUD4x1Qi
	fPoFiAhjWJEJrSPLoMyHsKjI5uljG7+W+ISyE/UwcDVMpneFThzje/jE/qXUyyAiQHm6ppUcT7jrk
	k5h6+S1C10sjUp0midAhGihYhHjjeP+FuFiFotqrCPJjX4xwrVI9SfEG704EII8nZZIO93UxL39EX
	pBVJljmr+uTlvT2RK3mnUiRh9CiYipq2/KCQ32ttj5nG6nhrtO18/VCouYAdeO1z+pzCrxjyFG1rt
	ogJH2dIQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xRRfn-00DssJ-2G;
	Thu, 12 Nov 2026 10:04:52 +0000
From: Breno Leitao <leitao@debian.org>
Date: Thu, 12 Nov 2026 02:04:18 -0800
Subject: [PATCH] slab: allow sheaves for SLAB_NOLEAKTRACE caches
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261112-kmemleak_sheaves-v1-1-e40e3d73b253@debian.org>
X-B4-Tracking: v=1; b=H4sIACeP9WoC/x3MWwqDMBAF0K0M99uAE7FgtiKlpPVWBx8tGRBB3
 HuhZwHnhLMYHUlOFO7m9tmQRCvBa8rbyGADkiDW8aaqdZhXrgvz/PCJeaeHZ9M22naah6ioBN/
 Ctx3/sr9f1w96GXE0YgAAAA==
X-Change-ID: 20261110-kmemleak_sheaves-b3531591ad21
To: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 Catalin Marinas <catalin.marinas@arm.com>, Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=4171; i=leitao@debian.org;
 h=from:subject:message-id; bh=MLIdxiVYr0DykPJmiS1vQneQqXpmkadDVW7FJlirFLM=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBq9Y9A2ObEikrSuWD4D6AfZFba14UUyXj1BQJy6
 oYycboraESJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCavWPQAAKCRA1o5Of/Hh3
 bXCUEACZgA+GkTSzeaJdyEh+2nSyorQzJFWP6Jv3W5KJgVCECtKeKV4Yd04X9XYCIG+aEFuPat9
 r/gz/uZJqKRwnJeWCkgCdJaguu0OduUm2JJphP4vG9inC8fBun2FIp8scbxNq/RR+YjD0JaG8yd
 C1Fm/XwMXFShRrq6PlSCUGgkCCTRZkNbVa5aqN8JOwI1gw189SpWd6Ogmm4YfJIGVNd48tqtoRS
 XOt71tuBzhve29nFhpluf8Imf24owalpf6AwT4UzM6WanaXZx+hAAHBg841jWlXhBcIr3uLpuOH
 xvErIDZuCSALHJ1nNkOOosMp9XGSU9b/VKU9+Y2ASG46r+ZbT5FpsTURY1EfGmH78pJasoGD8+Y
 667J4m03ddSbCHSY7l+y8/G0kOy1PoAobo6ATGCvhnrdkkMrguLr/v+DhF7FEKH7qDMqe+EVHvf
 /LlgKQ7dhMqDg49aITqq+cirxiaEOrcLqGEA2Pm2Mzm4AzOD/DH3FKquCQol+gN2rLSE7Z2HYSw
 6CWqem4nea9Bs3Qk4vPN0j3q+LFGtx3gteJ63JeQdBvxXhhrd7VnYdiaTLH/4ThMZDbq2k1ABjj
 vQP0/cmM9eS4WYO+e5NUFb35TSJ0yllhLPHeaRIcbOcGitn/6RrwmeJAufpM6/hA3m7WXwoqYPh
 x4Y66BjwKQ5QMnQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Stat-Signature: i6aqbdsh9w8bkg5sshpgyy8ss1zh7k4t
X-Rspamd-Queue-Id: B700E2000B
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794477897-331326
X-HE-Meta: U2FsdGVkX184Phv9kGUWZpZbL+FtXbkpNlvaGVY5bQKpX31F+hByPT2x4CTCfH2GgWHRo84fYGIEwPLol66eeV4tJSNQv07N83C9+fF/xBnopuCfuK8vjld7EoGXvIycQce7c9By7iINE7oIYmMzRcryfcp64GILRXhHw3ZBvrX11Ys1flLXDBM/6f6Q4qyArENULsqRTz60keuVusDqnBalq56w2KDJVj5YpIgnOFQUtQNYyL8tekFbzEWptchkwypGQQ+cf146tljfVcj91EXlhRr0l+9yDxjUu+KLYBGLVz9a5QX5cfDV1Y9JQ5ZEjedab/Xl/7LQdvh2Ts3fgHVOvkPdlUqAA1Q3+FsaCrrn/GJYKxj1VZ3qlHo+mXN1LbVj0zTABhYQDC6O0oXaskpx/Q7diZxK0LOpZ7qie/+3HNGObo5FbUTbunesI45qTU979poqiW6Z0XrMTSO7Oha4MJ8g+WtAXfazQLuPUHwYPkcpfJ/2Lgq0PMKUP/kBnO9LpwQCLHlH8VLtuPpFWmhbipEazDzJsLPiWrTi5m168JNxWsmf06tLtYhwErPZqxTTn2yNxGzMWmPZZcXfmV8CnBNthiZHEUgZKsq5uVpKM6L35MbszPOnUkflkpOfYNf7rxNOGp8n7H1dLVmzrmAvEUlSwwN3zIEsVHzHvvr6zA+Q+NxKlbBO3bkjRpuydXM6QercC8k6/Ys5ZXqyDXDUfAKx8ahuAYPzGSig/sTkoo2bgGKTBlOsogSJR+7+rEl2j82PjMMnT7r/RKfwqCdUmk5c7NpT8FoZmOfvbiNmnhtl/RK97Fuf7hK0vBkc5mQ/0YoOF2Usa42rreg1YSxqC4SB/rpvPbFhAKsFXvxB1562S/r+T+xVib8J7Ctgri+Xfil6k6cfThSBHWIIIz/JWRLc1K6l4kxRcaXPqWh9SwWwbwjLBMb8Sov6YSVL/8uLDr2fYrEKxx6mtgd
 7Lk2k2Dh
 OnwCexTeSuUReAD99t0gfAOf6qHlyktTbfSOOKq9ApHLpDk1EihGkI/lSzQzJ0inizo6c1NskUoAIm2E6myyHkcsWWFEs+b4nKC6VTrTh8IyVAMb6TQ4cBjOWnuO42U0fMOlOBhKl8X92IemA3ITaC5w86hyNRjrh5ag16LHLTTxPxzkOIHf7ciSHAnB8LSSnLHl9GtJJ3NkM8TvY7QwmImKJXzJHzjEns3mVCU3Ffqf9d0jgneCNoXsO+jK8AaRYyx1PYdAFeWSIj1EuMC1VA6nxQ7O3Ey7VzheuVBy6Y9tJXexfhgQAK+kWAk2upgTWZWgbieZl4YlxBJvJOmrc+oeQ23tRhjcHcN0IPLPAJRDx3RjtuMAIpg7k7SN0xpTZN3Bv7pYPsxqb99mK8tWzbQjk4S/2/l91G0doh1mvsQObJNf/FIFmwD2OGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This is a patch that makes kmemleak cheaper to run, by letting
kmemleak's own metadata cache use a _new_ sheaves type. The flag only
makes that possible without recursion.

The cost today:
  * every allocation kmemleak tracks needs one kmemleak_object from
    object_cache. An RCU callback frees it later.

Why that's slow:
  * object_cache has no sheaves, so each of those allocations and frees
    goes to the shared slab lists under n->list_lock.
     - On meta's fleet kmemleak kernels, list_lock is the second most
       contended lock, after kmemleak_lock.
     - About 88% of that wait is RCU callbacks freeing kmemleak objects.

Why sheaves aren't allowed:
  * a sheaf is a kmalloc object. Tracking it makes kmemleak allocate
    another kmemleak_object, which needs a sheaf, and so on.

When I reported the recursion in [1], I suggested keeping
SLAB_NOLEAKTRACE caches away from sheaves, and commit e47c897a2949
("slab: add sheaves to most caches") did that. It stopped the
recursion, but it took the sheaves away from the whole cache, although
only the kmemleak tracking of the sheaf itself recursed.

Commit 17c38c88294d ("slab: remove cpu (partial) slabs usage from
allocation paths"), from the same series, then left these caches with
no per-CPU caching at all.

In hindsight, skipping kmemleak only for the
sheaf itself, as the new SLAB_ALLOC_NO_LEAKTRACE does, would have been
the better fix.

Link: https://lore.kernel.org/all/aW_NK2NXVgtuzCVH@gmail.com/ [1]
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/slab.h |  1 +
 mm/slub.c | 19 +++++++++++--------
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index e94ac63d10dc03..7b20f10aa46a2e 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -23,6 +23,7 @@
 #define SLAB_ALLOC_NEW_SLAB	0x02 /* a flag for alloc_slab_obj_exts() */
 #define SLAB_ALLOC_NO_RECURSE	0x04 /* prevent kmalloc() recursion */
 #define SLAB_ALLOC_NO_OBJ_EXT	0x08 /* prevent obj_exts array allocation */
+#define SLAB_ALLOC_NO_LEAKTRACE	0x10 /* skip kmemleak tracking */
 
 #define SLAB_FREE_DEFAULT	0x00 /* no flags */
 #define SLAB_FREE_NOLOCK	0x01 /* spinning not allowed */
diff --git a/mm/slub.c b/mm/slub.c
index 8369853ddca721..f19e20b6f9a4fa 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2850,6 +2850,13 @@ static struct slab_sheaf *__alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp,
 	if (s->flags & SLAB_KMALLOC)
 		alloc_flags |= SLAB_ALLOC_NO_RECURSE;
 
+	/*
+	 * kmemleak allocates its metadata from SLAB_NOLEAKTRACE caches, so
+	 * tracking their sheaves would recurse into kmemleak.
+	 */
+	if (s->flags & SLAB_NOLEAKTRACE)
+		alloc_flags |= SLAB_ALLOC_NO_LEAKTRACE;
+
 	sheaf_size = struct_size(sheaf, objects, capacity);
 	sheaf = kmalloc_flags(sheaf_size, gfp | __GFP_ZERO, alloc_flags, NUMA_NO_NODE);
 
@@ -4727,7 +4734,8 @@ bool slab_post_alloc_hook(struct kmem_cache *s, gfp_t flags, size_t size,
 		if (init && p[i] && !is_kfence_address(p[i]))
 			memset(p[i], 0, zero_size);
 
-		if (alloc_flags_allow_spinning(ac->alloc_flags))
+		if (alloc_flags_allow_spinning(ac->alloc_flags) &&
+		    !(ac->alloc_flags & SLAB_ALLOC_NO_LEAKTRACE))
 			kmemleak_alloc_recursive(p[i], s->object_size, 1,
 						 s->flags, init_flags);
 		kmsan_slab_alloc(s, p[i], init_flags);
@@ -7987,13 +7995,8 @@ static unsigned int calculate_sheaf_capacity(struct kmem_cache *s,
 	if (IS_ENABLED(CONFIG_SLUB_TINY) || s->flags & SLAB_DEBUG_FLAGS)
 		return 0;
 
-	/*
-	 * Bootstrap caches can't have sheaves for now (SLAB_NO_SHEAVES).
-	 * SLAB_NOLEAKTRACE caches (e.g., kmemleak's object_cache) must not
-	 * have sheaves to avoid recursion when sheaf allocation triggers
-	 * kmemleak tracking.
-	 */
-	if (s->flags & (SLAB_NO_SHEAVES | SLAB_NOLEAKTRACE))
+	/* Bootstrap caches can't have sheaves for now (SLAB_NO_SHEAVES). */
+	if (s->flags & SLAB_NO_SHEAVES)
 		return 0;
 
 	/*

---
base-commit: 630059a5a632377b9b7b487baccde92b7ae1dd47
change-id: 20261110-kmemleak_sheaves-b3531591ad21

Best regards,
--  
Breno Leitao <leitao@debian.org>


