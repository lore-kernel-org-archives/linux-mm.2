Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8156710BA42D
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 05:34:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A05CE6B0092; Fri, 27 Mar 2026 01:34:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B6D66B0093; Fri, 27 Mar 2026 01:34:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CC946B0095; Fri, 27 Mar 2026 01:34:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 78F906B0092
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 01:34:24 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DB4951B9336
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 05:34:23 +0000 (UTC)
X-FDA: 84590727606.18.D4B6C73
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 363B51C0003
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 05:34:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=aZkAHLEA;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774589662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aA6GA7UjCVCWzBJVbX7fygc0hyf3brfw7iTfig1L+ig=;
	b=O8ACvIg3tUBy6mqk+TEmV+w5Iuw31PBLmvNjenP4wuleFE/ddDiTWxMBrMJMSDzfSKhYXu
	nCOzs/BeRN3DRMdmFwpkjX1fLHuP3blRC36j2nQSkmBlP0mrpCImGt27KZ7VxxPqeNLbob
	9bwmyFaYwPmHm3Kv63rzsqnabzMS2CY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=aZkAHLEA;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774589662; a=rsa-sha256;
	cv=none;
	b=5QZuAYoel4yOPlwA8UB71NKZt4wNWc6ytl05QWiE6KpCWjkxhNpA4Ce805cETo/n9iGAsk
	x4zVa91HJjl0vfRLHWa25o68ApFu90R/2d/tErTmehYZjnZTzEFh7cMnLiF0GrnH2Dfqxk
	3lyoYvyIS8Unmc0DXXjPg5y6XU/DCdI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7F2C26011F;
	Fri, 27 Mar 2026 05:34:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7A4FC19423;
	Fri, 27 Mar 2026 05:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774589661;
	bh=weCefxiBjTGq2PwSMe71qissOFHl66eLJ4DpNp4Zd1w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=aZkAHLEAux8dadNSGOey0wxkDpcPcAptJleH9NyEM/0a5D35/DK22ls6cR/Z8yoeS
	 yByYdpP0YmsbDMxfKeVmAva1lHdgkP4Dak9HFF27QPqwjwNdYVCe/FkpKUZfrqRZW8
	 khTUxjU60ZFLqfiW+wihj8uTKlMgDvWmDc2E+nxM=
Date: Thu, 26 Mar 2026 22:34:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Xie Yuanbin
 <qq570070308@gmail.com>, willy@infradead.org, Liam.Howlett@oracle.com,
 david@kernel.org, justinstitt@google.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, ljs@kernel.org, llvm@lists.linux.dev, mhocko@suse.com,
 morbo@google.com, nathan@kernel.org, nick.desaulniers+lkml@gmail.com,
 rppt@kernel.org, surenb@google.com
Subject: Re: [PATCH] mm: optimize the implementation of WARN_ON_ONCE_GFP()
Message-Id: <20260326223420.cf92ff1d55d078390cb10cb9@linux-foundation.org>
In-Reply-To: <20260310145231.1680db9b@pumpkin>
References: <aa7p3eQfEuh2wObQ@casper.infradead.org>
	<20260309155933.41179-1-qq570070308@gmail.com>
	<be647d6b-9bcb-41c8-bfcf-7fa03d2b942f@kernel.org>
	<20260310145231.1680db9b@pumpkin>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: gf3n1gb8msqjzqkz5anctoywa934qopu
