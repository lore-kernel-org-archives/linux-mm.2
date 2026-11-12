Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05244606A886
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 08:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zuYnnyT2
Received: by kanga.kvack.org (Postfix)
	id 202586B05BA; Thu, 12 Nov 2026 03:59:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B3806B05BB; Thu, 12 Nov 2026 03:59:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07C856B05BC; Thu, 12 Nov 2026 03:59:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E0F846B05BA
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 03:59:23 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 76E4E14026A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:59:23 +0000 (UTC)
X-FDA: 85425868206.08.4C0C054
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf07.hostedemail.com (Postfix) with ESMTP id 83BA340004
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:59:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zuYnnyT2;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794473961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zQkr1RU++tmLxFcJTSSs0phGfaQL6+em9BkBvgFpLks=;
	b=gfleh2HKI+E94tkrcpnfYpAJtXUhPDUDNFtr3gZ3lExD/lmXJ939Lef8QXEuO7s9pOpQWv
	NxF2XG5BZozMdh6DlD5VJIW2JpdgJcNIjLwhk9Y2Z47qfnwT7zwznwrnJ4doqdn28aWzVG
	hxM5KB2l3Q6O3s/i5WGDDAaNHr7hvoA=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794473961;
	b=GPur5LtaqLquiTJswyiyy0uOChJFvGv0YGuPTeWCXpYRenKpf+usOgZo41RD8NO+jb3Bxq
	ktSj4L+I2Gp7mEPSEpxk3c6d3mCz6xubTcRYkPJGFf+zsZ5Sw1qLJ8T3Zu216kc6byL8l3
	3l42/DIkEO+IQ0JdR3H386iewbMacvE=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zuYnnyT2;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c4d427836e9so520600666b.1
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:59:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794473960; cv=none;
        d=google.com; s=arc-20260327;
        b=dhYf/U0LuSPO07UIGVtBInV4oLoBDVho+HEafN9Kx3Irxlr9g0hCUuDbFlD+VVA8+7
         fBVfzxYVtsnQXtbKXsvnXJnv1LAxiGJ4MnLF7HftchQ44VxUBvvTFI9hvVy1iIP8oxug
         CNVDmEyot9uplieSyntWJ66j3GmVGCgEuSRKFvX2TbzLxW6cfFpBHbmQqrGCO7B2LqwZ
         f5/HAOCxJ6P9mSwWrPEmC0dOlMf3qlLcVY3ZnHMhOG/qXlqIvRcc73Uv3LC4vm1TAYmu
         G6GoETq5ccYOuCe0gUhAkxVKTCYXByclTXMXtWCwcj3CTUejLak2LW4CGaN37BrTQY0T
         RXoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zQkr1RU++tmLxFcJTSSs0phGfaQL6+em9BkBvgFpLks=;
        fh=UDaXFrjRyc/4Nl6Dpe2/ATx0qVBQyClR2Z96tbt+Eu4=;
        b=cpOUX4jJgNXKPnn9v/cL8j4RxWz/reDGiOjRA+BJt56cPX+uRWJ68zNlnCiqMbUEoJ
         4bMv/oV9DuooQIz36+7SiJ5Tpo/pCHDkn/W93mo2EM/JR4a8n7Ag9JrUo/pyEDBzNBug
         3PFGCl0Qid6JCl0sc+PNa5jP6O8T3RBUtPYWFBIippuEzoPJQiJUAeLY+l0CoCNdt1Sb
         RB/VHIEHNeGzwxtxDFWCot01m6rBcfEE+W7VRK90lWE7A2Jwsi6nyvoqJ07spjtqtuSs
         0Xxz0swtRBPWiCpFrH2QDtwxYBD0Ik/0i6VRdXQSkj2dqTcAw8+Gf7zhBP2S49cTKclS
         ckNw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794473960; x=1795078760; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zQkr1RU++tmLxFcJTSSs0phGfaQL6+em9BkBvgFpLks=;
        b=zuYnnyT2ZtkccjO2fwlmO5s3xqGjNxQd+C7aROrfj1fG6YV12rljFb1lSSZOzDAXN4
         aRPMJS5xnsi2jMRwbL80wjXqPmaFaEJ7pAQmmPJ3HTVJmqCmYhVJ+8qDeIVHe61xe4BC
         ZPQn6WXlcXVMUW7B8vKkiE7459K8Pte2kWKfA0bAbQdTI7v0miJLyY8tkmeQA/qmNSL6
         ZQZd0c6ivYP+kUt+i8iQYQYMnYnV9TyUP8P50iO4EQxJ+uPb9In3YbEIWCS+IkiQZDzR
         hThnP3sUf8JKkMA4HMUntW/bLcH/RgnbA4na26B2mQOf3Kw1iEWyzHjrOVxXMshiqwHO
         kAXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794473960; x=1795078760;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zQkr1RU++tmLxFcJTSSs0phGfaQL6+em9BkBvgFpLks=;
        b=egv5JmNcydxqZAWdz1iplbxVlTIFPICiURyBPXg+OdLsoOeFiBTKjjo4EUg+tSPN7N
         UrqT2QfL1OpnOYWXS+Bg5BosnRmSYpjYeSTS5OZ9j9mwk3LdyVlI41g+iugHwiZy51/8
         BYseCS8WDv5SBNLNZuBY7CuUgkXQY/UBlaxIJzHhKM7OHY5ywuRNwDPIDiEX+WDQcojH
         KIuLb50tPdicNstLz6reKgwQEAX9Y9c9vcHrWXNj1SfMqQZDz9r2MnecipWjSSGECRcn
         J6xEyIJF0GvIrrTO+kNKp1q9LQv9bp6kqzUopGeGxwDc6njH0m0SkuzIcYRzdkGt5P3B
         SSiw==
