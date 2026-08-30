Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57304C61DB9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 07:45:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74F746B008C; Sun, 30 Aug 2026 03:45:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 726ED6B0092; Sun, 30 Aug 2026 03:45:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63EC06B0095; Sun, 30 Aug 2026 03:45:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 331056B008C
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 03:45:09 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B0731120150
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:45:08 +0000 (UTC)
X-FDA: 85157149896.22.BF58805
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf30.hostedemail.com (Postfix) with ESMTP id D661180003
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:45:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="RZtfM/AC";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788075906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dnQmRfOj9jURwrL7DeKDSG0H8W6p70+xYqiH8s21HTY=;
	b=abRSOBkV6c8TEKCLTzOvwKRF2gXtXDGn9/Hfijl17P0p0LTKlyEnNv7J72YzT9BCvGweRV
	RxCgN1sxMs7PoGBsPEHM2VX5F3VEj//aBDIHaxoZy+odwq+nzl1Aq44ODiiFo7xrtsL+Fs
	jUx97kZvsnUdn/lZyIvFVptDYMq+gKI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="RZtfM/AC";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788075906;
	b=Mpu3tW6F4XZduowLXiemaNPpTXjaCR83OgacUpM2ubvUc4x6evn5iueOm9D2BW94rS/E8D
	Fyg1NQ9knyr54wxbwKUKAWMlyPTaCz4tmJ64StgL4IsgRsIW409GQxJuTbVKJ2Mhm4tOep
	bBnbufGRg5jFsKos8GAT/sw2j57EudA=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3964dfb5b9aso2538538a91.1
        for <linux-mm@kvack.org>; Sun, 30 Aug 2026 00:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788075906; x=1788680706; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dnQmRfOj9jURwrL7DeKDSG0H8W6p70+xYqiH8s21HTY=;
        b=RZtfM/ACqZ62SfrICJrn3cAJ0Tx83rmYtpXfB5sqsirvfUSI+KKySO1TnO4VVikj7O
         6TFKe0jZwEMxy0knTZ4QBQ9Oa0TrTMHkLybwbQ6VbjzA/TBy+BH4Dz0RYZ+oGxu64aK1
         U9IA355zO3OD4Ifngutv50f7ARUy++e4GqbadPNjMwEf006M4Snr0ayVYhmbHUCmO2sE
         gUOw5rbN2WEVOeQgD/zkhkoHyGKoCpeJRiCAfS54xbidlSbaedJ53SPzaeBouRVPw84V
         WEJBYD7RVn43ggL8Lcbc6OOSdj7nMfm9n5I+5axfrtBPNk6sd6w+0i4cLUExTFxfivoV
         5XrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788075906; x=1788680706;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dnQmRfOj9jURwrL7DeKDSG0H8W6p70+xYqiH8s21HTY=;
        b=DgqrInu/C7UOfbKKgjCuJhoLiKqbpQG+xv0+GZgcPJBzPGXIwBcZ4u99pc8OPF3SmH
         zU/jfgvwO6g7CDcLi+va7Gl5dzIsLQU/wV7roUGpDfqcC4d61CVq9JAgD1cbFNgG9PWb
         RVLJHsmnR7o06qy0S5tQVs6cHqlLbkl9jzOtIKE01EeMnc1gM5FXANv7f2sSS/xvzyky
         wxCX0ukGpprE84FQdqJFuJXqohdX9Zu+to1l9jvwb4xrLLe/fcAvN1BotKy13rBM9r8b
         0tqv4uGltzJqRCtA/fMmDIz11wxAM9VV+VraazaOP8c6+DO9XiqgInAAgChdP9SramZy
         kzaw==
X-Forwarded-Encrypted: i=1; AKwUvBwFdkOYOTTEBMt8qGYaQYPuyNiaxlokdCuYaEFOcnZpSrMOpfA4yVHNMGikPOEmDX5njlbrkM0haA==@kvack.org
X-Gm-Message-State: AFuF++nEp5vI2LL5FtkDjDDr06maztN/GNo2wQEvo+DzIyL82WquJYl9
	JfeBbb/gmDE/1QfzIcXOP6l/mtx40SdlpJ+2Cd6K45HxTg78ciO/QTff
