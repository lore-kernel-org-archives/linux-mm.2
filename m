Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7674FB3CE2
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 09:35:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F61B6B0095; Mon, 30 Mar 2026 05:35:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CD736B0096; Mon, 30 Mar 2026 05:35:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1322F6B0098; Mon, 30 Mar 2026 05:35:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 068CB6B0095
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 05:35:38 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9E157BB4FF
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 09:35:37 +0000 (UTC)
X-FDA: 84602221914.12.6C8464A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id EC04D1C0003
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 09:35:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="QdciE/Iq";
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774863336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xqxFktKd4m1zGsF/mrLF20s/UOZTrbps7tHG4RNCk8w=;
	b=Si5PY0yLo//05JttjX9hbtM5IaTpI882Tp9gATteq1VmwtFfNhraUUgsfAXqaFu0wVZipv
	1WPEcM/C7XkWDtKONtJObwX8/BZ3qqnSyJgxnW4GNbqbnISkybZWI3XWyRygGxCrmMKk+D
	36YSnpqN+MlkdBzW8Gn9wSNPjr9jguA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="QdciE/Iq";
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774863336; a=rsa-sha256;
	cv=none;
	b=4aitfakkRdeeDp7zn/gkNgW2k3tXVruwUrBE7etQh5YCqizX1H70iGggJqGHYuT6n/JXmf
	nyH+InWfeI37uoPod5TOC0PMYB04PErFtxzmLrNvcSuJ5ptCUE+glSwPH5iB6Cs44BljX/
	ymPy/IhV/SU8jQbVUHtaB+bnGl0P38c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C2E1640DDE;
	Mon, 30 Mar 2026 09:35:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B859C4CEF7;
	Mon, 30 Mar 2026 09:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774863334;
	bh=xqxFktKd4m1zGsF/mrLF20s/UOZTrbps7tHG4RNCk8w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QdciE/IqKnCA9XD0OWM5s5YkhSm/y9muh8J8bUhJJQyJPjn6Ei5DHqTrU9pgNpQUo
	 BfNxk9cw2nzYxKuVP+Km5hZisqvCvZZ4xwyWQKq+IpHN1HBf8K1J9BSG8d/DfnOq7u
	 rjMpHYFiTt0LqBLVzp2BEqan6ullUds5FUpM2xCBazbmbzkJpfjSBPDP34upMYI0Qe
	 aG7c9wmP4l9+sIDxDkWO4Bi6dhbInGy5BdUy+LtUpFCLdqKM1CkHHbLFKqWWQh9E46
	 7Ciq7//L8TkmO1pIefcN6KhA0YMPqIzJRCFYZfHFLLlG0DL8aC0FYDOpMe7ywTvOVl
	 oaxll3j2bzQjw==
Date: Mon, 30 Mar 2026 10:35:29 +0100
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: update MGLRU entry to reflect current status
Message-ID: <7f8d9fb0-16c5-4071-b310-8881fe389648@lucifer.local>
References: <20260326185629.355476-1-ljs@kernel.org>
 <20260330002340.GA116015@shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330002340.GA116015@shakeel.butt@linux.dev>
