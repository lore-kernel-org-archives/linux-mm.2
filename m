Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37C05606A324
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ey2/rNZS
Received: by kanga.kvack.org (Postfix)
	id 575656B05B3; Tue,  3 Nov 2026 03:52:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54CE76B05B4; Tue,  3 Nov 2026 03:52:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48A7D6B05B5; Tue,  3 Nov 2026 03:52:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2836E6B05B3
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:52:35 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AD2D91C37E7
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:52:34 +0000 (UTC)
X-FDA: 85393191828.29.4468324
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 29AB840002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:52:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Ey2/rNZS";
	spf=pass (imf12.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793695953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H1zLd6hG/R8x62IgEXyvz1fvxMh0hGKtNRoZJvWwbaA=;
	b=zVtp7c18DL/tmrJ3r7wBGT+l3+PRZ7jQN+buFfUds41m8Y5DIw8YTMkrA1a0XWH8OnIQbb
	QuBjgYIHxKjyath0HIF9ROnAadh6X2tvwIjq1rudvOa7rAHKjedv9QaXRlrDHFyo1HmxkO
	P7B+PAlKCKN9ol1c7kK5QrZxRTG1wnU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793695953;
	b=tdtrfj9BKNCiSf8wunsZAf82AAN7zYeu8SUdmc8d9YBmEysSTvoEHnW1tLRIEC40Aou3uo
	MwJqQRCznCa9SAAXje9K4PdLob2DTD8xMs12Bym1v7u/AhVPiwg8aqhG4W2MX4cRokiE24
	Zh0iatqkvbLQEVRgSleN860UJiEDH5E=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Ey2/rNZS";
	spf=pass (imf12.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9DB14601FF;
	Tue,  3 Nov 2026 08:52:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 039E21F000C1;
	Tue,  3 Nov 2026 08:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793695952;
	bh=H1zLd6hG/R8x62IgEXyvz1fvxMh0hGKtNRoZJvWwbaA=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=Ey2/rNZSZSGEgNni1SBM051jGaDNXKipu6bI+WhqXg+DXQtxTAkPHp1y6npUYrPMd
	 xG+FEEg6UyC0ULBue/cBsk5nnYzKj6PlsZ6wuwRfOkzFTa+1PgFj49FrepxPsmfx3g
	 MpWpm7Rd+T0rbT5L5MhjpOknL27S4xBg7V7z657TtsQ5A3taA7GGwMQncLSH1ywyWB
	 0YYFzQSqU2+NuAm1u5c621J5DSXar3ssYU1XYYOg8Vhz/fdsKsEJ643KBwbTOjIg1w
	 QfQdei9I65G90fAi1cTue17tdqDZXM6TNp4UwAXwPwoCWerM6/8ut7/VkDPCNe51dr
	 08zz1FF3faELw==
Content-Type: multipart/mixed; boundary="===============8055261971948351789=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <3b79b99ba7a323fc42e7d3a19139c46535271762ae6f70ab629213866f54f54f@mail.kernel.org>
In-Reply-To: <20261103075916.100050-2-jolsa@kernel.org>
References: <20261103075916.100050-2-jolsa@kernel.org>
Subject: Re: [PATCHv2 bpf-next 1/8] bpf: Honor const on generic kfunc memory arguments
From: bot+bpf-ci@kernel.org
To: jolsa@kernel.org,ast@kernel.org,daniel@iogearbox.net
Cc: bpf@vger.kernel.org,linux-mm@kvack.org,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,ljs@kernel.org,john.fastabend@gmail.com,nierro92@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Tue,  3 Nov 2026 08:52:31 +0000 (UTC)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 29AB840002
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: n7h33c9imj77nym53cmpnhchkxreh3rd
X-Rspam-User: 
X-HE-Tag: 1793695952-121817
X-HE-Meta: U2FsdGVkX1/MQou1mgdLhpV0ON3pNmM/R6jHY/srSlHYy0BAOjzO8V/RLHUNLkLq5u2SRMtnVE/b6nCSvWZpTdxpcEByvIN1oxTgvLnxfY/bk3ocTn/J84IB90EUfA/LkzB8rh3wCwhUER5TnJluMGcCnniMWVS3dOkm9awE54O9Ms/LcWcq2RjBs2WeJIO4GH8HDk9IO8ky2QiOtmjvgafUGG6yHQHdPKMD9Gt/XXnM7mEjoCbWm/dPKyCrDd5mDYvVPQW5PRNU1eKJIdogiCFUIZiEZp0Wek1NqTrjWTjHF3xdbglb4rLy6v4IZdbHq82B+qnHJGB3yfAk1qryWYJskaZYfnahHQ7hRPYW32uF5M4xP0Lp0fRVbQFjvjXMvMqWWdJOLVOvU0g7uf8WtRvVb8Hjp0Cvz2Ve9ki6FYCWmJlK2z09mY10cC6M7GnHZNa+N2qOoFSi/ea0XCoq4/TGc5N5EJ9EnqcQzL9Ib/Yco7j6Gq7qc9kIh5ftwEv0L4/XRgNu02Qyajy+zyCP74WGl5ixfAwsUUhCirBAISYnJqaeq4shvq9Dd2Wz+cK9AhOP0rNnmswlddldvu/2TqmO6bFRW8q2OGqjV3DGa9isj1pV2EXUhrgsUP6F1QXF5NkTvD6Flz2VjnaeiHpyFpaj6L0TAUIeAbkSV3V4MFdg1neRqCw1WnMgPBjcD2E4/cwIHtf9JUMsYisirYY1jwTK0Az6lZQ8SFw+hLgcFCvuTJxRc1zAZ8QckByfgEFo68mrgPBp7pjJSTJfnaC5B79j618TG9rd3zWf9WYM+YRte3RENokKR7hMBaDzaAF4l89rg4q1vhUSw4fDnMt+hiLp+fJd+JkAb6bV9dLnxDEjLLrDbjQShfNqAk6jq7cq2f3/zOc8xn/PvlWX0qgkXru3k7UnV+qRgBYHoPebXmSFRWk+SEvvDV8UETa/C2j+JVVznU4HkDaN2bLgNEU
 tAjivq8G
 jgcg6zfBUe8Y+0I7c9vxX3HGZP6z8i8bp/4oq/tRwYMJrO0MX9ck+StueTmomK4xWgq/mkXo1h7jwL7P4uLCRqgABuJWcLgDxV1SfOs4+0hz4U8GzvwB8t13P9xWdH66ZrA2LB9SD8Wwnbgo+Jjrm+rFGXgSAocTK9if3HXPttczjGpPwq+cawjcG9z60kVWiflelaWwrbReug7l2ADzkq0J+XCCtoKYU+F0/F/VAp7g2lJkCCrh9DSebWKiIRjfc0UJ7IdNveKl38qnB/RhqoGYMyx4E4mrh5uEUVEMLdaLfDg+lY5ZsoB3bSmtTWj0eKTtRUjFBnR0pT2sje2WozKtcLJnm8xSFL4VcZXlkq7joGle9kdBFeRB5I7Z0qR9PMEg9ECcqajyvhG0UTLaHmduXhYHqXNNZf/xVPG79E1s9J6w2u2SS3/4/aWkxXBUGxCEE/lkLxhzl/KKDHlwkm75d67LlBTtZvyA4ZSFO6hEHDN5s5gScjHp7XecwzSaZwv9s3YKuaB4WQC4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============8055261971948351789==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> bpf: Honor const on generic kfunc memory arguments

TL;DR: Commit message only: it lacks motivation and doesn't say the verifier
now trusts const in kfunc prototypes, so a kfunc casting const away and
writing could make it unsound; kfuncs.rst doesn't say this either.

>     bpf: Honor const on generic kfunc memory arguments
>
>     Mark generic kfunc memory arguments as read-only when their BTF pointer
>     type points to const data. Preserve that access mode when resolving
>     scalar structs to fixed-size memory.
>
>     Signed-off-by: Jiri Olsa <jolsa@kernel.org>

This isn't a bug, but the changelog describes what changes without saying
why.  Could it explain the motivation, for example that read-only memory
such as .rodata can now be passed to these kfuncs?

Before this patch, generic kfunc memory arguments were checked as
BPF_READ | BPF_WRITE.  After it, a const pointee is checked as BPF_READ
only.  As a result:

  - check_reg_type() now accepts read-only registers (rdonly_mem,
    rdonly_buf, BPF_F_RDONLY_PROG map values, map keys, and
    PTR_TO_BTF_ID | PTR_TRUSTED).

  - Program types that may only read packets can now pass packet
    pointers.

  - check_stack_range_initialized() no longer marks the stack bytes as
    clobbered, so the verifier keeps what it knew about the stack across
    the call.

Could the changelog mention that the verifier now relies on the const
qualifier in a kfunc's C prototype, so a kfunc that casts away const and
writes through the pointer would make the verifier unsound?  Neither the
changelog nor Documentation/bpf/kfuncs.rst says this.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/41602296728
--===============8055261971948351789==--

