Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3C5ACCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 12:35:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E4EF8E000D; Mon, 10 Nov 2025 07:35:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BCDA8E0002; Mon, 10 Nov 2025 07:35:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D3178E000D; Mon, 10 Nov 2025 07:35:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 094BC8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 07:35:11 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A2DA7BE0BA
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 12:35:10 +0000 (UTC)
X-FDA: 84094642380.11.1816096
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id DFA58180009
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 12:35:08 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bjyLkioR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762778109; a=rsa-sha256;
	cv=none;
	b=OMcLw3oImKrdwVHGlWNUOIc0ZMUJhVrQZIABL/AhaT1XIhXex0FRFb9BmVf+JQgkrKwhoz
	DMq+h/Kpaz+j6KTXh0TyN8eNmaYBg22bzHvMYGwUvnLwtKRkgUbf9KUVQpthBPuJqsplJp
	sxs86wFusIz39abS/vCNnkS78QjedS4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bjyLkioR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762778109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7ftAhIGd1qK7oc62q4gKkS8hG81IpIum4M8oWVVKkQ8=;
	b=rBP421+rTEhF+H7wb7Eevz3led2IsNh52wlIT72ZVngpxm3A6lgJeFSauSpyZLCiEBWWX2
	ytDHNMIcgiFgV46ODdeIgIpsk/9hln/XMHMoCkr15N2Seu/4qYQ6WHGUqvPQDdJw2g2dJ8
	IX6RgJ30b7Blv6Oj0WJCZfeD8jRJ/r4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BBF8140240;
	Mon, 10 Nov 2025 12:35:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4C89C19425;
	Mon, 10 Nov 2025 12:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762778107;
	bh=Aqloc7BOWQNjYEGGJL4VNHIwvX0puHEXVUArW0wY5yM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bjyLkioRQTNOQX7WV1Bvgk28/2Npo87/4O/DYvYxhvdIkzERkIF4YWgs3zpThh4Nb
	 nk4DxXanbkMIWVH7rVuKqkYHYeYKOOPFEthmKGnYEIAObYRKAndU3l8nRk9CvViRux
	 65l/SP8udZTmUVNRLT5uXlJoPFSAOuwJ8MFyqobPnPc/FGkeiRAg+O5ICkw1tnUxZ9
	 nw59ACFdY/BU2F4GziHlZTo7UgjLJ3h/vdd4gyK6wH9qrNK6e1DhackPpUZT9njHNg
	 FBi/N8QIzRNuYSKNnCDyU3rxchuLO1kRHhf4q/nx8ccSCm7L7vHbfETFkVt/ILm193
	 OzCXZMlkxupeQ==
Date: Mon, 10 Nov 2025 14:34:44 +0200
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
Message-ID: <aRHb5FJ2TUMtktVz@kernel.org>
References: <20250924151101.2225820-4-patrick.roy@campus.lmu.de>
 <20250924152214.7292-1-roypat@amazon.co.uk>
 <20250924152214.7292-2-roypat@amazon.co.uk>
 <DDWOP8GKHESP.2EOY2HGM9RXHU@google.com>
 <aQXVNuBwEIRBtOc0@kernel.org>
 <DDYZRG8A99D1.2MYZVGBKJNHJW@google.com>
 <aQiJAfO8wiVPko_N@kernel.org>
 <DDZV32U60137.1HE9JGMU6P1KD@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DDZV32U60137.1HE9JGMU6P1KD@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DFA58180009
