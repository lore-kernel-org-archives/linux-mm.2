Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75F7FF9D0D3
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 15:00:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74A836B0088; Tue, 14 Apr 2026 11:00:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FA936B008A; Tue, 14 Apr 2026 11:00:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E9596B0092; Tue, 14 Apr 2026 11:00:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4E1216B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 11:00:09 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D0F251356BB
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 15:00:08 +0000 (UTC)
X-FDA: 84657471696.06.529A1F3
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	by imf13.hostedemail.com (Postfix) with ESMTP id E822420008
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 15:00:06 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rbI0AMxy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.49 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776178807; a=rsa-sha256;
	cv=none;
	b=GHHCovjdZHpS5LkZLdXs0pX1oakcxGYKQnskfOuxd4z4u+wdK5ZDqC6RwoJvSeCZYhxpuc
	/W964RAGmc0VI6NL5sO/K4e7Of2bvjxzK9pe4s9RDK6GadqsrBD20WPb/H0GMTOchm9rzH
	O6Kpbot3n6GYPlFfC9OHn/QMTWEVd8Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rbI0AMxy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.49 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776178806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4HhNjSBI2VaOj0qFbdmW6uKns8Ks8XYfh0+PT8mKMJY=;
	b=3ynw8lxhMOzR70uy0DZ3Tc4s4Ntxh4YRqwLTSHxMYExL1ASDSAiD/w0fe11JnNxqiqSe/2
	EnHxO2FCvo6m3fyxrCVL9AE5K31Z1xLimeCPlirbBKP/ZwSIfolPVR4bMVp4I74kZJFy+F
	GaYbCZaG58yqVndMaqAGYH2klNa52+Q=
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-7dbcf927395so3328135a34.0
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776178806; x=1776783606; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4HhNjSBI2VaOj0qFbdmW6uKns8Ks8XYfh0+PT8mKMJY=;
        b=rbI0AMxy4ynJlIR7iXLKOozmeyOc/fqKv318hd4mzT0KAPwHLyExRfG0rClOF7H/ET
         IkFpQHY0I28YAI2fIYLALDbY09p6h7njbrdz+KQMZcjxX0XUEnI6SLKBc7dhkV4hsNXe
         ua6REMfqo7HbFnL+xBJruj4GkmMuRB5XetxTHDTsynt2y57J2aqmDiCKo8bD3fNSA5MK
         p9eUuUIHlKdk77sOp+9pVNIWRhLX+2Ra+N3CEjZA7a7rKB453CxEUzC0WahE09npm3R0
         c5+7hNEWZ5/FSOFOSPRaFUvF0x6HJ+oQpE3xBMsjI7Cjr3iHGqq+oL2rl8pD4L1cYFNy
         RS7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776178806; x=1776783606;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4HhNjSBI2VaOj0qFbdmW6uKns8Ks8XYfh0+PT8mKMJY=;
        b=Cz5eKL0hOrhpHkbcwqT+CuJy35sQ77+ByF6tP6GFSOyAiIHPQs81RGzT0n89NOzMsW
         T3qxVIUPSQgzRqdCsrq1b0GOHDefN9eC346EfJjrXGTDvUCEt2YNGnVc9W42QxfxHano
         yiKuVdgOPVzg0UbMl2IUuUmJmvLxnMHeHcFnwRb+EBbW7JZQQztp+EbLl3agCkgXdRCG
         7ws2XyNeAN4hfbhBzTcKMQY57Tl6nBWyAMzjS/FswsIJDstZYoOiZvTjeNaO8GR9UHyw
         HpZBZVhte6EJbvjwSkCyxJOq7tT1Or7V6CqWU3iLmLJrVNhJwhTeMWZ140uvOuZc6O5t
         F8pw==
X-Forwarded-Encrypted: i=1; AFNElJ+zZFDZiLok+vYSYd+6ynLf3h1y1yZtauE6XXBAY/ydG8B5/gJTnXTx1mjBSNOa5FrCrlc7MYTNiA==@kvack.org
X-Gm-Message-State: AOJu0YyBUHp/+Y3gqIliyvx5biZAf022bYNcPoByH3KfPGQDgirhsRvD
	RNIXH4DM5QNKAM9yElasn8L0nhUqMnvFYzDRWkSPOJpTXAiPGaY+lhgK
