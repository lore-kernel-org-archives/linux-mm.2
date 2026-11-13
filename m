Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6494E606A339
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 12:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=kBZWa3Fh
Received: by kanga.kvack.org (Postfix)
	id 615A46B070D; Fri, 13 Nov 2026 07:37:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5ECF76B070F; Fri, 13 Nov 2026 07:37:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 502CF6B0710; Fri, 13 Nov 2026 07:37:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 250AB6B070D
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 07:37:07 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BC073A02AF
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:37:06 +0000 (UTC)
X-FDA: 85430045652.29.F712544
Received: from mail-wm2-f11.google.com (mail-wm2-f11.google.com [74.125.225.139])
	by imf08.hostedemail.com (Postfix) with ESMTP id C5B5916000C
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:37:04 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=kBZWa3Fh;
	spf=pass (imf08.hostedemail.com: domain of alex@amutable.com designates 74.125.225.139 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794573424;
	b=SBTRi2+0z9SVE+7vEqOADMkzf0/5b1PjcBvvRkePiaynMiXdKyLYX8d1Nn9/pY5URIhvg0
	Bzra5W2RnX93VxdBARYlV+yJgsvEGz8RHBRatEAxUX9hLC5MSCKaHeHi2TfSwIG8TNdzDI
	eEKtf/PRHB236iQnHA3/cTLTieQ96q0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=kBZWa3Fh;
	spf=pass (imf08.hostedemail.com: domain of alex@amutable.com designates 74.125.225.139 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794573424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=87/Ge5NhXdmtGpcXCLUvnqWpWEAxiW5M6eWOW+m4zUs=;
	b=EiBMaXbPls/jRPJaGJkehYAqNn6zTCFjELYmUodT57aYyC2CSYV1Skm4VW33V3YeJDabhq
	MS62TSl9HGOAf8D0vTELdv4VMf1DFdk2MypNPL1k6H15KIfDQ/P7uCGWHtfJcgOpWmeOf4
	pVvnjaugB/EDMHKAZ29JTuRTZ4b9FNU=
Received: by mail-wm2-f11.google.com with SMTP id 5b1f17b1804b1-4a5f76661b5so3542025e9.0
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 04:37:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794573423; x=1795178223; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=87/Ge5NhXdmtGpcXCLUvnqWpWEAxiW5M6eWOW+m4zUs=;
        b=kBZWa3FhJoghpUzg0RY/21IcSV18GjfYLTbLF7tH05UypOYxX+HVkcivww1uIdv5bS
         /yRTO6Qv7unQN5iN09eAijaBzq10Znb+TBG+pByZFCBeehkDQyWUrxcIDRQZe/GS9t/C
         eVc003Lb12nG4XODASf9AJLYZqX41rnMgq94EMTe1rDwEg3QWiCUyyvBE6gEO0p3K7oM
         P7NXT67Rtx37jU5LZPR4nUByyj6fymiz3UFHl2f9dFblxsCNrqxb7hD4pAk5d8pu35wc
         7RgNb0L7xsur9si/NRF9T8fnirpidPz0H0GqLsjEvHJZysus6fVBqK1hQDhQWTSIaw/V
         WxKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794573423; x=1795178223;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=87/Ge5NhXdmtGpcXCLUvnqWpWEAxiW5M6eWOW+m4zUs=;
        b=PluMJ05jF/R/Jo6QV4f0eLKfaddcEiOIkuFS9/23mVm+Jsz7ioOVw1dO8qUgla6RVs
         egpfFjlQcw4vNTB+TI9UmwemPpcs+5P0VuGGbqu8OqsXkZ+/w1/JPXpCJvjqp9WYR4Vh
         GSKiLxJNTNEUgdBsuCaJ898qLgrWxrCGKHAGF+w2/xhmGV6Zlp2HN4G7tMkveJZ3RHtf
         Ag6cwrjxou44q5y8Zd3Jm8XUWwu7IucIjv7Xu64q31AL/cvVGY0V13QkV6ZoNSWwrpO+
         35o2bgCCOxxnMKzMEtNi9xc8IBpEbmS7Mwi+KjcYNR1ryfcx7mTGxDLuUD3XyBNDMs1/
         jqeQ==
X-Forwarded-Encrypted: i=1; AL+hErEEEM8JFBtVftAkHrnd+3+LykgXqbXV63hpWN6ZSNvf09XlXVSAivflVxMx4XStr+WDRWW0bdPNZA==@kvack.org
X-Gm-Message-State: APuU4Z84iGye6SjLYMkVWyWqra6FfVT1ZwBpyCBA/7ob3HVD34ELEDsk
	hQjvXYR3TgqBuKDnK76e+f9GCA3sAZqRaurjC2ShQBaLNAG7W/kC41V9s8fBpe7Hb+4Y
X-Gm-Gg: AYBFou10ET8KZdVqbicXzmRbuIOhGda+NnoaFJwNUWAOSFBy7brrvhtH1wQgKNuuiSN
	QrqAMER1d5iGUY0GcluHis9lg+bA0Mgjz3gXgHByvgSFMn7RPKIZqLNPFSeobtvTXXNlvXYH2D/
	AUhb1Obr6Yp//xYjUEsVqz7OWMV4QyYjB42LUjMth+b271JCZRwgp9yCDfxpSlLJiNA61o5B1pb
	WFXzwjlwwKrADb6soHFJI7w9u3O/4pK7mBxbHW57zsV9mlKNkmaBZz9byPIvJXJTXcMm3MDe8lL
	4Qi+GcCxo8N5Aw9bqX0J0RJBoB9E0wLtwkqDi5dP7uP/Cp34qeOpJJgeo0by2aGYSbYRnMWon4e
	AG83psdul8ATHMZ0hOy8WrNAXXyngq3/XiNcwWBB/x6pUmYxCJoZEj3iMd1EZDlYu0vtsUiy/aA
	e89A7q6SSLRQZJFHqTKbgl1Bbqono9MeYKuMbuv3Zif1AxzykpGz7zbqTnXWNffrPod84jW5Eeq
	5hxh/E1x9MU5CB3QCxIcXV0S2coa6grcbdC1Nff9i/yE35CIwaeOt5cYvc1BR47ZteZGivejMx3
	WslDx3HRFIs2WJCuBFX4g9098FKQfBv2+GNf+qzMedwc0lzcvhLfgS/34VpApsOvRvwoWdBf21Q
	3xhQu+WzZ
X-Received: by 2002:a05:600c:b86:b0:4b5:d95c:2378 with SMTP id 5b1f17b1804b1-4bb55ac4030mr49782945e9.34.1794573423157;
        Fri, 13 Nov 2026 04:37:03 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb55af2901sm57437255e9.13.2026.11.13.04.37.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 04:37:02 -0800 (PST)
Message-ID: <f12140be54ffc4d1e8e4026f80c41c75cf5727e0.camel@amutable.com>
Subject: Re: [PATCH RFC 39/41] usb: gadget: f_mass_storage: refuse files on
 pseudo filesystems
From: Alexander Mikhalitsyn <alex@amutable.com>
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, Josef
 Bacik	 <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, 	driver-core@lists.linux.dev,
 linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org,
 netdev@vger.kernel.org, 	fuse-devel@lists.linux.dev,
 linux-efi@vger.kernel.org, 	xen-devel@lists.xenproject.org,
 ocfs2-devel@lists.linux.dev, 	linux-s390@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, 	linux-usb@vger.kernel.org, Amir Goldstein
 <amir73il@gmail.com>, 	linux-erofs@lists.ozlabs.org,
 linux-kselftest@vger.kernel.org
Date: Fri, 13 Nov 2026 13:36:59 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-39-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-39-4c998976c6c7@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Stat-Signature: qa9ik7684mb4hcf7mhydoxsqnq4b1h56
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C5B5916000C
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794573424-521048
X-HE-Meta: U2FsdGVkX1//9zJ5yFVFYhgmaVZXF0C/WU/mugcq4LrQVMyZWWE4+rH0VfwfSNsoXPjKuJRte1zcIKc3zO9fp3WOIo5N6bImuH2n0rxy8zFpPmwjBLznBLm4KbC3GR6xCvxmY55Y8OaxU6XizKk4vL+RyxHXCBVxICg0puqnLd0sOCi13oFs3+UUTvNuzTLp4EYj2XHtnpKOBpZv7lbB+qDxl8Jlsl0E7iBq6hTXd7GEVGkq6iqVMWhj50StxT+ve99+9zRxUAKhwaz7uOhDKUZ0+zN0UW9eIFne7sgAMWAI90RKdJpCxKJhwVfPYUq/BxT60TF6xjIjLzzZfxZ7uDe4JjKEKLBbN6Z/Mhmse23PDx37ScgKgA1+rTzZDyBW3Yoplm1HDS7B+g6R396utOsfdLG+h9YPfjB6+lTQsmzJxI6m70c+SjO1tvsYfI28OFXmv2Y9ynnc/k3WZMWNgWaw5zj0KIMmCR7aDSK0q67KuAaiwJ6CVJjI3qOvNpQYPLRZX7NHIxsIzgG6OxIX5f8hWW7i1jD36D441BBNKezwNgjr1HUbaLxFlRFVM7oA2KmXVT5agmH5wSaxbkAzLTVrioYCxhfPl0vjMWTADhCx9KsEUrAbmD3eEmS6ePGgnwQJvMq+L4sgPK0gVK16xstq3Pyc1RoZUTTIbyRbDRhwydCWOHlGClvqTMaxwmXywSf5tfB9vBRME9Mza+eCIbba/8BvCFySveoG3vI92LNYLqo2Wi/8goBWmneK1UBb8MkCuuVf/WblWYMUh+b9GrxnUCLAwNTbcX89SUvcRnSaVDzJJQriIGS7q+AijZzYLWrvX/n39ddOdennwdkho4CJEbPmLnt9A1D3cfrstl8uatTDfGclh+OptwM0gxIv+SZwD9Df9/nWNoRPn+HWhEwnLPaPVRd7cKNDdxijHE9pgH57Zdtg1qJb9xX/kBpDQOuB86+0oLWvK89BV77
 QwzWTTRY
 war1n1+mMrsZjqVb4x9jeCX3ZW10+2KfqlRuTI6OoEpfjcVvuB+txVD4G1k6D/kAzEsgQYtML0cfPCZWiH2UXZU7Kw755OkVoLEPqDahsqWe0qsjVOUYWiWatcSsltkDsKCRzOOPpqKTz+PHY7DktfA8z49otVMsejLZKl3F/8odTh3yIp6ePoLB83VUphSt1bWCreGJYpDFIQoGskzdJkYR6cAkHTD19h5DvYJmLheiTNMEwjQeykUN8o1dqHfo5t0NBTxXeqXJ7nqpJMoQ+QAGIRH79MI2gHP5g935Ei3g/SlOkCXB51IDmQ9HU9WtOmlpJvi2ajq33lNZJ58laZSTvqNeqHO45sqxLPVmOgpwFMle9tXfG0JU3jvaLE0+UEque4v8v2zm3FvTacu2CXSrE6IVF+CT5NsbO+ToEZpEGHe0Qgg1dKpJ54+fAvK7nO5sTdYh7+LU6lgkHpRRDLr4wfhKma+OImxorWccnAMBsebs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 2026-11-10 at 10:14 +0100, Christian Brauner wrote:
> fsg_lun_open() takes any regular file as the backing file of a LUN.
> The
> file-storage kthread then reads and writes it with kernel_read() and
> kernel_write() on behalf of the USB host. With a procfs or sysfs file
> behind a LUN the host gets to read and write kernel interfaces with
> kernel credentials. Refuse files on pseudo filesystems just like loop
> does.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0drivers/usb/gadget/function/storage_common.c | 5 +++++
> =C2=A01 file changed, 5 insertions(+)
>=20
> diff --git a/drivers/usb/gadget/function/storage_common.c
> b/drivers/usb/gadget/function/storage_common.c
> index 75831f2c7abe..83683ade20c2 100644
> --- a/drivers/usb/gadget/function/storage_common.c
> +++ b/drivers/usb/gadget/function/storage_common.c
> @@ -211,6 +211,11 @@ int fsg_lun_open(struct fsg_lun *curlun, const
> char *filename)
> =C2=A0		goto out;
> =C2=A0	}
> =C2=A0
> +	if (file_is_pseudo(filp)) {
> +		LINFO(curlun, "file on a pseudo filesystem: %s\n",
> filename);
> +		goto out;
> +	}
> +
> =C2=A0	/*
> =C2=A0	 * If we can't read the file, it's no good.
> =C2=A0	 * If we can't write the file, use it read-only.

