Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA55BC5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 13:42:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D16046B00D7; Mon, 17 Aug 2026 09:42:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEF1F6B00D8; Mon, 17 Aug 2026 09:42:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDEE66B00D9; Mon, 17 Aug 2026 09:42:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9228C6B00D7
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:42:12 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 19AEE160734
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:42:12 +0000 (UTC)
X-FDA: 85110875304.29.04DC9EB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 58EF7160006
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:42:10 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kUgKhK7A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786974130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=THX0Z/8utD7j+IXnwYTDcoLP5zSf7naxjyTV86BLgDQ=;
	b=CBVngwoSyXAtph969imIg6K6Icc3GLaeZ5k+QVhy6eCDLxZ9A1hZLmdoKK4+ipWYS2egF2
	xtDnIky1SPhy2jALouYsQyMsXMjpk5jHLYremlVipIsvUHcojwO8EteUhZfttWB7rigW0y
	Lm5VZDH3+8W/d5YR+JxpJuOegYI8eM8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kUgKhK7A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786974130;
	b=QicbtK/PWp2ogqGRnZw1jHTqKPW5VDXUen2+4bnXxdCJwnG6nIlm2vwdkDmVzEazImhJs/
	IXP2vdWMNNC0cy3AImF68loX4Vi/BNRyDtWe1LeJDJ+XJTG2d5fDkw2+U4oC1pDWL49T2q
	Do/y3+6VYjp0iVgyHoxLV5m8YVHOjLM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7D44743CC5;
	Mon, 17 Aug 2026 13:42:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2777C1F00A3A;
	Mon, 17 Aug 2026 13:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786974129;
	bh=THX0Z/8utD7j+IXnwYTDcoLP5zSf7naxjyTV86BLgDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kUgKhK7AoUwKAqnbkbeYM5ehgQFaN+R6d+cdrlJ8KaoIb724DCtdhNNOBc66wwJEv
	 s5bP4WMHROjY9Im4Ure/mxamJRMC7nFf0tE5QJBZTNyH6pMogVxuNNuI1o8nTuj1Gx
	 UYGH+JsT6fsECYGb1mkTufCVdjmS5KIoXGg0c3c/dIKXKNtxzAbS13yDzmA2Hz9pYL
	 jCx2GZ577NJ0JSH2K/VNuzLCqvNhX3IsGZ7XDSYrnhwsP0MOT6+8OZyOx7D7hkO0sG
	 UZnoP8n3+xFN304mgxB2QgGsUjPSNNfcRUtS4BzQVBk6X82MqZQ0SnN5WlZCk8X3j9
	 ohfonFOSaP52A==
From: SJ Park <sj@kernel.org>
To: dayou5941@163.com
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	Li Youhong <liyouhong@kylinos.cn>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon/ops-common: factor out damon_putback_folio_list()
Date: Mon, 17 Aug 2026 06:42:00 -0700
Message-ID: <20260817134202.75525-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260817063458.351063-1-dayou5941@163.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 58EF7160006
X-Stat-Signature: dgn565pyg7k5nf89x639fk54g847bcyy
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786974130-373312
X-HE-Meta: U2FsdGVkX1/AMDYd8doFyqTw7vrT5A9qgg4ea7kUPfwU76awCd8s77N09OX9KaGPESUssc0sdyMWkAnHHusUpoabab4d+lglKKIxxPmQDDd8Zz0IDkTt5MC1+Pk7Rm3EXxEST39HKnoUwqC9NYIv4QP1UUq1Id+zxKWV7uJs8J8sP7lFNWzOcL9vUTfEVxBF9CdnRetQLcIuDg8sXfwi6Kz6kwuZfYW6FJ4sOClwZBZwAgAqmYg4iAKCv2O2QGYoEMxNVVZz8SkGfljFIqg3htBsEQrhoSZnzeCTUV4fWabhRuTa1HyZGXyQuv8B8+PAnYccVSB6G8zn61KMiDdWNZ5aWP7LRrO8RDOseM0bQpV2H5ica6L9x8S/ykblUquY2WhqzmgB1MOQifPNiAUeui9x0bZilr7b2Bxiz5TMcEU4uodVvVK9A4sFLdxCtpH3LfjgDHHn8sY2F5prGA/tnHthS4CgCc6M855oja3XcQ1oZmkHssmo4fwPGiS5+Iv88OXHEMqjjqkOgEdx3my6GNDodw4V/FAaXSLmnnWaFiZidNM6jXa3qn5cKVAMk+GHYc4G97q0jrP7Jxi6EIDr8xfy3nvwpYsv8Vyg4nHVjAi8J6jCmsCBIwqm8ZBZJ2LBS9Jax68EG9oTYtkBuU7aIUoogvOGv2sBz8bO2et+r+oAB6uoQum9qEhXtRVOs8wcs3WuIVYja3B65mHMF620I+xTUokflz/kvD1meD4v22AbjXcgwvl3h/fHbDJaDlKd4z3QAA0TlKQruqe4pLbf+xE9iRNPoRmFu6Irl/0szisdbV8QbuWynTburm2BLEc76r2ouoB9JwTyRJuVOqVhx1jbw0YFuq8ThD8WM9yqrgT828DFny3HdoKavw43LZ4Ll7lig/67EdznmN/Sl1WK1KG0n1H3co9K+ndtPNcamH2MIDN8Y+Xg/gHSfJT7eZQIgCkghElRtb9dvrUhcUc
 VQhwuFy6
 K7RIm8za/zapLffFmZROW9S3Z01h4PDGDEcIYb63/gRlQDbCafN6GLw1pWYRTCA98uQTsxtswnNZNn0LuyciqNr1jJUk6BWEwt/lnDddHMX6x4WnUyPsqqO7HOmG3XptSRutNLanb1jVMlmmZE0RvLOrLacO0HGyR+ApaMLiKJBO31uja/mfdcxjmEq6Dp430ANK6nA9b8Y2UJLz/lwku6nc5ZCtOuDU9DsTpfokTdo1Or7YSD/apkOXbaRODzMn8GYXhCJnQcR06vTDayxRpe/F4waXycYlRivv7yPxnXHlTT5FTLmnr/AIYz8OoFvyLHIvQ7GU44138II+bl4fqirScr7jqcNPxPkTUjIr3mO1XV89VmM1n8IJsmDBA1GsursT9xQsDQIsGnXw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Li,

