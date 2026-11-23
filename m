Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69B37606A6B6
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 03:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=joufhle2
Received: by kanga.kvack.org (Postfix)
	id 8CD8C6B05B6; Sun, 22 Nov 2026 22:31:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87E536B05B7; Sun, 22 Nov 2026 22:31:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 720C56B05B8; Sun, 22 Nov 2026 22:31:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4DF936B05B6
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 22:31:27 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CC296A8458
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:31:25 +0000 (UTC)
X-FDA: 85464958530.07.2EE74BB
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf14.hostedemail.com (Postfix) with ESMTP id 06A0E10000A
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:31:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=joufhle2;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf14.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.216.43 as permitted sender) smtp.mailfrom=jeffxu@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795404684;
	b=BSQ6oRPtfwEOgwiPf1adyI1ut2G4cMoq36zEZFuyb13XmOA7EooUZ3e4wQ1cHod8+dE6kr
	c1wTjeGGqL8YGXKoMpaWyHPHpDZy8Kmx3a7X1isQgmv5e8P4EfLYkcDwSjhtWvHFnxn1iK
	9BrWwMGLfHCSMCB7N02RkEsMp2wdX3o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795404684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u+VJkDmgbhhT238e3Khqv+7tnUuWga3+yY83FP/NeKA=;
	b=xwI+It+U4lBVv79OYuDxwh2demdaJ6Woov5ky8e6pe7cc6QXhDizsyKE/Xioyelrfaajem
	t6Vzkpnr5UJ6PyHJyO990QgSAgTcG3AjJcnKGuhV/TdS+L+xeDnzzEa9ARMRado1DWuJ03
	KVeAQeSfdGF2/aTB5qlgGVPsgTRcHKs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=joufhle2;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf14.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.216.43 as permitted sender) smtp.mailfrom=jeffxu@chromium.org
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3b3f9cbafecso373955a91.3
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:31:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1795404683; x=1796009483; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=u+VJkDmgbhhT238e3Khqv+7tnUuWga3+yY83FP/NeKA=;
        b=joufhle2Kxhd1LIgUexT4Qid1FdVz6i4Yg696D3BApDmW1Dtat+LVUqs2/YXsHvt1g
         EjwFMMNTga2vkc3hxuXhiUCFpI7i8HbSCLo4hVpfyONarwZ2D4IHPZ1maIyG8y7zAqQr
         qLvBooahXUjGcwLFjmTdty8lFCLGEUEvB/P2Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795404683; x=1796009483;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=u+VJkDmgbhhT238e3Khqv+7tnUuWga3+yY83FP/NeKA=;
        b=DNz4DEQkX1LX9uZggynNXpRJS9ynG0GCvNEgs/lTdy0Wkn7VdlsbbqeZNiKCljJIsH
         rmk4UCP0KnEU5bkQ7B07tHPdmTrPKEculoEhNdV2n5U4igRNHalAnlHNZFEaRil/jcwa
         VdhDB+dDG4sgcO+FFeV+kIyNSPXBnRNh5GDcajq4yw2DuW30sP+iBNscCDc34EGGqdfT
         c7kqY0osTgXMHsDcDfSoz75KQ1afpbXPgOeMTgZTPDRU5fVz+YxkI16o8Q4ME2gPoiPy
         7wKRApRf0Y6HjuKXRZsV+qak3qfILon91fp931jYHfwqadKm5Jhmj+m/ZO8/lKLpja9e
         czfA==
X-Forwarded-Encrypted: i=1; AL+hErFZb+t+mbUoEehqaG/9EPDkxCR39kT6KXzDVM+AaKTRY/HZm5QkRnZIV3Rj0ypl9iZr9hY6UURJGg==@kvack.org
X-Gm-Message-State: APuU4Z+nv8ZPNhIhRejmFEEfHIh+jGXeufgAsDcw27r/aAuBQrpz58Ir
	8zUyZHu9Rfv9Xi5pib5jRLf7zvJ+e54VBIm1KU92BO5YAloUNxmHUfG6ctzLPRg/Lw==
