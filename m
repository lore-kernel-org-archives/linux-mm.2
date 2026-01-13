Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11C00D2F33E
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 16:33:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70FA56B0005; Tue, 13 Jan 2026 11:33:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BD806B0089; Tue, 13 Jan 2026 11:33:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59FA86B008A; Tue, 13 Jan 2026 11:33:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 45D9D6B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 11:33:58 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DC7A6B6FC8
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 16:33:57 +0000 (UTC)
X-FDA: 84327487314.01.5A5C457
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf14.hostedemail.com (Postfix) with ESMTP id DA997100016
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 16:33:55 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=uV9CwIGM;
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768322035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qI+cXlhZ3eVz3npFQ/NimD2ZFpeK3OA3wDm9Z2GaXgk=;
	b=KvYbm18XUAtUsvFn1IQmVabEDmvO5GiXpbYptYO+YPST7ac2grLI94kIW7ze3YbFL+g9O7
	fEf8NVGOI3t9WIq3G2pZAtGlnAlZRFz98LlVwm4ZC+cdOSJxan6xYmVYho8n0paUZE5CzH
	DjH2khcYJwM55noDyVK3YDK9fLKzP5g=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=uV9CwIGM;
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768322035; a=rsa-sha256;
	cv=pass;
	b=RJFO4AEr/8bfwo3aUgxMsG3r/Z6x1fBrTgYwENQ3P8u33AetVongfI497ze3ZpwrKHzFTN
	44NOjeA2EiX8cE7uL15E4C+/cpgb+bUJuebqoOoJHCZ0Xp4zorD8JqR3wA8kROS64/MJ4K
	Q/yLSuuxzGyPpzeNQdHkTBksjSKni4g=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4ffbaaafac4so656551cf.0
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 08:33:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768322035; cv=none;
        d=google.com; s=arc-20240605;
        b=JOCBbUoDuKYVT/VKXoyjwskulQkzcloU3beLhQORWWhmszrPnOv6McQFPOwfIUTzhK
         dzmUuqGMqK0jkTrgUitAR0t23BISv4z4G9Ro9U/fayumISZhq/F3rcnBqSu3DmMKqqEO
         852gohiKx6f91GLRvIQi0hk5a94T5jN+gTJFL/dcOxk+EqSLOqvozsTf2oXF64xzi9Hs
         bU3RDzZze0JFdF8qQlFw31r8BwJWDhQRi2csIMdFN9UCqLCffsMTtFDonM+yRGOTEirh
         dU6ZYT0vLQKY0tjz2vcFazCaIpLgqoMaxwKaEh1RKQ7mhBS6zvzmXvkbt4KAUVC7oQOh
         m7Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qI+cXlhZ3eVz3npFQ/NimD2ZFpeK3OA3wDm9Z2GaXgk=;
        fh=gfIAzRYvK3ZqhJptaugZdsD2IJZyGHgKzbjqYLhXi/0=;
        b=JLNt9kGGEeAptIh0BPkVCbtde35pkuaSCqlUKBaeF62EFS09hDWeo7x6e7FemVL1Wc
         l5dnVseSw8GmZ2DJL4J9I9pkdlVovs0ER2l/BjsoKNeszqpcz8eciZFKvp5lsHkMjkXT
         suwvauFmNB4WRK38Ji0neCBWAHct2btA4aur04n6oXqIWJ7ky1tnlHo34iZ2ItWFdkF6
         7QcLtcnlYzOPvShxbOu32YBWyV+vhUGBg3d5RVgDOjihBvH1gnyJfAy0maqt8DaIcI2y
         Cgo6nrjQhCYxBbfHLLWaYcdW+jCQGPxReSxtpbAb53lelmn7Ik6nvOvtYlhwz9Z09btv
         MqKA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768322035; x=1768926835; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qI+cXlhZ3eVz3npFQ/NimD2ZFpeK3OA3wDm9Z2GaXgk=;
        b=uV9CwIGMTDLHw1FC8Uy6SLdLoGlW7KzsuAoM+Rt0xwsbHJr21k9rCfcQDSLLRbbMtE
         toSgqhk5QdkxMfsh9NRYf6ZyEuhPJVs/MM4+VSvdAfz+gAHQTLGgTM9gvqKql/NMdlm9
         YjA2+vge+VAT/EgDfPKEFVEeMSJBTZuGL2rPgiApIbkd4wVG4rc4d1Zl40PpUxzfJgxf
         MM7rYmHYQr7nYq1ZDGIpm/6DaKK5fo93bQlcjDMKAl0aGruFDTTOpseAn5VNuceZ5xMx
         IplOFXBQICS614ozf7/RGxPZ6ZPrMVITalT2ir4lSItjtbwZJIFtXL0XD0aeOcW7BVCb
         Kr5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768322035; x=1768926835;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qI+cXlhZ3eVz3npFQ/NimD2ZFpeK3OA3wDm9Z2GaXgk=;
        b=rCEd5v4jFd1u8bKCq4KdBwMOeBpz954a1b9OkqIHZfb+Eh7oUaofSOuxRyGtULlLtD
         oh59bT1w4JBd/zxSDoAsLDRBE1UQpPEksW3yrWlHbpWzzuo1uiZgM7GOQgTEt7JLyZ4j
         0HDnEiwi+ELDhzPTbRXRx/wlkVPqbunbjnkio9lysKSx7RGP4PpHnrP1gexTd9d/yoVo
         NZCYbO4dDFG/RGXoVWOYy0pgoEVx8vgWplvb8DXvm7h29+O+jOZcEB3MM+iQcAybvTPe
         vVr6S8BSPmYXTEs9iCAeQR5sbNa+FdvwurDPXf53gnuLhagiblYyIbvZtm+ZeVkVQHHE
         jf/A==
