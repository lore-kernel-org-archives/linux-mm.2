Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 669D31061B22
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 22:34:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D0E46B008C; Mon, 30 Mar 2026 18:34:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 881846B0095; Mon, 30 Mar 2026 18:34:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 770616B0096; Mon, 30 Mar 2026 18:34:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 655446B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 18:34:19 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 099AB13BB1E
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 22:34:19 +0000 (UTC)
X-FDA: 84604184238.24.48C8919
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf21.hostedemail.com (Postfix) with ESMTP id 347881C0007
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 22:34:17 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oUmKQI9I;
	spf=pass (imf21.hostedemail.com: domain of rientjes@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774910057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/PvBM2KlWberUTOaHUwtkA3AEbHqB7/4ny8U9ORc3t4=;
	b=Zy3B6BLzo40037FU8OPnseIvFiTPyicfCbAQC9tD7GOpnfC/lBxWQiqMufX2WLDdE18glw
	wVcVjs4hZBQ4PKAWr5FxKcMQmgoF79eEV6d4oB8mvS/HA1SYQSC28yZEgaagM5eKqSdTLw
	W3mv5dP5KUfRrdOiu0Te4ZHnC/pKTR0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oUmKQI9I;
	spf=pass (imf21.hostedemail.com: domain of rientjes@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774910057; a=rsa-sha256;
	cv=none;
	b=2wfiagm90iATVoNPaZUu2ME5yssMj3OfFeWqsJpf796LO7kK6U6PgkSxCfgiVkT6kFx/Mh
	r5E1eN4Mxez/7KGftffWCgrsy8JCEl1BsyPERH2GMZeAZ7iVk93dg9arpheuk3dWvCnUtH
	LhNIFA51qflPZXHEHNJWBFxtt45pccs=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2b0b260d309so15175ad.1
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 15:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774910056; x=1775514856; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/PvBM2KlWberUTOaHUwtkA3AEbHqB7/4ny8U9ORc3t4=;
        b=oUmKQI9I7foPNjHPRJgPTxfoJVjNd37L8fA7p1nZ9Y0j+OrJDHOccMu0ptTlShZarZ
         /gUemSNyNno3R5TYtuTyjpP0rCLr9i+lfHvis/mMXvkV16ev+A4eZfzOwAwwnMZL5A62
         qzOlWD/uHSM1dPK/VjDkPrZakgP4Dsbwm0WAOUyis5U9kFjTyjIrEfLBvJV4roWN9xrE
         qmySaTupz3pf4Frr1yLCiJ5OpMFzs246OzW4OReYXalIDwRt3uJlib1pVtXwaytyA0or
         whLeuQt4kLdI2G6hFypb6o1Y7uRgnNRsGFOtUeN+tvsfjefwf8Du2jDvbWeTR/qqAmlI
         m1xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774910056; x=1775514856;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/PvBM2KlWberUTOaHUwtkA3AEbHqB7/4ny8U9ORc3t4=;
        b=SkmoyJrrWFh2bfUJ2GAVXMABnVSu7E9mr6q1YinSkeMLXfpRm42qCcoxHDS7R6Z1Iy
         pqVhl2yYle1bMsrDd3Ctg7/U1AeOYdwwGVsNaTSb1e9PH/38dryJZyjdZlaec4j8a2XR
         zQhkNCJnG5PAH1HRvt1LUg+jEwT8WTv0WY2Wc4MTqhkioqKDi5rF3F/Yyp4o8MNXeVS8
         6pXNECX+1AmaUQL4F7/skZf0d1vP7uFLzhTIDt+HbHFzCKOGFV0JSK3B98TptDxj1B5P
         VZQs4xfbIWA18DAjpUx2Kiuy00cAxONhHNMqLvsiQoqaKGjw5PQahP3L8OaqK4k92OsQ
         qdjQ==
X-Forwarded-Encrypted: i=1; AJvYcCUo3d0vVLjZEK1VPZT1AQG4lOc1EWx/YJGfcu1bZtpzUo+OFm2l/xysHkH/kcH/Axe5GOv4zTdgMQ==@kvack.org
X-Gm-Message-State: AOJu0Yw+OtTXGLbw+Gexd+0ZGFk3Y9bGSfmbXWaYOLi4Cgq4GUVnf9AN
	5T/O+Sdbf2zahdQKwbsLLWpoYn8Y+Y0K6xEdff/lh8wJVuYzWAbPiqIThV4xdYHmJg==
X-Gm-Gg: ATEYQzzlzx/u7c8TJTpjp2Mn+9KHgno6djzEcECaHV3iJ70gmmHwTRDKYL+C5merT8O
	/aRkz6++Po9PDSK/qoiAmGjbDRcw4a+GRCiIyLCvTO8u8DgpTj3cC+M5z5vpKbMP4Hmo8YVl7wk
	I1UHzVGzgMGqOOsSFLfsDcuR0NSuZZpZchdPUGIP9xaS7mTLC5gf2FeZQevQmqQsaCDUpUyCZLL
	epDBW/0sXCVr4uC1GDB5m15lCE53/VGSAJ1o2f+OQLWR5RYAVeQNUmqH8zngVOKTp+GcppXVvt+
	z21ZGI/eAuwj8x9JQ6Ia9FBbLMwzH9ZIvjUhFALcVREonNqIOb2rKdFgyRymZEKaMLXUCoj7085
	69q3EHbRh1kBlsIhcwiOXOybY+aqLM9f8x2R9t1t0vRAwHWL7txlzVyjYhL4irQGp6TIqd1GKmO
	cm/70UT5W0TzsahlL1sF0RHrVX504EyPgmrdq7auUlCf/gsmgr2MGQMW4OWH4Qsk/bGJJM1SiaC
	iuEWEjf0P5mty8623xBXC7inCqh30xfyUQHUvYOs26iYFyEU95unQ==
X-Received: by 2002:a17:903:2ca:b0:2b0:5b4c:a439 with SMTP id d9443c01a7336-2b25f6cc9b7mr1424425ad.2.1774910055410;
        Mon, 30 Mar 2026 15:34:15 -0700 (PDT)
Received: from [2a00:79e0:2eb0:8:bec3:8e5e:fca2:7852] ([2a00:79e0:2eb0:8:bec3:8e5e:fca2:7852])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c76917bacc2sm7279445a12.26.2026.03.30.15.34.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 15:34:14 -0700 (PDT)
Date: Mon, 30 Mar 2026 15:34:14 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
cc: Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
    Suren Baghdasaryan <surenb@google.com>, 
    Brendan Jackman <jackmanb@google.com>, 
    Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
    Petr Mladek <pmladek@suse.com>, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [patch] mm, page_alloc: reintroduce page allocation stall
 warning
In-Reply-To: <fc4d2479-08f1-441e-a1ba-74fa6b50262d@kernel.org>
Message-ID: <bf25058a-4e35-8524-e8f3-97e2a1c0b815@google.com>
References: <30945cc3-9c4d-94bb-e7e7-dde71483800c@google.com> <231154f8-a3c3-229a-31a7-f91ab8ec1773@google.com> <acqAnhmm6q2nKkPh@tiehlicka> <fc4d2479-08f1-441e-a1ba-74fa6b50262d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 347881C0007
X-Stat-Signature: oewephqbussu4mzu9axuo36ydpponpqn
X-Rspam-User: 
X-HE-Tag: 1774910057-334915
X-HE-Meta: U2FsdGVkX18cyfzYKFGTjuRN52iGTzV/gu+S+AeeBDW4RUwTuORvIKvnY3PQ08Vh3yQwsyi0dQtL6kXta3AMDNkKKWuzgVdZM6NWDEHHj/nmnev0GaRquYsZhVRcSd0H7fbYXIST91kGdJPybkHeEJqJKNw1Os9rN4e/yexB0iLQB18ThKn/0T6ZP6lhwUihJKPKLIpoAifE+S4G0qCb76gvAnX42mrzfr4wD6PY1icXRz6BX1mFsH2cc8CZ8SHL7V12I7x0J7ojmaktUJXz4NAo8BAcQ7AclDVd1pkg7P19FnLgWddGq//RTrTaRQuGgRmTXv0/+mdijNP8F2lZuLOICF4ktSEUOCHqeZkYk2vyI8PoojOaQBVVJU0wComGGI4EisSO6v1GUt7GavRMqd6ourBvJBJSstEsy1+OioQtrw8UVxElyKbSHS+wnmc1G5oJyu+DEGgtQV+tLUUOT+21GRL6Jj+lqlvIb8C5lnXU8j5l9Yv+LNJnPQiH5klb1INSi1CHQEJLLmcfCITZ9GZxv/FpCsr1lBK1IEReui09WvVC5Uj58nYa3QQ5xGx1RSshzvM//3hb2OrKc1t5/pIUYbCYM8HolvxcbnhQHgQ/N3tgXXE9WTPlmxELlF5mekvL9slD5KMT0uRJI+0l1Gl3Kt2bOP9FDI4drSmriMvkh5NagXenT31OUkAcyoV0FwHFNKBFzo1bQinxD9fFfWR3fo06r0x2zI4lGW+c2A7vCVrTh9i6PHf2MJFHbQBWQQlOfIRTNIdZ32xh4SIgkxvQtyiS4206DbMEJ07XzleiV7gxHcC346zeZn01DvhXJPZkk3HmtS4XKm4Y2TPqut3FI+CdoZarSrY9uMOBeLoDEXnVO18kdJgh+WwK+PIHRmh/lYqT2q1KMWY9HbYCoVMto0QLxCrYWnjoMtiwsTtZlikS6vR8QDHdMRiWykbFZC057oqlSw8+SVBmFb6
 48z2RRls
 qnnj2gFKHbksHH0RkrWiKL+08A8D2BauKD2OtciBRrXDbIvivMsZVz4T0VN5N2v52km89/GF7Ocq3TN+PXnLmwz728+uAHjRaehCrL6flTolv0ezE//fS433VcaR5JQusUGQdOB/ST/k60EXi1JPG0lzgpxHzqq7map7QRoT6zeGVC2M4drRxu3HaUVPGBqnjkeq/1gOJEH6jJqHuyNlX4MQiRLj18GLiBdnNUGkiOxy2+BSedmnVEs9ohzsh0ylqswEgC+XR/qyjlkGEdlpc/Yg6XOnqPhxmLSxADnvf0oi+8njt1sRjalLpUy+XuM2viw90CMVw6OaWL923HnUziMvsMQm2Mg5d9QJG82csc77mkOFQL8kKT75U5AQdbPQ2dOJnR5zPpWInBthDTURCrEEudRasRK/UHNz9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 30 Mar 2026, Vlastimil Babka (SUSE) wrote:

> >> Previously, we had warnings when a single page allocation took longer
> >> than reasonably expected.  This was introduced in commit 63f53dea0c98
> >> ("mm: warn about allocations which stall for too long").
> >> 
> >> The warning was subsequently reverted in commit 400e22499dd9 ("mm: don't
> >> warn about allocations which stall for too long") but for reasons
> >> unrelated to the warning itself.
> > 
> > I think it makes sense to summarize reasons for the revert. I would
> > propose to change the above to somehting like
> > "
> > The warning was subsequently reverted in commit 400e22499dd9 ("mm: don't
> > warn about allocations which stall for too long") because it was
> > possible to generate memory pressure that would effectivelly stall
> > further progress through printk execution.
> > "
> >  

Will do!

> >> @@ -4841,6 +4884,9 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
> >>  	if (current->flags & PF_MEMALLOC)
> >>  		goto nopage;
> >>  
> >> +	/* If allocation has taken excessively long, warn about it */
> >> +	check_alloc_stall_warn(gfp_mask, ac->nodemask, order, alloc_start_time);
> >> +
> >>  	/* Try direct reclaim and then allocating */
> >>  	if (!compact_first) {
> >>  		page = __alloc_pages_direct_reclaim(gfp_mask, order, alloc_flags,
> > 
> > Is there any specific reason for this placement? Compaction can take
> > quite some time as well.
> 
> It seems fine to me - as longs as the slowpath is retrying for 10 seconds
> and still can't obtain a page, there's a warning.
> 
> We don't catch cases when either the get_page_from_freelist() attempt,
> direct compaction or direct reclaim attempt is what gets us over 10 seconds,
> and at the same time it results in success. If that's a concern, we should
> add another check_alloc_stall_warn() call under got_pg label (as the RFC
> had) - I'm not sure it's all achievable with a single place with the call.
> 

Right, the big idea here is that at least one of the allocations that is 
looping will run into the check_alloc_stall_warn().  We might miss a 
borderline case but the 10 seconds is already arbitrary and this is the 
placement where commit 63f53dea0c98 ("mm: warn about allocations which 
stall for too long") ended up before it was reverted.

