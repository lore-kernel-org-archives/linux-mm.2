Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1C1EF531C1
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 18:29:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31E1D6B0088; Mon, 13 Apr 2026 14:29:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D02B6B0089; Mon, 13 Apr 2026 14:29:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BD4C6B008A; Mon, 13 Apr 2026 14:29:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0B2146B0088
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:29:02 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9F7BC1A02E8
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:29:01 +0000 (UTC)
X-FDA: 84654369282.28.C95CD9C
Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	by imf01.hostedemail.com (Postfix) with ESMTP id 585B840012
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:28:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=bootlin.com header.s=dkim header.b=A6txoxr1;
	spf=pass (imf01.hostedemail.com: domain of alexis.lothore@bootlin.com designates 185.246.85.4 as permitted sender) smtp.mailfrom=alexis.lothore@bootlin.com;
	dmarc=pass (policy=reject) header.from=bootlin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776104939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=8wwTbqAk1/v1m7wW2LqSmKK5iRKdfUxdCX7mcszWNIw=;
	b=LGxuGZytI6CC/IzeFU14A1Ust+GQiP5+TgMoWOBEfEa3EJ3006XsiIAg0A3Arwi+WnlU4o
	Kz5/rveNr+8vWBfHbRw0gDFwQLQpaHKAenrmB0MFC+RbUEmjzIDDSD/3VsZijTNqnkTTxx
	cZYaIuaSPoJGlEKCTiPmSdpyyakOthU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=bootlin.com header.s=dkim header.b=A6txoxr1;
	spf=pass (imf01.hostedemail.com: domain of alexis.lothore@bootlin.com designates 185.246.85.4 as permitted sender) smtp.mailfrom=alexis.lothore@bootlin.com;
	dmarc=pass (policy=reject) header.from=bootlin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776104939; a=rsa-sha256;
	cv=none;
	b=KK1t+HKRaAHw3mQceHgcgbayxjkgUPTuke4y6HcnCc+zJ8FzcZB+wIqdN+mwEi1tQtOlNU
	qr9av6bMIr6FQ7hsEKyHa0S6AT9DEzuInsqCm2kNDB/JvaMDaIJBwv9czspelgnd8h9KTJ
	S6rO2ApKJubGi8VsxnVmktBRzz/wenA=
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 646294E4296B;
	Mon, 13 Apr 2026 18:28:57 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 24AAB5FFB9;
	Mon, 13 Apr 2026 18:28:57 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 57AC3104504B7;
	Mon, 13 Apr 2026 20:28:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1776104935; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding; bh=8wwTbqAk1/v1m7wW2LqSmKK5iRKdfUxdCX7mcszWNIw=;
	b=A6txoxr1XcmG6tEbbCTyhur5lWgPF7QbN2kOqQ54tYUX88h9fiDrus4Hjzv6K1aTBvZ2CO
	bjdVtAPCZTUuxgjc6RPvbXX0F56K9Ade5XwS7muo/TOF1Tvpmck0wAWs4AVubunqSm+Ndd
	6f01OPXyrIg/4lsYV6IK/RMy3MjbBTauAl1B50TjTV2IxPVcJuSQrO4S+u7TZwMR/mU033
	FVILOV9EtBmoXp1r76CWS2aoAmzpBnQyc2Izig6DLjirZ630fRVBYFhCLMDQGNkhc32w4F
	Q3k01keahidyZQVCTHur9l743MSGM6UBhfKfPB0DM8ZaeCot7DW4hlmohhjJyw==
From: =?utf-8?q?Alexis_Lothor=C3=A9_=28eBPF_Foundation=29?= <alexis.lothore@bootlin.com>
Subject: [PATCH RFC bpf-next 0/8] bpf: add support for KASAN checks in
 JITed programs
Date: Mon, 13 Apr 2026 20:28:40 +0200
Message-Id: <20260413-kasan-v1-0-1a5831230821@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDQyMz3ezE4sQ83bTkFDOLNDOT5BTzJCWg2oKi1LTMCrA50UpBbs4gsaS
 CNN281IoSpdjaWgCGQM1aaAAAAA==
X-Change-ID: 20260126-kasan-fcd68f64cd7b
To: Alexei Starovoitov <ast@kernel.org>, 
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
 Martin KaFai Lau <martin.lau@linux.dev>, 
 Eduard Zingerman <eddyz87@gmail.com>, 
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Song Liu <song@kernel.org>, 
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
 John Fastabend <john.fastabend@gmail.com>, 
 "David S. Miller" <davem@davemloft.net>, David Ahern <dsahern@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Shuah Khan <shuah@kernel.org>, Maxime Coquelin <mcoquelin.stm32@gmail.com>, 
 Alexandre Torgue <alexandre.torgue@foss.st.com>, 
 Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
 Alexander Potapenko <glider@google.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: ebpf@linuxfoundation.org, 
 Bastien Curutchet <bastien.curutchet@bootlin.com>, 
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Xu Kuohai <xukuohai@huawei.com>, bpf@vger.kernel.org, 
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
 linux-arm-kernel@lists.infradead.org, kasan-dev@googlegroups.com, 
 linux-mm@kvack.org, 
 =?utf-8?q?Alexis_Lothor=C3=A9_=28eBPF_Foundation=29?= <alexis.lothore@bootlin.com>
