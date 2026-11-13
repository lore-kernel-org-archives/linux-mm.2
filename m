Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EDD2606A339
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 10:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=tpugeP9d
Received: by kanga.kvack.org (Postfix)
	id 15A7A6B068D; Fri, 13 Nov 2026 05:13:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1322D6B068E; Fri, 13 Nov 2026 05:13:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 047646B068F; Fri, 13 Nov 2026 05:13:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D0F2E6B068D
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:13:06 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2B207120637
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:13:06 +0000 (UTC)
X-FDA: 85429682772.10.276949C
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4871C20007
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:13:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=tpugeP9d;
	spf=pass (imf03.hostedemail.com: domain of alex@amutable.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794564784;
	b=AcixS5Re5ZRuftS5jD1OitPQ0FiZb+SWEX9adx6wSzzaFzzOJvbtxHG0flKTzy5aJ/cBQg
	7JT51C5pnZtcmF7ZhPnD8gbaa4/5tYvkj2eCz8aIdp9RDP/6Q7LATyLWKlq0QOthYs5JfH
	kSz1fJF14ubIQI9UF6D0yw7e2hzQPtU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=tpugeP9d;
	spf=pass (imf03.hostedemail.com: domain of alex@amutable.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794564784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PGZ86VpI4/X6bkLIqgY54HnsW6MSps296zHbeFwxlLU=;
	b=Gq30/K0YVBtQvSYsaKmjnAJbqmOS20wSSsgL6Du5B8athxBycHOQpLl7VjEucigycE8qfB
	X/0DvDVvSDwtfG7UyejqoV+wnbPepcjjRWr8g5gl+nXhwfdyOw1tEXd+gyFL7BzS/aZRkc
	8hpsXDspNxkE3wAokUfqoofvyhn4mr4=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a1fbd52ab6so8045485e9.0
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:13:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564783; x=1795169583; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=PGZ86VpI4/X6bkLIqgY54HnsW6MSps296zHbeFwxlLU=;
        b=tpugeP9dQsD3JldPLT4jOKJElNae6xiVDXW8CyigPkg+LZ/aIEyJAOWBQDD/1Y12fi
         geidMhexhFGUVoKLxt1mIo2E6H3XmAUKml1WU+fa6pGQBQHrYn1VZ8EmIknE4iODMeEM
         2owFtVXYSlYFg9Tyt243T6QzYZYvkJDw1169MGmPBckAUEyx/zcFcCx8H3/q0/89wDYB
         et+AIa3aOnyATnu9a2K89pdDtzq6jsjEFJHGHoPXHRCiUuS9KvowME5hy5Z/01YpxchZ
         qy2sqFj2gen1RYKrOoEQV+DjHfiPNEdWoU42yuMxLMwoyJXtRsyvRvG5T6lSqbwmS4/L
         GYQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564783; x=1795169583;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PGZ86VpI4/X6bkLIqgY54HnsW6MSps296zHbeFwxlLU=;
        b=T6cbJXz443+qWK67La6KNckyBdbZnYv8LvEK4EmNnS2FZPZrhZSfYmNHX6KFkCzH/v
         pAAA1D7GoEIHCa2P/83DqpnQzidG4NwpgynYlU+bSXSFh9JAhxir89l/5Rk402fsv26p
         6ZQsRSH2D7EtwuUJy/3CcgC96wwepPCXEcKRHeFU9Kzi76eqyAhpbCPxXAfgSu/9aCb+
         qfxaetufGyfrdTZefkxxdvV65qiUT8foitZzrTWRe5XyXGxYkyBqI3pX/a4T60qjiVvI
         3lr6zR2LiRPkj3pqSiL7cOu+WYNCSxR+Oz87ObGjehT7hyZk0Wbc80MWdj0KXSnsc+JA
         UGrg==
X-Forwarded-Encrypted: i=1; AL+hErHu3ffQ7pF+szKa1KK1q5068SF/poUSNng3KGFxEljVNdiJyPKq8dur9IXk4sbcOycls6pT4dacMg==@kvack.org
X-Gm-Message-State: APuU4Z+uKIb8xDoW0sVV42EOpC8uOqwUo154bbyQHk0ZtxpGWd1DDk2E
	dn0b51+EbTNUAWthO7vrucr1t4hbuShlIX0raPKBL4XoeAwvyJ2Yblf6H75hdF0AJHlv
X-Gm-Gg: AYBFou3pLm4RGyw7xbqRepFxf3pyfGd4HpK9XUN1UuW1Vk08aWN8IJ7m8FL5SiGjail
	GdGJVoIib5vRqdZs+KRyPoc84jpBjBwxvLE/F7avC4LVEjsW3yvBJQB/M5K1AZ445zNYe1WuS74
	KO+AFb7mxPuFv+98l87exr4sUQ5EB7ciIBpVkNhKUR/Pgf6ORoMQ08LR/6AIuvxbIZmImjRgyeK
	uI0bCEqFVUxKF7MCAukjS/AnI0IlMGDOnLXYSRCTuLEbYERQSAA2xRrTU+u07VoA6FNKk/dMWUp
	yiQYHt32Wl5dm/musVKBfTW0oLLzU/yNPUmvv8DVFZqwbsBT4sZZakPIghpuO1aRBtAFdihKTGo
	49timaynl+WyP4wFatfIq+eejcYR2l6mU8oi1rLECb1vg3q7MavUL48aX8VJY6SqPLYdhRkaXld
	7G5mst05/hUQKb+lD2YofQ9sy8jfIXyeApRLpO5R4YZx5+MVP+HDeDmnqARuAeX7c1lozBS+Th+
	s6QXUyYXzFNS6QFbeRSQM/J9Wq9wEuVwoypHQj9IDjbQgaBqYhmd7oEwrdmbJLJnSLq1wGzeWow
	On7NGZLNReKe02Ccn/uvfgNauFEY5OG5Nby6VJHRkqSQ7+y2RqlLiFw8/mwpkph0
X-Received: by 2002:a05:600c:4f90:b0:4b7:6c16:7b43 with SMTP id 5b1f17b1804b1-4bb55a47602mr36814615e9.10.1794564782834;
        Fri, 13 Nov 2026 02:13:02 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb5d2872edsm4056955e9.12.2026.11.13.02.13.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:13:02 -0800 (PST)
Message-ID: <94dfa5ec75f4479663dd79f3ce05c1dc6c080185.camel@amutable.com>
Subject: Re: [PATCH RFC 22/41] sunrpc: use fc_init_pseudo() for rpc_pipefs
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
Date: Fri, 13 Nov 2026 11:13:00 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-22-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-22-4c998976c6c7@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4871C20007
X-Stat-Signature: 6kb6yj796trajhiwpn1fqjuh6yazcfk9
X-Rspam-User: 
X-HE-Tag: 1794564784-723374
X-HE-Meta: U2FsdGVkX1+1fyLIw8Y505el/7nlimSjGvTjBsWiQmKXPiAQd0LnR9fOdRRf0MRBXZE1WcadnZy7iX34aV35oParbvr8aqURaGcCL22M6JjvZ9Zvb3n12JmJMmCmTYdZGz1O9UL9qfr1O+x35UGy++ecQCW68vu5xTk/kf/6DFjEFMq74gdV4tm7h1ePbpIN1IUNMWJyBESskFYclRZV95OtT7lUqIxiXrnjCm5VPxgBDgQ/oXUbGSxfUSNCH5Eg5l8DmYPTp8Gn4ZuLiYGvDsd2QBBWBEzD8ZP++sCiiKwlvmVIumnweo1x8G9SogG5SY2I8adR7WTNDPuasRAZ+jzP/JiqAgFAKzMLQH11r9Uez66eu4i63GIOQM2vIOfC/aUEjLqYgMWi9Dqobts+ajJh9zJH9Su2QOGRn/up31lY7PWKKaKx+N63amaPzhFZp9ZHMWSrAExkoEHHzg55cfDrvzYP85N+0H1wRN0MWQrt5Y2c6srSawtInULDiIo/7/7KNjRYUkM/gNE1MuQBEkQ16WFmf0EY6gCCcQc90eGwLDcQvNVP7ppO0bWcM1sp6X/pug7ClGpZDpBvotIadGJNChs6T/y7Gv3pWxd8Nw1j1Pi1k5zEhzzrMUhmqOtpsE6iddXOv2+lIqRtpw+y0GhKL1eOvLdVGPrii+o/xDlS3kkGAJjfL33ZDIKOqGL6u/I5hicilCJIhn85wyKmZ5Q5sdMG8/sAWOd9P2uDiRfGQxwpMKSKuWzxw1FQs6z1sV0GaXmeWjKu1Ki0/JtTnRcx6BIpe4q5AYf5gLnVr2Me6sy6nKN+/LCySe+pywCiXQuXli/6fLxn0qm9w++6KAw/RQNtLMn39zejtvEYrhInNJ7Atq3gIz0h3iiQPWBdWeKS1mVB821eHXrG6BA3xk+81xmxMYq9qgF8kfzM4MJSSmaOITIRN7RCrSJtvW2YNrUvKLqsNIkzlKhJiL6
 vAq8M9jY
 2viRmb5TL8Qf/pbabYNcGi+09JU0Nr4sxxfFFCkVjCN7vtbm8vbqZon+LfETavVeXexkSQrybz/X+qYaTT/bJTEV1FK/IXhEC9wLOBwDJES65nVZejP3wLAizqMOExPXuXkWM+OU8lvoejnXB7s+xsAMMHhwDmf4KXcJV9q75vRZ2D8iKULv82QijSHs2p4U45AtAYsJaXLE1FIcCV9adwEv2B3f2ZbVuRinba8OxhkKEyNVrsIUqqdjNBWP5vbkAopY6LZRowVoVdLL7FwnUzUlXJP1Ou4LgvoCQNKhLqoE33QLq5ylO6gWd5AmRotd4qqEgZdL/D47Fur1rZ+KJzfHQbaWljmQ4i179f2nBM39TPF7hBK62AINWB1k0/QM3FlLbmfKmRSMBvG7P+N/tcA2XIhr86EvXGExNwKxFiWrWSImMwPea3J2Mdltu1uwxmcAQNNGLjPgwNW/V7+2hWSgA6S7NouRAUAEXu0wG38zGG9J05PKdMlST4Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 2026-11-10 at 10:14 +0100, Christian Brauner wrote:
> Initialize rpc_pipefs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. rpc_pipefs never holds executables
> or
> device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0net/sunrpc/rpc_pipe.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/net/sunrpc/rpc_pipe.c b/net/sunrpc/rpc_pipe.c
> index 9d349cfbc483..37277a6d2415 100644
> --- a/net/sunrpc/rpc_pipe.c
> +++ b/net/sunrpc/rpc_pipe.c
> @@ -15,6 +15,7 @@
> =C2=A0#include <linux/pagemap.h>
> =C2=A0#include <linux/mount.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/namei.h>
> =C2=A0#include <linux/fsnotify.h>
> =C2=A0#include <linux/kernel.h>
> @@ -1181,6 +1182,7 @@ static int rpc_init_fs_context(struct
> fs_context *fc)
> =C2=A0{
> =C2=A0	put_user_ns(fc->user_ns);
> =C2=A0	fc->user_ns =3D get_user_ns(fc->net_ns->user_ns);
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &rpc_fs_context_ops;
> =C2=A0	return 0;
> =C2=A0}

