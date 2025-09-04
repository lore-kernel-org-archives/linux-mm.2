Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5FC4CA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 22:14:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E054E8E0006; Thu,  4 Sep 2025 18:14:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDD2E8E0001; Thu,  4 Sep 2025 18:14:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1A5C8E0006; Thu,  4 Sep 2025 18:14:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BC0718E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 18:14:55 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2EE8311A53E
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 22:14:55 +0000 (UTC)
X-FDA: 83852973750.30.4158240
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id DF8D840007
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 22:14:52 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757024093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O1s9lw6tbe2htYbahVRtjD5lIa+YY9RGI9knjEL6DjU=;
	b=e6bapkSSE5pgW0C3VPj0uf0u8fPtza4effUwfjyYobi4nMeKFQsG8o2o7jSTkEOL+Q7Dgb
	0YGKRHsNYvj0U/TACs2vDNAkwoGOBY6a8kT77ZQLaw/Xok6eR7qOjmyf6Kh715hzDQezkH
	Pu1wOFSSWme/L9zlnxrTlgoZXgI0jRc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757024093; a=rsa-sha256;
	cv=none;
	b=QOWVq9kulyfTva8YEerpKwMrkV9ZKb5Vs5eQ+5MWaZcUGbvCgj0a8k+dkyExoQqEaIS+XX
	4py8a6PuxzoqOi90gjwlYVZe0FRYxkFZfjL5B+HQppbCFsZU9O5otQi+8iReRjJcBw5zsp
	O59iO/zQb6CjAIqTrORQKhOADfSjf4U=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2977D1596;
	Thu,  4 Sep 2025 15:14:43 -0700 (PDT)
Received: from [10.57.58.14] (unknown [10.57.58.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 46B793F63F;
	Thu,  4 Sep 2025 15:14:44 -0700 (PDT)
Message-ID: <75db1f58-98b3-463c-af4f-2ce9878cba9f@arm.com>
Date: Fri, 5 Sep 2025 00:14:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] mm: introduce local state for lazy_mmu sections
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@redhat.com>, "David S. Miller"
 <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
 xen-devel@lists.xenproject.org
References: <20250904125736.3918646-1-kevin.brodsky@arm.com>
 <20250904125736.3918646-3-kevin.brodsky@arm.com>
 <22131943-3f92-4f5a-be28-7b668c07a25c@lucifer.local>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <22131943-3f92-4f5a-be28-7b668c07a25c@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DF8D840007
X-Stat-Signature: y8sidceipp1j7uh1jhs5ocx9t371tzi7
X-Rspam-User: 
X-HE-Tag: 1757024092-34151
X-HE-Meta: U2FsdGVkX18gdYSx8Z1RICp6YV0XKEY8wzzzs6MAxGNJSGTQxDkqrtd/eDjj4vNkNYZr2vYIOMEahqaNZJUy2huOtrG8m7ZpcHbV7NCgp/tuNglQjn/Pq20Wk+0k2BcpV+7tpN08NMaHrZumnWLeRWyg+AwVCLG4P/7vVp3qR2w01zuiSM7qxQ0Orji/9po9f7/oVBAq2sY3b2X22JoaLQLN5LJyho9t0lDSqHIkpHM4PweESC+fKwf8mdkvZlMXo59KsjBiJuGW0mBWmQLhmALuuxyJcX38ivEkQMwPqoe4DKrevKSzNcznI6VeiqEFaSuaKbTqXpt4EOdP+ZOB71iby8WBDy+7xM/fJvDVd2NpEkusgokULiogcpZwSOGYYUocrwB44477N1gemIHcJthbN19h52j0sSvFORMpxpHV6yCeXU6ElEv2IeoV9n/ij0cIOw8+SE4L9U20tuCe0lGjBBgrkaC2i6E9jSSo0P7X2Yb904g9Qs5rFrRLz9LUvC9W69b9/TwGkfUijAGWhkjIO1ZprNgOa8paF45jVe2bVY43SyiRI/fgiV7KT1nxBkOixBmwFHqeC9WgEsoftyCiHASeH0KisRq27XU4saM0JDjkwnvsm7ClGbSbyPa4A03nHXz5auTbYZyB4nM2FouQN2pVrMIxHLjWGLwStaexxkr1/SuFJzlnejDf7VzkNH+v6sccdG4vUygVyJ69j7g3V1azmWonj0z8nZENPZzb5om0pUitr5pkOtYGgukIkHetPEgqGwfTClD2mAiDBZW/wFKKlBBiGAdpCdQ3bhuW85J7dJZRfkktmm/OpbrThWQaH45JjQ/7MwoQqiJ3go9erS6FCFcHv0CLd/SjGpLnlBjal//Rvjh7naB5xivNtcbWZ1L7BIVF/5vxaaELNOTKG+oMZTduGpfSSBPYQqoISymwHkbH7lQJeXmwUxPSsUQDxDGFsFRcJOXd+oy
 vxsJLuRl
 fbPuII2HxK5r30NNao5Gp/Ak87D73U/vRkVO0kkeNpqF0D9l1aJCs5Ok3VOAJIQvzG/AUeZUSAihc8WtxdLJGX9iU3TcMPOSwgjVKPqCNVAWALnjON4xoh3sdsP1xeF1B/lBin3MZjrub6YeQLHPhFS7EzoHkJBi6i62j/H/4abR3t15ZKKtv/oS7sk6ThQ2gSzmHZxULW+MSqHqKToEEEqxDEg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04/09/2025 19:28, Lorenzo Stoakes wrote:
> Hi Kevin,
>
> This is causing a build failure:
>
> In file included from ./include/linux/mm.h:31,
>                  from mm/userfaultfd.c:8:
> mm/userfaultfd.c: In function ‘move_present_ptes’:
> ./include/linux/pgtable.h:247:41: error: statement with no effect [-Werror=unused-value]
>   247 | #define arch_enter_lazy_mmu_mode()      (LAZY_MMU_DEFAULT)
>       |                                         ^
> mm/userfaultfd.c:1103:9: note: in expansion of macro ‘arch_enter_lazy_mmu_mode’
>  1103 |         arch_enter_lazy_mmu_mode();
>       |         ^~~~~~~~~~~~~~~~~~~~~~~~
> ./include/linux/pgtable.h:248:54: error: expected expression before ‘)’ token
>   248 | #define arch_leave_lazy_mmu_mode(state) ((void)(state))
>       |                                                      ^
> mm/userfaultfd.c:1141:9: note: in expansion of macro ‘arch_leave_lazy_mmu_mode’
>  1141 |         arch_leave_lazy_mmu_mode();
>       |         ^~~~~~~~~~~~~~~~~~~~~~~~
>
> It seems you haven't carefully checked call sites here, please do very
> carefully recheck these - I see Yeoreum reported a mising kasan case, so I
> suggest you just aggressively grep this + make sure you've covered all
> bases :)

I did check all call sites pretty carefully and of course build-tested,
but my series is based on v6.17-rc4 - just like the calls Yeoreum
mentioned, the issue is that those calls are in mm-stable but not in
mainline :/ I suppose I should post a v2 rebased on mm-stable ASAP then?

- Kevin

