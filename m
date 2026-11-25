Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58F4A606A699
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 12:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=srjxAJmR
Received: by kanga.kvack.org (Postfix)
	id 7D6D06B09F1; Wed, 25 Nov 2026 07:45:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 786E26B09F3; Wed, 25 Nov 2026 07:45:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69DAB6B09F4; Wed, 25 Nov 2026 07:45:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 35F756B09F1
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 07:45:34 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AE8501C494F
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 12:45:33 +0000 (UTC)
X-FDA: 85473612546.23.EB41AD5
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf07.hostedemail.com (Postfix) with ESMTP id 97D8C4000D
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 12:45:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=srjxAJmR;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of alex@amutable.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=alex@amutable.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795610731;
	b=j6Hjavjbx9XRWqh1Vj/nOu5wJ9NxOgU06WJPJRhkjRpl/YuI1r87UMZGzT4OaxAVCXP7nK
	P3SKxMubgXXZv0CqS5r3S3P1V93Dj4B68J5u3WzL/+Kk0HfJhAThflXYFvwx7hXIfVh8Lc
	dpurVuYLRER9NJLHm4TNcTfs0JLy6wk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795610731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j8tGJOMZL0j/KUQBnDfeHMeTQs27ZK0iqIQ4+ayeZUU=;
	b=QCtMlkMj09r1wOvYhQz87PHg0Uxu3CL5cuPMMY/Tsg+7b8LmPPa29FuG0caG0rKqFKK3qQ
	eb0gK/KOqFMK+Ftu7/QuDT1KWZli69nSyGYd2vCJv8alv/keCGP0GwleXwXIVRr6DOSEsI
	2bcdaZdFwFLtOWsAEQfDZPcMoIE6gtA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=srjxAJmR;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of alex@amutable.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=alex@amutable.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4bb6c7b6dbdso53013065e9.0
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 04:45:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1795610730; x=1796215530; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=j8tGJOMZL0j/KUQBnDfeHMeTQs27ZK0iqIQ4+ayeZUU=;
        b=srjxAJmRjQcntRnQuI0T9zwvT9qeNAVCjS3NcNS6CjyFuVm7Nm1Ep7YdkXQuoi+fgY
         e7LRHUTQlvqNgAvPd695J5JSq3NWzokNFA3tVNk04/W/1DMYEviD/uGqlL+zLVv31J8O
         OGWdox+aI5D2aKMU+Pq3+v/NtPR69YThjGm4gEVyxhfYrM1uO863cfg7aaCnxTegsOjw
         qny3OsgbiFWJgd3mZ7Ar4uJHBtHpKOowZ+KcV0QAUDh17U8Qu31LVVOhsnTB4L+ur+MP
         Hy68t6fvBau26IfE4G8w2k/H5k3SWGdfxh4uzdYEmk7EjxLViV0p2bIzl+2LrfF7GRMA
         GekA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795610730; x=1796215530;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=j8tGJOMZL0j/KUQBnDfeHMeTQs27ZK0iqIQ4+ayeZUU=;
        b=gcmr83uaftRvLge5sIZJfbxllkUbaJuhXjJjgiebz6LNvfzQ0HKDFzFvXRjuDW84v+
         aTQvMV99mus9lNzWBGl+POY4dAJOfUOiaHKgK49BWiT3rjekJ4RwfbIewqn2N6yiyBPy
         syXF5i0YfZRjzU3IN+6FLH1r/jun7qv8w93D4ZwzxnIUz1O6hiLfbyoet2wmnkGmsDNF
         CaQrw/Ty6zeoNy1PxwaX2e91ITWJiqvW93xfXaflmpceaOr3R9bAKD+h3hXBx+w3b36O
         29jn6kMrTTXS4ig07RHzcNEtPlOnmEWKq/d67gfEwocHCPT+E5IFwmy5Au+cHAtnjKVW
         gg3w==
