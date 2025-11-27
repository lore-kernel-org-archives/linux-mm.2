Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3F67D111A8
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 18:02:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D31E56B0089; Thu, 27 Nov 2025 13:02:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE2B46B008C; Thu, 27 Nov 2025 13:02:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B83726B0092; Thu, 27 Nov 2025 13:02:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A249F6B0089
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 13:02:24 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 33B4088499
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 18:02:24 +0000 (UTC)
X-FDA: 84157156608.10.C7DDECC
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8E8641A0018
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 18:02:21 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jaQoFt6s;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=eI1N54OM;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jaQoFt6s;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=eI1N54OM;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764266542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LprbQYn11VfhFsTFjUTcXyobIQcXWdrCP7r8wxLZPag=;
	b=JDX6t2IpVGtn0EH9cFIvksj80Am1TG7p3nsObaJLg519PtBCqg2BrrryzJCSZWSSB1jTyS
	NXCsMvGAnypthdpEbq1E/lD4EazoL49hUVYhhN1A/SLmEiFj8yUW1W8GxIimeVqMTzbC4I
	7Vjeg73TVR90Dvn2DEWvLjJl2y/j6bM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764266542; a=rsa-sha256;
	cv=none;
	b=StjrEINehScZ3FCtUm2KCvwIcCq76TBkOfLYE5JisHkSYklQglVFW4oSheYcWeEDisFXsK
	85JoGORfZaD8L5Hx9SDgkcgncJZ48/vAVdtEOa1FPXozqfNC6KjoSNRfPTP7X6j58Tp2Ie
	Ms4cyVuMI/qHWvkvUXdH4ecD/BevVNs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jaQoFt6s;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=eI1N54OM;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jaQoFt6s;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=eI1N54OM;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 75A0E33693;
	Thu, 27 Nov 2025 18:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764266538; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LprbQYn11VfhFsTFjUTcXyobIQcXWdrCP7r8wxLZPag=;
	b=jaQoFt6syjlu8H32MMxJRaEDexU7FfX21I72il4ZbGVEOCDMN+1Ybz9U+hA0Dz5uot+32u
	1suLuQJM+LGG/cAAOQ6M4ohnWzo9PyOJkmUDWXb57M+mtU1i226DIlhwWuAgYrz/ve2gdw
	AgT6qq4DHAE7QnH5zWbZfuQTXWbeMIA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764266538;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LprbQYn11VfhFsTFjUTcXyobIQcXWdrCP7r8wxLZPag=;
	b=eI1N54OMcZ8ii3TTS8drrzDjF/fJHcUopw/TdadWtI0i+9YlCvRHAMBrTn880nIIv0IMuK
	iS+DBQtk5Fh3OvCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764266538; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LprbQYn11VfhFsTFjUTcXyobIQcXWdrCP7r8wxLZPag=;
	b=jaQoFt6syjlu8H32MMxJRaEDexU7FfX21I72il4ZbGVEOCDMN+1Ybz9U+hA0Dz5uot+32u
	1suLuQJM+LGG/cAAOQ6M4ohnWzo9PyOJkmUDWXb57M+mtU1i226DIlhwWuAgYrz/ve2gdw
	AgT6qq4DHAE7QnH5zWbZfuQTXWbeMIA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764266538;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LprbQYn11VfhFsTFjUTcXyobIQcXWdrCP7r8wxLZPag=;
	b=eI1N54OMcZ8ii3TTS8drrzDjF/fJHcUopw/TdadWtI0i+9YlCvRHAMBrTn880nIIv0IMuK
	iS+DBQtk5Fh3OvCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DF0BB3EA63;
	Thu, 27 Nov 2025 18:02:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0f2DNSmSKGn+XAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 27 Nov 2025 18:02:17 +0000
