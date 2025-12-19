Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 166A2D711CC
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 02:21:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F7FA6B0088; Thu, 18 Dec 2025 21:21:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57BBA6B0089; Thu, 18 Dec 2025 21:21:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 488676B008A; Thu, 18 Dec 2025 21:21:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3677C6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 21:21:44 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DC6891603CA
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 02:21:43 +0000 (UTC)
X-FDA: 84234619686.09.42D2E31
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6563520005
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 02:21:42 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j4GYPpK7;
	spf=pass (imf03.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766110902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jHAVMgJuaLVHRg8W9cI0ITzH1H2Ju+U7Cwq+CjXlhhQ=;
	b=Jtzza8nihRZYpysOdrPwomORp9rNsAgsWKAALI7CTDEzScprXajqIac9Epg5x9eW7uLRdX
	eFmLhbVHzch0q4WtjxlNz/PpfhOAiutBF7UdG4htSJN2Uq9LrLHq9cWxWqC/PiFA6i+ze3
	5ySfclI1FpeDRSlchVuLK6UVDE19j+g=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j4GYPpK7;
	spf=pass (imf03.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766110902; a=rsa-sha256;
	cv=none;
	b=MDYqx8ZdA+P7o61bOkpqUk6W2Zd3DcHQwatyHYy4SBChtnXx1fyYBWhbq7fhKGOSSjPlCx
	9ekduU8UxXetVtuayXNtQuN6BbD+SIzNDQ3okL7Hr8dUJwDFfGlmUN6U1VRVyCmInds5UJ
	i9O3XHgf4/ZZEC0wvUqGawEUXB2rthw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6F2BA60008;
	Fri, 19 Dec 2025 02:21:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD96DC4CEFB;
	Fri, 19 Dec 2025 02:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766110901;
	bh=Wn06/ZF3XHZjIpC5IMs0aTkDV4ts+z6RiFMrHphIV+M=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=j4GYPpK7VGAKXEExKB9LndVfK5vDEnlPsSU/BRzP1Xsn1r4HoXfGuLnuB2ypyDz6Q
	 KZ2byv9yD8H9B0QuwaLDJJHQGjweeI0HQxZeBTCVb10j0wZEqs1cRuzgCuGvaF8b9n
	 /sKSDgzvRXjPleKrN7waHbwN4lThs8w9caxkr+bge95bDQuARiPWEGnRMHrdTn/IQZ
	 E4+kaiOi76WbamsmoFRspnK2WLZoamNWT1JhRwwxUrTLthvAAZNmimBNW1Cs4LTogI
	 nqrXWgzQF3yhZL47FL45I3m9c6fjgzTSuPpLwcFp63dcHrBgt+UuDr95k2ivgt4HNh
	 4V4YvTI5BickQ==
Content-Type: multipart/mixed; boundary="===============6244217947612912370=="
MIME-Version: 1.0
Message-Id: <cf8d48e8bcdba2515366bc8b6c85f581ca3d18ead24db9cb3ba9b98db252e0b9@mail.kernel.org>
In-Reply-To: <20251219015750.23732-6-roman.gushchin@linux.dev>
References: <20251219015750.23732-6-roman.gushchin@linux.dev>
Subject: Re: [PATCH bpf-next v1 5/6] mm: introduce BPF kfunc to access memory events
From: bot+bpf-ci@kernel.org
To: roman.gushchin@linux.dev,bpf@vger.kernel.org,linux-mm@kvack.org,linux-kernel@vger.kernel.org
Cc: inwardvessel@gmail.com,ast@kernel.org,daniel@iogearbox.net,shakeel.butt@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Fri, 19 Dec 2025 02:21:40 +0000 (UTC)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6563520005
X-Stat-Signature: rybancwmgbo3nhg7t8ei9rkma8hdw3sj
X-Rspam-User: 
X-HE-Tag: 1766110902-925034
X-HE-Meta: U2FsdGVkX19q6+d61JT/xiCMZwZyNSnjAT0BGz7D/D86pRZwOTqAWQR4RlCHilxxfA6OMDQqs32Q9PDiKfnNgfRE3okT7PR11+4ZhIHWrunSO+DQjba7R1FjFN/Ncj0NtTBt4keW3zyqVL/ATQGxvn81iGWPCZ7keQbzJ8ySRoJLIGFzIAbIhgh48Fp/VST4eely/1gJSAfPEyVEjb6jpj7fx8IxKXrrHEfNOEVSXi6Wbq3sTzmwfyXcAgm5md9W4GhlCymrsAN2GizvWcJdVsSJhEaZdQhIhAGp5LyCjhSmv6WsuARiB4WWXz3aMLimaIQrXMCXirFWD603gCWJ7JgXuyaaS3NJSR4nkKLfoPdNJ91YpmEQMzfswDuIkBbkuno+cFoS8sFIjymxEECooU+Dz5JMHMur6xVYtAxqQiiwcgMZiHs5vHORlHq2lgmTqm4Y8xd1pviV9TjVIpB/py6wHQwa27BTVtORw7PF24UyL50LFPkqmyAprH8lUKX2WbRlvDLQaYEAeUsI3njiHj5jBfxpUTrz8jpRJliT/ZRnFXgxbJwaGkUu6QgRGBM8m1aY94GRDbk9jUx91nzWtfUf5sbkIZ9KPorqmWx7GkhcvshWqSAhERskD692rfAyzoY/eCTWzOoFrPxQUnNN8Gek7oG2VXiLoTp5TCn8MPGzV8q/W7oi0dhxpLgTbJflE4DcVTqcb0h88G091RV+6lTOg4x3RrcYR5US0Oa1q6ZdNe82Vfodw318/VrHqYyJEPYfhLmbHPACwKi75JgQJAJuNwAAmw2qMxkApx6Z9KX8/dwbcI/zwVtK7ZA379s9wGRIhD5rRO/ZBtSKS0dCUdVE2dFhJ3cq2wMtS9lgYwldliKryKehHHSyDhAOsQog7IltPy/fBYvHxad8PXa2XDHX/wsMibwRJVNXX3fUwFplcAHQ6SSYvSfGvpBI4fhQFRdMBvAOSiHawmCCgIc
 E5yeCoyF
 fH0HMuRlztVuduYN5QJCwVgwQ7/oyH9qWmpbr5Km6laDp7x4GJo/tuqWuPZyrrM2qQqw0D3ho98ZGFgGEWkODnsw88YPZ6VDD6sKQm7xk08cazamyyqYBKiLq17Lm6uL7nKD6Q9f7KbnbqKZiszgGP5L1jnOnQ2obnzq6GP8azTHir6ArD2OvfGZKwLhdAjIDducxGFBTce1cV2gSdzCp/Ty61jmD9zpiAb5hFygEQ0zclBHDK+/WEiBpc487x5Xr2lzWjLQilwgJX4OeHL3XECaUhfNpn0e3A0VMc0hL3tniDA3c8nZvbXhfoIsGpZCLcijGataPHAn4uVw/AHX4crWWc7+2mhX7odEvdqa+xVRSoUk9r7KmDm3zyx/VZ8stJ55IQzji3qJVqAPiMBxxdGckT4LretXW93ZO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============6244217947612912370==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
> index 4d9d7d909f6c..75076d682f75 100644
> --- a/mm/bpf_memcontrol.c
> +++ b/mm/bpf_memcontrol.c

[ ... ]

> +__bpf_kfunc unsigned long bpf_mem_cgroup_memory_events(struct mem_cgroup *memcg,
> +						enum memcg_memory_event event)
> +{
> +	if (event >= MEMCG_NR_MEMORY_EVENTS)
> +		return (unsigned long)-1;
> +
> +	return atomic_long_read(&memcg->memory_events[event]);
> +}

Could this cause an out-of-bounds access if a BPF program passes a negative
value for event? The enum type is signed, so if event is -1, the check
"event >= MEMCG_NR_MEMORY_EVENTS" would evaluate to false (-1 >= 10 is
false), allowing access to memcg->memory_events[-1].

The existing bpf_mem_cgroup_page_state() in the same file uses both lower
and upper bound checks:

    if (idx < 0 || idx >= MEMCG_NR_STAT)
        return (unsigned long)-1;

Should bpf_mem_cgroup_memory_events() follow the same pattern with:

    if (event < 0 || event >= MEMCG_NR_MEMORY_EVENTS)

[ ... ]


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/20357445962

--===============6244217947612912370==--

