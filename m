Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A6BBD116F3
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 21:35:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B91176B00AF; Mon,  1 Dec 2025 16:35:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B68D96B00B1; Mon,  1 Dec 2025 16:35:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA5AE6B00B2; Mon,  1 Dec 2025 16:35:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9A98C6B00AF
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 16:35:26 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4CA601320CC
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 21:35:26 +0000 (UTC)
X-FDA: 84172208652.14.9C6CCC3
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf03.hostedemail.com (Postfix) with ESMTP id 60C0A20013
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 21:35:24 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CkmbJDLE;
	spf=pass (imf03.hostedemail.com: domain of yuanchu@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=yuanchu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764624924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pztwMSM/xJ8ORFd02azXUTlR9KBkGnFnYMXGWY/ok94=;
	b=ULLRRvFx+mw3n7OOrCtJeYemUQco0czBoCH4ZJdg0BCvSbpihqGXtfUFYi1LrQmGVi/x8T
	Z3TaqvgqitjULR8vnCcXuJZKNbQX0chhPXJfOBMgaRiI/7H9SGlFrLz04bxfM/zXVF8wuy
	nJu4n1XvI271uDxBcERmoGmJZHAxEwU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764624924; a=rsa-sha256;
	cv=none;
	b=jJ/4B4/1xvJbiRCxnmnc0rnIjVunrP6AQPbY7rbSbyMynBLmfcFm+MUMHgXh4vGgrneFox
	kOtR/QdknrdJDE38uZNxTwpDdNAhw3KBNVGvrvVmex3JKQ1ykQWHbu5BiQsRmA3HWCPapy
	DE84jrS04vBFDs4nVDDwY/XLE6+FlUQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CkmbJDLE;
	spf=pass (imf03.hostedemail.com: domain of yuanchu@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=yuanchu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-29852dafa7dso839805ad.1
        for <linux-mm@kvack.org>; Mon, 01 Dec 2025 13:35:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764624923; x=1765229723; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pztwMSM/xJ8ORFd02azXUTlR9KBkGnFnYMXGWY/ok94=;
        b=CkmbJDLEJht6kUguLSpirO1GKUuiZ/1B2doMXzvQiT03LAQMXFEwPTrI8xM5+Ph70i
         BGpS0nJRvai31er/AOckYC02XiYox5OlwzcgJmQXSgpO8ZJzwhcJUjQ0I8SviXmEhfpc
         h1TrSVjBdNr7h2jgmn/8OMLhUaLVLDvLJTimYPIGf+0+9emQxED/CU9hJu6diOJ0Cezm
         MAr28dPdVQ8QtIfzWS41zQFrSrauN9taFKw99jw5EHGsH2NnGDrcls1swpWkU68Yvz8h
         +ECqnXi//5YMokMzDzcA73cnnopOQlrHUCTt05OyEZU8wWSLIvRhVN9Ctmml+AyuyzCu
         MTZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764624923; x=1765229723;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pztwMSM/xJ8ORFd02azXUTlR9KBkGnFnYMXGWY/ok94=;
        b=iK/vDMoRKTx8MmGe4OiFjz82tpds+E7NHRqhM4rMMdewMjZFraxPQa3U/46Qf2cwpq
         U2Y7Pan5fCJqPWm5AYWZV4xsnyJt/4uenwxdirOFXou5e3kJ9NbUmwMLgiDZ2ZWxSISc
         pJiUk9cpYsKLNDpawoLd1rKFqOmT9BgJ3QXB6HK33uWvI5/yhhV3akLrWxqskn40s5+t
         d1X70l+cM7jfUF3jCZgwzNTZPKHx8XCC6G1dZdVd/FRDUHdHLRku/eKxVrPBhk+2mKBt
         Z+A8Y9BzvL9F4Oafyxf6lS8YdFTM7siP5Q1jRutgF8d7SMxhBu3hWOLV2aNpXS5Y4mNR
         8KRw==
X-Forwarded-Encrypted: i=1; AJvYcCU8uOsv5yuKuJLOLSirTiC+B1ZB1sIzJJXTDcbEbYiO8EwGp1Y8+9ELXXa9kGEIDgKd+zSSMTARzA==@kvack.org
X-Gm-Message-State: AOJu0Yyr2nILtAvvZVZTB9dRowhYYfYk5HN55tCyPPXdR0U4wBI54IAi
	YvvGQCdzxI98m8X4ilW+WdLPdkzuTpMCrfPGRJ3MkwnBuVPE6b947eeK/1pf47XdSIV1DkqHxK4
	6gJ15x1nXJRg417mThVBDLCFFQeOzOSMgqK9qKEov
X-Gm-Gg: ASbGncvtHefzVjEB3cNb2egkfukzTMZr6zOi32n44B1fxeQv8AJF/K0pVkP5cbLipxR
	XubvmopPCboYZH9KYPN9UbSnjk/HWHdBCPeRsXWtt3KXyBIWdtIqvQ4AIEgUdQPwK5ptIUqbk8O
	Lsun53i7HI+DvzAXzzYambHIHe+ILp7A125B4ftjkcJ37S2gD11GFC+9pkASVNs1N7chciliifQ
	Fq/eD82IPwGsve1KLVlZ0FxRNW/EA88R7Pp6/9HiEHPheQUczEG0D4kvxSgNc94YCF5TZ4WEWus
	7sa8vOI/uNWk5bN3dctSBTJtAeYlAL0oez4m
X-Google-Smtp-Source: AGHT+IGcEr+u4Lvyu2lcr5/u3UATd1g0adlZD8heHy4ha30xHQDJbp7Oka+Ww5wtit5evGdRnPc0wgduqHEKGAIhdio=
X-Received: by 2002:a05:7022:6190:b0:11a:4c75:a45b with SMTP id
 a92af1059eb24-11de93975a9mr2477c88.10.1764624921927; Mon, 01 Dec 2025
 13:35:21 -0800 (PST)
MIME-Version: 1.0
References: <20251128025315.3520689-1-wangzicheng@honor.com> <20251128025315.3520689-3-wangzicheng@honor.com>
In-Reply-To: <20251128025315.3520689-3-wangzicheng@honor.com>
From: Yuanchu Xie <yuanchu@google.com>
Date: Mon, 1 Dec 2025 15:35:05 -0600
X-Gm-Features: AWmQ_bnUvWHfjLPC5vTcuKxCijZrgA-YfCUFmk-n0mUVC2U4d1FBt5FslZMBSHs
Message-ID: <CAJj2-QFM3iwO==3JKQ4nnHfAxYJuyYXZ6uNJUR8rQdf_Q_1x0A@mail.gmail.com>
Subject: Re: [PATCH 2/3] mm/lru_gen: add configuration option to select
 debugfs/procfs for lru_gen
To: Zicheng Wang <wangzicheng@honor.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@redhat.com, 
	axelrasmussen@google.com, mhocko@kernel.org, zhengqi.arch@bytedance.com, 
	shakeel.butt@linux.dev, lorenzo.stoakes@oracle.com, weixugc@google.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, corbet@lwn.net, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 60C0A20013
X-Stat-Signature: x7sp7ubwzsh8zzjdrmz7cjzore5hefo6
X-Rspam-User: 
X-HE-Tag: 1764624924-442647
X-HE-Meta: U2FsdGVkX18g+TvgN0vmcN4paRIfC+Odp1QimS7gysKKhI/+d8rlrqbpE4edhvj4qWhjXtkVKdrSkmJteuGulSzt+9LmHHvsuHEh/ZHdl5Io4a0NIS7cu31/TOIPSnZTooD8Ufki9OhCVJC/reTF8LIOb0buvDNt0d+aT4SoQPGRnZW3dlUBnGdgJjLEhTrXH9L8YODnBrFKV7HyYDDeyHVmqCHAnQ5paojG+0X9mT5PbP6BB9tcB9J70tMzG8Bgcb+ZrGBQ5r3ZF/O7Cf+PzzgsWkQhak53Sb8UHqKJGqInnKtEtDhe26H8nsOULoSsdohFygL01TrTTtb5mEjwkOOhhQ2/1Z2fwtMz9ciYgoEpUJn7VngorYqMtDk3w2lLG2BI4KLfdJudTowe3hZQyBO9sosDCcBftHBZ/ksJJzQWdVp1SM8k0564aJ9vp26STeuDUoXCrkQ0+95pVi4BNv/8kwedW2AG1VUT4QB9Gbl7ZcintqC0dwirCpg506k69SDd0NjWzAQq9RRdOeq86L68IMEhGeQmnvqrq2NTMVfq6stUhVCStnKAjXjITlZ1T9Icx0SYLyuUyXT6q4Otcvpor7UkxgsINFw78omKDx4laIoOUtY5NUAq9LNMYmfWK97Ck5a6lQYJ3mCfytiIiQ9z46T/wMXBg96Cj0Bvior+IQpOhdoQ+8QYxYpIZMkJ6eViUPqoZcjZtj/mAoykL9ZbgDn9Vryuz542KSLeh4JocEzE+SFuUDLacTp85VFoaAkh7Th6gZ0558ZStNB05N+zS29Ly08Rvdxbe7YglUlx4AS0Ee6ECNnhDJKYVDGs4G7py+eT2Knl2Vwc18g6AWju0UvGIPy6ue2j++ujP5oHgkhSnkWibP8smsLjcvKnj9Tabm3WycCOpBDC5qBdsw/Q2FRNeuuC1vLLUfK5UjmDDSw7bqyjhOuWC1HurhUiTQLNkN/E99LbgU9wqrn
 2IJTpL87
 yK0yV9TST64ZyAtru/SoEGbstAJO9UXSFBZ3KBXkI4NS0LYABLd3ViQykBgEXwz19XCoH8PZb4Zx7jP0I3bBuoWs1TBaMQD6GozUM+7wGk4uOgSpu2eeLkLOg8S2RpRscNKdg129mrt43MCMIUcr4qxL2Wz0oKFtDUhMKKV+Fy8ddypwzXvhg23NbGvgw9sJjtLZEEv2SsB/R52z4katqsFdQVQYXte/sxUzO7LJTwze6ibT+3BPDG4CsoAOrMR2BUNqfCZTI5JcOtvAp/W3LKPKyCJu62VsBWm3nKrcmzTSmO/Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 27, 2025 at 8:54=E2=80=AFPM Zicheng Wang <wangzicheng@honor.com=
> wrote:
>
> Signed-off-by: Zicheng Wang <wangzicheng@honor.com>
> ---
>  mm/Kconfig | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/mm/Kconfig b/mm/Kconfig
> index e443fe8cd..be7efa794 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -1325,6 +1325,16 @@ config LRU_GEN_STATS
>  config LRU_GEN_WALKS_MMU
>         def_bool y
>         depends on LRU_GEN && ARCH_HAS_HW_PTE_YOUNG
> +
> +config LRU_GEN_PROCFS_CTRL
> +       bool "Move lru_gen files from debugfs to procfs"
> +       depends on LRU_GEN && PROC_FS
> +       help
> +         Move lru_gen management from debugfs to procfs (/proc/lru_gen).
> +         This production-ready feature provides critical memory reclaim
> +         prediction and control. It is no longer experimental.
> +         The migration ensures availability in commercial products where
> +         debugfs may be disabled.
Hi Zicheng,

A config option determining where LRU_gen files reside creates a
fragile procfs interface. Consider adding a similar interface with
less implementation detail to /sys/kernel/mm/lru_gen/ if the goal is
to stabilize the debugfs APIs.

If the goal is to proactively age lruvecs that have been at
MIN_NR_GENS for some time/events/etc, is it possible to integrate this
into the kernel and avoid leaking MGLRU implementation details into
userspace?

Thanks,
Yuanchu

