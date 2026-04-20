Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CC68F5A8C5
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 21:47:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C15726B0088; Mon, 20 Apr 2026 17:47:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC6C06B0089; Mon, 20 Apr 2026 17:47:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADCBE6B008A; Mon, 20 Apr 2026 17:47:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9CA356B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 17:47:09 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2DDF0E58B0
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 21:47:09 +0000 (UTC)
X-FDA: 84680270178.25.454352B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 84E8FC0013
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 21:47:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tVoTEZTI;
	spf=pass (imf10.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776721627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FOuTR/KbbtTlvh+xlQlns56orYBQwPCjaTjJ1Kz8q/c=;
	b=UsN6wxjrHZVvyKY7tpR4Nh+HlbUxya6jtFLzEmwNtgHlty/A3PwcDgjXtnXRvqWY7orVyf
	ArT29KORoy/1MqPP1vz6KECP6xFzDPthjPH9xUi9pJDy1USJJEtnEirwT8FNccr98mYL31
	ySAc/rloWJFmNocFm12V5Z+0bbzg+CE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776721627; a=rsa-sha256;
	cv=none;
	b=n1F3HeH89rGD6TPLbqsKdKIY7tBdc/1hUn7CfCshDuV9HR8Zjfqh39MpD4ZuJe7NktvUTn
	x+AcTE0NQeUbU2k/e5rAbS5BcKErlF/Y3sKMXa25D42+RresvRAZDuekx50DBesSwwyy42
	hDjxSsLUxUT/QuoTYfS7oxXyHBKEFEU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tVoTEZTI;
	spf=pass (imf10.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B4BDE6001A;
	Mon, 20 Apr 2026 21:47:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23709C19425;
	Mon, 20 Apr 2026 21:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776721626;
	bh=k7xmzyZCP3cUzoavLHUHjt9yYXdF5Q3aObHP+orasFg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tVoTEZTIXsi3M+dPWmV/s1NPuMSPyF9gklAGL1CM0QIEjfXZnb7VTj0BRjE5DJKhm
	 XWDicYFMzz/WEZmAG0Sd30py43F9pGiXqnWX7RLUKnToIJG8J8PgH2lLDQZBlJf/pW
	 XWlwrzc6RifOjcE6bGVTTe+nUOhRWiPLQctj8fFVGW5E2JIWFb87hQ4SJSSq3V8PXV
	 Lx6aKzhXLisOdHnU2OTLb/6lfWSRPEdequYf7ljUm65wxm805J3hlPDeKx8V6Oaj0U
	 oLOpOiGDxW+xtm5IWcMDzNTqDfcajKauT58TYKi+guXNB7MsPxZKG6k6DcFjUIuldh
	 E8tBkmuk0MevQ==
Date: Mon, 20 Apr 2026 14:47:04 -0700
From: Minchan Kim <minchan@kernel.org>
To: Michal Hocko <mhocko@suse.com>
Cc: Christian Brauner <brauner@kernel.org>, akpm@linux-foundation.org,
	david@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	surenb@google.com, timmurray@google.com
Subject: Re: [RFC 3/3] mm: process_mrelease: introduce
 PROCESS_MRELEASE_REAP_KILL flag
Message-ID: <aeae2Cl4ybcx0fHA@google.com>
References: <20260413223948.556351-1-minchan@kernel.org>
 <20260413223948.556351-4-minchan@kernel.org>
 <20260416-planktont-abwinken-b9499483b939@brauner>
 <aeHTcXfCyCED4WSl@google.com>
 <aeHbf7joGitRz7rB@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeHbf7joGitRz7rB@tiehlicka>
X-Stat-Signature: gfgb18ri1w1f3xis7jcnkptytgemn6fh
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 84E8FC0013
X-Rspam-User: 
X-HE-Tag: 1776721627-995784
X-HE-Meta: U2FsdGVkX1+hAd1d3ebsMHcV95yum320Movev740el47xxFBPRuYMFQLAdktAdswcH94lAGYR0PTUM5CLFcAp6m4rzU6QSQimaiQfiPbYSlbvHM66YW7FvaWzINEt8zCKn6F03ulSmurDemyBEssckAeqeWmxrKsDAd8DjmJ8WhenAgGaUVCdp2KvuREqsiqHbz+gKZ3fNnmHvhV8jMIw8qhCecBr809FUHk5DjRJ1yMTfCY4ZN669t5/rO/e6QttW3bFkhCujUMIgLgUjoQHBOU5/H7rYihdWPQlhKIkYY7LbbBezt6jrAvWztXJCfeGbgcJuIhd9wWjls0GFo6oe0o55r4ryjQfHoF0+1B2LFRSeqDYHlyWulomor4iBbY5idWR/AgnwhVaqjcHdB5Q54jIeuCo4pg2Fu2iXNXsROASbVBg84/gLiD6qQKkIgyVl0xWZXQHwbEUaOcbB287uCR8Zt/HrFRcW1xhV4C//oBQw0JNPR79YR0OzuD93GV0VGG5g531eIGLUdg2VWNYw34zYkOY7UTITQfayVi0xwLlwCiNg+c1y2LzWxwaAyD8t7pbqLf9I9yDD80Ud1rD45vC60DgfD9BvLgEePkFrfAHQVMhHFI4ZPLHv/hh2ikzLEwzG29d8z6fvs6V0vi+JFj/Q1z38Ter669AePnOIO15hpW53mDqNYiqT/V7crFbvedfX0fXQnssvT/j6zHokcBcGHvq99URUSGbcMgFpNZ1VmiFdlh8mBA37E9sV9knCmn5fy9aMoXKYxUqlSphKAiUxqzvu58CK8u4TygdWhBq/ox2VCRD3qQ1va8AzJSX5sPmx+ZMn219l7JWHzOmq++OsOiqCCNajh49wUNa2t2hUeMbIZYgNumHYEMdZS4+KdT1uLg97aP3xArW2kRSoebLpa8uSShEEWOV0pKcYsbE5JIMYevP88DwyTGwLrvpEFtREAdmy/agJ2GZ4O
 HjH37dZQ
 Ws9wXcmEXnE/MHUzrsvWYdn/4zqJKZ557qGzbslaHG/z4/JDgdChPj/8pZNJoflJMQS/Cf9ICyH3d86QBrB/N+C+ZuKLcIbYEo2Hb3qBzVdaR9TkUAfjdPw5eGhOZ+mUdtOhrIi5UIV8ij39nn5MmAqvLdn87Q0dCTfsRyVHwYX+7BmRW/tuLXt03Rf7XV7NHy+aBhEn0c/CqxpTybqIbZFDHGOe+KTGwpKYo1VsCqXA5N7yEYG2o/3xuAA7U6SSWQClmzDJeN/8R6+Cx3V2IlU/r7sFU0g/Og03q7jP27mleFJn+zQVO+BLMzs9DvZiSpmSeGPEGdludl74=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 17, 2026 at 09:04:31AM +0200, Michal Hocko wrote:
> On Thu 16-04-26 23:30:09, Minchan Kim wrote:
> > If I send the SIGKILL first to satisfy the process_mrelease() requirement,
> > we immediately run into the scheduling race condition where the victim can
> > enter the exit path before the reaper can set the flag.
> 
> Why don't you just grab the mm before you send the signal and then continue
> with reaping? You just want to avoid a race where the victim manages to
> process fatal signal, start its exit path and mrelease path losing that
> race so you rely on the exit path, right?

The problem is that process_mrelease() operates on a task obtained from a pidfd.

Once the victim process receives the SIGKILL and enters the exit path (exit_mm),
the kernel sets task->mm to NULL.

Even if we could somehow hold a reference to the mm_struct beforehand,
process_mrelease() would still fail because mm_struct via task returns NULL
after exit_mm() has been called.

Therefore, we cannot simply "grab the mm" before sending the signal and expect
process_mrelease() to work after the victim starts exiting.

