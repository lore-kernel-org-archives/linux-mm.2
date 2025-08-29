Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F36E4C8303F
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 03:05:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B5D96B0012; Thu, 28 Aug 2025 23:05:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48D436B0022; Thu, 28 Aug 2025 23:05:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A3806B0023; Thu, 28 Aug 2025 23:05:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 29F7A6B0012
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 23:05:41 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CF9AA1DDFA7
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 03:05:40 +0000 (UTC)
X-FDA: 83828304840.11.7F8109A
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf28.hostedemail.com (Postfix) with ESMTP id 008D2C0007
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 03:05:38 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OG9UbEfd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756436739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rm9UORu61ILt8i4V4EUJUDwciURTt9U7GCvX8oYPwcg=;
	b=G432Bqq7DqPKvrffrk7AD/6dCGz5qGdGMUqMEtFjm6NDThsowjRfPJTWdn1N6S3267uzQi
	xHn6aA0JNDiphXnvOnsmzHvAB2LaZ49KsWpIinexfE4wOwpj+mrkFRw4o9h8hLgd0bMxre
	Z+GyAf4TR0HJrB07bsZ1ZmSvacHDnjY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OG9UbEfd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756436739; a=rsa-sha256;
	cv=none;
	b=HiIr8YU1mzcIaezBwdy/Ng2utkuP+gFimxlOiuoGP6Hd/MXuga95D/MhUKI/LQ9zsj6gtX
	aDLuf+m9Cdi1pyQa2MTyHFMYHvLWOzNoqKcZkGp43KPbaW9IYLH2Lnj7+Wj4/RtdazDR//
	FuaLsV7SaFDU5gxmvrhEZrfZ1gJgl2A=
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-70ddadde2e9so14796016d6.0
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 20:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756436738; x=1757041538; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rm9UORu61ILt8i4V4EUJUDwciURTt9U7GCvX8oYPwcg=;
        b=OG9UbEfdotQkQj2FF5sO4chAVT95wB2bL6tovy1jtdZTtI4iiMMUceraYvh3U2fXSs
         rAhx824tQ8HcrjpTH+zvmm2rWIRAQuVRREBrJLvb2iBic9MI1seFcPGrIHmDLaud6nC8
         i67dPrY1gZ/k0nm5Cpfj3WZoGZJxl2yFolUwk5tg4UyREFivQUJWvqLz4gmyt+mZKFEg
         427HUWgYHQZ/88kuoW1mXNeZSocqRZTKkEWY0uJbiELe8wn0tl/zyKZFnq+tCrMs5a/g
         UO4PTDQvgd6Bofg/CvWKMWk0VomkuxZRoXmO2sG+VurV8KCsT/dlxGFoGaIconngvNNX
         LeRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756436738; x=1757041538;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rm9UORu61ILt8i4V4EUJUDwciURTt9U7GCvX8oYPwcg=;
        b=xCuoo3xG8H+YDWUFbBvWn422CBBNTPjkPN0yN49e1kIghYzRijUwoHplqn/pwUe2r8
         yR3oEFjY38Ij7B5G5zMEj+8JEtoNZS6KhsCIcNdb7Wi6fQ0MD4O56470O8h3+4KKuzOr
         2HiaoJTD9PFDa1HP0/Dfl6BKH61rv0dIHOpEN913XqgjciTz7Ybdx2ReEuJtOwp/YIgW
         c/ubyjzjfw7oHyRz/rlwVJ/gk2IrRDXEaY8XWbq/2HfRZni3QvVp0EKhi4BZHC/BDvGT
         +jpQsXGKhlYi6/i+KZROZ3UOPsWFP3cYRaZtNx++IH4jbsjy/r5hXIXm5ZpnVfd8+qSq
         z33g==
