Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2496FC982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 20:19:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 197866B008A; Mon, 21 Sep 2026 16:19:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1484B6B008C; Mon, 21 Sep 2026 16:19:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 086B26B0092; Mon, 21 Sep 2026 16:19:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E01576B008A
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:19:42 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5CC74A40B3
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 20:19:42 +0000 (UTC)
X-FDA: 85238885004.16.7579214
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id C5D6C14000E
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 20:19:40 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VwOwRcBI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VwOwRcBI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790021980;
	b=Od3sFTqtf/e+RIwKsmex4Q71mClfT204powBSTP3/yJrkW3+hswP0+tlMl9YxICtNMAd5N
	sh11o7SSUvCQsN0T7rSjQMdmB2B0VACUvfJVgGh4+IurFR3H4hF+kZjkbgFExo7yctB56N
	/ZvXJ+E9xnR0l0Rqog+71fHsGNAYolw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790021980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oKuyFvdDafEvPgKBAQD55KsBuofHiKxwkbpxZQsO20o=;
	b=VLerCtATW1quiyNXi0p81oDRQVBlK3wBC9f8XwL7qaXS6IKPHqDXPKIlDsvd2ToCwuBw1H
	QiLkp2DV/hBTWd5jDTZy3Pw4TqEny5VIcRjZiheFd+071NJgtYHhU2pvbDPBAph3hk3ZZ0
	MmeQbBZup1iY3xFL4/3HXeB9tXIwOd4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4F025601F0;
	Mon, 21 Sep 2026 20:19:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 898F01F000FF;
	Mon, 21 Sep 2026 20:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790021980;
	bh=oKuyFvdDafEvPgKBAQD55KsBuofHiKxwkbpxZQsO20o=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=VwOwRcBIq+8Ch8Vcnm8aDMg2Uws7MJBdBMOCi0S9vQbDC0NvXHjvTgRKnXc9e7yqa
	 UDSjDbDHGIQVDUHJLK6VgPIX2/mK5oLfKSsHw4QS1ICafyFBFiaYVHK20rZMDf1D5c
	 FJqu9BZ35FT4BpIBxvIZwFcnalRzhbQ5DpEcru3XAwT4lkJL4uKkaSbJRMI46kw4xb
	 0To4JfqVk+P8t/ngqFdXbnASTDw7tbRw2XdPVoFwIk0HHGNkKj1x7zrVxvLA8QuXI8
	 3GRWuvO4/sEo94YcjnoRnbbIo78tPxcvxEl1HTi9GGVmmo9rc3p+jqv1NckjvOWX7/
	 6aY91McPEWuuQ==
