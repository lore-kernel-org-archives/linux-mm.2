Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EC5D60A3829
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 10:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=W6Ex/m/S
Received: by kanga.kvack.org (Postfix)
	id 084D36B0667; Fri, 13 Nov 2026 05:03:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 035E66B066B; Fri, 13 Nov 2026 05:03:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3F806B066C; Fri, 13 Nov 2026 05:03:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A7C516B0667
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:03:11 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3001EC05CB
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:03:11 +0000 (UTC)
X-FDA: 85429657782.27.F17452E
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3833C4000C
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:03:09 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b="W6Ex/m/S";
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of alex@amutable.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=alex@amutable.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794564189;
	b=BT0LEo3jLdUOqqYA8C0mG3Q1Am1hN+lbjLO8+b0tp4z/ywRaDoAic7pHrqQmG7mKhC9K5t
	DB3znEM/If+2oXEQk39w58vpb5GJOVv5W/OoMxjcfrr3IFhsC08TMshFGxRALDXt0HHJfs
	xs4EU8IfyI5PwxDQri3eTtYb+Ucv6Fk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794564189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SoW/gPie2WRRtXdhiV6ow6HDYwH4jtR4w1oiMzBwW74=;
	b=ue6YcjZ4qWV4Pfeal9nVnF/Pgj3Vz69kAJzMjT5ubwFr9T9h83cUj59NtrNzF9blfSvwKT
	TKoN2zb8eNCiCUjg9SczTtT6C+0lik4LKMpReTssYoORQo64PBkrtcQ7YXRRzlqOGYPrM3
	F98Ji5cn3chbkDR3A/w6I4wDYwQAcZ8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b="W6Ex/m/S";
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of alex@amutable.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=alex@amutable.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c4d427836e9so121393566b.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:03:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564188; x=1795168988; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=SoW/gPie2WRRtXdhiV6ow6HDYwH4jtR4w1oiMzBwW74=;
        b=W6Ex/m/SfuASKbysFETU8s0px2bRBSNGW9b8PRUxcHz+6WnHhhpXXoJ/NIrrGExMm3
         rc72UajGNQMxWaclU06TrOpc6JuNk9pLenoDNVwT3lrHi9EpdFuvwCAtS3LqzYMo7w3k
         +eRdlal5l8a7e745vdVhiZ8PNDIP+vNJB+KYKP2/TvRQsynPyF4l5hZ0CKvloSg3cLGO
         DduQqh1iW3c6pTQokqvAzOOCFxM+Ysv39gtnDnnvpB2V4Ge+RpCBe0ojuYPAMLfgT6bC
         2A2dELiwlbNokLq/Guc7gznVFNN8u6KQjkv/sF+bQmau0zPip8NYolWln4WDHDmieAL3
         uvlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564188; x=1795168988;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SoW/gPie2WRRtXdhiV6ow6HDYwH4jtR4w1oiMzBwW74=;
        b=aZBjiWUG+Ej+gLHvtMHf5BJFOyAbO7XlTIK61SBh7sQ0RIAfbXR7DuttgLJlydDL1F
         Xy15CFXPDwrmojebLFHQ0dT3fbm3+ZdNnHpitYbEIPFMLf40AuzRUqh5GhvsO9LG0P84
         zHN77fbq+FqTtR0nX/y283a+mPW1YXxhORhI2Pts0a7WjzXK/XxubZFZ6GrLjRdbxSaz
         bi7ZtlQeME11qf5ec3QnJkJTuGb7Aevzy7M5cD+bmU4baYiDMSoMlKeZzfqabKfh1ox/
         DYrmAC9ikY6d5sj9bhSz1RHdql1q3RnAtTflO7nwNWbGo6ikSC34BjtScrna/vNt1lL+
         w/bA==