X-Forwarded-Encrypted: i=1; AL+hErFYGLYrQ4QXq0qyLZBXlGUJ0KrWrdKdu4lxZBRoyCgfxUfyHDP3QvjF9WrUn6ZYxPotpLlEXGE4bg==@kvack.org
X-Gm-Message-State: APuU4Z/LWf0itgJiIFAH65pvGyfUeura88ukbVVmNjKag3vYCLwKKaQ8
	js5dzrWBqCoaV+HfO8qP0wNm9JKwD3DjFC+Q3cJyByYkuMeBW0b0IS3t8DoS4qV36Tg0
X-Gm-Gg: AZFdTZfzSGogcphgPMKJgoYg18P84Ro9pZAjCbTmKYgWgrF9QItYWNXrh8r8q/5ZZoT
	NWPsjl76g2uanUezD+kESqug1BceomCS/jLP3z3TRH8JTxpBm3zzFIfPC84C79HC6esHTjQettu
	n2MqqaKjkr8W8IsYuv6i3+SM+DNp9NgQj68BVRuWud1DvAH75qpzQWSjW5nzLr3QQxagjwOk5EZ
	T677j8yvILn7CfDIdSTO5T5VyiYa12T1K8YJQl00yinFFJ5ZbeYLj4AgyLVj66A5vJSX4NUxkWd
	AQiXQYcRao1J0xgo76TcH+zlscMw1keDZsUt9RVb0053IxYMXa7fx62hkp8eKdkHnwz4LzTkMJs
	9Jd3p2PtUMExyqFkTyPV7qXUD/mrf5xl5YnzhM+zZU9tDU77ah/cVfByjW3S/fGChmqczyNKgQe
	B9Ee9UAlaApjD+6gObpzkhgPnTmu+HqhHhDaOb5BKuKe5/JHCQpPIC4frro7DiV40pti3TBstmf
	Mr2Z6Iz08xDnbUAknCWrwP5FpAJfCkQEGUFykyocPcY0EHYJBb8pACxJQgZ/IpbLcQ8QvstSqEB
	wNa3H3uu+y2Qw9hDZlRsrM5TQ9VMrLijE2ANQwBWHXpZirdsARl7jLiFzXhcYUFEqaKzR3PJcZg
	LuKOK1n4zCkUYTwTnaQfNFvEWLORxnM0vNcH+EDK7aB575jj3shb43Q==
X-Received: by 2002:a05:600c:8184:b0:4a3:5a7b:6002 with SMTP id 5b1f17b1804b1-4bb8881e969mr338093175e9.28.1795610730212;
        Wed, 25 Nov 2026 04:45:30 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:c235:97b:8b16:8928? (p200300cf572c2800c235097b8b168928.dip0.t-ipconnect.de. [2003:cf:572c:2800:c235:97b:8b16:8928])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bba3d3679bsm34001885e9.2.2026.11.25.04.45.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 04:45:29 -0800 (PST)
Message-ID: <9f460569c2d4236f470231a5cce0b6086c612e19.camel@amutable.com>
Subject: Re: [PATCH v2 02/13] fs: add d_real_data_inode() and
 d_real_metadata_inode()
From: Alexander Mikhalitsyn <alex@amutable.com>
To: Christian Brauner <brauner@kernel.org>, Amir Goldstein
 <amir73il@gmail.com>, 	linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>,
 	linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, 	linux-trace-kernel@vger.kernel.org,
 linux-integrity@vger.kernel.org, 	linux-security-module@vger.kernel.org,
 linux-mm@kvack.org
Date: Wed, 25 Nov 2026 13:45:27 +0100
In-Reply-To: <20261116-work-ovl-d_real-v2-2-90564c4ae347@kernel.org>
References: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
	 <20261116-work-ovl-d_real-v2-2-90564c4ae347@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Queue-Id: 97D8C4000D
