Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C176FD8770
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 14:15:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4D546B0005; Tue, 17 Mar 2026 10:15:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E25196B00B3; Tue, 17 Mar 2026 10:15:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3B3B6B00B4; Tue, 17 Mar 2026 10:15:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BFE7D6B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 10:15:44 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 91E46139E18
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:15:44 +0000 (UTC)
X-FDA: 84555753408.22.78B1CA6
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf05.hostedemail.com (Postfix) with ESMTP id D0BC7100010
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:15:42 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="pd/jSNlA";
	spf=pass (imf05.hostedemail.com: domain of 3DGK5aQoKCAsxnwl0ty3vtrzzrwp.nzxwty58-xxv6lnv.z2r@flex--mclapinski.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3DGK5aQoKCAsxnwl0ty3vtrzzrwp.nzxwty58-xxv6lnv.z2r@flex--mclapinski.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773756942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Lm1/04AucX09o7Vc1s8OzOzNp6FWCOos1z+TBuLIodY=;
	b=23D2tnN+lvIyvmcH/fnm+Y77DvNtULhk1YxeMz/9ulNy4iS82MBN39tR+uoND7RYzWTTBy
	dj3iGZg1fJAB21+UGPCm5Vd/YOUG1Nof/QoJioGtMlOvaC4dHkD68oeHwvDoTJYPaxuu1V
	3d7Jbmi1d4JapFAcuc9MsPSIAjeK2Ew=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="pd/jSNlA";
	spf=pass (imf05.hostedemail.com: domain of 3DGK5aQoKCAsxnwl0ty3vtrzzrwp.nzxwty58-xxv6lnv.z2r@flex--mclapinski.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3DGK5aQoKCAsxnwl0ty3vtrzzrwp.nzxwty58-xxv6lnv.z2r@flex--mclapinski.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773756942; a=rsa-sha256;
	cv=none;
	b=qVL5xABB5BxIWEYxKzV4tFCGrz9QERtgqs8b6a7I0cyar+Sin+sBX9tuTy1gA8IOKp/H42
	DxVtDAJ3jIluYzi5a9I85j9yYcTmPJr5FabcrS1vuIDplzllzTKiysvEzTLXmC47j+Yyay
	l96+0XwY3WpjMahtuOXhTRaR5nY9bbg=
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-662ff83887eso7900961a12.1
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 07:15:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773756941; x=1774361741; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Lm1/04AucX09o7Vc1s8OzOzNp6FWCOos1z+TBuLIodY=;
        b=pd/jSNlA1tLPTLZzyMEYmRVXWrFjhI2Pp3sLcPyLlvtjuf5gTsoHgWc+yG2FmWcyUK
         HXu6pO7BWHkup6ivjcv0yPPl44Zo595w7d0TZlusq1GqtFztrCSZrurzblDLO29AVsfK
         jCxtfGpUJKXkYtPeOL3Sv/IuJy/SaJR/PXsEONJfaYZnBuMMcLPX/h6//bT6NJSPED5X
         uvea5fM8ti2qVyneDNmXZUWGTjoXSmCeFn1wZEqpGYrdNJHpfjvWeKKY5NEscXhNfOkl
         pLaRsZyKvBrVRjm2td3oJLh+vnMWuri4EG77enRJMz/kaMa1bBFlO2odRP0ngdHZTnkl
         ZhKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773756941; x=1774361741;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Lm1/04AucX09o7Vc1s8OzOzNp6FWCOos1z+TBuLIodY=;
        b=sgJ+zDC3M8WNA+RxpDuFK1VpWvt9wDbmqzEkH5xInZ2xsAKSWBzuhh3XH4wptzKfV8
         zIwEAcXHLkQ+TdhlzraGbXor8sSK2adjNCVxS1aIgVoaFpncTjKwCX98FkI7he/UyeBe
         9HB7c5e2zfz3pHYA1XMHZycocRqi8UJ6FUCDu+TWZn/F/FbXp2t78U4yenXvM67IMy4k
         Lvd1iKZjjbtP8Gz9u/sKoNcCNR9LSuquTZfcFHTrPxhK8vQ7dNAshx3z9IzC2v2T+FpP
         39BXKUfNdsPWHH8//M09M52BQurPgbHQ49Jhrnzk52kkW1xYVSwidQwLlsPlmOLaGwkN
         FImg==
X-Forwarded-Encrypted: i=1; AJvYcCU03yTM5DuMWsgAjmoi1zX8B5caExlmafJo2GtEVKqSMawQHSlb+L9WljkpTAtDJQtb+/9PIOCQ4Q==@kvack.org
X-Gm-Message-State: AOJu0YybUi9F6qTYbt5nw7eoHlLrBIR3/lknF0G03nYRlkCR/b78xcbV
	7f0g6Sp0gRRX+JYhnIfuvJP+uK7LFrbGVmUuMO7R4Yrw7wZlppHSYwdWr2e52uWfg8rz7ekU6qk
	054wrYZ+zHnHVL4kA4+k24w==
X-Received: from edya2.prod.google.com ([2002:aa7:cf02:0:b0:667:8c6d:ee30])
 (user=mclapinski job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:2809:b0:662:f12c:257b with SMTP id 4fb4d7f45d1cf-663babc560emr10556033a12.12.1773756940594;
 Tue, 17 Mar 2026 07:15:40 -0700 (PDT)
Date: Tue, 17 Mar 2026 15:15:31 +0100
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
Message-ID: <20260317141534.815634-1-mclapinski@google.com>
Subject: [PATCH v7 0/3] kho: add support for deferred struct page init
From: Michal Clapinski <mclapinski@google.com>
To: Evangelos Petrongonas <epetron@amazon.de>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Michal Clapinski <mclapinski@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D0BC7100010
X-Stat-Signature: poxe5kft4wozzyn9f351t5ogoerf8d7t
X-Rspam-User: 
X-HE-Tag: 1773756942-780814
X-HE-Meta: U2FsdGVkX18Ycq4V7/RzWx5dGFuYi2BagASb+r2Mzckj1oO3gTGc+sWCvUZuIP6XxmZ5IHgN/4SimMJZ1s0UyUrGAxu6TCPs7ELC1JFcqbbF1I3wDLmOgxar1X7h3ZIBSnQ6Ue4D4v8mnfWP0/HFId7ocuL9NBNgXX2OzihM3yyJUU5iUkwK0wvfJLmbSY9gga+7V5mCP9TjaKQDize1UPWXSwyUYv17SNHpwhL1FCrRlr/qtXTbP0RE3qZQ8b+SYtVB1B6ZfQVQWnPSpa8p+CBkWdtuaiNDd7OELbCq/VhmWeTidonnvmYEXFJfsiKl10MtbU1ynrG10xg76Jg1kunff/8W4A9z2Wuzlr9RVeWhwH6PlKje4MPNbtBR7yHK2l8KWhODMj2/Loi5Y7EDsoDbavV9iAmN+jWn4bhbJ2KC4/vlY6BM0XGZPJQKenTY9bJLuQxf81i+OiQypNX3YUdW/P6y6hrsOoereS8MNViuPWvEJQrwxlHafS8/+Yfvcrz2FojKw5JcqEaVXRYOXAs/7lbh9/ozTCVoRfk59z6LBoSnIfKheQmeI3saT3jnEhqFZrE7uTYKpWutqMJgOR4Ag0BsQ2GS0R43BPu2YP9sFIarFnnEOpubbpmYCu+NO+mKLz3xFstfKvvOodoGbtXpsoCqaK/04fi7cNgXOuUgRcEwn1bAXRVxgU+b1/J5K2eBvYrG+MfnnjumzCluDh4AV2lk0TdJ1BlFpJ7q7JBvErgo6FygbbK8RvX/NDkjvRr9sOagzapJRO8Vesg1BSZ826Pqv3Ewto0shUAYmCormA4pXlG/Fk0sq2DG6OxrIshCnWQEn8EM4hETN7zrU95xOpvHigLiKtQhKkDlAtWZp2BUAFNk70j1ONzuiPh3DKIajS0mmH2WELkvCe1Jlv4kIrLqQrXPJOUm/lZVecsY5MtKNLIRzuWib/4F0UcpE/v2cuQMdFY/Ki+RcDI
 GWzlldZL
 fg/4h/rA94ODHnYuSHzWC7RX4tM1yCU9j8LBEoTZZxQFkuRh1Vp5nt7+mTmQ8QKE3WE06S1QdT/Eb4ibN7L27L5hRk7Qpli36Ik2qgo3XwGFem8/XF2Ls0/YU8bQ2NJMhQAM6gV0Hqnfl35v36VQ+i0fDB/bRYs/1Z3RYQx0qQzbxW9fWzktsjZEreLV24TXQjYN8xOcTVOpQYBXemKAbogzEY9MMDYlt2YDcIdEDLbpYpMu5OW3oQZFLfccgDk4GCPP2a2GT2y9xHSs0UwRw+8GG7xqfAfkVEC6RyFTd7XQGHJ/0k+ekzyDOcP+R9YBwR7VsPvEz8GtSkQAzpObt1NDtJLeL8lsDQ9JEsIZJClfNulQ6QLz4YDuXLek5tBjZJh1s/Xy236M9OzIvB1nxdde6/tVmXXJD8CcomDNR5koJK8CPMB2WJ6G31B9/PAQ0gI7UNtOw9S5aaVfynwws+NRfORYdu7z0ovjY0VDsXAWrGOqYXlR+t1R7luHWX/cMuRUojMMViD7noc8Rwo1HD2er5iZRk4V2IYm2U44G/XcTInuSSXucC1J0zOtjfCfIO29b5xO56JsxWkDfuDcoJKIGxpUrWZWwCov0XLhu1F0TTHa/KZ0NbFp6zVWbCrJeNr23ynTT/OBcTH1ZSKPXVn51U+SERPD2or0K9OEufTza21gtTT2ONdld4/XUIAsZL/FaKc1Bo+vlF42ewq1LWfIaDSQoi/NPYKQe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When CONFIG_DEFERRED_STRUCT_PAGE_INIT (hereinafter DEFERRED) is
enabled, struct page initialization is deferred to parallel kthreads
that run later in the boot process.

Currently, KHO is incompatible with DEFERRED.
This series fixes that incompatibility.
---
v7:
- reimplemented the initialization of kho scratch again
v6:
- reimplemented the initialization of kho scratch
v5:
- rebased
v4:
- added a new commit to fix deferred init of kho scratch
- switched to ulong when refering to pfn
v3:
- changed commit msg
- don't invoke early_pfn_to_nid if CONFIG_DEFERRED_STRUCT_PAGE_INIT=n
v2:
- updated a comment

I took Evangelos's test code:
https://git.infradead.org/?p=users/vpetrog/linux.git;a=shortlog;h=refs/heads/kho-deferred-struct-page-init
and then modified it to this monster test that does 2 allocations:
at core_initcall (early) and at module_init (late). Then kexec, then
2 more allocations at these points, then restore the original 2, then
kexec, then restore the other 2. Basically I test preservation of early
and late allocation both on cold and on warm boot.
Tested it both with and without DEFERRED.

Evangelos Petrongonas (1):
  kho: make preserved pages compatible with deferred struct page init

Michal Clapinski (2):
  kho: make kho_scratch_overlap usable outside debugging
  kho: fix deferred init of kho scratch

 include/linux/kexec_handover.h              |  6 ++
 include/linux/memblock.h                    |  2 -
 kernel/liveupdate/Kconfig                   |  2 -
 kernel/liveupdate/Makefile                  |  1 -
 kernel/liveupdate/kexec_handover.c          | 65 ++++++++++++++++++---
 kernel/liveupdate/kexec_handover_debug.c    | 25 --------
 kernel/liveupdate/kexec_handover_internal.h |  7 ++-
 mm/memblock.c                               | 22 -------
 mm/page_alloc.c                             |  7 +++
 9 files changed, 74 insertions(+), 63 deletions(-)
 delete mode 100644 kernel/liveupdate/kexec_handover_debug.c

-- 
2.53.0.851.ga537e3e6e9-goog


