Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6940CFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 17:42:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20C2C6B009B; Thu, 27 Nov 2025 12:42:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BC056B009E; Thu, 27 Nov 2025 12:42:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05CF36B009F; Thu, 27 Nov 2025 12:42:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E37736B009B
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 12:42:54 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8401BC021C
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 17:42:54 +0000 (UTC)
X-FDA: 84157107468.27.9DF06C4
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf26.hostedemail.com (Postfix) with ESMTP id 02CE6140014
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 17:42:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NqTrWm4L;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=b8h0WCmq;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wBz3TfhX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YKB50LPx;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764265372; a=rsa-sha256;
	cv=none;
	b=KRCeSs26WPdtgXlgSlKcljyNuIAHH7gO+FAkvR5hYaMsb7WqtYRSk5goBFv31VDiITDDuK
	3DAtTnd1lxBk3h92e0ZettktLS2dGYXYpoY81GYsMp/Ro1mxl2A1KIqVLB6NdSoMHzQDvK
	W1OlnBFPt+4V1jsyZQgrvlRoyDBeI6A=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NqTrWm4L;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=b8h0WCmq;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wBz3TfhX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YKB50LPx;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764265372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9YPutSFBijd0TO+2myFDGHGTV+YBxplLk7KH2guw+X8=;
	b=6PZCr9bLo92Y+4Xbobk6Wh3ytGlWD/EJe6UTmL02jwdPjw+nJD9ok4attILq54eb/FDgBg
	1GKHqiNhOMwdqfT0ep4JuS3dpVG5Xjqyz4+g879jlbtojYncJE+JrcLhdOQu1AbzP2k2Ma
	cre65sTfMJYn0H171P3hthS4YT3Bxew=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C322F33682;
	Thu, 27 Nov 2025 17:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764265370; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9YPutSFBijd0TO+2myFDGHGTV+YBxplLk7KH2guw+X8=;
	b=NqTrWm4LPG82baIsiUU5h1rpOw/EQqTvqdaomRhu/Lu72m3bF1YbQuVbv2QfchS6BZ8rkj
	ejYaacKovTGSlS0GhHGNdjYBm0of21LLnYGE/9dSeI4qhyd8RxcsUrlO64oPnMRcvs0MeY
	ktN66oa32YJoOAZwL3nEeg87rjczL1o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764265370;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9YPutSFBijd0TO+2myFDGHGTV+YBxplLk7KH2guw+X8=;
	b=b8h0WCmqCBP/W2/bFz5URs8L0m3l0saXoNg/KF5ZL314kRwVbsSNRXQ1BI2i/qtz0RYDu4
	qh/W+3EHyMziwhAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764265368; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9YPutSFBijd0TO+2myFDGHGTV+YBxplLk7KH2guw+X8=;
	b=wBz3TfhXBGCJ3iemO49SaJOqPrYVQ8NAQL/dggm2WpCjOTwcxbYkHv+HP5GK4T21jFS9gL
	t0pDztPcZWqDfGhhkCoItBCD554Yf+0lUhr0zLKU4zYNZqUXjF+r0NRk7l0Hbicusa+EKJ
	MC0XtirDjVUpZsOY0VV1K3LvAFXg1gU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764265368;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9YPutSFBijd0TO+2myFDGHGTV+YBxplLk7KH2guw+X8=;
	b=YKB50LPxcmgnmWX/LLi8j1/+oHX69WJry0vY/t0g3AIHMSZIXA4UKp5x6het/C3wATQKwK
	0unXZGsA0HxALnBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 564CD3EA63;
	Thu, 27 Nov 2025 17:42:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8+wyFJiNKGkUSwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 27 Nov 2025 17:42:48 +0000