X-Stat-Signature: meoqr4segtyqofocorw9k6b6x3k673ze
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795610731-587522
X-HE-Meta: U2FsdGVkX19QcnZmXR0yDEYF/QhHP7EIhhT0BpZdWg5CqXrcfFpqHpPMxQkCQVoP5gk9KCmLqTSelH/34Xq8yfND6TcC23rrVtWqd+UuXQHBNcU8Dieju/AMEebfwhaUNahJZpLRlDoC5jTEGEtdyKPEgMhW9UBeonxnHGd9Me79KD3MDRFz0UtgnKTqKvYYwIw0VWxUcfjunMpUGFD0erove9xl+YXMWdUIuJUm15J2z8wbjn3gt9q7lFCJ+Xg/rml7zaViA4i4jK/r6eqC+Zuj9RwNkfTZMRsFBx1h+LJlZOa8pI6xzRHNUwDILKQ4wvUtYV0MsoTHRCtXELePza9dDHYEIJMvVQwKR+DqLK4NtfvH9QPD15K4R7AwS1mcryc1U+P+tE4ILR+V8MP6GDt1C0BghQQD2Q020fOY83vcTEQXSWPg1wd2caz0y/uQXqNWGFox9vLJn6WdaBFlVn6Uik3DnVPE53qjxp6Ad/QOzPM5gd33TEH9tzn+gfCymyJopsYCW8Q9vLN6NI9enE2FT3YUril4VsH3O2sRIjRHTcae+b9LGX0l6aErO8vq9uNsPIu3KuiNKt/ciCQa59ukm56LUk2zr7xTv04wxJtY4SOs7rOuVN8iNS+nMqTaqQvJjtsibBHrXwPtBTlWs9YWRjEyukHuAkb37x21WKh4hPbjnHeMvbyHkckDqf7tI7gfVnhw/ky+QwrjBpz0E/Ox01v2IdnfBEyHdGuba7otGyKyzFBh0Rlnu0InVWAarXof4AhVfcWajP1Erdvq88BIQgwZU/FOelR86Fa8bOqM6mqTLiI+k1Hs+199PK53Uq61gssrYlNWvG8AWrh6kA4HUXnob+iyIY861uj8sVLTfxVuzAZ4FZsLsJZ53E+pl2qEvuXc5t0ITCNwns9vX7+0nNQLdHnJ+VwTfOqu6+aF1X3G8rGKzeL2scVqN1LL20tfBFHtIoGklKpC5RK
 nK9t2/KH
 1MCH0duSbrOfyoyo7DypeicSqmST6FvEA96VVmfdhkM8Unn8fZX/VSO+4G2p7Yp9C7LKEQUYWsg1nfxg2HKwRwRmha41Iym3NK4IbbbAgE+alDJHVAOiFLITGJwcrX+Vw2AqkzbCac5fpOehe+uxfVZcB4NuhGDWrFr3VNa7KZdw47p8Qk3BZoAmi+VeBpsmJnKHZuceTrrDxbcVajNAeF9ERD0U8NfDet/jEyjDRqIJUwQbNkx3QsKYv24K5VM7ui1XCYzY6EwCGgI6f3RJUPpENsvZYr1dtWNs4ZSSULKRZs5mdkTD4cRfYRGHhZBkokGatLLrQhnaJYFuslBOEFh/QsvIp2230S4LYqVEzHuo82uyNeo9McwQZEsfyYIUtPa8B17YiODTbK6+3KoMMLNeVOzv4jc10hq0CBJdsPFhIOkjSIaRVYjMcILjMUiKfiZyLmoTK0OXOfBZOfmVRT+d1LHRn55oi6e9028Fd13PV21QCcSD03jK3WBZyh9j+fOJ2LkaMiRKt2X8iwSPfUlO8gU73wi/EbC9GoszFvp6QADYz+Dn2273gCCS21+sU3RVYZGpZlK7HYDjP9+ZXI7YE8JysL7gKndzajzmMapA3Afr3y061OqYTIe4ZoyWUskiSfWbrytBowjlEt+IBW+zWykvnFUyYIB81xPH0fAHAfqGS600drnYQ0CE0ywyyQbb3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 2026-11-16 at 10:43 +0100, Christian Brauner wrote:
> Currently, d_real() can't fail. When overlayfs fails to look up the
> data
> of a metacopy file in a data-only layer it hands back the overlayfs
> dentry and callers silently work with the overlayfs inode. That's
> more
> problematic than current callers realize.
>=20
> For trace_uprobe and bpf's uprobe_multi it means uprobe_register()
> fails
> with an -EIO that has nothing to do with the actual problem. For IMA
> it
> means the stacked change detection is skipped and for IPE the file is
> evaluated against an inode that has none of the properties of the
> real
> file.
>=20
> Teach d_real() to fail and teach all callers to handle errors. This
> adds
> two helpers for the callers to switch over to:
>=20
> - d_real_data_inode() returns the inode hosting the data or an
> ERR_PTR()
> =C2=A0 if that can't be resolved.
>=20
> - d_real_metadata_inode() returns the inode hosting the metadata or
> an
> =C2=A0 ERR_PTR(). overlayfs never has to look anything up for the metadat=
a
> =C2=A0 but we don't want to promise that it never fails. So callers handl=
e
> =C2=A0 errors for it as well.
>=20
> d_real() can't fail yet so this is a pure preparation. d_real_inode()
> stays around until all callers are converted.
>=20
> No functional changes.
>=20
> Suggested-by: Amir Goldstein <amir73il@gmail.com>
> Link:
> https://lore.kernel.org/all/CAOQ4uxhGxpBtMZ5kfuzR1tQAewiecoX7UjXQRo91QjJH=
H9T_Yw@mail.gmail.com
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0include/linux/dcache.h | 45
> +++++++++++++++++++++++++++++++++++++++++++++
> =C2=A01 file changed, 45 insertions(+)
>=20
> diff --git a/include/linux/dcache.h b/include/linux/dcache.h
> index 84b0cfe4ed0e7..a75016a713d4a 100644
> --- a/include/linux/dcache.h
> +++ b/include/linux/dcache.h
> @@ -3,6 +3,7 @@
> =C2=A0#define __LINUX_DCACHE_H
> =C2=A0
> =C2=A0#include <linux/atomic.h>
> +#include <linux/err.h>
> =C2=A0#include <linux/list.h>
> =C2=A0#include <linux/math.h>
> =C2=A0#include <linux/rculist.h>
> @@ -660,6 +661,50 @@ static inline struct inode *d_real_inode(const
> struct dentry *dentry)
> =C2=A0	return d_inode(d_real((struct dentry *) dentry,
> D_REAL_DATA));
> =C2=A0}
> =C2=A0
> +/**
> + * d_real_data_inode - Return the real inode hosting the data
> + * @dentry: The dentry to query
> + *
> + * If @dentry is a regular file on a union/overlay, then return the
> + * underlying, real inode that hosts its data. Otherwise return
> d_inode().
> + *
> + * The union/overlay may have to look up the data first. This can
> sleep and it
> + * can fail, e.g., because the data is missing or because its verity
> digest
> + * doesn't match.
> + *
> + * Return: The real inode hosting the data of @dentry, or an
> ERR_PTR() if it
> + * can't be resolved.
> + */
> +static inline struct inode *d_real_data_inode(struct dentry *dentry)
> +{
> +	struct dentry *real;
> +
> +	real =3D d_real(dentry, D_REAL_DATA);
> +	if (IS_ERR(real))
> +		return ERR_CAST(real);
> +	return d_inode(real);
> +}
> +
> +/**
> + * d_real_metadata_inode - Return the real inode hosting the
> metadata
> + * @dentry: The dentry to query
> + *
> + * If @dentry is a regular file on a union/overlay, then return the
> + * underlying, real inode that hosts its metadata. Otherwise return
> d_inode().
> + *
> + * Return: The real inode hosting the metadata of @dentry, or an
> ERR_PTR() if
> + * it can't be resolved.
> + */
> +static inline struct inode *d_real_metadata_inode(struct dentry
> *dentry)
> +{
> +	struct dentry *real;
> +
> +	real =3D d_real(dentry, D_REAL_METADATA);
> +	if (IS_ERR(real))
> +		return ERR_CAST(real);
> +	return d_inode(real);
> +}
> +
> =C2=A0struct name_snapshot {
> =C2=A0	struct qstr name;
> =C2=A0	union shortname_store inline_name;

