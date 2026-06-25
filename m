Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E0ACCDB47F
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 08:58:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 135926B0092; Thu, 25 Jun 2026 04:58:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10CD36B0093; Thu, 25 Jun 2026 04:58:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 024E66B0095; Thu, 25 Jun 2026 04:58:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BAE466B0092
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 04:58:44 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 07918C2A4B
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:58:44 +0000 (UTC)
X-FDA: 84917834568.29.94BB330
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1DB668000B
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:58:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nDj1Ojoy;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of tabba@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782377922;
	b=IX2Gef2wFderBmR5Ba+6KmoMezYKsoHXQCY5bNB13XThL4oHDKMlRPaPFTCQ9kOVThat1L
	RTpwOGe2OjYLEZwta1HBAV6+uCB23aJ4jpJZwXHV2hpodt+yiG8DCsz1pge5RSzJyPVcZK
	pHpItxfbBqS/5aGp7+zAQmrsYpduiok=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782377922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WlALM42viJ6jSZuQC8WWXMFlP84OGAnUizlvgeGuSiM=;
	b=y6rYpjuszA5ZWvV7U8J0bwOnM5hhGyFrW5dlAPniyZZUNZiAuRHAFtTNeIK0KxhDkZYB0H
	yGVxTix7E/dLS5tgAuV5wyKHSvd2eQf0difzzJjKIPRemav6CnP4YGGlGJq3/orqsrKPea
	rLcfoZaEEr8RNhTywC8M3E5iZzABj3w=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nDj1Ojoy;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of tabba@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-519ed52bcc6so212551cf.0
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:58:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782377921; cv=none;
        d=google.com; s=arc-20260327;
        b=lB85kOBdoJwPligmEyvG+eo0iZSQx3SnNrKIw+PwEsaGjk3YNWA0apEB2hb4UowVRX
         Yx5b4vBk6k7umVCWKedTkp8GiY1KNjI3DHb0l8aDHnv+YYpzR2XhfTmhqBXouieQ3t/D
         KGycuf7nasmLsVLaQG3ba2KguPcg9ZmDXBwHPAlX2Gg6FoM9w4XL6RFQwcXbJ9/cmRt1
         8ZVqIkqGS+iQiZTbFjhDonQfL6GZ7ZxNDJ0xm94xZbq03+K1PK7Ku72Yt45rs+ekBszA
         QxEO5YtWScehdjEWOJLJbRP4bcTSVP+K4Va+HJTnX1IoxgD0c7DbstVTlYEZa28VfWlb
         BSFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=WlALM42viJ6jSZuQC8WWXMFlP84OGAnUizlvgeGuSiM=;
        fh=TJyGgcza/Aqibo6kLYsDYchqGbzAqxklsYnYrPcraqM=;
        b=nQvZx5D0pcC14Vl8JQympLwdYcsTVALyW36JaG0CvvsSJ3fH4v8RxhNTvNPWI08Etw
         f5NJmeZvbwarwxOXxu+TKAAhjw2xyZsN6p+LTnHdsJmiJ0kXQ2BStXRcab+i8WgOm07V
         HQr7I4d84Vhec84l3iH3gV5uifqPHz95B1tGv0exdFtulX5ZxaA9cofeExvuxGyYdyvd
         39uo0cSXJSSxBfnkOrySy4C8Jwf0D/LRd/CR0A3M5WHNkkuLS0eEiTFsTU3z5EQFUkyR
         Dh+n72WAAWOt+eMzlLGANzdDRFNMoQjpDF7/r8OGo6n3AOFbFWNeiKZgIMJRjapWTWZY
         m7WQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782377921; x=1782982721; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WlALM42viJ6jSZuQC8WWXMFlP84OGAnUizlvgeGuSiM=;
        b=nDj1OjoyTKLcSVrjxFZczL1r0m9XQLmJJwljaDnBVd77bs0EMZOEMAZcojgkaoPLSN
         +pPfVNMQykV0xbyjbJPqnAF30Fb/qEocCegLciO16BXev+l3wgmCeEPz3sr+ZdmLUFyu
         coQ4am4V+WzxliyBItIjXhQ7DF/GpcC0C+A4duevCkqdaw8qZ0vAUGgMonDD5Y0y9+sK
         di1EVHOhWQj4SnW+6c/woKWun3UBCdn7SEgU3Y/KLAJwfgA6TA/l16XSvFznWHfRX4bw
         y9GHD6Vo4FPcuxzjK12UTaNVjczt/24spoB5u53NBgynei8KAKrFLmDMPpAMWy0h/QYG
         KiVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782377921; x=1782982721;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=WlALM42viJ6jSZuQC8WWXMFlP84OGAnUizlvgeGuSiM=;
        b=Fv8JCG2pBKP8W+VhuI6Zl6IaWym6HvzhBCEacCgZPa6joZY8wniCv/B12XfF0rWGu7
         gGR2zFJbQnGUEmru2SRb+7KLpkcIHeA9ucKFkjxcTrq9H/EhfmSZ00uGZjx0VzXOkw0Z
         XyKPakNVZYm+QSy87DGBG7ot8R8sGjhAdxD1MGoiuVDQrWQVkfJMovH6qs8xnQCG3t+I
         SasOMxsiwXgCLkRtqkl6419LV3heZqM7GoeNIUu9wcT5GhoDJ5CqjLdw+n/JMY0j7F8v
         9aIT3PC8froPIYVWQMtlriEgcihd70G7jaEcey86fQflu8u6rpBEPy9F4geNELBsL5tx
         934Q==
