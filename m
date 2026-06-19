Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84699CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 19:21:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C9EF6B0088; Fri, 19 Jun 2026 15:21:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5532B6B008A; Fri, 19 Jun 2026 15:21:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F54C6B008C; Fri, 19 Jun 2026 15:21:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 04A8C6B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 15:21:30 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 60604A0584
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 19:21:30 +0000 (UTC)
X-FDA: 84897631140.11.D807048
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5B1ED40010
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 19:21:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Z5luWeW7;
	spf=pass (imf27.hostedemail.com: domain of zokeefe@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=zokeefe@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781896888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NwM07K3rOkOHfc7H5+DTwc63NaW6MBuHAOMiUNB1qI0=;
	b=hbRrZnRvI+er72yWc3NDC2ra+bvO8JXbYuUn7b8hyNJEkJWp/p47zIclqilXrhcd0XiC6Q
	3DF62nKUTt1kPFeA4SPCnbUGloJLTyn+Ed1jb5fX2pmujyeiGMjWJY2mM2FZCwb3hSvuOm
	JXJd7DD0YqTCitRMYxXjvRpZ8mslvxk=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781896888;
	b=O8obCeuc6zXbCAq0ngI4YRlY2F+h44clz+VntX3vDxnvsvxvBIAntxrwOEP3xzz+IELvy8
	TGepkUqNTL45+QI/obGzDcGKwcE/reMhjA+QVq1ym7/2tekbikCiLFg3TvUcED7lwfsNY6
	yC+LTfPj2DYJmYPAvbc6XlKYcnQXTPc=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Z5luWeW7;
	spf=pass (imf27.hostedemail.com: domain of zokeefe@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=zokeefe@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2c6a4eccab1so57265ad.1
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 12:21:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781896887; cv=none;
        d=google.com; s=arc-20260327;
        b=YD6uJPjSivDOEvuRut00ZUovTY+on9k7/7spC7w7PrO72W47Daj61LKt5qSIH1/Ke/
         CIo+JJ5Q8tN4bGg3hHoEXngA26TIGPFXw4AUICEwXTl6xQ0plqAX4cggh5FYunBc9b3V
         xVsR4BQw3SW+STW80WGgrq3Mzk07T6YWUcCzRhPanhDB6P5PThigPWqgZylEhAmeo4BR
         5Pqtq4f8kJQNR7x6oFUsJjXc0ZbGGXEryXZp5uxMfLIX4Hdazb/CeteM88E4kXEMZYR8
         BS7tG5bYLqBi8i1Td3MG5Qre1MSqfY9wdSOzom6ufgB+zErlvq7RvmCrq9tH9oeZ1EEn
         klig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NwM07K3rOkOHfc7H5+DTwc63NaW6MBuHAOMiUNB1qI0=;
        fh=1xkg8e6nAuyMmso3jkJU/KuitNYp6wX3XAwoJHI8f8I=;
        b=Y/R4iMTqvvgZpMAqIPhUMDdN3uhasrbZbdvRguza3vCmQr87Bevz3ejU+WjUynrP5z
         YZFQ7Ht2FKYpMJUBAvGt2nesSaqVyZxB4w/euViXfr8cBztVoh6vk/oqcWq3qzTuwJU5
         k3KRJ3Q0fJmNZWhIfVSeQK8IXZlt5kRkIVZcRPsO18fECBiGEoh8Jy9a904xfjzQ/TKs
         d9ev5JuogcO1KHTB0k5cTjxH/dsFOEwTcH3CNVQncMqBwLO91iMCwSLKETzijRei8oIY
         Y21/Hr2weHraDKbE1Vsq174PdSssY5zkUVtYzgNWo/ofN/8s3TafUG6DJV68YWN0RFgz
         34xg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781896887; x=1782501687; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NwM07K3rOkOHfc7H5+DTwc63NaW6MBuHAOMiUNB1qI0=;
        b=Z5luWeW7a0pROGTJRbkdt9thxIfcVsv/yAjTPd0kkotCzvPwZ2T7Dwwpqv/awBsqNd
         WK3CTb4HR0gvxNqqucE8FGf09cINuA9GJVMlrmsT1OxBDxCjnzCqSdse8feBRR3Nug1u
         DHeengbmiOvNpjvE08jkXvzahE0gXp+MSv2zYUD352ub1iWUG5dQpJ/G1L6D7XnVkUTI
         IR9LbmrzCjpdBo+xbk3oJW/2/vAlD5z9LmwubxsJ8PJAIfDGVG4Ydm6TdLaH0j+HriqU
         ykWFoI4gUe+20NmRA5S+nxCZeKJ+B6zgGkcGhQF3lStYtNRoV3FHE/Q3z14Kb9ryY0b/
         jFRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781896887; x=1782501687;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NwM07K3rOkOHfc7H5+DTwc63NaW6MBuHAOMiUNB1qI0=;
        b=oz93tYHOeLxNx4Ewr5zImRG+e6C2rZibjVkVjMnZqNU0nB9+/5wZcYtkpGNlUeduR9
         cfPGqisbm5NPzoPPXy3w0afZFrVJ89axp22E8A4WbLb+zr9KdFZHSA1dlvgITr01gzkt
         CMpC6TSNrd4sXHPnFCsBaSvoA8hofDszPA9u1q/XUZKEYr2VEf6QwgWtMdW1a6OJNcaO
         HDCUTv/7LeA4C4Ko3pCrfd5WO8nTK4NwX9L/axOeFxWiqAI5BXz5785jwTWQnr2WarIj
         B9TOK0rAapc6C6u35/LlDHQ1QwRtPr4d4FQ84a8tcmNZSzdYFL77WfoTUdN/RDL1z8aA
         T5Wg==
X-Forwarded-Encrypted: i=1; AFNElJ8dOhuMYtiJedknPbAlbRd2IBG/R85a0GO+pX8zRl2gcqNRO7yM4hEBYINQs/k9RvN8QpXmZx7kmA==@kvack.org
X-Gm-Message-State: AOJu0Yxd4OkOZKt3JmzcRPDh6hi5U1rZSiLVxFBNfiasa2Yp/fPOtWDG
	mo/n9YRMsoEJrFB9T9875cKx4+IDoVcQcfedcYQvjvmgiSo905qTKSD2XR8xjxffmZfT5PFidxx
	lg1jAX6KaY6px58k+tjXQq0qx1twBBvBIviQNOfvW
X-Gm-Gg: AfdE7cnYXEioqmOQib5APsyYkSNjyb4L+OlwNaQZSlBDUFFMlhpUwU5jsjGt1ilj8hA
	94dUGiPQdSqBhEefrDsHCq7Zo2G2B7kpCiwCxpPduHEloJpx3Tp06wBlfTpgdTqO20iznc4OJM3
	uBiBOY7zeCl3g8vbQPPRPskUS+roMAYChU/btmftl5BjJqfGBZre+YwY0Q4T7WeaXW+lmQWesQz
	hrci5JFL3MKs+yoLazoOyi16ekw4XCzqbYMpfHSZVUafMT1BeuUVEHOcGg/CJ4nH2MFtkAz3w==
X-Received: by 2002:a17:903:1590:b0:2b0:b925:da98 with SMTP id
 d9443c01a7336-2c720199141mr1649895ad.19.1781896886472; Fri, 19 Jun 2026
 12:21:26 -0700 (PDT)
MIME-Version: 1.0
References: <20260424191456.2679717-1-stevensd@google.com> <da9321ad-4198-494e-b9fa-30d69bd29be3@intel.com>
 <6369e5ce-74e3-4c68-8053-d7d7d21b6955@zytor.com> <dbeeea58-16cb-4383-b8e8-91a8ca84e88a@intel.com>
 <CAAa6QmRw6QLnVJ8+uvMV8ASreLXzSab5Jii3Ju11qCZYio6Few@mail.gmail.com>
 <c070c4d6-a570-4eea-aca0-72eed319a198@intel.com> <87pl1md7h0.ffs@fw13>
In-Reply-To: <87pl1md7h0.ffs@fw13>
From: "Zach O'Keefe" <zokeefe@google.com>
Date: Fri, 19 Jun 2026 12:20:48 -0700
X-Gm-Features: AVVi8CdLspRvZVpCXWFvap7dSLuqCy9o0eZN4RyhDGZ0kdkCC3cDbPuFHVXJmPc
Message-ID: <CAAa6QmSHBDeY0G=_N1P4dAAH917J7jerfZrWDfDd8w=8jH8nVw@mail.gmail.com>
Subject: Re: [PATCH v2 00/13] Dynamic Kernel Stacks
To: Thomas Gleixner <tglx@kernel.org>
Cc: Dave Hansen <dave.hansen@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	David Stevens <stevensd@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Linus Walleij <linus.walleij@linaro.org>, Will Deacon <willdeacon@google.com>, 
	Quentin Perret <qperret@google.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Kees Cook <kees@kernel.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5B1ED40010
X-Stat-Signature: k87kjztx93dkgrrmbu6953xz38ugux9i
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1781896888-51763
X-HE-Meta: U2FsdGVkX1/pD73MlMGA7tunlxu8u9Va1InrHFaENFRfHcbi48CxS2tH7IqUkAu7HXHDJIRAaALgBkJ+27wbjV2nVwt3h6K+cI0ySsCxbMB1zfTinN4JOxGQUx+UU/Ts0asiA0laOmzNLSzprIkzAaH2ZDDgxxTKrWjuRM6RhvnDh3Wi5op0dKjk7694zYYeW1AuTOcEKwMvvH8AvPuvndU1w0B9/20FM5JeWMJjkbPtPSTXPhlhfoXYaAuUgLSn8urQdPPP5BIfUjoKKicOrQf56Ies9t61hNp9kNS4r+KBALcHoyYjDacaLTVPJv4qonnNG8rs0bruqDxb+pVABIzlqBn6ug5Uljc1pHg1527cyw0biT6TPWUndmsV6hN44e1kk2LixMUcejuWwGkVfBivy/9g2Nz42j8KZmu5EDsxJEYQMJvqodIi2xWPEFuRYQOQqoA3V+ChSBdmzbKJO4OzXLXzjTiex2KUr0fZQqfKErQ5LvT9syYqIE1AgSZvLvgSuAF3CddLh43+H+10j4AT56VOSHpkeWLmf62WjXA+AybbiHCRXYxrBI/7UvoWVPiiYdKUX8pZ7PuQOGsK2hG1m6ypHbB+QhJ3PjSqRZRoSxz1zrFxP32jgbZ39E3sf7EFJJJlrKuxxezTwZmVuj/nOiRJk9Zm1Q7nFACj+QkjBZOv4bvzFEFlzwt98nT+h2mGpK0bzvjcCR9Lf9dua3ZHMBUPuBTY2hqBW/OwGwVMcRyYnIvO76sluYAQFykMPCnBXT6ybKpmGeEBmXkmlwQ0WKmXpQ12+IaWnezWfr/lMUABi4Icf1mju0izZ7TNPQExeXY02W/malop+z5id4+Kz9XQdCiBXQuep9jiXc7Ly4AERHMpAvNpDbAzdt5wVHF7IthN0O5MlQsYyGmE3iRquQW5kZbxUEagmZOKJGVDncOdIlJA/5wkQx9lQR+wXFAhjt4tdp6VgT946MV
 lmbBiOJO
 hVRUVamia4ccKxoxrXUuByaGXuHD3mqi/36KRm4RvvoKb1dBApEzCtyEpUodiej7ngUx2icez+G3WU+oCihFIbQ126gUf5TpCFHpqnKqdzPJUWN7Z4EBXuR/fsUrbjDftwePFMWo661++THq0QOtgoGcLZHgCliXLRPg2eKTNMqOA/T4k88i+HzgRvHEsVR+qC17l8gN5C1UjCD1VpnSM1k5Snp7vedHoR1UUFUgif/LePVw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Aside of that the part which worries me most is the IDT hackery. That's
> fragile as hell and full of unvalidated assumptions. Reading "should not
> happen" several times in a changelog doesn't make me more confident.
>
>   "It is possible for #MCE to occur on the #PF IST stack, but the #MCE
>    handler shouldn't generate new #PFs. The reentrancy check on the #PF
>    stack will trigger if any recoverable #MCEs do generate #PFs - if ther=
e
>    are actually reports of it happening, we can address it then."
>
> Seriously?
>
> We don't wait until the report comes in because the report won't even
> happen in the worst case:
>
>        #PF on IST
>          ...
>          cmp    0, reentrance
>          jne    abort
>
>        #MC
>           ...
>           #PF rewinds #PF IST
>           cmp   0, reentrance
>           jne   abort           <- Not taken because #MC happened before
>                                    it could be set.
>
> IST is fundamentally not suitable for this and I'm sure there are more
> holes in this.
>
> I haven't looked at the FRED side of affairs yet in detail, but the
> handwavy explanation about external interrupts having to be moved to
> stack level 1 and unconditionally bounced back does not really make it
> appealing. I agree that chapter 8.3.4 in the SDM volume 3 is not really
> helpful, but papering over the problem without understanding the root
> cause is not cutting it. If it's a genuine FRED hardware issue, then
> this needs to be understood and documented.
>
> The x86 folks have spent a lot of time to make the horrific x86
> interrupt and exception handling solid and therefore have zero interest
> to deal with the fallout of something based on "shouldn't happen"
> assumptions. Either it can prove correctness under all circumstances or
> not.
>
> I understand the save tons of memory accross a fleet argument, but a
> large fleet is also a guarantee to trigger all the "should not happen
> and impropable" issues which are gracefully handwaved away. That's a
> truly bad tradeoff as it ends up in non-decodable bug reports. What's
> worse the have to be handled by the maintainers and not necessarily by
> those who implemented it.

Thanks Dave / Thomas / Hans ; I appreciate your time taking a look at this.

As Dave previously pointed out, I'll admit to some ignorance regarding
the subtle nuances of x86 interrupt / exception handling. Counter to
my goals here, that code has "just worked," so attention and time have
been spent elsewhere. We'll undoubtedly need help making things solid
and avoiding previous pitfalls. As David mentions, this is an RFC.

While it seems common opinion that the IST-based solution is fragile,
what of FRED? It seems like this is exactly the kind of support needed
to avoid some of the aforementioned sw "mess" in various x86 exception
handling paths. I agree that it's less-than-ideal that we are forced
to downgrade exception levels in the common #PF case, but is that an
unsurmountable problem? Pardon my ignorance.

Lastly, I just want to clarify what folks have meant by "extraordinary
claims" or "evidence".  Aside from the above discussion on FRED
exception handling, the "only" other part of this is the allocation.
Are people concerned about memory unavailability, deadlocking-type
issues, or something else? We have considerable design freedom here to
avoid certain classes of unreliability, but=E2=80=94barring any clever
tricks=E2=80=94I don't know if the allocation can be guaranteed to succeed =
in
all conceivable circumstances. I want to ensure that reality does not
present a hard blocker.

Again, thanks everyone for the time and help,

Best,
Zach

