Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4A03C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 11:31:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3A816B0092; Wed, 16 Sep 2026 07:31:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B11986B0093; Wed, 16 Sep 2026 07:31:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4E1C6B0095; Wed, 16 Sep 2026 07:31:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 863E76B0092
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 07:31:08 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2024B1406E6
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:31:07 +0000 (UTC)
X-FDA: 85219409016.02.2E33E64
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5B17520010
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:31:06 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JInK15Ne;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789558266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d3aQ/RHXKAOVlFbFC1F/OA3OtXmrvIqiX5Vn/+TjVtg=;
	b=vwxNZ9ACsnKf2iNmqPUMw+6G3oIft6YAqxXcHor39JOeCreW7r82ibzZQEnh5XU9zyKXZ9
	Q+CXAcFbanqtql6omFGd23NeXkZFN1XXRUj/HWVU8vIvrg6yaZ0LSc6yexkRt0928Hygmj
	MJzyIEnnjBjIa0EXLAqH3ZXhFUqfM7Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789558266;
	b=yQ8j8OSCdDfnFEk3vsUcfg62TKzan8Vp2TEfW0bU31JtjMF1bLgCE6Htla3LEycf8HZOTW
	TIz8UiYikBjmoodZx5Yn8x5lvS0u6Gkf79D3TfCxo8CG5Rsp4cBzbCaJ3eCI9Gig4h+AE+
	8CTqIXx44X9SqC30AFDr4fLPMZ0RsBc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JInK15Ne;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AA37E435E1;
	Wed, 16 Sep 2026 11:31:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D870B1F000FF;
	Wed, 16 Sep 2026 11:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789558264;
	bh=d3aQ/RHXKAOVlFbFC1F/OA3OtXmrvIqiX5Vn/+TjVtg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JInK15NePnHwnp5y0aeKVDsmdAWQ8ljldVfQpVz0MS0LQJtQw6xAdjqUcD11+caw5
	 j04ipBiOhLho3PxcawONN/CNz5rKhn3QLdRjSMjrFCR9qfLuG2i6ir8g/hV+P/B/kO
	 7lluvELFD+ej13n46WiWLJSF2G77vOKF744TzZHuWT/HW4vElneAba8jl6gsZ1t0cm
	 LGmel36amcsfpCcrvO+h9UCuoB3H5dtwncIjPLSIeJ42cn64gluNG1XGbhZwAzKzDX
	 AnDRxeXd7PuKQyiz9pwLE5C/8PblfNiwJA+38zoHGRbM6g0KTfrCbY0d4meDIcxuZ1
	 wZtv5VHieRyCA==
Date: Wed, 16 Sep 2026 13:30:59 +0200
From: Christian Brauner <brauner@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, NeilBrown <neil@brown.name>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org, 
	io-uring@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 3/6] coredump: hold RCU while releasing parked threads
Message-ID: <20260916-aufrechnung-urnen-jenen-519900ff6667@brauner>
References: <20260915-work-coredump-fixes-v1-0-f354ca41780c@kernel.org>
 <20260915-work-coredump-fixes-v1-3-f354ca41780c@kernel.org>
 <aqlglWwVeh4rwL0q@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aqlglWwVeh4rwL0q@redhat.com>
