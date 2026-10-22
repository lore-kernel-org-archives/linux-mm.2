Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19576606A327
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 02:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UBj46MA/
Received: by kanga.kvack.org (Postfix)
	id 2D3A66B084C; Wed, 21 Oct 2026 22:37:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AAD06B084E; Wed, 21 Oct 2026 22:37:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E8146B084F; Wed, 21 Oct 2026 22:37:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EDD296B084C
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 22:37:30 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5BB5E4061B
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:37:30 +0000 (UTC)
X-FDA: 85348701060.11.53F2547
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id C3849180002
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:37:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="UBj46MA/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792636648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s7IDBrOb09HW515M8YqXw6KmuJ850iUtgqwrNUNLuDg=;
	b=VzxibRzJuQeyMd7fgS6m5wdotL2WYveshPckNV2hhCghGvQZtowDdL3S5bH5s5TOwKenb3
	TcN7EhQMELgWDyoBLSUVQRa21ipVmSkhvSCUA/rh05OqQO8goz8QQ5v+rf7OV7Ps/jPmXH
	oj1tsmZKSNZKpmuGwAtq0fRnj0FfTtI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="UBj46MA/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792636648;
	b=M9ebgvNUHIIDMj+fSRSe0QriLQBG2SbAMyD7KV0bQMLxE8SVR0tpux6cZVIjN2d1Zuna5o
	NsfkZy3nnnFDX+Mem8goT3uQE9Zjz0iyzqsoE4ZTEU+trBkZd5/ewc46As6hR9RFwCvkux
	0sZnwj1E4+xSDXOHZS57Lo9neSDStgE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 274B741321;
	Thu, 22 Oct 2026 02:37:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 297771F000C6;
	Thu, 22 Oct 2026 02:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792636648;
	bh=s7IDBrOb09HW515M8YqXw6KmuJ850iUtgqwrNUNLuDg=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=UBj46MA/XvLQQfLFsLil3VhVenGPTNYAHO7gSbNprUyfFTL2s6qWEds468MJVOjdm
	 smVFX909FQ8UhUydSfAxnVXetgyA89WIxf4P/DK5PcF4MsPgtsiJP8wPMinaeLZyZL
	 7P3pgAqPGISjeo0SfgqEwINhoOJImeM9VkTOgOY2pCGZ9Gw9vRCXioUBcXXiMDIoJJ
	 hgRLfO9d91u3UrBt+VkhaUGj8poZCFY0KJaNyQe9pTOwrAl0LTzS9ye40teAW3CE6B
	 eeHcDQWbOKCYS6+7mE3PWmnbBxWkheL5OrfdOkIuApNuMolgY5KvW7+GptMJWjCn38
	 uqVckgRXYkvIA==
