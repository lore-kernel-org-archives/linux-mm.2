Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AC16D37E3E
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 15:30:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB8706B0089; Wed, 14 Jan 2026 10:30:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C66056B008C; Wed, 14 Jan 2026 10:30:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4B466B0092; Wed, 14 Jan 2026 10:30:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A224C6B0089
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 10:30:43 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4ADDBBA0E5
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 15:30:43 +0000 (UTC)
X-FDA: 84330956766.02.4C486B1
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf15.hostedemail.com (Postfix) with ESMTP id 23541A001F
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 15:30:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CgA4btdW;
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768404641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LHI4NLCuinMSMqSID/uXnOXOA3QVWgmhvFfo1463h8g=;
	b=Uqw8mmn2OKpUViBZJnlxyurva13KQcTBr0gjliQx54lEw7NayIuM6u+4t/Y7ua18H0p34X
	55yM3LR8D/Us5xpdiCCipCCizS/5ExZG/SW13W/JSwTLAY6702Usbt/nFrDw3ft+s+9bg7
	YpsgMuBlvsdl/vd6vNYgu4MWfTx3ffo=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CgA4btdW;
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768404641; a=rsa-sha256;
	cv=pass;
	b=B/XUU/uykSaSVpkBerzQV6qOgRx28BVyoIIWqDzK3Zi3kJimuaAlCEFgrrysDHxOcvjYyh
	IV9fqZdEZvT44oYpvxRdRmg3fChz/G3LweeB2SAckBz8UFIh2c5zIBSfXQgCRvBZ+GcSI6
	m+rcO8yAGi/vi5pq/hvZZM8yjBFYc74=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-501511aa012so171521cf.0
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:30:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768404640; cv=none;
        d=google.com; s=arc-20240605;
        b=lRrPmQ4OErOowRyoczHOBXXKXhdVIn9vRWk7C8xanwRuHXymOP44IfQqqn1rYTqoqB
         gBbEkdJWAqJQGF8uLEn7pQBDztYKWRVfphh0HQL766bMdGcXPFGUHh5AWf9EfIW3qn4Z
         y15Qas7CXEYL8P/hrkSZWoIF7+RTi4gtSP0cX5vZ4pGSOZJEf5xHSub8rD/IBSeLOOon
         YLeRbBGC7S+i23QcqwxLqFOu5gipZiPLy0D5z7bG3K19jceNpl2N/g0KlxHKVmCg8ydG
         w0tfgbqTO/K2CoQdiG346adeLaVjrH1CEJ8qZUlQsoOfaStvnztgNRDoWtVLup2WPg2a
         Ul7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LHI4NLCuinMSMqSID/uXnOXOA3QVWgmhvFfo1463h8g=;
        fh=oqN2MLFs2JPgEibU93yuUzSfe0IjsbjvqZSFAFetgR8=;
        b=jCIWWMWhm7xl9YeH3Eh3M4J7EKMRcPP4ifk1iW2EOcYfxlHNga1Ucv2Co97ZPKL2qU
         oXWwLXGmbQgXyhbmRVTOhZI91dgDlBRPpHfg9ERWFMXPl5uDst33jB7LqKjQspFR9/9m
         VFlUStHH/O1LlX9yMTf7YmaNiRZIvqbCLklagZhbFbPm9N13R6eEWCC5ikaF8c7HZW/W
         zELkF940Vg8sHtC5LhYmY7xYLVYELNLc8FTLgZdVR++8QjmWMsXCqRTRqN4phKuDh66L
         YTtjhb95ke8Lsvct3Pi+so8BhB4iNaau+oxtKNTxSBa+2OBzDGyrsrBECuv3fSOZWJdl
         CR0A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768404640; x=1769009440; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LHI4NLCuinMSMqSID/uXnOXOA3QVWgmhvFfo1463h8g=;
        b=CgA4btdW6pXy/o6+TW4UxE3MOY4P42bFYoStlG1IvQK/MeVivQaj2fsgeXUbr0ICrP
         2PmTbvTuP/l1gUAxGT2MSlenrXWWiAu9tMgEQ2bJ9GfKZctMnIZrQl4IjoG8rE68eJ7a
         Cjmym64RW1p010FM1BV4nPvd5r40P4C9NXNG2GYkQOkcGwex4oBcBsWgcwGR3E8h8dnx
         M7VQCj5S34G9tiG7c4n5oP1ZZJoa618XFc4wL0gdv+48mowjox9uCrupJzNULPnznhJp
         /9c8zgFGoZ8o9YZwZCCduAtEnOjGIgaPmZ6g3Jvxh25y15aLTJgqiObHo5PVnjB70Uip
         UJyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768404640; x=1769009440;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LHI4NLCuinMSMqSID/uXnOXOA3QVWgmhvFfo1463h8g=;
        b=dm5xWRKQiNJqFbp2LzPowejIGGAkf8DDXt1Gll029i1XZIw8bIOHUNDg21PGZJk0RO
         5DZ/eoIGSeJ9n36tEAfKolztdO8DBICKiMj4BPiyRJzTWhvkP5F4VeccEiPBhf5SS3qY
         XPm5aNl082gVNKkvf6v6Pbwks62s2ukq4fOBmk6t7KY77RiqREcdFFaSt8lY8Mv3N2Yq
         KNp3b1wbmt0042ITuLlKxmxWCNqqGU/y1I3R8AOq9wr5EEXdJq0ZUSxU2HDJ10IbB/3s
         qAoW7YpKwxTisn0uXJT66arXhyx3DVxI/l7Ws7VoI/cN2hWvRzN/jugL8CZHMiR7Pt92
         nisw==