X-Mailer: b4 0.15.1
X-Last-TLS-Session-Version: TLSv1.3
X-Rspamd-Queue-Id: 585B840012
X-Stat-Signature: ker1gwxohcw5soxweuuq4k4tn184buag
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776104939-518387
X-HE-Meta: U2FsdGVkX18yyqXvwjyo+EL6U1cRAut8RflxKmiPutVu4Cz6S1z+UMeRc+jCJEBOoUwQh88tKgwpc9/2C9v7O1QRoNUe1kegcLMddW0E9uDo+OsE9ujJ+tkIZTlLIdLQAuzFrinM8FtwbjuU+0Bhu+Pl0IXqr2jddJfqRS2gAInt+JUDnZZIYPl+md+cFN5U0HZi+cRnXw700WH/vv4f39Wabr9Rv6/mcy1QyXkq7LgpctQxIpzrGIRay+RYzhvwI/5zyYG3WhznxgRQkt9xnpzOqbBGK8ksSCLZ7DSNXZCsxcVrMKewzSlNS9udrqfdixKuKDhCu3EMfZj1h/ajF2F4sV+xSheMo/d+8edEpNdRHvt/Bdtk4WzS+Nn6annJlM87GqITTk1Kq7D144lhIRvxVePkqT1fTe+6JuZibKQei1uGKsULYUEkd2RmMTX0q8HtdI9cbmb+bS3Vi9oZVnKjuJBN6d8WPb5m5HeRlx1xOsFvmCcqjeYfg8kooUDFSijq1KTNiqU2tc2iEiXC+g99/fk/cD/BlGZS94p1qWT+z4BbUdXBCHbGQqeJ7N3pQoP+RAXRsqkHC8uesY9Lf+z7vozto1OhRJmWmQElf8IpIB3Fd9wG/NAZ3fGoPAL6vDmW7Vm1ZlioEMcCWs7jM/4c+97Vrg4EjvB18bnwEOcAeMEr4lhv22NWUtbE8MQGQT7IfPepJfnbapdA467ou0YU1zTy8TAf7KXoqzQ2ab748Oo0czIyx0ecAJsyfrh42yxBYcsDYHYJZuAecif1WrdVT08jB9UknTHFFGbu5N0NxLm5l/uWXeaYbF/4Q6MlqSNkyF56GUnPBh9N5H/1uX+VG0nog2yefg+ZfCavc+MGcxOJ9uFIDds6S3fYlUChH+2cz3JKp/gfAm8ND+wBUzlKkpI/N6bjgcLr53FT3Z6ebeCIslDbKVWmup1f6EcaKouODx+jDptv/RvVGvJ
 9eI3ONqc
 ++IUqz6v92zjbxxDNiFMux6tsTuc7ls8r+ikcUu92Widis7EJUGzR4nId4JQiVDJUQlYzSQKQRIxVwOAlFjuGXkGiptPHkFUmJX6QZYDanlB95S2SKxgzngXZCm5qQ7gYZBdX6AIbQosoLyBpZ1U1/9OsdTtmcMvG70wDvS3V+2bBdvAb6d0y3am3StFoiAHQhTL7gFey+QLb/0j8PkXj/aJ7hRY6gzwZdOdSjBSmgp9J/lrW5Ce8bRYXGpMGyq6E7AvssdZ4ZL1mvoOmF3+HLcoR8XGqVdJ+hFVc99IQbjwRh8pAAfkyMvaudtCQgTHcPFsGPwFSzvDUHZSIuPxYbcUZkYzlBhOWp+NMQ/R+0acPPg8FT80d0Iv5Uvaet6XmHgMdDjt5nagF0rhdiLX0U8tFIv8skSh52MD4hVsBg/3C0AyCNMqMg4gVVZTsYLdsstFoU9+7qpMxl6s1SWNMCJ1lOypKF4k94ECQK8dvZmJ9jxM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,
this series aims to bring basic support for KASAN checks to BPF JITed
programs. This follows the first RFC posted in [1].

KASAN allows to spot memory management mistakes by reserving a fraction
of memory as "shadow memory" that will map to the rest of the memory and
allow its monitoring. Each memory-accessing instruction is then
instrumented at build time to call some ASAN check function, that will
analyze the corresponding bits in shadow memory, and if it detects the
access as invalid, trigger a detailed report. The goal of this series is
to replicate this mechanism for BPF programs when they are being JITed
into native instructions: that's then the (runtime) JIT compiler who is
in charge of inserting calls to the corresponding kasan checks, when a
program is being loaded into the kernel. This task involves:
- identifying at program load time the instructions performing memory
  accesses
- identifying those accesses properties (size ? read or write ?) to
  define the relevant kasan check function to call
- just before the identified instructions:
  - perform the basic context saving (ie: saving registers)
  - inserting a call to the relevant kasan check function 
  - restore context
- whenever the instrumented program executes, if it performs an invalid
  access, it triggers a kasan report identical to those instrumented on
  kernel side at build time.

