Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BCB3C531C7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 10:26:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 593246B0088; Thu, 23 Jul 2026 06:26:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 543896B008A; Thu, 23 Jul 2026 06:26:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36FDA6B008C; Thu, 23 Jul 2026 06:26:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E6DC26B0088
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 06:26:04 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3F5C912042E
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 10:26:04 +0000 (UTC)
X-FDA: 85019661048.03.648DE8F
Received: from mout.web.de (mout.web.de [217.72.192.78])
	by imf16.hostedemail.com (Postfix) with ESMTP id D34DC180006
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 10:26:01 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=pzTE6pTg;
	spf=pass (imf16.hostedemail.com: domain of Markus.Elfring@web.de designates 217.72.192.78 as permitted sender) smtp.mailfrom=Markus.Elfring@web.de;
	dmarc=pass (policy=quarantine) header.from=web.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784802362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ET0AwCFbueyIrbxwEwyenRyXyFcvsqwk26HKdPa/aR0=;
	b=PiBiI35KCJNgzrD007wWEUHHAp3X61b+pQtCMmvMLdKO5dIl3xWKLa6ECWI76lvs2HU8aw
	eEdp0OYPsVthReitMCI15yZRnhfF+1oeWgIrhsNuBvQ/tmwrlaHqwLIQBS49tmGFoaqiYB
	Q7Nwd2oO/PLMPjrR4v+8V2rIfCYZSxY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=pzTE6pTg;
	spf=pass (imf16.hostedemail.com: domain of Markus.Elfring@web.de designates 217.72.192.78 as permitted sender) smtp.mailfrom=Markus.Elfring@web.de;
	dmarc=pass (policy=quarantine) header.from=web.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784802362;
	b=n9qf2RHco8qGkqS98SyaMqx8/ILHJ4RAdBn0wNy1/NjtK0p5dyjkSa1/QlucsVjvF584Vk
	g5vm7M58+sV7X28abNbaz+Yr5mqmdN7qJPwB2kpbktFzu9//NDB7aUERnyzfZjTPuRh4HQ
	1Bcg5Nd3JqPLBr1GajaDNj6sS6ae5VA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1784802338; x=1785407138; i=markus.elfring@web.de;
	bh=ET0AwCFbueyIrbxwEwyenRyXyFcvsqwk26HKdPa/aR0=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Cc:From:Subject:
	 To:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=pzTE6pTgQl3hCzS4TVSqDVce4csMOqT03Ok+uS2PfBSujwVbv+IcAOdhGOF1SoEn
	 0VXwkww7ZRfs4O7V2g2TYwHFGl9UQw/2S6Bho2xgEwN9EbdbMJe7gtWzl3ZQY6ePk
	 HUI2l0Oa5H13+/JO1zrZALLDoebVbMzbYOUlDpEgRWLe46Vq8/164KFdkBvqxIk3W
	 Li7MohyY21hf18b/alcst9jboWxhsZs+UbWksAHfK11kT3/ZTeB8YDA+ciirpNFRx
	 D+qsxi+6yCWFzcQfIDUhezqfhM+Xx9igXVUxToScM2h1ANy4u2sXSojfeFtiuG1r4
	 dXD92AegwFQslSH+qQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MQPdr-1wZK791RKL-00XnHW; Thu, 23
 Jul 2026 12:25:38 +0200
Message-ID: <48f2d61f-d468-49b7-881e-f00777db073f@web.de>
Date: Thu, 23 Jul 2026 12:25:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-GB, de-DE
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] tools: Use fputc() calls in some functions
To: acpica-devel@lists.linux.dev, bpf@vger.kernel.org,
 coresight@lists.linaro.org, kvm@vger.kernel.org, linux-acpi@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-perf-users@vger.kernel.org, linux-pm@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 mptcp@lists.linux.dev, netdev@vger.kernel.org,
 platform-driver-x86@vger.kernel.org, virtualization@lists.linux.dev,
 Adrian Hunter <adrian.hunter@intel.com>, Alex Mastro <amastro@fb.com>,
 Alex Williamson <alex@shazbot.org>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Alexei Starovoitov <ast@kernel.org>, Andi Kleen <ak@linux.intel.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>,
 Andrew Morton <akpm@linux-foundation.org>,
 Andrii Nakryiko <andrii@kernel.org>, Ankur Arora <ankur.a.arora@oracle.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Bartosz Golaszewski <brgl@kernel.org>,
 Bobby Eshleman <bobbyeshleman@meta.com>,
 =?UTF-8?Q?Christian_Borntr=C3=A4ger?= <borntraeger@linux.ibm.com>,
 Christophe Leroy <chleroy@kernel.org>, Chun-Tse Shao <ctshao@google.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Costa Shulyupin <costa.shul@redhat.com>, Crystal Wood <crwood@redhat.com>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Daniel Lezcano <daniel.lezcano@kernel.org>,
 David Hildenbrand <david@kernel.org>, David Matlack <dmatlack@google.com>,
 "David S. Miller" <davem@davemloft.net>,
 Donald Hunter <donald.hunter@gmail.com>, Eduard Zingerman
 <eddyz87@gmail.com>, Emil Tsalapatis <emil@etsalapatis.com>,
 Eric Dumazet <edumazet@google.com>, Gabriele Monaco <gmonaco@redhat.com>,
 Geliang Tang <geliang@kernel.org>, Ian Rogers <irogers@google.com>,
 Ingo Molnar <mingo@redhat.com>, Ivan Pravdin <ipravdin.official@gmail.com>,
 Jakub Kicinski <kuba@kernel.org>, James Clark <james.clark@linaro.org>,
 Janosch Frank <frankja@linux.ibm.com>, Jason Xing
 <kerneljasonxing@gmail.com>, Jiri Olsa <jolsa@kernel.org>,
 Joe Damato <joe@dama.to>, John Garry <john.g.garry@oracle.com>,
 Josh Poimboeuf <jpoimboe@kernel.org>,
 Kaushlendra Kumar <kaushlendra.kumar@intel.com>,
 Kent Gibson <warthog618@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Len Brown <lenb@kernel.org>,
 Leo Yan <leo.yan@linux.dev>, Lukasz Luba <lukasz.luba@arm.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Mark Rutland <mark.rutland@arm.com>, Martin KaFai Lau
 <martin.lau@linux.dev>, Masami Hiramatsu <mhiramat@kernel.org>,
 Mat Martineau <martineau@kernel.org>, Matthieu Baerts <matttbe@kernel.org>,
 Michael Ellerman <mpe@ellerman.id.au>, Mike Leach <mike.leach@arm.com>,
 Mina Almasry <almasrymina@google.com>, Mykyta Yatsenko <yatsenko@meta.com>,
 Nam Cao <namcao@linutronix.de>, Namhyung Kim <namhyung@kernel.org>,
 Nicholas Piggin <npiggin@gmail.com>, Paolo Abeni <pabeni@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Pawel Chmielewski <pawel.chmielewski@intel.com>,
 Peter Zijlstra <peterz@infradead.org>, Quentin Monnet <qmo@kernel.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Raghavendra Rao Ananta <rananta@google.com>,
 Saket Dumbre <saket.dumbre@intel.com>, Shuah Khan <shuah@kernel.org>,
 Simon Horman <horms@kernel.org>, Song Liu <song@kernel.org>,
 Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
 Stanislav Fomichev <sdf@fomichev.me>,
 Stefano Garzarella <sgarzare@redhat.com>,
 Steven Rostedt <rostedt@goodmis.org>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Swapnil Sapkal <swapnil.sapkal@amd.com>,
 =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>,
 Tomas Glozar <tglozar@redhat.com>, Vipin Sharma <vipinsh@google.com>,
 Wander Lairson Costa <wander@redhat.com>, Will Deacon <will@kernel.org>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>, Willy Tarreau
 <w@1wt.eu>, Yonghong Song <yonghong.song@linux.dev>,
 Zhang Chujun <zhangchujun@cmss.chinamobile.com>,
 Zhang Rui <rui.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:oE8+mhZLuuzPoVJveX8dSfMkqZ93/zc2FhN7LFb/WMxxY+dB4Es
 JaCb3i9i/BSjlGWfdbgCSfbEQNg2sbCVc92d24AbT2dWephWnWBsG7pSsstJDKm6DVf+bP0
 en2uHvC2gbKpdwda7vnUTLbJOQn6OhyBHUiC616utqSRP2VXQYaMWzz7H0MGYhCoUCxsona
 O2fmE39On4igp2bhYFboQ==
