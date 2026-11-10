Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4948B606A320
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 18:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ISLi9FAb
Received: by kanga.kvack.org (Postfix)
	id 4166B6B05B0; Tue, 10 Nov 2026 13:37:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EE646B05BB; Tue, 10 Nov 2026 13:37:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 304A36B05BC; Tue, 10 Nov 2026 13:37:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 154D86B05B0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:37:51 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9D0CA1A0AA0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:37:50 +0000 (UTC)
X-FDA: 85420068300.05.63B4E2C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id EEFA4120006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:37:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ISLi9FAb;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794335869;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+IS7FH0DXsKLuZwtc/xVH9zBjYrq4Z5T/V0pa7j6d/w=;
	b=lSD0s0SNZ+eBJkCKGVFdvdKlH8XG3IxChApIy+KDE3Yn6FCayApKyO8/OGfX8Pup6TGJRn
	BPT07vkjxAS0cDAfin6jBl8N897qHbyitwnmn4mOxmNpEuPKOiJBfeuHl3MRJyCBhB34Jq
	lztBvvyoFuje74iq5tq2gzi34bjeA0M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794335869;
	b=61BR7FsmL0FyjmoYpWRb5cn1MHSNdJIxJLorsHFT9VQhl2+3Jz90eqD6cBr/qgkbf6SWib
	knBKPVlGE8hqYm7cKLzw0EJTkKRWirmaRpki37dBCNa2TwWMO2ivBgQ3T8j/PapBDBF2DZ
	o4RihzjZCn7D6ahosYexWdg398DTv8A=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ISLi9FAb;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F1344437CC;
	Tue, 10 Nov 2026 18:37:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E9121F0089F;
	Tue, 10 Nov 2026 18:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794335867;
	bh=+IS7FH0DXsKLuZwtc/xVH9zBjYrq4Z5T/V0pa7j6d/w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ISLi9FAb5aNHRovGSTT8DpAZ20vM9QvazEhz1eMH5awVFUmhis07JxTPlij2m8uZG
	 Nda+9CvYrcduI/CzT3tlBPbGodS+2/T74/B5mt0pcfZLfYk1az4kAvQwRyzWbNoX+p
	 VAU/G0y2eXzUDxcpa9HhQGKwnmpMJiOo4ON130mXLWCJws07CKISQXL0vttzFOeauH
	 h8a2xAIVapkCPftY1UYOF7CnWINmA52qhhmXQ6OYX9wRgE8wqkOjsAtHCD/tUyZ+YH
	 J0GSxUNbepV+fwS65FqlJpXYyaeJq2Y0sbGrAArB2MYxN4JehMjFm+TNk3UorL9B2j
	 qfEyo7yfBy2iA==
Message-ID: <sashiko-outbox-207587@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 05/11] zram: check mem_limit before allocating
 zsmalloc object
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sergey Senozhatsky" <senozhatsky@chromium.org>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Nhat Pham" <nphamcs@gmail.com>, "Yosry Ahmed" <yosry.ahmed@linux.dev>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Brian Geffon" <bgeffon@google.com>, "Minchan
 Kim" <minchan@kernel.org>, "Richard Chang" <richardycc@google.com>, linux-mm@kvack.org
In-Reply-To: <20261110054836.1515030-6-senozhatsky@chromium.org>
References: <20261110054836.1515030-1-senozhatsky@chromium.org>
 <20261110054836.1515030-6-senozhatsky@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 18:37:46 +0000
