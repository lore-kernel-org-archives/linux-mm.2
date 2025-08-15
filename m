Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80171CA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 13:56:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6CA88E01F9; Fri, 15 Aug 2025 09:56:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D57B98E0003; Fri, 15 Aug 2025 09:56:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C461E8E01F9; Fri, 15 Aug 2025 09:56:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B63FE8E0003
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:56:03 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8569D11585A
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 13:56:03 +0000 (UTC)
X-FDA: 83779140606.24.457FE2A
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf25.hostedemail.com (Postfix) with ESMTP id E3BA2A0009
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 13:56:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fkUBvPcp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755266161; a=rsa-sha256;
	cv=none;
	b=0svw2H5kf2Fs2mTka+no3qNEf+0a2t2CLKZpPPGR6D2cpF9GYh+n6G/QvLhUWfSwEMZ5g/
	EVNXhgANVUgHr56aia9sSeCBr9Dyq6aC5QKVM/Y7H6yDCCVltD0/uWuOE8fxmdRWA3ly7F
	KgBsRVxlassjvL2KUnZTpS5ZXT9F24A=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fkUBvPcp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755266161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=htOuw1jckUm3cFOQCy2Ez0sym5NjcBkm+jIoTXRQCgk=;
	b=MFz4FVtZJUbt+HtxvpjLfH+RdO8YV9j/OdMWgIw+Z3MY+u26RvAIkauG5TO0tC5MK3e8aB
	qNWYltv/n563CJjf1m3cGdcFEpP+ABRNHcDc1k95qIzfBrQE5UE0hB7mTqq8wn71fKApy0
	Sc8iBTMCnbN1UgmSHM76v7mw3aJa7pc=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4b109c6532fso18788381cf.3
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 06:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755266161; x=1755870961; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=htOuw1jckUm3cFOQCy2Ez0sym5NjcBkm+jIoTXRQCgk=;
        b=fkUBvPcpdlGWmuYN7GevohIwfwbvA/re36dD2GqwqceRkpAyHMsdN+utIluTxjXwTf
         Xw3d4Pkb8a3bDOeUXzQL4D6v9hRYMPkUka26iPA7J37CDXYpnE9+cGFKzkDdM/zZioy9
         +CJmdlinp6Z/C/WHdthQyAI0baNq8gUAobOUTtw6nygjL/lZGxp2wK9Zgd27eeZWN+EP
         BTYcR8zqBpE2wPsSU34/MvO8udFJl6VbbXgKB/O/VzsfoQj451FHxan8QKFN0QZ2p26J
         7S1nCaDNTi7R19onvUxsHPVnWjMWWdANQUXXTc8w2l7fUo5PwTNo5UfMv+moTbBhSR9E
         D9vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755266161; x=1755870961;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=htOuw1jckUm3cFOQCy2Ez0sym5NjcBkm+jIoTXRQCgk=;
        b=UU9Tft2k6uRxZLHWskO/lt+jFJmRx0cShWN3/KfGiOcyohqu8zZYzXSohqsANS3vli
         k+lgsbqqNleKFxOf7t+UK7u1XlnODdx5y8T/p2vPICllaz33rjD30uHfYUpTepZDIGUN
         /zu0f/Hnfo5MHHQfD06SAgiugrdtY/bDFfah7nf/91cy0EkTdPZj+AWHBHOPVEHIELfT
         NFSuBesJx8kySdfV7F53BxLbtjF0A36/6zb9rvQgv4ZtqVWoLF1nydWaD7WuuwDVP6+y
         g4gaiH6T0MUQxiTwiMIkNnhGsJyMWFoaYfapSImQXkIq3gjkDdHUmygeLDz8rAKt2SXO
         nR0g==
X-Forwarded-Encrypted: i=1; AJvYcCXn9ulz6OWNehwSAml97lW8QnqCyrqOFKt3h4PIkeCTbxHsown6jKv1wdjOOSIJRjvCt/tQNH4DjQ==@kvack.org
X-Gm-Message-State: AOJu0YyC/atO6zUGvn5y12oXZzLCL+MYHxJRz8DBN9t8MzBOTR2KICQh
	TXzwwOGJ92qJ1t6aYHBN3ldnz4tMT8Yo1avRSN8dkeAe3JuQbsUwfNxy
