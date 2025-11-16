Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71370CD4F3E
	for <linux-mm@archiver.kernel.org>; Sun, 16 Nov 2025 08:11:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3588B8E0009; Sun, 16 Nov 2025 03:11:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 309A98E0005; Sun, 16 Nov 2025 03:11:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21F228E0009; Sun, 16 Nov 2025 03:11:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0FB328E0005
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 03:11:58 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9362A89A72
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 08:11:57 +0000 (UTC)
X-FDA: 84115751874.29.4EC1A25
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf08.hostedemail.com (Postfix) with ESMTP id B2749160004
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 08:11:55 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=fromorbit-com.20230601.gappssmtp.com header.s=20230601 header.b=lCh9Jlwg;
	dmarc=pass (policy=quarantine) header.from=fromorbit.com;
	spf=pass (imf08.hostedemail.com: domain of david@fromorbit.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=david@fromorbit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763280715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HxFwg3ju+ftuSMqIiYAdOOvZ0OAIJu2EJhRRFE1j4DA=;
	b=5Ba4/1WFWcZHNcsxwqtx3gafxXnUWzPCLFeGVpkPaz44l1D+FfNAO3OT79mLAUu/oXJqkO
	hS+7LkegrFfpauOovNp+0cI1WRPE02KCpGWejqDUch2arBJMh0ET48h9O+RQfDLUXSdR60
	ACHWZcRdv8IWQTdFTqdQm1jyOlACdRQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763280715; a=rsa-sha256;
	cv=none;
	b=sCJL7kz9haiJ0yLNctcb5Pz0fnBTZoobf83JgzKyAWS2VPjmCcCm33VVHwbF/LCxyhyuNf
	qJuzfWZsvcIbdKFErAIvtB1NL3wwI6CKu3rPwffpxXUf/TT4MtNJfT5+WDwdk3Qg7/kkCA
	aGtEupOu3d/M3cRgN9lActGF9SdKg74=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=fromorbit-com.20230601.gappssmtp.com header.s=20230601 header.b=lCh9Jlwg;
	dmarc=pass (policy=quarantine) header.from=fromorbit.com;
	spf=pass (imf08.hostedemail.com: domain of david@fromorbit.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=david@fromorbit.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2958db8ae4fso31138965ad.2
        for <linux-mm@kvack.org>; Sun, 16 Nov 2025 00:11:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1763280714; x=1763885514; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HxFwg3ju+ftuSMqIiYAdOOvZ0OAIJu2EJhRRFE1j4DA=;
        b=lCh9JlwgV5Js8CDxQzSDNdNqgBt3BDLtnKdsYtmPviOtzoaZGzpQ5varER1rmlvj8N
         VwkTRxeo+hMznpZEWEZvAftB8D7YY9+JEZVOKcXNlNrYbvhF5tVsl/XjHJXFHaQiD2XQ
         yyXLGN77lcMj4fjJmrF++Kjq5aEcd0DVJAJtppLZpbYcODbs6FI4JuqfWweeLShNHdqN
         LzwtuJRKh7YQWqxPwIoq2GqyG3fPqzSUHJbAQ1Uuxmni8yyMc3aIF9cubUcE5+Rueacf
         OA3bDAEgoeQCMjsnNkmEayVLlbaZSg535yByeRYumM0WuNBMaGX/CRoQQKica9E2n3mj
         of2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763280714; x=1763885514;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HxFwg3ju+ftuSMqIiYAdOOvZ0OAIJu2EJhRRFE1j4DA=;
        b=oY5kxtqvPG654IdG//176VtjgjCmFPTcWycEOmB7f0JqmgDb6fIkTdv+jDkv5xI+xA
         EqZ6c9wNUNlK59OOxQ0o/LSU57PSh1K3XwZNS0AfyfwK+Q2/Xeuar6xUdYPsSAWyvoWU
         Pd2PqmquF7s7eBhWaEj9XVZIK5G1C0nT9bZpSA6QMp7uLqo4eEdup8Vnsq/GSfsBHmLO
         4lG/+l6j5zk64RrIDSofuRNuzZ/F2InYkMK73CnTvZH0w17y5Syf9JCBwHS6bXX50EKx
         ZkvMLn8rBiQ/KcH+HThq6UuEg/NllRxZ8woSdiqL12JkZIHv9NhV1rLHup+TGCOYLpwr
         WBWQ==
X-Forwarded-Encrypted: i=1; AJvYcCWi4S/IOdMtipxKkLB6tNG9JYhXaLMZ6ZxbnDdFUHcRDwz7tlXbctCvnfdlxzgTMkETzRUjTxtlKw==@kvack.org
X-Gm-Message-State: AOJu0YwiIQ6hDwkqoKpxzXol1HX7fz9j2+ry7MMcQyEBMEhrOXaevxO3
	7oLpqkTORfljV+xBhDA/KwFYSKTJB760WjMjZ6LYhX1i6aQko+UJB1oKCD5/C8JaoJA=
X-Gm-Gg: ASbGncvci0zNAjd1TjDSpQ49UWwnQiTq0JkwpGpGW3y+hBqBxR5S8nIi3ESom4cJ8ty
	yOW2161CuPQ75uPZmJ6qTpQuDnkzhIPtsQ+zUZj8guSy8gSRVfrZD4XAaBtO3z6JIjuIt5PxcxI
	Xd5/wlusKvvgzRNhtyrEEr4G3yQAa9iv/ZlDVpQoesXWm///3RgkdbsYRJ+WHWQivT7klkoKRRN
	8b1zICVgQ6siSo1fAkht7qxKUrAgbGUYkb3pd7qx6g3f/0lY1ijg9Q1BhVJ++QwBV6Ci2nt8PvB
	9u3iOXcwAz9i81JPvkQpeVmPbCq3lgJSyi3Kk2U1H1T8zJB5RyITE8EYYiEsY2+v6b8Oi3HDVH5
	E2d47tPVteWt7QTsKJbm61F1BGd+FdoWgWKqttHWi/JGJIMja5qPFaSqZcVVq8mCjG6YXGdZ/Dg
	Cyxh/LYoVp9gZNIfL9Quw2RSwzd8c+eobTz8QuDrlV/sJBWu/iPmE=
X-Google-Smtp-Source: AGHT+IG4zTCgOyc8q36N6azv8U3/msRqtiTIPYqJrKFmmGWBG01OEhj/Rfjn+kBTPtApfo/xiU3cYQ==
X-Received: by 2002:a17:903:230a:b0:295:94e1:91da with SMTP id d9443c01a7336-2986a73b093mr100196375ad.33.1763280714289;
        Sun, 16 Nov 2025 00:11:54 -0800 (PST)
Received: from dread.disaster.area (pa49-181-58-136.pa.nsw.optusnet.com.au. [49.181.58.136])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c234726sm104981205ad.8.2025.11.16.00.11.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Nov 2025 00:11:53 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1vKXrS-0000000BUZh-0XuM;
	Sun, 16 Nov 2025 19:11:50 +1100
Date: Sun, 16 Nov 2025 19:11:50 +1100
From: Dave Chinner <david@fromorbit.com>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: Ritesh Harjani <ritesh.list@gmail.com>, Christoph Hellwig <hch@lst.de>,
	Christian Brauner <brauner@kernel.org>, djwong@kernel.org,
	john.g.garry@oracle.com, tytso@mit.edu, willy@infradead.org,
	dchinner@redhat.com, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, jack@suse.cz,
	nilay@linux.ibm.com, martin.petersen@oracle.com,
	rostedt@goodmis.org, axboe@kernel.dk, linux-block@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/8] xfs: single block atomic writes for buffered IO
Message-ID: <aRmHRk7FGD4nCT0s@dread.disaster.area>
References: <cover.1762945505.git.ojaswin@linux.ibm.com>
 <aRUCqA_UpRftbgce@dread.disaster.area>
 <20251113052337.GA28533@lst.de>
 <87frai8p46.ritesh.list@gmail.com>
 <aRWzq_LpoJHwfYli@dread.disaster.area>
 <aRb0WQJi4rQQ-Zmo@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRb0WQJi4rQQ-Zmo@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
X-Stat-Signature: 5776jippytiziabtshw5yoia7s7xt43t
X-Rspam-User: 
X-Rspamd-Queue-Id: B2749160004
X-Rspamd-Server: rspam10
X-HE-Tag: 1763280715-71542
X-HE-Meta: U2FsdGVkX1/DVOWLQoTT5nKyNE4KUbS1/1cd/7KVovKHUAT3cEgEj99NTkY4Ysva25yvMLgp/c9cjQJ+jyArhPiv6RmD/hjjJEvB/8J4zWXqURrAg0ybJs7uPxhivVqNHvVToA1nnHekB06jkRaheYORs/cYIrjRCXBYAxc/KdeoFd2rXUHmNdfjM+BIEAJ6QanurXafvTU3SKRXtOIPKJbm0XikTokI/ftohs1bunqb9Tl6tkyhb79gOn0rNFpOesYAVL+bI4QyDPE3K4C8Uz7OELM1O6tUiNU4K405p4QUSrGnfS1K7nBcnQ0qxsj2IdCxyRETVVdUxFVCMfuNkEjnb2X+ZfJ3nInY6c7Iq2ybBAlsJCyTxB073GQ5vYj12lvABUWUxR7C5Im5q6m80sI8ik8S2g9+S6h5u7rUMpEziZkQhhPf1lRb+8S3tj/fBAMp/9FhzYfjVAvFBO3gFeDuZTgamwur4RCCAd+lsaBiKz4GwMXi3n2qcFor3Se33Ezq580Rw++HaqugqfOqBsLvIcWYnh9LPlgzsHtPLPQOQmxLAH0Z5af0fnd57HpzKhl8Mrepix6r+xrK9LjBGvtKW9pErYTBjemhu0mPKn/jufgtsr+KLBdBWdgF3J0XYtMW2UsnWK0sHiWz03X2/UVnZ5sxVJhN0Vn11Oh9aKiQWdCxUFUSaiqIyzlKpv8xuUgi7AusBOevbGapHwZU4jYIq7tOnkWtELwz2r6LD14U9TCYe+ylnYAllgkFXqZoaX0yCLPt8i/kwfnG+rPdjQnxaD+DINw17lgbmEd4XcNiFour4todNwujfzVgURw+y3tBvxgGTPlSlbsxjRQUjX1oE2S4ZPbl8GPn1sVqWsi+f5TDbBmek+gRHN8OJg6GBg4prHl9T2wZ+mZG2FiC+Wd4oU+rhH2Sn1JygSSUSA706V4IwDf9ngKqtMIBslOQcCywlWNngH1WHgDjYPo
 R3A8KvNl
 69jY4Ye5VZ9/B1Z4oshrAp8kGNlSnEUQqiOI0SFXkX5z46HzdUp3lwibS5I89VBp7ZDYaoJRsSSiVoapxEihG1grROdrGwnSRzXGTzE7rHs3VXmiOUJB9lpBy2jRkhkDhINQm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 02:50:25PM +0530, Ojaswin Mujoo wrote:
> On Thu, Nov 13, 2025 at 09:32:11PM +1100, Dave Chinner wrote:
> > On Thu, Nov 13, 2025 at 11:12:49AM +0530, Ritesh Harjani wrote:
> > > Christoph Hellwig <hch@lst.de> writes:
> > > 
> > > > On Thu, Nov 13, 2025 at 08:56:56AM +1100, Dave Chinner wrote:
> > > >> On Wed, Nov 12, 2025 at 04:36:03PM +0530, Ojaswin Mujoo wrote:
> > > >> > This patch adds support to perform single block RWF_ATOMIC writes for
> > > >> > iomap xfs buffered IO. This builds upon the inital RFC shared by John
> > > >> > Garry last year [1]. Most of the details are present in the respective 
> > > >> > commit messages but I'd mention some of the design points below:
> > > >> 
> > > >> What is the use case for this functionality? i.e. what is the
> > > >> reason for adding all this complexity?
> > > >
> > > > Seconded.  The atomic code has a lot of complexity, and further mixing
> > > > it with buffered I/O makes this even worse.  We'd need a really important
> > > > use case to even consider it.
> > > 
> > > I agree this should have been in the cover letter itself. 
> > > 
> > > I believe the reason for adding this functionality was also discussed at
> > > LSFMM too...  
> > > 
> > > For e.g. https://lwn.net/Articles/974578/ goes in depth and talks about
> > > Postgres folks looking for this, since PostgreSQL databases uses
> > > buffered I/O for their database writes.
> > 
> > Pointing at a discussion about how "this application has some ideas
> > on how it can maybe use it someday in the future" isn't a
> > particularly good justification. This still sounds more like a
> > research project than something a production system needs right now.
> 
> Hi Dave, Christoph,
> 
> There were some discussions around use cases for buffered atomic writes
> in the previous LSFMM covered by LWN here [1]. AFAIK, there are 
> databases that recommend/prefer buffered IO over direct IO. As mentioned
> in the article, MongoDB being one that supports both but recommends
> buffered IO. Further, many DBs support both direct IO and buffered IO
> well and it may not be fair to force them to stick to direct IO to get
> the benefits of atomic writes.
> 
> [1] https://lwn.net/Articles/1016015/

You are quoting a discussion about atomic writes that was
held without any XFS developers present. Given how XFS has driven
atomic write functionality so far, XFS developers might have some
..... opinions about how buffered atomic writes in XFS...

Indeed, go back to the 2024 buffered atomic IO LSFMM discussion,
where there were XFS developers present. That's the discussion that
Ritesh referenced, so you should be aware of it.

https://lwn.net/Articles/974578/

Back then I talked about how atomic writes made no sense as
-writeback IO- given the massive window for anything else to modify
the data in the page cache. There is no guarantee that what the
application wrote in the syscall is what gets written to disk with
writeback IO. i.e. anything that can access the page cache can
"tear" application data that is staged as "atomic data" for later
writeback.

IOWs, the concept of atomic writes for writeback IO makes almost no
sense at all - dirty data at rest in the page cache is not protected
against 3rd party access or modification. The "atomic data IO"
semantics can only exist in the submitting IO context where
exclusive access to the user data can be guaranteed.

IMO, the only way semantics that makes sense for buffered atomic
writes through the page cache is write-through IO. The "atomic"
context is related directly to user data provided at IO submission,
and so IO submitted must guarantee exactly that data is being
written to disk in that IO.

IOWs, we have to guarantee exclusive access between the data copy-in
and the pages being marked for writeback. The mapping needs to be
marked as using stable pages to prevent anyone else changing the
cached data whilst it has an atomic IO pending on it.

That means folios covering atomic IO ranges do not sit in the page
cache in a dirty state - they *must* immediately transition to the
writeback state before the folio is unlocked so that *nothing else
can modify them* before the physical REQ_ATOMIC IO is submitted and
completed.

If we've got the folios marked as writeback, we can pack them
immediately into a bio and submit the IO (e.g. via the iomap DIO
code). There is no need to involve the buffered IO writeback path
here; we've already got the folios at hand and in the right state
for IO. Once the IO is done, we end writeback on them and they
remain clean in the page caceh for anyone else to access and
modify...

This gives us the same physical IO semantics for buffered and direct
atomic IO, and it allows the same software fallbacks for larger IO
to be used as well.

> > Why didn't you use the existing COW buffered write IO path to
> > implement atomic semantics for buffered writes? The XFS
> > functionality is already all there, and it doesn't require any
> > changes to the page cache or iomap to support...
> 
> This patch set focuses on HW accelerated single block atomic writes with
> buffered IO, to get some early reviews on the core design.

What hardware acceleration? Hardware atomic writes are do not make
IO faster; they only change IO failure semantics in certain corner
cases. Making buffered writeback IO use REQ_ATOMIC does not change
the failure semantics of buffered writeback from the point of view
of an application; the applicaiton still has no idea just how much
data or what files lost data whent eh system crashes.

Further, writeback does not retain application write ordering, so
the application also has no control over the order that structured
data is updated on physical media.  Hence if the application needs
specific IO ordering for crash recovery (e.g. to avoid using a WAL)
it cannot use background buffered writeback for atomic writes
because that does not guarantee ordering.

What happens when you do two atomic buffered writes to the same file
range? The second on hits the page cache, so now the crash recovery
semantic is no longer "old or new", it's "some random older version
or new". If the application rewrites a range frequently enough,
on-disk updates could skip dozens of versions between "old" and
"new", whilst other ranges of the file move one version at a time.
The application has -zero control- of this behaviour because it is
background writeback that determines when something gets written to
disk, not the application.

IOWs, the only way to guarantee single version "old or new" atomic
buffered overwrites for any given write would be to force flushing
of the data post-write() completion.  That means either O_DSYNC,
fdatasync() or sync_file_range(). And this turns the atomic writes
into -write-through- IO, not write back IO...

> Just like we did for direct IO atomic writes, the software fallback with
> COW and multi block support can be added eventually.

If the reason for this functionality is "maybe someone
can use it in future", then you're not implementing this
functionality to optimise an existing workload. It's a research
project looking for a user.

Work with the database engineers to build a buffered atomic write
based engine that implements atomic writes with RWF_DSYNC.
Make it work, and optimise it to be competitive with existing
database engines, than then show how much faster it is using
RWF_ATOMIC buffered writes.

Alternatively - write an algorithm that assumes the filesystem is
using COW for overwrites, and optimise the data integrity algorithm
based on this knowledge. e.g. use always-cow mode on XFS, or just
optimise for normal bcachefs or btrfs buffered writes. Use O_DSYNC
when completion to submission ordering is required. Now you have
an application algorithm that is optimised for old-or-new behaviour,
and that can then be acclerated on overwrite-in-place capable
filesystems by using a direct-to-hw REQ_ATOMIC overwrite to provide
old-or-new semantics instead of using COW.

Yes, there are corner cases - partial writeback, fragmented files,
etc - where data will a mix of old and new when using COW without
RWF_DSYNC.  Those are the the cases that RWF_ATOMIC needs to
mitigate, but we don't need whacky page cache and writeback stuff to
implement RWF_ATOMIC semantics in COW capable filesystems.

i.e. enhance the applicaitons to take advantage of native COW
old-or-new data semantics for buffered writes, then we can look at
direct-to-hw fast paths to optimise those algorithms.

Trying to go direct-to-hw first without having any clue of how
applications are going to use such functionality is backwards.
Design the applicaiton level code that needs highly performant
old-or-new buffered write guarantees, then we can optimise the data
paths for it...

-Dave.
-- 
Dave Chinner
david@fromorbit.com

