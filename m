Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 600C8606A320
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 17:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=PqMgZKnx
Received: by kanga.kvack.org (Postfix)
	id 6584F6B0875; Tue, 27 Oct 2026 13:43:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62F896B0877; Tue, 27 Oct 2026 13:43:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 521796B0878; Tue, 27 Oct 2026 13:43:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 27AD96B0875
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:43:29 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AE6E81C44D3
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 17:43:28 +0000 (UTC)
X-FDA: 85369128096.23.BB46490
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf27.hostedemail.com (Postfix) with ESMTP id B948C4000A
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 17:43:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=PqMgZKnx;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793123006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p3B3dOUVUprYHGKVW+MiktwDFrlXxMAYs/IueGeZxSQ=;
	b=DJudPxn8WB45G/zbjLFkE2fPmt1k51f44yTvTNv3IWbqkdsyvjYCcO9AimM0NG4s94mepc
	BuJrlyw8CcfjnuJyKclQ6oJ66m6IE7EyBMJJcekSiMuYng0uv0IUcFIUB1psSuueYaEd35
	eiES/boHcNKMhcwAJFWslM2dR1tZ+GI=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=PqMgZKnx;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793123006;
	b=Ai0jQhwNkNbpWOUOvRwkF9bq1Y1vFAwopIODt3pMo5WcE7+5Z6lWisp8S6E7DkujP2jofp
	VQIp/u3rDyntI1T95biEZMOgcSRvBNqC2zBq3uClmfj8Y6wBGGohzwYss2rKg7wpDpw2SZ
	DVm2NFPh1x2txwBfl11SoiTf9nYQjy8=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a20d7a8984so2865e9.1
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:43:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793123005; cv=none;
        d=google.com; s=arc-20260327;
        b=pSBvQ4J+Gp5hgaKbMFNdtbBTpaZDNDzCvgE091O9Z5oikPEPQvIxSRrkO+7k11OYMh
         h1uQzgfwAt2JoSKoK33y1A2YSi2f6pZ7F0s0W40y/VY6nBBZkj1GgwE3jX/TWJ6QGB2x
         75HGsy9bTY5/nwMWqkTzWcwvYNAnjTj0U9Mdso6PJBqQXBWDzz9ZCnYX186rP0rEjvp6
         PtM+p3/H21zrurAzBIsASnqvcMFEgmoeEcouSxNnbG9LTW+rnvXBXkLNO1q5i5IPSDVI
         ojCQ7jCjBUpAPNo+pyw9j7SERf33NMIC8k/MZJrLkYm9gTxKxqzv/5J2wPuHPD1SaxTY
         I18w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=p3B3dOUVUprYHGKVW+MiktwDFrlXxMAYs/IueGeZxSQ=;
        fh=0RCkTXE8ZSr8sxh8cxIT+6r+pwa2J0O8Q6r2RveTSO8=;
        b=pE+9vKeCqDy9LKNMEPD8QGMPIZtuy88wg86VMJr/AVZ1zMPseLBXQ4ix6X43lW+A6T
         kQDBQViBpnLiEUSaKom4CLMsrXsuoMTs2F7vb+f7xoqjKx0tnLnEh7RLVIX7/dgSz9Tu
         eGSgthjhsr+wWRVvu8lqiiebujG8ueB8UwdFZNti2OKA5U8cr46/GCf1/42gxTuLMgEW
         pWVL1Qnc1SNEPaI3Ih0j4gfxngOrfQmbv4jkO+oTIvVusCVLOK0T+e/EP4qfXgtWrmph
         IPeacOVMZoduklxK0/i95tRA5Q/++DWlTJz5hGtdIv0YM0UxbNHSEEVw1jnjXfRSNy1n
         8XTQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793123005; x=1793727805; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=p3B3dOUVUprYHGKVW+MiktwDFrlXxMAYs/IueGeZxSQ=;
        b=PqMgZKnxEdvOmObZeSv7/s6Dl3t0OSQNZHLBJeJMTi3TLQdqYdq9Vnm28pBQfk9gcW
         +lSHcjoQBFNb2OHDaXIFsSWQTJXkq0HmE+1rGGzSV9YsBL163YeGznurgYjUA93D02I4
         b8yjS1s9lml/S3Aaqfis5yHQXLn3IaI/ISUyAaHAvLJEsGjDVSVQgpmo+RdopKtLYDmh
         NB8FxF6FB8ab+fk0OU8rt5IJOqCPNKVfV7FQcp5lT8jxRCyXVG/TACoosdr/J5lyt/76
         IYKj0rW/U2sYFWI/cOPon1euY0027ktInWZnnfdqird2URghAX4cpJ0G5pOTfyVrha8A
         msNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793123005; x=1793727805;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=p3B3dOUVUprYHGKVW+MiktwDFrlXxMAYs/IueGeZxSQ=;
        b=A1EBMzvLkQBGW35fSku6/x73Al4Dl7bijX2D76oq5hdVZUZCrrHAGeWK+aKbvbJpDB
         sAaj7FMaFGJkGVlh50jl+wK35XSGXV7ShGh7luMGdhu9EOamOPVr1YPFGvWqvsae7Je7
         TCzwNFwFe3NImdAbsazIGswqEHDBzLhIDAStGMRkOJMi9YOZMdekJPgVJJV6XJQoz8Nt
         dEzMvAlN/lYkNAwNv6XV5FxecUlA8fNvU33yAezNSjM8lShgRyEZQ1YkGLdOCjzaD9RU
         X/EdhV9y7vJqRorvLTI80AaKnbNpTF8nXa3dwHj7Wdf2NyJiW8qJPLrigaKGjDqAPYwP
         gQjA==
