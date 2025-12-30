Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E14C1EE4990
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 18:13:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 361936B0088; Tue, 30 Dec 2025 13:13:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30F9C6B0089; Tue, 30 Dec 2025 13:13:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23C716B008A; Tue, 30 Dec 2025 13:13:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 10B406B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 13:13:35 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9D48CC178C
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 18:13:34 +0000 (UTC)
X-FDA: 84276935148.10.8774F3C
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf02.hostedemail.com (Postfix) with ESMTP id C09968000D
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 18:13:32 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iWRHPxUK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767118413; a=rsa-sha256;
	cv=none;
	b=Y9w0CF7YZoNIjx3TSprHnfY9tBMTvpfEcl/hT2vVq1f7ejFAkGkle8+8gmihJB2gbtYbQX
	EfnziEGHg8xPuNblGrJMMfaEnTadykBINqd9aMjPltC4dOv75y+visiuAbqIBffuLz5zaS
	g0P3q/qy8m5H8aahFJcG+03Y33I/TaE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iWRHPxUK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767118413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2KIbte4AjguXPg7uu7NhV6x7iy3noJMlW4r9WgTskaI=;
	b=HXoo51CHNbntG4jaYlI1EHM815um4BLp3pbOApvuUELfjClxuL+E6PtRFm0HKirA6snIgM
	qATdiOn8NHMWNFmJ9WnhR6Yc1S3T6N46GrBBXxtEmMJXpM7IfnKYVEnP4dkZTbuPR5kvR8
	T4/vJkIOqN6zQEI5R8ME8rDzEy5DtC0=
Date: Tue, 30 Dec 2025 10:13:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767118410;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2KIbte4AjguXPg7uu7NhV6x7iy3noJMlW4r9WgTskaI=;
	b=iWRHPxUK6bUIObUiOlm47FeYyctHwFJnt3AZeHE7kRDgg7NfSbQ/zb9FdNxilYaDhuey2q
	dbYCTZ5wzOJY9E53RProjDZDQtV6nCjKBijiZ7OAW5QC5xviyqhQLuAzPvqkzQb8/AAdN8
	46d5J5BuBO23NZsPaS3EiyWJLf2PTDM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Zi Yan <ziy@nvidia.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	muchun.song@linux.dev, david@kernel.org, lorenzo.stoakes@oracle.com, 
	harry.yoo@oracle.com, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org, 
	hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, lance.yang@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Chris Mason <clm@fb.com>
Subject: Re: [PATCH v2 00/28] Eliminate Dying Memory Cgroup
Message-ID: <slvvzxjhawqb5kkgfe2tll3owxjwtq2qkwd7m3lmpdslss73lo@hkewnkbik3qr>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <7ia4ldikrbsj.fsf@castle.c.googlers.com>
 <1fe35038-abe1-4103-b5de-81e2b422bd21@linux.dev>
 <87tsx861o5.fsf@linux.dev>
 <c3ee4091-b50c-449e-bc93-9b7893094082@linux.dev>
 <krpcb6uc5yu75eje7ypq46oamkobmd5maqfbn266vbroyltika@td6kecoz4lzu>
 <03C3C4D4-DC37-4A2F-AFFA-AACC32BAEBEF@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <03C3C4D4-DC37-4A2F-AFFA-AACC32BAEBEF@nvidia.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: C09968000D
