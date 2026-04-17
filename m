Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D810F8E499
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 03:49:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BF5C6B0005; Thu, 16 Apr 2026 23:49:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 771DC6B0089; Thu, 16 Apr 2026 23:49:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6895B6B008A; Thu, 16 Apr 2026 23:49:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 569026B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 23:49:42 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CA2685B6E1
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 03:49:41 +0000 (UTC)
X-FDA: 84666668562.14.9496FAD
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf25.hostedemail.com (Postfix) with ESMTP id E7E5FA0002
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 03:49:39 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dn5FryAs;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776397780; a=rsa-sha256;
	cv=none;
	b=0uY3ggYj/dbO0nWkYBl3TM/UUJbBgHG07U9Zi3DumYVBFFax8OmHGnJMbO1MM4n12xyVGu
	H56O7N0XXJ5qzbRQzbZOHVwI5yXVsf59s8V8dYI6qnAwf9PKIJEVQKYLse2s4efrnMgWYj
	rxMURvK35VTO0z/t1zw54lEQ7eexuKM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dn5FryAs;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776397780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EOIYn6Vs3t3hB4T19aQ0W0U21onG5fYSXjKIJbShOas=;
	b=iw2dKHaEQo4utddfGTu+dm+8maeODPOplAFPHFXkI6ICy0LclxmCHMMzDnSp83r8ZDV73E
	3/lgJUAc1abIh0mto5CWfnHFCX2OcCGFpTS6Xx2sqm/G6nSSvyHYCuyutouU7ZixnOLERi
	jsJ6A/1KaVJhVOFBy42GfP1lmEC1ogw=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-35fc0d7c310so174684a91.1
        for <linux-mm@kvack.org>; Thu, 16 Apr 2026 20:49:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776397778; x=1777002578; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EOIYn6Vs3t3hB4T19aQ0W0U21onG5fYSXjKIJbShOas=;
        b=dn5FryAsnjw2w0z2apzrLBtw7t8bEwnEsUP/GNdpfIvIeAmFaeoj8AXBelhrfphe9O
         BhwY0ji7l08fT8zrHvuFvTJ28SupPbCbTuoRhUSCmMLTEgCEE2YgCmXRZ23X5P+Ihh9K
         flbSBbl63Y+i4r4WFZT3omFmNNDfPOVnB6OQzR495vwQJQMfg61G3xfTPsfqQoMak/9H
         ijp08SaLn5zDr/Bmh8Xg3G+DZ31ZXmU5u7BfGBFVZXmVcbig9c7Iyi0MhLgsDlHYarV/
         J7EK584NBzf+s2zSPYgyG1ZjGpgcGI2cyKA9Sxmwsv0Oh3aM6dC+4eLq4AF2Q2aMtFsu
         0R5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776397778; x=1777002578;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=EOIYn6Vs3t3hB4T19aQ0W0U21onG5fYSXjKIJbShOas=;
        b=bIDAzfHweGiJtSps3ZqKr/8sYLeEpcfpC+qYt539SrwoGUOXnH1H2kg3fdTMYnV3ST
         J2HSx32xVFhFLFbYPK92VNcvC+fHahM2bxukAhw2CYiupTjKfYhroL5ykG48COsM1sgS
         VdbiT49GxbsueNju30DI8clKLuomIN6ydEJ1RILrZKp1E07oY63h+KjH9BbTDVyus33c
         w9VCMl6p7X3UJOeB7zc32kHwOk/mxiF+LWac9oiktvqjOta3Fv1s7RhIfPWPo3wb2vo3
         kr/095YsJEVWzoYlC2JZ47X57MqBIpWC67Dpex55Y0+euEx5nIjs+AT+CIzzOVL7yTLn
         /6dA==
X-Forwarded-Encrypted: i=1; AFNElJ8yt1Z3JYZAwW04byHskC5MjveuJNaJR1dU8dt+kDed1jfskAa1v5ygvRMsqy2ayZ4YS60M3t9PLw==@kvack.org
X-Gm-Message-State: AOJu0Yy03dBwzjbghMf28rD9XOZj0XRQExVBWfBcim9dW5A2miuW/5xI
	MYb2xl4cfYAhKrkFccXDHk9nRSPZEr95q0qDU+WboZYXqVY5cgAczq40Zi0QqS8a
