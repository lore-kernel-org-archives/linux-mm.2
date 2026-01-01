Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 039B2EEB577
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 02:34:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6892A6B0005; Wed, 31 Dec 2025 21:34:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 637616B0089; Wed, 31 Dec 2025 21:34:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 543BC6B008A; Wed, 31 Dec 2025 21:34:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 40ECF6B0005
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 21:34:28 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F21101411F6
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 02:34:27 +0000 (UTC)
X-FDA: 84281826174.23.FDE0CE4
Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2E8171C0002
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 02:34:25 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RSIrXtqg;
	spf=pass (imf18.hostedemail.com: domain of rgbi3307@gmail.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767234866; a=rsa-sha256;
	cv=none;
	b=toN/PZ8EWO2JkB1lsVfNSHaBKmC/BSA0rug+RPc9RTOHzeCPxI4CTvB9X8GnVf6A7D2o34
	AGQnF/rHm/vYKCVH2bTURIqXqx0RwXld3ctCDIxUnnEpL1yIo55GqoXjEPRBoaaZN6k5l3
	5t2oGVJxwDHT8QVs0jTXajRm5h/bkPg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RSIrXtqg;
	spf=pass (imf18.hostedemail.com: domain of rgbi3307@gmail.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767234866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X6sWZLRmGf8XzUeHmImAxpT7l30oyOZDx/Iyh5mXQB4=;
	b=rNzZ9AVjoEFj0Kaj/sGJ/Auogm9L6mNOpO6AQR0eie7HiIcCvQuyvx0gbne0St5uNswtDg
	skS47WRIEdueHmNVnHVL1twFnC/UKkIJ3ymaJ80T8+pSM9t8hepF3fiUlydrbUCaTN2y2j
	XPF6f8Hx14nYLdUgZnt8d6A2ujrG7IY=
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-6446c924f9eso9914033d50.1
        for <linux-mm@kvack.org>; Wed, 31 Dec 2025 18:34:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767234865; x=1767839665; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=X6sWZLRmGf8XzUeHmImAxpT7l30oyOZDx/Iyh5mXQB4=;
        b=RSIrXtqg5gk0716h4DGs8TYTNILzmR2pIVdX/gNw+k5Y654PP4c+PCONWUl2AelK3A
         hNzp6/GP9CXJAtifcEubx0s/tsFE8VUXJemSMuMFIfULbvuhGI25C42sc5VgA544B6P6
         BudnKG6oN7U1nJ6eFUu33TWv7QwpL5jHe6JK8JQvF4v/nQsv3smjNuIN7dbQ+dNGrtf0
         1zs61zwSafqfW2w9mw9FxDClk9PSCAC3PD0QthzQ7ds51qFmuRG26KWJVjMY1BXgLM3E
         07ha7ZKgkTQXCKHYnuhP7uH0iyUi3J42cb4M6MLMIfLkx7zNb51E3mUdQ6jgwL4IYlR5
         yD8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767234865; x=1767839665;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X6sWZLRmGf8XzUeHmImAxpT7l30oyOZDx/Iyh5mXQB4=;
        b=pXAN7siDhb/S45VLLLZu5sWL5Mk6pLQwPSq362zFq9XMb7zMtri6wbfH8JRYhw+dC4
         R1Gdrdjw3Jyu3I0kV32KZmu91Ds742LSUtqYDn00LWNcYdGlobuaLjFG2hDeVIerPGW3
         PsV6B1V0OKZVeW7jB6sZbTgYhVZxCPOE0qd0QLCclYJM9bPhdfcuDIV9ARX0Dz5qM533
         6P/pSTMXEQpWzmgK8hy2kCxdEZpmRSTUG5mNq+F+s6wDMl4lxSCGo+kCKeTIQUt4uVC7
         A5dXaVdr/uXbVfSwIq7eiNV+Uqvrw+X8IszBRSt5THkBlQDdAdyo9QcPF6w6Q+hPWkEo
         mL7w==
X-Forwarded-Encrypted: i=1; AJvYcCVC/r/wzykJefndL+9caxviUeoK45c/kd7nDPrNatmw4/jDO5lyeMW3fSP5ND1ggIXog9I71NIa2A==@kvack.org
X-Gm-Message-State: AOJu0Yym2jFJ5Gb4Sv7Bvm3PRsRDTfUa+jtR+b42MVW+lO1i8p718qZx
	pg/fH1mHcjeTFKfMYrudLabEgGW1hcf25X5otZr/B1x4z5sbeLsOReeJ3xmSGpLXn5vT8ugsqJF
	YwoYIyiDQY43KGnKZYqSfLde/c7ALbrs=
X-Gm-Gg: AY/fxX7hWNIJOiZZYYn+c+5ePzdotOpi7/0ENfV5Evm6QMvTA4B2gqDXM5WxEd5Zmfc
	TXlnG7mNLhFpHczhBtoIaujpJ5RLUDFp72moyoFHU6aLP2t7aG+KHYiFmBMKsONW7oy/Hr1WBR2
	RHlZXEhyX8UjaO2h+t1ULfNO2zV1RZ7gDJ8vf/3KGic99lIhXetS5AcgYiBsovqZQv65UVG6d8X
	+bjHrQVQGNNUS8JF052ae1kFN4mxKxGCBMqccIAXjugsN4gTCygJfazYkGShwPX0LKOo4e9
X-Google-Smtp-Source: AGHT+IGwbxQUmQAg+3ZYoLCwo/zfbvy0ci3uD0B/Y+5bdBsXdTN4KG769swe5D0Y5FcE+w9kIzARSt/4JaOMiHYMjZ0=
X-Received: by 2002:a05:690e:1586:20b0:641:f5bc:6972 with SMTP id
 956f58d0204a3-6466a912ce3mr26239292d50.78.1767234865232; Wed, 31 Dec 2025
 18:34:25 -0800 (PST)
MIME-Version: 1.0
References: <CAHOvCC6or4a5YM-byNFkB4q8v8YO=ZrT0VymYQfSXEx84wgeZw@mail.gmail.com>
 <20260101020028.88096-1-sj@kernel.org>
In-Reply-To: <20260101020028.88096-1-sj@kernel.org>
From: JaeJoon Jung <rgbi3307@gmail.com>
Date: Thu, 1 Jan 2026 11:34:13 +0900
X-Gm-Features: AQt7F2rRhYsi4UukPhK-fCydGkFg7mvJP2beIaLDNsKcp4I3Wqayojuht6he99M
Message-ID: <CAHOvCC5Frn16MiaP7AjzvJNPfnGXyjcWmhtwNnKQzXwz3VUL9w@mail.gmail.com>
Subject: Re: [RFC PATCH v1] mm: improve call_controls_lock
To: SeongJae Park <sj@kernel.org>
Cc: Asier Gutierrez <gutierrez.asier@huawei-partners.com>, akpm@linux-foundation.org, 
	damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	wangkefeng.wang@huawei.com, artem.kuzin@huawei.com, 
	stepanov.anatoly@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 2E8171C0002
X-Rspamd-Server: rspam04
X-Stat-Signature: dfkctnadgmbccnmjwm19y3ds7sa8xd4p
X-HE-Tag: 1767234865-738871
X-HE-Meta: U2FsdGVkX1+pp4iQM6RCJ/kmnyr7tcQtJ14xS60sUYUYAeYt4AwXebrMCU23k2MeR9oXmu49FnNrE/qFoponX00p1QZwkXaV4RxIPIeNsG5MchRBwm0Br4+FwrqUgJhREC1TxyHjJiUZOAEZk8+pIhlKdgENVopVpKvQg1LvQ1nPsjYlnWrtgziYLPlp8O0KNkUadaBOTFxfCO7drRYymGTtl3CIG6dtmG7sdnuldrrCU3Sg36O7ET725UW5PG5a84iUz49HRcR6LrbPx1F7KojdC+a57e0AGKp8GX9HeCgmFc6HH+DlC9jzrhULKPTYR3V4eVyf0wHP8qyQwE6gZZIiOCEb7wjxSkyISPYR9dwI/4QD0EWJkBN6n33YlCSSytoomnKWMVHM8FOpaZ+Mrj0NpuAvm7qaGnDWUzquy7bBxNrB7POO9fQV+RSzEnK0CBrERW2B0H/dzxrQ90V2EGrW7fbxvJ+rPV15jv6RJYaUzt9Vmu+OD0nHsVjzBUD19prDJMOxleZIDR1YyAQkT/il4deb91CWXxfJVxydQMUZOaWw4GQDn/eVIjeTd+ophX54mXfADI7kw8gtRSz5e/PHkQFYQmHEi5Y3c5s0ZIH0SckN8vBnnZBQpBJK/m5aWczxuYPNRHFBI0YYp9m9ShvttCQwp5l6IniSY0S8qHAz1m8D41gHONOjFyf6WT2JUhOY87fQfL4H96cUPG+OYMzhc5QdCcNrydjd6OEl3j/vbJjAJmhFVTuFQ3I3hRifv1Lu+vfLXILv4x8L8jNfxLJtqUOT3dtMxuEFaSNqoBL2FBesQOmV5ySv3i3kdJ8oq320htqocSl9/40/NrhEV6NLy2BUrFTlsFEeWKXK0BQUx3mNSHVWXOaEr2SW7vTWwPyD5kt0FR5SpFQI193L1nNWe6C8Dzysp2Z350DYLZMAFMWDgi+/3PONBJwB0YuBEEynhgO5JNaD3EZxPT5
 sunXwQf/
 pcpkWtXYWfWsuF/M4z2qJRJgNZpY6aOAPMHlzvqjBpkpP7p+si+egSV1bxC0QmclhB9DwKQAt7Ws7/guPiepDZqkbpLTQ0aHwm+QxBNaKe3I8o0ChKx5rxBv1/T7sRz8cHUIN+Qxfq6LZujP7Lsue3gDqn3vwjn57L9gIhHRGqUICKD7VhThR6UfApKYKK1tqFp7oq0lCdcMunBXy3zlBX+cAFeCpSuCrr6VZgm0sKcCibR34hoXaAUtmmsWTH1pRZd2f9sGGR3onVDPTvrv+QWsKNWESTBlt9Tvpobs8QnAZCP3pb8ItEeO2kP5GDwiW88PlOTpvkYQt2MyWw+PtBUyhdGEsfz+FxMsDPqITyNvp0Z1sP68Dq1mQhlJIAQ3F2ggEAwBRsU97u1Tr9GLvjMEspONlxmV/unwMrCqIjDeVUydZ7DI6o7cG/XlqooGY3H6Vgsx9LjP7Xyk12vgTQzeLzZe5HUYJR6cL5+gjp7/xM1Gh1iNz5mMv5TrnD3vtVDyC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 1 Jan 2026 at 11:00, SeongJae Park <sj@kernel.org> wrote:
>
> On Thu, 1 Jan 2026 10:11:58 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
>
> > On Thu, 1 Jan 2026 at 00:32, SeongJae Park <sj@kernel.org> wrote:
> > >
> > > On Wed, 31 Dec 2025 15:10:12 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> > >
> > > > On Wed, 31 Dec 2025 at 13:59, SeongJae Park <sj@kernel.org> wrote:
> > > > >
> > > > > On Wed, 31 Dec 2025 11:15:00 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> > > > >
> > > > > > On Tue, 30 Dec 2025 at 00:23, SeongJae Park <sj@kernel.org> wrote:
> > > > > > >
> > > > > > > Hello Asier,
> > > > > > >
> > > > > > >
> > > > > > > Thank you for sending this patch!
> > > > > > >
> > > > > > > On Mon, 29 Dec 2025 14:55:32 +0000 Asier Gutierrez <gutierrez.asier@huawei-partners.com> wrote:
> > > > > > >
> > > > > > > > This is a minor patch set for a call_controls_lock synchronization improvement.
> > > > > > >
> > > > > > > Please break description lines to not exceed 75 characters per line.
> > > > > > >
> > > > > > > >
> > > > > > > > Spinlocks are faster than mutexes, even when the mutex takes the fast
> > > > > > > > path. Hence, this patch replaces the mutex call_controls_lock with a spinlock.
> > > > > > >
> > > > > > > But call_controls_lock is not being used on performance critical part.
> > > > > > > Actually, most of DAMON code is not performance critical.  I really appreciate
> > > > > > > your patch, but I have to say I don't think this change is really needed now.
> > > > > > > Please let me know if I'm missing something.
> > > > > >
> > > > > > Paradoxically, when it comes to locking, spin_lock is better than
> > > > > > mutex_lock
> > > > > > because "most of DAMON code is not performance critical."
> > > > > >
> > > > > > DAMON code only accesses the ctx belonging to kdamond itself. For
> > > > > > example:
> > > > > > kdamond.0 --> ctx.0
> > > > > > kdamond.1 --> ctx.1
> > > > > > kdamond.2 --> ctx.2
> > > > > > kdamond.# --> ctx.#
> > > > > >
> > > > > > There is no cross-approach as shown below:
> > > > > > kdamond.0 --> ctx.1
> > > > > > kdamond.1 --> ctx.2
> > > > > > kdamond.2 --> ctx.0
> > > > > >
> > > > > > Only the data belonging to kdamond needs to be resolved for concurrent access.
> > > > > > most DAMON code needs to lock/unlock briefly when add/del linked
> > > > > > lists,
> > > > > > so spin_lock is effective.
> > > > >
> > > > > I don't disagree this.  Both spinlock and mutex effectively work for DAMON's
> > > > > locking usages.
> > > > >
> > > > > > If you handle it with a mutex, it becomes
> > > > > > more
> > > > > > complicated because the rescheduling occurs as a context switch occurs
> > > > > > inside the kernel.
> > > > >
> > > > > Can you please elaborate what kind of complexities you are saying about?
> > > > > Adding some examples would be nice.
> > > > >
> > > > > > Moreover, since the call_controls_lock that is
> > > > > > currently
> > > > > > being raised as a problem only occurs in two places, the kdamon_call()
> > > > > > loop
> > > > > > and the damon_call() function, it is effective to handle it with a
> > > > > > spin_lock
> > > > > > as shown below.
> > > > > >
> > > > > > @@ -1502,14 +1501,15 @@ int damon_call(struct damon_ctx *ctx, struct
> > > > > > damon_call_control *control)
> > > > > >         control->canceled = false;
> > > > > >         INIT_LIST_HEAD(&control->list);
> > > > > >
> > > > > > -       mutex_lock(&ctx->call_controls_lock);
> > > > > > +       spin_lock(&ctx->call_controls_lock);
> > > > > > +       /* damon_is_running */
> > > > > >         if (ctx->kdamond) {
> > > > > >                 list_add_tail(&control->list, &ctx->call_controls);
> > > > > >         } else {
> > > > > > -               mutex_unlock(&ctx->call_controls_lock);
> > > > > > +               spin_unlock(&ctx->call_controls_lock);
> > > > > >                 return -EINVAL;
> > > > > >         }
> > > > > > -       mutex_unlock(&ctx->call_controls_lock);
> > > > > > +       spin_unlock(&ctx->call_controls_lock);
> > > > > >
> > > > > >         if (control->repeat)
> > > > > >                 return 0;
> > > > >
> > > > > Are you saying the above diff can fix the damon_call() use-after-free bug [1]?
> > > > > Can you please elaborate why you think so?
> > > > >
> > > > > [1] https://lore.kernel.org/20251231012315.75835-1-sj@kernel.org
> > > > >
> > > >
> > > > The above code works fine with spin_lock.  However, when booting the kernel,
> > > > the spin_lock call trace from damon_call() is output as follows:
> > > > If you have any experience with the following, please share it.
> > >
> > > Can you please reply to my questions above, first?
> >
> > I have answered your above question.
>
> Are you saying your reply [1] that posted today?  Unfortunately I was unable to
> get all answers to my questions from it, so I asked your more explanation as a
> reply to that.

I'm sorry, but this conversation has gotten so long that I'm getting lost.
I've given my opinion, so I hope you understand.

>
> > And, since call_controls_lock has a
> > short waiting time, I think it would be a good idea to consider spin_lock.
>
> This sounds like you are only repeating what you told so far, without
> additional explanation.  Hopefully the additional explanation can be made on
> the thread [1].  Please keep replying there.
>
> [1] https://lore.kernel.org/CAHOvCC65azs4BU2fyP-kxvFWB3ZPCfyZ7KCO8N1sc0jtTENmNw@mail.gmail.com
>
>
> Thanks,
> SJ
>
> [...]

