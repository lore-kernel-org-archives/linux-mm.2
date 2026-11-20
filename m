Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 540E460758CC
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 01:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ZudIgpoy
Received: by kanga.kvack.org (Postfix)
	id A3AF76B0694; Thu, 19 Nov 2026 20:07:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EC426B06B6; Thu, 19 Nov 2026 20:07:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DB476B06DD; Thu, 19 Nov 2026 20:07:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4FF386B0694
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 20:07:09 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C421A1C4811
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 01:07:08 +0000 (UTC)
X-FDA: 85453708536.06.926935D
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	by imf28.hostedemail.com (Postfix) with ESMTP id EF9CDC000A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 01:07:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=ZudIgpoy;
	spf=pass (imf28.hostedemail.com: domain of 3OZ3_agYKCNA7D4LLA2AA270.yA8749GJ-886Hwy6.AD2@flex--lrizzo.bounces.google.com designates 209.85.218.71 as permitted sender) smtp.mailfrom=3OZ3_agYKCNA7D4LLA2AA270.yA8749GJ-886Hwy6.AD2@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795136827;
	b=TChJMu26pezsGqAsnnVhIkWQkYszcTy7x4pn5wAaBeZ0BPyczsKFlBRD8SVJNaehnR/oWv
	ZixagBoEm4eOJ6pguEQfiHj/Hf0470aAdttJXtCYDunC+7IoXIGQwLCUZSLroHQtOiSPbL
	6BgvlaBP7vHSgn08Wymtguo8z0oWqxQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795136827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AQN5t7G6pHMdsBxUWuah6BOQAsYBhE4OD2pSiEYielc=;
	b=MJEz9CYxYD93E427J6KBaNcx//nCDLHcTf2T9IJsXqMAnT38BX2Hl+EGnSeLjDn0PhrszZ
	TntaQTJold+swsnXV6QdAFXPAm9POKO4Obk5QsRALGkJnpAVnoVkzy0/z3vdtwhrhopS8H
	jnxJY6pQxcLacgSNHQ2iuW4ixFunmjg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=ZudIgpoy;
	spf=pass (imf28.hostedemail.com: domain of 3OZ3_agYKCNA7D4LLA2AA270.yA8749GJ-886Hwy6.AD2@flex--lrizzo.bounces.google.com designates 209.85.218.71 as permitted sender) smtp.mailfrom=3OZ3_agYKCNA7D4LLA2AA270.yA8749GJ-886Hwy6.AD2@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c50547b4992so21699466b.3
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:07:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795136826; x=1795741626; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AQN5t7G6pHMdsBxUWuah6BOQAsYBhE4OD2pSiEYielc=;
        b=ZudIgpoy6/FFpA6O/Or3kb4vgxE1ZDWS6vrNUJ25mQkG1KcsvNzJc0JM+3usgbxkTs
         QvZzMNj6s4oPSXPMwcE4rR02pU41RkVwwpiu/EnHY4ocWysdtHd01mrSjRqxvdcM+0ax
         xnHDmjWbjSlBkPDaj/7WmNwQp3PyLpoAdOdv9iNiIBfv3YGSa2pcgL/kEkRjUiK8R18J
         saGLXQtEgZngF56aNe78Rrg374CIQV1FyEYPzDxHyXrhEqmRPBlYgbD99LyKggyV+DGm
         sjII62HqHEvDInwjuqdG2zxGymKhFbQF5WfrhrNriGc1LMuhYwuIrOc0pw++GncIzFHY
         41AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795136826; x=1795741626;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AQN5t7G6pHMdsBxUWuah6BOQAsYBhE4OD2pSiEYielc=;
        b=SXmHvNsg+R1ibSt8MLQ25nwK/CV4QMxJkVV00ZUS6JFUiS2vt+Lmo+R+Ml4/yNmplt
         Slm4WFsz1yl/AwMkXFg8vMNiH+F0oh/imRupJEuCrlHzJzCromU5gZ+xX1KTLDorYtbk
         6fco5lZm1D44nQFVSv41Lz7kl6YUqr5GUYxfB0mU2RV10vLbCfnrN20H/nXNpzNxRfUm
         CGJBkaupnXnNmvBmMwGhxOQ+TtbhIa/DucPIy6HAwxDYz7Am/Wa4eXYS0Vk//Kw5wqSu
         2d3pMNUNBJziM6Dy8Mt2Wi8I0kLfBreCrh8VsuMbTmBBgp5sLHbLX0UXXI+rSBB44QZU
         0vRg==
X-Forwarded-Encrypted: i=1; AL+hErEJTV1/YlJWQC6pizYVt6PvnJgui+pwmOmlm7KyqGin6VeutCeDPs7T8jrdYuUU9a6Ju8UuLIiFag==@kvack.org
X-Gm-Message-State: APuU4Z+Yc1zelFNzj6a06a6cFWTHvp8TcTjYD+/NtQMGrLyLcWAktMre
	0P3hjISqt/+VtQNjZnmEQ3emGWkPWAovw4dzubLmzGATuDxoMeUYPxqX+TCfZK2m8zX9SzaUmjp
	lDNVkmg==
