Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 842A8CCA471
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 06:04:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE76A8E001D; Thu,  9 Oct 2025 02:04:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBF778E0002; Thu,  9 Oct 2025 02:04:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFC598E001D; Thu,  9 Oct 2025 02:04:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9FF818E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 02:04:18 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5910C11B138
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 06:04:18 +0000 (UTC)
X-FDA: 83977535796.09.C948C21
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf20.hostedemail.com (Postfix) with ESMTP id 308641C000A
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 06:04:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=l9ywbguT;
	spf=pass (imf20.hostedemail.com: domain of yadong.qi@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=yadong.qi@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759989856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bX2CmiGH9cU2/SkYhdfhaISvrY/NYRlNzsQnhnysgAs=;
	b=jfLVkIA7oEDyOORibCfgbH4C0+GNGH3vL5flJkmnkB6EWYn3Nzg2UTCdZzkm9eUvqFjArQ
	4JV5hlDFphcimKh2IGZVRvsoGE+BN9akSRzy25Ggirm0sQ3Aw/nR/WmFuB6/aMKzVXPW7y
	N/plXkzBFFXDcAdoBZQSfW8TL55mz4M=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=l9ywbguT;
	spf=pass (imf20.hostedemail.com: domain of yadong.qi@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=yadong.qi@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759989856; a=rsa-sha256;
	cv=none;
	b=InUPV/GN2LA+21OFYbhNB6XK42hjC7rQ/xpClWve6yMDBp+YFD3F0VLseIwPCqLGdQhBAX
	3AB6ZFytRfo1RhaULbSqSn6xBh4Lh+praPwObB0+HMafvH9uwMwuOfRAAPy2KXmqGOz61w
	RGU3a1XPA+v8KbS5GVjE7PMd5VK0f+A=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1759989850; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=bX2CmiGH9cU2/SkYhdfhaISvrY/NYRlNzsQnhnysgAs=;
	b=l9ywbguTXPrU4duYFZoVxImwpAP3/Bc3NCuLYMde25dZdutlDFHn4WqPADkTf+W8YXqwssN09NhpmQBCPUK2RMtoPWedQNiA4rKqVLypgknsB+h+rS6fqVgF8d2ajcgB4MqMe/kJtuRdEwKnOlnV7V7CSGn5ozjJWes8jkQlc1U=
Received: from LG41624401116(mailfrom:yadong.qi@linux.alibaba.com fp:SMTPD_---0WpjGwvU_1759989848 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 09 Oct 2025 14:04:08 +0800
From: <yadong.qi@linux.alibaba.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: <urezki@gmail.com>,
	<linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>,
	<ying.huang@linux.alibaba.com>
References: <20251009035943.526-1-yadong.qi@linux.alibaba.com> <20251008211714.5a8b9fbb57dbe454cd4a9c6d@linux-foundation.org>
In-Reply-To: <20251008211714.5a8b9fbb57dbe454cd4a9c6d@linux-foundation.org>
Subject: RE: [PATCH] mm: vmalloc: BUG_ON if mapping size is not PAGE_SIZE aligned
Date: Thu, 9 Oct 2025 14:04:08 +0800
Message-ID: <000d01dc38e2$86ab7460$94025d20$@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQEfqa1TUb5DdaMeKJ5HQMODeYaJIQI0Cl/AtiDDkRA=
Content-Language: zh-cn
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 308641C000A
X-Stat-Signature: nymcgqnjgynqn3f79se1mb84ch4o8i4b
X-Rspam-User: 
X-HE-Tag: 1759989854-23965
X-HE-Meta: U2FsdGVkX1/u60DIVC+EncbwYHreScRGK18/Oi5PsSJadJQNlgXSg4tQ92akTlYGcAlS+3/OFHHppR/JDVeq/IUyp3LKAf369/3boEWdYdO/tsG74nlF0XfIgAq0MUFBw/EtqfwPA6A2tnMk46e7zPp17UdLuKTZ05j1SW0OKc4OJ/wcDK84fzWuI56562ddN2itzimJwCXbPEWOw+WQDvGkAVl5h/EYhbF4nAQ/5cXrf2DEuGaPnLZiRekWvL+A5w5Wwb5lUPSr4TT6fwTqQ694/bKa30jgqRH2YJHKSyQeFJ5Bgp2KL4/AIjDoDqFqDZxREa+6H2qrz27BSdAbWHABYvL9ubmM7L1w17brErOGgueU0T8Xbmnc0mlrEwUgJmEMrm6i50Y28Yrh6uxlnM8Rwp1B3beBYG4ZYL5Pqrlb/IwkawtMua89HF3AoUJwZrbbwpudHdxydmFapkbt+diCoptWS8zCAEFZh05PQpcX2KKcKFvBSO6Jo8XMq7OC1qVVN5S6Qo1orZt06BEFiE+B2kMenJp9kQ8i6k5k3sstrhSTE4XPIzBDEOARIX5Xgqcuvu542NZ+64K2klsq5Fd9lHj/fiwQDvvOPP4WRGqLjOTl5XcJMJFST70vkdh5ZvnOFtpW+GOieb99HVUOKcK6Ozer28eOEn/UE/S23CufnDsGJ7a20Xk61JxGgP+xl7sbgcbZC7XwO6pj1kgvi3QBRhNMF4eHhlWFdDmo47AmlMDGiwrao6uyL+1W5qYhYqPs7WCdbWtH5zzNnY/wbqnS9ApYs6Pn24nuj6txB7oD5tEupTOOig0qsi09vXLmEr8r/1M/xAZjrURGEte14+tFwSdTTKlQkhd3b8CZqsDncoosG67rpgBN3YpQmewc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> -----Original Message-----
> From: Andrew Morton <akpm@linux-foundation.org>
> Sent: 2025=C4=EA10=D4=C29=C8=D5 12:17
> To: Yadong Qi <yadong.qi@linux.alibaba.com>
> Cc: urezki@gmail.com; linux-mm@kvack.org; =
linux-kernel@vger.kernel.org;
> ying.huang@linux.alibaba.com
> Subject: Re: [PATCH] mm: vmalloc: BUG_ON if mapping size is not =
PAGE_SIZE
> aligned
>=20
> On Thu,  9 Oct 2025 11:59:43 +0800 Yadong Qi =
<yadong.qi@linux.alibaba.com>
> wrote:
>=20
> > In mm/vmalloc.c, the function vmap_pte_range() assumes that the
> > mapping size is aligned to PAGE_SIZE. If this assumption is
> > violated, the loop will become infinite because the termination
> > condition (`addr !=3D end`) will never be met. This can lead to
> > overwriting other VA ranges and/or random pages physically follow
> > the page table.
> >
> > It's the caller's responsibility to ensure that the mapping size
> > is aligned to PAGE_SIZE. However, the memory corruption is hard
> > to root cause. To identify the programming error in the caller
> > easier, check whether the mapping size is PAGE_SIZE aligned with
> > BUG_ON().
> >
> > ..
> >
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -100,6 +100,8 @@ static int vmap_pte_range(pmd_t *pmd, unsigned =
long
> addr, unsigned long end,
> >  	struct page *page;
> >  	unsigned long size =3D PAGE_SIZE;
> >
> > +	BUG_ON(!PAGE_ALIGNED(end - addr));
> > +
> >  	pfn =3D phys_addr >> PAGE_SHIFT;
> >  	pte =3D pte_alloc_kernel_track(pmd, addr, mask);
> >  	if (!pte)
>=20
> We try to avoid adding BUG()s - deliberately crashing the kernel is
> pretty cruel to the user.  It's far better to WARN and to continue in
> some fashion so the user can at least gather logs, etc.
>=20
> How about
>=20
> 	if (WARN_ON(!PAGE_ALIGNED(end - addr)))
> 		return -ENOMEM;
>=20
> ?
>=20
> (Or VM_WARN_ON)

Sure, I will send a new patch with WARN_ON.

Best Regard
Yadong


