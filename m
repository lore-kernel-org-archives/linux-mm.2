Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8A69CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 08:56:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DA008E0002; Fri, 12 Sep 2025 04:56:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B1F68E0001; Fri, 12 Sep 2025 04:56:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A12B8E0002; Fri, 12 Sep 2025 04:56:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 193758E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 04:56:00 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B0C7513B9B5
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:55:59 +0000 (UTC)
X-FDA: 83879990838.30.206EE2A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4944DC000B
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:55:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IveBiTgu;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757667357; a=rsa-sha256;
	cv=none;
	b=B8D1n4Z0wunjoR1LDC3All9OpGOHy+dHlbB4aIUnyaSuiTtvI5UtTy8s6cE8Hz6DDv35aK
	gnDWzEYjknp9GcWxGrnpUgd03WkGakqSzvipdH0TDb8IduL2FwWHYefDALefz3ArnocrLx
	2FXQeQMo3A13ndNCNmPeBQ+CaYs9fe8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IveBiTgu;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757667357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yhSXL+2pa9oDbDGRuQ4gQlpl18vQ+30/sPKc3K6z7Uo=;
	b=zDFOofkgV6fmxShqRtPFyJiuwxElVXivy7J1emM+GfN9OAIWRoaEU3xBM3YZjKsoUaEYRd
	klj3TYhUIkUI1B66ET4LcW+sjtliWaQlJD+MaItbEMNa2r1MMbaOxix843Y0sxR6p3Umv5
	OY10qVQW5rsja9ks+6j8+Pk4urXxoeA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757667356;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=yhSXL+2pa9oDbDGRuQ4gQlpl18vQ+30/sPKc3K6z7Uo=;
	b=IveBiTgu6K6wb46I3mtmTdpkQZdEaqeL7kwT/a8yxdSlKW8E78iZo7pxHlYZUQtPHxFiux
	ab9FzjtoPCb2eSDilf1UonpvzWM9HIJYBUUXLpll/e4fZlMu3/EBp+6NQjhHgc7kmlbz7v
	K1OjrPcQbN3bxuuhO2kLH+8V/cZFQEk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-513-zBmYV_tDMjipUocVCrrsRQ-1; Fri, 12 Sep 2025 04:55:54 -0400
X-MC-Unique: zBmYV_tDMjipUocVCrrsRQ-1
X-Mimecast-MFC-AGG-ID: zBmYV_tDMjipUocVCrrsRQ_1757667353
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45cb612d362so9314905e9.3
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 01:55:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757667353; x=1758272153;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yhSXL+2pa9oDbDGRuQ4gQlpl18vQ+30/sPKc3K6z7Uo=;
        b=FzdaG3xAZne+AeLDt3aldrWHbW+Sw/88xoaSOSb09QNU95FeQN+e2FoLMS46H/sLow
         MHUQiz5x0TI9w+Zk1e2TWzUdnixipylkBPwyEkWNrQHjmW8d0t1QQz5d0QL2NLiGfrV4
         TMM/gB2VXSNwtPeuo98+6+RFaAtcDBrcg9JDiM70JbZ65gp4W3bClfTJMFswS9sFEKQw
         7Tu+FChOw8spESiK42Zsj+S7qc0QNhdvPelhB0XiPL4wfhX7HPfAbuD6dUwiIBWF9QzC
         M2PWjRyDYHHzcxshsfRxZLOBGa8QwzJT2RlW8ZubkXfiGnIdn04LUx2lZk49PewUL8Bo
         N/3A==
X-Gm-Message-State: AOJu0Yxb1Pzx9x1kTRYxFG1LY7YBrBMACaCAnheLw4wG6vpugrYWPc3C
	zCkMoGu4B6fpVUThOPe9YELclwy2AlsbmLJuqexsQ2WOQXeERNU6wOxJQdWLuqNtlCFnBrmZZys
	3FLIhGLWeR2cEAV1F8fnDFvAiFfYIyng6ud9lZ2aM9uCCNeCNiZ1F
