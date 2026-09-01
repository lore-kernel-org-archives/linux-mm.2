Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5D5CC61DFD
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 00:40:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 984086B0095; Mon, 31 Aug 2026 20:40:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91D5F6B0096; Mon, 31 Aug 2026 20:40:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80C956B0098; Mon, 31 Aug 2026 20:40:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5B7276B0095
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 20:40:48 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 14BDA120312
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 00:40:47 +0000 (UTC)
X-FDA: 85163338134.17.5F6B2B1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 76ABD8000A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 00:40:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZSpqM4kT;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788223245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3N8NIqIOxkcYSjk247eYz7rQGp0XJk93W3Myu5nHrNg=;
	b=IYZUO0PBM5BtnYMSGc8yf92UQEjJp/WaIpafdfFraCpLK2b3ehItzdQAIUL2MI/KJzvWnR
	czcaqgsWJlQ9iGdZeq+1hiD5+Ih9z5Le38ftaDK7EWz/FfOvtaYA8UN7Yar5ZyHXOSqXF0
	92YYPDDfCsQbpYULGhtLfgayy9qVCJw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788223245;
	b=IjLK9j56eB5CSawx7dkNrBUAIH1EoC/X1ogDt1UDVbEVEfCVfWqtuyMq7gvYuh1UvVaQaQ
	tP4x2yfIlbCdWwlXQfzGYtv3yyEOQdd/k4aCxgB6hNspwVFOFSE8Rs11IHZua+5jXGZYv6
	LW3up/223hC3e+R+WvU38ba1i24J55Y=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZSpqM4kT;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 06100601DE;
	Tue,  1 Sep 2026 00:40:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7228B1F000E9;
	Tue,  1 Sep 2026 00:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788223244;
	bh=3N8NIqIOxkcYSjk247eYz7rQGp0XJk93W3Myu5nHrNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZSpqM4kTqw0jxKwvfK9n3dBnjAL8wdD5lAfrynrfZMtQdgiocvvGTm2AnKUmjRmzP
	 hM+b/68DxI64UeXiepXd5zilqWLAcsS0ezVmCahaBG42SEUD+7v2ut23iudRjIGxcO
	 yOkPj/u62Tnv2q+4r9fz/lZNxMCy5VfdlTYcMkqNBAVElYFX/pILLvqy6Q3/mlEaxK
	 DpHXzTYN10PlSfrYZ9FCL6FhAzYsOpeFNgL2K6f7G73aDZgY2WOjqiIwqTk+f8NuUW
	 wPFpvgGtndbxU6q2ctNNXs0GlobJ+Ph+hpsXl+0+ErZaTHZBY3KTVyjeMNg/DLylaK
	 oXzAUe85DsQkw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Enze Li <lienze@kylinos.cn>
Subject: Re: [PATCH 2/7] mm/damon/core: introduce damon_set_target_pid()
Date: Mon, 31 Aug 2026 17:40:32 -0700
Message-ID: <20260901004032.89105-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260831163119.66bcfdd8a4ee66b3609be63a@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: f9h8ead6uxaadiqps3k79cpuf6omaq8b
X-Rspamd-Queue-Id: 76ABD8000A
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788223245-136887
X-HE-Meta: U2FsdGVkX19agKtwniTV1PMW7JJP9TjYuo4r7Fsu1Pu5fJMuXGiyzDB+LsOSK0K4HqJOEupUFRaiptzXcZVH49h0YghiGJQ6KIgEVp/yq2L9JfxYU3XUYISdJOVElYAG8bhjOgl+cySt/31IttAwLPyT3mfwkmPE6rIqp1G0BD3NNeoVQ+Gtg3t/Tca1okdQBh7KEvfpvxI0Pvo4lv9PusBGGrutv+/VRGjc+4csB8a9DCdym4sIceMt5lUDjIawdrBA/WSTwtZepRRe4ySy7wL6zXewTfyRL4Y78Qx0EtZRSN4OLtF7TBSf2cfvghIT/J8d3TF5Lpaw2wjc7q4IptjuUUvoBnuQm9aq1KO2pi5ownw0+ynoC1QEycE7n6iP2hnD+rDaJPGGgfOFwTvFBA03xP79zYEn3gfyOVoGmta3vstUSG4YIH4flOaiMMCHwNGduDEMeevH2NLU9RUsnEJ2q6IsqYQ1MGB+PhhKL722vcvW2QwVgpKGafTgQKJxMwvfW+Nj7YsYvlGxU2zHlk5YcinLgpSzCQNIaDeL3JrG6tx7NiQkRHpqB1UcOnDETyytyjLGv1N4e0Bvg7oJqigMSbAnQOJVOoDnvs2frfsZ/FF9wML5r1sTzCMsAeY2M2tBvglpGRkgWQKyniIMMjKjwZjVIfEUdkfR7A5jvO0eqY1yutLLZNa2OG81jRrEZj/mfcdj8fzWLhiZTIY8WJyeUUGpCoFsKQFEVP1Ky4g/Be1NCHKdtUvNV8Hoow3ViUQC+P7UXq63i9C8I07EYO1sFS7x4nTx3IjC/+ZDI7eCCVvjXqrV7+T9NNwRXuLBFapPHG9A0ltzYeIYAbTpz5PwvL/ndEF6WsPB+gXsGFOjj9OuKypVWpq/Px0972nBcphQYxx70GcIQ1g9uNq7zYZADtzPk03w6Pe7qcMeZhVP6pAuGyI7O6NZ/fooAN0qUMM9mldb81SdB6O8tUW
 Rjkqgarl
 JFt0ztGqyLVeiPG306zzRxkwVuSiHMS42tgwT9CIOCOb1pU453djwho6ZTZbsu/3Cn4gpsEeqmBnNsMZKsNC87p27aU9vUYkCv8pJddIHBMuYYszMk1bGxd8LrWnAvSnH10NIgWXuwpV/AjvCZsOG+YXL0Ox4wZvC9zvELfeDtyxtXv3AJo//E6cdgwldgsjLbssBx5DRi4JxYY2P0DwV0Ht4+fGaUEmKicqlvDwt0X5Ly73hNIRHaoNljS2iyijJQoAvCpAOKD/LrLz38uq1hVJTSFrLgjd0JC7Bf5U/RWg0qYQewsDAiRH4Aqd2X9a92/Pus+5ILu7jXm0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 31 Aug 2026 16:31:19 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 31 Aug 2026 07:26:04 -0700 SJ Park <sj@kernel.org> wrote:
> 
> > The logic that finds the struct pid for a given pid number and assigns
> > it to a damon_target is duplicated in multiple places.  Including
> > damon_sysfs_add_target() of mm/damon/sysfs.c and the start functions
> > of the two sample modules, samples/damon/wsse.c and
> > samples/damon/prcl.c.  Add a function that does the work, and replace
> > the duplicated code in the places with calls to the function.
> > 
> > Signed-off-by: Enze Li <lienze@kylinos.cn>
> > Reviewed-by: SJ Park <sj@kernel.org>
> > Signed-off-by: SJ Park <sj@kernel.org>
> 
> I assumed that From:Enze was intended here.

You're correct Andrew.  I found you already fixed this when applying this to
mm-new.  Appreciate!


Thanks,
SJ