X-Gm-Gg: AeBDieu/KyYVbAlFOVNqbcsoOq3TbX5GU7d97hotRd7sJqshvqXsUdJZ6PIOyvgx0/w
	j+Q4n2FT2nNwDP575SF4aYpapL9YRzXiZehGCTiBtugtL4gCHDiaiBYLvSGgPpqqchEMh8XV4L+
	Dsjs4SG5rxPnBUNeCVuA3XnPZ1t2bVDapK4eTFggwv2nW3ZdWRZ1uuPatoTiI+XjcOhL2f+MNBF
	3BvfatIEP+2nVUErVk6J+pA1tycNjLDeOBu7k8LF0sX+qSazjzOClQWh1Xtym3wy8tboemI1pgw
	ROnLdKD8sTnK0cW23Kc7fVslzVUvFjmbHqGAhyHurEvTMq7zZBH0FCob7wBb+jDvUGGTfQBfYPU
	yLIJRUzdr0rGAPes7nb9S+o7H9kGkgsXFHE9acdX1L0eHC4EjxdiHs++EnMc7FWDjYpUd9/LNSA
	ou5/XQOuWpW+Rki6detjtdyTglmEn1q1FT
X-Received: by 2002:a17:90b:2e90:b0:35b:945d:752a with SMTP id 98e67ed59e1d1-3614046e0b8mr1021853a91.17.1776397777891;
        Thu, 16 Apr 2026 20:49:37 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36141868906sm392590a91.3.2026.04.16.20.49.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 20:49:37 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Jeff Layton <jlayton@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew
 Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Mike Snitzer <snitzer@kernel.org>, Jens Axboe <axboe@kernel.dk>, Chuck Lever <chuck.lever@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 1/3] mm: kick writeback flusher instead of inline flush for IOCB_DONTCACHE
In-Reply-To: <52b81c4d1fb2ad0e07b3b3b4dfbd3d36e8ee3e7d.camel@kernel.org>
Date: Fri, 17 Apr 2026 08:25:52 +0530
Message-ID: <ik9qthvr.ritesh.list@gmail.com>
References: <20260408-dontcache-v2-0-948dec1e756b@kernel.org> <20260408-dontcache-v2-1-948dec1e756b@kernel.org> <tstklxm7.ritesh.list@gmail.com> <52b81c4d1fb2ad0e07b3b3b4dfbd3d36e8ee3e7d.camel@kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Stat-Signature: 7brhgfcsrq4ab39mdoqiqzx89ccn7ggt
X-Rspam-User: 
X-Rspamd-Queue-Id: E7E5FA0002
X-HE-Tag: 1776397779-727859
X-HE-Meta: U2FsdGVkX18QMRiXZAs6UXaeEqw6L1OMqbklSQ/oMadpyDjj4F/xULBcdwwOvPZG0K/cmSF9rM0Jvsbujqp78X+C5gwp2mYtn6iyXS/KXm0tVU7IAZ1bsSkqVtiwzvZc6v5890k2ch/oCK/WM8UPhE/vCX3NNivdplikobDdprq/rsAJ0ILl39iVgBovDC4/SMVXMHAxitnUPd3YgDK/uLVauuFct0rTNgZJpNIM4X72L2u2i87x+d3b46TsJSdP43UAmt1Vo3teGFUR9igd+6ktCTjUk3N8BwLTfhoPKAqx1JMHDalGCw6TySrgMBJBmIK+qk32Zf156pZPSyNaLt99C52cWfywEuqs17HNkR7jU3S7f7ZSjTnaBi+A+6+yWjRAB9FDr1lAE7Gi8Xm21cbu/SIN+aQPHmKSqYERTI6UouO5N6B79GeUvoszi8h1x1t//iEvZJ18HzOAMn7RFAeU4MkpX06WKmhez3WS/wj7424PXLv/k8Ui4AaBoMLUwQryAcHU3ePKyNVoNDkulw6JTUQXDeW3ppVHHY53wFEerz/RS1JO+cZjMDCYqihyz9tSCZsfMnJlkCYKhJgkVKG/KEqzRcxXlb3bNB68kjTWbgFLoaNMVAMko1ygCDUwepNKImxnmSZ28h739M5zQvqqOYu1Dg6aSvYyFFA/V+i4bYh6f/+NvbtPHwpv2cAj3aLTrGblH/QzihDg4QSpp/57YSKdoVuD9rlEAo4e/8FUH4rHXi96E0KtaHImRRiCkKQbIMUHO0Q/Kp35CI7Vrrs0UHsEipsQBRHjaHnI2l5oj8o0vxi/xAe87QF+vfKGIdZJsqitsYKHCrjCB8H4mzxmwPR9NQkg1LdvTPNCc4UPqaYA1vi+uJspfo3hNkuh2zRAq/XwyUt3TLqMX/eVjwvxs3LslFw4RTZm42CkJ2ZS/OFhLxLe304xnP5xV/hBMEqsBNcb/1s1K83NHtT
 n4Decey+
 X0ip9r4pwb3WworUYZnjkOsdY5doXF61xh0MJM489qGhmd9rHBE4YjIe3UI3tKvhXc66SqisR1NF/n4UGG98NQ1TfCMXwnC+lky9HML0iV0WwsXFJqFisXhh/ofvfmJ4V8/XZeLHFdDy+ju/hCwtdKOPOTDGfPvGor7zsLm9OQxIYPJX9Fvpjia26WwTNb1YHK7YmdNumGrxsbQlOFqBHbCvdxh/iXNId7H7wKMWEdG5pIBzk0zZxORfRzUN50IpukXyYG3jTGcXSRb42lrgNlvHgvOSVjBG+H+6o6zsTlytcmvROlQaY/nVijirCXuV8ozohAyVTKYv9Avh3euGaLkN/pGbGrtVtSzTlKC4SUbDXE4FL5w/dzhHRITVeHb7nkcqawOOFKag+lhEg6ZzBx0BIp4xhQWg7aXFzwVwt+o9lNJAEAxfA4vT3yfO4ReblLGkRLK5QqRgLNMjnzW8sJqCb4Bsu+UwmPj8zXBmeLxek0iF1G5WQxwU/pdpc7MAebGrYPyKrY/EsS5U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Jeff Layton <jlayton@kernel.org> writes:

