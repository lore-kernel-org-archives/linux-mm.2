Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C48BDF3C991
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 15:33:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D8EE6B0088; Tue, 24 Feb 2026 10:33:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25C036B008A; Tue, 24 Feb 2026 10:33:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13E186B008C; Tue, 24 Feb 2026 10:33:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0007F6B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 10:33:54 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ABE2C1C135
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 15:33:54 +0000 (UTC)
X-FDA: 84479745588.18.415BBDD
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com [209.85.221.65])
	by imf25.hostedemail.com (Postfix) with ESMTP id 72D66A0011
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 15:33:52 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UyUwfeBK;
	spf=pass (imf25.hostedemail.com: domain of chris.bainbridge@gmail.com designates 209.85.221.65 as permitted sender) smtp.mailfrom=chris.bainbridge@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771947232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8ZrBVMewOqqxRF9QwFcMStTEodH15BpBeQtPveLuffg=;
	b=Oi6rIocdFRsMFI0eQI10SdVCCm5dySUKoDARNugLKLtEuD25wxVgBmAsPJIAtwmbPFKM8b
	tLm3yLS2DcaYiq2LvfS4pp7592VCK6qqXpRjV74mx+d0ls9mc01JM8yxxIO14qP5yt7uCo
	MXxPxIop1kI8PQg2e5HZHDewzoOEp+w=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UyUwfeBK;
	spf=pass (imf25.hostedemail.com: domain of chris.bainbridge@gmail.com designates 209.85.221.65 as permitted sender) smtp.mailfrom=chris.bainbridge@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771947232; a=rsa-sha256;
	cv=none;
	b=dZBOW2j+tMjDmIoSz0TLKONafM+rHe076URl2mK3NKbE26+JC26s8w91QLqoLI+KdBVuDh
	Q00httTtTgalq+4YC4Mj2EF6BenAXlA5hayf/uhp+wpPNbKfuFiWHLRpyp2xeZCBnoSmIt
	lkjFnqWj8vvVRxsGIJXa+k+PTB1q+BA=
Received: by mail-wr1-f65.google.com with SMTP id ffacd0b85a97d-435f177a8f7so5544707f8f.1
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 07:33:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771947231; x=1772552031; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8ZrBVMewOqqxRF9QwFcMStTEodH15BpBeQtPveLuffg=;
        b=UyUwfeBKcfSo9geObBHnrBgDrRIylSwMmE5541KPIl+TeTLG0OsQ0c/wWjBsZOpUMx
         Kwb57VrPgjNqT7MOllQcSwrWa7LJCB2NsYcI56xFIFRltPdF7S6taPEmvWM2ZRU8IXyF
         YdpgJderKAidsJ3F1m/vhG0EMfqbxVKviQPrDkx1AGd7Ik5Uk++kDXFt7lO5TpE1w1tW
         vZrqfsxDvI5NNx1m4xB0x3po5x7aaS89p7+k7b+jn1JWydRfMi99e5UqT5mMRpCV9QNg
         /KfDg2CfUKsBl6OsIAhPsRweAxpl/3i0It5sRzTSI9AMcDwyzuKd+yG0KFfXtmzY5fl0
         6sfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771947231; x=1772552031;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8ZrBVMewOqqxRF9QwFcMStTEodH15BpBeQtPveLuffg=;
        b=gUrIseU5FsUY/aOmDu1fbUVRhJqnqC9mPtDwIQs+LHGIox6KeYaOceOJpRCe/b8a2L
         5YfLI29/p7x1MFdPyLgH+80OJS83E16whlw8uMcmSeGQ95AbBzkbFT86wXJ5C7nR/JZR
         3Je1z11TobXwrHonCJEjQumNPYtRrFMrQVro4fweNMxi9gqRv9JLKsFDM7v5KkdrlW9a
         wZl44d3OTyx0ES6pBxI4+bDS1IsOlZkCo7DlTwPiXEjVir2I6xeBCS23SAOO/XI1wrnU
         8/jiYZbTRh0WIzBuKNFNfvr89OGLbcRpxAVwzeQESzYU36EPSMf27MIiMI/VmbqDgUBb
         o1Gg==
