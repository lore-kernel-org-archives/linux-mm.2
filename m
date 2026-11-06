Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A16C606A31B
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 04:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OtSg4Csq
Received: by kanga.kvack.org (Postfix)
	id 605BD6B05B1; Thu,  5 Nov 2026 23:48:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DC5C6B05B2; Thu,  5 Nov 2026 23:48:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 519F36B05B4; Thu,  5 Nov 2026 23:48:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2C62A6B05B1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 23:48:46 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 379EB80A84
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 04:48:45 +0000 (UTC)
X-FDA: 85403463810.14.7FAE098
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9FCFB40002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 04:48:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OtSg4Csq;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793940523;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hhfOeJeYz1xj0gbEi9rPmzkvN0a5SwOK634qNkp20no=;
	b=bvTDpJNyJ4EYN1xvcHTicyJzKHbaueOVXmg7rt1QomsV3ju+Yp8O6ncJdvS5BoLnikt1FS
	nTJoAGz2ayFKWTm1pHBjv+3Y6PpZs8B6zkJHHFw4m62KvPpVjkWVY0jot9wMdt8G0lUxMK
	Pt27wbxSjKHSOvwkIBk0iLEH2I0pioI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793940523;
	b=S07Ku9lCzE8urcuSj8g0WKTNBn1ISfDTzuZiku9qrA9KGIqXytzxL2WB8oU5DgDi/tClHd
	jHg82/DDVf3a66oysdEgJOcqPJeKev0pONHwylQ0wIRZsyqe7b2tm2v7b6R6SmFv7G4CNh
	1HqW56J+i6s3eoVz1uFMSwxHD9dBr7Y=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OtSg4Csq;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6A90D601E3;
	Fri,  6 Nov 2026 04:48:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3BE51F0089F;
	Fri,  6 Nov 2026 04:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793940522;
	bh=hhfOeJeYz1xj0gbEi9rPmzkvN0a5SwOK634qNkp20no=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OtSg4CsqvH8zrALUwiU0cY6l4JK+S9jQanwD3HBGC3Yq9sIEM0Nt3fzxjfq2uqYdJ
	 6PnMQ1KDM/c7vn4tRtyzY8ojCra1Y3jqCxeAjxSfqoLfzVIUOZIVQebtBqFhhml4O6
	 +PS94Jvf+ZSwyRfV0DYKcAKd7LbwM/6xLCQAD1pNiGyoh0V7OLWVdA7n9MHmpTK9J8
	 lkdJLcgDpNbbvO5dFMw1PvnMY1JB8TrZMKLEgB+Ktz1cad+JIsMVfd0NRnqinTqcV8
	 da4FqfJeWVy1c+PgcN3hSi/Z8uJ93H+EN7yNalFu3CCVYEphK5fAealdDY9UvaWwzx
	 Epz1MTtZikYVQ==
Message-ID: <sashiko-outbox-200764@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/7] zram: allocate zsmalloc object under slot lock
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sergey Senozhatsky" <senozhatsky@chromium.org>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Nhat Pham" <nphamcs@gmail.com>, "Yosry Ahmed" <yosry.ahmed@linux.dev>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Brian Geffon" <bgeffon@google.com>, "Minchan
 Kim" <minchan@kernel.org>, "Richard Chang" <richardycc@google.com>, linux-mm@kvack.org
In-Reply-To: <20261105044752.1997895-5-senozhatsky@chromium.org>
References: <20261105044752.1997895-1-senozhatsky@chromium.org>
 <20261105044752.1997895-5-senozhatsky@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 04:48:41 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: d7ur1bquwjd75ebgbtjhrbwzqiosemiw
