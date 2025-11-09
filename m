Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22D4DCCF9F8
	for <linux-mm@archiver.kernel.org>; Sun,  9 Nov 2025 09:28:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B749F8E0010; Sun,  9 Nov 2025 04:28:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B24438E0003; Sun,  9 Nov 2025 04:28:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5FFD8E0010; Sun,  9 Nov 2025 04:28:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7BAD88E0003
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 04:28:07 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BD66EBAEE6
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 09:28:06 +0000 (UTC)
X-FDA: 84090542172.28.B056DB5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id A52A62000C
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 09:28:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762680485; a=rsa-sha256;
	cv=none;
	b=L39Z3uig9QIqawlkp9bwWanh2yYCZxRldd1Jixm+BMZKLwykPgsJfWegQTuaHyXyf3YEGV
	duAWn1NxG6q8ycl4WnrbNM52KUhRArPv7sIICiUlxqFmfQFdom2n1PYk1U5/UkiGp7PQKt
	paf0TC1Jxtw8aRAlVvwrowLSkJtbmX4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762680485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A5v3l/GD3DEOP2m1ic7gUKIMwmkjectHNhp87e6tSRQ=;
	b=o9QA2UxC0wTOrqf1EMh2yBSjUgPu2FniqXK/S2m7BLZ5xEPoE7IKMi4w88r9bCznoT40ls
	Ij9/mNVgSpzy156tf1d3FXrtKfnUiqzvoWMdrYtIxfOThRVds4cf7GhXYPkONguW3dP/SE
	E/zXDKlfDGxutPjUZW3/S0usZpDuW+I=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AB7332F;
	Sun,  9 Nov 2025 01:27:55 -0800 (PST)
