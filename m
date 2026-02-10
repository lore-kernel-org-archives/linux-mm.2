Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CE31EA3F22
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 16:18:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C7816B0005; Tue, 10 Feb 2026 11:18:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 475766B0089; Tue, 10 Feb 2026 11:18:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32CC26B008A; Tue, 10 Feb 2026 11:18:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2073D6B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 11:18:50 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CDBF813B587
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 16:18:49 +0000 (UTC)
X-FDA: 84429055578.20.E33ECC6
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5730A140016
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 16:18:47 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=J6tIx6D9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8aX6TdNe;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=J6tIx6D9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8aX6TdNe;
	spf=pass (imf23.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770740327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AWAHMKXyBrxfBf69pBcoJZiRyKZIcjQ3u+E8dpyzTIw=;
	b=5c7Ox0NAiAYhiC6TxQMrPt6zK498wKswFUmeUXmYZhYwTn2YLeVwLPctvEXN12OGRBbnDH
	7lFFlyfLqZjuEEUpExgZeCoVgMWBp1AID6fKpIV8s0YvFimg4EVZTSKbBwrl6VwD1anKdT
	EO/RhtxfHx3u0jQ/tw1VkXD1GvTc/rQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=J6tIx6D9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8aX6TdNe;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=J6tIx6D9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8aX6TdNe;
	spf=pass (imf23.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770740327; a=rsa-sha256;
	cv=none;
	b=Sq+cF1NDi7Xg9+dxiJ3IwYzZ6fzjBIWI8VIgmF+WtrXHu08FwRIkAoIe3I6uzWbl8S5kmo
	qCEjMEBJG+au8AmxfryagDDSBwzQVkgzq0Ibx39sGiKJu8ZZL+uPbglmKUMIGZBo2OhKG1
	dLS7wGnn9E1t3l1Q9lQTzbjuy/FpGVs=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 72BB55BD70;
	Tue, 10 Feb 2026 16:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770740325; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=AWAHMKXyBrxfBf69pBcoJZiRyKZIcjQ3u+E8dpyzTIw=;
	b=J6tIx6D95KB80m9fGTh2TvNmjCHG5fxuWYA++kYdpTF5CUPzEPE6Y27ROec8++ZKiXC8jc
	BTW7YpEmAOjK4wIlGKE65+gpazYd22/8sW2kEXc0qzTZppdYi9rb9ZwHxwmnpZGT4bcWnZ
	EetyOrJ4f3DWGqJuoYCozdnZpH4eVHM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770740325;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=AWAHMKXyBrxfBf69pBcoJZiRyKZIcjQ3u+E8dpyzTIw=;
	b=8aX6TdNeeQQlCcrkh2WiCDuyS2sI6CHZ6ha1b8LqZjvmgmakt1EWA0RCl51+boIW2xcNir
	s1WXULnmB7OOI7CQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770740325; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=AWAHMKXyBrxfBf69pBcoJZiRyKZIcjQ3u+E8dpyzTIw=;
	b=J6tIx6D95KB80m9fGTh2TvNmjCHG5fxuWYA++kYdpTF5CUPzEPE6Y27ROec8++ZKiXC8jc
	BTW7YpEmAOjK4wIlGKE65+gpazYd22/8sW2kEXc0qzTZppdYi9rb9ZwHxwmnpZGT4bcWnZ
	EetyOrJ4f3DWGqJuoYCozdnZpH4eVHM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770740325;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=AWAHMKXyBrxfBf69pBcoJZiRyKZIcjQ3u+E8dpyzTIw=;
	b=8aX6TdNeeQQlCcrkh2WiCDuyS2sI6CHZ6ha1b8LqZjvmgmakt1EWA0RCl51+boIW2xcNir
	s1WXULnmB7OOI7CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2D77F3EA62;
	Tue, 10 Feb 2026 16:18:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0ryiCWVai2lJYgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 10 Feb 2026 16:18:45 +0000
Message-ID: <f80f6ea8-2988-461b-ad6d-c1b23408c45f@suse.cz>
Date: Tue, 10 Feb 2026 17:18:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv6 12/17] mm: Drop fake head checks
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
 <20260202155634.650837-13-kas@kernel.org>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20260202155634.650837-13-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5730A140016
X-Stat-Signature: z6sm76jawh8cuixdj18yijaimbptk164
X-Rspam-User: 
X-HE-Tag: 1770740327-848136
X-HE-Meta: U2FsdGVkX19CGTemCvB/wddosiUW1jG1pH21pa54pkSL4XrT/zOt0XiVB2dOMtOd5Y0qu5o6bF/3909ZhGVv8TQaPYPRnf8hBhMLIodqPH/Uz1i+UF2bLvtjr2RZxF6L513QmzPHq3zOlWUB9Hojk+pQTRP8xEaxgiQC83FrOM4uETgsCsVa60HpPbN3sw/Xh56Js39Yz06JvvLdXJUk9c4XVrwkaQ1ax+eevg6BvZx84XvOnCjMttyMwkybr0z7BMXPk5kFkqCrmHDk7gt867db87Zu3+P5b+m7j6MrDX1j/NmfONasZG9E+70tsGGPvFMUs89HFWmyxYpx3+VFNVafGRhGmSnj7NMxClwmXFl50tjchZYP+9TfTdznIuJCdwV3dDNNL58+5497vA0V2ZgHgnjdZoRZMBVyYt6HRtNDox+i3xm5saMpBmDiwhbN3XphGp8pzd4X1UxlhiYW3WP0k7tGVjU8fWQgMDUF5ZDhTRjuUbOE8yny/HL8eiN02K5QIh5mJ/zkVzy+07wyAUni05/jWFPRDX96CN79nY06NkVhL9w/LGKBjIRoHPJhxl0ARt3ls6AwbgeOAnzfhn8C9mH28X3IFjOBjr/l6vXXQRjMnUFr5bikXxuX9jgsR2Hnkc914udoqxPu5x4AhSBw+TTyYgQP90vchd2WfLRwMITE6dIJUpQVrkdWwC8SjeQ1SNVUeRPAlBUZrOHtx6LQYC5ME2l/8RV+fA7nqgQEgyfMuBVO3wo58ALqjpoz45CzH9fsdK9YCpaiPieViWvq4S03XjddvB6wMFrgKKI3LsgGw841D1oUK7HFwduRslDnchRW73rva5iK/8ld2cDjSQnYt0k+r6Ouw/8FvVZ8QYuEtdRhWhCtse9+Xh4uV9UIUNe8iDhbON+GoJuXamEUhS8YR5W0bdiTH+ulScC9ZEsf2GfGpQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/2/26 16:56, Kiryl Shutsemau wrote:
> With fake head pages eliminated in the previous commit, remove the
> supporting infrastructure:
> 
>   - page_fixed_fake_head(): no longer needed to detect fake heads;
>   - page_is_fake_head(): no longer needed;
>   - page_count_writable(): no longer needed for RCU protection;
>   - RCU read_lock in page_ref_add_unless(): no longer needed;
> 
> This substantially simplifies compound_head() and page_ref_add_unless(),
> removing both branches and RCU overhead from these hot paths.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Reviewed-by: Muchun Song <muchun.song@linux.dev>

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>


