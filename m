Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58EDACAC5AE
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 15:30:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 706868E000C; Fri, 26 Sep 2025 11:30:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DDF98E0001; Fri, 26 Sep 2025 11:30:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F4A98E000C; Fri, 26 Sep 2025 11:30:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4F8B28E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 11:30:44 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1B58E1A06BE
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 15:30:44 +0000 (UTC)
X-FDA: 83931788808.11.9C26F35
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1EB5510000C
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 15:30:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ddI2DdRI;
	spf=pass (imf14.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758900642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hw0PkEDAgZJmZX4JQxCB6B2llrhkqMZatxLmc7xYfO8=;
	b=X9CUn/aoWctyEdlb6TXXSi+RB6ENR8GUBvOxM2VhAIRaBKR+AGPq+PdR1ZYE1AGyPh2XFJ
	VXOJTUWfyWC2/A9IgCPYTkCUIdufuIPwvTNijavvBmzrt4g9eMrJyC3LlaSDyJT1fc7MFO
	2qB3SgvHemqAC0wabyXoHc8fPdOhP5E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758900642; a=rsa-sha256;
	cv=none;
	b=td3oIk8Zv7lTt0kZjMEEcj26ojHkTsB103kCrmKkzG10djCN/V/qvb8SoZvqCUsrQl3iJW
	kQ1s6ZmV9xDHxaBjVMkdHYVk7TvKJr3EBfpA4/GDdT80CIKZjq15athNLACDZj977z05s/
	VLHthIRJv4ErdAFZpktKY/RjtBrPDhw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ddI2DdRI;
	spf=pass (imf14.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-45dd513f4ecso14522735e9.3
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 08:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758900640; x=1759505440; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hw0PkEDAgZJmZX4JQxCB6B2llrhkqMZatxLmc7xYfO8=;
        b=ddI2DdRIsxt2kmCQtuSVkvUYg/luVUcjKUFSL1/xBmaiQlsBjYFvoUNHmhBu8OV2Ro
         HXsyQQ/ua6RACrk9kEPLYZOLp5smi1jE2XOJ9H7HSnlzbZNe7Qa+e3U9HQzkk5zjbLKX
         GHAW4tHlTgwcpFEv9z8nMUBDJKRcasEqY0uc4dlMkeGYwSt74zRel7r47e2EvgeJpziC
         +Geb0rvBOsXAkQZxwLDZ5QVPDhNd1t/E0D3d8zG6KhLj4+hn6wScgWgSyu5XRMY2WupL
         xu6iMGGMamXtfdXXnUoJbSo/SDdWsz1OcYY9GaLWiWF7loPcrwMDGTH10YM8teUqhiXo
         Dscw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758900640; x=1759505440;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hw0PkEDAgZJmZX4JQxCB6B2llrhkqMZatxLmc7xYfO8=;
        b=TWq/s3GX52eBUquefTNic5f1w3ISVheEhQFXNymS1NqLta4L3eCP/s3XJgN9YQvuUQ
         bNZpXq/6RWakkyO+icrRu9Co5t4cF97dEcmsUzNmekJOaW69VdEe7ZzzRkq72Z3Gsx6Q
         iyvj+BJ/kCh6nsh5p22H+cv4dqSeoMPUIm4b3Ue8pBO9EzQU0H34bxCbGvvp8+hKB6r4
         hVU0A/FJGRzOd6gqdrD/WY4QKyap0Z4nLQ0ugM0glWIC5tn8x6WGuj9BuHPAS2KOFV0H
         QuL4a3FBP2IvCGoKJsjkiHrVSl2vZ3QCsKUMraFU6V1k3HQ19tQfO1T7UplyoR2wvoSs
         UfPg==
X-Forwarded-Encrypted: i=1; AJvYcCW04iI2+lxDwsbbQ/jTLb2AMHcDLgFiS1o7RkM0px4wV5+p6X2UHhk74Q0rGrIV+Cs7TaqeF3rzSg==@kvack.org
X-Gm-Message-State: AOJu0Yw8S1YE4Pf1ExezAzGjfXs7+23CIz/cqwrryU+kpL21OKHpD4Na
	+mKpEDykPhYtv9Oo0maNxCkGAI6PuZJrQQzBScVGfEKXVyFbd4IHXCbxGiRXltkHA02ymaX9lSo
	EcP0gV93NiyvIlevZdYVchB8JByswW6A=
X-Gm-Gg: ASbGncsNfx04PmQ7Df/cnYjE2IYb8Jak3INu4AqsSWJICTK1sGE4BKZQlRXarLgg9VE
	kfxM0WF80mhEHVeegz1S0sVmUOVS2vYfTY+Ci8W918C0EA4aiLP7V7kuXpCDUKN2OwDCho7hg44
	clsvCuCe6ZU7ef8uJ7B02EqU1n7F3dohS06GuiVqvnhBuGnSZfdZaXaWqpBddIVdB9hjkeGMN8E
	IORBhrG/2NQ2voDccVH
X-Google-Smtp-Source: AGHT+IHPcobe0pabmtv3LTAUxvYUa9I/tUExRRvv4KQMIFR1FB2bTWAabu9dOrWdANVnlud2d72ux6aywV+LbMiMy+I=
X-Received: by 2002:a05:600c:1553:b0:46e:39e4:1721 with SMTP id
 5b1f17b1804b1-46e39e41ae1mr38372785e9.12.1758900639846; Fri, 26 Sep 2025
 08:30:39 -0700 (PDT)
MIME-Version: 1.0
References: <202509171214.912d5ac-lkp@intel.com> <b7d4cf85-5c81-41e0-9b22-baa9a7e5a0c4@suse.cz>
 <ead41e07-c476-4769-aeb6-5a9950737b98@suse.cz> <CAADnVQJYn9=GBZifobKzME-bJgrvbn=OtQJLbU+9xoyO69L8OA@mail.gmail.com>
 <ce3be467-4ff3-4165-a024-d6a3ed33ad0e@suse.cz> <CAJuCfpGLhJtO02V-Y+qmvzOqO2tH5+u7EzrCOA1K-57vPXhb+g@mail.gmail.com>
 <CAADnVQLPq=puz04wNCnUeSUeF2s1SwTUoQvzMWsHCVhjFcyBeg@mail.gmail.com>
 <CAJuCfpGA_YKuzHu0TM718LFHr92PyyKdD27yJVbtvfF=ZzNOfQ@mail.gmail.com>
 <CAADnVQKt5YVKiVHmoB7fZsuMuD=1+bMYvCNcO0+P3+5rq9JXVw@mail.gmail.com> <7a3406c6-93da-42ee-a215-96ac0213fd4a@suse.cz>
In-Reply-To: <7a3406c6-93da-42ee-a215-96ac0213fd4a@suse.cz>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Fri, 26 Sep 2025 16:30:28 +0100
X-Gm-Features: AS18NWDPulJjeGNZJBavOvdAFs79dpLiwntGES88AId5C9cShcZs5_ox3eb1K2Y
Message-ID: <CAADnVQKrLbOxav0+H5LsESa_d_c8yBGfPdRDJzkz6yjeQf9WdA@mail.gmail.com>
Subject: Re: [linux-next:master] [slab] db93cdd664: BUG:kernel_NULL_pointer_dereference,address
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>, kernel test robot <oliver.sang@intel.com>, 
	Alexei Starovoitov <ast@kernel.org>, Harry Yoo <harry.yoo@oracle.com>, oe-lkp@lists.linux.dev, 
	kbuild test robot <lkp@intel.com>, kasan-dev <kasan-dev@googlegroups.com>, 
	"open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1EB5510000C
X-Stat-Signature: qfr4woqtm14pw9asc6s8o8foq9ftsbry
X-Rspam-User: 
X-HE-Tag: 1758900641-442939
X-HE-Meta: U2FsdGVkX18a1zwnfEtNYYCitw5pMkIHQ7V3pwX8JXY64djscKCExw3r9tkjm0GKy2daNrasZ7HcqUTGGnXz6uMVcbEReaiILP8zvO4thwtwHgSErjLqFIRxRMQTlDBuRDYbhR/i42qOtWRt/8Ua/TIxNdoj7lX2qib5xI/VQBquBZr3f5cnn9/MNnZb2oM4k1UXey7Jym1kjqVcgwEwvfYY7ciLASNHHcXsmnMBEo5GAgU+JC7FhE3mBcpvfm7KZTHoCHGr225q0cK2Ia2pforUyqPW2PW324PLPbMIHuJFn8ls44Ux/HaJ67pCW/hbcA3/AjpTU2/A1p7iqbTsrGcAzEmlNbV838r1J41uRc40w7EQKK2J1gDWHRhufiXsd4Y1pz1nvceAJnYMSH6K0IbN5TvVLgD9S1lkmBcbOK7u8bUrcGKW/zU8EBa+htEhqfGxLKAU0B/Jrq99saEeY77roUlSfYtH0SthUGPM75COk+QD4Q21X41v5fKxK22REmO95ow2y23kE+VMtT8hyWPr4aDhcuRZL5a1v8kG7jLNM/nqj/bQSg9FxABzPwWjyRA4+LZBT/E5cmH9FRxtz8F/3MosN5l9K4yhKWVCf5Y9OUAcBD8l1YGg01bK4SMJ1Jkk6hfX+XMqJ+qprj03GtzhX1IGbAiSxPSXAm2x6YA9ObuxqRLGOA6VjM556tkLowuVDP5Kw68u/a5zYS7Q4kueH0zUT0NYI2KaH+n4rvwH+4tI6yQKxJcv3dZj98sAPF5TEo2rglcsVq4k9xpQplBGnkKr2nmyQgNQu02ZD16mTzjpaVmCuWM0Z141JSTt6xZvYbTHGmTBqLLURykdo6s9b+44yqraw/UqGXxm/wXxzDo4e91LpeVATbFGb/jpHC4JTMCowfOjmpxHAxp5+o8duPFoK8OJEXfT1SMNO+YggiiIn+MUbgCDhL4LHCezEMBEfhPlKFgp8xK9Jzx
 8F6BUfrS
 /7vYZVRKd9XgofNeD7PHOX1z6iTB2mCdINpi6DuC/J6xGKVb+qyftqcygJ445JFIpzbgtuCPE6FQZyUStO3fQQfJjkVRLExW4VJcityeb8VkBGpjKEVeX0F8nLrrw9ixya1QiujrYgEB8Kq7+41I3NvpwrCHdD3dL8ahFfSSeh3DJu0Icoj1WdKij0ltRi04UhG8HI4HzDUp6S/vH1YvzIgWy91+evT7MBPKZnwf7rYIgJFJecrdm5lke0AGcDLWwimQfLa1J27SYMWkiWQN4A5RQSSNcCY/EWM/NVjW88oRWgSuQgT+sLRvsjeqNBYZp7RReTA8D0whSUm6YWEw4thlmtIkbxCVfX5pWSWKTbJ7/HnZ4brLNKVKVvSKJRZGnAqA+J8sqd++O2XHVfXCfb8F/RHYBSEMng2wP1wev74vHKqRA9PY0mkTDUKXt7MVkaoBmstSKI+MyjRY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 26, 2025 at 1:25=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> On 9/19/25 20:31, Alexei Starovoitov wrote:
> > On Fri, Sep 19, 2025 at 8:01=E2=80=AFAM Suren Baghdasaryan <surenb@goog=
le.com> wrote:
> >>
> >> >
> >> > I would not. I think adding 'boot or not' logic to these two
> >> > will muddy the waters and will make the whole slab/page_alloc/memcg
> >> > logic and dependencies between them much harder to follow.
> >> > I'd either add a comment to alloc_slab_obj_exts() explaining
> >> > what may happen or add 'boot or not' check only there.
> >> > imo this is a niche, rare and special.
> >>
> >> Ok, comment it is then.
> >> Will you be sending a new version or Vlastimil will be including that
> >> in his fixup?
> >
> > Whichever way. I can, but so far Vlastimil phrasing of comments
> > were much better than mine :) So I think he can fold what he prefers.
>
> I'm adding this. Hopefully we'll be able to make sheaves the only percpu
> caching layer in SLUB in the (near) future, and then requirement for
> cmpxchg16b for allocations will be gone.
>
> diff --git a/mm/slub.c b/mm/slub.c
> index 9f1054f0b9ca..f9f7f3942074 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2089,6 +2089,13 @@ int alloc_slab_obj_exts(struct slab *slab, struct =
kmem_cache *s,
>         gfp &=3D ~OBJCGS_CLEAR_MASK;
>         /* Prevent recursive extension vector allocation */
>         gfp |=3D __GFP_NO_OBJ_EXT;
> +
> +       /*
> +        * Note that allow_spin may be false during early boot and its
> +        * restricted GFP_BOOT_MASK. Due to kmalloc_nolock() only support=
ing
> +        * architectures with cmpxchg16b, early obj_exts will be missing =
for
> +        * very early allocations on those.
> +        */

lgtm. Maybe add a sentence about future sheaves plan, so it's clear
that there is a path forward and above won't stay forever.

