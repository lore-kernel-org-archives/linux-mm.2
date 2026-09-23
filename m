Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58BBBC98304
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 21:46:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED0846B0093; Wed, 23 Sep 2026 17:46:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E810C6B0095; Wed, 23 Sep 2026 17:46:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D718B6B0096; Wed, 23 Sep 2026 17:46:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B3D886B0093
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:46:33 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4A886A2A04
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:46:33 +0000 (UTC)
X-FDA: 85246361466.02.5C8DCB8
Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6A6A340007
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:46:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jciCGrZN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790199991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CWYKTy9ur2zfAfW3YtEaKW/NAKkIGa1U+2owoaIL5wE=;
	b=EBi7fyn3A2IIN6E1bFvtNDrV5N6pm39C1stz+RVtPqQlKfS5hljZYqDsu22ecs2G79gkNQ
	pjZXc1T44XqmDvXKYpPBsxR8B8PSVpkd8hdQsg1YPLNiixwMw45Dt6rC8Z/47+biyJmjP1
	CeJ815hFj9NCji4/z+s7Z5q6HesWfXI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jciCGrZN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790199991;
	b=FicBPZkUGfbgHEXyQ90F90fOQWKdsEe5mYaOLhGdmgDQU9MUz8kRcqrjThr9Qj4QGo3GOT
	xdjWSrELZAuttIl0NrbWb9wbM5UR/vz6lN6B8Xk6SV3v8guqEV5z+p1D5aUEYeMzjWXbK3
	uttV4t2SWzyzVLwvk7jU/RkOQbhax1M=
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49b965f447cso10816795e9.3
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 14:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790199990; x=1790804790; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CWYKTy9ur2zfAfW3YtEaKW/NAKkIGa1U+2owoaIL5wE=;
        b=jciCGrZNcQWwjQ2G151Pwa6xbmNmJk9T0ajLnukE3DJszoQGiSpx1ltLHze2prHCpl
         YVvt35UoMpl+HMITuKM5rx3jBHXr4zqCyo6ZkeJSkCD2zWxGHwJXkZhubkhvvRP/Ojce
         U1Di2bCJSiNyj+5R4c7PpBb3FecRoPL0WaTz/1SDweX7w29qEcEZBvvUqPSp7vYTMkdx
         5yr1KQZAjPHLo3+IkAYV/3iWwFL/UMmMPDcxJFec8/8p1I6nqShD5ntY3/XYjEnIkL2w
         PHk/y7yc7SULdcBXsoEka5vzr+pvjaHn1v7C15Om+ilc3AxUsCr4u3HbeEsd3wKYzbIx
         AhbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790199990; x=1790804790;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CWYKTy9ur2zfAfW3YtEaKW/NAKkIGa1U+2owoaIL5wE=;
        b=RIMfPemIkWiOvD3veC2h6qm+nW3ksgmHC8l/I3mowf6V+C48yjONLSxTloJD54hdRL
         a8InpMpnzr2Bm5/6QWkqemEtUhVLWwGIFjclYxZgIN8tIeXESM/uIomRc4t5ZegB+h2b
         tRHJkb6uWJv7fcgqDnqgzCEIu7YiaE4FP+GxuzNdPlmma9Nr0l2WFqLEHS4kq0fAUwOp
         r3CHSxRxTf8BIznze53DuUtKVx5ffYw66wPlI2exvC09N/4UGPfoqD9U2/999eDsuA+L
         a5terLd3ZA2F5zsBlSLPeeHF+aO7kLBaZw/c9dDgBoaAlfSfKVA86wT/3V91CAKeVG0Q
         ok2Q==
