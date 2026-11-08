Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 069ED606A326
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 00:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MIxgKo1a
Received: by kanga.kvack.org (Postfix)
	id 043A56B05CB; Sat,  7 Nov 2026 19:44:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F36BD6B05CC; Sat,  7 Nov 2026 19:44:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4CFB6B05CD; Sat,  7 Nov 2026 19:44:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B81596B05CB
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:44:24 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 503971402F8
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:24 +0000 (UTC)
X-FDA: 85410105648.26.7CE0D3F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id B200DC0008
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MIxgKo1a;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794098662;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2dNPdJpPL73VkFeXaGLHTmJbbYE7hZ1MglU2xGcUkII=;
	b=OgXLUN97/u8y2+iUrGuk4ApNmN/OfqmCrnG7EYeP8AO5ecuABzaLkeSPWh2eABr4GWzWc2
	0rpNw+TJg01JyRwACNZG31KLO9UELTRPhRM8bripnAbmTmpTrSvphYRza3IY7ftmyf22/f
	C34DxVNckwiZyMB74PVrbzvPBK6By1A=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MIxgKo1a;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794098662;
	b=8pnhjzw3HG6HFWMawYDpYm/N8HtOa+S3SfOlhsS8iIp89GsvLFXEQYpGo3Uzubpwrh3Wki
	rM2CWJMyv0//ZR24s8fptWj6wEIY/SKCOuK0D5CXJ+35KYo1jhlk3kL+HNCNLhP3X7pKI8
	lngZiHB9Urm1EIntrIF9uhrMMUrBVC8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0ED9F413E1;
	Sun,  8 Nov 2026 00:44:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBECC1F0089F;
	Sun,  8 Nov 2026 00:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794098661;
	bh=2dNPdJpPL73VkFeXaGLHTmJbbYE7hZ1MglU2xGcUkII=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MIxgKo1aFSfUEsfUUqgav/Km2q+VyJ2XmbnJPwdON1Sf6HlTlKrFqGWa4H+OO4QXE
	 Rv98OIyylzXcUi0kboCu9MukVPmds0vJTERDAGA3V3NbJI1j6wOCaDjJajoblbFYNZ
	 FzJ7KbumKvCrkdohOp1CfzPrVdFsqWG/miWHJnuFNN0YS2dWXkLK9QHEFSuIqAFpsw
	 CfC7AX0a490baUnF+HJbTuwa8+Qe+96CqfQ8bykUnleL1icX5to4pJzzRlj5wZKU2R
	 E51+F+sTVsJ0S6Pg2QuzGF7v3hNuuaS0+P8aJr8zknDISaF9gegixK7ZV9Mny1sknt
	 lPY28q8Br0Xuw==
