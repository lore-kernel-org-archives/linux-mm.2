Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98723CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 04:08:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A2856B00DD; Tue, 19 Aug 2025 00:08:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27A696B00E7; Tue, 19 Aug 2025 00:08:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 190736B00E8; Tue, 19 Aug 2025 00:08:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 07FE46B00DD
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 00:08:43 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8F70A137E15
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 04:08:42 +0000 (UTC)
X-FDA: 83792175684.29.DD3BB01
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf14.hostedemail.com (Postfix) with ESMTP id E53F4100003
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 04:08:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rneKP4IZ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755576520; a=rsa-sha256;
	cv=none;
	b=W/OoVIVq1Rue4rcR3UW5kHX3IG+e5O1S5WI5kRSC1FtwcdHDNux/TWxU5LapE104CPBtsj
	LJpoI6yF2qDCINFXkHF0QoJv8G1ftKfg9fgHkQMqkL3tamXNoBu+A3QNRji5LGL1lDjXzx
	uoDoAKneks8V2qS4YoC6DgXUau5nhZ4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rneKP4IZ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755576520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kNqSNNC+ZFCES/MshdQXARqO1gw350ZAtbqLST4gBOI=;
	b=YNI0pZVE6Fsh2AnKcE1RxUH35J2/gWBib7lfLUJ/B46OQb1DCFkUT1AqR0UpCUu2S75PNV
	S80Ux/ncSKpctEHvl8Z3xzEqv7ynMcCzpegP+VecsxkrvSuyVbItugrsEY3x2COCnJqtK4
	EY/KZXP9+ZzyzpUJEs/ieQp4suJHxnA=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4b12b123e48so145151cf.0
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 21:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755576520; x=1756181320; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kNqSNNC+ZFCES/MshdQXARqO1gw350ZAtbqLST4gBOI=;
        b=rneKP4IZ2FHeNTN2qtSwiKLFaeM4koL2g0KPaXXWaMgwLbaW2COmDj/MKfmLSypz8M
         rUW5LT3v4z6xPd4Ul12A/zcy9tHVjAkzHED1UXCxozrKIQyJ9OgZ/86bOciQzGV/x8Bz
         U/gc7tpsq+1x0qrmPavlCJhgAvEfZWyDQUO9gxckea9ZXT+pNupZHoC0t6zbTzd/LCV2
         eDU+1FtXkXFqvzfyFZVFZUMTny4TvAqTrH0F5ltFasfk1cN9gK/P2devoOi90TYOlIUN
         snSadCIzu37VB+x/g3iNyNHv0rd6U7q8cA9IeIsVHs5m7MbPSHRBgwixHZKignH0OGxb
         MxRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755576520; x=1756181320;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kNqSNNC+ZFCES/MshdQXARqO1gw350ZAtbqLST4gBOI=;
        b=VX6jHTBwyGXAFL3jybkG61cnoIVJ4MM7yXTiCZ7G3HCwiGjYPHpLdW0/c7EBWJ0mRl
         zGR3Xhh4DMhMA1zqJRZEox3fkGm3oz4rUA1Yl98fA0lqbklUeIgbyIaoYunew/TbfNGq
         oKVhM1GgBbDxPqWzQoLHtwlSjsvNQBoa8kOeRohfvc2skuoIcLErDZHwcWl0hjU29Hcx
         2HIHfuHUzyGmIMoRom2q8ocERL6Dn4zwaKSFKUsBYqliseOwLgN94cLlYfz0AGeGWJFq
         prUoAEbc61A98pjxEOD/Kyv6UL7DQcmvaorYlKFbf29QAqxO4ogmSBFmBuYMZWioXnsS
         CTVA==
X-Gm-Message-State: AOJu0YzINH4q/3CHN/QPfilIAVUZG1uNgaKTrCDyCPDHl/8ANRvB7YuG
	m7EDZnIW2mk2gBvBDapQb3Ua1CoW14iIRUImVpvicoANZJy4EZRyHjvSYGRR+xMAsih20GGz6JM
	0JWae874W6au/QXedM5geXiH2rW4QxrDu2Yi2Vn6n
X-Gm-Gg: ASbGncu3IuXilcVOS6WPQueDV+tOsVMFj2e5eWn8g2GrHv7kSqdtHLLoJhPxy1iIpq5
	UfMpEMIU9YKHLNoYcF2SWWwZxrajaxWB+SBfVhSH2Xt/KP0dwBgwCBi/31KQalRIx0E592XgBWr
	ntc4nlEdglVtW9bqXbw5jCkae0p6yjfnb3t9FTcTg/iyyH1rfBbMCgBn75Bitog8wLHsqqg17ER
	txmO2L4W5Cd63/lhgRkq+k=
