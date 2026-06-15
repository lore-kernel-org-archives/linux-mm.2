Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EEEFCD98DA
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 10:01:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 679E26B008C; Mon, 15 Jun 2026 06:01:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62AFF6B0092; Mon, 15 Jun 2026 06:01:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 519CA6B0093; Mon, 15 Jun 2026 06:01:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 422C86B008C
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 06:01:46 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D23B21209DB
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 10:01:45 +0000 (UTC)
X-FDA: 84881705370.20.72EFEA3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 15A308000C
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 10:01:43 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="H/TxuAZi";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781517704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5AbWeqS/xKwakGdjqbnfqVp4y0udwwlVR+ZRCrbcWMg=;
	b=caBPPwMcuruk3J5wi0m04IXO66E1+zqup1FCk8qiQlx5G4PeAgxUyfCohqwWbeq6kvqi1X
	SLITAFmlCICejNE075xquWWuNks9xDnYjCJoe6OJmHPE5eoV2crz2MWjqaFS68b3bdKz4W
	zc+bwIG3OtZLPXeGoFCl+GM+BzZJ3/4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="H/TxuAZi";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781517704;
	b=RBt5LnjfV2UZ2O/p5H8o/3Cv7s4tJu8FhZDxcggoM0GqphVxEtMvoZ+xMKUKUwdGcm3veN
	8/r81DnujmomOljW9dDSddIGk9q21JXNzvMg8Gor0pZ9L3pfsMmcdsL2yLgr2HdiAA/Sw6
	1eji35NBwj82qdQgG2DAlIp9d1BGd54=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7AEB96008A;
	Mon, 15 Jun 2026 10:01:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D83EF1F000E9;
	Mon, 15 Jun 2026 10:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781517703;
	bh=5AbWeqS/xKwakGdjqbnfqVp4y0udwwlVR+ZRCrbcWMg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=H/TxuAZinPO4H71+nK3269iPNOuT97g11xD6SDqSrKd7T3fxvRlFJgHlI4Gma1yQV
	 /IYJiZhuXR0LLW1db5XGNfABDZkZCbh02bJjkzAhdBC/wFQKZ5hMtroYD8Wnhp24gu
	 71b1QHLdRCkyNprqN9ZxqsFFnipGqqVARGdJjt2yMQJiCv5i1oBLvxZRCQWpgx7R0L
	 HUowHP1uxPwScLWaD7ejXYJsITXHuJpM+dl6x1z5uWY9GmEGuZzrVv+OlAWgTghry+
	 RW1RiJ3Ub64ulmOshHoEtuJc3EYJhRledrDxodS8kEhTft/GYgqYixnRaKiUu+tFRO
	 wlcUW/8WnRa0g==
Message-ID: <1c63fbca-6ee4-466f-bfb5-5ff25a847607@kernel.org>
Date: Mon, 15 Jun 2026 12:01:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/16] mm/slab: replace struct partial_context with
 slab_alloc_context
Content-Language: en-US
To: Suren Baghdasaryan <surenb@google.com>, Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-7-7190909db118@kernel.org>
 <f9b7935c-f5f0-496c-b55e-1f3feee5c87a@kernel.org>
 <CAJuCfpE3XfxLmV-DzM5nLqYqGsFJThr-1i4bmEEqMpGZ28RLFQ@mail.gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <CAJuCfpE3XfxLmV-DzM5nLqYqGsFJThr-1i4bmEEqMpGZ28RLFQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 15A308000C
