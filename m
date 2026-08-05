Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C217CC55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 07:17:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C9916B009D; Wed,  5 Aug 2026 03:17:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 979F66B00A3; Wed,  5 Aug 2026 03:17:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 842646B00A4; Wed,  5 Aug 2026 03:17:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5B3646B009D
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 03:17:43 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CD63DA03AD
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:17:42 +0000 (UTC)
X-FDA: 85066360764.16.E28A2D1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 26DA4100009
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:17:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aNPelBbK;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785914261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kmrSBoGTeyYYh/0LyjGTqLsKBsQ92dszomYmjSvAHsg=;
	b=2f/iWh6nCE4qDZ+uAlHNSysO7/tiqJ7tzWd4UyDmiHJERIaRLuUbgZI6CQWh/pJEnyBymi
	yJNgYcc87LyJlppXttTnZt3j3qOZXC8TobbgMK33IoQDWXmbCQurTUb83jMTS5TEnKtnYc
	Tnyry3f15OXsT6itIm/fm+cxcj/cJBM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785914261;
	b=KgtMmM30MXhy/uYyhW1J0lY0pJV/cZtg8CeJflMHGeCoUBBkx4jtlnZXUcQ2Wt6+iVL4yq
	YgMhg0p04LdT3HpmufAPKf4+btv4mP+T9am9w4Vx57P4pFXvBBVSv1/Wm7oGHXOH+wRN7V
	1cDehAYriuEf/+j18QJ3Jczrjla2Ibo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aNPelBbK;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5E7D56011F;
	Wed,  5 Aug 2026 07:17:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BE7C1F000E9;
	Wed,  5 Aug 2026 07:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785914260;
	bh=kmrSBoGTeyYYh/0LyjGTqLsKBsQ92dszomYmjSvAHsg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=aNPelBbKX9iXsPeJd3gjkCpS6qJb35JPXQk1kYOf11oy8Hseg3l93aDKZnVLS4B0T
	 JyQE2oc8Rpu7v9HnCeWTMMRoW0JD/5+YoH7o3PLypfO8X60t19ZfMRJK3nCTrQVg8K
	 f9o0f98CFqT3G4j0VqyRjbeAS7efMqhtuIU7l2vDc/QZSGILnIG+Yqykr+1R/7lVxU
	 zZ+vBzJl86uiC7sS2bbmx9mePAo4BXMKXMfpmhpE/8KjGfmLn3ALf80+QEJBz/rt1L
	 uSLnH2v8XvEp9y+7gk9egroQDV3wcblSFsXxCu/FtOr+JbDQ9gE4EqKkFukd0n2u3i
	 gShUSHAxPq8qw==
Message-ID: <f31fbd7d-2e8d-469e-ae8d-abe5b7f6e236@kernel.org>
Date: Wed, 5 Aug 2026 09:17:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/15] mm/rmap: track whether the page VMA mapped pgoff
 is anonymous
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
 <20260729-b4-scalable-cow-virt-pgoff-v3-7-e8ecfefea812@kernel.org>
 <1b48cf7d-8906-43d4-a85d-5cfad10a12ac@kernel.org> <anCcMvnsux22LaWU@lucifer>
 <007258ed-3fd7-4d90-b909-6fdda15e0485@kernel.org> <anCmQdKzZFRMqcxs@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <anCmQdKzZFRMqcxs@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 3azw6918jf1xjfw4xsd3g3aup9169xyj
