Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BC5BC5DF8C
	for <linux-mm@archiver.kernel.org>; Sat, 22 Aug 2026 13:54:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12D2D6B0095; Sat, 22 Aug 2026 09:54:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DDB66B009B; Sat, 22 Aug 2026 09:54:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0E056B009D; Sat, 22 Aug 2026 09:54:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BFF476B0095
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 09:54:00 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4C9B816015F
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 13:54:00 +0000 (UTC)
X-FDA: 85129049040.25.879EA79
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7F97920006
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 13:53:58 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Sal9YDx3;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of 39KmJaggKCMkp6sq+vx8v33v0t.r310x29C-11zAprz.36v@flex--ardb.bounces.google.com designates 209.85.128.71 as permitted sender) smtp.mailfrom=39KmJaggKCMkp6sq+vx8v33v0t.r310x29C-11zAprz.36v@flex--ardb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787406838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=SFWwYfK2ORvvb1ePNWqdIkWg8WHsPyZq2XD2ex3XzW0=;
	b=4JO8icKd8mLzryFG0tXyJGqcTBkm9vbCszOLgiDuDgFofLLGhDW3XAU6Mkn3IGDZqaTuk9
	FwmD8w6548v1Ha/IQ1p88GQOmPOmWcuJq7oQjgvPkd5wgOcGp5w+em/oYLff/P6CqyQUx+
	HkvkpLAY1NIm3sgd2pJfTujimen+yio=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Sal9YDx3;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of 39KmJaggKCMkp6sq+vx8v33v0t.r310x29C-11zAprz.36v@flex--ardb.bounces.google.com designates 209.85.128.71 as permitted sender) smtp.mailfrom=39KmJaggKCMkp6sq+vx8v33v0t.r310x29C-11zAprz.36v@flex--ardb.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787406838;
	b=AJ6o93bz1CwnR3c5sPrnJp99/EALKpkHloTeDkFUxErWYD8x3xmxmSZtIrbZ1SK1RKOQWU
	QBNydu8Lf3pZPOkwl1vkvij0TRRrcB8+FEXHZ/ZmrBLQbOqtWOABQvw0EUPEPpBj6B13r7
	0Fh1XqMaJsoLkUYAMIX4b0Kkre3FJCA=
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-495474a5fbcso16830435e9.1
        for <linux-mm@kvack.org>; Sat, 22 Aug 2026 06:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787406837; x=1788011637; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=SFWwYfK2ORvvb1ePNWqdIkWg8WHsPyZq2XD2ex3XzW0=;
        b=Sal9YDx3+zTLuGF3k4vYxtGZxcpvCnRhngJR4UkFWKlRNuPvnedWv/XK04cF18yeU5
         eEPvnNWKZ7NJxqMrOSiamEybH1/SGo1CZrlpngkOi7QYS/2uhaRpUuCyEI3rR0kdz1yu
         OBxkUDNO3TA+ngQtubrtdSLEaNMD+/AR0Ux9mQtt0EI5nlw76KEm1hOw9B1tIVCJPJFM
         3ca5oQFustUteO11h9v/CYCLepHOembkTI3ywwoiurFqaikerzmZHmuVYaqEhYbF4lBF
         37+zCnG+g3QF8eyrJkRrrggRI2hQV5waPQOSaJpWMFpMBaavPbQSkCehY5BnU+RbnM9V
         qXqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787406837; x=1788011637;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SFWwYfK2ORvvb1ePNWqdIkWg8WHsPyZq2XD2ex3XzW0=;
        b=LgyDGL/JkzkXeO2M5cFMcKd9B3n0L2svt8oQvK7eK6gcptMRvEhWgfVZrHDG4a4eT4
         xAtJr3kXGEi+/X15heMChL7ojVHXhdCUBBJGx3gJU6ZOsk/STbOfoagNXgmktuo+BcsA
         JWyGtYKeLfUoAO356nJmcsWEgKIFTiSNbz3WVesN+Hr5yx6asxVXSa8q2UbzX5O67PIg
         BVrwEktcT8C1wx3R1aMxbwghljrgpsp8V3QQQSz+nKmHVxrM+kLjsauRNFiAhWtGMr5v
         b4jDOpow0QacpQTPJ/FEkROW+fy4jqMb1HN1d9ix61cpxJlCCcZjsiXxak+nBfHXpAsX
         3ylg==
X-Forwarded-Encrypted: i=1; AHgh+RoUqc15Zid1mAt5qOzPO7uIDeRoIOuGkzcTO7oT3aupmaNoKiusK3Ec4BFY6UENjzYuNI7zNUyK/w==@kvack.org
X-Gm-Message-State: AFuF++muOi/f6qbkXHpMgIzg4J17g6kbaWx1z5vJ3XJ7MP6jqhKmvBdr
	xeY8vR8HEgU0Cz4yeRujW+xMDOOsd8z1dKSZpSG6YiC0tiNYf08M7+qej+XBuTk/DqXZIabwCw=
	=
