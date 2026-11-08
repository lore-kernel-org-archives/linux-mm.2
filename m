Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E906F606A326
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 00:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ROnDo2up
Received: by kanga.kvack.org (Postfix)
	id 1A37D6B05D4; Sat,  7 Nov 2026 19:44:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 154836B05D5; Sat,  7 Nov 2026 19:44:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0918D6B05D6; Sat,  7 Nov 2026 19:44:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C26366B05D4
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:44:35 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 577EBA7DAE
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:35 +0000 (UTC)
X-FDA: 85410106110.11.78CD5E0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id B5606140003
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:33 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ROnDo2up;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794098673;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FYDflmfipi1PjLcDGCMu62uuoKoinLSLqz7eYoqq+KQ=;
	b=iOU/xsa4ZG0g1pZzjHQ/MOUQnlWKfL+VF+L+S50rWzRVplnu77ttUCRvSCUUjzrjUU2ZAG
	NKyncbYG7EOtdiANxEjqchwVPIhKNg6Y7jrOpQBCfwIQj/DJ9/f5uI8qW2WetXtOO9kQ+g
	szYat6K0CA1LlvOonet+Xv2qCCDReK0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ROnDo2up;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794098673;
	b=k8RiqBqLsIqP75TbzUAgMkl+HCMxdIr7npIVMR80/zdYG0iNJFAYBTgz6lms+SXkfzSnqw
	NnIphxwLszsh5/intqipfHVJR2GcBVTPwMnnrIhlRua2IL7VkGaJEdZ722Fcwx2t5kqXFb
	HJBU+jx7lIRiSW7W2lTPxjfrhh4z7WY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F298341636;
	Sun,  8 Nov 2026 00:44:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01D031F008A3;
	Sun,  8 Nov 2026 00:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794098672;
	bh=FYDflmfipi1PjLcDGCMu62uuoKoinLSLqz7eYoqq+KQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ROnDo2upa0yparepTbW0CMUrMFlVNDpAMXV4nnDDtZ5aSls0t0S4WbIrCopMEAQO3
	 n4fcDVYvu2tYz31BvFH+Pz4lod5myGGr7GK1i2n2x6K5gvdN1GdaMDNmdoHGYx54aZ
	 zpQ9R7gxyOMgEDpM5WYJXtsNDaPpiybZlN6pBC3Y+oen6u3Y93MhJL572CUBiW45i/
	 SXfG4FPspabqXUCX655V3wv26QpLh2mY9o8eL313drTpnQH45ONM6zLHTjd7lO+pWV
	 cnYZM5cnTje5SOd4Y+4YfjGLg6Yu6vM/alHVAgfKsfg13Tq9OpIh9CbTtMTUabOXid
	 mdYE8LF6yNG+w==
