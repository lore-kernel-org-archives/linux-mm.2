Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C25FCAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 14:02:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 971E38E001C; Fri,  3 Oct 2025 10:02:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9491D8E0007; Fri,  3 Oct 2025 10:02:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85EF98E001C; Fri,  3 Oct 2025 10:02:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6ED2C8E0007
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 10:02:23 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 25CCC451F0
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 14:02:23 +0000 (UTC)
X-FDA: 83956967766.16.3A02984
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id AB5DB1C0002
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 14:02:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=d990GyQ9;
	spf=pass (imf18.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759500141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FfdNLsJo1+niCnnKhS//GeejM6UpWhfStrR/oS1d2Yo=;
	b=SQwJMQPdlkVhPNN9ELifrT8gETdNYu5/SnDI17yUmsF25dpi/3ye3GKZWV6Csb4vg5EPHD
	jMexXZENXDseCqLxOqk3A8SP087rXw1CYX3dYlFZ7pejZzuIJ01UZ0zFCvsWuOSAtzK4Xw
	vI7zdkkA6Y6NM+vqmVehtcqgr0EWp3U=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=d990GyQ9;
	spf=pass (imf18.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759500141; a=rsa-sha256;
	cv=none;
	b=yp8+3lZU65l2wA1XFVwzfemoXKoAQTSqFaEDgqWRMH+xLk5wLn6kgj3J6x1Xgh/L22UX21
	WLO4anpSmxedgEmETpzzmnDT2FpOh+hHBWgM+XwNex6FjKYp3N5lzeUClpQkrPSJS8rhsU
	LR2p8kClD4xEftrTuT4GvApuuhwNzvs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759500140;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FfdNLsJo1+niCnnKhS//GeejM6UpWhfStrR/oS1d2Yo=;
	b=d990GyQ9kwrT196VFyJ+XEA74648HTMfoeZj/tuoBD7guZzbd67KQYmDT8YO5+Dy2dc8x9
	/PQwxzwXa1K1JAyUsgrB/rH47pwWn0CWHrtH7JWg6GbI855cJ+CVRhKQFcA6Z7mQ/0C5Uw
	dBZk2gr9+lg6+6aPnXyjdRHQAHnZy6U=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-264-p_BD7KLYMhmubOkiZcNWvg-1; Fri, 03 Oct 2025 10:02:18 -0400
X-MC-Unique: p_BD7KLYMhmubOkiZcNWvg-1
X-Mimecast-MFC-AGG-ID: p_BD7KLYMhmubOkiZcNWvg_1759500137
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-43d3063f5c9so602114b6e.2
        for <linux-mm@kvack.org>; Fri, 03 Oct 2025 07:02:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759500137; x=1760104937;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FfdNLsJo1+niCnnKhS//GeejM6UpWhfStrR/oS1d2Yo=;
        b=Kwcx7pAQy0ocsZ5A/G8rSiZIdKZn1qDsZNwrqqTp+7N+fJOJsuK8vw27P28bO+khFO
         xCSoxuy5CO7xUYJgCokTFuoz1WAOPxpWPhKj7OkXZvbwnWE22sZLLy/XFF3Mu1X9vCey
         OYGqrtarkaZ9Lu1uu/pAHqS4ACGeQ7Zu/D0eJv/W6Nm+WeFitXu4JVjRIMAX2R7mKAcU
         Cex01UvKOiOiuSkZr/FbvCTUGV5NKdAr4eBzljSf7FK66904IrV0oZZFOfRo0ITOrZU+
         u2oph9L9BOGvez8P6uqwpqjxuF3eJCIiIcXYcnhpaGDFz2cG/H2Wq0DDXpswndM23O5C
         8OSQ==
X-Gm-Message-State: AOJu0YwqsGHbPobcw3D/Ha2dBQRnzbGl0uaYmBlzE8yehY6YXZIwPr9z
	Q5TmAxIDPXmQJ+6mhNVajxQ1BvDjUdoDGoguZe5z94jvky4ud6aTg3lG1soCQRf5F63wWEJJ2GJ
	Hd2ibwJbzZuQqByHdeoVTI+SPNHCEeXyPefwYRoWsTbtBVOE+eTIs
X-Gm-Gg: ASbGncsM7xFsgyANHh/2VLsTTjuCj/LSn+y4uG2xiF3L7zHcHpk0YUge2BJ4hNesl44
	e3ct4g5ZGtLejKwbIs8d705ZR3Ct+P6Yallmj72JcdXmnyOZPF0l4dOBH6wXuIHh1Cciumsp+v3
	lq3KoiXLt2FtgIWzL+8R1qMeMrK7yYR+pYaAoO+YnezhEz+2PdpKH3CiPkvdCBu0GZN19QYc4gF
	q573/NK4yDskIRS7WO2ydd/WvazPUZZmQDnYd8uGwQp12bZs0lDPGBfiyVSgSFUI/DzbX4TkQGP
	0yyAs/bOXX477J3rKMhf93HKOlWcmg5T3nMqqA==
X-Received: by 2002:a05:6808:1784:b0:439:ae49:9159 with SMTP id 5614622812f47-43fc1828ba0mr1175485b6e.36.1759500136856;
        Fri, 03 Oct 2025 07:02:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEisDW2mGnc04qMiO0ty7y+ZeCROu3lxEpJKjD24LI/W2t/5ZFdYU4iCFfZ9dw1K+GrywtPBw==
X-Received: by 2002:a05:6808:1784:b0:439:ae49:9159 with SMTP id 5614622812f47-43fc1828ba0mr1175402b6e.36.1759500136107;
        Fri, 03 Oct 2025 07:02:16 -0700 (PDT)
Received: from x1.local ([142.188.210.50])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-878bd785963sm38628446d6.35.2025.10.03.07.02.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Oct 2025 07:02:15 -0700 (PDT)
Date: Fri, 3 Oct 2025 10:02:13 -0400
From: Peter Xu <peterx@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Axel Rasmussen <axelrasmussen@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	James Houghton <jthoughton@google.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Ujwal Kundur <ujwal.kundur@gmail.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrea Arcangeli <aarcange@redhat.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>, Hugh Dickins <hughd@google.com>,
	Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH v3 1/4] mm: Introduce vm_uffd_ops API
Message-ID: <aN_XZbQjuYx-OnFr@x1.local>
References: <20250926211650.525109-1-peterx@redhat.com>
 <20250926211650.525109-2-peterx@redhat.com>
 <f1da3505-f17f-4829-80c1-696b1d99057d@redhat.com>
 <aNwmE11LirPtEuGW@x1.local>
 <f409cbe7-7865-45ab-af9a-6d5108bc5ad4@redhat.com>
 <aNw_GrZsql_M04T0@x1.local>
 <43d78ba7-8829-4a19-bdf3-d192a62cdac4@redhat.com>
 <aN08NxRLz7Wx0Qh4@x1.local>
 <ad124fb6-a712-4cf5-8a7e-2abacbc2e4be@redhat.com>
MIME-Version: 1.0
In-Reply-To: <ad124fb6-a712-4cf5-8a7e-2abacbc2e4be@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: DbpMuq_qXR82_Mg4VzFEOmcezUhhtnvGMWFAJUMPImM_1759500137
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AB5DB1C0002
X-Stat-Signature: 19hidnm5igmi33ui8gc1ey1cjgc5gu3h
X-HE-Tag: 1759500140-706962
X-HE-Meta: U2FsdGVkX18GqKxwQsNj9ncdfKcVcjiIOWFJ9NmQzrYEvAyM5i5mZhKZW5BmSEBwbsoPTKg7lc5LqVkTXsH0S+1i9IYrfQRzShThYj0H5CzuB2kanRH7PMau+cODLGTbwqcG1Egj4ylEe7U1AaK3Hhf+vtrab0TpE2zhAAhhRzTNv/AHoWOtMofg5PFeQaWAzFCTzCdSdbUTXWLedkWUsn1btZMD5FLeu87pZs1h1cCRr1xAHYtOfB/4BQHApeAPYzJgHv70MPfd3FidFcq1YMa3RnVu+4mW7SXC8BygMHHWrAslmFE0+HBVvPlL9TvgbK+srFkMjcoGMFZMCBNhyUaI6RREqt17hSLm43kMEyIKKw/WcAZ1GESCVFy9rvSCfzlJhUQSebW9IW9wIggOYxk+fTklUSc0+qVqKa+1PxJq1glr/RF0D+zY6wl50VCVEY+QaQTvDNSra8nfwXHNPgZxrXf7soZ45q8YzkUmh0yutC3rxj9GxBq4UDs868wI7sXR5+AEZldveJsJdEDRZmmsRTlns8AZgZqpOQj7+WQNa5+3uUfuVFDAPrxyRR1XtE/fhw5cNfWoS81EHIz61iQK2dCbdcuCdErBCwm0xPVnih9muCugCXZ+KQNWWrlamx/hmPvn2069ZElZmKCzsgYswlSRKWt85PiWufG3ZJkQ4z1AH8cHUL559oJ9rzBpwSNJfD/gH3AM3uTkwnEWOcAAYpAxgOe7L5EPcDi5aqo7LS8ZEBE6dymSBC8nPl2feC0qcOrAmXl3F5hPUfYq8TIJ4RlPbsxYcUqKI14vjqmkOv7EX1KdDz+Mpn+citu4VlyXY1FRndE57XBwoGiFt4607ul2fx6nHMrQJiD2fKD0VNnJG2Bsm2aYTGoMfN+nejNtVQYPNfCESVJlJgKEkn2TpL9qSPqkDVrxBhpYcJkbC5ws8sx8DkbTvtZn3mNX1BVRmg9+rEOOCal7+FU
 c7pGQtia
 B73nMHBmkdYtCqvs06Ij+N6tL/3rgVLHsu5XOf8am/cUFkCOnnU7zfjMJ/jKG6caDBhQdWREn9kTCRLYE8w73mLIaaV98lQmIswip5y9A1L3y2Nk8XF1Wc2d+BIPBBwqClpoiNhaeTUpd7ZzRHymsxjvCyb6I7QkSsW0xlOEhK8khgiob34oPrR/JDRPKkHSGClr0twREmgWCM+8VnaPqQJGCG+O0o34y6ISl/Kpm301ugzSWzd7EKzKioaB2FVHGurEzienTfOdQxgjldUmaHGtVw/OwVxYPi+eCLfGsGjnKtUvpK2Pm5VVIVf/ToEB+njf/mtJHVs2yCbqW+h1jW5tkDkKq7HHeroIqYJ4TQxCrCvvJkcLIjZPjxHNJ3u7e0c01jV2tXatFqgF9LRR0OwMOJ0xTEKeXvDyMtg+B5kpFznc/WNoMrpl6g6qSGQukAioGCAhwgJH42S5/7G3gkV+A9Hl7GQ0SVXyz48hyWC3IfTozZaDIJ3Pk2NlW8EOJY+AgLrjZZ73giGPFJ4mDkCHy3jfD3/bvi+VLK2KdiVuwLn4ea69UjIBSEIsJmZWG0e/X0Z700Ijgbng=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 01, 2025 at 04:39:50PM +0200, David Hildenbrand wrote:
> On 01.10.25 16:35, Peter Xu wrote:
> > On Wed, Oct 01, 2025 at 03:58:14PM +0200, David Hildenbrand wrote:
> > > > > > > I briefly wondered whether we could use actual UFFD_FEATURE_* here, but they
> > > > > > > are rather unsuited for this case here (e.g., different feature flags for
> > > > > > > hugetlb support/shmem support etc).
> > > > > > > 
> > > > > > > But reading "uffd_ioctls" below, can't we derive the suitable vma flags from
> > > > > > > the supported ioctls?
> > > > > > > 
> > > > > > > _UFFDIO_COPY | _UFDIO_ZEROPAGE -> VM_UFFD_MISSING
> > > > > > > _UFFDIO_WRITEPROTECT -> VM_UFFD_WP
> > > > > > > _UFFDIO_CONTINUE -> VM_UFFD_MINOR
> > > > > > 
> > > > > > Yes we can deduce that, but it'll be unclear then when one stares at a
> > > > > > bunch of ioctls and cannot easily digest the modes the memory type
> > > > > > supports.  Here, the modes should be the most straightforward way to
> > > > > > describe the capability of a memory type.
> > > > > 
> > > > > I rather dislike the current split approach between vm-flags and ioctls.
> > > > > 
> > > > > I briefly thought about abstracting it for internal purposes further and
> > > > > just have some internal backend ("memory type") flags.
> > > > > 
> > > > > UFFD_BACKEND_FEAT_MISSING -> _UFFDIO_COPY and VM_UFFD_MISSING
> > > > > UFFD_BACKEND_FEAT_ZEROPAGE -> _UFDIO_ZEROPAGE
> > > > > UFFD_BACKEND_FEAT_WP -> _UFFDIO_WRITEPROTECT and VM_UFFD_WP
> > > > > UFFD_BACKEND_FEAT_MINOR -> _UFFDIO_CONTINUE and VM_UFFD_MINOR
> > > > > UFFD_BACKEND_FEAT_POISON -> _UFFDIO_POISON
> > > > 
> > > > This layer of mapping can be helpful to some, but maybe confusing to
> > > > others.. who is familiar with existing userfaultfd definitions.
> > > > 
> > > 
> > > Just wondering, is this confusing to you, and if so, which part?
> > > 
> > > To me it makes perfect sense and cleans up this API and not have to sets of
> > > flags that are somehow interlinked.
> > 
> > It adds the extra layer of mapping that will only be used in vm_uffd_ops
> > and the helper that will consume it.
> 
> Agreed, while making the API cleaner. I don't easily see what's confusing
> about that, though.

It will introduce another set of userfaultfd features, making it hard to
say what is the difference between the new set and UFFD_FEATURE_*.

> 
> I think it can be done with a handful of LOC and avoid having to use VM_
> flags in this API.

I waited for a few days, unfortunately we didn't get a second opinion.

David, do you feel OK I repost with the rest comments (almost renames), and
if we want yet another new set of features for userfaultfd, we work it on
top?  It'll be a trivial one patch to do the mappings if we want.  The
current patch is also the minimum changeset we need to unblock guest-memfd
minor fault.

Thanks,

-- 
Peter Xu


