Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00DBDC79F87
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 12:43:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 520176B0145; Mon,  5 Jan 2026 07:43:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CA6F6B0147; Mon,  5 Jan 2026 07:43:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CD1C6B0148; Mon,  5 Jan 2026 07:43:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2E6056B0145
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 07:43:19 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 05AF8BF4A4
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 12:43:19 +0000 (UTC)
X-FDA: 84297875718.13.F57930E
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1687A160003
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 12:43:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ze+TwaML;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of 347FbaQkKCAgitqkmz6ptowwotm.kwutqv25-uus3iks.wzo@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=347FbaQkKCAgitqkmz6ptowwotm.kwutqv25-uus3iks.wzo@flex--aliceryhl.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767616997; a=rsa-sha256;
	cv=none;
	b=i3T0/2DAhMsSYl+oXEIkodLSuMkerkkwtHTYIVg9CUDt4VEwHTU0mRXnq/SXQ2cA+wYLNA
	Rg2puZKK0/kTFrtEqTEryt0gxCXRt0zfBpJJvn/e26pMnHpZ2poEEIMxVxCKT1G7ylCStQ
	EnsZunycBkEWUYNsS9f4onhlF10OnnY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ze+TwaML;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of 347FbaQkKCAgitqkmz6ptowwotm.kwutqv25-uus3iks.wzo@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=347FbaQkKCAgitqkmz6ptowwotm.kwutqv25-uus3iks.wzo@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767616997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z46BFumMsZupou+yyaDDz+IWIkSi27BbE4HeuL18C6o=;
	b=VFy3LTDz304aHuaM4RRPZam9ei8gLabDZT+XAHlaMS6X8rHeW4Fe4m6JmL1DBg+2pCash4
	FUoU+yBgi2j5uYuI66fFJODOv7AkLuttv7eqOIyczCh5kjhBAp3lBQCSenk0wuBiHkb8KY
	Tr6YNGv/wbrBezzObnKQwuEvovaEodo=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-477bf8c1413so90088915e9.1
        for <linux-mm@kvack.org>; Mon, 05 Jan 2026 04:43:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767616996; x=1768221796; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z46BFumMsZupou+yyaDDz+IWIkSi27BbE4HeuL18C6o=;
        b=ze+TwaMLpWeIbYSEWkKS4N85CK16r8/t6RANg3WRygg2rMjeI1Emaf//xQOS6aH12l
         RrjEoILCFWGFCrKY81LDeBGPd2uB9mc6afI1G4OpIUqUD0E8bSkhHRSlf9mWkeigXVt7
         YNCSsgyEOIgM/4BCQMWqg5vZ5Ce0BEpR356mkwCDhkWYXThmdoIG1L+vsfdO1DFu25lK
         GRdLYmjSzjJ/sr1p3DF9kQQqe+qcvurB/7MfdU6YoajDruuJMXwfVMwAIwWAK9Gasumo
         M8+Oza6lI5aSZnOGaU0inBMLJnXx5Oinorw1kzqs22GvtVBWfrEpnYA6gVbnB6rPWP9J
         u+Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767616996; x=1768221796;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z46BFumMsZupou+yyaDDz+IWIkSi27BbE4HeuL18C6o=;
        b=oplMYqVzcsfKl58qkr1/HLShFq54NNg5KnL0PVrI/uOZ8upDGwT5nFVkn3tb3aN727
         JBRqhyKOI1sqpB4JhAcm3r6OGQZVgEP4hYUmQdG6f3qQr8QN9lO0qhCyAJe0OZcu6EyC
         zeCdak45vG/Uvlubc7IIWAJuptVMyvoTuFnzPB5pVUG+BykUwfr08V46l9SbRkBB2a9H
         VTo/StG2UIfOYdEqjAz2hkdbkLiqXMP2ELE0etVEWiaUy8hByFwihI/+qPLJhixqLVI0
         onotMefFMDS/wkCscx3fJZ6b+WvQSq36xbNoGoSt1lZvSszAknnRsZ4a3QdQp4UmsDr8
         6guw==
X-Forwarded-Encrypted: i=1; AJvYcCVrcl2AjSKIhiFGdrgsPEAtFQM8MHvxvJEkYKuyaBdHJim3ZettoAsWU4lht8j0dRkjyyp2ph19DA==@kvack.org
X-Gm-Message-State: AOJu0Yzch78iu1fZj1TGc53WkcZToPh0SIUB5199xV8HooitxMNImCdk
	TMGDvX05BjuWFirFm7LN40jaB8iygiukwy45yud6KAB8tE8y2O1jOxoDLDep736/zDVjMCO8hTI
	0jMZeyW8QvltCNvrvfg==
