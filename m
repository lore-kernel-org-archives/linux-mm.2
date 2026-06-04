Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BFF2CD6E75
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 19:30:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B28E36B0005; Thu,  4 Jun 2026 15:30:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD9B46B0088; Thu,  4 Jun 2026 15:30:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C82E6B008A; Thu,  4 Jun 2026 15:30:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 88A756B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 15:30:53 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4E3A2162173
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 19:30:53 +0000 (UTC)
X-FDA: 84843222786.27.71D8C29
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf18.hostedemail.com (Postfix) with ESMTP id BDE1F1C0008
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 19:30:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=Ii2Axgd5;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.42 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780601451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/vRjXw0GxoiIE6driNbyJfpHo79+KlSJNRDFpalZAbE=;
	b=kO6r4KMCb7+a2hxmkygnqBKZjQpDmP4Gl0Kzdoxpf6YPx8+xTJGaC9Scug0BHWxTigJOCd
	IJXIYlhFvZbySlNjEaR3o9LPpIIVNR4mWfKKsjY4YgGegT0EkbxMrb8jDvOAWebxHEzNHM
	D6F8kytGfU1yCb6/99/nJT/iR7zHiUo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=Ii2Axgd5;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.42 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780601451;
	b=a1+R5oZq/VfaqA37FF2hiW7l4uAI6AZOZ3SjpKSRjRD+P0/BGUcQrthTq7K+HO+xGJe9pn
	B32+V+QQqLC7+BcROrj97PieD1VHUYvwtkMOxl2xMAXhPqejgX182JvVK1qH76aW6sdcG/
	xZsSiaT0EW1g9raxk4+Bhf+r9eScgDE=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-bef47b1ac01so177885366b.2
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 12:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1780601449; x=1781206249; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/vRjXw0GxoiIE6driNbyJfpHo79+KlSJNRDFpalZAbE=;
        b=Ii2Axgd56sp+0hK5UFlvta279OXJEZPieDnZQ3U/9tVDFOI3GJXZtniZlK7mLa16zz
         9Hvcns47OIEkLpCmbW319r95tU4QdCSzJJAKA3JiRqHj7a+LxIq5KNSFQJ/39pWSintD
         YdJlFx5OlWrtXz1qNETkDk91xslv330rWVvJQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780601449; x=1781206249;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/vRjXw0GxoiIE6driNbyJfpHo79+KlSJNRDFpalZAbE=;
        b=MEBeI8CHKNvTgnT8JQUPpxGhk/PukqZ/WSqNnGqY3mWZHO85+m5QH9AVX8rNkw6poQ
         PpISqe5bAk3aXX5M1G9cPxuGqNHSdfAI9lMMSldwPqdOCxb0WfuzgRZE1qBTd7NeyQsu
         N2jMLy4fdjQnhKzFi5228aI0J38B5QCQ4zgCY3E8n8mCjU/97zn055ENnOVq6BjXmmHa
         vEY9tnoUL8mREUyhx9FXLRPbZVuWB8/DznOTV28VhxZzvXUikTY/mh+Jx3YQaBOx2kNS
         hQQHFcFVBYO2VqOylg/loQHoCfE5F/QBPZTsxw5gMsbRseJP3ALEr7zXtY1mUZe8szS0
         bH7A==
X-Forwarded-Encrypted: i=1; AFNElJ+9WgN+LilHVrjzYFIODiLGmoeIKXQnqcmZ2KAXQrEm25hcaxr9qVB66VWakTJvrzKX1TfMr8vhSQ==@kvack.org
X-Gm-Message-State: AOJu0Yy2d1ruVSGCOqEc9xSy7HOTMmTebxgEfsz9eNVdbb+b1B6O9V/2
	6ge/3Rak2Zt/arfnIruXSr0dH6Xhix7QbqwPI/lpKmPI4ZxcbSqTsVPTFy0ZcHDNrODGa/f8Ve7
	Dr5NSw5zZBQ==
