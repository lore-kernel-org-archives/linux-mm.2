Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D97F3CDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 23:01:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFE816B0092; Mon, 22 Jun 2026 19:01:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD5656B0098; Mon, 22 Jun 2026 19:01:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EC166B0099; Mon, 22 Jun 2026 19:01:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7307F6B0092
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 19:01:38 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DE79F120287
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 23:01:37 +0000 (UTC)
X-FDA: 84909072234.11.FC1836C
Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	by imf24.hostedemail.com (Postfix) with ESMTP id C3FBE180018
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 23:01:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ktOXu7cO;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf24.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.53 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782169295;
	b=uC1r2xtVOCWiVD5mF25JUyGZ9yPsrWpYtaYH+ZKQPzLPA/obVhuLtiK6LutXN6LWksbGVC
	YRuf1JxBrHTSNFrEPrtarF5ijkg/eB88ULcg+t/bzhBanEI4xu42UUVAE1QnxuYD/P/+SG
	cA/30DsSbBxpEEzP7e2f/i9zQreQNcg=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782169295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Se78T3ehOJrnIX6EVHqhbA3McVgxD20iSWZ28XYCDdw=;
	b=VlOAoPqy7qYIC3wYOfvd8u6HfcfM64koMNVW4/eL3JVGKAlNcOVAsNNM9JOpCngjxxk6Tp
	OZA1y5C7IzhJlSarue765gMdKK2Y6Q1l1T+q708sLlwYnYdFRo6BGh2X8S2XLKNVAfAnnT
	ghBOGjuJ5Ba/8VBjZfBDKuSCoD1voNs=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ktOXu7cO;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf24.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.53 as permitted sender) smtp.mailfrom=ackerleytng@google.com
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-13988680a69so11461778c88.0
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 16:01:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782169294; cv=none;
        d=google.com; s=arc-20240605;
        b=CFhvS/d58/PDwfFlqGu0oByk1vppW5iCaRfB2X//hB5gb+EbgonNW8dRtdkwUyNzsI
         pEJZTkqLc/gg8TG3YqhPWuC1Fmz+6DpYX+8hpi4opf7D3MwAC03EDjmwYTd4+b7w5yLX
         c5b8+NibcA5eSe8jOf6DRP92doxNjSq+Lqz7SFGZHdQg4hXjpGaLK7YRAtse58D6ShrD
         UcubSlrckzwxvRvgsNNd5h+TSEX4djpZ++YcCnd6s4SK09oc7NRQ12tteR0ca+VNA9Ck
         8zAhmvkvUSmvFeVmqIloZQDuhW0kCxZrvXYuBS/MiTFqKZDK1x7RjQ8xVJrtxBtJSco3
         ocGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=Se78T3ehOJrnIX6EVHqhbA3McVgxD20iSWZ28XYCDdw=;
        fh=kUZdesqLghxRUInHyBo6HRAqTAvZ9PAOX3a8YvukXk0=;
        b=Hwd2b6m8WpHvGaxM3PRoPxRPf8ekxlCCYiZlntMcR2LdRYUyP/iLknnE2gImOTQiaY
         /Zse28xP3DE+HH4yg33XZsLMR71AVR3hZwn+on/xlawnzbe8IfF6GTF5QxyxI1N6luEk
         hW8R8DgetahrPOOc894DJcGMY1AVpMBwLJJvQCrXvDs3/uhU5YRWgP3FgvAmDLJv8Zuc
         7PKI606dnmAHTlpmWMjWQf4bxO0raedvfMVzAtKSvpouTuKinsOAsnr1Anw/Ct6wNL4h
         vKRk6iw4h8OneI9gNBia2cJbOqsTPKZr7FQEOONl561/ofMW172Cs5cTqSWbCMXh5egv
         jEmg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782169294; x=1782774094; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=Se78T3ehOJrnIX6EVHqhbA3McVgxD20iSWZ28XYCDdw=;
        b=ktOXu7cOZgo4DKWqrqOmexXahkELm9b6wTp1DO+xBoDJuVbSYsW41v52Xz1eD1kUk2
         ojoAU9n4RkDx2aJKt3mXqFX6Q6x+2qmC3IvtIeprPbJ/jPDpqNbPQwYqueZhR/Z6mm67
         hj8WfkMcet4gcrylgojWUKzF6Tcq+VKgoCPLmImTLmbkKRWMtCpeIAzW4dQvWZM5J7NR
         1cuPe7h9vRyXIjnD9mbCrRKH0O+QZvmGNisw2asi20jeaxRXWlCA9ARPz8IvkNFuY2kl
         IWfmDITwRng0NZ8H6nALpJUVlz0EsvQ/eFWCQ/eiR/MmedD+M3sa7BfF6vQnxkHVwpla
         vrzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782169294; x=1782774094;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Se78T3ehOJrnIX6EVHqhbA3McVgxD20iSWZ28XYCDdw=;
        b=Rx4zpCCkpNyqY2Kb0nfvbcQwHyHvw2ZnmfKHjL8oygnEjxXwxmCnuRDtPUks5mBIT0
         RtoImOq+QTwd6lRv3F4bZxtckHMNtuxIiL5Tc1NXkKRQg9JvHNEArVfaEerP2BiMCaEV
         aLvYkMdTHODMuIl5ScWZn6Ynvgw34lRn486gn7jSjKS3p8VAFJlpSXT0JDSZ+5bgGx9U
         n2mRQLgNuOpicELI/GkGxGEMSdam9k07mTAMv2srNTQTuJU5PNKLsmlSCMFdQJnEp/un
         jttWDm+h0rL2u4J7pB+kxX+1yS6D9VHVIInfSDqb9S9w8nHfTxTTcUr3EzOkqPTBhnfu
         FlHQ==
