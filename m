Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D959FCAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 15:12:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBC438E0019; Fri, 19 Sep 2025 11:12:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E940B8E0014; Fri, 19 Sep 2025 11:12:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D82748E0019; Fri, 19 Sep 2025 11:12:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C74848E0014
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 11:12:29 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7042A5A517
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 15:12:29 +0000 (UTC)
X-FDA: 83906341218.13.5AF5C37
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3F32EC000A
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 15:12:27 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZiBCU1sU;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758294747; a=rsa-sha256;
	cv=none;
	b=1JbR/8kdDnU6/P2ssDssAkmXK7H9ibj1NK+rs8vc1EUiYxi8NJ2SudEAzGf7s7eR1fqD1w
	TS15yU9gHlnF3DkcYnWsDaemScZA/II5DgF979HShyKQIQHA519/2Y/sC2u3PEpM1qou5A
	Ipmz9O9YPXeWsq7SmYPvjkV14ypZeYQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZiBCU1sU;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758294747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QmJz52HRci0hnUvV7fGD4Inffu0fj+CyCOx7NYmarUo=;
	b=YXG1C7rmvalr37KAQsoQuxCx2p8Mx+GEJu5vQnV0FqfSGBSGT407OAsSlh1dIWOlKlYB37
	XzxztR7DkymqZwmv4V57ks/FtsBljpumRNC9cLu2twRXjKnRdmTFBBCXAzdO6h3fBcR1uE
	QzwNrQRaxGNKZT9DjTsTpnbTYaB2x4k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758294746;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QmJz52HRci0hnUvV7fGD4Inffu0fj+CyCOx7NYmarUo=;
	b=ZiBCU1sUe+kohyUjiONhG8fVDJeLv3W5XFF3oLLukbfoQFJOU7dY5HaX57AoQDPO2zInAJ
	QUNKpnrDsVhzPl6G9SUDmZi3bI80eTyKH0Ei220eRgJ2PvIpS1QZayPAK2IcmSGXb7KZrl
	hkqYcK/3kqA8AZ7RfjcuM6XTbfVGGjc=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-178-eJ8mYQstNDGt1LGXX0ASKQ-1; Fri, 19 Sep 2025 11:12:23 -0400
X-MC-Unique: eJ8mYQstNDGt1LGXX0ASKQ-1
X-Mimecast-MFC-AGG-ID: eJ8mYQstNDGt1LGXX0ASKQ_1758294743
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-4bf1e8c996eso27582161cf.1
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 08:12:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758294743; x=1758899543;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QmJz52HRci0hnUvV7fGD4Inffu0fj+CyCOx7NYmarUo=;
        b=VVu5VCuEALC9sN2lJBmfU7AHlk4ynqfgjnkYxUJCFGkXVFdvCc4Py6iUsVjFD0p2TO
         joi5uM/whYuM08TC1rw1RyN+/xs3r1h/6jk8gYdLi/0Qp/bQF6dgJJmQtuK+NEYiC35P
         yDTNsiy8AkrUVjxR+njIq1QBbdCx7vOQZa4xD3ChwIiwyB1nDfPUY5ROznrqta5qIX8A
         1L2WVnHnxlbPnghbR9AjzzChRIldZ8vum1KP+r0S9fszebdOMXwOItFv59/I7QADpnkQ
         gbjviuNJO8+bd70YXFWHgQFyerKk8Tpd1i9NfaTuNLC3pSNFuk+FW/GCWeOMJ+w1WDt2
         8g+w==
X-Forwarded-Encrypted: i=1; AJvYcCWzsW5+wM1GRHkC45i/6DH3it7AVUM5QQlYRgO9MP4ETkyAXPpMICd8YswU19Io5v8HCi4BdXMBwQ==@kvack.org
X-Gm-Message-State: AOJu0Ywtmnlf1JoCQUH4FaChikMbuqBC9N3EAZubthOQcKlUglLw4AYn
	GWxQVIwLkQdvjd/BY6xyv5OR1F7wPt7/VEduK9m6dCqxHQtIyZNsuBh6Kzs1vWQwms/biu32Xqw
	oj5EKhVIhFxag9DZfabTgCoFPWLR94AkD/gIerjZmWrTAowZFs0T4
