Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FE55C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 16:36:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CF266B0005; Fri, 10 Jul 2026 12:36:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A6896B0088; Fri, 10 Jul 2026 12:36:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED9C76B0095; Fri, 10 Jul 2026 12:36:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C8A2A6B0005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:36:08 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 654431A04EE
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:36:08 +0000 (UTC)
X-FDA: 84973419216.17.5111080
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	by imf19.hostedemail.com (Postfix) with ESMTP id 713591A0006
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:36:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=cloudflare.com header.s=google09082023 header.b=JxrBLeZu;
	dmarc=pass (policy=reject) header.from=cloudflare.com;
	spf=pass (imf19.hostedemail.com: domain of yunzhao@cloudflare.com designates 209.85.210.50 as permitted sender) smtp.mailfrom=yunzhao@cloudflare.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783701366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a90Iq6PaIckOPj+VO+r7rfW0rIo+Fa8RGIg4zgx95ak=;
	b=Kew9f/JmiQbOEdV/0cNOMi8U4z+aTRX4n0Ns2TXSkC1748ADwLvT0Uo/rjlc59BKJ+K9af
	C4PeBKI27GTecFW7RS9hXmpPF29Ki3D5gnj/N7YE6ICMHynYPVOR4s9cg5kgZNVC8e+Lsy
	5CliUWj1Vr7P65Xf7dYTl035KXsSnFc=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=cloudflare.com header.s=google09082023 header.b=JxrBLeZu;
	dmarc=pass (policy=reject) header.from=cloudflare.com;
	spf=pass (imf19.hostedemail.com: domain of yunzhao@cloudflare.com designates 209.85.210.50 as permitted sender) smtp.mailfrom=yunzhao@cloudflare.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783701366;
	b=nPIdVKzrorzOIgMK/ELq8MrMLsOEVgrHrOanGJOUFpZq5kNCz6VFyeo2yNlHRDyrTSTDXo
	GhUuQCvsTf8j1Z5E5W+INtN5nO9fch35b1SWgJKr+ffSR3umvDk6zDEz0SljEKPu7IhtC9
	oqr+R+yzHTw7PaeCS4b+7DIc9mO6BQE=
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7eb34c17b96so761836a34.2
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:36:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783701365; cv=none;
        d=google.com; s=arc-20260327;
        b=Mz9t3Sh06Fj4Odm3YulRg+m4q4x1gREKVb1T0WVDvlQANqNRedp2XXhcKpw43h+Vhz
         4QiO+gaMeWvAWU2f1V1B0ev2vnAwAICtCmQ198RLs5sPOK6UalrT/lFfT5o586M/i075
         xcmYkolfTGcEuOFEIYvDuTZb3wiMK8N9C5R2poV31g7B6vOEm4qSXHJiC5tf6u8/hgdt
         YQPCZk83TzR/5duvaqejSpPk8lYqn5wuX3OAcgIjNRWdn1gRISLde//HcTGrw27Fcyz1
         gjFLOP3xOP6iOyOJDV4w/+bhg9OB7N4AS1wF88Ca9Yz7GIkmgl+GMcmBF0i3Y8FU4dqH
         zxOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=a90Iq6PaIckOPj+VO+r7rfW0rIo+Fa8RGIg4zgx95ak=;
        fh=crbrB4YGeWoXzvqz2C7tG5H2UawHJhWaHd91EE3W1bU=;
        b=P5O1b0F8BL1YB7Jeoaq46mkiGO+hvCFG741ahp2l2NoW/vn39j+tFZGKM1U4sXTtA9
         27/vMJurooRo+fpBQ8AB2lQhJyZsXJ79jIQPdygpRAzA2U3Xo3tQF3WXJyXvFLS49LsX
         hRxbVgmkfIxVgRkKKlveK/pgUTCb3j32a6htF5c8iLvycr3Baptyjfadr8qA3bnTCsy9
         Eq1oURsnOrkNOPtvCZK3lS7HKAAalwdS6t54gb118hMbOBOVpyRfRFRSbVrciMYM3Pjq
         ZBsoaqCHD7nlG5lUdGcLKixIl0kjkS5stxX0dOzGNQsOZzKmB2CK74OVM8ntFaeWgy86
         jHgQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1783701365; x=1784306165; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=a90Iq6PaIckOPj+VO+r7rfW0rIo+Fa8RGIg4zgx95ak=;
        b=JxrBLeZumxKP33RCBLCWnSU4xu5CDBkfw27bOykvSqYPvhN9h9Sztt/WlC/VIh7AFW
         6ZM8EL50dUKiVXst5s9tCm4OZSdpK+0s74FyBMVBt5SvF+skEYdXQC8BFgQ0ViwvQUe7
         NjUjzW8LjkPaU14imkgG4AWnwGXFpuZjLKi489kxaqR+6PbkZAE129xxOVObNn0c7+ZR
         idtjE7/iDwk9ayUfGZzNFwDQfELCDZsNAjk2UtMKaYFsw1GSRVhRsQ3EgQHTPTXV3/4q
         aXVsfwpuNdkAW8IrpwR2nHopPdEiEd7UB8ma2dNWfOQYoSf5GAaeTKbrBu+4kY83z944
         ktHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783701365; x=1784306165;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=a90Iq6PaIckOPj+VO+r7rfW0rIo+Fa8RGIg4zgx95ak=;
        b=fNuIDorNqmDanoSINYhxSl6JTdxOBgzZXcmyldLv9IwIl3tjx1xkIP8GoeiGRTwR4D
         IYOLGp49/LT4xR8JthNB7phvjxvVWBENYNUR0SoSckqG//CUod2Nf63yvn//CkhH4+rj
         kpgDILEhismnE7gPYvONjFqc4LI/8FDBPhdy3J/jAXy+VLG1C+KW1ub1yFVk0wZ10TNN
         AhPdR2dKELfa08GfAn8i0gpLIERZCoZdhbjnv6TRWSh15HvYLPQc6uN0G4hWnpyoFgHW
         bguTE2tjc6B9aNqJ4Zmob8oJeshzJeDh932LdbsJlsCvHaQ95ari+q6FejuKrhZWUpR4
         WNaQ==
