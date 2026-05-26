Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C310ECD5BB4
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 07:16:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 229B96B0005; Tue, 26 May 2026 03:16:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 201B16B008C; Tue, 26 May 2026 03:16:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13F146B0093; Tue, 26 May 2026 03:16:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0448A6B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 03:16:19 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BD8F61C01AC
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:16:18 +0000 (UTC)
X-FDA: 84808712436.11.774C0D6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2725A1C0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:16:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NoN4EZXq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779779777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eRG0zcrXjj+9wqDZKLd7HllNgNkPyBgP5qAN66OAM28=;
	b=y96q2cvOk+hpwLlqe/70Kkk4F/Q0+gvXH21/569ZRiilWWgC4vhsZr+djDR5KzizcvgCUK
	4NJjteW1sO4j2CsyNufViP4+nRsKXUVLNYlKhQNCDALSwuge+NTFY4xMXpaZKauQeAUAcM
	c7vRskNLLNwFYkk9+WrDVzCby/slhtg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NoN4EZXq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779779777; a=rsa-sha256;
	cv=none;
	b=F6qJ2rVJj4mjO2677hv1Ah17o5QtCN9sEY17fTnCSv9nrGKCMM8DnNVFEW8LXfvXoolwaE
	kS+Dk/YBIWUB+7738a4MORbxUO6juTDrox+o2D+hd6H8+DpwyZkbYwC8s+bsqeJ9PfiKrv
	plZlH6WXLuEl9dCT3bhOst3kqSXBWGU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 14B7B44541;
	Tue, 26 May 2026 07:16:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B2E11F000E9;
	Tue, 26 May 2026 07:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779779775;
	bh=eRG0zcrXjj+9wqDZKLd7HllNgNkPyBgP5qAN66OAM28=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NoN4EZXqV1KaSeG8mVESvmUod2xmiIR8JV0wdKYflx+JOJLX3ym4W6YdUmWYjDxoE
	 5oNMMNssz698pKcpag9/WRxeaMlWGDed1o+SEV/L/LKbZyZbwFvhQZ2p+La2sYOLcg
	 7qBtcLYc9hCoJ1Vp/yyj8QwxG/8DdMycjbX2gPRaRcqyO5oOqsvUmtQ+ttnYqicUPc
	 5GhtYBMtY0k8oVhkjdAQD8F6GuXsKj1zB/cqbjMx8NEDidRFbO0kxthP/zqW35iMBj
	 s/e+D5e0LQpOY9RMvRutzzNOv2eMZs5zuuieTFeYdiBJQYrCy6QJl5JKS1dgXQCzOx
	 jrG7yV4+GU2Vg==
Date: Tue, 26 May 2026 09:16:09 +0200
From: Christian Brauner <brauner@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jann Horn <jannh@google.com>, 
	Linus Torvalds <torvalds@linuxfoundation.org>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Qualys Security Advisory <qsa@qualys.com>, 
	Kees Cook <kees@kernel.org>, Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org, 
	Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH RFC v3 2/4] exec: introduce struct task_exec_state
Message-ID: <20260526-halbieren-badeverbot-maler-d4bf1a6ea119@brauner>
References: <20260520-work-task_exec_state-v3-0-69f895bc1385@kernel.org>
 <20260520-work-task_exec_state-v3-2-69f895bc1385@kernel.org>
 <ahBveiRasSfLAx5b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ahBveiRasSfLAx5b@redhat.com>
