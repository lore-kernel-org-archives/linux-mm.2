Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB2DFC88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 17:16:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EA316B0095; Fri, 11 Sep 2026 13:16:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C27D6B0099; Fri, 11 Sep 2026 13:16:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1BF66B009B; Fri, 11 Sep 2026 13:16:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CC1F76B0095
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:16:47 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 34CC61402BC
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 17:16:47 +0000 (UTC)
X-FDA: 85202136054.15.206E96E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id B4E3D140005
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 17:16:44 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QzV+agSQ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789147005;
	b=ZFiVqJTXNR1pdOnZrgVWrL0PRRNgQ4snFS60BJ4YCKDz6HlN/q0lPKDoZc1N4lK+bRTu3s
	aXNkswr8uIL+U+FP+v+N2amOb74O3uY4Vn0XWdKn2MoQN3zA5wnrXmu36PdqfdRjUDWhOu
	F2MxUu5xkR/L1Tpi3FkFjumG3pEID2U=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QzV+agSQ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789147005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2gLJ161dkwsq964nEcXmxhgBhqu8XXJwXX0byV6GR0o=;
	b=5h0ZOUCqqFuLc3mhmzsXMrEA/S6bSNdga9vqp80Y9DyKTwaEZ6LtlvszxRFSwGZBWTiePs
	qyQLoleIhom4cLUAJ8nD/r4CKPov6EsJQTMA9Rata01n5j3HXyikHl60m035cIbtKeEBvf
	CLfHIxSBlbMBXFB+16buI19BfE+J5og=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789147004;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2gLJ161dkwsq964nEcXmxhgBhqu8XXJwXX0byV6GR0o=;
	b=QzV+agSQahwsWUf8rV/jEMB2Uhbkc8Kg0lBxEWj2L6Jl5rxYCReGutJft1pwQmA7VVysRD
	0EoiNAG8D5eg2wRYufc4M5N1XSy8x90/t009CKnIXXR+/iEl/XyiKHgc1J1E4UpTY1dKoM
	SrFGpotOrgEN7uqdu+19P6Gz+bPw3ow=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-648-Rj-cvUwGMAyGPQnZAnD2Fw-1; Fri,
 11 Sep 2026 13:16:39 -0400
X-MC-Unique: Rj-cvUwGMAyGPQnZAnD2Fw-1
X-Mimecast-MFC-AGG-ID: Rj-cvUwGMAyGPQnZAnD2Fw_1789146996
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3F1851801366;
	Fri, 11 Sep 2026 17:16:35 +0000 (UTC)
Received: from [100.90.56.12] (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 21D561956095;
	Fri, 11 Sep 2026 17:16:26 +0000 (UTC)
Message-ID: <a3c2d0f6-a7b5-4344-b837-434aeac5dbc0@redhat.com>
Date: Fri, 11 Sep 2026 19:16:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/3] liveupdate: Move to feature flags for LUO and
 memfd ABI compatibility
To: Jason Gunthorpe <jgg@nvidia.com>, Sean Christopherson <seanjc@google.com>
Cc: David Matlack <dmatlack@google.com>, Logan Odell <loganodell@google.com>,
 arnd@arndb.de, pasha.tatashin@soleen.com, rppt@kernel.org,
 pratyush@kernel.org, graf@amazon.com, akpm@linux-foundation.org,
 maz@kernel.org, oupton@kernel.org, bhelgaas@google.com, alex@shazbot.org,
 kevin.tian@intel.com, dwmw2@infradead.org, baolu.lu@linux.intel.com,
 joro@8bytes.org, will@kernel.org, robin.murphy@arm.com,
 linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org, linux-mm@kvack.org, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-pci@vger.kernel.org, iommu@lists.linux.dev