X-Gm-Gg: ASbGncvblGKL7RVoXZBVRHdtN6D+Le6lH1Oi5uG6gOQseZHeXpr/5Ly7I4UWjyO11h8
	wc1VMKgEGDn+2fTxlwRkAcf+kntWaYcNp2kepzBsu6qQ7tHtbgyVi0O00sb7Cfho2+9uUs2eF1f
	1VvBGkpVTfpeNbdcEd6F4GCEaiTR5C85CJDja4ckhhxxlPhrktSY6tucPmEdl6fJOSIPgGTO+b5
	b3+hG5PCm+06+tZao1vacfu+KisAeP6puB1FJj8+hOqnxQ0qrzDOywskR+qu6jqWmtAHA55uFo7
	q9LSe1Gf4cohNTRLuLy5/mrA69YIjKL/qIxuDKeZ0xLvDqyOjD4CRsv91ZfKekTVcMmeyPHiKlj
	hxdEPxrNpdDHsYpnbFnpg
X-Google-Smtp-Source: AGHT+IFA5ocU0t0P6Vd1e5Jiomncb95U626f/HquasQ6giNUDflHW0b1pvVh3BD+6pcW5GWRqf2ajg==
X-Received: by 2002:ac8:57d0:0:b0:4b0:89c2:68e0 with SMTP id d75a77b69052e-4b11e2c638cmr30410701cf.60.1755266160836;
        Fri, 15 Aug 2025 06:56:00 -0700 (PDT)
Received: from localhost ([2a03:2880:20ff:71::])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b11de55b61sm9255701cf.56.2025.08.15.06.56.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 06:56:00 -0700 (PDT)
From: Usama Arif <usamaarif642@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@redhat.com,
	linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org,
	corbet@lwn.net,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	hannes@cmpxchg.org,
	baohua@kernel.org,
	shakeel.butt@linux.dev,
	riel@surriel.com,
	ziy@nvidia.com,
	laoar.shao@gmail.com,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	vbabka@suse.cz,
	jannh@google.com,
	Arnd Bergmann <arnd@arndb.de>,
	sj@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kernel-team@meta.com,
	Usama Arif <usamaarif642@gmail.com>
Subject: [PATCH v5 4/7] docs: transhuge: document process level THP controls
Date: Fri, 15 Aug 2025 14:54:56 +0100
Message-ID: <20250815135549.130506-5-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250815135549.130506-1-usamaarif642@gmail.com>
References: <20250815135549.130506-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E3BA2A0009
X-Stat-Signature: 47gifdpa8f1mh4er68o4t1i49wtrq3u4
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755266161-311116
X-HE-Meta: U2FsdGVkX1/a9Uax/fkffdlpvKHJ90mEgUhQZy0S5dEj4YrKiqhJZvlW6X5KXXFufTIrJ06qpUEzfq9rrKPcP1TL1CDWphZ3xSdZNhWlujARju4+5MD785YyC7ppD1hNsIHFXAEOKtXcevjcf2asbZY5rQghdmD4hQOlQMIXZAbCmw3ZhgtE5NgmtfOU+fDFLA24vdN0nws4FFQcnL/it4uSiNtt56N9H14SR1yz75KIcUHj5C6H99+EarjnGVnzCMVc2pZfYCn/8HGs6i/5U77263BIqsQk0l7xV7G6XtKUtO4Kt9L+s+hpVg8CH5xZkXT9Y29oqaVVZu4XSzXh0eeqXJ0Ea66/Y5WSUpuh4+kkyDB+8qHpKko6+DGVSSuzETP11ipQIOKOdfUGY4bWG5er6Jp2rOlrehhB4rBiQeBy8FqBJErqCmaZGZ99CUQ3HQt0cVzUikOhr+Ubm3D+r+QJ9s4FYFbYKSiB9I93AjUmaZLNXp6k1b10b4OJ6zyMf1Xs+0awE+QwFd33kLsVv+dV5Vo015XgyxQWw6pktCX1+syjKF9xf0VXFWac0LpVj53XTryiVMAHwuIdbex+HXxVZ/8UkUxADNlVo7UnwvegCLXrxvGkfBaYgC0QlFrJczOue0juZqhhLs2FH5R8qvD9Glh+3bn+l2HVXYZwJyx4QvL+AQmi3uPk01yEWwtIFuanrROZ7UyNuOTc488p/aj0XHxMWloWSp1oYrkDfkVsXNCnsts/qdW33vLA6B9Ju2Eqr7+kCdAPp5XFHAUUY5YHD6MDn2DvGp6ZW1GF3PeVhXwoeICcRwjFCSnHmsTrZ0sfgVRCDuSCrv9m/1wR772j74m+UpUA0QjfORkDcyp7bSbDowMLxCsmVsBwiXOI7GuKiV1VgE9y1tDRqVOfoz1uPqJQklcdgGC8YslCFUEX1WVnA0MRHCxt1gTHOw3mlT8FzsfU1eTpVJOKFEi
 Wdr/DHX7
 O5WiQCxfCOHc7ZbdtjJQ1/A49nEg+zCcB23DBnbi0u5iGkt4FxdbUVbcBbOAvlD7JrekvUhs2RhCxTJJ4A2sxEfFuwp9My2FR4Hm2vBYG84Ep8leGknE8fKStcbEt9LyeEdtfiQ1P9pA3wN8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This includes the PR_SET_THP_DISABLE/PR_GET_THP_DISABLE pair of
