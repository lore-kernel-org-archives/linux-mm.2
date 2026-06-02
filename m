Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 693DFCD6E60
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 22:06:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89CDF6B0099; Tue,  2 Jun 2026 18:06:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 874016B009B; Tue,  2 Jun 2026 18:06:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B1656B009D; Tue,  2 Jun 2026 18:06:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6DDBA6B0099
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 18:06:29 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0F4541A017B
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 22:06:29 +0000 (UTC)
X-FDA: 84836357298.27.A8DBB8F
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf27.hostedemail.com (Postfix) with ESMTP id C04AC40005
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 22:06:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=d7Ne38Dn;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.47 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780437987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qw8RVcymrwPdvtyZ+lyACgxH7IqaYDBeV32TfvS6Ats=;
	b=svEwx+h1qCaE/2x04KDJk43IHo+yOPQgyPu2gQzNGKLeabAKgkjQlZUPWwV7c1Om8sEq+/
	2onhj0wSITorxVszn4ulgIGosTOeG7mno+hx9SsqZbozEgrjUfExZpd6U9gRfIEpgqYucv
	HmBD9ElglkMDCjPZw3S1VEl6bjt+jYU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=d7Ne38Dn;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.47 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780437987;
	b=Yz34CGYGcNGZSQb4do0xcj+cSxC4CgYgAH0SFInw7a5m3TESXUtJrBnzfQgyRAUD4xJstZ
	pF8+gnsLYhRngOcc+k0C7uW5ScLHe5bwu5otnA1hRmG/IkT+e+3w5YMp+AhRc5HtpuSCyO
	fGkeDbLuGRBF81CR2aBezZ65qFMrokI=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-bec405a6ea5so484585166b.0
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 15:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1780437985; x=1781042785; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Qw8RVcymrwPdvtyZ+lyACgxH7IqaYDBeV32TfvS6Ats=;
        b=d7Ne38Dny5ihDXaYu+I7rAbV71Aa09t+dHP3KoOI7yJEyjURnkhOD6cRBgivUtb29T
         0zmgfM+G/t+bj041aaF4BGxYfrcnCOsySSq7sJe84pNIs32yVBJQVoHrJbmpB9C6hMIl
         4OMPErdeBJUsp+UGiPC5zXCCT5hd8DPK9mfnM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780437985; x=1781042785;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qw8RVcymrwPdvtyZ+lyACgxH7IqaYDBeV32TfvS6Ats=;
        b=f6X/MkdfEq+liRryKKQENBZs5PqOI51FOb8O7vbt/ANW5Rsj0LtfqYiEFHeCyW/M1m
         ucE0MCauy1vUXy0dPrC1dJcTsf75kmK29lE0TAAJN1tx9WOB5nw3BQ0a5PI4/fZGv9uz
         Xc+1TjWjjk+TTlObrQ5AUwOpJ16pNNkmEfQd9bSK/+dnBSYmdBfszdUeH09ZQe2TNEer
         c/Gz5gZkVLWaTVTBxdUM6DRPsDG0AAWzXX+W6UPzSRxP7wurkQFWpfK9b5Ec+QPrw14/
         XWGA2BYaSqx/R7Ye2fra7JG7m4Szz6fjya5MJRU6RjQjXCNofrMG6NV49ULs8ZFJmOSM
         YE8g==
X-Forwarded-Encrypted: i=1; AFNElJ/TMa3HI4amOLi2InTWqw0TyjgKjWwccMTACJwBLR4nG3pJ6bz5/Bi/S7KHQQSpj3nckOBtvmvriQ==@kvack.org
X-Gm-Message-State: AOJu0YyWUE49B84v7fvXg82a9xBsC+91RMEJCxvCdHH/sIYC2JBbEV5+
	/aawqhLKUxDou0GRNVm0K6qJeIGEgp8+4WLILLyRbA4add5YO8gxLtRINp5aulsZIic268HCvKM
	Oo+qIEXM=
