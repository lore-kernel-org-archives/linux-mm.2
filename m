Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5913ACD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 19:46:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 963CD6B0005; Wed, 20 May 2026 15:46:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9139B6B0088; Wed, 20 May 2026 15:46:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8296A6B008A; Wed, 20 May 2026 15:46:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 74DCC6B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:46:40 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 960881C0198
	for <linux-mm@kvack.org>; Wed, 20 May 2026 19:46:39 +0000 (UTC)
X-FDA: 84788830518.13.325BB37
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id B9E3E4000D
	for <linux-mm@kvack.org>; Wed, 20 May 2026 19:46:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CRptv/lP";
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779306397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7lSWTy00BvSZTY+xqAPC7SlKrdzegcATLVgUGfnA2BY=;
	b=GA+r3ldgT0/E7745c9Uk2Nmvq+mFhpGu3OCSMh/7kL+SIeJKmXvAcNM23gRGB0cKkNCX+u
	BHxGlen/nNwKNkGtEQgRHE06NlQIhbhjkAE65SZnl2UMuOpjmGcvr1jMj9KU0eo7P9Wv5F
	BzkwlGCUFL6lMfFRW9ybnCCfO52/4TY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779306397; a=rsa-sha256;
	cv=none;
	b=5KbWBh1KzMa9rGzsMxswREUHAUbotbwzgvemg+Bp1Vpj395mDJyoUmy9kY+5gSO4DSGNLY
	w+eG31h4hKzWDtxz5AhcDxs72k0xjUJqZImdq37u6StTq96Durm/dO0DXn8BtDHe3hKZkQ
	4fTrR3x1q71DloqciZd21CWq/z8q+Go=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CRptv/lP";
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ABEAE41B07;
	Wed, 20 May 2026 19:46:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DAA41F000E9;
	Wed, 20 May 2026 19:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779306396;
	bh=7lSWTy00BvSZTY+xqAPC7SlKrdzegcATLVgUGfnA2BY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CRptv/lP6ThFnKf9wG2Wce+ge3rAlMa0TA7OrtF5MQdFqLBrJsjy8BT9dPhLbCacH
	 ewPu2yCSxaUabtrJQh8mFyI94bcGvMDxdnmcyCClVCozxTQPYqn7BxteUJz/Ju6gpw
	 LM9cNZHuA+Ql4h6coPrtUBNUOyhAZDJVkBuJfqm/c0zj1qWyC/kyZ5sQtG+3mvXH2k
	 EKm+7X5Na8f6ViMHtaLLzBJiix38soNjc+spgbwW3HPigMa4iTyl0SJ4xC06tysmmz
	 eCpg7YSEkDiKrw8znFRsp/IolM80GFhf0i4PShxKNG3vcEXxE3taIujypPd01FZ7fs
	 wh3enGt1pA1DQ==
Date: Wed, 20 May 2026 21:46:30 +0200
From: Christian Brauner <brauner@kernel.org>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: Jann Horn <jannh@google.com>, Oleg Nesterov <oleg@redhat.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Qualys Security Advisory <qsa@qualys.com>, Kees Cook <kees@kernel.org>, Minchan Kim <minchan@kernel.org>, 
	linux-mm@kvack.org, Suren Baghdasaryan <surenb@google.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH RFC v2 0/5] ptrace: keep mm metadata accessible past
 exit_mm()
Message-ID: <20260520-getrickst-farblich-20a11fe21bf3@brauner>
References: <20260520-work-task_exec_state-v2-0-9ea88ceb09e6@kernel.org>
 <CAG48ez0kVA+Rw+pHSi5-JLf9KTh8Y9Am04W567YS=imgk+b7tA@mail.gmail.com>
 <CAHk-=wh7CJo_GmRoByrMePPB6sDC2ienhEd8riq=xp0BLPYZYQ@mail.gmail.com>
 <CAHk-=wgfOvMTh8Tbkrk8ifHw_aA+vfacLs-NtULpqx1sN+y01g@mail.gmail.com>
 <CAG48ez3WUjLY2iV2_BmJB1RX6vQ+5czYNJY5UP0KHZLvob_Ztg@mail.gmail.com>
 <CAHk-=wgtQ1s9r1zaBcV6vau5vBd2zmYyhH0WqY1KfjyvAseB+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wgtQ1s9r1zaBcV6vau5vBd2zmYyhH0WqY1KfjyvAseB+Q@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: B9E3E4000D
