Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22F35C5CFCF
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 15:46:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1F316B0530; Thu, 13 Aug 2026 11:46:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF6326B0531; Thu, 13 Aug 2026 11:46:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C33666B0532; Thu, 13 Aug 2026 11:46:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A1FC06B0530
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:46:47 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 326BB1201E8
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 15:46:47 +0000 (UTC)
X-FDA: 85096674054.22.937AA90
Received: from mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8A12F140003
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 15:46:43 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qwiqCVvW;
	spf=pass (imf23.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786636005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=akZbaRFBLZfI8O1xYmFo16Fcpp1vOrvpY6LWSh0sGbI=;
	b=fS02n5kS99u/T2QyNW1jDW0HGTtqk1hszJCQx4ZQDsYXGhJ0zEdK5MwInsielzotRv5fVU
	2xSE0B4uLu1xN8pXBjgk6dkoLgIzxTXZIL6V9IkWAdhjgyAtIgV4QKwXfYIm9c+0UJARoO
	mbihfCkaQMx3gmRUVy+7UNF4tz7FAO0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qwiqCVvW;
	spf=pass (imf23.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786636005;
	b=wsKB+9maF+Rb12Ky7OYgeuaoVSHycv1rOBzPHIeZEG/uxMocdNCd1Cf9mL7rgE4M18ZWz3
	5Fnz/2LkQi3jieGlatckuTTOI3vf8PfQsfUSSW3RGhDV7jx2/SygGxM21x6lxTk4Y5WyoB
	PiPDeQk1PlI90UXD+gGPKVCRLrl8DLQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=VvvSWU1z6gNgzJq3hKzNJLAXvt5lEZTq3+S78iDvHfo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786636002; v=1; x=1787240802;
 b=qwiqCVvWtk4b3jpThTjnUMgeW/euGPyxx05hS43njfUfL4ZHpMU6rq/Ey3SLDeIZywHQY3Al
 lyEjvJ6CYtpS+h5f90Ur5pJyMbd2TI17eI3Pixw0CHO8NPUWSt+eJM76aOmjoGB/7iGggCQ2sJ9
 l+EkdG5x+BVVp8p70bzPE/qA=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (77.97.51.77)
	by smtp.migadu.com with ESMTPS id 834805d10310483a;
	Thu, 13 Aug 2026 15:46:41 +0000
X-Migadu-Flow: FLOW_OUT
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 13 Aug 2026 16:46:40 +0100
Message-Id: <DKNXLRXE2ZIB.2CXWIXRAZO45L@linux.dev>
Cc: "Borislav Petkov" <bp@alien8.de>, "Dave Hansen"
 <dave.hansen@linux.intel.com>, "Peter Zijlstra" <peterz@infradead.org>,
 "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand"
 <david@kernel.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Wei Xu"
 <weixugc@google.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Zi Yan"
 <ziy@nvidia.com>, "Lorenzo Stoakes" <ljs@kernel.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <x86@kernel.org>, "Sumit Garg"
 <sumit.garg@oss.qualcomm.com>, "Will Deacon" <will@kernel.org>,
 <rientjes@google.com>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 <patrick.roy@linux.dev>, "Itazuri, Takahiro" <itazur@amazon.co.uk>, "Andy
 Lutomirski" <luto@kernel.org>, "David Kaplan" <david.kaplan@amd.com>,
 "Thomas Gleixner" <tglx@kernel.org>, "Yosry Ahmed" <yosry@kernel.org>,
 "Patrick Bellasi" <derkling@google.com>, "Reiji Watanabe"
 <reijiw@google.com>, "Sean Christopherson" <seanjc@google.com>
Subject: Re: [PATCH v3 04/26] x86/mm: split out preallocate_sub_pgd()
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Mike Rapoport" <rppt@kernel.org>, "Brendan Jackman"
 <jackmanb@google.com>
X-Mailer: aerc 0.21.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-4-6f5729aa9832@google.com>
 <am9sw9dnbYLegAfY@kernel.org>
In-Reply-To: <am9sw9dnbYLegAfY@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8A12F140003
X-Stat-Signature: fwko1bkyddahomdjuiz91fzxj9dhdrzn
X-Rspam-User: 
X-HE-Tag: 1786636003-538069
X-HE-Meta: U2FsdGVkX1/jfCgZtThRINDG91rhVgA3DkvzTBG5L6tNmtS2gjFZ3hGrlYIPioVrREUWhCrJvW6k1WcAJ4RAz2k9gXZsoJHhH7uCGsKHiZR2IFwQZCJqA0Yih92f1+Zt8/dFCaxUM1lxuE48Aa4HaS4EDQqd1dLl2nFicJ4Z+Zp+16kGVN8XBfm0y4tVgrmESVs6IPpj6986tGZZjcDQpwLs+kIFIb2Qe+znMft2TxynNJrzZ3QVd80pZwLm5aimlfzRFfjze8NNShJnIMN4HgNLLotKjDqMoofMd9hxVpkq17OFkCfsRKyY6MSC/LyL0xkfm1KlA1Q3KdsxYXUJDhvCkLKh+EO+Oq0a5uxD2kQQfERAjZbMkrDzlws89zDiFDXsvAeH8WpAzr/AOgZQ0FIMmFWcXux+d9nSJJlX5BfJciloSu3zSRndBeF+ZjHGcx3SBtJsgVzs9cZrstuPXgNjqqCwdnUJ1hoPI2VEK4Utu4RtEUmT7uO1kzWR9goUaWMI/GjfK55dySg8Tc/lq04pwAYlkp9AguwuvBrpExX6Q12JfY8sjYfBELLtZ9i0Qk9PBD9/Yp/2K8HXrPPKIi3J/qumhBIhBmaOWXsOKUKSvj3TE3jC0xT50eXxek6CIMPRCNfK48ix9gPOwCLtKKESh35AJXo+3ImTrt7UEHzcL6lod24lJSxX2SJ96DTi7tTHQ4btdFYc8q0Qdc7ZGeAy31LfkJS4RzOb7ZWzd/uRjE1WMc/Dv5wVsXDcOGMbPvpzLz3dMC8yI0kxz/gUPlw5+8Y88GF/ZuYD17lA7QfnxVIGkXLBmzUHG1gehG1QAIVHXI3O1RpoegOfgE3XHzwpfZ7LQedoOuWWbBUKAmYXnWQw3AVqHtyVJRqrgqN5IDb0pZMAAdCp06bZUPtcGhMC4/KnJNPZ1hIdtHxaDo3RBImjthzcX5fKTIea6XXGzAPLB7Jk0hfViHaSEgV
 WwlVXrkz
 Drk68Tm+8vHs11Va8h/9QAxM+OE0ohlVdZBPKl7wCtQXMMTxu7iPflu7jCn2Sg3M7oHE9Sqa33bsU32wbQZ2FA2du4fzHLCOW05GDxYEjVWPnDdAiHmAoTQXVUeVkPhTpkOlXBS5oRhPUgUeOKwFPMqJ0oLTxC2yHQxb/woPEIgh8m+CCnKk3/QX69WwWrehQEmFeQa9gcBWdawy7SL42+kuuxe53mDJPEEopRBAhwS/Sg/Zhdu30+sTF0bCiAf9mqXyR8/9eONZ1CzRXhqQt5d7wtSGp7Ef1ItMHPlUabnHyHQoEGwgaBUvoGF3mo1TSKlr/bE3p2UCzV1bHfZRC0t1dWD2UT2QQzrKz1NjL2Bbplqvcv7NM9w/9HpMAeNtL+o+W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun Aug 2, 2026 at 5:13 PM BST, Mike Rapoport wrote:
> On Sun, Jul 26, 2026 at 10:22:37PM +0000, Brendan Jackman wrote:
>> This code will be needed elsewhere in a following patch. Split out the
>> trivial code move for easy review.
>>=20
>> As a side effect, change the logging slightly: instead of directly
>> reporting the level of the failure in panic(), show a generic panic
>> message, will be preceded by a separate warn that reports the level of
>> the failure. This is a simple way to have this helper suit the needs of
>> its new user as well as the existing one.
>>=20
>> Other than logging, no functional change intended.
>>=20
>> Signed-off-by: Brendan Jackman <jackmanb@google.com>
>> ---
>>  arch/x86/include/asm/pgalloc.h |  3 +++
>>  arch/x86/mm/init_64.c          | 44 +++++++----------------------------=
-------
>>  arch/x86/mm/pgtable.c          | 38 +++++++++++++++++++++++++++++++++++=
+
>>  3 files changed, 48 insertions(+), 37 deletions(-)
>>=20
>> diff --git a/arch/x86/include/asm/pgalloc.h b/arch/x86/include/asm/pgall=
oc.h
>> index c88691b15f3c6..2aba6cfabf495 100644
>> --- a/arch/x86/include/asm/pgalloc.h
>> +++ b/arch/x86/include/asm/pgalloc.h
>> @@ -2,6 +2,7 @@
>>  #ifndef _ASM_X86_PGALLOC_H
>>  #define _ASM_X86_PGALLOC_H
>> =20
>> +#include <linux/printk.h>
>
> I think this should go to arch/x86/mm/pgtable.c. pgalloc.h does not need
> printk symbols.

Yeah thanks, no idea what I was thinking here.

