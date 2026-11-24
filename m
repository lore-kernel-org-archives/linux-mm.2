Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1577606A326
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 23:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IlpI7jOH
Received: by kanga.kvack.org (Postfix)
	id E62456B0600; Tue, 24 Nov 2026 18:49:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E12446B060B; Tue, 24 Nov 2026 18:49:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D28656B060D; Tue, 24 Nov 2026 18:49:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B6A846B0600
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:49:12 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4F4D0A8C47
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 23:49:12 +0000 (UTC)
X-FDA: 85471656144.18.E439FF8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id BD4B8A000C
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 23:49:10 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IlpI7jOH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795564150;
	b=8pWJFM6eQV1COqG3PZILBvtx9YZxrP+1fsW8daOk8Sg0EfovCCboSMdduYNmzyBjHpi7Uh
	MZt0LM/aMrpVaoN2FIRpGusFP1O8ZgcMqntU0PHHO+Z24tcznzWvuQA+VjF1Y2f7jPFiMy
	ooUfnRZYq/c8roOqBWyVNL/RWs4iJR0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795564150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lKDulksU0CH8kWxQ0HqONqWmjOATVYmG6DnvF0rQk9k=;
	b=XbW7qOe+NwJzV5lTL/7EXgqeMymMf8SJeJmeQfue1sI0SiJB9ka7SyHJFgr151WvFb8U8v
	H+L559yA4QM2UK4xTbwZ+fVeJoc2gpnMQvjc0pmVqosRvQ3Az6DuFRiXmklTBeZ/FfucBb
	1/zy2XkbrbE4+HhtR46LHxYrBSsY96g=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IlpI7jOH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 12FD160F21;
	Tue, 24 Nov 2026 23:49:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A1521F000CA;
	Tue, 24 Nov 2026 23:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795564149;
	bh=lKDulksU0CH8kWxQ0HqONqWmjOATVYmG6DnvF0rQk9k=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=IlpI7jOHHg6tzDJtT7dUsw9yL6fpvZ9HKK1m6TkLc2LiZZ3UD8SsdCYQOPTGUoh4Z
	 NipXRVpiqDCGW1FPX4Aj+JWvOWuaH7yh47kJrzJMMgWYxRGBiXlzu1T/MZUWUC4g0W
	 vMNK/n0rsVJnt4+MwUB+9ab95GUxpkKWlaQFELGgsxYF/A92uqHyYjG81QXhlUvaqv
	 UyJ18+lF5X1JslR+TZbpCj/oUXLo5lcdp3gbMbe0ryI4vzplir4QZl2zv7zCVHIKE6
	 KKnfsBtZ25FkDGwWmWDCI+A50sHcwbB23XU+Xd+0/5dBGydMv0HgkDtdDiR3r5CDs1
	 IEQtda9ZYTz+A==
