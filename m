Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6306E909BA
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 15:15:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04C006B0089; Tue, 17 Feb 2026 10:15:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F39AB6B008A; Tue, 17 Feb 2026 10:15:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3B2D6B008C; Tue, 17 Feb 2026 10:15:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CE4E26B0089
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 10:15:35 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 96516C10B6
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 15:15:35 +0000 (UTC)
X-FDA: 84454297830.23.DC39282
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf23.hostedemail.com (Postfix) with ESMTP id 75997140008
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 15:15:32 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qRK9Hocl;
	spf=pass (imf23.hostedemail.com: domain of 3EoaUaQYKCMM1njwslpxxpun.lxvurw36-vvt4jlt.x0p@flex--seanjc.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3EoaUaQYKCMM1njwslpxxpun.lxvurw36-vvt4jlt.x0p@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771341332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HPh5d8pZ0/N2pmYYWL0hS3cj+T7x1Qno8FKMpGo1Eao=;
	b=0wSDGHd2yD5FUovHcbhiEaRbRKoOaYhCdcAjtwjfOWgBzjOGmyMnZDSkKFBYadi7yyRsZ2
	NLVY9ueyv6jLKcOzCGeNNePEi055hcLtrxl768gfckU7ze+nPEyO9EKD81ThuXSlvEUWyZ
	M9TkC2L0jbhXVTPAeFBt69ftMHp6+xU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qRK9Hocl;
	spf=pass (imf23.hostedemail.com: domain of 3EoaUaQYKCMM1njwslpxxpun.lxvurw36-vvt4jlt.x0p@flex--seanjc.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3EoaUaQYKCMM1njwslpxxpun.lxvurw36-vvt4jlt.x0p@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771341332; a=rsa-sha256;
	cv=none;
	b=2f0pn5LSfBYFBxhcODGArErskHuGuBeb5/MJ0GJG0EeCYKpPEU5mgk6O/S35sRS7BM2FAv
	PCPl2TxQ5c4qWbXsbTUG7JRPUXzwpnVyxboIiIs/hi92gE4Ec21mJEQc6eyzbzLe97bZVq
	802du+iaPMaeC0MbjaqWYMZzL0HE0zA=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c6e78c4aa50so955829a12.0
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 07:15:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771341331; x=1771946131; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HPh5d8pZ0/N2pmYYWL0hS3cj+T7x1Qno8FKMpGo1Eao=;
        b=qRK9HoclYLt3t6/ulLLYqHJbyF0/qEjhYiQjziSgixyIj0qTGZSGF8esDYPauIqmWS
         SDIVp1D6Ri7g1X+fQGuF9JfkKN/LCg8W3AbzXx2CPmaa2+NquxS+agLOFgEIDcTl5KlK
         b2XDhE3CNByKXL7GHg1z+H8koWGeV2Luw+XLYjN9jZ/UD1GKSfXYLG5Yl66grnRkwfEa
         uuhBk6N9onAO0V/+D9FqKQP5EwsD+vTlAlpJE0aqpTzG/9znoh4vLpEifP/k1bBplRu9
         QYe2KfhcLGc5q956Wr7kryRYJjXQZWetnfOOuO8FBQvymfXPmpuq4Tz59ZnvGbmqdqZv
         4VmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771341331; x=1771946131;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HPh5d8pZ0/N2pmYYWL0hS3cj+T7x1Qno8FKMpGo1Eao=;
        b=tms7xoz+BCbxqX8M2/Pa8cXbZ7HD99H/SON5F7RNo9K4yFh1FdVjIDpqrdspxYdfYU
         JxnnlXlLFDGtq0mRjOmMJFLHh7AC5Su4UkTOqs7x0sDcOVD8ZaiqXm/IELgFTY8sYcMT
         r86baNZPfkDrEzioXcmwGRLnyCem0g9SnB+cZ3kF/vlJYzf5DFqPhhDChvRX6MiCkUyj
         qGLiXcnh0OsxnO+Pi6lOkfQ/dC4/RfAAHpYZZLTDe9BoX/EXe1wQvQ2mzMmPYT7gZM+T
         3wBZEqYa1iqVigo88bTIj30UbLPIYjhpNQQ8jivUMN1lYFuOFBBA9U4WnE20P6s4lnr1
         t5QQ==
X-Forwarded-Encrypted: i=1; AJvYcCU7dy8hp8XFRB4mzYHCsLmfgCG82QFKch4Vd1Ymq84INabaTbiqu8H9rfkaSDpbjfpDI9/RqG3OWA==@kvack.org
X-Gm-Message-State: AOJu0YytaCvBQW5bKR2htq4mE1DSSKhBxglpL/kFDtOkImvaw4jIjv6A
	ktLPCT0hoLfheNJo+PHKizZebEuf9iHhZ76yl3DJ/OcYGPOPfPBsaLT0bqrM2jsXhq7bwbloxBp
	cZHAHBg==
X-Received: from pgbcv6.prod.google.com ([2002:a05:6a02:4206:b0:c6e:2a5a:51cb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:e347:b0:35f:b243:46cb
 with SMTP id adf61e73a8af0-3946c6df211mr12345864637.12.1771341330830; Tue, 17
 Feb 2026 07:15:30 -0800 (PST)
Date: Tue, 17 Feb 2026 07:15:27 -0800
In-Reply-To: <20260217014402.2554832-1-ackerleytng@google.com>
Mime-Version: 1.0
References: <20260214001535.435626-1-kartikey406@gmail.com> <20260217014402.2554832-1-ackerleytng@google.com>
Message-ID: <aZSGD-EGSR3Z5Qyi@google.com>
Subject: Re: [PATCH] KVM: selftests: Test MADV_COLLAPSE on GUEST_MEMFD
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: kartikey406@gmail.com, pbonzini@redhat.com, shuah@kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, vannapurve@google.com, 
	Liam.Howlett@oracle.com, akpm@linux-foundation.org, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, david@kernel.org, dev.jain@arm.com, 
	i@maskray.me, lance.yang@linux.dev, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, shy828301@gmail.com, stable@vger.kernel.org, 
	syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com, ziy@nvidia.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 75997140008
X-Stat-Signature: 68wdbhddibs6zjuxxq8xy4wcsg8ukr9n
X-HE-Tag: 1771341332-974998
X-HE-Meta: U2FsdGVkX18twUmz2uDiR0fLAlNXHGjHHmVjgo8you0WI3Zmvrzg74ia+BT7mWV4ULjB4xI5zEBLGO5DjxaaieYYPFAivUC6uHbFx0oG33wRkcm/4y+tOb11gM6mEhtc5kcUB/6HCI0LjuymJ9cIShGgXDXvHU4Xn8EpyIEGeTGox/W8VnbmqtVPz3pFmj2iADZB6CbKANh9kj8yh19cgjLVLnZfoAFgbok2woug7HWQhkUiLXAGy3jsnkIEFIXMKEvT5m81x0m7cxgCJ6aYe2NE5lyndot//YncIH47ynxVAuL6X3ANkTD4rre4rymGM0T/09AEoCvAWGp8vIqm2z4JKx45GaE8AkvKCQbn0//wZTSf0EDSrnwY7Vla2YBp2STy0QtmOCcutvl/IXFk5B+htJpq0BWakxePEk5OzzjVgw67Yy0sWMAkIwAnn6SWoIO/+LCcPPI3Aflqm65UkUZwU6iB0CVwPy3cT8E3RG+jLHniveXkIpV2EyZckCuMcglNM6Qj/lIVt0xTBg60o/V4shNQE8Osh4eAmrxQusw9tQ5C8Ume02HoSGcPqAJIljj1uKimkgxKiPQzbHFKGtrMvMUPcQuHFrk6xSasFCM1egzAKjMRwW4z463cR+s/EG8/BC8sJelkyJ9Nfd9Ib5mGbRAaglgixoZdiRC6uDCrBSuNfpZwM+PON7WYb1PAd90UqgZh9/cqERGb62xUCX3CMw97eT0Tj3HxLReaT47cglEnE/q+CzLpcdV8L13VKE1IZEoIBfrizb43yAM/9duT1lblAIVX3P3LsYk0EHH7Z8fp1YpDkFx4XV02Fh/Cht7Eiifv/stC/b/tjYu1SIG+CHmrWTJrwhWGmPFsdzRT9xur7Kh0OyAJrJdlghgUTyUi7zGVRGYOBQrd14QdpQ+y1qd1pyQVJnHQ3Pj5Ggm+IXNW4zu+HqJlC4C9x9aijOUXf6gZWjHHkh4QriB
 XedYvguw
 dQzv3Al1YC+TPTxbGvnbUV+MOamRScgfTKy51JfWkDSFeQ0PJJ7paEQJWVV8arHcDamqOC0HX/X4tcfytRrJ8q3S4shm1JDOMZ/HltcY40faWome2m/ByoBMVhwDMZ7HVy7KtTEnUve+mijqhd/pChISlPKuW9dljaNq0+xQVm15diwhjujsDJL0K7aidrVsJTr2q+Kp32P7H1CrciPAg+H9+5hEUpbPB08FCT/cTv6hox1E+wz1gRbSv+eGO6MwrKgL1ks8dulCWwxDEuy5sIZ/mB9p8BD52q195/+YF3/GnqNLgdCEJ85dkYzDD3OIIEPlGNlkwlfYlnBpe4IHjPMYObUt+VdaJfeY2rzZ65TzhX10dKBe3e3aFIJDM3O+Z5PXNpVZ1DR9O/CjPl5qiLifQTw9p9wFDgG9+xP66n7VT1tbU9B70UJV/Su4rP9zPJfZ3vNbX1X00fTTjtfi+WCLlHPx3H8brIrzOa00yhXj76SqyAmG7q+/NQgozrIK/TjzHRRXNVNhzFrhXGpwWewzPJlGM8oExKin+vNKVN3w/xsodohvLqlO4utxR0XDv2p2rLn0z92W8pGz9ug2hsnI2abrtfpasmAA+XTb1WycsQW9zp8FPx4CKaB/66NNOBi6yjVBdqgMSdJ1F3YhleBgsVmOYHrxAo3y4nkN4vxu1GaiSVrZM6G1YRCy/cAZr15Gq7bRU8Y5Gk0mmgIm8OGQcaRqBVflRQDneCsFbbhhaZz2d/v2On1fmUt7jkwVV8PehouF0GTc6hNg4BaUYlLcCHkBIyfj0Z4Lwudv/RpUkdR+swzq4QP4vS+I3TNCwQFNy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026, Ackerley Tng wrote:
> diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
> index 618c937f3c90f..d16341a4a315d 100644
> --- a/tools/testing/selftests/kvm/guest_memfd_test.c
> +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
> @@ -171,6 +171,77 @@ static void test_numa_allocation(int fd, size_t total_size)
>  	kvm_munmap(mem, total_size);
>  }
>  
> +static size_t getpmdsize(void)

This absolutely belongs in library/utility code.

> +{
> +	const char *path = "/sys/kernel/mm/transparent_hugepage/hpage_pmd_size";
> +	static size_t pmd_size = -1;
> +	FILE *fp;
> +
> +	if (pmd_size != -1)
> +		return pmd_size;
> +
> +	fp = fopen(path, "r");
> +	TEST_ASSERT(fp, "Couldn't open %s to read PMD size.", path);

This will likely assert on a kernel without THP support.

> +	TEST_ASSERT_EQ(fscanf(fp, "%lu", &pmd_size), 1);
> +
> +	TEST_ASSERT_EQ(fclose(fp), 0);

Please try to extend tools/testing/selftests/kvm/include/kvm_syscalls.h.

> +
> +	return pmd_size;
> +}
> +
> +static void test_collapse(struct kvm_vm *vm, uint64_t flags)
> +{
> +	const size_t pmd_size = getpmdsize();
> +	char *mem;
> +	off_t i;
> +	int fd;
> +
> +	fd = vm_create_guest_memfd(vm, pmd_size * 2,
> +				   GUEST_MEMFD_FLAG_MMAP |
> +				   GUEST_MEMFD_FLAG_INIT_SHARED);
> +
> +	/*
> +	 * Use aligned address so that MADV_COLLAPSE will not be
> +	 * filtered out early in the collapsing routine.

Please elaborate, the value below is way more magical than just being aligned.

> +	 */
> +#define ALIGNED_ADDRESS ((void *)0x4000000000UL)

Use a "const void *" instead of #define inside a function.  And use one of the
appropriate size macros, e.g.

	const void *ALIGNED_ADDRESS = (void *)(SZ_1G * <some magic value>);

But why hardcode a virtual address in the first place?  If you a specific
alignment, just allocate enough virtual memory to be able to meet those alignment
requirements.

> +	mem = mmap(ALIGNED_ADDRESS, pmd_size, PROT_READ | PROT_WRITE,
> +		   MAP_FIXED | MAP_SHARED, fd, 0);
> +	TEST_ASSERT_EQ(mem, ALIGNED_ADDRESS);
> +
> +	/*
> +	 * Use reads to populate page table to avoid setting dirty
> +	 * flag on page.
> +	 */
> +	for (i = 0; i < pmd_size; i += getpagesize())
> +		READ_ONCE(mem[i]);
> +
> +	/*
> +	 * Advising the use of huge pages in guest_memfd should be
> +	 * fine...
> +	 */
> +	TEST_ASSERT_EQ(madvise(mem, pmd_size, MADV_HUGEPAGE), 0);
> +
> +	/*
> +	 * ... but collapsing folios must not be supported to avoid
> +	 * mapping beyond shared ranges into host userspace page
> +	 * tables.
> +	 */
> +	TEST_ASSERT_EQ(madvise(mem, pmd_size, MADV_COLLAPSE), -1);
> +	TEST_ASSERT_EQ(errno, EINVAL);
> +
> +	/*
> +	 * Removing from host page tables and re-faulting should be
> +	 * fine; should not end up faulting in a collapsed/huge folio.
> +	 */
> +	TEST_ASSERT_EQ(madvise(mem, pmd_size, MADV_DONTNEED), 0);
> +	READ_ONCE(mem[0]);
> +
> +	kvm_munmap(mem, pmd_size);
> +	kvm_close(fd);
> +}
> +
>  static void test_fault_sigbus(int fd, size_t accessible_size, size_t map_size)
>  {
>  	const char val = 0xaa;
> @@ -370,6 +441,7 @@ static void __test_guest_memfd(struct kvm_vm *vm, uint64_t flags)
>  			gmem_test(mmap_supported, vm, flags);
>  			gmem_test(fault_overflow, vm, flags);
>  			gmem_test(numa_allocation, vm, flags);
> +			test_collapse(vm, flags);

Why diverge from everything else?  Yeah, the size is different, but that's easy
enough to handle.  And presumably the THP query needs to be able to fail gracefully,
so something like this?

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 618c937f3c90..e942adae1f59 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -350,14 +350,28 @@ static void test_guest_memfd_flags(struct kvm_vm *vm)
        }
 }
 
-#define gmem_test(__test, __vm, __flags)                               \
+#define __gmem_test(__test, __vm, __flags, __size)                     \
 do {                                                                   \
-       int fd = vm_create_guest_memfd(__vm, page_size * 4, __flags);   \
+       int fd = vm_create_guest_memfd(__vm, __size, __flags);          \
                                                                        \
-       test_##__test(fd, page_size * 4);                               \
+       test_##__test(fd, __size);                                      \
        close(fd);                                                      \
 } while (0)
 
+#define gmem_test(__test, __vm, __flags)                               \
+       __gmem_test(__test, __vm, __flags, page_size * 4)
+
+#define gmem_test_huge_pmd(__test, __vm, __flags)                      \
+do {                                                                   \
+       size_t pmd_size = kvm_get_thp_pmd_size();                       \
+                                                                       \
+       if (!pmd_size)                                                  \
+               break;                                                  \
+                                                                       \
+       __gmem_test(__test, __vm, __flags, pmd_size * 2);               \
+} while (0)
+
+
 static void __test_guest_memfd(struct kvm_vm *vm, uint64_t flags)
 {
        test_create_guest_memfd_multiple(vm);


