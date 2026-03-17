Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60850FB5EAD
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 14:41:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A55276B0093; Tue, 17 Mar 2026 10:41:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A05BF6B0096; Tue, 17 Mar 2026 10:41:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 942766B0098; Tue, 17 Mar 2026 10:41:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7EA4C6B0093
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 10:41:16 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 30A5A1B6F5D
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:41:16 +0000 (UTC)
X-FDA: 84555817752.09.A59A9B6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6F5E84000C
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:41:14 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IWUB9FcZ;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773758474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kB2C3F7KizvoIdwP/HpDsgc4oUMaayreiiCDCoqQUz8=;
	b=LUyaSRtf6QFpkCflAnQtGZDGZ6yliqJICCHX1YvA57lUusuYfobFJJ3PGux+66GuZGyrga
	xCDAdPodFKChjoXmjYaax+0YI5Dfx2WHOPwFHrIjBOtG6+3NdM3yL6SUo8Ed1JtXq/ONdj
	JFzhda1GvM8+9ghZqozxRZWDrdt8xWI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IWUB9FcZ;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773758474; a=rsa-sha256;
	cv=none;
	b=Gyyi3/f/Lv3qf2FiKaON3icEmureDhxSYkcD5BKNgfTSsf840GGuqmT+bNV8OcbRKbSbh2
	iT5/YavU11GQ8ycaoHIC2YOlSdHiblEVXK0aPHxNzHoPu4JJXU+sBP2/mcmWxQ2okMin9j
	CZJW3D01zosS814CsRPO4cWLTnnO+CI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 343B743430;
	Tue, 17 Mar 2026 14:41:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 842B6C2BC86;
	Tue, 17 Mar 2026 14:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773758473;
	bh=HloLWblUXfx/tXmUTea0CrvTD8QLr6l63/rB223Sfn4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IWUB9FcZEm1B+/N3hiautZOJHwc0koqlxINQxuwl6SZe6mZ9KSi64b3pYhrMN00yC
	 aj5+T4JrWz4AU43u+eeq4+jIJCjYWp46m53yzDAD1aGs06Neto0IUhbKxeTjisOX3+
	 OHbL/WyjkIZ3qw4vlcJ5bOjSfxpQvxzotHnma4ohJi8gunBcUqzGJMxCc3FaH2dz0x
	 0a9QMPJ3xp+v99KMpGxBTqh3YbhFeArT1pVO9Z0mPMYXXUgd3uCyh6zhs4rRhpe5X+
	 xtWAtX3ZmyUFnSfZX/0DVo9asvNmIg9PU/4QidXMbut4F2mxMIqaMKHa0C+5UU8zv2
	 9e1DkZM6wFkkg==
Date: Tue, 17 Mar 2026 15:41:06 +0100
From: Christian Brauner <brauner@kernel.org>
To: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Shuah Khan <shuah@kernel.org>, Kees Cook <kees@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Jan Kara <jack@suse.cz>, Oleg Nesterov <oleg@redhat.com>, 
	Aleksa Sarai <cyphar@cyphar.com>, Andrei Vagin <avagin@google.com>, Kirill Tkhai <tkhai@ya.ru>, 
	Alexander Mikhalitsyn <alexander@mihalicyn.com>, Adrian Reber <areber@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 4/4] selftests: Add tests for creating pidns init via
 setns
Message-ID: <20260317-nullrunde-deckung-b53c8cf46bc9@brauner>
References: <20260313111014.2068913-1-ptikhomirov@virtuozzo.com>
 <20260313111014.2068913-5-ptikhomirov@virtuozzo.com>
 <04c179a1-d3e2-4a87-a024-ce1b144f1b60@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <04c179a1-d3e2-4a87-a024-ce1b144f1b60@virtuozzo.com>
