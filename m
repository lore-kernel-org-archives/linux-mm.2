Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C0AE606A326
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 00:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O9x7Xwzv
Received: by kanga.kvack.org (Postfix)
	id 48CFE6B05CC; Sat,  7 Nov 2026 19:44:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 413CA6B05CD; Sat,  7 Nov 2026 19:44:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3296F6B05CE; Sat,  7 Nov 2026 19:44:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0A82D6B05CC
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:44:26 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9668B12025A
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:25 +0000 (UTC)
X-FDA: 85410105690.13.6E7EBE7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 11087100004
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O9x7Xwzv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794098664;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GLAng9GU2q0DAhSwRoFsK3zaIaNi2hoXo+hI//Uk/Xk=;
	b=lesCahoj0xIdjyDiUCpSfr4pSUvx8WEfkxRN6kJ2Hdbf+KdFmq+VXXlnvVvKaxYclF98OF
	OzfBwrCHSrgYDrkbG/kBW0IKREc/W0tGXUWy1LZFgwcKLe4OwByDFd7Cf2uGRkMzduKorQ
	dOsq80bvlyunUAod0K3fvFM/IU8rWg4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794098664;
	b=25iwDZfxjhW8MPRJ3hMRoVgHtDnxGZj1L/uyh6FUG886mPtFyn2tYtF4/e16qFmzEuscwj
	TPr8LAulqNTZzpNUiNE/HtTZeZCzr1BEI8mag2D3tEKSyTjqncvA+RbhSKgWiwbBL+r+rB
	RztZWvqF7L4VJ5yliU5Hcx4S3ZzMNw0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O9x7Xwzv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A457C60EF8;
	Sun,  8 Nov 2026 00:44:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66E781F008A2;
	Sun,  8 Nov 2026 00:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794098663;
	bh=GLAng9GU2q0DAhSwRoFsK3zaIaNi2hoXo+hI//Uk/Xk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=O9x7XwzvfE2FoAjufaWcAvibpkwt7zCH58rv+Vcmng/QxPVswQEfBl88BOWIqgu/z
	 NYTiAzrAfdtp/Rik5JdlTmukxN7C9mODZgg7jQy63kFJxDlaDr7JnYyV7jUiUim7XY
	 c9664m3PonLJXfYt71GzM4WbS95fTA77mqpY3bDDnmsbXVmWrFuVcorsWMb8UbtMgO
	 K5slUbND+WUR5A7xNlGCSM2e2kmgA7AxJqXm/O77wJpXUA2uuq4t98ouYHhBNGnXde
	 evCMysJz/YCd1+sm7KyFY1CRcRzv6ECBBniI5j8dI1U9bWMPWYT+AVzg07e0vkXztf
	 1PNHmVOJLTv9w==
Message-ID: <sashiko-outbox-203470@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 59/88] vfio: Dispatch guest_memfd get_pfn
 provider op via vfio_device_ops
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
In-Reply-To: <20261106-gmem-alternative-providers-v3-59-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
 <20261106-gmem-alternative-providers-v3-59-8484dde66a7e@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 00:44:22 +0000
