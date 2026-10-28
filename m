Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5621A606A33A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 15:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=E/BHRL6D
Received: by kanga.kvack.org (Postfix)
	id B97A86B05BC; Wed, 28 Oct 2026 11:42:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B202F6B05BE; Wed, 28 Oct 2026 11:42:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9721E6B05BF; Wed, 28 Oct 2026 11:42:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 60AFC6B05BC
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:42:50 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EB3D61A0153
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:42:49 +0000 (UTC)
X-FDA: 85372452858.27.A7A0D98
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf26.hostedemail.com (Postfix) with ESMTP id BD069140009
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:42:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="E/BHRL6D";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf26.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793202168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aLcHh9wVCNj0wy7JzbpEj3+SL2vMXcdXR22pTGdylzU=;
	b=oYYkryuYZZ+KOY3N/llZ/FIMFZURU3puNoOpkNdMixz/VNtws5RcbwYC9XFA9GHVvC3TMF
	AvH3ek9Pcv/7CkCixnH8SXqSdI+MovaAxsGZiELfnDXcBtUdFPbxxg3fpoUd8492dlv9ER
	jm1Q5NyLltplXuTSH/aQXWPnKXmYVBg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="E/BHRL6D";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf26.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793202168;
	b=PuQ2RvDzzzTIBR4Wf0MCr5Iw0XXc0JaX6UGnyFSetthZ5SjUq2KA97dBGCmtBPnPOXI2XI
	2YaRN0r3ZSq8Sq97TRR7+o8MOHfiGku7KeNCbcS7dnFGjk+J+Bi8rWwFAz04kBIWsfEp4h
	khupH0X4ABj/qQX9c0qWoO6bgREjfCA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=aLcHh9wVCNj0wy7JzbpEj3+SL2vMXcdXR22pTGdylzU=; b=E/BHRL6Du+Fdr3+amsCWlylmKW
	+LQLxA7qkn4homkLKhl2qvDpFOgYBU1NZrVb6YWxzpe3IsRfZGMLDmLg9wRqqtOIfuN8yG0ccapFO
	Kxpvxtm6WXotTb46LS2rzAP9ya+rhkKEad1O8UWfRJ3aCmQ/0pWShBjH3VWzNmVGLPEV/7jCLLGLx
	IM6PQCtzKzhw2eErmBZwP4E3M+yhlSkZ/v6Pbnlf1mFBuxvefTl/8m1PQ31cXq2Y8hmBrOilEKwra
	9jnQ31VU+3ScBnnxNTxILEesGeROmYACWLMCIdsj87pzzZXl/sF78i6hy6X+ooibEmECOuOECERXK
	JBMtSBCw==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xM5na-00000007Qpt-2enj;
	Wed, 28 Oct 2026 15:42:46 +0000
From: "Liam R. Howlett (Google)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Thomas Graf <tgraf@suug.ch>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Chris Mason <mason@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	"Liam R. Howlett (Google)" <liam@infradead.org>,
	stable@vger.kernel.org