X-Gm-Gg: ASbGncsBvx3irtA+bVjuPLT6luCKj2RMAluzQ/AJNhPS2mBEmM7AThtcFbVyj1yKb59
	rjeirSR6VCqTDZwCQ9Ws9zoxLNcAxTfe0FFavLwolMTjR9DH2cOA7CFYyoGYk3D5eAMDcerLCki
	2TqWgbWOPHDfZ6Mvm355iIPsd9IYbvZcvD3UkronIZVM5/DSE2P9oUEMjYTdQ487dij7bYLdA8u
	OdP3hxBW3rjR9S+f203REVIwyN0P8jrwyUIljBhyiGn3E7obcvAB5LRE31ZsPXxKuxqB5UlSLKV
	m1xoCujtCaZyZ7RhJPPXYHW780urcbJV
X-Received: by 2002:ad4:5ceb:0:b0:791:cb4c:9b6a with SMTP id 6a1803df08f44-7991a92e840mr35669156d6.42.1758294742567;
        Fri, 19 Sep 2025 08:12:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGCDlUJCkHLQ6VjNNDvf2z4Gu2ZNi6fnE7IirCVygBUyU26zMlumF7vXOau4Gjkxek8FmU4UQ==
X-Received: by 2002:ad4:5ceb:0:b0:791:cb4c:9b6a with SMTP id 6a1803df08f44-7991a92e840mr35668616d6.42.1758294741979;
        Fri, 19 Sep 2025 08:12:21 -0700 (PDT)
Received: from x1.local ([142.188.210.50])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-79347e4d391sm30251696d6.32.2025.09.19.08.12.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 08:12:21 -0700 (PDT)
Date: Fri, 19 Sep 2025 11:12:19 -0400
From: Peter Xu <peterx@redhat.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
	Muchun Song <muchun.song@linux.dev>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	James Houghton <jthoughton@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Ujwal Kundur <ujwal.kundur@gmail.com>
Subject: Re: [PATCH v2 1/4] mm: Introduce vm_uffd_ops API
Message-ID: <aM1y02xaEUkjOIsW@x1.local>
References: <4czztpp7emy7gnigoa7aap2expmlnrpvhugko7q4ycfj2ikuck@v6aq7tzr6yeq>
 <a1a48a0e-62d3-48d0-b9c2-492eb190b99f@amazon.com>
 <7cccbceb-b833-4a21-bdc4-1ff9d1d6c14f@lucifer.local>
 <74b92ce3-9e0e-4361-8117-7abda27f2dd4@redhat.com>
 <aMxNgyVRuiFq2Sms@x1.local>
 <cigo2r2x22bk7wzr6qvazcdkmt5kfqhbgb7nslpuff7djufucg@f6xucfuntz3q>
 <aMx0oGwRpSTcfdnf@x1.local>
 <swfs7qpgrezamnijhheiggwdfklfqdc6ahp5g7nvprr64m7wz5@msf2mqajzbuz>
 <aM1l2YMmvBgiXJ8a@x1.local>
 <33dc85e3-f3ac-4179-bf1d-821135fe3c42@lucifer.local>
