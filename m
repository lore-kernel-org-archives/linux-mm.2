Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94766CCF9FF
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 09:02:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA6E68E00B1; Fri, 31 Oct 2025 05:02:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7E878E0042; Fri, 31 Oct 2025 05:02:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B94598E00B1; Fri, 31 Oct 2025 05:02:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A73CE8E0042
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 05:02:26 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0297E58D9F
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 09:02:25 +0000 (UTC)
X-FDA: 84057818292.20.FB177D1
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf06.hostedemail.com (Postfix) with ESMTP id D8C7A180013
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 09:02:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=OpY1qGxA;
	spf=pass (imf06.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761901344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=riW5F2YSMNEn22/E8/Ov0+qACVsdJ9lrTJanAog9mm0=;
	b=8Kx8+XkFvjUikbn+STMT+zoFtBr7uUVXbOjf7P+RqG2Ygar8xlZKreYxQ6NThWl1Uczzd7
	b3fsWqzZP2fa98R7kMmAOAVtaSjdVK9BjD2zvOmpsb/A4Hmwj78D2x2gUzQiRNtmgOpqFA
	V+NjZtTlE3BeA4OqXIApmy3Lj+Ikr/g=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=OpY1qGxA;
	spf=pass (imf06.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761901344; a=rsa-sha256;
	cv=none;
	b=QH6+zUjVAYVu8UUnIaRmK9mco13flMRsxV+DQ5Xftadi6koYMNtVIHI87FsOOUz2zk0iWb
	jz83emKg5uIB5cMOOIoiK7529lCF00JXKA8vvRzyG21dSFcDbz6S782DOuaqaLdoCyLEps
	4DApGd6qpaf1WiZJBKaOJqGL2fQwl44=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-47721743fd0so10567005e9.2
        for <linux-mm@kvack.org>; Fri, 31 Oct 2025 02:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1761901342; x=1762506142; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=riW5F2YSMNEn22/E8/Ov0+qACVsdJ9lrTJanAog9mm0=;
        b=OpY1qGxATiiFpMeCJsstqimsFKP/yycHelAoxYnaD37EzL2ZqwCC1/cZIhfshV+ZtB
         CwjwoupxIa1Vj3ssBmqZoJoAmkLY6deJrzA29lw0qQdGyk5waWJYVe37flojom0pnkJo
         9iwWWppCWZHf3OkB7PDS9zxRB4wWV62F88C4p86ahW3I6psShGT5QZAk0VNcztjHGwGO
         r4nrDG/nM6vDdEcOuKxCgD2MkKSEnr3oBWBqA/9pQLWXIdsprwcQFcVjKFsayLG02og7
         qbNM1fofol6kWkEM+fpsZTVC3GCSoKvCtJHYXIKQUs2ccZXLCI1IG/SaOVCysXjuO77f
         mb1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761901342; x=1762506142;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=riW5F2YSMNEn22/E8/Ov0+qACVsdJ9lrTJanAog9mm0=;
        b=RgqZ0sV5YT37qgkF7cQ4lh8Rpkx7bJ3LC77uYXXvIQfldloBqM82Uvo+x2alJzZLRi
         JtLGGg9dW+DpXwtrozbBUM1VVSDgM9ZJ7jLYZwYxQvbzyOpMa4towl1XBcYrTHoeD4EH
         yykybIdnzCIcWnwdSBksDGaMhjQRE7E1eNaAIX0/OATFDg77Y1Ol7e0oDxDXIcoQkfxz
         i55M0rRuM6FGFQCAO6k3lbFIpmDetZDJBUlFF2Wy0NM1HhLM0UAwRPhhwONhKR3YM9FZ
         dBy9zP8GnBVZ8jkpKWKr00j0szGoVNMuTvGhwko0mkv9WSXIWVfD1owqmAhdZqHOvVTT
         nPOg==
X-Forwarded-Encrypted: i=1; AJvYcCVk255j7Wcl+GZlnnbs8jlzomDz0mtFdVx7yPvWFZt1wnNedMpqSeW6dfM7jCgCERoxspb46GkiHA==@kvack.org
X-Gm-Message-State: AOJu0YziubvggCg/eGTU5w6BxcacZ/RYXFVlIF3jJurRECLtpnAlSnKL
	2kh9NA/RBJujOr3Y0MLI0hzykaQO9todwSPFxxRr+FJJ6Q26i8TSS7zTaJHedisDcew=
X-Gm-Gg: ASbGncuYgNj6p8jv4j5eBdD5gAM5jGkDYmgJbNp7+ZGuK2fqPctK57niiDJHWoBDyH9
	fnyNFIebvlo8DtrQEFL7zG8ljbp8Q8cm+4rtjLd3yf70HiNvzGlk1KSI3ezs9phao6lZM0/fWuX
	KS/JxpQ4Rjc1B51Lwj51aVjIuR7tE35NyA1njVcqiKMIGw2hsfiB09bpHoScexrFcNzQmMRNb21
	JwcTZvrD69YHP3HmrxTFp9heR0/9hBDqlSLYqiCUE68PxhRlxiz14y93+X3xNjTkiPEN1y5bj2c
	tUw65VZenFUxW+TJYQWBwaxXyaAoSp5xEm4CZa31e6xslKMAPg8Y+jR6fsf3AEP3h6pbJh7+gyk
	6LDs8574Cp/WHAxDWSAtWuvy+HqmyvqCykjsbwbWx/v3/ZuEeZZUvBq0+G9ai+yz1k3bDFynSxi
	LaY/yZEWm95trWHX8xckBVGdhtAeGe+pSL+qE=
X-Google-Smtp-Source: AGHT+IEfIG+L9PugHrFEoMpYM/xl7+uFJi6ldJ6zhfB62Pmwm0o3+Vbm3I+W0dyQ0yvCl4rrfOq5Ig==
X-Received: by 2002:a05:600c:1d9b:b0:46d:996b:826a with SMTP id 5b1f17b1804b1-477308c8b64mr25548685e9.36.1761901342084;
        Fri, 31 Oct 2025 02:02:22 -0700 (PDT)
Received: from localhost (109-81-31-109.rct.o2.cz. [109.81.31.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4772fd38c4esm16895485e9.12.2025.10.31.02.02.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Oct 2025 02:02:21 -0700 (PDT)
Date: Fri, 31 Oct 2025 10:02:20 +0100
From: Michal Hocko <mhocko@suse.com>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
	Alexei Starovoitov <ast@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	JP Kobryn <inwardvessel@gmail.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, bpf@vger.kernel.org,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Song Liu <song@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 06/23] mm: introduce BPF struct ops for OOM handling
Message-ID: <aQR7HIiQ82Ye2UfA@tiehlicka>
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
 <20251027231727.472628-7-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251027231727.472628-7-roman.gushchin@linux.dev>
X-Rspamd-Queue-Id: D8C7A180013
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 4atzbzahgjws46hp7owojw95hrpnq7w4
X-HE-Tag: 1761901343-706532
X-HE-Meta: U2FsdGVkX19lMaoO6FNx+Ufp4lo0t7LhVC0qcgpFJXxfa68JvEPgPe0kW8JsUzu+UknVgpnPvievX+rVgYnGnOuKcRNqvT/hDPsEY1Co3bNsGxMao1YHnaF9bqAJau44MPsX8bI4dsXrkx6kuRo+i1/wifiLAs2Nm8wcu2zNloZLLJB9VFIeDXGPDi4XJ7Qux96bIV4hoZHJaIn9t/GJ6ecsssPP5/N7lGBqSn8tCLKLb6pXMWIrKR2Rhg2RxM1EmIL1uqFPF3fS1OPUFmuTsqGhygq6xDODiKejrvxqN8A2X8XuJhKSVua331zfbAFEctpsg3VEXOpiL+WC3taJDoJ+DS7yc1d6sd0c67d4Yqsdedfc9U6/0iqtSNGtjy385K9VCI1K4GdEe4SCCCqkrdlqsqX5exYmzz/zcthtmmiW4Kkuv58e30I6HWJHPNHwm7nQvGYdl0U1NuBbflHScpEdGEZ1dvHVApcLBwZQqJLj/v2YAmc5uMOLPmE6vNEKmAId0l4aX8qNN8ayAqA7fxLSVWYj2VNfYlq6odrFqTOiZ5jcxnEcmRHur9XRsRUCtvPa+0Kj59JnABo/JYJKv/13vftttgPWD306gUERSZBQrxyflv5QK/PI3t8v921r4YMoelqLjmYKnIVpwVdKRFyhhJtuyJ/pB1YvDRgBlet+OX1eJITOYDSMcrTj7CDmCJowfRvrlAdVcZ0agERLY1aM8UK7FZozZQkDqd33T0k4nfztad+CGkQkXPLxHxDJYiP+cgoOHpd2edGx5Sk60wy2bxCtXc6r17gqJz1WjP1WKHlHG3RjwTc619/7fA3u1iYlMqXrASoAp4fRiXNZVtfRkgbFy1UZQzVmthv4j1pFmqm5tyOULq17HB49A1S8BZRTUN9BrN9mNYrC10hSEZUM4Oc3dfj3/a16TiLNNZPYOBeXLm2ipoedjsUOI4fnxlC5xLScIRmNzWVYwR6
 u1XptuEK
 CS3GCjhnrm+fmnKTti7lH2+T5wfq+Qf3ueCA67uADcRgettRiAF1MATdlY9P6iBvyKpwVOfem3VNN8Ju1Y1QYUTFdN6l6+AlNXVf3bx3vJtL2Ugutc2MjA6guT+zUKZhbT2mULopXKD4d6FM38VCosp5HgxAL14omd2rG+XMJLcAEzlaC+V7SLR+CqAIYIwZjbu494v0DqlPm23Qh7NHf+mlmw+rBJu0Fx2P6X0rb8i9E5ws27BxPM9bdqjIYqWzp+Ew3qApiQhXO1+aNIvHDz64l6idaRmp2sd/5LptB0gX6j/Wgc+LCv7A3zhRx33181on1DmYlKDozp4rMdJsPOwdFWOgOVlC2BUAjYPu1P0xwzSo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 27-10-25 16:17:09, Roman Gushchin wrote:
> Introduce a bpf struct ops for implementing custom OOM handling
> policies.
> 
> It's possible to load one bpf_oom_ops for the system and one
> bpf_oom_ops for every memory cgroup. In case of a memcg OOM, the
> cgroup tree is traversed from the OOM'ing memcg up to the root and
> corresponding BPF OOM handlers are executed until some memory is
> freed. If no memory is freed, the kernel OOM killer is invoked.

Do you have any usecase in mind where parent memcg oom handler decides
to not kill or cannot kill anything and hand over upwards in the
hierarchy?

> The struct ops provides the bpf_handle_out_of_memory() callback,
> which expected to return 1 if it was able to free some memory and 0
> otherwise. If 1 is returned, the kernel also checks the bpf_memory_freed
> field of the oom_control structure, which is expected to be set by
> kfuncs suitable for releasing memory. If both are set, OOM is
> considered handled, otherwise the next OOM handler in the chain
> (e.g. BPF OOM attached to the parent cgroup or the in-kernel OOM
> killer) is executed.

Could you explain why do we need both? Why is not bpf_memory_freed
return value sufficient?

> The bpf_handle_out_of_memory() callback program is sleepable to enable
> using iterators, e.g. cgroup iterators. The callback receives struct
> oom_control as an argument, so it can determine the scope of the OOM
> event: if this is a memcg-wide or system-wide OOM.

This could be tricky because it might introduce a subtle and hard to
debug lock dependency chain. lock(a); allocation() -> oom -> lock(a).
Sleepable locks should be only allowed in trylock mode.

> The callback is executed just before the kernel victim task selection
> algorithm, so all heuristics and sysctls like panic on oom,
> sysctl_oom_kill_allocating_task and sysctl_oom_kill_allocating_task
> are respected.

I guess you meant to say and sysctl_panic_on_oom.

> BPF OOM struct ops provides the handle_cgroup_offline() callback
> which is good for releasing struct ops if the corresponding cgroup
> is gone.

What kind of synchronization is expected between handle_cgroup_offline
and bpf_handle_out_of_memory?
 
> The struct ops also has the name field, which allows to define a
> custom name for the implemented policy. It's printed in the OOM report
> in the oom_policy=<policy> format. "default" is printed if bpf is not
> used or policy name is not specified.

oom_handler seems like a better fit but nothing I would insist on. Also
I would just print it if there is an actual handler so that existing
users who do not use bpf oom killers do not need to change their
parsers.

Other than that this looks reasonable to me.

-- 
Michal Hocko
SUSE Labs

