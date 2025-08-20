Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 314D5CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 11:29:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C784A8E005F; Wed, 20 Aug 2025 07:29:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4FF18E0003; Wed, 20 Aug 2025 07:29:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8C4F8E005F; Wed, 20 Aug 2025 07:29:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A47958E0003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 07:29:26 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 71E9CC04E6
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 11:29:26 +0000 (UTC)
X-FDA: 83796915132.03.A25EF15
Received: from mail-ej1-f67.google.com (mail-ej1-f67.google.com [209.85.218.67])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9DC9AC0002
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 11:29:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mW8A8YlF;
	spf=pass (imf22.hostedemail.com: domain of memxor@gmail.com designates 209.85.218.67 as permitted sender) smtp.mailfrom=memxor@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755689364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=upjI12z9EKSOogPe3mu03H4QB6bxTGw3qKQDwah+3Jk=;
	b=LKVr59aawSUy+c1EUx3a6HY4tYQ5jiAU4d3xhtuR5lUaeCWCtbxMc+QQM+54BRL0UEwITs
	TkRIaGiOJ943qYn2dlvTioXrf2j0SiaqnGzZaNqrZtmBtfKxEL7khxg5v72q49JT3c/T6a
	ie7c+vtajNA4fftNzNw+zTFQ+7W8DhE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mW8A8YlF;
	spf=pass (imf22.hostedemail.com: domain of memxor@gmail.com designates 209.85.218.67 as permitted sender) smtp.mailfrom=memxor@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755689364; a=rsa-sha256;
	cv=none;
	b=fnEZlk7i9o2VFDJQOkyuMJhDZtL6bgQyCBehcttkupb1m+2J8e2DbPNPZh7zyxuFQyX1Ha
	fTlcXPrmMRvWSk13YzzxCi28WYA4YqNHjevwhquTuYux2FiKveNVeRemSR3qpa4GCLm9U/
	nfE6VFcow8S1eM9F7eX6XZIwrNQrjkQ=
Received: by mail-ej1-f67.google.com with SMTP id a640c23a62f3a-afcb7aea37cso798800566b.3
        for <linux-mm@kvack.org>; Wed, 20 Aug 2025 04:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755689363; x=1756294163; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=upjI12z9EKSOogPe3mu03H4QB6bxTGw3qKQDwah+3Jk=;
        b=mW8A8YlFcHWAS9p8F2+D/fhm/hI2Scov/GmHaFGCOhYvwkW2sIfiqsYeEYZtERw5G5
         4QspAjiunW+6BhoY3Rk/D4PTOXJ+UzMBNUrk3omP9i+na7HF5HI31PhXGmO9B1Op0qVl
         7aUXESNQPj1PLG0nCd+MCYyML49at+4QsUkk3OoG0ZgxCHSm0w12Q0snL15b+Ur47wA3
         2rprpm6v3b+ZjOVzbv/S5O7+E0GhO8ELeE/Gx3ApBzb8BrVMk6vb9mDhe+klUUxKpDWY
         nerORewxDc1efStYrEMNW5fuZSHYMa6/6xGkWvnQzF3c+/6RhcYG5CfCyCTLNHA2yZFa
         ix4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755689363; x=1756294163;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=upjI12z9EKSOogPe3mu03H4QB6bxTGw3qKQDwah+3Jk=;
        b=Dli1eM3azPNuZaerTg4G26UdpLVR5chBwq7gjxbGNk8MxNEgrcRuUaqHRxCPigAw8L
         FAr5X1o6cE42nfGZ7wY7WQuftaU6IY2imeNchKjNCW5Ql6QFBcq3l1LkwPeTVouxkLvy
         SZdHg/x1p69s4k+u2dFgYu3RLMWTthg0BZC8nBDXia+ezfeSNFNrPaTmrVcJHuSMr8IU
         iqFgAl4SxSkacFnd1EEu0fxtSVdRIpupKRuq2au3vpdhWxWWhvYLt3AwoeGBOOvJxzwW
         1LvEvfBbErZFGNjCJ7jlfMSMDkLO+Gi8nIPRAR+/GU5/VAR5VxxiuE3AKK6KCabuxQ+r
         BB4g==
X-Gm-Message-State: AOJu0YxjbiE+X/Gxi4LE6QzZTjkkh4YSFmMNYKlp4HZJ+SnPCmBrz79M
	2db6EkH0zZQJo0ry1tQttOkt4dLLb0HWF3hiIW+E5VVZfvol5nnpfW62l5lmJe11BC3mjTTuNLP
	cuxvZ/oiTr9j2Fwo1yjGr7LCyicZYzXM=
X-Gm-Gg: ASbGncsRecUkDZ/+QVAkjfXV6Rde+KmUTeKsfJZL+wwUzAINxzEa2IPmQi6MCgSlNUo
	uAhZ8iln4JXZuXHNk1bJfTWEFJ1sJhEYMO5rUYQ+6KI1lHoUVnrdSJMyhkdTrbV6wmTIbdgrDdf
	harTekpjIU36wOu2UsApWnDBHns1uof2H8Bwav5Dak7yNxXJLY1V5RGftbyYW0F2XbRapJDL2Ig
	5DcRMN2qy4Ocin9LRqkbeyHqoot