X-Received: from wmlu19.prod.google.com ([2002:a05:600c:2113:b0:493:ae35:2761])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4f06:b0:499:a5fc:207e
 with SMTP id 5b1f17b1804b1-499b8340754mr196385025e9.8.1787406836660; Sat, 22
 Aug 2026 06:53:56 -0700 (PDT)
Date: Sat, 22 Aug 2026 15:53:22 +0200
Mime-Version: 1.0
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=3648; i=ardb@kernel.org;
 h=from:subject; bh=2f7AvVCI5x1tX97+DCcut0s/Ah4Z634pXHbbbq7B0rk=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIatz5WXxBeue7y3/sIvrsfxld8u+ud3712Ssecfy8Xo4Z
 /z2HZaKHaUsDGJcDLJiiiwCs/++23l6olSt8yxZmDmsTCBDGLg4BWAiP98zMvRtO33wRsLJ8H2u
 zLVsqfNVVy7rWL3p0aqaHzyLTcMu3S9h+KfBcnOJYGSsFldpb0TP6S2Bt7lMSs58us+6yehx6eU XX1kA
X-Mailer: git-send-email 2.55.0.860.g4b6b3295ed-goog
Message-ID: <20260822135323.795946-11-ardb+git@google.com>
Subject: [RFC PATCH 0/9] arm64: Allocate .text and .init.text together
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kernel@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>, 
	Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
	Aaron Tomlin <atomlin@atomlin.com>, "=?UTF-8?q?Adrian=20Barna=C5=9B?=" <abarnas@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Kevin Brodsky <kevin.brodsky@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-trace-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-modules@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7F97920006
X-Stat-Signature: 4tkjup6nwjgot6fzap7umb1cq4oktoso
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787406838-245839
X-HE-Meta: U2FsdGVkX18W4+BKZ1QqFGa6wVOFB0RqJ2+SBguciacnBkQuEFqXiiSpZ0nQvzbFmNUcBc4g75oNnan1tR30YJqaZ1Sf0gpSduaN+l5L2B+EjHKP72cCN9cpzQ8WVSM4QzNl9Fwsc6AhiGFLvLNwFUdpBkvIlyftkTiDViTLxdwuqBjwdEneCg7r/bRh/iLuD6vc9rmWaoyfhsBXre7AyM2c45V2mDZS+vUrF4yYDu0AFFXF88oLAvIe0V2MmrcvW2N4lbX5xQvkaguya/OdPb3GxVrcRG0agbXdzRfcoRlMeJv5nE5QFZFiCkR9jBRtnSuvfDYpq8EnNdkp2+hO9Ku8IL6KnwUpzl9xHeDw+AkwuEbJwJ9D/ovJr6L6fa1bo9Tl3hFe2BJ2MMP21tLLDpnjn8V+VVr+lpGtkFRdVzVpfglxJSLBeFZAUyrq2KqoD/++pYRsEFMjbp7e2iNFN8zlQQ17PedetaAhSFzrLVIleEv4ZjKJr7xAzhhcdsnmjN6NS2nM9+fuOpoxw22TMw87JFqxUb/dw7BYxoT0L99Mw2pbwx7lLy2Ks5JJ28NVpZmowJoY2TSZXFI2TiMKkhaNFcrcX6t2gVTFUEBb/eumMrfiJILDwOWErnMz8ylK0vcS1KjOmFi3LALG+3rD/w3cWhMLSDerSLRBIOp12jjEh9Z0wziX9O/mdC2Axbv4FK12PxGyornMwF7yfx4OrKIF1ZofygoiIcAU9qM680zseLX71Lc9n/ObcJAgRSaEhYf4u9/ALLU1aeLc4kGxSiVzet5IOqYT2+sKfgbcNT4u2HxMVzMhMko+vTCVCp0YTaYqRhiNEEnt3vW/PtW+pLiYhc/OKOV9uYb6WPGa5clXVJ4kZ9aZuGnAMc6Nnts6QD/hBkHBH/2HGGC98Q4/UUcqfOOXJxFTHIFwWsm1UJju4TOodmgSbf0vjW4qor6dquSXGjXJL5pe71U/mPN
 VwNrf0Au
 j3W12/5AHMGo93xuYSXO8iuXdbb/BeY8wv/Z9p3ScpfIfqL6wfBQmk0aeMpKJOYA5INbvJr2ixIHL4A/uWn8rwuAaie7AEoyFBb7s5JkmoAEQsUE2UF2lCkTRDDmxdF3fCA52fClwu3owJjT9e5Upuut4r5HCi/Pl9reHvXFjrc/XHVu34QPh7vN8/q855GwXtXSy/ffeUcHvSyENLb48kgj7DtRTfOl5PIKoDQDkeicnPSNzAywSCfWXZ83EYGl0nWAHc/JZfJQ9CwIcyUDPAdm6/zHh5qAVCL2h/savd3HgpTUBpjOEluolHz/784BP4VEhF1woWG0oLifJuujLg4zL4432wbBxM8cx2S6pUJN35FUkKJS8jhX2gbkwWLNeOaPrS/2rCd6j6KjaNvRLax68YMb7zB6zgqpBfl4heVOTPNxtoPzkt6yZH+7c9+ubcsjac5OPyobgPb4HixUwViOhBAeBvR0zZi0jsnAc9TPxiFqeCj63G+E4RwVYSPGfgtDRWs1Knrt06Kjdkth9f/sYQWyZKoH4mpZ6337RZQQDpG8n9Lv/qknAFbn+6IcOdaoIBKk8lI5iuZieU40VRAVijvGvy3A+zHFAM5v1UzqlDM5XN7LyIlzx/Pjh1U7HISS4Ws7RlsQdYorX2H4tQXnXODw5f81RPLoRQ0RUzrvRBwbMTqLhqg+I0UOlDaHqpJ3V4vKu3MNrMUmBLN7vRzPPshWU1T10IPqB8M1GlYG36TohqIj6GCxxbdmHOgbpNzu91p0Ku0BDn+Fo7kelwsOArYnBQT5TH47ofL5E8okvTW+cSY6uOi8IEb4Dr7rgtW8AmkqhW1WgpbcGGULcYwzDjNsd9GapRHPZyu6WymaDEBzzns9sUzarJlO7krrPWomAQZHaSMH5avWwbYm6LF9Yip6XR5XHEdvgVZ9GV5eEqGZlmGyT3/gfiprd395GvMSIRRX7tHJiLCPKJnvS6KMwleTZ
 V2U8yk5o
 b7ro9ctDPLZTL6JVw6PCtJVtv4qK1Hrg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

