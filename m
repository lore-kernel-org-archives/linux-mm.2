Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DC19D6CFAB
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 22:47:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 894A76B0379; Thu, 22 Jan 2026 17:47:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 842496B037A; Thu, 22 Jan 2026 17:47:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 717206B037B; Thu, 22 Jan 2026 17:47:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C4166B0379
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:47:34 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0B502139F3F
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 22:47:34 +0000 (UTC)
X-FDA: 84361088028.26.A72E426
Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com [209.85.222.54])
	by imf12.hostedemail.com (Postfix) with ESMTP id 04E8F40002
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 22:47:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="DiknK/18";
	spf=pass (imf12.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.54 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769122052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xs+dLd9PKnX16GE3/TgauaKHwwAlEIk3gXFN84JGCiE=;
	b=Y1VVX2BX5dJMD1XW+NueAvFNLDWD5hvSdPlyAoIAOiTHyQQmit3ibnLWacBMd62Mtzc+SE
	dDth6vBLUxiyslnx37JdLsH7ynO7YVDg1PhpflmwFj9V8dRp00tapGvDT53TcTHWLXNHx2
	3My2PFvT57gqMeyEPulAM+yAVp4Ud+8=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="DiknK/18";
	spf=pass (imf12.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.54 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769122052; a=rsa-sha256;
	cv=pass;
	b=gKeJkKd7YQw73kkgQvT5HhWWsxUloGZy/30bVk5Fimj4fAm+ehwXbJC7BmNgujUObdd9/4
	7pVnjZ/KVIQ/S+hDoYrDUecAuIB2tXHFMRftQcJBUjb6TOZ6osgYyWROk2Mcfrw8aRdRvV
	lNbE/0lxy+x6J4COOfcGBLxyAaLgCFI=
Received: by mail-ua1-f54.google.com with SMTP id a1e0cc1a2514c-93f500ee7b8so896737241.3
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 14:47:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769122051; cv=none;
        d=google.com; s=arc-20240605;
        b=SoU7JlGkMATZI91EWhSP3gNVA9ad6+FlwGZ9V6cVv40oX8dRLsFRJ2Pg83Z9yoCLww
         id9lEM+Rjq33DpusXZ/43YrjmPLL1AhRpLP1y3ZNOBaFJb443Ro24Wdywp4LGH3XmTlp
         XRyV73zLxew3efrLOaUHy4a8wtHWDoDGOwb+/vw0EStCtllqSyEUrt2h0ggVDuuAyWps
         IuHwzpzxst76jM7f95K8Ews8yugCXvHf0RVEK9hCOumaWd4lRyPWv8DMFm3Ruh6jAag+
         OKgcHH61OYH+E/cBgmwZsqv0sfpPWi/jkM2Hg/xWG8r3UZop5D8xnYWOrGK6LkscuOeF
         wu8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=xs+dLd9PKnX16GE3/TgauaKHwwAlEIk3gXFN84JGCiE=;
        fh=/R9wKEa696k/H5250Yapugr+J9Lp5TwqVFS4DchvH1I=;
        b=iLkaa8JsjJLPD74LcAouZbwHG06v8T1kZJmlWxzr7HJsx17ihAB5+R6uefTm0fOcqs
         oGean3ExObxFNHF/HNwdlg21xCZfpsTibe9cl30++DSpwvK7+oxS2vIjYpWqIdkjMWPd
         GMoyDxPCiKlmiSn7Rche2N7sGl0mdRodW6JOVR+/HRs3bPry245fkgi7njcpjS2hM3n2
         /TzZWgyVsb8j6vGJZYb0nNpHdk/TlhCBG1af7iGFt+EDsp75lbJzzjH5YPAQvGHgr0XF
         pqDfWPFkYv9NJ95yWsEiV02VBhETX/AgyDhBNiDAZhuuktvjRJAxu58I+4LxFXttiyjr
         OTeA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769122051; x=1769726851; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=xs+dLd9PKnX16GE3/TgauaKHwwAlEIk3gXFN84JGCiE=;
        b=DiknK/18if53injAsHh5p4cO5DtYCvDq828kufoSmIFcAfuoLrwvZ0CDbOkUz8Y9uU
         DUFLH4dlvp2X1IQ7Zft95e0iYu2QbdtSVSnUnqNBkmwo8AB/bYiHat9JAoz7qcwK48aq
         urQuIwTDB6G3BsTOfE0nbwjhlR0g47Fjg087ltAU8Xsa6odp7SikbJvc0PgkxSKFT01t
         qEOA1w3eCX7Wc8dQJZp3bjZjmDBFWASoX9MZxMrdV9+i3rFj0K88kHwiSxlrNCHqQXBJ
         7YT15Oh68L7pIfKWnI1v7qzkKWGSciMKQoSMz+2Fkb5S06A+4w7YIFZ9vIamQpPbtihN
         zHSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769122051; x=1769726851;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xs+dLd9PKnX16GE3/TgauaKHwwAlEIk3gXFN84JGCiE=;
        b=pMUepSbl/TZpJc6gycd9Ab+8LGFaEKsfQJ6j71arDpn1dnkTadQMuOlsbrepl4KcY/
         znM7KzGQTQ8HOTAqlb2MhLMWRB49FraRa83bVnF2etvWU1ogb/fkzSKLCkJClMS8STS7
         iXJ7b8o0Tpy4QQ4wm6hP3Ol+ESty2+zEUeKMGxOyTzltkTWNQWtudIZg4wF/qBZfVIPz
         hL0XH04Hkg2516LOVCsj6micLVh1+IjuBCkPd6pDfDO6uqj2eBtaFH1VMUY5ooZkta2Q
         qXj8goPIxZW5a6nqBarOLOLKm/i2Q7JIvATKr28KbqRnEIOh52LEJWToHR144HdKMBEy
         w8iA==
X-Forwarded-Encrypted: i=1; AJvYcCVbqrfn0nnas+zKGHD7vq3hV++TsOSdaIeRfS1MVLGQxZs98YNDMjCX0w0HwUS3623VCd1+cEHAAQ==@kvack.org
X-Gm-Message-State: AOJu0Yz6RzYX63KjCQZ9KRK/m1DC0PJaM1lMJ4hPnXZuCHJP4rzMCYU1
	Un0cwzBvkglby/1HLQovMM0fopn1dT3fN8ODUZm1A+eOKUk/G08tALTn/ygeeubXj6C1VZ48yfC
	t5RtXkoSZbF2BruQRDRE02lPoiLiquE8PLeOc/dS6
X-Gm-Gg: AZuq6aIPEE8rpuf9EY/+jsbzv5GKK2cQUSyhAbSC095lrYWTdplQKQy+o1csffnCVoU
	vwPQV2lyGwOeRpanN7JNDTpqr0XUMTG5XMIqpYjLRAcqyeLya2ofAuJKAZjtKfCFUE2sgt8y9l9
	Z1PrEy2rZrSdjV05wSSoQip9UoRphpKiBjHEA6XS1tSpH6FpTb50lFjoTbb6hosMglTv0pfqydH
	G6iu8O31fx3ficGMsE9FZQqNx6FdSdsjcaZY3tFKIP/yqzWzAa9PG9WfOwj/8UERukM3zhtwy1Z
	6wTxnW/pDMo2w5PvezjNCV8zlGYYzrZgNl0=
X-Received: by 2002:a05:6102:3a12:b0:5ef:7220:bcb2 with SMTP id
 ada2fe7eead31-5f54bc8224dmr480092137.28.1769122050230; Thu, 22 Jan 2026
 14:47:30 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 22 Jan 2026 14:47:29 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 22 Jan 2026 14:47:28 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <ee9c649eed3893d852c3d20fb96bdc4904b7c295.camel@intel.com>
References: <20260114134510.1835-1-kalyazin@amazon.com> <20260114134510.1835-8-kalyazin@amazon.com>
 <ed01838830679880d3eadaf6f11c539b9c72c22d.camel@intel.com>
 <CAGtprH_qGGRvk3uT74-wWXDiQyY1N1ua+_P2i-0UMmGWovaZuw@mail.gmail.com>
 <8c1fb4092547e2453ddcdcfab97f06e273ad17d8.camel@intel.com>
 <CAEvNRgEbG-RhCTsX1D8a3MgEKN2dfMuKj0tY0MZZioEzjw=4Xw@mail.gmail.com> <ee9c649eed3893d852c3d20fb96bdc4904b7c295.camel@intel.com>
MIME-Version: 1.0
Date: Thu, 22 Jan 2026 14:47:28 -0800
X-Gm-Features: AZwV_QhacTtf2zgQk3uMxNHfKwdT09Bqx79KDOGE5Z3VW9UujMTrgN_9VI-QiKU
Message-ID: <CAEvNRgEz0+ic9uvcsWYqWgR5EV=TfY0SAGC39zAL+n19SoBXmw@mail.gmail.com>
Subject: Re: [PATCH v9 07/13] KVM: guest_memfd: Add flag to remove from direct map
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>
Cc: "david@kernel.org" <david@kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "svens@linux.ibm.com" <svens@linux.ibm.com>, 
	"jgross@suse.com" <jgross@suse.com>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
	"surenb@google.com" <surenb@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"riel@surriel.com" <riel@surriel.com>, "pfalcato@suse.de" <pfalcato@suse.de>, "x86@kernel.org" <x86@kernel.org>, 
	"rppt@kernel.org" <rppt@kernel.org>, "thuth@redhat.com" <thuth@redhat.com>, 
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "maz@kernel.org" <maz@kernel.org>, 
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "ast@kernel.org" <ast@kernel.org>, "pjw@kernel.org" <pjw@kernel.org>, 
	"alex@ghiti.fr" <alex@ghiti.fr>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "hca@linux.ibm.com" <hca@linux.ibm.com>, 
	"willy@infradead.org" <willy@infradead.org>, "wyihan@google.com" <wyihan@google.com>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"yang@os.amperecomputing.com" <yang@os.amperecomputing.com>, "jolsa@kernel.org" <jolsa@kernel.org>, 
	"jmattson@google.com" <jmattson@google.com>, "luto@kernel.org" <luto@kernel.org>, 
	"aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>, "haoluo@google.com" <haoluo@google.com>, 
	"patrick.roy@linux.dev" <patrick.roy@linux.dev>, "peterx@redhat.com" <peterx@redhat.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "coxu@redhat.com" <coxu@redhat.com>, 
	"mhocko@suse.com" <mhocko@suse.com>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, 
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>, "song@kernel.org" <song@kernel.org>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "oupton@kernel.org" <oupton@kernel.org>, 
	"kernel@xen0n.name" <kernel@xen0n.name>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, "peterz@infradead.org" <peterz@infradead.org>, 
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>, "martin.lau@linux.dev" <martin.lau@linux.dev>, 
	"jthoughton@google.com" <jthoughton@google.com>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>, 
	"Yu, Yu-cheng" <yu-cheng.yu@intel.com>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"eddyz87@gmail.com" <eddyz87@gmail.com>, "hpa@zytor.com" <hpa@zytor.com>, 
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "shuah@kernel.org" <shuah@kernel.org>, 
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>, "prsampat@amd.com" <prsampat@amd.com>, 
	"kevin.brodsky@arm.com" <kevin.brodsky@arm.com>, "maobibo@loongson.cn" <maobibo@loongson.cn>, 
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>, 
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "itazur@amazon.co.uk" <itazur@amazon.co.uk>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>, 
	"gor@linux.ibm.com" <gor@linux.ibm.com>, "dev.jain@arm.com" <dev.jain@arm.com>, 
	"daniel@iogearbox.net" <daniel@iogearbox.net>, "jackabt@amazon.co.uk" <jackabt@amazon.co.uk>, 
	"agordeev@linux.ibm.com" <agordeev@linux.ibm.com>, "andrii@kernel.org" <andrii@kernel.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, 
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, "joey.gouly@arm.com" <joey.gouly@arm.com>, 
	"derekmn@amazon.com" <derekmn@amazon.com>, "xmarcalx@amazon.co.uk" <xmarcalx@amazon.co.uk>, 
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, "kpsingh@kernel.org" <kpsingh@kernel.org>, 
	"kalyazin@amazon.co.uk" <kalyazin@amazon.co.uk>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "sdf@fomichev.me" <sdf@fomichev.me>, 
	"jackmanb@google.com" <jackmanb@google.com>, "bp@alien8.de" <bp@alien8.de>, "corbet@lwn.net" <corbet@lwn.net>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "jannh@google.com" <jannh@google.com>, 
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kas@kernel.org" <kas@kernel.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "will@kernel.org" <will@kernel.org>, 
	"seanjc@google.com" <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 04E8F40002
X-Stat-Signature: ukdzw6zzi3oscqkiaeg4w5fhms771c4d
X-Rspam-User: 
X-HE-Tag: 1769122051-584247
X-HE-Meta: U2FsdGVkX19vu+77g8TRx3tHtLtvMJY3QnV1uiCMpB5kBdZb9ID/BtB73xZuRvhu9FBnUL4+G1nKD0wb8hgNNNbvd8DGITpoZpBwuJSnJDsvevKg4eW3zV79G9G7vsqpjJap0T4Ymq6GynEfKrWihDEevvlwHcVIhfS2yP14OlkRlAuVrQ0m75RwcVEszbSy8UWxHvDccrxW6VLtA0NkFqtwOfzQZzOTcXJDgL5NyO+5H/rg6pZlecwcObK7rn9WILdMSx0KuqDK/HVJLCmK1FxUJDuWC5097r9pPCKLKlZGh8R6yDpoDizQqSaUxiD2vLG4jjIniVNsEktey6/rJr9bFwPVLSh4hE3t0rGXR11x3lTMEUk4ecUDgkyfcqV4e3hyqOQwpXc7Za5jBCluo6koygtSCQPNzdU7h3kYRmiaj97XY3UpKwrPZPJ38JvoFHldFhihjlepc52qVuwY2+SG0u5NDRfmgpihhowuymc3ZvqVO+jYLiT3p/+4v+tsz04JJy1g7TUIZvLzOxYohC+vxcm1YS7wUmHiZ9NVIPHXbHQ8qw8IJMB3q/7vR9VnlLc9xReLkVxwe8BQVG5FtIq+Vxqq7iv9qIfmLPSPhy+mkioUyE45qGTIOLUnVhzC4ZbvuhaofuA8G2XrsFA4kXVt0ADqZ/5U5YPJo/ow5o+pYskc1cA1elFaLTrmC6RSQsLk2ypgsqY0yhy4uXp6y08QYW1us3pKLO9zrdefGTetrCN3o0JqpvGKLPDWr768MaD2SV8FUDgKaD0+pK5emtm01IKsjm0ydX2x9zlnKX6+IHmX1eYMdai8KtXS55F5QwvIcCCr1GYsR2TiFuondDs6Ni0qFbuC0RbXVPuODtim8DOjtGMxW2Q8dALPq65hRU+jxtc18J6kwQaqW6Ge/vxNmBH9HsmLJSAjEPiVbW84oFH0bbJezzLGuBHYbvkJAKsWbH63CH0UqN7aGnc
 RlKKgzBY
 TzGh9gP7RSYQmTRBHhxmRFreK2V8pACuz1cJiD3upwkIAFjw414kJwSUm74vF4pz0Wg/dHUuKl/Uckc2wzpmNQuFWcYgndp1huiIo2lgazrIJ9iOuUY3ioh3gTmSk6ygHkYTt/J8VpXHI3Ke3NNdTcechnZg0WNLKCBHlP2HZ5Hc17bG96AblqQs+jtfHbnTfrXYfBXsdK85U5iNO7L2gpwsnVx2ehJvSEC/tJzXRTQB3a1HWQQnbA5EzY19NdrDIi4OFIwp7RLIOuP53PdVJvnqrQrP+1uQ9PDBmxFiCcAgyJGJZDnS25202eVJ0jgna5Wc3oYRHDsMfqCnmWaRUc+gBJ6YE4E8XuuUIUQA+LnWGwq0IpD7kv8gQPb7ZbCD71EVdZALc6G9QZ10n7JZdrmlAkpd8UIONrjlEYqzTIejGK62uNlpqwArTuE/zRiNANM/twdkG1PwWw3tOiRYs3KURSI0hYt4aslNLcaHLnxNEzJot9DpQTDIf16dtefNtNYY/8RVCLSWRzk97OAwGje9Nig==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> writes:

> On Thu, 2026-01-22 at 08:44 -0800, Ackerley Tng wrote:
>>
>> Can we disable direct map removal for errata systems using TDX only,
>> instead of all TDX?
>>
>> If it's complicated to figure that out, we can disable direct map
>> removal for TDX for now and figure that out later.
>
> In theory, but it still would require changes to TDX code since it does
> the clflush unconditionally today. To know whether clflush is needed
> (it's a different thing to the errata), you need to check a TDX module
> flag. (CLFLUSH_BEFORE_ALLOC)
>
> Gosh, you know what, I should double check that we don't need the
> clflush from the vm shutdown optimization. It should be a different
> thing, but for we gave scrutiny to the whole Linux flow when we did
> that. So I'd have to double check nothing relied on it. We can follow
> up here.
>
>>
>> > Then there is the clfush. It is not actually required for the most
>> > part. There is a TDX flag to check to see if you need to do it, so
>> > we could probably remove the direct map accesses for some systems
>> > and avoid temporary mappings.
>> >
>> > So long term, I don't see a problem. For the old systems it would
>> > have extra cost of temporary mappings at shutdown, but I would have
>> > imagined direct map removal would have been costly too.
>>
>> Is there a way to check if the code is running on the errata system
>> and set up the temporary mappings only for those?
>
> The TDX code today doesn't do any remapping because the direct map is
> reliably present. There isn't a flag or anything to just do the
> remapping automatically. We would have to do some vmalloc mapping or
> temporary_mm or something.
>
> Can you explain what the use case is for unmapping encrypted TDX
> private memory from the host direct map?

There's no use case I can think of for unmapping TDX private memory from
the host direct map, but Sean's suggestion
https://lore.kernel.org/all/aWpcDrGVLrZOqdcg@google.com/ won't even let
shared guest_memfd memory be unmapped from the direct map for TDX VMs.

Actually, does TDX's clflush that assumes presence in the direct map
apply only for private pages, or all pages?

If TDX's clflush only happens for private pages, then we could restore
private pages to the direct map, and then we'd be safe even for TDX?