X-Rspamd-Queue-Id: 9FCFB40002
X-Rspam-User: 
X-HE-Tag: 1793940523-382271
X-HE-Meta: U2FsdGVkX18AxT/2/iDzHrn0wS8jAwxlf1SJ+mcksbx3J7+THlqQiZVX1fk5XaYxfsGONX+LdElgbtRsWfWmXWASY1dBv4CKGBbnuuSrB4LGx75f+JKz0luFfVSRVF2laaC0WmbClG0imdrotfU2qkxPlEfsQ8JyxcIswsRcEdOrY7FQZvn5VPAIT6GMZxjLch9lx51L0UOTtxyarauJoBQuv2sqGjdufWlGioNozlt5BJs3vmwyUiz4QxmOH2bgfHiDRpohesTp04nXlhIZWbQOA8jEVamU88aWVLuI7iFjzIOPi0xI8gsyxIRhCiZLI92t6B2IKveM/8UczbjsXZ2qrZHDyXR4I1nfSYqLkq1K8g853saDgypSNJG5UFj4liVwy1gQN4iOVBQeGP6O0tcOAyjpuugcZoxEcaDvdsHSjT/llUEDrvUn0L3nMw/xDHYujbbIu6Toz8aRdLWb6mPY/I4cj7lyXNm3T8zDD4pySpJDQE2vC4BE8q7uj8+sCTiCJUoExt5YNtMupYcY5LfYjFdtXm6hCyfQ9n7/bLlJK0W6FFNGM9x0F0FvHxxPoByeCwvi2priEBqoRBox0QipcPRimtoab7A7i3f3K3EaREijLn0wCzXQp9hXjq+xawQTzTmdrn9Eskvvg2D9gvktM2iRJSsaybqxjOOUfO3bfKHEd/dO4Tc+8DUZP8/2WJKqQ6ICln3OXv387rMvP/nmM58TgBeM+F7kHiwu4vo/8i2z6II/anskMhtpBOWFtGEizIU3rwSCL0UJqE/LpR/wR+tAxuvXZxIC26HNelRqfE9AzA1ga4hPgiXPdT5UZfs5VlkUE1rJxPUBP6rjeoc9zFxrL47UDX20198inUN22MAl8+WTZGv2LwPQrg+sXXSW0QLCqRdSTlVz6BzhbsVlIEJS5+BqilGpe25Au1ocTlEQ33V4Zxt9EzMXO7FckCs9HZV2m6TFbMq4vQ2
 bqRrczuy
 YC3RTgNWuXg5LBLSlugY/E7JZiTGTKYyOjSPS7f0wphpWU8gIYFYMej2/ZA7Vs7DBgDUqLbs39kghW0AYPLDPwK8KpbN5nS6u2qvlrQ9H0s3U7RaC2+nkDA4jyf6bV8TgIutCRLt28wMSNFhWHt7whwdBki6otfYMyr437NvrpXxMUB7NQaesAJttGYA4RGAUCwjscGTnWR1bdPwXq0kVIh6XS/m2PYhh2gRsyDrEp2xJwUNODH6HC+m2SOOeEOxJRPCc98Ib8IssCio5p8w2C1uHs7Jl6OdNK+7Di1gr1ywyXSlXtn4C0kUKv4T9upy5/QLSTQ49p7vCu6JZfP2VzusArFx3AgUj7WY+ONhhrO/aHbi+FwpEX9Q5UkU51vqBj3kzUxLgO3hbJmPT2+YU349mRxyDE2G+RKqt8CBHrFJvaf9L69mdU25oVvKdEZU9j4q/f4YS/ZRtzq5i41wpjA3GR1LuQjMyLAmE94LS43YEGZ4TCMkI2WHHnb+Q5fFYcyL8DhoKO/Vvm2c7nLQOZebdsTG1BKyAR9mzMnZmlzOFkTuTaUhPy1lMQ/nQvBm3efRGv09FmmP2RyaGsJwvJSb8eg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] zram: data loss on write failure after slot_free() in zram_wri=
te_page()
--

commit e7f04891f4b67054972cd177192ff9867fcbceb7
Author: Sergey Senozhatsky <senozhatsky@chromium.org>

zram: allocate zsmalloc object under slot lock

This commit moves slot_lock() and slot_free() before zs_malloc() in
write_incompressible_page() and zram_write_page() so that the old slot is
freed under the slot lock prior to allocating a new zsmalloc object.

> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index 2c2e11b2b6638..e2710ce35b1f5 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -2260,14 +2260,19 @@ static int write_incompressible_page(struct zram =
*zram, struct page *page,
>  	struct zs_handle *handle;
>  	void *src;
> =20
> +	slot_lock(zram, index);
> +	slot_free(zram, index);
>  	handle =3D zs_malloc(zram->mem_pool, PAGE_SIZE,
>  			   GFP_NOIO | __GFP_NOWARN |
>  			   __GFP_HIGHMEM | __GFP_MOVABLE, page_to_nid(page));
> -	if (IS_ERR(handle))
> +	if (IS_ERR(handle)) {
> +		slot_unlock(zram, index);
>  		return PTR_ERR(handle);
> +	}
> =20
>  	if (!zram_can_store_page(zram)) {
>  		zs_free(zram->mem_pool, handle);
> +		slot_unlock(zram, index);
>  		return -ENOMEM;
>  	}
> =20
> @@ -2275,8 +2280,6 @@ static int write_incompressible_page(struct zram *z=
ram, struct page *page,
>  	zs_obj_write(zram->mem_pool, handle, src, PAGE_SIZE);
>  	kunmap_local(src);
> =20
> -	slot_lock(zram, index);
> -	slot_free(zram, index);
>  	set_slot_flag(zram, index, ZRAM_HUGE);
>  	zram->table[index].handle =3D handle;
>  	set_slot_size(zram, index, PAGE_SIZE);
> @@ -2325,25 +2328,27 @@ static int zram_write_page(struct zram *zram, str=
uct page *page,
>  		return write_incompressible_page(zram, page, index);
>  	}
> =20
> +	slot_lock(zram, index);
> +	slot_free(zram, index);
>  	handle =3D zs_malloc(zram->mem_pool, comp_len,
>  			   GFP_NOIO | __GFP_NOWARN |
>  			   __GFP_HIGHMEM | __GFP_MOVABLE, page_to_nid(page));
>  	if (IS_ERR(handle)) {
>  		zcomp_cstrm_put(zstrm);
> +		slot_unlock(zram, index);
>  		return PTR_ERR(handle);
>  	}
> =20
>  	if (!zram_can_store_page(zram)) {
>  		zcomp_cstrm_put(zstrm);
>  		zs_free(zram->mem_pool, handle);
> +		slot_unlock(zram, index);
>  		return -ENOMEM;
>  	}

[Severity: Critical]
Does calling slot_free() before zs_malloc() and zram_can_store_page() in
write_incompressible_page() and zram_write_page() cause existing data in the
slot to be lost if the allocation or memory limit check fails?

Previously, both functions allocated and populated the new handle before
calling slot_free(zram, index), so a failed write left the old slot contents
intact. With slot_free() called first, the existing handle (or backing devi=
ce
block when ZRAM_WB is set, or ZRAM_SAME entry) is freed and
zram->table[index].element is reset to 0 before the new allocation is
attempted.

If zs_malloc() fails under GFP_NOIO memory pressure or zram_can_store_page()
returns false because zram->limit_pages is exceeded, the write returns an
error while leaving the slot empty. Subsequent reads via read_from_zspool()
then see !zram->table[index].handle:

drivers/block/zram/zram_drv.c:read_from_zspool() {
	if (test_slot_flag(zram, index, ZRAM_SAME) ||
	    !zram->table[index].handle)
		return read_same_filled_page(zram, page, index);
}

and silently return a zero-filled page instead of the previous data.

Additionally, on systems with PAGE_SIZE > 4096, a single slot holds multiple
4KB logical blocks, and partial writes go through zram_bvec_write_partial():

drivers/block/zram/zram_drv.c:zram_bvec_write_partial() {
	ret =3D zram_read_page(zram, page, index, NULL);
	if (!ret) {
		memcpy_from_bvec(page_address(page) + offset, bvec);
		ret =3D zram_write_page(zram, page, index);
	}
}

If zram_write_page() fails after slot_free() here, wouldn't that also wipe
out all the other unmodified 4KB logical blocks sharing the same PAGE_SIZE
slot?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105044752.1997=
895-1-senozhatsky@chromium.org?part=3D4