X-Rspamd-Server: rspam03
X-Stat-Signature: 6prs7m5ra4k65pudzoo9691itgd1kgrn
X-Rspam-User: 
X-HE-Tag: 1767118412-500392
X-HE-Meta: U2FsdGVkX19Es3HZeQay+WgXi2t8xVQM/cdCLkC4ceNF6rqx1a5MkvvLxn41vLviDbZen0Z9n48vgp9OUl80Vl9kng1isEgn9Vrb6HR9AIHNB2EP1fUnTngk+nqeWEaLqQIX+ENjjbhlNrRQYZvkD6wJoavGLN4IjEHnl62z7T6iNxwauXzhFqkPz25/B9y5rrAWKwW7exHJma5pR2TULYgJ6WjWr7kVYbvHy2qbwtFHH76oVNQiJJDwm8bCdvm3MqdtoBXQPLBmOs+VrDULeiIr55sTC6cWcKdvfgj9LEP1h3ohGi1klVSD+LMgL2WRzQRSvLveY9hyqNBHsdMcnHwQ9UA53BIrKitiNU6ZhCq19aiqmimGfY5RXWnaSMmIRQ2kV2V0tWbDY6ty0XtFz9bFeYyOJTpLdupRrNCF/vbZvuQW2e7YScetrRpcgFsVArsAv7C6hTHnzLbQeSzSeBsxdXD8fGUnsLBdC/IZvJTWW+AYIS6FtnV6JvDh2rOjt3mVeq50j/7VwWcRT56eiA5FnPQHWxrpqV2SK9ZrDZYPbDdLOqErJUCoCK+zqmSV+P925YFS+OcW25uDEpOYQiT7ZPh8ajSm7lL6ow4V57gQzvK+jo73ZmE+74FZQOoqXE5x5mpXU9YxqqDCAY5x4EkITjdT2InfTCc5g8/6LtyC2M4ikOxv6ALvjs+vpidE5VvxMU2Q+MqO6A1k7ST4STIecdeAaVaqxoMOWBJdfTCxsZo1AGEPDkHgwPTjDUbcehS/n/R0VcMt7EAjDz82NIwvZeX9LPz8BivayM81t04VjbI0RypZbIWUwC6T+YF/CrthyMxqKFI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 30, 2025 at 11:46:02AM -0500, Zi Yan wrote:
> On 29 Dec 2025, at 23:48, Shakeel Butt wrote:
> 
> > On Tue, Dec 30, 2025 at 12:25:31PM +0800, Qi Zheng wrote:
> >>
> >>
> > [...]
> >>>>
> >>>> Thank you for running the AI review for this patchset, but please do not
> >>>> directly send the raw data from the AI review to the community, as this
> >>>> is no different from automated review by a robot.
> >>>
> >>> Hi Qi,
> >>>
> >>> I don't know why you're so negative towards it. It's been great at
> >>
> >> No, I don't object to having a dedicated robot to do this.
> >>
> >>> finding pretty tricky bugs often missed by human reviewers. In no way
> >>> it's a replacement for human reviews, but if a robot can find real
> >>> issues and make the kernel more reliable and safe, I'm in.
> >>
> >> I just think you should do a preliminary review of the AI ​​review results
> >> instead of sending them out directly. Otherwise, if everyone does this,
> >> the community will be full of bots.
> >>
> >> No?
> >>
> >
> > We don't want too many bots but we definitely want at least one AI
> > review bot. Now we have precedence of BPF and networking subsystem and
> > the results I have seen are really good. I think the MM community needs
> > to come together and decide on the formalities of AI review process and
> > I see Roman is doing some early experimentation and result looks great.
> 
> Do you mind explaining why the result looks great? Does it mean you agree
> the regressions pointed out by the AI review?

The result looks great because the points raised are really thought
provoking and things I have not thought about when I reviewed the
series. The lru lock without irq or the possible infinite retry loop in
get_mem_cgroup_from_folio() are two such examples. Are these real
regressions? I am not sure.

> 
> If we want to do AI reviews, the process should be improved instead of
> just pasting the output from AI. In the initial stage, I think some human
> intervention is needed, at least adding some comment on AI reviews would
> be helpful.

Yes I agree and therefore I mentioned we should discuss how should we
(MM community) should adopt the AI reviews.

> Otherwise, it looks like you agree completely with AI reviews.
> In addition, “50% of the reported issues are real”, is the AI tossing
> a coin when reporting issues?
> 
> When I am looking into the prompt part, I have the following questions:
> 
> 1. What is “Prompts SHA: 192922ae6bf4 ("bpf.md: adjust the documentation
> about bpf kfunc parameter validation”)”? I got the actual prompts
> from irc: https://github.com/masoncl/review-prompts/tree/main, but it
> should be provided along with the review for others to reproduce.

I agree and I didn't know that Chris's review prompts are used here.

Ccing Chris for your following questions.

> 
> 2. Looking at the mm prompt: https://github.com/masoncl/review-prompts/blob/main/mm.md, are you sure the patterns are all right?
> 	a. Page/Folio States, Large folios require per-page state tracking for
> 		Reference counts. I thought we want to get rid of per page refcount.
>     b. Migration Invariants, NUMA balancing expects valid PTE combinations.
> 		PROTNONE PTEs are hardware invalid to trigger fault.
> 	c. TLB flushes required after PTE modifications. How about spurious fault
> 		handling?
> 
> 3. For a cgroup patchset, I was expecting some cgroup specific prompt rules,
> 	but could not find any. What am I missing?
> 
> 

