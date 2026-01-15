Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0A66D3CCB1
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 05:57:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F32CC6B0088; Thu, 15 Jan 2026 00:57:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB5906B0089; Thu, 15 Jan 2026 00:57:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC2416B008A; Thu, 15 Jan 2026 00:57:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CD6856B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 00:57:33 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6D4611AD68A
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 05:57:33 +0000 (UTC)
X-FDA: 84333141186.21.300B925
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf08.hostedemail.com (Postfix) with ESMTP id EDE3F160006
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 05:57:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=GLsVxRdl;
	spf=none (imf08.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768456651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aO8IjEV3AqaUA0VAtyH8dY/Ue4Mm0DNZe+SgvViKDiA=;
	b=1jvCz4eBoUD4iHRsMPqGCqMtLT21sm+mYj37AOu2wf4cas/5179gC6bN3QBREmxgq0I9L1
	KRNB661e0auJcRd/fODSZmAbE7uGGQzM7awJ1pMaXUfoYQa+aHbIyqZNPwTJRv7zDjWAYy
	jTlAvzZyQabYWTk3LaDSATQp8X3UB6E=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=GLsVxRdl;
	spf=none (imf08.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768456651; a=rsa-sha256;
	cv=none;
	b=Cr3BmWcVqjZHEu2WK7fVlOLcqi+6+9TaC2c+aXKUuc2uk1BCzCyqs5APcue3bd2/Be3Dtv
	CI3N3H7yrlsBd/Rl9eYYIUaHNEe/UKqwFY5CwU1gIUVLWLtcomji1Eri4vwIwTqg90vV5+
	1C+PtXUmDIeOj4rqf48GnXk9YGgL4+4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=aO8IjEV3AqaUA0VAtyH8dY/Ue4Mm0DNZe+SgvViKDiA=; b=GLsVxRdlINgsZk8FkEJlY5nY1L
	pockPlKwDJGFY6IYuwUcG8wytD9keK+kxdBhlyowFAGYqkf7+vP2dlbA0GDAeBi6PUTOD8mDKLzVQ
	ihdt4lIZfZnjl25nQosn1LR5St0WHx2jSZvsxnbFrlq3BRCvrLOQTBY+MXPLLCUPM+NY3bMz6ky6a
	8ekt7ybnielyOFl6c7kVnoMuwaPtLqJQE3Lx6qB8MUTrn+xaQiywvEuwEZbKEVjcZXAid1Ul82332
	6Lrodjb4XaYIjnQTbFpVFCpceorf4cP4WhVivwqevRVss1wCn2DKr7cxSN8qJLRFtvc4v3Ru5dVEr
	Muy6BCGQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vgGMB-00000007HBi-29MT;
	Thu, 15 Jan 2026 05:57:19 +0000
Date: Thu, 15 Jan 2026 05:57:19 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, kent.overstreet@linux.dev, corbet@lwn.net,
	ranxiaokai627@163.com, ran.xiaokai@zte.com.cn,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] Docs/mm/allocation-profiling: describe sysctrl
 limitations in debug mode
Message-ID: <aWiBv4A4QGJ1pr1l@casper.infradead.org>
References: <20260115054557.2127777-1-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115054557.2127777-1-surenb@google.com>
X-Stat-Signature: huejjpjma6if97m5rhociok6cf4qc6op
X-Rspam-User: 
X-Rspamd-Queue-Id: EDE3F160006
X-Rspamd-Server: rspam08
X-HE-Tag: 1768456650-253406
X-HE-Meta: U2FsdGVkX1+dj9+rWyjX8LS+LnOitGKm5afnTUq94ChgZ7fv4bqOB91PFQDbXBYJpVP07VP69V4rYallqkfb+12YHk4hINqavL4t0XtHSAfr5OZfuQdscyNCf92DY5F7APZPDMnePuB8lR81cDsBnyYdO5/wCQKjieIPCxDxwtpVifcZIat/+8zdIfRwqA+opyAJJIueiCqlHekNtAZMtmPhG84mVh+YmTk8TWwhmDG87WxGVRPqaGQB8BCHDepZB59BxOyITsNOMENXwbReJSPEwvArsgtoZzSg5H53RLZ/WdeeyDPNPImwMmBxIsyLCPHyf8AAQfKRpWD1Nx07jP23ZiQszs9b4gYxXKGxVuDuXAOnE1vr797I6xE7OvWxVBNLqOarZuCrE+vPNuFXjqJgxhANDkDchl4qunsHODmvUjlFThYtPClNs3/pm2m8SRzLJAcCwVyxEIBstgPYXVBD/GKI9lbQ5Tl+A5zTQ9F3mGzxoCQyXOul3r8a2PA/NlHWV8xmLQtKJPQZXexE8DXU98L3FUTYxDsEpkSYdhj5mSLw/4VUQ3HK8ktjht9VBYxzGoBtCgn95MrNqG7XjY5MhwuxNJrrRJ7tQb8LKOTUjOEUqhNEgc7yOEFwAqtE2DLvgEA+nXkxMYnV5F8U+NActNow3P5WaSErvM/XP4/+VuyIY+WJfQlgMMSrUeZCGCAErigZ94SNuSR0cMMhiXSUbhOv79p2Nm4hmGMidBlxuJpsTPD6ytvqZHukjgx8SrnUHFjToacslKCA98r+S0ciNR1CB6hUXBaZnNsvltldiNrONQxmL8xlycjppD7pygy0Q3Umtv8m7gDNYe+wLrk7yaFfHQLL7lda5mxcEFE7dPmnnWYJwYOf4klXHksuvH9C1aDq4jhP79zyyhx1hSMVCECtuJFYelaCQ3YQJVHjc+A8hGtqDpkA6pQEee38IjuJKzkZVGpj1sZqfQo
 q/eitNnQ
 Paq0PhOOD/IBk76i2LgnSMjKPfuYaQk6L5Zsc4bZydAv0CrcXB9pafeFy04IMYBMz0UDLU3ZtPxMOkfcpCD48PgjFm6jR5fw0sjMcxlZYE940qnBBV7Sywh+nW7z2Kqn1fDuY9OOJFpxFrTl9A0ocbe+/o5U2mJvhjnkcRKc1QlaHy2gEsMKnNqdoEYRkGADJpVDNWzk55BTrQmPbgW4gXUD49Kve3PvG3jC7rUcGKQ6fynn1yDC+z3C/bA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 09:45:57PM -0800, Suren Baghdasaryan wrote:
> +  warnings produces by allocations made while profiling is disabled and freed

"produced"

