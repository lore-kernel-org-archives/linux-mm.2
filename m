Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA8AEC5B56A
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 16:49:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8C436B007B; Mon, 10 Aug 2026 12:49:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3CBD6B008A; Mon, 10 Aug 2026 12:49:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92B186B008C; Mon, 10 Aug 2026 12:49:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5ACE36B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:49:49 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E3454C0182
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 16:49:48 +0000 (UTC)
X-FDA: 85085946456.30.AB4C169
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf24.hostedemail.com (Postfix) with ESMTP id 04C5B18000D
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 16:49:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NcHmKEdG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786380587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=opQteIDfNDFGbe327v0N4D1kt+GGRQG5/oQ05zdVIEY=;
	b=0X2jRnlfJhbE+zld/dXkgCrg+3JcDD4R1wR1aZioDQ1iMaNV0GQ61OcIUqDsQD5zIhbpSq
	IyPd6qSOalg5FN6/y1Iin6YCcsSo8e7jc5fWHRZFnGVQg53/W6q73hQeYwjcFsxbbuOATa
	BPIBylIUw9VQQSRRVPf1lhBaMzTH3jI=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NcHmKEdG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786380587;
	b=R/MivPheQ7fCUhJA0u8BSpMm1DPpxg15qejriNa2++0H9DHQzdwTY0CXiBUH+zdLVDDAzr
	v9X/hX0D+/LxxRkhcM428eDZWzUi9+8Jmb07A44Iy6KkcIRQz6/HBr36xOk5Snj7IlWlDi
	yRKWN+7VcqksuDl+wb/nr1nSoJT93a8=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4953de5be0aso15633055e9.0
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 09:49:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786380585; cv=none;
        d=google.com; s=arc-20260327;
        b=OFlZGwNrBKJoRbfy1CQQblmFiWli08c1ogaVkU8R/HtMRiFHIKlGfislhsCvoGY/jY
         XeK5O8D5AgC9bWg0efvmZh0ZIkA1pynS/+PN9B1aZP9vIhYfrzkByUSWEEYMZjvv2fnE
         dzZnES/+7T7uEIjS7QY6t8KPPInJesyUt9qzOIvUOigWh3XYY3noQN+z7iggLYDio1hQ
         jDrq2MVO09IYgukVumOVYNQILckuaZb6xgYvCm0je+yFFFKhca5ZN0bEQKRpQ9tudpTN
         RsOpyrdAURvWnm4vscGGdIgBRRX/+vVcJFhxEbEiD+gWhT7MYo7Kc8qD1iczTL/PrvGi
         w3tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=opQteIDfNDFGbe327v0N4D1kt+GGRQG5/oQ05zdVIEY=;
        fh=5+uMoKot+7J/2FiILdGRO0xHb55nBSXbVgRElI/5jEI=;
        b=ZUWwzytq/wvymogejNsRiOtZ5/JG8CV0FCYhaaCx7bCZOmBE9V9/wEwcSqdBtlqwlY
         axPTsIeEtTvZF/gTg2qksb5PDkhRjsPlFF+rlg2U3xLClJ+ps49aGDkUXHUkYRqEzClW
         lj8VgepsUzDkhR1zHZOTVoH09hbnoNCytL7K4YanPXIxklOdBgaa2i5eQuoNkwOl64/C
         +mCamDKP8fksLCxgc7w1kzUpki48gp7LW3psfsF5ORVlhl9RAvyq7UV2704pZmLroOgP
         wBUC59OuLCPtDWWj9rLpJUL43ID9dQzwgk8tvaqQy5og2/Y0/sBufsO1mfHhL/PzQ/7A
         U4FA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786380585; x=1786985385; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=opQteIDfNDFGbe327v0N4D1kt+GGRQG5/oQ05zdVIEY=;
        b=NcHmKEdGQoCCXUesTmOKkH2XIcfgGDI0eDTaDMh5zX6RuInlK1QsNqR2aahOu8TuzV
         Y8BQqOPjzgEO2D0HduujLiNVmSP0bJOwoLt+jYtjSI94U45oq6cDvBWHTpzn49Brupeo
         hetM9R+BPutw6ygH0OsItMPAZtZ+7jWyNQQw37tWDuSahRujPS9KW02TUjgmkZGfUZXn
         xBMld+fSBy3aKZMAFVN0lHscOE5Am5+565RJAVau2kD9waFnutxpZ4/79bj3fgJA+8WY
         i1wa+E4YYqPZ1TveuuEy/SbJ1B2To6LsDGwTR+FDNz3zElm30766q6RJ0Vl9slyUewod
         6JvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786380585; x=1786985385;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=opQteIDfNDFGbe327v0N4D1kt+GGRQG5/oQ05zdVIEY=;
        b=sjkdJQRkjz/dhyynX/Z9uudDSkE6jJJVFOWmFupv0rF1JNp+zyiPp7EEATvZuOBIkw
         o9iLlnux8dUQBn1c57n/UF7pog/bcfY1u5hZ4eqoBUeXS71PC/tQ12z1JVMbowD7Ku/E
         cRxlP6HICvpGLMIFrVwjI06UsfKyC0ct2vH75CjUxA2o5zxq1ciMlWSAMpdMc7kAkKbb
         egbXh/5hQbCUh7U62c0daLUD5u1EiNxJPA+64/x29764O6AHwr7Qdq5am3t4vmX/QCUy
         W3BHvCwAnPmGLnCUN2T5UC2eUJpYU18ylViAhH3WZ4el8W22kUPfya4VIL7B+0nJ6JBZ
         mIRg==
