Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B37B4E7BD95
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 11:20:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5C9C6B0005; Mon, 16 Feb 2026 06:20:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0A8B6B0088; Mon, 16 Feb 2026 06:20:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADE7B6B0089; Mon, 16 Feb 2026 06:20:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 986A46B0005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 06:20:11 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 184E41A0D89
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 11:20:11 +0000 (UTC)
X-FDA: 84450075822.30.5C4B183
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf07.hostedemail.com (Postfix) with ESMTP id B293340005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 11:20:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1h2bkYjg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Wh+Z0PPm;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1h2bkYjg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Wh+Z0PPm;
	spf=pass (imf07.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771240809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PkBeeZVr8B29Z/3z8eE/N0ouHBNVef5cV12hX5biciA=;
	b=6zHsAeT7a2xWmskC9noR30yDlV4qwvzRrzdCe4sZWb94gqeSQFFbJAnHuT8NQfX+OxtKxA
	PeP1XKlGETsWELTSbslFIuyZoqrBH2J4wTqjV9V+rz3GK9s+2J80i6oo5JM11SuQpHrkjb
	4r9GUa5DyirAqMCFzh/T3Ik31vRjmlM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1h2bkYjg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Wh+Z0PPm;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1h2bkYjg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Wh+Z0PPm;
	spf=pass (imf07.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771240809; a=rsa-sha256;
	cv=none;
	b=SfOpCuBdlCZD5OQaZCkmLcQpViHLJURgTgIpWFuFuyq4QHccHztU8I8pxPYWpfQCER+1Eq
	eDJNlKijcIFMYz0xp3mGLDO3T6XW2xXQ5Kvyf4SWr7x1PSnWb0Gi12dz9OXRqQjtOrr9SV
	uPRAyiBPHVmB3DAswf5e0/xyyLsuisY=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0EF343E6D7;
	Mon, 16 Feb 2026 11:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1771240807; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=PkBeeZVr8B29Z/3z8eE/N0ouHBNVef5cV12hX5biciA=;
	b=1h2bkYjgZEmnbCrgsRupqQRL98BilkGpRMnV5wPXrt/v/a82Tb9wwCynD91kBzalpn96LT
	Z1KrYRTpzNo84mt8Hsmnz9LtMc0Yk/gFmJKdvozpFwkODJIH7y58W3d4+uYvzrE9ZwZUHl
	KzxVYOEv43HwZV0UF2tr5LzU87U5PgY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1771240807;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=PkBeeZVr8B29Z/3z8eE/N0ouHBNVef5cV12hX5biciA=;
	b=Wh+Z0PPmdugjtjUNhnfSOFAC3CEvCAdAen3J6baKl5jqFKpV46OTsM489HD1MbFADRsqJ+
	lvpajPoNGiiDfnBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1771240807; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=PkBeeZVr8B29Z/3z8eE/N0ouHBNVef5cV12hX5biciA=;
	b=1h2bkYjgZEmnbCrgsRupqQRL98BilkGpRMnV5wPXrt/v/a82Tb9wwCynD91kBzalpn96LT
	Z1KrYRTpzNo84mt8Hsmnz9LtMc0Yk/gFmJKdvozpFwkODJIH7y58W3d4+uYvzrE9ZwZUHl
	KzxVYOEv43HwZV0UF2tr5LzU87U5PgY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1771240807;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=PkBeeZVr8B29Z/3z8eE/N0ouHBNVef5cV12hX5biciA=;
	b=Wh+Z0PPmdugjtjUNhnfSOFAC3CEvCAdAen3J6baKl5jqFKpV46OTsM489HD1MbFADRsqJ+
	lvpajPoNGiiDfnBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8A0ED3EA62;
	Mon, 16 Feb 2026 11:20:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6UJ7HGb9kmnSbAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 16 Feb 2026 11:20:06 +0000
Message-ID: <ac1d589c-a02f-421e-a432-9d65f3e2ce99@suse.cz>
Date: Mon, 16 Feb 2026 12:20:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv6 08/17] mm: Make page_zonenum() use head page
Content-Language: en-US
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
References: <20260202155634.650837-1-kas@kernel.org>
 <20260202155634.650837-9-kas@kernel.org>
 <aZJTLwV2SaaKu1k_@casper.infradead.org>
 <ec4a9a1e-8c08-4879-a787-3b9e0bc38160@kernel.org>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <ec4a9a1e-8c08-4879-a787-3b9e0bc38160@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B293340005
X-Stat-Signature: jezzj1bebf8j1o1yft8xm4gk6bnd473i
X-Rspam-User: 
X-HE-Tag: 1771240808-423
X-HE-Meta: U2FsdGVkX1+iKHVshg31SfA7AtlMahCxat39V+Ldwi6fX18KSS4NZn5XDGE+jAKFGEyFfbrCQnfqD5nErBRqe8KwWtD/PWwhi3KWWhQ5olxTh0nZSb0XllOnC+O7nJaIs5VGTAdvL3yfkrXfw36mZgaen8QQvnVtehPdDCIs7Md6gQdt89iR68x/HLoqVMq5MCJLaMpfygxDY4RwZh/UPlJWJAf8ldy5f5wCvTOq9G8vub9CaPG2H1JJ5fTuGrM8z01ITSykvOXFU0rPgJIeSKCkoiYc3YwyBOmz2yNZjwgaIKMj0fZYa0eJfC35T3c+rnGhXniZCUJa/Vm44mNXj0jJV3H1Qc8Bp41MwzXpSw+6Id+PG9/2e6WA2Sx9kxwFjeTVDZyiifbWuz7nB2H+8KvMpJDe+I0A/mRwETeW00xvPm+qsV8znIU7DLPXaE0CDPXC+WnEbDvjhT1uINQ5iuEobQ92ZYm1MkDHnJ3T7rjE0HhYBD7sorbVP4q45mWLu7O42soLRJc6z/+Yn3eK/tnvUUCxUhjcPXGRt9OmL89QHqoFRMdFIl5Sk8b3Xu58FFXaaIzPsUhwjTZxcJawiMAyDuImrMOgvsjM+AAcSYNIOt8VEsNfWmiCbzEoy7qFT1i531+obj5oKcISgjej63LZrF/CorbtAvcvjOgWxJbGtF9UYk/ahHNTgsS/DHhzPsI38KIC7tGHulQOcS0/QeXrl63nykvS0TP2lbNAIYx5rz5HCSN3udsStJN2Hd1qcznWKgco96iZwFtHWssYDjn2klajDbnP0ZvbMnm1ojsNJfCpO6AJ/Q0X5aFmGc/YYkEpa2gchaR9QzADE/jGOikHdobepwP7fbZWyARgJp20r2vquK2Fp0bzQ9diSsw8KXLXyz70Xl+pu6yapGZL9Ia10lKt/cis8H9NnHIij+QEN+HCKVDBBUPgpKcKNw7OcSmxUtOMI1638lABHoN
 c0MnDuBd
 K0GZzR7mTcP/XUYRt3r5vU54aUJdOqWTFR9eo0Caklz/ouNh/9GAv1aMnJg2WQ7tRE6Hd5fKwGGzyIVxixDgR+Yuq2tnxkgGppxsQkDI8VObvhdMlxRYJd+aonlM23hS2vVGXQO+iezXgBA/A8vgqKZcmUhKIHGOOJe6PtpitQfarhACeh+qr5gf00S08or7clHDAI1t/A24II9k1OhKk5bkapPsKX6KKwR+8y6uduQ2I5SR85fcC+elKN4TUh1EwsaGa8GluIXhpaFBBv3iDJ8xQ6++hNiBA1uSyNsiOBBOX2Mks/5vY+q3dsxcSDk0uIUkgC1FS3iVN9T4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/16/26 10:06, David Hildenbrand (Arm) wrote:
> On 2/16/26 00:13, Matthew Wilcox wrote:
>> On Mon, Feb 02, 2026 at 03:56:24PM +0000, Kiryl Shutsemau wrote:
>>> With the upcoming changes to HVO, a single page of tail struct pages
>>> will be shared across all huge pages of the same order on a node. Since
>>> huge pages on the same node may belong to different zones, the zone
>>> information stored in shared tail page flags would be incorrect.
>>>
>>> Always fetch zone information from the head page, which has unique and
>>> correct zone flags for each compound page.
>> 
>> You're right that different pages in the same folio can have different
>> zone number.  But does it matter ... or to put it another way, why is
>> returning the zone number of the head page the correct way to resolve
>> this?
> 
> How can a folio cross zones?
> 
> Runtime allocated hugetlb folios from the CMA/buddy (alloc_contig_range) 
> definitely fall into a single zone.
> 
> So is it about ones allocated early during boot, where, by chance, we 
> manage to cross ZONE_NORMAL + ZONE_MOVABLE etc?
> 
> I thought that it's also not allowed there, and I wonder whether we 
> should disallow it if it's possible.

I would be surprised if things didn't break horribly if we allowed crossing
zones in a single folio. I'd rather not allow it.

(And I still don't like how this patch solves the issue)

>> 
>> Arguably, the caller is asking for the zone number of _this page_, and
>> does not care about the zone number of the head page.  It would be good
>> to have a short discussion of this in the commit message (but probably
>> not worth putting this in a comment).
> 
> Agreed, in particular, if there would be a functional change. So far I 
> assumed there would be no such change.
> 
> Things like shrink_zone_span() really need to know the zone of that 
> page, not the one of the head; unless both fall into the same zone.
> 


