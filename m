Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7A6EC5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 16:39:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECA396B0092; Mon, 24 Aug 2026 12:39:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7AD86B0095; Mon, 24 Aug 2026 12:39:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D69D76B0099; Mon, 24 Aug 2026 12:39:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A90036B0092
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:39:16 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3F75F1C0852
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:39:16 +0000 (UTC)
X-FDA: 85136723112.09.1BB257A
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf20.hostedemail.com (Postfix) with ESMTP id 541081C0008
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:39:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="iu/doDhk";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787589554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lxchaipo0XOkASCChG5mzH54uBQ7bEpO8g3CtzEDtkk=;
	b=IJQ4qHp5wtkJl4tNOSQIt7vKaVezRX1NFwuSkQ5iHSmGBbin6yNVMFUsDwaxfA0eT/2m7G
	VRlfYKKD2anUfHSVpat6xbGMPAfB3G3U+EWtsxf+mU6Grd/SBEBTfmsKEAAsmAuTOcCq5G
	i7YNN0aBvi5JAYAjeG/2AZaMTnwC/M0=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="iu/doDhk";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787589554;
	b=5MEVuxskfBOIu2v0OvE/005z0nJx6BQc4rgzuq2C0IcSFS2FXx9utQYvjm7A/K6tBTnVx0
	rK6YgBSWv/r8VMcRDqVvTYnBIdxeFl4NQsFP4YWy533Yy654l1IMEyrmgD4KSfyPYc6Kki
	9kpAfQDtC2eR7VDX1AbtXQcpMFOq5gw=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-499ae1c6471so22316755e9.3
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:39:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787589553; cv=none;
        d=google.com; s=arc-20260327;
        b=ljMNj5IJrLk3Q0HtLd/6mSiN/KTc42p+KyD6niXmHByi/qMBfP9ZH98SYUb3D5MmIp
         MALabAgEMnbzJJ8mUamBkE+qEjQf+72VBy7H82JkVI+C+NzIo370ZoU9NTi1CfMQGKr9
         RBScwK6uX0W6bmeTFLH3b6PNG2qMZ9xis9z+lrox14LGj93CTH64uzh7OTMzcRp6dzFL
         oUiDe4oqIZK+YRIlKyv03VkffR6iyHpQylil7wrg0w9vF27FejJJN1PXjmdc4rKLnjrz
         wOrFkI/ftenMy1QnM/g2Uq4cmK6UpRx6nZxb8einzjNKuzpCZgQbeqV61jjad3q8KXLc
         +Mfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Lxchaipo0XOkASCChG5mzH54uBQ7bEpO8g3CtzEDtkk=;
        fh=OPKFRV/YGi2GFc6jB3HZPNRpEhu3iMJGTq3kMJvJKLA=;
        b=O6lgYEgLZFRev4HCcuvQyweEPiUWt8dItjB0WcoG7QWerLeciK6aZGzqQUUmGBb4GX
         ualDmUWeeuzqAy4go3FYyO4zZua/8iPCYIrHDzOBQ+1JZZQ8hVYOF089pR3VrRPYq3YO
         yehsXxGII6vIY/vn0iglfMOl84DGruUxF4I2SGM4vAOBc5SV2eA02O7VubCa4m7WBwI3
         XGkAxdTWaKg8AFdMphH13VgJRNiR/hauz5iOp7XnHjGlIZBuFc2GZfSSeNC+9ip9ECnR
         CiqbuGZT0jGjaxukU6pD5z9QrxxWNl6uiFjkxAtIEfKHSeQ6ZnTfuRafFRUq/ArX8ruR
         ivCg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787589553; x=1788194353; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Lxchaipo0XOkASCChG5mzH54uBQ7bEpO8g3CtzEDtkk=;
        b=iu/doDhkedOfnH74V6hCD2UfToFuetraBOeijsWDJAXbOWDZJVJ+U1B8OSWJDKNFWS
         0+udc7QuSYZT++WtuiiS3nMfOCd8WdyCyCBXJnXkRX/r3eJUyFWEFJB9yfkLa/5jV1vM
         XhZqPUlwrzCztPIP/Xx5nIvB+Nt8IVkLolCWasBfd+Ljh4hZ0XzqFn09r3IIFJUCzh3+
         rs81Ax8iAiJFHBpfUoADe1xcIX8Sq6cdHZ+qpFjashe9c0iyil2aeSBLYZlir7FAl8C5
         ZyZUpN1l+Sm4LDqUzrJtGec3fcuymgwQDQZNvzk4WsFhPWTydbqaC6RNO08R6vYuz2S5
         Dvqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787589553; x=1788194353;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Lxchaipo0XOkASCChG5mzH54uBQ7bEpO8g3CtzEDtkk=;
        b=lIiSUsLNHnyz2D6IC3sGa7TS8Qi1+UAaF6B6rOeBqDqxPQn14jb+BYucpOQDi4ZFev
         7OiGpwg/7A1TzXazwoPvBFp5LBt7E1T37Ysz6ieNqO6Bwdsm2f+ClJ2uowENGUnGkZeX
         0oADSbidjKZCi5g+O8a/k4RFFp2xUW70YUrPnbL33JcRtJLvjhe+QcZ4VO72JNHbleGE
         dHMjST7ywtYwcWmswwXCsNfJM3RrFCJLModVKkTZhfKd4qmKBjDBkpzZUdyhVIC3p3Il
         PHEpf+MjnXY3c7l23GGvt8BRHrqevzpSBEXc6BT5PMN/+lVYgDLdOTh0CXnR0dkV7uHh
         zfqA==
