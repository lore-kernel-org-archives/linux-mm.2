Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBAE6CDB470
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 19:50:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 944876B0088; Tue, 23 Jun 2026 15:50:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F5166B008A; Tue, 23 Jun 2026 15:50:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E5926B008C; Tue, 23 Jun 2026 15:50:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 581936B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 15:50:06 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CA4D38723C
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 19:50:05 +0000 (UTC)
X-FDA: 84912218370.16.CD1B537
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf17.hostedemail.com (Postfix) with ESMTP id F134C40005
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 19:50:03 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aBIYb0C9;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3aeM6agkKCHQlSjmfkSZmYggYdW.Ugedafmp-eecnSUc.gjY@flex--tarunsahu.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3aeM6agkKCHQlSjmfkSZmYggYdW.Ugedafmp-eecnSUc.gjY@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782244204;
	b=BwvF5ssQUpdNxicFx7vxQRUmcRfGN+VBdcP9ZDUJjJRJ3UrAZMgenwHnXDIi1gm499IANX
	X6GFDm8AuP+sagP1zAMrY1XW0bsaWXgfq0BVbxbv2eUjgDgZLgnCweT4x68phN/axtJQH+
	CUEnrby/yefVO+uRfPWJnrEuj+mAW8A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782244204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zdsj6Guo7r326E75XLxyGx3YlVfMh6UQRvA3w5OPiCM=;
	b=hZmKa2HsRLo4RlgmuZIfVIaE11haculM6YKoVOQ4+RS+tjKhgb9Yu7NKPj/aLnkjsJ1ffu
	IRnM4tC5WHsU930vywJH2Up5Gp7036+U0CE6zyGFmirOucAUCtZ2qZrwafCpfJKnal/8tu
	atNjD51rP9BTigg7kb0pR1JwujWfFgI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aBIYb0C9;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3aeM6agkKCHQlSjmfkSZmYggYdW.Ugedafmp-eecnSUc.gjY@flex--tarunsahu.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3aeM6agkKCHQlSjmfkSZmYggYdW.Ugedafmp-eecnSUc.gjY@flex--tarunsahu.bounces.google.com
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-695bbac451bso183052a12.1
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 12:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782244202; x=1782849002; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zdsj6Guo7r326E75XLxyGx3YlVfMh6UQRvA3w5OPiCM=;
        b=aBIYb0C98XFMmgiypOsrZqr8aCu0LmOS9+Ume9UP4kA9ik2K+wUn2ajJON1B6TiUab
         V+ffpH5op2KJjxTz1d/jkGbExBnBZWCrUn/oD1XuROaLnk6OckV5QvuhD2XXwugkHQm0
         SXRIEKb8b9yP/RGErvzV/DceaXRFAdbFL0gPq7Z5lBQ6FvLjhOSdTlVs5lz9Sb7Hzwkb
         XPATeNYSaWSmwkn+cISVYNtjdlkBRdILGJ9oi5QzkNPfxz2T/NLlsliVmARxyB6evAah
         d5utYRfncc+NuK9+TyZXfLaQLx6xFoxMvJItkRXGJilJxeN2SZSh07sPW69v+ls220Pd
         OCAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782244202; x=1782849002;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zdsj6Guo7r326E75XLxyGx3YlVfMh6UQRvA3w5OPiCM=;
        b=PhxCFtcXuCj5+C68zej+259ejNyC50YmlDt+li0iNIxMoVM8lt8WvAxGovlnDQ61Vo
         MSr30SQ0MoR/LzRqAibWQLri1y+qmpmA9ShH6DiVD6wt8t65qCrfv7TrW61otzoUapk+
         tsVUDcHVVC//7UJ1y1hXiOF3cr03WbMgIZPgbPAg1IE9hWeuvVmE3gfYhVTG5W2MSXtP
         M2PO0sn8YMZB94Uzus8Qnxs4R8sZfso3r8sWZgIZSK37S71Ez9d6JNkpQKqgu9qFU457
         ZfKhI9+w4Mg5OoF/dndRpXnzZS+sznlg819IIjB29QI9yclOXxZ/pxbA5dP9hRyBxfZ/
         s+tw==
X-Forwarded-Encrypted: i=1; AFNElJ/tAq1JW/6xV91quJcZ5LwvFg7F4f528y70astYNOhXIxlocKidRzxwyGrj5GZc1o9WLUCSzojRUw==@kvack.org
X-Gm-Message-State: AOJu0YzHeDBwIx7tnFtqVzSUOOM+hFleRxURWvl2sK6Wv1MHL3pes6Le
	4OEi11lfwjrE7fPq8kVoXI1e/krZ9AOtaG1H1v4I0SlSP5xSo3xjvcaIjNXie79cXwjKKrjiQKb
	VV0mpO+GvQTrhKGUDyA==
