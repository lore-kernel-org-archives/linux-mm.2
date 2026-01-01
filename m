Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B1DBEEB573
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 02:05:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB6556B0005; Wed, 31 Dec 2025 21:05:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C63E56B0089; Wed, 31 Dec 2025 21:05:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B459C6B008A; Wed, 31 Dec 2025 21:05:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A24F86B0005
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 21:05:00 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CA016141073
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 02:04:59 +0000 (UTC)
X-FDA: 84281751918.13.A3B4151
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf03.hostedemail.com (Postfix) with ESMTP id BEFE920005
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 02:04:57 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jxJd5tJX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767233097; a=rsa-sha256;
	cv=none;
	b=DbGDSrmfZ2mpy1q4OEVId9Ybc1xeQ/WKa0ao83GGw3T7LvLEXkjAkTJZTa4S6ZZX7T9b65
	wssWkxSu5tsjX6caapkryIEqT64mL6crfGKC6KlTkWfnVCcyEvS1yVrit/sRCNXFKe/fT7
	HF5ZPLd89jwT0L2wV8YAFPz4l8pKZVQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jxJd5tJX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767233097;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t4h33WmPmh9knOAQ2OtmSS5LD6H+sen3dTiFufGLTIE=;
	b=N1W7jyVhXC+T2bqPa/0ZdOrEnli9UCgvGTrQWPsQLP9kLZVFpgiDVqpKRd0y5APWxyAxSQ
	j8yYWpKmhNzad9HU2pIKWAtVX63GYSe7Ymt030qSpObwKZ9hjiNf8ZXMmFYlrEKNnVz/ds
	KFbHOoFqYc/xe4fLT+xRe2bM9SP6wt8=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b72b495aa81so1852453466b.2
        for <linux-mm@kvack.org>; Wed, 31 Dec 2025 18:04:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767233096; x=1767837896; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t4h33WmPmh9knOAQ2OtmSS5LD6H+sen3dTiFufGLTIE=;
        b=jxJd5tJXOFkaVPa/dTROKMyVf6j72oecgtxD8xvY3ceGIQfZKOxZcAVnisoDIdF5aP
         rTe8cMrCsOVLrA2juqaNs0fd8KhUGWiS/NQrTpcbvxD0cfOmoCx6qtHGJFj9/ItsuHxx
         tMiLD2fcFQbkJMrFFqFkr4/Dh1Jj/+ECnZc2jCclAa1nNe+PbYvG/TCN3yLPrce5k1Yg
         OHUCseIB/4QwA/kEL00Tm0WWlCC/VAzgB2Ref9cLdLi3xQHD+aPUWtre8+jZRG27HOaA
         UV+CgWUkxiIfn3Assb9uPDOR09zrB6RnXn8x53B8joam0bI49MOeMAUu+9YtxVllakSy
         sR7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767233096; x=1767837896;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t4h33WmPmh9knOAQ2OtmSS5LD6H+sen3dTiFufGLTIE=;
        b=ky2Dwq+L74mmB5hn22R9ON31cRNWri/sLVsZ4Srx1TWtbUJZXD8jbAe+/KADY12Jdg
         Z/rhVWE47NWviISmX7WxpmDwS4oWEazPt8DotPsylVHOnAgA1KVm8ji08MOAEkMRC5Gp
         HR5huDevvfW82Ik/g5g9RJqWbnoqJqqY2lhqoxuvRP2M3l5+dN2TmaS4Mm6vMZxjYTHL
         8FVdO9l7fStMgsx+VcYIvvzVSLcWprjIx+DD8MtaIqyB+C0L0pnFdeDv4BRjCUYdbdPP
         kUI8IhGCzQ8iTZt/L865e6uyox+JVwtqUJD79groWJTuXGRN4GzlXL5GxTbICtS8Vx+g
         OKow==
X-Forwarded-Encrypted: i=1; AJvYcCUwgsAdTbwHphgbpAmoKZNVt74xvtiMgLX1O4bHBoKIWXcTo+OYqbOkM17FfAeR3DQZqYVhRbL+BA==@kvack.org
X-Gm-Message-State: AOJu0Yx2ueyNHuu4ijmsZvWkaNb0YmS2jfeucSGIwtV/aIxodDVnz7e9
	OxJp1m1yO7GbZdpxU6vBxPtrwiu0+hGC/5XOJuZrpxhRATgrJ8wBOOhp
X-Gm-Gg: AY/fxX4ku0iDcyoZL1LV+J9jUu1deTEnozSN9UVvwj+Vf+fKehamKvpaYglRuTbbCP2
	prXTnVwfU8iyPq9AGdyvbDYMtZxZrjQHTW0+ZLMCHyX4301vQpaMdztV9fKZxF1+BmvQTBhQruA
	LOj4PuA1rXhl0HX7uvnnILlVV8leMj6lP5LAXp2YIVwBZ3jASWrkPFWKfeWuqIBa5Sdeqp7TrfQ
	GhubrzI7O/RZqOItaFmd1JEygm2wROSclurw0+qLfvcRzgXUN6P8gm33sXxxf5e8KoXULz7TnQa
	WaCZXoO3DP2SJcFN1d9M6pYbZZ1nTwSqhOr1utQIzuwO99iRziHBSGwnSPI4CT6LOlpdTxLA5gP
	SQEVNee+UvHB49OSfpY658BGevCS78uzCGNBlkHQ58pWY+jcFJ5aYsrhMCyyFc8/rh85JVHMzK5
	OAn5hzyaWFZg==