X-Forwarded-Encrypted: i=1; AFNElJ+H/dimvR4yFX5sPuL1zmorVFWHl5q82sVODlF8yySoptiJs45vFv2in1zez6X4+0DM0ONClopmLg==@kvack.org
X-Gm-Message-State: AOJu0YyFJ5tf0u6WlS22ZsLJaiy1tzcJbNmt2z+lfuPUyLr89/xA6N2C
	12dJ1mpcfXCm8PBFEQlQoo+cZvUTT0+ehGh6Kn6/ke18idUbcww7VSkV+l6nyTgp5dGJYZr4XWb
	gUryF51r6ESoIMvtL1SsYS3As1cmqH1HRIGlMlss2
X-Gm-Gg: AfdE7ckHN1UDemNzYoLwNjZdaAX1kDb1JraaGA1yBujmQ3GfGGNHvhCG2lUMLlTG2k1
	BAy/jQkW2fnpLL/ni05ylCcWQxJJ+J1jxdh2V6F3CZH0nBcSv5bXr7I45ARwyOiCqP0kjL4yIWL
	jrbHaT12nu8ZkQVaY0u9Miwx9Su6vBq5QptjO/US8QnoTKjdK3QC2LNLkbsH65GvlC/zR30oNYV
	OX1aT0F5h8HMPwvj8zveTqhuLV7OOSfsgEI/yKxgmV1cRbbhOinbHGUO5IGuxMi8oU+kwNINpe8
	1gGFUo8RgpMp15ePWE0/yJzKiFT+uHteuwoeoiKaVJt7cKZZg9WoyssZXoM=
X-Received: by 2002:a05:7022:78c:b0:137:938a:1044 with SMTP id
 a92af1059eb24-139a216738cmr11302655c88.33.1782169292599; Mon, 22 Jun 2026
 16:01:32 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 22 Jun 2026 16:01:31 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 22 Jun 2026 16:01:31 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <deb20fbe3584a8c6bfda276447fe464c6553737d.1780676742.git.tarunsahu@google.com>
References: <cover.1780676742.git.tarunsahu@google.com> <deb20fbe3584a8c6bfda276447fe464c6553737d.1780676742.git.tarunsahu@google.com>
MIME-Version: 1.0
Date: Mon, 22 Jun 2026 16:01:31 -0700
X-Gm-Features: AVVi8Cfmvsh-tLhJUbMrgpAzFVY6IGOEzbMnkY3GArVYdQhVqbDKG-2CuMgaTr4
Message-ID: <CAEvNRgE2GZNiDg_g6SP_H9CDsDDAnpN7KTRWJEK18wxpTZFJZw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 10/10] selftests: kvm: Add guest_memfd_preservation_test
To: Tarun Sahu <tarunsahu@google.com>, Jonathan Corbet <corbet@lwn.net>, vannapurve@google.com, 
	fvdl@google.com, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, sagis@google.com, aneesh.kumar@kernel.org, 
	skhawaja@google.com, vipinsh@google.com, Pratyush Yadav <pratyush@kernel.org>, 
	david@redhat.com, dmatlack@google.com, mark.rutland@arm.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, 
	seanjc@google.com, axelrasmussen@google.com
