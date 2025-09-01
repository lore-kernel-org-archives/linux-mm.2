Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FC5ECA1000
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 14:05:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F160F8E0006; Mon,  1 Sep 2025 10:03:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC6078E0024; Mon,  1 Sep 2025 10:03:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE19A8E0006; Mon,  1 Sep 2025 10:03:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CCB978E0006
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 10:03:20 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0FEC913B23C
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 14:03:20 +0000 (UTC)
X-FDA: 83840848560.22.23DCB8F
Received: from fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.158.153.154])
	by imf30.hostedemail.com (Postfix) with ESMTP id 63CFA80014
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 14:03:17 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=ap59WIrK;
	spf=pass (imf30.hostedemail.com: domain of "prvs=332aeadb2=roypat@amazon.co.uk" designates 18.158.153.154 as permitted sender) smtp.mailfrom="prvs=332aeadb2=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756735397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZpDM1obzK12bUteESwrJgWTMch0DIESyPnVssVZOnU8=;
	b=XjXdFIg4YPsd6lARpLBTeDETK2OGT4WbPfBDHEbVDGhh+2q63EwCpqY8DLqSiKvPbsY4ff
	Sp9a+sJa2835WJ5Fec4vQCy5F+yjhRBBEy2GPfmu/pFYWinC4yoI1g3wrAFzbJzB7PUkq/
	pWTCsBqju4yeJI74iVMjCt+iL4Kp4hg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756735397; a=rsa-sha256;
	cv=none;
	b=dNWh9bBt4Xn1ANrpShsXSnUPlAf0HontDLbQep+vT5Lkuy/rEtSpesA3zskTJSNPZPqd7z
	7K0/aPfqcNbawoP8p5Jv8IP6G3W1buKSq3RTOaxY2CVMrTxtYcg/XlGtKIBIOe95qXVpk7
	9Bp5kNS72gbpSUFlNgU+EOnE7s3VNL8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=ap59WIrK;
	spf=pass (imf30.hostedemail.com: domain of "prvs=332aeadb2=roypat@amazon.co.uk" designates 18.158.153.154 as permitted sender) smtp.mailfrom="prvs=332aeadb2=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1756735397; x=1788271397;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZpDM1obzK12bUteESwrJgWTMch0DIESyPnVssVZOnU8=;
  b=ap59WIrKdbtQm4b6DVLCAaBLQJ3DofUzCM+zAZbmcwFHXxfVbGw7y7t8
   mJdq0Vem/649qNNUvDOyNpot3D6l2gNBwjWJB1XzFAOF1bA0cwtbIqiZH
   O+UagsGhHCgOSx23nuVl2f6hXKQCaV/YOy90S7vZDN8Qaw9mKn04aSa3k
   nxL2mT0ISXVZ0QCMNmtsnf94638fJIE9Eb9GHRZUeN0GqQfRP4odCvONj
   ggRTr5G9518dfGBMKK2SPGIpZqTkz/uH4s0dYdkghCSSskmbSzBVz8W/z
   pfsz58A5w5r26KatVVOuRb4WpH12Znkt5LHbPWenlITH4cPr/ISGGcBj3
   Q==;
X-CSE-ConnectionGUID: cy41DMtgQzWT9ehlwIF+7w==
X-CSE-MsgGUID: AJVPOO4OT6GsjUOkK8ggbg==
X-IronPort-AV: E=Sophos;i="6.17,290,1747699200"; 
   d="scan'208";a="1356650"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2025 14:03:07 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.228:17259]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.42.3:2525] with esmtp (Farcaster)
 id 1e95fe30-2115-4c92-bf6e-bd2030ad81f1; Mon, 1 Sep 2025 14:03:07 +0000 (UTC)
