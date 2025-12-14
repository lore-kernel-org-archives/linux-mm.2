Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62E26CFD314
	for <linux-mm@archiver.kernel.org>; Sun, 14 Dec 2025 03:27:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4509D6B0005; Sat, 13 Dec 2025 22:27:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FFAD6B0007; Sat, 13 Dec 2025 22:27:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 314736B0008; Sat, 13 Dec 2025 22:27:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1C9BF6B0005
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 22:27:10 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 786E8135BC1
	for <linux-mm@kvack.org>; Sun, 14 Dec 2025 03:27:09 +0000 (UTC)
X-FDA: 84216640578.08.E41B039
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8DE3B40004
	for <linux-mm@kvack.org>; Sun, 14 Dec 2025 03:27:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=WLn6X98r;
	spf=none (imf27.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765682827;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=daKyAtCUV+qOiVIBB6oUwMd/W2Iw3WrV8/lwVUqgVdk=;
	b=qgdZzAC0Metn2vNQZQcq0k0aH5CINRz6PdyD9yfTCnz9rr7FSQ3zYOhnwxkMwjwfBGlvRB
	qiZbjJNg3H0WdYduitFEzEBC7J/J4nvqIjhGzpeRqTxXowMPee7sbQ7hkUpcGUffPJ5/Dd
	2sWt71PLM6d0oQgOEhYQu0x29YM19SM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=WLn6X98r;
	spf=none (imf27.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765682827; a=rsa-sha256;
	cv=none;
	b=4nNi/QM4VBK5HAwkk1vHXGf0+3BMO7OaBAmep5Zy30Md6CvmC241zy/5xN4flSc2iXvrtt
	eeIJo5kdghM0i35utaUPviFcO2OB0fh/4q2Kf8lEaGgMmxhTWgoatd2J4KPX0HcnCfQEfW
	RL7gGoN0b9afop/UapXWLPl0M1wb+Ag=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=daKyAtCUV+qOiVIBB6oUwMd/W2Iw3WrV8/lwVUqgVdk=; b=WLn6X98rc27kiAai7WW2purgsD
	PKB6n2bP7EMLo9Pp0ws7+mM6eKdQlwNtQeE+E/YhV6MdDAgkSeOj03C5CoYibGm51ZliSFVXDODg9
	qG1d2iZjMPiZs6CKefsV/QPf0kHNL5EQmzF5Gz/KRYpwLaWFZlBbtwMGThm2YyV26ufmpd0gQxrM2
	lUqr2KPus2yAsz/nKm6I36FaT6EJeFGFeayXS0pEChOLLq3+c63uNHdNz7r59yjdpETdp8D4rSLqS
	BtNr72QOaHK/kw12Wixk1bzdZavqFztJ9xabDkrb3UHDuomnjMxvJUTd2Cigqfn7kbZv4Qyx7Y45e
	yVrr+RPA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vUcli-00000001vqe-1yAt;
	Sun, 14 Dec 2025 03:27:34 +0000
Date: Sun, 14 Dec 2025 03:27:34 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Hugh Dickins <hughd@google.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: shmem_rename() bugs (was Re: 6.19 tmpfs __d_lookup() lockup)
Message-ID: <20251214032734.GL1712166@ZenIV>
References: <47e9d03c-7a50-2c7d-247d-36f95a5329ed@google.com>
 <20251212050225.GD1712166@ZenIV>
 <20251212053452.GE1712166@ZenIV>
 <8ab63110-38b2-2188-91c5-909addfc9b23@google.com>
 <20251212063026.GF1712166@ZenIV>
 <2a102c6d-82d9-2751-cd31-c836b5c739b7@google.com>
 <bed18e79-ab2b-2a8f-0c32-77e6d27e2a05@google.com>
 <20251213072241.GH1712166@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251213072241.GH1712166@ZenIV>
X-Rspamd-Server: rspam02
X-Stat-Signature: dokfbzzff5okbpoochm6wj67j7z8em7k
X-Rspam-User: 
X-Rspamd-Queue-Id: 8DE3B40004
X-HE-Tag: 1765682827-401810
X-HE-Meta: U2FsdGVkX19vWiJiTaidQ5Eu3QSVPR0P3t7sly6HRQBqocSuSfH5FDyCm4F2hIIhvFXFZYSqzBYj9eqsnBmusQfyq01nXknaaKwnKSQRPhB4pwZdM03UhRD3CqNv0cZalREfvmJK2phOsJB9lrK7gIU0DLDb1YZmhGqYXF2jxtijQNN2qGfKvW2vRnwA1kkeBL7Um1q9KsnVvkKv8CVr1EVGt4XWqDXeRsifV0m4+m7pgU68cyd78jS51AiwK2oTRrSZZHo6uV+vVKZlNkFcVqdh3qCkRRqQ7ydd1JvyPy6N42wf6ceVF9pWrMqXpPfxuK2bda914uzTgnnnJokFgzQf5s3eo2S/ZiVWhpm3txjD1xbhRHKDefwmm2pKDz5EVmYP/wrB1NZokOwjzJrKH5hLugJfMqKh45IS9djN8B23TXK5GQ3Lv57pvNZ/pvTCaq0tpOAKhYfefPaf7mpELxbT48Eh5efz8rt/DGO7/vnHcHt0Vdax5EN62y46Xk1akTOXE/do5TTXol8n+KQdCKQCugMGqxw9+GnuD8cMQpJ0LfrQt/NFu4olPGwMktGRO/okAnHpddmvVyiZA6OzERRH2ryn17oNtfsnZvW+891Onr56gCtRey73FJquzeG7dIOGd9p8mgIlA+SIxVdYLpUhTDG7IlrXSvJ/LqLPysn7cBiL1sDkkSQiNaBqWRAp/B/DMyI9KOqYeUnwQDVVSB7SRifmDkC8346pLToSJuFB3foj4lyuhJh2EftO2OYOpCUzMQaraaCJZYclUjUOCPCvuRTsJc6Eadyy/ASu/5n/KVTZhO/MrFG6Q9DjiqqdsSYGHeFQFKs9wmon6XHPTCexturRwFqgdcaH4/4lmPKH0V8JCLtUCCOqiPsq06EDepfYLeMM2aWkT4JIwrNzPz8A2UvMJtLaaHXSMZi9zOJQ8JDVs/3HEis/4sZR3DE/z/L59xn+XJxwl43wvqJ
 pGEjhwwD
 bVd3LGOjmU9/iMXiDsMgJ+BtUplS9qJaOz4HhxNYh6OGQmPKfRg14Hapm533UCEjhEjy7yqxpDdi4JMNf/mpPsEdkFfYnh070NEhY8PuB6kOrpXd4oYsZjOIXrdbStU7KJfbLIcjkpVPy+mzoaN/73UGRq3VAzI2tQS+A/5Ip7uitxqUOsw6PZHZwPh5A6iad8RHjy6+de6+AzKykV/arkjHUd4X2T0W/GS+opmDJMjkGGD5dqlWpfdj6rVmJzbp8nMLrR4pnhXsUPdUebI0zkyVZGX+rCcJRa6YZSwcCsnNQazJI+qu8nc5NkzeOUIWcTMtHOMqeSbufU82eWrUUGRoXNmX8U/5kPrsVm6uoocl/Din0nVVhdRqHn8Ox9+UbHaGMR/DSyJtLzDjZJSa91uL2hV7Wm1e639sh2/Ix6ywLT9icH6WvPzdq0Yh8MQRssXhgYakaECb+rlIhZ8NZjPsvEaYnI7Gt4+VKBMUzvMppE3DlbYfkVii/AKiYR3NurkT2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Dec 13, 2025 at 07:22:41AM +0000, Al Viro wrote:

> 	What I'm going to do is a couple of patches - one fixing
> the regression in this cycle (pretty much what you'd been testing),
> then a separate fix for stable offsets failure handling (present
> since 2023).  I'll feed them to Linus; I hoped to do that with
> old regression fixed first, to reduce the PITA for backports,
> but if I don't have that debugged tomorrow, I'll send the recent
> regression fix first.

OK, I think I've got it; see

git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git #fixes

individual patches in followups; the first one deals with this cycle
regression, the second - with older bug in shmem_rename() failure
exits.

Folks, please review.  If nobody objects, I'll send a pull request on
Monday.

