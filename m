Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAD58EA812A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 15:10:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D1A26B0089; Tue, 10 Feb 2026 10:10:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49C016B0098; Tue, 10 Feb 2026 10:10:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 394C76B0099; Tue, 10 Feb 2026 10:10:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2B5956B0089
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 10:10:12 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D71B913B4EF
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 15:10:11 +0000 (UTC)
X-FDA: 84428882622.26.4C57948
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7CFCF40009
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 15:10:09 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FzKhpDen;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vonB70wL;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FzKhpDen;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vonB70wL;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770736209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2UHkOqQwjD7PPM/fhQZDO8c7lSC7w0EmY0aytb/bPRY=;
	b=j7W2lZe/r/Ic3FURcSikXqzvSx7i1kuQRleK4InEq3UnWEs2m4sUMxFug6dNNeo3aHaNPS
	3g9mj5fY7vOnBT6QS7VjyVH3STNMIzRCYr2RDLswZVnTPnjjVcYZ20ZGFknJkUUT9GnNEN
	/JTU2VqjaSIeYuhOEXkb2rvJZOTfK9I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770736209; a=rsa-sha256;
	cv=none;
	b=F6U0QnUDCzOaZK1uGi0dlfOXquFkig4y/Huxih9u4LQWSfpY8KZ2qXl5cDDMxBQ5gOUHNw
	jMEXCAttIEfLiJXvu0bczDbtWWkPN47HSdo0QAoquvKuWb1Snlm8FleDzss7ZCguQvuAMf
	H0PmNe89eqOu9aG5g+4F8GFaQ1KsQok=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FzKhpDen;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vonB70wL;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FzKhpDen;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vonB70wL;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0C5113E6FE;
	Tue, 10 Feb 2026 15:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770736208; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2UHkOqQwjD7PPM/fhQZDO8c7lSC7w0EmY0aytb/bPRY=;
	b=FzKhpDenlGYp4eihH7/g+3KJ1ATytDedkanO4kaeyJuBR6rVUm2iBP+6iZPVQ7bCu1zFT+
	Vz1Tjr9e9Fz5DMAQZVkO44WljuSt+be+I8bsF+SjEwimi49rGvkw401/aMia9hpFXmVpPA
	iMhRF70CYQZu8wPxx4M8MF8Q1sfe0hE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770736208;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2UHkOqQwjD7PPM/fhQZDO8c7lSC7w0EmY0aytb/bPRY=;
	b=vonB70wLfhLr26yqHPyH8yQaxYfS/DxAI36Xae8txXOyzk6aou4QhxzE4Z079QFPMLuDq6
	AvMM/BSIeSroQOBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770736208; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2UHkOqQwjD7PPM/fhQZDO8c7lSC7w0EmY0aytb/bPRY=;
	b=FzKhpDenlGYp4eihH7/g+3KJ1ATytDedkanO4kaeyJuBR6rVUm2iBP+6iZPVQ7bCu1zFT+
	Vz1Tjr9e9Fz5DMAQZVkO44WljuSt+be+I8bsF+SjEwimi49rGvkw401/aMia9hpFXmVpPA
	iMhRF70CYQZu8wPxx4M8MF8Q1sfe0hE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770736208;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2UHkOqQwjD7PPM/fhQZDO8c7lSC7w0EmY0aytb/bPRY=;
	b=vonB70wLfhLr26yqHPyH8yQaxYfS/DxAI36Xae8txXOyzk6aou4QhxzE4Z079QFPMLuDq6
	AvMM/BSIeSroQOBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B966D3EA62;
	Tue, 10 Feb 2026 15:10:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mHH8LE9Ki2n3EwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 10 Feb 2026 15:10:07 +0000
Message-ID: <a1c53239-aade-47e5-bbe2-cfcaa599be49@suse.cz>
Date: Tue, 10 Feb 2026 16:10:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv6 04/17] mm: Move set/clear_compound_head() next to
 compound_head()
Content-Language: en-US
To: Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@redhat.com>,
 Matthew Wilcox <willy@infradead.org>, Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