X-Stat-Signature: htii5w6km3uuucbn6t8smzdcbnkck8uf
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2725A1C0005
X-Rspam-User: 
X-HE-Tag: 1779779776-484956
X-HE-Meta: U2FsdGVkX1/i6KLkYzh+217SvArUED6cYSzXOJGo4KoegM0E9zIJshRG82GDJCXzeSf71gcbnPoPV4L+q1VeQefM8ogd/HNktbr6qBvw1/dwvwpzzQP7BzcZ/58IeV3tOR7YohKXwtL/nbgMRUHQlDEJKmZ10jJXPOQzCebCS4w+FYXHzXpfuYdK78xKjo+BxfGqTXZVEbXMsOyned6OehgbgrfTZk8Lqaqr/O8tDsZNLbDvWDh2Sb7vZpAWnr6/8L9lC/kSrY2yLQKSOkp4wytTvgju+3x7AtW99K0HwrZKLeSeSM06EcaLo2QiCVF/unFpB8vieJiaiuWA9SFD7xJqZ+z2saiDRQL5YfYNQ5NsEDKOpqJA3ytYML4+X3NXM037CeWmphr3JHVaLuMLvNm3mjSUDo+j7D3r5fQgQLQjXZkR5/T71QsW5cMlGYd8Jxq7mUW7FqrJeB8HDsURmUMuuf467ef9xm2F+WNK9FdZp9p36VgClf8/FodgjmKWqI0vBSHPblk5Q6wRWAyKDOifdYKnJIpU5wMmh+UVjUJv3icaEdUjg1b0Xy5zlfic/oV/aQcgQz6nIZiZG7x9djb5KII7WlbCVfOH5ArPsIradj1fFuQ6NAI5aWyc7K57X4vMHgWksFewT7F+/CDzmhZdJUQpeqcf7jNaPEC2jpbkmsQAJprggAvmEE4O8i5aqwLg50/Vu3NugOy78AVgilhqMUzLxG2Q6RByBQc97U+XhHuydY6HpZa8GOP4WjGOESAA2X4mn7YnZEvUtGye7HA3+WE1xueWSpmXl4gmHv7O/58C3MqhUfkJJxZHIh4oTu2R4CVdabtBDIT+hpjqOwZEuzBD5D5/1B4RDP789f0YjCf894JvyYLOf31QX/Jh5RGbpnQtZAIhQGOrxN7zKakfYLNccBknC/T59UtZM15FOkCd0BLBofLH1+rKLKfHuhyZ8wQdGjNctpDqO1Z
 4xSms5af
 8mmTjwl4/i73na1jf3nFbnnPN3134xD7i6QAUCMhfZoKslRFKDf0851jzuZMRGxWdQNVNptgPbBy8qJNkPc7+BAZnx8zFYZJfc3Ic46AbA3Y9jWWNPxkF+k0+jbdfH9Cmu80T0lj/Z1ZTCmEf1IBuwVdwt/DgDCHmXdK/mbkVanMxHD/QLxXJgM1rA93xyQsK9c6RNGKHsLwiiExDP0lfIx6qAf+AOKbceYVJiSblnHs77/JLzwe9Qen7PbQGGgAhxk+VmWpPfpbNnP1QQMNe/7HEcFS9p8uGYMjHWij0fAqDPcUPmt8iCsQDXvtSet1usBQIzufm5Qwf7gz9om7Z95oCOguZxHnt9/RL1n6TO1nvyoU6Y/37Ykr1aYIU8i6QEVIaGGZ/8+c5OwNsSQqTn0A0BxKnSsphliWr9WYt+upIcRU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 05:00:10PM +0200, Oleg Nesterov wrote:
> On 05/20, Christian Brauner (Amutable) wrote:
> >
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -962,6 +962,8 @@ struct task_struct {
> >  	struct mm_struct		*mm;
> >  	struct mm_struct		*active_mm;
> >
> > +	struct task_exec_state __rcu	*exec_state;
> 
> Sorry if this was already discussed...
> 
> Can't we (later) move exec_state into signal_struct?
> 
> AFAICS, the only complication is that task_still_dumpable/etc can't use
> tsk->signal->exec_state if tsk was alredy reaped (another thread can do
> exec_mmap() after that). But perhaps we can rely on pid_alive() check
> and return an error if the task has already passed __unhash_process() ?

So Jann pointed out a problem with this in
https://lore.kernel.org/CAG48ez0Gz_GghVeVzaixAQRNYBdWHYEj3K6FXBSzc+8WNsFxtA@mail.gmail.com
I quote:

    I think signal_struct is not unshared on exec; so in this sequence of events:
    
     - task T1 is a non-dumpable task
     - task T1 creates another thread T2
     - T2 exits
     - T1 goes through execve and becomes dumpable
    
    I believe T1 and T2 are still associated with the same signal_struct,
    which means that even though T2 is part of the pre-execve process, it
    shares state with the post-execve process and it would wrongly be
    considered dumpable.