Cc: linux-kselftest@vger.kernel.org, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kvm@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C3FBE180018
X-Rspam-User: 
X-Stat-Signature: 4mins5pw9scq4sio1phhqdqra7hibsw9
X-HE-Tag: 1782169295-814648
X-HE-Meta: U2FsdGVkX19zq+A0h55DdoaqoLk3Sqx+sLfImmnAs1jmpQn+q/pBVjAhF4lm/NyftZT5HCLVXTFQSs4Od6n+f8bfwo9V8xQZKUEina3kNuSbbGALlbMipue7GidvJZks1F5ItX0X6FVbHbDHRCxOJHFZ5xdN8yre+CTXP2TyOXCK5hMDqHis5yCb5zj6a43Y6cHhvqCYU/LUz6R7q89G3Z7A7ZqGH84tX2am44HklQG7rKDbovEszZp5s8vJ68FR7szyjPBNPx/Hxn3InbIEe4vplVygaDyXEr5RnQ7q08wW/FMOs7TrgQGmSyM022L7Bu1Pg7r0Vmyrmv/dnyJnkDUSYtCXkXwV9q08FasYJ0MmSlCs0zA14cXL/LXGzCC20IcwpOfhELk51U5MkxMOGJj/ifpr1o8/sQcjP8EmGjSkkT2eqPA+WlxnR9sjdKUHZ3+cGlwG1Grpz40H371NS4BlnfoWWBI39RVAWgz0mO9oF1s6k2FdPhjDknkjE8C8dAgu8Xie+nLkkl5SZN29V+cehwC/qTKJcH+r7Fbt+6VEcGXnZxWop2a2fLDCiG+Hgcd2EsaKThmIFu7dGYDKx1a0Q9/igK1hvsjlYlzHKcZWxECIL88dS3tJjphlVymfZmz+26c2jW3C8NhLpkMBvB6lR551lYg+BbwksD0ZpJbdSncQZVz+9VQXh/Km3T24E9DTYcX9XLiJk4yuOH4h8NJQZTAQhoCTf27c1Q/5vU2qXt0D0WyhqDQtz/TNOrWxsI+wdgXvpThSzIP8sHjP4CsiCFv0z5/syZN/jSPWG2uRXpypAT+BlGnYm7uE0s2MBSAA0BEegJV4mYn7yygTRaojqoWQq/L0N25KHEqc5wXGeBsBtsOXAZrPrPvNnzQpRR5zBKHKhsa/ciJcdvUPofG0YkIYBrcIqfi5jOfB0j2uYiixtH11GHkWyyXwTlX12PBaQxMoUSJ5SxB+4Ja
 /3tVFci5
 fCkLWJ4kjXrCYHqyrh8cX2lII+xip1Vu6gAqp4VTPzBn0LD0ICE1tNYsId+Psh41bvGdDF+sdrpfcyMpg3ym6iVbnAXJgsuIc9Pb+PlGVhdj+DLsBH3yM5YuNKj4ZWVRYiL1O2yMURQxmThAE4PvNkb5P1+GuiKuw7JLwz+0mTDXOLmQfcr8WTdeSCVtaafMbMnKwP6Et6JSqIAJxzBre4wLRBEMxG+7ytfPej1YCxCyKdYH+B5K65jznmLeZE9IgQSXKcga4ty1f9V4QF+HQICR124psZV+8OqyAkPxLY3b1Fboc3vp1UAMtIzHMEAfHCBzGk6Zn7s1K5VvkwKURwKX4/YjTNPwqmsUo29nsMdwCQi6XHBknXmsM1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tarun Sahu <tarunsahu@google.com> writes:

> Add a new KVM selftest `guest_memfd_preservation_test` to verify that
> guest memory backed by guest_memfd is preserved properly.
>

Don't think using backticks in commit messages is a common practice but
I might be wrong here.

> The test leverages the Live Update Orchestrator (LUO) infrastructure
> to validate that memory folios and configuration layouts are
> successfully saved and then restored during kernel live updates,
> preventing any memory loss for the guest.
>
> Here, I have used the kvm selftests framework by creating a new
> vm and mapping two memory slots to it. One is the code that is executed
> inside the vm and other is the guest_memfd whose memory is being
> written by the guest code.
>

Don't think commit messages with "I" are common either

