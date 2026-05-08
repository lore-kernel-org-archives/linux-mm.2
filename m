Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CE25CD3427
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 02:40:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 197276B00CF; Thu,  7 May 2026 22:40:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16F056B00D3; Thu,  7 May 2026 22:40:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 084666B00D4; Thu,  7 May 2026 22:40:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EAC7D6B00CF
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:40:10 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 93A5E1406BC
	for <linux-mm@kvack.org>; Fri,  8 May 2026 02:40:10 +0000 (UTC)
X-FDA: 84742698180.13.37A63D8
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf01.hostedemail.com (Postfix) with ESMTP id B63E840002
	for <linux-mm@kvack.org>; Fri,  8 May 2026 02:40:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=HTCBDgMZ;
	spf=pass (imf01.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.171 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778208008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lgIxBzyqVLhoNqsOJWVNuFvzEo5Cnm2Tdi9qM5pIjSw=;
	b=A9ik+OmlxCqpIuMoo6wINaYhNOQ6ykNCTVZgVsoQd8zHxiUIXoHhUCcgfE2bRx8F9OohhE
	Bj+37l00OwtNjIFG0Lad5t/VG9/cRHx7P0qkPB9yx9brGf+PWA5ZhOeVD6A27pLYV86e9X
	iPQ0hG0wkdoJiPYZpxfgScwBglYhiLA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=HTCBDgMZ;
	spf=pass (imf01.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.171 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778208008; a=rsa-sha256;
	cv=none;
	b=n/BhviYSiSvwVnqzkpBPuuo3Lc+7MrgcSkjxPnFe1fS0noLBbHV71PNm9281g81s+ncQxD
	t2Wk9VTkGSWym0aQxiCwUKlVLI/kRxYO2CWf187n9W7G6zxH2C6ArrHOBwHgnQylGLmUt7
	uB1EUZ+IwvVBYV6JdozQ2b8k4ZaN4NQ=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-837cd669be0so1129157b3a.0
        for <linux-mm@kvack.org>; Thu, 07 May 2026 19:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1778208007; x=1778812807; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lgIxBzyqVLhoNqsOJWVNuFvzEo5Cnm2Tdi9qM5pIjSw=;
        b=HTCBDgMZXA+Pv11l8o3v68lahS7nSlQYBSEjw6Tff4r3ga53nrs69qp7msTc1g3dzF
         lNwhVkTNjfGSNdKHpI7Gia3aRbYEAyjqmmqFglf0wN8NxH+Vb6VmncbDqX1HTDzNslJg
         BUgI/e2AVKqBqJsTnDpYKCAAlExiidXj9Js6U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778208007; x=1778812807;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lgIxBzyqVLhoNqsOJWVNuFvzEo5Cnm2Tdi9qM5pIjSw=;
        b=N8P4bHjPSNok04jGy+4IUNpo8X2+VAuM6c9QkPqYTXEd/CEuOw/M3Ivk8fKjrv9ztR
         4+VuX2toFqGwRCX7YnWUahqtVjuDE+XY1iVKEhqsSJjS0ZSg4Q9lYsMCUjG0Jy/HUlV1
         bp9a9QXNo1RK3brWJD6GZfwPA6ZbQCoyBOhkZRBRWEgylLBPpusk4izGyPDYlxXKkEmq
         ddpCCQ2MEZHbJ5VvOOCRHJbDaE4TnYWsQf5t3wSlV0l0lL8959Zj5X1QVGqd4y+wZZVi
         vUajz7xjYrzOwFKrCkDFwFYcMdS70pTMljWe5jaM1ngyijU/yjr/itAYH5VJ22Fgz/bZ
         64oQ==
X-Forwarded-Encrypted: i=1; AFNElJ/vD0/BlOBquniN0b1obmDpZKiT39WREkQ9OlKewv8VtPlgxttAReTb8KtcXIaSsDIiGT3HJ07+Pw==@kvack.org
X-Gm-Message-State: AOJu0YyyLy43iwF06mGRe+N8rWQcEHuD4c9W4v45d08lLMHe5R5uXz8X
	VNC+qHMqov6+G5guegXyWyJ4CfFYfVaYCB31PbvwTbhMbcV4oetJZHFoIRcWS5isqw==
X-Gm-Gg: AeBDiesQ8cRIZG9UZRxMCpmgVKLxaoPfcUiRcO02U7APLlAaN+XImSBQ1801pG/aI+/
	zZmrDH4avpbYyZYYtf5DYlsM0YIB77GUIBZrOnOUvfDL2Ssxs+rapSQjhVyAxwR/sTX9QghtYG6
	fmE9upSPPDx8q7whJ27Xjzpoka7LR2Shx96azbGyXsCOZjisxq/QnB4cBomAIx8NotrHOkcxX7N
	LxulLd1I5O0OxLWZiJ8RyXGy6Enapz+cloZemsDijSRCP3fn0mgTd7mgnwZmK8StaJ9JFIiOX5h
	ltT5Uj1Lxj/lSZMy73piRu9/3BHYE3sCsS90GvRUgPW+8JnjfER6igBodlXwvSkLico96uC1LrT
	fWs914BsS1HnQbOKZz8ybI0yjciWipqV63gklJeMj+IGWnBtkNPPk4OXPXRwHp98fZ7dC/2eDRV
	uqjuVLQjyLAlL6a/KuWj04AThK7QlM22wO9i7nRtOXta80t5sbTTA7Z3ehwEeAXYM=
X-Received: by 2002:a05:6a00:8e09:b0:82f:6e9:d1c3 with SMTP id d2e1a72fcca58-83a5d873ebemr10437527b3a.29.1778208007495;
        Thu, 07 May 2026 19:40:07 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:7ba2:1dc2:ed3e:1484])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8396563f111sm10182262b3a.4.2026.05.07.19.40.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 19:40:07 -0700 (PDT)
