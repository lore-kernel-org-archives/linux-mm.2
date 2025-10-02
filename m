Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99F78CAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 22:12:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00EC38E0021; Thu,  2 Oct 2025 18:12:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F00D08E0005; Thu,  2 Oct 2025 18:12:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC8DF8E0021; Thu,  2 Oct 2025 18:12:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C66628E0005
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 18:12:00 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 615C211A992
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 22:12:00 +0000 (UTC)
X-FDA: 83954572800.11.7948B6A
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7880618000D
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 22:11:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=evqJHAzh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759443118; a=rsa-sha256;
	cv=none;
	b=djlGYzn52lNh5fbEzldu+mvroDXtmUCEbhpbgDw9ZTQoA+3u8xf0HuChMBnnKkFkSa9B43
	BiRWqYPlBq95OLeUyTNLe0/qqL09wJyPNPrP8epmOp7Ka+EH+F0pkT6lBHLRCo6iEsym51
	bosKkBp/Iv6sLHVF2YiokXVqiMCqYWE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=evqJHAzh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759443118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bu6T7CVwhfawMHtvRlEfFhPE/85D7sRoHUpa1kduIKg=;
	b=ULKYZGquehzb4jZgQqEppTFpRqwisZkFx2fFZ9i2Q5D2GXI7GhtQ3L7Ftltjk21E4D8k/U
	IG1orCpuGVtUsEgetbDx42MaQowFkVYUzz1xW5QCpdRkaydoz9b0fk9dUm7RE+DJYx791X
	IXbP/M37z0RN2nh8Ejk5GZl69Pz4ymU=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-269ba651d06so2654075ad.0
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 15:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759443117; x=1760047917; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bu6T7CVwhfawMHtvRlEfFhPE/85D7sRoHUpa1kduIKg=;
        b=evqJHAzhMLkz0FXXVwITuoO1N0gibTKf/xbiNJTHwGNrwCWKA27+CJVc4uY3hF/PTC
         jZQkUxG30IHX5jcTZiOq0avrOk0hGFebswkrptCNr01toyGydBI/RY9+n5FtCATEqV46
         JiguGwa4bPsE4vHohaSuY9kxHlikw5bfQ+n9YLfOnekB9wDAFT8aGC7JJNlmJL5XWPcd
         s4L42HMGmT7bwjdK3MiSvMVMf+fXWscRy/346iAUvgaHZR9q6Vr075cs/dWFMIJaqpqO
         UjxhFn0514bL9thCyOabvCMGonQvOKx0xaeumT0DTrrqH9nhGHDE6FZSDtxPm9dsYIJi
         yOhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759443117; x=1760047917;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bu6T7CVwhfawMHtvRlEfFhPE/85D7sRoHUpa1kduIKg=;
        b=o7T6UNvUHQ/HVcufIn9uON83SJ/9I+F3jRS0Fn5Dc6r7Tf9pndyXF4qovHZ9RYDctm
         rGKWMYhwvg/wW/tqCkov4VXcztdT1zo2AMzhiSgp7nUqWFQcsotduMBBuyN3v7+O1g8p
         LT3w+muIbWyMICRTlie7MfhtBDuRzvL/dRHGUca6iBC/8/tZFQLSu8F0Jm8E8LN4aah/
         SB3AXCN+FKtUBueK6QYirB/AEUhCIk1QGD0+OHr5msu4qQNJGvboI0DseZzF4qx3xNzu
         14Us1XdS3h9Vtfbv32JDq64mV6fZgMZS/LAO+u/jKU1ntqHSNW3HG5ZxTXArsa+S1t6S
         GQFA==
X-Forwarded-Encrypted: i=1; AJvYcCUTy12kqYx75TU9aYJnPsH1ScieXdcUwwxqVCcwLkdwDA9CtxFWfv7iASjFtlitttku/r+EjkXZ1g==@kvack.org
X-Gm-Message-State: AOJu0Yw+p5BCd99fBArq9R3A4chpwgO8wvOb1UJvsCYkGDudXL7gujUt
	vwpVfV121QmPjsWzXWu5XtsgUuhzvCbuuAtTo4FmC41BhMZLj9Zb9yxuEesdgqsyC49wLJfRpTk
	gCArvPHeOfemXI+HsmIXIChgVqIyyRs0=