X-Rspamd-Queue-Id: 363B51C0003
X-Rspamd-Server: rspam09
X-HE-Tag: 1774589662-455043
X-HE-Meta: U2FsdGVkX19iO5JgI2usGZSbFWx7YjwAE1WI70KGOcTnTnBMG8v1PkrLfAxR5eHSo84mP2gwDFPsxYBZJij0QQCQuOY2k4l1yxUZ/IJBdIo/AC8o0cbFIaZ8phMd/ZhQtbStYCDd7HdbUi1yDmrFFOGLyfyHtRDUV/2uAz2Dooj04HZwR6wHFBEZy/L2YqtK0rMDcy9c8Jjnt5dd8j6p27PO/YhNAbbcA2dsBKjZf58Wo4otgXe2zZn/YtVQHSwDyTepLfYiCTF6v1rLFSpaAqQRQEg+NtZFvjTdvecO8ceB5MO+pWyJoTVGFQfLUN4yARA8WmvpcKAqS56xNLWYiXC+Dctyo+m1GmE8vCL8bch8VvdBHAcQGd8TpQSa0QhuXpsuVF2Wl5MG8eAidukjaJlcI+9lnwLG4hScQ0dCzuo9ONGq6RYty0kIdyaPZ5pVY9tqFIdcjxhPPmAR6k6TsDOVASluFAoq90QhtHfxzBBFP1M6CvIgsKuL26265oWIK0gwpB1zTJcPi6k4rebty8RoZP8ViYccd46bkxonIjBFhxv1TuOCtjFCG10UI2egjyCA7iXPZzNBs/EqVEYRFg9EfhfOzb5WXfBozgYQdKsctmDxeZpAG3tL8pb+ZdAw0sjzxT+5/jtx8XLM3ZYH/Ggepn94f7ygoPPVNkadbmmCNFN9r1a/AABkh/EuHdIc0xvpO/HQ9WgdPLS+Z+wWjHSMKpHTOw6smqt647USFpyDBJxhaiahFqwa7Of75VStHvXO6EhHb9ytXajSc/37CIrdV9GS4ckYFLNQ3Utky6+t7TFkC3duoRYEb+ctcQES9HFRTklbDL84WXkwH6VdhmXzTVA4dfclNKg7JU0qsvLILVMO3qyo0y8u6lPla0XsMjIcU6CGBihn4I6EyDCCTRmji2NKeUMHWhYhOWnPbpO0leb55qE95Zcct2IHv5uUSRdWn79qsQZu3VwICfj
 hp6/As4Y
 fVli1aHzDbk2EubQjE3OJqwDFDF4Sst2NKcQYVoEiUFacIfakQu0mTrJ7EqfA07GLF/wxXoU/l8gWTtEtFQ/YsFaUZBHBMoF2pXH4lfvxF1k0p50596+MpnON/i0qfGaAfAwPOl+LeClAsbzhgzGoVrvWbPDqcV7jobf8dll8JZaCUvjHSBdeo1eBblgZmT+Pphl91dfzikoAgdBKH33AXHgvjFqybwww9i52bkyA9WWdj5NhyMnKx/YJ73VDGgHMI9QUew2BuLuMBbhvD+o04Ej0fBz6gb8GR5cZF2vs1y393sLxLjFfNXygzvdwKTCuTyN68Z6foMvIbxap+jKXq/KcBDqYYBuf5MHyxCrmw236AqX+IGzkR/3n9a2eJ2lDAEeWgFL4R4FVioM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 10 Mar 2026 14:52:31 +0000 David Laight <david.laight.linux@gmail.com> wrote:

> > > If a and b is both unlikely, then "unlikely(a) && unlikely(b)" will
> > > generate better code than "unlikely(a && b)". This is also true for gcc.  
> > 
> > What are the details of how it's better for gcc?
> 
> I'm not sure about that specific case, but I've definitely seen gcc
> generate sub-optimal code for some un/likely() of compound expressions.
> The underlying cause is that the code is (probably) first transformed to:
> 	bool tmp = expression;
> 	if (unlikely(tmp)) ...
> this means that you lose some of the short-circuiting that happens
> early in the code generation of 'if (expression)'.
> 
> It is also not at all clear what you want the compiler to generate.
> For 'unlikely(a || b)' you want 'if (a) goto x; if (b) goto x' so that
> the 'likely' path is the no-branch one.
> But for 'unlikely(a && b)' you still want 'if (a) goto x; y:' which means
> that the 'b' test is out-of-line and has to be 'x: if (!b) goto y' to
> avoid a branch when a is false - but that means you have a 'normally
> taken' branch after the test of b.
> That pretty much means the compiler has to decide which unlikely()
> to ignore.
> So it only makes sense to do 'if (unlikely(a) && b)'.
> Indeed even 'if (unlikely(a) && likely(b))' may be better!

fwiw, this change makes no change to `size mm/page_alloc.o' for x86_64
gcc defconfig.

Given the expressed objections and that WARN_ON_ONCE_GFP() is used only
twice in the whole kernel, I think I'll remove this patch.

Xie, if you disagree with this then please resubmit the patch with a
more convincing justification and hopefully people will reconsider it.

Thanks.

