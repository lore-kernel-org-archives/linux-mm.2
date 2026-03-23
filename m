Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B301F4613D
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 15:51:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D72FA6B0005; Mon, 23 Mar 2026 11:51:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4B1A6B0088; Mon, 23 Mar 2026 11:51:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C87E16B008A; Mon, 23 Mar 2026 11:51:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BA4906B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:51:58 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 534BA160C1D
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:51:58 +0000 (UTC)
X-FDA: 84577768716.13.AEE8ECE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id AACD1A0008
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:51:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o1THjGW8;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774281116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2+P1LJbOhGaADXr0borEizC7CpTJv3YbpsxtYt/vS4k=;
	b=alPmF2WMeNOnfgw6zcWamU3k6OtVwQ3BmyEwSLq+J75cV1t6BWVKMz4bSLU9azvqY2co+1
	bOfPBjJ3hq929k9FtBeia/uKWfYmH8Sgx9TO03il7cMO6TpfcpF6xw2i/nWj8u/JxXNk9W
	VOtkPomMOeremxcMCsewoiRqEq2025o=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o1THjGW8;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774281116; a=rsa-sha256;
	cv=none;
	b=DkfRltsv4fjGLX7Y8d9hUcxmxOlmFkpWLw15h3uQIW7lIYhlXiD+Mn9ezP3TYJFIa6VaRu
	Ar+gzXv8OQ1DuGzIy+Q/BxVpR3llqlT1pv1QirvOnRSqgGgvxER5/DHzy2n5/bL7RXM/4q
	uT2mnCbYF8kKZNwLbbLBag8hC3NqBik=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EE492600C4;
	Mon, 23 Mar 2026 15:51:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCA5BC4CEF7;
	Mon, 23 Mar 2026 15:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774281115;
	bh=vZdm4GONA/O1jK4+M6185Q0giqh3AS1i2sFB5Pfd/2Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=o1THjGW87BBZn2ZRvUB/ZbG6Bpk46OGuXu9+rNxgEX1JPplRd0PmhhIVaepJQX2x+
	 tNfnZZ2oJ/LEW/V1kb+Kd4rSlee9+4uD+RKeGWfnc/xNRMj7aASQw2bbJQ+4aFpnT4
	 D5oU71wAa1icX022onJ8SXq1egN+wMrKLzs0GkJXDMxvnSocAjVWuUsitbcyyxaQfV
	 JJXP9c4lBWKh9RLPX/Xy30cKFsVybbnBnhAp26jeybHA0vntxV0OkXb/w0rzQv6/lE
	 VQ33MGCeDpT2FONGoMZBv7aFNGtJEznzEExGGKYXFQSBLYixZR0A4kZUSTFL4AAduW
	 zfBJEYhpa4mqQ==
Message-ID: <47f796ed-ac66-4a75-98c9-64afc8929f35@kernel.org>
Date: Mon, 23 Mar 2026 16:51:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 25/25] mm: simplify VMA flag tests of excluded flags
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
 <d395c5dd837a9864f5efcec42175910afbe3ce73.1774034900.git.ljs@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
In-Reply-To: <d395c5dd837a9864f5efcec42175910afbe3ce73.1774034900.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 4nxgc7opdtzhjcfbert77e8qxd7aefox
X-Rspamd-Queue-Id: AACD1A0008
X-Rspamd-Server: rspam09
X-HE-Tag: 1774281116-102545
X-HE-Meta: U2FsdGVkX19X5gvsKZCuxyPLi3arb30onlI+TcVmvztExZ3Gz9VGkxgMF4hKit94j6uWqTUJ9B7Ji6BiEpGJhk2nDzfUneejt+KEiuPjaN2nLalY6moDNsbYJpNRsHIWqwY/69VhNoMOZ+DTcrFRjg5jPJgHdRynMuPbcBb1K/bI2vt/CNIBjlmIti9MLjnd9qXV5I4wR3YNVOtUuTAgMpTU70+VbX5KzQM6kG9L57+VSYSfV5VcOV7YXcUW+roMtiLmKU98a5/RMQcqiqISmZBD5fv0jQDo0qy6VL/8YKTS/NijDw/U4zKa6TZOkpXyUOQAgO5oE4FoF4gyoKxmT6BbW6nUHMw+GS/1eurF4mfOnd92wBg/H1G90vlvVr8xmEDMgUnZ87UpNo1R0g/v0NoT+d20yNi6V98ZxUTEg7rJg1FiULkfRhV4prVak44Bgy4czpcnIWTrD/M69TZ6cxiPeomV46wC73IF6T6Iw7wbc2hPHipb3hk/Zv+1VtTcY2xEBqb3rV5iQS8n/tDQCOfK0sj6nJDt5mq/LqYKY0WZpP1muplnXHlFuSw0/nPcLgPBzN5MUKB1G1yUZHS/vX0LUdWAWRcfN3JZ0GaWuRmMBtd0Cm2fE3ehCkC67L+5QDcu/26MWwulh5ZzyolqlLQ+sjlT37o2QYpu0aUYcMnpUbRbc1TJfZt7tL7v2SIuYG38QlUqglWhQuNfQb8hU66X7JtlDfz+yxcLIMdZnWy+OYsJauXFT2dUAnOFB4brSKwnarxqcYF6ZDFq8dImvGffqZ70qVOB50+YeADVEhju57yi9KB4XmqjJwTBFSDTMhq8zdlPSqqDKXSPpPC9P5RYpXSmKMHI1FlBbmQPsknR9eUAU2nmqTzIJDGmT5YKYPEE2cue0GfvQLPZUdtDdk4E5d1DycY1r5robh4n5dC9jrXm8Ozl5JKkNGU+c4B7BuKthBm1YXcOkUSqbbO
 qpn3dWjm
 MM5XwgEWf/eW3A4Paw51AljnJK4uDrPSDsBe2176KmH9+i0sulUKeXY3UhIcfDuHhvII7X52PrrY8mt2242PjoNy5qcMwEXtPia/UoYLAd7w6KUyPS8/rKlnlqDeGY7ZKBXQBbDrQ6eG9E9ZoAITwtiqpVHXS0ZTBNBL3WApS1UJS9A2rdRdW63nwSUBBGYtzXDkaMytdNtGEM8NqUlScaSieCT34OZuT48bteMeE1+ytXWoMj961aXltfUn04Bk5OUvJRtactYlNySYma7Z0H9gkvHhkt/+bNtQeJVRyqzEB9zn3JY943/kRAfrkcQBI71WQHS/UiTO/JbaM0qjvXiOz1MvylVuYbk/8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 8:38 PM, Lorenzo Stoakes (Oracle) wrote:
> We have implemented flag mask comparisons of the form:
> 
> if ((vm_flags & (VM_FOO|VM_BAR|VM_BAZ) == VM_FOO) { ... }
> 
> Like-for-like in the code using a bitwise-and mask via vma_flags_and() and
> using vma_flags_same() to ensure the final result equals only the required
> flag value.
> 
> This is fine but confusing, make things clearer by instead explicitly
> excluding undesired flags and including the desired one via tests of the
> form:
> 
> 	if (vma_flags_test(&flags, VMA_FOO_BIT) &&
> 	    !vma_flags_test_any(&flags, VMA_BAR_BIT, VMA_BAZ_BIT)) { ... }
> 
> Which makes it easier to understand what is going on.
> 
> No functional change intended.
> 
> Suggested-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