X-Forwarded-Encrypted: i=1; AL+hErEBHSRxH6x3Tphk+L1OusuGsKcA2tgJu82PWLtIY4d5vqZhMJp6FeUEjEU6zDFS8fIIAkiJY6o7JQ==@kvack.org
X-Gm-Message-State: APuU4Z8GgBNKYuRhQixkPSJ3AYdymQjdiyqJs+I+Z5FNxyLg17UrnoU/
	gE6bRncsDgNwlqJQnTNQ9cY3ejuIbVEB/pNiDJg55r8EMgp855dPow0fHyPpVRrA/CMH
X-Gm-Gg: AYBFou2JXoAZfpxbOxefzdzRf/DjzG0y4LOyiKYuFjfKiv3oX4kMRqAl9FfTpdfZxAA
	sRXbI+BI0vSi+6qZ70NFm//U8rXlNjWe+yHmwloEw2xMVb5Yjg4z1KHfynMguTR135SxVISx9oN
	MEo1Ol3C4p08wXRDRojRAdfmYMI0wBkPft8sX6e0gQXGtSgaGLqPVdoSdb+X845sHfTp9cZyJ0D
	eKOC2abMrGP3B8p7XoVqT2cUUTne/t9mGZn4I6x0yxZ+E1G+dk/rCHDEutVujxu/GXH/qw2oPMg
	ZPFNSiMpf0SNyZBXKxATIGBnv8SdFSPOeLVMtUspw2JGYfcLCQ0TDWXoQ/J0jzBKI4okmqvscFV
	5lnbQJocw/OvPKJ6ODcKczEtRQtqJY+ziLObJG04VmnHvbCrMQzaZhEIchHutLlt4rdtw4BPxdC
	OPZ++eMyk1nSBkUXwBWCdn6ZqnIpC9NSV+1Jm7EjM1LkGHZowhwua3gX+X+x5jdNwLg6qSg0lSr
	FuBrHgmnPevNa/T3nY5GohgpG/0Tqcps6EkHqjuK+zYCQNi79jgVZE4Fvy5pHEAsv07RTRWIRvt
	myt5VJ+yHw00/T/LIN1Rg1eX8bR+tfvHP8ogpNvsQqCayQn9
X-Received: by 2002:a17:907:d12:b0:c4c:b4fe:c9e8 with SMTP id a640c23a62f3a-c50963dbee5mr161853166b.38.1794564187801;
        Fri, 13 Nov 2026 02:03:07 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b3dbaesm74933966b.32.2026.11.13.02.03.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:03:07 -0800 (PST)
