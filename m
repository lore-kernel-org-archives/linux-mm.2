Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A4E5C9832A
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 23:32:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C3806B0088; Sat, 26 Sep 2026 19:32:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 175CE6B008A; Sat, 26 Sep 2026 19:32:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 062FB6B008C; Sat, 26 Sep 2026 19:32:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D1FBF6B0088
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 19:32:25 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BC54D16096C
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 23:32:23 +0000 (UTC)
X-FDA: 85257514566.16.8D40443
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id C39CE100003
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 23:32:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oSnJHM4f;
	spf=pass (imf14.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790465541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nw4tcFFem5fMw8F25atJ8BPsyQyyVvwGckLrZIYusgw=;
	b=x9Ef+OOBd1ClzTeQYfK9PsgiuDAyBMnwDaXrRSsehQYOE+tsplXl+GhyhcMjSoile8JMr1
	zkv0Do6bvejQWrNSg/pD4fiuCKKoUm/apQIvqM8bulDiTBI/2oPd9bQfjuqBuC2UzTWvUL
	jVbXGeUpysBIeE6ygj19SmSDTH9JMCE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790465541;
	b=KaXm8xTdQ4ltXrT6QEkypt3JXe0M2fZvak9a/oBReILrdHcwi3zTjK+6M3JxW+j2b2yjSt
	ut9PgRaqpCpQTyCQjZ4y6oOMO2Qzk0gfNGmSL//9uPh0whpxZR5QJIWtg3Fa/1WwlFZwIN
	v23qVjYWlbbNMUnWuFCazePffPlYeJg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oSnJHM4f;
	spf=pass (imf14.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8C2C1447A5
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 23:32:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 682061F0089C
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 23:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790465540;
	bh=nw4tcFFem5fMw8F25atJ8BPsyQyyVvwGckLrZIYusgw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=oSnJHM4fiIR4Plle97onn98lQr1SN73bzdns9EL1QaFpA7ed7Bv7G+i4AwQjeAk5X
	 ahnnWEVu2auJn98A77tjx+275Wbm1eZd50oOB6t09S7M8SylVeLUixL592bazL8Zqf
	 e4vNFsSd0UdTzN0DLRcbBKv+p6c0uI+9Hw5aTb/qiO97oiAWWnfazRwbOw87MMz0iB
	 YEzQjTRI+LN9rd9RCAlj7Z15cbFCTj3hnHtICBXfmcpZ6V6aGLqUvIOsqZPHckemAk
	 qo8cYFUza6+6p8qMjFYS+Nj9tRx1GOM24WU6lCk/y5Q2t6vpPxTNcZLY7+DyV7FYWL
	 /bsGZjS+YLX6A==
Received: by mail-ed2-f35.google.com with SMTP id 4fb4d7f45d1cf-6a60591ae54so3082560a12.3
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 16:32:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByKGIeHBsyJ+vpGClWC3IsC2zMLcu8yLoDMDPnymosphvDKI+FlTQBM0I1nQ6sK8VIWaboNqj/uaw==@kvack.org
X-Gm-Message-State: AFuF++mEAGpNjCt4dzanIFTXAcT5ImjMfKzt//i7mC+XVB3/IOejIYBG
	LZ9bTg0SDUnlCW+DndlT6gyugEd0W/NE6GAIY8pRaXzYtw5gAXiPwXDqpdsVOedFYt+heAScsDo
	jcrruLj72E0f5nlweQV8Mwxw0HS6D05cpPx8JNDedvQ==
X-Received: by 2002:a17:907:962a:b0:c2d:ca32:2176 with SMTP id
 a640c23a62f3a-c2dca3235abmr54019966b.8.1790465537433; Sat, 26 Sep 2026
 16:32:17 -0700 (PDT)
MIME-Version: 1.0
References: <20260926045517.3458413-1-matthias.goergens@gmail.com>
In-Reply-To: <20260926045517.3458413-1-matthias.goergens@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Sat, 26 Sep 2026 13:32:06 -1000
X-Gmail-Original-Message-ID: <CACePvbWPLegjMtF4jYN4+_1ZeoEuBHwZuwNyMpYwPZaA0edO5A@mail.gmail.com>
X-Gm-Features: AclHuK9AxoX5x-gecpb2ks2aU57CnhQ2g3FIIpOxpjBk-hgB0LOGfyaEJiKPKFM
Message-ID: <CACePvbWPLegjMtF4jYN4+_1ZeoEuBHwZuwNyMpYwPZaA0edO5A@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/4] mm/swap: reserve swap areas for deliberate offload
To: Matthias Goergens <matthias.goergens@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, linux-api@vger.kernel.org, 
	Alejandro Colomar <alx@kernel.org>, linux-man@vger.kernel.org, Karel Zak <kzak@redhat.com>, 
	util-linux@vger.kernel.org, Jani Nikula <jani.nikula@linux.intel.com>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, intel-gfx@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Pavel Machek <pavel@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, linux-pm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Shuah Khan <shuah@kernel.org>, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: j6ax8r5hpurdffyd3tf7f7ha75sofwrc
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C39CE100003
X-HE-Tag: 1790465541-884560
X-HE-Meta: U2FsdGVkX18JjV+NYXlbkXQO//PnwolCbPJjRG7RJnsysMO+BUI+WJZlU5t2IU9w7MzjW/yFLeQSkUpyuKRbsXfvZiqAf+dxaTulkfF4hYypqD8OZOYMFmewJrsUW83L00bqqCCLaL7fmOqDHmI1k1tf7aabBGSNGy5+8LnvFH/+qwYOukTPz0G/mmfbd3t8CJkq136SmeZzNwWTzO2mctcquQhjXQWu/4Voa/C2++eSJ+FuqYNdGT9QXaMgbUDvUZrAV+PgIMmNbThGjS6yslC5BurBWWzDs+wrkHR9n+cjao+Qvj7+71OTMFwstUHyy4bmwvB9YjkftZM25nvR3HvPYfuM/Y56wh94sJDgO0uQi+PdTtmroB75grnvTRR9TUU79aIlO5rtfjP3+IuEfOptZDYYVQHPw20tzqM7xrwW8Qj7zi2AGNnTV/hEd8k61KCmcshv2wlgcYVOrq3f6L3aHAnN3RAaSct6X4NEG/WPQPc1sHkGZvThcsANX9SbjfARU3e4SQFCmIReALcSuFM+a+O211w0E50KNZxJwqOK/rb3pXKNmju2LaKalxEAQvXSKqUgMxbP5TQudXs4WmccNHiHb3DG4g3Yw/qyt5tilhDirVVEJbJpyrVIU3ofZo6jrLqeOaLSdNB9dw2ZM0C9kHGxCU2xgW4pUN62SUCeoJwomo8iu+71ZtSWVoIB40ILjwAFfGR35+vkmeMx7yng/7US4vzZOHCvAIUtO1DOGXt4PMSK6plJHGtEC4uMABEBeQUCS8hHs5m9+BHJppvngApSAOLQ3VVtlpOrXotbNc8rVVelOBYuHS7t66rDoemrE3leVDY+66CXCfxWq0EoUEk6kQEeATFxMAMD44JMnlpvJq95f6JBgoSReGWAOeRlCTZXGv4nld5b6abLLWpNiKDqcnS2n/mXxH8qTLjy1r9gRzzk7kbG5VG43crhKwl/o4hi3JLL19DT8CV
 mkxd0sW+
 uWIuUmlda3FJmbSQtFXr0o6LleqS4aHbcERuAl6mWGb5HPC6v87USkx4QQdXccB/GkQLyutk86Z16gj9rr8GQsRrlWK5lnGz02EiaZc7smWhIBeZ5RS2Ibebw9muQn5sgGhOjjHnwxjVSCvg7AKhd7bDiLtE7r1U2WDsOk7edNcPzvhnC33KZ/eTJIyWx4DsKJUY47iJgpkXTjmfLdCbdxNXyYhEBXHTeqO7u0BuB1WYS8skyDQj/HYVfQQEHIqMjQd5JuCR7ncswl3DC3GEGmoAJsstA/TXAITXzl65b+3SZrWKX0COmUwbKfXzW+KBIQ9nK97gE3lNk6JH9jyW4emtDDgLAYAWLCHYNVgyy1cgJEOG/1X209rJw5OKL8uQwnY23PIynOc+MMlgNVIcTGFXcVx3iLrZZ+bGm59QkYeAxaLWbN2VbvPbx3DRIKq0Rj+YAe635LL1c1zFboXrPG58FBnYPzY2TCaCRi8Kur3A/Wio12T/ugBJYLlVohYmUC0PTHTFusJ/WZCRbphdfj6gQ0IAAaV8zdi0b5k22NPXkCrZX4GqOhLP+yYH9G4s6QM3ns5U0mUZ8OXCXMrNr2Ngy2Wgj5yKYdDnKNEjfjFygULZX9TfBvq3OTXD04WjZRZ/WeqtXkr3UB2YaM3vKnWX22RVfL+jSVEDbmix7vUT+GK+4chHBnOUysQdTCmfo8+mZ1VzQlW4IZQslZ+aUjV8gY8GLuvHMtctu0b7uH4BodWOoPpezmGNMMcUBrc3OQ2fmckOfU9/z/2m1hmPHRFsSXGvASyo3UXwst8j0AMIs/38=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 25, 2026 at 6:55=E2=80=AFPM Matthias Goergens
<matthias.goergens@gmail.com> wrote:
> The series fixes zram selftest device tracking and error reporting, adds
> the swap policy with DRM eligibility checks, and tests routing, workingse=
t
> activation and retained-entry write refusal. It is based on mm-new at
> 995829088503.

Hi Matthias,

I can't find mm-new 995829088503 anymore.

Your patch does not apply cleanly to the current tip of mm-new
mm-unstable, or mm-stable branches.
Do you have a git repo with your patch applied?

mm-new is whatever Andrew can find on the mailing list, regardless of
whether it has been reviewed. That mm-new branch is very unstable,
even more so than mm-unstable, which should at least have some review
already. Maybe consider using mm-stable or mm-unstable as base next
time.

Chris

>
> Feedback is particularly welcome on:
>
> - Activation-time eligibility versus backend placement or migration:
>   is retained-entry refusal, with possible reclaim churn or OOM,
>   acceptable without migration?
> - Eligible-capacity accounting, including overcommit limits and OOM
>   scoring; cache recovery, cluster invalidation and workingset activation=
.
> - Persistent activation and visibility: current swap listings do not
>   expose the policy.
>
> Validation includes x86 builds, affected arm64 MTE objects and builds
> without swap or memory cgroups. QEMU tests covered routing, retained-entr=
y
> recovery, data integrity and cleanup, with negative controls for write
> refusal and teardown failure.
>
> I have also been using this policy on my own machine with experimental
> bcachefs swap support, with no problems observed so far. Deliberate stres=
s
> testing is confined to VMs; I do not deliberately stress-test this machin=
e.
>
> Changes since v1, incorporating Sashiko's public review [7]:
>
> - Improve selftest isolation, retained-swap measurement and memlock skips=
.
> - Track allocated zram devices, wait for udev probes and report cleanup
>   errors without deleting data through a mount that could not be released=
.
> - Clarify activation, capacity reporting and conventional fallback limits=
.
>
> [1] https://patchew.org/linux/20260825153238.2695446-1-nphamcs@gmail.com/
> [2] https://patchew.org/linux/20260713025644.170839-1-youngjun.park@lge.c=
om/
> [3] https://openzfs.github.io/openzfs-docs/Project%20and%20Community/FAQ.=
html#using-a-zvol-for-a-swap-device-on-linux
> [4] https://engineering.fb.com/2022/06/20/data-infrastructure/transparent=
-memory-offloading-more-memory-at-a-fraction-of-the-cost-and-power/
> [5] https://www.kernel.org/doc/html/latest/admin-guide/mm/damon/reclaim.h=
tml
> [6] https://www.kernel.org/doc/html/latest/admin-guide/mm/zswap.html
> [7] https://sashiko.dev/#/patchset/20260914104501.3960616-1-matthias.goer=
gens@gmail.com
> [8] https://github.com/util-linux/util-linux/pull/4633
> [9] https://lore.kernel.org/all/20260914105606.3997649-1-matthias.goergen=
s@gmail.com/
>
> v1: https://lore.kernel.org/all/20260914104501.3960616-1-matthias.goergen=
s@gmail.com/
>
> Matthias Goergens (4):
>   selftests: zram: track owned devices and report cleanup failures
>   mm: restrict offload-only swap to proactive reclaim
>   selftests: zram: cover offload-only swap policy
>   selftests: zram: cover retained offload-only entries
>
>  Documentation/mm/swap.rst                     | 105 ++++
>  drivers/gpu/drm/i915/gem/i915_gem_shrinker.c  |   2 +-
>  .../gpu/drm/i915/gem/selftests/huge_pages.c   |   6 +-
>  drivers/gpu/drm/msm/msm_gem_shrinker.c        |   2 +-
>  drivers/gpu/drm/panthor/panthor_gem.c         |   2 +-
>  drivers/gpu/drm/ttm/ttm_backup.c              |   2 +-
>  drivers/gpu/drm/xe/tests/xe_bo.c              |   2 +-
>  include/linux/swap.h                          |  29 +-
>  include/linux/vm_event_item.h                 |   1 +
>  mm/memcontrol.c                               |  20 +-
>  mm/page_io.c                                  |  24 +-
>  mm/swapfile.c                                 | 123 ++++-
>  mm/vmscan.c                                   |  31 +-
>  mm/vmstat.c                                   |   1 +
>  tools/testing/selftests/zram/.gitignore       |   2 +
>  tools/testing/selftests/zram/Makefile         |   4 +-
>  tools/testing/selftests/zram/README           |  20 +-
>  tools/testing/selftests/zram/config           |  10 +-
>  tools/testing/selftests/zram/settings         |   1 +
>  tools/testing/selftests/zram/swap_offload.c   | 425 +++++++++++++++++
>  .../selftests/zram/workingset_offload.c       | 207 ++++++++
>  tools/testing/selftests/zram/zram.sh          |   9 +
>  tools/testing/selftests/zram/zram01.sh        |   9 +-
>  tools/testing/selftests/zram/zram02.sh        |   9 +-
>  tools/testing/selftests/zram/zram03.sh        | 174 +++++++
>  tools/testing/selftests/zram/zram04.sh        | 164 +++++++
>  tools/testing/selftests/zram/zram05.sh        | 447 ++++++++++++++++++
>  tools/testing/selftests/zram/zram_lib.sh      | 189 ++++++--
>  28 files changed, 1926 insertions(+), 94 deletions(-)
>  create mode 100644 tools/testing/selftests/zram/settings
>  create mode 100644 tools/testing/selftests/zram/swap_offload.c
>  create mode 100644 tools/testing/selftests/zram/workingset_offload.c
>  create mode 100755 tools/testing/selftests/zram/zram03.sh
>  create mode 100755 tools/testing/selftests/zram/zram04.sh
>  create mode 100755 tools/testing/selftests/zram/zram05.sh
>
> --
> 2.55.0
>

