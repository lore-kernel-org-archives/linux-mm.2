Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B06DCA9EBD
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 02:57:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D657F6B0095; Fri,  9 Oct 2026 22:57:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D16926B0096; Fri,  9 Oct 2026 22:57:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2BD26B0098; Fri,  9 Oct 2026 22:57:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A30956B0095
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 22:57:10 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 37A081C404E
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 02:57:10 +0000 (UTC)
X-FDA: 85305205020.16.DDABCAC
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf09.hostedemail.com (Postfix) with ESMTP id BF9EB140003
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 02:57:06 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=SaSXpE7b;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791601028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j5jEa26nyH8IslPvDz7idIbI8zvRhCKMtempuPJaz6w=;
	b=cXX6MvEsEbe9qopk6LgPyqFDlGQqmJ6yJ8eQPXhDYBzvU0aQ1J0SURxFRK1mB69cm2yeOq
	ai6Yq7LB4IUAGxAhy2LH0Od1MPnp9OkzbAJ2L3svCIwuhF9iKYJVJolEf6cBBH18+tqX2T
	gxrMgp+qkb/IIKsBpJBWcXFwSmXhn5k=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=SaSXpE7b;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791601028;
	b=F9cqQZR6Cr00aEQL+/UCkvdtpeen6ii7m3/d0gwengjigqkMO7PjBY3lyknN9e+Rb13a0k
	20SByvVGIkjLGtTJ1mQhk9fBCWmB7/XVwiAh7Zr6NbBW7cXOAXM/JVeSum7yuGjBfJwG8q
	W3VjG6mvHGClP+/qbp2q+qcnRiR8h/A=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791601023; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=j5jEa26nyH8IslPvDz7idIbI8zvRhCKMtempuPJaz6w=;
	b=SaSXpE7b37xDpChoJ3sdv3DOUKfklixKOXDNzhG8nRL2KOxNRpsJEpOgF6KpL2z5l0bRScJp4UbegLHF8EeZjn6yNFBRKyPG0j1b1Oq+sK52k4++X0NDZAu10Zddo5tbNvm03XVhcYRvaSuUlEDBNd8Ltcp7vQvYtYd7S48D+6g=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XCUyC8C_1791601020;
