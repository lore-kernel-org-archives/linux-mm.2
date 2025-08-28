Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB9A4CA0FF2
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 03:27:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BC9F8E0007; Wed, 27 Aug 2025 23:27:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16DF88E0001; Wed, 27 Aug 2025 23:27:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 083BB8E0007; Wed, 27 Aug 2025 23:27:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EC70E8E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 23:27:01 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 919A084F38
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 03:27:01 +0000 (UTC)
X-FDA: 83824729842.14.030F1E6
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf03.hostedemail.com (Postfix) with ESMTP id D043920005
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 03:26:59 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Nd9+i0Rc;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 3gsyvaAgKCCcFPOODPDVJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--cmllamas.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3gsyvaAgKCCcFPOODPDVJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--cmllamas.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756351619; a=rsa-sha256;
	cv=none;
	b=ZKY52vvEX7fSzTLi4goXIjksgbvz3rQ9M5Ok8OmQnGU1b4+SOXICPMd7/SbhU3vWgsJVea
	Rnbk1BUHdLhTtXjVgzvqNU7MY8UPSHQt8WAtzDGNaUxu5lHYEQKQNdgLukfl2xkTJJARtI
	lv+FIuerPwTcfdCjgUndRrbgmKEdySA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Nd9+i0Rc;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 3gsyvaAgKCCcFPOODPDVJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--cmllamas.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3gsyvaAgKCCcFPOODPDVJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--cmllamas.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756351619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=/WwDqhBFvfX8vGdZlaGfr2aX/pAs2877vUWTmC3CYPY=;
	b=2LF4LKqKp9iXkfmZUDmcbLV3nexB5E2+p0a4/jJS+lb7L1O0kEqx6JiKfY1ksl7UKuTHeJ
	hXs3aFc6du2Gn30SdTljAAJcBoK+e8WZEjPoOffPMeWYA/AvUmVwQiMG3+Y0xeW18CAwFO
	jaALqnkAdP4nFiUZ1dusIfDRMdNcZ1E=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-244581ce13aso8475475ad.2
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 20:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756351618; x=1756956418; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/WwDqhBFvfX8vGdZlaGfr2aX/pAs2877vUWTmC3CYPY=;
        b=Nd9+i0RcUwLmPCx3WWknGBGoL2mVWWk1UNOL/v0RP28C+6z6uPiGtPxpJggP1rerNi
         8/GMqhS6D1fwAPfOJy5ZkwebE0Q7lxXc5osmjcI+Uo3fRvTsUmfuJsCNXENl11XZtZuC
         pAOR+6Tjn2K8lbYQ4u+ubIY/BBs+TDkJrr70ZQZ2dS/Qz5PXeA1ppFCcDpp28XYBeS/4
         jEHg4QbpdMlv4nnD28ks9U8PKcUX9UxsQtiICo3Sp8luQXOxnWx9R6/vhdXev7PLSm62
         ujY1TYRulKVevAzu95mdeMANyJQzXtW+tkwz/fA6twmaLaLsEWgJviqhGzUHohH5oH4B
         rfFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756351618; x=1756956418;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/WwDqhBFvfX8vGdZlaGfr2aX/pAs2877vUWTmC3CYPY=;
        b=YHgnnAAxw3U/3eIXv3TbjxU7myvbR68oXf9f902xhI1rI/A1HGr1TAp5p9I0qF0sPn
         f5sXaXpP+Ct07XTfed93ycs8iA6KLrOR8ovZyeXUUSihExuBOTRVbxh6pmUrhKcyxjBg
         O+HJ7p9MWKt05nrAXNEEgISyVfqgY6KmgqiwUh5OJ/4UzBK6U849Q+tSILUgeG8+PJGz
         Yt9WlSLrywWIG+6gR9jMFNpeD3gnUUDmy3dS1+EO4UctRATQkwWyM1wwkp0a3hRMo7+7
         8o0ftPxJnuqRww8OH8ZQzhPc2xKwAt9l64upWsuNZVqrmms4Q/7q9RnhUh6yNa9i8JfX
         triQ==
