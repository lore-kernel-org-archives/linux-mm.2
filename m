Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08D60FB5EA4
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 02:50:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 173C96B0005; Mon, 16 Mar 2026 22:50:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FCFD6B0088; Mon, 16 Mar 2026 22:50:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0124E6B0089; Mon, 16 Mar 2026 22:50:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DD0DF6B0005
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 22:50:56 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 74D75B9334
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 02:50:56 +0000 (UTC)
X-FDA: 84554027712.16.F4C62A3
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	by imf28.hostedemail.com (Postfix) with ESMTP id C5254C000B
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 02:50:54 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=WF0oJIBL;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773715854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ZrwP9vzVGfaNwMkvnLtT3luNTNC+jo4F7BZmDmDkAs0=;
	b=rjECZaGneT64btR6jnKN0S9rZKts9LPLOHP4Eds+zZ5Nwrg79E2Hx60AMuf5xomYMntUOg
	yMgU1pPL5NJD+2av7dtOW57+dXAqEug5GSiDqpuGzI4ic6Umh2+LM6abqAGZzoZckEsB2Z
	uiDM4YTyF0tReJfR1Uuz+AIeHE6z40U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773715854; a=rsa-sha256;
	cv=none;
	b=z9brwFyaD/KKMPfma5WJddys3u2ZZdZn47giyZBT7uww2lI5XD/R4PB12TrR+2mVxTRL7P
	ob84TDRuROyeHXKjV67ohTdFnkN4lV1iRZewJgtchXcDtte8hJ3DR/xFsDQuEK6c7tz2F7
	pPKp08pJRAhs4WDvGoi9RqZWUps5XFQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=WF0oJIBL;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-79a3ba1653fso17445077b3.3
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1773715854; x=1774320654; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZrwP9vzVGfaNwMkvnLtT3luNTNC+jo4F7BZmDmDkAs0=;
        b=WF0oJIBLaQx4QjvqMOifItQVyzbnXWcQt1L88DKQUr8QPBd5AD5skfJzBE1rv/Ce3y
         F6U/k6C/iu4s8Tv+fCllL7tzt0Qk+XFwXfT0mu/NhWUEuHa/9zi1X+/nc6jl41anbt43
         F8Z+IA/8hCqdjL2KK50qEgrmv+PPUOcjYeaDukcDyRd+VFf7QQ5iYq/wd8whVy4TR0o0
         jBKI9ncUGxs4L2ZJ4nAXvAPFbD++dYHSCTVdwkzGWwDdyTJhgmvvPo2PBkd+ofvQsD9/
         L/lWtEY3efFZbwPGhVS//LqSad1J1SwHd9lwG30jI/ocneuZb9zYzPwpu36vKi9Qp8VJ
         5IMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773715854; x=1774320654;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZrwP9vzVGfaNwMkvnLtT3luNTNC+jo4F7BZmDmDkAs0=;
        b=Id4GKUg2/U8B1/VDDOMljUuCHrYo0cvld97dEOkeNE2EK9nS0wwPFR9jC8mcfie6P3
         Oyhe8W8wi2T9xj0gsnxY2ytfhR4XumYZINbaGBQH7VNLrjpXVWllph6DV7gstVMpUObf
         uYqgpqeWEVEBGjsUigQtjx1Q0m10Pqbr1ynOc8CSZJX84rFvBO60AnS2OD3QvPQXGPtV
         17yFn70unIYq9/7rlTcaIv8bv7oEw3ZCoyCbYxWHDgxMNoA7KBV1z32JXGVde+yLVgm7
         yn1aYBx++bCxZ9QZUKz9CYfiRQDd0v60oLz2qLLHp5dx+f+UKcA61++T29RiVGMA/6jp
         uH0Q==
X-Forwarded-Encrypted: i=1; AJvYcCWQT1K73e6RDPtLOLyucAshRFsbrCE2RpzYkVRGbs3zobhM3uP2uT8W6KCxGqpGxZW5ns6DRS6Qsg==@kvack.org
X-Gm-Message-State: AOJu0YxgQe+LKxRnlSi1W0uFbrJsKtfFPC83hfmkSJ8XQQbV55rnduFm
	LI62X2bdLP0e/DSOAZZZ4RXuxN6HdCnS6+6lCzgvX+gVPP6hiyHrPL1/oEePdTmqNgg=
