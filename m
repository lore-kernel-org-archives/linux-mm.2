Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 384B660A3825
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 10:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=PwMc/RTs
Received: by kanga.kvack.org (Postfix)
	id 3215B6B0681; Fri, 13 Nov 2026 05:06:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D26C6B0682; Fri, 13 Nov 2026 05:06:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E8EF6B0683; Fri, 13 Nov 2026 05:06:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EC5476B0681
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:06:04 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 80CEF1402AD
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:06:04 +0000 (UTC)
X-FDA: 85429665048.01.AE57C6F
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf04.hostedemail.com (Postfix) with ESMTP id B349640009
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:06:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b="PwMc/RTs";
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of alex@amutable.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=alex@amutable.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794564362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TjkCmA8zoLhZK8u7U4HhR7QcElVzore/o+jClE5BdRs=;
	b=YnPHYhLKROeqkGfobQbwgiqdufEoUIEIepFHDwmEffWHJRSRSZOGaA+I8c0b7ZqWeTE1q8
	YJvQ0rkf3lmAK3wEvYhxW9NEPdfxzEPOT2OTVy5Phau3erk2CPfWVuS3ELqBiD6EAGW0J3
	ustypDUNdSwp1tqQc9FgoVakJtDfaaI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b="PwMc/RTs";
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of alex@amutable.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=alex@amutable.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794564362;
	b=lyp6/9mY1o/XtpzLl0as9XK60kTqjBc5AuxiQLziMYNiZxlXTkqk+Dx1YOfcDuL03GxIh0
	dmmu26a3GA2iekj0Z4YCqPDnJ23duobztXJGQnwkMLFXe/HnlDjI191wldZ5l37/PPBW4q
	eoEmjj9AOqIByGbaZwHyko7FbMmaU9E=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c4d581da0aaso117997566b.2
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:06:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564361; x=1795169161; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=TjkCmA8zoLhZK8u7U4HhR7QcElVzore/o+jClE5BdRs=;
        b=PwMc/RTsYQVghe39qTvTAXeHCvTmXI79X7CXHiZetkFb3pesQaDtY1ZOaztoIlFhp8
         lHHiSefzyqo5+VIdCU+ihNhFwfh3fNnbOU0VQ9OOBTACPN0nhOk3JQ751nV9wEZ5EE7V
         NC9uW7OMS/sJQPfkcvpU0K8/xI7miYpDLei/JChWlDwRsV8c+EqLNrUuOnIWieH2JNlQ
         n1gsIDkI6HyZMeMc6HDM7aaAr9mwPPAgHJKeDOfvxUACkF7BXSz+HMGFpPYNznetpfRp
         kCD4OzoydpqDLAPKM5J6wHtQLyY+eiu3NNiiwMbKtGluFuCNM63rsMv2kF99H0nh5LXa
         AwfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564361; x=1795169161;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TjkCmA8zoLhZK8u7U4HhR7QcElVzore/o+jClE5BdRs=;
        b=yZuRTOdKWwKePEbOBWHnZhu9P6wezV6ke5HgDrxWzsF/SY/k+H8/ydEX8lyZKZKlHd
         k6UrHlC/szEZ5GhMXXN7KUbDqELNrDOho/8waLpc7D+9bJ7s65ZNfXTm2dqjAy9k34Y7
         9vLh+4gA5xa4nEXNCRDTOZKebxNBzWHtitO5YnaUPnJy1b55UaI1toQ+6uwalA1Ngk61
         omwuNy3rF15Xz0PD4ZM3QFnbI5ATmuFkq/Lrbit8KRluFE69wg5GGcg9A91gFQZ6PrJ4
         skDKAe2/HiE12yixHl6RrEJlOZQACLWALrO2S6qShWtjikEc+WTFAA8PpwBCetOFo3pO
         KFdA==
X-Forwarded-Encrypted: i=1; AL+hErH7+XoMK2dqt6LxvlueCz2l3jJ8flqSiAF0eovXPRQUGO2jTL/30+3akgbMST5IdOVvYwDDtJKUGA==@kvack.org
X-Gm-Message-State: APuU4Z+qla7FK5IS9G/UT7816+3SUk1UHI0ePGoon5/vCnVwXAx+XIAY
	ZGNMHJ/ouxqCPmpW1Jxrj2Dg7lhi+x3BwJ+ZkRGFnfQ6F+zW0r1mw9BLseV81cb8PfxF
X-Gm-Gg: AYBFou2kXKj3XhXqZxXfwDILnkpoy/F/l+UKKEQUGtagxjIR3QwF+Z/TkTLX/nHhAMH
	woLQ/tKOaTlMdkMXQf3vG5fcdEwXZuxoN5ZaAaXB/6X/Buq7u8rMxQwa0BgbCOAdqyy2k7tRfKY
	EWlw3qFB0axs45yj2oGqO6qiIK7uY2+cWxyZ8Apg9qaCas4bZB2r++/LUOHLjyNJpMDn41DjrNM
	mWMJvftR9sHdO3VLTtwsa1sc8S5zLjN1YbbtUpL0Hb/GIMvnoYRTrqUGBTeIqew+ULDbJMii6k3
	KhR6C71R2/L1p6xs/0/1dmZp4WV93AkU+s1AdUa99QFL8fWRvPhyj98rwIXBv7vbt1AisKdIYJ6
	Hp2e0WSMpcIq43IqBI/gPXDC8g96xPQhsvUAXsBk4a1Sk1r1QGpf/pUmHN4/poVaiJZRSLwV4Ee
	ZQC63dp4uUsHU9RZjfG4qBH3PANvliD7Pnt4l4slF6tKwNrRCQYtoqqTvY0okoyhokFLxOpAQ8w
	t5aAc+fCMKOuqrf1f3NkBgFv5VKwZ0v4JD9sB3GdHUn+cvi6Eph6MfUC+qeYVJXK6NgaD/qSDdz
	+N/jg49HgzM+k4fsNjDbH79mJzfaMxIhW275G2vDYwpZMuenUUyadqNyvnpQr2E=
