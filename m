Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0631CD4F4A
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 21:51:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B16E6B0005; Mon, 18 May 2026 17:51:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 063196B0088; Mon, 18 May 2026 17:51:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB9D76B008C; Mon, 18 May 2026 17:51:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D9E326B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 17:51:40 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7E2A7C3245
	for <linux-mm@kvack.org>; Mon, 18 May 2026 21:51:40 +0000 (UTC)
X-FDA: 84781887960.09.61D268E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id B0ECD4000D
	for <linux-mm@kvack.org>; Mon, 18 May 2026 21:51:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=V5gIlmRp;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779141098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ui35YCdMhextVXvfGs+RH2GaTpNCHxdrnIA0sTujsfc=;
	b=6ZE/MXWrOwQdPKbTLRnlIcxuT54KBGA7i7tUyn//3Nk4q4pWiZUuL85P2gHvcbLPiyj+5F
	Uc5qBYOSaNU6teoMIIw1jFmmyBLrY6X3HyRiFP05KeWXIdbg+t1TKLwijFYGk2pWMPP8ow
	wX8IO80buAAa7KXtf01Ygaczkj/R2G0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779141098; a=rsa-sha256;
	cv=none;
	b=KxuknrpC94sh/P9DCxVIstLMC9wjIRodrDxLAHSnEU1t3qKEqwXzTzcCL0NMco6Uc6/DoQ
	zMRb6nvuqY76Yg2iAohezTIvcZVag859NFPTBrwIeoTedaZHjXEJHNK7cpc8in0kh1EjWY
	f0kXsKYi0rkrwdvISC4EpWoHkOQc/vc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=V5gIlmRp;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B02BF43A50;
	Mon, 18 May 2026 21:51:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B98F4C2BCB7;
	Mon, 18 May 2026 21:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779141097;
	bh=aY0k4+s5LAO5ZCe+6y3wGxrecziQGleYEmIT2C7RsAc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=V5gIlmRpxo83oYESxmn2FUqFW16HCxf5eNhXcuYyPf+PrEAtWC3zDMa1wNbKl8Tg9
	 arCFDZ4fP3F18zRuYhePFadE6sbHei0gF577GFhwrtn2saa2mVJuiTANJNlu7s93dL
	 /Ld3d0fEdIJ8N/odDjcPG5/nBV1IMMn8Ox9N0WKg=
Date: Mon, 18 May 2026 14:51:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kairui Song <ryncsn@gmail.com>
Cc: kasong@tencent.com, linux-mm@kvack.org, David Hildenbrand
 <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, Hugh
 Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, Kemeng Shi
 <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
 <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Youngjun Park
 <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, Roman
 Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Lorenzo Stoakes
 <ljs@kernel.org>, Yosry Ahmed <yosry@kernel.org>, Qi Zheng
 <qi.zheng@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH v5 00/12] mm, swap: swap table phase IV: unify
 allocation and reduce static metadata
Message-Id: <20260518145136.8541d74ab64d3d42d9f1a4ce@linux-foundation.org>
In-Reply-To: <CAMgjq7DryNOmJbJ38tiwFadVT3oaMTTtQ3=BxD70s5AVjG8pbw@mail.gmail.com>
References: <20260517-swap-table-p4-v5-0-88ae43e064c7@tencent.com>
	<CAMgjq7DryNOmJbJ38tiwFadVT3oaMTTtQ3=BxD70s5AVjG8pbw@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B0ECD4000D
