Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28BC4D65C5B
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 14:59:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 881246B0088; Wed, 17 Dec 2025 09:59:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82F336B0089; Wed, 17 Dec 2025 09:59:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72DCB6B008A; Wed, 17 Dec 2025 09:59:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 61BA46B0088
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 09:59:42 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EA3CC60681
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 14:59:41 +0000 (UTC)
X-FDA: 84229272162.10.7A5951A
Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	by imf28.hostedemail.com (Postfix) with ESMTP id 22647C0010
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 14:59:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mSbsToTq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.53 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765983580; a=rsa-sha256;
	cv=none;
	b=ZmujOzg6NqjcyRFH24HFhhae9kjMaI0sL1Vev7sgAJ8VTwCV6yIjHMn3sIZ+nnMBV8k+/s
	LXgPVb9j4tU5gBZPNyqyWv7A+of7qBdKcS75Q5q6fnfr+ZybFm8/M+fwCvyms/NW55rvl1
	Hhz9YjjWMqdv+rgMCLm7haG/wagYoTg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mSbsToTq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.53 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765983580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=om7fWDlG7JRBAVM8v+UjRYiuB71tqRQ7mO9GKgWPBsw=;
	b=cVD7G3iK2NtYvfcOGMXkn0WioN7Lorhl3G7lD6h2Ln30VqyfEcoX1Fhc3bP6ZCFPzVOGNk
	BRDXfiU3UlfcAqs97WjUjDVVyhU7YpjJA/U4L1SWMul6eVoTSuOWCTngsECLmtP9ImTG1+
	WpP99hxcoZtUHtoGdHbZRDDg38a9sYk=
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-64467071f9fso4687967d50.0
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 06:59:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765983579; x=1766588379; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=om7fWDlG7JRBAVM8v+UjRYiuB71tqRQ7mO9GKgWPBsw=;
        b=mSbsToTqxrw2ESWAHBG44leAvymFAM2/S2ZhNzfQcZpnUA9tMiOANT+w9fGWHHL3FN
         82Z/H/yJQZoOazYYVFKBumCaGS0VguYaBZ/uqsr+UJWIdsrVhhCftMTAx/FG9PJJzsNA
         Sa6GXyKMR/lhzYfrv0q5kJBYz9YPfDOioWga4q3a3CK4CU/3cL23dnXkBtouA4s5XwLy
         cxnrelTYmjN+ZRCfYLyAu0/j9WLRHQ1JlX6PgjMXYHcA1PayYHJ2WThE8vbyRQwt1cji
         2Z1G2D6miQ2uU8Y4oA1KAss5KaGPJbQCIFCgQiB7dE2WzTWQiMztFGDohrvIQP51+mNv
         Megw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765983579; x=1766588379;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=om7fWDlG7JRBAVM8v+UjRYiuB71tqRQ7mO9GKgWPBsw=;
        b=K74zIpFdmpbdpcowOvBbEj9aWvrFJ8IihFxwr1APk/2YbYmq1AP1xE1T39hWl5UKCR
         sfUbaS8bRR2NETYRC4ta3r3XuTMoqag0768DVZXHBeE6+4wwh4rBzynWKGEJc97qtFx6
         AFcE+RxWVK+eCB+5guVc1mozueFjt+Vi/FnGRAkAXNRa43EiPaXD2SyRBZsRkopO6PMe
         Gx+6LmIB/cLLrNXP3z2OyiFCGan0umGTnq8I97ozX7fpwcwWJYOisRLDwFFRI73GIPUB
         SbQPI1WFWuopX+mpqi9KyXt7AgVABmmj+XBBPr9HznbJpGJmX5nH0jlY3IR5V4ntVDlW
         Y9Ww==
X-Forwarded-Encrypted: i=1; AJvYcCX6NMQYdLFH6eNchtZDJtU6YToQjMWR6xWNn4Q9tBVCxib8LiOvNodqp/cuvhmMiA2VIac/4k5TFQ==@kvack.org
X-Gm-Message-State: AOJu0YzqkFy5eUmGpu+sSvoCyemQd3PvIx7VXp0w0lU3jaH3tlIGK9c0
	gHhKW4KTlrg1Hs9lMwz8N54Ud6vcwt/RBFl4yaVvNyHCg6IkTb+1zwFn
