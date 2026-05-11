Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 337F8CD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 14:41:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 704A56B00A6; Mon, 11 May 2026 10:41:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B5666B00B0; Mon, 11 May 2026 10:41:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A44B6B00B8; Mon, 11 May 2026 10:41:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 492ED6B00A6
	for <linux-mm@kvack.org>; Mon, 11 May 2026 10:41:35 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1452A40162
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:41:35 +0000 (UTC)
X-FDA: 84755402550.02.61B34EB
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf22.hostedemail.com (Postfix) with ESMTP id F35E7C0017
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:41:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TLisMYjJ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of jannh@google.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=jannh@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778510493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z170Amak81rqK1Z7ArZ4RiigKBxs4M8ehBqJt+giuPU=;
	b=cJIB7CEwTL80lMByaRC/SQZAaNb1jUQgPIWBjctYozQ3MgaQfYw/SvUVeuG+3i6vdC4WU5
	zuSAXT57dGFOtTTDYHbhrMR5Pn1IPv+FYF+0jtsVJoDjGPxx0LmD/n8cFdbppaFvGD/QgO
	CNk4pBBwhmJjssGH1yCj117iBmqeY0A=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778510493; a=rsa-sha256;
	cv=pass;
	b=KbdzQ6JVEj93+afb2bAKBQ9kQ2wmk1p+LCii0tZoyZBWrAWA7fUmavKV/3vlUwDheiuIJL
	QwZsNxGwtVwbBUpRiATNEHkTw7MkKMnZPhENUDlR/I2ocHXMu4WUC7+wPbKmCx4eDCOsK2
	JIuJCuw38sP1zygrEMTov0q5YdH/znQ=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TLisMYjJ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of jannh@google.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=jannh@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-671588ab0cfso318a12.1
        for <linux-mm@kvack.org>; Mon, 11 May 2026 07:41:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778510491; cv=none;
        d=google.com; s=arc-20240605;
        b=it8v+ukTW9mIBT2IDeSEW7iDL+HrwkHg7LqJV0XLX1lhsfwzUVI4P6b6fMg9fgJO/j
         blXKYQpHkGDcnp93KzKBrcF+58T3T4RdQWcPM/l33LHFhL5kKk1XPb6UjOUgdj4cV7Yz
         PvAkDERw+aYK+pRFIhqhSFYCaZMlr43nqPzTH5tR6ZWtMdSji/D1cnH9zukOUGTcmKCu
         fl1bboDglm1H2woDwyT2brtw3TI/VzBeSIW8GouNKiSIiye5d+xOfBw8ceb4mgxkcGX7
         ssjlCqHFHZN81AU5EnDyO/2VYY9ghQEa5mSsJa6AS+D4Tbltp6mh7g0dhEzpnMdcWeAo
         UutA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Z170Amak81rqK1Z7ArZ4RiigKBxs4M8ehBqJt+giuPU=;
        fh=1CfU10SDI4lbZIljxO1iTteOGcdX6D1uNG/6hrLfO9A=;
        b=fbuF0DMZY7f9YWEGLStjAD3J84KWYKybD4MzFKHQnXnLCTyBxjJihFMrph20CmIOMr
         VVQzL/555Sjd68RoJKO1MOwGJux+uhqJ+iY/NAgbpk1uawfTSNlJwQd54IKsmyHlK2/w
         D9E0TFUcJ8P6jVhrN4BeDqXj6TeDMl2f0FCDPWtdrvsQE1MhB0Al3PsdWbVBZXXQHLT1
         0FM93UDisEJv2kpCmZkTJDoVIldW+Spcr2d3THWA8jZI9gQqt5aVOfBRPBcJUhhKeRl5
         QTIqBJR593xrikAR+RtmG3zP9grRhkR8YvkNohjDvOHr2ErUYc/+3/4aNp4Uxe5aGWtq
         /SpQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778510491; x=1779115291; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z170Amak81rqK1Z7ArZ4RiigKBxs4M8ehBqJt+giuPU=;
        b=TLisMYjJJ16HQ1AaaWjgNGmiTIXZdEFRPwWKDf1qNbjes5gZPQK6ujxCwymYFT93jm
         OZBZFs+msCh5+v+D43raVydKQ8VkC3nKzvedRj94vzmV2EbdddREzs/uXE32fBAQZSqo
         xkVMHlt9+bgYEg3KlrZ5ANiKD9ve5GftzbPrF+PRUF6lyVGJZn8CDhtBiMIlv3CLFj8f
         yVAV/FZo0+d/yHEILsk3+FyvQYuUnFDXxfFUJhWMgqfQ9qQr72+Uyo+piA5hmOtd4Zyc
         pivTVDoAaEDQQMtbWMNY2s5rxbewmvXoLxO1ZMn0E2yzIPF2ikpQSlO1nf7Lnllwklms
         zbOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778510491; x=1779115291;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Z170Amak81rqK1Z7ArZ4RiigKBxs4M8ehBqJt+giuPU=;
        b=WPkF3xWjqcvwSrN3uSnOGxaBVgurmhiRQdDmOS2MuMY2UTiZkUHT0pLfaSyMAesc1f
         c40TqsRn2qZFJ9mBJcj1aEi0tef0eL1G9yphJJytAMEJ1Z5F6aylXKBEhuuOwkIlzHfx
         llxFwERzWxJNVC2limqOo24S7C1IJ7TNOKISGM1MtjGJDG2i7Lw5B+ByIFdk/qarfd4n
         3F1rqvN4VwKFqtnaPos+gaOJJlAQF0bt7KHI2xqnrq8nAIC0CxO7nz8T9bTsr65jVFkB
         77lphVkuGBg8leI9yEAnFD0uV3+ts1Bqh7ZmhZJLXROLSR7HBRvtsxTm9ZwqUlBstmps
         WT8w==
