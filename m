Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 298DECD8CAA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 11:45:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 612D56B008C; Tue,  9 Jun 2026 07:45:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C3806B0093; Tue,  9 Jun 2026 07:45:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D94F6B0095; Tue,  9 Jun 2026 07:45:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 40F946B008C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:45:51 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DF7AFA051B
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:45:50 +0000 (UTC)
X-FDA: 84860194860.12.9D57118
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3AC4314000A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:45:47 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf09.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781005548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wy/O/CmD6ITOl+dRSnC9ZTVcfd+SeJmYk+gaXEE7Pig=;
	b=3e5mXrNYIs+JNvJ+8fRAFmlQy7BH5sipAAIApSbHsxpaqAAUrfRh1ynyrt3JZt2rtN6KUR
	T7CHQ+uO+zsdnT0gPNliEi6QWHxQGeaOgmoaM6C5KdoB+gkvzTRPxSfmkD6iw43bU+lGFJ
	qSOanXvj3FJ6/kVv9qd7FfqnB3jJMEk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf09.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781005548;
	b=cR0JHHBNbq54u/uzKcDBlnMFFGdAZ1UWUrJoK6ItQ0hVvsipq0H6MQMiVkSfMZdsh8+bO2
	VBKvAk4Xfsag+Af8Czdct9+A8YJCyiSK2FkIk4ukpsDHO5a/o/0aJ5rFNbiqJOazY1dKWs
	/pRhLtcR6K1HJmuD0aHKyBUWdDoawXA=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gZRtb5vbrz5BNS0;
	Tue, 09 Jun 2026 19:45:43 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl2.zte.com.cn with SMTP id 659BjZf5073737;
	Tue, 9 Jun 2026 19:45:35 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Tue, 9 Jun 2026 19:45:38 +0800 (CST)