X-Gm-Gg: AY/fxX7zor0jVzMNftvUY+DnI06OOYSIwaokNzwRfxTfyWxXkBB6L6f+yanW/FBdaRW
	+Z5QBqZoFp3hHliMKN198KEKB8y6QjaMUM5iKHuWLqsQYuWhl0j1Q4zIdXtKmObnftaXm3jdoZn
	/H/o5wjDKE1gSjXQQwOnK1Q7ppM3MFeIFOzmreGcZUCO7tJGPSBVB9k3DqhCDKhp6fsMDinsUIn
	nSmrahBfE9ZQJDvl4u+Ge7m7qGA789T9vRF0837xg7UmE4KQN779BdQa34GQAFNEYJ9MTgeHajJ
	Qui7Ig/m41wOMt49BI7KtrZkBSyu9QggVcTX2qEk99vW47rVPaga/cz35bCqKTkwjls4OgrS2SY
	jj0Pbi0uukQ72vALusOyc3qCC4Zjgh65SY18BvwgZoZKso4xv6/20nBBesaA1JJeaBwYap+0xik
	CLD0nDw+wJ/AQDbJ71L+A3nw==
X-Google-Smtp-Source: AGHT+IFlW+GTBKHXgTr0MLAOSDznbq0ZzlTE4iKHk+uu4fdhX3OuHaBTkZENLnMVgzyJRtEPxq44XA==
X-Received: by 2002:a53:dd09:0:b0:63f:a79a:7690 with SMTP id 956f58d0204a3-645555eb8demr10489093d50.39.1765983579022;
        Wed, 17 Dec 2025 06:59:39 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:4f::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-64477db6476sm9075272d50.20.2025.12.17.06.59.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 06:59:38 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Daniel Palmer <daniel@0x0f.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] mm/page_alloc: restore 0-handling to zone_set_pageset_high_and_batch
Date: Wed, 17 Dec 2025 06:59:26 -0800
Message-ID: <20251217145936.4094990-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <17c45b15-326d-4b4a-b3f3-745002b81d5f@suse.cz>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 22647C0010
X-Rspamd-Server: rspam03
X-Stat-Signature: 8kubdnda6xdkppfnkfmametuxqrojpfa
X-Rspam-User: 
X-HE-Tag: 1765983579-779832
X-HE-Meta: U2FsdGVkX18jUbH3xbqoSv9ttgbyzdFUngpAFipkqXfY0Q+96R26t2YdAZc4DszwHH3NtI3D0JzAKnTc3XtDw0fVOSXUE7iB6zvNsi6I8+fLtkFYsR3rNEO0sOnk9y7wOGWfIErryQnosj/PGO5SGW0IsSzFNA181vk3KgaRpN6CuiXXlTY/0yoAoc07gcYOU8CQxoKBPnRrj1L+VDk2I3DQ/8asqB737aXzhV2N2Cvx+VSbPErKx6OqZVfpJN5S4ME+JrwPjDZ7NWlWa3vL38iOpY8Wnx8/e3e0I4Lhdy8CPzlEVVqBXxikQWyc9DedH3k0G9//AfnE5fiI/f0sKA0VFa8DnvZB6xjH6FKBUyQ4QabDLm1acbKVDltjfoBRfun8RLauSDvOsgYWQlzZ3m5vPspxbksbX/oD+THWtAptNxJwKfcn6KJWj5/2/11L/iavsJwYjVZT3lYdh/i/n60QjaDq/VDg03ClhWY4giR1/oRN/tJ3QEX2XZd0EZsmmawBL12V0+LiGWbIpZto1licjDSbtBQQuS7YAb/jfS5oNpRfVLaoKq8ltb/60updlEqevHLoUsaHLUQKyzOmuhgjB2VgP6Y0lE9Gv2F9G0VHDHTgEtZ4UV9VWNAIAdqATs5goKOnXeBuAUJALd/PzYzDwpVKUgDOz39VxeiC6a9CvDeIjMJiiBBfLVBk9LJ0WPsSwKNUl+Nzmz5ZxIy2+ccQmo7rOyFnSUXhZqasrvwOCfVbbpWj9jsBMse9vTv7jaGv4Nn1eIN0GYTAuuinB+oYIJPowg5EViZqqKFemevKUa355r5iifuNwzVnA6RXjxDvMrASUtlSgseWl4v5ejrGIplhFqGSPCM+ikA/NMQLCw0Fsjm/V8+Kl+dO0tx5O4GCbMz8A8mRsoXi7fyxGIS880otlkDbRrXrqOp4FavI8ePK61n8kKOEqvS9SYhnu6qoiMN0OPYN8hIwgA+
 bpM5ZxRG
 jjBH61Py0luDj2y4JY5ePrkWQQsSQ/c4VfMTgl5ePHL2dT3i5wd4vqDUbyUE1SPAZDX+4y+XwYxa8f0FG8GyawQexEy6s77bqD6xQr/e1SBjeaM6H3tbb98UMDI+fTD0PqGvEpJUKq1Ndv7lljWM0ghNfuD1WWqUNRJNeuBv1E/8IV99K2hEd9L5PjaXMp/Ywsfo3yY6qlcZaIx2WQwhNjX9j5wcaU6hb3kzoDbwW9VH5KTgX+CJAC0NdGbQEPrsLFmnND9Hl8Isj/As8OgtakIt2/Rr6/4toqYx8EV/NksjGZLfEhfZfiCQ3bsnIWufxAZAsgEu0k1/dEo1PEDIO8TWMyiOofyWKaHbKlEHHxUBqRmAmr5thmcByFI8GnrSkEwpgX3gy9WAlu45GR8ZrmG0ZscfnXKb9q9VP3U5FUfpG3OT6COXEhDihBj8cD0TaxhfH/tWz0dTWlWtOjGkjH2C3Dh0Da5iGUPhwSefm7PcE/ug+wDN3j/5+7J5ihgdVquB5sojJxVXOtfVaZ/4clGdz5PfZ8UDEDVSQcILwnQ9qqcxy3uhFxqDcZLQjODHVJ4YK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 17 Dec 2025 14:19:47 +0100 Vlastimil Babka <vbabka@suse.cz> wrote:

