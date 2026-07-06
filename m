Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A43CDC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 16:38:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B3BE6B00BE; Mon,  6 Jul 2026 12:38:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 664F26B00C0; Mon,  6 Jul 2026 12:38:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52F776B00C4; Mon,  6 Jul 2026 12:38:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 273A66B00BE
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 12:38:46 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8C45B40178
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 16:38:45 +0000 (UTC)
X-FDA: 84958910610.12.A3418B4
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf17.hostedemail.com (Postfix) with ESMTP id DD4B540003
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 16:38:43 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ww04ihlT;
	spf=pass (imf17.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783355923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=q3YBRTaja8Io8T+OBzHFe+6+gYpexbpRi1HdwVacSuQ=;
	b=51tDgFPbSz+6kx1AaqM7uX/Bq7HvDONday0e92q7tQLyQ0YHH5vb9sCF6YJrYa8Se9OYZD
	tQEu9fo+WC1qWIkluY16+vNOpRMvsi6Fk/LGT7Wsv48o1xOOXvyYTJrb1y3aY5e2wvzNay
	hSktDXFv1agz5S2/TjzSGK8pAkgjCrI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ww04ihlT;
	spf=pass (imf17.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783355923;
	b=YrUW0XQohk8pBvMJ8YUyxrg/y44XqsOuTQa7+HNeTon3wKWB7b9rPPLiaa7cdfwJ9JxW3H
	83k0vxKwRErhQ4x3MPrZqVTD8oL5iP335L82lTjF0B6/bGi5UeixrXozlvyPhyc+qfx/jI
	JdRV4X0yxN5H1QGkp1oxCI5cVlEJtf0=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2cae134bdc8so17550425ad.3
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 09:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783355923; x=1783960723; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=q3YBRTaja8Io8T+OBzHFe+6+gYpexbpRi1HdwVacSuQ=;
        b=Ww04ihlTiaVofmL6uBhc7uZMX1upgujHu/QxDcstpCqOHWm5KaSWAv0vKkp2TZ/iVs
         bMZ1yU58QY85gMCVkcawWTfFjb33Xdw6R7QeeU+46/HZtHQafdUnZC+CoSeiRQ5IEDvu
         1iOhV+GvHWl3cDKKy+pIkhFsTN8jCDAhZ5ah/2+WFGZ17wtvyASmHwbQUAQz08kpBSea
         O4xWfcvNh1l2xQ/+uoFXb7v3L0yED8p365fafTWI10hnXikWSL4VFF+USOiDilS2O0tc
         BmrIuo7qChF1pg6fKGCZ6f397EXR9yMVCrhDRM5QA6SzSfHWEIZ5/qiYnL3yBvkztcrb
         Qbew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783355923; x=1783960723;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=q3YBRTaja8Io8T+OBzHFe+6+gYpexbpRi1HdwVacSuQ=;
        b=OI53E8yZaPcMrvTdcdkRA0jmKVEyQcAhUeUJpDZSZ3lrgieUUkBsfkbv4hQ4UQr349
         4RPjtTsZ/qIl/CA7b01Q4RCWJ7dMJPmcoxluWcTXuvJ3vyZKD2URy/vGnksTvuPgAGj8
         /XBXoe1tzqDQ9QAoGaDxLgkOy9yl2tX4EzQ2/KJo+JFQih1WRL015mLW6QlbyB0trXuH
         aMh1Q2NrOq5G41alLsT0wYawlyy70qnDSfoDq08qLpjp404p9PaPcx5hW4yWesmrDKbC
         c63vMLkD3hNqIpKsrpjDsJrWeV6sNsv4Eu9jTS07fT8ob+/S27UqfrNrZ96e1mX4SnCV
         mRbQ==
X-Gm-Message-State: AOJu0YxYGMqSdr5/Hc4RqGrTVyuALqQWB5Y2nZbMH3xO+CLe3Dy1xiuP
	RunSOKxnBNwBgqXUgVYjEH8fHej12y3FDy1lwb7FtX9J2bOr9+N0LxfE
X-Gm-Gg: AfdE7cmBJbdi3Nj7SYGvkhXfvwF79YOdgmMuAuzz6yIOzJxER1EyZUfmnEzRFpJvqiI
	n6bIBR0C3xBTsbS16Gj1uh8CG4z9fcZ4QuD3VQsdyPX9UqMhfR8aXoNIuzUuFEQgJhh9gQ27GKF
	p5DHc1p0c1vrcirXDLshkP4JW5hiI225UgtMkk/dkRrRCAbRB0dDifiFcJbY3QAz4+CMHV44Xez
	6bdWJdKUFnHDmNjYKe9B4pb13VtB8oi44QRs8vdXVV3YkCSZlt2vB5L+A4NI1tbo1qWd7kRPZ2n
	zQKWQ9/wdMaffyvnXAlcyrBpbTmregArp7Fb8H9BLoYi5SmRPXQYvZAJZtnQ9gGM8jOPQzY+DVh
	ILd4dqQqQe/IPYMoekEPxbzje+D0JH6xZZKdxxpqV3C4M7bhY2/XT54dddQivWyUCl38LsqTjgv
	JO8siYN6k=
X-Received: by 2002:a17:902:daca:b0:2bf:27b2:4b80 with SMTP id d9443c01a7336-2ccbe729635mr13347365ad.14.1783355922667;
        Mon, 06 Jul 2026 09:38:42 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cad7893a8dsm53103305ad.73.2026.07.06.09.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 09:38:42 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: rppt@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Chris Zankel <chris@zankel.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Rich Felker <dalias@libc.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-sh@vger.kernel.org,
	Nicholas Piggin <npiggin@gmail.com>,
	x86@kernel.org
Subject: [PATCH v2 0/5] treewide: remove unreachable memblock_reserve() return value checks in early boot
Date: Tue,  7 Jul 2026 01:37:48 +0900
Message-ID: <20260706163753.193875-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DD4B540003
X-Stat-Signature: ug1zye8j8f6x8c8scxsoi5ptmum77p5t
X-HE-Tag: 1783355923-47571
X-HE-Meta: U2FsdGVkX195k1lzEUNfsV+RtEHjTh71T69NF8SKJxk2CN+TkBDYlXMV1REPlv3nI7BoZogfKdBQZTFaxJDfet43yHZqG6t0Vn5kuWZJZMaxXZ3PFiVDeW5OZdrtyXCo+GGV118Yvs2oM7RCXW6kO81FNLXy+O7OIxj9av4ZrBESF7gWzhGx2hVDTStb+OdZ/3ji3tPO9A1+glJ4xeosPurN0nTW40WC7ospszpMe1x+dD7osBQuGVzf+C5YhC4MP31bWyA0zov+3XvZXHJaanJ03l9r4FMYXBcPUPN94YvnqBelH8spDwku5k+XCG1H2IzdZ73GXzzIhaYO/LPw/PlZtP9YMsKZ8UuF7jHl0mJnp5migMpxwDMpgWW/BC+zcpUnG4MNuANyA1eLre3QQpxZr2LWDlrT+FPuTEW+4LDLU3o1xpgiM+f9/1n6wALvNn1b0X9b3GBwv0EYYn32m2xgr+LfAU/PH0Ar0XXa+a0rMrdYm4crxn60DthXAL2z8qiToeYi4eN3NEKMYe77RgIuj5iatRlUkBLwEd0n8Nuxz9MiDOTCQpurknr5nvHV9R6s0YyOK80s21NuwJnoF3l0X/Xs9vHPeVBdFDWhG+PZJufIZ/PsO3seHSaD+twvpLOWKIUZH3XPPrMNKwjI1HNNtJeDpcXpjKTUY9RrLvj0qJ+xlRi+yDHXHV8PwsP+spgbnQ7LJEfK5dFeSIqyo6OH4SdUxLmJrH8LfZDSnA2PfYPdvXInbJDfipVNz/xgZpHoMwixhgkKMSJlnj/OUNzA+FwUA5lZz+wSwYGQctQn6yUnHdxtw1B30FdLzCrBrbNGHeT0kzLidep04MzU5HiztG5CJ0JbBCOOcB+ROJawcVnUgZOkZUruz9ScoG7SRazs72lPH020EyGUhiXSTZPirBZBKc7Fx0Lttq1fDAPrPkNNusvEDUzDVNC+JSlSGYcZQf7xIrgCeBtXgdf
 iXt46C3Z
 f/GkdzhNp6mm6pJhHkb6ezX9jhNJiMfto/VQEwXKCHbi9YT2RAH19YD4uvV4J9ssCjShdAyQ/ZUYMsN1hQoQGZIO9DJKIV+x2yGQjbPuIYU9NmmzE+4hKIlhenV5pM+Vtk/4JdscJcr7BQmo5Lo4E+2eNy6WoxYptBu9Ws/vxyn0VXCLAUmhbvL+H2aDfpFaZa2B33hr4b9TTdYKCFaMqmPdCRO5cF7SZdQ7NyBK52jCJdzAoVdt4rMrv1Ub35u4joq/zWAC96FrjI8SpJpnQujS6bwxQXTuTkdG1kHrbmBHCy96sLfmlU3azaG6k4MGBkTVLhB1A7IvsT9X9230vZw6TqHQrr5Egnsy5WBOXbqw8ogG16lordHI/lswQoLrlVRBAdTM/xmnQojppi90jw3jB9gNrXRujR9WeaDhRsEcTWwTv4syLzJ2zDi+fpxjVq2Mq9Z8twVV9TgAw4X9/GJGFnnB/AgrxqAPw/3UJHM61HLc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memblock_reserve() can only return an error after memblock_allow_resize()
has been called. Before that it either succeeds or panics, never returning
an error.

Before memblock_allow_resize() is called, the return value checks of
memblock_reserve() are unreachable and can be removed.

All the call sites are in different trees, so I split the change into one
patch per arch/subsystem. The patches are independent and can be applied
separately.

---
Changes from v1 [1]
- add reviewed-by tag
- rebased onto latest memblock for-next

[1] https://lore.kernel.org/all/20260616182959.2429774-1-ekffu200098@gmail.com/
---
Hello Mike,

Like the previous memblock cleanup series, could you review and take this patch series to the memblock tree?

Thank you for taking valuable time.

Best Regards,
Sang-Heon Jeon
---

Sang-Heon Jeon (5):
  x86/setup: remove unreachable memblock_reserve() return value check
  sh: remove unreachable memblock_reserve() return value check
  powerpc/fadump: remove unreachable memblock_reserve() return value
    checks
  xtensa: remove unreachable memblock_reserve() return value checks
  Revert "tpm: do not ignore memblock_reserve return value"

 arch/powerpc/kernel/fadump.c   | 14 +++-----------
 arch/sh/kernel/machine_kexec.c |  7 +------
 arch/x86/kernel/setup.c        |  7 ++-----
 arch/xtensa/kernel/setup.c     | 13 +++++++------
 drivers/firmware/efi/tpm.c     |  7 +------
 5 files changed, 14 insertions(+), 34 deletions(-)

-- 
2.43.0


