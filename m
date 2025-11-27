Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74401D111A8
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 17:12:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDF3B6B0093; Thu, 27 Nov 2025 12:12:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B90266B0095; Thu, 27 Nov 2025 12:12:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A317F6B0098; Thu, 27 Nov 2025 12:12:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8D88E6B0093
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 12:12:37 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 35F33160243
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 17:12:37 +0000 (UTC)
X-FDA: 84157031154.30.DFAEEDF
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf29.hostedemail.com (Postfix) with ESMTP id B084F12000B
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 17:12:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tcF2zkRY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="5PP4P/Da";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tcF2zkRY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="5PP4P/Da";
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764263555; a=rsa-sha256;
	cv=none;
	b=VHyKvB0euFuYJP9+HGVprBenpbFBa4dTZL++jT/0bkddtWJ4EL9YIVcxhzcqdgGhbxz0Ce
	q7dpYrXvjzEXKAFPqSDQQviUCUqVV1tb/uJATVUPaAmIIoyDUUrsCGrYJ6J40+0HsdMLK9
	JbvSP7GE5tRjsLf3L0YSEv4MDz8SRZQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tcF2zkRY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="5PP4P/Da";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tcF2zkRY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="5PP4P/Da";
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764263555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=muXdCPO0hjEgv1mSmTtKeYXc4kibJAl1WAR2F5e/B8M=;
	b=wSA/c7xnoAtgRVsPDaT6C+z2P/CLOGrYU7W5TIozudkLQLzhe+UPKD/Px8dTndwoMlBe+s
	yTlBqdIbmxoUacEjUFqjzYzlrHaP5vVEvn6bGiav/MfCvoGhUNJ2VvvRT05f2x9Wrzp6XW
	VvdGeFhgW2QBkZeCYJa1/IqIvDikaEU=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F2B3533682;
	Thu, 27 Nov 2025 17:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764263553; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=muXdCPO0hjEgv1mSmTtKeYXc4kibJAl1WAR2F5e/B8M=;
	b=tcF2zkRYl/USlxiTOLnx4ezPZm5abgALyOtNcW+Clv5TsS/mok4YlZSUOMXmxizM0phxBj
	YRpNlgBIvwq06/RKvr8Vh+miSWk3seJtuUATyv66zM+MiintsU1zHi++wxB9iXXDv/wy21
	Kng3/P5AnLp9b258ocpi48OfZ/+WWVU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764263553;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=muXdCPO0hjEgv1mSmTtKeYXc4kibJAl1WAR2F5e/B8M=;
	b=5PP4P/DauP7TF2V79v6nom1eiGVrP5sM5vFIkeUcBMF6xWkbRGiGAWGaECl8FLkiTD8qAv
	nNgcZEszTaiQ0pCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764263553; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=muXdCPO0hjEgv1mSmTtKeYXc4kibJAl1WAR2F5e/B8M=;
	b=tcF2zkRYl/USlxiTOLnx4ezPZm5abgALyOtNcW+Clv5TsS/mok4YlZSUOMXmxizM0phxBj
	YRpNlgBIvwq06/RKvr8Vh+miSWk3seJtuUATyv66zM+MiintsU1zHi++wxB9iXXDv/wy21
	Kng3/P5AnLp9b258ocpi48OfZ/+WWVU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764263553;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=muXdCPO0hjEgv1mSmTtKeYXc4kibJAl1WAR2F5e/B8M=;
	b=5PP4P/DauP7TF2V79v6nom1eiGVrP5sM5vFIkeUcBMF6xWkbRGiGAWGaECl8FLkiTD8qAv
	nNgcZEszTaiQ0pCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 842B63EA63;
	Thu, 27 Nov 2025 17:12:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9PCSHoCGKGlQLQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 27 Nov 2025 17:12:32 +0000
Message-ID: <73d414c1-8cdf-4d61-baa0-e4d689b3973b@suse.cz>
Date: Thu, 27 Nov 2025 18:12:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 13/16] mm: remove non_swap_entry() and use softleaf
 helpers instead
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
 <2562093f37f4a9cffea0447058014485eb50aaaf.1762812360.git.lorenzo.stoakes@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <2562093f37f4a9cffea0447058014485eb50aaaf.1762812360.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B084F12000B
