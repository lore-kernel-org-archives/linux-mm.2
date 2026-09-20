Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5876FC982D8
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 19:39:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54D4F6B00C2; Sun, 20 Sep 2026 15:39:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 524CE6B00C3; Sun, 20 Sep 2026 15:39:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 413726B00C4; Sun, 20 Sep 2026 15:39:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 19FFE6B00C2
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 15:39:20 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8C7951404A9
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:39:19 +0000 (UTC)
X-FDA: 85235154438.23.AA784F7
Received: from mail-yx2-f30.google.com (mail-yx2-f30.google.com [74.125.224.158])
	by imf15.hostedemail.com (Postfix) with ESMTP id BA17FA000A
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:39:17 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=aO0qUxfj;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.158 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789933157;
	b=nquw8nEzspXURpi1JSCwS7ARaay6cZFsGw5/2hydA3PXs5grQfQX91ep1XcZqQEYfU4FVj
	kWR/N9l0tihefr50jvcJqv8vR8EuKRGp84bIBTSXk2/QRv5Z5AJvMSUQ1reOjDXRdfvWCK
	p3JVYsbU15gDWU9DwmKQwcMAhkpALO4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=aO0qUxfj;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.158 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789933157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GOyD94xneAEU7+yzaxi3P4vCBB/CkWgVuLYMi+o49fI=;
	b=yWcsneKFT5SDGwuArx7lPrUfZLWYrauQ+/PcY4hn1baZD53hsCr0P2kSS20bc/cfv7PtrV
	zf9jGvt6FbgglXWzi4TAMjvFfQOjbuV+r5BvuaJ3B3ubBJTT9lfN6cZbEOv6Qfi8FNNoCk
	QScoEUYwighW6m6tIdQB7w4ED9x3lL4=
Received: by mail-yx2-f30.google.com with SMTP id 00721157ae682-85d440939efso18018327b3.1
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933157; x=1790537957; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=GOyD94xneAEU7+yzaxi3P4vCBB/CkWgVuLYMi+o49fI=;
        b=aO0qUxfjf3ZvHXpWL7PMVYuOz1Pfu5V+/BAG1NDq2pfnGER+Pn3H5fk1X9NomIqvKs
         kdhfU264pN5xkEWUgOlWx5oR5Y8iW5pq7IlS/kSSkOEl8wheE1VUYveMbZHgig3VIq0S
         wBdqEtXPN/5RfmEMA/yiPgDQ8fOinyIp5dfrRW1rIlOaS106VD6AOTTztBvimtJk1CJS
         IP5G1/e+YPnnnWcZvHfgD3dsYeu1HtwnzxE67wp4UF17ILhG0S7uoLHQdUDow4AznH+P
         CRqA4zVbAd/vFE3gAcqvLLb9rj5D9SENPHjE7/uHY2TxcCWn58Znpt1TuJwWDUgs50j8
         Pr7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933157; x=1790537957;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=GOyD94xneAEU7+yzaxi3P4vCBB/CkWgVuLYMi+o49fI=;
        b=CSKjRmvbwUsm4mMqXB5PV2P4DqKke2cOd7ugQptCc/ffVwZkoTGJhRtRjniuXEK5XF
         1Kig0TwDPrHrifZGX06CgSK20/Y8ZlJXheRwtmlpDPRqlKKAo/vG2k3T4ikapPnhd4wm
         jb6hCVRPYlxwsO9yEVAUQommL3G7Ggy4mzejJo1E7M7LCuDtaUvg562hkvfBRAOuIQ6d
         GQ/PMLeR2KrBlK2tqZXu4o0V4uscAKRU2LMR0K1s0rCHmco3Uzg4ps2e0q6nHLr74u9h
         L9b+50o0w8c5MkAFhF6opr9L/iRBlxDBfXMiW0v8+uZ9OQLjO01u/mM6LV6oqGbtYR3W
         mVXA==
X-Forwarded-Encrypted: i=1; AKwUvBxOn+vxCBDlryEEpYkAX9zc1i8IwMwOxxtQu8fPY4w1CJLB9h1sTY+RfGGG7tYz86GITJ+qFeUMog==@kvack.org
X-Gm-Message-State: AFuF++ltFkNMAlmUt69WMR8xwVx61EiiQShf4F+PemnpAPNMbE1J8ipH
	2TzLcc8RF1NTVJUftmnm/f3B41ku4h1cwu/VN4GQUN/eRlEr5oxD+Ys3XLmIuBSwfNQ=
