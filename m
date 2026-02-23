Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 008A3EEC2A3
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 22:29:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C76E6B0088; Mon, 23 Feb 2026 17:29:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14AEA6B0089; Mon, 23 Feb 2026 17:29:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 056CB6B008A; Mon, 23 Feb 2026 17:29:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E38306B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 17:29:02 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A3D65139F9C
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 22:29:02 +0000 (UTC)
X-FDA: 84477162924.15.C7D5E35
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id E60A7140007
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 22:29:00 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y0AE6S8S;
	spf=pass (imf09.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771885741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8FniOJfMqck5NjV3XUREjoWtodA5PQ+Kik0c/wR3Gsg=;
	b=AfYdyKCR3LsgC8n4VkSph4ZjKY6yOw7S0xVSpF1vZBC1fu5R5SN9/aF8gIR5998Z2+pDOi
	axwgXVBF3vcbltqQhAfOLS9J+gP0XOJTxX7IN7uVWALVMWj153SvctCylCQWSX5Dvc+E1D
	wLAE1e0l641V1fI8zzZFWBC9HdkwXeI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y0AE6S8S;
	spf=pass (imf09.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771885741; a=rsa-sha256;
	cv=none;
	b=7FVlKG/xKP54MD+6ELQdSz8ONR89C1dRGNGCgV+31WzA4oW7Enkx20xgE03GdLzcHTc3jA
	2+CjD+8wXQc3tJtoDL3U/LHgQBaiMxSDCXWO9o0g4ztlQAsie0VRXoJwmGo3VYwUMcAc0O
	84IkkT02u8W7VQGqb9LfaKYa4cAULak=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DC21E43D92;
	Mon, 23 Feb 2026 22:28:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A79C3C116C6;
	Mon, 23 Feb 2026 22:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771885739;
	bh=9rMeHiSNAtJk2NgmJptISn2xhvOOSYJ3+ZDMUHV0gRQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y0AE6S8SLcePt2dotW2vBCvk7LcxEiOCdweEhNwBS2jfdGn8FCo0Tm20b43MsUoIN
	 I1oZIH17J97MQ5hINoxSpHoirGgVXyeQhgB+tRkM22EjBb+xYksPnlENl/TYp4ky7e
	 MuRamCV4itnPJSpEPDB1OyTKQrlOpQMUCWoRrMI+GgNvaNMUOK05h01Iwq8I7kHpWD
	 8O55s2Lo5H+vcux4HozO0MKos86b8AFw0oNDkoMRQbIIWtDmHDge+kGfi2YzspBNOZ
	 wjQ/l4CZW/pUscPF+mLtcdQ0OlwrFuoYTpdj+v4iMicAHx16ZlzMg/nKXw8CNiNQdC
	 t+EnzsBT0kK5w==
Date: Mon, 23 Feb 2026 14:28:59 -0800
From: Kees Cook <kees@kernel.org>
To: Andrei Vagin <avagin@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Cyrill Gorcunov <gorcunov@gmail.com>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Mikhalitsyn <alexander@mihalicyn.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, criu@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Eric Biederman <ebiederm@xmission.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Koutny <mkoutny@suse.com>, Andrei Vagin <avagin@google.com>
Subject: Re: [PATCH 0/4 v4] exec: inherit HWCAPs from the parent process
Message-ID: <202602231428.CAF9D1B913@keescook>
References: <20260217180108.1420024-1-avagin@google.com>
 <CANaxB-wNJWhyM7JUKT3y0Wp73=+8XZRnSkdudxqDwEo2FaJpwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANaxB-wNJWhyM7JUKT3y0Wp73=+8XZRnSkdudxqDwEo2FaJpwQ@mail.gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E60A7140007
X-Stat-Signature: 6sek11dt1tey1o6aazfqo11ytiujq9ys
X-Rspam-User: 
X-HE-Tag: 1771885740-10640
X-HE-Meta: U2FsdGVkX1/Rp5fQaXVZNErBKhu41p09Y3B4XP5haLcNX8EMV+1JqSt7ncqtg7CGsA+AiUtbMzzkvRtgZuucXclgl+eE0BgiT6XuP3mAlipXKA17zKGADu6zP+1F1ezEUKxkv4TBaGjyJak+UfC/GHNTiPYkYocGZB06PAtnqm0gGUsxKYTrC0Wj0JfcR8jCuQ6lNXhoGXcFYdQ9D6O3B3Hj22rWCAA9B35Nj7pBH1cTWw3uMZkh0E1Yh0LE8vXRqfbqMdO4EKLLr+uMi4cYjQGwqIz9uhiGAOGUsxqubCMKGETjvfPjgzfpntkHNjGMFPlzp0VXGtMMdeEVzG7rnBK+stUPRXBwzlfQsHXgt7sN8/P0y0f+xMdl8489YNDu8sQ7cSInjdY00rtI7bOxt0GKPuPeqWCNR7Vs0s+37q5S/2aN0sZ5eSe3GOfMy95IPHnkqsMECTE9waDgD3lC/RSB2DYseBKRklEeLXCs5AmjIhqgV9cHJZk3PJSGRKSfCL3cClpXeuSU0P3cUXiik67Snc3liUVTsbNNxKxZHDAC/ttF+uMCO5flQv1Zh9hoCt5pR4HrTiDIDKp4QrQrhQbXSqPgWlFisNwreS23WItpZ/DLgqxRI3IMcDhvg2jEJDz3PlHYw6J0tpCoTLQgxs3b+fNs8M+NSmocR+cPEpxr8f0vr2IHUPUiUNcwYjn+o6k56PJwgdS/+pd4tMeXb3qnYHNN14USVJex41hrTLTmvHlDd+1l/cjjl220GiKbbPcIwpR7JDsT4Gq0iKyNgiZzHlpePw4aiWYcyEaERpdy8dYi3g6BvKqKdok4YuerBbJhAk2o2N2rEvZM5rk9QuE8xek7X84jLxHYgOmzQ3vds68NIu3MRJKFQHbJvhC2lj5tgnWhlNUtXpANCr+qwK6tMbP0uhSiph6fB8C3UIY3qFHbgSCPzjKbdWTHY5ENAwjQxh72mvey3hxd786
 igOF75CY
 /9jxSXWL29qh4emUVA5Bfc5AHiGqRsp68x3frXn5xcxNguaUrsIGn503Q80lxCzTg0EYfttI4Ia8r9z2zA2mBjKTARdQKfy2MAsy0UAmjdSCNCPgfLDUnSK/Bv1lVyL5/6/jtukHq3CCEUNq7ChjKTfAtYLt3YH+kmIGQXWnUeCL92XkJ58Oe95AMu+cA+VFOmU9W7ZECqHHvvDY6HirXjFJVxK5IgedwYjlMKpwXnFtRTJ2KqkjwRJaAJcLJcZ9eD+IXXJapWBJbjwWkU/rh7jV7aXxY40iMhr3dfeE4weTTSa8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 10:29:00AM -0800, Andrei Vagin wrote:
> On Tue, Feb 17, 2026 at 10:01 AM Andrei Vagin <avagin@google.com> wrote:
> >
> > This patch series introduces a mechanism to inherit hardware capabilities
> > (AT_HWCAP, AT_HWCAP2, etc.) from a parent process when they have been
> > modified via prctl.
> >
> > To support C/R operations (snapshots, live migration) in heterogeneous
> > clusters, we must ensure that processes utilize CPU features available
> > on all potential target nodes. To solve this, we need to advertise a
> > common feature set across the cluster.
> >
> > Initially, a cgroup-based approach was considered, but it was decided
> > that inheriting HWCAPs from a parent process that has set its own
> > auxiliary vector via prctl is a simpler and more flexible solution.
> >
> > This implementation adds a new mm flag MMF_USER_HWCAP, which is set when the
> > auxiliary vector is modified via prctl(PR_SET_MM_AUXV). When execve() is
> > called, if the current process has MMF_USER_HWCAP set, the HWCAP values are
> > extracted from the current auxiliary vector and inherited by the new process.
> >
> > The first patch fixes AUXV size calculation for ELF_HWCAP3 and ELF_HWCAP4
> > in binfmt_elf_fdpic and updates AT_VECTOR_SIZE_BASE.
> >
> > The second patch implements the core inheritance logic in execve().
> >
> > The third patch adds a selftest to verify that HWCAPs are correctly
> > inherited across execve().
> >
> > v4: minor fixes based on feedback from the previous version.
> 
> Kees,
> 
> I think it is ready to be merged. Let me know if you have any other
> comments/concerns/questions.

Yeah, I think it's looking good. I'll land this in for-next/execve after
rc2 (a week from now).

Thanks!

-- 
Kees Cook