X-Stat-Signature: mhwc8onq3cn6mukcoxmmkzugckrx9wtc
X-Rspamd-Server: rspam06
X-HE-Tag: 1779306397-363059
X-HE-Meta: U2FsdGVkX1+BjBWqslh1gL1KtO/OkggeJAl/UZ7cYfFhU1M4oS5bMhYyVMtJcB4IExpJPqdQFKQD0c9l2YkBwOHRj52TNxJDZqyBeT1kgrQtjcsm5DoxwJGttmQ1JCyyPHqAIf5gJyu6igtYiRWRpZLydMRIe/98+xTBWm1lNSKvRk8OHLKFlfG40e1xOniH073ip/Es/JhCymT6ETrUFdeTWAILzAwwlsYKhT7CdUBSvpPMMJnW26TmLpXFweHs7W1yrMl3twMKWFuTiRSPnsWzZgOG3oJDUizZGK2Efx6SnXTPkwmFYJIT2r6npZZoL9so4QCAhBAktJn8JJFtZ9CKVnJu8upvw2ENw+4bv1Y8gls+kujTqh+SHsKHyrSRuvibzKHkbk1RgoVhX2SvfLf0z34hXlO+9I1hQ6mq9I3cwMJLKjFzgsksfel4PdRJKC9Jxj585INntI+jWpJyEkMUIWUAAd+naX9g1PlWhYePmx6Zq0x+Yjpe/yKOYw/Y3MuMThHJnw4t+5fIPK+46jEFP9ZYi7NeewNCJTQiBeU8QHXGd3Yztnm5ct/pj4VeCvRksHxnKg73emfrBNFf1BWWuKFZ3AvjO8co350itqvnORmd4+sEK95lIqBw/Mz24JnZ9fyEK3pErjC7gR+JsKpZqtfSkhFrogDfTcSz/tn624dEiowv/bcsq/OSHw5yp06YgnGP4dnilMKOCmQEJycOfIrMaNcjzPCS0qRBtVn6RaWxY3+118GAku8eqCR94fjDLysddp8CxTldEOFg8ELwQEJeEhdiQspEpcQ30S8HXgzvco4/letzOK6fDC+WSSY7TEI8B0gJlIHkCjrPOZatZaZnyv6YwusAKpE0nMcRqOExJbUa6oUJ217qHnm2tr3IOxJ4vULH4SWSmxkz95r02Su2MXKOHhBIv9RP7XuW78xaqy7NVjbS9y2cDot6oK7qFuhiHyQIHQAFDZC
 mbCUAsDJ
 X03s7ZTRN2kvulVhLdm8lS9E3N7B3B07JCMNvt38hedMh3aJh8INl2AHD1FOT1JcmhO/vLx2FT+rgWUQTH29Co6NJDbUYSnUYSB+coo/EQLNKwer1yZe318dUlorCbCDJkKkThiEXS340dWWGE0zeJb/VslBkFKuPRpv6+A2XAaH6TN90bdbVer0FkSWi4R3WeQ2mBPIq7TrxzfXC3A5TkcG3RISWMN0RUl5tebiL4uLyg3BbkY4LopVsNnhM2AjxVSWbsxYsH2//ShqGDWDVbf4eZ/uRwwqJlKu/q9DIqqmggzive0HvFKHo6bsgSjWdlTb5nV/33GW9rtunCMvreaQFn9acVfUPtFH1/2mPUGVTzatMEWKKELaCpA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 01:12:49PM -0500, Linus Torvalds wrote:
> On Wed, 20 May 2026 at 13:09, Jann Horn <jannh@google.com> wrote:
> > This patch series always unshares state with alloc_task_exec_state()
> > on execve(), and never on clone(). I think compared to that, it would
> > be strictly better to also do alloc_task_exec_state() on clone()
> > without CLONE_VM for now, to preserve the existing semantics.
> 
> Christian did do that originally, but I convinced him that we should
> try to aim for simpler semantics (and imho *better* semantics)

Tbh: I always expected that we would end up at the original
dup-on-clone. Either now or when rolling this out. There's just too much
crap that could rely on this - but we should've definitely tried. And I
very very much agree with you that the non-dup-on-clone semantics are
fundamentally nicer.

I wish that dumpability could've been a userspace only concept. I really
dislike that the kernel magically resets various things during
commit_creds() transition. It is such a mess and leads to really broken
behavior for stuff like pdeath_signal which magically disappears on
setuid() which makes it so useless in practice.

