Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64FDD606A326
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 00:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KyjKx80N
Received: by kanga.kvack.org (Postfix)
	id 65F2E6B05D5; Sat,  7 Nov 2026 19:44:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6368C6B05D6; Sat,  7 Nov 2026 19:44:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54E7D6B05D7; Sat,  7 Nov 2026 19:44:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 222146B05D5
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:44:37 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9DC6612024F
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:36 +0000 (UTC)
X-FDA: 85410106152.20.931F31B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 00547C0005
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KyjKx80N;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794098675;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RmJ7M5blQgPkbOX5TxgxTr5nIo11N9om45iOa6C2Vkg=;
	b=Tr0FQJdiPqFgM2W/8UszpRzlR6eTJcrxtx7W9RLGUmjGLGZZGgZaiBbbqU1bzvfyWC3mM1
	7kjqcCJVbAx6HBNmU+5PUibUTVsBiMXWVUkCiZxTCunZ0rkXibN9Tey76zXyas9tLb9tjG
	L8hL7/xl6FaI+cg39CxpcNFImN6spvo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794098675;
	b=uTMkPpxiUYN70U8QgMVkK9xRg1HH+qWobLyRSvryUrrRKEDWgU+TbzoFx42mdEGAPKYo/F
	SVwyp4xNmSBt+g+pBlAsqPxbHVbj1CVbOUQwrqXphLpHmodxS9vZKk/ale/ZZjzr1r+qkO
	NZ4Q0259BwIWY69T+bs6GCYIsPUaV7Y=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KyjKx80N;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6790C409CF;
	Sun,  8 Nov 2026 00:44:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 657391F008A1;
	Sun,  8 Nov 2026 00:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794098674;
	bh=RmJ7M5blQgPkbOX5TxgxTr5nIo11N9om45iOa6C2Vkg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KyjKx80NzW7hR0AOJO5TecuHZDm4+kHqkWhd3wh/cikDNlwYq7UuehUENlT5VvGml
	 51T6arQNg3tui+MEgdfVbZLsPAUKbhbjPxNEUAP2HSmD6YNMO228pR1/i9F3ZPcFlS
	 8Ne1EuVQmlPDtlwwirP8xa91grh76JGNip1BTePfD3myMj1W14aKoNe1wHRx8L6Iu3
	 ihwJLpdJmP/hP6iK71fRoJ5ls12dTAfLbKCvdUKUDuWGA0T0H0hnCFELotgiD0jjGa
	 EtN2XJmsuubSnQOa0NPb+VUTiZe+s2VfnyK+Ody/GS0jkCXeFoUcGAhHQThU3PUiyi
	 bniB0Jkhg+EEA==
Message-ID: <sashiko-outbox-203480@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 69/88] vfio: Dispatch guest_memfd read and write
 provider ops via vfio_device_ops
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
In-Reply-To: <20261106-gmem-alternative-providers-v3-69-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
 <20261106-gmem-alternative-providers-v3-69-8484dde66a7e@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 00:44:32 +0000
