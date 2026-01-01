Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F4BCEEB573
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 01:07:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF56A6B0005; Wed, 31 Dec 2025 20:07:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD5D96B0089; Wed, 31 Dec 2025 20:07:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E1706B008A; Wed, 31 Dec 2025 20:07:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8D7176B0005
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 20:07:27 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 36EE08DB3C
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 01:07:27 +0000 (UTC)
X-FDA: 84281606934.25.AE1E145
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6885B1A0019
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 01:07:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Mk0KjyGl;
	spf=pass (imf19.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767229645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HCLZDaLm2L6JswOmFkluz4sNK2gYaYWfod70ZwLuR1E=;
	b=z4umc8vk8CTOC+UcMQAXyzG/8lNwJ+eOrGujNLtMVfliBaw0GdEwPB+/GO+yCcSzU2JiXy
	gQD41DDZEGr0LqCP3Rm77LBRoP3DngV6ysnBYhy1yoqXeARJZfWtYjhrnwWxyVou8cIU/P
	Q/gCiTXLGHNLnKU7LyQtZm6O/bL41eQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Mk0KjyGl;
	spf=pass (imf19.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767229645; a=rsa-sha256;
	cv=none;
	b=XZIoRcVBDepJbgGwkg5m73J81gY7eJnsjvW9wUUtH5C2TXDSAtVbLw/KainsqGVNFEVRyO
	HlUk0VgFJ74Z0Ht2kphA3fE1PI3vyIl8cna0MpbayPuNzUBdguYyk1QKNivje4Kyjyw1Dz
	76uc4vBpsQenfT6koCU7GGZBBuXik3o=
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-786a822e73aso99666027b3.3
        for <linux-mm@kvack.org>; Wed, 31 Dec 2025 17:07:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767229644; x=1767834444; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HCLZDaLm2L6JswOmFkluz4sNK2gYaYWfod70ZwLuR1E=;
        b=Mk0KjyGlqP+LvuKzmV0rD2w8YQW//EBD+AzCvCU4ipiPj74hn3F0xpk2PCwn9FKD1W
         9i+bKOg4XtankqSITT/8zcnKYvbXK0kIqgJR+qs669vBrVD2mVPxaMPX5zFpYn4r3xBd
         w21V9GghB8JSH4jLuUCtSF8B7eAEM4Mz8GDtHBszEJwYSPgS0991ITQUErJgpmDrhg45
         +3HqX3NsdvUi3b8njGy6XwrI8KzjQcDxKNvk21Fppziq+WyeQYwJdyUjZc/2aSlo6yya
         5Yq/wzscL6Df5l6dxZFTqAjZlnTYk2AHEz2jomvCLQrsYxoVruBWA03qDRn5ghPtgsCt
         JQzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767229644; x=1767834444;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HCLZDaLm2L6JswOmFkluz4sNK2gYaYWfod70ZwLuR1E=;
        b=ArDRxhq4XC7tnbp0P4Nhf1icTRzW/9zPFNaYCjLFbdfs4LQKsQckgq8CPpBPYgQelm
         DRqOB9IF+cB245MJ4a1R/zHeBFBbz1a9pPGIuSIdXE/1L8raQ2936bFvzkSVHukODJUV
         xhzVuFkC8kyrD97AOsj5QpRyn85ZKOFG9gbYDvgtDc5EXgpdT1D6p4zJQ2UORMi/D3Dn
         3eJcs/36povr+1qlY4CBXjNssjym3PzcvOUH4XSAxloHD6KrvgoXTHCtCK0yflP6oe4M
         i2FEP4Al17whvHJ1fqv4vZPkxVzTx+JGYQuqmnkPG3x5duoCo7ZflADWOLVGt5jpiE+3
         GQ8A==
X-Forwarded-Encrypted: i=1; AJvYcCWg+Ov6Xau0h47sFYL/HMv3MMGIhDKVSSg50duSxGOGF+byXuG50avI0WiV64omKYLeZYc8rHiW8g==@kvack.org
X-Gm-Message-State: AOJu0YyLiZZJGRCN7XnBliCZt8tTgGdCnTujUjCyLTcFuy2IXfMR2Q+h
	oBNCMkU/uU0L93xPxvFXbRbI9dkvsD/01nr4Md9hiENG/GJyUeh5H1o7IhoHpS5dcWg2pNHGafY
	C+ToAyHWpjzSv95Lmc/lrBHZTsIvF/Vs=
X-Gm-Gg: AY/fxX7vQAGBV+nSXnAZdxnXK1VwaEODIljfsIe5ZZZUVgRJoaqDSTkzCRe/glqnHnt
	tE6qj20OyWC/Kvt+WAr98dnv7Q8Uie/4gsDWv9Nqpye4LkHoPSCTexXmpN5KBm2lEYAx30WDMmz
	gUDHPHnwTjvdqdkMm09EEBU9ukfKO8GEqiLrdVNiuqqdZwqgk94Jng6CRBksuscjZqy4g8loo69
	IPkTgqnzwZK22KRn1umJxCa8IxcZXQUx9pmdRaHitmBmmDVQmg7l6lyA4ltKc2Nua1duiRPS385
	HTYJ70Y=
X-Google-Smtp-Source: AGHT+IE8AcGAnGEoBO4Yb3pW+KwclBfnwWg4JRryk/uwFkoneK5K6k2fj2iNYeV0VCcRixn3NLZQ/XAJl+Y/ge6rzIs=
X-Received: by 2002:a05:690e:1519:b0:63f:b18a:7812 with SMTP id
 956f58d0204a3-6466a85b095mr27554748d50.40.1767229644497; Wed, 31 Dec 2025
 17:07:24 -0800 (PST)
MIME-Version: 1.0
References: <CAHOvCC4FhpLrknhvWbDd=cxaLUyxHFkFxBDYSC3waeg4FC+TBg@mail.gmail.com>
 <20251231045948.77624-1-sj@kernel.org>
In-Reply-To: <20251231045948.77624-1-sj@kernel.org>
From: JaeJoon Jung <rgbi3307@gmail.com>
Date: Thu, 1 Jan 2026 10:07:13 +0900
X-Gm-Features: AQt7F2qRKINMM5Amxei6wbd2xIBkigXILcsVOtv_fPrcfVGcvulJURB03OoLv6w
Message-ID: <CAHOvCC65azs4BU2fyP-kxvFWB3ZPCfyZ7KCO8N1sc0jtTENmNw@mail.gmail.com>
Subject: Re: [RFC PATCH v1] mm: improve call_controls_lock
To: SeongJae Park <sj@kernel.org>
Cc: Asier Gutierrez <gutierrez.asier@huawei-partners.com>, akpm@linux-foundation.org, 
	damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	wangkefeng.wang@huawei.com, artem.kuzin@huawei.com, 
	stepanov.anatoly@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Stat-Signature: sece9bgthw1yzh39negkg67nuhf8ng9s
X-Rspam-User: 
X-Rspamd-Queue-Id: 6885B1A0019
X-HE-Tag: 1767229645-42141
X-HE-Meta: U2FsdGVkX1/Ee67HekV6uSlrvaqpwrjkPUAxHknfOWprSemk/HEfsUUWRzS+nuv14VUFoma6oeZ3+U1J4Ln5sl78FYSV5yZfUB2RLHvFLP7Taq7M+EKmKcVfiqFi6+lt34q6nv2mktyAq7Qin0jO2vPAYd99jDNe6QhyhfudJjmcq0XhC0QZKdwCVnnw5435vsl+hVpBjlGNvP/XpshS1v0LiIAfhMV/l1GVEV0o07VhL/46CBEZqoRwBfJKJrprRBoKGCjf5xbcRuKIEi4VcQfo3Vvl8v+Bxx1KaiE5J5IUXDlDXf0wWhEIaBhgN1bI6WxHCG7eDfwBXvih5Gk249D9riyF/vC6ow5xtIwC08Uttb31GjIAeNIlVRYbYwCW7rtESGhj2F5FLQmyrSxq+1IswzqsKUNhx5HSemKaIeEgfIRyB9/RXYymXpGA+assFNWY55k/0AvsgQUaCfEazNGjn7+Ra/WYGH5NA+YbYfMFof5DIMAxLbl1QcmCI9frHqETW5eA7nYWLeZSJ+CJnhRzr1Q8At2mZVZUdrlI8TKd8RJyXsf2eIYU5v84LzLAJuX2sySKrZ7IgU0VDRBDQFC166pvU8pXwxO8OAIGnfxIpnNQj9IG1OppF/mYf9n3ndhwpcJknITdinfq/3bKljPzW+egNrAcrjU3QJObPcc+/VwEehzSgbXuGIMByRG0u2eZGBJMhMRu1+EbpuWc/9j9t1Lo9wKJ5Q9CwtIqKNwINyQlEBi1BftO8qTwmPvBVV4VIaCL7OgZININ8AFmxVpj2XcHtJZhSH48HLVL42L1G3faFP+3C+4ZbQL6lOKaBXsH3uxerXgV+bwqkDoPt/pFjTQbLMgOtKhODE1TMn+UVNNF4cxA1DWSWSXEyfcbHnjg3bVgKLIWi5hHWFXDpY5bFuSXWvQBP2R8XfAEzWdYBRg7ank45pVVwfc1K6bkLRLUmOPQbgmGZUFlR2v
 NEnM7aku
 MFrLHIwcscKFtxAF7GRBY+urLCz9S/+BrYKAHtVDIJu4bxz6XRVNF2Kr2EAi4TnPj/v9OfzBx5xuCnMdPo197MXWaWnpO1s4G3xK0pdW69ETIysFS4Qi5ZqFNb5IQQcqxj5Mn5JEdbxRTYwcWynkhawxtchGMM/iMCPqlH7jbG5nFeTX6hFWf3gXyWf6Hw1+nE/YoswII1G3s2XmfJGjCyFciKNYys9MqN3cmCqb2K5L0GLA+t/+fzqJ1VmnRuR1dG89ucmKQlHifq+gpyq8Ef2WaIKgLK1vRx53vtVB9UEjrLn1O9xHmooegCMoG4I/FXP34YsKvrebIM9NjevtwxdLrhnggF88LFoOGeV3mztCP204wC7zYnGa+6K73r19Rb0y7vQMV0uT9jdmuDXIDByenitpB9Bk/W9Xdusp4FkopekPc90ERrKCpknk4uYp8/ikf0+uCBs3rXdYFYPc6fyZ+yL7KFqXDFLiDu6ivJD3cWsAGGJP/eOhTD77T675hYvCb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 31 Dec 2025 at 13:59, SeongJae Park <sj@kernel.org> wrote:
>
> On Wed, 31 Dec 2025 11:15:00 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
>
> > On Tue, 30 Dec 2025 at 00:23, SeongJae Park <sj@kernel.org> wrote:
> > >
> > > Hello Asier,
> > >
> > >
> > > Thank you for sending this patch!
> > >
> > > On Mon, 29 Dec 2025 14:55:32 +0000 Asier Gutierrez <gutierrez.asier@huawei-partners.com> wrote:
> > >
> > > > This is a minor patch set for a call_controls_lock synchronization improvement.
> > >
> > > Please break description lines to not exceed 75 characters per line.
> > >
> > > >
> > > > Spinlocks are faster than mutexes, even when the mutex takes the fast
> > > > path. Hence, this patch replaces the mutex call_controls_lock with a spinlock.
> > >
> > > But call_controls_lock is not being used on performance critical part.
> > > Actually, most of DAMON code is not performance critical.  I really appreciate
> > > your patch, but I have to say I don't think this change is really needed now.
> > > Please let me know if I'm missing something.
> >
> > Paradoxically, when it comes to locking, spin_lock is better than
> > mutex_lock
> > because "most of DAMON code is not performance critical."
> >
> > DAMON code only accesses the ctx belonging to kdamond itself. For
> > example:
> > kdamond.0 --> ctx.0
> > kdamond.1 --> ctx.1
> > kdamond.2 --> ctx.2
> > kdamond.# --> ctx.#
> >
> > There is no cross-approach as shown below:
> > kdamond.0 --> ctx.1
> > kdamond.1 --> ctx.2
> > kdamond.2 --> ctx.0
> >
> > Only the data belonging to kdamond needs to be resolved for concurrent access.
> > most DAMON code needs to lock/unlock briefly when add/del linked
> > lists,
> > so spin_lock is effective.
>
> I don't disagree this.  Both spinlock and mutex effectively work for DAMON's
> locking usages.
>
> > If you handle it with a mutex, it becomes
> > more
> > complicated because the rescheduling occurs as a context switch occurs
> > inside the kernel.
>
> Can you please elaborate what kind of complexities you are saying about?
> Adding some examples would be nice.

You probably know better than I do.  What I'm saying is too general.
spin_lock is good for short collision waits, while mutex is more efficient
for longer ones.  However, I'm saying that mutexes place a burden on the
kernel because they schedule internally.

>
> > Moreover, since the call_controls_lock that is
> > currently
> > being raised as a problem only occurs in two places, the kdamon_call()
> > loop
> > and the damon_call() function, it is effective to handle it with a
> > spin_lock
> > as shown below.
> >
> > @@ -1502,14 +1501,15 @@ int damon_call(struct damon_ctx *ctx, struct
> > damon_call_control *control)
> >         control->canceled = false;
> >         INIT_LIST_HEAD(&control->list);
> >
> > -       mutex_lock(&ctx->call_controls_lock);
> > +       spin_lock(&ctx->call_controls_lock);
> > +       /* damon_is_running */
> >         if (ctx->kdamond) {
> >                 list_add_tail(&control->list, &ctx->call_controls);
> >         } else {
> > -               mutex_unlock(&ctx->call_controls_lock);
> > +               spin_unlock(&ctx->call_controls_lock);
> >                 return -EINVAL;
> >         }
> > -       mutex_unlock(&ctx->call_controls_lock);
> > +       spin_unlock(&ctx->call_controls_lock);
> >
> >         if (control->repeat)
> >                 return 0;
>
> Are you saying the above diff can fix the damon_call() use-after-free bug [1]?
> Can you please elaborate why you think so?
>
> [1] https://lore.kernel.org/20251231012315.75835-1-sj@kernel.org
>
>
> Thanks,
> SJ
>
> [...]

