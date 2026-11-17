Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D352606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 16:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VZCSUsmf
Received: by kanga.kvack.org (Postfix)
	id 5F82D6B05B3; Tue, 17 Nov 2026 11:28:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CF546B05BC; Tue, 17 Nov 2026 11:28:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EC8E6B05B3; Tue, 17 Nov 2026 11:28:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2240B6B05B3
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:28:33 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 80943A04E4
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:28:32 +0000 (UTC)
X-FDA: 85445144064.30.9BF3E72
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf28.hostedemail.com (Postfix) with ESMTP id 92786C0005
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:28:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=VZCSUsmf;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794932910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kYRKqypZGpF5DQTuLNtjlb+FmX8c92duuQBB1ElK0Kk=;
	b=4A7wgRsORsYhy0oX+9OrPuJBihFkpZ6z7gaeQcbeRiLQfrCbxJ9LPJtvBbeTr81x+uq4HJ
	U2oB/lNcJcht9TVatMngQ+zd3qsnabNRUjyCnG6RshjgPNNih61QARtBdrjAM5iAZNaAmu
	sCFImZgB3A1hiuvq9TY/p7RvYpLSc50=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794932910;
	b=2HIClvKFOe62PwD0cl+FaBw0KwUjBZV+sckqbS8A/8DRcADHTcATlOm8eZHci5z/fneezJ
	hst9OL0zTF0Icyeyyro0DBYYR7jyUbPMMtxqeEwPh33grPms+OoS9PjFnpPXi4SCj1ZWOr
	FWcCSYWswsY5SmIl5iG78ZxOqI3NA84=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=VZCSUsmf;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c5075fa7ed0so800846866b.2
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:28:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794932909; cv=none;
        d=google.com; s=arc-20260327;
        b=ZOwEnYx28zy5bS3hXBn+dHMuBiPHLX4ifhPB/lmpMrgg9YplCg9upz1odNe8X39Azx
         QoqM2Evdvcq2qL9cfvtB8PzkedzP6DSQjQBa/yIqcM8H5aCtADbQODPaXGwmyLUN+J2L
         a6Le77Prg7owXr+0MJE88XFNq7l2yp/t/viY0fwfIohKj0XQMcNyahgjij7K85gtwn2o
         ojPeeiFACKlXhHZ2syQaToaLSeqxkFO6JdEsyiUJOc4exuCkUIs5ZVCPmjeQoDKP6fMv
         1qlduCJMsQPlxZdgiV28cnnDclzLZhJAsYsfrySIHRm3Hzf9SPuW+qw+dbIJwwK/t5kT
         OBpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=kYRKqypZGpF5DQTuLNtjlb+FmX8c92duuQBB1ElK0Kk=;
        fh=qMlzMQb1m96XNLboDMqSjt9xXqfypRui0mr8ao+v1VI=;
        b=YpNZEjiqKENO1DsN7IPf8spTTejekoxrEII2t17446ygdEX5qgf1rZzOZNHhAiqs/z
         ybBdbwFM3YfFG3/7EgdlxeBD5wK/jNx0NYeIOXO5Y2o/WiEukwwlspLO9olteJzt79I2
         oeqlkG6CR0IZxfiyBqbg4TXSctx87LmaWBhZSbilpSJH7atlv8mZ0HLPCncg87UdOKyV
         6oYjnOdAGAR8x/eU3Yl5ohSdocC/fhR6wC09PIfVFTmUdntKk4S7VmSgpTa0GZIzlsyO
         BMKenRL0CunJqHNq3vuh8bLAfnVjH8clK0qEGMNv5/nL9xj4KzXoctxtJAIV9s+vaC+1
         WxVA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794932909; x=1795537709; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kYRKqypZGpF5DQTuLNtjlb+FmX8c92duuQBB1ElK0Kk=;
        b=VZCSUsmf8NRuNrZime/wsQY4KoRqPbTqKq1RzLsGgx3qxpWd9N4/mtV0aVdjiO4aZ4
         4nJZzrnB4f86ldxybdRMElA+8N9DpCv4zk3iQZRoZqveR4rXblNy20fvxP4vPvKywSlQ
         sHAYcqzlGN+bM6xpMAz24eEVCKwY/S7xrARJjUjUguNsQEFY5GM/AauFaLuTV7vObyq4
         tclIjY+QJXIoJPqdxL8OQmLaFeJjAsr8+oON+ke/bdHXyNmXYrTvdK86uxeGDa2oa4+y
         Hp6r47RkBaGMaP0c4WNotBIf394QxI6+Z3NyneRjnx2D5koyT6T3QjP4TreXX5ewgPG0
         FE2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794932909; x=1795537709;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=kYRKqypZGpF5DQTuLNtjlb+FmX8c92duuQBB1ElK0Kk=;
        b=lgBjSt8PvVV7q0N7M8xiUQbJnWO+CYLLSUEVVKyXX58xTSU1mxYYQa3nZKnufr210d
         wlg/csb6HEpXR0PEA8KqLqN74QHjx5flzlSjaOs8l+89+AkIp/uIKkgNZznM7RtqAUD3
         KZfBxCGZWlceqsz+ntjbKtLqWcW1LlXp6h4/thUCrlr0c3HQe0EQ55mtR9l/YbfHG734
         e77YwgJp7tW6XYOUMsa9ZAVm+yAflZ4BdGPkkaFECZDfTPeTpsEEfuozNzODGjYSDfkN
         1hyEH8rXu8voN7Cx0ilIOau0/yhC5MCSRsJOkThj5E06rDOP5fltLrHDnJIakFP7Fo/Q
         SxfQ==
