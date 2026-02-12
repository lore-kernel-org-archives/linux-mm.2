Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DC07EB48EB
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 09:22:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71FC56B0005; Thu, 12 Feb 2026 04:22:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CD3F6B0089; Thu, 12 Feb 2026 04:22:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D9546B008A; Thu, 12 Feb 2026 04:22:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4E6B16B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 04:22:20 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D63028A9C2
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 09:22:19 +0000 (UTC)
X-FDA: 84435263598.29.1648B9D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id DE6B18000D
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 09:22:17 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KHdfQbax;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770888138; a=rsa-sha256;
	cv=none;
	b=QPb1hAzzGr5ATeJZ+6YBXpsD3iHI0rYviKDU44gtphnwK0M4VO+WBpZGM2Lczyu23HrbRZ
	jkTYL1dQSJzVzFfe/1abk3XkZbclfc3jszlngOXV5cxnMVVzQccESp3NLTospl7eD/3nKh
	etZi1XaU1Z94AkKOvcQd2dvgzG/Uy5M=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KHdfQbax;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770888138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XHUhK6DuMmJa9XqbpvDNQgrQWJrweoUVYbiYjAcqntY=;
	b=7iW0GSfi05TzxQS199Au5z41nsYyoAu6DiXop7PcMlZ6xPIBpv6COH2lIdNEW5vo6vnBWN
	Hcr/+Os2rbyDrPbwZY8xw/csc/TEqgE4plSm+odL42O55r4GE/UUNqDNx14rJwpZKxgn/x
	U/hOphet6lVoUeP0PRjdVD2FJUdkcDU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C469C40DFF
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 09:22:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1DF5C4CEF7
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 09:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770888136;
	bh=JB/7zOlJxyPK4AODuPi6IID3KVGl6JqfTuWuOUfvCOk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=KHdfQbaxGqbednpjSsdQc31KroXyR88Q6tpvWzhZCF3/M/sEV/JEJJD5U7UsWONUe
	 BmpdHyx9CmzHAzLPPThwDW8PfbBD4eExAJh8i6L6j44CB2JJn7nP88wZ/DOW/QrNaZ
	 Z5JE07zJwrgw+ONzXUxhqAR1Fiw7mbk16Qq0fsu5iEVX5IIQwe1kNua0x4vmGHf4fY
	 KrIJg0XD0mOG6LiY8/Nar9XIjoOH6YjvhYWntKGQOoigct1JV7BcskImu+tfuRv413
	 5OA3+7Btjqd7cHjWUe0jm44sJ9oAWMjMQpKD1UmVVfYKO6ace9aUCHcxVxpiWEXoAS
	 XQxK9UhmWfnbA==
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-79495b1aaa7so77300627b3.1
        for <linux-mm@kvack.org>; Thu, 12 Feb 2026 01:22:16 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXxyqYceO7o/dMOWiK0NhC8XIzQUkdI909wEc/jMYDnyVWzID9eL48uWGSBFovi/LJGtY7FHpIBjQ==@kvack.org
X-Gm-Message-State: AOJu0Ywh5/gXnvfbvgATs7TZ8yl23c1XPxkJByHNgU/ZDv67GpKF85UV
	+ORO06Ub5JtrnNz9E0wEs/Xtt8lSpB0bX1H5znCAWfeGq91U+hlvKo6sNdFqfkmuqnONGgfMA2/
	CehBiwNT28T8oo8uaRZU47ttd232P2pzJJuGzRp6EYA==
X-Received: by 2002:a05:690c:5:b0:796:4626:741c with SMTP id
 00721157ae682-79737672ec1mr24998587b3.52.1770888135981; Thu, 12 Feb 2026
 01:22:15 -0800 (PST)
MIME-Version: 1.0
References: <20260126065242.1221862-1-youngjun.park@lge.com> <CACePvbU3OoGg5-dHXOJk=62AkBxJCLmzwcHdHuPe2nnxfzMLBw@mail.gmail.com>
In-Reply-To: <CACePvbU3OoGg5-dHXOJk=62AkBxJCLmzwcHdHuPe2nnxfzMLBw@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 12 Feb 2026 01:22:04 -0800
X-Gmail-Original-Message-ID: <CACePvbUicBa5Oh4Vz4qX=SV3M3CegCgSJ2GjogN6Cbrkkc-uwQ@mail.gmail.com>
X-Gm-Features: AZwV_QhY5aRCo78B7qZljiipdgbP1hOhUEtLHQD298lzVq1xKMNdXeyikOJ6XuY
Message-ID: <CACePvbUicBa5Oh4Vz4qX=SV3M3CegCgSJ2GjogN6Cbrkkc-uwQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/5] mm/swap, memcg: Introduce swap tiers for
 cgroup based swap control
