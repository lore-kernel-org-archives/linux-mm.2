Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 139F1EFB7E4
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 02:11:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A6306B008A; Mon, 23 Feb 2026 21:11:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7869B6B0092; Mon, 23 Feb 2026 21:11:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 668B56B009D; Mon, 23 Feb 2026 21:11:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 543976B008A
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 21:11:23 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C618D1603BE
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 02:11:22 +0000 (UTC)
X-FDA: 84477723204.08.314A8B0
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf20.hostedemail.com (Postfix) with ESMTP id ED4521C000A
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 02:11:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Qm94elZ9;
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771899081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eFA8Gu4szBvFtRfGkwR0vdAO1QkTVvSnODLMLCE2WIA=;
	b=nIWJQXh6knd3vUP0I7xHK/JuCZUYAj8douharv2UdovtYwFeIv/d4hUXty8qBDjkAltnOy
	sVXjVQOOUyZVfdXLxfCKiNP0uvO4nz4rOL+ElKUHfe8Zgppe7aM/2/EvNlr29Wdd96R/sw
	78OOH2B2Xzdnv0OEmgefunKu9fOAlWQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771899081; a=rsa-sha256;
	cv=pass;
	b=hgm3tQayEt3BSBKlCpImvpUEEzfvUcACYIR8I4jTno10kFOmUzsxS/EohariSYXcdfFcXi
	ztYWP4bUHHE4EdqznR4eUTMECMPEe8o8/YLQS+yQjKiO9AGAzX9F/jTRr5lXAgS9lVJDuS
	O/tlSd+chdCpSFMOyh9IlGbAcmi/PXA=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Qm94elZ9;
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b8d7f22d405so788451266b.0
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 18:11:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771899079; cv=none;
        d=google.com; s=arc-20240605;
        b=ICUbjhW8bjM+es/9dz9DO9tAc6bDsi+PPM3YFz/LNzcS6+SPU7OB54luuVinnj6PfL
         DuVYJhtH3/ZpuM+4GMN/iVLPKlBX+j8pFMR/cuQirIK7IY7XCiBOiwxxciFITZn1Iaxg
         e0uSpZ2nqThKUXXn2lHt5hB7mna9V2Tf42So7jyQDSGV0txWTsIcol9tUvy2kR3MMOMz
         g2o+G3E5RWrd3ez4cwJyM38xa/gizwNM707j6sYWmSFpnRmWimbWF+UHgzG1g7efxaAM
         tDQ+VkTdJ3Lti3WVJDilp87lxDH1YmdVJed1ZsDwn/TmIxn1lz3W+XLgP5kmdsn3hte0
         Zbmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eFA8Gu4szBvFtRfGkwR0vdAO1QkTVvSnODLMLCE2WIA=;
        fh=Ee0EWu5OSRhqKgZdPR6Yb2P3exwdnmAouUaWg7S9QQY=;
        b=YwzB1e6CXL3PhVBcqqBW156O9rm0zDvJhwhJggISVGDwzdF1E+cqlwqGHfR9kvBBX6
         44aw9ng7MGnwJS9jStgvyc22BS7f6R3XKmMi4AK7a2fIGBUYVk1W3h5K06g7QL0WASZW
         VUxqDDTn3Ew78X52kvG7lUQ3Zttry6UepVa4vYSEysbwjT4+4zzkyunQyqaTWpShUoiP
         RF4kXlq6Kpl7onhxu0CEv01tH+NOyPGI/aQs7NC07F3LprSrtGENEazj11nfBn5smOff
         RX7/DQNcswvXRtAKdD6HmI4xTasfgMjsHYO3AbhYMDE+EtXsw7IUZd7T+5nSMP2q17Cv
         Fq4A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771899079; x=1772503879; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eFA8Gu4szBvFtRfGkwR0vdAO1QkTVvSnODLMLCE2WIA=;
        b=Qm94elZ9AeL2TO9FulDBEiM67vCGgE8w3RRSS/trgrdFiTrGWJzqoSLty8aZnpdPUD
         6dMpiCubZrKcXXI0mhJMpMztmDlWWff4WacCEg7syGlCf2gqMKuEpDNaURotkJgXVHC1
         6MNpc1FkahyYlgduwaIwUscZ5rZ2OmRms9adyhrIpcHg9Vs3QG1C14PS1wmM9Ut2YD6a
         xhTBeG90LgDmkWET4jFhl7WwibyiRlyC9sF/Jtyju+ikWE9KiRrBeTa6ueZ1Fyq9ENom
         1dpz2S/wy04saZvonS6dh/Ecm8e6bymVSVMftIgM7VSx1hA6ew+EyQCSC2tXrAQ+gPGF
         4g1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771899079; x=1772503879;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eFA8Gu4szBvFtRfGkwR0vdAO1QkTVvSnODLMLCE2WIA=;
        b=kxHJWHH2oXWrTdicJzBaZPIghaub2B2lGR5dWIEZ4JiM+5QaLePETUvxcSlDojvcZ4
         5qZc8vOaEDbracZ0g7VKGTkqwquT7B7kveySvRVAH7GVG2VkMQ1byzBWV8aBBmIxbdxy
         wofcimbE+HqTxXOE08dtTVPSWvCeczvTfoCu5k3Ymr4cxnEKLb5jOwqOLGP978IuTeir
         OyFaaLFLfQL6pNROi3RYZoMrK7hW8Sq01ZgoIJhRO5vLCgCSn08TB5+gTCY6Yy9gXXAE
         4K6Bn0HqfPqWGmzPHhbngxe0ulcKUluAC8n4bDkAzpsDkMZ0Uxde5ecBSt0jN37S15xR
         +Aww==