Message-ID: <sashiko-outbox-203479@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 68/88] vfio/pci: Use iov_iter for MMIO read and
 write
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
In-Reply-To: <20261106-gmem-alternative-providers-v3-68-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
 <20261106-gmem-alternative-providers-v3-68-8484dde66a7e@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 00:44:31 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B5606140003
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 9trmjinwc99ifukfr9e3d9qd9xseqj13
X-HE-Tag: 1794098673-273685
X-HE-Meta: U2FsdGVkX1899LyHU7+vjgxboovsKqXRAVn1yCOQH8S+wddYrQPlhcxCa+y22eynWfKpw36Av56D6oPE7HPqi9sqHJpJMUgnOkfiz+BxI1ZozB9UJu06vZNigYQrDUoAXVNBlSBfepbnwFZ8IKpTZ/AjYLLW/4tB4nmHDZqHcTErH8Xl3TKTWAA9Y3KMHPUith37SZrImB9hiSsvWWSqEyFvXB519YvGFFg5kVS9Xskf38NWNxMDQxqqW7olWo6VGOJLzQOSt8NxHfF9A4a1SqzjJuj0aXa8iY6cmISNHE4xJoWae/fCyfUF2e5pfpBtkUMSQX1mEnqu23Q3FXApewlhK1v3ZVLKpmfo3Ga7kzBRRqHAIY5d1SF6vm/8EXgtiAvIkdH1dUd0jmiewlPMusw7QwIJw3SzlpEZEbv/agCqE4opWqHo1VRDcjpM2XJUTA9JPnT27Z3Z6ya08B/Az+oIFx7nakRX2CMEcxmZyFzbiPh2mxpOf/mOwX4N2HgMwmq/soKE1/TVb19lOsS6GO137mChrbeMSzJq1pbaoEBZp+P2K8S824kdpJ1LhNPRtQXak7i5nrLGwMvUsHCTULtG3iHpJhEEAwgUW2CnBTot+CSFjuupylwHBiYrQ8NTaNjFNP/hnknkBhulGRdwMw9wZXHmukXbV/v26yU+IyC9drzlCwGRdAxCBRVaywdKRmXpri8T9ZZcCXfM/LxMiYYG6pKgr+w8gE5ydk/b7OY3HJKhwh0SHi29GDbRVE9ajwrPePa2VZ06EOJ1VoF2NBu5psOoRtBXWS5+Rtq2Q2at1I1xYVb/BRU92blmZPQ10uRwdhKzHifO9P6xclM8WySpUddKmLu0etArhpTHl2Rfior7YSj+kjQBJk8X4fkCIazRDJp9Nbjm9hoCwKeFXlHGJEYPYfkvKXJAFCnnjc/8lhcd6zUeN4HridbYAVUG/2+EiT+ktx8S08t03yv
 NBLQf2+v
 fG6ApRygn2YRkjguoeb8mwUvUa0CDprgE0kXGBJwZ0xmMhO0YJs+6WnCKue8owz744KYsloo+UUugxWyRXKj7Pgf4xUjWTA6PS68gnvgW76lOyVrdZZwa6GECd8Mnxrk2aXPrz8rwPSJS/Z8oZaVm0Fq/Jut8LziLApf2FR684kG3jDPrjkTALw71REmM18HXWxgXt14GGsgzT+LXDbhfZ4WNdOve9PI8azOxomoHdqJSzC/lErtysDl5/eEYeSRRHdbdexZZY6vRjm80o8mbsJwm0tz5AunQBXO5QyfhzISzaS91bkeEBLjpOV8fMdUkU2st62pzVUOnGLg7E2iqSzS0Cjyk9gzKphZI5RfZuj68TozJh0g4R6WrkHYqlceh4wub5MwkCRDscxJ3U88MMSmTTPgCPNNbRbhdhnkUBGPtOIe2Yzb/4ZTsMfp0ux5Er18T9G3iguMzVMqK6D5/ylx+y5yPuisKfAfwCPibJZsYeWYkSZd1jFStzAgatBJAWJs0iMcrT6JLDKPl1xsKUVVOtr1RkiLZT/H+Bky7bN+9VVqVjl+sH7wbpjMlE7t92zMdiGi8KWisNu1w+V7bzM3bPNV/M+tRhQx9ZJ8pQiOdKuyJ0L4/Rb80jG+qC575BfTPYMA2ALT08mOmyjWEvdinVj0pJEltUbGPqiR3hH6r3y9qa3A48FsdKsC92OwRkw+ULZdffzJNms6zSgegNvpOuQ==
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
- [High] vfio/pci: missing linux/uio.h include in vfio_pci_rdwr.c breaks
  build
--

commit 857abb2cc1a3ab7c6f488750b101680f17be6f5d
Author: Ackerley Tng <ackerleytng@google.com>

vfio/pci: Use iov_iter for MMIO read and write

This commit refactors the internal MMIO read and write helpers in
vfio_pci_rdwr.c to operate on struct iov_iter, while keeping
vfio_pci_core_do_io_rw() unchanged by wrapping user buffers with
import_ubuf().

> diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci=
_rdwr.c
> index e5f1f60513709..cc64722d1ab9a 100644
> --- a/drivers/vfio/pci/vfio_pci_rdwr.c
> +++ b/drivers/vfio/pci/vfio_pci_rdwr.c
> @@ -91,34 +91,34 @@ VFIO_IOREAD(32)
>  VFIO_IOREAD(64)
> =20
>  #define VFIO_IORDWR(size)						\
> -static int vfio_pci_iordwr##size(struct vfio_pci_core_device *vdev,\
> -				bool iswrite, bool test_mem,		\
> -				void __iomem *io, char __user *buf,	\
> -				loff_t off, size_t *filled)		\
> -{									\
> -	u##size val;							\
> -	int ret;							\
> -									\
> -	if (iswrite) {							\
> -		if (copy_from_user(&val, buf, sizeof(val)))		\
> -			return -EFAULT;					\
> -									\
> -		ret =3D vfio_pci_core_iowrite##size(vdev, test_mem,	\
> -						  val, io + off);	\
> -		if (ret)						\
> -			return ret;					\
> -	} else {							\
> -		ret =3D vfio_pci_core_ioread##size(vdev, test_mem,	\
> -						 &val, io + off);	\
> -		if (ret)						\
> -			return ret;					\
> -									\
> -		if (copy_to_user(buf, &val, sizeof(val)))		\
> -			return -EFAULT;					\
> -	}								\
> -									\
> -	*filled =3D sizeof(val);						\
> -	return 0;							\
> +static int vfio_pci_iordwr##size(struct vfio_pci_core_device *vdev,		\
> +				bool iswrite, bool test_mem,			\
> +				void __iomem *io, struct iov_iter *iter,	\
> +				loff_t off, size_t *filled)			\
> +{										\
> +	u##size val;								\
> +	int ret;								\
> +										\
> +	if (iswrite) {								\
> +		if (!copy_from_iter_full(&val, sizeof(val), iter))		\
> +			return -EFAULT;						\
> +										\
> +		ret =3D vfio_pci_core_iowrite##size(vdev, test_mem,		\
> +						  val, io + off);		\
> +		if (ret)							\
> +			return ret;						\
> +	} else {								\
> +		ret =3D vfio_pci_core_ioread##size(vdev, test_mem,		\
> +						 &val, io + off);		\
> +		if (ret)							\
> +			return ret;						\
> +										\
> +		if (!copy_to_iter_full(&val, sizeof(val), iter))		\
> +			return -EFAULT;						\
> +	}									\
> +										\
> +	*filled =3D sizeof(val);							\
> +	return 0;								\
>  }									\

[ ... ]

> +ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool t=
est_mem,
> +			       void __iomem *io, char __user *buf,
> +			       loff_t off, size_t count, size_t x_start,
> +			       size_t x_end, bool iswrite,
> +			       enum vfio_pci_io_width max_width)
> +{
> +	struct iov_iter iter;
> +	int ret;
> +
> +	ret =3D import_ubuf(iswrite ? ITER_SOURCE : ITER_DEST, buf, count, &ite=
r);
> +	if (ret)
> +		return ret;
> +
> +	return __vfio_pci_core_do_io_rw(vdev, test_mem, io, &iter, off, count,
> +					x_start, x_end, iswrite, max_width);
> +}

[Severity: High]
Does drivers/vfio/pci/vfio_pci_rdwr.c need to include <linux/uio.h>?

struct iov_iter, ITER_SOURCE, ITER_DEST, import_ubuf(), iov_iter_advance(),
copy_from_iter_full(), and copy_to_iter_full() are defined in linux/uio.h,
while linux/fs.h only forward-declares struct iov_iter. On x86_64 with
CONFIG_IA32_EMULATION=3Dy, linux/uio.h happens to be pulled in transitively
via asm/ia32.h -> linux/compat.h, but builds on architectures such as arm64
(or x86_64 with CONFIG_IA32_EMULATION=3Dn) fail with an incomplete type for
struct iov_iter and implicit function declarations.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106-gmem-alter=
native-providers-v3-0-8484dde66a7e@google.com?part=3D68

