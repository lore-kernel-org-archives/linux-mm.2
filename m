Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E200DCDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 09:09:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B864C6B00A0; Thu, 25 Jun 2026 05:09:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B378A6B00A1; Thu, 25 Jun 2026 05:09:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FE9E6B00A2; Thu, 25 Jun 2026 05:09:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 709776B00A0
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:09:15 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E77651A05FE
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 09:09:14 +0000 (UTC)
X-FDA: 84917861028.27.340D050
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0EC20A0002
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 09:09:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="E/OFe2TE";
	spf=pass (imf25.hostedemail.com: domain of tabba@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782378553;
	b=7/zLnu+vzbY86TSFTjTISEEzyKPaeSq3lFbFykRmoieTo4wxLjBymsyfj1dIQedJUxmJKn
	8TmUgx8uIbdoETC0N31gK60HKXjMXvz6iPokUwdlQRG2wEkSaXrwXpH0UNaIvl18CvtBzc
	m2wW2ZetiSzNcQ7jQLnrIBJkXw/gHkE=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782378553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R9slP6pRfRJTNIoqGcM2r5fRlSRzSJ4pkgblOXA4Ai4=;
	b=efJv/Ui8cC/9imcxCU1tb4vNR4jBDtde3MNDd/bXqgfHMdvBcL2yGkoYV8daY9uIE6xfG7
	GVN0+4q0kdvMJ4Z+usWH0o0RagbBPR6FqkMqB9l6beVAGuEI6pEVY9hGRldQRswuvlXzPG
	3vdx8KIOVbZETX9dEMPIxIeVJVs2RKE=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="E/OFe2TE";
	spf=pass (imf25.hostedemail.com: domain of tabba@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-519ed52bcc6so216131cf.0
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 02:09:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782378552; cv=none;
        d=google.com; s=arc-20260327;
        b=NtWHhDSyZGeD59/ghAkIXf+NqN3oK1DHmG26yx6o79HBT86ZVnipsgQcWJ0rtb0fYv
         2pYtJsf4mW9IxoHYaYk6qfLp7ow+MJTOo4ACQyHa0C8e1Oe40oiipbfEllQylOcoBpcj
         L/xSq3R9y2RLbUeLg7PQMqBeYFFz3RWZm66Yth0kM2h3HnBgg+xsVQUu5Kp6d3Lt9LK7
         i9y8sn1LKR58IsaEu+k8ag7ZVu9cx9J6hfQcnqA3RIfKShgG115hwZlHcbGSYzw7+9+j
         dY4WwZrJnEo2M3bMo7FjUZFVvuLehDvH0YWBLrFYAtEAJFNkzNFa7WohmskOLsbKu/uH
         wsGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=R9slP6pRfRJTNIoqGcM2r5fRlSRzSJ4pkgblOXA4Ai4=;
        fh=s6RywoyKl3j5jxCBd16yJVnJceSUBU3sJhK6+gQLuOY=;
        b=Zx1qQsKeUtXCmbGRVCYhyqbBVGzqBZREOY6bR0pKm/ndquVSujiIKCad0olwXj/0BE
         XAm3te63Tjhc1LWHEbS0iNhsSRFuSg/++/jj8kYPMEw9dHuA2NjKf+woB+USx08CPwsz
         L63NhhK9Iug+XSxq1FBYbBt3RK82NlpunORo9ggcFmieoy9hF99zW6oFQuFl3u0cy5bg
         Z1Hy4AD+RujO2DlNakVsYpO1QaRX70JmWoev8cbcobjpo2WJIobkevAvKpqIXEA3FkPW
         +G9Hw2iWl25FlQtJIGcSxHSaJEIPnLd2McUO7KkoYL+KAOhVxXgHUY4v1MnKBnbi60OG
         2EYA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782378552; x=1782983352; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=R9slP6pRfRJTNIoqGcM2r5fRlSRzSJ4pkgblOXA4Ai4=;
        b=E/OFe2TEPWXLQ9Y0Ru/SeN5wql8HNq3wgWqkbRfdWsJxq9Ii9shyHzA4oaLLKXD88Q
         QhSHCVWdJq0+IRlpMG06ZloNN95Asgp3j4KQpoz4vaxAshpcr9+rVYq+54KyV63tz17Y
         u+0TNIE4EGu85CNP8bWJhD6wAF0eTssJcEnaxPP0c+V9/HTnQ2I54z07M+qhhUwvWtHk
         R8i1aYLVGGlnxuflcYaVoQbrqX0Cs3dCkrxgj3ejS3LITyBKPIxztpRGsUaC1UedEJIh
         iaDtTqAlh6laIxxxErILRzaxj+ICkPAeBdk8eI9TzO30nf5vB0VG/XTm7ucSQBZUj7CH
         79nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782378552; x=1782983352;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=R9slP6pRfRJTNIoqGcM2r5fRlSRzSJ4pkgblOXA4Ai4=;
        b=M/zvW3PquX3I3Wd9HVEZvCwrmRHbwPwWW4g+xwwfxvk0u0+k1WhhtldnXg8CmXS9jF
         5vv4Q5deUZ15H2ocZjeqnThUGfwsyVsyJWuInTXMBDChcBNugcxBTqymMR+UV2LrOXus
         DdtRfjyFMtIy5We8tCX3rSf2sz40WKmXm0ci3a/bWCK9qyWAejrHKFJdJzVD5O5xk9NC
         6xX2Z3Whoo8YvnVpGXGuS2c4NPI7XmO1RnTF7YWdHc7GoFTpu+7HJ8JosAaYpTHhxow5
         bfL1OHeJf3ssFnSWPiTB13sms02CAWKpp7J5L0fX8QCn0nnVuo+xf20CdKQBZiZg8JJO
         MSNA==
X-Forwarded-Encrypted: i=1; AFNElJ9PE2BxYDAb6KZovZXQiHYg+xbbrBPqxD7s/c4SJcIXf6A1Ys8yVUMm4JpKV6ENN2vDThWobYcImQ==@kvack.org
X-Gm-Message-State: AOJu0Yz5CDBbyLXz+0Zo+68HeGHO9r+Ls/LkUXfpPgyYiBom67qyv+7/
	07YXFJ8xFfgfD+TGJg+G5yPAzZRQclMWo9qUmL1Gk5zHSiMtZUQovi0KE9xtCPK7NDRKD8UjLRg
	nnmH27bYCUooGtUaxznxEkL+zvdo5nuCQJbwEgMOP
X-Gm-Gg: AfdE7cm2Eif+5PJhwfDOcDXaSTgXb1u6HRU7dnpvqZRohnmP8rEBH1SijmXWundyLju
	4XqVPHHA//r1kbQqPzbXj0odLso9khke+6Kc3okMqO7TK16MOMFp8+M/YObzREijZbgJLE4FteN
	gweL6onfG0yEl9dtSI2BgylqZgDNrpS+xlOzrlBazQKNvzvIHtvhDAGr+jlQkVfNv6+wyhNStdu
	/pRGEzicP1jMizj6UmKltFvcevX3IhZvn80FeS4mjkhuoscXYmEdUtYNi9OYKhwtDgnh9Wckg==
X-Received: by 2002:a05:622a:681b:10b0:51a:713c:7444 with SMTP id
 d75a77b69052e-51a713c7d5emr4672591cf.18.1782378551258; Thu, 25 Jun 2026
 02:09:11 -0700 (PDT)
MIME-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com> <20260618-gmem-inplace-conversion-v8-42-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-42-9d2959357853@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 25 Jun 2026 10:09:00 +0100
X-Gm-Features: AVVi8CetvJC1Xv6WjNcu210fkMycJkdRkSQWNh7yK6lGtnxBBkgdQs08aLwNOyo
Message-ID: <CA+EHjTyHQa2Pmgc=0zf6emtALxAN5f8gUXoV11mShz2qdrqjTw@mail.gmail.com>
Subject: Re: [PATCH v8 42/46] KVM: selftests: Provide common function to set
 memory attributes
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
X-Rspamd-Queue-Id: 0EC20A0002
X-Stat-Signature: 7x6k7z5mk9nxng9mdjo147w76tuyz9aj
X-HE-Tag: 1782378552-799697
X-HE-Meta: U2FsdGVkX18s6J7BwHFb0tgnN916Mwyel/Lh4UeQSdWBO9ewbR5eKIPoLI9e+s9Vd46fpO88z3IxzSAtIdgleZGKZxTyUbFXtqfRPpmakkeWraTGJp12jaTz/3PLE/ifHcT8xBsCUwI28+ncqH68Im8L76ynujWHsyIoRDY2W4siK6hw77nPya2DuGmX6V+84GPKzWi8SjjP8nY16w5/ECg453R4E4HCj0Zvxec2Rd2/LPiyIH2Cbvj7O/RZGAUwWqsrwyaXgP1b/xOyJI+FI+PwMr1+bqSC6ixMBN6DGstOuUl8kG9M562rw9S+a83EPOwvp9wBVD8ngG9lkP3deuSUFPUo7ZVOYy+Mf1rPD/zuKJC6X/CwxWUPY6SADIaYx6ottFECM3iooHZn74OVaoGNSVMGrW3EMd5ZvqrgL6HTHdg+A+n45tQB5Ct+BBXcWOcNe6ji3shwrD72cyccMj2JHEsFZTBh8L3e2DPE0sbAZYMV5yC4b8FZBxWdwxX+TaNUh5pDCyZX5oK1nxzMRuFqL5i4F462DyVcpe7EDmqLXge09kZZUaiHoBv6k8ZUARM4VLbgO81FlzwEvM2umU/o5f3Svxoqf98zMR7g107dVPbMpiCtAV4dK4pza2yaAKewXTKyJsD0OFfYIg07knG81L5PW1GMZLNrDOjRPwaqbnjVs+nswSGXYgTuh9YN/Btxtk/ZA83mWweAQo0LeGHVgqHfygn3mUi0eIULImyoZAkre1Oezt5+nSQAH9VJpoJV546Z5R6FfI8CfvcaiDVhSjAF9flIw4ZSORcdUqH1PIwBOBOFHbqsTMsIP+sLRSxmOUUs3rOsiurdYwYHXCm+bL8eIXj+hDTUX8hLDNsYIB1d+5cyF2m5eLeydsKK2U7R0SzxYsF4DGm4CPouQtOGvsoa/Dl2B40y1t9Ux2IfelTy1CJ6J8Fv4OJAz+zdUaZyd6hq48YSzgoCfSC
 6RWAaJTL
 Dnb9nhutF23ckFhBE48+J46gwg26PjnxpFFLqr3My+5A1dS4RroFKmaLtMDrM/llC4ieHdJd+8fnUs3Sxbb7aFHTKpC9kDX+LLvvbgMVfH+RAPTD594Sv5DB+x12MJBiHdsEwZrgbDamE3/NA3dR88Xixa4SR8FzHJX3cC/WpK231pEgQdGdyQJvJ1YOf3AXGXp8ohBWSY/ZYOsE2092KzMfvIDbIYZaHovjVy07TUx1gT9vIYCoIHA2Wrxh8l4kTBe4/zjB4DQjRuqJFUSqX1FJdRDTpwUmQfiXE
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
> Introduce vm_mem_set_memory_attributes(), which handles setting of memory
> attributes for a range of guest physical addresses, regardless of whether
> the attributes should be set via guest_memfd or via the memory attributes
> at the VM level.
>
> Refactor existing vm_mem_set_{shared,private} functions to use the new
> function. Opportunistically update the size parameter to use size_t instead
> of u64.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  tools/testing/selftests/kvm/include/kvm_util.h | 46 +++++++++++++++++++-------
>  1 file changed, 34 insertions(+), 12 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 3a6b1fa7f26ef..db1442da21bb1 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -454,18 +454,6 @@ static inline void vm_set_memory_attributes(struct kvm_vm *vm, gpa_t gpa,
>         vm_ioctl(vm, KVM_SET_MEMORY_ATTRIBUTES, &attr);
>  }
>
> -static inline void vm_mem_set_private(struct kvm_vm *vm, gpa_t gpa,
> -                                     u64 size)
> -{
> -       vm_set_memory_attributes(vm, gpa, size, KVM_MEMORY_ATTRIBUTE_PRIVATE);
> -}
> -
> -static inline void vm_mem_set_shared(struct kvm_vm *vm, gpa_t gpa,
> -                                    u64 size)
> -{
> -       vm_set_memory_attributes(vm, gpa, size, 0);
> -}
> -
>  static inline int __gmem_set_memory_attributes(int fd, u64 offset,
>                                                size_t size, u64 attributes,
>                                                u64 *error_offset)
> @@ -532,6 +520,40 @@ static inline void gmem_set_shared(int fd, u64 offset, size_t size)
>         gmem_set_memory_attributes(fd, offset, size, 0);
>  }
>
> +static inline void vm_mem_set_memory_attributes(struct kvm_vm *vm, gpa_t gpa,
> +                                               size_t size, u64 attrs)
> +{
> +       if (kvm_has_gmem_attributes) {
> +               gpa_t end = gpa + size;
> +               off_t fd_offset;
> +               gpa_t addr;
> +               size_t len;
> +               int fd;
> +
> +               for (addr = gpa; addr < end; addr += len) {
> +                       fd = kvm_gpa_to_guest_memfd(vm, addr, &fd_offset, &len);
> +                       len = min(end - addr, len);
> +
> +                       gmem_set_memory_attributes(fd, fd_offset, len, attrs);
> +               }
> +       } else {
> +               vm_set_memory_attributes(vm, gpa, size, attrs);
> +       }
> +}
> +
> +static inline void vm_mem_set_private(struct kvm_vm *vm, gpa_t gpa,
> +                                     size_t size)
> +{
> +       vm_mem_set_memory_attributes(vm, gpa, size,
> +                                    KVM_MEMORY_ATTRIBUTE_PRIVATE);
> +}
> +
> +static inline void vm_mem_set_shared(struct kvm_vm *vm, gpa_t gpa,
> +                                    size_t size)
> +{
> +       vm_mem_set_memory_attributes(vm, gpa, size, 0);
> +}
> +
>  void vm_guest_mem_fallocate(struct kvm_vm *vm, gpa_t gpa, u64 size,
>                             bool punch_hole);
>
>
> --
> 2.55.0.rc0.738.g0c8ab3ebcc-goog
>
>

