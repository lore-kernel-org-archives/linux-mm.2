Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07C5FCA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 15:56:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD15F6B008A; Sat,  3 Oct 2026 11:56:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D82EB6B008C; Sat,  3 Oct 2026 11:56:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C99626B0092; Sat,  3 Oct 2026 11:56:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A40D46B008A
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 11:56:41 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 19631120A51
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 15:56:41 +0000 (UTC)
X-FDA: 85281767802.21.6C293B1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 87E9520002
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 15:56:39 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UPGAYEhX;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791042999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NzhxsV7jtoLr70i/Q5PxTj0BUfUeVGbJ6ybWMLKfAzA=;
	b=W2wy+tZVadSYWoTqb/U0pnyIlNbG0Z0xEu8jhgJQd8grvmikipZ96mY6yR3VmpGSVkWyev
	uTgBWB8ZgzSPXf8XOk/mdgAUfgaFdDcWJhVlgHr29z/ofsDNP6BNAIkD5N9Qbqk6SCCBfw
	teddR/1WD4Qyrwr5O7CGIq+swK/CzB4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UPGAYEhX;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791042999;
	b=PeAzqQAKCBaufYCpPZ4tog3XZBKlu1iX5/G+CP/J/CopQy040nSM1HZqPtWkFFQ91FI5Lt
	QI2LkVzQUYjMhnmDDhNtYFL0am8pQvUpdwI5XEEalOLAeSkHrkqPr54CBkEDHbRMVsjGh0
	3tKkItrKOhjgY6gASN6bWuDjaG/C5M8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BF99560D99;
	Sat,  3 Oct 2026 15:56:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 679141F0089D;
	Sat,  3 Oct 2026 15:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791042998;
	bh=NzhxsV7jtoLr70i/Q5PxTj0BUfUeVGbJ6ybWMLKfAzA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UPGAYEhXKD563KxiLn5ax0iwVPtf7O8U/4Rrb7nteA/xQiyDEM7ymdL3mWaQ4HF4v
	 qOfW01Y+a4iSnEmajSp0nHa77ZjyUH8XNKCKdf2dw9hYFa2HTBOg61IDwMtyTWcARE
	 Ep54D2ZuvN89OY7aCj2sH9wCDrdnhPBt2YZOqyq1CxkozpJEX2GC0tKNR5oUrSabhV
	 Z08QwcxH0Jzk5Yg5lBF40TagpG5a0CDp7iyXTaF7Y+5zYsaDi12VW17ywuDgGaKufs
	 WrJTYFodEGflFSOWoLnRFCY3cLC0pAzd9dkj9XWX2KMtimdQ0RDHV1njziP5LvrXDo
	 1xkenDJLThOTA==
Date: Sat, 3 Oct 2026 16:56:32 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Ameer Hamza <ameer.hamza@truenas.com>
Cc: rppt@kernel.org, peterz@infradead.org, akpm@linux-foundation.org, 
	david@kernel.org, mingo@redhat.com, acme@kernel.org, namhyung@kernel.org, 
	linux-mm@kvack.org, linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, 
	regressions@lists.linux.dev, stable@vger.kernel.org, 4ncienth@gmail.com, sashal@kernel.org, 
	alexander.motin@truenas.com, caleb.stjohn@truenas.com
Subject: Re: [REGRESSION] secretmem: SIGBUS on memfd_secret() pages while
 perf record runs
Message-ID: <asEllR7if-J3wteg@gremlin>
References: <20261002175651.811343-1-ameer.hamza@truenas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261002175651.811343-1-ameer.hamza@truenas.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 87E9520002
X-Stat-Signature: cze19rqtrkk4qs5nu91qn46n81xez5ax
X-Rspam-User: 
X-HE-Tag: 1791042999-987841
X-HE-Meta: U2FsdGVkX1+5KvwSGZ8iJ6ePqOmMBFovewuLmaL4pM0GP/DBWJgHQOa5KovI1T601O0ND5AsyoVuMFDTprt6J+tj5+UYIUeg7lIvvfUh31LGURJ4AarWKUPqrc7Oa03Ccpd6xvdv18/f1K4VjsMkyvJ1aTCTxIDOjGPhZpYqZ6bqUeiXAA9hNUFectJlN9UV1oXFMSXsIsb0RGID8lrb27oyQM63j1gQTseT/Dppse7WiM3AnSqRhDVNrJcEqKD8QHpx2wQealCkiDUj0E36Njzd7FtOv1luUtNlqxULveLMECODFa1XR1GH/xO4JbROryYRS+9Op6xnV4JXPExryTw07vZtqSLcU7qrjPX+jbILh0AIVr5eRrAdqQUQs+OkaNEW2UYB11GyYnUJMchc9cFvh6oZFRwlkOAKYaL9uOfZEcJemIlcXvg4mOWL6Qt7Idxw9mYJS8SAgmQazIDMcNcT0apuVti4OuP4E9mDEuEJNHp93/neovmGkVIrWcSCY2o2L51E0BTjJR0PrPnUMEr22mWPujxSABAj9r8MXpB+lAFnE8wE4/gpxyv5FmU/VJdXuH/zvGHRPM9yiK21+O0/ry+jUu8KJR+cbvhsZZ2Qk3NgPb/Hj932V+gcxXcyFjtFS0yzqBdILel1X+ijgdnlN7xUD4MJk3Tdl3z0V6HgS5OwKh1kR9kDg8gifWqNpKXJU0CXlKRE2sgBHSGUMuj3GZnQcHMBN/Y/Tv5pCHqzbDMRRjW+b9yuc/7v1dwBg/4jEdBSUUdsLVrvHpmQApIx8qCULItE7B3Lg+iZJOo9BYrBXg4wKbEvi/dx4TNcdSUnRyHlNTQ1UVFc0VZuU8LvfOgTxouwKECrXcI+qHGyvCn0iRkZLGRfkELj43bmiwK+k4kUMOyYfsJzO4O9yXGabOg2iuT058fZzyXdTI57rqEON6qerIuQ5HXUZc9MoyqvvorzrdIzOxmyyQC
 LbF5IcDZ
 S35hLc9+ozu6lf+vXNDBLBWD9zrF6UhTW8L5uIAcEJEPVTvRw3dD81BUTHuxPF0ia5/RIKE6IDIBL5/iyvKvN+osN5lfVujAm3pmkAyWDnKkFiRJLhX/rHNUMSkrAEH1nHwUXCMSJBeGvoYeQ/TTygqUuSmUOEk2WLjOX+ezissPueLPIKwctZmid1ScngB33IgiqWysQXCvthVOllk+tGkAEJXHnYnXHBPwST9URpudf30Gh6VeeL5G7djzJMHbRm9DLyu97GGVUF1lMuInqZWudfdQG8j3Yy8/Au+lnh9VpESJxOY7fRk7SMGUMR80LD0wo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 02, 2026 at 10:56:51PM +0500, Ameer Hamza wrote:
> Hi,
>
> Since commit 97d34aa65c29 ("mm/secretmem: properly account locked
> pages"), in v7.3-rc2 and the 6.18.52 and 7.2.5 backports, touching a
> memfd_secret() page for the first time fails with SIGBUS while the
> same user is running perf record, and read() into such a page fails
> with EFAULT. This happens for root as well as for an unprivileged
> user running its own perf record. It reproduces on v7.3-rc4 and
> 6.18.52, and the same test passes without the recording or with the
> commit reverted.
>
> The commit charges secretmem pages to the per-user user->locked_vm
> and checks that counter against RLIMIT_MEMLOCK, with no CAP_IPC_LOCK
> exemption because the fd can be passed to other processes. perf has
> charged its ring buffers to the same counter since 2009, up to
> perf_event_mlock_kb per online CPU, and only what exceeds that
> allowance is checked against RLIMIT_MEMLOCK. sysctl/kernel.rst
> describes the allowance as not counted against the mlock limit, yet
> it sits in the counter that secretmem now enforces. perf record sizes
> its buffers to the allowance by default, 516 KiB per CPU, so on 16 or
> more CPUs one recording uses up the default 8 MiB limit on its own,
> and on fewer CPUs it leaves correspondingly less for secretmem.
>
> Reproducer, as root on a 16 vCPU x86_64 guest with the default
> ulimit -l 8192, while "perf record -o /tmp/p.data -- sleep 300" runs
> in another shell:
>
>   fd = syscall(SYS_memfd_secret, 0);
>   ftruncate(fd, 4096);
>   p = mmap(NULL, 4096, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
>   read(open("/dev/zero", O_RDONLY), p, 4096);   /* EFAULT */
>   p[0] = 1;                                     /* SIGBUS */
>
> The commit closes a real hole, unbounded pinning of unevictable memory
> by unprivileged users. The question is whether the perf_event_mlock_kb
> allowance is meant to count against the RLIMIT_MEMLOCK budget that
> secretmem and the other subsystems accounting to user->locked_vm
> enforce, or whether perf should keep it in a counter of its own, which
> would leave the hole closed and secretmem usable during a recording.
>
> #regzbot introduced: 97d34aa65c29
>

Hi,

Thanks for the report, however this is not a regression in secretmem.

The field that is being used for tracking the allowance (user->locked_vm)
is used by everything-but-perf to track against RLIMIT_MEMLOCK, but perf is
using it for something else (pinned_vm).

So this is a bug in perf, which should use its own counter for this,
AFAICT.

Actually it seems perf invented the field (user->locked_vm) to calculate
memory that actually isn't mlock()'d, but is kernel-allocated and pinned so
treated 'as if' it were.

It tracks a per-process (rather than per-mm) RLIMIT_MEMLOCK allowance plus
a 'gift' of extra available pages which exceeds this.

Every other user since is checking against RLIMIT_MEMLOCK (and you'd hit
the same issues with them too) - io_uring, MSG_ZEROCOPY, AF_XDP, iommufd,
s390 KVM zCPI and now secretmem.

So this is a long-standing bug it seems.

Other things:

The SIGBUS is unfortunately necessary - since the region is populated on
fault, it is only then that it can be determined whether the limit is
violated.

Not being unlimited on CAP_IPC_LOCK is also, unfortunately, necessary to
resolve the security hole - often privileged processes hand out secretmem
to other unprivileged processes.

If those processes then didn't apply the limit check, the mitigation can't
work.

The commit message goes into detail about all this.

The way to address this right now, as I see you've applied yourselves as
far as I can see (in [0]), is to change the limits to account for this.

I will work on a patch for perf that fixes this specific issue.

Sasha - you can re-queue the fix. I will send out another fix for perf.

--
Cheers, Lorenzo

[0]:https://github.com/truenas/truenas_ros/pull/128

