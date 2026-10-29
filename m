Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 580C0606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 00:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ohR3uX7w
Received: by kanga.kvack.org (Postfix)
	id 19CC46B00EF; Wed, 28 Oct 2026 20:19:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14E9C6B05B1; Wed, 28 Oct 2026 20:19:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03CAC6B05B2; Wed, 28 Oct 2026 20:19:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D0FCC6B00EF
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:19:30 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5EEF1A7579
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 00:19:30 +0000 (UTC)
X-FDA: 85373754900.19.7779F9C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id AF00E180003
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 00:19:28 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ohR3uX7w;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793233168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GU7Gb3GLimfKLTFeZUh6Xge/AOYd9HMwRfZdUHSCdUA=;
	b=351c32paiCMrjIP3UFNP1Dq4t/qOCTUOIW5JRgiwS8apgrfeigb7uZ6LoS69wwwwozT/0T
	77nqtftxZDB5Df+j7XVwCkapQU5ZOplCDM9f5RyjTN3tdnQeCwGgj0k1d3QSy0Qtl6k95k
	BHspbZNlRje3fRbSoZ0QML5+w1lmjC0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ohR3uX7w;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793233168;
	b=ZPPLfPPZXvXwb0609EpNDpU7ckjekiet8BU8Jfidrw8GgMXeslP/jZWvOzsV9ztUb/5//x
	0ogftwBXFv3B84xikGqljO40j+lYYzuAcF0/rnM7wYwM2o5ctzhSChuOr1ODeQznhvUTiY
	NcrZy3jJdV8eTzbl64xN7hIqMHLF0sE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 990514071A;
	Thu, 29 Oct 2026 00:19:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2881E1F01825;
	Thu, 29 Oct 2026 00:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793233167;
	bh=GU7Gb3GLimfKLTFeZUh6Xge/AOYd9HMwRfZdUHSCdUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ohR3uX7weE4E0JafS6YBZO4ZKoCy6PK+GGlCc+DDD1vXXdFOppaZrcuc+Duf1bUUW
	 G5yCdo83B+NdZ2HDqz/uhRIhXS1SPF3fmOxELysSXn1N3LUl2FMbyslQW8oN8KTPVE
	 XGsa2KWyu6KZlHdQoc+XIaSHHlO6poF06gOnt9/9057jrug7r8htJAsHmkBQcTd6yV
	 HKh3hl8A7whynE82pK3aNxX2CSbjcVGyoPIha2pEWWOAbmdVDNvX/zK587kk32/PkY
	 EecpCI6DuRlQ7PO4+4OUUjsoQ2bwTIIhFVWubQb3wEBk6Nb95N4rV9KLddCRvfvdu5
	 ppGEL8nR77/4g==
From: SJ Park <sj@kernel.org>
To: Manuel Ebner <manuelebnerli@mailbox.org>
Cc: SJ Park <sj@kernel.org>,
	corbet@lwn.net,
	damon@lists.linux.dev,
	jm5905938@gmail.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	rdunlap@infradead.org,
	skhan@linuxfoundation.org
Subject: Re: [PATCH v2 1/2] Docs/admin-guide/mm/damon/reclaim: improve grammar and style
Date: Wed, 28 Oct 2026 17:19:19 -0700
Message-ID: <20261029001920.166896-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <1303b843e41498612cce4acdbb47941c054bcf7d.camel@mailbox.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AF00E180003
X-Stat-Signature: yqapt4h3yi4gwg7kj96493iawkuoih54
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793233168-277902
X-HE-Meta: U2FsdGVkX192E0mMPw+XhbGrV2Xh4wj1bl1xuaoOz71aZ4oDIryv9TEnEy9doOc3MZuzI93W/NetNUuLKpoFCvS/bc5FsZxHqq8ApWnJjgfw+VGNF30KNc5/3VJrjd+LHb8CvJuiXv6Jetnhu9uKtkVOh59uc6c2v8z5Tpg49h9yL9zpfMRj/M9PAUyUO34/mQ5si8iNTX2Bp+aT7EfHba7MK9RVMdZNc2fty/uT2G44J2tiFGiY2WdS/P/06vgUiPGZze923u7LT0UV3bTJPT2mpENLWv6Ic17iT47O7Nruh6H6tvafFiJCB87dWalQ/A+72gAgT4yFIy1oR/rE4k9NU1rUQj5ZQR1jD3GBLQ/TIuYO6nfoz5rXs+QSMbmEHeC2qQHEyrS+wYGpuHGvDG4wVjYoEJRaArdzdtuYJA7CO2VKREA/6pqrmvO3oy5L6aTCcq8CAWaF0dRoA60C8VAqYJXxZLn5KWu9sbPSnKam7yTc/CXikh9ndivkzvUUZQRIUReTzgL2c8TQNZz4cyst2HVNc+56sJiGwYj9HlFWL3qWhZ90/kQVjhY3RrTimh6l38sY6zqlJ327TZKk8l+b+gkETzMPFY5Fyukd6ChTPJl2Q1BpOGkf/gKw0PUmF56ZdQ/hPLr+TTfS5MX9MXJWaOQEeEuXpBRPgMNEzqCR0XTxCGPZK4Ky2PYSP4SaxE11aQq18C67G4OlWZ4MNOkXwU3zIRQUMtk7ODQ1QT/DWBF0zS88A+sQRbCUYMkSa4QVYOUIWjHKX2ljIscinFV2/YSZKNHU8zubhVTqwnij6pqmPsXYZJEErIAnHAqru8rXxSpW2u/EMogWWXL7+AjX9XeY3AzV78OoRCDxDvDbvAXTiL75E8a4FCoo1OV7WsdQU/YYabMXK+wWmFUufHMl1z05Qtjf0lhmEXSlR/0lGx0W3FfHYxnvbi3jByELxc9op1gcif+IPXoqG8X
 KVjyT+ym
 lDaA+PhICmp0PXIBUJ9BtthZwnwIsnqfIRlYWAiF/+J5cZbd5EBsDUwo65AT9qH3JyJgregw0z1cfd/4xnEf1SEfho3BvTThXaptoqt576d7Wms2IHMYRDc4ZPy8UtLP8gjE5Q2mt7Y76L4nrz/0BItqUeVSjbrDVmXsnOq+7Bb9QxHMQ4gtTGhRE+49EPOQ/GaKBxg4NlDneINOeigiEIErj7fobrkZ9HXPqDLpsz+oJAaQYXggcS+NzDPV0LQV2l6Zp3Q4dC1GAZ77NNSqEo7ipc8qRY/hFmyq4qOCxt55+gX90E2mBA/OrUad+//LTSooFcdRa6VxlbJk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 28 Oct 2026 17:52:01 +0100 Manuel Ebner <manuelebnerli@mailbox.org> wrote:

