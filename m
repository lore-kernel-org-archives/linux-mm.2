Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AC55D44C66
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 15:55:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1B606B0092; Thu, 15 Jan 2026 10:55:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC8C96B0093; Thu, 15 Jan 2026 10:55:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AAA96B0095; Thu, 15 Jan 2026 10:55:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8ADAF6B0092
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 10:55:31 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 07B6013ACE6
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 15:55:30 +0000 (UTC)
X-FDA: 84334648062.25.8C97636
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf25.hostedemail.com (Postfix) with ESMTP id B48E8A0005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 15:55:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=O2rIC7Vp;
	spf=none (imf25.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768492529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q5bkL3Phvitbtx1bT4hfJIq6tZnmxPD0rFJlAMAShJ4=;
	b=V1pW8ZcPEG4j/aqF1FPMf6YpnN5eNttXKDRT6I5fHuUaya4jCZZnAkRQAopMvqdgEwiCHe
	0KhEdsJXAwEnTOx099tz5TovkYVFFn5LXpcS2aELOvzVKD+StW9A63BSPX9yoDvzLNvHnm
	ephOJkyWB+k1CfaRw8cZUUqBVzDRP9k=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=O2rIC7Vp;
	spf=none (imf25.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768492529; a=rsa-sha256;
	cv=none;
	b=Z2Pbqx/4U/4DoUQlLjb/R6CNVWj37DefTmT6f3HimYToigi2qxYaahP8kPalxwRGRt/jtQ
	Amnt6n4AxV2Pxvo9l9lHBFxiCmVI1f1pH4FULpK+wzFn+hrAqXiMwNbDVVueSDTJY5t/7s
	hV6TQIwpvNYJwlalsubxo81OgepUWSk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=q5bkL3Phvitbtx1bT4hfJIq6tZnmxPD0rFJlAMAShJ4=; b=O2rIC7VppOmyI4NJVqpXeNx1ps
	9E8lXOJndmHISi9czu2yHfSrQTRbYobUU55b39rEMzyDlLR6z+C4bKlMldkk0zKZcDtVQyRXirthW
	KI1r01BntklxKvuUMRRrhgmfBmFnpmdmRgaKJwlaz+Qr95fzmRdU8AMMwVYhCB/fCB/gyfRfTEhdL
	oCCHfn5loLBrr7rjqMykoBHhlmKOfS1Z5lF7LMiDAfY3TLvCDDF6etTTuk+ncZAGMIu/wScOPq3Qt
	ysh0B8nLJ2h3UIs60lSbHici2O7xcYYlHYyatawLyoOOL6mJoOtWjhMKRYG6tjN8XoPCMrGZHt0W7
	BP1PTC9g==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vgPgp-00000007w8N-2zaT;
	Thu, 15 Jan 2026 15:55:15 +0000
Date: Thu, 15 Jan 2026 15:55:15 +0000
From: Matthew Wilcox <willy@infradead.org>
To: "Kalyazin, Nikita" <kalyazin@amazon.co.uk>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
	"kernel@xen0n.name" <kernel@xen0n.name>,
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"corbet@lwn.net" <corbet@lwn.net>,
	"maz@kernel.org" <maz@kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>,
	"joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"luto@kernel.org" <luto@kernel.org>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"david@kernel.org" <david@kernel.org>,
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>,
	"rppt@kernel.org" <rppt@kernel.org>,
	"surenb@google.com" <surenb@google.com>,
	"mhocko@suse.com" <mhocko@suse.com>,
	"ast@kernel.org" <ast@kernel.org>,
	"daniel@iogearbox.net" <daniel@iogearbox.net>,
	"andrii@kernel.org" <andrii@kernel.org>,
	"martin.lau@linux.dev" <martin.lau@linux.dev>,
	"eddyz87@gmail.com" <eddyz87@gmail.com>,
	"song@kernel.org" <song@kernel.org>,
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>,
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>,
	"kpsingh@kernel.org" <kpsingh@kernel.org>,
	"sdf@fomichev.me" <sdf@fomichev.me>,
	"haoluo@google.com" <haoluo@google.com>,
	"jolsa@kernel.org" <jolsa@kernel.org>,
	"jgg@ziepe.ca" <jgg@ziepe.ca>,
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>,
	"peterx@redhat.com" <peterx@redhat.com>,
	"jannh@google.com" <jannh@google.com>,
	"pfalcato@suse.de" <pfalcato@suse.de>,
	"shuah@kernel.org" <shuah@kernel.org>,
	"riel@surriel.com" <riel@surriel.com>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"jgross@suse.com" <jgross@suse.com>,
	"yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>,
	"kas@kernel.org" <kas@kernel.org>,
	"coxu@redhat.com" <coxu@redhat.com>,
	"kevin.brodsky@arm.com" <kevin.brodsky@arm.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>,
	"maobibo@loongson.cn" <maobibo@loongson.cn>,
	"prsampat@amd.com" <prsampat@amd.com>,
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>,
	"jmattson@google.com" <jmattson@google.com>,
	"jthoughton@google.com" <jthoughton@google.com>,
	"agordeev@linux.ibm.com" <agordeev@linux.ibm.com>,
	"alex@ghiti.fr" <alex@ghiti.fr>,
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>,
	"dev.jain@arm.com" <dev.jain@arm.com>,
	"gor@linux.ibm.com" <gor@linux.ibm.com>,
	"hca@linux.ibm.com" <hca@linux.ibm.com>,
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>,
	"palmer@dabbelt.com" <palmer@dabbelt.com>,
	"pjw@kernel.org" <pjw@kernel.org>,
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>,
	"svens@linux.ibm.com" <svens@linux.ibm.com>,
	"thuth@redhat.com" <thuth@redhat.com>,
	"wyihan@google.com" <wyihan@google.com>,
	"yang@os.amperecomputing.com" <yang@os.amperecomputing.com>,
	"vannapurve@google.com" <vannapurve@google.com>,
	"jackmanb@google.com" <jackmanb@google.com>,
	"aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>,
	"patrick.roy@linux.dev" <patrick.roy@linux.dev>,
	"Thomson, Jack" <jackabt@amazon.co.uk>,
	"Itazuri, Takahiro" <itazur@amazon.co.uk>,
	"Manwaring, Derek" <derekmn@amazon.com>,
	"Cali, Marco" <xmarcalx@amazon.co.uk>
Subject: Re: [PATCH v9 01/13] set_memory: add folio_{zap,restore}_direct_map
 helpers
Message-ID: <aWkN4yzwPtotaTeq@casper.infradead.org>
References: <20260114134510.1835-1-kalyazin@amazon.com>
 <20260114134510.1835-2-kalyazin@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260114134510.1835-2-kalyazin@amazon.com>
X-Rspam-User: 
X-Stat-Signature: x3t8dqugc34pewp1nzjrsbjsrao458z4
X-Rspamd-Queue-Id: B48E8A0005
X-Rspamd-Server: rspam04
X-HE-Tag: 1768492528-656454
X-HE-Meta: U2FsdGVkX18486wTdI3ItZdQtkSTiMS80I3zf1b9I3ygV7mjyEP4CjYa0Oxx6n1z3uIXY2ArZSMGVXEFCOKqxS4Kl6uafXDYTcTd8F5cXuo6BZPNGPcIb6hHrAKsI87cAmP5v1WYZCbym5c1ZpGP4wAq5+pGK9gebtXVWJPhB0claiF8Zc33yuoWz+gTCuryVNfiKsAiDmbfbyZBTEUeoivYDoWku60JJm397uvuJpN3xg/hJ3VDHXI5NvYI/y+Oy9yEkds906uKkLRSk75ROydRoTK0fL2VoTiF5qWmhYZzURcjX42oX2vtX78I5ExSYLNdP7Xe8MkAMWsQmSye4CQ/Oebg+ZJ/XTSTtPeO/rUpJ6E5H4kk49+liXT2tY5EKIGeBTL/LYh1+NCvENL/0Cit0fb7iPkfYi9585E3HI6n4K7AgSyWB4PQf2xj2y15rjYNJPR9RmrYNTM6i7fzGqt25wtsVwptVuuJ7BT8kIn1njmkkxsB3pUgVMt7tAkXMdu+Ska3wpKecDrI99gS8C6EXB1NF5fHlq2/DMNA0FO1X9vS1CHIN1KHa7Yciq5Rgn8ouEYif42pT5lBZneWjpNYWT88n861K79uDso+gK6YF09fwfEjr4+iFEr44ygnsw6XhRSKiaTGE0z2hZIB+pDgTlRpSChJRFUsGuvGERhAWfcxMxiGUf3lLhlmgJ8PBlWsyL71j+WqPOnPdKf/uFlbPJo7oq2WzfVQnfG5pvYlyrWOvkUsME5PRdgzTFtsaWEKhwBsv3nkYuIMNI/cRgYlCdlVHVQuh/rR1Sj9kxHH5R2XzIOQzTJ5HHfxU/9frC84AAw9DQ2UYDGRSZrFZkLK+T+vb5CekrdPkdHcr0au7NmL36XPs07fPWM6tLImEtZTavS4LBk21H4XQa50IDTucA1DDOO+iDWiFvLEZ/FDVF/0wjoAqcs8keAhnuVHyHAR4WNv49+nW9bT1/K
 jGkpL8tv
 XJagDVO89FO6qcN92AEhG0yUGJtfE/4dvyhmQ2V7mu0SO7EqVU+VWBANPrNEAmPDuZsXh8UpB7/w9wgLrAeFIerpJpyk/gGph19wnTT/hkwf+PxY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 01:45:23PM +0000, Kalyazin, Nikita wrote:
> +int folio_zap_direct_map(struct folio *folio)
> +{
> +	return set_direct_map_valid_noflush(folio_page(folio, 0),
> +					    folio_nr_pages(folio), false);
> +}

The implementation isn't the greatest.  None of the implementations
of set_direct_map_valid_noflush() actually do anything with the struct
page; they all call page_address() or page_to_virt() (fundamentally the
same thing).  So converting folio->page->address is a bit inefficient.

It feels like we should change set_direct_map_valid_noflush() to take a
const void * and pass either page_address() or folio_address(), depending
whether the caller has a page or a folio.  What do you think?

