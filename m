Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39A73D30CF6
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 01:25:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A9DE6B0088; Tue, 13 Jan 2026 20:25:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92D4B6B0089; Tue, 13 Jan 2026 20:25:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 802986B008A; Tue, 13 Jan 2026 20:25:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6BE196B0088
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 20:25:15 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3DEAD1A0322
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 01:25:15 +0000 (UTC)
X-FDA: 84328826190.16.ED00A28
Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6B039100003
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 01:25:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="J/fgRRZa";
	spf=pass (imf14.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.177 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768353913; a=rsa-sha256;
	cv=none;
	b=tYkM13h4K2Yabs7hfHNCDxgxCK355MiRIO/NuWg7CjABtXNh0bcr8ZP0z4Wn7PkrIthceF
	+BL88Q/yNmXRMM4eesq10MvNm1tT9VpDJKonKwnHP8xw8n0aXJVeHSJ421zll3drpqKYlJ
	RtxsGeAMPlNXVjbmFZ0GkahxVFKjQ1A=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="J/fgRRZa";
	spf=pass (imf14.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.177 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768353913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tQOYAceq1jN6K8WHvhB95/29jogW18uvIgDUNueqvos=;
	b=S2XO3pffPGKV8ukCkVjQut0z1hT+yn0hAR0SHMWj+CuRj9fwaTv0CfRbdlCKQ32KaQvdmC
	HoSeJH7W2IR9jO6FP2yD/t8z/C1ZTR0fDZ1tQB0rD63Ut4Qv6MVeu73TzaYBd/MPCTFS64
	of1tieH2RSFH0AAyJziQDxRFBni+fq4=
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-2ac3d5ab81bso6090753eec.1
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 17:25:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768353912; x=1768958712; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tQOYAceq1jN6K8WHvhB95/29jogW18uvIgDUNueqvos=;
        b=J/fgRRZaPed/uvokhxW/bTIGG4O3kUbUJlGs/WSH79riibflkMnf6pZ42sEkrKFkWk
         gWAMIpbOj3EvXGSfIwP2RsByfED3VZ9f7YsllDGetvdJZIK78Mf0aBR5HxVwz6XzK3m1
         b2e1lXAOYfWDO6/CuIn3Pl+vs1hQr4rZF9borAXCD8URx5KXltl+s4TAI4tqD9LtaDpV
         pX76Cs/k/4i9GjqArwos8Ac320ix+LCvSkhU8WEY2ipm3GqnYgzO9yd1HhCg5WQ4Kuuc
         B2XB3rTKPV5vI/1wpEWwBWcdoOH2jhU/3nCCbhk7ciA4LWIYzK2nLb+ErmNzI8A9YO/S
         e5tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768353912; x=1768958712;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tQOYAceq1jN6K8WHvhB95/29jogW18uvIgDUNueqvos=;
        b=iaH19CEGb1QuYrnWn2lJViWSXxg5IDjaSoe/Etfj/AFuSm83ZZv+9kx1HqQMDUES7q
         iVgiYLTzXnytD0DRshiWPPy7WL+A8hj7/OXt09hZSWUpKYzaROR82wZV5JDxvc/l50Ez
         BYlP4RdVG42tQGPsV3Qt0nPyLxAQFvGGPWIXbOttW2q/3O4n6fNPl6GdQ9DlNCWXktJC
         EKFcYFrS9PtsGGf1ov7657RbrmJDvYsEOziLyZgVVR6jfnS16NXt5GOVH8fMnBYvvz+F
         1zNNtMX6AA/j1YJHie4p2tuNM0awnWUD5v/yWDGAvkcZ7pA19iX9/1CGIwqze/WtBYmV
         YnFQ==
X-Forwarded-Encrypted: i=1; AJvYcCXd8ylvbtHoRihn2L/saiX8ZrEe31Ysm5VsEZRY/CqyK7w5N4I8gTlKrVqgbCZTKqxFetX5vOXHRQ==@kvack.org
X-Gm-Message-State: AOJu0Yy7mNUULwGo0wCGLzS09n0zC+/xVIwmzDN1D652q6QayZaS/2sp
	JZZ4NlAkphO2+PiNGJh4F50Fqw/t4xsMfSGByvoZ9VwCRuaJTddmnybc
X-Gm-Gg: AY/fxX7Y7eEr4B/YejO2m0jvEOCQq6H4b3BCHJAazz5LjQQ6rf+2y/BSu6a+pWwlDVm
	gUMZpcTJLFUQ50+VC5+oeH0I3Ji96goM+d3Nsy1/Qkd0RmAEs34iWiyPgQnSbALlWZbwNYesVhS
	d0BdfFaRfN8i0xfQdZPaAAUq/5j4w+4fenhQIoswV97baxz4O/5nLyz+08b8DNe9S8RPtcuOOEL
	Q5uaZz2yuDaza8QkoUrb0w0wCtl+RwqXWpr9Bw1+yjv80YAhr/JwM8suTKpPhitZ92K4EoxEOO3
	pnQegOUGLxhfw9sW6EIE+z1w43xGW7xBkweOlkHwyUZ1Umpy4NemOgeqNRNKkxbrZuA0OC5Fwek
	4L6Wu4y9+evq2IQPiaRNRVArgsKrwt8Vgn4Cme2bEOYnOMRukyoScElGLikSNafI25OUxfDccA1
	z2
X-Received: by 2002:a05:7300:3215:b0:2ae:5f34:e93f with SMTP id 5a478bee46e88-2b486cac6f6mr1300602eec.15.1768353912008;
        Tue, 13 Jan 2026 17:25:12 -0800 (PST)
Received: from localhost.localdomain ([2607:f130:0:11a::31])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-121f24985d1sm28862935c88.16.2026.01.13.17.25.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 13 Jan 2026 17:25:11 -0800 (PST)
From: wang lian <lianux.mm@gmail.com>
To: lorenzo.stoakes@oracle.com
Cc: a.hindborg@kernel.org,
	aliceryhl@google.com,
	bjorn3_gh@protonmail.com,
	boqun.feng@gmail.com,
	clm@meta.com,
	dakr@kernel.org,
	gary@garyguo.net,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lossin@kernel.org,
	ojeda@kernel.org,
	rust-for-linux@vger.kernel.org,
	tmgross@umich.edu,
	wang lian <lianux.mm@gmail.com>
Subject: Re: [PATCH] rust: fix typo in bindings
Date: Wed, 14 Jan 2026 09:24:50 +0800
Message-ID: <20260114012450.77608-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260113192949.689834-1-lorenzo.stoakes@oracle.com>
References: <20260113192949.689834-1-lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6B039100003
X-Stat-Signature: af14xotajxkwrwq81b7jmrqgmuu5ouh8
X-Rspam-User: 
X-HE-Tag: 1768353913-84653
X-HE-Meta: U2FsdGVkX18AXEz4VrCRfRmOWNLDhUIJcF9bPzGuIwQW8JyoM19Kle5wrs6KthNuvgIAo+RBuTg9D2ILFfDCzaE5/bo1N4kpeh1v5hogaV87mUng8YBPnjS++lF1V4Eax70aR74vAAEDvLJI1u6XP52zq4wLcGgiTBjDGVZd85PH52G3LVNUB5s5sK9rYCXFz49bDaF8tUBTDYOrVtP4X1k7lPFEFH61Ex7FrxiEZnl/z6r00tjoIWNjrLb4EujokPFq3h4RL3pc0Jhs4dwU5/49t7PbovKIb2yIaSL9PNFGNnF1wozEVvzTbIeYOT8RTWSXn8FiU1b3tU6VQBsBP43Wngi4d09iJX3GwxM2ui0qz+q10+QuTqpa8mX3P56cKl5RfstX9xY2AyrM9saawftRRCFqT1Lfz9llHwi+COmZTqWHcjKZUvLlPksEOkLx2xwdl/CdgXfkao8G5saiVSOw+2s+iqp1jTnCBf6mwPHxBOwBFOAEA2mAWbWH3JOsQuxy7eolt+H6cp3SPRyq62+CirLwsfp6ax673mHRpdSOTvatQXfTdioq+Y39F0jvWuoHoZepPgWjEg4iFKQFjYt5Ebn9i6cYxkMrH8YiKo8JgGoVq3sisdeaM+ADjoOKJmCAM0cqbzns8ZjluuE/PAQwUlBDNW7ubrSJaWCHou7quOp7kYHzr8FkawpSUCROfKdkiwjdS/ipMQXXT1kKIw4k0uQMJLfwBYat69uTK4ChviCVYdSwc5P8Y75jh9bLG9hnLMBH12wTIX+dodV0ut2Sk3Ngd5/wU0I6yFM9ZlUEhIB1I0bFT/MgCu/hJY5cVMEw/YLEz5n+HsxAvcLEmytVmYTVd9Rb7Idtj/qtqhWu9saykA1cuFbIigBWksm/arZy77mlAwqwnOCLBOI/D6HUm3jkkEdIpMwOvufi5OwDUgWLOUhkeuBUC1Knv7zN8lpU9zjQRIEoQoA1us1
 iACqTuet
 ShIkF7NTCaBnmJj+c+wbIchZBQqT8Vw6Ff/aeNQmDpWri4rmRRXG7ODFdXzt98IPYI1MbceMtdN1gzxxVz9lo8wyulfvMuHhypBjP+C/7slKu0WWbT3uU1/ukM7u4Q6t3bDNp9bpzGyx+KA3cUu9r7F/Otxjv536MI9gg8LXHUB9qDCkjQXzmNCtQT2dkMC5Pd1MZeiERYOEkjYt4h5cIt/VzVRC0hfrOa770dQ5blWRyC5LHwYIkzbuwDJhdR02l+Tfvqui57CMlPxhW6lVxjL7dAle+fg/neCAgtEkYZdjI4oUTx1o4e5JCCOtHIPrMA60mz/StkhIKaeM84bBxejsfcedMFPlsG3RXIOedUYfPKfr+GIQQuWWHqPlGzoKdxVEQ9hod1eTpGxPOnjXw34Q26OW3i3pUSOguupa0HWQJRAJOmNYUXFkUlESqbND4tkRobHeuYpnuVEUXjZQ5le70lA5Dbf6TDkACUeUvSfAWdlvNaC2NvA2vO05f5rNFPR7nZT8U3zTf2JhdMhu2V/g6H5IsUSIcKXGDyqJWsgpodp2i48JIsPWidhDlCBPyJwJnJxeI+nb5iHKQTTo6aocvVk6OhYgnaJJHv1Xc8O9wDDfVBmJRrCMdiVsB0DZgrJox
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>
> Commit 2b6a3f061f11 ("mm: declare VMA flags by bit") added a number of
> overrides to the rust bindings helper as the change performed in the commit
> caused the rust binder to not be able to automatically determine values of
> VMA flags.
>
> However a typo was introduced leaving VM_MAYSHARE to be incorrectly
> interpreted as VM_MAYEXEC in rust code. This patch fixes the typo.
>
> Fixes: 2b6a3f061f11 ("mm: declare VMA flags by bit")
> Reported-by: Chris Mason <clm@meta.com>
> Closes: https://lore.kernel.org/all/20260113185142.254821-1-clm@meta.com/
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

LGTM.

Reviewed-by: wang lian <lianux.mm@gmail.com>

--
Best Regards,
wang lian

