Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3FBFC55160
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 11:48:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC7FC6B0088; Thu, 30 Jul 2026 07:48:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9FA66B0093; Thu, 30 Jul 2026 07:48:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8D8B6B0099; Thu, 30 Jul 2026 07:48:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8D8CD6B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:48:42 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2EE30A00F1
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:48:42 +0000 (UTC)
X-FDA: 85045270884.12.1B77E4C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9540A20004
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:48:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KKR4hC0h;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785412120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XmU45OCNuFOiwGfrBinV6WwQ/rNggasBHJ+eyOZDXdo=;
	b=lk+VgWZOF8r9wb10rsc+Qu0r94exyCUWIfG1whdETUyuD8u/0yMuUY4/AAL+O92FgMnzc9
	9Klpc1Eh97m2L6IT2oyNxWy60fiq3oORxypKJYAnhGEffc0S0geTWXao+lvrKttwZbS726
	HUKTbHcfn88aifFItUV0rooxou8Mhd8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KKR4hC0h;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785412120;
	b=d8JEM4BM5JcYNs9JlDL6E0tyHsF9/rIrc/axMwHoT4H8rzSG3oT3QoE7D/dRlL4GsrMonG
	stn8pq7mrDx+GQUE+3RrS2CQEk+Cj1J/jkIl0xAolS7SdPOWiiCOFf8KEoyna9/1hRV5w3
	Qha3n6/v1wtO/F5D/iI4zxY+Gn5JtFE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B1C7840832;
	Thu, 30 Jul 2026 11:48:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B66A1F000E9;
	Thu, 30 Jul 2026 11:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785412119;
	bh=XmU45OCNuFOiwGfrBinV6WwQ/rNggasBHJ+eyOZDXdo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=KKR4hC0hisUM68EidQUezR8zfwNy0414zRBBLqO65Nl+SsArL+flSO5eWsVfIE24o
	 AfQQNHa8nvQ8Ri2p8ghrcZ86orQfPeVsaquEYI1xm2CjqTrS20K4EaLnyLcsjs25Si
	 ZQw1C7ANRR92SQPXctO2KqWJn8WCnWNLp77U3sUr18v36L1X6JvXKboeYtNJ1IPo6h
	 caQ8FAjONcV87XXUOa1zCIiGRQpzpxm/uEb1aiRQ95h1HEb+tC9YrFxX5QOHKApn44
	 gEuifJKyeNAmxwe2LQJcCo+KD7XF5DbGRKwao4yLlKXTDPVm37hmehQpfQbgtEoyfo
	 +DGmTfWAh/G3w==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Alexander Graf <graf@amazon.com>,  Muchun
 Song <muchun.song@linux.dev>,  Oscar Salvador <osalvador@suse.de>,  David
 Hildenbrand <david@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Jason Miu <jasonmiu@google.com>,  Jork
 Loeser <jloeser@linux.microsoft.com>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 18/22] kho: extend scratch