Message-ID: <2a1c9796-c55a-4a4d-99d2-3095fdec6ec0@suse.cz>
Date: Thu, 27 Nov 2025 18:42:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 15/16] mm: eliminate further swapops predicates
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
 <956bc9c031604811c0070d2f4bf2f1373f230213.1762812360.git.lorenzo.stoakes@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 xsFNBFZdmxYBEADsw/SiUSjB0dM+vSh95UkgcHjzEVBlby/Fg+g42O7LAEkCYXi/vvq31JTB
 KxRWDHX0R2tgpFDXHnzZcQywawu8eSq0LxzxFNYMvtB7sV1pxYwej2qx9B75qW2plBs+7+YB
 87tMFA+u+L4Z5xAzIimfLD5EKC56kJ1CsXlM8S/LHcmdD9Ctkn3trYDNnat0eoAcfPIP2OZ+
 9oe9IF/R28zmh0ifLXyJQQz5ofdj4bPf8ecEW0rhcqHfTD8k4yK0xxt3xW+6Exqp9n9bydiy
 tcSAw/TahjW6yrA+6JhSBv1v2tIm+itQc073zjSX8OFL51qQVzRFr7H2UQG33lw2QrvHRXqD
 Ot7ViKam7v0Ho9wEWiQOOZlHItOOXFphWb2yq3nzrKe45oWoSgkxKb97MVsQ+q2SYjJRBBH4
 8qKhphADYxkIP6yut/eaj9ImvRUZZRi0DTc8xfnvHGTjKbJzC2xpFcY0DQbZzuwsIZ8OPJCc
 LM4S7mT25NE5kUTG/TKQCk922vRdGVMoLA7dIQrgXnRXtyT61sg8PG4wcfOnuWf8577aXP1x
 6mzw3/jh3F+oSBHb/GcLC7mvWreJifUL2gEdssGfXhGWBo6zLS3qhgtwjay0Jl+kza1lo+Cv
 BB2T79D4WGdDuVa4eOrQ02TxqGN7G0Biz5ZLRSFzQSQwLn8fbwARAQABzSBWbGFzdGltaWwg
 QmFia2EgPHZiYWJrYUBzdXNlLmN6PsLBlAQTAQoAPgIbAwULCQgHAwUVCgkICwUWAgMBAAIe
 AQIXgBYhBKlA1DSZLC6OmRA9UCJPp+fMgqZkBQJnyBr8BQka0IFQAAoJECJPp+fMgqZkqmMQ
 AIbGN95ptUMUvo6aAdhxaOCHXp1DfIBuIOK/zpx8ylY4pOwu3GRe4dQ8u4XS9gaZ96Gj4bC+
 jwWcSmn+TjtKW3rH1dRKopvC07tSJIGGVyw7ieV/5cbFffA8NL0ILowzVg8w1ipnz1VTkWDr
 2zcfslxJsJ6vhXw5/npcY0ldeC1E8f6UUoa4eyoskd70vO0wOAoGd02ZkJoox3F5ODM0kjHu
 Y97VLOa3GG66lh+ZEelVZEujHfKceCw9G3PMvEzyLFbXvSOigZQMdKzQ8D/OChwqig8wFBmV
 QCPS4yDdmZP3oeDHRjJ9jvMUKoYODiNKsl2F+xXwyRM2qoKRqFlhCn4usVd1+wmv9iLV8nPs
 2Db1ZIa49fJet3Sk3PN4bV1rAPuWvtbuTBN39Q/6MgkLTYHb84HyFKw14Rqe5YorrBLbF3rl
 M51Dpf6Egu1yTJDHCTEwePWug4XI11FT8lK0LNnHNpbhTCYRjX73iWOnFraJNcURld1jL1nV
 r/LRD+/e2gNtSTPK0Qkon6HcOBZnxRoqtazTU6YQRmGlT0v+rukj/cn5sToYibWLn+RoV1CE
 Qj6tApOiHBkpEsCzHGu+iDQ1WT0Idtdynst738f/uCeCMkdRu4WMZjteQaqvARFwCy3P/jpK
 uvzMtves5HvZw33ZwOtMCgbpce00DaET4y/UzsBNBFsZNTUBCACfQfpSsWJZyi+SHoRdVyX5
 J6rI7okc4+b571a7RXD5UhS9dlVRVVAtrU9ANSLqPTQKGVxHrqD39XSw8hxK61pw8p90pg4G
 /N3iuWEvyt+t0SxDDkClnGsDyRhlUyEWYFEoBrrCizbmahOUwqkJbNMfzj5Y7n7OIJOxNRkB
 IBOjPdF26dMP69BwePQao1M8Acrrex9sAHYjQGyVmReRjVEtv9iG4DoTsnIR3amKVk6si4Ea
 X/mrapJqSCcBUVYUFH8M7bsm4CSxier5ofy8jTEa/CfvkqpKThTMCQPNZKY7hke5qEq1CBk2
 wxhX48ZrJEFf1v3NuV3OimgsF2odzieNABEBAAHCwXwEGAEKACYCGwwWIQSpQNQ0mSwujpkQ
 PVAiT6fnzIKmZAUCZ8gcVAUJFhTonwAKCRAiT6fnzIKmZLY8D/9uo3Ut9yi2YCuASWxr7QQZ
 lJCViArjymbxYB5NdOeC50/0gnhK4pgdHlE2MdwF6o34x7TPFGpjNFvycZqccSQPJ/gibwNA
 zx3q9vJT4Vw+YbiyS53iSBLXMweeVV1Jd9IjAoL+EqB0cbxoFXvnjkvP1foiiF5r73jCd4PR
 rD+GoX5BZ7AZmFYmuJYBm28STM2NA6LhT0X+2su16f/HtummENKcMwom0hNu3MBNPUOrujtW
 khQrWcJNAAsy4yMoJ2Lw51T/5X5Hc7jQ9da9fyqu+phqlVtn70qpPvgWy4HRhr25fCAEXZDp
 xG4RNmTm+pqorHOqhBkI7wA7P/nyPo7ZEc3L+ZkQ37u0nlOyrjbNUniPGxPxv1imVq8IyycG
 AN5FaFxtiELK22gvudghLJaDiRBhn8/AhXc642/Z/yIpizE2xG4KU4AXzb6C+o7LX/WmmsWP
 Ly6jamSg6tvrdo4/e87lUedEqCtrp2o1xpn5zongf6cQkaLZKQcBQnPmgHO5OG8+50u88D9I
 rywqgzTUhHFKKF6/9L/lYtrNcHU8Z6Y4Ju/MLUiNYkmtrGIMnkjKCiRqlRrZE/v5YFHbayRD
 dJKXobXTtCBYpLJM4ZYRpGZXne/FAtWNe4KbNJJqxMvrTOrnIatPj8NhBVI0RSJRsbilh6TE
 m6M14QORSWTLRg==
