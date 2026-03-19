Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24B58109022E
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 14:34:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 645D06B04E4; Thu, 19 Mar 2026 10:34:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F6E06B04E6; Thu, 19 Mar 2026 10:34:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50C7B6B04E7; Thu, 19 Mar 2026 10:34:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3B24F6B04E4
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 10:34:43 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A1AEB1C955
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:34:42 +0000 (UTC)
X-FDA: 84563058804.28.B89BA44
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id D5B72140010
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:34:40 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FOvmnnOv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773930881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B0TxyhvTVjjZewUWh9ZSLztRLOylhSD1ceJQHzPjk7Y=;
	b=IojEjFZRsxOjZqIPPgsPzVqTlenq86SPwfGbJlwRxYn0hEAFnRkf/v1bv/M/MTSWYKO4Zc
	LjhKoCvJ7srJJAZVszI5iroVOjEOCh2HrSnv+I1sSNlVgOvADZZVJG/mIFc7NtIyIYrYMA
	6mHzDjChOHegaoXwVq5yNUad9QXfw9Q=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FOvmnnOv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773930881; a=rsa-sha256;
	cv=none;
	b=t9mLsmB0wkuiQoJKlb5QoovEL8ANxW9+NN2PHQvK8JbftBrrHOPN3mM31pNrDeqB/wQ65V
	TSphxl5JikRzaDOF6tbddycD9I1plAj6LGZKC4n5t6LPq8q9RvDArMBpNtXgyYhNpqGsj3
	TYgGQt6GPIPlhWo2wjXgLgxfqYJo9xs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DA43344521;
	Thu, 19 Mar 2026 14:34:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C8FAC19425;
	Thu, 19 Mar 2026 14:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773930879;
	bh=QPvwXTWdLaBTtuwZnmO/qS7QuZy5AGitWuAjPdnxmHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FOvmnnOvg2mEHRMZzebQTmrbuUoWrScNc476HIfegGUcK8PMwOs+SHj81CzqyBQ6D
	 QoQAQGN1c2VxN+kn4MldF/JebdDEf7YQ9GHw6CoXSYXRtHbX2WlSzVJzmi/jyTOmIp
	 Jw6tTlaM8f7Pb+fbIwt3zUauI/embi7CJQNEOeXIzf2M1wi/8Ow/+b5JaVwHXXZDK5
	 puKFHBw+h2zleFlajvDNhOBUq0ZRGbTKSXiAfHigvhtRo1BBe3oaF9wewRSbOIUXIE
	 R1j9nM3v90+f9zuqtzTIB2iuRuXEVFzaR0axDRgYYjvfsYbiZsLo/o8efhbA9ELtYO
	 S7vnT8uULGQmw==
From: SeongJae Park <sj@kernel.org>
To: Josh Law <objecting@objecting.org>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon/core: reset nr_dests on allocation failure in damos_commit_dests()
Date: Thu, 19 Mar 2026 07:34:36 -0700
Message-ID: <20260319143437.82957-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <B08CB6C4-72EE-48AD-9AA5-16CDA175B193@objecting.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D5B72140010
X-Stat-Signature: 7tyd8jn7m3jyrhkjoznnab8phr94x7b9
X-Rspam-User: 
X-HE-Tag: 1773930880-481576
X-HE-Meta: U2FsdGVkX1/V8pHvavlqjf/oiix6N8KeSlH1ruplUMjmZeIXX+Fx51iWeGisOUJKQqjl4SSaJKAAFalJa3vVmOW6V7CHCndRGVXoh+8qHUxlvvCPFi2IgyD1RDYOd66odoSExuxKmICayc4LaRTpPdQMGLX8QWMGTZepzS9UufwiI8ZvZ9F0psIgElsBZJ0Y//hQdyMEiGoDzuB/B6DPHvAkuDNdlnTI9PTPb+j92zRRdxU3hZwkGL+U3KYXcGQ3drXiWNAyXmoI+FpKhJNFHkruWXdz3IR6E+LcSzlPbtRvPf7dAOINXuFOFHz0UNC2bhHXKN+cKZoVAdoUSQQIS1MiicYyKjGXGehfayYON4U3Wdrs3zPxfKIdEoaC51HHdfkn7AGFtr9fUhQb7hPqCo4mQULXyVJZS+OjekfuGVbfj+DQ4Lk+4b9ZawzQYPnBd4DXUtUiofruerldkfgHUMJXHV5Yv7HcdH8Pweb+7GJ3N4WypZAYUC6PGuavJORZjEK/+Pj3eQKIFNn5o18B1m6KyHvUGfpEJ7KOGyro5l3aND+8xjMVE3UewNIydsBQ0fcRN9g6T1m8NQ1JxGPXdaNaBppufGVuGerl3Ky4zKNrlIk4GDnNh1sGn4Vp3DkfF4qbTy1MxYktnAwa8G+bjxAI58gHY0raTyNJVPlaYpQzoocALYcxQlalVMn3FclNEANiKx4avT3gABowyPyOGW/9cqSoHGz6DXb6GGterJZFSX4H69UqYBnvgxJVU0U58Pr5MAp1eYseTA01um2oQHaUsB6AaWOP+eKN4QfWpsXCHtoBvlLSc6/EQt7Pv/6ivCU7mN4CJkW767Ld1I20QwzSAnD8qCJKDxebNVizuNwrXtXQxGkRl7ijIrgC+wQkwDbZwF26SOxWhaVz+LlttdPFYVTfQvyZTUp1TZT0gwPQq3OjpHo8PbxoOuvjynGFbNTdwsPVnnavGtodBEW
 sQR3XsLd
 onjYbODlenv87g8m+eQ9G5YcceMREKlT6VuTJdNsVW9jRRhdLYq0zEQzWbrNfdDB2ys41XIC/7O2TyDlpffoUYVYb6PMCiCTcCBLPVMyFCtMMfNsxN4cslIWg5o/zckNIs50HI8+4EkyWhf0ImHAhPabX+4XW9IQdvjSCvbTOGHKiESGNLJLd3QLIHk0JAj75R/5nIfanflxMoFCQzLLL6YXbD1DjKelwhX6Fma//UqNNwJ662WzO1bfkNnfWOis18djKjDvNQ27KwukBn7D47792L6Kr4gqjwJOKFbq7XSislE+0weEyLP18CrE4/TTHIYPeV/vZVl8wfgo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 19 Mar 2026 07:07:18 +0000 Josh Law <objecting@objecting.org> wrote:

> 
> 
> On 19 March 2026 04:33:09 GMT, SeongJae Park <sj@kernel.org> wrote:
> >Hello Josh,
> >
> >On Wed, 18 Mar 2026 21:49:39 +0000 Josh Law <objecting@objecting.org> wrote:
> >
> >> damos_commit_dests() frees the old node_id_arr and weight_arr before
> >> reallocating.  If kmalloc_array() fails, the function returns -ENOMEM but
> >> leaves dst->nr_dests at its previous value.  A subsequent call with the
> >> same nr_dests will skip the reallocation (the sizes match), and the loop
> >> at the end will dereference the now-NULL array pointers.
> >
> >Nice catch.  But, this is a sort of intended behavior.
> >
> >The idea behind the code is that, if the function fails, the caller will
> >not resue 'dst' but discard it.  Hence the function is only ensuring the 'dst'
> >after the failure can be deallocated using the deallocation helper function
> >like 'damon_destroy_scheme()'.  For this, the function is setting weight_arr as
> >NULL in the allocation failure.
> >
> >> 
> >> Fix this by resetting dst->nr_dests to 0 immediately after freeing the
> >> old arrays, so any later call always enters the reallocation path.
> >> 
> >> Fixes: cbc4eea4ffb5 ("mm/damon/core: commit damos->migrate_dests")
> >> Signed-off-by: Josh Law <objecting@objecting.org>
> >> ---
> >>  mm/damon/core.c | 1 +
> >>  1 file changed, 1 insertion(+)
> >> 
> >> diff --git a/mm/damon/core.c b/mm/damon/core.c
> >> index 7f74982535ac..e233eb84a2d5 100644
> >> --- a/mm/damon/core.c
> >> +++ b/mm/damon/core.c
> >> @@ -1060,6 +1060,7 @@ static int damos_commit_dests(struct damos_migrate_dests *dst,
> >>  	if (dst->nr_dests != src->nr_dests) {
> >>  		kfree(dst->node_id_arr);
> >>  		kfree(dst->weight_arr);
> >> +		dst->nr_dests = 0;
> >>  
> >>  		dst->node_id_arr = kmalloc_array(src->nr_dests,
> >>  			sizeof(*dst->node_id_arr), GFP_KERNEL);
> >
> >Someone (including a part of myself) could argue anyway initializing the field
> >is better to do, for code readability and completeness of the data structure.
> >But I'd argue that might only encourage calllers to reuse 'dst' after the
> >failure.  Also, the 0 nr_dests could still meaning something incorrect, if the
> >first kmalloc_array() for node_id_arr success but the following kmalloc_array()
> >for weight_arr failed.  In the case, nr_dests is zero, but the size of
> >node_id_arr is not zero.
> >
> >I think the intention behind the code is not well documented and that might
> >confused you.  Sorry if that was the case.  I think this could better be
> >documented by adding comments for the function.  The single line comment in the
> >function body was for the purpose, but having more detailed comments at the top
> >of the function may be better.  If you'd like to send such documentation,
> >please do so.  If not, I will do that.  Whatever is your preference, thank you
> >for finding and sharing this room to improve!
> >
> >... And, this patch helped me finding something actually broken.  As I
> >mentioned above, callers of damos_commit_dests() are assumed to discard the
> >'dst' when the function failed.  And the only caller, sysfs.c, does so, except
> >for the final commit to the running context (kdmond->damon_ctx).  It can result
> >in DAMON running with the incorrect data structure, doing NULL dereference.
> >Similar issue might exist for DAMON_RECLAIM and DAMON_LRU_SORT.  Because those
> >modules use only limited parameters, there might be not.  I will double check
> >and make a fix soon.  Again, thank you for helping me finding this issue, Josh!
> >
> >
> >Thanks,
> >SJ
> 
> 
> Well, I guess hardening this patch is useful for then..

Agreed.  Maybe adding another sanity check (e.g., WARN_ON(dst->nr_dests &&
(!dst->weight_arr || !dst->node_id_arr), "foo")) under DAMON_DEBUG_SANITY might
make sense.


Thanks,
SJ

[...]

