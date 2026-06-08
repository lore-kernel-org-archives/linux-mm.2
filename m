Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D06BBCD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 15:43:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 217856B0095; Mon,  8 Jun 2026 11:43:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EF146B0096; Mon,  8 Jun 2026 11:43:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1053A6B0098; Mon,  8 Jun 2026 11:43:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F30F56B0095
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:43:51 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B455C14019C
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:43:51 +0000 (UTC)
X-FDA: 84857165862.05.ED1AA42
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf07.hostedemail.com (Postfix) with ESMTP id AD48E4000B
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:43:49 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=h8fWO05X;
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780933429;
	b=GierbOW8YG/JTlNv4Rwfa/6/Zu5C4KJgh0ozy1yQQE4dX3iFESq24P/7wRhM8sPgMykpbB
	Xe99xOMDiwxilXC8nMuQ/b0KwxcSnrjFs5EifX1afhZTiZjkjmKlnXwaZ+znvZXlI0Xq4G
	1lDZrRA0HSIsBzaA0JZ4TQ334ISKgDU=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=h8fWO05X;
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780933429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LNsO1uYwbZ4YYu1nCvJmCZN9gsNpZqr3IZ/OrlPN7h8=;
	b=39abdC9yB4hPTl9wbhs+cVvlxNgaFdMA1/xB0frCc+i9H+bEetp/hpXGEPVEOdH0k/bOej
	v68oJA+cuhOWIp0+0rl6s/znjb1URqil+9BLjG4/X4rB4EAoG3hWAJyU498ei4XCGBU9dA
	EVyg4fjWO0lPE+6gpq7lNLi72Q3clzU=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-68bd7ec2371so27641a12.1
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 08:43:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780933428; cv=none;
        d=google.com; s=arc-20240605;
        b=fj0YUxA4hNW76CvOYDrtEVCbQN1t6rCMW/mm865iBpdCKaWVtd3hQR+7PLscSoZiA7
         AuWUXKg/ZG+rHHCGTI4K9qoOlhKKT2IRp6LIF1xM9IOLAuREOmcNwVsy3+zSdnmI6D/+
         FyK5ThspXq5eANCKVf/TsO/sx+b3SOQDmDeeuNf5dXrXRR/mASAD1PHn2ViUhqltNbUk
         1V9Rsmn7KsEk6bR7jnEEW/z4usT4UhnKlcTaA3vaYzWQ6PL+QTO4/XjeU7wvvHQk/uX9
         lf+ZYACXLcvTcMold06wDEd59PM3bPGS/T2bdmFmC/cz1nsDRUN7DNzOW1qCtY3xuGVR
         9ftg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LNsO1uYwbZ4YYu1nCvJmCZN9gsNpZqr3IZ/OrlPN7h8=;
        fh=YbmswnZGQMP0GORJHSoAqY+HFpAk/kZJUZItAcOjGdA=;
        b=LsgMAvQgtVpDvCvxlGRTAwA6XifByB5mkfOiyJEpZapJrwAnx4qh0Z1RnjdAmHGaNy
         UeaMn9k+J0SapdlYyP5ItuXgVhmIqdY35m13U8LF1p5Cn3YFQcWZBix9WUDfFURfoOZH
         SnKvDYm2vQ82j8IfdoTc9oSmAD3v26Ywm+oDvAS5CRDvpU+H3YbfIlo8nCi4dULHRIAn
         dUMdKYLG8CzJ/lepYi4yxBeNkKhVmI8FCn7ajn/tgRF3ZoUO5/OUkIinYTiGsNRTq8uM
         qfv98zDuBX6qGL/ZNAbPkDtu6ZupYWSc1sbewjwhZB/++DwSBvLwsFVcNGaoieJS7Kg+
         NzpQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780933428; x=1781538228; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LNsO1uYwbZ4YYu1nCvJmCZN9gsNpZqr3IZ/OrlPN7h8=;
        b=h8fWO05XkYVstm1JXsSLx0Lc6dhwdEThBNxUEBRaYmuTaKmrBfysdMYmWIHStK8qdO
         oq68BaG8+IE3qpWX/0NqIISMWk/cZdjNiKHWP55uuePocuQXF3cClN/WwRm5A9WwhmLc
         4ikMobdCxM94RQ99IkZvEo6kqPondrtTsAqSkXHVcdZ09++4kD9ACkoaZx4Nl6IMix1Z
         VQtk9zggRZzzLjiRf5nn4DrZSFKmj03829wj0h19vDncB1ZsegJriV+OpEw4sbk+haJW
         IFfi2XO3nSWU0OueFFv16whcBFFmgXuPVPmFFZMbuW6tISh/9eWmOsugJnJfVPHqnmAU
         cbJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780933428; x=1781538228;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LNsO1uYwbZ4YYu1nCvJmCZN9gsNpZqr3IZ/OrlPN7h8=;
        b=Ljq5V97CnVbnpfmIY5e2TythKywcxfV0Q40KRc2CGsYwAZDrBCoqThTqllaejIiMny
         Rs060m2/V5mjPBnBRcpjMZdN4ZkhyxgzRDok/jf12iPOSLStVFbgyWhnbL+ZMVJ4QP95
         eyhNAwVwj7z6jDMI23JHJObiJH+xpbVZEjTVduNLquvvBVsyr+JOEpdeXgp1BPJJhvxZ
         KY2pv1lb5CdfPUMeX1B6JD2S27RzpY6InKtHI1IleJPrgnYb2yEwtdBfGN9Ehzu2jNZ3
         n1F9xuV1+DAwV7idyD46XWnsMqQOnNZKe5g0VGYQ7wse/YpMyDLm0Irlq2ZzDLdLF2ej
         V0dw==
