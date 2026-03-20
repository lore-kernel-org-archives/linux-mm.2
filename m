Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EA6C108B8E4
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 10:04:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5EC96B0096; Fri, 20 Mar 2026 06:04:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A37246B0098; Fri, 20 Mar 2026 06:04:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9740D6B0099; Fri, 20 Mar 2026 06:04:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8929E6B0096
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 06:04:54 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4BC3C1BEEC
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:04:54 +0000 (UTC)
X-FDA: 84566007708.07.A1F43C5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7275540016
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:04:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D+ceYj6Q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774001092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rLnu6l4LZw7GzCP4ph/UkgXaEggcROJGe4czPjVlOqc=;
	b=neueiprL7Ch8rIUGgDUyxQhTCZQ9/9Xp1oST+LdbYNunNwatKXy8adRAC0DULd5iKG/xii
	pJZk0G9prxrxVOy0KxzVIfBT/blGghwXsv0HMTHyLe/yyVsYodACaGX5tR6BlJIi+2augE
	hZOxlAr5yZrIVGTEnXQiSzj0MR6DcpA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D+ceYj6Q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774001092; a=rsa-sha256;
	cv=none;
	b=Eg48SAhQhHYtAGLXwmyjxKrPtPdx1i/ysnDHtHGj/XG62fJ5WYBshXjKiX4G1tTyo2PcB1
	LZlUUBQexH9rIRbTb2OPho4W3mA5rO43PIrIdttsJaaHvSbmPvahM9mxO1yZKHK3/KZmlu
	sAwD4NiFo+J5fkltxTw6LUc8ZClgCiU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 96C7D4172F;
	Fri, 20 Mar 2026 10:04:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5136FC2BCB1;
	Fri, 20 Mar 2026 10:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774001091;
	bh=SlqXACEW1bvWaBbKKIpFc5l9X0bOJT5QGbTI1CG7U9Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=D+ceYj6QItOJroZYLEyyE2MBeFVEH6IM75Vi5G/PN8ZodL7Zj2nolMyC/N6rcOzkO
	 gTCj46ngQl60VkkqPpRigcsp0XQiO42A067h6OTJgyefrwGzF90ZZtEs132xst3EGv
	 ke8Hl2sGVHG/IkTdRc9G/zU6xxL8fF4oFp0Ar2N9JRwlsGuLC+7u/6vxBxw09AWcEj
	 wZJweQNUPpvxCo1otppn/Rx/k/XQG4Ouo5iXXkmaQrjxicqq3obmIZPMt/6B5YVhLa
	 1Sl2cxlTleUBCVRG3Iv6gjwGNTfScFbagjQpLmpHaNteEB95xldtKJALrkvf9Y3A4/
	 y7TCZZbtJpalA==
Message-ID: <17a34a6d-8fb0-4010-8318-faca575823e1@kernel.org>
Date: Fri, 20 Mar 2026 11:04:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 19/23] mm/vma: introduce vma_clear_flags[_mask]()
Content-Language: en-US
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Kees Cook <kees@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Vineet Gupta <vgupta@kernel.org>, Russell King <linux@armlinux.org.uk>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Brian Cain <bcain@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Dinh Nguyen <dinguyen@kernel.org>, Madhavan Srinivasan
 <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H . Peter Anvin" <hpa@zytor.com>, Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Michal Hocko <mhocko@suse.com>, Paul Moore <paul@paul-moore.com>,
 Stephen Smalley <stephen.smalley.work@gmail.com>,
 Ondrej Mosnacek <omosnace@redhat.com>, linux-snps-arc@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-hexagon@vger.kernel.org,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, linux-um@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, selinux@vger.kernel.org
References: <cover.1773846935.git.ljs@kernel.org>
 <b2edda6f00c10ef63013257f282cf155fb371b06.1773846935.git.ljs@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <b2edda6f00c10ef63013257f282cf155fb371b06.1773846935.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7275540016
