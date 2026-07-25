Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 106BEC531C9
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 14:06:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE8466B007B; Sat, 25 Jul 2026 10:06:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D72B86B0088; Sat, 25 Jul 2026 10:06:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3D306B008A; Sat, 25 Jul 2026 10:06:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9819C6B007B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 10:06:42 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 078CBC0322
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 14:06:42 +0000 (UTC)
X-FDA: 85027474644.11.7FD9E25
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1FC6D1C000E
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 14:06:39 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=opPXCvuE;
	spf=pass (imf18.hostedemail.com: domain of linusw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=linusw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784988400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ssP/vx2xvZFVkpWUGpEHUbU2ssgcSty0tchErGpJGIY=;
	b=OXKZ4hz9niJ3ifeoKjSVpU0eLzdmS8ZM8AHUb8RvTVr//RXy/ScFX9dFQOsg+cS0kcD9wO
	OKdzOrEnOLDJx4aK91KdCYH5SWdH0R0v9679TBtmPbCHp8PEPPwm+wLqliaXh2uUdu3bgA
	j3nO3PZvAVcTrNTxPBFZLU8qe76jnjs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=opPXCvuE;
	spf=pass (imf18.hostedemail.com: domain of linusw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=linusw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784988400;
	b=SIg26lXqMUdFKRr8o+oE8/71MZnv5bw9EIitV79TyRhqfL6iiJ8TCCdZnXoc73h5Nc6QWM
	Gs4BmI28BXiaLWF1n69W4Dcd4JZYcxgCyN81d8jN0XsfX/dK3ZZtvlgNTDdfHaU5YJ2nPU
	glQcJRo5oLg6X9dx4X6yxmiWOpu5Bmc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3BCD860A6A
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 14:06:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A916F1F0155A
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 14:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784988398;
	bh=ssP/vx2xvZFVkpWUGpEHUbU2ssgcSty0tchErGpJGIY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=opPXCvuEe8n3PPU7M5ujJZqB3rWQBT0RU4WQlsETK0tRQHs33oDIN6jn6wQT7O3T7
	 Z5H9hYbLDjmqf/m7XQ+/0SyxTk6y58P9hkJf1EGhKCJL9Qym2K83B+CXayO1MRo9Il
	 yfnvle/hPdRoHm3+J3abaORHTu7X6SFEElZMyCLvddn24xsZMadinGc8QlSF+XoK/0
	 uYirOsJuF68uhWVAJtb9vCYGkn+nXnFWFcQwTryaOAAcZRHOKPSZF8uRI8IjaeRi9U
	 +jSSheJTq1J7WPkby85QC3EEzGx8Gh06C1Iua+RRCdwA+nig7Mkyl2vWi5oaY9FWk0
	 4hNREfU5/WzfA==
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-39c923b8c2aso13841891fa.2
        for <linux-mm@kvack.org>; Sat, 25 Jul 2026 07:06:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpxO6HBo/kgZBJDwrfJcVBz7pdKPFNPq3Dz5RONmg/fUaQ51ddSrwPddbiXWH2Y4rQVv2mCWGEVDg==@kvack.org
X-Gm-Message-State: AOJu0YwWrrWNj7b2EC83X8v6Vxf93BnSYE7welmQ4dk93fukFK1KBAmZ
	BrX7Rl7J76qYIAkOKSxfktYjQ2hJVOc9YrZHpcmq7xf/UoZ0VgfMgOM9lclUtIPbzAdHDasmYa1
	u1PFK/PdfNDM24Ok3pWEE/mYs34PDERQ=
X-Received: by 2002:a05:6512:3d07:b0:5b0:1108:c575 with SMTP id
 2adb3069b0e04-5b2c1afb4c9mr313282e87.7.1784988397379; Sat, 25 Jul 2026
 07:06:37 -0700 (PDT)
MIME-Version: 1.0
References: <CAD++jLn_DDvWAudHC2Qtz9kaaonuC0YGTXn9nvPtZfGLbtUsOA@mail.gmail.com>
 <20260725020926.11440-1-xieyuanbin1@huawei.com>
In-Reply-To: <20260725020926.11440-1-xieyuanbin1@huawei.com>
From: Linus Walleij <linusw@kernel.org>
Date: Sat, 25 Jul 2026 16:06:24 +0200
X-Gmail-Original-Message-ID: <CAD++jLnHow_nx+kJ6Q8JjX0qPgR8jwwLi_a8xHzgc9gQHbcNzg@mail.gmail.com>
X-Gm-Features: AUfX_mzSvjKHLHaKmkayyxfaSojjziIW6z21biYafMhxP1NfGfMVkYwI0HZIC1c
Message-ID: <CAD++jLnHow_nx+kJ6Q8JjX0qPgR8jwwLi_a8xHzgc9gQHbcNzg@mail.gmail.com>
Subject: Re: [PATCH v4] ARM: mm: acquire mmap write lock around show_pte() for
 user faults
To: Xie Yuanbin <xieyuanbin1@huawei.com>
Cc: linux@armlinux.org.uk, akpm@linux-foundation.org, david@kernel.org, 
	liam@infradead.org, liaohua4@huawei.com, lilinjie8@huawei.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, ljs@kernel.org, mhocko@suse.com, rppt@kernel.org, 
	sunnanyong@huawei.com, surenb@google.com, vbabka@kernel.org, will@kernel.org, 
	xiqi2@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1FC6D1C000E
X-Stat-Signature: c9d8e9k383iu1bgfwqdpu89gayym5qzy
X-HE-Tag: 1784988399-897569
X-HE-Meta: U2FsdGVkX18j+whOwYt8jBrODveFmGglD+8LHL8P2FPIR1w0rq88eGFynRUhz5lFU5fTc+0vhWQQlhyYXbkXLraiLpQWQ9xxhaOUl5zc0qvrPKHsm6gdu3DseKxko1a/Sv5+LhydBpU8339xWjpyyY0hNWydA/Cwr5Kek34GOrb03pTVJyrNRd99TtiTI+/EqAOmzLV1e3QKOwEzh2joH6LGBcjhs76Jf97cHLetNpdC+8fZtTqxeWo5qIjppMTX8fnVkJmCSmL2Rj0dZgPh8Yq33q4pSeLitmeOAYdJyFIIWmeX3lc9TAu4c4vp8ODW6k5HSyIszDG8xRBY9Z+7RHnYvEc4m429jvHMKXRyB16aYTWtoDYAZYxyuXi+rzDQuMRj4CVYQ0fs/pgk1Eq5ISG4VvAUZK60DcESbHCyYaSm3HHk+7gzkeNlJCM+VKBP61MI+OTJVJBSB8Up0IpVnvHQ72ErwWEZ+HclL3YiVWuQa74SAp9Hw5LyUWkZbxzcMHqB0bXOIDf2Ce2tatiSqvvocmFRPTYm2Z8dQyFMunz4DnzKX9BooZQM2bM/UXU9/t3XqFa2RC5r2PJma2J07IwgE5+FDpNo1Aofyc9Qibc586jgX1CUbVXUWH+LEsx3Xo1afRHlgfUYM64ylte+/3LidBuKb6keG15Oc9s6dXc3T4yQ6sa9q5SVLgBPuV32KV1On318FmUeCvdK4XUbC0DR8sg5yIKYcywiG3xYTzgLy0ezGnr4OoxDd48tkf4bZw25ZncCHuNvl6tI4N4DALMfr7Y2XvFGwd21gDXIBB/enFSt+6gcb8UBJ3jIl6Ol5yVIkjpqvbFC323bZvPgnT7CFZq0u4hWvfVueJUsvx2/0Zit2ZwXg0C+FIve8AzQ1smVEsPCn9duQ/PIB4bH4fh713Dc5qbtot0Jd5cPxH4AmgoCp17rhEuCsJU/NtucvbkiCrVqHpRVaKWisK9
 Eab9/LWA
 jzMtiZBOZlSL3qYIlMoyRHEnqVdSQjRkgWAhsR1PgL8wPQJVPMHsouYSMonQNDzabe+Tijw5FK52HkUkrMUDmgiyf/kr9M4Pvv/gIN0gyDN0xs1Ci3vuMXZ5kzcTvxTQ4GkjY9oxgXKYipp7Uu/tZV3mEKDK0w+TRf8gnFyDPU1jMcpf3jiqXjy/QblYxp9FPFIEeArkPxeGYDMuy4LbaWDksXsNZPRdd+HwhWdMB3dkdHeZ8ZG9u7PMiTTYXVNqdtG6rkVNRkeaw+AtvCiwmehcUOrpmyd/vXrQjVeTfDu+NsZrB4yhkjf7YUIyHmhjU/JgEkmT/QShWVySZFlsBE2AcMdjL5RIWjpUNRvI6PwzRRHc6wDCKNmpsi7afKxEe/VcauyQJSryiGppQjgAxEfgLBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 25, 2026 at 4:10=E2=80=AFAM Xie Yuanbin <xieyuanbin1@huawei.com=
> wrote:
> On Sat, 25 Jul 2026 00:05:58 +0200, Linus Walleij wrote:
> > On Thu, 16 Jul 2026 09:40:22 +0800, Xie Yuanbin <xieyuanbin1@huawei.com=
> wrote:

> >> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> >> Fixes: 6d021b724481 ("ARM: dump pgd, pmd and pte states on unhandled d=
ata abort faults")
> >> Depends-on: <20260629123349.134224-1-xieyuanbin1@huawei.com>
> >> Depends-on: 59e4f3b45b96 ("ARM: ensure interrupts are enabled in __do_=
user_fault()")
> >
> > This looks a bit odd. I don't get the first fix tag, drop it.
>
> The first fix tag can be open as:
> Link: https://github.com/torvalds/linux/commit/1da177e4c3f41524e886b7f1b8=
a0c1fc7321cac2
> Link: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/co=
mmit/?id=3D1da177e4c3f41524e886b7f1b8a0c1fc7321cac2
> It seems that a 12-character hash is no longer sufficient to index it. :)
>
> May I increase the number of hash characters or just drop it?

You still don't explain why you add this odd Fixes tag, which is
why I ask.

If your point is that this bug goes back before the start of git, then
just write that in the commit message, no-one will backport it
to 2.6.x.

> These tags are for the maintainers of the stable/LTS branches. Since
> the bug is very old (we discovered it in linux-5.10), they are likely to
> be backported to the LTS versions. However, the depends-on commits may
> not be merged to the LTS versions.

They will figure it out anyway, both Greg and Sasha are very clever
people with very clever scripts.

Yours,
Linus Walleij