'get_maintainer.pl --nogit --nogit-fallback' suggests adding below recipients.
I added them.  Please consier using get_maintainer.pl from the next time.

- linux-mm@kvack.org
- linux-kernel@vger.kernel.org

On Mon, 17 Aug 2026 14:34:58 +0800 dayou5941@163.com wrote:

> From: Li Youhong <liyouhong@kylinos.cn>
> 
> The putback loop is duplicated in damon_migrate_folio_list() and on the
> invalid-nid path of damon_migrate_pages().  Factor it into a small helper
> for readability.  No functional change.

Thank you for this patch.

> 
> Signed-off-by: Li Youhong <liyouhong@kylinos.cn>
> 
> ---
> Note:
> As previously pointed out by the AI regarding whether removing the local
> variable struct folio *folio in the damon_migrate_folio_list()function
> would introduce build-time issues: no build failure will actually occur.
> This is because struct folio *folio is only used inside the while-loop.
> link: https://lore.kernel.org/all/20260724060707.CE1F81F000E9@smtp.kernel.org/

But, a build on my setup actually fails like below:

    $ make O=../linux.out mm/damon/
    [...]
      CC      mm/damon/ops-common.o
    mm/damon/ops-common.c: In function ‘damon_migrate_folio_list’:
    mm/damon/ops-common.c:357:17: error: ‘folio’ undeclared (first use in this function)
      357 |                 folio = lru_to_folio(folio_list);
          |                 ^~~~~

> 
> ---
>  mm/damon/ops-common.c | 31 +++++++++++++++----------------
>  1 file changed, 15 insertions(+), 16 deletions(-)
> 
> diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
> index 0bcad6b1e5b9..5c0c941b7f75 100644
> --- a/mm/damon/ops-common.c
> +++ b/mm/damon/ops-common.c
> @@ -329,12 +329,24 @@ static unsigned int __damon_migrate_folio_list(
>  	return nr_succeeded;
>  }
>  
> +static void damon_putback_folio_list(struct list_head *folio_list)
> +{
> +	struct folio *folio;
> +
> +	while (!list_empty(folio_list)) {
> +		folio = lru_to_folio(folio_list);
> +		list_del(&folio->lru);
> +		node_stat_sub_folio(folio, NR_ISOLATED_ANON +
> +				folio_is_file_lru(folio));
> +		folio_putback_lru(folio);
> +	}
> +}
> +
>  static unsigned int damon_migrate_folio_list(struct list_head *folio_list,
>  						struct pglist_data *pgdat,
>  						int target_nid)
>  {
>  	unsigned int nr_migrated = 0;
> -	struct folio *folio;

Above declaration removal is causing the build failure.  Let's keep the
declaration.


Thanks,
SJ

[...]

