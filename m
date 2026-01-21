Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 706A9C44526
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 13:16:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D076B6B0089; Wed, 21 Jan 2026 08:16:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB1DE6B008A; Wed, 21 Jan 2026 08:16:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB3E96B008C; Wed, 21 Jan 2026 08:16:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A822D6B0089
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 08:16:17 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 51C67C02B9
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 13:16:17 +0000 (UTC)
X-FDA: 84356019594.19.E274725
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5E643100003
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 13:16:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=buPSxwIV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769001375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P4+UV6wR1tAB/YyUs6TPuGVmRVeqrBL/GPaWOyEoV2M=;
	b=iB07Nzgl8OoZjwGGQh91wqv75RMOUGXlB84vqjREJaLWhZhx3IUoYZ2dPV17407VXG2Dxi
	987sFboI/l/fc63cn/oaN27cuNrqAf0f9ZMqdDsuQVtc9T78PY4+w5PrAt+p1xFiJUfHd/
	YmlMZrSBUgZV2fk1u58N1avVeM+edc0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769001375; a=rsa-sha256;
	cv=none;
	b=gil7JklopU7O1tBtcJ8d4xHcfLumgGkNNuRSaYDCLTCrkbvvZpDHtS5Pi/ULEqrCidsao5
	xbBaUBDl652lRz3hZeIonnvD4U429fbXPHvDnYxezDTKlWEF6kRN/D/AuGLA2dP58zg/E3
	bbRLb0/aC5sFEwxYMxFrXWkAAgYwdRA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=buPSxwIV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6505d141d02so11052901a12.3
        for <linux-mm@kvack.org>; Wed, 21 Jan 2026 05:16:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769001374; x=1769606174; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P4+UV6wR1tAB/YyUs6TPuGVmRVeqrBL/GPaWOyEoV2M=;
        b=buPSxwIVRIn6r0Cf3JGcEpfuK5rlvXYJ+ua4011Cj5zVXhpI20vQXETBacWSdk42Or
         0qEYG1ehDePZKaw02Z9loIy5GvG7iNroCcltxWFYjQ7Sh6EQQsVp3rRvWNSVAt/hdqYz
         9gMby64FGaitcGSKZlPz4Zmsw07eSYcJUtucuVZI39Ft+6gXj7K6McaOknIxdNawkJ7m
         oCYhQMhkFNMMu5uxiopLErlTVyGj0TexoD8EC+1TaAhjvQB7j62zFcsssPUyvj2Om8lj
         uGw225xlN7XmdnKh33uYCVP1aLj6DrwDjfmpAAm5ikWR8r+tJjHIznfazSPaJyfKpeHY
         vb3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769001374; x=1769606174;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P4+UV6wR1tAB/YyUs6TPuGVmRVeqrBL/GPaWOyEoV2M=;
        b=L2E8zw4/mU+j4q098fb2B0B85qOIjaLH2w2KN4GZl3yDIxwuj6zx2YBM/g/EGU4EIR
         jvOrie1al8JAiHltW/DXckhiA3jvWKhDPR1ZfkzsoJuPlVuD9Xvo1K0TwNCN2n9Q0BJF
         aONaxZNJofU8VJciYXvKAvxmFoyMVTTREzU1zpBytzYu5KTLOtMa6vqNKqffAFFGYEpO
         mRH8K0kBl2xyOi2eCwMYdGCOXTS0KYkvXubhuFwlfbyG/XJXqxV3xxW6r5oAaIorJjXG
         kYzIgqmKarnKsQFxRo/Cjky1KisxzC3AnLTRoTxxzfo/v4ZoCPq4yK+SLzPvyNBUi6o8
         2KKQ==
X-Forwarded-Encrypted: i=1; AJvYcCUKGCpaLM3ni53hGFlovEMBsnDMIZZ6aY8EOfqmAmZVU41t/g9AAtSlTkiLoZDudj68EO+DMjYo7A==@kvack.org
X-Gm-Message-State: AOJu0YyUjTM+wSNErvSQTQXr77XLSKQPO2XhFd+FZXo1mQ7zTeYplnX+
	Ga3y/EHpqoOYrlq52/WmuNHMXcErZ+vUVXpq04HHJk+Es0Htq9Al7XMAXp6vww==
X-Gm-Gg: AZuq6aIPvqfy2chpiTYMyNN0bNtHcyA1xRfRZcAuG1RiVk+vrCFXWO6RVfBNB1WiGz2
	72m0lbb7oxnmn/uZPV6PM0BLM6ew2wQXuZGmIXiUsHW9gvYmiNWwHz/rzor3M79AQj7KrhvfsqI
	TYOnc84mF5ak1QgQroY5iVTkyb424DcFqTW60ssZs/Bwqp2jErEQsBf2GdGyIMe4z2E8G2nA4j4
	RhBNSJfhfewqcF/YtYWP/LeniILPbGzyfteqYQzVWVEeHweUtPwwXFCUb1rgu9vl6QsHivmzJlE
	6MIpw6zBwyQBW+j+QIEcf5954FcMDWGTFvNE8KZE67btR5O5f/KiyewbzGCyzcNUpFbuEFjk+1W
	+0lc/2WrtBy5ACIwRFc7Kb5/5/NXSwU411CVBQc/aNcPSsUCNRfrfqSC7BLR6cmYQ38iog886Aw
	v6wz3g1e3JXF8SfsUHsccwxk+digxZi53o7CTWi+5LhDZhJXYH808g
X-Received: by 2002:a05:6000:1acd:b0:431:8f8:7f1e with SMTP id ffacd0b85a97d-435901751cdmr7939323f8f.48.1768995134371;
        Wed, 21 Jan 2026 03:32:14 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4356996dad0sm35896316f8f.27.2026.01.21.03.32.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 03:32:14 -0800 (PST)