X-Forwarded-Encrypted: i=1; AJvYcCVTPy7grsa6VupMgz7xbJJCrJVQKCdF1Sjv3IKOshsWH0Zcdfw2EWfKDFcf9B+aTOtKZ/wshmn6kA==@kvack.org
X-Gm-Message-State: AOJu0Yxxfc4hjfCfw6hVi1DVHCnJr+WmxmAn0kIUe9MONy5FRi0jGUgQ
	syNluZQjwzBvknsXt3hCjRKVJn+J+5/5R9Fr0VVwTOiCIIDSxKbgvRR9bND6dklf56gh8SNdsAl
	Tevde8jySgLpW2OKgPgm6RPHUfgRNUfk=
X-Gm-Gg: ASbGnctpV5wf8vyZ2b9d0gBNEx76lCqlZ0+oT2DecW7L1jMKPT2nWLb/sX3h+4JWmsQ
	z93yCYjhW0bFQTFiwLjP0UgGpyTXzf30Sd3s5If020brTdpNTucdlW7K4duCGQN2b+DX2Sl+z+k
	UDZrd/aHML84hF29kmGGCPJvykqE+L+e6ARYBaR1M2dOf2POu1XVUVSanj9Htgp/8BRwnqQm4cO
	TUEZ3GAbxoE5NCdAHePoff8Uq0IozESJ5lPKCk=
X-Google-Smtp-Source: AGHT+IFXdA7LJArbjhB50zi9oIGtUBIHMcF+ph6Q/htUjjp/1ateQP201klw17fLGsGNyNz6MLeHTAPUSbdTC5BQtKg=
X-Received: by 2002:a05:6214:248c:b0:70d:cd1a:4a43 with SMTP id
 6a1803df08f44-70dcd1a4ad2mr152609386d6.46.1756436737975; Thu, 28 Aug 2025
 20:05:37 -0700 (PDT)
MIME-Version: 1.0
References: <20250826071948.2618-1-laoar.shao@gmail.com> <20250826071948.2618-5-laoar.shao@gmail.com>
 <bca7698c-7617-4584-afaa-4c3d2c971a79@lucifer.local> <CALOAHbDxxN8CsGwAWQU4XRkG8NvU-chbiDv=oKW0mADSf1vaiQ@mail.gmail.com>
 <b335afe9-be7a-46bb-bf92-37abf806d164@lucifer.local>
In-Reply-To: <b335afe9-be7a-46bb-bf92-37abf806d164@lucifer.local>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Fri, 29 Aug 2025 11:05:01 +0800
X-Gm-Features: Ac12FXyRkVAu3IBFWqROm107KDRmxs-OaNCft6vWe5MQxiSekVcD1hUUDL-ITVU
Message-ID: <CALOAHbApv0Sj25La7EQZg7UBxfvkfMXpGPtNrYKABSYpNV6ORA@mail.gmail.com>
Subject: Re: [PATCH v6 mm-new 04/10] bpf: mark vma->vm_mm as trusted
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, hannes@cmpxchg.org, 
	usamaarif642@gmail.com, gutierrez.asier@huawei-partners.com, 
	willy@infradead.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	ameryhung@gmail.com, rientjes@google.com, corbet@lwn.net, bpf@vger.kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 008D2C0007
