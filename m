Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CADDACCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 11:08:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 221E38E012F; Tue,  4 Nov 2025 06:08:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F8DE8E0124; Tue,  4 Nov 2025 06:08:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10EEA8E012F; Tue,  4 Nov 2025 06:08:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F12738E0124
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 06:08:28 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7A879C0466
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 11:08:28 +0000 (UTC)
X-FDA: 84072651096.18.3F41CE5
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9B8CF180009
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 11:08:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bkjzfBjR;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 3qN4JaQgKCNsG79HJ7K8DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3qN4JaQgKCNsG79HJ7K8DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762254506; a=rsa-sha256;
	cv=none;
	b=QSY3nLfay0NLBypmRttnCc0I7+C3l1K70KmJRoEZvIMQx1ZvREqHVQxDKzwOvEbiZlzVgd
	TNkh4lI+kHROJrCgYB4z4Jvoqa8wMuvnBc2GBFiDo7LMpkY/vWYv+0tHwPnaQnbn+xTA3+
	DJXl5Gsy3Za8fJtzsAqF27mlO4Dn8oU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bkjzfBjR;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 3qN4JaQgKCNsG79HJ7K8DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3qN4JaQgKCNsG79HJ7K8DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762254506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a4cH/AxQtviVkhj7n7m5X/IItvMNFrrOxnPoGxdV9l8=;
	b=wthLh7mJ8ngGbHx6CWwqoD6aobh+VDvOhOK7w5+0MkCHnF/WXcIonkwKGfXzE5D9el3hU9
	11qr5dktHBdodzzJjIf20OXR4tOMriAytNdEiHVnh9ewX2ee3jadJ/3NiJBU18vLHiRort
	oVkQDEosyNiDitun8lKeliSITSwDStE=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-47106a388cfso42053045e9.0
        for <linux-mm@kvack.org>; Tue, 04 Nov 2025 03:08:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762254505; x=1762859305; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=a4cH/AxQtviVkhj7n7m5X/IItvMNFrrOxnPoGxdV9l8=;
        b=bkjzfBjRViDiKlzjuzUlY2C8nNrmnpjzoTleBILoOoPGrDcPjRvlvSXaKz+GrKzKEw
         Z247Aw62VAm5AC8Mo7EEZCIiRqwsluT1Nn3/F68318P9x7wI3Ynmdb742Ige7VLrvp1V
         CNJDp5fTmLizgN0oAZGnGPagN3RQGgMsJPK1p7c0gLcCHQ0NW4E+pYnFM+56myKU4me5
         p852QjeQefQYGeQnU+tVLjIWW/LssA4NoxDNv39lYaF1MyWeRngqHVa34ejNqFRLR1+P
         A45wa8gglWUuSjsGlsIC82xgCXHQku6bEyD4Z2ES0aWogL0Eg0Wb8lUDE7guWldfgKtQ
         Duxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762254505; x=1762859305;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a4cH/AxQtviVkhj7n7m5X/IItvMNFrrOxnPoGxdV9l8=;
        b=tA8HWg1NNjH14NlDc8AKRppDaHVVBumYZWRDSX7mTn88mihD+tdxmRFr+lY45DR3KC
         YgdHu1lKfCN6nqKPHwWoSivWl68c76/avegfdczt6DQAVuVGdVs021POWUC3HbN1eUKA
         2vq0M8vnWiFypzZQQY8wrItWJ+lLnRJfAu0EOomct6D43yi6l0CZ1aenf17qBypskMlU
         YTPhrfR7u0A1grFcLdkAyqns/N4QXiLe0U20tB9E/d+0XMq+phkeY3OIjBE3FvyWE3Rh
         +iO2Vb3eM7YCDwjMbNMDCt/aIHbnHqardLdZUGc/UMQNf9yBMZ+chJ/Mh+9zx4YZqBuq
         Fvbg==
X-Forwarded-Encrypted: i=1; AJvYcCUQm+pOVI5AkixfnB1y2xhasKAwEawxGeuxAC/ITiz9d239VRajBi4nKdlDMUdWa8G3YYxb2gjEZg==@kvack.org
X-Gm-Message-State: AOJu0YwjP9H6R3k1qBlkZV6Kwxsr4WXYbG9vt9i8d032IKkmFfbVgXHv
	h+yT2yHb3lRFhAwFv7Bp3DkVWwEn8EesNI87EbE1+7ZLUXzmdyNTSK36jr7L3uA+OOPgtYhubtl
	oHkQ9p+8M+Wflfw==
X-Google-Smtp-Source: AGHT+IHvMIGMZ3oRYsIKBDomkCS6KVzlMOaVYE+CMhTF6/Om+i57uqifzVXn/OYDK9jNj1kCcP7uTWSdj5qqlA==
X-Received: from wmbg22.prod.google.com ([2002:a05:600c:a416:b0:477:14b8:19f6])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1549:b0:477:e66:4077 with SMTP id 5b1f17b1804b1-4773089bd5bmr143775885e9.29.1762254504672;
 Tue, 04 Nov 2025 03:08:24 -0800 (PST)