X-Gm-Gg: AZFdTZdVXOAoMymuo7XK0IaPLZDfG6PeYDrXxZHBrwJiAO9Lf09IkAcgYmVY5hH2Zyv
	bmVlu59r19eOzGdZt/CemVFq7A7lnKrKkXcVTuADrYAa0hnzwImdyv7vPMlYE8C08QHVgxVJpag
	oXhswMcwfHsFENuAFik4n5xcYiPTqYyYV8/MEfvg0C3zkVtj62w+txu702R3JQtpsvKcZXVrCK4
	3QSHf2NG4pJN6opionOBkQ/DWHgmHsVt6ED+Hu66RryLibZddXnQqIdIVcFXj2ER9hPyTf0YUti
	/EqEXBZIJ/v5QkdqmaCxGprD2aC1SoWwzi7fVgKYDZSj7fFTRQFSA5NQ6wL74OtHkp8jPcKxT1o
	qpmiMpZuNdvcUiReDFp/dlypNNV9Xn4U8weB4JNX4dHqLwheWrHEtMrEgbBP10yEo5oTVz047Nh
	KTZgi7155PDAWLW+bNWQJjbIK0N+hFImqmvyUEj0XGL0ELtbt16E4jD4Xt0X+W82FMkRUAlez1f
	FxBOVWpBdrEeFyzdMgSiG/dT76j5eckK9lkisGquzwVa+hC7BqIAaixZshDXoDiG1OAIdrMRq9Z
	kUqwxdppq7gQUdCJrsTFln+wV+CWwdoCb3jcH5xjdRWjSfu4CNw+18AoZK34aHB51KPzQA==
X-Received: by 2002:a17:90a:e70c:b0:3a0:c1b1:45fb with SMTP id 98e67ed59e1d1-3b41c58aebdmr15663729a91.0.1795404682704;
        Sun, 22 Nov 2026 19:31:22 -0800 (PST)
Received: from localhost (221.247.125.34.bc.googleusercontent.com. [34.125.247.221])
        by smtp.gmail.com with UTF8SMTPSA id 98e67ed59e1d1-3b41ad48786sm15745736a91.9.2026.11.22.19.31.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Nov 2026 19:31:22 -0800 (PST)
From: Jeff Xu <jeffxu@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Jeff Xu <jeffxu@chromium.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Marco Elver <elver@google.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chia-I Wu <olvaffe@gmail.com>,
	Dev Jain <dev.jain@arm.com>,
	Ian Rickards <ian.rickards@arm.com>,
	Jann Horn <jannh@google.com>,
	Jeff Vander Stoep <jeffv@google.com>,
	Jeff Xu <jeffxu@google.com>,
	Kees Cook <kees@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Peter Collingbourne <peter@pcc.me.uk>,
	=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?= <ptosi@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Tomasz Figa <tfiga@chromium.org>,
	Will Deacon <will@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Baoquan He <baoquan.he@linux.dev>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Allison Henderson <achender@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-mm@kvack.org,
	kasan-dev@googlegroups.com,
	linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	kexec@lists.infradead.org,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	rds-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] mm: kasan: skip KASAN for GFP_HIGHUSER
Date: Sun, 22 Nov 2026 19:31:10 -0800
Message-ID: <20261123033111.2349160-2-jeffxu@chromium.org>
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
In-Reply-To: <20261123033111.2349160-1-jeffxu@chromium.org>
References: <20261123033111.2349160-1-jeffxu@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 06A0E10000A
X-Rspam-User:
X-Stat-Signature: eqegkwrafrwhugij1dangomz61c74w67
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795404683-259044
X-HE-Meta: U2FsdGVkX1/n7XIRDYWGtzeYhT927WI0DkQ/IgbTmkyYg/XGrz08EePGRW6Xvrx2WLtbIigh8OpN0/iErvvGcOmBUMzPUwwsgEnqkzyezg0PdmpGr1kt+1ploKwWpJSQ1Oatkf7N4km5snpPACOovmC949x1MwqwNeFGyTTSB4zXovHZUIFr1OD/ZCuyDsQj17Nf6CDZGvvN0LF0jUdtCnhyGNur9E/RJ//Y1ICT2P/3SprAav6QbCnAr24A6v1E6gvgALiHjOJeY34DxMGzoj25vpyAmo+uHfP1FoSiJImELWdYhmg1UtbVr/XQBydApzBoJxb1P4kpRewSrjLMyn6QzcdF45IkDutsuh/92bQxoTrXX3mmmY4EkyzOyL7M9z3KvY80mMdI0GZF+YQLrJ4CIRrhVWiZ/sKCzE+EMnpn4HTAX15/OIC9LsSWEDjkatI1Y7NnK+7G0Mo7Wdgc/5FV7NEwaQkTsiwscWc40JzFZ7YC8yuDN/EahhagbCFNnzJUgbKWdSutUxWBrXFXDdFGMv2VrfwVKQWdur1v4H9SjEhlj6q/iOcg2+ho2NN3w2tUl3O+7BTNohryk9qxWJSlq6du16eYcXmsu9tITT0Vqa2hhZ7maYB3K+zV0X9VEjgyHk6dQM8PvQ8Jr6wr5jtgv97IfmPV1u1y1S7E1LuFDuurFoHEeRlJtRacCnitR2i+DrcTSBO1RfRaSjYR3+cF9BBMRAWs6WHLq8pf9TVAsN60WE0r0m1z7hJDProidEiEkki43Nzdi3HH0HWlHPUaqhPDLTNtulye2vnlpBPaERf/qf5P1Hrujsn083uZPASuD6wY/ceaQ9bfZxAzmV3M8YyFKb+i7CMDGuDYNjq0oHeVfAhVQ2+eI11mTb6y2YX7lZAovkbTmUlggc+K9l4Ob95Bs4Vpu5bPCYbXuSO8XoUU8jges4qllLVUupEIfQpVfPBwwAkGCywJ/KG
 VvcYcEP7
 pYFFnXVoWR0xG9zziqLa8TR+Ymd/LFSNwkd/IEQtEzPHUeL2Kqh7r9lq2ldm1nQlUkg+8Q32Oq/AaloU6pVV60+TfDfff3ZhX/RVsrwbxulThluhflLQ7Krd/ZK9A/j4eECCxSrRADRBq9FlxROcm2qEeO5Lwx4QDf8Wlvbxq/5OydsrEsKZNMraoCHRx6OHjJjF0exOwa5y2p+5gq2tW3bfnzGkhBDyEpcO6em33yT/XFYbjqHHI2tYfJNZ/SnA/u0cgj/Mi/EiATjnKm77HWMOUNQmwhaR1z6ft5v7rV0linnCRxYLcQq/PjFak8UY20W3YJrKZbAxnZNdzxnhBtld53KYBiGmFSmaLA4I/pV4sB7Rbe8lYU36yi1RVO172z98I+FndBWkshA2UZadMcx8WVL7PLpL5CiaUNZZJx+iNrwmoBdW+Sy+muakEVH3J2/7bk5tpQlskxm6cCzFryP3S4bwHanEVE2aNoz6tiLwHflH+m86zqeXoBKqUH8Xv70QjiDFzPQu76TRW2+Zz45SVSh+7AA3+6JcY+XbO1en/1sW7+KM15Nxw5Kl+EeebytjbUKuMS8TwtC9HJoQ4lzxTs7JHM9ydQ+SsfY+CrHJNVKf61Ba7Hm7M0p4jxrzUJPEEQynBleaQEyA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Move __GFP_SKIP_KASAN from GFP_HIGHUSER_MOVABLE to GFP_HIGHUSER so
