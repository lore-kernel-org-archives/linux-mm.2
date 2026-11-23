Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3E00606A69A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 23:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=cYZzH/v8
Received: by kanga.kvack.org (Postfix)
	id 463356B05B2; Mon, 23 Nov 2026 18:39:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3ED636B05B3; Mon, 23 Nov 2026 18:39:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FED06B05B4; Mon, 23 Nov 2026 18:39:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F0C9F6B05B2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:39:33 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 60C7D80A34
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 23:39:33 +0000 (UTC)
X-FDA: 85468003026.22.3D0E55C
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9F74C40002
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 23:39:31 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="cYZzH/v8";
	spf=pass (imf01.hostedemail.com: domain of 3ss4EawgKCMEkth0shjrnvvnsl.jvtspu14-ttr2hjr.vyn@flex--dmatlack.bounces.google.com designates 209.85.167.198 as permitted sender) smtp.mailfrom=3ss4EawgKCMEkth0shjrnvvnsl.jvtspu14-ttr2hjr.vyn@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795477171;
	b=vcH5eH7skPzUgjR+nf9Sk95r4lc19qvAyD1TaBXKw1+97fSxv/OWLivLSU2JnaW467VtTE
	s+YSfQ0XA1Jk/0GPP+ie4owwZuYnbiFeBoNAypo2ARTSs5qOLgyopiNXuTd3FPlzac7YiZ
	8Fh88BHli+mnrdsz95uyRkKkexwc/zU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795477171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NNY7sb7Lc3fUr2Yc/4c0jbyfUC5yRtKrBOqqupJLhM4=;
	b=ZssqYRwFAH6Py+faX45H2SVqFUNc8UdPpqx6FZ2rquTfE/3IAEVXbyQMNB4TW/eP1JcOlG
	75xwqjFBh63fGm+yMQKxElv9iM7GfiWSU5h2HsgrJPVkPZKnkFmRsqnk6H7pRcDt6B16It
	9SaH1jKiFJ5baqpACa8wCzWswzHhVxI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="cYZzH/v8";
	spf=pass (imf01.hostedemail.com: domain of 3ss4EawgKCMEkth0shjrnvvnsl.jvtspu14-ttr2hjr.vyn@flex--dmatlack.bounces.google.com designates 209.85.167.198 as permitted sender) smtp.mailfrom=3ss4EawgKCMEkth0shjrnvvnsl.jvtspu14-ttr2hjr.vyn@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4dc57e2a3f2so5081705b6e.0
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:39:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795477171; x=1796081971; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NNY7sb7Lc3fUr2Yc/4c0jbyfUC5yRtKrBOqqupJLhM4=;
        b=cYZzH/v8oJoRB4JupOS58NhyFM7Lu4us5TZ3qgiRy8BFOXg/imDO1d4sRJ39CVE7CP
         U/QdSKxcYCUG0clkNadWbQ5ObxEuU3ofmRwgwGm8bl7jxpG+jeV+YeReca/u01dve5Rt
         I3M5QZxcASUI/FDpWQTjcJYQzA16L6cvf70Q2UaUkzfXr93bLALmhZfB8GnbpKeRpowh
         6aztDz2fDa11YaJM48l28kRukA+61nx1Hhjc6W4De7BhCI9e1kdj6BjQNyRaiGQEy9Bn
         DRp7+/8ub6wfWeRNFFmZvMFNIeGm6MLDJ2FGKCTOKT7uhHD7pNslrw65NsC7bwNQ1E8p
         2M3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795477171; x=1796081971;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NNY7sb7Lc3fUr2Yc/4c0jbyfUC5yRtKrBOqqupJLhM4=;
        b=xkKZjaAQCL3S7259+IQweZnH/LQoqELITlq2xkD43D1ado1fG4Xosxz8X/kBf/153T
         +4Y15Zqh27590uOwd+fNbGEB9lU1xMvJ5u2h1gFaR8/3g2y+J5gaEIvCynQzUbbZ9GhZ
         bJtlW8n5d3mBNkKcgl2x/pLqHfZ1hchcZI1MTf2cD53c7b8EmfI1/n65pYT3zSIYAik+
         aDHmaUV/em/VQvNguv6zhXG6LGyK9Ho3WAW+YfnFXFOZFd07iLNcOL8K89R6vj6C8Oe9
         t0rsm7olzyuWmPCFalzE2wO08XUiwZDWA/e/mwtHDugbyLpdLVxyop2dj5wKnN8PxNYK
         Lzpg==