X-Forwarded-Encrypted: i=1; AHgh+RqVl+k01hOHxqvc5dk5ftIAyxl16BHq+V/S+rcMSibQlVM++MBX1trtq5HLEkTzXFcm0FZFArXdpA==@kvack.org
X-Gm-Message-State: AOJu0YzSw6hkpZWMD0q1JrTKTHI4yqArAL2NaWhtnKD650M0C0R/jVTG
	XANLNyI0d2YiD5RBYH7e6Ovr1H0PRPAbDVJ3a5rZ1lR11Ba/uoqwWgEX3OkHGWQMCZk8JmuqKEN
	lWRBv7UwKrXLbOfOIQssEVpCrIgN3/G0=
X-Gm-Gg: AR+sD11m40QpsiJoxaLwxhu6Zqpaj6laKkXesdbaLnSAok6ASvZS7nNBerwY1hsyKST
	p6VtFnZbqc7dzIZo5l5gGQvvmfaYRQkJAV6iIcjzUvoo8vrMveC5k/wxTgNOi+Rl0zvu6udBcVU
	vDh3fu1u6thYhOM126QtYsno/f2hDOBkEfnfAgP5q3No6OUiXXpfF0I+lrk5g8SckBOkZGSXfXF
	wukv4+JJeEG5/0pZsmMkoQAGQQQaC8dr1j4YjxoyH4RnV89avpxa5CapERCKDVX96zE2u94AgKd
	3JzE9oVKwMv2xnDadp7Zhjli59dbKeHPGq9qJVxxRxeaAWfBRYNVljsfVhs0hG7aLOb6SKZvhsK
	UB0Tp00Mo5v4QS4DvRYB43u2b
X-Received: by 2002:a05:600c:8b4b:b0:495:5fdf:2075 with SMTP id
 5b1f17b1804b1-4995e0254cemr315174035e9.0.1786380585382; Mon, 10 Aug 2026
 09:49:45 -0700 (PDT)
MIME-Version: 1.0
References: <CAJnrk1bk66ZhRAS7mojSnD5RBfFS+0ChAPymE3ObRWr0C_udWg@mail.gmail.com>
 <CAO9r8zPpe6fWOSXtRUjFB8WNMroeBqvLT+2QtAU4E27AtLUXMQ@mail.gmail.com>
