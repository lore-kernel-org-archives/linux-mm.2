Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC981D2E032
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 08:01:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D5186B0134; Fri,  5 Dec 2025 03:01:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AC806B0136; Fri,  5 Dec 2025 03:01:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E95F6B0137; Fri,  5 Dec 2025 03:01:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 30C0F6B0134
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 03:01:43 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A288F13B138
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 08:01:42 +0000 (UTC)
X-FDA: 84184673244.16.4A8B575
Received: from mail-24418.protonmail.ch (mail-24418.protonmail.ch [109.224.244.18])
	by imf27.hostedemail.com (Postfix) with ESMTP id CE7724000A
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 08:01:40 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=mwzwteWz;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf27.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.18 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764921701; a=rsa-sha256;
	cv=none;
	b=4Yh1E/eJ9wcKB4DfFortwY1a035I8vO0dLlym21OtqX/Ou0gNuiBPBrsaOHC7TuHxkDaYW
	hMc9gBjhEqFNtt5XRoQ/PVg3gWFPfMkBBU/d4qeHq9ltxB8POfTfqme5stZ3aUxH/GhH0u
	xihVOdrHqtqiM1vE8I1asOrdYNW0Axc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=mwzwteWz;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf27.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.18 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764921701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zgc5Bfim5kR7lSEF9D/3QfXneWnjNYTl3zLRKpUUg0w=;
	b=L8k4cQ4nnYFNZRDtnGK0q+egwl2VCcF2TZD+SEMpBRYKir2PHb5EGVr7HvTJcrcWLVkodv
	yIIzuZ3m9rrXkhQl10gKNtAT34hIse+qMcjZO1kyGqgATPumskBlV/AeiSF1xdGSJ1TWiO
	6g5HQM11e1eCRet5geCbOAxvReDAxb4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1764921698; x=1765180898;
	bh=Zgc5Bfim5kR7lSEF9D/3QfXneWnjNYTl3zLRKpUUg0w=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=mwzwteWzQ4+P+0EheVmeVZVyCucCeGcOdcgEVReGyJxazYbDrOdG1S7D0jCMUamfp
	 iydGU9+1EY6vFnlYBpjho6eu3YGlllfWJ2wa5oMcArU7QaC4un+wOMvnB64rlc5+XJ
	 jD70CbVLek+OcQzYRzDcZlWFx9rDEpOdvdynAg3HLrrWJiXfjcMU4iK849dVdORqy5
	 dWiuL1WI0jK7e3Bu8kDH2yay9JzGxXcB672cRzePhHmBO0oT0hxTGqCWsV4m7XNQ1y
	 q8gAdM8XXoCsHgwaEKlsUZ5QtgnUFQP4VR21r1c4Nl68QPGh59rwJvpxYkxGC+j5ud
	 WZbdLoJpZ6M5g==