> Hi SJ,
> 
> On Tue, 2026-10-27 at 17:06 -0700, SJ Park wrote:
> > On Tue, 27 Oct 2026 20:05:04 +0100 Manuel Ebner <manuelebnerli@mailbox.org> wrote:
> > 
> > > Fix upper case. Fix tenses. Replace 'set as' with 'set to'. Add space after
> > > sentence to make it double space.
> > > 
> > > Signed-off-by: Manuel Ebner <manuelebnerli@mailbox.org>
> > > CC: Aveline Noir <jm5905938@gmail.com>
> > > ---
> > > @ -113,8 +113,8
> > > Choose as you wish.
> 
> I will refer to this below.
> 
> > > 
> > > @ 20
> > > should be:
> > > -Free Pages Reporting [3]_ based
> > > +Free pages reporting [3]_ based
> > > or
> > > +'*Free Pages Reporting'* [3]_ based
> > > * the right kind of quoting/ kernel-doc highlighting.
> > > Choose as you wish.
> > > ---
> > >  .../admin-guide/mm/damon/reclaim.rst          | 36 +++++++++----------
> > >  1 file changed, 18 insertions(+), 18 deletions(-)
> > > 
> > > diff --git a/Documentation/admin-guide/mm/damon/reclaim.rst b/Documentation/admin-guide/mm/damon/reclaim.rst
> > > index e4e2ffa52e..0bab2299ea 100644
> > > --- a/Documentation/admin-guide/mm/damon/reclaim.rst
> > > +++ b/Documentation/admin-guide/mm/damon/reclaim.rst
> > [...]
> > > @@ -30,12 +30,12 @@ guests could mitigate this problem.
> > >  How It Works?
> > >  =============
> > >  
> > > -DAMON_RECLAIM finds memory regions that didn't accessed for specific time
> > > +DAMON_RECLAIM finds memory regions that weren't accessed for specific time
> > >  duration and page out.  To avoid it consuming too much CPU for the paging out
> > >  operation, a speed limit can be configured.  Under the speed limit, it pages
> > > -out memory regions that didn't accessed longer time first.  System
> > > +out memory regions that weren't accessed longer time first.  System
> > >  administrators can also configure under what situation this scheme should
> > > -automatically activated and deactivated with three memory pressure watermarks.
> > > +automatically be activated and deactivated with three memory pressure watermarks.
> > 
> > Let's keep 80 columns limit.  Same for below.
> 
> Okay.
> 
> > [...]
> > > @@ -113,10 +113,10 @@ quota_sz
> > >  
> > >  Limit of size of memory for the reclamation in bytes.
> > >  
> > > -DAMON_RECLAIM charges amount of memory which it tried to reclaim within a time
> > > -window (quota_reset_interval_ms) and makes no more than this limit is tried.
> > > -This can be used for limiting consumption of CPU and IO.  If this value is
> > > -zero, the limit is disabled.
> > > +DAMON_RECLAIM records the amount of memory which it tried to reclaim within a time
> > 
> > Didn't we agree to keep use "charge" ?
> 
> I thought we agreed to "records' but I sensed a misunderstanding. That's why I wrote
> > > @ -113,8 +113,8
> > > Choose as you wish.
> above. Should i have been more explicit?

Sorry, my bio memory easily be stale.

Anyway, my impression was that we agreed 'charge' is not really difficult term
and therefore keep using it.  Maybe you were saying that only for the paragraph
we discussed about if the term should be explicitly explained.

If you don't mind, I'd prefer keep using 'charge' here for consistency.  What
do you think?


Thanks,
SJ

[...]