X-Gm-Gg: Acq92OHhG8Ft4riCRpdISCDbAr5xdsk8HdY8Trud8dECnHBapQKqZ/ByfwdVWGUM5Lz
	MJKx4ADWqK9zXdqwT7+nj31pEAuv1aj58xpjxjoK8eNsMux0l6HkrHDeNK1/g8/LqRbbQUvyKzS
	a+XEVQhTFFu94YgnMT765NGrauBqgNXVl+6KslFG7jUDB8ILPQz3cqkTra/xIRqFcylso41ytWE
	y+TPvidjECdRYUpdeYgb/euoPJmzjUIbk3WIHXvR7ToONfpIPyzB9sx5AyslSwdAFjZ62RFG1Xk
	6fQNi0BohCgZbqQ2CCCUsVlFj3WonY9e4/vsXSwF/mRcIUMCrLzjmzaIllxoA+KIw7B4VeixBle
	K3fI88nuNbXiK8cpTOxKff9THCesoAXtMFsuLudNbkMohvyrn75BlSjcxMs1mLl+cY0suSIDzG1
	l4FdVgVwZyqfOYDwrOTYKjo93YljK3LbkfLazMYST5E3gPWn9cMMMB6VX9sWfZPKQekyRkqC/Hi
	fEjuG5jtxs=
X-Received: by 2002:a17:906:7955:b0:bec:d077:c4dd with SMTP id a640c23a62f3a-bf0ae9fb19fmr15329266b.32.1780437984964;
        Tue, 02 Jun 2026 15:06:24 -0700 (PDT)
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com. [209.85.218.51])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bf051c85e76sm44172066b.15.2026.06.02.15.06.23
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jun 2026 15:06:24 -0700 (PDT)
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-bec450b950dso409046866b.2
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 15:06:23 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8nUNGk1bU4XqXY6luPpoeHiBMC/ex8suzQJag79MPubIPLiZPvWpHzk8KSNR/FWnj6plsAiZVT2w==@kvack.org
X-Received: by 2002:a17:907:3f19:b0:bed:62c1:f7 with SMTP id
 a640c23a62f3a-bf0ad9ebf64mr15174966b.20.1780437983314; Tue, 02 Jun 2026
 15:06:23 -0700 (PDT)
MIME-Version: 1.0
References: <ahv16ogY8Zx3Rtox@pedro-suse.lan> <20260602211242.13870-1-safinaskar@gmail.com>
 <ah9LaPQayJ6tBE53@pedro-suse.lan>
In-Reply-To: <ah9LaPQayJ6tBE53@pedro-suse.lan>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 2 Jun 2026 15:06:07 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiAqf0PdZ4AKj_4riUnnEb=g_ZNPkLnXrByA9BBHYiFRg@mail.gmail.com>
X-Gm-Features: AVHnY4La_ZzADdnhLw7VXJvUOP1cc6TzuLIwNWiX_o8vXHDUu8ML9nZoEC5oxec
Message-ID: <CAHk-=wiAqf0PdZ4AKj_4riUnnEb=g_ZNPkLnXrByA9BBHYiFRg@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Pedro Falcato <pfalcato@suse.de>
Cc: Askar Safin <safinaskar@gmail.com>, akpm@linux-foundation.org, axboe@kernel.dk, 
	brauner@kernel.org, david@kernel.org, dhowells@redhat.com, hch@infradead.org, 
	jack@suse.cz, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu, 
	netdev@vger.kernel.org, patches@lists.linux.dev, viro@zeniv.linux.org.uk, 
	willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 86wunae79zn5ezxwgtmre87s1eywnzsr
