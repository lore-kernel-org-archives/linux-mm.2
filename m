Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B72EBD1266D
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 08:21:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F5986B002F; Wed,  3 Dec 2025 03:21:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CD5F6B0030; Wed,  3 Dec 2025 03:21:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10A826B0031; Wed,  3 Dec 2025 03:21:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F39696B002F
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 03:21:10 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 965548A5CA
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 08:21:10 +0000 (UTC)
X-FDA: 84177464700.13.A29D720
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id E04D040012
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 08:21:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764750069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e8MuL9dN4W4aZAtBVVyLVjE13/XsnSiE2gy07VCOnSE=;
	b=WTq7tmhVEYEFKVFVEffEzU3alv6K0kGbwkT6Kiro/+YJnri34R+B+pNAEJAufp6/aVKYe+
	NYPgLfthKKk7WyB+xS7LLTuPvd8puSqzcVVm6+NjiZ8MOxXGZ9cHkaiUOgeZQSPuCtOp6I
	TMz81cqtbOhvYDpyFIcEOOQc1YaOl7s=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764750069; a=rsa-sha256;
	cv=none;
	b=HTpMKpVjsHTsfD3X+nHWbjnl/eqCwYwnGZML9mZCFKIMiaSfFtUtJYupNaU2Y1tvf3i9Iq
	YahwxcI2HlVHZsgQ0MwQbj+9+mg5rXugtwvM3VmYdVMuBcRhhehZqXJmobqR7h8rgfgHaN
	Awm5jbytRXbXLC7fxLqSR8II0djwd3U=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CDA3E1477;
	Wed,  3 Dec 2025 00:21:00 -0800 (PST)
Received: from [10.57.45.92] (unknown [10.57.45.92])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 23FCA3F73B;
	Wed,  3 Dec 2025 00:20:59 -0800 (PST)
Message-ID: <703cbee6-a813-4970-9232-34ee91ed8961@arm.com>
Date: Wed, 3 Dec 2025 09:20:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 08/12] mm: enable lazy_mmu sections to nest
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@redhat.com>, "David S. Miller"
 <davem@davemloft.net>, David Woodhouse <dwmw2@infradead.org>,
 "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
 Jann Horn <jannh@google.com>, Juergen Gross <jgross@suse.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Thomas Gleixner <tglx@linutronix.de>,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
 xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251124132228.622678-1-kevin.brodsky@arm.com>
 <20251124132228.622678-9-kevin.brodsky@arm.com>
 <23dcf752-0b75-45a7-84f8-25bddf97af08-agordeev@linux.ibm.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <23dcf752-0b75-45a7-84f8-25bddf97af08-agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E04D040012
X-Rspamd-Server: rspam11
X-Stat-Signature: ippan5unmoe7a4up9o3utbcwrxkhqjbt
X-HE-Tag: 1764750068-615613
X-HE-Meta: U2FsdGVkX1+UGD5E/73GL9+qy/yxmJSZrN32zO8Z7bPba3KNqs7dKJRBEk/LsNoaGrqp3skfZg0PfBNW3vqPiH1OFCMDb++ditVnevBex5/lO6mzEtjhlgImKvFWNMxO/5BwBGwbV+NS561oSgA2orSG+R0bo588BXHxRN3U0TXIsAW+3AGbUlBq85xCyTKcoMXMTREAj+fzjEMK/PtwEyLDpSuYxAkIDG8rwRtYl79sbS5ai7Zcnz+cIeQpMFEVo7SepCONImqqOQURvDe97FHUIkU6sZ49KJ75FUQ6jb+4FjnDAnBXK66QiaZwFnBN/lomzuemJl/uqF0P1fcLCzZqNXSVXAdScOEGKutrtDaYNRKYgR+02aS9wMEL+WVBY4Y6cWP66+AiLfOQxME876yUw3EmWvcBW0RDnhcGxtqFcpOjeM0YKI+oZCzORq+mEjU9mSBDXIAqDFJztXSEPJbx7DGfpsxkt4+Otj+KqJcdden625unVldLqXZUj6V+TcQq6JU7dmJoe++ywy5QMe+BCRis+fbktRKX1SJs5TFJ/yQ1j4e5SXOiRGUDOAjYvSL54ABE2xj5iEGcD9YRKtroakVNfkmaZMle6+mXJaU1Aex7MNfAd+eqrOMu/nFbZKcufL/VrSAWWckmukQ+j3KI8xohZkkDDqy/ISwDM3/8TQO7f9yYgZa/00zw9yFahA61B4AUTkFyTqa+3VTP3lxERC6mTYgaq1+tRDtK1qVNm4xlOqexAPI0ZMymGtMSZQkwhrLPsKWQJ+x46oxjivR6y7EkVvdR7N7Wf5cZlrfMgcXOo2q8ZUtyU9PKr6R2kCfGFe7480kw/WGQ1yXFIjHTm2vUYljaWVHkUVZzxGTAbUBq7Ik97de/GzAdvFS8QFHgVV4RzH26Dt6ESiXpU0snhFZ1meTGFKXnk7NAKik73OBbEgVaPjjkcMFTNrd/I7s/uP2tmciUr80JQff
 /CrSgPa+
 eTYvBrt3CMb3fCVklJUfdhiGEgLvsO5e8wlTR0A23kxFxdfoVhvq/e61ywt3d5euSgbgCft+9cO9ZgjLLmhisvtjUCbZ+GYBF2pDayXei+Dlg8cG6XrseR37X6JziAoHTLcjauB2VcKzKrP9CUXJfnog1/xKFF1BhqHVy9gMvYr28CvpWW9ed/lZIFU2AUSaqJLZ/Rvk1Rh1MWsyjcXNZM8aZSYuDlzQpyaJYMpFv1S55jsJIgejlsE18gJVQeawfOIAarmSDe98hmA7FVgCfL8CnWFRcyUDiUkg4peG1ku6yKG8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28/11/2025 14:55, Alexander Gordeev wrote:
>> + * in_lazy_mmu_mode() can be used to check whether the lazy MMU mode is
>> + * currently enabled.
> The in_lazy_mmu_mode() name looks ambiguous to me. When the lazy MMU mode
> is paused are we still in lazy MMU mode? The __task_lazy_mmu_mode_active()
> implementation suggests we are not, while one could still assume we are,
> just paused.
>
> Should in_lazy_mmu_mode() be named e.g. as in_active_lazy_mmu_mode() such
> a confusion would not occur in the first place.

I see your point, how about is_lazy_mmu_mode_active()?

- Kevin

