Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 448DBCA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 16:37:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D85106B008A; Mon, 18 Aug 2025 12:37:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D35B46B0092; Mon, 18 Aug 2025 12:37:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C728C6B008C; Mon, 18 Aug 2025 12:37:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B1BF76B0089
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:37:02 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5258E118368
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 16:37:02 +0000 (UTC)
X-FDA: 83790432684.22.3A5C420
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4E00AC0011
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 16:37:00 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BWQKoTOj;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755535020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zyF8w0ug34YvP5h7YWfOovC3eabcMuzPu9gaq703vMM=;
	b=1kCD4b/Tm/KdAcriT+yr//fErqZMZdn9t++gsFs+Z/GRjnirBCDJj5rRSjGBnjC+RGzCaQ
	r9usIXTZ3tnpdD865q65um3Ds/WZVhjWvibGh5gwpYKHohBNAIInxpS64hD/gpQIoTmC1Y
	6iY01fRgMjKoP531HevxjOJzP/qpvK4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BWQKoTOj;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755535020; a=rsa-sha256;
	cv=none;
	b=05SnE01b5SbmaH9zTcqV0Zdi+TIjUGOu3Iwo57qZLpu8JEW0M7TS/MJ3QSJjwH16RpD2Kq
	/+NDfWbfEt0Y9YiZ84f4LIQFivkSOlz1Y7p9myflVC7/EOxaBaWBxh3AwH7+eM9Rb4wdIX
	qfNXdHs2MZpLV2uU1U366SmbG3VnN6Q=
Date: Mon, 18 Aug 2025 09:36:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755535017;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zyF8w0ug34YvP5h7YWfOovC3eabcMuzPu9gaq703vMM=;
	b=BWQKoTOjJAeg4ipv6fK8Ni7Adn19kl83Nn8j2/nL/VJeDPG13FOQHnsIQM96vulIIi2LxN
	W1tkkuQTVtgtz56jrp0ILxSONjpanH3QZC3lMFvNO5hFWyOEoeD83DnEwUIXx7Jj9gC4L+
	fqR41CjDwS1kp4FtVdlWSSJJN1SjesM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: syzbot ci <syzbot+ciacf14517a343602e@syzkaller.appspotmail.com>
Cc: boris@bur.io, kernel-team@fb.com, linux-btrfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, willy@infradead.org, wqu@suse.com, 
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: introduce uncharged file mapped folios
Message-ID: <d63fvoc3ans2d4xsuzsavchg3g6b3a5ao6osckrkwgwe3354zq@fp5nxj23krys>
References: <cover.1755300815.git.boris@bur.io>
 <68a19424.050a0220.e29e5.0065.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68a19424.050a0220.e29e5.0065.GAE@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 4E00AC0011
X-Rspam-User: 
X-Stat-Signature: xk45r64uctw33hrbhamuwmoadqasbaoj
X-Rspamd-Server: rspam09
X-HE-Tag: 1755535020-331713
X-HE-Meta: U2FsdGVkX18WwOmBCBMCvMqbykJoRxzJ6WAasSi5vl1imWZ4t0X7BzEFUbW1BkLwKvqvgFr4mIjIXdReE/u8CsSiv1obIwVoKAN7vQRUuC8jihPpcLVKU62L2oKY3PC5eaG723PksxgaFI37flSGcAeHdA54Z4oyYQKYaBj9T1ayAXwaBASDUBHOeBEgNx8Qb30AuzlwV/jE4A2KINaKiuUgEnhF1hDPern4oO954MhQ7cpAEx8Nty+kc636WKBVF2PGGv9HgBYPPqZ0W5PddjIBnoVdD79ZtJbQIe4FJXKfeVaEeiT6QCBsMEcdHVveXGTB4hXDV6DGhMq3MYCzC84ru8qWDrW4jrUEspZv2vzjsjv/4oUKu8fRBrVgS+wfM1tJ/imsmnZqETiNtcvz/+/qagAEmUD6wDzCAVDMncKGYMyEP20kPGRepJHx29I1bcgK+fPSNXC5uYGLqHlSu6l+HDCHLr4o+UnEBT1F2im6NZx6arMYiYpgQuLfkjvTjo1kLxJZ0WCFsB7Gk2QUMqyxncZki9Vb8DAD1C1trNbJe4XJvrPqEVmI9IiZmrazBuBQH3fYKtlckAxr/h1K4efk4JFdWF/+oKLCG0NzsRJqgPW8isvZkBDEJI3S5xJOh16H3xPPKhyj8PYANVNfdnVqfWgaoN2jYUNndrEj5Xfo8ekz/j/vOr8qwMqAPiBRb5u54QhGcGC7/aP15mT+HCCCZRAyZMPpWyuivm+XFd3M2s6GUb9zCvsstb0CQQ+s4ZGf11rArM+4hUCwPxldY1PXKGAumnZTa7mzYi/hCE7HOsjyikS3FGecPocGkKZrGe8ikMJlcXb9r5WXVBSIN7Bk+zZyEa6971Si5QKSUkFnxTB8XixghZohVeIXt+MtEfRn2XICMr2GYLMNGmXQ/oImzcLxErKkoEjaVRGRbLJE7wjpwK0xK8jdLKK/roJ6g/FWucWHmfs0b8qPiLS
 7UE/rx4R
 UVb2yRqFh2y49IFUcMLYBBXbtx4yC7c4hJhGOPxjY31c2zFLl+RnOZ0MMHQi9ocbndFYU0QlqZdd+52U1vvYBQX6A2bjTMFTZlwVje24x/c5CdI4Q4RvjPHgiQ3PYtsrMopWTkgbiK591URDg/8dUEf8YFFUtJGbSwfBpIxuvxaowkrGPr9qI4yaa7/fDzruB9PkuuoHxXT2qKeP5UVY0XD+xpjNb6tVue84sCjnBengCeU+ME1KlZ3DhTa9lF/AFXn49GYngXVZKNj4I8v7c7piGxacP8MVeds5p4Fd1gOOYg/aHCNeFfXL5P+sAQE5a1NXc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 17, 2025 at 01:34:44AM -0700, syzbot ci wrote:
> syzbot ci has tested the following series
> 
> [v2] introduce uncharged file mapped folios
> https://lore.kernel.org/all/cover.1755300815.git.boris@bur.io
> * [PATCH v2 1/3] mm/filemap: add AS_UNCHARGED
> * [PATCH v2 2/3] mm: add vmstat for cgroup uncharged pages
> * [PATCH v2 3/3] btrfs: set AS_UNCHARGED on the btree_inode
> 
> and found the following issue:
> WARNING in folio_lruvec_lock_irqsave

Ok that is expected and we need to fix the warning instead. We can
either remove this warning or make is only applicable to non-file
folios.


