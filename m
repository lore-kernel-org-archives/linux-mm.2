Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3F8FC55822
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 07:30:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A33166B009E; Wed,  5 Aug 2026 03:30:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E3E26B00A0; Wed,  5 Aug 2026 03:30:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D2A06B00A5; Wed,  5 Aug 2026 03:30:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 667FF6B009E
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 03:30:57 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 028C31C0C3D
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:30:56 +0000 (UTC)
X-FDA: 85066394154.27.5C59C03
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf20.hostedemail.com (Postfix) with ESMTP id 337F21C0007
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:30:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=guXTPAJZ;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf20.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.48 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785915055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LE65ieIp8I659VmcofXZw/PZP36Nf/+/qha9kOVSF1w=;
	b=HHLVJ+36b4WCYm6WiISV+XjXSd4l0BZqGZuMetDfDtx2I4vUp8rISkdbFyZtzhzDfaiQHa
	DlXCXtOGBxO1K+5MAdAroWEqBnzVTKrj8eryKknqlQVE+IJUgjTgXtrnR2EAuM93YMdY46
	/mxhiDAJEbQpdNJmVFYzzeD5/D+3oxo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=guXTPAJZ;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf20.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.48 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785915055;
	b=4skYMSb5YlrwpivmxJOHupm+zFgTfiCPaBR9esKl6lJszj7B1kdUi6w8WQv4M5iv/H+ULH
	3yXvsP7Sf015ZlhXIcevcY7QWozSZFPZHTuTr4zPmaixNkT6KWZtdwNkFL0yrC6pAnU/Ls
	jXQbclExFLXJ/TH7eZ6QdlBNWhA2UT4=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-38125cebfdaso796333a91.1
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 00:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1785915054; x=1786519854; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LE65ieIp8I659VmcofXZw/PZP36Nf/+/qha9kOVSF1w=;
        b=guXTPAJZzYFtLjZZnk4xHeOdw7Z4DFAQPNGm8FhQX0Mw+D9mJoEYAYHq8p3ABHZuLr
         1sKq4oeeskPH9NkTwIjuK2oQbAnuTN9wI9bBhfh7AyEI+N6ZPvyD/xTmL5Ne4y6di68I
         muoCpwDG7RGbFkuns63XtOhxsc8UGEsDS3Xlc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785915054; x=1786519854;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LE65ieIp8I659VmcofXZw/PZP36Nf/+/qha9kOVSF1w=;
        b=Yo+PtBymbtJwlAF2kCzs1Cg1qrNoB8K4Y75nJLjqFi7VMvI25enXmT+BDvHBibkmwA
         hG2H6d3VTivwpF3viGI6zQ2o+bnAhDGDmhHPLRZhxamnhUUzrLWAYnJG+fCZ+PkJk1rd
         YqTFgrNL84WSNqRm+qX0cAlvsJzdFuMmknzvUnEEyl2sw3SkprUnIM9TgGOO/NZp0Lvd
         T//zyvEGuoYQ46PQ7tOafI5+CqrGYNhtCEMESnVH17Bmjq/Et3gIAcBn53NFF9cYljgQ
         9ThNSYuCfWkbwgbErOnekex492b84G8mS8Ie5h3h+ptvN340g8YolfPizkgEkRKliYnn
         6ToA==
X-Forwarded-Encrypted: i=1; AHgh+RoclhJ6lOD5l8quV9R29FVOqgPgC9MDwxp0Y/ObrSB3qTmYhe6W/2wq95nK4mb9MDs9tkjrcwYhPg==@kvack.org
X-Gm-Message-State: AOJu0YyB5jVBAIWmU0cLyyxeu6xEqp6vBOhAhbAR3CVzRdYlCFaMJdeD
	+9909JhsPnO8ly+lglyZ0JAfzZD0PiXiLMX5c1ofVkAbaeDJ3eE1T+s4FEvuCrCenA==
X-Gm-Gg: AR+sD10wy+zFvd7Wnl2vzJLADn/vEiNfm4vsOXd/xc9S8wYDSTiJj1UJ4W9krgcpq2z
	o26PY8Nq6JUwtSoPF+IxeSZFl1ct/blDfRFEyuipxnYrl8ZwD99Vks2mA/W97Ho1NZwHFV8dPOs
	E4JKCttWEwagXRZ+rNO8ra9De1AcInK3j7npFpVLX5LPYl0MXQr45Uko+04mdZNTq8tqOIlIbKO
	f1od7vU5dHyYht3jYbvOPIe9Q7R9zMNgw+VP3fY3+Wbx1v/AP6JUiEGLcb7LxSraLYtil990gV/
	hgB+rzYbLMcAoUwol9D1JFh0UAChEgaJK80LH5yx5dk25Dn2L4w3NL3P8uXNURmDz2NF4MPigcu
	yucugQIPdDeEp1vA2oawupOJ9Uj5fCXd57GeJ1ALMCVTz77BqUd8fk/6rbUgYM8jFzOLwEmOYfU
	4cExqTFahiy69n4lm2Q0DtYUxKwg7ZnCvez7Wq9+Tbb7Y1nwre6yY9ONt8UtFxJ85FCs7ZxJOJe
	UmGQ+w4K59rq9K9oS2n11e7aF/l
