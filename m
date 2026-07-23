Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E2B7C531CF
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 13:39:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDD966B007B; Thu, 23 Jul 2026 09:39:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8D416B0088; Thu, 23 Jul 2026 09:39:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7B8D6B008A; Thu, 23 Jul 2026 09:39:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 711426B007B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 09:39:57 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E1E201604A0
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 13:39:56 +0000 (UTC)
X-FDA: 85020149592.14.71712B6
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf23.hostedemail.com (Postfix) with ESMTP id B49D4140004
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 13:39:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Dhd9yfdq;
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.179 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784813995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5OXNEFjRCaitHQKe2wfBmPOWIET8WKaJvN/RgwCYDNw=;
	b=sF0OdlqnU5x0v5I8eaVO45San2v2G83WnyVKYDjm9MmVe9scI7NsSgC3y/pvoBq+tL0BHE
	FYmyU4UntfMveCyGaJmKuxJRDMy/F5Prjuk6Wj5NZdey99mHxyU/7bWcKhJPs/zw9B18UA
	soaNAls53yM++d3bQHriUlvgLlrO3xw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784813995;
	b=fG2enh2dyGC5KlgJMtaJXhlodcnqp03yYEgO38Np5ovj9aqplSkYD+519vMf/rdS2MYf83
	VQ3OiTiq/Jex5B/fegCff/cy29GD3d3Mz54WN/Ddr4NfgZcKyLV2neJQdBKwzfah3X7xIn
	9rSYFkhPEYOKy59mMCZ7PqXebbv7/cU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Dhd9yfdq;
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.179 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-51c5382806fso6302821cf.2
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 06:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1784813994; x=1785418794; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5OXNEFjRCaitHQKe2wfBmPOWIET8WKaJvN/RgwCYDNw=;
        b=Dhd9yfdq6k9H6lVintCecAB6V8j2a/l2xTUGZYeh4GJQHaY2tW2XjwuBjE45JGmvao
         lu3gU+0Fwy9fYNUKpEZRx2I6X6cwo+LinCerVkS9pReiNiqGrk+E2aAsLYoTRieng2N9
         dF4ZpLZyJDCqZrJOW8NyH3Y5x5jb5n0D+OL0BRfpcWAoJdGYAZhxOfQOo6/u+z4FyzzC
         DqeBIeVVa4kWzdHjLm+h078+ykBKh8QVA0i34XwMeakJ+z6fqsC+PtJu5TMszMEsNsR4
         JcVqqUwLbp1zGPEV3wgAAf9ClDX0f6GkKAYb94DoT2Wg9pCELsSaAy7yCsgFsMgmgxIP
         rClw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784813994; x=1785418794;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5OXNEFjRCaitHQKe2wfBmPOWIET8WKaJvN/RgwCYDNw=;
        b=USyjARPU8uNNWjZSCjqI6/0yGvMaIbLcIkU5aUX/O+ESsrhWTHflZoAZVd+ri9c42S
         cw8hIE2FVe5e2WIuxQjwjzTpvyUWIB8vFb66x2GPzDeoyGcElTkvUe/bIf/EIm4legEz
         qZ8Bwa+Hxntvppqzf+sAuYjt3Ej2WhXPuZe4eLGdrP7bey8BQoFbzqgD0+3cM8w+bsR7
         tc40SHIPG14B4jQd89NSsT6ZOv3joqsb0KPuxRNgJGFIRp9wDmuPP2LYTcUK6761jk/O
         x1a2iLjPHXdHJMFCRC5BpREZFdtWh/VYGQqgmhzrY+Lgj/LFjOYyKSHMxv0MU+tiecaI
         aozg==
X-Forwarded-Encrypted: i=1; AHgh+Roszu74QeHHcu9ZpwUVC9ya/h82e6uYEG66RWFW+ctIUCqtXPvr1+9TPBpx9JcIgDp2hTUHn0dIJA==@kvack.org
X-Gm-Message-State: AOJu0YxbvtilKiNPDBvaNDUjx04ctaN4O3dJAsIhRsHYbSkDleeUrr9V
	NKSetgZPh8gMlaONcIH8ws6kKPi4q2v4X582aSLmLnGYH23SpuM5AMWMbl7CFTNCuYk=
X-Gm-Gg: AR+sD13vGNTumFe/gNmdVoO69v+xt7nUnlwefnldlnY8jLYWShEU7KhyYbOPi0+cADt
	aets932aiEPSOuMttQOUZG0MBSrURXq3ZAMSRs16RKs4zG41DoVX9Crn53jhDOPe2cd4E38uunV
	XXD7Ajo1T1UrfdiMPUV49ZyOFeYPagV1WElFE/SgWPSktZC5YyiPU/EYaekCMeUb2dSe0gdTQ7S
	Y2wTHxZZE+NWuyWkiAXm1Erk7clDUAbGJ7Cm1yUhWskB0IyvxmAMmiJ6cmBmbyGI/Rotf1IZheP
	fGS0nEE6utM4nFQD8w0Cv5JW5stokoqpR1/YZxSuvxv7yFNL3UJv1MoKKqA38RBZiH6258MZd2n
	kxeRcIvrAd9+R8voGyKUHkzjnUo704eHLskVaQThyQC9zeRr9ta7q94bekdCn/DTVJGVTinwBRE
	ol
