Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF7D7CCA476
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 21:31:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23E0E8E0006; Tue,  7 Oct 2025 17:31:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 215B38E0002; Tue,  7 Oct 2025 17:31:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 179CD8E0006; Tue,  7 Oct 2025 17:31:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 093628E0002
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 17:31:31 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 96E27140333
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 21:31:30 +0000 (UTC)
X-FDA: 83972614740.22.6170404
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 87F8E4000A
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 21:31:28 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fMKH5vkd;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759872688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6IvtNS3uo/XgOa5TX20Qh+BTwg8wn+aw958X2Z7DeeM=;
	b=W3LVc/4zRv04q9ydvxQ1aJh1JYUM+o1Nsp6Vccc5WkoHbsFEBTNTFlC5tPA0b8YOBsNJDz
	C63CTYv4JkA5NxsxuHvqgNKbeXouns6erGUZBsn7mPeEBnovZ2h5pTDSQdBiOqJ9oJ6Vvj
	iJhyiGYEdDB6KngHTyqoJrmnjUFMwX4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fMKH5vkd;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759872688; a=rsa-sha256;
	cv=none;
	b=qv2zXFyTOOCT8gQO2kNCEOPP6W0HQMoNO14rJGKVxD95y7z8h67b7dbdP5JOE1LOdEHtC6
	2/gV1CQhP+QO6CJzryiEdpPVIADRfHqNkPkbp+ADxM3cQ+gVn4j3pXAyU0RsF1M4pODYrW
	XJ2L4TtOaIyrxmyZuB6BqKro+wgeh6s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7591A60219;
	Tue,  7 Oct 2025 21:31:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86E6C4CEF1;
	Tue,  7 Oct 2025 21:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759872687;
	bh=OcA2rmW9ILaz7YK3rji/wcS3ixoqSNZBjA9FWLhRmfE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=fMKH5vkd62MjcQveuUSO/Qm0wH1HnevbRZA3K5NxeKcaOzmJrfibwFugl2Sln/sgr
	 UEmsTTe8Hch2qFnQue4qQ+QfkA1qHD0DbrsiTbW3CVfhmfW5YlhzCHuK0E8vboAGE6
	 oOmgRanNGYvyQO1cL0YVs18r166igYmoHW6Th2pY=
Date: Tue, 7 Oct 2025 14:31:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@kernel.org>, Baoquan He
 <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 00/10] __vmalloc()/kvmalloc() and no-block
 support(v4)
Message-Id: <20251007143126.451f73cae2d3d7f5a36e4229@linux-foundation.org>
In-Reply-To: <20251007122035.56347-1-urezki@gmail.com>
References: <20251007122035.56347-1-urezki@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: t8i7zafjcu7w1do7ehpr6wc9zcrp8rzx
X-Rspamd-Queue-Id: 87F8E4000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1759872688-88672
X-HE-Meta: U2FsdGVkX195ER0Vs6Uk91sNTXIBiHl3/GQlKEV69s7PFB7Ffo58jABFvJDwtXGL0zQ5cxeA6X90fym9S45uJJzO1WVNGWOdlyidN25G0HhCA5SREsQHAbHjMd9/IGjg3lIKw+/3iZeihC9GtGbT2L6CMKapyRxSNijMdPxjEmi73FB1yR9VmHWKZNFOnQAnH7QVYlLzXQWl74qOcsEYnx561BinJ9H1048utWTSdsheI2uGwxfMqcBaohHBcpyxBJnPvAdEbwVVi61rcnWi5c7+zGVtH+R3Tzq1tRumPb6hlqMzvIGsb3z3qrQc5YE+2C567yE7a03+2yuBr9O+EViF4YxkHGmHPtsySIJElmffqDPOeDoywr2AXJlbeY+NUNCOfoNhoTuakSNmiCsl06MnxOYQPSS9WdzRiGTW0B70Bst0OkGj8qbD5n3SUF7ohq/UvKqwaaFdFdwEJAI63EcCYcrPd7mZcIuFnaWn96pYOGNXMecfON6FGsjCl/tTIyRB4WoHCORpzjlubtimXLlvkuU7cSNHRJwWqHVioDI4mKeTMCEQgD+kFWjlNcupAZLpbaOrjO3O2tyEfrEA2o8jsQ83XSXpbjojR9f4qSmwQyR3RkRJTFQHM2GSvJPx/RIFnlQb6nS4GzcsP5vhz922wPprFtuxj3s6pVXVaotFeegBKMZ7YM+7B/BXABV1qme8dybr3AAgfTDN1ZPJIjLT+g42kWdyCwsilnSgTGgdJT4DBOrfxoiJNtQ8bCxzjZvYe+j5jS2nvi8xqtwX7nQraZ7AI8ZWY8F8im+3WVANybSaRd4VC9UUnhbmi+amkSIsV0W1Wub7kYSEyom9FYBPc24gc/FylXf4x3sxMOvNUd00NEhesNUBQwK8htLIKxi63aphobfOEHBTZOKzwcDqfmY6PumJyj/g7q/rEb4SZI/scZoIiUYEeQ8N8LV2gyy7qVZRs9I1RQhe9gS
 5LKjm9pd
 aiWk05onIUyB6a/X4EZSjtkqYUAXP29uBMY80q2Lra6D6VBWa4kF/eRfJoj1Ibw0+XkaUItPIeNv7VfyLRL0blZ2hUXDO8rsmmNXnbBNEgwPZ6XVKhMYyH3BRibNotvX4jyn4JeHby3F5nAAYz2Y7pGC7woQ37thFj5YhL2IflE1lDpGXodYoCKqCNY0SPN6DUVHw6iudYsfePmyE1XT9NbhU9LBrQAWKXhDXzH9Vdz6hI20hqLOp9EHA/4SXoK+iRbVXPH3mbWbE6tRY6FctdftYU6ppvS49lxiOV9R8RE48BJWrafA9vBz4M8EF7cwwvJ6hrzKhUx/w7Ns2cv2MSvzvEhShAkXRidp2BItXT09yH7r2X4Erm66r9H5oaXmWq5Z03lCDEOAitHBbsvLRuRxnEg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  7 Oct 2025 14:20:25 +0200 "Uladzislau Rezki (Sony)" <urezki@gmail.com> wrote:

> This is v4. It is based on the next-20250929 branch. I am pretty done
> with it, if no objections, appreciate if it is taken.
> 
> https://lore.kernel.org/all/20250704152537.55724-1-urezki@gmail.com/
> https://lkml.org/lkml/2025/8/7/332
> https://lore.kernel.org/all/20251001192647.195204-1-urezki@gmail.com/

It would be nice (and conventional) to have a [0/N]
introduction/overview, please.  I went back through the previous
iterations and could have kind of used
https://lkml.org/lkml/2025/8/7/332, but that doesn't look very
applicable.


