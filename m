Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A1C2D2D8E4
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 10:08:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 809B76B0098; Tue, 27 Jan 2026 05:08:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C2056B0099; Tue, 27 Jan 2026 05:08:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 624426B009B; Tue, 27 Jan 2026 05:08:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4AA9A6B0098
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 05:08:40 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E66701B0DDE
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 10:08:39 +0000 (UTC)
X-FDA: 84377319558.21.56559D9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 68080180004
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 10:08:38 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20201202 header.b=NV3uG0II;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769508518; a=rsa-sha256;
	cv=none;
	b=bydXCVlIKdp0rsV1ZDqwO6kMW13JveTFhmXm8X/ndkDOerBDsxoPA8LzpE02+whmdlttOe
	T8TeqO9qs0Wnox1mjw5BPOOEIEDjjFCgZjlCNOfq5RDIEBY2BtAkhUld445pLXzOmYdJ2Y
	H1ztZ0RyO4xsgo8ZRcwpkrW+a5I41dc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20201202 header.b=NV3uG0II;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769508518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uG2AnnCoi19eqgBL/wwFEi4teZzTnpWOtLisy6YCfZw=;
	b=C9MQPMC8df1Z0xIi3moYMp6LhyHQ5pIUIVplFr8jkiBmyjnGSj48tNAeZBL+1VzlVcQkVc
	Oj2YvatQYgK49ymmXjiflITsLNUjmd54Ozow0JgsaMJJGiwXx4T2Eqy49oE5P/1YM9y9aB
	SRnBJwKFgvKXiqDir9q/A+nc6J2Rt6c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BF0C560143;
	Tue, 27 Jan 2026 10:08:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88634C116C6;
	Tue, 27 Jan 2026 10:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769508517;
	bh=5stgSFPOFTFIULArixFeHkYV56tWc18IJxdLX0dDglY=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=NV3uG0IIJ6oSlguw1ZOHGTXtX0nknoen7oyTS8zTEgfLxcLcEXtD4qakjZdS+GRDN
	 m/iMbO0lg+p37/K4dLa4XKE/hjJWpm7tTOpi+ndk9g64uAZDiw7gXbWFhKVHyvI7fO
	 N9Dd9ZbQbIMC5rO1zWbIt3ZFZ1ARRxKSqZdp/SejHNvFxXCWHQl0v9TgiD9otDZ388
	 ypdzcpuHPEWW1mOZF60Aan+OvKkWE0pYm4UcReG1RH+fTqE9qxWp611DJfQBcShTs6
	 MlaGeAKzvdLhhZwxWiiTXlvTt8fD+2pcZncfLOhT9+en3swcxHqgm4KxDgl8rYJqPd
	 6SrdFZVC+e2Yg==