X-Forwarded-Encrypted: i=1; AFNElJ/6VvKa73f2XbEou4OsEozDPg3fttCGd8t8pXhuNCq1Uuyd4CmpOXUBbb4iZvzcMKANCTskYXGMOg==@kvack.org
X-Gm-Message-State: AOJu0YxaTAJc+1qMyFZNJKnV/8Efqmv9iySnizcwcy/mlA0Vk9pK0IyF
	k0Toa6BBloOdlix1v5yraaHRbKKPSfp1Vf/pcQQDUfjSa2ZpcaSQS4W0ANnR0siw96ZCVrTcqZS
	9le7GvXhGiigUvieYlds/PtXlkc4Ude4XW3U5E9Za
X-Gm-Gg: Acq92OFAytAEfD3JJvKYx0my9Bpx7o5iTnrQu36vnbgDyoHU3afXUay+61WbjrAswrq
	cftsHAn+n/CctYue45J/l0OmwZcIRFeDO/6jr/l/dKYNUOKefEBxgoyG2WQQArVdN6bJ+r4hJiC
	jYJbAl9o4zFcBSgu1k1954tpIpwKK3Mxv+20L2qqBKl4jXYnYH60QtsHNDoqwqgNUSMv3ErJSG4
	urfLJPVtvL3jRbpGprVVLtVC1bZGxKEH4by1ICIsrym9xZ/VXvL5U+KIPXRWdRlvD42OJM5wziZ
	vv6IwcqgKUgTx26r
X-Received: by 2002:a05:6402:50f:b0:68f:d41d:ca60 with SMTP id
 4fb4d7f45d1cf-68fe9289b95mr168955a12.14.1780933427834; Mon, 08 Jun 2026
 08:43:47 -0700 (PDT)
MIME-Version: 1.0
References: <20260606015729.1837935-1-surenb@google.com> <20260606015729.1837935-2-surenb@google.com>
 <aiPWD6xZLg6g4DTO@lucifer> <CAJuCfpH74gRmgm2tgwB7SHzL9DrU3Yc4LyS8XLa0tR7fJqaw_A@mail.gmail.com>
 <aiZ5qFTc6XDMsqB9@lucifer>
