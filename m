Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9703C54F54
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 13:50:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3A6F6B008A; Fri, 31 Jul 2026 09:50:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C113B6B008C; Fri, 31 Jul 2026 09:50:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B28076B0092; Fri, 31 Jul 2026 09:50:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 83EC66B008A
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 09:50:03 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EF9FE40444
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 13:50:02 +0000 (UTC)
X-FDA: 85049205444.06.CBB5D2F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id EA47120007
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 13:50:00 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GaXFjw9u;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785505801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E6/53IoTaITFwF6OJqnQibU8ofhN9Lsow6iDpep0Xps=;
	b=ETNYn3Xj0nmrTfZrveht1JSzTli7ZJ86j1APUZxoam8pw/qCzRziqPoqU1qWClG2Q5Q2ci
	NvhDkYg4MIN4BIWmqdTnmEIElrfeT8nOcKMRgMRZEoLYtQEAy2YIiQyPliNGpxfEZ67Xfi
	XDR6r3CfrOgai/xhYDcNENy1FlB2L9A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785505801;
	b=8lKXUXisjoQa8eOIOomDkNqSRdb0p/gzifu+C0um9PYlmvzE9dy5fiy75Cm/gclWDPz8qv
	cfpSSvNszVQq37AKP/4i+yYjj6NlO7QcgcmkQ8zec3Pp+bXVh0lSId9ScsKWdaEx04XKJg
	phcgnEMb2eFfO+sxBlUxn51xOKA50uo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GaXFjw9u;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 44EA9403BF;
	Fri, 31 Jul 2026 13:49:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88EF41F000E9;
	Fri, 31 Jul 2026 13:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785505799;
	bh=E6/53IoTaITFwF6OJqnQibU8ofhN9Lsow6iDpep0Xps=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GaXFjw9ui0agGo1svAJcB/SttjHf5dRf1X34eOINiDbZ9wl3erajDcnoFQGY4AkF+
	 ZdOt1sWOKikj9vjtnoJFEScSFQrHDdIJljctwT2uK6JqRFDQ5SgtSAyb1h74SLnYgc
	 emA9164rFG2eP6Pccs7d5Qk4zL5njRqH1EK5B+wB4NoCNxg0GYJsNkxSojfarvcH8X
	 52YQjalKaamshJOOjaKDCCO+f5BItXxNrcBbqJlYeGefIGhNiM0C4p6+qV56WkZpx2
	 YL/IM9zcAVhQMileoGITOSlOYx15gQQUc3mqO/0UkbnoY9RpWa01O/sJHmv5fkaNO3
	 p/MK+xBS4aMRg==
Message-ID: <e9d202ed-c614-477e-be2f-f51975b003a0@kernel.org>
Date: Fri, 31 Jul 2026 15:49:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/13] mm/slab: skip kfence objects in allocation
 profiling
Content-Language: en-US
To: Hao Li <hao.li@linux.dev>
Cc: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
 <20260727-b4-objext_split-v3-1-c29ef0f1f257@kernel.org>
 <amsxmCmsUTYM26Fh@fedora>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <amsxmCmsUTYM26Fh@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EA47120007
