Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEAB5C2A072
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 09:13:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39B8A6B0107; Mon,  5 Jan 2026 04:13:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 387AB6B0109; Mon,  5 Jan 2026 04:13:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28A5F6B010A; Mon,  5 Jan 2026 04:13:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 174B46B0107
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 04:13:10 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DC1949E7E7
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 09:13:09 +0000 (UTC)
X-FDA: 84297346098.29.DECABAE
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	by imf30.hostedemail.com (Postfix) with ESMTP id EBE938000F
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 09:13:07 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="M/ItJm0E";
	spf=pass (imf30.hostedemail.com: domain of dvyukov@google.com designates 209.85.208.171 as permitted sender) smtp.mailfrom=dvyukov@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767604388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F/EBXTEtpM/Dxd5GFiILVJe5/gXQsTRvK+VB6VyoCz0=;
	b=nPF0XIllY3ub5Txx9YRzU8hXnFk3TLXsHUinke14wNnY1Yqnuji01y6GwSI9T49XF0s7e+
	Jefly0ZacHIYNP8oMTvWGHBqsgW1STOIvqARDPaZwLL7WLBpnVV5q7NupYYXVIoeKaSLvi
	m17C9u8Y02z2e2rcAXHgjOuSGtp/t2w=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="M/ItJm0E";
	spf=pass (imf30.hostedemail.com: domain of dvyukov@google.com designates 209.85.208.171 as permitted sender) smtp.mailfrom=dvyukov@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767604388; a=rsa-sha256;
	cv=none;
	b=IW9UcLiZCdi0lxe93sHf9PT/i28rFvIn9UNGw0z/TS1GtEFyQn2FNRSrczKZr4wWqgt3qV
	oAW72prCQtKsmwb7Lk6PbzdpwTUQC/Fge0C1H1mMPQRShmfnubH6CULncTRJ8Fi5smgRjk
	u43xFqq/yrwB9ptJP6kRYD8ibcgU3Nk=
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-37d96f97206so103674591fa.3
        for <linux-mm@kvack.org>; Mon, 05 Jan 2026 01:13:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767604386; x=1768209186; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F/EBXTEtpM/Dxd5GFiILVJe5/gXQsTRvK+VB6VyoCz0=;
        b=M/ItJm0EKnHlQ4P0rQSOxOx3lD2bgGJA+XcfODqggNk5T8ZeBVFetgA4EbffPpWygk
         aQDn/tm3VITtsP0GfwDz9YGIeA45ukpsCKv9pT+8gwOGrYKuatJXZsuXFhV49kOZn8jN
         bhBQKmCUHvUnjFfqauDhPL9+mGrmByj1xlKIuit8NNfAQb5/WaFnqX9UvkNJD3lxOljX
         JacIQDY/Jvt9unOA9/PWzRbuLwpKW1mA9ED1ZlPbA+ygJ5KCQWCWCS1TMrD4lRRm6Pqz
         td4knuxyCgKj0V6NQ02GG3iIbfOhezan6LnLIFJ4I7LVccllZxPLsxdSCElQ2605+W4r
         9ZyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767604386; x=1768209186;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=F/EBXTEtpM/Dxd5GFiILVJe5/gXQsTRvK+VB6VyoCz0=;
        b=g7zy6S70Bx1rNP4NH38WsCOnYkhWtkh3ZJJkDKFS02kg6lfoyKAwhOaacQBJx5garG
         ORwLRk6dIlSNDbGtqymhL9FanRNSCVKLWI+vLQpiy2DyYyPNspbQsnZBZ2J0i0AQNMO5
         C21l1CxK5WC+MeCRjRXi+s4V6DVXMHK/G2Uh4Xp2nhLuqSAvdwVZQeuiIL+hHe2yMce7
         mzyTmk3H9ihc9DH30g2lLZQrSQv+Aiv0shpKvTd5rMhf68/ATgI0HZZ4jltGmyPqA0sr
         tsMR2fJCy7uDm1q5Fu6HMbh0LcF+vFl+orgUhadw81BChjB/8x0ZUUNCOkx/tqj4bigj
         MXpw==
