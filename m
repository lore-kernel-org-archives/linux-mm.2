Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DB12CA9EC1
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 20:39:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC74C6B0088; Sat, 10 Oct 2026 16:39:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E77C86B008A; Sat, 10 Oct 2026 16:39:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D66FC6B008C; Sat, 10 Oct 2026 16:39:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B23CB6B0088
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 16:39:15 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3C550C071D
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 20:39:15 +0000 (UTC)
X-FDA: 85307881470.01.9CBF5AC
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf16.hostedemail.com (Postfix) with ESMTP id 84220180002
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 20:39:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BIlFURbt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791664753;
	b=MA0cMIq1//Usp8DjP3z+vzW6blcEdfJP/ReeeQlHJMiyixrqrP1n0nQFdLTuZ2GUzgxxnv
	LAknnyV/kKrPL1zWzh627iDX/UxhijVk2aF9msqUt/loLT/yyi0jyYM9KGfb0XUXQB95OL
	1JNCNWAuoP9DyYMJbshgUZZZo2pSf/4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BIlFURbt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791664753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=JNuMer0adZ1K0ed6Vf60DHY2owT/YxK/mEmjSJifHAw=;
	b=IkpdNPRduqL/HJXhksk0OAkoloYS35vjzO9H+Z0m6Eyev/VaSJTvU+iRzPWLXml/W9PMPg
	7T1tseWk64pztvqTaa+qOOurR9VbR9LZH6aEPuTDkhqyJeSTtHN/xF0d0DjW2NHV6muZC+
	oQ8bbp2vzOOEZGZRlWnw/hgsqsPmr2Q=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a1880e1bf1so7122415e9.1
        for <linux-mm@kvack.org>; Sat, 10 Oct 2026 13:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791664752; x=1792269552; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=JNuMer0adZ1K0ed6Vf60DHY2owT/YxK/mEmjSJifHAw=;
        b=BIlFURbtM8PcbSAdJWnBo3P9EVTj0nk+mBhyHs4ekw21MPsXq2Q/37qmUtuaDYpl8g
         y/J1HWQcMsIaT5CaA4tTk2Qic3gp0P9rqbJs9ShDndtUyq1vWQ/wzRZQoyOy6mnPV/A0
         5Ujvn26/QjDj7/kW2/oB0nFvWXPZhlkZ5zjwUdNaFi+biocDqqUTpY53Q99TXV9Z53PA
         JLFuvjYK4PRLXH23RlhSB1zQuAA4WoGSLBbkLfoxxV7347SHOcfabq0kKh3yUU7jwTsN
         F1pAz9i7KyxfV1eQIe/St/KT07b76KQzrU187buN1yJWLSKZALdj9z+yG+O/Ni3UF4CV
         JF+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791664752; x=1792269552;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JNuMer0adZ1K0ed6Vf60DHY2owT/YxK/mEmjSJifHAw=;
        b=xup0wLc3UUFvMHiI9ptJfdDu00Jk0b0t7Nx6iOfzuHpEhPTQyv5OGY6Bj9YJDMyy2U
         ZA9vuhGuh4Pn1CCDwzpHsfeti1kqzOX+K5W9EEkZYbhPA6Vuu0IzNXx6rB+3lsd5CDR4
         OTgUnzdKTpvolX7Tw8mFTJDxDj8My1pNKZWCdH6r2NCGyeVtXI91FdYQ+fhTQcbDhxh1
         ha6aVh+M280JQ/HFBejqcmjVgdMTAkxQ57UF6anRyDKGVr0Es30al04hBRypI6zZAdQS
         JyCGu6+mBClwvhQGPuUXlp4OlPvER3K4ow6Pu7l7y5j8Tlc016IvuemC6MHffffEZFJ1
         9rsA==
