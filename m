Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE8DECD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 04:44:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFF706B00A1; Fri, 12 Jun 2026 00:44:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD6F26B00A2; Fri, 12 Jun 2026 00:44:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC5AE6B00A6; Fri, 12 Jun 2026 00:44:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 992166B00A1
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 00:44:57 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BF9F4A03D6
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:44:56 +0000 (UTC)
X-FDA: 84870020592.15.F015D5B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id CCEF140006
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:44:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="C5jJ/wIW";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781239495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/go128rmErNISgmXs9cmoyd/VORO9f4PkvOsc4cy53U=;
	b=oElK8CVTwyTUzmncYNX++lw0tUC3M4KyfohoTqrzqfccoriU1d57StxgnVwFRq8/rxOcsn
	lO1LN4XVl57KnDmQFCmIeab1+SvomVUBXsZK9XsDlbh23Mo107eOY+cwzt7K4FrBhxsjDq
	9fUiZYUulIjWGqQ/QzZia+9MSno+ZMo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="C5jJ/wIW";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781239495;
	b=Jbtwzrrhk+PNFyE0+EQGzs09TZlZn0T32/bVpLZeCs+mhv+GvLsUhZKGZCKrlV/ZBRHj4i
	3+myJxT0jdhym+LqbLuYQT6zzpvF9n8V6LHrqun2QljS3HiD0ZhH+gShqsqsQfvqIN/N4A
	x1LyxPoUBRg1OKRVYZItwfvvR2wchaM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D3C722E91;
	Thu, 11 Jun 2026 21:44:48 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.31])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E073D3FAF5;
	Thu, 11 Jun 2026 21:44:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1781239493; bh=SQA3Q3+/82oh45oJTME91UR/PdPgdrsuA9Fdpn4kolY=;
	h=From:To:Cc:Subject:Date:From;
	b=C5jJ/wIWZzhIUGdGO9T1hGV6rroAbSN3pDV9MfJilf8tLHrAckiL0S/LKO41BXhZH
	 TcYl95kWuiBGL2H9XMsb2TGyjHPdch3DNT1yTG9y+K52Dm55IzVzSy+Ru4qjMsWBbB
	 MevnQMAJu19h7w8r6XSGIR3dzkoJ3W1yPt0WeTnE=
From: Dev Jain <dev.jain@arm.com>
To: ryabinin.a.a@gmail.com,
	akpm@linux-foundation.org,
	corbet@lwn.net
Cc: Dev Jain <dev.jain@arm.com>,
	glider@google.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	workflows@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	kaleshsingh@google.com,
	21cnbao@gmail.com,
	david@kernel.org,
	will@kernel.org,
	catalin.marinas@arm.com
Subject: [RFC PATCH 0/2] kasan: hw_tags: Add option to tag only at allocation time
Date: Fri, 12 Jun 2026 04:44:22 +0000
Message-ID: <20260612044425.763060-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CCEF140006
X-Stat-Signature: k1nhzhrbwwnwdsmxs7fydqeessami3om
X-HE-Tag: 1781239494-967116
X-HE-Meta: U2FsdGVkX1/8rRtlQqsyLrTzkaNI5pKtDcmwW0gpm1tsAEfwrVC3OMRAPMiHUiMvQsJyIAd7h+O121IQaG0wHy7zgKy7lOAq3cllvzL48IIkQVZm08brg1cv3pRAzz7eCu0gS3E0Tk5oEy8H0Mk9U9jhvjQnEMwvOfDZErrpCqfNGYrxEoH/yqjEu/pawV/Uasy7i25Wman2cCbZjkJtKgV03ohZ3gCDUxQWDns7jqDVXonI6w1mAr9gkGfHoi8P5eNjZSUv+sKfe9OK6mTFUSj7xenXlrpYmbN1vdj1VHvxQUY/lXJwYVcugLgW6ni3Jvmb6Fc//dTvFmdPJoboweR1JPtdvVZdO+FCXCGEuEvRzuejqqkcL7nNS6ma4FPySnJNwOeClzVrH1VRGvlM3gCav9ryVeEhGoYbHWtTt9HUdzYtkDoB+VvN2t3D8dp3pP0H9DpPl/Klq2naYNgXt4sy1Yz34f+XXLGVSoa7x1li1UolFu4a1efslpUs/vw4Bko6ryX9HoVU7PqABFSgq58IR9sjmO0xO05piyPQ7wbGwxfETC7NyOEbOf95QtPTsCoFYcBgC2cmoO2iYnMI5X5tgeO7lWzJcVYD5pnYQTrLKHn0tVEKvIC8HV1YBKENKB2z0rU6eqgGJz9nhbOP6iZUeRgrLJgbdU2VylDXT/ZqUHsrJjRdl5hJro4mSKDqPfFOw8FVF7gFaUS36ctkpgRwkJXS2LdWwVlCCKrj6UVl6USvSLDeVdWhLYOStkQQQVHosxS5KG8Lu4xjn7WwOv5XN3n/7jaq2Q3nhEtzwMfJYu3dRt0hBizlw1zEI6blYwnHqCBucONR58wZ+U0bpg5xJxTrMS7Aagh7/9V5ivcQBgVX/fqR16DNTix+GdFw8kWiVV7ByYdxkLGSPxtOfIkA9J7K5tYn0EI5kEUFMItKYulLiR9CwP5Nfe2gaBodd8QSEo9HYVmPRsarqp3
 WAUImRxv
 ov22/5/D/XVkS0XzDYFum3odJfPIiMuT9Bn+B5cWhaIZj/G2tXOZOSEoTfvfeuvt+G4Gw7HNRuwKxkhAlschVM9H8Z4BBMszn+w0Uhc29VgNt9Ncxd8qPvUZ+434mXtHr8wnfq2NOILPNtlEcpxmRySfTLj4ERTVgUoJeJXEttNPcfAxDvW36UCGoezizeAaxLd2tjPaSP0kPIHrA2wArgJz7I/a0vZJ0+ECIdWlMgc71An9WY51V52Ox5L2nKyl+2iwGQwpRocZ3MBfPVTSuSzIYhtvlYhdFOAYxw8jgGC1srqFh2tfdK1upCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a boot option to tag only at allocation time of the objects. This
reduces KASAN MTE overhead, the tradeoff being reduced ability of
catching bugs.

Now, when a memory object will be freed, it will retain the random tag it
had at allocation time. This compromises on catching UAF bugs, till the
time the object is not reallocated, at which point it will have a new
random tag.

Hence, not catching "use-after-free-before-reallocation" and not catching
"double-free" will be the compromise for reduced KASAN overhead.

This is an RFC because we are not clear about the performance benefit.

Android folks, please help with testing!

---
Applies on Linus master (9716c086c8e8).

Dev Jain (2):
  kasan: hw_tags: Use KASAN_PAGE_REDZONE for vmalloc redzoning
  kasan: hw_tags: Add boot option to elide free time poisoning

 Documentation/dev-tools/kasan.rst |  4 +++
 mm/kasan/hw_tags.c                | 45 +++++++++++++++++++++++++++++--
 mm/kasan/kasan.h                  | 23 +++++++++++++++-
 3 files changed, 69 insertions(+), 3 deletions(-)

-- 
2.43.0


