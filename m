Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E74DCFC299
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 17:42:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F7156B0029; Fri, 21 Nov 2025 12:42:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A7206B0095; Fri, 21 Nov 2025 12:42:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 547306B0096; Fri, 21 Nov 2025 12:42:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3EC536B0029
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 12:42:16 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 84BB95A1BF
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 17:42:11 +0000 (UTC)
X-FDA: 84135332862.23.6A411CD
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf08.hostedemail.com (Postfix) with ESMTP id 06020160004
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 17:42:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uLMmVYxu;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=t4IfWiE1;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=T7hcIXIa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="o/bNKbry";
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763746929; a=rsa-sha256;
	cv=none;
	b=kdhAF1/qHVxcYgPqquxJ7VLPn7WC/YkkBszPL6PIftL47mnF8YVffZ3Rx9fvDmEcWHOQE2
	TSgsa0ttBlqX2y/7lZU03/S8uZB+zPh3YpBkb0+kFfL97CVwFGTf5bPRMt/hFqg+WXju1T
	ulZNfmU8nt/1TRL2oqKVZ4TMyqFXmTw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uLMmVYxu;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=t4IfWiE1;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=T7hcIXIa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="o/bNKbry";
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763746929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fvWL+lNKlgX1eT380bMrHtywD2H5E0N2B/Kzj0lZgPo=;
	b=7XOiON1pMUKpx2hKjrpOyyQ3hXiVHV1wFKeIMOKd6gHK9g7VmKgtP0azW9cVdWMj8XsXTS
	gcdnezGBB4cq+W8uA0qtwyVPCW2QulH3edeFXcnveC2HtEQLgd+pYV4ciP3Kfdw8r4fBZb
	7P3X6l90IG8c5jQVs4sFLKctoM/Hv7Y=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DF7F25BCC3;
	Fri, 21 Nov 2025 17:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763746927; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fvWL+lNKlgX1eT380bMrHtywD2H5E0N2B/Kzj0lZgPo=;
	b=uLMmVYxuB3iqeJI8ECB2zGfRGLM7O1/V1ZUySd9bXqAQBeTMKgxA/wNcg/926E/UMTDxUL
	u1gH9v7mp2YVjldkU9Y9WtIXNoyZr1kupmsg4wG2bL5XKpM9CV4sqK4VophSRhG9c/j78X
	ISe9maoRW/cl9NTupz5Ujf2ou65IRE0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763746927;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fvWL+lNKlgX1eT380bMrHtywD2H5E0N2B/Kzj0lZgPo=;
	b=t4IfWiE11vitXTClhh71GDzG3r3w/GifZc4sin3krRAldyW8e9G8iM/AfxSVi0G5Qyh7bm
	M3evORf23xeZBHAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763746926; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fvWL+lNKlgX1eT380bMrHtywD2H5E0N2B/Kzj0lZgPo=;
	b=T7hcIXIanly/cX0OvdRH0T3me2gS34gXAkerlgk9WIp3Bqyc74IvvWIZ2Zm+V7/YyDoew6
	8MJvRnsfyBtxsOq5xaipffYPkfpKnkVJ/BjRDU9CyebbTjYJTXCEV7BuLBI18cAsNko0gj
	WN4h4rGaBNmzoAxHJhHYe+Upj2jOIWk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763746926;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fvWL+lNKlgX1eT380bMrHtywD2H5E0N2B/Kzj0lZgPo=;
	b=o/bNKbry4JiKL2w+Ld6T9S/2pyKcFIPzgvzP6g4jlnfEDbqTIId00mFXolRXTNVnSYAOk5
	HbW8S44BM7Q1s8Bw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 502523EA61;
	Fri, 21 Nov 2025 17:42:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id f0LSEm6kIGkDUgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 21 Nov 2025 17:42:06 +0000
Message-ID: <a623f785-6928-4037-b4be-5d42b46aa603@suse.cz>
Date: Fri, 21 Nov 2025 18:42:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/16] mm: avoid unnecessary use of is_swap_pmd()
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
 <8a1704b36a009c18032d5bea4cb68e71448fbbe5.1762812360.git.lorenzo.stoakes@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <8a1704b36a009c18032d5bea4cb68e71448fbbe5.1762812360.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 06020160004
