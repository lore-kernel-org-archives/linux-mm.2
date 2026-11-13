Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44334606A8B1
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 12:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=rTTP+4AY
Received: by kanga.kvack.org (Postfix)
	id 46C196B0711; Fri, 13 Nov 2026 07:38:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 443F96B0712; Fri, 13 Nov 2026 07:38:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3318E6B0713; Fri, 13 Nov 2026 07:38:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 00A586B0711
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 07:38:31 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6F81B1A01D6
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:38:31 +0000 (UTC)
X-FDA: 85430049222.02.18BFBF8
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8E3832000A
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:38:29 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=rTTP+4AY;
	spf=pass (imf03.hostedemail.com: domain of alex@amutable.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794573509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ny+1veWg8VD0eIDxFJ1X48Kguf5Oe9PbJZTpbcgMiOk=;
	b=rufNFGtwcYD0JDNKDzvbsTI/keFOSS8fRHvLAjnKRv2gcfS7SxVN/8A6xnhx5iZfPibyY2
	2UhV9Q1BK5tQkDzMa8RYR7m4kIsSw0AQH8SbP+wUGF2no3jK3agJHYnDS2tIfQ0tSmJ0PM
	6FY1uEitMCW2WiCaLDLLttCIPr+Y3kQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=rTTP+4AY;
	spf=pass (imf03.hostedemail.com: domain of alex@amutable.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794573509;
	b=WjmLHCvamB6J2eSHdpsnOLDOC2b4TI2ciV3JJlBgsMH0bwKKSrmlzs9iZiGcP4/S8fLwmW
	NH+Cdp14H9ota2Tz9AYa/0YsY/XE4xWGsm6k4P9ACirUEKtTZR9EqefNGUEmC73PtX+Zgg
	DVgOrmuzOyb6NQGv2hDiaZsocecg/Yg=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a9a8d6cea8so9108335e9.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 04:38:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794573508; x=1795178308; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Ny+1veWg8VD0eIDxFJ1X48Kguf5Oe9PbJZTpbcgMiOk=;
        b=rTTP+4AY8fRJlyVnBhcPSdt1sSjVAvFy/QK4I/ZodWxSEiQeWycETYNkp+/QQ4/IJT
         0gTs5PjAEV0nRo3Pe8ATGYVOdMYvKG4n7PtcW3phrW+FjKKdHcmGmrSD4CikRifM+3TY
         f4W5SKF9BNWFXxHyulJNq3yyDghy3coTBVCwiZhGvTqrdhMIxFUy/f85zB91GFbr5fG5
         d5ZHSjQnvsZ1r6pyQEXtf12v44rXn6n7yQAhR7ylPEYfvdd/X3XLa0SgravyXmzfAiab
         YNm0d61O0visXtXwko4SPGMIkipLRuPCNJve31oOcd055CS9YFIdwOmJo7LHM0/Atk7T
         4Qfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794573508; x=1795178308;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ny+1veWg8VD0eIDxFJ1X48Kguf5Oe9PbJZTpbcgMiOk=;
        b=E4lbTUDynLQ311n8s71bLEgpdP2Kyo34eyUuTSeEOJrF4ym0VmVOp3Jxi6CqFd1jLg
         3cI82sfbwCG8+S9gKz1XQLxDs2OGHAbAYvf15Ao6XKqAi/17V0J+tgxEQmkHmkoJsj0f
         NuSE/J7V4WJFOX2t+NKTtQ1THdev87LorneD4d2qIIqM+/oG9ZpMgD78Xk+dEUQFlv1P
         sWyfTeahFnZT8xseV4RtGJG2k/QSZKNq4DgluG8D0Ao07yawRXCRSj083b/X94y8218O
         VIgUdxZ4P7ddxGvjAaWO9ZjTDMeOJKT1ia/gfbemYV5eQEfnUouzkd7Uhoxzs6sKaiIS
         Yobw==
X-Forwarded-Encrypted: i=1; AL+hErHGK81EA8Xj/xRRJpBvKjMFY9ahpUIN+ADq2GZl+zXCx0oSZW6aiRr8yRgJA7cJ1dXLYLmFiY0pKQ==@kvack.org
X-Gm-Message-State: APuU4Z8DzwpTz/OFDISnqAVhBXMYKjcQ+V4uaYGmcbnaOtITrqwPkUdW
	X6xHzqNt7iTc0GB9P9VPq3SnL1U77iTj4/ADFfho+wma2IPv8AK+cTYy/S9yLkHLDVud
X-Gm-Gg: AYBFou3BCwV/FZwO63eE8VqpQ/BmTmkfLrWMdMH8jek3W9xAQNOEE78AdlfQta9+6Ew
	Ir5dT/noCGw8+MRc1gWG1jCV1UKd8x31zV98NTnBkMG8zE9lyMYaq+b7MTrE2eOOVWkzcgkviEC
	7Dxn0YwwdChLbA8kHkeYhJoILlEE3uSVdZahcqlZdZ7LsCgq/zlcI/eLD6KbbiwqVn7aDJtQalQ
	rv90OB/IkFu3VlEXi5uOiwk75Ipyv1c55taV966e5HmLXj2YR+iMFwtgRESFLaYnEBlU+UQu7Fo
	sUqiuzL43EDC5VzULgU0i2oM7O1qs8wOcFoTuKqSO8zw8qJnVsf7B9Qpm3aKcAfsLZPPobC4peN
	Ia9qEEksKdK+WYH6sN54TLqeLwC7TKhnDdB7HpHEuf7nq6TXkt6qpNojOZaT/l37x7qc8v3/LSK
	nd8gk3T4THnGHDeWDgr01ZtegK7Ch0eHBHZL1mwd2/FoVOvLxRrNFLbms9hlW3fifGv8nqLOR1c
	ns3Paa1qln37+jC8JD2aJOG7GE+AqUCx7p3wWg1OSndE9HU77C+b+aamAZOi0srs5ROgkpLE1HV
	8ZQhLX/tDgcVMMPZovlK533s+6DGPGisKBo47O0DKBYWYsHNPCtpAiqKjNtTnWY=
X-Received: by 2002:a05:600c:a596:b0:4b5:d95c:2380 with SMTP id 5b1f17b1804b1-4bb55a86fb2mr24790785e9.11.1794573508217;
        Fri, 13 Nov 2026 04:38:28 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb571cfa2esm48348475e9.2.2026.11.13.04.38.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 04:38:27 -0800 (PST)
Message-ID: <28a33fa649dcaae2eadcc934ec49fa591ec1c283.camel@amutable.com>
Subject: Re: [PATCH RFC 20/41] apparmor: use fc_init_pseudo() for apparmorfs
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
Date: Fri, 13 Nov 2026 13:38:25 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-20-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-20-4c998976c6c7@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Stat-Signature: wemx651h8cbjszozdpxjeddmqmpafi7c
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 8E3832000A
X-HE-Tag: 1794573509-434643
X-HE-Meta: U2FsdGVkX18Cej2MuuaslQkl0QJmFznyymUzgjEjGXGilNBQXnV72aGylrNDQ7+lqdn2/1kaWn7/NHYgqmUNuQo81vUuTD+ROCXSFEcOVL1fjfUSdFyMKbM/1KbRfXABfjccpAsVZGyACXYRhzSP5732CxbP3qyHhOm69+BbHnuiOqTfV4MnpSqRPBVHA0tr8oJYBmiFLWRYfrfoLSMYlWCFuNnn0SQO+e/CC9cfIk0A62qPy+dshJ1gvoLfO5BRvja2TK1cvS9rnVNi10LAW0gGe9/BxYbe3aAmlJ1CFld7HNfSWPHceQexBd9iMSJ1p+dVQMyvSwhzzJGQKXXHYFFWb6YGKe+L+RnT9VCkfPdqy4i0inh7rtHvnaM9X9wPWfQio4XJapHHt2/PIDRsw3SnNC7qDi5c+N9DSHjpYEYKYlQpPrQYDDvpveuRwsclD6qATWB+NdUqPvC1YotgO/BZmpxgxbaUCXOp9qScEB0xDQ3NSAqk9Z+4G6CKxGTRVRhEdNQucYtQe0icpjbQfGTzjG0506aquIZ+zIfFS3hKxcvd8xoGRmqOTTss5I4qS0yzYVoM6ITgNu3DTBTpCBaYKSzg7Z8QHd2O8U1DXZRxZPLpmTLBT2l4LI3h59GsiGYBxuiyumvQt6XfpCGqLWspqW0oMsE3Op0fwB0S6LCmcXLG7lUpzXbAcd5qKUAsKl07G/1ZXP0i6QFQXJZnXsKMR1WRClUwRk9D4oelP43XoyOMOtKVeJgTEHdfQjfKOQwLWcSzsYGyOoFcou4dVRF0lDF80pZWfZtPATINUHwLsV8pKyZui660jOzfT3lKvhX4V/7ZrfQaAuHoiz4JEBX37cPMX1XRo/yzlElQ90dgpjXeQMabqmCPbbGmcCfsQTEnFQ1D8TqkQPQgC6cCn4lQ1dba0b3VnJ23r4Z3MX3IR9FdGELnOO8nyV2hiJD5IaTNsChF1dS8WZvPSY5
 QL543LjK
 78BrtwcmKzTCtb3YVBT/vBlpI7u4Q9oPoxfm063ub/6deRtd/xv2kw/4tlRtgjFUaJKIG6qb0iHaLlORM+ouALdcAQb7Po0QA2OdN1PjJcs1FSjhz7zzK3krqxw0T+PNCgdA3MJNu1oxyTtC2WoLa58OzdWz0wAH1RwM0eqYclW2Bt1TLHEXGi2GFZEqYvwqYDYZmUx5iGNf2IEXt/YVMwYbyFiFgR6LbGrT1UhM5/yV1r7C2q/pC1Wmx+oTQeUoQeMSGCFxcoTE7C3bl+JL1BDIDnwLQvix6tXqXCSzE8gdProTkqdawCwbMMWMQlKDKBko0+OgeTjmc3lIjj3HXqHJQiPlSvelX3PS15D2usMTmVGSvd3zt4fRFQruaB/SfSOQNK6rNGdOugt8jKA0RxoyfDkPzisDsIfagIyE/HpQCAMF/WVI7dQzKuZZWunIm4tsMeGyeFpayO+qUu6Az3h7OmkCfyq6K14ZRIHDy+bXkHC/kaHfmYOCQaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 2026-11-10 at 10:14 +0100, Christian Brauner wrote:
> Initialize apparmorfs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. apparmorfs never holds executables
> or
> device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0security/apparmor/apparmorfs.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/security/apparmor/apparmorfs.c
> b/security/apparmor/apparmorfs.c
> index a99366467217..351ea3a7120e 100644
> --- a/security/apparmor/apparmorfs.c
> +++ b/security/apparmor/apparmorfs.c
> @@ -21,6 +21,7 @@
> =C2=A0#include <linux/rcupdate.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/poll.h>
> =C2=A0#include <linux/zstd.h>
> =C2=A0#include <linux/string.h>
> @@ -263,6 +264,7 @@ static const struct fs_context_operations
> apparmorfs_context_ops =3D {
> =C2=A0
> =C2=A0static int apparmorfs_init_fs_context(struct fs_context *fc)
> =C2=A0{
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &apparmorfs_context_ops;
> =C2=A0	return 0;
> =C2=A0}