X-Rspam-User: 
X-Stat-Signature: mjr315ohsdji3z1zmzeudrj1y3kqh8gr
X-HE-Tag: 1779141098-532851
X-HE-Meta: U2FsdGVkX19dtxM3w9IKqBUEabu3Tbc/5nuRbAdqx//FRfYSPXjQjXqdwnAvQQkjJX0RLD+1Ag5VM5+Cn+byEqaDU7UDwE98QVoHoh+X6d40mQU9ssmEe8jyePadPOHC7m1PzzvXWwBX0grxH4LZekQHdOtT4PatqtnbdiCSbxnjHCNOzIBNtOMphjlds3KDwKCpJuWZqeCkAS/ULu8zEYpwxGzps059Wy8Bx5COCJoYybCLHkbzA9CXRd3fP0E3DYkD6BPAJpg5MTFFckgc0Cn5SDXLUU+wXSXvPWH5/yBxp6NejUDaQRG2fBQ1u7xtQSbk352TNYxogM3azKcjN3oXwc7JdU9so8mlhb5iOGnEphcnAAT3raucyUPuH0tO9bLh+/33MmQqR69ia0pzgvHMY8dKSzHBv46JlO6S/nPdY2xBolKe4tszV6UchanRsvjWHkqiMwKsF5Ynfrizgzdtcy5UrZqGOWoj/1m5Z3SpeOEk2a74qpEjwkHVCjx/eXEQuZbtQi2dQEpsYfEm+++wCD4mD5N6qPzA+IbA81BoR/aJZPDG+b4kwrXImuSOhWITPB8OEXMCfXg1Ai53D1A4eawUwGuXC66YVmPZ2eTEtVCjMu3ifTu0xrxz7hV8qj7qR9jfcCKnmMZw8241kZ7an4lbTSmYBRavnHikOgSVYY8WFIpNafzK/nK+Cza6u9CKLqntk/zJFDr5bG9s39+Ui3QXMuPy5k0fQU46MfOtB4XD2mQ3f42a15bH+susAgexAfsoVLDsgzJQLDR6x6w096g3Am7oLH84I0erbO4ToVdu+iXF9doFblKjBtGjz3H7xZyqz1zz/BLbKgVv7qZHZA+LJjTfqAws3vsHBESmeCxmlyruqB1J5CytJIJtdh02wnM2LiDeGpDlDEp1Qlgumm1zDtionDtV5BXn9up4ss2a0libSVT2ZZtiA//wP6qgNGNDb40ifnXZCbY
 PRRFvS3O
 cKiOKKtk4xyqnndCvXXnZcbMB8wVXlXQm0L29Wy4qRJ/jAdN9ZrSAQ/qttK1a0URWdtYJX4DiheEUeXHD8So1lYKcBoeKtWaOtsFiouCh5v+R0ia6pIyPPz0e9cvjsKLCpTyg+jI1LNGCxdYcnwxFqK+qNCL+JQcNI7Jep5plHkfx9cypMO7sAlZLNdwDO/7TPziL4VSzQUu2fDvPozA/+fYLhptChtOX7kqZe7pkBPplvVG+ZUjUi8g0CvQ0lGsJBuSeh+GXwhAuMDCic/xBB7LzSLyeTHg3UI2whOd4xfe2OgvUxgnVmUKWcCWlC6tGlMi96Xe5NejW4NEUEj2Fc5x3v9DWHqlyXPt0c+Qu68WyTY+zmKJ7XkbiZrb+HkT0aQSjON4GOScv4frCkHmNIGXwLw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 19 May 2026 02:11:35 +0800 Kairui Song <ryncsn@gmail.com> wrote:

> On Sun, May 17, 2026 at 11:40 PM Kairui Song via B4 Relay
> <devnull+kasong.tencent.com@kernel.org> wrote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > This series unifies the allocation and charging of anon and shmem swap
> > in folios, provides better synchronization, consolidates the metadata
> > management, hence dropping the static array and map, and improves the
> > performance. The static metadata overhead is now close to zero, and
> > workload performance is slightly improved.
> >
> 
> Sashiko only gave a warning this time (and it's false positive):

Sashiko behaved unusually.  "Note: The format of this report is altered
due to recitation restrictions.  Direct quotes from the original patch
are omitted, and a free-form summary is provided instead.".

	https://sashiko.dev/#/patchset/20260517-swap-table-p4-v5-0-88ae43e064c7@tencent.com

Roman, what's that all about?

Thanks, I'll add this to mm-new for some testing.  Review is thin at
this time, but we have a large and dedicated band of swap maintainers,
so I'm sure that will change ;)

I understand that there are some architectural/directional differences
amongst the team (or there used to be), so please don't be shy about
weighing in if you think we should be taking things in a different
direction.


