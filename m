Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9351ECD3424
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 17:35:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E60C76B008A; Sun,  3 May 2026 13:35:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E11CC6B008C; Sun,  3 May 2026 13:35:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4EE76B0092; Sun,  3 May 2026 13:35:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C93066B008A
	for <linux-mm@kvack.org>; Sun,  3 May 2026 13:35:26 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6CB128C7AD
	for <linux-mm@kvack.org>; Sun,  3 May 2026 17:35:26 +0000 (UTC)
X-FDA: 84726810252.07.B3A56C7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id B3860120007
	for <linux-mm@kvack.org>; Sun,  3 May 2026 17:35:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VIlgec5Y;
	spf=pass (imf29.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777829724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GN39IVhl46BFR07AUR8szHt2wyzVwSB98dBsnOAUilw=;
	b=Ih7zQSxXTJ9IMt5fDQ/UsG2sdV5M126VZuh8odrLp7xHZpj1m5EjHSTnESiKtIOpvC4Ptk
	olvaLxzTV7DiDXOuA6WOKn2rsuYp6gMBOsFsiIlG/yIIdt8XKdJ3LmAYTmzKreqi39HM9w
	zYwSizqJUA1ulrruyY4E3NM0uGKw83A=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VIlgec5Y;
	spf=pass (imf29.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777829724; a=rsa-sha256;
	cv=none;
	b=XCRLZZicp/yk48lkIxLpE14xoccn28wTzth8hWSs+DEI7r9J9PeDqm6pMq3+GURxmnkWYI
	bPgickDfFPxToDkMyFTK89rHOjpGiZX3Lvdw6BBGcCWAgGJ+IrMi7HTsigr+w7fWpAc9k4
	jF4ovTgn/wrXTTJzQdkrJ/lvucDWtCY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1CD1060120;
	Sun,  3 May 2026 17:35:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09CCFC2BCC9;
	Sun,  3 May 2026 17:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777829723;
	bh=Lrbq7R7Bs5eWqu3TEwgo9f4OD7xPcRENrhdU2XXOl0A=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=VIlgec5Yh5iXUJEtyLNGJT5aaPlFySsTzVBmX5hflWEE85zhM5aC5OyUjs3u5ztrE
	 VI6f/x9ghuq5XVWhylPpM2Z24thZqpb733UVpzxUUJGRwqY86vGCjsSYIrRjS26YXX
	 ZP6R52r9MoQWLd4JO6AWWK2+LxkV6WAgp2Y2vNflCOjIigPTal74EOztAveZCDA5Hs
	 fbVYwk5eAxn7DsYWFnp5NfqqVPTPh7lUVz43vzWA8dPSYrBJ4wlE+QWHxzgX+svnx4
	 9eLjJsAPGmuOcrqmJm0QzyQootQ9/mGvFrtebKInoUIk8cPC3R0XeNF0c+09fdjBfk
	 iQoiJKDY5ZCLQ==
Content-Type: multipart/mixed; boundary="===============8100301415052033692=="
MIME-Version: 1.0
Message-Id: <c13f99d42c434ec73ec1e8cf1141047146ab359e60e56e78e1c32554d6e01e9b@mail.kernel.org>
In-Reply-To: <20260503165024.1526680-5-vernon2gm@gmail.com>
References: <20260503165024.1526680-5-vernon2gm@gmail.com>
Subject: Re: [PATCH 4/4] samples: bpf: add mthp_ext
From: bot+bpf-ci@kernel.org
To: vernon2gm@gmail.com,akpm@linux-foundation.org,david@kernel.org,ljs@kernel.org,roman.gushchin@linux.dev,inwardvessel@gmail.com,shakeel.butt@linux.dev,ast@kernel.org,daniel@iogearbox.net,surenb@google.com
Cc: linux-kernel@vger.kernel.org,linux-mm@kvack.org,bpf@vger.kernel.org,baohua@kernel.org,lance.yang@linux.dev,dev.jain@arm.com,yanglincheng@kylinos.cn,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Sun,  3 May 2026 17:35:21 +0000 (UTC)
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B3860120007
X-Stat-Signature: n8w3zfm7s4oho1piekf8r6tofupsuei8
X-HE-Tag: 1777829724-648578
X-HE-Meta: U2FsdGVkX18wu0OMqxtvgGmLFZcCscMnDnQ6a3dYCTFgnFa0jJAPKWQa2Ae47fEanudSE3S+qQHRei6igZ7//9pRHY0BwZqn57FArevpe0+8vod/tPP9lhbhRuFalfxU9bwdreygGVjCTIFUKN9/oeFs4XC5Mvj+W2NuDgfUcCpEHQk2+avmytY/6oFPRmmQnTlnHvr3TNDwd7gY0lPijtJq8pQlQXqWUUozLq/a9VmiOsoJ0lUx0iA4Bfy6ln5dlaBJuDvpa+iQBj03Xt8HubAU2dwYHMrKmlAwLwaJ1FYyNHQZ2k9lwSGSFO/dNv0z73GDRLd+vakSl9wK6JIDuaU3vnln6rTr/cVAOiPVQgBl0yIy8+iumUyl2EEzzUQ3mrOpqdn/FWCzncimJ7hvoEOK6FZvgAr77BYav4xIWbJbCZyqVJMeeCF+ijeAztxyUbpppFO+i6P4Gs6b3Vyw+MAmLPuFs2ZAOjT+GNDw90edNa7ZDZRxx3j5hkfm4IlpSmy8/dR3xS29PltNQSmYMiTKyLfAnokWdMiic5fmdOusEsxGZ9Pgw3HbapG/HPmrjZOJiLpXKY7lXtuGWIFy1SeMhYlP1HYSB2fl++CLEDe/XS9v7lltvfuK/q1+aCt6wcd/Hmj3Ek4kPZQkWy2eXQBL0WJtlYqk69UIqPm9QG7a56cl48uZFiPudhOgp6rT4BSBUYeijhtrEkPkIF6E+xAtbtnUmMDIJxSZqlNaHHBLYfADM50lqGpqBNPNTj3ak7G2CurbX9NWgbZh7hp8Y1K2F6uda5HqCOT05b6EQ6jf9TLH73w52xZZcvDEcExACYJe/8KxD0ObuHkmlNlj6/6leIzO2uJ78eMGFhFzJR+Jt5HupWXdPJri2g4JwIaRwEKKby25+oCYa5rIQVV7/XYGfr/ri2DWfwRoa6+vqIGA3y5aEriLmFIjn5EddECok3xeJFWD2EJkQ2bSOWN
 9Ed4iIf0
 ewKzL4FPXM/hImmDxl5roGRO2OWf1Q01dYR88ai9ChTdDMRQONtKZnCiqRccGo9SBmNeFdc4R+9+MUgCghI4/r/IQOAWBCal8Ib2B064+NwCHi/EsUbW7bVSH0VoN81FTAxqEUfFAiUoFXVkA0q2x2IA31LfqHgzFNUKJ8IJZDJR9Ilyq2XGtjiv8y/dsfkTEyzSmKEifwJ3TB/V4ZxowMqZr1Yo7XQkJn8jXXux3Wt0dDyi+Zelb4HbtoBwJ7sxHZL87bxNjmYbVpy3M4hUFRKMdh6Ty7lm3iUnxvfXr8iiWj5y9JbtLX/6HB1hvW5rmawA6UGFrIV9WrsJNX59ybryK/6zfuEPdXxfXJVg30ICxVVgZD0Wxf8ZEmxb9XNneXftbtfMr7hYZcHlG2B6QxlYAVae+KsTyDea6nfRiEhBfo988D0FeGM5jegV2kzFj6MTJdQxNaXiM1rNbJbrij2Kj8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============8100301415052033692==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/samples/bpf/.gitignore b/samples/bpf/.gitignore
> index 0002cd359fb1..2a73581876b4 100644
> --- a/samples/bpf/.gitignore
> +++ b/samples/bpf/.gitignore

[ ... ]

> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> index 95a4fa1f1e44..357c7d1c45ef 100644
> --- a/samples/bpf/Makefile
> +++ b/samples/bpf/Makefile

[ ... ]

> diff --git a/samples/bpf/mthp_ext.bpf.c b/samples/bpf/mthp_ext.bpf.c
> new file mode 100644
> index 000000000000..bbee3e9f679c

[ ... ]

> diff --git a/samples/bpf/mthp_ext.c b/samples/bpf/mthp_ext.c
> new file mode 100644
> index 000000000000..0e064bad136f
> --- /dev/null
> +++ b/samples/bpf/mthp_ext.c
> @@ -0,0 +1,340 @@
> +// SPDX-License-Identifier: GPL-2.0

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
                                                   ^^^^^^^^^^^^^^^^^^^^^^^^^^
Will mthp_ext compile with these symbols? A tree-wide grep shows that
bpf_struct_ops_opts, BPF_F_CGROUP_FD, and bpf_map__attach_struct_ops_opts()
do not exist anywhere in the kernel source tree:

  $ git grep -n "struct bpf_struct_ops_opts"
  samples/bpf/mthp_ext.c:260:	DECLARE_LIBBPF_OPTS(bpf_struct_ops_opts, opts);

  $ git grep -n "BPF_F_CGROUP_FD"
  samples/bpf/mthp_ext.c:261:	opts.flags = BPF_F_CGROUP_FD;

  $ git grep -n "bpf_map__attach_struct_ops_opts"
  samples/bpf/mthp_ext.c:263:	ops_link = bpf_map__attach_struct_ops_opts(skel->maps.mthp_ops, &opts);

The struct bpf_struct_ops_opts type is not defined in tools/lib/bpf/libbpf.h.
The BPF_F_CGROUP_FD flag does not appear in include/uapi/linux/bpf.h or any
other header. The bpf_map__attach_struct_ops_opts() function is not declared
in libbpf.h or exported in tools/lib/bpf/libbpf.map.

The only existing libbpf API for struct_ops attachment is:

  tools/lib/bpf/libbpf.h:
    LIBBPF_API struct bpf_link *
    bpf_map__attach_struct_ops(const struct bpf_map *map);

which takes no opts parameter and cannot attach to a specific cgroup fd.

Samples/bpf/Makefile was modified earlier in this commit to add mthp_ext to
tprogs-y, meaning the build system will attempt to compile mthp_ext.c during
make samples/bpf/. That compilation will fail with undefined type, undefined
identifier, and implicit declaration errors.

This looks like it depends on an out-of-tree libbpf extension that adds a
per-cgroup struct_ops attachment API. Is that libbpf patch supposed to be
included earlier in this series, or should the sample use a different attach
mechanism?

> +	err = libbpf_get_error(ops_link);
> +	if (err) {
> +		fprintf(stderr, "ERROR: attach struct_ops failed: %d\n", err);
> +		ops_link = NULL;
> +		goto attach_opts_fail;
> +	}

[ ... ]

> diff --git a/samples/bpf/mthp_ext.h b/samples/bpf/mthp_ext.h
> new file mode 100644
> index 000000000000..33dc01bcebd3

[ ... ]


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/25285279315
--===============8100301415052033692==--