X-Gm-Gg: ASbGncu/Bz3Pve3XXhDtjxlR9LbmxESoB4t+lD+Sn+9/NDsU1UX1Ul7Wnp7jRscCrXn
	4t/VO7YBkoyAxjXAcDwOjjb//eVslg1OPL6m6d7yWx9LsLZ8t7uMhgzHhbGqM7eCIvr9lb5T+VE
	wKOunYe9yR29ZDLPbXFNRqNMCLgUfu1XNxvqCBir62De7tFeatWU31xmT51vqDrbbpOu+DM5kTe
	S/xAak0Ef9eQ+XxK2Aq36rsw565HFNiwpKUhuw+Mrbp+njA+ypFz6913ZlWx4L8Fj1UnyFoBnjZ
	+KsvZ0/gyPnX5TyRznNpwBcZAe5uxSNLUl/01Zewgu96ijo/mw==
X-Google-Smtp-Source: AGHT+IGwKnqSVieJ3MfyTgFFO/O9vpr8rro3ogT4lM4nX7G7iGhsfj8Tx0MNi0UQc58JqTsdSFoH8GBJjyKfBVPnZAY=
X-Received: by 2002:a17:902:b196:b0:266:914a:2e7a with SMTP id
 d9443c01a7336-28e9a665b6emr3287285ad.6.1759443117189; Thu, 02 Oct 2025
 15:11:57 -0700 (PDT)
MIME-Version: 1.0
References: <202510030449.VfSaAjvd-lkp@intel.com> <20251002141925.ab86656b1d50f6e27f216209@linux-foundation.org>
 <CANiq72kOhRdGtQe2UVYmDLdbw6VNkiMtdFzkQizsfQV0gLY1Hg@mail.gmail.com> <5467d9cc-54c3-415c-9ddd-a1ff1026f29e@nvidia.com>
In-Reply-To: <5467d9cc-54c3-415c-9ddd-a1ff1026f29e@nvidia.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 3 Oct 2025 00:11:44 +0200
X-Gm-Features: AS18NWDnPckM1PfneojmzdbCoOjMOJM9kMDMDSDk4r7YVa59EgpddvEXF-NHdJI
Message-ID: <CANiq72nE2gAuK_ym2=As3yXRDoNFbKuSa4oac7abhpjy45ZQGA@mail.gmail.com>
Subject: Re: [linux-next:master 13069/13300] error[E0425]: cannot find value
 `VM_MERGEABLE` in crate `bindings`
To: John Hubbard <jhubbard@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, kernel test robot <lkp@intel.com>, 
	Jakub Acs <acsjakub@amazon.de>, llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, 
	Linux Memory Management List <linux-mm@kvack.org>, rust-for-linux@vger.kernel.org, 
	John Baublitz <john.m.baublitz@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7880618000D
