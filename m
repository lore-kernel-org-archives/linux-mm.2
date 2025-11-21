Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90F2ECFC294
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 17:17:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE1226B002B; Fri, 21 Nov 2025 12:17:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB80F6B002C; Fri, 21 Nov 2025 12:17:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA7286B002D; Fri, 21 Nov 2025 12:17:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C86266B002B
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 12:17:23 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7C08813B75C
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 17:17:23 +0000 (UTC)
X-FDA: 84135270366.04.90C5DDC
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf20.hostedemail.com (Postfix) with ESMTP id E8C3F1C0013
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 17:17:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=seitYhqw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NDTooAUC;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=seitYhqw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NDTooAUC;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763745441; a=rsa-sha256;
	cv=none;
	b=GvMqYKosA2pRRflQPFJ6DIfaL1OpE+eI9tuWJ2SXt/sUIMexwTWHAWwT1kEXsBA9mdPU5d
	NDGO4dx9L8l6iPtxnn9FufZaB+VhVwlGRydLmu+25hNxrR5WkquJDas/DeanHGaZEuKDWk
	sxMCORqpUIEdQIGH5zHqYleDqs1wlJY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=seitYhqw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NDTooAUC;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=seitYhqw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NDTooAUC;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763745441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7LEGbaOecDDjvk1EwNEzfMhTtMaKrsVKdVICC5r8o2o=;
	b=F/qip3c4ghp8iJz+Oyffa7bNLMbUH+PsXUiB9F0NkidgMJcybsnGYtjtXTw12Y47Qcyb/M
	NtQcYSymV7JlRa66q7yZo7MUWhmZuoQhxNe67S1VYieCQxVM3Fdgc6/msaB8qkS8m+pwaz
	mNp8O9nkcAJT2ya1tnl8jGXkv3TM6Ww=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 16C04219B1;
	Fri, 21 Nov 2025 17:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763745439; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7LEGbaOecDDjvk1EwNEzfMhTtMaKrsVKdVICC5r8o2o=;
	b=seitYhqwZ+LZ3NLW7zzLFjSgiBCBUcJgahySg+YR3FBvkymm+BoQA+jnCB733pHnWNrzua
	JD+Ir4xIO+0vtzG/hZEL4XaiLLOTJ0iUnjmewW62FQusZ/debzsVBK/nf4yiYjdsI3ED0S
	i3IZ4TwCSEvjsBBb60Wb1h9NfnvFCvw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763745439;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7LEGbaOecDDjvk1EwNEzfMhTtMaKrsVKdVICC5r8o2o=;
	b=NDTooAUCnNZv3O9vs6OR7UL+JomfyBCx4pTJVEjHbWWNe57rQjcdrH+PHPnxRv94p0uYg3
	NScDYut6UHA9eECQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763745439; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7LEGbaOecDDjvk1EwNEzfMhTtMaKrsVKdVICC5r8o2o=;
	b=seitYhqwZ+LZ3NLW7zzLFjSgiBCBUcJgahySg+YR3FBvkymm+BoQA+jnCB733pHnWNrzua
	JD+Ir4xIO+0vtzG/hZEL4XaiLLOTJ0iUnjmewW62FQusZ/debzsVBK/nf4yiYjdsI3ED0S
	i3IZ4TwCSEvjsBBb60Wb1h9NfnvFCvw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763745439;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7LEGbaOecDDjvk1EwNEzfMhTtMaKrsVKdVICC5r8o2o=;
	b=NDTooAUCnNZv3O9vs6OR7UL+JomfyBCx4pTJVEjHbWWNe57rQjcdrH+PHPnxRv94p0uYg3
	NScDYut6UHA9eECQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9988A3EA61;
	Fri, 21 Nov 2025 17:17:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id f9HWJJ6eIGmKOgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 21 Nov 2025 17:17:18 +0000
Message-ID: <37833a93-749e-4024-96e6-c6628e9e3b2e@suse.cz>
Date: Fri, 21 Nov 2025 18:17:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/16] fs/proc/task_mmu: refactor pagemap_pmd_range()
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Peter Xu <peterx@redhat.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Arnd Bergmann <arnd@arndb.de>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
 SeongJae Park <sj@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Jann Horn <jannh@google.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Pedro Falcato <pfalcato@suse.de>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry.yoo@oracle.com>, Hugh Dickins <hughd@google.com>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-arch@vger.kernel.org, damon@lists.linux.dev