Date: Wed, 21 Jan 2026 11:32:12 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: zenghongling <zenghongling@kylinos.cn>, muchun.song@linux.dev,
 osalvador@suse.de, david@kernel.org, akpm@linux-foundation.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, zhongling0719@126.com
Subject: Re: [PATCH] mm/hugetlb_vmemmap: Use max() macro to simplify the
 code
Message-ID: <20260121113212.3d685ad2@pumpkin>
In-Reply-To: <aXBvY_MjV2GZ0WPN@casper.infradead.org>
References: <20260121015114.560424-1-zenghongling@kylinos.cn>
	<aXBvY_MjV2GZ0WPN@casper.infradead.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: st118tk45xatinzq33c8nosmtsagwsay
X-Rspamd-Queue-Id: 5E643100003
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769001375-13357
X-HE-Meta: U2FsdGVkX1/me6IsHHax26COC0jHRJ7CplI2sOLKN8AUJm5zAP3mkRj3x1V5eSEWck9AFMd+zsFaYCQUcgPcJJJ1yb4rKjVYk1Q92YdWEEJNlhgrx3uJ/E1Fck3iI/uQC/sXw5RnyeC+CDW6k+GcKxdMTestHCvJeOn8PFW/Sd4Kg8MmLFKx1pZm/lkZu0l/wv3Dj45YEP4xdGiS4lmy9M8zCjjzCpyTj4DFQnaw2RokP8yfpP1L12H4/uShYkU8yGOTea7faa8ITAAeQXmUMkWmoy3MoKK1sePS5mtTI4CfS5NZ+Xv4eaJGWicLJxvuHPoi5wgKRgcL52Ti/W2dNgoiMWxb7okD0snksZF/JbaPJCroz+8hLioQFBuV5JfrvIOoeqU1+Kfr3caPEKFEeSmfq4w309/dS/pDrQnBEBwyUxvLRjYQcdfuGt0zvPL2EYnVJHEUz6NhIkB09sYUA90PBdutLFuKY/U9+OtRAU0mKjGkU01zBcCnmggB/ZNQ+ED281R/0Cxig5hqN41ZlKV60OLn+i/ysSVccNbMJ9QnV7FrBUNApIXAQ7ZVgIjA/yCgcAKRxcQtKDGWg4HtWmzTBweZT/oxBe3cZMZayBRrTZwbGHv1XRl+BVM8xC7FSiC4DdiYsfU6DbLp+J4vsoOvRFT+h0imSg1JY6grKBVdk4ghDC4KIn0O03hYZxsjwtYtjAQMM7MPF9VnsPeaZfMT/77m/ZsOIrc9g5SrMGrl+47jMouVTzQ59BTQTK0uQMCfnjpnQoDrHUu960VwaDS1E4tWvfcOdWYllpzvJEruhsvMi3q22nhVjo8Cd40rHo8rbn4ftz0XmPLz4BKjDUqs8RjoXh9DFMzuKtfi6EuTQDj8K0snxMXo89pRVTe9cq3JU/9aPQfbvo5HPiqsmdWknZfaNvIFvZ9ObyUgIiIczq2q0uXkRUqKRvTWocrqT3cADYHqCxNqnd7uSsk
 Ysi+h705
 qdmk72ixnEYhDR8kJXTqjiNjKCMh3PAkiOP+X5rGwq9hLBFw/OdWy4x1JaQWMMHYr5B9st2z6WY/GnVE3F3LSe6q/ZngZnBXl7O/ni/mKpmvuHI8uEZJH4PRHG05BP9jj/T2PUo4kdJNp7pzK75Mnyy3ONRpGsRUvoFnmfKHSqan2I/YENgCRV/3qlpAnMlynwORfB8e2Xc31uFAauxVqm0TyV8Nf32OUws47SNK4OBPd9Fy/jFE3/oP/+fSdsrdaW9hw7wsYY8A7HIbiw6Nj7oWfeGRcNjvSsvWD4PK5+cbdDslHiQ0gyuDBskW++yUUEHtdspowdg6xgbtIx3ctVBYIcrd3PXW6ZgCE31gEa3yQZL+UPTM2KohEJH6doXgtDtrXEEcEFUUGo67kZNeTUOd4Du0+ArKNAtI6dUiNCBCD7pJLpyC/w3DObdHOagL7vQYn3DAaFT/g4aK+7bQ9hsi5oe/vf9Dx5PVU6WYjrW60Av7X/ycZ7OGAPmj89my89FEkTR94KGYPtYbdRHcws9aQvPx3GBIq00TZPYC+7b3EfVYDmFaibu/vRSB6jsd99SfAeKqYXpGO3ecnBYwgCJ+qSQmmMP4ktLNnsVfJsLPZ2JPx9//NiR/QWA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 21 Jan 2026 06:17:07 +0000
Matthew Wilcox <willy@infradead.org> wrote:

> On Wed, Jan 21, 2026 at 09:51:14AM +0800, zenghongling wrote:
> > Use the max() macro to simplify the function and improve
> > its readability.  
> 
> How does this improve readability?  I understand what this does in
> the ternary form.  I have to think far harder about it in the max()
> form.

I must do a patch for checkpatch.pl to stop it suggesting min/max
for trivial cases.
Oh - and stop it ever suggesting the _t variants.
IMHO it is better to have an explicit cast on one of the parameters.

	David

> 
> >  	if (!is_power_of_2(sizeof(struct page)))
> >  		return 0;
> > -	return size > 0 ? size : 0;
> > +	return max(size, 0);
> >  }  
> 