X-Stat-Signature: d17bpxxgmnkdoorph9gbzeo56gjh4r1u
X-HE-Tag: 1763746928-903678
X-HE-Meta: U2FsdGVkX1/iVT2BkbeQy5RL/iyMQ+b5sOmibQy861ejCH6r6wAVDtAhGt5PU25dsPN+rFKq2wN50ZiHBMMTKnmakh1XJL6sm0j4arEzwpXeBj1bbX08+HQdyksc1r3fCg9puQRKRnbww3CVlRPjTtckcEnBle4NdepwmC+SDZcblwH8sv7h9ndMAx2YXY/Sd0YFLAsdrkuBBmSy+dlcAfUu2Yzx+6nrKVnESKkAIujPsDLkPHyCPQml6xCxIRmtLPsAcxsUPQ2Dl01m+xAM5fU82VXUm4b3lHyPfOphRgIpATw/QmUO2Ef13hjwQNaVf0m7+HOR0MDaghyFgaVMYbFVek5LeW/DFILJRS3C0mTZlmay1agsAlSJRS0uT7xGd9ntU055KlWhaO3dxt2Fj5rCMnPBqvU5niUmSRQcqY0UUX3TXdDAczfqPY5JbsUmuvyXzSj6LDNpFBW91zlj0tuUQjSpYDNuf9bbixeHo8Qe83FAUxWJ9XZCZ62Cmkcktm8xJvvahFPl8mVpIeb89uFU82qwHFuf7hICNgEOEXIDwLjyx0nh0EF19D8mCc4Mcy84HJx1FjCKJ0i77fd1naEdnBSJAHQrtJqBbjFJBnj428rRKr0O6reBAZN3gK224CMgsL3m5aVJ8SCp7kjn4NdtNgwQrDt/4KyIHrbbszoMxGFqKSNZ9JhORAw8yNVR/O5Ohy9htKV9ob6y48jIsMUVJbklCiKNoYekW4Z6ELLSxFi/2mKq1Hw32zRVpODis84PgELPX9+sXDeNj8Xm02TDT3e6n4HTJCYheIlxVJ3rtLZ0EbiT98q2J1ZC8jDaceJD355UDJlTgMbVuOlRl8xQy9HZK53GVosBh6fS8rz1NLtLj2f/75g3Nzvk4ah90SmEGm/IWOiKkhPst3NFw8n4TllKJHwuthmvwyLaVF/qkeMdKFzVpSEbqy3wdrTydlRnb8Vco0mhWuk8ZNe
 P/FkAmQa
 dNYC75BYwCr2lDb0G3mglp75aoHZjZlXPpbGevdRSKU13djytNFRl+UHyStDL4iNWv+tWXRXwhjAQ2r4Q9ZeLyJNTSdfr3yOiDC7zy/BIJ+DcSri7d/7utf/Z+E+0SXsWYushRnoexjI34jEtha/6lqQoUYGNJre/ryFQSiFGjsMnFCUFGFIwTgsbE71vegFBwWRYGeEc0r28gsTMUR/m2thJUJP4n/pygl6edfiSvIwB348uYT8jKSbj9SPSM1gCji2/EldjMx4J6wywiXtpfUXMLM9CRP3BvoMWcyR1GiM3zD331Es4wkBBtvQ6HssJbMM+n937RGwR7sFdlkGvDE08PvuicyZ80X+lc/HHDGnnj4Hdxa+y58ZdeyN57P5AcGYu7Rx/j08ufy/ErqHwwgUN9LMX74ElpTPF9bEBv+/6cjk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/10/25 23:21, Lorenzo Stoakes wrote:
> PMD 'non-swap' swap entries are currently used for PMD-level migration
> entries and device private entries.
> 
> To add to the confusion in this terminology we use is_swap_pmd() in an
> inconsistent way similar to how is_swap_pte() was being used - sometimes
> adopting the convention that pmd_none(), !pmd_present() implies PMD 'swap'

			       !pmd_none()

?

> entry, sometimes not.
> 
> This patch handles the low-hanging fruit of cases where we can simply
> substitute other predicates for is_swap_pmd().
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>