X-Forwarded-Encrypted: i=1; AKwUvBw8GKwyekmWxlCoTzM4W4pmt5sqq1IBIxuiNyzNxxAzgnV49TwGYVlJvMtm/1t8IV00gFDWDcGJ4Q==@kvack.org
X-Gm-Message-State: AFuF++kJhzug6d7fBY5PNxBM1EIYZRWRu7aYqrT8lbgKOMJvrj8KZ67G
	uDvS4PUq067oLHEfqJzAK0ziKf+MYfhEdDwwwMcTJHafBOo/1q8GV/2r
X-Gm-Gg: AYBFou3kX25IS1pa/E7rGsA7QE09FIFuDBdLUU8wm8HI2Dkrdmg3+p2LcahuMH0GWl/
	vFMeHOvZkHpm8/qaoH8PL4O6j8u8a+acBjt7spu4V5hqWECsaXLmWYBMhHER38VdAAxBG4RV5i6
	GoWeHQgzecFq7PRmicwvV0iFC9AL0lmuZPYw2fpqGnR9ltL3Xafoa2WZ8Me8AEqDYC8EAkhB7Fu
	SeiZAWD3azwmEG4rN2faOw3Cq2S75+Vf4u+v9RuPdH788NbYyxxSczWgAoxMPP5l59zupfOsf3C
	4hBbfU8JUklKgEHCp3EFUIfpx7ABOQRoVCaKuq+kJaxH0hrKyjADXjp37dAfZuXRGKL8sTI9H1E
	woLcexKWsUEZb8n/u8GdiGjAb0v+1kqzV+5On1fB6XNQPKBkzloEm3NV1QFcYl4A+shFhuldPyw
	yVUJvXQiLf1ceqe82zLkiBf6n06ofbj8VGPuHK7DSG7xQ5/De3ej8PB/WXTk1U2pMcze/WznSJF
	4J8+XkavzuXVuOPtM+XdIDioJyB22FWCdn54Ad1cDzYqO6FuVz0Rv1FFIb589tXhoxS3ON73312
	fENCLx+9LRekFicu2mFRd3zfoLlDPnsSnC5ZkDeKAV9e2eIA9kxDBH4LCWD2njgFWlz4Ps9Nzwy
	KzWyy0yhl/uWBVZY=
X-Received: by 2002:a05:600c:8b22:b0:49e:7d25:f397 with SMTP id 5b1f17b1804b1-49fe66d30c4mr8601345e9.15.1790199989777;
        Wed, 23 Sep 2026 14:46:29 -0700 (PDT)
