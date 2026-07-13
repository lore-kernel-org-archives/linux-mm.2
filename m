Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B6D8C44501
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 17:12:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89F176B0126; Mon, 13 Jul 2026 13:12:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 850566B012A; Mon, 13 Jul 2026 13:12:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 765866B012B; Mon, 13 Jul 2026 13:12:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DF66B6B0126
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:12:41 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 55658168BFD
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:46:02 +0000 (UTC)
X-FDA: 84984028164.17.A53DCC8
Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8C0EEA0009
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:46:00 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MRSisO6m;
	spf=pass (imf15.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.41 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783953960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XU2J9ywExwhM1zwy22c2Y1HK11dL7My6r4TdOxaIsEI=;
	b=IFDi+QdpajRhOyclSH8VH2ZcRpsR2Otf8Tjh+EiX3kdA4R6IGSBSvBxErHeiW+1o47gBLS
	qwVoR4pf0xTQMTNooK20dUSSKL11R0bXCcB01gbzXQkd6kIw32zBZSbGwJS3t+z+fa6qFg
	G6nLkBzCAo5w6VuRvqkCQ8esXLZG1sk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MRSisO6m;
	spf=pass (imf15.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.41 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783953960;
	b=YetfGHffuABVAOI8KZ72g/H6qs5M2ggCFtw/1IQ91Sk69ANF0TeXwiNeKCp4z7Rk88B6wn
	AsiQxDToIQNMGCRYzZkxCgKbi5hfLw2+NWQyzHQIcRfIaeussEyGPYfo8DbFR1JRvT50/8
	aHE3UWlsq6NnfW7mJTpGqhM7QgAdYG8=
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-6a2c1edb210so476313eaf.3
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783953959; x=1784558759; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XU2J9ywExwhM1zwy22c2Y1HK11dL7My6r4TdOxaIsEI=;
        b=MRSisO6mpRqhWonHDyCehFGgkdHAwfJ7nSUrCjEg/NycUjRkzrWbsN3vvKRl65Oxt6
         uqS5KsfQUv9Ef48BAgqyH7TR63JXIGw+BwAuZKDxve+A95cx8WS7XsOgXEwLyOIOfzll
         R74HfO7+dutY/Xwq7wugk9NlyzC1F/Bi0ZMuNF6NjUTSaq1XSm7KFxFTAp70lnOixPnr
         IMjkS795QZrvf7O9eQVce8lRky7IxFoB62OuN34HBt5QkdNFZVQgZOYaypURod67muor
         SmC3IFIYjX4m1sNIpmFpg9K96ZRxCCfXLGfjWjblCzN0looK+Or+JNiguZKRdmxBgIDx
         F0Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783953959; x=1784558759;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XU2J9ywExwhM1zwy22c2Y1HK11dL7My6r4TdOxaIsEI=;
        b=GGpfOXfkekUVgPzp6QdXE7/MnxWTTou1VMH6g+GtO+LmDniNSyr8ZZ1MQ/IQ848e2q
         KCpjMqc84lTuiBz+VxWiCcetjp99B9Ay9rpATT61RxugBanaN6AZ07qIhItNBgClfkbC
         2rpvc3eUnOBFKDTBiFZchoOMM9a2szBUgh1MEEiOjIN9zpBWCrRGys2zdV+S4HZTk6qt
         hSvp6FFn2Tqobg/xv84nt+RciioZygFpwh27oVpzHAa6mbBZ9nSWRyYvkaqMTiOz1zLw
         8j0rsQ97uY7wyaIjC5ePyUCEVCK+jUXKkmPQLD3LpyGWHbOxhDJrh8zn+xFHQuf8I8aN
         kGdg==
X-Forwarded-Encrypted: i=1; AFNElJ+q/DZ/X/4debXk5DDqwyqhl6wjrCddMdbrIOeRW7E0tfrGcoyCi9jyXA0qVAjkT7x0cvuvpN1TFA==@kvack.org
X-Gm-Message-State: AOJu0Yzw08GnipAiPQPWQbLqWp6vt6k9OmIbvFvj4biEBIZY2HQKQZhV
	RORCwf3RncsDolXuupX1LSse0cTw757taPsyuGvsBJNeVNEMrhKISUEY
X-Gm-Gg: AfdE7ckClgbVqRe2LyXyAMHcqg+IUdwzInJrCUib9Fp/BYXE1zfZxIzhf6A971iYIQA
	st+pesWhtg42Huk5R+iEjVSQd08zhBSfDlJSy0QTPSrnjoJwIuWsomuBE4tAkPCk8p+6Xdn/L4Q
	oQWlv+EXbK2u+PZSlnuA4XjXkSNJqYhCw3I2AHcfWAmAGcW29Wduz/3JO+fnZUTBuxl+QTRdxQQ
	IqjVUH+zOhG7u/ESec0FsQCG6lYycGm3nxpZY7crIkKYwLFRdzAiId81b5Qhkw+uLeInCIGeeqn
	nYI2HqD8MLOrm0u+a35k4RJEDH/q3f0rn9ziK9PRZXKrrx2bibCasOiPSSCpHN04dmvwM1NpB8S
	yyc5srzfHNk7+DEK8L/UZqKvVnfG+wwV7x5A9LnbSDVMWc7cgagp+h+kR09cW4+hYHHS/tATyUV
	kqLCYJ7GKlojzHK4428Bwc5EHJsSQB+rAPU0IHHXzguEdN0WM05hmLAg==
X-Received: by 2002:a05:6820:1b0b:b0:6a3:2368:4cc5 with SMTP id 006d021491bc7-6a39a6dd434mr5521035eaf.35.1783953959481;
        Mon, 13 Jul 2026 07:45:59 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:71::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6a38e9bc8casm6715121eaf.2.2026.07.13.07.45.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 07:45:59 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Song Hu <husong@kylinos.cn>
Cc: Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Wupeng Ma <mawupeng1@huawei.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Ackerley Tng <ackerleytng@google.com>,
	Zhao Li <enderaoelyther@gmail.com>,
	David Carlier <devnexen@gmail.com>
Subject: Re: [PATCH] mm/hugetlb: restore failed global reservations to subpool in alloc_hugetlb_folio
Date: Mon, 13 Jul 2026 07:45:56 -0700
Message-ID: <20260713144557.3845941-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260713115008.937175-1-husong@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ms79m3igs9qmxhpsmie3fjp18bgyc9z5
X-Rspamd-Queue-Id: 8C0EEA0009
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783953960-554446
X-HE-Meta: U2FsdGVkX1/bCXkyTqwt3m9M4g/dCTpr4jHuOOACxHpwj7IZnYEalXOLfqNLgiOSAC0t+w/jWwa9CEslfgJVaV/p/w6M9d4ZRfLjiwUat55y2nWvf3cPYkr1On5XEkv1y2jHmgxn2GF2xS15SIiUH1UjVYuVmxCU0CMHSh+K9LT0VDvde4CMUn7V3H0Bapda+42nqfXiboFmmqZPWlrbOrUo0oiJW2ASkBNfwfJsmR2nBkBBfshmKzwFkLTcjpIjCN1fQ0C5pCOJhk2AMZG2YnlnBDOFEoWD/JLHccHw6vVgyCO1OrEFGcKB5uE3fBaOWoWEMF3wcQX8D/9LNPwfmgA8OFwXoyYCbSEKwhJNpDkSCEV/6xKg9sJoOIWHVzfzSSnwrHJ+34Nyo38qRpqtePIwUhFbOGOF9U7HNMIlzv1CTNPbZKscMJ7tXYja7eqeRBj7No89E73ZXY6YFHZddjmvYNf5JMnVXdiBGX7oNnPi0Cvk8wxPsMS7/SRIzEXfSIbQLwcbsaixj3NZmVjZCwdpP1mDRz6y1kzsNi7IPhE7DSmuOLWamNsV5o7lJVq9376fuOBX+JFaRkUbjAKs8+6RA1eZe+AarV0GATiB34az1C/YB0Hu54mAbbDLEBvY50B9JcT4rcQ5tb2YSDBOrHdPCN9OQ1ZEwXtuTKPxjcsMQqdOlxUq0gkQ+TadDkuXd2VloVFiJpQPW8bqMOwEQUJF657q8qGqwftXYym4VvoWk8Ry1oqjgNBfpqfyKtOkkDHVxtV3Z7h9I5UwALvNwum2uVloDvFRfXL1zsrUOOolmgxnW6ui2BBfFj6r4TMMvBUTTDsbZki+RXMbBEX+570GHzxPo6ZPZ0c8z7KYEDbB5tofv6FxV465AN4Vemmdq+r/a44Dgy0art09ta74JqABa9SuqowWEiWG4b5u+P9uF7BVqPawOpsaL9y2PN/GRtxMbM3ePw63rrKfIUs
 HB+7sApR
 KSTUkx+IE9qTpIh/cGgusC0x9n83lxIPOofHD2YEUNP/+Zh3NlsCJ7tq9zxxYaIYzFjQcziTJPYM0IoPQ9YVa+jm07/vMA6NJOOGfab1R9qwxajcr0lqtS/xMAn+mueNfwaiQq0EBqGsUAkEi9OBwK01+w5Om/wqQdND7GC6+eQgPc7m7K4ZN+bj9x7wHugqkLrtmcUjvqP+vnfwlKHQVDJlr/eMY5XTICHZTX6qBn6y47Sot8Wus9bkdA/3HXsW0Twx7d56RVh/kVAWTosCV/zttrUEftH2JogKKOCTfr438mcqUflyJ+U+Vc0xSQdKDtS3EoeN8CntnXJD2r+XQVeZsGG5BHCiDtrU1FCW3h96/WEh0twTzUjldKuCzCa4ywg0uOQJgmu/g9B1YCC7eYq5kKEEXx/onn4M0smJRuxPZAX0Jun9sEdQ2Vidsz8kqpa+zDXqqGim5CsZtXyOn6YBa5AO2l6MxOYmbucsXQhPajll7wDBTMpfLieKzze01B6r+jhDUkKkKpURzubuk/htuF8Pe3FLt5zvMUsrkcf6F1dzW1zTOMiYCAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 13 Jul 2026 19:50:08 +0800 Song Hu <husong@kylinos.cn> wrote:

Hi Song, thank you for the patch.

> When hugetlb_alloc_folio() fails, alloc_hugetlb_folio() only rolls back
> spool->used_hpages in the out_subpool_put path when gbl_chg == 0. For
> gbl_chg > 0 (e.g. a size= hugetlbfs mount), hugepage_subpool_get_pages()
> has already incremented used_hpages, but the error path skips the
> rollback, so each failed fault permanently leaks one used_hpage until
> the subpool is exhausted and hugepage_subpool_get_pages() itself fails.
> 
> Decrement used_hpages for the gbl_chg > 0 case too, mirroring the
> hugetlb_reserve_pages() fix.

So something is clearly wrong with this codepath here; there are now 4
competing fixes in the mailing list currently being discussed [1] [2] [3]
including this one and they all do things slightly differently.
Let's please agree on what the correct solution is, 
I've CC-ed the authors of those 3 other solutions to discuss here. 

> Fixes: a833a693a490 ("mm: hugetlb: fix incorrect fallback for subpool")
> Signed-off-by: Song Hu <husong@kylinos.cn>
> ---
>  mm/hugetlb.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index d6c812d1857b..8413ec92d836 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -3073,6 +3073,19 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
>  	if (map_chg && !gbl_chg) {
>  		gbl_reserve = hugepage_subpool_put_pages(spool, 1);
>  		hugetlb_acct_memory(h, -gbl_reserve);
> +	} else if (map_chg && gbl_chg > 0 && spool) {
> +		/*
> +		 * Restore used_hpages for the globally-requested page that
> +		 * hugepage_subpool_get_pages() counted against the subpool's
> +		 * maximum, but which we failed to back from the global pool.
> +		 * Mirrors the fix in hugetlb_reserve_pages() (1d3f9bb4c8af).
> +		 */
> +		unsigned long flags;
> +
> +		spin_lock_irqsave(&spool->lock, flags);
> +		if (spool->max_hpages != -1)
> +			spool->used_hpages -= gbl_chg;
> +		unlock_or_release_subpool(spool, flags);

Why are we unlocking or releasing the subpool here? 

>  	}
>  
>  out_end_reservation:
> -- 
> 2.43.0

Thanks again for the patch,
Joshua

[1] https://lore.kernel.org/all/20260708-hugetlb-alloc-failure-fixes-v2-2-c7f27cbb462b@google.com/
[2] https://lore.kernel.org/linux-mm/20260428113037.88766-2-enderaoelyther@gmail.com/
[3] https://lore.kernel.org/linux-mm/20260515202902.461539-1-devnexen@gmail.com/