X-Gm-Gg: Acq92OHFKF16dn8nKNgc6G4rMrhtC1oGhN7R0de0N2kmPMZhSkpoWyeIP5YMbN/zXl9
	8e9p2hyU2Yr2zfAZTs1bqJ81cfEAiGnJwUbufNwt7xpD/CM/mpLiSWn+wWgoi8I+CIm/6XN3VF+
	MTdV43/Q6JO7Nmgi0Ui6k4h0A/irUs2bJRWI8a3K90jR7Nws+TB23VEMUL1WjD+oMVX9KBuu7qY
	UbR0LQlff6hZ8m6u0zah6YdCjw8awEPilxw9PaPo6biFsXT09R/qpEfTd+dwCx8hLqmdIhouktJ
	ARa2tNW+mg8dRf2n29keXbgPO0nHeSdVFFsfmRxv91fUE/M46+wWeV0CqUf68klQQ8LQMSvz0D5
	vvva8CP1uxQnpoSBZMeIwkkz82gBf7orENiDD+0myj/Ad1XLDIGtScr7JBW7Y8nrc/N1SV3DNIx
	LHkglctd0QjA5pXkPszfKf6lGeybu6B0/dl6cH18gIKADU0ayx/egsgYcFfF4d4AUlxli7vODYM
	jUzIHshhcY=
X-Received: by 2002:a17:906:6a1f:b0:bec:5264:e52d with SMTP id a640c23a62f3a-bf37037f2b8mr5427566b.11.1780601449020;
        Thu, 04 Jun 2026 12:30:49 -0700 (PDT)
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com. [209.85.218.45])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bf054e086fesm357252266b.32.2026.06.04.12.30.47
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2026 12:30:48 -0700 (PDT)
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-bef47b1ac01so177880666b.2
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 12:30:47 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+zq+LOIqmFLuCE6CKay++56SGzvXaPlUxYv1ujOVOtTwktyGS3rfEVC9418jvhv8wjgamPe7qXHQ==@kvack.org
X-Received: by 2002:a17:907:3e20:b0:bf3:fe:1d5d with SMTP id
 a640c23a62f3a-bf373306d04mr3098066b.43.1780601447577; Thu, 04 Jun 2026
 12:30:47 -0700 (PDT)
MIME-Version: 1.0
References: <f919874c-065e-48be-ac5b-300c4ab86d4e@samba.org>
 <20260603211736.755139-1-safinaskar@gmail.com> <20260604100609.6b37f500@pumpkin>
 <CAHk-=wjvb56qo27-axALOKCY-CjLsj9_294zeBovPVJaYm14dA@mail.gmail.com> <20260604183829.63c35fd9@pumpkin>
