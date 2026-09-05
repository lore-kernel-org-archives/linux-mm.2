Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91646C624DB
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 16:12:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B5386B0095; Sat,  5 Sep 2026 12:12:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 865A46B0096; Sat,  5 Sep 2026 12:12:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 755B36B0098; Sat,  5 Sep 2026 12:12:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 53C7E6B0095
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 12:12:44 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C56B0C0351
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 16:12:43 +0000 (UTC)
X-FDA: 85180201806.15.F8B4B8E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 304FD80009
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 16:12:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lDyANSQx;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788624762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bXbXXrcCdtBT1TjZ6Vc2kGjnHoJ85kk8eETl4UzoqhI=;
	b=JdNUtWrUpBnRBQPNlbxkEdrNvlhn0bjfSJSY30T2wbQ1D5eyKTSY2ne0WgKop4D/bFFnTj
	2qsQCaa/nyOt/a2QWXXLRC/rKlwCZZ++t69X5FmnlS4MsfGmHpwCcaatHaPiK4W8r//CLa
	NpMaLUcvL07PrXOMjcLaSymiZ5y4vFM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788624762;
	b=fJo0xERx49MMKHIfZS/V6hb+/GAkjUV6uu/AbeyHyWorbwkakkKhsseSc2gMYa77WVFrGq
	qyvBtYSwpVk8utJ7dxPEhqCiJ+LIvB9S2bTgtphz+OC8xWDzJHa3xGB+OiJ6IXtG8HGy0u
	BwMA45pNuPpkgH9kBpfVCCvgPXBKTdg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lDyANSQx;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7217F601DB;
	Sat,  5 Sep 2026 16:12:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E75741F00A3A;
	Sat,  5 Sep 2026 16:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788624761;
	bh=bXbXXrcCdtBT1TjZ6Vc2kGjnHoJ85kk8eETl4UzoqhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lDyANSQxzIBxflYlMpKX1pe0/t2OpjXWlI1ISNGTEY1ORvoezMa0w7l4YFUf6d10E
	 8oAEH/Z+bwG//ucJYE2fZ+8s8RnJkficEELpCf8BM1lli8Rnq5+h9iogHAHo1F6Sfa
	 RvxevkQF0RGDiEzTIgBVkqGlWpBQpWsjCWmvQAZEmwuB8ZHJbg0xHAc+ca2rOavBy+
	 eZ17Fo1JTfVs1mtQv/tK9oI1mupNK69xqjGWpVmuip8Q4jBOZptAKrRVts43wRHqcl
	 0PW9MsaACADQUbG8vnI9+OgZ5kUju9CuaQYi1CKP/6V5rrBHI5e0fMqeSe7MXBMOhi
	 Aud29j8TwCbxQ==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2.1] mm/damon/core: fix false positive in damos_quota_is_full() when esz is zero
Date: Sat,  5 Sep 2026 09:12:33 -0700
Message-ID: <20260905161233.81892-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260905103935.4871-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 304FD80009
X-Stat-Signature: nbu7sia3hskok7zwc9r4x69buuksqx69
X-HE-Tag: 1788624762-315251
X-HE-Meta: U2FsdGVkX1/IOrX/jJ/0GEG6CiJcJi4Qdw8RCq5QosZa5ms5mgM6nlPraYakNafPLtiHKgXu9mFriTul6Ft3WgUSwnt0iaSes26iImkrDLUGchmdUkYSO+9oIAIAxXWZ96r9qdxL4085OonZtMsZdZUH2G/puFDDp9ijdKyVyiqH4IWQI96rR1mC2xXPn6EWvqzrG9uSzPUOL6br6rSwtr9bTLdAxXUFgHlal+ibVeNn9Pk9yPm0aJ+FQ6DSFYaLQivpRCsJzwqcsNDA6GsAYws8Xw3bjizqvU6z5a5ffyO83IvgqD5NNWfHEQQ3NlImNiN0qcRkqoa+uQJ/svDwz2rOgrZFVekwNjOD//X4Zl/PtxzA+XJ55AJvfrHkdyA/WZ96bb68UmEZYYu9EYus+/qu9mE3lbwkJdInTnu++Oub7JMs7dhpy/j9n6oO0PxfKzA9O1ZvnWaJ3lPMpVFnMOdyhn7SDGug7IlqVGPFVOUxjJiziMi0bK2hh9/ZSmIeJvYag0cHb5lHzgJ8QQoCVcnicpKwV13aUI9SbOqx5BflGTAHmiTsCeHKrGxXR48TUzQXLTRTAteyNea8L0dpexeq7I/ozMShBjLSJOSdYchEZ7rlwso9l63fhOtvYVzTii0uSFPZNLeeIN4/DReNSBdp+xi94Q0y9I+0nY+E5hcEa0qCszc2+Tt5x5Gk1KhyHWaxWI2X8qN6tSly4nDxzWR5S/3v3YTfdDFbOAROqjDlV4L8Y/AVFmQTv1OJgD+xefp5WLZUzSbsEZQ9loo3DvWdPTCYWqw3usZi7NgcQR8Dz43m+tR2hyQRFRnMWvL5ojL8fldqGN2PSM0rxJDqVktO/mxWDmJBB1iA6BUjUqefRL+lfNTj4pS7DCpdt5gRkyIDBjz2EJi9OF2pepQrXN2bQMNrkRoCk3HBbnuaeQ6vi0HZyYaBUSsP7tUvdioPB3hl4FUfEsU/vT3lcaZ
 jP3ES6C+
 UGkLPJdj6PFxyZ+MOu6K3eGsh/+oTFikM8zguG3FHzR3X7E4wx0hP+eZGyVfUegDd56rXuSKcFBGaBEXVuMAoUZI9i0uMNZAIAruT1axlqG6+oaWaW6zvkHtRvCBlEatQ6fxHr1eoeoUZdpWR51BPO/b+3uXs5SSJjvRnZwqYusRksdbFDvCh+3I2GVwD0Tj7hsJRHnjgrD3oH9QzrJbXKE5lVl7u3Y/rMJI7HIJVsR5A6WRiF7FfTGYiV8UJxZaGIQ+/V5lmvkwWU1ufkfDQpyCuq7Ou1CO8FqHVW9f0QcDwJf4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat,  5 Sep 2026 18:36:58 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> On Fri, 04 Sep 2026 17:25:34 -0700 SJ Park <sj@kernel.org> wrote:
> 
> > On Fri,  4 Sep 2026 23:35:38 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> > 
> > > That said, it's not important for me to add explanations to the
> > > document, but may I know why commit [2] changed the behavior which
> > > introduced by commit [1]?
> > > 
> > > Commit [1] Behavior:
> > > 
> > >     if (quota->esz && quota->changed_sz >= quota->esz)
> > >         s->stat.qt_exceeds++;
> > > 
> > > Commit [2] Behavior:
> > > 
> > >     if (damos_quota_is_full(quota, c->min_region_sz))
> > >         s->stat.qt_exceeds++;
> > > 
> > > Before commit [2], qt_exceeds will only increase when quota->esz is not
> > > zero, but after commit [2], qt_exceeds also increase even when
> > > quota->esz is zero.  I'd love to understand the rationale behind this
> > > change to better grasp the design evolution.
> > > 
> > > [1] 6268eac34ca30 ("mm/damon/schemes: account how many times quota limit has exceeded")
> > >     (Fri Jan 14 14:10:20 2022 -0800)
> > > [2] c7ec7d5f6b3d1 ("mm/damon/core: handle <min_region_sz remaining quota as empty")
> > >     (Mon Apr 27 18:33:50 2026 -0700)
> > 
> > Seems commit c7ec7d5f6b3d1 didn't make a behavior change that you are
> > describing.
> 
> I actually wanted to point out the behavior difference between commit [1]
> and [2], but I've understood and agreed with your point.
> 
> > 
> > '''
> > $ git show c7ec7d5f6b3d1
> > [...]
> > @@ -2601,8 +2613,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
> >         if (!time_in_range_open(jiffies, quota->charged_from,
> >                                 quota->charged_from +
> >                                 msecs_to_jiffies(quota->reset_interval))) {
> > -               if (damos_quota_is_set(quota) &&
> > -                               quota->charged_sz >= quota->esz)
> > +               if (damos_quota_is_full(quota, c->min_region_sz))
> >                         s->stat.qt_exceeds++;
> >                 quota->total_charged_sz += quota->charged_sz;
> >                 quota->charged_from = jiffies;
> > '''
> > 
> > And I don't think there was a behavior change.  Hopefully commit 54419bbd0ee3
> > ("mm/damon/core: allow quota goals set zero effective size quota") will give
> > you some clues.
> 
> Thank you very much for your clarifying :>
> 
> Now I completely understand why there is different behavior

I told you I don't think there was a behavior change.  I still think so.

> between
> commit [1] and [2].  Because in commit [1], esz==0 only means quota is
> unlimited.

No.  Commit 54419bbd0ee3 says "DAMON core assumes zero effective quota means
the user has set no quota."


> After commit 54419bbd0ee3, esz==0 also can means do not have
> quota at all.

That's what the commit is describing the before-commit status...

> But the qt_exceeds should just not increase when quota is
> unlimited, that's why the current implementation is completely correct.

There is no unlimited quota.  Hence I don't understand what you are saying
here.  Please carefully read the commit message again.

> 
> Best regards,
> Rui Yan


Thanks,
SJ

