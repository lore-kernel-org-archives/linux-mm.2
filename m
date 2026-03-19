Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37B701088E70
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 04:06:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1367D6B03D7; Thu, 19 Mar 2026 00:06:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09EEC6B00F8; Thu, 19 Mar 2026 00:06:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC9726B03D9; Thu, 19 Mar 2026 00:06:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DB2746B03D7
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 00:06:02 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 87AE2586B1
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 04:06:02 +0000 (UTC)
X-FDA: 84561474564.27.FDF7FAE
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf05.hostedemail.com (Postfix) with ESMTP id C93D4100010
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 04:06:00 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=gP2Ze3h6;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf05.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.52 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773893160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zHOwjv3YhlkQefFz19R3DRihRwLiRVCyfnjzhTGc9sI=;
	b=3DfsXBSuRhZ1IgWIfiGx41XylqD2Z/dMbxLmcqUdisRw/JZbASLIATFDEvoTvABxVBo0rk
	nYUYi6PjpmkEur7VqgZ1s5qv8ljJk9qKJMUmwZkbbFBH03w+qLiWreb+uWP9cX00/zpl4z
	QLXt6AIBOM9mIf/P8Zxwd4DqbiSd3UA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=gP2Ze3h6;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf05.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.52 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773893160; a=rsa-sha256;
	cv=none;
	b=zDDj/pWs40gz/pNCEx/8MgD4XMmxCJ5JM+TyBBy758TNLQeZ8in7iXhEzzFA5OFAuXF0J6
	Lmkre9UAoA1S6044uz5tLjDvS60zhNodYTOIXT2YwqWb61VrG6LAK66tH9FSq/NpMcO8M7
	2QSJQQWUF+Ctj7T6tIGxToh2raycDVM=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-35a1f549e7eso395915a91.0
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 21:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1773893160; x=1774497960; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zHOwjv3YhlkQefFz19R3DRihRwLiRVCyfnjzhTGc9sI=;
        b=gP2Ze3h6VBW6zhreswmtRu0xlwqv0WEd6eSOo0mUvw6aCvJFGNJzAw4sBxXESB0M29
         rcv2ItPREdJA5fw5VK4gQr0T3Fy3ry4Om+dWEgrdN2sf45nqNnCW1inLZ2EwZowbtJTV
         iYPjZRUkhr32O0cuP2wnjvCqDpygy1SWIbsYQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773893160; x=1774497960;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zHOwjv3YhlkQefFz19R3DRihRwLiRVCyfnjzhTGc9sI=;
        b=kCQQHm3sVi159mLBlXNJE3x/X0ItRayu5WknVkj+BiajBqUn8QMu/o4zV1DkQck9LC
         ZsJcKw2tBuAQRIJFldpgo9Kjj9yQ5wHFDg+T/7q5gagMlMz82NkCEitn+6fDO8jr1vea
         v97QhB+Q/e9/XlMw2RdZiO2pr1355UMYdg2TYbd0FK25iuM8odzCqlN0rkBMUUbgo0Ck
         ORVvXf5N4AGsiwoF4QdNfpy7NykI5g+/O3QnN/ryrNOl3fYdXP8tzlQu1EMRB3m3OXjz
         LaUOScdwFZEj0gMP/6tQn7Slw9WvOD1gWMxsZdoyfCh2SpDiYxPHvZnXWhc6BdQcChjh
         rjUw==
X-Forwarded-Encrypted: i=1; AJvYcCVqFzgGkAJDczhdJm/y0kw4u+qzoDsshgBF9/c1JhvfWOA/G26kk3sgdIwtc/c8W/38IJ1bPdB4Yg==@kvack.org
X-Gm-Message-State: AOJu0YxrIyRxZLIt70HSBj+1xe/nDeEfC/UQIFapTtg+BtOga14RQmQJ
	wZK14RddXTio/tPR6WZlakuNAN5QY3TOtJqmq2+90qWJAoaadhLbt7TCS+bnSXExYQ==