X-Forwarded-Encrypted: i=1; AL+hErEWc+ykgG9LnRMWvSdfjW9fvZot1QqcpWbao+F+5hVUQMvkLXL0y5IC+Su7nhr++KX2IHw3TeJcMA==@kvack.org
X-Gm-Message-State: APuU4Z9I4LRz9kYJBfS6jZ/1X+5ehJP0a2f8zGqMOHQTRIYJgOv1HPrH
	naiekVk06ZN2wYa9PU00MzTQ8DDUSGz8uA5mYU5QRQ8RQ6F20FhOEUFXYa6QM42PDKfqyZrB5Ce
	36keYSFjOrPBAUjjSxsZrar8+bKzFc+c=
X-Gm-Gg: AYBFou3oD6JtCVv5gaBc+N/odEVfWLOtpCG0qRfgjJ0IgZvG4J7SxLsqX+o1h8JT+qP
	IyDzlAucymDL/BpMXwk/O78OlGY6Mk5EzOflv7kx78YFDzs3Bv7a9bhip3rP3uihVyYkEN54Vi7
	H3QlQAR9+V3TvFIgHPe4UuubqIc2CFxKTQ46FSGUWHCkDycoLxG2Xz1JPV+OYUc6pq/lEhTnBzv
	or4nYrw7I6+k5L5DfQXA/QJiV/0HyX6Egq6+SBQzrvKTUf70SYPv0mbsYhAwy5PhJlZoZhfjI0W
	6e7HsorFW7rhG66701rwv6CG59YQIK70IfvKrZqq+pPfouOTG4sNzWlE865gkmbYSLIzNsVbOuq
	wSzozYR+5+zUqyazE81XsFkTUE/7Cm5V0W8UO8oPd2Sm83znJ5L5mROXQhnrrBux0ZO8zoA==
X-Received: by 2002:a17:907:6095:b0:c40:19dc:a24d with SMTP id
 a640c23a62f3a-c5066af4f36mr398521966b.9.1794473959838; Thu, 12 Nov 2026
 00:59:19 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261112075827.255602-1-hui.zhu@linux.dev> <avVx_1BEP7fIzGDK@KASONG-MC4>
 <avV0IbvSx4iuv0tF@tiehlicka>