X-Gm-Message-State: APuU4Z9unYgcMKyk7vEdtEnUTV/fDo95QI6Cp/9bJZAMR1YOdz48XXu6
	Ukr5C3IkQX6lUHN95t4Vz2XVD7uuR8920G+rsaopd4iObz0FULQEI+erUVwtWt6UHun60eidNcH
	uZlLQVOuRu65lTvYSaPo69qDPQbIzRHU=
X-Gm-Gg: AYBFou3WN9VTDkbrcMGgOKciAnVeTefCH7FkKr+vaoQ+B0w75eTLMcAwRHewpkW9kvC
	CJQsa1lB6WBb+bdQZEPNjaf+DDQrFy0e0DyJ0d3YkhSvpDeiE7csu8BrrDOYWJueLgUFstJ81tW
	+pCHfHi0HoVt8BZeYV0DK/wCqHtGLiEOH2lqwlHYfHSEr2gWMGoeqr595hCCvKZgjzDdjsdu0hr
	EgW8+yHZ4aIMedcRORssWgpXHJR6yYCN7d1gQ4dd4Im71eWNVKMgMa6WHx009fkhIHTL13RWiVI
	6JuYlVJwJKDhSe4oh1DjTXR8O/LIAY6i8LLjpmKHC2r2W1IidcPxM6+tEnM0q8eyrBjm4eXPpvx
	QC6QItxrd4gAAwBqZyL0sZTV2nOy0/4kd2tn36oWWZOW7lm4WeptGrC6UiZhOwBxRCv1Z0g==
X-Received: by 2002:a17:907:3d05:b0:c41:8e21:4d5a with SMTP id
 a640c23a62f3a-c5096110e80mr1270381766b.5.1794932908726; Tue, 17 Nov 2026
 08:28:28 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261116110122.309748-1-nakixii@gmail.com>
In-Reply-To: <20261116110122.309748-1-nakixii@gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 18 Nov 2026 00:27:51 +0800
X-Gm-Features: AclHuK8jFoB078UJjX-4oMtgMSTNWJhLa3LQu5nrN5DX53PjZ0PRScBUeflPjVU
Message-ID: <CAMgjq7B=F7grQqhUP1wGPG5uYHL44QNS023Lg4Zw0ycQEr_C0A@mail.gmail.com>
Subject: Re: [RFC PATCH 00/16] mm: add in-memory compression of reclaimed pages
To: nakixii <nakixii@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosry@kernel.org>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Barry Song <baohua@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 92786C0005
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: ybus9ou1y3j75ffcgxw6hjkxnwdhkptx
X-Rspam-User: 
X-HE-Tag: 1794932910-320577
X-HE-Meta: U2FsdGVkX1+QgBzu6we6iXiR10f9qPsWL0vWaI1HwCbcjjjYEn5+UQgNcV1A5tEWcv4njh8TbNew/cPbc9kSx3pIDJ/X4Outl8xMaze9ymKpnRNFolfOtljDIxEnpuUxHw33XnoOIQX+tLFJUtUFnKxscKZBxPJJUma9gDqEsy7IBAs/F7p3g1cXEPRhkS7F5dxMn7zq/GP5BpRpgU9qevlw+WtnZjHHDAGyEAckDtZJUG8v3mte71cxyyUDd+tRuC5kMP5bNR5tmGWxidSWyY8wrVKH2aAcRjGSgXa+jU1aZ8ZLBjnNiEkcAdMAId63aU8Ikz4/W4GrkCt3gKaNkIgiC2GmG4IoiXeW/E7wvX6e+Et7NMvU0pUFvxmNgXMxacDUQodqnjXW+FQ24vCHHywmhYMm2CgXtKFyBfv0vLeufrYZhq/iEdrvk4Occ8eP2B/OdeNwH2Xpaj2u+LYr3nFVjPChKKyvXBSPo4ED25tsqAWB+O5/+hNij+m8t3biITprt45OOevAwe+ji6bM/vI9wr62PDkul3ThU/anwPZw4h7hVi9rgkcg/FHTyFhMg1unhHEIHYWy09GH3mHIFlsbGJA4pWkNaF6AT++SoGUJaPT/ssREPffQ8luPLemWl9DkkpvZYtduXZmQxWBHA8owBzhOlyhfUpc7h9IEp82CGCrDoOVom10jim20uCRVNZixgTebtZnJ9kl4WmMvuNbp/MY5fSglQe7VAwBW9fVHvzc2AlGcu5TAwH5uW4I8spvsHXJ2+KMHkOnMYsQiCtMCJP97IHh+dKxpP22owJ7+bonxfRjHE5MmGhkQt8mmtmAIgQ0EgKujnX6fXGBPg+7NvTq2QmsH53XavPdnUx3L2W/goRhnsqMy6vf920HHGvjQHodeTq42gvFKbo8G8siQX2C2VMBdMO+yLVmQch33F/M9qI3ya2dzCgNNDZnaH5fM2VfGxPBa2xXAC9l
 grBuvn93
 EzaRbXmbsjfTXuillnCjI4fS6MK8axa/DBY1PyKVwX2GOEt2vtcBMviIRfpSIB1Z9TK+VBEbyzsYxZkUe64pgwaWBdlRcyO/7TwfB38Vd+0EySVH5Kw0JtTeW7EIl/tPKe9H6NsiHQs9d0Xi8NZuX+darDYlNWW/E2bW/fnLonjkzgjKtZeXnhUjcEmHw9zYASRsBcVzDrOUm5gqIhZ+Nj2z71cANPDzoVz9XJgfCWTCE9b+VribLZZX4YjGTF6Fzz2RllJXWKN5JX4V05pmFm1GogwGE4fkTdbaZB32bnmgKGqg2sunMFvLuPk28RtfLh8UZhH12k95AkUJen0mZkjekhqB0jMWTCh9KLQYB4Y42T0ER7S7mB9qKoG5bb/QqPw/3yQUSzo0P6QggXK1HRNfG7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi nakixii,