UI-OutboundReport: notjunk:1;M01:P0:Fh109ZqTVW4=;hGHBZ9krLx9F0kqbNfURx2t5yL6
 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
 yNIZaYTUcpAR9q+hOhSRI
X-Rspam-User: 
X-Rspamd-Queue-Id: D34DC180006
X-Rspamd-Server: rspam01
X-Stat-Signature: 9b5imphnpyw9fmkxqauifn1zs71gpm5g
X-HE-Tag: 1784802361-436468
X-HE-Meta: U2FsdGVkX1/VORYZlab61xZNkU2ZVCdv3wfSoYOI7L0sKDYr1SV7qpQmfUiJZyQSpNm8nRwZBlYu08GgnMGW5f3u01R4W4nWR3E+yQac/t1QudvOMqAuGoEB46NdSTQL+Xwp7A9g/SB7oApUXY6hX6GLQvjkrUNV9ZTYplbuyZY5gAHWyAnDtvpzXoavk0KK50HRExt8MBI9oS2UZRIfbCJsJzVFkZOUgfQIdv+iqexclbBBuwsgIqzWgbe940TyCEDYO5JG5YDpE8jLBEXQjBnjDNjdbo5Wx9fwNkinmTE/fVM5kDvwk0urAO5ejIlTrhJ7sTG62Hu3TQYCywA8OoDso3jYIUJSj3SdvvGysUn0VqPnhwQC4qCT7jBTEuvzywcmJ9mF8CuJOqArfsSWPryPhIaPt47AUwt5SLUd2PeWTOvVhcn2lT8Zr6JDT0eeuzyvxLTCUWpb7noMHUeaktwN9ijDaWasNgdGisNUkaCz3SalTolUNPJhSpxU6LeKTUykiXsnjtaRH1s/Gi6MHEKiZ6lherDexD9p+3gvNE6h/xbW6t5im68UBB2HsUMv+d5S/rSRMLCeeyWS6TFnGROOkVDTBckl73ccM6hBLUQGngdjS7JQ/7Zw+G5RSLD/2An70HyvqWJ8RpsozKOnXOFLSItlr+h18b3S8Ehd06DUFjfLTTBS4bS/qwQj9/3lXWlDkvDsDWpuTQ4Z2kz+327FzYCH8L3/B1dS3nMNEztWa65oxPxIHqQX2HnPyqtOV7XWXpiyGCWMJqIwopgZlOhGUODaHFQ4BNLFFqABSV62vr0QNYKCbzH0FgDYGjSuSONydONN7N/o9CyjRF/baiv/OnJchfP83ggAl06NDvtBlTc6Nvf1gvcVPY9VixLUH5bC5W9/7XpbSuoiHXAdsldV+Lm1ldeejclFbKWL4ogRrRKPpdoVjrsud0M6G4xgBKjQwBCXd5DYAEKYoyx
 dmUM6pgU
 r7lTkDiP06RnK8mpoErgGDxJuID2taMzZN4Kgy8fkSTSzciFCD0f6ecy/8m22wMeN5SXw0NQvc9NN0XRerMnVAip7mcCV2Q7ISCStdYdZRTWGxl1REuZAAzxh/4VC+5CvVzEJHYPNS6NjyLJVHsgwu8xEb6zCz1tU7JlsX1E5dMkvSQJ141Q6SgL6DNNdiM9LTrupvFzRfg1Gqw/72f8LSqCc3Y8+2kF1NsMn9iQsBXfQkhkf652mooZ0PFzYpWdj9K1A1v0M9OQInRjPwH3KChngyHoyXgQMrWJDvmASPhj2Z9ngyLIYSfjA6Y/LZwxug1rYqjLVtWY9SRvmsH0iIvQAwW3Rwe36D/5bK9NgXsWv0M3kA9x9kfI2HEnN6H5shdTSRH0TOPfpqkbx7yWnttw3NNoEVdVIoPjH3YYMkBj7rYcc4hWPO/ZPDdBwn0MYbVbq3WAzY1gCvLL1NCZxli75l8DmQK2C/BWL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 23 Jul 2026 11:13:30 +0200
Subject: [PATCH] tools: Use fputc() calls in some functions
MIME-Version: 1.0
Content-Type: text/plain; charset=3DUTF-8
Content-Transfer-Encoding: 8bit

Single characters should occasionally be transferred into the output.
Thus use the corresponding function =E2=80=9Cfputc=E2=80=9D (or even =E2=
=80=9Cputchar=E2=80=9D).

The source code was transformed by using the Coccinelle software.

See also:
Improving output for single characters (with SmPL)?
https://lore.kernel.org/kernel-janitors/202dfb21-f5a2-4550-8a1f-aa07d84db3=
45@web.de/

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 tools/bpf/bpftool/common.c                         |  4 ++--
 tools/bpf/bpftool/main.c                           |  2 +-
 tools/bpf/bpftool/netlink_dumper.h                 |  6 +++---
 tools/bpf/bpftool/prog.c                           |  2 +-
 tools/gpio/gpio-event-mon.c                        |  2 +-
 tools/gpio/gpio-hammer.c                           |  4 ++--
 tools/gpio/lsgpio.c                                |  4 ++--
 tools/include/nolibc/err.h                         |  2 +-
 tools/mm/page_owner_sort.c                         |  2 +-
 tools/net/ynl/ynltool/main.c                       |  4 ++--
 tools/objtool/builtin-check.c                      |  2 +-
 tools/objtool/disas.c                              |  2 +-
 tools/perf/builtin-c2c.c                           | 10 +++++-----
 tools/perf/builtin-daemon.c                        |  4 ++--
 tools/perf/builtin-lock.c                          | 14 +++++++-------
 tools/perf/builtin-script.c                        |  8 ++++----
 tools/perf/ui/gtk/util.c                           |  6 +++---
 tools/perf/ui/stdio/hist.c                         |  8 ++++----
 tools/perf/util/cs-etm.c                           |  2 +-
 tools/perf/util/debug.c                            |  2 +-
 tools/perf/util/header.c                           |  6 +++---
 tools/perf/util/intel-pt-decoder/intel-pt-log.c    |  8 ++++----
 tools/perf/util/libbfd.c                           |  2 +-
 tools/perf/util/session.c                          |  4 ++--
 tools/perf/util/stat-display.c                     | 12 ++++++------
 tools/perf/util/values.c                           |  4 ++--
 tools/power/acpi/tools/acpidump/apdump.c           |  2 +-
 tools/power/x86/intel-speed-select/isst-display.c  |  6 +++---
 tools/power/x86/turbostat/turbostat.c              |  4 ++--
 .../testing/selftests/bpf/benchs/bench_htab_mem.c  |  2 +-
 tools/testing/selftests/bpf/jit_disasm_helpers.c   |  2 +-
 tools/testing/selftests/bpf/test_progs.c           | 12 ++++++------
 tools/testing/selftests/bpf/veristat.c             |  2 +-
 tools/testing/selftests/drivers/net/hw/ncdevmem.c  |  2 +-
 tools/testing/selftests/kvm/s390/keyop.c           |  2 +-
 tools/testing/selftests/net/mptcp/pm_nl_ctl.c      |  2 +-
 tools/testing/selftests/net/psock_tpacket.c        |  4 ++--
 tools/testing/selftests/net/txtimestamp.c          | 10 +++++-----
 .../testing/selftests/powerpc/nx-gzip/gunz_test.c  |  2 +-
 .../selftests/vfio/lib/include/libvfio/assert.h    |  2 +-
 tools/testing/selftests/vfio/lib/libvfio.c         | 10 +++++-----
 tools/testing/vsock/vsock_diag_test.c              |  4 ++--
 tools/thermal/tmon/sysfs.c                         |  2 +-
 tools/thermal/tmon/tmon.c                          |  2 +-
 tools/tracing/latency/latency-collector.c          |  2 +-
 tools/tracing/rtla/src/common.c                    |  2 +-
 tools/tracing/rtla/src/utils.c                     |  2 +-
 tools/usb/ffs-test.c                               |  2 +-
 tools/verification/rv/src/in_kernel.c              |  2 +-
 49 files changed, 104 insertions(+), 104 deletions(-)

diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
index ef366ccc9650..3133058cfe40 100644
=2D-- a/tools/bpf/bpftool/common.c
+++ b/tools/bpf/bpftool/common.c
@@ -53,7 +53,7 @@ void p_err(const char *fmt, ...)
 	} else {
 		fprintf(stderr, "Error: ");
 		vfprintf(stderr, fmt, ap);
-		fprintf(stderr, "\n");
+		fputc(stderr, '\n');
 	}
 	va_end(ap);
 }
@@ -67,7 +67,7 @@ void p_info(const char *fmt, ...)
=20
 	va_start(ap, fmt);
 	vfprintf(stderr, fmt, ap);
-	fprintf(stderr, "\n");
+	fputc(stderr, '\n');
 	va_end(ap);
 }
=20
diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index c91e1a6e1a1e..aecfc778625f 100644
=2D-- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -273,7 +273,7 @@ void fprint_hex(FILE *f, void *arg, unsigned int n, co=
nst char *sep)
 		if (!i)
 			/* nothing */;
 		else if (!(i % 16))
-			fprintf(f, "\n");
+			fputc(f, '\n');
 		else if (!(i % 8))
 			fprintf(f, "  ");
 		else
diff --git a/tools/bpf/bpftool/netlink_dumper.h b/tools/bpf/bpftool/netlin=
k_dumper.h
index 96318106fb49..bf0919b4f52a 100644
=2D-- a/tools/bpf/bpftool/netlink_dumper.h
+++ b/tools/bpf/bpftool/netlink_dumper.h
@@ -25,7 +25,7 @@
 	if (json_output)				\
 		jsonw_start_object(json_wtr);		\
 	else						\
-		fprintf(stdout, "{");			\
+		putchar('{');				\
 }
=20
 #define NET_END_OBJECT_NESTED				\
@@ -33,7 +33,7 @@
 	if (json_output)				\
 		jsonw_end_object(json_wtr);		\
 	else						\
-		fprintf(stdout, "}");			\
+		putchar('}');				\
 }
=20
 #define NET_END_OBJECT					\
@@ -47,7 +47,7 @@
 	if (json_output)				\
 		jsonw_end_object(json_wtr);		\
 	else						\
-		fprintf(stdout, "\n");			\
+		putchar('\n');				\
 }
=20
 #define NET_START_ARRAY(name, fmt_str)			\
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index a9f730d407a9..d27cb9d49860 100644
=2D-- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -1266,7 +1266,7 @@ static void hex_print(void *data, unsigned int size,=
 FILE *f)
 			fprintf(f, "%c%s", c, j =3D=3D i + 7 ? " " : "");
 		}
=20
-		fprintf(f, "\n");
+		fputc(f, '\n');
 	}
 }
=20
diff --git a/tools/gpio/gpio-event-mon.c b/tools/gpio/gpio-event-mon.c
index b70813b0bf8e..e12e14780c0e 100644
=2D-- a/tools/gpio/gpio-event-mon.c
+++ b/tools/gpio/gpio-event-mon.c
@@ -121,7 +121,7 @@ int monitor_device(const char *device_name,
 		default:
 			fprintf(stdout, "unknown event");
 		}
-		fprintf(stdout, "\n");
+		putchar('\n');
=20
 		i++;
 		if (i =3D=3D loops)
diff --git a/tools/gpio/gpio-hammer.c b/tools/gpio/gpio-hammer.c
index ba0866eb3581..b76c94fee04d 100644
=2D-- a/tools/gpio/gpio-hammer.c
+++ b/tools/gpio/gpio-hammer.c
@@ -87,7 +87,7 @@ int hammer_device(const char *device_name, unsigned int =
*lines, int num_lines,
 		if (j =3D=3D sizeof(swirr) - 1)
 			j =3D 0;
=20
-		fprintf(stdout, "[");
+		putchar('[');
 		for (i =3D 0; i < num_lines; i++) {
 			fprintf(stdout, "%u: %d", lines[i],
 				gpiotools_test_bit(values.bits, i));
@@ -101,7 +101,7 @@ int hammer_device(const char *device_name, unsigned in=
t *lines, int num_lines,
 		if (loops && iteration =3D=3D loops)
 			break;
 	}
-	fprintf(stdout, "\n");
+	putchar('\n');
 	ret =3D 0;
=20
 exit_close_error:
diff --git a/tools/gpio/lsgpio.c b/tools/gpio/lsgpio.c
index 52a0be45410c..abb2c6fbc3d7 100644
=2D-- a/tools/gpio/lsgpio.c
+++ b/tools/gpio/lsgpio.c
@@ -152,9 +152,9 @@ int list_device(const char *device_name)
 		if (linfo.flags) {
 			fprintf(stdout, " [");
 			print_attributes(&linfo);
-			fprintf(stdout, "]");
+			putchar(']');
 		}
-		fprintf(stdout, "\n");
+		putchar('\n');
=20
 	}
=20
diff --git a/tools/include/nolibc/err.h b/tools/include/nolibc/err.h
index e22ae87a7289..89c9a3d3bc77 100644
=2D-- a/tools/include/nolibc/err.h
+++ b/tools/include/nolibc/err.h
@@ -27,7 +27,7 @@ void vwarnx(const char *fmt, va_list args)
 {
 	fprintf(stderr, "%s: ", program_invocation_short_name);
 	vfprintf(stderr, fmt, args);
-	fprintf(stderr, "\n");
+	fputc(stderr, '\n');
 }
=20
 static __attribute__((unused))
diff --git a/tools/mm/page_owner_sort.c b/tools/mm/page_owner_sort.c
index 35d3d254941c..0293a838211e 100644
=2D-- a/tools/mm/page_owner_sort.c
+++ b/tools/mm/page_owner_sort.c
@@ -917,7 +917,7 @@ int main(int argc, char **argv)
 			}
 			if (cull & CULL_STACKTRACE)
 				fprintf(fout, ":\n%s", list[i].stacktrace);
-			fprintf(fout, "\n");
+			fputc(fout, '\n');
 		}
 	}
=20
diff --git a/tools/net/ynl/ynltool/main.c b/tools/net/ynl/ynltool/main.c
index 5d0f428eed0a..245d7f58c8fb 100644
=2D-- a/tools/net/ynl/ynltool/main.c
+++ b/tools/net/ynl/ynltool/main.c
@@ -156,7 +156,7 @@ void p_err(const char *fmt, ...)
 	} else {
 		fprintf(stderr, "Error: ");
 		vfprintf(stderr, fmt, ap);
-		fprintf(stderr, "\n");
+		fputc(stderr, '\n');
 	}
 	va_end(ap);
 }
@@ -170,7 +170,7 @@ void p_info(const char *fmt, ...)
=20
 	va_start(ap, fmt);
 	vfprintf(stderr, fmt, ap);
-	fprintf(stderr, "\n");
+	fputc(stderr, '\n');
 	va_end(ap);
 }
=20
diff --git a/tools/objtool/builtin-check.c b/tools/objtool/builtin-check.c
index 118c3de2f293..b6d27d326b8a 100644
=2D-- a/tools/objtool/builtin-check.c
+++ b/tools/objtool/builtin-check.c
@@ -297,7 +297,7 @@ int make_backup(void)
 			fprintf(stderr, " %s", arg);
 	}
=20
-	fprintf(stderr, "\n");
+	fputc(stderr, '\n');
 	return 0;
 }
