Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FDBF606A33D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 18:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LtjgAtYo
Received: by kanga.kvack.org (Postfix)
	id 3FEB36B089D; Tue, 27 Oct 2026 14:58:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D6A46B089F; Tue, 27 Oct 2026 14:58:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EC8A6B08A0; Tue, 27 Oct 2026 14:58:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F15DA6B089D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:58:30 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BA3AD120B02
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 18:58:26 +0000 (UTC)
X-FDA: 85369317012.19.8FBE898
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id E12134000B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 18:58:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LtjgAtYo;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793127504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u2yMh+u2ETflUov7pejt9JZNgRsva0yVABsIFHQ38bs=;
	b=I9pYZiywnk0OXXtH/9wuIR0eA3Dz1qe0PP5mven2D1nvDhYwezo9QZulav8iFlLAKdnfAv
	jfDHaSq+rtMOe/i1Zz0Rv8BIQ6VM5NRq9jp1gaI/2C21UEj1oJ0pEg5A/xMKG/Z5+YgZcV
	qyHt2sSj7XfrDuSwinPgK8Q12zgCIT4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793127504;
	b=GtaxpyZ3JWeSDlPyGFrOy4qa9rRAgheU86uvbYB00/NkFxe5a4m2gRCEEfbzC5n0Bxc4gO
	Xqi0Ab/gzGDqiquYjvloz3+z0n4q2M++8wyu8HoG9xz24I39GtlXkp6mjuME7TIpgCzn2Q
	BGYDerwAAuWoC+B3jM/9I0rdEYmRiV8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LtjgAtYo;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0AA4C601FA;
	Tue, 27 Oct 2026 18:58:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A591F01825;
	Tue, 27 Oct 2026 18:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793127503;
	bh=u2yMh+u2ETflUov7pejt9JZNgRsva0yVABsIFHQ38bs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LtjgAtYoaRtsTjIRQpRSFAn3vOq6pDx2vhcZTQqOtPf5cITj/2/gIAVsm1hXQICOd
	 mFgPQvsdJEZMRJs2CfxOLBRkUaQvZ7//pJZjXloL/kKBORvouD5SBH6+gonP0BFlkL
	 61LAyBEB9ezEm4aGl2Jgnzyvo8hdwi73QG+tS4quWoNQNnf0zdC2jgieufGGCbzLuW
	 wwWn7SyV0Uc/5dN9qNkBaFczItU6JLXWBVY41nPUT6+K9oEQJIYxi3UTc2DoFH981p
	 asg/5U6ggQZjnZGzt7HXEYdvU9EVg8y4GlCcG3cE1u4mbLHDruUPxRn/n5k7i24ruo
	 dGUYjq7RsK9QQ==
Message-ID: <8a841fb1-8e71-40c6-91d4-3252a0a1a368@kernel.org>
Date: Tue, 27 Oct 2026 19:58:14 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/6] mm/page_alloc: don't undo another isolation in
 alloc_contig_range
To: Zi Yan <ziy@nvidia.com>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
 kernel-team@meta.com, akpm@linux-foundation.org, vbabka@kernel.org,
 surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev,
 hannes@cmpxchg.org, linmiaohe@huawei.com, nao.horiguchi@gmail.com,
 ljs@kernel.org, liam@infradead.org, rppt@kernel.org, osalvador@suse.de,
 muchun.song@linux.dev, iamjoonsoo.kim@lge.com, anshuman.khandual@arm.com,
 stable@vger.kernel.org
References: <20261027042204.3741307-1-gourry@gourry.net>
 <20261027042204.3741307-5-gourry@gourry.net>
 <a4fc92b5-7d99-49f4-94ac-89fdee699042@kernel.org>
 <179310997463.2232644.3260379218896917308.b4-reply@b4>
 <6f5aaf2b-894c-4306-a0b2-e56f815d0a89@kernel.org>
 <A4D82AB8-F33A-465C-AE69-933B746E4885@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <A4D82AB8-F33A-465C-AE69-933B746E4885@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E12134000B