X-Google-Smtp-Source: AGHT+IHb4FXR8+6IReKURWCDo1GDROcS9nS8ZK0U/BuzFCFRx4UyIi4H/RGJplSPzQ8aQkM5GOyc9gt0PQUHWiI=
X-Received: from wmdd17.prod.google.com ([2002:a05:600c:a211:b0:477:a0e9:dc85])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:470e:b0:475:da1a:53f9 with SMTP id 5b1f17b1804b1-47d1954778dmr560627315e9.14.1767616995744;
 Mon, 05 Jan 2026 04:43:15 -0800 (PST)
Date: Mon, 05 Jan 2026 12:42:40 +0000
In-Reply-To: <20260105-define-rust-helper-v2-0-51da5f454a67@google.com>
Mime-Version: 1.0
References: <20260105-define-rust-helper-v2-0-51da5f454a67@google.com>
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=1586; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=NxiYW0CbqWZmci++RKJimpvk5ApS8tJULtdHUF0b2gE=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBpW7G9HcM8jXB7EhJZmxhOVXBkfAqJJ6TRQSLuj
 qqOtSRahV2JAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaVuxvQAKCRAEWL7uWMY5
 RmBiD/wM+sYNoJCxxvFtNBv5ZQEVMGut4EMMHuoEp+cxz9iETUHnUKV2WdfWAv6Di6pElayIQDs
 Xmhu8IWGphqcOrROZon8pQ/ru5idMHqBNRM2+dM8RBKllHE7h894KMd18tczyyVkW3pOf27fQ6q
 xWpaxOVrUUU1Hs5PLZLA/g5rHishlixFGSXGcgZuD1gaBpy5wPSuKXj7PZpruci2BADDp/AdRpn
 2veLunxvPaX7qJ3993M5PhhCJbKLKVe8dmRygNk3XLQWcR6aWc9FYpPOLQUJktuYKeO/nRdJRgp
 xxZcsm8Y/O5i1wAVyJkziZGoV2PMvt+I9/GHmNcv2qtRCKW+YZ8SwmfaUaEcAC89U/77imhlsIa
 7/NzPNXI2eYehM13QdD9pZ+HSTMPFvr5mxzaK8Az2J9/kOUfcNL1u06cVBDlg/SiA5U5oBhsHHc
 tx1BOy6XuvTw/0nWHO4bvywYt/tr9BCfP4D8hWUk5EWzTw0sILLeY6IFRNFmkE7kzLos7IXwWQu
 6APiigknaMWoc7VxpFylvh+5HkBDbmtRUpCPdNN4tcmyE+qE4CVNmRE2Hfu6N550AqSo7hW4A/R
 x7YiCjYiJxt9Lg6gri95NC+QF2aN9O0vXpASyjJJ6OCIssdU85AHDq+TzO3r/7Hu0BWtrm56Y9F rIrBJAV/P58bS3g==
