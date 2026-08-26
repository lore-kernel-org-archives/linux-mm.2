Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CBA8C5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 21:03:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 078106B0088; Wed, 26 Aug 2026 17:03:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 027B56B008A; Wed, 26 Aug 2026 17:03:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7EA56B008C; Wed, 26 Aug 2026 17:03:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C52416B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 17:03:09 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5D0131A023B
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 21:03:07 +0000 (UTC)
X-FDA: 85144645614.10.2F97A45
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6D419C000D
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 21:03:05 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=foIPooo9;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787778185;
	b=k4h6uU/qK8HpV8acY1rKlP4zCGFLF6qveX065btwSyfYkQQJd0v+/Hyw379ZRZuoGsKfEk
	/CTaLdKMCrOy7aEPZDuh1/4xjutCAoxVXbRkGT/Ln70GuF5W9kieqybuEGb7r3b1vK5i1M
	OVWafCSsIk/wuiMj+XVD6jKLoI4KiUM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=foIPooo9;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787778185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5KQzDgyiIPz88ZmSk3EZ6LlItPMqpc2RARdCySgObbg=;
	b=Kt/MFTxhQPF36RBQ0XodnjI4BF8VAuTUQ66mH4iXQdJ8IcYOJeMakSpNG+zUzO5Y1WWhtt
	yNWi85VmOSdiDt6AQeqX9r6BplcTtQz3vlJqxTVCM2zXFVlmg8AZ8QQ0dXBRQsTnvaaUx+
	5u1FdBHwexBgi6uqDQ38gjC5zyXOnQs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D594F43FDE
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 21:03:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B97D01F00ADF
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 21:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787778183;
	bh=5KQzDgyiIPz88ZmSk3EZ6LlItPMqpc2RARdCySgObbg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=foIPooo9AEpRxj35k7f/KTmciK8rtt6Te/B0afzdBDkp4WP1Xkpnq4nkiVXf1vfdG
	 q23EIJQmetVlzQraAdWGlbAofPVf7aqzHPdYcDawHUkQeDZqSSGgEORTHpcc6ueDNk
	 nc5dDLk9OFh97Jt/uqHe7fto/2+eaA6A3/4nfR4zhrGDZYXD9B7Lmire9hFKRLzJtF
	 8wpeQju7aiA6mwNzjK7TX2oldJujslmzVclhw9pwg1Ni3jrn0VX2t8PNfFtLH5fazQ
	 4f5QeZmboTwkvTh/njkGgRNbztn9ZTAHHcjrz8yyN6ITDJ4hjA7fCmAJ2GqWd/FmKN
	 8URnEoPQh18Ig==
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-90cd572323cso1752756d6.0
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 14:03:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rp+15W1/1a7ywTII3fpL0Z8tssvXt7yL6sCcust0NXROPl8nhUgwMWYFRsDUH2ZON6SNQJVZtsafQ==@kvack.org
X-Gm-Message-State: AFuF++mwawHvsXwpf6bY8Orq9DtOSe6E+uWJvRJ8oQ2ciJyhewxtN0VA
	pJEao4oC0DknoN9MuBZNI8z9Q6Pt2rF6Y5YNAIfYYv/BsjJ7tiln/9iozqjVm+k3DZRW9bXGGU9
	Rm4y5l0IQXVrRJ1ggyNagkwKOEfZH3TY=
X-Received: by 2002:a05:620a:9142:b0:936:7967:7955 with SMTP id
 af79cd13be357-937803e7e75mr815574385a.21.1787778182927; Wed, 26 Aug 2026
 14:03:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260826-drop-thp-maintainership-v1-1-3d102748fa17@kernel.org>
