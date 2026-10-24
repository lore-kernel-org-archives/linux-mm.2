Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83B15606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 10:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OOZxQpcM
Received: by kanga.kvack.org (Postfix)
	id 977AC6B0A94; Sat, 24 Oct 2026 06:22:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D9C26B0A96; Sat, 24 Oct 2026 06:22:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77AEB6B0A98; Sat, 24 Oct 2026 06:22:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4F34B6B0A94
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 06:22:05 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 49255120347
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 10:22:03 +0000 (UTC)
X-FDA: 85357129326.18.77E82D9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 94AB3A0006
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 10:22:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OOZxQpcM;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792837321;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eYXM4y7vVcl00H+9DObDCdderh0QDVdn3eYPAzsxly4=;
	b=XwgDSL1tR4qGTF18QNQdsE13e3mGknshe1Heop3F/CL5rY82FuT90PqZaFsGL118+Hxsjf
	UgnTHem5hUH5DJbKctqJJgyNSGYEFHSD6nmfFpIKtXfWunoIL0mZIHCliMk8WhvaRsLeLM
	POrKqN1wReLIGBsPjEPdjgfhnDd2r7k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792837321;
	b=KcWtaTE0ClDPsuwHON8mx8ibhUCDmYnvCRR9fivQ1+3IItHN8MsXisz1Ym5ZJMImjFoeX+
	G3sfMwQKLwqNB8/R1dAbg2xyuaghCZRJSdOowd7bVhBq0sfrYGLXBCzTDxZzcRUAaH0AzM
	ZJi0HKDXgX+mbzyRxao9RCPIgfSVZzY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OOZxQpcM;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BB6DF43E91;
	Sat, 24 Oct 2026 10:22:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3982F1F01825;
	Sat, 24 Oct 2026 10:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792837320;
	bh=eYXM4y7vVcl00H+9DObDCdderh0QDVdn3eYPAzsxly4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OOZxQpcMc8VvkkOt82eS9CKR1G/9ZWClkZJCGAzGW5CmyyFBgN0kuiE+QE8QWRd/G
	 4VUJHDQuoPtZZIKtZS9Lzxjnsa4uVENe3m/uMUnPnNvZf+o/VeAcsVFcwclYDokfNz
	 Hjl9Q7OO4/TOdsucXOTtFwrAeC7r+AKsPxKB8aLoUntOzuuXzcdYfJHRhit0mDpHTK
	 /rtpVCs7+BnzhmSqigkVjElzJuKJmZKnkVpQ9TuLvAB4//+Gwb7Ar+rN/w51v6FiR6
	 IghfpV6CIfh4opwvPcQ8nDMWmGtS71jfqAwMcullCTaSRjggiZJ4bPAH2fg5h8JEIX
	 4eVHhNJmE/XDg==
Message-ID: <sashiko-outbox-183642@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ALSA: us122l: mark hwdep mappings VM_MIXEDMAP
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Jaroslav Kysela" <perex@perex.cz>, "Takashi
 Iwai" <tiwai@suse.com>, "Kazuki Hanai" <hnkz.64@gmail.com>
Cc: "Takashi Iwai" <tiwai@suse.de>, linux-sound@vger.kernel.org, linux-mm@kvack.org, "David
 Carlier" <devnexen@gmail.com>
