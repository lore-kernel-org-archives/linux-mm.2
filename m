Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C13EAC9830E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 10:03:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9AD06B0088; Fri, 25 Sep 2026 06:03:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4F776B008A; Fri, 25 Sep 2026 06:03:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3AD36B0092; Fri, 25 Sep 2026 06:03:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 903696B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 06:03:14 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1FE571205F0
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 10:03:14 +0000 (UTC)
X-FDA: 85251846708.14.0370D8C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 65CB6A0008
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 10:03:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZQlSLR9x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790330592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t36CornOt9N5L78VQ17XppVwwpYO+WRPIyNlZItd53Y=;
	b=g5tNhNigA9D98IWHMDEwSJBMiHj1jQ2RepJzHyLnhe6uKG1THmYl7qOy68Z9RZooabAQ18
	yrOw13fWgUnWPGP+rnFkh/X+BuhPsVYa1z1axPwDihobwIfXqHp2qyDuGmUe1yIHM+ygMU
	TiryMT/R0M2Km9EnxezCbwvgO4VONqY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZQlSLR9x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790330592;
	b=r5XWnklUcPi9DRDX/dmyLJsyCujj6FEoVTACrQkHVqDt8eNeRCyCms/MGZszCZDisMYPXf
	uvP9IaFNXyjEwFBxagFr6qArRcn3T648gh0OLJ+5mX5xlcdQydQIoAKw+IzP0IfJL306p7
	MRk5hDKRFauIGrzJPFub3tAENSrAwhM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E338F6022E;
	Fri, 25 Sep 2026 10:03:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63CFB1F000FF;
	Fri, 25 Sep 2026 10:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790330591;
	bh=t36CornOt9N5L78VQ17XppVwwpYO+WRPIyNlZItd53Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZQlSLR9xHXZe3ovZL+O5SGKyjwqcEF8nNNxUh9+RbSALwRy1mRLu+0iaqVxvv7UG4
	 N/+won6apca3urjKK4I4XdG06ZAghJ7L+zqCotK8m4XqWrxJm8KvOjlbjSOoRKKyaX
	 Ptpcjp5BHXjx2ms/e+tGKMvGhuA5K2W6jvJNUw2FEXMw7zc+uGxkpXMnjQaJ89GUxR
	 ki3FLSpW9m9gUf3bEYg5P1gSA6Q1o7wdaulQwKazp5orcmaWrCljp9Wy4yo4ZdOqL6
	 mo6nouhIG3E9BCEYv+mMLrVQkcpPZ+uLequRrGGdIsJR/HYkhfbJQHpI0vNCvNUiJK
	 gU35NHdAbIvAg==
Message-ID: <59c4417d-b62b-4b40-9efb-e704b4162573@kernel.org>
Date: Fri, 25 Sep 2026 12:03:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [FYI] DAMON and virtio-balloon in DeepSeek's DSec paper
To: Lance Yang <lance.yang@linux.dev>, muchun.song@linux.dev,
 research@deepseek.com
Cc: sj@kernel.org, mst@redhat.com, damon@lists.linux.dev, linux-mm@kvack.org,
 virtualization@lists.linux.dev, ryncsn@gmail.com, kunwu.chan@gmail.com,
 lianux.mm@gmail.com, baohua@kernel.org, xueyuan.chen21@gmail.com
