Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CF19C982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 15:01:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D239A6B0093; Fri, 18 Sep 2026 11:01:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CACEC6B0095; Fri, 18 Sep 2026 11:01:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4D7B6B0096; Fri, 18 Sep 2026 11:01:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9378C6B0093
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 11:01:03 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 07A221406BB
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 15:01:03 +0000 (UTC)
X-FDA: 85227195606.21.BB9C1A3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4DE6114000A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 15:01:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h3tj+2SR;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789743661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m0lbIXYPWHNxCUA+ixIepaYl5/92+XFxrovY+YXT0Oc=;
	b=hnNlavflCHVPQFvKHUWffjZoXyXBYiQ1F7/vetTvewgjU1MzxNonq2d7uHsArmH5OTOCff
	X7RcK+mk+Hjwwidqwv/kZFB9X/fOmbk2GtyHoGeYP0EDAtSv5LmPMZCgq64Fbx4SAVis3o
	YuqWCpMNds4ylP33TaXWSdHmuf0nUaE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789743661;
	b=LQeCWY8YYiSrNPJcufmsbg4cNDOCmtdkf0ky5V8crEGIDhER8KbGrFXQdm/R6OjKCoStzu
	VuQ6KTQEzXQ4i5h78/FYqpoPQmq9nzvlN0bsRaP8USwTtWSwABqKHUS5pbGxksPlvWjYvU
	9ImVORSWwiBPKfnw/xilmGHW9u601Xk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h3tj+2SR;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9FB1C601EF;
	Fri, 18 Sep 2026 15:01:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E77A1F000FF;
	Fri, 18 Sep 2026 15:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789743660;
	bh=m0lbIXYPWHNxCUA+ixIepaYl5/92+XFxrovY+YXT0Oc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=h3tj+2SRLdyyyh8u6EmUdZLxGnTCejPhtW7liS54uyDqfHII8uZGPJSjRKYeJknSC
	 VcNwzzno0SonxatCkgMXDqtQ1GFAQEcHr6e5okErY/GhfEbhJZA+JVa0nf671uAmth
	 3KmGDUSKIDQN6TFK6rx5Z7uBikGnd4JWH9oYOVdHNIEJLfjqCG/mByc8vHg/Cgv9mV
	 d7D80DVQzaNDziO+TBHvSre0qgy1ldT2XNELzipdrmjj0qAAhSzKVTJqT0T2agG4N7
	 v745yVxJlJVC7B/4Uj7vPZ3BntThlPrIkclP8BybCFg5P1sm4G0wOPjtHgsx5nuePv
	 TIwGlDUdXinbA==
Date: Fri, 18 Sep 2026 17:00:50 +0200
From: Christian Brauner <brauner@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, NeilBrown <neil@brown.name>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org, 
	io-uring@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/7] fork: refuse new threads while a coredump or an
 exec is in progress
Message-ID: <20260918-oliven-lebst-wohltat-c633868711f1@brauner>
References: <20260917-work-coredump-fixes-v2-0-f3787fcda051@kernel.org>
 <20260917-work-coredump-fixes-v2-1-f3787fcda051@kernel.org>
 <aq0VLTyxNatFmLOK@redhat.com>
 <20260918-irrsinn-pickt-vermummen-d7167c397398@brauner>
 <20260918-disput-maden-parkdeck-2bc22dd90398@brauner>
 <aq0_lvHDViIpX_Mu@redhat.com>
 <20260918-elstern-potenzieren-marotten-71ebd0744753@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260918-elstern-potenzieren-marotten-71ebd0744753@brauner>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4DE6114000A