X-Received: by 2002:a17:90b:264b:b0:38a:c3f:3b87 with SMTP id 98e67ed59e1d1-3903c58a6femr5225814a91.12.1785915054038;
        Wed, 05 Aug 2026 00:30:54 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:8002:2a47:a704:5a58])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38fee066b9fsm3665743a91.17.2026.08.05.00.30.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 00:30:53 -0700 (PDT)
Date: Wed, 5 Aug 2026 16:30:49 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: senozhatsky@chromium.org, akpm@linux-foundation.org, 
	bigeasy@linutronix.de, hdanton@sina.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, minchan@kernel.org, ryncsn@gmail.com, yosry.ahmed@linux.dev, 
	surenb@google.com, Dongdong Zhang <zhangdongdong5@xiaomi.com>
Subject: Re: [RFC PATCH] zram: avoid preemption with CPU-based compression
 backends
Message-ID: <anLmcHXqEX3HvSpZ@google.com>
References: <20260805005545.66112-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260805005545.66112-1-baohua@kernel.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 337F21C0007
X-Stat-Signature: 6oswn95zemk84a6n7kn36qmi78q6jysn
X-Rspam-User: 
X-HE-Tag: 1785915055-827346
X-HE-Meta: U2FsdGVkX1/MRQb/eru2WZj83/rSZcpsnRbdNQUrMRWYDe26OW9VikppuzOOgYh0RMkv+dysAzccAXm69kAHb9M+oawsG4byQ7rDmNo7uId1jUCALw7jZzud19ZWla41ztT+UGNGrg/Juybcyiolp75o61/8HA59zhnD29Om4mDdutJhyP43NOzWu5h7yzCufP/FfWfaxhQc+zQ2ZN3J1O1tPW7NGpB/rNQAUcF/Jf409Y05nyiQ44bvb4i5u2DBNm0JBwSDSmQNueCoGTe+xXIGOJWGUZR5IcC56zroyg7wCyOLzO5bay5FvtE6odppEHWWtV8xR2LsreNI4f8tY/E32I65Pw3FOwXioHu6V7ZifBj4Qo+33WwyPPxOBlTLFJlWndqkdw+S01iJ92MgYeRM2/j7xxdhge+3WFaLKMhJ0rhoaIObbBke+vzZh98ji5e8KsgbCRLdm35mpFZiU3ffcBMFlS+QS2XO/U7I6EJBhWkd2IoyZsWYEnyY8gWENYvXtHpyUQbX3lpRcVv8EBZDH1rrzx4B3QLxmjniq5GLRQkFjeDlbV8mIpNF+r1Yw/on11b98t0+qp66bD2eIf4q3ltbQdl3n2cWM5XytS0mulIK2+q0L+Adpxwq2NsCfY5MlAixjeBSwTrEM3LISCzQb6YqNPBrHksRqwSwRdEzRmeX6mV16SyGnsmwSCTfsyuYD2nLatkyoSB0VPtYrg9fOOqFTQweAqXOu3AQnuMoUSZctZ+V6mqZ/YSlUfxUjJs2jkvdnwYZ0tbrJBfBtBti7GtygF+LYCIQoJQxsGWH5+NHeYcZzPHna8lZsbow06a7r72klqhDHNg7pqLVot3XfFRjqP7lBnX3AEMO8rt/sfnV/vnB5fg+OZXYc3d1NYzur8QLkwiGf3QH+2E//2iHFMv9tGrRkX03lCZGcUZk//IqNMehtrX3x1L6UQXRr6A4l7+cMqzMZ6VwUBU
 pqo6MFgY
 qUJZLvlAnPfdcqds2LWLOUTMiBMgQzkjStrxMYGzXjMir8/xUdNCrAndDPaEMHecpK6UpjCj4yO34sno30mxeGZWphfWD5B2LyYyvAeKiRL3a4bjUg9Pn9MuG4Y3ycbdeSEHtPz1VZN+Sy778dk8jmI8OHutD8D0PemcYNEXC6AHukrOe4etEsNOjrG2LGOM2UYjw+aieMvCkiXvHTPBTuKlmGrlAbZ4kNBHYw0gMAFdXAwdGvpswM0N9YgtF2rnDKmFPbMkgf3PN92iWd7IdK5cqtV66QSMH7nfNHtIVozrsRD5TPQULqL0BTm/xOH+t4m0spevILbON72Ojaf0YrzNN19FoBiHJDoL+76iDLNKKtKNG0lBSKVK4Lv6BMCW7iCXd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/08/05 08:55), Barry Song (Xiaomi) wrote:
> @@ -128,14 +128,20 @@ struct zcomp_strm *zcomp_stream_get(struct zcomp *comp)
>  		 * so then unlock and re-try on the current CPU.
>  		 */
>  		mutex_lock(&zstrm->lock);
> +		if (!comp->ops->async && !IS_ENABLED(CONFIG_PREEMPT_RT))
> +			preempt_disable();

We take slot_lock(), which is preemptible, under stream lock on
some paths.

>  		if (likely(zstrm->buffer))
>  			return zstrm;
>  		mutex_unlock(&zstrm->lock);
>  	}
>  }

