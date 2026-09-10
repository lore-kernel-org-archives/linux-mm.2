Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DF5FC79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 11:31:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 649046B008A; Thu, 10 Sep 2026 07:31:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FAFA6B008C; Thu, 10 Sep 2026 07:31:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E9136B00A1; Thu, 10 Sep 2026 07:31:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2BEE06B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:31:52 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 746B8404AD
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:31:51 +0000 (UTC)
X-FDA: 85197638022.05.91817F1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id D1140100006
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:31:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=QPChFh2S;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=QPChFh2S;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789039909;
	b=qCSW5BpLvP+YlsUdsFw8hWUeopjV4eI7cAEiv/IdSZH0P+AT2ju+Ij1Pi6RHxnSbeaRaFt
	CLutfquChe8ejlxGwQMxWHd6+2I8JjA1pjP1Iy9w48R1qKnYQYxhHYLIDrt8v/2dreaVvm
	6REl2h/qaEcBowViA8NnO/ERxucJ6ZE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789039909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HXoK0I7uGlT1Y8TgMGohYGWQ884Cw2Zx+PIiz4t9lv4=;
	b=x78+wS8vZOR1U/zMcSqbjnSfnJj8amlQKVFDUgprGfBlpFkhkUC9YHODZG3fy1Mezes9Av
	DM9ApGStxFhKNeH/g0oLa6aJJjO+B6JltruNxdhPiKo+BoxgJ+g67VJv+YWpli9TOz23BA
	UaTN7GNXndTRigvEWmosuM5uh40vqEY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5B24C153B;
	Thu, 10 Sep 2026 04:31:45 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8898B3F528;
	Thu, 10 Sep 2026 04:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789039909; bh=azp3o1mihi2R6duYwj7abG8AVTbmAow/Fym5VmGLMS0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QPChFh2S69dAT24VWmc3VdsBcSdyT2LdSXVbaueArXhiONAA6WvjbudrfRdqY28D5
	 CKk9ZfK/E7iqJuQVFSckwsp3gHioXyIB5H0VSwpiivd3aTci+06eugrRJwJos1BqI9
	 WCJD4yXv2/SQgQEcKMKBuSLaKy0dtEIl713gKddw=
Date: Thu, 10 Sep 2026 12:31:42 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/3] kselftest: mm: replace usage of /proc/self/smaps
 for check_huge_xxx() helper
Message-ID: <aqKVHnkhjZm-54LZ@e129823.arm.com>
References: <20260907-fix_split-v5-0-822b810458bc@arm.com>
 <20260907-fix_split-v5-2-822b810458bc@arm.com>
 <956df69d-8c0a-420f-889e-7df2842605dc@kernel.org>
 <aqKMVUDvN8bBpwVS@e129823.arm.com>
 <1968ed37-3836-44df-a266-9a37219c2f6f@kernel.org>
 <aqKTkkK0wnm6cqpX@e129823.arm.com>
 <3aad90e1-5081-4f8d-803e-e9f593ce581d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3aad90e1-5081-4f8d-803e-e9f593ce581d@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: D1140100006
X-Stat-Signature: bf4pnmgjw55wdobowicu4z6t4hzd8jmw
X-Rspamd-Server: rspam01
X-HE-Tag: 1789039909-409685
X-HE-Meta: U2FsdGVkX1/FexJr11t2FLSa3yOcyZPm6AzJVNssvFkd6tWKRqIYHFBR2bS4tDpemmUPJ+fJwwjwhGARPWeKBzdU1A5T29fTUumQ93ZKEgobT0XKqWzSnMrr/raDW7EB8Wf3Yeqcf45uxXXvvth822ukqtrHEMSMiEbz66DYNae41sg13s3kHAY1d9Bv9/+rGalo7vy2wEwxmdZZgP6gMy4d1Jsw8pu3gaHWpXM5pSUnyi2FIzoRyK4HUx+rKq8oFvwsjvFKFCBi6FRwsCHT5iw45nl3TGAEG/ECFJ67bRRrBVea+SDWENXfjzY3/Eq2qGCEpephB7iw4K6N4fFF4QHkiSS4VWTn9WfnXX1kaOy/01A9I0qf4NP+Qelp88GK1WErIexQPOmqqY3Lap3BXyv47/7wVo5A8jdrmKTPXTxvtU63aHcnA9B20vfCNJ68hnONOW1BfxqdliWIzR8Oy7bqgmYpnRdqBH6qYuKCc93HNX5jLK/9mGmqpXRguMj4MiAkYKinr56nGTzDqIYG38PGfpChoM9XMa5ojjg8ek5fO5StTvGujTto05kuK6pYFWrNXMNaGCGmBMQN6XYLnnL5aUyYXIqOn++sFfcJcYp4s5A1RvkR0JA+rglcxVnO5nX9K4ur+wQUz8tMV5OWDeuiXwWZCXjkQ3v1honRL6A8pdxEsx2xxvwzKqSPU2kqz6MYwH4R0XbYG5eAu8ZZugJdad7nLcBXlNFR3FyUbiHjiYfR+QyQ0qYOBRTu1t7MxSNyOJnlARu3DA/w/M3eWE8fBfPp9mfLorrILPRQFt5IISoVrq09kxUjta5iaMs3XThUyJUEmVIXr4jFRb6tF8ZedzaB9ovExHflG12il039DkGOgGyEL1ORXVOd8ZvvGhfyelU+2c0v64SYWTQtzTc4SipaAMc579XniQHpKApOVmTGA+lu/7D92QOOlbjXjUDu7JjgZiw3ghvHcd8
 wo4RClP1
 H+w1JGTfImE4BduiHPAYQvcF8dKXLdizuJFDiEE0Ih0ecexVqmrm5lQi9J3oDiAWzyU39j/7tr6WiqJw8+Q6MBxn02J2kk0nJLiw6kpWYJLPgKa6Xiu2V5Acu47l2Xi5f4ypCT9DkOAf/Ndh2ftJTgbbInbbCuBv6jDKeLii7egPQyTmhkz8kkD9N0yo6eSJEvipjjTRafanJcB0sYe0HaJXQWZTxgt5U8OlFnKIGGvOka9rB59gFsw/jlhKmPQxJPAafF41sz5jpRuyWxstGX7qXH3jKZFZAh238
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 01:27:41PM +0200, David Hildenbrand (Arm) wrote:
> On 9/10/26 13:25, Yeoreum Yun wrote:
> >> On 9/10/26 12:54, Yeoreum Yun wrote:
> >>>
> >>> Agree. but there seems the case where discern whethr the mapping is
> >>> with regular file or shmem like tmpfs -- khugepaged test where using
> >>> __shmem_ops. So I think it would be better to keep this as-is.
> >>
> >> Let's not add or maintain unnecessary complexity.
> >>
> >> hmem_check_huge can really just become check_huge_file.
> >>
> >> Even file_check_huge can just be simplified.
> >>
> >> There must be a pretty good reason why we'd want to keep this.
> > 
> > Okay. then I'll change the check_huge_shmem() to check_huge_file()
> > with the separate patch.
> 
> You'll likely have to make both behave the same under the hood first to then
> remove check_huge_shmem().

Acked.

-- 
Sincerely,
Yeoreum Yun

