Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B319CCD185
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 21:16:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4ADBA8E0065; Mon, 13 Oct 2025 17:16:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45E4F8E0036; Mon, 13 Oct 2025 17:16:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 374348E0065; Mon, 13 Oct 2025 17:16:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2520F8E0036
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 17:16:24 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BF921882F2
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:16:23 +0000 (UTC)
X-FDA: 83994349446.18.C92C707
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf18.hostedemail.com (Postfix) with ESMTP id BEA941C0014
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:16:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=fromorbit-com.20230601.gappssmtp.com header.s=20230601 header.b="BOzwnnQ/";
	spf=pass (imf18.hostedemail.com: domain of david@fromorbit.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=david@fromorbit.com;
	dmarc=pass (policy=quarantine) header.from=fromorbit.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760390181; a=rsa-sha256;
	cv=none;
	b=R72QA3ZIYsQZDmpjLHSP2ZYPxgaUFYzaipCzLxcpiBV9OTeI9zdjDbg/jsQ68hA1uUuWO7
	nTluZgfRYHZGZfJcva9euN7yLquPOYSZeHlJaEv/mP1FqYZIqHm6/3hHBjEWYetppdXku5
	GodjHVSfdOVCeV3r2oUUGcoQsZXi6/o=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=fromorbit-com.20230601.gappssmtp.com header.s=20230601 header.b="BOzwnnQ/";
	spf=pass (imf18.hostedemail.com: domain of david@fromorbit.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=david@fromorbit.com;
	dmarc=pass (policy=quarantine) header.from=fromorbit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760390181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1bGIpbfrOvyd6WWfxe3wkvxR2bRwHs9IuC/zJmaL5A0=;
	b=DJQPXjw9aEzE79KWmOp40vccN0OxY0OcQsiZ2DiGdjdpAgtI2MNMSf86amLCQQD7hYy64/
	mLOCB9BuOnxsXxU5BkGAY+KEMH7VISlqg7b+ZyUtUoANhdIodhejDRqyV0ydtQdMpwC8KA
	CX6LokA9kYgaXFD3NuxB7KtpbPE5PII=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-77f1f29a551so5971559b3a.3
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 14:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1760390180; x=1760994980; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1bGIpbfrOvyd6WWfxe3wkvxR2bRwHs9IuC/zJmaL5A0=;
        b=BOzwnnQ/7+3JhqVOCOSFKoE2OnHKHwUPJVNbBYXfnT1nnSUPJMH5TIRGq9hMDvsoL9
         ZHhyWhAADET72/xYfmqmboOBese9mlAAIOGU8/1Kl/L6rsiRHiEyR9GkoenJBWcA03gH
         Nh53AkGqepfKhdYOPyYDrFlILM9BsHYE7LW05a5PhfFTDBzrMnWaFQ5AscGUmSYIlNyI
         R8y47n9kloRuPGTgUzJCyOuS0x8v9dK+ziDDAlfq6ELud1xVhyOE15Rr6JZwXBvRVlZe
         Ud/FcKIbYYcoc9Ut2HNgTTg15twBto0CW3GbYPY2orSd2NahJv1vkl7bWwhIeU28+T1J
         TIdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760390180; x=1760994980;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1bGIpbfrOvyd6WWfxe3wkvxR2bRwHs9IuC/zJmaL5A0=;
        b=kstSsNnNGTTlDOR4FxnbhepqBgCMDhSguJ+QhhdasdPtfZPAQqjDDoT98pWKG3NFGp
         lLDZAojdyUcCPLDzy+ZAYbcXwtvE44b4NH4DHqiRGJMmWzW/gUfy3hx36+Q0Xm32T4Ju
         Cd+SD2sMjT1FzjU3lbE63kLLswEFmxqJdt2H/uQo6WsHoxGqRjFe87rljj2ou50iDpT/
         yY3Z+Gi3xEaWnAYEVHnIaSnBFP85LB5tOjUgCpZAsglhHSeIyNW9C7ZwJ/NfJGnmBNhB
         QN3W0sRKV1JZICt3KC2vcP8+ro2bAr3yjNDrzTeOpxix2q5kE0+WA4jWiKk8RhJ1bCb/
         XQiw==
X-Forwarded-Encrypted: i=1; AJvYcCX26sZXKpPW7w+Rp981OhthBOhIRFcMAyuTSUVNo4B1xwG5hGjiU0s3GQnEITNTG91qkz6fD/GiRA==@kvack.org
X-Gm-Message-State: AOJu0Ywh8KmuR+lIxhjd3sKApIf+BkSQT1iDtlINlg1sF7JK3RIR0GwZ
	Qhpihpvu4g5e3TcU35eMuwWywvCTLNKIMjgHHVDYQb0HiOqa194JVNtEr6Ga105115w=
X-Gm-Gg: ASbGnctSZiG+CSTbebWBSlVF9qYFTtTVf0/nn0IzrkuQYgy2QGRHK8/vQol0lgw0yAK
	CZKNNFj+F4ePyxR/SgRjRrcJge1LwcukClwnF2TP8VoTu70KWCbUyPiaZc1C1m53zPxzsMaF8s1
	4JuE7NA/28i3NVS1cmsPdDjQYnv+8IIPY9zNpIOADGkr1FUc2SXe+NHBwakI6OmRVWpNe7f1caw
	HIJ3LLc3MYRqmGNB/Rzr5virIjMyR/2wTbvc5ZqI6l5yX0tNtA20MvO1GHUiamzxjt3a/GiSMoC
	BcE0fMIFTDclswvvb5UCnM55Tfq5zlArXIA1HtbzEryVfX3nUmKUPlD0sMTSHujwqhPf03B1OvA
	H1l7XwlDtkD2ZVg5bD2u8yCXmfFIsBTwU6GHjuUhm3RVYq4E/8gGFRxJ7Bb134NxDIL7A98oO1u
	Al4eqCKgzHWwW6nOznePKHfWR/LPJLFvwRrphmpg==
X-Google-Smtp-Source: AGHT+IGuPS/85NrpQt8btSHtyMtZAkheFRYc33E0JjNt4LL7IUHtXrIkFRrVpgza2afcE9/ZUrV47Q==
X-Received: by 2002:a05:6a00:2443:b0:781:4f6:a409 with SMTP id d2e1a72fcca58-793858fb715mr25502723b3a.11.1760390180328;
        Mon, 13 Oct 2025 14:16:20 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7992d0964c1sm12471310b3a.54.2025.10.13.14.16.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 14:16:19 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1v8Ptw-0000000ERfm-3Uzg;
	Tue, 14 Oct 2025 08:16:16 +1100
Date: Tue, 14 Oct 2025 08:16:16 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, willy@infradead.org,
	akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, dlemoal@kernel.org, linux-xfs@vger.kernel.org,
	hans.holmberg@wdc.com
Subject: Re: [PATCH, RFC] limit per-inode writeback size considered harmful
Message-ID: <aO1sIICzGcKReH5w@dread.disaster.area>
References: <20251013072738.4125498-1-hch@lst.de>
 <j55u2ol6bconzpeaxdldqjimyrmnuafx5jarzhvic3r2ljbdus@tkmjzu4ka7eh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <j55u2ol6bconzpeaxdldqjimyrmnuafx5jarzhvic3r2ljbdus@tkmjzu4ka7eh>
X-Rspam-User: 
X-Stat-Signature: 3q1g39izypjfg4oa89jn8n515ad4y9hf
X-Rspamd-Queue-Id: BEA941C0014
X-Rspamd-Server: rspam09
X-HE-Tag: 1760390181-51857
X-HE-Meta: U2FsdGVkX18zC/WsNe9HXRfNaO0rMEX9di/HzDxDMrmaILnuL8pCU/VjKHQNNNH9JM+U81SLO+0nGUB1aMgfUdW6S45RjiGyfw/+8zo9C8T5aMPODOcWpkBlrzCsNGoUXaCbsf6HJBuq8z9dPdK9L78BGMgf5wIOJq5pvVw402cC6K9DHuMjgYSoEOadRb/Fv9D1JKUTTHkcFFbWliSBn4oFGGoQHRo0P3ShiXf1oiatZYvkS3LXGkhcyq6ynCyvV4gB/u8LiD7uYDTtk41vW1e0A2n9p0Ve2CMKytn2nqHxItApckPbQTra31g+Ch8asEc2VCA6zmYJfJ75dJ/k8B052lMZgB4rKLviVhBbhM9HPge6p2yM9ls36SocEDIOPF80gQP51RJ2gk2YXthegjJCFnjbmMakCPd5AHVbWQv3QuR6O6Y6GR5VqwFPugVdl/zvff8HxQYP+Jgi2PlG04L9KPbyajQKRmxCWrZqhkUz1E9t1ArgDB/hMyn5G3p4j7sMxx9GZnoOY7ePgKDRtfJij/LK3fo/9TQ10GAjFm7XH21/AxjMnt3KLk8ELO04K9inVZdSVi/Jx1MC0A+k4kuUw9KxQow5fJyzmEeQjTG9pi0RZXLHKJypaKK1RCglMylfd1PteUpClzS8Gc6qDQsUJ1lsGYm75wB8PqIX2FEGLkS/XqlnA5vQtDDWHvZCDsUi/XXSBBsqbSeZ5l9DQ8rqUToRzxv2XTwjRtk/VLk4oHa3pjGqKPSemInR/thhQ63cxolPB3+fOMo0lTSUiqYgSOFcK4HKFSyIz+C4H0nORzAFxi3Xj2fehYCy+Nkawrm4pRRziwY/AFsKJTt9URZLw9l5gVg+xLECko210xydkOWdGOMDpbuWNo4fMGSrXQP69LKs+WfVvzeWiBxNTygmmPVUZbunFfc90TBJBZDmRLWNAYrOb7xI2g+mTTWmgeKTe1YaNV4Zk6WsC46
 Rb66TGjW
 vFA4qKK4QfWUdeuKvtNqI701rCkWfDIxqw5Fa4BNgf5aYtiIhSSsL/rosYM64WRaY6jKm1h+WibsfmbM+KU2wnr4JWL4fvnZS+w1N2jzGTaFEm1wdnghrqZk60LcvIZ9dy4krxNzAeagZjWgtvVJsJh1Wo6IILs2tU+spRH8LKJUOGfpvDtAuynKf3tf8uV+TBWXrXufT+buipO85NlKP+tDOR5sRkkm2VzR4xhLHD0Jf6+5zbpYM0ewmX37x9DvM+00MDC4nttaNgm66OOCJpN51CjDCEIZyUdTlg8BC+z0XloNsfN1RTW3hpFcBslCG2GcqGED9KUgWPbgFJiseoQYBzDni34VDQDhmvN0xCezfns/fOI6eEe+nJWUPevOKrDL5AxlmbIc/Zl7oKhEEyvW0QOGW98Wxj+TBhSuaDAnTCqIRkqg+l23u+oEPZAEtkTWBhBpu8Ynidg/NkyGESxBZ+B5vrymMkNH5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 13, 2025 at 01:01:49PM +0200, Jan Kara wrote:
> Hello!
> 
> On Mon 13-10-25 16:21:42, Christoph Hellwig wrote:
> > we have a customer workload where the current core writeback behavior
> > causes severe fragmentation on zoned XFS despite a friendly write pattern
> > from the application.  We tracked this down to writeback_chunk_size only
> > giving about 30-40MBs to each inode before switching to a new inode,
> > which will cause files that are aligned to the zone size (256MB on HDD)
> > to be fragmented into usually 5-7 extents spread over different zones.
> > Using the hack below makes this problem go away entirely by always
> > writing an inode fully up to the zone size.  Damien came up with a
> > heuristic here:
> > 
> >   https://lore.kernel.org/linux-xfs/20251013070945.GA2446@lst.de/T/#t
> > 
> > that also papers over this, but it falls apart on larger memory
> > systems where we can cache more of these files in the page cache
> > than we open zones.
> > 
> > Does anyone remember the reason for this limit writeback size?  I
> > looked at git history and the code touched comes from a refactoring in
> > 2011, and before that it's really hard to figure out where the original
> > even worse behavior came from.   At least for zoned devices based
> > on a flag or something similar we'd love to avoid switching between
> > inodes during writeback, as that would drastically reduce the
> > potential for self-induced fragmentation.
> 
> That has been a long time ago but as far as I remember the idea of the
> logic in writeback_chunk_size() is that for background writeback we want
> to:
> 
> a) Reasonably often bail out to the main writeback loop to recheck whether
> more writeback is still needed (we are still over background threshold,
> there isn't other higher priority writeback work such as sync etc.).

*nod*

> b) Alternate between inodes needing writeback so that continuously dirtying
> one inode doesn't starve writeback on other inodes.

Yes, this was a big concern at the time - I remember semi-regular
bug reports from users with large machines (think hundreds of GB of
RAM back in pre-2010 era) where significant amounts of user data was
lost because the system crashed hours after the data was written.
The suspect was always writeback starving an inode of writeback for
long periods of time, and those problems largely went away when this
mechanism was introduced.

> c) Write enough so that writeback can be efficient.
> 
> Currently we have MIN_WRITEBACK_PAGES which is hardwired to 4MB and which
> defines granularity of write chunk.

Historically speaking, this writeback clustering granulairty was
needed w/ XFS to minimise fragmentation during delayed allocation
when there were lots of medium sized dirty files (e.g.  untarring a
tarball with lots of multi-megabyte files) and incoming write
throttling triggered writeback.

In situations where writeback does lots of small writes across
multiple inodes, XFS will pack allocation for then tightly,
optimising the write IO patterns to be sequential across multi-inode
writeback. However, having a minimum writeback chunk too small would
lead to excessive fragmentation and very poor sequential read IO
patterns (and hence performance issues). This was especially in
times before the IO-less write throttling was introduced because of
the random single page IO that the old write throttling algorithm
did.

Hence for a long time before the writeback code had
MIN_WRITEBACK_PAGES, XFS had a hard-coded minmum writeback cluster
size that overrode the VFS "nr_to_write" value to ensure this
(mimimum of 1024 pages, IIRC) to avoid this problem.

> Now your problem sounds like you'd like to configure
> MIN_WRITEBACK_PAGES on per BDI basis and I think that makes sense.
> Do I understand you right?

Yeah, given the above XFS history and using a minimum writeback
chunk size to mitigate the issue, this seems like the right approach
to take to me.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