X-Received: by 2002:a17:906:ef07:b0:c4d:5820:325a with SMTP id a640c23a62f3a-c50963dc627mr169588066b.39.1794564361325;
        Fri, 13 Nov 2026 02:06:01 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b8651bsm73693366b.78.2026.11.13.02.05.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:06:01 -0800 (PST)
Message-ID: <e8b71a2778d7d7797d433e7bac1a37ee64aaa30c.camel@amutable.com>
Subject: Re: [PATCH RFC 15/41] tracefs: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:05:59 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-15-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-15-4c998976c6c7@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B349640009
X-Stat-Signature: 5pfbg388ccf3jwdgmrp3i45wg4tctfx4
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794564362-528767
X-HE-Meta: U2FsdGVkX1+vfc7hdhqVdgIEiar+QGNHo29Rz6fj2yn53cG9EAvGIh4ewnRjvPBm2eer6s85ANV5CNJlCl/cFRaNHix4dMCDGE9g/3qFTk2yo37y3f6mX0rjUJYr8MgFk8d7gHeJ57uRu/z62z4g+PB3H4RX4RU3mcZw0aXI39ZcsJ62qMZYxrGA0HPo7+ESPq1NX9rsvU7/HSU9Rhi4XTvlenR22B+sGlRJemLxXDBzor+lF44tTgcC7AmP1ioopJ3U6ExT2b8rtj04nzcgJaFix2aLZyjB0J8QlNPo2IkqBqpKkOvZbEZhNmskdClN0zW7QppZusRDuOJtxYPxkgrF/ovrtlxw2m5ILO3NJMPT812IcUe0wfYIv1cVMPhmbEx4TmtPHYosGOqriNZXJzfUjMrGndj3qbbd12pSwaxRybtEZJzLFBN2UJpFWEQMjci1OA2O88swDNHiCFLDqKMuWh9sxPaXuihZ/hoPE6q2SvjMgjjLO+HRfaLhNL11gwX5PUjVt6pdiP6zQccavaHo1YABNSiDlTlgHlxTBMI3bWqRVAgNzq+zRbYPL+SX0epVvXbSxzulQ4iNMk5kzwdWiaKQW8fMj8FXXYnyVhvG3FTCDYQlEfyOWa+ozszsHHV0sSEyKk8w5lCnsHyPwzz7FrKrNrrsv6pApO35Z4aM9GjRSaPAUPEBeoO4Ydvldj9URvpeKKuCSFsSlpqu6j0jmKP3bhCw6HHyK4Vcki7mdtqACUWC8rgmVPnTjgk/7gH7+JHYnXRF7tZtrHnirTKdXOtl+HPMHVGL796nzw6xX2JdvSoqlzvQb3j7JutKmuIq3qkN+jo9bUxBu1vm1x7MerNpmTuocbB6/evLbhS3vx1iFDY3pCNd8JVuEs4vFrDm967wl913UMyteP7MzzTFRVcDNipUKpfK25QaQgQl1zl/FrPWhQrcvSf5lGptWjgu/vJbLT+/bfX9vKh
 +BozqPIC
 FKt8+/35qrHP6yzuyAHrY2IjZkvhWtliAkE8fX0vJHYVlwbf8vcI1e6wiuro4Fd6lBj2NXY+aCdEUQOzrEQU7bkF9d5J1mUD3wZ2DKjeGbyjfgcdwwcIAkPdhyma3jGlimtEr06fAdAVxWXCEd3+CFeEz84aeQucLSYf/9RIAygyuGr9WHnXnsnmY3vVnyUWtq0OHw+9wvKJyEZehBK9f6PEf90bN1e7qgBBOERih1wC1Y/JtPl+eBE8KnE+fFzKX3Wo4Kqt4qhGDpSfZCYsRAXNTXTtHN9VpkAoD/smgBE0qkCgd27lBhjHdwB4EFZL7sqVoVnJZjglnm5DaaZQyWScDBtCe0dsB6UoF7EWF7uYPeZu6jF7u+Il3bh1g3otlnTNoncfz8DTRPIADT7ObrS6GdF1/L4AQOLxk4BUnLQ/UCyiBVGUpeh+4y+rKnqCeyO//8K4r2rdRpL7pxONHfCthgO0ondD+fl9aI9LHTHCoSwcWeDjMJs9GbQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 2026-11-10 at 10:14 +0100, Christian Brauner wrote:
> Initialize tracefs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. tracefs never holds executables or
> device nodes.
>=20
> SB_I_NOEXEC also refuses PROT_EXEC mappings. The only tracefs files
> that can be mapped are the ring buffers and __rb_map_vma() refuses
> VM_EXEC already.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/tracefs/inode.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/tracefs/inode.c b/fs/tracefs/inode.c
> index 5020365ca704..e04febd868eb 100644
> --- a/fs/tracefs/inode.c
> +++ b/fs/tracefs/inode.c
> @@ -12,6 +12,7 @@
> =C2=A0#include <linux/module.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/fs_parser.h>
> =C2=A0#include <linux/kobject.h>
> =C2=A0#include <linux/namei.h>
> @@ -510,6 +511,7 @@ static int tracefs_init_fs_context(struct
> fs_context *fc)
> =C2=A0	fsi->mode =3D TRACEFS_DEFAULT_MODE;
> =C2=A0
> =C2=A0	fc->s_fs_info =3D fsi;
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &tracefs_context_ops;
> =C2=A0	return 0;
> =C2=A0}