=20
diff --git a/tools/objtool/disas.c b/tools/objtool/disas.c
index e6a54a83605c..339d1d5690c4 100644
=2D-- a/tools/objtool/disas.c
+++ b/tools/objtool/disas.c
@@ -537,7 +537,7 @@ void disas_print_insn(FILE *stream, struct disas_conte=
xt *dctx,
 		return;
=20
 	if (strcmp(format, "\n") =3D=3D 0) {
-		fprintf(stream, "\n");
+		fputc(stream, '\n');
 		return;
 	}
=20
diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
index c9584dbedf77..fc9b6b18eded 100644
=2D-- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -2511,7 +2511,7 @@ static void print_cacheline(struct c2c_hists *c2c_hi=
sts,
 		hists__fprintf_headers(&c2c_hists->hists, out);
 		once =3D true;
 	} else {
-		fprintf(out, "\n");
+		fputc(out, '\n');
 	}
=20
 	fprintf(out, "  --------------------------------------------------------=
=2D-------------\n");
@@ -2590,15 +2590,15 @@ static void perf_c2c__hists_fprintf(FILE *out, str=
uct perf_session *session)
 	setup_pager();
=20
 	print_c2c__display_stats(out);
-	fprintf(out, "\n");
+	fputc(out, '\n');
 	print_shared_cacheline_info(out);
-	fprintf(out, "\n");
+	fputc(out, '\n');
 	print_c2c_info(out, session);
=20
 	if (c2c.stats_only)
 		return;
=20
-	fprintf(out, "\n");
+	fputc(out, '\n');
 	fprintf(out, "=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D\n");
 	fprintf(out, "           Shared Data Cache Line Table          \n");
 	fprintf(out, "=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D\n");
@@ -2606,7 +2606,7 @@ static void perf_c2c__hists_fprintf(FILE *out, struc=
t perf_session *session)
=20
 	hists__fprintf(&c2c.hists.hists, true, 0, 0, 0, stdout, true);
=20
-	fprintf(out, "\n");
+	fputc(out, '\n');
 	fprintf(out, "=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D\n");
 	fprintf(out, "      Shared Cache Line Distribution Pareto      \n");
 	fprintf(out, "=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D\n");
diff --git a/tools/perf/builtin-daemon.c b/tools/perf/builtin-daemon.c
index c4632577d129..7cb20b3a03e4 100644
=2D-- a/tools/perf/builtin-daemon.c
+++ b/tools/perf/builtin-daemon.c
@@ -691,7 +691,7 @@ static int cmd_session_list(struct daemon *daemon, uni=
on cmd *cmd, FILE *out)
 			/* session up time */
 			csv_sep, (uint64_t)((curr - daemon->start) / 60));
=20
-		fprintf(out, "\n");
+		fputc(out, '\n');
 	} else {
 		fprintf(out, "[%d:daemon] base: %s\n", getpid(), daemon->base);
 		if (cmd->list.verbose) {
@@ -730,7 +730,7 @@ static int cmd_session_list(struct daemon *daemon, uni=
on cmd *cmd, FILE *out)
 				/* session up time */
 				csv_sep, (uint64_t)((curr - session->start) / 60));
=20
-			fprintf(out, "\n");
+			fputc(out, '\n');
 		} else {
 			fprintf(out, "[%d:%s] perf record %s\n",
 				session->pid, session->name, session->run);
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index d5c0d55cb82d..3706aff25883 100644
=2D-- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -1319,9 +1319,9 @@ static void print_result(void)
=20
 		list_for_each_entry(key, &lock_keys, list) {
 			key->print(key, st);
-			fprintf(lock_output, " ");
+			fputc(lock_output, ' ');
 		}
-		fprintf(lock_output, "\n");
+		fputc(lock_output, '\n');
=20
 		if (++printed >=3D print_nr_entries)
 			break;
@@ -1598,7 +1598,7 @@ static void print_header_csv(const char *sep)
 		fprintf(lock_output, "%s%s %s", "type", sep, "caller");
 		if (verbose > 0)
 			fprintf(lock_output, "%s %s", sep, "stacktrace");
-		fprintf(lock_output, "\n");
+		fputc(lock_output, '\n');
 		break;
 	case LOCK_AGGR_ADDR:
 		fprintf(lock_output, "%s%s %s%s %s\n", "address", sep, "symbol", sep, "=
type");
@@ -1629,7 +1629,7 @@ static void print_lock_stat_stdio(struct lock_conten=
tion *con, struct lock_stat
=20
 	list_for_each_entry(key, &lock_keys, list) {
 		key->print(key, st);
-		fprintf(lock_output, " ");
+		fputc(lock_output, ' ');
 	}
=20
 	switch (aggr_mode) {
@@ -1687,7 +1687,7 @@ static void print_lock_stat_csv(struct lock_contenti=
on *con, struct lock_stat *s
 	case LOCK_AGGR_CALLER:
 		fprintf(lock_output, "%s%s %s", get_type_flags_name(st->flags), sep, st=
->name);
 		if (verbose <=3D 0)
-			fprintf(lock_output, "\n");
+			fputc(lock_output, '\n');
 		break;
 	case LOCK_AGGR_TASK:
 		pid =3D st->addr;
@@ -1721,7 +1721,7 @@ static void print_lock_stat_csv(struct lock_contenti=
on *con, struct lock_stat *s
 			get_symbol_name_offset(kmap, sym, ip, buf, sizeof(buf));
 			fprintf(lock_output, "%s %#lx %s", i ? ":" : sep, (unsigned long) ip, =
buf);
 		}
-		fprintf(lock_output, "\n");
+		fputc(lock_output, '\n');
 	}
 }
=20
@@ -1781,7 +1781,7 @@ static void print_footer_csv(int total, int bad, str=
uct lock_contention_fails *f
 		for (i =3D 0; i < BROKEN_MAX; i++)
 			fprintf(lock_output, "%s bad_%s=3D%d", sep, name[i], bad_hist[i]);
 	}
-	fprintf(lock_output, "\n");
+	fputc(lock_output, '\n');
 }
=20
 static void print_footer(int total, int bad, struct lock_contention_fails=
 *fails)
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index f91d8b1fbd01..2b202018ba59 100644
=2D-- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -2563,7 +2563,7 @@ static void process_event(struct perf_script *script=
,
=20
 	perf_sample__fprintf_ipc(sample, evsel, fp);
=20
-	fprintf(fp, "\n");
+	fputc(fp, '\n');
=20
 	if (PRINT_FIELD(SRCCODE)) {
 		if (map__fprintf_srccode(al->map, al->addr, stdout,
@@ -2817,7 +2817,7 @@ static int process_deferred_sample_event(const struc=
t perf_tool *tool,
 				    cursor, symbol_conf.bt_stop_list, fp);
 	}
=20
-	fprintf(fp, "\n");
+	fputc(fp, '\n');
=20
 	if (verbose > 0)
 		fflush(fp);
@@ -3273,11 +3273,11 @@ static int list_available_languages_cb(struct scri=
pting_ops *ops, const char *sp
=20
 static void list_available_languages(void)
 {
-	fprintf(stderr, "\n");
+	fputc(stderr, '\n');
 	fprintf(stderr, "Scripting language extensions (used in "
 		"perf script -s [spec:]script.[spec]):\n\n");
 	script_spec__for_each(&list_available_languages_cb);
-	fprintf(stderr, "\n");
+	fputc(stderr, '\n');
 }
=20
 /* Find script file relative to current directory or exec path */
diff --git a/tools/perf/ui/gtk/util.c b/tools/perf/ui/gtk/util.c
index c47f5c387838..037ebc47f7dc 100644
=2D-- a/tools/perf/ui/gtk/util.c
+++ b/tools/perf/ui/gtk/util.c
@@ -37,7 +37,7 @@ static int perf_gtk__error(const char *format, va_list a=
rgs)
 	    vasprintf(&msg, format, args) < 0) {
 		fprintf(stderr, "Error:\n");
 		vfprintf(stderr, format, args);
-		fprintf(stderr, "\n");
+		fputc(stderr, '\n');
 		return -1;
 	}
=20
@@ -62,7 +62,7 @@ static int perf_gtk__warning_info_bar(const char *format=
, va_list args)
 	    vasprintf(&msg, format, args) < 0) {
 		fprintf(stderr, "Warning:\n");
 		vfprintf(stderr, format, args);
-		fprintf(stderr, "\n");
+		fputc(stderr, '\n');
 		return -1;
 	}
=20
@@ -83,7 +83,7 @@ static int perf_gtk__warning_statusbar(const char *forma=
t, va_list args)
 	    vasprintf(&msg, format, args) < 0) {
 		fprintf(stderr, "Warning:\n");
 		vfprintf(stderr, format, args);
-		fprintf(stderr, "\n");
+		fputc(stderr, '\n');
 		return -1;
 	}
=20
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index 8c4c8925df2c..044d2aa3b312 100644
=2D-- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -691,7 +691,7 @@ static int hists__fprintf_hierarchy_headers(struct his=
ts *hists,
 		}
=20
 next_line:
-		fprintf(fp, "\n");
+		fputc(fp, '\n');
 	}
=20
 	fprintf(fp, "# ");
@@ -783,7 +783,7 @@ hists__fprintf_standard_headers(struct hists *hists,
 		if (line)
 			fprintf(fp, "# ");
 		fprintf_line(hists, hpp, line, fp);
-		fprintf(fp, "\n");
+		fputc(fp, '\n');
 	}
=20
 	if (sep)
@@ -806,10 +806,10 @@ hists__fprintf_standard_headers(struct hists *hists,
=20
 		width =3D fmt->width(fmt, hpp, hists);
 		for (i =3D 0; i < width; i++)
-			fprintf(fp, ".");
+			fputc(fp, '.');
 	}
=20
-	fprintf(fp, "\n");
+	fputc(fp, '\n');
 	fprintf(fp, "#\n");
 	return hpp_list->nr_header_lines + 2;
 }
diff --git a/tools/perf/util/cs-etm.c b/tools/perf/util/cs-etm.c
index 95e3ec1171ac..d4534b489252 100644
=2D-- a/tools/perf/util/cs-etm.c
+++ b/tools/perf/util/cs-etm.c
@@ -912,7 +912,7 @@ static void cs_etm__dump_event(struct cs_etm_queue *et=
mq,
 	const char *color =3D PERF_COLOR_BLUE;
 	size_t buffer_used =3D 0;
=20
-	fprintf(stdout, "\n");
+	putchar('\n');
 	color_fprintf(stdout, color,
 		     ". ... CoreSight %s Trace data: size %#zx bytes\n",
 		     cs_etm_decoder__get_name(etmq->decoder), buffer->size);
diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index 6b5ffe81f141..5429984ab49c 100644
=2D-- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -350,7 +350,7 @@ void __dump_stack(FILE *file, void **stackdump, size_t=
 stackdump_size)
 			fprintf(file, "    #%zd %p ", i, stackdump[i]);
=20
 		map__fprintf_srcline(al.map, al.addr, "", file);
-		fprintf(file, "\n");
+		fputc(file, '\n');
 		addr_location__exit(&al);
 	}
 	thread__put(thread);
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index e90e541f546b..e3a2a6e52ef0 100644
=2D-- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2454,7 +2454,7 @@ static void __print_pmu_caps(FILE *fp, int nr_caps, =
char **caps, char *pmu_name)
 		delimiter =3D ", ";
 	}
