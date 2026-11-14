Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76739606A89D
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 11:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Co09+6WR
Received: by kanga.kvack.org (Postfix)
	id 5CFBF6B05BF; Sat, 14 Nov 2026 06:12:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 580916B05C0; Sat, 14 Nov 2026 06:12:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 447F06B05C1; Sat, 14 Nov 2026 06:12:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 102E36B05BF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 06:12:01 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 651B6803B1
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 11:12:00 +0000 (UTC)
X-FDA: 85433460000.12.FD24BE9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 85D4F120005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 11:11:58 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Co09+6WR;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794654718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9u58OC7k56Oh2FJNigWfAleT6Lj20pexcyKsyjL6XiE=;
	b=WJW648r6kfj75IASXkm3Ol1h5F4tUlDGTSn+h6lio5QZ8bt/1hKEgzSK2XsNx70TqOBFgb
	SafqZC5csITftc1jFRcUGk9wnMyVhDor/FOEtSrgC7B1Djx08/xsYsQvEH29ZyQJToyzfX
	AnQSIB/+x0tPwIOaK4Ovt1n5p50VtXk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794654718;
	b=V6wWPs/nT81o1IP15oenPren1BHhB4qvaHtk9Pqg1bQX8OQEUAsS26KdTwoNwQdadqrZ7H
	L7Tvvg+uJLUxebPhdfwFf5nnLRZVB29QR9+8T4jWArvMy1i5O2On3v9rLL4prsDC5RIkS0
	KDuKsfiZEvEXJycXc3ANVsd1/TGOlFQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Co09+6WR;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B5B9F436B6;
	Sat, 14 Nov 2026 11:11:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E9A41F000C4;
	Sat, 14 Nov 2026 11:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794654717;
	bh=9u58OC7k56Oh2FJNigWfAleT6Lj20pexcyKsyjL6XiE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Co09+6WRFlcwqsospnar4EGcys3raTpikkCYP/B/3HB4f81ufpt1wUl9dRZRvIZhq
	 ir9DClZF0v02mvrLjG9ac+WLlrQLJ4v/Ei8y5zMBqTwZyMio8zGaL4DQ+7GCMKbNYP
	 +m5AJzrCkD1hAIKSGungpJeChB2QdIrqVgvAvybVKHuwIYRe19veAKs+sA1zOFUnMD
	 A8233TBM8kmwt1KsvmtXp8Y8SOtsARfV+MqjRICLQpPBKKuXxKXE9MB7e81VPPWguK
	 JnGY8FJwND+KWuRYoChlKmFe4bS+T84Ec4sSLI+RBqKRoojRyIAsbWdwFmHNT7G44M
	 CsbRtU5TnN0wg==
Message-ID: <2fc85df3-cffc-4786-a7a8-0f0a6347fd59@kernel.org>
Date: Sat, 14 Nov 2026 12:11:49 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hmm: reject shadow-stack mappings
To: "Gregory Price (Meta)" <gourry@gourry.net>,
 Jason Gunthorpe <jgg@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 leon@kernel.org, akpm@linux-foundation.org, kas@kernel.org,
 dave.hansen@linux.intel.com, bp@alien8.de, rppt@kernel.org,
 stable@vger.kernel.org, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