Content-Type: multipart/mixed; boundary="===============4752217963743545921=="
MIME-Version: 1.0
Message-Id: <6173f32708a0a1401350ac03dfeb0c3a6b212331b233b3269ff708dfc74dcffe@mail.kernel.org>
In-Reply-To: <f14f1ad53f742f993a7ac5cb5ba6eaee26bebd91.1769506741.git.zhuhui@kylinos.cn>
References: <f14f1ad53f742f993a7ac5cb5ba6eaee26bebd91.1769506741.git.zhuhui@kylinos.cn>
Subject: Re: [RFC PATCH bpf-next v5 08/12] mm: memcontrol: Add BPF struct_ops for memory controller
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
Cc: zhuhui@kylinos.cn,geliang@kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Tue, 27 Jan 2026 10:08:36 +0000 (UTC)
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 68080180004
X-Stat-Signature: 7m7ccfbbntpgykz5u5xhmt6ox4w6h6yk
X-HE-Tag: 1769508518-793921
X-HE-Meta: U2FsdGVkX1/P9CzmIN2KLcRW/mXRpYSKv0BUdZHCwJyLdMQiAf0CcSx1m4oVZ4Ifp1rTuYoHCgfsKvV2RzLhJu8jZWVb2+2gN09uDkdxsq/oHN14qM2d99YYDJtGipWE2lVzN6RHoUK34klD/hjzfgzpBDSIn97eMJM2/OD3+ea+XQMuTej1IPHiqe5Hck7/Qzx/ndtgVXaojh0vZwRWeho3DmolXtMmUkSuRIJ/OeRdBPJkmo1574JDmftfPz7AVBzg7gerZe3XqV6GWkkxKUZf+nu+5jIqlC+Ki4mgP3HBJ4OquI0wphBsZJ1rGezOLDBQ56Z7DXuPYGJWnKmpfZ5qj3AzmGwM4EhUkDxpI+TNUz6gIRO8oOIkz9jF1uag38PSiTXZeJAfm6HCwLyRxjbqTZXywy2MFcxb4cudeFB9lluugcpLfXLiLirQgRhKeQxsabzkylMNlTiVyBWp5go4h8a2WKqLoSnm3ahLfCUNCLPZrjga0Lzo6bSZsfC0PZt1OUehqu2OkAOWijyWACv1ixnee0N15+EoV/HxmnYG4VR/4Ip2XSmbJM04CgkazJ3Yvtvi0CO0jrQ3QwN7YNsYpuJ/yPuVK4xLsXd8SyKFuxHtOghkHl03UaokEaSYTKuKBsm5U1I72Ur2fqYc5FxykSox6mZwF6krr4Qno5rP5no2CnoCnE+LJhWh38hoHUlxb5jaA5/rFjpVqukBodc4sGaL/i1+Cblfhi/Rwl2kmE0vCRE7NPB7YNP4NdIZozsy83mQDWLpX7KEkNE8Xfv/yXuNoAknsX1ThXGmiIMx+LjQglGgaw/eHla3ZCsh3hyn4QVKjMIwgl86Y5HGNJLwUTlBo8NuFm8z1y9V1UJQwFaNoIvUfVpuxgmd0i2Z/TACfj9q2QF9HtdvaVtCKpV6ZfnV2GMiy2QXgJBEbjJLM5jc5ribhWaDteWdBe/vRZj/WM/TSd4hpJn1E5d
 LgX0jZrr
 cIhqcH5Lq+5kAIM/F4tOq2i7kv6V9zwLOFRMCjIdxGsp0mpChqhHr+3SnWmhjhcZZiTuDQ20jvRMe7F0AhQCFZcnsoO16gW97SUkGLUsRv9xRBi+smSsreKZy2QTXjI9QyaK4Lpsvw5fzxiiFDoWYH7apljwZz9yH94SmY3OtOHRTlG6tZec8KkVJbDQOhjkUug01XVp57ImyZTUkKv8ebhWPTuQkLxho8bbxibR79tCNDYoB7MJw4VFdtdiqAD3ddjrI/QMdGExoWf7l3klz2qu8zKwajHWrc/sQ3s+lNRVSKeeb7bIwynuaF909KXeZOY2aFByxoH94Kg0aUzEMdYCDaL0OhJpNgJqwcROtcZJD2iPmCGaX0sxdcuo8kOD5NASkPTZE8R8MKOZC2RxZnN7I40WTMVAebslV590DE8xXr0MeDWnsigJdQj2xDJXQLWfdvPcQRYyOMMYLoH6PpfHQRyYIcxB/FCK+5gtD3j5/nWrLsPFpHpKCp5GtYB4l8gzezaIFX4nJG5foNIXNSwG3WzWDrCHiRKCYO2j7aYGfL1F+IZ8wZ9Fwm+GFZj1g2/IVTkb7yB2rFv6qay+PO+VYFA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============4752217963743545921==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 1f74fce27677..8d90575aa77d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c

[ ... ]

> @@ -2530,10 +2537,14 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	 * kernel. If this is successful, the return path will see it
>  	 * when it rechecks the overage and simply bail out.
>  	 */
> -	if (current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH &&
> -	    !(current->flags & PF_MEMALLOC) &&
> -	    gfpflags_allow_blocking(gfp_mask))
> -		__mem_cgroup_handle_over_high(gfp_mask);
> +	if (gfpflags_allow_blocking(gfp_mask)) {
> +		unsigned long bpf_high_delay;
> +
> +		bpf_high_delay = bpf_memcg_get_high_delay(orig_memcg);
> +		if (bpf_high_delay ||
> +		    current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH)
> +			__mem_cgroup_handle_over_high(gfp_mask, bpf_high_delay);
> +	}

The old code checked !(current->flags & PF_MEMALLOC) before calling
__mem_cgroup_handle_over_high(). This check appears to be missing in the
new code.

When PF_MEMALLOC is set, the task is already in the memory reclaim context.
Calling __mem_cgroup_handle_over_high() from such a context would invoke
reclaim_high() -> try_to_free_mem_cgroup_pages(), potentially causing
reclaim recursion.

Was the removal of the PF_MEMALLOC check intentional? If a BPF program
returns a non-zero delay from get_high_delay_ms while the task is in a
reclaim context, could this lead to recursive reclaim or deadlock?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/21392729810

AI-authorship-score: low
AI-authorship-explanation: The code shows typical human characteristics including a refactoring oversight that AI would likely not make; the commit follows standard kernel conventions and has multiple human authors.
issues-found: 1
issue-severity-score: medium
issue-severity-explanation: Missing PF_MEMALLOC check could cause memory reclaim recursion when BPF programs are attached, potentially leading to system instability.

--===============4752217963743545921==--