Content-Type: multipart/mixed; boundary="===============2510359726493679342=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <fd2115bde2e78440a8c28b057e22f7a7a3064cb74e9030b92ee2f4498ea6046a@mail.kernel.org>
In-Reply-To: <20261124-work-exec-update_lock-v1-18-e489035395b8@kernel.org>
References: <20261124-work-exec-update_lock-v1-18-e489035395b8@kernel.org>
Subject: Re: [PATCH RFC 18/19] vfork: wake up the parent once the child has left the mm
From: bot+bpf-ci@kernel.org
To: brauner@kernel.org,jannh@google.com
Cc: torvalds@linux-foundation.org,linux-fsdevel@vger.kernel.org,acme@kernel.org,linux-perf-users@vger.kernel.org,bpf@vger.kernel.org,selinux@vger.kernel.org,kees@kernel.org,linux-mm@kvack.org,linux-security-module@vger.kernel.org,apparmor@lists.ubuntu.com,david@kernel.org,brauner@kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Tue, 24 Nov 2026 23:49:07 +0000 (UTC)
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: BD4B8A000C
X-Stat-Signature: fi8g9t3rb3r9eehe9hh96xaf1k589azo
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795564150-67628
X-HE-Meta: U2FsdGVkX182G8UcdCtbg5nUJWKGJr3lIZEcVXYS9Kw/tRjSbN+HEWWeGnfa473ZkFbrSzisb8IYbSpOuYjKst3RHdKhoL1p+559ZXg6oYWh+RJa1F/ELClbuIAPYQMWe5BAyfUWvQUF+C8ZT8Mmfqma9LbtnBTw9rqzZQIBFemcI3HJPTFJah9vuNqWvcZrLBQr6ad5LnhkZqeqjts7/kLjYfPhZQxKGozTgYhbRzpNtKi9bSpNsx4oCAeSXMKYDkoPUfGZN8KcYQj3dKsaDzwha/ZIo2YBHjQs9aqqtdbOJPCfwKeDxlB5cqEH3nZ9R33n94W4o/UMc0Sy6lWedrr7C2uiitr/oBfkj2F6F3+n0LsfDLkmbmjL1/+ri7tq7i+83DuqhKFZGu7U5FFD0yygTBrCO1COMkJO8g+TuHswngKHmgjrisiLDmn4o+vXSlX/kkKh1K5Q1ry8IEJRZ48OMqoa2nKz0A8tdLfyLOtDKcnHI7MmPuDKWwZ5wFlOwzA2Gj6IK4oigTCMESXwbimj5C8e8UfxH/3o5K+Oo/+o74qbS5BJ0m7ELdVJwZ+KJFsRPciu2ObAvM12FhYcZAhK+goG2DvKGbqMozReUW8lkujksjR2/L3MQMxo7tuHEPWu0U5DJ2h75mU6hT6ugMU+5H4YTn4XHYystVywZHiuN9b7cQbhx7+u6crq0H22QvRaJVkFkFwWT1rXQnpHEDMlO/SnY0cj76Dn4bzkLVB0n9FpcbNSyv5Ilri8US+2vhPTVqH/j4fV5dNJo2GdjQ6ZR5ivX5xw3wizTZsYqsJvbB0gOctnVj2TnknOozuQS1Xlo0mIFCHsdgs9PEraDrnUK7SVHn3qWMvemmAZxpBHjF5NclCh8KOZIeFEBLjZfi7HEzWXbove1HXb/ZYqbwbhRH5K3565b7d7YWiio2+BxTSnxFhAhNx1d/lSU50cibQMApnYsEpwEvWLZ+y
 Dvfn4zgG
 5qumF/oftMGtTYfkHhvl0KcRstGdsNjFHQyGHfem+TmWXU050eHS3z48CTMi94sXCrVm3nm2pw1G3w+9wykBW9kexpzEQAVLLrZ3c1YQWLn/hvZ/8USB4RrQK5wIiLfQrpxJTvQcQS2w2E+vRKSvibMWIBpknXkNUDr4bdr6OpLR4Ul073BSALvwrbOiYOy0oF+5tEcAd/CgdnKzv3frTc/Ff3FPdI/v4DUFpT2Nt69TTIXxgwR/8NbsaHwV8fZX/Gub+vO3kwQuVo3NiqO89A3jdznJidRaHnPI5KVxgYlpuIl36FsAVWKKYDiN6Af/ORvEDz5y/UDv6qe9DZHlGDSHhsrH8NYlPwvO0eppsy+4h6/J/jFvkKl4H6Zh7NLEGlGoy9UdPZEwnmKzcTZYVuln2ceVQfHf/ZpsNzxDe+QtsYUnzJV6jg4Z+U4vuxJyufDoyugSoc3kIozPfWXaxdQu8Qk6Udqe9GfMlje1uWxQMGFkCbhIltTIHya9BrPgIzTqd6Q866CIll2zsfGojq8PonGfIm9GtUgCyWIJJ5xgpgQrr754B35UU0fZN2a0IrIl1gWqQo3caYEpXezLOWR/YRitTKzMgL2ABtNMKWr0p2KloUri3E3/an9Svw3sxplGPXFM1n1YhfB2Bi2SLl+PvTDlgRhsyONqK2gB7K1lyTGj6hYtNbsDr2J1/MVa6DKOPFoHzCvzwJK2iwFwE1S6heVpULhkPdbTjzrVUxOVT0J4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============2510359726493679342==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> vfork: wake up the parent once the child has left the mm

TL;DR: Commit message only: it cites "[1]" for the 2.5.56 change but has no
matching link; the review asks for the history.git URL to be added.

>     vfork: wake up the parent once the child has left the mm
>
>     A task that called vfork() sleeps until the child has released the mm in
>     mm_release(). But exec_mmap() releases the old mm, then waits for
>     exec_update_lock and only then switches to the new mm. And exit_mm()
>     releases the mm and only then drops it. So the parent is woken up while
>     the child is still on its mm.
>
>     It wasn't meant to be that way. When mm_release() was added in 2.2 it
>     was called after the task had been switched away from the mm. exec only
>     moved it in front of the switch in 2.5.56 because deactivate_mm() and
>     the write to the child tid address need the old mm (cf. [1]).
>
>     The release has to stay where it is as it can sleep in a page fault for
>     as long as userspace likes. So take the wakeup out of mm_release(). Wake
>     up the parent in exec_mmap() once the task has switched to its new mm
>     and in exit_mm() once it has dropped the mm.
>
>     While at it, fix the comment above mm_release(). It hasn't been called
>     after the mm was removed from the task since 2.5.56.
>
>     Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

This isn't a bug, but the changelog cites "(cf. [1])" for the 2.5.56 change
that moved mm_release() in front of the mm switch, and there is no
"[1]: https://..." line or Link: tag anywhere in the message.

The previous commit in the series, d0c33c04297e ("exit: don't take the mmap
lock in exit_mm()"), uses the same "(cf. [1])" form and does end with a
"[1]: https://git.kernel.org/pub/scm/linux/kernel/git/history/history.git/..."
line.

Could the history.git link for the 2.5.56 change be added here as well?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/45508356147
--===============2510359726493679342==--

