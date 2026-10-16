Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1D91CCF2C1
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 22:59:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA8806B008C; Fri, 16 Oct 2026 18:59:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B595C6B0092; Fri, 16 Oct 2026 18:59:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6F136B0095; Fri, 16 Oct 2026 18:59:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 87E7F6B008C
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 18:59:09 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 17B23401A3
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 22:59:09 +0000 (UTC)
X-FDA: 85330006818.17.61D3D81
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5ACCB40007
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 22:59:07 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=K0iehqGc;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792191547;
	b=ZB94Sy/c3DEBc2X5bNa/edphDlRzyOth+Ny8EKc4qxtF3boXkUpjtypYU0JKXN/Ie1jbqu
	aldUberMMjgVyE9Zc3QR82/RL50aXt2TqtGgm+lsftJxyIRGYuMWrj4eWvJMEqHAJ8GFVG
	00NLTSrWzgHfHrflJ7C7Wg5ZiY9MYEI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=K0iehqGc;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792191547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2XIZw4yIu0sI+8wa1+fQEbc6VQXsqxREgHYBNQYWVKI=;
	b=LVkJCnNMOV1tpByF19dg8FlKX+EUUDIwXK1KsIikoiftvvCZBc7ACAhTYKuT8Dq0dvyYoM
	Nk6wkDnCQzhS6Cy+hdumj8KqFB2mnnKDMy4vv5Nn9afuVVvNgIXVY6ZWA1XvcPgDvXSW3y
	KcVbgBH855JPZfc9dpswzuFm9uVcKB0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B7F0D6022E;
	Fri, 16 Oct 2026 22:59:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25B501F000C4;
	Fri, 16 Oct 2026 22:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792191546;
	bh=2XIZw4yIu0sI+8wa1+fQEbc6VQXsqxREgHYBNQYWVKI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=K0iehqGcH6OaYxRdNrNEpl3rtaVqerqvgIjRBbpdxMovHc2N5nmd5gk9tKrViP3B+
	 CVCq3cr9444LCA25tUNknkzy+Gm2THEOSPkIVShx18Q3s7BRkV6c/EuTXDzecbAv+6
	 2CwNsL4Eu6qrnPjbXX8WPiP+LUgzjNiLytIU2bIg=
Date: Fri, 16 Oct 2026 15:59:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wang Yingjie <x-professor@outlook.com>
Cc: Alexey Gladkov <legion@kernel.org>, "Eric W. Biederman"
 <ebiederm@xmission.com>, Manfred Spraul <manfred@colorfullife.com>, Vasily
 Averin <vasily.averin@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org"
 <cgroups@vger.kernel.org>
Subject: Re: [PATCH] ipc/sem: account enlarged sops arrays to memcg
Message-Id: <20261016155905.2a659b7bb7d61f33467a3263@linux-foundation.org>
In-Reply-To: <20261016152609.2528805-1-x-professor@outlook.com>
References: <20261016152609.2528805-1-x-professor@outlook.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Rspamd-Queue-Id: 5ACCB40007
X-Stat-Signature: q7e7cmindt3d84e1nbhwcinhhgcfm1rh
X-HE-Tag: 1792191547-402711
X-HE-Meta: U2FsdGVkX18N0hvAThIp4u2bBeREu1bt0t+s7TPKuLf/GVTixXzbOsS371JfeQdgMdrRwxjyFGJ91EjgQQ5Udd8cNyc79du8Z7dh8fqWfCa7BNydeKSBKFA10oRl1D23VBJMK/ccNzhYWSCSNsGp5hu30J/dXqPLwrXwP59rRcWp2NdRpi4DRyPxJzNy3G9fToVti/esT9O+6x8JoWNxkp+EEoxpkot6V3SXO4d0X9YmXdc/huh9vUOcIMU050JfzYpKJkpWu0qqagzJR+T+Y0CZZnrgzcOZCSRg5RjSaxvrO60PF+1h1NY6vtSSKOy8FkQPU+2RapTSvlqNm+Ef6YVS7xy3TUeJryEG5NgXNJKylFtXY98O+KuaGDEG9ZiHYgwS8QZERRT99Q2ItDV15uhX0CoHzxjPDBn6mWkXxxxzo2Ap7CfJVVyI9w3OtzEDNGLo5L/7DXfyjFvOibNQrgBY3+OWl0SSWc2+k6nCb6a/SF1AGs/21NC5pgxGX8cD8J9ihUxWguDK/rsghVSY86uRiAR6MeD8TrJ9wDQCoc03fNZxsFS785fG4AaE4uxvBqzLWV5bJ84DfqE8MxYpIdRpxsW3RW0DpoxhXkhtq2nNBdHzSvKQhNZD1dIZYpOcImMugg49B+dwjwhjWt5MJt4ENNyuTc+tKIAplNcyete6tcsQCpLh3tDADz5aru4XoJMpCgqN81BsemEhngNOwPCgy9pJ2rprwWtuAipxEBc7Ptwh/qLTtgVE+9t03IWbq3RuebYEjVEMacLYRXFBfmQs7o02IZBFfp/k6kQPm+faY2pARqmGEcqNw+E0sd97h6Kbc47yr2YOiu7ZHfkiWIUzuosVveU/LstQwWdEhD99tC5zRg9GGSsp6XW4aXwF84hMYQCoyr0xX8hsNR4tKZiMDRmnhz4Pue5AsffXlFnR1wwalzG/CnnEPnW577RsprB1egT+n39VX2KejRl
 fM1Dr8s5
 WD3jcCQxlcEGXg7bfddHS2eDLmOakCbSK6IX34Ho8+CUZiOmsLbE9kZu3y/Vn4ot3T3INZ1iMF0bRwI1sYdROREq1xj9DaRLrbPK4VLLriPDVnwuxucXU9stfh1cP6m8/ZsR5uFHN7PGDp+FYkCK748z66/xc/T+/RRmbsJwmCAu1pYpDNHQXainYMIG3pg23NsDbc9X9T9Ly2VQa4XGKof5LM/E108XbdRPy6/rIPwwSW9PySQHsP2R9CAOqo2r/c72X6Qp4+AhF/6/1Aq48EmvFXHfEV5F2SM3IiplMPyHqB5AecVyauWE17w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(Alexey, Eric, others: please weigh in)