X-Google-Smtp-Source: AGHT+IFCnRN5BM6kVAHLy0RVPYJFMCs5SToyOj8yBYpIC2I9xHPhI6HdJIINOAMKk7wNRoMxzNkAfw==
X-Received: by 2002:a17:907:960c:b0:b80:b7f:aa32 with SMTP id a640c23a62f3a-b80371da8f5mr4059310866b.41.1767233095827;
        Wed, 31 Dec 2025 18:04:55 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b83926533b7sm738659766b.20.2025.12.31.18.04.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 31 Dec 2025 18:04:55 -0800 (PST)
Date: Thu, 1 Jan 2026 02:04:54 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, Vernon Yang <vernon2gm@gmail.com>,
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
	ziy@nvidia.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH v2 4/4] mm: khugepaged: set to next mm direct when mm has
 MMF_DISABLE_THP_COMPLETELY
Message-ID: <20260101020454.unwjna3cdmcgpldp@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251229055151.54887-1-yanglincheng@kylinos.cn>
 <20251229055151.54887-5-yanglincheng@kylinos.cn>
 <f47b6192-2115-4f4b-82ae-dd66e65f4340@kernel.org>
 <20251231025112.uzlgrs3dgbyzul2x@master>
 <9c3b81da-f0e8-4652-8900-05593e124c26@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c3b81da-f0e8-4652-8900-05593e124c26@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: BEFE920005
X-Stat-Signature: eqf9ured4tn7jaysytp8s3oayripzshx
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767233097-462029
X-HE-Meta: U2FsdGVkX19C0PaUuOzjmMZqrk+Kju5x9aiZM508LXefV8WuxFue6Cg+g9iwt04a4FlxsyfQcCr6RfXFSnxxex8sA2TkoPOcT0K1egi1YUsqdMZkiZxW7dW/rjWRnroTdBsgz4S2arQQrsjMvzWvxC+UfZ8f0M2EOrqQKSA8iTx0VXai7XOFHKD4vr+rNuAxHUIghH5rx4Uc51cSxSYKOrk5GbsC/pWKnbdEPHRJqRSs+Z+EewZXzBLXHDAb2jY2V1wo9V3HOvbc3pGWZV4m8rrpcrrhNJPDPSTeG1p8ZJRHr1Sv0NiSd/RveSCHjds0moCPRb7qQSBgllmYpAf1TivgSWOp70iM8JpdNd1XKTcBdmCraejLw7PKvGF4iv/7rcHbUFDimT2C92Daw9WQJWB4+wMHjYtft+OppvQkXMPe/pj3jb50Pl1JrqP3G4+MGyJck0gjI8YVAq6Asb03jVrpRX8WgZ3ZAkn/CTuyEvmBe6Gh/AgRqGdBiVnXYna0Za/i54gAyG1pjCnM/XxDEROnQe7Bl9FXqeSXBpo9dNKZXVq/QTYoQoVqN5fh1/fWq59No9yL5f4mg1FVNdlesWaLOr9uhQlfyAwMsNV3Bz+nvcMaxsUW+xXCzAVoahcg3/2DQkNADlXcFJFB8AISjOwjaDHoxiIOtezNyzM6ULXr8oOrNNZjMYF/eHJRF3OAXvAY9YbZLS+qRd9r91jUJImowM+SlM+yC/RHpneXodyPDLzRe1W5pIplRe2DN1vWY1E0bhufz6Ex1d93gk/i6M93T2JoBmshY6sjckz4kaSmohLaE7pSxIx9QIkkubKQZVC5QyIwDK0LdZpdRiFV3XYy6hOfVlGx3ktBFScRZQQ6OtcwR2i7kiRUWjb0z45WXuENdtvwlHduZluy4x6PL43WCta8AwSnOOVEQgBY/Wcrcpc8NUnGek92ckx6l3nr4KzNdbHXian2ap+fv/z
 3olR2AT9
 TcvBqpb2ShDfN68jcQdlkYfW+1wKu5Ez6YmeiGLcKSva87wqNnIsjGgV+nYf6ZPNbqV3CVVBu/OKHb0QsNCWNCCtpBFCZoTN76ZrGlVeo5HwhPbOwDVFPCC8GhDTcP1ojAaXum5Nw8cI6u7Z67WAMtwNwmy/uw8eH+ejgFJ8Sh8uHuUlWLwyTmKZeEai3B2eUzftNGHbt+jzletMpONqHBpo8+lr5VvZKiHkGxlyw94MMPHN/VQbFgXh+DPL9XGIYYz9WEyripNJxakv5fZZcx6d356SzNtlZjJowd16pxcrnACk13RkVhaShpkrq2h+qkBbFIhhaJI5FSYAGdha9gKkIeh8K2G3QvdKWimM6zUjAMYZCm3ZbuN7Dtre4uRtBQeuEScVbLPhtoI33RvYsT1HmFPXFb/NkUZdTmTkOzwEUSTCT//Rcw7jcKJaqoNSZflmv1lVGQkJmNOnwDN06Nveew0Ky57mbEBX8L8my91lmMte59T2nXHsz01PaG2via//6VkaOXnwD9E4JvP9byeXX63t7dw1Bml27PDjxIx0tbuzZjEh88bKoYata485LBQoXGcHPH5k0koR1SFUlm3hXCv8J+TCjGm3j9TvByrUJiCq84cwiEjm8yK0l+FmYWA+tDu7zabekPRs2Ryr094Z6gFUoC8ELos2rEmTvn9FJZvSWcXrmGmKivIl3chaEO3JOx/w3ONQyvKUQrlP71gomk6I3R4NnGcCUb3AZHRdnhbOc+Q0RIw1w1A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 31, 2025 at 01:21:12PM +0100, David Hildenbrand (Red Hat) wrote:
