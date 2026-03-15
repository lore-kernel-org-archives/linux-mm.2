Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD83410854B4
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 00:26:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 352416B0088; Sat, 14 Mar 2026 20:26:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 300746B0089; Sat, 14 Mar 2026 20:26:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 202926B008A; Sat, 14 Mar 2026 20:26:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0DD8D6B0088
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 20:26:15 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 88CC21B8D47
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 00:26:14 +0000 (UTC)
X-FDA: 84546405468.04.BCEF54F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 01AA640007
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 00:26:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aOm9hRGv;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773534373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TCEsKNfdZITSjpQyHiDAdP3XfiNLIzA5V24uQjjFr+0=;
	b=M9xA2isxk7IM2WydALDUxgK00kcE04XbY30XR4kF/nUBoxstduYm55Gu1Himuqcy02Kx3f
	I2AIS+BePZylh3u+OA1LZx/u3WLLXJruVTdJhjnkO/77EL4ULG5ZdY7rVY2Sem64Rdhnb/
	f1oWhwduoHdGjE6kjaQteEBS+xAuIyk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aOm9hRGv;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773534373; a=rsa-sha256;
	cv=none;
	b=y4py37ZNbHgB7OYt3HQqyZAjE8KfjXc4hjX5Yzx+fqHC142GskplvO4n0dVPk9FdNyVyaY
	Nd8xThNVLAuD0K1D95LnpjnPHNs8n5xaSc/YcUXo2Gl1/GDF5ByZBNqF4D5G5u4ZeYgQYY
	zns5VtpIaJLdrkBu4zwmaJjf6yzyvow=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0890441B21;
	Sun, 15 Mar 2026 00:26:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD42DC116C6;
	Sun, 15 Mar 2026 00:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773534371;
	bh=1sCvwrjbj+DjAx2QZdG6F13Pd2u4zTGhs2VeFPdIUyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aOm9hRGvVEJ/WNi1KJenyI8c+au+LcuSvcap9xpnOUs46n6Hzn3yMxewe9y/3RmuU
	 6vnJU7/9uTJS4ivQW1jxW6ZsGFsfMh9RBupLtXlRb6UcaHdlG9Xuu4VX8yRunm7G+a
	 WtzcPVgys/b1pAmUj/VhQTMiKsY4omLF0QvPvXTWw90t5wFlf7aiaZ3u1tff+/g60k
	 jT7C8VD26WID+hxbBGorJpPzPR8O12Ksp+DZP/vvImFAyCRxO9pND+THdVavTiCpXk
	 3Bi2t6dtzTGbDaO+Lil7VVpob1/29tSDen70kCxvZRYDqAYe0zh8pPyTeh5N6v7SvH
	 183AbuCSj2NPA==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH] Docs/mm/damon: document exclusivity of special-purpose modules
Date: Sat, 14 Mar 2026 17:26:06 -0700
Message-ID: <20260315002608.77292-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAPLv50rMiS+PBFh6BQ1f1XZAJu=1hMOaSx6ySQgeHxAY=i1mQA@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 01AA640007
X-Rspamd-Server: rspam07
X-Stat-Signature: j3uue5t9yojewi4txou7gegda736h9de
X-Rspam-User: 
X-HE-Tag: 1773534372-148988
X-HE-Meta: U2FsdGVkX184SwoelNybwaN3qJwo5qmCfukhiN3PiqwCnDrmSo3E2ljFoamK/eNRwloMpePEqmI3LgH/X6S4mCi11oL+vvQ8kkOpijRNghD+l43ZOmAzYTv6CZf71rsYiJlX4U+S5X9naxQ8sGf9d5fTZ9AVGeeLHDmXoRs2kig7WwxvnYMvPo03P5D9gnMGSLBgbCgylv366eemsDOlWX0cPa4mmZXqLwOAi/iefcfIOFLvTJfR0IIp/EHBz2AffbjzjEpy0jUs+jJcqi2vXfegBu5ExySZz+JfvfHYJMpK7+hENFGtgeLfSnFq+qbUqBVLqIoYTL4ha8/BeG+m35lXE1sw/r+UEFnWoqnwfRGJ2UPQEA0wpHkObHhGFudq/TkAhmZvLdLXJ21VIFyRdvZ+BHgavlTzmU/Pm6cmAA3XmjheUkWiSx1GcLMG5AyZTcAVPoqgAOxaIE9PcbdndfzrKLO6/9sllaknq5H76NnclK09cDX4vHAAT3K3U09l9KTHzQhwP+9yUcDJA6JM0X9dEslpL8VKUg/26g28Lrkh6yJHcxxbIAF2B6bntjiUOOLmB9o3KOeHm7mZlvnRemWKmwuuWDkuqMFbhzjfnGCJDI7c+ucJ2qv5uLqWQsMSSIgBNe9D2V/XDDpjte1jjbPh8LZmUKKwVkUYQ3JeBKaGfZmonFkG4biYebmW6Vgak//EfzRWAkkpCbE8CwEtFpp/hip+OIHsb1KRVr7MnoiOzAoOKe3yG8eK2eOwDJh+9TGHqPpbLpx1D3ZnhWTcnWC7o33XEAmZogsebOnDUOFVs3o/1kvwqURdidSHJXk1S5dCiWzgbZ6buoBVVdiwoOVW938Nm1xcYI9YJkmoSqmghqmSElYHDJdDif6wiiye5NOD346vFAQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 15 Mar 2026 04:37:34 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> On Sun, Mar 15, 2026 at 12:25 AM SeongJae Park <sj@kernel.org> wrote:
> >
> > Hello Liew,
> >
> Hello SeongJae,
> 
> >
> > And thank you for fixing this!  But, the broken "contents" directive is added
> > by a commit on damon/next tree [1] that not yet planned to be upstreamed.  That
> > is, seems this patch is based on damon/next tree.  As a result, this patch
> > cannot be cleanly applied on mm-new.  We prefer making patches based on mm-new
> > unless there is a reason.
> >
> Okay, I will make sure to follow this in my future submissions.
> 
> > >
> > > Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
> > > Link: https://lore.kernel.org/damon/20260314002119.79742-1-sj@kernel.org/T/#t
> >
> > I think it would be nice to give a context about the link.
> >
> That makes perfect sense.
> 
> >
> > Reviewed-by: SeongJae Park <sj@kernel.org>
> >
> Thank you again, this marks my first contribution to Linux, and I truly
> appreciate your guidance!

It's my honor to help your first contribution! :)

> 
> >
> > Assuming you agree to my above suggestions, I added this patch to the top area
> > of damon/next after dropping the "contents" directive fix and adding a simple
> > sentence describing the context of the link.  The change made to this patch for
> > that is as below.  If you don't mind, I will post it as v2 of this patch by
> > tomorrow morning in Pacific Time.  Please let me know if you have any comments
> > about the plan.
> >
> The plan sounds great to me. Thank you for taking care of the v2
> submission!

Great, I may post it tomorrow morning.


Thanks,
SJ

[...]

