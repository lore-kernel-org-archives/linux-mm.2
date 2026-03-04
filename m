Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4AE3EF8FF9
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 15:35:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3242E6B00A2; Wed,  4 Mar 2026 10:35:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EE7F6B00A4; Wed,  4 Mar 2026 10:35:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EDD66B00A5; Wed,  4 Mar 2026 10:35:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0923A6B00A2
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 10:35:26 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CD9541605FD
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:35:25 +0000 (UTC)
X-FDA: 84508779810.13.3A6327F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id B623E1A0019
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:35:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PQ79D0uP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ardb@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ardb@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772638523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cpimJVQAzg0tkh/rMhO6VGSMsFgeGaZyD/TZqVZ4MPA=;
	b=n6iwfHN+1QgVdKOpg62lgKFMMG8i4FALsU8yZXFZ+1b1eEIEWmG1e7d2av+FL4FMH0+ipQ
	EPgaStox8QcCgVJHHppWiExanMCCUAgQf6XQbwpVXp52MCKi2G9ZFE0Vt2ESwbHTYdwrSN
	lrSK7D+CopGtQJ4L7pycvmgqXuW7LZo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PQ79D0uP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ardb@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ardb@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772638523; a=rsa-sha256;
	cv=none;
	b=Av9dTe3jv9ukwdih/KdVhJX5rCeah3s+3gGvVaA8zBxdaSPedq/KRuJAwdam0+a7ts8KBd
	I46kcMC/TmnNpeMIp/FkChebWUOwCiYha3JMQha8r9sZEXQ3JcVlR6M9E1+l2wWrptnVEd
	ql/qB9Cfj3FyU1SlPrdW1DyNxUD+6vg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3FCA861336;
	Wed,  4 Mar 2026 15:35:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8132CC4AF09;
	Wed,  4 Mar 2026 15:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772638522;
	bh=lj0Pz9TkA8wMfvIqwopRi6nT7hU93c7m1ZyRNGoTF7k=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=PQ79D0uPVur1I/JzPUtC/Ge6V7LNj8a+buEGlh4pSIYahKAeI5bC+v6D8nOHBLCMP
	 nNV7sCH0v5asB12D4zPI0GYeV1wEqfhcSTm+kf6Gz3DIZdfoBJ2XXBvRuUVGfi3I56
	 ljgVxBfHg8qt8NYol2ypteWpDoeJEL1cwj0M6gLhME3nNyqydNJ18yuncw9KdMop+a
	 sB1ZcmaNF3NCKHgJroF7WvArPZ/BB9MiB+plOvGDqU+ew06uvFsYKKFAjtXXAZgLt8
	 Bqc9icxgTgdeC7AK4zJfsN4v2JIS8lJgKWZKqIMa+1KCXhnnwir5Rd6RsDfLAnmj2c
	 yt6G0jS8cMPJw==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 878ABF40069;
	Wed,  4 Mar 2026 10:35:21 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Wed, 04 Mar 2026 10:35:21 -0500
X-ME-Sender: <xms:OVGoaU-GLJssz3YlKWJHxbryAg3Mn9Y1wMBeAbTNIh7mcTVHvlBOHw>
    <xme:OVGoaXj9AkFdulceWnhVBkEbV83QvCvNgH5SsVrpe5peh6jC-qM0KWwqve1aAFuG7
    C7Vuz1F8YOglwu8YZAExknXK2apaQISmlI-BU5d-pfwWKsCnBAXkFo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvieefkeeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvueehiedtvedtleekuddutefgffdtleetfeetveejveejieehfefhjeei
    jeefudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhguodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdehtddtjeel
    qdeffedvudeigeduhedqrghruggspeepkhgvrhhnvghlrdhorhhgseifohhrkhhofhgrrh
    gurdgtohhmpdhnsggprhgtphhtthhopeduvddpmhhouggvpehsmhhtphhouhhtpdhrtghp
    thhtohepphgrlhhmvghrsegurggssggvlhhtrdgtohhmpdhrtghpthhtoheprghouhesvg
    gvtghsrdgsvghrkhgvlhgvhidrvgguuhdprhgtphhtthhopehgvggvrhhtodhrvghnvghs
    rghssehglhhiuggvrhdrsggvpdhrtghpthhtoheprghnughrihihrdhshhgvvhgthhgvnh
    hkohesihhnthgvlhdrtghomhdprhgtphhtthhopehlkhhpsehinhhtvghlrdgtohhmpdhr
    tghpthhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepkhgvvghsse
    hkvghrnhgvlhdrohhrghdprhgtphhtthhopehpjhifsehkvghrnhgvlhdrohhrghdprhgt
    phhtthhopehlihhnuhigqdhmmheskhhvrggtkhdrohhrgh
X-ME-Proxy: <xmx:OVGoaZXi0YeXJduP9NY19WM-5e4wN2a5n57lD3z0hY9VeG3db93rbg>
    <xmx:OVGoaRspSqiqAg6Q-zTr8gR9ysJ3UU_HbpwQbrk_t0qMxvKFpLja7w>
    <xmx:OVGoaU7Q_mBhtX2DgOD0n3k8LmCUR2iPLs5qOPyli-v1kt5J5nSIFA>
    <xmx:OVGoacRD9zmODc_tHhYkrw9EWwqcm5EZUcepTMdxX1qS0SxFk2M08A>
    <xmx:OVGoafsTysKZ1bWOpeXrR9p5o5fiUTFsYk_Fg7ObybbLu_4jv3Zsj_Wh>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 3E9E4700065; Wed,  4 Mar 2026 10:35:21 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AFCgwcuzDHfo
