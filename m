Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFC30E83071
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 10:15:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 191E06B0005; Tue,  3 Feb 2026 05:15:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 146356B0088; Tue,  3 Feb 2026 05:15:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04BB66B008C; Tue,  3 Feb 2026 05:15:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E8E3A6B0005
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 05:15:31 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 34DEE1B1C53
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 10:15:31 +0000 (UTC)
X-FDA: 84402738462.08.950162B
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf05.hostedemail.com (Postfix) with ESMTP id B6FA7100009
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 10:15:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WecfiqfN;
	spf=pass (imf05.hostedemail.com: domain of yilun.xu@linux.intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=yilun.xu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770113729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qo0LlT3R6FZA/L6tL7OikHZG2iaBEOMkaq9rfc+AsKE=;
	b=vklw8zKDbnmqV7DpzjvTjsKkYGEvYKORU2ta7kC1uj1jYT09W2SoBqQwZPjPlTX/bzkiRK
	WWfhurfy6DSCQAst6wtNIh1oXC504rVb1eDbHHp8rncELufD7ipSoI/MPqRQV/Hkkieqmh
	JPsq50IPZ/Nw2hc8Ow2H93n4yUwPh3o=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WecfiqfN;
	spf=pass (imf05.hostedemail.com: domain of yilun.xu@linux.intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=yilun.xu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770113729; a=rsa-sha256;
	cv=none;
	b=X5csRkAAC/ONgaaALyF9SZ5n3xFMDmxPM7YWZeuzdyF9NK0kGyOUVRWXp2MDXCmAf5uYM6
	HIzlwp1Wm4YueclxGwfzy4LA6cWwAn/43zwmDJFWMfWEktRDg/vrZKktTAcfQGu267cjaq
	u/Tv9pm4hVafPVDeG3mqkYoZuEQyxNg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770113729; x=1801649729;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ltTqItvs5DEbQAayR00+PqL/+NRtgJq6ixieEinQSY4=;
  b=WecfiqfN3+4HFolw1eDY6s8izhfOKd5mIlACq4SNyLDdV7LZdJGup/dh
   dF4RTtswcYMDTBlXyKBJNlxWJKjLHBK1Jijr1pS4tXJ+B2m3HnH5pqXCD
   3KSKwZyfPgHYxd+BuzRQsrGHC7969OAFfinYkL6jAkAFhxdCDbu9skHRK
   glr5iLRGVf6YyeJaav+Ow6h3rPGosVKqBaBd6ARl6v8gYA0EUDNDa+NZR
   RP8rGyw+YQ4SDzY2XB9TZlIJUJAmRpOv+4d5HibA6P7RtbffylkKdyggK
   E22AVdJ3ySq+v6b4ojEYV1aUl87JkcAQj5kODenzgBIHHGEp8jV4AROFg
   Q==;
X-CSE-ConnectionGUID: yRUH+GSTSEqb5phzuWvVIA==
X-CSE-MsgGUID: lFf70l+hTQecmpxkVSTfQQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11690"; a="96738262"
X-IronPort-AV: E=Sophos;i="6.21,270,1763452800"; 
   d="scan'208";a="96738262"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 02:15:27 -0800
X-CSE-ConnectionGUID: QSwRDmD1RvONYQUf1EbLaA==
X-CSE-MsgGUID: +XVLnH3CSfiSKxpDX9/BtA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,270,1763452800"; 
   d="scan'208";a="209093662"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa010.jf.intel.com with ESMTP; 03 Feb 2026 02:15:05 -0800
Date: Tue, 3 Feb 2026 17:56:37 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Ackerley Tng <ackerleytng@google.com>,
	Alexey Kardashevskiy <aik@amd.com>, cgroups@vger.kernel.org,
	kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org, x86@kernel.org,
	akpm@linux-foundation.org, binbin.wu@linux.intel.com, bp@alien8.de,
	brauner@kernel.org, chao.p.peng@intel.com, chenhuacai@kernel.org,
	corbet@lwn.net, dave.hansen@intel.com, dave.hansen@linux.intel.com,
	david@redhat.com, dmatlack@google.com, erdemaktas@google.com,
	fan.du@intel.com, fvdl@google.com, haibo1.xu@intel.com,
	hannes@cmpxchg.org, hch@infradead.org, hpa@zytor.com,
	hughd@google.com, ira.weiny@intel.com, isaku.yamahata@intel.com,
	jack@suse.cz, james.morse@arm.com, jarkko@kernel.org,
	jgowans@amazon.com, jhubbard@nvidia.com, jroedel@suse.de,
	jthoughton@google.com, jun.miao@intel.com, kai.huang@intel.com,
	keirf@google.com, kent.overstreet@linux.dev,
	liam.merwick@oracle.com, maciej.wieczor-retman@intel.com,
	mail@maciej.szmigiero.name, maobibo@loongson.cn,
	mathieu.desnoyers@efficios.com, maz@kernel.org, mhiramat@kernel.org,
	mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com,
	mingo@redhat.com, mlevitsk@redhat.com, mpe@ellerman.id.au,
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es,
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com,
	paul.walmsley@sifive.com, pbonzini@redhat.com, peterx@redhat.com,
	pgonda@google.com, prsampat@amd.com, pvorel@suse.cz,
	qperret@google.com, richard.weiyang@gmail.com,
	rick.p.edgecombe@intel.com, rientjes@google.com,
	rostedt@goodmis.org, roypat@amazon.co.uk, rppt@kernel.org,
	shakeel.butt@linux.dev, shuah@kernel.org, steven.price@arm.com,
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com,
	tglx@linutronix.de, thomas.lendacky@amd.com, vannapurve@google.com,
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com,
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org,
	wyihan@google.com, xiaoyao.li@intel.com, yan.y.zhao@intel.com,
	yilun.xu@intel.com, yuzenghui@huawei.com, zhiquan1.li@intel.com
Subject: Re: [RFC PATCH v1 05/37] KVM: guest_memfd: Wire up
 kvm_get_memory_attributes() to per-gmem attributes
Message-ID: <aYHGVQTF6RUs7r3g@yilunxu-OptiPlex-7050>
References: <cover.1760731772.git.ackerleytng@google.com>
 <071a3c6603809186e914fe5fed939edee4e11988.1760731772.git.ackerleytng@google.com>
 <07836b1d-d0d8-40f2-8f7b-7805beca31d0@amd.com>
 <CAEvNRgEuez=JbArRf2SApLAL0usv5-Q6q=nBPOFMHrHGaKAtMw@mail.gmail.com>
 <20260129003753.GZ1641016@ziepe.ca>
 <aXqx3_eE0rNh6nP0@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXqx3_eE0rNh6nP0@google.com>
X-Stat-Signature: 6eih6wru63f1qho7gj9b51k7cq86x6gu
X-Rspamd-Queue-Id: B6FA7100009
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770113728-582042
X-HE-Meta: U2FsdGVkX18TWkGUKGrPO286+WPidptZ2pNP90/b+q8d5/a23aePJOHKnUojkHqG7W0ADSyqC68MqhttjoWXOTT5iDvWl0gqH3KleeidRWpPkudcbGlTlsGQjQ3j2xzAs2Gw/L+T2ROsT3KspX50HvERHZEmjajglTAVwpIutZE48pRVwBhrEUcy5uz5U6jSAFUIZHMB6qV2t3Q4BoaiXNcAEtRQhGD6mt3z8GNr0T5EQ7Q+NNxteZIctx3PU61R9GOV+A5rTM4jKYSAgR7sPnZsDhgRznqfFsJblrBM0ZylqwM23Z9sI5+rTmIwukKfqhQ9d4SdJisAfPXQjS8Iu9hGlLTJLPiDQ9mTZODPNsq+9UwZD0h88WLnFJOXFijKbw6k2EViLSDg+nntk0R9Dor4alRoNBOT3egLcDHTIVhY9+v3ZH6yUnVuQ0nihAXgZjQVdd+B+GMdN3AXVme8602Bn3fm+sd5wR8BhjBWvff2b+5NTntyxq36FAtL6h4yBLVATWFcpKNCUgKGw3zgNotF62zWve5/b/TiZpwxgvpDAM8NEMnOzmGVrmXvG8cXmiNnIj06jeyGhh88OuTI9mh7kYx1u6iPHV5TT5cIdXdJicGK1RYjSOCaFT0fq1bbmK03ZvSIWAaWZ9RIs0T+leiQKjcp4kzmNjPuXEX7jLhB+TeDiRzqwo/3AakBuMwWa6iY7n8i7BvrkiXWVwUUgNZHxDN1EtpMNNEODjUEDkpt+/kmnGG2HqLJLNjrONzkGc7hkIc3UYRe+oG1lBUkVaOz6qUoqAako8boZaRE3IMTnOPGtteWwqKlGaVTm6NGhFIHQRPFZR5gdt1maLfxKS4PdlRhRVYOThIGM21euI5r//RIuq4rVI4RI+wFNFRkdchFdotgV+g4t20zmj2Divr84yWF2Cbn6qDo8Z5MdNuu239sx9kdVFQPoxk7Mn3sAYP5OK1IaJjjN5OWjJr
 +S5eawPZ
 1RMASkWj7VBINzWczFgyIgVRaMZxZ9p7J/Get1db2yluFtNHmdrrp14iKQBkYUvVoIZrFG3eIga3FvHANNBnF8CJ5c/m0jMb/sveWDK/Jr71kFPu7kQUG1DL7lct+wy9LVAVUGWLLeD382NuZ7srf8e89a3rgkms0/K2Ha+Z/MKZZOToJUI9YtcpM3z4qeJfTHBVUUF7mKpQOdQtdbRvxIoQRR9HqI3t+AXItcyAv64HYYPzaEWb9S2HOERKR7+9OptPzYMmytMXxALAlZ3mYWh8Z8X9vY+fw1USPVueRKg3GgKCuhhCpE8e7OheugPpidmyP+dMHdlmWCuajJwRhSEdy9nc2QZlUuSqS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> +1.  For guest_memfd, we initially defined per-VM memory attributes to track
> private vs. shared.  But as Ackerley noted, we are in the process of deprecating
> that support, e.g. by making it incompatible with various guest_memfd features,
> in favor of having each guest_memfd instance track the state of a given page.
> 
> The original guest_memfd design was that it would _only_ hold private pages, and
> so tracking private vs. shared in guest_memfd didn't make any sense.  As we've
> pivoted to in-place conversion, tracking private vs. shared in the guest_memfd
> has basically become mandatory.  We could maaaaaybe make it work with per-VM
> attributes, but it would be insanely complex.
> 
> For a dmabuf fd, the story is the same as guest_memfd.  Unless private vs. shared
> is all or nothing, and can never change, then the only entity that can track that
> info is the owner of the dmabuf.  And even if the private vs. shared attributes
> are constant, tracking it external to KVM makes sense, because then the provider
> can simply hardcode %true/%false.  

For CoCo-VM and Tee-IO, I'm wondering if host or KVM has to maintain
the private/shared attribute for "assigned MMIO". I'm not naming them
"host MMIO" cause unlike RAM host never needs to access them, either in
private manner or shared manner.

Traditionally, host maps these MMIOs only because KVM needs HVA->HPA
mapping to find pfn and setup KVM MMU. Now we have FD based approach so
with dmabuf fd, host no longer needs mapping. Does that give confidence
that KVM only needs to setup MMU for this type of MMIO as private/shared
according to guest's intension (which is fault->is_private)?

We don't need to track private/shared in VFIO MMIO dmabuf, only to keep
them unmappable.

> 
> As for _how_ to do that, no matter where the attributes are stored, we're going
> to have to teach KVM to play nice with a non-guest_memfd provider of private
> memory.
> 