Received: from unknown748F3CBA5068 (dynamic-2a02-3100-a4a2-9601-c082-2dcb-3f3b-92b8.310.pool.telefonica.de. [2a02:3100:a4a2:9601:c082:2dcb:3f3b:92b8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fe43fc27csm26083595e9.2.2026.09.23.14.46.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 14:46:29 -0700 (PDT)
Date: Wed, 23 Sep 2026 23:46:27 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/damon/core: preserve the caller's quota in
 damon_new_scheme()
Message-ID: <arRHl5blMrrmvhkU@gmail.com>
References: <20260921171155.3359-1-sj@kernel.org>
 <20260922120845.44460-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922120845.44460-1-sj@kernel.org>
X-Stat-Signature: kydnnbrsyhkrtuqgw988k37k6jb1t3ng
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6A6A340007
X-HE-Tag: 1790199991-144285
X-HE-Meta: U2FsdGVkX1+oi6inUxZDqj5x2KeWM7aeFeDgeanWCSUOpC/N0kvguMFn+4je1CfAkmHVUI5EO6Y7f39wUJN4EK63Ry9ZFaO0NYfxK8OPIbA76enV23aF5mZnRNH/fLJh4/IZPVLdV04DXqvMQHSi1J8iFFxbdQ4wM3m2JeqUUtDL3X7hd7H0V22CoP2m+pIetHClzQYD0MSuoYjRC4HEXc9DSjeHb2RdQybeBb5KcwX5COxg5okHbbk0AUkvnqtqJb62XXM3jGBoXG6JZDkbHrqgMdu/phk0DP+4YqHVBl3dppPyzs4bWwA7mgUd77FDvKD99kUReOazCIOu5j++EDLMfnMkZlNL/cdKKpi2B7tCEodnoJKHhrUKuv3LR4tatRto60/zmHGkG2WvZF5c7tQ28DLF7ixIopPvTxe0OszBq+zUjRiJNLao0aDAxUQUD8c2vdwc3hi0NSBx4taW8vzkwKVCOar3kJ5f2+99FfDoqPeZogug3nJdRq4YDrIZ/7352Reab/G+Ld6dSt8kutVywKvW8IXXLmRY9DA3GmQRDr00dFfrrUFqNi8dPP+KmOTQ9EwFj0zAbyo7j26yBLVVM/AnkK5Pbn2F3Na6qCx9yzsjPzPV6XQRsPc5WRavnHLgq4G+W5BXXAWBt6WX+lgx47T8oMR9D8ZHAeI2sikTAxZA6n3cz9dHLSov4oJc8P1PFPfe7VnXpq+0akhmMjuJ8psHMiVB8HVCo67DLJHQ8OWdyWPS53ZJGq7zyj0PyZve2RVCBYanrS3m5DkcOT+B4TrdIRtHBr+Lq18BukJCWsYHXm80692roLWo+R9LzRoudXnWBGJgrvAE+0bRhppG+Aij3wunpINYRuE4HfdaOHKVAtC94U2NkXtHH7JJOuKBEOjKy/uatrLLYwoeNIuzvXP6Ofk8wEXiTgj1hvzF4btJuJi6alvEBMp+VS/hVj6kahwg+0oQjS1s8A8
 hyDFQr5y
 EZlgD2rlnYbAYn6u5e7eCiCVPd20KXmaaFgLY1Jy+LZz6d/0sxu/ELiGRncD5J3KqwaaFPbClmfNEn1gSc8Ym4gepUzE88VVhQw+aTs+q0xhkk0xCtOhUxyhvB0+6l8Iv1LfSTkf6YdV4no8romhbbxhBjFc73JkMSw0xIFk8rq9yPV99Svx9+EBXlU5IfpX5q0t/aHj4JOhnVHYCc2XjcxUrG/ZP2JG3dVr8Fi70zNZvyNS08sSYACq5p9U01eqmVFNttlld+pVL0JbgKYeGvCeK4tqd/DUCISjXs28ir58uZ6N2whYTpeQyZwyk5iP6E8TgFsluHVmXjP2o2sJbBaJcqB9NxtXziaDgnSXyqpgGKNAaoB3O1P1ZvAKdLEht6+I5wdDnWhyqaW8/kI72FSpKPrR6ppbQErYUAeXILshZdQeLZVQ/Wwftgv97KYzAW4Jcq6YIFZeIv/wzTcH3M0l8ElY+uocP5w/4jjmnhh17P+boZmhyp02PepI8SoNCu6FH3/AtsmjCAaA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 05:08:44AM +0100, SJ Park wrote:
> To calrify my opinion more, "caller's quota" feels unclear to me.  I hope it to
> be more clear that it means "the quota that is passed as a parameter to the
> function".

I've made it explicit that this means the quota passed as a parameter
to damon_new_scheme().

> > > 
> > > damon_commit_ctx() first copies the running context into a temporary
> > > context for validating the proposed parameters.
> 
> I'd prefer using the term, 'commit' instead of 'copies' for clarity.

Changed to "commit" for the context operation.

> Now I understand you added the comment for commit 60bd24f272d0.  I think Fixes:
> should also be 60bd24f272d0.

Agreed. I checked the diff and earlier callers. That commit first passes
the running context as the source. v2 uses it with a plain Cc: stable.

The LLM suggested the wrong tag, and I didn't notice it when checking it.

v2 is rebased on mm-new and passes all 46 KUnit tests on x86-64 and
i386. I'll send it soon.

Thanks,
Karl