=20
-	fprintf(fp, "\n");
+	fputc(fp, '\n');
 }
=20
 static void print_cpu_pmu_caps(struct feat_fd *ff, FILE *fp)
@@ -2513,7 +2513,7 @@ static void print_pmu_mappings(struct feat_fd *ff, F=
ILE *fp)
 		pmu_num--;
 	}
=20
-	fprintf(fp, "\n");
+	fputc(fp, '\n');
=20
 	if (!pmu_num)
 		return;
@@ -4349,7 +4349,7 @@ int perf_header__fprintf_info(struct perf_session *s=
ession, FILE *fp, bool full)
 			fprintf(fp, "%s ", feat_ops[bit].name);
 	}
=20
-	fprintf(fp, "\n");
+	fputc(fp, '\n');
 	return 0;
 }
=20
diff --git a/tools/perf/util/intel-pt-decoder/intel-pt-log.c b/tools/perf/=
util/intel-pt-decoder/intel-pt-log.c
index ef55d6232cf0..0a35493b854a 100644
=2D-- a/tools/perf/util/intel-pt-decoder/intel-pt-log.c
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-log.c
@@ -70,14 +70,14 @@ static void intel_pt_print_data(const unsigned char *b=
uf, int len, uint64_t pos,
 	int i;
=20
 	for (i =3D 0; i < indent; i++)
-		fprintf(f, " ");
+		fputc(f, ' ');
=20
 	fprintf(f, "  %08" PRIx64 ": ", pos);
 	for (i =3D 0; i < len; i++)
 		fprintf(f, " %02x", buf[i]);
 	for (; i < 16; i++)
 		fprintf(f, "   ");
-	fprintf(f, " ");
+	fputc(f, ' ');
 }
=20
 static void intel_pt_print_no_data(uint64_t pos, int indent)
@@ -85,12 +85,12 @@ static void intel_pt_print_no_data(uint64_t pos, int i=
ndent)
 	int i;
=20
 	for (i =3D 0; i < indent; i++)
-		fprintf(f, " ");
+		fputc(f, ' ');
=20
 	fprintf(f, "  %08" PRIx64 ": ", pos);
 	for (i =3D 0; i < 16; i++)
 		fprintf(f, "   ");
-	fprintf(f, " ");
+	fputc(f, ' ');
 }
=20
 static ssize_t log_buf__write(void *cookie, const char *buf, size_t size)
diff --git a/tools/perf/util/libbfd.c b/tools/perf/util/libbfd.c
index d8241c7caac5..efbfdad8b330 100644
=2D-- a/tools/perf/util/libbfd.c
+++ b/tools/perf/util/libbfd.c
@@ -603,7 +603,7 @@ int symbol__disassemble_bpf_libbfd(struct symbol *sym =
__maybe_unused,
 		} else
 			srcline =3D NULL;
=20
-		fprintf(s, "\n");
+		fputc(s, '\n');
 		prev_buf_size =3D buf_size;
 		fflush(s);
=20
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 3237870a1a34..ef2b3226187c 100644
=2D-- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1257,7 +1257,7 @@ int perf_event__process_finished_round(const struct =
perf_tool *tool __maybe_unus
 				       struct ordered_events *oe)
 {
 	if (dump_trace)
-		fprintf(stdout, "\n");
+		putchar('\n');
 	return ordered_events__flush(oe, OE_FLUSH__ROUND);
 }
=20
@@ -4015,7 +4015,7 @@ int perf_event__process_id_index(const struct perf_t=
ool *tool __maybe_unused,
 				fprintf(stdout, "  machine_pid: %"PRI_ld64, e2->machine_pid);
 				fprintf(stdout, "  vcpu: %"PRI_lu64"\n", e2->vcpu);
 			} else {
-				fprintf(stdout, "\n");
+				putchar('\n');
 			}
 		}
=20
diff --git a/tools/perf/util/stat-display.c b/tools/perf/util/stat-display=
.c
index f94f1324d24a..b90e3be95549 100644
=2D-- a/tools/perf/util/stat-display.c
+++ b/tools/perf/util/stat-display.c
@@ -529,7 +529,7 @@ static void print_metric_json(struct perf_stat_config =
*config __maybe_unused,
 		}
 	}
 	if (!config->metric_only)
-		fprintf(out, "}");
+		fputc(out, '}');
 }
=20
 static void new_line_json(struct perf_stat_config *config, void *ctx)