In-Reply-To: <956bc9c031604811c0070d2f4bf2f1373f230213.1762812360.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 02CE6140014
X-Stat-Signature: had5rzayzmgq3tsyuqsdpyfif4kb17ga
X-Rspam-User: 
X-HE-Tag: 1764265371-534506
X-HE-Meta: U2FsdGVkX1/U7gNUc5NC9owx2hg9rEM4tO4WraTqDtfKXhhHidLgyHwM5+uJCN9/NpptZmigNA8oq5lrlzU066qv8S3S5FxAV9JmWQ1zZQndrvlz2B3YTlpFLalzTwHCYLzLH3vWmZ4XmdzfjiWSjI9iF9jKyC68wf1rpFCLJP6pH350yUsehr6caqbqUSUAZLB5NP3RAisA5V3zohOOZIssR0dFCISuT2Ic2eZSVcmkf0s4/Qh1ipgj3Y0stvkxaFaWM+kUooHXrDwVrAOMUVoCHcGliAC90Vpq+e7haP7JfS6cPdZcQYUXR12bAbD5Q85u7+PoBjM1hR2s7Um81ehn42gvOP2U30lwBzqWqjBMWBbaUDiSalVRQxI1AD7vbgPD3K1/9Fh3KJ+sOFkj94pV5DGK77wb/shEHu9RE3GZtYbuVWgxSw2f3F95Iba6oB1P5IKhphLPo0QtXHe4bRELbd+3ZBedUVADmyD0EwBu3VeCdnze9GGbllZ5u0Sp0ha+d1PDHs88098XSQzWaQBpfMWgTc5WOJ8EZ3lmVDccfC0nf/t4qEco8b22zQ0Nfa7mFjumF0mjfDWkFkIb8Ej8aXw17rj3BjvhPofrCoEOX9aRyKWUqmHnyYN+ZWqj3aSF+4uE2HU1zl4PzNZ4V3EAE/dQQT0sfsijCavtk/OMYHRzYCEhsuy4wIKs2OCeJTFB81NI1Au0pDkiHO9DDul1zq3+X6Y0WFg5D1o6zDurrAd0utce0xIxgOV7dZdH+J+4gekvtKpDLdUbfR6jcdkhW8u+GMsh5k1y05rj/2ArRGvMziAqukqu1t8fWI7sTgYmVM8Q5lMY0qJwsPiZ2pA4AQ/wRCzyjt29wkX5cepF+S2gO0ytQ8Iare26Kbo96ipq6hUBOZpsaWGtT0bkW1qVR4hhPYXnaShNwwRXreR7Ol+L7BIPP9PrRGLL+klM3X3M0gy7jvGcFgJHWdf
 8Vg2lTDS
 3dTzt2IYsgeL4ckKA7QOiOn+vWAeKrO6D8nFxITt3mas51JzFLu9I0KxX8ceKa2MBPziqXzUlI/Z3PrsOjG0+aJWjYSFF+vJoIhXEziP8NGEsHSdEtCIn2WseiJvrdm850Ykoj90uzCTkkwleVnR80Bw9+g0KKawNGz68tnlRupbr9bEqKbpW6DyNLPx1HTUV7WEOoWg/BGGz16p1haPLkBI0H4mLg8fwPEHpiDHP0NGTc+vZqAYI60u7Mbb+ueIfQajx5dQazlMlh9cbyyw1pgcEUDaOxRHn4n0xtWLaTtwV4XHMJ0I8mCxil8y60H2ZfmqKdS6wtmeBwjoSknQ5n1w/ZQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/10/25 23:21, Lorenzo Stoakes wrote:
> Having converted so much of the code base to software leaf entries, we can
> mop up some remaining cases.
> 
> We replace is_pfn_swap_entry(), pfn_swap_entry_to_page(),
> is_writable_device_private_entry(), is_device_exclusive_entry(),
> is_migration_entry(), is_writable_migration_entry(),
> is_readable_migration_entry(), swp_offset_pfn() and pfn_swap_entry_folio()
> with softleaf equivalents.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>

Two completely non-urgent nits below.

> ---
>  16 files changed, 75 insertions(+), 176 deletions(-)

Nice.

> index f5ea9b0385ff..d282fab866a1 100644
> --- a/include/linux/leafops.h
> +++ b/include/linux/leafops.h
> @@ -355,7 +355,7 @@ static inline unsigned long softleaf_to_pfn(softleaf_t entry)
>  	VM_WARN_ON_ONCE(!softleaf_has_pfn(entry));
>  
>  	/* Temporary until swp_entry_t eliminated. */
> -	return swp_offset_pfn(entry);
> +	return swp_offset(entry) & SWP_PFN_MASK;
>  }
>  
>  /**
> @@ -366,10 +366,16 @@ static inline unsigned long softleaf_to_pfn(softleaf_t entry)
>   */
>  static inline struct page *softleaf_to_page(softleaf_t entry)
>  {
> +	struct page *page = pfn_to_page(softleaf_to_pfn(entry));
> +
>  	VM_WARN_ON_ONCE(!softleaf_has_pfn(entry));

Nit: the warning is already in softleaf_to_pfn()

> +	/*
> +	 * Any use of migration entries may only occur while the
> +	 * corresponding page is locked
> +	 */
> +	VM_WARN_ON_ONCE(softleaf_is_migration(entry) && !PageLocked(page));
>  
> -	/* Temporary until swp_entry_t eliminated. */
> -	return pfn_swap_entry_to_page(entry);
> +	return page;
>  }
>  
>  /**
> @@ -380,10 +386,17 @@ static inline struct page *softleaf_to_page(softleaf_t entry)
>   */
>  static inline struct folio *softleaf_to_folio(softleaf_t entry)
>  {
> -	VM_WARN_ON_ONCE(!softleaf_has_pfn(entry));
> +	struct folio *folio = pfn_folio(softleaf_to_pfn(entry));
>  
> -	/* Temporary until swp_entry_t eliminated. */
> -	return pfn_swap_entry_folio(entry);
> +	VM_WARN_ON_ONCE(!softleaf_has_pfn(entry));

Ditto.

> +	/*
> +	 * Any use of migration entries may only occur while the
> +	 * corresponding folio is locked.
> +	 */
> +	VM_WARN_ON_ONCE(softleaf_is_migration(entry) &&
> +			!folio_test_locked(folio));
> +
> +	return folio;
>  }
>  
>  /**

