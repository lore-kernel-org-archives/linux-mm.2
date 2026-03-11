Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C9E81125852
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 16:38:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67A056B0089; Wed, 11 Mar 2026 12:38:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64FEB6B008A; Wed, 11 Mar 2026 12:38:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 579166B008C; Wed, 11 Mar 2026 12:38:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 301936B0089
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 12:38:30 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AA0CA5751B
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 16:38:29 +0000 (UTC)
X-FDA: 84534340338.14.5D4826C
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3D3DA140016
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 16:38:26 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	spf=pass (imf23.hostedemail.com: domain of yskelg@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=yskelg@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773247107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P08WFOTXPeZbjNHq2MDEWVEHtsVyIG/JuJeitfuWRP0=;
	b=jMmd4l4xwEkM1sOpqQzvn1qE07qtMJxP4z7k5SD0Uf8gtts2yyY4dRnwviyUbzSRvPMI8P
	Sc4dU1rYAUP53T55+ZuonOOcmn56qWOtDtFZYt/ttStvHh9NFdGZ4u4XfmxJo4CVvcALT3
	oHq/izI9VoMfuObJUpdC+QUOhK8KpCE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of yskelg@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=yskelg@gmail.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773247107; a=rsa-sha256;
	cv=none;
	b=jbr62gHv0QauGo1QQRPzyCat3P83wXWu5Qo9dru0NwXslBJpmHUmAgBZhBuqiYPdqOdKOu
	ak0OsA/xxVQyUgbKuhttT/6HsZVEPQzf4rJR/xxXuYKEChcMdxoiY8p/u7vUzy1BNhEYk2
	Z4KWdMk7d9fTbh7K/FK0yX9ndzkc2eA=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2ab1c8fdc40so167445ad.1
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 09:38:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773247106; x=1773851906;
        h=content-transfer-encoding:in-reply-to:organization:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P08WFOTXPeZbjNHq2MDEWVEHtsVyIG/JuJeitfuWRP0=;
        b=ZeWdBHAb+NlnKzimtqcs5yHpaiWJ3K9mlzJ6S+K4eUbjJ9L++NBmBzCOjwoYonJVLl
         kImix3Jkd6z5lDl+P4rKkczF4kQaV2RYvx4+X3PhjhQ2b7BOi9Gm4oDL5NHThJIum5T5
         DOXVg1UzNFLzu+u76E6oOzA78MO/zV+QuEyliWinAEB37X8EfJfxJrVQi4Y6g3L2cdj1
         5QWQMyL2MabdiAA/0yeYnnbsWDP44eSDpZfyMVtz8oylg4up5OH/K4Milai9bOrKKRVf
         9iff0UoQJmdZ8eYrYBRZ17ETfEmel9t7YFF9ZcED5mdl6t9e9OBkbsFjrQ4aYCa+UIZ1
         07Qw==
X-Forwarded-Encrypted: i=1; AJvYcCV8gD1Sk046HUzs6wyPmPx1Lgx9LEZFQHYL5M4qHmUHhBu0hGjZtWDG+6UNFb7qiqylZHGek3iVNw==@kvack.org
X-Gm-Message-State: AOJu0Yz7IcpQTZLJ/Vf9+VnDsprwzt8mnbRw5COJVp13TKo7HCeIo+/J
	MFnyVeDyYOXpjmd8VARhO65IIQODL/t2rISZoWuxJ/OE6FwNJLTYGUay
X-Gm-Gg: ATEYQzwhXkBBkHIJ/3bZumhU/nSx6uSOKLK9vsJgG8w8GYsFelrGeUUMw6UzynSsX2L
	HqH9Tq33LFHHE7GL1qH0x6z+zfw8Uq8uRqK3qmIoiyKDxtx1AaUXtQ+XMQoXCXz+RCxGPiNFbp3
	VEyOThsbPVbIE+2RWN2cjovCtTimUasTXcgxXNdkenT8+o9L2j2ez+fImyKBieQc4SAjUrgjJcN
	DjTyTFjjereAxyUI0eOxe49NpSYkCSC0C0B8CwdX21lvjilG7d8+Ri8Z9cZGQCPOWubu31ExvpC
	evsbXxy14y+z3w0C7lzDyMru9Q2D2quMcdDHZDjhm8oGPg8Diex3ex+RpUlBAABvoeKXaKETD7V
	HilrdioBBl7CTZJBkIHPiQn7ERL158Tc4F20Hsmp7ExJZqDBajDrgXNyUIlgdrSf7cSKHTVdD3V
	0NjRH1DQdxRZ16H9OY23cAU47QMsNsVbIF3gGKRUDwWLCDdF/TmiBxt7/7NuxRNlkoaAgSuEQTf
	dp/3E24BZYbL/MnG/eVAOZtXsnoYiRt
X-Received: by 2002:a17:902:e88d:b0:2ae:5745:f0ef with SMTP id d9443c01a7336-2aeae7a37fdmr23488625ad.2.1773247105821;
        Wed, 11 Mar 2026 09:38:25 -0700 (PDT)
Received: from [172.30.1.49] ([119.206.52.3])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aeae246abcsm28390525ad.26.2026.03.11.09.38.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2026 09:38:25 -0700 (PDT)
Message-ID: <02e5b102-d8e2-4fbf-8818-55863e425c96@kzalloc.com>
Date: Thu, 12 Mar 2026 01:38:19 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 20/42] dept: apply timeout consideration to dma fence
 wait