X-Gm-Gg: AYBFou2GieEuZhimaLiz8H4pHI7FOGr4GhA1I+04FdPpbIp33kAIvDpGTtSy+j6gt2/
	GGc4a3TYi1FLUonuHErlJRWcAanWWRisnLjY57RXhyBzs/o0YO0kBJdu5HORbBadkJUtQ/OG8XK
	FXY9LceJ6v8mKIoApygCW2BgZFQJcWVM2Z78A346p58MLxUdPqsk2eSgVlMivDFaAkOoFLe2cRq
	lejryt75s4KQayZfteTKXWTTV9Tk4xYnjjbmRY+WLzQwvo5TzyMYe+4dSV2CymGRHEhqV90ADkA
	H9KOJt5oaJ7WIh8JXFRpFKQT6E7KsUGlumva0FSC9s7300Tk8ogAw/LCaDIGDkAb8P1rGqwbxFf
	HD+qtFndIK8oN816TRyjIvKuHUMyeV/cN1UKYFq28RDsT462GBZxD/h6WwWQbGY5xQYuQ78wlXe
	RmW6CotS+K43/i+dXy/AMFff337YEmNDIBtpWnAzqY9UP+BhDGsbW35BgNfX2apPPQyeqX/mc0+
	MaNvVnCM3ZqjeY50pBTZrrHIWL11PYiieu1qL7NfojI7QZCtti+8kB1Y6WSnthNVeNb0D0LVO/T
	Ju8TsRAu3hEEFgDUXoc=
X-Received: by 2002:a05:690c:e3cf:b0:845:ddf4:a399 with SMTP id 00721157ae682-897308f89e5mr31680887b3.11.1789933156801;
        Sun, 20 Sep 2026 12:39:16 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-89a4761747asm18686667b3.30.2026.09.20.12.39.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:39:15 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	legion@kernel.org,
	kees@kernel.org,
	will@kernel.org,
	ruanjinjie@huawei.com,
	atomlin@atomlin.com,
	rppt@kernel.org,
	jani.nikula@intel.com,
	hamzamahfooz@linux.microsoft.com,
	joey.gouly@arm.com,
	tglx@kernel.org,
	nsc@kernel.org,
	alexandre.chartre@oracle.com,
	james.morse@arm.com,
	dianders@chromium.org,
	bp@alien8.de,
	jpoimboe@kernel.org,
	shuah@kernel.org,
	catalin.marinas@arm.com,
	linux-kbuild@vger.kernel.org,
	linux-arch@vger.kernel.org,
	kvmarm@lists.linux.dev,
	jaredwhite@microsoft.com,
	johan@kernel.org,
	pbonzini@redhat.com,
	mingo@redhat.com,
	linux-mm@kvack.org,
	seanjc@google.com,
	mark.rutland@arm.com,
	vdonnefort@google.com,
	tarunsahu@google.com,
	gshan@redhat.com,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	xur@google.com,
	djbw@kernel.org,
	oupton@kernel.org,
	nogikh@google.com,
	sumitg@nvidia.com,
	linux-kernel@vger.kernel.org,
	zengheng4@huawei.com,
	peterz@infradead.org,
	corbet@lwn.net,
	suzuki.poulose@arm.com,
	luto@kernel.org,
	hpa@zytor.com,
	zhangpengjie2@huawei.com,
	x86@kernel.org,
	yuzenghui@huawei.com,
	jic23@kernel.org,
	ardb@kernel.org,
	pasha.tatashin@soleen.com,
	petr.pavlu@suse.com,
	ryan.roberts@arm.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	rdunlap@infradead.org,
	kvm@vger.kernel.org,
	fuad.tabba@linux.dev,
	maz@kernel.org,
	mbenes@suse.cz,
	jgross@suse.com,
	seiden@linux.ibm.com,
	pierre.gondois@arm.com,
	song@kernel.org,
	nathan@kernel.org,
	pmladek@suse.com,
	graf@amazon.com,
	chao.gao@intel.com,
	zhenglifeng1@huawei.com,
	arnd@arndb.de,
	sidnayyar@google.com,
	linux-arm-kernel@lists.infradead.org,
	vladimir.murzin@arm.com,
	kas@kernel.org
