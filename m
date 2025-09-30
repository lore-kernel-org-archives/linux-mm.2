Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92103CCA472
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 16:29:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C55778E000C; Tue, 30 Sep 2025 12:29:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C06478E0002; Tue, 30 Sep 2025 12:29:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B428F8E000C; Tue, 30 Sep 2025 12:29:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A24758E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 12:29:30 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 58AF0C0775
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 16:29:30 +0000 (UTC)
X-FDA: 83946452100.05.264B8B8
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6D41C40004
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 16:29:28 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=PolTssNT;
	spf=pass (imf07.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759249768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RK4X/BIb9R9NgXTb/i6Ig5G5g1HpJIT9kFV85VHeGVI=;
	b=aOQzudSNNWBLKT1mfrkG+7RJUqR3oIOHv7DP0fMLjTBzedy4DLpHl5LjYPU/9yUGnMv+wP
	wv5wyOHvxJtx6kIfl53grf2NTx2AOKq2BYnpj1maCGCMDRPdpuAWrMlvxGYyqKT5n/rusc
	ixEbL/A+hl0PwbTIeRqvnYJr+XNkNbQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=PolTssNT;
	spf=pass (imf07.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759249768; a=rsa-sha256;
	cv=none;
	b=66mTRVhwYV2zhH9SUB+wLagyjnuNXKwQlwHqL3T4sf7ID8lhgAKBjsyY88BFkmMXGeyB83
	28JuBwl6G2DkiRaExVx+Mrv/ndmewsBpHkSKHcOi79GHKkFSb7qU3dUYqLbBpddrAzo/Yv
	0JDYNQiaFGC1a410tJ9ZjxyMLN9nbOc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1759249765;
	bh=2kqE3MdFlsyIlKM4AXOI/bfovHhPnQfahB0ssoeeF0c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=PolTssNTD/USvUl+E8EPJJxihv6AllZ4tybpwcB+Lx+uOtrK9A4XzieEF2h0abKvP
	 REOKUxCTJiev/5Ke0JauBbNNM0IX0gZrcMFVmlhdz9WpEVoKmMVUn+bQaZsFjtUTKm
	 51B08R7qwVAHwh10JCkMociGcrekAsNWjxGQO+R+uUV2DcBYDqdvOBuo2mUr2f5p0i
	 zbkpKQcGRGJ3eZN+Fho0rg6JtT1t0yPC5V0AhKZuSU/+qaXjcO9z8+/aJVVf6W5TGE
	 gLLFBVYnVOOA43QHW8I+COItf8bHKz6NWF5MiSUqcU9gmwtf+QMeCNMJVFN1q3pAG6
	 Hz1v/kBYgvPSA==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id B0BA117E010B;
	Tue, 30 Sep 2025 18:29:24 +0200 (CEST)
Date: Tue, 30 Sep 2025 18:29:20 +0200
From: Boris Brezillon <boris.brezillon@collabora.com>
To: =?UTF-8?B?TG/Dr2M=?= Molinari <loic.molinari@collabora.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard
 <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, David Airlie
 <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Jani Nikula
 <jani.nikula@linux.intel.com>, Joonas Lahtinen
 <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Tvrtko Ursulin <tursulin@ursulin.net>, Rob Herring <robh@kernel.org>,
 Steven Price <steven.price@arm.com>, Liviu Dudau <liviu.dudau@arm.com>,
 Melissa Wen <mwen@igalia.com>, =?UTF-8?B?TWHDrXJh?= Canal
 <mcanal@igalia.com>, Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>,
 Al Viro <viro@zeniv.linux.org.uk>, =?UTF-8?B?TWlrb8WCYWo=?= Wasiak
 <mikolaj.wasiak@intel.com>, Christian Brauner <brauner@kernel.org>, Nitin
 Gote <nitin.r.gote@intel.com>, Andi Shyti <andi.shyti@linux.intel.com>,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 intel-gfx@lists.freedesktop.org, linux-mm@kvack.org, kernel@collabora.com
Subject: Re: [PATCH 2/8] drm/gem: Introduce drm_gem_get_unmapped_area() fop
Message-ID: <20250930182920.5604ca49@fedora>
In-Reply-To: <cd9084e1-16d9-4fd6-9c64-1876d53d5225@collabora.com>
References: <20250929200316.18417-1-loic.molinari@collabora.com>
	<20250929200316.18417-3-loic.molinari@collabora.com>
	<20250930123003.75370854@fedora>
	<cd9084e1-16d9-4fd6-9c64-1876d53d5225@collabora.com>
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6D41C40004
X-Stat-Signature: 6u44q3cxpxjxxap4jaxiamw7wzsytaor
X-HE-Tag: 1759249768-951671
X-HE-Meta: U2FsdGVkX1/iX14h7tBsWunw4kQtAi0VBdUTq7rd32XqghXsJnTXG+dUFGQg3MtY/ikCAof2t0/g52MLvpZw7H3ZmIgfPZ67weks8XMRzDSyP9JYn1RUBCa8ITnwUwHxSDIs1e0RP2rYSBp2HwfN5zrqWD5Vg2kzti3fkZT/uXL1JGid4XCy3/lxBbJYfEPzgi/7YzhAlZd1DW5Q+JoLPq5T+/UDy7mCTGdosodiImHytVNTVIBa1hOOeJQkGfGqdRYDpuwYN3VST8sKR7LTy21b9ulJAX1LI7Btb+08FsbZuuZ1dOVGNZOdp/h6Dr/mRBur3lYis04rV5XU8Fpv3SculQ4YuV63WMm8SDxV84jmcts2FvSMo2oJk+CilDZuEd4vePvo12dM0PUp/4EZMkltcsvBqzFmm1JftRkfPDIqKHDEbt/gNYKOzlIwWc4QbUqjjzPRG1E07QuVbX9niQ3Ov+4b86V9eEu3cSJ0xEd0N+FbIEu8cHxJ8Ez31bDqMV+ODN0RM3pUao2HAhx9FgP4W8hnAP88QS1FFT6wrKPUXT/7R9h4WGTTYE8bIDR21WtW8qeahAwUas+dMMQytqeE5keRh25MEA6EUmZZAC9PdhPIHg6E9qF9u4WIS8EOWOhf4mOEcwmMIasjMO2qpM3PiqgUZh3ENnydRakkgv6lrsLrMvtxIJ8I7tOiGYYC2nq6gzaooRRbM0UtcY6uDeuIWWQicpZNZjeJ4ZKWieCJviam6i3f/g2Vwg3NWqXOK4rUnn0nmsFo0cPxsjrVyUbViOvTIHZlK+d0j8r0aFRKpqumX6pHLMtuBufHWapS1Uz0e6sHve8QE905RwsThXkeITa5UhakoQTiBv0ldA/OdHeHjQ6QR3NIvZzFY7SGCoSwWOOsY2nXixH7OK0PmjpeIgQNUpH1jQx+8sQ/UJCTldSVBMRnWHkHP8y+XIwqi1qKlySNC1PHIrvcU4P
 n4v+NQBn
 g8IkD5/gkabNGajsWkLphRVmc24qaTuTNFBQHPAznqrDRmQGayStjTaKAnSpHst3SiQd1LHhz+gQjFvZxV6S+xo/qOaBf/rqrUL5hnCpnGzd4J3t71YZso7ewd07XkkLHhwjsxbQQszAA6BTpgXbvMbF3VZPK3g/j37pvxH1e0HCBGq7bL0jbtwmNv6x0NQmfQCjjfjLX/cZw3DTmFob85qMh1PJtE/msfyurL48wx1d49V4K3zBcmGEC6QW9yrO93GQ+mbUrb1pGdhfJU3g718IyJGRnR06PR0aG49oa7gSu++mAhWtuSL9VTeAPI46S2/q4Iy3P4nqia3yv2Jys6CwNlucBudQllXsL06Bf9VCeCyayGKJhXKP6ioins1LcuWpipGqjvLRXU0r0toLq1YmJ8w7Rvlv4RfjW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 30 Sep 2025 18:09:37 +0200
Lo=C3=AFc Molinari <loic.molinari@collabora.com> wrote:

> On 30/09/2025 12:30, Boris Brezillon wrote:
> > On Mon, 29 Sep 2025 22:03:10 +0200
> >
> > Lo=C3=AFc Molinari <loic.molinari@collabora.com> wrote: =20
> >> +unsigned long drm_gem_get_unmapped_area(struct file *filp, unsigned l=
ong uaddr,
> >> +					unsigned long len, unsigned long pgoff,
> >> +					unsigned long flags)
> >> +{
> >> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> >> +	struct drm_gem_object *obj;
> >> +	unsigned long ret;
> >> +
> >> +	obj =3D drm_gem_object_lookup_from_offset(filp, pgoff, len >> PAGE_S=
HIFT);
> >> +	if (IS_ERR(obj))
> >> +		return mm_get_unmapped_area(current->mm, filp, uaddr, len, 0,
> >> +					    flags);
> >> +
> >> +	ret =3D shmem_get_unmapped_area(obj->filp, uaddr, len, 0, flags);
> >> +
> >> +	drm_gem_object_put(obj);
> >> +
> >> +	return ret;
> >> +#else
> >> +	return mm_get_unmapped_area(current->mm, filp, uaddr, len, 0, flags)=
; =20
> >=20
> > Looks like the above code covers the non-THP case too, do we really need
> > to specialize for !CONFIG_TRANSPARENT_HUGEPAGE here? =20
>=20
> It does cover the !CONFIG_TRANSPARENT_HUGEPAGE case=20
> (shmem_get_unmapped_area() would just call and return the=20
> mm_get_unmapped_area() address) but the idea here is to avoid the GEM=20
> object lookup cost by calling mm_get_unmapped_area() directly.

I'd expect the extra GEM lookup to be negligible compared to the overall
mmap() operation to be honest, but I guess if we really want to avoid
the overhead, we could still write it without this ifdef.

	if (!IS_ENABLED(TRANSPARENT_HUGEPAGE))
		return mm_get_unmapped_area(current->mm, filp, uaddr,
					    len, 0, flags);

	...

My main concern is that shmem_get_unmapped_area() evolves with more
!TRANSPARENT_HUGEPAGE cases, and by calling mm_get_unmapped_area()
directly, we miss the opportunity to get optimizations for these cases,
just like we missed them by not forwarding the ->get_unmapped_area()
requests to the shmem layer so far.

>=20
> >> +#endif
> >> +}
> >> +EXPORT_SYMBOL(drm_gem_get_unmapped_area); =20
>=20
> Lo=C3=AFc