References: <20260202155634.650837-1-kas@kernel.org>
 <20260202155634.650837-5-kas@kernel.org>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20260202155634.650837-5-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 7CFCF40009
X-Stat-Signature: m8rcw9pn6npn81deg7boiz5srx5tbnc7
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770736209-403345
X-HE-Meta: U2FsdGVkX1+Ug22lNAHfuxU+5lA8ME01Poyt+v3QUX1iNU7bPvhXMGkR6iOhVRub+S1AeCUfpy+Ro1QC7Pm+dajo5fGsFHRtJQnlZUJ2use2gNRIU/iUjxq83qXZQFbKGCxUWHT5eQRk7KJIO5KxY2U+VYqv3H6bIhY3fB81tFerY2AdDA7aHHjlgqux1Pe6COQuh6Jm5OuqRjyUCgNAwzf/lQl5WWe+PXpB6dk9d93Jtodvcgts+7fdEOjMV8OUkGnzSnQYLSpNhwD7SxOAQi6OLl/J6pxPF3njisVZV7V1BiIFAcIoLhYPS1LEMbdAiFdknNSOGTj0SYiHBSsQ/NB6QEih6mt2/ApPv8krSKRvaCRs7ANkfifCWxE3SAygN8j0wddlfWJMh38JkyzJdaDsDYmBYrjJJtsGpExwci+YqZOmM02a6lmlgTLs7rR96dmiPBsl3Je73uT1wEwDB1ysqY7PY29t6ylVcYD6WLcS0Q4c01LC9sEH+1/1coRop0JVG1RtOCQduishI9s+uEv3WynjYlRYWWqqDrNPw4nMJFpaJo1IuG2NCZV3c8sTuY3ZyvwMU4FrS4/uYfz9N3xVde9LqLG/cVc0dPSfGXw1Ru7mQN+SGwDNXWSRePu0uiARXZowvnB230uggqIyQVsYGDKnWl63zWRE93R1QWIIMUdbP77QQjFQBBxLLCHHDLlikncH0NAqHJLIMDA94mILAV/Z1KqSjyXcoO1dnjwjy0gSdHR878XKpnxOUL/+ZXtsYv4A8vowg2+2y4A7866wsDiq/B2gHyNwaZiio9Ta9f5yK+w3UIwIRSZh3lIDwOV3wWgCj0ieKejVR/l8H3bfKN2v8djr42z9K2w0Hs4jKqN+jQ5mFHax586zQIXS6LvxjEabiW8Ov+EiTGNwEcF+SE08H/uZ6J6r0F4NoX6AmaM63VWiWEGkPPxy6KdpRIC9vvgf3kexW56bSmN
 kM0mPiks
 FPRH9zxo7i7zLk/w4tyG/AwK+ui1pNJszkbKaZY/OzO+VTEEXC5wHkuOGt5Oi2fd2lox2eSLXo5k/Y2xxc4MINr2u4KpP4NbZvkCusvXXzmCSwwfuaWSK6kS9ax/CLXY0oLGz4B28vkMAH+cBGKrM5MYF2VUCMQVIYluCu7ca5Kg2dHSaRUD3yABB1JyG+ceVkkZDFn6oRqSVtU01xmRjlmpcOvFnjKGwXrufKbPVB79kLwZfGkj4/joEH+zTqPQM5bBNsJN6SfYhSUaiZwGxTx0GomX+z/CG+vrpApRyAL5mgBnb5gPtNBZVj2BNgNWRuMKnnRtQZpw8zXZnjBc/KRA4qKL+nhIe5bCguX3yZpBUxStJo6TbgKFaHH7gA/Mj4QfGuAfruSUzYyWE0ga7WWtjww==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/2/26 16:56, Kiryl Shutsemau wrote:
> Move set_compound_head() and clear_compound_head() to be adjacent to the
> compound_head() function in page-flags.h.
> 
> These functions encode and decode the same compound_info field, so
> keeping them together makes it easier to verify their logic is
> consistent, especially when the encoding changes.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Reviewed-by: Muchun Song <muchun.song@linux.dev>
> Reviewed-by: Zi Yan <ziy@nvidia.com>

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>



