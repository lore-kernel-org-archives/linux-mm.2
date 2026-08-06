Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92A8BC55838
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 06:03:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77E796B0088; Thu,  6 Aug 2026 02:03:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7555A6B008A; Thu,  6 Aug 2026 02:03:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 692E66B0092; Thu,  6 Aug 2026 02:03:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 48A6C6B0088
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 02:03:16 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B8335120635
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 06:03:15 +0000 (UTC)
X-FDA: 85069801950.26.9601B8C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9033540008
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 06:03:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=D16vJWBW;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785996193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oGCrkq796kYfU9i8z2D5ssSg733nYYHqftVQ+MtqR2Y=;
	b=lETG4FW+o7Nh9m17cImUBfCVgjswCVToqiiINNveMxjof8nDJRXpMX37HRSXhvjaGQ1djT
	9oxWW5R0BERx/1bEd9Ea0p2NVHXARH+w4HTP4GpU2RL4CrnSYMEyciAFviLFdPRtnHSmG/
	yJ7WgLL5aF5mkzScMFveYQoGJWp87ys=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=D16vJWBW;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785996193;
	b=Dy2AfTQrVgB4efNVwfxEV8vgP6en2n7tC4u1scNHsx0hslRNnroZuAUt3tH2UI1xZ4kGD2
	Y4Qk6DyHoHdNCRmCnq583y986KsRyTr2gqbCPzAKKl/SD2iXBrEVIjzLg/unyPpgNIl5AM
	ZXt18ISqOqgVdiTw7kRM8VzkvoOrX/c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8A311418FF;
	Thu,  6 Aug 2026 06:03:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A5161F000E9;
	Thu,  6 Aug 2026 06:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785996192;
	bh=oGCrkq796kYfU9i8z2D5ssSg733nYYHqftVQ+MtqR2Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=D16vJWBWVW8aThnqxyo6Vfu1OZyze0N321KKS/eAQqFmPtwnDBb8sAHqnEyfIU/LF
	 Wsc06LydsN93+UIvr2rOLyEb8G4HyLt72u4rz4d5hXlngxJmOoX2OS7he6cCil07pt
	 AtREIgNapeYi0C0YynO2Og4FykbHYox2x+PYAw7U=
Date: Wed, 5 Aug 2026 23:03:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: paulmck@kernel.org
Cc: syzbot <syzbot+d2401aeb74cc84adba04@syzkaller.appspotmail.com>,
 hannes@cmpxchg.org, jackmanb@google.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, mhocko@suse.com, surenb@google.com,
 syzkaller-bugs@googlegroups.com, vbabka@kernel.org, ziy@nvidia.com
Subject: Re: [syzbot] [mm?] INFO: rcu detected stall in khugepaged (3)
Message-Id: <20260805230311.2bbda85fb92abcf12d85194e@linux-foundation.org>
In-Reply-To: <d5771d33-d8f8-4fcf-911b-089e862042e5@paulmck-laptop>
References: <6a727d6c.9511d2ce.1fc5b9.035e.GAE@google.com>
	<20260805122952.6ae38af69a0457779cb44359@linux-foundation.org>
	<d5771d33-d8f8-4fcf-911b-089e862042e5@paulmck-laptop>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9033540008