X-Gm-Gg: ASbGncvAkEil9n6Ov3TPq9JbajaM/RDC1CyMLdDy6U9dl2nFhpzcMoa8XqOXxAB/9D8
	sB3f8MHAdACKtR2ohWZufray7UQnSKvMBDzYBbiNefUsLYORgosxw7HvFLmo0XHFZ4XCx4RCwcT
	MF7PFwNdw/yzVgDbhg3emXGKdnnLUzi7d9l+FD+gA+JRvf3HH9bbedaWYctUwprAhnL+Opp79cj
	f1nyNDlnpRuocFsg5tBvk8+W75RlKcUUMRwYOrX2/AgIcKNsB0dgFAmo8obAJhZN3xyZNuAWbqp
	AGxesapUZLtIGWMWgkexbngq4DneRQCZAZ1NsVL9CDTx0arsdq+dlULjVxGtL0U1F0KHvUjVLtt
	tdOy75Vzeblq3c+dsC7rIIpFrM6YhhGlQEghUJ/lDq7A3abSFJUVF26B0cAZtW2oUw8c=
X-Received: by 2002:a05:600c:228f:b0:45b:6743:2242 with SMTP id 5b1f17b1804b1-45f211f86c5mr15325705e9.22.1757667353217;
        Fri, 12 Sep 2025 01:55:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGWDKbJzbJR4/u84XZSgPwx14/k9hN3sfQaLT2TQm5sKZh16Dp+Cgzni1IYyZJBI43U7rR/8A==
