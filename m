Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FF80C79F9E
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 16:19:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 660226B0096; Tue,  8 Sep 2026 12:19:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E86B6B0098; Tue,  8 Sep 2026 12:19:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B0346B0099; Tue,  8 Sep 2026 12:19:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 268096B0096
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:19:02 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B5799A076F
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:19:01 +0000 (UTC)
X-FDA: 85191104082.18.FFDB703
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id E18EA20009
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:18:59 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hIJVey6e;
	spf=pass (imf31.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788884340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XIz1WNRfjVai+B//TeytB0d3qjhRgjrFm/mWruttF3A=;
	b=M1xWie0pWAG8+Kb0I5xPIXgnQ9/yH/EGzXJ4l8TdWZNWKOuxIGnwfl5URjdSQo1YsJV+kx
	+vRvTA1N3zKBjoFBem10DAV6dUQD8ppYMvc3GT5tBwKs+BzQOCeSDf++RCo64TP+s2nw1j
	IhMc5qkvVldaA1TlvoTVLy6BlS/+xCo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788884340;
	b=cmZliVGmuxV2PHA2lPiZTb/jGjT0gSHbZpUP2RK/u9MblBYwBLEqIdfuFsPeTLMb/35YEc
	fKLz5GJi6wMxGWvA/OIPLDG/TblLbNLHRdkOt5fyrrz2BOVf4u9EHq9sbs2Ok4qQdZF1Zv
	gNEjWevAnRNkN+MsoAmUmcguYOlHEGs=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hIJVey6e;
	spf=pass (imf31.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 372AF43CAA;
	Tue,  8 Sep 2026 16:18:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F245F1F00A3D;
	Tue,  8 Sep 2026 16:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788884339;
	bh=XIz1WNRfjVai+B//TeytB0d3qjhRgjrFm/mWruttF3A=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=hIJVey6eXNMSqenjKnHt/h3sPBnFmxxNwxxhNSLcnZqLT8BPOeaFF1hH0tR+Co41r
	 ael/HHqtugbbBaP3x76wS8jPP2c3Gd9Hrxs2w2259eSP6c3ptcA12BHppqw4qNwESw
	 1mKbemsI2cMKk4icBvIYGk2I5/TJB0NnIVWjmks371jAh/qHe5t7X83AHcmsWDWNvm
	 7oHnROaYqtHg5NUCH71/D8qPX0B0cJufiagv+qF4iN92DTstNu/8SfbSaSjrf2kb2d
	 FohgbJaqS25TpKPd3r0YgaIUmj59g9wU7LWskx7jcSw1XhD9kcFPO5BHHxszsbRQ+7
	 0cTLaVelCJyCA==
Content-Type: multipart/mixed; boundary="===============0769803629942985773=="
MIME-Version: 1.0
Message-Id: <bf31b548282f8e22f34ed509308df909261914918d9d3a5b3d9baf31210dc254@mail.kernel.org>
In-Reply-To: <20260908135302.74963-6-tasos.papagiannnis@gmail.com>
References: <20260908135302.74963-6-tasos.papagiannnis@gmail.com>
Subject: Re: [PATCH bpf-next v6 5/5] selftests/bpf: Test mm_struct user memory kfuncs with linux_binprm
From: bot+bpf-ci@kernel.org
To: tasos.papagiannnis@gmail.com,bpf@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,linux-kernel@vger.kernel.org,linux-mm@kvack.org,david@kernel.org,akpm@linux-foundation.org,andrii@kernel.org,ast@kernel.org,brauner@kernel.org,daniel@iogearbox.net,eddyz87@gmail.com,kpsingh@kernel.org,ljs@kernel.org,matt@bobrowski.net,memxor@gmail.com,song@kernel.org,sun.jian.kdev@gmail.com,utilityemal77@gmail.com,viro@zeniv.linux.org.uk,tasos.papagiannnis@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Tue,  8 Sep 2026 16:18:57 +0000 (UTC)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E18EA20009
X-Stat-Signature: yc7nzaspa1kh3cygysmtgy8jfjnzrqqb
X-Rspam-User: 
X-HE-Tag: 1788884339-814401
X-HE-Meta: U2FsdGVkX184xwyN602cWK0BkcZNwXpJiC8XAnaRXCR/+dRZMWMEjVI0lds3CEa4LaXj70re5nJeoVA9kDhmcgx3UYQCohEMP6XqtDdQ8vT/1ESAi/r8FnAVke/NhxtP8ir2J/G1A1/yzG4pNkQTeat6o89+jZppcG48PtKmLAUKp/jIynSHqyFEB4fDm/v5+QXiWF9DuRiqNnmKqhJM/t6ncsdh/KvmOIemKfsv2YQmfVLgApY6RSJ1RLHx4/EBAp1j3YbCgftApFYPHXTGYXoltNOE1nwQyokYEAQ2rrmSpHNYaDvyFgcP6iaasXqgz9Jqq1idRmYhka1i9Hjg2z4kRFWrw6WZ0Lz3foyZIXm/xafYU4cwQQvXqfLzSbz1Y6A43slckhHi3OTv39cj4BALEVEw5z9zrX5UeQgxmcoFmsO3aKSwNfHVypRhcLbQycYydQimqfwaj8GrJpJpLhV+m7i748PJAx/asm5Y2woBzSD1XgTR17CCv71LiahknDNLGu/p8bag985jaYNuYGCsfI8c3tRVBvot4aIq5/JWF7GSFthbN00mO5KZFAkcVoS0mqLo/vjOumGT4HNF9Gjyqzzyf97Y6BgNcyWlt5gNdFJG4XZykbTXb03TuNkhU+S3LpweekT1E26PIEtCzz2srxEd6F48BSaXIkawTMoOmY3RZN/wS5Czkvt54fhv2zPFc/EjHTB/91MgK/l6XCWcM5MDPk62tm4LzxjJw1pst1GDBFUj3Zl2ItQgvuyaIRgQaRe6WJcEscCcomZyRK8o8UiJRDtmRmLGW3WMKJaRlsEJZeBZZHFTtKw3NyTQo6QY3BsNyT2aSKzmEQOMAlWrBLK11Q50ZdPEw4eGPzX7hiBwbnYdnS6Y5mtY5Zs+7baQEs8aVlXWoN5W+APDX7J/97V0/qwJ4Y4N30gIGHAvkuMrzHsieYSrPlySPkLFnORS0BpoPmP77DwdNzc
 XChnQgzX
 BBs6lRMLqF3c6jyCL0TeQwg2mG4l7KMNpNZQWrXNCLYNPsNg6EF2cqOGe+NT09IeYNRyhneWPsDoX+YQRWgxCW/7OD1w6fBglz69f1e98+oC1evV5B4t9WKSXq8x+39tq2K55p4z3y7gNx2EnXLU/aAQmqMRHutNrI8ORGbYlwEaokgBdqD99WCsOqIHGbkfFnwMz22/S/Jpe4mV89aEK2H2A3DQK7I8LATKPR3WK+T1cmqpdlbugYy1D57aLARDhEt8/AY9qLYprpPh00h9R8v7lVl0FJp0eUp6ACLzlPTpgrN3vNmvdzk9gORZ9wL0/0Zb702fC4aGHESWpfyWZzPVLm9KLK++icYNWSlNY7/17kEWUiodAlTGMptfQIDHnR8AChsK2+DkLWFYyYUCPOLmzTvIUrULTLTxC0Jt6ZbC+z7rJ/C7mErtUA19Um3sUgtqV7mg2b7x8XGoNcurtcF4mSij5Qt4JohmhtpcKdUfa1dbrbCE2Jdwuafi07AJWPqsE3MFHwHqPO6DCHy1wTKbCeHEngErKcQF/mHE2z0jnhC2ebkURdtLZFpXfjj3iY+wYRd9kfWf7l1I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============0769803629942985773==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/tools/testing/selftests/bpf/prog_tests/copy_from_user_bprm.c b/tools/testing/selftests/bpf/prog_tests/copy_from_user_bprm.c
> new file mode 100644
> index 000000000000..b2325b193576
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/copy_from_user_bprm.c
> @@ -0,0 +1,72 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <errno.h>
> +#include <sys/wait.h>
> +#include <unistd.h>
> +
> +#include <test_progs.h>
> +
> +#include "copy_from_user_bprm.skel.h"

[ ... ]

> +	if (!child) {
> +		char *const argv[] = { arg0, arg1, NULL };
> +		char *const envp[] = { env0, env1, NULL };
> +
> +		skel->bss->monitored_pid = getpid();
> +		execve("/bin/true", argv, envp);
> +		_exit(errno);
> +	}

This isn't a bug, but would execvp("true", ...) like test_lsm.c does be
more portable here than the hardcoded /bin/true? With the absolute path,
hosts where only /usr/bin/true exists would see execve() fail with ENOENT.

[ ... ]

> diff --git a/tools/testing/selftests/bpf/progs/copy_from_user_bprm.c b/tools/testing/selftests/bpf/progs/copy_from_user_bprm.c
> new file mode 100644
> index 000000000000..b334a157419e
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/copy_from_user_bprm.c
> @@ -0,0 +1,123 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include "vmlinux.h"
> +
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +#include <errno.h>
> +#include "bpf_misc.h"

This isn't a bug, but is anything from bpf_misc.h actually needed here,
or could that include be dropped? The test-tag macros, __sink, the
__clobber_* and __imm_* helpers, SYS_PREFIX and CAP_* defines all appear
unreferenced; __ksym, __kconfig and __weak come from bpf/bpf_helpers.h,
u32/u64 and BPF_F_PAD_ZEROS from vmlinux.h, and BPF_PROG from
bpf/bpf_tracing.h.

[ ... ]

> +	data_len = bprm->exec - bprm->p;
> +	data_len_match = data_len == sizeof(expected_data);
> +
> +	invalid_flags_ret = bpf_copy_from_user_mm(data,
> +						  sizeof(data), (void *)bprm->p, mm, ~0ULL);
> +
> +	copy_ret = bpf_copy_from_user_mm(data, sizeof(data), (void *)bprm->p,
> +					 mm, 0);

This isn't a bug, but could the first call be wrapped the same way as
the copy_ret call just below, so both fit in 80 columns? The first
bpf_copy_from_user_mm() call breaks after the single data argument and
pushes the remaining four arguments onto a 92-column continuation line,
while the identical call three lines below is wrapped conventionally at
the last argument that fits.

[ ... ]


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/34245694915
--===============0769803629942985773==--

