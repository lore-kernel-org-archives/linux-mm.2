Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E0A4CFC295
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 17:10:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9F916B0010; Fri, 21 Nov 2025 12:10:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4E996B002D; Fri, 21 Nov 2025 12:10:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EFFD6B0088; Fri, 21 Nov 2025 12:10:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 87E516B0010
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 12:10:16 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3A75E89C0F
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 17:10:16 +0000 (UTC)
X-FDA: 84135252432.14.8832290
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf20.hostedemail.com (Postfix) with ESMTP id BBDB31C0007
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 17:10:13 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=h7i6TXUY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+uR5t++p;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=h7i6TXUY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+uR5t++p;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763745014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IvYqDYULzOTgnw2r6/zPhQ1WOCd/M0ctrvyFGAsskZc=;
	b=udD1oW5Z83qFVs4gBIz6+7qvNhfHOHqQmdGftf1EqxhZoFo+4W/ljt85ElZyAdRf8skqmL
	h0VQzGG60aXJ2Hh5W55b+w3j57PQnGwG8cx1ryspsUB1JVc7d3iKTo5K35yS29Ym5wwsSR
	9MN5/rxfd84n99hhCH2I8cYqTbvp+G0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=h7i6TXUY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+uR5t++p;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=h7i6TXUY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+uR5t++p;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763745014; a=rsa-sha256;
	cv=none;
	b=qcW6K814sv0fRdy1ySLiUDDEnz25df+e0j0RcBN69f7CO9y9jKh63bXflPSsiJlbrx8R4/
	afobs6fERlnUZSjxQpKwZ91hZqzpMmB74QarTyiTOAi1MDeNd5sruJXHnfaDXvZhv+l3j9
	KtYT60w256rhRzNb0CXaTqpGxBoejNw=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B9D16219FE;
	Fri, 21 Nov 2025 17:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763745011; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=IvYqDYULzOTgnw2r6/zPhQ1WOCd/M0ctrvyFGAsskZc=;
	b=h7i6TXUYfSuW0WzRgslqS2fymXU2sXrf4TwD7hQhKpoCs6DePTP5TiNoo6c4LvIA2soF/K
	Ze7i0tmEB6pW+krbhud8WyH5DsDWQGBn8/UaENHXAmMykWC0hkH9h+PlWnc9KJmgcRp54a
	ZvXP+/1LRC+58q0lyzVE1M7Otq2a4t0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763745011;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=IvYqDYULzOTgnw2r6/zPhQ1WOCd/M0ctrvyFGAsskZc=;
	b=+uR5t++pwYwzlEM/52jTcJFIPrRpraOGnSeM+8XfV0i0K1pjd3rRhta7XuBVtu1y7eVXD7
	RXFHYrKMt3A/srDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763745011; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=IvYqDYULzOTgnw2r6/zPhQ1WOCd/M0ctrvyFGAsskZc=;
	b=h7i6TXUYfSuW0WzRgslqS2fymXU2sXrf4TwD7hQhKpoCs6DePTP5TiNoo6c4LvIA2soF/K
	Ze7i0tmEB6pW+krbhud8WyH5DsDWQGBn8/UaENHXAmMykWC0hkH9h+PlWnc9KJmgcRp54a
	ZvXP+/1LRC+58q0lyzVE1M7Otq2a4t0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763745011;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=IvYqDYULzOTgnw2r6/zPhQ1WOCd/M0ctrvyFGAsskZc=;
	b=+uR5t++pwYwzlEM/52jTcJFIPrRpraOGnSeM+8XfV0i0K1pjd3rRhta7XuBVtu1y7eVXD7
	RXFHYrKMt3A/srDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5310E3EA61;
	Fri, 21 Nov 2025 17:10:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QiXvE/OcIGneMwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 21 Nov 2025 17:10:11 +0000
Message-ID: <e0fb91ad-736f-4ee9-979d-c2512ec0b544@suse.cz>
Date: Fri, 21 Nov 2025 18:10:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 05/16] mm: use leaf entries in debug pgtable + remove
 is_swap_pte()
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
 <222f352e7a99191b4bdfa77e835f2fc0dd83fa72.1762812360.git.lorenzo.stoakes@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <222f352e7a99191b4bdfa77e835f2fc0dd83fa72.1762812360.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: BBDB31C0007
