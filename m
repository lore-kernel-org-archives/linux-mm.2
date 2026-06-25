Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 878EECDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 09:30:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76F166B00AA; Thu, 25 Jun 2026 05:30:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F8916B00AB; Thu, 25 Jun 2026 05:30:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5995E6B00AC; Thu, 25 Jun 2026 05:30:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 276526B00AA
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:30:12 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 91DD14065B
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 09:30:11 +0000 (UTC)
X-FDA: 84917913822.05.B3C7A50
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf04.hostedemail.com (Postfix) with ESMTP id 94C5E40002
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 09:30:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kiPaRTa2;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of tabba@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782379809;
	b=vVFtkmrVIP0NKDhE90UxD1TsUvLJs2m8TpAbE3VaB6CbBhqQiNzroavO9+FiQ3hSFAtQzX
	crRolMjTjoPV+94sl+VOmnOA4lgMHpq/bPjwRxUlP24gsYOq1zzxLAoMFunDYuEgRIq1Bn
	Z7OX+sDNKIINsU2ss4fgkE3XNVpk+Fg=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782379809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HWFN45t67ilSUVNbHIGobHGAf81p04HluCZmKDev2qM=;
	b=vmp2qARiQkHqH4T84TWQeMK7WcqD4BdOSVsd4zAqQDoaWiWbYHFUwIXglvjwEc7s6D+ril
	dU/uDiitFH6BxEkGPdNqLDsObjdHEZ+7b8r84DdMVcSki6UNAnEwCC2eBfeTBQqKqGUtuz
	yaktvpLJ6TUQhPxptnSJqhCIZCIXEJQ=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kiPaRTa2;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of tabba@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-51765531803so197501cf.0
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 02:30:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782379809; cv=none;
        d=google.com; s=arc-20260327;
        b=DkiyXbvdrZZrqCiSJKVpnsooppwIgsRBtt0wVjsXdSxB4gJ2zgwX5o0Gbqf8zJc+/C
         4cOf4MHLs+DWZY7TOy7VyOfGSl6Kcj51gDwqB2otxdRHWeSdbPHH0Bm55qRuJ19hteZ5
         rgDGWHQvu6pPAh8Ayx+fF728GacdaQm9zMyqnDHLPCCz8uoTaJOBCDii8RwrjMkM/nQw
         bCWKuIFFMqjWzlVdf0fjXE5CltdxJ1uUcaq4ZuSZipgIhOZrcCGAnIUvUvP3JIISvRJb
         KPKTgzd0UM5s/uIeK7tbWmPoIxkeRtSURxmDYjRrAXINS7JAPptiuHAry2b1G5WpV6mt
         UxYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=HWFN45t67ilSUVNbHIGobHGAf81p04HluCZmKDev2qM=;
        fh=hV3jx6aP9rCIXLUOJ8fBGC4lJd5TW+17HBaKH0hWDJI=;
        b=briJ0LqqDZT5/mza6XAogWmIjJiBsEKxwVv3hzDUrkBUvthfx8JR4McgFbMN/ZF4q9
         +QPduJoXuisFZjPKi2hQmnAPZK04eqUqIAGFAe3ZjZE7XP4NzitkA0fCByecv9m5QCuF
         cKCP6TeRlu6sfaYstX+e+k1Of3s4omYqe8Zf+HmWFm4cQazpRnt7h9JDFRYM6T9a3U6J
         /tcuKCm7KakGSVGyFBiyeoZFgINLjsXDuAslgZ6igaUWCeYP6a50/75CCjILOaIgQq/+
         aDJA1I0JxODFo3bIed7mVkNkBo1u094+SZDKge3bfDuuUPc7wA1/YjUhzgFh3NkIGFmW
         YFAw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782379809; x=1782984609; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HWFN45t67ilSUVNbHIGobHGAf81p04HluCZmKDev2qM=;
        b=kiPaRTa21wsek+HUTPe5FJF9xRvN4yaHxn5NP2+meahJDNeH8xeqVZDUExuQXqi0WD
         bhL62HXf+W18J5/WiDpEFO7tw/jZjJdR7SLbWXXaqeMoEMcLxrSOAoECGE/ZViYInBsw
         nLYpOpnj1aSYM7udDTiD63GksJn0w7EMhaTcia8NGK1q75yyKXS/j8naG+IWDi6XK1Ex
         6PP9eXiRshTD2nHHSTFub9LFvDga2jka1WWNTa4rT+9nGHzN0CiK2Lj7bhazVmbFMGAN
         gPKWij/vVVZvlo7+gaeDYMlOzbolOA1Dpl1EFBidOVAvddE2034kTFYiN7CD6LQgHW4o
         O77A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782379809; x=1782984609;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=HWFN45t67ilSUVNbHIGobHGAf81p04HluCZmKDev2qM=;
        b=Gf2ozUxuRWeTKYh/pMxPdh09ZouU9NEBUqgA8gANWI80mfnZOWXCgTxCMiHFt+xWzY
         WbRR9M22EhXwNFzYZ+4Z2qfIflnLcDH09rNO2IMaN0looF/MKmKQeCuQ7D28gJYitumo
         m9wbvrO0t2iMNNGfdm9zpIcyd9OVCtcnQu2yi6prY7sCw/7yLSiU4ZaLmQCY6VFAYZyW
         bH2C99Jz/a3GIKSAcqem6qp2wSn0hLNP7xx6IQKR2diHlvIIVjPss5wq0jFq8nJvaQGJ
         Ta521gKINpd4g8SDs/ZqdocHLBh9uaJA5TddTP94a09LBhwz4qDSvOxYrw1r9acAS6tn
         Va9g==
