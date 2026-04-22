Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75154F9EDFC
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 15:26:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A640A6B0088; Wed, 22 Apr 2026 11:26:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A158A6B008A; Wed, 22 Apr 2026 11:26:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 903D46B008C; Wed, 22 Apr 2026 11:26:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7DA926B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 11:26:44 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3C43789C42
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 15:26:44 +0000 (UTC)
X-FDA: 84686569128.17.B42D9D3
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3B3DA10000C
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 15:26:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JJeDVhHV;
	spf=pass (imf14.hostedemail.com: domain of elver@google.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776871602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mguVNYCKn1UqNE6wCiBdJA3G/L2uqCAslGSj7SsF/bg=;
	b=qeMPRA32psVHravjw/mGveSnJzP3wPOD2PVC8thBHU/OvjqNov41XnlbgamaJ8ieStHQof
	7zAGa7ZJrltIYjz7i6tjx5WtPUZyMu+aEF5Bj604/3YtoOUjthL5FbNAy13Et/jNL2AX1q
	IfcLb+XRbdVKLIdDs6vdYAtbhQkjuRE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JJeDVhHV;
	spf=pass (imf14.hostedemail.com: domain of elver@google.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776871602; a=rsa-sha256;
	cv=none;
	b=0k9jm9+tC9gLs4FPS7y5c+rd6CBl8w34gRDOOPL10JNDUgZMn7xSl0O506U55WupG1N6wX
	31f34pEc/YOcULB/K82/oe3QjOqsCmX7FuW3bImtkSn13QCxTeVkOIqWhb9mxA8rHLEPwh
	uuauaAsah4tt9OvTGW9m3G7jqe1WGiY=
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5a1307438ddso5155353e87.1
        for <linux-mm@kvack.org>; Wed, 22 Apr 2026 08:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776871600; x=1777476400; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mguVNYCKn1UqNE6wCiBdJA3G/L2uqCAslGSj7SsF/bg=;
        b=JJeDVhHVd4TaSMcdXO/Sf3XcRNTB95nPrFn3XalTdjmWi7l0bKZdO0qxjQbpareLhM
         c0zsVkQfYhlQxbpi33n0yTHAi1sfh3/axDmKgKjWL61JsXpgLdmdo8Bhw+3WzgLxG4k5
         +VFOsl8y2+YL5DwZiGnU62brZocxtQdz8oF9J43nWzOmZq8fCBXcwvZikyDEn69oykWb
         D85nEisOwmipsL8+tSXu7k3DfsBuPzr8dAyyz8lRldGgWKV+Z1h7cvF0/ezobhrJI3U1
         mS66lTb9nUnC+OP8bvJVbrT8v7RGf+xGaCPSqXsjZO3MEovYQAXBHUQRTOeqNUNf0uef
         tEeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776871600; x=1777476400;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mguVNYCKn1UqNE6wCiBdJA3G/L2uqCAslGSj7SsF/bg=;
        b=Pns8nsUlO2NDySKMPQGql8+lhyLmL30VW0cUqRLdm2iD/o4MDBySHsbXcrnI9vVFg4
         Q1YmFQbqM3VzeU/6G3pDQ4EqxqaE+mI0YPYFhHrWH7IO+Urx4fHK99GuBSZs1ciuoPYF
         DrkGl136kZatu9/+kr/E+fqNk6gNAm6CpElj7cyKB6maGYe3zw6hZNmpygNuh3baS5YI
         jHAD2G+6W01xfQjBvOgULuDJbcjnvHC9JbY3+xNNM2CpDfq1yQb8Yry1O1mwt5nA8k/G
         oD3vJqTDxQejxwrPQVb5xpDgNECTsNOxbVgWwY008C3CHkPUPvUFJ9LfTNGkV8JAoutT
         XrvA==
X-Forwarded-Encrypted: i=1; AFNElJ+mfHMA0yon8ltA0Hb7YZoG3txoALC0TnSeHnAyTfXXV5XNa2ScpcumjD9KsRj1y+rE4+PVQ8xdFQ==@kvack.org
X-Gm-Message-State: AOJu0YyL2eyBljK1BA0hueolFJWTT29W2j1IeWjQqVbN/byWO8jgh0TZ
	38F+KUits228LgH8ji8+tuRYLzuQJwgWeQck2wZt4qO+ou9MjnHoQWB+kNnK8P1isg==
X-Gm-Gg: AeBDies/1wQAsa8PIfJd/qy4HWrh016ilGNRuBp0P2fr412Ss65Q88IxPP25EwH/4Cv
	neHIRZDucMqwVUzADe9Kg3hFYS63+yvruwe8LWFX1DpXdPzDBJQgm/+VIM/lqaXt0dYIJ5CDaH/
	0tV/j4RO9Osbi7P7D1nSQfwqKWuDN9Z03ZEXS8kBSno+LLLxw0S2VyMD69j6VeoIKZWLXrBeB/i
	ydp2ta4mlBJey0pjw8LdRAs2ILqAfIEn0Ng1TeSP+/PbM+ra1chIWqbBFFKp/hMjcgpYutLH804
	ZVP6edFW4ooCb97TV8aW+U3H9c25ZDlzODdcgxAtiHDCbHZa9vkKTKZegm/rfkhx8P7+ibIe9Bx
	ymVyrPhcUqc2d+p4atTsDXA57r4WZKpQaBqDuNP4312soCaqBi5mmaaZlEBVfsOaTc6dam3+I+o
	vN0coCGFdx4EPz19dU51Tq5WsK29WeCKoGdYcaqNmAI+8UCqehNcTVwCHsRW8i3TSJaCuyHuMcX
	dbjZFrHy5Nzs0gi0BuQ
X-Received: by 2002:a05:6512:3d20:b0:5a3:ff44:f019 with SMTP id 2adb3069b0e04-5a4172ca21dmr9302999e87.11.1776871599679;
        Wed, 22 Apr 2026 08:26:39 -0700 (PDT)
Received: from elver.google.com ([2a00:79e0:2834:9:ec7d:19d1:709a:2171])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a4185ad30asm4558169e87.16.2026.04.22.08.26.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2026 08:26:38 -0700 (PDT)
Date: Wed, 22 Apr 2026 17:26:30 +0200
From: Marco Elver <elver@google.com>
To: Kees Cook <kees@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>, Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
	Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org, kasan-dev@googlegroups.com,
	llvm@lists.linux.dev, Andrey Konovalov <andreyknvl@gmail.com>,
	Florent Revest <revest@google.com>, Jann Horn <jannh@google.com>,
	KP Singh <kpsingh@kernel.org>,
	Matteo Rizzo <matteorizzo@google.com>,
	GONG Ruiqi <gongruiqi1@huawei.com>
Subject: Re: [PATCH v2] slab: support for compiler-assisted type-based slab
 cache partitioning
Message-ID: <aejopk23CsntyFOB@elver.google.com>
References: <20260415143735.2974230-1-elver@google.com>
 <202604210954.84C57E5E0@keescook>
 <CANpmjNO8CcR56LXAQf4GQhGcbU4MQkRCa7gVvwuAfvVrzEUhQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNO8CcR56LXAQf4GQhGcbU4MQkRCa7gVvwuAfvVrzEUhQg@mail.gmail.com>
User-Agent: Mutt/2.2.13 (2024-03-09)
X-Stat-Signature: xew5i3urfmz9jhzcmtzzejcenxc8c3j9
X-Rspamd-Queue-Id: 3B3DA10000C
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776871601-186274
X-HE-Meta: U2FsdGVkX1/GAJKynvC1TcrJZE5h/4NaPViA+k4gyo1ZPE/3UopChRmqTJEqeWrM7M17n8158m++g2rym0eBwn2ktsGhY/Alvm3jo92y0udhIyx3odSOpuDfyowS1Jf6BTIUDVsfLQUryerqnkbl6U7BXcCTOFxnODAoVrp0ZYK4mFJq7anFsSKee+zNooWtKgslgzL84dsmrPUt5+gZvP4bJR6GEb9mgOj0gHCRvromW+urewmYT7lIJrfINGNBtQdX1BjYxN9cB0xHCesTErcgsMDOT1GctJ/RBnp4ZqpKyCixOGkadiiGzDA7FN04bhUq5FzpWsVbl8qfCQHp/58DlR8WWyFyj+X9JUDNi4DQKuGlOtx9p2XOL813eh2AzW5WBBqrFdX7307l3AOOePUHJUePu8fLPcFqDnFttX6TXZ9vPUA1FVMxbmZKNCzhe4D70AQTO0GleiMcDxjSDu35bkr8QzjncR7uocy8rvEcFqQWr5d3glHgcrvx4qTASFstEvBbQmBPkSye3tm47EFiDuupsISow/xEkw1dJWun2Nr6OzOQ3iJlbfkI3xIJeFTX0kKOXD+Q7PqmodaQylm+zCM2RvZyurGDv7C6BquJCSZsiWJtEbgHdtvr/R7AcCd7bNghInBGN18X0IJ1jvM7rkl2R4vO8ALf0If87YrxSYXkQ2gOTE4mwf7QAqIhlMFXH+oCYEB58DPDW1jmNUa/oEaGmusF8Vw2xLNQtGfz3U1pSHQiSjZzHVzsxOVZ2zopKuFXdI+AkWtcJiRg+xx2u1zAy9IGUyJLcODoQI87gbuKgkarW0xRL2uR9amXlrfEMVjzvN5CwpoWe10U8x/1WzQAqPojsQXS6GbEuIjgkduMQSBzpX6GCsj/wJYB4/8Bsp44Tb4IZZr8FOMxUx6LTy6+XTWqFtBlzM7pTdT0yrHbHuYuJUaeSM2DCWQ29mv9LsUXk71zveV5Esu
 L+zETdKD
 mb09k3j7gp3yds8vnrnFTfmgjf/5RdADK2IzU49pQTBl51enRXho+i3cODRLEReyZm1/YPzoNdgVGk40NZFds5zcqPCq3XgrLACiDyeZAKxtrBaVHmwSpzBCaJUiDNrd1+MEvQnWwoXm+onK4Ha7/A6Zb2Fh4LZpQQKVEXv3geLENRBAqebAUnl7mbLqEhPaTYTKU90qxN6/4AyAfNu8pL/VOd2++eNuDa94LArHuxVxLF/MFGG3pW7VOrUKNfFDavD6WBZZyN77CBb89Jl7XkjBbJ0YJwE3dZEdKbeL5XTPBZR3bUo7VmJL6nwSLhh7VTJLdNQ+0NURI/VRTYLGwV4kGcc+S5n1mmWOeDniVr+2EyBtcjFwFuPV5jesmQzCowS1DAXH/ZC/Ic/diCdemITbr/gpwVswBy4YPzgduTF0OBUkvQHVazFN684ksqVMFJ2dkJDG2KFtTIKAv18tV8V5AX14rP2h1zoTz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 09:13PM +0200, Marco Elver wrote:
[...]
> > And actually, perhaps a global rename of the options so the selection
> > naming is at the end of the CONFIG phrase, and bundle the on/off into
> > the choice:
> >
> >
> > choice
> >         prompt "Partitioned slab cache mode"
> >         depends on PARTITION_KMALLOC_CACHES
> >         default KMALLOC_PARTITION_TYPED if !SLUB_TINY && CC_HAS_ALLOC_TOKEN
> >         default KMALLOC_PARTITION_RANDOM if !SLUB_TINY
> >         default KMALLOC_PARTITION_NONE
> >
> > config KMALLOC_PARTITION_NONE
> > ...
> > config KMALLOC_PARTITION_RANDOM
> >         depends on !SLUB_TINY
> > ...
> > config KMALLOC_PARTITION_TYPED
> >         depends on !SLUB_TINY && CC_HAS_ALLOC_TOKEN
> 
> There was a comment somewhere else that even introducing
> PARTITION_KMALLOC_CACHES might confuse users of RANDOM_KMALLOC_CACHES.
> I think completely getting rid of and renaming RANDOM_KMALLOC_CACHES
> has marginal benefit, and will cause friction for existing users (even
> moreso than already). I see little benefit here, and would prefer not
> to break user configs more than needed: configs that already set
> RANDOM_KMALLOC_CACHES, upon rebuild will be prompted to enable
> PARTITION_KMALLOC_CACHES; if user says Y, then their previous
> selection (RANDOM) would already be picked and they don't have to
> rediscover that it exists under a new name.
> 
> I can make this change, but only if you're sure the benefit outweighs
> the downsides here.

Upon further reflection, since the transition isn't smooth anyway, I'm
probably going to rename, but have them all use the PARTITION_KMALLOC_*
prefix so it's easy to just search for "CONFIG_PARTITION_KMALLOC_". I
don't see the need for a "NONE" variant - I've seen this pattern
elsewhere, and then you end up with users reading the .config and
concluding "CONFIG_PARTITION_KMALLOC_CACHES is enabled ... but oh never
mind actually it isn't" which I find confusing. This could be useful if
we had a dynamic on/off toggle and the default is NONE, but that's not
the case here.

diff --git a/Makefile b/Makefile
index f70170ed1522..d1f63ffb85f0 100644
--- a/Makefile
+++ b/Makefile
@@ -989,7 +989,7 @@ KBUILD_CFLAGS	+= $(CC_AUTO_VAR_INIT_ZERO_ENABLER)
 endif
 endif
 
-ifdef CONFIG_TYPED_KMALLOC_CACHES
+ifdef CONFIG_PARTITION_KMALLOC_TYPED
 # PARTITION_KMALLOC_CACHES_NR + 1
 KBUILD_CFLAGS	+= -falloc-token-max=16
 endif
diff --git a/include/linux/slab.h b/include/linux/slab.h
index 0537c3596163..b46300037ca5 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -501,10 +501,10 @@ int kmem_cache_shrink(struct kmem_cache *s);
 
 #ifdef CONFIG_PARTITION_KMALLOC_CACHES
 typedef struct { unsigned long v; } kmalloc_token_t;
-#ifdef CONFIG_RANDOM_KMALLOC_CACHES
+#ifdef CONFIG_PARTITION_KMALLOC_RANDOM
 extern unsigned long random_kmalloc_seed;
 #define __kmalloc_token(...) ((kmalloc_token_t){ .v = _RET_IP_ })
-#elif defined(CONFIG_TYPED_KMALLOC_CACHES)
+#elif defined(CONFIG_PARTITION_KMALLOC_TYPED)
 #define __kmalloc_token(...) ((kmalloc_token_t){ .v = __builtin_infer_alloc_token(__VA_ARGS__) })
 #endif
 #define DECL_TOKEN_PARAM(_token)	, kmalloc_token_t (_token)
@@ -732,11 +732,11 @@ static __always_inline enum kmalloc_cache_type kmalloc_type(gfp_t flags, kmalloc
 	 * with a single branch for all the relevant flags.
 	 */
 	if (likely((flags & KMALLOC_NOT_NORMAL_BITS) == 0))
-#ifdef CONFIG_RANDOM_KMALLOC_CACHES
+#ifdef CONFIG_PARTITION_KMALLOC_RANDOM
 		/* PARTITION_KMALLOC_CACHES_NR (=15) copies + the KMALLOC_NORMAL */
 		return KMALLOC_PARTITION_START + hash_64(token.v ^ random_kmalloc_seed,
 							 ilog2(PARTITION_KMALLOC_CACHES_NR + 1));
-#elif defined(CONFIG_TYPED_KMALLOC_CACHES)
+#elif defined(CONFIG_PARTITION_KMALLOC_TYPED)
 		return KMALLOC_PARTITION_START + token.v;
 #else
 		return KMALLOC_NORMAL;
diff --git a/mm/Kconfig b/mm/Kconfig
index 6d44bd2633bb..d8510913fbeb 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -265,12 +265,12 @@ config PARTITION_KMALLOC_CACHES
 choice
 	prompt "Partitioned slab cache mode"
 	depends on PARTITION_KMALLOC_CACHES
-	default TYPED_KMALLOC_CACHES if CC_HAS_ALLOC_TOKEN
-	default RANDOM_KMALLOC_CACHES
+	default PARTITION_KMALLOC_TYPED if CC_HAS_ALLOC_TOKEN
+	default PARTITION_KMALLOC_RANDOM
 	help
 	  Selects the slab cache partitioning mode.
 
-config RANDOM_KMALLOC_CACHES
+config PARTITION_KMALLOC_RANDOM
 	bool "Randomize slab caches for normal kmalloc"
 	help
 	  Randomly pick a slab cache based on code address and a per-boot
@@ -282,17 +282,17 @@ config RANDOM_KMALLOC_CACHES
 	  the randomization by retrying attacks across multiple machines until
 	  the target objects are co-located.
 
-config TYPED_KMALLOC_CACHES
+config PARTITION_KMALLOC_TYPED
 	bool "Type based slab cache selection for normal kmalloc"
 	depends on CC_HAS_ALLOC_TOKEN
 	help
 	  Rely on Clang's allocation tokens to choose a slab cache, where token
 	  IDs are derived from the allocated type.
 
-	  Unlike RANDOM_KMALLOC_CACHES, cache assignment is deterministic based
+	  Unlike PARTITION_KMALLOC_RANDOM, cache assignment is deterministic based
 	  on type, which guarantees that objects of certain types are not
 	  placed in the same cache. This effectively mitigates certain classes
-	  of exploits that probabilistic defenses like RANDOM_KMALLOC_CACHES
+	  of exploits that probabilistic defenses like PARTITION_KMALLOC_RANDOM
 	  only make harder but not impossible. However, this also means the
 	  cache assignment is predictable.
 
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 21ab7dd79b5e..ca5e2a6d4e46 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -742,7 +742,7 @@ kmem_buckets kmalloc_caches[NR_KMALLOC_TYPES] __ro_after_init =
 { /* initialization for https://llvm.org/pr42570 */ };
 EXPORT_SYMBOL(kmalloc_caches);
 
-#ifdef CONFIG_RANDOM_KMALLOC_CACHES
+#ifdef CONFIG_PARTITION_KMALLOC_RANDOM
 unsigned long random_kmalloc_seed __ro_after_init;
 EXPORT_SYMBOL(random_kmalloc_seed);
 #endif
@@ -1010,7 +1010,7 @@ void __init create_kmalloc_caches(void)
 		for (i = KMALLOC_SHIFT_LOW; i <= KMALLOC_SHIFT_HIGH; i++)
 			new_kmalloc_cache(i, type);
 	}
-#ifdef CONFIG_RANDOM_KMALLOC_CACHES
+#ifdef CONFIG_PARTITION_KMALLOC_RANDOM
 	random_kmalloc_seed = get_random_u64();
 #endif
 