Subject: [PATCH 3/4] maple_tree: Update internal warning and bug_on code
Date: Wed, 28 Oct 2026 11:42:17 -0400
Message-ID: <20261028154218.1668182-4-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261028154218.1668182-1-liam@infradead.org>
References: <20261028154218.1668182-1-liam@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BD069140009
X-Stat-Signature: aji9jubpcyocj8847cczn5z7qkwffirp
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793202167-218589
X-HE-Meta: U2FsdGVkX19U2vBYGWueFiekPaw98IEUlzhDlGaneNuqguUNjR64R22gXPuXGR971YLuyva5X7wVuS+Zzk7x83oHtkyg4y4YKO19KFSGA6UJIulzXMytNztE3/pEJ2nuEXOvVdLkNoLL1gdeflahZ+QGQ0UKc1JLlD8XU66Bm1rICm/t8GGVhgKv1k9CM2yCBlzn4k8I2KE/Pgp64Xw66FDBiVlGo569X1nTq3Z9ulI1IJptn5NclJe5pqnEgyr4WOaOgoSgCur9DomxlDeJZNwqwf3JFY0ivuMW0v8wyHU5N2hjn1x4rLCvgdFnAS/8b2YAAE9BhAtb/9kKbg2GtrCEyEHlbmn6MuZ9hIHRs3qHLfL3Nuqg1qdUNxUIivzUfUNA0KCq0yGEcx6FIiY+dPaXwA4Vs9TXRAAFrtyqwE5zw+KpS7asiDsH/eMT9H23gvqsC3sUyhOLSK2mNki24OH0f1SL7IERLKtp8na7yOZ7SYJOE7vukwmUdso8oqtg59GuukX+0sVJB4/HlVjg5txUnSZIIvOAffH5546ahLPRmoOrvQVLGEBDks7nihnQhieTTmTUQ5e82rH+xjpxA+82vNv5yHQzdqUzgfLUv+1r8RpyU88RDEoZrvmUsatOwcZ6vM/9nm062A9IoQ/wCCbs7kRSFwNK3FYMG1k0WtMkN9OWJkPD4JtMJJIKTjL1slx0YSLzoUQGCX8/jxDuPMjDa2Z7564Ys7M9PHPqR8W6YIjL5gV8jdL8liiX0VRGQGBDzmNOrgkszaQ81t4OtImNLpITnIc/ekKTDtTxju0R4meL7GRahbPSwKuM+Bv4X7Qu+PQfGkdFuO7qZk7b3sSg+A5SXnnxUumZHT4DHcQck0tgqbLG3293XnHiT8/tVmV+yL93yddHTR/fV7MuD3K2X986N8iAk8UJP+KrY4mk/K7119l7ZB8feh664t4KH3Iv/0EdLVb3L4lX9Pd
 JSqIzDvC
 fys34K/O/ZSDp2o31xeLnJF/ClEAUM03OxODM2oSGlehidOWxBXWTyYzJwF+9H/o+z20H12y1/ncl36rHOGv2YSlwhhLs1R1B/W5WZVNC3mLOUGIbi81GpHnOAgxpY605pNbw1dzb7r85hT+zvvrZaNsqXfk0yYyv2phW2pQTFEuQIg1RqcxEBRm/pKZF5ti/zPiFZbmU2tSPfw4lVFfOOZ2Ky3KvW0QP4C1gGGxYQgyX2uP1BjepGRVBUj4sTq0pq0Gt/1LWsDmCK1+ef2op37g+c8Tfk4gsAkrvPpV+53UYeN+LMsm88G1QJNoha5lKqoEwqfz26dIIRB8ZwEi0MZh4zzvt+gUXhbxshalrIAqP4I86grph8XY5tQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When CONFIG_DEBUG_MAPLE_TREE is set, call the WARN_ON_ONCE() after the
custom information is dumped about the tree.  Without using the kernel's
WARN_ON calls, syzbot will not catch issues detected by this code.

Update the non-debug code to call WARN_ON_ONCE() as well.

Cc: <stable@vger.kernel.org>
Reported-by: Lorenzo Stoakes <ljs@kernel.org>
Fixes: bf857ddd21d0b ("maple_tree: move debug check to __mas_set_range()")
Signed-off-by: Liam R. Howlett (Google) <liam@infradead.org>
---
 include/linux/maple_tree.h | 54 +++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 24 deletions(-)

diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
index e30e57f5f3df9..0f96f1f19eb95 100644
--- a/include/linux/maple_tree.h
+++ b/include/linux/maple_tree.h
@@ -680,7 +680,7 @@ void mt_cache_shrink(void);
 		pr_info("Pass: %u Run:%u\n",				\
 			atomic_read(&maple_tree_tests_passed),		\
 			atomic_read(&maple_tree_tests_run));		\
-		dump_stack();						\
+		BUG_ON(1);						\
 	} else {							\
 		atomic_inc(&maple_tree_tests_passed);			\
 	}								\
@@ -696,7 +696,7 @@ void mt_cache_shrink(void);
 		pr_info("Pass: %u Run:%u\n",				\
 			atomic_read(&maple_tree_tests_passed),		\
 			atomic_read(&maple_tree_tests_run));		\
-		dump_stack();						\
+		BUG_ON(1);						\
 	} else {							\
 		atomic_inc(&maple_tree_tests_passed);			\
 	}								\
@@ -713,62 +713,68 @@ void mt_cache_shrink(void);
 		pr_info("Pass: %u Run:%u\n",				\
 			atomic_read(&maple_tree_tests_passed),		\
 			atomic_read(&maple_tree_tests_run));		\
