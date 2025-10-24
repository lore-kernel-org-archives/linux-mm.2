Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F149BCCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 15:34:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CBF98E00BC; Fri, 24 Oct 2025 11:34:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A4818E0042; Fri, 24 Oct 2025 11:34:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E0588E00BC; Fri, 24 Oct 2025 11:34:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3DEEB8E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 11:34:07 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EEBF5160ED5
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:34:06 +0000 (UTC)
X-FDA: 84033403692.19.D651B32
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf13.hostedemail.com (Postfix) with ESMTP id DD8E32000E
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:34:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=E05lLQN6;
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761320045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=are2xt86yIlpc4HL3GdNhNk2Nk9IKxa3I/LJcQcthQo=;
	b=f3pQ7/q08XxPRKxJz/f1PC1Xt/ENJecxhgaKAkmwhr9fBFmIY6zGTZ/MSDlpVWJlVmfXdw
	gbFkxchYHSEG4d9hwfa5p9dzVaLI5oUpgy4m260vlp/nU2G2NY8YMdeBFl2bV4i54xIbXw
	mbw/gcg21GdN96qEk/jFSu4NxWtr4Ao=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761320045; a=rsa-sha256;
	cv=none;
	b=jm87HWqMCRhxee5bdd3nIzQZqo+BWUg7cxpToITN4ljxUebG3Jjac/W2J46mZ3V2lUIhhm
	PCkayQIFgN8rqPA50d5dGOC0CYhIFONykbrn57VaagU7EmhgzGI4Iv+vHYamLiXWIzEEOg
	IYmYgvg6dABubCy9b9ZPFfwkXaEP4/M=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=E05lLQN6;
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-63c31c20b64so3959023a12.1
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1761320043; x=1761924843; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=are2xt86yIlpc4HL3GdNhNk2Nk9IKxa3I/LJcQcthQo=;
        b=E05lLQN6fS2XMphMWFgApsP6UVJpmeKLJKrQjhyJqk8kUDuFphufU1JX06pNu55t+7
         gjZCrJPC0MEW/fUE0bNZbCV0sy3tqwsgHjhbzfuzMy6tUqtAi7zrx+53cRXUldF9X0kP
         /sAfIQ33P4OoU3TqzyMcj7yKmhuMt5neqxgmnZJPJGW/3QXAlPLIqfYZB6kMbmjyvrvX
         fjpvaberB/B+sBtOq2vcG2QZtpLcpuYKSChCEZXSsa5BX6w9rKVH4GijM50ohuy1JtB/
         cGrPy77Nn+0cAQ5z2f2MyjTarQWQ2peLNJcJWTZ++mRpcgnMrUt+YKcLk/BYzL/KPuxF
         g6NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761320043; x=1761924843;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=are2xt86yIlpc4HL3GdNhNk2Nk9IKxa3I/LJcQcthQo=;
        b=ayDKkjY+JobmKDM15jk8yPEEOTIGwqAudlhyG1vKIYePksvqXP11u3N7EOCaHabm5q
         fpzG2puT4AzSoEYDdaXtSxD1o3qZEukKODZ3+OKdHxbJsHyb62+v0+iKXFEpUZwvL/iM
         acklOwC5eizt5z+OtWH06RkHPEX/hUD1L7n07Mi92V0/KQChHkezhaQ7F+bF1O8boPic
         Cq8sfRjfTMZyrYN7XqrBI+9o/2xZIL15VQ9mAsL/7kgVdKEm7yqpME+KnwIMwxS8VrAu
         2xntyOA+qXPE9wZ19hUaEuVw13iK7hMJ10ZaqvUCG0T2C5oQsbSEZTBFH6rPAPzv/LLM
         9lGg==
X-Forwarded-Encrypted: i=1; AJvYcCVkO/xwd2/dudvkV34NoPDNnXFbXgpQzqqTY9Xs23WW7kZFhMg/Vu33F2A2UQZIveUNU2pR1Z91sA==@kvack.org
X-Gm-Message-State: AOJu0YyG5p+++7RP+9/g3IWYmsjKB0VAABlvkdZ3scHWMj5g9fj1tc8h
	G5Vr40hfJwA2yB2stUP9+5ND/UDdrm1L33CsmZ+CF8mRo+hck4DTuZUb2ZG1slKOMjJx+gvA3DL
	J8nCGWEewZrVQWvImJHnP5g+8VDECFjrE5o+ttrTCZQ==
X-Gm-Gg: ASbGnctzWXyFo1M8wfEsX7oloQJFKDzdp+5DX2GbbKqFyADnGF7o01W7Jqw0yPOy+E2
	4oALaSN3SCUQW0xr7bwIr8CQAk6TzE5sLsuWsQnxJ3dRYlRI2gTUW8fmQ7zO2mq9ulWcNIcVOMU
	we81vCttao8q+OI9Y7QlrJ8ZaHK9ocWMCTvq+eY2IoD2RI7gTJk4BhgkhfZEmk/dmeGwzbu6oaD
	bBTzK4p6c7vpccOlUh/iK1oR57+G4cpj3B06JIqt0jZvINiHxll5Wn+10xAp2iepvGt
X-Google-Smtp-Source: AGHT+IFfTkje+cUGlXkTFymJUSte5krNn/bEG5EhN31gNJr/7cVMgJy9Ry/5kSN5HjqZ3SuvQkYNIfXAVoLsVbdbd8M=
X-Received: by 2002:a05:6402:40c5:b0:637:e4d1:af00 with SMTP id
 4fb4d7f45d1cf-63c1f677665mr27513307a12.10.1761320043188; Fri, 24 Oct 2025
 08:34:03 -0700 (PDT)
