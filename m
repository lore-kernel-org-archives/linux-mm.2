Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94EC9C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 12:54:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C8C16B00A1; Mon,  6 Jul 2026 08:54:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8790D6B00A2; Mon,  6 Jul 2026 08:54:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 744616B00A3; Mon,  6 Jul 2026 08:54:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 463E66B00A1
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:54:45 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BAFA914032B
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 12:54:44 +0000 (UTC)
X-FDA: 84958346088.23.E32615E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id BDF2C4000B
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 12:54:42 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OVFHaulk;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783342482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O5CbBkIap44vv0dv2vbH0BDrSWl7QQVeNrKgD7wP9bs=;
	b=aMpt2x/8spPvuj3e0NKH+dVwwEmgxxvZ0qEgK7mLqjIiJzpTlXXGK9fX9wP2ID5RSJrZSK
	Flqy7O7CoQ6vYK357Ad0Gv3BRAELS2PsALts3jmWXVgVZUGhuyVEHF9vYpX1/VLSIbFQKx
	lDS6yLdSDIwLVv8jJxazvPCozevAUm4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OVFHaulk;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783342482;
	b=A4nE39e8QuPrqgn4ZLWWE1lHAZU2dHGZKmetgN2FxQAjRSWgxVPPsAE5LmG8EvwlH2r4hf
	6azYxKbpB9EUiKEhUnDfkS3/Ur0WqBeH440Njs7P1WOk0XgGSfIkpls+fmE4UdOdtCMz4m
	Ft7bnVoDGf3VdXouwGkm0O3GGO2KAoo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ACF31439AC
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 12:54:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9303D1F0155B
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 12:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783342481;
	bh=O5CbBkIap44vv0dv2vbH0BDrSWl7QQVeNrKgD7wP9bs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=OVFHaulk0NPLBDGMxFVx22h4uhWSI0rSIgJg1MnyJM+e3Fyu94V3W+t6I790kmhGj
	 x05bg1+xSP1gZkpy+epm9XPHf0jWCElNi0gZPPclgFLNlpT6z3aq+nhSx9vIvDRmJ7
	 VVhdkEzza4n6ZY6qzSVEbJZ2JP1ojVn8bLRg0vjqNbPTDrjZG9qSswWxIvDuwUIboi
	 02/vNMcrOoCgINQBo+zoyk2eZ4p/To3ZoVhag+kCTAfNV77UZ0gOI4wZJob2l1jH8w
	 POme44tV3Jq7Ls9qX0SwQf5UVOkgBSaONLxbMioExxnzjqR49sPaxn53f0CUTybYld
	 fIFCcaTLTHtgg==
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-92e533aacf2so133945185a.2
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 05:54:41 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoD0q/3Bl9VnTT4YDxckaeQkRJSSOmhemv+h554FqGWM6ja5PnwZU2TzFGGYdMDiDvftMSiYbzg9g==@kvack.org
X-Gm-Message-State: AOJu0Yy9pgjJcyG3lXQkb4XJtdiuaxyc63zXBA93h6/As+mn9lKZ5VRT
	RrgvHxpFXd8ry7ZrT/1bGQhSZLqex0Sn6S73eVkoBtvYdTAklst6ruvF5pDexc3Sv0JUFBB6z0Y
	C29XmsxlqzXb99Z7FjEYphxm5XCXVS+A=
X-Received: by 2002:a05:620a:4515:b0:92b:67e6:8ac4 with SMTP id
 af79cd13be357-92ebb70e907mr53609885a.62.1783342480844; Mon, 06 Jul 2026
 05:54:40 -0700 (PDT)
MIME-Version: 1.0
References: <20260706081218.3438762-1-richardycc@google.com>
In-Reply-To: <20260706081218.3438762-1-richardycc@google.com>
From: Barry Song <baohua@kernel.org>
Date: Mon, 6 Jul 2026 20:54:28 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4z+NfRbT0KYJA8Oe0QZ5nKUDLQFwE01Gy6khj6kq09JZA@mail.gmail.com>
X-Gm-Features: AVVi8CdfHG0hck1UfRCYx5WHJjadHhzP9BH2o_DZBEbKZBrJKijblbNecG1ajMc
Message-ID: <CAGsJ_4z+NfRbT0KYJA8Oe0QZ5nKUDLQFwE01Gy6khj6kq09JZA@mail.gmail.com>
Subject: Re: [PATCH] mm: vmscan: abort proactive reclaim early when freezing
To: Richard Chang <richardycc@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, "T . J . Mercier" <tjmercier@google.com>, 
	Martin Liu <liumartin@google.com>, Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BDF2C4000B
