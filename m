Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9A3EF4613D
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 15:50:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B0886B0093; Mon, 23 Mar 2026 11:50:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1886D6B0095; Mon, 23 Mar 2026 11:50:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C5A06B0096; Mon, 23 Mar 2026 11:50:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F255A6B0093
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:50:00 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B3CC6140C4C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:50:00 +0000 (UTC)
X-FDA: 84577763760.18.E049B6A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 132D414001D
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:49:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XdKC0tlg;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774280999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pBxuE79q0h/5XA82Gqv80sB/5+DcRUE+NdGM983xYdA=;
	b=OH49hA1Ud0xnsDG9JBvBiHSEqcKbKCYGO3P8q7KZrHBOZ+aIOWo4pVa8tAom68DQlTkTcU
	/qALJAhZc02skN8odpcwX0RDU0J/nX/+cO9UiUvoC+2jCN1+XNgM8Pn1TmdaelY61mj1nT
	8wKRNmIjCibc4LpaCtwo3el9g+S2qUM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XdKC0tlg;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774280999; a=rsa-sha256;
	cv=none;
	b=O76M2w+KjVQHfYworWG0wKoSB2maKYFNZDdfiaS8e6S04OsYTYiu2yv5Yxr0mHBLZjW6fp
	kAcz8rekc8IkUO+KO7MIXYaVYQdgXBVH7UqtYItyXAgNzwz1O9DyvM+2cBDLm3NhYEeAXE
	pkQNUzVH2xOzRAWPtJ78TVS+0+nS7KM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 30C9443D7C;
	Mon, 23 Mar 2026 15:49:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79346C4CEF7;
	Mon, 23 Mar 2026 15:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774280998;
	bh=PE+T0jq3B8ZtYRDz678LEyuTz6jmDPCQy5RpPTYrDcc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XdKC0tlgf1MZ9+nFlKePnzFurNne6QPx1E6YWyTEqc5Cy4/MJ7viljpcXJeeYfD84
	 LwWQhNPsI2I9K0v1c33u+VAYFjbd8O5XNRv7oB6hk9aWRLevlIqBhXTN/OJlKMwQKf
	 P5Vz/q+wIiOUnPmbE+gPP+1XyMVrMVU51S9pyTagqqIblZpcRImI+DCS0rQGs9Ppmv
	 uI4cbcMRaN1v0kgvKPt9I+2sGELYGp/hsRsweEovyazf3HWaMCdkqf89a80XhZaKnl
	 owytQQeI/86OfShIGnWbjgDPLE70BmD03V3uE7cRvQ8417IfFC5O/o3RDSK2/SzDZz
	 cVIvEtMGRKwxg==
Message-ID: <3945a9c5-565f-4126-8d46-1db584b09e79@kernel.org>
Date: Mon, 23 Mar 2026 16:49:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 24/25] mm/vma: convert __mmap_region() to use
 vma_flags_t
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
References: <cover.1774034900.git.ljs@kernel.org>
 <1fc33a404c962f02da778da100387cc19bd62153.1774034900.git.ljs@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
In-Reply-To: <1fc33a404c962f02da778da100387cc19bd62153.1774034900.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 132D414001D
X-Stat-Signature: 73ucfa7fmpu4ynpjhnws7371gpxq6tyo
X-Rspam-User: 
X-HE-Tag: 1774280998-709486
X-HE-Meta: U2FsdGVkX18bUvnEqb6gap/JrWLqwKVpa30AvfA+HTJzB22MAYfA2FtLaSrDJZIIX/yplhTFVbZBX8y/X/kvsaWBHAPMkKN+yxkUPTEKgggcxzioZ2lh64C+tfZW7SIBb3Ij2oE7i1YEhL/IsPv+mBKYRMVVkQSzTMnc0tmWODcCP+6m0BVgMft0VEdp9oLEwe4zvVLWTOS7L4pqprT+KuDr7thZK4nbeYfn+Oezq5jIdKH69fHBKZ/DL/9DjT+6YGtKZlR9LIExUHAeHNAi7LojfGHC2pDmN6K0sdux7GMDRNWhnvembj/NWhiMJY4geEDXlFP6TXdv3VSwacNKgdg41/1QeJIgVEsM1N5tnxHd4Ybd318N6eh0ws5QDjb3i6+wHbOO/uBa0vBZwaojortDG2bBmTD//xTvV1ZTPa26kG8NA6AFsZVduOPpmvQyPoV+oF6nFVS4CeFR17KS8jtoqXz1vyfHjrFenYX0cDA46fl9jxQHsPZE2JC9uGQzoEZyanUYUVKFcDt50f/cFdsUGS80nWhFyfwuBfYYfwDJ+DJQq2DX39Xaa3i3raapI9d9Hdy7uKNx8Z/7jlWPgdePxVLBoBYD7qMtFVHUvsf5H8Q77+wGSavced+1YCtMOsAs2F9pkE0/PnWNZKdXTJImeKKB/A4ckVtJxp/f9RiqSNwAreolZW+li7ZFhs/hQVvgjulZaYVE24FWhZmKUZjExAvjDCz1ZEThrTlSWqm9F82vwlHNV6DsTwni18NDbVeKFWTfCCaB+FMHiR8kAnJA5yeKdjOM+Lpf/Xvf9j325lEp7mSLaa4tjLSFgL2LfYaeAz3mg3MKSALHpMLloiCY+NTD8YEOmlprutjM6YXkpwZ3yhns0ZLMpcBvegy3Zuceiik7RzuuDgxE6IFMzZ+VwIn4gAatVqu+nX2gzTpp3LLeTrX802ln4nTPenmXUgU4Hsmps60Hi6g1lzg
 nmRL1duD
 /pO3t705P3SKc5DzS0Tx9LF7yLcSY3vfOwzf4T9cEo2q/TUY33fdUcNWuhpNYr7/e0pPOeM0jJd1Nibw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 8:38 PM, Lorenzo Stoakes (Oracle) wrote:
> Update the mmap() implementation logic implemented in __mmap_region() and
> functions invoked by it.  The mmap_region() function converts its input
> vm_flags_t parameter to a vma_flags_t value which it then passes to
> __mmap_region() which uses the vma_flags_t value consistently from then
> on.
> 
> As part of the change, we convert map_deny_write_exec() to using
> vma_flags_t (it was incorrectly using unsigned long before), and place it
> in vma.h, as it is only used internal to mm.
> 
> With this change, we eliminate the legacy is_shared_maywrite_vm_flags()
> helper function which is now no longer required.
> 
> We are also able to update the MMAP_STATE() and VMG_MMAP_STATE() macros to
> use the vma_flags_t value.
> 
> Finally, we update the VMA tests to reflect the change.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


