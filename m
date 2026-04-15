Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFADBF9D0FB
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 00:27:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 398CD6B0092; Tue, 14 Apr 2026 20:27:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 349626B0093; Tue, 14 Apr 2026 20:27:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25F5B6B0095; Tue, 14 Apr 2026 20:27:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1723C6B0092
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 20:27:06 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 97D8B5835A
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 00:27:05 +0000 (UTC)
X-FDA: 84658900410.27.9D3C5A6
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf07.hostedemail.com (Postfix) with ESMTP id C1C3840016
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 00:27:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=fBKTEjFj;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.175 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776212823; a=rsa-sha256;
	cv=none;
	b=1ixbkQWIytTGZMWtKIAPGs6o8hpKe+Q6ExCThv2yLFyuvN0luLj5MTjMxSOJgeAOwtIb4W
	n6Qgq4zFlG0Jnnu4TZvolgTLcRueYGUUtw8+C293IG+okJynRrgurueo7u95qjMMkicU/I
	Oq8yZ13eh8FPbAhGMs3EhmCKKRgR9aw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=fBKTEjFj;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.175 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776212823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kDpGBnaT3lT3hUJ3gOq0kFT1XqTcnbKHudND+6nYB6c=;
	b=Ezfmmg53k8iig3UCiBR6k5UQ+RggVNoGfQeqbkse0JoGJWeESukJTW2fSoW4ENGcoi1gUC
	i+pOugGY+OvKouTjAJaId0PnxHRCKFJWAhryB8VSLmfYwHk66sEVgW1OjSLvNxOdwjfmW4
	Ms+07k1e9Q51W5IxNDF3TLvniIy4t5E=
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-8cd71fb9f06so386891685a.2
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 17:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1776212823; x=1776817623; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kDpGBnaT3lT3hUJ3gOq0kFT1XqTcnbKHudND+6nYB6c=;
        b=fBKTEjFjxlSqn1vX2fmLaD7s8GZxFew1dfp10/sPBdDEbbhjDMXUPygI+5kPmuTIX6
         52EIrVdH3QOcKaLpsmiwc20wep7qyFgf1P+kGXKtlLXhVIrv0Xy45SVAILw3no2y9Y3I
         q7CdtE2Cqbo5OP/CcMbkTAp5S8AR44X3a9ykPdtHo3jRJ5yUgkhzY+XdzKvkEV9BbTSq
         /kfYxnzTinZLHDoYWzC+qcD8mmvsXNSokkt4/DiGX9L9Ek7vploE4tvI7G0hn0bO6emg
         Ae1JKnA27dWF6nWCvS267bZggFuNwO1F2jxq7wODkLzX4KPt1mYjHhcr7AUNVkiSc4pb
         IxiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776212823; x=1776817623;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kDpGBnaT3lT3hUJ3gOq0kFT1XqTcnbKHudND+6nYB6c=;
        b=DrmUaJpkFZiRBSpgj8ULJb+rjYo3W2aX9n7+xk2D22DxLq5dMzTx49bVH5O1p6RGZV
         CCL5ONtNe2tmoeNmP5VEbbxNb1F5elQKf57YCYl9GjwtZ2C4iwcxx9vraJChpJzD3obH
         CiwnaIPtRGINugbhuOG/dez8ZvDagMhS7VU6IKHsA6NxXv4oyu5zwrg1jkfFfoBqvzC9
         Zw/izty3J/6VN6BReF23PyQaFoCRgVwlW/5ITrE0Fm7BKSA8oO2f++WUUyjV4FuJ+QoQ
         cHKZlsmV65M7IO6TrDEpOcOfdlJoDQY5SvqXQcLz4tobEoKq1EU4r/Rrh46MNSWthrUz
         t1pA==
X-Forwarded-Encrypted: i=1; AFNElJ9cJilYMVCFaBheK88zd5Kv5+nJewdZOYxTUxS7o+HwttBhQcx6TNfxQko2i+tTP4iQ3jc3gnMIyA==@kvack.org
X-Gm-Message-State: AOJu0YwhRP3MwE2IPFysCdtmFiOmtqrk6UBT04Mp3ka6cEPk/WMuNDdb
	5KkH35wFcI7L0hdlcjVH/kJgOuXV47dJ//hQvM5WMmdAfIARhjDIaix3nbRZXdphLm4yZXLBKqA
	lIA1G
