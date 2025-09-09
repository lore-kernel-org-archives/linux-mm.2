Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F14C5CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 09:00:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E1D78E0014; Tue,  9 Sep 2025 05:00:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B9D58E0001; Tue,  9 Sep 2025 05:00:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A8928E0014; Tue,  9 Sep 2025 05:00:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 352A08E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:00:32 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A09DF14040B
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:00:31 +0000 (UTC)
X-FDA: 83869115862.08.A978299
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 388ABA0014
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:00:29 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=O8XofVYI;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757408429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FFaNWFCl2wdsjl/T84rwbCzslw/ZOsn9DcOtT4QWrC0=;
	b=w4e7RudBgMO6Dgbxc9bFA4l6dZMDR77O1GG6uosFH0aIZ0Lca3yYRGi7JSX+BGKEdSuM9i
	jxsc7Dvq59LhqyMgJFDDuVoF/IeAvJhmgHU4JwaxRpl5yLv3ZWfbZOWqnS/H5WYClI7zjt
	ia/kq+NXDFqy/E9oz9pZsV+3mzAjDIw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757408429; a=rsa-sha256;
	cv=none;
	b=0rgcQvVOR0Mvu05L5Zvmdoiq+pcf08M7WaohVGizhgIaNtDv93n30xbgnZTHOGawrrUWoG
	xrTM84OtPwqDIGz9FfAKmVwb5azUz3aCqTGxF97+XlqPXi3amuMZgYy9cHi0GhvzzlHeYP
	u8Nc1b74JMoRVXkjXGDdvEOcfOCwQ44=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=O8XofVYI;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757408428;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FFaNWFCl2wdsjl/T84rwbCzslw/ZOsn9DcOtT4QWrC0=;
	b=O8XofVYIRJ7JdydV/AcXJE6OL/CzP5apt68h114P/51brpsJaH1b/Lk9wp9D3jOzjTm5bj
	SyY3GBBRZRzFnFY7fcz8XB/q8rGkqbGxoqAOTaUA7SNVtSB4zIzNQ1/e+SGFAGkJkKXwxK
	BxXiUxINIGEbRczdgB4W20L0dgBeFxg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-549-t5DmcULSPp6U42Z-DIROCQ-1; Tue, 09 Sep 2025 05:00:27 -0400
X-MC-Unique: t5DmcULSPp6U42Z-DIROCQ-1
X-Mimecast-MFC-AGG-ID: t5DmcULSPp6U42Z-DIROCQ_1757408426
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3e3f8616125so2508050f8f.1
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 02:00:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757408426; x=1758013226;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FFaNWFCl2wdsjl/T84rwbCzslw/ZOsn9DcOtT4QWrC0=;
        b=ejZM1L7ehW026hCLXL76WfRfpye2OVb8qxOPBPjzcblXnxwQFqn8PN9/vM79gSlimv
         q0tfvD9zIfInVwKs5zbkUnmm4/Sqbka+oJSfOQ+IiKUCk4+zcG6URLX0tr/n56rWac93
         VXe4jWrdH8VXGe+BTXzP7Lc1/+SenPAzQ+oiSmjeaIukq+IBX3ImiyFwT/PL4DtN41ZK
         1abtdl/IpplxkWsw+Rtm8T+XEKKZjiTQ4RnVaLX/W84G7pKXurN5JcM+0xynVm1KC1aE
         k6afeVszSwAZrwPA26ZHDv3LV6K/LRNozHycceA5zz8xqAuC7zisG97WN7J+W22gPofH
         gZ6g==
X-Forwarded-Encrypted: i=1; AJvYcCUY2gFlybEKCwVemSA47QSwgKxaXZ0Bsty/A6+0Qz9YEtF78MttuvVUcYnEZiyuIICWcbECao74yQ==@kvack.org
X-Gm-Message-State: AOJu0Yy/UDZ93EMy7ddXMdEUz/4BQOxKspbp283h6HOYAdM7QhzVpT45
	CoVvUXL75Y76XVW3KHEbJ++E4rZeWm5BjSrlr2aBCJHpaozJarAFzmlBPoCqMQL7y18QMYuz12E
	psWF2/XEmFosFYLGbfwQyKitbY1HZ16P/v/SEDkue1wkaFl9pq3AY
X-Gm-Gg: ASbGncsVd34JM8bcaxb+/d4vTavKaEuz+Kf1EbzPbb1hHsVQO7Z1Qby8EWf+xuR03jk
	YoOybS3lEt/+gm06hkEwyuPHszzvq9GO9LUks/cNzGUJnLiD7d8IZWS2+eJRh1QCJ/cDJXNKp9c
	OeBGYKxubOU6nZhtNcV82csjae1+qMVUqsHNwH8EXyIluA458fn1rpSw998NYI2sL8tPuwIw2Kf
	exFTBz1ZMxMyLRN0+8PiX3Rj+1LwRfHsjplxv85f4Mp3ROQ63atxOHE8wonEB1Yap75DgF5npB4
	CcNX+3ebo6AQNcUs3Sw2xPR2jzkJsDAkZ00s6tYNkYkyY/ffj6mZhz2thxMAuQ8+OiMF9pep4Mh
	AScGIxFli2vAZeaXrMQ3ORYffUE99MGeBei72OeGCvkZUVtjWGlUsHVRrbveDm5ao3vk=
X-Received: by 2002:a05:6000:250c:b0:3e0:b982:ca49 with SMTP id ffacd0b85a97d-3e627a7cc9bmr9939876f8f.2.1757408426350;
        Tue, 09 Sep 2025 02:00:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHjFbjC0Ku1RkV979c1EkKILIgMIbFwdRAtmt79V1a4P0VkSugVjLkyPMCm81yr9ZzkyWnCIw==