X-Gm-Gg: AeBDieuDGmqE4qC1Wd6fUO1mvI3a7trAWaFvAqQsNrTNoCpNW9AiR9tEYMSke9NyZvM
	2NZXzlOe0Yuw888/I6zZh4F042EozQmos0fExydi8DOiRgP5I0TOMNaWtcmTS8xTfNcPyCH8js0
	ZCOuhB3KywXvXGhKORfYiO7vsH3v7X1WZqKt1M4SOuEWm9pvSRL4nQaV6a5HWu8+yf0dlvIR+p6
	XX5U9w/O+nBB+Qg3djRaS8M7iqq0klp8uSehxBYTMyvBSeeW2p4XByMVhP61wFMYWOnbhS9eclO
	o2TVlbuqfZiRi2/5gVB/9+nONmoDTrs/mVxPOxqUy80JXDGOu45r25qZQWYV+ZwrXQIvyLUKlay
	teValZHSaoKHFOYf3on+YIoRmVd65hR+RU/imIT/w/yQcLcJvIYIGEn12EhgKRg0Nnj5it4waAN
	jH/WxAalNYZ7BKDf34y3/48A==
X-Received: by 2002:a05:6830:488e:b0:7d7:51af:4aa1 with SMTP id 46e09a7af769-7dc27db3792mr10373819a34.18.1776178805691;
        Tue, 14 Apr 2026 08:00:05 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:54::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dc265c2babsm10705351a34.7.2026.04.14.08.00.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 08:00:04 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Ye Liu <liuye@kylinos.cn>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/4] mm/vmstat: remove unused __node_stat_* wrappers
Date: Tue, 14 Apr 2026 07:59:58 -0700
Message-ID: <20260414150001.3262806-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260414091527.2970844-4-ye.liu@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9z4mnh3m68z7hgoo765bk17femetyedp
X-Rspamd-Queue-Id: E822420008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1776178806-33407
X-HE-Meta: U2FsdGVkX185TeCRz0+eM5qXF5Jbrm45j8f5U74jdQ3NIkHH33RBtyg3XCx5upDYILWvuLuAUDjdugA4PONXnnsissy19icVpAfqxWi1SgDTjpxS/zEkq28jLQu1fMyIXG68WlI2ha6aXonVRd9wwydNBCEQkj42nyInibURnp7yJwyZA5ru0eI3QSv9YBeBYjAvTWdXznvGKpQxSA+CdqUxNTfhibKPzw4NH/25fRdnWYxozODhW/pXpfm/WaFdRQ5EDCNuqGvJGolrgKuLKqkXQf8HQkuhUH1bXVLnSLzkRhbv1soRBhZqmnMNliXPxIbJdLpj+PgDckt/kVV3swmOs9O75yh360EEHz9jFmuXegzqE50LQ3oV0ca0mQtDBRR+mweFhjR0y05aQrMHKlmtJVPFGvF9XkczZ1zLKwoboNPk2HxoS6YZMtHh6wMcFbadem/MkBw/oWZrQXNmiKYAXDHIdY3pdYkhECj0LgJVg/06sPAAsBQYgQGteZuKMTKCAjBerCoOhkkabbMfwzTFH1OYGUT5fO+N42HPCI7M7NkeAc/n8o1Wy5oB3hcZOjL4WIwZpYWWdE+nuzzriQJBqMDLNZtjY76LnPvDFgZu8OFC/qINrO6gBcxzOR4jHyJ6tA8IhmFkQJ4HQB4kn3Cgh6t2fpreE5KPnU+4gvaNSZt6hmZHQMnbr2/00PuNr92eRSyzu4lnLMzsrLTcDcig/kO5JtOcs7+9kYzZngaaVM2/MGjQDZH/AAwkljYD1p5aqagWugjziNvvkPiL4S7A2vVSvW3tEoJMcp3ZuFGi1qapKF+6V2z3UN74Iutqt/NTHGHTMIDgk7c24EoS436XeUbY0nfiV1oU/3uXupXanIep+EzsGlac20Vsb/aIqebnJPjMEdhCAKwNVmRumtnI4F+m1qMMAiZWudCRwFHnVMThukeiMKtWE94loP4tHC5bWgT6ofOB35gWwCE
 tXQ7UdU1
 BQOtbZXwKDlyNLty8uXckjnpP/bc+7h6e05dBGS3+UWvGQdzET0F6x3HIWFsaOLh4h1yM0Ehivw1PQwyLSt+AL2WVrVtwsv6Co/maxbv0ZQlX96OwgSF92LoaWHqlGJzkndjKfQ//3o8fhi3Mxq7cmJ3hxuZn306DknvefP9b7OMTAIOYdHjVkVdiy6xpZljUaOP15bgrKHFdPViTh5VgmgvUrISoaZukK7dQokHhggI9mjQoMM+ZqaxlzjWENTCOtDlzWoLkzWOqBLZKtnSdq/PobioBOvbDvrF4DFLpccohuYbG4xRrIaU1CL0KKYux9FUjUS3zMmDJ8Ns77WdLcz/ILCSJ5wTIsXUab0k/ljIzJksCoXjLxKVbrLgyYJJuUXW1q/d44RHd/J9l38PrCZwYzrh/i1kNxDLyJMB1JCGEbFRk8gmGhsw66hi2m0fFVhOTIZwuq3BLr1ByH7FcyFs8rVz27dbcyn5aRI8aEoqYzrEghhlLOe/ASHoYajv1HJM3dLzEgd3b9Pjr999weAAW9Uyg4HDJOk4XUfL7EIMpCjHUitQQqKnYRjoLf8681Vl+MsGYUBiLdyOL8bIxSYyUfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Apr 2026 17:15:20 +0800 Ye Liu <ye.liu@linux.dev> wrote:

> From: Ye Liu <liuye@kylinos.cn>
> 
> Replace the single call to __node_stat_mod_folio()
> with node_stat_mod_folio(), and remove the dead inline __node_stat_*
> wrapper definitions from include/linux/vmstat.h.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> ---
>  include/linux/vmstat.h | 18 ------------------
>  mm/page-writeback.c    |  2 +-
>  2 files changed, 1 insertion(+), 19 deletions(-)
> 
> diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
> index 3c9c266cf782..54da7d820f78 100644
> --- a/include/linux/vmstat.h
> +++ b/include/linux/vmstat.h
> @@ -440,24 +440,6 @@ static inline void zone_stat_sub_folio(struct folio *folio,
>  	mod_zone_page_state(folio_zone(folio), item, -folio_nr_pages(folio));
>  }
>  
> -static inline void __node_stat_mod_folio(struct folio *folio,
> -		enum node_stat_item item, long nr)
> -{
> -	__mod_node_page_state(folio_pgdat(folio), item, nr);
> -}
> -
> -static inline void __node_stat_add_folio(struct folio *folio,
> -		enum node_stat_item item)
> -{
> -	__mod_node_page_state(folio_pgdat(folio), item, folio_nr_pages(folio));
> -}
> -
> -static inline void __node_stat_sub_folio(struct folio *folio,
> -		enum node_stat_item item)
> -{
> -	__mod_node_page_state(folio_pgdat(folio), item, -folio_nr_pages(folio));
> -}
> -
>  static inline void node_stat_mod_folio(struct folio *folio,
>  		enum node_stat_item item, long nr)
>  {
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 6f9b7b081ab7..ed3301753e89 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -2627,7 +2627,7 @@ static void folio_account_dirtied(struct folio *folio,
>  
>  		lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, nr);
>  		__zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, nr);
> -		__node_stat_mod_folio(folio, NR_DIRTIED, nr);
> +		node_stat_mod_folio(folio, NR_DIRTIED, nr);

Hi Ye, thank you for the patch,

In addition to what Matthew has pointed out, I also wanted to note that this
substitution isn't trivial; there are differences between the __ prefixed
version of node_stat_mod_folio and the one without. Even though the correctness
of the two versions might be the same, I think that a change like this should
be supplemented by a description of what side effects this change has
(i.e. introducing additional overhead from the cmpxchg loop).

Thank you, I hope you have a great day!
Joshua

