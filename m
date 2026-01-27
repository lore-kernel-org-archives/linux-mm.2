Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4B39D25923
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 03:08:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D042C6B009E; Mon, 26 Jan 2026 22:08:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE5BA6B009F; Mon, 26 Jan 2026 22:08:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C120A6B00A0; Mon, 26 Jan 2026 22:08:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AE8AC6B009E
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 22:08:49 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6AD28BCD47
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 03:08:49 +0000 (UTC)
X-FDA: 84376261578.26.9D46237
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id E9AE680004
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 03:08:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EWYFjNUg;
	spf=pass (imf02.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769483327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+iIk24yWejml0i9ywY8UvQx+ATbXyYw6cNWx0ZiGanI=;
	b=Uay6ATMnHee93TrfvsOjrVUcy4BR3uic+8cmhmTgkJKWqC6MII2vae9OOnCsWjlrivHYZd
	oiOjAMLlcFEna/bH0VieE+V2h+a0uJEWbSvz65p3Inrf6L28/J8PgJRje8chMZTxtgxJJ8
	mKexLcwvSsN2mhlryUoCBobjAhHYJ8E=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EWYFjNUg;
	spf=pass (imf02.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769483327; a=rsa-sha256;
	cv=none;
	b=270QGdPTZJeF2KzPUZz8YVTRJK7x9A39nKyqED1pbkzlbcYw3c758KtSvJIyb+/3X2AQuP
	Kmcm8CWvsFafVLO42MhswkcfEvjqFqQH0bEAKqUrRP3LrNC1wnMMl0UN32UbtAJ9eiiYHN
	QcgOsinImJez+I1ijqj2bSn9YBuGZtU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 17F7160051;
	Tue, 27 Jan 2026 03:08:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B66FC116C6;
	Tue, 27 Jan 2026 03:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769483326;
	bh=r2VRHW3WxWnawAiIF9XP8PHtMz4QMDWUBEXOXvY8H2U=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=EWYFjNUg75mYuAauRKChhRpUjAEjA+2PP0uoHx+vXt9zaOPOzFiGq7Dv2dntKzOn5
	 AqKQnuKIa0oj6WLjNNHdhfmSptSHipYNrlTLhbMZOhBvYynMdlYOa/QHukZJv0l1iy
	 mtdAJ96k6bZ8QvNEwJVhfAlOOgG99x3aWbS6ztRUaeIsHlzb2WGskT27+p4welYoKB
	 VZZPS0mMvmehf8Q3Wwjdv6tARtahUqmREThO3MaR2Haybg7Sb6+dmiUQEKRN2yxH6z
	 oByMCB6gH9W9DYUuiw+WP1OMLhJB0rhPeSslPGmKe6Emm3G4eb61YhoTBzHPrmIqVy
	 m+cjo2vtu1pYQ==
Content-Type: multipart/mixed; boundary="===============1477226859959415716=="
MIME-Version: 1.0
Message-Id: <11e47e72d311eb7a7a69fd74e1701c3563ac2f9d7e4fd4f7a94d49e83885ff22@mail.kernel.org>
In-Reply-To: <20260127024421.494929-12-roman.gushchin@linux.dev>
References: <20260127024421.494929-12-roman.gushchin@linux.dev>
Subject: Re: [PATCH bpf-next v3 11/17] bpf: selftests: introduce read_cgroup_file() helper
From: bot+bpf-ci@kernel.org
To: roman.gushchin@linux.dev,bpf@vger.kernel.org
Cc: mhocko@suse.com,ast@kernel.org,mattbobrowski@google.com,shakeel.butt@linux.dev,inwardvessel@gmail.com,linux-kernel@vger.kernel.org,linux-mm@kvack.org,surenb@google.com,hannes@cmpxchg.org,akpm@linux-foundation.org,roman.gushchin@linux.dev,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Tue, 27 Jan 2026 03:08:46 +0000 (UTC)
X-Stat-Signature: ayfsdoqp7bhjgrfm8dqbdwp9rmi7eqsf
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E9AE680004
X-HE-Tag: 1769483327-209137
X-HE-Meta: U2FsdGVkX19KZjPvmE3dMzkDjh5YRLhVKts46oKsqThuShYgRcLNoFwjmGRR04wO9xvecJjeIbFZfq22IlnVgWBBM9bNU2va5U1FlXB/cKAYLxL3OlZujOM1nOPXrhp4viuRrcFNtDmefUhdl3Tho3NNJKmfv5hVC3psXwzsWeXEpA5NUzF1O5Vm4cofQFH1lKN+ugAjlNTc/QzDzyIAz/368hWCxtM8jHbRLoH4ui7nEQK0UZCKddWsnn55oxDqzG3Z4NG5cTv0HbcEk3/VNO0cBnhtwMnO35fqPfZmSwjxhkMGZz2oGN5Nn3umpjbMCDx8GhQzkPur589PkB+FzTCJtIKzOHuc7npsxb1mbH9qwTWXcrU7+sL+9DQONXuGkM1sBGgikxOKMMjIIDx3QXLNkZyL+WvFfPczPAh43sMk3mIrF9GSqVtbDMkabcohVBKqMv9ArUM1hAVzZV5nbYhKpZZEz6oa0/XaM1HeP8m+OZOS2yRXQme2EcAUwLFaMuJ8lwqP417L0N06P171CLZ9TdGJ9Z5eD1lVKKMxsTrYB9oHoCrX+9B3RfiMV/KjmgU4sY0RykDzusd29HZxPfBFlAsEonJfsMoNnuhOZQgagjg6NRGmXwlptd3DwM0giwqNFqkV6jrU+D74SjZ5v+4gga2oazYNHcwcxGl2ATETQPqyYf7TQzKe0mImXlDiCbYeq3qqFg5KmFisoOxwmEuQ4lN+FMsrNYTFcBiartrPOK9P06J7ifMQE3M0XEwGPdcpP5dAI0eMFpGTAvJ4jD74yc5y1R70nQ1kARledpldTc1hBIePEJTSy4NxNE324v1JEDSwxB/eftY47XGiViRNnDYQ8z453hKtlSRidvlm+WQpwj2Zsl6j68NmU+YaMrygPVE8N7IYLw795l31O3+QeqD22LZIASQA2s8/NY960NtRIA88iVMIH1/MuBIK1PzONZjSAV4df9s0CLi
 DD6aA11A
 zVl9LwaZcNIBuJnyHvSRuJtto5A4qDdIDRZlZXdImYlCWDTdW1hyyOBqd+fLaeTcrUBbqNwHtO0Og5gk8ZPYzVSDtLsp6cEhlP2QcNEhouHW7u2ws9e+ZW5U/1LYPJKD9OR+yPXISasGqKl+KXhazAs/olUUI7KpQjQ/IgVY0kFGCZOOrWoLkdJCUirK8fDPp2IydJhuSHkdAYdDOcCmGv+nRAdAbgC+xJjrqFdkC73KsktOMUTuzwqCJT5j0vZPzasYM+BCpVlvTMI2IXWPVnFLbitdxtik00ZC5o3570vRKQ/+mOVgMuIZvmrtAHsej7KTyO4ODpCIW3AfGqBZIS284y76d7Zv0NW+VV1Hbn+hYiVcs7SBVxexlfO6p1Oy07uLhgF5swauET3jAlh887WKmdHyU51TPDY17IzVrMItGJKxEUbp4njWbE5ZnPJwn0xX7XzaKldm5vx3M1Qhs4MDl6Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============1477226859959415716==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/tools/testing/selftests/bpf/cgroup_helpers.c b/tools/testing/selftests/bpf/cgroup_helpers.c
> index 20cede4db3ce..fc5f22409ce5 100644
> --- a/tools/testing/selftests/bpf/cgroup_helpers.c
> +++ b/tools/testing/selftests/bpf/cgroup_helpers.c

[ ... ]

> +/**
> + * read_cgroup_file() - Read from a cgroup file
> + * @relative_path: The cgroup path, relative to the workdir
> + * @file: The name of the file in cgroupfs to read from
> + * @buf: Buffer to read from the file
          ^^^^^^^^^^^^^^^^^^^^^^^^

This isn't a bug, but should this say "Buffer to store data read from the
file" or "Buffer to read into"? The current wording suggests data is read
from the buffer, but the code reads from the file into the buffer. Compare
with write_cgroup_file() which says "Buffer to write to the file" - that
phrasing works for writes but the inverse doesn't quite work for reads.

> + * @size: Size of the buffer
> + *
> + * Read from a file in the given cgroup's directory.
> + *
> + * If successful, the number of read bytes is returned.
> + */

[ ... ]


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/21382620878

AI-authorship-score: low
AI-authorship-explanation: The code closely follows existing patterns in the file with a minor documentation error typical of copy-paste adaptation, suggesting human authorship.
issues-found: 1
issue-severity-score: low
issue-severity-explanation: Minor documentation error in test code where @buf description says the opposite of what the code does.

--===============1477226859959415716==--