X-Rspam-User: 
X-Stat-Signature: u6dqams4mxtfyt4efiekezazj99natgn
X-Rspamd-Queue-Id: EC04D1C0003
X-Rspamd-Server: rspam09
X-HE-Tag: 1774863335-780186
X-HE-Meta: U2FsdGVkX1/ApGwI7D9pidTW6mk9dg6/sufZoKCGSnFoO4dF9Jg7moxM8Aw5kzXsuRvC+gdDamiiKzvNqo/hyW1gQgXWuaDw6dO5E63Pwyc1Ew7CqtjZGodWcjmQciqZVLSTgNA5kZ7P+bSbIKhVLxWsdJlFywZRme/1qKpQbDkhkZQgp7vxEDi56uSWi3sSuPXrnnJGxBuxzpv9YKm6O98vgmWJplHhH6gqGDmDS4W8vBf3n7i11gMCbDEp4Pn2fyG6xzQ3P3eItf6BBPdoiT3+XYrGfs9BkCPlCZvgbZ4usVT9l4tSb9oG14O56hqMzPsusz/wKwQhoDHgOxu8KWFkPCoO06dNz7dJKfQUXsO1msU8Cz9ZxYopYkYjA2OxpCe9IGvCFytY1O216ZoY2qwye4RNwTZugjo477lWv67rgSsONswR+rBrqF64WwBejLAEvKszoFVBovoVLE2Xx0Z2uoE2xIU/xX6mBRus5daxnjUNXV0ikEBIXfbsT8Ff4lVMtt4VJp4NKWCzMe4j71Lhdhmj/TUyghv2HD+V5a9SNiXkbhkVDJhLitQJfLKcYM+G4XEAp6H3WqQDoDr+ZWot/9IXfDI0ys6z5BgWQpQJs8MEyNYkO11iZbMhI0v1j4wbXxO6PULSp9ApiiLt+dj4zyWQVpUk6GNNNm4yHWu/qoPNgSpwdJZCVPi2YsdlAAx8bRRqqc/uevcO3YeM2tDodrrQIlmMPRlHnKujaw2ppMVrPGFek2uWZrE89oVaNairE+jm9ryU7S/gqnShL8kO5lkBGxFeg+vbfHQyg4CulB1ov+UHmPGdcQ4qpwfavqM6oxZ6DpybuR8ICTRaCfUaCF7kVXgkO63UJrdRTBs8fGON7jv7SiSBeODJrPtpn4bjpVs0Ytlsd+WFUwF+ooVYUqL93vTWom3PmiJ74/rNKg3yrvdZ0lUGAUYZvKNq1M3WJlNKg9WciYNp1GE
 +8MRkt4Y
 /5ATHTbh11GT/CRvirvLnUAEndwwEBFt7eEoVDFHo/gEOr92RUXjWYDFRk0Oo6PrIWyABNnxUVi7GBG+Blcee8mFlZLw6ufIj8B0JQUwhByiq2jiwX2a+1pikEUdJFhKykRyJqjX6NcrIBWbGbhZbXUj1JcKHhPePUTw5x0RVbq7Qhup/b3rFPn0D2rInQ1I1NEJqofTdOpnCIGnjxCopsF2vKNO14s5v4GEUZBYnW4L3ang=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 29, 2026 at 05:31:41PM -0700, Shakeel Butt wrote:
> On Thu, Mar 26, 2026 at 06:56:29PM +0000, Lorenzo Stoakes (Oracle) wrote:
> > We are moving to a far more proactive model of maintainership within mm and
> > thus put a great deal of emphasis on sub-maintainers being active within
> > the community both in terms of code contributions and review.
> >
> > The MGLRU has not had much activity since being added to the kernel and the
> > current maintainers who kindly stepped up have unfortunately not been able
> > to contribute a great deal to it for over a year, nor engage all that
> > heavily in review.
> >
> > As a result, and within no negative connotations implied whatsoever, it
> > seems appropriate to downgrade the current maintainers to reviewers.
> >
> > At this time nobody is quite exercising the maintainer role in this area of
> > the kernel, but there is encouraging activity from a number of people who
> > are trusted elsewhere in the kernel, and who have contributed relevant work
> > or review.
> >
> > Therefore add further reviewers, and at this stage - to reflect the reality
> > on the ground - we will not have any sub-maintainers listed at all.
> >
> > Each of the files listed are shared with other sections in MAINTAINERS, so
> > this doesn't reduce sub-maintainer coverage.
> >
> > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>
> Haha, I feel like I am shooting myself in the foot, but if I plan to
> make drastic changes, then I need to step up and take some
> responsibility for it.
>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

It's much appreciated :)

Cheers, Lorenzo

