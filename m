Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D58260A261E
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 08:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=CWxaxJ+8
Received: by kanga.kvack.org (Postfix)
	id 538FB6B05B0; Tue, 17 Nov 2026 03:28:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 514536B05B1; Tue, 17 Nov 2026 03:28:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 427046B05B3; Tue, 17 Nov 2026 03:28:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0D9B46B05B0
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 03:28:10 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 93C9DA036A
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:28:09 +0000 (UTC)
X-FDA: 85443933498.06.8B2DD21
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf03.hostedemail.com (Postfix) with ESMTP id B571720008
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:28:07 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=CWxaxJ+8;
	spf=pass (imf03.hostedemail.com: domain of alex@amutable.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794904087;
	b=52XU2DmK4c/CiXnscVCbELtM/Dbb7z91qN/rblYP30a0Rga8K0HtNKDj4FtKYO/F2ukoin
	J8dt41GDz9rsNNzlwjlVTinU3G6nefjwbWP/Fx8qpwl3K1EFX1SZNT06pmnPKOWaDak5+T
	1mrECf8qeXTa74bAsMvRXVpb4BTKbBs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=CWxaxJ+8;
	spf=pass (imf03.hostedemail.com: domain of alex@amutable.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794904087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AET1JHslkSzLNTOs00e5qdhXA33kuZnL+yhN5Q6hFHY=;
	b=Ks1+UX3z//W1m/fwW07qKENBiNBywHcswENqoe0mh4vxYfbGGqgMLgd9D7bcWXoT2c9QRQ
	ONuoKeeOBW+mS+d/VaBctAdG8NgYWTQsQdZzyk9H1c+a1nvRwdz6JclgZOGoQVqQOtoXRr
	MfvDYRCcI8yNnuD58iFIq65IrJKCjfs=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4bb6c7b6dbdso26232795e9.0
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 00:28:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794904086; x=1795508886; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=AET1JHslkSzLNTOs00e5qdhXA33kuZnL+yhN5Q6hFHY=;
        b=CWxaxJ+8cV+sDuRfcWRMsbV9i+oBralwtG4QSJde2FsicaqzSUGHQBw9ntgiLIAC32
         NbaISAQIgkq/d4iQPBXSSdX/Owal4gzqgw7RiyYBAxUkVxnK5EZm219Fwy7vb+jZtAQx
         zPYOUxhurfRuZO7z50K4yUGA8N0x9sa+yUrzC82zd5dqzCqeRsP/WAdOupERxppTb+8Z
         P9HrraQvUij3RnOSfUFu6MWF3vedrgbHQRadsDKjVQP1i3z/GCKeRDdFTK5IEzuWhHiz
         IB+GGqVgjn0f2dwQbjOGOtey/YfhnKw7wdUPGATJv4lDCQBmhtZt8ze7RFkUxvNC/pNd
         HxbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794904086; x=1795508886;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AET1JHslkSzLNTOs00e5qdhXA33kuZnL+yhN5Q6hFHY=;
        b=ytdW2p/fUA26foNCBzpSlXXLThxbMnxd+bdy9zwuFEhvvRaWb5UbZhbdVdjxoaJ7Sg
         ruU4/FGNmpitDFMEMd8+YBP+PIaPhxU6zF6N6t/vWuAQnIQIiRJvalXyCr6Ctexgz0nM
         CNJfUZStvFcxdClNqHD+cKBvSvhvpBtyfXebOBHF9oFr/VXjgSsrzrzHXnHnFcNebNUf
         XnnRRnPMtIVAk0ZAx/F2bjEAvTx5UcAitThjHMfi0F6mwvgV6snU5z+lQTiKFOkF0Mdv
         9am8NGGBvJDLIVLeUJ332tnev9H9W8SYrSKYwHVv9be1smCi1ByGhidGsorcRWJRynBe
         NAyQ==
X-Forwarded-Encrypted: i=1; AL+hErHrZgk/gRRfJOpn+ub1nobl/9jk8stpSdl8cV6sWMYEk9uXKr0MNmnxBSGGtuRWiL7cNNg3TqR6hQ==@kvack.org
X-Gm-Message-State: APuU4Z+vSEO3bBoNaPWJXTSE2wF8W996ONEyUd/iSHEKheejs2TLAYfa
	ivDuJ5mEOdAT5IUADzLI5uJvR91U/L/J+zoAWJhCuV6r/20VIr6EDS/M4S+0ahG4rhYA
X-Gm-Gg: AYBFou2TzxjpgdsSX2G4n3bncPgTzVDga2KOXWZ6MEzLagyV2hdttO7Hm+GdNRQsKpf
	0uNg3oivVMcLOVijB6xEm1bzfpa2KDfk12SPTXSDKBdb3qhC98vFf1yn5+LEaHFH5V8nEH9MHme
	8vD47DJlMNUvDF2T7+AWUpNbghSuCaB3ytEeT4v87KdSPjN9AznC+BCkKIejYclQGjobSgHlXlg
	Uy9Kwq1s0tHtdyxB7mhg7sVsOkVDIXBW/ZSPf9sp8WlT+8J7MxUca9Sw3rD/p55b21Gme4qh30M
	ASspWVxJrzftYm4aGdPg4m1Qev3KB4nQxJ+tvcgHb9O9Qb9NOnyA8rbzyGRcJd+68uMHoesotdw
	rK1OipGgZx1oAOp2w5wIU9QViZDVr9yrDkyAkZ0jH22r9+2VNgyubFAI9dgRQYn7ciL7Ou+IQwg
	FzuaxXTen2nxHp1PIIqV4JY1YZdSVhB7zo0eEdrRgfrHDov1dblrYBMcP9cXTRKUP20XnAYdVAx
	dfv1tZ8U1HpkbYw/jJFpUAFkIM9eGz2ezuHB1PDen4VJTnXe9EwcD3xQP5V5CuMQYobhMJo1w/R
	OKaAqOiRgDfif4psq/wbW94QTVvvL2lSbuXLTtlE4W8NMpONuRz4EEx0KO4adYlUU37hW+yPbLg
	xS/rIi8rzl0LI+KcTbur6nhCqCw6SgENBvONcLN6uapa4koonHWnHCwci
X-Received: by 2002:a05:600c:512:b0:4a2:a9:ed87 with SMTP id 5b1f17b1804b1-4bb55a5aa47mr209766355e9.19.1794904086313;
        Tue, 17 Nov 2026 00:28:06 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:de4c:6789:33ce:97c2? (p200300cf572c2800de4c678933ce97c2.dip0.t-ipconnect.de. [2003:cf:572c:2800:de4c:6789:33ce:97c2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb78418853sm74782845e9.8.2026.11.17.00.28.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:28:05 -0800 (PST)
Message-ID: <fa0ce0f7ecdbe91cc6773bcbe86be137d2129944.camel@amutable.com>
Subject: Re: [PATCH RFC v3 21/44] nfsd: use fc_init_pseudo()
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
 linux-kselftest@vger.kernel.org, Chuck Lever	 <cel@kernel.org>, Chris Down
 <chris@chrisdown.name>
Date: Tue, 17 Nov 2026 09:28:04 +0100
In-Reply-To: <20261116-work-loop-pseudo-v3-21-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
	 <20261116-work-loop-pseudo-v3-21-8cbbea1cf34f@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Stat-Signature: 8nyhqbjj83pgrfi5cgy5k3764tifxkjb
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B571720008
X-HE-Tag: 1794904087-999454
X-HE-Meta: U2FsdGVkX191o+2Eb+Gas27yOCMqw2RQEBdbsdIUZfj8eiFKUcXPecmrGtXxqnQc9+UM1FFA+DEc1Dntq0GSOTXfE+fEMaZnLb4z1tigxZMwA9hm0g5Diiv43fYR09huxKvS4F5pHeYSCNMg9erErbwrlqTa6pXNNR7L11rCSKY0/iHQTJNm/B5OxdO+rfna+1SEVQMDaFkHonOsipAjlrLKrPvwQopc6yOHNFcI3FMCCidO5LKapmPHfTYUO01Pyp7D399iPg/YwOQPKRseLGtdP09T5ZV4EzGI5/gyDYkGQIU6oQQl71AFG32Ag67M/b3UUkGREIV/lNHLdhvgb8DWBK68GJo9xOUZA6G95zwnY57yQIuwkZgC/bNsACQ7kBhNMo3F8B8j3/NQ5ZWYsfoMCNjTKxSLM4JsiHrr7nqc7NDPO16Wg51LP1AxOfhqAakhXwoXM7sbaqc9mQpFmtXK+57YeAeXXHbtzW7bEX3JsLbCQ0XWwyjQWCCn0TK8cPsjDmLnQ0C7mrN82XygsXcesriVUCBxWP5sUFT0AodPnAcjXNZa2tbZ4rO0edubZQEBIiWumxQj6HWIBfpWef83UZttFiD1hBalKoPbUxacv0A3wJmuBFKJBi9YrK+kkaTgLIJ+auPFNxwDL4eufLLi3P4KUiYW++HsPoZNzOcYLVj78pLfX0EaBI5rbtbTlqgiyHIkAaMz62Y+lSYaNPM9kH5BHC0VNiX70sxULnSODotBi90js+034Akw0X67+fRcinmwJAbjLVsd6tGdL8YaAqR6SozEZ+em19P6eBQ2Lo7SLe2XG4gZMXax1ydV50Vn/s9/LhN6yIF5E+6tU1szySI4O8fNCzhiPoEHKzxa7BRTXKrQP19sbdMBZhS2Fp0+u6zPB50TnAHISHVK+wrxapOViQBol3boKp6YBIhh0xlnmlC1aV6NxTRy2wfX7yD+Si1Qnt303Sihkb9
 aalPDq3t
 t5ZShGX3xFeY7P8lYVDw7KD0wRU0noROUX2BI6hUF/mz7O2VFDYWe6PVjiXxdLTarXnCQrSSla4XDc290oV/FBEuXsIbaWvDrVz09Zqb5Rp8dMvGOTuDpRScA/k8UV0Yji2N+FwV4BDOyMFmB/mkN3OcJUDUpoHIALy3mNnQgJ3nbtSPv2eD44ge8IYNCJeA6e6p/HV0Ca/ane8KiWh08ne7PpMWow2xvwrZFkIp4FGXuRew8egxle+oYkvHRZIURfGR0Dyvf3/CkjrC3LAietuAFwRbWUmT0L09enwXpFbeHJMlHKg8aErc3I09HvkUwPJyr3qFNOYgbQJ25UmqvThgnH4EQ4kncN89ze1DvqL7KHfJl2Zxnr/DqKIjuDP21yLNaEhF1bYQ917lQbtpABYV1UNrdUPGTWemy0n0HByJTjBDG2jycisUmjnpe2gJdNHHMucgsNUbU5okN80VWgOz+W8ChdWVbO2erkvTY5iB1MkLCMqXSJYJBFRMv02wRT0ShHT0j7sEQcQ2T5cnb03dX2C4f0KBt9BlD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 2026-11-16 at 12:04 +0100, Christian Brauner wrote:
> Initialize the nfsd filesystem as a pseudo filesystem. This raises
> SB_I_PSEUDO and also SB_I_NOEXEC and SB_I_NODEV. It never holds
> executables or device nodes.
>=20
> Acked-by: Chuck Lever <cel@kernel.org>
> Reviewed-by: Chris Down <chris@chrisdown.name>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0fs/nfsd/nfsctl.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
> index f32311f2d7cf9..ce2666deddbd9 100644
> --- a/fs/nfsd/nfsctl.c
> +++ b/fs/nfsd/nfsctl.c
> @@ -9,6 +9,7 @@
> =C2=A0#include <linux/namei.h>
> =C2=A0#include <linux/ctype.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0
> =C2=A0#include <linux/sunrpc/cache.h>
> =C2=A0#include <linux/sunrpc/svcsock.h>
> @@ -1375,6 +1376,7 @@ static int nfsd_init_fs_context(struct
> fs_context *fc)
> =C2=A0{
> =C2=A0	put_user_ns(fc->user_ns);
> =C2=A0	fc->user_ns =3D get_user_ns(fc->net_ns->user_ns);
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &nfsd_fs_context_ops;
> =C2=A0	return 0;
> =C2=A0}

