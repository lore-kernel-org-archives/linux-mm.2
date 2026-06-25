Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53981CDB47F
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 07:41:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 459536B00E5; Thu, 25 Jun 2026 03:41:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42F956B00F0; Thu, 25 Jun 2026 03:41:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3465B6B00F2; Thu, 25 Jun 2026 03:41:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0617E6B00E5
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 03:41:30 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8B495A059B
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:41:30 +0000 (UTC)
X-FDA: 84917639940.03.181FDF9
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf22.hostedemail.com (Postfix) with ESMTP id A5CAAC0003
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:41:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rNZFQRtL;
	spf=pass (imf22.hostedemail.com: domain of tabba@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782373288;
	b=sOQ+u2WgvRhDALvoUQyQQIGdjHs4eTyzJ0Md0wwZafV9Z033+ssZXfRq0CvamFPIB4KdXW
	dD+5PmK0bnW48wpp2AhulFuf1dxWp/NWXaV8DTXvXixCzWnsd6+jSe8EhqsdMzIaPPGceA
	3iOVdZ92O/1duY8kRDpJNA3XKX5gdsM=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782373288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IKDmrHuQqoBYlM3iNILSe07cr8MVKcj1ghLIbtUqfRQ=;
	b=lHq+MqK3fQYaZfSIXIORsfmMvaXB5ScXAFbw1Qr+b/knDu3Ec5itMoq5OcyxL0YZq0dWI3
	3QQgVbLTmdCA0Kq6VPv7SFG5aKZSX1/xxXVQivMPraw5hm97ONdgMV0PdGQ5bi/qsGGkHR
	wE6Vbv4fRx7iwr513wHz2BBZn46oDAc=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rNZFQRtL;
	spf=pass (imf22.hostedemail.com: domain of tabba@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-5177d1ff061so144071cf.1
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 00:41:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782373288; cv=none;
        d=google.com; s=arc-20260327;
        b=U6EgGYGnrMEEP74btCo026f7RR2E0uygG88dOKgv746nfQX7eKxWgJiZXVrDMtz9Nz
         sZjtvj4Z2jR+o7TU/JnxPyB1KMZ90rX/w10rRpCDWXJOs+dHZBk+hncAXNesGgwrKlWw
         D0pFZXloBzJ1Nbul0QbXhlXPYL7DUDeA8BWTp1JlRIeFiC7AAZTXWKfcu4CX1PJxyjPq
         9VtoX7quEpf8TnY9ZS4JLjfUYHNURVWoL2jIuA3w0Mr+vp/UezObfBPaYutDJIm7vxq/
         DgdJ20o1+MyUki9n9xltYtnml8lZVddq8N0IShCnOPbs7cTvvbQ8heKdO3wG6jykI4Ri
         d3Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=IKDmrHuQqoBYlM3iNILSe07cr8MVKcj1ghLIbtUqfRQ=;
        fh=nOlUOZaL77KoR4U4C1KSKj0nyVm9LPywNDejzu/Ccrw=;
        b=PfZszDsAqLxIAB+AHRS1eVgvk5yM+k4pmjgmSA4iZIJD7QgC37HiVqR2hj2G5Yi7mt
         y1Dz1fnv7EuSR9moXoo2ylcKqF6Dtmei9bZN4YUe9IqzmTk3pR13a79/Kbm9O0FuJMEo
         8ytuFqUEU7ukzbSLtG8mRWn9FaEJKZxHerQTq6UjUhjXgcf9ZCT8qpmdxJ9QpsvMFu5w
         JrXfvu4qLahLVNsBBy/FLji83qrwIowof+q6yKYPWDEDmSunLuZqL3q6OsAEM2i9KIA7
         OYLWV8rTePTt107J0QXmhsoTjIeZoQpSgd7ZuXerDHaDSNCiIvjZtYm7y3T3V/lg12B9
         RzMw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782373288; x=1782978088; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IKDmrHuQqoBYlM3iNILSe07cr8MVKcj1ghLIbtUqfRQ=;
        b=rNZFQRtLwDOKW4LM+HcbYcwQefIFRnvTauZS9gWxg/O0GQnfjRFiqHYh86KoSQMe/l
         9OOGBClfWVyS0OxbVo8GtKheBntm8hfjq5UHUmlRTaUzC7QjIjicL5TN5jQjy63S98DQ
         nDlXLhhPg+JxU3W34Aps6/LVaLzVxeqdZx5brk9Aqoy8ND3fOyR+isD228Dqdx2tvwsu
         G/eyQa9KDUI67+IDef9eQeEZC0xt0+yTnzl9MNTpgSw0EBK/140R6lGUmjvw7HJpNL6d
         foQ9e+vBU3GDEYcyHrcTDOAvvG0EvGxknVpfPlwyueSKsJbw2Ou8+BZExHRHEGKs3NgS
         LVSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782373288; x=1782978088;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=IKDmrHuQqoBYlM3iNILSe07cr8MVKcj1ghLIbtUqfRQ=;
        b=dizoU7YQTPC0J5SwiXgZLhjsW+yEio+KXvYUTuetKEhuukafTioZ5pKmyofLy+RTT0
         Hk17IpgW40rcMiPsQHlysinDwrEFW0pMhGy7V/lYX4k0SPMflXylZgo38dXl3Jab1Deu
         tS+flSzRwn3sZRfTXnbXbShw9TH09qlMl8jVuu0UXlK+lIdW8dtPtAqzst1FPoYJlgIO
         GsnAhjVWrhvUAJVaooj+Nu0peItZ6oV2vwsooDKz4+J5+P9H0T+JJ6Ra0iR/QGBPaxgl
         u5cwf9GCDoGdODRlj/yyi3w/B8gTq4OEKCcYtsYWoUNsibMAV4S8vj/lyzhiJ60GrN/b
         BY6A==
X-Forwarded-Encrypted: i=1; AFNElJ/GFIJeNq9bTXlqaYNJVIY5oB2Headp0WVPkeVxhA8I+bMjHuzangqskafWvEkk/ZYVdGukHrX2Eg==@kvack.org
X-Gm-Message-State: AOJu0Yz/vQQVeIDruesPJFreevehomL8+rKFRztxji44WYq5n8WqUF+N
	p3kqOIJ7pbjkOzNjqVMXklU0InnMphaG3Jq7VFaJm5CWDi3bEft9PHbJoUG8S+5Rr1YJBCP8+Nm
	Y7sQHUpxORtF1xQGwG/ZppCgQVhtDEh11hScBhdfd
X-Gm-Gg: AfdE7cnvR6roftZOtGSC6KNgbKT/nsO8xbGVTANvb4WUlt9Hkoaq79znnhpgj3Ahp9l
	64MwauKm0JmtdrGsBLvxjIqxO2zvTXvZCJ853g1KY+dduUTpw1s4zHJ8qhT4UbdWwrO5ZacFRHf
	nKcxEn/z/OTgtVxh/qdDMjtOXbpdZnV4+VBkDhTTTD5AUmZ08jJYSjx9ItC69l8lsmWhCh5VV/Q
	Ebcu3UkSXoSbeBPMgukDg5rDRiCmGo+NBtYU+2P9bAK6qjtuGKDVSawrZIsAzOf0dQbqR1pKQ==
X-Received: by 2002:a05:622a:120e:b0:519:56a8:2693 with SMTP id
 d75a77b69052e-51a6ebae001mr6553451cf.24.1782373286970; Thu, 25 Jun 2026
 00:41:26 -0700 (PDT)
MIME-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com> <20260618-gmem-inplace-conversion-v8-38-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-38-9d2959357853@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 25 Jun 2026 08:40:00 +0100
X-Gm-Features: AVVi8CdNvXe7DIQJSIUqqBW3OCX6JP2NJsxm61_dCUo-WV2w6fSxq-mU03dKtt8
Message-ID: <CA+EHjTzEGxZQXPPsY5nynYf6ts+Jt3TBevgLpPVyHDqf4i7RGw@mail.gmail.com>
Subject: Re: [PATCH v8 38/46] KVM: selftests: Add helpers to pin pages with CONFIG_GUP_TEST
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
X-Rspam-User: 
X-Stat-Signature: c5hzx3ewopjgwud4ab5rrmqwq1u9tyi9
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A5CAAC0003
X-HE-Tag: 1782373288-37999
X-HE-Meta: U2FsdGVkX1+h+pugNQL2wLC2T1MbLx9O3Z4zFUUZ0VYqP2sXElsu7BtSo6clpVjNuWchiiT1VoEoCFuDF1F9wJgWlZoBR3Bmka5M3cXDpISBRZjHA93eaIfsN2gKu6W8QcOLDj3dLKoEmIQzXekHPZKKj0sYOeEW/v8CXFH293psxJO36eEPIn3LtdmwJ1NNPGdXbRR6ktD5u+tZ5g5aqjLl2ATFZCu0c97E3FJ/8Wv4RXHhVe/odV79yvJlwFCCF7ygz4UE8rl7h3TAQ5b9zfQgUFG+rqPiX4mVZOzWLz0jfDe7q3KBLcz9lvTJRdxgo+S3B4C7a785Zkv+CcBiQWZt4nFiMJrsYFQ/YbbfVg9PireLUe2Db0G/tJb9TvTw+5IcZ+E7CGGawB1AFsLoTv2aAQ/FHPQyy9dGOz7uMoTw2ghBdiLybdyqJA3mvNvQAZ/sSx1v7N9CqTtyeYELl+N9MnNZH/iEtmJtk/GUrdpYHw2dl1skbkd9Q8s5IU6UbrmG/2T7pHTV1XSu04tYsDFPbeCnRrVDTXUz1mXePeX+lFAVIUWinJ1MvyOMjMaW+AnMU8j4HyJmNEqVzRcT92TFJMxKpo7lOhQPCsVvS8Q8uwKwLyORdiklVcghDcacS45s1mwJjseIacjdKsxf3v7axBT7sryQNSXL4ocuCO4YMjztI4RHVW0VWOFayNVpKcTPNzVlC5UITvLENeg77G7vODTLm5w/MSczsYcASWlKVDe8XA5UhoyAAEq2jCB4VnFMQ3alUHRzP/wnGG9wGzQilXVQOECxHfnJmpNAXvmI5GrJSuwaG+BZHVUYKD4u5YRGVg1YCNJ1plGcFotMzu0/cqkqstqpghD0s/mIw3MB0jBWAeQCVaS0bJcWwx5hYFZU0o1yvIDXOo/cTu20WTTOi8pV4pKeb91t3EXPaZQYpu/ajY3IHbmW2i7pgbeMSw3IYCaCSWFluQ0vpBs
 qJuFtGiR
 hY31JHn4DjltJ5FL1gf+oEOYdS6ETBNIvpz36Z2xpP2NK0FbmHPtNdRDjl2azmkV/vUZlzxXTv1T/L2nmtGCB3WGwOww4a+VOZEEJENo/aQ+oorO2S+oeeP2zynnigdeYG/6FN/WDc8vvrl4NvEpi/cgDT1Z/n1WjJDN+/FiVad4M2ZoOYqtHFR1GSqA565T0V6qp5HM7Z1fH/aogyCCkEFgyeB2vXTHE7OqBxl28LnBzlDEi+U7MxaZMfTXJaJxuGaWOQSuGIrMVxQPJl24GdzcfNVbhJRYIfl6YppBJb6aRi1LbLqhPPPugmLxucEJTZ0jVUmgKP1U7Jug=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 19 Jun 2026 at 01:32, Ackerley Tng via B4 Relay
<devnull+ackerleytng.google.com@kernel.org> wrote:
>
> From: Ackerley Tng <ackerleytng@google.com>
>
> Add helper functions to allow KVM selftests to pin memory using
> CONFIG_GUP_TEST. This is useful for testing scenarios where some page has
> an increased refcount. such as in guest_memfd in-place conversion tests.
>
> The helpers open /sys/kernel/debug/gup_test and invoke the
> PIN_LONGTERM_TEST_START and PIN_LONGTERM_TEST_STOP ioctls. Since this
> functionality depends on the kernel being built with CONFIG_GUP_TEST,
> provide stub implementations that trigger a test failure if the
> configuration is missing.
>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

nit below, otherwise:

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  tools/testing/selftests/kvm/include/kvm_util.h |  3 +++
>  tools/testing/selftests/kvm/lib/kvm_util.c     | 23 +++++++++++++++++++++++
>  2 files changed, 26 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 323d06b5699ec..79ab64ac8b869 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -1195,6 +1195,9 @@ static inline int pin_self_to_any_cpu(void)
>         return pin_task_to_any_cpu(pthread_self());
>  }
>
> +void pin_pages(void *vaddr, uint64_t size);
> +void unpin_pages(void);
> +
>  void kvm_print_vcpu_pinning_help(void);
>  void kvm_parse_vcpu_pinning(const char *pcpus_string, u32 vcpu_to_pcpu[],
>                             int nr_vcpus);
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index b73817f7bc803..524ef97d634bf 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -18,6 +18,8 @@
>  #include <unistd.h>
>  #include <linux/kernel.h>
>
> +#include "../../../../mm/gup_test.h"
> +
>  #define KVM_UTIL_MIN_PFN       2
>
>  u32 guest_random_seed;
> @@ -639,6 +641,27 @@ int __pin_task_to_cpu(pthread_t task, int cpu)
>         return pthread_setaffinity_np(task, sizeof(cpuset), &cpuset);
>  }
>
> +static int gup_test_fd = -1;
> +
> +void pin_pages(void *vaddr, uint64_t size)
> +{
> +       const struct pin_longterm_test args = {
> +               .addr = (uint64_t)vaddr,
> +               .size = size,
> +               .flags = PIN_LONGTERM_TEST_FLAG_USE_WRITE,
> +       };
> +
> +       gup_test_fd = __open_path_or_exit("/sys/kernel/debug/gup_test", O_RDWR,
> +                                         "Is CONFIG_GUP_TEST enabled?");

nit: should you close this/reset it to -1 after the tests?

> +
> +       TEST_ASSERT_EQ(ioctl(gup_test_fd, PIN_LONGTERM_TEST_START, &args), 0);
> +}
> +
> +void unpin_pages(void)
> +{
> +       TEST_ASSERT_EQ(ioctl(gup_test_fd, PIN_LONGTERM_TEST_STOP), 0);
> +}
> +
>  static u32 parse_pcpu(const char *cpu_str, const cpu_set_t *allowed_mask)
>  {
>         u32 pcpu = atoi_non_negative("CPU number", cpu_str);
>
> --
> 2.55.0.rc0.738.g0c8ab3ebcc-goog
>
>