X-Forwarded-Encrypted: i=1; AJvYcCVoXVBPrvBzOzoaUMwP2A9hDzlDA1dsp4bGCGJainjibug4zFoa/SyqugZ5Bjq2S1FH9igY8KOGCg==@kvack.org
X-Gm-Message-State: AOJu0YxAEdfKEXX2eUDLfgCIrbY8Pass91IuTy9RV/G+7b8JAN0id0hy
	PL7hggSg0VXjQtn6DAz/THg6WnlxJA/tAfq+s1q8lnX/WUL67E82LzbvEYMhkB1+MWs5xNNrFny
	qs0BrwSFs4P9dpzz1wvvPgz6yJ29Yx1g=
X-Gm-Gg: AZuq6aKx/h5Az/CZtg8DRc93BJflMNLrbZE86HaFvCgL1fW8J2+CgQEkOhT7rA8KaBw
	bIMRd62KbAlFB7DkoaLiEGG5rjGQ6Use2zUanofVBwNOUUiHda2ilt0DgpnL2LAP4BVWAWadNRM
	tI7f7dQSP9TcvJlu0RWTq9Ozs5NUveZNIsG+4Ui2/WA3LFpmEZqDAkqdqECV+B2VbLajwVn5nA2
	7wZtZ/GorPT5B7uM+JldbDMfyhzbvB8+t7mEHpXFMOjIzO31JOv6NhewHxVdQCAG/it70UrMyTK
	/ACJ8rku2mmlamLGIx3z7Hkb2v//ZkEhRnKTJ20b
X-Received: by 2002:a17:906:6b96:b0:b8d:bf4d:7463 with SMTP id
 a640c23a62f3a-b9081b4e964mr504856266b.31.1771899078951; Mon, 23 Feb 2026
 18:11:18 -0800 (PST)
MIME-Version: 1.0
References: <20260220-swap-table-p4-v1-0-104795d19815@tencent.com> <aZyFxKGXc8J6PIij@cmpxchg.org>
In-Reply-To: <aZyFxKGXc8J6PIij@cmpxchg.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 24 Feb 2026 10:10:42 +0800
X-Gm-Features: AaiRm503gqQwqplXGOPWtkC6hEz-XK9q1g7AWXt5tyf9jgc_DTnRm0pF7psYupY
Message-ID: <CAMgjq7AyL4=cN1mQ=i56j-kOvEaZXyT-3Wu063vM5JijXcFDLg@mail.gmail.com>
Subject: Re: [PATCH RFC 00/15] mm, swap: swap table phase IV with dynamic
 ghost swapfile
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: pzsgty57yobmempyjak5xqmiobtpfpj5
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: ED4521C000A
X-HE-Tag: 1771899080-572975
X-HE-Meta: U2FsdGVkX1+tJ0l8eoUnQRHTB+qtliGixRp3XbngaE0d3F0Lfg1BgAKlP/TpFXd+47q01ZxsI5rVeEjMuO+DCZOCWS+iY0jXNydf8m9disPFvYHxTHigamOJON6TI7xc4QP+o1bkJOy/At0JdrkQZD8jv75lYbPy5xbT4tdecjxKVgP3+ZeQc0LE4WEppoNeF7A0UDS/F/BgEeFVYHVep6e+ZIpYHHwRc0FWu75f9xvIlqlXg5hdEj+HhRD7RZRcdhXT3Es80OJ1kCPP0FvW+XpLbXHJjXw9WQx7XPMrEajrPNvD3LNg3rJPJZKr17rHxSyq2sdcsUqPBwxhzihhcVX1gvYRquDIRlQV6Eun+WsO/4e4a5RrlKIKdjhwGg3IKd6h7o1MxeBYgBVtZ4VfNaCI4Pn5baydXZ0c5TQzYE5YY2u8fuG+kq646/VNqEv8E55f8hqYSPDbMScK2Z5cvPparo5TiqNLWusDSfKPNph9SsgQHp30hKXtLxsDSIeG+7MkBoA7sztTLS9P36RjZTjaTjLIc9dE6CQbekYXIjMI8RwjapHOvfgj+bJypWRxeXC7gEbDBmkGWjizGvkLcMdjVsbhimRRGxR7jWJqz68aDS7JHLJb1dtgTqXhYxdfQRwwDBUU8HLfRo4hYAZGvXq5r0jnR+C5RnZ5MZGWMHUBgROXv1qtWmMDNSYmVahNQUgP5PjXs6cmCoc0FZWfAZisE98tb6uaQerKSEivk8DTB9PRziAudB9rFSRXByEoyn/xkrM0cp/YDlotAFagOL8n4DvuQ+BPBAj6lpzxaOnVJX8tijINUPFQ1f0ljY3tQnLLERNm/pKBU595fe2a3tQzs5zxm58LYo00+YE0fSb0mzSxmOj6RdTz+vvaQXe21zzX52Bc1/ixVDh4YzHn3FqiMY6rwajI8L0gJaJyYWh9TKwaItN1AqOFZFovkWvUAnQglY3bePY4BoQNd+k
 8AtDw6fr
 +Tbwq2F8N225NUabR33Qb7FsxnPFUjC9IfJvqqMeFfShIdpm4+vwwlWfDJKRy+xvqQ/xWWw3dNtwZLuDOGaMspbPnRlbMrSUXGwILZB0vd/pZL1eh4mDtdaPIzQPujBtcBxDXeXEw+AF8Hu4NBvGlyqJpqg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 1:00=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.org=
