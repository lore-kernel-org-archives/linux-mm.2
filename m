Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4DFDCD6E56
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 19:49:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9973C6B017A; Sun, 31 May 2026 15:49:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96E5E6B017B; Sun, 31 May 2026 15:49:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85DE16B017C; Sun, 31 May 2026 15:49:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 75A8A6B017A
	for <linux-mm@kvack.org>; Sun, 31 May 2026 15:49:08 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1C2AB405C8
	for <linux-mm@kvack.org>; Sun, 31 May 2026 19:49:08 +0000 (UTC)
X-FDA: 84828753576.21.BB42BE8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 38BF614000A
	for <linux-mm@kvack.org>; Sun, 31 May 2026 19:49:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aF9n1T7D;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780256946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mK2Bhf6YoJh2Z2OyeiRaRcIGKaedQsLjME5c0Ozqbs0=;
	b=VHZWPdMFIg/CjrHiJfoAqQ/anuGe5lAnTRoakuecwLNYVzA1TqI+9sE3/OILfEn1Sahr91
	jXN+T4kzdlUl3ymLbQMuY6fmXmZyFvDztSBmbKdkfwuGbLjPVaOiuV1Jw6VCk8D7ySp9eL
	/fAbOwG7MxH1PVPOQaUCjE3N047PHfc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aF9n1T7D;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780256946; a=rsa-sha256;
	cv=none;
	b=UtPvsOb0wCinqZ4Z3AxzbhTWIvprl214AhnBBQxENgCm6VVvO8jcI4vVpX6ovDtjrcfPi1
	VCPs/Z2zYwQ7AHaKsZytxCUwAZaZ6nfQI+kWMHM8zfHECl3OoYXlxWFVs573cHgG2LQUaV
	Yll7isxZ5WExmStaG45YX9UMhklM2cY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4A83241569;
	Sun, 31 May 2026 19:49:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39C31F00893;
	Sun, 31 May 2026 19:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780256945;
	bh=mK2Bhf6YoJh2Z2OyeiRaRcIGKaedQsLjME5c0Ozqbs0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=aF9n1T7DCVy1Hkc5fpzdyVCBZZhkp+kaL1rI5Ax02PcKOU7ga0DmKNtwfAjAGiEyi
	 84PLNj2H4A12vPsVja9NqV1Ngi2fbkDIrRANB9RVOeG9yhBrMQRoIHrEpykGSN8qQN
	 y07CpYsQGEw4US40Tg2OK7L6HVCSBswDv8zueXLMSOK7tlS6QO6fzhXHsWzYdO0z34
	 NKVCtVmAc5mOHWoELEpZgZhVc2kT38sdXZCbVGmAdLona1awLOkcL6gdcWkbyUDLVb
	 YMkmx7LTrTPKrXGRDhGoGuEI/czhR4WOKJvNqci5gTwhFJfJlKAk8B/NANIMtsqkAt
	 rUG98FonuYKEQ==
Message-ID: <b45f9b55-5143-4387-aa98-e077390d542a@kernel.org>
Date: Sun, 31 May 2026 21:49:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Process (was Re: [PATCH mm-hotfixes-unstable v18 00/14]
 khugepaged: add mTHP) collapse support
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>
Cc: Nico Pache <npache@redhat.com>, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, liam@infradead.org,
 mhocko@suse.com, rppt@kernel.org, vbabka@suse.cz, willy@infradead.org
References: <20260522150009.121603-1-npache@redhat.com>
 <CAA1CXcCoDU_pnp0SmMzRi8wPGB1OBjbbokevq2X_03X1vpWtOw@mail.gmail.com>
 <bd622950-62cf-4b57-b3ac-89635f28fa4f@kernel.org>
 <CAA1CXcD373fFfo9YPWRj8mJ_rsnzyCrpn1uk3=k7kU=QuaLOgg@mail.gmail.com>
 <a9f43ab4-e47d-4907-9620-32287e3e9b84@kernel.org> <ahVX1iq_-95vd0PN@lucifer>
 <fa9095cc-69a1-468d-a1fe-718386398b10@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <fa9095cc-69a1-468d-a1fe-718386398b10@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: thjqpf7ru9j7q11wkxkp766oo9nat6ch
