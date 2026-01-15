Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68441D4661C
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 19:39:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFE566B00B5; Thu, 15 Jan 2026 14:39:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCFFA6B00BD; Thu, 15 Jan 2026 14:39:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B875A6B00F9; Thu, 15 Jan 2026 14:39:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A6DB86B00B5
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:39:52 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7D9AE1AE530
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:39:52 +0000 (UTC)
X-FDA: 84335213424.01.707DDE1
Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7862B16000E
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:39:50 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=eDiTGPLW;
	spf=pass (imf08.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.44 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768505990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8OTackPsw2h0c8jYnXMkXzgJ/rIyJhkclZPRusTP9Ac=;
	b=1QYRzdiavXOOYbzr9MbvZ5WFY+MPZGI9B6He09dq82FQ+IxzoSxmb40J2ySv825CKLpGFs
	RwfDB3RKHO3HZdv+ts66blBM7TrFwZ/p09ijk6hwUuhuQPcs3HSn2gHWitJvbckHdofHDK
	qkQP9ldSdQXLZZOQlVI/zpCzREuJp3A=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=eDiTGPLW;
	spf=pass (imf08.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.44 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768505990; a=rsa-sha256;
	cv=pass;
	b=vrUT4B9mVCz8nYCaQUoDrjW0OBTknzugb/7proj8RSdrnsKJgngI+LLNlYLCqBJ6MrkoGY
	ZDye9J8rNbun8T1At339ntgDLF5oWchWg5R5Sy9t+PbRabQ4m1FsmdD2dpjdOhoQYOoq2G
	sUwgHWs+QzjN+EJCofOGTa2QIRgPDKk=
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-5eeaae0289bso851267137.2
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 11:39:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768505989; cv=none;
        d=google.com; s=arc-20240605;
        b=K0pdgUXhZ/rkN7FWjILg2wQtpJb8Ov4Y10yXTtt+VoBl9EVZ126yoSBKwzSQ2OruBg
         1umwnPTON3gZhrVdF8b7xx8ceJJ+2IpTVnXb7MT4/2vcTvE/9UzQpYvuBTzHeDNCSFNM
         caDW4y0Kgu7HLU5zc+zXR+VH0XwpkpDsypZLp4lGL3jesrvhxzPQnQbTlKTItqFyhmB6
         UcA5g+c2ZIUaiOK8d7SwEkBDSMSZ9sq0P9hXlv8qeHMxEytiFGiCiDm92Npu+Tu6BQ1t
         FKAnwVjMp6APd5qVCMbvSW5Yfarsu7MIMR1kdqRc1hMNYpoQOjywHq0941mYlgfTQnkp
         R8aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=8OTackPsw2h0c8jYnXMkXzgJ/rIyJhkclZPRusTP9Ac=;
        fh=G+NvdpVgDzRqxFKEzNPkCT7452n3EHjVF/3ECMYMzaY=;
        b=FecEWYQGj5ZYuskjOfK3yBqhdkUs5Ck4wtxymaOvKaRKv3+G41XxahzndiGkdt9AyA
         7G2VpJUhnY5MnArrJDigKviIUiUd3ONHj17CjQgyzM1Y86eRMKVWLVwULAghEmle/T7G
         peQfXlMCv4RtQrKY2RZIFucOnYEc/BuzD3u1Lp6LRl2EDGDdEgx2Jyf15oH9VLXpaxKv
         LXUr+ZLRQRbDlfifVPunVdoUI98P4JJvoyJ5etM8Suvxaxjte/c1sUapz62Gj2ZLhmT/
         6AAYhB6EtmqIf/hjiENMXFLVwJn6X0JebI5KT1gPO/1joQkPCpAhneaLJp8nB/km5lWq
         5xkQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768505989; x=1769110789; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=8OTackPsw2h0c8jYnXMkXzgJ/rIyJhkclZPRusTP9Ac=;
        b=eDiTGPLWZnl4/aT9Y3PK4YVgr5MV45Pao/I1dmHamEFCtMkCRFlhgNHgV2/L0/EHD7
         pCL6N4ZgzGPXJ9yfd2P4yc3m/xCYwiZOlHT2T12hHiF0ONW/7X7zA3sVQJ6KRsN9kqgq
         VN8qdwUAgJ/3OFjpSfbf59vt0WhYXsskZH7tI8XGgDijqa3BNG1MsWIZw7FPaUyIhLnv
         25HcPyVkkdFn1IGijA8Evk7i1tgKaorjDIoLwWC2EFl+SY0itQXlIcpKBc2u+WmJOAcg
         upoofB4fZ2G+JgrR/ZdbrQxg2jqslleHYT+lI5Ql3wvH3SiwmTIzykbOaYQJvgpp0RFU
         /TjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768505989; x=1769110789;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8OTackPsw2h0c8jYnXMkXzgJ/rIyJhkclZPRusTP9Ac=;
        b=RoUwmSIFEcfHwPeNm+VEeucwAmOXdq76MQReq6OAfdfjjwBMPRg6eN31FdQGLNYe5w
         g3x3+68u9DGaGQsPesZ6kj13/dkaZnjOz28XjuOcJ3Zmg0GQdsR3HiVvs6qKewIiJ0po
         eBfE4fDp092OrHziScVYi4FNSUdB7uOf70jFKChzY1uIaAsObB0+RtQG1j6t1PV9urIp
         lfVEJl1Hx6HtK4O4GYEsczsvp+kgd1DeJw/xqaWgUnQ4dDHfYIWqph7yo4fy55gZAoNY
         hers61MZqZYo7X84EJ/YKMmYX6HBZwYxEqJvfTI5okA0OPUOjdU8zQRvLpImyikM9bZr
         eDoA==
X-Forwarded-Encrypted: i=1; AJvYcCWVr0J6McDUpduTmHiShORueVgLgY+xabF+T83RVHapldEIKf+KuKvTh0CFGeLLb2u7LHJ5bf9ljg==@kvack.org
X-Gm-Message-State: AOJu0YyIkqREZaJ25kfhrhksou20lE6IaFL9g5+V3QnvMFmZ9NsIYEX6
	WsuX4LzRINY2NoAs74fRWpl3DOlQqwcEghThicb0+cuYHlz7XyXCbCfXcLny0uCkvavPIn/sR8X
	/7a939woZqJWe4/RHnqbcC1Z76VMzpUuci+gh06qT
X-Gm-Gg: AY/fxX4x4YJvOo8SeguTdqybXNKIRdN4CUARTDGrUeQVuVzlojtjj+7TJyrVIl6xK1A
	GAcl8oB2emEd89swX2No35nLShatY9e7xkUZZy454cj3duNA9kB8mZoA3DetYIyryWyZCOpvF7r
	KGDmAZ5HU09jKOCq9XufR6787l8xsQoUx5W1XJW7yaDowyXzZPF0pVNN/m8E2o+6YrqswO1VrR3
	WW3LYC4Qyd8YN41ABQLBpqYABOpHZ+BFV7fQBfH+pJ9B2GU7zUr9DGpHld2rudUgNLOPV2+qn+/
	Gt+b3xP46cCSWkyhYdk3FHHu8DV9o3LNrBwS
X-Received: by 2002:a05:6102:3708:b0:5ef:ab71:cbcd with SMTP id
 ada2fe7eead31-5f1a4d8ce85mr377168137.7.1768505988665; Thu, 15 Jan 2026
 11:39:48 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 15 Jan 2026 11:39:47 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 15 Jan 2026 11:39:47 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260114134510.1835-10-kalyazin@amazon.com>
References: <20260114134510.1835-1-kalyazin@amazon.com> <20260114134510.1835-10-kalyazin@amazon.com>
MIME-Version: 1.0
Date: Thu, 15 Jan 2026 11:39:47 -0800
X-Gm-Features: AZwV_Qiu_D8foB8Z5ZjGyCrmwdkqsKcMaz5fdNTkl-JawXW8yxxzsPZp7V4tbiI
Message-ID: <CAEvNRgGz2gRu2i+OSxasuyZudqsRGXijbDES8uXVe_hH6QCK4g@mail.gmail.com>
Subject: Re: [PATCH v9 09/13] KVM: selftests: set KVM_MEM_GUEST_MEMFD in
 vm_mem_add() if guest_memfd != -1
To: "Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "kernel@xen0n.name" <kernel@xen0n.name>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, 
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "corbet@lwn.net" <corbet@lwn.net>, 
	"maz@kernel.org" <maz@kernel.org>, "oupton@kernel.org" <oupton@kernel.org>, 
	"joey.gouly@arm.com" <joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
	"will@kernel.org" <will@kernel.org>, "seanjc@google.com" <seanjc@google.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org" <luto@kernel.org>, 
	"peterz@infradead.org" <peterz@infradead.org>, "willy@infradead.org" <willy@infradead.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, 
	"ast@kernel.org" <ast@kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>, 
	"andrii@kernel.org" <andrii@kernel.org>, "martin.lau@linux.dev" <martin.lau@linux.dev>, 
	"eddyz87@gmail.com" <eddyz87@gmail.com>, "song@kernel.org" <song@kernel.org>, 
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>, 
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kpsingh@kernel.org" <kpsingh@kernel.org>, 
	"sdf@fomichev.me" <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>, 
	"jolsa@kernel.org" <jolsa@kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>, 
	"jannh@google.com" <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>, 
	"shuah@kernel.org" <shuah@kernel.org>, "riel@surriel.com" <riel@surriel.com>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "jgross@suse.com" <jgross@suse.com>, 
	"yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>, "kas@kernel.org" <kas@kernel.org>, 
	"coxu@redhat.com" <coxu@redhat.com>, "kevin.brodsky@arm.com" <kevin.brodsky@arm.com>, 
	"maobibo@loongson.cn" <maobibo@loongson.cn>, "prsampat@amd.com" <prsampat@amd.com>, 
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "jmattson@google.com" <jmattson@google.com>, 
	"jthoughton@google.com" <jthoughton@google.com>, "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>, 
	"alex@ghiti.fr" <alex@ghiti.fr>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, 
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "chenhuacai@kernel.org" <chenhuacai@kernel.org>, 
	"dev.jain@arm.com" <dev.jain@arm.com>, "gor@linux.ibm.com" <gor@linux.ibm.com>, 
	"hca@linux.ibm.com" <hca@linux.ibm.com>, 
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>, "palmer@dabbelt.com" <palmer@dabbelt.com>, 
	"pjw@kernel.org" <pjw@kernel.org>, 
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>, "svens@linux.ibm.com" <svens@linux.ibm.com>, 
	"thuth@redhat.com" <thuth@redhat.com>, "wyihan@google.com" <wyihan@google.com>, 
	"yang@os.amperecomputing.com" <yang@os.amperecomputing.com>, 
	"vannapurve@google.com" <vannapurve@google.com>, "jackmanb@google.com" <jackmanb@google.com>, 
	"aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>, "patrick.roy@linux.dev" <patrick.roy@linux.dev>, 
	"Thomson, Jack" <jackabt@amazon.co.uk>, "Itazuri, Takahiro" <itazur@amazon.co.uk>, 
	"Manwaring, Derek" <derekmn@amazon.com>, "Cali, Marco" <xmarcalx@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7862B16000E
X-Stat-Signature: yw396q3op1p66o4p1ubt443xw5t5ak9g
X-HE-Tag: 1768505990-284199
X-HE-Meta: U2FsdGVkX1+291spmePZGKTpX7HBpRYwON52mK4tzn5++1MvnrHO8/lpZmVKnnkvDxueJtYFa2utOGAH3lE2U5rcaMXY9R0ZbXLQz4SN1q36esNAuYQVCGFXEcyIcMIb97MfUSaWfW45ruGHvJg/9YNeaWx4n1kJ8UanBiGfIiiPsk0dJthnepAwGGSgTHtuSTXXvqKYzvwGc7UViU7Snk/4zgIa+GyU5O9Z6rLkWkPplu3AeeUanGdf3Ch6M445ZVj1HK8zwOScrBve4AA4OfG91djUfSI0o2cJoobivHKz3JN3QUvYVIf1lLozaZXVgumIVrC/w9s6KylX6dAROOhXR+/dKy/5CssXwrJFXwOM/Gcn1yMHpU+gImE4T1reTRR/XY5RHX3JIbhEMYSNUVBQqqmQtWcbSsI1umxv1RV7h3+j0AMi8EHcAFD7sGcml2g/yR3qty5YRvxiHz5slbxuso+k7KpN0UabmwzvTWT3qQYHdhXYbAKV0OMwD5302Cw5YY0yntgz6dqop4eXatDHTkugrRBiLX5wYxtI6SuZvW8KLZTKVpuu3JuYfsPh1VrD4ttZNQGaTYpum4FkOtye8Ah2rJ8zxc1OR/lslA3vzJSY76BwcDauagKIzPk3dc62I984/DyTVLAGpF+jDh5O1e8y5eBXf5IJe5qXPnBnotfYTJr2nRd7H/bGVZp6lQHfREH5sV3X5xn+3jRBRZvObgcMrSWip2YulgQck81r6GrsZ+Tng7cXXNIbIsVrPlrCqB/HlR8jveraJIR8zg4CaDmvFQyqUmaWN6XGl+0kN13RyuPk8R1CjknQQCrmqmmIa01/dvA9IHrnfO8G8207m92bbUbnvjPxzGaZR1DJG1IeWG+azfpgd5yI/msSqO+AHmujNRYzHMswjK18Dusojlk7UoaRBCu9xiP4ROWH1h+0XAO4eACnDJvVxJNAlTqWmFebg29TOnkVTns
 WSBB35JT
 0SQPbJQb/SBRNcfMILdnvrEm4fqaoHuCWAZj6QnSIHtCRv1Q2LSLdf3pq5rwp5gV08HcOBenlPyVRsnhE5Kragx0OkSRRzVI4tdHap7UOqg36LsZZq19U8PKDSmHCEaz3uHqz43xGNTFcJFvqnA9Qiapl8qi5/hwjR8kcIP5AEzGC1xKpFsUfj0LELJYQN5ajoC0XmOr+419uhtCWTIq9owP8rlSM7fH4xbXYgEgFOuOPEhsGyNmwI4YiOALBvsB2TVxUk02aYA7IvcAlRzdFPobojlgfdka/8hlaJnWswkhWsM6A0PkUeJhJkgJzLu11sNwJti6ZwoBl+BxewH8OzB83Ft/iviuIhKNfYDsK4dkocmzDNQI+EarmL5TeN6MkwXUeBFwg7a/u21wJq2dVFtWkq/D8G7515G6sVAiXaeQ+MwZBg0k3ilS8QI++QY073Kk8RMu2+yvbhS1AG/QSXNst1kPoaX5rdxg205f3bxo3s16QuI1lZh6PiF3Fxyhj7zV7qmJPwubmitA5o5q8D29fsmcx8k9FlOxEkvrsGCQuzKS0sKSsoqgiP6c6d/fYlMFWcY9jaQ+odMU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Kalyazin, Nikita" <kalyazin@amazon.co.uk> writes:

> From: Patrick Roy <patrick.roy@linux.dev>
>
> Have vm_mem_add() always set KVM_MEM_GUEST_MEMFD in the memslot flags if
> a guest_memfd is passed in as an argument. This eliminates the
> possibility where a guest_memfd instance is passed to vm_mem_add(), but
> it ends up being ignored because the flags argument does not specify
> KVM_MEM_GUEST_MEMFD at the same time.
>
> This makes it easy to support more scenarios in which no vm_mem_add() is
> not passed a guest_memfd instance, but is expected to allocate one.
> Currently, this only happens if guest_memfd == -1 but flags &
> KVM_MEM_GUEST_MEMFD != 0, but later vm_mem_add() will gain support for
> loading the test code itself into guest_memfd (via
> GUEST_MEMFD_FLAG_MMAP) if requested via a special
> vm_mem_backing_src_type, at which point having to make sure the src_type
> and flags are in-sync becomes cumbersome.
>
> Signed-off-by: Patrick Roy <patrick.roy@linux.dev>
> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
> ---
>  tools/testing/selftests/kvm/lib/kvm_util.c | 24 +++++++++++++---------
>  1 file changed, 14 insertions(+), 10 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 8279b6ced8d2..56ddbca91850 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -1057,21 +1057,25 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
>
>  	region->backing_src_type = src_type;
>
> -	if (flags & KVM_MEM_GUEST_MEMFD) {
> -		if (guest_memfd < 0) {
> +	if (guest_memfd < 0) {
> +		if (flags & KVM_MEM_GUEST_MEMFD) {
>  			uint32_t guest_memfd_flags = 0;
>  			TEST_ASSERT(!guest_memfd_offset,
>  				    "Offset must be zero when creating new guest_memfd");
>  			guest_memfd = vm_create_guest_memfd(vm, mem_size, guest_memfd_flags);
> -		} else {
> -			/*
> -			 * Install a unique fd for each memslot so that the fd
> -			 * can be closed when the region is deleted without
> -			 * needing to track if the fd is owned by the framework
> -			 * or by the caller.
> -			 */
> -			guest_memfd = kvm_dup(guest_memfd);
>  		}
> +	} else {
> +		/*
> +		 * Install a unique fd for each memslot so that the fd
> +		 * can be closed when the region is deleted without
> +		 * needing to track if the fd is owned by the framework
> +		 * or by the caller.
> +		 */
> +		guest_memfd = kvm_dup(guest_memfd);
> +	}
> +
> +	if (guest_memfd > 0) {

Might 0 turn out to be a valid return from dup() for a guest_memfd?

> +		flags |= KVM_MEM_GUEST_MEMFD;
>
>  		region->region.guest_memfd = guest_memfd;
>  		region->region.guest_memfd_offset = guest_memfd_offset;

Refactoring vm_mem_add() (/* FIXME: This thing needs to be ripped apart
and rewritten. */) should probably be a separate patch series, but I'd
like to take this opportunity to ask: Sean, what do you have in mind for
the rewritten version?

Would it be something like struct vm_shape, where there are default
mem_shapes, and the shapes get validated and then passed to
vm_mem_add()?

> --
> 2.50.1