X-Forwarded-Encrypted: i=1; AJvYcCVBO18sydG3oODXEb/aIxJ2qn/N3ntJfMvAXayXTLtg5JU7qtHOwBJx/SGxaxjwDrZXjsEvE57pBw==@kvack.org
X-Gm-Message-State: AOJu0Yy6e4wjbfF9OS1UR5vMv2HNnAmjkV9L79s0pnmGy8osgMNpnrrV
	lFeaSfloMRnCtF9LI9pcxJMAxcXa4p0EfETxB/i/+uPn6Q0EuoKGpfc2UJLqVTirNFx/MqCTIDB
	kep1VsNYjjUvcBeoCEDKd09Zxt/1SKgsSu+6CC76O
X-Gm-Gg: AY/fxX6jSLceJLlsOPWspF2r9yrb1wHCPA0YE4xBxYqTwkK4yKkONqUg/Mk4p43GsyI
	AMMVLAud+M3TdNGLMEjV6MdsnWdvSASO4cYY73m/wMcRHEcHl+wAGWOvFEXeNZsVd4Zp+2PEt3Q
	8nLmcNkU1xN4JiZh5gekO7tP2AuAe7jQ65Gg5vtZDm2SX4JTzvxxYjqcno61S4jPtOckPWb+8Pe
	8sS/O+l8m7vx3e+FbObCMscbdwBkBuFc/tZrpT6WMCIS4NKt2ZX9ZjprZcKR7YetChATtG9xVc6
	Yv/cCZC6lMw8cZ0mn3F01e0JMg==
X-Received: by 2002:ac8:7d44:0:b0:4ed:ff79:e678 with SMTP id
 d75a77b69052e-5014826ed12mr12371711cf.18.1768404639804; Wed, 14 Jan 2026
 07:30:39 -0800 (PST)
MIME-Version: 1.0
References: <CAJuCfpFTJUowSAjNum1zecDJYuyUi84vUNkoNNf=CnUwpsTVeg@mail.gmail.com>
 <20260114072507.163364-1-ranxiaokai627@163.com>
In-Reply-To: <20260114072507.163364-1-ranxiaokai627@163.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 14 Jan 2026 07:30:28 -0800
X-Gm-Features: AZwV_Qg3oxN8zwRkmODCQEHZCf-5rb3Om5ZoPZ21CjCRt6TeEP_vWdO9jDrUyNU
Message-ID: <CAJuCfpHaHa=g35jVrB+NL6xwh266ohNv7GUekZxPU0qsribJwg@mail.gmail.com>
Subject: Re: [PATCH] alloc_tag: remove sysctl prefix from mem_profiling boot parameter
To: ranxiaokai627@163.com
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, corbet@lwn.net, 
	david@kernel.org, kent.overstreet@linux.dev, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	mhocko@suse.com, ran.xiaokai@zte.com.cn, rppt@kernel.org, vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: k9aex6t1dogwnxxrbdr4xeuii3hkc7sz
