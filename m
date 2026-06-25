Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BECACDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 09:57:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1BE96B00B2; Thu, 25 Jun 2026 05:57:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CCE96B00B4; Thu, 25 Jun 2026 05:57:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86ED26B00B5; Thu, 25 Jun 2026 05:57:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 635FA6B00B2
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:57:27 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E8E189013D
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 09:57:26 +0000 (UTC)
X-FDA: 84917982492.05.4838113
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf12.hostedemail.com (Postfix) with ESMTP id 07BE440006
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 09:57:24 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=b0TEK0sZ;
	spf=pass (imf12.hostedemail.com: domain of tabba@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782381445;
	b=Yd4Spl+t2v0+ayZKYq5uenwbQdkk5vj7gmvOURk7DbJaVCI58Kdj7Yg5IqOYb6ZOIE2M3m
	TkZeSdmv8pW76qUQQ3rk18EKGzpb1pAshTMVkA9jV+CkhPU3qf2IVU3b5DuCfTWlQwy12p
	y9nPce0lK7mgRJYCqcXjnw6cfwKeLz4=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782381445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u/mrXMGknIREFr9L6V/jI2fkRAbyZYaUWGH07oXz/yk=;
	b=EzcsdAoKXvORcjc1xQHpyN4bq+ZgPzCXHOFRU6f0rGWZnvTBVzrKal9jCcGigD9sbhs8zB
	8kAERO7cctoE80gWAx7ioPijHpmExxD++cGdEtF4xSO8x1o4Sjkh5SMVKGUv2bjrxXFT4A
	L2XHCV5h65gezy+UYiF6VJkBDKAx5vg=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=b0TEK0sZ;
	spf=pass (imf12.hostedemail.com: domain of tabba@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-51765531803so203501cf.0
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 02:57:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782381444; cv=none;
        d=google.com; s=arc-20260327;
        b=dJ3JoBfs/iBtYTQ5D/HPmVTiPMRABC2oAu7NUNelFGASXHvWVOT+fUYyEtSZYrg4jP
         I3cCU0n7Vn75eGRUN+o0kM9A2QDw7yxeLd+NNfWsWkm/xTv67ymvS36xvQS5EH6BDpKe
         ZvpZPjy/w3Iqtcm59jY/Liyiu9+U+1U5mccqkxTHngaLa4MSS9kDzxzvJ7MJcTi5PQqh
         HHlPSeuBApxCPGCxtrtVe990c1ZKvPaSg2tLCH5N89hhBB853hM4uj5T1stf8tURTKNo
         jjAo6pd/W3czOlNCl/e40QNralXfSurj8vGsZs75ghPUX8LVoq/nDxu6gDAclAmQQsX1
         SedA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=u/mrXMGknIREFr9L6V/jI2fkRAbyZYaUWGH07oXz/yk=;
        fh=qDtQfyzZj+Bj0sWIKzZ4LFELtypFK/MyEP1TZ5vuRZ0=;
        b=p2yz8NUXFYfOuRizGIgF1d+1g3DVdWs7OQks85Gt0j1ZjArBiLGSRNJ4HzagjqOu6s
         UoRRUJVqLrjkpiOEi6uV8gSFxIYmO6SiREoyvoihDqvbZLddoG1+7eCZzow6UZb1CgPa
         YEgrM2GkE/R7KQXzOlMyU7v49AsJV22DzGmtdAxhqlontTt3smvvjpo0VsymU1f1uaHC
         i0N3PjbidJjQWQoojLo4nOV3BnwauAkuWW3zQb3rtYjPhCGO9Gxj2XC+5NyM2DcS7gm7
         o+K9NmXpAnMp191y+VsYI0IwAFo5zZk0AbGu63xi+ezVHOl4k2l/jlLU0oPT/9TWM6vu
         sXqQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782381444; x=1782986244; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=u/mrXMGknIREFr9L6V/jI2fkRAbyZYaUWGH07oXz/yk=;
        b=b0TEK0sZqINzCyPSLpcGi51Gnu5yn+3lEwL1/2HSmz4i9Ri96qC+Y7t0eZNDYTWgQr
         LaJuVj3+2RLKaYm1GLQwK4u/l4iBo3xvGyEJmoKc+Rv3+rP9t3QtfVENtGPa5P40eZHU
         /fpMS/4Au+2VvQM+gOdrO0LdIfKRoaQ8SGXYc9k7bd73ZYQ6KBxRfxN3PBoMcNDiSFCc
         X+CKYVcHQQ2wky9nsO4Ds3JMBcGRHhbOTl0q1U+rD3tflpLQGK3EtTZFY8aYefjrJdAh
         j20lCK1Jk99ymqY0KpY1s1aEQsEHk9fEOjPNZ/TSC4b5p+9rSEJk3wuy2fzyrQe6MS2J
         1CXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782381444; x=1782986244;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=u/mrXMGknIREFr9L6V/jI2fkRAbyZYaUWGH07oXz/yk=;
        b=FlK70ZiWLsi2/JjPKR+/Dr/VDsO/V1BpkzxdID5zyX2k6eA0YddUmwOCcP9br6CedZ
         nVtzLUfXcq+B3Vft2cD8fwjknGdzUYoV9ANPI1b4itESjN+a7xhvnRPY/Fwu4A5/ohxr
         d1rWhuc2RnxtUTu9qHW3UGEy78RZwLosZ7SDNm1VTEsyJh8fRqbfe5aDuV07XQgG6wEN
         iPG97JdVS/1WXDrJBrOqD4RndLYDNOVF2W6okdakMVH2Gov3NVRA4iy4YpS2CBe8MjvE
         u13mScIFUVfRt8TzUHsccq7VdPmqG0/MrrrXKEUNRgeVhvTV0BPYDXaWRruytPW1t5Je
         N+wQ==
X-Forwarded-Encrypted: i=1; AFNElJ8+VQvChWad55uPmBjp7utxhZGDIHDtsup5XxdWfbCG6F6Fjx3l6Deq8Bkwd29JJrqcBqkkKsPq2A==@kvack.org
X-Gm-Message-State: AOJu0Yw/js8yF36ksz286NKnDBROq3wBqkCJR8N2e3dEXwBrkYILsg4W
	2VqBvr6KPzDvLgJFf6VtQ/p9BUW6yRM0gB6gHEAJiP/IFJm76bMHVdyAUmEaNyyenW9Y6xOwBXA
	PEqsfPNj2IfaAvR62qYs375DKZ3L11kaQGXVj7lro
X-Gm-Gg: AfdE7ckJA4IB/P/vkmr9vXadoclQNmlRpcMOJL20O4x1Ic6WfxtK9lW95CNVKTpFfZQ
	If8fTBOYr6vmRp64+ODjT7aMpKQq681TalHeZ88iQjswr8luGKQQYLZeCaTI4Ib0iI4ZR5cMJOJ
	xl8jK4pkOzlVCqFMHE+Vl5nSjRbwUhT9adhjOCqKAjKdehQz60gwzSuRcIoLA/QL3F8jMP7xAWn
	ymhVZCVM7vWekSOyimdF7ugLoMGECygXPXUXq68dCdBezwxWTHP1C7V9lGsPSLIv0So90qyUeoN
	cQNS5lV3
X-Received: by 2002:a05:622a:1804:b0:50e:38f0:ccb2 with SMTP id
 d75a77b69052e-51a7097b73dmr6249471cf.15.1782381443129; Thu, 25 Jun 2026
 02:57:23 -0700 (PDT)
MIME-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com> <20260618-gmem-inplace-conversion-v8-46-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-46-9d2959357853@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 25 Jun 2026 10:56:00 +0100
X-Gm-Features: AVVi8Cdu5TEy7e9mOJQzpvO2gtGAQsCwELbue-J7rOmw4IFWddPVfZNy_ZtxEUs
Message-ID: <CA+EHjTw3MrKXdOjC10Q6rrxehwYZjFv7J45wK2E2PBWtSBwCRQ@mail.gmail.com>
Subject: Re: [PATCH v8 46/46] KVM: selftests: Update private memory exits test
 to work with per-gmem attributes
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 07BE440006
X-Stat-Signature: akt8ke1fy37bwyhuc3e6jnmtz6kybu3r
X-HE-Tag: 1782381444-617841
X-HE-Meta: U2FsdGVkX18pjCnZkG2Sah3nNutCgPJftbSdhV/jdyzWuKpWethhISV2jmp3LX33LEvUaZRS9CLK/axXKny+fWADNfRkkV7aSDdADDIyQOKpuZ3E0Le6faDFUM9hKhT77sewE6485zkXX79PksBR+gen9lADXaS6RcypxrQlUoWMj6Vrg3Pekh4LO6AnNxrjz4X3+hZiUmO/PHXrImNuRGfPOMBbDW88sV4mPgJXv5WutkdcbIi4lfuvosbFNoWDs+s6e+AHLl8p/lR7oHDD01F77lhqkayRtVU/94reAobDx5M/dffkceJ9UTlA/yRXM1xXXIYq+2x3USj5UAsRvakdOmaFrQBSu478paZ1m3krQj19BH1gfy6PC1PQ1T2T9iMOyH+CkDQmyip2SIVZwZNS3EzB84dySdTRcAxWdcRpKzyDEAWcdGN3tmMUd7Oo/X61WWiXPyqy4ogT23DLToiMR46RNDbxCsGAqatet0BLCprX0WTpwqNODFwVJxVV3Xx6FPf7KDLAUrl5B3z18nCpArlH67EUOuTHVbg24/r7yNE8bUlBp+ToNdHDcobU7fmNrCQan5AWlyT5rCIDzDLyYroRzhxiKibPhiOG2AqzB3eqyOpB8qPsxOlOCRwzK3b6uW8Przd8BUKJSDjYj2kq697RSJQzAQQGNZ6L0KTm8IExm2iTwL/XqJH2Os60zOLgH/gUw4dLSeji0z8zvm0A/XDQqoljKGAoj+cF8o15GszW1uk4EBT2GMaGVSdJb4ovDFaL78lkNB4tYgxliuElDb31ZUpGErMW5ZK1gb45m+mmUO4zDZkJatpxrIbW73r6D6wluJBvvraWeniYRnbec7Nt/RhUBYo9S2A9mUH4N5cNj5J7J0tmSQ8znreN09FrilEqp+I364xXLDE3pbR5sVrc/x8/aR+ZYQuyUHTa6M6HHjWFxNZGy0gsCwzZpVj/QDC+GEZl49FjvQE
 eT1eNK9m
 RlA87w6i//8W9DrDchyBDwThUqpcjAPZghpAaa1m+tBfRFCskJLGYbKE5wJTo1Vs09OsQ0KPVe1ox6AWXZZM7lJZX2ASXgM4HNITAglzf/fBh1PVopom+l31K4AcEudXjWzQNYS9mmirYqpJBAS/l/hV8r/4bJE81r7z9i+UNLlCBIOTZOPgJQZy2SKmXZPmcvMWjr1VhZ/LWT8jsnWjFXgi0lzlmKWOr+pCaZFGUQ7fZZrmu01Qg+ZZaGeUUIwlGMdZc8Inwfv4qzNK6Tn+6o1pOY9FhlTMIwbtp
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
> Skip setting memory to private in the private memory exits test when using
> per-gmem memory attributes, as memory is initialized to private by default
> for guest_memfd, and using vm_mem_set_private() on a guest_memfd instance
> requires creating guest_memfd with GUEST_MEMFD_FLAG_MMAP (which is totally
> doable, but would need to be conditional and is ultimately unnecessary).
>
> Expect an emulated MMIO instead of a memory fault exit when attributes are
> per-gmem, as deleting the memslot effectively drops the private status,
> i.e. the GPA becomes shared and thus supports emulated MMIO.
>
> Skip the "memslot not private" test entirely, as private vs. shared state
> for x86 software-protected VMs comes from the memory attributes themselves,
> and so when doing in-place conversions there can never be a disconnect
> between the expected and actual states.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  .../selftests/kvm/x86/private_mem_kvm_exits_test.c | 36 ++++++++++++++++++----
>  1 file changed, 30 insertions(+), 6 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/x86/private_mem_kvm_exits_test.c b/tools/testing/selftests/kvm/x86/private_mem_kvm_exits_test.c
> index 10db9fe6d9063..70ed16066c63e 100644
> --- a/tools/testing/selftests/kvm/x86/private_mem_kvm_exits_test.c
> +++ b/tools/testing/selftests/kvm/x86/private_mem_kvm_exits_test.c
> @@ -62,8 +62,9 @@ static void test_private_access_memslot_deleted(void)
>
>         virt_map(vm, EXITS_TEST_GVA, EXITS_TEST_GPA, EXITS_TEST_NPAGES);
>
> -       /* Request to access page privately */
> -       vm_mem_set_private(vm, EXITS_TEST_GPA, EXITS_TEST_SIZE);
> +       /* Request to access page privately. */
> +       if (!kvm_has_gmem_attributes)
> +               vm_mem_set_private(vm, EXITS_TEST_GPA, EXITS_TEST_SIZE);
>
>         pthread_create(&vm_thread, NULL,
>                        (void *(*)(void *))run_vcpu_get_exit_reason,
> @@ -74,10 +75,26 @@ static void test_private_access_memslot_deleted(void)
>         pthread_join(vm_thread, &thread_return);
>         exit_reason = (u32)(u64)thread_return;
>
> -       TEST_ASSERT_EQ(exit_reason, KVM_EXIT_MEMORY_FAULT);
> -       TEST_ASSERT_EQ(vcpu->run->memory_fault.flags, KVM_MEMORY_EXIT_FLAG_PRIVATE);
> -       TEST_ASSERT_EQ(vcpu->run->memory_fault.gpa, EXITS_TEST_GPA);
> -       TEST_ASSERT_EQ(vcpu->run->memory_fault.size, EXITS_TEST_SIZE);
> +       /*
> +        * If attributes are tracked per-gmem, deleting the memslot that points
> +        * at the gmem instance effectively makes the memory shared, and so the
> +        * read should trigger emulated MMIO.
> +        *
> +        * If attributes are tracked per-VM, deleting the memslot shouldn't
> +        * affect the private attribute, and so KVM should generate a memory
> +        * fault exit (emulated MMIO on private GPAs is disallowed).
> +        */
> +       if (kvm_has_gmem_attributes) {
> +               TEST_ASSERT_EQ(exit_reason, KVM_EXIT_MMIO);
> +               TEST_ASSERT_EQ(vcpu->run->mmio.phys_addr, EXITS_TEST_GPA);
> +               TEST_ASSERT_EQ(vcpu->run->mmio.len, sizeof(u64));
> +               TEST_ASSERT_EQ(vcpu->run->mmio.is_write, false);
> +       } else {
> +               TEST_ASSERT_EQ(exit_reason, KVM_EXIT_MEMORY_FAULT);
> +               TEST_ASSERT_EQ(vcpu->run->memory_fault.flags, KVM_MEMORY_EXIT_FLAG_PRIVATE);
> +               TEST_ASSERT_EQ(vcpu->run->memory_fault.gpa, EXITS_TEST_GPA);
> +               TEST_ASSERT_EQ(vcpu->run->memory_fault.size, EXITS_TEST_SIZE);
> +       }
>
>         kvm_vm_free(vm);
>  }
> @@ -88,6 +105,13 @@ static void test_private_access_memslot_not_private(void)
>         struct kvm_vcpu *vcpu;
>         u32 exit_reason;
>
> +       /*
> +        * Accessing non-private memory as private with a software-protected VM
> +        * isn't possible when doing in-place conversions.
> +        */
> +       if (kvm_has_gmem_attributes)
> +               return;
> +
>         vm = vm_create_shape_with_one_vcpu(protected_vm_shape, &vcpu,
>                                            guest_repeatedly_read);
>
>
> --
> 2.55.0.rc0.738.g0c8ab3ebcc-goog
>
>