X-Received: from edbbp7.prod.google.com ([2002:a05:6402:1467:b0:692:efc2:c022])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:5253:b0:697:aee0:7a4d with SMTP id 4fb4d7f45d1cf-697dba62033mr2212935a12.6.1782244201867;
 Tue, 23 Jun 2026 12:50:01 -0700 (PDT)
Date: Tue, 23 Jun 2026 19:50:00 +0000
In-Reply-To: <CAEvNRgE2GZNiDg_g6SP_H9CDsDDAnpN7KTRWJEK18wxpTZFJZw@mail.gmail.com>
Mime-Version: 1.0
References: <cover.1780676742.git.tarunsahu@google.com> <deb20fbe3584a8c6bfda276447fe464c6553737d.1780676742.git.tarunsahu@google.com>
 <CAEvNRgE2GZNiDg_g6SP_H9CDsDDAnpN7KTRWJEK18wxpTZFJZw@mail.gmail.com>
Message-ID: <9huzldc5m3yv.fsf@tarunix.c.googlers.com>
Subject: Re: [RFC PATCH v2 10/10] selftests: kvm: Add guest_memfd_preservation_test
From: tarunsahu@google.com
To: Ackerley Tng <ackerleytng@google.com>, Jonathan Corbet <corbet@lwn.net>, vannapurve@google.com, 
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
X-Rspamd-Queue-Id: F134C40005
X-Rspam-User: 
X-Stat-Signature: hqqp1tgy5cidczqhd7oj6mned8kfbt43
X-HE-Tag: 1782244203-826154
X-HE-Meta: U2FsdGVkX19vMtEdKVszwKtFN81QaLYR6H+K4BanU0qxO9cS7VXmmdGzKqrE2ZCKtW2wyZJocBfwmOsDaa0OXvlyeTqzT1Na5NArS75vWkJ+F7cxY2WNtxjNV7nqlPmTnzEnH4koSWNtSduasqkPzQeuD8CgCXS+Am/E2tIq2QgqYQ6vB2jTlPKdC+EZ5xugk46FQn4aV8GIeE9CT//Jm0/yk6027Szs4J2HJNPqNx78XQKtYdTY1bfeJVJZ72MBB7pO59U9ngx2ChQDpgmvx3d/OsVJx6wLmNBPyrQKa2VhRIZTsnSp6nJgsE6mJdD68Olf/48KG2TqjUDX5E73B1Ryip9JiU58YEG2208rpp8+y16JWARSZD8y0adyllBoZfMM9z7h62TovWi+QXgZqmJrd151GNbETAmuD1kR1O5KiliWqnziRUCzPlv29tAlaqSDMubOkKxxPFqVtSkKaptdIpW1K2gN0wjLff7dXKgiN7b9u3aHCMdcVvV3yA1drPLJ0elLR7B+S0DHQDPClz4L8omwu6K3Ag18xLhkoOr9logLRW5MtHVdsiAzbYurBc06cUvHtULWhuNy51gbglOmW6YYXLpml8QyCYQF9OnFu6161ng/FVxcrqtZ8aYCG3l3E0zr3/kG9LfDsc2PmRpTeGupjyCsqHFYqfNccHQejwlae76NNvG4yuIg1S2IlF0K4gCoRWB/CbbElDkvz6LFsfKyPQ0Ja5V43y5RAdgtQ8yiLN3I0O8JgKruV7cUvHnsak23JFHO9nE//pBY5SdMzAG4GLvLdOD4+ALBUejSBMO8+wKz/3CIvT0Ud8zP1SJ+ejKnx2Cd1COaL2hspk9AxQqmg8fqxo1oni5WjotafRmrZDCmiNYzK0FKR4Y2hyzswDf9Xx8Obwo7az1v5/RdsZv7/473WqZ3D5iFnhIrJUfmmlbh9XQncKBhrABFbJ7tI/hwF5tZs85ycOO
 yrfXkfXq
 YpIjI+P2UqLjYLf8eqnCFtpPTdW5zl47+S5LcqZVhWAR9rlaxt5b1isgRgR1BKC1C03PUDY28ifaeUQ9wDtaeemPiPlW6HCHbYtyzHpE9hJ0PzkLeg2zIlXJ4Vw1zSy/TdK9v6pvAeqBZY7QBtM+ywUlcl8jG+HGQC8cGJqZrw65v1jN7JOCR2vmahFDP1EDUJjvpZL/bpSokbkm48kuIygRkZEo4j7n7puEGuMuQwf6FxIi4ci0AYMKqr5nxM2R7Ys+uPBi3wL3sBtoAQILrvx1KBt+xznaV7u9xEX/YfBOLgObDxgbQZK0eUY4+BdyNe1LCbJQgUiR+AkHYsUYyLaP32mJSzSj8ZxKiIMAMIX9gaP6OjfBo6Nb37p0XrCpjL4JsEyql13NWNF5bM7J2IWdYnb2W2WH4YjN1oFL/KdXZWDCf/X9qHHiBsRwciQqYhkZS3B+BbnSEUNp5RxQmAkaBLEnp4zuzA/oMF6x2pqtTcVRQAkVOc5j4vIlw1Pw7IsKy+G5HYkN78xWvzx7x4dRadlzDzAqPJ13AkXlpj02d22F0x8cKn4x/Zw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ackerley Tng <ackerleytng@google.com> writes:

