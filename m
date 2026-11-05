Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D62A1606B9EA
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 19:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dW/11WUL
Received: by kanga.kvack.org (Postfix)
	id E55576B05C8; Thu,  5 Nov 2026 14:35:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFC8C6B05C9; Thu,  5 Nov 2026 14:35:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEC6E6B05CA; Thu,  5 Nov 2026 14:35:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9A4FF6B05C8
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:35:46 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2785280951
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:35:46 +0000 (UTC)
X-FDA: 85402070292.18.9C17CFC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 81AAF1C0002
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:35:44 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="dW/11WUL";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793907344;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=alsXUfuEo/F1zePFVRl45Ndme/OflhiQcp41SPItDb0=;
	b=y263C85Hvc4xQ3/8K6k2rauAu/4SBLaMJfkcF8K1npX1ufB7Xgyt2lk7Bu8Gax57PWfxfC
	fCHP/MKfMqDvHPB0UoFsh2qUsDTz1kdB0UT5eA3f//iHI11VDAnUe2dos5hp+z+KkF8soa
	eAAQjecCIx4U5FjL0HFzP4GQbB40LM4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="dW/11WUL";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793907344;
	b=Hz7Xhtp0tKQYdxAr0974C7yCj1K2OyG3DQFx2uTz3gvihdipPm6Zc/H3SPzCjTntOiC9Sr
	4/eOl0cGmrT/mdBYFliDFkF33DDMtQb1iPDoDgxlQIQcoMEOdsQrN+tQLfbaJwKRMVGLvw
	yhN/gZJWb3MCiSWP7P0qwi8ecTfVaYI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D071C41B33;
	Thu,  5 Nov 2026 19:35:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6CEB1F0089E;
	Thu,  5 Nov 2026 19:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907343;
	bh=alsXUfuEo/F1zePFVRl45Ndme/OflhiQcp41SPItDb0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dW/11WULePWBsogqlKJCGC7JYPbCbnYXRV+C/X7JOVxLXj5zOAba52zQpFTgNc3SU
	 VqxLxyGyN/7wF0BTtfNixYDyxmB3E86QX9Ux9RGZ1zXR/EzZ2ZJyrhkPfunyxJJIZl
	 un+xpBbQSiFaF0jJ6u/VW8rXe40ajptsRa6PjrbVxC7gTAonFrr3x4gk/kvpjOE5P1
	 HarizfUM9JcPoR6EP40r+AaFcc6yhKBRuZw/KiwaBzFcWGsYWpC0CK/E6jNjHZpgDM
	 EXhNA7+mREaW+iD5ECYOta1cjbh7H74x/1uUayMthsMGSyY9SbGLuxXinygzr+5A4r
	 a3NkeRuyCBiAg==
Message-ID: <sashiko-outbox-199944@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 14/23] proc: let procfs copy in writes before
 pinning the entry
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>, "Jann Horn" <jannh@google.com>, "Josef
 Bacik" <josef@toxicpanda.com>, "Chris Mason" <mason@kernel.org>, "Jeff
 Layton" <jlayton@kernel.org>, NeilBrown <neil@brown.name>, "Eric Dumazet" <edumazet@kernel.org>, "Thomas
 Gleixner" <tglx@kernel.org>, "Al Viro" <viro@zeniv.linux.org.uk>, "Jonathan
 Corbet" <corbet@lwn.net>, "Christoph Hellwig" <hch@lst.de>, "Greg
 Kroah-Hartman" <gregkh@suse.de>, "Joel Granados" <joel.granados@kernel.org>, "Kees
 Cook" <kees@kernel.org>, "Jan Kara" <jack@suse.cz>, "Jan Kara" <jack@suse.com>, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, coreteam@netfilter.org, kexec@lists.infradead.org, linux-pci@vger.kernel.org, linux-sound@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org, linux-usb@vger.kernel.org, samba-technical@lists.samba.org, sparclinux@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-serial@vger.kernel.org, "Takashi
 Iwai" <tiwai@suse.de>, linux-input@vger.kernel.org, linux-raid@vger.kernel.org, linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, "Chuck
 Lever" <cel@kernel.org>, tytso@mit.edu, dmitry.torokhov@gmail.com, "Petr
 Pavlu" <petr.pavlu@suse.com>, "Anna Schumaker" <anna@kernel.org>, yukuai@fygo.io, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261104-work-procfs-core-v2-14-76ace653a773@kernel.org>