X-Gm-Gg: AeBDietvooi6v5UmoKlw1to30uKFHmVeap11VotlLltZeCrc0A8PoBt/uh7WZR/eQz7
	dggf2bZvB1r9cRlTBARLDL+mGbVDHOQNdlk7n1DHCVvnseUAIMQClqf/Rvw4A13ldUbvtFFOrcF
	HqMbb7uA9r9PXev2H0//PtrYPkxCqnEDD0dKLa25hhc4wl1UkDi09DqS64gDwOVsaKNyFs5+RiH
	X7f3JMZaafPGnwJJA6HDorOnZsJSa2OppyQIXo+3Kim2QRsWbmYeDIhI3ilAPKlDaieGlLNf6KS
	FJvNgyENzzoLU+ofDBJrrzSYWqwylivPghHJ3Z25jMqFCp5b9fzebfQIXWSlGnQpdEYyLDCKJKO
	/JhMwE8UytEgA0K9bOL9swss4EPVx3V4JK2EQhIrglkgCwgVaFk5SBgrRt14x/+bWFigmTuybo0
	d6hm1cLB4fDeV0MUwMoPmwV7VzWnzYnrw7bg5Y+bq/FtbthzSJAgJz6QbXRxNSO45TEZX8m+Hkv
	u+23yD5V3CJFg2Wvyz+Tno=
X-Received: by 2002:a05:620a:4411:b0:8d6:bd01:a684 with SMTP id af79cd13be357-8ddcd6f8560mr2828658085a.7.1776212822595;
        Tue, 14 Apr 2026 17:27:02 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-243-150.washdc.fios.verizon.net. [71.191.243.150])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8e4ef33afc7sm7479885a.18.2026.04.14.17.27.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 17:27:01 -0700 (PDT)
Date: Tue, 14 Apr 2026 20:26:59 -0400
From: Gregory Price <gourry@gourry.net>
To: Hannes Reinecke <hare@suse.de>
Cc: Jonathan Cameron <jonathan.cameron@huawei.com>,
	lsf-pc <lsf-pc@lists.linux-foundation.org>,
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [LSF/MM/BPF TOPIC] Strategies for memory deallocation/movement
 for Dynamic Capacity Pooling
Message-ID: <ad7bU9Guk_csFsEG@gourry-fedora-PF4VCD3F>
References: <e06deabf-44ad-4f3f-b817-78506c5e3203@suse.de>
 <20260413164359.00001c86@huawei.com>
 <ad1b4dVCgG27A5AK@gourry-fedora-PF4VCD3F>
 <38952332-dad4-4d17-a9c1-5c25d79f67b4@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38952332-dad4-4d17-a9c1-5c25d79f67b4@suse.de>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C1C3840016
X-Stat-Signature: ygq88h863d3yon8qqsnu1hgbfd1mp54b
X-Rspam-User: 
X-HE-Tag: 1776212823-436823
X-HE-Meta: U2FsdGVkX18g+PbbOLIuIp0zxWOsge+gZe8oMZzoYMJbJfi6m94/eQ9tYYJXW7QyihI4sI5x9Nkl7NYbqEZQJOd/jxa3zRS4AiCIw0/EqcLByuo53CvWnYVAo55oQ3ikln634ouOIdDjeCEhSdQlRxhoY6IaW1ubtKJPe9atBo7bX/frbiCU6YWvH4j3/qCEjCj2fly1RfF6FfRMKODNa0NWALqjRioeFfjq964G0flQtLoIUyP2oLUYHoQKRw5mznoZ3AD++7hN50JEQ1xi3vku6iENSCicLsZn5CfvkUKXY7zzs/vmC57vivJWuRI9wLFEJaPVhhE+JlnS8MdKfyfU2/JlCrygJrkpZVn26R1Dg/LQaWTzwOX3fy33yK7KxpgSOn8zbycffzcZfE0ifMSymizLyRBofUee91R2wVfHcSOQ1DGN66xyWQIxlrchnaPOH1COWJlVhRy1XkQkVL6IzzMDScalYgf68qFWnOlEC06MggscXvby4xPKK6bpC/4fmm3XXe504HEdFMU/xDutsIy1izXumB6ShEyx+8upnZEgdIJqYV/mDGloaGHQ/2iRLvOp4awuaHSb+xBrlN3k8yRxLDkQu+vZMSHLK47rbj3mzvalo+n0+8y+C8n6655RWUN3jDk9drX7NI3IbzqYcmim0JHm1rhJ1L83XNeX7ZIEBPpDXSPRU/wGhxKlI0b6w4WBTfQu8+XGP1TvLCJNt3rAgW5pat0xme53rElyZ++sV1H0UHPCwPnjgr1m93iMlqnfuVUGcl5zvy9+cYuxpzXxeVv0nnQFauwJWXIXEYjtOUIxqyB6DSu/ZKpZwVd7Gr+9nJ/+KnDzMDOJyr0/z9kfM32zMowRcB/IbjxwnJKfcnSm5+Xt3jTISsJyuu7xY/2eIRkfEDi1HRr3nv4782KLZOYmjNDy9+f9FLN2lHU7Vj8/SwXa/IBQkYLs1l7ncgsF28jqSm1d2Ou
 T1q3e8W8
 c4SVO/WJc0mJLxU2o1PVvj0NfLYlgDN5qGmrN/5O3yMFVxmJvaF/hLVgToc+ws6MewGcpquWSwSKlCnL84QZP5WFURYf39XhAdQ1K+/ewh9u/ChmGB5W0GB7z0B8kVQqC/goNW1drAvYF23l0r+uIort2DlXyFOXnTsBYknlp/eZNZojqMko9KEx7Uq9hzGTJHxYVWJHN5GE0C9+tfJDO8y95urbN38rdEXdelsc1RdJ8fwX8cu0mJhxfE2X4Ha29OQJdbO5hm655Oej7ZAv97wEpW+XJUhgjwrWHh4RxikfzLYtQyoQdNnn7ms+mWZNYknWe1wwPj4ChZDM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14, 2026 at 09:08:22AM +0200, Hannes Reinecke wrote:
> On 4/13/26 23:10, Gregory Price wrote:
> > On Mon, Apr 13, 2026 at 04:43:59PM +0100, Jonathan Cameron wrote:
> > > > 
> > > > So quite some things to discuss; however, not sure if this isn't too
> > > > much of an arcane topic which should rather be directed at places like
> > > > LPC. But I'll let the PC decide.
> > > 
> > > Superficially feels a bit arcane, particularly as we are currently
> > > kicking untagged memory into the long grass as there are too many
> > > open questions on how to present it at all (e.g. related to Gregory's
> > > recent work on private nodes).  On recent CXL sync calls the proposal
> > > has been to do tagged memory first and only support allocation of
> > > all memory with a given tag in one go and full release.
> > > 
> > 
> > General consensus after last few months seems to be:
> > 
> > "While technically possible, untagged memory a bad idea for $REASONS"
> > 
> > I do not thing the private node case changes this, if anything it only
> > changes where the capacity ends up.
> > 
> Thing is, there will be things like CXL switches. And with that we'll get
> CXL memory behind the switch, making it possible to reshuffle memory
> 'behind the back' of the application.
> While the situation is similar to the current memory hotplug case
> (and, in fact, the mechanism on the host side will be the same I guess),
> the problem is now that we have a bit more flexibility.
> 
> The reason why one would want to reshuffle memory behind a CXL switch
> is to deallocate memory from one machine to reassign it to another
> machine. But as the request is just for 'memory' (not 'this particular
> CXL card holding _that_ memory'), the admin gets to decide _which_
> of the memory areas assigned to machine A should be moved to machine B.
> But how?
> 
> And that basically is the question: Can we get the admin / orchestration
> a better idea which of the memory blocks should be preferred for
> reassignment?
> I'm sure there are applications which have a pretty flexible memory
> allocation strategy which, with some prodding, they would be happy to
> relinquish. But I'm equally sure there are applications which react
> extremely allergic to memory being pulled of underneath them.
> And then there are 'modern' applications, which also don't like that
> but for them it really doesn't matter as one can simply restart them.
> 
> So it would be cool if we could address this, as then the admin
> /orchastration can make a far better choice which memory area to
> reassign.
> And it might even help in other scenarios (VM ballooning?), too.
> 

I'm a little confused by how you imagine this memory actually gets used.

  1) Are you hotplugging directly into the buddy as a normal NUMA node
     and letting the kernel dole out allocations to anything?
     - i.e.: existing add_memory_driver_managed() interface

  2) Are you trying to plop the entire dynamically added extent into a
     a specific workload?  Something like ioremap/mremap or ZONE_DEVICE
     exposed by a driver's /dev/fd ?

  3) Are you reserving this region specifically for in-kernel/driver
     use but not doled out to random users?

  4) Are you trying to just plop an entire extent into a VM (in which
     case you technically shouldn't even need to hotplug, in theory)?

  5) Are you trying to just decide which memory to release based on how
     much of it is used / hot / cold / etc?

I see lot of "Wondering if..." here based on what a switch COULD do, but
divorced from real use cases, 99.999% of what COULD be done is useless.

There are basically an infinite number of ways we should shuffle this
memory around - the actual question is what's useful?

Some use-case clarity here would be helpful.

~Gregory