> Tarun Sahu <tarunsahu@google.com> writes:
>
>> Add a new KVM selftest `guest_memfd_preservation_test` to verify that
>> guest memory backed by guest_memfd is preserved properly.
>>
>
> Don't think using backticks in commit messages is a common practice but
> I might be wrong here.
>
>> The test leverages the Live Update Orchestrator (LUO) infrastructure
>> to validate that memory folios and configuration layouts are
>> successfully saved and then restored during kernel live updates,
>> preventing any memory loss for the guest.
>>
>> Here, I have used the kvm selftests framework by creating a new
>> vm and mapping two memory slots to it. One is the code that is executed
>> inside the vm and other is the guest_memfd whose memory is being
>> written by the guest code.
>>
>
> Don't think commit messages with "I" are common either


Will take care of commit message everywhere as per the guidelines,
Sorry about that.
>
>> In Phase 1: Once data is written the vm exits and wait for the user
>> to trigger the kexec.
>>
>> In Phase 2: A new vm is created with retrieved kvm and again two
>> memory slots are assigned. Once for guest code, and another is for
>> retrieved guest_memfd where guest_memfd memory is verified by the
>> executed guest code. If verification succeeds, The test passes.
>>
>>
>> [...snip...]
>>
>> +#define SESSION_NAME "gmem_vm_preservation_session"
>> +#define VM_TOKEN 0x1001
>> +#define GMEM_TOKEN 0x1002
>> +
>> +#define GMEM_SIZE (16ULL * 1024 * 1024)
>> +#define DATA_SIZE (5ULL * 1024 * 1024)
>> +
>> +static size_t page_size;
>> +
>> +/* Deterministic byte pattern generation based on offset */
>> +static inline uint8_t get_pattern_byte(size_t offset)
>> +{
>> +	return (uint8_t)(offset ^ 0x5A);
>> +}
>> +
>> +static void guest_code_phase1(uint64_t gpa, uint64_t size, uint64_t data_size)
>> +{
>> +	uint8_t *mem = (uint8_t *)gpa;
>> +	size_t i;
>> +
>> +	for (i = 0; i < data_size; i++)
>> +		mem[i] = get_pattern_byte(i);
>> +
>> +	GUEST_DONE();
>> +}
>> +
>> +static void guest_code_phase2(uint64_t gpa, uint64_t size, uint64_t data_size)
>> +{
>> +	uint8_t *mem = (uint8_t *)gpa;
>> +	size_t i;
>> +
>> +	for (i = 0; i < data_size; i++) {
>> +		uint8_t val = get_pattern_byte(i);
>> +
>> +		__GUEST_ASSERT(mem[i] == val,
>> +			       "Data mismatch at offset %lu! Expected 0x%x, got 0x%x",
>> +			       i, val, mem[i]);
>> +	}
>> +
>> +	GUEST_DONE();
>> +}
>> +
>> +static void do_phase1(void)
>> +{
>> +	uint64_t flags = GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_INIT_SHARED;
>
> Is there a reason to set GUEST_MEMFD_FLAG_MMAP? We're not really
> accessing that memory from the host in this test.

Right, We can skip it.

>
>> +	int gmem_fd, dev_luo_fd, session_fd, ret;
>> +	const uint64_t gpa = SZ_4G;
>> +	struct kvm_vcpu *vcpu;
>> +	const int slot = 1;
>> +	struct kvm_vm *vm;
>> +
>> +	vm = __vm_create_shape_with_one_vcpu(VM_SHAPE_DEFAULT, &vcpu, 1,
>> +					guest_code_phase1);
>> +	gmem_fd = vm_create_guest_memfd(vm, GMEM_SIZE, flags);
>> +	vm_set_user_memory_region2(vm, slot, KVM_MEM_GUEST_MEMFD, gpa, GMEM_SIZE, NULL,
>> +				 gmem_fd, 0);
>> +
>> +	for (size_t i = 0; i < GMEM_SIZE; i += page_size)
>> +		virt_pg_map(vm, gpa + i, gpa + i);
>> +
>> +	vcpu_args_set(vcpu, 3, gpa, GMEM_SIZE, DATA_SIZE);
>
> If GMEM_SIZE and DATA_SIZE are static I think we don't have to set those
> as vcpu_args_set(), they can be used as macros from within the guest.

Yes, There are multiple places we can skip it, Like passing them as the
argument in the guest_code_phase1/2. Will update it.

>
>> +
>> +	vcpu_run(vcpu);
>> +	TEST_ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_DONE);
>> +
>> +	dev_luo_fd = luo_open_device();
>> +	TEST_ASSERT(dev_luo_fd >= 0, "Failed to open /dev/liveupdate");
>> +
>> +	session_fd = luo_create_session(dev_luo_fd, SESSION_NAME);
>> +	TEST_ASSERT(session_fd >= 0, "Failed to create LUO session");
>> +
>> +	ret = luo_session_preserve_fd(session_fd, vm->fd, VM_TOKEN);
>> +	TEST_ASSERT(ret == 0, "Failed to preserve VM file descriptor");
>> +
>> +	ret = luo_session_preserve_fd(session_fd, gmem_fd, GMEM_TOKEN);
>> +	TEST_ASSERT(ret == 0, "Failed to preserve guest_memfd file descriptor");
>> +
>
> Thanks for showing how this works :)

