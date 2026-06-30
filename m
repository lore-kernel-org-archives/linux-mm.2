Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30C57C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 09:11:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BDA96B00B6; Tue, 30 Jun 2026 05:11:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 096926B00F8; Tue, 30 Jun 2026 05:11:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F16116B00F9; Tue, 30 Jun 2026 05:11:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CDF606B00B6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 05:11:41 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4E40BA042A
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:11:41 +0000 (UTC)
X-FDA: 84936011202.13.9382B0F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 734FE1C000B
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:11:39 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="hAZ/XGAW";
	spf=pass (imf18.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782810699;
	b=L4otET9tEE76rjZGMgeVJmh1JLPye0km8Ql2ZzIWJY77QKXWHNrVgT9heb8Nx4aMzF6NnV
	rl7fG6cqi6ykqRaAIZZCP94BHju+kOKUvrED+PiazvRNeiadPJsRASIdTtXOsO1TuCKfj2
	yGEvK0u0Z5Gyf18n10pbU/FAjOZN4H4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782810699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b3mOfrJH916cwXqr+ZvwGijVGpltGH97Y0po0aXz5kQ=;
	b=UVA/DMT+tJ9BcWhzaPwEpo2rbVsDrXAi//VhjT6EiEgH3YibTnahIuiquSQ3RW19JSnHYY
	05RNJZaZoRyyNNMN71elJVjTkrmQxndrIjOkqT4RgzNz6cVIlYQlH1jSC7sm1goWuGuBwQ
	5yFvJ6yjwkgPCp7RD2z65eXARFGYUTA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="hAZ/XGAW";
	spf=pass (imf18.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CDF6F2C1C;
	Tue, 30 Jun 2026 02:11:33 -0700 (PDT)
Received: from [10.57.81.132] (unknown [10.57.81.132])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B07BD3FAFB;
	Tue, 30 Jun 2026 02:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782810698; bh=Fp0iKtIQ8WSu99tEd8oJ9ZJXm1jtTIlwqw7RjhGDc+g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hAZ/XGAW6u+JKDyTjbV6aaMnWKHnBmN3C6nhJhtMaxQUv8mY4WutOy1CIUH1h5PaP
	 P/y6MGDQDKu+Z19IQ0YpQlt8bdC9TQbsdY9hXxRS0fUKaQ9OtMPJ/oObIJO74x36xf
	 UBWKMVwAmj18UEiY9Kpxmydd0hlAYSLfzTocchLg=
Message-ID: <94cadab5-41c9-4127-aef3-14cb25415363@arm.com>
Date: Tue, 30 Jun 2026 11:11:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v8 01/24] mm: Introduce kpkeys
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Linus Walleij <linusw@kernel.org>
Cc: linux-hardening@vger.kernel.org, Andrew Morton
 <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Ira Weiny <ira.weiny@intel.com>,
 Jann Horn <jannh@google.com>, Jeff Xu <jeffxu@chromium.org>,
 Joey Gouly <joey.gouly@arm.com>, Kees Cook <kees@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Maxwell Bland <mbland@motorola.com>,
 "Mike Rapoport (IBM)" <rppt@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>,
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org, x86@kernel.org, Lorenzo Stoakes <ljs@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>
References: <20260526-kpkeys-v8-0-eaaacdacc67c@arm.com>
 <20260526-kpkeys-v8-1-eaaacdacc67c@arm.com>
 <70f4dcdf-c45f-47d3-91df-a7897bd86ff4@kernel.org>
 <CAD++jL=km9hqTuTMFUhyx_QPuMEwWqmnUVQtPtMXnp8paHH1_A@mail.gmail.com>
 <9b11b0c0-dfc7-45ba-934e-19cd053e5635@kernel.org>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <9b11b0c0-dfc7-45ba-934e-19cd053e5635@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: c7shhjbb44gtoosyr3dj9j47gr1mxnap
X-Rspamd-Queue-Id: 734FE1C000B
X-Rspamd-Server: rspam06
X-HE-Tag: 1782810699-464740
X-HE-Meta: U2FsdGVkX18b8Ra6D+DOhUdawL4x31VMJ/wBFgoLHswgSn9GTBlNOOPVZ9B4unyiU6vjqOjErNQs6TN1kXt3P0tPhUFRuUHPiFc/cP6ZI+aNXL/Ck5IkRQBqy70R3KKmnMI1OM4C/yxC7aXy1SDsdJntTbhEaEZsqZyQJ+v0te1coHCyuJXyqiF9UtCpbkuN7QPCczRowqEjjqlmNv2/8yM/nzwUgc4iS9lHAd0o7AgWf9+29gj97VHU8RtOXao+lVF6UKgc0roYchYlB7XNscQ0Pe+Vs3BWW7GW4ulh5qjrBnmZXCqmQZCA89m/yuK5FlopPRCi+8WewJ4FqtvT3EzMON2PYleaEt8J5tZ4MSJWRa/uLEhue4yVUbc0EASh5+YmJJ8SU0PfXhVoWkeusrvdD+LXcqnVPZ7i8S0q08V5vqhVoVovqh1Y6mwa4Oav8Po9QE5VctOIh9A7wMe+ykc9r7zEVkgHbPoHl1VR9/gfVfBvtlLo1tHuLk2N+xlNQhNdBkdFQJVTisrXE6ityumbYJigAGoZpnpn5GgYlskQMbaKeNrNB2EhNyul2HQi8psqDIrGQxBF9vQwk3kcxjrMPNu3/c4ShaaxhFWfw3z14T5JL7NBpztdhsXlgdhRRczrDH4JzMwzVSWJVXlchc2iO2Khw9H+2jyB/EsYWHXsseZ/hkC0qqEAsrC7Gn3ryENrAxFgD2VyYEqqNZtjWYcb7msGwLs8R9hJhS4NU/rGVD1kY+iaGHu3jc+M2wd6J8a5w/6ZRCGwAsHiUElnphlm1+PEpEG81c5Ef0Ouemvwi/LwGGGpLJLIDbD2Wd2HD1u5XzsojPGENzXePktPxAQ/kSJJvAEwCZVx+3WPZIVORIyS3i7JiDwVB1xvhfBQOF+BRhIuxsTXNPg1pRC+Cu/RZPxpgySRVS5yX3l3qlcfxSggoYBRhGFaZRQyrrPxAFRjYeVTThv/PLetHDo
 a11aeqHD
 ymcLF8qRPGS2WX0iA9YQ3neO/i6bW6cUhsgSP3BohloGaxvW6GS8RHdOiycQV0pn2+VzueARC9tS7cT6CYkC4F9OLndDeLnum1erWoAgYGdhb0nn6yjThkdSDxYCTac0BvQ2bYD5mrrJWDaY2C0ig1qlok9Hf21UkZJyVW2gbDByM8txnRFvtB+Izc6kC1Ujr9tRcEACZrJHlHC6H2kq1IkT+4+eta3IM5iTWy0QOZYEF67042qQdUfPaNOAnT6VoTH8wyS5PNGDagsk9khllsi3cjWtK9EDn5mpj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22/06/2026 20:38, David Hildenbrand (Arm) wrote:
> On 6/18/26 15:22, Linus Walleij wrote:
>> On Tue, Jun 16, 2026 at 5:19 PM David Hildenbrand (Arm)
>> <david@kernel.org> wrote:
>>
>>> Looking at this, and wondering about "why do we get registers involved in this
>>> API" I would probably have an interface like:
>>>
>>>         arch_kpkeys_enter_context()
>>>         arch_kpkeys_leave_context()
>>>
>>> Whereby you return a "struct kpkeys_state" or sth like that.
>> This is close to what I was looking for as well.
> Cool :)

That's probably what I was looking for too, without knowing it!

>> enter/leave makes the code look more like generic entry.
>>
>> Passing some kind of state cookie around is inevitable in
>> this design and IIUC Kevin argued that it would be inefficient
>> (another level of abstraction) as opposed to just hammering
>> in the context we want, where we want it.

I must have misunderstood what you meant in your previous comments, I
don't have a concern with performance here.

>>
>> But I think the compiler will optimize that out by constant
>> propagation if the backing architecture implementation is
>> simple.
> Yes, it should be wrapped somehow. I don't think this will be a problem
> performance-wise that cannot be solved differently.
>
> Returning an u64 ("register") here is really arm64-sepcific and should be
> abstracted.

Agreed. All this looks very much like the new lazy MMU API, and doing
something along the same lines seems perfectly reasonable.

- Kevin

