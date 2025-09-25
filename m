Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02175CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 21:35:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C8558E0002; Thu, 25 Sep 2025 17:35:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 279048E0001; Thu, 25 Sep 2025 17:35:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18E898E0002; Thu, 25 Sep 2025 17:35:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0943A8E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 17:35:25 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 929461DE731
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 21:35:24 +0000 (UTC)
X-FDA: 83929078968.12.B864A30
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf05.hostedemail.com (Postfix) with ESMTP id C762D100005
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 21:35:22 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lcs333zi;
	spf=pass (imf05.hostedemail.com: domain of 3mbXVaAYKCKgaMIVRKOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--seanjc.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3mbXVaAYKCKgaMIVRKOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758836122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dyD0NvHQvKcjtkMWqtARFSwsGpym7n4r8JiRe/0tuUQ=;
	b=uw5ishBlijxtoI/JcP8lo3j1WOVHuA/KTldMgie2CABZSt/aOoxarmC6DrnkR35d1jRGQ4
	jaGvG+zfRmLArD2ZiEsriyfBnke0aoupcTUaO9szmEnw/BK4by/XDDH3PwKEUUfRVLvqbs
	ViWehnDjUHGvw+c7pXWwRjTwDKbdHyo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lcs333zi;
	spf=pass (imf05.hostedemail.com: domain of 3mbXVaAYKCKgaMIVRKOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--seanjc.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3mbXVaAYKCKgaMIVRKOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758836122; a=rsa-sha256;
	cv=none;
	b=ZnJolU+QiLZIKX/iM8wGiJYlTCAfa49eDxeaz34LKed4v9pwEJc5EvDBFu3cDNazkhbzyY
	asdBPgBBvXWueSGCBfXxvphVwhzB5tCITWsdHp6z4zImAVgMBxc2vpRyaKFBq1Spi+1idt
	92UUu9JLAPWg9IWfDSrcI8++GVaWXEY=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-33428befc49so1458624a91.0
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 14:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758836121; x=1759440921; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dyD0NvHQvKcjtkMWqtARFSwsGpym7n4r8JiRe/0tuUQ=;
        b=lcs333zi+Zuzz2wnGbZNplQw42sHY1Js9l0G1shWTe/uuwVqzU8HmuPuMT0FpncQve
         SF5BlbpNiczW9Gzi4Cle//57B+TIozS244mqjOpzI531jebRLqeW4bKZXVm5to0eCBWj
         ocJ/ry4Jsthhuym9FFvOf+CkV7wrJxRN2CgFv+lX2k4G/N2dotvAIyAHQNxIBt7iawBt
         g0w5DUK3nFPqUdH+lalyULscaUagzVfkMP7Y53lu492VtIpoKu56BQI+2o4XvVF6FGld
         YaRVLCBRzDGV3OGXGW9l7wjKZI7r9S8nBuIRboJGwMDs4ShqSyetRPy324CQQWflE4nR
         rezw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758836121; x=1759440921;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dyD0NvHQvKcjtkMWqtARFSwsGpym7n4r8JiRe/0tuUQ=;
        b=Gpl7+xBdDYp9O0TID/ZwZbokbPnjnohYFu0JUehK89JwBF0MlKYgNYFqPsAAN6VqxM
         heMzHQWrSYlKCsOgpSEpO4qzgl4DlS1PE21gMUWMnTNEtt4DNbRrXHcQCLMfJDYVwXY7
         tu1V3uGBQOrmUai/35h+o74WVYXd9uKXDgUlH5oSjCIw36FU9mp0PAHyK4UijoRrfb/p
         JSudmLie4BLXUEkFVHfyiYL8/VU/6VQkFG3cuZJMOga4mtYaAMpnNX+qPNEj9/yLf3DR
         ljhujnBrThM/FqEppaJS3kg0UP7JJOsY7S7kiw2Olqcw37gb85c0chw0oAtCoYD8YP7T
         HMhA==
X-Forwarded-Encrypted: i=1; AJvYcCWmPDB/oub0cT1lDkB8eMmIrpi6ehS05r/fAxNjxHmsqJdVs385JYTgwwguSTQTK7GXBrXrhGKpDw==@kvack.org
X-Gm-Message-State: AOJu0YzfsU1Wl1tMEuTUN9x3aZ7NGFfZqslOPfKWwUarW2+4vAB487pT
	gu0A6fX/d/1sl8hTXFaPy00k0Hd0BBg33OQNYz/yIQZ5O6O92NFtccXvNh9QoL59+0Cllkkf9hB
	QYbKG1g==
X-Google-Smtp-Source: AGHT+IEF46Ap3+CoFy4DNwHeeqPSdM0QIu1/iWB0NVseFrH0JqhT9O+vdtR7XjCf1sCWIaN5eWCQMso96V4=
X-Received: from pjj5.prod.google.com ([2002:a17:90b:5545:b0:330:6cf5:5f38])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c07:b0:32e:ca60:6bd7
 with SMTP id 98e67ed59e1d1-334568960d8mr4094341a91.11.1758836121051; Thu, 25
 Sep 2025 14:35:21 -0700 (PDT)
Date: Thu, 25 Sep 2025 14:35:19 -0700
In-Reply-To: <20250827175247.83322-10-shivankg@amd.com>
Mime-Version: 1.0
References: <20250827175247.83322-2-shivankg@amd.com> <20250827175247.83322-10-shivankg@amd.com>
Message-ID: <aNW1l-Wdk6wrigM8@google.com>
Subject: Re: [PATCH kvm-next V11 7/7] KVM: guest_memfd: selftests: Add tests
 for mmap and NUMA policy support
From: Sean Christopherson <seanjc@google.com>
To: Shivank Garg <shivankg@amd.com>
Cc: willy@infradead.org, akpm@linux-foundation.org, david@redhat.com, 
	pbonzini@redhat.com, shuah@kernel.org, vbabka@suse.cz, brauner@kernel.org, 
	viro@zeniv.linux.org.uk, dsterba@suse.com, xiang@kernel.org, chao@kernel.org, 
	jaegeuk@kernel.org, clm@fb.com, josef@toxicpanda.com, 
	kent.overstreet@linux.dev, zbestahu@gmail.com, jefflexu@linux.alibaba.com, 
	dhavale@google.com, lihongbo22@huawei.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, tabba@google.com, 
	ackerleytng@google.com, paul@paul-moore.com, jmorris@namei.org, 
	serge@hallyn.com, pvorel@suse.cz, bfoster@redhat.com, vannapurve@google.com, 
	chao.gao@intel.com, bharata@amd.com, nikunj@amd.com, michael.day@amd.com, 
	shdhiman@amd.com, yan.y.zhao@intel.com, Neeraj.Upadhyay@amd.com, 
	thomas.lendacky@amd.com, michael.roth@amd.com, aik@amd.com, jgg@nvidia.com, 
	kalyazin@amazon.com, peterx@redhat.com, jack@suse.cz, hch@infradead.org, 
	cgzones@googlemail.com, ira.weiny@intel.com, rientjes@google.com, 
	roypat@amazon.co.uk, chao.p.peng@intel.com, amit@infradead.org, 
	ddutile@redhat.com, dan.j.williams@intel.com, ashish.kalra@amd.com, 
	gshan@redhat.com, jgowans@amazon.com, pankaj.gupta@amd.com, papaluri@amd.com, 
	yuzhao@google.com, suzuki.poulose@arm.com, quic_eberman@quicinc.com, 
	linux-bcachefs@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C762D100005
X-Stat-Signature: tp9gz196c3yea9mzhrg4rittq4ikq87h
X-HE-Tag: 1758836122-851372
X-HE-Meta: U2FsdGVkX18hrvMe/4uUlQB7XY7tpcph1fzsSQNQHlnR8YNU/mzKgYbnTtyebAmAO0Le+a8RLlvT+DSUwVR2FnpWrJK9YIn686t1d+jx1aTcbeUdgjvhKVuH7G7HSKCL9+BWT8m9GLmXi7ne7yxq0Bng+znEYrLp20k1RSts5g5Co2lQ5una57XUg1iD38z9Gbv1GhTgknEPmzEgR/c5sfYuAvw75YSx158ieO2/+DDC7JkygBqb0IrL05sDBdW0HHrIY6SbSIE1Nk0J8aJHYh2njeZgvMCz5+Hx+tYn9tZKXLirZHr1+HbdU4O1dbrOMVuntdUPqcXkV5wusUcBH3n3m4+nPh7DWoF3B1nEbiQk2eiy8i0aAJUy8S+D3fqUNs2Yq/1uSPT5OoFhYP8CYnkdfwPjm2JSbJ+z1FM8JC+1IoxEtu46aGd8ew9847mAbMkSEcuwNsIeSaDrYnBuna9cBxcFcp1AVgyF44+UWEYSQ+B6JVmtPXWWTmZVuCyaVwlbgr8lpA0sd8mSChY0oB4CosG84CQze+3fq8g+1QoFUZcMTRDes+z7xEXTM9PU+3RKFVwEuydOAzeMhud8VuAvhyZZz0/SF7cmIGC0BM2xEKInnnF4ThRfEOKN0zNKDoeQ9tTHuIFkGa2OzWaHXOXYQ9te+m6UOdvLqUmUQRuxFp+ELTEcJ9cZTtw4UM+Is4k4wLZkzyGk+aV8c2Tn6BTQpla+TK5PsdzLpBCKYui6c3ikSzsS8FOH+/zZ4hycprvUTIG+PxjJoVwpaYFSj/pQSRP3FOWqKd3/keTSc4bEiPCIM4gSN0hdKRv8iMLLfaxI/YRLaSW3s+f5zyExzTtkmfjEWcmOwv5fFiQh3xfxxZcYwaepUENOP7bI0zTOlkw8UbiViwiNvrMCtFfvxsH6dj5uTuvCPlOCPoO6XC+ik5HpRzjnxRRrXqMnSj3nD8EZmaRCh8OE0EVooD8
 qEppRt/A
 /iBnsdYAoW/nW+rjhFEnxcpmQ4cvgansGK6j5MXP4Ew4l6cVoCzKxADAaR6AtAA1eApqa0Jutd0s9hAMA/VbV5+Nzbc1g4NSH7L4KLvWfquVVpnP5Bmfs53Ox0S1l2Sr0JoEHEJZkoLyZWZJnpNdf9k8/eRR0ew+F4XyBWO6nay67ibaHOarB+EYKHB3aJYfSsJqCyBuKhBAs8J4FFjSbW6saBlTHw5z1pG/clm5KQNBdFOKromtTjL+JET1mTIbfnEAwgLpW5oEcTtWalgfkARuV2wD/TwllnkZzDNVQS4ihLWjvDQcFtxwQsgaZ9crQmStrl+xJqaIfxGYU+RN+MoRgeeUJvEqInuc7tkZ4L3e6TBI7NdE6snCQ0h8xk3k0QkEReqxcBtHY2KWLkHBCDLzZnCOHNRdC2nvjEuCQXNwcbKa5oRqyoHw27s/Dh7a8oAO0CSZm28Db3ENQCN/7zAzEgrYRYMA0B2nbOofDVcdcgl4otTJdapWBkKM3dyEUfjXHaMzKWqBVt7xkjelUxQjkwMa2kUJt+YH1VDZ1SInhBj0TIC3x+Na/6lKT8X+OuAaAQn07tj3XgwcGQNdT4e5QpCQDtsi5U9YoFpyqPs89DLZsYUpU/eC+ylbXWYALUSlRE9keHMZhdRIF1tVez6P9keZxev2yJ71f9MwIHobAM3bHCDYYq6CzJtolo1yVJqVBDsPXFSdhSQFpkR2HVsoV3WL9mxzeO8pq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025, Shivank Garg wrote:
> Add tests for NUMA memory policy binding and NUMA aware allocation in
> guest_memfd. This extends the existing selftests by adding proper
> validation for:
> - KVM GMEM set_policy and get_policy() vm_ops functionality using
>   mbind() and get_mempolicy()
> - NUMA policy application before and after memory allocation
> 
> These tests help ensure NUMA support for guest_memfd works correctly.
> 
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
>  tools/testing/selftests/kvm/Makefile.kvm      |   1 +
>  .../testing/selftests/kvm/guest_memfd_test.c  | 121 ++++++++++++++++++
>  2 files changed, 122 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
> index 90f03f00cb04..c46cef2a7cd7 100644
> --- a/tools/testing/selftests/kvm/Makefile.kvm
> +++ b/tools/testing/selftests/kvm/Makefile.kvm
> @@ -275,6 +275,7 @@ pgste-option = $(call try-run, echo 'int main(void) { return 0; }' | \
>  	$(CC) -Werror -Wl$(comma)--s390-pgste -x c - -o "$$TMP",-Wl$(comma)--s390-pgste)
>  
>  LDLIBS += -ldl
> +LDLIBS += -lnuma

Hrm, this is going to be very annoying.  I don't have libnuma-dev installed on
any of my <too many> systems, and I doubt I'm alone.  Installing the package is
trivial, but I'm a little wary of foisting that requirement on all KVM developers
and build bots.

I'd be especially curious what ARM and RISC-V think, as NUMA is likely a bit less
prevelant there.

>  LDFLAGS += -pthread $(no-pie-option) $(pgste-option)
>  
>  LIBKVM_C := $(filter %.c,$(LIBKVM))
> diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
> index b3ca6737f304..9640d04ec293 100644
> --- a/tools/testing/selftests/kvm/guest_memfd_test.c
> +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
> @@ -7,6 +7,8 @@
>  #include <stdlib.h>
>  #include <string.h>
>  #include <unistd.h>
> +#include <numa.h>
> +#include <numaif.h>
>  #include <errno.h>
>  #include <stdio.h>
>  #include <fcntl.h>
> @@ -19,6 +21,7 @@
>  #include <sys/mman.h>
>  #include <sys/types.h>
>  #include <sys/stat.h>
> +#include <sys/syscall.h>
>  
>  #include "kvm_util.h"
>  #include "test_util.h"
> @@ -72,6 +75,122 @@ static void test_mmap_supported(int fd, size_t page_size, size_t total_size)
>  	TEST_ASSERT(!ret, "munmap() should succeed.");
>  }
>  
> +#define TEST_REQUIRE_NUMA_MULTIPLE_NODES()	\
> +	TEST_REQUIRE(numa_available() != -1 && numa_max_node() >= 1)

Using TEST_REQUIRE() here will result in skipping the _entire_ test.  Ideally
this test would use fixtures so that each testcase can run in a child process
and thus can use TEST_REQUIRE(), but that's a conversion for another day.

Easiest thing would probably be to turn this into a common helper and then bail
early.

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 9640d04ec293..6acb186e5300 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -7,7 +7,6 @@
 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
-#include <numa.h>
 #include <numaif.h>
 #include <errno.h>
 #include <stdio.h>
@@ -75,9 +74,6 @@ static void test_mmap_supported(int fd, size_t page_size, size_t total_size)
        TEST_ASSERT(!ret, "munmap() should succeed.");
 }
 