X-Forwarded-Encrypted: i=1; AFNElJ8FM+jBKSdnBbH0Jn3kdnnmwrZ1sboxR/1mMFgRaUG8gT9ggNEEAzEhWxsPmMgbBGuKpwmClgMZ2w==@kvack.org
X-Gm-Message-State: AOJu0YxaDisN6sX7f2dNJCZ4a54HxXdOFfiH3Juy/VBI2bPlO0Bj6wGt
	Iu5diwYmRjueKh7aPU4ev/fLrq+IqkpofBnAIRvOZCokq8NHn/I0z/rUnUd6zP6f6wjKUcxfDtD
	aaZ2onJBl06eC1BepVycwNgz77nYUM1oExdkHUskb
X-Gm-Gg: Acq92OGPTz6roFv4lurHtmB7KswQbMVdKRopDMYfRWQJL6AIA/XUjn/guLyVB5zPRzs
	Oo3/pelsuePq+UXLbyUHEMHKHMzmhb2qIDmO/9wJpmh2hlZeXujsIeYsqGJnjPUSzrR5YM2Jq45
	9PyjxIUroXyOR3ucFTbWjoBwopeimWK1Uaf6GYM5rl+mrcYJtt+mfCfIWYBF4N0LbIH8JbVLLKL
	fSFN/9NtzEiL5JHTUuGjIhkn6Ew3KMnlHFxFMgTwzxyqQFMnSm+B6+joLZf6Oh4mh4etCdcOamq
	165llhgPYl0MqDtB8oVLIboBSegD73xWrMPNdr3pfJGgmuiV
X-Received: by 2002:aa7:d702:0:b0:678:a5c3:4d12 with SMTP id
 4fb4d7f45d1cf-67f67ef588bmr85386a12.3.1778510490891; Mon, 11 May 2026
 07:41:30 -0700 (PDT)
MIME-Version: 1.0
References: <20260427153416.2103979-17-ardb+git@google.com>
 <20260427153416.2103979-19-ardb+git@google.com> <CAG48ez1DJ88a0pBCE-Q0VXyDuJgng8zdunb38g4b4JPU88exww@mail.gmail.com>
 <31252c1d-a98d-4635-ab61-ce5b649e256f@app.fastmail.com>
In-Reply-To: <31252c1d-a98d-4635-ab61-ce5b649e256f@app.fastmail.com>
From: Jann Horn <jannh@google.com>
Date: Mon, 11 May 2026 16:40:54 +0200
X-Gm-Features: AVHnY4LoyjasIFmS74GQZueVkF8l7m5tKta7HqO6wHGgS7XuvrG5_IpYer7LdIM
Message-ID: <CAG48ez2xJwJDgxSH0u2G==9dOQJQxQ7WsQfU14O1H5hEWic1eA@mail.gmail.com>
Subject: Re: [PATCH v4 02/15] mm: Make empty_zero_page __ro_after_init
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Ard Biesheuvel <ardb+git@google.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Anshuman Khandual <anshuman.khandual@arm.com>, 
	Liz Prucka <lizprucka@google.com>, Seth Jenkins <sethjenkins@google.com>, 
	Kees Cook <kees@kernel.org>, Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F35E7C0017
