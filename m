Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 159ABD29DE6
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 07:49:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BA776B008A; Tue, 13 Jan 2026 02:49:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78FD26B008C; Tue, 13 Jan 2026 02:49:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 692486B0092; Tue, 13 Jan 2026 02:49:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 586546B008A
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 02:49:36 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EF59D56EDA
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 07:49:35 +0000 (UTC)
X-FDA: 84326165910.24.7AFA4D1
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf27.hostedemail.com (Postfix) with ESMTP id 175684000A
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 07:49:33 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=j2U0ueXg;
	spf=pass (imf27.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768290574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D72r7QS3AZghCN5eZae/D45TgwvMIo1bhMsAnpABw0A=;
	b=hu0oggMs0peRYbBseb7dIhUFk3kVUcSQVT4kjab+OPIpwwTQaG1PMbCDZ76DTZk8Y2fxkU
	IOaX+PGaEVb2lqVZMIFAdBOY3DsH4laXBQI9WXFqK8d7qGPvIqPTvy2IHtsW8LNyhBTSm7
	sJWUV3A823OZq5NhEIzGWUYrhfXwMdI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=j2U0ueXg;
	spf=pass (imf27.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768290574; a=rsa-sha256;
	cv=none;
	b=4TwOhk3TRnQxBqW84fnckXu3zRH3hsxWjwCSmni3vy0166ZRq/20LuLacvuy12NKOGLNdB
	pg8B0WzYg4sPYuM7rZxXBR0IThqQgB/jhc/IdJhgnIKc7hPMip5SYQ2u6nkj9sWewehKj3
	PhiN8zHXzjUYazDALWglU/T1SYlU9Kw=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-47d59da3d81so27059295e9.0
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 23:49:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768290572; x=1768895372; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D72r7QS3AZghCN5eZae/D45TgwvMIo1bhMsAnpABw0A=;
        b=j2U0ueXgG/08ycdAbj4YaBJuoEhfTTKIa4ZFvgyW4VvWI9tgaEBwmzTZ576jS0qSpI
         oWetKnTvq+MgLaDKUuX90qftTfUoPldrXArmG7uBL8h5WC1uDIs8Ey6sVulyaMKtjkEH
         wgTQ3EXPBm6m5cE7Eew+cncnacyoC/0a0Qn5dSheHC/2UCZXnbqSFedEglT+Bsca3bN4
         Iqp8sKhnRSxEm1y4awJD7z0dmsN5mVLKcjM6frEJwMz6oRZ2BbhFNtEZYuNWhEwr2zQe
         Bhcxh21XcPelVJ14yUNQrLpZ7Cgjqv2mShskUcVN7VueYPtekNd0K6LNvE+xkrdwxLJT
         daUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768290572; x=1768895372;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=D72r7QS3AZghCN5eZae/D45TgwvMIo1bhMsAnpABw0A=;
        b=QkQw6FTK8VFofqkMZ6FrV8IK71zSlbVbDbReVMItE2zAoQAQ41V5i1Ei0Mryrm85dJ
         F/R12qJby42nq9a6jKIaE4b28ZiBA1ZZ/LyjH/EmVeltSH9DSxS1+5auOgEhvwJxPCJk
         UL0xJClJ1R+hH50/bvRHpxwxshRsk5ty0Wm3i/0sbIG1c9Pj+DrXm8fGZ669WX0CoDKK
         HnzUJZkKgxDZMShVeB69ji6vpwJDGx5BNob1p/ohZL/BIXVBO1n7zs7qowIUJ1fm4B2P
         STNb+NfzllneMLfSYJenpv+FLQXhhpUeLeZuNpZtKh9GDxqgzMX/qgdBl2u+FAMPx0Il
         tglw==
X-Forwarded-Encrypted: i=1; AJvYcCVJwsUEJ4QJPkshNqvFa/JCqdPLjEkkNXIOtn5+1qLMbtuFcqCX0kmq4L/oiZeoq/Y7TImYolNvAg==@kvack.org
X-Gm-Message-State: AOJu0Yz3yY7dDfzl6KSXDiiKgNxSIixEkxA1KfXVez3f8k6bs1fXjrCD
	MTYdrt9zUKHLEt++5UsthZUqINCaWi2Li0oBigLvWKbnMIpd0sAMKbGRszcK08aYIuUCWMTMCkk
	jxsPfTjJsmaOOH3tgrXczySBM57vwts0=
X-Gm-Gg: AY/fxX5qqG5vbMazhV9g0FqyUxoQ7znGYwdFd48abHNsmTPbbiiQND+BTCO/syZQoFS
	PeQN5Azmhcphr3fiZQSi2X2e3GvU0I6omhV2MKgWsoLYjAZqLjeO/vGGSvrx1Nn45boSU2r6UfX
	spcYIzaUl6K/sKF/XscEqhfFdORasLyCWl41cH/pVx+or1gnLr9b4BPLEFSOIuvCayQyZAJIs3I
	mNRG6mEzBS6/GxZ/cZMNbPSivOlenx6oyE2V/2P7mxOAD4Ix9s0lxmL1fCRuTPUh0L4bpDRzyaz
	I8KLYw==
X-Google-Smtp-Source: AGHT+IEUFzHNS5l/qkxJS4NHDFzj85t9p9hXmvLuRRVn51UAN1F31Ec5D+lka3oYPvt3/QRvR+bD0XtQlx2VDHa+1AY=
X-Received: by 2002:a05:6000:2084:b0:432:86e3:84ec with SMTP id
 ffacd0b85a97d-43423e8dc7amr2509543f8f.23.1768290572295; Mon, 12 Jan 2026
 23:49:32 -0800 (PST)
MIME-Version: 1.0
References: <20260108203755.1163107-1-gourry@gourry.net> <20260108203755.1163107-8-gourry@gourry.net>
 <i6o5k4xumd5i3ehl6ifk3554sowd2qe7yul7vhaqlh2zo6y7is@z2ky4m432wd6>
 <aWF1uDdP75gOCGLm@gourry-fedora-PF4VCD3F> <4ftthovin57fi4blr2mardw4elwfsiv6vrkhrjqjsfvvuuugjj@uivjc5uzj5ys>
 <CAKEwX=MftJXOE8H=m1C=_RVL8cu516efixTwcaQMBB9pdj=K+g@mail.gmail.com>
In-Reply-To: <CAKEwX=MftJXOE8H=m1C=_RVL8cu516efixTwcaQMBB9pdj=K+g@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 13 Jan 2026 16:49:20 +0900
X-Gm-Features: AZwV_QjRztJYV3eeZ1od2Jwrm9JddNIFu6M0SVCsJAY8kxCGR_nVVkUgLa9Xz14
Message-ID: <CAKEwX=M8=vDO_pg5EJWiaNnJQpob8=NWvbZzssKKPpzs24wj+A@mail.gmail.com>
Subject: Re: [RFC PATCH v3 7/8] mm/zswap: compressed ram direct integration
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	kernel-team@meta.com, longman@redhat.com, tj@kernel.org, hannes@cmpxchg.org, 
	mkoutny@suse.com, corbet@lwn.net, gregkh@linuxfoundation.org, 
	rafael@kernel.org, dakr@kernel.org, dave@stgolabs.net, 
	jonathan.cameron@huawei.com, dave.jiang@intel.com, alison.schofield@intel.com, 
	vishal.l.verma@intel.com, ira.weiny@intel.com, dan.j.williams@intel.com, 
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com, mhocko@suse.com, 
	jackmanb@google.com, ziy@nvidia.com, david@kernel.org, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	yury.norov@gmail.com, linux@rasmusvillemoes.dk, rientjes@google.com, 
	shakeel.butt@linux.dev, chrisl@kernel.org, kasong@tencent.com, 
	shikemeng@huaweicloud.com, bhe@redhat.com, baohua@kernel.org, 
	chengming.zhou@linux.dev, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	osalvador@suse.de, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, cl@gentwo.org, harry.yoo@oracle.com, 
	zhengqi.arch@bytedance.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 14ntkiyhynoqg5hbqjqe5e7rbwmradga
X-Rspamd-Queue-Id: 175684000A
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768290573-88715
X-HE-Meta: U2FsdGVkX1+VZs/kC+g4Fm38lNxT3cn4qMTiCRkZL/NrPznk4AAe4mWE4KAHw9BXwgmtEq51ioaDlk8FfbY9GYsq5AqqEZ6i2YS6b1wQ2J61F0NFUDJHvjNKjrIyeVgTA8GSbpNgqY1bJNEVyadxTdlwC2x+F3RXe50rY5p+Y0nytVajxvgps2ovRJCy0c6fyBT8RtsWK+bausL0JgFilg3av8aRYe/ztZRZAvVx5zIG9CHrJL07AhvxtR3+x9RB3CkxeObqT8G2h0nLwXCzKEHHre31YC+5K0QxCu2La0NDFXxrnTzCLZIBJyFaOJxK2JSsWlocgS7nrWOJdM6/0Gg7/tzwcXBezoBadOqnWf2XFvG4aB6NxErBSzYOTa2AhBoNhwjCsmsGQSqDFCxU7oRqMiI5eJLRql1MNR1vbuPenkOPys3UhW/17fRC9qu+6LVCMwx5t6dMS/7sYhrkoLAJHwNC+UQZCre5e9zRHKcV78aCeqXrftvsv2Sf+Rpp18EGvrjfvsB35cruMF2Rj+EsgMwhCR8TOkS7VLpVMbGmoIUw3Bz/MGc5nVsPVoyJ7e3C2ck81CUlai86BWEIzZH+LFCBSsFFb1z+N5stX9tsGUqxlLpmtCqWQSZ0ts4TR7B69NSxotkk4XTbudr2Mxg0eGa7zs/QTM35C7iMNv7UU7ItvgNUNaAE5H1K+wD1EMibhX8suDvwXObRjasqD+eIqmXtqjplIlZNAdmi9QtMEuGNmEXjHn96b0YTaZ7nbGFi+BBM0cnWQ4ypIORcjdegA22EBNXBcTnrSQGyTtkV30IMaw9dh27gVcjGI2rVa0VfdZ6xryEnRpkhG/M3D+a++9IqXuoQc7txjXS8Bg6chgylWlx2SGiU28OwsOSXBTQa6nNbYFfLdnsMFXEgPiP75Oj5uBv60oOpu03Mka96VJ4tcWeoiss9v642YZ9pzE6sn9IVrn7P07WSN3T
 WPCFLTXz
 sm1lXpJdRi7T8WScfKjxaSvCXxbvpOVho0vvwxapJdvHhQL1g97FauZzpPJID7ilIYlrVaCQ0PNjiuG9CX2ZAbEVwt51OHwlW56cSrjS173trDC6pTZvOpkaJfpsUwds5tpdVEjAp0iJsnrXH0HU38ykvSLXlclghhi10Q4DADD8vHKq7KEF1IjW2j+j9uMnRKVvvfyehMjGes9lJcczbwlXVhMkAuH+FIdvYJGk4DAMHJo2R5SQ0YuNxrnxRgkUqzymUjY6oGGeYVwfVpFZCaBwAbDS+FotiRIShaEGLvseYnWSz3es5WawqVeauQwU3pndHKi43NR9hOQ3I/KYUwmvtGerVwnthROgJ8mhg7yiteGICzMfhaOjnePWKLIrPiwMqCJ8WzebHs6zawuuPkYeSPnpv/j+CEiH/2hjHFTQtWWJAfcqVXFyE5ZJh3tx/lq+z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 13, 2026 at 4:35=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> > This part needs more thought. Zswap cannot charge a full page because
> > then from the memcg perspective reclaim is not making any progress.
> > OTOH, as you mention, from the system perspective we just consumed a
> > full page, so not charging that would be inconsistent.
> >
> > This is not a zswap-specific thing though, even with cram.c we have to
> > figure out how to charge memory on the compressed node to the memcg.
> > It's perhaps not as much of a problem as with zswap because we are not
> > dealing with reclaim not making progress.
> >
> > Maybe the memcg limits need to be "enlightened" about different tiers?
> > We did have such discussions in the past outside the context of
> > compressed memory, for memory tiering in general.
>
> What if we add a reclaim flag that says "hey, we are hitting actual
> memory limit and need to make memory reclaim forward progress".
>
> Then, we can have zswap skip compressed cxl backend and fall back to
> real compression.
>
> (Maybe also demotion, which only move memory from one node to another,
> as well as the new cram.c stuff? This will technically also save some
> wasted work, as in the status quo we will need to do a demotion pass
> first, before having to reclaiom memory from the bottom tier anyway?
> But not sure if we want this).

Some more thoughts - right now demotion is kinda similar, right? We
move pages from one node (fast tier) to another (slow tier). This
frees up space in the fast tier, but it actually doesn't change the
memcg memory usage. So we are not making "forward progress" with this
either.

I suppose this is fine-ish, because reclaim subsystem can then proceed
by reclaiming from the bottom tier, which will now go to disk swap,
zswap, etc.

Can we achieve the same effect by making pages in
zswap-backed-by-compressed-cxl reclaimable:

1. Recompression - take them off compressed cxl and store them in
zswap proper (i.e in-memory compression).

2. Just enable zswap shrinker and have memory reclaim move these pages
into disk swap. This will have a much more drastic performance
implications though :)

