Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 751A9D11186
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 16:50:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C9266B008C; Wed, 26 Nov 2025 11:50:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A10E6B0092; Wed, 26 Nov 2025 11:50:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B6DE6B0093; Wed, 26 Nov 2025 11:50:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4C2926B008C
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 11:50:12 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D730E1604D8
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 16:50:11 +0000 (UTC)
X-FDA: 84153345822.28.A8354BF
Received: from fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.64.237.68])
	by imf06.hostedemail.com (Postfix) with ESMTP id 732C9180004
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 16:50:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=OO9Qum+W;
	spf=pass (imf06.hostedemail.com: domain of "prvs=4186e4d8c=kalyazin@amazon.co.uk" designates 3.64.237.68 as permitted sender) smtp.mailfrom="prvs=4186e4d8c=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764175809;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hOWpCuTZQXXu+UFDi92tkah8da8iWaYrZywVBBw9cnQ=;
	b=BNbz/Fhx/JDfV9tP+I0pxQsW//XoMBLMB6AdU41DzDNIhWKWC6Vs39gss4FUlnktUhWmFy
	wkNCs7YsS9c+a3HJRGl2cVWL/6e2W20c2RntbQUnDDaK4WFKAbFzqP/yy9LTgdRufV09yA
	wajrtvMF/27A6KUr356YwUqm5BsY9rI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=OO9Qum+W;
	spf=pass (imf06.hostedemail.com: domain of "prvs=4186e4d8c=kalyazin@amazon.co.uk" designates 3.64.237.68 as permitted sender) smtp.mailfrom="prvs=4186e4d8c=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764175809; a=rsa-sha256;
	cv=none;
	b=I3dPkhxqtPr/1jWKB/wrGl34gvAW1jdlG0PbsnG14kBmFoLlgMDyO85ManSKI7uTKXJVxx
	V/xF44JR3VP+J/Zty88+f9drRcNDQfg4FeH6q62rX3mzMryg0eJMt5Wqppo5jx0iSc8I4V
	BDL5c79KUYtn43CRXMfVDubfn7u1ACU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1764175809; x=1795711809;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=hOWpCuTZQXXu+UFDi92tkah8da8iWaYrZywVBBw9cnQ=;
  b=OO9Qum+W80Q35ywAVa8NKTAjDngK1bHGGH0Y8xK0RiE7gGLSyHZaUX0Y
   4O1YXJw56WqRFGTvhqQs3JJggjpg7bNTTbCBAhh/08D293SsL6QL2nIVE
   LFEXQhgW9ivFcKjOnaz/OVHfytvVaw23Igj0gbKPjzInFx0JyOsZKioJ5
   s3SmRn1v6WfPKebA42jc6pH6ofbZ5wj5lEJ89PYfOCG3wygwA/aCpH0wM
   xffSXg6OgmQsfRfMLSLYMt8EbmRl8dAmQJy2HmChXA/xinW4yiNNAOh3k
   s8CzdIUHSIGQSEqgKaV/QtjKZrX6Gv1xGkgvwO4k4edoJRFfs5foJXpe6
   w==;
X-CSE-ConnectionGUID: KZIjcG2CQ6ucnaRhPFfPyw==
X-CSE-MsgGUID: eHrl8mI8Tee2eBv0E8nJCw==
X-IronPort-AV: E=Sophos;i="6.20,228,1758585600"; 
   d="scan'208";a="5751043"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 16:49:50 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.232:17770]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.27.255:2525] with esmtp (Farcaster)
 id 2808e225-d96e-4595-94bf-b76a6f3bfa50; Wed, 26 Nov 2025 16:49:50 +0000 (UTC)
X-Farcaster-Flow-ID: 2808e225-d96e-4595-94bf-b76a6f3bfa50
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.79) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Wed, 26 Nov 2025 16:49:49 +0000
Received: from [192.168.8.204] (10.106.83.30) by EX19D005EUB003.ant.amazon.com
 (10.252.51.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29; Wed, 26 Nov 2025
 16:49:47 +0000
Message-ID: <18b4cddb-3e04-4272-9f04-6857cea70ff5@amazon.com>
Date: Wed, 26 Nov 2025 16:49:46 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH v2 5/5] KVM: selftests: test userfaultfd minor for
 guest_memfd
