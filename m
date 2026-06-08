Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0718FCD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 09:11:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FE2C6B00BE; Mon,  8 Jun 2026 05:11:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 287F56B00BF; Mon,  8 Jun 2026 05:11:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 150066B00C1; Mon,  8 Jun 2026 05:11:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F39BB6B00BE
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 05:11:05 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9F80C1C2BAC
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 09:11:05 +0000 (UTC)
X-FDA: 84856176090.28.299AABA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 069BA8000D
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 09:11:03 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ItR0pG3Q;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780909864;
	b=60OqTURjkjQNf1uN3rb0iAXTtkGaN7/egjNlNsFpozDx6SQ+/yQfBOWLsxvFPl6yfiEc5k
	tVkAmMMjiGqWfa0Zu53VgtpfaXqZucnPZ0Pqdi7ftU3vF6lPJk7s0LyCraoRUzzhInx8IU
	/JsTIqfgcs3z/e5G9Iw2+b4gfk0827g=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ItR0pG3Q;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780909864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BFff0qw1eQAiypeysJZENVXCeIwuiMgTCoupaaA1AGg=;
	b=n0zkqQGNSsQDLu9cCeX/orYntFOtCxrRJx/go+k4SICjQqSjEbof1H5Mlr19BT8MKmp7Vv
	Y+F02EF7KK80H2yKqul9fAMLQavbnM5gY4t13BFvkeX5+hJJRTvAEyl7J/OdMDCr783v4y
	k+6ZtJUkb387ei/4d+RZw1CWg2GzUsM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7A526600AE;
	Mon,  8 Jun 2026 09:11:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DE0A1F00893;
	Mon,  8 Jun 2026 09:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780909863;
	bh=BFff0qw1eQAiypeysJZENVXCeIwuiMgTCoupaaA1AGg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=ItR0pG3QoAc09PLrAgHj7dzp9NWDYPsSmEmIv+MSZypxRomUz4VHNPTpGSviY7RiQ
	 cG9rLDGeopY9FhwrDKxtb9zKgebONgf7oKI42YN06s+hl8oyL/wiygF/KfIBUJENCk
	 QVj2IgTjlGCZU5CIalas4DHj4o+f8Tq/KPmmAvB3XJ5bm8O2YRveb9/2kD6q6P4u94
	 hjUgvAyz5mDHWapAF0+agr/bJ1JzGbLgR+h11S+YMCbgzLu9cYD6I+it6y+XN1mHRA
	 HRA4TRDC1U3dazGiyOnbRtx5X9PA2H4U5gc4IxN3Hd86rADLwxWX6/H6Bm/qmSXWrP
	 UsHNoW4hwc/Kw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Jork Loeser <jloeser@linux.microsoft.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Mike Rapoport <rppt@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,  Alexander Graf
 <graf@amazon.com>,  Muchun Song <muchun.song@linux.dev>,  Oscar Salvador
 <osalvador@suse.de>,  David Hildenbrand <david@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Jason Miu <jasonmiu@google.com>,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 02/18] kho: disallow wide keys in radix tree
