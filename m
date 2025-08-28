Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4539DCA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 10:47:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 684BF8E0015; Thu, 28 Aug 2025 06:47:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65CBB8E0001; Thu, 28 Aug 2025 06:47:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54B188E0015; Thu, 28 Aug 2025 06:47:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 41EA78E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 06:47:13 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E50871A0AA5
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 10:47:12 +0000 (UTC)
X-FDA: 83825839104.24.A40C22F
Received: from mout.web.de (mout.web.de [212.227.17.12])
	by imf26.hostedemail.com (Postfix) with ESMTP id BEEBD140012
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 10:47:10 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=fvofJaPk;
	spf=pass (imf26.hostedemail.com: domain of spasswolf@web.de designates 212.227.17.12 as permitted sender) smtp.mailfrom=spasswolf@web.de;
	dmarc=pass (policy=quarantine) header.from=web.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756378031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0WUJqsrAYnQkrI39CYTgeGfmXA2oXBJe4Y8RSF3Rocg=;
	b=dheN3BFbsiOf1w1B2IsOPCA9cYCsEdQKTVOZYtBuaI2cU+HL0EOMpGkDEYmCLSSBcTKDj9
	A9TQP1qs7Go4gh7jw78IQHc4p6HMhdkFMYS3eKVNStwcfoJjtqEMmvAYxCAx3+dC+SptKw
	7ct/BSQTm6dFV5D3m4TT0Xl0El0xWVs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=fvofJaPk;
	spf=pass (imf26.hostedemail.com: domain of spasswolf@web.de designates 212.227.17.12 as permitted sender) smtp.mailfrom=spasswolf@web.de;
	dmarc=pass (policy=quarantine) header.from=web.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756378031; a=rsa-sha256;
	cv=none;
	b=WCMCwXRhMNiopWY3DHa5okr+J8RI7JJ4q8bqjtEcdB+/XU3PgZcWFY8hVAF/HzOWTwZ60J
	F4lQJFYpbZX5K7oq16FikUawFLM9KaAzzHB+qwPMjZ+qywEMrJYYDt2CwiNdEayVdXZCXP
	pXQdosJPTaTNQdJ6egtJ7u4ZSHJ1t9w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1756378022; x=1756982822; i=spasswolf@web.de;
	bh=0WUJqsrAYnQkrI39CYTgeGfmXA2oXBJe4Y8RSF3Rocg=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=fvofJaPk04UEbJ0tgOPTIBGpJ+5yn1ns6pnWzY9auAAeMJh9B661CO0seeDvNONm
	 idpKw4Sqb/9FPxqxLNdl2CLeFTB35nkaJbNQaCo5N37lk9ZchG7oc+JgTQw9KFnql
	 ENlrQWDj/HaeTigmLBFJDqP+HND/AI4yNWw6LkFz9GROqOmDxKhaltszvNPwmGf6G
	 54gR9B6KEXw30WNc+7EHAwfq7rnCV5r37Rw7PryUMSblTmB7YpsKL22JwD7lMrWQQ
	 EQ9f7+8zm5GOrDqCh88ELVGiEGZ/TyldFMfeCtu7Z6P2Q5GW1XydgraXW0wAPqA+0
	 bQZMZaiHeA/KCnxaWQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from localhost.localdomain ([95.223.134.88]) by smtp.web.de
 (mrweb106 [213.165.67.124]) with ESMTPSA (Nemesis) id
 1MXocY-1uzJP73lBk-00Ynov; Thu, 28 Aug 2025 12:47:02 +0200
From: Bert Karwatzki <spasswolf@web.de>
To: vbabka@suse.cz
Cc: Bert Karwatzki <spasswolf@web.de>,
	Liam.Howlett@oracle.com,
	cl@gentwo.org,
	harry.yoo@oracle.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-rt-devel@lists.linux.dev,
	maple-tree@lists.infradead.org,
	rcu@vger.kernel.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	surenb@google.com,
	urezki@gmail.com