X-Forwarded-Encrypted: i=1; AJvYcCV5v6c8cTpbAMYMf1PFKxWDPVoht+xmHrsbjz6N7IqodPyjuf9WGcxTkSOy4eGBoMxfxBywcxOxEw==@kvack.org
X-Gm-Message-State: AOJu0YyA6gK7PcDf0kpCPc8zX6aS0peiaQOuuk68wkEAQtQvTnVTXSPp
	U7gGLjt+MWmi89twZXgONe7JxZwUYzc1L4TdPLamlCou+GEakSS6Ycl4nfBuUje8QD3ZVKgo/xj
	QcaU9UUKioblgNq7BCoJEf2/LKk1vtOKmCZ7kONsd
X-Gm-Gg: AY/fxX62GKfzLeS2MwB/eeGPAxVJo/57WVyeN7tKELCtmEQFyLbOazVOb9rpb+crZ9S
	4W6MCn9xapL1rae+uETf1dhJTvVAIrkIGOHm597IHs6jtTAKgX/DaD4P4Is16umt5kKDmMXn8qS
	icHnu6xsP1u/zE+Oh67iTl8mkSCW9kkmOhrf+zRRWyCfAMTKrysystkCvU0USI2VXgxer/xYejv
	Dmwf3Cd829AsgHOi51J2XaEa7FzxDLTkkjq294lQyYXyNOQ0X0GRZfxeeNbsbdsO/SI9YS2MmpB
	GpCORhzc7WAllmYWB2E11uKBLFfD
X-Google-Smtp-Source: AGHT+IFiwPmLAbxVEiMIsgTD7R4M8/yJfu5iEsnuABhWlORKvNAMGFn2w+wpZuYTdbiT9OhJE0cyVwDb1Xqqtptu4SA=
X-Received: by 2002:a05:651c:1507:b0:37f:aad0:4082 with SMTP id
 38308e7fff4ca-38121318ac9mr138882791fa.0.1767604385740; Mon, 05 Jan 2026
 01:13:05 -0800 (PST)
MIME-Version: 1.0
References: <7ng6tntadu62ls32r54aetyevgbghta4oufyzxtq5ym6bprjai@hc2ozb2mbcyb>
 <20251224001617.45293-1-21cnbao@gmail.com> <9bbc1962-5f6f-4e3c-a672-d80565aa5157@linux.alibaba.com>
In-Reply-To: <9bbc1962-5f6f-4e3c-a672-d80565aa5157@linux.alibaba.com>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Mon, 5 Jan 2026 10:12:53 +0100
X-Gm-Features: AQt7F2r87goJtE9t0ZPcJS4d-8mLdcXWw97ixphLOr9OAlPWILnqmxPWi9aIHA4
Message-ID: <CACT4Y+bjP-3L8E2+3tZ3F37W-hjnz5Zhb5t+fcaAu1NYferr3A@mail.gmail.com>
Subject: Re: [syzbot] [mm?] KMSAN: uninit-value in swap_writeout
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <21cnbao@gmail.com>, pfalcato@suse.de, akpm@linux-foundation.org, 
	bhe@redhat.com, chrisl@kernel.org, hughd@google.com, kasong@tencent.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, nphamcs@gmail.com, 
	shikemeng@huaweicloud.com, 
	syzbot+178fff6149127421c2cc@syzkaller.appspotmail.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EBE938000F
