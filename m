Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 522C5CFC28C
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 16:50:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A84A76B008A; Fri, 21 Nov 2025 11:50:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A355F6B008C; Fri, 21 Nov 2025 11:50:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9241E6B0092; Fri, 21 Nov 2025 11:50:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7D4C06B008A
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 11:50:41 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 007024EF98
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 16:50:38 +0000 (UTC)
X-FDA: 84135202956.18.10CEC08
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 009CE4001C
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 16:50:36 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Lgsu4pZ9;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763743837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y99R+8CEyjSwO40X3zCg8mJ1hR4S48f20Zpq1/JxexE=;
	b=JUD45a28I2J87IfBTuTTqHtxXF4LrZaT0tHwJGh/YHq8j/Em8XCYR5cqRgieQ7Lvmydpop
	5micC+x4TiHha0koD1gqOQEelAhnW+3cGq6O8MaY5REwcsFuWKybqkWy9srpbQPGIhzPbf
	3gnps7K/qtzjeM9bOYpLa/nEf9fr/Zg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763743837; a=rsa-sha256;
	cv=none;
	b=YpXM357GIFDJitxDGGufK3rbq9kV9yA6weF628cAeOyM0trcULtlkVl6vnDBUvz9MiMx2o
	2C2y49RS3qXDklNvpWQ9wf9fA3yuOe0Cg5HlTHBsfdmzTQPsISmsOQXa8wft6b8VhFd7ts
	H4U2ADfzKnFMX+xM0BEs6IJkJ8WQFS4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Lgsu4pZ9;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F12AF41B19;
	Fri, 21 Nov 2025 16:50:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75345C116D0;
	Fri, 21 Nov 2025 16:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763743835;
	bh=fl2EOt0yx1kTg9qgvkSi+MWK8mIsBijhE6heMSgYkzg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Lgsu4pZ9dcc1c6RhEs/PRONpeLQB8QF13bS360lCVfPXEy09F7lNsnWRolfn8cdt5
	 1jIJZZM2wT1R7kuazT6sQteFATmAEp0BSOnYRaIYPmsKD48fAzrkJ+vF3Q9oCNPG91
	 H1Q17/BF1yPQD1bDs00UD3oAW0/fEtGAIzPUI/Ew=
Date: Fri, 21 Nov 2025 08:50:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, david@kernel.org,
 lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 linux-mm@kvack.org
Subject: Re: [Patch v3 2/2] mm/huge_memory: merge uniform_split_supported()
 and non_uniform_split_supported()
Message-Id: <20251121085034.d8092d312da961b23c33a22c@linux-foundation.org>
In-Reply-To: <E7C2F025-4CA1-4739-8661-343D60D82F7C@nvidia.com>
References: <20251106034155.21398-3-richard.weiyang@gmail.com>
	<20251117012239.lqm33uu4vl4y5zqc@master>
	<337CD281-F5B3-47FE-82C3-ECB236450F60@nvidia.com>
	<20251118033339.7rukw7vvjvlbj5jb@master>
	<51358ABE-B0BE-48E1-95E3-C778D1F44622@nvidia.com>
	<20251118103220.bd90932096d4e36f754de21b@linux-foundation.org>
	<2AD36673-231C-41B9-905D-35BAB4CF63D2@nvidia.com>
	<20251118140658.9078de6aab719b2308996387@linux-foundation.org>
	<20251119005248.ddlbhokgjdmlkhkr@master>
	<20251120131621.486cbccc8a713ddbd30dcfe6@linux-foundation.org>
	<20251121090048.3n25tjhusu45xpoo@master>
	<E7C2F025-4CA1-4739-8661-343D60D82F7C@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 009CE4001C
