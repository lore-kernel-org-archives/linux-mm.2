Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BEF8EEB578
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 01:51:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8350C6B0005; Wed, 31 Dec 2025 20:51:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E1BC6B0089; Wed, 31 Dec 2025 20:51:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ED9B6B008A; Wed, 31 Dec 2025 20:51:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5D8F16B0005
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 20:51:29 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0E7321AA431
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 01:51:29 +0000 (UTC)
X-FDA: 84281717898.27.A94B1CA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3F104140007
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 01:51:27 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AHTZoNrH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767232287; a=rsa-sha256;
	cv=none;
	b=B+HJ8bXVuNIUJ/LTNmhnXGDwmsSubTM8C0phWJznRwQmn8iJLK8JAXUwhGPi6AJG1hM/br
	wcsIv/IWYk+QX1iruw+ZIwp3yj9I/PmSSvhyHMCWBlBX2rnRr9V9XXzewPifrFFTqStZPX
	CwE3buNK4X/AuxNJahKsQ9iDdagJocQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AHTZoNrH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767232287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7gMsrhL3IDCNYVo+zgFK8qFVgnDeVqEBG1WodYF2C04=;
	b=cxKktkFciALRh7cqDUoQ4KsBvgKYlAINmDlR/ppOgLcxxVBDi11KtTlHWydrNZWnl8Z2cn
	N1ymkky3tSvPVGaLVV9IgIgn06uElUMfTXQjNGGsOfUP60w1WEmPcCm3JIZJNBFLdAA2zk
	w1hORF4LkKq3GkUxNx5e0hsV9ecZRmA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2E3BF405C1;
	Thu,  1 Jan 2026 01:51:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8AA3C113D0;
	Thu,  1 Jan 2026 01:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767232286;
	bh=n+485lTY5SOjWS7oSH8qGjCb2Tgr//hFiOxuDtjWY5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AHTZoNrHHoYKncG0GuBi7rgxUN9S5Telp8isvswfXv+JWar64RfEQVKkINbSCSvP7
	 6yuBdpIv9tH4ruip0U+bry1z4ngYZEq/jUH3DU9Mm9vTBKRurCzEJmRbM51/2BChK0
	 hYoEKW9pNfmJFNfiqjawozpwbGr/lqNv4seLNcqYSfT0QSl1byelJh26Um2zr5ltws
	 UslxKKk7PUfiWoi4sf8QyFUP6LXBBvPrTe86erkigAcRjaGdEu29wBQk3KGofgAmmI
	 Ch3M9arGEXHIstopwqOC/JTsccNZeW3wJ8f2jmbJkKsuoPqtKKoJ4mlIBONpxPJ7BM
	 9Dm2IjnJ8IVnA==
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
Date: Wed, 31 Dec 2025 17:51:22 -0800
Message-ID: <20260101015123.87975-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAHOvCC65azs4BU2fyP-kxvFWB3ZPCfyZ7KCO8N1sc0jtTENmNw@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3F104140007
X-Stat-Signature: e76qyi1e1pdmxzznhaxhfjoo6fauommz
X-HE-Tag: 1767232287-209772
X-HE-Meta: U2FsdGVkX19NIxkT6G0F2tzlpUf3Ha3zsT+B4mqyhI5AmqVqkkfC6MlRjf0QgPVUr/RS7j58Te5oqpVQfArklpEAjY1p62xHjcaoMPrgvaxUO71FgcQz5JaPsRp5bOwNfTUiMlK5aSGg3rXv1BL7qX+TktbZ60bn8JINA4vEfovTuFaBBOPa6Rm6YiaTcrk+vxMs4+3XyVfGiGr+jxAKr9HPqp8Ug8/TCsIMd/g5oN0lJlQWhluJeTgXsLTuLk3meY2OmYlkfxtvMFqF3WDOkgadVRJ99ZthZtciYH/OePyQmER4qwNsk+pAr8oMlYULxWe2ahJP6aRB5df3mUP/Hlyr1UhWAuuj+X4Yun4j/HrmtN1tyViLFomZBbR4xKRCV09ZkNl+rV/oCAgOrRG6uHyxgpc5G2zUjOm0PSFdImIPLbA8GB2jf3xTZpubPPWFsy/7e5tErFgI43M3zdKZ7jASWdSxRVTiPK8bXZmNvDBiFera8N/F9ep1ntNCtGHzcdYOiGj/4juWcdWso0+1Qjz7tV2xbW1LA+5rm0NEScpxBPq5p/mLiJhyHj/PPvhiWEw0UyK3J+Sy19UACL7PWw/2TwYZREkUldlBCs+i2YdWwLqdoMrXdGWaxYlatKeDQ/dl+UtnhRUFE+Gl2N/orkbOsmvP+0QI4HnIwkRYHT0/7USRN2nNoHH8m4FIp+rZYCop/JF0nxEguaEAw/e9pn8pqGpXHOaisSxZraNqNNrLkBDHZos2dTu3JfoeB6bNUFw73L/tqs7N2NbsD+PQxwTpyENwNaeOpUY/wv+3r/5+uJZ1pQvu3hyjYeiK1OKU1dFkMxw6I7IY0aSDS+uTDmAIe/b0IllThfZpTp5NJbzkwElKdONt8MvJ8EPpq+j5QGSOTnyq1tlplrnqXpGIemeu0uob8fB8igsQhQQP3GCE3GxAvuzvWBJTBA5+SSXWhxyu7Vtj3RQ6wFGvvmO
 EhtGM4X+
 McSpRQ+qvJLo77YbK/TcJrCXpmEZVzY/R7V4e8R4UK2FktSBxd5V+Gv2yb+Hu5gf059fphx9t/JvwSuujyKwPYbkRx9euIra958/gDovZjF5jdB3IVRDrXMtL7nX3BQw/a3TRIunmY5rQW8kmK3jWsWd/5sXI5lAZexWIpywl8FW1HpfmBswOBTAFF7fczv6I5fLemeWM5kC2h+a+K3boDDs5qZl/r4wjTsN53ZPMLjdjdyLmvdzOAJdh6GB6MVPywdfhT6lvdXHNnJfKMyvihwpWt+ZVWblomIg5xIdVXkR86NojnevriPmos0h8QJdIMTyYhLDZVzBfYXyrQCCJ9z4mZ9+o+/P61QWzE0Jb1fYZqZI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 1 Jan 2026 10:07:13 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:

> On Wed, 31 Dec 2025 at 13:59, SeongJae Park <sj@kernel.org> wrote:
> >
> > On Wed, 31 Dec 2025 11:15:00 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> >
> > > On Tue, 30 Dec 2025 at 00:23, SeongJae Park <sj@kernel.org> wrote:
> > > >
> > > > Hello Asier,
> > > >
> > > >
> > > > Thank you for sending this patch!
> > > >
> > > > On Mon, 29 Dec 2025 14:55:32 +0000 Asier Gutierrez <gutierrez.asier@huawei-partners.com> wrote:
> > > >
> > > > > This is a minor patch set for a call_controls_lock synchronization improvement.
> > > >
> > > > Please break description lines to not exceed 75 characters per line.
> > > >
> > > > >
> > > > > Spinlocks are faster than mutexes, even when the mutex takes the fast
> > > > > path. Hence, this patch replaces the mutex call_controls_lock with a spinlock.
> > > >
> > > > But call_controls_lock is not being used on performance critical part.
> > > > Actually, most of DAMON code is not performance critical.  I really appreciate
> > > > your patch, but I have to say I don't think this change is really needed now.
> > > > Please let me know if I'm missing something.
> > >
> > > Paradoxically, when it comes to locking, spin_lock is better than
> > > mutex_lock
> > > because "most of DAMON code is not performance critical."
> > >
> > > DAMON code only accesses the ctx belonging to kdamond itself. For
> > > example:
> > > kdamond.0 --> ctx.0
> > > kdamond.1 --> ctx.1
> > > kdamond.2 --> ctx.2
> > > kdamond.# --> ctx.#
> > >
> > > There is no cross-approach as shown below:
> > > kdamond.0 --> ctx.1
> > > kdamond.1 --> ctx.2
> > > kdamond.2 --> ctx.0
> > >
> > > Only the data belonging to kdamond needs to be resolved for concurrent access.
> > > most DAMON code needs to lock/unlock briefly when add/del linked
> > > lists,
> > > so spin_lock is effective.
> >
> > I don't disagree this.  Both spinlock and mutex effectively work for DAMON's
> > locking usages.
> >
> > > If you handle it with a mutex, it becomes
> > > more
> > > complicated because the rescheduling occurs as a context switch occurs
> > > inside the kernel.
> >
> > Can you please elaborate what kind of complexities you are saying about?
> > Adding some examples would be nice.
> 
> You probably know better than I do.  What I'm saying is too general.
> spin_lock is good for short collision waits, while mutex is more efficient
> for longer ones.  However, I'm saying that mutexes place a burden on the
> kernel because they schedule internally.

Thank you for added explanation.  But, in your previous reply, you mentioned
"it becomes more complicated because the rescheduling occurs as a context
switch occurs inside the kernel".  Your above explanation ("mutexex place a
burden on the kernel because they schedule internally") is not adding more
explanation but just a repeat, to my view.  I'm asking what complexity (or,
burden) that you concern here, the internal scheduling is causing.

So, may I ask your explanation again?

> 
> >
> > > Moreover, since the call_controls_lock that is
> > > currently
> > > being raised as a problem only occurs in two places, the kdamon_call()
> > > loop
> > > and the damon_call() function, it is effective to handle it with a
> > > spin_lock
> > > as shown below.
> > >
> > > @@ -1502,14 +1501,15 @@ int damon_call(struct damon_ctx *ctx, struct
> > > damon_call_control *control)
> > >         control->canceled = false;
> > >         INIT_LIST_HEAD(&control->list);
> > >
> > > -       mutex_lock(&ctx->call_controls_lock);
> > > +       spin_lock(&ctx->call_controls_lock);
> > > +       /* damon_is_running */
> > >         if (ctx->kdamond) {
> > >                 list_add_tail(&control->list, &ctx->call_controls);
> > >         } else {
> > > -               mutex_unlock(&ctx->call_controls_lock);
> > > +               spin_unlock(&ctx->call_controls_lock);
> > >                 return -EINVAL;
> > >         }
> > > -       mutex_unlock(&ctx->call_controls_lock);
> > > +       spin_unlock(&ctx->call_controls_lock);
> > >
> > >         if (control->repeat)
> > >                 return 0;
> >
> > Are you saying the above diff can fix the damon_call() use-after-free bug [1]?
> > Can you please elaborate why you think so?
> >
> > [1] https://lore.kernel.org/20251231012315.75835-1-sj@kernel.org

You didn't answer the above question.


Thanks,
SJ

[...]