To: Mike Rapoport <rppt@kernel.org>, <linux-mm@kvack.org>
CC: Andrea Arcangeli <aarcange@redhat.com>, Andrew Morton
	<akpm@linux-foundation.org>, Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand
	<david@redhat.com>, Hugh Dickins <hughd@google.com>, James Houghton
	<jthoughton@google.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>, Michal Hocko
	<mhocko@suse.com>, "Paolo Bonzini" <pbonzini@redhat.com>, Peter Xu
	<peterx@redhat.com>, "Sean Christopherson" <seanjc@google.com>, Shuah Khan
	<shuah@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, Vlastimil Babka
	<vbabka@suse.cz>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>
References: <20251125183840.2368510-1-rppt@kernel.org>
 <20251125183840.2368510-6-rppt@kernel.org>
Content-Language: en-US
From: Nikita Kalyazin <kalyazin@amazon.com>
Autocrypt: addr=kalyazin@amazon.com; keydata=
 xjMEY+ZIvRYJKwYBBAHaRw8BAQdA9FwYskD/5BFmiiTgktstviS9svHeszG2JfIkUqjxf+/N
 JU5pa2l0YSBLYWx5YXppbiA8a2FseWF6aW5AYW1hem9uLmNvbT7CjwQTFggANxYhBGhhGDEy
 BjLQwD9FsK+SyiCpmmTzBQJnrNfABQkFps9DAhsDBAsJCAcFFQgJCgsFFgIDAQAACgkQr5LK
 IKmaZPOpfgD/exazh4C2Z8fNEz54YLJ6tuFEgQrVQPX6nQ/PfQi2+dwBAMGTpZcj9Z9NvSe1
 CmmKYnYjhzGxzjBs8itSUvWIcMsFzjgEY+ZIvRIKKwYBBAGXVQEFAQEHQCqd7/nb2tb36vZt
 ubg1iBLCSDctMlKHsQTp7wCnEc4RAwEIB8J+BBgWCAAmFiEEaGEYMTIGMtDAP0Wwr5LKIKma
 ZPMFAmes18AFCQWmz0MCGwwACgkQr5LKIKmaZPNTlQEA+q+rGFn7273rOAg+rxPty0M8lJbT
 i2kGo8RmPPLu650A/1kWgz1AnenQUYzTAFnZrKSsXAw5WoHaDLBz9kiO5pAK
In-Reply-To: <20251125183840.2368510-6-rppt@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.106.83.30]
X-ClientProxiedBy: EX19D002EUC001.ant.amazon.com (10.252.51.219) To
 EX19D005EUB003.ant.amazon.com (10.252.51.31)