As discussed in [1], this series is based on some choices and
assumptions:
- it focuses on x86_64 for now, and so only on KASAN_GENERIC
- not all memory accessing BPF instructions are being instrumented:
  - it focuses on STX/LDX instructions
  - it discards instructions accessing BPF program stack (already
    monitored by page guards)
  - it discards possibly faulting instructions, like BPF_PROBE_MEM or
    BPF_PROBE_ATOMIC insns

The series is marked and sent as RFC:
- to allow collecting feedback early and make sure that it goes into the
  right direction
- because it depends on Xu's work to pass data between the verifier and
  JIT compilers. This work is not merged yet, see [2]. I have been
  tracking the various revisions he sent on the ML and based my local
  branch on his work
- because tests brought by this series currently can't run on BPF CI:
  they expect kasan multishot to be enabled, otherwise the first test
  will make all other kasan-related tests fail.
- because some cases like atomic loads/stores are not instrumented yet
  (and are still making me scratch my head)
- because it will hopefully provide a good basis to discuss the topic at
  LSFMMBPF (see [3])

Despite this series not being ready for integration yet, anyone
interested in running it locally can perform the following steps to run
the JITed KASAN instrumentation selftests:
- rebasing locally this series on [2]
- building and running the corresponding kernel with kasan_multi_shot
  enabled
- running `test_progs -a kasan`

And should get a variety of KASAN tests executed for BPF programs:

  #162/1   kasan/bpf_kasan_uaf_read_1:OK
  #162/2   kasan/bpf_kasan_uaf_read_2:OK
  #162/3   kasan/bpf_kasan_uaf_read_4:OK
  #162/4   kasan/bpf_kasan_uaf_read_8:OK
  #162/5   kasan/bpf_kasan_uaf_write_1:OK
  #162/6   kasan/bpf_kasan_uaf_write_2:OK
  #162/7   kasan/bpf_kasan_uaf_write_4:OK
  #162/8   kasan/bpf_kasan_uaf_write_8:OK
  #162/9   kasan/bpf_kasan_oob_read_1:OK
  #162/10  kasan/bpf_kasan_oob_read_2:OK
  #162/11  kasan/bpf_kasan_oob_read_4:OK
  #162/12  kasan/bpf_kasan_oob_read_8:OK
  #162/13  kasan/bpf_kasan_oob_write_1:OK
  #162/14  kasan/bpf_kasan_oob_write_2:OK
  #162/15  kasan/bpf_kasan_oob_write_4:OK
  #162/16  kasan/bpf_kasan_oob_write_8:OK
  #162     kasan:OK
  Summary: 1/16 PASSED, 0 SKIPPED, 0 FAILED

[1] https://lore.kernel.org/bpf/DG7UG112AVBC.JKYISDTAM30T@bootlin.com/
[2] https://lore.kernel.org/bpf/cover.1776062885.git.xukuohai@hotmail.com/
[3] https://lore.kernel.org/bpf/DGGNCXX79H8O.2P6K8L1QW1M8K@bootlin.com/

Signed-off-by: Alexis Lothoré (eBPF Foundation) <alexis.lothore@bootlin.com>
---
Alexis Lothoré (eBPF Foundation) (8):
      kasan: expose generic kasan helpers
      bpf: mark instructions accessing program stack
      bpf: add BPF_JIT_KASAN for KASAN instrumentation of JITed programs
      bpf, x86: add helper to emit kasan checks in x86 JITed programs
      bpf, x86: emit KASAN checks into x86 JITed programs
      selftests/bpf: do not run verifier JIT tests when BPF_JIT_KASAN is enabled
      bpf, x86: enable KASAN for JITed programs on x86
      selftests/bpf: add tests to validate KASAN on JIT programs

 arch/x86/Kconfig                                   |   1 +
 arch/x86/net/bpf_jit_comp.c                        | 106 +++++++++++++
 include/linux/bpf.h                                |   2 +
 include/linux/bpf_verifier.h                       |   2 +
 include/linux/kasan.h                              |  13 ++
 kernel/bpf/Kconfig                                 |   9 ++
 kernel/bpf/core.c                                  |  10 ++
 kernel/bpf/verifier.c                              |   7 +
 mm/kasan/kasan.h                                   |  10 --
 tools/testing/selftests/bpf/prog_tests/kasan.c     | 165 +++++++++++++++++++++
 tools/testing/selftests/bpf/progs/kasan.c          | 146 ++++++++++++++++++
 .../testing/selftests/bpf/test_kmods/bpf_testmod.c |  79 ++++++++++
 tools/testing/selftests/bpf/test_loader.c          |   5 +
 tools/testing/selftests/bpf/unpriv_helpers.c       |   5 +
 tools/testing/selftests/bpf/unpriv_helpers.h       |   1 +
 15 files changed, 551 insertions(+), 10 deletions(-)
---
base-commit: 7990a071b32887a1a883952e8cf60134b6d6fea0
change-id: 20260126-kasan-fcd68f64cd7b

Best regards,
--  
Alexis Lothoré (eBPF Foundation) <alexis.lothore@bootlin.com>


