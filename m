Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8252BC79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 20:25:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 633126B008A; Wed,  9 Sep 2026 16:25:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BD286B008C; Wed,  9 Sep 2026 16:25:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45E0B6B0092; Wed,  9 Sep 2026 16:25:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 171726B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:25:14 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 85A681A0341
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 20:25:13 +0000 (UTC)
X-FDA: 85195353306.04.7014F4A
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6F8C440004
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 20:25:11 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="lb7P5/15";
	spf=pass (imf07.hostedemail.com: domain of ackerleytng@google.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788985511;
	b=iv/uvbTArT1hrxtzRTBXPi/KjcHuCFVMOhYupOuGSbahIbudw1nN2K8hGzKbPkmLtiYp41
	5SxLWks6TXiJpp0z4c24ZB03iD6gjPFOYoH/Vk8JhR5q550iR4HYGYQNdZjkeHqXK1tTNu
	6LI4GDYTiPzCqJezwHe6JImY+88jJmM=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="lb7P5/15";
	spf=pass (imf07.hostedemail.com: domain of ackerleytng@google.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788985511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sAJgjokaArCH/jUJWMU61BMeLKssOx+oevwPJuJSlB4=;
	b=mcc0nmr6Z754znUdHKDZIKeReE25Xkov4wF1EjEhf4IsI5igim0Owj7u0njwg2Vn++9kR0
	yjLJoxZOGFF8oi95yUxWoD7p1EcQPvz1/QQXDxCWJgAx0XnraO2FZRDNHoYXB/ZBZlPbDK
	2+1yrc1zPiP/CFJDaIb5MBqzH5ith6c=
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-90e7bde5596so80326326d6.1
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 13:25:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788985510; cv=none;
        d=google.com; s=arc-20260327;
        b=DTOAVoQldjenYJFa57wnlKOQt24cTnxn0Ynz+OuGifJIZBLzmR+9GGkN98uGqYMd0b
         421SpWnqPImdCZOJ6lII1Kg0wsVRNMjUtplk7ZvsjHihv4lgy3Ec7Yd6FToIXBBLoUn2
         HdcW6hrS5QhMo8JpNzi54DfqIpAz+tDU4aGnr6Zuonp7950//Lscf+g4oA03dRPjgFRY
         lbgCPWW/WStnho8raawRRqCngqGTGU0fogV9xODmz93FhnzWo+z1QF0BVvcCQzd4Uy4l
         b08qG081uJtZdXbQKkBDcCLH4DwywnHXQrq4hj/bX0EIsQhZ6wJDc1U0OVWPTxWQYw22
         Qa2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=sAJgjokaArCH/jUJWMU61BMeLKssOx+oevwPJuJSlB4=;
        fh=LcrpExzXqeEH/uRWKxtIiXMdttge+ZKcVi282pTTkYg=;
        b=VFU6zzDgZoYITRkpzqwXtP3qXlqr2upYVlIG4PWdcEjdzVwXTRauqBcog9HSegNY8R
         ay8kNtkoVCeYu+EOTnOTpc3q9Y9iqtr2Z36GUUzeNVV0mqKbNY0osOdGWkwe/aQQqDBK
         +uTSI5z1yoiY89XNr5W/Ae6qm4ZkuQxrq7tsXF23usl9E/G0ac6HX6kH0PvPUVkR4XXK
         wCmjcTVSZiP7NGLMsamTXcGDZaZCPOUfMeaYZ5l17hPxTH+nHsHGwyrZOhYGGqQHC7hk
         QEqyKei4EdulCLCiUwOTFfrLoJEpywdYJbzzuvH232QksEUST7ZTTjsGNt/7J1q970hl
         nvGg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788985510; x=1789590310; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sAJgjokaArCH/jUJWMU61BMeLKssOx+oevwPJuJSlB4=;
        b=lb7P5/156WV+zF/Upc8aCLiwUsdrsAAoKx2/+nALUpk7nli2i5UUr4YBJj9ZPWKRmI
         DUw2xFfU2LcTpItSHypNloV9Fl9oMSI9R/LvgVTfwsr5+OAOXVwYkIXI++1VD7WGspxd
         ERIwkKr6gY6iSMbLLGvGo3b/hOCwPYuZFlZ0jjf8usY55Z/dajdXIdNvuZN30QGsFqZI
         nhANQ4aO2NnmOccgMsCrGkcQkbkxtf8pmCh5Mib8HIX9YR23fU35dafPwGI8GJvj10kn
         ccvv2PRWvhkYnfzNZRpEdeXWW6Oun0hmJeguF/RF6UOaPh5zY0p5dYcvxsD9kjepjEMf
         hnwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788985510; x=1789590310;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sAJgjokaArCH/jUJWMU61BMeLKssOx+oevwPJuJSlB4=;
        b=NPzmlA8HHhr2GuaWsAceDGyL+ay51ObeA2kwRf1h7AFcrwp7JsbQaFkWTk8mADYJ6g
         t0c9fkKFP1dRUlcMSCO5gGJX1oJgXEveksuoEThnyWN7cMHaxLpR7VA2GtSrYRQIAlRD
         Tv+y5LHQPO5ZDpfsgc6sT/lNMw5aYinbK7ROz5JOV4Qr6qx2cMTWMDTpA+9KydpSNqpg
         DmVIm5IVsuMMkaRImvbknv4twa36WrlBLst+KndOmXxIRrNh+JVJ/hRqYZ7+KMBluMPv
         j4aGAY+1lH2gaE4gUM7+rmQhZyrtntwCgE1x4mI/EdVEkWyTx0pBHTx6zulvYi1KzKkj
         IvnQ==
X-Forwarded-Encrypted: i=1; AKwUvBxd7hu5bhtoOziaEBoMpmNHPOJXL0feKx/pLYnl+wNvcSmRABPYtAYXIRzOw3kdV9pS4aNH9roDag==@kvack.org
X-Gm-Message-State: AFuF++nmFGHRHjPn87J1f+ctDFnh6zVwbJ1xD2yd0r+VOsR730wxmNmb
	PzpR+/KDlQnPp8lRVnOPW5RcE6chXpjo2KaKl0uHYXZwyyYyPba6z8HEsM6y9UbGiwwf7Gz0q89
	MgFhOVRCZsuS1ZT0/ak5KseOmA2NnvyULioRqGaDs
X-Gm-Gg: AYBFou2R85fbRBW814UOnb6zYSXUHtKkRHN2raVx+H5HqhIsKyJqUN/TKCyqrFLZ1je
	C3X54UzlkBlPbnhPneFBejaqn9Qw9WU/5Gh5Z8SNqdA5lTm5rIk6PQmKjFGnheYylU7mNzjxnjW
	xha5C0wVnIP27BYl4gDO6PyK4zC1fLIy63VHn4a0xb/OF+i0W34PNu6+BTmchC/UyL38JX7E/RV
	9AH3Ee8//+5TKus+8NHHN6Oj/hZ7qHQ87PM2EuU2Yz6O62Q5JExTDzVieBFz7W7jJV3vPnZyKG/
	urnosLsLK2luTlurcUxJa7wpPaCWTUPJkfUuMkDOOFSyqIrO5dBV2UEAL5OCN6Wo9kDXmgxmLIS
	wK9d0BbNhs8JGoT1US6WfkuhHQcuEIoJbnF/MmQbf
X-Received: by 2002:a05:6214:2028:b0:910:70e1:e73e with SMTP id
 6a1803df08f44-91070e1e8eemr54547936d6.36.1788985508825; Wed, 09 Sep 2026
 13:25:08 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 9 Sep 2026 13:25:08 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 9 Sep 2026 13:25:07 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260902-hugetlb-subpool-always-track-used-v1-2-de1cd14bd713@google.com>
References: <20260902-hugetlb-subpool-always-track-used-v1-0-de1cd14bd713@google.com>
 <20260902-hugetlb-subpool-always-track-used-v1-2-de1cd14bd713@google.com>
MIME-Version: 1.0
Date: Wed, 9 Sep 2026 13:25:07 -0700
X-Gm-Features: AcwNN1WKF_ytLnZvmqYqok7fCFO9k5UkC6wmjaHMYmOMsaT-t0wpYlqa0Qxgl0M
Message-ID: <CAEvNRgGGW+D2GWwjUj5A_L69aeUaaWFn4vx6FE7Q5gkd278+nA@mail.gmail.com>
Subject: Re: [PATCH 2/3] mm: hugetlb: Fix out_put_pages subpool reserve calculation
To: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>, Alex Shi <alexs@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Dongliang Mu <dzm91@hust.edu.cn>, Hongxiang Lou <louhongxiang@huawei.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Shuah Khan <skhan@linuxfoundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Wupeng Ma <mawupeng1@huawei.com>, 
	Yanteng Si <si.yanteng@linux.dev>, fvdl@google.com, jthoughton@google.com, 
	rientjes@google.com, vannapurve@google.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6F8C440004
X-Rspam-User: 
X-Stat-Signature: a6r83yqq1m5u6pafg3zto34sbjmrosxo
X-HE-Tag: 1788985511-664124
X-HE-Meta: U2FsdGVkX1/CJRn/fvyarbpd5dzavSu3elusMNdG/GK7utHW5+DYsYALtNhzGl2YHOaFcUxzN7IM+IltHOc9G6WJNMsTKwg3ypLDOLBVQ/FZoWY3/O+UqxJwcwCN85Os5wKl9ryeqheZ2p2CZ7yWm62RnyNW707vei05rD7lUPkVIPQ0mLk4GKFWK+56k9TsarkA1zPVCBjhx81TMlNPCLs+B2tRRy8NyI/ef5ib4VofBYk5Z/j391AasKzqvBlokh74RMyXjHxfUeGVTY74P0iEo3u/oi7wePzsVedn5jVJyIi8OoroNjkapJ70bHLG88XdHc/MGjf4uwFkFQl2Un4EzlM+efFP7JwKxnFitBE3crnWmXrtIjnxk6rzylKxpXBRhJz/hfpQsx00OarUIbHWwWuvTw5rDCN3Q9zUstCSwJ4QOKsDMv6jCvuLKEc2YcmZjakLqwP//XaZ1nRjtR9vu0i/T+UWN5+uUeLK5QfnmT/mlEnu30QtZdO1CI2AXoeCvvTIF2zX87/DWrJlB11PhmWv4utT/3GKi54+2V+X7sPBarVLxaSguC/5Dgo9H6+r4/cyHeQKr3iJ0YWhEChgvxyzlBg6xZ599ucVVKp7bDw0owgaJwrGDqjtocMIYEzpr7G2xWpYYSO8XNI3LWz1GDB+CHwE9bhGrId1CHspzqtja7UuCMyuJOnI2KRPdmBFYAw8P3X8kwQb2i9pkzuEvaz4YN1XPZYxyNiQ+dC/IUKrrXlnvLD0YcqsRV0UPBOnrB15HfWzs8rabfKj0KdN41aaICOytxewsMgzvBXDmuTRJi5TwZ5lVBzC1miFaD0mxPqsyocK2IzL2xOmm0VpYBRf/4Bv9mErQAX3BCTg9nd6IQP8qATNuH6Jg5duBQKyHUEc8unmWocf55X4PUrPqdwMHP8qmRqudHksxmuoAN9uEUU99QaRk2skyvkGQjoJ6VrFDzohT2nGFx/
 iSlzoQ64
 YOPHKNyxxz1pYkSgnfYjSMQnFZrVD93aQhKGjNiL7h2nt04hwm4OEwMT6HWMSrCBY4dRzPqS/EAab5anAH0egVLgsH5iGro4HveELWWI25pPA1wx3p0QJ/hbaIO0eFactBbpFk2JkfTxIGw35cZJgLCZqDEnPiZFmVOaMuNZwVHcjK7LfzO/F4LoktFoQGlmGwRh2iDnHhXjkdjyRa7hgK0rRPPc8QHB+fNJOlLImfcEPO7YmjIJd5CM3ort2Fm1Ss79P+wvNn9hBlxSTQWBFNAE0b/3i/PH1cbYo+qA//jKIjux4WdzLUnEsANwFF17oXvnyiU/Ppmxa0t18yF60Ut555WGUBv4nRE3LqiVWjYbtUxuOU3T+BtwCipysESnyQ3VlfLLAPL/EnrQrmAcUkxgtbHr8TdRQ4rDGjyJUtOcSQnmzghLhG1vp2jc5N5NH1UwjGl0JIrDJwvWZy+nvgXYWMVGwsU81wfLWFroZzjxw2Ubm4E/MIooZU5i0r5uGYszo2px0z/BhvPVFWumReLZ1mw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
writes:

Copying Sashiko's comments here for discussion :)

> From: Ackerley Tng <ackerleytng@google.com>
>
> When reserving pages for a mapping fails during global accounting, the
> error path rolls back the adjustments made to the subpool.
>
> Currently, this rollback was performed in two separate steps:
>
> 1. Returning only the portion of reservations originally satisfied from the
>    subpool
> 2. Separately adjusting the subpool used pages counter for the portion that
>    was requested from the global pool.
>
> In (1.), because the used pages counter had not yet been decremented for
> the global portion, the subpool observed an inflated used pages count. If
> the mount was configured with both a minimum size and a maximum size, this
> inflated count prevented the subpool from recognizing that usage fell below
> the minimum size guarantee.
>
> As a result, the subpool failed to restore its reserved pages counter and
> instead returned that a global reservation should be dropped. The
> mount-time reservation is permanently destroyed, leaving global reservation
> counts depleted and causing an underflow when the filesystem is eventually
> unmounted.
>
> Additionally, if concurrent threads modified subpool usage during the
> reservation attempt, calculating the rollback amount using stale local
> variables could cause global reservation counts to diverge.
>
> Now that used pages are always tracked within the subpool, return the
> entire requested page count to the subpool in a single call. Global
> reservations are then adjusted using the difference between the
> reservations originally requested and those returned, fixing the issues
> described above.
>
> Fixes: 1d3f9bb4c8af ("mm/hugetlb: restore failed global reservations to subpool")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
>  mm/hugetlb.c | 49 +++++++++++++++++++++++--------------------------
>  1 file changed, 23 insertions(+), 26 deletions(-)
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 66b6601abb069..d84ef044d1346 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -6674,12 +6674,14 @@ long hugetlb_reserve_pages(struct inode *inode,
>  		struct vm_area_struct *vma,
>  		vma_flags_t vma_flags)
>  {
> -	long chg = -1, add = -1, spool_resv, gbl_resv;
> +	long chg = -1, add = -1;
>  	struct hstate *h = hstate_inode(inode);
>  	struct hugepage_subpool *spool = subpool_inode(inode);
>  	struct resv_map *resv_map;
>  	struct hugetlb_cgroup *h_cg = NULL;
> -	long gbl_reserve, regions_needed = 0;
> +	long regions_needed = 0;
> +	long gbl_resv_get;
> +	long gbl_resv_put;
>  	int err;
>
>  	/* This should never happen */
> @@ -6754,9 +6756,9 @@ long hugetlb_reserve_pages(struct inode *inode,
>  	 * the subpool has a minimum size, there may be some global
>  	 * reservations already in place (gbl_reserve).
>  	 */
> -	gbl_reserve = hugepage_subpool_get_pages(spool, chg);
> -	if (gbl_reserve < 0) {
> -		err = gbl_reserve;
> +	gbl_resv_get = hugepage_subpool_get_pages(spool, chg);
> +	if (gbl_resv_get < 0) {
> +		err = gbl_resv_get;
>  		goto out_uncharge_cgroup;
>  	}
>
> @@ -6764,7 +6766,7 @@ long hugetlb_reserve_pages(struct inode *inode,
>  	 * Check enough hugepages are available for the reservation.
>  	 * Hand the pages back to the subpool if there are not
>  	 */
> -	err = hugetlb_acct_memory(h, gbl_reserve);
> +	err = hugetlb_acct_memory(h, gbl_resv_get);

[GLOBAL ACCOUNTING]

>  	if (err < 0)
>  		goto out_put_pages;
>
> @@ -6783,7 +6785,7 @@ long hugetlb_reserve_pages(struct inode *inode,
>  		add = region_add(resv_map, from, to, regions_needed, h, h_cg);
>
>  		if (unlikely(add < 0)) {
> -			hugetlb_acct_memory(h, -gbl_reserve);
> +			hugetlb_acct_memory(h, -gbl_resv_get);

Sashiko:

Does this error path complicate the rollback logic? By explicitly freeing the
previously held global reservations here, it guarantees that out_put_pages
will need to re-allocate them from scratch if the subpool absorbs them. Does
this increase the likelihood of the subsequent hugetlb_acct_memory() allocation
failing?

Ackerley:

Yes, it does. Restoring gbl_resv_get here is the correct thing to do, to
undo the [GLOBAL ACCOUNTING] (see above). It does look weird that
hugetlb_acct_memory() is called twice, but the hugetlb_acct_memory() in
out_put_pages is actually purely meant to follow up after
hugetlb_subpool_put_pages().

Everything is mathematically correct. Sashiko is also right that this
could result in allocation within out_put_pages.

I'll add another patch to clean this up, see next revision!

>  			err = add;
>  			goto out_put_pages;
>  		} else if (unlikely(chg > add)) {
> @@ -6819,26 +6821,21 @@ long hugetlb_reserve_pages(struct inode *inode,
>  	}
>  	return chg;
>
> -out_put_pages:
> -	spool_resv = chg - gbl_reserve;
> -	if (spool_resv) {
> -		/* put sub pool's reservation back, chg - gbl_reserve */
> -		gbl_resv = hugepage_subpool_put_pages(spool, spool_resv);
> -		/*
> -		 * subpool's reserved pages can not be put back due to race,
> -		 * return to hstate.
> -		 */
> -		hugetlb_acct_memory(h, -gbl_resv);
> -	}
> -	/* Restore used_hpages for pages that failed global reservation */
> -	if (gbl_reserve && spool) {
> -		unsigned long flags;
> + out_put_pages:
> +	/*
> +	 * Return all that was requested from the subpool, let subpool
> +	 * tell us the new number of reservations that need to be
> +	 * returned to the global pool.
> +	 */
> +	gbl_resv_put = hugepage_subpool_put_pages(spool, chg);
> +	/*
> +	 * There may be a difference between the number of
> +	 * reservations to consume and the number to restore now if
> +	 * there are multiple threads interacting with the subpool -
> +	 * restore the difference.
> +	 */
> +	hugetlb_acct_memory(h, gbl_resv_get - gbl_resv_put);

Sashiko:

Does ignoring the return value of hugetlb_acct_memory() here lead to accounting
divergence? If gbl_resv_get > gbl_resv_put, this attempts to allocate global
pages. If this allocation fails (e.g. out of memory), the failure is silently
ignored.

Could this lead to the global resv_huge_pages counter diverging from the
subpool's rsv_hpages counter? If a concurrent operation drops the subpool's
used_hpages below min_hpages, hugepage_subpool_put_pages() would absorb the
returned pages into rsv_hpages to satisfy the minimum size constraint. If the
re-allocation then fails and the subpool is later unmounted, could this
divergence cause resv_huge_pages to underflow, inflating available_huge_pages
and potentially enabling a system-wide OOM denial of service?

Ackerley:

Yes I agree that ignoring the return value of hugepage_acct_memory()
could result in issues, but this isn't unique to this code path. The
return value of hugepage_acct_memory() is ignored in similar cleanup
paths.

>
> -		spin_lock_irqsave(&spool->lock, flags);
> -		if (spool->max_hpages != -1)
> -			spool->used_hpages -= gbl_reserve;
> -		unlock_or_release_subpool(spool, flags);
> -	}
>  out_uncharge_cgroup:
>  	hugetlb_cgroup_uncharge_cgroup_rsvd(hstate_index(h),
>  					    chg * pages_per_huge_page(h), h_cg);
>
> --
> 2.55.0.970.g62bdec98f9-goog

