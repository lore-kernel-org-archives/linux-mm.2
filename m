Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 208E1D2D8E5
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 10:08:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C9666B0095; Tue, 27 Jan 2026 05:08:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8582F6B0096; Tue, 27 Jan 2026 05:08:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D9836B0098; Tue, 27 Jan 2026 05:08:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 583406B0095
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 05:08:35 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2A020C2EE7
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 10:08:35 +0000 (UTC)
X-FDA: 84377319390.27.2399EB0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9A8CB40005
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 10:08:33 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20201202 header.b=QkWZSo7P;
	spf=pass (imf17.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769508513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JQzaE/u6Pw6XeXykc09hPOw7NqXMhukk67zDFU/gsT4=;
	b=DM7asQ54/+zlN06XZUIEGKWgY0EWs+vxrn7VynzLuaVU7z8Ym7m95U8aVKozFxGDMXAc92
	kBqj49AyKAUlZkyeJm/exF1B1gr8618tNVhsplbinlztqrzkV3O5RepC0Xg/+q5tzgYMqR
	HbkRtiPcW27LEaElLMa2ttUA3CmybJI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20201202 header.b=QkWZSo7P;
	spf=pass (imf17.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769508513; a=rsa-sha256;
	cv=none;
	b=F9iUynBeMrUObeQt4xSHbYOD9l/177lsJvc8VTmYG0Hv9V9Ct3SrC8BfNfgvySBQn4hHxf
	rdDTl6NxdoAfSC9sGuWTwxnwjaw73ctZwZx83oaCsmRU5eL5fA2YR0yluuqyfMI5Lpi20X
	fWC3ifHxWgqpa2OzIzStJphVAVhZHbg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 207B96012A;
	Tue, 27 Jan 2026 10:08:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1CD6C116C6;
	Tue, 27 Jan 2026 10:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769508512;
	bh=cy8xGVioBJHrY+OkOh4J/GrPQP8YQgHcws3ff81U3Ko=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=QkWZSo7P+uvsQFRqjZU2/MEn3LFFKSGP8uzTF83Ktz0a8JbxiiG3oUXSED78YLS6v
	 5ssWJ/1MFokjk5gx1S2wSXzZIs/quR94uCeO3/rTYJGbbKpCTe6U6qcrMF9L/5k9Da
	 u2C5zU0e0kCiXXq/et2CoNWMsT0kypjuXv0e/6ktqoxvZCW03AHGxaw9IrWoOnR2ws
	 0SnkL0lzIzzEJwikvU2NxvYItrCKLabKWSQdR10jSTNwdmxE7CB00+/ANHx48rqs6o
	 d/HBwBtgOXpiuR0hgI2sC0cxKpbIrv6INxhTK7M0uNebxa93K/Vc3jrkJp2tiht4B8
	 5R/oSenmYBOPA==
Content-Type: multipart/mixed; boundary="===============3455022572687602342=="
MIME-Version: 1.0
Message-Id: <7a66cf5f0e6a1e441fde4e593b26326132bd100531a9a1c5d318edf526ad6a6c@mail.kernel.org>
In-Reply-To: <635923ceadf1899672e4f7727ddc52554c11a3ac.1769506741.git.zhuhui@kylinos.cn>
References: <635923ceadf1899672e4f7727ddc52554c11a3ac.1769506741.git.zhuhui@kylinos.cn>
Subject: Re: [RFC PATCH bpf-next v5 05/12] libbpf: introduce bpf_map__attach_struct_ops_opts()
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
Date: Tue, 27 Jan 2026 10:08:31 +0000 (UTC)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9A8CB40005
X-Stat-Signature: 4wggxo4we68o7zniih6jipsfxhbx1cgc
X-Rspam-User: 
X-HE-Tag: 1769508513-320371
X-HE-Meta: U2FsdGVkX1+4pUPtHVXRjgBHOcL7Hqq4y4R6twia5+bXQai/PWvFP3S2/VzLeF4SgLXQnxzyqA9tg4tdHjvrBwaPJQUUfA26bkGunu0hg4zdPLu96Y8ABIAhEnin0bmzKzKPbahxSUZR67x1d33ohGfcFseLgUWsNrEPDpgCNYzvrsaTrCxkmkRbBDr8p3n6kr8sjkz29u7GbwYTc1jj8k2WHETch5BHsNfeYhgb3KdF3xjyw/93J4QFMd4PFpZVjFmkrrrE+cDHB/0nPVLD4r1Qh+Zk557AWNnwPX97LRoKuziUeQvcDP4iO4pSgnZdYL9/yxmSSmhPx/iBBcBwXZvuo9vcTbPO6TrxgAQUjwojPVlsRftj5YpicJ5aMqcWzHpKZRwRxD6hhtYyFT6SyuaUFHkxghDYPdXBZ8NlMN6u3wmP//Z50TmZRXJYx3WGlnu12MqaHcGUYtC9BxUJQktYY5kTARDCVZdRUlZgMJ4GhQS46gYnpCr8JlJM+sd7d1Lc8F1CyS49tlFQQ9GpXH7smbj6stsdkVO9GJT76kOcFAl1Xda1mco16zblHr8kbUhx9QSOvJ84nhrAXj5xZsy1XTfuqBGVUrWbe16KTQUwlpep8WlFZOPuXDCeSHMGZYzJX2ju8wABB0dzWvfrzjxSi8pWDW2DGitAQ/LLm5nleTv1S8gUtBlZE87WqBdy/QZ4bfmTGtiWGC3+G+AAvK+FLUYdmeOddh1pCQtTbc0CN2BX5abvzfQ9DgAJN96x+dHw0OuVgJCDIiIIxtDoXF6EdxNehbwlYphAMQz3k7d85N0Cxp60J4xhWxLLlJvO3QaX0pvJWayziGB3LaAK8ZJqdmnxnxPh6L9dnCxRnU2CZ9t5fI9JTqLWWStO6NiGzLGk1DGuauaoGNhxkY0aAMy0Bo50gChrZN4z432E/RA6HmpifXleVo0QO3ZRIn5rYr4oemtWf7FCD8oXF5H
 vIcjrhAY
 y7z8aD8JcYkX1hEjW/eAXv3Swy0jFXtsmq9np7SP9WfeF3DGVrR8ap/yUY12UjHq2iIMgdiXXgJxzjhKjgGIpVeiICIfR/QzFw/+cRsH7swl6LlUernX0Z72fR4R1RED9Nhs5DY9VzdFQZOAncKxFdpKx2LK6kumKZCKros1tLsg+TZldA3Ko0XHXeUZ6tcciWc/28XIn9PclY4jnOwDpox65VY68reYiKcpIvWN8DIfSrPg9v0TesJOQ7SE95bCeiC320L9hWdgpPRY/p7mZ7dOSqzr0GXz3hv33guD257DDa4dWrlTMq7EXaKoYvC5cN1TMRSKuyoqqCEeD2YN8oyvfiIETLG0lMRYn90BYU9pwc6X0HswjoS7OAaCtXJM+Ok6mSvf+rfVSeo9Vn3wXyW/z+I1Oeb2joJpjJUTvBSLxxT3C54PnwBkX8/bdrwPnSrMvxmmQYnz/1nG1BQooamQYMOOrT8cbMabF4Klwkfh1gqCbrh5x5opFaMpnbMUGIG7uGeoAjNDiRnIuok0bzibOB8kyuJKIA9/BpQW98ugolNEV3plWnDPQl3NFgxfdu6dB1rBBhUs3kgZT7olCVaHnyQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============3455022572687602342==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> index 5846de364209..84a53c594f48 100644
> --- a/tools/lib/bpf/bpf.c
> +++ b/tools/lib/bpf/bpf.c
> @@ -884,6 +884,14 @@ int bpf_link_create(int prog_fd, int target_fd,
>  		if (!OPTS_ZEROED(opts, cgroup))
>  			return libbpf_err(-EINVAL);
>  		break;
> +	case BPF_STRUCT_OPS:
> +		relative_fd = OPTS_GET(opts, cgroup.relative_fd, 0);
> +		attr.link_create.cgroup.relative_fd = relative_fd;
> +		attr.link_create.cgroup.expected_revision =
> +			OPTS_GET(opts, cgroup.expected_revision, 0);

The bpf_link_create() BPF_STRUCT_OPS case reads expected_revision from
the opts, but looking at bpf_map__attach_struct_ops_opts() below...

> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 0c8bf0b5cce4..70a00da54ff5 100644
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

Should there also be a line here to forward expected_revision? The
bpf_struct_ops_opts struct defines expected_revision and the BPF_STRUCT_OPS
case in bpf_link_create() reads it, but this function only sets relative_fd.
If a user passes expected_revision in their opts, it appears to be silently
ignored.

> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index dfc37a615578..5aef44bcfcc2 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h

[ ... ]

> +struct bpf_struct_ops_opts {
> +	/* size of this struct, for forward/backward compatibility */
> +	size_t sz;
> +	__u32 flags;
> +	__u32 relative_fd;
> +	__u64 expected_revision;
                ^^^^^^^^^^^^^^^^
> +	size_t :0;
> +};
> +#define bpf_struct_ops_opts__last_field expected_revision

The expected_revision field is declared here and is even the __last_field,
but it does not appear to be forwarded to bpf_link_create_opts in
bpf_map__attach_struct_ops_opts(). Is this intentional, or was the
forwarding line missed?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/21392729810

AI-authorship-score: low
AI-authorship-explanation: Commit message and code follow standard kernel/libbpf conventions without unusual patterns typically associated with AI-generated content.
issues-found: 1
issue-severity-score: low
issue-severity-explanation: The expected_revision field in bpf_struct_ops_opts is defined but silently ignored, which could cause unexpected behavior for users relying on revision checking, but does not cause crashes or security issues.

--===============3455022572687602342==--