X-Forwarded-Encrypted: i=1; AL+hErGLDWDEUHKtFOd/geW/aN1uF76CbMHM9Gs+KOKoPLKU/9z3uPih/tVbWVm0jz5CFgtjGuRztowydw==@kvack.org
X-Gm-Message-State: APuU4Z9XNQmcpOKsvhj+Bynpb6lW9AHkJWOeyxspSH31bJHhO28w61A6
	3j9lJ3/9AsgMW/0IjB9L+drZs3CUghdWKZFWf9LaE0KgS9zJerTxBQ7Uhn7fdCkQ4/z2DSYgZLW
	hxsCayDhg0CWlVg==
X-Received: from iobdo25.prod.google.com ([2002:a05:6602:4619:b0:9ca:bcca:dd8b])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:6615:b0:573:1dfa:f0cf with SMTP id 5614622812f47-57a0a404865mr13656920b6e.51.1795477170400;
 Mon, 23 Nov 2026 15:39:30 -0800 (PST)
Date: Mon, 23 Nov 2026 23:39:06 +0000
In-Reply-To: <20261123233924.3970932-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261123233924.3970932-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261123233924.3970932-2-dmatlack@google.com>
Subject: [PATCH v5 01/18] liveupdate: Remove the list of steps from
 luo_preserve_file()'s comment
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org
Cc: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9F74C40002
X-Stat-Signature: g8u3r63idepnqwkw6o9ciwaby3x8yyg7
X-Rspam-User:
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795477171-210827
X-HE-Meta: U2FsdGVkX18aIO4mzQ9H4xzCntV4osjnm90K3CxO2LRVgHLTX9yH+By7udq3OHt6iyNKaiOLJVp3iep/vGgSP6UZkD0lbKiuGNHjlUmaXgu1jN7LD0gEjCJEhCmvV2+gjqpfsXbmSrz8/IiTE0NyTy8oDZgWZwnbujTvN/JUvKXcu8GIrq1N0FFzYXTuaEbXb7kFr5p9hi1k1C/Hb3ejHE0o5HvSTuSbSZjbZzlz8I4weuOMuOHOqCwAnAzpIfN/KYLJYkL4bu0FvPT2iJR7z+aKMIAppJuFwsmFkpVVWYPP6FQCFH/IDh9T4YTurPk0QChABCq+DxIhrRcOtJcFHMNerROUKRy3SR4ZbEaMUJXLjqgX/cYdOCfYJcsReqHpP48GCAB8yY+dJYZSVYUCsTntDpVQgdIcXUP93ZFBn5U74UI2VY0SYSVFyCzsUznYn61OVOZBxHFUfBy/Y3YG579B9osP2o1y9XLs75zqSuh8XIXJoc5GjZ7yUGl+3ygv9wrpvgWIQrFOxoE3h5OT/4C+i2wHJc28TNk9xMtS00OJOwwrXKeNpYenDuYa0N40/R8RSFQvjoJ9oA177mXClcZuzpZcSEl6ASQHJiXIpLb2j3LRlVxXZS+dspWmeHNKITO9LoaodCYQaXEomweil12bYioB8E/KsoVjPJ8XNziFoMlA/uKBXaWGnHzDz3R2lw9SA/iMx9Ov87gilsPRbfg+yBE6tCOYvuRzO08nycHJJDHmhfKNNXOadlkF/WzekqgpwMSS46ch7hRpfTkDrU0Uc6TMtZPuOjdD0pxiaWuZNLbrXPlRdRoAYvOlVNoSu43rFG78kGkpzCu7eEbrmUMev3rAH7xW5/ywdwPQg65O247sMw7AlXI1x+kSdoIEf1552TVswaY7qtt2VCavgOmDR5bAM8ozUzj8Pj/Ticdl1eBE6Mqckqkdil/SSYwNvF3zdNMceOLtHOPD5ZP
 1ECVmCtI
 jwGHPYtSqAUdKaZJEnCBY9zJ4+lDQlQnOSvMRIbtm92N8bOP2nnTQXXrG/Rwv+5iQvz0SmRZEid3XkxHQMMJrPd3kJJuS58ogEOwqeRTHvR+VcY2MMWX5ymPCQHa95d1lRq7ABCfHjQunAeSxf1118nHA5tgsGwqlK+6yvqLbmfaI7NRp0Efhm8Uic6CoWnk3COUeZJWU9oOKBkCj1ZhjEMXhyVJLDtrTkSv9MCWPe2SWRv5J2cOLgVwC0xArj/uY/sPL7XpVZyNI4cFaS0woUmDlbmV0+SsSAXXONWAJ8zTOagnCXaS1qDaJYbq7pICyLhZI+JLVpXRh5z19/dENY+hZ2PTkO8S1t0YBiB9/dRlX/jUV8HzcGBWe9ykVcyibBsP6YJGMLQyPumluwnk2o5/Xru+8DDI+h+hLYrOUiQ1cAKrq+Zh10l5UWm0NcryEuiLMFjwlCnsNmv+UwFRFTfrNll9tkxFQ2S0BHZx+5NKH9hQetOzhfTAoF8XQxwBcRoAivEVdbUvGduEjL339Te6fXFWsluJBF9vNFYr36/9bDNB57Iyp6Dwj4shtJn67uTeOZ1xGQhEaTm+KR6zkG2x2skn/4ZCqXI6EV9Bi67serj9j5wQ7ODJaPZEb9upLlS2JQ9CWRTlqqC21jtePbG1p9yrDk/CkO6NA1+aIVgSqauAA/04+0BSNDDgbduvYzNxmaxZTpBYFvZo/dETAT+ezd0fFv1st5gahhLtBqPpCdSNeSBvBN0EXKtBSNEOf1uVyzR+VOtRpyvarJmM9OWSV9r3wlyMfhymdYB3pjgXAzCmljU7Suu7PgSm5oVg5JIdRNBq7jPALAVnwewPBQ1b5dW9+jVGUWdj+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Remove the numbered list of steps from the kernel-doc comment of
luo_preserve_file(), along with the sentence that introduces it, which
repeats the first sentence of the previous paragraph.

The list only restates what the code does, and goes stale whenever the
code changes.

Suggested-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Signed-off-by: David Matlack <dmatlack@google.com>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 kernel/liveupdate/luo_file.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index a39992da504f..a42b60356d52 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -214,18 +214,6 @@ static bool luo_token_is_used(struct luo_file_set *file_set, u64 token)
  * unpreserved or successfully finished in the next kernel, preventing the file
  * from being prematurely destroyed.
  *
- * This function orchestrates the first phase of preserving a file. It performs
- * the following steps:
- *
- * 1. Validates that the @token is not already in use within the file_set.
- * 2. Ensures the file_set's memory for files serialization is allocated
- *    (allocates if needed).
- * 3. Iterates through registered handlers, calling can_preserve() to find one
- *    compatible with the given @fd.
- * 4. Calls the handler's .preserve() operation, which saves the file's state
- *    and returns an opaque private data handle.
- * 5. Adds the new instance to the file_set's internal list.
- *
  * On success, LUO takes a reference to the 'struct file' and considers it
  * under its management until it is unpreserved or finished.
  *
-- 
2.56.1.809.ga0b61035b5-goog