References: <cover.1762812360.git.lorenzo.stoakes@oracle.com>
 <f9ce7f3bb57e3627288225e23f2498cc5315f5ab.1762812360.git.lorenzo.stoakes@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <f9ce7f3bb57e3627288225e23f2498cc5315f5ab.1762812360.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E8C3F1C0013
X-Stat-Signature: 1tymq4tm3zqtwjqkdatoydfbe9r81p4k
X-HE-Tag: 1763745440-521362
X-HE-Meta: U2FsdGVkX183hiLpIc8fhyTsrRe8dQhP8t/i95+wuV2BdismEly10tofVzen0+fdtEG9P7PbzPo6vMu0cNFdsMfZHXpcmF/wjYiuDUuqrbmouP1VDmGTH/tLZc0WcktXV1klgaG8t2hSvTbyZ4CM+G4CtOxnzRwPC5wNm5ecc00YcDBb7mTnkdDg00TwkXYxnca6jbLyxI1g8PV2IQ0m3jobF9kxMk3SeaGp2yx+P8Rgv2Lje2tx/xeB+IfOKFphY+i6wVxtqZYbX+qKCcIowyWaNaQ8PS6uis+CJe6oMf8M+Dy5xuOGv/z64axsXni8PHprVhNyqyavN8WuC7JVMVeDHUIoQdm2js5nvwdizZxxTKjHeKAoHvBjlxreluCeU7UWA5q+8A6tzdfuxJu8QTY8+WCzRN5lzPfRkMZmIl5z7inG+yrUIrS8nNEH/KbbL88wiCrfbhQbNH1TH+rxti9SmABIHK7kX1X627W/yfrqbb34mWVgOlepoQfksuMoeN6qBLNyc/2a6YYxVlD1UFTVzRjNE3yn2Z3a9hcgfnN4UBZ9VCwKOZbJEhByWlORM1Laci8gPPU0geGwNdRFhjCskn1vviOINGV7JYtDCG7ItEESgHJYpAcXPZ2QqY+XGZErT4oanXJfbfixDmDTVwrtxkgAKQXqXzBDk8U+WeGvR3df4eLf7qPPqcrw4n6YWT19SIjG2hMx7F9BLRpR6/jo8/JJO35UOPSdNLd84p5/uMg+rfxh+YHxTww5/vYC6DKyEpLOtwX4xZ3QSyHwnhdsM70riqEABkE2pxeYw8pdQWBdKDK11Ug89SVFPqvp2fUz7Y6OUwjUHyW+m8kDNa9+g8OZJEYnaNy1yhE3QSRF7W1kMCGQoNj3/5KgBbQsBma8FDKCsk/v5uEVNW1jrsBDCGhh/f6ENLYh91KLLLCM16ZBa7qdc9qEwsGIkEwRnRLLPEJmK012eklIYJC
 mfGj6HIc
 yxIwJJ5Yk6a8PARWbfv+mPY3PSe2AdqWaVhxF82QwofE4ZUKwiTAbanjIRzezVYwvOYY+RvcGGFk2XHvsN+N6HZPKlPIWzHbboDpFrldK+ccRBzcplKzDY3bDZfG0WXG/J+XcMvYIoL7xBSMoljL6YSz3mbnSR4o1/jJNEmrMCw9XAIMO/za9TBE5vPe/hJglZm/8g62lXu4ucxdus4WBD0I3fuFW5Nv18DCmCYqFRDNFNfXaCnZaYjGrVNkejClT2VKz/Q+jRx3R62i15hF0Cgf0Uw9i3d8OeYfU0jZ7AFsCnKoQoKErsQvs0gos8O7ySv6Vp3oDav0o6Xy5iUgdGCGmgXSoEG6JuSR4KfBdEP9NdBY9Fw3Us8cFw1YHtwEnU2Z1J+xculhGz36RdV228NxRGzTaUJ19BEFFK8tqkoND2vU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/10/25 23:21, Lorenzo Stoakes wrote:
> Separate out THP logic so we can drop an indentation level and reduce the
> amount of noise in this function.
> 
> We add pagemap_pmd_range_thp() for this purpose.
> 
> While we're here, convert the VM_BUG_ON() to a VM_WARN_ON_ONCE() at the
> same time.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>


