Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FC0210AB828
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 20:58:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46A146B0005; Thu, 26 Mar 2026 16:58:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41A866B0089; Thu, 26 Mar 2026 16:58:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 330036B008A; Thu, 26 Mar 2026 16:58:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 212836B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 16:58:28 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B0E85160CC6
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 20:58:27 +0000 (UTC)
X-FDA: 84589427454.16.C9254CC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id DA47A1A0011
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 20:58:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Ls1/FcCK";
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Ls1/FcCK";
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774558706; a=rsa-sha256;
	cv=none;
	b=l2wqtdSKAPqLW90D2WVhWylQlKMsYWOEy4N6XLhlI1hwDe89Wo6GRBlBAoEeVv9vH8Qcrl
	KeVq60YDX0YUXD/kOZNWAH+wARzTC/LT6IEhZy0fFb/TFQ97fwalRPjt+UyxkR23VJX9eW
	ttcuokzXs79GqgByVHrOoVKma5/mz3E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774558706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:resent-to:
	 resent-from:resent-message-id:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=/RpDg75qqqxQhR8IuG1eO115kfElUlVYi8Pvw1yjrEg=;
	b=3lgweVIeW2RpsQR+0SGxPUjwsOmpmz/qAYRV5wDORT6OTf959YMfnqcyBNExAyrZIkujkI
	AOhIPcZjRD3vyRAlHj+Gf/6kEmryLt0/sHbdxAO0D77GoRzVayKRIhgbhmAe5lU7KQzy5A
	P3pY9FbXIlbrhjcvUscyHthpN5H5XtM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A2D1040E0C
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 20:58:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E87DDC116C6
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 20:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774558704;
	bh=Ldt75UkzA/EcmR6Gx6jkMlK4qkdEE5l75ncw1R2lOQo=;
	h=Resent-From:Resent-Date:Resent-To:Date:From:To:Cc:Subject:
	 References:In-Reply-To:From;
	b=Ls1/FcCKMv+RSakopRH6iI3GNKWyfruGLp7WUcWoen9axIu3i2u1F8gHPsj6EnRYq
	 Wzlx9e/x1cEeYn/6mCNDCvCN3yC85/aH3mVmiSHH71m3WG+EX581/QquAZsrlHS4yI
	 W+afDydpsvhxJQu8OD2r9fQofRt8KoGrQ4XSgrloFWPrwBj4GTzBVwGLTreddF/UOZ
	 NsaZikC8sD7BUfx1Jjl+41F/eVpZgwVvWMlJ/q6rdZkGtIexo7Qh9gQJDQ/NB8sTK9
	 ++gYQW7DHYP6THQ337AEcx2vL9t03939vCGqmUB0QSNVdkTCuQN86xHK+Abg44Lxhl
	 2bozBZpZCicSA==
Date: Thu, 26 Mar 2026 20:41:26 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Axel Rasmussen <axelrasmussen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>, Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: update MGLRU entry to reflect current status
Message-ID: <44e24a7e-19eb-4497-912e-aa91b54cebbc@lucifer.local>
References: <20260326185428.354430-1-ljs@kernel.org>
 <CAJHvVcjAm9MLvmHA9SWQzGirM-9HJ4qpDQ263Ku+EUJH+bxY1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJHvVcjAm9MLvmHA9SWQzGirM-9HJ4qpDQ263Ku+EUJH+bxY1w@mail.gmail.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DA47A1A0011
