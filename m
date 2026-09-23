Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C9B4C98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 14:01:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E775E6B0088; Wed, 23 Sep 2026 10:01:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4ED16B008A; Wed, 23 Sep 2026 10:01:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D662F6B008C; Wed, 23 Sep 2026 10:01:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A584A6B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:01:36 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DF34AA0862
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 14:01:34 +0000 (UTC)
X-FDA: 85245189708.19.FBD93BD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 240F08000A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 14:01:32 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hHlZr6Uu;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790172093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PC3Za8iCgsJ8W6QmugoGUlZXLsysH1qJQuMBo3/+gew=;
	b=CrEcuJhnkTm8B7yWPD4pyxR6XzEs4tI9iSlijRb8v1VTfvk13M5XMABSwl59uZ8ADR8YVY
	L3D94AKAzp4Tsvt0UQW48vg/lro9EZ8jVllv6thYz0eIyEPGX+8i+QzXacynTOTfY0oUPN
	0AxZkGd1dyO58fSUDL4I7U4QZH+qeBU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790172093;
	b=OsOBxjbDWS42i793FVLuX6AkZ9uWteT9SEoF198T5lOjcKPy2rCeelgMDz9e1QOllSS0yV
	SotWJ32PODPy5rfr3aHQi05dL7O797qft6tK9l4hqHCOcnF/qtpUDHUAQNQeGAmP07YhIJ
	Ajf9t1yr8ZVo2zFy0H/HqtZFGjljTBk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hHlZr6Uu;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8D1F4600AA;
	Wed, 23 Sep 2026 14:01:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F9841F000FF;
	Wed, 23 Sep 2026 14:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790172092;
	bh=PC3Za8iCgsJ8W6QmugoGUlZXLsysH1qJQuMBo3/+gew=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hHlZr6UuVw7UelysAGbw5mSYPwWTMdGw37gZc3d2NyH+4d9MxpidkuqVlSaUoqO+U
	 JYoInOedh76KNB7+IC+SqJJDcHfLIU9bjLiQpBOOrTHI5W6BzVKCPPp3XFfRy/nq8l
	 1royZje/hxJC7hRPD94k3qbotq8whotW6PjfNj4UDwNIanavDnkzBaSz8JjfP3kUbY
	 ZIvq61RvSRKfDbBgqXtk/xs/Nzr4xdqutTOna1byzk56OIuLokhgP4HoldZDX+8IF6
	 MxJmQSe8F/tTVkB/bKqxebaObXz+dgQggNd83Yr7LYJvIpVRTFmjxCJ18ONpeiu7kH
	 8vyyJOF6yXr5g==
