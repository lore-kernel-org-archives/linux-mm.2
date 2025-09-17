Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72887CAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 16:24:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D22898E0057; Wed, 17 Sep 2025 12:24:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD2848E0002; Wed, 17 Sep 2025 12:24:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0FDB8E0057; Wed, 17 Sep 2025 12:24:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B0E768E0002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 12:24:18 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 56542140611
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:24:18 +0000 (UTC)
X-FDA: 83899264596.23.71D2A46
Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8E6EA20008
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:24:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=weissschuh.net header.s=mail header.b=TgrRAWqJ;
	spf=pass (imf03.hostedemail.com: domain of linux@weissschuh.net designates 159.69.126.157 as permitted sender) smtp.mailfrom=linux@weissschuh.net;
	dmarc=pass (policy=quarantine) header.from=weissschuh.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758126256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vjx7+DyrbF0Flw01KLBFaM/TSq+PyoTjffcNltVfg44=;
	b=Dz4GyRPqsl+k8RHy9fsYbNkWk288ltkjrksG6moRAOPEp8BIa3fzOrIIFTROB3mwMW8bDY
	XezPelDGq0DPMIl+QqjcUjysMsGKj+NdOMhOVLqZ/cyzFnhsYT1/AcoPjK5fk35/bsMfVb
	WrcoWkoeMxLiBgsFd431uoXvFtKesU8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758126256; a=rsa-sha256;
	cv=none;
	b=ELRBvYGHYRyCLlBLvb2L9lE2hSp6fU8tO5X0rI0wlddaNgcW+tdiRegMM9rMG8e5kJDcCR
	ADNmFikP4zJHeCsFRU2HM06pf8Asl7oIEOMbb8kMs2qsOHbHclHFtJ1aARnDSc++8EmKt3
	8+tHrX/W9UaVtQIx349tQpaG4/z8vUQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=weissschuh.net header.s=mail header.b=TgrRAWqJ;
	spf=pass (imf03.hostedemail.com: domain of linux@weissschuh.net designates 159.69.126.157 as permitted sender) smtp.mailfrom=linux@weissschuh.net;
	dmarc=pass (policy=quarantine) header.from=weissschuh.net
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1758126253;
	bh=ee0Fihprx00Irt1b2uNyIYyx46h/WRE1AhiXBYr0/Xg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TgrRAWqJvWypJvGtCRQDXPQqq59D7Dqxb2bVm70spnRUbnCk6qdM9RrExj3dlcXNW
	 CSmuaEmg5E2735yhs5qryPq4U2Yd4DwpC3uEjUv4Aqp1SpSjl3QH6pgEnNg670qpbl
	 UYGnzvDBOu5eSd/CGusWWHOEUdGQs0d5diZ18l+E=
Date: Wed, 17 Sep 2025 18:24:13 +0200
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, 
	Kees Cook <kees@kernel.org>, Eric Biederman <ebiederm@xmission.com>, 
	Shuah Khan <shuah@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, Andy Lutomirski <luto@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Willy Tarreau <w@1wt.eu>, "Jason A. Donenfeld" <Jason@zx2c4.com>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH v2 16/16] selftests: vDSO: vdso_standalone_test_x86:
 Switch to nolibc
Message-ID: <1f64966f-ef7a-474a-9641-561b6b7cb0d2@t-8ch.de>
References: <20250226-parse_vdso-nolibc-v2-0-28e14e031ed8@linutronix.de>
 <20250226-parse_vdso-nolibc-v2-16-28e14e031ed8@linutronix.de>
 <20250917153209.GA2023406@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250917153209.GA2023406@nvidia.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8E6EA20008