X-Gm-Gg: ATEYQzzInBSLeNp4gCyFGoZopigQ810tW8/7PXSwdibXXAi1xQZDGCDv/s9iAS7skQp
	9Rgn278M0jOCaKGzmThW4cwOfSPTnRyfsDPOe/vhktB1ZUOIsOFnpnhjgqx894NqxPpjEszZgcY
	rtri00kA8OArGgGTvPocYSxsCby9n4jYwkrFI3uk73uTbaGFtO2wwwiKiPQcyIwn22RYCD4wq3J
	Khw12I25kELQq7ThbQwePZgi7am7C9CjK/wzkki7wmHZOl8t+Y4bfJMSjtKxWwFktgAHUpUCPRH
	/9G1U9QpMGkPXTnnfGfLed10WKUZGPZAzFpebozCGK4cZTPdZC9F3Vnv/h8Tgwud1hhgC1nq6n9
	Qyjy3+jm5zq/mQbwyFnLkuFls+6g1oUYpPl0+7bqjHB37OJ0r+FpqdKFKpZg1K91u62/N6EbSX5
	TawnkCr59hpzfMEhzLqU5FQg82e2bJT6EPLImVZexcdPlc+WFLwrOLrdVpxHDTK86XLfwNpKewB
	my8bSj9k5tqY1tWhEQq0kTvZlBQpaHKEMLVc9NQHYXQS85KSg==
X-Received: by 2002:a05:690c:6d81:b0:79a:668a:b6e8 with SMTP id 00721157ae682-79a668ad14bmr3958707b3.61.1773715853738;
        Mon, 16 Mar 2026 19:50:53 -0700 (PDT)
Received: from soleen.c.googlers.com.com (57.233.150.34.bc.googleusercontent.com. [34.150.233.57])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-79a5a866c85sm14951757b3.35.2026.03.16.19.50.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 19:50:53 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pasha.tatashin@soleen.com,
	rppt@kernel.org,
	pratyush@kernel.org,
	linux-kernel@vger.kernel.org,
	dmatlack@google.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org
Subject: [PATCH 0/6] liveupdate: Fix module unloading and unregister API
Date: Mon, 16 Mar 2026 22:50:43 -0400
Message-ID: <20260317025049.494931-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jyaspdk3omqutxugr1aretag84t8mmbi
X-Rspam-User: 
X-Rspamd-Queue-Id: C5254C000B
X-Rspamd-Server: rspam12
X-HE-Tag: 1773715854-143446
X-HE-Meta: U2FsdGVkX1/XfQppCV65s9S2UTzVX3f+GMp/aIdDQvRn+LCgY+Jcc7k4/9iI9VJhTDdpC5M6vkKD8AMJwR0OluAxEc+ohFj4yEkkDidjUsCGkVyI9hgmMHv1EbR92b/oattUJdg1ZoPdrjnrUpLUBgBQbjD1Zbhnybf+YqsjLmjkxXcfE+5eV2/+1qBilU4F1eafGcRAEQBCor5OVy9j0B/opRv5AzGYzjirqFkOSa+sAPE8dA+ufXpLr9My9FrBxM5pJitAUPVWLyc6AJWbtLDSgmJoUxEIkCv3Jpf+ofRa6BJ2zm7i6X+fnruq2/LOzysE7qIEJVOIgcH16QzkbiiteCPwf5n3O1/3qsw7i+PFMWsT4x8OK51f+otUhYFlC0WuAHFCcUlO67lO1P2DaJvlFyC4+mDXpWmCSlAauwMeyN1O0JDKozAUmyjnQtPpnC/fpAJ6RDwCRWUG83/1uKpne26brrP9KhtwHt++cavFeQqy049bf3dUefXaYW8A4OY6VO6QcszkZ1E3ji8/+lVV9hb/y+MYagO9SoePDywPUWUUG0loAD+GF7EV1Op/Ch9YmJaovugdq5y3jLsd4+yKU8ukJC0/jkBiUM9f33cKoJTzwHDxy37vQB/6WUbty3GdU+5N7s6Q9s9dKSCczr1GJDGPg+VhS9VVJI0E4A8AMXY7ccvNKjVKdD34pz2UDVTd3R6+m+FnmV0FKrdyfhECM8Qphdb8JgTlMsSzSftjjhkI3q+N5paKXfPdIsIygskmo5jvVyEhtpmd5No6n2ZAunbZC9Ye7nuz70D5HldTj+y81If+sF37p0pjNjOq8qaK+wH4BbT33GDG+vgD2HsNm9c7YQ3/PZG4Ni9qgyScCPfhGA4vfmYnAcd2JxQRLZdM53fquSBgNhsM858f8zlyVcrhI2wEBIeOkafXuhcCOiajU7Za6FPFrYHYkXHPToBFyvLq3iePIP+4k5N
 126JGBv5
 UD6kqV3yw3P/2GjSFg2B5U+uEUMoek//CLICnuYSPEuKHKoOiEREvZeGoRgnpZQi28dkq2zA6T4IqO6f7mgZeI03yISczDEsICoak7qdD2RPL97lvXVQzqRg7lsNNthEVJgNxeXIxTqL4Tq4lrko3U76N6UUBzLK5+H0NCZ6QHQ/MzxTiO+7vtceZt5wDbF0JZiwuk2ktET8zD9GEe53kR1uyVpn/6qjR+Qzq5ywnGnKy+BnqIJhSWpCmQzFpp6MAh6XcoaYzfaw/F2dJOOt376pgeg4ObcUIktAbJcCeFFktxK3t3VhasgC9XF7aVsdyh0Kn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series addresses an issue with how LUO handles module
