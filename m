Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DD87F327C4
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 08:40:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B1986B0088; Tue, 21 Apr 2026 04:40:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 162166B0089; Tue, 21 Apr 2026 04:40:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09F856B008A; Tue, 21 Apr 2026 04:40:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EAEFD6B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 04:40:43 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 95449BD576
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 08:40:43 +0000 (UTC)
X-FDA: 84681917166.08.3D14BB9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 776C9A0006
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 08:40:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="m84g/SYw";
	spf=pass (imf15.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776760841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EgumEJfrYaLcloTARpupOXQw32PxC3gb23jmLt56KT4=;
	b=8TkZYYALDgbu5PK37DkVJ23P05j7ue7TUoIdVNM/eV7QnWDnocDkROl4hFnXttOhcikqmL
	U8f2UGn9SkZnT49uAk5a1nimu7S9gD+xD1lvCojRO+qoAv0pLaeSG7JYBUokEQ5YaRCBns
	9L83TN2sgiFiSTdAEibsKkyWkCWt2Ls=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776760841; a=rsa-sha256;
	cv=none;
	b=p1opUJmKIvRE7hm0BGqwndyTKr06ZQdgH6jtuGFrvJuDPOWXv7V1spPBdQu/ToDjXazZ3/
	X70wGEgchBDG9e1cyhhxVfKvB5VODDETvtfHCUoQzr9x1AJXywDnsrG3/W17DNXbsnN/yP
	iaRgGqRqadQQCR3xJw9TEbcKwzzzOQg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="m84g/SYw";
	spf=pass (imf15.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B260925E0;
	Tue, 21 Apr 2026 01:40:34 -0700 (PDT)
Received: from [10.57.63.119] (unknown [10.57.63.119])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5CD263F915;
	Tue, 21 Apr 2026 01:40:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776760840; bh=EgumEJfrYaLcloTARpupOXQw32PxC3gb23jmLt56KT4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=m84g/SYwoTZLaSaOqMPRRzbUY3MObVT2M729SpYBGr2MyrPKhYR9E74+K6sjJ0Vbw
	 LF/PIYYBuV86V7ZYmhOnDeRF75EDyFh53WYU+XEu+I/4m5IQOMasOzExjCvFK578q9
	 3wBS81X9Rm/vbkwxQAHT4CFnEaGGnv0jl9C3AWnA=
Message-ID: <566e7e6b-17be-426f-a3f1-a615d0d61077@arm.com>
Date: Tue, 21 Apr 2026 10:40:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/6] mm: Make lazy MMU mode context-aware
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Claudio Imbrenda
 <imbrenda@linux.ibm.com>, linux-s390@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <cover.1776264097.git.agordeev@linux.ibm.com>
 <8809412aaed8a515fe2e149c822543d640060936.1776264097.git.agordeev@linux.ibm.com>
 <4dc47078-0f8b-4388-9715-744c18590a00@arm.com>
 <0dd3a5bf-a98b-4181-a88a-ec9c0203f90a-agordeev@linux.ibm.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <0dd3a5bf-a98b-4181-a88a-ec9c0203f90a-agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 33szhdx847gwhdiij8bueawitmwq6oak
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 776C9A0006
X-Rspam-User: 
X-HE-Tag: 1776760841-179770
X-HE-Meta: U2FsdGVkX18BYjQh49rmFPuPuUqkkACgEpoCVSxxq29g398Mnyon+U64BtUAVxKNAn2W2sBeIJbxTBNA/gu83LkZysPLAdF9GftjtM/7rL3QyY6isRujv0zw23oy4ZCAwUSNQfcPxBYOLO3BaN/NBf3J+tbhKFSJe5fPaIbKv9S//rXOPPlDkASpjowf46akx265RXBBIejREpR80jBvsls4ayEFsl/+gjthuXqVfnKKtqFUejJVG4tDMfOrnIILkPdqgBepD6lGfWMIfMryXsaj4ICWipNU2QVFpYe6CV/15f3rXsHzrGmoNs6Br91Y0h5Gcg0mFj7BJOEzU698K7gLyRhewV54S77Xu4uh9NGWASv7xXyM4yLXHOpKsnkGsb82PdFQ+91CpFNBiR9iqE5r/+nzIv/ncxCDVWRnLGfe4abVh30CFlxKOTBc0aNShaH378EPW5KHYFq2fJhriFr55lEzVCXA2nCZd4XMto9HPdyh0f3JHIGeN/o4iZA9m2eoPUUzPUEowTMpvi+ChZzieRCa6EoWf/wJFIQ3iljrzN9IVrVUN6Gbq4v/K1ZX+j5aCKOktGoElSGO7a3QkIWvGx7LzP5X8vTQeZJuYh/5GPEPU60NgGNvkJSRfIhp+Gy39d8orxKCkBAsPcNZjDyZG//fAZwA8UJiRb6OgdNg2z0GTsCM5G1DzfnPrS0WtKhltSVPlmbWVnvcmbkM1LtZPAt9zevLEQhItFPXwQg7Ie564eEDUrCPR7Qq4c0c0xeCwsiAZezaX1kgn6oEO+xwfPZ9HEXa7ecXGkwq0aDb/J2FuzEpJ2K2PPCsBhz0rr46gzNOlImiVryGDPFvPy3D+J6NsbyEPAr/reLGIpUyQDNsGaTwOVWgEpBEFluy1LOxsS3hCV/Sm4zXJRhbaLHnh4Sc1kjmNAhm53gZojYLSRi5C6owpGtqQsNGMhRf+dy7cwjfCHx4hGR9h16
 kj7ppR4c
 anKmQYYwFS6nFTTa/LbhrFMgV9py2ytpqsiC/3ZGmlSXUYMWNw4IIOSpqBTqtFkQg676YhCTHSZppFF1B4TxBOa5IMIo2PKRhMv9u2pC147dg+p52oJKpq74zUKnFi/rmlCvgS0uQNkcE8p59Wv9wdaZ7AdrY+YiEsKvI90DHd3R1NPVwF8Stu+V/ewQmmOQgr/EqjcGTeyF2qAk/43vkLLPF60k8wIiWEetV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21/04/2026 06:57, Alexander Gordeev wrote:
>>> + * PTEs that fall within the specified range might observe update speedups.
>>> + * The PTE range must belong to the specified memory space and not cross
>>> + * a page table boundary.
>> Does that mean that all PTEs mapping [addr, end) must belong to the same
>> PTE page? I think the wording should be more specific.
> I tried to state that end of the range must not exceed pmd_addr_end(addr, end).
> Any of these sounds better?
>
> The PTE range must belong to the specified memory space and ...
> a) the address range must not cross the parent PMD address range boundary
> b) the PTEs must belong to the same parent PMD

I think b) is good, maybe "PMD entry" to be even clearer.  My previous
suggestion of talking about "PTE page" isn't ideal since some
architectures have page tables smaller (or larger) than a page.

- Kevin

