Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46C46D72350
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 09:19:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AF326B0488; Fri, 23 Jan 2026 04:19:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92B6E6B048A; Fri, 23 Jan 2026 04:19:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 771736B048B; Fri, 23 Jan 2026 04:19:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 591206B0488
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 04:19:06 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1FA7616018F
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 09:19:06 +0000 (UTC)
X-FDA: 84362679492.24.A1E1471
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 895D81A0004
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 09:19:04 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20201202 header.b=kiwWVxqw;
	spf=pass (imf19.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769159944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PXtqj8SNV9zwzZjcPiVAucc5VG6lk9uPprPrNqSZIy0=;
	b=zXhY7PvjaYe1/EeNDtiBB8ejhMlmYx4EPNeqjHQCCHcbW0xJr/YdzsD/OWKvlJKaAd7yJi
	lBkY837uVZGuInVgjACxIiYFgYvj1ZeK6z+UG19LqiM2CV1CKQ0e+E8lFqG5kZV4DeXm5r
	o4RjGbCGDTzY0Osgs+E484Yrx54Sofk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20201202 header.b=kiwWVxqw;
	spf=pass (imf19.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769159944; a=rsa-sha256;
	cv=none;
	b=vc+Xd5HqCNqPI3bmfV12CqRhoJ0kMr22vi3huvChe7ExnUjGoSdJTpcAkN/URgvrqxvf1Z
	Y6MTGm9H4NAIY+eWxm8Lf2tErVvjyOTO4X8n6nKywYzgOmvuzPNRAL/Iis8zL+HsrF6h0Q
	jNFy+rAWcu6YoDevqbiLTeqDFpsL17M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6ECDB44482;
	Fri, 23 Jan 2026 09:19:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B4B0C116D0;
	Fri, 23 Jan 2026 09:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769159943;
	bh=sxaiTV/qjZ9OJLWuPUm5lpJHeVnyKAH5pIqR5axWKB8=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=kiwWVxqwhLtICIYNAcF3V6WIubpaoam1UBgKy1c2x3txZXWC6q/CUSDTEEgAIWnSk
	 KXT8Dfsl3g+fQTcj94wL+fWM2u3jZ+5yLtLVsPdtlBrnoX57qVIjJizC7LlhxREbHT
	 x2USTPdVOG0S2IAJPc4BQnNEkGTBLTEfKce5lBHI1nRyFBGI6UqYtkurROa0l8JFD8
	 gyqpPZwgCw4cJEyO+prp7szjajg5CiSXvHZ7geqQGSFMMxg8yVs7rwhv28gEDMRUNj
	 v9rjQiJ1HImsMMOLlPkKxHg7gD4JcfQuCeGjIlq9QebL7CahgT/cSaNgLXTQnrxb9L
	 H8CcOpfVl2dYQ==
Content-Type: multipart/mixed; boundary="===============6020917005380425134=="
MIME-Version: 1.0
Message-Id: <30378be80fdf3abf59019b02fe9dd351d63e9d71b9f074a9dd79de1b6a9bd6c9@mail.kernel.org>
In-Reply-To: <03bf6aafe30def690c63e454d76e733f27dff4b3.1769157382.git.zhuhui@kylinos.cn>
References: <03bf6aafe30def690c63e454d76e733f27dff4b3.1769157382.git.zhuhui@kylinos.cn>
Subject: Re: [RFC PATCH bpf-next v3 05/12] libbpf: introduce bpf_map__attach_struct_ops_opts()
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
Date: Fri, 23 Jan 2026 09:19:02 +0000 (UTC)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 895D81A0004
X-Stat-Signature: iyo4nra6hrk4dnoyzb8mj8aqzg3j87p8
X-Rspam-User: 
X-HE-Tag: 1769159944-157323
X-HE-Meta: U2FsdGVkX18n73oaGVCFD8Fb+9dFvOmuAwRjA65fSzREmiVKr1yXcGHvnjKfnXFgELcnnFbAX5D2uKdssvLReYTEgrCoggt2g0u0zKqoHTY3j+HhUBwx/v05XF7O6I6bOpZJKaHBQJP4aXeQJHRguAeVz3Da0agWmJx42vgE7KlljCXCT2CkkPMnZmvw8ioTdNTcX3qcAZ3mjFbkpmAO3L6cn++PiXb1Ax4pTeI1ai3XWCYiSKB6k2qHFdAhZ3+ssP9uqidn2mr8QfSoTYh5PgPw/CZxa+d5NtxeiE7/GVATnP5WfmBGWbe2w/PryXv0jl9Fl1/XQ7f/sf6UhW+wwiHaMFxyIgfrrSatvBKPv5ezN1ecM47Gf/k6QqZFBvCm/UGhWRBScJeAdzrVQucJyBbpui9GHcYgIEPq+GJ00hB9iQ4qWB+VBJB+1puHEldKZKuAvFJZ5t9X4GpwEyMxZ1y+wbJMTqUWYfqFteeBtqykhEEPd1gEyjZ8kU+aouur5XrOYpyTYRzwKNRVXoNvoypZ31bl3rsrreJbDT677ijAWrHyHHPflTlep5omr6S+oiNqz8TbgH+mWSqBZD34/1PAVVH4RmmZRwpPQRgXN5nDk5u0AXkwV5IKOpym8IFzDZQejroURkHq38QU1FMzwyd8AYL7R7H8wyL6T2qFngONcoOYhIzcJCs5ELRdONhC8ESj/UEcEgwRO+0pHQHauAlM+Y1cVGT2QceWltoLFN4PzRHHFz4deODj9b8YGpqHD3Gf6qRdheVIiIU+glfy2HG6nrTdmFf4CycroXzGpx/+uydTE9PIrr9yVbWqQWJ+4Ejx1v+bYWy2QvJG2lCwTjDryyxjHWQeK4AU9TOxjpEMMD8arxf75vNccPCy6bGlzZrSQYd8I3ZaJbpmdtDZR46+H8AICnJ1i9WgsI8JoKq7n7F6+GF4iDN5UwPozH3Vq0oSOdyEcOjKlYSRTQK
 efuJQpJF
 BqafKKHfS3BRQv3RygFWaSWiRFlgzNRj3oVMImNiQ8yovDFzeaheBskqrYuznMF5kl+NCuNkTaNS4F7LzkypUSv+g2t4rwy/ArvEep9bJx0sXtzOnBOMDxD5vZN5NMrCsDeNB1Bkyl3WVO/nT1pixTf8lrnbLHXlmaRCH3Fy4vwrl98QuD9sMMM/49dn0hv9K4q5ppabiC3SvM9wNc2kfhdJmZTcUgRkYKOe55aqSO4xr3V7Dhe/Ea5rj+yIKD+pI2q3CmAchAq6ByYuld72DnvHc9W5MAvgebI9+/MIMM4D2dIC8rUJFLf4myKKv+/8WuNlBaW0GUJ54UPTz5Wbwofu360JHHBcpcPSih44W6eOLUfV9H3kaBthFNV7OrYSMDaN1IWpO8+AMbaxVRHT8YiKwSqSGX2TJ14QQi4zR+hdOBG0o2vH4JWb8HagJk3HnZsvyAmVbp9QL+aGGr32P0BhfGK3qOOM8dmAyNpmFAdttE+uve82kcHNcye0OrUSwY/00TqO7SL1dSEiB+mYIX7BTOQoPfBVLctZg/6QdFAwp/oKXKsinid25Q3XIZzfL/NUl+SLddpXRgyau+L5sH58ZhA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============6020917005380425134==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index d18fbcea7578..2bf514462045 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -453,5 +453,5 @@ LIBBPF_1.7.0 {
>  		bpf_map__exclusive_program;
>  		bpf_prog_assoc_struct_ops;
>  		bpf_program__assoc_struct_ops;
> -		btf__permute;
> +		bpf_map__attach_struct_ops_opts;
>  } LIBBPF_1.6.0;

Was the removal of btf__permute from the symbol map intentional? The function
is still implemented in btf.c and declared with LIBBPF_API in btf.h.

It looks like the line was replaced instead of having a new line added. This
would break applications using btf__permute() with link-time or runtime errors.

Perhaps this should be:

  bpf_program__assoc_struct_ops;
  bpf_map__attach_struct_ops_opts;
  btf__permute;


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/21280790825

--===============6020917005380425134==--