X-Forwarded-Encrypted: i=1; AJvYcCWCMR7RcvwTHMXEVdm8y61JVu0wNlwl2HqHmwlbJ8a0ElJFyyQRWlbjK216Pe+0WRO7lryxquAi2Q==@kvack.org
X-Gm-Message-State: AOJu0YxEDY3kt9HBJqiQv3+dMqgdDgvRGwmk38xpc12OpeA/6xFCxXGD
	oOwfqECynRltHo3TAEgpFvmC3peHOXcf/DBQSWKTH9wXReGZSWqcp4d3b2WyQT+TdbJiQlHpmOe
	BOR43x+yyNfo1RA==
X-Google-Smtp-Source: AGHT+IFxSA9GIyNl3LjYDLq/9j+Nr4FbBkqdslTMspmmUmyNwznrDCKsEp0DmZ+NS6CY1yHpDOzTMPRVndE+uA==
X-Received: from plfz1.prod.google.com ([2002:a17:902:d541:b0:248:beac:b4f1])
 (user=cmllamas job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:f707:b0:235:f459:69c7 with SMTP id d9443c01a7336-2462efa8c13mr281904895ad.52.1756351618636;
 Wed, 27 Aug 2025 20:26:58 -0700 (PDT)
Date: Thu, 28 Aug 2025 03:26:52 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.268.g9569e192d0-goog
Message-ID: <20250828032653.521314-1-cmllamas@google.com>
Subject: [PATCH] mm/mremap: fix regression in vrm->new_addr check
From: Carlos Llamas <cmllamas@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
Cc: kernel-team@android.com, linux-kernel@vger.kernel.org, 
	Carlos Llamas <cmllamas@google.com>, "open list:MEMORY MAPPING" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: D043920005
X-Stat-Signature: 7cxat9k7ty8qbm67qfm7tbsfmionhbi4
X-HE-Tag: 1756351619-892198
X-HE-Meta: U2FsdGVkX198adhD5AhK7j/NOUhxaNaAJkYU+INL1aK52tKGcHb+XMo6RpFrMeXJVl22KBLLGKiusLtX05u0Ho0Q6zfZHgv46OQIUKZK/N4Fc3h84p5FSLZyYslFPA8kovhAwI5NbPC2hu/X+xP/7U9lkiINEtBALrKH7JmtYTjRjGFwy9wtLv4mLW1dqyIQy5lrHI64pTWgJlKYCUxQbPG5/UXqPJ9ehK+DgmMolSiV2PtSjUFc4vG1WQ81m/efGIXfuTvOn1tYIl+WbzVy1h1dEk4YygeXCAA6K6VmbN6SWAwi4rJNQHKyNjdM5krtn7QttrWDDNsz2wMMAplXdGJcIUPR4pSm1niplvOAOuqQ96DXvQAFSPryJvT2pD3QFLyX2M/Kh97sZ0RY9xf+ehw3IQiavMhFeyX8icGXN9oKvoK8AHnJww6wHQHoDeUmTd23PKmUYxzIHIlJUoE7ETja8NFYNR+cJMNzH2URxnC+11xBWxe77ZPaFwzD7P5gzQQlgW9NcPC8//Zpdp9e7WskeNEpGHoWK3rE81fDmXP+bMUSwhYD0d4xiUSSBqwUzH+smvDnXcVeWbsS+lygFXlnOAE9Qeu8fRTqIlaT5CFZvxjAyMLHtpXf0J5KG/OB9pPSNyPyAjLR4q8+y8czj/jiKS5lHu3uMDtc7tK6soUeQ9scTOki1rdb2PLbZHdXMamaw67oNHb7esATw3MY9fBtEUt5+/qVjEN34u00Fs97PfabTZDTucDUYUZVeBWtVC1aaY0H7yVhh3FyZoWiF1Y3HP8Qrn2ToxMw7pkYNMtk2Z5as2Vi7qXMtI5TpSj8aY3s0AxsElfwqN3tUWEE1zTRb2GBN2oyv5Jifx8gmB2+L6gIVQwJEf2RKPJIOTxwojsrohYYCRQNNR2+zhgB56R8lMr+l9WggiLF7ZmRuOKIHpmyfleTn++3iTlsqw67Jdfmnl3NQrwuDMvt90Q
 3hAroP1A
 tGSdjPkOPy4Bo47Ho1liKhy5J9jKrd4ZRxHgok1O64cN60OS3VASfq/cV4pfBjUJDoxdcKQQnOQHIPOLICBQsFLZWyMMX8CURCYZWj4joe/5RsRt7cahGnVIBhg/mJ5crKxsoLZFOQEdlBGv+hk3lCsT8R8lhwG5/uqX3A3kvkXKHLfTqe3w+Xr/P+dR8rQEEIdjCRSNJAPvPkRBVgIT9KMxI9MhJfIniPOLvgLRt4GYZgjEqwYJ1hiZj8AfLqDDKzpgJMkiQJfUT8RP0ISeNBPepWsLlHHWoEs7GG2CPbo7sZu+Se73ZYNxgr+5Xrog84aCYDTLNR6JDg6NND1NykRNo1Sotj8jihdxB+ESaL9RSa9eRApUQTK/Zor535GJUOp1/wx6/ZRvj0tg7QCp8vf8Gsqor+S6poIh8emomUcoJyCe749HszqN4zbxYMZL8DLS42uiqg+NU49vpQecfisb3JxIgtlZnZsDpWM+w3EqhDTNJd+D3d/ETH6Fsh59VHFKDO4fBn2fKzywAn0frtxSRFhbtawrR/XoCib05FgJWu/Whgj5evibujoxHLKkIFKUqCLsqjmX7GSSKrvNxRf6WK5t1ug+iHAso
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 3215eaceca87 ("mm/mremap: refactor initial parameter sanity
checks") moved the sanity check for vrm->new_addr from mremap_to() to
check_mremap_params().

However, this caused a regression as vrm->new_addr is now checked even
when MREMAP_FIXED and MREMAP_DONTUNMAP flags are not specified. In this
case, vrm->new_addr can be garbage and create unexpected failures.

Fix this by moving the new_addr check after the vrm_implies_new_addr()
guard. This ensures that the new_addr is only checked when the user has
specified one explicitly.

Fixes: 3215eaceca87 ("mm/mremap: refactor initial parameter sanity checks")
Signed-off-by: Carlos Llamas <cmllamas@google.com>
---
 mm/mremap.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index e618a706aff5..692acb0f9ea2 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1771,18 +1771,17 @@ static unsigned long check_mremap_params(struct vma_remap_struct *vrm)
 	 * for DOS-emu "duplicate shm area" thing. But
 	 * a zero new-len is nonsensical.
 	 */
-	if (!vrm->new_len)
-		return -EINVAL;
-
-	/* Is the new length or address silly? */
-	if (vrm->new_len > TASK_SIZE ||
-	    vrm->new_addr > TASK_SIZE - vrm->new_len)
+	if (!vrm->new_len || vrm->new_len > TASK_SIZE)
 		return -EINVAL;
 
 	/* Remainder of checks are for cases with specific new_addr. */
 	if (!vrm_implies_new_addr(vrm))
 		return 0;
 
+	/* Is the new address silly? */
+	if (vrm->new_addr > TASK_SIZE - vrm->new_len)
+		return -EINVAL;
+
 	/* The new address must be page-aligned. */
 	if (offset_in_page(vrm->new_addr))
 		return -EINVAL;
-- 
2.51.0.268.g9569e192d0-goog


