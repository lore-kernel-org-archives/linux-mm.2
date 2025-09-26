Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E974FCAC5B9
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 10:53:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EA348E0007; Fri, 26 Sep 2025 06:53:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29A6B8E0001; Fri, 26 Sep 2025 06:53:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 162388E0007; Fri, 26 Sep 2025 06:53:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 025278E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 06:53:28 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9556A16062A
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 10:53:28 +0000 (UTC)
X-FDA: 83931090096.01.29948F7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 10835180012
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 10:53:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uD1JE0tX;
	spf=pass (imf24.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758884007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rCfPCEzH7cCaK8RVMsErsR2iGgULDkGBQ/tpMFxAJv8=;
	b=iC76uBmY6KTv38TgtaZwKb96v2c7A3DZMmghZMzJkShpB2xjo87ghT9Nmjijvmm8hOUD8i
	PkPRFS96hE/JauPQ8uDpvsfT2zC769ACrFQk8yVzIwQSKMEQEmnYTJAQrACmkicvsaVlvz
	MWYz2zHtneXu2/dlNgScxqkrbKuGVFA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758884007; a=rsa-sha256;
	cv=none;
	b=DhQXmIGs3S5HU1pG2/hm5lGJ1uX0+w/i7dqlWzplzKUCttXywV7jCv007Zhc+K8jAr7uKH
	a7RHue4YWyiBEuZcIzyqa/X2mcQm6nV7TtyirJm5QK0L/R7rgeCSZS6XgLi50u+ziH8cg0
	sDz0vMv0m+802QHJEdKEU66OMjc6ukc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uD1JE0tX;
	spf=pass (imf24.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 024C461D1A;
	Fri, 26 Sep 2025 10:53:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70D44C4CEF4;
	Fri, 26 Sep 2025 10:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758884005;
	bh=7hmmYSJPRgv/HC65SCjVCWih93S3343uLCIvyfBCuoY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uD1JE0tXSNlpM8sPhyTXW479bU0LI8INqzK4TERYGl4X7uWhmA9lmVftkg1kWXZ5R
	 77GIltP55fsK1VaNF04SNJorVj4he00rts0ps3WabgzU+pkpIwJ4s8I+R0hmUJnUtU
	 RiaA5H5VESS2asBJWt7pSZgGaIv0Nm+KYRCGG+rPlSqbN+Dbh5Z/Txoz0wlINXpYEV
	 XpuzK1hMtXmi8NPXs68yGAwo2DcoOz/MQPBrQn8al4WKuMkf07ZITw6sd0eQuO6+Q/
	 NxEbMuIeeoejXQN3nR+oF+rAs5zBbLTi3No4iK9EUmEyBi7Uiryz2YSyhJ74rbGMLA
	 g299/90nvCdmA==
Date: Fri, 26 Sep 2025 11:53:12 +0100
From: Will Deacon <will@kernel.org>
To: Patrick Roy <patrick.roy@linux.dev>
Cc: David Hildenbrand <david@redhat.com>,
	Dave Hansen <dave.hansen@intel.com>,
	"Roy, Patrick" <roypat@amazon.co.uk>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"corbet@lwn.net" <corbet@lwn.net>,
	"maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"luto@kernel.org" <luto@kernel.org>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"willy@infradead.org" <willy@infradead.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>,
	"rppt@kernel.org" <rppt@kernel.org>,
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
Subject: Re: [PATCH v7 06/12] KVM: guest_memfd: add module param for
 disabling TLB flushing
Message-ID: <aNZwmPFAxm_HRYpC@willie-the-truck>
References: <20250924151101.2225820-4-patrick.roy@campus.lmu.de>
 <20250924152214.7292-1-roypat@amazon.co.uk>
 <20250924152214.7292-3-roypat@amazon.co.uk>
 <e25867b6-ffc0-4c7c-9635-9b3f47b186ca@intel.com>
 <c1875a54-0c87-450f-9370-29e7ec4fea3d@redhat.com>
 <82bff1c4-987f-46cb-833c-bd99eaa46e7a@intel.com>
 <c79173d8-6f18-40fa-9621-e691990501e4@redhat.com>
 <c88514c3-e15f-4853-8acf-15e7b4b979f4@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c88514c3-e15f-4853-8acf-15e7b4b979f4@linux.dev>
X-Rspamd-Queue-Id: 10835180012
X-Stat-Signature: pp1ahyt6mdtrekdtgjp1et4zdzoprizb
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758884006-758585
X-HE-Meta: U2FsdGVkX19McnlSZD4YG1v00X4oRtPJKlM9WRyFelnxSlaDkF+1RJAISClbkpIxSzxdj6poWlz9YaHAtjOCUAIIGpmAD5F+9Qkf0GXS8/MqgsR87yoFYj8sQHYg37GDL8fZU4cgaWAlmOqXc9pzoVlUjQVuYOgzyiEsXtZMnJujuqpkmb3Qt59TXj84E2Yp02lCTZ6jTZ0Qx3SUx6did12X+ul0E+QqsUe9UNOxllLXuRTdNcJdfNEzckp6JkucP4L/NEb8RZibNMyoin2c7MdsKUctdZ1l42UImRxgrxwucnYoTznQt3Qksj+0OQfF7DW1vZhKSbJWajldrfJxjjWvSCfQ0dgMWnbnLccQCYrF6CYuwXSEt0jmO9S3luLJoMyI5jXaU1q/7LzmnMsQ9wj9SFndATAocWq0LerOjZI/6LcKtvdo3I7Aq1SuMVDt2Ln6Ez+237OVtSFgiSTpevXbIT3XCH54i6Ew3zbIMSd4puupsn+qLKiSgyBbV1Gu20M2Uzz2TgguH8e0Eq91LmTG6oBARIjfPkeDnhREYA6W1BcRqlghE6NnziudikdGh0PcdnDanaa6b7DoneeUmt6D4TkM/1Uz3TfR22OB3eUKAnVkT71icFVEj3azz0xob0a5iLKLuWzsInubGjKAA6lzMW38gwCpl46YmLfUAZ4Q3vuAS4qsDAdYS6GSNTXdHhU8bXsOl6BOuNV9B9j3skoZzdvmjHbyJ/FYa46mpCoYwY8DvsQrST+PMPPDhTFgz4ZkDnd800342Alz/cczJXiQ/4SjP+86SK3OlhT1JSWBbbGBU8Inz3DfeNgllLyK294UDFLEnm5Xgt/yAiEyncYyGc2DuhZkYSbTPkRT4VEcRcjHxr6/bHyjD6DRo2cuN8+PAmsFcoTjkcuADVocwWJbHIqpCjD4Y5pstCSt3LjwVNHYyZ5yYZ42Pl3YYsrTnOJr4ot789ryscTWOmS
 sMmsAGkp
 KPuYKY/M08BaiBtZtwMYF1P50t1mWjn7NARWfLsan5xnhDScjqPMIrn0UBzj1gn51uDXKvNM0DCoerSZImLk6ZmCnaaJSEneFa1ty8ll8urpH5TqP+xClNOCiRHhbJivS8lhvfQhnzkurVqP2jq1XC4m0cjetJKTyAbpPhMO+Ub1JURKPuRI6Kq3DKghEoPlFl/B4MM1H8G7vDe+WwNwDBOLwaiFffXeydfhnqWrqtWsYL8a0k7ciftiFPiZRCuWJLmkDK0zvN7xqcPboQQjK8THYtoLyCLeNtmeKFbA5LgR4wd0GWamTE8544jmQJjkQ6wlcwtJZnT1/LP/WehSKCfxUQ7bBg9mzHlJbBZ65Aj0R4eAOiYOVXDXZgpNAb08f2P8caaSPYJGygpL+lJCxhbkMIn2y+Ceifwzr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 26, 2025 at 10:46:15AM +0100, Patrick Roy wrote:
> 
> 
> On Thu, 2025-09-25 at 21:13 +0100, David Hildenbrand wrote:
> > On 25.09.25 21:59, Dave Hansen wrote:
> >> On 9/25/25 12:20, David Hildenbrand wrote:
> >>> On 25.09.25 20:27, Dave Hansen wrote:
> >>>> On 9/24/25 08:22, Roy, Patrick wrote:
> >>>>> Add an option to not perform TLB flushes after direct map manipulations.
> >>>>
> >>>> I'd really prefer this be left out for now. It's a massive can of worms.
> >>>> Let's agree on something that works and has well-defined behavior before
> >>>> we go breaking it on purpose.
> >>>
> >>> May I ask what the big concern here is?
> >>
> >> It's not a _big_ concern. 
> > 
> > Oh, I read "can of worms" and thought there is something seriously problematic :)
> > 
> >> I just think we want to start on something
> >> like this as simple, secure, and deterministic as possible.
> > 
> > Yes, I agree. And it should be the default. Less secure would have to be opt-in and documented thoroughly.
> 
> Yes, I am definitely happy to have the 100% secure behavior be the
> default, and the skipping of TLB flushes be an opt-in, with thorough
> documentation!
> 
> But I would like to include the "skip tlb flushes" option as part of
> this patch series straight away, because as I was alluding to in the
> commit message, with TLB flushes this is not usable for Firecracker for
> performance reasons :(

I really don't want that option for arm64. If we're going to bother
unmapping from the linear map, we should invalidate the TLB.

Will

