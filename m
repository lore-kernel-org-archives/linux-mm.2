Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 188D2CCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 09:25:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 694F18E0007; Fri,  7 Nov 2025 04:25:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66C8A8E0002; Fri,  7 Nov 2025 04:25:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A90E8E0007; Fri,  7 Nov 2025 04:25:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 49C698E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 04:25:17 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F2E311A03F9
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 09:25:16 +0000 (UTC)
X-FDA: 84083277432.22.B0148D2
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	by imf25.hostedemail.com (Postfix) with ESMTP id 92430A000F
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 09:25:13 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=WkyizHyt;
	spf=pass (imf25.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.33 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762507514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u8uZZ4eKtfeKdhCl1Q4zHBINNzxY5n31tzDb1+D2ZUs=;
	b=KZ2OHl246ZcU4ZfOATOVEeAfaP2EhTkKksmNkCTGZhUwX8q+bRzxey3Aoun+1QzZDJAbxS
	H0FjBjwIM7jSJqncOPlXIwemmLH+EDR83gOuvoVHLdG8njcSer1r2Px/uAvUd16cXFmpPd
	3Lt92vEMRoZMxNmxigb2VY+VsAzNtAA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762507514; a=rsa-sha256;
	cv=none;
	b=G9SbL/HcL8VBXshrihHBgcUj4MJzwMs7Y29rG+qxlPOPpVRpUAinr0s6i5I/KahfhxNDor
	Wi4//VNQsr5VH2bgHh+VMgkoXGRKsL1lQAVBHXGbi4PKOY+MLOH1+7/p3K4co/c2EivI+n
	i5GlLoLpJ37ln61TEN7eRo1ho5w+tbU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=WkyizHyt;
	spf=pass (imf25.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.33 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20251107092509epoutp0394362ad87b5c71e28408228f24f293ff~1rz37TAqw0980009800epoutp033
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 09:25:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20251107092509epoutp0394362ad87b5c71e28408228f24f293ff~1rz37TAqw0980009800epoutp033
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1762507509;
	bh=u8uZZ4eKtfeKdhCl1Q4zHBINNzxY5n31tzDb1+D2ZUs=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=WkyizHyta13iamjwW4vEYhV7pbJ4ccsfU1gtc8g9iF06s6v1ewoPf1tWE0RmZzDBq
	 8IrTKwbRW3EJJNRRAcc0YbZXEBZjOKLmedL0iyJ7xAD8IfLfx3GSl9U22Vc8lKAaqp
	 1zvpQRJd3/jzSbhjnhqRNNnd7ETs5cD4oO4MrhSI=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20251107092509epcas5p39521b5623906275347b3ec7177eac680~1rz3UXgnn2572925729epcas5p39;
	Fri,  7 Nov 2025 09:25:09 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.91]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4d2tv81KkDz2SSKY; Fri,  7 Nov
	2025 09:25:08 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20251107092507epcas5p3041edfe682f64c59ac3fe0fab4b9384b~1rz1O74AD2299222992epcas5p3F;
	Fri,  7 Nov 2025 09:25:07 +0000 (GMT)
Received: from [107.111.86.57] (unknown [107.111.86.57]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20251107092447epsmtip2e07f9528cf570ebdd336a8a4571fc676~1rzi_2xUI0827208272epsmtip2i;
	Fri,  7 Nov 2025 09:24:46 +0000 (GMT)
Message-ID: <91367b76-e48b-46b4-b10b-43dfdd8472fa@samsung.com>
Date: Fri, 7 Nov 2025 14:54:42 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/16] Parallelizing filesystem writeback
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, jaegeuk@kernel.org, chao@kernel.org,
	viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
	miklos@szeredi.hu, agruenba@redhat.com, trondmy@kernel.org, anna@kernel.org,
	akpm@linux-foundation.org, willy@infradead.org, mcgrof@kernel.org,
	clm@meta.com, amir73il@gmail.com, axboe@kernel.dk, ritesh.list@gmail.com,
	dave@stgolabs.net, wangyufei@vivo.com,
	linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
	gfs2@lists.linux.dev, linux-nfs@vger.kernel.org, linux-mm@kvack.org,
	gost.dev@samsung.com, anuj20.g@samsung.com, vishak.g@samsung.com,
	joshi.k@samsung.com
From: Kundan Kumar <kundan.kumar@samsung.com>
In-Reply-To: <20251029085526.GA32407@lst.de>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20251107092507epcas5p3041edfe682f64c59ac3fe0fab4b9384b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251014120958epcas5p267c3c9f9dbe6ffc53c25755327de89f9
References: <CGME20251014120958epcas5p267c3c9f9dbe6ffc53c25755327de89f9@epcas5p2.samsung.com>
	<20251014120845.2361-1-kundan.kumar@samsung.com>
	<aPa7xozr7YbZX0W4@dread.disaster.area> <20251022043930.GC2371@lst.de>
	<e51e4fb9-01f7-4273-a363-fc1c2c61954b@samsung.com>
	<20251029060932.GS4015566@frogsfrogsfrogs> <20251029085526.GA32407@lst.de>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 92430A000F
X-Stat-Signature: aj1imredit3e3kyz6zpuqw4he446kwn7
X-HE-Tag: 1762507513-811884
X-HE-Meta: U2FsdGVkX19RJl8DBs8vhjoPBNo63iDIJ7Fk9CX6VZtYxeJyXm5Y8v4XkSNbw8jGFKTN7PrsfaOOkMq0GbBpWfWRie3xlufaGodjo/HbsMJ0N5QUMMti+wYRWgYpy25TUldHe6g/WvWV+mONowagSrQY3DDkfHeym4cNiTjYFpOYTYYaQxx/IR/UX89ZDu0LeEYDNY4Isnikbl/OLqDE8aT9Co/T2kaknqc2DFnTLqcsUIvPfylZ464AD869IsYo7x8RW8gq1qF80Ser+A8bpBF96GOJOrIqOL+9Yk29YKCqsvGEWLVQ0XSvFkuMJAeWwlZQVKAFvTgj/P7PNAGiiIVMt83arB1dHIH29nLQFuD6ABt9OQcpE8eEYXs2D17lNMELoTqPX5mmNTSGNgGZzobXESe4m361brRfTO226jhdZ5VGeJNlqZUxp9n2W/rhLQRzt+i7te2maPQzYdDOS60Uy2sKC3PeqFZZ06BRhJXpvJBR9n/gOkvHOjzub0vYDBETGZlkE/nPTIm3zEhFl5ewDm3OUSX/ITEfmxgtw7DD6GzyCI/5rdByPFMK7zljFu7Xo6Q+EFUiK7YSmV0RwTXeaUfGETzvuYhFGfJ8v0JODt9zJu+2EW3mjcpmbIcxGVvJIo5Y/nKesGhOkrHKGZ0iuB9F+iSS8ZrnD+9ssGxmHR2Hl3QBsDdZfNszQttujNtceARzj5swZ7Vk/7jPW5KI5hUyfoXHWhSI9yowo5l0rh5JFDLSegPPDxjyF5knYbwr9wABgaKOIYa0yzFgNX+Q3wGgWjkw8aste/cd0we3t6XbMGritQQpfE4xjSnKV7j1rWbI13z/wpGL8kAdZpD1imaHGLCFgiCEXc7GPnYvWEja6oxDAwjQh7j/mP18YHZtgO/rQ7KZwwfSvRI+bfC02g7aqTSykuFzQm9gNe/mq8hWqvx1zaG4d7gtnSIuSIU+/gZF2BxBTBtdtKT
 cFLDqQQk
 o5SIVowOIKWmYsss/9kNFrGXOTHQ1H4Fch2bXQdF+9AlI9NmWjzAETNXnASni9bviWJIXCq97zvHS5e2w6EgM2uZpLKW6cVYCvyA7TnlpSG9ntrhCeaMA+WPMfaYtLlNdCLJImi4Wuzz8L24x+VVK+uDGUGHY2Zq5C5os4yETxDSf9EGeXJk11zfpmZ9+aenIA1Zh6wLhgfxVAQc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/29/2025 2:25 PM, Christoph Hellwig wrote:
> On Tue, Oct 28, 2025 at 11:09:32PM -0700, Darrick J. Wong wrote:
>> Was that with or without rtgroups?  metadir/rtgroups aren't enabled by
>> default yet so you'd have to select that manually with mkfs.xfs -m
>> metadir=1.
>>
>> (and you might still not see much change because of what hch said)
> 
> The real problem here is that even the inode number to AG association
> is just a hint, and will often go wrong on an aged file system.
> 
> Now for the zoned RT device we could probably do a thread per open
> zone, as that is a very logical association.  The problem with that
> right now is that we only pick the zone to write to once doing
> writeback, but there might be ways to lift it up.  Then again
> zoned writeback is so little code that I can't see how it would
> saturate a single thread.
> 

Predicting the Allocation Group (AG) for aged filesystems and passing
this information to per-AG writeback threads appears to be a complex
task.

For write operations without pre-allocated data blocks (fallocate=none,
resulting in DELALLOC), the next available AG is selected, and the
XFS hook can be used to predict the AG that will be allocated.

In contrast, when writing to a previously allocated data block
(fallocate default, resulting in UNWRITTEN), the AG containing the data
block is chosen. Large files that span multiple AGs can lead to a mix
of random I/O operations (DELALLOC, UNWRITTEN, MAPPED) being directed
to different AGs, while still being cached in the same page cache.

To segregate these I/O requests by AG, it is necessary to associate
AG-specific information with the pages/folios in the page cache. Two
possible approaches are:
(1) storing AG information in the folio->private field, or
(2) introducing new markers in the xarray to track AG-specific data.

The AG-affined writeback thread processes specific pages from the page 
cache marked for its AG. Is this a viable approach, or are there 
alternative solutions that could be more effective?

>>
>> --D
> ---end quoted text---
> 