Content-Type: multipart/mixed; boundary="===============0035746704262275047=="
MIME-Version: 1.0
Message-Id: <76e3a68c2ffd1644b1edc42507d25a1e4717beb9f9d420f04a4036b00e731d67@mail.kernel.org>
In-Reply-To: <20260921192559.2619635-2-shakeel.butt@linux.dev>
References: <20260921192559.2619635-2-shakeel.butt@linux.dev>
Subject: Re: [RFC PATCH 1/4] bpf, cgroup: fix cgroup struct_ops query for a second attach type
From: bot+bpf-ci@kernel.org
To: shakeel.butt@linux.dev,akpm@linux-foundation.org,ast@kernel.org
Cc: hannes@cmpxchg.org,mhocko@kernel.org,roman.gushchin@linux.dev,jp.kobryn@linux.dev,muchun.song@linux.dev,tj@kernel.org,mkoutny@suse.com,ameryhung@gmail.com,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,martin.lau@linux.dev,song@kernel.org,yonghong.song@linux.dev,emil@etsalapatis.com,jolsa@kernel.org,ihor.solodrai@linux.dev,john.fastabend@gmail.com,jiayuan.chen@linux.dev,hui.zhu@linux.dev,donettom@linux.ibm.com,gthelen@google.com,kernel-team@meta.com,linux-mm@kvack.org,bpf@vger.kernel.org,cgroups@vger.kernel.org,linux-kernel@vger.kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Mon, 21 Sep 2026 20:19:36 +0000 (UTC)
X-Rspam-User: 
X-Rspamd-Queue-Id: C5D6C14000E
X-Stat-Signature: gheuuam5np7cjyo6oem1bp3ws3exejta
X-Rspamd-Server: rspam01
X-HE-Tag: 1790021980-769256
X-HE-Meta: U2FsdGVkX1/yCS2pk3i2Mhbz0+IYgg0h1H+zh6/Mg09XcsTc3Pf15+KvyRAEd4nMaBpNe5e7hWJIYoKfgkzDW54EyTmtVIi0pEd8jCEmcscFHF0SEWR4MXbxf3fl6ghL8gCkwRCqLzCaNa1NgCL0VXI3WIP6QAFf21fyLK1Oz40pA8nwPp03APnbMW9P576tXYPaJdoi3v3wpk0wRjFu8rVsc3DTsShYukM25jwzG46jIcSXY2ZWBDlgAi9L0Hj/DFt1Ndg8w62/WExC6ZSaoYjp99zJBN8Qp7lKuE+TJXQ+ADNrFD3hD47vpNHI3ymGW8TfAoc2pkScM+6YSGIFNyuGmGzFymAyq1RVqTwCMsa7lR4GKD8QYGkxOgLbKD7yLnFHOAAlLQT44SC0scdHy/upJp7xMUYUAIqdwU0AOWv/raOeAwx6lgrcaXuZj2CflkLgAABhIRwL7MUs/9s8w46GCpl+o0jCG7Zps/s32Z+PDVDf6VXIaNVAOMzuUZEo5gM7HDMh4OwkhsjLk5fa27gJbvisZYKXJPpFfKIW6pSi565RYd0Gl7XRZdhcqD+K9HSGy2O21yLU2xJNspx3Nvn2nOLk7t4Ide/k93dpD4nYpQtnd3PxgmdN19CgrE8HHQsdMacSn/XXgSULf3m66wHaUNIPQBb9F27DGMf/glXRE5b6AtpNUxVhZ/kIdvMYOhdgyRLtRQMqEGp5F/iJ1TPjkNfajGOyhMEhG9EGQus0BSIG5u5scGI1J3qaVJuoBbwyvkg2Exwt6V5dDVG9Ktr5JDqrXh9tEJ3nHcWen6uPPnIa9Q6c+qrfzistro9xtdo0Qy2aV2cM66TljtQfuSQAkFLYhjBOItNds/JUFDd4M44RHbR+zrlRVAgO8cViORopScrk1e62ZsEff06z615k6qRGRZNnPsmteOuOs4oVMfe4Q19VP75z840szS/qk0q0D46eB5jPGzE5w3k
 CegsWBVk
 JHYUPmqOUp4hKwd6jYKUXh+DaViJ0GUySw/FSfmkcj+X+bZ4ofXNTbjsanDDuHZUS3R72E+UmR12fQ1DhicwZqz3SOOtZHeFqFzGPoNN4+bj/Du4bIccr1ySuATJHC5BgKuwCmbe/szMLrn4RIkMVjY+f6sQ0Q3BH6vnPKLooTQPlWvcxCrMYxuSCHgw3KwgLCtLw6jKw8uEFRgucW4uyPCxnu8gYUuLGB9Q1B5Y9uhWgVZ34y0RrCmwuT4sv0Zcn3FOMIZNiz1zVt3X0C8AY5x/tmaXxXFkf7K/7NFQYU/8WCztDLMcNqca6VxSgu1mgQoIz9hhnmmS8Y6a799236VLDOP/I+DJcaiQRvYB8tx8lLGjC9irQFRvJRmPGDzTGFBGwPW3XE9ueCIcI1coA/XIlGAnzk/bT5p/0ogaIpOupMEZCR2lboeGeec4xSWFVwGher6OxG5Bb9B506xDMQgSF9ba7XjBRjxvan2S0y+AgGBpKQMkPvt6Y5RuM0+cUxCwKty+UsvuR9V5WpkleFU8D06gDBXiM3Xh9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============0035746704262275047==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> bpf, cgroup: fix cgroup struct_ops query for a second attach type
>
> Two things in __cgroup_bpf_query() work only because CGROUP_TCP_SOCK_OPS is
> the only one struct_ops attach type.
>
> It calls cgroup_bpf_enabled(atype) with an atype that
> find_atype_by_struct_ops_id() works out at runtime.  That macro is an asm
> goto and needs a constant.  Today the compiler can see there is only one
> value; add a second type and the build breaks with "impossible constraint in
> 'asm'".  Add cgroup_bpf_enabled_runtime(), which reads the key instead, and
> use it here.  This is a syscall path, so the cost does not matter.
>
> And find_atype_by_struct_ops_id() matches on type_id alone.  An attach type
> whose subsystem is not built keeps type_id 0, so a query for type 0 finds it
> and returns success with nothing instead of -ENOENT.  Skip such slots.
>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

This looks like a bug fix for the struct_ops attach infrastructure.
Should this include:

  Fixes: 369d9dcd8fb8 ("bpf: Add infrastructure to support attaching struct_ops to cgroups")


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/35646140734
--===============0035746704262275047==--