X-Farcaster-Flow-ID: 1e95fe30-2115-4c92-bf6e-bd2030ad81f1
Received: from EX19D015EUB003.ant.amazon.com (10.252.51.113) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Mon, 1 Sep 2025 14:03:07 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB003.ant.amazon.com (10.252.51.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 1 Sep 2025 14:03:06 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.020; Mon, 1 Sep 2025 14:03:06 +0000
From: "Roy, Patrick" <roypat@amazon.co.uk>
To: "david@redhat.com" <david@redhat.com>
CC: "ackerleytng@google.com" <ackerleytng@google.com>, "Manwaring, Derek"
	<derekmn@amazon.com>, "Thomson, Jack" <jackabt@amazon.co.uk>, "Kalyazin,
 Nikita" <kalyazin@amazon.co.uk>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Roy, Patrick"
	<roypat@amazon.co.uk>, "rppt@kernel.org" <rppt@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "tabba@google.com"
	<tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "will@kernel.org"
	<will@kernel.org>, "Cali, Marco" <xmarcalx@amazon.co.uk>
Subject: Re: [PATCH v5 03/12] mm: introduce AS_NO_DIRECT_MAP
Thread-Topic: [PATCH v5 03/12] mm: introduce AS_NO_DIRECT_MAP
Thread-Index: AQHcG0kkyhDN15WuC0qLRSRUvcsDSg==
Date: Mon, 1 Sep 2025 14:03:06 +0000
Message-ID: <20250901140305.14081-1-roypat@amazon.co.uk>
References: <7ef927d8-190d-4b22-8ec7-dcb9f5f75dba@redhat.com>
In-Reply-To: <7ef927d8-190d-4b22-8ec7-dcb9f5f75dba@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.88.180]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 63CFA80014
X-Stat-Signature: e3g65mycpiwfg3w4m3ywktapm498jkqr
X-HE-Tag: 1756735397-511854
X-HE-Meta: U2FsdGVkX18eOGa+Oi/38fWcevs2h/PaMb43dKdAaRfpF2LEJzUU1qk0E53v1g8FwwMm7V1cnHGxAcTNXV0Qfai7oomBlGId7uV78Xvpdg1zxPxrNyViAZ7X4MmXE0+/Ht9vhhZbnFiIL5P8NFmJtINWHHlG5qyy34toFYAA7yVgsXcC6//ETD4fGAmmWgOwbjw36QrPoxxx1JS6k6OvnH91sXURSiAj0kKVxnbqrAXL7kQUbrqkTSynS99HqYoAsgR54yKOxSKwTowRTP2iO46bczq00noP6xeUXfj7aRj+ctQsXl+KcJ14CiAt5qrpME3dUK+wAAK9HkMTlhiE10lb/sZBhXtJq9bO3ZJ17CBzdN+2K9AKZajgy0OJqNEoU58RbUEOSGtwfQ64WXwoY7UH6lN/Vyx/cYt+/dtJsWKo9d2MZ++0L/BvmxKqX9eHZetFrAgFlGMtGpEzM/8e7t4fOzSLMzVrP4VYI5oidMvIavXoPUJptgM3VUJAEsuTOIiu0oGWeM+izwGbniEKfpTWz2AzciyLC1Fh/KkqE7e2/HaCbPg8e22RJvhrEcT9cOj43AQ2rujAcUJniZzzN5ojNzj4t65lOim4SoWnt2yes6u/TtGRhXYTCL57rcG8Ad8EbTXDPfjDZsM0+BFjCx9jlhRNVYVYEZUfvZHHrTXNDrSYVD3Elm72rNI5+CDftRq40g3ZzAzkh1RdDhBeHPBE8aZ8r3hBYpEpZf/2JB4uAPh2mD3iTVx7Eb3g0uU+lVPWZPdpbVJhIpQYQxfaP25Kuyyvzs7JNk80QgLmuUz+WVz7LZAJDSXX+xQccaN8Xo6Wvz6ARVAuLJcXQMQgmcJhxEzuvPSwSH3fDP3uv2MLd+l1v5zheefM6VFAMPqgwURJLwqQahT6nbQnw08OnH2NZ+D5herKGK79OvFRVX+MTIvpHCfsK7osyFBtISUc+1WtdxDr0F0bQQipTyN
 oAtm2/Xa
 qUBjQJAu1yoErGwWqoJt47P/EJdw84PjrPUkNnxnCyVrk3//95yNtaW9eboLKLVJefg6kiHA9Z5y8/3w5Kg7c/vbj4aRe1zapaM7Nc9mUKNBIfeLwHsozfeAQXzKPba1D7i/Lx6aaxKFW7uIBObmHYfdDaARMTCIS1RdaQ1s9NUcsBEVF9oVwiJ+LkSP92eSs/iLZMrGS5pn2S5zWn3DLWAmTZG0uropmjXZODgU8QOiwJSkjJWrqQsy/N9PqwEyy6XQ31Rcr3MfRgYvRXvVagl+gd+8JkU5b6IaLSuvmxUN+R/neU8cMHbwKMQl/VWwCqkJL4goMWzLuAzQcO74duQ9iED7PGbw7/IWGInQgVZshyD7LTQw0aaBxaVuQmcvIu+isZCQmej8zu3IbqYRKJYcDVFNPo+ifUfILwRhvbk65T4wsg3eYGylb6+YCOD0KP7lvxSe2IDhdDqs11Ghoaes5Z+b6JBcABt1ozIi3UWrRLjOK5PdFb66Lq4joa7mIHr3zmz+K8orc1yzbh+SUNfmYRbm9uFbT8YCFHOwm58OrUmzR9EFPhHroZu/d1wfYyYUObsUtPf76wUdoZBbFom2WHnJhRDmEbFVNdbQRszVpb1Ce8OoFGKFtP2H9aeizwwNKwdBfT9lZr39Atqe/sU+88hNasVa1gHkalw2t1Ubmdr0xj/YrQHcn3HYCPy1BEv7SGP9pk2XPJF6P+J9HO9d929waI+u/nQMo3TOQYJoH8c8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

