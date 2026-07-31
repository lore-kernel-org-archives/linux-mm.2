Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05771C5516D
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 13:52:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00A376B008C; Fri, 31 Jul 2026 09:52:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFD116B0092; Fri, 31 Jul 2026 09:52:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEB786B0095; Fri, 31 Jul 2026 09:52:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A9FBB6B008C
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 09:52:51 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3D7BDA1797
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 13:52:51 +0000 (UTC)
X-FDA: 85049212542.08.703B824
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8DFA01C000E
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 13:52:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D0y+qJ3D;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785505969;
	b=sfKcFOovGwVSRAtRG3L3TfIwMpLA+/v4ktuIvpBiVhUzU6hoSU6Rkk4Y1iD5I0ldFky2oc
	8TbUQSFI7Dx2XVYoWiIoh6aMVG0F0x6bBJEZIbV2l3SombW8+j9I/ey4I57a2I+dScQJb0
	yRD8/CRiQo31khxMGfGvi5BfnIhxeoo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D0y+qJ3D;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785505969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cDEHYu+1/dZP45QPh68o+tAnVQBCZEowl8E2/iwoQoc=;
	b=NHpMUqGvDteQUSjg+c+2IzOJvNODgUw+fnlDKXu2TK3+IdyVONo93VtEFTBELA2S4kbDi/
	SCbd3aqayu37NBRmogx/NPOXL12flIuLZHRIi+Wj/bYaZ7GZT5ubzP4kdn08eXDYibNSdG
	pwjQN4AN1wvqE2On+9vy7sTNBdaOgKA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E8C8A6004E;
	Fri, 31 Jul 2026 13:52:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 304431F000E9;
	Fri, 31 Jul 2026 13:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785505968;
	bh=cDEHYu+1/dZP45QPh68o+tAnVQBCZEowl8E2/iwoQoc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=D0y+qJ3DABboRQb60kuGNjDtOgqw38ZaBeCzQ9tZVgoXDBxDijdVnq49T9BPLVnWc
	 qPNgJCPgkUkC6HgEvUw/cqle+HO5Wqj0umQtyWK2KcI8MU4ICo7VtlvHNUSNfsDTqX
	 wEiy43u8bFodHNHkdAupn6lRtCs5sp6L2XLFHfOURqEIiFwwcCswMMFj5oY+P1jxvi
	 UT0YcZRzTkhGAu01Ghdh/Kbouw+1FmUT/sZSl8tH51oHtIpL1YvmqZWyxxfCvLv7ze
	 zBdPv9SLGfn/1Zgcrm1NiCLLkY3kFuTvNNSZ/l0Rdd+XcsXUgBaFg+3TJ59EgEbXC1
	 uoRQMBmjjHE9A==
Message-ID: <4b87664a-9ec6-4499-bc35-8c6f022f0881@kernel.org>
Date: Fri, 31 Jul 2026 15:52:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/13] mm/slab: change struct slabobj_ext to a union
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
 <20260727-b4-objext_split-v3-8-c29ef0f1f257@kernel.org>
 <ams72G2rTkobk5Qk@fedora>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <ams72G2rTkobk5Qk@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: kk43yh6rojtdupr7qt5ebqmh37j915s3
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8DFA01C000E
X-Rspam-User: 
X-HE-Tag: 1785505969-645534
X-HE-Meta: U2FsdGVkX180nM7ktnsu1p0YAzlUWFrbIIeXYZ1OYZAb+oNw4BJEtZyiD80E0vWJGI8K1aUslff5Dsl4Lg2GBXRJDhZbGIL6WLO8LEeQa+5WgO5GXmw+LBcIxNE7m4agxh/1UJbbfwnTTCj+/gTdykOELC/n+nAJjQqHXLRIQ3mDaCW0RJs873ARXKlmRKkJKNtkiW6NO7bpbt1nqAU8z6Csnr2+ZAbMQQMRSct881jux3ZQHV4ahomoLPvkvag2qc3BhS8VJaz7dCYqjPCA1p3/t/GThhBInn/JHe6EsjUxMr1D3Rum/tb9SaQgnkwiBLJAQeUxz7zmReFAMwz1j7/c73y2zSuRyB0tmQrNiKxA9FvGtSpzxKfi8ZaJxmiBgr6/yLC6xE5pGNTABhI+lXPHmoxz3zeELkcvva4rZ2SuH81m4d0qoU9Bi3eJlFybWz0xpxpnfNPf7TRDtqAvZRmFAdndC/VLySIMz9v4yRm/0ieEotxjLUKZPUnjPJZWVeSWXRZXh+MA++U8nabo9tbFVs5Idu9nO6Yd5QU9WCoVD9e+pD0fFXvR3JEahGQTOWAUpFzVob3n9Q79mDWd+agXEdWBlMfuM+hawy7DWIHYkc+U/6BzfZHfQS/iChhgsTNCT7yFUxwVYRme43y8+9NUFF+/Z7P2c+t7pyPlvB6yTHQTnGCFYyRVuw/CsUJCQEL8X71yw97gUCPUYvJsBOcXzQJLiJxTjXucRdQH8C/O+muYyQjhi/XhxHIszTxerOorRSWfHCgK3ACE4cJn7CE7lr4KoY0e4lNUiq5oTy/4Gak+beFkiOqVB5Fok8meieNF7YswKRCoAlGBL5TJAa6ZH3BZuBLiwHwMiFQrFctjSX869Tw2dFF+LBqc/Sf5HNOey2FpjFBleltGqxhGb823oXEDuoLBUSLcsPvZVl91GbNJng6VtB3BvTM0KGpDmwKwrfR6j4Cgo05p9YZ
 qC3NM1fk
 zmRswTRV06SF9dTwNJMwcVRfbC9SiiECTeJKFnQq//W2WJdzn8Ek0m3++11sta1pHVqAxrsAWZVZamc/4ccEpFcW2WBHLXp+HWZC/gxzK8EWnuzqyoYMYNelhgR+e4rQVUy/OBEcBNNM/udyoERk0UVxG7igkFjSnsYgdVcS9sWsep6/oI7qNkYJDX+vt8GuAm/fEGQanClKX+AHNUEO6mKg6CPRm3eGSmyDdbk+dip1VsGjsnuWXC8HnSjzXj1VytnnYd0YZ0xC/BepM3D3vNS66h312kLS3umbpCXhEkfawon8O2u+zrnkWCWLNLzCp6OOFFS0h3CpJD2o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/30/26 13:58, Hao Li wrote:
> On Mon, Jul 27, 2026 at 02:54:02PM +0200, Vlastimil Babka (SUSE) wrote:
>> @@ -7933,7 +7936,7 @@ static int calculate_sizes(struct kmem_cache_args *args, struct kmem_cache *s)
>>  	aligned_size = ALIGN(size, s->align);
>>  #if defined(CONFIG_SLAB_OBJ_EXT) && defined(CONFIG_64BIT)
>>  	if (slab_args_unmergeable(args, s->flags) &&
>> -			(aligned_size - size >= sizeof(struct slabobj_ext)))
>> +			(aligned_size - size >= cache_obj_ext_size(s)))
> 
> Nit: cache_obj_ext_size() could return 0, and the checking will always be true.
> But I think this is harmless.

Yeah should be harmless as then no objexts are used for the cache anyway.
Thanks!

>>  		s->flags |= SLAB_OBJ_EXT_IN_OBJ;
>>  #endif
>>  	size = aligned_size;
>> 
>> -- 
>> 2.55.0
>> 
> 


