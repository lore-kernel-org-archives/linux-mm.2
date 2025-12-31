Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28CC7EE57D1
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 02:15:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 520516B0088; Tue, 30 Dec 2025 21:15:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AD196B0089; Tue, 30 Dec 2025 21:15:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E38C6B008A; Tue, 30 Dec 2025 21:15:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D9096B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 21:15:15 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B7A0CC1D27
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 02:15:14 +0000 (UTC)
X-FDA: 84278148948.17.6DD9FE1
Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1C8291C0004
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 02:15:12 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DEueX3N3;
	spf=pass (imf20.hostedemail.com: domain of rgbi3307@gmail.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767147313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TjfTZhxsuFnytCHStJNb8M8EerX5fb1TydQlSsVH+Kc=;
	b=HZMDNpndNs7HRsbMUSJkCzkMveKo3tZpzB7j+3+Z65ldQu/7STrMHtV0j9yi6t1GUNpyrm
	1x8aHr1bWHoh+nbK2QFPmE247zH7VEyenVuGuUkiVoHiIRTwczV91O4h9D5FRHtnfYPTyF
	KrfQ/dRxhoXutTXX67GL2vwnPuexFjo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767147313; a=rsa-sha256;
	cv=none;
	b=0n5mUd9w2/ZDVHpDSjxZns4YGCoSTEw1ZXCQlQm9b2NGbGgeHKKgGL3bvVsXF2yNy+O1ad
	npjqY9l0mJ1sGZjksPBbXzVPgCFyny+icvGoX6n8UUwE47MjFp7V4NoOQiSDSedIJPw+mL
	4afycd9nnV5hZyCyRmWHr73MEQFjBvI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DEueX3N3;
	spf=pass (imf20.hostedemail.com: domain of rgbi3307@gmail.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-646b8d2431dso2024729d50.2
        for <linux-mm@kvack.org>; Tue, 30 Dec 2025 18:15:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767147312; x=1767752112; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TjfTZhxsuFnytCHStJNb8M8EerX5fb1TydQlSsVH+Kc=;
        b=DEueX3N3ba0EyDWh/L1wUvdehn1wQkdGsqkEMeT9WDjU3HxYCCbdTiAbHAC4kKTBVH
         RLc5lCvaPu5mqjXVXBwZEsbKD7HEPNO+cg5AAoQ7Or6CPVjEOkQk4eeUoqmufRzGXM8E
         XvAGcY5ReCMmaCjERqdS9QmVOyPIbP+ZBVBLSLPZCFVFA7mzAnfQG8FLw6lb1VQeIs3K
         gTYdykLQwB2K9EAkr21vkX9TuRmpgTAu7veXWK/GPy6yMFW0c21T6G9oBFbLgacZjuCi
         aQOQkJXct6UB+tJSM/aARlyxmHD8DtzipMpu9Nh9hBmONNQ6mA4r+tx2OjAVMBF8NqJa
         GseQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767147312; x=1767752112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TjfTZhxsuFnytCHStJNb8M8EerX5fb1TydQlSsVH+Kc=;
        b=qGTWgKuJliZDDdOzpIfMcJfMsbYiIQLwmX+6ffuCf32NjbeHdHtTcpH+kLzyaSK87j
         abyqZ5+fwZGPQQnEzH+j+vYYrzahHpKFkryQDuiMpIDNStdyppOS9YSE5EBuTYQFuPOM
         bsCqCEnIIuQHKwEs4XPgQsQI7zueI8bBSmm3Hhh6hWeROIrcw4/wsLmkR6r/k3ODRpPr
         5FmWAnnzSRF3PBTY8S17uVWTaDvXKKofS2iBhtYFqCy+lqF9OijPEWlP7Pb/hvQ4+rBt
         tMk7fyPj65fzEj06la5b0F8xJYpoZMSay4KUejnAQAWaUEFrHkEGFeAqWvfwwVhMNEJ2
         fcPQ==
X-Forwarded-Encrypted: i=1; AJvYcCXzcTsN0xsxLFiXnEtHJVtTJWg8rgsnmYDb2d6G4AjCRxg9cUtKmVmU00d6hkh4juMJ8B3+0DT+Lw==@kvack.org
X-Gm-Message-State: AOJu0YwNbHdyt1pMVn/b8kcubm52gKswy0phjhEG/o/uI9rp6tacZ9mc
	lSStN4VTugd4Mn1HMrv0NeR3K5u+EExVBOQDHilyP6e7VUNeX08n3trGqbs4aesW4DF7TQzwWTp
	Nfrz2w8/vYHxAhLUw1xamZ3rkkf23itI=
X-Gm-Gg: AY/fxX6Pj3kkRN0KhK7vI+dIMmaEfMTY1xygtlHxKT6Y1znQL3O8KSVo63BrZb4qsKm
	AQEYYK/moGokw2tr1sc5lDXBGSHYC580OBnNvtNrYHDkc0C4l+XdA62B0/6eEy+l+t2MaEHYiv1
	ojPCB00YjOJmLcs4AG9CoFoPGcoDyzS2/dtUjSvM+a1rLRbQwAlgQOCS0Stc963yIZHnSObUJsu
	umUXgzeDSNHxXP06AjPf1WH2r6JhdytxUCw+RMQutqvimzcrbW8ouwLE3uJck2W6aZi1U4v
X-Google-Smtp-Source: AGHT+IGL4DyIhhfeKJjVZUle8A3hNbfdiDShjwM2p95/bqd+VS+m5HW78WKGClsmtpLuHw6mEKZ5Sa5sxwI4ASCK3b8=
X-Received: by 2002:a05:690e:1914:b0:645:5cf1:7685 with SMTP id
 956f58d0204a3-6466a8c9570mr26677749d50.77.1767147311921; Tue, 30 Dec 2025
 18:15:11 -0800 (PST)
MIME-Version: 1.0
References: <20251229145533.2437293-1-gutierrez.asier@huawei-partners.com> <20251229152250.78975-1-sj@kernel.org>
In-Reply-To: <20251229152250.78975-1-sj@kernel.org>
From: JaeJoon Jung <rgbi3307@gmail.com>
Date: Wed, 31 Dec 2025 11:15:00 +0900
X-Gm-Features: AQt7F2p3gYsDqr85ZYvuCiGLXjJute9alqoQns-Mc9ZwsH3742lbbwiyDQb2AQ0
Message-ID: <CAHOvCC4FhpLrknhvWbDd=cxaLUyxHFkFxBDYSC3waeg4FC+TBg@mail.gmail.com>
Subject: Re: [RFC PATCH v1] mm: improve call_controls_lock
To: SeongJae Park <sj@kernel.org>
Cc: Asier Gutierrez <gutierrez.asier@huawei-partners.com>, akpm@linux-foundation.org, 
	damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	wangkefeng.wang@huawei.com, artem.kuzin@huawei.com, 
	stepanov.anatoly@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: ukp9rgk68fu8pjx9ic7bwmzhxo3f7w9y
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1C8291C0004
X-Rspam-User: 
X-HE-Tag: 1767147312-21395
X-HE-Meta: U2FsdGVkX184qPaqcDgcI0wp/IdkJ4nDXB65b90/iVl89KNhW3Bt2sk/Y8q4H50v7QoN2Z4iM0i4SNE750mDbblhdIHrifg4m8R12hYA1AsJmNcpLWav8T/Ne0B/50EKwNMqS9bqVAoXYLW3l1FNHUwTy86j54tktpK+EvUBoNVIIVcSnzE6CnNs0DnYDL7j9KHG8gn7qL3a7zWbNxNy990Ldf/mtUE92QLJwZLvDQuqW1lFQAZZiH/Slq/2gPMNXxxe2Wh8dt0bo4Q+olGwSjTnf1MzAmtWtPqE2Lg1SmfSnSQfHdWuctQq2kIi97SysRNFWyzjgCbbTNwq6y4Qj1mYLlLikY88ggqqoEIuk40f1aumOC8mHTkBmRhQCZ54wwVRCoRB51dhLyJ0TloAXmN5cwSe0LtACYuLAvBTBDf/pLSjsMMXyonCQ0DAUq9nCpGZoc7nwD6HZysvbyASCWIguw4nsJFi8Rqr0M8qQYwGMNF38SfuDqoXUpCziVNXGKUVBk39hYkev9B0egzjEHZC8DGc5+76eUXGNHWBelgF2CBPE5DS1NlWy2sRBfIE9XeQCioBYPuaIlY2SZQvdrXimS8SRCl8EM4MdMEzA3b9KyBK33W+BKMzkzJvuDFWzDZAobDsQU3HRY+wK5GM1VjtfRoc0pEiIAnLB5cKDVy7kwKsQF4WM2NKYxmYTgr9vmU/6f6grYLMsJt4m0ygyi9Mi6O3xJivPGqQZNH1PEXN0uSl4FGtOxEPP8iZnwUfNJ4jDx46Aj4kCeuiALPHp6dvf/liWnlHiAzpm1/da62QPAjcwSoUf5zi/wy9RGQ4y2M+UX8qM+8WN47XTRjFJjbZTphVO8b2gpUTBAiyWoAlvFGO+HfXbK76aFepDQYXISmwtPQCrs2b6Ng5AuYDA9Q05llz8lmoMT8LN5BXaiiF9XtIZB+QSJUsILC16rax642Es7e/3S7rSukIoBZ
 LtaUpf65
 f0BbeWSHcDqnnafNhe/x4Q62ixA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 30 Dec 2025 at 00:23, SeongJae Park <sj@kernel.org> wrote:
>
> Hello Asier,
>
>
> Thank you for sending this patch!
>
> On Mon, 29 Dec 2025 14:55:32 +0000 Asier Gutierrez <gutierrez.asier@huawei-partners.com> wrote:
>
> > This is a minor patch set for a call_controls_lock synchronization improvement.
>
> Please break description lines to not exceed 75 characters per line.
>
> >
> > Spinlocks are faster than mutexes, even when the mutex takes the fast
> > path. Hence, this patch replaces the mutex call_controls_lock with a spinlock.
>
> But call_controls_lock is not being used on performance critical part.
> Actually, most of DAMON code is not performance critical.  I really appreciate
> your patch, but I have to say I don't think this change is really needed now.
> Please let me know if I'm missing something.

Paradoxically, when it comes to locking, spin_lock is better than
mutex_lock
because "most of DAMON code is not performance critical."

DAMON code only accesses the ctx belonging to kdamond itself. For
example:
kdamond.0 --> ctx.0
kdamond.1 --> ctx.1
kdamond.2 --> ctx.2
kdamond.# --> ctx.#

There is no cross-approach as shown below:
kdamond.0 --> ctx.1
kdamond.1 --> ctx.2
kdamond.2 --> ctx.0

Only the data belonging to kdamond needs to be resolved for concurrent access.
most DAMON code needs to lock/unlock briefly when add/del linked
lists,
so spin_lock is effective.  If you handle it with a mutex, it becomes
more
complicated because the rescheduling occurs as a context switch occurs
inside the kernel.  Moreover, since the call_controls_lock that is
currently
being raised as a problem only occurs in two places, the kdamon_call()
loop
and the damon_call() function, it is effective to handle it with a
spin_lock
as shown below.

@@ -1502,14 +1501,15 @@ int damon_call(struct damon_ctx *ctx, struct
damon_call_control *control)
        control->canceled = false;
        INIT_LIST_HEAD(&control->list);

-       mutex_lock(&ctx->call_controls_lock);
+       spin_lock(&ctx->call_controls_lock);
+       /* damon_is_running */
        if (ctx->kdamond) {
                list_add_tail(&control->list, &ctx->call_controls);
        } else {
-               mutex_unlock(&ctx->call_controls_lock);
+               spin_unlock(&ctx->call_controls_lock);
                return -EINVAL;
        }
-       mutex_unlock(&ctx->call_controls_lock);
+       spin_unlock(&ctx->call_controls_lock);

        if (control->repeat)
                return 0;

>
> >
> > Initial benchmarking shows the following results
> >
> >
> > # bpftrace -e 'kprobe:kdamond_call { @start[tid] = nsecs; }
>
> Commit log shouldn't start with '#'.  Please consider indenting the above
> command and below outputs of it.
>
>
> Thanks,
> SJ
>
> [...]
>

