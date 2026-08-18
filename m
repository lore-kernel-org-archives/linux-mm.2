Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9942BC5DF67
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 03:21:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 532126B013B; Mon, 17 Aug 2026 23:21:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E2066B013E; Mon, 17 Aug 2026 23:21:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FB5A6B013F; Mon, 17 Aug 2026 23:21:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F105C6B013B
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 23:21:26 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 73DD61C1E78
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 03:21:26 +0000 (UTC)
X-FDA: 85112939772.20.823FA32
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id D162E1C0007
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 03:21:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y9Sot6Uh;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787023284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r8ycGWTUx2Z6i4TYl2DorBvyB4i7PAtWRsvpykEZrpo=;
	b=ys5I2lVICPsMGVU8cvSeiGkgje8oNpospfvrXtazjwHYMa75/fwQh6fjbe+4Ep9/DPcZMU
	xHdMFH1D8grSbdlLX14IFtb46LOeM+mif4TV/YRtMkEJYgP3ZktkFmtNHkZ7iMF3d/+MCp
	vI6EOa+wkgSmKOslOB+FGDyob3uzpKs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787023284;
	b=p3SZXAz1sdsutIji1i9x75TUA238KxFeJnlJFsRMnwo5gabQYq1mpgOuuwZYyaQd0p44//
	DFNK5/O8jR1GNzMPiusA36fyuB/pr1SiWvzpnr6MtMAx+TEYJFRDmFFWBiLC2LVWtE8Nvi
	AJyG+gbWfZkzqx7NFlkt9kZRlaGW9zY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y9Sot6Uh;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C78DA40546;
	Tue, 18 Aug 2026 03:21:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E0341F000E9;
	Tue, 18 Aug 2026 03:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787023283;
	bh=r8ycGWTUx2Z6i4TYl2DorBvyB4i7PAtWRsvpykEZrpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y9Sot6UhFW31l4tekFskkY/DZIvzGQa68alZJQG6Xim+nEmdHpvBdCHgXd00Vd0/j
	 qTpZKWeOfXYZTJRmNCaxjIpmzvsU4GEliO8wBg3GRxmcGY3VrE/8ClxrwV4pZC+D4h
	 c74GxNA77tVI3zgGWUnL/k+gmugOn6FQplXxg68yJ2W0m2m+hbdx0kvDGzLa3eRQvV
	 hOXYZOQjdiIzAvi8yBuWIMSk3aPSQCFIHTcxn5VmM+zkmMvnbJlWra/fsyGVdb04xa
	 zIaQasnLSlPLDYshIw95JxXIVJZTaDP0BYtAFY1myXkaP4WMe+cADKUOpJk40T6GpV
	 to0fZwPUYYLsg==
From: SJ Park <sj@kernel.org>
To: dayou5941@163.com
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Li Youhong <liyouhong@kylinos.cn>
Subject: Re: [PATCH v2] mm/damon/ops-common: factor out damon_putback_folio_list()
Date: Mon, 17 Aug 2026 20:21:20 -0700
Message-ID: <20260818032121.89231-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260818020650.2844354-1-dayou5941@163.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: phumxh9s3z74xteqzx4f718gzjwnij8q
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D162E1C0007
X-HE-Tag: 1787023284-181313
X-HE-Meta: U2FsdGVkX19icAR5+B5p9/mcPApQjGqM8nOsQy0+P51W4eG8MkSjqTq06dKFiWfDqCCWI0fXx3rCkWo1CleCd/30qpK/BoiubqiyP0IJDvm/7Fw7NOKFsU+uQakX3DCMT+pj965xZMT7a16Kb7hutQ9Nx8RA96dTZncifQ0yJJzfvTeroU1yOg9a1Z2DLjEpljbk31jAxyxiJvQbiefuBWxTlniSTOgFwJu1wXjSlJQA9KTh8kBXW4gfmyDIIN61ms6jQ7qfPW9GIV/jsMm7OKIW6RJtSGx/xyq/8mM6GosnX/Nn/2vIC0H0026d3S2VBa9egwdT/3FWa4XAGDmHi2RR4frBrN7zr+TSCUoGx0fOM/62qriVvi+BVOxcUM0sgg6Ap85n1Ty7gEJn3mkiBW6xI/usD99EyRXkN5M55EcFuAC33rD90DN0sD1QUkChOWrWSiv7ObCuGiok1qq2pW+ituLiTfff4H40l8mTz5nGIvQUzPiHU0yZEbutebytK+WozSP3eBBIUCZbWAW/cYQcy6zyWyc8DOFsr3nqpo3SoZUHeupnmadCACAxfBwKsn4yAd/qOTTkb6pIqVi8xBrf4sjVViD8OAn9GRtL/tg/1TJ19I+xXVOkIbcYa/QMF6r6Nzd5XbxdcCAh4vJfYRlHYYleUvh1IVJhSxS+1BzJV066lI9t/bt7Oy5nYYPi6wn7QcGCOW/8K7Q7+WJSVJAcQpZeKedGGaGQIwrjGH4YyK7zXnEgFObUqs7AVUb88m06Y25dsktctntFokKSiYAvfOA76HY6EmGq7sNg3+OaL1smRRGyij7VyLbMCUDwkqlY0KGtzMZhpNHTV2ivkFaZaKF8qAkZiuMBW9jzWBQVyw/2Qfs+yiIfuIf3vJcgOa9HSsSI2KMrSD40uaz4sc/EYMqcbUvr0ehnv3k/CohedLBsD460qB8H/gK/qvXZThG8j6kT1zwsXPT3tRk
 0rINwhok
 /VjuW0sPbLExlQ+O/OmdiCWmZLdAyAZnTPhwPsViSQgN/hmPjq5Rci9u7DJTotTMVILWbY1mtCJqiY3HgQTgBEFtnFnyxny0/NN/oVuhAGp7Hcf6BGJCw2nr9/HyesoWYcIXy+bFLtFDmEgeHu/40VzEuyomc0UpBQfn4RcOo7iZV7Uf4OODxodhlhhbrt+Z21TojNJADyJspjdIykukmf0fBhrNrgiYDZdlbeU9Wka7Kbp/i3kmNIVgds/9uMjycwiYTgVHWOU/DJttfJY8cOmk7UJj9t1U1yn77j7eoC/RnILMoiZYtpwWkYDDZ9a7waq6q+Sf1emnYHuQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 18 Aug 2026 10:06:50 +0800 dayou5941@163.com wrote:

> From: Li Youhong <liyouhong@kylinos.cn>
> 
> The putback loop is duplicated in damon_migrate_folio_list() and on the
> invalid-nid path of damon_migrate_pages().  Factor it into a small helper
> for readability.  No functional change.

Thank you for this nice cleanup.

> 
> Signed-off-by: Li Youhong <liyouhong@kylinos.cn>

Reviewed-by: SJ Park <sj@kernel.org>

This patch is applied to damon/next [1] tree.  If this patch is not added to
mm.git in short term, I will ask mm.git maintainer (Andrew Morton) to pick
this.  So, no action from your side is needed for now.  Note that we are in the
middle of the merge window.  Andrew might not pick this until the end of the
merge window.  I will make the action only after the merge window is closed.
If it seems I also forgot doing that or you cannot wait for my action, please
feel free to directly ask that to Andrew.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