X-Stat-Signature: quui6qd4qtytfp8d4u3qt3p84ikzk95r
X-Rspam-User: 
X-HE-Tag: 1767604387-251692
X-HE-Meta: U2FsdGVkX18+QfVivlClnfHCI32TtGVEB/z2s6W7hW8y8mZfU2nhCKiDco1/vYaQ4dgE8vycR43MtsewhrPHdmMmgH/4R5oL7nZwBsojbvMD4M262hDXBXZ1gLXXSDCA6dFrhoux6LFhiNLN/DYgPN7TvZ/D4TJTMQYWsya1kLIYbDqw4QZ7gaf74wqc4t5U0QTRXcub0abof7sfv2f2iFWHH5tWliZdhWMe01x5DUMBflhwg8mVKtNjno3NeGai4eX/zdIflEW88Fb/uPunbyMcB28Ejw2GqJ0KwjWpQ7ddsm9CKHpDZs5WIPoRfM876d/WxOkiZ3s5s/tSNwccNbVWCr8ADOvbLSAcivnhz9QFEIBc6n8GNrbd3991bxiSYUxxvWukVX7/ZL1Tuf/hdaDpmbGVRYdQ5qf3agMDcNAQsCZFQiK4cfNwPNyYl/yspmVBgAxk1SJ9maAWgv5ivnhjvcifyQ1UAopbYncGY/NSkySikxPXZIOyIRpEL8IzAesCFqJM3dkvrvHiCgQ045N7wvlDM9UKt0V950MuobWV+UPNEGDg29ShYdKmznbI+cVG8+eFhPKRbAzgQqZiTWD2eLGBW8dcqZGYx0nIx0c8ph/fl3NXf4cu6Hhlz9QvYlxKE2TBckI+O1Qgy30dxVabJbX+4SbheaxMjafROV5yqefhZ8dSeAwq9YIvcFw+2sUu3I1OKOTMwrV3gPV0Vd0e/YfDW/fL1QWX2Eycf+nEVw7Cv3pUeLPnDUMkundEs0eBb1tTfF6DR1yRC+rnq+5acECT5Y6yTk7ej2ZkaujL5g6zXcidMp5r8NQ/3bkBJNznFARnfkobHOYeQ8nLGaBCewaoBr8HOTwJweitiTJ4j753dJY0hpq278lOOZb6Mmf8JEKFNQIljjSv91ryhWx9f43STjQZr7G6lherOLYUX8UghAsQ9A4BBISMBXbAKWbegApLUXMH1wuADB6
 oW6Cdd3q
 hWIXeQbLFHQdKQnWHfzRM6EJ0brjEwCqiQWGatb4JRx79iOcxXw/4B2uuRupnRHlDrd8U3rwEEkbnO9Ln29ZnczAVXCorNDczYkc+4DYsyByradQKvVMtWI6WnwZi5V6RtugcDPpVeCZ7WtFK6gUBdBu1jYNTKeH5/0jtn2G7w3mblXmvwNwWf0zbJPKH1fdpVgi5OYu33MCxvrwmkrn3nyBaqDIfLSs+velSHLN9IcKjsx1oALNnOHQqyHyoSUav39i1aJFaXarnGF1NHXTDF+XGWuOo6R1TcPB4YRhb07ik8zZvk/G7qRRTMRrd/PBX+1cdBGoZs1iWJKN906M0Rf7+q5vJOaUEijmT7QuAqm34ktBS0fI1EyUz/WCQF2/RmDlzD97SoVLckhbg5aIduzAYqXIaG2a1yrMdCZZKh4nIwwbUCwBgKAicjEEKOe6PlEyTxnuJtLvT9eke/mBwSSvUN4P9iIKBQJd/uQ0yhACZ7wKXWl0Vt4N4tl9XLJr5KtRyMPRnBrKjhK4PyL3yDvjT2OlBRYMabIbF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 24 Dec 2025 at 02:43, Baolin Wang <baolin.wang@linux.alibaba.com> w=