To: Youngjun Park <youngjun.park@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, gunho.lee@lge.com, taejoon.song@lge.com, 
	austin.kim@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DE6B18000D
X-Stat-Signature: rxnxarmtp5rzfem7trz34i8jy4uidp1h
X-HE-Tag: 1770888137-124678
X-HE-Meta: U2FsdGVkX19rGdOZV/Dp0hAZlV1IL5XQ+0ZnHpGFH2C+yAS+VMSeQGm32vHjjejTDx4WlktNG+4WqLvyhmSzc2EENOeZImUGvz76uqJL4z5sfRWHXiWRB4o/cwPdE78iZDjCWhRHx5kBfJrPvJFi3g5RsEn1GVzvrmBqg1DSnmgIvdelvKbc20yKhfP8sVZOscONR/5E7l/TC5FSUe2h6u1zvL40bAoZn7h2YPSoMIrLfseKk85NsWlsk5rab7jbI7ria1utcQwj5tpQ6zDuxA+ZrZBefnpKsYxrh7bmzHTvNyOAo+6BiovrGiGFRe3VdcFkaEyV3Ygj/+/MQ5GI2zmlUJcU1bzR1rb7huJ8nCUuK40oZ19Qx3zStPHNF1wR+fGRSZShS4LgKv3KK3rFTy/KpRljUqBXa4/XLvuVb6jruQFWHl+87KpIUc4MWTXKg63V20FRHgfllcKRO3N5mrWFoTEUcRp6zTa6LwHkudoUsEm7b8CuYv/NAYPD466G+4WUGAVtGUvwa4+RdH1GUIP7uliVhFJOF3nxM1JBycHQFqbsSrWUJlJFPLDsz9ijLxQlZdnnfPsWDVp9b+YyK5o+TBh8ejesEWw2LXCqlu3QX0XM/TxoIZ5Pu5R2sxMicokYLrf92bns8aMvQD3CYb3cGPqa4JvSt7NjDd4oLcrY/M9+hfQ3jBPU3Ls9HqUmMvml5eh+pu1w+1AxnmjE0+CJTwVBhTNQzZSMS/QXs39CkgtE0ebUMmdc2jjp0cp4NqVtwdCU6PWoemVYz6llKRWQQCtm8h9PJCSNE2GsnRvXRXdLFHFlQ8WUkCNfCtI+jZYFclAvRdK3d6gIMQZ+8491skc9NeT08Vb+6plD402mO4KUPUvLP1sPXbvnQgJ+nNbNGOrUt2n5WP16dEeDNu9tUhW2jsMbFwq/sJQW8yNNKZcAHjBRy8O38eeqZp5bnG14AXGFHO/zEyC5P5z
 Y8GMtGCs
 ypNieY1jEgIdosCjd6hfOGpDhtndLRKShJH1MUFXyGelNOm+uoeV3E899VQRdOPZcA72ycmJBD0IJhWZt/R0/Lvi3eeAHfcARg5c6Yc9rGi5m4ERZVgwq62OTXelycwKPYbyfDb57WjWCvYYeSPmp40nHcKKxGxxxV4F3BHFRmX6P5nsPVskB7QGYtWL9AiEoW8rfrnCyObJL7lA6/e9gVk7zisqM7utZ3m5MYiVnq5zuSZMDrxth0lXFvpdw/3i19k/GNxiM0ZQ8eq8bsgKgtPTd/rHjGrSAUzhkdbsxF6pUVDd0m9E9FjqYMeJIPRzkCq0eOJAetfSW9qk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 10:12=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote=
:
>
> Hi Youngjun,
>
> On Sun, Jan 25, 2026 at 10:53=E2=80=AFPM Youngjun Park <youngjun.park@lge=
.com> wrote:
> >
> > This is the second version of the RFC for the "Swap Tiers" concept.
> > Link to v1: https://lore.kernel.org/linux-mm/20251109124947.1101520-1-y=
oungjun.park@lge.com/
> >
> > This version incorporates feedback received during LPC 2025 and address=
es
> > comments from the previous review. We have also included experimental
> > results based on usage scenarios intended for our internal platforms.
>
> Thanks for the patches series.
>
> Sorry for the late reply. I have been wanting to reply to it but get
> super busy at work.
>
> Some high level feedback for the series. Now that you demonstrated the
> whole series, let's focus on making small mergiable baby steps. Just
> like the swap table has different phases. Make each step minimal, each
> step shows some value. Do the MVP, we can always add more features as
> a follow up step.
>
> I suggest the first step is getting the tiers bits defined. Add only,
> no delete.  Get that reviewed and merged, then the next step is to use
> those tiers.

Just take a quick look at the series. I take that suggestion back.
This series is actually not too long. Adding the tiers name alone does
not add any real value. I actually need to look at the whole series
rather than just the tier name alone.

Chris