X-Forwarded-Encrypted: i=1; AJvYcCXWnkTG34j4Mn+t6xCYG7nnDanvmeE5UGe0F+HVIATqSuNVGJ6GV2vY2JCYxK6yfpxTnzwsnEhuBQ==@kvack.org
X-Gm-Message-State: AOJu0YyXTR4tKEBIIq/TlEhYn1mzotY/OjxIWmb2Hy17+rsfwQ59wDNX
	d5+s7vJHcDoQRoqdQnCa7jqmwlR1KoUu2A4M2IdGtPxDiunkHS1tACVk
X-Gm-Gg: ATEYQzxKE1eklfNCvKe6g+vlbromIYx9DgF1oXdQVfsbH4cS0Y56wYjcvd89oxKIFo9
	lCRNJ96Jg06iKidcc6WKwRlKZ9QqJ+O+mUGkCCM3nxtnA684PQcBNMV+28J72ZrcdGkc1B+Pr+m
	yMxB/uLa5CqnSRnBaWt+j1/UlZQOCQ+a4wbNlCIaG8+Lda9gOfkmjBgT/ihSRh7zeY/y2ANXMeR
	koUMV7mLhO88tjUPSyXykt3XGyPoKjVmpBuypD0oBa4/GCb2nO+78yuthTJu8uNsYs7QMxrtaLA
	o5vsWKbKNLrYHOLUjueNJBzJviOEt8w/5yS341k0LJe/uiO8U6nRNRFMdpKnN7hNJjnEj08Q+rC
	gYFQiSDwfAj5ko/rKkJERxv6bcXqDw5H8L874kaKA/0H9lDz1JQOdnlsRcWKGlzyRsG9H5riLAI
	IiEtPD0/MzIPBVPtLCKPNvTBO5R3hm3ag=
X-Received: by 2002:a05:6000:250a:b0:435:930a:658e with SMTP id ffacd0b85a97d-4396f185229mr25020104f8f.53.1771947230585;
        Tue, 24 Feb 2026 07:33:50 -0800 (PST)
Received: from debian.local ([90.243.35.46])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43970d3ff1csm26813442f8f.20.2026.02.24.07.33.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 07:33:50 -0800 (PST)
Date: Tue, 24 Feb 2026 15:33:48 +0000
From: Chris Bainbridge <chris.bainbridge@gmail.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry.yoo@oracle.com>, Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hao Li <hao.li@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH] mm/slab: pass __GFP_NOWARN to refill_sheaf() if fallback
 is available
Message-ID: <aZ3E3P2-Rmwt7YBT@debian.local>
References: <20260223133322.16705-1-harry.yoo@oracle.com>
 <e4f3b873-7825-46e3-831c-d0f5d3761ce4@kernel.org>
 <aZyur67rmiOT9zY7@debian.local>
 <5e767065-5536-4b95-8a42-c4be5d31c77f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e767065-5536-4b95-8a42-c4be5d31c77f@kernel.org>
