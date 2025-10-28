Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19D94CCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 21:34:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 489868E0197; Tue, 28 Oct 2025 17:33:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43A488E0005; Tue, 28 Oct 2025 17:33:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 328EE8E0197; Tue, 28 Oct 2025 17:33:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B9818E0005
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:33:59 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AE92EBA3A8
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 21:33:58 +0000 (UTC)
X-FDA: 84048825756.18.E61D5C0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id A9CE11C000B
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 21:33:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=phmrTVky;
	spf=pass (imf18.hostedemail.com: domain of song@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=song@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761687236; a=rsa-sha256;
	cv=none;
	b=b0YfyATXtcY+4djLtbKGjDGPIUcvzYlc9FQEEDRiS6Uh9/QjbF/3+ExinFMBudFKfgdz65
	vL76ZOguSwiOeES2QS5R4CaG32s4fLmRRKZolUi3hYENMpJ1nD2xAbJg2Dl5VP5HsL4wi6
	yGnz3OnCDLx3q/hzcH+yW6G+NbYGCkQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=phmrTVky;
	spf=pass (imf18.hostedemail.com: domain of song@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=song@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761687236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QH//50JL9r5vlgYsJZ4OaxQcxUqHTRxV5sbtAPYHsOY=;
	b=HEpL53sEFmgqxAEvRP0cZGxx+IGmtytxW3BlqtsGysW7P/dJZWNYIGShQ0UiPwmkAPyzps
	XjNInW9vPM9JrPM12qhx6/nZcxymC3eGsrI8b/oCCflz2JUUIfBh8ChEYsiqsVC5cMc0Xs
	uNh3qF0TLJw+X2VIFjUb2UcPNRLIK04=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 80F6749141
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 21:33:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62157C19425
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 21:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761687235;
	bh=iFWP7xxMJgkbRCwFD/Ow8yzZAuMAdW311BwnuPvp2SA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=phmrTVkyk/RJJ+EFRqA64SJtzZw1RrTXF0Jy7f1CXc/pvZLehllXnDr4sgfEh9lXA
	 2/twG9h2eNIdBfauTgXEQuIRcS4YaIBUHDFnASGVKVGIr9PViTjDz3uHg1aUHndGnm
	 JfmMrIDVcmMtfhGvsEaRyHNrcNHVVSFVyWqW7mc2lxSIew6H7Ge6bK3IDkKkVZFTE+
	 ckLbL07VYqopMUKqVW/aEdK3rZ1Vhdn7Jx2oYQrh9yRmC9zb2iiksD6jhqrAr/U6XF
	 BoaOIR9Ixch8dADOEBUFirZRLio3iFt5cOVoN7gFFs9TvytO8YcKQnFMJVdWxBjyCE
	 nG+tulYpts/hw==
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-87dfba1b278so68400386d6.1
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:33:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCU+xGKYt4RcowIm98b00/t24JAsgQysQumMY0pMittutlhPVOl6EdrbxXjwdbKqSVoE23k020KEMA==@kvack.org
X-Gm-Message-State: AOJu0YyOGn8eKi1JcVFSh5a9uiAR+UrxZnp9O2+NOVB31zx3L120fCCa
	6lcgQTglZWEpGmPSSMieidSZcRqQNqdty0Y0jZl9PT3I6ge5zTtkcD3KZxI31S7rMvO3mfcne0D
	4TWnRjTD5kN3f/+RO6ROepcNaJsAwyUA=
X-Google-Smtp-Source: AGHT+IESUEc3eeZzEWwxs00NmoTrW71KQg0jPt0Nsondh+RQEdb4dLarCNV80h0sV/jj5ri8Uz9bMzHY51U++MLe3GA=
X-Received: by 2002:a05:6214:2129:b0:807:ca4f:5666 with SMTP id
 6a1803df08f44-88009ad0903mr10291646d6.2.1761687234390; Tue, 28 Oct 2025
 14:33:54 -0700 (PDT)
MIME-Version: 1.0
References: <20251027231727.472628-1-roman.gushchin@linux.dev> <20251027231727.472628-7-roman.gushchin@linux.dev>
In-Reply-To: <20251027231727.472628-7-roman.gushchin@linux.dev>
From: Song Liu <song@kernel.org>
Date: Tue, 28 Oct 2025 14:33:43 -0700
X-Gmail-Original-Message-ID: <CAHzjS_vrNZpEbBuHLhHwHaGzLaF3QEeKWz-VikCm0bYrFBq4UA@mail.gmail.com>
X-Gm-Features: AWmQ_bn4FJi2CLDbiuBc051gpuUbvflP1rY5GJvh4T7UtMPVn-sJ9ZXRwYG7Zb8
Message-ID: <CAHzjS_vrNZpEbBuHLhHwHaGzLaF3QEeKWz-VikCm0bYrFBq4UA@mail.gmail.com>
Subject: Re: [PATCH v2 06/23] mm: introduce BPF struct ops for OOM handling
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
	Alexei Starovoitov <ast@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrii Nakryiko <andrii@kernel.org>, JP Kobryn <inwardvessel@gmail.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, bpf@vger.kernel.org, 
	Martin KaFai Lau <martin.lau@kernel.org>, Song Liu <song@kernel.org>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: s8d85isnxyu6u7f6qhd93txmstbdzyte
X-Rspamd-Queue-Id: A9CE11C000B
X-Rspamd-Server: rspam09
X-HE-Tag: 1761687236-918878
X-HE-Meta: U2FsdGVkX1+2KAxOOLdIxHk7IDNi8EoZTDRVrc1nAGoC0xuR3AII5OB2bTNKhkA21pk7Mtr7bZqzE2kSRz0qagUglCLWl9M3vRSkXWGQxKXx1sx8hfGivwn7Z5ShNN0oH1FNSoMWUhwWfXCUaRyqBPHkjN3rdLn24H07ix3a8ZFVhLmIWYhDcC2HuOsudrHSjfZJrBXJbECvD+mnO6CfvcELkLqPKd3DoiRqE1zF8Pw6vc5jhPccBpOwCg1FeuVZtuGVlhgZMic3/sNKSlA1OFkks3sthHWAABFryR/taPC+rviRPkxBkNOVh8aW2z5B80cxrtGiMPpiLFAqO/Huc/tcYxiUup2/h3w/wtHNsacagzH5OPAUEDjqR9o3FDwgi6DeC5lj4AfInjAakpqJOYLEKe05nI8oj/m26NbWOCSIVVgqcbn9wOAczNLNvK/cjcfWzoXJ/KBgVwkpoFyihyBNa7Fg5BzBC36EXWAZh4zkRaMD7H+Ae2ik+IYNJdICQmDxxN5JiBFYTdTRYgPrSEonH8My2vWCfUcBVfp6vXSEQrmXDkyF8EjZZHnm4XPIUP6Ep0WSrP/bzh/A0VSsTDisq1XVe1z69ZKZLvNc+lriG3W0MKD7uIaX4oiRfykD4dgFF4/AUUCkRdLkuig455tH9Cx1o0Z4jouywIESvjIyZxchln4AHYZBkP3A8TafHts1uv+zuNDhzYt1IkSejODRxClDKjQxiVcJU2r/3rowy2+Qz5wkZU5x3+Mw5IXuWAu56IzSQMi6OtxeBJeuZ/w0+CbjaYB6su2KqIs2zD4fnePOIOl9eQyTNe/oZ3R4a34VRiwOSxAOdJJgkxMiU1F0fALA9g8P8F65C7UC0Vz2qietVb2WG1DlLoyC0sOofTWRHj0mtz9TuiB45KD5yn4dIjRqe+/4a8WHDzKzv8YkWqyB6fvlGFN+wFsyhG1DyZo7P+SlESbFIxxCL2e
 nAAc0aAT
 7cSTRj0bInnNf/Yv4zWMY/0D1ZvMAghCPjXu7urNgYLKBcv5OqD74+0K6EufUfTVCJ+J+/m3dcYkWKFYHD9ZDBMuxz7M/Jczq4OoD4NfnHoLCl7LZOO8/IM+mZL4mt1gy7G9L5caZYnGvkg/dV4ezWYzLxp4l4qxQuGGV6bYcQxuD2wlyxr27ZxnPRzNrHwdFbE0K4f2Ysvr2negLL7l+I9egt6DVVnpNaRWtP4uBYI4esrC+ZqumMRJ5wNQSB02jtEVU5bk/BTrOou0tfzmOUgiJSXVXuMbVa+Uj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 4:18=E2=80=AFPM Roman Gushchin <roman.gushchin@linu=
x.dev> wrote:
[...]
> +
> +struct bpf_oom_ops {
> +       /**
> +        * @handle_out_of_memory: Out of memory bpf handler, called befor=
e
> +        * the in-kernel OOM killer.
> +        * @ctx: Execution context
> +        * @oc: OOM control structure
> +        *
> +        * Should return 1 if some memory was freed up, otherwise
> +        * the in-kernel OOM killer is invoked.
> +        */
> +       int (*handle_out_of_memory)(struct bpf_oom_ctx *ctx, struct oom_c=
ontrol *oc);
> +
> +       /**
> +        * @handle_cgroup_offline: Cgroup offline callback
> +        * @ctx: Execution context
> +        * @cgroup_id: Id of deleted cgroup
> +        *
> +        * Called if the cgroup with the attached bpf_oom_ops is deleted.
> +        */
> +       void (*handle_cgroup_offline)(struct bpf_oom_ctx *ctx, u64 cgroup=
_id);

handle_out_of_memory() and handle_cgroup_offline() takes bpf_oom_ctx,
which is just cgroup_id for now. Shall we pass in struct mem_cgroup, which
should be easier to use?

Thanks,
Song

> +
> +       /**
> +        * @name: BPF OOM policy name
> +        */
> +       char name[BPF_OOM_NAME_MAX_LEN];
> +};
> +
> +#ifdef CONFIG_BPF_SYSCALL
> +/**
> + * @bpf_handle_oom: handle out of memory condition using bpf
> + * @oc: OOM control structure
> + *
> + * Returns true if some memory was freed.
> + */
> +bool bpf_handle_oom(struct oom_control *oc);
> +

