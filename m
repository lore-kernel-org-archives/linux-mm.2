Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A772EC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 12:25:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C27566B00DD; Mon, 29 Jun 2026 08:25:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFF346B00DF; Mon, 29 Jun 2026 08:25:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B165A6B00E0; Mon, 29 Jun 2026 08:25:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 508166B00DD
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:25:31 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B7062C32E1
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:25:26 +0000 (UTC)
X-FDA: 84932870652.16.1A4A7D8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 30AB940002
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:25:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c2fdxPuJ;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782735925;
	b=mHFSoOl9AisF6Ha39dFWPLafrqqGMwOcMXx03Fluegrq1QrmUc0GFrWwr6NjmAEcBEgxW2
	+GxrpnuPOsvqrPgQV65rvcQOGPk8SXil3bieWbQj2XwMnCe7n3f2XPcjBKt7dCky9Pa+1X
	TZuQTxf/A1/7LUoIzr4COf+13kWy+IU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782735925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U1jtLkA6UuZsfpQiwXDViZ4TbQirP1iCEgORsJjMVIE=;
	b=eyYTphaG1bVvecexsA+J+QOoAy62jXRx18NfMLlKJ9BaWtIKQhnIv3rO+Xd0UNUGfLmZdq
	ekJACyQ+Iq+axRAb3CAT0/cDb6zRSRp59skJVwMd0W4Wj9rqohRDLs+ortvQMQeEwXGR8q
	+fpuKE4KoqgVYjce0iG2yrmUedfFGuk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c2fdxPuJ;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BF9AC601BE;
	Mon, 29 Jun 2026 12:25:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F691F00AC4;
	Mon, 29 Jun 2026 12:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782735924;
	bh=U1jtLkA6UuZsfpQiwXDViZ4TbQirP1iCEgORsJjMVIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c2fdxPuJZracea4THiWagUGG3qtjKlYQLO8kI5qBAOAmNyUqU+Cz2tE0LZcZK/+x6
	 6Xk6iEoGktAUHyeB9cblz74jdddGkwaBjm0aSRvDSQySW3n0Fr3QzWtICG5O83ECq+
	 CpGzQfZJaEmCid2LM+2XsU2ThNJ23kEbysH1NlUtWxqEIESKzs4x6d5f0OSVrFyJfm
	 j3TScuQr22512dqslB4Ah+zgS28CuS/F239kYvXoA+o5vDrfUPnKKgS1tQAkh4mNti
	 ITFv6t9aZ5OoDpmTegOvjzsXL8lUZRPNTyuRby3AAe3GvKu9tkUXabe/jqKUOVL1Ww
	 sDInYPPHhFcHQ==
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <linux@armlinux.org.uk>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Dmitry Baryshkov <lumag@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Dan Williams <djbw@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Matthew Wilcox <willy@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	SeongJae Park <sj@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Hugh Dickins <hughd@google.com>,
	Mike Rapoport <rppt@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-parisc@vger.kernel.org,
	linux-sgx@vger.kernel.org,
	etnaviv@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org,
	linux-tegra@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-mm@kvack.org,
	iommu@lists.linux.dev,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	damon@lists.linux.dev,
	Pedro Falcato <pfalcato@suse.de>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH 30/30] tools/testing/vma: output compared expression on ASSERT_[EQ, NE]()
