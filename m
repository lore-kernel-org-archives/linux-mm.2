Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 382E8CAC5B8
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 22:16:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 438FF8E000D; Fri, 26 Sep 2025 18:16:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E9398E0001; Fri, 26 Sep 2025 18:16:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D7FB8E000D; Fri, 26 Sep 2025 18:16:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1DF3C8E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 18:16:52 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8F56911ACDB
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 22:16:51 +0000 (UTC)
X-FDA: 83932812222.19.8BDE87D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4BE668000D
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 22:16:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=M7nU6+pF;
	spf=pass (imf30.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758925009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kkXTa7RqqZEP8ZuTVR6o5k3BT511d0DHtJk9rDVDug8=;
	b=b1YDSabgmRsBpNeTQBNQAL6XMOX+aAQwBsvrH0v3tXs2RNTE8Ik25MClhIqG8577cqkLSO
	2REZTzSzAnucvnPSQJOXRvtnqA/hqwPQjYzjdLpS8cnxhiqqoxoFO1+KZmRrYSUJ+Yjln9
	63zA+F5h4Qg+5aeajgzi0KtOBKD4KaU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=M7nU6+pF;
	spf=pass (imf30.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758925009; a=rsa-sha256;
	cv=none;
	b=yXKkmFc+Ooeh1sXpbmo35/k01zgDDqcEtrU3FPhZrlw4tJ23gS9+Zz69WczOMYirC2Hi/O
	YMmQtTAJXANiOEaXQ19MGOPUj6KWi3aqLJdDPcvI3X0Ce+u+Ya2fvOL10gyJCxvUnxHOkz
	QHgW1u9rhLzmRPPqT5GfEOmI/5eMKK8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758925008;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kkXTa7RqqZEP8ZuTVR6o5k3BT511d0DHtJk9rDVDug8=;
	b=M7nU6+pFfCx73uYp4YX90YKLqr62tnShz/jzOsmzlFezm32D4eTawJM6RxzRjU5d1vQKjX
	z63D8aNgaWA7FBBI2D1kxtBcJrBfcYD6J09JKk/p9BzcGg5Xxmwnpb9t9j344JeT7wlRIH
	PQVmn06qtMunf/t/UqJz+YZmMLHGULo=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-151-chD1EIXkPAOWKmZAH5a54g-1; Fri, 26 Sep 2025 18:16:47 -0400
X-MC-Unique: chD1EIXkPAOWKmZAH5a54g-1
X-Mimecast-MFC-AGG-ID: chD1EIXkPAOWKmZAH5a54g_1758925006
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-84a63a0c496so755331985a.3
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 15:16:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758925006; x=1759529806;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kkXTa7RqqZEP8ZuTVR6o5k3BT511d0DHtJk9rDVDug8=;
        b=mpW0nSpACCbp6IYGyO+c1N+CXmuQhy6A9+HzgA5ozTdzQT4fA1gRfDU10AwGgUJBlk
         svXlGdWTgXSEp7pNAyv4+Gzr1IyPublzN4AX10732QNH95IyNt3WrxecPbTHOj4NjVzO
         WgiA5sGvukG8kWuYlZC680n8Sj3WtA/7UoHls9wep/o4lA5Ird11y6KsVNr4Nh8aRdZ+
         CrSb6bma8h1JjeMnpt5MpAX+2JGPHsYbbqXMmnvUqeH6Kpi5ew5jeUUb92M1wjXDwHBI
         afp/k5prH7YOq+vc9RgdWCtCEBKpn0dxKMgcTEm9n/D+uQ2ngIij1J1uO1uopy87Jv9j
         NhPg==
X-Forwarded-Encrypted: i=1; AJvYcCXar4KUhc3wKhu/t1Y4GhNW5ztGcK/ftOPK0Syk8Mm+GiWXupIidcvi7hAyr3/wWahlJk0jbh3Bfw==@kvack.org
X-Gm-Message-State: AOJu0YzX3zX8W/5O4T0cqvNjqz7F6gCT5oly/stR6YeCs76+3bOyLOj9
	pLiA49DmyjcUQRckdOvVPL3Qtzk62yFUapx2nZ+3wYeTVNverFhRgAmUfShAL2n3XT3xEtPjnhs
	AMbQnAgta3S/10tHBiqXxrrPlRKMX3QKJmMOXTu8RCNt6y590WtAD
X-Gm-Gg: ASbGncuaXFv/4MqXuhteUPlmdvnkEy8qLUBpWCa+tFCHRTqNg10ewUltp/m4lOiWkLY
	H+8SAEPBj5pEuk+vh+5SryGoNxF/KxKKpwRsMD2RM4qFDb6229cyX4Dx/CqCO0Kaouo/dElGUXo
	JXbma/TOif0p4ZCERDVqBK9f9SpaWKuov6/MGFYeoJw7t9RUNXaqWhDnHdN//zQpmNH4dYJqRgS
	58S7aha2WzUW7+ltexRuj/9lou0h4UmxrEcaGFzJ6BMVd4YGM9jgk9s6H9B2Uo4lt9LTHtOmeNr
	m8CSkAXlZDpjrxAPWtCQMIt/mR2dPNSQ
X-Received: by 2002:a05:620a:3704:b0:848:5ee0:e8c3 with SMTP id af79cd13be357-85aebdf5bd3mr1094460385a.64.1758925006157;
        Fri, 26 Sep 2025 15:16:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IErs36LpN/UBpbF14R9glt6nLAiwkd4SkJisQznHMXdN3otqZxjc89EFlrtBgNp8AJfrqVjKw==
X-Received: by 2002:a05:620a:3704:b0:848:5ee0:e8c3 with SMTP id af79cd13be357-85aebdf5bd3mr1094454985a.64.1758925005494;
        Fri, 26 Sep 2025 15:16:45 -0700 (PDT)
Received: from x1.local ([142.188.210.50])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4db11221a68sm32902091cf.36.2025.09.26.15.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Sep 2025 15:16:44 -0700 (PDT)
Date: Fri, 26 Sep 2025 18:16:43 -0400
From: Peter Xu <peterx@redhat.com>
To: "David P. Reed" <dpreed@deepplum.com>
Cc: James Houghton <jthoughton@google.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Axel Rasmussen <axelrasmussen@google.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: PROBLEM: userfaultfd REGISTER minor mode on MAP_PRIVATE range
 fails
Message-ID: <aNcQyzvre07V4UUC@x1.local>
References: <1757967196.153116687@apps.rackspace.com>
 <CADrL8HWGcj1oANGY=qAzpYi_-E-Xbi=L28Bmyyf8H7auVix=QQ@mail.gmail.com>
 <1757977128.137610687@apps.rackspace.com>
 <CADrL8HX78-oh0k2qAgqPvNVAhi4ESYvjRsScPGR2P2Dts13Bfw@mail.gmail.com>
 <aMl4qLyNovWHhty9@x1.local>
 <1758037938.96199037@apps.rackspace.com>
 <aMmMnfU-Koopc9mL@x1.local>
 <1758042583.108320755@apps.rackspace.com>
MIME-Version: 1.0
In-Reply-To: <1758042583.108320755@apps.rackspace.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: XcQpyRAppKh7YM2vP6Qr3L5Huunra5w63NIaQn1sogw_1758925006
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4BE668000D
X-Stat-Signature: 3n63cscwndizda9cxz8jxej9rwfcujr3
X-HE-Tag: 1758925009-779235
X-HE-Meta: U2FsdGVkX18wmaUsGBOuXAwWd3aI0IiDTCy8vG8A/TKjAVXyO1gc2c0xF53opyt510EExgU1HZCuG5JAxbelYIU+1NUI9h8ddmJ8YnMPl54zpkl1zDOhCKPoM0NwTBWQk4mCQOEPw+RGPUgnCGSP8I4KGNnsrZnIvFLF94IoSlDS3Smv/xO9GavlONPAor1x4n1RY+9o4KLZXh5qVcwGulZUV2XbSPNXQTPJBHcjVxmsOKBFz/+4K4otrUS0yMyMC3KHBpDdmExsFuddNxbtdcAxfAfdMyGfrUUxBIEeAA/8YTMkC+tIaYIFliHhaAYGExnZGgl+ceQtU24PM2iHFiWZgahGNkDYCRtnNLXQ4uWElkBuvVOis5oQkdiMsn6FYxbIolp3lFgvpfDm6FPJbIYrRe0Brd7My/5WFjJuHGypRlRimp1OITlf4kYuMGZ7+WMWwgHtn7zmz2HY4k24ylMrLyLHJDrp8I9k1ygnBLL8+/sXpKY/FY0Qf0YS70equk8H9qk9eZQWfRnoCkHawvBnTMRQAtSLGxMfnfk/SBuSONSCqFE+z9mngsYxC+sahS6fA2WJUaHKVYvo8O0ycs12ZVu9wYb6j+BedL2nGezPwrefisslugmDgnx1iiTLSTd5/TEplW0/u0D7pbdYIdm0DxbCC38zbMWCh5x99MNICae75VUcQEjEulsYoYIM+4XMq6+8JXNN/reqvbzYUjtAwXhkqg+GGnSuIZ/NX00ppugHJLIGKrNGe2Q/yBKRfC1Rv3TH2jh10ryQcSg7wLCGD8rPfLE0P1T84HuxipOmbvM7WkEaRRK7bZm1F5ZGf40yVX3SniOmkj1OeL+/5VFmac5RelBXJQJ7ZDRV+20aG129SBHjNZ03jNuN9TtKqvmN4/0KwGJQJdSGIOyCLLXtVHrGdI7rbCg6m2tKl5k4vUSMGMESP5WE0WJCxz7/Z52FOysiaNx4V5L7HCM
 bZ+pkGhV
 2u9+QhriSf22U4/zG5KF0rAKcoQ8xm2ixxOKRPs4So+jqoxqJNVjtnyZ/1/U1pgRX+6raZiyu73zkohQjVYOVYT/qeVE0dZQV7UdPpOY5Mk1lpJlL5SsRzsr4Nh1NmbRMYqDmdJFL+yR7Y7HBvVZrsR0SrcMf5VgWJJOFF0boajjZg8eifgInfjVKqoqWYnHeRiyspLGagYmJ0v78mzGH/0PeuXXhnvcdbPt33UDn4BI5HyCnCmRfG0G57D7SmX2jTSB2MjE9hCUptQ98FUONmzvX9TmYvSPYvsfLB2zYfUYBVxDq8v3K1FF66C3mbsFYt8UzvblFoBGZhEk5NZuslQ0JNgQm3LntfcW3k1PhHJxq1oyz+ccJYr/9l2RgxfVRszK9vePj92lmj7S2YKadbVZw+v/Sc4hwnjGRUeYkH2gPqfkImUPzb6u8cpjRGRUlPewHhToxoRTXZjbDyEWGjdbKFaUm1p86zFRS8sA3VeQ9SIloRAQdYxEUvaq/ghlrvpoR+KlYBZrTpitJU/K6B2wpZdsPqLjidePucOLYuxwX2u28FR1WrvBjo7oRFte1NKQM6bmD0bUeuVoaYDaBVcAvMg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, David,

On Tue, Sep 16, 2025 at 01:09:43PM -0400, David P. Reed wrote:
> Than -
> 
> Thanks for your interest. Some clarifications on my current use case are interposed below. 

Sorry for a late respond.

I think I get a much better picture now with the answers below, thanks.
Looping in Mike and Andrea.

> 
> On Tuesday, September 16, 2025 12:13, "Peter Xu" <peterx@redhat.com> said:
> 
> > On Tue, Sep 16, 2025 at 11:52:18AM -0400, David P. Reed wrote:
> >> synchronous would be better. But what I want to do is at least get
> >> notifications of swapin events (including the case when the page is in
> >> swap cache). Also, using UFFDIO_COPY can be useful for the swap in case
> >> might make sense (but rarely, because there's no way to access the data
> >> that was swapped out).
> > 
> > Some more info on the use case might be helpful.  I can start with some
> > more questions if that helps.
> > 
> > - If it's about page hotness / coldness, have you tried existing facilities
> >   (page idle, DAMON, etc.)?  If so, why they won't work?
> 
> Yes. Those functions are just summarizers, giving counts and
> averages. They provide zero detail about specific pages to the
> application running in the process.
> 
> I can clarify my use case focus by pointing out what inspired me to use
> userfaultfd for application specific memory management (which is, after
> all, what userfaultfd was promoted for on Linux Weekly News a while back
> when it first came out). This 2024 paper is along the same lines as what
> I'm researching, and was published in 2024 Usenix proceedings.  ExtMem:
> Enabling Application Aware Virtual Memory Management for Data Intensive
> Applications
> https://www.usenix.org/conference/atc24/presentation/jalalian
>
> See figure 3 of the paper for their performance problem with userfaultfd
> vs. their kernel modifications (upcall).

Correct, userfaultfd does have such IPC overhead. SIGBUS sometimes can be
better, but AFAIU it has limitations.  E.g., I am not sure if the signals
will always work when the fault is triggered in either:

  (1) a kernel context using copy_from_user() / copy_to_user() or GUP

  (2) when a fault is scheduled somehow onto, for example, a kworker

AFAIU, (1) can really easily happen if one tries to do syscall read(),
write()..., where the buffer is userfaultfd protected.

Meanwhile, (2) normally can't happen but it can still happen in at least
the KVM use case that we heavily rely on, where KVM has a feature to be
able to offload a vCPU page fault to a kworker (we call it KVM async page
fault).

IIUC, such limitation will also apply to the upcall solution they provided.
From what I read on the paper, that should really be a mimic version of
signal handling, but making it per-thread, under the same task context.

>
> They had tried using userfaultfd for their work, and found it was "too
> slow" compared to what they call the "upcall" technique they achieved by
> modifying the kernel page fault handling path. (see paper for details -
> and Jalalian't thesis dives into it more deeply).  I could code up an
> equivalent to their "upcall" - but that would mean completely
> non-standard (and fraught with security issues, as well as not being able
> to use a separate management process).  For me, the performance concern
> is less problematic - I'm doing application analysis and
> experimentation. And I don't want to have to maintain a kernel patch set.
>
> Note that I expect to use madvise() and process_madvise() to manipulate
> page coldness and swapping as well.

Yes, looks like the right tools.

> 
> > 
> > - Assuming it's async reports that can be collected, what do you plan to do
> >   with the info?  Do you care about swap outs prior to swap ins?
>
> Detailed application paging measurements, modeling, and so forth.  I'm
> not asking for a big enhancement to userfaultfd - just expecting it
> should (as is) basically work, if the UFFDIO_REGISTER actually allowed to
> register the minor page fault mode,
>
> > 
> > - How sync events would be better in this case?
> 
> Simpler to coordinate the interaction with the faulting process by far.

I think I get the gut of how you would like to use it.  However, my
question is, if you want to do fine tuning of "which layer of memory should
hold what data" kind of thing; IOW trying to replace the linux mm swap
system but provide a likely better one, more suitable for your workload,
then why you have swap in/out at all?  Why do you care about that?

I was expecting your PoC (or ExtMEM) to completely bypass Linux swap, then
you can freely move memory pages between system RAM, NVMe, RDMA, etc. like
what ExtMEM paper mentioned.

So far I don't see it a block if one would like to say that the swap cache
is also one kind of page cache, then would it make sense to add MINOR fault
trapping to anonymous but only trap it when swapin?  Kind of ok when
initially read about it, doesn't sound too hard to impl either.  It's just
that I still want to double check with your use case first, because it
really sounds like you should have turned swap off.

Thanks,

-- 
Peter Xu


