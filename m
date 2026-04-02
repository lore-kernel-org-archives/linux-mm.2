Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35C12D39420
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 13:45:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D82E6B0088; Thu,  2 Apr 2026 09:45:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AF956B0089; Thu,  2 Apr 2026 09:45:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C5696B008A; Thu,  2 Apr 2026 09:45:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5DA1A6B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 09:45:36 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2E790C261B
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 13:45:34 +0000 (UTC)
X-FDA: 84613738230.03.C568C7B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id EA171C0017
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 13:45:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cQiFmi+V;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775137533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PGNedSjqzsPqQNQ8I+9b8sK/Ktw/mwYWWmaMoMv1Lss=;
	b=ye1WupC63TNTJNMP/vyyZFSTMsrVmFE42Ay3ljOKiSBsx98YzCcYhrQi9NI4UiWSzh5SzC
	Mt9KYfVtMeAkQkNhuqd5MxWPxpS++AwpjRANWCjVMwIVZO7g5m0dqNhHo5HZcX7K2u+nZH
	7iyEhY7ehb9xxA5/JtOb4+TwwwrtA/E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775137533; a=rsa-sha256;
	cv=none;
	b=ZU14eNHVDsxW8ndzhb+CsrCWPKI+r0X8QrvHHE9djzq8sAcrnc6uRgZKspSJhTYcg3VsB7
	f6m7Arx/ZfUe7GI44wn2ARZW6bF3VDmuTUTZ5ya2yJLV01VWb0UKH7fOpt9OEYkgRnGHJX
	c46ZzHMVR+Ve46f0S0hPvkSWsPIzUAM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cQiFmi+V;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DD95144080;
	Thu,  2 Apr 2026 13:45:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84F1CC116C6;
	Thu,  2 Apr 2026 13:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775137531;
	bh=k9Cznl168Pn0Wx2miebdvhm7nxt5aTwTCe0L9Yb1jRU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cQiFmi+VbLsqDWBV0MWLcRbVBGTTC7gpeECxUQ76bz2bWwxVgrHgXSeLrSQURuU0l
	 oHw+Bz5BnlB/bxZ3XJdPnmIRhKvO1f+DJuubzWKnJl7pCwJO5a7atO1XJU6Y8BpKzR
	 Bqh5nAawkIge9PbJx320y71R6IO5Zgj2CkD2CFUAnVv2ysA6d82NA0Wkil3ZZz8Ubb
	 2FBcsDRMwGVTKO3PMmypgvhmlnseEamVdEcBL9Nlk5EFpF7nrRsrKjXyTUV7jpdOEX
	 3osIepvSgg7J+MxUh8i87Y+3MahYiHzfI62XOPZvH4Hkig2PvaKikLoaHTZ4f6kSEL
	 ETqBNTNwPmBrg==
Message-ID: <1bd5618b-f21e-4f87-85fb-e581d1efb803@kernel.org>
Date: Thu, 2 Apr 2026 15:45:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: huge_memory: use sysfs_match_string() in
 defrag_store()
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260320-thp_defrag-v1-0-6ab15d0d26eb@debian.org>
 <20260320-thp_defrag-v1-1-6ab15d0d26eb@debian.org>
 <3c2f0e52-0271-4bd7-b3d7-84249c40e2fc@kernel.org>
 <ac5w-LjEA3gkGHNf@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ac5w-LjEA3gkGHNf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: EA171C0017
