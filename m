Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57BF1CDB47F
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 09:20:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4748D6B00A6; Thu, 25 Jun 2026 05:20:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44C176B00A7; Thu, 25 Jun 2026 05:20:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33A356B00A8; Thu, 25 Jun 2026 05:20:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0E2E96B00A6
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:20:23 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 92C9C1676FF
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 09:20:22 +0000 (UTC)
X-FDA: 84917889084.23.1322A1B
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf28.hostedemail.com (Postfix) with ESMTP id ACD1AC0002
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 09:20:20 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=U+Fh0S3e;
	spf=pass (imf28.hostedemail.com: domain of tabba@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782379220;
	b=BV3S0ToC/uY9dX7BX8Jg5pkkajkL50WkJqy1778raP00J3rCuOKqyPhoyO74ZIuEy1/WZo
	fhy+WWQsXSZgNgFaetZM3s5xvAoHRBtuvOHGQt7GHUZ/HF2YSHalJzjHBk0fITbR5cZ/UF
	/9LmKeVL6sF7iL7r0K4sB5nQg1rlHI8=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782379220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9sNVNZ83P6g0a7P8tPRt1nDyKQGm49SitMTFhdy7JFs=;
	b=Fh5O+WPUX+LgO2nGnQwzJ+dMilbUP267NUyfm1d7pchh19IFTtqj9cwhLsfDfRmHVJALCR
	Sz3hemlpMNXg0C7EXUIMMr3L5IqrC853DwLd+M7yJoMduypiCXHkMfAEPUxMsdQEtuzyRs
	emaObD+lQQhE/KFILf2iae8HqTe1dus=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=U+Fh0S3e;
	spf=pass (imf28.hostedemail.com: domain of tabba@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-51765331535so162471cf.1
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 02:20:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782379220; cv=none;
        d=google.com; s=arc-20260327;
        b=L/a/mrcjysh2KRjmCfB4RXZVmsmzMEu+C74xPtP0+1F2kaNpemxQNQtM+vGcUfNuqZ
         YibwpAjtgQdkacME0XqbmvPyVzEaHM+dnzb/Mo63vSXTERoBeuVI32yCf7wrhqnMh1Na
         P01VoLp4Di7wLRF+iJyJxb2Gsd4JgtYGtJqH8tWnBfvA6B+MblICl8RL/THZTt0SixNz
         RfHPxpzsTJk9bH5nN1tNXGSX8b17/WuSonhkEo4McTGOxsRZm5o37v5l+viz/ulIyVfM
         O3JD/MqBUXBDBJgvHpS0lbvH++c5cpWlSQLhf4/5wAZrEZM8rLlUapUJyVBMxAQy7i3z
         suXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=9sNVNZ83P6g0a7P8tPRt1nDyKQGm49SitMTFhdy7JFs=;
        fh=b9+C/qjqGxghmAZHjcRNzde0eRZjfKlWxSejQlFcbEE=;
        b=bDR8BL2/kcXbt0lgEcPKDL7Xw/GnpjsLEj516ur8O2AgxTPssl9P2EeVkVtViainoK
         vZ/FsxCCBcoQJtYVOVGAvRp85G5gU0oV6uAPsjttdwHMtw42eCeqbuU36OsVVOTny0ay
         5LBtLCL39HKXo/5gKlXlDH8pogyrvwv44oxm5BrMWOE3HfDpUAXUe1i9aZOLsfEPxm8U
         Ks+VDxd+ZEh0CDns54VSKRLaTXOQ3hbUfERshMVlMilM6QEUYcj5YpU6G3+YgUctjGNr
         78SCpicz1b8Y9BSySvPreMW0P82Pq5KJ4aAjYuyStmefb3TMi7tFcWP5CXGn68SQE4nX
         Ch3w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782379220; x=1782984020; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9sNVNZ83P6g0a7P8tPRt1nDyKQGm49SitMTFhdy7JFs=;
        b=U+Fh0S3e/ApTDCp8ft+BgGQ2qx2Sj3oPesWtv80a0tTyIrtYaHybTQ48Mz9fW2D7sr
         xd6aO3ne8L+8hA85B0D221P5FUOzg/PmqqgezcPxRmNcr7ijl2mtQqNS5y+B2se8XzhJ
         1bmJrBKVb5tROaJVKvE+hNrxVToPrNfgl5gtt/Z/SInYz2nhp1kaxDAcz/dwoYUDMm+9
         +KB4nqRO6Q85M50xfbtVhrY1aFKbXntdW8bZ6nxh1iOwNeL+lQ8qXrwM2sxV/M6zya81
         ptjHT5nN0sQY0N9coTLtBd1VOR0Zi7kzG7Q/sqokASxMuGcCu+sxA8XSyfUApVM/MQFD
         15/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782379220; x=1782984020;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=9sNVNZ83P6g0a7P8tPRt1nDyKQGm49SitMTFhdy7JFs=;
        b=mKJ7UISzsL8DBk+HMK7odq3Rk65Wz7hzKlB6bH/3M+x4u7rMldKZpbqiPShIhj3ScV
         2JbPJL6puepCQGElb4VrlkmS3jAyFr/qrVhCllR31fqIQMgtM5y7z6Vs+4l5bpJ7A1sy
         Xu0ROAsD67H1Is0aeYwPW/EA6WlYtUPuYkXq5cM5W3eV4t+VIsH9PrcYklRMA1PrTibk
         5TiM1Kklg6nOZdIvNJR9bLpqrn81ufgBlEHNNmvWfMW6VphbT3Vk5xT/UYhvTHrFtTYh
         GVxtz5uKp1ze3bZBrwzUd9wFmw4jHyv7/IIzIyglki/R+9t9KUI7eLmewT/FvXvg+1rR
         vB1Q==
X-Forwarded-Encrypted: i=1; AFNElJ86TjPUO/xfLM6LML+SaEBFr3jPwYOICg/QFoQc79uLPsVAuv0Lp5rO0DfxRn9cGlMgLLpt/4iyTA==@kvack.org
X-Gm-Message-State: AOJu0YzCHiyk6iy+VDANMFv+XVk4Cl3gwl64Mn2RuhgC0HcQHPYS2Fc+
	wsS89dsiOOH3iaiN1NEQXvtIWYhiTL0ln/kga/F6kaNz+qF5IJz3eVqKZDDpnd5nmn0Gl4Zt0kI
	C2z6u7S31qvGRVBpTRLz83C0wcEs14QzOdcrC9xQy
X-Gm-Gg: AfdE7cnd5u0KG14kC7Gak3vNK/LWZ2pEE6J0DJAT3QCACYvbvbaopMoF221RqOSVAOv
	ZcrURklZGBUlPu12tE6+Eb/gKsbUCxqr/JE0P8fD9sW+PbslXCywEDMvwIgnxDNaGhOU8nzEoZR
	9NxCEDHSchwW1eUNHqk5+kTcevoGjccHGkWLEEPFaWtmFmMCjyBLfv+/94eJr/rHRqWaZWQ1Pjl
	UNZ578SR9lH+i27JucQe5U9FU4VqUTo7+3rn3YdmdtNxFxjOlSH/vgRCDN+bX1Oc4HNQQH2/Q==
X-Received: by 2002:ac8:58cb:0:b0:4f3:5475:6b10 with SMTP id
 d75a77b69052e-51a6e9af205mr7810381cf.8.1782379219049; Thu, 25 Jun 2026
 02:20:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com> <20260618-gmem-inplace-conversion-v8-43-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-43-9d2959357853@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 25 Jun 2026 10:20:00 +0100
X-Gm-Features: AVVi8CeL3q_KiSPnBQlDtTbHhecm2C_9dXyC0RdNzrEqsxqa92mG6-FntXo0Q6U
Message-ID: <CA+EHjTx3z48aykAeQ36d=pOGEEcChWst9_T5+rOFNcxP3n9vZA@mail.gmail.com>
Subject: Re: [PATCH v8 43/46] KVM: selftests: Check fd/flags provided to
 mmap() when setting up memslot
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
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: ACD1AC0002
X-Rspam-User: 
X-Stat-Signature: jxpkdon83rpqptfix7hjm4e811rb1ozb
X-HE-Tag: 1782379220-730624
X-HE-Meta: U2FsdGVkX1+lAaR8zc4npXpAFzDeU6pOammUKBCJ5o3Oyao9f0tsUwV/MZJsPcTyOzKRoGFM36VHvl1174I4KrzxoL7KK5bfYTE+Te3SKQnNFLc12CyPZ09/E53xBOzzCNp7YrZ6aaG1QruJwaHhnubLdsb+xMWMV+L7ONOAQCky79EI63xLhLc/ma2iK0QA4CD7ZcxPJ142eaodMlJCb0JRP9utkuIgM5heHevbM+SwLXYzPxPmQr4ykjqmn3zZErTYImptNxtC6bZNNEsr+B274Y3dokT4gPWLu/YXoLPqb9RsviGq8D+MqsSpeFx+k4G6K9sM1VdKBUK9s8M3FcCynkhCRiac1aq+s/0oi1M/94Vmw6npax+ccI7jEDmi3jHFJWIEdSmKUm+nd6xNeX0Ucf6dL4+9FfDb+TzFaS95Gj+cHmaslS9mLi5Te4D2bM42q2V2zpR1NzpOw54zPsZvmYSzhSNrsvQEMdMifHqTApxZHWzPV0SkEh3/wL4BguP0G3IawtrexGJMKp81pSK5xA0snu+vG414KM7JyGAqMjeNoDmiVKJtvS5YeGcG3RotKJFPuBHELpKFkSxPb5wFJLFnumDnMn4HzGTwRq94qWMD4qUF8migDc3nwLGzp8fG8agFRM8GHLy1jmXdR0Dy++Vszan7QIwoSkgn21Td2iLXlABae1er8e4pZdEGRaTS6XE1h/W3VdJltipKu2y2EnFCF+DO/O5xpnOYrhPrufbRzNNMTFWl/GccVbYIvy4FhjTWT0S0+dN8l9OpB7gqB5G8EBDQS0yd69Pox77BUtoBvFe0aG43GndqPwu1Q4HRiYm43DaC8P7K2Wf1f/KRCbwRPaYkDGwp4ML5tFaZr5GVrYCL3RcaqDd7620NpELNlVmhfIrLWDMN0MQugQR+oYq+MW4GLcBm/tzUPv1PlcjkYqzdCAWyJhtyfH2XI34JDihP3ERDqqOBZ7Q
 IJP0JR0k
 ARSMbwb9i0ke2LlzsoO1k+aXjenJDroe1mbdPoIK5uef4vgP+ZDK/jX2Cgk70Itrk+xd9kJImRFMC3PZwUaPIiKdECga2JGlaWGIbcsZ4acDocmpoSTuzwkiMVtOChLbQllao1lLcZr6DDMS2HemU79xXJAffB+FPrsgL4J02S/uXIhL3ZYSqO6Qt4hjOzpc2IAvPawjO4pOc64fXesAlVWsNZX+D6ncUdF68UNZu9F6Cx0sIxUsgP7vYKWY9BULLzvNfbRrOWBin9GJmPfjrl970F+2DWNq+2ken
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
> Check that a valid fd provided to mmap() must be accompanied by MAP_SHARED.
>
> With an invalid fd (usually used for anonymous mappings), there are no
> constraints on mmap() flags.
>
> Add this check to make sure that when a guest_memfd is used as region->fd,
> the flag provided to mmap() will include MAP_SHARED.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> [Rephrase assertion message.]
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  tools/testing/selftests/kvm/lib/kvm_util.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 0b2256ea65ff9..6b304e8a0e0d5 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -1110,6 +1110,9 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
>                                              src_type == VM_MEM_SRC_SHARED_HUGETLB);
>         }
>
> +       TEST_ASSERT(region->fd == -1 || backing_src_is_shared(src_type),
> +                   "A valid fd provided to mmap() must be accompanied by MAP_SHARED.");
> +
>         region->mmap_start = __kvm_mmap(region->mmap_size, PROT_READ | PROT_WRITE,
>                                         vm_mem_backing_src_alias(src_type)->flag,
>                                         region->fd, mmap_offset);
>
> --
> 2.55.0.rc0.738.g0c8ab3ebcc-goog
>
>

