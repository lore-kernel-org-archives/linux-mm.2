Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76F8BFD461F
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 05:47:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A06A6B0088; Thu, 26 Feb 2026 00:47:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94E766B0089; Thu, 26 Feb 2026 00:47:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82F536B008A; Thu, 26 Feb 2026 00:47:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 703D36B0088
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 00:47:21 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0C5161A09A8
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 05:47:21 +0000 (UTC)
X-FDA: 84485525082.04.A7F71BA
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf23.hostedemail.com (Postfix) with ESMTP id 30EC7140004
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 05:47:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kbJQqZoK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of sanjayembeddedse@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=sanjayembeddedse@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772084839; a=rsa-sha256;
	cv=none;
	b=Ljy5nkFRcVKFBlRY8jX0Vz9/lf6eYp121SGxUXQCYEuEOjdLFSPHSdmzEmMMnpbJd2H7Yn
	aqzc/e2pKulyyus98cOislrDSIm/9ExAr+qCoRaw35y4H0T46VWSNReYChYKwSo9R9YGei
	0fgLpr8BR/7jXea3FN5bfokG4GO7AsY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kbJQqZoK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of sanjayembeddedse@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=sanjayembeddedse@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772084839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=m90N85NLQCkdCZjrPAkhaouebwaruDVu5ZveDlIpaQQ=;
	b=hOqnPxfkp3+tl/v4SS8UFLmumQ1SwwZlAtAxeBlmhkctWJQ8spz4PzvyaMz0l1/B9pI2dr
	T5pj04tvEgfYBfsePUhD4zF/F2U8REMJwThbbwnlUG6j/p3v8C9enpSrNWBQFITqUS+5aB
	Wy8nUPjodKHF05wSaxEu8J3KJb20fqE=
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-c70bc5b4e86so186529a12.0
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 21:47:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772084838; x=1772689638; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=m90N85NLQCkdCZjrPAkhaouebwaruDVu5ZveDlIpaQQ=;
        b=kbJQqZoKStwV7TMBOgYg61tUer2osAOjYw8b9RN2QWXx8ix27rVMbpcdTAWR83h0rJ
         x08hJu5eEy73zcAEZ5aqeYA5LDTeKrsE8E7dC7AefoCfepyX0K0t9C4/PszEa7S0eQi6
         qYxF8wSeos33T8P5VzSGXuqoQuLd8tJM1LGf2bjvIDSpx+v9z/vpWmK9eKosKrkhAkFQ
         kkanlt8yWMTCCZz2PaMM3VtYJR0Ur0UQ4ITqf+BkiMivCiYdxeOrwEqjTzC9xJWBugBP
         m/184myIzYcHXvLLpRFKhZDjfuy5jTnFSnMHjHAyFI4SJSjNeAYTUuLoRJ3KHSUB42Yy
         1h0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772084838; x=1772689638;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m90N85NLQCkdCZjrPAkhaouebwaruDVu5ZveDlIpaQQ=;
        b=BwTU5WRv/7PocoGoOTN3PshyukqGUj0rJaEWwir36bwIC7TpFEFpFajuYE1xanatBq
         mGWkrx0LCctLuAC8AzrusILj5BaPa6SsJDeQm8a5cycP4ImXIlLgFeiiUD1lQnxFL7Ib
         caC6452LSLkuThRVtE3zY7wvemz/m6uuippDofG3P0ImdqMgDtX97pLuIddPMr5jSE5V
         1Ad5fLRSn/Q56khMCdB9LKCYMOvMBtQpOT+Ea+CCLQW/nbLCcOARSCYXMkeySbIsGXku
         4IMXNsHgLNTDZyssnqvtADXHayvXH10rFj59lLuT+nEQ8DEagauCwNtF2xmCJI8FaayD
         JFIA==
X-Forwarded-Encrypted: i=1; AJvYcCU6iyFiocBNPRr1+Qia4kfhyQrXu5yR54k28TqyPS1wiSzuF7Jhn4Ea3XrGD6RZNjqxmkApfrW8HQ==@kvack.org
X-Gm-Message-State: AOJu0YxppO982Gr7DVbB3Rv9L1k67VpfxpIun81nWiPkNMMBnDH8Fdeb
	nZ5z8+K3bVW8Xyvw3Argy2vGwzwoipdb1x1Tes2H99QtpMjAAB3pNW22