> On Thu, 2026-04-09 at 07:10 +0530, Ritesh Harjani wrote:
>> Jeff Layton <jlayton@kernel.org> writes:
>> 
>> > The IOCB_DONTCACHE writeback path in generic_write_sync() calls
>> > filemap_flush_range() on every write, submitting writeback inline in
>> > the writer's context.  Perf lock contention profiling shows the
>> > performance problem is not lock contention but the writeback submission
>> > work itself — walking the page tree and submitting I/O blocks the
>> > writer for milliseconds, inflating p99.9 latency from 23ms (buffered)
>> > to 93ms (dontcache).
>> > 
>> > Replace the inline filemap_flush_range() call with a
>> > wakeup_flusher_threads_bdi() call that kicks the BDI's flusher thread
>> > to drain dirty pages in the background.  This moves writeback
>> > submission completely off the writer's hot path.  The flusher thread
>> > handles writeback asynchronously, naturally coalescing and rate-limiting
>> > I/O without any explicit skip-if-busy or dirty pressure checks.
>> > 
>> 
>> Thanks Jeff for explaining this. It make sense now.
>> 
>> 
>> > Add WB_REASON_DONTCACHE as a new writeback reason for tracing
>> > visibility.
>> > 
>> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
>> > ---
>> >  fs/fs-writeback.c                | 14 ++++++++++++++
>> >  include/linux/backing-dev-defs.h |  1 +
>> >  include/linux/fs.h               |  6 ++----
>> >  include/trace/events/writeback.h |  3 ++-
>> >  4 files changed, 19 insertions(+), 5 deletions(-)
>> > 
>> > diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
>> > index 3c75ee025bda..88dc31388a31 100644
>> > --- a/fs/fs-writeback.c
>> > +++ b/fs/fs-writeback.c
>> > @@ -2466,6 +2466,20 @@ void wakeup_flusher_threads_bdi(struct backing_dev_info *bdi,
>> >  	rcu_read_unlock();
>> >  }
>> >  
>> > +/**
>> > + * filemap_dontcache_kick_writeback - kick flusher for IOCB_DONTCACHE writes
>> > + * @mapping:	address_space that was just written to
>> > + *
>> > + * Wake the BDI flusher thread to start writeback of dirty pages in the
>> > + * background.
>> > + */
>> > +void filemap_dontcache_kick_writeback(struct address_space *mapping)
>> 
>> This api gives a wrong sense that we are kicking writeback to write
>> dirty pages which belongs to only this inode's address space mapping.
>> But instead we are starting wb for everything on the respective bdi.
>> 
>> So instead why not just export symbol for wakeup_flusher_threads_bdi()
>> and use it instead?
>> 
>> If not, then IMO at least making it... 
>>    filemap_kick_writeback_all(mapping, enum wb_reason)
>> 
>> ... might be better.
>
> I did draft up a version of this -- adding a way to tell the flusher
> thread to only flush a single inode. The performance is better than
> today's DONTCACHE, but was worse than just kicking the flusher thread.
>
> I think we're probably better off not doing this because we lose some
> batching opportunities by trying to force out a single inode's pages
> rather than allowing the thread to do its thing.
>

So, if I understood it correctly, Christoph might be talking about a
different approach here.
Instead of kicking flusher thread to writeback pages for a single inode,
if we can track the number of dontcache pages
(get_nr_dontcache_pages()), then we can kick the flusher for those many
target pages. I think this way we are still reducing the dirty page
cache pressure - the problem which RWF_DONTCACHE is supposed to solve.
But I guess, that doesn't necessarily always mean that only dontcache
marked folios will get written.

If we implement that then, this should still help with the batching
problem you mentioned and hopefully should not cause a major regression
for the workload which Jan mentioned.

Feel free to correct my understanding here please.

-ritesh