X-Stat-Signature: bt1qsog4egftodm6xfitzqjo9xg94kzx
X-HE-Tag: 1785505800-658948
X-HE-Meta: U2FsdGVkX1+k7NCUZfPoHGOo6w74tNwBCqM91UCt8Nzq5Ol6I3udfWGso6PV6wHcK05hpN6BAuIzGWxyiu5DIPvPG3Jm+O+gXLECdGN9s2mdEh20orMgIwwx/cGDchUGwyRiKmGOlwf6cmha0Uuzo22Ukmf9F2MuNfcdBtopyFPRpLmfy6ETsORLxSzWnmnX5/jm16og6pZrNII3j1ncAMYfbcuwtunnyoJgWAs457hP7gijZft9oLaqYMCaHGKNWIuzB00FK+fvcweH3/Qw0S2alKX5wO/dBW+fG5U/2ml0GB8mitG/H2Hpsf+CSx7K+mEtbHMcfaRDkI2ZhE9Q5RN07eGSR8KvmNeiSwoTQqan7QzGBDKMgk3en2KTY5xFz0TzWRFgjdiG2wRxaN5JwX5XE+0XY/5d8eTl/NVTyT1tXt3EC9xo6dwnvMhiX2mTSXfyV2qgHIciToJ7wOKp29Hm5tsEIW0O2rGHEVwAFwig0eH+msksiocVVq0l+mtKgdivJec0dGjyKnY2mNBOUuLwjvN4njl1VszWOHUWVJjgpec5RvC7ZOrO8B5pw36gK+ZRkCtsUJKpjMV9E8pWG/mEOOZaQXGtgyQkJjOVlZbz2H6kIGxsJHOIQjbCJTB6j7NFQsHNJ1SyX1j8ojhykORBJ2YdTcCGCVvc0l3JCFBRpKJ4+agxQJAhEQGqUrYHxVQ9Mjj6EAltA1RL1XPuUU4VWVO65/iZfaYbkH+KjhQdb4JSDCK/ZoMzoivI4NMDY+Q9tPAjdh06FtfeTAuvUpWO1aSmKuz4TnAmQJ6KXvBSaZjRI98EXd6aZHUXbM93QlLk9mLtb/frhWVmNpGPUhCWqc348HMSRwkND4JAkrVNyB04RFpF5Gfo7c0WPORDxfSohUE1c+HCGR84mx/AX1XjqKvPL43ijTGVhjqAP3oSFO/2EdXaHxSPxMFKI9SdNws36yVwHHZqZ7UaCQw
 cv6UdDnp
 4jxe3VJUQ6drE9DCGTlxOKQvf7mcUPNHK+csghePTIVgrwnFVJNhy44MekAIlyhaV9nx7jPoWhnCTihEVYEgwCfBJFwniTCpVoFFE1nCWF1A3qscnEIMQ00yIh1uwPYkwMQsL6qka7vrz1En563gdoacTSaRS0kTqml4QQTwv0LxehI/OyS9abSSquYK/aZffcLfJSl1nINOgyi34CWVg5xDVzr7IfnAYzUhtuERlosQiJTioIHvuJkvSQMqFJBEf3zFY8iQfukXkvDZkvtWmdijV60eLVkFBg3Tb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/30/26 13:16, Hao Li wrote:
> On Mon, Jul 27, 2026 at 02:53:55PM +0200, Vlastimil Babka (SUSE) wrote:
>> struct kfence_metadata only contains struct slabobj_ext with
>> CONFIG_MEMCG, which is then used for the "fake" slab's obj_exts field.
>> If CONFIG_MEMCG is enabled, the struct can also end up used for memory
>> allocation profiling. If CONFIG_MEMCG is disabled but profiling is
>> enabled, it will end up allocating its obj_exts via
>> prepare_slab_obj_exts_hook() and assigning them to the fake struct slab.
>> These will probably then never be freed.
>> 
>> So things sorta work, but not always in the intended and optimal way.
>> The upcoming changes to slabobj_ext layout would additionally need a
>> proper refactoring to keep working.
>> 
>> However, there's little benefit in accounting KFENCE objects. KFENCE
>> allocations are rare and there can be only CONFIG_KFENCE_NUM_OBJECTS
>> (default to 255) outstanding ones at any time. For any callsite
>> prominent enough in the memory allocation profiling stats, allocations
>> served from KFENCE will be lost in the noise.
>> 
>> Thus let's not complicate things and simply stop accounting KFENCE
>> objects in allocation profiling and skip them in the related slab hooks.
>> 
>> We also need to skip kfence objects in mark_obj_codetag_empty() in case
>> a sheaf is allocated from kfence, per earlier sashiko review.
>> 
>> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>> ---
>>  Documentation/mm/allocation-profiling.rst | 7 +++++++
>>  mm/slub.c                                 | 9 +++++++++
>>  2 files changed, 16 insertions(+)
>> 
>> diff --git a/Documentation/mm/allocation-profiling.rst b/Documentation/mm/allocation-profiling.rst
>> index 5389d241176a..d02eb54ee8f2 100644
>> --- a/Documentation/mm/allocation-profiling.rst
>> +++ b/Documentation/mm/allocation-profiling.rst
>> @@ -112,3 +112,10 @@ break it out by rhashtable type.
>>  
>>  - Then, use the following form for your allocations:
>>    alloc_hooks_tag(ht->your_saved_tag, kmalloc_noprof(...))
>> +
>> +Notes
>> +=====
>> +
>> +- When a slab object is allocated from KFENCE, its accounting is skipped.
> 
> should this be 'allocation profiling is skipped' instead?

The document uses the word "accounting" when it comes to individual
allocations, so this fits.

> Otherwise, looks good to me.
> Reviewed-by: Hao Li <hao.li@linux.dev>

Thanks!


