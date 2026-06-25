Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82836CDB47F
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 09:43:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A5F66B00B0; Thu, 25 Jun 2026 05:43:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47D766B00B1; Thu, 25 Jun 2026 05:43:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 395ED6B00B2; Thu, 25 Jun 2026 05:43:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F03616B00B0
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:43:35 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 115C3C2039
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 09:43:35 +0000 (UTC)
X-FDA: 84917947590.03.BD0EE35
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf30.hostedemail.com (Postfix) with ESMTP id 27D7D8000D
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 09:43:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=byaZ56ow;
	spf=pass (imf30.hostedemail.com: domain of tabba@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782380613;
	b=NTRt9zpzm2y5sxpyuZNt0efVg+DvvFnRm2KAhNENRlXguNB7gADy3ZqP2tdj5GFzt1DKDd
	MQbUYyUQJxet9+gcsOrU++qjzQ/pynhgQAyr59oM5uBgYMAnGVMPSHyf3VkSfRbvJhwe3r
	gQ+FhAcK9xfs0DTf0iKZTw01M/vJWEM=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782380613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gcCzDur02+kpX92XVlxTT3/2MUJYhXNphEvl6EVFGyM=;
	b=BzYGwP8x0h69q2Y1gHClPevPWsWxu5ORl3MBCVd2zQF/hE+NwU6MtyuZtI/bjq0MK43rzt
	bW+Mvvj/PevXIyLE0eYb8Cz0aumjggPBiTeaAX2F2mL6VfPr+nZC8mTvzo+UXLwsRajXvj
	wGRiTQjqJDoHgyGJM0cU/wWO1iU64tM=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=byaZ56ow;
	spf=pass (imf30.hostedemail.com: domain of tabba@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-519ed52bcc6so223621cf.0
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 02:43:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782380612; cv=none;
        d=google.com; s=arc-20260327;
        b=FBx8geJCKQco7kbgqdR+pYpYURkcnOp3GL25rlZZUIxn66WIj4xZSSCPbps1V8y4Ia
         M1dtt0b/XFFw4R3j8p1Q7Y+S08sNp4nV5/hD98O/58Nz42AejIhQG52KYC+NfbrTWBfo
         NyXCQ2pD+vx/SvuUhhPAnqqWpx3HYhdPlS6UwE3+fXuxd1JDrlnzTIDptBVBXQrpBlIY
         TajPXz5cNlpyIsbUjP/IWOKVlpiPNt0e+HWT7DmlgfutcZtN+2k6smlg/FLe3NjyKOZb
         PHmObOJNl8Md3KwRH1ff7R3KUKmXChYfMRPOhHrmtc0NG1zxXMV8TKMisOxzqq0IZRf5
         AXVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=gcCzDur02+kpX92XVlxTT3/2MUJYhXNphEvl6EVFGyM=;
        fh=igaoTkWopt1Ui/eo5053ngc675Vzup2UMy45od2MUKk=;
        b=EqZ1xh0Jor+XjoYL0y7Hi6OnI058d8kDrgYaW8SN6jd6uanzKkLF1XMT09e4nNzrdx
         OBmNR1CsljpH0o9X8JsTw+cPYCmx5OZFSTUyVVTyzBuWYLlxy2/mv0wesz2OzpCqnUys
         4O87na3mEtjRCj5TpD8I3uIog7agPPt+AFYskfsnaVHbx+H9zjCjyepVyRx71F5rhTkS
         TG5LqwiIY/qUir/KCZEkYTgGj2PT2/26pdpU+oH1TtnzPvZYI2Lv3s7XWXvpl8+m4xtV
         TwwyvVmNDVS8ZnEQfQwMzAsxk207DPrQr3xsxKYb/tOOi8GUD5vKxRwV8rWpTuSuJO9K
         7OMA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782380612; x=1782985412; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gcCzDur02+kpX92XVlxTT3/2MUJYhXNphEvl6EVFGyM=;
        b=byaZ56ow9VF27d0IuLpnPZot6FsnrP2ty0w+WA/Z88gLUhgzYBbGzRdofjA0ZkAHNY
         MBGOco4afT1W1uPZYM9EqnFjdh6asIok/g2ZzJVvtl5xhM3F7E/6ioPoye5t4fOnoDXr
         9IL2JcssYik1xPrwoh+1HJ6E7DXSb3FZlFAoJiEsKZDHpBvXIshNZUY71R7uoIVbPYrw
         yNxhGs6wwOc5V/U+4EYd2KF4ziFW9pG2xCN7NOvFCDWgzUmTqBXTr5FxnNphCFftxTrQ
         1s7TwRqD9duhC+R5AZ1BTf3mri+eaEhUBuCISQrC0a22OIJI3XFfdM+Kfy0PnoPDaPrb
         eQqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782380612; x=1782985412;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=gcCzDur02+kpX92XVlxTT3/2MUJYhXNphEvl6EVFGyM=;
        b=IgxpCRYCxB9wguvVhnaW1MU+9Ffyass0utQFrR8ZD8pfrPvdIVLg8xExjJj+Hd6Tcy
         hTpWBLZg2ThVWOWZ4yCxPQOhpJSVNFEXnZev4gFGehpkqLXXtWmQo9k+nglZ31aI8pNb
         7CYkfAF1p06kEhikJ7rZMh/tWj3FcLO/JcEms2n8P66Y6JzEe7zLGR++5cXv8qa6F02g
         +HCAT1er76Irbbo32N9Gb+IaV8Dws6yuJyLBfNpY4GgXS9WZI/u4yFouTWr66q8FB30H
         aW2cuMWKijXfXVofu/XLbLDffeUSDrM1zSAK2j4u/0x3ZJzhpWYFj/CjVYiGFWJEDra/
         yUkw==
X-Forwarded-Encrypted: i=1; AFNElJ8VX8abNXNq0To22YXfwQaKbgnvZLvCXHUY4tsOFrDELlSmey/hR1G65hqIYPftX7Ov2ouRyskbKQ==@kvack.org
X-Gm-Message-State: AOJu0YyMeC1NmXTFJbVl7qy7KYwcWTdBrLdYf3ijEzBlwPIRin+tchQX
	cVvkQRGrSstqX9rOzgxu3RMv5ijZGIfav4Tc+UxrfB/QlEcD/lUmm4Rz0CskmfThRgiVmW7dHsf
	9eQvupmeToLlLP1qDBHD6ybMK8F4noW3isRD3/i50
X-Gm-Gg: AfdE7cn6IC/a77tBbqzhjBsoQE7tWwuTkOt1xm+wOQonTADE3sTs0UFqc4TaUALpkSl
	3UAjssPzdL/+2tUDAEHOYKPuePuewvvQk29X8N8KxgpGiDnlskSgS7bNZx+MpjUU1P6F8USwDKC
	RC4kmn/i9j+auu/gePGl/OimbINIs/i2VurWvzU9beoDi1pZmD3AaAxmd3Pn29slinecM6mZ0cj
	LL4aZD40YYgLRw1FaUvI1oIc26Mgc4oCKVvLq+/RKhXA0nIM/JwogsY7lHg4axumhggg6V68cnK
	Y6xGGuw9
X-Received: by 2002:a05:622a:1f96:b0:516:cc18:4760 with SMTP id
 d75a77b69052e-51a709958aamr6605881cf.21.1782380606888; Thu, 25 Jun 2026
 02:43:26 -0700 (PDT)
MIME-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com> <20260618-gmem-inplace-conversion-v8-45-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-45-9d2959357853@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 25 Jun 2026 10:43:00 +0100
X-Gm-Features: AVVi8CeAgnQFawLrHeIHW8UXEeBJMVi8lMuxnjDgguWeUrHnouPWU4zA8KvTsuw
Message-ID: <CA+EHjTyddaEbaa8ohd-2uLbT=dpxPn92s0UULbckHyoCXtZMgA@mail.gmail.com>
Subject: Re: [PATCH v8 45/46] KVM: selftests: Update private_mem_conversions_test
 to mmap() guest_memfd
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
X-Stat-Signature: nnjawokkmf1w6h5yybbx6wshjtsiuwb3
X-Rspamd-Queue-Id: 27D7D8000D
X-Rspamd-Server: rspam06
X-HE-Tag: 1782380613-185280
X-HE-Meta: U2FsdGVkX19Qn2JbO9Z0aELdSdIpicd1NdpP4dfI3YyWcngorRWEawNXNO2k2Svd2yesscxWk0m4NEOOCdBOfQABxD5Ca6aAHKinVv7J1q06KiYwbubXnlcAqAqDOBA8QG8mYuSV6U1yjaYlJcOqmfnyxAJ3JJAPjlRUpLkfwB3DuwvnGQqkl4jY++jjdkfZJgD7hRhg/4JVqPJdqMH6ovnjZA+TjyF5GBDIqMO3ATokLDBehXUG+HUtAVCRL3zoMnDHBDCqhMN1uyhAFR00qVnlv2KT7xHNNt6V3kbhDDce6GHljwNt6VF9R6vFzVagj/Pa7WGhwNuaBhFCCL3DU+iAdwLSCus8BnPQ3LKdkEz72Q7xQ6El7aYsdIUttRRvBBQzBLgYNau2vohiPs9OixBUygGxlPF1iCzWbPx8F25xTn8oeror+g49pCOuMJnLJHloBdzMsyMo9Q2ckfc48q7MS57B87iu1U4fiRJo0bSouBVN/KP9C9cm/N2ZCEIxi4I+qWLKATFrHduLG8kQrataSEIGt0oqvCYqEpE8SpF96YsnvQYWDEvmA1bXyzi3piE82Y00VUkCwd35ORcDlqwX0POnIobZBSxjHPaqzWcWedEchbnWvGpC20rMU3w/UrMX4oPcJjK3Poobaa7MQOW83a/vF4cCLG9ivrdDU5YvRcQk6+1ClZjfZSUf3NP1FPni2BSJFAo29FeIrLpU3TXxAIY12apQzTAZQOJcFJdWTqlLqElXsp3Xi1LuUeBAfdFPs89FjW8eUpFrwqtMxrU3p5NC5rPyCMgNmha4QQt9M2AFzaJ6/lQGWfCX19iDKDL959XPnZSUwwOMqiROSsnwBQypNhwiT4GIu78kPK5KB+N/lrkLwnlNKUZ4qjcbtoNxzp9ZbrHXqnbCVun6+TZ6rwh+IhoDfRmLeJwoXUz6rGgeZ9juvjdApxU9yuue8Pe9DlYPOh1OvXVSiHj
 MLiGZWG9
 aD+7CuJgLr0uGP3AzFaD6KIUxxhMsshOBg3Zsg/AKBlKQUHZIvzNOmjwKC17+/Gs/0F+8xGzP+c8+jJHHDQVxYXT9j50X/6GuEPs+z+8Dw6rYatL5ULsk9PLodwEtD222H3e8akUt1xIWeuMGRudymKSKD2uz3zw6v3j5ODV1r4i+9Q6FIlpzsLsRqxglebgbshfbyRMNKy5EccrZGUPO/Mr72bs3Bl5x6t5eFGyZmVZifouKQ6/qrPJ7HkkpGHSeUzF7WouMoyn6twuvK/q2JKWnmzyV0B7eLSp31srJUKnT/3UZJybiKCPBUK+HXOgTRdP20QmDQJC+wso=
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
> Update the private memory conversions selftest to also test conversions
> that are done "in-place" via per-guest_memfd memory attributes. In-place
> conversions require the host to be able to mmap() the guest_memfd so that
> the host and guest can share the same backing physical memory.
>
> This includes several updates, that are conditioned on the system
> supporting per-guest_memfd attributes (kvm_has_gmem_attributes):
>
> 1. Set up guest_memfd requesting MMAP and INIT_SHARED.
>
> 2. With in-place conversions, the host's mapping points directly to the
>    guest's memory. When the guest converts a region to private, host access
>    to that region is blocked. Update the test to expect a SIGBUS when
>    attempting to access the host virtual address (HVA) of private memory.
>
> 3. Use vm_mem_set_memory_attributes(), which chooses how to set memory
>    attributes based on whether kvm_has_gmem_attributes.
>
> Restrict the test to using VM_MEM_SRC_SHMEM because guest_memfd's required
> mmap() flags and page sizes happens to align with those of
> VM_MEM_SRC_SHMEM. As long as VM_MEM_SRC_SHMEM is used for src_type,
> vm_mem_add() works as intended.
>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  .../kvm/x86/private_mem_conversions_test.c         | 44 ++++++++++++++++++----
>  1 file changed, 36 insertions(+), 8 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
> index 289ad10063fca..4308c67952310 100644
> --- a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
> +++ b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
> @@ -306,9 +306,12 @@ static void handle_exit_hypercall(struct kvm_vcpu *vcpu)
>         if (do_fallocate)
>                 vm_guest_mem_fallocate(vm, gpa, size, map_shared);
>
> -       if (set_attributes)
> -               vm_set_memory_attributes(vm, gpa, size,
> -                                        map_shared ? 0 : KVM_MEMORY_ATTRIBUTE_PRIVATE);
> +       if (set_attributes) {
> +               u64 attrs = map_shared ? 0 : KVM_MEMORY_ATTRIBUTE_PRIVATE;
> +
> +               vm_mem_set_memory_attributes(vm, gpa, size, attrs);
> +       }
> +
>         run->hypercall.ret = 0;
>  }
>
> @@ -352,8 +355,20 @@ static void *__test_mem_conversions(void *__vcpu)
>                                 size_t nr_bytes = min_t(size_t, vm->page_size, size - i);
>                                 u8 *hva = addr_gpa2hva(vm, gpa + i);
>
> -                               /* In all cases, the host should observe the shared data. */
> -                               memcmp_h(hva, gpa + i, uc.args[3], nr_bytes);
> +                               /*
> +                                * When using per-guest_memfd memory attributes,
> +                                * i.e. in-place conversion, host accesses will
> +                                * point at guest memory and should SIGBUS when
> +                                * guest memory is private.  When using per-VM
> +                                * attributes, i.e. separate backing for shared
> +                                * vs. private, the host should always observe
> +                                * the shared data.
> +                                */
> +                               if (kvm_has_gmem_attributes &&
> +                                   uc.args[0] == SYNC_PRIVATE)
> +                                       TEST_EXPECT_SIGBUS(READ_ONCE(*hva));
> +                               else
> +                                       memcmp_h(hva, gpa + i, uc.args[3], nr_bytes);
>
>                                 /* For shared, write the new pattern to guest memory. */
>                                 if (uc.args[0] == SYNC_SHARED)
> @@ -382,6 +397,7 @@ static void test_mem_conversions(enum vm_mem_backing_src_type src_type, u32 nr_v
>         const size_t slot_size = memfd_size / nr_memslots;
>         struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
>         pthread_t threads[KVM_MAX_VCPUS];
> +       u64 gmem_flags;
>         struct kvm_vm *vm;
>         int memfd, i;
>
> @@ -397,12 +413,17 @@ static void test_mem_conversions(enum vm_mem_backing_src_type src_type, u32 nr_v
>
>         vm_enable_cap(vm, KVM_CAP_EXIT_HYPERCALL, (1 << KVM_HC_MAP_GPA_RANGE));
>
> -       memfd = vm_create_guest_memfd(vm, memfd_size, 0);
> +       if (kvm_has_gmem_attributes)
> +               gmem_flags = GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_INIT_SHARED;
> +       else
> +               gmem_flags = 0;
> +
> +       memfd = vm_create_guest_memfd(vm, memfd_size, gmem_flags);
>
>         for (i = 0; i < nr_memslots; i++)
>                 vm_mem_add(vm, src_type, BASE_DATA_GPA + slot_size * i,
>                            BASE_DATA_SLOT + i, slot_size / vm->page_size,
> -                          KVM_MEM_GUEST_MEMFD, memfd, slot_size * i, 0);
> +                          KVM_MEM_GUEST_MEMFD, memfd, slot_size * i, gmem_flags);
>
>         for (i = 0; i < nr_vcpus; i++) {
>                 gpa_t gpa =  BASE_DATA_GPA + i * per_cpu_size;
> @@ -452,17 +473,24 @@ static void usage(const char *cmd)
>
>  int main(int argc, char *argv[])
>  {
> -       enum vm_mem_backing_src_type src_type = DEFAULT_VM_MEM_SRC;
> +       enum vm_mem_backing_src_type src_type;
>         u32 nr_memslots = 1;
>         u32 nr_vcpus = 1;
>         int opt;
>
>         TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));
>
> +       src_type = kvm_has_gmem_attributes ? VM_MEM_SRC_SHMEM :
> +                                            DEFAULT_VM_MEM_SRC;
> +
>         while ((opt = getopt(argc, argv, "hm:s:n:")) != -1) {
>                 switch (opt) {
>                 case 's':
>                         src_type = parse_backing_src_type(optarg);
> +                       TEST_ASSERT(!kvm_has_gmem_attributes ||
> +                                   src_type == VM_MEM_SRC_SHMEM,
> +                                   "Testing in-place conversions, only %s mem_type supported\n",
> +                                   vm_mem_backing_src_alias(VM_MEM_SRC_SHMEM)->name);
>                         break;
>                 case 'n':
>                         nr_vcpus = atoi_positive("nr_vcpus", optarg);
>
> --
> 2.55.0.rc0.738.g0c8ab3ebcc-goog
>
>