X-Stat-Signature: 8eswbfwp9w6nwkcaztw99f54zu957frn
X-HE-Tag: 1762778108-437857
X-HE-Meta: U2FsdGVkX18UlyYBjzlV+y1EJDd6bIVONG4Zoi1e63X4y0FVhs8EIAYrxIeDRdo4SSQzAef6zFDHIEREVOwRP2kCJKsWJyWAT0Vl6M7OnVzy18AjbwRvmjwIq4vGGCE9KSUAxkUufSpdYBQcKiM4+j45w9AMopg99hqDr7dDgsMN5J+JieZ+5bbrQfaabrtYdfqZPzMjjcP4R3AOercMmKBefmvLkIYKuBBkiv9MerDMXUe2aCkqR1HZNMHmWCtfscyQ59kGxHmKzlJt5yuwVE4s4QJlpzRpWYXeaUu0tqmkTMZwcBohukmBUSjzmEfR4BJlB1XKsB/F434z6MBTAkZ6ZUzpPw1UpdqSWbGNrDnk7Ztc36H2A5bWgmqB9n1LtYVefh7XUtvY1+F75MWjj1CSm48dmM4hSB+YKuMENfP0CnZH7d2wVR0/5GbxyDUu+kgIr8+aXv7VakKfpOFdI2tCQw55/M5bh232XkUmGS5MBt0mE4BhV4zWvqeguJcpeIHI3fetlaf2FyEbnH7k1FkbgK/A381wgsH/Wi3Ye3zpTk72OV308I0jJQYuydcNO6uX9fLKe8lZraGLGXd+YGpznmXCUJmfWGsOIeNOJMN57fFC5DhEwxeufeY96Ay2AI7QRtuQYrTwBcj2VT8fJtASAlQeEeJ+l50IaXMhMH9TsbdiOggSQjEo1ZdHSmkZKACFCUUbperDa7FimUwRDJyM9Lfl1MDWF3o9s4xUx0hXeGU2Hqa8DyLrRH8iWhJNrCy0S9fYhUrUnBn9wepysTl/weQxPUSnjl9D+2I9uVJVsgaoLLoQQoLgrErH65cmNEHY2OpPrU3IGxaxBvngoxLpTGQlD006v3qHjcumzhf3EXgDQxkmq6GEEYn/HAA4XRuUzJyxtTfgyikSh1C6H0cAzfP9M0hpdIDxtAvJM0bTEu6VWlJBSCj6PRfxD45ZcfGiiWZqBlM/WYJh+9G
 qFZhKUBO
 Dw6fSi7yqQ8hUNQteasxQLCZdSuFZP4/orY814Pd3/oZpmAmSMWq083qXFZlzMGBhF3b8n6+gP/UVBGe5tfb7SyufFc7h7zxUNuPj3LkqyR6uubnbE/Y7J8Dfe/1F2nz3JUt4DDvKY5eoVi/24S9Oy6Xgigzrl8lwiaDyF7SYyLpnQAM/pc1XQB+vPSRRPSe92ynd5RkKCRNsQ5t7AY08Vmht81oJPZchQL2GEIHfmDdBHe7qQ6mTLGk3Tkn8rocjlJCxeZHfCb7hSIP8vFNAWL2SRlhOv0Lo7yB3NmewwArCe0y9sQAYvEtH2w/WBQ8EdqcRSgE+OMdwa4vdXS9eEr4pKQ9oeQj63cKAFahCNgBh5ChsFElsAMS2nxfCkJm3GwxqEaP7jTrb7MF7KxyZDRrsMKhc5tD1BSzA9+Wc2V3zVjMyXwjEimBYJc9PbhTiagBT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 04, 2025 at 11:08:23AM +0000, Brendan Jackman wrote:
> On Mon Nov 3, 2025 at 10:50 AM UTC, Mike Rapoport wrote:
> >
> >> >> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> >> >> > index 1d0585616aa3..73a15cade54a 100644
> >> >> > --- a/include/linux/kvm_host.h
> >> >> > +++ b/include/linux/kvm_host.h
> >> >> > @@ -731,6 +731,12 @@ static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
> >> >> >  bool kvm_arch_supports_gmem_mmap(struct kvm *kvm);
> >> >> >  #endif
> >> >> >  
> >> >> > +#ifdef CONFIG_KVM_GUEST_MEMFD
> >> >> > +#ifndef kvm_arch_gmem_supports_no_direct_map
> >> >> > +#define kvm_arch_gmem_supports_no_direct_map can_set_direct_map
> >> >> > +#endif
> >> >> > +#endif /* CONFIG_KVM_GUEST_MEMFD */
> >> >> 
> 
> But this is for CONFIG_ARCH_HAS_DIRECT_MAP? I am reading this as a stub
> to fill in for archs that have set_direct_map_*, but don't have runtime
> disablement like arm64.

You are right.
 
> Whereas my concern is archs that don't have set_direct_map_* at all,
> i.e. where we need to unconditionally fail
> GUEST_MEMFG_FLAG_NO_DIRECT_MAP.
> 
> (Or would we prefer to just not define it at all on those archs? Not
> sure what the norms are there, I guess that's a question for KVM/arch
> maintainers).

It makes sense to define can_set_direct_map to false for arches that don't
support set_direct_map. 

-- 
Sincerely yours,
Mike.

