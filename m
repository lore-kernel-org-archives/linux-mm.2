Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16EC4C5DF67
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 23:54:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 366176B0005; Fri, 20 Feb 2026 18:54:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33DBD6B0089; Fri, 20 Feb 2026 18:54:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 249596B008A; Fri, 20 Feb 2026 18:54:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 104C56B0005
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 18:54:46 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A7C2C140374
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 23:54:45 +0000 (UTC)
X-FDA: 84466492530.03.59E0BFF
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0789F180004
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 23:54:43 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=TTtoE2gl;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3QvSYaQsKCOEDFNHUOHbWQJJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3QvSYaQsKCOEDFNHUOHbWQJJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771631684; a=rsa-sha256;
	cv=none;
	b=q1qkmGo1FKF0s6LPBfHb5K9LgUbUl4lgN0XOF2NM0YaOKz3dbSvN0BlMbKmQZbpjew1hD9
	JxQ89s8m/LgJSUPlo6tArGhCAzL7Ltei+WeW/y67e8KWJZvshu4EsJN1lqk6+TR0hJkQLd
	3cT0LVyWdFflJ6Revfbhxzk42kp0lfo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=TTtoE2gl;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3QvSYaQsKCOEDFNHUOHbWQJJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3QvSYaQsKCOEDFNHUOHbWQJJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771631684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=oX6po6OlLhA6TpNB89pe3rdCVjt4izYpIUQkYe/YBf0=;
	b=eoModyvhz0F1eoYs6BDOBERAkqJG03/fvmQ/6juELMfjlo9J6WkFW7s73RPcZFZeZRy7l4
	HYjaqnPqcKCj/NAhL5mryGmg+DsElK3HlMqPTjmcIx+SDdK7XjH6YEEANqJZwIPXbOqpiC
	zzEasLnCbXoo/dssB9yiAGdZ4XY7ECA=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3562bdba6f7so15761114a91.2
        for <linux-mm@kvack.org>; Fri, 20 Feb 2026 15:54:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771631683; x=1772236483; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oX6po6OlLhA6TpNB89pe3rdCVjt4izYpIUQkYe/YBf0=;
        b=TTtoE2gldsqWJ7qRvm0Tr1psxgJnDf1U7tsiDFlM7KOHTdb8Sqyb2B/CkD66yLS/EK
         mbMYyvPNx83d0rBIoiuiiZ/SmccLQTi1BedeuyGVVsKRuVmOPmvcfhK819XhEu6l0ZeO
         OefzIiLySrLRxMsePlbqQbKWcBA8PMgf9YNxUay3LxeVeSEJuHt5nwoO/LVOy3eXb9W0
         1vfIftRALex01oTbTJdLe+7HJQ2ysnmZzv7RqgUxpJg/a7ufYeTEy3OeOcZvqEXFsZWG
         ndSi6soBxZ/v6gFk8YSDIH0leSg3tphk77E1/TD0AHNOX0Em6WFjEPGd1vd8CHleh4Ro
         CM5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771631683; x=1772236483;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oX6po6OlLhA6TpNB89pe3rdCVjt4izYpIUQkYe/YBf0=;
        b=th1N9nRyM6h61M4+JD504Aj76iaBxEgxDgnJy6+iATdf2T43AzjzMRgKn1ZU6DEA4u
         XCiRET5x+AR7FwnUXSHuMakoSBGxUBwLUkr/n5SaBKEwbNk3lbiAZLSVBCwuNnBGZBaU
         T0ZRVQqtolfQhULMUTkpRkZzNe1lU8L+uMpMYGlqgUhtmOTqGk8P/sdVz+abngNZFTBh
         Jt12wOVBzzaecEyJdycIPemc9lw16OOMvEVzuOXI+TLFzt1FYZTECaKmOIKxxjAQItAq
         df6gSXAZyjryzpt71Xp6MogeiioPm2dLMdp4pa36werqHC4mfeekdmkT87dtFa0f9G1m
         4+kg==
