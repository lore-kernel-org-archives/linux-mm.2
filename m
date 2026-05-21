Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C829CD4F5E
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 12:14:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F28696B0088; Thu, 21 May 2026 08:14:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED81A6B008A; Thu, 21 May 2026 08:14:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA0CC6B008C; Thu, 21 May 2026 08:14:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CA82F6B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 08:14:00 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 91FA71A05E7
	for <linux-mm@kvack.org>; Thu, 21 May 2026 12:14:00 +0000 (UTC)
X-FDA: 84791318640.16.13CAA05
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf19.hostedemail.com (Postfix) with ESMTP id B180B1A0005
	for <linux-mm@kvack.org>; Thu, 21 May 2026 12:13:58 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PLGFtqFe;
	spf=pass (imf19.hostedemail.com: domain of tabba@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779365638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GJBi6kqgS/T+2nzhRr9ooN0dsVaPQuEMdq7fBLHxWNg=;
	b=Rf6QSWJiVBGw29ahQn1w9CgvEXaRYMBmPF6cCun88xRyytd1DWTUE9UVuhlGb7fk6FKhXJ
	oj7vDlnM0+SRBkHIkMgfNEreBaFzQgseqFeDq6mX/uCidk4HgaK163szlv2OVkmviVpOO8
	GmZZR/VBIiQGGBKoJasMk4QNvuxjXbI=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PLGFtqFe;
	spf=pass (imf19.hostedemail.com: domain of tabba@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779365638; a=rsa-sha256;
	cv=pass;
	b=TVcOJzao3LWchkKnh2YHuD4iMtexx1LR5Hvu8WxUCd7R2v3bsWHkXQaWCp5FVP6KZ+2zTm
	ru9Hgw7ds9RXit0aFCvifLe3GdOEx+CElEIqwwk0lINRx7Vb5k5Ko9CgIT9gzlmKYBdh60
	3WvFLGfBUEiFHzg4E3eEUvZ2XSpMiug=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-515548f390fso5861cf.0
        for <linux-mm@kvack.org>; Thu, 21 May 2026 05:13:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779365638; cv=none;
        d=google.com; s=arc-20240605;
        b=bj70iv0ioJtp23dhctAP9imb/2nWaKTmi2lP1/VJcF9ErlLKUPpH8PL03726zTdg3k
         ZGch16QH8KqsjSiSQ5UkbDCKVK0bKnWHHcDLPqMyG6Aq3c73ehmoo3GGqbIGQTOQUt4I
         q8EjCj9BhGM9qrs9Haz3PKkPXRJ7gf351BSauY7nfUROoyL8Gr14EhAKsEEEWVXtZD2L
         fZKANn+O63FCX4rYJqouQ2vXq1CKzR60gHEGnNQOiW8h0IKCAPZ3muXLdsTW8pu9FBnB
         4umo9e9/jbkr5o2UdBgBW3I0YqIcv4DrrnIQHxaK5A/pYbTJTvBMLTj8+v3+YO/3BY3J
         MayQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=GJBi6kqgS/T+2nzhRr9ooN0dsVaPQuEMdq7fBLHxWNg=;
        fh=TkB5gM5eUbqL2kfvo8mlO66bbDADUgV8ivPdXSOZuVU=;
        b=HGnwks2W62YPpx4KmpNY7FPt3NhV+nTM0ac2Ifiy9AsvH4XYE11rMyPjACy9FIM8Uz
         p+M+lfq9aT6RUznW3L46xocCueg9ttGeap8mzr7ymSwosTzWF8YIfkhF/xnaSEXJKZg5
         DQauJ7VYyQf5hibl4ApjSwx392D4W7WT1KfvdGr3459djoPZHQTEYJTmCc/HddP/92yn
         VNGiApS5cwcyxs7AbP1lU+c3DNPFI1IE4G7/f1Fg6TR5VtuHbWNUWSLxI8QWFPHtOO/F
         WCYjaaI3cmwaoq8uo67bMWHqF+pNJelV85jxlHusVbMfPvhty5d3UZsoS5g4QBJHosgV
         4ZhQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779365638; x=1779970438; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GJBi6kqgS/T+2nzhRr9ooN0dsVaPQuEMdq7fBLHxWNg=;
        b=PLGFtqFeCQhhlk7hlJAVOFBNJaWBwjw5hdoLptzBDoLLUIhAnKlIyz27U15EfUs8Ee
         edEyZNldoXJQOSF2SgdZqn4Bfugm3gsfD4znJU8y0LFfdHu301cyVD/v4j8VlE4OwPXD
         8hSxwZjrIgsWRnLajCEHyMRqy/hAz3pTW8Qxj0T6lIN9Jd8qYxJmXq7R8knZyW8VoV9Q
         VqvzKEvUzWFAWivT+nYSt6qKSsANrpztcaRURxVP5XYD3EQm88ZvReIuevN4fwEx1zQV
         KZIXPyx7yTqUynYNKGUAW8hYPiVku5NsAd/F8buSvl1cyxEfOTpzkhtR82LdGUSy1PCQ
         9awg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779365638; x=1779970438;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GJBi6kqgS/T+2nzhRr9ooN0dsVaPQuEMdq7fBLHxWNg=;
        b=cr4kwh3By16kye0DhW5vELfRieKU0ne3Hfl+WVh+sH30dqJHctSSytgPPYmyjfxJnY
         QokAX1N30fEaEsc20kuYxPzaRKvqVyttoXQ4fM0aHwHk4WVFSLscTEaEDEEq8jXEGxAg
         /erzxrsxMt98Rq6LbYwEzQzXTIut+cvtHPg9ghEa1MzoB8WLFfpc4hNVH+tipN0VK9ny
         /nmpqGQOYJoMiOy6s97Qsb9LXJu+fkPpUQsZk83h7OeB/OhfeW5XWjaKUiyAsuHfaKJa
         dF2RfmCTBBipkk6fjRZtnJ4ePCm4sXUzPHH/PyvDQ5IiLdB/F0zw22ta/E56NwZhNJfT
         slxw==
X-Forwarded-Encrypted: i=1; AFNElJ/YDYu6WYEM5ZxZVeL+c3HW2SMxDOJu9nrqA4Dg+7PXeXBBPp7OvyOrO2UF1wyYV59jQkmxN1N0MA==@kvack.org
X-Gm-Message-State: AOJu0Yz3YruyxRezYtEiz2Xx/YtmpAxyt70i7UrNHQLMVjcJu9A3oz3V
	PV4QpOU6OSQq3F6VkTjpb6kqMEHxDvOlV2nBViWLvtzOZnLKyvssVZVQ8jWY69KvvXMh84wtsBy
	1blW3GKPRlH9RIjEq4YkwH0O3PMAZEN7FsvNbNlEf
X-Gm-Gg: Acq92OFNDECc6NFYpIzdPmP/L8ocHIz42NgK391MThspAsW72o9fLSgh4WgXvtFZX99
	hipzV91K58p6JO/Y92hQzUsvtL5HUuCX+2v2p6L14sA7MuLcGojVf1tG72Y04bDsE5zbxP6wNjH
	UrETAVW3txYsdNWZHkZNDzgfDl4bSod9MbjM/msPR1gpJMOlWC2Uci6CNgKN7eyqligzo6sNhh0
	+aIMB5jHrG6+wqkXLV2FqLeOf6GYIpbBtfydJbDcxiRPkFpqaKW+iOwF8ANJaYKepLm0QAdbsz+
	u3337Vw4hMzkT9MVeCg=
X-Received: by 2002:a05:622a:a94e:b0:516:4f62:85f1 with SMTP id
 d75a77b69052e-516c552fa38mr6885881cf.22.1779365636942; Thu, 21 May 2026
 05:13:56 -0700 (PDT)
MIME-Version: 1.0
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com> <20260507-gmem-inplace-conversion-v6-24-91ab5a8b19a4@google.com>
In-Reply-To: <20260507-gmem-inplace-conversion-v6-24-91ab5a8b19a4@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 21 May 2026 13:13:19 +0100
X-Gm-Features: AVHnY4KHC9HIiDmjKgEge5iH3VKNmS75Hv9JyZN2WMHPkcnLceuX40X-36gd_Tk
Message-ID: <CA+EHjTzfo0_uxHbrcntLdHLaLGB3uO41+JzcyW+vHr+u=VB5=g@mail.gmail.com>
Subject: Re: [PATCH v6 24/43] KVM: selftests: Rename guest_memfd{,_offset} to gmem_{fd,offset}
To: ackerleytng@google.com
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: B180B1A0005
X-Stat-Signature: 7bk78d6hyeourojzc1shx9ydcojtp7xq
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779365638-161080
X-HE-Meta: U2FsdGVkX1+DTZjr7fFTANaYljnW9V5BfHotxpYcsISnoLqrWMW/edMzaaoxbo6G/GY5+z+5zX7WMoKzUhaILI9+SjamqWRp+MajmAxiqmSESe618z95fjtJ/gdWp/tN6TTVAf89wHfgJY+bykgmnNWOxVG2tSNMW75GdEs3QvVhFp47CYacTrYBEo0xsNvzaMeuwa6Q7Wk1ENmynAfsCAet9dixoJ/G9SBfEyZ2OGnWFMKNY798YfJI4CvRF1lOxTz31hUhiITzbTZWTPcifea+oJeyF/yx27q92E64dnHZfG2Gx7j/WapPdt4pblmfS8kz2AtnFkXPvPn8ZW3A6+cJvt/kMOJXyxdL5r6Iq9TlhqshiMcYRQyRcFQAvQoA8eI3SbfvFEobfYozFMnB+nUeY+ZdLG5VBQvT2VgPfVOjf21bWTohPTJULXCD1lMt/MNewZ5XSQWOILWK4kuHWqs2Zsz+0CM7YOJAV3Lm8ypHvTv2LtiKtQ+dYCEtksH2t9JCJ+8GVgW8AgVEgTAUqptSNQgD/T4cyqofebEq/d4sxYljDxJwg6cIKiSIxDVzVuTdY+AelwBiiYVj4oGJT6T9UNQ0/gItx12DNIutnfB3vMAL6OEhL9oLE0Gtp6SZi1VY3lYYfx7iZcky1ULxHYk1fZn7w1Tq9vLSw0iFKjtZ5XOJNtEEpGlX9ePZ381CQQwkBYjX9WOP22/WlbTfBuuBjBaxzXJ7wHU7oocaPFXXTsznwy2bOHqqIBJAD3jleXJn9uAVej6OVLdNoRv7DQIRDh5JuONQ8FyKy2tf225QYqbHE01wR0Dg1crkm03ZxAiUYAijcHZQ2YylrKo/If0XINNEo2r8Ot8LEjcvG4Zu0rt30YpxYz1e2K+YEJZr5w+WsttcMVY/8RyTHyE56nCgK7exNRtOUAA2RNimMROtwXFqU9p4dDXWeUbTn5jq8WK/Lw4pGGQ0xfyZW7S
 in87Befu
 l3aaKcGZyaAquQMEOgoBrmjiQswaR69EVdtvsRpt4hbJkPBtk1DDZWEmCet+QS3KQnuuNeLxzIVeIQqYuBS+8I9euvhyf++DcL5o4epCr6fAlYbPw2lsGG60P381/xzbwvr3/UC3mtGVvp8JX9LjvgJ23dPGAY0Y8vyOjt+sMPD3lHfABxsnQ2yYrZYttivsuVbCOtP3CWR6OXXph/xzftT9NRl0ZyKIfRwbqVri8g9dnaJuq9TvBgtCzz1eAt/M4jw6pJ44vNY1O8nlI6LDfSHF4oaFjERZOfSdIL/KrisTF7hOCQfM0gf6yrssfPH3KkhcOE6OES/tAwlo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 7 May 2026 at 21:23, Ackerley Tng via B4 Relay
<devnull+ackerleytng.google.com@kernel.org> wrote:
>
> From: Sean Christopherson <seanjc@google.com>
>
> Rename local variables and function parameters for the guest memory file
> descriptor and its offset to use a "gmem_" prefix instead of
> "guest_memfd_".
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  tools/testing/selftests/kvm/include/kvm_util.h |  6 +++---
>  tools/testing/selftests/kvm/lib/kvm_util.c     | 26 +++++++++++++-------------
>  2 files changed, 16 insertions(+), 16 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 2ecaaa0e99654..f19383376ee8e 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -690,17 +690,17 @@ int __vm_set_user_memory_region(struct kvm_vm *vm, u32 slot, u32 flags,
>                                 gpa_t gpa, u64 size, void *hva);
>  void vm_set_user_memory_region2(struct kvm_vm *vm, u32 slot, u32 flags,
>                                 gpa_t gpa, u64 size, void *hva,
> -                               u32 guest_memfd, u64 guest_memfd_offset);
> +                               u32 gmem_fd, u64 gmem_offset);
>  int __vm_set_user_memory_region2(struct kvm_vm *vm, u32 slot, u32 flags,
>                                  gpa_t gpa, u64 size, void *hva,
> -                                u32 guest_memfd, u64 guest_memfd_offset);
> +                                u32 gmem_fd, u64 gmem_offset);
>
>  void vm_userspace_mem_region_add(struct kvm_vm *vm,
>                                  enum vm_mem_backing_src_type src_type,
>                                  gpa_t gpa, u32 slot, u64 npages, u32 flags);
>  void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
>                 gpa_t gpa, u32 slot, u64 npages, u32 flags,
> -               int guest_memfd_fd, u64 guest_memfd_offset);
> +               int gmem_fd, u64 gmem_offset);
>
>  #ifndef vm_arch_has_protected_memory
>  static inline bool vm_arch_has_protected_memory(struct kvm_vm *vm)
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index df73b23a4c66a..11da9b7546d03 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -947,7 +947,7 @@ void vm_set_user_memory_region(struct kvm_vm *vm, u32 slot, u32 flags,
>
>  int __vm_set_user_memory_region2(struct kvm_vm *vm, u32 slot, u32 flags,
>                                  gpa_t gpa, u64 size, void *hva,
> -                                u32 guest_memfd, u64 guest_memfd_offset)
> +                                u32 gmem_fd, u64 gmem_offset)
>  {
>         struct kvm_userspace_memory_region2 region = {
>                 .slot = slot,
> @@ -955,8 +955,8 @@ int __vm_set_user_memory_region2(struct kvm_vm *vm, u32 slot, u32 flags,
>                 .guest_phys_addr = gpa,
>                 .memory_size = size,
>                 .userspace_addr = (uintptr_t)hva,
> -               .guest_memfd = guest_memfd,
> -               .guest_memfd_offset = guest_memfd_offset,
> +               .guest_memfd = gmem_fd,
> +               .guest_memfd_offset = gmem_offset,
>         };
>
>         TEST_REQUIRE_SET_USER_MEMORY_REGION2();
> @@ -966,10 +966,10 @@ int __vm_set_user_memory_region2(struct kvm_vm *vm, u32 slot, u32 flags,
>
>  void vm_set_user_memory_region2(struct kvm_vm *vm, u32 slot, u32 flags,
>                                 gpa_t gpa, u64 size, void *hva,
> -                               u32 guest_memfd, u64 guest_memfd_offset)
> +                               u32 gmem_fd, u64 gmem_offset)
>  {
>         int ret = __vm_set_user_memory_region2(vm, slot, flags, gpa, size, hva,
> -                                              guest_memfd, guest_memfd_offset);
> +                                              gmem_fd, gmem_offset);
>
>         TEST_ASSERT(!ret, "KVM_SET_USER_MEMORY_REGION2 failed, errno = %d (%s)",
>                     errno, strerror(errno));
> @@ -979,7 +979,7 @@ void vm_set_user_memory_region2(struct kvm_vm *vm, u32 slot, u32 flags,
>  /* FIXME: This thing needs to be ripped apart and rewritten. */
>  void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
>                 gpa_t gpa, u32 slot, u64 npages, u32 flags,
> -               int guest_memfd, u64 guest_memfd_offset)
> +               int gmem_fd, u64 gmem_offset)
>  {
>         int ret;
>         struct userspace_mem_region *region;
> @@ -1055,12 +1055,12 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
>                 region->mmap_size += alignment;
>
>         if (flags & KVM_MEM_GUEST_MEMFD) {
> -               if (guest_memfd < 0) {
> -                       u32 guest_memfd_flags = 0;
> +               if (gmem_fd < 0) {
> +                       u32 gmem_flags = 0;
>
> -                       TEST_ASSERT(!guest_memfd_offset,
> +                       TEST_ASSERT(!gmem_offset,
>                                     "Offset must be zero when creating new guest_memfd");
> -                       guest_memfd = vm_create_guest_memfd(vm, mem_size, guest_memfd_flags);
> +                       gmem_fd = vm_create_guest_memfd(vm, mem_size, gmem_flags);
>                 } else {
>                         /*
>                          * Install a unique fd for each memslot so that the fd
> @@ -1068,11 +1068,11 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
>                          * needing to track if the fd is owned by the framework
>                          * or by the caller.
>                          */
> -                       guest_memfd = kvm_dup(guest_memfd);
> +                       gmem_fd = kvm_dup(gmem_fd);
>                 }
>
> -               region->region.guest_memfd = guest_memfd;
> -               region->region.guest_memfd_offset = guest_memfd_offset;
> +               region->region.guest_memfd = gmem_fd;
> +               region->region.guest_memfd_offset = gmem_offset;
>         } else {
>                 region->region.guest_memfd = -1;
>         }
>
> --
> 2.54.0.563.g4f69b47b94-goog
>
>

