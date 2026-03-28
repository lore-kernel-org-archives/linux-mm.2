Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 728CA10F3DF3
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 18:36:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBEF66B008C; Sat, 28 Mar 2026 14:36:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D70266B0095; Sat, 28 Mar 2026 14:36:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAD046B0096; Sat, 28 Mar 2026 14:36:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B98706B008C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 14:36:33 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7EF84C0FB4
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 18:36:33 +0000 (UTC)
X-FDA: 84596327466.03.6140F59
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id D6B7A14000A
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 18:36:31 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=manguebit.org header.s=dkim header.b="l/xJtaqQ";
	spf=pass (imf26.hostedemail.com: domain of pc@manguebit.org designates 143.255.12.172 as permitted sender) smtp.mailfrom=pc@manguebit.org;
	dmarc=pass (policy=quarantine) header.from=manguebit.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774722992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2G5EjnsDra2FRBDfpoHL88rw7wDpJJ6XyDPUAlNk2CE=;
	b=etHTZWHD1xOyQjPskJvmuaUNQkW2KneQtkadu14HXW99hGQlcjbjJHS0/vDkPPSoW5FXV0
	ryAMMZKcNpI8/Yo0eyoQV4IiOsW+TMC3dipIhjvAF2eLuYCplmr/6hU1m5hwUZ8jPh4AHE
	kp+Jo+FzJdHyaxoAPO4H89NDjX4MJa0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774722992; a=rsa-sha256;
	cv=none;
	b=oI33D7R7TxmzPkbwEobF4cCxRB/ZyIz1UZj12erFBDx2o36iJtcnSvrGpBmIdd7wbZ1lzm
	aAgvcUu0VgAvIVBmIJGKxhxzabpvisdD/EzzwO1IPYTSmAcHF5T2s5O4zGw2hDfckuD5Hu
	bwcqitC7ZG2hhtmfrdWy0bk+S8drPiI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=manguebit.org header.s=dkim header.b="l/xJtaqQ";
	spf=pass (imf26.hostedemail.com: domain of pc@manguebit.org designates 143.255.12.172 as permitted sender) smtp.mailfrom=pc@manguebit.org;
	dmarc=pass (policy=quarantine) header.from=manguebit.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=2G5EjnsDra2FRBDfpoHL88rw7wDpJJ6XyDPUAlNk2CE=; b=l/xJtaqQbIOEJk9zlI9x/R+HbG
	L3R5sAwTtHIxcRDqGQ/yRYtEadhEfcAjWRqZaSAkqrg5zakHzc+vhUyBV0Jsj+1zTGC4tqfKAWA7M
	Wo6es5dWLIMPpy6h76cu5buH4eOZavh8FiAkBQ6PFw8X/KsusWS5ujfeX8qOS1SNeFnzdeRyJTSKg
	zWLYh5AsjWaO+d4ynavPbCAidz0ioWER1Z+rwWyGvBgxCXD0UMShGguznBykol887FSTaTtPTcut8
	cO3L8CVZPJgZ7sLRxl6Q2/ts+kmHtPc4e4fiJYBKjnK360N/gJolVTh3J90rd7PpgFPZdHOtMtWJD
	DtIEPVPg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.1)
	id 1w6YWL-00000001nom-3cop;
	Sat, 28 Mar 2026 15:36:29 -0300
Message-ID: <9faf4ad6b806a377678a03917edc580b@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: David Howells <dhowells@redhat.com>, Christian Brauner
 <christian@brauner.io>, Matthew Wilcox <willy@infradead.org>, Christoph
 Hellwig <hch@infradead.org>
Cc: David Howells <dhowells@redhat.com>, Jens Axboe <axboe@kernel.dk>, Leon
 Romanovsky <leon@kernel.org>, Steve French <sfrench@samba.org>,
 ChenXiaoSong <chenxiaosong@chenxiaosong.com>, Marc Dionne
 <marc.dionne@auristor.com>, Eric Van Hensbergen <ericvh@kernel.org>,
 Dominique Martinet <asmadeus@codewreck.org>, Ilya Dryomov
 <idryomov@gmail.com>, Trond Myklebust <trondmy@kernel.org>,
 netfs@lists.linux.dev, linux-afs@lists.infradead.org,
 linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
 ceph-devel@vger.kernel.org, v9fs@lists.linux.dev,
 linux-erofs@lists.ozlabs.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 10/26] netfs: Bulk load the readahead-provided folios up
 front
In-Reply-To: <20260326104544.509518-11-dhowells@redhat.com>
References: <20260326104544.509518-1-dhowells@redhat.com>
 <20260326104544.509518-11-dhowells@redhat.com>