@@ -1316,7 +1316,7 @@ static void print_header_std(struct perf_stat_config=
 *config,
 	FILE *output =3D config->output;
 	int i;
=20
-	fprintf(output, "\n");
+	fputc(output, '\n');
 	fprintf(output, " Performance counter stats for ");
 	if (_target->bpf_str)
 		fprintf(output, "\'BPF program(s) %s", _target->bpf_str);
@@ -1333,7 +1333,7 @@ static void print_header_std(struct perf_stat_config=
 *config,
 	else
 		fprintf(output, "thread id \'%s", _target->tid);
=20
-	fprintf(output, "\'");
+	fputc(output, '\'');
 	if (config->run_count > 1)
 		fprintf(output, " (%d runs)", config->run_count);
 	fprintf(output, ":\n\n");
@@ -1406,9 +1406,9 @@ static void print_table(struct perf_stat_config *con=
fig, FILE *output, double av
 		fprintf(output, " %17.9f (%+.9f) ", run, run - avg);
=20
 		for (h =3D 0; h < n; h++)
-			fprintf(output, "#");
+			fputc(output, '#');
=20
-		fprintf(output, "\n");
+		fputc(output, '\n');
 	}
=20
 	fprintf(output, "\n%*s# Final result:\n", indent, "");
@@ -1428,7 +1428,7 @@ static void print_footer(struct perf_stat_config *co=
nfig)
 		return;
=20
 	if (!config->null_run)
-		fprintf(output, "\n");
+		fputc(output, '\n');
=20
 	if (config->run_count =3D=3D 1) {
 		fprintf(output, " %17.9f seconds time elapsed", avg);
diff --git a/tools/perf/util/values.c b/tools/perf/util/values.c
index 6eaddfcf833e..2c5340a928dd 100644
=2D-- a/tools/perf/util/values.c
+++ b/tools/perf/util/values.c
@@ -217,7 +217,7 @@ static void perf_read_values__display_pretty(FILE *fp,
 	fprintf(fp, "# %*s  %*s", pidwidth, "PID", tidwidth, "TID");
 	for (j =3D 0; j < values->num_counters; j++)
 		fprintf(fp, "  %*s", counterwidth[j], evsel__name(values->counters[j]))=
;
-	fprintf(fp, "\n");
+	fputc(fp, '\n');
=20
 	for (i =3D 0; i < values->threads; i++) {
 		fprintf(fp, "  %*d  %*d", pidwidth, values->pid[i],
@@ -225,7 +225,7 @@ static void perf_read_values__display_pretty(FILE *fp,
 		for (j =3D 0; j < values->num_counters; j++)
 			fprintf(fp, "  %*" PRIu64,
 				counterwidth[j], values->value[i][j]);
-		fprintf(fp, "\n");
+		fputc(fp, '\n');
 	}
 	free(counterwidth);
 }
diff --git a/tools/power/acpi/tools/acpidump/apdump.c b/tools/power/acpi/t=
ools/acpidump/apdump.c
index 72ad7915b04f..600d5b6e04a8 100644
=2D-- a/tools/power/acpi/tools/acpidump/apdump.c
+++ b/tools/power/acpi/tools/acpidump/apdump.c
@@ -171,7 +171,7 @@ ap_dump_table_buffer(struct acpi_table_header *table,
 	acpi_ut_dump_buffer_to_file(gbl_output_file,
 				    ACPI_CAST_PTR(u8, table), table_length,
 				    DB_BYTE_DISPLAY, 0);
-	fprintf(gbl_output_file, "\n");
+	fputc(gbl_output_file, '\n');
 	return (0);
 }
=20
diff --git a/tools/power/x86/intel-speed-select/isst-display.c b/tools/pow=
er/x86/intel-speed-select/isst-display.c
index e4884eb02837..5d492780aad9 100644
=2D-- a/tools/power/x86/intel-speed-select/isst-display.c
+++ b/tools/power/x86/intel-speed-select/isst-display.c
@@ -122,7 +122,7 @@ static void format_and_print(FILE *outf, int level, ch=
ar *header, char *value)
=20
 	if (level =3D=3D 0) {
 		if (header)
-			fprintf(outf, "{");
+			fputc(outf, '{');
 		else
 			fprintf(outf, "\n}\n");
=20
@@ -138,7 +138,7 @@ static void format_and_print(FILE *outf, int level, ch=
ar *header, char *value)
=20
 		if (value) {
 			if (last_level !=3D level)
-				fprintf(outf, "\n");
+				fputc(outf, '\n');
=20
 			fprintf(outf, "%s\"%s\": ", delimiters, header);
 			fprintf(outf, "\"%s\"", value);
@@ -156,7 +156,7 @@ static void format_and_print(FILE *outf, int level, ch=
ar *header, char *value)
 					fprintf(outf, "\n%s}", delimiters);
 			}
 			if (abs(last_level - level) < 3)
-				fprintf(outf, "\n");
+				fputc(outf, '\n');
 			if (header)
 				fprintf(outf, "%s\"%s\": {", delimiters,
 					header);
diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbo=
stat/turbostat.c
index 4ad7cb1df5c5..bfa38199275f 100644
=2D-- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -9022,7 +9022,7 @@ void dump_cpuid_hypervisor(void)
 	dump_word_chars(ebx);
 	dump_word_chars(ecx);
 	dump_word_chars(edx);
-	fprintf(outf, "\n");
+	fputc(outf, '\n');
 }
=20
 void process_cpuid()
@@ -9692,7 +9692,7 @@ void topology_probe(bool startup)
 		fprintf(outf, " siblings");
 		for (ht_id =3D 0; ht_id <=3D MAX_HT_ID; ++ht_id)
 			fprintf(outf, " %d", cpus[i].ht_sibling_cpu_id[ht_id]);
-		fprintf(outf, "\n");
+		fputc(outf, '\n');
 	}
=20
 }
diff --git a/tools/testing/selftests/bpf/benchs/bench_htab_mem.c b/tools/t=
esting/selftests/bpf/benchs/bench_htab_mem.c
index 1ee217d97434..64b97a41af45 100644
=2D-- a/tools/testing/selftests/bpf/benchs/bench_htab_mem.c
+++ b/tools/testing/selftests/bpf/benchs/bench_htab_mem.c
@@ -148,7 +148,7 @@ static const struct htab_mem_use_case *htab_mem_find_u=
se_case_or_exit(const char
 	fprintf(stderr, "available use case:");
 	for (i =3D 0; i < ARRAY_SIZE(use_cases); i++)
 		fprintf(stderr, " %s", use_cases[i].name);
-	fprintf(stderr, "\n");
+	fputc(stderr, '\n');
 	exit(1);
 }
=20
diff --git a/tools/testing/selftests/bpf/jit_disasm_helpers.c b/tools/test=
ing/selftests/bpf/jit_disasm_helpers.c
index 3558fe10e28c..58ea2a2ec13e 100644
=2D-- a/tools/testing/selftests/bpf/jit_disasm_helpers.c
+++ b/tools/testing/selftests/bpf/jit_disasm_helpers.c
@@ -228,7 +228,7 @@ int get_jited_program_text(int fd, char *text, size_t =
text_sz)
 	for (pc =3D 0, i =3D 0; i < jited_funcs; ++i) {
 		fprintf(text_out, "func #%d:\n", i);
 		disasm_one_func(text_out, image + pc, func_lens[i]);
-		fprintf(text_out, "\n");
+		fputc(text_out, '\n');
 		pc +=3D func_lens[i];
 	}
=20
diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/self=
tests/bpf/test_progs.c
index 7ba82974ee78..b520be1bf7aa 100644
=2D-- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -383,7 +383,7 @@ static void print_test_result(const struct prog_test_d=
ef *test, const struct tes
 	else
 		fprintf(env.stdout_saved, "OK (SKIP: %d/%d)", skipped_cnt, subtests_cnt=
);
=20
-	fprintf(env.stdout_saved, "\n");
+	fputc(env.stdout_saved, '\n');
 }
=20
 static void print_test_log(char *log_buf, size_t log_cnt)
@@ -391,7 +391,7 @@ static void print_test_log(char *log_buf, size_t log_c=
nt)
 	log_buf[log_cnt] =3D '\0';
 	fprintf(env.stdout_saved, "%s", log_buf);
 	if (log_buf[log_cnt - 1] !=3D '\n')
-		fprintf(env.stdout_saved, "\n");
+		fputc(env.stdout_saved, '\n');
 }
=20
 static void print_subtest_name(int test_num, int subtest_num,
@@ -409,7 +409,7 @@ static void print_subtest_name(int test_num, int subte=
st_num,
 	if (result)
 		fprintf(env.stdout_saved, ":%s", result);
=20
-	fprintf(env.stdout_saved, "\n");
+	fputc(env.stdout_saved, '\n');
 }
=20
 static void jsonw_write_log_message(json_writer_t *w, char *log_buf, size=
_t log_cnt)
@@ -1333,14 +1333,14 @@ void hexdump(const char *prefix, const void *buf, =
size_t len)
 	for (int i =3D 0; i < len; i++) {
 		if (!(i % 16)) {
 			if (i)
-				fprintf(stdout, "\n");
+				putchar('\n');
 			fprintf(stdout, "%s", prefix);
 		}
 		if (i && !(i % 8) && (i % 16))
-			fprintf(stdout, "\t");
+			putchar('\t');
 		fprintf(stdout, "%02X ", ((uint8_t *)(buf))[i]);
 	}
-	fprintf(stdout, "\n");
+	putchar('\n');
 }
=20
 static void sigint_handler(int signum)
diff --git a/tools/testing/selftests/bpf/veristat.c b/tools/testing/selfte=
sts/bpf/veristat.c
index c9c257784ee3..61ea29bb35d7 100644
=2D-- a/tools/testing/selftests/bpf/veristat.c
+++ b/tools/testing/selftests/bpf/veristat.c
@@ -1628,7 +1628,7 @@ static void dump(__u32 prog_id, enum dump_mode mode,=
 const char *file_name, cons
 	printf("DUMP (%s) %s/%s:\n", mode =3D=3D DUMP_JITED ? "JITED" : "XLATED"=
, file_name, prog_name);
 	while (fgets(buf, sizeof(buf), fp))
 		fputs(buf, stdout);
-	fprintf(stdout, "\n");
+	putchar('\n');
=20
 	if (ferror(fp))
 		fprintf(stderr, "Failed to dump BPF prog with error: %d\n", errno);
diff --git a/tools/testing/selftests/drivers/net/hw/ncdevmem.c b/tools/tes=
ting/selftests/drivers/net/hw/ncdevmem.c
index d96e8a3b5a65..7bdcc4114dba 100644
=2D-- a/tools/testing/selftests/drivers/net/hw/ncdevmem.c
+++ b/tools/testing/selftests/drivers/net/hw/ncdevmem.c
@@ -135,7 +135,7 @@ static void pr_err(const char *fmt, ...)
=20
 	if (errno !=3D 0)
 		fprintf(stderr, ": %s", strerror(errno));
-	fprintf(stderr, "\n");
+	fputc(stderr, '\n');
 }
=20
 static struct memory_buffer *udmabuf_alloc(size_t size)
diff --git a/tools/testing/selftests/kvm/s390/keyop.c b/tools/testing/self=
tests/kvm/s390/keyop.c
index c7805e87d12c..120834f8ba0d 100644
=2D-- a/tools/testing/selftests/kvm/s390/keyop.c
+++ b/tools/testing/selftests/kvm/s390/keyop.c
@@ -117,7 +117,7 @@ static void dump_sk(const unsigned char skeys[], const=
 char *descr)
 		fprintf(stderr, "# %3d: ", i);
 		for (j =3D 0; j < 32; j++)
 			fprintf(stderr, "%02x ", skeys[i + j]);
-		fprintf(stderr, "\n");
+		fputc(stderr, '\n');
 	}
 }
