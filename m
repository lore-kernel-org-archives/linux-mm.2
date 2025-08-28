Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68853CA0FF2
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 06:59:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 853166B0026; Thu, 28 Aug 2025 02:59:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82A0C6B002A; Thu, 28 Aug 2025 02:59:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 740126B002B; Thu, 28 Aug 2025 02:59:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 626196B0026
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 02:59:07 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 02A8F1409A3
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 06:59:06 +0000 (UTC)
X-FDA: 83825264334.24.10043DB
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf17.hostedemail.com (Postfix) with ESMTP id 539AF4000B
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 06:59:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CiDbbiI3;
	spf=pass (imf17.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756364345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=imRtYecfg+etFNKaWp3et/EHqOd3Dvqo3ESB36BTlR4=;
	b=GyW4qFsfjQ2om9mQkpTUoBfu/peCSeq5GYSI03D/gnK9rqdSSlkSPjEMuLB6WlJ5Fo1FZY
	NCKoBRX3sWLxrtv1UhgDK1f9DXf8Shp4dpPK0EUltYMP+9YW585m1gCYJvAcejU/ah9tg2
	CubPfhjzyinphV9ev+hrKwU2VuBETn0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CiDbbiI3;
	spf=pass (imf17.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756364345; a=rsa-sha256;
	cv=none;
	b=NxVTiG9kDiabyVhyu5HJQ/Qzte+c39S7G9eWheawKOEYwpZ49RaPSq/OiY13UE46v8xQhJ
	+LdmD3hZaiB+lA0ZC0PbtJLJBCA2e8VVcbffToUa7+3fpj5WsYEQRBDR1T4yrgUUAi+SBp
	rfcWxh+FwqvO+7Ct8mTt39gDfdoQhEQ=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4b28184a8b3so7369211cf.1
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 23:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756364344; x=1756969144; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=imRtYecfg+etFNKaWp3et/EHqOd3Dvqo3ESB36BTlR4=;
        b=CiDbbiI3yjRdc7kc2xaFZQM43Vbuus65UYAqqkipDEJeBxdRiwIpr0quww3hY80ORN
         gGaatIxkn2tiGI5k95UmyUqDU7JYQkEAMHBjVQN2HgcjZEgaGbjRYYoHrklZ6zS295Jp
         otjvb5Gqqmah47OAzf46mKY2/yHzZZRwpQpnLoEmd6gaL6dezOFLqZ16aLXCKo3qaQKz
         Xl/KIRMewei1Yx+sjF6rna3L9x0NhKidThgzJOL0RaPT9PgqGkZ9PegDDrresV7d9PjZ
         MhyL2sJWwU0Nia5QJJ2yuQK/SYezG//7e6f3xGt/e1ghkrhXxR1WXm7mag6dL5p+fwnq
         XaGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756364344; x=1756969144;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=imRtYecfg+etFNKaWp3et/EHqOd3Dvqo3ESB36BTlR4=;
        b=VdZrrLghOb6CyoYRYZgq/3hCGH60yAMDZrHrarsDmCxvV1Dg6YW0MSce8JxJcYiEoV
         qxJMeefiHJ8z7V9/xdDyCrwfTkWaylLbXGpg7zHGWXz2fWUvQhh/DMbz8TSCjzO/LLig
         Hzf2OQchvSvMaDxemoQ8pS92kp43VXe9IZvs0S1v2McTK2kCBZGxsxFEkvSKtrQ5gN7Y
         1grolmgh0/jHVUw2947JkZo4cPxxV0iyNtCxY/ZWpRo87eIDzVxifOJ4MJON2SfOEDX1
         q4qutBZd0LDC5a28SC2tARnn/cAYdZTXD+y6+xeBCHlEJQcUyOMl/NfSohQazooUIVxk
         YkSg==
X-Forwarded-Encrypted: i=1; AJvYcCWn1kvxjxqA3o+DDPIBf9jcfKrwKeqsuSE8J89Q5FTdzDv6bzsr/tY2pYb4Onj7pv3sfEIE5Ca2Jg==@kvack.org
X-Gm-Message-State: AOJu0YzCoC7htalQe1LO5qc9uOJtDjeIPS+IMDsPW2A1I1iJ4xTtb9T1
	pDsWABZOow12oAfJpp6oV/OUrjX9bKDYiE8LbcjTQrLah5/VTDeN8LIT0RT6uSIj+pVV7sJ0/v/
	HcLjBhYSN8OlP/yHJEelLlx/vw6ZBqQQ=
X-Gm-Gg: ASbGncvsLdj7N2FO5/8zFotF0G+Mp2GAFzL6gv0kvn+Hi4bmH4AWAl6NrTjGmxwmlPf
	3T+R+fF/8wxkKEfhwml6pECmmi0SRN6uM52SnA+9xPZ1eyAChHqClKx0YmJlJlJ7/HyJeoU5lZU
	b8EuPT1eVghCB22RUvDrm/G54e066toUj3vpw5H2Ti3t9Eqq8jRDHaNZrRyTLHv3U0OZo/EbBTr
	ErtIX8xtkhBkDIoe9MqzupJYSn5DdCBRfiX44lb3h50PDx9dQ==
X-Google-Smtp-Source: AGHT+IGMHvpvoVZa9mXmBBeocL1rpGhAuvRVNAEm2pjo8nSBLdwTn61/uotyQhl6uDY9bSKpy9uNA61YHeQ2elpq2ks=
X-Received: by 2002:ac8:5d48:0:b0:4af:322:346a with SMTP id
 d75a77b69052e-4b2aaa7df5cmr235111751cf.37.1756364344187; Wed, 27 Aug 2025
 23:59:04 -0700 (PDT)
MIME-Version: 1.0
References: <20250826071948.2618-1-laoar.shao@gmail.com> <20250826071948.2618-3-laoar.shao@gmail.com>
 <fxjgxvoq3z4utlwb7asmt6wfjfl5t2nvfnghhmwplhqerv22yg@3i4gdavsyirq>
In-Reply-To: <fxjgxvoq3z4utlwb7asmt6wfjfl5t2nvfnghhmwplhqerv22yg@3i4gdavsyirq>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Thu, 28 Aug 2025 14:58:28 +0800
X-Gm-Features: Ac12FXxzOOTe1natEd0mMCAsPZpFJWP7A30MXtoADcSt0CwP8hYi3Z3hSqrAKo0
Message-ID: <CALOAHbDmtyH54sxyxhRBAd+f1m-Yw6WrBvdk+Qom2SMLYqCAYA@mail.gmail.com>
Subject: Re: [PATCH v6 mm-new 02/10] mm: thp: add a new kfunc bpf_mm_get_mem_cgroup()
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, hannes@cmpxchg.org, usamaarif642@gmail.com, 
	gutierrez.asier@huawei-partners.com, willy@infradead.org, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, ameryhung@gmail.com, 
	rientjes@google.com, corbet@lwn.net, bpf@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 539AF4000B
X-Stat-Signature: wenm181nyx9fro6p7yeddk1zs77nf36a
X-Rspam-User: 
X-HE-Tag: 1756364345-513636
X-HE-Meta: U2FsdGVkX18bvC9lf5K29zQvGHb9gD/RZGTareBrwk7q9AxuON96dh/ROSvnGoB+9B5dsYm8Xj9cTK2YmKnS7CePBD5bjycuypl4dhm7Vo/2imz0W/NKGlX2I1v/CphRPi1KaC1TyFVEwY4FBgwki+T+OQ/WIC4b+/k7zhMUjB7YcWO6T2FdABD2zdRln8XeUZ81/ytoa5uR6o+Vh0rTSTxK0W0bwA5hbAm9AkwF2g3rvKonnv5br5wMzPoWZ/AfjpsgNAtyrxi29Mhia3YLn6PpYDQzIAJe3NiCE9wnYXuAstO8hmMMfArXUwtw5X4OO1zCq7ZREjJSHX8L35ssDFns27jERdzdi4dTkvV8ioJ0xXItpBA3GcHRHYWZ1DszviNbDIMkbRlpG+AuyGcgrWdVe0h9JkXm7AAc6huByOJkOYtgMyl7lHc64qxZbr1DLnocGmJpAC7KZ7hvNiJdr25uaT3Z2tfJ9XHxZO42vphRw6zpsDVHqGdRxoSS1+WnQXPAvTzggv7S6yFG8KI/W2vf3TyuyPopaCL02GYUepY3Fh1Uby4nYMc80R84jgXn+9ApfxDp7u0E07U9+hI2MAxc2ezm/jn9iGt3Vkn+yJkts/lSh4uq3pljYCIy1pPovXwFLyH03iHVt5rfuCFpbBjFpw7GExHgYPqT+c8AVeVEPRiqQtDrQaZurdcru9GxB2AWi03PQkeSuSBtw05q+GH2Md9W8QySWsmUzN1K4Le/HGPLhNCTKjjI4GMX6DgNZx2i9Zr350ERC0je8YWNgpFnAfBzWajPAQ+dUp/TdvNk9f2DZdB1URCHCCSIIDYiUvjK7auEI/AmioH6jV6JIJcr0s3nCtWb3Py9ojU5ZV+RPQO0BA4r8U7lEf5PrIKwFxil9roAhC03xcc0Vcsf64VADRjjgPIZeYHvjGlyiJDxaotDHGGcvJlJzr3CcF4lYG3CgyvLYAYMPCkqaPa
 KgRCxEhG
 LprkLevYVl9h1iKAgpYV4qj3cKIs5ttPKcQoEYZ9YvqYmzHzB1Znq3vEOtrvNehWfiSiQt16iVGP4frKv6yWCMN3NmHMl2D6hzewCmQR4YRgPHft0pbaHV2eSVnk1lhK4bVCo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 4:46=E2=80=AFAM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Tue, Aug 26, 2025 at 03:19:40PM +0800, Yafang Shao wrote:
> > We will utilize this new kfunc bpf_mm_get_mem_cgroup() to retrieve the
> > associated mem_cgroup from the given @mm. The obtained mem_cgroup must
> > be released by calling bpf_put_mem_cgroup() as a paired operation.
> >
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > ---
> >  mm/bpf_thp.c | 51 ++++++++++++++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 50 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/bpf_thp.c b/mm/bpf_thp.c
> > index fbff3b1bb988..b757e8f425fd 100644
> > --- a/mm/bpf_thp.c
> > +++ b/mm/bpf_thp.c
> > @@ -175,10 +175,59 @@ static struct bpf_struct_ops bpf_bpf_thp_ops =3D =
{
> >       .name =3D "bpf_thp_ops",
> >  };
> >
> > +__bpf_kfunc_start_defs();
> > +
> > +/**
> > + * bpf_mm_get_mem_cgroup - Get the memory cgroup associated with a mm_=
struct.
> > + * @mm: The mm_struct to query
> > + *
> > + * The obtained mem_cgroup must be released by calling bpf_put_mem_cgr=
oup().
> > + *
> > + * Return: The associated mem_cgroup on success, or NULL on failure. N=
ote that
> > + * this function depends on CONFIG_MEMCG being enabled - it will alway=
s return
> > + * NULL if CONFIG_MEMCG is not configured.
> > + */
> > +__bpf_kfunc struct mem_cgroup *bpf_mm_get_mem_cgroup(struct mm_struct =
*mm)
> > +{
> > +     return get_mem_cgroup_from_mm(mm);
> > +}
> > +
> > +/**
> > + * bpf_put_mem_cgroup - Release a memory cgroup obtained from bpf_mm_g=
et_mem_cgroup()
> > + * @memcg: The memory cgroup to release
> > + */
> > +__bpf_kfunc void bpf_put_mem_cgroup(struct mem_cgroup *memcg)
> > +{
> > +#ifdef CONFIG_MEMCG
> > +     if (!memcg)
> > +             return;
> > +     css_put(&memcg->css);
> > +#endif
>
> Just use mem_cgroup_put() here.

i will change it and thanks for the clarification.

--=20
Regards
Yafang

