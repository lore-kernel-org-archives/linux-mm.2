Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 956DFCC6B1A
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:46:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C7826B00B0; Tue, 13 Oct 2026 11:46:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 778566B00B1; Tue, 13 Oct 2026 11:46:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6427B6B00B3; Tue, 13 Oct 2026 11:46:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3D1F66B00B0
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:46:53 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BFD411C47D6
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:46:47 +0000 (UTC)
X-FDA: 85318030854.09.1483046
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 00A011C000F
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:46:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=X75FUdGM;
	spf=pass (imf20.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791906406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JeRaURUo5EbmMLuGd0BOhxrctGp6NHfz84lMXFt/WCo=;
	b=Ho8BAp2tZC1404jSCzqY48ksby8HIpu0xt/1AFOv7fVgsUeC1dlT2q/bT8Tl8ihHQAYXP1
	KgFFCemE0NpRfYjk233Ac1rVWACfTPBDUsxhiGpc5zk0UyFlCUwe5GbNcpAT5giebjQnUT
	thiNnVAt5l7S5juENLFRIkGfEpnTuXk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=X75FUdGM;
	spf=pass (imf20.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791906406;
	b=etPzt1lQDv3OJLdTU0ryX4lOkSJ1cCBc9MHMS2Q6KsMymxaIYRxqD14xT/9gqrKTl5Q/Jh
	giDAxT3dd8Nq5RKyPkMVYHqWwKwfJE9Wj0LdAq57mIudF0icqffR/Ov0ePgu+ULG0HZlCk
	f36yN6Lj2lItrhSACblcQXUlwZ0r6i4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D442A169E;
	Tue, 13 Oct 2026 08:46:41 -0700 (PDT)
Received: from [10.57.13.106] (unknown [10.57.13.106])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2D4FF3F673;
	Tue, 13 Oct 2026 08:46:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791906405; bh=JeRaURUo5EbmMLuGd0BOhxrctGp6NHfz84lMXFt/WCo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=X75FUdGMBAZYYdPrK2BcgKxQkWiUuX/Mev7U3QTFrR/D2ZaBM94pw0qWGcNhIsrhi
	 HNgW0pdzZ0TS8JEbWeGOyWyZ+WWETzZd6VBjM69GJs3SFC+HdmB5a8oKbOxUfqjRFR
	 QT19CD1NHaJSx1sqnq4l1v9tXFIlJQAsH36l+TS4=
Message-ID: <9a36345e-5301-4636-aabe-557d923e61f9@arm.com>
Date: Tue, 13 Oct 2026 17:46:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] arm64/mm: fix destructor for unconstructed hotplug
 page tables
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Dave Hansen <dave.hansen@intel.com>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?=
 <bjorn@rivosinc.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Muchun Song <muchun.song@linux.dev>
References: <20261010112457.49485-1-songmuchun@bytedance.com>
 <20261010112457.49485-5-songmuchun@bytedance.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20261010112457.49485-5-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 00A011C000F
X-Rspam-User: 
X-Stat-Signature: 5e9m7o4r8y4j88519acgcoxqk9hxkpan
X-HE-Tag: 1791906405-777783
X-HE-Meta: U2FsdGVkX1+scbxEwrNA+tLH6s4qBmDRPaZJq2cZpSVKdDLnFU2/E3/n+Fb89u+3tbk4s627LNtlhA4Kxgg55nOvFOSgj0jaUPIGDwLOmrVlq5fxIx9k1Vczt6n9PSpbmBBLKsJ9Ovxve+ixLYW0EcVzs22RbWB6KtbzlLvS20PGZ/gG70Kz59peh39bnN8+qeKZcOZK3QqVEKEJF+VISM6QjDvy5PNrvo354Ei5aF7JBH6LwwP1k7dXMBGNYTl4VQz/nV+9rjh8oOFkqTPF8+Rf8Omlr/GUxB86yjzLEG3TL4NfAdLrtTgn0ft+Kwumodd5/ZlLW7YTGAfeKA1BF36obR21tdoJmoVJ0ueXPy6EauXoDNYBMmeVx+iQF/7iAIrpGk43ehvxak61IxrB20S152Av5AZQHQXq14pg2UXmFj2EcuW3yGi3/iT2bI0N3eL0C31i+1eC4BXMVurO6td6nc4IhrtGgTHujKX+vf2yFXymG1TyZVLnyX/5uWvIT7KpqtKKS3AQKZY5V2Kl5supet0NAKRVABAPWKRbkKFtvhzmaKzXieBdfAo8Mq1mB/SHIcsuhOObpcSFAPfj/0AwsmwveHgUNrZZ3eqfKAsNAJeBo4gzaNcZqs5b8zia3XRJR4PK8yvCjpIcZTk8z87VXInoyVOymi0AGJ4EuqptiSsyoZADQWYGuyobWOfbpu3+JnpPDOxI072ZbVjIDMvNCdwwUw1oh3Ji1oASgPvchnoJMIByOCyxhz/B7R5vLeKMf8FNVJGtUcd+utPusSkDWP8RlWXJ3jFkw0rLNZeQGXOk/THFNm76bl+6DtOBkWLmi502XAyNNd0BKYv+kgR2SMLi1b0wqEpxAfnMOoQeW/gmiB+J07vdMmDC9aWtlPELp2VDBCoqZmqiROz8G7xyGGJjsgvAvNxr9YHR5h5XaGp5H3QJk8srn1IIhPbTEOmPH2pEuuAn0MN9HLm
 xdRCi90D
 rdEQ2jc4Nt0XXLDMQmn0Q55nl4DcGHuLtg5VEbb+ltbZrUEXdITa3QkylePZ0BFn4LTBtFlDl8jbUeRzplZ2BIYu9SPaSpeXWrlrwZUjeHPnR+1NUVCEYvuPL8BLDcrEpV+rdArikMnyic47fIebIGdpELe00KKGUADYUwSYdOrScpetrGgL1/tkRnLB+V9ftNJJv03Ga0ORMNnuS4UZjFBSkfhOTKNpdiE+E9JFjLPKjCXSbtTsCT+/68s/1dFwq/8uKYlscyj822bBtJINuJhYp32cYsAZN53MPDFNJu7Dd3W5Zy5ej0QraJm3TIRL64d+y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/10/2026 13:24, Muchun Song wrote:
> Commit c594b83457cc ("arm64: mm: call pagetable dtor when freeing
> hot-removed page tables") made free_hotplug_pgtable_page()
> unconditionally run the page-table destructor. This matches page
> tables allocated by the arm64 mapping code, which runs the
> corresponding constructors. However, arm64 also uses the generic
> sparse-vmemmap population code. Runtime intermediate page tables
> allocated by that code do not run a page-table constructor. Freeing
> one during memory hot-remove therefore runs a destructor without a
> matching constructor and corrupts NR_PAGETABLE accounting. Free
> intermediate page-table pages through pagetable_free(). It runs the
> destructor only for constructor-backed pages and then releases the
> page through the page-table freeing path. Fixes: c594b83457cc ("arm64:
> mm: call pagetable dtor when freeing hot-removed page tables") Cc:
> stable@vger.kernel.orgAssisted-by: LLM Signed-off-by: Muchun Song
> <songmuchun@bytedance.com>

Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>