X-Stat-Signature: dob8nf6us86ad35tosp3nbu444ah5goj
X-Rspam-User: 
X-Rspamd-Queue-Id: 72D66A0011
X-Rspamd-Server: rspam01
X-HE-Tag: 1771947232-157608
X-HE-Meta: U2FsdGVkX18GQJaYcSFjjika7cWQidq1thm42Nm6IG6a5xJCt4sPdIwLWmfDc9kbh1TxNqAwxNWoZGommCIrkgI+OV3hqXVBa9zOBqdzOJ8GaXz+erj8Hkc893Bh3vds/ONmJXCXoBiAD4yu5AGFxpsv6YURh9w0OnI31yN+15bKJcZtNGcMxWwj1WwmX7UQG8Otc9HgZeSUNIknOHy9zFCYDYB/Z8jeGMWnp1xiQPaipnszuTicW/K6Fr1IIcug29L6ZYk9CEF7rfol5fVzmnyM7W/JY8qSv18MUkXkUNtScbcUDkKik+IS9D9w+tLnAZ8ey9ZUVXpMFbWTDgcZY5GByQcp0I2yAKmRwGGSbaxB6SA0UtUGm5XqdiryTt5COBUo/+t/9VSS9YlT4zG2KhbBDxE11QEA1l0Hncm9iVn7jNbdznCng/ZgD21u2pEK8ef04bu8kAnygDnl6hIy74bn1ehXFyXmjRiloDw5TU1ZJaHKTUGoT0zM5VDsq2SPKKQF/INtNioZpgAI1eCAfnR6hhFIwh+jCuCqKT11EZaKvXIO/e1WME6iibRjgTdmQ4lWMS7KOOTg282K66s2URZrLp8AQZeRSDeeRyc8ehfwOKnUXk0mafzna49Th2WRXhe59FDI/3WqUb+awjFHZ/oDu7Ao2bnqwB2u5Z9BtHBPUsZUygPC6Y9akmc2UXxN+KQp+XQZp38qYu5nbXBBj2jDKojPYlL7hL3iqHxR99YrJdwphoIdEmRIF9di8S2hRYTvf7wQiSJaHtonOvAHkqCa1/foZiPWWiSBqAYjdEYGjso3lKQkfxPEpmrVd8r+1BVWVvO8G2HD/bKnnKPMAFPPiCwAjb1F1qyH57sYAB52qgA9neWv5WdVYCCJ3SzxEIL8YHB8ZkRlJATd1b/UVXeKUe7pP/uAEdBHGL4H6+bcSGmXbtCwhyVDK4xB7vqJ2WFF3ULbLLo0X9Q5ULV
 scSPg8XO
 GDlXuxu6sG9TTOaZATT6vys8gpHpgld70bq4ixiUrTCIF+p5m9VsZtM0js8pimSKls35sZmacZSot22ceb4NnJjD0ChSUy73GCMW1FxlLXrhHpFBQ8Q1Do8ZxaT9CV2YVDZPv0440LrQSo7dlGKq6UlrAfXVaMQKyeD8yQZZ635kLYwyUfj9V2pUTbmmjUhO/IqMRAA7ids56/os4ADd9qLd5dVdNupYTnQoSPGXilAnYV95frDJEU9tn8yRVRpyjP0/zg5uyyP9doNjxgExtGrUdchISHhTG1+c5mNokuOiHOiXMkY+9TOp9LCNCjb2XTRUcsHfIPYjZjLa0hnSjYjsJ0cA4XVEOpdjqChXW0tAGj4ITDsUS16Rce4NaG18S0UNOWTtYxO9ci7dO2FrjzZ+vqr5Vtqwg56T2LGUpjxgSsJ/mO4c1V3D01CQQtwVJZyr3rF3YtssFjbyN0H7J5cp3OjKk4L88+CCISZv7McZWgLkWc2SQrXalLHZpSgHskaojrC8qUlOfxRCwNIcoweNgX/PH0LGUY7UdjNepxaFql/EQOBTqQLjhqv3HvlrDr2NjBnwwTMIJnVO41GnHmN8UtA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 12:30:11PM +0100, Vlastimil Babka (SUSE) wrote:
> On 2/23/26 20:46, Chris Bainbridge wrote:
> > On Mon, Feb 23, 2026 at 05:48:25PM +0100, Vlastimil Babka (SUSE) wrote:
> >> On 2/23/26 14:33, Harry Yoo wrote:
> >> > When refill_sheaf() is called, failing to refill the sheaf doesn't
> >> > necessarily mean the allocation will fail because a fallback path
> >> > might be available and serve the allocation request.
> >> > 
> >> > Suppress spurious warnings by passing __GFP_NOWARN along with
> >> > __GFP_NOMEMALLOC whenever a fallback path is available.
> >> > 
> >> > When the caller is alloc_full_sheaf() or __pcs_replace_empty_main(),
> >> > the kernel always falls back to the slowpath (__slab_alloc_node()).
> >> > For __prefill_sheaf_pfmemalloc(), the fallback path is available
> >> > only when gfp_pfmemalloc_allowed() returns true.
> >> > 
> >> > Reported-by: Chris Bainbridge <chris.bainbridge@gmail.com>
> >> > Closes: https://lore.kernel.org/linux-mm/aZt2-oS9lkmwT7Ch@debian.local
> >> > Fixes: 1ce20c28eafd ("slab: handle pfmemalloc slabs properly with sheaves")
> >> > Link: https://lore.kernel.org/linux-mm/aZwSreGj9-HHdD-j@hyeyoo
> >> > Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> >> 
> >> Thanks, added to slab/for-next-fixes.
> >> Hopefully Chris can confirm it works (without adding the __NOWARN to btrfs code)
> > 
> > Yes, it works for my test case.
> 
> Great, can we add your Tested-by:  then?
> Thanks!

Sure.

Reported-and-tested-by: Chris Bainbridge <chris.bainbridge@gmail.com>