X-Stat-Signature: wzuh5jb9wxxusjyfegjewae89tk8rmhx
X-Rspam-User: 
X-HE-Tag: 1756436738-29346
X-HE-Meta: U2FsdGVkX1/J1YM/oJwmDXkN/k9rAE9BlVMWS5ggdR3Apq5yNGXIehbhBbhxCeg1csPEVWgL+7x2z+wjyaMqGhvbohOcJPTsn4vcosoBZpzkGAWAg4e8Fv4K3fnwC3VLZYMdFq1eeXFwvyQ+9L7VH+drTcFrCqT4RnbeYM61CuIHRCBgXSx5QHJjoWS7xV4uTV0kD7SDyqAzTTikKAdO2Iu0dCypiwp2hcv4gz0KrwD4Nbf1NL16JbuHDM2hApsGsdaLEWIUX3D7FG8sDYRQwFKjybitbN9fZU8HR5aMSP1cONUi3PM4J96SpsdKeq+Rcmdw1y5TPg20cw6IdDUY1kviMNzQzdxclmaFYuLZ+HUfgC0C3lZsmKkOgqrWnUkxAtO7v+hjaCNsq+t7ty2cC+nea7ljCOAFyWxKOce1dkSM7yjs5Hko+ImAQt9SgdAlTPgHkUQtAZ7EDiz9Jj4D8Avg6XRBVoveJeoKth1n8xZC8hOfPN+ZKkfbCKeBwbiagItMIB6n49ZUa8k3+Cf/rKujf2L3/chAY9NgVPIdDo98Mk1AoWJdGBEKIV7mKwfm1DKdAohDKfd6DIRq/L/lPiaLqu+sEpaLi8O49RT6yNKruaSk73lLzbsM1g/MjnkVy17zNyxj9bFTsD8NuR0rv9BXiU/cjrKEBNBgredxnCVnWXC/K8sEusNYsq3QoulmwcAv5lf59zSBN4mvSG5jwiWk5USbaB0n9Hi1ZD0I3M1khP6aajnOe7Qq4vXYadlLQ3eP6Ap2t6fsgZSrrQrszta0GwQ2PthgS7AoQ77oXJacGpQLw0mDTWghJnW9QYH9hp6vFauYdLoCVGBrGQ92dgLYW8KdhK+iKJPC2ejrtOHj1GufZTlgSejggWyi5O0CT/UH9uYVDL3YlLLK1ZB2ysssR5G/neiP3F6HhOkLT80tiYBjB8g44F/vSPd9d/p3XFHk6ACTwx0QP21/DhD
 cBG0ezz8
 Wz1Kbd7GXaz23P52Rk7hY20EYQOySn0iEdSIEvgZwJGjvREwx/X5/2ZBZzEuz6wpgytdpqSZo+YfQKEej+LgECSDJg3j7zt9Q8jBRhhYHUAAa8fTx/kQ3woyWf/EfrEn/BqZHXiftuOMFv7JbCYOCa0PnS8EUBc/Gb2vVWLkGtJxKnqPK7KCjNXmIr6XzcJMeADG4tDaQNMp4APZpGY3yLxu2yD2C3XK4dTKF6+m/V/wQHdySfHM9N1VwAI8Wz2jHB0gKrxV7BXgGB0PKGhcHukaJcvvw2oCcjVocnbg+U3s9jQAUJobCi9jux1AD67WZz7KirLVALqadJvsA5eRYoiwhsRUGMpY4rGwEKgIBiGPTZes2y60BNX3kI07AGf3hOUFj7P6jgxcsFz4TG8157bcM4jPdIL9Hs8A079XwfeCgPzgyXAtOtwKwAmccT9dpYUbYFt5QPnUSZU8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 7:11=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Thu, Aug 28, 2025 at 02:12:12PM +0800, Yafang Shao wrote:
> > On Wed, Aug 27, 2025 at 11:46=E2=80=AFPM Lorenzo Stoakes
> > <lorenzo.stoakes@oracle.com> wrote:
> > >
> > > On Tue, Aug 26, 2025 at 03:19:42PM +0800, Yafang Shao wrote:
> > > > Every VMA must have an associated mm_struct, and it is safe to acce=
ss
> > >
> > > Err this isn't true? Pretty sure special VMAs don't have that set.
> >
> > I=E2=80=99m not aware of any VMA that doesn=E2=80=99t belong to an mm_s=
truct. If there
> > is such a case, it would be helpful if you could point it out. In any
> > case, I=E2=80=99ll remove the VMA-related code in the next version sinc=
e it=E2=80=99s
> > unnecessary.
>
> If you lok at get_vma_name() in fs/proc/task_mmu.c you'll see:
>
>         if (!vma->vm_mm) {
>                 *name =3D "[vdso]";
>                 return;
>         }
>
> So a VDSO will have this condition.
>
> I did a quick drgn()/printk() test and didn't see any, but maybe my syste=
m - but
> in any case this appears to be a valid situation that can arise, presumab=
ly
> because it's a VMA somehow shared with multiple mm's or something truly g=
od
> awful like that :)

Thanks for clarifying that.

--=20
Regards
Yafang

