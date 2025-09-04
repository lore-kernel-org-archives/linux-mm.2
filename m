Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1980CA1015
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 14:48:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 467B28E0007; Thu,  4 Sep 2025 10:48:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 427E28E0002; Thu,  4 Sep 2025 10:48:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33E108E0007; Thu,  4 Sep 2025 10:48:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 228E38E0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 10:48:20 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C885211977A
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 14:48:19 +0000 (UTC)
X-FDA: 83851848318.11.F07BE07
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf28.hostedemail.com (Postfix) with ESMTP id BFE0CC0004
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 14:48:17 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=JsbeWo0H;
	spf=pass (imf28.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756997298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g6Sf9UE3EF5HYpffcmBwy4ps10mS4KNLSqgfI9CuUyY=;
	b=gJSF/1mXrZNWRmzvdjH3A7UnmhTugZv1GHLX82m1VlyJMgkE8HqCXQn0HNlnB2EuE1Y7uF
	u8uoE9VrCAQ0RX+DfAq3RFLZRg+7MDRJTWBCw6ohuAxe3yAIjft8QR+J4HGw9v9HFX1/D1
	WAtbwyn74OunGmgaYnVcmGQu0StxH9Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756997298; a=rsa-sha256;
	cv=none;
	b=QLP4GN4NKe5n8R583YSj5wp9+S4GK5tqm8ROLGBAxkFwrt70V2v9kvlI9QZ5XA/jCS2wgp
	d97t7RF0i+8st8lfiIBw7q21Iokui2V7tToSZ4urwSIdvUCkpdukS8QvqdyLEj7sopyjZg
	YVRQOCydgYCqzamYDhzS8tKq3/Inrs4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=JsbeWo0H;
	spf=pass (imf28.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-45dcfecdc0fso8447615e9.1
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 07:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1756997296; x=1757602096; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=g6Sf9UE3EF5HYpffcmBwy4ps10mS4KNLSqgfI9CuUyY=;
        b=JsbeWo0HWKOIZlzxWXHcN2LWbuN2j966jUUtAmAEgYMEMncpKIpJbLHalPKQUh9oxT
         lCaqtiuIwsxhnQ66lR2zI74pqdiHipPJASMtupX43XbPDJmkJzFkoyo/jz0MmAdIesFl
         j0Tu6g6z0VjuiAA7vJ1/Hua6/7uWV4VDuVFDbDqFk/gnX++WoCT+IFfcRc7Tt2EPXWKD
         8To5d59QXTMISQfsi0RmFmjSqfqNv3wRGp0gaVhSTGRKvShnvE7l5sxZAxgs42ZZ0XHc
         tHutg3Arf/ulkA5DIf1w/i+QgaS/VwzfAUMs1k0ckmaBo9XTe8P9x9AlQZ1uZLiqPnZk
         0fOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756997296; x=1757602096;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g6Sf9UE3EF5HYpffcmBwy4ps10mS4KNLSqgfI9CuUyY=;
        b=TSy7XwwrpoB6rZajyk/MOe+hBnxuw7IL4SNlSem6iut2sx+SJ4REsB4jWEJ49MYEB8
         JABL4vwonyv27MNG2jFliQm+KXNkpW0SoiZ4VFqtilZGMmMCGtfBRo5BDO821gQekPx0
         ToJuKzeA4+hG67PVVHwVTHML7rbFuLaRsub+K/5jycTVtwxLHodoXMBXHcO+5Y+39y9s
         pOjMGajkMjb0tlzglG5v3vhPcg8YHaoVbXYUf0q0D5mRU+HbOT5Z+JvZzNgj565cmt0k
         CQhSOKUe38svoYPDtoAcNugcRsqLtE+VPPxyxF9dj7JcV3zx3r6wx2oQDwd/BTLzUJ//
         Nq0Q==
X-Forwarded-Encrypted: i=1; AJvYcCUhgridZcx9wPx+qLZLvJWJECH4qM4/kilXRLZs51yhfDCBaEJC0Mxj4pCzsTUSaRwNCRpOTRH86g==@kvack.org
X-Gm-Message-State: AOJu0YwQOYRLY4GXofbdfaHjXgMiMPGGC251DTxhi7gf39s+z9tTyR9Q
	b6Y+UYjK1lsWPCjXYOobOB36IxRJIelg/ZZy9KCzBZL7mdqPx+48FPDtsFDsDJsq3hM=
X-Gm-Gg: ASbGncv9xxkh25nDmRsFDANCWP/sEmbZ1jbsLLKpEntmyUhOCSaldD3SZnqaM5dX5U6
	lbrWBSF/velN8T4+Uaq+Tq/h++Bgw1xmRtHTD/3bDL/U5Q3g8HIQPw2C5JQSEi/JwdNLvjpSM1r
	GphUIRz9igQiloIqpHeVyuMYfqcnU51OEwkJdiC48pV1opSUYcr9ZoLyUbtw8njEMbsrq96VMbr
	1m9YRW3FRs8DOrI/PHr/E+doPqRxvCHFybMKc/xSEvMkwDsRfaYWSvBXPLTXc2oabzY2CvU3IFr
	3vY3jxAI3cDSZmvR63bsybayB4vshjQaBQpE1Gycr1XvkV3r6ckT1HJeX7/HKSVXqr37aDWWKHV
	hqRLDaKMUguY4AuhZO5Q8ZX1c0dlpKWCRrGRys9wvuUT0G6mrGYM8xw==
X-Google-Smtp-Source: AGHT+IFmEWOaYXgd2qYtZqy5eD425678QUgMGGgTXiY3gZfol0LS2F7CgHBQrjxKscsjVJaOReKoiw==
X-Received: by 2002:a05:600c:1f0e:b0:458:a7b5:9f6c with SMTP id 5b1f17b1804b1-45b855335a8mr170497585e9.11.1756997296078;
        Thu, 04 Sep 2025 07:48:16 -0700 (PDT)
Received: from localhost (109-81-31-43.rct.o2.cz. [109.81.31.43])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45dcfcb1497sm21106915e9.1.2025.09.04.07.48.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 07:48:15 -0700 (PDT)
Date: Thu, 4 Sep 2025 16:48:14 +0200
From: Michal Hocko <mhocko@suse.com>
To: zhongjinji <zhongjinji@honor.com>
Cc: akpm@linux-foundation.org, feng.han@honor.com, liam.howlett@oracle.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	liulu.liu@honor.com, lorenzo.stoakes@oracle.com,
	rientjes@google.com, shakeel.butt@linux.dev, surenb@google.com,
	tglx@linutronix.de
Subject: Re: [PATCH v7 2/2] mm/oom_kill: The OOM reaper traverses the VMA
 maple tree in reverse order
Message-ID: <aLmmrvPb6mFHzqCc@tiehlicka>
References: <aLg7ajpko2j1qV4h@tiehlicka>
 <20250904122438.22957-1-zhongjinji@honor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250904122438.22957-1-zhongjinji@honor.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BFE0CC0004
X-Stat-Signature: 8gfxzinrsd3fm7c7npgenkjhde18nb1u
X-Rspam-User: 
X-HE-Tag: 1756997297-636774
X-HE-Meta: U2FsdGVkX1/wGEWcR7RIyAZ/hKlQCGA10kla/dU6XmstiliCKGFfjQDfY4MY6jEbswdkap9nEoROg36kBJIzcNX/UWVefQpstLhupvSNn3DWMGcEQEwEPeBuzqJprO2YJbfp7wj4psSBQoKPjkYWnmANMbpPibXT7tp7qszpxegozBWpkIY8PLzVKc5LN3jQ504W0OC1YASP4NTRyRUY5h+MMJ4zjC1NDIw9UMKd+MbXTQiHZpEHr7rn5Huu20t7BFYy7AQ6CbZX0y1RQEQ8vR6LbOz7llJDLNMZQpGTr8n2ci9lLCKTcKJL4Z+Ydu8oEsN22Uc7Kb7A+h7UW009DgUhtn1gqz+uuhZIGrVSSMPgNXL+u+Xl2X8c1u+YF5yWhhYrGm0WrdPub+iOUE5Yj3wNfCKTcdSqa/2iZBzO5B7izs205HUuj3nPsZ6cFCHOdA0rUeus2baix6QNNSRFlqVJpZXd537gsyio6G8Vx/1/SpSwOZwrNElhBRIIGgHXxhXY9g3s6RImz/C6eTfi9ZyRYlt99aC6gEdlNZbOIfxgGfFPgV4fyb1ptQqx26W3v9q6J0tZUml+JPlOmP+ML0nbTzTdgsw/BDp/eEn0twyLMs+ZesYHbqJygV6Ac43n3wi3GjiB7HenkHduYEiuA1FJruSMuxEkl+jRgEvEWqw3uHbxqZsd+en6yvP3wjVwqL55EyHmqrEGjioN+bMBJV83uYNwDs7Mc0y8ioNQ8fV08oWZTHOFKba4O+BgmdWjq7ONQfVD3HCmRzIeOceUaHUC1NL+lzVD/v5jJ5LLH+v/R0tNFUcBKAKQn4ypbWMEufy+Nl1fuKFP5DdMFS1dBLQNGXuno0TJSvuNCQvlE+hxgEaSy/CIstxPtdRh9tOXVQOXFdhL08MY0FigMJlutyXslUt++5WgFXnimB4DyhQWDhv7T6cNHEkwInGRxmqsxj/DC+KL5TeYzWg4Egv
 NL4f48qr
 OBuqV7MnmNxhHAX5SkDgQusZMpCaFVD3HhrnAH82enVzzQr8hinC+naOPfK2vXjCsEzGl+Xzd66cPz9DBQi4FQbFI0ZwPnzgVOBE8AyuJCf/3/iGIkrFVjM4yryHKbS9D0J1qLdIWt2HmZmCt70RURACQwSFOeyk1GDwA/El64VQi/NlDk5mvOeeToH0jDUgRqKQE4bcepS84fIL1UqCUcHn6FeAKtDpM8RwmzmUWb+d5AAUEwB6eoimVqJopdh7CgPWgirCjU51W2VHeaN0aFJJ3lOvP41lL+kPYTFQmsL4OcxxuzFKTY1RNdl4y8m/ngbIAIj/ArxfTAY78oHPvM+czFQjaIyAgZfck/P+L0C+b84s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 04-09-25 20:24:38, zhongjinji wrote:
> > On Wed 03-09-25 17:27:29, zhongjinji wrote:
> > > Although the oom_reaper is delayed and it gives the oom victim chance to
> > > clean up its address space this might take a while especially for
> > > processes with a large address space footprint. In those cases
> > > oom_reaper might start racing with the dying task and compete for shared
> > > resources - e.g. page table lock contention has been observed.
> > > 
> > > Reduce those races by reaping the oom victim from the other end of the
> > > address space.
> > > 
> > > It is also a significant improvement for process_mrelease(). When a process
> > > is killed, process_mrelease is used to reap the killed process and often
> > > runs concurrently with the dying task. The test data shows that after
> > > applying the patch, lock contention is greatly reduced during the procedure
> > > of reaping the killed process.
> > 
> > Thank you this is much better!
> > 
> > > Without the patch:
> > > |--99.74%-- oom_reaper
> > > |  |--76.67%-- unmap_page_range
> > > |  |  |--33.70%-- __pte_offset_map_lock
> > > |  |  |  |--98.46%-- _raw_spin_lock
> > > |  |  |--27.61%-- free_swap_and_cache_nr
> > > |  |  |--16.40%-- folio_remove_rmap_ptes
> > > |  |  |--12.25%-- tlb_flush_mmu
> > > |  |--12.61%-- tlb_finish_mmu
> > > 
> > > With the patch:
> > > |--98.84%-- oom_reaper
> > > |  |--53.45%-- unmap_page_range
> > > |  |  |--24.29%-- [hit in function]
> > > |  |  |--48.06%-- folio_remove_rmap_ptes
> > > |  |  |--17.99%-- tlb_flush_mmu
> > > |  |  |--1.72%-- __pte_offset_map_lock
> > > |  |--30.43%-- tlb_finish_mmu
> > 
> > Just curious. Do I read this correctly that the overall speedup is
> > mostly eaten by contention over tlb_finish_mmu?
> 
> Here is a more detailed perf report, which includes the execution times
> of some important functions. I believe it will address your concerns.
> 
> tlb_flush_mmu and tlb_finish_mmu perform similar tasks; they both mainly
> call free_pages_and_swap_cache, and its execution time is related to the
> number of anonymous pages being reclaimed.
> 
> In previous tests, the pte spinlock contention was so obvious that I
> overlooked other issues.
> 
> Without the patch
> |--99.50%-- oom_reaper
> |    |--0.50%-- [hit in function]
> |    |--71.06%-- unmap_page_range
> |    |    |--41.75%-- __pte_offset_map_lock
> |    |    |--23.23%-- folio_remove_rmap_ptes
> |    |    |--20.34%-- tlb_flush_mmu
> |    |    |           free_pages_and_swap_cache
> |    |    |--2.23%-- folio_mark_accessed
> |    |    |--1.19%-- free_swap_and_cache_nr
> |    |    |--1.13%-- __tlb_remove_folio_pages
> |    |    |--0.76%-- _raw_spin_lock
> |    |--16.02%-- tlb_finish_mmu
> |    |    |--26.08%-- [hit in function]
> |    |    |--72.97%-- free_pages_and_swap_cache
> |    |    |--0.67%-- free_pages
> |    |--2.27%-- folio_remove_rmap_ptes
> |    |--1.54%-- __tlb_remove_folio_pages
> |    |    |--83.47%-- [hit in function]
> |    |--0.51%-- __pte_offset_map_lock
> 
> Period (ms)           Symbol
> 79.180156             oom_reaper
> 56.321241             unmap_page_range
> 23.891714             __pte_offset_map_lock
> 20.711614             free_pages_and_swap_cache
> 12.831778             tlb_finish_mmu
> 11.443282             tlb_flush_mmu
> 
> With the patch
> |--99.54%-- oom_reaper
> |    |--0.29%-- [hit in function]
> |    |--57.91%-- unmap_page_range
> |    |    |--20.42%-- [hit in function]
> |    |    |--53.35%-- folio_remove_rmap_ptes
> |    |    |    |--5.85%-- [hit in function]
> |    |    |--10.49%-- __pte_offset_map_lock
> |    |    |    |--5.17%-- [hit in function]
> |    |    |--8.40%-- tlb_flush_mmu
> |    |    |--2.35%-- _raw_spin_lock
> |    |    |--1.89%-- folio_mark_accessed
> |    |    |--1.64%-- __tlb_remove_folio_pages
> |    |    |    |--57.95%-- [hit in function]
> |    |--36.34%-- tlb_finish_mmu
> |    |    |--14.70%-- [hit in function]
> |    |    |--84.85%-- free_pages_and_swap_cache
> |    |    |    |--2.32%-- [hit in function]
> |    |    |--0.37%-- free_pages
> |    |     --0.08%-- free_unref_page
> |    |--1.94%-- folio_remove_rmap_ptes
> |    |--1.68%-- __tlb_remove_folio_pages
> |    |--0.93%-- __pte_offset_map_lock
> |    |--0.43%-- folio_mark_accessed
> 
> Period (ms)           Symbol
> 49.580521             oom_reaper
> 28.781660             unmap_page_range
> 18.105898             tlb_finish_mmu
> 17.688397             free_pages_and_swap_cache
>  3.471721             __pte_offset_map_lock
>  2.412970             tlb_flush_mmu

yes, this break down gives much more insight. Percentage is quite
misleading as the base is different. Could you also provide cumulative
oom_reaper + exit_mmap(victim) time in both cases?


-- 
Michal Hocko
SUSE Labs

