Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 741B2CDB46B
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 22:52:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 284316B0088; Mon, 22 Jun 2026 18:52:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20E816B008A; Mon, 22 Jun 2026 18:52:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D69F6B008C; Mon, 22 Jun 2026 18:52:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CCEDA6B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 18:52:20 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 30C871202EE
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 22:52:20 +0000 (UTC)
X-FDA: 84909048840.15.5B7E505
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2C8E9C0009
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 22:52:18 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZIOxnaKa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782168738;
	b=m13PI0Ny3y4Qy8zSoMhHWOe/rqDk/Af9iJ+QcADeo0NeU9IS4KHArBr9V23DjSs381YPhI
	Zrlfc1rTdBjAEZvKbRNbEUD6oEuDy7bCeg3hvs4VbaDkexz60u69Z6Z3/aTliFeyb1tCJX
	7hOO+NJqTVSn3Qn6749cVSB59Qg0BKA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782168738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sOaJBY2vYbjxJ/JpG7DCE2JRLzNVwpwwc0x2I1M0tkU=;
	b=DS/dSf/JzdKopQPgmgQ8KXlHbGPfFR3eJBqgmqvKq9DEfGnBNx6dCrKoklQJat82ce4yBH
	xze0IKKRuNHZHYVJmS06JEcdC1tL0mE5k2iySp7d3MsMdpWM00EeJO6j9oZUrrsC+iRXzP
	NarDU5/yA/SeJhyHEHnLvGSsnJ5HOxQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZIOxnaKa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 57B724456F
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 22:52:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 207031F0155C
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 22:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782168737;
	bh=sOaJBY2vYbjxJ/JpG7DCE2JRLzNVwpwwc0x2I1M0tkU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ZIOxnaKab5p1n/3vTLL9gXUkmX2oYBpiSSI4S1Uk7/8zrSjEy4ofyrWXKIk/7YAyq
	 EIWbcTgfeqfpaQWtp89e++0rRLLoJ0jGyKhsnjB+nA6RbCXJ2urbaNlaVOEpEksnW0
	 +NI4Tmh/r5FFEazkOrnPF0cVnldvTgPEBCCRpUex6WgBu2wzruGpvm/KQOV+dnCnNS
	 2je8b9x8rWa46d6mP7P07hk5/7kSuu2lJbxdTTY6b17r6cfiux0vCxtYj3MsoFF12U
	 oeTNV7yKN5OY2kcDbfFvqAeGWTC3dPTMtHQym47+ezpqjj0ahN4oJt7s2Gsu0SJIV3
	 6bUTMmOdJX9xA==
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-9158fbaa4bbso562172885a.1
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 15:52:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/vLb1kaqZEIL+gFGW9u6cdClfrDiB5Y82wtywh4ZT9e2TmE7/aDbbazv3nZBTKEJ68Vskp+yhhLQ==@kvack.org
X-Gm-Message-State: AOJu0Yzs/2JyW8+rmtODehT6AY7CPS7Q+YnyigexP7fkIcb6yTGL3OLk
	zot5t1BQVRHGDAwj3/d9GZDk7I5QHsCX2qHgZgduQ/zKgOTIWgxD1RSXn7x+2nQp0rMiggK9yaA
	jbLc8GP0GPrEoS4AcntgOANPxwvNngao=
X-Received: by 2002:a05:620a:a2c5:10b0:920:be30:2d38 with SMTP id
 af79cd13be357-920be302dbamr1837599785a.9.1782168736458; Mon, 22 Jun 2026
 15:52:16 -0700 (PDT)
MIME-Version: 1.0
References: <5A9E929D82717101+12fcf643-efb8-4b9a-a53a-1e28cc894f0b@smail.nju.edu.cn>
 <20260622073703.79258-1-qi.zheng@linux.dev>
In-Reply-To: <20260622073703.79258-1-qi.zheng@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Tue, 23 Jun 2026 06:52:04 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4z34ZRu_RKkaZ7EgTWMOxptUjZ90WJyNoJrXGNjzutxnA@mail.gmail.com>
X-Gm-Features: AVVi8Ce0foZMj_P664AgKaMfmRLO4b5-1jEQyynf-QVbFLWZ4URCnbuGkwqxqQo
Message-ID: <CAGsJ_4z34ZRu_RKkaZ7EgTWMOxptUjZ90WJyNoJrXGNjzutxnA@mail.gmail.com>
Subject: Re: [PATCH] mm: mglru: fix stale batch updates after memcg reparenting
To: Qi Zheng <qi.zheng@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, kasong@tencent.com, 
	shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, hannes@cmpxchg.org, harry@kernel.org, 
	muchun.song@linux.dev, peiyang_he@smail.nju.edu.cn, mhocko@kernel.org, 
	roman.gushchin@linux.dev, ljs@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2C8E9C0009
