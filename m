Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5345BC43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 00:11:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC4556B0005; Sat, 27 Jun 2026 20:11:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C74BB6B0088; Sat, 27 Jun 2026 20:11:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B65866B008A; Sat, 27 Jun 2026 20:11:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8BD586B0005
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 20:11:22 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F33EB1402DA
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 00:11:21 +0000 (UTC)
X-FDA: 84927391962.27.769864C
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf11.hostedemail.com (Postfix) with ESMTP id 44EFF40006
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 00:11:20 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="G85OU/xu";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3pmZAagkKCM0CtAD6Bt0Dz77z4x.v75416DG-553Etv3.7Az@flex--tarunsahu.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3pmZAagkKCM0CtAD6Bt0Dz77z4x.v75416DG-553Etv3.7Az@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782605480;
	b=RYjL13iIPWXPbWIM2xt6Bk+fMy5dAxHZOyXtkRg76KJKxXWuZFK+x2msv2PXh4ywo9/RMG
	i2GDDhWImTPcsP5rZz5Ubx+W4kXGJNcPknCJ892Z6LetPJYis0a4sLAWsQkdVNhlNMmw16
	lhbPxleB7YIxcr3/4BRVbWiYvGdfry4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782605480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R1hMKkHTx9eCvHpWXu0wJEWn2SvHnzVGjd97/dJhuHc=;
	b=PI0xiNGrw3dx5FHOl6yw4rcVYp5EwGqYvsmKevRMOxFb9XQJ4ahLxU3fbiMbDv5LK1X2WX
	/LlIavLha3A5bUZQ1/IrnfJVNC2JeVx1j2EJs5Hd6o18rWt3oz7ubhlr5gNTK1Rhp5illu
	ouXRZ6FuQzOHUTd8dLYjT582sqFch3Q=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="G85OU/xu";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3pmZAagkKCM0CtAD6Bt0Dz77z4x.v75416DG-553Etv3.7Az@flex--tarunsahu.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3pmZAagkKCM0CtAD6Bt0Dz77z4x.v75416DG-553Etv3.7Az@flex--tarunsahu.bounces.google.com
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-69842d5e6bdso448095a12.3
        for <linux-mm@kvack.org>; Sat, 27 Jun 2026 17:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782605479; x=1783210279; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=R1hMKkHTx9eCvHpWXu0wJEWn2SvHnzVGjd97/dJhuHc=;
        b=G85OU/xuEL6KMqRB7Aoey7JM47zID9D3aDLR4Ut8pgSYIa2ofeDJanK/eV4xBuW8G0
         TvxkAUI0S4gP3Sfmz924pQktzQkA+8iBvu5938nnL91wplcqrHxGjCNFORJWAnTdTB8L
         CMUJqf4HfbcIdVQaYqVfvCj1j5Bf8TeBKUrV42NkOHhfbO/YSC6l04pPgUMz9qu2X+0q
         w1bYkkYkzkyoeVCvfJLJpwIQ0cMUM2ijBPyLe/CiwL53CL3lcb90LmcQscb/Am3U6Eap
         SaNUy5OSQ/5IQmr9c3o7mrVc59nHtZoDvxxisGUUXgFI6+JZqUr+6JrgtcJCZyWsm1wC
         3DZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782605479; x=1783210279;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R1hMKkHTx9eCvHpWXu0wJEWn2SvHnzVGjd97/dJhuHc=;
        b=r66QdJMDI7tOliDlv4NJop4vhmRNKPGfhxcnXGgGVQ7MBHCxfcMfdPe0WxEn8BgIEU
         Ab2s+o+RIADc3WwufQWI0tzw1JcznmjNqegbLIgCqHlSiE0w8P/+Wh+LLkdwF8tGqMt3
         ozEZFy47d4CjyK2ch2zMxUNfpil/jnTxWwkKyx7O8ZVX1hErr6SsOAVeuGngA/ywzlon
         7KbaH4g7Bg8AftJBvc+gdQVhhTwLOG+rqVmbMfAR8W8yW7czfAFpIaC6QmYho/8J4eCx
         Dr9FxTPzzwU3ehK5S58EVCtJ5BKb1+xv2i43MTeEOSm8bcrkv26AFtmcuCnlzEyWYmHz
         i8Zw==
X-Forwarded-Encrypted: i=1; AHgh+RqlbPRUJ5r+F9o3zoDfug7Qyy4Gnuy0aJWVHKHsTFNHkKQh9mLD77+VHGcVnwFixtps13xEE1ND3g==@kvack.org
X-Gm-Message-State: AOJu0YwtTll+dexrnr7ziuAZjlaI8kGOHT2S1NtxMYhlMi2iVyDmlawt
	Gsd90VE/eCpMhp46m2jbeT7oAyS2W+behtoUZUeN5dK+MQxbXzx1gd5YqLe/Hmnq72dHp1FK8/L
	1zpJdWnu0wJqB5EbxfQ==
X-Received: from edbbf28.prod.google.com ([2002:a05:6402:1a5c:b0:698:48be:f3ac])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:3591:b0:698:4831:f9aa with SMTP id 4fb4d7f45d1cf-6984831fc61mr973106a12.12.1782605478597;
 Sat, 27 Jun 2026 17:11:18 -0700 (PDT)
Date: Sun, 28 Jun 2026 00:11:13 +0000
In-Reply-To: <20260628001114.1869564-1-tarunsahu@google.com>
Mime-Version: 1.0
References: <20260628001114.1869564-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260628001114.1869564-3-tarunsahu@google.com>
Subject: [PATCH v6 2/3] kho: add KHOSER_COPY_PTR to allow phys copy of
 serialized ptr
