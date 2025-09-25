Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6978CAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 11:03:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E0618E0014; Thu, 25 Sep 2025 07:03:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 490ED8E0001; Thu, 25 Sep 2025 07:03:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 331AF8E0014; Thu, 25 Sep 2025 07:03:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1BE098E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 07:03:02 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BFB271A0463
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 11:03:01 +0000 (UTC)
X-FDA: 83927485362.16.BECB36F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 290841A0014
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 11:02:58 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=agBtVbfR;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758798179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r/0to4OyeGm89Kw4M6wzRihwRzmpUZBpw2U3yaSo+SQ=;
	b=r0MAHTn9jo2ypVB3JNakYHjptpo+EopsT1aTwubJfEbYj1otoMl28py+u42+ZJaTIZKqtG
	tcVOXlwrLrfTAth0qGkmWNLjAx12EOdbikBrHrLhltXh6Wz3+zJGM5eA8cLyVAoBVKvLTN
	kQTdZtKph7rUEJb2869D984s90wdWgg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=agBtVbfR;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758798179; a=rsa-sha256;
	cv=none;
	b=2+BOOOLbCtYedAkZpjznKrgRvZUXiy1SHMNk5bbyfDXJdvtFvqbsisGWPuOFvGWtsNzjWJ
	9uJtJjntyuq1QqqWirJZWtG3Jnt/6zmPN09Lq9+QQ/egOAU6f0fImRdugVoUoq9RSMk0lr
	LaPR4NdIGMpYosZSImKDMq78/J5wZok=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758798178;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=r/0to4OyeGm89Kw4M6wzRihwRzmpUZBpw2U3yaSo+SQ=;
	b=agBtVbfR/CDX62ZoTjQe3JL2DvpN2tvcwRsuc9yztOA828Br8uHlzDG56G03045wsv/U/8
	Typ9Sex658vDfJ509O5ol2e8YOCFIWXlwaGBxwOeXsdvKVJZpSuZ53LsjBKm7ehK8Mgi+4
	qtg1lZOXLuEQoq+WBusxCzLO0WBEEk0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-425-PyIpwf7pN_OlJz5DCzwLlg-1; Thu, 25 Sep 2025 07:02:57 -0400
X-MC-Unique: PyIpwf7pN_OlJz5DCzwLlg-1
X-Mimecast-MFC-AGG-ID: PyIpwf7pN_OlJz5DCzwLlg_1758798176
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-46e23a66122so5951195e9.0
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 04:02:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758798176; x=1759402976;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r/0to4OyeGm89Kw4M6wzRihwRzmpUZBpw2U3yaSo+SQ=;
        b=fH8lNdjrNOiq8gcpmEOQt/lcVplN8oUAEZBJARGY8U+85TToPQH2cpf1Vx+Jr1OsQE
         r6Z/l+BUkX56J2wnNYMRUoMIsrI4FhLcUbPEHbc7IlS/2r19ZAy8uNYUz/+uK27W7KpV
         oH54c/A2ofwCImZszr7jZvYZ0FE0jdigksaPTaflw8QF3149VnGg2DX4m7lW4A6FLU24
         UIizMffMsT7ku3WA5s9h6h+JEo9adgbtEodl1inWzby0ThGZ3Q4FiNufvnPi65bAJjk8
         sHT43bSB7TQvdYxRE5JTWtJM3Y4ToABmVVn4G0m7As3GDHSWegF+g9xWjsl3/56cdfNE
         qnBQ==
X-Forwarded-Encrypted: i=1; AJvYcCXeSY4xZ9HrS5YSK64LlxHz3PhJ4e03yDb8NDcLGdj9+WUaEe0jRBNeX8vSl2AiZimIT6FDcrBg6A==@kvack.org
X-Gm-Message-State: AOJu0YxakCUqWZkrLvcG3irLCRxXomFa37GVi8P0QthzoIt7f53gTDaU
	e984CctUeXCxYtQguiD5n5AOPPUzs570HVTfhG0Wm49QsATC5TJV+NMASg0VetcgoFRLldhJvRR
	UB+zhlGNAYe3Rz6Id1peo+klCPkXqzjojfgvN5ZpLaNzVxMC1caLh