Glad to know. it helped.
. .
 v


>
>> +	printf("\n============================================================\n");
>> +	printf("Phase 1 Complete Successfully!\n");
>> +	printf("VM file and guest_memfd file have been preserved via LUO.\n");
>> +	printf("Tokens: VM_TOKEN=0x%x, GMEM_TOKEN=0x%x\n", VM_TOKEN, GMEM_TOKEN);
>> +	printf("Machine Size: %llu MB, Data Size: %llu MB\n", GMEM_SIZE / SZ_1M,
>> +				 DATA_SIZE / SZ_1M);
>> +	printf("------------------------------------------------------------\n");
>> +
>> +	daemonize_and_wait();
>> +}
>> +
>> +static struct kvm_vm *vm_create_from_fd(int resurrected_vm_fd,
>> +					struct vm_shape shape)
>> +{
>> +	struct kvm_vm *vm;
>> +
>> +	vm = calloc(1, sizeof(*vm));
>> +	TEST_ASSERT(vm != NULL, "Insufficient Memory");
>> +
>> +	vm_init_fields(vm, shape);
>
> What would happen if the shape was changed between preserving and
> restoring?
Shape must be consistent across kexec. It may break. struct vm_shape
includes two fields
1. mode: 4k, 16k or 64k mapping, how many page table bit etc.
         which are used to setup mapping with guest code, and memory.
         guest_memfd does not support mapping other than PAGE_SIZE.
2. type: This is userspace side of the vm type. And it will not have
         information about the preserved vm_type via vm_file (kernel).
         If userspace changes this on stage2, some action might not
         work. for example, if userspace is expecting vm_type to be
         COCO VM and preserved vm_type is shared, this will have
         conflict when userspace will try to perform some operation that
         only works with COCO VM.


My Question is: Why should someone change the shape, unless they are
                planning to make the vm fail?

>
>> +
>> +	vm->kvm_fd = open_path_or_exit(KVM_DEV_PATH, O_RDWR);
>> +	vm->fd = resurrected_vm_fd;
>> +
>> +	if (kvm_has_cap(KVM_CAP_BINARY_STATS_FD))
>> +		vm->stats.fd = vm_get_stats_fd(vm);
>> +	else
>> +		vm->stats.fd = -1;
>> +
>> +	vm_init_memory_properties(vm);
>> +
>> +	return vm;
>> +}
>> +
>
> I think vm_create_from_fd() could be introduced in an earlier patch to
> reduce the amount of new code in this patch. Also, I think it could
> perhaps be moved to kvm_util.c assuming that other test will use it too.
>
Makes sense, Will take of it next revision v4.


