Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B045C5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 08:19:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 353E36B00A9; Fri, 21 Aug 2026 04:19:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32B056B00AA; Fri, 21 Aug 2026 04:19:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 268F76B00AB; Fri, 21 Aug 2026 04:19:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0664D6B00A9
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 04:19:30 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9AF7C40393
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 08:19:29 +0000 (UTC)
X-FDA: 85124577258.18.EBCFBE6
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf04.hostedemail.com (Postfix) with ESMTP id C6D8240005
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 08:19:27 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Unf84QJJ;
	spf=pass (imf04.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787300367;
	b=yyOonaNh3cICgdWTZzeTSK89+VYXEQoW8ksuL5phXa7EZgf2qfTCKrWUK5rKrEdC1Emv5K
	jG/72Js04v/2rA1gU0aEwBnwyfC+OzxWq0Zh8TgCVTb16RT2dC3uPl4qfk/da3dGCFSS4Y
	D20WLeb5TLowtFDZJz+ZvuqQUnxFTgc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Unf84QJJ;
	spf=pass (imf04.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787300367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lhXuBcyJmXYpDqWCX/Ojyplzefto48/xHEW5jp//TXY=;
	b=KJ3DxXHi7rvJgQ5q7dgB3tryZH+C7rDnzo+hLafkQ8q/jwZtJZy9NPZwDYuYy97Xk+qO1z
	SJ9IRMuopMYH1FLuU9RpA41gBx5ZucepZqx46z8V25LZrA5fgEO3IkNgwhucLG3ep74kDk
	ZAU+0j67FkSSI49Se/8xQKKTPeI5oBY=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2cc891373e0so8888155ad.2
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 01:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787300367; x=1787905167; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lhXuBcyJmXYpDqWCX/Ojyplzefto48/xHEW5jp//TXY=;
        b=Unf84QJJ5aRzyfgKRXmaf0J+vswZjrdYHRKAu4gYLJci3gwLmMm6sanLs1whA+6TB1
         epFOx+wAc7K/KzyxbPZsIp68W48qG8dcn4N5CQDPP9e8dxbRNCebDSNHkXGiHq3lgamV
         R9YUFeWgGCdTBTTH1KxhdcDDSX5xLR3eGckkoUw1Al4yHHAzhXDDqSf90lGjNVdNmy83
         6JOex+NKiQnoLA2XMCEnI9lKRCUuGWQz+rTmEN7Pjf+ni3iSy8/OSEli9DOxIgsiceEi
         onpi5omGD31tZ6FcSdRX1gQ0+AQ1B5IJ13EUwlmIoO+i02HQ5QYkGhle7vSFc0xksUfE
         1deQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787300367; x=1787905167;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lhXuBcyJmXYpDqWCX/Ojyplzefto48/xHEW5jp//TXY=;
        b=mGAG6jg7QHMKhrkegOIVD5L+UHlgq0H8yuyNo39Or7Jo6qLN78jem2qUOUsNQdSjLP
         K5P9QbaGS8VhwJgsGiS0oqEsTnD82G7gMAAxlSvt7qbkx+f3WdRwcO3DJDXKw/f1pYmw
         4Y75D3Ky3//FxeCkT0UwEjduPMjxt8Ylwkn7T5PQ3odODoB0GdUdyDIFjjlHEIbuaMzw
         dOMwDJ6Zrc7sQmDmnKx+Y8+5Dt8n+XWRX2TTtTZnQQxFU6iUEbc/knlrdHImlqPWFVTP
         V582XGdLRK1rbJIjwA13xFnugEVVj6wZ9qT/IZM5ufUbagNHi8mZq1+P/+F2FEELkMFK
         F5Gw==
X-Forwarded-Encrypted: i=1; AHgh+Rq0FAcBttbTL6qdWz3KRq8a0uCyHjtP2kFYyuFsypMwqN6L4aHKAyEIfuVUWhwX30XGm2TvvbBvGA==@kvack.org
X-Gm-Message-State: AFuF++m94BhPwSU9Zl6ftWY5DO1z5995StQxFezd4R+nkkWVXJD7qcS7
	TBI2bA9I+zrYwPI2Gx/7DWJDXG2bCf22PaTVXWKUqe2q7TRwWmw6aFVK
X-Gm-Gg: AR+sD12Zz6X1BE5aqyVBbcyYz0HpafVYYbqGwgWYOYhqU9avfcFzShv0gqhqlN/O3ZG
	z3AOOH1fm2GHg9aFt9fl4wkcqLnkd+OUuKUljtCcsnuKJp8AX0PB0ofpXaNz3DxA0rymscGF+vz
	cx9ooEfj9bxUU1QVurWbakeuevQVKdYat/U8oufqFDBQML/iGx8Dau3Uaim62SOE1hfCYOhO9YJ
	d9YtfDCOtdZEmJ8vHqOlC5WY7Gbn20S7OOTr+nfUU8VchJKUckp/Z4Lli8CXIvfOjlRqkAKLX7H
	OHdLA8vDz9OgHuHXv2Wg/Zztc0fgVJwJ5tvMOIpGypWNn3m4kxmBD5YTN1o5yDH5sOHrWBmWef/
	LffE3mF/j+wX0NDJFKLgNW+TMtu6TBwC7J3SCRzSWI7wanD95HGH+d0q/KGdvNqp9jcDEs4uE7Q
	GctRF26wBq/y2eWght+xM+1xMcOx6GcBAti2h1vUAa8jsjnFduTqqeLg+Tf50ltmjFuvfMoEsBG
	II=
X-Received: by 2002:a17:903:354b:b0:2c0:a555:80d6 with SMTP id d9443c01a7336-2d64ade4a69mr92013265ad.2.1787300366663;
        Fri, 21 Aug 2026 01:19:26 -0700 (PDT)
Received: from localhost.localdomain ([240e:b8f:1df9:a600:c693:b19f:ada0:748])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d62e36e15fsm16222015ad.45.2026.08.21.01.19.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 01:19:26 -0700 (PDT)
Date: Fri, 21 Aug 2026 16:19:18 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, nico.pache@linux.dev, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	usama.arif@linux.dev, zokeefe@google.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Vernon Yang <yanglincheng@kylinos.cn>, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/3] mm: khugepaged: fix folio is used after
 pte_unmap_unlock()
Message-ID: <10f5d327-d86b-4971-9344-ce29f40f8955@gmail.com>
References: <aoMynfFI2XK2UXXN@lucifer>
 <aoM3BJE2mGmHZybs@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoM3BJE2mGmHZybs@lucifer>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C6D8240005
X-Stat-Signature: ndoy6fqr97zwewc3bdqejwyocgh1h8yo
X-HE-Tag: 1787300367-788236
X-HE-Meta: U2FsdGVkX1+TmwlOGLLkAL/tZzNfdm3ilbAtMc4xOMl8+vVHY3H6cl+1ctyDUqFBLWuKTEJ8qtajtFJ5WYEXOrfOuqUnLJQ6svD56bvnF2gTCm86/J1G8mImLZajLNtnLwIApMVpLyF8PonqEBgNNErxCBOe3yKF5G8YaBg9il3wEy//kIaAnsWdTIoQOMPnxBkl39L1Jx+q+tVHaOlBx+nHA5O+jbUVq94ZoexGUQ61vbt/y7pOBfM15tOgCmW99hnclrtQSxPqn9GXI6yxrvfwFQEJ76eS4zWgrBl3sJcBS+0zd+CJFAULsQ7WkpXe3JqiKa1N9KBMSHl1U7+vVZoFYORYedT8vCcXRDR43JJ6cuBsrekrmRiCHFZIHzHtdqBxjjVLdt4NrTUEawD3BkW5Or/LkPE49P8jTFeAcwXzgqu6ewPzNygv6mxFcuNQRGV4Me27C0PF6g4aZn275gzJprtC6aPDXW1LROTlFNsp7XwNcX336yUr0F6Gp6Uvg10cwLBFZfpTtw8R9huZvbkrMhGUF2LwJei0FJkOkGUvW+kgg8LAP6X6SA30nX1YlinNH/LtnZdpC05Y75A1V5uznc2G00zBcU7Mf3U6j9O6yG7X1dDoWvcm9kXGQ4h5bEWWSGTQgFF5N2Gat6sITU5kTir3LNZcFcwi/o8pOBm6BUK+KWLCFco0jDBVev9mMckrSfh1/hcrMbL4HO0gTuHaEVQzp3O/qijjVC5u8Ihjxh13H7EXBJhutF9LyLoXfOSJEV/7EhzyBJ6iFzAZKfFbjGgOahAQUskAS3mjfVzT/ncg5EYGdzknStYfQ9fkHQe1XrNxND3W3Ha9rIz20piBI15uxJ7+tPWavxXDVKThsRuTPDm+YBtTDr/bjfzxhC/guygH7JWfvTmykK4HquUFxJ17OSb3ykYtbkPgKEqJlEjnVV9fZfP0EUKvnGM1249eh3KzSkUltU6OyTP
 nDUwifD6
 ulE8n/KP/jclC7e/FYECxO0vegs3w+dU45pNhxj/LJpU9T1zk/w/pgwabN7g+bSO5aE+m9KujLPhMD2+P+aHpRab6kASfrMUVZfUgcjDKFT3Fe+BrsLihdDq2f7zGo21JLkmHPCE7ms2aG0QS3fgemaELWEgSFgK6JUb5/D0ayJ4PsSMjT8mQZHq3smVqw1kB5FI2gtNtu7fnZhDoIMITz9ZqfsZDSk8kpEangsLXZKKa0WPrP+ntqi2Nadw8PP+hv278fucaj7Msk8eLhMr8ZOfeBY6va+BQHLhbwn+G+GLwxLXJ/OgmNfjvyqGJ1sc1NqqW7oWjuLI6IM0OJUSAe4KCra74jXssiAKGQCap2myVB07TKFtVSSFU216KZ0w9HB9/bKHWVv5ZK228H8xj3qHPg9kI7IPPsl/fvaYD1qTxNOpo39ek0fCSndQfwV3Mhu/+aK3LeYYlXRq4E4j5IpYefb2OOk4OXcyeGFfaVqWK0vGzFIE4FJgHnJ8v3xyg1WQQ0X12g2+6xmIOqAcr3VvCOxj8f7PBjAR8wpJ2pLuI7bc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 05:33:40PM +0100, Lorenzo Stoakes wrote:
> On Mon, Aug 17, 2026 at 05:12:01PM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Sat, Aug 15, 2026 at 01:19:23PM +0800, Vernon Yang wrote:
> > > From: Vernon Yang <yanglincheng@kylinos.cn>
> > >
> > > After the page table lock has dropped, the folio can be freed
> > > concurrently. The trace_mm_khugepaged_scan_pmd() is left with
> > > a dangling folio pointer.
> > >
> > > So using the folio_pfn() before dropping the page table lock,
> > > closing use-after-free window.
> > >
> > > Fixes: 7d2eba0557c1 ("mm: add tracepoint for scanning pages")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> > > ---
> > >  include/trace/events/huge_memory.h | 6 +++---
> > >  mm/khugepaged.c                    | 4 +++-
> > >  2 files changed, 6 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
> > > index d3572d4ef453..5dc71d292f47 100644
> > > --- a/include/trace/events/huge_memory.h
> > > +++ b/include/trace/events/huge_memory.h
> > > @@ -55,10 +55,10 @@ SCAN_STATUS
> > >
> > >  TRACE_EVENT(mm_khugepaged_scan_pmd,
> > >
> > > -	TP_PROTO(struct mm_struct *mm, struct folio *folio,
> > > +	TP_PROTO(struct mm_struct *mm, unsigned long pfn,
> > >  		 int referenced, int none_or_zero, int status, int unmapped),
> > >
> > > -	TP_ARGS(mm, folio, referenced, none_or_zero, status, unmapped),
> > > +	TP_ARGS(mm, pfn, referenced, none_or_zero, status, unmapped),
> > >
> > >  	TP_STRUCT__entry(
> > >  		__field(struct mm_struct *, mm)
> > > @@ -71,7 +71,7 @@ TRACE_EVENT(mm_khugepaged_scan_pmd,
> > >
> > >  	TP_fast_assign(
> > >  		__entry->mm = mm;
> > > -		__entry->pfn = folio ? folio_pfn(folio) : -1;
> > > +		__entry->pfn = pfn;
> > >  		__entry->referenced = referenced;
> > >  		__entry->none_or_zero = none_or_zero;
> > >  		__entry->status = status;
> > > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > > index e7830761d3a2..7c8c48577408 100644
> > > --- a/mm/khugepaged.c
> > > +++ b/mm/khugepaged.c
> > > @@ -1603,6 +1603,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
> > >  	enum scan_result result = SCAN_FAIL;
> > >  	struct page *page = NULL;
> > >  	struct folio *folio = NULL;
> > > +	unsigned long pfn = -1;
> > >  	unsigned long addr;
> > >  	unsigned long enabled_orders;
> > >  	spinlock_t *ptl;
> > > @@ -1778,6 +1779,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
> > >  		result = SCAN_SUCCEED;
> > >  	}
> > >  out_unmap:
> > > +	pfn = folio ? folio_pfn(folio) : -1;
>
> You already defaulted the value to -1, better as:
>
> 	if (folio)
> 		pfn = folio_pfn(folio);
>

LGTM, Thanks!

--
Cheers,
Vernon

