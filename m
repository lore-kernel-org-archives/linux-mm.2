Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9863B1088E60
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 17:31:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 070116B00A8; Thu, 19 Mar 2026 13:31:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0212E6B00A9; Thu, 19 Mar 2026 13:31:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E51BC6B00AC; Thu, 19 Mar 2026 13:31:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D00166B00A8
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:31:36 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7F7B41606C5
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:31:36 +0000 (UTC)
X-FDA: 84563504592.28.E68DCE1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id D2FD280013
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:31:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SO7vfJuT;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773941494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4bl9t42B4LXiBnZarf9/q3l/mzIDatsBzDzzQR7YZIg=;
	b=DOf4v5hlWV79K1SU67D3/t2ZqpZQYx2hbzKtvclt97YV+NYnI5K2g9CuHgI30CwfI8x2Gq
	vcLCTEb+cNBRNH9f20/3zSIsFK/xZ0C8s9a7il77GstIvoWlqY9Y1i2NpNJIznPwSUYcgr
	b7XtDFqgMkxUkfwRo6gbaroWrsXOqe4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SO7vfJuT;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773941494; a=rsa-sha256;
	cv=none;
	b=8bpcJVrSG+WcjcbaX4su2I2AiubyGS3EXMzp6WIfnqTm8gxvsMFOiNKrNFLpyUi4oPosFP
	QrsPtYFUpuWwvqgVE6n5dtKZz2JNO6fnba1l80HGvcMprOXFcYKEnSit+Rr9qK1YmiUFn6
	LbWrfrywu9W8yzvcEYhrs0ZKaxRvk10=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0C91160053;
	Thu, 19 Mar 2026 17:31:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13691C19424;
	Thu, 19 Mar 2026 17:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773941493;
	bh=5DppXj3QcNzrGmdgZID5IYobrhntHlZzGlg5qMCJioE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SO7vfJuT4xUudvKFdjyC/XRHnDWKzUW5zhPZGOW4NkcLJWB/0zaBAPUZDEbzNniLu
	 o6gtnAQILi1Xg5RGSgTnobL7eO04ZT32Gx2h3qfXV8nubgacMQGFufOtrVHdeNmWgM
	 pZkRzoFA3bJPOKRw3mhQGFNORsomWmRnmNuVBbUaFpZmVyH6WM0IdprCTCpaX8+qFC
	 9GF8H3rbnnwghtEQQ9Ex+hdnihLJcH+Gq6I/Fk+KprdszHQSk8Tg0pLI8axTqiBT2S
	 atwtkQeokLlmSyD0VHX0bighzaB+U0P3innYYSr/zVKdE8T5gI4Lh0EcWg4r+v5cRx
	 N/zcFeNPSI1JQ==
Message-ID: <12bb9812-d7c4-44da-aa57-689ad520cb17@kernel.org>
Date: Thu, 19 Mar 2026 18:31:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 10/23] mm/vma: introduce vma_flags_same[_mask/_pair]()
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
 <028d03f1b980b7f65fcc556db2e97224c06af1a6.1773846935.git.ljs@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <028d03f1b980b7f65fcc556db2e97224c06af1a6.1773846935.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D2FD280013
X-Stat-Signature: pckxaeqcpsaioum5o1wptctmbbyekqoz
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773941494-396943
X-HE-Meta: U2FsdGVkX19jzHLujNHeSfdJqTfJXr8T8cCh6IZcigBFRHuJzgiRmQ1CGwnm9JaV8aI6h3pbjIGMKV+6mKq31QVeFP+ajDC3yUw/DEDZe0RL24xvPrVO4nSBryww8QuHtf5maUNCCiox8DuRUx2lMBqnSMqbSnUPGyfA9abefiF9AbWpcpS+7RMzNcKOXsXEMPNrj/a9/lFdNObvMsst5FxFd+0ZH3dWGOS2KgP0j2xzYwkicLJIzuuraJEdHj9/bWd7VpEFhKf957JkIfPxtbMZtDI6O5pqjWOLpmAJV79Q4Piax15fmAlkkhX981bLdmVn6H7P5CqPBd+yrbFl+X/6UoJypLgWJ/XRAVthny/ZH5pldwrZGxD3CFebOwjRtJlmWor4Uh1Bvz/v0deQdIzmnTwLbEnw1PD60ryT4HZdDCjlDE4U6ASPFfa9YgBdnirwfmZVGmM0cC/wHqkGKR/hTucgW81fZ9/KyfND9qlkTtK2HPTcHPSdDyEt8Aqg2pUibkabGSzxcjdF8ut0tOG0puUNUPdQiJe8LG21KUUL/M45HMhlrKx0mExrL7NSp8OmNvFmrEnc4sIqsDHpi2h72d9D5i+tfw8fYvc5786k21LNbKcxM/uBmvGAVKLpWokJTz7kBX0h5wBc/TiuzJT5lYoDvYa67hP28D1iE289K+QPdGKFUle/IwafOhFrtZtkUXbWF3XuPqVpcpNCcMUTQXtYHzzHO4wdwwVvbPRgQmAscz/ao2M+g7oO/ZxwXs+ROyQQv/tSN18Js0XeEjPT3vvMNejuhbHHnld8VzE4CD/HtBSODTcBvM6E2MxNkSq3d3+cZSgwSlbwm0qZb1ilYtUocDTTvVaNU8tWxj+DBjUIhRjhggMQfXT+Y/fKaya8X741umbD8St9lyQlTuWtYygeX9pX3RsJOlljGV40qMsuLo/Sw8DaMmj6TN+FyDm50lqvtu0/JisHhSn
 UmRsvQG+
 Osa0rH70ds5MRMD8foDOHirTse45lw9XNQQ1fiVkVJL28SpWqFmoa/rN7/FqJfANYBkqniJgb3xkhhSM12EISCZmgwkJq8Y/LvDpsKBaN9c/eFDGUZNP/06R+rg7zR0wblqA22dS1P3li7nFY1pOIV6Krc2exHgGGDKdelCsoj8tibWh2wvleMYt70P6M2IqZXTi9/tt8lQPqO8vPO8YRzwkOPv/Q8CUlHYHBY4l1rq4dPftnuYkK3JeF9VAY1RDouiV18W0xRTSBVs7durDB0aXLLxFVTJK80N1vBAKuCovlKZTh4bne2H9tBDiVVLFti1wkgY4Lfa90Bo9l/YsLbsttmAdzlTyNX69grPgIoDBKHnDeqSYNKsjWzyoE1vpqQaJKg3UOdAuJjcc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/18/26 16:50, Lorenzo Stoakes (Oracle) wrote:
> Add helpers to determine if two sets of VMA flags are precisely the same,
> that is - that every flag set one is set in another, and neither contain
> any flags not set in the other.
> 
> We also introduce vma_flags_same_pair() for cases where we want to compare
> two sets of VMA flags which are both non-const values.
> 
> Also update the VMA tests to reflect the change, we already implicitly
> test that this functions correctly having used it for testing purposes
> previously.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>