X-Stat-Signature: 118914d4szqxgarsmewzqb74g9icytas
X-Rspam-User: 
X-Rspamd-Queue-Id: 5B17520010
X-Rspamd-Server: rspam03
X-HE-Tag: 1789558266-215882
X-HE-Meta: U2FsdGVkX18mrx0VJ0QKTUA3qzjCm52otwMjRzWmi2K9GA+Cr12A39Xg8T1L4Zm2TByUEPCPhGLcwQucTt6coIniMfoaH2mv/ol0Vu6OhS2mpd1w5m8a/HFv5GBRa6FUMHzWfy/EFCDPG0c96PBzsMAvyZ3VCC5tgL+S18C6YxM5Iy9WI9nxOc+yc1VCgVEPeqjK1yb8x4XHc5vm5lEWKh/Gvg5p7su1pOPh7z28JepKOLvmRAI4ikkOfwv2DMLQeF91halCHBZHJPPgJGaovWWtNuEqJ/XdubtnZBSZBB7LZXZy7WrUSOifpq1YfbrzRhZzMLxQMNNFDHVD+TZPPupf42p0NhP0jiyJe8/+bppoq7En/WQBKKSxMcsmoF4Z6SHmbLW4s7L+kqIskwhYf/EhJLoCaItoYHtzfDONRpu4MJi6SGU77G7UQaH2J/i/mrmcdVSampIy3fKf/DC5XB9vKsrNFwuFeA8EImCCRvOWHFxhXXd5MjFnZzb7lOcuTA5ihimN/TAbWO6WgQvyOjycvRIwy7+A36bWNrlgDAFuDZ9h/6M6l5HGK5Cwu0LkqRCyBT72uUyIW8JasUCMwlVkiY8PHGp0aLH7tF5Ef+xYcY3h7ydfkefyrwLkAs0Yst8rRRz8lX1kOlk4vjx51DYr3yI9QgkTgdYakn80tu/8hGSodOAN8KrxppPUD8Vte6WCWGOWtyqJZkQFIvHHe3rWKL3rzkLxiCy9FpJV8cjmpmA4uQab2HL4PdeCoN/XIMyhaJe7Y2sqkY4VihFNi71mmrJGgpf8xmmMCuKzDE+ZfBat3fIwrfhaDV1CBiSJ/mJx5Ceyi9Lk1wF5UaxRvU4X8hgr7zHIgevjkCf90HvCOIDVs+E01/fd/a03QdVQVorfIJFyPzwQVEkInsFLJMc3JLGq6JjEIHEiRbn3AqWnLwP82txyIadMADgZ3EUklh9Ml0OgjalV0uh9Ff+
 iUyeuZTp
 f9hZKjT3vaj034Mhaf9gQQtmX5urOi6x3b14vtG4wS4+aCok+CQa3RkemqRreyQoHGGlFgQysD/FFfTItMuYEir8jq0PaIAeIU9p9t+npnTca87/tLN/CMJAPsFwIEEIwZrppnt4fTtH7+y50IvU50MNlHkO5T0qsprAu2akVARQ7xBm9UH/O0IXaJuU5pCX52Bsl4ibxoTAArhYh3eqn6BstthGCSo5QnJdu+8LUNycnrhMI3z9aAMvk+8+ntKi62kT1KZ8yfAw0Oegw8rOrNTfewrTYx/G7GNYYFCu5JoTix0z8UpzQ8RfKTUFLdGY22605JxmHUTLqXObwFU8kcM//xQo9UPGcE5z2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 05:13:25PM +0200, Oleg Nesterov wrote:
> On 09/15, Christian Brauner wrote:
> >
> > When coredump_finish() releases the threads the wakeup neither holds a
> > reference on the task nor is it inside rcu.
> >
> > The threads don't necessarily need a wakeup to exit. If it gets
> > preempted or was woken for other reasons it sees ->task cleared and
> > exits. So only rcu keeps such a task_struct alive.
> >
> > If the coredump client is preempted between the store and
> > wake_up_process() for longer then try_to_wake_up() takes pi_lock() in
> > freed memory.
> >
> > Hold the rcu across the loop.
> >
> > Fixes: a94e2d408eae ("coredump: kill mm->core_done")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> 
> Aah, thanks...
> 
> Acked-by: Oleg Nesterov <oleg@redhat.com>
> 
> 
> But to be honest the changelog looks a bit confusing to me...
> 
> 	curr->task = NULL;
> 	wake_up_process(task);
> 
> So wake_up_process(task) is not safe, task can exit after a spurious
> wakeup if it sees ->task == NULL.
> 
> And perhaps a short comment above "curr->task = NULL;" makes sense?

Yep.

> The reason for guard(rcu) is not obvious at all.

Ok, will change.

