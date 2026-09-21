Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69F58C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 20:03:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8062C6B00B2; Mon, 21 Sep 2026 16:03:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B6B56B00B3; Mon, 21 Sep 2026 16:03:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6582D6B00B4; Mon, 21 Sep 2026 16:03:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4206F6B00B2
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:03:20 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C2E37A02A3
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 20:03:19 +0000 (UTC)
X-FDA: 85238843718.02.60152A7
Received: from relay.hostedemail.com (unirelay05 [10.200.18.68])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8ADF714000F
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 20:03:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790020997;
	b=vWS0ovRO4t/nC+UUVWsrzWBStMmigdOa3QdwJQqmTqOgqUGAtGnbdw35zCPM0BURQq9H9O
	yb81ScnNK9oz3qiWQgQ+YKKkf9MZlcQcyY5v02V1gT4E/a+V/IyD6SI2217/2XtphKcj9d
	gm/mt+wBtF+qvFmfHKlEW4hL4jJGu2Y=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790020997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eQm/uwfE/blbvgLVhCQkOkUD5IsuWeBPyg1vuiu/AZE=;
	b=U3NV2KC9cFAjv39YiR9ApWW/QZLUOd3Ggb0hKjV7o7U52iujWEnIX/iCUUO1Nnqsj5WBs4
	LtjJNxX+fmJaCmXfb5sfzSD+cC31dQ/novZXjl9GbNrQNOQig4vmj32UiNuHHhOb2POYWf
	gunS27s/NZKeKkCflxeJt4GxIPTtW+Y=