References: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
 <20261104-work-procfs-core-v2-14-76ace653a773@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:35:41 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 81AAF1C0002
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: wydri14uge9di6ytha357cosyfit41eq
X-HE-Tag: 1793907344-162718
X-HE-Meta: U2FsdGVkX1/gk3PyJpeDcDOji20nztiLNBBrkYViksZBrKELbgfBGU/5o/LZhO0Ft0mAzZSec7lZwFgzDWXZZL+1xbBFjYu9omCrKzSi6HB+RrKDYWsDxgLg/MYPMgQk5TJ0W4mV+ozTLlONeH07Mjlve4/LfulQeRYyoG38yzXxthGOobHI/Di/gSH4ZbjZ4OSxsXWRe21QJdXYC/RLarGUYsLKwboBHpyaKE5a4I8h07oEy6Tg7fdz5FEO9LWSacNuEpwGKQtsH8voe8xAnJDiTLBqSCubPlJEKOOill27Gs1+hde5TnXdXf2VgvQZG0eMrKR85CWd0yjwcLMY41dJelBq5lpjkutsl8NIZmKrEnaCkGfX9/09XjV1UOXuieHW7DZ6nypaHBdcu0yvtTeAQhJmap+vr2txxq8FlMwbhZczc4E8cV/POmpJv4NdqURTUFzy+DZk6XyL/W35UKKu7rXCxD+crDjYfTprr6dbrHQaqjgW/Uk38B4hesjMRvNbKrgh7mxHqa77pxi3I4FKwu+tkfg4b47O36f5MrJNOcQxZTt7oQWtF/0LLxGWiLMW6E26DZXupK0xfiMwtP7ENZ9WSjXm+9wD0IpfVBRm0V22WVzfNTJxrfiChnYbuqeE3+35Db40LZRU7hHEQBdE500zqD1RQ2pFtxyuj6g8mGuoF6bwGLdAqezXyZRi67BvGiIWtO5u4VUroURNwscUkXx8Xxh7tvbBpfnzA44QfKZVMFdq8GulG/W9Lo6APXFR9v907lr8YUXsG0/EEHDXvnWBcOEDKQ1Zk8jaNMZSfV/7rUEWAppMRVtItILe2n3WemDomrUT54cyJno2ic7hG2AxbqkJ7/A7zVyZd+QNVpp/GU7MXMKxsCindsOyCOzlXpgfliteYq9by+o8wMyiOraJjjfp78f9WiQioLN1sSHOTUG5DB3ZVktZwGjocE/Kn/EpE/2LGk1IEky
 sWs0gPWO
 TzDWofr1JygEc90uL7HK2EHf3ZU3aG4j8KRke3GhbSr2TdfaVVEOjxk1D7fwVDwdqN5WlnIEhjeXo3OR0SA2dxICthfg0fm2EC4BH0xyFdphZ+lLY2bJtzUpmySXu5EXeUKbLHxwQcYMSFGqBK+gouiFKND5wj9/ijIJnkNiXXc4kpy+A2Y6BOYwSKi+XQuoPFvGB6My3AdVjvive677mP3+Ykr+oQ/r3RPs5zBnKsV4PcI/6xA0iDjEs2GT0+FsD9/0S9cfXkiS7iCuKx1PMH+CRCV1y2w1EmnD+ksmklCWa6ho2jppwghS4lKKGXVHhz2paRE2iDgt5SItfvCorMDN1etxmX70rDA9/oxduGHv3zd2cZaSEvi7NVYZM2BOfSjVCOxlNlDHotxmGUAnVGO9LOs7hLf2CSS+El0ZA3+80NROhdGs207lJEuS6YgsZUzou+Zv19AxzE5nVDcpnrKgWroFNDfWeyuqVxLlNPTs96phISPJKtZeRepGHHbffo2AX+V9gT94ERUkNAp95P2o9LMW40cDvZyCJFyIHRlL6Eas9H80XtYGjsvVQ7Fbeb6o0sUcm3AakjPH8trQNCbJkOv/jSRbuwh46kPTnAkpn3Oc1VULACtaIFcfzo0NHWTGQ3gybbfJQhsYd2z9dX3jcEW81X2CPek1X
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
- [Low] proc: split __free(kvfree) declaration and initialization in pde_wr=
ite_buf()
--

commit e52627c4b4d80d32822781f143a8c1245bd64a2c
Author: Christian Brauner <brauner@kernel.org>

proc: let procfs copy in writes before pinning the entry

This commit introduces a ->proc_write_buf() callback in struct proc_ops so
that procfs can copy write data from userspace into a NUL-terminated kernel
buffer before pinning the proc_dir_entry. This prevents userspace page
faults during write copies from blocking remove_proc_entry().

> diff --git a/fs/proc/inode.c b/fs/proc/inode.c
> index d51ab7548b117..df1caa0f238df 100644
> --- a/fs/proc/inode.c
> +++ b/fs/proc/inode.c
> @@ -417,11 +417,44 @@ static ssize_t pde_write(struct proc_dir_entry *pde=
, struct file *file, const ch
>  	return -EIO;
>  }
> =20
> +/*
> + * procfs copies in what is written before it pins the entry. A writer t=
hat
> + * faults on its buffer then doesn't hold up remove_proc_entry().
> + */
> +static ssize_t pde_write_buf(struct proc_dir_entry *pde, struct file *fi=
le,
> +			     const char __user *ubuf, size_t count, loff_t *ppos)
> +{
> +	char *buf __free(kvfree) =3D NULL;
> +	size_t size;
> +	ssize_t rv;
> +
> +	size =3D pde->write_size;
> +	if (count > size) {
> +		if (!pde_has_short_writes(pde))
> +			return -EINVAL;
> +		count =3D size;
> +	}
> +	buf =3D kvmalloc(count + 1, GFP_KERNEL);

[Severity: Low]
As reported by Sashiko on RFC [1], this isn't a bug, but in pde_write_buf()
(called from proc_reg_write()), buf is declared with __free(kvfree) =3D NULL
at the top of the function and assigned later with kvmalloc() after the
count > size check.

Per the Cleanup API conventions in include/linux/cleanup.h, should buf be
defined and initialized in a single statement at the allocation site:

	char *buf __free(kvfree) =3D kvmalloc(count + 1, GFP_KERNEL);

after validating count?

[1] https://lore.kernel.org/r/sashiko-outbox-195538@kernel.org

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-core-v2-0-76ace653a773@kernel.org?part=3D14