X-Stat-Signature: zu1f73qbnqxcboigopgi9auq8dw6gyin
X-Rspam-User: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793127504-615884
X-HE-Meta: U2FsdGVkX1+XMObr2fKcGWBrVv1KF/y3JizRSTxb7pilnZF6RSknpeFDqnQEZJb+VSnDG7CfUZwZ//kFi54nWYc/nLTEsEWFo/6iaq9rRfclSVlakigASL4C6mJd0q1XqP3X6YDZ/kUOg5w93vlEulNPuETr1cqUxwJQSG3jskZSFqkAuPQR6Z7sydkK96cxdtKgvLURUBiQN+hG4A+DeUDC8tkNWVi0cSm3AfZNKzvWlJV8pXq8+jHwbst9LPH3VlbsTZFlv5BYRxXHrz7544zQ07TYzfWefaq2IRPfPvbFOExLK31VSTk80aISyY+QF78wBTv9hU41NwPIrkjrW4sF7OLWg8oJBWmkCBraDuWfY2eZ+wv6hxMu8iug1ORBBG3tVoAT1E/jWOdId/4tg9XYRMVNN1mM64uNICc0XlDaCU64LNns9220GpCyYZs+xqzv92yMk8ci61qBp9+qNHajXhefOOgGSWuyBE9ieTZdH3Vu6t0TU5NH+sO0cOFdQt7MiPF8SHTzgvEvEPVsfyS7+KK7QEjHmELP6BZvTRMqkdSX+/bg0bB+CrX6/9S4oToCgndqreUHE0Vf14ErHaHkZMivjXKzbDyWX8noewwkfO7OV0gejSWo9y4vEqwtN7EmwdneqyTGHipuIcD+asyuerkr1+VylQidtg3tK8vNDFOruHghRkRpCTEa8Btq5ESnN++OMpapkY+h9vhnf3YFRDjLV0USPk6EIAfenH9xZuwYj6LKCBythuIuuu1OW2x9JWD56ROfTiyC4rN4vWvcxBEVykj9KVS0cXhjBqrs8H6ZYacgUv/rIY04CDlYNWiKiexygisPSxIpEphOrA1gGtSCCTOoZ9Ieo5KLyOtZYDz3OWKOfpfsFJM314VoRyV4zAga7zTXhz2ayGBxMRLyX3xvauGoOJHWkdQor/On2TnbH6Kuksb4VmWzXi97QwBjDNW3759vac428Jo
 fmC+gdSR
 lXA5ojxE2jSrbUnxDN2Quvis6pXvAULwj75x28TL1bRUHElaT5wgLmZSBksIypY1srVbJzwRCBBPPVm0tOjqL28gxv4a8jWu2rtHWtyB0eVYziU3G2bpu0ssGQLRr/Jxbh2VxlKKTJbiQHXRZQubcE8v1D15cH9KOzjPMc5ZWLCtr46+EWRwz3gIpg9WH4dxtsIUU1CX906Hxrwck3jgfrrwyKZW7DXKCA5zuTpvfRH/cnypJ7inqBN5NQZGiwrfHCxesYdqytUn8jwlEC5kwHJbN7Q8fG+V2+unVj1WwGoGGAdwiEobgzjzygPrkknFYpnr3lOqyFToyTe2BPKA7X4rl3IwHnmAoXDangErrUNKTwxXzCRMi5yz+pmdr+3zxoWyC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 19:53, Zi Yan wrote:
> On 27 Oct 2026, at 10:13, David Hildenbrand (Arm) wrote:
> 
>> On 10/27/26 15:06, Gregory Price (Meta) wrote:
>>>
>>> Yeah, this is going to happen more.
>>>
>>> I've been sitting in these patches for over a month while they soaked on
>>> hardware getting performance tests.
>>
>> I mean this fix here is really just independent and shouldn't wait that long :)
>>
>>>
>>> Maybe worth a private tree we can rebase on regularly for these kinds of
>>> un-vetted/posted fixes to see what's coming?
>>
>> Maybe. But if it's just us core people we can just talk on IRC etc (like Zi did
>> two days ago when he was about to post something that I already had on my queue).
> 
> One idea is that maybe Sashiko is able to identify patches fixing
> the same issue and does some grouping or tagging on the website.
> Or send an email about it with a lore link.

I think that's too late. For us core devs we just need to sync on "has someone
already a fix for that or is it worth cleaning the AI shite up and sending it out".

-- 
Cheers,

David