Subject: commit 4ca04daa23305 fails to compile with PREEMPT_RT=y
Date: Thu, 28 Aug 2025 12:46:57 +0200
Message-ID: <20250828104658.172649-1-spasswolf@web.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: 20250827-slub-percpu-caches-v6-2-f0f775a3f73f@suse.cz
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:x8k7jnSLTIhjtWsrF57/r+ECHgT4S23aBF+WvPLQmxRQ3qbrz5Y
 BMzXjERZIhcrvgm87eBXEIlDnXJGKF3/Ms7eF6CIdyONbD98QI58RdZc2nhWL2SVAtUcZCQ
 e/BBxXpK01UvZAIXxHpebOLizmd0t7w46q0t6y5y/PMHD45G37CAx5c0v09E+o6K3FKZ0lz
 uGUaqyeXAFY313t+aashQ==
UI-OutboundReport: notjunk:1;M01:P0:Np0hriZfIZM=;c6DZNBGjuihKHBEYf5ipWmKa4CR
 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
 n40O4zoAjcUYx4VMoRt
X-Rspamd-Queue-Id: BEEBD140012
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 8ixtaci9b11xektihsbyjpwc81i41pn1
X-HE-Tag: 1756378030-338301
X-HE-Meta: U2FsdGVkX1/EwTes/Ump1IneGkm1Icylk6G/u1B+P9EY4wfU/ZP6xJtXnTDjZMlq1OhFR6NzcCUIDpDwY0jwj7GxOFMz5SH6oSkW5EYM8dPPd5AInPchWcapOMv9uXmlRJoSoxZfR98mplmrpU2gbM4oDLTBs2wImlHwU3O04+AB9wcqa/dTJQZbVI6WvqgzhhhthW7suYHoDEzEmIkxa0yGE9j0U4geWl7UvjflUt/KlFaLVv/XKojo4HW09JPJpNsKzWRcDEie+2CmhSlYvyB82QLkpszJBLkuVtuiikPVvOOLa+p+aCjBbN/XjguN3ZTXgkwujipU51+XtYS9pgbrfshjLPv7CmqwLPzpfxtMKhgHcwTvDlqlCAJiAkjkpXD23FF/9DKpOdt7+Mqmd9jWpW5koywlAgZqrZEcVgCpd8UISzAla0DMrT7W23x5T/s8Rq+3sqMxiCtddz+zKfyol6xVRNxPMuJEudJL8nccjJzzRQBQl/r544J4r3FEA6fjE6b/3adNAoRskUTAH/NXFNgDNmDl6IyeGRH3PAhjusz9jF/5K8pHOK7Zq5HxW2oFXBqCLD4fJGO094Oc6UwHIPjDaMep31y/ejwI48az2SuDWl87nD6+uuFRdLkr6Z6OH3tPjqb9GQdeu1rmvUGoYCKJcJQA+1AQK1kMiedW0jlx0XGJ3Mg9KFbLNHC9HCS0k2qnIZvT6KJop7IuVd+Dhq2sW1IW2WnsZgr8xN1QrVJ5ZnkuaLjoFpl+jzAPhEbzeGArpiA9A/j1U/SdTtZ5qLbbBBZdEWmxVWRaVqlTFdpazG5A7qpaKJ97oZdhE0Bpb2RXEMpygfls6AyoBwvpczGEQ5OzgtdPmGQXeymWY67tuuSmXtewzjdE0Y4WppeA/slsJYjanTe9Otm2E783/krmIpmi0yJvbvFbd4UPcbV66yY1t1lOyF6tAafQly96u3zgzbLdjME49bd
 fYdL0UVT
 mgTb0F3ZNJLjDzdzM++1owSj7Wtx5krFL6q6LLgdS6GB3JJPHfmMmRd8+jf1w7OdFlJYjIpoqWqV79bAT4XJ0F/6dygeaj9OCbY4O87pOhoDGZrExxjFlSIg6gHQhCsEKwZ6PzcARQi1R0dXCe+18L6IXJMskoP/M9/CJIzWaZZym0ad4uMpjU46N6Bg62O/K8tsUe5XzxBXmfhwTNyQIcz0u+knxpA68OyPrGYXALQRLHPTizKHA4hGOZxYKKRgQy9s43KD3LpGFto+5ZJnosCha5Ovdd4INEN9AWZzFiiN44f71Dx40pBQMQsFnEZvJVPQWXI1eUC91oSBG8FV00s8ez92AxGaSbtXH3H4588wP/ss=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In noticed that linux next-20250828 fails to compile with the following er=