X-Stat-Signature: fo6ef188xrpubwryt8t4oyje9nkostd3
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775137532-393792
X-HE-Meta: U2FsdGVkX18NVwo8CWn/WweX7EmiWJTggnTosv8F60UkyvMmvbZ3VUsDg1e49s84rIiKxW/7Gapc2LiRR0+uldQWZXSlf553u37ho5VO5QYWfrnkcHzN1OWv00bSQGVElSk+G8hRo8J81Gy7De3TQFtIMmPZEiVwy2iaY3To4Zr+iBictaEL7LH3bBN3ryVaL20LpCmRZq1bfGUB3Wo1O+38OJqI0znwGfir2htQavJIvnxeZfus19BnRq0rG33N56NhYPckLAbveebQYweAS4UI2G434sgkI6GvOZWsGhoO8yzBxckCubGUG1QWHcx2MzBToLJ79nv2f2iSNR11vSsiQ+V9aN0UOGPDtkDcSRTf0Ids38itkD2e4UJP5Ay2gqll0miuIA+kESfq8cMhIHSBJXpJsAD/HKcgMzrwR4Zuy7lkQAfcBUwKjh3AHF4+kWOMV/Q2GTWGoUzL3NYN/mWaQ4/YtDvwbGKEHwTJHVe9lHVy3AMQIjNDRYNK7opyl3rx2PT7ALQQXncoxtTOWHo+xlG0lOfrOkWNNgoJ0vqcH196CJonqWikWfOyEXEgFHOYRuHGhHqip4xN7x1zdeM4K5e3zPc9DR9bJuT45VgUpC4RhDYsiSWw6B/3feZ1k1WJdfBkGPJ5sEcEy3L9cpT+18okk2i3m0AnGwuur6uEVOLlEnLhHpkoyZeWzD2VZidFWZ/2smhgSdDsvprL6Xdk/2A0lVJvtkcrHGDS9wK3dCMmy4l+MhzODigw3E3ST2n6+AzQgxW/KsrkdpiwmQ6cRkX/cZmXpgWeTHUg1r78jnE4JCWON10Z0XtccguVfvJnmjGuIJmNn5qLSg3Z1/4lVT6XHMHrZxLZl24I/xuulRB6k+9+D3LNEbrf//mgaCnl30p1474A78L65+pUH+F3JrKsqUpojmUT2j3V0Z3uyKIP/E1WPDgRW6GQH0+Z9+AMFZDRz4SvcjqfXtJ
 zV1YabZC
 p7lZsbQN9p8zWo7YvkXy4XFPASCb2GeAwOZ6YLnFVaDABETvVF3OmC1kB7iB4TbdKpEJ6UIi5nE2X6FKKQ+4BZw+At+XTDlM5fIWUPxZXwFKYYJQrRmuGlrl9Va3kcJW2JsLuVqRW6pAgdlohHtd1q7I75bJdGK/nXnmceIL9KWk5w5X9hnz+Ku9XLPS0OFfVMDXf/P5PDXOKKnBdKW6olxQu9tO3ivg2q6kQiv9pCUZOn12XfeJ0P+grpsweejXNZ0ea0vG1kvoiCIez6/J80myZ5P1AF5kPfYqjPkN6JIqMAAYIrckyVLAOllKZRqS7r55D4+0ECmiIlhbbO6yiEhrH+VU6n1R9pipZVmPkzFrMWsVGO/940H3wiBv+MKAzM+1/zgB5K9diILM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/2/26 15:42, Breno Leitao wrote:
> On Thu, Apr 02, 2026 at 10:21:30AM +0200, David Hildenbrand (Arm) wrote:
>> On 3/20/26 17:05, Breno Leitao wrote:
>>> +enum defrag_mode {
>>> +	DEFRAG_ALWAYS		= 0,
>>> +	DEFRAG_DEFER		= 1,
>>> +	DEFRAG_DEFER_MADVISE	= 2,
>>> +	DEFRAG_MADVISE		= 3,
>>> +	DEFRAG_NEVER		= 4,
>>> +};
>>
>> These numbers should get assigned as default (C standard) I think, and
>> can be dropped.
> 
> You're correct that they would be assigned by default. However, I've
> explicitly set them to clarify that we iterate over these enum values
> using an integer and require these specific values.
> 
> This was discussed in the previous patch series:
> 
> https://lore.kernel.org/all/20260308140530.9ab6d1445d0936467eab4aef@linux-foundation.org/
> 
> Please let me know if it should be removed here, and I will update the
> patch,

It's ok to leave it. It's just ... unnecessary :)

What I saw in the past is that we highlight it by only setting the "= 0"
on the first entry.

-- 
Cheers,

David

