Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43C94606A338
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 07:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=gentwo.org header.i=@gentwo.org header.a=rsa-sha256 header.s=default header.b=SjUybCf0
Received: by kanga.kvack.org (Postfix)
	id 503516B0B12; Fri, 23 Oct 2026 03:37:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DB3D6B0B14; Fri, 23 Oct 2026 03:37:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4179C6B0B15; Fri, 23 Oct 2026 03:37:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 269796B0B12
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 03:37:04 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ADD4AA7D95
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 07:37:03 +0000 (UTC)
X-FDA: 85353084726.02.316DF12
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf25.hostedemail.com (Postfix) with ESMTP id 05D64A0006
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 07:37:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=SjUybCf0;
	spf=pass (imf25.hostedemail.com: domain of sh@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=sh@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792741022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kCICkMhdloN2vOZs6TT3hOFLpHVo0v/saupjPBSOnA0=;
	b=sJiH84NTwgFZi0e0ogKBsyBshhrDnD1JMh9FFd68U79eMKj/FSDkKUsLfNi104rhaOu2ed
	hILI3xw1HpQjXY5dr7P4Bdi1smuM+tBEo1KHUDjnBpXPGgtemXkrPRv0bBRAXjoqe4/h2l
	iSkEY3cmKVkq+MblWMwZrBaVDM3C7zM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=SjUybCf0;
	spf=pass (imf25.hostedemail.com: domain of sh@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=sh@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792741022;
	b=20/n92sO4Y5JNwxJZPKeu8Fy8gKLrb3Hg3xlbn6vfew3vuI9SFz7NyipyBvetym3mKPFFA
	YcrzA13zeRJ2m99GtoRHgOere2Gf32lLSKrNCnjZGaq7dntTzGTVeh6NMxD1IEszLFv9e7
	PSeaYzKTGUu0TO71Nw9VFfZD/choRak=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1792741021;
	bh=36DO8i2bkr8z2JQZQxXEchKKItiALErgWh8fLAo6Zz8=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=SjUybCf07Vef3W8cLyBTd8TuCKWahdmE5eYY/hc9Qek4VWM8dVNwyT5VR4g537vKt
	 g67ZnAuTxU7bkPfJIwuGoMUbZORN2NsB0FJ4MLvbgwuBqNGjq0lotWhDEZp88qEJRF
	 AkV30enxYOXWdgNdqh26aJTDXdQEq33I8JwCTmPw=
Received: by gentwo.org (Postfix, from userid 1007)
	id 0974340263; Fri, 23 Oct 2026 00:37:01 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 0672C40261;
	Fri, 23 Oct 2026 00:37:01 -0700 (PDT)
Date: Fri, 23 Oct 2026 00:37:00 -0700 (PDT)
From: Shubhang <sh@gentwo.org>
To: Dev Jain <dev.jain@arm.com>
cc: Andrew Morton <akpm@linux-foundation.org>, 
    Uladzislau Rezki <urezki@gmail.com>, Nicholas Piggin <npiggin@gmail.com>, 
    Shubhang Kaushik <shubhang@os.amperecomputing.com>, 
    "Christoph Lameter (Ampere)" <cl@gentwo.org>, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmalloc: reject overflowing vm_map_ram page counts
In-Reply-To: <18c9c7bd-0d89-45dd-8425-64f10e83fbb1@arm.com>
Message-ID: <b003613a-42ff-b789-5154-9a3208ee246a@gentwo.org>
References: <20261022-vmalloc-reject-overflow-v1-1-5fde0042ffb9@gentwo.org> <18c9c7bd-0d89-45dd-8425-64f10e83fbb1@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 05D64A0006
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: udc6h87t3t7x9j4bj91zkiyu5bw6r3dh
X-HE-Tag: 1792741021-322096
X-HE-Meta: U2FsdGVkX1/gFpV1jUcQKb0H1A9udJRPw07ipTqAEDGo1Bt6V/lI+Gs/NTNvMZk5SFi5USP+ooBhjZxSHQQ6EqWmKdOkiB41HgOvhqhmQMOoJ/e9Af1KD4kMOjqhxu7OJ0lzWgCj6dJvbMQhcpPzFuIGY7p59XU/jG9NwIdjC89CQxnivGQPc9+tfrhvncJJ2RKAAAfN7l1c5wj8e/9FrJtSBgCGInD+R9HUQGXU3NngakM3mxhn0rSvF5pX9im4pQ6Gu7aXty5oq2+PYCOmE1hi8td5Acoy89QAPoznza9M9Q40mkrWHzCmWl7YP6MKLCt4ZgF5PAB0sye3/QsGm0RWg0Xab1vVmpU4RbLlZS73jpmpUkq85mV8ZF8emRCeKEfv6HcvE024pLtQ8N8wlu6OYaimxAp4uQjusbrCaRKrYYjsdzqM+md8KyvTdRRUsB0HT+uw20xMwiGo+Aibjv82Ru5EETCzREdLfDNT8AlnbT2Mx8h7BskRJxajRxAZVFjASgVQUdELLdZUGBgoJcaVAIXsxbOt+AzR/n9askdv1vAnKfmGuG4LQe36i9adtNctR7ZcGM1J2F01jBP1YH2H+qQZ8Mh9YQzkydLzyzn1X9E6YT0OLDplkd2gEmrdEtZ4vRXrJgKg0dgU+PzIdM0ITK1C3/AvtryM8W/m5STTMMSimVKgILd9EP4yQosJn4lAuUNecq9YyCs4viMLWEhR7ShDL22cDBH9BeEqSEZjQgvg3ZujAAAQ8ll1VTZ3pRCYeJH621yYwAqkW1NixeUbFKLQtXOrvYFQ6/3CBjunrUdNtdxqkqdtlL41JnIagD2YI72p9tqDKpRKmHspfE61njVZBO/bWACC3K7/+7CKS/bt85DfsUD8xBMX4qRI+pgrtlRBS6vbVADwlLGePiIooxGIbyCidiDS13Zwk+6GWFA4gRacHRsD5C6LnyVR7Hite2nhWjbkDgQu6Kv
 t7g899Kq
 2YEzG0zTSIqkQS+gUf4lbMc3317Co826XoxQCyPGVHuFhVRsgl4zdy5BlYblnczozzGVAXpCu1AZ6Cz/8vGl8o/oYxlxWlJxM0bMN/GDxImQVpk7OEoFgqwrpfGlBKzjuW2XEFs9KTHnVzSk4omr2xaJ5SBZtbYpE8hH9IcxkODk9XyvPNow+en4/ByCrec7b3yiZ5r8hcril9P5s3xbXZ5TWZ9mnxdrSmU325fpxQPaY37/qcvbW/WpZGeU9GicGvEtGQFGZRmfMHAM3JhFf/zBO7p9tpDpN+aOGYo2b/NK7wYK3JF30Huypj/nDDghQg4A67k1GYlPWoZsBO4/L4W88CJa6w+P4vfHg8kS9N0gjE9HmpAngdCf1Jw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Dev,

On Fri, 23 Oct 2026, Dev Jain wrote:

>
>
> On 23/10/26 5:05 am, Shubhang Kaushik (Ampere) wrote:
>> vm_map_ram() converts its unsigned int page count to an unsigned long
>> byte size without checking for overflow.
>>
>> On 32-bit kernels, a count greater than ULONG_MAX >> PAGE_SHIFT wraps
>> the byte size.  vm_map_ram() passes that size to both alloc_vmap_area()
>> and vmap_pages_range(), so it can allocate and map only the wrapped
>> number of pages while returning success for the original larger request.
>
> I would expect the caller to take care of this?
>
> In vmap(), the check is count > totalram_pages(), is this check more
> appropriate to be used in vm_map_ram too?
>

Thanks for the review. I have addressed the conversion issue in v2
with check_mul_overflow(), as suggested by Andrew:

   https://lore.kernel.org/lkml/20261022-vmalloc-reject-overflow-v2-1-0db7a20c53f0@gentwo.org/

I do not think the totalram_pages() check in vmap() is an appropriate
replacement for the overflow check in vm_map_ram(). It is a separate
sanity check on the requested page count; it does not ensure that
count * PAGE_SIZE is representable in an unsigned long.

For example, on a 32-bit PAE kernel, totalram_pages() can exceed
ULONG_MAX >> PAGE_SHIFT, so a count can pass that check while its byte
size still overflows.

vm_map_ram() is also a separate API and performs this conversion itself,
so the check_mul_overflow() validation should remain.

Regards,
Shubhang Kaushik

