Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 512C3CAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 14:17:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 985968E0002; Fri, 19 Sep 2025 10:17:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95CEC8E0001; Fri, 19 Sep 2025 10:17:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84C1F8E0002; Fri, 19 Sep 2025 10:17:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 70E758E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:17:08 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 27D081606E6
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 14:17:08 +0000 (UTC)
X-FDA: 83906201736.28.219A903
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id D8600180015
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 14:17:05 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XExNOyoZ;
	spf=pass (imf24.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758291426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ticqe5qWO2L3qCYZDyiYvfuA1uJgYJW+p6eRr/13AO8=;
	b=pKsp1r3s+y+FQoIbqVTN89Sllzkpw+jbREdnkYnghgoTb5xg5TmqhrqBdAhnkI659n8Jnl
	4Z5WbiduwLHtyS+UwWomb4ABRK1X7orlw6iCJnfjQn9ttxK+lwpL9CWYDvcr4H/MbhFE8c
	zyHKitOVUJEDDoHVth1IW6+ETy0PF+Y=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XExNOyoZ;
	spf=pass (imf24.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758291426; a=rsa-sha256;
	cv=none;
	b=tfk7q9Y2i3brgB6t8U+vVV7BcRNCSBK/tDMTV/jQe/UWQBmSUQL/3zkgoyX87CWCihD6YM
	D/R2FtKzGhdb0sorpGOivLNjHw1lqNEOjL9d8tJyGc8BKlTHgwPw2tfTP9scUL2UeknH9J
	J8iU9Zo6M/UHdV8VkS42H8EWpNgUH3E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758291425;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ticqe5qWO2L3qCYZDyiYvfuA1uJgYJW+p6eRr/13AO8=;
	b=XExNOyoZXw0MyDM/vN/1U1EgwyuJ2I+2FK1BCFl9JSosoqQr7DiUEm2LRsa5LfbtXfmJHf
	MmFzbmR2QXArfNATCuboi3jcW4C1mkKJxDsK3Ska+Hnnx7o/boyrUm6+oJ0H6NC8s18dCm
	9eNo6OAlLu2YM40RS+mqRoF/7QCUGY8=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-27-MzoBuAckNweDcAiyS4QIpA-1; Fri, 19 Sep 2025 10:17:00 -0400
X-MC-Unique: MzoBuAckNweDcAiyS4QIpA-1
X-Mimecast-MFC-AGG-ID: MzoBuAckNweDcAiyS4QIpA_1758291420
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-82e5940eeefso470928285a.1
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 07:17:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758291420; x=1758896220;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ticqe5qWO2L3qCYZDyiYvfuA1uJgYJW+p6eRr/13AO8=;
        b=QkjY33m9GFwzN5RTIPrn6t86ROYZMmJkEnKRXk+hA/W++FoqGJHpa2NOCoNXDWBRAJ
         nXa7XK9p/qEB+puG5TIj4Bt6idmtfaMP/yT0M7tfTx/zwL4oU1NDUCrXO6HWFkC6hJ0l
         uHBdvAjlgNLewiq1DJszyXJmGyRRBCHynBbWduzrCMguuENwyAYysTdm+wV9H7HKYC/Q
         aYz+uccKymeUFCnlJbGMRCjCUZRF6bdFuKe7NoPrAuTveADaLssPtO1kwhwGGSywx17W
         QQfdBANsrGD4cAHBFUmPNPp4VgCnjhIpVs0tzptPLGsDfP+0wxeByV3ZM2n3K9mvYlyt
         PWSA==
X-Forwarded-Encrypted: i=1; AJvYcCVK25pNGeUFSQwxTaLyMga8lEw6GZsuvMuMVr1Dy9oWXxiGWSLq/vCPtBA9Sq0A5ALt2RLItfwdDw==@kvack.org
X-Gm-Message-State: AOJu0YyO0g1c12LbLT/+waNMyX8oAsdPDMwYajKh/1mucGEhxgS2VNY0
	hj8AnLScyUt19t4YqXTdOzpNRo6foEckc56ihXahJyaJ3Eax2o7/uWO4gNwngEXPGbdV0AVSZMV
	cUyk0Mq5ZZwztp2Fsatxjm87bUqMC50pt2VN7z+pL2XO+r1yCrpjw
X-Gm-Gg: ASbGnct90Fj4FNnsoj0IiT892SJFDl4AAZp8yj3dTFMXZn22PryvMnsJ9w/MTNE7CF/
	fNVV65I9lmud4CZYzWa1RXQVRF6M9Jjymw7xfFvtg81hXp8fShccP3MpJcgsFUTJPOM81jozYKq
	ajBxfK4EE8j2yYIV8M4kd+MDhJG+49aweNBM2h9lFcraaJSwnESyHICcUCXqiimzLfDV0QipvJD
	K7eaLmk+S3rZtP1xf+Tv7rBB3uo8KIXvC2ubYqzs4UYU5QMmSJ1otvaeOZNCgvzo4zUGBZiPuGV
	psLBNXUJEP/zg1h4Pz1I4yxjd9x/CBiW
X-Received: by 2002:a05:620a:2552:b0:829:d0e9:bc1b with SMTP id af79cd13be357-83b83bf98cfmr374575385a.7.1758291420078;
        Fri, 19 Sep 2025 07:17:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGmwp6NIoXqiqR/kixIJFbO80y7cuU3Ya0UiZpIOCrLcj+9fy9PCkWSa9mP1YicitttrWDVOw==
X-Received: by 2002:a05:620a:2552:b0:829:d0e9:bc1b with SMTP id af79cd13be357-83b83bf98cfmr374569185a.7.1758291419395;
        Fri, 19 Sep 2025 07:16:59 -0700 (PDT)
Received: from x1.local ([142.188.210.50])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-836262b559dsm352820585a.1.2025.09.19.07.16.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 07:16:58 -0700 (PDT)
Date: Fri, 19 Sep 2025 10:16:57 -0400
From: Peter Xu <peterx@redhat.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
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
Message-ID: <aM1l2YMmvBgiXJ8a@x1.local>
References: <du5pzxmfk6lile3ykpaloylwz4eni6disj2oe25eq6ipzqemiw@ybcouflfnlev>
 <aMvEu9m7fJLnj862@kernel.org>
 <4czztpp7emy7gnigoa7aap2expmlnrpvhugko7q4ycfj2ikuck@v6aq7tzr6yeq>
 <a1a48a0e-62d3-48d0-b9c2-492eb190b99f@amazon.com>
 <7cccbceb-b833-4a21-bdc4-1ff9d1d6c14f@lucifer.local>
 <74b92ce3-9e0e-4361-8117-7abda27f2dd4@redhat.com>
 <aMxNgyVRuiFq2Sms@x1.local>
 <cigo2r2x22bk7wzr6qvazcdkmt5kfqhbgb7nslpuff7djufucg@f6xucfuntz3q>
 <aMx0oGwRpSTcfdnf@x1.local>
 <swfs7qpgrezamnijhheiggwdfklfqdc6ahp5g7nvprr64m7wz5@msf2mqajzbuz>
MIME-Version: 1.0
In-Reply-To: <swfs7qpgrezamnijhheiggwdfklfqdc6ahp5g7nvprr64m7wz5@msf2mqajzbuz>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5O6iVV6CLXPKmv27dgUQphgd1BHiX6xE2w4k900RwZc_1758291420
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Queue-Id: D8600180015
X-Stat-Signature: xowdtqoh4kqttamof5ix98wwddsqgzby
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758291425-967438
X-HE-Meta: U2FsdGVkX1+IMK9ywMe7ksnMDmg5BeG6X5fiOIB0gzadokNeids1lIc51xZ1XKTLVzBaOp3zoo1G4JFpBIfCaGaGjbj2VdMlAQpu4J6PAp+6COj/06fkoD1cE0cfLzHJeL5VPxAYJgsroCDxasjEbinkXUmMjEd9LFIcG9tsyXKGIIxWHz+l6UW6g7hov30Kpy+KaT8GWFuUfLaNmhFYP5bLCJ8zzGKbejoPXj/ca0tmu51GvEzKKOQZX7jXUqpMbGAskzsMkUfE9jbKEMNvH1/IReYZ6xXMa5qpBJ2O8/Kwvcf3LhUV0sMv9ACBqgXCcw+isOKX1UF73MOMOUV77KQpzj0+u0BqO8DMnbJMAkD8nRmE6OKj4lFr3sEvkrJyDx/gEEPXRa2pURjNUlDKuNxEWTYE2LFse6I3ZmdYYYHivyhhTJPY61ZRvtieozUGolO+cmcDwX9zS876bfL/AdHbkJqzgGjG7UhVkBBsg1cdTZ4GLSzOmA2nJR78zYmRcfBHdx8ZDa//IlVJwCGqB05amSaW4EzF6evz2pG13y3B8/wtATQkIvMKKZPIkxbM4Y/cYA5URdQnuSbXuseZNseBZlryPCIRp9YqSPGir9M67XPOvNI0lGFYWnkK+WHBzebkUdh5LLNCKc50D5gl8Plz26j1sDTWkjL9oPLaVN7AQ12XnV5D/UQD4bm2ALdigEnCDy2/BguFC0Z8rZdG/aojDv5EOZi29+ohvIZaOzs1W+SL8K3QM8s3EnydNelRFgbvmx2gF6KVKOBqjTRFnt7EmOEbhR04qDg3Feb/YtS2YivpS/yypQbRFMELO9WHANNjEV77U7cHOZCrI2lMfWFofB/ZIJemoHKWvqk956+orTPSj/DYbx+xETZoxOJfvDsUjUOYfMj3o15ivp81Bb5+5CINkLGPd+SFa5zRLna2do6nkFicvxL8VgLkU7AxTVPaq5evB1Z4nOiU6Bx
 qSCwz9Kh
 YJxmwXim0krR1Rfv3ZM+yVXCnbtx+0jnzCsWSASYmK0FTz/twcMEcfvh/WyYEZEUdPJts31Ou31WH6vNsq6kVKZpfxwjidRltGpm6IvZ5/Nrvg3oUOYuUfLKgjoLYWlMXmi2FbopHS07t24FyPmXuKIpX0WL7eOp0mAUke6ZVpTL+gX6F6cGRQXwrfhdYhok09itT6+KLHinawot3MDqJb5xHhh8dsG4HwfFuHc5M71VnQzstmOm1UHElYBoqFSkW3M/eQ9rJhBAv1l1q0tr5D/eT9xqasQL/wtVx/Ag7kHCmOnVXUFV3anWQ6uFpJsPGbIP02ncU0uPtSwcvjI6OSVXVD0h22dhjUF1vam3/0mkzKpEP8m+pbI2GpI0lCDkTrELnDY41NIa9TGXbyw/SoExiw+3kEkga7jJhCmZOnvZ7pxmjr7r5eDidNMPqOIcHdtiHJTpN2WiEtedUGa+Nn4etE7ntRhrfVOUgQBMq2Vexpxv6BbvwsE06Losie+gyDabobrq22jqAzdMPuPsHZ/EHwA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 09:50:49PM -0400, Liam R. Howlett wrote:
> * Peter Xu <peterx@redhat.com> [250918 17:07]:
> > On Thu, Sep 18, 2025 at 03:43:34PM -0400, Liam R. Howlett wrote:
> > > * Peter Xu <peterx@redhat.com> [250918 14:21]:
> > > > On Thu, Sep 18, 2025 at 07:53:46PM +0200, David Hildenbrand wrote:
> > > > > Re Nikita: If we could just reuse fault() for userfaultfd purposes, that
> > > > > might actually be pretty nice.
> > > > 
> > > > I commented on that.
> > > > 
> > > > https://lore.kernel.org/all/aEiwHjl4tsUt98sh@x1.local/
> > 
> > [1]
> > 
> > > > 
> > > > That'll need to leak FAULT_FLAG_USERFAULT_CONTINUE which isn't necessary,
> > > > make it extremely hard to know when to set the flag, and comlicates the
> > > > fault path which isn't necessary.
> > > > 
> > > > I think Mike's comment was spot on, that the new API is literally
> > > > do_fault() for shmem, but only used in userfaultfd context so it's even an
> > > > oneliner.
> > > > 
> > > > I do not maintain mm, so above is only my two cents, so I don't make
> > > > decisions.  Personally I still prefer the current approach of keep the mm
> > > > main fault path clean.
> > > 
> > > What we are trying to say is you can have a fault path that takes a type
> > > enum that calls into a function that does whatever you want.  It can
> > > even live in mm/userfaultfd.c.  It can then jump off to mm/guest-memfd.c
> > > which can contain super unique copying of memory if that's needed.
> > 
> > Per mentioning of mm/guest-memfd.c, are you suggesting to take guest-memfd
> > library approach?
> 
> > We have in total of at least three proposals:
> > 
> > (a) https://lore.kernel.org/all/20250404154352.23078-1-kalyazin@amazon.com/
> > (b) this one
> > (c) https://lore.kernel.org/all/20250915161815.40729-1-kalyazin@amazon.com/
> > 
> > I reviewd (a) and (c) and I provided my comments.  If you prefer the
> > library approach, feel free to reply directly to (c) thread against my
> > email.
> > 
> > I chose (b), from when it was posted.
> 
> Honestly, I don't know what I'd vote for because I don't like any of
> them.  I'd chose (d) the do nothing option.
> 
> > 
> > 
> > > 
> > > That way driver/i_know_better_that_everyone.c or fs/stature.c don't
> > > decide they can register their uffd and do cool stuff that totally won't
> > > tank the system in random strange ways.
> > 
> > What is the difference if they are allowed to register ->fault() and tank
> > the system?
> 
> One less problem.
> 
> More people with mm experience looking at the handling of folios.
> 
> The common code not being cloned and kept up to date when an issue in
> the original is discovered.
> 
> Having to only update a few fault handlers when there is a folio or
> other mm change.
> 
> Hopefully better testing?
> 
> > > 
> > > Seriously, how many fault handlers are you expecting to have here?
> > 
> > First of all, it's not about "how many".  We can assume one user as of now.
> > Talking about any future user doesn't really help.  The choice I made above
> > on (b) is the best solution I think, with any known possible users.  The
> > plan might change, when more use cases pops up.  However we can only try to
> > make a fair decision with the current status quo.
> 
> Planning to handle one, five, or two billion makes a difference in what
> you do.  Your plan right now enables everyone to do whatever they want,
> where they want.  I don't think we need this sort of flexibility with
> the limited number of users?
> 
> > 
> > OTOH, the vm_uffd_ops also provides other fields (besides uffd_*() hooks).
> > I wouldn't be surprised if a driver wants to opt-in with some of the fields
> > with zero hooks attached at all, when an userfaultfd feature is
> > automatically friendly to all kinds of memory types.
> > 
> > Consider one VMA that sets UFFDIO_WRITEPROTECT but without most of the
> > rest.
> > 
> > As I discussed, IMHO (b) is the clean way to describe userfaultfd demand
> > for any memory type.
> > 
> > > 
> > > I'd be surprised if a lot of the code in these memory types isn't
> > > shared, but I guess if they are all over the kernel they'll just clone
> > > the code and bugs (like the arch code does, but with less of a reason).
> > > 
> > > > Besides, this series also cleans up other places all over the places, the
> > > > vm_uffd_ops is a most simplified version of description for a memory type.
> > > 
> > > 6 files changed, 207 insertions(+), 76 deletions(-)
> > > 
> > > Can you please point me to which patch has clean up?
> > 
> > Patch 4.  If you want me to explain every change I touched that is a
> > cleanup, I can go into details.  Maybe it's faster if you read them, it's
> > not a huge patch.
> 
> I responded here [1].  I actually put a lot of effort into that response
> and took a lot of time to dig into some of this to figure out if it was
> possible, and suggested some ideas.
> 
> That was back in July, so the details aren't that fresh anymore.  Maybe
> you missed my reply?

AFAICT, we made it the other way round.  My reply is here:

https://lore.kernel.org/all/aMnAscxj_h42wOAC@x1.local/

> 
> I was hoping that, if the code was cleaned up, a solution may be more
> clear.
> 
> I think the ops idea has a lot of positives.  I also think you don't
> need to return a folio pointer to make it work.
> 
> > > 
> > > How is a generic callback that splits out into, probably 4?, functions
> > > the deal breaker here?
> > > 
> > > How is leaking a flag the line that we won't cross?
> > > 
> > > > So IMHO it's beneficial in other aspects as well.  If uffd_copy() is a
> > > > concern, fine, we drop it.  We don't plan to have more use of UFFDIO_COPY
> > > > outside of the known three memory types after all.
> > > 
> > > EXACTLY!  There are three memory types and we're going to the most
> > > flexible interface possible, with the most danger.  With guest_memfd
> > > we're up to four functions we'd need.  Why not keep the mm code in the
> > > mm and have four functions to choose from?  If you want 5 we can always
> > > add another.
> > 
> > I assume for most of the rest comments, you're suggesting the library
> > approach.  If so, again, I suggest we discuss explicitly in that thread.
> > 
> > The library code may (or may not) be useful for other purposes.  For the
> > support of userfaultfd, it definitely doesn't need to be a dependency.
> > OTOH, we may still want some abstraction like this one with/without the
> > library.  If so, I don't really see why we need to pushback on this.
> > 
> > AFAIU, the only concern (after drop uffd_copy) is we'll expose
> > uffd_get_folio().
> 
> If you read my response [1], then you can see that I find the ops
> underutilized and lacks code simplification.

I tried to explain to you on why what you mentioned is completely
orthogonal to this change, in above my reply.

> 
> > Please help explain why ->fault() isn't worse.
> 
> I'm not sure it is worse, but I don't think it's necessary to return a
> folio for 4 users.  And I think it could be better if we handled the
> operations on the folio internally, if at all possible.
> 
> > 
> > If we accepted ->fault() for all these years, I don't see a reason we
> > should reject ->uffd_get_folio(), especially one of the goals is to keep
> > the core mm path clean, per my comment to proposal (a).
> 
> I see this argument as saying "there's a hole in our boat so why can't I
> make another?"  It's not the direction we have to go to get what we need
> right now, so why are we doing it?  Like you said, it can be evaluated
> later if things change..

You described ->fault() as "a hole in our boat"?  I'm astonished and do not
know what to say on this.

There was a great comment saying one may want to make Linux an unikernel.
I thought it was a good one, but only when it was a joke. Is it not?

> 
> My thoughts were around an idea that we only really need to do a limited
> number of operations on that pointer you are returning.  Those
> operations may share code, and could be internal to mm.  I don't see
> this as (a), (b), or (c), but maybe an addition to (b)?  Maybe we need
> more ops to cover the uses?

That's exactly what this proposal is about, isn't it?  Userfaultfd minor
fault shares almost all the code except the one hook fetching a folio from
a page cache from the memory type.

"could be internal to mm" is (c) at least.  No one can do what you
mentioned without moving guest-memfd into mm/ first.

Nikita and I drafted these changes, so likely we may likely have better
idea what is happening.

Would you perhaps implement your idea, if that's better?  Either you're
right, we're happy to use it.  Or you found what you're missing.

It's not required, but now I think it might be a good idea if you are so
strongly pushing back this userfaultfd feature.  I hope it's fair we
request for a better solution from you when you rejected almost every
solution.

> 
> So, I think I do want the vm_uffd_ops idea, but not as it is written
> right now.
> 
> Thanks,
> Liam
> 
> [1]. https://lore.kernel.org/all/e7vr62s73dftijeveyg6lfgivctijz4qcar3teswjbuv6gog3k@4sbpuj35nbbh/
> 

-- 
Peter Xu