X-Forwarded-Encrypted: i=1; AKwUvBwDbQTjlkpy7QD8jHGgZooEB1cGiEo+qjN6qPWJPYtKTzfySeKx62t7v13rbjS4E+hRF81DRGPAOg==@kvack.org
X-Gm-Message-State: AFq9FYJzd2qq3ILvXLT2AUTVW08TYtVPlVi8zJIRb6bud18ekaLilEWL
	zHxEWjbiRm7f8lGouPBHU5Yn7NfvZxB2WS/RId8AfvGm5GMy+ZpcY5s0
X-Gm-Gg: AYBFou1xLPKA0j7SoCWOE0vS5WyehxO/S4VQKoKljKQtp3eLbxUAKQtVeost9sJcEJ/
	h5xwjbJhd/0Guh9tlpa6GMBDKPjDOLEqx9PJ24Ceg+t0OiNvj/4X4opI3/6CNKVrPur1sIR56yJ
	FZ/x+gczgvizrQxY/7+eWU/9iLCUjbjPIbkxNbpI9YKTzbSt709GwyPX7lhceiIQNjNXnClGjmb
	pghMqfjuTBrrqbxP1VyIobFjTI+2rVI5XqhAZZA/POya+sZHQHygzWzRf8JE1L9l+42ANyjgoyZ
	77+WsuDThavXY3FVnLUfH4Lizd/kONM+OLj/hcSPQ+lw6y2fKlujyRne6TDPOCT1/6Yn8VQje5A
	TfUxaRLrFB6nVUeUMAlUAPzR8i7vXkK3klMw1TvSmGME8IBlyhH5/k2z/yAv9Z1hUYrdteC8nci
	iw1aNW2pzy2dQVZ8kO3US8pgM5bNNukF3WvDGDMHA5eREww5naTOtmdRotv6nokAsSThVk4L+h4
	LovDBJCwrsuu18gDZlL0XcbJRccfPZBadpIQRw5UdKZBDoK42v50csD1KhFPlMXJJVcJaJ9vKml
	0HC0dPSoSUBrZ640FpeWZI7cg+/Hs1Xs8MytCQ6wFhXKTOxQaezk/fR5mwA/GYnoQOWlOGohzF4
	=
X-Received: by 2002:a05:600c:4709:b0:4a1:7baa:7303 with SMTP id 5b1f17b1804b1-4a18e4a5237mr105971385e9.7.1791664751688;
        Sat, 10 Oct 2026 13:39:11 -0700 (PDT)