X-Gm-Gg: ATEYQzy/7ooX8kq4ekn3sZr2ef+sFDveSXLzhQf4QYUqowAM9etmaEuQ4i0Z84m/Dp/
	TkxxjmPyI+Ca+rLmKk3qIUtdfqKXqwGDdPPytynAV+u4AxiptTIS9RQ7epgaF/q3EQcCXSQUABp
	Zb+dyhYgRMMvtm7nh9vjib3x1xaxs5JzneZFYmVWldbM/tHd96cQ2b4vkOvQc5Zcxi17RxbI32U
	CP/g5P70tq/a4SZ5xV54QYXVmAKRcCRuovOYS0SKop41/LlREKnL2ut4YMaMWDgse7u2rgV4b8P
	tWwftqy9B/pzAXZkfOktegyFOLlsxlBYtUuMfso4m+pGqEMMJQVMqeSlkFOFJxgNE/R/J91Zp3I
	0gJerfkRKO4Mp5j5wlXHNMaKV2m9AYq7NPX5/f4YR8nnK5StCHCPvskkN7yqZG3ixg3jOU77NnN
	iLaRK1zlc3LuOMODnIwGp5gXgaAN4W9tdkxBP7r26irBZZz3YLxfmsR21u0Uw=
X-Received: by 2002:a17:90a:f94e:b0:354:c629:efaf with SMTP id 98e67ed59e1d1-35928c4bbc3mr2519336a91.35.1772084837867;
        Wed, 25 Feb 2026 21:47:17 -0800 (PST)
Received: from hu-ckantibh-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-359037afe31sm4471199a91.16.2026.02.25.21.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 21:47:17 -0800 (PST)
From: Sanjay Chitroda <sanjayembeddedse@gmail.com>
X-Google-Original-From: Sanjay Chitroda <sanjayembedded@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sanjay Chitroda <sanjayembeddedse@gmail.com>
Subject: [PATCH v2] mm/slub: drop duplicate kernel-doc for ksize()
Date: Thu, 26 Feb 2026 11:17:12 +0530
Message-Id: <20260226054712.3610744-1-sanjayembedded@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1ed4nxtbxnp1j1jsowtd1cgbybsmba5r
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 30EC7140004
X-HE-Tag: 1772084838-863902
X-HE-Meta: U2FsdGVkX18N8THgxtXUHYmdUxQ83kjwrslzOLF489fzwTMxUFkiVjei/P3FUA3tGap7RWhPlhxQd89BgckauTK7fSWBcHtxhtzJoSH/Tn7NCU3a9hcyhN8U4YFZJZp9fEX6cFUUU6SGjmUo2FTRUntvUBk8VO1sYUvvIT1tDRDNxAO8LDM9lQ1RK5llluQ7Gf3Kv4ZCSZ0BYeeP2mEpEvZUw52StV66nxrEslRzAfLu6qNjePS6N8yZq5qIve+kjtTv/MrxyCIiyz3G8c4SR/IA6AJAzR4HTxsKON8N0mVS+SGAD0nERPb0f1DPsSuSIlYQLfLJno8mwXdyHnHDCpurIP9kSuSTDedriON6a9+HqJ17szx01KFkF81Gia4C9DSmkhsMMGU/Bdb7/SL96FSmc0KO55rLvw3SgApFXnPjtBouglUG0uXGVbslTS7ggOIS+jN3thNVUiidRXiY5/K41ggdNB2Rvh3Kyi+S2LsRCM1M/CtnVksUrqe77JanBm1LRuwDNOzSBN5f9UJQuE4dV92ruWSFa0T4yA7PvWlLPMmN5UJV3RkQ2jCaH5YJKZ5Rss7zUPz5L9VUJsgT80mHJNft69BJ78NcpkQQ5h08DYHQLhB7mMvD8cZLUk8ycDj0h2vvNE6fsxvDNpJMl0g9kpie9h6JjCuhpXO0JkYQHqcHYOvr6/t+uXDk2/UrUxfX5EHIktmzIu4sj1Gz/mFP2vrQhL6DH+Bt5WPvDeU0lOR6Rieee3JQg+q4NYcKujpDS4ZnuXRP11CltCnU9ro1gKOPCHc5WeFakegvGsBdUxP/Vlh2ccah6ZwDfMY7IZQLWn0CywubK5nzSUiq4lN/F1P2OZznHneLaB1F3iVi4CivGJkxsQ5RQFO7LHrKOzfF0GcXxjsSmjAgD4//84T0ymsReNIc7E9AlfoNWqqFSErEpFUr92ADegfJNe4tY6BNEr+AO7bjYYYYwUN
 gQGHn5K+
 dtPTi4zgCY51FFxnHiT4kwjGPQxkUtav1t1NkYSfo7AlN2EKunIi/hNhBsBOw/0CdDibYMv+pja+hgu2UOM4XhsDFZTPLNioiLj+TOI1R3ttS4BqYyHHxbn7lN7xrda0lv+5OOpMkrjURnaETu/SA5ZHruFbLzVrS6schb1D9iJ3ZnJnP1ytwr4YAL83s19S5nP9Nd+ADt+HOYRr56fRYA1ggrXWjPNP5u9APO79ZjIrmWjxzBMd5jACIKM30KM1EWMN9ZgkP/jeeLCNDFBTlMxcIkdLkt0Pyg2kHTPo0XZrH7r67BI9ekaT7XvlBo7XZsthHB1j7uvBciyBpDpKZ3CqWplQi/h8EZFU27RwF6Oj+15gKsZt/6pyVZJL7PhckvPsu7dWVkTnxIy8ohbHxkzr7aHAT89vcyyT9CcQoEMQfH48JJMnP6/+bbQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sanjay Chitroda <sanjayembeddedse@gmail.com>