X-Forwarded-Encrypted: i=1; AHgh+RqwsS/mc6iq4fD02rB4ayEUaEO7mwffjYIwywngY10c95vipnDIm73g9Iz7+YEEcMmzvs4ufr/g2g==@kvack.org
X-Gm-Message-State: AFuF++nj+s6Rnd6uxRq3IToihflDK4zUGA2w7eaelUovN5kAenQ+MDE2
	FnXEAKipJVPjTP3Sv3Ce9gRnht78o5vKShAEGH0MponTEoR20aBtihCWCMQdBSDPVhnypDO15AO
	g4l4onGR6oqDJv5zTy4mF2lsLe3VIOXs=
X-Gm-Gg: AR+sD13j9je962lAfjOsDzlKvmaujnXbcIRbOO9YAsXS4Ee3QZmy6Z3BNvUMB5sOFkQ
	g+38kx8TpTIUQyu3wzDfzREqKTVhw3NcEcvG2an3K6Iqnp3/TCOfQQlbnOb52SUWdCNSKZli0Pw
	cvRtCiZFV3GOs5oJS2gi6qfq9+4klNQ2E2P1nOewm+NyBgeI8o14hpLRbvPYpreIPJT3GQt0/TH
	a++1cB5GmOQTWj5tA1/zfsGJ/PCqZufBFIiM5KWQw1Q2k59fI8IETN1hAv0P6i3D9bm2JKZbyC0
	QAIMRZ1KedpW4s+mclZ8y8v0BQnkK74pOJXmiYeb00N1VIX8owmyRqcb
X-Received: by 2002:a05:600c:4e89:b0:499:53c4:1daa with SMTP id
 5b1f17b1804b1-499b8474febmr346530335e9.15.1787589552280; Mon, 24 Aug 2026
 09:39:12 -0700 (PDT)
MIME-Version: 1.0
References: <20260818163221.589352-3-alex@ghiti.fr> <20260821083500.856970-1-kunwu.chan@linux.dev>
 <CAEmasaUzCU7r7DzJfMFbQGZCJvA_wOJifPywQmy8mOz0efWn8g@mail.gmail.com> <CAEmasaX8QPPNFjrTWn4jn+hoC_q9BrRhia9Zz5FYHyzbMjN2SA@mail.gmail.com>
In-Reply-To: <CAEmasaX8QPPNFjrTWn4jn+hoC_q9BrRhia9Zz5FYHyzbMjN2SA@mail.gmail.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Tue, 25 Aug 2026 00:39:00 +0800
X-Gm-Features: AcwNN1UaQAkZTylCiVANyXjbN8zO4d5pJy1P5Gk4Q_Uw1URMWPexKU-CeqwqgRw
Message-ID: <CAN_Opa8Bp3udH2hVGMGwomncFRrZ11FpqkN7gogPgYJYNtAe0Q@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] mm: swap: drop dropbehind swap cache folios on
 writeback completion
