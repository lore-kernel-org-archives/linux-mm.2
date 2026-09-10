Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF1BDC79FB6
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 02:41:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BD696B008A; Wed,  9 Sep 2026 22:41:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96E3E6B008C; Wed,  9 Sep 2026 22:41:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 885A36B0096; Wed,  9 Sep 2026 22:41:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4AD826B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 22:41:38 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3CDF81203AC
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 02:41:37 +0000 (UTC)
X-FDA: 85196301834.26.CBCD791
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8816D160006
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 02:41:35 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OJrglBua;
	spf=pass (imf08.hostedemail.com: domain of chao@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chao@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789008095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nu1gPlwGKoa2f9NvPadg4IYpWkUCMvg0otg7hjCzfHw=;
	b=idk9f7oFWoxkRdMzdigUl30iyUO7xcwSLC1OTWOKE+ZWhVj+JpLVFU6kiweAWn9xqNe23Q
	ZmpMk7aZFBUfkM1IFRUNoirnCVS3P88ovyBfJ1CwkslPKcaMei1EBQ+xBZ/51NANRm/XdF
	XOFRbR8+9aJu5p/bRFQ4mJLJAHmiaCQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789008095;
	b=UPZktI5DUxlZTFsO2NQKzE/mbkXRQxqx7m1J51J7YZkKMv1bWUaJOGdaxx/SsdWUvatntu
	5r1Jm9uH7zu6QOXNGPKwcHpYJVzYSKgN0pUJB1UKfYMpF+wDw+FCjTatXPm9RGD1htJsFs
	iaOK9h7S6fB8x0xBZ/RuxWLMO0eRy1Q=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OJrglBua;
	spf=pass (imf08.hostedemail.com: domain of chao@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chao@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DBCAD600CB;
	Thu, 10 Sep 2026 02:41:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA6041F000FF;
	Thu, 10 Sep 2026 02:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789008094;
	bh=nu1gPlwGKoa2f9NvPadg4IYpWkUCMvg0otg7hjCzfHw=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To;
	b=OJrglBuaU9WW+pL5FUY/mAH1U8HHR5HruLQeZQ9r+/JrVmN3mGgghLSG+l8nTQKlR
	 or4uMkgukGXAfG1emnyr2aFnLIgdidovISRTVhcgzvPkW5HCCyrYiU5xk2RjNXhfJj
	 JYmnBbdecJZwKTPvfLhTGzeGCiotp5Dpugo3prgZhSFrjxTnG6ULADcKb1+O2RCf0o
	 2UZjXn6uHDVX8muqscS3LvTGcZl+6hCeRoUh8XZe1M6S0tD5Ymd20LURLBIMrodPkV
	 lSx/92yJRnMyHZwfUxu0ab9wB0Yb77P7vdNXzDz2+SOVRTPvgH09uZwsJtR4/Ofj5w
	 4ll0XVDwPp46g==
Message-ID: <7e11c56d-05e6-48f0-b5b8-b4a0e18ddc1d@kernel.org>
Date: Thu, 10 Sep 2026 10:41:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: chao@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Jaegeuk Kim <jaegeuk@kernel.org>, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH v3 06/14] f2fs: stop using PG_private
To: "David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>
References: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
 <20260907-remove-pg_private-v3-6-6ae22f9d9272@nvidia.com>
 <e5792e81-e8a5-42e1-aafe-58dc603f4968@kernel.org>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <e5792e81-e8a5-42e1-aafe-58dc603f4968@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: cqirbnae8jrw6m55oc7zfpcqx1kthrxf
X-Rspam-User: 
X-Rspamd-Queue-Id: 8816D160006
X-Rspamd-Server: rspam03
X-HE-Tag: 1789008095-689267
X-HE-Meta: U2FsdGVkX18T+GIb4EhxT4beo4FFiUZc63pv1rgca1h+1BKUNscIWr+cwczB213gX6i3TXONUIEqsMfLPXLxgDVb5DxOf9vzieU7kyKr4+GR0iA4bVXFRC8VSiCQNctorn8EtDJRAd3cVopebZ3hjNcsZ9mh8kG+NtqPq2y+2vAiRNydbS23sfOFGVaxroKUCIW2LWp2NXifeBOValziBeiqZabQlGKeZ23HK+PV3aQeyonxWo0JX4WRkkFo0EGl6qDflQaeS02AuJhcpa2dkw4vLFeAsezb+JVrH8h49wGdfqRtKJ1nfomVGVueuy2SFvYnbJcKvWN0PwcCcSgn94GW8/uo0kzNEvztHwqHZEt1HOWnr5vOxWcIp6vSc6m6yy46LZanRcpvbkxqHLxK82CASn8t9bqbhwPJArlYNEVa+wKmQkKRbv7Xv/A/nOxCMSVJsyb4arP0zwiefWK7Fw0wVFyf+V7j69JFNQ/A9pi6S4j2My7Yhg+3dRvbQjqpPG75C2CPEY2HkC2W3qDbDMeYU/WTg1MtGz0WdC1Cqh3ZMgL2oONg7aRT8EITVoO3nFElPCCWoTfSk09+wle/DYZfXA5oEauzadLyXZHHqpjrZV+KhgBZV3X6dLskkyupUPZigY+Mm0Td2h4sKqf1iQm0LfwEXo+b11b3nYcUxA16RFgg9SI/gsrD2JMelQKKVpZ4ImrEex611HDz9ZqAJmsjTTj7zwKj72cSqhTuW7zUHVgnuE8loLWwMDNKfzTV9edE3WRJlfymgvpVJx19B9D+RJxX2idauZuRFqaHOZOjx/HAqo8S9UNBKwomA8+gnoRscNII6rrPJW9+s/tfMZx1ugW82PahShfH/zp6/N2BEmT0C55E802N/Q4kGCq+QAHM0gUJLvvEljJcoLCSKK55tBzuP7q1R193N66lGx/Q/CYr3LVYVg9SNIsDpMdvC1+1NMaLVNTPuJwsIsC
 I7dilOlA
 YrwIQxBy99qrBgKSR7f+fzrmKJEmYZnebOcYmWdzl0EkfdcKz0ue/9nFgHUnE7XBvpkQE8vVz7/EOw2E6HSTDrPaazmp3ADgMXxR51fZmIOr9X/CfZjxCFvmhLe7AZy32J37vPO4uzN7LTNXublryRdZJJ7cDDkAO3a7RPh88KKuuWDXAKV/WvXlOOhYgPZNg/mA7sgglVD4LOjur3KdNnW7pGCfKli/6ygLqKSMMSCy+Qt4c5d8gaAfcE4fAAzur4hybsPR7+6Ct7/mZLymafRUgkX67MoqC3nYKASxbsIWtqhwDAlafHxuiqAORflwU6F95TZ5aLw3mt2b10hdIGink3Gan3ykwQhicCZ7M0mylye6AzRiBM/WVQbOsVnrH/O6H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/26 23:47, David Hildenbrand (Arm) wrote:
> On 9/8/26 04:56, Zi Yan wrote:
>> f2fs sets its PAGE_PRIVATE_* flags in page->private and checking
>> page->private != NULL is equivalent to checking PG_private. Change
>> PagePrivate() to page_private(). Meanwhile, in set_page_private_##name(),
>> page->private is first set to 0/NULL before an PAGE_PRIVATE_* flag is set,
>> but it can cause confusion when PG_private is removed and
>> page->private != NULL is used instead. Change it to initialize
>> page->private to PAGE_PRIVATE_NOT_POINTER instead and retain the original
>> semantics.
>>
>> It prepares for a future commit that removes PG_private.
>>
>> No functional change intended.
>>
>> Assisted-by: Claude:claude-opus-4-8
>> Assisted-by: Codex:gpt-5
>> To: Jaegeuk Kim <jaegeuk@kernel.org>
>> To: Chao Yu <chao@kernel.org>
>> Cc: linux-f2fs-devel@lists.sourceforge.net
>> Cc: linux-kernel@vger.kernel.org
>> Acked-by: Usama Arif <usama.arif@linux.dev>
>> Acked-by: Chao Yu <chao@kernel.org>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>>  fs/f2fs/f2fs.h | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
>> index 9940a6cecf1a2..2f7ab5888b078 100644
>> --- a/fs/f2fs/f2fs.h
>> +++ b/fs/f2fs/f2fs.h
>> @@ -2691,7 +2691,7 @@ static inline bool folio_test_f2fs_##name(const struct folio *folio)	\
>>  }									\
>>  static inline bool page_private_##name(struct page *page) \
>>  { \
>> -	return PagePrivate(page) && \
>> +	return page_private(page) && \
>>  		test_bit(PAGE_PRIVATE_NOT_POINTER, &page_private(page)) && \
>>  		test_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
>>  }
>> @@ -2710,9 +2710,9 @@ static inline void folio_set_f2fs_##name(struct folio *folio)		\
>>  }									\
>>  static inline void set_page_private_##name(struct page *page) \
>>  { \
>> -	if (!PagePrivate(page)) \
>> -		attach_page_private(page, (void *)0); \
>> -	set_bit(PAGE_PRIVATE_NOT_POINTER, &page_private(page)); \
>> +	if (!page_private(page)) \
>> +		attach_page_private(page, \
>> +				(void *)BIT(PAGE_PRIVATE_NOT_POINTER)); \
>>  	set_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
>>  }
> 
> Very weird interface. Why do we even need the page-based interface still?
> 
> $ git grep -E "(set|clear)_page_private"
> compress.c:             clear_page_private_gcing(cc->rpages[i]);
> compress.c:                     set_page_private_gcing(cc->rpages[i]);
> compress.c:             clear_page_private_gcing(cic->rpages[i]);
> f2fs.h:static inline void set_page_private_##name(struct page *page) \
> f2fs.h:static inline void clear_page_private_##name(struct page *page) \
> 
> Seeing code like:
> 
> clear_page_private_gcing(cc->rpages[i]);
> if (folio_test_writeback(page_folio(cc->rpages[i])))
> 	end_page_writeback(cc->rpages[i]);
> 
> Makes me wonder whether we can just use the folio helper instead?
> 
> In f2fs_iget(), we enable large folios only when !f2fs_compressed_file(inode).
> 
> So naive me would assume that we can just get rid of the
> set_page_private_/clear_page_private_ stuff entirely.