X-Stat-Signature: g84wqn5age4nrrc4oicyx59jfk3wjdib
X-Rspam-User: 
X-HE-Tag: 1764263554-575204
X-HE-Meta: U2FsdGVkX1/ZyNTBeR7UZVkQPo+2Hu9TcllfO/qsjyqtVc0bH4MUexhnKP6fcMU+Xqs997Bc1MSlqWUGArYvvaOV8mZKCnfzwjGC7vcDJWSnCKsdWMt6JgEy0gEhns84ZP1Kto18yLf6zembpHhwWdEodK3XbNN4/k6+4oKrN+iIsBV0tMvL5Ho4n33otgUzIq8Cgf2OId2zbpxNhXQZ6TNqPanaYqdfVCnpMCg8DDLdhwW5lJg7IwszWp2KGLe1A07aNYaf8brRT5sKGpGfBVOX5MRxKAFNmIjCpyG35nDMVaguBPDNnlkadBMTZuKdIPyvxqAxjnqMDf+xkFXbJ/Rl74S0RQt2/5x/Zbk9tsB5HQ/5bvvA4LsKM8Vf7OY91A8euiVB3H5hXIRRj8TJh77/yjizX/yNdMFfHXcEbF3rLxzd9qNKMPdwqeMeDn1p0flawBgAAFalY2ejfBHxYbOvU5Y3IXt3zC69u6/XOnN2AJukHerbwcQFPTyDATqPWdVu1jLZpAA9JepOSGX6Oweji9p+26YJP81WM+oT//VhCOCtaX2iMD9VwQb4FyYSD3YYECadc9joZR/SZBpT/KtRRC/Vdcuuy12ieIq/FgrY1VuR8/sD1DeAIV5sf5ruBjLYe60l04hoQrZRY303/6lPBB08jga7QYCbzpV1XUXWV8Q7Q9uyTKd68b40Ce+ixbIQMnXV8PBJBpJdcT05gwXj3C0TH6HNmRvJ/wKYbW1maRuNI9uORr25lAPL2ul5lsFXVeeIlJzJ4RPegpxC5rNJXRzGQp3wql0fOe1ouT+p3tqypXjpqRaKUWjXiVAxvsZr2Im3JJN6q7fku381NMQS2UgDwbc+XraS/UoGQvEozkZMfYANvPc+SqUrVgtZaifugVI4R9/lwr4lMLQYmQV81nxNRb0JCFqueJ8/SBx7Pzr+R1MBlt0t1WS3FWATgyMEOPm3KtV4xNjbEQr
 jInZwvqb
 qgvmpXMXLaN+Gg6SmhhKUgIc1mv+/mSyyHVmcyrkdyJ3eh42R4W501Ncv9o9dcjj8AvJoCsh8Jx/NJriOjKA/UtssAbVX8DnFduopWGwCfQ1khc1FBDdi4481fcj1JIlCGm5hQdbV9J5oqPi+dc4Re8H4M3IphXyIrddI6XtooMkHfipr+JqNWf0esML4hPlr4mMG9PbpzYpm61mH2iyYrBGff5+lL6kCOXXHi3cXLuw6v9/Bqqgo6cjVMd3CiFMmX1LhJa0JeEY1U8xRKF75/i2oEgA1zOZ3a+t1+S5WWrb9ZmJrV8LFJsXub1vovJWRM+nFM2EgaspO8brur6/XUrAXN8RhHdzSmWLkR8QTgA1p+SFQ6UQ/bDWBthpCb/BaGbeOMcirUBHpT7sUEyvJO78BwGYWtnPbqGNOWiEg6j7XXWo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/10/25 23:21, Lorenzo Stoakes wrote:
> There is simply no need for the hugely confusing concept of 'non-swap' swap
> entries now we have the concept of softleaf entries and relevant
> softleaf_xxx() helpers.
> 
> Adjust all callers to use these instead and remove non_swap_entry()
> altogether.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Nice!

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>

> @@ -1430,19 +1429,20 @@ static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd
>  					orig_dst_pte, orig_src_pte, dst_pmd,
>  					dst_pmdval, dst_ptl, src_ptl, &src_folio,
>  					len);
> -	} else {
> +	} else { /* !pte_present() */
>  		struct folio *folio = NULL;
> +		const softleaf_t entry = softleaf_from_pte(orig_src_pte);
>  
> -		entry = pte_to_swp_entry(orig_src_pte);
> -		if (non_swap_entry(entry)) {
> -			if (is_migration_entry(entry)) {
> -				pte_unmap(src_pte);
> -				pte_unmap(dst_pte);
> -				src_pte = dst_pte = NULL;
> -				migration_entry_wait(mm, src_pmd, src_addr);
> -				ret = -EAGAIN;
> -			} else
> -				ret = -EFAULT;

Eww, good to get rid of this.

> +		if (softleaf_is_migration(entry)) {
> +			pte_unmap(src_pte);
> +			pte_unmap(dst_pte);
> +			src_pte = dst_pte = NULL;
> +			migration_entry_wait(mm, src_pmd, src_addr);
> +
> +			ret = -EAGAIN;
> +			goto out;
> +		} else if (!softleaf_is_swap(entry)) {
> +			ret = -EFAULT;
>  			goto out;
>  		}
>  