Received: from 30.74.144.133(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XCUyC8C_1791601020 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 10 Oct 2026 10:57:01 +0800
Message-ID: <1b77c2d7-acc6-476a-b5cd-547471a46409@linux.alibaba.com>
Date: Sat, 10 Oct 2026 10:56:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: memory: fix truncation removing mapped folios
To: Pedro Falcato <pfalcato@suse.de>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, akpm@linux-foundation.org,
 david@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, qi.zheng@linux.dev, jack@suse.cz,
 ayushr@modal.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <0d2a1809fa1cfc22ad3df26ec28b2d30e5cdf3bd.1791540483.git.baolin.wang@linux.alibaba.com>
 <asjXJZap53yJWMYi@gremlin> <asjr2zCp1BVtfpTV@pedro-suse.tail5790ac.ts.net>
 <62e0ce97-1016-4f82-af38-7703c8cffefa@linux.alibaba.com>
 <askdZgd5P986OSMx@pedro-suse.tail5790ac.ts.net>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <askdZgd5P986OSMx@pedro-suse.tail5790ac.ts.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BF9EB140003
X-Rspam-User: 
X-Stat-Signature: 9okine1pb1szug4697kurgx1oh5jy9k1
X-HE-Tag: 1791601026-143555
X-HE-Meta: U2FsdGVkX1/KRYqJiJ2pr2kmzwxxOSj7spmo+/M1HjDlN9ZvXCSujCiDMv1OthykjYcDiVnSgqDSwGZdzBqs1GnyCFHEoXUJdGnqXM0v0XtK1q9haDFPJoTe6hIcIwZGK4Ha1q8lBahNxm0uMYrn00qjpIweWfMnXGQibIKNe4JC2Xx714e6WdjumecJ0IvYpXBpBjMZ5sv7U05+8EtaSmXzPW8x9C9AIhlxXoJzQ9ug2q/BK4J2fknaVxJjrqAlUgrTpfgrIpZ4GMj+DaaCpbXdY30X53ZehaECnbTeESynuN0R1LmYdVG1qYBQRxNeXZxmmCAsz87zVwPH2WbJpeISDSa97Eg+Z+y9uyh6JOnf/9ZMKpN/bky8RVoDzHAjKjyIi3+nxBqsbI2ziJ+Q0Zxy/LkdHUvhhjDME6xeBsdZ4fjwfeEhnQ61t7E/lAavNLLNMXO+Gvmdcbqh7gDsKs7xs9VwYv7ciIcLHCf4ufDxJtVia+O+PK5SbWwQT5p8t579MxbYX1o2voGqDdaXkq0dWB9xIeKPF2xZ6ZyRAfCtXqsvEIktRBYFPhGgk+nxIPDVoqYCTshH/XINntsXWHTCJ0J3ZjuRaevoI+0i7XL4CBwnz9jFvp17KFWOKz9BC2n2kpLhti/us3G+r6pVPRsIachgtxyP7KgiVa0mUa8KxY1pwtL20cMbKF1YfjPgSrVR23ixHfPTdfm5UUTZxhl+gExZY/f027faaUBldxqmN7zS05jUe//g9D8g8nEzdhloEgyi3NckQDAKfsYqTSo0c7NKbqM4+rAJxrRN8KI6WhdfRY2Tpn0hMaQCgzsRllJ2lByqHN41MLo5hmDsQG/UmO8k4Y4iVFF7B7AuopX6PU2p3nJJg9kF38/EwZZg6dNSrUy7b67QCvpLWw/0OvUfAGyCT2WrIIm75T8VkzBMSEjT1mIcg+y+XRujOLjavARYU49zFsa1rMw0pVB
 Ym05ocTe
 RKEA9wpRxnp+Q3FzC9TyJZNK0Y25VST0Lg3x27sO0ixMIMB/zx25Hidi3nQJCDT1ZLgkWm+WLw6GxStx0C4oMI7SV06YF5eBByO0QCHGE5ZX6HcaoVDbIM7sTAcR52WNWkE12m5hnpayGKojF+JUyaUqhCSFaL5M7V2L2nGhmj0wdx3RwzZtu4ikaNgAxOHoOXTwnQSZNXiHnLzNLra1y8Qnxvk8FcfNO0afQ7D6X4JSm6bqdP3oDrqdcswW7NQFdjimEfCfDLsPUdgDCoxvt/qj8UTQGQJFfrgjeOFIp9enrwuP3ILejyxASbksYwR0wP0l1DncxwQ2OmnS/dz1lXVMKYR8FMGM2IwPQtLoQvZuIgL8Ne67hzawkkzbPs63qMeTLdcAajavK9PRNQFDCZgotl1KH1zbjaO/RAkMamJLuPoE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/10/26 1:01 AM, Pedro Falcato wrote:
> On Fri, Oct 09, 2026 at 09:53:55PM +0800, Baolin Wang wrote:
>>
>>
>> On 10/9/26 9:36 PM, Pedro Falcato wrote:
>>> On Fri, Oct 09, 2026 at 01:00:52PM +0100, Lorenzo Stoakes (ARM) wrote:
>>>> On Fri, Oct 09, 2026 at 06:12:03PM +0800, Baolin Wang wrote:
>>>>> diff --git a/mm/memory.c b/mm/memory.c
>>>>> index 1f5d5f7d39cd..0272217ad7b0 100644
>>>>> --- a/mm/memory.c
>>>>> +++ b/mm/memory.c
>>>>
>>>>> @@ -2044,16 +2053,10 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
>>>>>    	 * to ensure they are still none, thereby preventing the pte entries
>>>>>    	 * from being repopulated by another thread.
>>>>>    	 */
>>>>> -	if (can_reclaim_pt && direct_reclaim && addr == end)
>>>>> +	if (can_reclaim_pt && direct_reclaim && addr == end) {
>>>>> +		/* rmap changes need to be observed before e.g PTEs get zapped. */
>>>>> +		smp_wmb();
>>>>
>>>> What does this pair with? You should always say what in the comment.
>>>
>>> Yep, this is missing a rmb to pair with. The diff I posted at
>>> https://lore.kernel.org/linux-mm/asigKktcrSY80A_2@pedro-suse.tail5790ac.ts.net/
>>> had one in zap_pmd_range(), which admittedly isn't the greatest. I'm not sure if
>>> there's a better way to do this.
>>
>> I don't think we need an rmb to pair with. This is because the
>> folio_mapped() check in __filemap_remove_folio() cannot be reordered
>> (guarded by spinlock) with the pmd_none() check in zap_pmd_range().
> 
> Why? spin_lock has ACQUIRE semantics, which are one-way permeable. Earlier
> loads and stores do not necessarily happen-before anything after the ACQUIRE.
> Unless you mean something else. 
A simplified view of the memory access logic on CPU 0 is as follows:

down_read() -> Acquire A1
pmd_none(): read pmd
up_read() -> Release R1

spin_lock() -> Acquire A2
folio_mapped(): read mapcount
spin_unlock -> Release R2

Initially I thought the read to folio_mapped() could not be reordered 
into the preceding acquire/release section, but after re-reading the 
memory-barriers.txt documentation, I realized that it actually can.

“
  (3) ACQUIRE vs ACQUIRE implication:
      All ACQUIRE operations issued before another ACQUIRE operation will be
      completed before that ACQUIRE operation.

  (4) ACQUIRE vs RELEASE implication:
      All ACQUIRE operations issued before a RELEASE operation will be
      completed before the RELEASE operation.
”

A possible out-of-order access sequence is:
A1 → A2 → read mapcount → read pmd → R1 → R2

So yes, you are right. I'll add an rmb barrier in v2.

Thanks to both of you for the review.