=20
diff --git a/tools/testing/selftests/net/mptcp/pm_nl_ctl.c b/tools/testing=
/selftests/net/mptcp/pm_nl_ctl.c
index 78180da1efcc..40467e86bfd4 100644
=2D-- a/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
+++ b/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
@@ -208,7 +208,7 @@ static int capture_events(int fd, int event_group)
 		}
 		if (server_side)
 			fprintf(stderr, ",server_side:1");
-		fprintf(stderr, "\n");
+		fputc(stderr, '\n');
 	} while (1);
=20
 	return 0;
diff --git a/tools/testing/selftests/net/psock_tpacket.c b/tools/testing/s=
elftests/net/psock_tpacket.c
index 7caf3135448d..724da9222ad9 100644
=2D-- a/tools/testing/selftests/net/psock_tpacket.c
+++ b/tools/testing/selftests/net/psock_tpacket.c
@@ -116,7 +116,7 @@ static int pfsocket(int ver)
 static void status_bar_update(void)
 {
 	if (total_packets % 10 =3D=3D 0) {
-		fprintf(stderr, ".");
+		fputc(stderr, '.');
 		fflush(stderr);
 	}
 }
@@ -825,7 +825,7 @@ static int test_tpacket(int version, int type)
 	unmap_ring(sock, &ring);
 	close(sock);
=20
-	fprintf(stderr, "\n");
+	fputc(stderr, '\n');
 	return 0;
 }
=20
diff --git a/tools/testing/selftests/net/txtimestamp.c b/tools/testing/sel=
ftests/net/txtimestamp.c
index 170be192f5c7..86c8d4945d73 100644
=2D-- a/tools/testing/selftests/net/txtimestamp.c
+++ b/tools/testing/selftests/net/txtimestamp.c
@@ -200,10 +200,10 @@ static void __print_timestamp(const char *name, stru=
ct timespec *cur,
 		ts_delta =3D timespec_to_ns64(cur) - timespec_to_ns64(&ts_usr);
 		fprintf(stderr, "  (USR +");
 		__print_ts_delta_formatted(ts_delta);
-		fprintf(stderr, ")");
+		fputc(stderr, ')');
 	}
=20
-	fprintf(stderr, "\n");
+	fputc(stderr, '\n');
 }
=20
 static void record_timestamp_usr(void)
@@ -254,7 +254,7 @@ static void print_timing_event(char *name, struct timi=
ng_event *te)
 	__print_ts_delta_formatted(te->min);
 	fprintf(stderr, ", max=3D");
 	__print_ts_delta_formatted(te->max);
-	fprintf(stderr, "\n");
+	fputc(stderr, '\n');
 }
=20
 /* TODO: convert to check_and_print payload once API is stable */
@@ -271,7 +271,7 @@ static void print_payload(char *data, int len)
 	fprintf(stderr, "payload: ");
 	for (i =3D 0; i < len; i++)
 		fprintf(stderr, "%02hhx ", data[i]);
-	fprintf(stderr, "\n");
+	fputc(stderr, '\n');
 }
=20
 static void print_pktinfo(int family, int ifindex, void *saddr, void *dad=
dr)
@@ -933,7 +933,7 @@ int main(int argc, char **argv)
 	fprintf(stderr, "protocol:     %s\n", sock_names[cfg_proto]);
 	fprintf(stderr, "payload:      %u\n", cfg_payload_len);
 	fprintf(stderr, "server port:  %u\n", dest_port);
-	fprintf(stderr, "\n");
+	fputc(stderr, '\n');
=20
 	if (do_ipv4) {
 		if (cfg_do_listen)
diff --git a/tools/testing/selftests/powerpc/nx-gzip/gunz_test.c b/tools/t=
esting/selftests/powerpc/nx-gzip/gunz_test.c
index 7c23d3dd7d6d..412defe98271 100644
=2D-- a/tools/testing/selftests/powerpc/nx-gzip/gunz_test.c
+++ b/tools/testing/selftests/powerpc/nx-gzip/gunz_test.c
@@ -363,7 +363,7 @@ int decompress_file(int argc, char **argv, void *devha=
ndle)
 			goto err3;
 		fprintf(stderr, "%02x ", tmp[i]);
 		if (i =3D=3D 5)
-			fprintf(stderr, "\n");
+			fputc(stderr, '\n');
 	}
 	fprintf(stderr, "gzHeader MTIME, XFL, OS ignored\n");