X-Rspamd-Queue-Id: 732C9180004
X-Rspamd-Server: rspam02
X-Stat-Signature: hcy3w44ixkqd1kpn6ododr8tmno4ikts
X-Rspam-User: 
X-HE-Tag: 1764175809-794810
X-HE-Meta: U2FsdGVkX19K6NLoad1Bf1G1WFzQO27DlnD7RrFfAdXkCPMqcw06+odB5nF16wPRK+CPCOmy0auR346cu+5TrUTT3C0o+NLCOPc3kH856vbprq5307u3GjE35rsVcV78CFeEgzgmuBHcgdjipbkOTnTXjTyW3bZmPdHuP85W7C+i9kaQT8syETleIP//XWuaiBCare8PQFRiwB+k67oRLXUmwrHT+ZXA9jh7jvg0lgf86thOWr5x3w5+Beukjpwrl0GeLSeQ5GAgIq81bqjhLOUgoTW6i31H+WpCOm4ZCJREkvqpj/bsKhN8XSQF760r1iM5u0Q3tNr+VG8Rqi9cYu5GIf4P9vJPACpxvUVJ1tzMCi+p2Zoc4lLjwoRQtLmPe0wHXEXBcmAMH05hiDaxfTyIyiuYzYxd0rgh2Y/TpAfxn2DlN3qJpK9un5G6GJN1ZZC25Pv87jt60hmxEntoBS5WdARtGqwU/2DBxWI6Suq2/rvPUGvXm1Gtjp/jXDKzukWeloP8fk+U4BJCRZtSmvVJfOlZuR8p0oXe63Y3u/u0/yWv+VHgUMOPtSpFSERx6aFIZeN7DO2Bz8a5NM+pLFO9F54jsbRg7Y3KQzuwkCnCddG/IqcOmkiK0beGMicecZQMjorLxuVx7HKFiHZ2W19wwQ5nYvLzE1PUKRQ4S0kHND/KNb2OZKa+GrkS7+aS3ameem/BmDC3tt+BYgPFE9tNu4NEZuawb8Q3ueE+6LYbzHHXbUsL1DwBR2Q5fo0OuSxc5LCfBMG6CO6L2u9Cqx9qs0j/0iWBcm+dLJlcrtC7BDif0IXBZsOPCWc6G+rEr/EYsyjAiC4fTM4Ks0bH8+eocboZuvWI8t0wP2jwCoK6AfS46b7jCOJNAa9+alDaS2MzQMyJchXwCQm+vVrtEfbCPdvp/8mzyuzWrOwG4/sdxN9nBQQYFYJQsUJ885ZlERdfotUrU4bZr9/Y9y8
 bTPZ2bcj
 xI7JWRKvNcEcUFWH+AXWj892FIgFJYSPAy+4JphHYMyR+lHGedWS1SRhm7xSU9z5DcWVdH4NExhIxo9Lb7EA7AfaYdN4rzIIuqk0FaQO7lh3DaDsd7rcVaLD64ITDnfYXFRCnzj8ybpiPhHdLGlFqDSXmt+RTLNzmdyV4jw+wwz88ciBeckt1FXS7KCiQg3w38vyS5neGhVVA0zd/yZYJu2snq2FZKnGv5VmcUpjHz6LjoUjycxaRRFmCbF7vRxPTz3CN0DCvdJBvVh13+eNR0/xMv3pINGnkx1Kps9CXWVZLdQuJXkgVaTnP3MG1czKPSx2z6nWSnjsZFXQUJ+Pz9ii4z8ZmpqWbw4lTsozDJY+Uip5KiTyqkS7iEl/c0EZIsa+oFFaYmTNvH3Bu6RseLVfh4/MUdT5RaKJbAk0sa1w+zE4gvnPMydjhMiyaEza68ECDA0SJBqwg3S0ULvF92yIcobk5dV0CZQhCeWcf3edyohQhRoqCL3DStdOI4/HPtfAQsa0xImJwjeRufSLdHdGx7M9QjlpNn2RW2djL4l7svpBoT4TVlHyriMgoIHpI6V0hHBbVrypc/DA+lKwhnmf2P44XjkA+rELN7Ooc1e4tYNmtTYuLLP5h4XcbB7aUqbiQS+IDIsZov4/THCNW931Sul2n3qYzRlQPMDDnQ6ujMkBtW76mbLDAa9ye12geUhNdstLCUxfWdXlggCGXATYqPfiOg91k48Voc8bzFCv5yCTd1wnGh7k56zh9EsoGkE34ZbzzE+y3dKiWB4CGN1GQIuRjIyhjYRkjpiQGaTpVLsyDMRzaJEXbCRkcuEtC5zz5ONEzj+tINF7yWB4QOdhxgahlpEj2lFVQwQOMmJPOWK4/U9ySQasWSHn5Yu+bovMfylAHAhbWVgvMEDZOOWuCX/mwTZlnvls6cYfgmW0rFjibEMdGDRuDNj+WcUx6KFIC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 25/11/2025 18:38, Mike Rapoport wrote:
> From: Nikita Kalyazin <kalyazin@amazon.com>
> 
> The test demonstrates that a minor userfaultfd event in guest_memfd can
> be resolved via a memcpy followed by a UFFDIO_CONTINUE ioctl.
> 
> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
> Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>   .../testing/selftests/kvm/guest_memfd_test.c  | 103 ++++++++++++++++++
>   1 file changed, 103 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
> index e7d9aeb418d3..a5d3ed21d7bb 100644
> --- a/tools/testing/selftests/kvm/guest_memfd_test.c
> +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
> @@ -10,13 +10,17 @@
>   #include <errno.h>
>   #include <stdio.h>
>   #include <fcntl.h>
> +#include <pthread.h>
> 
>   #include <linux/bitmap.h>
>   #include <linux/falloc.h>
>   #include <linux/sizes.h>
> +#include <linux/userfaultfd.h>
>   #include <sys/mman.h>
>   #include <sys/types.h>
>   #include <sys/stat.h>
> +#include <sys/syscall.h>
> +#include <sys/ioctl.h>
> 
>   #include "kvm_util.h"
>   #include "test_util.h"
> @@ -254,6 +258,104 @@ static void test_guest_memfd_flags(struct kvm_vm *vm)
>          }
>   }
> 
> +struct fault_args {
> +       char *addr;
> +       volatile char value;
> +};
> +
> +static void *fault_thread_fn(void *arg)
> +{
> +       struct fault_args *args = arg;
> +
> +       /* Trigger page fault */
> +       args->value = *args->addr;
> +       return NULL;
> +}
> +
> +static void test_uffd_minor(int fd, size_t total_size)
> +{
> +       struct uffdio_api uffdio_api = {
> +               .api = UFFD_API,
> +               .features = UFFD_FEATURE_MINOR_GENERIC,

Should it be UFFD_FEATURE_MINOR_SHMEM instead? 
UFFD_FEATURE_MINOR_GENERIC was removed in the v1.

> +       };
> +       struct uffdio_register uffd_reg;
> +       struct uffdio_continue uffd_cont;
> +       struct uffd_msg msg;
> +       struct fault_args args;
> +       pthread_t fault_thread;
> +       void *mem, *mem_nofault, *buf = NULL;
> +       int uffd, ret;
> +       off_t offset = page_size;
> +       void *fault_addr;
> +
> +       ret = posix_memalign(&buf, page_size, total_size);
> +       TEST_ASSERT_EQ(ret, 0);
> +
> +       memset(buf, 0xaa, total_size);
> +
> +       uffd = syscall(__NR_userfaultfd, O_CLOEXEC);
> +       TEST_ASSERT(uffd != -1, "userfaultfd creation should succeed");
> +
> +       ret = ioctl(uffd, UFFDIO_API, &uffdio_api);
> +       TEST_ASSERT(ret != -1, "ioctl(UFFDIO_API) should succeed");
> +
> +       mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
> +       TEST_ASSERT(mem != MAP_FAILED, "mmap should succeed");
> +
> +       mem_nofault = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
> +       TEST_ASSERT(mem_nofault != MAP_FAILED, "mmap should succeed");
> +
> +       uffd_reg.range.start = (unsigned long)mem;
> +       uffd_reg.range.len = total_size;
> +       uffd_reg.mode = UFFDIO_REGISTER_MODE_MINOR;
> +       ret = ioctl(uffd, UFFDIO_REGISTER, &uffd_reg);
> +       TEST_ASSERT(ret != -1, "ioctl(UFFDIO_REGISTER) should succeed");
> +
> +       ret = fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE,
> +                       offset, page_size);
> +       TEST_ASSERT(!ret, "fallocate(PUNCH_HOLE) should succeed");
> +
> +       fault_addr = mem + offset;
> +       args.addr = fault_addr;
> +
> +       ret = pthread_create(&fault_thread, NULL, fault_thread_fn, &args);
> +       TEST_ASSERT(ret == 0, "pthread_create should succeed");
> +
> +       ret = read(uffd, &msg, sizeof(msg));
> +       TEST_ASSERT(ret != -1, "read from userfaultfd should succeed");
> +       TEST_ASSERT(msg.event == UFFD_EVENT_PAGEFAULT, "event type should be pagefault");
> +       TEST_ASSERT((void *)(msg.arg.pagefault.address & ~(page_size - 1)) == fault_addr,
> +                   "pagefault should occur at expected address");
> +
> +       memcpy(mem_nofault + offset, buf + offset, page_size);
> +
> +       uffd_cont.range.start = (unsigned long)fault_addr;
> +       uffd_cont.range.len = page_size;
> +       uffd_cont.mode = 0;
> +       ret = ioctl(uffd, UFFDIO_CONTINUE, &uffd_cont);
> +       TEST_ASSERT(ret != -1, "ioctl(UFFDIO_CONTINUE) should succeed");
> +
> +       /*
> +        * wait for fault_thread to finish to make sure fault happened and was
> +        * resolved before we verify the values
> +        */
> +       ret = pthread_join(fault_thread, NULL);
> +       TEST_ASSERT(ret == 0, "pthread_join should succeed");
> +
> +       TEST_ASSERT(args.value == *(char *)(mem_nofault + offset),
> +                   "memory should contain the value that was copied");
> +       TEST_ASSERT(args.value == *(char *)(mem + offset),
> +                   "no further fault is expected");
> +
> +       ret = munmap(mem_nofault, total_size);
> +       TEST_ASSERT(!ret, "munmap should succeed");
> +
> +       ret = munmap(mem, total_size);
> +       TEST_ASSERT(!ret, "munmap should succeed");
> +       free(buf);
> +       close(uffd);
> +}
> +
>   #define gmem_test(__test, __vm, __flags)                               \
>   do {                                                                   \
>          int fd = vm_create_guest_memfd(__vm, page_size * 4, __flags);   \
> @@ -273,6 +375,7 @@ static void __test_guest_memfd(struct kvm_vm *vm, uint64_t flags)
>                  if (flags & GUEST_MEMFD_FLAG_INIT_SHARED) {
>                          gmem_test(mmap_supported, vm, flags);
>                          gmem_test(fault_overflow, vm, flags);
> +                       gmem_test(uffd_minor, vm, flags);
>                  } else {
>                          gmem_test(fault_private, vm, flags);
>                  }
> --
> 2.50.1
> 