X-Forwarded-Encrypted: i=1; AFNElJ/TIIzVHHo/AMPAq95nshjIFKC+WZ08ZuiNbINgh3pNauOuBbruXjvUUEmcwu9FK8jVwNKQQ7T82g==@kvack.org
X-Gm-Message-State: AOJu0YzC1SZSJXr3DJoAaAyGy5tzHD2rAKAQf1OHV0YO98yXyVu8/9zk
	c7xg93EBOBSachxQnEtOSeJMVxHmGKlGo1bwso62GZPHsD6rbTPA1i8dhd8RFrHyyUh3IrE8ts5
	SK1BiMHXa10Np/E8d3XKlmZydEL+FSxgPgz1Zdljx
X-Gm-Gg: AfdE7claCUuS0G+rrXNT7bWA4F/RrskAYO1y+w5ScnJOTqSt+LyJB/4ZQxVA1om/JFZ
	Do6VOcMSmKUc5/hxRSdiCt14BeluwyKXecyLu97bzjIeKaW/hafE9opDK08eNo1PbyA+wgZBFU8
	9I2CvO3gdkZ/zK6ZvMc9H1VNchHw/3B2RrZAWllxXYu4EjJO9ResgGm1HZ67p1BaA79tMEeZROK
	/fgmf3NBhG3P1O8rzWitjKz8GyKJBPowAdni67XnbskpTtRaudjuSYtDAQKN6dlQRWDRUTcGA==
X-Received: by 2002:a05:622a:228a:b0:517:5e32:2d14 with SMTP id
 d75a77b69052e-51a6e9a113bmr7270171cf.10.1782379807934; Thu, 25 Jun 2026
 02:30:07 -0700 (PDT)
