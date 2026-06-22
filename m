Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E2EACD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 10:40:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE8A66B0093; Mon, 22 Jun 2026 06:40:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9A566B0095; Mon, 22 Jun 2026 06:40:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D61226B0096; Mon, 22 Jun 2026 06:40:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A3E046B0093
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 06:40:06 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 38C6D1A0630
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:40:06 +0000 (UTC)
X-FDA: 84907203612.24.92D0022
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf13.hostedemail.com (Postfix) with ESMTP id CA19920005
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:40:03 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Nr2pAkOR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="AGIoKqh/";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Nr2pAkOR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="AGIoKqh/";
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782124804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NkRuo/RALBae4rTRv8OE22ZA7JcrZTDytq9aKv/jWx0=;
	b=tAEDFjZoi40gef8UYeL/s/SVgxbMapRkAw5cUI0VHDXnUXmd3kd4RlN2NXqDyIYHjquWcd
	rlyyfzAgiPFQw33JvFaIJgQzJRxWqFHW5STTEb3xRov8P4a2YNex+svRaJ+Yo8s1w7RacG
	vvYJsIhHcfMNuaRE0YEOF7xWy9usNUs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Nr2pAkOR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="AGIoKqh/";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Nr2pAkOR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="AGIoKqh/";
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782124804;
	b=2ApPZBOPIBtRlRC2wlfwB2U2Ph5mtrjGcDjQrWMEX01CloMgt07HD+D+GdeDUMklQ8wYwp
	uENJcEHb1Lexr9c4nJNJIIHgpke8HVJkm4ibSdOtcPV0g07wQT/bQp5VuzN0FjlaMd05yR
	hDvk/SEfBwxZ1qwQ7NX/m8aRoBT1RyA=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5082A75B66;
	Mon, 22 Jun 2026 10:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782124802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NkRuo/RALBae4rTRv8OE22ZA7JcrZTDytq9aKv/jWx0=;
	b=Nr2pAkORoAbYHVh90pXxrF7Z3nfKZSL+HUm6JhBdUjwAqSDmMqMNsGNgNBq79NwQo/Xqam
	4MZ0dJvxsegm9PX+fhpL9Uegqd6vqvmyEXppXGirgE9fVYBZ+DrkEDSAjVLRd6z8KVMyda
	CNVCzk0Ryxv/TYLMOL3/yscp0wrp9pc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782124802;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NkRuo/RALBae4rTRv8OE22ZA7JcrZTDytq9aKv/jWx0=;
	b=AGIoKqh/cXXPyqn81qUZONwGXhOJgKygXJbyKGuoEpoj2EzB6ydGlBlIFbcfTOc4VS1CLe
	tZTo0zPpqP/jCKCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782124802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NkRuo/RALBae4rTRv8OE22ZA7JcrZTDytq9aKv/jWx0=;
	b=Nr2pAkORoAbYHVh90pXxrF7Z3nfKZSL+HUm6JhBdUjwAqSDmMqMNsGNgNBq79NwQo/Xqam
	4MZ0dJvxsegm9PX+fhpL9Uegqd6vqvmyEXppXGirgE9fVYBZ+DrkEDSAjVLRd6z8KVMyda
	CNVCzk0Ryxv/TYLMOL3/yscp0wrp9pc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782124802;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NkRuo/RALBae4rTRv8OE22ZA7JcrZTDytq9aKv/jWx0=;
	b=AGIoKqh/cXXPyqn81qUZONwGXhOJgKygXJbyKGuoEpoj2EzB6ydGlBlIFbcfTOc4VS1CLe
	tZTo0zPpqP/jCKCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 43B3B779A8;
	Mon, 22 Jun 2026 10:40:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CiWBEAIROWpGfQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 22 Jun 2026 10:40:02 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id DF419A12DE; Mon, 22 Jun 2026 12:39:57 +0200 (CEST)
Date: Mon, 22 Jun 2026 12:39:57 +0200
From: Jan Kara <jack@suse.cz>
To: Farid Zakaria <farid.m.zakaria@gmail.com>
Cc: kees@kernel.org, brauner@kernel.org, viro@zeniv.linux.org.uk, 
	jack@suse.cz, shuah@kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] fs: support $ORIGIN in ELF interpreter paths
