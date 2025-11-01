Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D21A9CCF9F0
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 09:39:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA2B88E008C; Sat,  1 Nov 2025 05:39:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7A058E0068; Sat,  1 Nov 2025 05:39:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A90538E008C; Sat,  1 Nov 2025 05:39:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 972EB8E0068
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 05:39:27 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4A95614060B
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 09:39:27 +0000 (UTC)
X-FDA: 84061540374.04.69F0CFD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id B9B4C160002
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 09:39:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cJ+WYDY+;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761989965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=18YqzTaug0HvHeFTH55PBus/Mv6JA/utQNUcP9Ea2qk=;
	b=bkwNuBvAJmKff2r+tI8zzIvOUTKOn4aM9I99aQc0svQ+vbnOCins171upz/Q5qkykj7fzT
	pti0/kyKCUdTOD1iUsmkXY9KnICG5Aj0VSmbFfsNdknF7z3BlbAyE0uN+ajr1R3v//P3Sf
	ILK2qjBwIb58yvHK7a8JOfXgmdmQor8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cJ+WYDY+;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761989965; a=rsa-sha256;
	cv=none;
	b=Req/SdgMIR23rlqqdPpV1GzGUuldmqmWGb1kjLs/w/WhKqBnLHaVHlvl6urNVHo8WgmyfP
	3UR2EfWUXkpGv3dZETJf0M28TIDbk9sqUGXOowpxo7x0fs5OapUMDkoh4nvqp6z8nwaSWO
	tNNmN5OrdgHcWicIXLZGSLvLuGIsySs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F3329601B8;
	Sat,  1 Nov 2025 09:39:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5088C4CEF1;
	Sat,  1 Nov 2025 09:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761989964;
	bh=jKoa9V9XhQiv7BaQFL5zndUrFnF2g5McGSxuYRyVXf8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cJ+WYDY+iJ5sz8QoBX/tgU9hS9MUKyxppf6Z2c2jctyOP9E8oK4uNRpvXJ0N7Vtn8
	 +1BC2YnPbSVKmc/bH7MUpPoZNwya+izl1xNabQT+1XlwS1BQ4mOQge1ALFNjsbnpmH
	 8dbbR8VGuC2diAqgEA5+pZ7+auNqQQcyoqaky5EjcHqjT6Zh6x5c48FIa6MZAHcUO2
	 apa+2zlnhJh/yi7yQPnsElQoV2X21wJKxz+CMPsU3MT27ZRV+jsk8w9hUJaFL+SyDM
	 lvJSrGW+4VcIuBmjfZP5z9FNQIsXfcO66WMXFChCMGvguxkPx5evJAwXAwFgmlWDUz
	 rGvhbOdFX0KoA==
Date: Sat, 1 Nov 2025 11:39:02 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: "Roy, Patrick" <roypat@amazon.co.uk>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"corbet@lwn.net" <corbet@lwn.net>,
	"maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"luto@kernel.org" <luto@kernel.org>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"willy@infradead.org" <willy@infradead.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"david@redhat.com" <david@redhat.com>,
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>,
	"surenb@google.com" <surenb@google.com>,
	"mhocko@suse.com" <mhocko@suse.com>,
	"song@kernel.org" <song@kernel.org>,
	"jolsa@kernel.org" <jolsa@kernel.org>,
	"ast@kernel.org" <ast@kernel.org>,
	"daniel@iogearbox.net" <daniel@iogearbox.net>,
	"andrii@kernel.org" <andrii@kernel.org>,
	"martin.lau@linux.dev" <martin.lau@linux.dev>,
	"eddyz87@gmail.com" <eddyz87@gmail.com>,
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>,
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>,
	"kpsingh@kernel.org" <kpsingh@kernel.org>,
	"sdf@fomichev.me" <sdf@fomichev.me>,
	"haoluo@google.com" <haoluo@google.com>,
	"jgg@ziepe.ca" <jgg@ziepe.ca>,
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>,
	"peterx@redhat.com" <peterx@redhat.com>,
	"jannh@google.com" <jannh@google.com>,
	"pfalcato@suse.de" <pfalcato@suse.de>,
	"shuah@kernel.org" <shuah@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
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
Subject: Re: [PATCH v7 05/12] KVM: guest_memfd: Add flag to remove from
 direct map
Message-ID: <aQXVNuBwEIRBtOc0@kernel.org>
References: <20250924151101.2225820-4-patrick.roy@campus.lmu.de>
 <20250924152214.7292-1-roypat@amazon.co.uk>
 <20250924152214.7292-2-roypat@amazon.co.uk>
 <DDWOP8GKHESP.2EOY2HGM9RXHU@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DDWOP8GKHESP.2EOY2HGM9RXHU@google.com>
