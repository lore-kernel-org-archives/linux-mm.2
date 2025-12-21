Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6B3DE67482
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 15:27:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C78E6B0088; Sun, 21 Dec 2025 10:27:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0763A6B0089; Sun, 21 Dec 2025 10:27:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E99026B008A; Sun, 21 Dec 2025 10:27:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D9F4A6B0088
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 10:27:21 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 797AD14087C
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 15:27:21 +0000 (UTC)
X-FDA: 84243857082.04.BEB35D5
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf13.hostedemail.com (Postfix) with ESMTP id 510892000E
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 15:27:18 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025112201 header.b=d4LBr66A;
	spf=pass (imf13.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766330839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jlKsAFeaIV2hMkoHG30hkHGQj8Sy9Pccwd7CmoKW274=;
	b=8QyTYH60LQtjpOdQbkVxwlromDXV1LAbM20i0jKmYA+kbaB048HDGo3RKrp6k0A0S6o9zR
	yYDgacLI4KmVuWKpFfrdfWeI8/hNU0sQCmngHCmzWc3gQ61Y/g1M8k6ROLG/i8v1Uk2W8a
	Ovf/ZE5+/vwWDnLyl3B+MLthIcvzpEA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025112201 header.b=d4LBr66A;
	spf=pass (imf13.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766330839; a=rsa-sha256;
	cv=none;
	b=VTaqDihQFfa+sbfXx2ocsy59nfCbFLVRklvrCWUEZREgQQi/MD2Uq+fpvOTOJvDoRC2XHq
	lquV75kJI41gulWQy1uD6RPeMCXrtaYOUoS9wojY5/4kaiPGXyXCkJHl1ckf81jvrt2UWp
	vU+oIkosjJ8aC2I2/p9vUU0FJ+8XyFc=
Received: from ehlo.thunderbird.net (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5BLFQAQb2906325
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Sun, 21 Dec 2025 07:26:11 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5BLFQAQb2906325
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025112201; t=1766330779;
	bh=jlKsAFeaIV2hMkoHG30hkHGQj8Sy9Pccwd7CmoKW274=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=d4LBr66A/lMYsQQUrfpraHzgjeSyK6794g+KDFvXyLiRZzLUKCZVKw68GdUqnufZZ
	 +NAvFJ1Tc1JY5HEDmF0egLxtTnk8IAec4qisamrjj52wF9Zyd4QozYprO+iiGUZQJU
	 c2fm+Em7HTcQi1P/wvEzvyQwP9GZuEEsuyscS4GLVm8IDRc8zdqM36lHHl3R5uLzaZ
	 l6bZyDuDsP+7ONg1mrdK0BrGIdBfrsgOE07sYDDOHVvHchBTA+qa7DJxFrF2DMYbxm
	 Nho6yO0DvkfLBbFDJfdtimxRjHn09lg7IcBD3DPpHB3/L17Ujb74vSiGQta0IdSzu5
	 LQhxq3/8OdW4Q==
Date: Sun, 21 Dec 2025 07:26:10 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Arnd Bergmann <arnd@kernel.org>, linux-mm@kvack.org
CC: Andrew Morton <akpm@linux-foundation.org>,
        Andreas Larsson <andreas@gaisler.com>,
        Christophe Leroy <chleroy@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Matthew Wilcox <willy@infradead.org>,
        Richard Weinberger <richard@nod.at>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>, Michal Simek <monstr@monstr.eu>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Nishanth Menon <nm@ti.com>, Lucas Stach <l.stach@pengutronix.de>
Subject: Re: [PATCH 1/4] arch/*: increase lowmem size to avoid highmem use
User-Agent: K-9 Mail for Android
In-Reply-To: <4aecb94f-e283-4720-96e5-1837352c3329@kernel.org>
References: <20251219161559.556737-1-arnd@kernel.org> <20251219161559.556737-2-arnd@kernel.org> <a3f22579-13ee-4479-a5fd-81c29145c3f3@intel.com> <bad18ad8-93e8-4150-a85e-a2852e243363@app.fastmail.com> <a2ce2849-e572-404c-9713-9283a43c09fe@intel.com> <4aecb94f-e283-4720-96e5-1837352c3329@kernel.org>
Message-ID: <D1726374-3075-47CF-B2FF-FBAC11BC962C@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 510892000E
X-Stat-Signature: n77h6osgko5c9knguauhj465jwdqy3tz
X-HE-Tag: 1766330838-358147
X-HE-Meta: U2FsdGVkX1/qWuWcvssZfv4QDsU/E/wETit4q9C61it2rVp3LD1aXNoqwOELWPGJtTKc6QkKpyY80M9uXZW5sVqnNoB7KG8lpcwHpWVFwM80na3Cgl65cefCkew9E46s8O0LZlI5Jv3IRMiQRCzpLg1MABri09ORuVNylwZ3ZXxh5aiflqY1jmm0kdFxeV4K1TniGMNM5q8x1SiWH30pfT8QcrP42MhI5eaGWyC3/VlZiv/6RyWBgAUarnY3Xs5084TZlh//ulWrtJyN2dZ3k7IuexfM1VX3dKIF9X2+RFMfcJa4eEU13hh7QM77YptJza3Hd+44A3fLqJLauktN3K1VpIK3oElu32N0C0IPb7QU7raLcMzJHz61mGIrcVGGfdE5nPx8XQvytvwVLrNcGhHifpaAZK66Vlw9sFyesro8LeO4MDXTlA3zF1W2situ59t2Xi7/7rx+GqZmb41tGXJwyxnytGcwdyrvuR3mlmGi1R9jK1VDGOCbwN4ZzOqh1JobMH9ZJ/j2dFcP1gBsfmTOJ0VdnXrnhAPxhKnaEkDQXWZwhrXzQbf7VE0qdMhh3TjCaau82t1s09Zvt5gs5zFHcIjB+gs0Ok8ONURM2gbgcUUzJON48WvWIeEJlxURjghaGkqhZ1XahotgArqSfFw5tiiQYa3nv2fX6pHzy6PwDuh4qnVoFH3ZFrvN/aDMzdoYrS8eC14sbBEEbGN62N4vk9LThP4dYObKr2QSX4TMoMVpQI0w0BsP027tCXzNuiRTTgOyZxhXy4p2mAdNL4+D19TbTHvd4AP3btPQrY50Cys6kG76zQu0JvQcJo5Jszrwi2y6sQ9h8oEw27qHVs7olfq5UVbRYzlVx/zTUGwx6NxqJA65H75x2zC+S98Vvh8ETnBqArfgGMbtKJY60DTdnZvt6O9OTDBeIpJ0YwtvrxDyGrSX66k5ra/on5WC9WysHX6yFaKD6zCiIRK
 8VkldG+/
 5YqRi/P73XdGMPfIePEfX9zWu2xgfISZTu19rbp2stYa8zwM+HR5cgmKz8t2QYDOLVdsAVOqDz9Rm2vYpmHaan0iG3LF++/uGD70D63abmv12Em3ZD9zy/0xiUajuFGdHMOowVmDOqOoTwi6q2ywaZyh6yVNJoJj0cWQLmeUCP6iXc561d7m/Q3IukBkOEAaoY9lL43XrSwN2ynRQ+vfEQFDejoyj7kbYNKhfF1Ka4myCPXLquSW+HERY0b1cxXUkSYCk8rvK+HIRVIo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On December 21, 2025 1:30:15 AM PST, "David Hildenbrand (Red Hat)" <david@k=
ernel=2Eorg> wrote:
>On 12/19/25 21:52, Dave Hansen wrote:
>> On 12/19/25 12:20, Arnd Bergmann wrote:
>>>> For simplicity, I think this can just be:
>>>>=20
>>>> -	default VMSPLIT_3G
>>>> +	default VMSPLIT_2G
>>>>=20
>>>> I doubt the 2G vs=2E 2G_OPT matters in very many cases=2E If it does,=
 folks
>>>> can just set it in their config manually=2E
>>>>=20
>>>> But, in the end, I don't this this matters all that much=2E If you th=
ink
>>>> having x86 be consistent with ARM, for example, is more important and
>>>> ARM really wants this complexity, I can live with it=2E
>>> Yes, I think we do want the default of VMSPLIT_3G_OPT for
>>> configs that have neither highmem nor lpae, otherwise the most
>>> common embedded configs go from 3072 MiB to 1792 MiB of virtual
>>> addressing, and that is much more likely to cause regressions
>>> than the 2816 MiB default=2E
>>>=20
>>> It would be nice to not need the VMSPLIT_2G default for PAE/LPAE,
>>> but that seems like a larger change=2E
>>=20
>> The only thing we'd "regress" would be someone who is repeatedly
>> starting from scratch with a defconfig and expecting defconfig to be th=
e
>> same all the time=2E I honestly think that's highly unlikely=2E
>>=20
>> If folks are upgrading and _actually_ exposed to regressions, they've
>> got an existing config and won't be hit by these defaults at *all*=2E T=
hey
>> won't actually regress=2E
>>=20
>> In other words, I think we can be a lot more aggressive about defaults
>> than with the feature set we support=2E I'd much rather add complexity =
in
>> here for solving a real problem, like if we have armies of 32-bit x86
>> users constantly starting new projects from scratch and using defconfig=
s=2E
>>=20
>> I'd _really_ like to keep the defaults as simple as possible=2E
>
>I agree with that=2E In particular in areas where there is the chance tha=
t we could count the number of people that actually care about that with on=
e hand (in binary ;) )=2E
>

So, maximum 31? ;)