X-Stat-Signature: r7xwpcc575ftt67ran9f3rry8fm7qf6g
X-HE-Tag: 1781517703-153229
X-HE-Meta: U2FsdGVkX1/lIyDNbimGTzR31VD439u0scVMJRxi8nDtBWwCm/DUPNI3Mjrx7/sDJcwoXpu/1wpchsJDHsA57aF1BKr0gTNvhPZjcZ5dn64RT9UP4EIMcUIzv77ocAuyEMgHJsPMFLURDZrMUnoNFA9nV0tVXna5UU7HHlW0TsAsL4fgZl+Ftdr88rt1BPVAr4jOXq4+iO1TVWPBKnj1J/HfHjh33sF4YK/vhAU+6NrpveHDfdG7HKLbKbL+MdehKXTf/2NHTyeHb9W1VUEP3/mUKm02gA+w/Ef5J25Sgb9mjJ5EM8J7U3AIiydNjSVW4q20c5/SoGQb3Xaf3ypq0Nd8ca4RTqal2pOlK2lhwbpIvkVtu4VbA5RyeiXCvKbkdQE5w1aMqN5FSdtTghsWU9M/Z1QXKZALK9KT1jX+ghmq2KDZLQKmmovMy3ytdoFu8si53PQVaZE/504eVknrE4nft5nnDVlm3Cy8IvIunN6ZFfEtpxTulqIHFENcgY7gXde0sTA1KJF+bBinDixDl2peIjtsCsUT5+kblUaf8I+6GAg4L9sjorsgiqFrzyazhLWalfBXoA68QGy/kGxJA4PxNDb7nmVAD03i1cFonJ/nuanhkOcKSyphATU+szr1dbztrHjMuYxSUzZgwK8gFTjCZBg2aAdeGsY3prn5gFOtULjxq41ktYYOCaYjXFHHZS/G+IjnlVwDZecR1GIsbfXMDF8NblmQs2Q+4JQiFVxo9yu+pzwI/MHpv/9R4QisKr8wgQcqzzfsdp6+izTfKB7iyMbp+vb3+YxEKgn/o4V+B5CUlnkjOUXkdv5KdaXImLcNE048DTIkLD8amSpSr1xu22Ptpmm7geOlTQoEGGX+mBs27G3eVj9KBInxQB91mRpHTahb52zeC0i8YBwSyL3BTyqh7X1CjmCI4+smAqxBIaKXnA87JFsepSVUYkgT5jk3EJQ0WDyaAzuHJ/X
 Y6pWwgab
 k2vLNJWSjZjyauX7QabAS7aLHHpnYNZ80gN5ix8ZJHuflVQ4bNAjIHJBedJI/Pcp5CYFSb6ezkTrFVE0Lt+UgxvOLOxzMzXttlBGJjWXe+mRpu8joGDKW2OfZu574XqeLV8IzIUn4MRW4+IWToyEjtmZUemQs48VxzjyNWRUVvuA+JmulHBfzfkNSBvNGb9JwrmkHPrVW80Ne/OOZ0F9e9Z3N00IYUDboiCvCMyDZ5QO9gyng4OO+HcYcfBu0Ntf0yjYrPCLg/6l6YetZ+SZfe81SxebB5wuNL5As0D3w/ahMqeqxtqLG29Sfo+SMiaUe4KJiqBeSBcSBT2OBDjHFKRfGh97reRcXMxQDp2H2LpXbGolWwXobEhM/jlS3JzTqQHSK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/15/26 04:36, Suren Baghdasaryan wrote:
> On Wed, Jun 10, 2026 at 11:05 PM Harry Yoo <harry@kernel.org> wrote:
>>
>>
>>
>> On 6/11/26 12:40 AM, Vlastimil Babka (SUSE) wrote:
>> > Refactor get_from_partial_node(), get_from_any_partial(),
>> > get_from_partial() and ___slab_alloc().
>> >
>> > Remove struct partial_context, which used to be more substantial but
>> > shrank as part of the sheaves conversion. Instead pass gfp_flags and
>> > pointer to the new slab_alloc_context, which together is a superset of
>> > partial_context.
>> >
>> > This means alloc_flags are now available and we can use them to
>> > determine if spinning is allowed, further reducing false positive "not
>> > allowed" in the slow path due to gfp flags lacking __GFP_RECLAIM.
>> >
>> > Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>> > ---
>>
>> Looks good to me,
>> Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
> 
> Ah, nice! The conversion I was anticipating in the previous patch...
> I would do this removal of partial_context as patch 6 and then convert
> ___slab_alloc() and get_from_any_partial*() altogether in patch 7. I
> think that would keep the behavior of the ___slab_alloc() more robust
> throughout the patchset. But I would say it's nice to have, not a
> must-have.

OK, so I switched the order of 6 7 and all the changes from
gfpflags_allow_spinning() to alloc_flags_allow_spinning are now in the
newly-later patch; the "replace struct partial_context with
slab_alloc_context" part has no functional changes. Verified that the end
result is exactly the same, and only updated changelogs a bit.

> Reviewed-by: Suren Baghdasaryan <surenb@google.com>

Thanks!

>>
>> --
>> Cheers,
>> Harry / Hyeonggon