Content-Type: multipart/mixed; boundary="===============8781031005950137975=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <6d62321ca2f86cd19e5dbe9bac70a6c964c208e72c8fcb756fd4e12a94edad95@mail.kernel.org>
In-Reply-To: <20261022015712.1297331-10-alexei.starovoitov@gmail.com>
References: <20261022015712.1297331-10-alexei.starovoitov@gmail.com>
Subject: Re: [PATCH bpf-next 9/9] selftests/bpf: Test uprobes and fork() with busy mmap_lock
From: bot+bpf-ci@kernel.org
To: alexei.starovoitov@gmail.com,bpf@vger.kernel.org
Cc: daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,oleg@redhat.com,peterz@infradead.org,mhiramat@kernel.org,jolsa@kernel.org,akpm@linux-foundation.org,liam@infradead.org,ljs@kernel.org,surenb@google.com,david@kernel.org,vbabka@kernel.org,jannh@google.com,hughd@google.com,kees@kernel.org,mingo@redhat.com,tglx@kernel.org,x86@kernel.org,linux-trace-kernel@vger.kernel.org,linux-mm@kvack.org,linux-perf-users@vger.kernel.org,linux-kernel@vger.kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Thu, 22 Oct 2026 02:37:27 +0000 (UTC)
X-Rspamd-Queue-Id: C3849180002
X-Stat-Signature: qzimafn7giafqstezty4eij5nmy4trbu
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792636648-635045
X-HE-Meta: U2FsdGVkX182SMd/5XCI+13Q2a1j5SMgYLRnPSwNhDJB0RHmVlOL/vXlVGXzzPwpU27VeaEAvj++TBMy8lhJQ6cyJPz5pU/B66R/3qpn/VF4V9ZrvK/KdbF7pb8YY+pnSRYQmy36tSv5JVFq1H22Tir6fwwKfmpNgPDKGjfxDZMegxefaWnYn8tTGuf/HlgNmKQP5OVSD1V4bQHaQuf9lhtU1/TDPzVkWS3+0yBbZFUagsTcdImYpXd+qoXLrrr2FL/EbmIikLwoGcb0IsWpJ5XjgpRO7LWllgnXdnpfLYEo0D7d2IFTZpLlsyFf6WbVlCFmGPLQIigi5DSouliGym/MeBs2M04vH0sh/iFxmQecVjdF3ijYaLqNMtHl5o6hl0PIatG4mS7VDWWrgnuvJ/gf56ArOyycLfLjjw55YKMowPzzAU2VNtpnaTtd+fA2KaTzssEafLHeWdbbc2MRxQrCBOpyD4jfz5ybJbZc/qZRi4Tj2Lq8g1nYBW5PXSbzFudEd9mD7us0P8QhdpKIQqrToukrSpyvS6urRXt8jM279PYP8LJs6uEaJCfhyKqJMj9iVV6RKuQbJbOd+aISMftrWjGLXdqpk67YkstAnYnGNqD5NBbVrgwKJt9f4DqChWXh02Dsf1Qz+43BJTp2lEjS5Yh/9du6Xn8jXh706kp9YPzMbJysmr+0RhTgCB71wy+PYbx+7Tp4rm3j/MPU6HAvOMzPulvaIjTClWgSqPKf+/d1fz9v7f6rjZBZYyaCDFM2kTGVKZwUDl7129UlnX1d7W+XXVS1QLecGeroV1fCgpSTAm+SM/ZpMpudJhLqiEfqDH6U0rFvI97GlXJXdNX+adxeqJlgZX1WsAZ77JJ5OM5bGPKRvOKL92oSJgf/CBAn/SxqxOap+wZNSAEHt0OjGJjLFw+OzVftqXLpCP/LyvNQLWofpXjTfF2wpdYIAM2J/TGMo3ZMyVtvOgi
 BmXBnaFW
 a4BYnXEWQSBxJGlkyZ1IsRfoPCUyEv8hrvfnNGcXsfe0B/wIiQ4fal3w/WOqRtw39UAKRkTB3nYw8aDHVIPb5NQ8csgaKRIcwV3pY3+aBy1udzVca47VCvC0bULXlsrhxHbPjaBXUeuvyRJUVrHLVfLOaDa/4EQLUGsqiWB1DOd1rIHq35ev/sTD8P3zX8q0ERoapFcvc2XKz7w76/5LqPbMMztMBvibtVpUssB1zh0rF/z2A2Fq3wD7vzEQiLlIK85izI7d75bzj+34lCAp7j3Qhn138oaTxwCkeph+nTOHmupgkctxbuKVT5mrFDjYyW64ChKHvnI8/pbwREu4rv8PtNp1pUiNvhwfL+axI/R53NCYSh9ZcvQlsPdzrnrKxaPh+Y17x866TaJB+8oKGjk10XrXeILhRiw9LC7E/1HeXo0YazgXk6m/vWjObShXZ9Od69ftXaRcnimn1nFMQqI92k+FB362EgEIt+FalNyKqk0vcAyeDx9CJjxiK246gwnwmNKEXbwTr0R2XRiMq1lrg8I0RXAZehC+c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============8781031005950137975==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> selftests/bpf: Test uprobes and fork() with busy mmap_lock

TL;DR: Nit only, in the new uprobe_busy_mm selftest: the local now_ns() helper
duplicates the existing get_time_ns() from testing_helpers.h and could be
dropped.

> diff --git a/tools/testing/selftests/bpf/prog_tests/uprobe_busy_mm.c b/tools/testing/selftests/bpf/prog_tests/uprobe_busy_mm.c
> new file mode 100644
> index 000000000000..30614e8b92cd
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/uprobe_busy_mm.c

[ ... ]

> +static __u64 now_ns(void)
> +{
> +	struct timespec ts;
> +
> +	clock_gettime(CLOCK_MONOTONIC, &ts);
> +	return ts.tv_sec * 1000000000ULL + ts.tv_nsec;
> +}

This isn't a bug, but could this use the existing get_time_ns() from
testing_helpers.h instead of a local now_ns() copy?

Both read CLOCK_MONOTONIC and return tv_sec * 1000000000 + tv_nsec as a
__u64.  test_progs.h already includes testing_helpers.h, so get_time_ns() is
in scope here, and now_ns() is called about ten times in this file.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/39710454342
--===============8781031005950137975==--