In-Reply-To: <aiZ5qFTc6XDMsqB9@lucifer>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 8 Jun 2026 08:43:33 -0700
X-Gm-Features: AVVi8CcIo-LdW6RRulcqTsqgvVlgvcZ5udrZhHCkpCEXNwWz6fYGFce0NkIqXT8
Message-ID: <CAJuCfpE_LnwyKKtbFGN4hz_VyRkVh_yf=kQEkUXHdSUwHMuF9w@mail.gmail.com>
Subject: Re: [PATCH 2/2] fs/proc/task_mmu: read proc/pid/smaps_rollup under
 per-vma lock
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	david@redhat.com, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: AD48E4000B
X-Stat-Signature: ac1dd6ddxjdb61qxb3xabjux4mgg9xrg
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780933429-898725
X-HE-Meta: U2FsdGVkX19KnopigQlXmWDGh5XxAnDUPOKs8aRYoV2pNevpY7fIbay6w4kMU/GM1U7IJhKC/qtC7E2AtNzq8YS+u16v+Pc96HW2fZlloeRalK9CqUHZUOxalENnrZmmb0anqU2QXSaifRiCmFRu04wK3MyYpyaqpypMH75mMLI6a9bFYpuVSFaTEBn703br8nDbrkS7sjZVzsVs7A78iiB22VFkzET7m+/IB6NDpWIZWmFiQLEcfTCyAejxdBSHHZgf8zN7aO1FXVoPv91yBHrJSvu2ZJ09JZk3u4xxuA3RfxaqmbMTUrXZilyCbXmPY2yMkem7/ZIvdqjFtfuMB3TqfewK+PjG8ZxjexPpjQa1u3pP9lOmP6AqrmxZ8LWB5vTNFDAwNdVUysm0WUaK4S4+41O5CBeiT2IbhjYMJHYkmLoNEa14ee2A3L7zv4PO176cQA3GgoX0YJYFGGsk4VrWcqa49OcroD0k0+jtuhQBPJI6oXL4h6uf1XQg3jc65GuWb7NEjPMLh5X5GvSv9q0LfENjDQTYddxcAqAOHp4QXapUnaeLlg8SLwBtB97iixi5kRQzI2ELIDWoF51NchfZwpFoPUgB6pGWcBQPISZ1wFSbN+AdJ7cptmvF9LIbJI5Q6GQQ/54PlbFCdkN23G1A/A5e/DGFKUPw/txo5WaDxdrySeJQbzV/r4fzkhn1y70tTqAgcAXIFPQ0moWtlNSIUa0NZT2T3+1hbiJtjLrdG3m0xUGg2PAfCuGKkSDCEuEMi+OqVQPms4l2HGCxObmzOxViFsrKNI0SIP+hio712Og9iTIwNFWLrtZmgsL+Fo0sYD6V9Cx+rVrSHoUqXILwVqMami9/eqcQHnORoUEBgyOLoRfMOnHsbucsuhyTUJ+J6JRd+vy4oThPrEfnasISrHg7PHGAAnNE1mh24XpbNkUi6TJGL16g+5+4xuDwigHJELyA50m6pY3GF59
 3oJ1P1Nm
 ULAqIzGAWdE4AmPzuSqz98Z8sZKzrPF6BN/2CLhQJLb/XljCjIoTsBTfJz9Ij3p5BSn23oZo4dLoFFdvQGykLw24lIK80TzksmsrJlOejIo6o5RF/Z0JoETdwfr8aopBw9ZWY/6dvDNcUt1pkg0aMVH+B35nS/V4+WiKmW20WbBIv3Dhp8yQZOeC+82XtqeoAouZUbVUIxikdNcIPDBoWVZVmUmROdejdjM+pB8HHks/ZwTnimolubL+UER6TumS5dPZs+xG4JFN56vDooqQD7n8EFvDF3XLuLCm7BPfp9/FEZt+onknFzA2g4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 8, 2026 at 1:14=E2=80=AFAM Lorenzo Stoakes <ljs@kernel.org> wro=
te:
>
> On Sun, Jun 07, 2026 at 12:45:23PM -0700, Suren Baghdasaryan wrote:
> > On Sat, Jun 6, 2026 at 1:12=E2=80=AFAM Lorenzo Stoakes <ljs@kernel.org>=
 wrote:
> > >
> > > (Will review separately)
> > >
> > > Sorry to be a pain :) and I know it's a petty thing, but even for a 2=
 patch
> > > series it's easier to handle if sent with patches in-reply-to a cover
> > > letter :>) also makes it easier to track overall updates in cover let=
ter
> > > changelog.
> >
> > Yeah but the first patch is a simple cleanup of about 10 lines, and
> > writing a cover-letter for a single patch seemed excessive. Andrew
> > would have folded it in with this patch anyway, I think.
>
> Makes sense, sorry to nag but I want to be consistent in nagging everybod=
y
> the same :P no matter how well I know them or otherwise ;)
>
> I will take a look through the patches properly in a bit, I meant to
> actually do that on Sat but got distracted...!

Thanks!

>
> >
> >
> > >
> > > Thanks, Lorenzo
>
> Cheers, Lorenzo

