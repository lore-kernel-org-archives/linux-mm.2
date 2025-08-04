Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4324DC87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 23:10:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF26C8E0002; Mon,  4 Aug 2025 19:10:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA2BF8E0001; Mon,  4 Aug 2025 19:10:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B920C8E0002; Mon,  4 Aug 2025 19:10:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A4DB88E0001
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 19:10:12 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3FD031365A4
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 23:10:12 +0000 (UTC)
X-FDA: 83740620264.04.D9BD906
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5FA1940009
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 23:10:10 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=emQpYAhD;
	spf=pass (imf12.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754349010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OwTFCa47yjLyOw4GeTmYZtCVh1CzB3NwU8kncZE+7No=;
	b=oIG+LqDEfLPcNOMbW/+jnroM61zW3qyh7ne9CQgXwgp7quBcu67j3KRyQIbmz7MasKrFKi
	3l5ONSglPYWiF6ynI4/dvhV4ehMACnRdlVULJLAwbUI+G5A2hzJ//+KKz36QhYwiD4vqtY
	lM5oFB1tT9+S4K4gsnLemE2d/79Rz/E=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=emQpYAhD;
	spf=pass (imf12.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754349010; a=rsa-sha256;
	cv=none;
	b=swAMWWEyljIcD49Rj4EkIOYnqU/Y7lD7FBqq6+nD2T0mrZOjTPO4ELJl4WOwvdD4irKk1+
	TzPw619KvaKpgUgnboB0ynpS16vcLgoNJEWCRpxUvmO/u1aQpiZDiBTbjHoOW7ScwW1aMK
	Ae7rm2MC2r0oKZc8gp95dOo8W8YQzrQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EFD6145EC0
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 23:10:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6319C4CEFE
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 23:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754349008;
	bh=OqU7HKlaaB+/yr85e8O0qFFV2mhIIMzXHyes2/pyXiM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=emQpYAhD7UcEV34gva/+Tj2Gk9HQNqUdMMzPJsgGAVXqLM/GSpEW0RmrusIHZTWSQ
	 mEV05f0QR6bajRjLIlWSa4IZkibAVyg4gSoG1hESJs7QfWJCgW+96Fhmr1oQfTfwpl
	 nIHxlfFJvZrseS1hYf6Q3mjx8ENyoaIVdtOIGJqNpVL1n4lK0bFMm8V4jnzkU3vH/b
	 tLPlNK/xDGtMOmbSsd4E8WBwGr4Ke0RfftUuh7rvJZlwnP4K1Ju/4GTwr2NXN4YQri
	 iuNdj9ZHC2K+Angv3b50xnFEgKLlXyjSAR/TYKmgNbMrw2C3xzIYlYhcs3/lPMPl6x
	 gBj8HPi9LxthA==
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-458bf57a4e7so20225e9.1
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 16:10:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCV3Woaav/pc/+Zhpn61vVBehO0lwH17I+17g2kfU6TCPi+QlZ4FHYNSCYg/7W8we1ZRHXu/81KMJw==@kvack.org
X-Gm-Message-State: AOJu0YydeoiGiJbc22NMHO09/t+3nrwEOAipQzdI6dgAkJMid6Z0cqYU
	OhImTZhSIAvmqxG0WJa3oZbC//z5kw3K8JDtkV2X1YvccjITCRQ/G39XvTjh0GW3ywwVRzpI6gG
	FKvoGcFYoYmm8aIfG4LtQ18ee2uOfc5vuAy1jfsmG
X-Google-Smtp-Source: AGHT+IHKpk+HdsX+UkmoGsNTrjTyAvv+GZeP3pJG7v7GzWXQDB8HcuYU8JvYjjZGY3fLVdxWGYKFXeKl60hxqHiBoUI=
X-Received: by 2002:a05:600c:3b8c:b0:43d:409c:6142 with SMTP id
 5b1f17b1804b1-459e13212bamr553835e9.0.1754349006808; Mon, 04 Aug 2025
 16:10:06 -0700 (PDT)
MIME-Version: 1.0
References: <CALzav=d_Bjfy=6if+rPmxgGJfUV8ijnQ5hf40HoH6Yozg_H6Ew@mail.gmail.com>
In-Reply-To: <CALzav=d_Bjfy=6if+rPmxgGJfUV8ijnQ5hf40HoH6Yozg_H6Ew@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Mon, 4 Aug 2025 16:09:54 -0700
X-Gmail-Original-Message-ID: <CAF8kJuP09jvpB--fLy6Ju6rRuKFS5r8vyq1ne7ragbv0suWzLQ@mail.gmail.com>
X-Gm-Features: Ac12FXy7avNazRoYmbC_NeBMrj_2tPBaCG8ggpo_BqxQQnqN6_SKMsJk-VIeXn4
Message-ID: <CAF8kJuP09jvpB--fLy6Ju6rRuKFS5r8vyq1ne7ragbv0suWzLQ@mail.gmail.com>
Subject: Re: Live Update MC (LPC): Call for Presentations
To: David Matlack <dmatlack@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "iommu@lists.linux.dev" <iommu@lists.linux.dev>, kexec@lists.infradead.org, 
	Linux MM Mailing List <linux-mm@kvack.org>, linux-pci@vger.kernel.org, X86 ML <x86@kernel.org>, 
	"pasha.tatashin@soleen.com" <pasha.tatashin@soleen.com>, David Rientjes <rientjes@google.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Vipin Sharma <vipinsh@google.com>, Josh Hilke <jrhilke@google.com>, 
	Changyuan Lyu <changyuanl@google.com>, "graf@amazon.com" <graf@amazon.com>, 
	"dwmw2@infradead.org" <dwmw2@infradead.org>, "jgowans@amazon.com" <jgowans@amazon.com>, 
	"ptyadav@amazon.de" <ptyadav@amazon.de>, "jgg@nvidia.com" <jgg@nvidia.com>, "rppt@kernel.org" <rppt@kernel.org>, 
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Parav Pandit <parav@nvidia.com>, 
	Leon Romanovsky <leonro@nvidia.com>, William Tu US <witu@nvidia.com>, 
	"anthony.yznaga@oracle.com" <anthony.yznaga@oracle.com>, dave.hansen@intel.com, 
	David Hildenbrand <david@redhat.com>, Frank van der Linden <fvdl@google.com>, jork.loeser@microsoft.com, 
	Junaid Shahid <junaids@google.com>, pankaj.gupta.linux@gmail.com, 
	Pratyush Yadav <pratyush@kernel.org>, kpraveen.lkml@gmail.com, 
	Vishal Annapurve <vannapurve@google.com>, Steve Sistare <steven.sistare@oracle.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 5FA1940009
X-Rspamd-Server: rspam06
X-Stat-Signature: i9d5icqm5w8peshc3d5nytoh6h9z5njd
X-HE-Tag: 1754349010-183673
X-HE-Meta: U2FsdGVkX1/59gaebf6ve6hhdGEf+ncrrwhsmkYGcxINi6/rSdwuzQyNetDMQpn+aYOqhJfrrnsh6x3BU2Hon4BbUs9yoa8MUOx0H+ulCL8g6V+tmgQIX+5bkXm56TXiHERlPCBlDJcynQdXOjy6ZlO2csbMlbomZpSdijeKaCOBKaJRmsfzsuqRIGMF1bD+qwkMAVAN7szw5EQahI6QyLpMXw+Jp5SWLjea0fG2IMYXkq/Vi7wyqP02tNBvWg2wmEKYdWqHosfIpgunFo5zPDWlG0VVnzVQgGwMTbD9Mufxaof5GwniiPCR9I8lZJp1CHSyxjfti/jA82w/a19Huxq6Z+Yo2xYsRbHXvzgW+TcIQMKkRg8NTqGsG72femmxB/GyKM9qINFyMItq9wP68TFS/G3aPCqVeu6WYJfsbcbD205kN4WZAeD0Fx6uQxpvIh3UyUE5T7pZIyI511Wb60s3hiv5Q0cqKxsRIYPEt4UOgieCcwfH7pCuiRyg6wVB0FeZQU2Yi1oE9DIkFytpEjeDS6/+QB1bs9WdAe95pF6dyUYn3itZqgnvDzsdc90ckCAz0yGDR2HodLIu9iXmqY7MiKNyYaEhyBmvdNsv0pfxgc4DT0Ft5R5KbvJTbfwvCQKxtuK+R3SIYkiRlTh752eaVUqveT9pILufIMfP3FhWVLTYT7r/d9J7wKVMXx2IR+9UY5Uf7ZAK9+UBjB1MbPL2HSDmzF8gqJDGv9lPnfVTQx8PrDj4PPHe6E5waGw6HJKaSqp9L+N5RwNbDuXNVtMa8jvVj0Khhzy+1jZf/xHvofgbKs4+OBxUzpMqmgCS9KveeQpGTitUNi2pKV3fBzEV7yVvOS0KFo3qzCjIeVnR33nLKKILOn8fpg9PlNiQTTDXIdEODec97eDDTXhcd7fkJ4FpuNe6jDbuDhZT6bDXjxWOXmnEnHBmj3mVhz6JRwB8w0ygRNOSj7q9NUY
 dOTcLw/E
 akUV+GeR4NnZ3v+Gwyku/Zm29mdFJc8+N6P23Tdo/RR0V3oVKEcvJRztbv+VqaYU7NSUPaqjp+/tNkN8TIAWkCOG+NdJeacjM/zik
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

Thanks for organizing this.

On Fri, Aug 1, 2025 at 8:33=E2=80=AFAM David Matlack <dmatlack@google.com> =
wrote:
> Topics to be discussed at the microconference include:
>   - Live Update Orchestrator (state machine, userspace API, implementatio=
n)
>   - Generic infrastructure for preserving file descriptors across Live Up=
dates
>   - Live Update support for specific files (memfd, iommufd, VFIO cdev, et=
c.)
>   - Integration of Live Update with the PCI subsystem and Linux device mo=
del

I will submit a topic proposal for the Live Update with PCI subsystems.
The PCI RFC V1 discussion thread is here:
https://lore.kernel.org/lkml/20250728-luo-pci-v1-0-955b078dd653@kernel.org

Thanks

Chris