X-Stat-Signature: ph6fx6dbqe88yj55o9o1rytmzha7t3dn
X-HE-Tag: 1783342482-405596
X-HE-Meta: U2FsdGVkX18YKMOH+zTUFnvSg2EePK12dWE1nAlc0/4RuMEJYCe3GhZguEQ69zkF2qwFo/aRv0XTD5eYPXCsybK4x0M5kpyUMg9vKGLUegqTssZbwMSOWxJJv4Xx6YYM3YPlXb6Tg8FyfQjryh03khBXuttz5M5rIVTybM6+fovMxqfBr17Bii4KFaPweTSFwBDuoKv0CbsHrWLK/SgXjvyIaGtH5p0eEMEd9Uezudau+uPFbpa9h5jV62t5MEHYYEKuNDUH9cZ6s2brLWysmY7fYRSKefCqssvJcYahUYNJCiD5PVM6nlHiXqa7wsiiJGqAjjlN5bvO209wlllqTAiJRrjMkSF7gBR0fsOobEdLjCpa4T322x6ZFwEaxW7Hd+KFQZ+uUb/8jasvfLM6UY57ZsD/f9Oo6UmNVF52ypyZ+wimYyEFDZC9PtJCW6/ekhhR8ftOcL40dNA8n5NQ8Ld6sEH/wQ7M8rOeLp7n6TKp3B8WNmIWN7mjsKMS97wnx92ntID78LERokVfwRiOoRoIS+ZR2vgI8dophydSSViMG27aBpIWSj7lqsNBepT1FYd0QvESK21TObD63XOGE85EYRCApkXnt0FC+UiXPZz3rSjRYFKJ5kFr4rStmOH2WDLS3ugcwTYfKxq7IUkpnvIe+QREeUryg0HxLBjRJXJ8K9y38/usdYqKgTgaPzXRZklRWc+cKDMgqj1KjewSDnRGf3p24kT8jdZ/vuxbJByE7Mbj0rWa2LKctVYsCWJ1f8GGoorgyecLNQDFF/YrFojlIVkh28YZxKSLsH8rdCcrfYn8yG4k2356shyT0XNleTXiHmK6P/OSQqu5tYWJsPViu4kpRSJ7QE8n34DnsJdwIwcwurPpmIBjwh4ehy144HQT85sbTr2fwEIq8tWmYJjwuAnbeb94zdKD8XgU0n5ENV8l2ZH/29mbIt6sfueuMjS7XTv9PsmrpZy1LOM
 XBvXX5Ge
 0QeVxgQxYk++Kgfza/dVMWsl7Vt/4TCouLcDKcPahHut/C2MhTv7A7VzMS/D86JitiUok9Axy665KgOTcbCtM8I5BpojT0aoY2wFbqUvsGqY3Iql/FXfJm8c8avJnYcqAt7TChAH+vk6J8j1blOB6dDq3xNUJmSgdA8GrgZQGEiqbeKOS/sT/HdRLM/jy76xPNmJ35C7TU3RXrYaFggRTlabSBuuAOS/mWvtVhzn4wrksmqd+XI2Y7LFbM9+O2XkOxLvmJXinVMnPX31t6G1syLh6BPtUELyUOVJsOAFSniGiwMr8RVqph+WPgQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 6, 2026 at 4:12=E2=80=AFPM Richard Chang <richardycc@google.com=
> wrote:
>
> Proactive reclaim (via memory.reclaim or node reclaim) checks for pending
> signals in its outer loop in user_proactive_reclaim(). However, the inner
> reclaim loops=E2=80=94scanning cgroups in shrink_many() and evicting foli=
os in
> try_to_shrink_lruvec() can run for a long time before returning to the
> outer loop, especially on systems with many cgroups or large memory sizes=
.
>
> This latency in responding to signals can block the freezer (both cgroup
> freezer and system suspend), leading to freezer timeouts. This issue was
> specifically observed on Android when attempting to freeze background
> cgroups while proactive reclaim was active.
>
> Add a signal_pending() check to should_abort_scan() for proactive reclaim
> paths. Since should_abort_scan() is called within the inner scanning and
> eviction loops, this allows proactive reclaim to abort early and return t=
o
> the outer loop, ensuring the task can enter the refrigerator in a timely
> manner.
>
> This check is limited to proactive reclaim (sc->proactive) to avoid
> affecting reactive reclaim paths, and wrapped in unlikely() as it is a
> slow path.
>
> Signed-off-by: Richard Chang <richardycc@google.com>
> ---
>  mm/vmscan.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 35c3bb15ae96..fb472e924fc7 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4929,6 +4929,9 @@ static bool should_abort_scan(struct lruvec *lruvec=
, struct scan_control *sc)
>         int i;
>         enum zone_watermarks mark;
>
> +       if (unlikely(sc->proactive && signal_pending(current)))
> +               return true;
> +

Seems reasonable to me. I wonder if you have a script to
reproduce the issue. I'd like to test it.

Best Regards
Barry

