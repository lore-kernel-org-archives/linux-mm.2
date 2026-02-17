Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBF02E9A03E
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 20:25:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F312A6B00A0; Tue, 17 Feb 2026 15:25:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDE2B6B00A2; Tue, 17 Feb 2026 15:25:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE18B6B00A3; Tue, 17 Feb 2026 15:25:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CB3246B00A0
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 15:25:02 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7C5DDC0D9C
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:25:02 +0000 (UTC)
X-FDA: 84455077644.17.2122530
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	by imf21.hostedemail.com (Postfix) with ESMTP id 828541C0008
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:25:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MxeBpIhS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771359900; a=rsa-sha256;
	cv=pass;
	b=P0Ux3fYpXvuxg26NybYVERmTF2CUevtydOYS2IcXRi8yxERO+GyAgxioElU/Grqg4n4m6V
	lqCCuHLI8rYy8MnbbMp9Q4rD+/18ZpNUQ7Qwixpt6zUctOKvu+zqalACQ/pTxFj0jgI7EX
	3b7pAtXMDUoNvSOrjohvrOqaRF4R7k0=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MxeBpIhS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771359900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rDDEWsw4CKwwqmAURAFC3flEZcqum1GMx4CN2UKN8vA=;
	b=uzLZCUby3HaaNjQmAy3zS41AYDNXyTlFV5+S/Xib4lGKdhit2Ch8wA3quOWWpc1c3INEMR
	G2qFeGZfwUc1VupitS2TaWJAINWV0mPkghYWyMDtg3knVQ4vsUQeXs6XvdZ5LGG8K1f+aP
	7S7xObttshdTUC2Ahxitu9RK0M+1W/o=
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-1275750cfadso66055c88.1
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 12:25:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771359899; cv=none;
        d=google.com; s=arc-20240605;
        b=Wo2+TYaOBbIGOpE2lgmzHCu8Knag2qXcDuvaOz7w5dw7YB8KacmNMbmLr6Sp7n/DCe
         Egi46IPZ6rUTTI1WVQr95l0Vk4+VVOpbaHJJnNIHSh5Rd33bVlfD7zZ07WwnDMec1jov
         gjF+NRXn9uimeoT+3xJyWFm2Kq6BYOiKf4s9/xfEWHNJWwr+jCkoKSmAdD6cMFcVj2jo
         20dW+H4uU13McugCskbS4TMd91hN5fTRtlAstO4X/OzmTUn+OrZVKjklorvbwPekrATl
         4yctIJYbebMhqA6v57g4TgB1CC45Rx8imG3acRaZFHgq3O7UwMUWgA1L8DxHNwimccWc
         7USQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rDDEWsw4CKwwqmAURAFC3flEZcqum1GMx4CN2UKN8vA=;
        fh=30J+V0WbLfavmgAWuOzy+5QH7tHqM5qrnc5V3XS+0mA=;
        b=Xm5zp64eSzCLVqQJxuefDaGEBhS8wglgpKm0/b+R6biNZFNXQU9GsWJReR3T2nqAul
         yxFBLKLXEdHdaMalk4Hl495WfNeCgiYCC+jKoB8VPYXtJnIJrSiVd5xKoIeGSidIRd+G
         u//EENa54oAKYbrLhY/etem81ZM8VZaKEHz2m8ndwcR3q0MrLNUReAjvXHRuELfqOjDX
         ogc+j2Fj5Xikvy4pQPns19/P4NdeS1YJ5TJpc+5ntlbn0ztLKbwBS6LVKAyGuT8D7kWV
         VTNtcQ/gMuTsZ5xM5DRneQhgK7gRJU0tZ/bPM7uTapd6DUoqawZ+FDMXoKnLfyLVj9Yx
         bfeg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771359899; x=1771964699; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rDDEWsw4CKwwqmAURAFC3flEZcqum1GMx4CN2UKN8vA=;
        b=MxeBpIhS97IxvAefnLlwVpGutw9h60ttIVYAP/iILhtE2t1VYgVu69mcWLZjAV/fMc
         fzyny3AFhQoad8qErzcJxncrUJLqu8SystjluDlKrRl0CB77EF+cXaLK3EYaRl/b9ZUI
         ALEzKUw5LDmu67HiQ2btnUO3hF2XSIVrP0x2uu+pRlFYA1SZ6aSc5oPzeFmOOBn6SvLo
         F0FJ5QzJ6InC+CixbBpBnCfyU3wDOkWggK4GtYtDRN5c8J/Ef7GUBGovhSMdCO9UHetB
         0dfZkj7fWA/yG4K4GX5hBaAZ5SpymW+SxVvXDriBbsePTMSdeUkOEtPXdlSYnsLK3RjU
         VNng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771359899; x=1771964699;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rDDEWsw4CKwwqmAURAFC3flEZcqum1GMx4CN2UKN8vA=;
        b=vQVFhaO4T7Trd69b5Wl4lrzs6Cn8/8E+i/Q1oXssTsX2JAarpwbgO/JNHVhcHVAxE2
         +rW/zWuhrzIiQ8rcZvmBjSa2DjiH8PH0Lw0ml94sFvdeChV3n9pETUeYV5M98BKQKFib
         Kflu7A4Pnk5iZYa2GVc/N+385wAIaSlD4+m9Vd0tTfpoA0OqMY69myYGhqhyxrut3yxu
         YZucUL+qpqRWdLK84REfAu+HJn0cTmbMGd3i8/Ehgx+mKGWmbwP4+N0tlXZGbzj9dbnd
         hP4qfvsef4GqUDg8fhaavuxepBFKz9a5AnBWnVoX/wUDPLBMq7rB6y2IYY/Y0FzInWLn
         sSGw==
