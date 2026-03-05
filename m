Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53BC9F30937
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 10:52:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD0836B0089; Thu,  5 Mar 2026 05:52:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7AA96B00A0; Thu,  5 Mar 2026 05:52:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8A256B00A1; Thu,  5 Mar 2026 05:52:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 998CC6B0089
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 05:52:01 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4C6DF16085C
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 10:52:01 +0000 (UTC)
X-FDA: 84511694442.16.3BF7873
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf15.hostedemail.com (Postfix) with ESMTP id 80410A000D
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 10:51:59 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ACsRmmHR;
	spf=pass (imf15.hostedemail.com: domain of 3TWCpaQkKCAgitqkmz6ptowwotm.kwutqv25-uus3iks.wzo@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3TWCpaQkKCAgitqkmz6ptowwotm.kwutqv25-uus3iks.wzo@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772707919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zZqmM9VzOQ/O9cEt4xOeQgOy+8UiQys6mbbZHkCbCuo=;
	b=kmZC8QnVILO0clUPF/hOpjANCZB4G1IG7YNjApprWpAnbOQm1kxGRBkeomQd4LaMM+cdX9
	dClC9fL0k6p2SNHsdgFf4zT+45/pFNbKVbeghwa+xEPJEtK7wP2JD2JXxGFTOXs5t3p2JG
	QlFmhmYNtETa9H+tiNa2knvtfhrh+mk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ACsRmmHR;
	spf=pass (imf15.hostedemail.com: domain of 3TWCpaQkKCAgitqkmz6ptowwotm.kwutqv25-uus3iks.wzo@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3TWCpaQkKCAgitqkmz6ptowwotm.kwutqv25-uus3iks.wzo@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772707919; a=rsa-sha256;
	cv=none;
	b=yPpDqP9mm8MojDxgn8naObti2dU0ch/Su1Pb/1YcVCMmDNIH1gnK4zzkmruFHa5/tUGOz5
	gf0tSoRNYTb7kl3+L36j6rGPE4wGlkCMOYzDqHa9i6/hgzZSJGrPN2kI5s+P9icPDWEsNy
	rGbFQWXIcwJZrFHOK0ExtHT1eF4vUKo=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4836b7c302fso80530865e9.1
        for <linux-mm@kvack.org>; Thu, 05 Mar 2026 02:51:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772707918; x=1773312718; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zZqmM9VzOQ/O9cEt4xOeQgOy+8UiQys6mbbZHkCbCuo=;
        b=ACsRmmHRYHhhLHGR0Vr1VwbTPbG8APCzrKi21MKHC22XNhz9Fu2W0SbxmDlOlmYX4O
         652kWOgVNR1wu/4NTJmax/rnOb73jMlJViyG+P9XA9F5CD6KO523trC0q4rWwJJgIwkM
         gouu04/DOdIiurLlQxWy8avk+gDJTDiL9VOdKJcfcBQoNFVMHDmClvmdKIsLHr/ZKluS
         uovAiiG6cLqXqNCmAtUScuAZaXdj6lY4madjdYJviJ+vCk3Lglqy5fQ+luv4aV3fzzpG
         Taz9Uw8TLJj4bT5HiNDWekjGXcuuV7P6BcYPuURkUG8aYcmTmKNrS6CCvOTqGejICfog
         o0uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772707918; x=1773312718;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zZqmM9VzOQ/O9cEt4xOeQgOy+8UiQys6mbbZHkCbCuo=;
        b=tAfVQb5cLR0RmdW+QjPh5z+dTsNzLftLe7C+O0GrEFIRnSfvhk/z2O9hoxl9ZgPDqV
         UUmFENS5fcWgxXNqq+6XkeGJ5hw1j0OPvpo/bS2b31FChJ6UH6YvadL1hmFH1ePzrhkJ
         5rat55Kue7/+9dPLrjhg4Zh+/6svyAxohQVdpHWc8Bp8KcGF8NDHagnQndgaUQ0FUjNl
         SWkbrI2Nbb/uZ70Jil7TgeHM9eHMccIfsmp0Tk0+yaHlw4eHh7pb1guJ1jMOndmoBtgM
         hxNIR5f97C+ywj0GM2Mv562yYw+jBqmEThnuEs6fqNT1PyIFEzldF4AcfWlHP7E8DAEp
         WJkQ==
X-Forwarded-Encrypted: i=1; AJvYcCW6kq0ixgOt3b2Jmik8jSaTS/Q7XLornor1dOrgIIXFmzOcMRrVYyxYhqcTvkoJ+iKkvuYefC74Lg==@kvack.org
X-Gm-Message-State: AOJu0Yzg11dJVWnz9B/8x33pfUSxhJvPdTdgk30LfrbrEFz/YxpyFk5D
	5C6X69Z2BAKyYPPcSxp6UOR5gx9+HCvoZiOEkWOo1J77lXtJmu3T45yqXQ23LYu6ORbNM8wK5ng
	Wfv6MHjhi2SC1cusIfw==
X-Received: from wmpb29.prod.google.com ([2002:a05:600c:4a9d:b0:480:4be7:3f3a])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c8a:b0:483:456a:5146 with SMTP id 5b1f17b1804b1-4851989fc75mr80019835e9.25.1772707917693;
 Thu, 05 Mar 2026 02:51:57 -0800 (PST)
Date: Thu, 5 Mar 2026 10:51:33 +0000
In-Reply-To: <177270557911.104478.12699746103670684667@derry.ads.avm.de>
Mime-Version: 1.0
References: <20260203-inline-helpers-v2-0-beb8547a03c9@google.com>
 <20260203-inline-helpers-v2-1-beb8547a03c9@google.com> <177270557911.104478.12699746103670684667@derry.ads.avm.de>
Message-ID: <aalgNO1gRJdrWm4p@google.com>
Subject: Re: [PATCH v2 1/3] kbuild: rust: add `CONFIG_RUSTC_CLANG_LLVM_COMPATIBLE`
From: Alice Ryhl <aliceryhl@google.com>
To: Nicolas Schier <nsc@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, Will Deacon <will@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Mark Rutland <mark.rutland@arm.com>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
	Nicolas Schier <nicolas.schier@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	linux-kbuild@vger.kernel.org, linux-mm@kvack.org, 
	Matthew Maurer <mmaurer@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 80410A000D
X-Stat-Signature: xtiqy9oyx7k4jswursf5n77kmnyhkkfx
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772707919-832687
X-HE-Meta: U2FsdGVkX1/Tgxi+Mgj3+HnEsGGiHzKOP+FykqONAu7AeLEr9cv1sb6pdglYGLMqpJ9T7QHGH4cSw8hmNo4RmsWRnMErrojLFMhOExy8RTQaDD1BAAg5oxN9Fr583oGHCnAejgcQpdhIdxj444MIARnHX4bE0er/j3fdePAYoI9Pub2dpSAX+36yPEBqj4Aw6hLml86UVSFivzSIZ3igm9e+6ZQn2hRH3+TRPywf8RBiSVmNoEbmW5dCZtck9KRhTqt1ovkB/R+Zj+HPR5/bvW88SEwpd6kvoiAVwGR7SZH0KG7zYcGWTAZhXSDSuZFfJY7k0ZLVLFy2f/r+qZbWJm9+0HnWb5aAB8DQk1Yfkf3sjNoNc98JupJmLlM6g4kgDNNGuOdP4uALbSpTj4d/qLTsztW2qXLQ3xF9Vg2d1U2HVp1ppvizUXvnc2QAXaD3i7oJI9RPh3DrsUSUeVbwOn60e5aMpu5Yv26OMMdp1F7SwuW9maL/0weoQTbaIxMxqTwrmWTuu4/9b4Y9hjPJ5715AN8qQl6FIaY6sO7x0ynKJ8aJ3LiZw8rEaqFJJzWxXrJ0ijM0znTm87CZBSFFDxB7SCwhxoVsjPz4v3ysipkQ+foR5FjQrIPt+47HCHEGGMKgGgB9UEvEE5hdjnDuQ5RaFGOjkupT0bg1Wp4LeWfYsnDH2EglFHPBMGNB8Lmw1csAsp5cUDXEqRQGfvq/K+lEisAPPEPjYSL4esDVpTDmfSiif2iQjtv/gWLxOtmv67sRuPZ7i/D1hSsjFxHrgjoYfVc+JlNEChbDrYBm3VB6xT6AHBQV75xf/iqWhlLBqgWM9x9sQBOopukQSBJgeL7a1V5v7KOvDXnaHDD7a5j08+bWByOCHmCB0Olf+vYY6znzQ1RgG8t2YrBiEN+j8LCKDDrifX1uyghGD2PEIR8h+i1rfiqRVwm0Z39Wt0sbGQvjkwlcBzTIN4XYKbz
 TEnNPHjA
 x1N7RieEKhn5no89/94VckJ0EJxEdMM1r1CpCbhhmPR6sKDd7n66y8MPx/M3iBDbj4uEZRlBBG/cMpujzCnfT93ttnItQ8KMAJgKarYdBIX82goEughRMfWtI1ZkRjZN86dOgGal/KVCSxM2CKTCd59FXqEKsCMDyEaoKI52D7NmacLyiuAKDBLbxZeLhVptXZQWletY8uDsApqiWwJX7rGaWxkOaZAs23Z88TS9co1zY71J1f4Zb9nCd/Ncs9FRnxJel6ROmhfuUVtoKW/Z8hSVC1B+8YRWGzAapHXQj5mtqd7RJoVH6GaUuLQdg9FIpynqOFEgJBRu/lbF4OZ1OaVpjAAIeeB9ZAggI1QMUTA/kpVp5WEr3NkoHealek7cXnNVMF4rw2zMNTdv/QsKs9hruyxLsgUXeBtMMc8IfyYcgefWu2lPavyjZSFGr6F8NS3tUQtAxdBf74RY7C8PLyBn6uzw6JcIdfpqnGcv9F7L85kRvhsmYFJWNvZPmIm+jH9OQ+HnLTH7mrSPZbJCqO9T3voSJoqiAgJ5lyh7bqWiv8vMRFnNn2a8hKZqJLfGfI/c7eDiDV65oZNAQyTFuETCriaNyTUwsB2fLfGKx+AODog5JcXynACyq+c9RIblvWskoruFEE4pYauXXf3sW065Fps6GBisLziJtLVn/iPIXoohwNz4k8ExMuX5UG9tm7WbnWnZGf9nCNWxxd4fILZ3N0KJHfpEeqN0s06tGwbHwvNl9or6OKMFuu5yQEfyin1ahpqC01P3Yu9NxLTgCrcf8YQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 05, 2026 at 11:12:59AM +0100, Nicolas Schier wrote:
> Reviewed-by: Nicolas Schier <nsc@kernel.org>
> Tested-by: Nicolas Schier <nsc@kernel.org>

Thanks!

