Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0B70C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:28:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 780D96B00B4; Mon,  3 Aug 2026 09:28:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7585B6B00B9; Mon,  3 Aug 2026 09:28:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66DDD6B00BA; Mon,  3 Aug 2026 09:28:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 403736B00B4
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:28:00 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 224D91A0655
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:39:48 +0000 (UTC)
X-FDA: 85059310056.24.0B50584
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf29.hostedemail.com (Postfix) with ESMTP id 43D6A12000C
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:39:46 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wdsCv7xa;
	spf=pass (imf29.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785746386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wxNx4GDWUihrljy6qO1iXM0vV/PzaZT1gUMrOo4agVk=;
	b=Klxpd5AbG911BSj/vWBPaaR6nkSOonfElfsftEJrfEWmzG3mjUrrxNSObMYjOauPi1PqsN
	+T1UJpZUEASroYaQMRwPUPgN7vEhrTO0av7fHfA50SlGDjI3OmOfM9jq93/AmubJxgEc/A
	E8+f91eIsBrWaOtS1f+8puPppS+7+DQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785746386;
	b=UwMR1R3oN80zHPUr6frhZpl13y6i2NA+/DheXgQyyjTwjcLYfkbVVJOCBD0wJMjzcuBEcY
	Fd1cCxHzPn82F8Ms983i5y6VuxcxYfkxsMuzg1v+rhWjVEa+Z8zFhO0SX09UKNRGHLbICu
	4GgZ75OGSd5OBYkoiu4e1CtVDCYnZtw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wdsCv7xa;
	spf=pass (imf29.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785746383;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wxNx4GDWUihrljy6qO1iXM0vV/PzaZT1gUMrOo4agVk=;
	b=wdsCv7xanZYH2lLaZyI3Sc9uLB26pn1JOIYwZ9hS4f3Niq4qYKa3hmPkDDPHMv9+KoyP+Y
	1uDDNrgwUZtRohVsWHI7XXn084qZG9U++C08ZGVFIM4PqRpGXoUfSixe5S5F3oTiX181l+
	AOf2bd5jSvafihaz7v81tiQb2XvwfhY=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v9 4/8] mm: add a template-based fast path for zone-device
 page init
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260803070929.86075-5-lizhe.67@bytedance.com>
Date: Mon, 3 Aug 2026 16:39:22 +0800
Cc: akpm@linux-foundation.org,
 apopple@nvidia.com,
 arnd@arndb.de,
 balbirs@nvidia.com,
 bp@alien8.de,
 dave.hansen@linux.intel.com,
 david@kernel.org,
 kees@kernel.org,
 mingo@redhat.com,
 rppt@kernel.org,
 tglx@kernel.org,
 linux-arch@vger.kernel.org,
 linux-hardening@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 x86@kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <CB22DBB6-0B52-46C2-9A19-4A18A6F6DEC1@linux.dev>
References: <20260803070929.86075-1-lizhe.67@bytedance.com>
 <20260803070929.86075-5-lizhe.67@bytedance.com>
To: Li Zhe <lizhe.67@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 43D6A12000C
X-Stat-Signature: xpfhjrdzubn7xmbt479fuhs6ta35tttm
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785746386-735606
X-HE-Meta: U2FsdGVkX18+QAS0tzQHL+vZG7oG64/Sz9i4zkU25+8MlgwDwJh72LfoEQq2EZ9uTZ+3G3A8n0zuGAjN7OFncguD7ZrG5YtCeMwTi3UuPNZNE/XzDkMx64/2RzxGGZAWhHdKHT6P8v/AKvHHaPw3FLC2ze95dUhyVMavgLnzAYPWLpvgV/PKcg5GsE+MN+nE/u2fCYb/51gnvPxdezlf5ah1iRJcnyFLtWA+jrBHc76CZVgHPtNfw/FGdS8G1R4L7i8iz5AkleyilgtqqQAiQbG3e32dgFYomqsqp+Su0oOQnQeebO0U/YxbJHmMz26YBitjclc3KHW8YHsKdG7OJkj8S5YA4FzT0iMTqNIDTQarIcbnVTBj6ARvX1VXvGU1TfMGo116ID91bHLqFzO8FSVIEJgGiSvRIFnOQmkJor109uX6yXHGlvPKYuXvEL3H2bhkbEZMDSPzM6q+9KGCMz2W7ow33P6TXPhbdyYwNFkVG+Py7ZpKWeVhtfXAw3L2e7msiwdLm+i67C9Yiydrf8Cwp1u2yfLS+nHp+ttLHiOv2CbIn2Z0+BjtnIYRTC6aKJ4O3ssjmnNVZYHweisFFByN0An4BU6mPyLjKIbdN7QvaVszgMkDZZR6nE95HSPge+/B9AjGjGPE3CdZnBWgueZdxIdoDRjPqnB4CQ48D96Su8iZwgqg7pfFZpl4sb6eIgsDlSAUiFv3pPYtoyyjdwpFqpGveW/PFNeXLtYg5IHR6t2AoTkQBjc+Kv15pSlD2wk5NE4VLtimhfs0MW0JHn1ghng1tjgrKqMyHGtZr/Ky61Te6Bp6vcgfoeWZYGfr/30RmmHOUCHtLxpiTLz/YQ9d2t7P8c8uRPbZgUpECC/ze+jylzt22DllR2jxCso5BgnrLIIVwQ8nVySl5TCDOeXD70pKOqYxfSjjx9brHjAGrMqveNqWQkUmzb7PLGdz0IgUvluYRlGUzanLciy
 PApkfcUW
 qncSPCKv0OEvgau4DuBgNZSohLzrd2AL9G0uAQ2yBcxTbRDmZOB0E7NvIslmepNw7iAexzHW4PNwWahs6krM/hhkxyzn5e2cpRM0avsz3LtFjnVKCyKWPPnLtgk7vrjqYf8NjDhGz0WBmfr4K8b5ph778Ww4VWkyNRSskUFNhIg0GmojaQsTdnro4h5sl5Ww8s/fejLFKPrLGvkgUMHHTTrjPMLln23dPjMPRgr+GGcSd2OaUPzo9CsFKpFj9Am01GpyY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Aug 3, 2026, at 15:09, Li Zhe <lizhe.67@bytedance.com> wrote:
>=20
> memmap_init_zone_device() repeats nearly identical head-page
> initialization for each PFN. Prepare one reusable ZONE_DEVICE =
head-page
> template through the existing slow path, refresh the PFN-dependent
> fields in that template before each copy, and memcpy it into each
> destination page.
>=20
> Use the template path unconditionally, as suggested by Muchun. The
> page_ref_set tracepoint is primarily a debugging aid, while this code =
is
> still initializing struct pages before they are handed out. =46rom the
> perspective of users of those pages, the initialization-time refcount
> transitions are not part of the observable page lifetime.
>=20
> This means page_ref_set will no longer observe every =
initialization-time
> refcount assignment for copied ZONE_DEVICE head pages. The impact is
> controlled because the final initialized struct page state is =
unchanged,
> and keeping a separate non-template path only for this local =
tracepoint
> observability would add complexity to the common path.
>=20
> This patch accelerates head-page initialization. The pfns_per_compound
> =3D=3D 1 case gets the full benefit here, compound tails are handled =
in the
> next patch.
>=20
> Tested in a VM with a 100 GB fsdax namespace device configured with
> map=3Ddev on Intel Ice Lake server. This test exercises the nd_pmem =
rebind
> path (pfns_per_compound =3D=3D 1).
>=20
> Test procedure:
> Rebind the nd_pmem driver 30 times and collect the memmap =
initialization
> time from the pr_debug() output of memmap_init_zone_device().
>=20
> Base(v7.2-rc1):
>  Average of rebinds for nd_pmem driver: 244.28 ms
>=20
> With this patch and its prerequisites applied:
>  Average of rebinds for nd_pmem driver: 215.55 ms
>=20
> This reduces the average memmap initialization time measured during =
rebind
> from 244.28 ms to 215.55 ms, or about 11%.
>=20
> Suggested-by: Muchun Song <muchun.song@linux.dev>

I personally feel you might have used the wrong trailer here, because it
implies that the overall design is based on someone's suggestion. But =
for me,
I think what you actually meant is that in a previous version, I made a
suggestion about simplifying the code, rather than dictating the overall
direction of this entire patch series. So I feel I shouldn't be credited =
here.
This information is already enough just appearing in the change log.

Muchun,
Thanks.



