Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C582606A329
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 09:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lcmEB/R6
Received: by kanga.kvack.org (Postfix)
	id 6D7896B05B2; Wed,  4 Nov 2026 04:08:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B0B56B05B3; Wed,  4 Nov 2026 04:08:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C64C6B05B4; Wed,  4 Nov 2026 04:08:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2FE686B05B2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 04:08:56 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CDF0F160658
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:08:55 +0000 (UTC)
X-FDA: 85396861830.19.D426BB7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id D1352120004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:08:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="lcmEB/R6";
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793783334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CwbssC3IcsbRd7BqfSzfMYQRORQNQUvKDFxxlCd3lXw=;
	b=vCgIaFKDI6EzI6tNYIadu8RvWKTM0W9MN/FKLg8yzkX6bvIpYoGpvi812HDukl/bxTOjrN
	UHNxtNs3M/rVuAZktrVom3pRn8dpqJg5PVXXJkBC9zHIbsy/UzgywIWyMzddNGslsHIIzF
	f60sTt4ZGn2gZ+y6/m0fkP7uFFhkosA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="lcmEB/R6";
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793783334;
	b=CGEopNX8VMDEgRWsUQVXYuGKfeEwHdTnXDyxlmVzufJPA31f5+AmiEdMD/lNclSAV/X/l5
	HTfJ8hyorqPEXFPOaDtL1Raij0hL2gaFPNYrIJNjxPREsd3R35OWAiULyeuPDOcxdva7Ct
	1ZPqI/3IZr/AJX5pHXQXMiXtitcifec=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 353E243C52
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:08:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB581F00A02
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793783333;
	bh=CwbssC3IcsbRd7BqfSzfMYQRORQNQUvKDFxxlCd3lXw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=lcmEB/R6akcJdDRia+T5rGWp4agY6KiX6qiYpvTJ8Fi4wSGBW+ouMzIM5xhJhtIZc
	 PQyrh00XtISp6tP5KqjmL/pDsx77Y9YjVQ0kFn7NF253J0OaGT1WoEi3v+p1ujRkn2
	 ga4TmCjxu6LdUp3QZEVh5/CpXTzkW+bLSzcwn2XnlXUC6Kk0WEBJ48IlxV2S8q6663
	 n0fHi8hMv9XYd7VYyaHE1tZehMNWE58GKgF4ego9G7B5eXG88JagfLL6trQlQEbiWG
	 YQXc+0NZsUhcha6BMuUCRFC8IzICG4U0Rmr955GgZspNXBcmXauXEJ6qCHI6wCqs3v
	 bg3pzAcT+tlxQ==
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-5eafb65e163so311673e0c.2
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 01:08:53 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBy/V0dTYdJgjk/I0Ybo0zZ1TuKoB+NuE5eH1D+3CHpsZr9MTnwSKNw11vHDUzdSvfM866d0N/jSRQ==@kvack.org
X-Gm-Message-State: APuU4Z//D7K8XjqK2e6MbVhpwmOaOgA4ub9GVvcY5ud+JV70Vbs5+Hxi
	uHlnm20zNjNTVKWMb5hFcNjoXVzQuOHMOOJtNblW0XyLT1jlJV+lGSqVnzdmqm7rJe4DGok95z0
	jVZiLoZY4xhGHnNFUDzakK7SKgkz+U/E=
X-Received: by 2002:a05:6122:3108:b0:5e7:8bd1:731f with SMTP id
 71dfb90a1353d-5ec6897757amr6563644e0c.10.1793783332317; Wed, 04 Nov 2026
 01:08:52 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261103113711.1832834-1-max.kellermann@ionos.com>
 <20261103113711.1832834-5-max.kellermann@ionos.com> <CAGsJ_4wpd-e+xjm5KwihVziAeVnQp3XYG=+-BKmx0SVEhmyqqw@mail.gmail.com>
 <CAKPOu+9textOydxZYng=Bo9Sf91Wq_7rv5r2pBrhXOfiex=qGA@mail.gmail.com>
