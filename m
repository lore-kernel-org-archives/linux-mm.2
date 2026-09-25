Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29A3DC9830E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 23:04:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00B4A6B008C; Fri, 25 Sep 2026 19:04:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFD5B6B0092; Fri, 25 Sep 2026 19:04:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEBBE6B0093; Fri, 25 Sep 2026 19:04:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB1326B008C
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 19:04:56 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 39A901407C4
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 23:04:56 +0000 (UTC)
X-FDA: 85253816592.02.7AD29A4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7E15B40004
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 23:04:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="fv/XMh+c";
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790377494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/CbPmrir7hvxqhkoRGJquW0lh0N7NUF6YrjVn/tUNMw=;
	b=Ccr3jrI+H764pS6xfLtCYs2WQcKHHQ9trPB+fquH6rXrD23iRNYMNtuM1KlkeAEXPFJIN/
	QOfnJIY3radaPymi41Gesks7HezzExsmQwGTvDPtdTKaGFWGxcn5QRZmiq42YXMDyvem0o
	usrq8I/9bj/UENpNpflfTBQA6jBVwbo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790377494;
	b=B8M3yHK8wYPSxLmQ0b96tCz4zzC3x2chwXg4Pv92YyokIOhhnfWMLJFeNmSNUYHXz+Iiwu
	swDoRofZivEz6aEcq767RG/PoAIM3sjti6UzwDmlIvNqLPlVOR9wZ8TWc/v692Ql9kcBmi
	6dShxrls9r3SNHiV7EVCToJ5GEb6aXs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="fv/XMh+c";
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EE2C760136;
	Fri, 25 Sep 2026 23:04:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 786071F000FF;
	Fri, 25 Sep 2026 23:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790377493;
	bh=/CbPmrir7hvxqhkoRGJquW0lh0N7NUF6YrjVn/tUNMw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=fv/XMh+ciNrkinWE2uBqyZ2g/HbLC9pT6uDzbPPDf4mdTgRykf8To4g7xkYKggnZw
	 ADGOc6rhFVqm8fli9Kg6FbxUztl7iIXjjFxXe7c5uqSxWDNZNzPSwlssQE70XaQ2lY
	 E67hvMJX/ROPD8WgGruQCvgAveUmP7zQv+QdGYpk=
Date: Fri, 25 Sep 2026 16:04:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>,
 linux-mm@kvack.org, liam@infradead.org, bpf@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/nommu: Reject wrapping ranges in access_remote_vm()
Message-Id: <20260925160453.7e7561edb77b5c4152675f7e@linux-foundation.org>
In-Reply-To: <arZzn0bwWqp7xTE5@gremlin>
References: <20260909064231.18693-1-tasos.papagiannnis@gmail.com>
	<arZzn0bwWqp7xTE5@gremlin>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7E15B40004
