Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51E5DFEFB70
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 17:56:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B72F96B0092; Fri, 27 Feb 2026 12:56:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEEF16B0093; Fri, 27 Feb 2026 12:56:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A188B6B0095; Fri, 27 Feb 2026 12:56:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8D57D6B0092
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:56:09 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2A706BA86E
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:56:09 +0000 (UTC)
X-FDA: 84490990458.21.EF460EF
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5A3DF40011
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:56:05 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JC4MJHjf;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772214967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ueUWYrLBvbPWDOW6N12hfvbVAzOPqz9SN+vWu5wWKDE=;
	b=MRae+ITlLV6ByjAtPuizWd+IOG04CJQ+4zjihK5ZU3ydc+cWVF9Xz72yqyqL1d5I9IdYrj
	LTsHIonyh9xeqMdDz0jwxwo7lr7C0KkY9y7UFED+WjFg8vuWnbuAV11r8N8nCVyc9AMJKe
	XFaAcgpol7BaAc6q68Qv0Sc/dbE4zf4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JC4MJHjf;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772214967; a=rsa-sha256;
	cv=none;
	b=3pzDnV6QvNUGnbP9uo4/Khk+PA5/J4VnzMFRXiZfRMsbwBCe7j/jUQm7HyA2AYgc7wKdoD
	A36wznubyTSCdwbr5Vvx/LYJ8HMpT3b/Rrx3ui7QMKX/4KUkcTfr4IRLi6XnTdUXdS1gBx
	nwR6+iOAHhUaBtmt5GoheEtqzMdk8yk=
Date: Fri, 27 Feb 2026 09:55:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772214963;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ueUWYrLBvbPWDOW6N12hfvbVAzOPqz9SN+vWu5wWKDE=;
	b=JC4MJHjfQx2Zd7VAO8LGdoVf95ZH38LcUcc7Nft8V8IcMcZAUxmKFlpQFfOCGBTZLlMwHA
	+O53ENA8gd8lbswoE5BIMJ0ZKi7IYAaUF4Q1a8t4Qu+Xy67rqz/hgNRXlqtL5/yqVRn3l/
	RlYfpBowwzOnQLzkH8nUG47CO/Q1gZU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Matthew Wilcox <willy@infradead.org>
Cc: Kairui Song <ryncsn@gmail.com>, lsf-pc@lists.linux-foundation.org, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	linux-mm <linux-mm@kvack.org>
Subject: Re: [LSF/MM/BPF TOPIC] Improving MGLRU
Message-ID: <aaHaSRXNLJNLwvKh@linux.dev>
References: <CAMgjq7BoekNjg-Ra3C8M7=8=75su38w=HD782T5E_cxyeCeH_g@mail.gmail.com>
 <aaBsrrmV25FTIkVX@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaBsrrmV25FTIkVX@casper.infradead.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: j4cu1sry6pgoacm865wpzfi7zrt7tc4m
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 5A3DF40011
X-HE-Tag: 1772214965-893847
X-HE-Meta: U2FsdGVkX1+SlPhYgpcmnXOyhz695VC9OL+sxwvUcf0vgsId2qK1YfbJZnwPJnYDkuTpZcrJjLePl0JqoH1GeMkVtyyByMVhhKPv7uTlsrX1kR6VqHgDZGXhloiY2GbUDkAMzDnIwmq4ikM5pVUHkZ1sk4vl0QgrtzqXgepoWI0IgAyGIIllxCbp2rM45HZ2IposhdppgiWdGsAaf9y3FfDh4ISciWIF5fq5ZouDTsgwxl7sp2njpOSN8hdsOXEzgJoHxGiHIm1vQMVcMEjGIAIbrexOHtXsqd7usZ7HpDAoVP2QmUY5xB8aTaVT71BOn1PEgB8ahwqcCEJpSQRNL8MtQzXAR017ur70yOPt8N6T4WXrm0K86PFwvnCh837Dr/Ry/XQoDJaQGZ6/OlEfdk/+OA4NSDjlMgaEDxrz9N47uhu+TDlHG5sFy0f+Wix7a53zOuzInr4W+yuOXRmd5QVXNwfnwamlCfX4ZVWU0eXg5Pwjm+DRBmBQAVxi/77BmPH80WajD85UflxxmHIYUBv+getj+ccYv+PmD4+kbL1XxMXEDfOG2VuJhk4Uo5WOdykqS8Qu/WdoKtxxqqyIejlPMelfC6sC5K9HgXqqZIb4/lHPidT/SuKy2VFQ8AA8I4zNiHhywHS07PaJ+SZCx05o5gNWbyHC8PORBK4CXrSJOHWveMDTriVMAsES/qFQK/iVn1DKyk69QnmZKwct4QR2Jb1a7CZv4ixOWhpkcz2bl2m4i69ul1G2jSihJsddnHsfAuv1RgHtwH9ijldIZ15Uq5nOrLcQSy8CfyatWFHJFnYMTbpqzYZvdelw7xGR+pk5C/I7WtOhgQgL8CWdOxZYzRgiA4rmvmUM/XN7kxvqBmXluG5N7cl8BI5jIMH6FtTp8vNAomDpoIbOZw9WTQSvoeUu65eKC4XmZbVOGuRUokHt9mcInFq/Okns08zsGMax/UNtPGWC9NjUXsY
 dZSmvMxs
 J4UC25o4bURAiXHWpT63qzTD8EDiQ8edSbRUAg8DtxsJHQGdJUF5ZxU9t5HdOnIHt8//j30dbqbe8ACoCNVoV6dc/MjpLMlTTDuZuU20rxFQPeSkhld6WnVR9yw1L+vEet/HqUTDSmiPRIXKMmQSe1MGit0Y0mbzNg1bnJcseCaImixNzbKofFbH/ZFhhiOK89x2McbFZfFKETHsgaq0y9+YZyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 03:54:22PM +0000, Matthew Wilcox wrote:
> On Fri, Feb 20, 2026 at 01:25:33AM +0800, Kairui Song wrote:
> > MGLRU has been introduced in the mainline for years, but we still have two LRUs
> > today. There are many reasons MGLRU is still not the only LRU implementation in
> > the kernel.
> 
> To my mind, the biggest problem with MGLRU is that Google dumped it on us
> and ran away.  Commit 44958000bada claimed that it was now maintained and
> added three people as maintainers.  In the six months since that commit,
> none of those three people have any commits in mm/!  This is a shameful
> state of affairs.
> 
> I say rip it out.

I have very similar concerns. Though rather than ripping it out, I would like
we put efforts in unifying the two reclaim mechanism (traditional & MGLRU) over
improving MGLRU.

> 

