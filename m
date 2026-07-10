Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3971FC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 12:17:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A5336B0096; Fri, 10 Jul 2026 08:17:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47BC26B0098; Fri, 10 Jul 2026 08:17:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B9E86B0099; Fri, 10 Jul 2026 08:17:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1CD976B0096
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 08:17:57 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 972FC1C8A68
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:17:56 +0000 (UTC)
X-FDA: 84972768552.14.33F9F69
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id D6B4740002
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:17:54 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F4pKQcW3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783685874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dmff57dHcT58UCIjXdH2a5/WJB4WAYVK22MUrbSXs3c=;
	b=z5C4Ao/gPTx+QKdo7IDrDK5aKECjprDfBXhBnBNMLjnrZEJLsVSdM4VHGT+8Ha0V+mUKyq
	tiHSBXRDmMqWkOIjMxu/0FIerlrHO8Lakz3X9hzMCBAY9mHHkrbnx1GChB+znKJhOPMoC+
	tRbVN0IAtlXyNTFgBmO5hOoiwm0CnmI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F4pKQcW3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783685874;
	b=GsLkMMh3A2YjS/lZIGuG0N+MPAbCNJix4A0UXpu+dsIQajrwkKQGbueXkwgkd15Dm75prF
	r1Q1aQ/VCxlEWH45XMuoY/X9Q8+/JrpKrLqe5nbpFEBvF8mpwzZ6xoqhK9kKm5/VlfXNqQ
	mOPuQeLn0aCMPRRjn5cM09qaGsYuUxU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 769A7601D9;
	Fri, 10 Jul 2026 12:17:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA40C1F000E9;
	Fri, 10 Jul 2026 12:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783685874;
	bh=Dmff57dHcT58UCIjXdH2a5/WJB4WAYVK22MUrbSXs3c=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=F4pKQcW3xjEG+bbSXHpXiDmXYYN65DFMjfjoLm+hl8JAVVW1t3MgNVueM28Me0iWZ
	 ZzxugY+JYrwDUKswEy8IIWfv4JrT2adCAHvw+MsVgVLYfQm/FoXN3Ymk3X1CvpDHTy
	 HLh9YIopbOpkiCUylua3cdzGRR+EIaSqD4qkZyHH4BGW8cVuqMFTiBOfG2NTtJeYB3
	 v2ECfm/t28BXhD4GV4BqNQs6dn/1kEsWvoo+9fmB5arG+Zq6wwCSe1gW+vB87GWJKV
	 NkMgkrilo+jFL7HS53lzqvRxQW1JXdxg1Sfz+roNYILFQeRJcm7TRBa2GSdHH7th5O
	 CKQVoPajEHggw==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] mm/mm_slot.h: add a helper function mm_slot_remove
From: Lorenzo Stoakes <ljs@kernel.org>
To: xu.xin16@zte.com.cn
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, baohua@kernel.org, 
 lance.yang@linux.dev, usama.arif@linux.dev, chengming.zhou@linux.dev, 
 qi.zheng@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
 wang.yaxin@zte.com.cn
In-Reply-To: <20260710131536564mY9CDv7aP2dKPiLFXbrBv@zte.com.cn>
References: <20260710131536564mY9CDv7aP2dKPiLFXbrBv@zte.com.cn>
Date: Fri, 10 Jul 2026 13:17:37 +0100
Message-Id: <178368585772.363984.12871786869575753171.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2072; i=ljs@kernel.org;
 h=from:subject:message-id; bh=o+mJDSD6iU6VAb3AkbMu/ilGQwuquDuOSiqihnopqcM=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLICHj0Rs9lfE/Q+WelOLqcv396gGy7e7X/CTU3YZj5bu
 UYnNn9CRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACaykY3hn1m8l3LPY67ru6dE
 /2FXO8nU8U33V+PGXW+1Y1YsmnFYfz/D/wru5V8t3s/5r/36/h3Ozy+CuCrVWZyyz1r9u2xbsdP
 /EwcA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D6B4740002