In-Reply-To: <avV0IbvSx4iuv0tF@tiehlicka>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 12 Nov 2026 16:58:43 +0800
X-Gm-Features: AclHuK-ueh3IWxcuKaV-MJSsNbfRKYSzUtWpmEl4qHfY-8sLr5Df-ouMS4l4hMc
Message-ID: <CAMgjq7D+fUzru-NgOnMcp2EH4gT51=o1LamPFC1sKWkqRds-jw@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: check need_resched() in fill/drain_evictable()
To: Michal Hocko <mhocko@suse.com>
Cc: Hui Zhu <hui.zhu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 38zw984jyro9oj1zpt5bj3st7cc4yjr9
X-Rspam-User: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 83BA340004
X-HE-Tag: 1794473961-932532
X-HE-Meta: U2FsdGVkX18+frfccKVZFbgR9chCdWa60faV9IJ8hWgLrNqdA5W7YKuSWUmhcLpC4ZzFOKd4eYeDp/keMdCnio+JUzSOmyn9OnRJ3y+QpyNlyG2KldijLaMtU8mSLXshZUn/7WHqkZQVo/1JXsv25e9PPPCAzc4CLOfJ9gj8pUMok+r2qJZv5U8HN+e2E+y31CghLR63yGSGQNR94w6L1yx4d8cTti61zd8nNhyAxP3qvsIqaae0p1BNzO5RYn2wivHK6alLsGcI5mSk+sLfHCfzCnBx9ndn2+HlyS+U+LNs7hCvErbMW5yUTDcb2OwDO1eEC6oT/jBu2PL8/YL+4jO123v+t1206fh4Idbf5UjeletZuZ/9xoSv69hsAd2CGzIHPViPuP2T9BiLLhUOkQv6nYpUTdl+nBB1cr1nOBr9q4omrkv76K8PE5DCXKKF4Fli/AuU6wTvlU9P1RkqFRBhSidZ0XEkc4nb6C9rILrJQZJntbxI7FlLNBe3zN2Ud+iLkJD/wFEa86Y4N7hQcXAXEUJfYblsV0KeyKINgUVOCi8i6qV7k8BxPvFofsZS5BvRi951CesPDCir2nx+0CD+5AujnmaLoJYOXhH1iYykFOzIKQBEC2dmihiY/WzEUzGH4xSFIDjoRDF0mg/Oluvge6e9pbz7alIs+P6CJuE4TG7GASG+23uJO16v4bUrJsF0dnQ/vbjVFw2e9CVcg2Oe1nuUHD6R8ZU50oWBflDcBcBacJ79OjXeZOmrWP6JuD5g3t7TPy4WLYAFZFlqg0u/RkXds2CjN5m6emn0FIqFEH8cW17Po0IE9/5yqBFs7GZiLTTnQFjcrnUdDEhf6umIgI1FxP9vHI69Av3xMT0YgzFRS5uCwMXm2UkDm+EiAi2STOBrk+lgncxFuePDXxSELPmp8RtKB2HHzcyLxG1UTorurSSYIkhsuHao3dvE20zp8Rac687P00hzy6n
 hU6JLVS9
 9Z7teg9B4Cz0n3CEjoyXKnjlC2cU3b5oyjpTv8ZnSG36/pnEPyv8+5hFFHfTPztntEsm0fYRx4/90W9lFJPAxu85K+kLpodXwIECysh6pIfSgWSYhSFxJk8Sc/0Fl3XDtN9RVLc3gaUPt4SZSxvxkuUIJ4OVLFb9CaDPyYTCyIvFIrpCe1axeoW03QqIJA3Z0CExEJdm2xLh7OuW56LJDrJ1TZfllCuFew0RBhBQpaZ05exgslwuJss6bMAmL26IUMh8QfQgJ/BEhvXBuuE9gQ1Um11x5OD/UXjtL5iGXE7zO0jS6AUBfWKFrDsm9ejg8C0aXEPGXj1AP8DBdKv1wm5tRzZ2EDnQ+1ChY/yfv/ArtyMZpTEzIO4UKAYDh+sD+4KhmVZpsvDf29RMZq0Z88u1EpT3egPxlgpf06AF1XD2KAHn/wabDBr7v3U9/DlIzQdi3ASAabjFtJtVUZG/rbDlZFL/MbihdjbyGocoC87Hl/V0m+dCdVhY4JXxml33Sw1rq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 4:09=E2=80=AFPM Michal Hocko <mhocko@suse.com> wrot=
e:
>
> On Thu 12-11-26 16:03:54, Kairui Song wrote:
> > On Thu, Nov 12, 2026 at 03:58:27PM +0800, Hui Zhu wrote:
> > > From: Hui Zhu <zhuhui@kylinos.cn>
> > >
> > > lru_gen_change_state() migrates folios in batches of up to
> > > MAX_LRU_BATCH (4096) folios under lruvec_lock_irq().  A full batch
> > > keeps local interrupts off for up to about a millisecond, and CPUs
> > > contending for the same lru_lock spin with interrupts disabled for
> > > that long.
> > >
> > > The caller already reschedules between batches, but a batch itself
> > > only ends after 4096 folios.  Stop it early when a resched is
> > > pending; the caller restarts the migration where it left off.  A
> > > remote resched_curr() sets TIF_NEED_RESCHED directly in the target's
> > > thread_info, so the flag can still be set with interrupts off.
> > >
> > > This follows walk_pud_range(), which already pairs need_resched()
> > > with a MAX_LRU_BATCH cap, and commit 6e9be217a3ce ("mm/mglru: use a
> > > smaller batch for reclaim").
> > >
> > > Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> > > ---
> > >  mm/vmscan.c | 6 ++++--
> > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > index 6a1af9b92349..47f2cb25eb46 100644
> > > --- a/mm/vmscan.c
> > > +++ b/mm/vmscan.c
> > > @@ -5533,7 +5533,8 @@ static bool fill_evictable(struct lruvec *lruve=
c)
> > >                     success =3D lru_gen_add_folio(lruvec, folio, !act=
ive);
> > >                     VM_WARN_ON_ONCE(!success);
> > >
> > > -                   if (!--remaining)
> > > +                   /* stop early to shorten the irq-off section */
> > > +                   if (!--remaining || need_resched())
> >
> > Hi Hui,
> >
> > I've been thinking about a different design, what if we just
> > delete the `--remaining` check completely, and check
> > spin_is_contended on the lruvec and need_resched()?
> >
> > In the optimal case we don't need to keep lock/unlock the lruvec
> > at all so this is faster. And it still avoids lock contention or
> > blocked schedule, and it might be even more responsive as we are
> > release the lock earlier on contention.
>
> Wouldn't this result in too much lock bouncing in the end? Would it make
> sense to reduce the batch instead?

Hi Michal, thanks for the suggestion.

The fill/eviction loop here is a quite cold path so probably fine, I
did just found another reason not to do that though.