ror:

In file included from ./include/linux/spinlock.h:63,
                 from ./include/linux/mmzone.h:8,
                 from ./include/linux/gfp.h:7,
                 from ./include/linux/mm.h:7,
                 from mm/slub.c:13:
mm/slub.c: In function =E2=80=98__pcs_replace_empty_main=E2=80=99:
mm/slub.c:4727:64: error: =E2=80=98local_trylock_t=E2=80=99 {aka =E2=80=98=
__seg_gs struct spinlock=E2=80=99} has no member named =E2=80=98llock=E2=
=80=99; did you mean =E2=80=98lock=E2=80=99?
 4727 |         lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock.llo=
ck));
      |                                                                ^~~=
~~
./include/linux/lockdep.h:392:61: note: in definition of macro =E2=80=98lo=
ckdep_assert_held=E2=80=99
  392 | #define lockdep_assert_held(l)                  do { (void)(l); } =
while (0)
      |                                                             ^
./include/linux/percpu-defs.h:245:9: note: in expansion of macro =E2=80=98=
__verify_pcpu_ptr=E2=80=99
  245 |         __verify_pcpu_ptr(ptr);                                   =
      \
      |         ^~~~~~~~~~~~~~~~~
./include/linux/percpu-defs.h:256:27: note: in expansion of macro =E2=80=
=98raw_cpu_ptr=E2=80=99
  256 | #define this_cpu_ptr(ptr) raw_cpu_ptr(ptr)
      |                           ^~~~~~~~~~~
mm/slub.c:4727:29: note: in expansion of macro =E2=80=98this_cpu_ptr=E2=80=
=99
 4727 |         lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock.llo=
ck));
      |                             ^~~~~~~~~~~~
mm/slub.c:4727:64: error: =E2=80=98local_trylock_t=E2=80=99 {aka =E2=80=98=
__seg_gs struct spinlock=E2=80=99} has no member named =E2=80=98llock=E2=
=80=99; did you mean =E2=80=98lock=E2=80=99?
 4727 |         lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock.llo=
ck));
      |                                                                ^~~=
~~
./include/linux/lockdep.h:392:61: note: in definition of macro =E2=80=98lo=
ckdep_assert_held=E2=80=99
  392 | #define lockdep_assert_held(l)                  do { (void)(l); } =
while (0)
      |                                                             ^
./include/linux/percpu-defs.h:246:9: note: in expansion of macro =E2=80=98=
arch_raw_cpu_ptr=E2=80=99
  246 |         arch_raw_cpu_ptr(ptr);                                    =
      \
      |         ^~~~~~~~~~~~~~~~
./include/linux/percpu-defs.h:256:27: note: in expansion of macro =E2=80=
=98raw_cpu_ptr=E2=80=99
  256 | #define this_cpu_ptr(ptr) raw_cpu_ptr(ptr)
      |                           ^~~~~~~~~~~
mm/slub.c:4727:29: note: in expansion of macro =E2=80=98this_cpu_ptr=E2=80=
=99
 4727 |         lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock.llo=
ck));
      |                             ^~~~~~~~~~~~
mm/slub.c:4727:64: error: =E2=80=98local_trylock_t=E2=80=99 {aka =E2=80=98=
__seg_gs struct spinlock=E2=80=99} has no member named =E2=80=98llock=E2=
=80=99; did you mean =E2=80=98lock=E2=80=99?
 4727 |         lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock.llo=
ck));
      |                                                                ^~~=
~~
./include/linux/lockdep.h:392:61: note: in definition of macro =E2=80=98lo=
ckdep_assert_held=E2=80=99
  392 | #define lockdep_assert_held(l)                  do { (void)(l); } =