In-Reply-To: <CAO9r8zPpe6fWOSXtRUjFB8WNMroeBqvLT+2QtAU4E27AtLUXMQ@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 10 Aug 2026 09:49:31 -0700
X-Gm-Features: AUfX_mxLee7dpyylWKON8KDAzBJgmBm61mwBeQMBp_ggGZ_j5xRcyxsvPI5PLAk
Message-ID: <CAJnrk1YifN22mA5PFRVrh3m_ygxax6x4_8nraG2hPqCzyzBj7A@mail.gmail.com>
Subject: Re: memcg stats flushing (WAS "Re: [PATCH] fuse: disable default bdi strictlimiting")
To: Yosry Ahmed <yosry@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, 
	Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, kernel-team@meta.com, 
	fuse-devel <fuse-devel@lists.linux.dev>, Jingbo Xu <jefflexu@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	linux-mm <linux-mm@kvack.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Yunzhao Li <yunzhao@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: madc1bhip8p6mawa54hjwgjar49d9atn
X-Rspamd-Queue-Id: 04C5B18000D
X-HE-Tag: 1786380586-970460
X-HE-Meta: U2FsdGVkX1/FO56UOlVMZWIUKcne/j7Jn1EMbMO7VgcznnhANrWHHMOVgi8VKCWlL21YFIrWZtpTridV1/QF9w1IWLtaSPVPb5DmHU4eio0juVgWY+3dAsD61bePJN2hs9tpdpOkuUO9hJNs20WfuTC10ebk2tcU7pKb/KGJYBPlXJjf4oZqhjY6asY9vLJoTVnAecNWXC+3np11tQjoVL1smorkNgW2Bt5Rpijry1CnyezlNSI2eCurqNWm0mTXLCJoK2SHRMEA0fT13jHu8BHZntJGsa0c5ikhK32tMIBt75swZtqz9jzxQeQGVbN7VQIovxFBUf2GXscKwtQKtMB4khiw+Qen4Mn5H96qspDEZeJ2dN81l50//vnJ43rFUvK3PiPZJg0QV1koibEgnNjbypOiuRvoh0CWFRFMPd4i2ZXCyLwbFDmsQqxrp9rbHTSlGwBH1cc27qKkdtzJzxGQhaLphT4dVYC1BK3WQtkGL8YjLbO6hlFlqDEHinFEyB7rzIoOAWAD1ypAujzp4SEB+D2CSSVcgMFiU+g+jBW4654W8UKM9I6Ttvvi8VBy6GGnnNhSZvn3pJ4iR77339QDAfFe5tm8rzX3AxL9oQdL9uvty+xtugValhkGOkJ0UOZiBA47Ysu0Of5GHbWc5oXvAgKKOCHs+TPlAKjNhQa1HbdQhunIH7MZo27IRv56mJfcL64onVgiEprzML9pA+zFmwAyCP5kqt6gtEb4L2IQi0ptvuknxoyKzdzvmSpkM5y5mhwDyBNh5ACxGkDlnS9I6xreAmvoEI6zjj6xRBz8yXgeBTmKrLwzogDWWfmjalkqwvkVUX9Yzwqqx260N1pcFM1ItH4IlHjKsynz0naGM1UuhHj+FNAZG/mgl8FbfE1qsPnASJ+wGZee7XQMQczmfnjTbjoIwGBLbrRUWs/7Aa1VWfNJbr4uGrYplmFw2BTBMfOsq03J0PFcH3U
 DSmE6wIh
 vALU8pPfEa5vXHQsMXn3wHZEnF8/PJa/i7xYxR0LnEZsq2wP7UkNvIuhlby3r3v3ctQ/e5/qjkpjGsC7oLyKY6fLr7NOsoLCndNrQLY42PQ5Adw/OXeWGLPovRoRr3g5gRX4rZOZV07dvla80G2iwiRP7TlThQQYx7b54G3E4A9/htdTMF3/TQE5vEbXNXxdg8NIAKD/5KM3CysMNraaaFrLfx53Lv6SJ5Ar7FCLdX03nTX/eu91M8dUC5dMYV8MwM5cNKhdqTfTLcb1Bc41LBeELjP6ismzHBbHX08J1M8HwnlQMVw7RHe+1hTO06+wmxCdLmnERR8rCXTzc+q4sSIHGXuYxWepXK9GcLWJQ5bwM3nOlHBGzLqTwyBBqX48FA4Y9I9PHjr9UbbC1SmkdKr94aKErmkmfMswkocWkmTc6jCD9qsdp//TccbkFN2fUgZ9TApwl5F/w6mI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 6, 2026 at 2:31=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrote=
