Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E42BCCA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 02:37:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F4C08E0005; Wed, 20 Aug 2025 22:37:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CCEE8E0002; Wed, 20 Aug 2025 22:37:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50AF18E0005; Wed, 20 Aug 2025 22:37:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3FDF48E0002
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 22:37:50 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BA39FB738D
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 02:37:49 +0000 (UTC)
X-FDA: 83799204258.23.1C6578B
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	by imf12.hostedemail.com (Postfix) with ESMTP id 157EA40002
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 02:37:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=CeTL2F4a;
	spf=pass (imf12.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.219.169 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755743868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=abh2xcvKhDlXl1t9fYOL5sKBFiJJIgTsOOzA5RbYIDk=;
	b=K3/Pkhj/ASvsSHMUyywjH/Y/0TIup5eUd7oNTZVS0q6Q+WHiV/RxMMKceJISL/XK4xEgvY
	SPKlvzqNbXQ6iksoaOxEdLlrmWllRwd4zxm8upb26cVKnvrZ2p8oLTCAMnARGJLHE7xWVs
	3PU+6LGB8DK7p4jtqYawv7yu+TsPxGQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=CeTL2F4a;
	spf=pass (imf12.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.219.169 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755743868; a=rsa-sha256;
	cv=none;
	b=2LzRuVxyJg2SvSXYdbm+2TUC2BSBeMtHSiN/2gYWquKfzDadJXwz/e7VBP7ZzpXvmk5+Ej
	xll6v2IZndTrAAs8nklYUUemAs/xUTsl4yffopdGNU4vaJ+PuK2RQHdIMREZOHzCwlK9V0
	sQr00n4M7ilrJeo9EKz+LXLsIYQ4Dgg=
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-e934b5476a0so545349276.3
        for <linux-mm@kvack.org>; Wed, 20 Aug 2025 19:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1755743867; x=1756348667; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=abh2xcvKhDlXl1t9fYOL5sKBFiJJIgTsOOzA5RbYIDk=;
        b=CeTL2F4aLwedtNCzuYwXQRmd/x/muvHFxJbv+Drr/oUNFyn2+COe1Ce0Tg4D3mXX4P
         Sey2IFvkllu/VQNG8gb6RiqIcz51XIT1R5XqCd2pSE3yyiOKK0UZLuo94ftITDgJ0EnZ
         G59+eBVMOObc4LY0HxlZbR0Vweg78dkfKKP/jSqFOF07MQbOZ1zEFmmcPT8gtVAPGqBI
         FvdjIRbSYR9+08Qfnb8PHbbeZgl/scK0UtQTTvX+mCyHc46T4vnQAzxLCq4VEQd6gv2p
         cgjOdfzry4TWK8DUBAQBI8Mrp5maacBGeurcP0IPa9asXWKqVk4MEBBBMx9LKHEwwsp9
         m3NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755743867; x=1756348667;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=abh2xcvKhDlXl1t9fYOL5sKBFiJJIgTsOOzA5RbYIDk=;
        b=fpyzb4oLgqvR+66pyYN10ehBZ3jSxc5k6NkpNT+GLv7CZ9sXy+tzisZEvs1yS/7+oG
         focGh9E63SBdTJ7qZS+uEfXJJGkPMvdb20Tc6LgWedJFsRq72+gshR4tRo1xZna4PLx/
         uSVdGacyQwSlHum1fufnTDgVwGkC7RCni46VTKfLhmvw9W2Kz1elBB3ZGSzqOOh8ZRH3
         iXdUT3Old47qOowxxvGQ0zt0f/my7pceitHj81Knil3g9Y8CAVtEVwlSVoclC0GfR3l6
         gLuJ0L3eqFT3msgXn/tsYfp0GiNd1MgNcg7BAKUZD8c1XNjGitce3xU11JBBk7gj6ZkP
         8ncA==
X-Forwarded-Encrypted: i=1; AJvYcCXE2f8D4rl5v3aQXgZFAa3BMMuXDZi2bQ2l7+myfd8EPuua5wyymWNYoDFUHNwcIK7v7YI+WgYAlg==@kvack.org
X-Gm-Message-State: AOJu0YyGrXbXrL94nc0eIBH1vM9JP6Sj4szz1mLFq7sjLUiwj+zdhDv/
	GgqwNW+do2OYMKxrVFKL7koL3HQ+VWorPxAceaEGl2XXOVy4PsWo3FcCew+U3E9MaoyrASj11Q4
	efnejXscWuFvjZIfRD+2+haLyjVu1gBksnecs7o594Q==
X-Gm-Gg: ASbGnctgio3pqAdMihzCQccRACc6/huKZ7B6LvZ1v/OfIZinhfKuK3UNiUNeO7GqBkx
	ABorhANDrQZxWwIClfIM7KbAyG2FnN4dHW9Zvz88gQoCwrCdFD9c1aDw/bTNNfHTCvmuIL207SO
	KaM2XFxC/HihEpE5TfMePpi/cv1tEJULGqO74iqQepbolIUpxZEw1c1z4FT6t5TanvOMbapk1x1
	hqw3P0DAwQsryFduK6KB56v
X-Google-Smtp-Source: AGHT+IHCZNM4nTpXJUz1hJfdzdPWtXBh+kRu6t2ury4CxvcEnKPHsqTQn2/FJDN7atiu1mu07hpYTwH60fyZrCS/jtQ=
X-Received: by 2002:a05:6902:100e:b0:e93:3f08:86ea with SMTP id
 3f1490d57ef6-e95088e6681mr875780276.9.1755743866982; Wed, 20 Aug 2025
 19:37:46 -0700 (PDT)
MIME-Version: 1.0
References: <20250820111940.4105766-1-sunjunchao@bytedance.com> <24119aa3-f6ef-4467-80a0-475989e19625@gmail.com>
In-Reply-To: <24119aa3-f6ef-4467-80a0-475989e19625@gmail.com>
From: Julian Sun <sunjunchao@bytedance.com>
Date: Thu, 21 Aug 2025 10:37:36 +0800
X-Gm-Features: Ac12FXyXvaqjw3gI0Ir1dBlPUBer24i_H2Sh9AFObdRH69tVXEonw0jQu0JZo9E
Message-ID: <CAHSKhtch+eT2ehQ5weRGEJwTj1sw0vo0_4Tu=bfBuSsHXGm3ZQ@mail.gmail.com>
Subject: Re: [External] Re: [PATCH 0/3] memcg, writeback: Don't wait writeback completion
To: Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	muchun.song@linux.dev, axboe@kernel.dk, tj@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 157EA40002
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: dss6gsu39pbgo3fqtdj7xhnqg96i7j6k
X-HE-Tag: 1755743867-10019
X-HE-Meta: U2FsdGVkX1+I2a/K+8OACh4OGxq9NSyg5/fpcZAvsaU9x1y8rx8XVYflb3ieINNKO+Rl3aSE5EJww9HYwpkta2OJJnMPXD4Mn97FcpthAqpeUdKuxteq49C67C12bIyCwGEFdRggRfc74zKOad4if4yLYW5hYAa1fmvvbnrtwPA/scgIvQplxza5IiwO5nk+ucW+OQcAo3fpC74CbAw9sOH6sJYNC5ByFLBMu4roKPWyizTA+zHB8NlyuiL14d7CR1Xlj5gTGjJ63icP+p1piRFzkRTnJxFi60g6UxjDohhrHEwGpr41T+vuZqSI3zqpsQt2l1hxkiO63F5J+6D5iMm+DHMtXS+D1dzKgDzVPICARMziTb2ikQaMHIPTBl9q8WFCRFjiAOzKWdXXx28/kq0/Rt/8zaKnw3tecKG+KXOHwtaHyCeSbIgU3RglJXR2NiNFqyHnjldNDGLbNEp175rB6c+o9Mpy5GPgKLMrHWOT3lHlYUE6ScpCknyJ6GZPyUyjBksXkWNky6hjiZS0zeUUQ3k39ilxxS0NxnaisD4D2BLOwvaMmdyuV42fzoFAV8ICAlXdr0sq+hcOLAeTOWQkDQWMlc2B1n0J9r/blaygIzDPdTxZ76Izc+mXnS4ZF66m2YsQE7+YRJu36ouQ1A8B+4KAl4gTIRM08sKDLgaAib/ZquNoc4Q0jgDOjCgviVsBHrTxgxZsJOdKeLpUfBEy20N7oXiuAGIYb33rv6xeRuArlxN351ikuVMeNj1mYPdzHHijJw84BOhZFCZsWkEeDx3hGSFbDwqEOIHtf35JNFKjmAnng2nUW2JC3Y0R3WvgqyvKXn+4KEpfhUWeNOKQtGh7nP56uXdRb48g424UaTS7tWCwsRUfj5I4YO2RzZ0267fO/heVacU5bH5cnSXVZIGw/K4UgXsNosv+wgI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, thanks for your review.

On Wed, Aug 20, 2025 at 8:17=E2=80=AFPM Giorgi Tchankvetadze
<giorgitchankvetadze1997@gmail.com> wrote:
>
> Could we add wb_pending_pages to memory.events?
> Very cheap and useful.
> A single atomic counter is already kept internally; exposing it is one
> line in memcontrol.c plus one line in the ABI doc.

Not sure what do you mean by wb_pending_pages? Another counter besides
existing MEMCG_LOW MEMCG_HIGH MEMCG_MAX, etc.? And AFAIK there's no
pending pages in this patch set. Could you give more details?

Thanks,
>
>
> On 8/20/2025 3:19 PM, Julian Sun wrote:
> > This patch series aims to eliminate task hangs in mem_cgroup_css_free()
> > caused by calling wb_wait_for_completion().
> > This is because there may be a large number of writeback tasks in the
> > foreign memcg, involving millions of pages, and the situation is
> > exacerbated by WBT rate limiting=E2=80=94potentially leading to task ha=
ngs
> > lasting several hours.
> >
> > Patch 1 is preparatory work and involves no functional changes.
> > Patch 2 implements the automatic release of wb_completion.
> > Patch 3 removes wb_wait_for_completion() from mem_cgroup_css_free().
> >
> >
> > Julian Sun (3):
> >    writeback: Rename wb_writeback_work->auto_free to free_work.
> >    writeback: Add wb_writeback_work->free_done
> >    memcg: Don't wait writeback completion when release memcg.
> >
> >   fs/fs-writeback.c                | 22 ++++++++++++++--------
> >   include/linux/backing-dev-defs.h |  6 ++++++
> >   include/linux/memcontrol.h       |  2 +-
> >   mm/memcontrol.c                  | 29 ++++++++++++++++++++---------
> >   4 files changed, 41 insertions(+), 18 deletions(-)
> >
>

