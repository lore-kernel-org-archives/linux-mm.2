Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84EB3CD5BAF
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 06:28:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C44936B0095; Fri, 22 May 2026 02:28:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCD546B0096; Fri, 22 May 2026 02:28:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE3D26B0098; Fri, 22 May 2026 02:28:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9E2786B0095
	for <linux-mm@kvack.org>; Fri, 22 May 2026 02:28:21 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 615BDC207E
	for <linux-mm@kvack.org>; Fri, 22 May 2026 06:28:21 +0000 (UTC)
X-FDA: 84794076402.21.5073182
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf21.hostedemail.com (Postfix) with ESMTP id 934EC1C0004
	for <linux-mm@kvack.org>; Fri, 22 May 2026 06:28:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lq5o7TK2;
	spf=pass (imf21.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779431299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1V7UQqNrZ9uHp5/iZSBaT8tXf5HPRHPJw5/0rwYb3Qg=;
	b=21jE0l5g21bH2V1jFke/KaDr1TtmEvKk/ot9Em4WYSPy53XYHRpTJu5ewax/J8LtRK7Xiq
	/jiIu6pwtJcn7E5RPmFbCN4BeR2nD0O+gPwkYZMYoQRn/Cs2gnFl1Jt4c/JaDVFy00wFbQ
	0DT/Dp9foiAA+INIIQJ6Wk7vTSCMBTY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lq5o7TK2;
	spf=pass (imf21.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779431299; a=rsa-sha256;
	cv=none;
	b=mq/c0Idn2RmHV3T8jW+CR1Os2MSUE8Xa8fGGcOzA1nbvW/HXwPZgcq22pRYNPpoVs5Tt8b
	VtJ08b5LD3lB8zNh1mA+Espt19Ozd4bxaSAKlKB+VtHgqzRrobho8WGBOpot5jgL0qUTae
	HXZIthTgBlgzjp4ridinJb55e71CqoM=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779431296;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1V7UQqNrZ9uHp5/iZSBaT8tXf5HPRHPJw5/0rwYb3Qg=;
	b=lq5o7TK2C5sv98lfHMgrVSITzYSD4jMhnl/rsr/dC1xxmIz0sAkB+EhOF0dpwqD3qNx7mU
	fVVse2Kyo3f0wbrnIqtoqtozvQ7vnbeV50hNaOr+qgBkq6S3Dz/D/Bau2JLNPmFuJW+96s
	9IUeMwSqGmlMZ7T/XGOprzFHUl5XRxY=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v2 2/4] memcg: uint16_t for nr_bytes in obj_stock_pcp
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260522011908.1669332-3-shakeel.butt@linux.dev>
Date: Fri, 22 May 2026 14:27:41 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Qi Zheng <qi.zheng@linux.dev>,
 Alexandre Ghiti <alex@ghiti.fr>,
 Joshua Hahn <joshua.hahnjy@gmail.com>,
 Harry Yoo <harry@kernel.org>,
 Meta kernel team <kernel-team@meta.com>,
 linux-mm@kvack.org,
 cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 kernel test robot <oliver.sang@intel.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <B3BDAA74-EE1A-46BB-B818-30A2D70C1FA6@linux.dev>
References: <20260522011908.1669332-1-shakeel.butt@linux.dev>
 <20260522011908.1669332-3-shakeel.butt@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: zhcqyb86xqqs91nw7kz6etnsudofikfd
X-Rspamd-Queue-Id: 934EC1C0004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779431299-146096
X-HE-Meta: U2FsdGVkX18S/GXgdE3V/q/cj+qvI9EDKi/0MplYIkf2b5s855g/RQXHvDImzWfed7WKL4ykZ+HCmqFebVq3M5haihb8Gw+QyfvsaVmIqW3t3coOlWrnR9lC7RC6IoqELPhJ1s9TveQtV/fwfkiEYHG+0OHbu/4fbuxOrPEp8/004dhyiytDeN9cboEQKB67mt6cbSx1WaRBaVwWp/r66nWKFdrnGSBCmup/PbUpzN9003jv7xvrH9j1vsgW+xyILnJv2oA97+DNcNwwCpCS/ALTvJwza+0ETP/+WX3tmD12vq1hpbVxPricIdQSPj8Q8jYM1AoVXETJ+afyF1oYy+1GwGVrNQTGtRaHJTPsKp/hr5fylwNf3IaSaBEdqY73PVjT7LhFqPGTxxt4Gpul3NrIqgCh3hZmcrnXNHoKoUu3SVjpqpDca+5oi5ufdhPmlAyc0VWRjw9JxvsTW/kBZ67lVbEFPHJQWtfNJv6/w+GsVPqagLHIzr8z/cr4UdoT9F6OlVTtXUziBddT2QQHcam5UvK1AcLJdwOe6BETVNcCNaBCcIOMUaz0wO0Bpxdv9oWexLIaDmDPhzug1y0qdevlDhZ6tvz4NCk3SORuMS/oQo65gHGXTDTx6j2SrbxeGLMyMlG3E1lZSPDLqAxXliXRNY0TbEZPjN8aIKcC07DppUK/PktE8QWCq7GpJwWHrE/s6zrSll0rz+gp+TEQPtN8Hx3ISukSAscrCI1PvxJWT6Xd2R0y+Kcx64o+otYinIDTq/gwaj3Sa+FLpYPdWV/XyXybjnwTxZb+s1Nj1s6A4hOLBk6oUMaoe94ZloTuxEBHO9s3nwpTBtu1xB9uhum7DXvHlJRo+ftdA/VjU3DwtrY6yAwctANbvmJKiGt2PGGHa/i0LnQ8rzwirRw5JK1swW8sLAea30AhX26GYTaWVWutikPHy0KLbC5J/S0jovhOLws8qivFajrZiZ2
 nNmHHC77
 OgFpf4GLCIiNZmK6kkrsth8576RwKKFpIBEBgncBpyHmuF2+bHbDne5qGhd3WcJFNyJs1+h8bPQ2k6+QnTNg0DaXKdMKDcKw43wXz8AKWjkHgC3CjnOtngQWcgE9ctNOaG3Se0EKtO7+T5GBfd0Jc+PszTB6QNWo+5bt6Uc+CqfSQifdIPXLNxaJO2CDXgifsJ52a6EIy3WttIFeREGNRpv+OObw65HUko2LzTPv0ZO1tLtXG8pbngWTFnq5jLHVA+FLqlLK4I0ieGV05a67PBfFhet8kt4CD8AQxzzDpzobuSc9WrhbwSud/jMaF7Ti4pSS/MqII94UwAL0Vg+IXuswKqZDeXZHoJVASFVPkt/i1y4faRIle9oZIWruZjXniJD1RAH59PdHso6ZwbEf9pylpYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On May 22, 2026, at 09:19, Shakeel Butt <shakeel.butt@linux.dev> =
wrote:
>=20
> Currently struct obj_stock_pcp stores nr_bytes in an 'unsigned int'
> which is 4 bytes on 64-bit machines. Switch the field to uint16_t to
> shrink the per-CPU cache.
>=20
> The kernel supports PAGE_SIZE_4KB, _8KB, _16KB, _32KB, _64KB and
> _256KB (see HAVE_PAGE_SIZE_* in arch/Kconfig). After the
> PAGE_SIZE-aligned flush in __refill_obj_stock(), the sub-page
> remainder fits in uint16_t up through 64KiB pages where PAGE_SIZE - 1
> =3D=3D U16_MAX, but on 256KiB pages PAGE_SIZE - 1 =3D=3D 0x3FFFF =
exceeds
> U16_MAX. The accumulator also needs to stay within uint16_t between
> page-aligned flushes on 64KiB pages where PAGE_SIZE itself is
> U16_MAX + 1.
>=20
> Accumulate the new total in an 'unsigned int' local, then:
>=20
>  1. Flush whenever the accumulator would hit U16_MAX. Together with
>     the existing allow_uncharge flush at PAGE_SIZE, this keeps the
>     uint16_t safe on PAGE_SIZE <=3D 64KiB.
>=20
>  2. On configs with PAGE_SHIFT > 16 (PAGE_SIZE_256KB on hexagon and
>     powerpc 44x), push any sub-page remainder above U16_MAX into
>     objcg->nr_charged_bytes via atomic_add before storing back, so
>     the store cannot silently truncate. The PAGE_SHIFT > 16 guard
>     folds the branch out at compile time on smaller page sizes.
>=20
> Fixes: 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg =
per-node type")
> Tested-by: kernel test robot <oliver.sang@intel.com>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


