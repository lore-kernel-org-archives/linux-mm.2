Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64013C9830C
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 13:56:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56CCF6B0093; Wed, 23 Sep 2026 09:56:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F6996B0098; Wed, 23 Sep 2026 09:56:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E4E86B009B; Wed, 23 Sep 2026 09:56:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 18A7D6B0093
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:56:04 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A2227120762
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:56:03 +0000 (UTC)
X-FDA: 85245175806.17.2252A7E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id D1177140013
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:56:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GTtH/U0d";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790171761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HgzmE1Bz8Mkwt6u5zesfSAcUD7w3ziC16QswaqnOebg=;
	b=gltkiNZW+hC2lEQIQSMkrhQrFTG6178BXKo2JrSjH2ZWcDJ2x4PZhV2flNXKkwZtV+FiyP
	RioCTnHJyFH0SX36jEM7e7MDa8ccP6BuKmUL3L22db8TFAjO83kLMnPKlQoJV8Cadm+oB/
	VwYPs4zLsgLV1JhUzBqXrQxBYg+eXmU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GTtH/U0d";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790171761;
	b=ziL6LWqg+obCwlbUtrA2mxyDgR4nUU5RreYIEHfWRiy7CCsvqYlPB0FBkIi29oFy4JeWmG
	yrS/Z/xuh+K8OB+bhu1kuzMsC4z5AxhKQPuTPEbA+++WfHsU64xmC18VJw3ZkC1Gm8Uc8U
	43ZZpeCLdTDwgYb9sQyiwIMXckqgmok=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 09F3E4053E;
	Wed, 23 Sep 2026 13:56:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FB681F000FF;
	Wed, 23 Sep 2026 13:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790171760;
	bh=HgzmE1Bz8Mkwt6u5zesfSAcUD7w3ziC16QswaqnOebg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GTtH/U0dncv5bXivkG9aJTnY70rghEaHSB8FlOrsI69v1BQHpZpGZN0dyV5zRSgas
	 qDV0BIBaBh8V8g3uNvzjsmpzZGTUXdzhWbU8P7qMMf6tBX994TBKgikXx02ZepCRow
	 4iXIMaBLicLR4DKvXWXiCJgINsXB/zHivQnK8agEvoCfR/4Q84SfvMsv6lHGFZIW6s
	 wTngpG148i+fiuiNZJLWDUERUPe/P5FxE/a8XD2eGn61VRFTwuElWp1QWPLxgagAol
	 F4lYGaI4AdkOrrIWOJYG4P8iiRzis5qIllSc45C+Q+JkoRNpnz+mOt0OYasFbww5lD
	 FpqJeQ4/llbqw==
Message-ID: <7be89e4f-2cf0-4eb4-aaa7-5f84a0001de2@kernel.org>
Date: Wed, 23 Sep 2026 15:55:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 14/15] filemap: Add support for authoritative mappings
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jane Chu
 <jane.chu@oracle.com>, linux-mm@kvack.org,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org, Christian Brauner <christian@brauner.io>,
 Jiaqi Yan <jiaqiyan@google.com>