X-Forwarded-Encrypted: i=1; AJvYcCVvcIimI0RoDJ2BPtTvsGfy13An7xnoNEbxZEfv4357cTxfe7/XtkBoQ5cdqbvipAdNQo5m+D1WRw==@kvack.org
X-Gm-Message-State: AOJu0YwRIIwC2KrOfqksrUkNblNtlT+C9W7a4FrJDr85Tt+OGAzyxAWB
	NZI1sWnLwcn9pgdRZAEWX0wKcZjz1KSLYpD2z3by+lb4d8BStNgEqX687o2a6rEd/lwghuEK1B9
	LmeIv+SWKKhapHFfaOFR4fm5UAXrb0S4=
X-Gm-Gg: AZuq6aIqlVJTvOwf25LyTroi577BxU1cWqC//TFH3v7Uch4SUHNmg9xveJe7fCc+yu4
	WlOwHv5HuFXQtzmImuJ4u85AMsyUeudGR1Jh509KRT4uN56BZfGCvDLWoJ9SgcaG7wO7Ptm+cw5
	NOs8KPnBe8YdwR5ojx+zk3mOKD036iL9jyQw3bN7iU54bDCLXWSlVsgi8XDhPIvlK5xMZFlsOm0
	u+p2BLW5sBLBTPpOh8eBvMp5CLl3XctOGZ7/hb7hhyOfVJaQne9xwdWshQ6lUXWhdKDXYRkAiBI
	6g5PKwtdv14D0E+R3ctjX0xBhMBhbv8i/kmXPsZ2wlLorjXz8ibIHMtEgkmTdnv7cTESZyrdO8k
	TBu6oQg71LDBMjWBnIce0Emke
X-Received: by 2002:a05:7300:fd18:b0:2b8:207d:6a7b with SMTP id
 5a478bee46e88-2baba0117b6mr2978273eec.2.1771359899022; Tue, 17 Feb 2026
 12:24:59 -0800 (PST)
MIME-Version: 1.0
References: <20260217-binder-vma-check-v1-0-1a2b37f7b762@google.com>
 <20260217-binder-vma-check-v1-1-1a2b37f7b762@google.com> <DGHC1OLDIXC7.Q4IAOOSMHIY@kernel.org>
 <CAH5fLgj2+XUzsuAnvwL=dc=5yOZvXCapBWRbFGwJAX2v5Wk4dw@mail.gmail.com>