MIME-Version: 1.0
In-Reply-To: <33dc85e3-f3ac-4179-bf1d-821135fe3c42@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kCUMSBOOJcsyOPfhwlRoDvd6p2GBPyfJIP-sDWs7dRo_1758294743
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3F32EC000A
X-Stat-Signature: fsjf5ob7dstya9c6dzs7tjogr19nhwg9
X-Rspam-User: 
X-HE-Tag: 1758294747-822522
X-HE-Meta: U2FsdGVkX1+x8zwvyDsaI71xqU9WuAv5e4oARz3xtflF0u8ceXDvuXUKKdHaST8d0FE54AXasvwSmenp8fMozs4svktz9JppiGcabe+CkvIHVn6JYlKqA8DZiII4WLeWYlGn0G/Jr3+XDl5UBTA6zNejx0NnkAzcXMbSQ9lxx/nyv0aL2+bSg4zWzRHuAm/xHuW/06Zp0AYSd30gCvxEfWbIkE/UnA4hQyoqv498D3DD8bSsQV1u2SfV/nYIrX14rGGGaC4a+Kpe3O88eAWowW8n0rsd2FbyWGIpMNkC2BrD7EBwEIcpJgeMJKt+v0KyhhaB5OOOYFYh9isJcx29JHMOe5lsxPNYed96nOMsG+H7NIGyxsPq5B9QpwYsZoTNS4U3CIVX5tu9aZySCpVtAKyvK71WbARiIE3WP210GT7CtJSiIs1AUaqDC/BYnMsI1e3Oo0ZDKx57Ni9IQLCvmJ4cKkhyqkcv5jev5TR+TDWjXxlyt9mwbEY7telv4bLYe00QeXSWy26NRc3t+E4RyoUqO4XcY7Bn7B0ntJt2o2RKf5sPI40Rid+IB7iZlvlYaqR/3vHFqkZ6Gvofnre4EQdX4bcYAnSEf7Ip62T3VAOqnBKo/xmqlIkY8rDt+Pz28+0LMPzvS1eJn5Wrud/0NGJU0m5pdWvdX4nC696t4nXRPZBoIYRbcvYR+/9vRGWDpdcV+igx6LRQqvlrr2vnsgKwylclPAsjS8hThDGmjKy6ailPX0Jx3XAm726bXB71AXXtI0Oov63ntch0fQhXDraUd8uEQd+jgOrITp/51po1OwYuRRObOaDWgUrYHTWv9hb9CIf9BK3yYTG21Uc8cijT/b47Fw5xNCyfD68psdsKSdCosNguTlgxMRfZgpT+/AW4tvofiCZ4sK5RHbFFnH8sH3xXBlfAYTCQWCcSnoyYb500QDXkeTDoZIeg0IRO3uc3jmZjF1cOSJsBUGC
 leByJW2r
 oX7nIaNa8JHSVNH98Cnnp3XbivkRRMrX2DeJ7xTm0v/yrgsnIqvWQFrokT+ntYKCjEJ71r3tiEuuC25yvKUiTbFK/mEo+6UiIDKGEWOgrmnBdDJUKJypZbmdsrDrP7VYGY8066R886sBd5lWQAXDxM8pifKubLESNmF4Oh55XJeI2JrEO8X0Xoh9t7aGsE0Dqd6I8fbELoC149IplGDRJDSA62HoScUSQlxCK9SGgxJc48hjke7dqL4j4GZMBt09wPs5A7Yx4czD47FrlVtBaxAALuu0NHdtoHAxExK2M5MLFB94rEm3+dBdaHHKoOdO6KSlVakzVqk54l8WJM5Md6boTAn1cF4U/UTGtZka4j5EvWhUeDUcfrnUE/cveptcxVtaIghZubqiqNgOHScSXHvHl1Ab1jvkQNXC66B4NRjkUvADOEevk3fetUJkS6JjvTo7Iehj9nBc99Qq16ASjcDERq4clh2HQarLRjur5c0Ro9xI52k8pSq2hmY5rAT0xhTYAmmPgd+8DbYB1U4FkrivrsAc5Fm3grDZPFLQwUQG4ryj0PgXtZipnLW72CMIG2kTP69563mZK0ds=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 19, 2025 at 03:34:39PM +0100, Lorenzo Stoakes wrote:
> Peter -
> 
> I've been staying out of this discussion as I'm about to go to Kernel
> Recipes and then off on a (well-needed!) holiday, and I simply lack the
> bandwidth right now.
> 
> But I think we should all calm down a little here :)
> 
> Liam and I (more so Liam recently for above reasons) have pushed back
> because we have both personally experienced the consequences of giving
> drivers too much flexibility wrt core mm functionality.
> 
> This is the sole reason we have done so.
> 
> We are both eager to find a way forward that is constructive and works well
> for everybody involved. We WANT this series to land.
> 
> So I think perhaps we should take a step back and identify clearly what the
> issues are and how we might best address them.
> 
> I spoke to Mike off-list who suggested perhaps things aren't quite
> egregious as they seem with uffd_get_folio() so perhaps this is a means of
> moving forward.
> 
> But I think in broad terms - let's identify what the sensible options are,
> and then drill down into whichever one we agree is best to move forwards
> with.
> 
> Again, apologies for not being able to be more involved here,
> workload/other engagements dictate that I am unable to be.

That's totally fine, Lorenzo.  I appreciate your help on figuring things
out.

I do agree the discussion actually went nowhere.

I think so far the "issues" is very much clear, about exporting
uffd_get_folio(), as you correctly pointed out and I'm glad you discussed
with Mike.

My point is that hook is totally fine, and we need that exactly because we
want to keep ->fault() semantic clean.

Just to mention, if this series cannot land, I prefer landing Nikita's very
old version (a).  That'll make mm fault() ugly, I pointed that out, but if
all the people prefer that and all the people like to sign-off with it, I'm
OK from userfaultfd perspective.  I don't make judgement there.

Then this series can drop uffd_get_folio() and keep the rest in one way or
another, describing memory type attributes only, and need to cooperate only
a driver with a ->fault() that works for the new flag.  But then this
series will be a pure cleanup.  I'll likely then put this series aside as
it stops blocking things, and I also have a queue to flush myself elsewhere.

I wished we can just go with this series with uffd_get_folio() only.  Feel
free to discuss with more people, and let me know how this series should
move on.

Thanks a lot,

-- 
Peter Xu