To: Byungchul Park <byungchul@sk.com>, Nathan Chancellor <nathan@kernel.org>
Cc: kernel_team@skhynix.com, torvalds@linux-foundation.org,
 gregkh@linuxfoundation.org, kernel-team@lge.com, linux-mm@kvack.org,
 minchan@kernel.org, harry.yoo@oracle.com, gwan-gyeong.mun@intel.com,
 max.byungchul.park@gmail.com, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
 boqun.feng@gmail.com, Waiman Long <longman@redhat.com>,
 yunseong.kim@ericsson.com, yeoreum.yun@arm.com,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>,
 Stuart Summers <stuart.summers@intel.com>, Nirmoy Das
 <nirmoy.das@intel.com>, intel-xe@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, llvm@lists.linux.dev,
 patches@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20251205071855.72743-1-byungchul@sk.com>
 <20251205071855.72743-21-byungchul@sk.com>
Content-Language: en-US
From: Yunseong Kim <ysk@kzalloc.com>
Organization: kzalloc
In-Reply-To: <20251205071855.72743-21-byungchul@sk.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3D3DA140016
X-Stat-Signature: wwmnux5rh4cc7wijkbcqp8pqx1tggakg
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773247106-44927
X-HE-Meta: U2FsdGVkX19fKsIJeAvqN0g1X+TzEzZ52rA6vKe8dT1F2HLVpyNS6+l6GdQncmoehaVPVJG4LashOicAamyRWVT1+LlS+juaZNkQ7WfEaxncVMCSIkbec1IhlldtrWI3jEqxHmArKpyZWNt5iKyX2sOmkGUBLKDAA3Jw+NufrSzj5zkg/Od9E1dqSwBDq33ExJr8ZWgoZ83HRShYGgqvDPPOwLIdawnS77Snj+3qBKKdBGN2dL2haHJvCg1SqMctmOVlMt3X9Wy5UN7c2mKJiryCL5KkjLJaUawCT8j/E+iNWhJ4MMSCLrlGf/cfUhqX+aiB4vuEkUl+psCfaC3jEy79wBBnkAox2WS19/+4E0G3s+kJt5G/zrZN5CzKlhf7zIQbJRY875uXQE4STK8gGMj7KKSZAM8ZXfqHy3oDQvzCyC+uFLgJTt0YnObwEBobz145dGH77zyR2ihbnceeYoJ6WqjCdnN4T3+X0vq1whS/gS/B4oFbuWTjc/YaU0VLlig+Q86AWxN1bWKGc5qT7E2sf1mdTAxrL1qPslGBa3NTXdYisA0MTajyj+z9vVeWCB2f/nOymJz3feBLKnh+TGYBowOcqTBRzQNg6sEn+GwsiScLj27V+R5n34AoHUZ1MTqZvJwP8HmeRlUrRWi7MTw4HqKzP2qzzPl6BX8wTcMBBiEB/vezWc+F6HULVlb8Wah4wfnwJYvdWR1c2RDFCbH6ojurhNfSZQlDszQkq1+bAmLCyGZV4hnzFTfpdjEr8I9SN39F4DRQLVTCQosucU0+r0nrQHkKhb02jJ2UPd4whxMXd+8tCo4sX4xjGDT6lx4bywT/asumeM9dq8IecLj4Ehu7IuRndljQCwbtXsYUOJsOR3NJa56L139/YSe+3GHd55/tmWxYomVl+81AnPpOuIyz0KNlGEepr8afJMo22yp0uDXECWOFaBeLCN0ZBFmNCUBEysGpdJLGag+
 YYpR11Qc
 vtNxUqynLTnIceEIjmVu6zSeejwvyUvzO13ENV475TKpKdzamaekWCQyoFagy60Td10U3GH4u/cHJGpwSrLWMQvFS+odRm52clKnhObvkI1lzK154vqCDgjMy5WuvGcTSBkJIn/VQ57LwCTUNQmaCHUW0TacqouSsGT4w4xAMxZUv8phx5RrRxS0SQzb9mVUjSefqxMq4HUHQWD0njtcj/COD/15A13Vg7kEPVxPmPR9IYhisv4dBUFhq7HEWBey4/PC24gAkkjgy0n9hMRXHyJTVz6rTz2JZvLy4qthf2SKQNGn+DqrZgTtHpyb8fDUzCcPirwExaDeuTA+0Z9tRctu3tsDHPpybIGQfl9tncYq1WdO3nRGrvK9Atrt98O4DGE12GNFQQUAz4IYq7hMvAbjfQjP+HvGyvfghz+QPaHs7NEZFmIN0PMb0FI2cTVp4EROlI5lHzPVUS67WPoE8xnasbEBgCekU10rFfJfByyxWbC4BMh8emS+A8uZjgNZv+/MMxkwg17Zrrzq2BcVdGMN4QlG/y/pXRjA3J03Ve+WlKZk3d95pHM2zU50TOhzhRfB6MyczLKeVfKRlg9ek34wbPJwi5Tdq9sis
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

