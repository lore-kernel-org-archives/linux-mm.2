Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 829CFCD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 09:11:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC1C86B008A; Tue, 12 May 2026 05:11:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E99B56B008C; Tue, 12 May 2026 05:11:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAFB36B0092; Tue, 12 May 2026 05:11:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CF4116B008A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:11:25 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 86E2C1C0E86
	for <linux-mm@kvack.org>; Tue, 12 May 2026 09:11:25 +0000 (UTC)
X-FDA: 84758199330.30.5BBC8B6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id E5D99C0010
	for <linux-mm@kvack.org>; Tue, 12 May 2026 09:11:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZxKzUQIV;
	spf=pass (imf22.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778577083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jWIKLyq7FH0+R+N+F4OIKVJiretAMtcnJ9k3w/L+AOQ=;
	b=fvK8RWBMrizQChALAUOY3nfQyHyeuGftW0jkQu3gSwg8lYmUlYRq0tKBPIbh3VZpfk1xjh
	MVLnvvjT9nMgClufHFWeUqXxCnjD7PM4nq4izcTVkISKb4ca7zB5wWAl/VZpxadX44TN2F
	UQQA0Mn+hSSN0W88Lox7sK6dqKEwKWA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZxKzUQIV;
	spf=pass (imf22.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778577083; a=rsa-sha256;
	cv=none;
	b=aVBq/TK8tIaGJHWEiyt8mKUdQ/7ejL8IMiqC9KPFYTfH+77geh9BElsZMl8FQRopEdeO4t
	5HYuwSliJ9axXrvB84TVNri55UGWRsFNjVGnzR3H8mkMJsUqwJBJ7s5+JUfAZdaxICxLsr
	C42W5/2M/bsuUqe4vu1Q055SnWnVaN0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5496A60055;
	Tue, 12 May 2026 09:11:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C522C2BCB0;
	Tue, 12 May 2026 09:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778577083;
	bh=4hEM1RL8Q3Ecwa5JN6pAuey/y8Z41JPI8moNXj27aEA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=ZxKzUQIVFSSFvPwUMy6zzHWK6v1yyQI1+b+4Ay92xGyuOyc3XqxunISgVEJQvaKA4
	 Oy6Y4eYSvs12RXLwsN5+5j2dyT3SSF8wxviUh2MORKlbFblWTILDTl1PCORmQaP06Q
	 fU8HEyQsgxqkQofnobPNrM08cCp5h37FBzg9Z9I1runT4dowCTEgpr6xHhuSzAyqyq
	 2VVUZViPyuAV3PeanymbGtGgDbVoYgo0LUdtA7a8UPQU3yRu12L5C2ECT/vLUUTrHZ
	 vfSQiIi8AA8b12fYfn4+jW9dhw4wTBUFR8YeIfkTpKI3WHYIzOwaisWWs6FJSohkH8
	 M4kZPjXQkZ1Fw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Alexander Graf <graf@amazon.com>,  Muchun
 Song <muchun.song@linux.dev>,  Oscar Salvador <osalvador@suse.de>,  David
 Hildenbrand <david@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Jason Miu <jasonmiu@google.com>,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/12] kho: add a struct for radix callbacks
In-Reply-To: <agLNUKE5LZqcoUex@kernel.org> (Mike Rapoport's message of "Tue,
	12 May 2026 09:48:48 +0300")
References: <20260429133928.850721-1-pratyush@kernel.org>
	<20260429133928.850721-4-pratyush@kernel.org>
	<agHB7HB-p_vkLS7R@kernel.org> <2vxzzf25c39x.fsf@kernel.org>
	<agLNUKE5LZqcoUex@kernel.org>
Date: Tue, 12 May 2026 11:11:19 +0200
Message-ID: <2vxz5x4tat6w.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E5D99C0010
X-Rspam-User: 
X-Stat-Signature: eyguhenu1gr1y96gi7t4b479ibim1me4
X-HE-Tag: 1778577083-95662
X-HE-Meta: U2FsdGVkX19zSU4jrIpYL+qUiwVD9ZqCWTPZ06tw2X/4W2DTP8jbfD8Zdgz+XtYDstOaRfUiVAIjKDpeJVixbSG4NhpCixeNxHohh/ngJ7MlDZNVn1vCgORi4gEjkScTzfOxe2UFqz2cVIw/NR/FTt+BlFrDyIZhlP54okBcBivbGMyS0Yw3HpjRTgGNEBFeRdsOIKyzrLi68X/hYOAszcD9cXEUiZjTbluDjOt5c1esfIkx/XhtiQNopoVJQMijDyWg028pKDP4Blp0ZyBrfLccO7Rjl3ZH2GS6CjDs3/lrjIiFuzYHFtq7oymIymfvcm5pwe0uKk0JcDSJVuiADHOb9xQyfUPTsVZmgl9G7gNqbw18RyP1huKA917k0EmSXfKfGujQbIvEf8WjETmhJyvM4vhLNehcd8KciV0LBuYCUn2fsrQdVx/htlRz5zd0a0RL0YOuIPKTM2P17/wFAvxQcAlHxnKqeCSpQ6FRxjYFaAPo/2Tc9Z4pq6n4OenUEBMnQFx7If6ZZCqT3we1ln5wQXkwQcbM793Y2r5+wgs+rDKIgOp3TIXFvQO0PEJ3s37FHuU/ILJRb2qd1e72JmciZxIH0gA0Vl2rSq8DxntvvfgQgsbW3M6Gm5/pXz8ZNy3SOGMix66kLF4+PN6bhzXcg7sGingb8gpYlY2bA6vaoie9JQU1uMiGCUWgE37J0jhQuQ/9pSRUV9ZiR+fKgp3EDcKY+5t1/cJJ8ggglsZIkEwUpai8IkAfbULYAdS1ZXHQILXhypfXZ9cZbqrEwy6NTywigNmpDlI+Hc+JtkZ1YIvmUK98cBIZOTwHbPqw7Zqlemoj2tZp6+KhYsYdL983/Ob0GuOWEmae8kpESE4aMnaiLvOvfsHNLa0dAG8qG7PYPU5jClRLv6/BJr/r1yCAVEgKRelNLudUjzZHbofaV6OmqbNyyQ02NLPJXoAdoS9InMor76Eb5sHDaIx
 BFP+FBBG
 i0bIM0o/CxKn/PZ+BJJHywc+7dygZrcoIO/RdoI/c63Pl97dOqLW695ICmy0dkae7Dyr8E8/6UHRYEdIHArOlOlG2/WDT9vupagOFaMpa6PULclvS8uVAjVgh0r7ln+Raduc5Tqvr+FMPuEN8aHOyk93yVBi64MgZWlcz09+xjjNddeGJnzOWlSgSSNa0pDOOmlgE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12 2026, Mike Rapoport wrote:

> On Mon, May 11, 2026 at 06:35:54PM +0200, Pratyush Yadav wrote:
>> On Mon, May 11 2026, Mike Rapoport wrote:
>> 
>> > On Wed, Apr 29, 2026 at 03:39:05PM +0200, Pratyush Yadav wrote:
>> >> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>> >> 
>> >> A future commit will add more callbacks for the KHO radix tree. Add a
>> >> struct for collecting the callbacks.
>> >> 
>> >> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
>> >> ---
>> [...]
>> >> --- a/kernel/liveupdate/kexec_handover.c
>> >> +++ b/kernel/liveupdate/kexec_handover.c
>> >> @@ -266,16 +266,18 @@ void kho_radix_del_key(struct kho_radix_tree *tree, unsigned long key)
>> >>  }
>> >>  EXPORT_SYMBOL_GPL(kho_radix_del_key);
>> >>  
>> >> -static int kho_radix_walk_leaf(struct kho_radix_leaf *leaf,
>> >> -			       unsigned long key,
>> >> -			       kho_radix_tree_walk_callback_t cb)
>> >> +static int kho_radix_walk_leaf(struct kho_radix_leaf *leaf, unsigned long key,
>> >> +			       const struct kho_radix_walk_cb *cb)
>> >>  {
>> >>  	unsigned long *bitmap = (unsigned long *)leaf;
>> >>  	unsigned int i;
>> >>  	int err;
>> >>  
>> >> +	if (!cb->key)
>> >> +		return 0;
>> >> +
>> >>  	for_each_set_bit(i, bitmap, PAGE_SIZE * BITS_PER_BYTE) {
>> >> -		err = cb(key | i);
>> >> +		err = cb->key(key | i);
>> >
>> > key(key) reads weird :)
>> > Can't say I have a good name, maybe key_action()?
>> 
>> I thought the context of it being under a callback struct would make it
>> more obvious. I don't like key_action() much better TBH, but I don't
>> have a strong opinion. Perhaps Pasha can suggest a 3rd option and we
>> pick on randomly ;-)
>
> Another option I thought is to call them ->leaf() and ->node().

This one sounds nice. Will use it in v2.

-- 
Regards,
Pratyush Yadav