X-Stat-Signature: 8119aipe5ypromnyrdo8qhees95gogtg
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763745013-860355
X-HE-Meta: U2FsdGVkX18xR/82Wf8cm4F8dCo1s6zCxWBDIfSJvr2zMtp6/CR3ZSfzzxbCxI9L/feO6anhPFi3i5j2TjhRZQTwIoADQdwdjU9pcGkhig3lhSGUi0pYr+X5sxA9Nqun3/xVmKsWiORgu6JDYiAs5cApnw/UG+88nk1P2uYb3KNRM6+qEhGmE+r6F/Mp4LMNgeu2wdPErEFM8WiPl558HUhwo/h8V6eXv1zHvYCDrvlRseMznVRkNkgU8xvPa47XsISmyaAvxkl9ZN37wZE43V7iBxkf4J/DSIanOPefexfjPdbntqqIEesj6bbPVNIQUwGq6YJ5KDhTDx8/Jv9QDBlMsgD+YV7xcar5Vx5MqWV1pFUtnLYHafA3W/Qr80/PQy/KBEKyxTElBZu31tK+A8NlmEDpD+EhXxOUD/7vA998Y9uGzC7fYtPG0nkOMhE5nvWd7E2TzBTcUxDg0YP+1XpuDItJozX5g14jQSdRbgN3QjLpm40XiPYOpueAecU1ppIFl4pnCIiaITFvpS25xvnOkTD/f6hN32oeMuGxNf+F52fAzmURkxUu9bZS7q3Z+EjtvgiZdXNt0XRPgWO8dCxmlyL6XCFvFSQjO3kZYKh2mxqJn0AfAsxUfSh9ibpb/3BTtRMLICqjbD5IWKno/CxLbnzWGt800RhUKZ8H0BAE2E+a0YICsVctaZbdT0sLgDhM9wp6LwCcaTyCSkRkmzHZTlTHtZ0Mq/9xN8TLnLSjLvi54A76jaFh0Xf0FyaUcmODSPCebjVgGGC+ovIcheU/3fGf+yHjMH3KGdKZOK9nuA2IM8F6A3ig4gqw8bbO4drnaVqyIzbljLRNAz2v/s3oSpV63vWiW4+Abzzhj496fjgGAzSeKXL1OLDOHFuSvH1GPm9CPZB44d5Mj6pXEpGM8gbjW6xzOPyYMFEsJhU1FX29hMSUNlC1Ti+DWVbRY2V/qW9crKQANJ9TJxF
 W2KJaMoa
 HxVpLHyw+03ASqvDmslSkB3YIfNkLWbhHvOiqGho39JYaUhz9waV+0WxRovoWJ0Ok2MqCVk3emSWLOyaeVEb18/3SAfSRfujxW9HEzITXJl0Lu/Yiu4XEArU+3QlQaTMDPSTqRSpprQcZeMwPi3Gs3SLTvshyEhY9kF/KbcOId2C4JvYBtTEBK/G5oLH5RKceridFByolGr+LQb2VaZfSxieqWBRGbpAF2n6C4c0sFQIbnUeQv5pZiAsGWRYYgK/7mDdYc1o5+FFs8qeiGU5CaraGzTP9JzBHylumEUA8ofz7DYtCfF2+gVUOuIRJIfoIg40e9YmpNWb6DrJzS9tuCeo+glo0DdKgsrfEGkdSdcbQe6+vcdKvya4ba6IsvZbsVdUd6CmTfV2e8TYKfkHq3tG1GHe36ZunVTXsr5TvAcwg+To=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/10/25 23:21, Lorenzo Stoakes wrote:
> Remove invocations of is_swap_pte() in mm/debug_vm_pgtable.c and use
> softleaf_from_pte() and softleaf_is_swap() as necessary to replace this
> usage.
> 
> We update the test code to use a 'true' swap entry throughout so we are
> guaranteed this is not a non-swap entry, so all asserts continue to operate
> correctly.
> 
> With this change in place, we no longer use is_swap_pte() anywhere, so
> remove it.

Nice!

> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>