X-Rspam-User: 
X-Rspamd-Queue-Id: 23541A001F
X-Rspamd-Server: rspam08
X-HE-Tag: 1768404641-255641
X-HE-Meta: U2FsdGVkX1+ibqK46uNjenX0+4TB5h9pRco43bv/MphRHfy1cd0bREeZWAv++ocf4jFbWmjByZYOyJcOl8VkzSVDyJtdYXa3TRw07oowNNLmsxNUe2IZAOMoB48sAs8Itt0tSo4Bg+RnXbDXFGr//n4Y6shWrWajvEizo2K4vPSk1H0U1E8PTY/ZTYOa+BVxEvudkJ6xFUb1Hf3eEn35enuONVa/wtlGoicn7B13Ja+UpzIxn/5pkKIjcWDVSYSEgLJWt/0p36BnwYz5Oc6ps9VIXUItD9xIAqNcW1p5sEa3hzYzm0GkkJnhEoygGmy0RbzdXjbtYRmjwvSglF4ks1lRbMyTtDu6Zta0fquBGOKwnSvqIdD/EJODUbJlBHuF7s8fiDy/j9woZJcI2VPkCrhY4wZh5n80RdZn1CjktyeLsqjTnsMA9wF+fj7ZXCKnQzDc5vr0nZ3MsBky5uf2vHANfMIBFz4+CeW52UBZpudwcceIAOXXsmNu5oh3BveZS8lguDrPFkNg28YH21wRtuPER2t6a1vrsbkHmet2kmLH75y3fmT7hBfKs78EbzDHMhiUa0q+W7NLbynXHesRtHvLi0T5mUIVOq5g+3Sd5Y30lBacjTaqEdTkAitPGaAYSqVkWyiTK6EIXN1Rjgbo/V1fqG6BYpcm+D7w9KPA99N4f3Qkyx4nrjUUiQAnQWPxxAM4QgCHbZ1n9SWsaK8MbvOWs+z2yeGaVPMp5oxSMEL7s9fURxfDs3qr7j9Poep5xtMoN+1AubUH/pqHBGIKTtxr9+rZ8iVK57fu+GH5tZTwTrQwip3kDbNdzH1EmGZuqSNWji5mol106+NrpCATJhc5zxGgGR+RY+TCUZDkUdnLG+J1cMrkLRf5dc8qy82+huj9h7mN+UKOugI/z7SQXr0KtRBFpmKvh5+gbYgnVPViiyW3nEaqtibBx/n2rIzkY8iajPAZMZVDjLYD71/
 450T+78g
 rpspJVHddOunmmBNQL/nGVdzoRs838uKNLUFVSEgxVONC6yUruJpPLsFN0OjTT3/aQVCw6UG8TzH5eXX6/8NrxYqeKPBp9EQ8FD27Iw5HppVlGUyhWYu7p6Gwmf3CRaSs6RqkDf0HG3gZHWER++wRONNvxTix0C4oAHDxr0qVh2/LfuzAL0swDlsYqsW3z8IXJOQ+jiXUJ5dcHXi1EwCSetblA0Cua/L1UFLOJ5FXlXHm/oRRZgagXluxFy/ujTFcJzSOHM1MQ+3x08FpiaxSFdgUsU9Qm8KVv8aGewKu01Q84ySa7UOA/3MukI77SeeovoVgDde9cygpRxvBOvsUrIF1BSAZDimJHiZzXSvrYIjYmtEhljsZy+xIq4vR4pJ8/ruVharwVRSzYCc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 13, 2026 at 11:25=E2=80=AFPM <ranxiaokai627@163.com> wrote:
>
> >On Mon, Jan 12, 2026 at 7:50=E2=80=AFPM Kent Overstreet
> ><kent.overstreet@linux.dev> wrote:
> >>
> >> On Tue, Jan 13, 2026 at 03:27:35AM +0000, ranxiaokai627@163.com wrote:
> >> > >On Fri, Jan 09, 2026 at 06:24:19AM +0000, ranxiaokai627@163.com wro=
te:
> >> > >> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> >> > >>
> >> > >> Boot parameters prefixed with "sysctl." are processed separately
> >> > >> during the final stage of system initialization via kernel_init()=
->
> >> > >> do_sysctl_args(). Since mem_profiling support should be parsed
> >> > >> in early boot stage, it is unsuitable for centralized handling
> >> > >> in do_sysctl_args().
> >> > >> Also, when CONFIG_MEM_ALLOC_PROFILING_DEBUG is enabled,
> >> > >> the sysctl.vm.mem_profiling entry is not writable and will cause
> >> > >> a warning. To prevent duplicate processing of sysctl.vm.mem_profi=
ling,
> >> > >> rename the boot parameter to "mem_profiling".
> >> > >>
> >> > >> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> >> > >
> >> > >How was this observed/detected?
> >> >
> >> > Actually no kernel bug or funtional defect was observed through test=
ing.
> >> > Via code reading, i found after commit [1],
> >> > boot parameters prefixed with sysctl is processed redundantly.
> >
> >I was able to reproduce the warning by enabling
> >CONFIG_MEM_ALLOC_PROFILING,
> >CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT,
> >CONFIG_MEM_ALLOC_PROFILING_DEBUG, CONFIG_SYSCTL and setting
> >CONFIG_CMDLINE=3D"1".
> >The fix I posted eliminates that warning. Ran, you can post my
> >suggestion yourself with me as Suggested-by or I can post it with you
> >as Reported-by. Let me know your preference.
>
> I think this version is better.
>
> [PATCH] alloc_tag: fix rw permission issue when handling boot parameter
>
> Boot parameters prefixed with "sysctl." are processed
> during the final stage of system initialization via kernel_init()->
> do_sysctl_args(). When CONFIG_MEM_ALLOC_PROFILING_DEBUG is enabled,
> the sysctl.vm.mem_profiling entry is not writable and will cause
> a warning.
>
> Before run_init_process(), system initialization executes in kernel
> thread context. Use current->mm to distinguish sysctl writes during
> do_sysctl_args() from user-space triggered ones.
>
> And when the proc_handler is from do_sysctl_args(), always return success
> because the same value was already set by setup_early_mem_profiling()
> and this eliminates a permission denied warning.
>
> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> Suggested-by: Suren Baghdasaryan <surenb@google.

Please fix the above tag, it should end with ">" instead of "." and
send a v2 as a separate email, not a reply to the original thread.
Otherwise LGTM. Feel free to add:

Acked-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  lib/alloc_tag.c | 22 ++++++++++++++++------
>  1 file changed, 16 insertions(+), 6 deletions(-)
>
> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> index 846a5b5b44a4..00ae4673a271 100644
> --- a/lib/alloc_tag.c
> +++ b/lib/alloc_tag.c
> @@ -776,8 +776,22 @@ EXPORT_SYMBOL(page_alloc_tagging_ops);
>  static int proc_mem_profiling_handler(const struct ctl_table *table, int=
 write,
>                                       void *buffer, size_t *lenp, loff_t =
*ppos)
>  {
> -       if (!mem_profiling_support && write)
> -               return -EINVAL;
> +       if (write) {
> +               /*
> +                * Call from do_sysctl_args() which is a no-op since the =
same
> +                * value was already set by setup_early_mem_profiling.
> +                * Return success to avoid warnings from do_sysctl_args()=
.
> +                */
> +               if (!current->mm)
> +                       return 0;
> +
> +#ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
> +               /* User can't toggle profiling while debugging */
> +               return -EACCES;
> +#endif
> +               if (!mem_profiling_support)
> +                       return -EINVAL;
> +       }
>
>         return proc_do_static_key(table, write, buffer, lenp, ppos);
>  }
> @@ -787,11 +801,7 @@ static const struct ctl_table memory_allocation_prof=
iling_sysctls[] =3D {
>         {
>                 .procname       =3D "mem_profiling",
>                 .data           =3D &mem_alloc_profiling_key,
> -#ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
> -               .mode           =3D 0444,
> -#else
>                 .mode           =3D 0644,
> -#endif
>                 .proc_handler   =3D proc_mem_profiling_handler,
>         },
>  };
> --
> 2.25.1
>
>
> >> When bcachefs was in the kernel, I spent an inordinate amount of time =
in
> >> code reviews trying to convince people that yes, they really do need t=
o
> >> be testing their code.
> >>
> >> Strangely enough, I have never had this issue with project contributor=
s
> >> who did not come to the project by way of the kernel community... :)
>