> On 12/17/25 14:02, Joshua Hahn wrote:
> > On Wed, 17 Dec 2025 12:23:58 +0100 Vlastimil Babka <vbabka@suse.cz> wrote:
> > 
> >> On 12/17/25 12:12, Vlastimil Babka wrote:
> >> > On 12/17/25 07:05, Joshua Hahn wrote:
> >> >> Commit 2783088ef24e ("mm/page_alloc: prevent reporting pcp->batch = 0")
> >> >> moved the error handling (0-handling) of zone_batchsize from its
> >> >> callers to inside the function. However, the commit left out the error
> >> >> handling for the NOMMU case, leading to deadlocks on NOMMU systems.
> >> >> 
> >> >> Since in the NOMMU case the reported-to-user batchsize should still be 0,
> >> > 
> >> > Should it? The value is effectively set to 1 despite what zone_batchsize()
> >> > returns, because of that adjustment this patch reinstates. Also does anyone
> >> > care, really?
> >> > 
> >> >> we would only like the error handling to exist in the callsites that
> >> >> set the internal value for the zone (i.e. zone_set_pageset_high_and_batch).
> >> >> 
> >> >> Restore max(1, zone_batchsize(zone)) to the callsite to prevent errors
> >> >> on NOMMU systems.
> >> > 
> >> > I would rather make zone_batchsize() for !CONFIG_MMU return 1 instead of 0.
> >> 
> >> Ah looks like you considered it too, initially:
> >> https://lore.kernel.org/all/20251211225947.822866-1-joshua.hahnjy@gmail.com/
> >> 
> >> It makes more sense to me than doing effectively two fixups in the MMU case.
> > 
> > Hi Vlastimil,
> > 
> > Thank you for your review as always.
> > 
> > Yes, I had also considered returning 1 for the !MMU case, since I think it
> > would make it a lot simpler as well (It would also make my original patch
> > function as intended).
> > 
> > However, I was unsure if changing this user-facing behavior for one line of
> > simplification would be worth it. I am not a NOMMU user, so I have very
> > little experience here, but I imagine that there is someone out there who
> > looks at zone_batchsize() returning 0 for NOMMU and interpreting it as
> > "there is no batching" as opposed to "there is batching, and it processes
> > 1 page at a time" (which, actually isn't even true anyways because of the
> > bitshift). Maybe an option is to just make batchsize not visible
> > in the NOMMU case in addition to always returning 1 to avoid confusion.
> > 
> > Anyways, back to your original question of "does anyone care". . .
> > 
> > I am not sure : -)
> 
> It's a pr_debug(), it's not even being printed by default, nothing can
> possibly break by changing 0 to 1 there. So I really wouldn't overthink this...
> 
> > For me, both solutions work, and in fact I prefer the original solution of
> > always reurning 1 for !NOMMU. Maybe some NOMMU users like Daniel and Guenter
> > can comment on whether this change really matters?
> 
> I would be surprised if they were aware of that pr_debug() in the first place :)

You are right : -) I do think I was overthinking it.
Happy to send a v2 that just returns 1 for NOMMU. I'll wait for a day or so
to see if anyone has any strong objections to this.

Thank you again! Have a great day!
Joshua

