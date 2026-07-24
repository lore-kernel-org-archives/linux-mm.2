Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66274C531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 19:35:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 278846B008A; Fri, 24 Jul 2026 15:35:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2282F6B008C; Fri, 24 Jul 2026 15:35:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F1186B0092; Fri, 24 Jul 2026 15:35:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D38806B008A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 15:35:39 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 64D4F160142
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 19:35:39 +0000 (UTC)
X-FDA: 85024674798.14.CA78D63
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf21.hostedemail.com (Postfix) with ESMTP id 47E411C0002
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 19:35:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=C1rXSWX2;
	spf=pass (imf21.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.177 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784921737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=52NE9Ozo8lcWHzI33LM+g+/jHOVCaJk/+w0sPndGSPg=;
	b=zAUO9uPNtORjdHc6rD36pUpDSVgNHEmGFFHKKN9u1hwlTj2Ec7Rehi1xnJim6cUBjrpRbU
	wVapOqr6MBOooBMyjJT7xiYJ4JV4IUobAEwXbbYmw/p0pFE8wPhyFF8H3uZnK5q2ay6Poa
	3aTNlKue6NFsNvlf2fs+Vlx7mVIAPbY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=C1rXSWX2;
	spf=pass (imf21.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.177 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784921737;
	b=BlHmJLjc2xPeRGSBM8gaORdC1fA6MxqlOrQkza8/AJdG/rtDEUIEy5z4TvvLKNLk/dXDXm
	glmDs1MAoV2OffHcfAhah8IQhybJ1hQxDsjnmM1Jhow25iAfct/TkFmOQcWSLxSfokfP1n
	pZOJRI1YKl2EQnzPsDqT/uFf+7Wa6XI=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-51c0006ea8eso7049721cf.1
        for <linux-mm@kvack.org>; Fri, 24 Jul 2026 12:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1784921736; x=1785526536; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=52NE9Ozo8lcWHzI33LM+g+/jHOVCaJk/+w0sPndGSPg=;
        b=C1rXSWX2gifTfGbkkBhwVe4pobLDtKaBDhRC/XU1Di459QfOPtJqpR4O+ygezy+dTL
         0Sn/6Nd0ePJdqsZnvibS+5r2wnoaM3QL26JFJoDL7XmYpmBuek/5W9kuiaPb+1LjaZkF
         SZegQoSH5iXJfvT6Qcwmoryr3A/fp0l5L2RRlgOzOvJbso2J8Kne0PUqCC3abIZW2BlV
         G9gRNfGpFSbnrxtdnMYGhrSltDZysVVqQ1K4pIl/P1onKqRk9DnVC3BeTFsGh/y3NewL
         fsZYdXVmMkw50Vp25RfSIJ09iOIsU2AeE68OQ7GhQ14wlhq34SJMQjWMSoOE3gy3AdWc
         rvhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784921736; x=1785526536;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=52NE9Ozo8lcWHzI33LM+g+/jHOVCaJk/+w0sPndGSPg=;
        b=AP7R9JKDRvaOShv4zeU58mXZlseXfpDCyuycglzUr8qZ+rhoku/FGMEQFj3VYJDMWu
         rK9M8TgxyR4oVIky7dxwOcHXs+N8JGkX33VAtn/QmXTvtgQPcqEeRsEr+66secjhwjEk
         HKhtG1W3rUN1Jjz3xC8EkbQjicp6vsKq0/khhb96oUSldhpu5B6iDNOBIazHjnYb0g5y
         iz9f3IaMy9z0qoA87gxvtah6MpxoEJLrZ3fDEkMXtPKuPyd0yb6uNy2D0bdS68NA2k67
         TUSZOs88HepkKCBNqV448d7d7j3m5Wq0XOmMyy+GfTHVY+Biqtwcor5ANAQP5UFgUXLc
         mQyg==
X-Forwarded-Encrypted: i=1; AHgh+Rpe6yi3spVxJlHZZ8f5A16D6JqR/B4cC5lTpsSvuwngZDKE4JvsJs7K8dbwsW0jfBMV9tfs80zY6A==@kvack.org
X-Gm-Message-State: AOJu0YyB5NbXERN4KgmdmY5zSgup6MDuhld8b9HlY3vzjncq4fsaAGmD
	ktf1rfFDY6aOOyUjKbA1jFlJCGLGk7MN/DkKaNv2pK7GDFvPUXuE9kKeh9ejhUL0pkiZgnbc3vc
	vBr7e
X-Gm-Gg: AR+sD11evfsC5NtBGHvV1DbYtCYZaeRfegVExMDdtQ1HAcrZbrnZeefjb4hM48XaGuB
	tzBrmik/5ecJg2ZD3kZ+g8GV8KlVi4Pm2l7ubRteIcCboMl9tG1ZPTGvF9DCBzPBX1hTwmAzkCt
	Ny7crf9eA9lVH0O+qdtEXoRjoyOpML8pySrWBSRtuRhn1IgkWDwHbK3wgvvW5xgiluH2Nak4k+l
	nX1DNPZPkY3GlBDfZdj/3lq4zzGRKnHfSh3q6/2LcdceOvyuuO+B7tXfbtA+gRQVMxlmR1mRxqS
	RnCm26W2HARn7f3rOA5/W+6FTacADoH5KlhPtWINYG0cU7mndww7bJKhixrLVWuCib6G+Dy1bDC
	BFxXi/JQ2k/Er5o4/qVpqJe9d9Gnd+K3Sa3XZCRGCmGpVNpLAw4R5/fn1oLg9hvfHCcVECyj13D
	E4
X-Received: by 2002:a05:622a:14c8:b0:51c:7b12:5fd4 with SMTP id d75a77b69052e-5283e012098mr87324891cf.80.1784921736375;
        Fri, 24 Jul 2026 12:35:36 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-529a280232fsm6175071cf.11.2026.07.24.12.35.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 12:35:35 -0700 (PDT)
Date: Fri, 24 Jul 2026 15:35:35 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>, Hao Jia <jiahao.kernel@gmail.com>,
	akpm@linux-foundation.org, tj@kernel.org, shakeel.butt@linux.dev,
	mhocko@kernel.org, mkoutny@suse.com, chengming.zhou@linux.dev,
	muchun.song@linux.dev, roman.gushchin@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	Hao Jia <jiahao1@lixiang.com>
Subject: Re: [PATCH v2 2/2] mm/zswap: Support batch writeback in
 shrink_memcg()
Message-ID: <amO-hwo8OGV5Goz0@cmpxchg.org>
References: <20260717085151.22822-1-jiahao.kernel@gmail.com>
 <20260717085151.22822-3-jiahao.kernel@gmail.com>
 <amF7_GB5Rl6OJmt4@cmpxchg.org>
 <CAO9r8zPaUPddYoLz8o+g+xkb-zdkfyB+LqaDOrkzqFSePEV-xA@mail.gmail.com>
 <amIdU1lFxqxTI3Gc@cmpxchg.org>
 <CAO9r8zPepaekOgaDaVBWyB_F05Ezvz+AJZ8M5+NGQ4BmiJNBkQ@mail.gmail.com>
 <d8de419d-0077-c47c-a5f1-37c229a853ed@gmail.com>
 <CAO9r8zNq3bRN+mumA5tcdizStpgoqTc++FYuGjvL8spbv4Q8YQ@mail.gmail.com>
 <CAKEwX=MG0F1+my1krUiOrHCn-Lypq2gq-g8Rv07Mz7sC=YEKaw@mail.gmail.com>
 <CAO9r8zOH93mfdjHq+Ljm7X+ykZS_rjzAvp9OBCzo+uyTbM1fDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAO9r8zOH93mfdjHq+Ljm7X+ykZS_rjzAvp9OBCzo+uyTbM1fDQ@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 47E411C0002
X-Stat-Signature: 6wg737nq91hmdfsw68hmg9nj43y4iyip
X-HE-Tag: 1784921737-912697
X-HE-Meta: U2FsdGVkX19rDglKtPCbYduTMRDnnTtmc3vopm1xwD86cnMjxRwpl8J/UIDEN/Zg0v3Zl78Z879Lhi+7L6IMddqkcrAltT8700dm14YRZpOsBjCHM4Ucyq+BQRjCvV/fFpHoTLRNNvbDMMrmR4W7UmQn5BUObC8JNZIK9kMCi19LyjfE0fOsncuvMRQuRZiGiOtL+wawhVE7+ipzB1QQtpHc5nMQWW42mhNwZWz20knC2eX53UZJ7TQB9e3TbRxRLBHxhoiQ/NrQjDAlv/8mYZjr8y8hH4/aM6oVsSgSWgvvsYz/Qu3KAJqdn1j0glaeZgoIlDYaGv8Ww2I5sKBkSbmC/tJDXurA8SGChOSspg3qTiDbez/uNESlkxMSij5IBfEBNAnyXfJHwPg2whYzmb7gtI2aBR7H5PVnjxdZO8g3YYg0xTqf2CHRtwSChTk1ykvqePkULF8cgCuIg5lpHa3JDviEn6vCBxFIk2OfLtQIwpIe48S9ErKGCGM0ODRvdSakhLiFHRuNl8XgfUz+oLkl/B8TK+Amhj1JTDmA/FpSf3Xa1w32ZCgsaC8TaRFkq2yCNGRO2IRdpUo8/mOAROC4uNYwrXUl0VSYaW2hgbehcYdTOviKR7/f0XGmVK/3OSJ7B2tIzCC8y3zAfjMfgw8jt8k0Qjp6oPBWwJ/pIkzzlYmbEIzpzYt9OfGThp3mtBE47ObWb8TH8sS54bipCK/rRLbqNuPU3zFgMu16vpB37N9HegYBfs1NKwQuuFD9N9ao1KGcvcb7o0E6PPi1P5osc/7uNvOnce33MBbcRs/jOgdqKXVe0lufCI1KX/PdE5wFKUBYaGI7gk4PWfefyMQ3jJK5iXN4zU3OwCvVDMLkwKu3+k62or0l3DP9KSeDvrqJex46jzLYD6/bbDbuxWAvIGVG8Mj6VdXzKDOPGuedidqEeh8q5RDQTNa9Cgrb+7VWtGuK5I3Fly8KmPy
 VVea5nGg
 E8UHaVMECPKK46RDGnxv+RZO94MNDAh9NulDFwvQwPxCtXRMnIZJiLr8nyOsoXa4YfnIdgZoisojMeu/irXG9u4FxlB/bPljsFIE409bqJZZuZcEn3GMR/RB1L49Ukr8JrTGkGaC9wx8ORWfI38GBazEDAobh8k9dg0Zt2X0OEpKtFle2x7hzXKwolZprxVK+ns8892crwbqhYS7XQEQSln/SB/LaOH2Xc9gAzqMSvwebh4kIH3Djnilepszd0jLVBmL/JLnjgzIMN5v4MxBfzvvgxXnhXm02LhvE/lfvnSHPpXPCJAHLP1acMscHJh/1W7EkWKZ5qh/8oRoPk+NyUQ2kqk9Ueg/tqjRg11dG1CXD34Q9qazZ7dlNjmeRimGjyWlRM4QJN33Oyhw1gpNrChIoVY9/ej2ss4TxgnbLlG7Yfdxskqyou7EC8nmlgAjAms5gy8wUzMpP4KFq3whCF1srl4yGWxuVbA6gEertER+fjn7AzTIfSFgI961aaesQt1KFjgtKBw0ZcwpmVfPwLUP2E7DiNO0bh5eZL98ui1bycTcDOjGW8e1fefyiDbssHCS3e4SgyUFKruugU/ILzu5/1CBG9I7sZR26
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 24, 2026 at 11:39:41AM -0700, Yosry Ahmed wrote:
> On Fri, Jul 24, 2026 at 11:37 AM Nhat Pham <nphamcs@gmail.com> wrote:
> >
> > On Fri, Jul 24, 2026 at 10:57 AM Yosry Ahmed <yosry@kernel.org> wrote:
> > >
> > > The numbers generally look good, the store rejection rate is
> > > decreasing and we are naturally doing more writeback which makes
> > > sense. The store rejection rate actually increases when the batch size
> > > increases to 64, maybe aggressive writeback is more likely to fail and
> > > cause a store rejection, so that also makes sense.
> > >
> > > The only part I can't immediately reason about is pswpin. How are we
> > > reading from physical swap more than we ever wrote to it?
> >
> > The same page can be swapped out once, and swap in multiple times :)
> >
> > Unlike zswap, physical swap in is not necessarily exclusive. You load
> > the page in memory, but if the swapfile is not full, etc. etc. you
> > don't invalidate the copy of the data on the swapfile. At reclaim
> > time, we notice the page is not dirty, so we just skip (z)swapout.
> 
> Oh right, I forgot about that, thanks.
> 
> I still don't fully understand why pswpin is significantly increased
> with batching here. I would hope that with less LRU inversion we end
> up with less disk swapin. Probably the test access patterns are just
> too random compared to real workloads?

Maybe more time in zswap for those tail entries left behind with the
smaller batch?

That's a 32 entry window that could zswpin with the smaller batch but
pswpin with the larger one.