X-Rspamd-Server: rspam06
X-Stat-Signature: yu8xa5eq4k1ctewa56pz1fpyeg7tugwd
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 00547C0005
X-Rspam-User: 
X-HE-Tag: 1794098674-244592
X-HE-Meta: U2FsdGVkX1/RgFouu+e94reYNr/AfBegzcLVMp9wjnOfkgrJpsQdjBRdMgCgMKUnKn3VmCzHopQY/3NJDUYSthC+iQ0649nZGuo7XkGtpnqhqtfV0tGQLbhDoN++s1bXoNPdtsgfqBmSjO/ace79dgtq5vbKP+x1/62tcqcmgo1hsPc9fcxxljgKSb5EgpruxV52rNIxHmKI07fV7Olz++lvysm6cvol8elO8KQyWr5CpPAMFAY4pHsqxU8uHkLRRMKY+fLWbahkdCTYKfNWFnNPXe3SgQv1OW+gCnNvjM5KYXYhQMUwCr8uTDklZ3OluW9aBvU+17AxAy6R/5QEfHyhvoYMN9SnmauK4iWSJlQOAj2R5kS87/BYZyhOjHYaXXuH2ZeIwRIMTpbOWxFryjgXGTzMN89kFWYfqNauWJq0bdVwrHRVxSJkNOp3rLhIRJglxQlMWpiCyyX/ybxixhqAkHT8/ODWTUxspofpk9G69QDtjjn9BWAnVvCLB0dIeCVCCHJaScNuY5F5b2GFYucqd+nGCsmJFVuHNW8+eWWzEx+jH+GGjdiVGzg0ah/9Ro6i4gaQd5iJ+ehuTrCpHXxI1rrJw/2gj4cMMX0zcC8Zx0gdK4KUgtANzf9ti5RBvn0Nf4AHyFmx10kTRPFd7iezLqYhf5+2kUk5JSBhLpuIlvD7RLAI939atfa2rY6LiXvOYsBYKr4DBKXsrVkY+uonUW/ZbNeoRJm/cHdjAeUcK8nktcsBkT3xvT/e9iV6xw0s2jj/bQJBX9bcbYXiJecDdxqTHdVSwB6Ju8s9BMagxZjiXlQP19a6Vj449UnmVXcajTgT8+f6hML9XZAPj988YVNmFjvK6doSvWdoAx+Dsumnf1SJI2/ydaYQOtZZjQpydJ8BwVwQQBj5TFjwa1MlJqz6Kfex2+X21oLP/LPhHRzS9vWH4Y8P97fLjopaiZ0gS0axvVeVitGq6fL
 HBzx/tb/
 nnKFHY2sol3GH+ZTGxDgzpDEB4mMiZhHJRJQEDmCXwfpsnqwr4Ss4GgSXO83jKfqTxf0yNBPPG3CaBZg3OnBIVz25clcTX9pj+NWc1eHuIvMiIjhWcEvgTCmkT5LS6K4pPYdp80V45sIFq/jVdRvCyF1afDAsY24thSddPEZmAH6r4YNPVufIEfW2CgujcM1fwl6h+2MzC8D14P1ZG+MbjxpgTyRNffa/CaaKii18Ehjk4A8Fk3c/a0DVFFlFPwZO2EqUkdUBHXaikcJgyYHN1JrunIv3hNBBzEH2kBeCLktyLZPuzZlSbXAziqEywzITCfVXMxD3UunpH3vh2lZFGoik7xooiqNLZ0vIdqLXHfpg8iiBo8Xf3/0+0PEGNioOzHOAwn9dGOLY9Te20IKabA7u7tDdreAjfZfwxIA7xT+HqQqWGoEzINz9yKWTXTyAZjPCDN6/G7ESyMG+7cStGGo4F9yi6YWJBx0dQmVUvawrteXmQo/ecA0V5uHhhN3Ut27rZD2ygNbEwN1NVBMZvfb88YRoAePX56TZ7zgtTH7Gzv3uJgWOoxFN/8gwPP53mCLQ1PojPcfVFeDL3UhTbGwgtAoTX1oPARYLXJE1TuxQBRYDiXb7MnQEu/it2VJ9nOrLiMuef54ud/Njox6VzdrOg8gp7isVZmzA+37lp13wNyaOtTChFsPZ5RiHuA1D+eybeDGVC8E7MfJ664nWbUP32w==
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
- [Low] vfio: missing kernel-doc for gmem_read and gmem_write in
  vfio_device_ops
--

commit 1e0b7bdc6352dbf69f404e2847472ddba12fa151
Author: Ackerley Tng <ackerleytng@google.com>

vfio: Dispatch guest_memfd read and write provider ops via vfio_device_ops

This commit implements the .read and .write callbacks on
vfio_device_gmem_provider_ops to dispatch data-plane reads and writes to
the bus driver's .gmem_read and .gmem_write callbacks on struct
vfio_device_ops.

> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 8022adedc26a6..012a233a375ab 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -130,6 +130,10 @@ struct vfio_device_ops {
>  					 u64 attributes);
>  	int (*gmem_lookup_pfn_range)(struct vfio_device *device, pgoff_t index,
>  				     unsigned long *pfn, size_t *nr_pages);
> +	ssize_t (*gmem_read)(struct vfio_device *device, void *buf,
> +			     size_t count, loff_t *ppos);
> +	ssize_t (*gmem_write)(struct vfio_device *device, const void *buf,
> +			      size_t count, loff_t *ppos);
>  	char	*name;
>  	int	(*init)(struct vfio_device *vdev);
>  	void	(*release)(struct vfio_device *vdev);

[Severity: Low]
Should @gmem_read and @gmem_write be documented in the kernel-doc comment
above struct vfio_device_ops?  Without descriptions for these new members,
scripts/kernel-doc warns about undocumented struct members under W=3D1
builds.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106-gmem-alter=
native-providers-v3-0-8484dde66a7e@google.com?part=3D69