I have been investigating repeated Clang build failures of the form:

  "cannot jump from this indirect goto statement to one of its possible targets"
  "note: jump enters a statement expression"

triggered by the interaction between drm_exec's indirect goto
(goto *__drm_exec_retry_ptr) and diagnostic macros such as _THIS_IP_,
LOCKDEP, and DEPT.

Link: https://lore.kernel.org/all/?q=b%3A%22error%3A+cannot+jump+from+this+indirect+goto+statement+to+one+of+its+possible+targets%22

Notably, failures on DEPT are currently observed on arm64 builds.
On arm64, _THIS_IP_ uses the common implementation based on a GNU C
statement expression with an address-taken label, relying on compiler
optimization rather than an architecture-specific definition. This makes
arm64 particularly sensitive to Clang's treatment of address-taken labels
and indirect goto targets.

This is also not limited to a single driver. I have observed the same
failure pattern in multiple DRM drivers when DEPT instrumentation is in
the call path (e.g. dma_fence_wait() -> sdt_might_sleep_start_timeout()
-> _THIS_IP_), including msm and others.

$ clang --version
clang version 23.0.0git (https://github.com/llvm/llvm-project.git
1ff1e5f10a5c765b4cf1344c4964604dcd09fef3)

drivers/gpu/drm/msm/msm_gem_vma.c:919:3: error: cannot jump from this
indirect goto statement to one of its possible targets
  919 |                 drm_exec_retry_on_contention(&exec);
      |                 ^
./include/drm/drm_exec.h:123:4: note: expanded from macro
'drm_exec_retry_on_contention'
  123 |                         goto *__drm_exec_retry_ptr;             \
      |                         ^
drivers/gpu/drm/msm/msm_gem_vma.c:909:3: note: possible target of
indirect goto statement
  909 |                 dma_fence_wait(vm->last_fence, false);
      |                 ^
./include/linux/dma-fence.h:677:2: note: expanded from macro 'dma_fence_wait'
  677 |         sdt_might_sleep_start_timeout(NULL,
MAX_SCHEDULE_TIMEOUT);      \
      |         ^
./include/linux/dept_sdt.h:46:31: note: expanded from macro
'sdt_might_sleep_start_timeout'
   46 |                 unsigned long __this_ip__ = _THIS_IP_;
         \
      |                                             ^
./include/linux/instruction_pointer.h:10:41: note: expanded from macro
'_THIS_IP_'
   10 | #define _THIS_IP_  ({ __label__ __here; __here: (unsigned
long)&&__here; })
      |                                         ^
drivers/gpu/drm/msm/msm_gem_vma.c:909:3: note: jump enters a statement
expression
./include/linux/dma-fence.h:677:2: note: expanded from macro 'dma_fence_wait'
  677 |         sdt_might_sleep_start_timeout(NULL,
MAX_SCHEDULE_TIMEOUT);      \
      |         ^