X-Forwarded-Encrypted: i=1; AKwUvBw6S0+AQ1cV4AjP8PQheaOvVaF9Qr4Lp8mHlSL+TQu3u9FSS0d4Mx0IsT28HcGddsCgDThfDH5c5w==@kvack.org
X-Gm-Message-State: AFq9FYK8kfmJ8BTVBwVSWDcjgtvV5xLGXSgd9tOuSjaUlvdxadXHdvqf
	WyN7zEOiyYkLFT5S7YhU66GDUeFyAlxWzGM1nb2mHDvEURjhmll767+w9Rn7USYsQkggcoIQ9kl
	PyyLAvY6bjDW+Ets8ZefE7lOkU5gNvo/Mk0mt1NDN
X-Gm-Gg: AYBFou2X5oWEZmtb724Q5jqvEc3QvcQUxrsUPRJEE6EJlXdlOyRIHfdyoCpDIOOSels
	uKrkOTqroQFPkgKIj8Iyek5+zvQ5LOE6mqAaPpMXLtRWmBpu2bLvUQUwigbB4wUIE6Kv2xzc8dE
	oWbol1CElKP6WvuaGxy3kpe9UNFXmLyYKubXM6EDWVAIyQ92veFPD6+qJKDh6dC01QhmzIv6vox
	XPoR0h69nsJpBwMfSyqiDJoybEvCE8KdCpdJLiiotBkzc4ZzKV19pE78W7XuDntQuJfhtH0Urrr
	dpoGDGRWFhNN3fUl3FuO2sN0Pc38WfO1i8oiB9KxMfpjiuLhHFmz8NzNctIQholewau0vzf/2v+
	1aN8+A79ZwlBwTxao61VuLCYE1drYJNXibkZ43tM6Oj29yezAWYLY8bVqbgKZVYDglQa+1QY4OQ
	vAfuwkJogT4dXJxQ==
X-Received: by 2002:a05:600c:1092:b0:4a1:eb02:37c with SMTP id
 5b1f17b1804b1-4a93cd51d37mr18155e9.6.1793123005040; Tue, 27 Oct 2026 10:43:25
 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261023222313.3979455-1-tjmercier@google.com> <DF7DBE4B-E0BA-423B-BDA7-DB07D1C9E564@linux.dev>