X-Gm-Gg: ASbGncuqzOnpXdtopde6hiAQd2qtYJUmLKyebL36Jp+jI7oUCjCiL1PfowpRS510eq6
	h6o7AcOFVyC13aXsHBGoAdtKawMaBR6tQBqdESeaZ0DwylIai9gt+gAffx59xhiNL7PV90BAHCc
	bw4OTQ0gpIV5uur/AU35k8p57hQolGd8pn/IOKJC7bA6wb/GV7FUz37iI7Qo2mDv96akyytOZCO
	iZZXZ152cPfVlI9sj+n8VSoX2dtKeuo4VL7wNdenyAKfIXVkwhzK/ZqJxNvf/LpE7QQAw4VG70g
	1hkMr1m5pXWw5EA6QLsoYJsdxgCHG4/QnUyaPQVmBHJ2jDgR5FHpcEHpvb6BLllc1ufwsFqEAG9
	llKOCUqgOXFUS5/JC0ENKWHFQV+OiI4eON+H+hRrvaC0D7dq+BNk/NkmL40HdHpLv+vFY
X-Received: by 2002:a5d:64e6:0:b0:3ea:6680:8fb5 with SMTP id ffacd0b85a97d-40e458a939fmr2659878f8f.2.1758798175635;
        Thu, 25 Sep 2025 04:02:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHaRjs0B05ZyXvh1d6jlu1Ktfb++k8xqGa0tdnYe8v/SeU1yGa2CE1nYchZ3/8IlcM8uOiw9Q==