The implementation of ksize() was updated with kernel-doc by commit
fab0694646d7 ("mm/slab: move [__]ksize and slab_ksize() to mm/slub.c")
However, the public header still contains a kernel-doc comment
attached to the ksize() prototype.

Having documentation both in the header and next to the implementation
causes Sphinx to treat the function as being documented twice,
resulting in the warning:

  WARNING: Duplicate C declaration, also defined at core-api/mm-api:521
  Declaration is '.. c:function:: size_t ksize(const void *objp)'

Kernel-doc guidelines recommend keeping the documentation with the
function implementation. Therefore remove the redundant kernel-doc
block from include/linux/slab.h so that the implementation in slub.c
remains the canonical source for documentation.

No functional change.

Fixes: fab0694646d7 ("mm/slab: move [__]ksize and slab_ksize() to mm/slub.c")
Signed-off-by: Sanjay Chitroda <sanjayembeddedse@gmail.com>
---
Changes in v2:
 - Instead of removing the doc comment from slub.c, remove it from the
   public header as suggested by reviewers.
 - Follow the guideline that kernel-doc should stay with the implementation.
 - Updated commit message accordingly.
 - Link to v1 https://lore.kernel.org/all/20260220124243.3264133-1-sanjayembedded@gmail.com/
---
 include/linux/slab.h | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index c5fde8740281..1c8c53b068b6 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -517,18 +517,6 @@ void kfree_sensitive(const void *objp);
 DEFINE_FREE(kfree, void *, if (!IS_ERR_OR_NULL(_T)) kfree(_T))
 DEFINE_FREE(kfree_sensitive, void *, if (_T) kfree_sensitive(_T))
 
-/**
- * ksize - Report actual allocation size of associated object
- *
- * @objp: Pointer returned from a prior kmalloc()-family allocation.
- *
- * This should not be used for writing beyond the originally requested
- * allocation size. Either use krealloc() or round up the allocation size
- * with kmalloc_size_roundup() prior to allocation. If this is used to
- * access beyond the originally requested allocation size, UBSAN_BOUNDS
- * and/or FORTIFY_SOURCE may trip, since they only know about the
- * originally allocated size via the __alloc_size attribute.
- */
 size_t ksize(const void *objp);
 
 #ifdef CONFIG_PRINTK
-- 
2.34.1


