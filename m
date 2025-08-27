Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90C8CCA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 10:13:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1DB66B0273; Wed, 27 Aug 2025 06:13:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF4A06B0274; Wed, 27 Aug 2025 06:13:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A31B56B0275; Wed, 27 Aug 2025 06:13:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8E35B6B0273
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 06:13:49 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EC9D084A78
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 10:13:48 +0000 (UTC)
X-FDA: 83822126136.23.44BEFDA
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf16.hostedemail.com (Postfix) with ESMTP id DD773180008
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 10:13:46 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=ODM7JvN9;
	spf=pass (imf16.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756289627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xvz3uUjRuvVIHh8nICa0VrN9xloppL7sG2j0TF3CVXY=;
	b=Uv+k9VJkIDZjh6YIPvHwTwSiMIWbzGBdLIls6cDinprZnmL61xa334kXBFnWWzDfiqij2y
	xY9e4EwBcNYQITN+VjFM9Q/2FoYch0GDmCB5SP33nViLUaA6hAfUs7Xhc0lSBc7SpiRTlE
	y5CFFTD8WfKcdIvONzhI2NUY38DNSEs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756289627; a=rsa-sha256;
	cv=none;
	b=jr0ertcCqA9/IOOy+rneb7U438rA45wdi4KvKuu3XikE3zyXJOdsqcaHz3/Tls/XRKa90J
	WDCOgyw3DcC/63IoNHtIc/k/6Ve7NFPwdpK/yZQsX7NEGrT5CVC9AdkPfipsPjep2N5TEq
	dJNvkMF1M6Ayo+133mQrXl5DGkqLmfE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=ODM7JvN9;
	spf=pass (imf16.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-afcb7ace3baso1180708966b.3
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 03:13:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756289625; x=1756894425; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xvz3uUjRuvVIHh8nICa0VrN9xloppL7sG2j0TF3CVXY=;
        b=ODM7JvN9KVyUaDb3FL1b+/u7vZ2nTfHVchXoOaXyvVx6KFGH49qGNUtaDR7oX1fK6P
         KyFkpgErvTVTZiwkNOXh/+CWBwZ7lHlyd50uG+ClE6s0rDacNj2NkLYG65+c7yvcYKwN
         csVk8IQkF617wD20ugHD3b11DtqZOrlZ8ZuakFl0uM8Xa2ekwinEgfr+xg1Rd5R/kQYy
         89kQmWt9RRa2hkHMXXA+aaNTSGKzrx4n9KAfIEcTMrtV+oQ+wHboKAl/ikAfcLP0MnEs
         FqX18lKr5BpZl62mCz86i+P4jbQ1EO7sVBIQgR3LnEXYZyEKxZLIHx+3xla/XfYvA/GN
         CeZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756289625; x=1756894425;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xvz3uUjRuvVIHh8nICa0VrN9xloppL7sG2j0TF3CVXY=;
        b=T2BzVfEpLl+0osogdqpIMTVWHHFBzeqZAXIBJNc5MOy0sfKAU+QZG2EGjIyPQb+zVQ
         BL/kAnrY9Bb0+UHScn7DZRC2D/D1sfOGflavkLUZKvHadJr22cvWJL5jV+6r95j2Sq+M
         5Yi7l/xuEcrd+6LnyAc3thsKiXC3z0/vATqs6pexLcMWAt91zMqnqcNsINQYJOMM361D
         yhMeIaUaSQ1X0BtSvkBrYI/63g1yeGTcA/i5h6AnF4hbkfYmBcyvDB1Jp3sK39ex38SV
         A2wSsjGl+5tohaEJkqSGLW0VTnQ9Ax7TMR/ZVQvUH2GPTsdXpn3H6HgOgVWB0bvjE/VK
         CEBw==
X-Forwarded-Encrypted: i=1; AJvYcCVPjsXOE8vQezbY4L0uwCuj+V2dym6btRV+wjlGBp4XhmRj1BaKViwa2X+5QF3MvsiOSgQMtisoJA==@kvack.org
X-Gm-Message-State: AOJu0YxsSgsMeGaZekxwswsr4tAYtfT7g0FJO4B5a9RwxlBG9b9YHQGu
	AO1uUjEZsSjIIsyLwzCDtYvGtfC0BxwrLTV7Cy4q4FEvdxKH6RQsiU4no7rSoiA1+vNtQ6Pd8va
	PIXnPL3b4pHAhoG82sTHynl6ZXPIBx9vYmMtJq8MnTw==
X-Gm-Gg: ASbGncuRFl3BAaAbMKslJnuxizqvT4nWnnCYUei5U4c39juIjSs0ahDJ3RiKsqklr4k
	ILuAsqLMi/R01XACk9EuYGcf/3Xw+k+DVkuv70ghWRXQdc/ibGj1b69cyqd6RfdNKONlFaEXe2k
	/64KkWNuYgcr5ZmL3U8xbOXd9aN0ZUgsweLR2zLtqgQy/bmmz/0r/ymhQ5erDjqDeGGF3CF5Eho
	96WSxhmm2wdio4KrknvnN0Lbnm+lmkgvT0=
X-Google-Smtp-Source: AGHT+IGlilblub0beLftAWMWI936Ykgkb7W6amQCxE7/3U6ErRHHtfFsJXaGAy/lTybsJEEc8106tAh730j5a9SzDJ0=
X-Received: by 2002:a17:907:97ca:b0:ade:7c6:498a with SMTP id
 a640c23a62f3a-afe28f767a7mr1748711666b.10.1756289625193; Wed, 27 Aug 2025
 03:13:45 -0700 (PDT)
MIME-Version: 1.0
References: <20250826231626.218675-1-max.kellermann@ionos.com>
 <20250826185515.7fbe1821713195b170ac1b31@linux-foundation.org>
 <CAKPOu+9wz9g0VuYDPiNDYdaGG-gdK86h1gGSCmVPsC2a5f-GPA@mail.gmail.com> <e5783c3d-7eeb-41d9-9fe7-730155f9bf17@redhat.com>
In-Reply-To: <e5783c3d-7eeb-41d9-9fe7-730155f9bf17@redhat.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Wed, 27 Aug 2025 12:13:34 +0200
X-Gm-Features: Ac12FXyu44OsYHZBPwR3H1LV2YZSl9vQxc7lNHNMlVr67uXAXYPJVZpR4sRqqmo
Message-ID: <CAKPOu+_8_gfko=Sh-YKpbgcMy0aJB=m9yrC5JJKEZm=yeYPOgA@mail.gmail.com>
Subject: Re: [PATCH 1/2] huge_mm.h: is_huge_zero_folio(NULL) should return false
To: David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, lorenzo.stoakes@oracle.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com, 
	bhe@redhat.com, chrisl@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DD773180008
X-Stat-Signature: px5hiz4kmj3goesoa3b38gbqy4cqn79o
X-Rspam-User: 
X-HE-Tag: 1756289626-559527
X-HE-Meta: U2FsdGVkX1+J9by4Omh9Hs8v2R6VpFbbqQ+pei/B37TrfPZof2l1LmM28y/dx6AUj/7XjSpl+oZCWdpb5dVEdPTrKnEBZq55FpyPAuaBSt5emdFnSV457Xr80UHeHB5dyWHdRAlyOyExsL520qbcOr4H2MInp78ZFVJWRe2lUwQe7aV5kITYH8JQ0BtL7H3VRPwtgO7+tOJydDlg/T0QjnScW5x5yuXSjkX6LhDgELstBx4SKspSxaTGvU4m22/kL7WqDnWbHxM+z59t679vJ4jIc/BEYrQPfK+AeCsWtbHhFz1k6sfFLcs2aaTCR5awekMiI6lRqUdifky7O4t7ToPKBQmygCPpNjklV6xsGyBh8Ogzsc5yzBZy6KlKYl7aVCYKyFIOdBjq8qxVOUvOEya1QBYABANLnIpeqxT97uyny0rEnZaHuFhlwegOEmH4nSUMInQOWzxZhbU7gh8HuxL22n2Cw3ve+zZyg9fIrvwcEqjgTj9XffZtQlimm6MgfC5uTn08evO9sKMJxKoZxozRZdfzGdslR53Q4YZaJpPxUOFzx6ir22v+v6b+DQvhBffBYGA91UleV7BUQQuFbZIFTZq0d3FTbWxiJB9Tfr1lkuvSfBJnnPrwDPl0scMtZAlfMgU9V4CZlETsmtfGPoKgRSye28Lt7tGnxd9o3A8+9kLxrfyaGrmrBUbWQw0ShE+VnoR5HDkJ7WLQrHUU6dn8vZGrCP28Q02TVYBGAXDKjRls2Mcc11zsC+HO6Rmn6gCTpCP/h1y7DkZtTvGQgLSbn+L1sNUZzvVNu355VHOB+R90luZpIbVrMRbNFZbdj/vBpdSq7IAehVg01btKpdK+VbOjb26/eX9FBTfIG6iTsNqNEXPyOE1wyJr2GMwCiv9Dq86gjsRNPu5F+z4gGGgirTlY5dtK09P30G6Y8MbfjQwa70Vt9uWEWyn1scm2YfxeYx4b5Uw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025 at 11:36=E2=80=AFAM David Hildenbrand <david@redhat.co=
m> wrote:
> Why should it be allowed to pass in garbage (folio =3D=3D NULL) into a
> function that operates on valid folios?

This patch isn't about the function parameter but about the global
variable being NULL.
(Don't mix up with my other patch.)

