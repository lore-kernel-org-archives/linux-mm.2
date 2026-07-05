Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DF5AC43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 07:51:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2537A6B00A1; Sun,  5 Jul 2026 03:51:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2043E6B00A2; Sun,  5 Jul 2026 03:51:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11A006B00A4; Sun,  5 Jul 2026 03:51:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DEE106B00A1
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 03:51:28 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 66F21406B9
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 07:51:28 +0000 (UTC)
X-FDA: 84953953056.10.BF2A6BB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id B40D240003
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 07:51:26 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1r3H7rex;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783237886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JmDzrGAApB3p232sFjl+IuA3F1DiyD0h9KZAveodTsk=;
	b=oP7KMO5uUsqggIa4MbRn6wwJmHhY2LrH2ekkk0KDPMcjDmB9ojIWi1Q3DWz9loHMu4pY2r
	/M7rudtUZvUJPW9LF2nMMvY1/reUXm+Tod8Lda1/+xT75zz8vQkrg9q2P8HLk+hT7xRqyb
	1E+fXfyhxHre3jKgMQtFbIoq+6dKOwE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1r3H7rex;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783237886;
	b=ntc4TOq63Q/1fLmTny0CLJlipx+TQcZaM5Coqv7T+JsLT2QgoCNlmS01DZcT2o2+ltA0tz
	LYrJlDoGlAEQw732RWrlmgaMhwAE5jJa3+IiPOF6GWzcifbRNnoxBtRA1uIUHM5dArRkXW
	BnF24QBhyKKEx3ep+ehXmzOJd4irst8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8E22341E93;
	Sun,  5 Jul 2026 07:51:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C02A1F000E9;
	Sun,  5 Jul 2026 07:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783237885;
	bh=JmDzrGAApB3p232sFjl+IuA3F1DiyD0h9KZAveodTsk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=1r3H7rexoiQDRjGFt+Qjs33P1gVqh+LD73TOTn/BTY0t13tL4G1XibQWtwbBNLJiy
	 /AbaYonfCEjLrKKi9OkCqN7wL49L3MbO1BuGftrDMhCvBcwuagImS8gD8y1Sf6ehPP
	 UGSpFne62asm/Cvv+3d9/HGQrxu5PpvI24+a2L/o=
Date: Sun, 5 Jul 2026 00:51:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, "David Hildenbrand (Arm)"
 <david@kernel.org>, Linus Torvalds <torvalds@linuxfoundation.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner
 <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Oleg Nesterov
 <oleg@redhat.com>, Peter Xu <peterx@redhat.com>, vova tokarev
 <vladimirelitokarev@gmail.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH] userfaultfd: prevent registration of special VMAs
Message-Id: <20260705005124.307e2379ab03109e5f77bd1c@linux-foundation.org>
In-Reply-To: <ake7PLwdHUHu4idi@lucifer>
References: <5a993689-f730-406d-8515-8bb6025cc851@kernel.org>
	<ajOtfdGgFQYL-T6f@kernel.org>
	<ajOvwGs5xhnfBu-k@kernel.org>
	<41ef0dce-e973-4947-b5e3-150fdb07f1a6@kernel.org>
	<ajO4sLq2UBciSgOn@kernel.org>
	<dd2ae577-9b7d-4e40-81d0-fa9fcd7e0767@kernel.org>
	<ajO7yI541hphWRb8@kernel.org>
	<11bae87d-73e6-4946-a41f-c5542fb40b75@kernel.org>
	<akeJdxdZXAFb8XCr@lucifer>
	<ake3JZJPYHP-0N7n@kernel.org>
	<ake7PLwdHUHu4idi@lucifer>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B40D240003