while (0)
      |                                                             ^
./arch/x86/include/asm/percpu.h:68:10: note: in expansion of macro =E2=80=
=98TYPEOF_UNQUAL=E2=80=99
   68 |         (TYPEOF_UNQUAL(*(_ptr)) __force __kernel *)tcp_ptr__;     =
      \
      |          ^~~~~~~~~~~~~
./include/linux/percpu-defs.h:246:9: note: in expansion of macro =E2=80=98=
arch_raw_cpu_ptr=E2=80=99
  246 |         arch_raw_cpu_ptr(ptr);                                    =
      \
      |         ^~~~~~~~~~~~~~~~
./include/linux/percpu-defs.h:256:27: note: in expansion of macro =E2=80=
=98raw_cpu_ptr=E2=80=99
  256 | #define this_cpu_ptr(ptr) raw_cpu_ptr(ptr)
      |                           ^~~~~~~~~~~
mm/slub.c:4727:29: note: in expansion of macro =E2=80=98this_cpu_ptr=E2=80=
=99
 4727 |         lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock.llo=
ck));
      |                             ^~~~~~~~~~~~
  CC      net/ipv4/route.o
mm/slub.c: In function =E2=80=98__pcs_install_empty_sheaf=E2=80=99:
  AS      lib/crypto/x86/sha1-ni-asm.o
  CC      drivers/acpi/ec.o
mm/slub.c:5604:64: error: =E2=80=98local_trylock_t=E2=80=99 {aka =E2=80=98=
__seg_gs struct spinlock=E2=80=99} has no member named =E2=80=98llock=E2=
=80=99; did you mean =E2=80=98lock=E2=80=99?
 5604 |         lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock.llo=
ck));
      |                                                                ^~~=
~~
./include/linux/lockdep.h:392:61: note: in definition of macro =E2=80=98lo=
ckdep_assert_held=E2=80=99
  392 | #define lockdep_assert_held(l)                  do { (void)(l); } =
while (0)
      |                                                             ^
./include/linux/percpu-defs.h:245:9: note: in expansion of macro =E2=80=98=
__verify_pcpu_ptr=E2=80=99
  245 |         __verify_pcpu_ptr(ptr);                                   =
      \
      |         ^~~~~~~~~~~~~~~~~
./include/linux/percpu-defs.h:256:27: note: in expansion of macro =E2=80=
=98raw_cpu_ptr=E2=80=99
  256 | #define this_cpu_ptr(ptr) raw_cpu_ptr(ptr)
      |                           ^~~~~~~~~~~
mm/slub.c:5604:29: note: in expansion of macro =E2=80=98this_cpu_ptr=E2=80=
=99
 5604 |         lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock.llo=
ck));
      |                             ^~~~~~~~~~~~
mm/slub.c:5604:64: error: =E2=80=98local_trylock_t=E2=80=99 {aka =E2=80=98=
__seg_gs struct spinlock=E2=80=99} has no member named =E2=80=98llock=E2=
=80=99; did you mean =E2=80=98lock=E2=80=99?
 5604 |         lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock.llo=
ck));
      |                                                                ^~~=
~~
./include/linux/lockdep.h:392:61: note: in definition of macro =E2=80=98lo=
ckdep_assert_held=E2=80=99
  392 | #define lockdep_assert_held(l)                  do { (void)(l); } =
while (0)
      |                                                             ^
./include/linux/percpu-defs.h:246:9: note: in expansion of macro =E2=80=98=
arch_raw_cpu_ptr=E2=80=99
  246 |         arch_raw_cpu_ptr(ptr);                                    =
      \
      |         ^~~~~~~~~~~~~~~~
./include/linux/percpu-defs.h:256:27: note: in expansion of macro =E2=80=
=98raw_cpu_ptr=E2=80=99
  256 | #define this_cpu_ptr(ptr) raw_cpu_ptr(ptr)
      |                           ^~~~~~~~~~~
