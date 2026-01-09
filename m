Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0848CD1A62E
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 13:38:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66DDF6B0088; Fri,  9 Jan 2026 08:38:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F1886B0089; Fri,  9 Jan 2026 08:38:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FD9C6B008A; Fri,  9 Jan 2026 08:38:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3DE306B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 08:38:00 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E149BC16E1
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 13:37:59 +0000 (UTC)
X-FDA: 84312528678.26.F6A70C1
Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
	by imf04.hostedemail.com (Postfix) with ESMTP id 07ECB4000B
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 13:37:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=FJlY+lwD;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf04.hostedemail.com: domain of m.wieczorretman@pm.me designates 185.70.43.22 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767965878; a=rsa-sha256;
	cv=none;
	b=dVbgsnG9wJjYTE4HnGUpjWDQcpsULqkH+nXpkH/5QRYz28ip86bQPMOWuKv+JUJv9LUP5h
	EwoioNd4wtV513wzxjv4p7jNY+Ph8angttlBx2EfHS4I/8Vsf4yFVUwPRXIy8E/GFrA7kc
	+Zo1z5yyv2bK0FEDSITqCk7PWsu0onE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=FJlY+lwD;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf04.hostedemail.com: domain of m.wieczorretman@pm.me designates 185.70.43.22 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767965878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j3NjXkb3MtCkcFp1gZdZbK2WKHYzWPAkjB9Zixe5dUM=;
	b=UvkKFMKg71y7ufjYC00JJPORKKezwxLlpvMH+tRtlvO1IOloZ49KB4cQwiQm3kVUne3fTP
	lmjWlRP1by858+MlygmDGCuMEnSqa2UWDpGUucFmh+Ludzd4wtLlJN9oxAGUZ7evvRfs0c
	b+/8WTVZIRu9gaFkppKzUAe8VMgZgCc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1767965875; x=1768225075;
	bh=j3NjXkb3MtCkcFp1gZdZbK2WKHYzWPAkjB9Zixe5dUM=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=FJlY+lwDEWrue3SxdKLkdkB5DgiHZE10OAmfbtbcwa0yXF8Gs2rPlo2EwsJNMBsw/
	 DSDjj3il1VqHvr6UL38tEM9mqmyyoin9Az51E6NrV3DrbZvRG4ucXEOQ9gHS9IhPHJ
	 pIETU6HZbmW/n2hQyKX0kQdqA3brjZzZwOY050bokoLyUPdliNpWip/hoLYy9rHpgV
	 dxtSfklbmxvCVSMfujG6ICA2t7K626MZ491sP+4F5iEbVKsaJsudTqRyZM4qfp7dAF
	 K0gVFbG5hB7LOnnc2Czvk9WFEP6gunL1dDOi/2IOYZoluUKDoly8XKz5Ot6ebZONND
	 e1Mf8H90vu0JA==
