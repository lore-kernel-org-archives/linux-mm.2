Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C06D4C5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 16:53:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8550C6B008C; Fri,  7 Aug 2026 12:53:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 806606B0092; Fri,  7 Aug 2026 12:53:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F7D26B0093; Fri,  7 Aug 2026 12:53:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 495196B008C
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 12:53:26 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D00AA400FE
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 16:53:25 +0000 (UTC)
X-FDA: 85075069170.02.235F7C6
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf30.hostedemail.com (Postfix) with ESMTP id C25C880010
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 16:53:23 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=ifjDWtEE;
	spf=pass (imf30.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.181 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786121604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=peRmGrEzoG+D97vGAtODr1oUhN4Bik3hV9FIhzwSdUw=;
	b=qUXk/I0HNnj42w28TpcLru2QnA1CFqdFxiWDiqla1b+d2XuCw+rV2EO/dTSspFzirY9pEq
	UnlARzzM3Dsb56LscqpI9X2JZpEFZ6SjeBFKPPMD5rx1/Dh6/IrQi8TInhCKEgcwRo7jS7
	kWW1Sd3Mjiwrg40pBrSjLRo3DHrIIE8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786121604;
	b=NMWXk+3ayzZeGeP0exB381R8mWa625GW3iFAzjw0Aa2p8BvJaBKsHbKgnJRl7cqzkDOP5G
	AGrc8CXjtu4/PPXgdPBRjerSSD0ZoFYq3cUDfsbawRdxGgm+obtEZIE6R/oAdTQWIABtBl
	Pn0JDimui794XfksT73fwcs+lU8p2cQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=ifjDWtEE;
	spf=pass (imf30.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.181 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-51c2b2c9eccso23274161cf.2
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 09:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1786121603; x=1786726403; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=peRmGrEzoG+D97vGAtODr1oUhN4Bik3hV9FIhzwSdUw=;
        b=ifjDWtEE9Lk4/1p+Q1JDb9NPuYRUwvUp4BiQe2KQswlJKjC1zkFFISR1nXOXD36N6h
         jazzijLeEYaBcV2+1hY8y9I4tAUJzotX4QEtbqzFqPx9S/SveYWm619LL6XZC4Qk6sMH
         /LiQwuhwaLuikRVExYby9hF43yfK8idId5aJvlfK9Rp8IOf9j6rwTm+7T2WjYTmWUEqz
         2RvTHvItrt2YIVrVTpXKw4buW+kHTT/xlrXmSqfG6RqLY2Y5LwCCKQ/OL3CteYTZmdiO
         c++pgMeIAgCDIUfr2w8XAWPjt+4koqCN4/zRdUAiMS5cZjil9aGcXNdZQ/O6LpwPclqy
         psqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786121603; x=1786726403;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=peRmGrEzoG+D97vGAtODr1oUhN4Bik3hV9FIhzwSdUw=;
        b=gPnlbR7JKkUS9oVSaU88+ZxfdSWn21q+1reZUyg8Ly0IXDJci0aPqndSenRr+ctctH
         MITL+9Iy0ZMhc60Li3rZLir8QT9jnaTLN5ZYbykUFBvd0C+Pi6kwj5XL4503p/2+Waqm
         gfbLPmeI+1cscSMpW3XzzDzDW9eh8Tk53/UD+41YhfS/o4GcyTba3em6B58gIK0CDJod
         va+91uuoNRHJD0psYCHjzUpK8ccV8tUCaU92sM9fD4w4IxV2n+rAfjW4y4wxq7xVw3JK
         Q83BhKAiLw0khWflkeoWZlIFh5OVhfHVshc82TwdvkGOshPmSgd2z+649dmVihjvOcgo
         59UQ==
X-Forwarded-Encrypted: i=1; AHgh+RriIcOoKtKM6lqfmBB8+KX6Co08YLuYG603zBNfTrfIGI5V2bW/G0eRCPtluYhWb8ZQqYDwL3MVQg==@kvack.org
X-Gm-Message-State: AOJu0YwHUx+af2RV1CaeXinhncao1k4TCRbcjBnfFmWrJhlLbqaz+OLV
	eOTOrdRGUDgzpiiMu49lpEhs9lnE7QSPSZCvu1c3+FSakemrXhD0eb9jVzh/EF1vsKw=
X-Gm-Gg: AR+sD10A+c4WZoFHY5XG3zx0Pj8zCivXKwZU0FvScuD2PI2NzuhTnkpbX5+HId/TNMd
	qqxzp3tqyWYMyGqeZ+IxkUOwLxTxDsYGuvxqlsrdoy1la68bMP/VyGqZB0W+JAUNDMCYdI47WcH
	Qb1WX0VO+qsvILDwN1YOv3sMgzjn/R+FQ2v1WPBfHhG//67EsDK6lxSJNUKCX2IxIVJGuvSEvl0
	Go5Ft6EYyEn7f8VbJLd7HtPCtMpubJf0TecnRf3kg7nVo9flZQxGjMDATxzNwFxnwnL4zi1gw3r
	COe7hK3/7BKkCkyY+EsitNlwbM9A3sY5HrJldGe0lcPJ4g1HIZwDa2yD2NPIbWTXAOLIBb4KjBp
	X9pu6C2K4G+UkDO2u3t8RsNo/HJI8f2NN2/l280E+MNCrkeRb6W0DhVphSszULXSwunsCUvy5kX
	K6RLJ6RqAfpYmRx2s1gW3Hpe5gpuycf1drliB0BA6axsmVkCNGwzjH6FuJ4sBf
X-Received: by 2002:a05:622a:345:b0:51c:73f:e3a7 with SMTP id d75a77b69052e-52ce6108188mr250650121cf.26.1786121602645;
        Fri, 07 Aug 2026 09:53:22 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52d166297b7sm16063031cf.26.2026.08.07.09.53.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 09:53:21 -0700 (PDT)
Date: Fri, 7 Aug 2026 12:53:20 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Matthew Wilcox <willy@infradead.org>,
	Christoph Hellwig <hch@lst.de>, Yosry Ahmed <yosry@kernel.org>,
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] mm/page_io: use swap entries directly in zeromap
 helpers
Message-ID: <anYNgMbSiYxQCSgu@cmpxchg.org>
References: <20260806-b4-page_io-folios-v1-0-0899bac3b826@columbia.edu>
 <20260806-b4-page_io-folios-v1-3-0899bac3b826@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806-b4-page_io-folios-v1-3-0899bac3b826@columbia.edu>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C25C880010
X-Stat-Signature: a4qig86q9gxw7wps797jqx8ecshh9agh
X-Rspam-User: 
X-HE-Tag: 1786121603-857616
X-HE-Meta: U2FsdGVkX19TjFhRVnp/e0pTaR+Dntzn5rd3Cv83RZKVOOK79NaMY98Vi0BoXp5YCTupKi7n0PL9OAhl6qFqAp3LaXIv8ZxDvAIgHPqBvExtw0HSsWQ9/mPGMY7XgDCL1Q+wQ2WVTc5/ZHg/IUwuoAfa8pz/6ts3yuBN7X+32sJauABN7FT4astTkGllb+peoEY8ynUze/eAkKsmPE0WFOjuMApLTZ6QBHBS5+zE4o8zJ3Hu/RNa84xf6K0XnOP1AfRTCjEZnio3+JU6LJnldmNyI4B0qvBJdXQ7sbWke0VNggpp/0+dHdxtfc+zLrnKVrPGyU5XveLDWZWC+HgutEHll4nUuLBbEXsl1bgsLnnbKlpSj82fE69UQewSqbiYvgZAfSJdGvch6dQRIUz4Bdlx1x00u8KMSN9x4/1I3tPRHaXH0983uOBtr369OeqaY8l3TiQiqCa1QfV+90tbg7uBVlP/MYutnKCqp+ZJZ/kDTrR2puUxKbDv1PcHW4hKlyzL2DY8J9tuKrII3Foh31MGY9S+rb8WvSo+ETl/wJ2b6fI0U8UTYGDxmKblHh5MtFhs41aSjO3W9H2wFVn+rBhC8amXrxAzFv7EDqvMQDKc+hl3TjIdoSHTyIDW7IQT30pM3AZEiX1T83GChnLiytYfxpyPKcvw60IwGtVl02JwaRChZvyASJCFHbB0A4RHdT+liSzGcA1LJzp8nkjvUuLjiZDJD8zjxu7vznJh+SfpUMKBSnif9IxIwY4j95yV0nH/Hitkx43eBToQ3+EPxLbCEPHt4AUQlMKs7PuuauOpIQ2GoLEpZcY6DtLvYHIRelzPxWgyEWZ7A/0v6PAz0m1++RPcfH5Z3gA1JQs7qob67xyOXtkfQlqYZbMw30J6G4vXHMid2/jLT3+4H5Fm5g5K3OMieHpy6cEInoWBRtDqF0JSM5MnkWler8Oi/DmrjTQIe/TZy/nSO2wVjpL
 2PGGiPwC
 tR+dT+0Ji0V8Ch5qrhSbThAtQM5X2v+lfCRo8ljB6lIpFz1H7GJm3psXV9VsdtEwU1WOWBLi9iqywZJIkOQxWaGOaYXyKm5jPujfeToSu8gkDJfZuaiCgcQnoel+jveX1yDufUaE1EnJ54IPkIWPGZZBnCAq4kTODYFjm0lQR9gKWHoLGFhA6/WtmMem/z9uLdXCksLEn+nQamiMkNZalL81rErttjdieAXNV1LefcvYnVq9u1t2VNUnJY9i2P/O0Wqcw6cFWnflMUAtzH3Gxw9ZZVEmaAaLC1lR0alTMr0gxjqyJNDzJJhNI51rxglX9rTD8iwzGBCe5fqPbUHHmXpiaoJV7sOPA/pHDTvwT9xiQhVyq2S+jgIQ4Oumnqkq7V03zTWISFNO6fhs0DbV1X6Kvfv/KaQw9ZQFGiDfmMjLMIq3Tu6CrR9ZSKfmHEmObDLoAypx1rrIzCMpoA0OMpRiiwOgfsZ+BRbzD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 06:55:35PM -0400, Tal Zussman wrote:
> Increment swp_entry_t::val directly instead of recomputing each entry
> with page_swap_entry(). This removes the last struct page usage in
> page_io.c and saves one call to compound_head() per page.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

...plus that unholy dance in folio_page_idx() for every +1.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

