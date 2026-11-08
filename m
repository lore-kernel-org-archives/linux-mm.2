Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6D03606A326
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 00:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QCkuDqb3
Received: by kanga.kvack.org (Postfix)
	id 3519E6B05CA; Sat,  7 Nov 2026 19:44:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 300FE6B05CB; Sat,  7 Nov 2026 19:44:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A2B56B05CC; Sat,  7 Nov 2026 19:44:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E51A76B05CA
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:44:22 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 85F4E140430
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:22 +0000 (UTC)
X-FDA: 85410105564.06.66B0274
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id EB43AC0004
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:20 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QCkuDqb3;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794098661;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zEqwgXBUkUu4Dpqk2uwW/tQtSdU+sYZ8iNDY55vkAus=;
	b=haC6/GR0jb9/igdAuS+ePGiVTvMdpdikupNs4K0/juFGORxe+A1h/n5b2Z2di7sljnCujY
	CesZZCuHgNZmPBz/qdib2qEYFRy3amz1RHVWpaEoEF+O1xNd51qi/KNw4TMEFBCLf8P+Sb
	cKZFddt6uoldUmKBzNEiXUfskmRKfy0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794098661;
	b=0IqS4NYWTOYuvzxH+Qzd2Q6CqOyAR5BBc5lTf+1GgDAhLwiRD4POqa+xeDex8d6KoNC/vs
	uipEoDfB2dVLbn13iymENYULmjrV7qP0XWhkowYD8lCjz9rfekAS2cOEBRd4zZybe1FJUA
	4T86AtVSJMqodEcvh78bi/fFcDF4Rc0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QCkuDqb3;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 899A7612A4;
	Sun,  8 Nov 2026 00:44:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 592DC1F008A1;
	Sun,  8 Nov 2026 00:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794098660;
	bh=zEqwgXBUkUu4Dpqk2uwW/tQtSdU+sYZ8iNDY55vkAus=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QCkuDqb3j2PdOcknM1a5laLqJTvBB0GsnOfqSVLeM8ElbY8GU3d4l+hjxxBJpMlcr
	 E9wrWaJ6ih6PcaU+0zZ8z5uzFDCRmGYOfuOnnS63ZHbDDPDRHvzu1HmVudS3q8xvbr
	 KF1P9nop0AiLgeLv9cLKJV35rAy9wIJnX6SuZ5fXEM8szUG/al/yWnhRNAtRZs205E
	 18oER2IvlSYoozrfLJtEjPWgxIEfKBxASbWUxA+I3H8hJFJKffSzDpcK1hFhQl0DgA
	 24BJtPhgCliROfn/LRDFKbXevhRq56BOM0wfM/ncSFM4umTU53AuGEGx3lDGSE3T7x
	 h2wictlrvgXwQ==
Message-ID: <sashiko-outbox-203467@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 56/88] vfio: Support
 VFIO_DEVICE_BIND_FLAG_CTRL_ONLY
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ackerley Tng" <ackerleytng@google.com>, "Alexey Kardashevskiy" <aik@amd.com>, "Aneesh
 Kumar K.V" <aneesh.kumar@kernel.org>, "Christian Brauner" <brauner@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "David Woodhouse" <dwmw2@infradead.org>, "Fred
 Griffoul" <fgriffo@amazon.co.uk>, "Jacob Pan" <jacob.pan@linux.microsoft.com>, "Jianxiong
 Gao" <jxgao@google.com>, "John Starks" <John.Starks@microsoft.com>, "Michael
 Roth" <michael.roth@amd.com>, "Paolo Bonzini" <pbonzini@redhat.com>, "Samiullah
 Khawaja" <skhawaja@google.com>, "Sean Christopherson" <seanjc@google.com>, "Suzuki
 K Poulose" <suzuki.poulose@arm.com>, "Tarun Sahu" <tarunsahu@google.com>, "Vishal
 Annapurve" <vannapurve@google.com>, "Xu Yilun" <yilun.xu@linux.intel.com>, "Fuad
 Tabba" <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20261106-gmem-alternative-providers-v3-56-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
 <20261106-gmem-alternative-providers-v3-56-8484dde66a7e@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 00:44:19 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: c9oiyt9ib1c1rg4h4iydayyi96ieiuoa
