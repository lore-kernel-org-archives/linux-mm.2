Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 769DBC87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 21:32:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3ACE6B007B; Fri, 25 Jul 2025 17:32:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EB8B6B0089; Fri, 25 Jul 2025 17:32:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DA136B008A; Fri, 25 Jul 2025 17:32:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7D8676B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 17:32:02 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CC1CC16094E
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 21:32:01 +0000 (UTC)
X-FDA: 83704084842.08.6FA416F
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1278D40008
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 21:31:59 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Nq5/wh8f";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of 3zveDaAsKCBkz193GA3NIC55DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--ackerleytng.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3zveDaAsKCBkz193GA3NIC55DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753479120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s/2wQleH7ITFpN7KmyE45uwJ+UkF1jVuCUBrc+xrmHs=;
	b=Vrr5RA6j+7p441o21rhvVrLUbVirqmCfKO3dLczCLj/Cb7DI5dfBBF/+wJPLWj9vJGiICL
	QhhuXR3XfMtlEka7y/1BuW322/Bd1GVfTEl49Gm8kTNLlWyXqezaYPsv55FdclTgRWksxl
	eKgntuuDexAgN1PBzktzwLVnoI3YOkA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753479120; a=rsa-sha256;
	cv=none;
	b=XSXzJ13pSAiYEU5jo6Gf2DlMyuJGD7D07atEtWJorexnGCynsbega+RBfR39qhtFGRZfSr
	WvF2KKaslHd1G+OMmo3DSTFF1g7KdLw2kUGVQ3NKbEeKCQ/igggQd1ZNeP/15WGGOrWJvu
	jnHcQ9pNWP6vOi+9XceCBdzUSY1wEF4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Nq5/wh8f";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of 3zveDaAsKCBkz193GA3NIC55DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--ackerleytng.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3zveDaAsKCBkz193GA3NIC55DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--ackerleytng.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-74d15d90cdbso2096422b3a.0
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 14:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753479119; x=1754083919; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=s/2wQleH7ITFpN7KmyE45uwJ+UkF1jVuCUBrc+xrmHs=;
        b=Nq5/wh8f+XxFvW8DrccrJJnFPJjT2yTwEtxOOAGeLq3mRwWSLdEU1ZJHgTc2fbls0l
         I2N37Jcm00alSJwDfmWZnNiHWek39izFpkZyvpHcywTFQeUgcY7oma/LJesZLOo0HlYV
         6Z1wWaEPXzkFrUYst3CrzLwl08ybrxl2IbqlT69QKG/GiubMiRfwaBf2NIWOKzg3bvQE
         NhqWsIwP8tiJahTG+ahuLW1qf0yLu7Mx6ZxY0t+GarfbDWvJLxZMFwiLkqFVmcNIaani
         l6MEQEUgOpZpDJUjSTIVRu5GgSEXNvhH6+Pwc0X6pgZ1iWP0WUUa/zqrq1onWMX8fBLf
         d2vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753479119; x=1754083919;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s/2wQleH7ITFpN7KmyE45uwJ+UkF1jVuCUBrc+xrmHs=;
        b=QMz849RoIqN5o60VJAe4BRWNUUfHWgGDQtGiKSaeiIGrCiXxpvEeKtjmwepOIp4f5W
         vu5h6q/5i+ppCzGniVmsgU687rkUaBYcFihaEsIQeeYUvlxe2bdW2A79DDxFLD9Fgsaa
         267CKEjbYBxxKlbRBg/IGeV1OnqFbX1tDJX7PLF9+NIEwERvNnUn81yASmWr92Xxoj3n
         dKun2lgm0YHkNy9QeUsAT+bWVHK8dzfhiHffREOnnQ1J9+jzrfxUQhJY0FONmWzPoTWs
         JdUKdr+d2Yj+VOG2pXSrZigmYCHgsFQUP6qKc4ypKNMBdiiEW2qfeLi6zQIy27xgTqbt
         u2UA==
X-Forwarded-Encrypted: i=1; AJvYcCUIYK/I5BWV9LHlKoTN9dp2F6UIQ4jEihHrfPaq0zrHW7Uwq26rUOnx1TCQGpf1LYxhwqW6UF1jRw==@kvack.org
X-Gm-Message-State: AOJu0Yw9LC0a0rz6x5GAo//3Y/HLWfFnuRb9Pp17K67ZNj2zS53G1rIB
	aK6Kh9/Sz8FfHd3XNZSbb+Gzk5mo1fAugUOkacAk5BXJ21ePyaSuCzZYIp66T9kSwf46LIxr0Z/
	LrUe24XYST1Aw8pYSVsiJLzq1uw==
