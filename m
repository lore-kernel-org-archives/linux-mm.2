Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2182DCCD183
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 07:35:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 561AE8E0007; Thu,  9 Oct 2025 03:35:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 511F78E0002; Thu,  9 Oct 2025 03:35:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 401908E0007; Thu,  9 Oct 2025 03:35:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2AE708E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 03:35:00 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CF790886FE
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 07:34:59 +0000 (UTC)
X-FDA: 83977764318.10.9947732
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id BDBAC1C0004
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 07:34:56 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=o9bHquSI;
	spf=pass (imf20.hostedemail.com: domain of yadong.qi@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=yadong.qi@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759995298; a=rsa-sha256;
	cv=none;
	b=0UhGVvfmWnh7gV4V4P3Lj4EQfCzuZmGxvXyuu1eb+OWRbB9C7yyie0llFE2/kFIAeOy2cw
	PAJZalQhEpyjtd+4HShx+ucd4CDWBm90KoeTFKo+PcSvOSrAVK/SMtn/FoR+fAZw4sqJ09
	RBXztfHZ9fa9o0vYs6nLnI8NWiGx7hs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=o9bHquSI;
	spf=pass (imf20.hostedemail.com: domain of yadong.qi@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=yadong.qi@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759995298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fmkkQQ3u5wzLEz28oroV4vlMCTJQvx36W8GzggAdlhg=;
	b=zRshwWZjHl1xlYvGkbX4i22U66kM9DAyL6pWzDJkwn4meIzXUBqVHrZ/kBwCas4Bvo+6nJ
	FaHqAbmBOj0+c6DKSQ6dY9FBV9rGuF4TKE90F+dPt6Kg7xZHK4k6vpJ/EYVOB3NnslIgtG
	YaJnB6oZA6cJF1blSRr3HAsa9qXL22A=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1759995293; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=fmkkQQ3u5wzLEz28oroV4vlMCTJQvx36W8GzggAdlhg=;
	b=o9bHquSIhKX7B1K7n/szHMcKe03H1Q0Y+N9wBk4MFBt/qlEWmY/iS4feh1oDlutrGyC8HnA/8ErrKs0ip5aIX8FVNxA4mX+rJoYrKKpJrYCXxRs6Kx8OcKy1Xc4IDDnSqHlQt9HfL0SF68SCCwwEj/xFyPDrPr9L+zkoFK0B+zw=
Received: from LG41624401116(mailfrom:yadong.qi@linux.alibaba.com fp:SMTPD_---0WpkCT8Y_1759995291 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 09 Oct 2025 15:34:51 +0800
From: <yadong.qi@linux.alibaba.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
	"'Huang, Ying'" <ying.huang@linux.alibaba.com>
Cc: <urezki@gmail.com>,
	<linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
References: <20251009061410.820-1-yadong.qi@linux.alibaba.com>	<87zfa0tw9o.fsf@DESKTOP-5N7EMDA> <20251009000356.8e18395dd9979045e0c66de2@linux-foundation.org>
In-Reply-To: <20251009000356.8e18395dd9979045e0c66de2@linux-foundation.org>
Subject: RE: [PATCH v2] mm: vmalloc: WARN_ON if mapping size is not PAGE_SIZE aligned
Date: Thu, 9 Oct 2025 15:34:51 +0800
Message-ID: <001201dc38ef$33162220$99426660$@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQDNMrr7Fq5t9NtUPwBpedxNSvimKQKJivZeASdK0me2ue+C4A==
Content-Language: zh-cn
X-Rspam-User: 
X-Stat-Signature: xdyaz53mbkiiezmos8itiyz3kbrgxora
X-Rspamd-Queue-Id: BDBAC1C0004
X-Rspamd-Server: rspam09
X-HE-Tag: 1759995296-972079
X-HE-Meta: U2FsdGVkX18xt1oKgs5sv/Fu3635n0KfDbYW4jtWZw4yrOqFz+XDRGQq1t//ha/zXS01eqzABMVFnbCz6UwODYwGIFkFskt5JebyUJ9Oe6aIz29duRPvviR9K8MMSJtCj98Kqw8Lx1TRYTDxovEMvKS1sp92HUDMcP5tEQIJHYlBr0qysoWFnx4XdB7N5QzCzxwEJIYt3lHmqz2e1o6nn85AGq6j8Jsy/tyUfz50tUgyt/eJW16H7NBtyz957tduK214YF28ssuMwGEax8kvwEAfTlszcVA+ugeLk0iMc8lk5zIyUyMsA2iIB1GnnP5pLg0wM4lzKJS8lZMMIoMMcvR3APsC0ZKNkASg7JSo37ZYTHJacNIANSkqmIdspQbCSumholBQT0YPeSEAY8UXh3tCyHNVBVzizjU0YkT7UCWxagz2D0ElKkmMNwWG3TfDc2VVuhmNr6LiJLqzkEIh6yXEMl64YZ+7dqpboGWfgusBL7yzBDK8CrzRJmQuUE9iVApqcIk4ulFoCmCoKZL7THMo+2WMUwZni20f0gRhNqawYtOvxpdCTzv0qiA73PxUf2mXjKecxMDxiyJA0pkxo5pFxx1hGqjK7Sj0gRcJVxlF6e9gV6WttHjgIhXB82Ezx2sM2PgYeYcEasPSh0A1P0rAl9KKMuUchy4d6vPNeLF8lreoN+E6L6ZinhDHwnWcyEphxRlIxbg89qznXaYfFoX1BX2oVQw+iiPDsIeEp4e+ydD/wpSU+dE3iqabSlwGZtlOg1YinOOqPE4YVLyAO9PHfVYaBduz4n3RM/8q9FCZ8D67HYHiZ69Xk5Y8/5Asky8ER+r81iyFYafPb9LQaZSKXxA7JaLarseJytI8UcxYsev2yYVExZnnfRipdvM/QmlXIsAgybtwDcO9iZlbMBolf+0AFTmzC5gc6OPFT0aGykKplcWWCp8CbGwZHghYg9kNXlcBCFqWVme7SFj
 2c9uY5K7
 vY09p8sIyCCq3kW1JNbtxhA+7S6mKDa8gFEMdf4E8fExbDbaPhyrtE2I3Zk45tWcMGhZ/t5BBkrcJyD/7OYi5det2KLilvufyyec7KMNWTR5u2f9OjQImkIGilQ0FxtBfSRSQKsxOKIS8RrKsaPjUyoCs2W87mLXMei+WlRZXkXLyAzm7qeNXWJ157X0BH3auVFxLH/OpdotaR674V67GcldSfgq2evKViImXntWkl6av7z/SarYH3NHmMkgqTxqieU8riBwGPoWI6V1ekVwBAWkjKq57Mxl9BiP+XFmA4Wa7oCS8egSY7XbkNDFtLq0w2IrObPPxx/zYxO9QzdOS2090hNkcs9t5IiUPc7KyMZ7EyIlVtNVQBcuVq4G+WPIa6/+31gcgACUIiPzECkr8tI0EHsrwLSI9ff1Mx5wKxr4VW1/yyh4ZA+DQFw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> -----Original Message-----
> From: Andrew Morton <akpm@linux-foundation.org>
> Sent: 2025=C4=EA10=D4=C29=C8=D5 15:04
> To: Huang, Ying <ying.huang@linux.alibaba.com>
> Cc: Yadong Qi <yadong.qi@linux.alibaba.com>; urezki@gmail.com;
> linux-mm@kvack.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v2] mm: vmalloc: WARN_ON if mapping size is not =
PAGE_SIZE
> aligned
>=20
> On Thu, 09 Oct 2025 14:38:27 +0800 "Huang, Ying"
> <ying.huang@linux.alibaba.com> wrote:
>=20
> > Yadong Qi <yadong.qi@linux.alibaba.com> writes:
> >
> > > In mm/vmalloc.c, the function vmap_pte_range() assumes that the
> > > mapping size is aligned to PAGE_SIZE. If this assumption is
> > > violated, the loop will become infinite because the termination
> > > condition (`addr !=3D end`) will never be met. This can lead to
> > > overwriting other VA ranges and/or random pages physically follow
> > > the page table.
> > >
> > > It's the caller's responsibility to ensure that the mapping size
> > > is aligned to PAGE_SIZE. However, the memory corruption is hard
> > > to root cause. To identify the programming error in the caller
> > > easier, check whether the mapping size is PAGE_SIZE aligned with
> > > WARN_ON().
> > >
> > > Signed-off-by: Yadong Qi <yadong.qi@linux.alibaba.com>
> > > Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>
> > > ---
> > > v1 -> v2:
> > >   * Use WARN_ON instead of BUG_ON
> > > ---
> > >  mm/vmalloc.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > >
> > > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > > index 5edd536ba9d2..2cad593e4677 100644
> > > --- a/mm/vmalloc.c
> > > +++ b/mm/vmalloc.c
> > > @@ -100,6 +100,9 @@ static int vmap_pte_range(pmd_t *pmd, unsigned =
long
> addr, unsigned long end,
> > >  	struct page *page;
> > >  	unsigned long size =3D PAGE_SIZE;
> > >
> > > +	if (WARN_ON(!PAGE_ALIGNED(end - addr)))
> > > +		return -ENOMEM;
> > > +
> >
> > EINVAL?
> >
>=20
> If this errno gets returned to userspace somehow, programmer is going
> to wonder what was invalid about the arguments which the program =
passed
> to the kernel.
>=20
> But either way, the callers of vmap_pte_range() should be audited, to
> verify that they take appropriate action when this happens.

I believe we should modify vmap_pmd_range(), vmap_pud_range(), and
vmap_p4d_range()
to accept an error code from the callee instead of simply returning =
-ENOMEM.
If there are no other suggestions, I will create a new patch.


