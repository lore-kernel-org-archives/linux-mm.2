Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26583C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:44:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 264906B0092; Wed, 29 Jul 2026 10:44:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23AEF6B010B; Wed, 29 Jul 2026 10:44:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 178BE6B010D; Wed, 29 Jul 2026 10:44:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E64BA6B0092
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:44:42 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 10E85C05D3
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 08:48:42 +0000 (UTC)
X-FDA: 85041188484.19.0FE327C
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4952980005
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 08:48:39 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=RZXWSbw8;
	spf=none (imf30.hostedemail.com: domain of BATV+791f8870ad8e349a4af3+8375+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+791f8870ad8e349a4af3+8375+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785314920;
	b=0EA7JrnvlaJmM+ABQUcaKlwUJSMZkcL3WL+ju4KvGWXlVRZd8JOUSE0dO7rx6b3DC2Us+0
	x64sLX3/7c/qlPfcIZm4qTlf1HxMbGrqFKjX/zd/hQuExuEAJFWKU/OzQiXzgJCMUHvrC0
	J6DPNOaO+WUX86OxxX8t9opr6mUjS3M=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=RZXWSbw8;
	spf=none (imf30.hostedemail.com: domain of BATV+791f8870ad8e349a4af3+8375+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+791f8870ad8e349a4af3+8375+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785314920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/narXh7pPOZ4O+pLXLRtRJ77mb3IERKycuMvFjLVUkw=;
	b=07C9afuEexfjznW7CdFMHJ4h5xODSwGH7cwDZvUoyYmYfgyP7YgQ/jYeWFl4d9+uR0LexR
	UCvAdbXBJB/TM2tbYLYWBiO2flE1D1CoZwKkJta15dK61fPqSrTuoZ/EtrDJVp0v6C9Ged
	1Yh2/Uy5pKS8jXQuKvBuPL/yyVFZxp4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/narXh7pPOZ4O+pLXLRtRJ77mb3IERKycuMvFjLVUkw=; b=RZXWSbw8u1u57uY2shP/yxlNQq
	R9nR/ZWG3r/ZX/a4kI4Mfv21+SVafHoH2rU0vvbVkGmIJZH2IlJCcji2wdKWfRuJ8OfosxNn8cbpK
	qedUwm0QIZuWAVU77jOxQOOwWKucCQd3ioDZG1ObK5h2+2NDMQopLovEgyN4AWhujYyXeamM88il4
	SlwyJcDysvtZmqntJ80ap8lu1o6rPHfLTN4lu2zXMFDdzOTm9vPiyAIBN6ya7nn+05AhUGk06oF/G
	PJWiNoci1XtaL4F44iCmw+ZXYDSF8bReAknLuzJEAwQUk2moDmiClY7+5NPWTz8tqkHJovN2PTKX+
	P9WdR9eQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wozxo-00000007HFQ-3Kwp;
	Wed, 29 Jul 2026 08:48:32 +0000
Date: Wed, 29 Jul 2026 01:48:32 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Tal Zussman <tz2294@columbia.edu>,
	Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, Gao Xiang <xiang@kernel.org>
Subject: Re: [PATCH v6 1/4] block: add task-context bio completion
 infrastructure
Message-ID: <amm-YHQJFUsj4AM6@infradead.org>
References: <f1b8eeb6-2397-4f48-a21a-a023eb0c80ab@columbia.edu>
 <rkb5oei6cx2erbyininczz6ukbnquqheexhu7tznn5rslkkdn7@b4kpdyhdwdb6>
 <ahbq0RdUyLIPiItB@infradead.org>
 <80cb53f3-e7e5-4f96-bacc-f9fb7661d976@columbia.edu>
 <cuyklvhnt37xwk3jlr2iyyxxkzvt4bsf5iqv2gag4ixdicnbk2@rfqgjlclwesz>
 <4jtsjd2sbsn2w7fzfwb7wwowz72r4kc6345ckkkcjoxjbbwjwn@rkl44x3o3sgy>
 <cc58a101-6d09-4e42-b99d-673271934c29@columbia.edu>
 <amgrwn0yQoFvJP4u@infradead.org>
 <8124341f-3af2-4a16-897d-38db5ab5a9d4@columbia.edu>
 <4ahxusvs255ibn5unrayfeioqijbbidtn3l7joczxphwo2faee@3wtnw4nzu6wi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ahxusvs255ibn5unrayfeioqijbbidtn3l7joczxphwo2faee@3wtnw4nzu6wi>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4952980005
X-Stat-Signature: nrasxeokojforod3ffa9i9sycs7jzqso
X-Rspam-User: 
X-HE-Tag: 1785314919-819304
X-HE-Meta: U2FsdGVkX1/ANRb936F4/AFvX63SmcT+MsAplyMEmtXZNLv7VyQ7gmQCuykAtWIbhH/ZB3CEeu027gPvbVD7XxAqP0LoiKRa9A20myHTuoTXch9TuJyo553fOuQh6+xvnOIxgSNeQ/Nk+Y3uUpICnzDYMvkBrfjSNUrv4eCQsgLrnOChg7GZZVCi9grWWDwDOQGHQGnLxGWYjAFoG3NM/Zd1eRnDd2w7bfHiMPFXUPx6y09f1nn8qHpcNRhCWdZqEtSvEqf5WMA++igkxrFL7fyhuRSpxmikE3+n+JTqyNrN/gLWIDO2dW0tNvSdk8/Au+Cw0UJbwGvoZUES9kVnNhCHorIYl2HTTCHAbU3ByqhuojNteM3lvEGr6c+ciAemOKe6FtRqrg4h7Ngk7FT/w2D4C0B69NlPNqUAxULwABeJ4e3MpSGbDDSGZkwvxhpxkFWfLmjFjFGlDfC09M2AkyatN7Q9AUGNWm64W/YMZAJIDOSO6LRIuZeeg2kJNaiCNL3EzuX7P0YcGaLSdNF1Kf+sPUNvNgDTUp+g0cnwn9t9Babk5uThb3KVexX8sOPSAPIso3e/ocs6xtJzHiY0Wz5Nnx2pCMrcmphtRFbRn9lR8CxS0KqRhFCrDB7mfsO7aK9pla9JJEq+cczPrGK6m7FTg+NRE3+7m5M3/9vqhOkVYPTipT7GVxToo7bKe4Mhdvc/TAAImC1hWQu5dwkj2VnuKU63zJHADNzsonQ/y98/ilaBhredmL+6DXOQ3SMPXXdpSaJfFyClNULWcGCHXt6hlLrL1XqcCYtKa73taGm5MdDmnKBM4ceOiM0UWTQ/YOt+lctgCtnzsQGsggetceZ/UX7+0jtE2+r8uIgg9hlMlFzSEH6jcXynbcv/1dvX4LN2B8NeSWknSmy+9E0zIMH3vWBVbEyL7J8Kzz36Ff5qHG4h4vJOoKkNFpXdJ6/OSqAJexxOTpsIr+Ptsbv
 mi18obKR
 VyU8PmygPb6J7Y+Ca9VYwOPIjVdrsxV0h6dzqBvLPSRb8tbSRPdRa3NGIvDu1qFAWG7nafQcLh9Qxp3JYbB9xFOermaMB82+Cu8eVIyKXvxx433/JXE8/QRzBa2jECeu5BcRX/wodQrPnY+gPjfD90ZoXGjIoJskzRm5q5YaD5k/9RBgP7bxemlfrLjXZJdzhR55hzdRGmezWA4kXrgDzHFO+9BpL6iF52UiCs8DODXuUjewPiuXH5nBBws18JLAkgv+LuZpUzgd+7FEIMqzxICtvPd0KzEDjvoo+AflIRBpxZ69IpL4KDDwAJTCJpGW0ayqFxierbsGESVmzbzOyp/Fsr/d5YcxLCApUTe1hAaskUdKxtGi4bpnSC06lb17LqbIVnXQ4WHR6C7SZSdQ3dyVzbigCqpMtQjdOowLPnmI20Ny4BPmzN8vRrYRcB6uhtgo6feZxaZHlCCAEkZ3Y/WbSjt6HWPPfrd7W+sfx6R3Kfxpsgti2XE8D7Aky+WuC9aK4aWH13Laheb6Gt/4fvCZOCqif/GmUg4M+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 29, 2026 at 10:41:40AM +0200, Jan Kara wrote:
> This looks a bit hacky and at least deserves a comment. Ideally we'd get
> rid of the xfs workqueue and rely on the generic offloading mechanism. But
> as Christoph wrote maybe let's just get something good enough in and we can
> work on improving that later. In particular if Christoph has a plan how to
> clean this up :).

The XFS workqueue can't just go away, as for writes that require
completion time processing (unwritten extent conversion, i_size logging,
zoned block mapping), we want to serialize the processing on a per-inode
basis as otherwise the different helpers would just content on the xfs
inode lock and burn cycles.

We want to get rid of it for read completions, and a patch for that is
in the lazy bounce series I posted a few days ago.