Message-ID: <sashiko-outbox-203468@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 57/88] vfio: Dispatch guest_memfd provider
 operations via vfio_device_ops
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
In-Reply-To: <20261106-gmem-alternative-providers-v3-57-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
 <20261106-gmem-alternative-providers-v3-57-8484dde66a7e@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 00:44:20 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B200DC0008
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: hka46868a34xzieb8utf8tptkcxybcba
X-HE-Tag: 1794098662-523423
X-HE-Meta: U2FsdGVkX18n1i8Hh0iZwpVhPPWnq3ZMWXTqp4nF8fwFPZeqNnWt2qUCNk+5qdOWsRLaw33y/uHqPAi08Lgbk6cRFRQB0vy0+Y2wS7A13cIP+m2WOxwZCdKnEENyoZ5xAE1dOtBXX4L/qwpz2pn0y5pPBL8PFO1xddCxU3cTjNL+pE3OY+zWVTKp11yKvJZHjwitCbdGAZoCSk+N4s48+bW3hfumDHmyHM0BvrUz1tFgkk5d8v5y/JJI3RfH8u2uSmJ/IL6PJGuaF8SepPbXqMv9778pkjEqHFnHt0PRSWJ0Kywlo4lRgHuOFQUVMcg/OXMq4xYMPHtduYJTktI3JYejv8yhg/mbREDoE01GI09r+DwGrAhUMlQBgtlVcb0ZKbcfr59c/jn/Or/R7bsmI38ik90W4eBsuRaAvtZ+XMtErbB58iu/RyROJLkEUgkZxxDT/eIvMM6oo/13gyX3iWb/XVfkQYdIiBShuEkKgzlvknKaSk/5hMJjwTp/wweK4b/D7Vro9tJqb6kFYMATNoe1BKTYWaRF3SEc6O5iLoW6Wpi5ZGVbVHegWlYtq2gVxdnDpyk4J/qBScqfnbIy3d9arVwi0Q5aJMEK1MmkaE/wlMOj33QExgUDxeIBUvuSSrzfDogL1ZcDWpyN4wKrp0fJlADemOurgboWi+vj58wCVy3zT8LA7Ru/OC9fOdUxiJBmYsQ0xYssTmKgbQDeo+bfMURieDFb27qHqmdVudsz8dujb5UdGUiwAP9FK4+68Baz8cJqeTbkA6aBgKYAhKWW1gNldBKSjtVL2xMFAarEeCHFfAvsiu4ju1Ue8tmF8JZkkG7VlKGPfpepD2I0SFSFkruquHRBbwu4/hbdSflGJCX7F7iWNj+ALLsr8BrguzeLFibJagADXJMjnrsjb/iix6Z8M/9ODSOsgTdXezXgj8K14Y9U+HQtGqutJYIv+PvfVfMhTwfzq1IbV7j
 i0uYoT8v
 olkdRiHV0m3XnsHXCXEt3NyD/BK0GbrEp12DPlmNrg7eUn+wpzKe15sv7jt0m+KA22a1oB1AKik/78cv24OfLrPTW9XyLcnLHVjpWLGsGCaXy7SdCo037jFyWZBcMg30l+QJ8hBFu37tC12BAQgC+PN2KSj25ohFFdeDwNWMFS1uaEATuUAQmld3Tasqkc03dzJYOaLSknDxr0d8uQAYWh8eUuTCBJj0vj0GA4T/nZDxmHpHcO3K9gXeJj8tfqdAXjhuV1nGByNgnqsAmevZmKTXxOIHKKSaOmhaRpyBuf/l9r9CCRyD7lGjZ8EaRcMNcg3ZC+jdQzn4Px/T87Ys/TNUefJq47iLkwvBJmbiPtgVC1jCa7qGsB876/io/Uten7jH8Sodn2oYfHj8HuU1EbGPLxrL3yxSu9shy3UH007T3XbB6I6koTUugeliHgusKHOd5vEA9t1iNHrjhWSJMhkSJG0PFONY+uOQhnsgc1sc0QSNiGVujz+lxtlWRtSC0aJ5SR+fMUFbVsQqv2qxq6q8UZJ6GM0rxiufMhCBdPobN9kWaCPXWEmpsF3ljxMVSsGoVvZkmvBSba5qd5oBGSYCUFRiF5QMm4kcR9OAnE7933nr6/gM7ZMTWJ+c++Fl2q4AkaZfU4bJS8bV5edQQ21RL6RRcUdsrkUHq76VO2TeLgd9HfZVlz1cmFWi/UfTPTHAgBqdRG4FOGpogpcW1vIVDLg==
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
- [Low] vfio: stray forward declaration before vfio_device_ops breaks
  kernel-doc
--

commit cc851a01b26fbe73cfc6ac69613c43e8df1f4787
Author: Ackerley Tng <ackerleytng@google.com>

vfio: Dispatch guest_memfd provider operations via vfio_device_ops

This commit implements guest_memfd provider operations on vfio_device_fops
and adds gmem_attach and gmem_release callbacks to struct vfio_device_ops.

> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index c81373ddf2a9c..65dc2cb523351 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h

[ ... ]

> @@ -114,7 +117,11 @@ struct vfio_device {
>   *             this device is attached to.
>   * @device_feature: Optional, fill in the VFIO_DEVICE_FEATURE ioctl
>   */
> +struct guest_memfd_provider_operations;
> +
>  struct vfio_device_ops {
> +	int (*gmem_attach)(struct vfio_device *device);
> +	void (*gmem_release)(struct vfio_device *device);
>  	char	*name;
>  	int	(*init)(struct vfio_device *vdev);
>  	void	(*release)(struct vfio_device *vdev);

[Severity: Low]
Does placing struct guest_memfd_provider_operations between the kernel-doc
comment and struct vfio_device_ops break kernel-doc parsing for this
header?

scripts/kernel-doc stops collecting the prototype at the first top-level
semicolon after a kernel-doc comment, so it tries to parse the unused
forward declaration as the struct definition and fails with "error: Cannot
parse struct or union!".  In addition, @gmem_attach and @gmem_release are
not documented in the struct vfio_device_ops kernel-doc comment above.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106-gmem-alter=
native-providers-v3-0-8484dde66a7e@google.com?part=3D57

