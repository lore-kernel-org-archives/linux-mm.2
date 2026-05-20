Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9393CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 14:44:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 464796B0005; Wed, 20 May 2026 10:44:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43C816B00A0; Wed, 20 May 2026 10:44:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37A0B6B00A1; Wed, 20 May 2026 10:44:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2790A6B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:44:22 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CBD001A0345
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:44:21 +0000 (UTC)
X-FDA: 84788068722.11.ACBE806
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1C8BC20010
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:44:19 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=Jk+SBRmX;
	spf=pass (imf13.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779288260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MHFESVVSu7euz1V34AjHeP50725ahkv7VZtZOUpyKew=;
	b=xdYsvSdCKKUPaTqPm0Ra4p4CJifpIgDEltYfvY3nOiasxJf4j5CGsTyPDTldWj1tIWo/bV
	MrIKtSwo6kHRSpjBTDRkFRZmcwKCRfD0UvMcvh7B8zdg42ydLarMg3ZYBbL5d2uORaN1+u
	9G2VWxG/oDEKe9HkW17rcjyxrEGE7sc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=Jk+SBRmX;
	spf=pass (imf13.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779288260; a=rsa-sha256;
	cv=none;
	b=haynk5kBjb69+d8a+iqmK/LGDxiWrOLgemjNfCQ5Yh5mIKgTPkZQUSf1EbqxGRpkzBgqGf
	WIO4dHRJRQ1wBmzZJn7DSjli58ixyDm7hDqQsR6PuEizjGhIMqohXB1PrphCw/zkAb5RUW
	xmQM/D/5ruc7Tb4jgDn0swgBHAPPTDc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1779288257;
	bh=QmwuzewkVbLg4n5w3vw+KAhs4FYKjhey77KymFbvj/g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Jk+SBRmXKrd5OZNxuf19CskKl3KYqJdl/mLtKpaGjYrK/gml8sp9nI1RH+M1kmaxt
	 +VfYm2nX0mJNN1yMviCUr5zKJidA5IV+XQAJTIbzQYt9/UMAwJJ9pPm7qn+s9LqljO
	 8dgatVbHLFFjvwosMj8910BF8Msh2clj/owUkeguYt9aATO80hvY9rmR2pN86BaVZu
	 R97cdl9yI+ex4sbdhs8BF6dO1nriOvZPCz1yoCto1uUxXrJxcm8yPVRGCr7nHT5/GL
	 g5o87/Uox7PVLEd+hJZIWCn+HfuQmiDc4nJQG6oJUC7X94bTP80DerMvkGdpHk9OaF
	 IPeQVHQrRfb8g==
Received: from fedora (unknown [100.64.0.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id B5C1917E0504;
	Wed, 20 May 2026 16:44:16 +0200 (CEST)
Date: Wed, 20 May 2026 16:44:12 +0200
From: Boris Brezillon <boris.brezillon@collabora.com>
To: Igor Torrente <igor.torrente@collabora.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>, loic.molinari@collabora.com,
 willy@infradead.org, frank.binns@imgtec.com, matt.coster@imgtec.com,
 maarten.lankhorst@linux.intel.com, mripard@kernel.org, airlied@gmail.com,
 simona@ffwll.ch, dri-devel@lists.freedesktop.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 5/6] drm/gem-shmem: Track folio accessed/dirty status
 in mmap
Message-ID: <20260520164412.3a73d85a@fedora>
In-Reply-To: <d89422f1-f00a-47b1-b68a-d949d6d6a974@collabora.com>
References: <20260209133241.238813-1-tzimmermann@suse.de>
	<20260209133241.238813-6-tzimmermann@suse.de>
	<d89422f1-f00a-47b1-b68a-d949d6d6a974@collabora.com>
Organization: Collabora
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1C8BC20010
X-Rspam-User: 
X-Stat-Signature: igyep3m3yz6q16k8joxpgtq6jc79akcw
X-HE-Tag: 1779288259-3201
X-HE-Meta: U2FsdGVkX19Z8YhzpFvPtFRgKaRBpG/A+ZOi+6M/+zv3wo8meYeq4BCWgSN9hMTWNb955nEr1QbnAZFfa/cXQpASeoC2D+/P58OcR+kjfWOwjEA+MQpVhAHMmX3uiRxuvx2Krh6YcBEUCGUVLvaowABbxGe89nLyHrXZcGQzWLaT0eeFvTSsRYiHRmCpIUj6Pnj24Kx4PlT5H2Zfq7r1YPlcFyJSXCbCNz2Ty0369n5EHRULnCwvMcP1fAVkVnLbgd97mgNbI8uoDHoR3sTSLkxB2v5TYbYmHcYMUUSnGz4RUtxV2+6ZpBJVdxYUPh0Kr7CUAkHxjnkXA8NjKXIV7JW3lni+GiPXOmnL4jyLVDRY+x2sYlPxElhrR/wWUCbxQhiK9hv5biDKiuSd/uMkEYm87/Udhzd+hPA5VvjJIk8xX8q1OSBvfWRJ8ki+gfG3DG9DCnnKga0L9L3D7hKhPWuVnKBo6x0asOOjeaEinmZ/8uC/htqbBuV5WWVUyoM+E2KQ0qMK6e7rwWpKsYl8IhTXNmwtdj+7rFbRr7QP0dW3pOWfR6YjxLau4avdERobXMbipFEdVAf91QroCjz25ZtxQAsSfwHbGKvCH+3ndii4hua40WNQeryi6gGIXRM0oBzSduSqwUfNdbw7MKDU/o95aFpWsmjZexxjzl4sdTdbBYBhpvoy8KIp3dAkZNtgihJwsMLLXz1JdAQ2+ON3qjATlksfDNNWzMLHYPHzV4r/lQY0PrPnpmFbO8kt3uqC3qOBCLNxxuMADGteqpiQ8fVEPG7XoteVyoV78HC5MkZEB0AaBsl1b2HKhbKuSGwVB+kJA0fP+ZX0duIEHT/qdhxKxCe86ooh9yhxF3VEKPrntSvutTnjvMGCp+WL3PR22K4yWppCZvncPdK68mFuT/Mi5sSONjDZtLU4Q2l4HvgBeDRFVK/3TCBvlv4nHQDrPjwzIL501cslAv+I/4U
 ADLIoLr4
 qi6kooX8VQWUAohKHBSTriAkPmq0VyTEHxbQEjfeLlpD7k8olU5UZXNrIub6p1k0la23EVmgRXfS+EEdLc9zRepm5MBDYa+kuWOKZCajKtLNebhAmstUi0IWC0izZ9lOyHsiICr6o6Ufcne/73WTJdz7Wqr8krrUh9W/XoYBJFeEabblvm8Y9sOZrWAVpCs6TBPK/rsY/b5wIczGuwEljjo/K8PSUeOlvwy3eL9dUrtX/VEwV+kSEh5C42YZ+0HMnLokqUJwfIb5bIhWaTThk+9E2vM8Nsx5dWI59CFj85NY9LsxPBbdZxllVpvz4/ooh6wnn9FcBbQCutY06KWNw3Sz8+yBm2lYypykT35uAGWUeNtapsoQ8XPNiEXIllo5mVuBa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 20 May 2026 10:11:03 -0300
Igor Torrente <igor.torrente@collabora.com> wrote:

> On 2/9/26 10:27, Thomas Zimmermann wrote:
> > Invoke folio_mark_accessed() in mmap page faults to add the folio to
> > the memory manager's LRU list. Userspace invokes mmap to get the memory
> > for software rendering. Compositors do the same when creating the final
> > on-screen image, so keeping the pages in LRU makes sense. Avoids paging
> > out graphics buffers when under memory pressure.
> >
> > In pfn_mkwrite, further invoke the folio_mark_dirty() to add the folio
> > for writeback should the underlying file be paged out from system memor=
y.
> > This rarely happens in practice, yet it would corrupt the buffer conten=
t.
> >
> > This has little effect on a system's hardware-accelerated rendering, wh=
ich
> > only mmaps for an initial setup of textures, meshes, shaders, etc.
> >
> > v3:
> > - rewrite for VM_PFNMAP
> > v2:
> > - adapt to changes in drm_gem_shmem_try_mmap_pmd()
> >
> > Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> > Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com> =20
>=20
> Hi Thomas,
>=20
> I have and Radxa ROCK 5B+ with Mali-G610 GPU and I'm developing the VDRM=
=20
> (native context) driver
> for panthor.ko.
>=20
> Recently I update my kernel from 7.0 to the 7.1-rc3, and qemu started=20
> freezing with KVM error below
> when running any graphical application with Venus or Panthor VDRM. For=20
> some reason Virgl is not affected.
>=20
> ```
> error: kvm run failed Bad address
> PC=3D0000ffffb4a86d70 X00=3D0000ffffb4be5000 X01=3D0000ffffb2279bb0
> X02=3D0000000000000600 X03=3D0000ffffb4be5000 X04=3D0000ffffb227a1b0
> X05=3D0000ffffb4be5600 X06=3D0000000000000001 X07=3D0000aaaaf384fd80
> X08=3Ddcc58d0daf897753 X09=3D0000000000000002 X10=3D0000ffffb4b96758
> X11=3D000000002533f84b X12=3D0000000000001060 X13=3D0000000000000000
> X14=3D0000000000000000 X15=3D0000000000000010 X16=3D0000ffffb3880128
> X17=3D0000ffffb4a86c80 X18=3D0000000000000000 X19=3D0000aaaaf384f8a0
> X20=3D0000aaaaf37cec80 X21=3D0000aaaaf37c7210 X22=3D0000aaaaf37c9550
> X23=3D0000aaaaf37c74e0 X24=3D0000ffffb3b47fc8 X25=3D0000ffffb3b47fc8
> X26=3D0000ffffb3b43c78 X27=3D0000aaaaf37e1840 X28=3D0000aaaaf37cee50
> X29=3D0000ffffecbf1a60 X30=3D0000ffffb364b530=C2=A0 SP=3D0000ffffecbf1a60
> PSTATE=3D0000000020001000 --C- EL0t
> ```
>=20
> After bisecting I reach to your commit.
>=20
> ```
> 28e3918179aa75cfd4490b3b0281496ed91d829a=C2=A0 drm/gem-shmem:
> Track folio accessed/dirty status in mmap
> ```
>=20
> It still reproducible in the 7.1-rc4 (ab5fce87a778).
>=20
> Appling the following patch (Boris suggestion) fixes the issue for me.
>=20
> ```
> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c=20
> b/drivers/gpu/drm/drm_gem_shmem_helper.c
> index 545933c7f712..1e036f69c1ce 100644
> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> @@ -696,7 +696,7 @@ const struct vm_operations_struct=20
> drm_gem_shmem_vm_ops =3D {
>  =C2=A0#endif
>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 .open =3D drm_gem_shmem_vm_open,
>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 .close =3D drm_gem_shmem_vm_close,
> -=C2=A0 =C2=A0 =C2=A0 =C2=A0.pfn_mkwrite =3D drm_gem_shmem_pfn_mkwrite,
> +//=C2=A0 =C2=A0 =C2=A0.pfn_mkwrite =3D drm_gem_shmem_pfn_mkwrite,
>  =C2=A0};
>  =C2=A0EXPORT_SYMBOL_GPL(drm_gem_shmem_vm_ops);
> ```
>=20
> I'm not familiar with the drm_gem, code so I don't any more insightful=20
> information
> to share.=C2=A0 But hopefully we can find a better fix for this.

Hm, given how close we are from the end of the release cycle, it might
be safer to revert those .pfn_mkwrite changes and consider them again
once all the details have been sorted out (it's the second time around
we hit issues on this patch, and the lack of reviews from MM devs is
scaring me bit to be honest).

Thomas, any opinion?


