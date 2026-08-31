Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E0B8C61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 06:49:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 637D66B008C; Mon, 31 Aug 2026 02:49:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E7C06B0092; Mon, 31 Aug 2026 02:49:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D7146B0095; Mon, 31 Aug 2026 02:49:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2DBCC6B008C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 02:49:22 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9AC6BA14BF
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 06:49:21 +0000 (UTC)
X-FDA: 85160638122.16.B8A3D78
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 937D240002
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 06:49:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=U7FcIb97;
	spf=pass (imf11.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788158960;
	b=lsyHEhXCZXoIHhe/8Uka6OJ492XqD4eOM/9YjLNW179jbXR4BeHXMcjiJIhaasOAItday7
	3mWjntdMNovxTwMIiani/OR9Gd8optqo6Y3WhqcTnhyZqXQcGhFFJRLK+xneoVCgoe6GcJ
	IdYHAUfGgGGF2rYzVPz6qDQZAUIa6e8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=U7FcIb97;
	spf=pass (imf11.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788158960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/H8XwUq6/bROzHqqhxbKEvOIJlS9kKt/F3AGQnb3rVI=;
	b=3S1QfeTRLcFsUdDIBPon6lUwCerDsPM90oWpqopNsnv/lhGBampUt3XSljigsOY8nS1iQv
	35oQ4O9oWpD31Ye24zvvJWhy6bOjUkNPjYmNS95bkalmAQZwofXeYHl/r6c8b4lQVal9It
	cmueIZcvL6KwUdQOeqBAFkFzisE68C4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B591414BF;
	Sun, 30 Aug 2026 23:49:14 -0700 (PDT)
Received: from [10.164.18.31] (J09HK2D2RT.blr.arm.com [10.164.18.31])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D75643F8C6;
	Sun, 30 Aug 2026 23:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788158958; bh=UzZgy0NWc63K+ko4Xr6TdOnwA9EjAL5aleqBNdt6jY4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=U7FcIb97JDEewur9Kf4radnvfeDHm6NiB7P5FNYX6eqEzgaSbcLTTz2427bXHEGdQ
	 uo4OFurjcGsPFnWvC+QS8s3MrHKwugc62Aj4Qy9UerHzl+ldPYjUgyGMq+omakELHp
	 zDbAViiLJS8zWjabH0UPjbR/p9ivvj9kKzLGGkiE=
Message-ID: <8ad05b11-5cc3-4682-b921-a0c7820b1f97@arm.com>
Date: Mon, 31 Aug 2026 12:19:08 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] mm: Drop pxd_ERROR()
To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 linux-mm@kvack.org
Cc: samuel.holland@sifive.com, David Hildenbrand <david@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Yoshinori Sato
 <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>, linux-alpha@vger.kernel.org,
 linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org,
 loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org,
 linux-mips@vger.kernel.org, linux-openrisc@vger.kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-um@lists.infradead.org, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260831054331.625505-1-anshuman.khandual@arm.com>
 <d766413f91cd778912f6af372d3d5429bac7765f.camel@physik.fu-berlin.de>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <d766413f91cd778912f6af372d3d5429bac7765f.camel@physik.fu-berlin.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 937D240002
X-Stat-Signature: pt9iybbi9ji7w1b3xx87bpndr1autwtn
X-HE-Tag: 1788158959-627155
X-HE-Meta: U2FsdGVkX19CaDBHhbjtopmQYx5PuXk1OMIZ5v8CfbmvjZnJF1QP2gZ+zSBvFvCafGY6wGOadPAeHnilC+ms17fYKWkpJPDmasqY4VCAg2xHsltIZjTRupQcB24WzSv651mGp2XXNGmbE2cFPJwtnIlaiIkzflyZSz+DjHdKhVZ/WzvKOB1QtZ+wm4iXkEod6MrbEBnK0EGlNTchQ55YLMgWyD3S9UeeAty68Pa7kQuo0assCGcP8WpxCg+bSpTw6vBKV5FOlmukjl28DUOEbBGjNSI8HW7l3Cy4FcBp+qq+395T4s5O22t4Q41B/Et0ziHD8sCKsqIQKNiSBhX3Wrn1qT3bxO9uGnzjLYPwCkeN15TWW4vYQoW6lck5/wf0VpCaluvRv/S2UKezzdV7C6SnQDnabCHvtKQdePDalevNjeC68j12pJbB1DgC9Ys2jeJ+XSXBnm/j97RHtR1CLTEE7YbchWIoYqAAxO1Mz3INTxd7khOhcwKEct/bnuw9PSRqkWa5ozG4ooA/sRg+ptFCl41/iU8/5EHyn43sPrx7GSHFbNItXIWWCkEDHpWIx40YLmZemTrE6fvcUwKaxjcyqkEZ+8JVii96Sru99IFeoMLgdzpZMW5uEhZCq8g+QbEr5e4HVjaYMNbqfyCx76h2fe3SqJjnx6jDPUDWH/I7/CRjC5LfGSgIDxWvUzhV+j/uctHi+Hef3oJJ7jawK/5pNIMc+oyzkXt9OP2EAfbF2wF50Z1yCDGQDtL/jR+9lHd/QEyP+orp7qYIpF1u4exEZViHdmHGxAEgk7FjGYfnGZa/zpgzuojGH4uCKoRfeeqpVwArH4R3WUijtLXQ7F7kS0RHJe15vAPvyE+aXjC5lRXERyOy8ZG+EqjBvo9kZ0N6nkxrz1DOGL5mS+uxRpbQ9u4PkrRNvww2IZs+gKloa8zMkyFOFxUHFOI7y1U1fKuBy6l0IjtK4pesYuc
 eKW4oM3B
 oLBC4Y4T+bKbXAauT3ywkbdKbM2AqYcZlv0Mb3QqVFPkcntiPcDYQAuAf6wFaJT50hlSsJySyBrh0GggM7+clo79yrg1q3QNHTG38f/HJSvMf5UbcNbd1Zq7k1dK59pZCdQniXfvs5ovBrjtk3Nj8Po8MZ+GxDLF0u4HX4eFEVad6Karg8ngB75GLMnUpo+o2nmLgcoApUCdLdW2ZfwnkRLfOcT/0kfLbpIiMJego6HjwHQWmH+VUekp5RX3mTs44LvaSjmhLixdyQRD3ZzzwdIS3lrydkHULZkURNoNAU07WyIAqlxi0e27eibgb3xgHTLyzeo8n8HbxA+ki1XKIaHMsIi6Lf1P4v5KHlb5vTZW5fiw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 31/08/26 11:38 AM, John Paul Adrian Glaubitz wrote:
> Hi Anshuman,
> 
> On Mon, 2026-08-31 at 11:13 +0530, Anshuman Khandual wrote:
>> pxd_ERROR() macros have been provided by all platforms, which are very much
>> identical and can be dropped off completely if these pgtable printing could
>> be moved to callers in generic MM aka all pxd_clear_bad().
> 
> If pxd_ERROR() macros are really all identical, why not provide a common definiton
> of that macro? I'm always a bit concerned about such changes as there is always
> a risk to oversee arch-specific peculiarities.

We don't those platform macros any more after converting generic MM into using ptval_bytes_to_hex_str()
which now handles different pgtable entry types.
> 
> Adrian
> 