To: Alexandre Ghiti <alexghiti@meta.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kairui Song <ryncsn@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Wei Xu <weixugc@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: a7t4zos4m6ixxgb7pnybehctsx3t7pdo
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 541081C0008
X-HE-Tag: 1787589554-432833
X-HE-Meta: U2FsdGVkX18YwO+q4sQ2nrg9zO9GLtxVMjh29ZEnr7y/nE5PDeheWo5dNshKqGbyK68HUYI9/zFRVZ/SlLrZAvYwqm4pHhv6eYzfDN42oIP92eKdGplVAs5DFmpV2/ode3B4yi6N+hmx4Lb9xMGup+Bf1mgZG23KJJCxhxZilFTptOj9uXGhiDNorIgqDXZmm+9T3f/FL6IjyLXjEzn7dDeOhktIQ7qRV9X/eWTVMhJoy6KM0ineaQcGSq65jKR+z5wKg3LPjb7tXE/5j0xFK9AZBV9gsd01TlBC7MLNX080nW7zsiiPugmUYBSQNbGvvb7KR83+dRSnE0aYlrOxrOU9XvSVmfeU3I1Dh4nNlwiyiVUw0aLk8iggVZ7jOe9gh3WSQ4Qrdqh5+35BeETb8VxJ+Uz6r7v9hkNYl1lpm377qm7spQhLlGqACceFnidxbRu4JjVgHE/ur6E3rsM8nWKfkpBrBptiUTfhMD2TMeie0DlGTIJZ6etzrWc37Ac1gA49Hd2Xyz+WgenixmFE8lxKQKD7Vg6Hl7f4Y2SNEXv8mi6YDOm7Y0Lgul+sz2XoxZJiIHKz1nRmWqtWrPlltTlIZe6m72WIFTRBfzp17aH5lHNeoC4IWFZrIUa3quTPa0g3nuqXw/6J3cD3eBD06PMALBX7Gxmy8Hu95WvR2IgRuZEFRU4CIclpZCshN3X2M/O7SxHxgWFr929Y/OVOHkx/3g0Usppq0DNMqWCwTCGPP/hNedY5OL5wi0bzNvZ+0On44zt4aKOYjMqrSES+jac3SDtsM+wdwIJDae5wlQNeYrhp7EpPatQs8vcSIpo9+U08QmVI+76xaXMY1oA/YF3rheaXT3X+ACOkUThjJhr5fW5SbjKyan+R4vdJhsdXkqsTtwP0lGVF+AybR/JHnAVqPe8vvBUbefoAZ7I33Qc24k0oyC+BDrcAD0EfAR9z2NSWwUEClkhDLOnYVSJ
 yjZKuWuB
 kW5jK3HCRjovnl6i9l3g22LCWXymdyq7SKS6AQCDoPlpi2M21RITIUxgo+P8DR5FaLbs+fiPVYUdDoflhtNIWdHD3imvJD1XMncgn0k3u4DaeR139M0ek/ifApGn5Nrx2DMe6ghOgb3QsXFfFyso/hFtcR7Vw0oEouu/fasKDl3n8NsXH5giZjWpIJvC4xNyUx/y6datTzXTyNj+kZD7YLmb1ts7SyJ0r/UT+LMWePpbm6EyKQJafoktmlsuYUc7zhuke8YVLFtMS8AMJvf+UBE7fbe0NQc5W6yrEprdNoWGtgkbzdOlR6fchKWrhwZr4Oz3vr4VRipyijk212vLaTuYv+W+jmfK5zXPSilSvaO+Ehq57nWUGJJY5HT75Vc66daFitgSiwo9hFUVeH4GAf5AjmE6khHqAp2umb657O1C0pXxA0vq237E8CXah2YetbcX1Glu1BrKa7lRw9DIGr2tPe66rUENDhxcvgzPrOFuJDXpxlendMzQZfuy1ApUP9BiSMY31maDS510=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 5:30=E2=80=AFPM Alexandre Ghiti <alexghiti@meta.com=