In-Reply-To: <178540063445.2151126.14089645580528118019.b4-review@b4> (Mike
	Rapoport's message of "Thu, 30 Jul 2026 11:37:14 +0300")
References: <20260729145610.2827231-1-pratyush@kernel.org>
	<20260729145610.2827231-19-pratyush@kernel.org>
	<178540063445.2151126.14089645580528118019.b4-review@b4>
Date: Thu, 30 Jul 2026 13:48:36 +0200
Message-ID: <2vxzqzkk7l63.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9540A20004
X-Rspam-User: 
X-Stat-Signature: mckyhxi6erk6jzotaigk6ofgmbi3dyqb
X-HE-Tag: 1785412120-436226
X-HE-Meta: U2FsdGVkX19dDTP5iwcUMAzbzMkWNZIJFr2ng2UaWk5k6X/vMMKs5oUMOhyZmYukgZcqPdp9c7uZsvOILaC88hEmfwQ4VoEVKBC1C/BspKUFPVvl6X7eyzCDN53jqpyCTUcHy9u+YbQHrpCN+KlscQXrfEDjfQvvWEhXZBuBloFsQJ1koa6PzIsWtrmbFEn/lX4ss5usCJ++IRqe5Yl+lCK434IVPZ2LgS9EEqP4PlXHzDDCXpV6WNrBTX1ORVl9oP/DW6DfPQaOt/O1FNEHXR7FDCBk9DsfARs4/7a9CSgLEA85SMc6y1osZAQxtIAG+oC3xruOnepucjh2uMhLIZb2LHJiOSRX17DRk+JALzbU6rEdeG9Ww9X26UMZpXV3xnp2kA187H4Tj98sZgeWD3xpXXoSlQPJq6ydTPD8I75a2RvAz3L8vZtaNgxmzAsIiKoemHutuVnIeSDmKyAIXeAvVBpPk7ykEPmIIqhRymi5LRNQ7/k4Lyj5xKevoo5t1u1b3/kLXNryvZtt5uXTGdjCjvDMPggod4D41GWWcc2sy9Ckn5SeR7u6kzq9T62m+5wzsd4Z9BM0sm78GZfxD2+lDsem6lblt+tGOF23MneMUCLl4yTUor7fnDxs6rKW0lX28J7qsOh/yrlF0ggTGojUTU96sKyWYxA6Nwr5obbFLsH1BAM62VcRt504l/GGJh+7wahv8OuGhqI85S+/19eXMKNGk8jiK44LfWUsvQ03bIUznB65Fnbq1/MDevCDh8R84ct9T3OV5sP2ZmWNKRBW9t8rDPW+uddFELxI4Qw4C/6loffMSno07WAEwfYQxbdJ6ntcnkQzBb3PvIocjlDB5QbwjKi2DbIe8hUw5NUcav1h/A2hOzT/bWUGgcfzZnRHi7FoZBroW6zQs1myq/bwL8xN/kdbq4z2ingkX5SrljFJyaH4KtYye4kMrzRehgqUX0YlnNyCBN5vD84
 CypSUKnq
 yxHTI4gIWclHs98/MK51b/TXc5+ZB1ScCA4oosCIzT7KNfJMatHwLdxOV5K4BsXFFIecuBKSpZTnVLw8V+3EYkHWsR4/Fng9QWF1qWFhcJfqpBSHZTTGDWxrFzSQcc51pybpz5yGV46szWS3n9jomow9eGHVNO1yL/IDJ1WFX69w7M2fL5ffGuprAZXDEaqd0qHMAwFoZ3QDH4ZXXDHPqO28vUQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30 2026, Mike Rapoport wrote:

>> +static void __init kho_extend_scratch(void)
>> +{
>> +	const struct kho_radix_walk_cb kho_cb = {
>> +		.leaf = kho_ext_walk_leaf,
>> +		.node = kho_ext_walk_node,
>> +	};
>> +	const struct kho_radix_walk_cb ext_cb = {
>> +		.leaf = kho_ext_mark_scratch,
>> +	};
>> +	struct kho_radix_tree radix;
>> +	phys_addr_t prev_end = 0;
>> +	int err = 0;
>> +
>> +	err = kho_radix_init_tree(&radix, NULL);
>> +	if (err)
>> +		goto print;
>> +
>> +	/* Walk the KHO radix tree to find busy blocks. */
>> +	err = kho_radix_walk_tree(&kho_in.radix_tree, &kho_cb, &radix);
>
> sashiko: Will this trigger a lockdep recursive locking warning?
>
> I think it will.

It does indeed, but that's a false positive. These are different trees
and so they have different mutexes. So I ignored this when sending the
v5.

But now that you also point it out, I went and did some digging. And I
think I know how to fix this. Setting a different lockdep class for the
local tree makes the warning go away. And from my sampling of other
users of lockdep_set_class(), this does seem to be right right usage of
the API, though I can't find much documentation on it.

While trying to explain in a comment why this is needed, I also realized
"radix" is not a descriptive name at all, and I renamed it to
"busy_blocks".

I'll send a v6 shortly with these changes.

-- 
Regards,
Pratyush Yadav