X-Stat-Signature: nif63pb6d6bbz8uk5kc4h46wnr3ozttk
X-HE-Tag: 1763743836-196346
X-HE-Meta: U2FsdGVkX19ZgB+aXirWf9pBF4jcM7WUFBIeLIr9WFDgkQ1dsNauFVbHA9Qc5n+4UPXdok47DTjxMytRL0gKU1f//1kjoas9JH+Wq69kB+XeOmriLkUgQs7aUqbagrZu/fJFIyXIeMkX3hkOv2qZxx1rpMwgLUMEjorTZfJ1qZ74GASJK7XbqZwJfjv3pSd7uy2/o99o4WqeSIDtYVoedbicCAx4Ajd9R4NP4Qo00AEY8RiQ9GDhmJIiQaF5mEI1BwcIKh9tESUFWejQ8WRJv5/LCnhIUrr6xS8zStg0VULZj4cbBTMh0BJ6N0B5GYn80sIDtmZVOuKpVTQ6hoE1Q+GlH7Iz1ybl4IGll+qbRNGoFxy6h2OC7xzWo3H9mV5SxnzdYPGK82abu8L0OfJf1Egql9CoxAPT14mYu5XEOS66zbNjfi3uReYLoLKtSKxqXVO/9eRkjSrj/wrwqB+W7JHres73oA2iUiMKxWEcQhYTjOsrakLuatvIeVYuWW5VOiDJxgtGXUzvNg9XcUIUfQ6JnmlGrHRx4wVVhnFcylHCHVBdbmq8RmHklgKfzfoSzaz/FEsg3ztEcGNYVNfVAAzCDsYrkJMVTh5xzyDHg3r75W0rLRLHP82O/v2cPWXkb0zdkYaFLV0vgcjioIvIdpR5yTSucdiS5JSEFZ4Dt7up5C3KPudvhGxfR3ihC414296ZyaQSNcFnHfY4IixX5GpoweUIpnNpaxFY53rUvmm+tpzSZ1Gp2EqBW/buBsU9IT8uMWZuFUfCsVsuh0RYcxyqcW0mCpOTS2ZEXFkuxgfJX+FxBtgCtYrgRMh1PhkPFXrqIsoLmFC9/SWc2EBkZEOVC1t9vR5RwSt8Yp69FEpIzfEx1dBcyYEGm4DGm9qbGeG2/VrqTJs/IxJHLGNXdM0Omlt/BLo8KcTIFbHmIBGLeBE1D7XZidofDMyVJ3YQSe4jrXqeZggXh1UvCA5
 199DRukZ
 FVTDqQtjm/ifMmlfEoBa3vPkYWdTVS5owsIUvVlKKeSQJ10nvy5HxaCm44zayM9JpS/ZP8VIzViZfZu6ySu6NCVwcUqeu4VDPObVUtpMJHiCIy/WB1bmzj3uPA2CXUIPwmjPvqaRpHCDSJNKfB3xsYfQtUgtHiv32+D+lM6HI5tr3dtyeD8U7FAqhp0y+FOi5w0Xf7rKjpYQNtSNGWBKGA1e84Ohn/epDRH1ELaHg33++zJEEH7UW1qOUF9rhj3RoCFIvceB3Y+GMFqsX21NmBf+iCU6NRyz0oVN6GWKYVcezEWIELNHv0NmCGeT6Yj7ADVCpW1NJK4pjk2srrDtalGTeipNXjjE5OYEBxjsZxCaWlne53z9/M7TUvUIfYi457PTfJL3qB1KFm/r2CmxCrxZNk4r8mFJ+60CJp/M1mBUacElJ59dOuzIPpEG6iH5tt/STtLPDcB9PUjiAYu31xc7zY4uDoQVqt9ueL8s3SKozfBk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 21 Nov 2025 09:59:42 -0500 Zi Yan <ziy@nvidia.com> wrote:

> >
> > 2. A further cleanup attempt:
> >
> >    https://lkml.kernel.org/r/136E8B1C-3352-412C-8038-627F5CC8A112@nvidia.com
> >
> > This one is the related mail.
> >
> > I proposed one version in
> >
> >    http://lkml.kernel.org/r/20251114075703.10434-1-richard.weiyang@gmail.com
> >
> > But it is not proper, will do follow up work later.
> 
> Please refrain from sending more patches related to __folio_split() and its
> related functions until the above hotfix is merged.

You're referring to
https://lkml.kernel.org/r/20251119235302.24773-1-richard.weiyang@gmail.com?

> I also have an ongoing
> cleanup patchset[1] and want to get it in before any other changes.

I remain unclear on the status of this patchset.  Is it considered good
to upstream or is additional work required?