./include/linux/dept_sdt.h:46:31: note: expanded from macro
'sdt_might_sleep_start_timeout'
   46 |                 unsigned long __this_ip__ = _THIS_IP_;
         \
      |                                             ^
./include/linux/instruction_pointer.h:10:20: note: expanded from macro
'_THIS_IP_'
   10 | #define _THIS_IP_  ({ __label__ __here; __here: (unsigned
long)&&__here; })
      |                    ^
drivers/gpu/drm/msm/msm_gem_vma.c:909:3: note: jump enters a statement
expression
./include/linux/dma-fence.h:673:38: note: expanded from macro 'dma_fence_wait'
  673 | #define dma_fence_wait(f, intr)
         \
      |
         ^
drivers/gpu/drm/msm/msm_gem_vma.c:933:5: error: cannot jump from this
indirect goto statement to one of its possible targets
  933 |                                 drm_exec_retry_on_contention(&exec);
      |                                 ^
./include/drm/drm_exec.h:123:4: note: expanded from macro
'drm_exec_retry_on_contention'
  123 |                         goto *__drm_exec_retry_ptr;             \
      |                         ^
drivers/gpu/drm/msm/msm_gem_vma.c:909:3: note: possible target of
indirect goto statement
  909 |                 dma_fence_wait(vm->last_fence, false);
      |                 ^
./include/linux/dma-fence.h:677:2: note: expanded from macro 'dma_fence_wait'
  677 |         sdt_might_sleep_start_timeout(NULL,
MAX_SCHEDULE_TIMEOUT);      \
      |         ^
./include/linux/dept_sdt.h:46:31: note: expanded from macro
'sdt_might_sleep_start_timeout'
   46 |                 unsigned long __this_ip__ = _THIS_IP_;
         \
      |                                             ^
./include/linux/instruction_pointer.h:10:41: note: expanded from macro
'_THIS_IP_'
   10 | #define _THIS_IP_  ({ __label__ __here; __here: (unsigned
long)&&__here; })
      |                                         ^
drivers/gpu/drm/msm/msm_gem_vma.c:909:3: note: jump enters a statement
expression
./include/linux/dma-fence.h:677:2: note: expanded from macro 'dma_fence_wait'
  677 |         sdt_might_sleep_start_timeout(NULL,
MAX_SCHEDULE_TIMEOUT);      \
      |         ^
./include/linux/dept_sdt.h:46:31: note: expanded from macro
'sdt_might_sleep_start_timeout'
   46 |                 unsigned long __this_ip__ = _THIS_IP_;
         \
      |                                             ^
./include/linux/instruction_pointer.h:10:20: note: expanded from macro
'_THIS_IP_'
   10 | #define _THIS_IP_  ({ __label__ __here; __here: (unsigned
long)&&__here; })
      |                    ^
drivers/gpu/drm/msm/msm_gem_vma.c:909:3: note: jump enters a statement
expression
./include/linux/dma-fence.h:673:38: note: expanded from macro 'dma_fence_wait'
  673 | #define dma_fence_wait(f, intr)
         \
      |
         ^

I was able to find the pattern of the kernel source code that uses this pattern:

  $ git grep -n 'goto \*' | grep ';' | grep -v "\*/" | \
    grep -Ev "(\*[[:space:]]+goto|_goto.*\*\);)"
  drivers/gpu/drm/xe/xe_validation.h:149:			goto *__drm_exec_retry_ptr;			\
  drivers/misc/lkdtm/cfi.c:129:			goto *labels[1];
  drivers/misc/lkdtm/cfi.c:131:			goto *labels[2];
  drivers/misc/lkdtm/cfi.c:133:			goto *labels[3];
  drivers/misc/lkdtm/cfi.c:135:			goto *labels[4];
  include/drm/drm_exec.h:123:			goto *__drm_exec_retry_ptr;		\
  kernel/bpf/core.c:1776:	goto *jumptable[insn->code];
  scripts/gcc-plugins/gcc-common.h:368:	return as_a<ggoto *>(stmt);
  scripts/gcc-plugins/gcc-common.h:373:	return as_a<const ggoto *>(stmt);
  tools/testing/selftests/bpf/progs/bpf_gotox.c:219:	goto *jt[ctx->x & 0xff];
  tools/testing/selftests/bpf/progs/bpf_gotox.c:261:		goto *jt1[a];
  tools/testing/selftests/bpf/progs/bpf_gotox.c:263:		goto *jt2[b];
  tools/testing/selftests/bpf/progs/bpf_gotox.c:284:		goto *jt[a];
  tools/testing/selftests/bpf/progs/bpf_gotox.c:287:		goto *jt[a + b];