X-Stat-Signature: m8gduxngpj5arm5rw5s3bajrtrj3maer
X-Rspam-User: 
X-HE-Tag: 1783685874-134856
X-HE-Meta: U2FsdGVkX19N6/D5iT1UZdac1QDqjRh3sTGmMwFJG675NXurxO4oeI6Er8mT4b0pQffFyByY5IyT6gZSwixfEZsIscLXC1h/N8SzcuxgMCgP/9jFD6PlG85Gna3S4rHAq/Wd8DnE83Rh03KShDAysXVEKFA8btbnzI8++HJEZahP+iKO6RXXoKcz34bBUnkZVmwLmTrYspJLGU3ffczbxG6kdi3VgJBydG6IgMN9z51CEZi2XFMfKi8kOQqieluC7RrcesUiP5T+NBX786hiM2VtsR+lY8S5bpgbmjM/9NAvqU7T1EMJ5U3VgF80tC60ayvs3pgsL2uEk6kYmHOdVT6DZbNiWJuQpwFHvf0ZoRPi6s+ZL6U/ew82Vd8418yauItHYSKe2BuMSVgpPIjwskUbHc1irZEwAvxSvOOyysv2+2/Zj7/kQnF3HPe28KRfPkAWnH9/1Q7DSH2OwdMtx8ltDJmNTcPuImYmb/+QcIsZEPlz7KcoqwOf8KyIFtcu005+VrKBhYuauey9J7DNIjZgTC2Wigjog7hZyAqQpwla1hG5Y6zgw+kxwsk4m4FHSPtQHQETXZud9SUSHu+FVNyiYR2xzThIZXtc8lL/VYfFoUUwexTKCouTg0aZbeVDcQVmjKHFwIW+Noqj1glAWWS2q6+S8+6LCSNfX2rcRfjb1Nzs00Nt5WZV2eHt9du8Rr2v6S90X9E+4qOQ9d8MoUqEiHqPEaXy8Yqt/EOUmjw0OQltsfAL4ytkmjPAkM88rw0YoOlJwa47Ah93T4xsXxB8hUh0yu0W1okiXruYk8+7NYSaXB054Y+Ozd860CX5j0AqP5CXaWsayVoVcyV9/0JT7dsfgmwRxEIjQGirsO1iKaCdkPlzR5GQAZHfgDFhejX8KkDHz0x/m3X3byvtmj4oAtS7vWDjPT8R+LAcVnswQ03wFDgpqk7oCEupVa0MP4249Q5JT1pzN3mOseT
 0p9U3m93
 08G+UaFFSkbHAVuCpxlv7gaP6ohT65D+g1lnvyIISMO5zJC9Dh/OY1Y1Ea5FUptVnsWWnav9uBMUfrqQFh2niyqypNKZ9jaZcEzlL12OYWLHQeWx3YCcZ54cVt5Q9DkAQQdxEU+SDmr/MxQ4H+22riU9Hrx6cbLt08GRNv4jyD/eJ+B0G1rMMA3S2eEYts0tGhmjct/UrSiwwDSGldYrEdzOctddi2C9lrkgczph8ot5dIk4/0w0nidrwTNolCE1HmMyfSQaYVeVA5Mg7cSl5/2nPh+V86dav8gtMJoQPKwEhEq+FQZYnDHlAKoZ20khCDPz/0Gfj9B0vVQO8K+7nBdgV2iiK6zmIK8HVO8kDq7BnK1HCBzNgTkXsGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Jul 2026 13:15:36 +0800, xu.xin16@zte.com.cn <xu.xin16@zte.com.cn> wrote:
> Both khugepaged (THP collapsing) and KSM manage per-mm scanning slots
> using the mm_slot structure. The slot is kept in a hash table and a
> list, and removal from both containers requires the same two operations:
> hash_del() and list_del().
> 
> Currently, this two‑step removal is open‑coded in multiple places

Let's not have em-dots in the commit message ;)

> across khugepaged.c and ksm.c. This duplication makes the code slightly
> harder to read and maintain, and creates the risk that future changes to
> the removal logic might miss one of the call sites.
> 
> Introduce a helper function mm_slot_remove() that encapsulates both
> deletions. This reduces redundancy, improves code clarity, and ensures
> that the removal sequence stays consistent.

You're talking far too much about a trivial change, just say something like
'this patch introduces mm_remove() to abstract this'.

> 
> No functional change is intended.
> 
> Signed-off-by: xu xin <xu.xin16@zte.com.cn>

In general it's fine but I want more :) see below.

>
>
> diff --git a/mm/mm_slot.h b/mm/mm_slot.h
> index 83f18ed1c4bd..bc3b9ae8fdbc 100644
> --- a/mm/mm_slot.h
> +++ b/mm/mm_slot.h
> @@ -52,4 +52,11 @@ static inline void mm_slot_free(struct kmem_cache *cache, void *objp)
>  	hash_add(_hashtable, &_mm_slot->hash, (unsigned long)_mm);	       \
>  })
>  

mm_slot.h also inexplicably implements mm_slot_lookup() and mm_slot_insert() as
macros. Can you change these to static inline functions in the respin?

Also rename the horrible names from _foo -> foo too please.

And we don't really need 'mm_slot' in the var name for a slot just 'slot' works
fine.

> +static inline void mm_slot_remove(struct mm_slot *_mm_slot)

Yeah this name is gross just 'slot' please.

> +{
> +	hash_del(&_mm_slot->hash);
> +	list_del(&_mm_slot->mm_node);
> +}
> +
> +
>  #endif /* _LINUX_MM_SLOT_H */

Thanks, Lorenzo

-- 
Lorenzo Stoakes <ljs@kernel.org>

