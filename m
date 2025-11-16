Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7110BCEBF8A
	for <linux-mm@archiver.kernel.org>; Sun, 16 Nov 2025 06:49:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C9728E002D; Sun, 16 Nov 2025 01:49:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89D778E0005; Sun, 16 Nov 2025 01:49:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B2C38E002D; Sun, 16 Nov 2025 01:49:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 66EDD8E0005
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 01:49:44 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D7B9B5BB5A
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 06:49:43 +0000 (UTC)
X-FDA: 84115544646.16.A088061
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf12.hostedemail.com (Postfix) with ESMTP id E48E940002
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 06:49:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KhpkueEv;
	spf=pass (imf12.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763275782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9b8IJSYXtBsPcOc3zz//VewvB+A/HFTZrZRLMW1CFbA=;
	b=MYRvoGtE8P1sDtUwPn86EbcPlQ7kU0qARVXmwM6eGuYl/7zbJSw5qR9zxOLOufQ19Mct6n
	jMF+1rnAixPRkhn8lEWwVDsR970P1E+Q0C6IKfqbL5VdidIhptikstbeXUsjZJQMkqQnmm
	LrujIyjvNEdIm2tDb/FCb84r3c9e4ds=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763275782; a=rsa-sha256;
	cv=none;
	b=y79ZkUlFtPgbxEvVTDg9XIMFtPiqKnEfjjbMQClB+fg62lZ0uusYP+vZVn29WbOk7rT9/p
	cWmeSy+4mEFg4MmiF2w3+s0Cbq9OC5SD6c+GuBv8EXMxVBwgnvXuum16+u1D7bOkluIGIW
	x5f3wgAcIXVz5bQsaW5IUcyioCkbr1Q=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KhpkueEv;
	spf=pass (imf12.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7ade456b6abso2867301b3a.3
        for <linux-mm@kvack.org>; Sat, 15 Nov 2025 22:49:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763275781; x=1763880581; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9b8IJSYXtBsPcOc3zz//VewvB+A/HFTZrZRLMW1CFbA=;
        b=KhpkueEvY1c18WVAIVriJDMHDJGYTdlQIbRNJA9X/D8EXIU83RNQSKx3V+d+qSmqwG
         kECXgw2LqT2qOJuHdboez1TXNeZhyDvx5kFY1x6UxKDaxFuR3Imk/bj1wn1LRIju41MZ
         pN0cbfOeY1zPr276vu8RuuJ5JlOiOjJHv5DrKZPsBgkZWyC4Gubrue3uu5CHvwHum57v
         pupA96oj2Kmy+STkmBAkWRA6d6QAoTnO9Bbs8Iy48NI3zAAxYgnjjDzpIb8XB7zb/J4V
         ZcohYx7iQdQ4OGhmwNy5pgGIWaPeJyX84KkYcBp/cT6xzM64+WO7fWuj7KF+pNLGsxUi
         9xIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763275781; x=1763880581;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9b8IJSYXtBsPcOc3zz//VewvB+A/HFTZrZRLMW1CFbA=;
        b=aVKyVwf8hW8M9fdu0ksWyX+53T2c92oxlP3YJUkFFaMfaTZ0YgT8GexHu0SLnnCRD9
         vC+BZIhE471J9nXQoibPEp3++inB7p9gfILr6IFSg+7R1hXhAS7gYGWTGpLKmp9udTBt
         JxxY6Zq09XVabzr2MQXttDgIOCC4KCfihryUyJ3ZQszgwdxVb3e18BWYIUZHQ3SPkjS1
         arE1IsxRB9w8zVj63Z1pj6ckb0IP8BVccfJbZZtZZmNppl2FI9HC9Zh1K8VtA+D/iOw5
         OyfVBGC2zqEgUq00lbFnmRtz3zevnGXESZqZkMId8umwoMsG0+5b4CLcWlMcX+Up+oav
         IHEw==
X-Forwarded-Encrypted: i=1; AJvYcCXPmBAo6JGyW4BkYW1HUvSIDirPnx66M8lydDr8IDh/gSIJS1uEkN7GQVAoXLJLU+iNYI9TZjfYlw==@kvack.org
X-Gm-Message-State: AOJu0Yxfm4oxnR3vW9xosn8b5UfCGLxt4sADyktyZXT0okxHtsDanmQ3
	0gPkObeOgvPwbQ0EZ2ZkKMFpAVQtpf3+stBX84Fs1XkbhKkMLSHXd0dw
X-Gm-Gg: ASbGncvpVQv4ObBqVuvcQn/3YfJvtlyxJKyMMvQ9K22kv9N6Q29zcWH+WWXXRjFBogz
	2/JN9k3uw/065IJaSSKNVy0BelBRDnogwhF4w71hve7ihtV0zeyWPUMEd2a5OB4DXkFT2pj0Ajr
	1eEopSDiWvH5F12dJJfOUNqr+zVRO/FATKd3tiNb767TsdYc91xfJGVR6R2WFoHOcrlRxtCmQcD
	jZOU+LI+u2J908KA9yGRBW9qsf/VVPwsdw1Hc+satA0naAUywrKT96j2zb+FwHWBh+L3iwMqOqS
	n68PEU+yWIGgarz07JCTe4rZiBACH/H0wWPTeTfGNA9ST33GQanU3F1Awr/K4jF7fsPhe+BUecJ
	2+zw7cLACA4vkWuCi3wWFZq6PiYpiDhyjRmtI8V7czhbsKLX67pCL/sfOO7XVZ61nuYTHmBCDqQ
	==
X-Google-Smtp-Source: AGHT+IFouFg86tnbEJBbixUeQQEONClEEPNYmTk01w9DMsSZyQU+lHf3REEj3Dr3gbQQjBDIKCsHKw==
X-Received: by 2002:a05:6a21:4ec5:10b0:35e:e604:f787 with SMTP id adf61e73a8af0-35ee61484ccmr465968637.39.1763275780537;
        Sat, 15 Nov 2025 22:49:40 -0800 (PST)
Received: from localhost.localdomain ([2403:2c80:17::10:4006])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b9250d2d16sm9578369b3a.22.2025.11.15.22.49.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 15 Nov 2025 22:49:40 -0800 (PST)
From: Lance Yang <ioworker0@gmail.com>
To: pasha.tatashin@soleen.com
Cc: akpm@linux-foundation.org,
	arnd@arndb.de,
	bhe@redhat.com,
	coxu@redhat.com,
	dave@vasilevsky.ca,
	ebiggers@google.com,
	graf@amazon.com,
	jasonmiu@google.com,
	kees@kernel.org,
	kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	rppt@kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v2 03/13] kho: Introduce high-level memory allocation API
Date: Sun, 16 Nov 2025 14:49:18 +0800
Message-ID: <20251116064918.35549-1-ioworker0@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251114190002.3311679-4-pasha.tatashin@soleen.com>
References: <20251114190002.3311679-4-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 51cpnjwwxmb9jdibadw4c7dd438xtwyo
X-Rspam-User: 
X-Rspamd-Queue-Id: E48E940002
X-Rspamd-Server: rspam01
X-HE-Tag: 1763275781-21127
X-HE-Meta: U2FsdGVkX1/k+NcLWOfY5HUrmbSL+74UkXO6+mj+bSuh//q09E/tAahhaF2ILgDQRAJwtSTjVY3c6AAlaXUuHQZRon7YxUvGrC1NsAljIlpuUHRX1os199bDwBxD2iYCW8RucZPY8uZVkpjmxdkxUpsYSUYEnm6t6HL96Dbo6PPfiTfmvPd2bDTtpFlk6QAZHYo+aN5QXbSEKaUAOEfIWTAl8hoYU7uAyJmyqFEYksnVyxlPfm4o76Z+VHzolR8dbEyvlaUxB8bYX42onHbfpYffbyw+eGBKxcBMxjRfDh1X0dTT6nEAe0eFta0eRDQX8V4wp5yDGO3S6DgSmjKEp53LWKZJ0C7H1t5u2q9BNXLqsfJp/fzazGhncy/kD4z7FgjLXhAkdHNcbIKVSF/+ilr+Jqgpf7BgzPQlMevn/c0NN3PEr6M4hMF9xAxruIXuWAcnIh+EYwb0D9ajbNEyqRPBsc2QCx1ErxOe2mMA2Dvr/dKhP9giU7teEFIWMvMO0TQ0SZXr1Xhsxb7GYv0CUegLUk0d0A0RfTPEjXlap9Z2L/4k2r+45Hk0KX+cP6hFaH3jsaOgYjNyqWeX1zjKKfdQsie0cbqEMPUKSSjSlkmF5zvA32d81hGRPKULbxSn4Vt27CiSz331NhmQmvPsGoGkpA5Qq02FlSdnXAK8/8ssCzk7SlEvxVLiUF7q5uYZMxuR6cPmM1ty5wSlKrJ/04dgzHNZNZj1IQ5+UlSWDpPQD0WAL2evDVOy0dsBdQQ2O2bBxm0FYBdHjvh8Q4TyHZED3zWO1hio2F20B1gNKPO8stut/qOaYv6TpwruTUGYfq6OT1TMtBqTYrbELQQjJRe8EO5vYdU0Yca3wsNpAiUwK1NU/kHvM9mKf9aVIHxNT8loHRpk/fFZATMckLpwBJRdCocXegYXu5bVUp4WT13XMpEjeDV2gvJex97uzKPIYzV02TuAAuHRRkf36yz
 2RbBhEYT
 tog4JrhzBt7qtNoWluf1qD8pKLclEfetBFwhp1Xc6itcRN7wkZTjxho/K6nAax3L4csYI0ouVbKANuXW3t7nNG2vuvYku7c/eG2n9GkrobFqTgoG3+TnCqYY3fUQbfokmT1M/FxMCSpkAOOOmtSy1+95uVx+XJV+4i77xNBvu3FfpNB/ZdrH5eXuKnLP+QpZRzoFn01BVhtf6Y95VtDnFbjCMYFlSEib82Jr/8ABRZUHNvA+FwYqMJgyEkuyZ3NET036932H/+/ggrIV9z8tYJBVqMHs6/0u7kdoehEk9aF8rlWIpGhMGkYOXOZ/CzT4+G2cdP0lYQNBiZq9PWQ8MLbV1v7vi6bLCSJ0PobDn4J5L4St3ulV+tUR/3vuJMLOCv1ZTGxxta+G9ngE6QNYQ54UrDPLVx9Rl06R8MWs5OjRI6et6QJeljqh8HOP7qLr08mBAF6p2qcogRv0rmS/9YRygqXXEFCpAlIXFZFfyotx29PXfFt+RW8uzZsbOeJOo2CuKEEiPigs8KNvxT7kYTg7gMEwxUkQP3FgOpkS/g2kY4O4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>


On Fri, 14 Nov 2025 13:59:52 -0500, Pasha Tatashin wrote:
> Currently, clients of KHO must manually allocate memory (e.g., via
> alloc_pages), calculate the page order, and explicitly call
> kho_preserve_folio(). Similarly, cleanup requires separate calls to
> unpreserve and free the memory.
> 
> Introduce a high-level API to streamline this common pattern:
> 
> - kho_alloc_preserve(size): Allocates physically contiguous, zeroed
>   memory and immediately marks it for preservation.
> - kho_unpreserve_free(ptr): Unpreserves and frees the memory
>   in the current kernel.
> - kho_restore_free(ptr): Restores the struct page state of
>   preserved memory in the new kernel and immediately frees it to the
>   page allocator.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  include/linux/kexec_handover.h     | 22 +++++---
>  kernel/liveupdate/kexec_handover.c | 87 ++++++++++++++++++++++++++++++
>  2 files changed, 102 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
> index 80ece4232617..38a9487a1a00 100644
> --- a/include/linux/kexec_handover.h
> +++ b/include/linux/kexec_handover.h
> @@ -2,8 +2,9 @@
>  #ifndef LINUX_KEXEC_HANDOVER_H
>  #define LINUX_KEXEC_HANDOVER_H
>  
> -#include <linux/types.h>
> +#include <linux/err.h>
>  #include <linux/errno.h>
> +#include <linux/types.h>
>  
>  struct kho_scratch {
>  	phys_addr_t addr;
> @@ -48,6 +49,9 @@ int kho_preserve_pages(struct page *page, unsigned int nr_pages);
>  int kho_unpreserve_pages(struct page *page, unsigned int nr_pages);
>  int kho_preserve_vmalloc(void *ptr, struct kho_vmalloc *preservation);
>  int kho_unpreserve_vmalloc(struct kho_vmalloc *preservation);
> +void *kho_alloc_preserve(size_t size);
> +void kho_unpreserve_free(void *mem);
> +void kho_restore_free(void *mem);
>  struct folio *kho_restore_folio(phys_addr_t phys);
>  struct page *kho_restore_pages(phys_addr_t phys, unsigned int nr_pages);
>  void *kho_restore_vmalloc(const struct kho_vmalloc *preservation);
> @@ -101,6 +105,14 @@ static inline int kho_unpreserve_vmalloc(struct kho_vmalloc *preservation)
>  	return -EOPNOTSUPP;
>  }
>  
> +void *kho_alloc_preserve(size_t size)
> +{
> +	return ERR_PTR(-EOPNOTSUPP);
> +}
> +
> +void kho_unpreserve_free(void *mem) { }
> +void kho_restore_free(void *mem) { }

The compile is unhapply here when CONFIG_KEXEC_HANDOVER is not set ...

```
ld: arch/x86/realmode/rm/video-mode.o: in function `kho_alloc_preserve':
/home/runner/work/mm-test-robot/mm-test-robot/linux/./include/linux/kexec_handover.h:102: multiple definition of `kho_alloc_preserve'; arch/x86/realmode/rm/wakemain.o:/home/runner/work/mm-test-robot/mm-test-robot/linux/./include/linux/kexec_handover.h:102: first defined here
ld: arch/x86/realmode/rm/video-mode.o: in function `kho_unpreserve_free':
/home/runner/work/mm-test-robot/mm-test-robot/linux/./include/linux/kexec_handover.h:104: multiple definition of `kho_unpreserve_free'; arch/x86/realmode/rm/wakemain.o:/home/runner/work/mm-test-robot/mm-test-robot/linux/./include/linux/kexec_handover.h:104: first defined here
ld: arch/x86/realmode/rm/video-mode.o: in function `kho_restore_free':
/home/runner/work/mm-test-robot/mm-test-robot/linux/./include/linux/kexec_handover.h:105: multiple definition of `kho_restore_free'; arch/x86/realmode/rm/wakemain.o:/home/runner/work/mm-test-robot/mm-test-robot/linux/./include/linux/kexec_handover.h:105: first defined here
ld: arch/x86/realmode/rm/regs.o: in function `kho_alloc_preserve':
/home/runner/work/mm-test-robot/mm-test-robot/linux/arch/x86/realmode/rm/regs.c:102: multiple definition of `kho_alloc_preserve'; arch/x86/realmode/rm/wakemain.o:/home/runner/work/mm-test-robot/mm-test-robot/linux/./include/linux/kexec_handover.h:102: first defined here
ld: arch/x86/realmode/rm/regs.o: in function `kho_unpreserve_free':
/home/runner/work/mm-test-robot/mm-test-robot/linux/arch/x86/realmode/rm/regs.c:104: multiple definition of `kho_unpreserve_free'; arch/x86/realmode/rm/wakemain.o:/home/runner/work/mm-test-robot/mm-test-robot/linux/./include/linux/kexec_handover.h:104: first defined here
ld: arch/x86/realmode/rm/regs.o: in function `kho_restore_free':
/home/runner/work/mm-test-robot/mm-test-robot/linux/arch/x86/realmode/rm/regs.c:105: multiple definition of `kho_restore_free'; arch/x86/realmode/rm/wakemain.o:/home/runner/work/mm-test-robot/mm-test-robot/linux/./include/linux/kexec_handover.h:105: first defined here
ld: arch/x86/realmode/rm/video-vga.o: in function `kho_alloc_preserve':
/home/runner/work/mm-test-robot/mm-test-robot/linux/./include/linux/kexec_handover.h:102: multiple definition of `kho_alloc_preserve'; arch/x86/realmode/rm/wakemain.o:/home/runner/work/mm-test-robot/mm-test-robot/linux/./include/linux/kexec_handover.h:102: first defined here
ld: arch/x86/realmode/rm/video-vga.o: in function `kho_unpreserve_free':
/home/runner/work/mm-test-robot/mm-test-robot/linux/./include/linux/kexec_handover.h:104: multiple definition of `kho_unpreserve_free'; arch/x86/realmode/rm/wakemain.o:/home/runner/work/mm-test-robot/mm-test-robot/linux/./include/linux/kexec_handover.h:104: first defined here
ld: arch/x86/realmode/rm/video-vga.o: in function `kho_restore_free':
/home/runner/work/mm-test-robot/mm-test-robot/linux/./include/linux/kexec_handover.h:105: multiple definition of `kho_restore_free'; arch/x86/realmode/rm/wakemain.o:/home/runner/work/mm-test-robot/mm-test-robot/linux/./include/linux/kexec_handover.h:105: first defined here
ld: arch/x86/realmode/rm/video-vesa.o: in function `kho_alloc_preserve':
/home/runner/work/mm-test-robot/mm-test-robot/linux/./include/linux/kexec_handover.h:102: multiple definition of `kho_alloc_preserve'; arch/x86/realmode/rm/wakemain.o:/home/runner/work/mm-test-robot/mm-test-robot/linux/./include/linux/kexec_handover.h:102: first defined here
ld: arch/x86/realmode/rm/video-vesa.o: in function `kho_unpreserve_free':
/home/runner/work/mm-test-robot/mm-test-robot/linux/./include/linux/kexec_handover.h:104: multiple definition of `kho_unpreserve_free'; arch/x86/realmode/rm/wakemain.o:/home/runner/work/mm-test-robot/mm-test-robot/linux/./include/linux/kexec_handover.h:104: first defined here
ld: arch/x86/realmode/rm/video-vesa.o: in function `kho_restore_free':
/home/runner/work/mm-test-robot/mm-test-robot/linux/./include/linux/kexec_handover.h:105: multiple definition of `kho_restore_free'; arch/x86/realmode/rm/wakemain.o:/home/runner/work/mm-test-robot/mm-test-robot/linux/./include/linux/kexec_handover.h:105: first defined here
ld: arch/x86/realmode/rm/video-bios.o: in function `kho_alloc_preserve':
/home/runner/work/mm-test-robot/mm-test-robot/linux/./include/linux/kexec_handover.h:102: multiple definition of `kho_alloc_preserve'; arch/x86/realmode/rm/wakemain.o:/home/runner/work/mm-test-robot/mm-test-robot/linux/./include/linux/kexec_handover.h:102: first defined here
ld: arch/x86/realmode/rm/video-bios.o: in function `kho_unpreserve_free':
/home/runner/work/mm-test-robot/mm-test-robot/linux/./include/linux/kexec_handover.h:104: multiple definition of `kho_unpreserve_free'; arch/x86/realmode/rm/wakemain.o:/home/runner/work/mm-test-robot/mm-test-robot/linux/./include/linux/kexec_handover.h:104: first defined here
ld: arch/x86/realmode/rm/video-bios.o: in function `kho_restore_free':
/home/runner/work/mm-test-robot/mm-test-robot/linux/./include/linux/kexec_handover.h:105: multiple definition of `kho_restore_free'; arch/x86/realmode/rm/wakemain.o:/home/runner/work/mm-test-robot/mm-test-robot/linux/./include/linux/kexec_handover.h:105: first defined here
make[5]: *** [arch/x86/realmode/rm/Makefile:49: arch/x86/realmode/rm/realmode.elf] Error 1
make[4]: *** [arch/x86/realmode/Makefile:22: arch/x86/realmode/rm/realmode.bin] Error 2
make[3]: *** [scripts/Makefile.build:556: arch/x86/realmode] Error 2
```

Perhaps these stubs should be declared as static inline? That should make
the compiler happy and resolve the linking errors :)

----8<----
diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index 6dd0dcdf0ec1..5f7b9de97e8d 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -96,13 +96,13 @@ static inline int kho_preserve_vmalloc(void *ptr,

 static inline void kho_unpreserve_vmalloc(struct kho_vmalloc *preservation) { }

-void *kho_alloc_preserve(size_t size)
+static inline void *kho_alloc_preserve(size_t size)
 {
        return ERR_PTR(-EOPNOTSUPP);
 }

-void kho_unpreserve_free(void *mem) { }
-void kho_restore_free(void *mem) { }
+static inline void kho_unpreserve_free(void *mem) { }
+static inline void kho_restore_free(void *mem) { }

 static inline struct folio *kho_restore_folio(phys_addr_t phys)
 {
---

[...]

Cheers,
Lance

