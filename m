Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BCAF6082BC5
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 09:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Bj3FnFLJ
Received: by kanga.kvack.org (Postfix)
	id A1F9A6B05B8; Fri,  6 Nov 2026 04:35:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CEF56B05B9; Fri,  6 Nov 2026 04:35:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C6296B05BA; Fri,  6 Nov 2026 04:35:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 648CE6B05B8
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 04:35:20 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 763651C47B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:35:19 +0000 (UTC)
X-FDA: 85404185958.29.3F0C5D4
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf15.hostedemail.com (Postfix) with ESMTP id 959C7A0005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:35:17 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Bj3FnFLJ;
	spf=pass (imf15.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793957717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e+beHwPVnOrx0jzUBZNVM2/8fCDJRY0y3tTo+TmZt0s=;
	b=sdUHcyslXSN3gtGEQzw+ssV5tna6TnwL959hE3llzscWRKbfu4++aoukVxS6yKP9ebPK6y
	6q9HEXh+un5keVmB7QdnOhBtOIepeTBo5qY/q4/ixQQD8opZKWYfwUHIsLNmEixtYaoZad
	dhd1bBTOuq7PqTVa/xdoheUclPjSCvU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793957717;
	b=bE7fk8tvBVJT9NZ+bpWy3ZGUODLyRvHvOxHIh0DukLeT7UMtkXXBPu87EET1FZjzmR19Dn
	1kfZmdkWaNjvJWhxyV9KL0PqCSi9kWKEel7aey2wYI9dpfwfcFpynkKI3VEzXDP9StWVO3
	50QmnZL7DxnBiRoCDshUlZoGFoX/++Y=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Bj3FnFLJ;
	spf=pass (imf15.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c49c32650adso52682366b.0
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 01:35:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793957716; x=1794562516; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=e+beHwPVnOrx0jzUBZNVM2/8fCDJRY0y3tTo+TmZt0s=;
        b=Bj3FnFLJgpM0vdNJSZ0JOioTukvho24jvA7gh6IschoaWRw8oVAltrf9EbeuaEJoud
         TRetqDFhtpaYj/EcFLQsc5Glt8qY0fSCFBXrnKN0VAZkAj3qpU2FN4VD/Mtj3DC3WkW6
         wUcgddoYBKZ0n+ii2qShHSCpwPlyuax1hZfTSVHbNrDHZv+9jvlm5+dmhknkiNa6aQV0
         YXmwqNxjc2t7hmtGWzW4qUfS0RX1wJf8GKn69pjO9Q6c1hWfqSQBz8Lf4YFAd38rRrZv
         V7pf4w+LMfMf6vkWILjYCGPK37aia78kqmpOT6hJ4KntipzyyHJl/HjV60vVnQ2pDjBA
         7Zug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793957716; x=1794562516;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=e+beHwPVnOrx0jzUBZNVM2/8fCDJRY0y3tTo+TmZt0s=;
        b=WjyNm3TilglFfGRwj2q/Iar+WQcom3nPJNcukdWVixEAmZ+zjeBVoXEV5wr2ykVETG
         zQ36YPs1o1TUSlTN/qVybT5jw5YvfIAonPX6QIv8AueKlm7uNeXIyqHtd3tgiE7d7hri
         /IOpFCSRxDYx+01jOAfyDjwzVmPk5IcwVzFoF38JKfqJYmqyn5mLlTVlXiEnkrok1Z9b
         RptGpE5HiuJkc3rl0wQQXOarFgfQjkDBO8Thd8diW+MPWKtsMDHpYKYdqW7LmpIt4tHJ
         jYP5Ut+ECiD6psG86SC6WWiLB0QRonHwNf/7z6xta3PsP7mkoe8oo+3IvJpKypYw2L52
         ffKw==
X-Forwarded-Encrypted: i=1; AKwUvBynT64AUB7wKr2EmfGUXTEs9ouV2O+w/jsyPQaNglE0SWsrfHpUvvdXX44VFR+E4DciS2AoSu1JyA==@kvack.org
X-Gm-Message-State: APuU4Z+SZ6+yIW4zENgpVYg2b9AWenzAVcBtkBHbXltF/EIhD7auBzQb
	ej34SVccjj+pK4ymHViwDps7wD0wxHP032D2tHfkN5feK1bD6rPKVedq
X-Gm-Gg: AYBFou172V4YHmBocn6C5KnAQ0sRl97xRz//NDWF4/88X3vvAxprABoz1CguUUZQKCH
	nRL28hj/thCOW6ojQLGm/LH3R1qFM57NjgIcO0Km10BSy77ONLVoC/dXVdRscPz4Ut/m7CGHDR5
	p2WUceZjRCkJRDSB/hqak/wzESsIFcclsmcIcrt4H+eU+5IKSpqtK4P2JRd49UEejTTsnzDffFp
	2hsCrx3QxydsxpHnLctjGc0pXFA/gjOPvbY5u5aNGzGyPwESp8I0qHdqaBaj+2sgHI+wlysfuW8
	Y/ev1ysvinmjL7OKrMWPWF+knBlriiPZYCprH4VuBEJsQBt7Uf5hhlBkGZBMkmd4H8ZeML9DTZ3
	DybjpiFOM9R4YEN4IdCv6iUnfjnTgUNrAyd489d6TdCey3XhyxzqNTaCW98bsSuUZu8xPG3BD2p
	td9DifMhWdmU42hVVCDVJ5g7wKD5ELw3UQrMr1rt0h3YXgTeMOARrGDZXRmt6pXPv5Jg5s7hGam
	gikP0Xrmt+1z7+b0QS97Ez/l50qn0JreO8pQGp1ux0rGnoIACWW8tuImauu0/NhOvkC
X-Received: by 2002:a17:907:a892:b0:c3f:153a:8663 with SMTP id a640c23a62f3a-c4d34bdd8camr155235166b.23.1793957715953;
        Fri, 06 Nov 2026 01:35:15 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4d35670169sm65381266b.42.2026.11.06.01.35.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 01:35:15 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Fri, 6 Nov 2026 10:35:13 +0100
To: Zhan Xusheng <zhanxusheng1024@gmail.com>
Cc: vbabka@kernel.org, harry@kernel.org, urezki@gmail.com,
	paulmck@kernel.org, qiang.zhang@linux.dev,
	akpm@linux-foundation.org, hao.li@linux.dev, cl@gentwo.org,
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
	rcu@vger.kernel.org, linux-kernel@vger.kernel.org,
	zhanxusheng@xiaomi.com
Subject: Re: [PATCH 2/2] mm/slab: don't queue the page cache work under
 krcp->lock
Message-ID: <au2fUYzBLv3uvj_2@milan>
References: <20261028134647.3176080-1-zhanxusheng1024@gmail.com>
 <20261028134647.3176080-2-zhanxusheng1024@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028134647.3176080-2-zhanxusheng1024@gmail.com>
X-Stat-Signature: fum6ndbb3bhicr17s7bxxrdjwti4pc8g
X-Rspamd-Queue-Id: 959C7A0005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793957717-820121
X-HE-Meta: U2FsdGVkX18/PKQK5jLG7B+NsMv8Kaa/uu6T7s9y8wxH8RxGkQHzSDIdAwDWLj+TlC/7At/zrWKtCyNoy5Pj9rhG4aohSoXHNlikc4DIVNIIGu/WT2K3SFK6Wbjg4PDFhAcymMOEAVJH841Jwfd+F9rLaN5rzgGNlTpSZGKoUe6mkygmhR4CVDgs4aZAzTts9WjtUrpN2WRCMOOnlXKRvgSxpLhozYXehFxwAuHXhRPvVgBjO42JQoeK+J6jwIWNXDEEoFjSl2h960Q8SdujjX3eLlp/qCHdmPj/zn3vmhB2L9Ofml/q67DkZsNBHkJtZxt5goGFBaz0Wwj9WZ1vIRhJVMxQajpewkXNVhNXpiJy9YqeE/cgzjh0uIWtXUm3lMVjkOgeeqZjW6/lgFlSqrPcmaOTvVJ4eNghbPTXFs0ZZpIULiR2RlIrWmZ4Fl02IAt8JHC25KyiJNhFcuodD2TOgGphKK3vvArHOUgZtaMSQD6K2VUPZ1oPoP2hkgswCl0h1T0Rbo06Os5TPD7+iikCblTXBqqEb/FAtPGgkIfUpvhRxFmHP+IfMxOjb63sQz/kguqikkMJNY1SXQGj3Zhen391P1f5kSw1s/906DOnfnyznQ/CYEwalvsuQo5xQNcK0zzpROTI9ysB/MhCGpry9m8JXk3Jo1YDthjFEDXhIJ38/3GiSD70SZvUxFmEmb20qG+AW0gevXbqMHIdBzB3hWEibOyX6HZXA+tdyB01Ag2VKGX4gG7b8G378diV9JVhF2ZCVQD4TpBB/m9f+82u4P9a4YMtAD4VsZ2bI5rs3PjqWrdxi2N8CoI89EZEft4sR1l8tc/Yj1rgf6pUUp6VaWUCpPXbdtRbNH18qxnodpOFaq5KTipwOp8Qd3iHga1VHJ9Fg+thN9Tc/P1uGDKqKs5fhHh0Pb28SpN3yIeVtrQiPn0m7HiYW076tY6b4HaZAjXhOKn+XI1VYda
 XbHfSEBh
 qYMnpawnGBKwM2z0mX+nsJ5vg4YrpYJI43PFT34Pwfwe0ECvCFbEnelZrLtmWNCrYGYZea6ol09GgqAPEgjVFOkzSkf62WkQaIPWih/wHLvTG5lBTj7rblCaI+AAJGaM0JKl1V/bVCwkpkEO4fYLie1cfC1jU9w0+eGNrqKodUp8NyfKedzM4IMcZgae8WXo1y/cn2Ukbe7SBPQra+0Ecv/uHKDaMXHdRbUG6nNdw6MJN74jX/oZRBY1iCF4Y1swwVtqBIl2H2sT67/+H9SvhU4S/OsAphssLLE0mf9eFNipx5tqKafNZMZfZZoKjZlLSHbYdkby30VDLnsmnLAtjdeISu5ruFp1drKEbfAc5qjmku5uuRwmIR6OckePgRFLU/hcdpnM/wwC7FQBGS1lgQBNE6dUwBbCv5RHOY9Nx+wN43b3aqXJCsc0BE/OHAgWxbsAjBqTtPbTUn2GAfKQU5ZpVfEpxny4Rqng8Yrcmk819GNlNcRTrBxwLyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 09:46:47PM +0800, Zhan Xusheng wrote:
> From: Zhan Xusheng <zhanxusheng@xiaomi.com>
> 
> run_page_cache_worker() runs under krcp->lock, from kvfree_call_rcu()
> callers that may hold more, such as set_cpus_allowed_force() under
> pi_lock, so it kicks the refill work from an hrtimer.  Under memory
> pressure it instead queues the work with a delay of
> rcutree.rcu_delay_page_cache_fill_msec, which may be 0, and a zero delay
> queues it at once, taking pool->lock under krcp->lock.
> 
> With the delay set to 0, calling kvfree_rcu() on vmalloc memory under
> pi_lock after a drop_caches makes lockdep report:
> 
>   Chain exists of:
>     &pool->lock --> &p->pi_lock --> krc.lock
> 
> Use the hrtimer when the delay is 0.
> 
> Fixes: d0bfa8b3c411 ("kvfree_rcu: Release a page cache under memory pressure")
> Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
> ---
>  mm/slab_common.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 3729aa7a6156..ef5ff0a20249 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -1987,7 +1987,13 @@ run_page_cache_worker(struct kfree_rcu_cpu *krcp)
>  
>  	if (rcu_scheduler_active == RCU_SCHEDULER_RUNNING &&
>  			!atomic_xchg(&krcp->work_in_progress, 1)) {
> -		if (atomic_read(&krcp->backoff_page_cache_fill)) {
> +		/*
> +		 * A zero delay would queue the work right here, under
> +		 * krcp->lock and possibly the caller's pi_lock, so let the
> +		 * hrtimer do it.
> +		 */
> +		if (atomic_read(&krcp->backoff_page_cache_fill) &&
> +		    rcu_delay_page_cache_fill_msec) {
>  			queue_delayed_work(rcu_reclaim_wq,
>  				&krcp->page_cache_work,
>  					msecs_to_jiffies(rcu_delay_page_cache_fill_msec));
> -- 
> 2.43.0
> 
> 
Can we just clamp this to 1 - 100 seconds interval?

<snip>
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 7223a7596dab..2c9236236ac9 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -2249,12 +2249,12 @@ void __init kvfree_rcu_init(void)
 			WQ_UNBOUND | WQ_MEM_RECLAIM, 0);
 	WARN_ON(!rcu_reclaim_wq);
 
-	/* Clamp it to [0:100] seconds interval. */
-	if (rcu_delay_page_cache_fill_msec < 0 ||
+	/* Clamp it to [1:100] seconds interval. */
+	if (rcu_delay_page_cache_fill_msec <= 0 ||
 		rcu_delay_page_cache_fill_msec > 100 * MSEC_PER_SEC) {
 
 		rcu_delay_page_cache_fill_msec =
-			clamp(rcu_delay_page_cache_fill_msec, 0,
+			clamp(rcu_delay_page_cache_fill_msec, 1,
 				(int) (100 * MSEC_PER_SEC));
 
 		pr_info("Adjusting rcutree.rcu_delay_page_cache_fill_msec to %d ms.\n",
<snip>

so we forbid zero as value to use?

--
Uladzislau Rezki