Thanks for sharing this, I do like new ideas on memory compression /
eviction :-D. However, this approach is wrong in many ways.

Posting a mega-sized chunk of LLM generated unreviewable code is not
helpful for anyone. And it's based on a rather old kernel, considering the
parts you are trying to work on have changed significantly since then.
It also lacks a convincing realistic workload, e.g. almost nothing is
measured under sustained memory pressure.

I think you can start by describing the problem and goal clearly instead.

> This is a proof of concept, posted to ask whether the approach is worth
> pursuing. It is not meant for merging. The series is based on Linux
> 6.12.23, not on mm-unstable, and has not been ported to the swap-table
> and zpool changes that have landed since. If there is interest, the
> next version will be rebased onto mm-unstable.

But anyway I took a look at the series (also with help of LLM :P),
IIUC, the main goal is to cut down the intermediate layers for better
swap performance.

Then basing on 6.12 is a bad start, those updates you ignored already
achieved that, or are focusing on and getting close: Zpool layer is
removed; Swap table & cluster allocator removed the Xarray layer and
multiple synchronization layers and reduced contention and overhead;
we are also flattening the zsmalloc handlers, and many more are being
done step by step. You can check recent git log and upstream mails for
the updates on these parts.

So in mainline, the win you measured is no longer there.

I asked an AI agent to try this out yesterday and it reported this today
(256M anon, all paged out, 20k random single page faults, page-cluster=0,
best of 3, canary filtered, same compressor on both sides):

                        pageout us/page   p50        p99
  6.12.23 memcomp lz4         1.11        0.96 us     1.63 us
  6.12.23 zram lz4            1.31        1.13 us     7.75 us
  7.4-rc1  zram lz4           1.13        1.04 us     2.42 us

  6.12.23 memcomp zstd        4.15        2.42 us     3.21 us
  7.4-rc1  zram zstd          4.92        2.63 us     4.08 us
  7.4-rc1  zswap zstd         4.89        2.58 us     4.04 us

Against a 6.12 baseline your point reproduces (7.75 -> 1.63 us). But for
mainline the p50 / avg are close to identical, and the p99 is only 26-33%
better instead of the 2x you measured; considering the ongoing
optimizations I'm pretty sure mainline will bypass that without bloating
up the LOC, or while reducing it.

And I think there is a major misunderstanding here: you didn't bypass
swap, you just re-invented it. And there is no "direct memorey
compression", everything goes through a page fault, unless you have
some fancy hardware support like CRAM.

So TLDR: the 46K LOC for an ambiguous performance gain is really not a
good idea, it is basically a poorman's reimplementation of swap with many
essential parts stripped to be fast (broken OOM handling, no cgroup
control, many statistics and counters missing), and still not really
fast. So don't reinvent wheels.

One thing to keep though: patch 1 (UFFDIO_MOVE exclusivity) seem
valid? And it has a Fixes tag, so please double check and send
it on its own and maybe we can review it :-)

Anyway, still thanks for sharing this - a good reminder that everyone is
chasing every nanosecond of swap performance :).

Thanks.