> wrote:
>
> On Fri, Aug 21, 2026 at 11:53=E2=80=AFAM Alexandre Ghiti <alexghiti@meta.=
com> wrote:
> >
> > Hi Kunwu,
> >
> > On Fri, Aug 21, 2026 at 10:35=E2=80=AFAM Kunwu Chan <kunwu.chan@gmail.c=
om> wrote:
> > >
> > > > >
> > >
> > > Hi Alexandre,
> > >
> > > I have a question about the reference ownership/lifetime model in the
> > > synchronous-IO case.
> > >
> > > Consider the synchronous writeback path in Patch 3:
> > >
> > >   zswap_writeback_entry()
> > >     folio =3D __swap_cache_alloc_folio(...);
> > >     ...
> > >     __swap_writepage(folio, NULL);
> > >     folio_put(folio);
> > >
> > > During writeback completion, Patch 2 does:
> > >
> > >   folio_end_writeback(folio)
> > >     folio_get(folio);
> > >     ...
> > >     swap_writeback_dropbehind_folio(folio);
> > >       llist_add()
> > >       queue_work()
> > >
> > > With synchronous I/O, is it possible for the dropbehind worker to run
> > > before zswap_writeback_entry() drops its reference after
> > > __swap_writepage() returns?
> >
> > Yes, totally! The window is short though and in that rare case, we
> > would fall back to the initial behaviour (almost, since we put the
> > folio back onto lru but not rotate it). And for async devices, I don't
> > think it can happen at all.
> >
> > >
> > > If so, the worker will attempt:
> > >
> > >   swap_dropbehind_drop_folio(folio)
> > >     ...
> > >     remove_mapping(swap_address_space(folio->swap), folio, true, memc=
g)
> > >
> > > while the caller's reference is still held.  Looking at
> > > __remove_mapping() in mm/vmscan.c, it expects a refcount of
> > > 1 + folio_nr_pages(folio), but the extra reference still held by
> > > zswap_writeback_entry() would make the actual refcount one higher.
> > > It therefore looks like folio_ref_freeze() will fail in this case.
> > > Is that the intended behavior here?
> > >
> > > If the removal can fail, the fallback is:
> > >
> > >     folio_clear_dropbehind(folio);
> > >     folio_add_lru(folio);
> > >
> > > This appears semantically safe, but it means that the dropbehind
> > > optimization is lost for that writeback: the cold folio goes back ont=
o
> > > the LRU and has to be found by reclaim later.
> > >
> > > This seems particularly worth checking because v3 intentionally remov=
es
> > > the synchronous-I/O special case from v2.  The cover letter describes
> > > that special case as an optimization that was not worth the extra cod=
e,
> > > which I agree is a reasonable direction if the generic path is
> > > sufficiently effective.
> > >
> > > Could you measure the corresponding fallback rate on a synchronous
> > > backend (e.g. zram)?  The 99.996% success rate in the cover letter is=
 for
> > > asynchronous NVMe, so it does not tell us how often this particular r=
ace
> > > occurs with synchronous completion.
> > >
> > > More generally, I'd like the reference ownership across
> > > __swap_writepage(), folio_end_writeback(), and the deferred worker to=
 be
> > > made explicit.  If the caller's reference can overlap with the worker=
's
> > > reference, I'd also like to understand whether that is an intentional
> > > and acceptable trade-off, or whether the overlap can be avoided witho=
ut
> > > reintroducing the synchronous-I/O special case that v3 is trying to
> > > remove.
> >
> > I need to look into the patchset that Matthew and Barry pointed to and
> > check if it's still relevant with this patchset on top of it. If so,
> > I'll add a debug counter to confirm we don't fall back too much for
> > sync devices :)
> >
>

Hi Alex,

Thanks for checking this and for the detailed explanation.

> As you noted, in my implementation, a race was possible between the
> worker and the folio_put() in zswap_writeback_entry(). Now with Tal's
> patchset which *only* defers atomic context to a workqueue, the
> dropbehind folios on synchronous devices get freed inline which is not
> possible because of the reference held by the zswap writeback path.
>
> But it's cleanly fixable by dropping the zswap reference before
> __swap_writepage(): the folio is locked (when it is allocated) until
> writeback starts, then PG_writeback prevents the folio removal from
> the swapcache and right before clearing PG_writeback in
> folio_end_writeback_no_dropbehind(), folio_end_writeback() takes a
> reference! So remove_mapping() is happy with the refcount :)
>

That makes sense.
Dropping the zswap reference before __swap_writepage()  avoids the
overlap, while PG_writeback prevents the folio from being removed  from
the swap cache until writeback completion.
The reference taken before clearing PG_writeback then ensures that
remove_mapping() sees the expected refcount.

I agree this is cleaner than bringing back the synchronous-I/O special case=
.

> So there are no more races as you pointed out, since we drop the
> reference before the writeback. I'll post the v4 today.

I'll take a look at v4 after it is posted.

Thanks,
KunWu

>
> Thanks again for your comment.
>
> Alex
>
>
>
> > Thanks for your comment!
> >
> > Alex
> >
> > >
> > > Thanks,
> > > KunWu
> > >