X-Stat-Signature: de5gest3zrcwbt3syyedfgr3ztbi891k
X-Rspam-User: 
X-HE-Tag: 1774001092-572091
X-HE-Meta: U2FsdGVkX1/wPJvm9qvixAOCJwM9SEmkxGFFHerz8pt1mWxRxTMNread3WiXB8CUNZqM6rj+Gu6TCd7/W6bwYFEZyUcxnWi2a8ZS7hUPO0NfCZGx+IHpGfPb4tCozvJAH6Jtcgj+OpyEpHgA7Ehe2VVC2XZtcKKvjSwRqZDtAAZ3YdCw6azrNjzrolT+2C7V/oi986Jz8b4KiPh8LQICwo8Y2F5mSmZ182BXKcnc7kzhb2yMhkFykowr0tTr3805PgxH29UaU71BHYeuw7o1/IePr6ptY8UCaanTTE3kobiKiIJOxnd1SIyasTuxLKCcVA5vJTT/r/6W8BAMXFAdFpcw7FX76Bxoqcd8nagIhgYWqsNHwu1AxO8YET5vstS+a02qXjGmz3Vc2ZFgASMp7bm36RUtHn/HbspL5CQ47TLRw1C5smcnE4Vpu/IxqRVmIB78A4ZOjV3aPY4BcekRFUHAmvcixVO4xqJb2dfmXi2Eiyuump7qNh/+lBSpiMHFMIaqLeLanB7aH/80N/bTASHzq3cmlICjZyAcvNo3PL+sh27eYDDR7wvgG1bKn3NtDEYhOWjOYJO/hNXjDGs3TcHQq+Dlk8pnQBL+pIWIldPKvnmKfGWUeNz0yd3E4Mb4lm6xo+63jxhiINBRvFCwkHyKX3bCtbc6D+noj9jDciGIyiPDF1A3hyUBW2ZlfnyFrI8Q1T12hNuJBpAnDVKo0r3N5QF+gZ0wSw6TgyowUy17Imqq5hHQTVeysP5gg4l40khOTu+4JetxiuvZOMgAUoBmHtxvAjI9NMJdT+Ct8D6M2GPRcyPXdyAHZukDGGN6GqK9PWxfC3NuYjUURz48skddFt3dr52HOIGtB2bEoBjDmgT9OCGW496Fdrdniu2zTmj+wIYYZUv4BfYus/WbTKyagT8spkcHkHODqI9yoQ81gri+k0SDIzGliVMAWgu84Or17mgnF3DbKvLiNrv
 PjfteCOP
 9aG1XI3xHER1TyQsm8RXpzBmYZcAHWAsWq9lUctzU6v9PDzjj31HXjdsZJJUmcfNtR8nWOhStjZzduGPC0ss2pzYgZc47YZBAV5PB4tXcfh93PiyhwgO8ofc6uqWs+sfM/pvewlHNmKJcBtc6KGSpRfRrkqB3CBm8LiFpvjFUWchV5jeWQvWoJPx6W3T4jeF6ldTbsOXjNUCH+Y4c2l8KEzHMsu53vMPcPHk6l34daBQ/vB1KIAYWTHvGK9wF5V7EL+2uKgakFKsRJfUH2sFB9zB1juK2gZcpdhLIp06AjMMAEme6gmeMG6V8a/xRZ/nqNVi/OOpvCGy3JAFlLP9ADZVNnnWGbxuIMP4yp7c1sFA4bn33Gf8n2QTwtyya1TxR/cYXU5HV6hsaIuzkyYH0EHxK2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/18/26 16:50, Lorenzo Stoakes (Oracle) wrote:
> Introduce a helper function and helper macro to easily clear a VMA's flags
> using the new vma_flags_t vma->flags field:
> 
> * vma_clear_flags_mask() - Clears all of the flags in a specified mask in
> 			   the VMA's flags field.
> * vma_clear_flags() - Clears all of the specified individual VMA flag bits
> 		      in a VMA's flags field.
> 
> Also update the VMA tests to reflect the change.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>