X-Rspamd-Queue-Id: C04AC40005
X-HE-Tag: 1780437986-112575
X-HE-Meta: U2FsdGVkX1+wHbNPrVgtFMtcD7r97jNwgDTrH/LD/dQJB6EfWSK1A9uXGLsUAAilcwgp/5/FIhWtXxOxvh+0pdsVdFXfohWYQmKeu5fcC1bzODP2T4Px3nn1sJOl7CS0XKvmS75pNcPvgx4zXMw7XQArDrWN0OVw0tYC8aKIjDW0lsSyvTMhEJQy/udNTgbaU2QBDJz9rg74vB/9oBqBTn9mjgr8TM2pc/XYG/CZnZ7sxHWq87ftASMoIyFiPecb01nBW0rDcDTa1TteAmWvzoYfqg4bXSscKKjrUr0ltTUFn0vfpBK92XoLVKtuPdAGEhhYs9kOnwmddtgAbcFq5Wf1Nu2JcJm6vHIgADduQEsYk1IeUbhnDiiwH6+e372377Usf7cFmBdqkSw+2X5Abs6TUYL+CB9kyhJM244U9ciKwT0jJLmUF3YbORQtspa8guz9fxEywA+f2C/h11IHNR2F3CicCsg9/lP8oDmQy7sc1mmWG/d1XCkla4USni5JSyU2dgp73cO0X99KTqbM3qwXVd9quPQw3XpTl2tXqA7hCVKRNIc+yIHPxE183O2F2HdALiZ4ia/RHWx+mx7A799q63svL7101YsybQUjbk9SVAtWaJvn2ujE1wy87XsQVpg7BOOhVr+M6agvVMw5zUpgDLTxy/cQIC+qSI9AexNo0jMyxR5TmKpIuKlWeMSyLhUC0Txzu2R11Il8JF7wKVIhc+VmwvsyJxERbYVdeKiJjGT9smmnMfxCvS6hT7jSQ7eEuw1hkYjX8Rd90f9V5qc3nBrKCg9PKoaq9F41jJzWE/GoffDPDKwqrmaQTPHYpVyRh4QNJ3pul0UEBwefXDEx2LOynWThiCvAj9jca6y6zFBu07Q2jUpAjYJka0wYdK+zJaR3puWxDQXo6H3+ZZKLwrP1Cj/wo5kjG7YYD5kPcPCNtvQIIPAcXljIQ7Lxqko8ImInmMuypGpUtsi
 Vda9cDFh
 xdQSqCkpIff+GAP1ph81F88oLh1Dhf+cWtutqXr3ePARaOqFQZJPBYCTEHkdcPggbKFmcc6SNBkFxsCiDzLFoc1qFs4kaLEgB3JFbAYA2WStTvNcds/rVWmv81DFu93Y/Sxh1pRdco7Vbm12MxoFZwtKDb4BZkMBUzQm+2zhXUPheQTQxfVeuQ7c1cDxA7uu8zrxfJQ5qamKy80KCbW10B2Dc1cm4EBsqaNwqmGHKqxHdPl5J2zpQyCjjPOaJGpoAqCCu8vI/rqvQhiAJG6qo6Ih5dUoq+nlDzkh70nboB0ONa/flT53F5PgFe6HT1K0Zn59czCAl+KobJmXTEvcklAmevvtnzA8iZ+c1rtFS3wqVeMhRHdeU2rbrBpuySiBgyWI6dQRsO/ZeVDDzgUbaMYmfTD9M8T/xAn+Z9Px74uK58KfWrj+q9mRrM8xs4XGUbif9+Rqm1m8EChbbekN5/PD2cjN67TGkgt2UZhaSebbct7mu7nt51ICxZh63ijHT0fji
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2 Jun 2026 at 14:37, Pedro Falcato <pfalcato@suse.de> wrote:
>
> Well, that's most definitely part of my patch. Also, you cannot outright
> remove splice() functionality

That isn't what Askar's patch ever did.

You apparently didn't even read it.

Honestly, I think you are the one out of line here.

Askar did something I suggested years ago, and didn't remove any functionality.

It just changes vmsplice to be a copying model (one of the directions
already was). It doesn't change regular splice at all.

And yes, it has the potential to be a visible behavior difference - if
some insane user uses vmsplice and then modifies the buffer
*afterwards*, then that would be semantically different between a
zero-copy and a normal copy.

But that would be insane behavior, and was never really reliable
anyway even with zero-copy (ie subsequent writes to user space buffers
would potentially do COW breaking based purely on timing and memory
pressure etc, so anybody who relied on it being visible wasn't goign
to get it realiably anyway)

Perhaps more importantly, it has the potential to change performance -
zero-copy *can* be a performance win, although typically it really
doesn't tend to be (looking up the page mapping is often slower than
copying).

I would expect it to be very clear in trivial benchmarks that aren't
actually real loads. And probably not visible anywhere else.

But your responses have been making it clear that you didn't seem to
actually look at the patch or the history of it.

Trying to make it look like Askar is the problem is only making you look worse.

Anyway, the vmsplice() thing is queued up in Christian's tree, and I
guess we'll see if anybody even notices anything.

              Linus