MIME-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com> <20260618-gmem-inplace-conversion-v8-44-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-44-9d2959357853@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 25 Jun 2026 10:30:00 +0100
X-Gm-Features: AVVi8CepKPjvM3Enq6RbicrK2LVKri7rowcdAQD9hRsLWhakG_kPU-ncpztrsII
Message-ID: <CA+EHjTzL4yfp2mUqE+_FdoDLVGdpdh8Gy+gAwe3FvLWXwkOFog@mail.gmail.com>
Subject: Re: [PATCH v8 44/46] KVM: selftests: Make TEST_EXPECT_SIGBUS thread-safe
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
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 94C5E40002
X-Stat-Signature: 4wrm61q6qsp6gqo1fbohepopconz5afe
X-HE-Tag: 1782379809-925060
X-HE-Meta: U2FsdGVkX1+Pru3Qa84bUT0gMCrqmYJiNNn2QE9S8iXQedFS3NYH/71h87hAGR5TcXcQsWdrtAmlTczB5SEdPrtLZRFYCPm808AFMp9XsPHsfO/pWFd9dMG/03bSj0ijs+/E7EWJPyoDph/IQBZ/hUSClbPsw6OCJAoX/8LWf3SHgI6W4SdK5L0Z/J88CHR/6IP81FSDDHwVFvybKjG9AdnkHu6N/5iH6YuWuZqPRdZAidPRaWYqFj6ROHc8vJf4q0hCgd0ZilW66tAHFGrabEUDmZfUtGJjBMdGsh5Mc2wprtDMqfvg/ZWHtaMWg0wh34Kx/v2gAhi533rnlGX1Q/H5qoraI3Pv4/pwGa5pxDzU88C04Vgct88yMdZEBYnb8WTFvOpAavuov/MONbg3/DRPsvgP48J/pZzE6LDg5FgslQKWX40iddaTPwJlV6GhZzzZmVVTw63VFKPNTavNdaGrOgNUq37V1eWFaiGw9bIjEkkp9B+umWwwpROqrPZUtFb3teGWMRyYH/tHqUS1tzGrQHuNZy6S9CkHbfPoD4i8AZxMBaCPNYIGV6KYVLFOfL50S7ZCEiQfQ7q9+WzSxAahFsMrX7YdTpmCnL/23DvCkf3gvYmxdIYn4HVCVYQTUMEnmQQ3XZOAs5J6C90UvjtWpz4w2cILiu2PNseJI5cMmHrrrqAzXXprG/ucD823sOdSQ87l0U9ZVJw7DXCnW+RNPTDY5acu1sbkMGQmpXalukaiKv+dD/ke4dEPfXtXYSISmG0Oih69WknxMINvKLr6WadeyG6ZMNlxyNP/Ohqd2XSVahwa5OcgTEilJ06fcyHZY8cCZZksXOoNcx0jI4bCLC1MGhgHbkYlR2bAwfedOCZMPAyDGmd3hT+byP1Zb/2HU27x0DRBgIj4br2A8O2Z15QyE7szjGp9/utYaROKF1gpdA+JoZBYwfVnBLOxcMDSQdUPvu8fR8jQN0O
 Wm/LoxRt
 HP5Uyt6AZ0uNmjcwkn3eic9RpawBuuAsAOEc+cV+zEV7u/PULg5jf31TcxoMMYLvEm9EbNCP2Z9tJ/4xOOAYGA55jUM+WNGUMsKfSso4qkBeXa1o96FFqnrplyWHp62HJBt6Dk7BmLu4loxEE7ipzeQyprJilMfbe5lNO2bE4QW4YpJj+R5O++zdM5KF7KtGRo/IOBIKZJW7Qov42Uc6Emn6oqf0WUNw/ozmpNPy1Zqi25mZtwyucGD5pDKB0SejteUKeyB+PgYoGDuU0SnEbmwy8f6vuKDP4Mq+kgfC7AmFyE7jU6VcZ378AO971kkzFx/1GctH+vTjBnTU=
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
> The TEST_EXPECT_SIGBUS macro is not thread-safe as it uses a global
> sigjmp_buf and installs a global SIGBUS signal handler. If multiple threads
> execute the macro concurrently, they will race on installing the signal
> handler and stomp on other threads' jump buffers, leading to incorrect test
> behavior.
>
> Make TEST_EXPECT_SIGBUS thread-safe with the following changes:
>
> Share the KVM tests' global signal handler. sigaction() applies to all
> threads; without sharing a global signal handler, one thread may have
> removed the signal handler that another thread added, hence leading to
> unexpected signals.
>
> The alternative of layering signal handlers was considered, but calling
> sigaction() within TEST_EXPECT_SIGBUS() necessarily creates a race. To
> avoid adding new setup and teardown routines to do sigaction() and keep
> usage of TEST_EXPECT_SIGBUS() simple, share the KVM tests' global signal
> handler.
>
> Opportunistically rename report_unexpected_signal to
> catchall_signal_handler.
>
> To continue to only expect SIGBUS within specific regions of code, use a
> thread-specific variable, expecting_sigbus, to replace installing and
> removing signal handlers.
>
> Make the execution environment for the thread, sigjmp_buf, a
> thread-specific variable.
>
> As part of TEST_EXPECT_SIGBUS(), assert the prerequisite for this setup,
> that the current signal handler is the catchall_signal_handler.
>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  tools/testing/selftests/kvm/include/test_util.h | 32 +++++++++++++------------
>  tools/testing/selftests/kvm/lib/kvm_util.c      | 18 ++++++++++----
>  tools/testing/selftests/kvm/lib/test_util.c     |  7 ------
>  3 files changed, 30 insertions(+), 27 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
> index 51287fac8138a..bd75162ec868d 100644
> --- a/tools/testing/selftests/kvm/include/test_util.h
> +++ b/tools/testing/selftests/kvm/include/test_util.h
> @@ -82,21 +82,23 @@ do {                                                                        \
>         __builtin_unreachable(); \
>  } while (0)
>
> -extern sigjmp_buf expect_sigbus_jmpbuf;
> -void expect_sigbus_handler(int signum);
> -
> -#define TEST_EXPECT_SIGBUS(action)                                             \
> -do {                                                                           \
> -       struct sigaction sa_old, sa_new = {                                     \
> -               .sa_handler = expect_sigbus_handler,                            \
> -       };                                                                      \
> -                                                                               \
> -       sigaction(SIGBUS, &sa_new, &sa_old);                                    \
> -       if (sigsetjmp(expect_sigbus_jmpbuf, 1) == 0) {                          \
> -               action;                                                         \
> -               TEST_FAIL("'%s' should have triggered SIGBUS", #action);        \
> -       }                                                                       \
> -       sigaction(SIGBUS, &sa_old, NULL);                                       \
> +extern __thread sigjmp_buf expect_sigbus_jmpbuf;
> +extern __thread volatile sig_atomic_t expecting_sigbus;
> +extern void catchall_signal_handler(int signum);
> +
> +#define TEST_EXPECT_SIGBUS(action)                                     \
> +do {                                                                   \
> +       struct sigaction __sa = {};                                     \
> +                                                                       \
> +       TEST_ASSERT_EQ(sigaction(SIGBUS, NULL, &__sa), 0);              \
> +       TEST_ASSERT_EQ(__sa.sa_handler, &catchall_signal_handler);      \
> +                                                                       \
> +       expecting_sigbus = true;                                        \
> +       if (sigsetjmp(expect_sigbus_jmpbuf, 1) == 0) {                  \
> +               action;                                                 \
> +               TEST_FAIL("'%s' should have triggered SIGBUS", #action);\
> +       }                                                               \
> +       expecting_sigbus = false;                                       \
>  } while (0)
>
>  size_t parse_size(const char *size);
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 6b304e8a0e0d5..b4f104436875b 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -2292,13 +2292,20 @@ __weak void kvm_selftest_arch_init(void)
>  {
>  }
>
> -static void report_unexpected_signal(int signum)
> +__thread sigjmp_buf expect_sigbus_jmpbuf;
> +__thread volatile sig_atomic_t expecting_sigbus;
> +
> +void catchall_signal_handler(int signum)
>  {
> +       switch (signum) {
> +       case SIGBUS: {
> +               if (expecting_sigbus)
> +                       siglongjmp(expect_sigbus_jmpbuf, 1);
> +
> +               TEST_FAIL("Unexpected SIGBUS (%d)\n", signum);
> +       }
>  #define KVM_CASE_SIGNUM(sig)                                   \
>         case sig: TEST_FAIL("Unexpected " #sig " (%d)\n", signum)
> -
> -       switch (signum) {
> -       KVM_CASE_SIGNUM(SIGBUS);
>         KVM_CASE_SIGNUM(SIGSEGV);
>         KVM_CASE_SIGNUM(SIGILL);
>         KVM_CASE_SIGNUM(SIGFPE);
> @@ -2310,12 +2317,13 @@ static void report_unexpected_signal(int signum)
>  void __attribute((constructor)) kvm_selftest_init(void)
>  {
>         struct sigaction sig_sa = {
> -               .sa_handler = report_unexpected_signal,
> +               .sa_handler = catchall_signal_handler,
>         };
>
>         /* Tell stdout not to buffer its content. */
>         setbuf(stdout, NULL);
>
> +       expecting_sigbus = false;
>         sigaction(SIGBUS, &sig_sa, NULL);
>         sigaction(SIGSEGV, &sig_sa, NULL);
>         sigaction(SIGILL, &sig_sa, NULL);
> diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
> index bab1bd2b775b6..30eb701e4becd 100644
> --- a/tools/testing/selftests/kvm/lib/test_util.c
> +++ b/tools/testing/selftests/kvm/lib/test_util.c
> @@ -18,13 +18,6 @@
>
>  #include "test_util.h"
>
> -sigjmp_buf expect_sigbus_jmpbuf;
> -
> -void __attribute__((used)) expect_sigbus_handler(int signum)
> -{
> -       siglongjmp(expect_sigbus_jmpbuf, 1);
> -}
> -
>  /*
>   * Random number generator that is usable from guest code. This is the
>   * Park-Miller LCG using standard constants.
>
> --
> 2.55.0.rc0.738.g0c8ab3ebcc-goog
>
>

