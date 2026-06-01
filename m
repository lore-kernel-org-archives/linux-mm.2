Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F803CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 14:51:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E23736B03E9; Mon,  1 Jun 2026 10:50:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFB566B03EB; Mon,  1 Jun 2026 10:50:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5F4A6B03EC; Mon,  1 Jun 2026 10:50:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C72A96B03E9
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:50:59 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6BD7891186
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:50:59 +0000 (UTC)
X-FDA: 84831631038.19.0229BCD
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf14.hostedemail.com (Postfix) with ESMTP id 847DB10001A
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:50:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf14.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780325457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VHTi48tvZ+Tv5IhlWLI+j7INX8ZYSxvWSbK1pi7H3Tk=;
	b=14KnK70ttfxj2gFFYHJYhdc9Ek7vg4pXBK9HLuScjS3aWIUv10r3fSZl4fEoNsMa4k9AuR
	n3luwhWDBRGl/1e2BC6IHQDlxVzQB4scxf52mvw6reoOCccD8tgf6rXIm76GVWILdzgebB
	/a4twtP5C7eT+VQvKP9+1pykFBREEXo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf14.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780325457; a=rsa-sha256;
	cv=none;
	b=5LYlJ2+8TnyWUr3p85ITgskMWymOhsB456BPWMRZqtmHoOygRIGiS1FSWpDWNW59gTm8+s
	UPBDT0dljVGZHwm/qPdBg7Xyb2N+3CJRh2ZANK5xMXBFGU0Ww64iuSPu0aeeLUSztQXW3b
	pNtindd5dV7pHsfeZCEcUK1zTuU1l6s=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9ED1768BEB; Mon,  1 Jun 2026 16:50:53 +0200 (CEST)
Date: Mon, 1 Jun 2026 16:50:53 +0200
From: Christoph Hellwig <hch@lst.de>
To: Baoquan He <baoquan.he@linux.dev>
Cc: Christoph Hellwig <hch@lst.de>, akpm@linux-foundation.org,
	chrisl@kernel.org, usama.arif@linux.dev, kasong@tencent.com,
	nphamcs@gmail.com, shikemeng@huaweicloud.com, youngjun.park@lge.com,
	linux-mm@kvack.org
Subject: Re: better block swap batching and a different take on swap_ops v2
Message-ID: <20260601145053.GA5268@lst.de>
References: <20260601113449.3464734-1-hch@lst.de> <ah2JOjCiDqXvPci_@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ah2JOjCiDqXvPci_@MiWiFi-R3L-srv>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Stat-Signature: zrkwfbsrfr4rqur9b1rhwxzo6zr79tj7
X-Rspamd-Queue-Id: 847DB10001A
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780325457-378974
X-HE-Meta: U2FsdGVkX1/OvaEqn726Co1m2Mo/VdpEqgh65Bj5UkGqtb3VDVVsbkrRqR0n4Z7M2AD34gP+qipZGdrGUGUdHiEVm2oRv7H0Fu4rtdfQHk7fPm9NyhfSBk1BuI6StsxUUtvoEecYMM+Cvk5MmIv5JyzA0KHZAb8cLltiJkDpxzsnaEG/o+W+0Ac0EeL9opN6GFV/YuKUSJ+akQr8IO+LoNSjSY+KTe1g2ur/KLbDi3ZTFoOgIpDUlCVmRcsOmBWQ47Akmd8xuL+xwabIwcBfbWH8x4iNeI+4jnwl9C2jcFPH2mqyXaTAdhRcRolAbgBzNfRuXFNoZCUzBIXAMbCSPMhCnAj36zCWD2pqGoBUF1JJXQRIuNKg4ZdR6Xx0tfewdIBIIMtFPJgXfiyd4CL583z049Dy8+7kVrXPzRxlKO73jPEGTFSC9FZd0q0pZdSB0CpFh8Ob6OjmvP18XMOUcCn8jcBJdjZ/6Dk3qQlieKYgizKYmp2uwpL0Hjub9NvcggblcWzIrTna/MoKv0XxMg6ah+UaRNsMLk+shhPfXUHzaX94hz7dC0Y5KC/Y4hz2KTj0e1aJ5DduhT4hqDNmWI0Te8w7nqGzYfa3gcQZKpLWJP3xFHbSbjnNitVubyHz94W2ZvV2/plWsQrJL+FQyN3HDfL8vgxnmPeLu3N8UGMcd4Nq7tMzMd9CruIKgKo5Ux85qqVI/m2aW+fh7HTKt480e9vSMFEIHwdTl+bhjItbtE7e48k6WZ7UY7L+Er6E0YqQTgKHhzXsZDwPpdsg3fEWnQh8GImeavc6PJzv2aWvDvWQUUA6Ff7jgW4iEk8nK/HWWXe5lTQ34KqhAtXYJhsTnl7UbGXQWk9uCyhdi5U33LPjeynHi9zcEgpNJ5UPLBcVXbmuJI2nFvtWdjkfxJdAiKpsq9tmWuqzVtut17WI/7utuoaB+yyHkmx2l/3bvl8qJARs04ODZYJfV6k
 XWuihL2D
 sl61G59WsWAqSeiVUOIWQu4WA28qoB/SWYYQGxc5ko3BjdcrRmPOHsfewVa0FoMuN3kMYUZRJN3VoRaRWgDW3fnrtVAfsANJ1IlgqIQrlnKMrzTWuM5+J0eIJ8UYT7az/qV1zB/8hd+QFR972O1JRgnBqBVXx4qWvQdKb2K4p8KUouIWq97+WTV7ZUILFfyQOl1OOorJ5LPACvGZnV2jT4lK1jQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 09:29:30PM +0800, Baoquan He wrote:
> > this series makes use of the swap_iocb for block as well so that it
> > doesn't do inefficient single-bio I/O, and then rebases the swap_ops
> > from Baoquan on top of the now very different method structure.
> 
> What tree is this series based on? I tried the latest mainline,
> linux-next main branch and Andrew's mm-unstable, all failed. 

The base is:

commit e1af79f3291a268adf4e149e1faba3052743e898 (akpm/mm-unstable)
Author: Joshua Hahn <joshua.hahnjy@gmail.com>
Date:   Fri May 29 13:27:54 2026 -0700

    mm/nodemask: correctly describe nodemask operation return types


> And by the way, usually we add version number in each patch's subject as
> "[PATCH v2] xxx ".

That does sometimes happen but is rather unusual if you take a quick
look over lkml.  It also isn't the default for any normal patch
sending tool.