In-Reply-To: <20260604183829.63c35fd9@pumpkin>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 4 Jun 2026 12:30:30 -0700
X-Gmail-Original-Message-ID: <CAHk-=wip3mwLOHOYJ9TtjDxOaq9YUXmuCg2AycyASGgeY6qqUw@mail.gmail.com>
X-Gm-Features: AVVi8CdPQe90u6Sxnc7w9w1KvqakJpNEvGXvNsTMWUZWIferNC2FIUNZ3K7Amh0
Message-ID: <CAHk-=wip3mwLOHOYJ9TtjDxOaq9YUXmuCg2AycyASGgeY6qqUw@mail.gmail.com>
Subject: Re: [PATCH 2/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: David Laight <david.laight.linux@gmail.com>
Cc: Askar Safin <safinaskar@gmail.com>, metze@samba.org, akpm@linux-foundation.org, 
	axboe@kernel.dk, brauner@kernel.org, david@kernel.org, dhowells@redhat.com, 
	hch@infradead.org, jack@suse.cz, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, miklos@szeredi.hu, netdev@vger.kernel.org, 
	patches@lists.linux.dev, pfalcato@suse.de, viro@zeniv.linux.org.uk, 
	willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BDE1F1C0008
X-Stat-Signature: ewe6yw8usjfoo5w8de3a6q945ntfzy9u
X-HE-Tag: 1780601450-585410
X-HE-Meta: U2FsdGVkX19foqStUQVz59S+fMBrWM/1or1Fq8jF0lYsdI4Ftzp2K13EpFZPVl5qcBhRvpB4Z+XK9VzXlU5CcV+B4pnJcY5zMs7mp9EL2y2W5j++Wb4mQyCzlh9sOWHlgy9LLx6AfPz138fq0S20wa0tyldLlCvPMQwWYVqqCt0ETBJmG6BlmDH6ylszQXif2xjaKKIvaTspiLAMh2SgBkQSmUBHANRfSeKwbKmlb7Xy90v7gx5NgPxGJmXMzpeZJjsmMiyZybDC4b5y1T/R4P2MCU8S46+bHRINFaqHlAFU1wtouW35VxpO5NhSkht9mAfxSVSXtIHVPtC6804wkrUoD3pQ8u2bsRDuKXFlYpH8GHqJYlyHV3eb1/RYD/XxxPmGG0LYbpAhe14tvg1Itypfe3XJZbKZpU7+49zmn6aGb6prhtw5rBN3kMYFYiqZiiXTyNuvo4MPU0HAKScP/2B0z1otxWK+LyTDbSCgvSGNM/wBxi/umGUzTOVyd7yoJhyDKWm8C2i8m0D13Smxp9IMykDHXf3iRfgRyoWJEKKP88r6LM9YlLcHEW91wVungmTLuR61EBRvc2DjCDI3d5K7J2oGPd7B35LGJCvNha5gkLSJnfDSvI98ywtB8gchbdedDCPa5tN7IYS8b/v8onFABjedEXR/+wj+jEZit/m904FtVwNelo7EkW25imr8SWOKT0aK6nfs7UyBbSYlIgvzGuZ09L0GSXr8/gLiQrKCi0u92Oszdq2q14wwXOU9A71HWHleF2Z2exFHkWGhk22n9w41nF+lpnt7sxC6cQl6rP1x29O8nvIAFSj+wyz360hrt12sJUJnzGGrcw4vmxviNLPyNk0jgm7j0SZnmIqXCUA+BHz5VzHJ1Fp9hhfORAPvIUCa580AnAgQ4Nm6h7JskUBRnpGMY/Hg0M3tDuNh2HxA8CnExDcZ+U8zHJqExBQbjscA899jH22fHlD
 vnwH06tj
 jy7ediUnvIA2XaFAhELq0/rmpNCOpREphyYuiI+VMEjvxuKvRJjEEzTtsz0qZDVAJdqzgrU+RwGQhP+Hkzt2T1NMy06zcnderqmaRgXBwpI3ScP40KytoSmiP+GIWrnz/Paa/7R8SCz1BHEwFvAtIHizF8zDTs0JOvXJ6h/Fu1xkHlifrSSLc4xNB6B+ymPetVPrRqXsuJVpBscNvhUjaOF4rI0hFXAX709/dtqIOLK0+7x4i0C19gXoAPizosu5EO7CMK9zWt+OCB9m89Ae0Xm6+gOg6UPk2yiiDoaBpS2DF+K90L4IeKCuorsSOYvEn4T1mXVMmczRdmJ7mZep4QdUsRMG1EYCjoil2YEUyC6GhZiBuU61KVf3JiqveuX5fGYqAP/4l1ODdUExX6CyHLldAtL2MvxwGK3tHSDTSKlO5drv5FgJWrZUKatuBH/1rtfA2sXUD7ThjLuIY2S/LcPj6y63aiGMf/jk1gecNyl64I0B8njKfUuHSnRU04AX55/b1wsqgQ8GwPYfPSOiOMgO2FMG+YEAUdn7FdvUbMsKYTiaoF4fk8iFMJ7GR3ktgFk7P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 4 Jun 2026 at 10:38, David Laight <david.laight.linux@gmail.com> wrote:
>
> Bool is another matter entirely, (IIRC from a couple of weeks ago)
> gcc will assume that the low 8 bits of the parameter register are
> either 0 or 1 and clang assumes that the low 32 bits are 0 or 1.
> You can't even check with 'if ((u32)bool_param > 1) error()' because
> the compiler 'knows' it can't be false.

Nobody should ever use 'bool' as a system call argument. Anything that
takes a boolean should take a 'flags' field with bits.

But this is basically what a lot of the SYSCALL_DEFINEx() macros are
all about - sorting out ABI assumptions.

For example, on powerpc (iirc - maybe it was 390), a 32-bit argument
is always sign-extended by the ABI, and the compiler *depends* on
that. But at system call boundaries we can't trust that the user side
actually follows the ABI, so SYSCALL_DEFINEx() will actually take a
'unsigned long' and turn it into a 32-bit argument so that things like
this are well-defined and you can't fool the kernel by not following
the ABI rules.

The same would be the case if some system call actually takes bool
(but I don't think such garbage exists). The SYSCALL_DEFINE() macro
magic would take the full register content and *force* it to follow
the ABI conventions, whatever they are on that platform.

              Linus