References: <20260805210557.1118966-1-willy@infradead.org>
 <20260805210557.1118966-15-willy@infradead.org>
 <0e0a0908-8e5d-4cee-9fbb-ce730bb662e1@kernel.org>
 <arGfbk5Yv9UTlNqB@casper.infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <arGfbk5Yv9UTlNqB@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D1177140013
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 934yazinrd1hb4e5fektzfhg85ugdza5
X-HE-Tag: 1790171761-592174
X-HE-Meta: U2FsdGVkX1/kpyJPPpkp3Zykcfz654hFTDZgI6CcB6VQqV997UdxXcc5yPB2XRTn2slNWQxqC+SOunK+bts4F8uXNKYQjUXlx3JuZyx9tOxHjF7gYwmX+fUaIcn+aubiPrjeKXg4hop0zbzz2rxoJOA/HefAG/ochH/9UjW1dXfCCaiv1FWAwQTk4YDas2295nmtdoaE6rarCvDcy3l0x/B4cr3QNa2dKTYhqxZP1euUXPXtjmKihwBZXsw905ibrXelFg+5/yEngJ6y/yUI2umTdkE7S36JPIs2Tvu80SZs7NvgGdXQlkfY2IqpOtXzPKgexgfMOM4QXi7E652ieYBTQcR93MquKEYNBp8xwToHadAsPvP0zjrKJuKGVrjqsMYbBVBithWScrWGInMICPcylMj70fS4frbuLDRByuu+J33pwoSyLdV7Zh3MG7yLGccNEMqQ3wEf3P3A6O6j9WRVpHeC73uojaRr0q/90EzqqFtAgwxzTdyZNN6o/8CUDz2/h5jqoJx1VxWLhetGZUm/0asClaRMzew9fMRi3Ufyyay15180AyBCqTPJmcol/rpV1T7SnnzHHhQ6XzECvkas0/d7n+Hom8DjAWeIiH/VhQngLxPDEwHgsrvXLH8YnB1HzqbUM9hZ13pIPQhu/5yDFYGXaQWrhzlIcAT8820/iTJJMFNuGfS2K83j1892ULx2ch1/VJraxSTXx8CmAJ3yKbGJJa31yjFJElLvYDOxb82KntBfP+3Gg1yz9drNLSl2tC8RU5bC5992VRWACSpAXZuu8OTAHillyciJN9FdglPoPzfMmKsenp7cOAM5RcNUIo17VXiCn+BDzr7ADIfie73fXkmaUxoRaL2ohH+9xsYbK1EZ/AW7wUAjpLhjx4pFk3M/8oS5dGw+bsTnfoc9QzodsrV/rel2k7vc8CSz+2SkT9g+qdVcGryPuIJq7zbtquRWxe37kAhzyBx
 5cB+OxRk
 gcOUxgswPBRF3fst/0xn5ENjqvmL7kkrBIDgHMb52tVxwt9QYjmQy9D26RwqB5svqtXNLEyLkI59ucrvPavqIEACRD1G/RV8yxLqVVv9uZDJdLez1EqMRoZ8jGPC5LKk87adcU5mAtMvGriDyIDhq43PuzJ6+yEldg8JPr+UO3jVdYYfNbQf6YJJjpj+vI4bMxchO9fi/TNz4ABkeREpHazDYmJfk6UHXvEvHxwy+KDFwEtMfkQcR+je3kpOWSHKZe7aIfH9sFjxgTj/bjDChaMWAEz1KVhV9l0SbJOCM2Fsj1/sepgHgDpFUsUXj4MuR4iSmMtmO27lL8w8aI9b/7VnYEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/21/26 23:19, Matthew Wilcox wrote:
> On Fri, Sep 18, 2026 at 03:51:59PM +0200, David Hildenbrand (Arm) wrote:
>> On 8/5/26 23:05, Matthew Wilcox (Oracle) wrote:
>>> +++ b/include/linux/pagemap.h
>>> @@ -210,6 +210,7 @@ enum mapping_flags {
>>>  	AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM = 9,
>>>  	AS_KERNEL_FILE = 10,	/* mapping for a fake kernel file that shouldn't
>>>  				   account usage to user cgroups */
>>> +	AS_AUTHORITATIVE = 11,	/* If we miss in the page cache, it's a hole */
>>
>> Just curious if "in-memory file system" would be a different way of looking at
>> it. There, a hole in the page cache always expresses a hole in the file.
>>
>> 	AS_IN_MEMORY_FILE
>>
>> Just an idea, because that's why I always had in mind regarding that (all state
>> in memory).
> 
> I suspect that's always going to be the case, but I don't want to be
> quite so prescriptive.  I'd rather describe the property than the user.

Hard to imagine other users but I guess nothing is impossible :)

-- 
Cheers,

David