X-Forwarded-Encrypted: i=1; AJvYcCUe9r0oxxKmFAwaXmW0FZhH6vlI6rmSSGd2HKMdxxA9hh3RZq+4WHFF0ott3o3dz/vRn3k+0Z7APA==@kvack.org
X-Gm-Message-State: AOJu0YyGp6xR262+mLYfoLLCkOx+G5Y6E+dnds+nC6M9j/WFgTaPB9cc
	JlGFHHVitGBZFzUJPwIEfcmf6XdJBEwMSxh2FH2Dkqnjnq/VoB2fKuAkJsc5tY02yqe+olo6bK5
	qTUdeIMwFOU+V1nnYJRZCV1j4oz9UPPObca2VJVSl
X-Gm-Gg: AY/fxX7rccWz7cUDN2CCLax7MSlq3+j1EZTCBX44y6O8uxclk9cG5EmRcFR9uVq3lvl
	50cPfwhau0Pz5W1nBop+3xRfOvvSg0Vv4eBbbfp29KeJEzxMqcTSwcyzITAlm6yQTPNdLFCZaKb
	qiiRJa7MYLusmM3j7N9RiWZGLen3yMbPsGiUQmOT+yntnnzKekYJbmXA768bOpcF/+UQEngaqmi
	yQnOgL1aHHd43tll36jaWIJPlXlZbo7gUkE21idM8bAkj6FO2MdqTgqnVbUCSh7l9VEOjMolex3
	8SwjHBmr5HiNXu1vodHXsRAGFg==
X-Received: by 2002:a05:622a:1aaa:b0:4e8:aa24:80ec with SMTP id
 d75a77b69052e-5013a287cb3mr12545891cf.14.1768322034517; Tue, 13 Jan 2026
 08:33:54 -0800 (PST)
MIME-Version: 1.0
References: <aWMLQkvushKidjQQ@moria.home.lan> <20260113032735.161838-1-ranxiaokai627@163.com>
 <aWXAaiLXn2tXr8nU@moria.home.lan>
In-Reply-To: <aWXAaiLXn2tXr8nU@moria.home.lan>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 13 Jan 2026 08:33:43 -0800
X-Gm-Features: AZwV_QhF2LNh9b5y9XH-3TUKdD9SDJ16RHoFzZRc-qtc8Hdy1LAoshy7iJbvlXE
Message-ID: <CAJuCfpFTJUowSAjNum1zecDJYuyUi84vUNkoNNf=CnUwpsTVeg@mail.gmail.com>
Subject: Re: [PATCH] alloc_tag: remove sysctl prefix from mem_profiling boot parameter
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: ranxiaokai627@163.com, Liam.Howlett@oracle.com, akpm@linux-foundation.org, 
	corbet@lwn.net, david@kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	mhocko@suse.com, ran.xiaokai@zte.com.cn, rppt@kernel.org, vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 6wqk86hnnf8t63c7gkdgdzqcxn8ka4pe
