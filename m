Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F48CD25924
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 03:08:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B01C36B00A0; Mon, 26 Jan 2026 22:08:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A954A6B00A1; Mon, 26 Jan 2026 22:08:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CB726B00A2; Mon, 26 Jan 2026 22:08:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 88A7F6B00A0
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 22:08:53 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3BF3DC33AA
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 03:08:53 +0000 (UTC)
X-FDA: 84376261746.12.01D8341
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 79658180005
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 03:08:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JKQEOq7c;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769483331; a=rsa-sha256;
	cv=none;
	b=URu9w6w8ok1eSe+JJuOE6rC0hS63+IDiwEjoRqhdomQSewQRyorfRCWk1doBRx1W+BPNwz
	z3G3kUiXGdk1alWcR/Kc1fqIhKYdf4fqatqAaVncBE9mDHDydt4X+mj82VhVBbT68PmBGx
	M/MhklVnF72eoCFJb0cF5Mh+Kj8/sG4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JKQEOq7c;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769483331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hpAMABF6aWHZNDNBxjlyF5dQr2lpDWiDtRrX+anFGt8=;
	b=JmaCjH/dOpo4nE3s9yxshr9RKzRE0HYApaKVSpdLBHW1j3gHrrIGpSLIF0b/THhfbAnsuI
	9ZEGn8hXqDkc+jSXMbYRpxoW3CiCkWuN2OWswsNZGjBVSfvRgnIDarXpLCaSBv0oQZ49Wq
	MDO/KXOaiFEJyKlb9ZiDYPPhBrQA2IY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1BC3244202;
	Tue, 27 Jan 2026 03:08:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF41C19421;
	Tue, 27 Jan 2026 03:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769483330;
	bh=a4VyBzG5dwslC57qu5s+IUxQjhwEMBgmA6+b7sDs1Lc=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=JKQEOq7cowOtLsJ4Z1TMDc7IHAQnmYrT/AGgqI8Cs8Ldn9Gg1LtTEkevR/3S0yBi2
	 wQubFz8NKQSakKV3FU862ym939s/n/gQP8rbolxCSW9cbVFGPsAVHtx3KY8865X6Qd
	 6hTXPWzehMbrocWt4M5AvBupot9x5oyGcIvbgN0BChRAw/aSvYk03yufwemo7st1lE
	 cE4f+W2lETLsuUqcf89RRUxe6WjkG0Mp4zlK9XgRlu9k2yS7qT45UTcG5C9Zni7Mhd
	 7Y7m70FQ5Yg3A7lO2wRcH9dA8zVMKjSkS6/eyzT9EgNcqsPGhgi9MgR3mzMLIj4nQe
	 hsqaQhvimHCYg==