X-Rspamd-Queue-Id: 38BF614000A
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780256946-146614
X-HE-Meta: U2FsdGVkX19vc2GuDwIa+X04GHj0OS2QqFav1kTKFI3QMAO7kL/OQTZc4FZ8xGycDdHKUhgrJdXj57aBI45t1ume87WWe0LwwUSLoUgq/L1LEPzHC33UKpExlS9P0Wu8l06M6VH0cBj+onIND6iGGpqDItW7GM/vDv/jTzNtz7GTOUsHiLZh5KfBxv2NiD2c6fUFf9YDvJy0AGoHPv5sfFB+UQr3sEKxrPSAyd4pc5uu4+UTfTaDfhYsfA4dGu96StwPrNeV+qtgGJ3Er4y437deSmrtFoEXRd0Aii7MXrba+11BZkelya7XAGaTUWpP0E/fW9I499wNQjRiD5LaUlaIwR4kPXFWXW2F/Dsg8+BkZsd31pTN93xgEGqYyoQVMQnoxFCMyhyenzzjIUwjyxo9zxcc5Xg5gDyX/S7bUtUhagZcawBAja76ruL4al6OOObFi1RV7iRQK0WMEv+hLrHuwL2LC7WPuqGlggHDzLOdav9Ky7/8w1jiuC/n2A2mj6EWwlSkJYFfdKV+fvK9H1VmGy9TFY/NQ64m9sb0d0YwripcPKCWp98vc59zXyyROLCDTCHgMFSIdxxgEy9S6Z9PQYGVwWHtzKw61b7KgO128h1Wdw9ViDigrUh7TDZfVsfEYpx4Cwg6aPfuBoj+zdEhwFxyrUPRSqfTRLqZvIdjwI1h7pVxd2ZAfHC0b9UHJkLsg51kwEuhRRsQt62m6AvwREWZ3R3XAdgYePm6vhJk3IxgSoVeDQNIiVbXDmufIHufN2s4GBoWG7sQoKhNd4825n7HeHyW0nInXURFDZC0h7/fiYpA5+GpOcqC9onFyv+DHv9lgKA/x6oU+LiddBoSHCtMsxn+uoG7iWmchA6T3jvD3otaBGAQNsI9JIqlQVrdyhr+355tLMw3FyaAhCXSmQ0ZGJyRl3hnORGqKOdFH5ZG35RsivwwJ5ZRGbRz9f8m9NenLxVvp06AF6z
 QHpr0nho
 y3QH+0++zK1NwFK/xX9Ae0ba0cwu8Nu3xgp2r9HI7KqKzygO/UK9Pxj24/8azvx/xjYwmgt0NMEBmPOlN9sD4az5xbaxyKH/2t+Z6mOB/C+odkKkCSZBzhun+kH9gn6havauiGqxDrBLBOupxwMOEv56ceGRx4Q5Fyeax7K7lZCgUZUqhbv/rSeUA9QwaPiCoSRt6LeaE3WuNUruwPS2FKP7kKKODc07DH0IdbzIdp2CmfpnU9JsFQQbUwnatz+3Utmhy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> 
>> and have people
>> base work against that?
> 
> This I'm not so sure how it would work. Assuming we have submaintainers with
> their trees and branches, the final "stable branch" is merged from those.
> But it's not a good base for work targeting the same merge window, as that
> work would likely go to one of those submaintainer trees. But then it can't
> be based on the result of merge of all submaintainer trees. That could only
> work for patches targetting the next cycle (after the stable branch becomes
> part of rc1).
> 
> So either patches can be based on rc1 and applied as topic branches in a
> submaintainer tree and then merged, or if they really depend on something
> already in a submaintainer tree, then based on the respective topic branch
> that's part of it.

Right, most patches can be sent against the "stable branch", but cherry-picked
on a submaintainers branch / topic tree.


> 
>> This would be 'source of truth' and what we eventually send to Linus.
> 
> Yes.
> 
>> In that world, the maintainers perform conflict resolution, but with git rerere
>> we need only do this once.
> 
> I think the conflicts would arise from merging the submaintainers' branches
> to the mm-next tree, and if they get updated and the merges are recreated
> (like linux-next works) git rerere avoids resolving the same conflicts again.
> 
> Hm like Andrew said, this needs a diagram indeed :)

It's one of the first things we'll discuss in the upcoming meetings ... I want
to talk to some other folks (in particular, TIP and KVM) to understand how they
are handling that.

Hopefully I'll find some time after my inbox calmed down a bit ... jeez, 1500
mails in one week if my eyes didn't betray me.

-- 
Cheers,

David

