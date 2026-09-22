Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01592C982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 08:28:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECBBC6B00A5; Tue, 22 Sep 2026 04:28:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA3A66B00A6; Tue, 22 Sep 2026 04:28:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB9496B00A7; Tue, 22 Sep 2026 04:28:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BB4A46B00A5
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:28:30 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 367771A0406
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:28:30 +0000 (UTC)
X-FDA: 85240721580.17.9912EFA
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf18.hostedemail.com (Postfix) with ESMTP id BCA2B1C0008
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:28:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=fnkRMEyi;
	spf=pass (imf18.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790065708;
	b=J1nzN6VLJNkXeKdWzJ40GlYOl1jfGqbhz5sdz4KZYXRjKVcF4J2qCoN1yg5OpcwqMsqx32
	blsoPsL7AUrO/DjfqUpGS9agfB+u/EiDQ1LVWDEYORTlySbFx6oxJ5Ta0+tvq//JMgN6hi
	ludJyTK6bjuOspsNdYFHjs+JHiJKZks=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=fnkRMEyi;
	spf=pass (imf18.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790065708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PfubRjl4+hlUE9k++w7dZcQM36qRb14JHyPG4O/PKVA=;
	b=yksIgJPWRqzFF8hIj0hcY3qp2iWdYF4ZiNND6E3EXODwvcEyDSdDXXmnq7AfbayqFBa7qZ
	wskakAUFI6DSBqdc3j3aiY8XAiiREslXEeQsFOq6DO4vP45BI2JBgVeolMzJ4mk5p+ssbw
	f/VjhMEbWvbgwUm//46qRb5smj6BZh4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=PfubRjl4+hlUE9k++w7dZcQM36qRb14JHyPG4O/PKVA=; b=fnkRMEyiFZRlkoIXIkHmeIfAQF
	uH9xp+wfoaRJvqEirWJ3TsgoXJOI3rJglOKEVHmzBt61a5A5FoP43o7Gxxx85Bivx6xU4m1tHAvM8
	00/fJtdacRFl6NMBEaChV0eGI1T/TJXlQXP7NW1Nf+/wEO0WALYUOqoGUbHXU1QJXGljH/iLsqhJA
	OTqZYTIpJ/vGzhLofEV5kMQNCSuGT6QctBp+1Gig1qQTPYPEXyuAceMjaud5SunG+xdslWl4NvdAZ
	hEOR9m8IdmMIbu0YezlYbNHuDge13ClURRR9wehj+c+scya0jTU4tgdXJPBiN51z0Xm+hMfbnA0cK
	clu60l2w==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x8vrL-00000007k9n-2SPX;
	Tue, 22 Sep 2026 08:28:16 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 98F9F300754; Tue, 22 Sep 2026 10:28:14 +0200 (CEST)
Date: Tue, 22 Sep 2026 10:28:14 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Chen, Yu C" <yu.c.chen@intel.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Kees Cook <kees@kernel.org>, Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Qais Yousef <qyousef@layalina.io>,
	Aaron Lu <ziqianlu@bytedance.com>,
	Srikar Dronamraju <srikar@linux.ibm.com>,
	Vineeth Remanan Pillai <vineethr@linux.ibm.com>,
	Ricardo Neri-Calderon <ricardo.neri-calderon@linux.intel.com>,
	Lu Wang <wanglu.priv@gmail.com>, Hyunwoo Kim <imv4bel@gmail.com>,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Zhan Xusheng <zhanxusheng1024@gmail.com>,
	Yi Lai <yi1.lai@intel.com>,
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Zenghui Yu <zenghui.yu@linux.dev>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	Kayra Cizmeci <kayracizmeci@gmail.com>, stable@kernel.org
Subject: Re: [PATCH v2 1/6] sched/cache: Keep nr_pref_llc_running in the
 runnable domain
Message-ID: <20260922082814.GX4121339@noisy.programming.kicks-ass.net>
References: <cover.1790035273.git.tim.c.chen@linux.intel.com>
 <06af61afedac32e6477f57feb4d658f6c411c3af.1790035273.git.tim.c.chen@linux.intel.com>
 <20260922072205.GV4121339@noisy.programming.kicks-ass.net>
 <65ee9df8-2422-4d1a-80d6-41ac51979da1@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65ee9df8-2422-4d1a-80d6-41ac51979da1@intel.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BCA2B1C0008
X-Stat-Signature: zpta3jinmaen58ibpc9kmzruknqpbd95
X-Rspam-User: 
X-HE-Tag: 1790065707-413818
X-HE-Meta: U2FsdGVkX19/UwwNdpmr2ig56RN9TMe3eJ+iw5IunEFCG7mJWEx9S5msc8EV5XNgB05phniqE1m9+iBzfsQ+V1Q3t2n5fTevuBxpXPTNp3pShb6EftjsUP+cpfPdhaGoUkMNNthQ1WzI0ZH4CoezTnUx87aPdYD4sreVHGD8l417uOcHnP+EXthFSfU0pdmEOJI/MEIuA79/KmPOWUyp4NFdBJnXgQcR90MBe9s0FDlMctFZEXgEuMSxWPhUk/4h9vfiWnxolBXHnY+1WsvPlc/5Z29OkazTJ5+jFCH5rejVolYUCWn1dxt3QaHkq514IyeMufdNw83xXP60F9mjRApaaD+Yn0rYDrcmx8l47oyY0iiqT4NMgoA3JNet59oIW+U6bMaPZ0EvynMpRmcjXM3aCu/sHFwRPTxkZBDJRFdISNLkrnkptOkAm9G3xy0X7C/RTCLMocEnKGX4juzBalycEywhdE56VXWortKlFinIKbK9oJoCF6tVfSoFzsZIfK+T0NTqzW6RYhQuC2bm6mOumJU5bvzJO7lIH8yO4vAKJWWXC+Dm9rbxRMsbckTsvGy+/3FDL8B7LZvKnm+nuUSnm1cXQppy4MNtxIUbUSIb97Jz5l395fchGV46IvfG1z58BKPiN1mKm/87avDbc+G8KWuUdcYBgTP37jc4SBmDR/HVjpNE57WhoLcKjqAlpgonr0g3JjKgBhEpJd7CIfXqtWCFrjFTSumgDW0QDWCfO0heWUTMa4KTgKQaIiRWRUuFw8+k0dPoVoaIk9iNtJgg0s5GPI7fZhRBn8UsmYqypnZpOua5BnPRw8c2y9qbXAOS5wzbyvuxdodLHgvvzT1HJQn+OmZwzmVI501ZaRmbtSmFzalhVFyjpA20IRAFnt2Ke5LTNCQKXmYHWZTEiROIorJiMOuD8fpxflN16FORzYlzMIy4X5K6bbW2Y+W4RVVCPNxRNoY0UkaHTYP
 zEfJ//D8
 u4CEpeyFYi/N4Q321o+pCiZQtNSd6odWUwT8anGYb7ZahkOQjqmUu4VLEro3F3L+GdpzXA2AuQBlzmBUJ9hqLiUlvFYOxp1tSiGFzQHl1UcydS1QS/f2mBVLVOFzx+GfyT2mnI5pZC/xEWATNPu7aOritG205daZsI2zN+HIg8j+KqSiXAtUDYkf0mVJVdnHUIjhKnWx/B4NdBobJmlAcXRugmWmPocEIsythXQYg6TceVqFXg/3exMOER9ljyszr35Old+1Cn2+dKya69unmcitLcRtwtFSmTTTCsEDKtAo1ezdSgFYguhR9biwM6/SmKEYTrNjxovqYfxWWhQ2AghEUjVs0q/DBZTiTv+AxiQ3pbzA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 04:25:14PM +0800, Chen, Yu C wrote:
> Hi Peter,
> 
> On 9/22/2026 3:22 PM, Peter Zijlstra wrote:
> > On Mon, Sep 21, 2026 at 05:37:22PM -0700, Tim Chen wrote:
> > > @@ -6395,15 +6429,27 @@ static __always_inline void return_cfs_rq_runtime(struct cfs_rq *cfs_rq);
> > >   static void set_delayed(struct sched_entity *se)
> > >   {
> > > -	se->sched_delayed = 1;
> > > -
> > >   	/*
> > >   	 * Delayed se of cfs_rq have no tasks queued on them.
> > >   	 * Do not adjust h_nr_runnable since __dequeue_task()
> > >   	 * will account it for blocked tasks.
> > > +	 *
> > > +	 * This check can be removed because when flat pick
> > > +	 * patches get merged as only task can get delayed,
> > > +	 * same for clear_delayed().
> > >   	 */
> > > -	if (!entity_is_task(se))
> > > +	if (!entity_is_task(se)) {
> > > +		se->sched_delayed = 1;
> > >   		return;
> > > +	}
> > 
> > This is dead code. In Linus' tree, where this will be applied, this can
> > never happen. A possible backport of this fix however will need to take
> > care.
> > 
> 
> Would you prefer that we create a separate patch to remove entity_is_task()
> for Linus's tree (so that the current patch can be backported, since
> cache-aware
> scheduling was merged before flat task-pickup)?

Nah, I munged it in with a few changes (I removed that cache-sched.c
file) and it seems to build. See queue.git/sched/urgent.

I'll queue up a patch for sched/core that removes some of that -- if I
don't forget and all that.