X-Stat-Signature: 6omck5xwho1rbwt6fs4gr311uxd8q7ea
X-Rspam-User: 
X-HE-Tag: 1759443118-984946
X-HE-Meta: U2FsdGVkX19IQ5UNVGQsvq05FtcPymocbv76L/1tbiae+rzNZyh7z/HSrqqmG8c+YkmPj99VUE1vRXXDgIAoxpDe0badyt0pSgg9QAnk6a/7oCJB/+z1nK1SMKF5NPPDEwaol7DkZHX47Krnt2OcabZqACKoU/lrDTEvawe5PcsVVhfEymd8C0DSrfwDwoObp+DBj6Mtjvt5ec61VpoGhv6TWt44ATTFHCxRVZiCkAlIeRt8tBnHUJY3zSIJ0O/UnD55j6yrfLrwYhVLiTVXewjcmsyK/8Kkf6D0X2hrSaKNrVX4XfD8DPRg9CCVvrGhuxpDV+CVktPW0rllw9rN0903Bmo8m6lk1spROxhj+1nOyiqFd+twTtUIxShdBw9VxpqsrOijqSswlYRi0MZxfihvc+9Q8BCeORexiXNocelajQ1afkrCmNPdaWxkdvz7KdOUCAoTBPUzUU0xO/wqwj0jVvTd17KmI4L/k9WjVnfvzUGgQKE176xJg6T/ngkeAKbHp9xN7XOFmrBWE3ibR5ocEAOIZuokgMl1B9c4rJ5oSVUhMcdo8j8shcaxQlS6dJY/rl0wlTNqet2eglbPmmj5ATMfBCzYwysiQjKOZ5OJ1kyeuikDryxdZoZFN2Gd2OID5SJnJeVb6haHizfvJBrhLhjiPd+6UJGaH2rXb1TLX2Qg8bJJWWorjKC1Vo4G5bkM8e7o4zEFLDLX9eH+mutkhANrtfdezB0qjULrHCXa9Yv9I0lopBBtwXPO7RTYQS8NLd+JvS4ZQQA96gKeuQDUMCrj5N5NDfW1eCc6yKbYdb/j7PuBh5iT0mHU3iHBqQM6b97uFaqjDhd2kG0WhNEK951uzmwFG1VFKfhiFoRfcJPL9HyYwGpXHRQtaqV2i6XYQPhFU0bHEbO4UkdQ+LM03YGctm1cXZKkcxmo5lL55wsDwRJ5jhgnFJmbp3B2IQC0bOuTlBcr5E504Hx
 D3rvPe9k
 lw2OO6zoV0VbqIz01wf4A+5Y1FIv5A8deWtYDrUritlKwV02gp7p40C+6JyiYxiQpoAcuZln2escO469GW7vyz4gNYSsCFGy5p+gh3KGHFGNB5U/7w51Yw9pSzr0sqFXnZDKhr+yi+FkTbucJJiLntp6EWHbdrVoMilKtGGkIuwpaKvGp4MYeoJCc/uAwFB3vOnTa3bN2wjiRJKUpsDrL1/VJdg5g0BoysUDX3EjjtIVUitDJQrisWz/hy4NW2SdHto6wqrDAS+rGeuhiRxwLMNaWn+k7BNcdMUnt1gz9CZXOtFGD1VxwmWKd2Nj8gKHAQnsZT00LUAiJKDhXkEinQeLN+EqExiozMkqERx/L1oxYuodEZFyAeEQU+QBQOAgKiLQ1PXUzRYuyBBSm1hcvPdqoKbucTeCPf0S4NsNIX6GKNjrA1wSkYEStZUuxkf6EFyuMiKQT7oKDPjhvVhRfopuADLKQwSnCuLoEryRgjSNDFfb6GkGjjdwoLNPjI/Bph7t/efD0fh76xB1rymcHOFSvLTQsvGu4e6wy8+Ex/WrVl60vvqKEsMqRjw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 2, 2025 at 11:52=E2=80=AFPM John Hubbard <jhubbard@nvidia.com> =
wrote:
>
> It seems like bindgen's --clang-macro-fallback argument can avoid the
> entire class of problems, is there some reason Rust for Linux has avoided
> that option?
>
> Although, in order to make it work with fixdep, additional somewhat compl=
ex
> build system changes are required. I've got it to almost work locally jus=
t
> now... :)

I am glad you ask! ;)

We were the ones pushing for the option -- John implemented a
workaround that I suggested, with optimizations on performance:

     https://github.com/rust-lang/rust-bindgen/issues/753#issuecomment-1674=
833380
    https://github.com/rust-lang/rust-bindgen/pull/2779

I think the last time I tried it was early this year -- here is the
test patch I had:

    https://lore.kernel.org/rust-for-linux/CANiq72m20pom+B9EmWO+91E8fjbMEob=
3JmvHRQ6UaXe_JmatfA@mail.gmail.com/

It is in my backlog to go back to the option, test it again and so on.
In any case, note that we will need to increase the minimum, so it may
take some time.

Further context at:

    https://github.com/Rust-for-Linux/linux/issues/353

I hope that clarifies.

Cheers,
Miguel