prctl calls as well the newly introduced PR_THP_DISABLE_EXCEPT_ADVISED
flag for the PR_SET_THP_DISABLE prctl call.

Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
---
 Documentation/admin-guide/mm/transhuge.rst | 36 ++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
index 370fba1134606..a16a04841b960 100644
--- a/Documentation/admin-guide/mm/transhuge.rst
+++ b/Documentation/admin-guide/mm/transhuge.rst
@@ -225,6 +225,42 @@ to "always" or "madvise"), and it'll be automatically shutdown when
 PMD-sized THP is disabled (when both the per-size anon control and the
 top-level control are "never")
 
+process THP controls
+--------------------
+
+A process can control its own THP behaviour using the ``PR_SET_THP_DISABLE``
+and ``PR_GET_THP_DISABLE`` pair of prctl(2) calls. The THP behaviour set using
+``PR_SET_THP_DISABLE`` is inherited across fork(2) and execve(2). These calls
+support the following arguments::
+
+	prctl(PR_SET_THP_DISABLE, 1, 0, 0, 0):
+		This will disable THPs completely for the process, irrespective
+		of global THP controls or madvise(..., MADV_COLLAPSE) being used.
+
+	prctl(PR_SET_THP_DISABLE, 1, PR_THP_DISABLE_EXCEPT_ADVISED, 0, 0):
+		This will disable THPs for the process except when the usage of THPs is
+		advised. Consequently, THPs will only be used when:
+		- Global THP controls are set to "always" or "madvise" and
+		  madvise(..., MADV_HUGEPAGE) or madvise(..., MADV_COLLAPSE) is used.
+		- Global THP controls are set to "never" and madvise(..., MADV_COLLAPSE)
+		  is used. This is the same behavior as if THPs would not be disabled on
+		  a process level.
+		Note that MADV_COLLAPSE is currently always rejected if
+		madvise(..., MADV_NOHUGEPAGE) is set on an area.
+
+	prctl(PR_SET_THP_DISABLE, 0, 0, 0, 0):
+		This will re-enable THPs for the process, as if they were never disabled.
+		Whether THPs will actually be used depends on global THP controls and
+		madvise() calls.
+
+	prctl(PR_GET_THP_DISABLE, 0, 0, 0, 0):
+		This returns a value whose bits indicate how THP-disable is configured:
+		Bits
+		 1 0  Value  Description
+		|0|0|   0    No THP-disable behaviour specified.
+		|0|1|   1    THP is entirely disabled for this process.
+		|1|1|   3    THP-except-advised mode is set for this process.
+
 Khugepaged controls
 -------------------
 
-- 
2.47.3