The arm64 module loader has to deal with a couple of corner cases that
may occur when .init.text is placed out of direct branch range of .text:

- ordinary direct branches from .init.text into .text may require the
  use of a PLT entry (i.e., a trampoline aka veneer), which means not
  only that additional PLT entries need to be allocated for
  cross-section calls, but also that .init.text needs its own PLT
  reservation, as the one in .text will be out of range as well;

- dynamic patching of the ftrace handler into .init.text code needs its
  own dedicated trampoline as the one in .text may be too far away.

- recent compilers may omit BTI veneers for static functions that never
  have their address taken, and so additional veneers will need to be
  added to .text in case cross-section direct branches from .init.text=20
  require a PLT entry (and therefore a landing pad at the target end).

This is unfortunate, because it is actually somewhat unusual for .text
and .init.text to be so far away from each other: only when allocating
either of them (but not both) exhausts the 'near' (PLT-less) module
region, the other will be allocated from the spillover region, which is
not in direct branching range, and therefore requires PLT entries for
cross-section calls.

This series addresses this wart by allocating both of them as a single
chunk, and freeing the .init.text part along with the other init
sections at the appropriate time. This ensures that the two regions will
never require veneers for cross-section calls, allowing the arm64 module
loader to be simplified.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Petr Pavlu <petr.pavlu@suse.com>
Cc: Daniel Gomez <da.gomez@kernel.org>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Aaron Tomlin <atomlin@atomlin.com>
Cc: "Adrian Barna=C5=9B" <abarnas@google.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-trace-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-modules@vger.kernel.org

Ard Biesheuvel (9):
  mm: execmem: Add API to split an existing execmem cache allocation
  mm: execmem: Allow huge vmappings to be avoided for execmem caches
  module: Place MOD_TEXT before MOD_INIT_TEXT in enumeration
  module: Allocate MOD_INIT_TEXT from the MOD_TEXT ROX allocation
  arm64: mm: Permit permissions changes on huge vmappings
  arm64: Enable the execmem ROX cache for module text
  arm64: ftrace: Revert "fix unreachable PLT for ftrace_caller ..."
  arm64: module: Combine init and core PLT entries again
  arm64: ftrace: Simplify PLT handling

 arch/arm64/Kconfig                  |  1 +
 arch/arm64/include/asm/module.h     |  2 -
 arch/arm64/include/asm/module.lds.h |  3 -
 arch/arm64/kernel/ftrace.c          | 13 +---
 arch/arm64/kernel/module-plts.c     | 63 +++++---------------
 arch/arm64/kernel/module.c          | 20 +------
 arch/arm64/mm/init.c                | 19 +++++-
 arch/arm64/mm/pageattr.c            | 13 +++-
 include/linux/execmem.h             | 11 ++++
 include/linux/module.h              |  4 +-
 kernel/module/main.c                | 22 +++++--
 mm/execmem.c                        | 47 ++++++++++++++-
 12 files changed, 124 insertions(+), 94 deletions(-)

--=20
2.55.0.860.g4b6b3295ed-goog