X-Stat-Signature: q73nmepk8on54iq8w93uhwbo5cjkxp8k
X-HE-Tag: 1783237886-701015
X-HE-Meta: U2FsdGVkX1/73xN18jXSKnWbIAO+c3yOEirmwoFloioH9KwBZCSbmdDlGGGEu/cyn83StsXCpOFNvHmaxOgDVu3Fs5lxKzXuJnvANw67oHbXoOpUPMcEgerhcIa2M/E06rtqa+oUeS8HUTCY0GeMhgubIV5IWZAcm1e7dU/L2nkFvaMkelTq70cJ4cWTWJqwXUw47Wx2It9mVxWBsXvH+ILqsLBnF1Gq2gmYdwXhsHOAzcAE6fIjzEbl6Qwn6PkmtgAIl5RM7vNoRIVyUTyQOglTFFgUP+F96xmHT+EgEPnb/V09vVVD9Lp7zGcCWCi24o/mgg4B8nOj0oF7vLtbkWQYMAhXJQykl0hW/wnEnsB9piZSLVlHi3tF0zfjvWawbGhPtjm9/us3zndQURLdaitj7dCRl8gLVjuThSCyNMBHD/CHKVqRDe54hTAWOPe2oBuac0CPLMequlMe9uIgWgnU4AAohjT9sWS1cTYb+l2ZQD44gYC4TPdXNqom9o+sA5SY4d0zntCdQNdvVdt4Eh+g3uPUKOQVzxaYyvg6kA8uJGsyfdnvI2HPwyqnFGhbYatQGqZCJQF3/8Ej1Is1C911wWWOBOOB6MgsSgGoJqlhnaAHKQoPwvARIuhF+X21HuAHW79Fv67vqZI7/XtS6aDcSwyqgva+z3A751TVmTOOZnigImyu0f+0rUU3Miua+xWAbn9TaBBr+h/BQDh0A6GP3aLLGvai3l2V+xGRPHqR1kjxW7G2DCxXpT/s174c29hFgVCRKEIZ8PRO2gLRXFJWQxL/mDxhrYUIJrfRRAITg6nxcF/7p/3cx7XJ88QGzHVNYPnJE4d7eJiUQQo3gy0rkbFTP3FlvUWiNpEPSrOwWZDAtZEcuE9/OpMiloaZXsUXgzvInNMGw6dJG6Dn56r9UIDzlKbZxkJK8PKxoEJ4u3XBIZlhdImcbLFpN7rHOKocRijtpkGovMc2SDe
 77eSgYrE
 u06nFG4IUIu7+iv3yutSIU1v87IzvDbhSWHADRNjnay0pawB4ubp7wvGv8qVTMlYSRsB4jADp/X3HZnxWMmORVt0I/SMcjYqRPtLZTGDiABFzRTncqaAzJqHuPznNFbbgJxszXxLXONdtI/oMeHSqyCRvLMUBW7IGMW3EtGtXpCBm2ETjf+QxLCjsivT08mMWLbyAztiUbd4ePqSAeHlqjDkgYRUDyM+gIzezsg/vAi18mZCVtFxwYRSlKx2eCkVfMI5gBkG2o8JTJ5H8Ygq70upn0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 3 Jul 2026 14:38:56 +0100 Lorenzo Stoakes <ljs@kernel.org> wrote:

> On Fri, Jul 03, 2026 at 04:20:37PM +0300, Mike Rapoport wrote:
> > On Fri, Jul 03, 2026 at 11:11:14AM +0100, Lorenzo Stoakes wrote:
> > > On Thu, Jun 18, 2026 at 11:37:10AM +0200, David Hildenbrand (Arm) wrote:
> > > > > In a way that's an extra check for hugetlb, but it will work.
> > > >
> > > > My point would be that we exclude all special VMAs, except hugetlb (which is
> > > > special but supported ... in its special way).
> > >
> > > Mike - you said you were respinning, it'd help my series if you respan the above
> > > quickly so I could base my change on that :).
> >
> > I sent it already:
> >
> > https://lore.kernel.org/all/20260618095017.2553004-1-rppt@kernel.org
> >
> > and Andrew apparently ook it:
> >
> > https://lore.kernel.org/all/20260618183442.BBCD71F000E9@smtp.kernel.org
> 
> It's not anywhere :)
> 
> Andrew - did you take that thread as signal this should not go in?
> 
> It should definitely go in. I will clean up the mess discussed there separately.

Thanks, yes, I added it then hid it when Linus objected.  I'll unhide
it now.