Date: Mon, 29 Jun 2026 13:23:41 +0100
Message-ID: <432444fa4c12ae1c4047550e2b205d3e9bab458f.1782735110.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782735110.git.ljs@kernel.org>
References: <cover.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9ytbx3h7ky3najmizx7icj7cb1754hbi
X-Rspamd-Queue-Id: 30AB940002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782735925-208670
X-HE-Meta: U2FsdGVkX1+zXQQo8HPssc8ThDP7W9XCe9Iqb+4oSIFL+PCLlH++lZvMF5LPdUpJref+kvnSmW/9MVnxfvrjZ2+UkThvyGo56AhXuIFIqJLUBSed2vNkSQ5pgLQ/bg3Vi4fCSpTnzIMlLVJYEdkHU8elqWlgGJbhEEF/9mA3NXyaNU5lRPXtdL8Lb85ttFkHkKiaIJzletCiCeAiYUjj7ei9SP/DZaZj/41hWDIaxE2LKs0vyLaWh4ClWlGCFo7d2T6+KMeK7KKzNTnKR4eB2XCXfs+/lmTZ8VbxJ2Ps7cn7UNwLWyDfycCMpmArJV8Z3THK5Lj6tucCJeUJ6s/AIFc7jkFnUSDU0yJdKUSAFSoYHs8hKuyWzId+OkilYQ6ONA/3qtDzuzJe4QAs/p7FMj/0kT7cXZ4Kj15SR3M12fJFvfcmTNmAlsXb3NP2LYkaGl6JWiDQZLGmmxoZ4I0xmLpoc5ojmewwPXcN3p6YzGLfTBhufAdJD4wjsI+G8J4ag/fuRn9Q9Ll3iuVNK7uFKRxjIZXgHEfPiu8dObxOAstd8IlGkYLsFPW77ESDPMfnbIrgokM0i/PBjPZUzZTyFbzc5Knw5gO6gcM0iYKYbxHHppQHBwKimwjUta/XdbrxcHtv9oPVgbZy1eKB81XGacwVez3Ena1ij+bXRCnGiUfV1m1hNAJx60Tdr9wrzF9buZRl4+Sl0JF7O8swy/ZdWpbLsWhIL9d+HO05P1IShbymyv4mVOd0a1X7i7ZVNEi1f8ub3rU43BeqOv27rtT2JvZmo6YBQviH3pejMHgaP04o5frKEYEjRVwBErTbCLL1lb4Kr2W1yct4Ry0V3z0Z1I27yzuHyenyUnsDxDXnHAvDmzdnjaks7fOrMWP9O9hnqcZ+G07KMOHCB8Gq4tmUuAMiRPVKbSs1cIkgdA97IUR3GOKCl601BR/eZ9PG/fgMJj3wYtsKvBYD/g4rHlB
 sYf2Cm49
 BXMU+2gokMOFofYpgxmNeoS7e3kx26ylRfdD+tgzBrdcixPstiRLsDzIJcfpEEiaW4lcP8LN36BRlDHPqZS+VsCBcKsxvPJP8oFqmWxfV/5og1YDKD7F3jqHFnrwTEgNnaV28grbklZvOd8IRd0OmZRQkyhDxVrO1QwppAipx5LEkYadMQJh0JlSoKR/1c7DQIuSaJr6lryOVDSYXKipG5dZSCGXP0zWoJfRNzYlqaCDfeO1Zo5DWm0OBNEGwC4wk7j7K8KHJyhrMPHyx5Fey5vZ+zBz2RiE+VS6PLQZEkpHH2PmmlRaDuGHREWnYx8ph4UoV8j8dRGJRlxtei/M+VEwkj9qeaIQ4TSZNgzwqCgV5EXg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the macros to output the compared values at hex for easier debugging
when test asserts fail.

Also remove unused IS_SET() macro.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 tools/testing/vma/shared.h | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/tools/testing/vma/shared.h b/tools/testing/vma/shared.h
index ca4f1238f1c7..216be4cda369 100644
--- a/tools/testing/vma/shared.h
+++ b/tools/testing/vma/shared.h
@@ -21,19 +21,28 @@
 		}							\
 	} while (0)

-#define ASSERT_TRUE(_expr)						\
-	do {								\
-		if (!(_expr)) {						\
-			fprintf(stderr,					\
-				"Assert FAILED at %s:%d:%s(): %s is FALSE.\n", \
-				__FILE__, __LINE__, __FUNCTION__, #_expr); \
-			return false;					\
-		}							\
+#define __ASSERT_TRUE(_expr, _fmt, ...)					   \
+	do {								   \
+		if (!(_expr)) {						   \
+			fprintf(stderr,					   \
+				"Assert FAILED at %s:%d:%s(): %s is FALSE" \
+				_fmt ".\n",				   \
+				__FILE__, __LINE__, __FUNCTION__, #_expr   \
+				__VA_OPT__(,) __VA_ARGS__);		   \
+			return false;					   \
+		}							   \
 	} while (0)

+#define __TO_SCALAR(x)	((unsigned long long)(uintptr_t)(x))
+
+#define ASSERT_TRUE(_expr) __ASSERT_TRUE(_expr, "")
 #define ASSERT_FALSE(_expr) ASSERT_TRUE(!(_expr))
-#define ASSERT_EQ(_val1, _val2) ASSERT_TRUE((_val1) == (_val2))
-#define ASSERT_NE(_val1, _val2) ASSERT_TRUE((_val1) != (_val2))
+#define ASSERT_EQ(_val1, _val2)						\
+	__ASSERT_TRUE((_val1) == (_val2), " (0x%llx != 0x%llx)",	\
+		      __TO_SCALAR(_val1), __TO_SCALAR(_val2))
+#define ASSERT_NE(_val1, _val2) \
+	__ASSERT_TRUE((_val1) != (_val2), " (0x%llx == 0x%llx)", \
+		       __TO_SCALAR(_val1), __TO_SCALAR(_val2))

 #define ASSERT_FLAGS_SAME_MASK(_flags, _flags_other) \
 	ASSERT_TRUE(vma_flags_same_mask((_flags), (_flags_other)))
@@ -53,8 +62,6 @@
 #define ASSERT_FLAGS_NONEMPTY(_flags) \
 	ASSERT_FALSE(vma_flags_empty(_flags))

-#define IS_SET(_val, _flags) ((_val & _flags) == _flags)
-
 extern bool fail_prealloc;

 /* Override vma_iter_prealloc() so we can choose to fail it. */
--
2.54.0