MIME-Version: 1.0
References: <20251022005719.3670224-1-pasha.tatashin@soleen.com>
 <20251022005719.3670224-6-pasha.tatashin@soleen.com> <mafs0a51jfar1.fsf@kernel.org>
 <aPnXVmD3cNmYNRF_@kernel.org> <CA+CK2bAvKrfuOXTa-RWtcuSR8rkPMhurwCn41NcUm44_vT63rA@mail.gmail.com>
 <mafs0wm4ke2wq.fsf@kernel.org>
In-Reply-To: <mafs0wm4ke2wq.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 24 Oct 2025 11:33:26 -0400
X-Gm-Features: AWmQ_bnJ5szaFV-enEeq3wfvmO3Zq6ympB-Z6lOOZF2BoJ-F4vXI0M6cDC_xrXY
Message-ID: <CA+CK2bARUpZaymPTusZWM-kzXcUp_d1UK9nUudu3tHitpeAH5Q@mail.gmail.com>
Subject: Re: [PATCHv7 5/7] kho: don't unpreserve memory during abort
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, akpm@linux-foundation.org, brauner@kernel.org, 
	corbet@lwn.net, graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, masahiroy@kernel.org, 
	ojeda@kernel.org, rdunlap@infradead.org, tj@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Stat-Signature: 5bgda5pnn3uqq7pxfnqo8rj1qdhoo3ms
X-Rspam-User: 
X-Rspamd-Queue-Id: DD8E32000E
X-HE-Tag: 1761320044-189871
X-HE-Meta: U2FsdGVkX197Y1xvMH+R7Slr9h5wjYj7MtZnOfqsoN91q3NgLf78YlM+A7SFHYnzJDzFYhPb6I9jPvDSpq4PsPsjBaACuBKJ9/R06ynMjQ79g79eYT8wNrdXdo9oMXIRPcwWv8c93CDvBXKHGUgQAylcvVTnYoP7nqfHX69sT06aoI/4BEK6sMquOGJXyyA9bQtqsc8DFEg9+3M92sbdp9aBKiljtJsG0y+A8YH1lULuqUrhSR57Zhriy77N7sojex1PpnJJgz4YZQdASrfg8NAZsz2GyWa9VccsC8gRNTVT7SLOIPfgy6LfviAHW2d22qk+qCJ+AT4IG1JFhBX2IjbZlhrTK2UylpeSA3YAj+iI1xCIjT0N+eVY24srW19hgpdx2WW5D5F8QJaHHpLPtOd4grCiQxryTm/w57jrYT95u22yWn9SyqAYoOqiSzgJC9OvZwyFYGNyzpK+bQ061nQtLRQYj9MtI4gLQy5bKFpSmyMvdHLRlTpW6xOZKJWDpSc0bcp40dsUw2imKEfoJ8oooOvoNvdarBwRm6XJx46VICeZxpU35wXHTvQmmi6aXGc8EVCv2tPH0gTgEAsNBQmUm1xPSV3RvP8c4++pOrqMUxz+acgm5+iAXdgQgUO1cCkB65mOXlQB6I2dCmuWkmeZPEvPUzvaS5xuZh2YwcgLJIjJXdTqfEeYRr1pn6mdTmUDb36wwEOH6UmVGZvrXgqxtVSD99yXzjGCyegnCQ/yKuzcVL78PmiKtzy7YGQDFaHFXyuUyISWs/SDSc4nQFvuF59SMLd0n+4TbswhhyywvWCMwxn5UCvcY3A49+4BtDk4TN0Zv8m5E3ScNHGUYHnumMO5mjAbrX4qox/DA7fJD1tGUtN73MimQIVskjPWTeSr56FA5Jz3alD5cQz6t4ZJoYZeHxoICrXOY2qfrwpEjR/mhLBH5fBQi4qjHzllA3H+r5uEC/zes7fBKFH
 iL1jPSBg
 cO7O09s7Vor2OAPnmC3DI3eAHbjno1ca05rW4pv8cus7iZHLQe2kh4FrYtJ1phZaeVyrqFOUXFx586b8ZQU/ICqgeM//3KHNE+65aNk7zRF5ctfcrZVNyj4n+XuJEoyeY28uootnVYbQZ6XnDEQEDDEXrM/FqN6xd08i21C7Qo2VIGiWInR/Db0vpARCGFaJfkjXo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> If any of the kho_preserve_pages() fails, the notifier block will fail,
> cause an abort, and eventually all memory will be unpreserved.

This is a wrong behavior. Why should the memory that I preserved be
unpreserved if there is finailziation failure or abort? reserve_mem
should still keep memory as preserved in case KHO later will be
finalized right? I have tested that this patch works with kho
self-test: preserve, finalize, abort, finalize again, and the pages
are properly preserved.

KHO Test and memblock do not need to ever unpreserve pages, as they
preserve them once during boot.

> Now that there is no notifier, and thus no abort, the pages must be
> unpreserved explicitly before returning.
>
> Similarly, for test_kho, kho_test_notifier() calls kho_preserve_folio()
> and expects the abort to clean things up.
>
> Side note: test_kho also preserves folios from kho_test_save_data() and
> doesn't clean them up on error, but that is a separate problem that this
> series doesn't have to solve.
>
> I think patch 3/7 is the one that actually causes this problem since it

I updated that patch with your suggested fix.

Pasha