>On 12/31/25 03:51, Wei Yang wrote:
>> On Tue, Dec 30, 2025 at 09:03:23PM +0100, David Hildenbrand (Red Hat) wrote:
>> > On 12/29/25 06:51, Vernon Yang wrote:
>> > > When an mm with the MMF_DISABLE_THP_COMPLETELY flag is detected during
>> > > scanning, directly set khugepaged_scan.mm_slot to the next mm_slot,
>> > > reduce redundant operation.
>> > > 
>> > > Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
>> > > ---
>> > >    mm/khugepaged.c | 9 +++++++--
>> > >    1 file changed, 7 insertions(+), 2 deletions(-)
>> > > 
>> > > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> > > index 2b3685b195f5..72be87ef384b 100644
>> > > --- a/mm/khugepaged.c
>> > > +++ b/mm/khugepaged.c
>> > > @@ -2439,6 +2439,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>> > >    		cond_resched();
>> > >    		if (unlikely(hpage_collapse_test_exit_or_disable(mm))) {
>> > > +			vma = NULL;
>> > >    			progress++;
>> > >    			break;
>> > >    		}
>> > 
>> > I don't understand why we need changes at all.
>> > 
>> > The code is
>> > 
>> > 	mm = slot->mm;
>> > 	/*
>> > 	 * Don't wait for semaphore (to avoid long wait times).  Just move to
>> > 	 * the next mm on the list.
>> > 	 */
>> > 	vma = NULL;
>> > 	if (unlikely(!mmap_read_trylock(mm)))
>> > 		goto breakouterloop_mmap_lock;
>> > 
>> > 	progress++;
>> > 	if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
>> > 		goto breakouterloop;
>> > 
>> > 	...
>> > 
>> > So we'll go straight to breakouterloop with vma=NULL.
>> > 
>> > Do you want to optimize for skipping the MM if the flag gets toggled
>> > while we are scanning that MM?
>> > 
>> > Is that really something we should be worrying about?
>> > 
>> > Also, why can't we simply do a
>> > 
>> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> > index 97d1b2824386f..af8481d4b0f4e 100644
>> > --- a/mm/khugepaged.c
>> > +++ b/mm/khugepaged.c
>> > @@ -2516,7 +2516,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>> >          * Release the current mm_slot if this mm is about to die, or
>> >          * if we scanned all vmas of this mm.
>> >          */
>> > -       if (hpage_collapse_test_exit(mm) || !vma) {
>> > +       if (hpage_collapse_test_exit_or_disable(mm) || !vma) {
>> >                 /*
>> >                  * Make sure that if mm_users is reaching zero while
>> >                  * khugepaged runs here, khugepaged_exit will find
>> > 
>> 
>> This one looks better.
>> 
>> But the sad thing is we can't remove this mm from scan list, since user may
>> toggle this flag later.
>
>In theory we could readd it to the list once the flag gets toggled.
>

Currently we use khugepaged_enter_vma() to add one mm to scan list based on
vma property, while toggling the flag MMF_DISABLE_THP_COMPLETELY is based on
mm. If we want to readd it in prctl_set_thp_disable(), we need to change the
semantic of khugepaged_enter_vma() or introduce another interface?

>In fact, we could remove it from the list once we set the flag. But not sure
>if that ends up any cleaner (dealing with races? not sure).
>

Removal is clear to me, but my concern is how we add it back. Looks a little
unclear to me as described above.

Another thing is how much "thp disabled" processes would we have in system?
If not that much, check the flag and skip it in the scan looks enough.

BTW, if we can skip all thp mapped process during scan looks more benefit?

>-- 
>Cheers
>
>David

-- 
Wei Yang
Help you, Help me