In-Reply-To: <CAH5fLgj2+XUzsuAnvwL=dc=5yOZvXCapBWRbFGwJAX2v5Wk4dw@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 17 Feb 2026 21:24:46 +0100
X-Gm-Features: AaiRm53pWPPTZa9dK4uHNNQw0RmQntvFMMvdgsDwpfgj0y84MDt3F3iy0Ue6yrI
Message-ID: <CANiq72mw7PSEcRLPXWz3UdsE7pY9EdYZNYSEewertFx-WzKusQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] rust_binder: check ownership before using vma
To: Alice Ryhl <aliceryhl@google.com>, Tamir Duberstein <tamird@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Carlos Llamas <cmllamas@google.com>, Jann Horn <jannh@google.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-kernel@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 828541C0008
X-Stat-Signature: 9wjyb3ssqa1gbfdsx9e4ra7d3f97o1bo
X-HE-Tag: 1771359900-284911
X-HE-Meta: U2FsdGVkX18wstRRi3gJRDEJL7m6Hakll4YAQEtKL5BEF6OKHsTBtRCbd5uD7dEyUpleDXCKn944G9Gtc4LMK4shbvFhx8+wMzEjWYG8H9cMv8ZRQjeTzV5CasHxq1j5Ei6P+Nu7spDzfVbHmJOWaikWs+PziGsvbyxLQfz9Ukiq78vYvV0t+E3/Vnf5tQUwv5B9njK5j+OdDbj4ZKK5WJ4pBK1KfsnIJs6VD00tGlEncbDnDPK6T2bizbbf8ECPPRs7MF5FsCybI0pXBEmy6RLWC3m7xIOIlb6gkOfPbCnOjR+EW49ZVxCGMja+claaUn5oi2ylGO7o9D2znBWXvyB8nlGGxAMDBL5YRQajs1DYtqwvwi3KD2Djw3NKMr4x054pf7evyYnB6IwxHTWEolPVgZZt8ldGfm2AEUe/sqyEejz8+rgewSS5CmxlwajDuv+/82pYaqym+HtuHkoAUMFJUnkk0XBmOxJCQjfOSzVci8AefYVb8fnhc9FxWPqWoudakSiYxlferb7EU39lHPPow19zqGNf5mfQ1cBwWGsyqJnG/6tHsAzh9GerwATPoscCFBq/OrvXJiUU+kh1QX2xh5noW8Nrc7MtSI2+TqRo3xiwR1Mdo0W0lWPx3ljr1nUTK2SkFtNsIt3MHCHpnKdoGJ8rrXA+noB4q8cPwLtLNSpuSP+RlHKX4ohJlDDtjOMu7huUmZXBgddc3LJbbr4SwiUgzf7n4arQ7aEkIHKTA4KUYxLjYF6ismgVxOctUYKmEZ8BBZqaiEvqwOVXqpJRWEAJPNp4YZ8zQ7+52bLeWgsAKJALWbERZKm6M0hOFviP8/SNNuPmY5VZAhRSBk1PV5/3ZbMS2CqJqqBDkiFIXCDxG+7Vj4F7avldmWaw1bjJNvEpt9kKDyNMX0xRa5rSoGqBJu5SmnzECjrgp2/iNl831HMaxjLmRk0JzBs3OQmxYhtaInZ/+pHcDRT
 SIcnRqOx
 lqKXX7YRc2rvTIbA/sLGd78Zl1slpWxxCoalK4PIezeVaqG9e3WpMBluJ14Ylr1ayJn8frhXB2tVT08nJpsOdBzHKC3geRlFsn2yqc7txeGIpdnFzdmO89Tcu7dcqAqDk+FUmQjSkW3tp7294NAxvI2Vf0RS9+jUAXXiou8SJdMG2QByHIUOJOU0SH0zegwQyUoSK/8Kmq0Td0clKo2zP8yiI1fHUbU9/te1FWyBUrMfkB8MhFDfSJbsBXvuS8fXZidMKv3Vrs16hTO/KoZl6PYQaSOgmg65obfo8DLdgrR0naO68KPbApHpxu7IDuZ2hHKI/Bgg+rghbsXgaJ6oME309TWfxevSxqEK266MpkCIyFlP4XqYLE7jMGkUYqvPSEN5AhnFIHHwuuUmib0/cBxXGjxiXyy1mtN2qNyBwMV+rfd/w1ZbgPXLbFxso28n59tcTGtxqzCsgwVj1Ff6VvUgUOWDumVU7/cPX09I0hO6HaoO02hVytmuPaw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 9:13=E2=80=AFPM Alice Ryhl <aliceryhl@google.com> w=
rote:
>
> How do you propose to reword "I will follow up this patch with"?

What I would have written is perhaps something like:

  "The plan is to introduce more vma abstractions to ..., but for now
let's start with ..."

> Honestly I think this one is easier to read as-is.

Cc'ing Tamir for that -- he may be interested.

Cheers,
Miguel

