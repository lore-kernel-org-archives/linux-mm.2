Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38FF7606A322
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 16:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=y+pfeUEd
Received: by kanga.kvack.org (Postfix)
	id 4D9296B060E; Thu, 29 Oct 2026 12:38:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 461D26B060F; Thu, 29 Oct 2026 12:38:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3508A6B0610; Thu, 29 Oct 2026 12:38:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 11AE16B060E
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:38:10 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8BEA28045F
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:38:09 +0000 (UTC)
X-FDA: 85376221098.10.14FD2BB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id C84CDC0003
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:38:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=y+pfeUEd;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793291887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gLPlt//hCaW3yl8CTKlsKCz4bE7ch+tF1xtuAXdIMsY=;
	b=UsNMv17arvJbf81qMOG5woIqaLSBBKdQjB9ogZh/FEmqR5apr3RC8KsrnufERcjqvrUaFu
	PThP9uq/EUCDaBECVnwoj995WzrrHU8DKX3/Xw1g5p5QNE+hR+KvcOfdL4alktHj3OK/pI
	lU26Q5MFbLjIqFMDIJmjU/1mjdYc9C4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793291887;
	b=kR+pmgURlzC/kbmSW9GHBcS57MPxr5kl1Jx/NGEw3vk4MtrOTzYym/zGWq/q79XsqI3mXA
	hsDWq5dWumJpYB1i8VLJ28Gq05Qid6zm4cH/HQ7mzGMQOJXHxLRSWb8wLNLSX4/S8Url/R
	3HgyN3Qau/n2nFcXZzceuhmRIWXsU/c=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=y+pfeUEd;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CBA77600C8;
	Thu, 29 Oct 2026 16:38:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CB671F01816;
	Thu, 29 Oct 2026 16:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793291886;
	bh=gLPlt//hCaW3yl8CTKlsKCz4bE7ch+tF1xtuAXdIMsY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=y+pfeUEdaNV+XdUGp1gYPf9LxEHpgLNdfdVuNmRlmCWYxa5QMqnA+ICugsf4lTNAo
	 2x2inJQsV93EwWtspyS4aE84d97kcM19sG2BGI4UdxVULEVcO6eznk3IsMWNRyoQFA
	 sKFiUVuGr5KZ/QssEkxtGolJvaHLFWP6Km5N6PYo=
Date: Thu, 29 Oct 2026 09:38:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mani Tofigh <mt4022@columbia.edu>
Cc: Oleg Nesterov <oleg@redhat.com>, Christian Brauner <brauner@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, tz2294@columbia.edu
Subject: Re: [PATCH] exit: use READ_ONCE() to read mm->owner
Message-Id: <20261029093805.67d5eb70116fe0e9823997fd@linux-foundation.org>
In-Reply-To: <5537eacc-0884-4b05-9634-16dff0eef69b@columbia.edu>
References: <20261027-kcsan-exit-v1-1-7c0429a29bc0@columbia.edu>
	<20261028235404.2a24aa50c06556eaf77a033b@linux-foundation.org>
	<5537eacc-0884-4b05-9634-16dff0eef69b@columbia.edu>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C84CDC0003
X-Stat-Signature: ood9sg6u5apbec8gi8uatubcp1u4y4yh
X-Rspam-User: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793291887-174684
X-HE-Meta: U2FsdGVkX18J8R9Qjzg2rfquCtADgN+sI3Xm6n0Y16sGGBzAcgoIQpEu3EJlY05Vs8zYBvKPk9HhWKVF0Z/z6rtiQ47beo6BqVfbm9nk1KXu+PFEkcHMrua+cblvdNUM2OordBSYOo/L5YhFbmC80sLd74fwLMG/8ZpSQAAyP1latnQmdBq+MpDbwL2hu0IPySrpaUkVlGIZB8ZR0LMAYdXbwVqoIaEPKXxzEGWhf+KyFy/g6DRdxOakOwaKHX7pxqXhmGreF2Vl2OJ1osU+JTTRetLc/sc0PpMpo17hp4rpzZ2lQ34J2y/Iuz0Kk1AaR5axYta6sy/YgsKNpdmL/+fk2YPfsq6DRmUz0sYvv5LRIAhfY0cqImF5r7jzF1vOL79DIvZ0tIA4PvA10WPTg4uQuoFc7CztKlcf0SPxMfNo/AOpNyGM6i4NyR6sWYtMxI2Qej7runpmhSTnGUJl7bOp40wIr8Bpf1Vv7oVQ/r5xqj7Loa6KKs+rRaYHyuR659qQbaLFTjBMlzl9hweoFEchF1B/eq/zZhqzO+8KOMosxUdSjf5B5e5F7fuUfE4wJw0PzyBezjBAgYkFdS2h26tfpkTHNcDEBJLdji3Z4wJHAz/L3QgOwN+/SxWC+HDcC7lDslrtTkGvhxFIh9z1GIlVwnS+hC92xrH/10oTRz9PkddpMGLqRABA/emXrcseB+9iliyNd0iEAP4lFMIAgm/BQgDZMq5jLQ54JQLVJW0ibzGQLKTBdgFl/RC5A+jLpK9sLdAUX7yYe8pZEfaXidsrMvRrJEP/WbL4tctMnaUHNM5nk9s7GblxhNzOUgZxpTep4f/nLWdajzvgqQ7I0p8YLGHXNyoPJyty2J7DWB1rda/VhzQM0z+vnsZ04RoUnkGOAm40CUUTiMRCcomy1GQgdrwT24pveahB5eHjDd3P2gah19Kd87UXTQHuQ7+Fxpgpgx3gfLWG2wnBgyE
 GqGSkT3q
 2LU67OmTLD/NIhfiXE1VLPuPJlFyd99JnWiRjQrblli0az8O9u6342uOZcNU6tXqm80IA75dszxFwyYsMiJVA7rh5m6AI7y21D34M1sxAaXVmPPtBcE9nhc5ZHlUM7pDfuMw/vs0id9aU2ThOHEsMryfHQzeElFrvzfWfgs8aC2GijYwG8hoi/u+yrYcR6AuYe9Uwz1W3ozHEoInSfk+ZHCNtepszL+JqxT+7hQ/dKmHWHRfEsQKHo4fmmsxDGg0ZkxcKbPVzVmay3dQezesrQ6i/myjA22XuBiE/JKk93UTsU7K2CkLlmdQ1IrhSydp2x+xG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 29 Oct 2026 11:05:02 -0400 Mani Tofigh <mt4022@columbia.edu> wrote:

> 
> 
> On 10/29/26 2:54 AM, Andrew Morton wrote:
> > We don't want older kernels doing this either, so I suggest
> > 
> > Fixes: cf475ad28ac3 ("cgroups: add an owner to the mm_struct")
> > Cc: <stable$vger.kernel.org>
> 
> Sounds good to me, thanks. Should I send a v2 with these tags or will
> you add them when you apply it?
> 

That's OK - we gather up the patch metadata as a part of the merging
process.

I'm assuming that Christian will be handling this patch.

