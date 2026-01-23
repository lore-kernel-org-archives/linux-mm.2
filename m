Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 212F2D74EC9
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 13:24:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 147456B04C5; Fri, 23 Jan 2026 08:24:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11FA76B04C6; Fri, 23 Jan 2026 08:24:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02B8B6B04C7; Fri, 23 Jan 2026 08:24:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E5E1C6B04C5
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:24:41 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8472E1A02AD
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 13:24:41 +0000 (UTC)
X-FDA: 84363298362.08.36C414D
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	by imf26.hostedemail.com (Postfix) with ESMTP id A122A140008
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 13:24:39 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LLOGfkYg;
	spf=pass (imf26.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769174679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DuGHsLpdvrQaNLUamOe8zWzhYMbQRAN+arTRx+eFXHU=;
	b=YJtyk71tGR1dlPYz8igUkg+z6L+uMlE1IbDIbXHOCnkzKv2eUlR3jOkJyPyjv49ZSrn3OL
	wgYnhTmaA2Dy/D8i4lDY985Be0OGeBvzndjahsFT9ROYegeKMu45/ciL0ZFtSfYahQfuZi
	/3pxvLOwr+awlJ4NnmNH1mxRkkrO+60=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LLOGfkYg;
	spf=pass (imf26.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769174679; a=rsa-sha256;
	cv=pass;
	b=nL8XqedALYt4BXtlRS3JbJAdOAl1rtpxWsgUjp3hnFGr4kCQqeFmwaY6yQAHH2uPc7F8EH
	p5TI2WkfJRYOKnRLPzevz0XdlXISq78suz0rulkRD8lK+fGmXYc94hFChC0GES5L0qcNJ0
	gJc6l/o81ZhlJgZreiUPWTyo+hMaSYQ=
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-59dd34f8120so2711016e87.3
        for <linux-mm@kvack.org>; Fri, 23 Jan 2026 05:24:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769174678; cv=none;
        d=google.com; s=arc-20240605;
        b=NO0m3kJyreCltDyWSc+HY6LMielbHn9YmQri3BEyS3Zqa6gIjyrwXZyXg9GKzFnK+V
         5PABJ3UFDkn46HpchR0k2nkTvWSrf8JN3qmMbMgPiN2kOWM5svb7T1XuL2FSwWV36/O4
         PgK4e/eC5stJu23mDJvTnlOR010NHjh9GW0G56UIRpiBOPcdHVlN9B9u10EoQyhfO8Pk
         Mx4I/1eHGbTWX8pplfjYRRGQJM2aks+gDLFE/h7rlzySqUW59wVQ3jmlnbVZfESHMBWv
         bV+2hRRu/r+MmmKnog+UK39z+mp+DD6zhhElNoaojGIr/yFVcuyxwzBIAgxhs4WSJ2Gp
         bEfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DuGHsLpdvrQaNLUamOe8zWzhYMbQRAN+arTRx+eFXHU=;
        fh=6zZVlGqtgjrThEOqZvLvxNcSDOc/VFJiz+VTNoygkc4=;
        b=SO05wcLl5lGz3JIiIgi4HugZM0lhfaKVAxJ+fNzvZKbyIl9WXnGUlt3d831pz+lAJX
         1cxRpFclZvmeP2QEIe8Zadt1JcMAwn+ZSJkNTzVsFTOKLchvfMeAOuFAFs0C5jyJ0hYt
         U59uqJ4HT1SkP9+BTHy+6hH1YlbN8SSArtb2SJJ+wNZa/vtXWd9Z3phjzeB9/RNv97ny
         k+0kvKye0vK0a9c4KIYYgGqgWHQyTTIOpD5x4kt1oRRblw/fvmLoYZlL/hZtSOXVrGAC
         FHF2NMLjlva/mI3ykXg2dBWD0LV2sFhUPXEMHct1+NtXUsPC4OqkfVaoQytvloGmOomq
         DyQg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769174678; x=1769779478; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DuGHsLpdvrQaNLUamOe8zWzhYMbQRAN+arTRx+eFXHU=;
        b=LLOGfkYgJMnoYlYFOn9r5xk48MJwcv5Ize95K7oqg5XOwoUrWJkldXQN/Bf/BKoO24
         zv4mbSpl6zGO4EfphWDylU9QHwBMG5lsrXTmfNwek195lKKAlevLzL8005U3gDQNa7Xp
         OJd+LZYATaSzaER/oQ3J74pwXWsXK/9+4n092zYOlQc4JrWedjFDHh4GTGmahqW889Kn
         xEdBx7THXjy/HYunsegtz5u0v4gObVw0tGi9iKu04p++RSfIB34YT7gLuQnGf0+gVipP
         +SHEkMkTtjf04TMGEpL3TlKbJLi+qi6WuxuNz53FjON6bzf0bThWqZ5yZJ26cqbjQeL+
         VYEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769174678; x=1769779478;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DuGHsLpdvrQaNLUamOe8zWzhYMbQRAN+arTRx+eFXHU=;
        b=a1hXkcbV8tQCSJu/oaT4MbwW28Uk7f8C2HabJyg6ejYJQ9fHEJ4359p+fjciUoXIw3
         h599Hj2XXpQhnzpiScLDPajbF7WX8XjfiUNGZStAccRE4YwGHqT8cBiYsopdJLFlWr9u
         1O7e7KFIl9ly4wi6kzRU/wEphoaLj4N6n8BVVxPPnXvTfawqfIsNK1/jz/VE/VTj3ZEk
         cq8fgEELDLVZGMaHnF/5/TZkMOdEalSfVDWzdW9OhRVjp11zhLG6d8P7+OflLS0PNXhq
         pw7z9iOtymFQKD3KYSuujUa6GPnvRto2LMrVTVo4LYV89pszUM387EWF1D4+A8AU7GZC
         gW5g==
X-Forwarded-Encrypted: i=1; AJvYcCUaTYpiMlCg5ueIpS3ZqmjGdfPZW9jIwuv3+1LGpm3mOMKsxqo7ok8cEf8G2wJeRCEN7wXiVK0qzw==@kvack.org
X-Gm-Message-State: AOJu0YzVRR3VXEP1VZnRmmcyCYjdgfr62ot5uD2r6xZ7y7dctvltEo0j
	QP5r4eIbgVX1FZb+B7NZIGEts2F6xWOcHfAvZxsloUZ91Gvz0uYX9JjmQlCbtx3kvKv0bff7rY8
	zstBFyZn5ni+mGNiyt6A9S+FWsyMESrM=
X-Gm-Gg: AZuq6aJN1PkC9BY/yCzTnIhN5BrD1DX/vlOt795Fb53GGKzoCNxXRTw8m7pzzYO3RtO
	K9v2denwERfMumoRd2EIV4o00RM7ZIbtXxzyRDvKLPRFjPcEvB6FKYfVChbDe0ilHR4t/QpF0CH
	eHfM5VGfiOC4rvax0CDQyWAfp5U/7uIVGOenmBWoYgNMhZVZ51Z+oB4LjpYbxBfV7iuwH/wukJ8
	3qWfosDbiKdTSXZFbhKin9SqN3Yk40mN6LZOiS4ECrDL5GGlid+tacXA9o2sDs8Y1fP
X-Received: by 2002:a05:6512:b0a:b0:59d:deb3:8bd5 with SMTP id
 2adb3069b0e04-59de4a3892bmr1010651e87.48.1769174677308; Fri, 23 Jan 2026
 05:24:37 -0800 (PST)
MIME-Version: 1.0
References: <20260110042249.31960-1-jianyuew@nvidia.com> <20260122114242.72139-1-wujianyue000@gmail.com>
 <87ec59f7-2d76-4c7a-a2b0-57bc4e801d1d@gmail.com>
In-Reply-To: <87ec59f7-2d76-4c7a-a2b0-57bc4e801d1d@gmail.com>
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Fri, 23 Jan 2026 21:24:26 +0800
X-Gm-Features: AZwV_QjMT56dui_B6kAZP1oU-LmaRozN4fxC4YhZzZM1bcpR5mH3Bc7b9_YZ51o
Message-ID: <CAJxJ_jjGS39doSXGn7rxX_OmfLni=5YFwbucV7UxK-KMH937uQ@mail.gmail.com>
Subject: Re: [PATCH v3] mm: optimize stat output for 11% sys time reduce
To: JP Kobryn <inwardvessel@gmail.com>
Cc: akpm@linux-foundation.org, shakeel.butt@linux.dev, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 3r4y8eztr4hxdjnj9bsmmad47ru1ke3j
X-Rspamd-Queue-Id: A122A140008
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769174679-521407
X-HE-Meta: U2FsdGVkX1/Sd5sFvEGn9CTCQweGDQWOjz20GOR5T+XsfgCfKrptTHsqAt90XgD58jcnEcRgjGlkW8Q/ZXRynhDMa7RnzSK3xPlvVIz/iqrdh7F7Bcl0VK2Y5fDF9ovUGBxud1jCDPcC7ac8IuXcKeJkkyrRU62vi94loGDAsv2mKaE6R+ciLwAiTdPpyEEvKg4QNwyH+8cLH5mAhG6dvhNldhshPJ9WnG+bhzDe8B3sZRYteUI7CVxqBDsRYMoOFPtUCk1Qh4TBhvndUxuUicUMl8KtuVm1Wy88uPByHomO7cIXzgGTKJzHTZZeMUDiXznGruZDjLWmy/N/txKA+vRcDn9D04eTF/oy0vie9ceFtBkWVW3wt8VulcPdzkOUqBbxg3pRIwkO2Z1eOwCOTFZydHEGO3TsxzyRreJziq2vQ2GknMMFaIW25nDYVpC53qeEvY2Vb1WE2a9pQJaQvLwetcHnjy1IW2Wt5PCFXp9NZB1dvDkCUqwJ0FgrtwnePYjw/ZI1cn8iwTvRkMFH1zn3lTJu6h/0+/Rv3xy/JG5E4448CmZWnRj/gB1Je9KiszvyJ8zXYvQd+y2nO0n2WT01gqEWNUFHpK7rPWwyoLp249hnkDQETOsXEFA7UdXNEAw/2FQRPpvu6V90vz9YZnVwPbqd/iwQIEKwKHO9us4SC8pyk/QgGpUiGnuEQJuTYWG48FR5x0a8R5CLWe4lB8AQAI5H1ZPzzMhUPdK4lUQFHv3VT2I0Yy8ZUlwCLtBbxw0PxmzfzY46uyK64dWuMTEXtFhk/G/27/PM6UkNx7PJxOrRUuQ/zu+btw/PbD5BfHn1uP5xVUHH7TRiFzQ9eyOafIbX0IZUioRXIkggg5/zh8zfKZ16I5TWViC/kT8Prlk5keEC9xrFKJdDPKZmSQnz063JF+ECxBXFrmHil4cokwxV5tGcVnDNlljbLCrv1/MZ2Ghn2W87tMwMUxX
 bUAt1/Zd
 qbNqT8ZqzsbwImxnYEUUQ9/LG/3gUQd7Ug+a2TwHcCXCBIyvHx8dyk9tlBQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 4:14=E2=80=AFPM JP Kobryn <inwardvessel@gmail.com> =
wrote:
>
> On 1/22/26 3:42 AM, Jianyue Wu wrote:
> > Replace seq_printf/seq_buf_printf with lightweight helpers to avoid
> > printf parsing in memcg stats output.
>
> Hi Jianyue,
> I gave this patch a run and can confirm the perf gain. I left comments
> on reducing the amount of added lines so that it better resembles the
> existing code.
>
> Tested-by: JP Kobryn <inwardvessel@gmail.com>
>
Great, and thanks for the detailed review!

>
> There's a recurring pattern of 1) put name, 2) put separator, 3) put
> value. Instead of adding so many new lines, I wonder if you could use a
> function or macro that accepts: char *name, char sep, u64 val. You could
> then use it as a replacement for seq_printf() and avoid the extra added
> lines here and throughout this patch.
>
That's a good idea! Yes, if we use sep, then many places can use the
same function.

> > +     memory_limit =3D (u64)memory * PAGE_SIZE;
> > +     memsw_limit =3D (u64)memsw * PAGE_SIZE;
>
> I don't think in this case these new local variables are improving
> readability.
>
Agree, will remove it. Previously I wanted to keep them inside 80 columns,
as a hack:) Indent is not so easy to change.

> > +             seq_buf_puts(s, "total_");
> > +             memcg_seq_buf_put_name_val(s, memcg1_stat_names[i], (u64)=
nr);
>
> I would try and combine these 2 calls into 1 if possible. If the diff
> has close to a -1:+1 line change in places where seq_buf_printf() is
> replaced with some helper, it would reduce the noisiness. This applies
> to other areas where a prefix is put before calling a new helper.
>
Agree, I think we can add a prefix param here 0) prefix, 1) put name,
2) put separator, 3) put value. So we can use a common API.