X-Google-Smtp-Source: AGHT+IGesKxQTKVmzs1CWmOLMYF7g3871uG3DVQpvVnVgh0Q1qhmnR88/PeohzOlETvzSfBr5Eb7p3CMiXA/OH+/rw==
X-Received: from pfbfj4.prod.google.com ([2002:a05:6a00:3a04:b0:748:fa96:6db3])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:ac8:b0:74e:a9c0:9b5c with SMTP id d2e1a72fcca58-763358302abmr4894396b3a.13.1753479118583;
 Fri, 25 Jul 2025 14:31:58 -0700 (PDT)
Date: Fri, 25 Jul 2025 14:31:57 -0700
In-Reply-To: <aIPgjOLq8erW06gK@google.com>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <20250723104714.1674617-16-tabba@google.com>
 <diqza54tdv3p.fsf@ackerleytng-ctop.c.googlers.com> <aIOMPpTWKWoM_O5J@google.com>
 <diqzy0sccjfz.fsf@ackerleytng-ctop.c.googlers.com> <aIO7PRBzpFqk8D13@google.com>
 <diqzseikcbef.fsf@ackerleytng-ctop.c.googlers.com> <aIPgjOLq8erW06gK@google.com>
Message-ID: <diqzpldoc5yq.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v16 15/22] KVM: x86/mmu: Extend guest_memfd's max mapping
 level to shared mappings
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 1278D40008
X-Stat-Signature: 4y6qop4wfk8imyw1xk6pc8bid6seqf8p
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753479119-137830
X-HE-Meta: U2FsdGVkX18xeNpLhon6bpA5oOTGjGjEFB09BTVMj5ZQ5qoA9BY2tftIE6CM7cvHpKbd5loNtTdaZvz/Lzwy/7ZMb5iakWap76FbzyrL3Wj0b9R2Tf7ki9koGjanwzc/DGH9Hbw1U0ZTTfzzVYS9azzAAlEnYeeeXRBvWp5m4rqd4ng5GVnV9ZhQ3RpXwO/gMueh+OaJhrLJgXdZPUSvQicIeLUbsrSRi3z0Wgdu2lvc1+wVaY6YzOsGflFrYG97jT+CRiBBozqWK5gqQtkH9bq4F6Nvo68KkoXnr56H3G/6LoVijXfSR3x6N1pkN/0CdkCWbS/EkkZeeIMmJo1UPsOq6TrfctZCihynrn3/70xaGdB6h4AYbIhpSEPPa9lLvg1jTOu2YHlUhSj8v6ExgfCzRrxzIcbDqMndf9WRbtLOYtKLQZ4nme43gmcgEZc1a7zLkRCaox9pCjn3nfYP7h5LgrcPn3QNRoXUikqySnGAcgj6yjs4j4q6cZPG/0acWX4xPDOdb5G7f/me1s6cO2K0xqVxPhUMn9kOJ03AyOdc4nlXALKB/CRL6X/DhVgIYBaRMDuP3Ay3WdPbsWjGEEMorjqP802o6NY7gGZ0ZKH5MLZG4/WRC0BnyPthOoN1DOnKIuEBT2jO5m/WAPehx0A5HzFlqXWbM1EEbdCFc0QTy4+c9YuOS867khfoOBmWlIwndHX3dx7pECT92E4K2BEiLv8p6bXw2nwaDB5ThhQGQxkw9szlKYBwhCsZC08Y/G3hTHlmj7ccHcgKGu7v9qVk848JA56yzyiFIEKgC39NgK8NuudbFn4CRvAv+w5U+ato/ZPCbh4Tcwu8fNj56BciznPnLyaM1a56Qrb9rT+n6C5sDVfI215Neke8/JmSO843Tf/rkUP+tpHLwCE2pFTKlEG/HG/PNLqAz3oLEVtrtoIKqVZYlz4P/Ovt5dkGyhF39WzDHoSqQMiI5zK
 RQoqsjPi
 wkjPh1y/Onsawg66GZsMIgK/er8Ky2YB0HWb2NJseMym4q9sRL+eje7YhqTtgxRTHoIu/2SzZlwg8YZJ1l+k4sDhWWSeqcQdBGlmza18XOPqgkQ1nHu1t7kf7PsCiWry2M+Zxp/pZdfm6qO+mFtc23FBeBDUUQfeSRA56bwPv3FGRjVfsBWZGQGWq3qKvKQ+XzoW4cKCoqbduwxkYtR5+h2hwgC4le7/Pqp4F31i9pymnN5V+e1j6ouGy4DHcJ63LRYxNzfobRD2IwhcTLgXUsINu+TaAeTT3snJH/lJD6rDISkPhBWCkeC75ZXTz9xfKsRwVvlV6a40LTaLQ/K2YI6uzo3omgSO0XDWz0/Oj71qQASpB88rZkaOlv0wM18hkDKJPBdUijvDl1I5FPQ8xT/mzHG9VThRNXcs4kF0SXMNUS1CKwADGBsmLDH6yIO0oW1CAxHqIZxxd9m7Am1hGgCLelmjt2RboNf0jOAcZorvecCobFwRjcZLYpThup7fSv8YjHs2L2vqAZMCXMTctRJkJ7V2jUrD09YPVdqW4buEcI0QFcAU4oIFapGUQbr0Oqzv7H9Q1X8BwofO9SdJX2506Hr0610v3zQtZqk1prou94xox3pHPJvaXV4zx1k2iXM5gQI2aHUm0na5Jd/K1SIdE80AgZ/aoDMKclv+pUZJhgPnn+bKQBJjBvQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sean Christopherson <seanjc@google.com> writes:

> On Fri, Jul 25, 2025, Ackerley Tng wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>> > Invoking host_pfn_mapping_level() isn't just undesirable, it's flat out wrong, as
>> > KVM will not verify slot->userspace_addr actually points at the (same) guest_memfd
>> > instance.
>> >
>> 
>> This is true too, that invoking host_pfn_mapping_level() could return
>> totally wrong information if slot->userspace_addr points somewhere else
>> completely.
>> 
>> What if slot->userspace_addr is set up to match the fd+offset in the
>> same guest_memfd, and kvm_gmem_max_mapping_level() returns 2M but it's
>> actually mapped into the host at 4K?
>> 
>> A little out of my depth here, but would mappings being recovered to the
>> 2M level be a problem?
>
> No, because again, by design, the host userspace mapping has _zero_ influence on
> the guest mapping.
>

Not trying to solve any problem but mostly trying to understand mapping
levels better.

Before guest_memfd, why does kvm_mmu_max_mapping_level() need to do
host_pfn_mapping_level()?

Was it about THP folios?

>> For enforcement of shared/private-ness of memory, recovering the
>> mappings to the 2M level is okay since if some part had been private,
>> guest_memfd wouldn't have returned 2M.
>> 
>> As for alignment, if guest_memfd could return 2M to
>> kvm_gmem_max_mapping_level(), then userspace_addr would have been 2M
>> aligned, which would correctly permit mapping recovery to 2M, so that
>> sounds like it works too.
>> 
>> Maybe the right solution here is that since slot->userspace_addr need
>> not point at the same guest_memfd+offset configured in the memslot, when
>> guest_memfd responds to kvm_gmem_max_mapping_level(), it should check if
>> the requested GFN is mapped in host userspace, and if so, return the
>> smaller of the two mapping levels.
>
> NAK.
>
> I don't understand what problem you're trying to solve, at all.  Setting aside
> guest_memfd for the moment, GFN=>HVA mappings are 100% userspace controlled, via
> memslots.  If userspace is accessing guest memory, it is userspace's responsibility
> to ensure it's accessing the _right_ guest memory.
>
> That doesn't change in any way for guest_memfd.  It is still userspace's
> responsibility to ensure any accesses to guest memory through an HVA access the
> correct GFN.
>
> But for guest_memfd guest mappings, the HVA is irrelevant, period.  The only reason
> we aren't going to kill off slot->userspace_addr entirely is so that _KVM_ accesses
> to guest memory Just Work, without any meaningful changes to (a well-behaved)
> userspace.
>
> For CoCo VMs (including pKVM), guest_memfd needs to ensure it doesn't create a
> hugepage that contains mixed memory, e.g. must not create a 2MiB userspace mapping
> if the 2MiB range contains private memory.  But that is simply a sub-case of the
> generate requirement that untrusted entities don't have access to private memory,
> and that KVM doesn't induce memory corruption due to mapping memory as both shared
> and private. 

