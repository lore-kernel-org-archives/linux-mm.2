Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66337C44536
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 00:20:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85E5D6B0005; Wed, 21 Jan 2026 19:20:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E19D6B0089; Wed, 21 Jan 2026 19:20:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68F2F6B008A; Wed, 21 Jan 2026 19:20:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 559116B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 19:20:26 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E66B65EDBC
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 00:20:25 +0000 (UTC)
X-FDA: 84357693210.09.D625C1C
Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
	by imf07.hostedemail.com (Postfix) with ESMTP id D1A144000B
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 00:20:23 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Ytyrpwp8;
	spf=pass (imf07.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.41 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769041223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NgWkbldIsVdXmF1uopkpscBQ8hvxBRp9zzbekpxQ/oc=;
	b=CCrW+ePjvc04XnxYVc4TtmwFps9WSC3AQFFNH9ur3a3bYm4Qe/3l0WR10Y7lhGrfMNBZnU
	zx8N2pMXwmCMloX3/F9UQXrUBmvYMxGXIBA51B+ygcb4gINJblGobgjiJoM5YMniSjnIyq
	dIujEIR7gjO+FZk6BVnE71qr8gNYn7Y=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Ytyrpwp8;
	spf=pass (imf07.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.41 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769041223; a=rsa-sha256;
	cv=pass;
	b=6pPOS8dUqd9lNOz+8mSIxKKEA8/0oSv4L344UYEX7uD42Uyrx7mYTdN0wqjwaU8Ure3w2t
	41aeOy37/BlD0apdo/gCeDTokRYVgWJ1Z3Cyx3lP8ht3N+Mz6bXkS0U6FxGqVv/J9kYifi
	uDPrqLlPLNunQ5BtVm2QpagzOYfZMxI=
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-947fef8ebf4so969339241.0
        for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:20:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769041222; cv=none;
        d=google.com; s=arc-20240605;
        b=YrunCm2F8El4F2Z8Y5sVUjNDTE9qJS5erZWH8rtCgKB9SR3CnwOVG0H+MYorawlM1W
         LxNoxV4AWiaivX1ereoo4a6VbPaQ2LRFGCE4NRpKnXmrx9t7ijU3ZSEK750xTEPSggJj
         88MeHdvVm1370YinTydHCeBUaP543HNUuWOj0jjwTw3vNgxxCo0tphZNkn3ha1Pak2E/
         lj55PVvPUSWuwP0z9D+4Pd49tbmtKZxTa9GMPQC6UrRf4rMgcTgzfBgIDNKdDthsjbQd
         3RxxRfrWS2j16eHpqYLGYB67KV2Ql9o6/s0ZGuKUOoFxLsp6CnbqFXIDWuCqtnNMer8T
         /DJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=NgWkbldIsVdXmF1uopkpscBQ8hvxBRp9zzbekpxQ/oc=;
        fh=QaZRSNLaQ4RM7yleiXTnL+CL0bOwAWGc9xjFrlVfYhk=;
        b=HDAhCKC3TqZON7K+WF3rf+IeRW8iQHnCN0JAuV1kZwApizT3zaB5CJel0f2Z5f/8U3
         54seg/cNTXvwOsFYKoPowqzQdqpftQC3ipFd4K39jOXRaSKy5CBeX4WhnwqMcObvssBP
         7hrT1E2DlKZ1M5VGxnXYrQ1e89dlImtpeUwT562uRQnNBxwqhyYbrg2YRdI2mKVDsQRX
         UcH/+aGi110tcwwXsOkCMBPOBBKkVwTM7HhLt9SSRN4AqVLptTEtIjhiO92DNEyyg2cP
         EjccTS4kEoF65Yx5ziImPgZux6xWakzB6NRTZesnkffaUSb80zgy4m/23ndgURZmGDVF
         Z+Sw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769041222; x=1769646022; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=NgWkbldIsVdXmF1uopkpscBQ8hvxBRp9zzbekpxQ/oc=;
        b=Ytyrpwp8bZE9D8fbfZ03SdsRYPpRVhTQElgRw0jvcamoEimUhrOWSeiOBiO1oSA6Om
         15mp0nq3pzoXVOFKggsZODMtI8/v0/0PUKxeoRgFa/XXcx3huytJkSzPiJIu3hxX44zf
         mYhCYKtJAT20nCKWrAijs4yWsUXn+x0JugpokmSvIvmxpJoXqWzTE55GJ/hf/zbr1VBW
         v8aBfB5U6FG8ZxMqf0/7it/2JKSvV+Iy/wxApkE+c7OkbKhL4gq6zMOMZLeSbdcdaTLT
         68KgvvqtW1ODe4sdPB5PW7AqDTYhT9Pz9MYvuqBOdULWA+RMsdswnszArn9lwm6XYmwW
         hZyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769041222; x=1769646022;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NgWkbldIsVdXmF1uopkpscBQ8hvxBRp9zzbekpxQ/oc=;
        b=jkknFwraLhu9Xgq+EbMspoptn/dTr/QpBKFhk9zIBrAppVocK/3amFlQp+USA1MMjQ
         LIQx9WoEXifriETVF8oWFib8+0xMHxHPtrwTNLTfissZmJ0DZdXRrVgjeXBjtJh9XvsU
         uOie9pXvqf0CE/vfT8rrTALLQc3ulJs8/QksBQFqHSBNYvKeoWU/rzQFmYKKwvOKtnyW
         xJWpV+z1394NO81rxWT9WaVPLez2J5bqdXm40hPz+MJUbZLPPrIbHeMNAS56BQLtokQl
         e5F2eA/NVDNsXvWumA/qXRzsBGhat0Bcqg/X1d70WhfnMQEsRhMgA+KSvoVmFsLNv/Kj
         24fA==
X-Forwarded-Encrypted: i=1; AJvYcCUiJ2TViv4pF0gYcoOP7fMcdyYpZzCHHfR964VTXb6Qd3baZ10ScedmD4OKGyVRHj8jxK6WNLQjFg==@kvack.org
X-Gm-Message-State: AOJu0Yzg93IpM8lG/en4Mi/XiXHuLqQ2gYD6j5zC3qNdkndu7srmB7a0
	upp65Xdii44njmypGibJrqqozplywVVAXsiAGn3xJVQIablrNBu/l0WSPrRbGXk6i2QFQFUYCkZ
	knNv9pDmrQlI2Ce6azm7U2xOMjCShCy6z7LNghx/U
X-Gm-Gg: AZuq6aJ27R6neHOKyPxgK6+6mLMVH8b2JF8hc2naT75uMFfs+ApL2x4cZ3Nq8ejo+O5
	g/Kle3LXE+Crf7pmCTnZfuAjxkk6+9ZVIPyfGoHhEW7/OiI4mlVa3n0czemzfBdOthmRQfKvGYe
	SNYxf1/+fQWqHILV+wjyyD/2FkGpGF+WpMXcS0jmh3Aqp0/lMvEnleH9v6wwwfYiuDQ34ngN7ab
	C1QaoWAxyU0o9S7t29eoYLcGV80HCX0nT2USVEw/hV+FBk+L0Ex25YTVzisv8u3jAjTzRPqvrmX
	q86g4VBer4ePg0VfYkHjd5tv9Q==
X-Received: by 2002:a05:6102:370f:b0:5ef:b32c:dff8 with SMTP id
 ada2fe7eead31-5f532daa025mr403198137.5.1769041220288; Wed, 21 Jan 2026
 16:20:20 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 21 Jan 2026 16:20:19 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 21 Jan 2026 16:20:19 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <6b50a83e-acd7-4db3-ae9b-015ffad4f615@amazon.com>
References: <20260114134510.1835-1-kalyazin@amazon.com> <20260114134510.1835-3-kalyazin@amazon.com>
 <CAEvNRgGrpv5h04s+btubhUFHo=d6mBFbr2BVrMt=bWuWOztdJQ@mail.gmail.com> <6b50a83e-acd7-4db3-ae9b-015ffad4f615@amazon.com>
MIME-Version: 1.0
Date: Wed, 21 Jan 2026 16:20:19 -0800
X-Gm-Features: AZwV_Qi8Ad3srMrd8WYJ_YHR6Nmvzc-hfHPfYm40mDZ1I3o7aAQCl-nKoDyQfts
Message-ID: <CAEvNRgHMdnALNfT0SuEb-gqM1Aq1c6U_nRB2GzC0jYqrDRJTOw@mail.gmail.com>
Subject: Re: [PATCH v9 02/13] mm/gup: drop secretmem optimization from gup_fast_folio_allowed
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
X-Stat-Signature: s3r6y8pm573jokk48ty4r163gk3jtn7b
X-Rspamd-Queue-Id: D1A144000B
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769041223-849890
X-HE-Meta: U2FsdGVkX18Y5riU5cbDqJtC1DaiRhYUXm9qCWeZ095/cvAepwjGarpzJXElKKszd6B4vcVp1nK8bAZ8XQHmTaR/hsH1GTTtXYx5e6ktlMyOwRkjPR3kw7xoxiofJGeCo4BNGmwwWxJb5qC6oys2jhedVNhwNhC1b9PoPhrnmI9V3h0S5uxEeKXZ5+2ij/mB2qEOSE4ycJt+dwKDIQjZbAjuTtYZrCPoAOwInYx5OAYNnhIMOfu7Oss9bvrqtDpmldGAivt8Bk9XMDAQsdWgmNySpdq5hrQslE6FN9bOzy9dg1ME8GeOr8xUuqzw683L5bB4y3h7R7AsK25AFkgxAhd+Jwmq3Mwejki0u2qheTPbLCBj8G3TYuiaIuJeVuG0748TVBbLor5aBVm4xkDtJQsyxqHapN0W8Cf+8byVc6E0T3NAOWfAzHNnbSLwSFEQMhRFfRvV0CpaYUe7toBcRsRrSfUN9oPj15uDbcriasCO5RZ6L6I5sRJ440aBQKbc3dGQyLjP4+vTeSl3KaJoRVaxnRR2knkpDGiSxI3Er/ZQDPwGm49KK+zykFdk6ocnK8xO79SXw7oWtQjsJJzy4odCMGe0o1CR7q9vVniCeSKCFxXTz5zwn1YCYWZ/JOygXIhEg5LTZK/qIUCWvYM+GcQrb3iFzkk2hnApsU9TIAivkvGosTgcRMp7UM1g4iWv68uII/8QZTh9z9wDUhReE1Gl1cg6EGmk46C4czh8hjE0Ji06WDvsk5fC2WUSFrNGlqtAB3/7DL4Jckma/vsMDT/2UJJmYJv0aq+3ho3EpBz/A5VBoj664cy+MMchSdsldR3zzphDRGwo9c4eGxeCi6GEwPOJq8tPmB8EyiLUY4GmqxI4PfNkN/b50yNjcwLVTUvSLDA0Cdb+PqO8diXYoOVzasvun7wjvsTRUJdELT8COawuIIVWxIA5BCKYYi6Q/Hu2d4MDcwgDqR6cAQc
 SVQp1AKL
 YD1utfJf8AZMGcodv2UCrRWy1FpvyIrFRP2EmFGnRJUjFNUmaJaa1zXe9I9grDP/x54MFwxkgztFdg/L4xWLJw1g3bXi3mMHxCVfVWZFYVB4jWpuP8s7GDalF+IUsndXCJFfcl5ikOfTChfFUrtSiC40duCLpwnZGeydrtI3VlBRIUKeXMaquez7G5OIRwu6ERuUApi2ag2m9Y3CdtWS3gKbMqEUWT+tROfluK/6ssbklAA9RtAXkC29WOZoGQt6fjUTr9ffB7AZFZA/nWIw2+GVCbuOQcCBxvKEJZymVwfXVWxsjslTySEQTWQcmgjsndVEgQs/fk8MhQ0gx+hbPrRlNuYhDaa81PJZZeUis+7AStAKLJbdJCXKds8cUIgusNc9EfxJ1vaOfgq5V203xvslYNaF7X6kqAui+v+/MhGJRlfYHmD8YctHUB+PIAtramxz+wU0mivDeEXbD71pdUdpFY7I0Ews0ePZ9qOW9bQ2Vw4yRnzqM0+N68M3iKe4IFGRxjY4lq+tLvgmgkMg7hetG50us+R9UTL//
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Nikita Kalyazin <kalyazin@amazon.com> writes:

> On 15/01/2026 21:40, Ackerley Tng wrote:
>> "Kalyazin, Nikita" <kalyazin@amazon.co.uk> writes:
>>
>>> From: Patrick Roy <patrick.roy@linux.dev>
>>>
>>> This drops an optimization in gup_fast_folio_allowed() where
>>> secretmem_mapping() was only called if CONFIG_SECRETMEM=y. secretmem is
>>> enabled by default since commit b758fe6df50d ("mm/secretmem: make it on
>>> by default"), so the secretmem check did not actually end up elided in
>>> most cases anymore anyway.
>>>
>>> This is in preparation of the generalization of handling mappings where
>>> direct map entries of folios are set to not present.  Currently,
>>> mappings that match this description are secretmem mappings
>>> (memfd_secret()).  Later, some guest_memfd configurations will also fall
>>> into this category.
>>>
>>> Signed-off-by: Patrick Roy <patrick.roy@linux.dev>
>>> Acked-by: Vlastimil Babka <vbabka@suse.cz>
>>> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
>>> ---
>>>   mm/gup.c | 11 +----------
>>>   1 file changed, 1 insertion(+), 10 deletions(-)
>>>
>>> diff --git a/mm/gup.c b/mm/gup.c
>>> index 95d948c8e86c..9cad53acbc99 100644
>>> --- a/mm/gup.c
>>> +++ b/mm/gup.c
>>> @@ -2739,7 +2739,6 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
>>>   {
>>>        bool reject_file_backed = false;
>>>        struct address_space *mapping;
>>> -     bool check_secretmem = false;
>>>        unsigned long mapping_flags;
>>>
>>>        /*
>>> @@ -2751,14 +2750,6 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
>>
>> Copying some lines the diff didn't contain:
>>
>>          /*
>>           * If we aren't pinning then no problematic write can occur. A long term
>>           * pin is the most egregious case so this is the one we disallow.
>>           */
>>          if ((flags & (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE)) ==
>>              (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE))
>>
>> If we're pinning, can we already return true here? IIUC this function
>> is passed a folio that is file-backed, and the check if (!mapping) is
>> just there to catch the case where the mapping got truncated.
>
> I have to admit that I am not comfortable with removing this check,
> unless someone says it's certainly alright.
>

Perhaps David can help here, David last changed this in
f002882ca369aba3eece5006f3346ccf75ede7c5 (mm: merge folio_is_secretmem()
and folio_fast_pin_allowed() into gup_fast_folio_allowed()) from return
true to check_secretmem = true :)

>>
>> Or should we wait for the check where the mapping got truncated? If so,
>> then maybe we can move this "are we pinning" check to after this check
>> and remove the reject_file_backed variable?
>
> I can indeed move the pinning check to the end to remove the variable.
> I'd do it in a separate patch.
>
>>
>>          /*
>>           * The mapping may have been truncated, in any case we cannot determine
>>           * if this mapping is safe - fall back to slow path to determine how to
>>           * proceed.
>>           */
>>          if (!mapping)
>>                  return false;
>>
>>
>>>                reject_file_backed = true;
>>>
>>>        /* We hold a folio reference, so we can safely access folio fields. */
>>> -
>>> -     /* secretmem folios are always order-0 folios. */
>>> -     if (IS_ENABLED(CONFIG_SECRETMEM) && !folio_test_large(folio))
>>> -             check_secretmem = true;
>>> -
>>> -     if (!reject_file_backed && !check_secretmem)
>>> -             return true;
>>> -
>>>        if (WARN_ON_ONCE(folio_test_slab(folio)))
>>>                return false;
>>>
>>> @@ -2800,7 +2791,7 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
>>>         * At this point, we know the mapping is non-null and points to an
>>>         * address_space object.
>>>         */
>>> -     if (check_secretmem && secretmem_mapping(mapping))
>>> +     if (secretmem_mapping(mapping))
>>>                return false;
>>>        /* The only remaining allowed file system is shmem. */
>>>        return !reject_file_backed || shmem_mapping(mapping);
>>> --
>>> 2.50.1