In-Reply-To: <fb7ed559-557-b8c1-1f6-5f879feab0ec@linux.microsoft.com> (Jork
	Loeser's message of "Fri, 5 Jun 2026 15:06:05 -0700 (PDT)")
References: <20260605183501.3884950-1-pratyush@kernel.org>
	<20260605183501.3884950-3-pratyush@kernel.org>
	<fb7ed559-557-b8c1-1f6-5f879feab0ec@linux.microsoft.com>
Date: Mon, 08 Jun 2026 11:10:59 +0200
Message-ID: <2vxzwlw9tn18.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 069BA8000D
X-Stat-Signature: tyx6b1gqba4s43d5bymrwc3tz3yx4y4w
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780909863-404173
X-HE-Meta: U2FsdGVkX1+E1DJQfCFfN4A8Ru9GZKUCXPTa9ZVzWzHMEK0LXJv8A1M9nvHONQpaMqMUdfAFLFeSWN1kj3uTaue8uwbLTboTtdE8e1udlMe/GA4QjnRuayi+oEZV72E/7uRgOtjiM0rFwABTaCLk53gsZMoMnz4roDQbvKzve5bLTysru2lEPlP4Q8b6uHCYIk19Ooor1yJ+oPy/GpfiWUVkKcYTaRzbQJd2boQkJuyEHgAWZ2uEKCJ3LeQC75C8GhSGZAlb8HRD4JIUwXZzYvTUuAxuz2t/1OE8ECz5VayjeV4Ln1yJZNHfOiakf/SbVrG/UqJgzhre9y5nIvl9HUvxJnTZV4pHn0Tg4DbcpSlzc0UrBycAsy7KONJZlr62ieR5gL8GXpbVueTlfn17sQNiBPGsdE/UQIXmu7WVb7fZjKsxOfTxsK0kuxjS85Ebvo3wFzvD1YzPygg5JiMjNBdkRz7O4h1GDb4eCJSDvG87nvJPC8xVmTzYNlJ3F8WAdqdIv56hQm1yzgYwwBCtdsrvsAmFjLe0WPxLozKJPdq3Hb3nk4yWaDhqDx6Rcr+QRGQlAf6/P1ToEMTNhhThO3SStxwOsWH9GPNyVTrtn5SnCh8QvItQ7DD3D4GsVqfuLzE8K+j52mm/iwREc0yh+X75Djy1s21XtmmWUuPpk4UrOb/t+XnnD6mB4PRBBd1091qprgHcQ9eUuIZ1jhlJ3FjEie1UD3RRnY+/cq0qc9Zk5TT7IX4/mBxsvor92iRTooH5Tk/CQrrX4m7PaGKyIRRC7Ul23xXw6Wb3l69wLMzaHCwaKSUlvg302vB/VdxSyfCquoIgvt8anYc0BtvWy3AqITv9ODbM09fDx/b1NzafqSmjLOQfiMziRCqjAmkRYuVUtLef/sbTTvAxCOvLpUsHp6m0J0voWlJvX8wcH8JDIoOWUiiLQ+ixYnAfTqOwId/ZWIEp/vAFAD3IKqd
 kvACcja6
 3Q+ypa0aroXOcfHkQCx+8D82hw0poC46CuOh+92S1R2DMye3TiSvMu6od3QtOH8fVyBxaX1sX4pBIgH6j54OrpBc1KwgVrWT1dHPDyVkGiAdTGhmvP5S0myi/3708Yby+A2K8DNoWVGqtILcHlgEhP+BIYUol0y6qq/kfnKMRNFGjeIBDpsHyobiZG6Eu9PGWD++z3r+JCA/kdkT0LD99sDuNVBw5sIooArUegTMAqUUhi1e2bqsSJC5Ilt8gy7aCVKFB6asA+drq7pk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 05 2026, Jork Loeser wrote:

> On Fri, 5 Jun 2026, Pratyush Yadav wrote:
>
>> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>>
>> The KHO radix tree was designed to track preserved pages. So it does not
>> provide the capability to track any 64-bit key. Instead, it limits the
>> key width to how much it needs for tracking PFNs and their orders.
>> Limiting the width reduces the number of levels in the tree.
>>
>> KHO is not expected to be the only user of the radix tree. With the API
>> generalized to allow other users, now it is possible to add any key to
>> the tree.
>>
>> Check the key width at kho_radix_add_key(), and error out if it exceeds
>> what the tree can handle. Do this instead of increasing the tree depth
>> since right now there are no users that need to use wider keys, so this
>> avoids memory overhead and ABI breakage.
>>
>> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
>> ---
>> include/linux/kho/abi/kexec_handover.h |  8 ++++++++
>> kernel/liveupdate/kexec_handover.c     | 12 ++++++++++++
>> 2 files changed, 20 insertions(+)
>>
>> diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi/kexec_handover.h
>> index fb2d37417ad9..6dbb98bfb586 100644
>> --- a/include/linux/kho/abi/kexec_handover.h
>> +++ b/include/linux/kho/abi/kexec_handover.h
>> @@ -278,6 +278,14 @@ enum kho_radix_consts {
>> 			     KHO_TABLE_SIZE_LOG2) + 1,
>> };
>>
>> +/*
>> + * The maximum key width this radix tree can track.
>> + *
>> + * This value isn't ABI itself, but it is derived from values that are ABI.
>> + */
>> +#define KHO_RADIX_KEY_WIDTH (((KHO_TREE_MAX_DEPTH - 1) * KHO_TABLE_SIZE_LOG2) + \
>> +			     KHO_BITMAP_SIZE_LOG2)
>
> Love the auto-derivation of these values, this totally makes sense. That said,
> my lazy brain complained a bit when I asked it "so how many bits can a consumer
> actually use?". So I wonder:
>
> 1) Why is the value not "ABI itself"; it feels like it should as it
>    determines client behavior.

The main idea was that if you delve into the details, the value is a
combination of other values, and doesn't directly influence the binary
structure. For example, KHO_ORDER_0_LOG2 (64 - PAGE_SHIFT) influences it
directly. It decides the width of the keys that can be supported.

But now that I think of this again, I think this patch is kind of
stupid. The equation for KHO_RADIX_KEY_WIDTH is exactly the inverse of
the equation KHO_TREE_MAX_DEPTH. The max key width is (KHO_ORDER_0_LOG2
+ 1), and the equation for KHO_TREE_MAX_DEPTH uses that to arrive at the
tree depth.

All this is very obscure unfortunately. First of all, KHO_ORDER_0_LOG2
is a very undescriptive name. I have no idea what it is supposed to mean
or represent. The comment above doesn't help much either and I think is
misleading.

Second, the equation for KHO_TREE_MAX_DEPTH hides in itself the fact
that we need one extra bit on top of KHO_ORDER_0_LOG2. KHO_ORDER_0_LOG2
is essentially the width of PFN. And we need one more bit for the order.
That +1 is hidden in

    DIV_ROUND_UP(KHO_ORDER_0_LOG2 - KHO_BITMAP_SIZE_LOG2 + 1, ...),

I think we should to the following:

1. Rename KHO_ORDER_0_LOG2 to KHO_RADIX_KEY_WIDTH and make its equation
   (64 - PAGE_SHIFT + 1) with the comment above clearly explaining the
   reasoning.

2. Now that the +1 is in the key width itself, the equation for tree
   depth can be simplified to:

       ((KHO_RADIX_KEY_WIDTH - KHO_BITMAP_SIZE_LOG2) / KHO_TABLE_SIZE_LOG2) + 1

   ... which is an improvement I think.

I've been tripped by this radix tree math before, so I think this might
help out a bit. Will fix that in the next version.

>
> 2) Would you consider expanding the actual values for the most relevant
>    architectures (x86-64 w/ 4kb pages, arm64 w/ 4k/16/64k page-sizes) and
>    put it in a block-comment?

Good idea. Will do.

[...]

-- 
Regards,
Pratyush Yadav

