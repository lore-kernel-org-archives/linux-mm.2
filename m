Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E989BCAC5AE
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 09:46:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E1748E0007; Fri, 26 Sep 2025 05:46:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B8C48E0001; Fri, 26 Sep 2025 05:46:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CEF48E0007; Fri, 26 Sep 2025 05:46:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2A4A08E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 05:46:26 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C6C90C0610
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 09:46:25 +0000 (UTC)
X-FDA: 83930921130.08.E8A4005
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf11.hostedemail.com (Postfix) with ESMTP id BD2E240002
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 09:46:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YNZESI5h;
	spf=pass (imf11.hostedemail.com: domain of patrick.roy@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=patrick.roy@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758879984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wL/DKY7lmmAFsSL3d0RvnMPd7olra+yxGHLjKGhoofY=;
	b=VWK7v3roaTDyOlr6GpzmTy7T/IZjP/7idckE8rpJh138IA+eRLvGWAjh0llMDINUL26q40
	CL5/vGQGSTUxxMOTUD1QnHrl6otrwLP751czuHvbus0IMCoFes9je4k0Zi4j9NRWvX2t/v
	ad3q3/BbNOGWkWQJIpN5ywJcDk/qUGw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YNZESI5h;
	spf=pass (imf11.hostedemail.com: domain of patrick.roy@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=patrick.roy@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758879984; a=rsa-sha256;
	cv=none;
	b=1ubsHAjy41w6uIO3Gge5WO/JesMhaOMtScjkdDB/6ogapvkdDZIMxFnpSgnxZVRjFlKF+v
	MiJDMZbIZfTKeSTTC+zWm1aSrIdb4o/ja1PiiCbCCnxeEVeLFyFQZaRyGWneRLCzTDNeo1
	ehZUEPb6foyPr1FmO+okS2/SBQyva2k=
Message-ID: <c88514c3-e15f-4853-8acf-15e7b4b979f4@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758879980;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wL/DKY7lmmAFsSL3d0RvnMPd7olra+yxGHLjKGhoofY=;
	b=YNZESI5h/jXNDiLLb7j86+j+TkXx1nKw543VaKtpr8w5CCCBn8PBOYUz9LE0gA3VqxAeTq
	vk8gHrlHjKvE2h5y4LlVK9XHV23gdoSJUvecSr6p74DcXM6u9ckDN633ckuAjfmHnKaOOB
	P/laAqnp0QFmiI8hpwCxa0nGYMdpMzQ=
Date: Fri, 26 Sep 2025 10:46:15 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v7 06/12] KVM: guest_memfd: add module param for disabling
 TLB flushing
To: David Hildenbrand <david@redhat.com>, Dave Hansen
 <dave.hansen@intel.com>, "Roy, Patrick" <roypat@amazon.co.uk>
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
 <e25867b6-ffc0-4c7c-9635-9b3f47b186ca@intel.com>
 <c1875a54-0c87-450f-9370-29e7ec4fea3d@redhat.com>
 <82bff1c4-987f-46cb-833c-bd99eaa46e7a@intel.com>
 <c79173d8-6f18-40fa-9621-e691990501e4@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Patrick Roy <patrick.roy@linux.dev>
Content-Language: en-US
In-Reply-To: <c79173d8-6f18-40fa-9621-e691990501e4@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BD2E240002
X-Stat-Signature: oc3b1g7jwnn1c191ifrpfh15t1z4bgf9
X-HE-Tag: 1758879983-110893
X-HE-Meta: U2FsdGVkX1+X+fyFzbaBlINxOle78q6/XIfh7jg036w3D99ZjuOmR1NeZDq0rOMFGc7FgrLax3ZKEzBZLeb/a3qvnoDb/WqQra8EVQh22zv9PZqn5QJeDsvuv7pC1pDpK9qqx1vt9eV58tpfysjWOSij+wdAdNHF38GHGxENkcvXYbz2tHSxlCo95ffG5GtwrXnQR9jxA6UIHCU2Xo5Rqmbwku/JCO0o/6qtNWAJnffxSQoTIqCJZXh+epu89YzPagE02cXhgcYqFWCnbuNmsetFvaKVrVXYauIkxJf1CkMv7GS+olLtfDCRZpL3yAdiGHtFsq4cCIiDn9KUf3IjXy2MIIq5JnoOVvhBDJHvb/B4ekpkrBXznfFtATmbrw+sn86B3TPLQv75/fa/TCfXkj5k4aK311MPQqcZO7+o3gIysbbe5fWpZbzNM46URyUg2qWP5jTUGZLImgV4wl577pNp98DI6usFHlGwyiCSsleh1ZDtXUtGkLuJU1CCVLd8QpsVpoLvUi9CWJVKIDb2XSUY45DSJGcKPKd4mClMMzGF1GP3bjJgwax2YKDjr2Dy+rL0SFQrMdQTy8JWoon74Z7V3Z9/GnyXCBF13YsQ+TnGyAHPdl15Xx5ubMmptADe5cQdxZ2f04Pana49dbzazz2Dtl9rIvkVRvzgfOovspy54EjY9qX25p6bVamLgX9aJ/Xd5C9WcyIf/h3WcsdT9NS1a3YTxdzTXL1Hl2NKJvZdV0ZfROoa4SA0meEpjfxZLEDggGwC1UXUWtHE9mQG/akyVHP1HY2U79YVD9aH736DDMhUszYSMzhQX1i40xMvAUdQZvVXBN5xyBP8x0RKh0969mncIVl/ft8nJdd0eFLqO/ErgIt4KGhRf++CZ7iBgrPi9a4iRijfoAOKnNpfluuRkVfKlN/jmjnRFkuKN5HbA3RjBSdio7BEs0/OnEzukI0lYZpsgKFvN2xlrjb
 uFaL5N2V
 WEbukszub2OJ+c0MVeZoM4zACLEqHIWSHZg3Q2RrzQcjleD478Z7t6LRpNVh3Kb5mTahzj27VqJe634Ib2V4/qS2qigvi03MOTDxNfMnqAdUdHZ6MD94MT2MzmaigtEpWqFvcs4r/Cta+l2ljBWvQt8Jf5KXF4/Q1suMBOexAs0qUtpL97uxzM6wWItZOD884Au2ktVZzje2GQpanPRovvwB4gM2v7pZGa9g3ZoYs8nHhX7yIf95YfGdkTLcqc+Omn4XV4xj8097ttu7wkTyLyqhaaMUh1NaKkGdsh2Y8LyOpQCjypuBlJbSWhq1qM8UPMq94lP0YvqpgaLaa+KSeR3jwWmSRsbkZ6BZPo9Oi74I0N5VgW7XrLY7MxQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Thu, 2025-09-25 at 21:13 +0100, David Hildenbrand wrote:
> On 25.09.25 21:59, Dave Hansen wrote:
>> On 9/25/25 12:20, David Hildenbrand wrote:
>>> On 25.09.25 20:27, Dave Hansen wrote:
>>>> On 9/24/25 08:22, Roy, Patrick wrote:
>>>>> Add an option to not perform TLB flushes after direct map manipulations.
>>>>
>>>> I'd really prefer this be left out for now. It's a massive can of worms.
>>>> Let's agree on something that works and has well-defined behavior before
>>>> we go breaking it on purpose.
>>>
>>> May I ask what the big concern here is?
>>
>> It's not a _big_ concern. 
> 
> Oh, I read "can of worms" and thought there is something seriously problematic :)
> 
>> I just think we want to start on something
>> like this as simple, secure, and deterministic as possible.
> 
> Yes, I agree. And it should be the default. Less secure would have to be opt-in and documented thoroughly.

Yes, I am definitely happy to have the 100% secure behavior be the
default, and the skipping of TLB flushes be an opt-in, with thorough
documentation!

But I would like to include the "skip tlb flushes" option as part of
this patch series straight away, because as I was alluding to in the
commit message, with TLB flushes this is not usable for Firecracker for
performance reasons :(

>>
>> Let's say that with all the unmaps that load_unaligned_zeropad() faults
>> start to bite us. It'll take longer to find them if the TLB isn't flushed.
>>
>> Basically, it'll make the bad things happen sooner rather than later.
> 
> Agreed.
> 

Best,
Patrick