Message-ID: <49f667b0-1ef6-42d1-9271-a20a6a12f325@suse.cz>
Date: Thu, 27 Nov 2025 19:02:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 16/16] mm: replace remaining pte_to_swp_entry() with
 softleaf_from_pte()
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
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
 <d8ee5ccefe4c42d7c4fe1a2e46f285ac40421cd3.1762812360.git.lorenzo.stoakes@oracle.com>
 <f2385065-cdd4-4e87-872a-b5e83014e590@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <f2385065-cdd4-4e87-872a-b5e83014e590@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 8E8641A0018
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: bxqzxnsrpqh1ngem8yt99mmja5hf8gkr
X-HE-Tag: 1764266541-209672
X-HE-Meta: U2FsdGVkX1+LinjqVqBspli9n3RIRyPViKmYS6sC0dotpYFd9wPTCltRShn6Rc2fdhnQ+zL/izcaboBUB59QLvEUc369cewM9Nddhv9IhrYasRh5KQDdjfLKuQPEYVrju+l5Tp7VT3gBzkdvgIVCjj9kLSHtS5nAreSRH59vxSB/wwjRkvVuc89scQUtObhhi5H/EBxDf3nmOUnZAB8kO5itNBQcfjC5UvRIGkT1WKJxWhRUxl9RdtISUZjb6WykWh5yItAE0lgdasO+g9I7GcHADUODQPpiUbcGuX4ZiVI4g6pkegMu/QHcF+vWfoB66ckpQmOh+zAtlq2iubX5yk1kHfed/4+ZY3HeT8bumH4XL+x1i7nhCSr/BMP7YJqXSyy17mjS4SFrwWNNmZsBfnRNU+POuk9EonjXVbhcQ701JdvZj9lIjnvdTHLKsyjvsI4w1vQBXmDH7KJHtav2IgvpLMvLl1UhaH7KxalgCmsY/EUlWB67McQVuxLgptSD+k8lVYZRDplLAuhw4S6QuQ0JIu1cfznkR1QoWF5iBRyOPkP+ybXWYCBcDp+EmI2LoeODgZdtTqpWIZ0uGsDwYrGrLtlNIuG6C7mipD2Aj1w+au6A8Nco5dBm3jSXLN10tWCrCDK82aVuSmQg7kINwsia7ISrx6sTJyvPRzaJzzD7jYO7Ji+rXmAAcN/YTL4JcQZhh9ervM0YmguoB4qY8vyD5NvkfJJnwSsZGWEx+PPD4qvMi1heFc7lhvB7k2M6xwKequZ15N4p1UX39QVpXEgweZEt82RXUZojRVeeCdeV7JedO/hyKyppexbzFyhjAd4yKwTYSCLtfz8HNxqC7T5YuWUxENu113fJZdl8z2ckWGgvkgZBCszm7ytQppDyYMcbk+H2ERAXxYZa17cHjDPh6sa+ENGHpP/eTcFTZq63+66dOV+ei1/yQPvIFUWB2i4YkSBwrP/yw2MorCl
 r24rhPZq
 LQW5b077OGHesO6YnOVDv4G+AlCtyXfhvwdzN5rrFo20M5bI/ZPmg71xR7FRtfyVM+CcpN/g7Q6wmkLDxeHDQnwH3Wk2u8flHnFvErLEnMfR9J9DDabl5G1yjFDVBjzEY4M1dziZhYCg9SJXZov6ok9FCchrJwxvohq30jAO6fhnCmv7WN0DI3p1d9Ox45vznyYHkWKiL7XnVv9EyCoEHkMhAiVhQZ2aU0fjSEPl9WugIxsJg6FSNhIiyj636rUOAlJ78w7/tg7mxP88voIhNhEIMu+DdEgSYMd8+3TY78UKQkkwFd9nJ4ORPNkUQvKv+R2BFiG6TiR8o/EWB5qmvhuE3HjcTLCJT76rQvrmCOheg9mGC5oTUOANXqzdwNvHDkQ9z+kd6YYeP+qrPBpjEtg/cQHlypedPigOIMK5slFrtkp+qLcbLPhVPfCgdGxJJhOgQRduJkbm5Gus=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/27/25 18:53, Vlastimil Babka wrote:
> On 11/10/25 23:21, Lorenzo Stoakes wrote:
>> There are straggler invocations of pte_to_swp_entry() lying around, replace
>> all of these with the software leaf entry equivalent - softleaf_from_pte().
>> 
>> With those removed, eliminate pte_to_swp_entry() altogether.
> 
> RIP.
> 
>> No functional change intended.
>> 
>> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> 
> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> 
> Impressive work, I hope it can be promoted to mm-stable now. It would be a

Ah made a mistake checking the git branches, so it's in fact in mm-stable
already. Great! Sorry for the noise.

> pain not to have it merged in the 6.19 merge window. Still plenty of time to
> fix up any hypothetical bugs not found until now during the rc's - overall
> it looks solid.
> 
> Thanks!
> Vlastimil