X-Stat-Signature: hpjoghwe6idazhufjzsxdnhkf7wwop4u
X-Rspam-User: 
X-HE-Tag: 1758126256-174486
X-HE-Meta: U2FsdGVkX1+YOGSEjw80tiumlvuNF+oHaANG0fz51WtHqrFkzb9dQVN2HznB9uL2HrPfffC6A7LX7hn4RSn3z/XK2vqfZ/BDfJSfv6vj/GQ0ioRqevFv/GthxCB00D8sZxKDsmtmzMqnkSBXog+E7rP+3UCSOIKiKY4aXlkKTPlLkvjdOMN9kw+xBo7Cr5vBTNlBWmBloa/mnWZhOC+eP92221o8HDs/sd82oisAbSP9Wl7K1GVOG2EWmCS+YCeNsnvwBnaJRi8vFTOUhmOngtbHoEV/LbHYFw8+BVC2Mzr2D4uIm4C+2jL6fg8Q1b2NdAAlQXySNh10S+cakWpPzpRgUrpY3jBtvS6WBBZYvq/e7HSip/9UT9BGlsJehOBj7pNl2Ug/nds4ttljqvOOPkoTKSS6D3lDqy9u/7EY/xWNXOiV8qeXN4X18kBF7hI3kq/Ag6n17Ze6XuHCpxS1d9Hd6paRSXucU7A5NdmMWUoQA8LM6pVr0vQYYfbFjLF0XPpi/CDrrU/fEHZeZCeDcMmsa/FddP8WoL2YvjM4ucVQsFMoEvP/V9L5+IZYa0Wiy8fRfWqVfiYq2CnQp6sw9QLtzFq/YLh1ZmsIo7sok6vyDf0O5ZczofvLwtWVQDbAASu0jnmf8yySVzOzIg3HIiqjolslQTYJ092o4waMIkIX1MV2p0pHGcS59lWc4kOUOHfyFxns+CCMDmBW3+JnE0odiv8LtbH4N1baeQQEAws3VGp/IfkLF/oczC7FcxjcupYzHzj5Y+xJxunjPMFsOLQ3jSj7+v500fSV8XoJtK+i8/fcg28PvOfiZrTUBLE0ChfdkD3sZqehB4b8l0HpPd3U28GljZPhya9/7oUD7W9SBq+ZJ+x0bjmtKRrnw2Id3+FR2ecXyPF72id5+ol8ffivq0LLhpUNy98sNfWzu3n524/GkNlj9zhrer6kZ+56SfMbC/PmueP5B8jflH+
 T5ixAIQw
 m3HaiaqsTDUjKXO+UsmTFVV9xh0dO+EtdnF1ydxfNaiW0F7eXyQhMoHT7Ku74+PbqrBq8uYran2o/z8dfi01MZcsDqxIBAnoxpC0m4T9+X7EVmLN0z2dKsKKzuzPRWPmdAtIQoHimtuHFrgvilpp3lKKSnmIsVnXhOlKQRwx6mP5uohBY5moHPnT921rYo+cQWu2pmgxtxdjxKGI5VYYO4XR2bvQnZcbc1whGFHjpwLG7s4w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jason,

On 2025-09-17 12:32:09-0300, Jason Gunthorpe wrote:
> On Wed, Feb 26, 2025 at 12:44:55PM +0100, Thomas Weißschuh wrote:
> 
> > -$(OUTPUT)/vdso_standalone_test_x86: vdso_standalone_test_x86.c parse_vdso.c
> > -$(OUTPUT)/vdso_standalone_test_x86: CFLAGS +=-nostdlib -fno-asynchronous-unwind-tables -fno-stack-protector
> > +$(OUTPUT)/vdso_standalone_test_x86: vdso_standalone_test_x86.c parse_vdso.c | headers
> > +$(OUTPUT)/vdso_standalone_test_x86: CFLAGS:=$(CFLAGS_NOLIBC) $(CFLAGS)
> 
> This addition of "| headers" breaks O=build builds. ie this:
> 
> $ make O=build-x86 allnoconfig -s -j 14
> $ make O=build-x86 -s -j 14
> $ make O=build-x86 kselftest-all -s -j 16 &> /dev/null || true
> $ make O=build-x86 -s -j 14
> 
> Fails with:
> 
> ***
> *** The source tree is not clean, please run 'make mrproper'
> *** in /home/jgg/oss/wip/kselftests_dirty
> ***
> 
> Because the build now spews stuff outside the build directory that it
> should not do.. Bisection points to this patch and removing the "|
> headers" makes it stop doing that..

Sorry for the breakage and thanks for the report.

> Any idea how to fix it?

Care to try this:

diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
index 530390033929..a448fae57831 100644
--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -228,7 +228,10 @@ $(OUTPUT)/%:%.S
        $(LINK.S) $^ $(LDLIBS) -o $@
 endif

+# Extract the expected header directory
+khdr_output := $(patsubst %/usr/include,%,$(filter %/usr/include,$(KHDR_INCLUDES)))
+
 headers:
-       $(Q)$(MAKE) -C $(top_srcdir) headers
+       $(Q)$(MAKE) -f $(top_srcdir)/Makefile -C $(khdr_output) headers

 .PHONY: run_tests all clean install emit_tests gen_mods_dir clean_mods_dir headers


Thomas