Received: from [10.164.11.1] (MacBook-Pro.blr.arm.com [10.164.11.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 032313F63F;
	Sun,  9 Nov 2025 01:28:01 -0800 (PST)
Message-ID: <9ab2c883-9707-4c30-9922-c2ff83d35677@arm.com>
Date: Sun, 9 Nov 2025 14:57:58 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Guidance on contributing to MM subsystem
To: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <cb17f29e-b45a-4275-ab2b-1443d909d944@arm.com>
 <20251109141452.7097-1-swarajgaikwad1925@gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20251109141452.7097-1-swarajgaikwad1925@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A52A62000C
X-Rspamd-Server: rspam07
X-Stat-Signature: 43mg4icwgxcwtidp683bdhgaa4xacked
X-Rspam-User: 
X-HE-Tag: 1762680484-656141
X-HE-Meta: U2FsdGVkX181hc9yMM08mfslpUrcZ8YS2biZCaCQB/ivv3ELNz6DqD+97ZYuNaMhmhh346WvnFswXxRIiXUI92WeKoPttjpmAsVSszy8Q+GDl5MtTeH8cbyLBNJWWNEF1aqUi1b/dI07oqpsiQ/3XQRljWvY4txFSUEbNE2oX0ndEJslCfKbhGsZQoOkQ6F6JDGNHbQJfc42BSML/DBViceyNQyN6IWdq3KhsViJ65pHUrtra41r2Dplw00DTJbLhavsAh7zPEiYYPwo1rZBJVsszLogbrMuu+zi/9p/NZ4RzVgKJ6kCkTTVQO5EoqOKLxPzVDiKpl5x6aTTuPBrYPzs1XKIQOYv6LsLNZcx+8iK3koxVFR22fLzz7dFpwJpKkhhR04hG7o8xBUBYdwiHiSlNofkhuGMkoKZcPhw/QJ5U/YHK45VhT7uTsA3LOlEbnGeiyKxdfiGsQujvXnMwIKW45vBawt2vhpmVZGXLg+mh8GuNSQu2LPEEbM9/DxEG5puKX2chFa0vuTNAX3e58iE2Ngx5ydfLWkQPM1g2VQnXiAKzSLAx8KDQv2imtXOqW5J0xbC3bGPr2DivW6TnOfSqfA3U22cS7dxSaNzzZdVeENzK7X0wYuMTqpCuWPuxXrWkzQ3NG+Cb7h2jUu+2dTK1o4mABh209lD9XK3UZ8YFaOzF6B3HBaZtMUqY3qszBmN75T0+LmtHXPE3+J6vUqYTZ+WP/tiv/tsMLSe9axtmuzc/qD1++hLV7J4HLwVAJHUQ8z6IoWU5j8T4ukbz1Bx5AkvkGwi34qSN6XSgyquEGUd194bKy9szeCgzAFAM2jMaEv35WnbVlUNqi+YMz0ktk6F1TXtGxVo0Vn3fw4jOa5bY2gU9E3oyv5Js4+/26wKJQgpcN1sQhVQ6bE6w8VoqdxKvKV80GfNamJISz3uG/A6/XJL+bMI4IHpR1DlWd//ahtOJxhMfsrco5T
 Jrm0GugG
 ANIF4o18Rvafl47NQrL6JgBT8Bon0gsR0LIzq6ymIeltFz3KaMj8G097k7NM2Pq+gJdSRpwGU1dfBmyrAXr3QUulJYrITq6y4SvcbSERhSXJSEs7zfFlYxveKG+bcjSIPf3l4ewxr2zwojddxoOxI2qZDlnfxzPWe1JVS41L7evcsUXPzlvyuPOqPvXZOCQtk7sMt8ZVNH86I6s6MLR9ggXdivEDa8tx17OILUWVnjZIO/UIn+jS/bibzGHuTWDVKx8sjlBEaSwSrZq4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 09/11/25 7:44 pm, Swaraj Gaikwad wrote:
> Hi Dev,
> Thank you so much for your reply and for sharing your experience.
> I do have some basic understanding of how parts of the MM subsystem work,
> but I’m still struggling with how to find meaningful issues or tasks to work
> on. For example, I’ve been trying to explore various parts of the code and
> read through documentation to get a better grasp of how things fit together.
>
> In other open-source projects, like on GitHub, there’s usually an “Issues”
> section where contributors can easily find bugs or tasks to work on. In the
> kernel, should I mainly focus on exploring TODOs, adding selftests, or
> improving documentation (especially for new or less-documented parts)? I
> also believe branches like mm-unstable and mm-new might have ongoing issues
> or regressions, but how do developers usually find or detect them? Would
> simply building these branches expose such problems through compiler errors,
> or should I try building with different configurations (for example, using
> defconfig and other configs) to uncover potential issues?

Yes this may be an option, to pick up mm-new and build it with
various configurations which are not extensively tested, and stress testing
with mm-selftests/mm-tests by Mel Gorman, etc. I had my first bug report
by just randomly testing CONFIG_LPA2 on arm64:

https://lore.kernel.org/all/20240415094003.1812018-1-anshuman.khandual@arm.com/

>
> Even though I’m beginning to understand how different parts of the subsystem
> interact, I’m not sure how developers usually identify new bugs or feature
> ideas to work on. Once I understand the code flow better, how can I
> effectively find such issues or areas where help is actually needed?

I would say to not pressurize yourself to find tasks, but focussing on
learning the code. Try to review patches - that will increase your
understanding of the code, and it will make you sit in the shoes
of the poster and think "what made them think of this work?". Leaving
aside very big functionality changes, most of the patches, in my experience,
are found by extreme understanding of the code and while reading it,
having an aha moment of "this looks stupid", "this is a bug" or
"surely there is a better way of doing this".

I'll give some examples.

https://lore.kernel.org/all/20251017160251.96717-1-dev.jain@arm.com/

I figured this out when reading mprotect code and observed that we are
doing an unconditional TLB flush (via mmu gather) for arm64 - pte_needs_flush()
was not implemented there. It is obvious (if you know about pte protections)
that we don't need to do that for a transition from PROT_NONE to any other.

https://lore.kernel.org/all/20250610035043.75448-1-dev.jain@arm.com/
https://lore.kernel.org/all/20250718090244.21092-1-dev.jain@arm.com/

On arm64, ptep_get() becomes costly due to collection of a/d bits for cont mappings;
I literally went around the codebase and checked whether we can batch process ptes
to avoid this cost.

https://lore.kernel.org/all/20250908075028.38431-1-dev.jain@arm.com/

I observed that khugepaged is operating only on writable regions. This didn't make
any sense to me - I scanned the history and couldn't prove that this is of any
use, hence posted on the list, and the community agreed (and the performance numbers
agreed too, as described in the cover letter).

One more interesting example -
https://lore.kernel.org/all/13945f06-f862-4f80-904a-f2a4ccff3e4b@redhat.com/

While reviewing an unrelated patch, David Hildenbrand reads the code and spots a problem
with the existing code, which was brought in by my patch, and I had to fix it in this:
https://lore.kernel.org/all/20251028063952.90313-1-dev.jain@arm.com/


As you can see, we "observed" all these things. The probability of making an observation
is directly proportional to the knowledge of the codebase (as is true with any other
skill). Which leads me to the conclusion - focussing on finding a task may be counter-productive.
Reviewing patches will force you to read the code and find potential problems with it.

>
> Thanks again for your time and guidance!
>
> Best regards,
> Swaraj Gaikwad