References: <20260903023452.721732-1-loganodell@google.com>
 <20260904160009.GV4157646@nvidia.com> <aptFFYqcSiBdMLE8@google.com>
 <20260905012403.GX4157646@nvidia.com> <aqIAtOoew-_6jw29@google.com>
 <20260910143448.GD3968357@nvidia.com> <aqLOWkuVKccR-I7W@google.com>
 <20260910171210.GF3968357@nvidia.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20260910171210.GF3968357@nvidia.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: Awisp_EkgxntgWyt3zOhBBJYIPi93Li8kEHi8iIwB4c_1789146996
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B4E3D140005
X-Stat-Signature: st9i9bfpupg896zhbb7cxt3edmziti3x
X-HE-Tag: 1789147004-524917
X-HE-Meta: U2FsdGVkX1/229L84pjAf+4NG6Xf70u1EluO0gwlI/Ml1o66xLvTqc9jGSBRx9hlUBiuIIdGEKGROiD44BWh7y96JUDdmhjfasZHDcfBr09F8b4fUu1b0uu7kT1cK4QCoIVfZaucWRMKw5GbfH7sWOY+1GoChBz4trth9Gll6U1XlZwxldryS1Ig6nSKYcgxGuu9e7u/uy/4m4br/O10Lr+hYQFB+ajJE12we0Ecj4HNi6oitQzPxgvG0XkG8+KJ5AzwQxigQ8QR+ep8M8EahrGJV1/8GwfOdSnXocb2HAu/twID+9ngoyYe3ksoF5HFWwz77NMoVFRUSc1cT7d9Zi6uzmXGUhOQt76s/KYJh9L+apiqLJnXajW+/Jx4NNsk7ZrlYrSLIyoWQlWt3ZS63+qAB3JtxBhYbk9Gut246OXvfzWPGz54gBsJd59LmUmabSPpnBPE9fYvSwNYUJASEiPKgOSZnhUmIqqhcjikZEqJQw4qYDxCOXzrLDE6qts+vmizEOpS9dyRQ4+eKHPFA4VCYsu1RrwcE4XBm4qLsiyVcXS9s4/jeaEXQj6kSWZ+Gz+6FYvvGl415+t2+IxMGRHz9V6kE7NgJTBM5HfT7zcGTjPX82jNS/bUOq9eBVhtCcaLnzrGk60xJQc4tvz+pFoLR25FqoN6tvOrHX06LKZuwnDhW+l7KcBURwiOrAmnAxSdAFQXUfNz1uZJhBLRMkS863iWdx3lPV4HojNQIn064hVci+FgNwBuSwDaj+mB4eEAXwlQ4UsDJM+m//i9Z9bBRB2RGqQwV8IbNxn8iRDKzvOkhcRhuPc3eGSMg3aTlLsxue+kCY0Yyeyop9BFImHwWA2sOb9sWnflj1RpfNb1YdoHhYXYAdSgvCXA7+ZT/vWp3N7CYtegwHHxFP3PEcYVgNx7WhsCjXQfczOjcEvFnlL4P9iJwo5g0v5QkeOWgbtVtzarNO4zLQnS9sD
 E65pG+WZ
 8hZBFsXQMcNG4SCKeNSvchUblWMH+YLOwDlie2fFx4GRc10QX/1F8txdY9gIDZUhnmVTkwUiLkVNoF3hPd2MRv+D2Bit2x/2G5RL8I//JZkzQhQohPifqro+HwMfH8yVzOmqiU1SWOlrs85VFBJ1Ub8WMo5gD9jSxkXkKPST05Af/kDALntQVP32VwDB5JY8cSHDpv9sbdk+rZS4WeKaZ80nqLkb9kyA/Gj9UUC5oAkp2EPhyoRADWX5tFy8D0aBB8wZ4tRv7oahN6DDevku7OWHpc3l1JSPhaogq4KydxKg1ZdmFrHbgvRbuyfwd5Liwji3RVtQcDjec2pM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/10/26 19:12, Jason Gunthorpe wrote:
> Keep in mind the actual goal here. Someone has kernel A and they need
> to blind kexec into kernel B and NOT have the machine explode, or all
> the VMs sitting on it lost.
> 
> Meaning you must have a way to determine before the kexec if kernel A
> is producing something B will *accept*. Accept is not "parse and fail
> with EOPNOTSUPP" like most uapi schems. Aceept means bring in and
> actually fully support and use.
>
> So how do you solve this problem? You MUST declare in some kind of
> manifest exactly what ABIs are supported, in some way.

You still have to pass out of band what B will accept.  Passing a string 
or a bitvector doesn't change much.

The problem, again is that memfd is the easy case.  KVM would bump the 
version number on every other release, as even a new serialized MSR will 
be an incompatibility.

Rather, forwards kexec *must* work (again, that's nothing but a variant 
of "we don't break userspace") and for backwards kexec, well, you must 
know what you're doing.  QEMU has been doing backwards live migration 
forever, and QEMU is a gnarly C program that has grown by accretion as 
we were learning all this stuff, so it's not impossible at all.

> Yeah, CSP broadly has to do exactly this across a wide range of
> topics. It is a further reason why this feature is not exactly usable
> by a "mainstream" user :\
It's not easy, but you aren't even trying to do it right in the kernel. 
You are starting from *a* solution and saying that it makes the feature 
hard to use.

And I'm not saying to dismiss your work or ability, quite the contrary 
in fact!  It's just that you're solving for the wrong complexity, and 
only partially so because (if I'm not wrong) there's still the question 
of how to bring the manifest of kernel B into kernel A.

Paolo