rote:
>
>
> On 2025/12/24 08:16, Barry Song wrote:
> > On Wed, Dec 24, 2025 at 12:43=E2=80=AFPM Pedro Falcato <pfalcato@suse.d=
e> wrote:
> >>
> >> On Wed, Dec 24, 2025 at 11:46:44AM +1300, Barry Song wrote:
> >>>>
> >>>> Uninit was created at:
> >>>>   __alloc_frozen_pages_noprof+0x421/0xab0 mm/page_alloc.c:5233
> >>>>   alloc_pages_mpol+0x328/0x860 mm/mempolicy.c:2486
> >>>>   folio_alloc_mpol_noprof+0x56/0x1d0 mm/mempolicy.c:2505
> >>>>   shmem_alloc_folio mm/shmem.c:1890 [inline]
> >>>>   shmem_alloc_and_add_folio+0xc56/0x1bd0 mm/shmem.c:1932
> >>>>   shmem_get_folio_gfp+0xad3/0x1fc0 mm/shmem.c:2556
> >>>>   shmem_get_folio mm/shmem.c:2662 [inline]
> >>>>   shmem_symlink+0x562/0xad0 mm/shmem.c:4129
> >>>>   vfs_symlink+0x42f/0x4c0 fs/namei.c:5514
> >>>>   do_symlinkat+0x2ae/0xbb0 fs/namei.c:5541
> >>>
> >>> +Hugh and Baolin.
>
> Thanks for CCing me.
>
> >>>
> >>> This happens in the shmem symlink path, where newly allocated
> >>> folios are not cleared for some reason. As a result,
> >>> is_folio_zero_filled() ends up reading uninitialized data.
> >>>
> >>
> >> I'm not Hugh nor Baolin, but I would guess that letting
> >> is_folio_zero_filled() skip/disable KMSAN would also work. Since all w=
e want
> >> is to skip writeout if the folio is zero, whether it is incidentally z=
ero, or not,
> >> does not really matter, I think.
> >
> > Hi Pedro, thanks! You=E2=80=99re always welcome to chime in.
> >
> > You are probably right. However, I still prefer the remaining
> > data to be zeroed, as it may be more compression-friendly.
> >
> > Random data could potentially lead to larger compressed output,
> > whereas a large area of zeros would likely result in much smaller
> > compressed data.


> This would be an unfortunate way to fix it.  The vast majority of
> symlinks are short, and we'll never access past the \0 in normal
> operation, so we'll be dirtying a lot of cachelines essentially to (1)
> shut up an automated tool and (2) optimise a corner case.

Won't the uninit data end up in a swap file if it's not 0's? If yes,
isn't leaking crypto keys to a swap file a problem?


> Thanks Pedro and Barry. I remember Hugh raised a similar issue before
> (See [1], but I did not investigate further:(). I agree with Hugh's
> point that the uninitialized parts should be zeroed before going the
> outside world.
>
> [1]
> https://lore.kernel.org/all/02a21a55-8fe3-a9eb-f54b-051d75ae8335@google.c=
om/
>
> > Not quite sure if the below can fix the issue:
> >
> > diff --git a/mm/shmem.c b/mm/shmem.c
> > index ec6c01378e9d..0ca2d4bffdb4 100644
> > --- a/mm/shmem.c
> > +++ b/mm/shmem.c
> > @@ -4131,6 +4131,7 @@ static int shmem_symlink(struct mnt_idmap *idmap,=
 struct inode *dir,
> >                       goto out_remove_offset;
> >               inode->i_op =3D &shmem_symlink_inode_operations;
> >               memcpy(folio_address(folio), symname, len);
> > +             memset(folio_address(folio) + len, 0, folio_size(folio) -=
 len);
> >               folio_mark_uptodate(folio);
> >               folio_mark_dirty(folio);
> >               folio_unlock(folio);
>
> That looks reasonable to me, though I prefer to use the more readable
> helper: folio_zero_range(). Barry, could you send out a formal patch=EF=
=BC=9F
> Thanks.
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-bugs/9bbc1962-5f6f-4e3c-a672-d80565aa5157%40linux.alibaba.com.