X-Stat-Signature: 7m7qnyrccena4dk6p1yfxok637om11im
X-Rspam-User: 
X-HE-Tag: 1790377494-498215
X-HE-Meta: U2FsdGVkX1+pTjnMa+DAgp983WhE+tii5fcmQYZycDmsBgKmgtpD5Gq/fOFdwUN4kTPjaW2JYmHHNx+z1Gh7Hi2WHwI3r9DUgdM6baQYabOkFpYETYpYTfSqqWN/5+qWzYIa6krQPFaNZ8YNJMBTw7NhqGYlQm0apJUl8Dr9YKs9OppKe+nbx0KfRjXXKJlqbLakHjcMnlZtWIPnnUMIhrBY6DI9dpFsoUawYUc/wyvZW4fuRu/AwRlVdLxkIzY8nyfGSmBLNPv/umIvaB0UffwvhOwN+yz6cPtqfiTNTFS2w/uBKtZT9VOszwyuaDoPKXQ+rC5P5tqHoWDft+O6bf7T5RNhuYW+c+jIcftJB/2QBbK4Fyee3qvOV1DhqPxY+/F7eko9Njd4YXwy4lDb4oa4vKmq7vPSPin8wrQylngOa/Nyjljyd12OC7U9Gj1oGU3IaDbwdUZZHCbGd5oaZkDmDiiZzJx3IaCd3GET7UiLUs1psI8ol0nlSMTTk9jj8OAwcjCULhWwzXS3ugqsB/Fa4+pkLcfDdwP2F+awfOLkL/WdDUylNZNlzKqSFWpnnN6ie6NlIcnIt7dN8F1sKGlMpuN2W9yYqd7YN3PZAjcBZoJtJeULAkCkvcuu5iIcMJyRfiSxFoQJ3t2qGYiiTskdfDf6xjy0HQ+Oa7pN7CFpoPi5evlmzv5DsQR2hW3SQ0v4ggzTovVmgT2TnyZNPoD1/HBep4rMcgn+fInJw80/woeOP8GUHZZMgY6IvPQIeRQsbhTp8TlBGash03/QpYeJKE6y4YNoTDgCLq3UphbIiXciAAs4HQFouzO0NkF57zA3rtLxIwZSrAKpDa2sL83JaUXPpfuHhrlyHU9EMYszqLJaMrM51+EEEnZ7BsuxtXhspUbRLHBP625+EasuSMFrycVGC50/EfgHNgmSR7F097OCHHeevfur5b8dtpX0xyXhy4ozLNTxm19uV7W
 +OnX8c1q
 UEFqhLh8s+7jprbxfVjapZOKEF4t861O/APc/cMinugjJhJmrR+2xQ6R8PAIHSWqPlYbUIYCyI8OkFXW4vmZbmDORBnQkmhD5pQd1wVdQmV7Swjfs/UcwBqupIb6bsw3FD0XYt2KrRcMKuhU59xabHCu6cNa1C7qFSACXqH5Er4xuXH4NUPVuabsCaX0ufNKG8E7D4NMi5/fRJFL0bxYhwO0kx8Cyo1Zjktkx94UrVkAgjOIuJfMduKRPF9l0mt0GIqxhk1O1Ox67BIohc/G+cQP9AAsiUh7d3g5UQG9xX/1QqxhkmsS58naQAp5cxv6bZqHpAbtg4iCCkl01yQXh/R+VfK5S+CCIwx2QhFYqwdo1unLPBg3fgYLidBxNz0aqLV9QHeZFbu2tJ7mE8d/a2KtAa+RzNP6mSVyJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 25 Sep 2026 14:20:33 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> BTW always feel free to nag if you're not getting review! Something things
> get missed. (Though I'd say wait at least a couple weeks before doing
> that!)
> 
> On Wed, Sep 09, 2026 at 09:42:31AM +0300, Anastasios Papagiannis wrote:
> > The NOMMU implementation of access_process_vm() rejects address ranges
> > whose end wraps around, but access_remote_vm() bypasses this check even
> > though both functions delegate to __access_remote_vm().
> >
> > Move the wraparound check into __access_remote_vm() so it applies to
> > both entry points.
> >
> > This is originally reported in [1].
> >
> > [1] https://lore.kernel.org/bpf/4ef240a5bea36ff84df9589671367832860795159386a4c8fba546a0fa8b786f@mail.kernel.org/
> 
> Probably better to drop this big and make this a Link: tag.

My scripts (after much recent LLM-driven fancification) made this
change automatically!  It became

Closes: https://lore.kernel.org/bpf/4ef240a5bea36ff84df9589671367832860795159386a4c8fba546a0fa8b786f@mail.kernel.org/ [1]

But scripts didn't figure out how to add a Reported-by: as well.

> >
> > Fixes: f55f199b7d76 ("NOMMU: implement access_remote_vm")
> 
> Cc: stable I think?

Well why.

I see in [1] "causing memory disclosure or a bus fault".  OK, we care
about that.  So the changelog should tell people this very important
info and should explain the circumstances which can lead to the failure.

> > Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
> 
> Seems reasonable to me! So:
> 
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Cool.



