Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3DDCCCFA13
	for <linux-mm@archiver.kernel.org>; Sun,  9 Nov 2025 07:43:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 578778E0012; Sun,  9 Nov 2025 02:43:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5269E8E0003; Sun,  9 Nov 2025 02:43:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43CA18E0012; Sun,  9 Nov 2025 02:43:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 340AB8E0003
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 02:43:55 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E4CE45B9FA
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 07:43:54 +0000 (UTC)
X-FDA: 84090279588.07.42510A0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0302D1C0004
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 07:43:52 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762674233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DNee4QgR7BO94DSVZY3TiKUaQqJeCzVp1cWJ4GcQUL4=;
	b=DtbFjlIAoRc6VmcMFXVoYw8xq5IZ73EbHo5T9PNOv9kKQGjxH0hNAQIq5YN05ZTlW/ZuDu
	QnS1TxJ2Au/pYmIo88tScqh8Z7DBGF/qh77lqYz602sYp+esXOsEoc87g0J5agcp3w1hmQ
	PVFbVGeg5kSXdX41c3MaZAZdAqoVX1I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762674233; a=rsa-sha256;
	cv=none;
	b=B39R18knrF6IShMJCzzxcZetiPfe5utT5GBjVQxblIIYAwNWLimikaSPelX1EfDeKB3ngK
	eXYkQMFPD711QbUXEZqy6XB2/nYABYmKuMyIWgjq343WOVmGFuasD2eVImLF7PLxBtry3u
	JbVUdnf6SwDH5ZNGManWMrFci1ntN4k=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2169B2F;
	Sat,  8 Nov 2025 23:43:44 -0800 (PST)
Received: from [10.164.11.1] (MacBook-Pro.blr.arm.com [10.164.11.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7610A3F63F;
	Sat,  8 Nov 2025 23:43:50 -0800 (PST)
Message-ID: <cb17f29e-b45a-4275-ab2b-1443d909d944@arm.com>
Date: Sun, 9 Nov 2025 13:13:47 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] Guidance on contributing to the MM subsystem and finding
 tasks
To: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>,
 open list <linux-kernel@vger.kernel.org>
References: <20251109113741.102337-1-swarajgaikwad1925@gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20251109113741.102337-1-swarajgaikwad1925@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hhru4mn4id7xznsqo5ysp717fjfwo6oq
X-Rspam-User: 
X-Rspamd-Queue-Id: 0302D1C0004
X-Rspamd-Server: rspam10
X-HE-Tag: 1762674232-346038
X-HE-Meta: U2FsdGVkX18TmX7HYYj6FeDLVfj3PS61avpuuQkFA8egfc1N2QRQfQIi9YHp97Q/l0zA5Kth3on6AZaHxzrBc4Wb+kK9kHh7LAJuM4eFHP1Nkrsz+rilJzEk8HFZY6Uj2Z/XUgXmQezGrMlHclrGP/gob8JrmMibqMRaRlSSXSTggQJiDHiKxN7sGMiL57WFUCU/rdNwy10+POGjSWFQbQulq+4/t8B19SmA0nxN46PPXoh+R6e7fGhcp3bWuEQjHhmLzBQ0Xskuk4/SgZk6OZYuMfx2lkj0H51Hh5fLGJxqprEEIabhb7kPm8+s9nI/iXUNBoTX6kNZsSSvvFWpdQTfFGnjQlFdPRhwcbLpcZrjqPGy+5YdbngRkgcrKNFItKS/kSitibqoBu3GUGyYMOxqLY7s+t92HdjeKwK+wBy+29rIjn4UVfxwRpgE2o56esYEZWUKdQXM1LQ2AiMzhwoqvbx14iH2dHnGK6E6rApfL8XEvaNY3yo80qKqVW1LFzikJi95/sCN4Z/oTPWeSakh0mafO/6+sVR0Z5LCA1cAzR/d7wXJ4GRtqcl2YQum0ZeOUNUOXPZTEaVuG9bK3FUg3wmuAiZ3UDkh9QlFYwgrMNCNW37F0y+12N9f3UoNNeMCD5BL5kV4AbutTfFas7eZj3CeOOBJvv+Uw0PXiDjsvoorRXgtuSk9F5O4dmuoFJw5zBW6GsSuiJ0ymgKwwVnTxaRIUeHCTG7G0RUGh0oI6ivLqTDhykDyqZt2imw5fFCcFC8GDY48J63s5OoQ5/U0ozh7vWJxVEPdWuJpnP8UarQj+cN5jXSzTBajnAp9R+6GnO+IqIMv5uFEW/u4Bw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 09/11/25 5:07 pm, Swaraj Gaikwad wrote:
> Hi all,
> I’ve been following the MM subsystem for a while and have submitted a few
> small patches (mostly cleanups and basic fixes).I’d really like to become
> more involved and contribute to meaningful memory management work, but I’m
> having some trouble figuring out how to identify useful areas to work on.
>
> I have also looked at some TODOs in the mm/ code and submitted a patch for
> one of them. I’ve tried looking into syzbot reports as well, but often by
> the time I finish understanding the issue, someone else has already sent a
> fix. I’d still like to learn from such debugging efforts, but it would be
> great to find areas where I can make steady progress and contribute patches
> that are actually helpful.
>
> Could someone please share some guidance or suggestions on:
>    - How to find open problems or areas that need help in MM?
>    - Any advice for someone trying to move from small fixes toward more
>      substantial contributions?
>    - And if possible, could you suggest a few small or medium tasks that are
>      suitable for new contributors to the MM subsystem, the kind of things that
>      would be genuinely helpful and likely to be accepted?
>
> I’d really appreciate any pointers or direction.
> Thanks for your time and for maintaining this amazing subsystem.
>
> Best regards,
> Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
>
> Signed-off-by: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>

Hello Swaraj!

I will recommend to first understand userspace interaction with the kernel - mm selftests
are a great way to understand that. Personally, I had started by looking at
tools/testing/selftests/mm/virtual_address_range.c. I played with how the VMAs are getting
created and displayed in /proc/self/maps, and when they get exhausted, what is the gap
between the VMAs (in fact, it took me some time to figure out that the ranges getting
displayed in /proc/self/maps are in fact exactly the VMAs!). This forced me to look
into mm/mmap.c (now also split into mm/vma.c) and try figuring out how we find a VMA and
map it. Eventually reading userspace code sent me looking for the corresponding kernel code.

>

