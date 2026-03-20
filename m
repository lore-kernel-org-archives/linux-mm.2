Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E3D81098781
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:47:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E47F06B010C; Fri, 20 Mar 2026 09:47:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1FC86B010D; Fri, 20 Mar 2026 09:47:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D35B26B010E; Fri, 20 Mar 2026 09:47:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C28BE6B010C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:47:55 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7470B1B6E22
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:47:55 +0000 (UTC)
X-FDA: 84566569710.07.1EC586A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 94BA620005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:47:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NmvzAFql;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774014473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fsse7E4lr1akNPXn+gA+KJM2gKVQErA+AX6lGBmSsgw=;
	b=R/kUgz1Hel2SGe+LMTRp2HFmsyJUyEt0DhB7NT8Y/Hz/xBKTZ95S0Z+2vP09CllrdVT2R4
	R64B/HOLLeQlWjxMDCbEYoyhW/yBH/r5e6VufCXOrCjeKii6kJJfmzrVntcZJAn4vu4OyT
	kyJoyg7DCLKJX+ZvS+DcGhVlsiYUKXo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NmvzAFql;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774014473; a=rsa-sha256;
	cv=none;
	b=2D0uKYc3uQAkM6XkyLYdWZbuCcK+7oLV6VgR0MP6E+w36rcW62SaJiBOYyC481CW1b2p8i
	HvfjrjZ33glgTqdph8CVCiDoYb4JcDOfTJFUF+6IvFCySo/4BGRGX7aqNws6x7kG4BtS/N
	rzCZFIZ8/hqFTO2PZk1Ic37jvl/ve5Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 619DB41AF1;
	Fri, 20 Mar 2026 13:47:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33F59C4CEF7;
	Fri, 20 Mar 2026 13:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774014472;
	bh=1yj3+8JgkDHlZE7ywicfVi+R3aRnk7415/Uk3keT3Vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NmvzAFqlIF1Sd2XV6mXt4Pno+pDkhmq1oWPGDeuUIhUSBsW2XE0vWcp9ZB4tOkdj3
	 bLl4RsR0KwwNepoNGRnJuDs67bGOos+dE5N7lLPsoilCBKEJkUzHWQlJce274btbjp
	 iUK2GJ0Jt3bNQ8YmNS4Xar8NdnlwAVIbN776zHIJJRnvI7SI+oW72LH6i/4CiUfpvl
	 NYHa85yZo4xMJR2v5tgZu4gdLmmIqnCPxDrTf+GlGJ4U9hz9Db9BKZ5qKZRo77Y3oP
	 qA7levsoBLBWpLMkAHedaD1hdLFhI5/pOKNw5PwcfTJm10mv9rCG4SGzLOy7Qs4yMk
	 K+AyxVJRpz75A==
From: Christian Brauner <brauner@kernel.org>
To: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>,
	Kees Cook <kees@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Jan Kara <jack@suse.cz>,
	Oleg Nesterov <oleg@redhat.com>,
	Aleksa Sarai <cyphar@cyphar.com>,
	Andrei Vagin <avagin@google.com>,
	Kirill Tkhai <tkhai@ya.ru>,
	Alexander Mikhalitsyn <alexander@mihalicyn.com>,
	Adrian Reber <areber@redhat.com>,
	Mateusz Guzik <mjguzik@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v6 0/5] pid_namespace: make init creation more flexible