-		dump_stack();						\
+		BUG_ON(1);						\
 	} else {							\
 		atomic_inc(&maple_tree_tests_passed);			\
 	}								\
 } while (0)
 
 #define MT_WARN_ON(__tree, __x)  ({					\
+	static bool __warned;						\
 	int ret = !!(__x);						\
 	atomic_inc(&maple_tree_tests_run);				\
-	if (ret) {							\
-		pr_info("WARN at %s:%d (%u)\n",				\
-		__func__, __LINE__, __x);				\
+	if (!ret) {							\
+		atomic_inc(&maple_tree_tests_passed);			\
+	} else if (!__warned) {						\
+		__warned = true;					\
+		pr_info("WARN at %s:%d\n",				\
+		__func__, __LINE__);					\
 		mt_dump(__tree, mt_dump_hex);				\
 		pr_info("Pass: %u Run:%u\n",				\
 			atomic_read(&maple_tree_tests_passed),		\
 			atomic_read(&maple_tree_tests_run));		\
-		dump_stack();						\
-	} else {							\
-		atomic_inc(&maple_tree_tests_passed);			\
+		WARN_ON(1);						\
 	}								\
 	unlikely(ret);							\
 })
 
 #define MAS_WARN_ON(__mas, __x) ({					\
+	static bool __warned;						\
 	int ret = !!(__x);						\
 	atomic_inc(&maple_tree_tests_run);				\
-	if (ret) {							\
-		pr_info("WARN at %s:%d (%u)\n",				\
-		__func__, __LINE__, __x);				\
+	if (!ret) {							\
+		atomic_inc(&maple_tree_tests_passed);			\
+	} else if (!__warned) {						\
+		__warned = true;					\
+		pr_info("WARN at %s:%d\n",				\
+		__func__, __LINE__);					\
 		mas_dump(__mas);					\
 		mt_dump((__mas)->tree, mt_dump_hex);			\
 		pr_info("Pass: %u Run:%u\n",				\
 			atomic_read(&maple_tree_tests_passed),		\
 			atomic_read(&maple_tree_tests_run));		\
-		dump_stack();						\
-	} else {							\
-		atomic_inc(&maple_tree_tests_passed);			\
+		WARN_ON(1);						\
 	}								\
 	unlikely(ret);							\
 })
 
 #define MAS_WR_WARN_ON(__wrmas, __x) ({					\
+	static bool __warned;						\
 	int ret = !!(__x);						\
 	atomic_inc(&maple_tree_tests_run);				\
-	if (ret) {							\
-		pr_info("WARN at %s:%d (%u)\n",				\
-		__func__, __LINE__, __x);				\
+	if (!ret) {							\
+		atomic_inc(&maple_tree_tests_passed);			\
+	} else if (!__warned) {						\
+		__warned = true;					\
+		pr_info("WARN at %s:%d\n",				\
+		__func__, __LINE__);					\
 		mas_wr_dump(__wrmas);					\
 		mas_dump((__wrmas)->mas);				\
 		mt_dump((__wrmas)->mas->tree, mt_dump_hex);		\
 		pr_info("Pass: %u Run:%u\n",				\
 			atomic_read(&maple_tree_tests_passed),		\
 			atomic_read(&maple_tree_tests_run));		\
-		dump_stack();						\
-	} else {							\
-		atomic_inc(&maple_tree_tests_passed);			\
+		WARN_ON(1);						\
 	}								\
 	unlikely(ret);							\
 })
@@ -776,9 +782,9 @@ void mt_cache_shrink(void);
 #define MT_BUG_ON(__tree, __x)		BUG_ON(__x)
 #define MAS_BUG_ON(__mas, __x)		BUG_ON(__x)
 #define MAS_WR_BUG_ON(__mas, __x)	BUG_ON(__x)
-#define MT_WARN_ON(__tree, __x)		WARN_ON(__x)
-#define MAS_WARN_ON(__mas, __x)		WARN_ON(__x)
-#define MAS_WR_WARN_ON(__mas, __x)	WARN_ON(__x)
+#define MT_WARN_ON(__tree, __x)		WARN_ON_ONCE(__x)
+#define MAS_WARN_ON(__mas, __x)		WARN_ON_ONCE(__x)
+#define MAS_WR_WARN_ON(__mas, __x)	WARN_ON_ONCE(__x)
 #endif /* CONFIG_DEBUG_MAPLE_TREE */
 
 /**
-- 
2.47.3


