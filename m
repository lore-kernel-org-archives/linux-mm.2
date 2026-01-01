Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81108EEB578
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 02:29:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C605B6B0005; Wed, 31 Dec 2025 21:29:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0DFA6B0089; Wed, 31 Dec 2025 21:29:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEFB96B008A; Wed, 31 Dec 2025 21:29:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9E2056B0005
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 21:29:50 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3F9D21A1371
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 02:29:50 +0000 (UTC)
X-FDA: 84281814540.20.B79D5DD
Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6B006180002
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 02:29:48 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HEkiB62v;
	spf=pass (imf06.hostedemail.com: domain of rgbi3307@gmail.com designates 74.125.224.53 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767234588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PQu1f9JiOtEXcxDEjSyvzzCwSzsVZVs8NmEMoX3qCAc=;
	b=QOBw/0QWgALywEFhjq5yutofikGvdwaILoomRbMXLWYRbiHc4Rh0BGlkkiN/JWXATqShQK
	l/tP016P99xqIRhgmG9fkTmysjfImZ5YGvkN2cAk+jZVLkCLbt2FkTSNVS9Vi0WDUr5ucK
	8RvHK7gM9vydY08BnY2OPgRMhV3wEV4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HEkiB62v;
	spf=pass (imf06.hostedemail.com: domain of rgbi3307@gmail.com designates 74.125.224.53 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767234588; a=rsa-sha256;
	cv=none;
	b=U5Wb9mihKSzZ1PYRn6Q43zLHQrncrQF9zWqyxxX9wzcUFClPaUSi+kj1Sl+6lOdttxVnuS
	fchkJ2ES3SfJbl0ANX7IwSq1skABo9oIbfS3B6YxoPyT8vpDKUb6hW2Y8pa7Lqho5WUu9g
	M2/EI8TbVDmNhB6xHb1ffoVHeF5S/SI=
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-6455a60c12bso10385272d50.3
        for <linux-mm@kvack.org>; Wed, 31 Dec 2025 18:29:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767234587; x=1767839387; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PQu1f9JiOtEXcxDEjSyvzzCwSzsVZVs8NmEMoX3qCAc=;
        b=HEkiB62vvofPWorBq+YqfwV0JHxHH3eZ2wpHT+wu+cS4VNRkBCHIveKNQSxiRktz6d
         h6nzb93VPPvU73iTeCUlbdS0gHQvz/zHzmeYkLf4UECvqlx/tUfmA3CDBbjkIRH7X8Vh
         bKDlDiWMPNOTo+chRdZnqfWE6qOdtZwlVqz9urcJI1zGrd8S83O5JE73Y5lHrV0OvuIj
         OyqhMDWBRrQJI6sIEwNPVn6KX1vq7+raLJgkqlllEarxQSQSn1f81Mxfv8uP+iaEXfld
         uE7z8rLSLavHYCl/ZZAewqlYTwmrY7XKaKzYrI0gGqm7uCbRvBAyRB4xc/XSjSj54Itq
         RTuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767234587; x=1767839387;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PQu1f9JiOtEXcxDEjSyvzzCwSzsVZVs8NmEMoX3qCAc=;
        b=YxHLB6qKmosmsl0bxf5L2zXD+KTQt20NKMxhPYhhiQpwDcEGCu+AFeWUVt25IpVOhD
         PlcQavcv6ehnXbgCMsmLUDgUhsfeS1QzbmOZVMJZiigm9ArkjOAGgU9ah2JQgBxz735l
         9pARpUwe8Bs5ZcwX4Z0en4HFK8ZphKKnuoV6xGp092BKyMyJm5usMcVKzUqT00wkcOwG
         NC+F0mmpTB2uWLH1wxA1QW66kn9SL9WRRj/q6mGaI+KNE2QDFNMCF2WRi+mNboxl8EPs
         AXdpyO7tLD0Qk4a/2Bm4hy9ST8MrLwlRd5GFUGZ8Hdvce9me/LWHNAWSzjouCZQfIAlg
         a8cw==
X-Forwarded-Encrypted: i=1; AJvYcCVpGdopVmq0fqbHyxteBMBkpenwuk6KTlTpvcJWBkbRUjBlniAKUh0MMdl8sN8J5XFbZVXh+KNy6Q==@kvack.org
X-Gm-Message-State: AOJu0Yxdh3NLwzqokSAUi/oRGrrQztl5w5zAukbVB6UV7ibduqyot5qW
	b0HiQIWw1V6qZwH1HSRSC7Ie7IYkajwyUtJP2GI6U3nBNhwxVvvsmM/J4WWu6oAgkwtuTnHb2t/
	vzaVH5VKzNMO8sJqTBEV2teOoYHqKhGo=
X-Gm-Gg: AY/fxX7V1sagQwM5v5kjh5psdJ+fB5FbVkxvgp4ONk6M2KwsfDAksNxn1aocvWSGyED
	y1bwu6w9IYl0btSQxmhoxDQPFGcomm38RMh08kCi3OAxpvV70ZKd2I4OAH5wUk1OQmBDlYYutHs
	oaJx2NgGp5XSQdKEOqq0DBjQDhbTAn6Mc3RXAsH18/qwKzbNfgZbkKUVO7drpnW5UEuvWHTHFdJ
	KhfW2OvDRp+BHGfC6Rto6FhXZiTHuUGEjsmWM86Axi6i7lfrpjjf90SnrPKNVbFu6j3O4rWnEpW
	kR6gs1E=
X-Google-Smtp-Source: AGHT+IG0j61eLfMBZtjBCRAtt6gD4cfUMx56tKt992tAV7oQ7u6A5BMnxDsu2RoR9WRSplTvopodGefdnhtnzMeu1cU=
X-Received: by 2002:a53:acda:0:10b0:63f:ba88:e931 with SMTP id
 956f58d0204a3-6466a8c28d8mr24774162d50.38.1767234587455; Wed, 31 Dec 2025
 18:29:47 -0800 (PST)
MIME-Version: 1.0
References: <CAHOvCC65azs4BU2fyP-kxvFWB3ZPCfyZ7KCO8N1sc0jtTENmNw@mail.gmail.com>
 <20260101015123.87975-1-sj@kernel.org>
In-Reply-To: <20260101015123.87975-1-sj@kernel.org>
From: JaeJoon Jung <rgbi3307@gmail.com>
Date: Thu, 1 Jan 2026 11:29:36 +0900
X-Gm-Features: AQt7F2rhNPQNC3SV0H9hrrUMFMj99IouwnqgjizjnbcHSdektK8WMCR8Js4GHWg
Message-ID: <CAHOvCC5GWg5XhB+OUZi6C373qYS08ot-1A9QM+24mhnuqdq3mg@mail.gmail.com>
Subject: Re: [RFC PATCH v1] mm: improve call_controls_lock
To: SeongJae Park <sj@kernel.org>
Cc: Asier Gutierrez <gutierrez.asier@huawei-partners.com>, akpm@linux-foundation.org, 
	damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	wangkefeng.wang@huawei.com, artem.kuzin@huawei.com, 
	stepanov.anatoly@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6B006180002
X-Stat-Signature: qpwf13ci1enjdea67bkz9jwx4gijziqk
X-HE-Tag: 1767234588-82632
X-HE-Meta: U2FsdGVkX1+cjGxY33GrDut3aF0WO+EfeIyrUW02wjstxLdWdvm+SKGf/WRHsuWrhkigJMj5nYhb5o6OBUr4PNBxGjiaOaQVR1hmLkVDPZzwKOx5sd43XdJ8gupWZwsUcA3Q28fg1OwaEs84zL/YeUhOtHKtHVCkn08VKFnnBQ2AMc9ItLmKTsfQsRcGiENh+BYXo+RuHROvcXz54UQ/sLKISHLpm/BU1cfecNMDkqiU1b2ln0SZLOlnNUwR19VcDoNJV2jbCDu6N17UALHPYz9VuZBeIPe+xIpXZqbjplQBaJJ0Y7nf5GaEiDNEZ8mNFGEoDrZKn89sG1Uhx5T2TzlgXdc0oPOLlVoxpSp+CPBRuxOJC9zRDZMIBhbf9pNCJVkXYcHPG4C370ang5AUlfrK4AMcQc4NfNahzAdqKnwV2fq38uJLw6kMPlppHjDJgWP6FkiOjoRtKyq7WeZngUEEdMHDQPzyrMncsacxZXSLGlaz4qMMSmK8W8RTOKn0bRzvnba2P+ZvNH9thwQFhcydyX5hMOZwKcVXF0WgqSrdIMboFNev9QuEszI3whzeymrQkjM0tPnI5w0ZQR+1gGqqOECQXkFVS9unj563SXgccRkz30/WuC9NLbadVrzCyz+ZMlz8jfU0yRmOYo8Y5sGubUHB0qBoRaBxIDc7hSqPkdsqP9YzDP9PGOhAqPRtmxuUe1MDzlfw2qAtxuLkE58TDGWYMURe1XtsQ/8Y5Ia/XeBnxoKsp2dQ9aBTyWOUBIBwsZmeNE1/lcbGaFiQezCrjZqAD/+xFSFFLUXmE8Wq+Bqyy6plY3fS83eBdwpVHtQnj+KwchkmHQqd0kaPiHgFxmESvQ9UpBZBs7m13F/mXs389LOt19T23542+93qtIcY7afi9dlT5p95hf6Ty17ElopndaE3BeDEWzBS/a3lKWYahk47QE024b/D7qzOXKZQyYtH3vj5DPQxHOw
 ynEFGOyj
 S+3sWZUprh+i/Yrnb67RYEbN6ZmYhLbDM0jmt+LwTerWgNijjZOt8B7wL5oXgD6mQAsO8CRl+4kMVXvdOCVs+Qj04MAc922oBXtIEELk1HD+ZZRJsJWi5gMP7hx41PD+vMSiieWYIzA7o9/uZPrfnvvGfDTZmci7nJCqczXGCA0jbcuPLXbutL2+YhmfwPKJupOQkgr+R1yLka16XlJfcrnsow7saqAeuC0ZTKMh9KJZPOVKSd+vdfJhWxamRIWfIPVh3DfeE+zILmDxg54wmsV5SlffgMQByBfpQuNItIQEwcp7CeaxqYfQsGqiJ6ApkPF///QN3auQDBOC0Z0D89ADsh7mejvJ0q546lGpX4FBV2NlZFH6i9lrLVxdU8329QREW8jONmFq46L54GveH4U1nl74EtPGPlJ8WxGDWotdSmZDWTQZpt8Zv3PwC9xTtAHw2pDADw56tmTXHuCygwHy1rodoVNAMke6tCUTZqFtNfCpi140j5aD++oNT/16+Wsko
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 1 Jan 2026 at 10:51, SeongJae Park <sj@kernel.org> wrote:
>
> On Thu, 1 Jan 2026 10:07:13 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
>
> > On Wed, 31 Dec 2025 at 13:59, SeongJae Park <sj@kernel.org> wrote:
> > >
> > > On Wed, 31 Dec 2025 11:15:00 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> > >
> > > > On Tue, 30 Dec 2025 at 00:23, SeongJae Park <sj@kernel.org> wrote:
> > > > >
> > > > > Hello Asier,
> > > > >
> > > > >
> > > > > Thank you for sending this patch!
> > > > >
> > > > > On Mon, 29 Dec 2025 14:55:32 +0000 Asier Gutierrez <gutierrez.asier@huawei-partners.com> wrote:
> > > > >
> > > > > > This is a minor patch set for a call_controls_lock synchronization improvement.
> > > > >
> > > > > Please break description lines to not exceed 75 characters per line.
> > > > >
> > > > > >
> > > > > > Spinlocks are faster than mutexes, even when the mutex takes the fast
> > > > > > path. Hence, this patch replaces the mutex call_controls_lock with a spinlock.
> > > > >
> > > > > But call_controls_lock is not being used on performance critical part.
> > > > > Actually, most of DAMON code is not performance critical.  I really appreciate
> > > > > your patch, but I have to say I don't think this change is really needed now.
> > > > > Please let me know if I'm missing something.
> > > >
> > > > Paradoxically, when it comes to locking, spin_lock is better than
> > > > mutex_lock
> > > > because "most of DAMON code is not performance critical."
> > > >
> > > > DAMON code only accesses the ctx belonging to kdamond itself. For
> > > > example:
> > > > kdamond.0 --> ctx.0
> > > > kdamond.1 --> ctx.1
> > > > kdamond.2 --> ctx.2
> > > > kdamond.# --> ctx.#
> > > >
> > > > There is no cross-approach as shown below:
> > > > kdamond.0 --> ctx.1
> > > > kdamond.1 --> ctx.2
> > > > kdamond.2 --> ctx.0
> > > >
> > > > Only the data belonging to kdamond needs to be resolved for concurrent access.
> > > > most DAMON code needs to lock/unlock briefly when add/del linked
> > > > lists,
> > > > so spin_lock is effective.
> > >
> > > I don't disagree this.  Both spinlock and mutex effectively work for DAMON's
> > > locking usages.
> > >
> > > > If you handle it with a mutex, it becomes
> > > > more
> > > > complicated because the rescheduling occurs as a context switch occurs
> > > > inside the kernel.
> > >
> > > Can you please elaborate what kind of complexities you are saying about?
> > > Adding some examples would be nice.
> >
> > You probably know better than I do.  What I'm saying is too general.
> > spin_lock is good for short collision waits, while mutex is more efficient
> > for longer ones.  However, I'm saying that mutexes place a burden on the
> > kernel because they schedule internally.
>
> Thank you for added explanation.  But, in your previous reply, you mentioned
> "it becomes more complicated because the rescheduling occurs as a context
> switch occurs inside the kernel".  Your above explanation ("mutexex place a
> burden on the kernel because they schedule internally") is not adding more
> explanation but just a repeat, to my view.  I'm asking what complexity (or,
> burden) that you concern here, the internal scheduling is causing.
>
> So, may I ask your explanation again?

I'm still learning about locking. I hope I'll stop here for now.

>
> >
> > >
> > > > Moreover, since the call_controls_lock that is
> > > > currently
> > > > being raised as a problem only occurs in two places, the kdamon_call()
> > > > loop
> > > > and the damon_call() function, it is effective to handle it with a
> > > > spin_lock
> > > > as shown below.
> > > >
> > > > @@ -1502,14 +1501,15 @@ int damon_call(struct damon_ctx *ctx, struct
> > > > damon_call_control *control)
> > > >         control->canceled = false;
> > > >         INIT_LIST_HEAD(&control->list);
> > > >
> > > > -       mutex_lock(&ctx->call_controls_lock);
> > > > +       spin_lock(&ctx->call_controls_lock);
> > > > +       /* damon_is_running */
> > > >         if (ctx->kdamond) {
> > > >                 list_add_tail(&control->list, &ctx->call_controls);
> > > >         } else {
> > > > -               mutex_unlock(&ctx->call_controls_lock);
> > > > +               spin_unlock(&ctx->call_controls_lock);
> > > >                 return -EINVAL;
> > > >         }
> > > > -       mutex_unlock(&ctx->call_controls_lock);
> > > > +       spin_unlock(&ctx->call_controls_lock);
> > > >
> > > >         if (control->repeat)
> > > >                 return 0;
> > >
> > > Are you saying the above diff can fix the damon_call() use-after-free bug [1]?
> > > Can you please elaborate why you think so?
> > >
> > > [1] https://lore.kernel.org/20251231012315.75835-1-sj@kernel.org
>
> You didn't answer the above question.

There is something I misjudged above.
It would be better to handle ctx->kdamond as a mutex using
damon_is_running() API,
and modify it to spin_lock only for call_controls_lock.

>
>
> Thanks,
> SJ
>
> [...]