X-Stat-Signature: osq5xshbtudk11c3jkdzgqbhho9tsqwf
X-Rspamd-Queue-Id: EEFA4120006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794335868-64900
X-HE-Meta: U2FsdGVkX1+NhRNmizxdrFF+teoaSt0+eJTZ4rCHzP/xXo4dIaW4QtFOLi8bi4X88WU6dl/Zxwt4N8fVmz+xPFY12RopZ+o/s9Idlx/jPBd/fc8oSQeIn5K36auYlpFQIftb06helMJ3b2panpOfnNLpWbs8bBXn6+xTheA1b6/u+ps1OrWmfZogB5ypPUp7bFDPo8li8p+6YiQDzKzuOJfXoMA9HEwZF12zn335sFJC9tDUFRNe43uL61tjP2u6PBddsc6Kis05s8O3LkeXczYSveIaxrSjaIMY0qmFb7r7lTlE+/CiqiZpu1bzKhPbdNoxXtD+WnNSlsgHUJKHdwcp/JE27gW2m2Mneoec8XUGNtchvbhsimUlJf81at1/6R6KecT+UqqQkQWWDygMPmqXFxgZ71+mdr6k3hcYqFU3VmfZnA7R04+hAhWF38LI2t8ttv9mpj8nYAnHytf0gfIyUTozK9PwjKjv5qK8s6wAMtD9WYHVdgb4Oz/6NuyWp2jYeAGHzaZ23KlH+a2Sm5aa9cyP5ydUf63lMEeehZ8i7DrtcVBTihBr8823QMD8mp62j3+LE3nNX/p10DiTpzpf4vht1izNBb0FuSCtqOBJe6bvishotrayOiuHlsYCYoaojBGpEz6x6LIBH7Hxs0aDqinDkKiHrPbXqg1sMvGk5FtJihOMPT/KFr24dL8OREme+HPpk7CF5/r8ThRcmmG5oGcAwqvr0reuGSevn+JDr7iriDdIhXihfNuumskeFCQalb1bKwOindFGEj+kgY00v6RUMcTzBsHQSR+7JSdVp5mgG0sMOqH7s8fN+aCS1VEHmSNjgh80SgO5usbcA2+scJt3ROk17lrQbtyNxU7bsNQEWyYUrOR6djoc9VbbCKHIy9/fUGrDQ5mbS9/AlrvzYiQ1UOQ55oFHeuV7hZayhh+ExGCljAP+lP/c/UiUiyZadaFAVm1Zo0hwylS
 RxD/qrva
 EsKYVsfDAwQAMO+Z4d/ZpDRjBwCIf7wqmgom6ABxAOQz/HQg8w851wwKuWDfJQyGz4cexfG7AiHDZpp0dJ1FYcloHT8ztFq02pIdpUX7r50xMXvdcg1y0AcVsbYvhSYSYnRcyJmNLd93SXUwCu5mN7NmgOV/qVQPussIdlBVtNT5/+X+GygqzL4QxJx+3JcIgg5Yhzx5ZoKX3xRtDLwpuIvRK5KaRDvH8dJmLuLmKK8MBbENZhPfuCaW3Hz5AR4lyT/xFdWXHd7yVnW/nCx6FXSLUoi6q+fADPn3pvC+r/i7Jg8h4SHD9oYtXDon+eVcjW3mmGE/xQEipknVZM14neXgi9bvLvfDtNujOT/mTIqlrmyXMrtH+IHmaShsT60N6UzjcTHCFBszvF1T17hg8FP+6svS0Y356/cnsx35LGmPnJsS05WH/9xyTrO2KDeM0iQSCbmM/0tyUlC9TYnGyraZKkfJIEaVFpYCK0ziIMaoH5hpZ+QtJhngix+5B0hkhfOHPyQFwgk6yY3HBN31ohqzg6gFHcZbxGwner2KyKXrxszo8GsomsRQztHV7s6KcRyVgltCdlODCWtSfVDjmnogLU4M/PyYVYTX8dCqzkqbilm2VYycXutgclqz/2pAAqodv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] zram: uncached double read of limit_pages in
  zram_can_store_page()
--

commit 29ae8f44e0ebe64efb9439cb2970653d6d8c9390
Author: Sergey Senozhatsky <senozhatsky@chromium.org>

zram: check mem_limit before allocating zsmalloc object

This commit moves the zram_can_store_page() memory limit check ahead of
page compression and zsmalloc object allocation in zram_write_page(), and
updates max_used_pages separately after zs_malloc() succeeds.

> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index 2c2e11b2b6638..d38b20a225954 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -177,8 +177,9 @@ static void mark_slot_accessed(struct zram *zram, uns=
igned long index)
>  #endif
>  }
> =20
> -static inline void update_used_max(struct zram *zram, const unsigned lon=
g pages)
> +static inline void update_used_max(struct zram *zram)
>  {
> +	unsigned long pages =3D zs_get_total_pages(zram->mem_pool);
>  	unsigned long cur_max =3D atomic_long_read(&zram->stats.max_used_pages);
> =20
>  	do {
> @@ -190,12 +191,10 @@ static inline void update_used_max(struct zram *zra=
m, const unsigned long pages)
> =20
>  static bool zram_can_store_page(struct zram *zram)
>  {
> -	unsigned long alloced_pages;
> -
> -	alloced_pages =3D zs_get_total_pages(zram->mem_pool);
> -	update_used_max(zram, alloced_pages);
> +	if (!zram->limit_pages)
> +		return true;
> =20
> -	return !zram->limit_pages || alloced_pages <=3D zram->limit_pages;
> +	return zs_get_total_pages(zram->mem_pool) <=3D zram->limit_pages;
>  }

[Severity: Low]
Can zram_can_store_page() return false when mem_limit is cleared to 0 at
runtime?

The write path does not hold zram->dev_lock, while mem_limit_store()
updates zram->limit_pages under it.  Because zs_get_total_pages() is an
external call, the compiler reloads zram->limit_pages afterwards:

CPU0                              CPU1
zram_write_page()
  zram_can_store_page()
    if (!zram->limit_pages)
      /* sees non-zero limit */
    zs_get_total_pages(...)
                                  mem_limit_store()
                                    zram->limit_pages =3D 0;
    return pages <=3D zram->limit_pages;
      /* pages <=3D 0 is false */

When at least one page is allocated in zram->mem_pool, disabling the limit
causes an in-flight write that was within the previous limit to fail with
-ENOMEM.  Reading zram->limit_pages once into a local variable with
READ_ONCE() avoids the second load.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110054836.1515=
030-1-senozhatsky@chromium.org?part=3D5