Subject: [RFC PATCH 24/46] MAINTAINERS: Add entry for KVM Caretaker
Date: Sun, 20 Sep 2026 15:36:28 -0400
Message-ID: <20260920193650.3373435-25-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BA17FA000A
X-Stat-Signature: 6s39krafryqxiyoza8oyf1idniysfh7s
X-HE-Tag: 1789933157-212818
X-HE-Meta: U2FsdGVkX1/SP2y1hyf0RHCj9pXf2yUGbDyZ/Uyn+DogsFy78wUW4ph4tzJTqxIxX+USHQYjPUZGv8E2lfqj0zIFmnuq1f4oWM0eqVOX4aKfK/ElCD1aaayHLRT2O2VsZEO4rvLBuqo7V1OXeDp3Tssu89zq04110ZrQksv99RZv22LJGIlDxpm0DRhXD6m9BDrFRXr/RmX7juNVA48J6HqGyScxe3IlXa35kLPsB6CFTP6cHU3N0qymbDy8ASLBwD7Ub2Grx0I2LAKrxS0KU64zYweLI9so1I6Iky/1Z/QJ+xKXHpwskobXhfcllHt7YomjD1Iy+rz76ems6VtHRo1KFEFbOfbr8Nu8OCqq41zqRnRwF7V2dgFYdlVW7EAuQxX7AZYlWhDfMllvGeJsX3A9blzeiJpxeez9s66EmG7UOFq4XS6KpmTepdKaG42ENKVdB8T6LNRWSI3KcneEHkeFFh5DXYNpHdcyotPzbA4qYzNt9MBmdRAjTiKy9Za++zfo/oDe45pZ3BjoJINZ1JfvrGh+tj40FKmTgWgAszCGZgxyYxes2mVfH0Kq2BnFa6Sx/uSPHegGYRwE+LltIiiPFCqrG7cD/xcze+JQEWWzSAab64lhnZ7zbXNYmb6n2nNaLSF2FWDhPUMvPudrDEBKgiZko38Okt3a2p61oUSq76qb1R+aE9KSK0QmfyCX4ySobxKDtjqvpMmKsO8RoRRrqjY5pvC9nkSqbDX9r3VzdzX7b8TrFagsHaPwwWN6xFn5GSRYkGyoOL7TJuBhe5fXW67wzDmsP7pHA5JFBZmxzSawjizJHUhqUpHjIHWQageY/q7d+uwsnLrZAEE7TLaBh0AVwlMY2JuRDPcJQMn1MOd/tp6mCkX/tIcTKW4+RqX4cgM0Ok0MYjvP0DHNp6XmfP0ZyYx1ASfqqWaEHk/ElsllK3rIjZEO/bq0yS138lWM8ZHCQvBuYX+n2zR
 WoY7BlPh
 kP8bubdeAZUvu8+6L/p5dwrl2pFw/fW8RniDIAmZsS9X41EDZl2KRwNdyVaK+gvYixVGYxjcqFsuHZ5ILHM5mtFE6nyVj/JL3emjQRNBClJh8q45I87OZtY1zwdzZVTSWi5T9grENs9HBKiDwCd3oBz4f3dnDahOxzuotfEKbUaasmCW2T+Nmmkpsp7QyriQ+mKL5DrxMIvFW6yWmPyGN2UbSvPFlT/NyX1l3Q859397x7YE6DSjmXDpGyKA4o4axL1F3zipyMZdRps5Yzl3+tBHF0u7FYxVpK49yQoOmqbUVCb9demoXFgh2l+szY4sOi+SeQhwO0VtAes4/3HE35KaLB8MamMMdPBG48W9dRDrxQIMrURHYghL3QOvwi3Wk8kvEX00ic+ObhiyMmbQUykVzsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add KERNEL VIRTUAL MACHINE CARETAKER section in MAINTAINERS covering
Caretaker headers, architecture backends, and core execution files.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 MAINTAINERS | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 23f332cfbd16..86806245041e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14296,6 +14296,17 @@ F:	tools/kvm/
 F:	tools/testing/selftests/kvm/
 F:	virt/kvm/*
 
+KERNEL VIRTUAL MACHINE CARETAKER
+M:	Pasha Tatashin <pasha.tatashin@soleen.com>
+L:	kvm@vger.kernel.org
+L:	kexec@lists.infradead.org
+S:	Maintained
+F:	arch/*/include/asm/kvm_caretaker*
+F:	arch/*/kvm/*caretaker*
+F:	arch/x86/kvm/mmu/kho.c
+F:	include/linux/kvm_caretaker.h
+F:	virt/kvm/caretaker*.c
+
 KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)
 M:	Marc Zyngier <maz@kernel.org>
 M:	Oliver Upton <oupton@kernel.org>
-- 
2.55.0.1082.g2b9226bbc0-goog