X-Stat-Signature: mfksxrbau9snmxqi68sh963bx1x5pycm
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 11087100004
X-HE-Tag: 1794098663-928431
X-HE-Meta: U2FsdGVkX19FEMMfZTrOJN6HmmrLKwt2WkJFFt0KSDmu5SHVWl9QRR7Vk0YDh5ChSXz4kbCOQHU9ScOaW69snUQ+dib77TyhBB3Qatn9dZEA236CmiBivZ40TE4vQypPzzeuNsd8wFQDGsXyhG9EAxMB/veFJMVf0ZfpCV3XC+k0DLEVxITAs8sly8P1orhZ5wkfcvD8L4VKaNxvGhqr1ZbXJvD9nIUUqnmDzU4Z/+b7shRpXaR/xYIqqOGcw1cX7b/nz6cWn68DNJZ08U78vl0nVYpbDScST5hLnqyARRBPgM1Te+64nxtAnct7vTZbUXC+7iNisDD4j5vEDwH4s01nC1tjv6LGsZjxF0J9Xz7mkk02bknbfsDPP3I5C16Ka3wiX1XGkZ3nVsSI15EqW600VuHSUaBKaI/U82a4j8BQP+cq3NECEGrAVZVP7QZB9BTN6j1rxRD5UpGxd12OaLQTNT3QHoCItqBk00p/Z0ZjYG6vmghfMytzh98XUru3+GOhcbi5L2y2INXqJDHLdhMzc+sRWoWBxS+U2W+fyzoYK5badq9XbluCZott8OxRTFBs+7oaX2G3MAF0Ie+MxewefsBmXxuXN7vV3NnqGinjb972F0iW8PBa4n/fJV4Q/tZtKZL/HaCrlesFNxEK9NFDPAl32TSmo0A/EXWbMPZ+ARLhrvApdAwhySSVhWiWspgqCYz3O7DZbrbGqiWxstd9wn/uNz+SKdyMcgoMCf/2mZAigl/hjGiiRc7z+xmd1eSRotg8bF9q/y1YWnWXHpZJemzVtNvmXXd3NU5ojgmo4YRv0UL6lqtxOvw4H9kUGsnMZX8VfP94PYmPvUdXO5r+77lu3FB6SHUDP/myNVOIej5bjondwrSUcVDftVLF7txQt/SBZzMtyndL890g5hGyik1t1xs1eYipmAxBVHCI1bzxV6+P3TOE/nc1xyhKZe4N+ohWXRWULdJIM+0
 ThDteU5o
 G8Kbu9SdAsjLh4Xf/kllR6uEL9vkzytNqz91JWDeEus19VS80j9AkuMmFLb3qeJ08HVJFDtXS+PJZZF+JYp/8ONMty3EIHCT1EUWqArpoFipEp8cXt88ECUFUazuRVjyevBwRj5dTXgc5415H4D45kMqyrSGirftBCVDZ0PsXDNUnIxJgc0F9hQ5w21GOjjEUXja4APwKWOff5E2VuKFZe3R57yoSc4M8XPzfydnG1WO2PZtZ9IlUctJgcZtd2mfPShwGISdQPMDK6BRsc0UDT2HGfgaqfxYK3hIQGxgeq/ZBgb83Ru5ZYpjoXuqrOTLyc0GdYBoEYmb46IIgyRXXfQzmV+gd7VcNAG/z1yUOAfTaTQjaMeTVZ1NCzrywVXMmjecC8K+KGQnqYfUrWoa8Y2sNP6q2R5fx7cJrc8yhK/Q+gx0pW1AHLA9f/J82JUJX9cvra6xpx1h8HWzz2dqMDTT1io4COx1CF/6U6VYUa0PtLMyMYWFYtDvKIpty4ZK7S7eDdD5NYMsBrlVGxdco/9lUQft7KMrxksGDvCvA9kzN1Ro7UGR6rWuy8w0/d8rnRl13kHtNH99abmY78BTcl05io1MrfWdOoJPmtpUcnK+/7Mrh5B8yzgle/YVrvZFpeS5xA4zhAO07aJxQd6YsYQ4kufVqAks6i0Es/20Lqu/Rjv3+DYst0T900GAQk6Jzx7cOF5bVOrRMnnJ7QW9oG46C/A==
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
- [Low] vfio: missing kernel-doc entry for gmem_get_pfn in struct
  vfio_device_ops
--

commit aa1fa472e3013956533385442614d3f6291a86c8
Author: Ackerley Tng <ackerleytng@google.com>

vfio: Dispatch guest_memfd get_pfn provider op via vfio_device_ops

This commit adds a gmem_get_pfn callback to struct vfio_device_ops and
wires up vfio_device_gmem_provider_ops.get_pfn to dispatch to it.

> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 65dc2cb523351..51e04b980a381 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -122,6 +122,9 @@ struct guest_memfd_provider_operations;
>  struct vfio_device_ops {
>  	int (*gmem_attach)(struct vfio_device *device);
>  	void (*gmem_release)(struct vfio_device *device);
> +	int (*gmem_get_pfn)(struct vfio_device *device, pgoff_t index,
> +			    unsigned long *pfn, int *max_order,
> +			    u64 *pfn_attrs);
>  	char	*name;
>  	int	(*init)(struct vfio_device *vdev);
>  	void	(*release)(struct vfio_device *vdev);

[Severity: Low]
struct vfio_device_ops has a kernel-doc comment block right above it, but
@gmem_get_pfn (along with @gmem_attach and @gmem_release from commit "vfio:
Dispatch guest_memfd provider operations via vfio_device_ops") is not
documented there, and the struct guest_memfd_provider_operations forward
declaration placed between the comment and struct vfio_device_ops breaks
scripts/kernel-doc parsing for the struct.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106-gmem-alter=
native-providers-v3-0-8484dde66a7e@google.com?part=3D59

