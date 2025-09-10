Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4EA5CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 22:45:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1467A8E0006; Wed, 10 Sep 2025 18:45:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F76B8E0001; Wed, 10 Sep 2025 18:45:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00DB78E0006; Wed, 10 Sep 2025 18:45:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DEF1B8E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 18:45:53 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 967E65863A
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 22:45:53 +0000 (UTC)
X-FDA: 83874824586.08.B204EEF
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf17.hostedemail.com (Postfix) with ESMTP id 05BE94000A
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 22:45:51 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=hm1N72Cy;
	spf=pass (imf17.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757544352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MX289tJcgQi6V/gg0Rfj/3y282yxF5LsONohYh8AGHw=;
	b=KK6ygi4OZ0/zDVKqQwNlZ7n9Nofj17JQmG7UBzHMlmXTGWcZaAEs1erAIyfD2NeR+IzLp7
	x8mF8XfaKft/KzzVWxRhjJAUyHuza+ngl9bXW8dLxR5kNNED5HQF5SEov+USSnfQDr/BRA
	qctYepxfc7FtwW8KMGaGcOf9dLM8pls=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=hm1N72Cy;
	spf=pass (imf17.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757544352; a=rsa-sha256;
	cv=none;
	b=DBW77VSBKD/8oLj1sT9HW994YoXM1vvrscc/yJ34ngHpy8zIAcKGGho8i5IaVEP5freuw0
	6b37RmXAczZ+FzUG2ajnakuTyJDcbTAqsg3fRaRtCdMzb/ZqOMhirvV3Xsu0LGQ8xxUyO7
	Ug4juJE6j7lZXIHpRtjdrhuu6huU0aI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1757544351;
	bh=MX289tJcgQi6V/gg0Rfj/3y282yxF5LsONohYh8AGHw=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=hm1N72Cyh7rDp2SfXLYvSXgDxJ2dqZ3adrY32dQ0q2TAuhviun5xKg5I4iC1Cy8/D
	 1K3NJaDnulxw3HcgBxR13zzRQrKEMgiVOk9BH7KOHUSQENmCDh66CfzZW4cGJ674Uq
	 t7tjlNEzTqEEK03bKvXtMDR9dJHF2Z/LIrpMOAOs=
Received: by gentwo.org (Postfix, from userid 1003)
	id 157294033E; Wed, 10 Sep 2025 15:45:51 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 145A54033A;
	Wed, 10 Sep 2025 15:45:51 -0700 (PDT)
Date: Wed, 10 Sep 2025 15:45:51 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
cc: Vlastimil Babka <vbabka@suse.cz>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    David Rientjes <rientjes@google.com>, 
    Roman Gushchin <roman.gushchin@linux.dev>, 
    Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org
Subject: Re: [PATCH v2 16/22] slab: Remove dead code from
 free_large_kmalloc()
In-Reply-To: <20250910115507.1991829-17-willy@infradead.org>
Message-ID: <f1fcf225-742b-622b-212d-a395999ae737@gentwo.org>
References: <20250910115507.1991829-1-willy@infradead.org> <20250910115507.1991829-17-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 05BE94000A
X-Stat-Signature: dddahcin7eir3npkwmiqghtreojyx5h3
X-HE-Tag: 1757544351-966424
X-HE-Meta: U2FsdGVkX1996UM0FGwbOORbZJZGsYBaORsb30A8MwkR4B4a8bYnumQ5o1rBuoceWiqGQijAqDAXsxFLVnMlskfSWPU1j6am/uDcqloXUt2ylL0XUyuxocj4TN218VUU0MRMnsV+v2MJh6qnYAPFH11LgiNes6eudhhnoM45Uhaw7zhslHLX/QM/wubSIiuDwdGJlpaU7zy9eYJgK4tfMzJEyHmFOL/lRnVIs7j2pmr4tWPy7vqrHp3BN+kVfArjbGnE3Oldzuw0DVDISwBonLmdckIAsOtjuKjvg3gUxBjgTDj5BCDQVAK9NLtIsdmvRSMW+I0OrpLJR+B0++WowlR5Za+njz5whZVGWPd/5vXG3FzggRHgzyyD6vrF+y9Av+ktZKa1HoNGvyPYX8duTfZyjZzAVNspi17lhQ2gnM5cGILlgnzlLqBGI+Ja/c9QuK2+YaCuYmb7V0OsVdJA7svK9psU77nFVAJ9O6j0Jz9c2wHP2ullda1cj4UVbfoyYo16/FpmcD3dvw/0V4wEmAHlopu24PIwTrd3pG7BOWq1U7XZnLuWl5s0sO7r2mAzBDoEGx+n+AKC6NrEh1gOVTOIK9V6NcY3j0VrxKIWNAI56mj4mUTPN6ugiXd+dKZz0jYH2eoo5BEYbgymulloJrHZhf2DeIVfXKmt85Qzc1jMLc8GfujN1YIxcrCE3/LXQPsC8maTC1Il0W0AY/hvFMxnMZEAdPCyYevaW5bfdPsoSxMtkoy23dlCNUkcAArJHvXbQJtIAj0tSF4SCR+thpcJGhskh828ld3okjpraZSow/kAK5slTl8/BEuySWKR68LCsSLmxWo4d0BCl2X9nYZC2SVAM37qf1crjXKz0Wp8+mNbUvwnfRecesyqMc/6pHzQlGFDK+5hOfI18Gr5IRKHMHIBzcxCk/75KdM72VBvG4TznL5T4Ctmv5g2XArAo/YjCNzkZumJMfg8sal
 J84axS39
 1dutMxLr9LgY7PIu8URF6ZgNcnJ6caLJAWi4JRgovf802EtzHuIcuMJJNPzIt51QUkFTZhySrWoIaYQ4Kiqzvap7SIpAoAtx+HXttmXIQoN0Kz+CRT0oHGC1SXsY1KRebSWWvcvzKOwkVeCcFCR9TS1hF06n4FYgZcIdL9DR3E2+DS1t1lcbpXP0cvZZzWibDauT6mA12a+O1JTEHudnW3CFIJFZSV5/dxtIll0BTBQ+BNrIK8SHSpQSsw7bKBKPRXnciF64crNtHnTyryph+tUCBXkVq+o196rc4bwlgeOtf5wVMRJasFRqH2uDAKV+dqmYFJcVFBslrGlyJiY6HuA/kRA3LlTvjc7kzz5l+/8Yg62QDT1tjOqXqhQhjcIImOwSF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 10 Sep 2025, Matthew Wilcox (Oracle) wrote:

> All three callers of free_large_kmalloc() check PageLargeKmalloc
> first so this warning is now unnecessary.

Reviewed-by: Christoph Lameter (Ampere) <cl@gentwo.org>