Date: Fri, 8 May 2026 11:40:03 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Richard Chang <richardycc@google.com>, Jens Axboe <axboe@kernel.dk>, 
	Andrew Morton <akpm@linux-foundation.org>, bgeffon@google.com, liumartin@google.com, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] zram: fix use-after-free in zram_writeback_endio
Message-ID: <af1BNwmyHK6aU_uT@google.com>
References: <20260504123230.3833765-1-richardycc@google.com>
 <afoc5qLvK2PDQKb-@google.com>
 <afw2919RiZje9xzq@google.com>
 <af0YtJOLGvO-LJow@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af0YtJOLGvO-LJow@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: B63E840002
X-Rspamd-Server: rspam06
X-Stat-Signature: k3zspyw75jpoz5so8ect4nzsbw571q7w
X-HE-Tag: 1778208008-465621
X-HE-Meta: U2FsdGVkX190FC0NHksNcjht8yygrszSIER3E+kQoWcSDieQMiuHtT6mIjLU15Brxbjfl0KLVZYQ3q7xWsQxPHCigjjPw6wMdkpTphNEOeOXrriVeYfh7IMXnfwIrv3EsFFfKYa2YiXZgWHtxWF3Xyh/jt6Qlq02eNujJBRE8pkK275bDL8uWlIE2bwPCMKPLm5MxBwthPP401G1zSaeAMh0lHZCT0w26eHFN6RmxhtW6dBp+TF3VkhRvBNcnEnP6G0phxXRNDXIuXWHMAxcm0MpeKKKPf+aVL3uoh4mTZoRtQgCVu+H0AscV0a5QRjoiBp899LgRSN4gkgRnNglnLDwet0R9h+2jaWjUUbIXjAdnsNYGiXAeli++/DB5V0oCMN/GGpUoPVphZJSqUIwk5Y+IqncRTDPHyuW3rr/EKWeUrIi+dtAiwTSniixXFUXqgySKY5IBLrubR1JbY4RRr0rBVxnFxwcGJGXm6O04A//FaiRnKGEDWTUiFpfmMw2xm670069s949JSS7gdnPHTfcsavPfQQJ9QbQVUVc5/QViFIm9NFY1mYv4ydzWFVqslFk7r5di9FYrGKCnbJG2rB5Be8atPC2WXga3LJxCHYcvSLetk6g2a2W67JKkCflJVrETTDfOhvUhIizudNa2LQqQsNhO7c9eQ+W4Pl3FRhbQKxAHxm6DfHB47JH4oKr3nhyYxcmj86P+akOzneRtnEmDhi9yus4qb3lEESh7X/myWpUr/9/JFVtjnHTMe+4PTGn7E2OgftfPq7V8RLPt5txx/taVD3xwwNys8lmTFB44YXopR9zp0is5i65gp678ZOzrjwj18+gfRhv6f6JfkazgNX5h88+G4In5HkC5InakTGiLJcE7G7usi/nCD+V5tSwgpmTSh9FKyIIJnFu1614RpN24YoHBtm8VEHHBpDv3I/RBiclQxPtljz5D/37NOblfvVYhiQ4LHPMRuk
 cvtNd3eZ
 o0EBB1Bwn9GizxMfkvAo3fSxciSJBY9LsGzVuaxwJ6CeZy3Mm0FHKeZIFmL22RxtfsaFFgAXFBYpqpf+HTFYCYBeCe8hYLnOdA+899GYLMeiAZSU/UupzZwRImZgVdwBbnbsezr1wOtI+TkzFg1946vn1jJXketrkre+7hCE2HjZaQQJn/sdfksBxZU2tAN98O9BO7uz91jMRky1LV6FOqnuIt1WphSbaQXeqvPmt2ctqeix3cGJH1XfS+h8RuyrOj97ItLYZF+rK09L9cJ72b4IBKz4dV0lLDh59A5lV2KD5A7mtZHxJtF5Iz2m6AqAzODknfzozQ/RSlDvOcpvQd8Sm0Z3bTFIGVo/cNvYQIOI/L/auwxVaRb6Pl7V2NQkhUcoe5aiKUgKVUtQ8LOHdxe5Te0my8/CTrY1kRKY6n4vWU7Oyvgz+Rtk02x5VZTaTy82uepySrXRCv3+qJZ6Z2mXMDDe2fAR9HRukSi9ag2WpdjLIZIlwUcQ8tA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/05/07 15:56), Minchan Kim wrote:
> > -	while (atomic_read(&wb_ctl->num_inflight) > 0) {
> > -		wait_event(wb_ctl->done_wait, !list_empty(&wb_ctl->done_reqs));
> > +	while (atomic_read(&wb_ctl->num_inflight) ||
> > +	       !list_empty(&wb_ctl->done_reqs)) {
> > +		wait_event_timeout(wb_ctl->done_wait,
> > +				   !list_empty(&wb_ctl->done_reqs),
> > +				   HZ);
> >  		err = zram_complete_done_reqs(zram, wb_ctl);
> >  		if (err)
> >  			ret = err;
> 
> I understand why you used a timeout here, but I still don't think it's a good
> idea since the user could wait for up to a second unnecessarily during the
> race.

Well, sure, it doesn't have to be a full HZ, we only need to wait
for propagation of atomic_dec() from another CPU.  That's very fast,
orders of magniter faster than a full second.  Just saying.

> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index a324ede6206d..28ab4a24e77f 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -33,6 +33,7 @@
>  #include <linux/cpuhotplug.h>
>  #include <linux/part_stat.h>
>  #include <linux/kernel_read_file.h>
> +#include <linux/kref.h>
>  
>  #include "zram_drv.h"
>  
> @@ -504,6 +505,7 @@ struct zram_wb_ctl {
>  	wait_queue_head_t done_wait;
>  	spinlock_t done_lock;
>  	atomic_t num_inflight;
> +	struct kref kref;
>  };

Yeah okay, it overlaps with ->num_inflight, but we can live with that.
Maybe can get rod of ->num_inflight in future patches.

[..]
> @@ -864,6 +875,7 @@ static struct zram_wb_ctl *init_wb_ctl(struct zram *zram)
>  	atomic_set(&wb_ctl->num_inflight, 0);
>  	init_waitqueue_head(&wb_ctl->done_wait);
>  	spin_lock_init(&wb_ctl->done_lock);
> +	kref_init(&wb_ctl->kref);
>  
>  	for (i = 0; i < zram->wb_batch_size; i++) {
>  		struct zram_wb_req *req;
> @@ -985,6 +997,7 @@ static void zram_writeback_endio(struct bio *bio)
>  	spin_unlock_irqrestore(&wb_ctl->done_lock, flags);
>  
>  	wake_up(&wb_ctl->done_wait);
> +	kref_put(&wb_ctl->kref, release_wb_ctl_kref);
>  }
> 
>  
>  static void zram_submit_wb_request(struct zram *zram,
> @@ -996,6 +1009,7 @@ static void zram_submit_wb_request(struct zram *zram,
>  	 * so that we don't over-submit.
>  	 */
>  	zram_account_writeback_submit(zram);
> +	kref_get(&wb_ctl->kref);
>  	atomic_inc(&wb_ctl->num_inflight);
>  	req->bio.bi_private = wb_ctl;
>  	submit_bio(&req->bio);
> @@ -1276,8 +1290,8 @@ static ssize_t writeback_store(struct device *dev,
>  
>  	wb_ctl = init_wb_ctl(zram);
>  	if (!wb_ctl) {
> -		ret = -ENOMEM;
> -		goto out;
> +		release_pp_ctl(zram, pp_ctl);
> +		return -ENOMEM;
>  	}
>  
>  	args = skip_spaces(buf);

So I think we also need to do kref_put(&wb_ctl->kref, release_wb_ctl_kref)
at the end of writeback_store(), because otherwise it just kfree()
wb_ctl and we have the same race condition:

@@ -1330,7 +1340,7 @@ static ssize_t writeback_store(struct device *dev,
 
 out:
 	release_pp_ctl(zram, pp_ctl);
-	release_wb_ctl(wb_ctl);
+	kref_put(&wb_ctl->kref, release_wb_ctl_kref);
 
 	return ret;
 }

And indirect release in init_wb_ctl() as well:

@@ -895,7 +903,7 @@ static struct zram_wb_ctl *init_wb_ctl(struct zram *zram)
 	return wb_ctl;
 
 release_wb_ctl:
-	release_wb_ctl(wb_ctl);
+	kref_put(&wb_ctl->kref, release_wb_ctl_kref);
 	return NULL;
 }