X-Google-Smtp-Source: AGHT+IHKR4WT5Ll3zM9CQe9O0PlIb3Q7/p2qJgWorUSCzbLQuFfLo3z+C+RdY7BU9glE+sZqnURywScSjdBODs3VOHc=
X-Received: by 2002:a17:907:e913:b0:ae6:a8c1:c633 with SMTP id
 a640c23a62f3a-afdf026893bmr188656266b.34.1755689362625; Wed, 20 Aug 2025
 04:29:22 -0700 (PDT)
MIME-Version: 1.0
References: <20250818170136.209169-1-roman.gushchin@linux.dev> <20250818170136.209169-2-roman.gushchin@linux.dev>
In-Reply-To: <20250818170136.209169-2-roman.gushchin@linux.dev>
From: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date: Wed, 20 Aug 2025 13:28:46 +0200
X-Gm-Features: Ac12FXwIsXWjctJQDIgLXvBtGEjb-bEMufXtBQBLDBmPn-VgQIIHSI30bz2R0xw
Message-ID: <CAP01T76AUkN_v425s5DjCyOg_xxFGQ=P1jGBDv6XkbL5wwetHA@mail.gmail.com>
Subject: Re: [PATCH v1 01/14] mm: introduce bpf struct ops for OOM handling
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org, bpf@vger.kernel.org, 
	Suren Baghdasaryan <surenb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Matt Bobrowski <mattbobrowski@google.com>, 
	Song Liu <song@kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: oah3gs4qyi354f71odkk3ufrgz8b5k33
X-Rspam-User: 
X-Rspamd-Queue-Id: 9DC9AC0002
X-Rspamd-Server: rspam05
X-HE-Tag: 1755689364-511519
X-HE-Meta: U2FsdGVkX18EaMhAmwbgAIM6QCYI/VVNwaoqws09uffF0b7OpwELKkM5N/9JhDZK+hO286m7EIbB+0/iNZbQsdjeobPpVS/Kwzi2V9mNAhoKUloUqaCNZ7AEYry3mc9VJs8be62h+I+2uFC0isLNvakbiNGok7mOGf8gYGRsJeUR5od9GcmgEam62/CGStlVBXaMz+ko5uoA57NdireGgQg8sOWWWN5xmbZOg3RDv4PqsTe1azhOBtHuDCR7vm3kULmmFfa7SHeTU5R/hhDJba7s3lA7Aj0eFXhOlBY3EeQnH75glQ+GzLo4ze+qgumzp59sVn3W9SzzCJwh68Suz0Ny6LB/cZOQkXGh0wUsS5lckamw/XH/bsT2bpSsc77uWnBSJAcTL9YpotYj8dvIz1JHTrKrYUqbcE3XOGoUIdzs8d+QGzize8Y3ax2XusgfGjlgClVsNj+jJCEAL2fE0/I/VQzJiybLIOXH2cZ2rygkmiLgPdvhC18O/N2qRPox2P7ZDdmu4g67P1mn/rUrqP6VOnon9JQ6gEyOPWYCVow6j+X2Wvra+I2B4NetQBWB0QHMS6fM3b/t4Ym/AF2eBA/vU1EdU0VKb13iMaea00tyIv2phNYWpg6N63SJ/6twg7oo05w4/l1Fqi1P4kjJkAT5pTghr52hw2B/bx65GCdhbKO8xUHv6eAKMTgu+FfG6FF55Z7Js8Vc5W3f2jM+4+TthAqkWw4EkBBkNq7kvwNAOQWTtFsDbTN9gS8DWtUl5aOwK6tZlIkZc1S80A9Kcptb/WP0ayoR5Gkm8LZREr1E6n9yHJ17KW9zJCtuQsVjRhqsUeXAeg7n3m9kuWc5DJGhBmc8ru48h57PPzk1/NS7nuXcceZyJAyTCBqE+DnrE6/PhYMkhh9samsn7p1S6tXtz3fv/TbPbQvqZRc+S0/6mti8HCV+7oOie5eLGOpNq+g5VU5l6PGUtdoe59n
 sMvNmbv1
 7Jucw06mfn2ickdJT9DJv5FkZoq92Mwv8NCx+VXPgC5xPVHiJJmEqZCj5/aavAXHdHp+c/bE8L5lGa1xLS2fnaEDqummMMoCXcEw5rsAWVhTUCnC71+RzaD2VRmPq7AQ5leJ5KPKX7MDSBS0tqnGoGyMO2ZlqVRM6PuIEXpA0NxKiUoBwgoVpP3tYjCRE3BcO+Y59jW6FkvKJBvEA4vfsrJwKPrEdyu8il3ES5jzv/mFniZXxztgu1xyuCItvybQu+vhQ7GRZB4v5yeB9OVp7GFYIrMJrshi1OcZkepqeHleAlwLsJIjz5/6cbuEXBwpvaJt5aXZNnDhEqnCrl0N5aCPnDURbyZP2g9UhzHM1bBmUFyT3Wi1c1B9FrzFt2XT7yeKp9FgXrUGaDQZTUr1wYAJpbSGKKJGHBqnN784I1O5+l45BpBYeGlPelQHMCwj6YwcQC/DBImLXDsycYcaXZVXjzlySQdJI7wVqDL//9a286X8FZL5CT4UErDA+vlID9740E2mb/db/yljDfEnpoUpNNg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 18 Aug 2025 at 19:01, Roman Gushchin <roman.gushchin@linux.dev> wrote:
>
> Introduce a bpf struct ops for implementing custom OOM handling policies.
>
> The struct ops provides the bpf_handle_out_of_memory() callback,
> which expected to return 1 if it was able to free some memory and 0
> otherwise.
>
> In the latter case it's guaranteed that the in-kernel OOM killer will
> be invoked. Otherwise the kernel also checks the bpf_memory_freed
> field of the oom_control structure, which is expected to be set by
> kfuncs suitable for releasing memory. It's a safety mechanism which
> prevents a bpf program to claim forward progress without actually
> releasing memory. The callback program is sleepable to enable using
> iterators, e.g. cgroup iterators.
>
> The callback receives struct oom_control as an argument, so it can
> easily filter out OOM's it doesn't want to handle, e.g. global vs
> memcg OOM's.
>
> The callback is executed just before the kernel victim task selection
> algorithm, so all heuristics and sysctls like panic on oom,
> sysctl_oom_kill_allocating_task and sysctl_oom_kill_allocating_task
> are respected.
>
> The struct ops also has the name field, which allows to define a
> custom name for the implemented policy. It's printed in the OOM report
> in the oom_policy=<policy> format. "default" is printed if bpf is not
> used or policy name is not specified.
>
> [  112.696676] test_progs invoked oom-killer: gfp_mask=0xcc0(GFP_KERNEL), order=0, oom_score_adj=0
>                oom_policy=bpf_test_policy
> [  112.698160] CPU: 1 UID: 0 PID: 660 Comm: test_progs Not tainted 6.16.0-00015-gf09eb0d6badc #102 PREEMPT(full)
> [  112.698165] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-5.fc42 04/01/2014
> [  112.698167] Call Trace:
> [  112.698177]  <TASK>
> [  112.698182]  dump_stack_lvl+0x4d/0x70
> [  112.698192]  dump_header+0x59/0x1c6
> [  112.698199]  oom_kill_process.cold+0x8/0xef
> [  112.698206]  bpf_oom_kill_process+0x59/0xb0
> [  112.698216]  bpf_prog_7ecad0f36a167fd7_test_out_of_memory+0x2be/0x313
> [  112.698229]  bpf__bpf_oom_ops_handle_out_of_memory+0x47/0xaf
> [  112.698236]  ? srso_alias_return_thunk+0x5/0xfbef5
> [  112.698240]  bpf_handle_oom+0x11a/0x1e0
> [  112.698250]  out_of_memory+0xab/0x5c0
> [  112.698258]  mem_cgroup_out_of_memory+0xbc/0x110
> [  112.698274]  try_charge_memcg+0x4b5/0x7e0
> [  112.698288]  charge_memcg+0x2f/0xc0
> [  112.698293]  __mem_cgroup_charge+0x30/0xc0
> [  112.698299]  do_anonymous_page+0x40f/0xa50
> [  112.698311]  __handle_mm_fault+0xbba/0x1140
> [  112.698317]  ? srso_alias_return_thunk+0x5/0xfbef5
> [  112.698335]  handle_mm_fault+0xe6/0x370
> [  112.698343]  do_user_addr_fault+0x211/0x6a0
> [  112.698354]  exc_page_fault+0x75/0x1d0
> [  112.698363]  asm_exc_page_fault+0x26/0x30
> [  112.698366] RIP: 0033:0x7fa97236db00
>
> It's possible to load multiple bpf struct programs. In the case of
> oom, they will be executed one by one in the same order they been
> loaded until one of them returns 1 and bpf_memory_freed is set to 1
> - an indication that the memory was freed. This allows to have
> multiple bpf programs to focus on different types of OOM's - e.g.
> one program can only handle memcg OOM's in one memory cgroup.
> But the filtering is done in bpf - so it's fully flexible.

I think a natural question here is ordering. Is this ability to have
multiple OOM programs critical right now?
How is it decided who gets to run before the other? Is it based on
order of attachment (which can be non-deterministic)?
There was a lot of discussion on something similar for tc progs, and
we went with specific flags that capture partial ordering constraints
(instead of priorities that may collide).
https://lore.kernel.org/all/20230719140858.13224-2-daniel@iogearbox.net
It would be nice if we can find a way of making this consistent.

Another option is to exclude the multiple attachment bit from the
initial version and do this as a follow up, since it probably requires
more discussion.

>
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> ---

> [...]

