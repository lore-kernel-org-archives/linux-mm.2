Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5591ECA0EC0
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 11:19:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E61FE8E0031; Mon, 18 Aug 2025 07:19:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E39BD8E0030; Mon, 18 Aug 2025 07:19:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4F9F8E0031; Mon, 18 Aug 2025 07:19:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BEAAA8E0030
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 07:19:11 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 90608160841
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 11:19:11 +0000 (UTC)
X-FDA: 83789631702.20.36CD4BC
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf07.hostedemail.com (Postfix) with ESMTP id B5C1D4000A
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 11:19:09 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HmNWlEu9;
	spf=pass (imf07.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755515949; a=rsa-sha256;
	cv=none;
	b=e68paVz/fYfWhDo9jEpQpm6OiRsZfdejo+gNKHgxygKt0PZo0m7hrOriIF0+inhNnSybcI
	rAI59nwNALlyD2njVnYrU4P4CVO9Dxyciv9ZumfPphlE8h2IhbQPk3ulFDc0NlWr/7nif1
	tVbh5U1m59QCWjwAw+xInd/tgNZHugQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HmNWlEu9;
	spf=pass (imf07.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755515949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xnirQyl6NtJUepL0SbTKIFjKA2ZZeazliRyo80v03Y0=;
	b=dSwXZIrs1uPSA8+puQKiK+sFnFoRJ7xxj1WFs8dKWL8AkadntCZMOoy53CBUhMSV+yaMWU
	L3HNYmZ3ALfOMmN9GD/lMHJhK1TpaZVkt3mDmoxInh2eam0pGA5wGtNAkGuDWOfYfeMhyX
	T1OZA8HoEUymAIflts9eLBaUytzNrGo=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-32326e6fa7dso497798a91.3
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 04:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755515948; x=1756120748; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xnirQyl6NtJUepL0SbTKIFjKA2ZZeazliRyo80v03Y0=;
        b=HmNWlEu9m5ob/sXFZC4Mp5bfPipug40sNO4smjvv163lwN/r1a+HtBFot9XD8SBDIA
         t4JiJIJyx13PKqUNLurRKRkwFGKMzGxwMgrBwi/wj8yiF9DzisHB2HeoO0+sbRSDPHKT
         XPD09f+aECYP6hhUWlyjMmYURaHAFvlceYAl42Yooa1kVbRLjp6S7dSJD2u4Lkiyq4bA
         fm2fDBxSgjXcrEo3SPX1pfjFqWYOTNfmlWrBwOXvOhd7F0ihfZZdFEPuXNIN3lrwba5v
         b2ChdpwawkZnKBtsHJOeppH+tltkB8MbvhlCZztcgJeESi2c/9hczUnVP8I6Bm8xlGan
         H45A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755515948; x=1756120748;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xnirQyl6NtJUepL0SbTKIFjKA2ZZeazliRyo80v03Y0=;
        b=Ja4oRXqzwzMoPNgeZRurlAb5MlOVJWrPYmOhKJ/AHpYlzmOGAbJxDMrzqygBRzRFgL
         L+7umEPejDyW8d01qKBC3eWKj3m27z+P5guWM//xN1CFsubsPu69wHLEaj3C6fyaIFxz
         vm90TOdLLil/5qfVevu4aq4m5tkOzK37KrvL//aszKylAE/7LJIlGURzkJUEeoEB84RG
         U66OMDO70QZfIivw9/V4kdE40uI0+8CageMBpGRA8hgcJV+dlDIo9urwpP/hGQ+QABwB
         /0BUATO/BPXMFQ26dboabZPOC1yVJRBEsuJ1GW4AnZ304BpqkVGTcR8nHmT6Ce7uky3a
         cpcA==
X-Forwarded-Encrypted: i=1; AJvYcCXKtWbQlkFVReilX0hwRCgsCodV0CZIRxIjJ55NBTOl2h4ZYsKr39IO8OEsxfPh+T8lMzRcILOH8g==@kvack.org
X-Gm-Message-State: AOJu0YzbHuLYCjdo9c20IK3HYkxFnTrL/3QTNQUWEGcSQVKY5hzIvI9A
	SC7HnCmNCtaXS1aKH2QgKmRMom70STo/pngm1tAEAPV5YenoqKCy+jvfROM2xlC4XNaz+edRYeW
	TqqDoGwXKn+C3J/+sNiGSf6Itl8J+FLQ=
X-Gm-Gg: ASbGncs5MI96/vnDHn7iir/OMwM7WgWc4CQhMv6tgYPgr5geWcToMf6lWwrhqCsdFbe
	FYAQ5rpJD+IxEJyuzhzzBdSye2BCpeMa8H/uJOFqMjow9FdqeqYNjFMol92rdIpmtujtovogj+c
	N10wj+tg92fYw9zkZM3Nb4hP5oampIuyga9o80tECGG0tbAb/FCfLLAyr4IxiPBM2yl0UQNAuQc
	ZhGVsTtMB7SP74qCXw=
X-Google-Smtp-Source: AGHT+IEB6mtYk5NJYh8LYxYr8dqZwcXL6UJUoFRAcV5Kygvnph29+Alv9tMPi0agX62hYV9p/H4wpV6KLKD0EHqz5fY=
X-Received: by 2002:a17:902:ecc2:b0:240:bd35:c4ec with SMTP id
 d9443c01a7336-2446d893254mr55283185ad.6.1755515948312; Mon, 18 Aug 2025
 04:19:08 -0700 (PDT)
MIME-Version: 1.0
References: <20250811-align-min-allocator-v2-0-3386cc94f4fc@google.com>
 <DC38NDRET9NB.31UDI8FHB7WAY@kernel.org> <8aa05f08-ef6e-4dfe-9453-beaab7b3cb98@leemhuis.info>
In-Reply-To: <8aa05f08-ef6e-4dfe-9453-beaab7b3cb98@leemhuis.info>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 18 Aug 2025 13:18:56 +0200
X-Gm-Features: Ac12FXwCrFGErkROMwouACVOQgFbTlyq7QH7i0XSag3tm7GDnoPUHsI2GpMApSw
Message-ID: <CANiq72mpYQU9CfwjvHvxhBaud0+qur3Db-hmKVqLKPLp_VHaiw@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] Take ARCH_KMALLOC_MINALIGN into account for
 build-time XArray check
To: Thorsten Leemhuis <linux@leemhuis.info>
Cc: Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Matthew Wilcox <willy@infradead.org>, Tamir Duberstein <tamird@gmail.com>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>, linux-mm@kvack.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Stephen Rothwell <sfr@canb.auug.org.au>, Linux Next Mailing List <linux-next@vger.kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B5C1D4000A
X-Stat-Signature: wk1ojhom53azpc6zc3exfymuhjhhtfqq
X-Rspam-User: 
X-HE-Tag: 1755515949-487358
X-HE-Meta: U2FsdGVkX1+1oIf1q7IJTClVup9F42OcesR5JCmKnHdrCNrfeLMXvifOI04aQIE989a2BixGChJemzk+ery3V4uUkQgC5GuniOpiF84Hwvkz6p1uY8yJlHAqJlsnOahb6/wXiIV2VTO3KN3qFkk8WTJy4LUZ0fXxETwiDwliVqiK+NoslpSdmvHVjRHntS9iPGdKOQUSuSKP+wdWd8w5dtWoYBiMNkf+HuMbDZRsbSIb1BHM09VV1FMJ5FO02IY0sIrf8ou7H1N9YxLlFi4ByZGMdKMDDumSbTEi3tEK5CVWGdwwWe5RHQl+c9AmUnuIHR3pKazl7OWdHurMCE0V9nr8tJ4Qp8BiRWp7+uUWH8Jgd3uJeM/Kun0IjTp21seate+rcH7x5TdEB6lxiVG5K7e8BMyG7OFY0if36S1EvOzHns9Of+sHBACm3tqfVMaeQEQeSlWPYLnKCujS8ktNldxtTt2UnvLSpxNeBpmeqcYjtkiv62X4CARN+9dxvuRBMrXpfKTzaot0QFJOSQ/mwGRyEnNHwuEAhfh5DB5F1RkyHQcDcvAAF+2et0T68c6egU+Y8500qnpGHBHm53xAm5UYum8rosNHqui+esSXwdyOPiIyTuij9lWmLOM+zHniKfYrz+l5CRXmk3YaMAgcCLdR2G5GpwMwITO0Er7gUMiQgYhO/4cuGIY0xwkNfvr1/2vbtIdEfEaf5uRl3DWcfYDih0L1oB+6Ojp0hOjXs2a9i3A2OorlIFZSzdnJDdDOcvi8VDGdEvYOqK9TxCNwUwlpFi/JfMZm3ioV9wfz2T/LXZuNSR8b0WzJoOpiU71upQmkegUg4YjWwMK+bn2C+ky1Iqfxv6MGoCdoB9OtYW/3RrZN1AucF6eF865dcyeeNwQI200PfwfDYo+WWHZvJbB/BxBoJFFdy5WcxC8UuvW60aQWKAJ3xpEkYt2RGHCZR8uLpFvpAGJwZYYwUKw
 CGQDuMDK
 T8HMo65zu+SoHBhie135g+NTnaBIlQjXGvM9UQ4I2J5/aKSpVUimxtZzGcUwVL1m87a0tUNrAoFTsn4B9/lP8Em9SZWWXd9CUsors4NKEgAnFCR89Z1aFocMkXTF0kYVG0+7j6VSBH7M40oGHuXJ0D4tFc9fS2PD7TkDIUnGoGl97pa6MNqgNKV5i9dyYvM4qIR66CwkfTsBwXEH1+1XRFVx04HSMuQhV6/Yl2WSFRJNQEDlaInUD1zYzHppu1+ixJh1F6/Q6m685PTRuyAI2b4PTjCQRUYrtXqKneWRWL3yBEgTZ/BKLyr2Zv7GPZG4HkijLt+FJrdaUCpX5tVm1JZC05+SumiTwIlk/WxUKdUr2I05HLmdadqhmciA3ZXZRqP0wgUwaE3I5Q3wg2R8WCZQ46EsPgwJeNuxX+x9bTARXA5nucwaMruU6ASW+f+wr5rn4yuzpclRhl6t8LNj+jwIaJG1wEzFaqJVMEPCSBtafTjXggVuEPh0CvDUy/xS9J5TfG693f+qmh8kqRWqt57Pwl7ptzm66x9fVshFGKPIeg6Rq+G0JhXJXBsg+v3Hqb4AJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 18, 2025 at 1:09=E2=80=AFPM Thorsten Leemhuis <linux@leemhuis.i=
nfo> wrote:
>
> on arm64 (ppc64le and x86_64 worked fine).

Yeah, it happens in arm, arm64, loongarch64 and riscv64 -- we don't
have powerpc support for Rust upstream yet (we had it originally
out-of-tree, but it never got upstreamed).

Cheers,
Miguel