mm/slub.c:5604:29: note: in expansion of macro =E2=80=98this_cpu_ptr=E2=80=
=99
 5604 |         lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock.llo=
ck));
      |                             ^~~~~~~~~~~~
mm/slub.c:5604:64: error: =E2=80=98local_trylock_t=E2=80=99 {aka =E2=80=98=
__seg_gs struct spinlock=E2=80=99} has no member named =E2=80=98llock=E2=
=80=99; did you mean =E2=80=98lock=E2=80=99?
 5604 |         lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock.llo=
ck));
      |                                                                ^~~=
~~
./include/linux/lockdep.h:392:61: note: in definition of macro =E2=80=98lo=
ckdep_assert_held=E2=80=99
  392 | #define lockdep_assert_held(l)                  do { (void)(l); } =
while (0)
      |                                                             ^
./arch/x86/include/asm/percpu.h:68:10: note: in expansion of macro =E2=80=
=98TYPEOF_UNQUAL=E2=80=99
   68 |         (TYPEOF_UNQUAL(*(_ptr)) __force __kernel *)tcp_ptr__;     =
      \
      |          ^~~~~~~~~~~~~
./include/linux/percpu-defs.h:246:9: note: in expansion of macro =E2=80=98=
arch_raw_cpu_ptr=E2=80=99
  246 |         arch_raw_cpu_ptr(ptr);                                    =
      \
      |         ^~~~~~~~~~~~~~~~
./include/linux/percpu-defs.h:256:27: note: in expansion of macro =E2=80=
=98raw_cpu_ptr=E2=80=99
  256 | #define this_cpu_ptr(ptr) raw_cpu_ptr(ptr)
      |                           ^~~~~~~~~~~
mm/slub.c:5604:29: note: in expansion of macro =E2=80=98this_cpu_ptr=E2=80=
=99
 5604 |         lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock.llo=
ck));
      |                             ^~~~~~~~~~~~
mm/slub.c: In function =E2=80=98__pcs_replace_full_main=E2=80=99:
mm/slub.c:5653:64: error: =E2=80=98local_trylock_t=E2=80=99 {aka =E2=80=98=
__seg_gs struct spinlock=E2=80=99} has no member named =E2=80=98llock=E2=
=80=99; did you mean =E2=80=98lock=E2=80=99?
 5653 |         lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock.llo=
ck));
      |                                                                ^~~=
~~
./include/linux/lockdep.h:392:61: note: in definition of macro =E2=80=98lo=
ckdep_assert_held=E2=80=99
  392 | #define lockdep_assert_held(l)                  do { (void)(l); } =
while (0)
      |                                                             ^
./include/linux/percpu-defs.h:245:9: note: in expansion of macro =E2=80=98=
__verify_pcpu_ptr=E2=80=99
  245 |         __verify_pcpu_ptr(ptr);                                   =
      \
      |         ^~~~~~~~~~~~~~~~~
./include/linux/percpu-defs.h:256:27: note: in expansion of macro =E2=80=
=98raw_cpu_ptr=E2=80=99
  256 | #define this_cpu_ptr(ptr) raw_cpu_ptr(ptr)
      |                           ^~~~~~~~~~~
mm/slub.c:5653:29: note: in expansion of macro =E2=80=98this_cpu_ptr=E2=80=
=99
 5653 |         lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock.llo=
ck));
      |                             ^~~~~~~~~~~~
mm/slub.c:5653:64: error: =E2=80=98local_trylock_t=E2=80=99 {aka =E2=80=98=
__seg_gs struct spinlock=E2=80=99} has no member named =E2=80=98llock=E2=
=80=99; did you mean =E2=80=98lock=E2=80=99?
 5653 |         lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock.llo=
ck));
      |                                                                ^~~=
~~
./include/linux/lockdep.h:392:61: note: in definition of macro =E2=80=98lo=
ckdep_assert_held=E2=80=99
  392 | #define lockdep_assert_held(l)                  do { (void)(l); } =
while (0)
      |                                                             ^