X-Rspamd-Queue-Id: DA997100016
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768322035-217707
X-HE-Meta: U2FsdGVkX1+fN2XhuEnntuX4NNltqErdfHOS/FB229utn3TEPxFy1llI8Rj2uW2Q9eu6Pai9I2H0TYAeyb4SrMoPZ2O3OzjFcwjRinLfyVQ9GAt+KFFpCsv2zHLQ9Sz4Vx4AmSYtgiLuCf/AIr27CRxVzbz1C3PKoi+GrNCzbcslwSloYAwEKNwzDHwdpdL4UOtYhpXJ9P460Or8TGpAmRlgKUIjFfja0Zt7wmg3ID3OblFOJLSfTjrSsgvrFeQrUFTfgUGDGM8aAqc46fmxRoYK/ujftNE3cqb9VqP+FdNWrWnp9Mo9Smu0XDWnlVh4DVEhi9XX78SNX9M7WPwLIrVELuR/nZEi7GwUHoIWmd4sYM7D4eoq3ZIJHqtsw5g28j2MqP1tXwwItO7Tedf7EP9+8ORyor53W3eEbOhE9vURRy1Dkr09Z3xYaY55CkhRz5FmBkddYY28QLETfyE1LV9kF2KgOTAJRXipCFCw2UYyCn1JUaroQofb8sVVnEKcmFIAzDyIXMb7cQhSX2ifB5rDqSMPEmjit7uqjRqVZBcy33uySW1SckxtJXD30AJTDYTgHxPLbMaeV8f4bnlVO1zxZ3p/AbNGHwdq1CWeijltyidLtP7QSh1AgxdbeSt5A+kGViy1EDX/G7X6IvERA8nXHp34j9VehxC09btgXDamZHwDJvsESPFdWdSPWPAwoarWpuW/fNkEXThFSplEYZb0GU4B+v91KASeIi5QU8NY+TgHWZnlgHJvMOrfohxHlYqu0iVVKqOzAJ6Hv2mSm5dqA/kJ/MJI2U0UezhkHblMR4tRJJzUxtpsfDLOH92kM8Q4w6ZK8Qmvy6y+LiNT24HZdi/Aa/0YycqybkS46uU2nh0fE5e0Xi6+kwLnb8PXh+mBHEnboSdKQ4nIfobRI6YUN8ZN8zE3ZVQzcExBoNGWPkdrmjL3ieu+JsS7QBL294OQkPIZ9y35bJuN4BN
 zrQXoonN
 1jPGbK2kJ+lr47ooGSlTnbaY7TPguTiPVXNdLKo4kpHZuW7y2eYk2ZT01xSBGFOIE5GRNXrD3PSBgv4LU2HAXsOaMk/hRUI2Ou4/AXQZSJPgzkzWDjHWlbpaRj/Zr3xpVJlk68u4PYfhT395Lr43V+QAgbyMzRSsk2TGqvxlj3qZm3RSn/pmTGO3v6D0BQ2lqr4TEHjfkHCzXrMnzFjDtLyDhdT66gQ7c2mhPvaADxUoJuvKf/39iejGgxnWgdeyjIy6ys+A2AvvBDMELG+Rio0ADMHsQTc06smnnsq9zsn70CQmRFKhjJ2qjOo0Vgj+APEAJ/t0reS5lHZK+Z0A2V4SFvFNHGnegZKIRr4bElZypgRl7EfP2sOAqtA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 7:50=E2=80=AFPM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
>
> On Tue, Jan 13, 2026 at 03:27:35AM +0000, ranxiaokai627@163.com wrote:
> > >On Fri, Jan 09, 2026 at 06:24:19AM +0000, ranxiaokai627@163.com wrote:
> > >> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> > >>
> > >> Boot parameters prefixed with "sysctl." are processed separately
> > >> during the final stage of system initialization via kernel_init()->
> > >> do_sysctl_args(). Since mem_profiling support should be parsed
> > >> in early boot stage, it is unsuitable for centralized handling
> > >> in do_sysctl_args().
> > >> Also, when CONFIG_MEM_ALLOC_PROFILING_DEBUG is enabled,
> > >> the sysctl.vm.mem_profiling entry is not writable and will cause
> > >> a warning. To prevent duplicate processing of sysctl.vm.mem_profilin=
g,
> > >> rename the boot parameter to "mem_profiling".
> > >>
> > >> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> > >
> > >How was this observed/detected?
> >
> > Actually no kernel bug or funtional defect was observed through testing=
.
> > Via code reading, i found after commit [1],
> > boot parameters prefixed with sysctl is processed redundantly.

I was able to reproduce the warning by enabling
CONFIG_MEM_ALLOC_PROFILING,
CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT,
CONFIG_MEM_ALLOC_PROFILING_DEBUG, CONFIG_SYSCTL and setting
CONFIG_CMDLINE=3D"1".
The fix I posted eliminates that warning. Ran, you can post my
suggestion yourself with me as Suggested-by or I can post it with you
as Reported-by. Let me know your preference.

>
> When bcachefs was in the kernel, I spent an inordinate amount of time in
> code reviews trying to convince people that yes, they really do need to
> be testing their code.
>
> Strangely enough, I have never had this issue with project contributors
> who did not come to the project by way of the kernel community... :)