X-Stat-Signature: b7d3xmnbhe6qmihqkk38ytthe9ixhici
X-Rspam-User: 
X-HE-Tag: 1789743661-519245
X-HE-Meta: U2FsdGVkX1+j3xXLhoOUP+NVApUsxvB5NO3bJxI0QTsXIH/7F/3DbFQHSupN9l8H/D4LGqQ+7F+249M15LvJu+S2qmJsPIBQR2Bk4NS9RONW90RBqnEtBWCaeK4XxaC33mqoZwN8ZmBRHR5oCC4Ntcar5pv0grEyRPipvW1Fasq/zP4PKIIOvDHYi035THvL4CdiwKHmQFbJJf1yPSVa/1RW4Gs4t/sn7zl9OudGeSKJrSl86na3sqMOBZHVdWB792AJRPeCFylPFC+E8DdXEgRleDl47uK0UtAR6uGksn2pP9un6m7r5k2SgMCKKaBZCyrtW33ZvWHXJxgemfCCKPK3ng1i0msITkBPF39Uosc0PRo0c55geBWY7DY5lnCQJxtTgOc3awasqiUllI0eJHu/Zuy+miJfXFs1t+ANNZEn5Q9mELg1nPaCY9xCyvuv+zBd17ANHJ4LA3uRNLV673PD1HBF0MXf6/VukvbAgavNUKb8VNX7wvV7DZQ0Ocy8lO5l47Gwb9cBoA4rQIkP0VxTy1tPRRCT4/c1kT8oofKngC0bBspbgvSfKPPvZVVwL1UR7mmrnd3bbDiIBZgx2rGN3eh9m5svWu4rwupDYAZQfacLiZLOg0iZgxX2p+J3ukQwH8YkX3B/++EBKJh4J745pk5v//EEl8G+RK07i99ogkhQ7yuW9LBCoqhR8x2sn74jida5Qo4H5qSuYtNoqFdmmXZ0P+DfwOBcek6Eb2yxihZ/3PG/jxEFO2ydXAjxOQIWKAqrpSFegHSllxhW/X9NM1uOaPVlYeobgSagCVXy9V85UiQSLjsUzkyZ1i9Xf6Y0wnqsMa8CjhqAGo8AYROjKKNPxNqOgAT23xhWAMmpesHKUt5cRcxmuKO1ANBRNdwxAtH8HP7+lcV2lp6b3sLbvPU6doZTSE68tkWsq7vfA6II6tY6/EjCQ67dY1dKuaYJZ88wVr8cLgdlGb2
 C/WUSBVk
 QdiCHv9P+xFbtlMKCaftfns9t+h38OAu9vUeSH1gv79dRqJusFC93TzcTeuxPhtAI6LclcDd759BL1KxUPjwzH1NGijGfO2fvPHGEb/sClluZ3cOLqzBu80mWgDeqor9c+xT59KOMpmAh7g0aQ1y96ZFzGLMtARo00orKv5WtUPZ3B2vq7Vzim8p9GMihPJInscyQjIz8aChNnb5i0d0G0qfPCjA4+A2gp3HGnWKHoBz5AtoUqbgrijVBSc0akJzfwI9sUHKbP2KUuH64k8UAbfqWaLCFZOzT2+6gCLnm83eILFs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 04:29:41PM +0200, Christian Brauner wrote:
> On Fri, Sep 18, 2026 at 03:41:42PM +0200, Oleg Nesterov wrote:
> > On 09/18, Christian Brauner wrote:
> > >
> > > I think this works but they also need to check ->in_execve as the
> > > exec'ing thread is obviously never signaled:
> > >
> > > @@ -2709,6 +2707,10 @@ struct task_struct *create_io_thread(int (*fn)(void *), void *arg, int node)
> > >                 .user_worker    = 1,
> > >         };
> > >
> > > +       /* A creator past its fatal signal or in execve gets no thread. */
> > > +       if ((current->flags & PF_SIGNALED) || current->in_execve)
> > > +               return ERR_PTR(-EINTR);
> > 
> > Ah, I forgot to mention...
> > 
> > Can we shift io_uring_task_cancel() up, after setting bprm->point_of_no_return
> > but before de_thread() ?
> > 
> > I know nothing about io_uring, not sure this would be enough...
> 
> From my reading of this code it works.
> The cancel runs task work and any create_worker_cb() queued before the
> exec can still create an io-wq worker. If that happens before
> de_thread(), that worker just becomes a sibling that de_thread() kills
> and waits for. After the cancel nothing new can be queued.

Right, one more thing to think about with this...

zap_process() skips every thread that has PF_POSTCOREDUMP set.
do_exit() sets PF_POSTCOREDUMP in synchronize_group_exit() and calls
io_uring_files_cancel() right after that.

That runs task work, create_worker_cb() runs and creates a new io-wq
worker. If a thread started a coredump rgith before that worker gets
created from a thread with PF_POSTCOREDUMP set which zap_processes()
doesn't see. So two ways of fixing this:

(1) mask off PF_POSTCOREDUMP in copy_process() -> probably the wrong
    place
(2) key on PF_SIGNALED | PF_POSTCOREDUMP

I think (2) is probably correct:

diff --git a/kernel/fork.c b/kernel/fork.c
index a28fd3976cc0..94a652d933c8 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2707,8 +2707,8 @@ struct task_struct *create_io_thread(int (*fn)(void *), void *arg, int node)
                .user_worker    = 1,
        };

-       /* A creator past its fatal signal gets no thread. */
-       if (current->flags & PF_SIGNALED)
+       /* A creator past its fatal signal or its coredump point gets no thread. */
+       if (current->flags & (PF_SIGNALED | PF_POSTCOREDUMP))
                return ERR_PTR(-EINTR);

        return copy_process(NULL, 0, node, &args);

Better ideas?