X-Forwarded-Encrypted: i=1; AJvYcCUKS3TqPMZ3J1PgoLU9bv+6mZj5m3i+hbU4ogtqxlhzRzY9H+BfJHJmu7QBS1hT46kdBdPqshVozw==@kvack.org
X-Gm-Message-State: AOJu0YxHLk+VhU6h2NeceeEpxsfW3tQ+OMC1/udC40BLjUQ8NgfPafIZ
	ceolL3ppp08yMgdTljbB7+eiwfOVnuP2Avu4xL+FsOIFdevNmtzmekLlJ6zaqB3RLz4cDq9mhj6
	E9dYG1y8NESzOojRGiRdFHu5EWw==
X-Received: from pjbbx11.prod.google.com ([2002:a17:90a:f48b:b0:356:2fe0:f5b4])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3147:b0:354:a065:ec3b with SMTP id 98e67ed59e1d1-358ae8d5edbmr1100686a91.27.1771631682655;
 Fri, 20 Feb 2026 15:54:42 -0800 (PST)
Date: Fri, 20 Feb 2026 23:54:34 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.345.g96ddfc5eaa-goog
Message-ID: <cover.1771630983.git.ackerleytng@google.com>
Subject: [PATCH v2 0/2] Test MADV_COLLAPSE on guest_memfd
From: Ackerley Tng <ackerleytng@google.com>
To: kartikey406@gmail.com, seanjc@google.com, pbonzini@redhat.com, 
	shuah@kernel.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc: vannapurve@google.com, Liam.Howlett@oracle.com, ackerleytng@google.com, 
	akpm@linux-foundation.org, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	david@kernel.org, dev.jain@arm.com, i@maskray.me, lance.yang@linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	npache@redhat.com, ryan.roberts@arm.com, shy828301@gmail.com, 
	stable@vger.kernel.org, syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com, 
	ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: hhskspio9oc41wdp4gsgot337bzppojf
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0789F180004
X-HE-Tag: 1771631683-440087
X-HE-Meta: U2FsdGVkX18kMK5nBEAQ8k2cNWCfFohnDQFu+Lew+iAfZczNX5lyNzRWDeiCzI0RWeXmMaDXzNTtobt3ke/cPZiRrcrFhMLJ6ZpGCgXFNTjFJuq2Ru8q69NCmRI63qKY5jjmtNkSuIggkB+oxUNHIR3e0gaEHVIjVeV9ak72NX8hwM5qZn1pt6YuSbN80yYifFiJLKGOqIJaPXExUAbRKOZ37hxM0PKXlmiRo1MtSm92knJPcxJXgcmAk2k3rSW8o4b20M3eSvFN2AgfHGExRwkOuCcOK1tnvj0ECQARToIO1qZJW0RZa38UxwCI08bbioMKBawUTyHGDEhaZYGGACHRVyHlBmTNFGepSzLEN3IOtXLPh6Z8wvJcvDFQWBSK5eW+bFEht3AjgFTkk/CkUykHTzCiztDfGqtdLQy74ntrPWfyBn4Ryd8iQP3LneiYiIL9ON533VqSLZfuBGmqRMixW4BcqAI8eXC4v0rcNg6emaBQDcwXU31vHZ95MFQWKKTary9yVv6aKozjK8t2qXqWuPjBi0nGae8veUz+nRPyMXYCB3+R6tqF8ZU1UTQtYPrbhxuTD424010p6E86Hiq/hQVjEa385oOQ87u7saTfLjoL18ZkEn635yVsf8pZJVsbym9+TO2xPx1UMhpSWxurwHoRk9JnaGhskWw90b3woKY0fWJdmTfsceA0WCwTTurttHujrvQcrMTOhAzpOTi3BoaRV8rNF7k2h2xcL11Nim9006pfRe68ECWJXO51tukAyuwZx3eRtpZLtQKWvCpwkrq0W1M6Q5ZYYrIyGN2pwXJaYDCBMqb2xpVti/YCES3rcuD0znBWMrQx6xP2zY55CLYOqWUgLK/Qw0qSX4ugIuE0OoWC4CI+pli+x5qBCeiNJpDZ6NVCTMsaXks+Z8nNLb7Gc5KtRw3LSrkrmulgNucCTgnv7EXZ3gLQv4PawwM+qx25VDit3pMlji9
 jWZl2dc1
 ZmJPCPQuPV3kIjXNdbIEBuYB5/H9W/b7CSYOvz8qkH5rm1BzEgGluH2Aq29zlRqGkvYaK6j0N7BzfA3qTNh0NIDHRORwPUAk15ChHsSmX8SMhaUitzxH0Q5tK8Vesn8Chx9SSELD0V4BG/MCgOVKI/SFW3FIPsim86Jo8Ql9Rlk4B86MzHDCVoGhhmKdYekNplbQeZCh2gv/yY1hnEwnbfHIPjNAn+o97bMesKu+XhvbD4renjm6UH55BH6YkZSiq3iA6U1O8ZrtVsqXjLPQ5Du5Jvn8RMFenD4hSt2o1PaKvBN0J7VkUk0Ka8cqXWLt8qDu9wLqvOWH5Nfbf7Py9cLLmK/fafyUnHuytG77eAhqaW/aMQqyEIB8ubqezVc1OnJ0raIh91pYpxGNrc33Sg7bbbSwanR7n6fCQcslBblgfdZPo/m3zpgaPT5Dgu4qMAxTPzIUjdyWoJ5d6hiMt2UF03xfPM7afVFlnNpnaEizGEabiexlMxKrLLiVY6eRCkeO8llD8LzHccnz67/Fhy2JvnrJhiS11248BMvVSst81/nalXT38/+sfJPrdGqlvZChezqGjarlC2NA/A7WGRNvu430jX2DHcgjKOPg/7nXU5O4VvLveL9FhqUzWUtAonSC+2zi6m0fuBLKYmESTk9ibA25k3QA56lKRK5Y0kArJ9JCltatFOm1v91GYX3IPpYDDJG0Zubr3wGsd8PIqPtxkWcNJeQeONnL1oY+VHXXPbLeKSZ2TRjRCqN5bTV8X3aZOyWLBUXAEDaFpe1XGTz8GpTwtKshm9a+JOt6JEIisQ7xQ0Vef3Ri5fE+eWf10Yl2+wnmEnDqLWBU0E5iBzhEiVDzVkaZ/MdTmDhIQBqSefRbDIG61iAz4Y1oVtB0bWY2Pm+x0UgbA4HnHb8FvK3pLOcHTC3TCgqja
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzkaller identified that khugepaged, operating on guest_memfd memory,
could cause guest_memfd folios to get collapsed, leading to a WARNing
during fault [1].