X-Stat-Signature: sm3wqty1jtg4rzd16kkej56bbp1bkkuk
X-Rspam-User: 
X-HE-Tag: 1778510492-172283
X-HE-Meta: U2FsdGVkX19Kl7m96pHMseSgcIucvh1FyT53PGDgEwTv++mMFOv5IqWnbO4uWjY0bgyV0skk2NAtPfFNccC8+2QWNkPGSBRZO1+wBecRJy5VukXzmfhy7ii5tFfA3qxcYzOOIWA1yHUjztQ2l9vJN+MFCm35GFuoa49d8exzDO4XZwAL6vy8rLww8YWhznE+NfFaDksVmcR7V31XIupFetBkkXkJqZohh5ZOSuXidX//ok3WQavUpEYzCEQ1EYJg9zLdPd4JYggVqbFmzIwJGYMBSi7Q382vF3dGyzvp28Wpf8/7ypmr/6C4ab+jlRZ8emI7rmb2RjqxlV5EmRhonRW5tvebZJTfTJzjeDnt342Xt8Dwh/ZvIyWTk6JH11NWemay2pCZQOCC9WcijthAvKmKjGXKCv9x9IHrJIDyZVhN40hp1NTA+h5cA805S2XjyHBYXGJ5VbNzFqZUsshEZr5xlT0ypvnzo4Xy+kyfK+rGgy1wP81gUfaHCeCpDYpI6n+H6DIOTLbta0oeRviHpf/VLxI2FJ7gdtNJ7IYacBXvNxeEbsBOYbB+MPdjBLjiRPSMxZkAqigDWzU/mlkqRVpDVWg1ooqlf9YwRvyo3LYO/hoZexYB3NS1iI8diuRTOUL2dbQ9ubavxojmlEi+0CntX36p90I1hx2QdNQSxUKWi84+rHZOMlOekcbp8t7awsVBPCySaPlxaXMMJkK+d5cCSVlGf+2A/jGWLC8d1DTeJeY+U6vkVTTAeWCWBsXejutIvUUBtS+19s67jmmMJ0T0DUFPmY9Q+25bCBJbl6IQj0ZgmPNj1f6bRsw+DJfvy0ZslttO0/Dj1UiA0DL5Br9RQLxWaNBUedlW1Y4s12F84qxnkyJ+eMNQGmOjJ9mrgPram/bgvh6z3KScxomuckTE+MF+9DQglhcRYfivZ924oTQ0eL5SYT9kZoBYnjA4prp4lzQiJiRpmo9unFC
 nuk3EYjB
 haXFKnV+BbjjZ44Hzgvr0KElvP3q4u4ixtBw+df4I2wUbLTKnV75zyDt85eJRwGbzG9wix7YYEmii45M10PBV76oBZuMZJjho26JzTOkGJCyO5MR0strpF82qzqb5xAHUs2YhpebBHbDOTJynBxHokBsCmXvJW0mT3eq/DF6XU1zk+DAqncZRx1mSdpyCR6qcZg7SRb1+UAFJcVAev92zXnyqw6x94+B3VMY/AlFxxa12BK6Dpx00sNBRQ78/dAR4sB9/NBLaAwoFYZcnd54vaIaMdz/jX2CUHtPKLBiY8IAoAqPgH6s5NGAcKycmDkGGF828jiqNMfQ5ZONayZUWutIa/KKvEEkN0v2PMHAixV082FHGuDXJJaWMtvAMWWXMTv43
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 10:59=E2=80=AFAM Ard Biesheuvel <ardb@kernel.org> w=
rote:
> I think we should simply do something along the lines of the below,
> considering that the size of a data object tends to correlate with
> its minimum alignment.
>
> I do find it rather puzzling that the compiler emits empty_zero_page
> *after* zero_page_pfn - ideally, we'd combine the below with
> -fdata-sections so that the linker sees all individual objects, but
> I suspect that would create some problems elsewhere.
>
>
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -452,7 +452,7 @@
>  #define RO_AFTER_INIT_DATA                                   \
>         . =3D ALIGN(8);                                         \
>         __start_ro_after_init =3D .;                            \
> -       *(.data..ro_after_init)                               \
> +       *(SORT_BY_ALIGNMENT(.data..ro_after_init))            \

Oh, neat, I didn't realize that's possible. That seems like a nicer
approach... (Assuming that it doesn't cause cache efficiency issues
somehow, I imagine it could be possible that source-code-adjacent
objects should also be located next to each other for cache/TLB
efficiency... but I have no concrete reason to think that, just a
thought.)