> In Phase 1: Once data is written the vm exits and wait for the user
> to trigger the kexec.
>
> In Phase 2: A new vm is created with retrieved kvm and again two
> memory slots are assigned. Once for guest code, and another is for
> retrieved guest_memfd where guest_memfd memory is verified by the
> executed guest code. If verification succeeds, The test passes.
>
>
> [...snip...]
>
> +#define SESSION_NAME "gmem_vm_preservation_session"
> +#define VM_TOKEN 0x1001
> +#define GMEM_TOKEN 0x1002
> +
> +#define GMEM_SIZE (16ULL * 1024 * 1024)
> +#define DATA_SIZE (5ULL * 1024 * 1024)
> +
> +static size_t page_size;
> +
> +/* Deterministic byte pattern generation based on offset */
> +static inline uint8_t get_pattern_byte(size_t offset)
> +{
> +	return (uint8_t)(offset ^ 0x5A);
> +}
> +
> +static void guest_code_phase1(uint64_t gpa, uint64_t size, uint64_t data_size)
> +{
> +	uint8_t *mem = (uint8_t *)gpa;
> +	size_t i;
> +
> +	for (i = 0; i < data_size; i++)
> +		mem[i] = get_pattern_byte(i);
> +
> +	GUEST_DONE();
> +}
> +
> +static void guest_code_phase2(uint64_t gpa, uint64_t size, uint64_t data_size)
> +{
> +	uint8_t *mem = (uint8_t *)gpa;
> +	size_t i;
> +
> +	for (i = 0; i < data_size; i++) {
> +		uint8_t val = get_pattern_byte(i);
> +
> +		__GUEST_ASSERT(mem[i] == val,
> +			       "Data mismatch at offset %lu! Expected 0x%x, got 0x%x",
> +			       i, val, mem[i]);
> +	}
> +
> +	GUEST_DONE();
> +}
> +
> +static void do_phase1(void)
> +{
> +	uint64_t flags = GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_INIT_SHARED;

Is there a reason to set GUEST_MEMFD_FLAG_MMAP? We're not really
accessing that memory from the host in this test.

> +	int gmem_fd, dev_luo_fd, session_fd, ret;
> +	const uint64_t gpa = SZ_4G;
> +	struct kvm_vcpu *vcpu;
> +	const int slot = 1;
> +	struct kvm_vm *vm;
> +
> +	vm = __vm_create_shape_with_one_vcpu(VM_SHAPE_DEFAULT, &vcpu, 1,
> +					guest_code_phase1);
> +	gmem_fd = vm_create_guest_memfd(vm, GMEM_SIZE, flags);
> +	vm_set_user_memory_region2(vm, slot, KVM_MEM_GUEST_MEMFD, gpa, GMEM_SIZE, NULL,
> +				 gmem_fd, 0);
> +
> +	for (size_t i = 0; i < GMEM_SIZE; i += page_size)
> +		virt_pg_map(vm, gpa + i, gpa + i);
> +
> +	vcpu_args_set(vcpu, 3, gpa, GMEM_SIZE, DATA_SIZE);

If GMEM_SIZE and DATA_SIZE are static I think we don't have to set those
as vcpu_args_set(), they can be used as macros from within the guest.

> +
> +	vcpu_run(vcpu);
> +	TEST_ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_DONE);
> +
> +	dev_luo_fd = luo_open_device();
> +	TEST_ASSERT(dev_luo_fd >= 0, "Failed to open /dev/liveupdate");
> +
> +	session_fd = luo_create_session(dev_luo_fd, SESSION_NAME);
> +	TEST_ASSERT(session_fd >= 0, "Failed to create LUO session");
> +
> +	ret = luo_session_preserve_fd(session_fd, vm->fd, VM_TOKEN);
> +	TEST_ASSERT(ret == 0, "Failed to preserve VM file descriptor");
> +
> +	ret = luo_session_preserve_fd(session_fd, gmem_fd, GMEM_TOKEN);
> +	TEST_ASSERT(ret == 0, "Failed to preserve guest_memfd file descriptor");
> +

Thanks for showing how this works :)

> +	printf("\n============================================================\n");
> +	printf("Phase 1 Complete Successfully!\n");
> +	printf("VM file and guest_memfd file have been preserved via LUO.\n");
> +	printf("Tokens: VM_TOKEN=0x%x, GMEM_TOKEN=0x%x\n", VM_TOKEN, GMEM_TOKEN);
> +	printf("Machine Size: %llu MB, Data Size: %llu MB\n", GMEM_SIZE / SZ_1M,
> +				 DATA_SIZE / SZ_1M);
> +	printf("------------------------------------------------------------\n");
> +
> +	daemonize_and_wait();
> +}
> +
> +static struct kvm_vm *vm_create_from_fd(int resurrected_vm_fd,
> +					struct vm_shape shape)
> +{
> +	struct kvm_vm *vm;
> +
> +	vm = calloc(1, sizeof(*vm));
> +	TEST_ASSERT(vm != NULL, "Insufficient Memory");
> +
> +	vm_init_fields(vm, shape);

What would happen if the shape was changed between preserving and
restoring?

> +
> +	vm->kvm_fd = open_path_or_exit(KVM_DEV_PATH, O_RDWR);
> +	vm->fd = resurrected_vm_fd;
> +
> +	if (kvm_has_cap(KVM_CAP_BINARY_STATS_FD))
> +		vm->stats.fd = vm_get_stats_fd(vm);
> +	else
> +		vm->stats.fd = -1;
> +
> +	vm_init_memory_properties(vm);
> +
> +	return vm;
> +}
> +