X-Stat-Signature: wjej4u1i9sjh4yfnf8wd5kemokiw5pkw
X-HE-Tag: 1782168738-458925
X-HE-Meta: U2FsdGVkX18OOhUY8ZgGY2dNYUHNstS9k6JyGs3+lxFCIYhOVjI3RzqSDXj8/HPNopAZwBZHSPsGi9Ov+JDmpd7jjOB5Taew36bVKCjJ7J7ZTJJHknv4AiaPJMzmLF864FAj42MJNGN9mPNsLF/eG6zMnHPKQQSHj6gvFtq7mCNYohpMTfKShujBmvUvYfSe88txupN3LUO/0zhcVTk3aC1gY9cpHFWuYwqhnKDWai/dTo0rr2/8zEHmhIpud2m54GDnP9+AkO7aDZYs4id4FeIOnUPv7dUhbELwOe3ml5wy85CC9y2ZJpO8TOPhM8nPOQxqpwL9ds0SszdI2ZollpmoXGe/5At6anfTePBl5fMoc+L3fbSh0k4wvfmutjroRX3+rAydxv/eSePHJaaO8OUf2P9TAndEyEBOyZYoZwRYtjwZirpg6IjrLETIfwKtFwdYpEF6FQ37bWrbNwaeYQKB6akhZFx9S5Latl+QBZ57pjdrGeNZ86ssnqdC/L4Q78k0HR6VryyU3n67iFvYc0IH7zTImL0wbLQbJQNLYV12I6YmnDWdJvKgNmIY+YsN3XCpU5U3TkGfWZzZ6rpUxL7ckon4rRhQ17NllQR5Y063B/87aYIOyFvJIZhSLYp+t5Knx2w5qj9iLJyoS2b+E1jY698PLwYfsqeEX+8ZK8DuNW8yOj3+SfilN20CwM+rYMyHbCRLB+WKAdrHg/pPxECJIxjKGaRN+NtkjADYyn6heMh5Jtvt16SKLEecnak55kzPuyP+lRL9ZnnkKdMGztc8c0eX9/jD8ETQq7RrVA9/atpmohFLb1THnf5O1DgQC1Ba762mU/6s3BTBZ76E260w33i0Ixr/VdrKiVvHOpGEaRqh35D28ic1NUG3XkbdSd4A1A//xN2YN8vPw5qW1qN3P/q+eoXDdcTKDQ4uUbP9JtHgXIPp0xWnazGsx6EKs5SyMwnEOorEZ3kClUg
 VHRdvUIz
 IX0HJ3shqxDnyg3SZqA9uUCARMOUPl7IZuFtUB1Zu+m4Yy3cDQpAMHNPnNI4n2/jUTbcJ1l2PRv28im8wW1L5pHVeJUnXb0Qp7j9geqItgPppy2LNcMKKoGHkEs+KnXrJK93iPuCrE7LxlwSh14G3UaRpnCmnBBWHZvvt+FwkKnvxTmRkEj/KDY7MfNMM3zMCSMqABhVlSowFmHpL0QV1nYLyTbTBEwYj5rdMIXaoD95f+JVL+tHJAe7SFHulvqxVjvJLmdAG99KuacEQ9ru0qZYS2q9V1cr8ZSFX8cj5bkpjW2JICOpeXwGLAo9ui3ayzDW9MmqhGve2XYY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 22, 2026 at 3:38=E2=80=AFPM Qi Zheng <qi.zheng@linux.dev> wrote=
:
>
> From: Qi Zheng <zhengqi.arch@bytedance.com>
>
> The mglru page table walker batches per-generation size deltas in
> walk->nr_pages while walking page tables without holding the lruvec lock.
> The reset_batch_size() later folds those deltas into walk->lruvec under
> the lruvec lock.
>
> The page table walker can run concurrently with the memcg reparenting pat=
h
> as follows:
>
> CPU0                           CPU1
> =3D=3D=3D=3D                           =3D=3D=3D=3D
>
> walk_mm
> --> walk_page_range
>     --> update_batch_size
>         --> walk->nr_pages +=3D delta
>
>                               mem_cgroup_css_offline
>                               --> memcg_reparent_objcgs
>                                   --> lock lruvec
>                                       lru_gen_reparent_memcg
>                                       --> reparent child folios to parent
>                                       unlock lruvec
>
>     lock lruvec
>     reset_batch_size
>     --> child lrugen->nr_pages +=3D delta
>
> This can trigger the following warning:
>
> WARNING: mm/vmscan.c:5867 at lru_gen_exit_memcg+0x26f/0x300
> RIP: 0010:lru_gen_exit_memcg+0x26f/0x300 mm/vmscan.c:5867

I can't find 5867; instead, I can find 5828:

VM_WARN_ON_ONCE(memchr_inv(lruvec->lrugen.nr_pages, 0,
  sizeof(lruvec->lrugen.nr_pages)));

Is this the warning?

> Call Trace:
>   <TASK>
>   mem_cgroup_free mm/memcontrol.c:3972 [inline]
>   mem_cgroup_css_free+0x76/0xb0 mm/memcontrol.c:4241
>   css_free_rwork_fn+0x125/0x1260 kernel/cgroup/cgroup.c:5575
>   process_one_work+0xa0d/0x1c30 kernel/workqueue.c:3314
>   process_scheduled_works kernel/workqueue.c:3397 [inline]
>   worker_thread+0x645/0xe80 kernel/workqueue.c:3478
>   kthread+0x367/0x480 kernel/kthread.c:436
>   ret_from_fork+0x72b/0xd50 arch/x86/kernel/process.c:158
>   ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>   </TASK>
>
> To fix it, add lrugen->reparented to remember the new owner of a
> reparented lruvec, and make reset_batch_size() charge pending deltas to
> that owner.
>
> Reported-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
> Closes: https://lore.kernel.org/all/5A9E929D82717101+12fcf643-efb8-4b9a-a=
53a-1e28cc894f0b@smail.nju.edu.cn
> Fixes: f304652609ea ("mm: vmscan: prepare for reparenting MGLRU folios")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

Looks reasonable to me.
Reviewed-by: Barry Song <baohua@kernel.org>