Date: Fri, 05 Dec 2025 08:01:34 +0000
To: Andrey Konovalov <andreyknvl@gmail.com>
From: =?utf-8?Q?Maciej_Wiecz=C3=B3r-Retman?= <m.wieczorretman@pm.me>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, Marco Elver <elver@google.com>, jiayuan.chen@linux.dev, stable@vger.kernel.org, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 2/3] kasan: Refactor pcpu kasan vmalloc unpoison
Message-ID: <mtfitb3vqbcqzezrckjlo2vyszb3ufqgimmpmfhnybrkjt7m6f@3ovjldsuitwc>
In-Reply-To: <CA+fCnZfRTyNbRcU9jNB2O2EeXuoT0T2dY9atFyXy5P0jT1-QWw@mail.gmail.com>
References: <cover.1764874575.git.m.wieczorretman@pm.me> <eb61d93b907e262eefcaa130261a08bcb6c5ce51.1764874575.git.m.wieczorretman@pm.me> <CA+fCnZfRTyNbRcU9jNB2O2EeXuoT0T2dY9atFyXy5P0jT1-QWw@mail.gmail.com>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 2cea9ea5c467759ad35e9323c2a7e8e0c5500488
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CE7724000A
X-Stat-Signature: g4mz1jec36w59eg4atg7qqxztdqgj6ds
X-Rspam-User: 
X-HE-Tag: 1764921700-642928
X-HE-Meta: U2FsdGVkX1/jY7VFWUZiBKLrRCFWQLufqWhZhrUi7s84Nwup6/UXossbMCdWQ9ywZeoeFTzFrSdtABh5PhbKlvGGvG6EAu3tWm70dIzvVeqHFUb2mJRDUP9NoIFrALYevrZRtpunSiX1Fz11Qwl/n/D42q7X82BDapusjws95oy6KEu5g2fFRRODvTjwMGNkw7lHiUZxLtfwuqOcXB6zbMbZDCjIvYDxnss6bLYsK7poNtO+G+Yh+6h/0Ds5tZ4bFkHhsKUTLWdrQVSqdNigOIUDWxcXbtJZD6tvHaf/ncQOxj/0YDdepZph+YBqOtTLsr14fcaTgPEBqcWS+b4t9PIhwDtY0ZvlBqlY5dqX6ANJgyV0CaXu/Y7wxwfsCD/FL1kXwt9+jSni4z4KWvxruc9IYEZIvvijfwS5OBbWCiT4cPySCBqWaMSOVEfaLAtfbHRj4is2Fw7i/8UEJmae37AFk2VBGQthcT2NFOLCrqkJFDqJpPYOIlybrMoz2pUIRGZ5sBl2fsF6a+Zw3qozN9BI1IHwTWn0lX5hno8d/BBdOSmRNwvfzjvDIJN2YWgvKlD5va7DyAvora/rcEWQHz9ROnlej2Bk8BXMY6cRCYtt+fNhWDmA6X8SfeW/wHQ5vK1P4LpwvD4cPwbFzZtUVNibG5dfnmv3o7AHAexYWfB++rKarpxyxnJ6M9NbD+MuDy6qKgUewwcAHHNMLG5mSNHy/DF3rQJmrS83FMuaSVqNYaT6aJzc6p40piPKTnbAlBSQPg2l33+jO6hgvKcYSWbcMYhQaRP6PfoEBOFeh7EBYV5YfYE4LJ8oBoAzmbENAwc7QFkaUK3SQ0Mtjauhmb7kbBBxDchQlECgmeq9zjAy23irqhF+LfNCovcbJq2BAKctXHeZIm2PzOHe2a8D8FUqzyEsZQXxUuXgzeqN6cS0FbrcofWPeSQvryE1QulXQWK216XPTWMmAse/vC6
 4ZdPGDME
 htV192H/VTgtjMT91XfsgESK/JMW5DNPipZqqckAUarF7CIP42iXJoPCugJ79fn3jeBfh1Vv7GWvcpSsZPbXEwMkwmFbv12dCwizjLSNmFwJrYFbX5ilD2lwj/EAPAeC4OBj+awb3VfuOJcMHDIcXyBQ0u3jTOA56Gl7GidydNt8r7LGKGvJCME7A7K0u82hpe/wDr+unwAaGofuVV/izRcC7TacVeB7kGHqlNP2/GGH5bKktn35TnossOY6BrZ4/TvV4K71vwcYOl80b4pgfSS3ukasmTvezL2vpK+7F/zdpmae0uvwPgvCoVUnJHgDDYPlxeMYh6muxAKE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-12-05 at 02:09:02 +0100, Andrey Konovalov wrote:
>On Thu, Dec 4, 2025 at 8:00=E2=80=AFPM Maciej Wieczor-Retman
><m.wieczorretman@pm.me> wrote:
>>
>> From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
>>
>> A KASAN tag mismatch, possibly causing a kernel panic, can be observed
>> on systems with a tag-based KASAN enabled and with multiple NUMA nodes.
>> It was reported on arm64 and reproduced on x86. It can be explained in
>> the following points:
>>
>>         1. There can be more than one virtual memory chunk.
>>         2. Chunk's base address has a tag.
>>         3. The base address points at the first chunk and thus inherits
>>            the tag of the first chunk.
>>         4. The subsequent chunks will be accessed with the tag from the
>>            first chunk.
>>         5. Thus, the subsequent chunks need to have their tag set to
>>            match that of the first chunk.
>>
>> Refactor code by reusing __kasan_unpoison_vmalloc in a new helper in
>> preparation for the actual fix.
>>
>> Changelog v1 (after splitting of from the KASAN series):
>> - Rewrite first paragraph of the patch message to point at the user
>>   impact of the issue.
>> - Move helper to common.c so it can be compiled in all KASAN modes.
>
>Nit: Can put this part after ---.

Thanks for noticing that, guess I need to revise my script that moves
these under the three dashes

...

--=20
Kind regards
Maciej Wiecz=C3=B3r-Retman