I think vm_create_from_fd() could be introduced in an earlier patch to
reduce the amount of new code in this patch. Also, I think it could
perhaps be moved to kvm_util.c assuming that other test will use it too.

> +static void do_phase2(void)
> +{
> +	int retrieved_vm_fd, retrieved_gmem_fd, dev_luo_fd, session_fd;
> +	struct vm_shape shape = VM_SHAPE_DEFAULT;
> +	const uint64_t gpa = SZ_4G;
> +	struct kvm_vcpu *vcpu;
> +	const int slot = 1;
> +	struct kvm_vm *vm;
> +
> +	dev_luo_fd = luo_open_device();
> +	TEST_ASSERT(dev_luo_fd >= 0, "Failed to open /dev/liveupdate");
> +
> +	session_fd = luo_retrieve_session(dev_luo_fd, SESSION_NAME);
> +	TEST_ASSERT(session_fd >= 0, "Failed to retrieve LUO session");
> +
> +	retrieved_vm_fd = luo_session_retrieve_fd(session_fd, VM_TOKEN);
> +	TEST_ASSERT(retrieved_vm_fd >= 0, "Failed to retrieve VM file descriptor");
> +
> +	retrieved_gmem_fd = luo_session_retrieve_fd(session_fd, GMEM_TOKEN);
> +	TEST_ASSERT(retrieved_gmem_fd >= 0, "Failed to retrieve guest_memfd file descriptor");
> +
> +	vm = vm_create_from_fd(retrieved_vm_fd, shape);
> +
> +	u64 nr_pages = 2048; /* 8MB is plenty for slot0 pages */
> +

I don't think declarations are usually mixed with regular code.

> +	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, 0, 0, nr_pages, 0);
> +	kvm_vm_elf_load(vm, program_invocation_name);
> +
> +	for (int i = 0; i < NR_MEM_REGIONS; i++)
> +		vm->memslots[i] = 0;
> +
> +	struct userspace_mem_region *slot0 = memslot2region(vm, 0);
> +
> +	ucall_init(vm, slot0->region.guest_phys_addr + slot0->region.memory_size);
> +
> +	vm_set_user_memory_region2(vm, slot, KVM_MEM_GUEST_MEMFD, gpa, GMEM_SIZE, NULL,
> +				   retrieved_gmem_fd, 0);
> +
> +	for (size_t i = 0; i < GMEM_SIZE; i += page_size)
> +		virt_pg_map(vm, gpa + i, gpa + i);
> +
> +	vcpu = vm_vcpu_add(vm, 0, guest_code_phase2);
> +	kvm_arch_vm_finalize_vcpus(vm);
> +
> +	vcpu_args_set(vcpu, 3, gpa, GMEM_SIZE, DATA_SIZE);
> +
> +	printf("Resuming / Running VM in Phase 2...\n");
> +	vcpu_run(vcpu);
> +	TEST_ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_DONE);
> +
> +	printf("\nSUCCESS: Phase 2 Complete! All 5MB complex data verified intact!\n");
> +
> +	luo_session_finish(session_fd);
> +	close(session_fd);
> +	close(dev_luo_fd);
> +	/* This will also close the vm_fd */
> +	kvm_vm_free(vm);
> +	close(retrieved_gmem_fd);
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	bool phase2 = false;
> +
> +	TEST_REQUIRE(kvm_has_cap(KVM_CAP_GUEST_MEMFD));
> +	page_size = getpagesize();
> +
> +	for (int i = 1; i < argc; i++) {
> +		if (strcmp(argv[i], "--phase2") == 0)
> +			phase2 = true;
> +	}
> +

Maybe use getopt() here?

> +	if (phase2)
> +		do_phase2();
> +	else
> +		do_phase1();
> +
> +	return 0;
> +}
> --
> 2.54.0.1032.g2f8565e1d1-goog

I think we also need tests for trying to allocate while frozen, and
conversion while frozen, and trying to preserve while preservation is
not allowed.

