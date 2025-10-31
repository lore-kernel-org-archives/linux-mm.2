Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0365CCF9FE
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 10:35:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E7218E00FC; Fri, 31 Oct 2025 06:35:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BEFE8E0042; Fri, 31 Oct 2025 06:35:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FC558E00FC; Fri, 31 Oct 2025 06:35:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F319A8E0042
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 06:35:07 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8FFBB885E5
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 10:35:07 +0000 (UTC)
X-FDA: 84058051854.30.24FDD8A
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf29.hostedemail.com (Postfix) with ESMTP id C488E120004
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 10:35:05 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=puzyI4VS;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761906905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=15d5jagqZuWVPOYKHa4FJ77KmZ/Kk6K2xbbjYubxhkU=;
	b=3sryQM3O6KZ2itQ4SbVPQ9vcYIDRf3DalFI9e6+EzVzwJCofJ1feWVW84zMSpEeO3KLwPi
	f+ww9RnGTWwg/+PUQ8HRzXcIEfMaQxf5vX9ZwwgKVSL4lj0yRU60wmzCSbdiHZqDCKExPl
	Xqoi51rf++ZSMX0iknbpSdB07Y1/cwk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=puzyI4VS;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761906905; a=rsa-sha256;
	cv=none;
	b=zrLj+8DuPluOgpZkE3bjae1X0WZpAHpDjTJNlsbEIcgt5riVJNhNGPkZQZUwCi82iSW3a4
	mufwlG8C4ouuGGgIspNiLrpE+CtO4xD6ULvO+/YgA5MS4Rm1Zup+4GJsRZrZOyWmhUlXih
	FiaLJ5izJmJ7kJCtdrOAgI6CdDM4+qI=
Message-ID: <5adc0331-d699-402f-a798-acbf76e124db@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761906903;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=15d5jagqZuWVPOYKHa4FJ77KmZ/Kk6K2xbbjYubxhkU=;
	b=puzyI4VSEcGnkKbWUyQwU8Fr2Cmzx93J3JXvaM/b5q6xIf6hFk4D9XEQIXtewTZydWzo3h
	N7MZfd9y7CNsoHOwLv1jNmWQyvU1MkeMbx+/edLqwHblPKh1suHNw5L5WZsFOSgk+13cso
	XTQeEKURcNDUydqbFINmNPex8s5BQEM=
Date: Fri, 31 Oct 2025 18:34:58 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/1] mm/secretmem: fix use-after-free race in fault
 handler
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, big-sleep-vuln-reports@google.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, willy@infradead.org,
 david@redhat.com, stable@vger.kernel.org, Mike Rapoport <rppt@kernel.org>
References: <CAEXGt5QeDpiHTu3K9tvjUTPqo+d-=wuCNYPa+6sWKrdQJ-ATdg@mail.gmail.com>
 <20251031091818.66843-1-lance.yang@linux.dev> <aQSIdCpf-2pJLwAF@kernel.org>
 <02caf80d-ccde-49d4-99dd-0ea3763a0593@lucifer.local>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <02caf80d-ccde-49d4-99dd-0ea3763a0593@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: bw88y8tmhbj36e7pqz559omthcomimmt
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C488E120004
X-HE-Tag: 1761906905-293905
X-HE-Meta: U2FsdGVkX1/I9PZrMq9Ld0t9J86QuP19mpC0xr6HuEmHbSikoj5FFB570xN7pfL0Bdc30OoAB5Ou7G1vlOGYKQp6u9JTjMCK8+tWT51i/ATnVM28G8aMC3PLmwzXTyYBYwUZeasV8yVp+3sOsjdXBbsMkjeDM+dEAgmfowvNQbpU0fympWWrECiJcLuPs72ovgRgKXhuYpHpL7DiX/7T1iGIuzFNTP+3FtmltTYLNsqJ0VGu2iaIeFwPkl4P+1r07Ywo1NwVWHMiuPXHnJ2+mmO/y/g3Rc+uOnJK5ttF5IEd2fL9v074a8N3tuTQzy/g2dRtXAJ2VdN+NDwR4qN9EcXTcruXyW61+MnGgoYXDHZgrhJYiXTKuJR4AOn1uSxnE08hxDYItyvO55FkN8e+ZgOYKQadYs4CmIQu3ai6DpCZ17GHNcOvFdlUAclk8627tHlGMUUvLrlwNF+AYYM1VshwV92lffF0I6YOxlUxaIo5tNIOhwX4JmNCr7HkqZ/zyOQ/UTMQDCxU0xw7RM4sJwjyF69QRJIvDfsOzPrk1zLaym1w9TfSbMqrsQF9Ff+dpFeWSfN9aSZ5w64texxdEZwGXipl+onzZeZaZh6OBn3JWDTFQVtsOoFMd2uqXxDAykmlfeHh+q4pB7ATZx0yUZMGzu2RgV0Yee13CZfaAxep3kr9KlKzu2tH3FaL9fk6VrVegeQdnfLUsNqzWj4PyZj/65UmoTRXy7BrOhVMZyW/zEhA2bqvJBhiqWDIgcDEsBBANCdq3iVDJ98oCw9AYBRLePM2RELFCQxVg+jHvPSCBJT8CPMB8EC93OlheswTqKx48LV53/jK6nY9igqnbJ97fy2gq49OiJ8x/IPxlLKXnge+LXnHv4cz020KH0l6XzgQ8Pil2zSEYMQ0jbomOvfoCO3GHy5j5QOHoJnvv5POBMwVpUmBqV8YSsXRS8liYmx1+tRf7jrNHbPopj4
 S4gWa5lU
 EipRd39cobHlDeyGYjlodeo7MwaGelBNQZUx8UXyQBknx4ADITC/z4nB94agasWJLqf/x7IX8KVd3563/MwVJoru6M/7aYnU/4qMDEkLkOth1liisTLlFPyrOxK3mslPkXLcw1MPIKc+kygA2/CzFIp6PHWMfF4u59mXnY5+Ht+m3qINZcmeJl3V9J0Y/lRXj47WSJigX3RWNe61ssntpXtqH1z7JobiRkLkoigyA+5E+Rh9Aov6YuepdhV9yRxtoPe/IW7Y1vJj0j3vBWyF33+gua5flG9SMHlrY7rb3FsPw7KM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/31 18:24, Lorenzo Stoakes wrote:
> Small thing, sorry to be a pain buuuut could we please not send patches
> in-reply to another mail, it makes it harder for people to see :)
> 
> On Fri, Oct 31, 2025 at 11:59:16AM +0200, Mike Rapoport wrote:
>> On Fri, Oct 31, 2025 at 05:18:18PM +0800, Lance Yang wrote:
>>> From: Lance Yang <lance.yang@linux.dev>
>>>
>>> The error path in secretmem_fault() frees a folio before restoring its
>>> direct map status, which is a race leading to a panic.
>>
>> Let's use the issue description from the report:
>>
>> When a page fault occurs in a secret memory file created with
>> `memfd_secret(2)`, the kernel will allocate a new folio for it, mark
>> the underlying page as not-present in the direct map, and add it to
>> the file mapping.
>>
>> If two tasks cause a fault in the same page concurrently, both could
>> end up allocating a folio and removing the page from the direct map,
>> but only one would succeed in adding the folio to the file
>> mapping. The task that failed undoes the effects of its attempt by (a)
>> freeing the folio again and (b) putting the page back into the direct
>> map. However, by doing these two operations in this order, the page
>> becomes available to the allocator again before it is placed back in
>> the direct mapping.
>>
>> If another task attempts to allocate the page between (a) and (b), and
>> the kernel tries to access it via the direct map, it would result in a
>> supervisor not-present page fault.
>>
>>> Fix the ordering to restore the map before the folio is freed.
>>
>> ... restore the direct map
>>
>> With these changes
>>
>> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> 
> Agree with David, Mike this looks 'obviously correct' thanks for addressing
> it.
> 
> But also as per Mike, please update message accordingly and send v2
> not-in-reply-to-anything :P

Sure. V2 is on the way ;)

> 
> With that said:
> 
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Thanks!
Lance

> 
>>
>>>
>>> Cc: <stable@vger.kernel.org>
>>> Reported-by: Google Big Sleep <big-sleep-vuln-reports@google.com>
>>> Closes: https://lore.kernel.org/linux-mm/CAEXGt5QeDpiHTu3K9tvjUTPqo+d-=wuCNYPa+6sWKrdQJ-ATdg@mail.gmail.com/
>>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>>> ---
>>>   mm/secretmem.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/mm/secretmem.c b/mm/secretmem.c
>>> index c1bd9a4b663d..37f6d1097853 100644
>>> --- a/mm/secretmem.c
>>> +++ b/mm/secretmem.c
>>> @@ -82,13 +82,13 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)
>>>   		__folio_mark_uptodate(folio);
>>>   		err = filemap_add_folio(mapping, folio, offset, gfp);
>>>   		if (unlikely(err)) {
>>> -			folio_put(folio);
>>>   			/*
>>>   			 * If a split of large page was required, it
>>>   			 * already happened when we marked the page invalid
>>>   			 * which guarantees that this call won't fail
>>>   			 */
>>>   			set_direct_map_default_noflush(folio_page(folio, 0));
>>> +			folio_put(folio);
>>>   			if (err == -EEXIST)
>>>   				goto retry;
>>>
>>> --
>>> 2.49.0
>>>
>>
>> --
>> Sincerely yours,
>> Mike.


