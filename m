Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 768B4E66886
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 00:50:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8B8D6B0096; Sun, 21 Dec 2025 19:50:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D629F6B0098; Sun, 21 Dec 2025 19:50:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C61836B0099; Sun, 21 Dec 2025 19:50:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B1B976B0096
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 19:50:01 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4723F14097E
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 00:50:01 +0000 (UTC)
X-FDA: 84245275002.16.CA09B9A
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf03.hostedemail.com (Postfix) with ESMTP id 42A9E20002
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 00:49:59 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aN25Td3I;
	spf=pass (imf03.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766364599; a=rsa-sha256;
	cv=none;
	b=kl/EFffIpNGfhmV0WIxs1LwaS9JLU/qCnsYd9/ep5N4tJbcxXr1Q8OVtoFAy4qzIYrCJtq
	3/qkCNliz6hR8OE63nZPYtisrE2mFYtJuyrXRL7ccrU3AWb9cUFgMYaEMiT3/ri2r+UmGc
	apnQOUg/R1JIY6s+AuOszRHF9feR8ZM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aN25Td3I;
	spf=pass (imf03.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766364599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TvznF6HkFTNiIhI7+tVTU2N5AFcUAe/pj6zJRL8S6bo=;
	b=7ms9uCWxQmxnosYIcEm58zHykRBOdRFU86t8fDl2zqA4gNu3Ub0/x61cwIHwWaAuQL80/N
	MmMUyyHQDEXnGjVs7CUeCRJL8CynfXZ11NdrUDUJ7mRWEIZ59LagqG6s9DymFbJtNZd5e7
	Kosa6xnyJX2ltdG0IRSzW8H2ftFfhSk=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-42fb4eeb482so1698174f8f.0
        for <linux-mm@kvack.org>; Sun, 21 Dec 2025 16:49:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766364598; x=1766969398; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TvznF6HkFTNiIhI7+tVTU2N5AFcUAe/pj6zJRL8S6bo=;
        b=aN25Td3Io3Anp7RJIBwqOFwAOcZEK9rUpXevej96+MA7+IvG662mmjxHGvDE/Nt/Gl
         oCr3wiAkgjb7dZiX5m9Bjq4ZrZkW0ICXSTf6EyJZR/36PsKpZD++Wjm3G+CZJOkE397o
         FDUp+hMEwznC+XwfI0x4hCP1r+0rt0VlFiiGhFzgWRmDBoFGK/BGXoQqYdKoo+NrQxX8
         /8XJ8NcBIceRKYwxJiVzl80agg9j1/5NJGoENavOfNvpWSFAEAYyz0155A5PqFVjURIy
         W2l2Rh3a9SteXZIG+DHUMJTx97rQCrMN8l+VyculEce8uF7rciJgdxD6K91F2aOem9yX
         LfuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766364598; x=1766969398;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TvznF6HkFTNiIhI7+tVTU2N5AFcUAe/pj6zJRL8S6bo=;
        b=k/aNCdHs0/8Hq1pXgs0eZdwnFULhw/nKzKkN4bGdCH9NIBYn/TULff4V1Qkc+6X1Uh
         0iuQAA/2XDolAx0ze7tMQnIl0WlIGcSiDWSBXFJTjFqlHZBkd1LAzS3bspx2BXYnsGnm
         Sjk4r9RDT9sRVDt0KLB+5IhyoXvcgsvu/ROqPgV7xiipINVyGBHZrHlqIIPHraPQeejf
         X0zDKDd0PMxdIeOEdC6hTJ/BxEoJ9dYK82DMoFu/rYSTwMLMtr9scXj3HXCZAzvmu/rx
         KRwskSVoC+uzaKFtG+OtRBIl+BwvrUhUt06QOr4y5eOg6MEYSQdSDJctkVhoOL9GmHvH
         UJ0Q==
X-Forwarded-Encrypted: i=1; AJvYcCUTL6N1Jh8wD6913Q9NiXxf99yu+FPNYGGRbSIh43rtjIgZkXR7S1rOTMGnjlXH2GOYGnlNHhIHww==@kvack.org
X-Gm-Message-State: AOJu0YysM4tGRWxw7VU4GXCd4KZsHoGund1vngcFYj4HgDd6V6fsh6HI
	Uy8FV6exViQ4iaZ71Pls7r/3KzTEx7KCsAkEy+jtrAq6PzXqbvhJRBH4arPYW2y9XjP2ey7sKVQ
	bwNjNtXOZGYtwyJWfBFjamoRSX7F2PV0=
X-Gm-Gg: AY/fxX633AJu67o1KYhr8x7ppIw4UFB9OCfCBQBExvxVxV1wshyWQynCihXO21OzT2K
	VLvW23ZP/qtzpx9cwcuEULbhh5uLCbkbI6vOt9GbTB4xCEWFMMeSSU7T13kB3jxa/IH6vPSln75
	JXL8cMHucAZpc5Omd8BK5m9gnHCYtJXlgboRggyBfFlN7He91hypXg19Kj5KyQt7WM4W6w07Fnl
	z24AKxaoKMNc4ivnKjlnDysRCygHDdIcBluaO0cjP4hgNOPZdbf4gOKRx0ghPU2t7fiQ01s
X-Google-Smtp-Source: AGHT+IFLLpsgIg3SMML8wyV0yyIqH9wAeaX6ob4SNQKIJd/JePJVNtDM+7GlyvTtPFOIiSc8UyCFSuUqjpROnExh3eE=
X-Received: by 2002:a05:6000:2305:b0:431:316:920a with SMTP id
 ffacd0b85a97d-4324e4c1519mr9448273f8f.8.1766364597604; Sun, 21 Dec 2025
 16:49:57 -0800 (PST)
MIME-Version: 1.0
References: <20251220041250.372179-1-roman.gushchin@linux.dev> <20251220041250.372179-6-roman.gushchin@linux.dev>
In-Reply-To: <20251220041250.372179-6-roman.gushchin@linux.dev>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Sun, 21 Dec 2025 16:49:46 -0800
X-Gm-Features: AQt7F2pVDUwMoKC5RqsFan_45pu3L1tkLo-R88ZJb38eQ6Ir4uJa8xcwJuj8ZPc
Message-ID: <CAADnVQJo3HspB9-_R5yWKWLdExDmFayDpNZ4JnoBpCw6aRNTrA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 5/7] mm: introduce BPF kfunc to access memory events
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: bpf <bpf@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, 
	LKML <linux-kernel@vger.kernel.org>, JP Kobryn <inwardvessel@gmail.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 42A9E20002
X-Rspamd-Server: rspam04
X-Stat-Signature: pzb83zhdsnpohjz4j18sr4arhq6paknk
X-HE-Tag: 1766364599-131353
X-HE-Meta: U2FsdGVkX19XOK5wEgoCd9JpOteKoebwm4hhutM4Lng0Jb5fTEbtMVKowdaWX3sia6py6s0ENlUDPi779YhiLWSpsguR53UvQv4S7k6ihuvCYXS4sXDJeJWVfu6ANEWk6Z9rS53lcouzeMADDv/LEMIT+dwmD8delBxjFdBmAzaFwKTtoRrbQL29CjSwiEvHCwgo1yiiE6IWuOOarqAyRIHJnudiN9LtXjxBxb6OjhLF3eTGcZ+hFaqydDqhxYAhb4wX5ulKA0otPF5IgRf7jKGdRlAQx2QrEdAIMXa5AIEa7wDa05ctftpiu5UqUweBIY9+22E5V7hq8mVai5W1c4MBiBFcvag8040W6+wQKuxbdQB95ipOFJ5oyGmPmpygxa8izgw7BZIfqbi/SL75536+NYDVSm0AfYZ4pamYTR6yuQbafGhPnjHJrsHYPgRRsPZ6NTENHk+nMaK7oVnnx1Q9gLrXQLQkPS02j4RlbodyCH8hHlYDzVubj18xBxcHJAOqXC6idArpG/Znl4Y0gfcN9tIH6Qj91KFggYK16z0OTAE7lBng2IcPnEda7JrTeFf81TkwjF9djtDTq6rnfXPRwgCn3Esk+0ng6TGLF6Zv1wGyXyRKwoJAjEkk2Mg71UjzlZ2XHE8M0mxcOet6FWWEj1jH9xA6hdyJZFH6hHf6h5YSVze/RWwfwXs8fQXjtsbbg1PLglqZnKOudADzUbQJh6j2uYVk5Z87P8E7G8e2xlOWZDF+QArAcDXWOEVe+SM6Ye+yzIfPjmyxWgvlAxg0VEPs3pQzJB+bs7hHyGI5avdsFYVECcQv6CnCgaL78jsQ+zAR1tA8GK+QLht+ABbUt3f3xTLbjP8quSQBUDrVZ1Mb2xxefc1e2ksSsVS1AISpOf4Rin7lqD0M0NyG9UP5pskzpclh4XlwiZTSLIHQXNM23slDlodww1nwINUi6Q9dY+xJtGglUgEtGM9
 dXPtcqDF
 U5yHxqG+zKj1/XpBN2WavY3VrECuj0uQMMbXHYtcD7sQBdjwZk5VlPBZ2gCOGRLjIAZQlSmpoOUvf0XOurcQ8JCt9LDS92L7uoDkNQ4dXtwedwpvdo1qGWbMvGvnRMUius9YGO4iFt8YAZW26qsCdLHZpNpSPVt82mL5BvOlBT+mJ9U4AnHpHbZy4YLYsKDMbZYNWOEu/pfrnSZqSLHFtNdSJGxspVdZYp8x6ItWeYPvW8wb8f/F21ER2CL3Eg3OFprytSHz7e9KMl1oX0Q15/odNLBOyFtdA4JSfejzGBnwnHL/hifnCOIs3d1odlxxR7uFLRMkfDfUC46I6juctkD/uN0D7f0BGDJrHIua0MNohR/QFefpYhVeKOdVUllAUaaCoJBVqedctz4Qa1AoJpYfBkGtZM9rpBO4cbXMeB04sST7CMFl5ukz6s6c0xciT3Gzj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 6:13=E2=80=AFPM Roman Gushchin <roman.gushchin@linu=
x.dev> wrote:
>
> From: JP Kobryn <inwardvessel@gmail.com>
>
> Introduce BPF kfunc to access memory events, e.g.:
> MEMCG_LOW, MEMCG_MAX, MEMCG_OOM, MEMCG_OOM_KILL etc.
>
> Signed-off-by: JP Kobryn <inwardvessel@gmail.com>
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---
>  mm/bpf_memcontrol.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>
> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
> index d84fe6f3ed43..858eb43766ce 100644
> --- a/mm/bpf_memcontrol.c
> +++ b/mm/bpf_memcontrol.c
> @@ -103,6 +103,22 @@ __bpf_kfunc unsigned long bpf_mem_cgroup_usage(struc=
t mem_cgroup *memcg)
>         return mem_cgroup_usage(memcg, false) * PAGE_SIZE;
>  }
>
> +/**
> + * bpf_mem_cgroup_memory_events - Read memory cgroup's memory event valu=
e
> + * @memcg: memory cgroup
> + * @event: memory event id
> + *
> + * Returns current memory event count.
> + */
> +__bpf_kfunc unsigned long bpf_mem_cgroup_memory_events(struct mem_cgroup=
 *memcg,
> +                                               enum memcg_memory_event e=
vent)
> +{
> +       if (event >=3D MEMCG_NR_MEMORY_EVENTS)
> +               return (unsigned long)-1;
> +
> +       return atomic_long_read(&memcg->memory_events[event]);
> +}

Why is patch 5 not squashed with patch 4?
I'd think placing bpf_mem_cgroup_memory_events()
right next to bpf_mem_cgroup_vm_events() in the same patch
will make the difference more clear.
For non-mm people the names are very close and on the first glance
it looks like a duplicate.