non-movable userspace page allocations also skip KASAN tagging on
allocation and poisoning on free under CONFIG_KASAN_HW_TAGS.

GFP_HIGHUSER_MOVABLE already skips KASAN because user pages do not hold
kernel data structures and tagging every 16-byte MTE granule on
allocation and free is expensive. GFP_HIGHUSER has the same contract and
differs only in being non-movable, used mainly by DMA-BUF, DRM/GPU
buffers, and non-movable HugeTLB.

On an Armv9.2-A device (6.12 kernel, kasan.mode=sync), this reduces
32 MB /dev/dma_heap/system alloc+free latency by ~80% (~59% alloc, ~98%
close) and improves an app-loading OpenGL benchmark by 15-23%.

Callers that access GFP_HIGHUSER pages through kmap_local_page() or
page_address() (such as ramfs, pipe/FUSE buffers, kexec, and RDS) lose
HW_TAGS checking on those pages. None of them store kernel structs
there; this matches the trade-off already made for GFP_HIGHUSER_MOVABLE.
Generic and SW_TAGS KASAN are unaffected.

Signed-off-by: Jeff Xu <jeffxu@chromium.org>
---
 include/linux/gfp_types.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
index c1331bf0b239..bb54c7abfb02 100644
--- a/include/linux/gfp_types.h
+++ b/include/linux/gfp_types.h
@@ -376,8 +376,8 @@ enum {
 #define GFP_USER	(__GFP_RECLAIM | __GFP_IO | __GFP_FS | __GFP_HARDWALL)
 #define GFP_DMA		__GFP_DMA
 #define GFP_DMA32	__GFP_DMA32
-#define GFP_HIGHUSER	(GFP_USER | __GFP_HIGHMEM)
-#define GFP_HIGHUSER_MOVABLE	(GFP_HIGHUSER | __GFP_MOVABLE | __GFP_SKIP_KASAN)
+#define GFP_HIGHUSER	(GFP_USER | __GFP_HIGHMEM | __GFP_SKIP_KASAN)
+#define GFP_HIGHUSER_MOVABLE	(GFP_HIGHUSER | __GFP_MOVABLE)
 #define GFP_TRANSHUGE_LIGHT	((GFP_HIGHUSER_MOVABLE | __GFP_COMP | \
 			 __GFP_NOMEMALLOC | __GFP_NOWARN) & ~__GFP_RECLAIM)
 #define GFP_TRANSHUGE	(GFP_TRANSHUGE_LIGHT | __GFP_DIRECT_RECLAIM)

base-commit: d12eccbcb79a4fa35c3aa588eb79056af62eb859
-- 
2.56.1.750.gf70dc682cf-goog