X-Forwarded-Encrypted: i=1; AFNElJ9qqenM/rgfuvzm1Ll9xX0jfFtiLJV+LvJ7B2lqRW56qptYTldZxLBYxHwzhPMyF2uWNgwS3B85yQ==@kvack.org
X-Gm-Message-State: AOJu0YyFHx2tc4T8j6pIvXRzI6bfEpCMipZySIDetFerkCHS8MsEHlc3
	Pjyh2GhpcRLNuP7Qu87fImNGxZurp9hd2iKSQEAMtmvA7a6oAR5kMbTRjFeVDEZsLRhrVO1ov3g
	Bho7BHjZYcITnKjyQP7XnZO0PVJppjD3DyxoIsWp1Hg==
X-Gm-Gg: AfdE7clJZlx5SMY9CVNtk6MLxs4K4FRcRGXMw/l2eKpIThkI6UP9z+V3NdWei0j/wuP
	yhH3US/01sYEjuo2vvrHKbyYNc9kR7JjuIJzHLOYb8gW/xnYzp/QUt1d0nI0DseZ8gQEgU1OxEH
	MW8HuOhobzR2hUHWCxCIVHPVcyJW50zeactuXatJuJKsCcec9CTje5K7u/DYWW+zS1o+y/mQ9/T
	Xl3zt061oQ7OIPx7iqyyC3E8mRxPp1T2LNx+2ctun9dl+EDISH1YArEn7Qwv46Xy1ntFtKLDEjz
	3z9qDWaqPkFgvIQ=
X-Received: by 2002:a05:6808:d4d:b0:497:d574:6155 with SMTP id
 5614622812f47-4a206015c88mr8866635b6e.33.1783701365275; Fri, 10 Jul 2026
 09:36:05 -0700 (PDT)
MIME-Version: 1.0
References: <20260702180908.150136-1-yunzhao@cloudflare.com>
 <akbHBZP9HxOJMtQB@cmpxchg.org> <CAO9r8zOiwgG80EjqdZFgWQvODUe1RzecLemxcB7xXNm_f3XfbA@mail.gmail.com>
 <6ecf5579-0b3b-4e8c-a625-bbf0a4a48f94@kernel.org> <CAO9r8zP6JrZcBnzb8A3A9V8so4gJMWLvrJQ7VwPyyU417GikQg@mail.gmail.com>
 <CAAnvDSyNbV5xSH0hrX9Tgw_wXU7Neo-XSJ1enebxJXvjOheHWQ@mail.gmail.com>
 <CAO9r8zODSyYTipACxdEzoheMrNKzfFt_tjBzrB+2tSCHA82WWQ@mail.gmail.com>
 <CAAnvDSziZM9TOExkFrF9vNi4VN=7T6yofS-=4rmFqc3jXncveQ@mail.gmail.com> <CAO9r8zPuX0j_fZsgRsaNQFyJqY4rZxERLya69TcCF83HrpHy-A@mail.gmail.com>