X-Gm-Gg: ATEYQzxd7dXICPoQOGgt3Yu0prALNHekcOJ8Sl5XJcGd7u4dyu1aWYKB2jXfH1e4ZW4
	d6pvLdgbdMfCaGWQIlZtDlfhPgqQxpnp4hHmAj5SVGShfGH3gnB3+2H9dqufqsh0WI3NSOKefCk
	xD4PQNwW+ChXxzmiftoWiE7vCfWNPUvOUv1YMm/2wFq3Vqhnv57GeVruNFotScAWhpCAy1ymWt9
	UhhvpYr/y7GGzGPqim4gYWjEEwolS2VjLoJRLI1o/FicjjBAfsa//HAeVPBokQemfVN11EOnK9Z
	Am5nfL39XfpSpQiZlA93yL4GYuGKFaSKApAPrmiWca7STnfB10zHC67HUAb4l6kbIrZCat5J9Fp
	4HBh5b87jxRgIFkwqLclGkfK0R8+UxTWR6+7pYasdpQR0Xfv/+eJ3bRx4Mlj7FNVmQQuMTs56Pk
	qea3fRfSy07+nFl+A+Ih1RRDCFlsM4PpDN2WhCzh96dHSFUjSpuI/a2VlGGMyLqSo=
X-Received: by 2002:a17:90b:4d0a:b0:359:8eaa:7f42 with SMTP id 98e67ed59e1d1-35bb9ef601cmr4835762a91.18.1773893159754;
        Wed, 18 Mar 2026 21:05:59 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:13e1:7517:52f3:cfc8])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35bc6017492sm1281973a91.5.2026.03.18.21.05.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 21:05:59 -0700 (PDT)
Date: Thu, 19 Mar 2026 13:05:55 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Minchan Kim <minchan@kernel.org>, Brian Geffon <bgeffon@google.com>, 
	Richard Chang <richardycc@google.com>, linux-block@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] zram: do not slot_free() written-back slots
Message-ID: <abt1dsjsT9826Ewy@google.com>
References: <20260319034912.1894770-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319034912.1894770-1-senozhatsky@chromium.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C93D4100010
X-Stat-Signature: 4udjn71jwujhf6fjis86u65sn1izq4s4
X-Rspam-User: 
X-HE-Tag: 1773893160-318549
X-HE-Meta: U2FsdGVkX1+8SeVoIGoTBhFTfFmErDoFHggbCtQ20ureq+LPOaGi6Rf1uv7O4h4f1qIbVF2NxNHNiQQNnC3IKqu2rC1VToI6/m2QLJm8vW01uhNksWa34ncp0XBg4bVDZ4W7HIUswObNfFBLgXOkAXRR8OntIubl8xl3Vsd2u+uLR/N0/toIDtafaIYODy48+JxvL6ePZjUlr4aKcqH2lxDpafs7PsVWFdCBih5nFYQv545/4ZbhtlQ3u/Ap7xa2jC79z4bmqladaVXUa28Gl/PmwhTPxOWexTVqjcH1SWZrBlrM7qojZebb9yldXzvGfxVtc/PFDWmwSzKqbHKEfRZGiQCa5AiRj0VBeoJHBeJTV7etzshgwvHBXDV/jlhIFZI+6xl6EleXBqVFjt7yX8ppJh1R0Rd9FuHpW7CVeV+pO9eaZzFQcqZ4Eh9PBvo2K+dpDxDBJpmAnhs5kj3j7rzDGli236Yv3WXm6h10k1nRZ1zD02khqbZ4MghDsqQD2N8qPCgItFKdhaGAvVzikdSdavDuNm5gP2IwBlY36tKCao3NDg76sgSl1DkhH68H9IlvstlbvDXccoZnfbXGX5Wp30euBMb3l7ohzNEixWKugUT0jRPcM533T7V56X5kqBfLqqQUa6owYcn7bAchb+KBO3lpdNa0DCUv2igmpBRMSNdsDWl6arTmW6QN2fLe+aA6iLYthlwHAR8akQkQLRTPT46KiH4m9oINRwY7RiWZ+wlOHIkYQAKMqq3blPrPBTXhGC+/vDUrzmK86cDLc6W4fLYJUUFDixM0IQGT/Ycky45RLOM6zZrkM+l+zPCixuiy1G3SjOq1B8CRWyE+SDRw2Ut2GoUX7HhRPj508PkWP4eOgepaBbs+a6aXglBBfsk6V155ZPiOg5t1ezcU6HFgX7Ese0YFkKEqncyl6FwXv5W9HNYlHgH0xvJquQskMWxxVKA30W867hec4fG
 wTMgxsVJ
 gLBhcPo6dOVgrrI0GkjMDmNaxog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As a side note:

On (26/03/19 12:44), Sergey Senozhatsky wrote:
> -	slot_free(zram, index);
[..]
> -		if (huge)
> -			set_slot_flag(zram, index, ZRAM_HUGE);

Original code had a bug.  slot_free() would decrement ->huge_pages,
then writeback completion would restore the HUGE flag, so when slot
would get freed for real slot_free() would decrement ->huge_pages
again, leading to underflow.