David,

Thanks for the patch, at a glance, it seems fine, can you please send
a formal patch? then we can apply to dev-test for test.

Thanks,

> 
> IOW something like:
> 
> 
> From efcde918178604de11d16c6dc5485542ab4dcdaf Mon Sep 17 00:00:00 2001
> From: "David Hildenbrand (Arm)" <david@kernel.org>
> Date: Tue, 8 Sep 2026 17:46:06 +0200
> Subject: [PATCH] tmp
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  fs/f2fs/compress.c | 29 ++++++++++++++++++-----------
>  fs/f2fs/f2fs.h     | 13 -------------
>  2 files changed, 18 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
> index ce88092d9ce26..0e9cc0fa297a4 100644
> --- a/fs/f2fs/compress.c
> +++ b/fs/f2fs/compress.c
> @@ -1064,13 +1064,15 @@ static void cancel_cluster_writeback(struct compress_ctx *cc,
>  
>  	/* Cancel writeback and stay locked. */
>  	for (i = 0; i < cc->cluster_size; i++) {
> +		struct folio *folio = page_folio(cc->rpages[i]);
> +
>  		if (i < submitted) {
>  			inode_inc_dirty_pages(cc->inode);
> -			lock_page(cc->rpages[i]);
> +			folio_lock(folio);
>  		}
> -		clear_page_private_gcing(cc->rpages[i]);
> -		if (folio_test_writeback(page_folio(cc->rpages[i])))
> -			end_page_writeback(cc->rpages[i]);
> +		folio_clear_f2fs_gcing(folio);
> +		if (folio_test_writeback(folio))
> +			folio_end_writeback(folio);
>  	}
>  }
>  
> @@ -1078,11 +1080,15 @@ static void set_cluster_dirty(struct compress_ctx *cc)
>  {
>  	int i;
>  
> -	for (i = 0; i < cc->cluster_size; i++)
> -		if (cc->rpages[i]) {
> -			set_page_dirty(cc->rpages[i]);
> -			set_page_private_gcing(cc->rpages[i]);
> -		}
> +	for (i = 0; i < cc->cluster_size; i++) {
> +		struct folio *folio;
> +
> +		if (!cc->rpages[i])
> +			continue;
> +		folio = page_folio(cc->rpages[i]);
> +		folio_mark_dirty(folio);
> +		folio_set_f2fs_gcing(folio);
> +	}
>  }
>  
>  static int prepare_compress_overwrite(struct compress_ctx *cc,
> @@ -1477,8 +1483,9 @@ void f2fs_compress_write_end_io(struct bio *bio, struct folio *folio)
>  
>  	for (i = 0; i < cic->nr_rpages; i++) {
>  		WARN_ON(!cic->rpages[i]);
> -		clear_page_private_gcing(cic->rpages[i]);
> -		end_page_writeback(cic->rpages[i]);
> +		folio = page_folio(cic->rpages[i]);
> +		folio_clear_f2fs_gcing(folio);
> +		folio_end_writeback(folio);
>  	}
>  
>  	page_array_free(sbi, cic->rpages, cic->nr_rpages);
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index 9940a6cecf1a2..0cfba8742d4b4 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -2707,13 +2707,6 @@ static inline void folio_set_f2fs_##name(struct folio *folio)		\
>  		v |= (unsigned long)folio->private;			\
>  		folio->private = (void *)v;				\
>  	}								\
> -}									\
> -static inline void set_page_private_##name(struct page *page) \
> -{ \
> -	if (!PagePrivate(page)) \
> -		attach_page_private(page, (void *)0); \
> -	set_bit(PAGE_PRIVATE_NOT_POINTER, &page_private(page)); \
> -	set_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
>  }
>  
>  #define PAGE_PRIVATE_CLEAR_FUNC(name, flagname) \
> @@ -2726,12 +2719,6 @@ static inline void folio_clear_f2fs_##name(struct folio *folio)		\
>  		folio_detach_private(folio);				\
>  	else								\
>  		folio->private = (void *)v;				\
> -}									\
> -static inline void clear_page_private_##name(struct page *page) \
> -{ \
> -	clear_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
> -	if (page_private(page) == BIT(PAGE_PRIVATE_NOT_POINTER)) \
> -		detach_page_private(page); \
>  }
>  
>  PAGE_PRIVATE_GET_FUNC(nonpointer, NOT_POINTER);