X-Stat-Signature: dufp4twqwboi5fjxf5fjkr37zepwy8pj
X-Rspamd-Queue-Id: B9B4C160002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761989965-774334
X-HE-Meta: U2FsdGVkX1+YIBYJKOVfKpfeeaPrMm9qZVNUKmQLzukUPAPw/Fa5B0G5FsM5959FZBhSnEpTO7/IYXqouOkAVKAUDKN2avbzL/FmBKjVHCQ7c8Hx/G70bkB5k+NwfgXZ65NqOtK+ruOKcPBAk0XcfkRUbQiuendAJMExtN9j8cSfHT2IMShUICep5fWE9LeGUb2hB4kGA9gzHHgcSgLMBGReZYkOWWjUBvpnNAw70sKyUgfoXPQWl9hLVhM9lFi0rg08Q1wQHgekJ1A/IN15KFTFMJ4+QkBdBIBAjUmmTvYQbLwuTgbEehTy4DQvGqwYCpMcnWGGuBG3orFnvAGoL5EX9h+tWFfqtr6IS0JPV5goPb7sO08Suu/+F5RdhYGv00yRvDpqOmFFywHyhcuf6oz9dwNhzLx2CTdc2Dl1loShs+vrqCSHqRoSuOrhttcC7/KVz0MNlesUMVK9aeHQ3VU5Crbq5KBxYTkORganPtoGrva19x99hEJ01QR8NHLuf6SoHwzz1iKJsx/BygD2iuPtT9x0qBWIUoHBaGciX9k0TgoQNfjHUSQtozFlHKJ2yiIsDV4xNN7OvTZjae54oI/iSb49RooMfzqqhrNLzhSYV31i9lRp8FzrdwT8BomPtDh3LoeWChzKTkGZHtF9WQVY2of7kYeex3EFHM8WxmsqqyTJFEcONQc8LLrOdp1wZ/qVqzKC0AzrT10Gt94nuLMSJHaWBebDAG8z6ZtFQv/ZaoNC7WvBKb23NpD37qgIruqGO7WATH4vu6286waUeuzLM9qyWbrdrykkFqOnDnGpkUO0UO712d0W3OiT5mmlZSUp1KeYZQdZFQ/hXDp8f1yZWgLOSVLDjxcJt30C/dFqDZJVCU5HVf12TqJjYIl65XJ4iJ4Dct/hTeWDQQpJiFmuPMPBdBp/ADiGIGsfeC1oaDWUPnbVNVIKB/Ylg925Ghq5Z+AKANTuF3T46PN
 960w+N0F
 F2308Hafm0fwzQSjM+p5I5r4dZQ5d5dpdICHUT7WFA+TpiXfTlCMGO58aED5+YMP8veh33mCl7ZYb323G9MqVC+yIye02s+90+Qsm6C+/kD7RnmWkYfAiCd9Uoyb/raakcah3pugfv69Al6U6iit7je/vK9slLDydoMj9K++VaV3n9jI5fnpR+cWrJmlvPdaOA2OtkEu7InoHbQ6wAtN56+Y/PgyzB/2Mv/XloK9xzMXqdWPG+aMCadH7Wa607AqYlK3QVK5uwIOYZZxhmXNc3PDPKORIVDf4P9gyJt9LZLRxGf2b6GBOoQCpzZbjPOczV9++Tk2xBIydeZ9NQiLijD1ZhixpSWddBbGDuo5lm8qj2nM+zJ3YWM0tMeerGbJ85NEnI2OB1k5ngSxP/63s0uvGq2lXQglLZeXs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 31, 2025 at 05:30:12PM +0000, Brendan Jackman wrote:
> On Wed Sep 24, 2025 at 3:22 PM UTC, Patrick Roy wrote:
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 1d0585616aa3..73a15cade54a 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -731,6 +731,12 @@ static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
> >  bool kvm_arch_supports_gmem_mmap(struct kvm *kvm);
> >  #endif
> >  
> > +#ifdef CONFIG_KVM_GUEST_MEMFD
> > +#ifndef kvm_arch_gmem_supports_no_direct_map
> > +#define kvm_arch_gmem_supports_no_direct_map can_set_direct_map
> > +#endif
> > +#endif /* CONFIG_KVM_GUEST_MEMFD */
> 
> The test robot seems happy so I think I'm probably mistaken here, but
> AFAICS can_set_direct_map only exists when ARCH_HAS_SET_DIRECT_MAP,
> which powerpc doesn't set.

We have stubs returning 0 for architectures that don't have
ARCH_HAS_SET_DIRECT_MAP.
 
> If this is indeed an issue I think it can be fixed by just defining
> can_set_direct_map() to false when !ARCH_HAS_SET_DIRECT_MAP.

-- 
Sincerely yours,
Mike.

