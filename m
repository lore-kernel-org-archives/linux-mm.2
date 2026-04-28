Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDDF7FF8864
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 00:48:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49B876B0088; Mon, 27 Apr 2026 20:48:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44B9B6B008A; Mon, 27 Apr 2026 20:48:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 361676B008C; Mon, 27 Apr 2026 20:48:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 221B46B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 20:48:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A82918B65C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 00:48:40 +0000 (UTC)
X-FDA: 84706129200.08.518132E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id EF1CB40003
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 00:48:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mFGKJMYF;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777337319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fP7tVmFQ1Eu6+gTMecUpbwsmg7GDJp/MwFxGAVFqKss=;
	b=Uk9kgmvuTgMz1i8guF1rjH22k1mZl5oLsCUAjpb93jVpqL44whC80UtUoac9uMmNsA4HHY
	VoexvTkxuLWG6MUxrKg2vJ1V8OzXm/8gY4WIvRTLaKuUWl67ULJ16uJx4OaEOZUCyWNEqh
	ePrlFGsry417dgV4Q9kAg6E9yMsNwlg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mFGKJMYF;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777337319; a=rsa-sha256;
	cv=none;
	b=wmGc8PuXtpyem/1sUOqOwQRiXcC8qd9iUPzoDpE72w1/wAGeqRWO7ROW2dlNtykYo7JWqy
	KoadzsrsHzkhak7Z8W1SvFDLbh4WLJZ/11mIEtoElr7ws9M+zSni6eMUIue2Rx2ePI5pny
	u8VmXceT0BzUm81l4DM0UT+cNAy0MDk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CD35640422;
	Tue, 28 Apr 2026 00:48:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 647B3C19425;
	Tue, 28 Apr 2026 00:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777337317;
	bh=pd3+iRU6SOVvmr/+JRNFN6pYsH/uGBTxvrVYDB0Q7bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mFGKJMYFVziQKMOi80meVeeySNKwaUTXjvyviT6UdDxkWOqLrFnMdcukOaOItDaMy
	 ust66S1yRSZDX/tiS4rqrs9wnVH++NFbYgUJp0Ja6YdzUGaDuNQRxVcLk1o/xB4Nsd
	 4rTTgQAmkxJtmvBv3jUdXNLvQYcaF6GrwEO4k7MkLvn2kZpHPIukK4iBqYFpMSGhUu
	 BtjiPcoY++PinhReoYmA6Dnn3As6wBORzSAlL0+lOWeeR4/Iuv644svs/SEqYi6sO/
	 YVmPUzmKTody2Ygj3Htipw2A2a+7JTS/vQdF13y/6P4CKbS6V2+bV/BjzTo3fO6NIT
	 suyhqNfHi8u9w==