Date: Fri, 09 Jan 2026 13:37:49 +0000
To: Will Deacon <will@kernel.org>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Samuel Holland <samuel.holland@sifive.com>, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH v7 02/15] kasan: arm64: x86: Make special tags arch specific
Message-ID: <aWEDDjQms8zbMgsB@wieczorr-mobl1.localdomain>
In-Reply-To: <aV_v18YWCHXMETVK@willie-the-truck>
References: <cover.1765386422.git.m.wieczorretman@pm.me> <0db7ec3b1a813b4d9e3aa8648b3c212166a248b7.1765386422.git.m.wieczorretman@pm.me> <aV_v18YWCHXMETVK@willie-the-truck>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 0570fdf76a1b4710800e4cf7ba907d1afc4ce5d7
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 07ECB4000B
X-Rspamd-Server: rspam06
X-Stat-Signature: zdmjxteg3ecuw9nttwef6ahto59o1cco
X-Rspam-User: 
X-HE-Tag: 1767965877-902813
X-HE-Meta: U2FsdGVkX1+M/GMfczPP+FgwK4C95E27HyYC9QS4QFG/yTCUgpAmmSqEyDc2mGpeGFvHmVnx5QZnEojICj1RcVaAoYYnSeJrmagZZDc3g8auMlS5Hb8dTqrGd2wyAJU2FnZJb9lmiEPfba/QXNf1zF79Th9RAi942MvG5RKd3E4jZHFMyDDmBuMuGqFJcu+2RP0y/G2kfJhH+MwDCFVITMB9b7gYrmnU5LuwsGsN31Gl6eCo+zA0IzH+5edivAayVjqiZlIM0NML3zargDhzByHBZR6zDojcP5TpClTqTzRhSroF/tke6NrYBNYbOaYTvfFkmIpRLxFVHIVzQSfYRYpS11byPZncXzkY6k+ykPIB2MisHVzufq0JNWP7lvXeI9Zf8nF/z425f+D92iosXFXMrt+AJSfpCuGJDdoSB9YD5OfrnnVRYxQ3xa9GWE/aloLKFhY1QidVJ8PGFyaNmMfvHd6UV8Ehr7Cc0aKu3GU6qn9oPHw7eQVU7DVAJXluIKQOz27Iq3UdcdA9mSSxWfrJA3H6Z827Ww9R4cwOB44IUzV7UmLbzk7+6ushUHHAa/Xu59mTKAhB+6qK78BImIbeC1Kjn6OyU3fJ3nr52fxwCF/FAeomCEMeWRBHf1mnnhW/NJHpR8YPQvEgz+7UdiFOJS36ItcyEkj5h+M6r7vxirf8FqjK3nbSKCotbkgjfmXs+15xLV2v4yxvd+/zDhpAVaX+kuNMG2rJgCnoYpjbXKbLRFs+cCLe13r6U2BBk5h1JdeCfhK6PtgY8AGro+Gi5BGi5aAENNRWvowkbEUbPp30zy3YqIQzuPhe7qpa1uYA/VT7HVyFCnNLbNffu3YQ820amdFWupNxEIqn1I/omx1K1jqMlM2G9cSnrAuk9QsMm20rfpJeNt0okmXA0pwul1m2s9zxrgWtNW/ryeyjuQrxqw3QxJe9hkQ7YCvYSrhclBsSCal6loC3FXi
 PlMgcfr2
 Dgh6UQXe3DgFQtD/7cm4gDry/c/4IZp734BxNAkxtfn/fZDXx9gpPgVZLLX/8XNKVVCg4nD3UQJBUKe9N63ND+rZt8EFrljJ3LrUiNth61uQ9jbZQvv/LxIkpbMidTG3P3jF7Tq5VRZ7X1EskQtE2Nz9Wiuy+4vvE8T2jHkNBuelkADzL58Yr/WJ38YBZjhtxZjxLryJImNR9xiSZbqormhVAlmCYmEoIiE3Ye30D1Y5k6PRdTifZ81JrQ15DlK1foY/h3cTn1Y8AL2+IIa7a97cZctphS0s8hz8J3q0Fd+AosVY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, and thanks for looking at the patches!

On 2026-01-08 at 17:56:39 +0000, Will Deacon wrote:
>On Wed, Dec 10, 2025 at 05:28:43PM +0000, Maciej Wieczor-Retman wrote:
>> From: Samuel Holland <samuel.holland@sifive.com>
...
>> +#ifdef CONFIG_KASAN_HW_TAGS
>> +#define KASAN_TAG_MIN=09=090xF0 /* minimum value for random tags */
>> +#define KASAN_TAG_WIDTH=09=094
>> +#else
>> +#define KASAN_TAG_WIDTH=09=098
>> +#endif
>
>Shouldn't this be 0 when KASAN is not in use at all?
>
>Will

This file (as well as the x86 version) gets included in
include/linux/kasan-tags.h:

=09#if defined(CONFIG_KASAN_SW_TAGS) || defined(CONFIG_KASAN_HW_TAGS)
=09#include <asm/kasan-tags.h>
=09#endif

=09#ifndef KASAN_TAG_WIDTH
=09#define KASAN_TAG_WIDTH=09=090
=09#endif

So the 8 or 4 value is only assigned if SW_TAGS or HW_TAGS are enabled.
Otherwise it's set to zero.

--=20
Kind regards
Maciej Wiecz=C3=B3r-Retman