Date: Wed, 04 Mar 2026 16:35:01 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Andy Shevchenko" <andriy.shevchenko@intel.com>,
 "kernel test robot" <lkp@intel.com>, "Kees Cook" <kees@kernel.org>,
 "Paul Walmsley" <pjw@kernel.org>, "Palmer Dabbelt" <palmer@dabbelt.com>,
 "Albert Ou" <aou@eecs.berkeley.edu>,
 "Geert Uytterhoeven" <geert+renesas@glider.be>
Cc: "Dmitry Antipov" <dmantipov@yandex.ru>, oe-kbuild-all@lists.linux.dev,
 "David Hildenbrand" <david@kernel.org>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Linux Memory Management List" <linux-mm@kvack.org>
Message-Id: <529d4fa6-e163-4b4b-9c51-f9f880492b76@app.fastmail.com>
In-Reply-To: <aahAgJ0G1uYSCFnF@ashevche-desk.local>
References: <202603041925.KLKqpK6N-lkp@intel.com>
 <aag95SSwClx4IzJU@ashevche-desk.local> <aahAgJ0G1uYSCFnF@ashevche-desk.local>
Subject: Re: [akpm-mm:mm-nonmm-unstable 49/110] __efistub_cmdline.c:undefined reference
 to `__efistub___lshrdi3'
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B623E1A0019
X-Stat-Signature: pksyjy4zs16xub3498pb3uyx9t5di9fs
X-Rspam-User: 
X-HE-Tag: 1772638523-721821
X-HE-Meta: U2FsdGVkX18/GLdfFO5Z4Etoj4U5jDY48AKqJV+XiHzAQe/x6opO5Lomy1nEkUO8g9i6csXU244ZYKnBjxEhGpYGnPyVmKP8BdY8SEvGqUHEL7TFHnIqIL1zpsIFf2ZVv1+eHX+e/PkufHs58HOm+RfxA0boMgIRqQBV3dhmPqpoJ2TYL3s4K27GqP3fW/U/LmWSLzCYa/zvc83z63qT3kn45wpgGKKep8UX95k2xKXC5BEnor0cLzsQOz0NL2qp+KsMNwNRpII25rMaG9hZ4vdqnud0gy06DS504PACKjbhKcxsKQCCmEmRII9I4DN2FoMsc4F0MM3rVrax6LZjNiFEruXhVzSWTu3qNcl98BWkpGMssRulojMXemMf0siKtHYpucOq95v0VhxTh2wAGBlNt/ExAHTUzBDR1gmRQK5RfXOHwKAMeIrCJsAePpTffzmbeQPCkJJjkWcnASoLSeu2Ui76T+QLsNEUD6J7Q+8Hlh7KCjbeaoagCV9mrZGJJId8qKLP5qtetBEyYbVrH39no7Zg1jG9qC3lTqxYM+ADK34N+W0kv0CN9rIIRNJTgLEQHJUXLKJD1FFGQnHcem97KVaJZs1tBppVk69eHFO1b07HoExxmSYutMnPxux8HdAjxT8IQT65KF1X8uVgLlEC/UFQfQpqcQpPo1ZUxTfr5s4dEjgybSTEt/iuKcaWO4Dpztzj1WonkwcbYmBHb9KZANI4oOIDU5bf7CP6IehelN7lEzJX7HFnQNpKO9c+46xwLcpc1fgtDO/QsYJ79eWVSDuquEUw7xaZJpD4THZjdFAZLC9XCQtjiJnS6SSFKfFqGZM5VFnpYSa8IvFk1dRp5e3px9+wm7Gedq52LC0Je0oNaOJpfy5fn0A9/bV23O1uFYLA7938mnEACHbFKXU/12uiqrP1snfDKmGpWJ2Mx09FZxcsqznQ5mLZM3f3s7ScxrsAIUIDQOSEGrt
 1CYz1Q6r
 VS633hIW3z7XX7Y6werwrkkDeOsQZdXKOTHmUJFSLBB0B26fv2EvWSk6KkuLWaT1qS32rdygKop2ATTTZaNgPtJNL//C1BVOj1SmRod+oCyvDbXjGEei+ffUJVQbjKgyJVSOlmZSGOWzCcPbyQNxwvcHYKtHPGz3xSdA0Fhqh+qr5Je07K+SuGXy25U5ZAi8MJv3N1exJXS9G7/LDpU6PfRKslkw0Dh2k5PfcHvVqJwpbiEQR8uMlAfpj3Wa49Fn+wjrvzSMIF1w7RfN3Kv1yoFAgC++qESVwn92+o7w9O+rPFzWKUWXBLMT6uwzz8ZTto37Ob5cOYLqwN9uJuQsu9tHTNrGqzj44dAbn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andy,

On Wed, 4 Mar 2026, at 15:24, Andy Shevchenko wrote:
> And since it's riscv, adding people from there.
>
> It might be that they simply need to include the corresponding library to their
> architecture builds (we have lib/lshrdi3.c)
>

I didn't manage to reproduce this, but if EFI boot on 32-bit RISC-V is really a thing, then doing the below should be sufficient. Alternatively, we might just disable EFI boot on 32-bit RISC-V, as I don't think it is likely to be used by anyone in practice.

--- a/arch/riscv/kernel/image-vars.h
+++ b/arch/riscv/kernel/image-vars.h
@@ -31,6 +31,7 @@ __efistub___init_text_end     = __init_text_end;
 #if defined(CONFIG_EFI_EARLYCON) || defined(CONFIG_SYSFB)
 __efistub_sysfb_primary_display        = sysfb_primary_display;
 #endif
+PROVIDE(__efistub___lshrdi3    = __lshrdi3);
 
 #endif
 

