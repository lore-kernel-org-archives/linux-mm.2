Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 671F0C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 20:24:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 593CB6B0088; Fri, 18 Sep 2026 16:24:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56B026B00A2; Fri, 18 Sep 2026 16:24:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4815E6B00A3; Fri, 18 Sep 2026 16:24:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 269FC6B0088
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:24:57 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A25DEC0754
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:24:56 +0000 (UTC)
X-FDA: 85228011792.25.6F690EF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id E9AD914000A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:24:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fMj3v6Bs;
	spf=pass (imf26.hostedemail.com: domain of "SRS0=kyR/=HK=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=kyR/=HK=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789763094;
	b=XeElig0+HvK0eVMZWgiPYKC2hEr+MDX4P0LiNiuhACuY8LEW/XXj9cMYLNI/XusIJo1wH+
	ByI4A++AYus+hj+gulVFXqDuAJCu0+HjrUmA9cY2Cqu25ffZYZ3DAXvDTomriUKCxe0ws8
	wgkyqBiUvTkDlZlEGJDzoWV+0tCry9I=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fMj3v6Bs;
	spf=pass (imf26.hostedemail.com: domain of "SRS0=kyR/=HK=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=kyR/=HK=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789763094;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=babmhG3CX0kOyIk0MhmJt1fcAmod/lU85NqbD6hfzmw=;
	b=CgC4Qb00S6z7eqt020GfVz9sZCE/OqgHNFFcq/gsbrLdYDuawfiuGUPv24YyhB1voQsG5P
	NfqPl0oUyoWLu9/VUOnpWmytjnPnIwx7q+IjznstqEzY3KeXOT1y/BJdJ/B5s4ECbJq9Ua
	B99UegpCPlm+yLWBGqPFQ/txKpxih2k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5ADCE602CC;
	Fri, 18 Sep 2026 20:24:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E6C1F00899;
	Fri, 18 Sep 2026 20:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789763094;
	bh=babmhG3CX0kOyIk0MhmJt1fcAmod/lU85NqbD6hfzmw=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To;
	b=fMj3v6BsyPRHwMQyaYa7dqJhrB0LIIXc9+wVmEH9Nyh2d+rxXqXhrA9mWJFHtX2Oa
	 fjNE7R2G250Vrg2BLDuh9n981t4ThUduqFdXwONzqEdNRakcl6hy8FFGCMUVGBdLXJ
	 y8hLr1pFhuPBuZIB4YM06xJZbWQH2XRijwG3BfGMgf/OxSh6l8DJlsbkXAmbkim3bM
	 W9sUuTDt05G1E54xKZ5LsJqv6+1X3Fl/IT7RiKZ2YhrqHH8817hXLauy9NDMRgIQ2K
	 KTx4DZx/sn6Hd2AiYHR0Z/j6aWJOMOMY6kS1Kv6QdIplQVA0i1AP9gumdvIBNe+Bzv
	 SAzDROaU0rcjA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id C4D29CE09DC; Fri, 18 Sep 2026 13:24:53 -0700 (PDT)
Date: Fri, 18 Sep 2026 13:24:53 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Breno Leitao <leitao@debian.org>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/shmem: report RCU-tasks quiescent states while
 undoing a range
Message-ID: <a67e8b91-ebc2-4d3d-b6ea-d221b297fad0@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20260918-shmem-tasks-rcu-v1-1-79acf91a2569@debian.org>
 <20260918123239.8f25b984ca280fcc11ef6e6a@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918123239.8f25b984ca280fcc11ef6e6a@linux-foundation.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E9AD914000A
X-Stat-Signature: 5kqep4k7nrffk41rshjmbrza144hw8b3
X-Rspam-User: 
X-HE-Tag: 1789763094-376084
X-HE-Meta: U2FsdGVkX19u+Q72rdTMUWguyxZLJmfJv/cE7tl6AznmVafwJWrZlmRTZg72KDUapkdV5DUrE5N7gkbidRRjo2XdUIx35UlWFSkPmiwbogtKyt/r0vTv0tAJRSGE1HqEMruFdhJYNSvqhyDQhlqGZcsx/K5hNNpywvumMNvL5J8fpouSQVqfLwdk8uBsFAz5pMj7iTaIeyrhJRdjg4lfafT7aONdD4vBIW8ZJp5aDAe/EEiNwgVrY0ydBPdXjDHxhfRqZA0nbiGQ9ADLl/VSuKktprqJ4EWYtsy/mh7dOTkfAn8oHbeVEvlbSK840yF7dMhd3C8ARXIeCnTmTNNVojSz1ZcwDNih9VCeotKdKs0K+zYs3Z+YkdvTsiNq7omycGOq5giVZEdZfzqytbJPe3B24vgrBRKCnNVu4ADkyd8R+GdenC2i85oBwJB+s8JFQP+Mceamgldvm2CwPuN0DsBRjIC/okA8pKwk1dTnro3tSNWPPPnXXfU5ucj7AXzeecbypb4VMMZ5P98qDeLRHmc0tE8a9k0v2I5hTMTgxPWcEoKi6zbrDnBurYnSfd9N2vcXCiM797mUMe9SiRmlvoFnqEgXpkGfNuEZPrjZDPzoiE8n7iRtSEgzucAh5UlRqeeuxuFHpNePpaPE82aJ1XtnkoNVQPCHcOZpiuvO3NDRsJB6VjonORDVW2wEM640yf3+zgDizYpQZLceDLLMCedpmtsZ+vTudBxAPGpOa7K+za1dh9tVscs6uL/fON1TCxJnBpUExPA2C7Ib/ZoPyctr4gb7b5Rvl9q8e4mZLYdxUOh8pa+7bP3lEm7JCOj8OIliFFIY13lde3NHdds7T9API/LlXQZsBHxAriVlikjIowsjKfX9i44AbMhDSolEY+fJcD+JDLh+WwBHiW++pE0wBCYuNWY/4pHoKttp9sd9iJwKQ69NljR9DNsKYikANNyMIRuR/DDGC07bc0P
 U4uKLgU/
 XLGELZRPu/XoMu1ZDehVDTtv1POy55Tyz73DUtlXizrhE+pOq8SCx0mIrKw0+/aryNzrNUNXhg6VVUBNDFdsHIhYX+qC0+pJMlhZKvqWYcaNcfJc53ZOAxsEN2A5FhWDeWVL/iyUpUO0MKQwtXFUlcS34Y7st1R8DV248KrV9vdYz0NHktu/k884ICnKT1mww06IfOj+aGEMHwpyhYJPujp2gdo6rP8YhG69IAcuOaj62pPA0jIIfk/5zovG9L5nA3CbcJm/l+WSoB576Rj3KvW0TBDGujxGK15IUptoS0zMb5prx/3ql6co8M3VUHuP9E6Z9OUiK4dDObGX7soIvJ30EwmfU9su0WpAA1pP9qcthbR+wRQIbez8RuKDdf89Bc626UW51pnty0B9nFnayGh7Epn83N2f9c83dIPoNwcYd6BhEJF3fGGaX/lQaiy021D4yFHv8hUwrZoRQRleLNDWPFtGhOM11DFE+yts20uJhlLVr+cs6zmznU0nSVZCfy6otJDAU/H2f6SDd2oOCowPCAq3jNQDl0nuz4WqbHI40rmo3mx43YJEBTH5uhym3sGucP4fvOfqsnGL/nqWnp5AEAjAyO+UXUgpiR7fmCUc0PvGm19qHvAVKZIKpOweWcJNKUPx834gsxkwYpiLvIU53N88uujlzyzn628lZBR6/ultSIpgbHhoCRs3CgONFlSWzMLjaF5/bAumLPVDGWlVEmrruIqbuQE+G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 12:32:39PM -0700, Andrew Morton wrote:
> On Fri, 18 Sep 2026 04:24:37 -0700 Breno Leitao <leitao@debian.org> wrote:
> 
> > This shows up in the Meta fleet on ftruncate() of large tmpfs files:
> > 
> >   INFO: rcu_tasks detected stalls on tasks:
> >   00000000752fd185: .. nvcsw: 59455/59455 holdout: 1 idle_cpu: -1/0
> >   task:rocksdb:bottom  state:R  running task
> >     __folio_split
> >     find_get_entry
> >     find_get_entries
> >     truncate_inode_partial_folio
> >     shmem_undo_range
> >     shmem_setattr
> >     notify_change
> >     do_ftruncate
> >     __x64_sys_ftruncate
> >     do_syscall_64
> > 
> > shmem_undo_range() walks the whole of the requested range in folio_batch
> > sized steps, twice, and its two cond_resched() calls are the only
> > reschedule points in that walk.
> > 
> > cond_resched() is not an RCU-tasks quiescent state.  Use
> > cond_resched_tasks_rcu_qs() at both points so the walk reports an
> > RCU-tasks quiescent state as it proceeds.
> 
> We keep hitting this.  Whyohwhy doesn't cond_resched() imply
> cond_resched_tasks_rcu_qs().

*I* don't have an objection to that.  ;-)

> > Fixes: 8315f42295d2 ("rcu: Add call_rcu_tasks()")
> > Cc: stable@vger.kernel.org
> 
> That's 2014.
> 
> > --- a/mm/shmem.c
> > +++ b/mm/shmem.c
> > @@ -1367,7 +1367,7 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
> >  		}
> >  		folio_batch_remove_exceptionals(&fbatch);
> >  		folio_batch_release(&fbatch);
> > -		cond_resched();
> > +		cond_resched_tasks_rcu_qs();
> 
> Won't this change remove the cond_resched() function from old kernels
> which really want it?

The cond_resched_tasks_rcu_qs() macro implies cond_resched():

	#define cond_resched_tasks_rcu_qs() \
	do { \
		rcu_tasks_qs(current, false); \
		cond_resched(); \
	} while (0)

							Thanx, Paul