> wrote:
>
> On Fri, Feb 20, 2026 at 07:42:01AM +0800, Kairui Song via B4 Relay wrote:
> > - 8 bytes per slot memory usage, when using only plain swap.
> >   - And the memory usage can be reduced to 3 or only 1 byte.
> > - 16 bytes per slot memory usage, when using ghost / virtual zswap.
> >   - Zswap can just use ci_dyn->virtual_table to free up it's content
> >     completely.
> >   - And the memory usage can be reduced to 11 or 8 bytes using the same
> >     code above.
> >   - 24 bytes only if including reverse mapping is in use.
>
> That seems to tie us pretty permanently to duplicate metadata.
>
> For every page that was written to disk through zswap, we have an
> entry in the ghost swapfile, and an entry in the backend swapfile, no?

No, only one entry in the ghost swapfile (xswap or virtual swap file,
anyway it's just a name). The one in the physical swap is a reverse
mapping entry, it tells which slot in the ghost swapfile is pointing
to the physical slot, so swapoff / migration of the physical slot can
be done in O(1) time.

So, zero duplicate of any data.

>
> > - Minimal code review or maintenance burden. All layers are using the e=
xact
> >   same infrastructure for metadata / allocation / synchronization, maki=
ng
> >   all API and conventions consistent and easy to maintain.
> > - Writeback, migration and compaction are easily supportable since both
> >   reverse mapping and reallocation are prepared. We just need a
> >   folio_realloc_swap to allocate new entries for the existing entry, an=
d
> >   fill the swap table with a reserve map entry.
> > - Fast swapoff: Just read into ghost / virtual swap cache.
>
> Can we get this for disk swap as well? ;)
>
> Zswap swapoff is already fairly fast, albeit CPU intense. It's the
> scattered IO that makes swapoff on disks so terrible.

I am talking about disk swap here, not zswap. Swapoff of a physical
entry just loads the swap data in the virtual slot according to the
reverse mapping entry.

> > free -m
> >                total        used        free      shared  buff/cache   =
available
> > Mem:            1465         250         927           1         356   =
     1215
> > Swap:       15269887           0    15269887
>
> I'm not a fan of this. This makes free(1) output kind of useless, and
> very misleading. The swap space presented here has nothing to do with
> actual swap capacity, and the actual disk swap capacity is obscured.
>
> And how would a user choose this size? How would a distribution?

It can be dynamic (just si->max +=3D 2M on every cluster allocation
since it's really just a number now). Can be hidden, and can have an
infinite size. That's just an interface design that can be flexibly
changed.

For example if we just set this to a super large value and hide it, it
will look identical to vss from userspace perspect, but stay optional
and zero overhead for existing ZRAM or plain swap users.

> The only limit is compression ratio, and you don't know this in
> advance. This restriction seems pretty arbitrary and avoidable.

Just as a reference: In practice we limit our ZRAM setup to 1/4 or 1:1
of the total RAM to avoid the machine goto endless reclaim and never
go OOM.

But we can also have an infinite size ZSWAP now, with this series.