reference counting and unregistration during a module unload (e.g.,
via rmmod).

Currently, modules that register live update file handlers are pinned
for the entire duration they are registered. This prevents the modules
from being unloaded gracefully, even when no live update session is in
progress.

Furthermore, if a module is forcefully unloaded, the unregistration
functions return an error (e.g. -EBUSY) if a session is active, which
is ignored by the kernel's module unload path, leaving dangling
pointers in the LUO global lists.

As pointed out by Jason Gunthorpe and Alex Williamson during the review
of the VFIO PCI live update patches [1]:
> "destroy" functions that fail are evil. :)
> IMHO blow up the kernel or something in the core code, you can't stop
> module unloading once it starts so it is pointless to propagate this

To resolve these issues, this series introduces the following changes:
1. Adds read-write semaphores (luo_file_handler_lock, luo_flb_lock, and
   a per-handler flb_lock) to protect the registration lists. This allows
   highly scalable concurrent access for file preservation without
   blocking, while still preventing traversal races during module unload.
2. Defers module reference counting (try_module_get / module_put)
   so that modules are only pinned when their handlers or FLBs are
   actively used in a live update session. This allows the core kernel
   module code to correctly reject an unload attempt (-EWOULDBLOCK)
   only when a session is actively running.
3. Changes the unregistration functions to return void instead of
   an error code. If they fail to unregister due to dangling references,
   they print a warning instead of aborting, aligning with standard
   kernel destroy/unregister semantics.
4. Removes the global luo_session_quiesce() mechanism. Now that module
   references properly handle the usage of file handlers and FLBs
   during active sessions, we can safely remove the quiesce/resume logic.

[1] https://lore.kernel.org/all/20260303210733.GG972761@nvidia.com

Pasha Tatashin (6):
  liveupdate: Protect file handler list with rwsem
  liveupdate: Protect FLB lists with rwsem
  liveupdate: Defer file handler module refcounting to active sessions
  liveupdate: Defer FLB module refcounting to active sessions
  liveupdate: Make unregister functions return void
  liveupdate: Remove luo_session_quiesce()

 include/linux/liveupdate.h       |  16 +++--
 kernel/liveupdate/luo_file.c     | 118 ++++++++++++++-----------------
 kernel/liveupdate/luo_flb.c      | 108 ++++++++++++----------------
 kernel/liveupdate/luo_internal.h |   2 -
 kernel/liveupdate/luo_session.c  |  44 ------------
 lib/tests/liveupdate.c           |   8 +--
 6 files changed, 113 insertions(+), 183 deletions(-)

-- 
2.53.0.851.ga537e3e6e9-goog