X-Stat-Signature: xw19n5hcaorjzcw5xcdd6ey6whmyuohm
X-HE-Tag: 1785996193-399721
X-HE-Meta: U2FsdGVkX18JQQwNdK04/bcvTOtQiiBhrj63V3wZd1aGt0+Mus5TMNxHmwjc1M3IKEgryMt1OvBqgqwdjJWkKwEYq2yMlARc/9On5Nsap/QtVN+vlJVIiddUzjtEOnhn91fs6TMtjFtfIJPUoQn2cwPYVcj4Ex5nUOxdM+gvp5g57KgNKX3P5kXYxaRa4nOMJ4FsoCKBAbAa/QlDbjYgGhssJlxpfc4dM0IVEZ1F3HFEBLuJNwpKehUcB1sHMC5yxt6F5XWOKZ9V6GFDGfvPbS6LLq+//KnQVpnNrR0QD4a8JflsI/aKZGU/MFdqwTfC2jGoOoERJozpwwcoL8k5jUdKraLWhY+PV0e1+U1k4PEoEd7sOLkIm7oAwtiqbNgNB1+cMw3GdRsIH9egdPEyP8G4ApOZtua440ZyZb9lIWHLUQLJcPtEXlrHvXYhsVnNwhvJTdZVnIV4RmyhJnh3CDeKIz9qfDGUAcPC/8cMuhPh0ZGIiVf7XuwEdt3p8PWe6rb8bDcAGyVeDHF2ldAvTJTxpftSbBW9FKSJ9W3TsF8QSKGVrpFQIZwN3EiyXkp5LeTUSebHZsFRjXDyaddAv+zXvRfFiXa4ollciv9Fwu1QWAkEwmC7k7yAPekMWcWaCcvrzKcPUoMYVOzobxm9a/mZrqC8duZdZYC0kgFTwvlkUNTUxo2K8uQWXvq4h0rlb4Pi5IDunM1Trad5+wSZ/rKobbH7dLqB0JctG9EfmBq3QeQEjyeop2in3JiEHKnTjyygHs2dyXh9ggBcfh53rNKI86O9GOguZstr9xl+WU2e/1/OW4Uw7pUOP3g2IYCUftcY8gx6q0tjn9MwKd3dYk4jO+fkGuyV//484q8mxD/x7Tp0olSfIt+JICsheTJwTvPJAKp3qJrOG1l8DzyUtRbSdMdPkTOcwzWDFJbwszAIuNzESkwdd+tbTHGav3Hg5Dlk/2Uwonjgv1v1CH/
 nCQ3To47
 A5NYaCFgaoH77oJFJgxDF53BL3FS5DTWcFOHBZa7GsgOxQAe2UbXOt/AAvGY5B0fkYAPkHyPDBAkPHx2Bz0LxKOIBx6CpjnKFpRO9kvS6ca1aSuSetRro++9Up/jbyLtMmIMFqBj1yp25zQt+bPr57ZHK9VVKMf3iJZboz+F3NE6e5CZ5Nwi3ZQRtyTm9TQcKwXEQJdC0wLnnvxZtuGx5izCzVlisirvMBKY9jtzo8UKYu0HJTKkSt5+T6FwgAp27QpZY0wLXIinxF4+cZTjC1+Euqq0qNdDgA2F7CmG0b2aiGNRsovF3678WK3aD6EIqRpQzRJ8fG5tNAnfsVoSrI9TcMwibKjxMggFHnkDn5Ol6/t3nuJmLTdmRyyFGfQnVLE7qWGgqECO/ecCHQHFDOF31+ZHBaykKVBrXm2ogEjXW3ksZZakf2IRPbUXrdWMB9Ww8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 5 Aug 2026 13:28:16 -0700 "Paul E. McKenney" <paulmck@kernel.org> wrote:

> > collapse_scan_file()'s main loop has
> > 
> > 		if (need_resched()) {
> > 			xas_pause(&xas);
> > 			cond_resched_rcu();
> > 		}
> > 
> > but that won't help with the RCU stall detector(?).
> > 
> > I suggest that a suitable fix here would be to add the analogous
> > 
> > 	if (rcu_i_need_to_take_a_break()) {
> > 		rcu_read_unlock();
> > 		rcu_take_a_break())	
> > 		rcu_read_lock();
> > 	}
> > 
> > (iirc rcu_read_unlock() does an rcu run, so rcu_take_a_break() isn't
> > needed here)
> > 
> > Paul, wdyt?
> 
> Let's see...
> 
> The console log says "rcu_preempt detected stalls on CPUs/tasks",
> which means that cond_resched() is a no-op, but it also means that
> the rcu_read_unlock() in cond_resched_rcu() will directly take care of
> informing RCU of the pause.
> 
> But that is clearly not happening.  Why?
> 
> Well, we have this:
> 
> rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-1): P37/1:b..l
> 
> This means that the task whose RCU read-side critical section is blocking
> the current RCU grace period isn't even running, and thus cannot invoke
> cond_resched_rcu(), let alone the rcu_read_unlock() within that function.
> So an RCU CPU stall warning is expected behavior.  Or at least it is not
> in any way ruled out.
> 
> What we need is RCU priority boosting.

Do we?  I'm suggesting we need need_resched_rcu()!

> Except that the .config file
> does not enable this.  Not only is there no CONFIG_RCU_BOOST=y, there
> is also no CONFIG_RCU_EXPERT=y and no CONFIG_PREEMPT_RT=y.  But there
> is CONFIG_RT_MUTEX=y and CONFIG_RCU_EXPERT=y.
> 
> Because we don't have RCU priority boosting, if the load on the system
> is heavy enough to prevent our poor preempted RCU reader (PID 37) from
> running, the grace period cannot end.
> 
> I am not sure why this task is saving its stack, but maybe that is normal
> for this code path?
> 
> My bemusement aside, I recommend running this test either with
> non-preemptible RCU (CONFIG_PREEMPT_LAZY=y these days) or enabling RCU
> priority boosting (CONFIG_RCU_EXPERT=y and CONFIG_RCU_BOOST=y).
> 
> Maybe RCU_BOOST should no longer depend on RCU_EXPERT?  I would of
> course need ot remove the prompt ("Enable RCU priority boosting") to
> avoid annoying Linus.  Maybe as shown below.
> 
> Thoughts?

If I'm understanding correctly, this workload is busted with this
config and the proposed fix is to alter the config?  Well, why are we
permitting that config at all?

Seems to me that a solution to permit this config to work is very
simple.  Something like:

	time_t start;

	rcu_read_lock();
	start = current_time();

	for (lots of work) {
		...
		if (need_resched_rcu(start)) {
			cond_resched_rcu();
			start = current_time();
	}

Where need_resched_rcu() tests to see if we're getting close to hitting
the watchdog timeout.

No?

