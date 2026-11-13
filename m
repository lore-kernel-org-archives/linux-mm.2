Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67336606A896
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 10:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Sir4LMw/
Received: by kanga.kvack.org (Postfix)
	id 3A5F86B068E; Fri, 13 Nov 2026 05:13:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37D266B0690; Fri, 13 Nov 2026 05:13:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2925B6B0691; Fri, 13 Nov 2026 05:13:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 06C686B068E
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:13:29 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 77D05120630
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:13:29 +0000 (UTC)
X-FDA: 85429683738.07.E20560A
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9AE88A0002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:13:27 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b="Sir4LMw/";
	spf=pass (imf15.hostedemail.com: domain of alex@amutable.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794564807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UX3uQO58FXw3i2m3kzI3o8uINYIcsljrdUAfEKBly4o=;
	b=CtCU/xZHRZJFnxwLRqrJMLhB2SxmRFlMWNvEFo+7/Mr4qugJWLRCG2Slza0EbuVe2LsPRE
	stVdURoUST6REJeuoDaNDaJ750yFQJeeoehTu6Kb2zJbFpSoiZR5LxRq1ahPFZWgTu9hkO
	wfMwTRTfpOJJlDc4D+e8g7QMX+kIfBs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794564807;
	b=4fK+7YtFZEMktaGod4ESKVLiJCGH155j2atgFsPmSM4dY09i9iMgVQiOTIXOUZi+XNCjWv
	bMgR4fzTsOkgR0RY8yhcpbQEWTqbefoVeEIYNrAgUq42SOIYyQ1GPy9gCm1s+1YOHxmV3C
	V5hfsmtrs8u54gP/LQ0Pu7AniYNnoWw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b="Sir4LMw/";
	spf=pass (imf15.hostedemail.com: domain of alex@amutable.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a1b07c3c5fso10630855e9.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:13:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564806; x=1795169606; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=UX3uQO58FXw3i2m3kzI3o8uINYIcsljrdUAfEKBly4o=;
        b=Sir4LMw/NQ6fET073yir7AD19GztSrs5kXeIWeHWcUE4u+rnJ2HRwhducz5EiguuTX
         DYn2giDMr78wfCjdni3vl9z0TgAV4Ri2kaJu3UdeNWAGQ/aNNmNjD1vHHC5cdj9pUwUY
         /tlgTPfUDpr4lubFXhR4w5a2wMeBUBgPDSEa9IDghdS8Uqr7p9NOpVN8qPicTwamgdzw
         yPDySZtc691UONeoBfq9bxVXJ3z/kj3SeX2jsk1rxk5h0o6CMbslHmI9MxJ7nVbPKya2
         9RYa5wtCU4MXnGB/zuJwDpdDxbAmjCvlrrVjndFF1bWGDja1OrKc796K29HfmvHcuZiP
         U9tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564806; x=1795169606;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UX3uQO58FXw3i2m3kzI3o8uINYIcsljrdUAfEKBly4o=;
        b=QKCpfaQW7AWQw4QgHCRcJIK0TCCI1HYeKDOtIgA2j24Ge4K6rhczIAEy4m9VU+DAl9
         5vr1BCbqRWNxLFHl+2f71ZIXp1Y73l/EPUpO8eNR9ccGBZTx2h3D8oCbpiy1Qzr/fZiP
         P3Y0glKmG7gh+tVopetwKY5PES+h/r/nU6+vbTBYnDfnobvVS+C3DbMJmTsbaa0z7UUf
         lomMlx4CMMGDgxwV0JRyF4kGs9QhQoTn4EwHiQuW6SqD6dmM5qgHuVVk8v/0NN1Fdp29
         R6//BbIhhIbWQsdaeHTNZKohY1iKsYZuhP5mVXPgFw8pvZqXIVXX0szyRe/ePUBIqKve
         7lZg==
X-Forwarded-Encrypted: i=1; AL+hErHgWZQyd3PfOru1E9h2wqe4jtda2k1QeVxVwJwt+XIgysHFqssYpgZfgjLubKcamSCFBF1ada7R+w==@kvack.org
X-Gm-Message-State: APuU4Z8spmL6jNyHkKbvar1uYbixtC8kE0wWBKYjweF1s5l445UM+Xyn
	o/fIvYbYgWHtczxicX1eYHh1lpeioC5w8n/e8O9SNCCfL1nGhCAoTQGyaqFwon6bTdlt
X-Gm-Gg: AYBFou3WPP+COMLDnMW+pV52o7XBY/bfVkEsOJUQrMVIyPjuUH4PUx5HCfqPrmXZ5BP
	nc1P48RLdQ4oH/HsG95Etc3yIHncxezjZ49NRtlfLFMe71hb1LTL5lXCGA4HClxNkao4LwQILd0
	9uYDoG1ZCAVJuw3obTHBFxKKh8cr9QqHdyV//WeoxQzBZgqxmmT9mnrAwCQGVOzg2Gg8WTwxoM0
	1F0Z/sflBMOsKKpFgZxr1S1fEF8EIFF7u9AJ3tr/gJUhlL5SsG3rgECRMgY+HSAUzIutwZ1NJXT
	MUGGK/uCQTjH1jVyuHsnPA2vKMsT2p6Zj4pSGS36Ciku1u35/ECWUieC1CXdVIQQJZSWKpGS4Tb
	mGnjo9AsHFEvvVFchDcsdn4XzNp96ZdEHwTfWrX9+7kx4QBpBSGaQwTfczrOIi+hhXaKoPQEayo
	4WDgpmVtOyy+qRMMcR5wqhM1ykWWxlHs+4gdA0/OmjjSX//wlm8S3XgR2+0MgeWfcOIMdWqtWwE
	D7mJf3i8Au5Q8Y+1MlhrPKT6Mmb3pUEZDMzLVsiKij3PnD0TV9MVDfAqR5dGu7XtUruE84rpnNz
	WvcfmKXKYmjmZnMo6D/FVanleZlqok2hlRk0SJlS0Tbd2zE+IU14MpA/sZwlFxE=
X-Received: by 2002:a05:600c:45d4:b0:4a0:23f:8b0d with SMTP id 5b1f17b1804b1-4bb559f6f31mr43583035e9.2.1794564806374;
        Fri, 13 Nov 2026 02:13:26 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c609c8a77sm4362275f8f.49.2026.11.13.02.13.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:13:26 -0800 (PST)
Message-ID: <23edc29c421f5d4c1103004f79e104e9f94d42c2.camel@amutable.com>
Subject: Re: [PATCH RFC 23/41] fuse: use fc_init_pseudo() for fusectl
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
Date: Fri, 13 Nov 2026 11:13:24 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-23-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-23-4c998976c6c7@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9AE88A0002
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: cmcoq89ny39ck4drmg46czzo9ywcfdwu
X-Rspam-User: 
X-HE-Tag: 1794564807-767295
X-HE-Meta: U2FsdGVkX1+5dBrvm56D+UGxMF7s26hMhTa8lahQ+vpPXyx/Gu2TSii2U+KeRRP8DglDDc31/4kW7Tfk1cCIz6YHztUlJOKrIgo3Xg/5P7X92sY+HGcgLvkqstvxwou9WYRvpLPrarb+9OtgRNSbn+jQt1D4g7SjtE4La5j9VV069A1s+VTqXs/ZON1KPI9slS6pXCxaKTaKZRWQrmxjBZ7SK77dfFjrxPX+uiSCQFG8GJz5ZQsGV5h4xXu9DMplD3nMECrqUo/2NgQ5D+QqzUp6AeTHpnPPgkHhKtGpXqUOm525Y0cLwG39Mckh8gyk/l6tQCCYQtpv8wxzLa4pzOMOxk2GhvCo03fkbuGMOefp2eRr1i+moDyur1YU1gaUhh+XGmGsC5ezi7Ndc+xHdtV0ifZaubXyQbnN2E9MIqvKRk1RP+mBfTZ7FwY4LPaNmr0I9m32BYg5rIrwjL8RdFgGsOjUFw01N5D7EYKB/y92PgQOGsPUIwE/v0OTuMw2MlX6wJMx4uG0Rz0LBFWphq9uLla7Ogna9h1Jl66F240m5U+1nwijH7t21MFdOsrReUcGRPo1VOemN8hZp7TAIFNy1xxmnONqWmKZvOzlVfqbERl3S7JiD26b1wFoyxzbJchxh+Qkv4Wdol2ojXL9OB2t0l0D6pM5KLK2MKGk33hZHWwDztVudRTvCCp9P0XEu8ts/hYWKV3NLZBzUcPXac8N7E4ZLjczjYepEMrYCu4EGFofVO53UMHTRIVAS1mUN4hDBykjWhXUOxKyZIx2Zv77ROLAXMO6sMUvqsRzMCJG2aVEO1XZKHbPngPTbx0Qz+V3nKSCISbs9OjDlbW8p4G+28Y1vS+izsXn0vjnacN6o5JYXpsCMMtPr+RuTUmv5lZ8mbB0UEPnWcSe6Rjh6LTC/TEGS0cjx27lk3VCTFIJW7wAYBIKNq/iZHOTa+VR2B/ondWGJGnzNM/vYa4
 MOLRdPKb
 1cuhoB68K+sW+rgYkKROYMj5VthLaa75tCiYcEVsMDVL6muGpXPmJQ7X+BYePlG5PDS6nPZ3q2D7hjGVPz/kgVjvGmzlTgKjO8mgTyAMMKPV1VOT6wW8I30amCy8igsgJF0LVF94SKv4Q7N2RBVwcvjLXTe5htiVwqlcGNM6bD6Hu6fA5xw4LBHd1UwMrIkGaTJXXSYVbdzoK7+d9KsPi9GyzJP25ZPWac0jpSU+twin5d9wRjYQC3CZBbLklClwch06NBwbS8Ewb9CWMKUXIiZLPTCre6fmo4xlgHV5VcqxQylMJXxtkLz4p8h3RqtJBZBoe1Sv5PSq+JQa7iUpKtPEEb3ZO5kLa1dHUYhSqUjcZ5HQt7eOtaGEWSVimFwVZ+a3a9SIZj61SmqaA7Q7OYC8LmiP3E37LdhhqtO7J894s5AHfzq06dL+mKbaHiHbn5I5BWMaVqOTwGsewk4rMsYY//E2cMYOSj2wkSC+7Mmyh7b4uCg6m6yopTg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 2026-11-10 at 10:14 +0100, Christian Brauner wrote:
> Initialize fusectl as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. fusectl never holds executables or
> device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/fuse/control.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/fuse/control.c b/fs/fuse/control.c
> index 21ffde596d61..4497362e7df0 100644
> --- a/fs/fuse/control.c
> +++ b/fs/fuse/control.c
> @@ -10,6 +10,7 @@
> =C2=A0#include <linux/init.h>
> =C2=A0#include <linux/module.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/namei.h>
> =C2=A0
> =C2=A0#define FUSE_CTL_SUPER_MAGIC 0x65735543
> @@ -334,6 +335,7 @@ static const struct fs_context_operations
> fuse_ctl_context_ops =3D {
> =C2=A0
> =C2=A0static int fuse_ctl_init_fs_context(struct fs_context *fsc)
> =C2=A0{
> +	fc_init_pseudo(fsc);
> =C2=A0	fsc->ops =3D &fuse_ctl_context_ops;
> =C2=A0	return 0;
> =C2=A0}