I understand that Clang's behavior here is intentional and conservative:
any address-taken label in the same function is treated as a potential
indirect goto target, and jumping into a statement expression is diagnosed
to avoid semantic issues. This aligns with:

  - [Clang] Diagnose jumps into statement expressions (D154696)
    https://reviews.llvm.org/D154696

At the same time, the kernel is not using _THIS_IP_ for control flow.
The label address is used purely for diagnostics (lockdep/DEPT attribution).
However, as discussed in:

  - LLVM Issue #138272: Add builtin/intrinsic to get current instruction pointer
    https://github.com/llvm/llvm-project/issues/138272

using blockaddress (&&label) purely to obtain an instruction pointer is
problematic in LLVM's model, since blockaddress has defined behavior only
when used with indirectbr or for null comparisons.

Similar issues have also been observed in other contexts where indirect
goto interacts with address-taken labels, e.g.:

  - LLVM Issue #28019: Wrong 'cannot jump from this indirect goto statement'
    https://github.com/llvm/llvm-project/issues/28019

Given this, I think there is three possible directions:

1) Continue per-callsite structural workarounds
   Keep separating indirect goto usage from any code that expands _THIS_IP_
   (e.g. moving PROVE_LOCKING / DEPT paths into helper functions). This avoids
   the diagnostic but requires ongoing refactoring and does not scale well as
   similar patterns reappear across drivers.

2) Introduce a compiler-supported alternative to _THIS_IP_
   As discussed in LLVM Issue #138272, a dedicated builtin or intrinsic to
   obtain a best-effort instruction pointer for diagnostics would allow the
   kernel to avoid address-taken labels entirely and eliminate this class of
   conflicts.

3) DRM/drm_exec-scoped refactoring as a pragmatic middle ground
   Since drm_exec is the common convergence point where indirect goto and
   DEPT/LOCKDEP instrumentation can meet in the same function across multiple
   DRM drivers, we could refactor the drm_exec usage patterns (or provide a
   recommended wrapper pattern) to structurally separate the retry/indirect-goto
   region from instrumentation that expands _THIS_IP_. This would avoid
   kernel-wide churn while addressing the recurring failures in DRM drivers.

I am not proposing to weaken Clang's diagnostics. Rather, I would like
feedback on whether option (3) is considered an acceptable short- to
medium-term approach, and whether option (2) is the preferred long-term
direction from the compiler side.

Any guidance from the LOCKDEP and kernel LLVM maintainers on the preferred
path forward would be greatly appreciated.

On 12/5/25 4:18 PM, Byungchul Park wrote:
> Now that CONFIG_DEPT_AGGRESSIVE_TIMEOUT_WAIT was introduced, apply the
> consideration to dma fence wait.
> 
> Signed-off-by: Byungchul Park <byungchul@sk.com>
> ---
>  drivers/dma-buf/dma-fence.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dma-buf/dma-fence.c b/drivers/dma-buf/dma-fence.c
> index b313bb59dc9c..f2cc7068af65 100644
> --- a/drivers/dma-buf/dma-fence.c
> +++ b/drivers/dma-buf/dma-fence.c
> @@ -799,7 +799,7 @@ dma_fence_default_wait(struct dma_fence *fence, bool intr, signed long timeout)
>  	cb.task = current;
>  	list_add(&cb.base.node, &fence->cb_list);
>  
> -	sdt_might_sleep_start(NULL);
> +	sdt_might_sleep_start_timeout(NULL, timeout);
>  	while (!test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags) && ret > 0) {
>  		if (intr)
>  			__set_current_state(TASK_INTERRUPTIBLE);
> @@ -903,7 +903,7 @@ dma_fence_wait_any_timeout(struct dma_fence **fences, uint32_t count,
>  		}
>  	}
>  
> -	sdt_might_sleep_start(NULL);
> +	sdt_might_sleep_start_timeout(NULL, timeout);
>  	while (ret > 0) {
>  		if (intr)
>  			set_current_state(TASK_INTERRUPTIBLE);


Best regards,
Yuseong