From: Tarun Sahu <tarunsahu@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, skhawaja@google.com
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 44EFF40006
X-Rspam-User: 
X-Stat-Signature: icwso6fyeyc8nnoxqpony535axfqgmwf
X-HE-Tag: 1782605480-467847
X-HE-Meta: U2FsdGVkX1+A6hSwj2xzo8ifZ2+/ek/POdnQwvReurGsTSxu73RTuenuwJTdZOOQcM6reuiXC4Yd61+nPggQoJtVIzj5ZR0uybdt67Se6GOG0kEIuCX17LKyFU8QuTMLFueSMwq6l6VATuFndjoRHJErGaWqTkVlY7GwkIrfe8sDc5DePpHCvoWy3GHuoQ1/iUKmiyKQm6cbgH7690aKLoXwBUsB1DePllzFpg8llmiS/n7uHRQjxGUuUCTKSauJeM5L0wpHhhBuSw29h45oDEc0hiZ+Il+8uO0arLNbmSKogEBtYJnHImVZfb73/8t49r0F01g18EJxr1IOTi8rEBZnt2KnlhWwQEVUaYM9a4bgjTsUSctRRl+VwEwKacMD02yKoN3gVcq7FNyxe2fuDXZN3Qwb5TIGIZ2fx694CW75nQthlZsGAk5OJIe9ilAKyQB1w5NssCeWb8n++Dty7tAbfPCRhSuEsLh+dbxxcurPA3oKMHml9Jf2azkah03d3UjIwgfmKmhLQxQoPZoH2cKLezQmpG1HWLqzMgPsvUWNuWiEx/j6z/2jtbwXAWt30cPP9ICUvnxtga1uBBehzrdqGWmLG2iinNnHXOrDiqmPbIcY4kbOZag3PEfvZY325dSzpqsal4Y1NHCzMN4p1MpQJb2HJdgheZ8NJbFf2as0b/eZSPI8O00+6hmcUmup9XSwa9buV60jQO80ZOWW58QvMe530i4cWvmUDcmtqd8XLcVwMv1FtVIiaeW8r5WMuM9Lz/2JN+tn8kGRUTTE/OaK8aTlMpWWSpPJ0hdzgbLJk4/Gp+MkewOJDsltaquymEC/kfyLkxzkmLdZLv5P3LXgcBf6fZ7G2t0ESYGVAmSQ+RkB5joNcAneS7IQjYhmrnmikYTEipKYpgYZJaLDNL5z7xFDSJA2d+0meuItyt3gXmbMi+YZFkwhuN4UB0YDDnXWJ3AJxrz9q1ZC7DO
 4JQyAs/X
 mCXNDCGYrzbL+1xhLwkGf/WXRG2MEB9e8tKRoiAZue+V01N1bxcw9fiWtPHaOFEaI9758uG3v7EDzgsNq4KrlpXhNpbgbLvMPwsJ2DTjnszB0gB8DVRmwc5ggJtONUUaeF16ZsR4jLW1fk+jmP1Ptx9C9/znSWhs2WooEGB6GgGKFfO0W83EEVvINz3e2fPswASFDY7bR1b/rFMeV3lXOV7BDWIoHEvE4YMntq5NP2Di2bHGhNDqHYoKAyW9N6h0CB4dnlv2hh2es4iKdEbX/X8Np4F4gY7tZoFGVRHwnKlBk4lAh0uJUocPBQ+bxfKcoHxZ/EkxyKQJIUbwkZNC7vrJsA2LqzYbhNNKpaT2LaCr5ozMx66lP5OkXFTw0mCEaQLRRFvKf24001tNpXTnkWxvVz+5Jx+AVZkzIKHqKAZfrDarg5LnqtkOckyfPYO7kY++HzgB4/bunFz42DQDaJSOS079mDMONXBMHUKS/U8RfTSh63eqTeJZ+VcqhW3C7EbJBchAiC+Y54CJ9ouwtmlUvnBtjN0TmV00fTttgbQpnl7pFTaeeNY+sAeEhKClnus8OdiNRjtokxr4qO15k2l9q9Vu6R6rH9YqKjzS+iw5E0ezdgmjriyN8a1nc+GgczpK6qWcDZJDz/CZCzbr/7RD3a0qOQNBNTQa7SRLN3AJwoFts6bDcWpu9TkjeYcgGZhxW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Adding KHOSER_COPY_PTR to copy one serializeable pointer to
another. It basically allows copy of phys val of the
serializeable pointer.

It ignores the typecheck if any of the argument is of void *

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/kho/abi/kexec_handover.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi/kexec_handover.h
index 5e2eb8519bda..a5a518e881fd 100644
--- a/include/linux/kho/abi/kexec_handover.h
+++ b/include/linux/kho/abi/kexec_handover.h
@@ -139,6 +139,17 @@
 		(typeof((s).ptr))((s).phys ? phys_to_virt((s).phys) : NULL); \
 	})
 
+#define KHOSER_COPY_PTR(dest, src)							  \
+	({										  \
+		static_assert(								  \
+			__builtin_types_compatible_p(typeof(dest.ptr), typeof(src.ptr)) ||\
+			__builtin_types_compatible_p(typeof(dest.ptr), void *) ||	  \
+			__builtin_types_compatible_p(typeof(src.ptr), void *),		  \
+			"pointer type mismatch in KHOSER_COPY_PTR"			  \
+		);									  \
+		(dest).phys = (src).phys;						  \
+	})
+
 /*
  * This header is embedded at the beginning of each `kho_vmalloc_chunk`
  * and contains a pointer to the next chunk in the linked list,
-- 
2.55.0.rc0.799.gd6f94ed593-goog


