Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32944CC6B1A
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:46:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E5646B00AB; Tue, 13 Oct 2026 11:46:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BD426B00AD; Tue, 13 Oct 2026 11:46:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FA046B00AE; Tue, 13 Oct 2026 11:46:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EA6FE6B00AB
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:46:32 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6141B40DA4
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:46:32 +0000 (UTC)
X-FDA: 85318030224.23.8F1549C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id B7D731C000E
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:46:28 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="kgXLF/sO";
	spf=pass (imf21.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791906390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eMq2mDhfJOst6GyLz1Fcuo6efNgXRerZYOqtWjNZhOM=;
	b=0v+ySC38+2djoZgzRPSR/Xb4bSX8Ywbk/TJDB7NiL03RctSGG0+f+51PTPiHJ6aesjQXur
	k+y/EX1DmNLAUy+sgYmwt8yHMmpz+pS11auxtf12aZRXHeICI7n5H/+MYwMKegNSKvRrx7
	64nbRyyreZVzVOsZDLIzk7xGdWqq+qQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="kgXLF/sO";
	spf=pass (imf21.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791906390;
	b=UDbNjVIE0drMu/M70pHd0aiK4CCzcKeZHQ9xXv2DEoGIKx4CpmkjYr3Me5FLSu0D1fwSq8
	TMxI5mFm2kz4FKPVx3KrO/fWp8xNef49XiUSlT1zq4GzGEALVq56jlJnnin9H+k5YuT4RX
	qOJyAp9c6iSUgpP+2wvpwFNT5iUIawA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 278D7169E;
	Tue, 13 Oct 2026 08:46:24 -0700 (PDT)
Received: from [10.57.13.106] (unknown [10.57.13.106])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CE6DF3F673;
	Tue, 13 Oct 2026 08:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791906387; bh=eMq2mDhfJOst6GyLz1Fcuo6efNgXRerZYOqtWjNZhOM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kgXLF/sOnmA/PaXP6KqDXjeIIPMuJW8hGp/vG4LTJIbgJAMKEq+rFi9KOnkBxr2Mp
	 bkt1V8H8Xs7ERmZYQ5D/uHy1DT8Mz3tJmtmFa8Gd2DjouQowQllwPE6ZsV7jtWw/y4
	 j1YlZw8422v0Rx693Qyax36zmWLe8F6JxZOz0ID4=
Message-ID: <d63f1f76-5bfe-4206-b6ce-189d6948a909@arm.com>
Date: Tue, 13 Oct 2026 17:46:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] riscv/mm: fix hotplug page-table destructor
 handling
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
 <20261010112457.49485-3-songmuchun@bytedance.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20261010112457.49485-3-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B7D731C000E
X-Stat-Signature: b89nyrh96146ixqifnisgqkfyqn191u9
X-HE-Tag: 1791906388-985932
X-HE-Meta: U2FsdGVkX1+hyy+FG32i4dJx/ORbrQFZTzZJCkbcbRTcijDDtWe/z+BHMJIJGGzUCFjgTkgEFkWhB6vMW7dolKf/TyM3oIrElcrA1uxpYzdM2LTBhlwTTiA+WFeGLgDR1X+KEE62RmXX0krd4LbM3vlkw3RvQh+Hw81QGgokvUgKCmTB8i7kwi8PC4QM/D9zDssZEjwyfltUeleX8IORApfFHqQDjU6X+P2QtunZM2TunoLxch/hFLklofwPyR/0CPrcra6E6VhvNhfraZZ0w2LMCB82tgZuh7GWrMB0Q6F8B8E5Y/EZZiOVnKSxQZiyRmpnAwwvQHXXUJqeiFbxYAuIAUHZY9ofRW7l4ejSpYNZZINu9WGZKWgmA4E/+XmUwE0lhK3/Vitx1YRjWNMAwHhIFiWpVmKPJlgBSUhD6pSIJPrBnJNQBwNiMtMaUWXwBDVX0rOUIOGFTJCa/nVHtxApvNwzehpx1in6OSAXsKauOgjD8diTbyM0tnQI4Dke8mgFmxensva3Nbu375cBJi8gtrSB9hbhRsOzwhZh88IgkprS37hsyVyNjwm256RNT76wEvGIKCmasng0kvvJyAGTEAnjXeajADE4YaPjr2KnBSwSH0EsfXUSbxGsyuj66A2yoR/4vvGcQgFugEGCrr+5UvvMvDnGsqb94T8hv+PVR77mCaDyVpxYM1jbN+NleyGt/n5smFONp8+XCxQBoxYbeegOTxGd0YiIgXBF6dsHHonHiL5AXvoz4P4pROweIxkPKyUvZQaOmWE8/Dhs4CU6Zr1RJ/VVKvnFxzjtPI3vq05I9usA29gKueEJguvvAknyLS8zi07qqzky+v7Onwam9OD+kipx5hHKZFNGxt84YB5JGVyRHo80uBoUpCG/0npTUh+h7k96xdMJOiW0ZsuE2eEXsiHunPAxNlnKytvoXJM7nrE3HoB5R/eP/WlzGHyKZ+vkw2YTKefg4IU
 hgdwZJSL
 blIh5vxBcBEvh6EslZvK24XH3073EglEcoF3qRmMqVZmyGlKbIUG8PPBBbs39q2SRLKwqP4rsW8zslFLyR/3YRIH4hMa6QC/OlaTLG1W1n5XPwARQLTCGbsDGvHn2LWEb6DS+xckc0dsZSipRxBNCPeke/os9SeCxYcsr2GmD61lk3IJYjrGhFonPDmwyBPPJdDcpOw3hqR8hwkzfRMIbTm+ZM7N8yPw+T7wb30GPDd1fTvMucYycYBIamb+JiLYJotB4EF55y5Y6sKqtqZ20Ue09tTkqGiOOf9XgawZyelD4ROPc28BYXy58lbcpXGslutcVuxZ19h1RuwmNmS1to2r4kQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/10/2026 13:24, Muchun Song wrote:
> RISC-V uses the same memory-hotplug teardown code for linear-map and
> vmemmap page tables. Late linear-map allocations run page-table
> constructors, while vmemmap and early allocations may not.
>
> free_pte_table() unconditionally calls pagetable_dtor(), corrupting
> NR_PAGETABLE accounting for constructor-free tables. free_pmd_table()
> avoids that for vmemmap using is_vmemmap, but mapping type is not a
> reliable proxy for constructor state. In particular, it becomes invalid
> once runtime vmemmap tables use the normal pgalloc helpers.
>
> Introduce free_pgtable_page() to select free_reserved_page() for reserved
> pages and pagetable_free() otherwise. The latter runs the destructor only
> when PageTable() is set, handling both constructor-backed and
> constructor-free tables.
>
> Fixes: c75a74f4ba19 ("riscv: mm: Add memory hotplugging support")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>