:
>
> On Thu, Aug 6, 2026 at 2:04=E2=80=AFPM Joanne Koong <joannelkoong@gmail.c=
om> wrote:
> >
> > I'm not too familiar with memcg or vmstat so apologies if this is a
> > naive question, but does it make sense for memcg to just do a similar
> > approach to what vmstat does? As I understand it, mod_lruvec_state()
> > updates the node counter and the memcg counter (if memcg applies),
> > where for updating the node counter, mod_node_state() does some
> > batching where it updates the global counter for that stat only once
> > it crosses some threshold (pcp->stat_threshold). Could memcg keep its
> > per-CPU counter as the accumulator but once it reaches some threshold,
> > it then propagates it up the parent/ancestors into a per-memcg atomic
> > global counter? The atomic would then only have to be touched once per
> > batch than on every update, which might eliminate the overhead of the
> > per-memcg atomic you saw previously? It seems like this would get rid
> > of needing to do any flushing altogether, as we could just read that
> > global counter directly.
>
> The memcg stats perform similar per-CPU counting and thresholding. The
> main difference from vmstat AFAICT is the cgroup hierarchy. In vmstat
> we have per-CPU counters and a global atomic counter for each stat.
> For memcg, we have the same for each cgroup, then we also have a
> cgroup tree. When we read the stats of a cgroup, we usually want the
> hierarchical stats including all of its children, so we can't just
> read the global counter.
>
> We use rstat, a cgroup framework that keeps track of which cgroups
> have updates on which CPUs, and then memcg has thresholding logic on
> top to only flush if the number of pending updates exceeds a
> threshold. Essentially, if the magnitude updates on a CPU exceeds
> MEMCG_CHARGE_BATCH, we add it to a global per-memcg counter. We only
> flush if that global per-memcg counter has > NR_CPUS *
> MEMCG_CHARGE_BATCH updates. So in theory I think we tolerate up to 2 *
> NR_CPUS * MEMCG_CHARGE_BATCH of stale stats (combined for all the
> stats).
>
> See memcg_rstat_updated() and memcg_vmstats_needs_flush() for this logic.
>
> Looking at this code again, it made me realize that we already iterate
> the per-CPU stats_updates on every update to increment the number of
> pending stats on this CPU. I wonder if we can replace this with
> actually updating the stat on each parent, then the flush path only
> needs to accumulate CPU counters. Or maybe as you mention, we update
> the global per-memcg counter when updates on a CPU exceed a threshold,
> and forgo the rstat flushing logic completely.
>

I can run some experiments and see if updating the global per-memcg
counter per batch and forgoing flushing could be a viable solution. I
can use my setup to test it for writeback, but for the zswap use case,
what's the best way to test if the changes are too expensive? Is there
a benchmark program you're running?

For updating the stat on each parent and having the flush path only
accumulate CPU counters, I think this means we would have to
unconditionally walk the ancestors + update its counters on every
update, as we wouldn't be able to early break if the flushable
threshold was already exceeded. I don't think we could replace the
stats_update update, as it seems like readers still need some way of
knowing when to flush. It seems like this could be a nontrivial
performance hit, but maybe it's a non-factor in reality. If you think
this would be useful to get benchmark numbers on, I can run some
experiments on this too.

Thanks,
Joanne

