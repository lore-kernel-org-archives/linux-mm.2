Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96891C87FDA
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 13:12:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3437B6B0089; Fri,  8 Aug 2025 09:12:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F46D6B0096; Fri,  8 Aug 2025 09:12:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E3396B009D; Fri,  8 Aug 2025 09:12:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0C1926B0089
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 09:12:53 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8508DC021B
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 13:12:52 +0000 (UTC)
X-FDA: 83753630184.14.CA5A0A2
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	by imf02.hostedemail.com (Postfix) with ESMTP id 940CA80009
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 13:12:50 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AxAW2KtM;
	spf=pass (imf02.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.182 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754658770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ttVrBE0Ue08luLt7PutqjyPNAQbrHDVeznsyVuSrlxg=;
	b=Otpigk/iyC7ZOHfkg8gju9QQ5ry5XddzmVrfbi2+CkXLb+49VfGbM4Fm14h8HjGVL5hcyP
	s4j5xkUu3vqkKaICYyjWu7THpyg4xdVz2wh6OC4gWnb0OTsZD80OcFTFxlTXWYePV4uXby
	b2uwGzegDkuPWv1JLANkHaJ8fv9YJpY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754658770; a=rsa-sha256;
	cv=none;
	b=DZna2BqzHimHlDeirHRQXoQodV5J16aUH4OO0o/mkl/17TnWgoeCjHyx3GvbFeRXJUqwIh
	SIRsSkqwS7p90EnV/+QaWI1dVQaYSArzn0StDiTkqgMo89SGoDLeZODVxTrG+YHXBqKE5s
	0bkNDDOCLqzirqtSblN/8yehTds3ug0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AxAW2KtM;
	spf=pass (imf02.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.182 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-33245e653bbso15103961fa.1
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 06:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754658769; x=1755263569; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ttVrBE0Ue08luLt7PutqjyPNAQbrHDVeznsyVuSrlxg=;
        b=AxAW2KtMjp4HuAZeLoDRnaV9y53MQZxKHf/mOtaaa4D6R+4mLiVvb5lyig/rJkglm9
         qH6whpy6yfkDIvzXK3MBs2YkEvIZOa11iGft7baPH6SKqPIlGpSiU+RKDCp48slv/QNo
         Ox8t6xnXzw1Y3BGAm+ZxKlwTJkj8uwIZ5aVMdeYcrL8/EseF+yycTLkSjyOmpPjAe8sl
         d10AjVVB9AXdyVVCojhS8Fc2FWs8z7kepPXXojU61XL5GU+jCcCyfbhN+8K8TOC8axVp
         Rc7wWOgRg6wQgOAH2V5t3vB/4RQYTa5ZakW+pHTdJlrC3c8tZbTwKM1qHhFO5R9xehjG
         nwKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754658769; x=1755263569;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ttVrBE0Ue08luLt7PutqjyPNAQbrHDVeznsyVuSrlxg=;
        b=TJp3vJjZ3Mi7JsMEzTrux0Br/qh3AgNFt7Dp70MUh6KQKXmNg5GKcYFsoAq4hX0aa+
         BpO2jEvIZSheDoXkG9/gm+bBHey4o9jrP0cV50/KlK0imZtQ42Dk8RXteKDilNGbMSj9
         wjoU/9Sjlaw46HSBRvH+xSjTg4r71ni0cM3sEPTV0Z6E19rQ0Tw2fXgtbz/I7ESGInBx
         Ih7x68Um4Eie3WhP4O67WZENPGXZnio2ATro4mreN/P59Bp7jtveM/RHhHeJbntSOfu6
         whBN21NHiVoH2E6KXHNuDvqAjhv9AvV3csr6I86aWpRFUtN2LFbZyUhRtTz1GT8YK/yb
         oz+A==
X-Forwarded-Encrypted: i=1; AJvYcCWe1DpBNzOjXYQWqA7pP3rLp7DtH34gExglywJK2wZ6DvLoSnkAmvoOrrM7j6XDUZAh88YCmfvcrg==@kvack.org
X-Gm-Message-State: AOJu0YzjOrQESCa3JdXg8pAOohBF/Rktnxxr1HcGN44r9OHoV20IpOo+
	LpJD4kqFhqradEtP5KNs9ffqI9jvnlifToUF/aGcejJWseBQDc4CFJww
X-Gm-Gg: ASbGncvkeDCtaM3GZuMcrD1q7i4pK3oB5srfTh+YRkJDpvq6EIlZvgf/iI0IAR7CmvV
	nilMlQ5VeHkYj9w+rJj0WHE6S8TzJC3BRkCbDwQcDSc4746L1if61kx1pSqvl5b6Ps8bCuqgKnR
	BJdbgaPfwwdVZs8QhoKrOYUTSEw9L+1q1g7z5if7V6SPFfTM+XgoOJb6nc+J5UgffOMtNSSBHmU
	j0asINDAFR1a0vVO/g9GkCzDAHnZGn+SDo4wzYLf5hK33covRaIu9L4j2MKISfdwFvFuLWymj0j
	FX1O6oZm1RDj1XfH0Sq9SwvMVegcrXyuLSNKDH77HjaOMo/nosqTTvOikPlCRdVuW/mePmiFz+e
	Odtu8/YjNChrv85ieFe5EL2AKfflfjxyhyIHpsbV1DdrBZPUDVQ==
X-Google-Smtp-Source: AGHT+IFo5CmOaefgqERYR5w2etAP0DixW0V4maBkIDaveu9VDAFqJz7lV8siIMn1mI1paEnDDReD4w==
X-Received: by 2002:a05:651c:410f:b0:32a:6b16:3a27 with SMTP id 38308e7fff4ca-333a225c879mr4486721fa.35.1754658768325;
        Fri, 08 Aug 2025 06:12:48 -0700 (PDT)
Received: from pc636 (host-90-233-217-11.mobileonline.telia.com. [90.233.217.11])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-33238272944sm28012901fa.13.2025.08.08.06.12.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 06:12:47 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Fri, 8 Aug 2025 15:12:45 +0200
To: Michal Hocko <mhocko@suse.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/8] mm: Drop __GFP_DIRECT_RECLAIM flag if PF_MEMALLOC is
 set
Message-ID: <aJX3zbr8QsIs1LOw@pc636>
References: <20250807075810.358714-1-urezki@gmail.com>
 <20250807075810.358714-9-urezki@gmail.com>
 <aJSU3O-pUnTnl_wP@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJSU3O-pUnTnl_wP@tiehlicka>
X-Rspamd-Queue-Id: 940CA80009
X-Stat-Signature: 4wt8uccyzw796fqdh46b6q5nh35ommbu
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754658770-649469
X-HE-Meta: U2FsdGVkX1//CM3OqOTPDoJ1LT527L9zNwm/Li+xh2UZAhK7sLVFRa5gSXn/xKSe7/bnJYa9Qhjo6tJh+A+2W4kO33//osTNOBLgW8OG0/f6OipEcvG+dzA3sB6kwjYkWHohd66J6PwF0jCHEcjAtud4X3tT43IIsUhl4vS44zh8kOe8SsaYmIU5iuaOLxWtevdOK2sgEf0uU3lzSQhNiy7Q/7P5gGqWR4h6X0g1PL4o6iil7+dPD0V6LcRb4Gz5soyRVhVSFVqjnRdDT1HAM6HI70IswLrvVIRnDCzZKKj1V8w+qZpSMfgbOcXPIoOkT3poFjm/en4H4Ye6Oq6sAgm9xhjeY3KKmQRZydLzDc2K2m7xlrF18FfVx/USPgpDEWY7GMLHP3T2g81yMZnjAgVmVGVAP2t52j4WZInrkBCjIOqGxBfNtgxkoo7f1+FtoDB1JVenFzNKwxbe45+zOpjUo+v9P6dIwswuflPXWfncGTgYWuhumJI0aUBj1xftHNleST8w89wiSi97lJXNhHe04fHQ50DDRdrDEW/9FnCgGbSOukcsaTV6TTcxNGedxZCt3R8EBFwB7/S1Y+jofLZXTG0U45dv41/iomMdq1SG008pNcBNck3ULeuxmrsT6VDnV9eWH6J1QFUypB1+8lClBOVdRfAtKLby+D3YitMrdWjxpO76b3oqeGc8qu8v+avTlPOVM9bNW9fsHbBzTipOSXM1ZwIWmCKe1OuWMXnQLdiHACMbrDlsRCDbVpuFA809sDAZNKzwC5Dl+QkK86BPK/MSRTgW1T/nl2s2NQqV9QQTAOumA2G1T9wFdbSoeQ3X1rpULDajX5g4/G2aYR/WkscOb6caH/qT/FLj8Amf1KOzQ/HZQesz6WM1O/6yQGyI4CaQiEFXhQnPFPlyXK+AC6DnSfKkMgJA+BYJs9t37YAwBKV/DzWM4kx6RRPCy++bP54ixLpYpR2FjHf
 cRKYTSTe
 z5JOO9WFe82lMhU3DSK/EyI4ZOFbiFlA5dxg6Whldpi6p539+0ml67Nt5CvJ7i5oD9AZZ9WkLQ0//7DwI+KWOz8jrVbWXXe+RSLAKGYf2Gnwgtv1UlMg9kuHh+me3zWw5xRZI1porCRxZSCNw5IN+rIvgzCXke+LsZtElRQM7iDbKEqw+HUSqSSL+kFQ9TNO1k+19i6uUGYvemy3RSlCjFa0xxBooC2WSxvpVGoVHtJDkZN3xMWt2o7GkHt07NxLryBD0q6OJbOvthsqUxZ2Qip7oA7UnJ9qSKBCwUS/blCWTaVizvxVXYP61+IF1YLSibBzAMRahVJM4UgCO97Z9Pyrl7KkjuBEtEXHDJxRJ3DAWhvGHRLtewcq46APN7T8xsztaYwLUe2RmtFYOaqgmPyZNh/VBDeAwPzazOSW4ACN/CyPuTreCmv4ByKV5X9/mnYDEkfXZtpOLLC8W5YTESjCsI5r2IkTfGmwl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 07, 2025 at 01:58:20PM +0200, Michal Hocko wrote:
> On Thu 07-08-25 09:58:10, Uladzislau Rezki wrote:
> > The memory allocator already avoids reclaim when PF_MEMALLOC is set.
> > Clear __GFP_DIRECT_RECLAIM explicitly to suppress might_alloc() warnings
> > to make more correct behavior.
> 
> Rather than chaning the gfp mask would it make more sense to update
> might_alloc instead?
> 
Hm.. I was thinking about it but decided to drop the __GFP_DIRECT_RECLAIM
instead just to guarantee a no-reclaim behaviour, as it is written now to
the flag.

From the other hand after this patch we would have some unneeded/dead
checks(if i do not missing anything). For example:

[1]
    WARN_ON_ONCE(!can_direct_reclaim);
    /*
     * PF_MEMALLOC request from this context is rather bizarre
     * because we cannot reclaim anything and only can loop waiting
     * for somebody to do a work for us.
     */
    WARN_ON_ONCE(current->flags & PF_MEMALLOC);
[2]
    /* no reclaim without waiting on it */
    if (!(gfp_mask & __GFP_DIRECT_RECLAIM))
        return false;

    /* this guy won't enter reclaim */
    if (current->flags & PF_MEMALLOC)
        return false;

[3]
    /* Caller is not willing to reclaim, we can't balance anything */
    if (!can_direct_reclaim)
        goto nopage;

    /* Avoid recursion of direct reclaim */
    if (current->flags & PF_MEMALLOC)
        goto nopage;
etc.

But, yes, might_alloc() can be modified also.

--
Uladzislau Rezki