X-Forwarded-Encrypted: i=1; AFNElJ+NBaukGgUnvHysppdiaSDtjWMnDKxGnnQjte1sYVVcFcjzBMTneSeXaSeSX7HU/mblGxQvUFxsAw==@kvack.org
X-Gm-Message-State: AOJu0Yxe+V37Q9TYeabhNVfQprOl80KBoz0PJAsXI1zVPmMoj3orNFvG
	MgCpi+sZJ7TbBGk7L7iwPec8igAa4dsv3IiEUbbWoXKptpPR+01NU5hEUp87WTYW6xorGwmvXuI
	YlAExf71FlnA6uLTOBs94XUJaVZK/VUfgWUG0Mh8r
X-Gm-Gg: AfdE7cktjan4M6n6sIi/1Zn/yIn5x/tUWEWSXJe/+gvovIlZV029ycIoJ5+diEB7WdM
	n0Kn5H3BgbPPKorg9j7/pcvwgoyc7ynbLSjCpVkdnJVdOzCDpSpOaxVhKi0G2G9AxK4co2qgAw6
	sz25kMk5H+h2lBsL7gYIiypQgr7bS5j/qlLaeiWzgPVqE1Hfm8Vf0B2TTAiEaZQjfglppr/4Nvy
	GV58fyRNl4esVHNyS83Jo//k9lkXJq8zuLbqXi+lHkswmjbvKL+j7Kt7A8rXZLD26weXReNuA==
X-Received: by 2002:a05:622a:4d99:b0:516:4f62:85ec with SMTP id
 d75a77b69052e-51a7097cdf7mr6284681cf.17.1782377920655; Thu, 25 Jun 2026
 01:58:40 -0700 (PDT)
