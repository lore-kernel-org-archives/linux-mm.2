Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33D49F532F1
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 08:22:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 760C06B0005; Tue, 24 Mar 2026 04:22:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 711AA6B0088; Tue, 24 Mar 2026 04:22:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 627B46B0089; Tue, 24 Mar 2026 04:22:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 51F1C6B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 04:22:47 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ECF9E1417CF
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:22:46 +0000 (UTC)
X-FDA: 84580265532.23.ACCDA57
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf11.hostedemail.com (Postfix) with ESMTP id 578BC4000C
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:22:43 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=IqBvEXtT;
	spf=pass (imf11.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774340565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nBJkqxYu+t3pfuHu+5NDgnAbi4EbO8D0s9eWWjl7kao=;
	b=lie188/ryF21I+q4MGQ/ZAMnSs9OOw/MBSt4zfjksWUpe6dbqgyPq+C/VmX+9iU6Vy2tLR
	AoQEorjVCWIuuNfgHlZ0nKsvKk/cEVDD0wNXvZvE/Pis9X1H1KhpS9p5FH3QD1WeSqtLRr
	mfKtmbuXx4FUIS/ac0hamrGnwoWXu1Q=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=IqBvEXtT;
	spf=pass (imf11.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774340565; a=rsa-sha256;
	cv=none;
	b=MBI9kHlr2kpjTy7fNrOYqLfWj8HLMxe3Q+SLnNBxuwSy96R9wAHYw0A0iWbdwpYzGAsOQX
	/fHMnX4c4U4+JBc7uUYabErgoM+5EoCtIEPqSgTXzvSFddhIz6qO7RKK/lLC+pg1lwg8pQ
	SUKWkD3s9ndenoH+zgpsMtKbFai4ua4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774340559; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=nBJkqxYu+t3pfuHu+5NDgnAbi4EbO8D0s9eWWjl7kao=;
	b=IqBvEXtTeU3G/jTtFNpJm+0z6HU6Dkbbqn9YUB35P5s9Si6a+t0P2pilpEHfgxxgIdtRVJzCD+VyIbpbGd/YYIw9iup0KjImb1qH6qdauUvC9sg5W6HRv5ZRfyhpmyuIdwdKnEMDuxV/KYG5fXBQEGTiVAsD6Qicr74M6W7/P4Y=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R411e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=39;SR=0;TI=SMTPD_---0X.dt9XJ_1774340555;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X.dt9XJ_1774340555 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 24 Mar 2026 16:22:37 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Shivank Garg <shivankg@amd.com>
Cc: <akpm@linux-foundation.org>,  <david@kernel.org>,
  <lorenzo.stoakes@oracle.com>,  <Liam.Howlett@oracle.com>,
  <vbabka@kernel.org>,  <willy@infradead.org>,  <rppt@kernel.org>,
  <surenb@google.com>,  <mhocko@suse.com>,  <ziy@nvidia.com>,
  <matthew.brost@intel.com>,  <joshua.hahnjy@gmail.com>,
  <rakie.kim@sk.com>,  <byungchul@sk.com>,  <gourry@gourry.net>,
  <apopple@nvidia.com>,  <dave@stgolabs.net>,
  <Jonathan.Cameron@huawei.com>,  <rkodsara@amd.com>,  <vkoul@kernel.org>,
  <bharata@amd.com>,  <sj@kernel.org>,  <weixugc@google.com>,
  <dan.j.williams@intel.com>,  <rientjes@google.com>,
  <xuezhengchu@huawei.com>,  <yiannis@zptcorp.com>,
  <dave.hansen@intel.com>,  <hannes@cmpxchg.org>,  <jhubbard@nvidia.com>,
  <peterx@redhat.com>,  <riel@surriel.com>,  <shakeel.butt@linux.dev>,
  <stalexan@redhat.com>,  <tj@kernel.org>,  <nifan.cxl@gmail.com>,
  <linux-kernel@vger.kernel.org>,  <linux-mm@kvack.org>
Subject: Re: [RFC PATCH v4 2/6] mm/migrate: skip data copy for
 already-copied folios
In-Reply-To: <20260309120725.308854-8-shivankg@amd.com> (Shivank Garg's
	message of "Mon, 9 Mar 2026 12:07:25 +0000")
References: <20260309120725.308854-3-shivankg@amd.com>
	<20260309120725.308854-8-shivankg@amd.com>
Date: Tue, 24 Mar 2026 16:22:35 +0800
Message-ID: <87wlz1zlf8.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 578BC4000C
X-Stat-Signature: 73kyh96ox5fhgkz8rqeu1ge3mmuetcbh
X-Rspam-User: 
X-HE-Tag: 1774340563-171905
X-HE-Meta: U2FsdGVkX1+ykBe/YAseIDGDnpBrimeEDma3bi3b7Vm2oCKNEsKF+k5ACawYrnrpQqOJzUCJhVTlEG0xgRnTqpsXk4CEIpb7hJ8TA9/HdjGnsHvj2BqXBxm4mube+NfwXlS6KfVZTiChwmniWkQkXKjKxiyt9GU/gZi/n4x4oXvma4VsjQi3HJZ91rkojfFfnXI0gupgG77hOPNhQHk2L6F2zSv3FBR0mSMCFN/G/tJC4fNKDq6HtZdicmAT9BkfpP51iZIq7NdanJZxyGsafL/WUH0rZCexdb/snNI0EtonLJrxjooeUX8JczCcIyEukTCwRJoc1Wxkvuiojv9LvgL7cwO+vR9ITRu2uZX8BxWjUive+YdHQovlafWHJez7t8lcsRD2tUQgmwL+CzUL3ytNj7US3UrspefwRvoyfcFREoEwwMYFEpkH25SNMFX0CtUQag/2GTrSFXJ1CCVOQnZ5660/W8HTDv1ltD5ruZy89nPyWjrbd+Y93ZTWV3G2Wh18eDu8FJtlH0BnOFscUNg4n9qIbByofiHX4VU+AJFzWu0PjfKrI7Xz97Mstq4oFBt+JyHO7Fxa/FFrqeQ03toeBhEfjzcBuMY2VhBS1cPLe+hoPwPKggh8rnaZWQfsiM/anxBxVhWSoZbE+mrDn2ylJxlVW+PDKpinboGA6icHVHA4IYHrdLtU88aKgre16ySeGppxWrjHRbGIy9wEUuMz3RE+U9VjHhstTPAJXV+Hvg+PZ6YmR3KMkGWncVrxAOgZmHYxL759PPLair19CnncDq5rNkPmnZWgRR/NpHYWJv8gR/+h1KMSuDj9gXTQai0YyyXahMSJXkN0gkKCqYeRjU6qKDq5mIaVyJsuwazeMhRoYtV3zhpK2oahdeO1lOCXJlu8t+f1cMM5CyIoYEiaLKnMVlEXWshP63FnMqcVB5GMsD/EF0ttgxViakCk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Shivank Garg <shivankg@amd.com> writes:

> Add a PAGE_ALREADY_COPIED flag to the dst->private migration state.
> When set, __migrate_folio() skips folio_mc_copy() and performs
> metadata-only migration. All callers currently pass
> already_copied=false. The batch-copy path enables it in a later patch.
>
> Move the dst->private state enum earlier in the file so
> __migrate_folio() and move_to_new_folio() can see PAGE_ALREADY_COPIED.
>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
>  mm/migrate.c | 52 +++++++++++++++++++++++++++++++---------------------
>  1 file changed, 31 insertions(+), 21 deletions(-)
>
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 1bf2cf8c44dd..1d8c1fb627c9 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -848,6 +848,18 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
>  }
>  EXPORT_SYMBOL(folio_migrate_flags);
>  
> +/*
> + * To record some information during migration, we use unused private
> + * field of struct folio of the newly allocated destination folio.
> + * This is safe because nobody is using it except us.
> + */
> +enum {
> +	PAGE_WAS_MAPPED = BIT(0),
> +	PAGE_WAS_MLOCKED = BIT(1),
> +	PAGE_ALREADY_COPIED = BIT(2),
> +	PAGE_OLD_STATES = PAGE_WAS_MAPPED | PAGE_WAS_MLOCKED | PAGE_ALREADY_COPIED,
> +};
> +
>  /************************************************************
>   *                    Migration functions
>   ***********************************************************/
> @@ -857,14 +869,20 @@ static int __migrate_folio(struct address_space *mapping, struct folio *dst,
>  			   enum migrate_mode mode)
>  {
>  	int rc, expected_count = folio_expected_ref_count(src) + 1;
> +	bool already_copied = ((unsigned long)dst->private & PAGE_ALREADY_COPIED);
> +
> +	if (already_copied)
> +		dst->private = NULL;
>  
>  	/* Check whether src does not have extra refs before we do more work */
>  	if (folio_ref_count(src) != expected_count)
>  		return -EAGAIN;
>  
> -	rc = folio_mc_copy(dst, src);
> -	if (unlikely(rc))
> -		return rc;
> +	if (!already_copied) {
> +		rc = folio_mc_copy(dst, src);
> +		if (unlikely(rc))
> +			return rc;
> +	}
>  
>  	rc = __folio_migrate_mapping(mapping, dst, src, expected_count);
>  	if (rc)
> @@ -1088,7 +1106,7 @@ static int fallback_migrate_folio(struct address_space *mapping,
>   *     0 - success
>   */
>  static int move_to_new_folio(struct folio *dst, struct folio *src,
> -				enum migrate_mode mode)
> +		enum migrate_mode mode, bool already_copied)
>  {
>  	struct address_space *mapping = folio_mapping(src);
>  	int rc = -EAGAIN;
> @@ -1096,6 +1114,9 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
>  	VM_BUG_ON_FOLIO(!folio_test_locked(src), src);
>  	VM_BUG_ON_FOLIO(!folio_test_locked(dst), dst);
>  
> +	if (already_copied)
> +		dst->private = (void *)(unsigned long)PAGE_ALREADY_COPIED;
> +

IMHO, this appears to be an unusual way to pass arguments to a function.
Why not adjust the parameters of migrate_folio()?  How about turning enum
migrate_mode into a bitmask (migrate_flags)?

>  	if (!mapping)
>  		rc = migrate_folio(mapping, dst, src, mode);
>  	else if (mapping_inaccessible(mapping))
> @@ -1127,17 +1148,6 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
>  	return rc;
>  }
>  
> -/*
> - * To record some information during migration, we use unused private
> - * field of struct folio of the newly allocated destination folio.
> - * This is safe because nobody is using it except us.
> - */
> -enum {
> -	PAGE_WAS_MAPPED = BIT(0),
> -	PAGE_WAS_MLOCKED = BIT(1),
> -	PAGE_OLD_STATES = PAGE_WAS_MAPPED | PAGE_WAS_MLOCKED,
> -};
> -
>  static void __migrate_folio_record(struct folio *dst,
>  				   int old_page_state,
>  				   struct anon_vma *anon_vma)
> @@ -1353,7 +1363,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
>  static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
>  			      struct folio *src, struct folio *dst,
>  			      enum migrate_mode mode, enum migrate_reason reason,
> -			      struct list_head *ret)
> +			      struct list_head *ret, bool already_copied)
>  {
>  	int rc;
>  	int old_page_state = 0;
> @@ -1371,7 +1381,7 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
>  		goto out_unlock_both;
>  	}
>  
> -	rc = move_to_new_folio(dst, src, mode);
> +	rc = move_to_new_folio(dst, src, mode, already_copied);
>  	if (rc)
>  		goto out;
>  
> @@ -1519,7 +1529,7 @@ static int unmap_and_move_huge_page(new_folio_t get_new_folio,
>  	}
>  
>  	if (!folio_mapped(src))
> -		rc = move_to_new_folio(dst, src, mode);
> +		rc = move_to_new_folio(dst, src, mode, false);
>  
>  	if (page_was_mapped)
>  		remove_migration_ptes(src, !rc ? dst : src, ttu);
> @@ -1703,7 +1713,7 @@ static void migrate_folios_move(struct list_head *src_folios,
>  		struct list_head *ret_folios,
>  		struct migrate_pages_stats *stats,
>  		int *retry, int *thp_retry, int *nr_failed,
> -		int *nr_retry_pages)
> +		int *nr_retry_pages, bool already_copied)
>  {
>  	struct folio *folio, *folio2, *dst, *dst2;
>  	bool is_thp;
> @@ -1720,7 +1730,7 @@ static void migrate_folios_move(struct list_head *src_folios,
>  
>  		rc = migrate_folio_move(put_new_folio, private,
>  				folio, dst, mode,
> -				reason, ret_folios);
> +				reason, ret_folios, already_copied);
>  		/*
>  		 * The rules are:
>  		 *	0: folio will be freed
> @@ -1977,7 +1987,7 @@ static int migrate_pages_batch(struct list_head *from,
>  		migrate_folios_move(&unmap_folios, &dst_folios,
>  				put_new_folio, private, mode, reason,
>  				ret_folios, stats, &retry, &thp_retry,
> -				&nr_failed, &nr_retry_pages);
> +				&nr_failed, &nr_retry_pages, false);
>  	}
>  	nr_failed += retry;
>  	stats->nr_thp_failed += thp_retry;

---
Best Regards,
Huang, Ying