Add selftest to guard against similar regressions.

Changes in v2:

+ Found get_trans_hugepagesz(), which I should have used instead of
  adding getpmdsize()
+ Extended tools/testing/selftests/kvm/include/kvm_syscalls.h to add
  kvm_madvise()
+ Removed the magic constant address and explained alignment requirements in
  comments
+ Refactored gmem_test() macro to expose __gmem_test(), which allows custom
  sized guest_memfds for tests. Sean, I didn't add the gmem_test_huge_pmd()
  since I'm guessing a test requiring a pmd_sized guest_memfd would probably be
  once-off.

PATCH v1 [3] was sent in reply to the fix [2].

[1] https://syzkaller.appspot.com/bug?extid=33a04338019ac7e43a44
[2] https://lore.kernel.org/all/20260214001535.435626-1-kartikey406@gmail.com/
[3] https://lore.kernel.org/all/20260217014402.2554832-1-ackerleytng@google.com/

Ackerley Tng (2):
  KVM: selftests: Wrap madvise() to assert success
  KVM: selftests: Test MADV_COLLAPSE on guest_memfd

 .../testing/selftests/kvm/guest_memfd_test.c  | 70 ++++++++++++++++++-
 .../selftests/kvm/include/kvm_syscalls.h      |  1 +
 2 files changed, 68 insertions(+), 3 deletions(-)


base-commit: a95f71ad3e2e224277508e006580c333d0a5fe36
prerequisite-patch-id: e001eecc9215dc0ed28546936f86a5a09e57141e
--
2.53.0.345.g96ddfc5eaa-goog