Message-ID: <sfv7zc6jboy2oxv7zuyofysas4ncbzenwsuzveiyduisfr6i7q@mx23er7uxdbg>
References: <20260622043934.179879-1-farid.m.zakaria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260622043934.179879-1-farid.m.zakaria@gmail.com>
X-Rspamd-Action: no action
X-Stat-Signature: ekewmmyab4d4g7rjt8845b6t8w4casqb
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CA19920005
X-Rspam-User: 
X-HE-Tag: 1782124803-644553
X-HE-Meta: U2FsdGVkX1/COSbRA5tVAfQoJ/bfEIzgBNYuJlpk/9xda/vuZh/Gqf9murzrqN2xvCUXc3EDofyI6MMYu4BeXquaQ9FwJ8HYVrZ/2+EhdsoZUZ6K8KrbxtiH8O7MycLmqkqq3a1NFt+aXTotgvBL0NYkro6SvTAdJAZssT5v14XTV+KH4ENRDfdlcYIlzHKQQMrinx/x/w6M+r0g1BWJZGmdb27EkL5UiAz23gU9T7BluidKOSwk1xA6SfZqwhNc4/tiIMVlgiW6w2liSaeG5lGDVeSa3XDJuBtjUVSpT+oB3jEHuouLW7MOMJoDRAvCVV37GTSwazeb/bkgAP12tjGx9Mt7t04KJt26vIdav7ysk7ddJ5i6nCCTSpuNuKt1PIAx9UGZYRilyIlMyi9oL7GAX63DM9jH9eOEAfpvGQdgS4+gDIT5EbjVWmSPdQNmNIongWp7F3nlJxc+qw93F1za+4JirEIAy84ngWuG9lfO5h2Ki7dq7UWzJGsbOQBpQVdSPABml7Vcj3UGOwP2Cr0WUntJtElcIDZUqfild6V4Ks5pncN7e2oyzPzhR8WvQF4z3gXOGbLbdAgmXWCPwdBD0koLv0BG6eTCBrq8/I32M2n2IgEiWZRYyO38zaGZjpzwShv3jEwUGDbaB4boEh11jAxJ3FnFQI8TZsn3z8BvxpMi2jjQaVT5W/m+TimiHbad+7wBQ8IvUlvMeKWRvquHso7UmCWsMSr6nF5dydfnPxvOIpALeJylfNKjbij7htpwob7M3ddzbc2L4PyvbJCXAHyaorAjaj8mByr7QJ5rVxPGlq6dWt9nK/cbS3uhOGSlgcOoBMax70ApC69Bu98oH+cdmjXbBWFAF2rNHdiWCZy7RhJUvT+JcurfdEpvQ4bpWaUWVJJG+9j/YTcaLQRZtJ8Wa/VzzELAUwaP78k8ur0r7wuBWoj/ak351fp/uIWdS9zN/Y7ZlYUlLdM
 b0m+7hCA
 b6eAoGuAWZrI6xyui2n16CJx4gEqzTunUsa7f8hSSgUSjjU9sf/yG8QSKuqTl2af3t1rpTMG8s/NNWNwY8jjqGcX7UuyTw9eKOa0nOAD0PRXZ6MtRcpMXUSus600ioZEPIn2mb3JH/swZjLMPSVk3z/i6ZU3An8PuErCrOfkG7UhTp+UN+r2YuN7bXJIN5gLZUaK3UAzOoJMo/I4g04GQKGeGsDzaeQ6WPufNQaBIsYVl4bZQRWxv1ApFjS9edegz77pRzXj9QE6W2z1GnIelhUFkOlDbbEtZ7rJ+HsHDvoiuUlU6j+9q1ctrpZcEwzOGlw5qf+tWfWb1Q8vGuztKw5+6PwZeuFmFn8hy9zMclKMMaeHT7TdkBvmUTImeEv0i3wIJCr1QPq3eFXSp357Vjtf03LNtzdiK5YhurXOpKMuSHlJZkhsDzqixb8J87eOpXFgtnstovRYi7Z8SxURIAnhvRyQL49/1jY5AbzZhde4EOkKuexbej6M0XyXbGTqX8smMOa52IYALVJk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun 21-06-26 21:39:32, Farid Zakaria wrote:
> Currently, standard ELF and ELF FDPIC loaders require a fixed, absolute
> path to the dynamic linker/interpreter (specified via PT_INTERP). This
> creates significant inflexibility for relocatable dynamic interpreters,
> where binaries are packaged independent of global system paths.
> 
> The primary goal of this patch series is to support relocatable binaries
> in Nix, where packages are stored in a read-only store (typically /nix/store).
> Allowing the ELF interpreter path to be resolved dynamically relative to
> the binary's location via $ORIGIN enables Nix packages to be relocated
> without needing patchelf or wrapper scripts.
> 
> For details on the design and motivation for this in Nix, see:
> https://fzakaria.com/2026/06/21/nix-needs-relocatable-binaries
> 
> This series introduces support for resolving the $ORIGIN placeholder in 
> the ELF interpreter path, bringing the kernel's binary loading behavior
> in line with user-space dynamic linker origin resolution. 

Thanks for the patches! Before dwelving into implementation details we
need to discuss whether something like this even belongs to the kernel.
Frankly to me this looks rather arbitrary and tied to the particular way
you've decided to setup your package management system. In particular the
usual answer for situations like these is to use namespaces which you
discount in your blog with: "If you are using tools like Bazel or Buck2
they likely already employ their own sandboxing via namespacing for builds.
Integrating Nix into these ecosystems becomes incredibly impractical
because we run into nested user namespace and mount restrictions."

I don't know enough details to really judge but it seems to me like you are
trying to workaround a mess in userspace with kernel changes.

Anyway I'm pretty sure Christian will have more educated answer than me but
I just wanted to express my skepticism about this approach and that perhaps
you wait for feedback from him before spending more time on these patches.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

