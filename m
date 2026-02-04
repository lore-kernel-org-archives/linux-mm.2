Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B869AE83EFC
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 09:28:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D7DB6B00AD; Wed,  4 Feb 2026 04:28:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A2716B00AE; Wed,  4 Feb 2026 04:28:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D0446B00AF; Wed,  4 Feb 2026 04:28:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 43A846B00AD
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 04:28:46 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 12AE313B926
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 09:28:46 +0000 (UTC)
X-FDA: 84406249452.13.82527C2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6A3C7140002
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 09:28:44 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20201202 header.b=AFSx54P8;
	spf=pass (imf09.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770197324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gSA7mipH8R///bnGI8oY4vMfZ9Nl42jQEHercPVesk8=;
	b=Ee1U5ashdQU2kPzOZ3dM29HoWM+xtHHc2dlO3+9Z180GFykJa6jKus94hIWNk0VWs+MImY
	hG/tQ5UgnAS8k0ibMtY5Hq5ko6aWSzJZQFCwk7w+an9Pmwf9ezEN3Cz0Xxn4zi7F0oeRDZ
	ICtcSf8CDFG7h9F3r6CAr8KEGBkFTQc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20201202 header.b=AFSx54P8;
	spf=pass (imf09.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770197324; a=rsa-sha256;
	cv=none;
	b=QGZLpXwEOU3luW0v3zsetqVDFk54BGYJz4iUKNXeIq21PJ7nORfAyYPV8aWPoL7oQ8J2Pm
	kwT4f98PvMmKa1gso/IBeZ2mp2N59PTXqo8B+N3yWdCxDSgqNbUfi0gXimDE4uE7QGB719
	6oO7s3+hlud8Mm75JkyFB9VxOAbC6WQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 985EB442B5;
	Wed,  4 Feb 2026 09:28:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF48BC4CEF7;
	Wed,  4 Feb 2026 09:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770197323;
	bh=wNmreD1B96IJwY1XBdvP/FHXcUDoGKx185+NrO65AHU=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=AFSx54P8bWsWcKCo3dw/7CAusa6aLI+b4yMUNsGB4Ux5ceAOJBU7zoi3JUNOzBbYc
	 9oHVWnYgY/WmA1CVyAo0UI6r+m3rYBgu3W9dUg0jiGqByoxz4+zHhbhueezyHgh6t7
	 kKrOxA9zuxkC5AOu5T8QDqCr828iKaIkn73q4V8BGl+VVWT73YZ47tyXsrSYlefftl
	 zmZmIw8ea/zJ1+/dLVH7dhbnqMImPbd486nAd7rnw4lMfwqC0nlSTceXptUMhXQ8HR
	 Ry8/jNQ4ib598H8RXm17+FE1TUvAWp3tT0Ae+bA6ETEpGYjkcZBZRVdsUVhSyIPShf
	 Q93mDkPKVXg9g==
Content-Type: multipart/mixed; boundary="===============6939426097549955783=="
MIME-Version: 1.0
Message-Id: <bec784d0d78a505dfbfbd17ffe95840dc356c80ceec2a96f9659b442b64c92c6@mail.kernel.org>
In-Reply-To: <8b9d7d9485c627dc05cdeb6863abd5a1c81c95ec.1770194182.git.zhuhui@kylinos.cn>
References: <8b9d7d9485c627dc05cdeb6863abd5a1c81c95ec.1770194182.git.zhuhui@kylinos.cn>
Subject: Re: [RFC PATCH bpf-next v6 05/12] libbpf: introduce bpf_map__attach_struct_ops_opts()
From: bot+bpf-ci@kernel.org
To: hui.zhu@linux.dev, akpm@linux-foundation.org, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, ast@kernel.org, daniel@iogearbox.net,
	andrii@kernel.org, martin.lau@linux.dev, eddyz87@gmail.com,
	song@kernel.org, yonghong.song@linux.dev, john.fastabend@gmail.com,
	kpsingh@kernel.org, sdf@fomichev.me, haoluo@google.com,
	jolsa@kernel.org, shuah@kernel.org, peterz@infradead.org,
	ojeda@kernel.org, nathan@kernel.org, kees@kernel.org, tj@kernel.org,
	jeffxu@chromium.org, mkoutny@suse.com, kernel@jfarr.cc,
	brauner@kernel.org, rdunlap@infradead.org, brgerst@gmail.com,
	masahiroy@kernel.org, davem@davemloft.net, kuba@kernel.org,
	hawk@kernel.org, inwardvessel@gmail.com, willemb@google.com,
	kerneljasonxing@gmail.com, paul.chaignon@gmail.com,
	a.s.protopopov@gmail.com, ameryhung@gmail.com,
	chenridong@huaweicloud.com, lance.yang@linux.dev,
	jiayuan.chen@linux.dev, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, cgroups@vger.kernel.org, bpf@vger.kernel.org,
	netdev@vger.kernel.org, linu@kvack.org, x-kselftest@vger.kernel.org
Cc: ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Wed,  4 Feb 2026 09:28:42 +0000 (UTC)
X-Stat-Signature: xgo8k3hph7oencgka3k7jck5418cxpyn
X-Rspamd-Queue-Id: 6A3C7140002
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770197324-896358
X-HE-Meta: U2FsdGVkX19eGisRJQiCjMw7+N+NIfJCe+jOaMrI6NR60HfuQxu+7OvV0r4yWiUaoQdm8kX2/wcY8VZO0qcJ4yQ7cit4NLUeph83jqw9LUrQb+vATtfDrJb/99/hoJGjkkGH0vqEm3lyzDr0lsuNwxESmmNgiZLqMKE749cCA9LuUFCfI9TL+3kDngF2NolnveadcPAcImorqQpUCW2B8Pjh/EWT5fJXs3U46Bz3FG8mLVIwJOJrs1Crz3LsncdSRT2MvROFobynNVjiw3ltBrkiLYP+lLQk/tF3ziEHGEMzRQHcCJoWtZHgje2lEc0GUtVDNsF4p4S/r2rw8ydg/Pa+p0jt3weEbE6jkLUtNIegMRnArg9v2NbLg5E2J+ILVy6WjoLLFFIYmLNPrHlnJQq5NaL39rO2RRio0lwqj/8LpYgiBpbvqjifY8VfT0hpHiRSrmb586xB/T6fjyDZuU1jXmB32Fa+YLKn+W0a6OVfAg9ErAhqbXM2cl43511O1/e1wWf7QhtUS0uETNLGsSi9ogzHkTeRv3M3/Q8pXAZY4caLurKl/BN47BT58yrEoEu4DzwE4cd+iXqvbEJQgWGDxvrhrawvADx2IbXtF/zDDKvL120rL9us9Ad8iP5o9zS4C7pRz033MChN7ObPhG816XeEDHnFy0R/Q4yoDJqVqmP0ZjsoyvI9lFPzRSNjl+kW2ZsplAFCp21DMQyd4ut5iPHpDsyXJt51IvEFm4MG/LO9rW36xV/xaPP7dao2ZF2GB0rWH6QecWC32iQhIf9BsttkYbEv7wx8h+fbzuXLOBgKRtzotmdOA6q642Hgv+0Yz98vtAfrnFh9wDZIJHOPLO6WSr38RkuTA9HkctyMU8xoojAV7EA3173181JwXZFxH7mOwcM0ZpLJXvlsu3U6cyVyhKazDC+EHsIQT+SK9ohFuv9wFmUvhiTMwn+axUj6i70wMd1F2MFtlcp
 VNUB83Jm
 v5Jluhy6/40Bio9p/sySaxmXbzhusIi4JHdS9b8UpGKwrKVF9BebngubSLFhDYaApkCHGfCGZiCt9/ONllIxuveWPyDoC3cp/uvLNQGWR9Q/mVWvWysDikbFnY0A8VFKLIGCytjNx77X52Y42W8mYpab2qCPUFfJnZ6StNeKerrdyLkYKCDyU2JM0nVPJ9jfMZu8Ll7H21pD3u9Hij68cYuHIqO0hGPSdgk1qDg70JpxCYisvaSigXwMmgsKYMGX4/Dr1GtTpnrcqD5D7gVaVNcQgrmZzUV6xKm0j2l7n+LuuzToRyWN/9R2odyhbZqP3wCyYkdZgj/DrjdeYPDMmPep2DogzZW/95BtmG9ZE6FNuvSsiwpudYnCzF6Y2WmVR1dMvJHUwJz/xoKc53bdDdClh/30e11Ln3iY4TlfB1sc90hRXEdbWQT7Hqbm+sIsz1AifpdoFoagZjB46lIAxoXgzKvtCguoCjNJyru9JHHuV3x/wADUuBIvxvyVY/sIgsv80OyJFsLgFxp/J+/ygVXVYFg2TxpZnE0EAjwkdoF9ahYclHIJKQqqssrFBNkC1BfVNDXOzRpF/AmJO1sKv9rNA1g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============6939426097549955783==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 0c8bf0b5c..70a00da54 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c

[ ... ]

> @@ -13503,7 +13510,9 @@ struct bpf_link *bpf_map__attach_struct_ops(const struct bpf_map *map)
>  		return &link->link;
>  	}
>
> -	fd = bpf_link_create(map->fd, 0, BPF_STRUCT_OPS, NULL);
> +	link_opts.cgroup.relative_fd = OPTS_GET(opts, relative_fd, 0);
> +
> +	fd = bpf_link_create(map->fd, 0, BPF_STRUCT_OPS, &link_opts);

The expected_revision field from bpf_struct_ops_opts is defined in the public
API but doesn't appear to be forwarded here. bpf_link_create() reads
opts->cgroup.expected_revision for BPF_STRUCT_OPS, and similar functions like
bpf_program__attach_cgroup_opts() forward all fields including expected_revision.

Was the expected_revision field intentionally left unused, or should there be a
line here like:

    link_opts.cgroup.expected_revision = OPTS_GET(opts, expected_revision, 0);

Note: A later commit in this series (e83943e72 "libbpf: Support passing
user-defined flags for struct_ops") adds forwarding for the flags field, but
expected_revision remains unused through the end of the series.

> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index dfc37a615..5aef44bcf 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -920,6 +920,20 @@ bpf_program__attach_cgroup_opts(const struct bpf_program *prog, int cgroup_fd,
>  struct bpf_map;
>
>  LIBBPF_API struct bpf_link *bpf_map__attach_struct_ops(const struct bpf_map *map);
> +
> +struct bpf_struct_ops_opts {
> +	/* size of this struct, for forward/backward compatibility */
> +	size_t sz;
> +	__u32 flags;
> +	__u32 relative_fd;
> +	__u64 expected_revision;
                ^^^^^^^^^^^^^^^^^
The expected_revision field is defined here but is not read by
bpf_map__attach_struct_ops_opts() in libbpf.c, so any value set by users
will be silently ignored.

> +	size_t :0;
> +};


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/21665371660

AI-authorship-score: low
AI-authorship-explanation: The commit follows standard libbpf API extension patterns with consistent naming and structure typical of experienced kernel developers.
issues-found: 1
issue-severity-score: low
issue-severity-explanation: The expected_revision field in the public API struct is silently ignored, which could confuse users but does not cause system instability or crashes.

--===============6939426097549955783==--