Date: Fri, 20 Mar 2026 14:47:34 +0100
Message-ID: <20260320-abend-kauen-5279c838c15e@brauner>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260318122157.280595-1-ptikhomirov@virtuozzo.com>
References: <20260318122157.280595-1-ptikhomirov@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1677; i=brauner@kernel.org; h=from:subject:message-id; bh=1yj3+8JgkDHlZE7ywicfVi+R3aRnk7415/Uk3keT3Vk=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTu9f8x7fPlWKEKRqPy7FSe6WxneNayK6jat6yYoKLQq r6bqba9o5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCKLfjIyHAyt0Y/2vHFyef3W 1pNJTx9vLXtu5vC1ZkNS3HeP0vviUgx/BScf/mamosYoX/1vf5bOho6mT6UHyy7Le4pnODxntHz IAAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: z7h7ngi3kk8ga11pwnturt8anw6ndidw
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 94BA620005
X-HE-Tag: 1774014473-300029
X-HE-Meta: U2FsdGVkX18OVlgSZuZ8yyaTS+E1KJS6hzdqlAIwx8T6pOT+SKKpbfoIwuQjt0xxPTHWeV6rgJpGqcXntARFMe2JumPM7f6MdIhNfzj0fUbZTWuHG7+YQH0u57AxW6bZ7jc8NjvPLSba/Ux1G8xZCl7TIQNXFS/qXk+QKY2Y7Tgc0j3vLTtDl7UWLO+h10xcHtTEpS+NqKdWn4A7+GiOcZm56iAb7TwDAUH4f/n1zdXTfcGL5nbsTMz2C+C1aIGlNYOw8fmKMCVpBY594AI8GhySd934Z8lrjs9MgjnvswUWPbbYbkE9O5YdVX63JvGPf87lO/e2yheRheA1+zE8uWwM3/I2ybEcI1TURPi68Ynpb28es4vXSHN2bOpf4mRMtLpyhaqUq+hn6iHeU4XkSB0Y0tvS2Vp31bH5V0MyJDY0v09Po7eELCNlV5WQBFvCeLI/9m87A7VL/GKa58sf0C/fTEHYDiqZ8oVozQttCdiU9wyCsHQnUQuQky0JxS2IehfJ4KfGAwAESjwtdC9jkOk5s/ot5f4GuhMi91o4kOLL9R4U3rlcEZ6OaDwsf3xtG5VSQmVmPeAH4YDNxFPvzMJHeBg05T1tN+4ZcMQInDFiXf5mwgqSvsO+HCDJrGp0JFzgjbmYnHNQ++ikVLTglPOCUf9sKVP6VOPUTuTzag8sNSnTuTafcIIfRH72nzFBzWYjYvKLQ3qrrQVSmmoMwFbDG2Lx4y8JAEr4Puhx8f1UUJwVh/bm3W/1tJw18wD9cBjkNkZft7X3/UVwgrNUeyp3/P0+orMwR6Dc2p7BSTZ+YSg06htTHRopYjuRruuYSOA7hGBrwOEcYVCKizQ97QzWv6qp4pe7K0EhDapsiN+afSTlBXsQ77Uis2ekRxptTcDQ9Fvs6TIM1UrKXv8kTuf8UkP7FSA6jJGOupw7GvQc12nuMh/bT6y3fN2li11MYu0Uj0x3hzOhDuH71F0
 5ArnZKWM
 bXbf04LL1PGpYh02uqln+nHdoo34reK26zTSTsdx6gaIljBEKoMletgHvbyThH9vh7A4Uq0Zrn174J5Bfh4at+8Tlyb5vphIZYDCtHb7sJ77Na8pc09nrD5LY6w+WJOoLkHm67R+PKTWPUKt7STfS2KS/ztUa45Ikd65GGq4jauwP+zKJYfSVT8g97ClJRzWWdGd0Jih8IzgzGC4DmqIFc1/vRqyeuz0IJyIvOmS6sCCMXdk0wjm9nfn5557ZIh/TsJOhJaOc5MD0+txzRGOp1X24bWoPIV7kaSOl7dJjCT6yXOVyRExbG6c7Tk8DTyqHLWZj68gCsmei7B0Pxz0sSBhGDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 18 Mar 2026 13:21:48 +0100, Pavel Tikhomirov wrote:
> The first patch properly annotates accesses to ->child_reaper with
> _ONCE macroses, to protect unlocked accesses from possible cpu/compiler
> optimization problems.
> 
> The second patch makes sure that the init is always a first process in
> the pid namespace, previously this was only checked for set_tid case.
> 
> [...]

Applied to the kernel-7.1.misc branch of the vfs/vfs.git tree.
Patches in the kernel-7.1.misc branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: kernel-7.1.misc

[1/5] pid_namespace: avoid optimization of accesses to ->child_reaper
      https://git.kernel.org/vfs/vfs/c/d9c857aee2eb
[2/5] pid: check init is created first after idr alloc
      https://git.kernel.org/vfs/vfs/c/39c8806e2d88
[3/5] pid_namespace: allow opening pid_for_children before init was created
      https://git.kernel.org/vfs/vfs/c/a3bdc23ba8ea
[4/5] selftests: Add tests for creating pidns init via setns
      https://git.kernel.org/vfs/vfs/c/7c5219e1a606
[5/5] MAINTAINERS: add a new entry for testing pidns init creation via setns
      https://git.kernel.org/vfs/vfs/c/2b46715fd9ec