X-Stat-Signature: mero51za5w3obkw58htdqnezmtasiio5
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 6F5E84000C
X-HE-Tag: 1773758474-972511
X-HE-Meta: U2FsdGVkX18Em+ATxE69Om9Oqk7JNbBSES7qekzTsstnKPpRz2LyVXiTo8QHr5pXsXRgIs9y7S3UMDMopIcRfrqXy6gcqOp8Hw1KaSm7rNPnYSzGjdrV/bUqLXDLG9Gb8URgpzGV6zABsapoX8VVYJL/JlAf52ER1leRxduyQQo1OOnvQ4r9//nG6MsBYIoSI6ys0lR0xS8kymvtlWKF8dxzBgFI6UK2QTL8KidFgLVUC3/L08OXkWAv/FrBsN0Zuszly9YXpGLWz3fNh8CyZh+zx394bb+gfWkvnm0tzDHMN471j15J/Laj+u+BfIliEDzA2zcVpLTF9+jVvw6RLs8rsq1mtqsMifgJ+3dNz7q3uetB1S8E5dawdabDpVRGCJLwuw2s6eppTHg1exkC8JnLpBpH7Lkqx3wiDs5zRhRW1WNnHQThhjxD2cIkHg3l6ZFIs19zp0L0LsUWkl4zUKoNTfW+hfpiOvduTMxixh8Gbo8HLp8OB8qFMZ5EkhfO1YjvDa8PBUSsTdnztzYTWH/SPNURhlbMPG6ce3M1lPhXy3Piz4nY0r7oeXCeCgt2zGmhrt5cGej+ekzVzfEaQfol3+Sy71weH6d/X05ZciMroo3yOmSfAmoUvxJZaoIUobjqcdYth/yPt2cfZXGj4A2PDiBLkoe2loUk3+e2dOZSEWfa419oMPQkVKmAXa3TzZweSVucw5WsXjvfFBBm2Absw7Gd0UbYgOCg765lt19vv4BGoRz00pUq3UDNg0u1/LFTWPWNLwsKoNlaYGCZLjC5Dkj3pAEEys7MRYCN/NNPoMqtJKh7X/SDiVYbfidP98ZLfg9cAQ4KVSW2pjhxrDCmfWJnEQ4HwuG3gokj6rTYnrXR73aA0rKttaLkYkgPylowjgWvxZTrKUnKxFHey0xMwXST4Wi47wKWXqG07NAIzHbnoBWO55xci6GWmVvyzpsyI/UUrPbVFZXjV8y
 X1DObUHR
 IZitGB5QjtA9daMklSMHe+wVkku2XFXsfw0RDib1WPCbnDkvwtdCTmxVNz+Rcrva69ry5SxL7oO4mEMFGHHJPI3rCqUkMrdlcJcqSxwSccI3K6sG2pRLZysrnZ2wT9FjtwSfj0tvYUkOwcLefL/JjV2P8xnoGXHjOxJdAs++ETfYEQyxacRPNLUW9Mu3zDnR2XSHPnqOqdckC+HxCevH1OLH1w6e1jRfCTCwagkxLWYIy8kLpDuSvs2hFQzwYpoXwgmZLv3V8/lF7ycjOhnsORp06OiCpddvfOmYE94AlnFOqaLFTKsnFVQgHSFQXmkbytkD7o145p1EAp0OkZsDZhNO1Ek1/cfC+xH9g8miC73p+pAYqPIdHBVhe0yH5Ibyxt5KdKfeySGaNShRm0cFh8qVEh4ZNbE6xL/oTP8lyxGvw6nk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 12:34:18PM +0100, Pavel Tikhomirov wrote:
> 
> 
> On 3/13/26 12:09, Pavel Tikhomirov wrote:
> > First testcase "pidns_init_via_setns" checks that a process can become
> > Pid 1 (init) in a new Pid namespace created via unshare() and joined via
> > setns().
> > 
> > Second testcase "pidns_init_via_setns_set_tid" checks that during this
> > process we can use clone3() + set_tid and set the pid in both the new
> > and old pid namespaces (owned by different user namespaces).
> > 
> > Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
> > ---
> >  .../selftests/pid_namespace/.gitignore        |   1 +
> >  .../testing/selftests/pid_namespace/Makefile  |   2 +-
> >  .../pid_namespace/pidns_init_via_setns.c      | 238 ++++++++++++++++++
> >  3 files changed, 240 insertions(+), 1 deletion(-)
> >  create mode 100644 tools/testing/selftests/pid_namespace/pidns_init_via_setns.c
> > 
> > diff --git a/tools/testing/selftests/pid_namespace/.gitignore b/tools/testing/selftests/pid_namespace/.gitignore
> > index 5118f0f3edf4..c647c6eb3367 100644
> > --- a/tools/testing/selftests/pid_namespace/.gitignore
> > +++ b/tools/testing/selftests/pid_namespace/.gitignore
> > @@ -1,2 +1,3 @@
> >  pid_max
> > +pidns_init_via_setns
> >  regression_enomem
> > diff --git a/tools/testing/selftests/pid_namespace/Makefile b/tools/testing/selftests/pid_namespace/Makefile
> > index b972f55d07ae..b01a924ac04b 100644
> > --- a/tools/testing/selftests/pid_namespace/Makefile
> > +++ b/tools/testing/selftests/pid_namespace/Makefile
> > @@ -1,7 +1,7 @@
> >  # SPDX-License-Identifier: GPL-2.0
> >  CFLAGS += -g $(KHDR_INCLUDES)
> >  
> > -TEST_GEN_PROGS = regression_enomem pid_max
> > +TEST_GEN_PROGS = regression_enomem pid_max pidns_init_via_setns
> >  
> >  LOCAL_HDRS += $(selfdir)/pidfd/pidfd.h
> >  
> > diff --git a/tools/testing/selftests/pid_namespace/pidns_init_via_setns.c b/tools/testing/selftests/pid_namespace/pidns_init_via_setns.c
> > new file mode 100644
> > index 000000000000..7e4c610291d3
> > --- /dev/null
> > +++ b/tools/testing/selftests/pid_namespace/pidns_init_via_setns.c
> > @@ -0,0 +1,238 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +#define _GNU_SOURCE
> > +#include <fcntl.h>
> > +#include <sched.h>
> > +#include <stdio.h>
> > +#include <sys/types.h>
> > +#include <unistd.h>
> > +
> > +#include "kselftest_harness.h"
> > +#include "../pidfd/pidfd.h"
> > +
> > +/*
> > + * Test that a process can become PID 1 (init) in a new PID namespace
> > + * created via unshare() and joined via setns().
> > + *
> > + * Flow:
> > + *  1. Parent creates a pipe for synchronization.
> > + *  2. Parent forks a child.
> > + *  3. Parent calls unshare(CLONE_NEWPID) to create a new PID namespace.
> > + *  4. Parent signals the child via the pipe.
> > + *  5. Child opens parent's /proc/<ppid>/ns/pid_for_children and calls
> > + *     setns(fd, CLONE_NEWPID) to join the new namespace.
> > + *  6. Child forks a grandchild.
> > + *  7. Grandchild verifies getpid() == 1.
> > + */
> > +TEST(pidns_init_via_setns)
> > +{
> > +	pid_t child, parent_pid;
> > +	int pipe_fd[2];
> > +	char buf;
> > +
> > +	parent_pid = getpid();
> > +
> > +	ASSERT_EQ(0, pipe(pipe_fd));
> > +
> > +	child = fork();
> > +	ASSERT_GE(child, 0);
> > +
> > +	if (child == 0) {
> > +		char path[256];
> > +		int nsfd;
> > +		pid_t grandchild;
> > +
> > +		close(pipe_fd[1]);
> > +
> > +		/* Wait for parent to complete unshare */
> > +		ASSERT_EQ(1, read_nointr(pipe_fd[0], &buf, 1));
> > +		close(pipe_fd[0]);
> > +
> > +		snprintf(path, sizeof(path),
> > +			 "/proc/%d/ns/pid_for_children", parent_pid);
> > +		nsfd = open(path, O_RDONLY);
> > +		ASSERT_GE(nsfd, 0);
> > +
> > +		ASSERT_EQ(0, setns(nsfd, CLONE_NEWPID));
> > +		close(nsfd);
> > +
> > +		grandchild = fork();
> > +		ASSERT_GE(grandchild, 0);
> > +
> > +		if (grandchild == 0) {
> > +			/* Should be init (PID 1) in the new namespace */
> > +			if (getpid() != 1)
> > +				_exit(1);
> > +			_exit(0);
> > +		}
> > +
> > +		ASSERT_EQ(0, wait_for_pid(grandchild));
> > +		_exit(0);
> > +	}
> > +
> > +	close(pipe_fd[0]);
> > +
> > +	if (geteuid())
> > +		ASSERT_EQ(0, unshare(CLONE_NEWUSER));
> 
> I think it's better to move this hack above to the very top of the test.
> 
> Was found by https://sashiko.dev/#/patchset/20260313111014.2068913-1-ptikhomirov%40virtuozzo.com

Please resend and include a new entry for pid namespaces as a patch.
Make me a maintainer and yourself a reviewer, please.