X-Received: by 2002:a05:600c:228f:b0:45b:6743:2242 with SMTP id 5b1f17b1804b1-45f211f86c5mr15325425e9.22.1757667352826;
        Fri, 12 Sep 2025 01:55:52 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f20:da00:b70a:d502:3b51:1f2d? (p200300d82f20da00b70ad5023b511f2d.dip0.t-ipconnect.de. [2003:d8:2f20:da00:b70a:d502:3b51:1f2d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e037c3ce5sm54255495e9.16.2025.09.12.01.55.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 01:55:52 -0700 (PDT)
Message-ID: <a17ab4e3-627a-4989-a5a5-d430eadabb86@redhat.com>
Date: Fri, 12 Sep 2025 10:55:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/7] mm: introduce local state for lazy_mmu sections
To: Kevin Brodsky <kevin.brodsky@arm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
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
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org,
 Mark Rutland <Mark.Rutland@arm.com>
References: <20250908073931.4159362-1-kevin.brodsky@arm.com>
 <20250908073931.4159362-3-kevin.brodsky@arm.com>
 <d23ea683-cca4-4973-88b1-4f6fd9b22314@redhat.com>
 <ca2054ad-b163-4e61-8ec4-6f2e36461628-agordeev@linux.ibm.com>
 <e7acb889-1fe9-4db3-acf4-39f4960e8ccd@redhat.com>
 <2fecfae7-1140-4a23-a352-9fd339fcbae5-agordeev@linux.ibm.com>
 <e521b1f4-3f2b-48cd-9568-b9a4cf4c4830@redhat.com>
 <47ee1df7-1602-4200-af94-475f84ca8d80@arm.com>
 <29383ee2-d6d6-4435-9052-d75a263a5c45@redhat.com>
 <9de08024-adfc-421b-8799-62653468cf63@arm.com>
 <ef343405-c394-4763-a79f-21381f217b6c@redhat.com>
 <4b4971fd-0445-4d86-8f3a-6ba3d68d15b7@arm.com>
 <4aa28016-5678-4c66-8104-8dcc3fa2f5ce@redhat.com>
 <15d01c8b-5475-442e-9df5-ca37b0d5dc04@arm.com>
 <7953a735-6129-4d22-be65-ce736630d539@redhat.com>
 <781a6450-1c0b-4603-91cf-49f16cd78c28@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <781a6450-1c0b-4603-91cf-49f16cd78c28@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gBwIqy5ZMylcvrotZR-idWJLUS74QiicGMl6D7paFic_1757667353
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4944DC000B
X-Stat-Signature: oq3ontyc34k8z3kg8fxcxoap7dw1h1y5
X-Rspam-User: 
X-HE-Tag: 1757667357-267129
X-HE-Meta: U2FsdGVkX1+u+Xf8vR9yhvC4zxa9+KXvMMdKGrNBgGR74SEivt5SBUsOdGzr53LtTAjW41LsbvQLUAU3rBtL4T5dWT6RZBflaHxqz7Hk0+lDfaE4v4fpIvmI2m+rTbO4KKMONqZMCVl+AdOrSIz6c2GD2izJLXS1NcPKnsGJLgGAYbp1srH0bwIs0Y3PZ3jX5Smg/t8NZ+26h1zOIopckc8Rycitkz7MBWu5DPGe5lOXELJqu6KDeAKQfOLbPPak8u1osGbCwr49JXZQTZm9Xr37AhNSVV1qUBrTDHHII2g6XgRaR7WOsBDmzGesny25bKClOEf+YNxtkEvYAxsDjxfEIytIT5qj40H6/ZpXLoHaDsLebb9/FX+obrYiBdlvZ7kSlaGrEzFv6C+qdUFKLjIo5yMbG//jl4Lkt/fVqyLt+K+la1vpmsLjWgk/FfhWEb8hhl3YRggUmcsSu1x1SBjIlgoVMhehJiL2Z5SatWZp2TLNPhGk3F1I+Dj/BelC0YKEW5f43r2IjPtbmHOm8mxpQQzXSt6nEK3d0xbVphAZjH6X7I9GwjefiHNMUB+TghmTMZkKMEHpV4s+IiNyOr2KqV3+yAUbjJU/7XzXA68p2thA86j5k9R0zJNrgfSGOVYa+QUkbnscroJDq923al2wZXL80SBuYanV/+rzXpxo30csoMeSMBlGTRpHQvRtUZumxnXiuDT1REcFFFpk6j1SIAFzVzXuRZGOIxi+y5DJLwVryHt7BcRf1iCNSC4r3qMe7ZDTvAyXrNYVdWEr279YikGPcaLUi5T6IJWHGH0cU1hztNKubR3AApcfS7cL3SAfARUBadgJ87E+eoUb5XU7S5iQYaKpxFaFmpiEHM57xY1BsrRaJsgDRe8lOdL4By6pk6WKibHMX5/vdvn16miinKM8p0WaGvm1iu+ge6hUtUDxUn+JryY/DncAi5Q2d7ib3lkWAYe6JYuqnX+
 A1t0uqpO
 hZjqUuGa5uYUOe/RbWZLZLW0xnk7loyHgeGzOvPSrM/NBiI86lWRVjYZd1rD4XVWbRhnF6YK3TJ+4tKk+6EV2XgI7Vj2QVyNcNND/3tXVoG9vAXB5dgIjpmnmn0DLbaldFr3nilkG7o/wm6AS92EWpB6FLKv9GlI3jZqYsDhzbHqyFqVCXyGVHd1nI6TBMc2QTjo2VYD1LxF4NOrX5HtSA7I7Lx81ocWNgc4fKidwAl+0Xsw+v//Niy2i9HlhWfA8rCpdgUn75m/IEivXCflWKRk1nZ6oRvu8q+FjDuIycASZMXvIjbziROdr/ZTn5u6UAdPvsIqWumU8LC8FVxpMXgx8ZbXZq6Zi7gWWs0JJ4zM3af6rbnm97qlYVDdZI2ymGzJAa39pnFNO7O+3eY+fUnOCh1FZ7OuJc05IaIy78WkVf2YYdsaTFtGpu+QbVpsUJlLwymggnELdmcVcBhiam5B1vsfIpgvSNkgw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> I also wondered about that. I think the safest is to make them
> respectively arch_leave() and arch_enter() - the flushing entailed by
> arch_leave() might not be required, but it is safer. Additionally,
> powerpc/sparc disable preemption while in lazy_mmu, so it seems like a
> good idea to re-enable it while paused (by calling arch_leave()).

Great, looking forward to seeing this all getting cleaned up and done 
properly for good.

-- 
Cheers

David / dhildenb