In-Reply-To: <20261023-fix-us122l-mixedmap-v1-1-e7bdd053850f@kernel.org>
References: <20261023-fix-us122l-mixedmap-v1-1-e7bdd053850f@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 24 Oct 2026 10:21:59 +0000
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 94AB3A0006
X-Stat-Signature: wey6nxfocfqdax6ycwztbxfkji5yqg86
X-Rspam-User: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792837321-174290
X-HE-Meta: U2FsdGVkX195Bs+04LNrCr0CKU7LhyzTrL3h//r5emW1QNHRZ/C7ZYECvELYI/6uZthdfDW1DJjpXO7aQkhKGpWskXZPk1j9yTUcoF0BIivMnT4omZ5IYjBXV6bXhTp2HH3u/nDRO0YXstDXjbNYVdFfxsB86AV8JM6ufhFad+ocEvi53SnvoHNEqJDGUBAquDidbPguoX09vST4oQSTy5eBG/jKuz7v0YK0Sq9Kz2u4KsC5ii+Zya38Ekw3Cka4JRmnqn+QAX9RDgFgqwiANnOOKZdwHDLGFX9mXsMMF27AMasNOraFImQciupl+mXvyOkD7huLvqACQInVj2U+Mz2kORHFyW9dkS0xGQij1N5Lhlgo8i5Nnx2hwC0XfeybvwrMRhwstTKpYrz6xdXaFmrPRJYUGHe5ufe7w4y3Y7IIj2K3co3ZS6MisVwfQRBEuaRUq2ufGtSqo4CHcD9h2n+hlbMF2PrnAqTntzSok/tPBgoA6ubNlDtbwoqN1YssfQAeLdsT5lqPNViP8f4buy+zuAR9JmiZFc9KSR7HX7I4yRwQP89PCAsZu87yZrfwRD8GyDpeqgwLbgbGLOCjIm2aWDS+9Y5scWr236lPqedrSXBt4oK2zDDoF34aBCX29/QJcnyngS5n3dFWs/bQ9A39bPxRxq22Z9dnAcyfhz0TIkKmQ5NzuriFHMJAWe0fUBdXoGLMDwVqLd83WZpapcJ7JVWeVgRT+Pyf0OMp3qRjrvv6LZZsjRf7QD842FALOviiimHqosAhLxjJxdeHpMlEHUbGLfE74BkSJjPVEJmFriZv/0+uyLXgahqD1ydRk5MS5NKhrIO3gR9tRsfss6QMPL9ESrn1zoA7tJ+P0YKEtXYYDpxQYB4xSyo4X+AcV6xwW6mNjhdYGmoSGrdTHHUmEPXDx4mdULl0xcDSjby87vE/XDkKYquVjSTMnlLcPJPbVHeqHv7Bm4YJTLK
 QEFaLSar
 gSS+gXVycLAGr34882iGvzhLIcly6n8Vv7k9XTlZC1wJH/tL9tv7HhPjguYsQVLLr38erdv8RGsOXxRZrAUN2VEiy7IM1kLMTPMpx2Pao5lH4Y5B5Am+A815RxCW2YjEKi+2K0spTG6kY6Yi+DrKbiUtPYXuderxPypvY3+pM+tcYZ7tRcEq06t/mk2FiT44uEkzeNlvmhyEFYQeFeKD8d6Fq/EHdzm/43HG6BY1k/rNJ2DwvmzCVK/K9s30uicTG4hQd1yrT9HeJ0VOxYWdS1o9j+zQiMvKJ0oJlaQ9PX4eunaKTA+dIRtuEvq61T8m/MLRV2V/5Bn5CdkTMbFnCHKToubRRTTNCy9CZ+09CAnS6uiSDS/DdZhfe8RXstP1BKQ3lWijpah3uOseKktLsEi2apsaH36riqbIAmrMVbK/RVj/9ucavxuqgA1wa4s917mRG8KMI20/mP3mAcLxyPyR+d4tfu7gGAcZ/6D5+yD/yK7lJkk+F658wJxp/bSH+kK3d+gaCZLXjeLwTqSyae4sbNoAm6Qjc5uHQZSRR08GVR1iesDnSw7nxh13T6Kon4t3GaY3vKPzwg0eIqzr23UGAEJIIhC985TVTuV6+41twbLveLxR1MWhAWdTAto8fiw0hdXbQECeJ4KBraLClnR/I4gIDnE2MMXsqV5AX4228udJ+QKbr+QhRX/Ed96MH7AdyvVfuIuizKeIXXhFQvT9uPzuw7mtzxPjarSmsRuWmFwbXFj76GkFLhg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] ALSA: us122l: VM_MIXEDMAP in usb_stream_hwdep_mmap() breaks mremap=
()
--

commit c40f3445d293957b8d56aca33b8d5ed4071fcf4b
Author: Lorenzo Stoakes (ARM) <ljs@kernel.org>

ALSA: us122l: mark hwdep mappings VM_MIXEDMAP

This commit sets VM_MIXEDMAP in usb_stream_hwdep_mmap() so that clearing
VM_MAYWRITE on read mappings satisfies the core mm requirement that
mappings clearing VMA_MAYWRITE_BIT must not be mm-managed.

> diff --git a/sound/usb/usx2y/us122l.c b/sound/usb/usx2y/us122l.c
> index a5db0d044ef96..2986a90ea3351 100644
> --- a/sound/usb/usx2y/us122l.c
> +++ b/sound/usb/usx2y/us122l.c
> @@ -193,7 +193,7 @@ static int usb_stream_hwdep_mmap(struct snd_hwdep *hw,
>  	}
> =20
>  	area->vm_ops =3D &usb_stream_hwdep_vm_ops;
> -	vm_flags_set(area, VM_DONTDUMP);
> +	vm_flags_set(area, VM_MIXEDMAP | VM_DONTDUMP);
>  	if (!read)
>  		vm_flags_set(area, VM_DONTEXPAND);

[Severity: High]
Does setting VM_MIXEDMAP here cause a regression when userspace expands
the read mapping with mremap()?

In sound/usb/usx2y/us122l.c:usb_stream_hwdep_mmap(), VM_DONTEXPAND is
intentionally omitted when read is true so that userspace (such as the
alsa-plugins pcm_usb_stream plugin) can initially mmap() the first page to
read s->read_size and then expand the read VMA to s->read_size via
mremap().

When userspace calls mremap() to expand this VMA and the virtual address
range following the VMA is unmapped, do_mremap() -> mremap_at() ->
expand_vma() takes the in-place expansion path in mm/mremap.c:

mm/mremap.c:expand_vma() {
	if (vrm_can_expand_in_place(vrm)) {
		err =3D expand_vma_in_place(vrm);
		if (err)
			return err;

		/* OK we're done! */
		return vrm->addr;
	}
}

expand_vma_in_place() then calls vma_merge_extend():

mm/mremap.c:expand_vma_in_place() {
	vma =3D vma_merge_extend(&vmi, vma, vrm->delta);
	if (!vma) {
		vrm_uncharge(vrm);
		return -ENOMEM;
	}
}

However, vma_merge_extend() -> vma_merge_new_range() in mm/vma.c checks
whether the VMA flags allow merging:

mm/vma.c:vma_merge_new_range() {
	if (!vma_flags_can_merge(&vmg->vma_flags))
		return NULL;
}

And vma_flags_can_merge() -> vma_flags_is_mm_backed() ->
vma_flags_is_mm_managed() in include/linux/mm.h rejects VMAs with
VMA_MIXEDMAP_BIT set:

include/linux/mm.h:vma_flags_is_mm_managed() {
	return !vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
}

With VM_MIXEDMAP set on the read VMA, won't vma_merge_extend() return NULL
and cause expand_vma_in_place() to fail the mremap() call with -ENOMEM?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261023-fix-us122l=
-mixedmap-v1-1-e7bdd053850f@kernel.org?part=3D1