> > +     u64 oom_kill;
> > +
> > +     memcg_seq_put_name_val(sf, "oom_kill_disable",
> > +                            READ_ONCE(memcg->oom_kill_disable));
> > +     memcg_seq_put_name_val(sf, "under_oom", (bool)memcg->under_oom);
> >
> > -     seq_printf(sf, "oom_kill_disable %d\n", READ_ONCE(memcg->oom_kill=
_disable));
> > -     seq_printf(sf, "under_oom %d\n", (bool)memcg->under_oom);
> > -     seq_printf(sf, "oom_kill %lu\n",
> > -                atomic_long_read(&memcg->memory_events[MEMCG_OOM_KILL]=
));
> > +     oom_kill =3D atomic_long_read(&memcg->memory_events[MEMCG_OOM_KIL=
L]);
> > +     memcg_seq_put_name_val(sf, "oom_kill", oom_kill);
>
> New local variable just adding extra lines.
>
Agree, will remove it.

> > +void memcg_seq_put_name_val(struct seq_file *m, const char *name, u64 =
val)
> > +{
> > +     seq_puts(m, name);
> > +     /* need a space between name and value */
> > +     seq_put_decimal_ull(m, " ", val);
> > +     seq_putc(m, '\n');
>
> I think seq_put* calls normally don't imply a newline. Maybe change the
> name to reflect, like something with "print"? Also, it's not really
> memcg specific.
>
> This function has a space as a separator. Earlier in your diff you were
> using '=3D'. A separator parameter could allow this func to be used
> elsewhere, but you'd have to manage the newline somehow. Maybe a newline
> wrapper?
I think a newline wrapper API might be an extra complexity, maybe this time
I'll keep changes only for which has a newline, places which still
don't have newline,
like memory.numa_stats print still kept using seq_printf() API.
But not sure how perf gain will be, I will test in the next version.

> > +void memcg_seq_buf_put_name_val(struct seq_buf *s, const char *name, u=
64 val)
> > +{
> > +     char num_buf[MEMCG_DEC_U64_MAX_LEN];
> > +     int num_len;
> > +
> > +     num_len =3D num_to_str(num_buf, sizeof(num_buf), val, 0);
> > +     if (num_len <=3D 0)
> > +             return;
> > +
> > +     if (seq_buf_puts(s, name))
> > +             return;
> > +     if (seq_buf_putc(s, ' '))
> > +             return;
>
> Can num_buf[0] just be ' '? The length would have to be extended though.
> Not sure if saving a few seq_buf_putc() calls make a difference.
>
> > +     if (seq_buf_putmem(s, num_buf, num_len))
> > +             return;
> > +     seq_buf_putc(s, '\n');
>
> Similary, though I'm not sure if it even performs better, this call
> could be removed and can do num_buf[num_len+1] =3D '\n' (extend buf
> again).
>
> If you make the two changes above you can call seq_buf_putmem() last.
Good catch~ Embedding the separator and newline in num_buf reduces
function calls from 4 to 2, perfect!

> > +}
> > +
> >   static void memcg_stat_format(struct mem_cgroup *memcg, struct seq_bu=
f *s)
> >   {
> >       int i;
> > +     u64 pgscan, pgsteal;
> >
> More extra local variables. You can save the lines instead.
>
Agree, will remove it.

> > @@ -4247,7 +4315,8 @@ static int peak_show(struct seq_file *sf, void *v=
, struct page_counter *pc)
> >       else
> >               peak =3D max(fd_peak, READ_ONCE(pc->local_watermark));
> >
> > -     seq_printf(sf, "%llu\n", peak * PAGE_SIZE);
> > +     seq_put_decimal_ull(sf, "", peak * PAGE_SIZE);
> > +     seq_putc(sf, '\n');
>
> Your benchmark mentions reading memory and numa stat files, but this
> function is not reached in those cases. Is this a hot path for you? If
> not, maybe just leave this and any others like it alone.
>
This path is not touched by memory.stat. Agree, will remove the change.

> > +     u64 low, high, max, oom, oom_kill;
> > +     u64 oom_group_kill, sock_throttled;
> > +
> Same, more new locals.
Will remove them.

> > +     u64 swap_high, swap_max, swap_fail;
> > +
> > +     swap_high =3D atomic_long_read(&memcg->memory_events[MEMCG_SWAP_H=
IGH]);
> > +     swap_max =3D atomic_long_read(&memcg->memory_events[MEMCG_SWAP_MA=
X]);
> > +     swap_fail =3D atomic_long_read(&memcg->memory_events[MEMCG_SWAP_F=
AIL]);
>
> Same, new local variables.
Will remove them.