=20
diff --git a/tools/testing/selftests/vfio/lib/include/libvfio/assert.h b/t=
ools/testing/selftests/vfio/lib/include/libvfio/assert.h
index 9fff88f6e4e1..682267bb71e3 100644
=2D-- a/tools/testing/selftests/vfio/lib/include/libvfio/assert.h
+++ b/tools/testing/selftests/vfio/lib/include/libvfio/assert.h
@@ -11,7 +11,7 @@
=20
 #define VFIO_LOG_AND_EXIT(...) do {		\
 	fprintf(stderr, "  " __VA_ARGS__);	\
-	fprintf(stderr, "\n");			\
+	fputc(stderr, '\n');			\
 	exit(KSFT_FAIL);			\
 } while (0)
=20
diff --git a/tools/testing/selftests/vfio/lib/libvfio.c b/tools/testing/se=
lftests/vfio/lib/libvfio.c
index 3a3d1ed635c1..80a312f149a6 100644
=2D-- a/tools/testing/selftests/vfio/lib/libvfio.c
+++ b/tools/testing/selftests/vfio/lib/libvfio.c
@@ -60,16 +60,16 @@ char **vfio_selftests_get_bdfs(int *argc, char *argv[]=
, int *nr_bdfs)
 	}
=20
 	fprintf(stderr, "Unable to determine which device(s) to use, skipping te=
st.\n");
-	fprintf(stderr, "\n");
+	fputc(stderr, '\n');
 	fprintf(stderr, "To pass the device address via environment variable:\n"=
);
-	fprintf(stderr, "\n");
+	fputc(stderr, '\n');
 	fprintf(stderr, "    export VFIO_SELFTESTS_BDF=3D\"segment:bus:device.fu=
nction\"\n");
 	fprintf(stderr, "    %s [options]\n", argv[0]);
-	fprintf(stderr, "\n");
+	fputc(stderr, '\n');
 	fprintf(stderr, "To pass the device address(es) via argv:\n");
-	fprintf(stderr, "\n");
+	fputc(stderr, '\n');
 	fprintf(stderr, "    %s [options] segment:bus:device.function ...\n", ar=
gv[0]);
-	fprintf(stderr, "\n");
+	fputc(stderr, '\n');
 	exit(KSFT_SKIP);
 }
=20
diff --git a/tools/testing/vsock/vsock_diag_test.c b/tools/testing/vsock/v=
sock_diag_test.c
index 081e045f4696..cc903cdb45d9 100644
=2D-- a/tools/testing/vsock/vsock_diag_test.c
+++ b/tools/testing/vsock/vsock_diag_test.c
@@ -86,7 +86,7 @@ static void print_vsock_addr(FILE *fp, unsigned int cid,=
 unsigned int port)
 		fprintf(fp, "%u:", cid);
=20
 	if (port =3D=3D VMADDR_PORT_ANY)
-		fprintf(fp, "*");
+		fputc(fp, '*');
 	else
 		fprintf(fp, "%u", port);
 }
@@ -94,7 +94,7 @@ static void print_vsock_addr(FILE *fp, unsigned int cid,=
 unsigned int port)
 static void print_vsock_stat(FILE *fp, struct vsock_stat *st)
 {
 	print_vsock_addr(fp, st->msg.vdiag_src_cid, st->msg.vdiag_src_port);
-	fprintf(fp, " ");
+	fputc(fp, ' ');
 	print_vsock_addr(fp, st->msg.vdiag_dst_cid, st->msg.vdiag_dst_port);
 	fprintf(fp, " %s %s %s %u\n",
 		sock_type_str(st->msg.vdiag_type),
diff --git a/tools/thermal/tmon/sysfs.c b/tools/thermal/tmon/sysfs.c
index cb1108bc9249..ebdb95819a76 100644
=2D-- a/tools/thermal/tmon/sysfs.c
+++ b/tools/thermal/tmon/sysfs.c
@@ -522,7 +522,7 @@ int update_thermal_data()
 	}
=20
 	if (tmon_log) {
-		fprintf(tmon_log, "\n");
+		fputc(tmon_log, '\n');
 		fflush(tmon_log);
 	}
=20
diff --git a/tools/thermal/tmon/tmon.c b/tools/thermal/tmon/tmon.c
index 7eb3216a27f4..9a972f73a2c0 100644
=2D-- a/tools/thermal/tmon/tmon.c
+++ b/tools/thermal/tmon/tmon.c
@@ -199,7 +199,7 @@ static void prepare_logging(void)
 		fprintf(tmon_log, "%s%d ", ptdata.cdi[i].type,
 			ptdata.cdi[i].instance);
=20
-	fprintf(tmon_log, "\n");
+	fputc(tmon_log, '\n');
 }
=20
 static struct option opts[] =3D {
diff --git a/tools/tracing/latency/latency-collector.c b/tools/tracing/lat=
ency/latency-collector.c
index ef97916e3873..3dc6fb9df926 100644
=2D-- a/tools/tracing/latency/latency-collector.c
+++ b/tools/tracing/latency/latency-collector.c
@@ -1999,7 +1999,7 @@ static void scan_arguments(int argc, char *argv[])
 "been enabled. Random sleep is intended for the following tracers:\n");
 			for (i =3D 0; random_tracers[i]; i++)
 				fprintf(stderr, "%s\n", random_tracers[i]);
-			fprintf(stderr, "\n");
+			fputc(stderr, '\n');
 		}
 	}
=20
diff --git a/tools/tracing/rtla/src/common.c b/tools/tracing/rtla/src/comm=
on.c
index 8c7f5e75b2ec..e81e676d51d2 100644
=2D-- a/tools/tracing/rtla/src/common.c
+++ b/tools/tracing/rtla/src/common.c
@@ -449,7 +449,7 @@ void common_usage(const char *tool, const char *mode,
 		fprintf(stderr, "%s [-h] ", mode);
=20
 	print_msg_array(start_msgs);
-	fprintf(stderr, "\n");
+	fputc(stderr, '\n');
 	print_msg_array(common_options);
 	print_msg_array(opt_msgs);
=20
diff --git a/tools/tracing/rtla/src/utils.c b/tools/tracing/rtla/src/utils=
.c
index cb187e7d48d1..3532da2f2296 100644
=2D-- a/tools/tracing/rtla/src/utils.c
+++ b/tools/tracing/rtla/src/utils.c
@@ -67,7 +67,7 @@ void fatal(const char *fmt, ...)
 	va_start(ap, fmt);
 	vfprintf(stderr, fmt, ap);
 	va_end(ap);
-	fprintf(stderr, "\n");
+	fputc(stderr, '\n');
=20
 	exit(ERROR);
 }
diff --git a/tools/usb/ffs-test.c b/tools/usb/ffs-test.c
index 22b938fbdfb7..e993736ba0d6 100644
=2D-- a/tools/usb/ffs-test.c
+++ b/tools/usb/ffs-test.c
@@ -562,7 +562,7 @@ empty_out_buf(struct thread *ignore, const void *buf, =
size_t nbytes)
 				fprintf(stderr, "%4zd:", len);
 			fprintf(stderr, " %02x", *p);
 			if (31 =3D=3D (len % 32))
-				fprintf(stderr, "\n");
+				fputc(stderr, '\n');
 		}
 		fflush(stderr);
 		errno =3D EILSEQ;
diff --git a/tools/verification/rv/src/in_kernel.c b/tools/verification/rv=
/src/in_kernel.c
index e6dea4040f8f..26132171f600 100644
=2D-- a/tools/verification/rv/src/in_kernel.c
+++ b/tools/verification/rv/src/in_kernel.c
@@ -667,7 +667,7 @@ static void ikm_usage_print_reactors(void)
 		end =3D strstr(start, "\n");
 	}
=20
-	fprintf(stderr, "\n");
+	fputc(stderr, '\n');
 }
 /*
  * ikm_usage - print usage
=2D-=20
2.55.0


