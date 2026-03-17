Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94226FD8764
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 12:50:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 087AC6B0088; Tue, 17 Mar 2026 08:50:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 038636B0089; Tue, 17 Mar 2026 08:50:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E42996B008A; Tue, 17 Mar 2026 08:50:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CE3AC6B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 08:50:34 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A87EC1B6BA1
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 12:50:34 +0000 (UTC)
X-FDA: 84555538788.19.BE9706B
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf10.hostedemail.com (Postfix) with ESMTP id 24B94C0004
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 12:50:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mvFCAy0N;
	spf=pass (imf10.hostedemail.com: domain of 3F065aQYKCOwVaOnifUccUZS.QcaZWbil-aaYjOQY.cfU@flex--hmazur.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3F065aQYKCOwVaOnifUccUZS.QcaZWbil-aaYjOQY.cfU@flex--hmazur.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773751833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ouPtvrktc39JxypPytkX8WaZzIB5CkXK3RuOBnNqCp0=;
	b=w/7oSGxlpPuuwpnILnp+P96NfARyM+C4LsUltj9QD7ze7mbEwg7dUORCGGh26bdVA4daHy
	iYCPRCRiGinXjJFtPHJ4Rk7ZGrmp7LsbXvlJHATGPKO4HSMh+rkhoTSS74PIk/DKzfLjsF
	gqsch0WZn5E3cYMCZhn6I/5hRg+oEUs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mvFCAy0N;
	spf=pass (imf10.hostedemail.com: domain of 3F065aQYKCOwVaOnifUccUZS.QcaZWbil-aaYjOQY.cfU@flex--hmazur.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3F065aQYKCOwVaOnifUccUZS.QcaZWbil-aaYjOQY.cfU@flex--hmazur.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773751833; a=rsa-sha256;
	cv=none;
	b=eETt1CkbwZmo+SzUmlzTt3tZ3RYIweUJT3kCcch8HO+7fpwCJCf3XrNuQh3hkkGBpB7AJW
	x0o9oYQeSRhHFI8N1V/g5bgN+EoSGkS08te+yU9wRYZLTKgHkYi9BGimRtHx20wUBY/7e6
	Ccf/o4v1268oDO7ZpDqpuW+VT3EqscI=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-43b3c9568a3so1537817f8f.0
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 05:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773751831; x=1774356631; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ouPtvrktc39JxypPytkX8WaZzIB5CkXK3RuOBnNqCp0=;
        b=mvFCAy0NZw0X2Udx4EGUdfzzW1638KtBS7f64vNpa7qbabtgAqnIWaXHkdusi2GCVB
         mXHACT8AWLS2f23CMMT046+GOARDjhzSe2yX2CkJnih2YLaJda0K9yuKBARCDnWiVx/Q
         X9fWTEhAgoqFe6Rc2QiZat54PjfcKRPN0AHYhkB+DbdZKp3MCAFj61DHrxyWbBjEq0xl
         1Fge+Xc4uz3NKvqDyW1OTQp3CwxkRY9kaar+mywz8dGZMSq2ax21ULXkwTbayoIgui2E
         N63qVRiEj5TYciyi6z1Xp6POcyoM83lD9FM0wzNlii9b10R3IZKDw4w9cf8D5X0yyhBI
         Be7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773751831; x=1774356631;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ouPtvrktc39JxypPytkX8WaZzIB5CkXK3RuOBnNqCp0=;
        b=BP2Nobli25iLfiLaaslY5AbkCeCNS4b4Yia9p+FEKN/drMNYVJeDzA1B2rCHfMjDu6
         XZivc19zMxmmtOPU7KdGUL+KL2Y7sRT4hdpxTM0BbaX2duRD/VpxQuUnED8MOz01qDAQ
         cHspxRiuxme5mf6pzKeF70nKld6v8kKj9VRkqfyBm2Ln52Y9Zi2hThfgrJcfjLytGY30
         kW4kxkTiUDuztA63T7WJVpHMddB8JBI0Bf1gjkbB+L2JE6aJnlCBJVc5oG66phvlCcwW
         KR/lZZhwvQkL4z86wAtRFnBf5THzG8/RX4ff7XhobItbzvbWPn4ADqyyzGcrS1A0i5Vu
         9J0Q==
X-Forwarded-Encrypted: i=1; AJvYcCVo43Ge1PeieV1CNQ/HzXIl57hOVZvfw3A0ScPYzrCq8Inrgs74w/+TXjkqRdvns0MxUpnbS2E1gw==@kvack.org
X-Gm-Message-State: AOJu0Yx0/2BLFQvcHooQ5g/K2ZqKhTjlItcYuF6laoEI/Ibq2uHuhZds
	Oo3gn9Ux9X/Plhraf2mqmxfvPF7dnmipnAlUewbJzHkHBEqzaXRv2omUZUWHEMC3fiBy1qBcunN
	+l/kphg==
X-Received: from wrbgx30.prod.google.com ([2002:a05:6000:471e:b0:439:f5db:2455])
 (user=hmazur job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:612:b0:43b:4077:c187
 with SMTP id ffacd0b85a97d-43b4077c7f7mr16938919f8f.38.1773751831147; Tue, 17
 Mar 2026 05:50:31 -0700 (PDT)
Date: Tue, 17 Mar 2026 12:50:19 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
Message-ID: <20260317125020.1293472-1-hmazur@google.com>
Subject: [PATCH v2 0/1] Encapsulate the populate and alloc as one atomic
From: Hubert Mazur <hmazur@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Stanislaw Kardach <skardach@google.com>, 
	Michal Krawczyk <mikrawczyk@google.com>, Slawomir Rosek <srosek@google.com>, 
	Lukasz Majczak <lmajczak@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Hubert Mazur <hmazur@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 24B94C0004
X-Stat-Signature: rffq76n17ur7frmeyaq1tdtmjaqbkt9w
X-Rspam-User: 
X-HE-Tag: 1773751832-815867
X-HE-Meta: U2FsdGVkX18ydc6ipKc+l+mo2Aj0sDFtV4SbOkOHsKXe8AVERBePnQyr0k23eVpvjeO3tFrzXShxcURUiAm5d5JCsoyqLMViq7pegGWSRl0MxWAZ1qaz9wBFb3S3v8iIU8pbdI8Qs+cWiKTG7jlUbTnIEmIIZaQs7v9BaV3A0/rGEeeOlvLtdwJLLY6/TyGAqcl93x8NTmW9vWPbJZERrgtQ999trjvumohEUF4AvcBSGDQ6Qa+gPWXnofN5lwG3Gfh6qGDgeM19yyJ66HqjsbMrHVgKnJCsUOwQ9KanVbSZfuzrcAg9HUGJkBQLJzHBdZ7x5s78mbSyjc7rNLkgflYG+cI3cgHduSt/SQJ509uGpJqudzh0mBadQRIjDIQpfLf2WD2tbknY3hBe3fUyQo4XgIKb32sO/Za+bka8Giqs0OIsfBE/087FzQPyf/iOdUQNNkmptxlK8ZDk5gPWN/MAvTVG16CLERa/xM04QaKWpUQBU1rqLbnhSiBJOcOWr6D68kcLbJwfJc3XfksMnBSfeKY3tV1WFcvtCeVajVKHLB3TW70YtjDMA00lFzSGzA534AFkzawI16bD0DJqDpuWFwcq+mhvG3xpBYNjQu5uthXr4YFSRVPOQOykcUVMtn+a9o5ANuAKxNUymmjOp7GmmSVdoYuctVnjHyGuAkxpOxaLFTWYmkaL5Gjr8490a696SwRH6F88fUbdM1mBqmR9DI7NpArwKBF1u+0Pp/zsMTGRzRIdZJ9EV8u9l6CPqTsKrLch0b7qgeda29+q5CBco66QAdXadbjtmFesgW04U1JP7icux7Kd4R3q5GZN7uBDJYheHDVBIzmcG9PMIHlM7U1rsHF0R2jgo351F7gRGfco0t8hxlRSU8sYTcClpuxYDDWIBRvnBFiijZDi1KsLNnSS1DWODOBuNLRtlE3p7u8KISKqLnozSfuJrTWTAGvOzc8bEAGO4XFtbgL
 60uACj0e
 wIwu3fByPetCxtBHuMsYqHv/lV4+RndKygROT8MljvmAHyzfZTGh3Ag5gAPyiC9uqJd0M99FWY/uHsDvEzHTGf0QsN1NQftEoSeICm+w5tp2g1KIvny1cEhBrPxBl1paMN91ylZGbF+iTMw+5SxGSaX9x5gziFZHdjTeV6hrudE3/t2HyU+L7jnIbvAfnNdqDP4VED3bDVtc4duiXH/CplMC0LTCo/9gMSfMBArNVl8bWrmGfC22732tx+zUSqmRBK9yR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,
thanks for the review of the v1 patchset. I tried to make v2 diff as
small as possible and without a modification of the core logic.

When a block of memory is requested from the execmem manager the
free_areas tree is traversed to find area of given size. If it is not
found then a new fragment, aligned to a PAGE_SIZE, is allocated and
added to free_areas. Afterwards, the free_areas tree is being traversed
again to fullfil the request.

The above operations of allocation and tree traversal are not atomic
hence another request may consume this newly allocated memory
block dedicated to the original request. As a result - the first
request fails to get the memory. Such occurence can be spotted on
evices running the 6.18 kernel during the paralell modules loading.

Regards
Hubert

Changes in v2:
The __execmem_cache_alloc_locked function (lockless version of
__execmem_cache_alloc) is introduced and called after
execmem_cache_add_locked from the __execmem_cache_populate_alloc
function (renamed from execmem_cache_populate). Both calls are
guarded now with a single mutex.

Changes in v1:
Allocate new memory fragment and assign it directly to the busy_areas
inside execmem_cache_populate function.

Link to v1:
https://lore.kernel.org/all/20260312131438.361746-1-hmazur@google.com/T/#t

Hubert Mazur (1):
  mm/execmem: Make the populate and alloc atomic

 mm/execmem.c | 61 +++++++++++++++++++++++++++++-----------------------
 1 file changed, 34 insertions(+), 27 deletions(-)

--
2.53.0.851.ga537e3e6e9-goog


