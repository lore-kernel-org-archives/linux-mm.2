Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28DE8CA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 21:57:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 559A98E000B; Thu,  4 Sep 2025 17:57:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 530328E0001; Thu,  4 Sep 2025 17:57:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46CE18E000B; Thu,  4 Sep 2025 17:57:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 36A038E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 17:57:19 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CE6C811982D
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 21:57:18 +0000 (UTC)
X-FDA: 83852929356.23.A50C710
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf14.hostedemail.com (Postfix) with ESMTP id ECC7B100009
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 21:57:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WCX+Wpcn;
	spf=pass (imf14.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757023037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rcZeZoGWZd6oDyE1JgIMLenB9ELxcn6jjg+gL7yAmkY=;
	b=B4NdPmlZuZF0FJ5UbWOg0kp4z+EPTUMPylpikO4FvQNUjwhalRU2kB1W/grOowvMDMVIA9
	/3n63Hc+Uul2+drAdZz/t3vfjb/smRvDY57uXiAhHgbgY/7k8vL2DYWXTro1F5DgmGqdPP
	bnTOIGbKS5PmTFMPazv1FElbyxEmI8s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757023037; a=rsa-sha256;
	cv=none;
	b=i19xC0Ar3hr3BjX6K0cuSg0q3u8czbgINPKrHisHZqbWRxO9WAYWKnT5ag6i3b0laYy/kn
	cPVmXgxmn6ee3Ou2o69/wIG3iJOunyK7SG9KWDEYnaG/iKBrZphja2ad5zlpYOpGBv+bjd
	vQdUfCcpR2ZW6kSF/wa+nyo1G9jWX4I=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WCX+Wpcn;
	spf=pass (imf14.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-b520539e95bso89299a12.3
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 14:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757023036; x=1757627836; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rcZeZoGWZd6oDyE1JgIMLenB9ELxcn6jjg+gL7yAmkY=;
        b=WCX+Wpcn5hSmyTbNThzHR063eFdCjErogPcEZzuG/icdmFKsmEV5Wz5JUF9Sb7Rx/N
         Sa5oZqJVdGdnXAfMegtfZsIBxFp+P4PYvP+/L1SQtsp4IZB6Q9PvOyybx2x/S2UFOkCE
         7mX0hWNvCU4mZEncI4t3Wzc/xhiBSV+mEBvHGvLSTKB3Q7cG2c194hWWODXP7+/Qmdzi
         4O+Bq/lFwNRiKrpA582RdqaSlexZAXaxphebLm/faHcCtTS7ApU6l7c2YINwTo22EY6W
         x3/VvRzz7NW+UflfmKw/eROxV7bARaEw98vFN8w85tPbp8FTDxB3cYdvxk2i/RkE3Ofl
         cuOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757023036; x=1757627836;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rcZeZoGWZd6oDyE1JgIMLenB9ELxcn6jjg+gL7yAmkY=;
        b=NTzLU1CMUZ5IUpQhN1iKhoREyR53n9DHDcW4oVo2zi2a0a92S6pTb80nOSLKEMz2hZ
         Ksc+MZzE2tXEc5S2WBb0NnlMN8gOAW/+Av+yQBCeNtiphuFt66/Ui8w+ifixtocjiA0H
         BaAXiCUd7Z9oHXo5ASGCEviaZdCZMoCpvM29DNhv6Id0r4AgV+6eISL65q0++O69bbYP
         frNK/mmpiKiwfzOubO3zUkgOqWwtvnMdPhVf2nzvYl/nboHI2fH+WJaixqmmlQD33luU
         3GebkzUBKBRxNvRq9HcoKciJlskxwAjWaLqGtA7H0+6jQrtmtk/vtRKtvOy0Pn0s3Wrn
         7FMw==
X-Forwarded-Encrypted: i=1; AJvYcCW565+ZHQTy34K7hZ4WVue/g4G0w7JC8AnGN32CUCvuS+0u7rSfDLpgwykSP3ogRJXJ4pBxLiKcxg==@kvack.org
X-Gm-Message-State: AOJu0YzO9OKoLcJRhNF1r72fTZxX+Woejqlq2/8OTkb8sxjIbNwE/CTq
	grjO2jm2R2a05g+WJIifuh/VU6xzbCA7PxVgQBRuWd1CF08aohz2wgmZnKz6pFfgXl5jy3lllPh
	9y9ovpWGqNLB4/JeWYhalds2CbdxXGAo=
X-Gm-Gg: ASbGnct2VnfSvi88FtJ0tOpmR8XXoJ17pJGsPFwmnq9yYLMy1bS+g7o7W1IS53Hw5eV
	k04O/aUiu5Bb2E1dp7clH2xgKl5iaIR927yUywt3wMBeHMI4mHCiWaxTuJkLBK2Z1jxE1q5hISw
	+7GUSn4gi3FgWytf3DYE652icmawHIOSi6ifPZoxPQi/DEesaAOCpXFJy/wADBUbeU8M5nOjgbY
	qpS5k7hSioeMQRg564bhatgaUOUIPsYihKfZXwewaHaOc9jHX7iiPzFreFkjiP89DqmT6Ax2sfT
	djd19wyK/g0lOc4vXXf/VmD7QewBr/F0nUas
X-Google-Smtp-Source: AGHT+IHZzzEVWO5PSFfDM0hepN4yQvN1y0+nmWEUBQlDiGcXUbGHi5nbA08+gO7LBQf4rthVM0fgKbPH71PBos20E9w=
X-Received: by 2002:a17:90b:1c86:b0:32b:8f2a:ae35 with SMTP id
 98e67ed59e1d1-32b8f2aaf59mr3254587a91.1.1757023035654; Thu, 04 Sep 2025
 14:57:15 -0700 (PDT)
MIME-Version: 1.0
References: <20250828-rust-percpu-v3-0-4dd92e1e7904@gmail.com>
 <20250828-rust-percpu-v3-5-4dd92e1e7904@gmail.com> <aLi-7W21N45fBGJk@yury>
 <68b9f5e2.170a0220.1224d9.5d3d@mx.google.com> <aLn4bopPt8uS4d1O@yury> <68b9ff1c.050a0220.35de1d.11b7@mx.google.com>
In-Reply-To: <68b9ff1c.050a0220.35de1d.11b7@mx.google.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 4 Sep 2025 23:57:02 +0200
X-Gm-Features: Ac12FXzzgEdE64V3Xyhcttg0HrRdfADWmugK1SarEVytCTaLM5JzuX5Un97wiHw
Message-ID: <CANiq72k1oRcxKbBpp4B-uCmqm+Hd7_xPqwM1kt-BYikbcsUSVw@mail.gmail.com>
Subject: Re: [PATCH v3 5/7] rust: percpu: Support non-zeroable types for DynamicPerCpu
To: Mitchell Levy <levymitchell0@gmail.com>
Cc: Yury Norov <yury.norov@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Andrew Morton <akpm@linux-foundation.org>, 
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, 
	Danilo Krummrich <dakr@kernel.org>, Benno Lossin <lossin@kernel.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, Tyler Hicks <code@tyhicks.com>, linux-kernel@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: ECC7B100009
X-Stat-Signature: chrbjoa5p6ogeso5btwhswh7d45gd798
X-Rspam-User: 
X-HE-Tag: 1757023036-831157
X-HE-Meta: U2FsdGVkX19MUhKJKqkW+uUOM5H+0g4qed9y7aDg6madcJnxATrM/mxjS2ajeOpZs0roIBg6yPWcqa4xLq+2iQQR8g4dVLF6dPx3ZdPCIhyuuoxQJwp+VaZ5YscRN7Wc6h5celNljJuC8Wn38Dmzry+2KdCfBGYBFJptQZ/1dWcoZXDuN1Kj8kFDR+8sr24GH5xnI5JT0Z92/wkWsDgSY6QUA9ygdXO5PL8s8NCplitP95ZnY5uCcG8Bh+mkVJGwkkzd59qnvFMzbFxO2Nxe0gt+ss8VwrNB4wQpQdf477jsvT5LOVOep4hJxqPGXgtG1oZlB+gQfJi07g2WjJ+UeB94CynUjuvGVIFmTyCmmiRIdFgmYZjhEnwwY/0c6k3aSHTizJb06jObxY3oEoJtgBZr376ONHOK8mULiKgEwh638KD/RY4be3Wd8eyud5rXnxVaBVjHdfHwrLBh7ZLovwL+mSOlaNGR40EZoU0cTvm6uCyqtJmgjlpBcZGl0gwD+bBxY0te8o9eTd1NuiI8gmkoB52wrC0qQo+R2oYTsrF59Yjo4UlMjupS3izhsT2sdRR5vwSD9WSQ3iBFNwM/GWjTgilTPtj3Q0NwE74lRvXE7cY1tDufM1pBYWkeLMkgOzTK/C8mTTNWLkO8hQrqpr85939SXSP8VvlXEtR11JmFsgaxM/7MhiFjWpz3sj9ux57mcpT8pU/cEoKFsaVSDu8y6dqwJMPPm2YwA9dit24KCFbkuD0F4uo0ghccXhsLnZ5F8bMGxjxm5DzT3XDjaP3aCp582q7B5wzP2Z8bwT7FO5BY6WBcUWVuAh4pg7ffqxD4/YyYB0VB926SeLxhEWJPv5O2pB0IdW1rxfVWSqbbUiMwwTcxSIFdfBQ4G1IBHv69duq5eN2mJ8odw412GF/RBjD1ny6nk6Y2AZi9cjUsEyQyL0BJo/7YWDULHY8y/7LdZOwDzrYuOiRLzzP
 SMNBPJzv
 eHkGdi8NavkfAGjKouxX3HQvDotl0RXkPwCstYh1VppRvIAYFjevAkMs9REMrYCYgoV+bAowNOMd9gzVxA7JnkLrDmcv3ceUfHww+dRrhsQRv5qRLnD7aFvpL283MFsIIkGTwq8W1jgWel+OP3TgQZ0hxBRS9hcYNkQ8wHsn8bdbNloinBmKVTcAQn+9G7WwhZuJmEvKOPHrusA31LKnttV80+CR4Jz8xJ+i03rCM2KrhLXWYp2kiAwEtGP+csLtjxVmBcC5I+GQRdKl4g01p5rw6N5XSzIVm69qsU1W8xctfDBMtZbhXUzAjHbkyzLmzLNTAnZyf+0uaSKeFBkF813lG4b0/m25URFQGZomFoUGY7eDWvSN0z5IEBsVwpyUWe58o5GbLoSKlAwrTODMnqVCepkK/FCk45lduQkqhQ1Us46Kb8+cWZwfeSakyLZdCiCBDx7TXGETPXNzdJuRI6j7T1zVICQEvm0E/w1eolYLXH9czhT2OpCMWhZlcFRe5Wy7L
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 4, 2025 at 11:05=E2=80=AFPM Mitchell Levy <levymitchell0@gmail.=
com> wrote:
>
> it *might* also be possible to use a macro and dispense with the need for
> a closure, though I'm not familiar enough with proc macros to say for
> sure. That would probably look like
>
>         for_each_possible_cpu!(cpu) {
>                 let remote_ptr =3D unsafe { ptr.get_remote_ptr(cpu) };
>                 // ...
>         }
>
> though personally I think the first one is better (simpler
> implementation without too much syntactic overhead, especially since
> closures are already used some within R4L).

Yeah, please avoid macros as much as possible. Sometimes macros do
have advantages, but if it is just to avoid a closure, then no, please
avoid it.

Similarly, unless there is a concrete advantage needed with the
function, please avoid it too -- the original `for` with the iterator
is the normal way of doing it and already used plenty in the kernel.

Thanks!

Cheers,
Miguel

