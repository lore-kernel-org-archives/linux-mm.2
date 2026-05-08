Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25F7CCD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 15:40:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B1B36B0183; Fri,  8 May 2026 11:40:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 762046B0185; Fri,  8 May 2026 11:40:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62B7C6B0186; Fri,  8 May 2026 11:40:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4B8C46B0183
	for <linux-mm@kvack.org>; Fri,  8 May 2026 11:40:14 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0FAD41401C9
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:40:14 +0000 (UTC)
X-FDA: 84744663948.10.669344E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9575CA000C
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:40:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t6g6Ee+K;
	spf=pass (imf15.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778254812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YGTGZaCx2W0k7jMU6sEONP8G6b2S9SUa1ZT5IV12a4c=;
	b=Zs8FTzavUMtk6en24ecw7ROUN0ECWZ+/2zgt6s4iWgJkSnRikrsGZpv5ETkcLrU3CSqMBE
	O0ElDoPIOJ3Qn7RHQ8msbANSba2bfFZu2HrQa8FBchEYhe8QTzZDLKkZ497N2FRusTYxYh
	t+PiB91r+OcdT6wuPrSNNzxzLgW8m8c=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t6g6Ee+K;
	spf=pass (imf15.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778254812; a=rsa-sha256;
	cv=none;
	b=Jo2rgmHzBf6K1gvN7H1pEYrkwywBsOw66JWkV93xOD9g3uLSuymNWsnjSTxYD+9tf85rZW
	DmjoKoJRuYqmusKtcnUwmPSV6V0+62t1ydDABLJwgmiibaJWbxiVdoBD6KDVEbHxKbMZ3p
	1wcxnTn0onfSgOySwIgzVZ5hTnW6ORc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D3BFA60583;
	Fri,  8 May 2026 15:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29644C2BCB0;
	Fri,  8 May 2026 15:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778254811;
	bh=5EjtDlUmrIuStydpM3BHOspQa1U4dcycPlThtC7+yjs=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=t6g6Ee+K+pTb0MKucmrg+Rik/fVxeI6T70n0nWBI/Jbuoq2JaXlABABbtH5s3tAq4
	 8AZ7z1jtmfppe/RgTn1Go8heZoor43pDeGPV72vKRD2ycbyozvlbGU9iPcQCpbiDu1
	 qWHKn/68tqPbt3C1GoZH3Ui+EwHxFO/hdgeLsev0JUWaFG+z9ToWWyGajtQGEbCRxl
	 ShypMRIVOZ2PXbmoqNmA84V3h6KhJk2EDc2u8Nx9rbjkBB35OxYbJVcTUC9nQWxKwt
	 yn9f2GN/jcdj7kSzfNZiRUWbwuqrQ/ftJAHAzdPXRHmcaudCBpO6KTsZ1j9FO5nubf
	 dr37E+SkHYfVA==
Content-Type: multipart/mixed; boundary="===============9112384240899730167=="
MIME-Version: 1.0
Message-Id: <5eb9dcb3bb77920b11e2efc3e082c685cc089499a4be5cc3469c3db4d2779da0@mail.kernel.org>
In-Reply-To: <20260508150055.680136-5-vernon2gm@gmail.com>
References: <20260508150055.680136-5-vernon2gm@gmail.com>
Subject: Re: [PATCH v2 4/4] samples: bpf: add mthp_ext
From: bot+bpf-ci@kernel.org
To: vernon2gm@gmail.com,akpm@linux-foundation.org,david@kernel.org,ljs@kernel.org,roman.gushchin@linux.dev,inwardvessel@gmail.com,shakeel.butt@linux.dev,ast@kernel.org,daniel@iogearbox.net,surenb@google.com
Cc: tz2294@columbia.edu,baohua@kernel.org,lance.yang@linux.dev,dev.jain@arm.com,laoar.shao@gmail.com,gutierrez.asier@huawei-partners.com,linux-kernel@vger.kernel.org,linux-mm@kvack.org,bpf@vger.kernel.org,yanglincheng@kylinos.cn,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Fri,  8 May 2026 15:40:11 +0000 (UTC)
X-Stat-Signature: u7544pb3e9nynhzy8d8riyo5hjk61n9q
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9575CA000C
X-Rspam-User: 
X-HE-Tag: 1778254812-201481
X-HE-Meta: U2FsdGVkX18ODu39wPunhGri1cRtOYp/wbnzmAFTWF/8spKMlrlAwAOm/YlWGxqhF8Ekhxmmg8VjUQhxJzyhqh07iXxxodhVuK+xHWAEHdqYVM0zs5Mux6pSeAOepikgJCN/jV1a9tE3/Nhe4jQKC30TVRgqWuB6BSnSOwgapBzQ0RlhYSzSPpGwhNkNMbIIK9JX5rKt9Ptq4anqPn2kYF8Y/gtmzLzSpQqxzIFUfZJnyTFgFfcHPCdr7atT+04vOutB0YgKBWnIxvnR/sPSRc0/RM56jH0qR+3GMXp51cKlm7He9tgAXQ2VkH14WKn+r+ADhMsi+Q+ocnm6GszKiUVYFqLttIYKHjacTrw5I6IuU05nVYLc+cnRd/f9G0C5ZaFUsr3oTMHfd/jh7VYDvYjuY3FEL3LS28abKk/jGACVlWHTk1cPpFHXewdEIvzxaVLiQFUePgrdyRw/UxU/tKaECCXN1hIfpp2y3igiP3ilEdAq1xQqVHTs0mSr8g4d2iX6FmzcjUtCefTPf4LgYP6GHrzjPoxSoS4xfCySjapU2ry92vHR20/QELLPqtjrRJY2dWJAfuWTIOsuLGa/d4OEPxCVJi7tv6g/hT8WXoc+B9YTGh3NzQm7opRvNrSOE+GYEgf+hDHl2LRTtkJwgJqALchTltM/mUUmz0o4nvN/zHJ1vZmwugaMn0hREyzxpkbg+MbPAZpETwHmJ1+HyMux4kT8V9QECriQuQQVnziEzSXjgfYSJ6rFZ8/G19V9dEEi1GLap0EHa/+Nl6vf/mc1leJo1KGoZtytbGylhVgWmTMkcHRv8FdzDbz5UMvswYehVjDptyh9g71LtOyXvO/2tDVW2tzcRaM8sS/3HSz/vidDuylwRA+0YrE/7vyhYn8YuNS3GzqZigGneMyGXpSAh53odn+SZCLalz4qEdNO0eBAAtOAwEJv/XYvt9q887aW2eUPaNKh1VUrLEw
 AWgmuM65
 vhWzciMVvmUOOlcKj3tzV2w26vpUiLHs/obt24tF4efEwBRAZBb+Nuud8KoD+MEglLPd2J+K6IXCbIq1Ap654DMLsYwNV/uviIAGdyRra5RK18CzfIV5MMo8WZHnO3d4ondLBJSRAJ4l8iBvPQcVfKk+W0a9St++w2vZstWrnmAfNGYEc3jSqef2hIdb1T1C5lK+YV+RMCgUDLbouOWmTIrGAp4OGhOzwT5X3fl4C+JZuWP1nLjXohqh2NHS2H0A83ht90GPetCOyzgshRkV49z2P1rO59zakGaq1y9IhuYIet4dsM1V3Jbin8hUjXY5PfLliU2iRZqFNHAZCHGkiGEtnfN6zSmpUadmXBm8/aTEYfKnYINJJuP4/9q2FzOE04qPP9T8Wp0BuiYtJ8Krw6oVIa/He9x8cxbLkxxzL/Dz2p9TXNieYyqv335wg7aNWJKQMH8MevnPbgxdTXVVgRHIwV2Br3DIwpL4I+mO6a4IzGr+mBXgtksP47z9ktaJeUF10Vak1SwMSy+ao+lPVeioWRQuwGnwBTzGbEkOMngwnm/JKpsIm9g24Aw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============9112384240899730167==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/samples/bpf/.gitignore b/samples/bpf/.gitignore
> index 0002cd359fb1..2a73581876b4 100644
> --- a/samples/bpf/.gitignore
> +++ b/samples/bpf/.gitignore

[ ... ]

> diff --git a/samples/bpf/mthp_ext.c b/samples/bpf/mthp_ext.c
> new file mode 100644
> index 000000000000..120c331ff26a
> --- /dev/null
> +++ b/samples/bpf/mthp_ext.c

[ ... ]

> @@ -0,0 +1,339 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <stdint.h>
> +#include <string.h>
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <unistd.h>
> +#include <signal.h>
> +#include <time.h>
> +#include <stdbool.h>
> +#include <getopt.h>
> +#include <sys/epoll.h>
> +#include <sys/stat.h>
> +#include <linux/limits.h>
> +#include <linux/bpf.h>
> +#include <bpf/bpf.h>
> +#include <bpf/libbpf.h>
> +#include "mthp_ext.h"
> +#include "mthp_ext.skel.h"

[ ... ]

> +int main(int argc, char **argv)
> +{
> +	const char *root_path = DEFAULT_ROOT;
> +	unsigned long threshold = DEFAULT_THRESHOLD_MS;
> +	unsigned long interval = DEFAULT_INTERVAL_MS;
> +	unsigned int init_order = DEFAULT_ORDER;
> +	unsigned int min_mem = DEFAULT_MIN_MEM;
> +	bool fixed = false;
> +	bool debug = false;
> +	struct mthp_ext *skel;
> +	struct bpf_link *iter_link;
> +	struct bpf_link *ops_link;
> +	struct ring_buffer *rb;
> +	int root_fd;
> +	int psi_fd;
> +	int err = 0;
> +	int opt;

[ ... ]

> +	/* Attach struct_ops to root cgroup for mthp_choose */
> +	DECLARE_LIBBPF_OPTS(bpf_struct_ops_opts, opts);
> +	opts.flags = BPF_F_CGROUP_FD;
> +	opts.target_fd = root_fd;
> +	ops_link = bpf_map__attach_struct_ops_opts(skel->maps.mthp_ops, &opts);
> +	err = libbpf_get_error(ops_link);

Will mthp_ext compile with these symbols?  bot+bpf-ci@kernel.org noted in
v1 that bpf_struct_ops_opts, BPF_F_CGROUP_FD, and
bpf_map__attach_struct_ops_opts() do not exist anywhere in the kernel
source tree:

https://lore.kernel.org/bpf/c13f99d42c434ec73ec1e8cf1141047146ab359e60e56e78e1c32554d6e01e9b@mail.kernel.org/

The struct bpf_struct_ops_opts type is not defined in
tools/lib/bpf/libbpf.h.

The BPF_F_CGROUP_FD flag does not appear in include/uapi/linux/bpf.h or
any other header.

The bpf_map__attach_struct_ops_opts() function is not declared in
libbpf.h or exported in tools/lib/bpf/libbpf.map.

You mentioned in your response that this depends on patches from the 'mm:
BPF OOM' series (PATCH#2), but this dependency was not addressed in v2 -
the same non-existent API calls remain in the code.

Should this series explicitly list the dependency on the 'mm: BPF OOM'
PATCH#2 in the cover letter?

[ ... ]


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/25563319416
--===============9112384240899730167==--