X-Gm-Gg: AYBFou2/DGMSLDMmgWbhtXEIXP6xTqub7wavP7rPqh2JBGp77qpdo8j9nLiNSrUTWOK
	DU7PI9KIaqRWGeB5nrhtPWcjVLordt4Pa/jSIVIjy8bUt2PZjKC5vApR4N8kGcgLuspHnJ8rpl/
	C95A6Y1/YluXt332SyrruWePgmKXi+Ytus8NcBG5LjzKhWL5Z1+7PcsY9ondq/rtcvM/odVqjmB
	fHQjoAgG5kDKF4qow0ZurJ/cg8XrBMp60Bfj2EWOZOF6CREWC52rAGJQkDF6P+2piukNKOarPE0
	cTDTTfNe5Z0YZ0k0GSTz3+cQQ2/ORFjJR1B1zLkMcPeaJL1y9qOlEraIqIdVZ8X+3eX80XUFjYD
	YNHiGY3j1s9AI/s3tz1HpezIRrpoe96mWeSDZZmshni6jQxkQv8xaZVNSEmUaZejO29T2NlXnzL
	g0lwhjMtKf+jRU4sxZNU+MlLh09mh5q34Itajcz61fLtQhInwO7cWkoQxIFQZv3RLSGNU2nXVpX
	/a/ue3MpCOy+PYC9FEXEiiE3W7U
X-Received: by 2002:a17:90b:1d05:b0:396:65dd:4093 with SMTP id 98e67ed59e1d1-396d0ff519cmr30220142a91.14.1788075905659;
        Sun, 30 Aug 2026 00:45:05 -0700 (PDT)
Received: from localhost.localdomain (vmi2317720.contaboserver.net. [84.247.152.65])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396b186809dsm15145238a91.10.2026.08.30.00.44.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 30 Aug 2026 00:45:05 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org,
	lianux.mm@gmail.com,
	axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	chenridong@xiaomi.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	stevensd@chromium.org,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: Re: [PATCH v2 6/7] mm/mglru: move folios from oldest gen to second-oldest gen from head to tail
Date: Sun, 30 Aug 2026 15:44:38 +0800
Message-ID: <20260830074446.79916-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260827234704.63163-7-baohua@kernel.org>
References: <20260827234704.63163-1-baohua@kernel.org> <20260827234704.63163-7-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: j9geofhp6aw4n7q4c7xkua5iocwwrpaw
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D661180003
X-Rspam-User: 
X-HE-Tag: 1788075906-373293
X-HE-Meta: U2FsdGVkX19E2VM7p2GAYNUL1r17sPStnA/8FG+LEGmQ0JNuOHBRv3gNa3s45aGQZ8m3nuKmTeW/IDbvYk2qD7e0gHI/HdbuqcoiDgMf2uT4i4v5PpqMe7H0d3h+27HscvbPPXiwJjZAz3RSE5nEffsdJ1x9A/Ah2zQxEtSkfODCm2vctc5iLv8QUlxbhJZc7pJO34byCvo3dHE6Q9gGRrh4PgiDa3rlchN0Xjt1xZsMtQZa9K0qk7ifWLApW+dl/lXpdrk44+UGKb82k50fMz8fGJcFdgOAewtqy530Q1EpCOsJUuD235ecCo7GAisfFWybaHAO7qFxMZ33CBNluJPPqcqSAB1uCRi9iGYYy2B1L7lyllNFRazzg7LH16rS3ADHLxznx9MYjAoT2538vSWtzVLVxOsrRaAgc1gW2xYj+fqcozAPVHQNF1gkxuu/QJKuYd64kh1kmx/D/kc7bTZsnYeu8l+byul5q6Ss2LvZL4u5uGGIObRjamqA1REoJnVJ0eGFKXseAnXbyEMDpJaAO4v4qCLWgxsf6PFHT35pSQgSX2ofyOorUlQHMo1ZEHKIwRqiBOYUEs1LcxfW4C09sJWg9lVZJ7IIKsFqw8XE11o3/0o2ReUZmj9XzAUVXbyw/3TPPXCG/D8JNTh9UyNj00zgtpR4ilXwfRezbpXGc7LfANO0pd0/KUa+ZYMV8hedTZAgyO2KEvzVc7t6qLIQQb4tsa0mbzImOo6kTNhN5oE2f345z/F+6+YoZPuvRddMfuuejR22Isv5n7rK9ow0CInIqApb0Efc+dajtkp1u6ymbP04Ld7w8T3qHTH7t42/K9/jpUOp9hztcddHz8Tuhs5zKUTfWzGN4Vi6mGdVE3IHpkV+OR+oqbQe8nUSveoXKwg1rulGjCAWAZkzHClPNKcVUtsNJRlgawTWsPbCWgoqnl0jz8c9S/YUbBSNASc5svUsA8jmdvz+TAj
 fGz2IOLO
 Vns3+n4Qv/rs+RxgHhik3+GA/GCDIXMat0HuUa03+jJX4WLHsX7Jqtozveq0ldt82xKmB+x+mgdUb43X0rsQncuFYT1dacFdLH1AaTmIqBzOu2nboprNmdZrpbhoYPeXfNh0yFA9bxfrlMOKhjybEAhdoVXmZF9/PChm6lg22YqDK7PSI7gFhYxAF7OJY9Vyl4/YRghlcdzVH8NL17/UdFSilgRpuMLKkxqqNHhubAVKPfHfhNCK2ebx2dFmO55MrOilwqzNtwfWYXXmIG47EwyZMRldjPsPcSzchrsMtNg9YBZ7SKz/hwUcjOxIsURkS1WptMrcfR+otnMQMotCVq/aBlmljrttGQ6mEm8hN6LbobiO7i97qxs66sPIQc67Ujl0hku4gpezjk4nabfWC3GmEK/E74TY2vB9QMxaoMOmWOKhTvvN1pzhe82pUHNJ1RAU0mwx7ix7GF0bb26jfHDU5sj+juO7RTRzcne0r3L+UPdwrLGOK2ifEusGLvhn9nWwgQg9El3xMjio=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 28 Aug 2026 07:47:03 +0800 "Barry Song (Xiaomi)" <baohua@kernel.org> wrote:

> For reclamation, it makes sense to reclaim folios from tail to
> head, as folios near the head are relatively hot. However, when
> moving folios from the oldest generation to the second-oldest
> generation, using the tail-to-head order would effectively cause
> a cold/hot inversion.
>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Reviewed-by: Baoquan He <baoquan.he@linux.dev>
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> ---
>  mm/vmscan.c | 23 +++++++++++++++++++++--
>  1 file changed, 21 insertions(+), 2 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 81f95a968447..17524e96fe64 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -192,11 +192,27 @@ static inline void prefetchw_prev_lru_folio(struct folio *folio,
>  		prefetchw(&prev->flags);
>  	}
>  }
> +
> +static inline void prefetchw_next_lru_folio(struct folio *folio,
> +		struct list_head *base)
> +{
> +	if (folio->lru.next != base) {
> +		struct folio *next;
> +
> +		next = list_entry(folio->lru.next, struct folio, lru);
> +		prefetchw(&next->flags);
> +	}
> +}
>  #else
>  static inline void prefetchw_prev_lru_folio(struct folio *folio,
>  		struct list_head *base)
>  {
>  }
> +
> +static inline void prefetchw_next_lru_folio(struct folio *folio,
> +		struct list_head *base)
> +{
> +}
>  #endif
>
>  /*
> @@ -3938,10 +3954,11 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
>  	/* prevent cold/hot inversion if the type is evictable */
>  	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
>  		struct list_head *head = &lrugen->folios[old_gen][type][zone];
> +		struct list_head *pos = head->next;
>  		long delta = 0;
>
> -		while (!list_empty(head)) {
> -			struct folio *folio = lru_to_folio(head);
> +		while (pos != head) {
> +			struct folio *folio = list_entry(pos, struct folio, lru);
>  			long nr_pages = folio_nr_pages(folio);
>  			int refs = folio_lru_refs(folio);
>  			bool workingset = folio_test_workingset(folio);
> @@ -3952,6 +3969,8 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
>  			VM_WARN_ON_ONCE_FOLIO(folio_is_file_lru(folio) != type, folio);
>  			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) != zone, folio);
>
> +			prefetchw_next_lru_folio(folio, head);
> +			pos = pos->next;

Saving `pos->next` before moving the current folio keeps the forward iterator
valid. Across partial-batch restarts, processing from head to tail and appending
to the target tail preserves the relative hot-to-cold order of these folios.

>  			new_gen = __folio_inc_gen(folio, old_gen, &gen_increased);
>  			if (gen_increased) {
>  				delta += nr_pages;
> --
> 2.34.1

Looks good to me.

Reviewed-by: Lian Wang <lianux.mm@gmail.com>