Received: from relay.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2057C402B9
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 20:03:17 +0000 (UTC)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DF28D1402AC
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 20:03:16 +0000 (UTC)
X-FDA: 85238843592.02.B23D867
Received: from mail-qk2-f42.google.com (mail-qk2-f42.google.com [74.125.230.234])
	by imf14.hostedemail.com (Postfix) with ESMTP id B7C11100005
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 20:03:14 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790020995;
	b=SAzMOwvO6SiCvC0zQFt6CTMHbStGJqvy/RRkVdp72YhsZK7pTHZzXVsJq/cNA89nRfD60C
	WH5qNKJ24vDYUpnl0J3hezgjYmqpDvLegoOO4Y9E+hrG15XjXWUUqene6RTikF20/gpvj3
	+5Wy3VfIQE53WwwDAt3Pzi3IiI5RGDI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=iDy2YK3j;
	spf=pass (imf14.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.234 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790020995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eQm/uwfE/blbvgLVhCQkOkUD5IsuWeBPyg1vuiu/AZE=;
	b=UWD03QPYz8RWGuF9hDddD7BMLZJNlonHGMFLyUgNfF/nq8OhT96xoiPEzcTgmOCjv+r5sU
	QFgXLssZUkb5OVig4o2roZiFzUNRlSvnWVD5JyJzjYJO/ppe0VlQnwel5GdsE9r1NZQdcR
	YobwosUdmAaZ6xTCInP4Vi2dUX9T+N0=
Received: by mail-qk2-f42.google.com with SMTP id af79cd13be357-93be29bb454so376125085a.1
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1790020994; x=1790625794; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eQm/uwfE/blbvgLVhCQkOkUD5IsuWeBPyg1vuiu/AZE=;
        b=iDy2YK3jOlMCwnv+pkaFzWcgjyae9EgI7IwDjlE8q/tdDJenIlX7gm/R/aP5ogaXav
         ixW6Hl+ofgZW2wPejrfP/57tszT6UaZd2pDFVc2JlzSAJPp5wvVsCYDLcesBVOwuZOeg
         LuwGQHmHyIk5cc9fT32TFefquQ2XhYyhbOLSI9DnpI6Jv31/hMqUgBPRYiP7JkEWAGda
         pvKaiVF86b5EuaS/ITubMQHgp4MyYewDYGxjzG/wdLaJR6yZq8MA2EDGrgHLyghrng0D
         wz+ca0kt6eyIy4EBYst+rxNhY5jjtt3Tuqa7gMtX/wuEoDoOqWSpn89WqBsbCZoUiZVw
         LsbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790020994; x=1790625794;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eQm/uwfE/blbvgLVhCQkOkUD5IsuWeBPyg1vuiu/AZE=;
        b=Mlf4ZJszpmFMs/A7I24NSRahOCdu3Nx6XTo6s1cFpzWzZbGRfP4A+jN3kPDdVF72AY
         0fus4p/AYltwBOrFOcYlfW0I+65dC1gKVVIE9whfx4hlIHajyvQxnvTWLUAc0176Yt/g
         1dY9o+oTC/51idQjNU7+O6rKFbfBSmkWjx3slJqJH7VAva2l7fscvIeeailasj1YKWco
         FOpA8U6n6F+B3twDT6Zifn+Po8b92tI+d2yVUxqUIAmn2B+nnQz71T2ILXz9CzBQUU69
         nd4CV1xJc0lau02OantSCGUScOQe5AKsk2Z4iKoFJLH045Ao6hsD39KkEqyXGOU41/mm
         Q2dw==
X-Forwarded-Encrypted: i=1; AKwUvBwhmUd4QGSUno+sdO9fhNxWAYFH17YFQZaSFJ2+8CegZr61TBBlhIsEh+C3WNm1LbAo3KA47kuNBQ==@kvack.org
X-Gm-Message-State: AFuF++lBoZ7b9Fm8ZtRMmCD327uDbiYqcm679nEsEET+jPqDQ+QN1vPC
	AKQVRTGNn2Eo3Av5C7aX4BI7K/Zd099Hyq2TJMBB3z8mfU1ujlq052BYfbH1RYyoaGg=
X-Gm-Gg: AYBFou0g+q3Go1qMGNd1J+FtFJmlzq3dcyedbEnmRGjj7ddE49EXQXfwCLuu5Nnf5xb
	ewnn4MYFpcX+ZERlFByMAfS4aFJG56I7H4p0uzpcjjX75MaSXLjq6ArHCemaBVxZ9a3s9rKLlVw
	EHWEmsL4jgo4xf+5q1+C6l4+CSoUoo63fXrnundRokixxvuJfiNkYIEnKyGSq9L8CKBHL2Ue40A
	pa5ytDuhiMB6BaIS8KMYkjyvB26ef0LbeeXL+9NVqRgOccQA2nHRiwZER3Y3NUkk+ejxyi+hQTy
	DIgovzvzaDN7HhAHSZzv8G2qPoI9p9EyeaB3K5L4eRsZDOkkXhWa8rEs7M6KMnNkGURwoWZk3Ho
	WpHRr7EO3Ia6tWEfJ3j1kTrYQU1rLwZLKV5uTRk/X4MdK3g5dFuDD1JmDG0wn4+gH1uJRWXheQL
	FcVXAmP/H3DCRpUfQ1WyRXKJvTaEpj46XGghu2jbltkPJpS8NbC8WWA5CsXBwPngX/aAQS
X-Received: by 2002:a05:620a:1a11:b0:93b:c332:3d9e with SMTP id af79cd13be357-93c198e7a38mr13199385a.30.1790020993597;
        Mon, 21 Sep 2026 13:03:13 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c19a9c777sm4296385a.27.2026.09.21.13.03.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 13:03:12 -0700 (PDT)
Date: Mon, 21 Sep 2026 16:03:09 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Liam.Howlett@oracle.com, david@kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, ljs@kernel.org, riel@surriel.com,
	vbabka@suse.cz, ziy@nvidia.com
Subject: Re: [RFC 2/2] mm: page_alloc: per-cpu pageblock buddy allocator
Message-ID: <arGNfQQAVRZpEoPl@cmpxchg.org>
References: <20260403194526.477775-3-hannes@cmpxchg.org>
 <20260918022222.22955-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918022222.22955-1-laoar.shao@gmail.com>
X-HE-Meta: U2FsdGVkX1/HIJcHCZpkkygFr1H1rfOYkSfG30thMtTWIXN4Yp3Tnw+VccFXsYr3oDUj6vAsqst9Rm8jBfqXHHaqwlcWSUpLvPrLzSTrya35Bbs3w8/DENmxXb9vc8029OBlLclX8zeHFKhepyPyUQ139G8kQbqRtm3ZM+JJk60XZaj0zhJXrLSLoLUgW9eyf9KtKCSBUQAlwgm/2BmPDfyel2grj79TxaCkXBkgsG/4llVup/LH0jaWy+DrMYvnHbbD6q7NZbeqvjeFrX2MiUWHQ2mYZ4etVkjM7ujaYubHfuZhkphN43neL3N4bC1POEWf3NQDmlt7Sb98CsZTUvC3M3KTxLILhJmwoT4/6yhZMBKvEacfXPR4KNuqbXAIlDcN6cEmid616o8wAWLurJ/84Ln+vNab9HIdiIP4fu5i2opN4L5JpJX6EjYLGpKz6ZxaeoYSETByWRdTQ0CrE8adQsh7cw6Vjqx/SYZvJNiDUTko5rVStxdrgFfbgWGpHAp04QnIpA6M2aJ1lPxS2kd81S0hM4sLsOaOr89I5EkVuVG269r6CzuekE5COOfyjCXplJfWaktVsY+lE+zR0mQ/Yk63DYZWPTy8BGpDKyv7T/odllTuds0l7dnZ0ZR30aFhq3c3PusbUNSqWFZ9u/pZrm8DD14tuSfs166hIQGLTHtpAMmReuQCHbZbyIEsQIXU+3HeolBp2AlNFjuQiVXM4dismpQoGAtahVDCdL1ZSVGWJwaS45yICkgg52hulBjcmttgfiKtuLoQYVsbpxtpM8+fnbcEITit7Mk7ONrzKO7p+sHojH2TgiVsWEUN2xbSBuCwsb6eDJNOOQDmsObo+lMMbxj13n796EXVNaeWUC8qrSy+CydAs+ReUSaaUEr41n7QdfkEyYjeZTOBFNwPKvA46MEI9K6n2tlV/yI6rtv8BlMj/oE8kO9aYN/lp6DIMkOP2NCnKYm1ysG
 ph5s3oUn
 NPVU1QkAe2Hfx5Kfpo4QFBmevGMiLDmbKemvDfKA2ff50aPx8WUZ+GXHUG0gw1r2ab8pdi1xnG6Uia5nPoopKjV/3R7n669fTAf9emTVGOAh9RECeCCDR9LlRXLMHz2zk2a0q3gHkxoi3NMrOVcPXHXlI2+wadjAjPhrR9CjJ5mAhFg4pR/8qSQi7uFQ/H0o/D/9plfxinHflDKrru+1vo+0FjyvblQbUQAPQbQWZxhirUOyrzMrEqezD0vqaA79U7LfRauLRa8atllxSCholTKWxB96ABo8mvd/FvQLqu3WnJLEhw841m2gc4AKNzxE5kNVGEJniLDg9u21KmcAF1tGG5cPkVzbjEO1Zd/e53LOEHFWaOFIw5M8bXMaHP2W4h0jTHCHKGVpJXVKTDOCp0QhTUVB1evd7XZU9Ahof351+FcAWK5ajl4Lgj/cFp5w9xPNOFVmYfTlb6cp9vzDbuEkcFm43oJBOGedfE77WBaiDPSRxZXohKNjec+AE26/y2vbw0+okdmHDGAgU3jHNL7VevKooFtHwTB8trkJBhPo+R0c=
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8ADF714000F
X-Stat-Signature: o7ryacjmd7snyjtscf5jqmy9y83y549m
X-HE-Tag-Orig: 1790020994-549927
X-HE-Tag: 1790020997-226946
X-HE-Meta: U2FsdGVkX1+JDNv13QDM+SoKMR0WccR6kFTHXI0QRyq+gE1F9342fXrfNA+Bl/V7mbz2rMv7kGxSyj7PnGtiRw7WssvJ98N3lDr6zXBnumTiqvZNguN6DUBJaLmqfiB7lnIoJ0FEaayKor9drQzRM/e8fERvS7HZeINcnVSNBh8sBmxLSixyzyK/GSf0PQO2rU2tP84LiUjbBl38X5qJWycsiGum8+uNw8kGLrjRlrm+qAdu63mueVcZS7Sgh7XHllACsv0WcGtvmywiFofd3EjIUjVJWmC/UZNAcT7JhYDLqCboz2WrmG/EKcWqzM335u0EYwZ4syg9xHACpIQ8XOpK53PtWo+nsawqdzt+k0QHy5Xsxkit0pk+juhhuYucvseotVvM70+Dt/UvENee8GRuDuPa3bc61bxlc9zDA2mLIcPJaXrT/98fyNJ39ii1SjjKi0vvM6vQnaXHGVLfEkjOybbETkjdO6or9aCERlxSIYJ/ycZvu1TCsdkdXbQCcqiP6snDouC3l9A42fWD+uNAQfYMX/2SgywGsxzJO54kJn/oK6u/3SBIRum01ww3XJK+mwIZ0ZMzPGiAzThK2o4VrSY4bXsCa/ULGh++PwZupfC1p/Fr/WEHYlGFZEaabVGlHRzgbCAGx6dbyXazF6zQ15fomzRc5CTXMFy/rb1YkUDfaomVNkp247b+cARCkV+AavnqhJCsLcNFkEbsleGq2v5ZzXuSBAmvLMMn0P4k3GFJVblyNc5t/MtfYxWS60mzVZikABf8mM6/AEU5I3oMDNVe1Qywn0ssiVcth/P/u7SJmkgmpex1uDOWQ8R+X3vYLuh2yB9ZAqE1fERtX4mXlL/jUhSfQHOnkk4ZUtCuajSxe2i1I9VM7mlnrTjbETYA3KQ6CiHbt4ksOp9e4No+kCJ4q+KYXwHS/2Bt6OdhpLKNvt+ZS9GXQ6HhLxkSQm7pmDTvKvmO+qu+zHQ
 Wtmb6o+U
 q0WiLHLtVSDb9gwPwfFNEyJ6P0dUIkuFR0tFwJghc9KGTILupzbDZE2rg1SI+Z2LNIfcalf0bjxnGID7dL/wwbnkaUcGX/eWtAJAmRmsiBCKWMpFsqPF/6FujV2rAlfocnqlkHeCFZMaYgXIxs3HAqB0yF2YmftDOyZYkfvci/E7KwyzE4AczV3sXdWnh9zi4nMg2acGOjvU54x9KyN4ijE63vPAx3dPVsUazGaGTlYwj7d+MbJCS4AdXKHAs1AA8ykO9YwxIqdjnCgsVlMAy53T3qlFWakNMtrLNe9ccbBmMwMJ4h2CUHeAuuOLBSJPpyIe9TQn1qg2yuQAj+ZCy1r1OZyDCm1prCgWgHSXS71YPXKB8TKqaG5NzKPFiqpnSdM6MdTLsMouVOLxF+5pgLTsDxlEtUIbejjoW3SKXuxpZ777XgCGRiVZnUQF5kAkeg1+aKSzCJ42w9zzjSysUcFMsICwPl4sULMTSRPjupelJJzS+Lo41clN9QYa43KHQNc0XFPZ99ivhczw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Yafang,

On Fri, Sep 18, 2026 at 10:22:22AM +0800, Yafang Shao wrote:
> On Fri,  3 Apr 2026 at 15:40 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
> [...]
> 
> > @@ -2941,15 +3242,45 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
> [...]
> > +	pcp = per_cpu_ptr(zone->per_cpu_pageset, cache_cpu);
> > +	if (unlikely(fpi_flags & FPI_TRYLOCK) || !in_task()) {
> > +		if (!spin_trylock_irqsave(&pcp->lock, UP_flags)) {
> > +			free_one_page(zone, page, pfn, order, fpi_flags);
> >  			return;
> > -		pcp_spin_unlock(pcp, UP_flags);
> > +		}
> >  	} else {
> > +		spin_lock_irqsave(&pcp->lock, UP_flags);
> > +	}
> 
> [...]
> 
> > @@ -3025,17 +3369,35 @@ void free_unref_folios(struct folio_batch *folios)
> [...]
> > +			if (!in_task()) {
> > +				if (unlikely(!spin_trylock_irqsave(
> > +						&pcp->lock, UP_flags))) {
> > +					pcp = NULL;
> > +					free_one_page(zone, &folio->page, pfn,
> > +						      order, FPI_NONE);
> > +					continue;
> > +				}
> > +			} else {
> > +				spin_lock_irqsave(&pcp->lock, UP_flags);
> > +			}
> 
> Hello Johannes,
> 
> Thank you for the great work on this series -- I hope it is still being
> actively worked on.

Thanks for the kind words.

I am still actively working on it. Since the last iteration I have
addressed a few things:

1. The locking bug you are seeing. Rik had also run into this during
stress testing. The fallback to the zone buddy on PCP contention
brought back some of the original zone->lock contention. So instead
I'm using the zone llist introduced for lockless allocations.

2. The PFN search for block recovery that Vlastimil pointed out. I've
tried various solutions (counters, bitmaps) but the thing that worked
best was having the zone buddy itself maintain free pages of owned
blocks on a per-block loaner list (in addition to the regular zone
freelists). This eliminates the sparse search altogether. Recovery is
then: pcp->owned_blocks -> pbd->buddy_loans -> page. Every page
visited gets recovered. For the loaner list_head, I'm reusing
mapping/index space that's unused in a freed page.

3. Removed the unowned buddy splitting on the PCP. Vlastimil had
actually asked to try that separately, as an incremental step, since
it's self contained. I tried this but realized that part was actually
bad altogether. It violates the rmqueue_smallest policy and causes
runaway fragmentation - just like the new block claiming did before I
added the block recovery step beforehand.

So now refilling is just block recovery -> new blocks -> unowned
singles of the requested order.

Incidentally, this also eliminated the CMA problem that Frank pointed
out, since the other refill paths respect ALLOC_CMA.

4. I realized I'm also violating the smallest-first policy in how I
was mixing owned and unowned chunks on the same freelists. For
example, an order-3 refill from singles sits next to order-3 fragments
from owned blocks. Only owned fragments, which route back to and
reassemble on that PCP, must be split. Unowned singles must be
consumed at their native order to preserve smallest-first policy.

pcp_rmqueue_smallest() could check the PagePCPBuddy() flag to tell
which ones can be split, but that introduces another sparse search
problem, where we might walk higher order lists in the hope to find a
splittable owned buddy.

To avoid this, I retained the legacy/unowned pcp freelists (up to
costly order and THP), and added a second set of buddy freelists up to
pageblock order to the PCP. This way the rule can be maintained with
O(1) list checks instead of O(pcp size) scans.

5. The on-demand merging at drain time proved problematic. Draining
isn't exhaustive, so it can attempt to merge the same unmergeable
fragments repeatedly. I moved merging into the pcp free path instead,
so every page is tried for merging exactly once, which seems to
perform a lot better in performance testing.

Overall, it's gotten a bit bigger than I had hoped for. But it also
looks much more robust. And the additions described above seem well
offset by performance improvements in tests so far, even on smaller
machines.

I'm still testing and polishing right now, and hoping to send a new
version soon.

> We are suffering from heavy zone->lock contention on our production
> servers as well, so I backported this series to our internal 6.18.y
> kernel. However, since deploying it to a few dozen production servers
> running workloads with heavy memory and I/O pressure, we have been
> hitting hard lockups at a rate of roughly one every day or two. The
> hard lockups look as follows:

[...]

> With these changes applied, the affected servers have been running
> lockup-free for more than two weeks so far.

I'm assuming you saw an improvement of zone->lock contention. Would
you be able to share some numbers or observations?

Thanks again!