X-Received: by 2002:a5d:64e6:0:b0:3ea:6680:8fb5 with SMTP id ffacd0b85a97d-40e458a939fmr2659768f8f.2.1758798174621;
        Thu, 25 Sep 2025 04:02:54 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08? (p200300d82f3ff800c1015c9f3bc93d08.dip0.t-ipconnect.de. [2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb72facf9sm2650164f8f.13.2025.09.25.04.02.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Sep 2025 04:02:53 -0700 (PDT)
Message-ID: <cf57bdec-6a2d-4d6a-b27c-991a7e2833ab@redhat.com>
Date: Thu, 25 Sep 2025 13:02:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 06/12] KVM: guest_memfd: add module param for disabling
 TLB flushing
To: "Roy, Patrick" <roypat@amazon.co.uk>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "corbet@lwn.net" <corbet@lwn.net>, "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "joey.gouly@arm.com" <joey.gouly@arm.com>,
 "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
 "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "will@kernel.org" <will@kernel.org>, "tglx@linutronix.de"
 <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>,
 "bp@alien8.de" <bp@alien8.de>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
 "luto@kernel.org" <luto@kernel.org>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "willy@infradead.org" <willy@infradead.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
 "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
 "vbabka@suse.cz" <vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>,
 "surenb@google.com" <surenb@google.com>, "mhocko@suse.com"
 <mhocko@suse.com>, "song@kernel.org" <song@kernel.org>,
 "jolsa@kernel.org" <jolsa@kernel.org>, "ast@kernel.org" <ast@kernel.org>,
 "daniel@iogearbox.net" <daniel@iogearbox.net>,
 "andrii@kernel.org" <andrii@kernel.org>,
 "martin.lau@linux.dev" <martin.lau@linux.dev>,
 "eddyz87@gmail.com" <eddyz87@gmail.com>,
 "yonghong.song@linux.dev" <yonghong.song@linux.dev>,
 "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
 "kpsingh@kernel.org" <kpsingh@kernel.org>, "sdf@fomichev.me"
 <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>,
 "jgg@ziepe.ca" <jgg@ziepe.ca>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
 "peterx@redhat.com" <peterx@redhat.com>, "jannh@google.com"
 <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>,
 "shuah@kernel.org" <shuah@kernel.org>, "seanjc@google.com"
 <seanjc@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
 "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
 "Cali, Marco" <xmarcalx@amazon.co.uk>,
 "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 "Thomson, Jack" <jackabt@amazon.co.uk>,
 "derekmn@amazon.co.uk" <derekmn@amazon.co.uk>,
 "tabba@google.com" <tabba@google.com>,
 "ackerleytng@google.com" <ackerleytng@google.com>
References: <20250924151101.2225820-4-patrick.roy@campus.lmu.de>
 <20250924152214.7292-1-roypat@amazon.co.uk>
 <20250924152214.7292-3-roypat@amazon.co.uk>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250924152214.7292-3-roypat@amazon.co.uk>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: EZ21WYbitOVRGIUJgcx1xktBb1Bf7GDYMlNXGYhWrLA_1758798176
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 290841A0014
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 3ndso8uedmsajdhex9jyhw1k3opr3b9p
X-HE-Tag: 1758798178-146473
X-HE-Meta: U2FsdGVkX18mTMg1wEPbuQkH8cGAo42IILjF2zPzaQ5t8l73gSzu5Nk3xsZq3eoZqpzfRcw4qt+8nKr6+VgfPOk8wE4lPTysnpTHOE/QqEXooO+0BE/5j/Q7fHzYZ/IcR4s3qUd4r9BR1aV0t0IFmMqbaZEy6K3is9+GlD4Y/QnXFiRYzQo+DHzxU4ywmUWy2pQsOZfd3ekN1rD7PYj2W+MU4slWA7nUh+so8om4ivSBljeN9b3ICwBMAfKK7M3KoTvjK2BJ8OsTtNwbWIPa7V/I7c1VWfFLPwhRp2Ba4lmVYgTfH4xI0L7aF9yrXUGI4bFjI1Z5KXRIFlzg4Dnetaka4CsOER9aNNn3N/kY71mGM3BqfHLjIYXwoC4sQDY8GArXaNMb4nzoUmB4oY4QYGe9yo7WBc0vTSsazeSpQoJ97FcW6dO06XRoU9HlLeQ/gSgTDXifsjQKyFAgrBnD0uSUPl8Qgz7NM1JB4/3L8YCwTTR2jObGM61tdvt/2rwVk0/g5Su78JLFoMAQkgj/SV9RCddpeYre0aqbX4E7QzxMcxdx2VVLlcoOK8bTZc41zxF9nPirqbYHDfKqBzOR4Re8KWXukeUUslbm4tUdkGeK4/MkpyDDI3cTCXXidqe0liIJMJFpADjR7CPAAwW/tbWzaR4dZge8utCIM3lELVAeH/YAYPn2jFl1sUAFmY5cOg6cZc1xiyo4EVzNfJYdtXRTeY/nHaCi4GIoTEshFtuEu8/YjbDHDHndCeW4fIUIZGzgCX4DK7VUy0TmEK6Yc0t7Fswfv/0a1v+3M80Nvfp37kmD0IyZz3+Hz5uxpRWSMRmr2uGJp0wRCCGk9h+ZmQ7EXJtAh08ZmXgNpBqU5KfEm0nh8bwofhUDN8sA0/2QppBmcjYvHGqYjzDa9IQ7KgQOkiICmpnfL/+QO4rZtFQ8aDyN+gmDhBlWkXTVQKl9cjXAOmFl85P0ZQKwlVO
 vSsubbw6
 eQ0b+eCwnC6nTg+LvA8dlGDJlO0JhI7vU1hjoGs5suOwi6Sa3J5vc2iIF1HoUbiVwx84FAhlq88hzHusP6fo3YuDwu96HR7GzMdIvY4KQ6b0Egkfh0GVlyF7AhkFuy85Ap2Fz0TtK35tutvNAOcMJoZDD9jbpSPAHKb2SNf75agjkyNUsfStNg3IZxjnTwanrKaYkwsx5fceefCHH+X9jtn1imFhpnXIPXZhGbmQGW+27/9WHL7+P6EofYS3JZMeFX5t/mzeOmNEd52N+mQfm3wpxniL4BfHFH6+7ArYvPnp1cv8CVZfN+pRLf3mN6PwmvUBuWeSDt82XHnvmI1sLevshuO8erUClth7jlT/MLKYP1xxYY6pJf0XLVYQCGGCPsfhFSSAjX4IIlROoVOyoVqRXOx2pyxacIiVI1kXH7to0UO/5dlBS0DObKvXXTC/bf/jpOqXpdCLc6/fTAM26tKmZm9VRSFNsiIN0T5KfNwez4Iy+nxMLagSRN5mNsCOsx2eSRAJcP1MpZYwuzTqEmKdbBK4eHMtPbHCpUCxnjVUkcE5p3RbEsouiayaPGku/okV3PboEsNqYN2bf7KlNQJmBChkBAKAsCG9MkeEn7Pw1owMZFWBVM96dUL2Z5fclPk52foEp/KusI5uE21G9oMqqk6OtKO10ARJFf6frcQclbgRHIIK6e86S6BfzYozJvhH0udlxmlSxvdJZPq4i5/Mos7aklyjKVnmK6mBGAvaE0974/kS6ryYfoouB2+5ZGq/FYCsU1NdC9vc+HJGA3IeXP6fCpQ/7CVzeillu2WC1XBY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.09.25 17:22, Roy, Patrick wrote:
> Add an option to not perform TLB flushes after direct map manipulations.
> TLB flushes result in a up to 40x elongation of page faults in
> guest_memfd (scaling with the number of CPU cores), or a 5x elongation
> of memory population, which is inacceptable when wanting to use direct
> map removed guest_memfd as a drop-in replacement for existing workloads.
> 
> TLB flushes are not needed for functional correctness (the virt->phys
> mapping technically stays "correct", the kernel should simply not use it
> for a while), so we can skip them to keep performance in-line with
> "traditional" VMs.
> 
> Enabling this option means that the desired protection from
> Spectre-style attacks is not perfect, as an attacker could try to
> prevent a stale TLB entry from getting evicted, keeping it alive until
> the page it refers to is used by the guest for some sensitive data, and
> then targeting it using a spectre-gadget.
> 
> Cc: Will Deacon <will@kernel.org>
> Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
> ---
>   include/linux/kvm_host.h | 1 +
>   virt/kvm/guest_memfd.c   | 3 ++-
>   virt/kvm/kvm_main.c      | 3 +++
>   3 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 73a15cade54a..4d2bc18860fc 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2298,6 +2298,7 @@ extern unsigned int halt_poll_ns;
>   extern unsigned int halt_poll_ns_grow;
>   extern unsigned int halt_poll_ns_grow_start;
>   extern unsigned int halt_poll_ns_shrink;
> +extern bool guest_memfd_tlb_flush;
>   
>   struct kvm_device {
>   	const struct kvm_device_ops *ops;
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index b7129c4868c5..d8dd24459f0d 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -63,7 +63,8 @@ static int kvm_gmem_folio_zap_direct_map(struct folio *folio)
>   	if (!r) {
>   		unsigned long addr = (unsigned long) folio_address(folio);
>   		folio->private = (void *) ((u64) folio->private & KVM_GMEM_FOLIO_NO_DIRECT_MAP);
> -		flush_tlb_kernel_range(addr, addr + folio_size(folio));
> +		if (guest_memfd_tlb_flush)
> +			flush_tlb_kernel_range(addr, addr + folio_size(folio));
>   	}
>   
>   	return r;
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index b5e702d95230..753c06ebba7f 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -95,6 +95,9 @@ unsigned int halt_poll_ns_shrink = 2;
>   module_param(halt_poll_ns_shrink, uint, 0644);
>   EXPORT_SYMBOL_GPL(halt_poll_ns_shrink);
>   
> +bool guest_memfd_tlb_flush = true;
> +module_param(guest_memfd_tlb_flush, bool, 0444);

The parameter name is a bit too generic. I think you somehow have to 
incorporate the "direct_map" aspects.

Also, I wonder if this could be a capability per vm/guest_memfd?

Then, you could also nicely document the semantics, considerations, 
impact etc :)

-- 
Cheers

David / dhildenb


