Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02EDBCA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 15:18:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 869E08E0017; Tue, 19 Aug 2025 11:18:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81A1C8E0007; Tue, 19 Aug 2025 11:18:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E2178E0017; Tue, 19 Aug 2025 11:18:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5332A8E0007
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 11:18:52 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1EA1116026A
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 15:18:52 +0000 (UTC)
X-FDA: 83793864504.30.429C94E
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3B2DB40007
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 15:18:50 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="auvCV/gT";
	spf=pass (imf01.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755616730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FRUc9LqkxwQZjbHD55dqvmWmLwFK/B3FIfNgwPcTxZ0=;
	b=BtcArAgVaFZxY9EfA758blxxIAyByV5Vr8duer34rW6Yurjjmp9BIEEtDLpqgv+KCPnw2r
	PpS7BjVTp0bDjkDXy1LtRj6kNJ2iCWTSVtji2ULuln3Gdfpud94rQsk2JXwgNAOshq4yIo
	DXU8LB7hZ7PbeuRMy1XlV4z+91lTH7g=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="auvCV/gT";
	spf=pass (imf01.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755616730; a=rsa-sha256;
	cv=none;
	b=tH8UUU6NeEQXiJdaTpPW+5VXffLZDdvBc5U+rNBHu+hDL8OH/pAyAwpny0BGAioQm7CDPO
	f/z5MXQMVpMvl8huwpLGq4HeVNO0o58fdYtv1UMVuXnmBsfZqimPfMfDGCj5lipTOnPAQv
	YIOgpK+wRPgzJQ+4lXamU2DSWivDLOE=
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-71e6eb6494eso32586007b3.3
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 08:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755616729; x=1756221529; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FRUc9LqkxwQZjbHD55dqvmWmLwFK/B3FIfNgwPcTxZ0=;
        b=auvCV/gTc2QZxNGxCSHRdNZa9v4NGEwjcpxMSsPe6+1aCbiuuLfwoJrDsI1Q7tWdrU
         H/AtFXjQbKFRhug4JTW1wRwXkIfHSmqpD8I0xGHnB+rvol5fUPIQ5cVnteqoIzmGVPye
         f0SHly9ZJi25o1T46W12AUQO1XEn8btCKK9+VtzVgTyzigdF3it6J5ztM6+ER6bUeiZz
         XIdetkZKAz8RpOoVw3ZapbgE/2bcdbmMJ7BpfLVtGS96OyD3K6zeMioP35H442ghXb4n
         r/DjRJw298Y1X7sT2z4jilo6A69R4LYKnYlfvj2LfhFD34p3FT1pgklOt1iiMmE6DU+D
         O9kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755616729; x=1756221529;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FRUc9LqkxwQZjbHD55dqvmWmLwFK/B3FIfNgwPcTxZ0=;
        b=E/1hYMpazyR8VmnYQT55L4uiHsekZN8YPGPMwO+QfNN78Ybj2hLa46klso7x5hLtnT
         M5dyGYH147a04flRA4MVUkl9WLc1RsyD+WzzuUzdZ6wWNjMdnFJlcMZs723irVbw8gj6
         K9MqWMVNPfweAFogNnxoBeoD1Fv+ESzxpXlQpqdcn1Rw2pWXsuMKtkM+FhYhBPzVO7AO
         w3m2H6mCmSLanZvLcTI4611VV5NJvPwdsZN7ddh4DC2zAxcNDGwA/x0KP8w+t6pSu8yJ
         uqUh/4TJ5/UJkmIo2zQzFk9j2ccFzETMJPnh84mGWk2HOOcLCcor2C7zctwdJ0Y7tpv6
         3i5Q==
X-Forwarded-Encrypted: i=1; AJvYcCWODJHHTWB7MwTE65GIXyT6EQ/Z4aZfcFnsgVMh9GJa62J85+8XTIKWDabIBatkxUeFcNRc+md/PA==@kvack.org
X-Gm-Message-State: AOJu0Yy88AryEARoGdplZRPC1L2L1xnfTvXl17BX2thr7aHFiSuXYqPL
	/Qy6eFg/4qYQNllGjV4GldQujQUk1uVGOmkhtZTlaUP3BGcAQ65JvstV
X-Gm-Gg: ASbGncuJNjL9bLtj9IydEXRI6IVmzIMSRZuCszNgJmNK8Weymvgk8zneQxvOBHPqfDz
	2VlT2VvV9htf4xG30X3nvaA/g5QE5VtwRNrxI8Q3wtVzJ2jq7S0jaWW/2oetnatKLwHqsdINHe+
	Bn11BVB34KemdBeYiYqwsVEJD0+kokhhpriurWPaE28JC16nUkjq72WfCHhr5gD7eONCes/tkCL
	UdUr3Vt1BGq9mdMq+BMAcdUwC7Wwamj0MJBgnSNtgjg/ZuhXuAAcCjYC9FwVjzNs5Hr94x3ZIF7
	ySd9qLrah86B9QptQOW+w+NxzaiAz6/VHsDBc61F5BGhFviGpgVuOoGn7GlrKyq7T567xZfauhW
	vj7o99VrUBbBWDFXYDUJ9Qw==
X-Google-Smtp-Source: AGHT+IEAYZG8JniwtwZmiJmxa46+aZaPP8w2nEYVSmlPFm/lWVH6z5++okUzfhixnHaV5qO9RKd7HQ==
X-Received: by 2002:a05:690c:7489:b0:719:fafe:e822 with SMTP id 00721157ae682-71f9d61cc08mr32926187b3.21.1755616728908;
        Tue, 19 Aug 2025 08:18:48 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:5a::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71f96ec62cfsm7947127b3.22.2025.08.19.08.18.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Aug 2025 08:18:48 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Chris Mason <clm@fb.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@gogle.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] mm/page_alloc: Occasionally relinquish zone lock in batch freeing
Date: Tue, 19 Aug 2025 08:18:45 -0700
Message-ID: <20250819151846.2000539-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250818171340.2f4ce3356f1cda59acecab57@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wfyiuocwisxrb95ntrtp57dhs9xehgjg
X-Rspam-User: 
X-Rspamd-Queue-Id: 3B2DB40007
X-Rspamd-Server: rspam01
X-HE-Tag: 1755616730-87023
X-HE-Meta: U2FsdGVkX19qixc/yIiKzszm4lLLaS8HZhEThUk5+vb1JpyOY3QwmAKuTtEc/cmCcP9XjG3cquyNKYx4S3yXjquzR7zBjx11y++kzMVSF5OfxpcDTkK3pjhg1KIXfPL9REUiVzwQ5tMlII/KTPuObdmiHSTkOPwqthhsQ9IDb0Lbs9gSJ4SQCbfMT6YwcLxDFZcm0knIPH/b8LJKAA82kbVK9In7jrkRzmC//lRWYc5z84Hk/q7CtEnKSRhGGXbvy9MMDJq3pMzK8X12i1fjVxEdYv7ftGxOlkdRQbS3SY7i9rGWPOq76JDMe5pgjjrqRyeTOjWUZndIlSeRvkD6YQysYujIuc2UBNTVvMisnaHvV7gE6C+T2qCJ2nmY0BYgNHA0VXFgX0X+llSCz0uW+ZSEAO2skc/lx8bhi1JXdotxsnZjOIJQomYJM63pcgDcGTQbkzAaTZbct0nI5hRBolc+zOME9LBFv2F590Mm7bmZQGhR3ty0E6nyVCNIxw7o2Zs4ZYDQLj+KMvg0FEvrtxlVVelwUBKim8dibe3sWx7DTUD+XTh4hoRQDvK5z0UmuoQteza+94SQMoPIE4C6AFn0vJ49QF7qPTwd/ePjXijKazb0hr4DfkAS6h16IyujCRBsr2wgYqO4i92D9iCcPH5vgfBhfFXMMutUo1+E5dD6XtNxtEoisT4ROxYOk4KlMbkrHMFcChqnuWymxLE62hgADiBPqEiR7/7nIEtTuG8xAgXjr+95/2+jddslyskDLSZEM3vXYFo6Z2Zx8wFDpRX2Rh1lRVXUAcwEdl1V7VN5e1l1VcCfuCC6xLGb/dcb5MFTiop0FadiF5jnoBdlv5h9wvior92iQObKqf1ET3Hh7yDnNvrk2I1E3tX/leOL8GfP5+01yyWGwnaBq8axP1z73pI/XmhcsQROkGKrfqSxca/LKEU0ED6cKTW1jGuRqfS+t0phnz0Z4Nb2Tcx
 bPSSo8KD
 Eij6biNOBupxgBmpitJFTwtiOUq6k16KPfwdiuj7xBOqMg9Q+BG1GaAY+Zs9VIHXA6t35t4el4oKpHezuBIvdr9J1XSSm0cDVF73AeBzf9RRJHjGoyRqf7r4uU4oC0GKNTBgsBaS/rqsflnK3uI9g4R08+OLlJQRZ+M72yJRsXLPm+i+MX+ITIMKN1HqCTP8PjTX3DjEBcPhmeorolIe92VONZckA8NaXZ6ESxb2vdAxEP5xXXolRgSwxUHAy4Q2MiIWcleYZV523gOeJ9bLvJPV9VmXw0/o++0ZreL9o1rAd2qKgc2jWaSlKa+/5SwJrKCU2ZfcmV0mE9ZFnIWh1Hr0c0FUGqMoSq4IujMn9PQo2qzKtmOAlXXBSb0YMlZOJVif/Acrg+eCLyWL5M9BGigroamjysMhtKiDKVUtp0zd0XF8XG7c/0kixs1pROf5LZYDwf9qPuga6c4GPYnNlags5sVrcJiHSmx/N3jtneSLS5iWcHFXhR6hGAjFzdB79k5k6ho6FL1RBp7tr/S6oNDWifBUpTCMqfotzg56rzT7hpJ9gc5vhuCPlVuUo+dVfuXlRaYXsrVwIihkGElwx0i6N/OwU39btmYoFDP/9eh0ouE9q1SCGY9egWm90sFnnKUsZHaWBeol9IFk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 18 Aug 2025 17:13:40 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

Hello Andrew,

Thank you for your time & feedback, as always!

> On Mon, 18 Aug 2025 11:58:03 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
> 
> > While testing workloads with high sustained memory pressure on large machines
> > (1TB memory, 316 CPUs), we saw an unexpectedly high number of softlockups.
> > Further investigation showed that the lock in free_pcppages_bulk was being held
> > for a long time, even being held while 2k+ pages were being freed.
> > 
> > Instead of holding the lock for the entirety of the freeing, check to see if
> > the zone lock is contended every pcp->batch pages. If there is contention,
> > relinquish the lock so that other processors have a change to grab the lock
> > and perform critical work.
> > 
> > In our fleet,
> 
> who is "our"?

Sorry for the ambiguity -- I work for Meta, so I was referring to their
machines. I'll make this clearer in the next version.

> > @@ -1267,12 +1270,22 @@ static void free_pcppages_bulk(struct zone *zone, int count,
> >  
> >  			/* must delete to avoid corrupting pcp list */
> >  			list_del(&page->pcp_list);
> > +			batch -= nr_pages;
> >  			count -= nr_pages;
> >  			pcp->count -= nr_pages;
> >  
> >  			__free_one_page(page, pfn, zone, order, mt, FPI_NONE);
> >  			trace_mm_page_pcpu_drain(page, order, mt);
> > -		} while (count > 0 && !list_empty(list));
> > +		} while (batch > 0 && !list_empty(list));
> > +
> > +		/*
> > +		 * Prevent starving the lock for other users; every pcp->batch
> > +		 * pages freed, relinquish the zone lock if it is contended.
> > +		 */
> > +		if (count && spin_is_contended(&zone->lock)) {
> > +			spin_unlock_irqrestore(&zone->lock, flags);
> > +			spin_lock_irqsave(&zone->lock, flags);
> > +		}
> >  	}
> 
> Pretty this isn't.
> 
> Sigh, we do so much stuff here and in __free_one_page().
> 
> What sort of guarantee do we have that the contending task will be able
> to get in and grab the spinlock in that tiny time window?

Thank you for pointing this out -- I don't think there is any guarantee.
Kiryl suggested that I put a cond_resched() here, in order to guarantee that
the contending tasks will be able to grab the spinlock. I think that's a great
idea -- I'll make this change in v2.

Thank you for your feedback, have a great day!
Joshua