./include/linux/percpu-defs.h:246:9: note: in expansion of macro =E2=80=98=
arch_raw_cpu_ptr=E2=80=99
  246 |         arch_raw_cpu_ptr(ptr);                                    =
      \
      |         ^~~~~~~~~~~~~~~~
./include/linux/percpu-defs.h:256:27: note: in expansion of macro =E2=80=
=98raw_cpu_ptr=E2=80=99
  256 | #define this_cpu_ptr(ptr) raw_cpu_ptr(ptr)
      |                           ^~~~~~~~~~~
mm/slub.c:5653:29: note: in expansion of macro =E2=80=98this_cpu_ptr=E2=80=
=99
 5653 |         lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock.llo=
ck));
      |                             ^~~~~~~~~~~~
mm/slub.c:5653:64: error: =E2=80=98local_trylock_t=E2=80=99 {aka =E2=80=98=
__seg_gs struct spinlock=E2=80=99} has no member named =E2=80=98llock=E2=
=80=99; did you mean =E2=80=98lock=E2=80=99?
 5653 |         lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock.llo=
ck));
      |                                                                ^~~=
~~
./include/linux/lockdep.h:392:61: note: in definition of macro =E2=80=98lo=
ckdep_assert_held=E2=80=99
  392 | #define lockdep_assert_held(l)                  do { (void)(l); } =
while (0)
      |                                                             ^
./arch/x86/include/asm/percpu.h:68:10: note: in expansion of macro =E2=80=
=98TYPEOF_UNQUAL=E2=80=99
   68 |         (TYPEOF_UNQUAL(*(_ptr)) __force __kernel *)tcp_ptr__;     =
      \
      |          ^~~~~~~~~~~~~
./include/linux/percpu-defs.h:246:9: note: in expansion of macro =E2=80=98=
arch_raw_cpu_ptr=E2=80=99
  246 |         arch_raw_cpu_ptr(ptr);                                    =
      \
      |         ^~~~~~~~~~~~~~~~
./include/linux/percpu-defs.h:256:27: note: in expansion of macro =E2=80=
=98raw_cpu_ptr=E2=80=99
  256 | #define this_cpu_ptr(ptr) raw_cpu_ptr(ptr)
      |                           ^~~~~~~~~~~
mm/slub.c:5653:29: note: in expansion of macro =E2=80=98this_cpu_ptr=E2=80=
=99
 5653 |         lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock.llo=
ck));
      |                             ^~~~~~~~~~~~


The reason for this is that local_trylock_t is mapped to spinlock_t on=20
PREEMPT_RT=3Dy and spinlock_t has no member named llock.
If one changes the assertion like this the kernel compiles with PREEMPT_RT=
=3Dy, too,
but I'm not sure if the assertion is correctly used here. If not one has t=
o use
#ifdef PREEMPT_RT here I think:

diff --git a/mm/slub.c b/mm/slub.c
index 3ab91a1409f5..2138fecc8d37 100644
=2D-- a/mm/slub.c
+++ b/mm/slub.c
@@ -4724,7 +4724,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struc=
t slub_percpu_sheaves *pcs,
 	struct slab_sheaf *full;
 	bool can_alloc;
=20
-	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock.llock));
+	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
=20
 	if (pcs->spare && pcs->spare->size > 0) {
 		swap(pcs->main, pcs->spare);
@@ -5601,7 +5601,7 @@ static void __slab_free(struct kmem_cache *s, struct=
 slab *slab,
 static void __pcs_install_empty_sheaf(struct kmem_cache *s,
 		struct slub_percpu_sheaves *pcs, struct slab_sheaf *empty)
 {
-	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock.llock));
+	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
=20
 	/* This is what we expect to find if nobody interrupted us. */
 	if (likely(!pcs->spare)) {
@@ -5650,7 +5650,7 @@ __pcs_replace_full_main(struct kmem_cache *s, struct=
 slub_percpu_sheaves *pcs)
 	bool put_fail;
=20
 restart:
-	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock.llock));
+	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
=20
 	put_fail =3D false;
=20

Bert Karwatzki