On Fri, 16 Oct 2026 15:26:11 +0000 Wang Yingjie <x-professor@outlook.com> wrote:

> Commit 50ec499b9a43 ("sysctl: allow change system v ipc sysctls
> inside ipc namespace") lets an IPC namespace owner change kernel.sem.
> The SEMOPM field defaults to 500 but has no semantic range check.
> 
> do_semtimedop() allocates nsops * sizeof(struct sembuf) with
> GFP_KERNEL. A blocking operation retains that buffer, so a user can
> raise SEMOPM and hold large attacker-selected amounts of host kernel
> memory without charging the calling task memcg.
> 
> On the current mainline base, one 10,000,000-operation call retained
> 60,936,448 bytes while a 32 MiB cgroup peaked at 909,312 bytes and
> reported no limit event. Sixteen 1,000,000-operation calls retained
> 100,860,416 bytes while the cgroup peaked at 1,310,720 bytes.
> 
> Commit 6a4746ba0619 ("ipc: remove memcg accounting for sops objects in
> do_semtimedop()") removed accounting on the premise that the buffer was
> at most two pages. Preserve that default-sized path, but account arrays
> larger than the default SEMOPM value.

OK, I think. But...

> With this change, both test configurations reach the 32 MiB cgroup
> limit and the caller is terminated by the memcg OOM killer before it
> can retain the enlarged arrays.

Only if memcg is enabled and the task's memory cgroup has an effective
limit.  Otherwise we can end up handing out idiotic amounts of kernel
memory.  Memcg accounting isn't a substitute for limiting the
allocation size.

> The sysctl also accepts negative SEMOPM values. Since nsops is unsigned,
> SEMOPM=-1 bypasses the intended operation-count check.

Let's fix this first. nsops is unsigned int, whereas ns->sc_semopm is
int. In the comparison nsops > ns->sc_semopm, a negative SEMOPM is
converted to unsigned, so SEMOPM=-1 effectively sets the limit to
UINT_MAX.

I'm thinking:

- Permit init_ipc_ns.sc_semopm to be set to any value from 1 to INT_MAX.
  This preserves the existing ability of host root to configure larger
  limits.

- For all other IPC namespaces, permit values from 1 to 1000. The
  documentation has long recommended 1000 as an upper limit, although
  it hasn't been enforced. This would be a new restriction, so the
  changelog should explain why we're introducing it.

- Validate the new values before installing any of them.  The current
  proc_ipc_sem_dointvec() updates the live array directly, and
  rejecting an invalid value afterward would leave a window in which
  other tasks could observe it.

- Update the comment in include/uapi/linux/sem.h. The warning about
  physical memory fragmentation is outdated now that the allocation
  uses kvmalloc(). Document the new 1000 limit for non-initial IPC
  namespaces instead.

Ideally, a new IPC namespace would inherit its parent's configured
limit, but currently every new namespace starts at SEMOPM=500. I don't
think we need to change that as part of this fix.

Then please redo your memcg-accounting patch as a separate followup,
with suitably adjusted changelogging. That would provide additional
protection for legitimately enlarged allocations in the initial IPC
namespace and for allocations between 501 and 1000 operations elsewhere.

Thanks.