In-Reply-To: <CAKPOu+9textOydxZYng=Bo9Sf91Wq_7rv5r2pBrhXOfiex=qGA@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Wed, 4 Nov 2026 17:08:40 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zzZZSaAwG=VLhuMvoD0YcAFdqyUr-8zRSibNw28j8wzQ@mail.gmail.com>
X-Gm-Features: AclHuK8306bVpFSltXAI1ZXaA68bWTketiXOy1YGPxl8Unk8QhQOKTXLATnYAlc
Message-ID: <CAGsJ_4zzZZSaAwG=VLhuMvoD0YcAFdqyUr-8zRSibNw28j8wzQ@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] mm/mglru: avoid redundant rotations of young memcgs
To: Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 95mz3cfx59kswsywfmtcycfze4rfc3pz
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: D1352120004
X-HE-Tag: 1793783333-450263
X-HE-Meta: U2FsdGVkX1/v674gtzdmYhvlLQkpGxNWU7dcV6vP6eFb2EdzU8L2SZ6/ZqEN9DMTu+By1qKTldqvlmWlmJNszTjUq1xSIg60jsI3zH3aZxj+VkOvzzHv3Tty0/9n0UGqdYzHeP/6dPZ0qFB9PEwnOHVUcL1Vtj2GkssFJA44frFjorT6pTLPZx9z8JEZGBtJy5+Y/tFaisNH6DLLPgZl4yyONGqyhuuSv8arFatf99AjGRj08HohPGuvHy5zmhd31hZ3lgOxynE2UdX7WLC3dgKQh2rdFsCSZBXv60TkeqTETO+Orb152ATlJz3isVLAA2gcuQMiTSNXyKbdoirRPGbWvrZtLw4cEEma7i2VL3EBoJVNK9vY2HzeJWlwRN9FDCoSN04+BGgqkDaO8dBOJtBRTkg3VSpg1dHNNDlFvBQbcniU7pyMi0C52OhZZWeH1EKh3/lztVg0CT0jfR8wT5i9Sc9i7C5XkmVuAlMIpya4+K3dYpdsdMcBO7LifQhAaHqLp1Uxds0143Jmj+Z4s82oItYIzI7wFeP3ays5IsXkHQU1OztgzIoUUeEATQ93cWR/4EUcaOcpeo/Q9aui1ZMt+7pVwbgfX0oB/KDSuTCQsA3Oke+Jxm1sEB1HSUpNgx033xyN+bBbi6clRCqUNqxEgen9xokK70fxv5rPZKLGANcW42V3FZn9Aq9bG/udzcFqFBpH+xjb0qEWk8rD0jeWZvBJ0cMDvRD+Uqw2dRWxw86iVR/0U/7KVOJsn9aw6LDV1X7IG4sYVpVWM5ZJmdzHLs03c3saSTzVNw233Ck++davS79pU9ngOkWD4nxVf4aqGplB1SM3CMXHXv0wvPm+JLtKba4rtt5l0G9IJ8aaRVUWY9rodla7151wCns/djbpUwuNkbqk7778wveEqo9dcp6vql16GW9y64RwOPI4a0HYyxCPUTFUv5iPFq8f+lNm/7nwKRtPuymLIOe
 LLiuSaox
 fNrasHkSEKCBwACzOdvz0FPdLYrqnOfnjZjpncIGxXINoLPSxNWx3hmor7lpAGGspAQWl1mUfc80rkTEbxcP7Ckh8QFNERQAytpiG0IGpnBftz0Y6i7Or/ib98JBRPXBcNlvJJsjqWljUh5RuQd0d8bMdmxcm8O36R9+6+5hTeVxmZaWVKgDuVygBSUlhIph6Ri3mOr/1qC9dX8cY0k6zk3UTnW01mOV5AF7QqnXFj5p4/jg1bn9sZkyICRVTS4QNEXfGBt+P2Lw6orWsdlg7H7FYb7gjT6Z/y5OCx5NYXVyDJuGPKPNcOhaTRLiQ0jc1On6nHp1VijXm186YxfdIenMmC2N08okTgs/MSNL4HIXe8Ei+zt6awjs7EQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 4, 2026 at 4:27=E2=80=AFPM Max Kellermann <max.kellermann@ionos=
.com> wrote:
>
> On Wed, Nov 4, 2026 at 6:18=E2=80=AFAM Barry Song <baohua@kernel.org> wro=
te:
> > > In my micro benchmark, this increases the request rate by 36% and
> > > reduces the average duration of each write request by 27%.
> >
> > Could you share your microbenchmark somewhere (or post it here
> > if it's not too lengthy), perhaps on GitHub, so others can
> > reproduce it? You could then refer to it in your changelog.
>
> Will do.  A note of warning: it's ugly LLM slop, and if I had written
> it manually, probably 99% of it could be removed because it's
> pointless garbage.  The LLM wrote it for me before I had any clue
> where the problem could be.  It helped me find the problem, but
> uploading this garbage triggers a bit of shame in me ;-)

Thanks!

>
> > I think this is a correct change. I wonder if we can
> > reproduce the issue even without concurrent reclaimers.
> > In other words, can a single thread running in a
> > memory-limited memcg trigger it as well?
>
> Your question is not really related to this [4/5] patch, is it?
> Because this one is just an incremental optimization on top of the
> real linked list scalability issue.

I think it is related. Although lock contention isn't a concern
with a single thread, the early goto unlock could still save
some CPU cycles.

I can imagine a scenario on a system with a large amount
of memory, where a single memcg (e.g. one running a kernel
build) is limited to 1 GB. If this is the only memcg
constantly being aged and rotated, it should remain in
YOUNG most of the time.

We could still skip things like:

        hlist_nulls_del_rcu(&lruvec->lrugen.list);
        hlist_nulls_add_tail_rcu(&lruvec->lrugen.list,
&pgdat->memcg_lru.fifo[new][bin]);

>
> A single thread means there is no spinlock contention and the linked
> list is only walked once.  I don't think the problem is visible then.
>
> > One thing I noticed is that you may not need to call
> > get_random_u32_below(MEMCG_NR_BINS) upfront. Could you
> > defer generating the random number until you actually need
> > to rotate the memcg? I wonder if this could further improve
> > your microbenchmark results.
>
> Good idea, optimization added for the v3 patch.  I don't think it
> makes much of a difference, but it really makes sense.
>
> (And I still hate that the Linux coding style requires having all
> variable declarations at the top.  Code would be simpler by
> declaring+initializing variables where you need them, and additionally
> it opens more opportunities for compiler optimizations, but... it's
> the way it is.)
>
> > Anyway, the compiler might be able to defer it for you.
> > I'm not sure, though. Could you take a look?
>
> The compiler is not allowed to because it is not allowed to make
> assumptions on what get_random_u8() does, therefore it must not
> reorder the call.
>
> (I wish C had a way to express a promise like "this function call
> won't modify global state reachable by the caller's pointers", there's
> just GCC's "pure" attribute which is too strong here.)
>
> Minor note: deferring the PRNG call will move it inside spinlock
> protection.  I think that's okay, but it can theoretically have a
> performance impact, and I'm not expert enough on this part of the
> kernel.

Thanks for pointing this out. I missed it.

It might be a problem, as it could increase lock contention
by holding the spinlock for longer.
Only testing can tell for sure. If it does increase lock
contention, I think we can simply keep the redundant
random number generation.

Best,
Barry