MIME-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com> <20260618-gmem-inplace-conversion-v8-41-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-41-9d2959357853@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 25 Jun 2026 09:58:00 +0100
X-Gm-Features: AVVi8CfUfIb60mScgDza3EFRj37-Gqen4zYG94Wyqg-j1BEdnIuc7f71TPLwtRQ
Message-ID: <CA+EHjTyOX8Ewj1pc0-OJr9So5=wOQPUUvJeQEC1a7=0OODEAHA@mail.gmail.com>
Subject: Re: [PATCH v8 41/46] KVM: selftests: Provide function to look up
 guest_memfd details from gpa
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
X-Rspamd-Queue-Id: 1DB668000B
X-Stat-Signature: wuujmitts5at13art7b5pmmkwrr8wms9
X-HE-Tag: 1782377921-179641
X-HE-Meta: U2FsdGVkX1+0NgmfPOYywkF2CM+4bJ8+FG2VTZwDKjL2YVuES4z4IrpDvwndyE8KB7QhkfVw36UXYTbYfHhkQL4WQfJpQvlUhV1eyTG4hSAACtmCtwla4sQxthHOtVI6hkVTkyBXqBQnbzNctbkSin9ohvtSXK9n9o+HwXpYcuUJV0XdRiyGxOLlR2xLuK5x+MGK9wpqUYTvjyu3VCPCj55xOwHgaNQWlFyuP7p+LRtgUpr/2JxVvWneCCwQGxe+OEO3reqAFCovr+vP+n2m4G7BU/9Pw0xqMPNvFIsAfN8ZBsTClGsEQFvUSHY+qRuQC+H7zCaUJ8UebqegwWriTNnWC8W4kna7wbqWfdBpiaCaDqjzC6BS4S1/hluXJ0+z1wpErzaAjv46sveJ2Nsn054/Pas8ifQzHhDdmtct4yWnTugISHszfufb1mDmZWgzcM9Ix9I7ADqznPJH6RhmCiRlv1qUMNeKDBdhKyWt20F74yHQSm/0n+QpCsZcnntCsRMBgFF1a2Zbjf4DuDksVirhTKd4EA6L3MA8DOO/9+QcSlVKIZ3BoJOCceQFg3fzhmVkXIN2LrdLT0tvyNCCaX1FkzFscnSClf6qRf9qd2Cgomqi3m/1Cg2YAgl/9AelkhTOX8ARQ2dDpARP2vWExUmZWI0Ad8hIjXCo1GkhA2qDCSuFOYhlKDDuyDVQUuuY3qDJWMB1AMyNT0FFWXdyIpdUgKeDLS2eEBDPZ1FQfcEUijsAWqBCyiOoMIkvIVMcLMnXxjwe5rTr2msqLHoInynORraWdqrHMtbpwkOrANINmnEgMKJ1y3h/uLxQb8mOQtzMVPfqcY9N1KXzGFSWK3TA3DQEaATkdh6O3X+5Ul2TfXn0ZWWpktNKtAM1kxlAPDpWQb/BcjJ4XQ4ON7rUNgQK6sSGhjvk4m20XLhlFw1EsQAc25uo0U0gOHVzYIu16ATC15rsccKly88KrI/
 ShFXPYYj
 kKwT+ifQ4b6RevP8q7siHgxf492tdicH5MMzB1gGKfxHULXYHglcJC9YY+zNwf2pJ+qprlHPWfD8XWfaahV6XssKU0FW9Q0eTA+ERjbhIvte13ZLSIKUvezKdr+kw8Dw3B1AMYmr1gTfwcMf0nJrIXliTWNmF9fEyEZrGhZPd3JlBfz1KkQA4ICvpYV8ICVGn0ukzD0Fnc2Ji8obVjnfrlIhg3qkwnKOu54x56x4lp9xVFeMVi5gux7631ziFw/Gs0UCcAH2UUAb3zXluiriM6P8YzuhDFjWXqloVX4gH2/7TTx/NuTQkJ/cjGJY3Owmqhhsygf0f7ZphCHQ=
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
> Introduce a new helper, kvm_gpa_to_guest_memfd(), to find the
> guest_memfd-related details of a memory region that contains a given guest
> physical address (GPA).
>
> The function returns the file descriptor for the memfd, the offset into
> the file that corresponds to the GPA, and the number of bytes remaining
> in the region from that GPA.
>
> kvm_gpa_to_guest_memfd() was factored out from vm_guest_mem_fallocate();
> refactor vm_guest_mem_fallocate() to use the new helper.
>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  tools/testing/selftests/kvm/include/kvm_util.h |  3 +++
>  tools/testing/selftests/kvm/lib/kvm_util.c     | 37 ++++++++++++++++----------
>  2 files changed, 26 insertions(+), 14 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 79ab64ac8b869..3a6b1fa7f26ef 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -428,6 +428,9 @@ static inline void vm_enable_cap(struct kvm_vm *vm, u32 cap, u64 arg0)
>         vm_ioctl(vm, KVM_ENABLE_CAP, &enable_cap);
>  }
>
> +int kvm_gpa_to_guest_memfd(struct kvm_vm *vm, gpa_t gpa, off_t *fd_offset,
> +                          size_t *nr_bytes);
> +
>  /*
>   * KVM_SET_MEMORY_ATTRIBUTES{,2} overwrites _all_ attributes.  These
>   * flows need significant enhancements to support multiple attributes.
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 524ef97d634bf..0b2256ea65ff9 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -1305,27 +1305,20 @@ void vm_guest_mem_fallocate(struct kvm_vm *vm, u64 base, u64 size,
>                             bool punch_hole)
>  {
>         const int mode = FALLOC_FL_KEEP_SIZE | (punch_hole ? FALLOC_FL_PUNCH_HOLE : 0);
> -       struct userspace_mem_region *region;
>         u64 end = base + size;
> -       gpa_t gpa, len;
>         off_t fd_offset;
> -       int ret;
> +       int fd, ret;
> +       size_t len;
> +       gpa_t gpa;
>
>         for (gpa = base; gpa < end; gpa += len) {
> -               u64 offset;
> -
> -               region = userspace_mem_region_find(vm, gpa, gpa);
> -               TEST_ASSERT(region && region->region.flags & KVM_MEM_GUEST_MEMFD,
> -                           "Private memory region not found for GPA 0x%lx", gpa);
> +               fd = kvm_gpa_to_guest_memfd(vm, gpa, &fd_offset, &len);
> +               len = min(end - gpa, len);
>
> -               offset = gpa - region->region.guest_phys_addr;
> -               fd_offset = region->region.guest_memfd_offset + offset;
> -               len = min_t(u64, end - gpa, region->region.memory_size - offset);
> -
> -               ret = fallocate(region->region.guest_memfd, mode, fd_offset, len);
> +               ret = fallocate(fd, mode, fd_offset, len);
>                 TEST_ASSERT(!ret, "fallocate() failed to %s at %lx (len = %lu), fd = %d, mode = %x, offset = %lx",
>                             punch_hole ? "punch hole" : "allocate", gpa, len,
> -                           region->region.guest_memfd, mode, fd_offset);
> +                           fd, mode, fd_offset);
>         }
>  }
>
> @@ -1662,6 +1655,22 @@ void *addr_gpa2alias(struct kvm_vm *vm, gpa_t gpa)
>         return (void *) ((uintptr_t) region->host_alias + offset);
>  }
>
> +int kvm_gpa_to_guest_memfd(struct kvm_vm *vm, gpa_t gpa, off_t *fd_offset,
> +                          size_t *nr_bytes)
> +{
> +       struct userspace_mem_region *region;
> +       gpa_t gpa_offset;
> +
> +       region = userspace_mem_region_find(vm, gpa, gpa);
> +       TEST_ASSERT(region && region->region.flags & KVM_MEM_GUEST_MEMFD,
> +                   "guest_memfd memory region not found for GPA 0x%lx", gpa);
> +
> +       gpa_offset = gpa - region->region.guest_phys_addr;
> +       *fd_offset = region->region.guest_memfd_offset + gpa_offset;
> +       *nr_bytes = region->region.memory_size - gpa_offset;
> +       return region->region.guest_memfd;
> +}
> +
>  /* Create an interrupt controller chip for the specified VM. */
>  void vm_create_irqchip(struct kvm_vm *vm)
>  {
>
> --
> 2.55.0.rc0.738.g0c8ab3ebcc-goog
>
>

