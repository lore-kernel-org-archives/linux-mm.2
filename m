Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E072CCDB47F
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 07:15:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 978336B009B; Thu, 25 Jun 2026 03:15:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 928EB6B009D; Thu, 25 Jun 2026 03:15:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 864C76B00A1; Thu, 25 Jun 2026 03:15:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 56C706B009B
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 03:15:47 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C94EA405F2
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:15:46 +0000 (UTC)
X-FDA: 84917575092.20.85FD888
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9459980006
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:15:43 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vbbvcBmb;
	spf=pass (imf30.hostedemail.com: domain of fuad.tabba@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=fuad.tabba@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782371743;
	b=wio2pueUx7dCfFJLjkvrURT04HfyQriiIxIHdU+avf/jpLBt6uwekcLpcR1sI8xeNuZce0
	joA1p3iealknDaDEXjVTciGs1CMKPqI3e6BjyFKdCjq9ZcBKYzSOrqDof0L3NyKzaLck7D
	Nd0UD+eq8WxrEPVkPOIN6ZtIYlpf5Ek=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782371743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n4l8kEDpwe6ZsvCFof1KiGbqck2t2+CoEwvUDbK1yNQ=;
	b=BnIrFm5kc+pORy0DV0iDY1+bojBrYRcfv65cse6FYHtOLQg+MXDTtkST3Egh1UECWkNcou
	xT/sH14ZD9LW7Y9C2aDRRyIvo0zbp7m7UDRKUMdIjgOuJxtfaoV8lKMYGFSJ3bbyrZXkhE
	cZNyb6uD4jPh4oSVJyw+J6KadfiJfEs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vbbvcBmb;
	spf=pass (imf30.hostedemail.com: domain of fuad.tabba@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=fuad.tabba@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Forwarded-Encrypted: i=1; AFNElJ9axRkuCI0HcQv4T4M7p3E1v7iqJlRqazXulX/v0hXqwRirdrxCBK+cYFAnECR5o3cimvsEF7xs3Q==@kvack.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782371741;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n4l8kEDpwe6ZsvCFof1KiGbqck2t2+CoEwvUDbK1yNQ=;
	b=vbbvcBmbwOIFFos+R0RUat0YTqIxermF8vH32FHejyiKXEut6l0lGXFx2z28dwC2i39xLR
	aqWUNTZ9CQB4cbWec4kXNRQNVCATWKxgw6k2gRuDvQX+xc8CSTxdt6YgoLbSPTQ/1UHubQ
	WJ6ohHN4d2EjIqxeP7HEPV29BA79flY=
X-Gm-Message-State: AOJu0Yzzc2jgwF+Fjfy/F3b7rniSeaID2rm+r0vFY7zZPVj/odL8KM0+
	3PdA5hIi8fYUUKH6TWp+6PPcHr/492iB7Q03Wh04BGcca9+Z0IXMIErX6BbOU0o7UFBrmgidmeg
	sPZBvgQ0cyXm5tPh6A3CWaw1mct3vAc/KcUprTdKO
X-Received: by 2002:a05:622a:1f96:b0:516:cc18:4760 with SMTP id
 d75a77b69052e-51a709958aamr5225201cf.21.1782371725540; Thu, 25 Jun 2026
 00:15:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com> <20260618-gmem-inplace-conversion-v8-37-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-37-9d2959357853@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 25 Jun 2026 08:14:48 +0100
X-Gmail-Original-Message-ID: <CA+EHjTxZQf9w+iT11O3+KC-z6Sbg5qCEZ-XCR3=wRnG2k3=Maw@mail.gmail.com>
X-Gm-Features: AVVi8Cfiom8KyzZV2HmAlpy9PB5CRyn77LPV2Q5_VbhfHk5a3YCLzvyw4gtaMNM
Message-ID: <CA+EHjTxZQf9w+iT11O3+KC-z6Sbg5qCEZ-XCR3=wRnG2k3=Maw@mail.gmail.com>
Subject: Re: [PATCH v8 37/46] KVM: selftests: Test that shared/private status
 is consistent across processes
To: ackerleytng@google.com
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: tpqf36q5b6qe19qnhj6gmac96h51oxk4
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9459980006
X-HE-Tag: 1782371743-955419
X-HE-Meta: U2FsdGVkX1+hQv+FPdKVp7OAZge9qjGtyNUZ+d3GYU3yqfgQCBvPJcAnxG2ZM09KsPFwlXPPhqIYeMbzaIcV6+/Rzk6T3CHvL550pj8tA8CwCJoHWrbPoyXPNSerZ9mnrQIcFZQ1PFkL35N+tlAZUFJYvZLYFbSwVPi1c9QWBhURIi2r5P5u7mu7k+PHMsUoWYEXGrCxcua5vsV+MxoXK3g5jLn0yz/lZkriP3FxyZzRrrMWtqyWltqAEIYjAuxpJmwhjRHW4q3pwVGFSb7gubp2njV8O6cfbbZt+gRZaTD6CGjE/V3otQiYs49pxoATq/OY9pgf6Kq6HNH/hLNNzX7qvv0Og14uePtQVb3m5r0p4sjrqUVWATWKYYzYg0BjKdMN3hPwe+4QLf3wA3KFiMQTItv8XA5kzR8yuTnm8kmWj68JljFaUnxZewvS3VBd4v3BpIs1uO/AEYj7y40DykkNQ6Z2/wTO4yC+rnsp43ojiF7tQZG0lbAiXQ8gweBFctKo9yIhGN71Jtk4Fcq6rW7THTZK6X3f4IRG+k5Y5/jx/Y8bHIhELqVDf+QMYUihm5elfvrJq6L+SOUq2SWXu1aCS25hLROtTshrC3zguwZFC8qVPZszI0hO46GoYYsAROuOOoxMxRQ92bzoOO+tQoL7K3XQDkSIsVtupcWLFZBYY/5BYAAiqITbonfEAEkShWtIZS8GsxkgcwoDZJPqg9B08LZAyLR1gbL34DEZIqqS14gqMPrC5umu/+p6SVCowQvcNdKZaYNI2iTfFTJO9QZ+CYNNbHqfXr8TJAJxK6gaoG8jKRfvrMQ8SefqC1v3gB1wN97U/uJ6shFEPM5uGP4eZk4KxHjKO2gaFg3TstfqgsfNdLrs+rKIpOiAJvQsC1mXpUqB3oYcoexi5imXx8/0cn575ZBtOw8pc4w99RNYEDlDYmsiqVmhvkG0dqU4a5Y5EFzRkms/L+DDxl7
 qFHeY4Q/
 7aHdDln6hOHtVLjAlKcR3ElVrvnDqtHsoctyzOsHU6HiMK9izIvpozYap6E4UBVINPc4FVA0Iyl4CbhTYenSrVkC/zhOgFhcjf67mgdFPRIvaeT4riT4/UvpCUB1vS7yibrKEZjiVhzOqGqKTQNaEqXvFyfLvA0qv2ypLB7cb6xkOZ1dvtZJTFR6bMGrdFxbHiEnNMZAgThk9vCQLReRkXGDvmA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 19 Jun 2026 at 01:32, Ackerley Tng via B4 Relay
<devnull+ackerleytng.google.com@kernel.org> wrote:
>
> From: Sean Christopherson <seanjc@google.com>
>
> Add a test to verify that a guest_memfd's shared/private status is
> consistent across processes, and that any shared pages previously mapped in
> any process are unmapped from all processes.
>
> The test forks a child process after creating the shared guest_memfd
> region so that the second process exists alongside the main process for the
> entire test.
>
> The processes then take turns to access memory to check that the
> shared/private status is consistent across processes.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---

Two things below, otherwise:

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


>  .../kvm/x86/guest_memfd_conversions_test.c         | 118 +++++++++++++++++++++
>  1 file changed, 118 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
> index f03af2c46426f..99b0023609670 100644
> --- a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
> +++ b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
> @@ -2,6 +2,8 @@
>  /*
>   * Copyright (c) 2024, Google LLC.
>   */
> +#include <pthread.h>
> +#include <time.h>
>  #include <sys/mman.h>
>  #include <unistd.h>

nit: include order

>
> @@ -323,6 +325,122 @@ GMEM_CONVERSION_TEST_INIT_SHARED(truncate)
>         test_private(t, 0, 0, 'A');
>  }
>
> +/* Test that shared/private memory protections work and are seen from any process. */
> +GMEM_CONVERSION_TEST_INIT_SHARED(forked_accesses)
> +{
> +       enum test_state {
> +               STATE_INIT,
> +               STATE_CHECK_SHARED,
> +               STATE_DONE_CHECKING_SHARED,
> +               STATE_CHECK_PRIVATE,
> +               STATE_DONE_CHECKING_PRIVATE,
> +       };
> +
> +       struct sync_state {
> +               pthread_mutex_t mutex;
> +               pthread_cond_t cond;
> +               enum test_state step;
> +       } *sync;
> +
> +       pthread_mutexattr_t mattr;
> +       pthread_condattr_t cattr;
> +       pid_t child_pid, parent_pid;
> +       int status;
> +
> +       sync = kvm_mmap(sizeof(*sync), PROT_READ | PROT_WRITE,
> +                       MAP_SHARED | MAP_ANONYMOUS, -1);
> +
> +       pthread_mutexattr_init(&mattr);
> +       pthread_mutexattr_setpshared(&mattr, PTHREAD_PROCESS_SHARED);
> +       pthread_mutex_init(&sync->mutex, &mattr);
> +       pthread_mutexattr_destroy(&mattr);
> +
> +       pthread_condattr_init(&cattr);
> +       pthread_condattr_setpshared(&cattr, PTHREAD_PROCESS_SHARED);
> +       pthread_cond_init(&sync->cond, &cattr);
> +       pthread_condattr_destroy(&cattr);
> +
> +       sync->step = STATE_INIT;
> +
> +#define TEST_STATE_AWAIT(__state)                                              \
> +       do {                                                                    \
> +               pthread_mutex_lock(&sync->mutex);                               \
> +               while (sync->step != (__state)) {                               \
> +                       struct timespec ts, stop;                               \
> +                       int ret;                                                \
> +                                                                               \
> +                       clock_gettime(CLOCK_REALTIME, &ts);                     \
> +                       stop = timespec_add_ns(ts, 100 * 1000000UL);            \
> +                                                                               \
> +                       ret = pthread_cond_timedwait(&sync->cond, &sync->mutex, &stop); \
> +                       if (ret == ETIMEDOUT) {                                 \
> +                               bool alive = (child_pid == 0) ?                 \
> +                                            (getppid() == parent_pid) :                \
> +                                            (waitpid(child_pid, NULL, WNOHANG) == 0); \

Not sure it's worth it, but if you want to silence Sashiko, waitid
with WNOWAIT might be the way to go (not tested, just from looking at
the man page). This is though very unlikely, mentioning it since
Sashiko complained.


> +                               TEST_ASSERT(alive, "Other process exited prematurely"); \
> +                       } else {                                                \
> +                               TEST_ASSERT(!ret, "pthread_cond_timedwait failed"); \
> +                       }                                                       \
> +               }                                                               \
> +               pthread_mutex_unlock(&sync->mutex);                             \
> +       } while (0)
> +
> +#define TEST_STATE_SET(__state)                                                        \
> +       do {                                                                    \
> +               pthread_mutex_lock(&sync->mutex);                               \
> +               sync->step = (__state);                                         \
> +               pthread_cond_broadcast(&sync->cond);                            \
> +               pthread_mutex_unlock(&sync->mutex);                             \
> +       } while (0)
> +
> +       parent_pid = getpid();
> +       child_pid = fork();
> +       TEST_ASSERT(child_pid != -1, "fork failed");
> +
> +       if (child_pid == 0) {
> +               const char inconsequential = 0xdd;
> +
> +               TEST_STATE_AWAIT(STATE_CHECK_SHARED);
> +
> +               /*
> +                * This maps the pages into the child process as well, and tests
> +                * that the conversion process will unmap the guest_memfd memory
> +                * from all processes.
> +                */
> +               host_do_rmw(t->mem, 0, 0xB, 0xC);
> +
> +               TEST_STATE_SET(STATE_DONE_CHECKING_SHARED);
> +               TEST_STATE_AWAIT(STATE_CHECK_PRIVATE);
> +
> +               TEST_EXPECT_SIGBUS(READ_ONCE(t->mem[0]));
> +               TEST_EXPECT_SIGBUS(WRITE_ONCE(t->mem[0], inconsequential));
> +
> +               TEST_STATE_SET(STATE_DONE_CHECKING_PRIVATE);
> +               exit(0);
> +       }
> +
> +       test_shared(t, 0, 0, 0xA, 0xB);
> +
> +       TEST_STATE_SET(STATE_CHECK_SHARED);
> +       TEST_STATE_AWAIT(STATE_DONE_CHECKING_SHARED);
> +
> +       test_convert_to_private(t, 0, 0xC, 0xD);
> +
> +       TEST_STATE_SET(STATE_CHECK_PRIVATE);
> +       TEST_STATE_AWAIT(STATE_DONE_CHECKING_PRIVATE);
> +
> +       TEST_ASSERT_EQ(waitpid(child_pid, &status, 0), child_pid);
> +       TEST_ASSERT(WIFEXITED(status) && WEXITSTATUS(status) == 0,
> +                   "Child exited with unexpected status");
> +
> +       pthread_mutex_destroy(&sync->mutex);
> +       pthread_cond_destroy(&sync->cond);
> +       kvm_munmap(sync, sizeof(*sync));
> +
> +#undef TEST_STATE_SET
> +#undef TEST_STATE_AWAIT
> +}
> +
>  int main(int argc, char *argv[])
>  {
>         TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));
>
> --
> 2.55.0.rc0.738.g0c8ab3ebcc-goog
>
>