Received: from imx93-evk.localdomain (dynamic-2a02-3100-9d3f-0d01-48c7-5d76-0ec6-9dac.310.pool.telefonica.de. [2a02:3100:9d3f:d01:48c7:5d76:ec6:9dac])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18be96549sm217808145e9.6.2026.10.10.13.39.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 10 Oct 2026 13:39:11 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shengming Hu <hu.shengming@zte.com.cn>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/slub: initialize the free pointer of the bootstrap kmem_cache_node
Date: Sat, 10 Oct 2026 22:39:06 +0200
Message-Id: <20261010203906.93156-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bqdfh9ycq89gsfxbwpunzxz6yuuwcra1
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 84220180002
X-HE-Tag: 1791664753-331463
X-HE-Meta: U2FsdGVkX1+vGxubuRFq4z9Xm5tRAWFKUpyhDor3wQF+PFrqCoEclQocbsJBVfnjojKZyrkqAqwt74j/VV1cEFDbfRKnr50+h5VNLdUvlgqK7icSU44FJl5/GDfCD3CsXWQkjofMHJXFwZR3pnxzYjz16lbJ7W8pjMHzDUYcpLN8oUkJzRgAs4G+kRWyDMKUIOoy1p4y+SAnaQprqSCBZGSnLeMIwTtD7X9lfQMtY/0GAsjXryShalc12kOC1FDwmnlQogHtz67TU6Cgndxubvs9SzEXAUezxyz9tge8L36ujDTe2cXsyUhy6mbezslU335gmWcjIzP4CPeA743E5v+OMFC+Z9RwJSNRD09a3j/8dJ8oLnK/xg0VkQkXOmCkJinT+3QXM9i9WD7yEdFvDvMoKfB+Nck4U74ab1q5pTJK24bQ7aJ7537X7Jl3Wt7XHfMpcsr/KOJ7I6KbphIU6HvGOV4I4WB6CRR9ASkxgTDUudQx+LLbUMAL1SB80S8pvxPlrGviMHOmHz4+mw1LYHu2aI2fEdtLN/Y4oB1W6UGV2+m28yJe2ABWap84n9/2fcXviToarSN0dxdY5xdVO6jRBUt1u5yVWJMogYVwe5eI48P4ltDBfYs7JNfxa7feALlvNYYXsQq83zN49Wy1vikGzo4aVuz76mofKtjhqsx5jLuNWZ73nPM/xXatlaUVwvKx4Sn2m8wT9NHnyouYMslDUMGsDadpPRSMzSev3sB0MhvceaAAn/czWBB6YJW3acEslyZpAhygQGc/pJ/ef79hfl50jvikmGiFq20Mx8iEQFAFXxUWQwOXl+JDPOA228TnNQ+hy6MqxUQk5SuTCG6KJG1PUYwXKxdefaHqK+LwS7RVFwJupvnlSGqIscuPk0+7R14OCT6Fo02tt/YrhFvHq+ILxUu1i4sBgi8rXAgU4X+deXg4bonH1fxmdpnZSXkwqImEZ8G0QF4yJtt
 bkGHOBmb
 8MCex2sN88Mo1RRLQW6Z4pmpLkYUHJApw5ByA5IQgndudqppTn6XEyxlXJyVcp1aXBvF+qvt6YZ4LaEbCvYo8OHbqKrEKtU+qzkNn0hbUTT9umV/FdI5StIbCLiqLRe32HqwvWyVwk1xA38OObuitueixGoLDzCnk3jszj+f2kLFtlltW7KomBjcHmE5O77ketoECeAN272xwhpxOF3+lPG9rPHi8sbwUZ7zwYoK8rzXbY2T1FhNjSBzrPBP/DpIemn84aAEtzJQbW5/osUmLrvkmmFRfPNbs3robAN+mqmhCTMd+sXjDLm3YX3x4YFjOn3Pva9RFe76Q4dbMhWQIG5QvUsFx/H8ViJmVun2r2uXa0AA0L8MLCeDSlxBH8iRM97xuCR01SwI7jmHowA7ZOJPhrBMPQJIgKlnZpKtjEIKFgNJF8/I2XelIyQlsaydzum2EWafLpGcFEsjhP9OQvVj3Bg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With slub_debug=FZPU, validating kmem_cache_node reports

  BUG kmem_cache_node (Not tainted): Freepointer corrupt
  Object 0xffff888000140040 @offset=64 fp=0x5a5a5a5a5a5a5a5a

and taints the kernel. Poisoning places the bootstrap object's free
pointer outside the object, where check_object() checks it even while
allocated.

early_kmem_cache_node_alloc() previously took this object from a
freelist with an initialized pointer. It now takes it from the slab
iterator and builds the freelist only for the remaining objects,
leaving its pointer filled with POISON_INUSE.

Initialize the bootstrap object's free pointer to NULL.

Fixes: dc795d4c0282 ("mm/slub: defer freelist construction until after bulk allocation from a new slab")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
QEMU x86_64 and custom QEMU SH7785LCR model, slub_debug=FZPU:
validation reports "Freepointer corrupt" before the fix, clean after.

 mm/slub.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/slub.c b/mm/slub.c
index 54ec125033571..9a20aa820bb0f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -7777,6 +7777,7 @@ static void early_kmem_cache_node_alloc(int node)
 
 	n = next_slab_obj(kmem_cache_node, &iter);
 	BUG_ON(!n);
+	set_freepointer(kmem_cache_node, n, NULL);
 
 	slab->inuse = 1;
 	build_slab_freelist(kmem_cache_node, slab, &iter);
-- 
2.53.0