X-Google-Smtp-Source: AGHT+IFbOGhUADqzf95dASxlMKGD6EvhrQL79SeIVQlkcYOfoGLJstTR7NEg3Eq1GC78cXJ92MVmgcUXRVtBajn4l6U=
X-Received: by 2002:a05:622a:20e:b0:4a6:907e:61ca with SMTP id
 d75a77b69052e-4b286426f44mr2557321cf.12.1755576519480; Mon, 18 Aug 2025
 21:08:39 -0700 (PDT)
MIME-Version: 1.0
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
In-Reply-To: <20250818170136.209169-1-roman.gushchin@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 18 Aug 2025 21:08:27 -0700
X-Gm-Features: Ac12FXx5DzlOVZAr-jbHhyctpcejdOKxZN_ofbcE7rl2HgLn0PJM0Trumx_iDt8
Message-ID: <CAJuCfpG1+bnFwpc4bxut_5tFtFc-s7+u2YF-suefoXq2-NijJw@mail.gmail.com>
Subject: Re: [PATCH v1 00/14] mm: BPF OOM
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org, bpf@vger.kernel.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Matt Bobrowski <mattbobrowski@google.com>, 
	Song Liu <song@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E53F4100003
X-Stat-Signature: ga81pm9q36kb9adypun8zi66xy6889s3
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755576520-451977
X-HE-Meta: U2FsdGVkX1/k2RgNe+2sXEF285Ty6jgh8TQ8mMzl3Wp+D2Iz/zZA2xrYMSuH4nNrIVCktK7ugSK1gbmvlj6VXXBdbdgkf70TaViaRJQkhmI7fmvHTuhLIv9b0UfkeKaPyl+7feul1I2FMX1uDyCjN1ZYArRST2W+E9db5HT2TFYxlQCrXwaog0NULSnPfClOlOZFLOQPBa5VdHbAxUYsaxh1nlv/JBbZaz43wzAINVcAM5HKN5UEa1OvrQSOnxnVyGM8FlmMO+LI02X8CUVbGMJrF01/IuZ/tfW+6A9ms+yBKcG+AlWW6QCKv+7W6u+xpp8ty0c6O9EEzeD9jM5h+yh6dD+BaDZhi59KAXfHLgHs//dq6o5clGPI7DlBn5wtc3XNPR9WAwbQvIkeHcMcXaAHkW8icUpKyv4qjlaYYw0174OVeMH0aOM10xgjun+KvnZ9KTcRSociTvC8Yvpaj1wLwtPSZLv7NxCT42EUyuHYnZNZjBXUVHxofTvjgvsv/uE3neLlbdRp3iwWREcwMw5ethFHs6FhfzvdUkyM1cGkXmB9/UBI0w6if8jlxaDn+GsBG21Qph5ikeW9OchdzQu9ZVNsE4x/sjIEBTcKj0MO7ySk4Gi5nPvBFy3gd/Fzrzg2brF4Hiu/zt5YTEU+N7xdxeQk7cgnEGga7uaQIQasBrIFHLMBOURBkE1PE5CCpVLBDJAWTOpO7CFcdgQEVOc8BHKRH2vI6nlAMfAaE3jO10T2oqq8O/rjzu2m+k1fVkysvfny5rfu1njDBFaI7zUjeebJvuMWCxgvAFw6preCDuZuXPuGKQFxoZbsz51vkMlWTF4sloiHB8dCTUHARbgf7GAfH7YdMAxuBSWolklQvWXr7w/FuIU9UuASCPYSRngMkhCILws6W+aQkZ3M8qECkJehYeWy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 18, 2025 at 10:01=E2=80=AFAM Roman Gushchin
<roman.gushchin@linux.dev> wrote:
>
> This patchset adds an ability to customize the out of memory
> handling using bpf.
>
> It focuses on two parts:
> 1) OOM handling policy,
> 2) PSI-based OOM invocation.
>
> The idea to use bpf for customizing the OOM handling is not new, but
> unlike the previous proposal [1], which augmented the existing task
> ranking policy, this one tries to be as generic as possible and
> leverage the full power of the modern bpf.
>
> It provides a generic interface which is called before the existing OOM
> killer code and allows implementing any policy, e.g. picking a victim
> task or memory cgroup or potentially even releasing memory in other
> ways, e.g. deleting tmpfs files (the last one might require some
> additional but relatively simple changes).
>
> The past attempt to implement memory-cgroup aware policy [2] showed
> that there are multiple opinions on what the best policy is.  As it's
> highly workload-dependent and specific to a concrete way of organizing
> workloads, the structure of the cgroup tree etc, a customizable
> bpf-based implementation is preferable over a in-kernel implementation
> with a dozen on sysctls.

s/on/of ?


