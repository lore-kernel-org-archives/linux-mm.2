Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7195F46C69
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 17:39:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2ED86B0120; Mon,  6 Apr 2026 13:38:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDF046B0121; Mon,  6 Apr 2026 13:38:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF5C16B0122; Mon,  6 Apr 2026 13:38:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C96756B0120
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 13:38:59 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8DEC48BC24
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 17:38:59 +0000 (UTC)
X-FDA: 84628841598.19.9067C22
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id A700D20005
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 17:38:57 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=SpvmHrXa;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775497137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PV3kuVo26724tWcQQf08thGuSWeUZ9veuE/NMIQGJRE=;
	b=nqYmiZtpmPpETxf+QnyB/UYYu6nd0M0lQfgZ8dZr/CONH02Yk322UasHmpuS9JD3cs43hh
	yP1GsE1VNZvWlHgDLXz8OXktuzM5RoQ7haTsHKdHrakITBuSCnvdMxf7QxjZLMXxKam0Js
	htfu3TbzvKbNBPQ93dirxpGilAZbT9M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775497137; a=rsa-sha256;
	cv=none;
	b=nkfE5gx1dE1vJDg/fksKkJbltzPQaFOqY/kzUW9RqHx7PhfGafx6Xljnb6L/i7I2jNThFF
	KQO5a+7T+CU64yVaeHHFt3o0+6y9E37AIiHP0bn5ZAj1iB1bJwipyAKkhBG5n0Qrv3RB3S
	sSKVBC5FVViwhpk9tbMNIDDkz6pPLEE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=SpvmHrXa;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 24A9F440EB;
	Mon,  6 Apr 2026 17:38:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 941EBC19421;
	Mon,  6 Apr 2026 17:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775497135;
	bh=AEZp5fDRQAY9KyEO2S76uYsWeMZLHYwUHfXcyppdE+U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=SpvmHrXaWUSIteK9NQmMmAVmsS7wA+YILEzBBFJ66TGzP0474F624CRO7b2RR/LoX
	 ojkRLNVX1047HXicU8yldtMLhQfo/5PcI1WkvKx4llS9UO9YEU/rAu9EqQMXWLi0FI
	 07dHxiYEIxBDPApS1z11jh+x0ZZudoTIMn/l4/N8=
Date: Mon, 6 Apr 2026 10:38:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (arm)" <david@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil
 Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Dev Jain
 <dev.jain@arm.com>, Luke Yang <luyang@redhat.com>, jhladky@redhat.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] mm/mprotect: micro-optimization work
Message-Id: <20260406103854.f48c27d7709beb680268d388@linux-foundation.org>
In-Reply-To: <a3ace37b-b75b-47dd-ad7c-c7c3f799dfdb@kernel.org>
References: <20260402141628.3367596-1-pfalcato@suse.de>
	<20260402113328.fd0a6f0e28cf74a651fa2291@linux-foundation.org>
	<6bl5bzq742c522nmhlshlnf6ho6y6a747l3zh63aagp7kfxymv@s2c6fsuikn4m>
	<a3ace37b-b75b-47dd-ad7c-c7c3f799dfdb@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A700D20005
X-Stat-Signature: bqm8rsy6bnfwosjnecuu7zuwetiwt9sj
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775497137-169904
X-HE-Meta: U2FsdGVkX1/iMqblpOG/fnFuJDhE6LTqgI4hoNlMEWxVPt5JOXHYxdyMQywzCWU3J2yQny/LPXdZmoShxEs0BhRfBy8rzd+8x5HHy8NgRIIG0QYFopR5WKmcYQBRQdavtt2NAO+yh5T54Myr0/VeWhfQAx3A2kyZrBn1npix1lXLgcQgOxCP+XxGE4ic/4ctTVj1Sd8E1nOvgqbyCwgu2smr8oNFR8fK3Do/bu0FDfsE3Fisf5d/oQFqCAAqXl5aRMyeXWxPmXTye9sdoV31pavx9PYRgYCSM2yIhmBjGO1beyEj6L7k8i/zFhjULbAi1WxlE1BTD+3qGRne/IGn+K+VfH9zKpCgWA6C0MgceS3lqM+shynUtgE0Ehpadl+7gKV9ldIiWzRjIHnqsVvOzgms/wmf+C4vasGR5TCbv4s24tanOLP9cFn8qdbIrGmD5Q/S4WeCIhBxWpS/JJPCd4H1wgpTi4hhLmtvV9Jo6J+F8LtzXW1XIn+IhaYzoBPFDwgY6HLBL1nACpg7QZ6gmufbIX3UBhjBWWdkqL6mmrIvcbhnEGhntt23mAo9SmNl0jNqUHMtavpgxOdajDW+S3LDMg7LojsE+ZqyUuTAl21sgBG9SVzf1svgpIVUmSnR6AnDVMWbOGaVLlWxvuBH5FGL0mL8n06NZLYq+5E3z+mJKJN7yxt9505iyB8NCpMMQ8OaEAq/ZlCkQTntFsnnVA3YgVktR2Y/7avwHog4jQChjI0OknqtWLEL+K3d9ZfDna7x8e7sn3iIuwyv0mJAzBLR0wc3YB2LWBnGf8ZTnnZy28r5LzlcRzL9fQZdl3zCiAKObWKUiw2/N+5GWRVAF4/TQv6fRkdRn25k1CmHtX4jWOBdSi+jHLGNQusnEuvlTmEllAqKRIihDMlTi1H2Jd05HsG02pn1LQUeJ0dOiHO1Qusl6EzXe3SfI3rLke4DatSHdh+UPltza+dfNk5
 ejDCAvvv
 lhG5kcKUVUGy2Zsd8c5O/HQEJfOQaDJ0E8P3zwKQw3OKejC81k9PAYqvV85QrfcA+9GMrl2YDmy0uDdI+k7n/wOFchAKMhCl2EQ0Klg4Dy0xHk/Lou0BhOZ6+3pvvBx3UJpYr8OGwK/b6CmMD1vHe8Q62QHWEr706dLRrJrg5Q7FWEcrGOkcWJEwUqVM9CZ2/Jp6CFGTUWAHDo6ZNqlsVu7fmVfrr7BpAZtycHEsoZGxwKviwICY7QMcCVHNVrycTBtdlXx9N8u/f/0dXaVU1GqBLBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 6 Apr 2026 11:09:01 +0200 "David Hildenbrand (arm)" <david@kernel.org> wrote:

> On 4/6/26 10:29, Pedro Falcato wrote:
> > On Thu, Apr 02, 2026 at 11:33:28AM -0700, Andrew Morton wrote:
> >> On Thu,  2 Apr 2026 15:16:26 +0100 Pedro Falcato <pfalcato@suse.de> wrote:
> >>
> >>> Micro-optimize the change_protection functionality and the
> >>> change_pte_range() routine. This set of functions works in an incredibly
> >>> tight loop, and even small inefficiencies are incredibly evident when spun
> >>> hundreds, thousands or hundreds of thousands of times.
> >>
> >> Thanks, I updated mm.git's mm-unstable branch to this version.
> >>
> >> The update is rather large.  If people think it best to spill this work
> >> into next -rc1 then please advise.
> > 
> > I think it's a fairly safe change for 7.1, but I'm biased :) Perhaps others think
> > otherwise.

Thanks, I've firmly added these two to the second-week-of-merge-window
pile.

> It's mostly code movement, so it should be fine (unless we messed up 
> passed parameters somehow :) )

This (or an earlier version thereof) have been in mm.git since March 24.