X-Received: by 2002:a05:622a:5906:b0:528:30e1:b5d3 with SMTP id d75a77b69052e-5283e0419fdmr25761861cf.84.1784813993716;
        Thu, 23 Jul 2026 06:39:53 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-527d0c4ce60sm35155751cf.7.2026.07.23.06.39.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 06:39:52 -0700 (PDT)
Date: Thu, 23 Jul 2026 09:39:51 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: zswap: free synchronous-IO writeback folios
 directly
Message-ID: <amIZp7Ual_6Gu86T@cmpxchg.org>
References: <20260718093723.153324-1-alex@ghiti.fr>
 <20260718093723.153324-2-alex@ghiti.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260718093723.153324-2-alex@ghiti.fr>
X-Stat-Signature: koecgaf6w53kd9b6dkn115itn84imosb
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B49D4140004
X-HE-Tag: 1784813994-93087
X-HE-Meta: U2FsdGVkX1+L7e4OQMDfJvbSimsZe71qtzgwvUixGP94lKRQ63xjy9f5eI/X2KCD3hMVsFPQXxQhGKxVayb+5f7RxTLzevU8zfFf1WL+myCzbQxpqfAsRlOcmsmb3NcEUgdXSOA+CLgsBdeLcHhoHlHMFTTJwxKmi7YWJPQkfkmc/Uo51Pu9bAkFIWqt5XyNnOLVsdS3uDMvuPHhbneq/tFVByk+TvQpuVqh0LSVxa1ehwH9VZdN0FjwqoEs3XbihBsl1l+q85nmlQqJlvLYa8zB6dDxbFsCG/CuBF1lku5Y8Z0LZAm1un83DTO4NF5svG2eqwG/dwRoDf9Gs7TUzYx4t7LRRpn9KueiiSEo9LhKMImjCRCVo1K/kN6HmooJeKckFuOHFCBI+V6VWhD8dV/beW1D8BRAMqs/zSOFliNUQwnftD0RNxCZJXP1xNh4qe7znyFdtOeSFT5vy9gqbIN0L66YAsqEzl4KOIuqX7QtlYuYczy4Iboi7gmj9RNWRwk4TzwcbIb0PcylVrOoSkGnERhMYacU7OTNytWDrpisJfSnt9DvvspPnmy5OTFrAExvQs3gEGTFUjn+B1Sb7SvxV+gD+6sUz5mWMWAoxdTSbwjRetLjVcb8FXs7PFeaBZeap0untBcA8R4OnKO4Zx8JSZGp9+IaIMIa9b04k7kteomaRZVJq7xwXRkEOrUsZ+4EQDyrqfDAoWc6euduMaFVy3Fa4W0cZhqB1YNcXNkuo/Sne053DxvoYh4o2d4986taqZlcwhUzHcU7wfkZbEVgAJ8uFKz1vWD+z/qKzajUa9B4ckI9Abr8Bck3RQ0drbQ5MsoH1W0GS7xN5uhbVqy180O5eKAyTDUlCoB1LwbjTA9Z+xhSgcj5fZSnMsYlxaCFY0dqWmHE4NvAr578Um0Rh500GYyx4VetQGvkd1m9jZSZ+EkStxCkXdZj/c58Ye0Op7OYLcCsDpYJq6M
 BqrfsrbY
 H6Yf4v+Jd2/nnnzjaon0oeVxRz6HGmu+acNGzhu85JjvQXvgnYVJkHyEke9rcW9pW457xdbcDI+NO3lceKety3oU/WZzOS13/G1ZTSS2oS3shmYel1QHOMHf7edq0R+cPaUnKVImw3QnXc2eizMs5qH+umy9f8Mhown5JIpRda6ZfYt21nhcXrODLIPWrbkE13QavbMItQOhqRizA9aYNntrrU26M0yDB2wtXQs339bMhdJXuBgfOijAzvonyM5XzRRJehjT05KT/nm/w/XxXvfoyYYwYsBDx9q1Ge2Geyh5TKoAVMYuYnakQL6lHwUZm/+OrxmBlWGcIn+U9dpcwV1gFPmZshSzQrkRkMMvyOCwp37YqPWCyLY6zSPkC1tWlc3uoTvd+xISSDXUok7kvbqWRNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 18, 2026 at 11:36:39AM +0200, Alexandre Ghiti wrote:
> @@ -972,6 +972,30 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
>  /*********************************
>  * writeback code
>  **********************************/
> +static void zswap_writeback_free_folio(struct folio *folio)
> +{
> +	folio_lock(folio);
> +
> +	/* The folio was allocated off the LRU and nothing re-adds it here. */
> +	VM_WARN_ON_ONCE_FOLIO(folio_test_lru(folio), folio);
> +
> +	/*
> +	 * Gate remove_mapping() on folio_test_swapcache(): a racing swapin may
> +	 * have freed the swap slot (folio_free_swap()) and dropped the folio from
> +	 * the cache, and remove_mapping() must not run on a non-swapcache folio
> +	 * (it would trip __remove_mapping()'s mapping == folio_mapping() check).
> +	 */
> +	if (folio_test_swapcache(folio) &&
> +	    remove_mapping(swap_address_space(folio->swap), folio))

I just chatted with Alexandre off-list, but this path does not store
an eviction shadow like the reclaim path does. That means no refaults
are detected from dropbehind pages, which can fundamentally alter
reclaim decisions, zswap shrinker force, and pressure detection.