X-Rspamd-Queue-Id: EB43AC0004
X-Rspam-User: 
X-HE-Tag: 1794098660-383450
X-HE-Meta: U2FsdGVkX18Up+LLoN82tS6Aa65h7Q9ecUVCimpY5eJjakS9Kz1iIlAQE7LMZj/F4lNGG5Kdpn3cutfnW36umm8btVsQHUpzmUlSCPNF369yAZKLnLOA2lX71+YOlLY2heY0J1UYMuzW327g4V//5UHMU0rlwl7HwEkxO1ziZj67HMXz3YUBLbEnrqSYGDaUsuky48yFHzD4mAz1g4I6jWeCe9qWBvVIhqViMzycdmyzpDT2iD3Mknhh7HRYfU8x19+ssdgjtQBmw3fsfvcuP/uc9aOEhrAEbd5OL/dcRjAzkNAHfZQ19J43O+qcaXEbdA27GCyFhR42jW2IEWeqiHIu4Ddr493Hb8IZpY/Qv2Fvq5CMZfuJGj+7nFwVH30A3Xe5ghKprwWTSdy79E+/IacgrPH6B10GUcIIzxqUD0f44SIfMo+5Doh9n+FzmXc8T7dU2qK+el1IE1uEUTNLzSOCAd6AgFQzs6s6sUc0F9V14HEA250gGLaQGK0BHjAsqJLH1zd6IiDuEYYIYyvS7iOMBCQOIDeLGqrGnsClzJQXkxtY8o/hMEqpq59q2mAOM684m0hnsMvGnev0gCSLd9MYRwEs8ogco5WFIAQTu0uSOU3GNUwLbgUhen30h+KKfXp+Y+RIu5oy/0Lotl4VqcLOs+shfz5Mt6549bpppPExdLfCWJ1k1+7Zg1VGeP6DhlqTrbCLdaMUiMnVdEzRU7vzfVKl3Tm+W3lyU42OUN8QXS1n2SKsg6fj9WeYSp77qMLCAZXASrT0b32fDhopGYEwKTQEjBNz9eBsc5iMWziiu+wRWOdGSm7wyg/Pe+34zFcfWdaZPktvoQw6HmA1HyS4PE7Du/OPMeqX+oItdAnWy/udPfSgeqpU23HRfiql15DavOq9lPUo8qCkwOh+ySb4vaD2NjUKeJ7MVc0LJ9rK6azhvZhcS3cj+OKJnCxIAhz4aqpP1/nsvEgb/df
 q36NjAOi
 aOlAlTK72WNgfrST+4jTsrQ6iLsrtFAqUejk1B1L1yCZNLIt/V9wdtv0L3qMN0oSywq2tZ1tAbtuaPVRvAlxTTfslAWR3EuueIAeWzhNl1E2CJ3FkMGIP0XwZe7xpOPnoshSrO/Mbuptu3AgSXNxwXJtK7t/+5TtS5FX0//SU+NWpcv1TIotOVr1LF4gR3A0yQwGJzJVvFyzFHgfm1WZpah2VNO8fMIzcnC1FZHhdxferSnvzJlDHCxHdVkPM9ZlcG6J/8DgPHjBipRnMI7euzUupoKEo//RrZ8qy4t5JucAjAelnq9C9fDlAcspuNynbreddMTOvfjbtC5L+p/UtQfU69i5KlppFaKcPM+3E0MEt7P0IGk8X9RaE2l//bQndzFA8RtIw0GBvum+TSFrKYY0cxAbVdhreIn701qorMXo0f1Lp6xX8zXGr9Gt7dxFKZtzREBGLt1XSTZ2+NQD/uy3VdxmSRPXH6MhW6vunHKu2ALx2uczcJXUSKOBlguNnzZ8u0/bPvTuw4vQ6MRjhFmsfpskyqeF8Ny69LV0PqoEMxHksUOZtAdiSqXi4q2b873wcXZYSL/D9efzxB3988nucngWhyaF2MY2/d4Sus9S8NCBqCKc14Au8symvIhfrjqwTOywXZD9chH1+QbkOVFntjaNnrPb72YP8C8Yl3j/ze44wtgSI0gMwF6Dz+4LVldsN5cofx2tHDbLtMOo7iUf8tQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] vfio: UAPI comment for VFIO_DEVICE_BIND_FLAG_CTRL_ONLY documents
  wrong errno for BAR read/write
--

commit 25f54ac99c18d430e01125c8ec278111ab821c3f
Author: Ackerley Tng <ackerleytng@google.com>

vfio: Support VFIO_DEVICE_BIND_FLAG_CTRL_ONLY

This commit adds VFIO_DEVICE_BIND_FLAG_CTRL_ONLY to VFIO_DEVICE_BIND_IOMMUFD
to restrict bound device descriptors to control-plane ioctls and non-mappab=
le
region reads and writes.

> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index e41437fa17ad0..ea62d4e72d3bd 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -926,12 +926,19 @@ struct vfio_device_feature {
>   * be provided the same token as VFIO_DEVICE_FEATURE_PCI_VF_TOKEN provid=
ed to
>   * the PF.
>   *
> + * VFIO_DEVICE_BIND_FLAG_CTRL_ONLY restricts the bound device fd to
> + * control-plane ioctls and non-mappable region read/write access (such =
as PCI
> + * configuration space), rejecting mmap(), read/write to mmap-supported =
BARs,
> + * and all other ioctls or device features with -EOPNOTSUPP. This should=
 be used
> + * to prepare the device fd for attachment to guest_memfd.

[Severity: Low]
Does this comment document the wrong errno for rejected BAR reads and write=
s?
vfio_df_check_rw_access() rejects non-control-plane read/write accesses with
-EINVAL (as described in the commit message), whereas this comment states
that read/write to mmap-supported BARs is rejected with -EOPNOTSUPP.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106-gmem-alter=
native-providers-v3-0-8484dde66a7e@google.com?part=3D56