In-Reply-To: <CAO9r8zPuX0j_fZsgRsaNQFyJqY4rZxERLya69TcCF83HrpHy-A@mail.gmail.com>
From: Yunzhao Li <yunzhao@cloudflare.com>
Date: Fri, 10 Jul 2026 09:35:53 -0700
X-Gm-Features: AVVi8CcGF5c25J4HlW1oB2HhLk40jZypYqV6bk3n4fZdznq2iDgxcNgwPCxE6W0
Message-ID: <CAAnvDSyDYU4MvRo1rNwxQcnmwHe2_UW43-hZEU-Zf76B2euYQQ@mail.gmail.com>
Subject: Re: [PATCH] mm/zswap: use ratelimited stats flush in zswap_shrinker_count()
To: Yosry Ahmed <yosry@kernel.org>
Cc: Jesper Dangaard Brouer <hawk@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, 
	nphamcs@gmail.com, yosryahmed@google.com, shakeel.butt@linux.dev, 
	akpm@linux-foundation.org, zhouchengming@bytedance.com, 
	James Houghton <jthoughton@google.com>, kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 7k36tg999fgz33c54ww6tzm189hwkg3t
X-Rspamd-Queue-Id: 713591A0006
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783701366-193582
X-HE-Meta: U2FsdGVkX182iZu97RckcvHOKSgkmT7jigqolukJrISZRN4mNpXfb0GI68/ichRigDAHN3W8yqXfMbe47tirdoxfmPWm74vpqCvWGptz4481H1e4L0G5Sto7tHZiwoS8Eo5IjXlWKtJGnbd+xPLm1U1NfFHNi8BKZNr2BbQio3n9X7L7gfgeC8sS4WtjMNOpNX2+gwwmqQ0g2n3Wg0blMG9mwgLlA1MllvAN2Qx/TozkX6DaT995OWgewG+vHL6jZlJxWMcKuDBuyFtzfq3KMzqbhcIpENPjam9lfEExL+xCi9OqW1hE00jPiUdnLiYT0csz2N4is4JhfaURvLjBc5zMGVjf9ckqgeSgu4cqEWtG9HiRnH0IuSlrslZCdVGbB/tERjliUCeRGZk0PwQdtpvrrT3tcqW6JtWWPaeaz2HfNatmig6tDWhFDuAXansdJbaI1mrEcmZc+vKy2vhcjplBMSXjrcrofZ+0Zs3XJV7FGJQ0/8zjR9hVjPdmXmfKzXG4SxjqvSwlRD7vM/35vCnAcJj23xmtf4dkuQvV9ozx5+3lHQPNO4Tt2NbNs+9LAKvVK5HtkLeP7ZfrlZ+XJcIO2YyaATibrzrSLJntedk2VDZzro9l0pnfuQrocw2UnBbVFaaflbdoOD5zmKobYCGMwbLr81hVUfZSDhv/kdpZU9f3HPcrGAuwxKnPUcVBVTsJTY46M0BwDqz238wgMRpfwTQd7vjA4PLnDDSYvnbQb631+pz1uwBdaanFuJ+ptqLj074DEmkEl9ist5rokEpjZchmEqzfo4I/Qx+brqDCC09Qd9r108H+XGxU4CozOiUPfNn39BbGXAqxmBZ5ayCK3pPmsGhfZE20FwK2FTdbZs2hNWl2QYBB9f5di+NDUFgzSC18f9QiiYF9IYf1teNi1Dzfcvsl9+OevpGGfRFrKm3l2PLg2xiXwE5YTE/EBMzoAiHfw5i9k9L8zM6
 kml2UFeL
 878ggg8hpICbPnROW/PV4juiSMJ64U+7xHsKTlMoN1bQooPJx0P5WpasOP0LYHHW65ozom6DBXQQ5OgEwATp/IGkBMAYm/9ZkLp/3+Uz/RZ5KsHyUNt9karHTBfwhXhNkZDc9mxhsnEoG1vlu6/EwiPSyeXERKy5YIPgYDidRFeJ9QfPJiHNLHNLF/1wTPAz8op8oH72VA+H60lz9BQmjSC8Z3IEOIQrZ8jQehTER+H3fjMk4VnCGIVblYMZNrKggPx97pDzr6y2uy54Cz5t0SUGLZjRQ72cUQ3YGR54yNmppoyNv8TL/hoXLSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Yeah the per-fault latency is exactly what I was looking for. Seems
> like most of the faults are not faulting in the pages written back to
> disk, nice.

Yeah, at least for our workloads the cold entries seem to
stay cold.


> Would you be able to take a stab at eliminating the flushes as I
> suggested above as an alternative?

memcg internals are a bit out of my depth to be honest. I can
definitely test a patch on our fleet though and get it verified
if someone picks it up.

The ratelimited fix in mm-new is working well for us in the
meantime, so it'd be great to keep that moving forward.