>
> The second part is related to the fundamental question on when to
> declare the OOM event. It's a trade-off between the risk of
> unnecessary OOM kills and associated work losses and the risk of
> infinite trashing and effective soft lockups.  In the last few years
> several PSI-based userspace solutions were developed (e.g. OOMd [3] or
> systemd-OOMd [4]). The common idea was to use userspace daemons to
> implement custom OOM logic as well as rely on PSI monitoring to avoid
> stalls. In this scenario the userspace daemon was supposed to handle
> the majority of OOMs, while the in-kernel OOM killer worked as the
> last resort measure to guarantee that the system would never deadlock
> on the memory. But this approach creates additional infrastructure
> churn: userspace OOM daemon is a separate entity which needs to be
> deployed, updated, monitored. A completely different pipeline needs to
> be built to monitor both types of OOM events and collect associated
> logs. A userspace daemon is more restricted in terms on what data is
> available to it. Implementing a daemon which can work reliably under a
> heavy memory pressure in the system is also tricky.
>
> [1]: https://lwn.net/ml/linux-kernel/20230810081319.65668-1-zhouchuyi@byt=
edance.com/
> [2]: https://lore.kernel.org/lkml/20171130152824.1591-1-guro@fb.com/
> [3]: https://github.com/facebookincubator/oomd
> [4]: https://www.freedesktop.org/software/systemd/man/latest/systemd-oomd=
.service.html
>
> ----
>
> v1:
>   1) Both OOM and PSI parts are now implemented using bpf struct ops,
>      providing a path the future extensions (suggested by Kumar Kartikeya=
 Dwivedi,
>      Song Liu and Matt Bobrowski)
>   2) It's possible to create PSI triggers from BPF, no need for an additi=
onal
>      userspace agent. (suggested by Suren Baghdasaryan)
>      Also there is now a callback for the cgroup release event.
>   3) Added an ability to block on oom_lock instead of bailing out (sugges=
ted by Michal Hocko)
>   4) Added bpf_task_is_oom_victim (suggested by Michal Hocko)
>   5) PSI callbacks are scheduled using a separate workqueue (suggested by=
 Suren Baghdasaryan)
>
> RFC:
>   https://lwn.net/ml/all/20250428033617.3797686-1-roman.gushchin@linux.de=
v/
>
>
> Roman Gushchin (14):
>   mm: introduce bpf struct ops for OOM handling
>   bpf: mark struct oom_control's memcg field as TRUSTED_OR_NULL
>   mm: introduce bpf_oom_kill_process() bpf kfunc
>   mm: introduce bpf kfuncs to deal with memcg pointers
>   mm: introduce bpf_get_root_mem_cgroup() bpf kfunc
>   mm: introduce bpf_out_of_memory() bpf kfunc
>   mm: allow specifying custom oom constraint for bpf triggers
>   mm: introduce bpf_task_is_oom_victim() kfunc
>   bpf: selftests: introduce read_cgroup_file() helper
>   bpf: selftests: bpf OOM handler test
>   sched: psi: refactor psi_trigger_create()
>   sched: psi: implement psi trigger handling using bpf
>   sched: psi: implement bpf_psi_create_trigger() kfunc
>   bpf: selftests: psi struct ops test
>
>  include/linux/bpf_oom.h                       |  49 +++
>  include/linux/bpf_psi.h                       |  71 ++++
>  include/linux/memcontrol.h                    |   2 +
>  include/linux/oom.h                           |  12 +
>  include/linux/psi.h                           |  15 +-
>  include/linux/psi_types.h                     |  72 +++-
>  kernel/bpf/verifier.c                         |   5 +
>  kernel/cgroup/cgroup.c                        |  14 +-
>  kernel/sched/bpf_psi.c                        | 337 ++++++++++++++++++
>  kernel/sched/build_utility.c                  |   4 +
>  kernel/sched/psi.c                            | 130 +++++--
>  mm/Makefile                                   |   4 +
>  mm/bpf_memcontrol.c                           | 166 +++++++++
>  mm/bpf_oom.c                                  | 157 ++++++++
>  mm/oom_kill.c                                 | 182 +++++++++-
>  tools/testing/selftests/bpf/cgroup_helpers.c  |  39 ++
>  tools/testing/selftests/bpf/cgroup_helpers.h  |   2 +
>  .../selftests/bpf/prog_tests/test_oom.c       | 229 ++++++++++++
>  .../selftests/bpf/prog_tests/test_psi.c       | 224 ++++++++++++
>  tools/testing/selftests/bpf/progs/test_oom.c  | 108 ++++++
>  tools/testing/selftests/bpf/progs/test_psi.c  |  76 ++++
>  21 files changed, 1845 insertions(+), 53 deletions(-)
>  create mode 100644 include/linux/bpf_oom.h
>  create mode 100644 include/linux/bpf_psi.h
>  create mode 100644 kernel/sched/bpf_psi.c
>  create mode 100644 mm/bpf_memcontrol.c
>  create mode 100644 mm/bpf_oom.c
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/test_oom.c
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/test_psi.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_oom.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_psi.c
>
> --
> 2.50.1
>