Message-ID: <fffc4f7f87fd5f03d1ef409df76f71ddad552213.camel@amutable.com>
Subject: Re: [PATCH RFC 07/41] binfmt_misc: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:03:05 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-7-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-7-4c998976c6c7@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Queue-Id: 3833C4000C
X-Rspamd-Server: rspam12
X-Stat-Signature: 4so1gx565c7qknezyeuajoqjtcdu96wj
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1794564189-534639
X-HE-Meta: U2FsdGVkX19UQMwx/3rdqdywTl4DPsKZivWdtBTJf0rJTflLz8xlnBItdXIld/AxJrj3fX4Bhvr4jXKLV8BJYFriFt5fJLLxva6vFGnrRDaZyMBcbwENBW3Cd9MyjuAFLSVFUeekM7CykJJ7K1Xo7aYfJtFXl9FXO/YTwP+MpQIDEaKb4ZRuEOlxGt/5XOXZ0DsKOVtGwl5M4w9EEQXOgdZUUFqqTS7312KtzFzxTvOm699Euqrv1UDogIhjA5VKZ8KDnCIeU8XwOzVHH/WaaL6gvGiGtYG4EtSbNRD783vrYsKo6mKtR3oriuXbo5vo7LhBdpfkl56N8pZzuMrxej7S2vbMsNwEu7E14/Q8qThcphv7mS854CbyhnU2jtmsOdNC2nH1NZkKw1s2GszztxpZlcoLwvogjIxS11lhd6HGey5ambtGOghK5zue8Yb/cHPonHg0Ht329n0rb6oY5PYMbPZZHXHNX9C4ymwtclasDwNuqC0XC3pi7Lj0WvTwDc2kzSbwgIxHJ/HA839exiQFbZW1OcfpW1A890QiE2VD+lYHdwFJoRqA95rgUBNhBqnxdhMsQkFlbR0J3Z5THJh2if6+Zju4XWoErLEt3fc7Zbf10rjYHwd7Acu6oZsqQM45xrhATicHbPLZxRRE55FF0PXDHn8g9PRDeEW3M3c8RAttUFtmitKZ0SljHHLUP/EbfdMnh439JTSuRlSdkJVClgwk6HUgSl+5OcABgBVvpiM7k1SdOzC4xEkoLodSW36USuLT5vj0diRU61+Gszq941UtBlQkN2huLq+txbpXy2TWCY75DPLLPR6w3nHVJRa/VMVujE6/unwOdPhJ0pEI9rcOwbraoOShIqQimFVmFX9Yjwtz2OaQdHYsQxTJoxm+9FeY1UIQdQtrXcHuW6q048QMZBjss/jyY3pDgIwELEKDYrXlkLFQk9bvjSnx/lRvbwBwFLnn6cmFOp4
 Q9HypEo1
 SGUhqGo4O74V5JDFeeFcWqDCeaB4t6ML29csmjALqfXzfJPixcjyCTuwOZ1fRPk7PaN6bx5suZt/BU89R9vxtGUm7r+d1LvZaM4JGcNE5UCmfCr4LSPStuBwAruQJ30QUSbA4fqhuakdf6QWVjaNalB2qe8SvmDt6ybAanP3y0YUYxhNSBYnTcAjlVymWJlN/a3uU+3uAgVM6zSJikgC5kfQ0Qq3TtO/CyhsQyIoEip3eljCgE7OTUOyaQOdRWv9eYI63zz+5OgMHWVB4O755+DpVcNobq27aPyMLQSISucdD9fojuApYTVREwxnw8uOK2y8PXuyexiZS5Ej24CTUUTbuHVsYGFg6t+bHZ9gayB8yhllwzGdUavFhLbRPUScT2fWF30RhessCGTbCVT4FSbldxdNebhN5+xYPknftlGZ82lsf0Mlwy1uht56cKFblgltqYbYH/p9AYOnCr79O2S1YPzrZn7Ds5BT2PTV4WypNLskBDdjFiJL9xWnqq+w4MGlfRRVC8Doe5OMQ/ZdemE2we1cS6zTC58rUDKFYwqrmyWlAhCgwSBZESw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 2026-11-10 at 10:14 +0100, Christian Brauner wrote:
> Initialize binfmt_misc as a pseudo filesystem instead of raising
> SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/binfmt_misc.c | 5 +++--
> =C2=A01 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> index d945b4f6e158..7dc233becd98 100644
> --- a/fs/binfmt_misc.c
> +++ b/fs/binfmt_misc.c
> @@ -22,6 +22,7 @@
> =C2=A0#include <linux/file.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/init.h>
> =C2=A0#include <linux/kstrtox.h>
> =C2=A0#include <linux/limits.h>
> @@ -1575,8 +1576,7 @@ static int bm_fill_super(struct super_block
> *sb, struct fs_context *fc)
> =C2=A0	if (user_ns !=3D current_user_ns())
> =C2=A0		return -EINVAL;
> =C2=A0
> -	/* Never exec off this instance and never let anything stack
> on it. */
> -	sb->s_iflags |=3D SB_I_NOEXEC | SB_I_NODEV;
> +	/* Never let anything stack on this instance. */
> =C2=A0	sb->s_stack_depth =3D FILESYSTEM_MAX_STACK_DEPTH;
> =C2=A0
> =C2=A0	/*
> @@ -1660,6 +1660,7 @@ static void bm_kill_sb(struct super_block *sb)
> =C2=A0
> =C2=A0static int bm_init_fs_context(struct fs_context *fc)
> =C2=A0{
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &bm_context_ops;
> =C2=A0	return 0;
> =C2=A0}