Date: Sat, 28 Mar 2026 15:36:29 -0300
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: D6B7A14000A
X-Stat-Signature: rpfckzbroq9r53sgucczp7wtmamw9rzn
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774722991-63177
X-HE-Meta: U2FsdGVkX1+CorXmglbM4YU8FbAcKayFsyDk3pHsieX0yYnECf2clXe9da1miWcVtcVAWuU9ilCQ8GLQSRGKJmMpjo0p2s66J/1VzyYRS7IF8szt6IydB09vSKWcqnsZPaU7Zz4b+1WcAaMF2mcIeYcUGDX9NvpTKFqTCb7LDzwAZ0hUzzafgBhNA5y7V7yH/pQdykChIpmkyfoX/64KZCaQ7RhQuk2hafe1vm7FefqA1yY89PfVkIrlvixJdE/wtwWptNNn0SMeKIsspQ7DkV6klRxBBKldsHJIBURdsKeWx01rSH+0zhNzWodNsGmQHOIpULL0vq2gP7ob5NEy8kLNO4m4tQ2kiIx8QbrUOOflm/X0x8kq+vwUqx3IGZETVs8HcSy1ohUsiZXpUbUjIhKj7ehfwrXG4yIttFBgT8z694wF2J5dItREMBWQh+Tgolldvh165wRur5IT04eyPdYjxDCS/5BFZ/Reh+OhtV3Lzo+CAsE9Nyh8kUNCvMIAOINC0ynp21IfWW2EeI2/VcKr2XgiC41QhrdPywq2AiYW+siiRAmbkLZbidoPQ5LZZdurkgjPOIQ/Y/hGRhCPTSC7BONm3mzvf4vICwsSNKxtPKUCxwFQHA0dB/mvUgP+2a2akpGNW55ifarzOaLaBHCE20/LQc8Mc8ocppaqBl9JPBjU23q/rRDIAL1TGGoXt7piW38JgRh49tVfoy7tt5XNYs0E6+hF2FsENsU8gWNQt3As4X5cChbvkkQUyVJRRiywedQXsGqvk9R/LoajVyBqaQpyCGzUnwt2C3EyKYUiibjO3GJJE0Y4ktDRbU5gJJVelOoXyMkIwwdOL0vNJRKz7zr9MSKtL4IH2bnYQoDBFCGDk/q7LG3c7sRoTI4Xfc2FQM3o8THMJRQclkD6/zc9cozJubrc0StWPWGNPWVUtoNxVd/pXSIRd5S4ySqYt0pcgWVjrrIFMRC1QTW
 Mdz7BRBO
 MUaU8n93DKa/l8iF6H1J06+CBi0X/VQN3B0CcwdOMogtIXoogxR+yeV5KgvFWJ+bMPUXuMyzETsF7IFkVFsPhHbSXFBGu4SLBmhnZ8MHLbDmDBlmJrtmRWcKK7mDCKAQlQ3/fG5GeLFbjCO8dC1F+b/bR/CqMw8ob4IVZdD0NY/9jdZ0oi0ovwsFwZMOiX86yI4zOpUQpM6Iyjhgnb0nECFPb083CXEQvcK06U3ea+lktXFiKm95IZcyOVh0rcGRNuMam341alcI+Xw6YHlWRL5AGrmp9M/XoFdKlNKb5X/81YccGIKDP+JgGdw72mjSLdGpRpYiSyTWcMI3balFbfEbqCi6Pm/8+Sq4CV9ljyCf+yCkc5XmoTK58nZtOZlc6L/WYSlotD4HNUuwHq49321pk2qzAYRBxzGE+Hk6lJGZuJlX0TXDbbCuHbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

David Howells <dhowells@redhat.com> writes:

> Load all the folios by the VM for readahead up front into the folio queue.
> With the number of folios provided by the VM, the folio queue can be fully
> allocated first and then the loading happen in one go inside the RCU read
> lock.  The folio refs acquired from readahead are dropped in bulk once the
> first subrequest is dispatched as it's quite a slow operation.
>
> This simplifies the buffer handling later and isn't noticeably slower as
> the xarray doesn't need to be modified and the folios are all already
> pre-locked.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Paulo Alcantara <pc@manguebit.org>
> cc: Matthew Wilcox <willy@infradead.org>
> cc: netfs@lists.linux.dev
> cc: linux-mm@kvack.org
> cc: linux-fsdevel@vger.kernel.org
> ---
>  fs/netfs/buffered_read.c       | 95 +++++++++++++++++++++-------------
>  fs/netfs/rolling_buffer.c      | 75 +++++++++++++++++++++++++++
>  include/linux/netfs.h          |  1 +
>  include/linux/rolling_buffer.h |  3 ++
>  include/trace/events/netfs.h   |  1 +
>  5 files changed, 138 insertions(+), 37 deletions(-)

Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>