In-Reply-To: <DF7DBE4B-E0BA-423B-BDA7-DB07D1C9E564@linux.dev>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Tue, 27 Oct 2026 10:42:00 -0700
X-Gm-Features: AclHuK_QytrvT9uNtK6TFZfkFqcTUjqFLup9uHHWt2PGssnl21GD_10Q-N8u7ck
Message-ID: <CABdmKX3-XKWXwZe5f=VwZeSuKH6xM0dsK7TvY7u9B1hgaPOm4g@mail.gmail.com>
Subject: Re: [PATCH] mm: memcontrol: fix NULL pointer deref in
 high_work_func() on dying memcg
To: Muchun Song <muchun.song@linux.dev>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, zhengqi.arch@bytedance.com, akpm@linux-foundation.org, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B948C4000A
X-Stat-Signature: owsph1fsrgf6j5qhrrn9z5ycpqyqdz9j
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793123006-304915
X-HE-Meta: U2FsdGVkX18rAQ4KPCBkySOKztCKwyMVINe445/xng95KawZtdvr6uKBSViWxEEjNbmyJBMloS9DK6+HSAcPUUcgVyXzm6s6DbA7iqPjNakSjQ08CLncrbzh9OoLLy+oivtMfE0Tm7J2iFrIq6mrz2cKI7qlcq9XYLjqtNd3qGFl681ag6f2AdkcqF9tVIAdp5WfSC9gYwOX9GDWlyx9EXt9isJGo6esyL1EHp1ZUE+R2PWH1DGt4I/k+38adWI+wQI+SCgnqI0BM3GARrLDzN1GZXOXf/Jo4Shq3CMN89gTnCFLBvzqvWBL4VOf+emJ+ijo2MFVPrRxH/j7uZOLNOGK0hIkTipn05peMGJWWzhq0oLuaDw39FIZDwmg3MIijD5WiUMgAs4nJQOZuFe6Rez41YkRGayllcvgRTVy7RfSErVKT2GWukoQojW5kOgaa64HPX5euKOsV/1xX00w4o2upSvR1XgROIiQy2f5qH4xPwo64ehJnjYXjZMal1pFguXjtZ7TmRx1O3wuuop4csjL+YHHCMI9X8RhNaGEtJd4ctsdizNiqx40V5VvM1LfKZEn67yMw7m0f5mtrFBc+tRrxwxf6yo6FK2Ef3W554JGvS5tNWRS7CkE3xgCUTCRNXlPQib+zcTao1zTFRRdmgDQLPDsQDbs98JUnT+MJPOoxw/aiHgcvRGT5HM5SLaRfvinGwYCwufGNMSF/cJcdYCXD8XSh1j8pfDmNSWiNFFs4zI4SQGGDHaZWi3zyeO4N/BoAf5oyEq32BpPVXoO9yRhy1CJ3H0oEzPCYkq7hlC9/EiV16amm1dj+LgOnSNKkaIpLZp4r4Bf06ME9JwyjCt1/C6F9ilJEGY6+ey9INeI6m4evtYdJyfWwQmI3IfW/ifxUupXEAokPyGx+cryBMXrgkOac81Kp8nv2yUe6prYWHI0xD3WGEzv8IrFJsJtkuqy09yDcMnUPykU6TV
 x9GJJWfG
 8IF+K4FKZHlXLKZNCarBPQRoetM7NF/rWm2DWcj9RNJtGln7s/8TkEhzMFZeJx5yWJCPAQgd6S9zWZbMPY10lLZGxf0J5DqYsyFCH01WXX5nve0id2uEXuq6ijGZ5WsXf/6A8D5v7/9oc4ll1VooGdBqPknoG3MaOWtfan74RhCyqyhDYGpsU9HXPZg2gYlM/Phr8CG0C4eoR+2Coey9in6+iWOSKEtjyZ+Z0tCXBJBZeEFXgGDv3oryC9aO5zUH7pZk4Y6dNfjBPJWUcjibfJwInG4jOmWQqTBZH/L7zFpsqQog9ArVUY1sWQcs7hk2/Sb6sBUxCTJ8WJAdRliH9Zpfm8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 7:42=E2=80=AFPM Muchun Song <muchun.song@linux.dev>=
 wrote:
>
>
>
> > On Oct 24, 2026, at 06:23, T.J. Mercier <tjmercier@google.com> wrote:
> >
> > When memory.high is exceeded in non-task context, try_charge_memcg()
> > schedules memcg->high_work without taking a CSS reference on the memcg,
> > and high_work_func() invokes reclaim_high() without pinning the memcg.
> >
> > Before commit f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of
> > dying memory cgroup for LRU folios"), memory usage above memory.high
> > kept the memcg's refcount non-zero. With reparenting, folios and objcgs
> > charged to a child memcg are reparented to its parent in
> > mem_cgroup_css_offline(), leaving the offlined child's memory usage
> > permanently above its memory.high even after its last reference is
> > dropped.
> >
> > cancel_work_sync(&memcg->high_work) only runs at the end of teardown in
> > mem_cgroup_css_free(), so high_work_func() can start or still be runnin=
g
> > reclaim_high() after mem_cgroup_css_released() or shrink_many() has
> > called lru_gen_release_memcg() and unhashed lruvec->lrugen.list. This
> > causes lru_gen_rotate_memcg() to dereference a NULL pprev pointer.
> >
> > Fix this by acquiring a reference with css_tryget_online() in
> > high_work_func() before calling reclaim_high(), and by resetting
> > memory.high and swap.high to PAGE_COUNTER_MAX in
> > mem_cgroup_css_offline() so that charges via references on an offlined
> > memcg do not trigger high_work on the dead child or skip checking live
> > ancestors in try_charge_memcg().
> >
> > Oops: general protection fault, probably for non-canonical address 0xdf=
fffc0000000000: 0000 [#1] SMP KASAN NOPTI
> > KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> > CPU: 1 UID: 0 PID: 27 Comm: kworker/1:0 Tainted: G    B   W           7=
.3.0-rc5-g2bba28e98578 #284 PREEMPT(full) <- Taint from lru_gen_rotate_memc=
g() VM_WARN_ON_ONCE
> > Tainted: [B]=3DBAD_PAGE, [W]=3DWARN
> > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-debi=
an-1.17.0-1 04/01/2014
> > Workqueue: events high_work_func
> > RIP: 0010:lru_gen_rotate_memcg+0x1a3/0xe90
> > Code: fd 7f 09 45 84 ed 0f 85 64 0c 00 00 48 89 cf c6 83 6a 07 00 00 00=
 48 c1 ef 03 88 83 69 07 00 00 48 b8 00 00 00 00 00 fc ff df <80> 3c 07 00 =
0f 85 ec 0b 00 00 48 89 31 40 f6 c6 01 0f 85 4e 00
> > RSP: 0018:ffa00000001ef4c8 EFLAGS: 00010046
> > RAX: dffffc0000000000 RBX: ff1100000779e440 RCX: 0000000000000000
> > RDX: 0000000000000001 RSI: ff1100000779b9b0 RDI: 0000000000000000
> > RBP: ff110000bffd8e40 R08: 0000000000000000 R09: ff1100000779ebb8
> > R10: ff1100000779ebb0 R11: 0000000000000246 R12: 0000000000000000
> > R13: 0000000000000000 R14: ffa00000001efb30 R15: 0000000000000002
> > FS:  0000000000000000(0000) GS:ff1100011c0e7000(0000) knlGS:00000000000=
00000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 000000000251ac88 CR3: 0000000009d6c000 CR4: 0000000000751ef0
> > PKRU: 55555554
> > Call Trace:
> > <TASK>
> > ? read_ctrl_pos+0x22f/0x3f0
> > shrink_lruvec+0x16cb/0x1b80
> > ? ret_from_fork_asm+0x1a/0x30
> > ? lapic_next_event+0x15/0x20
> > ? clockevents_program_event+0x2bb/0x6f0
> > ? lapic_next_event+0x15/0x20
> > ? __pfx_shrink_lruvec+0x10/0x10
> > ? __pfx_clockevents_program_event+0x10/0x10
> > ? _raw_spin_lock+0x84/0xe0
> > ? __pfx__raw_spin_lock+0x10/0x10
> > ? kasan_save_stack+0x30/0x50
> > ? psi_group_change+0x381/0x740
> > ? __pfx_sched_clock_cpu+0x10/0x10
> > ? save_fpregs_to_fpstate+0xc4/0x2c0
> > ? finish_task_switch.isra.0+0x1de/0xac0
> > ? __schedule+0xf62/0x42c0
> > ? __pfx___schedule+0x10/0x10
> > ? __pfx___irq_work_queue_local+0x10/0x10
> > ? shrink_node+0x626/0x31e0
> > shrink_node+0x626/0x31e0
> > ? ring_buffer_unlock_commit+0x11d/0x5c0
> > ? kswapd_clear_hopeless+0xa0/0x150
> > ? __pfx_shrink_node+0x10/0x10
> > ? 0xffffffffc0000095
> > do_try_to_free_pages+0x255/0x13b0
> > ? ring_buffer_unlock_commit+0x11d/0x5c0
> > ? reclaim_high+0x10a/0x1b0
> > try_to_free_mem_cgroup_pages+0x1f9/0x5a0
> > ? __pfx_try_to_free_mem_cgroup_pages+0x10/0x10
> > ? irqentry_exit+0xc6/0x670
> > reclaim_high+0x10a/0x1b0
> > ? __pfx_reclaim_high+0x10/0x10
> > ? process_one_work+0x5ff/0x1030
> > ? __pfx_high_work_func+0x10/0x10
> > process_one_work+0x6e2/0x1030
> > ? __pfx___schedule+0x10/0x10
> > ? __pfx_process_one_work+0x10/0x10
> > worker_thread+0x422/0xbb0
> > ? __pfx_worker_thread+0x10/0x10
> > kthread+0x2cd/0x3a0
> > ? recalc_sigpending+0x15c/0x200
> > ? __pfx_kthread+0x10/0x10
> > ret_from_fork+0x368/0x590
> > ? __pfx_ret_from_fork+0x10/0x10
> > ? __switch_to+0x588/0xf50
> > ? __pfx_kthread+0x10/0x10
> > ret_from_fork_asm+0x1a/0x30
> > </TASK>
> >
> > Fixes: f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of dying me=
mory cgroup for LRU folios")
>
> Hi T.J.,
>
> Thanks for fixing this.
>
> I have one question about the Fixes tag.
>
> The changelog says that, before f1cf8d2f36dc, memory usage above
> memory.high kept the memcg reference count non-zero. This is true for
> LRU folios: before that commit, each charged LRU folio held a CSS
> reference until it was uncharged.
>
> However, I wonder whether objcg-based kmem already provided a reachable
> path before f1cf8d2f36dc.
>
> In particular, BPF alloc_bulk() mostly runs from irq_work. It obtains a
> temporary memcg reference from a persistent objcg, uses set_active_memcg(=
)
> while performing __GFP_ACCOUNT allocations, and drops the temporary
> reference after the allocation. The charge can therefore queue
> memcg->high_work in non-task context without transferring a CSS
> reference to the work item.
>
> If this races with memcg offlining, objcg reparenting can redirect the
> objcg to the parent while the old child's page-counter usage remains
> above memory.high. Once the temporary CSS reference is dropped,
> mem_cgroup_css_released() can call lru_gen_release_memcg() before the
> queued high_work runs. The worker can then enter reclaim_high() and
> rotate an already removed lrugen.list.
>
> This path appears to have all the required pieces after:
>
>   e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
>
> Commit 6867c7a33206 later changed the release operation to
> hlist_nulls_del_init_rcu(), which explains the exact NULL pprev seen in
> the reported crash. Before that, the same invalid second deletion would
> instead encounter LIST_POISON2.
>
> So f1cf8d2f36dc clearly broadens the problem to ordinary LRU folios, but
> I am not very sure it is the first commit after which the underlying race=
 is
> reachable.
>
> Is there an additional lifetime guarantee that prevents the pre-f1cf
> objcg/kmem path above? If no, would the following be more appropriate?
>
> Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
>
> Thanks,
> Muchun

Hi Muchun,

Everything you said sounds correct to me. I don't think there's
anything preventing kmem from keeping the memcg above high while the
refcount hits 0, and hitting the same problem in
lru_gen_rotate_memcg() from lru_gen_shrink_lruvec().

So using Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node
lru_gen_folio lists") sounds good to me.

Thanks,
T.J.