References: <20261113195536.2660763-1-gourry@gourry.net>
 <20261113200303.GA395967@nvidia.com>
 <179460249376.482102.14669935557901467762.b4-reply@b4>
 <20261114002027.GE3706007@nvidia.com>
 <179464112539.482102.8723246686117488051.b4-reply@b4>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <179464112539.482102.8723246686117488051.b4-reply@b4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 85D4F120005
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: kbsmmmxyi636di8ocd571nmx9ccbzqbd
X-Rspam-User: 
X-HE-Tag: 1794654718-87673
X-HE-Meta: U2FsdGVkX1+TgM0GFXXRjGq0Iyoc7KCBgeK3iD5apfBU7itbjg63dPQ/sQfpZ839V3npKgaLDtjjH6Cjptoqt4bIAjL5xfFazFD/YduRQFR648zLvgyskPyehKUIExsIimUKKoPSfrvmjXiX9bd9DANvzeKv3RLIaGhKIa1mzLWBggaRgmiRmodJo4kC99oJYOrCSSrKcdtfy71ojwQlle2y74o9Jr6icPWQ6quaWRDUc2aFVY5g69cqCBUyMcmERRmdHfSrzNgTP7OA6Ygr6cz/QD/5JUoUyPJJyBo3bVzqCLh+EpdoBkik4HoEd8rpCGwko8qiKIQx9wzdgXI6Nv0KKe7OUn6TIWb8bX4X19si0xuEWtOt+flhBzzrrJXXOigAonhCeBgisa5vBA9QwCoqupRCD+QCDVrmNZ8tzwg3tBljgD8PnPj1MYrsOoAo96SrAlXH45+uY/lXCbfjWjkY/nETz+0nftUT3jYEKnZQp/Ydm/5hmRN01MvbmLMwbt+1HyzS7s358hNLbv5z/UbNzfEVXLii47sRB7f1Vg+xWmdu7+qxP2wZpfIYq81WOKj1pIJviMRzaUSlzuuiEGMcP01xrNfzKEHklsSV12f4OBkiiVd5tvruo25tgKIveo+CQg1yX9KbUVj5X3WZwJqwSwqDoq/EtcoVNwOfiAaj3lojIDT5fkwvsWnVDcpguhXmjST9vMuzhW2aQrpUtK7xPKNew/eImKItaWXli/+oECo0q61LIoCkBhwGiwQrGr0FxPExpPA3T4Etk8DJrdn7OcWyPxgKGWyXBOVuO+J8BoxdzPrg6fLo7yPe2amkVDP3+m6R2dfdadjcVRSQCAr1OeMfx2A5Kr/jpUGKLoO4+kGZhsVqrS7KZIyoJbwl3XyroWFX9/ddDge5sZAcoIMGtJrPB8BEJfZDhWA2in9AETpQ/S5gvHph5lQg3UOEo6VwpT9Xo1A/nBA1Hvg
 kDGgb/Tb
 t259Cdv0HppGJWYUE3qitXLuesWYeUUxNkf8YNKAxUHtCxdEZDBSHpWnJ2hepPdUElBULe1URgSSddNfKGbSdvL9UbPAO8P4WvJpPvhjeO60yC1spvB5SQAV1F+6f4Z/UPy1oSNFITstFboE8uN/Q+egxZjQPXb4Jk3bEHNNJ6DWFRuZLclzTktdublJOVQfmP1azP2sQjgqK6T7CvvWkUQHLU6WIqcVX7RfV47B+Fi4JsNYkLcZHQ963BGo9Ik74kinjNsF8E97HL+9s22ZvrgKy79SHxEYVu0Nq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/14/26 08:25, Gregory Price (Meta) wrote:
> On 2026-11-13 20:20 -0400, Jason Gunthorpe wrote:
>> On Fri, Nov 13, 2026 at 03:41:33PM -0500, Gregory Price (Meta) wrote:
>>>
>>> Some of the context is here:
>>> https://lore.kernel.org/all/20261111-mason-migrate-et-al-fixes-v1-10-3d2454362e8d@kernel.org/
>>>
>>> We had a similar issue with migration, but this should handle the DMA
>>> case as well.
>>>
>>> It's "technically writable" but the kernel is supposed to prevent that.
>>
>> Bah, it's not writable at all. The CPU PTE has write disabled and
>> someone thought it was a good idea to make pte_write() return true
>> because the CPU allows writes through a special instruction on this
>> special PTE? So now all the places like this think its writable, when
>> it really isn't.
>>
> 
> I completely missed this, that will teach me to trust pte_write() I
> guess... what a bizarre design choice.  I'm sure there's "reasons".
> 
>> You could also fix this by having something like pte_real_write() or
>> whatever that doesn't lie about the write bit in the PTE :|
>>
> 
> or rename pte_write() to pte_fake_write() instead and restore
> pte_write() to its former truthful glory

It's writable by the hardware, that's what matters to core-mm, for example, when
it comes to things like fork(), mproetect() etc.

*nobody* besides selected core-mm code should ever write to random PTEs. They
shouldn't ever even care about pte_write().

We have GUP for that, which takes care of that oddity properly when deciding
whether we can *actually* write to a mapped page.

Well, and we have HMM that reimplements part of GUP in ugly ways (sorry) that we
missed.

-- 
Cheers,

David