X-Rspamd-Queue-Id: 26DA4100009
X-HE-Tag: 1785914261-95772
X-HE-Meta: U2FsdGVkX1+m8ZFA34mi7awdvMQbrWx572F9loPnNGOa0EGzurY0KSNDsQvSfEeZDucXiuts2OHqo3/HyJ6VcmqNr+eAEJ8/NH4CLfLPa7LsUwcBgqFIStLqTs/m0Nlq3MbPIIGGizvFxOBqGMb4QNAnSTov5NMfbBdS7l6+ahCgr+FyPYsWIl2DcQm7wXSo85Qr1sCz5ybYlVVIx7QqlZNZT2+qhwHOLhpy3nuLL9/leaQBC9e9FrJiGW0vOjT7YCIB422l0vusgx1iCsulb1BJWPBpwrcL72rjoqACpENbozMnAQUmbTqUVS5SA+t2IShN9XjzEPgZZmNKw0G+KvNI6CY344XHhTECSvJ4CuEY7xSh0ptucFjHNAuR1ADF+25/nIJOXY9gBa2VAE2Qeh2IPy4+z3nnN6d51VaK4APdda6hvcMkweAZ4GOLTPDeeUfFZOKDITIvk2LIo0u54QJ7J1lTk23KmYmFrJVZelu4nd97HiiKX7xQIg2dkE9D2BmskcrBgFgXV2C9JwS10uEetEkUhouANCu8vYFtys1wYQAAoI0JyRt4HDHVf7i/KDuHSzy/Z4/y4b/Zsvk9mmP9F4/I9Pd0I3owicT+0RzAllyAWQjp6/qqE1ZMeCAX8InY5KtzVNztYwVv+1d/EB9q3sSd1tQmSEcJJwJ+oOkU5gvqGsvFDh0pyjc6U9oec0S2PPTmXpqrgP7XqvCJ6pAtaWdhnO/G5ddYXBmcOIZZ9ZlqTHMGGqOPZjsfsTMoMgl8rYlUQvMVhgQXNThft1saizxYxk8ggopLdgEBWhQnuw0Z104TIwKrncTLenFpYsCURqdGxmXsu3x7eCuRaWraIugs2Xw0r3yEwI3ujcXNTjyNnlJnBeLil1VZP7PrkRXPVSCNN5pY3w1UQxy4PxXW7DrjigKyuA+ZgFtF6IfDKhJ5nXMJo/bbT1uY/nQAvOzwh2hxBEEZgongBWP
 ai5BrQWW
 Sy6ZUyJCxrF9oFUFXtZuWAIjoeSJh7pSlrodZSkDONJ/ANmceCR99GVzW5PApv1PL/gLukclcEzq9oiy0zExaHnI+Hy+vvEWx3mFl03g69B/KWS92yLJovrGjboTIGWxGZMn/Gjcs0jrhfoXMvYrczR/BAtKuFFvfdt/z5IM1nzCHt1eKwLg6MDZSdmWXKkQBjoGzYN7s6Os605n2p+ogt+BCfE6p7TaURDvvPnySCgTFbVUgDSSa7QnRlkDyCORUR+VjsjHSSKmWJaI4xyYOUMMOV4fy7HuSNFfQGyOEX5BYAQW1P6LUTHAGMqUGTbA1KeVQ//VsVKmWTho=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/3/26 16:32, Lorenzo Stoakes (ARM) wrote:
> On Mon, Aug 03, 2026 at 04:02:45PM +0200, David Hildenbrand (Arm) wrote:
>> On 8/3/26 15:51, Lorenzo Stoakes (ARM) wrote:
>>>
>>> As per commit message:
>>>
>>> 	This is laying the groundwork for eventually using anonymous page offsets
>>> 	as the index for all anonymous folios.
>>>
>>> 	No functional change intended.
>>>
>>> I cannot enable an effective change here, because if I did I'd break the kernel
>>> and introduce a bisection hazard.
>>
>> You can just throw in a patch that cleans that up and avoids messing with confusing pgoff?
> 
> You mean do a separate patch for this change?
> 
> The existing code is already very confusing :) it becomes worse with the
> anon stuff added, hence the change.
> 
> I will separate it out assuming this is what you mean?

Right, if the vma_address_end() is not required in this patch (and does not fall
under "track whether the page VMA mapped pgoff is anonymous"), just have it in a
separate cleanup patch "prepare vma_address_end() for further changes" etc.

-- 
Cheers,

David

