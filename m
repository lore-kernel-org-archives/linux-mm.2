Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62E8CFF60C7
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 04:52:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E13C6B008C; Tue, 31 Mar 2026 00:52:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 891EC6B0095; Tue, 31 Mar 2026 00:52:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A7E96B0096; Tue, 31 Mar 2026 00:52:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6C09F6B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 00:52:51 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1C5D713C01C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 04:52:51 +0000 (UTC)
X-FDA: 84605138142.20.8A382EB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5910A40005
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 04:52:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TYXXjUYG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774932769; a=rsa-sha256;
	cv=none;
	b=O44SSpOf0jtCCLw3KtSz9GW8M1pUDnWTZgJeBimgj/OdRjMymK+wDi+biTozp9V5MOa1gb
	32o1PaOsZGKkMoG4jhOSSh3cp9z1m1aVf8QcCWWi3eAQVxUdmaW/XP5CpiFc5C3/ujQ48m
	yAOyH63TIuhD+WsyAEuyrF0z+1+BwpI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TYXXjUYG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774932769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oh6NK8Hex6PkkQSWIKQBEv2ndPT+0ZV4f9VfjjYeiX8=;
	b=vwBK4i9D32qBNA8fiRcr3n3F7g5QuQx2+066ed67pU8TpYFMJ9e1JUz7N9Bv6Ab1JzBoyF
	X7inLdZeUR4fFCvSgaKWabCWgh8ymsxHRTiq6GG6+osJOCd8ZPQF+pvXCV9lHcky4bKMi2
	Gtj+wwmtULt6F+P2U9SWuMto+OfTo48=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4EBEA43687;
	Tue, 31 Mar 2026 04:52:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C421C19423;
	Tue, 31 Mar 2026 04:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774932768;
	bh=W1sV0gG5y7v5xTcQdkLYhQC8LVNXIot5XhAZDvh9WtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TYXXjUYGsygiFeTxc15ZdsIJXlkwr86dYuvCilb0aMIDAh38qnVxfos/7uroLY2PU
	 iWYOMO4QDA3gMPxE2alA8RkBjKU8Oo5jJffsQ9Y8izDZ/UlHADM8T7YHPRBS4AZnfb
	 SEEM7AJFtW9Y76p0FPK9IOtBohiB6NkBjXpEbjCJgymtOtS8vlmQjlkC8RjYA4l+IV
	 Qt0l1kNaXWlfLZrcyVKHs5OrJPe9Dt/ziF+OcBeg8MdY9RRH0U/jj2uOWkpPizFeDM
	 LzzrM+mpWPjqrT8WlBtVvGgCoJgBACt9VQ/vmYFICTi16MmCkuR9me4asjESYAsxDw
	 9BCXgjPOU1KYg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Greg KH <gregkh@linuxfoundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"# 5 . 19 . x" <stable@vger.kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: (sashiko status) [PATCH 0/2] Docs/admin-guide/mm/damon: warn commit_inputs vs other params race