X-Zmail-TransId: 2afb6a27fce220e-80deb
X-Mailer: Zmail v1.0
Message-ID: <20260609194538282g8AslmvWYEhkh-XMw80x_@zte.com.cn>
In-Reply-To: <84886648-8cbb-49db-a816-de3e0d359ed0@kernel.org>
References: 20260609124031750t-yHeQFCJs4gAeOmsvEJx@zte.com.cn,84886648-8cbb-49db-a816-de3e0d359ed0@kernel.org
Date: Tue, 9 Jun 2026 19:45:38 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <david@kernel.org>
Cc: <akpm@linux-foundation.org>, <chengming.zhou@linux.dev>,
        <hughd@google.com>, <wang.yaxin@zte.com.cn>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <ljs@kernel.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2OCAxLzNdIGtzbTogYWRkIGxpbmVhcl9wYWdlX2luZGV4IGludG8ga3NtX3JtYXBfaXRlbQ==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 659BjZf5073737
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Tue, 09 Jun 2026 19:45:43 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A27FCE7.000/4gZRtb5vbrz5BNS0
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3AC4314000A
X-Stat-Signature: dsz1817534oug68o8mumcgdngt8affjr
X-Rspam-User: 
X-HE-Tag: 1781005547-419605
X-HE-Meta: U2FsdGVkX1/2wPWh6ZHwdnc0nIkCHYjf1VXJE5SvZKh89JVWTIve5VaPeFoMteO7QXVxtIlt+3Uk0kcw/pvBLGRmwelkbwQs82Hm6UYt4xxnC6IdUeMgidAjIgriTjY9xBh4hACRG06IBi+I2FFaVfzrc6mdBxo9USwAWNs3Km5yznb4i3+RzCuyWyP/M6l2fq5TU0iiXT7oedf9xfGuNkN8k/GB1J9CX0Xj+9Onmb8Ya47YBpAtmYBAMOPVph4H5v0TP1YL3EZfIH68UqLe/eJPweWp/K5IdcXVr49qN+ie/7UNFkH3oS8Ywwke/inc3ZQAFmi7ROLKDtq25Q/GJprhZyy7KAP+lfp86quTGAEuWBnw03spymYnxcfMG9OAWQGXxfouAAgK9l7f9Lpq9Rhkxwj4q7gEZmC8j56/Od6Yi1CIIduXxDgfXQHQl5qJKgKGNVVeI6pa/TYEUZe3UXxx/oQ7YIgldI5V00fRRRTby590Thum3N+rXA6AoCxtxPAj8dh0nu0SRAhLbEBIDBAHnglUVcC/DFFg+sjtm2Sq47zOkRLV+IUhS/EciaJylGf066c7xm8G0yDBJ1TCFY9SXT0/uTkrzuWa06vyhiICqkbwn/EnpeuVnsp0M50822wgV8bVsO17zzNVE0QrBQipkq6oUHYpCxK1FGnnRjNe7tw9YRL4/7PHgWOEkJKQGWLyW7cPzibJpEZTz4j9IPRFz1hyucoGq7TmP3TvMlaL8zuIjF9EG0QuYkaz+OTDEnRbcDk5lfQ92j6Klq5A5ORPv0HAMGJ6irWkIJK2XXutV+AN6lW3wfj5vz+LYm2fGQeAp9UsvBL9qXGMffDUBF7/ggFGrCRVc+IUeBMKl2lFmWaks4HehZNE/HlpiPjFAH2/DZQed2TeS6F4W6bnNPeDDG4BxNIypWcCK4gtKuwhzw5whW1VQDkgHucNm6hHNkTHojujZOK7u5mR4iE
 /+zP73o+
 dd25UE4UsdW0ZYloLXQFXztXXCla/j9MwsWaoU1CQt2j3ND/vKDbVgzU41ArZ/VRUpcfTunxsDcfvbzXL4FWidK2EQqiy5mTcQDZI5dvqc5MnEtze+GlqIa1wzZ1eb0jhmewoG8UUznVtjh4wX5eowPTyovz8FQfgGCuF8Z0GWy2HTIvJ7JyNYAIdz31qkylUAGsCEfv/gEfhOK4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> +/*
>> + * break_cow: actively break COW, replacing the KSM page by a fresh anonymous
>> + * page. This is called when rmap_item has not yet become stable, but page
>> + * has been merged.
>> + */
>>  static void break_cow(struct ksm_rmap_item *rmap_item)
>>  {
>>  	struct mm_struct *mm = rmap_item->mm;
>> @@ -787,6 +798,11 @@ static void break_cow(struct ksm_rmap_item *rmap_item)
>>  	 * to undo, we also need to drop a reference to the anon_vma.
>>  	 */
>>  	put_anon_vma(rmap_item->anon_vma);
>> +	/*
>> +	 * Reset linear_page_index that might overlay age-related
>> +	 * information. (it's still unstable node)
>> +	 */
>> +	rmap_item->linear_page_index = 0;
>
>Sashiko comments that, on 32bit, it is not overlaying age-related information.
>So setting it to 0 won't clear the age.
>
>Which is what we document with the "might".
>
>On 32bit, it simply behaves the way it was before (no reset of age-related
>information here).
>
>We could move oldchecksum below remaining_skips to clear age-related information
>consistently. Not sure whether that is really worth it.

Yes, On 32-bit systems, although we do not clean the age, we also did not overwrite it.
So the behavior is the same as it used to be.

>> @@ -1598,8 +1618,16 @@ static int try_to_merge_with_ksm_page(struct ksm_rmap_item *rmap_item,
>>  	/* Unstable nid is in union with stable anon_vma: remove first */
>>  	remove_rmap_item_from_tree(rmap_item);
>> 
>> -	/* Must get reference to anon_vma while still holding mmap_lock */
>> +	/*
>> +	 * Must get reference to anon_vma while still holding mmap_lock.
>
>I think this sentence should go, and instead ...
>
>> +	 * Must can only reference the VMA while still holding the mmap
>
>This one should become:
>
>"We can consider the VMA only while still holding the mmap lock, so ...

Oh, my bad. I'll correct it right away.

> +	 * lock, so reference the anon_vma and calculate the linear page
> +	 * index early, before stable_tree_append(). If anything goes
> +	 * wrong that prevents the rmap_item from being added to the
> +	 * stable_tree, break_cow() will clean it up.
> +	 */
>  	rmap_item->anon_vma = vma->anon_vma;
> +	rmap_item->linear_page_index = linear_page_index(vma, rmap_item->address);
>  	get_anon_vma(vma->anon_vma);
>  out:
>  	mmap_read_unlock(mm);
> @@ -2458,6 +2486,13 @@ static bool should_skip_rmap_item(struct folio *folio,
>  	if (folio_test_ksm(folio))
>  		return false;

> Thinking about the overlay once more, I'm trying to assess what it means when we
> clear rmap_item->checksum. We'd do that now in:
> 
> (a) remove_node_from_stable_tree(): We had a stable node -> KSM page, but
> something changed.
> 
> (b) remove_rmap_item_from_tree(): Same as (a)
> 
> (c) break_cow(): we have to unshare, either because insertion into the stable
>     tree failed, or because we would have only a single PTE mapping the KSM
>     folio after a failed merge.
> 
> For (c), I guess if we'd have to, we could remember the checksum while
> processing the rmap_item.
> 
> Clearing rmap_item->checksum implies that cmp_and_merge_page() would refuse to
> merge one round.
> 
> Having rmap_item->checksum cleared is just like allocating a fresh rmap_item. So
> it will fix itself up during the next scan.
> 
> So my best guess is that this is alright.

You've thought this through carefully. For case c, clearing rmap_item->checksum will
indeed cause cmp_and_merge_page to reject the first merge. The original intent of
rejecting the merge is because the page changes too frequently (somewhat similar to
LRU), and this rationale still hold. Making this page scanned in your case (c) one
more time is acceptable.

