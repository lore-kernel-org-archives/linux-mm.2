Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D572CD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 20:37:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DA286B008A; Thu, 18 Jun 2026 16:37:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48AFF6B008C; Thu, 18 Jun 2026 16:37:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A2ED6B0092; Thu, 18 Jun 2026 16:37:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 154E36B008A
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 16:37:57 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 87C9A1401A2
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:37:56 +0000 (UTC)
X-FDA: 84894194952.14.3859B41
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id BFE282000B
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:37:54 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=lGBv+lCY;
	spf=pass (imf31.hostedemail.com: domain of konstantin@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=konstantin@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781815075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FgYvUxkRhhZ1t4kqKiHc1yP0t1oilVAH8i82pg2Y2aE=;
	b=PkulEA9w48LWLSpPSP5eyEtBtlGN7BK3NXXdr+m9mgDxc3u8hHbD/DcSWJdFtS2cYQbLWC
	U/KWLD6KvJQ/b2fHMcs3MyVqSujMECMLCWlFtXAoW+GQW8dIxC3GRWgnVgCUYyONwcwdbj
	SzZD3b6u7kq/MTPn1nmHtQgnyIbr/Bg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=lGBv+lCY;
	spf=pass (imf31.hostedemail.com: domain of konstantin@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=konstantin@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781815075;
	b=X5AGaSTEQAM7e6MvagwMMbzktjEtHHRAIIiIBQOxmQsj3A9hp9Ld8Te4oAM6AjXrHFnu4E
	DokHTmRgNOiK87OssEnCsyqxKr+ZfJ+2tmLXxuoSpjj33WybRGsclD7X5dzacX8KIUYgOU
	fW7qUttPNm6yI0oGgI2wMRdQmEeUB4Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 971DE4076E;
	Thu, 18 Jun 2026 20:37:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 457081F000E9;
	Thu, 18 Jun 2026 20:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781815073;
	bh=FgYvUxkRhhZ1t4kqKiHc1yP0t1oilVAH8i82pg2Y2aE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lGBv+lCY1dyY/ASodCxpsI8G9aY/iPKrPt/+UjtiW3q7BTqSohgm9az2+ioAIo3Ar
	 FDz+3mldQkzcUB5v/Y1WNtw/VteSKN6EilfCGLakjt3kjnXaYW9EDlLthr93y67Iok
	 /6Byy9UBhkr7r7oVMjhx7h1z2zEKxcYLgTD6sOsI=
Date: Thu, 18 Jun 2026 16:37:52 -0400
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: pr-tracker-bot@kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>
Subject: Re: [GIT PULL] MM updates for 7.2-rc1
Message-ID: <20260618-generous-sceptical-jackdaw-3d32db@meerkat>
References: <20260617153144.acead3f2795da15f1e56005c@linux-foundation.org>
 <178179616355.2947725.4377157124023044624.pr-tracker-bot@kernel.org>
 <CAHk-=whn39dQtoMeJrz++nAnZpgnrooU0dgzOZXdn1LyxQ+f2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=whn39dQtoMeJrz++nAnZpgnrooU0dgzOZXdn1LyxQ+f2w@mail.gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BFE282000B
X-Rspam-User: 
X-Stat-Signature: pea5inyre6our16ssnn9cwypg3rfizfk
X-HE-Tag: 1781815074-960775
X-HE-Meta: U2FsdGVkX19KZA4YZ9XY4tmlcCOjZQrrcYnIutK4oILiRcc13fv926lzgYAAFVJy159KXNAwG+CPPQzPsRMbSYyg3/NJuJyqlixMYrqz9+I/JfCvC0qGWFCisDg3u5owlXNGngmVrikacmYIa6PI/0iXdhYNG4gg+eLygHdOV9YdtJ9PNAREIN/jhSvltfzfrujBiKiWFOOBWSM72+5c+IG0JXiJd2eoAbAiKKMJCYIqUpHogm9Dd/JjxJKjRfFugzwV8y5ZnzQ2QrdhgFDuBTdTyU7bk1sEuiatOSlWoN+JeWSeVjH2GJPkzQmtXnaPvmQVdquZLZMnyo0BtpM1LhlZg0cD2dKClNkagMhPbM/FDyMHtBjuJBCfvKGssl3vBXXGE6ECqEL0PFZdGogcdh5JWGXK0PP2yLFJqhxpj6r9rfvnFGhgR54Exgl6hyJOpUNbshcvIKe4DcINfDgtPjqytxG9m+pXT9pcvhhiHBBmywrksyp+2F+4WqaUhyE/qo/by23UsmQNcT3S2VtCSXcij7+4zGg15utwaM9ijEAe1DO2Z13l0fOIIUgsZRGksLT1qCrOENKezFyteCLckdCzwRsFFTHgs/8N3jDxmgWwYKX+tdBi443Q5RM7klbw8gXKgd3IOZGvx1bmeEgW4sjl1vHPOb3gPrItURSa9gEGKNcTI6Rh5WHLqy5z3I8c6JblZfBaKVXfsZxiPduG+gk5g9ZXOkRpism1kOMeEJVZg+1NF1wcIq0UcT8TjJFA+aa9RoRkRUqKCGEUE1EYmzYX8R9e/YjUSiirASCBBIpZfyxnFsukUiNe8gZDvkJNzjloAhQF7M/fnB3X5bx0qszG7E1pEkXsU3pV2YL1jq0J2OqBW3A2K1feS6uMKf8m655h5gY1+8wMXmuZyc8R+rq4wSu7CYfL+LxGTTUObxWURXZjbRFaSgXxDSX4HFOZr1lan5eFZ8BdOEIFSZx
 4VzFtMcx
 34NtKOy1Oo82e4792Lgr7ndLQdtVULL+k4hSMeYxylINl/4idYV6nK3yROgYOE1R2ly2Nd7vcS829hdI+bdJKxnEytglc9sHPhK23/EJLpnJUNBBlnM2WBUrcOIH+LatbkEHh3z83rN7hLL7iThJd+RXhApyQRyxMIRoahUhqSpUBKsCgYP+Pp4WJTi3evoaRUw8zs/Nj5bkTFjxL5RAY8uDww9NKJxYQ/x0GudNCelySON7xAX3xDcU7DPzSDSYsohCDayyOE/yDPA5Su492H+8UOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 09:02:06AM -0700, Linus Torvalds wrote:
> This is very wrong. That merge (2f9f5887b427) is merging Jens'
> io_uring epoll cleanup. Not Andrew's MM tree, which I haven't gotten
> to yet.
> 
> I wonder why pr-tracker-bot got this wrong.
> 
> [ Goes off and looks ]
> 
> Oh. Andrew's pull request is confused. It says
> 
>    The following changes since commit e771677...
>      ...
>    for you to fetch changes up to e771677....
> 
> and note how the "since" commit and "up to" commits are the same (and
> is my iommufd merge). So then pr-tracker bot thinks it's merged when
> the "since" commit was merged.

Let me at least handle this situation -- it's clearly an oversight.

> That doesn't explain why pr-tracker-bot thinks it got merged in what
> was me merging Jens' tree, but whatever.

I'll look into this as well.

-K

