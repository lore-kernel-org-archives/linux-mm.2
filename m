Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F575CD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 12:48:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B78066B03B2; Tue,  2 Jun 2026 08:48:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B28CA6B03B3; Tue,  2 Jun 2026 08:48:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A66656B03B4; Tue,  2 Jun 2026 08:48:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 996B76B03B2
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 08:48:05 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 601A2408B6
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 12:48:05 +0000 (UTC)
X-FDA: 84834950130.24.47EE284
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 91924160011
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 12:48:03 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ad+0GGTW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780404483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rVzmKFXMREhqLdDCgzF/HG/O3l27gcoWsVI3aFy6nLQ=;
	b=ps9H415Vw0V/9K09ptvObVBFsxHLL0qxSgcWSmsoDWRaStrhl9Ztmk4zhLbC4e9HR+Z6DR
	oMK+s5j5JXpmGjqBtqUjYkzHHmvUdnqiod9ffWoeU4IO5Bf06oUcZOGe0CB8Ij02F10jtL
	550cdisUp4AC5p0s9ncI+qIJTcSrPec=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ad+0GGTW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780404483;
	b=3pYrrwNxpouqgcrMjtOh5o8UKchAdIg9pLQePSKl7Wv1jNFRtrp+HDAhtyTpgJzKHVpEH1
	BLzvJJtObzGEyNneellsLd0bs1NjjYHCRa9Zq0Nu30exXUPZdUiXqvDFZTA1a6FphaEtYs
	KE7wMnKB+l3SmSM9pW1D596pFJevZUU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CAC7244350;
	Tue,  2 Jun 2026 12:48:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 977741F00893;
	Tue,  2 Jun 2026 12:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780404482;
	bh=rVzmKFXMREhqLdDCgzF/HG/O3l27gcoWsVI3aFy6nLQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Ad+0GGTWj7Kt4Vh6j3pFaTfvZWhVgGyL6n64229bd4TndYZP1KUpBH5meMVKUNFC8
	 Jv0oIqwjNfSqNEMGP+Hd9vVO9JM4Yjfcj2sVlYCdgnfe0rPhhgHY/nbvyRgZDBi4fD
	 4dIkjHMNoaXxLqo3rWyatKC/r+RMGmuJmjCfkXTZHuV3Xhta2ZdW3gvXqIoU5TQq8o
	 VV1FOCNhL4/AHGTz+8mYZSv8cP25v86sLrtmiQ95nK54t3iGTV4Y2jTZtYtc/ilbFz
	 4Q6XLiWPd1nSiplKG++LgICLAvO4F4XKT1cuM/pDOtewZKB/VKpXgi6iLBRxzbia1P
	 Cb3SoA9I4Z0dw==
Message-ID: <bfaa33d4-d156-4b11-8735-57a5d1b65ece@kernel.org>
Date: Tue, 2 Jun 2026 14:47:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Process (was Re: [PATCH mm-hotfixes-unstable v18 00/14]
 khugepaged: add mTHP) collapse support
Content-Language: en-US
To: "David Hildenbrand (Arm)" <david@kernel.org>,
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
 <b45f9b55-5143-4387-aa98-e077390d542a@kernel.org> <ah2ndruO3RQGtePP@lucifer>
 <506fed6b-8954-40fa-8b5e-c8bd8c0d004b@kernel.org> <ah2uDhs3a0bFcRNG@lucifer>
 <ca37b7ce-76b0-4825-b238-b504dd499d3d@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <ca37b7ce-76b0-4825-b238-b504dd499d3d@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: y46pqypk9nornw7jppw8dgngquae35bp
