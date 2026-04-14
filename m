Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C6E9ED7BBE
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 11:03:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9A286B0088; Tue, 14 Apr 2026 07:03:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E23EB6B008A; Tue, 14 Apr 2026 07:03:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D12F96B0092; Tue, 14 Apr 2026 07:03:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C0E496B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 07:03:52 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7064816056F
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 11:03:52 +0000 (UTC)
X-FDA: 84656876304.14.6A075B3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 903C510000C
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 11:03:50 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="G5Y/8fD8";
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776164630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jgyc/BJGxRwJ6A71YcyER0JDzVxGbts5eocxffYmMGg=;
	b=l1ZVEZLXqu2hANh+g8Kxj+yJZUl88zV1Du7lejhz5LzfW0nN0wEmpEaPSO6uFk5DdaJwsh
	E+B0C10SSlcHkCQLuvKlbMmo58T/125X9cerJLJt3fjC69jWHGErJ4dTOlRWn40EjZNk1k
	yHmiPXJS/xI3LNOvDJYrPVmY/jNRKGI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="G5Y/8fD8";
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776164630; a=rsa-sha256;
	cv=none;
	b=wFkou9CDrEu7cYxlOCd5oelHLrTTPoZbpgKsY8ZqGinXR1miu06PC0xOBZgz/s5cCUt6U+
	UHHfZttet6Ht1P9jhdnAPLlYKbU+XJ44XnDWTFly9fm1sEyTKtttNIiJUeYC1PWeTYICup
	ZXpgSW0V1Aa9IIKfgdKf1AkBFvpf1wM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9991F4321A;
	Tue, 14 Apr 2026 11:03:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EB2CC19425;
	Tue, 14 Apr 2026 11:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776164629;
	bh=SrWPhnGntZWEhwfx7DzHlkqjUcIXkV1FnkHFmTuU8zc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=G5Y/8fD8Y3ySpBce9Z9booc3YvxmpqO/2krLoBKNrMw8NezaR0DalOybg3Fub+6Rg
	 yf5qTn7uuQYd7kQVmq9OD1vnheXF/UV9wYDl1BeKjpdZN18nM/dPz/Kml6AHNRwQsH
	 keO3WJV6TtEghMhlv2r/lar6jqRWUYn4shDs9CG5I8oRWFYBgRTBw9IMaCFbSWjMS2
	 Ddv4lr3Q3Q0OBSiEolfYw/m6FWEY7MRykTgHOKR/dB/hUJtNVJ3THauISF1GHPFpUx
	 CXRAmoL4GrGQCFpsofvy6Px4HN37VscAX7eeiUog0y/oGcbjyiG6RW3y8c/EGHCgwb
	 bucy8JBds9K3Q==
Message-ID: <5a3aab32-e96a-4cf7-86f1-7991d924bcdf@kernel.org>
Date: Tue, 14 Apr 2026 13:03:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v2 08/12] mm/huge_memory: remove folio split check for
 READ_ONLY_THP_FOR_FS
To: Zi Yan <ziy@nvidia.com>, Matthew Wilcox <willy@infradead.org>
Cc: Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-9-ziy@nvidia.com>
 <ad1U_Z1b7hKlgnun@casper.infradead.org>
 <D29AD8D7-CEE9-415E-9218-87F07F3F9EBA@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <D29AD8D7-CEE9-415E-9218-87F07F3F9EBA@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 903C510000C
X-Stat-Signature: 19xjts63hs687rgmg9rg6fzdnshay3to
X-Rspamd-Server: rspam06
X-HE-Tag: 1776164630-591692
X-HE-Meta: U2FsdGVkX1+oDfduIe5ytoApF9cVZOKyidM4TTFTG08F0Nu22Z+1l/1xkmoj4WJSUTw9XYanaXHR1hvbg7EDDzpSMygGUbFTBdfnapNn5gTvZ1fQPQ7fCfpAoLYlUfntbvf9ZRjm8wM/mEokfFAwVMfwT7AVuCicVZ03UhUfS0Jd0fzW1GUEBQzc8FDL4VEc/1zOuCxFSMAwhPAYrQT+HMagR9QEVyPBocEMBoA3q3iujJfn6Rrh4RSZaAAXw5AlYO6R3ON8qb+cw49QFWnYerf08AKLzxKnZqfeidl1MO0yhq8oMgDGumwpBxTtnmY0coBcB8QiJ4mRufmVH8YSBXdmoe7r+RISkb5fX4UqGo6lb4Or9DMJV4oN7DKDhqEEHq4WO9O+OwtCmvUwzf2n77ggwKFerR2AMouIMc+idI3xzKO9I4Rg/ckYSUX5TSGrnPylfoVuMYUi+ObuIF4gKw5po+o+tt1bZOEVtMlGycKCs7nJV2DcZd/CPJK+SmYxflyapkHhIFPzcbuippVvSJrSodMb32QnU61liVQUVuxX8ftfU8XG1xFp8/II4d01cHUnpYQUid5GDqVWJR5svh81aI+FRdjk2MpqURZV/V1h7Gf4/wbSsp60LJKfYBPcbkqTTl0fhZYt1ayEf2MFgh7Je39vdIyFJ9HaOYUf6/mT0pIiz2JIibKuUkvgAKBr5yLg5u0HgnOLTkyEqMbRvz+mWrKJZ2YmeDImimOFDz8nKr4TTpnsvmamnTgT51uQm3OAVoKv19ZQz6JprU4eEwHZcRG/PMONTTqB6DLR1wSXSaOKzOX4dWBFYG5ka+4CNUkxxGZOBrQY6S+As5jAyhIs0VEKKhdoBZbeHHz5vqjvriK6qHjIgu3eNHgldi3k3p5I7mdLXqXv27AdO42Y768ISOBsGhPcQV/VUiS0ub1ovDfzt5liyDOrArv3pfTB3G6guO9RJPtEI6sC/1+
 5aeo1XHE
 0bHgmO2k3VvqDmUe/6V5TYPyyN5fw2vfbi0ETgraofvu5vw+/wcXkvV/BKlgLlNfmHkg3D97KknlC8UBKnh82hhB94qWI220u3baGQK7B4OWLuwe3C0FZ/5CQDf23TsfRP9O/lvNBVt6DoPxYfvZRdAEtgImGNhtM6O74+qQn8g5gTjYEUQVPVzxggCUN0eNkPg5nkjB27YOcJYNRa6TUOx72IvWO7NDKzDOYkFTsvcjNWEitJVKdrmuik+FeSbd93NjKiVAeSex5zllgnAvXkvFiY0NE27klETUCdPjFAlGGFUV4kAl+jrGJBNlRFrxrDtmqLwfHRRk/b/Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/13/26 22:46, Zi Yan wrote:
> On 13 Apr 2026, at 16:41, Matthew Wilcox wrote:
> 
>> On Mon, Apr 13, 2026 at 03:20:26PM -0400, Zi Yan wrote:
>>> +	/* order-1 is not supported for anonymous THP. */
>>
>> It's also not supported for file folios, right?  Or do we just skip
>> adding order-1 file folios to the deferred split list?  Either way,
> 
> order <= 1 folios are not added to deferred split list. See
> deferred_split_folio().
> 
> IIUC, we have order-1 file folios but not order-1 anon folios.

And only anon folios are ever added to the deferred split list.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