>> +static void do_phase2(void)
>> +{
>> +	int retrieved_vm_fd, retrieved_gmem_fd, dev_luo_fd, session_fd;
>> +	struct vm_shape shape = VM_SHAPE_DEFAULT;
>> +	const uint64_t gpa = SZ_4G;
>> +	struct kvm_vcpu *vcpu;
>> +	const int slot = 1;
>> +	struct kvm_vm *vm;
>> +
>> +	dev_luo_fd = luo_open_device();
>> +	TEST_ASSERT(dev_luo_fd >= 0, "Failed to open /dev/liveupdate");
>> +
>> +	session_fd = luo_retrieve_session(dev_luo_fd, SESSION_NAME);
>> +	TEST_ASSERT(session_fd >= 0, "Failed to retrieve LUO session");
>> +
>> +	retrieved_vm_fd = luo_session_retrieve_fd(session_fd, VM_TOKEN);
>> +	TEST_ASSERT(retrieved_vm_fd >= 0, "Failed to retrieve VM file descriptor");
>> +
>> +	retrieved_gmem_fd = luo_session_retrieve_fd(session_fd, GMEM_TOKEN);
>> +	TEST_ASSERT(retrieved_gmem_fd >= 0, "Failed to retrieve guest_memfd file descriptor");
>> +
>> +	vm = vm_create_from_fd(retrieved_vm_fd, shape);
>> +
>> +	u64 nr_pages = 2048; /* 8MB is plenty for slot0 pages */
>> +
>
> I don't think declarations are usually mixed with regular code.
Okay, will udpate that.

>
>> +	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, 0, 0, nr_pages, 0);
>> +	kvm_vm_elf_load(vm, program_invocation_name);
>> +
>> +	for (int i = 0; i < NR_MEM_REGIONS; i++)
>> +		vm->memslots[i] = 0;
>> +
>> +	struct userspace_mem_region *slot0 = memslot2region(vm, 0);
>> +
>> +	ucall_init(vm, slot0->region.guest_phys_addr + slot0->region.memory_size);
>> +
>> +	vm_set_user_memory_region2(vm, slot, KVM_MEM_GUEST_MEMFD, gpa, GMEM_SIZE, NULL,
>> +				   retrieved_gmem_fd, 0);
>> +
>> +	for (size_t i = 0; i < GMEM_SIZE; i += page_size)
>> +		virt_pg_map(vm, gpa + i, gpa + i);
>> +
>> +	vcpu = vm_vcpu_add(vm, 0, guest_code_phase2);
>> +	kvm_arch_vm_finalize_vcpus(vm);
>> +
>> +	vcpu_args_set(vcpu, 3, gpa, GMEM_SIZE, DATA_SIZE);
>> +
>> +	printf("Resuming / Running VM in Phase 2...\n");
>> +	vcpu_run(vcpu);
>> +	TEST_ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_DONE);
>> +
>> +	printf("\nSUCCESS: Phase 2 Complete! All 5MB complex data verified intact!\n");
>> +
>> +	luo_session_finish(session_fd);
>> +	close(session_fd);
>> +	close(dev_luo_fd);
>> +	/* This will also close the vm_fd */
>> +	kvm_vm_free(vm);
>> +	close(retrieved_gmem_fd);
>> +}
>> +
>> +int main(int argc, char *argv[])
>> +{
>> +	bool phase2 = false;
>> +
>> +	TEST_REQUIRE(kvm_has_cap(KVM_CAP_GUEST_MEMFD));
>> +	page_size = getpagesize();
>> +
>> +	for (int i = 1; i < argc; i++) {
>> +		if (strcmp(argv[i], "--phase2") == 0)
>> +			phase2 = true;
>> +	}
>> +
>
> Maybe use getopt() here?

In V3, it is update to use liveupdate library.
>
>> +	if (phase2)
>> +		do_phase2();
>> +	else
>> +		do_phase1();
>> +
>> +	return 0;
>> +}
>> --
>> 2.54.0.1032.g2f8565e1d1-goog
>
> I think we also need tests for trying to allocate while frozen, and
> conversion while frozen, and trying to preserve while preservation is
> not allowed.

Yes, We need those tests. For this series, I wanted to focus on design.
Now that we are aligned, next revision, I will send with more tests.

~Tarun