Date: Tue, 04 Nov 2025 11:08:23 +0000
In-Reply-To: <aQiJAfO8wiVPko_N@kernel.org>
Mime-Version: 1.0
References: <20250924151101.2225820-4-patrick.roy@campus.lmu.de>
 <20250924152214.7292-1-roypat@amazon.co.uk> <20250924152214.7292-2-roypat@amazon.co.uk>
 <DDWOP8GKHESP.2EOY2HGM9RXHU@google.com> <aQXVNuBwEIRBtOc0@kernel.org>
 <DDYZRG8A99D1.2MYZVGBKJNHJW@google.com> <aQiJAfO8wiVPko_N@kernel.org>
X-Mailer: aerc 0.21.0
Message-ID: <DDZV32U60137.1HE9JGMU6P1KD@google.com>
Subject: Re: [PATCH v7 05/12] KVM: guest_memfd: Add flag to remove from direct map
From: Brendan Jackman <jackmanb@google.com>
To: Mike Rapoport <rppt@kernel.org>, Brendan Jackman <jackmanb@google.com>
Cc: "Roy, Patrick" <roypat@amazon.co.uk>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"corbet@lwn.net" <corbet@lwn.net>, "maz@kernel.org" <maz@kernel.org>, 
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "joey.gouly@arm.com" <joey.gouly@arm.com>, 
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>, 
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will@kernel.org" <will@kernel.org>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org" <luto@kernel.org>, 
	"peterz@infradead.org" <peterz@infradead.org>, "willy@infradead.org" <willy@infradead.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@redhat.com" <david@redhat.com>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, "song@kernel.org" <song@kernel.org>, 
	"jolsa@kernel.org" <jolsa@kernel.org>, "ast@kernel.org" <ast@kernel.org>, 
	"daniel@iogearbox.net" <daniel@iogearbox.net>, "andrii@kernel.org" <andrii@kernel.org>, 
	"martin.lau@linux.dev" <martin.lau@linux.dev>, "eddyz87@gmail.com" <eddyz87@gmail.com>, 
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>, 
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kpsingh@kernel.org" <kpsingh@kernel.org>, 
	"sdf@fomichev.me" <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>, 
	"jannh@google.com" <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>, 
	"shuah@kernel.org" <shuah@kernel.org>, "seanjc@google.com" <seanjc@google.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "Cali, Marco" <xmarcalx@amazon.co.uk>, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "Thomson, Jack" <jackabt@amazon.co.uk>, 
	"derekmn@amazon.co.uk" <derekmn@amazon.co.uk>, "tabba@google.com" <tabba@google.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9B8CF180009
X-Stat-Signature: 7i83qei8hh4h5fb6fyja76updtn8ui3w
X-Rspam-User: 
X-HE-Tag: 1762254506-397101
X-HE-Meta: U2FsdGVkX1/ODuh5hiept47zS4XIl7E3oN9aSOHt2H4keIDJIXPd+jSqUYQI3uft4jS2Wz7/phxHihtd5FgSGkFNSt/IVAhnNeifjCUUPKPup1Su4p0MRCVTSDTamD0L7FWkxGxZPqeRLiOARtaCRi/KTY5MGshomuCFy5HQ6+DPq+n4O2FE8/nCRjfJzqKmhaQ20iw0I/SRt7TJa3UtTYZ8X1X2j2MDWNVrp6pqUZCs/irayTwlRA5ERWCIGaT8nbpREsUNXVueWYXgR/ZSoYR42jmNMkSlKKN+C1Q0H8J1wvM0kzgn8N4Hoi3EVnRJcfSXFS4CrmdBEKVFFm6M5k3dAMLw/n7l4WoNoywybd5FhGkH7e++zRi6B0xN8EEdx3adkemUx68NM6vOB76yAB43XoI1rlURTUb2FKeeCCYFwUD37VobKCBqUedvlD7GrWFjDwlbx5vd2FbyJ52JSMJYIWZ9hVexQ+HM71TflQLfTEsx7f28RKyIQtymtQJOqBh4UIErAeSgh9M1aoWTgNhUmvCzEBFyDPGmwxxDtm/mvIdV/5E2c1lnfsoJPcmQsiU8j9vS3su0USw7XrvYYGgCBpUNqCYCj7mubMi2nsnxwWyDdkCldmY2/f8I/4y8J6zQUPBhE4ktxrP6FjFDxFa7//DcKmVLYAHsT1iq3dWpCKIZw8L//GYOG3lbVxzNt0WsApjKwkO96X4IEe6dvpgh87Su+K8iMI23ljKYOYAnljtAlCrLpIQWpITwn6djczC24yZdUNd9+bg7XWQtR1+BqpzV5RBo2KjKZVF11svJJcenOSVVle8/AxmSmvyeHOLA4whR1qXY5G3jDCHPsConLyqDniI6rDur/mk4uA02NRdC0nN2DwzWpgq/MtVTvhNEL2Dr35PIP2VGW1n0NKMv/QfjX3p4vwF8ecNetk9WNbaeCDwPF6HMr+v05wtrkcRLUBkCJSGXARMQsGS
 F6RfOGYQ
 ZDQjQxvL+d7N1VShhMmSGW40pB6UwWxd8c251DGxTen4GhD3XAImXNx8wk8V3uT6B+lEg/sPe3UeKxfnpE+Fb/6eJOdFExRoZa768ujIuYFj0DIBmn+Z3r7EkylWDre/euIyHdU/OzKDmWgdT8XB19EVLLbfw0OayxcQEObeGcY1a257e8O0CF8sn2BJTMrlbHplKxLZg6gROoqQqW2FJPoaEUR+vvDsKc+b5+hcyGnHuTGXy0tL7h3Uqndrf5R0Bew/e4t/72POINMDWgrd+MLG2behDCH8hcAAlWuclhidZleSby4e+B3GjkUwGElBCk7Sq3mdl0dCecNOs0Q9A8Tl0QE1IalQGjGsG6w3IEi7zRUZRrG/Nw4kSRmG/Oti3qiNAH98ZPUVsxhAVg8M9PYd54447WxJlKAyQG8YCFb3U59aGK9tROzCcD8lb36JO/Up2l5cO7LHfUpxbpWaZRofpnke8n8rLSaNYwTn/8DnmN0PUqAGO9JOWFNNeNgmkLAs1Sv6I4KVB6Z22XRb5rVrtpEQ0GFizn/stFPGt71NmbjsfbuiPKylZLfk4wf7H6aD/IvM9BH4Y/bCHndphMWMJD+ZVXixqJxRICW+xSe2vm4q2Viax4SQ9TjcHJYJsfFWg9HTqCt0WXOnUybhk1IiBHv3T3e8KUSznatOtMqWzM4q48poYzjQcDa+dRXiOBlW0XOTweeHHxBSCy1vym3FuaBaG01hMSoRC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Nov 3, 2025 at 10:50 AM UTC, Mike Rapoport wrote:
> On Mon, Nov 03, 2025 at 10:35:38AM +0000, Brendan Jackman wrote:
>> On Sat Nov 1, 2025 at 9:39 AM UTC, Mike Rapoport wrote:
>> > On Fri, Oct 31, 2025 at 05:30:12PM +0000, Brendan Jackman wrote:
>> >> On Wed Sep 24, 2025 at 3:22 PM UTC, Patrick Roy wrote:
>> >> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> >> > index 1d0585616aa3..73a15cade54a 100644
>> >> > --- a/include/linux/kvm_host.h
>> >> > +++ b/include/linux/kvm_host.h
>> >> > @@ -731,6 +731,12 @@ static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
>> >> >  bool kvm_arch_supports_gmem_mmap(struct kvm *kvm);
>> >> >  #endif
>> >> >  
>> >> > +#ifdef CONFIG_KVM_GUEST_MEMFD
>> >> > +#ifndef kvm_arch_gmem_supports_no_direct_map
>> >> > +#define kvm_arch_gmem_supports_no_direct_map can_set_direct_map
>> >> > +#endif
>> >> > +#endif /* CONFIG_KVM_GUEST_MEMFD */
>> >> 
>> >> The test robot seems happy so I think I'm probably mistaken here, but
>> >> AFAICS can_set_direct_map only exists when ARCH_HAS_SET_DIRECT_MAP,
>> >> which powerpc doesn't set.
>> >
>> > We have stubs returning 0 for architectures that don't have
>> > ARCH_HAS_SET_DIRECT_MAP.
>> 
>> I can't see any such stub for can_set_direct_map() specifically?
>
> include/linux/set_memory.h:
>
> #ifndef CONFIG_ARCH_HAS_SET_DIRECT_MAP
> static inline int set_direct_map_invalid_noflush(struct page *page)
> {
> 	return 0;
> }
> static inline int set_direct_map_default_noflush(struct page *page)
> {
> 	return 0;
> }
>
> static inline int set_direct_map_valid_noflush(struct page *page,
> 					       unsigned nr, bool valid)
> {
> 	return 0;
> }
>
> static inline bool kernel_page_present(struct page *page)
> {
> 	return true;
> }
> #else /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
> /*
>  * Some architectures, e.g. ARM64 can disable direct map modifications at
>  * boot time. Let them overrive this query.
>  */
> #ifndef can_set_direct_map
> static inline bool can_set_direct_map(void)
> {
> 	return true;
> }
> #define can_set_direct_map can_set_direct_map

But this is for CONFIG_ARCH_HAS_DIRECT_MAP? I am reading this as a stub
to fill in for archs that have set_direct_map_*, but don't have runtime
disablement like arm64.

Whereas my concern is archs that don't have set_direct_map_* at all,
i.e. where we need to unconditionally fail
GUEST_MEMFG_FLAG_NO_DIRECT_MAP.

(Or would we prefer to just not define it at all on those archs? Not
sure what the norms are there, I guess that's a question for KVM/arch
maintainers).