=0A=
On Thu, 2025-08-28 at 22:00 +0100, David Hildenbrand wrote:=0A=
> On 28.08.25 11:39, Roy, Patrick wrote:=0A=
>> Add AS_NO_DIRECT_MAP for mappings where direct map entries of folios are=
=0A=
>> set to not present . Currently, mappings that match this description are=
=0A=
>> secretmem mappings (memfd_secret()). Later, some guest_memfd=0A=
>> configurations will also fall into this category.=0A=
>>=0A=
>> Reject this new type of mappings in all locations that currently reject=
=0A=
>> secretmem mappings, on the assumption that if secretmem mappings are=0A=
>> rejected somewhere, it is precisely because of an inability to deal with=
=0A=
>> folios without direct map entries, and then make memfd_secret() use=0A=
>> AS_NO_DIRECT_MAP on its address_space to drop its special=0A=
>> vma_is_secretmem()/secretmem_mapping() checks.=0A=
>>=0A=
>> This drops a optimization in gup_fast_folio_allowed() where=0A=
>> secretmem_mapping() was only called if CONFIG_SECRETMEM=3Dy. secretmem i=
s=0A=
>> enabled by default since commit b758fe6df50d ("mm/secretmem: make it on=
=0A=
>> by default"), so the secretmem check did not actually end up elided in=
=0A=
>> most cases anymore anyway.=0A=
>>=0A=
>> Use a new flag instead of overloading AS_INACCESSIBLE (which is already=
=0A=
>> set by guest_memfd) because not all guest_memfd mappings will end up=0A=
>> being direct map removed (e.g. in pKVM setups, parts of guest_memfd that=
=0A=
>> can be mapped to userspace should also be GUP-able, and generally not=0A=
>> have restrictions on who can access it).=0A=
>>=0A=
>> Signed-off-by: Patrick Roy <roypat@amazon.co.uk>=0A=
>> ---=0A=
> [...]=0A=
> =0A=
>> +static inline bool vma_is_no_direct_map(const struct vm_area_struct *vm=
a)=0A=
>> +{=0A=
>> +     return vma->vm_file && mapping_no_direct_map(vma->vm_file->f_mappi=
ng);=0A=
>> +}=0A=
>> +=0A=
> =0A=
> "vma_is_no_direct_map" reads a bit weird.=0A=
> =0A=
> "vma_has_no_direct_map" or "vma_no_direct_mapping" might be better.=0A=
=0A=
I went with "vma_has_no_direct_map" for now, because vma_no_direct_mapping=
=0A=
would imply (to me at least) changing "mapping_no_direct_map" to=0A=
"mapping_no_direct_mapping", which also reads a bit weird imo.=0A=
=0A=
> With the comment Mike and Fuad raised, this LGTM.=0A=
> =0A=
> =0A=
> -- =0A=
> Cheers=0A=
> =0A=
> David / dhildenb=0A=
=0A=
Best,=0A=
Patrick=0A=
=0A=
=0A=
=0A=