X-Stat-Signature: 6swhotjmw6tzqccj91p8cm5u65k5sis6
X-Rspam-User: 
X-HE-Tag: 1774558705-12378
X-HE-Meta: U2FsdGVkX187PqZU5K+T+rr4GD7zSN2iRlOHmpdLcoIIHyAvdrdQAMQM7P4SCG3CuLNxDSeAx7qMmDO8bnhBo/+IysbAFMkWKnlk1yhjj2hcCow4UkkiKT3gP7GDqlX7Ourwhx8CGXGSg+vT5TWqjEXH/+YbVAbbPKbdoLRAKqZbXp2ez3lypQzVMrqIGYajxJeGFZI7rQVEyUHruzwmHoaT+na85R+7zYuoME/tjJtnHGrSv9wLlaLhavxcRtp8wfWceqyz5UmgFAVAB6jRivvv5jKlGTz7VzH4Mv01bkfhi86DUZg8eC8PYebzJttu+Yj55le6EmV3KhNOgjH1Hy6MsZfCXjgiKFbJhAyVw2guNosIsqlnmT90Ijc9+RwyIoAe4rLsy7eC4iNFkx6EhXgADZ8kbH+LpVBoRzyOvqhkyiHirDYWkhwh8WVUzcUg8+gG4WmboP0ewxLRGXY4K598Fs1A/ranm+zRZyga2utSGJywHok31abcbXAFFght+Ia2JWOwqT7W7Au04qWLukdeH+8I7DPV12Ks6yLG3sMmWKTasYO9jKdYj1P8hXH29MrhnT0vp3gfCPHS5ictfo4321ebrQfvCsTZSupl1cqub+s7b7CRlc3vNG9Rtc2CuwgXxfJsKchnXjAUHqeviijnE6mTHxSVOMU5v4ffMoAeh8QW5tCHfJbuv0KPExlYagRLKy1/2X6Pu8t14RsZmvz8zjMl5MbV85UVm78tTKlpLt/giFi1jNcf18kVwhR9qu7X5hvYOGYLiyrUvX7yir3FEp+K51Y1PCEg3KQrk8H+yp4lc4dPgk6M7+BNsTckGy/5xLSlw+JsYsPY8pStQcVfvwd/T1hIahV6S0+GipsY5lnloNZzOeSE+/Xsms5Sqmm1mbXtncTloQTMdsfo8w1yc/nkZk1UIdhsv21QzBGDhw8lAe4/cqIM1rzG++48I6sOnw0LfmE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(final attempt at sending this mail correctly :))

+cc Suren who I should have cc'd in the first instance :>)

On Thu, Mar 26, 2026 at 01:37:21PM -0700, Axel Rasmussen wrote:
> On Thu, Mar 26, 2026 at 11:54 AM Lorenzo Stoakes (Oracle)
> <ljs@kernel.org> wrote:
> >
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
>
> No objections from me. For what it's worth, the intent behind adding
> myself and Yuanchu there was primarily just to review patches. So,
> moving to R: instead of M: doesn't change much for me in practice.

Thanks :)

We're already having a great discussion on Shakeel's LSF thread and with
new people interested this can just naturally evolve based on people having
resource to contribute on this.

So this simply reflects the current situation, with hopes that in future
things will evolve and we'll see some real movement on MGLRU!

Cheers, Lorenzo

>
> >
> > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> > ---
> >  MAINTAINERS | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 76431aa5efbe..16874c32e288 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -16757,8 +16757,12 @@ F:     mm/migrate_device.c
> >
> >  MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)
> >  M:     Andrew Morton <akpm@linux-foundation.org>
> > -M:     Axel Rasmussen <axelrasmussen@google.com>
> > -M:     Yuanchu Xie <yuanchu@google.com>
> > +R:     Kairui Song <kasong@tencent.com>
> > +R:     Qi Zheng <qi.zheng@linux.dev>
> > +R:     Shakeel Butt <shakeel.butt@linux.dev>
> > +R:     Barry Song <baohua@kernel.org>
> > +R:     Axel Rasmussen <axelrasmussen@google.com>
> > +R:     Yuanchu Xie <yuanchu@google.com>
> >  R:     Wei Xu <weixugc@google.com>
> >  L:     linux-mm@kvack.org
> >  S:     Maintained
> > --
> > 2.53.0
> >