Message-ID: <a4dcb274-3ea6-4f5c-be57-65b089967ae9@kernel.org>
Date: Wed, 23 Sep 2026 16:01:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] selftests/mm: init page sizes early in
 pagemap_ioctl test
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, akpm@linux-foundation.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org, gourry@gourry.net
References: <20260908134117.84405-1-zenghui.yu@linux.dev>
 <20260908134405.84448-1-zenghui.yu@linux.dev>
 <b1f2a146-1a61-42bd-98c5-fc4380b6ae49@kernel.org>
 <fa0bdb5c-3903-44bf-8d14-91d77e32b201@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <fa0bdb5c-3903-44bf-8d14-91d77e32b201@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: bc8dwc9bjmy4w8ubnqcyqiiexxcxkqm7
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 240F08000A
X-HE-Tag: 1790172092-524671
X-HE-Meta: U2FsdGVkX19bENkkt4AFQ9pPiH1W9w4IjEUmg9W94I/jLUBZCjia4lh/HLvzSHerDVPe/dehi08Y+6HmwqoQZcQaLUvzZOrap09m8a6Q1no6fw2PpFAFdGYWzMhkp2WIP375IZ1ckpvbTPeIlqZkb1SD/e9iVbl03D0mZJ6YsNDoM6GdmzBE+JjQ/lIpF7TnKnE0xb4L8tv04/0JchnzZ9TM3YsDPKZ7Sygcf6/x0O+pg1G2VvE0kRJPZAOGM0S2N6bCWuACPvUHv2TJezHZtGgJ0c5BcMiW40EMvUsTZR9lpM5vcZsGI1R2LdHG7Wkg7a3VrJU9xzbmSRF8x6EqRu/1i6oXhmDU/Dy8mpqbkS0spYb5sbBEmQyE6w+NUGyIMUkTEZpMbT95o4TbpMOu5H7iBCwcuZPrOibrRxnK9o1RNR30E0qFsVghLYB7akJ45mOfDaEOEX7kuGNx25MMfwuVejxVJn5nyZ+nYUgiU8qLzKCcBIXJb0dKC3GpKc9jTJVr0QjCvca0sEzYBWMvQ1wCeEknLN5EfHUXBhyRlWXdeOE87ClbV2z7o9ithUMRR6mf1VAPhEWFdDYwQ5eAYj3gZRbaLMUYr9NoKjJXq3HauiAaAi0vZUOiqapUr0Yt0NxTd6LCbMbhtJmT189me/0Oqi7/16dk/2R/DiDEH/I5a0OCHV3AxjYtoma179gOvX7UoEBV35d+eYBmxWJRmIDvM+M+Ptgaxf0DaKZqp+IaLtchfCF5gBH1ejI9GF+glotYkU2wfZpdmNfH1K02TYVJXZKqT6q80S/h/6WfCkwfxco8Inwz5p5myP+w/CNxIH5OgkxZFZtfpOoHhUVBKZg2Pfx6TBb8Dr51ZfybNr2DYDKdg2CI6uLu8bAqQ6tXltRavDFeoKz/pdfeehL/jSYNrSfRsVQwlwajkReR1TjFoCnDYsdyqpRt4hFtgp/AfVwVuAfvN0hnGoR6n2r
 q93L/Dna
 eKwU3ZoSfUfkh77+rZeRFNcmQDe3Q9/nGXdFB3ahAODeKX0cpwK3l9gpZZuhO5hH9eAHvK+UEhSNMF9/iMm5QmTDRZmux7AK4NsnBPd5joLMCbgzOt/B8P/UVWkLbWRP5TNOoffLELT5SoOFEYiMwUC6PTEQYjVIZT3B7jj5RZPZ6GRVWXpGitn1KX3vRNL9Cp0VpqwLpBvGyl7p7Y4eZW+2qWAA8o3G2mV+hGyz+3YYyibDOsjA6K4zFquPXMYbfzpojucrHtD9ZaZ963vouqxPLSYKRuhD1aJPSrJabXO2KCUhVw8SPxaYlnPd+lyh4BcIbQpSnjkJvwW7r6ah0t9uoV/3QgygLVdqLWH7YrK0jJRQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/18/26 08:59, Zenghui Yu wrote:
> Hi David,
> 
> On 9/16/26 11:30 PM, David Hildenbrand (Arm) wrote:
>> On 9/8/26 15:44, Zenghui Yu wrote:
>>> From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
>>>
>>> Initialize page_size and hpage_size before calling init_uffd(),
>>> hugetlb_setup_default(), etc.  That won't fix anything, but it is safer and
>>> saner to get these globals set up before doing other things.
>>>
>>> While at it, drop the page_size parameter of transact_test(), which is
>>> actually unnecessary.
>>>
>>> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
>>> Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
>>> ---
>>>  tools/testing/selftests/mm/pagemap_ioctl.c | 10 +++++-----
>>>  1 file changed, 5 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
>>> index 1a87b7483316..d9a4fb782ecf 100644
>>> --- a/tools/testing/selftests/mm/pagemap_ioctl.c
>>> +++ b/tools/testing/selftests/mm/pagemap_ioctl.c
>>> @@ -1489,7 +1489,7 @@ static void *thread_proc(void *mem)
>>>  	return NULL;
>>>  }
>>>  
>>> -static void transact_test(int page_size)
>>> +static void transact_test(void)
>>>  {
>>>  	unsigned int i, count, extra_pages;
>>>  	unsigned int c;
>>> @@ -1653,6 +1653,9 @@ int main(int __attribute__((unused)) argc, char *argv[])
>>>  
>>>  	ksft_print_header();
>>>  
>>> +	page_size = getpagesize();
>>> +	hpage_size = read_pmd_pagesize();
>>> +
>>>  	if (init_uffd())
>>>  		ksft_exit_skip("Failed to initialize userfaultfd\n");
>>>  
>>> @@ -1661,9 +1664,6 @@ int main(int __attribute__((unused)) argc, char *argv[])
>>>  
>>>  	ksft_set_plan(119);
>>>  
>>> -	page_size = getpagesize();
>>> -	hpage_size = read_pmd_pagesize();
>>> -
>> We have some other code rework that part, so I expect some conflicts for whoever
>> goes in first.
>>
>> Why not
>>
>> initialize them right when defining the variables, marking them const?
> 
> I'm afraid I don't quite understand your suggestion.  page_size and
> hpage_size are static global variables which cannot be initialized at their
> definition.  What am I missing?

I was assuming they are variables in the function, please ignore :)

-- 
Cheers,

David

