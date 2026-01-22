Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64D30D3EE89
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 16:34:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B903A6B02A3; Thu, 22 Jan 2026 11:34:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B57906B02AA; Thu, 22 Jan 2026 11:34:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2FE56B02AB; Thu, 22 Jan 2026 11:34:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8BDF26B02A3
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:34:25 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 31EE7D2B47
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:34:25 +0000 (UTC)
X-FDA: 84360147690.04.DF659FC
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2A1B94001A
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:34:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=H3tyBuPO;
	spf=pass (imf04.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.51 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769099663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L0r70yq+P7UB3qkVO5/x8sBghKy9pd209cUDvkPIBxI=;
	b=q9FqkNpNxTP/nk86PHwqxLKKpigfefpodqqxLJoueQ+7nXqKd7viw2nRowWLcaQO6Xw9t4
	2Rmby/SqnJEfiCIBcyC8PSbc5fRD6VsIPs2OubDrD3jC7AwptT2URJa5ArTxS7yjLSNAqv
	tiLJeDef76GVTzm9SY0DO75z1Z5RqDU=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=H3tyBuPO;
	spf=pass (imf04.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.51 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769099663; a=rsa-sha256;
	cv=pass;
	b=w8+jMKrAu88V8RM0AbNEaeI6oCJ/1d/CT7ufHVB1KHeBTV5ACm3dQ/aDO3xu5aVheW9ENH
	DRf/g6vhc1ABFcm6G0jt89jfENbFyH+6n+tnNbts1ADSv8RxhVMjX60jFqxJf+ZQw107fb
	KuHyTmgn4+F9we5ZlSe0yIUIsw4XeMM=
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-5efa6d5dbf5so348017137.1
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 08:34:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769099662; cv=none;
        d=google.com; s=arc-20240605;
        b=QJ2i9N+Qi6r7LSKKOOG55yiCJ9y3aWuIz1FH6SFFt/rQXwsqgs+b31loCNS7V5dcoq
         p5P7D2xu4lC3IrlbTfDVEHPTuuRO3VkKVaBgDlIclteaGHsrKIXMWDM8KQlUgFycXuZV
         CMcIg/cxInXMwblj8MwxAcm4lbjveLHOSo0gR5AUUQbUiQ/uksPian9By97jnvn9CUxD
         hls3MJAIMetKZAEYdO8invAVLS5XnptsMYUVCjp5JucgFxGIh3GliLfxGzy05nBTTCgA
         zVUpJ6yXygWaPhXOa1zeUrYP598lZfg+CdC+EqDXOT0JM5VvCjYHKkCYYryRKxahw7KC
         uXAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=L0r70yq+P7UB3qkVO5/x8sBghKy9pd209cUDvkPIBxI=;
        fh=gvIYvv4hNB5+rxWcMRRn4m79LrD1vAVtC4U8Pqth8nE=;
        b=WRZv+GUZ5OgYnP/omOojOrWauuUsIOn+z4v1q3PBle/lmJgYweWhyTWDYFy1RADSZC
         WgjHh/r5wTizZR6b0HDxx2ccDTGyIu51dBqQ0ehMmLn+k8K6wwt7gL2IfmK19VqXadR1
         7cQtXbF0hy62gHbmYkwt4Y/ZX+shab4rfFRLkTNF28yRS+/tUmz3bs3Gk/d6YysMN+DB
         mU/pcjNLSyW0Dk86QKCbNWq4Yh7aEoFKQHC5yM5VA37z8PwaXM/Lh+M5XohrsM1eKvud
         T0/KBkxY5iudOk7eIKF7DxyoB/iQf4DKzkgY5nQBxvdVVg72eBneyWmvQIwwbPHh4LH2
         fvvw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769099662; x=1769704462; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=L0r70yq+P7UB3qkVO5/x8sBghKy9pd209cUDvkPIBxI=;
        b=H3tyBuPO4zmM+J1fRjzIuv8UlN5P6/23UmzvgvdM9L04zz4nGOjtR9Xg0Hj4UIT1Dx
         cUB17QrVtmYuKHBN0qwF6NuTBLQSx+ZebrHqd4nFz6+mSH4rXVI2JquIG5bbYhgyfp3Q
         hgVDzQEBtPr0admDgVirXVARJzokA4Py2d7UAW9uYhWCi6oH7UmtBHnoNI7mfw0xu0PX
         3+VSWfKdLFMIF+p+pfJjD9xdjnCrd9PgDL166q95ZcomtuORMnqC31aRL1dd/8zgYmeM
         FWASADNcEvVwq58unEUSQLhKRhtSbwfZEuWKv5pKtzykwfBgxlGdeVOSsHgOYMc1y0fn
         pWOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769099662; x=1769704462;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L0r70yq+P7UB3qkVO5/x8sBghKy9pd209cUDvkPIBxI=;
        b=c0T35wjtbxwdjR2KyL3zcWbQs8DBVNbnViCKGONegTyinWGPmlGwNEOgLOYUwNVVUc
         9pLi0GEApXDQGFZqAYDf3chrErCDzME6iGDFzHGNNBWndO7VeQkk1HEQ1plQfKSKFSy9
         bN2JSkxGzq/BohKRaLvsHJfo/ak2vhNU1FGZg6C0NztNUmbLLyKpMigxMJeYRXOR1HOI
         J36y7mufSbldMGPfmVVu/HQ5YJfAT2KYEQeq6I/lYu0k55VJDIx+7LvZrWJg+wjFJLXL
         7BcH9ykzyBA5AXo8uZ6S6VAHhAKm0cPtaV41gvlXw5SABLpnsDMCHiQaKqPE9eQ+BrZf
         Bjpw==
X-Forwarded-Encrypted: i=1; AJvYcCVuDukm3COb/7CmNXKY10LiDV6mEj0mW0W28d6IXTYsPjO2MU06HMB/cq48s6ObowI76yrXRUVqkg==@kvack.org
X-Gm-Message-State: AOJu0YzQLvIvfz7kkhq1AGwx1voEq9csRSVSqCdTnawOH1pctKrvFBbJ
	AQkw965dHXbsKs47L/5SE4MNgwhhNwnKThzm9PjOEK1G+nLTTMWnoTrPCrgqFr4Si3L1MnpkLW1
	DyhGIeQKJBHSHsXBWlQzd+29orfzzKpAhL82QVHuk
X-Gm-Gg: AZuq6aJ33ATmYYPSeNN1CiwGLKzDEmOEyyLm+EU9FFO5MNeJvdIIynrzoqklIvwko+S
	Mxp2Ec33KTDG7fcdyedK/SjN6Z5YHKlvd5UQdQfPSi7Uc0HrCiP+gEOuA38/fca96Z7oAcH+ma5
	Rtk2H8fvKtC4Cm6R6rHMq+8/5ZNhlZu/8as8loYbySsvNQwT+Ja9za6hSd1pm7HedosQkUb2274
	+CvP5fJdURUJRjvVZ8YgAZE0aYefRlAR+uuYqTabdga/4q7JY2bCUCrWJtEEFHeTBPwGzy4PB82
	Us7u
X-Received: by 2002:a05:6102:c52:b0:5ee:9e4b:a81c with SMTP id
 ada2fe7eead31-5f54bc6d8edmr83779137.22.1769099661387; Thu, 22 Jan 2026
 08:34:21 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 22 Jan 2026 08:34:20 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 22 Jan 2026 08:34:20 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <a2b79af7-e5d1-4668-bff3-606f57d32dfc@amazon.com>
References: <20260114134510.1835-1-kalyazin@amazon.com> <20260114134510.1835-8-kalyazin@amazon.com>
 <CAEvNRgEzVhEzr-3GWTsE7GSBsPdvVLq7WFEeLHzcmMe=R9S51w@mail.gmail.com> <a2b79af7-e5d1-4668-bff3-606f57d32dfc@amazon.com>
MIME-Version: 1.0
Date: Thu, 22 Jan 2026 08:34:20 -0800
X-Gm-Features: AZwV_QgNvHql-EMuz2B4VijAKAK9511fycMrz6pi1d87rdZBUNlP58MQhoc9tIU
Message-ID: <CAEvNRgF46M1jp0+eBu2wQMO7P1afyo00SOkENFwvB2KYX3dnFA@mail.gmail.com>
Subject: Re: [PATCH v9 07/13] KVM: guest_memfd: Add flag to remove from direct map
To: kalyazin@amazon.com, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
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
X-Rspamd-Queue-Id: 2A1B94001A
X-Rspamd-Server: rspam07
X-Stat-Signature: jooeqfqzt8nzd5se1kg6toejuhq4keh3
X-HE-Tag: 1769099662-613316
X-HE-Meta: U2FsdGVkX1/ZCcatkfmWvuVMR8e4nlqAkT4nu/sthNxt74k0+vazruVeKC+HiqZvD8WyRFkFFOBPtDc+g130SGK+j3Pz7cNDlJYCtTd6DgYJkjPOigh1PQilAuw1rfeeY8jQp3HdRnwlHAPeL45EL5XWEBzf/nbSEeE3971uuE+FHACZgyNb0Razs/Zn9uhDb7EJMqzSo7bx//AeuVu0/GKcwriojgvMydz1FHZwwj4jJTWCjIHN9f30WTbeG5lSBApOgtznkBIx9OLVcSS2pdkDRpEoEnKS0YPsYcMmt3wt5STXGE/LYaFQGsj+ONxDVpzy30NyPWCdJKO81BTES36wQN5cULmdr3SZFe8HsQMvCXGtF5KbtrlLYzQHCDVB9WfvF3o7gLHN659Yh9XhMo/+bj5OhtxQdKxcqzIl0tI8Kzr8VwTyWyySHGywB/5dpR92/R9+Utvv+NtvgQqkabjCwWxi5Xnp6ZxND9bhrXubkN/2XfQDgoo8Sa559MFblxubuRLERbtjwtIaoCdCvVFbhFaE5ySQOq4qhpzb79umPWEuD2wSKObeocqjxaI6szQrEZhs09vt46K7Czbgl8p6Ivr6JF0mnSJSn0kKAseaLNtBcRDnDnv+M5W0G/MwrCAHOuDZGxEl835FCWe5zKqyv2wJcnc4KV3Mk0+tvfXYtpod9jgyVEDmpDqY43FP0Ncw41/4ALrGYB+HIyDW53gqjy/LxK8kt7B3HLCU1CukxEQqZ+i1unVbpchH5BKOmA3s52rE1q8nIFfw1QQ1sZd36cDYn0f2rpSRwVf2fFtaBVXlk5uFl1B0R3Ggj+bPWAV/qgQPZSRnYgH5ToiFqN8fCUjgu8762uxzI6Jqsz7HkbOOaBJ0zAO0ltY1Ev+kmwXfcyAh3xJEaniJsjhE/HyeUu2vaoHaENKcJGwRzh+ctdPDbE22hfTa59XSXkTk1uSSBvk99wGNhrX8uU/
 vMzHM0Ko
 DECqVYo37m4wnemhx7JfCHXCg0hBgI9URwLcAuHzcKdECnojXBqSWFCuy2kQasRuZ4Lpn+V+xQkCwIkqRIMYmvjVfHJL3zlBzCI5YVWFaClPzCSNlwGto0iANpGg94PvoGjLYaMo+pHMB1Syii2tLRqPz5NKimQdj2RXhOwF7GwkN1e9u2by7uoAgwsO0peVolMQEOXjoCSZ7J2qwX5/SV8nrP/spGDtLxdZX6La/hdSRdL2oSlPjnQUVuPDHSxZTXwm7HFP88LlyFUS4MNfxsP47e/BL5EQIekZVIOzIDcZa+gOtGlt7Jg+eJTXjAg0uqKS1FY4hR/1zoLqmysDy8XftO4Zkfv/DHcgf/Db1KlIjTLlIxSP8+CahSzfoVxq60uaWg1f+88ddX9ZdRIb7Vjmp88J8c6JSWUdOy0BuZHILPxfAyo8+u3YsYzxZ32Dvv13S8c1DQdUugoaGQY/W0VDbTKYBRMKJB/sBGl9zO6q60B2EuTn0M3VU2LtOEiSPqajmz7NIk7iYl9Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Nikita Kalyazin <kalyazin@amazon.com> writes:

Was preparing the reply but couldn't get to it before the
meeting. Here's what was also discussed at the guest_memfd biweekly on
2026-01-22:

>
> [...snip...]
>
>>> @@ -423,6 +464,12 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
>>>                kvm_gmem_mark_prepared(folio);
>>>        }
>>>
>>> +     err = kvm_gmem_folio_zap_direct_map(folio);
>>
>> Perhaps the check for gmem_flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP should
>> be done here before making the call to kvm_gmem_folio_zap_direct_map()
>> to make it more obvious that zapping is conditional.
>
> Makes sense to me.
>
>>
>> Perhaps also add a check for kvm_arch_gmem_supports_no_direct_map() so
>> this call can be completely removed by the compiler if it wasn't
>> compiled in.
>
> But if it is compiled in, we will be paying the cost of the call on
> every page fault?  Eg on arm64, it will call the following:
>
> bool can_set_direct_map(void)
> {
>
> ...
>
> 	return rodata_full || debug_pagealloc_enabled() ||
> 		arm64_kfence_can_set_direct_map() || is_realm_world();
> }
>

You're right that this could end up paying the cost on every page
fault. Please ignore this request!

>>
>> The kvm_gmem_folio_no_direct_map() check should probably remain in
>> kvm_gmem_folio_zap_direct_map() since that's a "if already zapped, don't
>> zap again" check.
>>
>>> +     if (err) {
>>> +             ret = vmf_error(err);
>>> +             goto out_folio;
>>> +     }
>>> +
>>>        vmf->page = folio_file_page(folio, vmf->pgoff);
>>>
>>>   out_folio:
>>> @@ -533,6 +580,8 @@ static void kvm_gmem_free_folio(struct folio *folio)
>>>        kvm_pfn_t pfn = page_to_pfn(page);
>>>        int order = folio_order(folio);
>>>
>>> +     kvm_gmem_folio_restore_direct_map(folio);
>>> +
>>
>> I can't decide if the kvm_gmem_folio_no_direct_map(folio) should be in
>> the caller or within kvm_gmem_folio_restore_direct_map(), since this
>> time it's a folio-specific property being checked.
>
> I'm tempted to keep it similar to the kvm_gmem_folio_zap_direct_map()
> case.  How does the fact it's a folio-speicific property change your
> reasoning?
>

This is good too:

  if (kvm_gmem_folio_no_direct_map(folio))
          kvm_gmem_folio_restore_direct_map(folio)

>>
>> Perhaps also add a check for kvm_arch_gmem_supports_no_direct_map() so
>> this call can be completely removed by the compiler if it wasn't
>> compiled in. IIUC whether the check is added in the caller or within
>> kvm_gmem_folio_restore_direct_map() the call can still be elided.
>
> Same concern as the above about kvm_gmem_folio_zap_direct_map(), ie the
> performance of the case where kvm_arch_gmem_supports_no_direct_map() exists.
>

Please ignore this request!

>>
>>>        kvm_arch_gmem_invalidate(pfn, pfn + (1ul << order));
>>>   }
>>>
>>> @@ -596,6 +645,9 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
>>>        /* Unmovable mappings are supposed to be marked unevictable as well. */
>>>        WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
>>>
>>> +     if (flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP)
>>> +             mapping_set_no_direct_map(inode->i_mapping);
>>> +
>>>        GMEM_I(inode)->flags = flags;
>>>
>>>        file = alloc_file_pseudo(inode, kvm_gmem_mnt, name, O_RDWR, &kvm_gmem_fops);
>>> @@ -807,6 +859,8 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>>>        if (!is_prepared)
>>>                r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
>>>
>>> +     kvm_gmem_folio_zap_direct_map(folio);
>>> +
>>
>> Is there a reason why errors are not handled when faulting private memory?
>
> No, I can't see a reason.  Will add a check, thanks.
>
>>
>>>        folio_unlock(folio);
>>>
>>>        if (!r)
>>> --
>>> 2.50.1