-#define TEST_REQUIRE_NUMA_MULTIPLE_NODES()     \
-       TEST_REQUIRE(numa_available() != -1 && numa_max_node() >= 1)
-
 static void test_mbind(int fd, size_t page_size, size_t total_size)
 {
        unsigned long nodemask = 1; /* nid: 0 */
@@ -87,7 +83,8 @@ static void test_mbind(int fd, size_t page_size, size_t total_size)
        char *mem;
        int ret;
 
-       TEST_REQUIRE_NUMA_MULTIPLE_NODES();
+       if (!is_multi_numa_node_system())
+               return;
 
        mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
        TEST_ASSERT(mem != MAP_FAILED, "mmap for mbind test should succeed");
@@ -136,7 +133,8 @@ static void test_numa_allocation(int fd, size_t page_size, size_t total_size)
        char *mem;
        int ret, i;
 
-       TEST_REQUIRE_NUMA_MULTIPLE_NODES();
+       if (!is_multi_numa_node_system())
+               return;
 
        /* Clean slate: deallocate all file space, if any */
        ret = fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE, 0, total_size);
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 23a506d7eca3..d7051607e6bf 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -21,6 +21,7 @@
 #include <sys/eventfd.h>
 #include <sys/ioctl.h>
 
+#include <numa.h>
 #include <pthread.h>
 
 #include "kvm_util_arch.h"
@@ -633,6 +634,11 @@ static inline bool is_smt_on(void)
        return false;
 }
 
+static inline bool is_multi_numa_node_system(void)
+{
+       return numa_available() != -1 && numa_max_node() >= 1;
+}
+
 void vm_create_irqchip(struct kvm_vm *vm);
 
 static inline int __vm_create_guest_memfd(struct kvm_vm *vm, uint64_t size,

