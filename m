Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B633606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 11:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=SHI+5VJZ
Received: by kanga.kvack.org (Postfix)
	id 59DAF6B05B5; Mon, 26 Oct 2026 07:17:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54E1E6B05B6; Mon, 26 Oct 2026 07:17:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 415D56B05B7; Mon, 26 Oct 2026 07:17:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1ABBE6B05B5
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 07:17:23 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 908E81C3FF6
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:17:22 +0000 (UTC)
X-FDA: 85364526324.25.C663CD8
Received: from mail-pj2-f2.google.com (mail-pj2-f2.google.com [74.125.227.130])
	by imf29.hostedemail.com (Postfix) with ESMTP id A8454120008
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:17:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SHI+5VJZ;
	spf=pass (imf29.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.130 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793013440;
	b=4DpOTh7sB2zQrBV1RGtUbhGs518jFTUrMEVIzXTflwO4bGWNv42B0l8bpXTAXWolL5eQov
	/6yD9MgVOV72F5UezWdjk1qxSeSj/J2iTREB42uMxpft5OJ5ex5vBZmQcjZILmc3vsqNOn
	bUamsthA8zgNfQI0zyqDomfzSZEQkc0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SHI+5VJZ;
	spf=pass (imf29.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.130 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793013440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fmsyrygG81C38l9zQdlGfkeoPAPtMMphWRdYuBnpfhM=;
	b=LOqwotCNadLPuHelE2x8uhj4Ufr8uzxI2KvBp5/C2CNg6pmI9N/zCqt6CmFJBINobp8m2H
	GPYxw9aiBw4SPMYQSDFUaH6Pr/fNHKwQElbxgyMCKHCj+yx4YU/SRdsjHT5jh03vCCMTcK
	EfXo+Zqc3zXHcloed9mpbxWIpWi5gR4=
Received: by mail-pj2-f2.google.com with SMTP id d9443c01a7336-2ea19bc317dso23372585ad.1
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 04:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793013439; x=1793618239; darn=kvack.org;
        h=references:in-reply-to:message-id:date:content-transfer-encoding
         :content-type:mime-version:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fmsyrygG81C38l9zQdlGfkeoPAPtMMphWRdYuBnpfhM=;
        b=SHI+5VJZsCem9H8kKFaSQkOp9TGZu/2ViRGe9USuhchqS9ca6NirdhSaV6gXswcQ4m
         1ejt5xIDtkFBMDqpgov5PEW9ww7ntJEqFDuj/M+vmUR1jl7IGww5JCEgYr88kASZ5xF7
         y4aMt3SwaHq6i4aCGhm7KtxhWxIEoK2/lKl2sG2+mYvCD03LtMuZh0VV/3XUYPlB1c5k
         P7Uo5MrvEOUG0RYVq/P+0xcWrIihujFV9aNacXOojsZrKevcM6w2fGRmFH+mRnhrAYcA
         +6h0V5Hv3ID4MSwRQUjBPCmXMvxr5xIZXVQl8KWe1OFQr9sQeThR433WDsJiPjzz7Ssu
         i0Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793013439; x=1793618239;
        h=references:in-reply-to:message-id:date:content-transfer-encoding
         :content-type:mime-version:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fmsyrygG81C38l9zQdlGfkeoPAPtMMphWRdYuBnpfhM=;
        b=z38LTfXtKsH1/wnn2hi+O5tTU4J6oOS933v88bJZwuPDAqAbrwRc/t6DXKLL2pxdED
         QOBv8RiPYRH7TYJ8CT1hIxZouHzHIU+KQviWGxsHAfG/aRmbo4rXpIN09M2XFPCMiF/6
         +58ux43epWGICqpbhEWBXY2PKZfP/wmP0GuHUoD+1OxssivsrnwVQt+zjz2o0EQVCpVP
         MPWKbU4bNwsxRBU7kGU5wWVvDLNul+/uWZNGZeTw7aEJmY9qYEXY5DTey66YOghyTNbl
         qvDqL8LbajuH71TLaY5Vn0AMJNu3fP069CrrSJ41HuO0hlWcV2DBvI4Py/RN3gNFuUcf
         KYCg==
X-Forwarded-Encrypted: i=1; AKwUvByUVnzk6Y3BPSg1FlI53Z1+j2rq02hgYdDCRdhC6CqpnjF1/kI2OE+naUwHKkjyW80uVRx71bxWgA==@kvack.org
X-Gm-Message-State: AFq9FYKyPLpDu5m5511V0leRrlUvtRhKEKtN3iljCKZawKXxQ6t+8Otq
	mN1DJ7Etp7jKvevnp2tIdUlOaz2LZ3mwyFVTSI19qTDvzTHVjX11z2GF
X-Gm-Gg: AYBFou2ZpP8IAxs2Ilv3Q+cSmJ/uWTEKfbkivcDoxCl1TNrz5ygfVcUTCQjxIR5ocdI
	4lCwMLb6z0gsjuV+xpqW4hiDKKocZNCh1XWhd2CPQ9k4OMGKrMTKceZksqIlNK2RbtNvSo2HHeL
	7z9KEiSF6hKg+ZcLMslDg0PtfIl4ScEclUEH01Wb0kISPa2/5IOrBvZ0nWK0J4/vzozqZgUWR+n
	yoUkYeEMFekwb0Md5au7TKE7HWHi3ge+9O/bSKHQWa99RFP1JEWBBLswfvmO8BoKrZkCVwrdHVs
	YCnH7ki+Alsn0lEffnwNqkGrtkGdg9Hril7ZalA1xp/sg4msIzIr3CTEirEnXRz/rzUTZnnNsY7
	QpNdOG3/cV8acMNKf6qPfN1XcLnxPagDO5NefsKhpa2QDEWm52DTRye4fDIYJq9kIANSO5JSlBs
	vTDbWyFhFAR3B9T4VP8tp1pOccJX2kTknPLji++NUQel9mQqwhJfdhy3xHFfRoajnXPcHeUwBCS
	Q+WOwdzR4I8QVGZ550wT8ml2L/PDv1B4Qa/t2eCD34dFk80Cl6n2blmXY7luDex5gHrpxwaskz9
	ntedGY6cCZGmC0O1qrlPOhK7sKFPHgj9NI1+shG6yFJal4WfibPg5w==
X-Received: by 2002:a17:903:3905:b0:2e4:aa09:fa9f with SMTP id d9443c01a7336-2ea9c84b404mr55890135ad.57.1793013439353;
        Mon, 26 Oct 2026 04:17:19 -0700 (PDT)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea9b1df35asm14878235ad.60.2026.10.26.04.17.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 04:17:18 -0700 (PDT)
From: Aveline Noir <jm5905938@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 Manuel Ebner <manuelebnerli@mailbox.org>,
 damon@lists.linux.dev,
 linux-mm@kvack.org,
 linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] Docs/admin-guide/mm/damon/start: fix grammar
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 26 Oct 2026 22:14:33 +1100
Message-ID: <179301327249.2.1796164575094900927.damon-docs-grammar-1@gmail.com>
In-Reply-To: <179301327249.2.4690198998605536207.damon-docs-grammar-0@gmail.com>
References: <179301327249.2.4690198998605536207.damon-docs-grammar-0@gmail.com>
X-Stat-Signature: i5yh7ppjbha6z8shcg15n6r3jzo5d188
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A8454120008
X-Rspam-User: 
X-HE-Tag: 1793013440-270576
X-HE-Meta: U2FsdGVkX1+FeRHiBnIcQFHeaVhh3eEmolQ/dV6bXlnp5Dc9K9hnY0pMNfeG+TU52Zq31m8Ho+odxacCCZ7EHWUoHfG9a52E/r5cq/2n4Yv7gg+yTaonQxbd2v5YUlIh2/Ctgvu8R1XTGcuMVN6rrvnCsRO/ncCMWYy/NIqCHMEUGuBVXDG+2otsPbEolmoO1s5vKAF9ei2RLjXyhFAIa6ST1M6D0sLH7/PEPVmtjtNWtY7kR1zEMCU/5mzbBB4GDvPi7lFFNLz218/SG+A8Ygdekyz6tTPDUnBpnozB8RfT0BdY/1NRxmwei0guaSo6Ah4TTc/55HtmucHe8i4ZqiB+uhPyChhvO0WUS4pVjAQELlqRIkmN5J8UaTFLeSGmk7c6wEfqqEjb0hKe2wiHlVB3x5+WwzGHS+aDY9mlwkrB5QZarYo+1AmH9PFhnZs/9n+diUR1uhOcCv2UqQr9TWL1w1fNGdPGr4T3y2BmeZKDfpCbeQwJG1X90SsKfvpCHXgnSWKxwoVlqtC/RPj2+fTpM1aHqoE2/NvbZP5y4E31rx9FJ/o23Jb3d++8H3GD+nIORfQrG7a7imQJoxt2EMGHvYj8TQCrYGkC/fmGPslnO9V4lKItD5BTEQxHPju/D1wahXwwJJkhNSX2GtN/0WGZhwyvLCcBNSUcNO5BJEj+5STU42exWWnFVue1XmQrlXFTWXVZjBW6kiOyfZw8L9BLt0F8O83bXYFOjKiQhhvxa9DpyPj3tUI/hpvcBENSU+XS41vPqZAN/1bQ3YD84gSaN6fellwPrlkPahGFaeJlhD9ZISr614GkOBW8ik5dR6KMMUSRF7rxaKLsSQpJL2RCRovYEmertuxIT8+PxNC5wAxBSgR+VGOOT1Hy3Ak92lxLmY5+lNyHFKGc0vUB4dLUoxMVjI0+ceHFiUbjatr5ZGtPG5pKipujGwkBsw2hX2GEIbwTd79GjwQDWIy
 1+5YIBkP
 4fpEAiL9qH3jq/hScAVm7h2OUobrhtQRp61pp5pka2k6VZ2yYUVC3UGNfcwIkJykrXpjAg7MRiY8PT9DyIZwPsvCTQk14F4+q9KMOPdzUTU6+Hrmi3qmfKGlRd1AJ+PiVtc8Yn+a9y5FfKFlWhtIFPmhNePhLiUi91igFnEZcxq41kaGzu+jmVw8mvuFGKGn251rX/I6gAj+AGNS9o/YYVIqnOl5cAOc4gAYzplfUlVpndHhxCQG8g/g1M91ca7K6nYYP0/1SnHNNe2J0nyoSkvslsR08YxM2yb4Fh0nwRETdK4T/MWuVEEn4vHsooQ8kqRd9IABiq2zlWDEMIYqIuadc1HFZdXeTOxDAm+faxPQYwI+T9s5I8Wt0bSYBE2Rd44Fub3D4MkzNkGHInkIt3f0RrYfbIDf2i/cnPoOeyTlnQrAOpXWiVLepFqHNb1r8KiflF1RSOJ8s+jcp2MfQZpMSbw3nyD3odHiG28BvI3S6qNiiwJ/e+E1v7BqOrRk1LTVm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Fix a few grammar slips in the getting-started guide, like "make DAMON
monitors" and a region "that has not accessed".

"The line of the commands" used to be "The first two lines".  With only
one masim line left, I make it "The first line". 

Signed-off-by: Aveline Noir <jm5905938@gmail.com>
---
 Documentation/admin-guide/mm/damon/start.rst | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/start.rst b/Documentation/admin-guide/mm/damon/start.rst
index d98b0eb8e771..a83fcc2265bd 100644
--- a/Documentation/admin-guide/mm/damon/start.rst
+++ b/Documentation/admin-guide/mm/damon/start.rst
@@ -63,7 +63,7 @@ the execution. ::
 
 The first command of the above example downloads and builds an artificial
 memory access generator program called ``masim``.  The second command asks DAMO
-to start the program via the given command and make DAMON monitors the newly
+to start the program via the given command and make DAMON monitor the newly
 started process.  The third command retrieves the current snapshot of the
 monitored access pattern of the process from DAMON and shows the pattern in a
 human readable format.
@@ -71,7 +71,7 @@ human readable format.
 The first line of the output shows the relative access temperature (hotness) of
 the regions in a single row heatmap format.  Each column on the heatmap
 represents regions of same size on the monitored virtual address space.  The
-position of the column on the row and the number on the column represents the
+position of the column on the row and the number on the column represent the
 relative location and access temperature of the region.  ``[...]`` means
 unmapped huge regions on the virtual address spaces.  The second line shows
 additional information for better understanding the heatmap.
@@ -95,7 +95,7 @@ monitoring results to a file. ::
     $ ./masim ./configs/zigzag.cfg &
     $ sudo damo record -o damon.data $(pidof masim)
 
-The line of the commands run the artificial memory access
+The first line of the commands runs the artificial memory access
 generator program again.  The generator will repeatedly
 access two 100 MiB sized memory regions one by one.  You can substitute this
 with your real workload.  The last line asks ``damo`` to record the access
@@ -170,8 +170,8 @@ set size has chronologically changed.::
 Data Access Pattern Aware Memory Management
 ===========================================
 
-Below command makes every memory region of size >=4K that has not accessed for
->=60 seconds in your workload to be swapped out. ::
+Below command makes every memory region of size >=4K that has not been accessed
+for >=60 seconds in your workload to be swapped out. ::
 
     $ sudo damo start --damos_access_rate 0 0 --damos_sz_region 4K max \
                       --damos_age 60s max --damos_action pageout \