X-Received: from ejeck19-n1.prod.google.com ([2002:a17:907:e1d3:10b0:c2e:3341:2b56])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:81da:b0:c51:1d9a:323c
 with SMTP id a640c23a62f3a-c513a88b0d1mr112105266b.15.1795136825044; Thu, 19
 Nov 2026 17:07:05 -0800 (PST)
Date: Fri, 20 Nov 2026 01:06:34 +0000
In-Reply-To: <20261120010655.467825-1-lrizzo@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261109182533.3594984-1-lrizzo@google.com> <20261120010655.467825-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261120010655.467825-5-lrizzo@google.com>
Subject: [RFC PATCH v3 04/25] mm/page_alloc: Extend alloc_pages() to
 __GFP_PISA and PISA block allocation
From: Luigi Rizzo <lrizzo@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@kernel.org>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Jens Axboe <axboe@kernel.dk>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Luigi Rizzo <rizzo.unipi@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Harry Yoo <harry@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J . Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Simon Horman <horms@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Willem de Bruijn <willemb@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Joshua Washington <joshwash@google.com>, 
	Harshitha Ramamurthy <hramamurthy@google.com>, Alexander Lobakin <aleksander.lobakin@intel.com>, 
	Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@ziepe.ca>, Dragos Tatulea <dtatulea@nvidia.com>, 
	Naman Gulati <namangulati@google.com>, Pranjal Shrivastava <praan@google.com>, 
	Mostafa Saleh <smostafa@google.com>, Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org, 
	iommu@lists.linux.dev, netdev@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: xq4xqn6ssp3sbtr3cej4bgk1g79kgt3p
X-Rspam-User:
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EF9CDC000A
X-HE-Tag: 1795136826-512159
X-HE-Meta: U2FsdGVkX1+SQXLknc+acFoQbNjTzencJDph61tS/gMsxCwdCGRGbWdH/Lhj6U/sZFphqTUEkIBkwpPtJ6GWIB9rtXt2hPQNVfYjirpeLoTAV4yJcExj9XevpNM+8JEFjWkfKGEh5xzlUlYELVVyNFySFoSGFPlPVDNLceZDYievtsDRfRvYVJ2wK0lVKAFLsK5RgJvg6vZLNBDEGqkhyu+X0xs9WiJ0o9rXUVDc3eYACM8g1+OX3eeY0f3A3jFjNGCTaqR/XPvZsGq9riRsiEECdqdhYESauuL77nd/abE1EG7pRp5PiYiWYS10iVVSqyOdfadGO7mEXZ4C/stMB0ZuqWjCPb6ms3N4qiikHkXHbu2qReG5sDajDKtm67+qQh6q8vx+/NNdSdGNPU2lH0htLV99cMCgJC7c/3fd3AkqqyALubK/L74k9PQdJfzHI/jNzH25vGQ5YcHcDoB1z0Ry1Sat6zu8xcuBb35d1YWI9V9RcBvCaE97R55wFUl2QtW6BKqkO1oHur+POoDs+mqoo6dtrteTCH5GwG7vfF9O4hrd5VV9eYrxNO4AyCwfIGvcTRL59Iw2zzaIQoNxg9dcLGfDbGccdaIfWznnJlXllw8I7QnuzBsn87U/LyYrqP3gIlYCHcHBK1Dh76AkFsrqeRlatHlue7X9wuLmRQCiw8WyBAATdkzkX96CJDeEU1eRVe7n+F67k3szYv6aCJNIq2+Jxy20doH67SqjVZ3B7KIeV2IFx/YC+JeYVvVAz1kB1Wn20WOHCu/0g5OLCPMHYgTZb3nZSwdHIOKs6qLyfqtj8QvvLN2fgzK9uyQsfcb9sUVg8keN+EwHJd1aJRhR9UFuBDitywArgcHUxoaVQ/K9T/jQMizn2mKHdacl7+bhKwZQs1mXJOPhSU1LNW6AJaiGPFXyAlOElD1MkQSGuDKWaJq5K8BQpOq6YskTC+3S4i0cH/1nGXF+Uji
 zDrDJRao
 vk6fY8EUiiNhlw1No346QgkCD6mQdpDstm5lL9WcGfuS5XOoGlwxBU2X8G0ekTXF+HCDhzM43MRpmfJ8qFTh5tRUJL+Qn3ZiPLJK+tKCDKKW/Ja846J856+gNyoNRuB5SrngZqwa6tjC+R6HyCuUcghQmKajoO8mQ72yKeztHh3Qo0jPP/t+LrN1bUyDRtMH71dKC6Ce4vbcirjQCtV/QSujObelTIVPX77/8XQB1NyN0mbWWmXBRaKAqEwTitWdtVslegpFWROOnO2spoR80BRGQ+n9YTFRdEhiNBaFj7neBFr7Wno//uOaAphC5XcBBJh73wvf+2mTwSlm3a3Cx3mMq/665krJe8uAQJfiqA5FyXRvhH96l6Z4LH1QE8CQhqkCjxcervA1lZfDxsE7MKGORtzzn4DZjSiDwLjmuDQLjEcQes+pcGt5/aksZCv1pFoFivASnJycJsYtbDrM4VQMtQ1yO/9NZa3il+G+bjdEFcyCsTZK+EWSNMqEo8ePt5NngT/sgz1WF/aTAq32/AfPl9YqYJlygcwewJDENJ+kQgemeMVamT/+K48NBOGZ+8fSVak2GLhmsGol/4HWrwz9vAsjRgqUpnAj4toxM+5eX2EYnVRfs45k8DE7uUn7j8gNPDwg3IU9nJrkQ4lkSIVJ0S6Q4XrUthzXwpouLXyVCGu+Fvo0kF4qCe8aRMO7b5ykMEJbcCw30eHDD9ql3/bbzUTQyShdjBQ7auLVXCyAoqO+ifC7fxWKggFKaLp2xI0LlRFMnzz5MSSwjlLI5sP67nKL22sseVPqPmgl/QUHzBsczHJgTg0zpzZiQHOgd8PZjNe1voXZ4kwLz3tinoVZevKWo4SULkZTFgngSx99Oxivrbg3e+swBow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add block allocation (pisa_alloc_bulk(), pisa_alloc())
