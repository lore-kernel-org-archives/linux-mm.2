Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0601B60A5BD5
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 10:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=cZRPptm5
Received: by kanga.kvack.org (Postfix)
	id 0ACD56B066B; Fri, 13 Nov 2026 05:03:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05C7A6B0670; Fri, 13 Nov 2026 05:03:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8D7B6B0673; Fri, 13 Nov 2026 05:03:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BB4646B066B
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:03:27 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5E9D11A01B8
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:03:27 +0000 (UTC)
X-FDA: 85429658454.08.F72A07C
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf31.hostedemail.com (Postfix) with ESMTP id 823502000A
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:03:25 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=cZRPptm5;
	spf=pass (imf31.hostedemail.com: domain of alex@amutable.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794564205;
	b=2ysD7uRC+BI78CYwyOi9oYK6UmxCNL4NZlIQ7wcKRYGHCbeenDNhe2Z41NODoUZs5nglF3
	lI4npPfryCtyUs/izdRbI8Zw+32HWCYXxJriseMkxPoKP575I4odmt/24VZ9JPZb3pQbgv
	ZOiLkxNuBuN3xbFQ/rVAgJh6x6x5Zn0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=cZRPptm5;
	spf=pass (imf31.hostedemail.com: domain of alex@amutable.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794564205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yP9dZgkD4P/bNBFnmHOgKVBIpz9VJZUP73dl9853V04=;
	b=0Dtx1LcbMeRV8S/fU5wl+C0WdRKM8DvNY5un+SiZXt1o087DJRcjycIprp6OdiMRTB2POT
	hcTn0r15vk7IHrEOZCRTIWFO8lLjlEVtyBPWpgNUePYGsXoZHqt5t6aRw8rE/V0ML5+rz6
	Z5UkM0DPSQrA1VIPjJE7klzn9YLKozY=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6b75712fb57so1193801a12.2
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:03:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564204; x=1795169004; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=yP9dZgkD4P/bNBFnmHOgKVBIpz9VJZUP73dl9853V04=;
        b=cZRPptm5w4/5ljRY9uL4d9x2/eNZUGR5osShJ9p62oXgmix0spp93p3w6Tyl00kDAF
         O3INSrON3wVdi3yP46WKhHKZu3VcR3b8ZZ4mi6yPLfBS/K9+VL2K83uncxdoGQyhLfTA
         1WTJTxagbGFcRYChR4c6gAX22Bf2RYfhM31RybO3KoluvZzxHWuOUCMIYWy2EL+cWdpk
         SFVzGKtQ9axmwlqt1AUEUQvOprYbt+4q580YnxlQfHYda3L1jsQERKw0t4YfhDZWGPuP
         k4WQxPP1SvoFZ/mQ9gom1uzweK7GxFZghnd3fpXJM12tufjNu3yGgbikMSPNqW39zc5+
         jJUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564204; x=1795169004;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yP9dZgkD4P/bNBFnmHOgKVBIpz9VJZUP73dl9853V04=;
        b=jTIpj/3D9EcMN8LxSel/L5yvOoj3Mfq+Y1xhKAPZ18AJfWxegy9B6XK6JureX62s8M
         vbneDsWJe6Y9TPvzyezjNhxvJ0+BPz5Q3EyL1EzOFZiRgvgnusND0OcEx1FwSKJsUZHt
         DhIC9BAfQ9hwqIJl8ZBI2nrpHqT5yj9pwQAOIn9ZGcSIEoLmz6FOeIkdjID9H2RzwI9O
         /SevTCdJ4PVzV6WjxAOdQ8o9RXskcrRitVk6kfHNEhBjAr03vuHKBfIpuMFuH+ABo4wb
         8FeWLpFvinPufVyZJr/w/jSW0PM+9TDjw9TNXtJ1e08yYTUzMLZxSlrfUEPaA4d4Ypbv
         WR/Q==
X-Forwarded-Encrypted: i=1; AL+hErGGwXhRl2BO5iLcy/t1rmM6De6PuKYFDtv+t9tBnJga/eM/TGXNcFnppfAfleBL7aQ9u+VJrhIZoQ==@kvack.org
X-Gm-Message-State: APuU4Z+Uv9vG297VY9A8lDjIQBEGmH1jveZw6ZncWmq1HVNQqCWFFMNS
	LQMI/42TR32PoLpBZ9Q+EQsXAztjEjprmCAJYzZdYxjpgr7ivTiRghZ99xQDz3+mqcR3
X-Gm-Gg: AYBFou1XFbJs58DD+6U2kSruS2GjlKFdr5voLpLEJJa53I7lu5wU0lkBbcTJrypNcG1
	uSPzCP6WaXuJebJ2MpQgLdiTZZUwauSNvsk4kibvfFQC5bg7ckFzHUOgYOR+MRW+0wEFfeU3Doc
	PxqKBYAqdVPcvZTCWGSBnSpFnwUEq0jFSVSyc5KYFryoULvTTho7VWXhz2aPr3t2E3LHceISk3I
	Z/BBz1c5B/iTwV3adQ44X2pw+6SW3emMjFCWT3SKtipBHRjaWzvAI4bHhwtq/LkKWMZ/0cYVrad
	6wDTBzSJduIHcZwWzAjY5IergtWY8rFnGhjsLf+/zXcNod7CpTOX7Nm5rwtvsXm/LrWeOW5b4pF
	1TSSz02gHmfXYKFJV79bL0WK0ZiWOpgWTFb+56u3va3LOP2zNI3KigjSrPTNBPFmJMFSFQOe8nw
	vV99nDtigyj1Q+IT3RbTKlBU7oAGDC662mnPS1EO9HezoEIF7V1a3oET6GPPxNMC+FTh+51PPzy
	yIop1JlSd0TaSL643lj6FnoCk4qUIOr89MQMiXCzohMrQesTfAtuAvzuAWExOEDz/a5V07J33LS
	Q+LLWqq1XoTY+VtzrLfUZbjzzyEf0E6nz6h/rojCPDLECROxoLjq78PU+CZZEoo=
X-Received: by 2002:a05:6402:270d:b0:6b7:d479:654a with SMTP id 4fb4d7f45d1cf-6b7d47965e6mr298323a12.36.1794564203570;
        Fri, 13 Nov 2026 02:03:23 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b7c236124esm752333a12.6.2026.11.13.02.03.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:03:22 -0800 (PST)
Message-ID: <e5f36cc53b733383ac1d1f1e8c03f73091595edf.camel@amutable.com>
Subject: Re: [PATCH RFC 08/41] mqueue: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:03:20 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-8-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-8-4c998976c6c7@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Stat-Signature: 69doepe6jcgyd3ea3zejifpc7qqtresz
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 823502000A
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794564205-293708
X-HE-Meta: U2FsdGVkX1+vFsckt4LRnxnnsqhJ1cn9V4paTi7ohtl8EYHkFTYPm3lvBsJGhebOBGEkhU+H34X6rpc4ySk/K3GRoSjuH+VwpjhMebCKLpS2ShiRAGUM0a/gpjgAviAcTFAen1Vm/36wbfQ/eNck/TnMSt+quaNuYn1C9ac/ioWyMojZWovGW0ktjmCt8+EGdDyot88eLxu2QZNtSXxnTQ44ECpBgRQleeMH4OMsPW5Uk4FCldbFiNiR6Df3O6LdD3b6mQN4bOHc7kzT2P5fMmpNQxjDGj38Dzl9d1p0tVs89Q2aM6E2Jlfj76wyhZ6X+g96E+xJfGf50m5EjHaqPfkFaYgu2rfb5jrjMRmtuMRtSWawgYWp8ubI3vcyU1Av7SDQy/J9GLdq8DQf/JH28WGR4iP0QQWsEMySJ7rAEkSyWSSEGSbsg83xiyf8hVVEKmNqVGQm2tzRtRYxHkFWbEqjiyDKA6KwW6lmM2MMfHjMc3YVk1msdB3VnXJFa4ETdMq89V2FmgPkc5Hby0T8uRxbs6TC/kBV2kv8poDX445VY1iGbl9dfSwI3sbOKC5SkpZlLhKlfGgfqmXdu29SBkkma7Ld4LNlPhyrtaSwR/V4ssqJ20PAXnTC2+MsERfvexZtdBq3JJYYLHCWPetvRvTDHxtP2jzqsm0L8gTp7w1iM10QrGF1UNcvwJl0vv8j2XKWWKUbrHojhqn/aFXbAFUjE0AUhGjfW4428RcMH0ybzn0CA+muCEFtuhvuPzgXVdWSwZe/Sm5HKT2n8iOsS8KWvAgQKGlcYDqDmsC2nZq/0UxHqX6hSndHd7sib1tnJ/TAXgpBRgdoGR/Dl0+beoWQeXlm7ZhKxzvP2ONFbyaZRsGOcIcNT4xBybRb1v6nYsZG3Z+t8O4DpyylMTqWsfmQ+jVF0qHFfGgmP1tG/6EOGqg2Ds4o+LsZ+daa44vdBYghNkPuNcFmViP2Nlk
 jCmbAVoZ
 b4VJ6AXw/nElEe0dm32PJ3dKg3f9vijZId9ZljoJT/iHi8nNddAVmLSSRR1SPPEqpEXqRxbh5OMyqQyErCbeWnrPrI9R2a1YMp4BjRV18WXV7rUYyPw7GdTUxL27yjHQrnKX0et80NQJ2RQRF3ZwcwdNHbjeRweNUUc8o/yTvBoUq+0a+SlVxbv53PwDof7vAZ6jgNOxFrHZqWdy5VTxatR6nABhUmfoJl9BVutUfK/7r3OKM18oypHDieyMnKGrWq86c4DrNEYeVmYhWMYFuUbzRSSALKor8jufo/C9hXacD0WGjHbf9tySUm/eoZHdzijPzDRTzGMD2rKYqBEZTdSdWsJL3AiIuloCZrhXfwlOlAaRvVVNeAGd73//xuAGqHYfBkn7WbqVykYQ7kge0Wy1tclhsYpHnzipj97dFTiQ867r0uyDlr9r3YI3yf0E2svjV+roenbuxK173dLcdi0NQQH6/wYKvaZizS+skVr5dl2gKBOhmlZE23A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 2026-11-10 at 10:14 +0100, Christian Brauner wrote:
> Initialize mqueue as a pseudo filesystem instead of raising
> SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0ipc/mqueue.c | 3 ++-
> =C2=A01 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/ipc/mqueue.c b/ipc/mqueue.c
> index 322c3dd98c44..8bbe32d0881f 100644
> --- a/ipc/mqueue.c
> +++ b/ipc/mqueue.c
> @@ -18,6 +18,7 @@
> =C2=A0#include <linux/file.h>
> =C2=A0#include <linux/mount.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/namei.h>
> =C2=A0#include <linux/sysctl.h>
> =C2=A0#include <linux/poll.h>
> @@ -405,7 +406,6 @@ static int mqueue_fill_super(struct super_block
> *sb, struct fs_context *fc)
> =C2=A0	struct inode *inode;
> =C2=A0	struct ipc_namespace *ns =3D sb->s_fs_info;
> =C2=A0
> -	sb->s_iflags |=3D SB_I_NOEXEC | SB_I_NODEV;
> =C2=A0	sb->s_blocksize =3D PAGE_SIZE;
> =C2=A0	sb->s_blocksize_bits =3D PAGE_SHIFT;
> =C2=A0	sb->s_magic =3D MQUEUE_MAGIC;
> @@ -457,6 +457,7 @@ static int mqueue_init_fs_context(struct
> fs_context *fc)
> =C2=A0	put_user_ns(fc->user_ns);
> =C2=A0	fc->user_ns =3D get_user_ns(ctx->ipc_ns->user_ns);
> =C2=A0	fc->fs_private =3D ctx;
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &mqueue_fs_context_ops;
> =C2=A0	return 0;
> =C2=A0}

