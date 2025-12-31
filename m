Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7459EE57D3
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 04:59:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19A336B0088; Tue, 30 Dec 2025 23:59:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1496E6B0089; Tue, 30 Dec 2025 23:59:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 054D06B008A; Tue, 30 Dec 2025 23:59:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E62306B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 23:59:53 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 80F688B43A
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 04:59:53 +0000 (UTC)
X-FDA: 84278563866.01.2A1133F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id E3C27140004
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 04:59:51 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=orhdW9k5;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767157192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yUl81JgJRnllOFAf5pRwBYlPpKAyQQvZP24ONQxr9i8=;
	b=TszXlCLImp+vdk3UdvvZ74EKn2U6f984KiDRRGYwS79/Q95230EojyQiHc04cA7r8NpcgR
	rbOs1E/DgDpTaLmftxQm8g0SNqPG7OmyYVis03/dyICXYbp/IFmvwvqw32yJEU9CAJvC7s
	3b1GhT1rcPP0tX5YWtUTaaxNVi7uUek=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=orhdW9k5;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767157192; a=rsa-sha256;
	cv=none;
	b=r3cktmNQdDG5sYciT0VBWBmXBOyYoT7bicbtBjkjG+yzVwdrtWn06PvNu+bgYbtX2dmWmj
	qTpqI84tmgz+MGFL1VqJAZhLHjBp/ctquvCBG4Jtpz/HUBNyg5Tefu3bQxXZmSzpO8EWjP
	VUoWuc2q9ZDmOrhIevts2FYAes32u+0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DFF1460008;
	Wed, 31 Dec 2025 04:59:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6484DC116B1;
	Wed, 31 Dec 2025 04:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767157190;
	bh=1vkr9V/MD64Y0pYrKiO0vgFUHcY2dKFCgeu7wq+aQ8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=orhdW9k52n1qz2Vwl+eS/OF4qd4l+IvUqSRw7W5ioOn+70hj2LbGhwnszGW25Yp8U
	 +0GpQm/8j9cMd/isE+mearVNJTkBerC1vDZIiPaTSsbc3+SLgAurRyLgjazuAR4tEU
	 LyT62GQA4Ke/+q1xInM3Ka2SOPwqcEUpym7xfACWIG+6dIS4yl46J2N1KrYugU+OKI
	 HtjKR8HnpxRzOYboVDxJnBDJywKJpyqfrN3vtvS3EweJsZ2qkhWJRfRupQLEUnv14K
	 FyO/nx1uJqXB42TmrbuaHDoHKu6gDYCAY33sNgjTZsy5y3sDhK6hqlSEppImovdfHd
	 UGvg6sQhSd9VA==
From: SeongJae Park <sj@kernel.org>
To: JaeJoon Jung <rgbi3307@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Asier Gutierrez <gutierrez.asier@huawei-partners.com>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	wangkefeng.wang@huawei.com,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com
Subject: Re: [RFC PATCH v1] mm: improve call_controls_lock
Date: Tue, 30 Dec 2025 20:59:46 -0800
Message-ID: <20251231045948.77624-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAHOvCC4FhpLrknhvWbDd=cxaLUyxHFkFxBDYSC3waeg4FC+TBg@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: ahdwbj6zy4w8nfzrg7p381anwqusb676
X-Rspam-User: 
X-Rspamd-Queue-Id: E3C27140004
X-HE-Tag: 1767157191-21388
X-HE-Meta: U2FsdGVkX186AqCUA9Srua+n4P+TaVGJufrgTv66nNysM3QrGn796Xds3CDmdZ/U+k2JqCrx5GsYsaVJvVy5Ytnpcgbx4RW1BxlKnFD3tRAEq/lRtJg8CuFEyLB/wfshNk4ugAIvrIeA9MdWaZUjmRkS4VNm5jroKLOgvlGhmwa9sS95oQBcSlv+1QdzuoxV2jIBEduG8+1/fiKNBJIJn1evOIDtQml1QoUr27Jr9fZEEdYyWL0Yg41IOgcB4heP4n2uClxZb5Vab2qTb2k4ZTJm2K4nf/PliqwtolZgT80Wq+HxUJAQrPgARqALntPU7t9GWpoSGcJYs3rVeXKVG0/LUC+yZ4L0lw4U7lj0mGol9eRdYQRU4Nma66Fl5fpCpvyklrBXSeMX9Ii08S7yVWqk4/ZB1viMflqIBuTOOs4LXrsooP0X7wc2u2sCWzDfTEFQGUb3CaG8hc2LGa1lUBGzl1uGYd9kah9IsHrpcAT9uxZL/DjCYlya+SxbuXNAtsVirNQIj+tayns3tN95cA/T/rnELcC5R1rN1SPzcWSiVSErSg1OjXpXLcAz+2eNhcXYruwIPYWoqkyttS3PaD9kcAHA8do6IvjYFGzK8LqMCtT7/EaMofwVhvExlG2HBTiEkR8TSr15knYTehYYorgqOogDPZFsTGDlzyFKbCLSAIAmyDto9/Ez9LyiPCC+5444ilj8S8MUWwV9pHsNhY7pxpu8P3GME+Jln/fT2WN6nKUy3UH2s89ySzr/BSZQhngxiHVPqMZJd/uUu8YKHqIBa70EwvrqEJVdwNH5uZbRHvq+49l+2kUrY9OTLC9Aq9Ia63D4ZXhEHx2KJE+BpDRBQ5LM0NHT9fYRo+waPdmewANDPX13+jnrWD4Ng9S8xeusbms0TgVZJPsAR/1hNNSXCRS/KgCPSZihrDDV6Y7Dx8UIeoVnejr702+K87ToNV4zo/0K92cBsmRzBTS
 Z5aB+NdH
 ukLIEjNGLHA2No2KvXbb6dgbeNo1mdB5+L0+ZOKpONK2VAZBly/wmTkJUoACB7gUtbqt18n+DwXp/9SlGsKuExucyjso0HmoOAXQ0SpLRQXgrmXhyJCcXMHlh+4uFZxsBxOlEuwEd6kj9HVmJ9gEzU2ck3NbmxjTv/8WW/G+Ar3zsq0mlZ8NG3h4KkhTvSmZb4TrIeM3QQHdGC/kKHp/NNMa2sHk/79E/C2wez7z+N12QRfPvDB4YLviI1aFgda25LmMPlnrPADHwyBslTZBpHaH1VbonCs9c0o09KabFP+6UfO4ASmchPJod4X3o8GisetyJuDo9W3yzr0UOxx9xtHA/Qv/vqNKs3cMLLnsV8Y5DJoE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 31 Dec 2025 11:15:00 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:

> On Tue, 30 Dec 2025 at 00:23, SeongJae Park <sj@kernel.org> wrote:
> >
> > Hello Asier,
> >
> >
> > Thank you for sending this patch!
> >
> > On Mon, 29 Dec 2025 14:55:32 +0000 Asier Gutierrez <gutierrez.asier@huawei-partners.com> wrote:
> >
> > > This is a minor patch set for a call_controls_lock synchronization improvement.
> >
> > Please break description lines to not exceed 75 characters per line.
> >
> > >
> > > Spinlocks are faster than mutexes, even when the mutex takes the fast
> > > path. Hence, this patch replaces the mutex call_controls_lock with a spinlock.
> >
> > But call_controls_lock is not being used on performance critical part.
> > Actually, most of DAMON code is not performance critical.  I really appreciate
> > your patch, but I have to say I don't think this change is really needed now.
> > Please let me know if I'm missing something.
> 
> Paradoxically, when it comes to locking, spin_lock is better than
> mutex_lock
> because "most of DAMON code is not performance critical."
> 
> DAMON code only accesses the ctx belonging to kdamond itself. For
> example:
> kdamond.0 --> ctx.0
> kdamond.1 --> ctx.1
> kdamond.2 --> ctx.2
> kdamond.# --> ctx.#
> 
> There is no cross-approach as shown below:
> kdamond.0 --> ctx.1
> kdamond.1 --> ctx.2
> kdamond.2 --> ctx.0
> 
> Only the data belonging to kdamond needs to be resolved for concurrent access.
> most DAMON code needs to lock/unlock briefly when add/del linked
> lists,
> so spin_lock is effective.

I don't disagree this.  Both spinlock and mutex effectively work for DAMON's
locking usages.

> If you handle it with a mutex, it becomes
> more
> complicated because the rescheduling occurs as a context switch occurs
> inside the kernel.

Can you please elaborate what kind of complexities you are saying about?
Adding some examples would be nice.

> Moreover, since the call_controls_lock that is
> currently
> being raised as a problem only occurs in two places, the kdamon_call()
> loop
> and the damon_call() function, it is effective to handle it with a
> spin_lock
> as shown below.
> 
> @@ -1502,14 +1501,15 @@ int damon_call(struct damon_ctx *ctx, struct
> damon_call_control *control)
>         control->canceled = false;
>         INIT_LIST_HEAD(&control->list);
> 
> -       mutex_lock(&ctx->call_controls_lock);
> +       spin_lock(&ctx->call_controls_lock);
> +       /* damon_is_running */
>         if (ctx->kdamond) {
>                 list_add_tail(&control->list, &ctx->call_controls);
>         } else {
> -               mutex_unlock(&ctx->call_controls_lock);
> +               spin_unlock(&ctx->call_controls_lock);
>                 return -EINVAL;
>         }
> -       mutex_unlock(&ctx->call_controls_lock);
> +       spin_unlock(&ctx->call_controls_lock);
> 
>         if (control->repeat)
>                 return 0;

Are you saying the above diff can fix the damon_call() use-after-free bug [1]?
Can you please elaborate why you think so?

[1] https://lore.kernel.org/20251231012315.75835-1-sj@kernel.org


Thanks,
SJ

[...]