X-Mailer: b4 0.14.2
Message-ID: <20260105-define-rust-helper-v2-27-51da5f454a67@google.com>
Subject: [PATCH v2 27/27] rust: xarray: add __rust_helper to helpers
From: Alice Ryhl <aliceryhl@google.com>
To: rust-for-linux@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Tamir Duberstein <tamird@gmail.com>, Andreas Hindborg <a.hindborg@kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 1687A160003
X-Rspamd-Server: rspam03
X-Stat-Signature: 975d7ksmfs7bwdgnd8w75ye83ryobchf
X-Rspam-User: 
X-HE-Tag: 1767616996-760519
X-HE-Meta: U2FsdGVkX1/Z8Ee3/W8Wn1RUA3gMEDzg5cJM3YJHZqPqW2QwknTP6IJCXDf9QZLV5kJCpB1ebvST7CaR1UwBFgu8s79SXsN3ejpUSyobY6uwKjO03RmDREzyoRBCqjgLnmqv4+6xKHEaHJUpVuNgNE7wSHJUfzF3VqRg+Cx3xZTxrT3tgOkQxWyIhTDoCCgq2A/kBrHER+PcNCM5BM0QbWrQ8J3SHf1EuBBjTkdtIjCm6SpCLYDsq85WOeU5UmmNS/ctGgznNRXzxng+RZATf0a1jIbGBWeSSZsV0tC/xiZAQ8gC8NlHFMZIOiOwsQy2F74HVEfDOOkkiHaE/Bc83PowP943O0fyNZp1H+wNBWr4p0HIS/5bLJaqjxLbxCZyANtLHVHYRj6hJzRjkmleYWYVqsS0Lyr7B4aHVRhIAuJ9pYae5g+0dOygDLTM6pPbH28OdqI7KJBg9cMY6GvCrwRGSvuZNzHeFdv4/Y6SWM7YBQOxXGfQ3QiGdweJ3nyFfcJJvT5lgHDx6Ak2rYZuukUOLtPgEdWa7CVz6nyKq9PzYnz5o06mpSPhPnsWdkleZDSfWxgqSmSFCJ2fT5jVyg4b9kE6RS4sxdoEVbGwu0Ig8MOq4aITwYIZgtN3hBNTPreC3z/ms5lHoBPWZTjF8caVY3aO+nG8flTIasFqxyDoZ/JoWceBO+jD7bahvT0XKjhfiI1azyz4Un2w2kbZ6pDMSSAMO5sONp/oTRTkZh12bB+LTg7ZNK55rB2XnQMHCE0tvWcEbOnpfQMDLcXqx9tMtdsvYU5QyPwGvtVW22UVx0wO9OAPR29HkS2w/7Me6gbVWDveFMIrMJ3xiY1ikjy/iinx6Li79JUbnxtMDZtCaAMWrRaGYxBe+BYMdlNIFg5v3fFeElU5Ua6ZM3wiAqvt/Mq7M2ra3gE3lVleICQOTOj4SF7xBlFCvTG4RfzvnLZs3K6FJ7+jLn7gw2/
 tsSnceNb
 YePBY/5FtOjTPIw4Q12w2GA5xnkJe0b7hRK9rJEJdqiDGe2wLbDfN8HDLnc7fVTjOaFFLrW6oXkY1/oEVzsXYAjR6eNtsCEEma9w6bkGGKOBbPhsBlfeKbXG8Z6EQyodRAK/K5uK/DdFoTEX/52TAecBvGKvNHu42II3yvfBUqRZ1KVGZU0/mX+80Jzy5RiBaC7aivwOu2Ci1p2wLoSMd/Buhb2+4jdvi50X8lb8yfiI4p/6h3dRPUwmLvJLdV9LrgVEtV9JVBeFQJoKXVuzwCL5/iagUq5Ie91RSjl+bokHJ9Ody8CPEpqC/ef9n2hAMsnfl1Vt48ysVhXzJZR+wlla//o8VQ/nBOfCRiMJTFV1Xm43ub+m2xVu6kk2xjIrCbju/dUnsCugeuA2Dv/vx3d/OJSYW8Yu1va5iCapm3KvDlBwKqpGGR2h9ca0zdky3ER2r37l86L3uVHyYwzsmOIlFelz9EsqWpn3+Wf6/wPHD0uWY4YNw15E/BFTsCVKrOxYG5L5PAvLNKhlK1BPnGAoCU27tZ1pHIX5+CmgqwNkdckVxmqL0WPuGkPSseOcnMSrQIv+ygQM5Iu2VNwMLnvFGisHP+UFaFbWVhnzs9EXG9UoJtADl9cPPKnL7QsxCdZ3CNaFMbFNTnCRMluqmTh+KZKv+XSecPC9mCzRK132IcfAdQnknb5m0lDnu7C9XIe9UvXHPW0CkdYvbNoyipI0EeJQ9Lg0unDT+KG1mSeZMBdTB/HafbGIpiut4AW/jfViAaQsw6bMw6iKsw0YD3AE7W/xZOHon2/A13sgD6fkIrTFtuYhvjjjLUzNFIw21KU2Gt2s2foR+aQKfR24LhacEQkCKLrWP3jxPlB4/cPQO8O5ZpdAvhWIe+zSx5gH7H5AcVOq/7uQoEW2eAh2Jw0RuKPyTEHAqzjcpKxAXDbYmFJhEDh5yuk1YjnBgMyEHWg/C2VKULqz0uHT/n6Jd3/ZulQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is needed to inline these helpers into Rust code.

Reviewed-by: Boqun Feng <boqun.feng@gmail.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Tamir Duberstein <tamird@gmail.com>
Cc: Andreas Hindborg <a.hindborg@kernel.org>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org
---
 rust/helpers/xarray.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/rust/helpers/xarray.c b/rust/helpers/xarray.c
index 60b299f11451d2c4a75e50e25dec4dac13f143f4..08979b3043410ff89d2adc0b2597825115c5100f 100644
--- a/rust/helpers/xarray.c
+++ b/rust/helpers/xarray.c
@@ -2,27 +2,27 @@
 
 #include <linux/xarray.h>
 
-int rust_helper_xa_err(void *entry)
+__rust_helper int rust_helper_xa_err(void *entry)
 {
 	return xa_err(entry);
 }
 
-void rust_helper_xa_init_flags(struct xarray *xa, gfp_t flags)
+__rust_helper void rust_helper_xa_init_flags(struct xarray *xa, gfp_t flags)
 {
 	return xa_init_flags(xa, flags);
 }
 
-int rust_helper_xa_trylock(struct xarray *xa)
+__rust_helper int rust_helper_xa_trylock(struct xarray *xa)
 {
 	return xa_trylock(xa);
 }
 
-void rust_helper_xa_lock(struct xarray *xa)
+__rust_helper void rust_helper_xa_lock(struct xarray *xa)
 {
 	return xa_lock(xa);
 }
 
-void rust_helper_xa_unlock(struct xarray *xa)
+__rust_helper void rust_helper_xa_unlock(struct xarray *xa)
 {
 	return xa_unlock(xa);
 }

-- 
2.52.0.351.gbe84eed79e-goog