Content-Type: multipart/mixed; boundary="===============2565306889531042229=="
MIME-Version: 1.0
Message-Id: <3af5210f45be4a508e584263a5517781ca762d28d4f6b831b987795662715e61@mail.kernel.org>
In-Reply-To: <20260127024421.494929-5-roman.gushchin@linux.dev>
References: <20260127024421.494929-5-roman.gushchin@linux.dev>
Subject: Re: [PATCH bpf-next v3 04/17] libbpf: introduce bpf_map__attach_struct_ops_opts()
From: bot+bpf-ci@kernel.org
To: roman.gushchin@linux.dev,bpf@vger.kernel.org
Cc: mhocko@suse.com,ast@kernel.org,mattbobrowski@google.com,shakeel.butt@linux.dev,inwardvessel@gmail.com,linux-kernel@vger.kernel.org,linux-mm@kvack.org,surenb@google.com,hannes@cmpxchg.org,akpm@linux-foundation.org,roman.gushchin@linux.dev,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Tue, 27 Jan 2026 03:08:49 +0000 (UTC)
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 79658180005
X-Stat-Signature: jub6aakp4f5fq8qkkpiactztredi9yd4
X-HE-Tag: 1769483331-741140
X-HE-Meta: U2FsdGVkX19WpR4+GyA+zkA9T0h0dl/vEoI3mKMCtWZNneN4uqbVMHCG0Bo2X3s2JIPyi93pWb0XViJgqvXVNESX2K9CheOwjRbaEIat3/dZvS8PZ96OZ0Xezus5XKAgdp5WJeAUV/JxHEgrK4eqPXYzj6r0nOV8QYfllYZSEFhAUHyXUfs3qteooXfOiwlFIqlWF+J3cQVRf+wSxBgtqfXIEeC/4lvVI2GB0lP9fUw8sW7jlwO9nl1CgRaxYNdQHaeOPUY0GNlA8XbtiESQ/k4EeV4LxHx1/XQNHl0Z6YEHma1Sm9YPmOj3ZafIfuNSSeWd/vDsiiMngv2FMG/EM3ebOrd+8Z2zgeC4u1wDpapxbhuO5m6e1aNhalbNKyuKb8sFZMscdGPb4QKORvOdlSeMA6dFK0ptE+f8HYiw8Wp/ALuvWAcorZ+pudULP/y6Qv1rMe6CfQaKOhEZQp3sVCZ3wNn/ZNQ9kfais83jjjGEf+ybGjtEWuyFmClZL6fxoj9A4TmB5iSzYuEBzdiMIcWdZhl8Iu6CVqm15XTtOybJPqFzmcczfkjM2uPxTjhoJRN2gVTCus3sENjMQ1LCA7U9toH66ehyXNmp0Y4JtTV5zmp6SgPoTLS5lVzEyhzf1Y4Cs4lAj1fLwLHcwf0p/8ilTZG5USTww47GH0BSGrP9cX2rBIrFUucT8t4fPQcvSig3dTf+w+A6QnTNq1NDMXbknDuKi9tlibMsxiaoGmMjcCpHMe31Ut9sU20z0GYN5Yb+Nec/Nnaj01/CYczNjr74giFQO1Y7ZltqP2PVSjJspdqPDRhGwYdqqZW5erCJNkBYkqHq6pylYb1dkSdxKeQ/gVbGHHxEO06EWXmSMg6lM7O2b1no3B5UJVkcNm5YEtPP8tOCprYh/sh4WXYrj//p2u+TCZh9at+SoRSIb9ayPzxvhQdcUSUGzm85Zme/UdH7OjzERh7bHfAb7av
 vJSx90Q3
 8f0h/KM+hsjObZcHcQC+1iDA0TlkJtlht7k3zWPNrko97Dq7DF8BuQOowYU0CqpbpN3W7kdzaQGDLccYPfHQIrGAoa0y18VNTndoUii3Q0Fcn9Iul99F8O4z0EW9psSX/3H936ZVSXt4xg6xr4zPXpwWHpAUEoFY/SUYcFJ/fpbEv8gybEc6JOyrUW0/kYP1eVJbwckAgjurN4rMr6qI22mr9dPBU2WAaTrdqb6MJ4dr9jXzZKVZ7OUjPlHH+dhJnl8kUZEof/YwDQSr59xWJ6OCHkBt7z6dNlnae0mYWfCzz8siX5/cRdvu0IOIDNOvVi/AnYVLT4uMLe7J4ydSsfwCtSxktaGjTePS9X8Gx7AT159Yjd0nssdPAVvo+MVKS3DKYVhYe/yCQMShaEmYDvJj2e0CV38D8nyY8f9Scha0dml3ifpQmpXxZlhGJrGygLLM1Lp7NFbeUqPwURNvsPOm/6w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============2565306889531042229==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 46d2762f5993..9ba67089bf9d 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c

[ ... ]

> @@ -13503,7 +13510,9 @@ struct bpf_link *bpf_map__attach_struct_ops(const struct bpf_map *map)
>  		return &link->link;
>  	}
>
> -	fd = bpf_link_create(map->fd, 0, BPF_STRUCT_OPS, NULL);
> +	link_opts.flags = OPTS_GET(opts, flags, 0);
> +	target_fd = OPTS_GET(opts, target_fd, 0);
> +	fd = bpf_link_create(map->fd, target_fd, BPF_STRUCT_OPS, &link_opts);

The code reads flags and target_fd from opts, but the expected_revision field
declared in struct bpf_struct_ops_opts is never read. Looking at similar opts
structures (bpf_cgroup_opts, bpf_tcx_opts, bpf_netkit_opts), they all pass
expected_revision to bpf_link_create_opts. For example:

    link_create_opts.cgroup.expected_revision = OPTS_GET(opts, expected_revision, 0);

However, bpf_link_create_opts has no struct_ops sub-struct to receive
expected_revision, and the kernel's bpf_attr link_create union has no
struct_ops.expected_revision field either.

Is expected_revision in bpf_struct_ops_opts intentionally unused? If so,
should the field be removed from the struct to avoid user confusion? If users
set expected_revision expecting it to be honored, the value is silently
ignored.

[ ... ]

> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index dfc37a615578..2c28cf80e7fe 100644
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
> +	__u32 target_fd;
> +	__u64 expected_revision;
                 ^^^^^^^^^^^^^^^^^

The expected_revision field is declared here, matching the pattern used in
bpf_cgroup_opts, bpf_tcx_opts, and bpf_netkit_opts. However, unlike those
structures where expected_revision is read and passed through, this field
has no corresponding code path in bpf_map__attach_struct_ops_opts().

> +	size_t :0;
> +};
> +#define bpf_struct_ops_opts__last_field expected_revision

[ ... ]


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/21382620878

AI-authorship-score: low
AI-authorship-explanation: The commit follows kernel conventions and existing code patterns, with an oversight (unused expected_revision field) more typical of human development than AI-generated code.
issues-found: 1
issue-severity-score: low
issue-severity-explanation: The expected_revision field in bpf_struct_ops_opts is declared but never used, causing silent data loss if users set this field expecting it to be honored.

--===============2565306889531042229==--