and split_page_compound(), which splits a newly acquired 2MB PISA page
into blocks of the allocator's order, frozen at refcount 0.

Introduce __GFP_PISA and __GFP_PISA_RW GFP flags and hook
__alloc_frozen_pages_noprof() and alloc_pages_bulk_noprof() so callers
can allocate from per-node PISA allocators (pisa_nodes[nid].pa[ro][order])
using standard page allocation APIs.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 include/linux/gfp_types.h      |  14 +-
 include/linux/pisa-mm.h        |  46 +++++
 include/trace/events/mmflags.h |  11 +-
 mm/page_alloc.c                |   6 +
 mm/pisa-alloc.c                | 342 +++++++++++++++++++++++++++++++++
 mm/pisa-kunit.c                |  69 +++++++
 mm/pisa-priv.h                 |  15 ++
 7 files changed, 499 insertions(+), 4 deletions(-)

diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
index c1331bf0b2398..80d1371212375 100644
--- a/include/linux/gfp_types.h
+++ b/include/linux/gfp_types.h
@@ -33,7 +33,7 @@ enum {
 	___GFP_IO_BIT,
 	___GFP_FS_BIT,
 	___GFP_ZERO_BIT,
-	___GFP_UNUSED_BIT,	/* 0x200u unused */
+	___GFP_PISA_BIT,
 	___GFP_DIRECT_RECLAIM_BIT,
 	___GFP_KSWAPD_RECLAIM_BIT,
 	___GFP_WRITE_BIT,
@@ -68,7 +68,13 @@ enum {
 #define ___GFP_IO		BIT(___GFP_IO_BIT)
 #define ___GFP_FS		BIT(___GFP_FS_BIT)
 #define ___GFP_ZERO		BIT(___GFP_ZERO_BIT)
-/* 0x200u unused */
+#ifdef CONFIG_PISA
+#define ___GFP_PISA		BIT(___GFP_PISA_BIT)
+#define ___GFP_PISA_RW		(___GFP_PISA | ___GFP_WRITE)
+#else
+#define ___GFP_PISA		0
+#define ___GFP_PISA_RW		0
+#endif
 #define ___GFP_DIRECT_RECLAIM	BIT(___GFP_DIRECT_RECLAIM_BIT)
 #define ___GFP_KSWAPD_RECLAIM	BIT(___GFP_KSWAPD_RECLAIM_BIT)
 #define ___GFP_WRITE		BIT(___GFP_WRITE_BIT)
@@ -289,6 +295,10 @@ enum {
 /* Disable lockdep for GFP context tracking */
 #define __GFP_NOLOCKDEP ((__force gfp_t)___GFP_NOLOCKDEP)
 
+/* Allocate from per-node PISA allocators (fall back to buddy on failure) */
+#define __GFP_PISA			((__force gfp_t)___GFP_PISA)
+#define __GFP_PISA_RW			((__force gfp_t)___GFP_PISA_RW)
+
 /* Room for N __GFP_FOO bits */
 #define __GFP_BITS_SHIFT ___GFP_LAST_BIT
 #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
diff --git a/include/linux/pisa-mm.h b/include/linux/pisa-mm.h
index 60dae9ab6116d..d55a42397c4b3 100644
--- a/include/linux/pisa-mm.h
+++ b/include/linux/pisa-mm.h
@@ -7,6 +7,9 @@
 
 #ifdef CONFIG_PISA
 
+unsigned long __pisa_alloc_pages_bulk(gfp_t gfp, unsigned int order,
+				      int preferred_nid, int nr_pages,
+				      struct page **page_array, bool frozen);
 bool __pisa_free_page(struct page *page, unsigned int order);
 
 /*
@@ -15,6 +18,34 @@ bool __pisa_free_page(struct page *page, unsigned int order);
  * ============================================================================
  */
 
+/* Hook for alloc_pages_bulk_noprof() (guarded by @pisa_key). */
+static inline unsigned long
+pisa_alloc_pages_bulk(gfp_t *gfp, unsigned int order, int preferred_nid,
+		      nodemask_t *nodemask, int nr_pages,
+		      struct page **page_array, bool frozen)
+{
+	unsigned long nr = 0;
+
+	if (likely(!(*gfp & __GFP_PISA)))
+		return 0;
+	if (pisa_enabled() && !nodemask)
+		nr = __pisa_alloc_pages_bulk(*gfp, order, preferred_nid,
+					     nr_pages, page_array, frozen);
+	*gfp &= ~__GFP_PISA_RW;
+	return nr;
+}
+
+/* Hook for __alloc_frozen_pages_noprof() (guarded by @pisa_key). */
+static inline struct page *
+pisa_alloc_pages(gfp_t *gfp, unsigned int order, int preferred_nid,
+		 nodemask_t *nodemask)
+{
+	struct page *page = NULL;
+
+	pisa_alloc_pages_bulk(gfp, order, preferred_nid, nodemask, 1, &page, true);
+	return page;
+}
+
 /* Hook for __free_pages_prepare() (guarded by @pisa_key). */
 static inline bool pisa_free_page(struct page *page, unsigned int order)
 {
@@ -26,6 +57,21 @@ static inline bool pisa_free_page(struct page *page, unsigned int order)
 
 #else /* !CONFIG_PISA */
 
+static inline unsigned long
+pisa_alloc_pages_bulk(gfp_t *gfp, unsigned int order, int preferred_nid,
+		      nodemask_t *nodemask, int nr_pages,
+		      struct page **page_array, bool frozen)
+{
+	return 0;
+}
+
+static inline struct page *
+pisa_alloc_pages(gfp_t *gfp, unsigned int order, int preferred_nid,
+		 nodemask_t *nodemask)
+{
+	return NULL;
+}
+
 static inline bool pisa_free_page(struct page *page, unsigned int order)
 {
 	return false;
diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
index 3c153b3ad8450..c2b2ec99ab63c 100644
--- a/include/trace/events/mmflags.h
+++ b/include/trace/events/mmflags.h
@@ -54,10 +54,18 @@
 # define TRACE_GFP_FLAGS_LOCKDEP
 #endif
 
+#ifdef CONFIG_PISA
+# define TRACE_GFP_FLAGS_PISA			\
+	TRACE_GFP_EM(PISA)
+#else
+# define TRACE_GFP_FLAGS_PISA
+#endif
+
 #define TRACE_GFP_FLAGS				\
 	TRACE_GFP_FLAGS_GENERAL			\
 	TRACE_GFP_FLAGS_KASAN			\
-	TRACE_GFP_FLAGS_LOCKDEP
+	TRACE_GFP_FLAGS_LOCKDEP			\
+	TRACE_GFP_FLAGS_PISA
 
 #undef TRACE_GFP_EM
 #define TRACE_GFP_EM(a) TRACE_DEFINE_ENUM(___GFP_##a##_BIT);
@@ -65,7 +73,6 @@
 TRACE_GFP_FLAGS
 
 /* Just in case these are ever used */
-TRACE_DEFINE_ENUM(___GFP_UNUSED_BIT);
 TRACE_DEFINE_ENUM(___GFP_LAST_BIT);
 
 #define gfpflag_string(flag) {(__force unsigned long)flag, #flag}
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e053cc7298eab..af1399659a163 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5228,6 +5228,8 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	unsigned int zonelist_iter_cookie;
 	int nr_populated = 0, nr_account = 0;
 
+	nr_populated = pisa_alloc_pages_bulk(&gfp, 0, preferred_nid, nodemask,
+					     nr_pages, page_array, false);
 	/*
 	 * Skip populated array elements to determine if any pages need
 	 * to be allocated before disabling IRQs.
@@ -5480,6 +5482,10 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 		fastpath_alloc_flags |= ALLOC_WMARK_LOW;
 	}
 
+	page = pisa_alloc_pages(&gfp, order, preferred_nid, nodemask);
+	if (page)
+		return page;
+
 	gfp &= gfp_allowed_mask;
 	/*
 	 * Apply scoped allocation constraints. This is mainly about GFP_NOFS
diff --git a/mm/pisa-alloc.c b/mm/pisa-alloc.c
index 7ba93746f6a89..e7f7ed5dca067 100644
--- a/mm/pisa-alloc.c
+++ b/mm/pisa-alloc.c
@@ -15,15 +15,21 @@
 #include <linux/kasan.h>
 #include <linux/list.h>
 #include <linux/llist.h>
+#include <linux/memcontrol.h>
 #include <linux/mm.h>
 #include <linux/moduleparam.h>
 #include <linux/mutex.h>
+#include <linux/page_owner.h>
+#include <linux/pgalloc_tag.h>
 #include <linux/page_table_check.h>
 #include <linux/rcupdate.h>
+#include <linux/sched/mm.h>
+#include <linux/skbuff.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/vmstat.h>
 #include <linux/workqueue.h>
+#include <net/sock.h>
 
 #include "pisa-priv.h"
 
@@ -283,6 +289,331 @@ static bool pisa_return_block_locked(struct pisa_alloc *pa, struct page *block)
 	return pisa_place_meta(meta);
 }
 
+static DEFINE_MUTEX(pisa_init_mutex);
+
+/* Return *@pap, creating and publishing it under @pisa_init_mutex if NULL. */
+__printf(5, 6)
+struct pisa_alloc *pisa_alloc_ensure(struct pisa_alloc **pap, int nid,
+				     unsigned int order, enum dma_data_direction dir,
+				     const char *fmt, ...)
+{
+	/* Pairs with smp_store_release() below. */
+	struct pisa_alloc *pa = smp_load_acquire(pap);
+
+	if (likely(pa))
+		return pa;
+
+	guard(mutex)(&pisa_init_mutex);
+	pa = *pap;
+	if (!pa) {
+		va_list args;
+
+		pa = pisa_alloc_create(nid, order, dir);
+		if (!pa)
+			return NULL;
+		va_start(args, fmt);
+		vsnprintf(pa->name, sizeof(pa->name), fmt, args);
+		va_end(args);
+		/* Pairs with smp_load_acquire() in lockless readers. */
+		smp_store_release(pap, pa);
+	}
+	return pa;
+}
+
+/**
+ * __pisa_alloc_pages_bulk - Allocate pages from a per-node __GFP_PISA* allocator
+ * @gfp: GFP flags (must have __GFP_PISA or __GFP_PISA_RW set)
+ * @order: Page order
+ * @preferred_nid: Preferred NUMA node (or NUMA_NO_NODE)
+ * @nr_pages: Total entries in @page_array
+ * @page_array: Output array of page pointers (populated entries are skipped)
+ * @frozen: Leave allocated pages frozen at refcount 0 if true
+ *
+ * Return: Number of populated entries at the start of @page_array.
+ */
+unsigned long __pisa_alloc_pages_bulk(gfp_t gfp, unsigned int order,
+				      int preferred_nid, int nr_pages,
+				      struct page **page_array, bool frozen)
+{
+	struct pisa_alloc *pa = NULL;
+
+	if (unlikely(nr_pages <= 0))
+		return 0;
+	if (!order || (gfp & __GFP_COMP))
+		pa = pisa_node_pa(preferred_nid, order, !(gfp & __GFP_WRITE));
+	return pisa_alloc_bulk(pa, gfp & ~__GFP_PISA_RW, nr_pages, page_array, frozen);
+}
+
+/*
+ * Split a non-compound page of @old_order into 1 << (@old_order - @new_order)
+ * pages of @new_order (compound if @new_order > 0), all frozen at refcount 0.
+ * Fails with -EBUSY if a speculative PFN walker holds a reference to @page.
+ */
+static int split_page_compound(struct page *page, unsigned int old_order, unsigned int new_order)
+{
+	if (WARN_ON_ONCE(PageCompound(page) || !page_count(page) ||
+			 new_order > old_order ||
+			 folio_memcg_charged(page_folio(page))))
+		return -EINVAL;
+
+	/* Freeze @page[0] (1 -> 0) so all resulting pieces start at refcount 0. */
+	if (!page_ref_freeze(page, 1))
+		return -EBUSY;
+
+	if (new_order < old_order) {
+		split_page_owner(page, old_order, new_order);
+		pgalloc_tag_split(page_folio(page), old_order, new_order);
+	}
+
+	/* Subpages of non-compound pages are already initialized as order 0. */
+	if (new_order == 0)
+		return 0;
+
+	for (unsigned int i = 0; i < (1U << old_order); i += (1U << new_order))
+		prep_compound_page(page + i, new_order);
+
+	return 0;
+}
+
+/* Obtain and split a new PISA page on @nid into blocks of @order. */
+static struct pisa_meta *pisa_alloc_split_page(unsigned int order, gfp_t gfp, int nid)
+{
+	bool can_block = gfpflags_allow_blocking(gfp), clean;
+	unsigned int bpp = PISA_BLOCKS(order);
+	struct pisa_meta *meta;
+	struct page *page;
+	int err;
+
+	/* __GFP_DMA/__GFP_DMA32 were already declined by pisa_alloc_bulk(). */
+	meta = pisa_reservoir_pop(nid, gfp & ~__GFP_ZERO, &clean);
+	if (IS_ERR(meta))
+		return meta;
+
+	page = pisa_meta_to_page(meta);
+
+	/* Fails with -EBUSY if a concurrent PFN walker holds a speculative ref. */
+	err = split_page_compound(page, PISA_ORDER, order);
+	if (err) {
+		pisa_release_page(meta);
+		if (err == -EBUSY)
+			pisa_alloc_backoff(&pisa_nodes[nid], can_block);
+		return ERR_PTR(err);
+	}
+
+	if (clean) {
+		bitmap_set(meta->clean_bitmap, 0, bpp);
+		meta->nr_clean = bpp;
+	} else {
+		bitmap_set(meta->dirty_bitmap, 0, bpp);
+		meta->nr_dirty = bpp;
+	}
+
+	return meta;
+}
+
+/* Reset fields normally cleared by prep_new_page()/post_alloc_hook(). */
+static void pisa_block_prep(struct page *block)
+{
+	set_page_private(block, 0);
+	clear_page_pfmemalloc(block);
+}
+
+/*
+ * Collect up to @want blocks from @meta's dirty or clean bitmap. With
+ * @unfreeze they get refcount 1; otherwise they stay at refcount 0.
+ */
+static unsigned int pisa_scan_bitmap(struct pisa_meta *meta, bool dirty,
+				     unsigned int want, struct page **out, bool unfreeze)
+{
+	unsigned long *bitmap = dirty ? meta->dirty_bitmap : meta->clean_bitmap;
+	u16 *countp = dirty ? &meta->nr_dirty : &meta->nr_clean;
+	unsigned int idx, got = 0, used = 0;
+	struct pisa_alloc *pa = meta->pa;
+	struct page *page, *block;
+
+	if (!*countp || !want)
+		return 0;
+
+	page = pisa_meta_to_page(meta);
+	for_each_set_bit(idx, bitmap, PISA_BLOCKS(pa->order)) {
+		block = page + (idx << pa->order);
+		__clear_bit(idx, bitmap);
+		used++;
+		if (!is_pisa_block_poisoned(pa, block)) {
+			pisa_block_prep(block);
+			if (unfreeze)
+				page_ref_unfreeze(block, 1);
+			out[got++] = block;
+		}
+
+		if (used == *countp || got == want)
+			break;
+	}
+	*countp -= used;
+	return got;
+}
+
+/* @zero: prefer PISA pages with blocks in @meta->clean_bitmap. */
+static struct pisa_meta *pisa_pick_meta(struct pisa_alloc *pa, bool zero)
+{
+	struct pisa_meta *m_dirty, *m_clean, *meta;
+
+	if (zero) {
+		/* Clean blocks first: the head of @partial, then of @idle. */
+		if (!list_empty(&pa->partial))
+			return list_first_entry(&pa->partial, struct pisa_meta, list);
+		meta = list_first_entry_or_null(&pa->idle, struct pisa_meta, list);
+		if (meta && meta->nr_clean) {
+			pa->num_idle_pages--;
+			WRITE_ONCE(pa->idle_jiffies, jiffies);
+			return meta;
+		}
+	}
+
+	m_dirty = list_first_entry_or_null(&pa->partial_dirty, struct pisa_meta, list);
+	m_clean = list_first_entry_or_null(&pa->partial, struct pisa_meta, list);
+	if (m_dirty && m_clean) {
+		bool dirty_dense = !(m_dirty->on_list & PISA_LIST_SPARSE);
+		bool clean_dense = !(m_clean->on_list & PISA_LIST_SPARSE);
+
+		if (dirty_dense != clean_dense)
+			return dirty_dense ? m_dirty : m_clean;
+		return pisa_meta_avail(m_dirty) <= pisa_meta_avail(m_clean) ?
+		       m_dirty : m_clean;
+	}
+	if (m_dirty)
+		return m_dirty;
+	if (m_clean)
+		return m_clean;
+	if (!list_empty(&pa->idle)) {
+		meta = list_last_entry(&pa->idle, struct pisa_meta, list);
+		pa->num_idle_pages--;
+		WRITE_ONCE(pa->idle_jiffies, jiffies);
+		return meta;
+	}
+	return NULL;
+}
+
+/* Extract up to @want blocks from @meta under @pa->lock. */
+static unsigned int take_blocks(struct pisa_meta *meta, unsigned int want,
+				struct page **out, bool zero, bool frozen)
+{
+	unsigned int avail_before = pisa_meta_avail(meta), got = 0, used;
+	struct pisa_alloc *pa = meta->pa;
+
+	lockdep_assert_held(&pa->lock);
+
+	if (zero) {
+		unsigned int dirty;
+
+		/* First choice are clean blocks, followed by dirty */
+		got += pisa_scan_bitmap(meta, false, want, out, !frozen);
+		dirty = pisa_scan_bitmap(meta, true, want - got, out + got, false);
+		for (unsigned int i = got; i < got + dirty; i++)
+			set_page_private(out[i], 1);
+		got += dirty;
+	} else {
+		/* First choice are dirty blocks, followed by clean */
+		got += pisa_scan_bitmap(meta, true, want, out, !frozen);
+		got += pisa_scan_bitmap(meta, false, want - got, out + got, !frozen);
+	}
+
+	used = avail_before - pisa_meta_avail(meta);
+	/* If counts disagreed with bitmaps, zero them so @meta moves to @pa->full. */
+	if (WARN_ON_ONCE(!used)) {
+		meta->nr_clean = 0;
+		meta->nr_dirty = 0;
+	}
+	pisa_place_meta(meta);
+
+	return got;
+}
+
+/* Allocate @nr_pages blocks from @pa. */
+static unsigned long __pisa_alloc_bulk(struct pisa_alloc *pa, gfp_t gfp, unsigned long nr_pages,
+				       struct page **pages, bool zero, bool frozen)
+{
+	unsigned long n, flags;
+	struct pisa_meta *meta;
+	unsigned int want;
+
+	/* Held across bitmap scans; dropped around slow-path pisa_alloc_split_page(). */
+	spin_lock_irqsave(&pa->lock, flags);
+	for (n = 0; n < nr_pages; n += take_blocks(meta, want, &pages[n], zero, frozen)) {
+		want = min_t(unsigned long, nr_pages - n, PISA_BLOCKS(pa->order));
+		meta = pisa_pick_meta(pa, zero);
+		if (meta)
+			continue;
+
+		/* Fallback to a new allocation */
+		spin_unlock_irqrestore(&pa->lock, flags);
+		/* With @zero, fresh dirty blocks are zeroed below. */
+		meta = pisa_alloc_split_page(pa->order, gfp, pa->nid);
+		if (IS_ERR(meta))
+			goto out;
+		spin_lock_irqsave(&pa->lock, flags);
+		meta->pa = pa;
+		/* Set PISA_ACTIVE after @meta is fully set up. */
+		pisa_meta_set_flags(meta, PISA_ACTIVE);
+	}
+	spin_unlock_irqrestore(&pa->lock, flags);
+
+out:
+	for (unsigned long i = 0; zero && i < n; i++) {
+		/* Dirty blocks for a zeroing caller were marked with page_private = 1. */
+		if (!page_private(pages[i]))
+			continue;
+		set_page_private(pages[i], 0);
+		memset(page_address(pages[i]), 0, PAGE_SIZE << pa->order);
+		if (frozen) /* Order zeroing before caller publishes the page. */
+			smp_wmb();
+		else
+			page_ref_unfreeze(pages[i], 1);
+	}
+	return n;
+}
+
+/**
+ * pisa_alloc_bulk - Allocate up to @nr_pages blocks from @pa
+ * @pa: Allocator to allocate from
+ * @gfp: GFP flags (requests with __GFP_THISNODE, __GFP_DMA, __GFP_DMA32, or
+ *	__GFP_ACCOUNT are declined)
+ * @nr_pages: Number of entries in @page_array (populated entries are skipped)
+ * @page_array: Output array of page pointers
+ * @frozen: Leave allocated pages frozen at refcount 0 if true
+ *
+ * Return: Number of populated entries at the start of @page_array.
+ */
+unsigned long pisa_alloc_bulk(struct pisa_alloc *pa, gfp_t gfp,
+			      unsigned long nr_pages, struct page **page_array, bool frozen)
+{
+	unsigned long i = 0, n, got;
+
+	/* Skip any already populated prefix, as alloc_pages_bulk_node() does. */
+	while (i < nr_pages && page_array[i])
+		i++;
+	if (unlikely(!pa || i == nr_pages ||
+		     (gfp & (__GFP_DMA | __GFP_DMA32 | __GFP_THISNODE | __GFP_ACCOUNT))))
+		return i;
+	gfp = current_gfp_context(gfp);
+
+	while (i < nr_pages) {
+		if (page_array[i]) {
+			i++;
+			continue;
+		}
+		/* Fill the run of @n NULL entries at @i. */
+		for (n = 1; i + n < nr_pages && !page_array[i + n]; n++)
+			;
+		got = __pisa_alloc_bulk(pa, gfp, n, page_array + i,
+					want_init_on_alloc(gfp), frozen);
+		i += got;
+		if (got < n)
+			break;
+	}
+	return i;
+}
+
 /**
  * __pisa_free_page - Recycle a freed block back into its PISA allocator
  * @page: Block being freed (called from __free_pages_prepare() under RCU)
@@ -328,8 +659,19 @@ bool __pisa_free_page(struct page *page, unsigned int order)
 
 static int __init pisa_init(void)
 {
+	int nid;
+
 	pisa_node_init();
 
+	/* Preallocate the supported per-node allocators. */
+	for_each_node_state(nid, N_MEMORY) {
+		pisa_alloc_ensure(&pisa_nodes[nid].pa[0][0], nid, 0,
+				  DMA_BIDIRECTIONAL, "pisa_o0_n%d", nid);
+		pisa_alloc_ensure(&pisa_nodes[nid].pa[1][SKB_FRAG_PAGE_ORDER],
+				  nid, SKB_FRAG_PAGE_ORDER, DMA_TO_DEVICE,
+				  "pisa_ro_o%u_n%d", SKB_FRAG_PAGE_ORDER, nid);
+	}
+
 	/* Dedicated WQ_MEM_RECLAIM workqueue so reclaim never blocks behind system_wq. */
 	pisa_wq = alloc_workqueue("pisa", WQ_MEM_RECLAIM, 0);
 	if (!pisa_wq)
diff --git a/mm/pisa-kunit.c b/mm/pisa-kunit.c
index bdf5184bbd52a..ea605cb6afe5b 100644
--- a/mm/pisa-kunit.c
+++ b/mm/pisa-kunit.c
@@ -7,6 +7,8 @@
 #include <linux/gfp.h>
 #include <linux/pisa.h>
 #include <linux/mm.h>
+#include <linux/skbuff.h>
+#include <net/sock.h>
 
 #include "pisa-priv.h"
 
@@ -33,6 +35,7 @@ static void test_meta_init_and_roundtrip(struct kunit *test)
 		return;
 	}
 	m_pfn = pisa_meta_of_pfn(pfn);
+	KUNIT_EXPECT_PTR_EQ(test, pisa_meta_of_pfn(base_pfn), m_pfn);
 	KUNIT_EXPECT_EQ(test, pisa_meta_to_pfn(m_pfn), base_pfn);
 	pisa_slot_free(m_pfn);
 	__free_pages(page, PISA_ORDER);
@@ -98,10 +101,76 @@ static void test_meta_active_toggle(struct kunit *test)
 
 static void test_alloc_and_recycle(struct kunit *test)
 {
+	const struct {
+		unsigned int order;
+		bool ro;
+	} cases[] = {
+		{ 0, false },
+		{ SKB_FRAG_PAGE_ORDER, true },
+	};
+	struct page *p1, *p2, *bulk[3];
+	struct pisa_alloc *pa;
+
 	KUNIT_EXPECT_NULL(test, pisa_alloc_create(first_memory_node, 0, DMA_NONE));
 	KUNIT_EXPECT_NULL(test, pisa_alloc_create(first_memory_node, PISA_ORDER + 1,
 						  DMA_BIDIRECTIONAL));
+	KUNIT_EXPECT_NULL(test, pisa_node_pa(first_memory_node, 1, false));
+	KUNIT_EXPECT_NULL(test, pisa_node_pa(first_memory_node, 4, true));
+	KUNIT_EXPECT_NULL(test, pisa_node_pa(first_memory_node, PISA_ORDER + 1, false));
 	pisa_alloc_set_name(NULL, "ignored");
+
+	for (unsigned int i = 0; i < ARRAY_SIZE(cases); i++) {
+		unsigned int order = cases[i].order;
+
+		pa = pisa_node_pa(first_memory_node, order, cases[i].ro);
+		KUNIT_ASSERT_NOT_NULL(test, pa);
+		KUNIT_EXPECT_NULL(test, pisa_alloc(pa, GFP_KERNEL | __GFP_ACCOUNT));
+		KUNIT_EXPECT_NULL(test, pisa_alloc(pa, GFP_KERNEL | __GFP_DMA32));
+		KUNIT_EXPECT_NULL(test, pisa_alloc(pa, GFP_KERNEL | __GFP_THISNODE));
+
+		p1 = pisa_alloc(pa, GFP_KERNEL | __GFP_ZERO);
+		KUNIT_ASSERT_NOT_NULL(test, p1);
+		KUNIT_EXPECT_TRUE(test, is_pisa_page(p1));
+
+		/* Freeing p1 returns it to the allocator; next allocation reuses index 0. */
+		__free_pages(p1, order);
+		p2 = pisa_alloc(pa, GFP_KERNEL);
+		KUNIT_ASSERT_NOT_NULL(test, p2);
+		if (!want_init_on_alloc(GFP_KERNEL) || want_init_on_free() || order == PISA_ORDER)
+			KUNIT_EXPECT_PTR_EQ(test, p1, p2);
+
+		if (order == 0) {
+			/* Bulk alloc skips already populated entries. */
+			bulk[0] = NULL;
+			bulk[1] = p2;
+			bulk[2] = NULL;
+			KUNIT_EXPECT_EQ(test,
+					pisa_alloc_bulk(pa, GFP_KERNEL, 3, bulk, false),
+					3UL);
+			KUNIT_EXPECT_PTR_EQ(test, bulk[1], p2);
+			KUNIT_EXPECT_NOT_NULL(test, bulk[0]);
+			KUNIT_EXPECT_NOT_NULL(test, bulk[2]);
+			/* Declined GFP reports populated prefix length. */
+			KUNIT_EXPECT_EQ(test,
+					pisa_alloc_bulk(pa,
+							GFP_KERNEL | __GFP_ACCOUNT,
+							3, bulk, false),
+					3UL);
+			if (bulk[0])
+				__free_pages(bulk[0], 0);
+			if (bulk[2])
+				__free_pages(bulk[2], 0);
+		}
+
+		if (p2)
+			__free_pages(p2, order);
+	}
+
+	/* Plain alloc_page() without __GFP_PISA_* comes from the buddy allocator. */
+	p1 = alloc_page(GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, p1);
+	KUNIT_EXPECT_FALSE(test, is_pisa_page(p1));
+	__free_pages(p1, 0);
 }
 
 /* Wait for the reclaim worker and its RCU callback to retire @meta. */
diff --git a/mm/pisa-priv.h b/mm/pisa-priv.h
index bca35f463c3b7..46170da8a0f0d 100644
--- a/mm/pisa-priv.h
+++ b/mm/pisa-priv.h
@@ -155,10 +155,25 @@ static inline void pisa_alloc_backoff(struct pisa_node *node, bool can_block)
 struct pisa_alloc *pisa_alloc_create(int nid, unsigned int order, enum dma_data_direction dir);
 __printf(2, 3)
 void pisa_alloc_set_name(struct pisa_alloc *pa, const char *fmt, ...);
+__printf(5, 6)
+struct pisa_alloc *pisa_alloc_ensure(struct pisa_alloc **pap, int nid,
+				     unsigned int order, enum dma_data_direction dir,
+				     const char *fmt, ...);
 bool pisa_place_meta(struct pisa_meta *meta);
 extern struct llist_head pisa_free_list;
 extern unsigned int pisa_idle_ms;
 void pisa_release_page(struct pisa_meta *meta);
+unsigned long pisa_alloc_bulk(struct pisa_alloc *pa, gfp_t gfp,
+			      unsigned long nr_pages, struct page **page_array, bool frozen);
+
+static inline struct page *pisa_alloc(struct pisa_alloc *pa, gfp_t gfp)
+{
+	struct page *page = NULL;
+
+	if (pa)
+		pisa_alloc_bulk(pa, gfp, 1, &page, false);
+	return page;
+}
 
 /* pisa-node.c: per-NUMA-node PISA page reservoir and work item */
 extern unsigned int pisa_reservoir_max;
-- 
2.56.1.809.ga0b61035b5-goog