X-Received: by 2002:a05:6000:250c:b0:3e0:b982:ca49 with SMTP id ffacd0b85a97d-3e627a7cc9bmr9939756f8f.2.1757408425189;
        Tue, 09 Sep 2025 02:00:25 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f23:9c00:d1f6:f7fe:8f14:7e34? (p200300d82f239c00d1f6f7fe8f147e34.dip0.t-ipconnect.de. [2003:d8:2f23:9c00:d1f6:f7fe:8f14:7e34])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e752238997sm1838274f8f.37.2025.09.09.02.00.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 02:00:24 -0700 (PDT)
Message-ID: <97b8023e-90ad-425d-8645-c3dd258e0ff8@redhat.com>
Date: Tue, 9 Sep 2025 11:00:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/7] mm: remove arch_flush_lazy_mmu_mode()
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org
References: <20250908073931.4159362-1-kevin.brodsky@arm.com>
 <20250908073931.4159362-2-kevin.brodsky@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250908073931.4159362-2-kevin.brodsky@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kS3KpE6glgcpmztLdv9Fo2FKSfHp5Lasoh1QpMh3Rxw_1757408426
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: yueci4z9djcabco45yjeyonbrh1j5phc
X-Rspamd-Queue-Id: 388ABA0014
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757408429-982573
X-HE-Meta: U2FsdGVkX1/Sqz2BCPT8SOdOmvMPZlVayIqk+TbgRN8+oezV2QjHjBrKeZRsI+qirMjhGStRz+P1yzGxs2gDB9NpF51ck8YrkZCF7h7kYHdA68HjI3iOkjUwy8ClWJYtMHWtYmTZCOYhCeLUqwfZgH7PC7Y+YD0y3KkzFonbjGwZE5qcB9+z6d63UkEumUGnPWrdD7YUdi+Vpk0m3VaWhPC1ri7lWloS2AeHZdVIfGHMc3WwZD/5V6lQKMHlmkCEwkVvYiP8daEuka31gRLfbbxYRYchjRqxEsRBtie1/+tSNkS3n3UyfHal8OKEv/yv+v6HdYrevB2+pRXMbMobVN89Ic5RpxI6lcMAYToslzafeYAR8gCNev0cRoNhDN3ciptKdlQLvh/J48nicidGphKBi1Fm/T0gS5K2mlnjDcioJ5vFQx2OwyrRbtoE6a2My85M15iIMYMWac/UN+ca6t93SusBPogi273w9lvhswxi+mRJDVzs+K2lKzFj2IoDbgPA9yN9od3G1+Vj6SCxMgVWTB2rX2EMrWRBMTLbdqDCqyqUQOzp8fkPL6gddHstAKtGNhebg782P/6Ae47gonbwWiEbxXWQ70OwBRZu2Bq8c7/fi/0aoZ0DpnS+eyN3zE+xbc21+umkmGDDFal80sP0FJpNBdmf9lEOYsGNxGXvpfquMaY+wxSOsGGBhjHpXidkiNVCnuVpPTWm+uklCiffVjccE8NJ+7MUD6DYrEuZgAp7JWbY2916jHO9I9FIA/WlkwKRjGES0UoSxSkxMnJeyjpNyFYDSrkV5Jv+x3Utx7I6kywXeyvIcvEQ+QOQ4k23ucugJyVVaGv9Z0cdmEvJpwl77l7I3O6p+wqpn64ziyhhiWJb5IoGEK5RH9p5PqWiAEZ8aq4qekEj7npUhJYAAsGW57iY9FCIvGugoEmwVuIRZ5x5jWgSJ42uqJgC1gApGrkm2sB6xGajcWP
 VenCh1T4
 M4rP/PlhjNBJ17v2zVxReYPVt7Ls/O530V1/Vth/p6oQK2gXhSd/UmoRyQE5nuPR2EAKoxZ0HxCpgWSZXfwQ4ImJ+w6J7H0m5tigqRqi+GdI2QDDsblo8UExELNHIppiGe8XbuhzOmgUuz1rN9YdrohZbfE6MZWYfScYY2Sc0DAcUFTH4zI26jgLVlseRU3s2jp3ZjtDlxPuO8A2hK07rmeqY1tbdDT4J4iuFVDkCYTDFkJLSdDJE/lwP8E1IdYoKj8vC6VEyTVtNIoauQZtrZKyiEneo6cEfat+C3gLuycLLJ9hQGCwaPVNYTfEd9KS/BgsNjReqkSFJcRfHafXlycB9o1hIE7XcSc83e7N3MPOVA3IHEvFSFE5X4NRP4dcPvZzHS2iT1uGQKGGRGaD6CY73MVDB9i66i1mgzk0h1k9bTnHe9zAXeQbK0C1N5tBt5ePu5IHF0ouGKqlzPjDxXVYOcuAwnxCjy36cbo6ITBYoLk5+dKSZ6nBe7Fw34pMxRrDAF84izzR9wkIPD1jjvhpm/BknKaALU4mh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.09.25 09:39, Kevin Brodsky wrote:
> This function has only ever been used in arch/x86, so there is no
> need for other architectures to implement it. Remove it from
> linux/pgtable.h and all architectures besides x86.
> 
> The arm64 implementation is not empty but it is only called from
> arch_leave_lazy_mmu_mode(), so we can simply fold it there.
> 
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


