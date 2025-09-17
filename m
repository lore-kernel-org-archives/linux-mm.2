Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1007DCA0EE8
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 07:44:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 667B58E000B; Wed, 17 Sep 2025 03:44:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 618368E0001; Wed, 17 Sep 2025 03:44:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 506BC8E000B; Wed, 17 Sep 2025 03:44:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3C5258E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 03:44:19 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CF5738699B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 07:44:18 +0000 (UTC)
X-FDA: 83897954196.22.96BF733
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 36B0240006
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 07:44:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hbSauEvn;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758095057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9fUu9OIh0ZYMHt9qnzpw0zc5dtk9qa7FmllVSO9UTrg=;
	b=QMb6uE8OGMinQzUX/jq7/jN4JBklpsRE9a4N+eJRCM/p80+v0J1wFEVZyDfy28yV2CLp6C
	UDsHVZolI9RJwvEVYKcJgBDhplGnTu6pAZ2DIW1Ld2oGJCSjkK9oS6HJd+nHgY16HoaX9c
	YIhvKCpI7B0nwJT04s+G7ru+z9iFpaM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hbSauEvn;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758095057; a=rsa-sha256;
	cv=none;
	b=u9aA5iggd2byMgluXI/W3QKFdcwRQOZjEWIxQ4M/tPaaCTT3wlV3gAbEB56EWd7RURREry
	uxLclkPbw+c8p6rQ/3Uf4SAwhRzIcTFSAFsf0xMaTuSxDQ3wifeH2x1uY3nORtTPCr+LFN
	0HAm16Z1e/Fm7kd3eVUyDO3vM+bhZUk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 182B7601E7;
	Wed, 17 Sep 2025 07:44:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E97C4CEF0;
	Wed, 17 Sep 2025 07:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758095055;
	bh=O32d9nMpfCjkvZmQj+LHF+wrVeinQYtykhIahUtbw28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hbSauEvn8Wn3EmtIF1IR8j8PX6fACuh6JMywy6s8FmmriFeqeH4xYjv3rsgkiiCHw
	 UyXW6ZCZNvyZE6RGZMkRkFVYho1qOiCrBlbKLbvA3DYc3eG5k5Z3b3t4Ah6Vut8N9F
	 mz9Od2K/Zjhb48M5Pz2QeuVL8vkMb1oj5uZE9k+U3z9YRyXC2W/V4Q1Rs0QQvxv6oI
	 TuhwBy01nl82bA0BWe24Tay45kPxpRH5HoKH4BQiwqA0cpTdkVZWobrGlHTzenVrMv
	 tcbISR9d3OsZQnCUcEViB7xZ1G39ye6jJ1F7RiGRvM7WXqTvJfZlKNBNHAG6K+b2bD
	 GaMy0M7pskqyA==
From: SeongJae Park <sj@kernel.org>
To: Kalesh Singh <kaleshsingh@google.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	minchan@kernel.org,
	lorenzo.stoakes@oracle.com,
	david@redhat.com,
	Liam.Howlett@oracle.com,
	rppt@kernel.org,
	pfalcato@suse.de,
	kernel-team@android.com,
	android-mm@google.com,
	stable@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Kees Cook <kees@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Jann Horn <jannh@google.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 1/7] mm: fix off-by-one error in VMA count limit checks
Date: Wed, 17 Sep 2025 00:44:13 -0700
Message-Id: <20250917074413.58886-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250915163838.631445-2-kaleshsingh@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 36B0240006
X-Stat-Signature: ip79ebtfe5pu6wyb85mwb6bpfqni5cyk
X-HE-Tag: 1758095057-12255
X-HE-Meta: U2FsdGVkX1+X9mAAMhqwxn9XB7IDXz9jjWC8IGCfvhWSzDZYcKVuHI+OdvbYtjM5t1JMgRioz0N33wMJy7EJgjhMfVSgzJAeWLvOjisDEbx5ZBrUuGdPtRBXGzCM7yM3lmIHPuibvQeAhmzUthkJ1bDiczdn3I7oNITQdR7QpolG/a0Srk+QhnpTwulx9M28yzGlJc/U3IL1BjevF8Mvc+JAuZ86MyB5P5SlQ3InUOqFb5HSQOpW3RIH2dSv7TtVjKjeKiim3rhnFurCWVuqUuZf1ZRNSHKqZ/08CsePBjTxNHrgoRSCjduE3Zoao/cnHChjE3Er/UbegMxAb69CAgV7a2B5uArxeS/SjwVvI+Vovv/7qzDszGXTGcXBnRevzVdOWFV2wshdrwfNH2Sh800EE9+fRDFZghda3PaasmfcaJdIbnDYo7TvCzr0NhxskALF91L5U8uspgs109uRpHeCwvm8XE+etIkGbprj3m1eyXLDD7jMM4Dt4wM+6XqFondmZ3msZoYLDNvI08fWVUODcS9mbGxcqr6QfxXJFPfmYkj6A+COajj+UPozQSm8N361iZtT+WDGemwiWntlEfe5BbMUeBdfHjO6oDBqkZa+krB2F2hQi2wiH1sBNpBkho60c3x/VNoYVushjYM48fzHh60VcO0jpZ/p+G365uNoeHESMuL0rPeYN2JSKSubVax2QeqQGIutDT4C9M/FqtmKL+hNRSV6P4vob/kt4N6v1WFga8TRDq8tqqBiIUjFxe0krHy+ITkCWX8FqbQ2TKHuJaHBeEITH1eRlC1a0pm5tOS2J8J90illohYlSafWUXWyhCvQWhZYMWPZOII+bw/7axjX0CrtdLXVGP3w9lgkdw55aXnJ3iel9Pk3OB5IB2d770pwY3/tpBz72S2FO1xQEtGJub6Hb2V+9kRhV91AiG5x8L0DdHutyC3RJ5ggfXry1wCn2sJPHl55w9N
 0osmxPmh
 eWnoReSpE31A96r/G5W0qHTPBshhgnFOc4oZKriWqtqEM6imy2HV8M4Jj2WFuRvrsH7IlfaKzjlPFUp7pAiMjH+Pr0o9nvC327zj/kJ89oZVPqftHGoLf2kLhZukrVBTvYp9L4nM9GHbpffWV8neJ+ki9xJzDNpcavT99+A0rONfvAO0BLL8YYJQCE8p3/WW+JgIlOZrV7LPhFZfr/XLAolIg5TDMige1lIWilqYDTc7ErLyl/YfHiCgpfjNjLlJKBFdDgIbb30uJaNKKwyYeGUd/JByEQDWBZCw/ewjw6Y00sQkyBaoMEP9IqprUwWctDDuf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 15 Sep 2025 09:36:32 -0700 Kalesh Singh <kaleshsingh@google.com> wrote:

> The VMA count limit check in do_mmap() and do_brk_flags() uses a
> strict inequality (>), which allows a process's VMA count to exceed
> the configured sysctl_max_map_count limit by one.
> 
> A process with mm->map_count == sysctl_max_map_count will incorrectly
> pass this check and then exceed the limit upon allocation of a new VMA
> when its map_count is incremented.
> 
> Other VMA allocation paths, such as split_vma(), already use the
> correct, inclusive (>=) comparison.
> 
> Fix this bug by changing the comparison to be inclusive in do_mmap()
> and do_brk_flags(), bringing them in line with the correct behavior
> of other allocation paths.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: <stable@vger.kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Pedro Falcato <pfalcato@suse.de>
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

