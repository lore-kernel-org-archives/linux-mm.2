Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6290CD6E45
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 08:55:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D45E96B008A; Fri, 29 May 2026 04:55:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF6CA6B008C; Fri, 29 May 2026 04:55:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE5D46B0092; Fri, 29 May 2026 04:55:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AB9726B008A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 04:55:41 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4E6CAC3DE2
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:55:41 +0000 (UTC)
X-FDA: 84819849282.21.BBBE046
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf03.hostedemail.com (Postfix) with ESMTP id 787C520008
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:55:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XAivuMiX;
	spf=pass (imf03.hostedemail.com: domain of nakamura.shuta@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=nakamura.shuta@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780044939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=JB/AJdGnqIf/Ml4hT7r5UXyiGQNpweafn+GD5Bd5gsc=;
	b=q/6Jh46heyAGB9A5dNqzqJSLPETALwRk9ev/irN45tkHt5O6zZK3s2TKKYHu0CHGLmJ8e3
	nfv/Y588bbSbL+wCuFoTj6uxWlKxnpDCfSP8jccm8RKjmVYfXrQ78gOhAt03Gxo2EUUcbx
	Ofa1MXNrkvM4pOUsB8IVpEjKJ9JA4to=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XAivuMiX;
	spf=pass (imf03.hostedemail.com: domain of nakamura.shuta@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=nakamura.shuta@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780044939; a=rsa-sha256;
	cv=none;
	b=3S3OhlhhvV1BXpA/M6QnxOVRC7UGN2Dr9732A15N26po1+kmNgnHAkNE8uT5WUNuTn1wVp
	2TVVfOIIn6Rx9PeZ6gD9GedindOOs5uU6ZvV3r49f489+sTJCj2EVnqLm6jYs7KbGYz19X
	8ZwyPlp9A59D9vQPoXHSkFsLK/StIhw=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-368f25ff4c4so7911769a91.2
        for <linux-mm@kvack.org>; Fri, 29 May 2026 01:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780044938; x=1780649738; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JB/AJdGnqIf/Ml4hT7r5UXyiGQNpweafn+GD5Bd5gsc=;
        b=XAivuMiXIbxPpfQgvDMgC1g3DXfUCpzz3v14nn62IvAmE1PAsY5+ozeBPT3FCgSs9Z
         JQGpQVwGDd2OfptTymfWGretgD3DzqoX0ZnDBKHFTmZrsA+jIkKxafU999wb4Km3niaV
         aGmpby6AspRA7Idqf1k65EfVCW3oP51v+8ukc4vbljOS4ZL0dTIufNIn2b+3TwdKQ+sp
         +my5cMX9Lpj4/Zia/H0ZUDrsGQw5kG/sZBY6xxdINEJ3FSvjY2WEWD34Nfn2Eyfrb5aK
         dUrqWuU5gSrLmkRxFOJpLmGDaDSZ7IQRdIl2h7K4bKM2iQBEHlGBQdMZ6ad2U9PRxkQc
         Bd+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780044938; x=1780649738;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JB/AJdGnqIf/Ml4hT7r5UXyiGQNpweafn+GD5Bd5gsc=;
        b=flNbnvxDYPf+8ot4bdWWZ0vbBNDq/wpPen06NNvce58NYxj3RUbCQOaP+ZCR+nm9Q/
         114vO8SYj1Rvt84O/Bg9sAuRLgKC7BvbFx4xxDsnlNCbe1wn297D/sJpOPMxLDQ0UbCN
         M/eAPt22B8Cgs+3pBwz0Yqx/uiFKaAEMGl/O8ldUnXGYCJAshbDoW04OEBOT+dAHNksa
         iNtEA2g9QivOtQmH2HWsD/MYG1+4aSaf5Bh+iJpS3tPuh8WTezFhBbQBMmQOGh6//44P
         qTX7nOv8YVKk0TlIDXPh5YxfBYbOocaneMhjuMSRLKn56zsAVzGtEsfn+qB9P0cj2Twm
         HVTQ==
X-Forwarded-Encrypted: i=1; AFNElJ+ZiYqSoYnMDJG4Uwvj03sTV5Y2jVW9HnFb0tp3q7WXqcnR6KOF1ajLykLb8YYB95e9A70KIPQX1Q==@kvack.org
X-Gm-Message-State: AOJu0YyTU2zfi10L9FamWrhE97c3iuSG+d5sp2PeJLrAjOF1DJ9//bXi
	0GfvHtwNG332dH+NxNMYGqz3leMHO/RgiLhwrkaZJk6YoHITLszT0uyo
X-Gm-Gg: Acq92OG1V4g9PihlmAIikGow47igpXm461womy34yK05Rcj1L92qRqHZT2DlYgrLAu7
	ewT4HN1ce0ikYIrvb8nqlZPL8RmbVsxT4EJYHikUoGamYHEcmv/TcrZEctFjEQubsqnILukD+jI
	bfIrxmn3RcM5LlA5mPNYOteFgCt7aLtGLoZtKTLRCuPtwfJUZbPCZ68rHaO+DnDsjorslgKhxg0
	wsIYyyIlffWPFVAwpBh6QbH+1bvXJYDgnSTK7JUgWcXAZ3MymXPfXYP72zkGIRDXMSoqjvf4R5p
	20Ptb6mcxMKXz+VYB9zJLUPoAwittWESxZmZi8xNW6tSZ20beT+Y2LRHgDLTE7u5iQW9LkJUuSp
	Ah4vKHbykL2u3cyUBkHReMDjbtVLfu39pLTNfBmxK2P4F0FPM/RT2asq4gaD8BGwax8INK2XE0n
	gkCjvMae32P7SCa/UTTZNmhu9dDh3v2ttlPkJQO6ygcJ3QjftY/AmyaGAQkb0NaMkFhuUEJqpuh
	oNdius=
X-Received: by 2002:a17:903:4765:b0:2bf:2243:d4ee with SMTP id d9443c01a7336-2bf2243d83dmr26285365ad.18.1780044938035;
        Fri, 29 May 2026 01:55:38 -0700 (PDT)
Received: from ubuntu (softbank060152129044.bbtec.net. [60.152.129.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bf239e7019sm12732315ad.11.2026.05.29.01.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 01:55:37 -0700 (PDT)
From: Nakamura Shuta <nakamura.shuta@gmail.com>
To: Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	rust-for-linux@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Nakamura Shuta <nakamura.shuta@gmail.com>
Subject: [PATCH] rust: page: mark Page::nid as inline
Date: Fri, 29 May 2026 17:53:16 +0900
Message-ID: <20260529085316.27432-1-nakamura.shuta@gmail.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1agb87amugo7tjhe5f14zky9psix7uh9
X-Rspamd-Queue-Id: 787C520008
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780044939-140284
X-HE-Meta: U2FsdGVkX19bz+5qZJvnPKLbwoklyhNzkU32BagNEUshgX/Dbsc0PVJwCK6X3b/P1GXwKqvA+m7+acZQAlus9q8CGfHf66nIMmXLd9S0RTdU3OJLXMoSZUX63j5sE0XZZ8kwgjAPeQOGp5E83PGkll8nqtybbV9MChPtsuUDIymYpIo4Imqt5Vq2C+3ZQ9aGv68yuShkvvbPrJsfV46sRVucgm0uRfgtIhFYNCRnfHVLfx3wFsypqy7jcBFGm7TOA3O54LemsLXQZpLrXkANl2B0PQGXtqT09aLtUY8sTfh7nfVefZmfMD8PXntbckYR56ul3SpvociTLSmJmzWXXHoVTCn9hC3sj+e5hnAOKftqVd5N5YguRQ0Rk97Uk+/QUYkfgiUhJ5meNQzell5vfd8+6xMEZBsYU4ZdPPfqSxG2HskxOheIkIxefJSOAK55a2BsxK751IKPwJ1cfSe6xKoEz+omUd5OmHe1ADyPvWiVhNN0UqjZogV4bls3ecAHwhdUCDsYtz+bBd/Re2o+7wm7u/7MPfX5zYHkG8Yr8uFVr6Crf2IlCiKI8wYrW0V+XtY0VWpuFuvMb4B8DnoadBqBu8AtRFa0iDaDoqInQCF9fnA/aex3Tvg0XBZ2dcn/ioUY2ETL/c5ZhFrdGyRp6wyKin1sUtGtHbza+SS/Pk1klMQcesJSSdZ2jPe5pO0URlH37GdFFrW6rRwqvI1FlGeC3Mo+hPNXG4d7pNvryZeUy3UA0P70vMd/eP+d0XB/dgV658ULLngm3klxzlT19jy51HnXPwfhPWaMsZGhCEhvMR0ak4CHzooTVHwWS8b/L9P29pKcQAg15Gp+2XjL4Ggumd0dOYdTCl2qsflJob6Bc8uUqhj4UnbM5oCoZ7MYHsH5aqTxKUKP/9Ioop0CAKfs/iU4ZeOeH5+4RANji5jTUHySYMI+Cy4Q5kPj82acEvB4NcpI7X4YMML3+XZ
 MbwcFxhV
 AEqAvDp6iSIayluieTji4bvvvd0ESGVszoi2wuMk6wlRA0NV+PazP6bXnnk0Bql4Vw+t5UQSyXqTPqDrzOSJxqTl1REknQ2BTj/FfkZF8ulMq/UxHIWw7wk/zfatTs/UdgofgNgSl88GcgYMfJTkSfpAKvAewnmGAd3h4KVT7vM+qe8IXANnG4VdyYivAu0g1RA2RJw6EBEJ+ke0/zBFc0bjsbkSpMsuU+1BfaCfQ1niDoCYtwueHnvCd9aVP6lNMSzDZMIR78VjdufB5CeB+QxOhWsp9jFXY37Ef89IIbC02AfYUOnG3Kvz4U77zEe9jKICYz6q0+Hl23vUIezJTgkmQ0IqKE4ybDc4S6ZyDQqgY7n7/6Tdr/Zr5CPz5NCsFzAJjP4F0Rmk5X3MX/QPR73n5SZe1IXbZEapSgvnR7hHqDPuIpry8T040DPDxsEzgMfYuvQcRGUFtbujkrQTSzOXcL2fBGwVvtkqt31uMOrXNa45MX5d/dbcQ+/0ALy5sej8p0xAGwskia+onsMmyYtY0ZUEkA7e8lPg8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When building the kernel, the following Rust symbol is generated:

  $ nm vmlinux | grep ' _R'.*Page | rustfilt
  <kernel::page::Page>::nid

`Page::nid` is a trivial wrapper around the C function `page_to_nid`.
It does not make sense to go through a trivial wrapper for this function,
so mark it inline.

This follows commit 878620c5a93a ("rust: page: optimize rust symbol
generation for Page"), which did the same for `alloc_page` and `drop`.

Link: https://github.com/Rust-for-Linux/linux/issues/1145
Signed-off-by: Nakamura Shuta <nakamura.shuta@gmail.com>
---
 rust/kernel/page.rs | 1 +
 1 file changed, 1 insertion(+)

diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
index adecb200c654..764bb5acc90a 100644
--- a/rust/kernel/page.rs
+++ b/rust/kernel/page.rs
@@ -193,6 +193,7 @@ pub fn as_ptr(&self) -> *mut bindings::page {
     }
 
     /// Get the node id containing this page.
+    #[inline]
     pub fn nid(&self) -> i32 {
         // SAFETY: Always safe to call with a valid page.
         unsafe { bindings::page_to_nid(self.as_ptr()) }

base-commit: 72d33b8bfeacbfdccf2cda4650e8e002def036f8
-- 
2.51.0