X-Rspamd-Queue-Id: 91924160011
X-HE-Tag: 1780404483-800827
X-HE-Meta: U2FsdGVkX19WXgbqE7nFpd+++lhBOHOourJRk+axZQWr0fE9Wp+cd5ldiCP4MjMqlzZ3b1+tew1tX82MlHBTZiaDz86dkuO7FzdRcK4fqMnWWj2JUnDW8I5Tsspzcbl/OwIAygaS118V+TzSpCog0EqBBQMc9qqsb3FlksDxOddAOR8kVy3HR9tTH55R5OGDJTvrC4wXwZVZySWe5+8BYRnirADcPBACAT2TxH9lZdfDFd05YHsxp6MuL5qJbUNo8jqaWmrk+16FQWHkLcut+TSMRGfeKboJacqWvOtsmgo1RmT6icwHJ2Lo3mHuoJyfdXGnjfPEIIRSWeuvvNcXFUteeN6pOfGvRgWZgC6VLcscyWHMqVXPkYoqDk7ojXMVbOyci1fIES419VlskkGypws3UVehIUV9Xg+pIKw2fkvcT/C857RBDA/yuD+Ks+6IqbE00E4mBuhsKpk4Qv2FImf0cFS2Ad35UyuRRQwJ22ZfIznoe/peA8RJWVMt1UwVJ5kCUS/6YVv7WDfynQks2V/9/dtI2ua9kGSkktwmSth7eiVxVsz9ILKYDBe+qnzESI4VnWeKfhyTvXQNDcbYfha+ygXiTI0yAIfaFVsb1xJWiHivWgV4QoxwlWZmQ9x6WufPyZ6pzm+ZdPs8Ke2AG/9YcTfn8KXYAe1AhYrWfil5oXqKD2VwKr+EV3tdj2ZSe6PqtAttdR+C/TkzFi5TgJ+o8L0lWkB8GkLKImK5z6K4MDygkUVgp6FC2W8OH9kfPhwRg59MAIa3y66gr42y7n9uo5D6SdBx1u7awjfs03mshgPqYI3e9k4kSLfXJ9ahiR+L0wrsx80aF0sBmn7DaZdRL8Pb9xKNFZdNKLxxk7pSAbwypgEKqLMP+7u+3Jq7uRUdtxITCFvRnRYvTeqwc+Ekm29FJPavMFHAZrDhpxescMBk4RNv7Qyan0dWOMbWWiMezH1CjkxH5KgWTvx
 JynnpDV7
 rnfo/FGdleJXbD3B6qDv6VToR9kgeL7sySGqo2lE1CoFKwdUMdX7rZxMGbI6OlZeu9IynOvz5/WUphwGVFyVkCdKfzajwr5yGTIP4EugB6oDqAbXizUApGTIQFut2yF+3EhlD6HfKp1zdZXwRu6XjkRhYbvRF4FlOVfEljm1u4Obi/QkD/kFVsJLvmmPmYri2Jrny/gWSgMpcoz24QiUEXaD0SCY5srTXb9bx5ns7Uts6Y8xWelNVhkBPPoGMYxnih+ZP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/2/26 13:20, David Hildenbrand (Arm) wrote:
> On 6/1/26 18:16, Lorenzo Stoakes wrote:
>> On Mon, Jun 01, 2026 at 05:45:30PM +0200, David Hildenbrand (Arm) wrote:
>>> On 6/1/26 17:41, Lorenzo Stoakes wrote:
>>>>
>>>> I think life will be easier with submaintainer separate trees for this honestly
>>>> :) or it could become a horrible mess in one tree I think.
>>>
>>> Requiring contributors to submit stuff targeted at some random trees is madness :)
>> 
>> Err what? The 'random' tree is the MAINTAINERS entry you are targeting, it's
>> based on the mm-next stable branch and only diverges in the work that's been
>> done specific to the subtree, what's crazy exactly?
> 
> We'll still have plenty of patch sets that touch files cross trees.
> 
> I don't see the problem of sending stuff against the integration tree from where
> it can just be cleanly picked up by sub-maintainers (after all, that's where all
> the subtrees were integrated against)? Or what exactly is the problem with that?

The problem is that the patches would not be applied on top of the
integration tree, so it doesn't make sense to base them on it in the first
place. Unless they target the next cycle, where the integration tree would
first become part of rc1, which would be the new base for all the
submaintainer trees.