Date: Mon, 30 Mar 2026 21:52:45 -0700
Message-ID: <20260331045245.67438-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260330142205.e7c7d7b47ec15a634f6eebf4@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bxgfe9fse3yo5tacmq8nouez7mcjoq1x
X-Rspamd-Queue-Id: 5910A40005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774932769-98302
X-HE-Meta: U2FsdGVkX18uZNCG1t5ANTFdDWC/NPNwxkK3v/pPJkLtiUxPnkozIk4qKnD5uMShbTzM09I0MFn5oG5EX0YzxhW2h6EmbgUQRqAU6ubE5BxwqsWYPnZ6Gs1G+OVE4jL0L0yQ+Nzzbn52NHNhBBfFY69O9iL0bAMFJAiqVuJHYK4gTPYVWXW74VqW/sg6uGJgZn5DqicDlvoFI/HjKkLRawiLYs9VENMVZ+Y1PVSFNtFZzm7XyhjRU7H5Bw+V+dgaY3BaQWQk/CvvWdi2r9y4NP2oRi4DeAsGXFBsWSbCBsBQndIHQ7f9djlakgbQJmaUfGZzDWuJwpoHw9hUNdjQx6XE/caaCLKdyGT7wE42n+xVbK2D9mDT7XBDg731qkAGxvCGBXzRXU7GaOv4bEeKhVocvm4dA/Rj5Gm8vB/UO7PAyApHkPSXomZYpk6kIvh1A5uk8qRaMDvM/PlK4/X6xp9eu1BytFNLksDqXlP9oiEtDoiToIn9RIp0PD/hUmZw8XA0u7ktNOLuUYR84tmk0nmd6Q0zdzX+XmiK/e/aMnbCxHd7avL8WzESSW045T50JesnEmhabCt5CbV82pLcHsQFDLUILdIDPm+YWMiB6RBFP5MQWftTNoXE8Jg8hAWGeSzUW40SD0KcKPb9rxZZ/ArDHmMFGUUcqDyemGxYN2pHFWPuPgxeSIyeHEH2hjIHQzL4T2VjBBHrccWoGSEC58oRmOS+h9rj/dCcEmT2brixuqp+wn7Hpzp4DShqGJVztwesz0SUSxezSt63U8vH8L4rIfkVObcWuE0OBGc8mcMJG3fR70ExUh7YDr0W+pqzpcLqMkx3otHvH5oEa+j83f9aP5gllsOVH4fcijgdf18cSbneO69v+ePkoAbYqPyFUBIylgJ6HXxjC14xbGgn1+qjxKC62hpCuaA23Ck+jYyNPLsEX0Y1aI8eyjm7B7ujPWOe7tAK5heacz0tW6P
 Azg4JzmU
 k1NOOKnmFiqV9tjYE6qXVA5nYWkqCZyvnARlB2k3MlFwg7XUawNA+HJl1/rU4lqIyjSAv+UbORRgJSsBJIS3swjTTngGn2FS2ICRtf+S023Auwf7vXkii+7JMzv2YTPQ4MOUvjJVMqq4f7K+t9qo46zMAezztriaiksd9SthFhbuX3HyVp/bsR7R3o0OH31kDbyVNc/5OA5VXGxUgX4Rpt7/7SQUyf864VHXjegqHvLyjCM/bfEsoJCal83WE4QqqwQSVKDnCD8SOZWVHt5ufcRF5yCYWXtyZih2U6Kr35/L6HOS6tXIgaDNILNe95QAj49lteRltJbXOcnVgG5NZJauAZHB1S7zHBChJy9EM21Npw/SFHJMk5TLBC1SQFTBY4uR8PaTbSLChH3tQTUyLkHEYTk8mKPadcIrDQlFGbEViTcY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 30 Mar 2026 14:22:05 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sun, 29 Mar 2026 12:32:26 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> > On Sun, 29 Mar 2026 20:05:53 +0200 Greg KH <gregkh@linuxfoundation.org> wrote:
> > 
> > > On Sun, Mar 29, 2026 at 08:49:16AM -0700, SeongJae Park wrote:
> > > > Forwarding sashiko.dev review status for this thread.
> > > > 
> > > > # review url: https://sashiko.dev/#/patchset/20260329153052.46657-1-sj@kernel.org
> > > 
> > > Why are you doing this?  If we want to see the review, can't we just go
> > > and look at the tool itself?
> > 
> > We can.  But it is bit cumbersome to opening web browser and moving my focus to
> > there.  Reading everything on the mailing tool is easier for some people like
> > me.  Like some test bots send reports are replying to patches, or we sometimes
> > forwarding bugzilla reports to mailing lists in a form of a plain text mail.
> > 
> > Secondly, I have to share my opinions about the reviews, as many times AI
> > reviews need human's opinions.  There is no good way to do that on the web ui
> > of the tool (sashiko) for now, and I think this mail based flow is the best.
> 
> I do agree with Greg that it's all a bit excessive.  Thanks for your
> your diligence, but perhaps dial it back a bit?  It's OK - we're all
> trying to figure out how best to utilize this tool.

Thank you for your kind words, Andrew.  I understand and admit the fact that
this looks excessive.

> 
> I view Sashiko as primarily an author tool.  Sometimes I call it
> checkpatch++.

Thank you for sharing your perspective.  This is helpful at what you want from
the use of the tool, thank you.

My view of sashiko was a human reviewer that having very odd characteristic and
cannot answer to my feedback for a reason, but still being useful in many
cases.  Hence I wanted to help the special reviewer be able to communicate with
others on the mailing list.  And I was thinking anyway that's what sashiko will
do, because I saw sending review as mail as one of TODO items for sashiko, from
the public announcement, and I onboarded DAMON for that.

But apparently not everyone is sharing same view.  My understanding of the TODO
item in sashiko public announcement may also be biased.  Maybe being a
subsystem's sole maintainer that looking for a reviewer made such uncautiously
biased perspectives.

> In a better world, author would be able to sort out
> Sashiko issues before ever sending out the patchset.  But in this
> world, a public send is needed to obtain that review.
> 
> So what we're presently seeing is author development activity which is
> unfortunately and inappropriately being conducted on a public list.

Makes sense.  Now I understand why you and Roman were discussing having a
separate mailing list for sharing the reviews via mail as a path forward, and
I agree that could be a good option.

> 
> Personally, I pay only a little attention to author's Sashiko activity.
> Just enough to see whether I should pay more attention.  If author
> says "oops, let me redo" then fine, I'll await the next spin.  If
> author says "that was all nonsense" then fine, time to take a closer
> look.

Makes sense.  I will try to keep sharing necessary information, but for only
targetted audiences, with less traffic.


Thanks,
SJ