In-Reply-To: <20260826-drop-thp-maintainership-v1-1-3d102748fa17@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Thu, 27 Aug 2026 05:02:50 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wH_-2NPV2j6wxN_EfAeXvDe_eUnkj0KVUu0nn+ANfohQ@mail.gmail.com>
X-Gm-Features: AcwNN1UCklyIxHoStaDuT-E1MIb2LN1kaFlTLTeei_p2HLyAvWl8ZP496MYtr6Q
Message-ID: <CAGsJ_4wH_-2NPV2j6wxN_EfAeXvDe_eUnkj0KVUu0nn+ANfohQ@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: remove myself as THP co-maintainer
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: oj9wimer65nxe6o7fdea4aqbtpic4a8o
X-Rspamd-Queue-Id: 6D419C000D
X-Rspamd-Server: rspam06
X-HE-Tag: 1787778185-855117
X-HE-Meta: U2FsdGVkX1/UPRaz0XtHdw8ZcKapTS+vUdYFc5j+tdFrOSY/REmlPUzHDH8O0OgXFk+FMwY+ZOvYT0IOtCWe/s6bMcF86Hr2wwa35V4Zgvpu+XM5/WVi+l10Hk8t/WXOzNfskrLmCN8uE2WXCotxl8VDOsLlVN3G+dZtPNJDkFBxHvSG9fcO1eCSxRICZJicy51f0iGWme9F2sK1reoYB7athqnnZNBewXabvuYgXm/LH7rRGRs2rFo3n187qW6bKx8KuLpBHqB05mt4WLwHV+YCrzgSm1cGfzVCqACwDlItdE4X5CF4JVyCApjqQLMQ6q5JsQjcvEN3bgeiAYJFuZRqssjsp3YFY5REQkKCSrfgU5ZWocloPR8NzrwZK+gbMNXtTo0qF6fKX14NJ7JjWHYdtL2iXt4XL9wrKS9rxbbPqMnnsUwdvCLTlLGlqjImiXNUbx++npmtLRj5YyIN/+zpKkWfwO8dP74rBnmA8y9Ap4HuuJT2J/8VafJOKX2L5u5mONQAyYa+KwSdPYINoBeN2DvnXq+XPClIo38PEj5DDXvfQy02y8R144agvrs9nDFtpB0eVwSCHaLH0xqN3zwWSl/iItJySf9dLy1v1Dk1vSgPUr7DeTqpI1iM9+eb3JdhzDU9m3TxycYbjmncZQLG5NTlk2xmk2EGyO9WQYXrIE05J1n8IhDwVwdJKTUJPtAxF60YWSmVXUGx/sHEoPcwmiaRsKU2dMocsr18FpzU0WqxEFzjpKIoiVbEG/Y/GO2uA8XVv8pVFrWCTFb9vuaqP9subEs5fG9wmPCM1hAFlkfbv/+h+Dy6VkWJdj+wUSIczmzutzvN8t0zsUzSe7ozsQCt6YWGrG2Acs6o/4KN2w3fSkDiEs0nYDyb8CmV7nlYT/cTuJsQLHpjhSxkDU75GveZuoB0YSkmhtIw92SWYQqmFZPZcRKSak+i9rUvqBkvFg2D86CNTdIHl1l
 wbhGFVEl
 lHV0rXDWW1hHMDoEM7tczbGeZFGIF7NqNt2t+sDy9kDf1C8t/FCZRLqtckQmVYL5ixf1IClE4C6vSYh02EnwRa8VWjqNUqLvd/KHKL0mCWh5EJnVszBq0rRAeJFrVxrKI/yTBLpITn96leDMolhiukNgC9VNjKWOMnhti4CUHVq9DLxCy/ntZQDUzJmFGYqXM5w8+gfOXUsnChBWC0HbIgQSrcYoqDgM0j/zfNXVzK7wSQ8vMNfx62LL5pa5B8QHyjWW9XRc5M5zVCbRggu4UIHcPa0gIoHukq2KfBpaa6C42P86VpOVNtiMBg/mnHNvYrNLZRyw0slGH/nc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 5:56=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> Unfortunately my workload is such that I simply no longer have the time t=
o
> give THP the focus that it deserves.
>
> So, at least temporarily, step down from the role.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

Thanks very much for all your hard work, Lorenzo. I can really appreciate
how busy you are, especially while you=E2=80=99re still developing so many =
things
at the same time as doing reviews.

Personally, I also feel a bit bad that I haven't been able to contribute
anywhere near as much as you have. I still have a lot of catching up to do.

Right now, as David probably knows well, my colleagues and I are working
on both FS large folios[1] and mTHP[2]. I really feel that I=E2=80=99ll be =
able
to spend more time on THP-related work and reviews.

Lorenzo, you have my deepest respect.

[1] https://lore.kernel.org/lkml/20260826082641.2007658-1-zhaonanzhe@xiaomi=
.com/
[2] https://lore.kernel.org/lkml/20260825043833.2659350-1-zhangbo56@xiaomi.=
com/

Best Regards
Barry