From: SeongJae Park <sj@kernel.org>
To: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 14/19] mm/damon/sysfs: setup probes on DAMON core API parameters
Date: Mon, 27 Apr 2026 17:48:29 -0700
Message-ID: <20260428004830.113597-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <d08d7ffd-8d51-474d-bf57-887e09cf1b05@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EF1CB40003
X-Stat-Signature: akoaz5b4kq5cfppk9ccyu15y68guh6ey
X-HE-Tag: 1777337318-70740
X-HE-Meta: U2FsdGVkX18zxEDKjwClmTKJvK2BO1sCui2rISslsYhMbBPz+MIyhNNVDjtd9TN3LvfASCu8VLvi7ymqj/oMtvbw18vapCNhvf3oNsmii5SpIT06A5x6e0Hje2q3VSGsBK8aaalwvbUiScOCUOVUF+RzjOYMbflcCTGFBLb0y+JLDeNU3My4zaZAY1G3f8r6hRKaYT0LOxB+ZhQyIhjr9H7S5liagWf1VazKSzVCx9+H8FvzE7VAV+kz6H9y8T96YJuUnvBLhjy2ov3H6bXxAtDQ806244Tnz0R8G9zRAS+x32BBNz5XZUk1dkGqULrAqXNj0aGZMDxIWbAmZ0YwHgIboNQLY2VMwE7UeoTK2XVhFnjA49onywX74N7HaIBbF/nLCA5NqpitfO4uYJBNEFQzXBUFDxR0S1FXW99oXWWIi2JL619LzL7Bihe4agZC1CWDP/huvm51m4ZDytN6qnzmKY7BqNAnJZdxCScJBPak70E37RbUl4Vu7X/Cfp7cg2w1hqy6yjU1WFqWrwAM+T7qjhij3dH2DcgIbUUdvLrSM3U+Y0FxIGjZ0OM2p5NFo5dJqNbzg1AHUAC/qo4DbbxG/Q9XMOo3RlZVGsHN+oOD0sNdApB6iGEhAOkNspL2MHWrFfvbEHwhFtJ7NUdAekb5Cg6g0Dj2b85QziNTi5BbyJLQtx/66BziybqSGkmWOxPuaQFdrhxGSnv/vF0uljJIVyPyCbAEMxp2XX8y1pt2MlVYoaSiivBBhVdYyGTXgdhqathc7tnjvuccUB7CSBhzL3IYeRrxw5TJUmWmSRokPTafLch9d8+EwDNd5avA89iGzFA4egbyiVgUNDwBkTIJGM8FpyHepltNJ4BI+yx0OXN9o3sd3hBPbHFjKAdUs1SLQuUkbFYWgGkcgAv19ATMuX/VoK9jlkVSccF1abCN2np4d4AxRaVtZCx9scpPW0mRMhPQpY9xMsqWwa5
 FjpYLvTo
 fGCq4TGAx9JWFFjw/8bN0wsRqguFFuI+vzBTmWyAeE4w+aQOLR+cHQmDsMHVK2BQhelNalntW9LvVgLPsaGA01HBYYA9xKVwT6hKew164r8zYwJ1LbK6Gx+fgTVKEusnY/l0MsYpi8zi1nLm1IOI2mlJxgMC2x9TQym3nQsxHPd6Z79NLoF5ZHqFRQltGNI4mZSAZRNic4HEjafZ/5rmtdfKwkKMAsOLAwhsLQLuB7DMqh1jJw+4MXSS9VS/dFNDIJEI/DrZftXeN/soas2eP64P8DyMWVSHN8Q8Q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for review, Asier!

On Mon, 27 Apr 2026 16:25:12 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:

> 
> 
> On 4/26/2026 11:52 PM, SeongJae Park wrote:
> > Add user-installed data probes to DAMON core API parameters, so that
> > user inputs for data probes are passed to DAMON core.
> > 
> > Signed-off-by: SeongJae Park <sj@kernel.org>
> > ---
> >  mm/damon/sysfs.c | 37 +++++++++++++++++++++++++++++++++++++
> >  1 file changed, 37 insertions(+)
> > 
> > diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
> > index 2e0b7eca6bcbf..8007961295d3d 100644
> > --- a/mm/damon/sysfs.c
> > +++ b/mm/damon/sysfs.c
> > @@ -1855,6 +1855,40 @@ static int damon_sysfs_set_attrs(struct damon_ctx *ctx,
> >  	return damon_set_attrs(ctx, &attrs);
> >  }
> >  
> > +static int damon_sysfs_set_probes(struct damon_ctx *ctx,
> > +		struct damon_sysfs_probes *sys_probes)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < sys_probes->nr; i++) {
> > +		struct damon_sysfs_filters *sys_filters =
> > +			sys_probes->probes_arr[i]->filters;
> > +		struct damon_probe *c;
> > +		int j;
> > +
> > +		if (!sys_filters)
> > +			continue;
> > +		c = damon_new_probe();
> > +		if (!c)
> > +			return -ENOMEM;
> > +		damon_add_probe(ctx, c);
> > +
> > +		for (j = 0; j < sys_filters->nr; j++) {
> > +			struct damon_sysfs_filter *sys_filter =
> > +				sys_filters->filters_arr[j];
> > +			struct damon_filter *t;
> Move the declaration of these two variables to the top of the
> function.

I have no strong preference, but because this function is not very short, I
think having declaration here makes reading the code easier.  Also, this style
is used in multiple places of sysfs.c including damon_sysfs_add_targets().

So if I'm not missing something and you don't mind, I'd like to keep the
current style.


Thanks,
SJ

[...]