References: <9f63d60c-913e-4e79-9d28-890dd48ef713@kernel.org>
 <20260925081504.23569-1-lance.yang@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260925081504.23569-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ejdkuib7bx6u433zwpsgckym3t7eo9n7
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 65CB6A0008
X-HE-Tag: 1790330592-308672
X-HE-Meta: U2FsdGVkX188D+sMnyMD9quGiSRWL9XxRAHo3RVynWKc5j0tsdkAVgh29ivsVv8t469ak0/5UQFfWeZRLn+x6Mi3GK03pcA9/Jv34TkhUvONskZJ+qWQHtie1dZkP4J0C6K+zc5WgE7qGu1pAqaHYD7StvN20AU8os0BOAtTHWIiMXxnHI+Rhva6vPwcNYHkm4KU2kjU0v5hlY1X4iodsU7R2rAVF10M5F2++X0whW9DXAL+NPrZmoz78xbRHv4hYNEvelpfQWBQwSaRVK73Gj8wvuWXO66UzQahrL+83r882uMSaf8n98Nlg7KJlgQkcAPaU0uacDHoOZhDcLeu3InDYL+IdNlMaD44Daosyn18mVyh+sf+ukzenjo53IqIgmuaF7kv44biCFIKIAnMpMH3ld+IhTr49EBYOooRF9fCqXC81u+U84I7qCHoB8S5OGPuQt9TQHwukbyMUCQfZk0qEkplnGlGvv2ZLomf9hhSVsdh6/LUIDhH0J+zFpXBS/KlKpp4xvivmDTaYIIi/aRs+8fJxlsRZtx5BPEGDG0WYoalIIX9ytBvVZkeQpopW2WD6hjuAKPjTM5oDHLtLQ/9k6JKhqCej7koTYZ7dmru946Ua/3XCCTJfvicXTjceUFBZ/rtLtg9lsDdlTaUknAn8mL0ejd0iomrqshftRFNXRKy4TBJJeTtN87uNUuL3HP08U14XJj54HegmElcyxsyGU8B39+hz839yEwj4n33A10gmWxZE+dNaqDU3rmamywsRJKu6t6HUWxEmN3doJNqMG6/kO3o7MeSrXXWA3puSub0zqmRbsC7usAX9JJjA9Vp+NRc+z98Sa4XR0bh7dMiENoUxkE88s+Ju9iet7BDTJN+cQzDkD+k+HpH+TqNGiDOyBpthSDVqlKl7aSY/ANNnT2cPxA8OPFQ/jsFmrY578hGbIpbmftVddNBTDJ0uGXFeS5isizu6yrtKAh
 xakJGObk
 xzT0rGV+E/vPJkXQAc8tVbWGJy1Ny+U8H8+K2Jwf7hHhufrk6pwljftFtrm2Bua38IrHaLaETAk1f+rcBafoRCrqSgjWya2VC8m8DXio3a/Kx58K9IrsyoN60hxlrgaW/8QdEOdxlC1/O++GvvRMJYo6yBXw13UKpdbAC/cahbwMUmM7OstaQkM1SPJRFGCXP+TOFpXufV0taZgrXr2Rw/WW8NNe4HYB1WYZCq3+HXz+L2lrnCmeP0hMI2o4JVWB669a4T9TaEe9W7J03G1w/KaA48kqhoixfRlqrgp4XWbqJYAEs7BUQYBI84Qb4JVgrrt8yhc8cM8OPvyLdDL9zE/hom6KhK4mHBYvA8Wa058NFNKcbiebjHKuHLfc83Ccc0SJr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/25/26 10:15, Lance Yang wrote:
> +Cc DeepSeek and Muchun
> 
> On Fri, Sep 25, 2026 at 09:04:41AM +0200, David Hildenbrand (Arm) wrote:
>> On 9/25/26 07:44, Lance Yang wrote:
>>> Hi all,
>>>
>>> I was reading DeepSeek's new DSec paper[1] and found a nice use of DAMON
>>> and virtio-balloon:
>>>
>>> With this kind of workload, an agent may read a file once and never touch
>>> it again, while those pages remain in the guest page cache. Without memory
>>> pressure in the guest, they can stay cached even though the host would
>>> like that memory back ...
>>>
>>> The trick is DAMON + virtio-balloon free-page reporting :) DAMON reclaims
>>
>> Heh, I read "virtio-balloon" and thought "balloon inflation/deflation, what year
>> is it?!". Free-page reporting makes much more sense.
>>
>>> cold file pages from the guest page cache; buddy gets a chance to coalesce
>>> them into reportable blocks, and virtio-balloon passes those blocks to
>>> Firecracker. Firecracker can then drop the host backing with MADV_DONTNEED.
>>
>> When I was at RH we were looking at this issue as well. virtio-pmem was one way
>> of avoiding the page cache in VM entirely. But it has its own limitations.
> 
> YES, they enable virtio-pmem with DAX for the read-only EROFS base-image
> and toolkit layers, while using DAMON with balloon free-page reporting to
> reclaim cold file pages from the guest page cache on larger writable disks.
> 
> They also point out that the guest must allocate struct page metadata for
> the entire pmem-backed address range. So virtio-pmem is not free either :)
> 
> BTW, Muchun recently posted a pretty cool series for exactly that:
> 
> https://lore.kernel.org/linux-mm/20260903122128.12264-1-songmuchun@bytedance.com/

Yes, that will be helpful in that regard.

> 
> (It shares vmemmap backing until a DAX fault needs private metadata,
> avoiding the full per-PFN cost up front.)
> 
> I have a feeling the DeepSeek team will be watching this one closely :P
;)

-- 
Cheers,

David

