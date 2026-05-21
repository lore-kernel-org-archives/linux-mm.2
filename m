Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 747D1CD5BA4
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 11:45:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B79FF6B0088; Thu, 21 May 2026 07:45:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B51DC6B008A; Thu, 21 May 2026 07:45:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A68276B008C; Thu, 21 May 2026 07:45:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 984EB6B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 07:45:29 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 495A31611E5
	for <linux-mm@kvack.org>; Thu, 21 May 2026 11:45:29 +0000 (UTC)
X-FDA: 84791246778.08.B01B9AE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9EB2D100016
	for <linux-mm@kvack.org>; Thu, 21 May 2026 11:45:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ctp0+TmV;
	spf=pass (imf14.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779363927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=msT2XoX2mDBwKh/3GrjxQm5Wft6O64ISwsfuZ01n9XA=;
	b=Hrg8SPi9OMkEFEenhQQup1pLyF6eiwp/Cb3bano/4OGKAQLXI+Xlu5tFAoDwY7NlOzYpYO
	Jk17Tsc6ktBrcyMeYn7F+B/2qhU6Qo/HWjTHTISUrdTpj4mO2saQVk8bhYvwOE6vi1Px4S
	NrhnuwjFLHRoF0LBn1+4GqFasL5BILE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ctp0+TmV;
	spf=pass (imf14.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779363927; a=rsa-sha256;
	cv=none;
	b=sb5TerodMEpzPFsK8ZnentUlUP9x68qiYyw0EkS1WGosRB09CzpIhAX6pPemHaMvw4Kuig
	S3S4ZfckEfkhQqhAcJ73YUcvPu7LPeXa5jaUD9MdzuHNm/wuLofpxaLKsiK3/HdGwBu0G9
	eWIlIZsgPdJhrA+LRVMTNHx7FJWLDMo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id ABECD40607;
	Thu, 21 May 2026 11:45:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AAF971F000E9;
	Thu, 21 May 2026 11:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779363926;
	bh=msT2XoX2mDBwKh/3GrjxQm5Wft6O64ISwsfuZ01n9XA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=ctp0+TmV3ALkWJCJ+H/jSA+uqorY+jPb0MVOz7V1NcMNiR/srECJrqkF2oPYZjTdm
	 nOLV7CrqCNo1poRVfZIF8XW+x7IOqSCT2ucqQ2tgFtSxHBU85mUVmxnUZslR+ZMApZ
	 zMdebaM0lG4hjykb/0MFvSsgFyMPEH1+CgDmLHiDGXVp3VcLxVCu/MKX0vusxs1wK0
	 KkCq9UcLXZRSt9Psv/Gxa38NWeQDr8tVugIvEttafyeFwH/t6aW/DbWpx4jNzz4wrM
	 Qv08Rq3z0dbG8NJZIJxR95ddXmm98195LYSsD73wdaI4+qAEng2rpMepH0PLUzzgvO
	 Isc4eI73S0U5w==
From: Thomas Gleixner <tglx@kernel.org>
To: David Laight <david.laight.linux@gmail.com>, Thorsten Blum
 <thorsten.blum@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
 <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Andy Lutomirski <luto@kernel.org>, Vincenzo Frascino
 <vincenzo.frascino@arm.com>, Kees Cook <kees@kernel.org>, Andy Shevchenko
 <andy@kernel.org>, Yury Norov <yury.norov@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] vdso: move offset_in_page() from linux/mm.h to
 vdso/page.h
In-Reply-To: <20260521103029.561d5c02@pumpkin>
References: <20260521090655.160282-4-thorsten.blum@linux.dev>
 <20260521090655.160282-5-thorsten.blum@linux.dev>
 <20260521103029.561d5c02@pumpkin>
Date: Thu, 21 May 2026 13:45:22 +0200
Message-ID: <875x4hvve5.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: hb414hmsmbocs1rg94k8tj4fxwgtiukg
X-Rspamd-Queue-Id: 9EB2D100016
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779363927-161140
X-HE-Meta: U2FsdGVkX19y7GJp0/056te44pez0234eD08+Kwoh1IE7W3iN27kpDg4TyExpFgAa+x9p6qB5XkFM0vlKPJ7bBVxEwbAxXm1LEpDpuFtLXUJxhF0BH7JHyALsyzsETngiLe7FLFfPThUntUgksPZd7ERbjceK/aDcyq8fkeDtZldo6f4gGJdO1+J+rGGugckqkOozgmuCDiOlbCx8dP35SbYZ8zKQ7sT3DUV4hfzdAYaoFG9b0uVHwoM3vTIGCM3ddE378WKsRDP+RiuoA/5y3gVAwAKfQZWj96GtWAKQo4kdsiA+Kz42TujKpF2Zh07nDY7I2+vp+1Kkfcuzs9KetF00bmx6qC9h2dqkZmD9144XXX9kP2H3rDzJWH1m+3+ihgV14lj4knSwwGao3uCT5T3+pFV3m4/KnACmIsmeE5PVuA3NTzCH0VTG7rwky5IiUqdajnAhSeY2trbxgMzdOV9gvjUa8rwJFjQ9+wPMhFK/YdJQh3T81JBwc953182Le6eawvgxyetwxg/PTQmFjpoIWMTuAUSAVjHEIg9Kl14hjlCUQ1vVCNtjO1XpLx27Pi0WwnFRxcex9Zz19DUjhwCKb5bV/PxSFDtrGC93NS8sUQzsMmBz96Fx7P3oxgKfwdHx/AYAdOfq41xzHqT+zUKTUWme16cD6yjPlumRQumzqzyl5Mar/Ob8Cf+w2Q7nnBa6JeeO/Hh6ac9uH7ewZ89tc6SbdmFZMDUJ8HsdAlF/PsjeHuXVRMXeEOH9atOcckflYT9md88vnwJJCyZ6YBucodsMHSPhUK0pLXpQGh8IaYYrk+R1mwaRrNxTuwcNnfaWUSHgEQLwZi8f/YuWIgDokjSz09JoUW+81Cb+DoAF3D9HG0zC05edJ2jbbz9ziNlfyLGpprdwMIIa7tQ6rTXJm71u8ecjCKsJUvxDmxe/MZv3g8pDTUBFC088RoZJQ0fg2a/coKZselhsB8
 epEoJKAH
 /bSEEDQnmCDE2ruu1lPp3LBD0yibPlAQn1TskWPqaKzZMF+437dTCUsVdrBFRDWDXaz24ZbDKpTLdl4/aoGh//KzXaUa+6xJ61F3iloAE/ju1Jzck3HnycD9mullZ532jqnqYRAuwVuvXH8RxOAhxbeE05XJ8oiY4YYlxY3Z450hY6moY4Uttil9iirIg4jyfV6qnQuVnZefjpRl6N+MnkQLcAlmy9t4+25MhwjnkUTR6Tkg2AhFO00OBOoMtYycxthQNK4SHJu0KUSm4xPjQbnntRvvlAePY1XhRrPsX2fIPkLp3eAzeUKLLwvLkJPTjdWAb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21 2026 at 10:30, David Laight wrote:
> On Thu, 21 May 2026 11:06:57 +0200
> Thorsten Blum <thorsten.blum@linux.dev> wrote:
>> +#include <vdso/page.h>
>
> That is already picked up otherwise PAGE_MASK would be undefined.
>
> The whole vdso headers is a mess.
> I moved one of the definitions (to do with bitmasks) back into its main header.
> The vdso compiled fine because all the 'normal' kernel headers get included
> in vdso builds.

Which is just wrong and we had subtle issues due to that in the
past.

VDSO is a pure user space library and just because it compiles does not
mean it is correct.

Thanks,

        tglx

