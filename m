Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9220E606A88A
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 10:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=mQnIWc8n
Received: by kanga.kvack.org (Postfix)
	id 491376B0660; Fri, 13 Nov 2026 05:13:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 418D86B0692; Fri, 13 Nov 2026 05:13:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26F566B0693; Fri, 13 Nov 2026 05:13:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E2CC56B0690
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:13:46 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0E71780586
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:13:46 +0000 (UTC)
X-FDA: 85429684452.17.F13A073
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf24.hostedemail.com (Postfix) with ESMTP id 33D3C180006
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:13:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=mQnIWc8n;
	spf=pass (imf24.hostedemail.com: domain of alex@amutable.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794564824;
	b=bVu9qfA32+P1WVGpv6Cnd/QNpiuwMxrzMJTQcVgH6tBfjVIL4e38l4Q6Lw4qlnsjmqZj4r
	tCVFjGrtB7W+9eK5kAY3R0NEd5OHBKOOvApvVtZvWMtA6J3G1RwB+66jLyyFLNEZnl2ol6
	6AOVomxTK15sZOX0qC6CNBc4WfG+gyo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=mQnIWc8n;
	spf=pass (imf24.hostedemail.com: domain of alex@amutable.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794564824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ycFr7tcHP3BtNSevVHScuCcUOF/OuOrXOdu+rsUd7U8=;
	b=haeBgktiXsypr/xP9E7iQmVkY/rwLRXEI3u9SPtxDRANNQIEZ5r6CLBHgYLH7vgJwolK7w
	dP/dM7AI60eZzyGodoqTBvERfRR7wwa6/IFMZxhT9hbT+QuAiVVEDf6hOZRzlnds6P/4Am
	9lnqk+wyacC7jRFl1zomT2r8+oeaxfM=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6b7221c0f2cso1490896a12.3
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:13:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564823; x=1795169623; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=ycFr7tcHP3BtNSevVHScuCcUOF/OuOrXOdu+rsUd7U8=;
        b=mQnIWc8nEyhqnv/eLHPPCECORc/mIeFpCiGjSDt0QbvBA45xGOjtGDupfwkLXXPbii
         ZPPyxuQiZNmKeZ8SKh6T2HAxdxQdnYRYAFTITq4Gvp5DQW1i27wn33YyGlgNfW5wBE8M
         rR7cokVzxGQu4MH7dD4DjY4bIlMFyqW0QzjBMgqjaO1hlH8w2l6Ptk+15fh41QqkZYEA
         xUy/4P5Ylf5Z9rJJbyKgYPvzTLlQ6TLSSWdt+A+NSU5CZ99H5tSyS/jXJ/hDpC51vgVF
         fjWSeO32QNjZmnhEjOkgkTnLnuFnZDtlokuRyKaKBXoTzcisT6lfMjEnaZhh8eDLkc79
         uLrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564823; x=1795169623;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ycFr7tcHP3BtNSevVHScuCcUOF/OuOrXOdu+rsUd7U8=;
        b=tIWG30a2TbzBwuZ8LfbTZQfAjpDVioGjdWp/Jlgv3XiWVvhcsuTIvp1RgwMIxRD+Rd
         YDKIhRywXZcdo09OqbHMSGCv4SkcaVFePpcXCgWWjkSGU3M8hO+ffN38Uwjy1j3405Fy
         LhkfEtsKgpXoi93A6Rss7fRYBlhP2xJJSjjRaroKjPf6Dm7j6rAmFjoVGNCSYSunRYne
         jrcgGRf6DgR3e4LZieAzSYjgPO62i/XH3fP1HGbD1vPmw8XUxmCKldEdNGuXl/KMXQ0o
         dVQWo5dy3bQUK8XNJoofBaOqPNc8zuFJNEj66xREfm0nd6/NqYkn24AvyTCN7JtGRwBq
         JXrA==
X-Forwarded-Encrypted: i=1; AL+hErF2aiwYh8r+06uUjTCN7hNi8e0h554yL7+SydEQun2NlxQlzxpWVe/oOPuP1wyg8gMWXEcw48Dz8g==@kvack.org
X-Gm-Message-State: APuU4Z9I8bsL0BVIjtQlfYMhxqyoCQXjs5yOuK7CylYw4SYIT/r8PBRo
	E6y/JGeQmN8LxuFkWnZbXNL0Wv3JIEQV1L1JcjY6fYgvZKvnRDXRSzOszDP6YVepGuFJ
X-Gm-Gg: AYBFou2M+OunJej5E0wmNKZhFUvwTZvTU9RXYlv7Pyie5c26GyaCkUUpZhdfbSllUB5
	sDSippA3tDy1s1398oEwuBedYm3j9eAqgb5tSiGqIB9gjqXnIV8M5k9NdQj8n6SvTBsJpf7565b
	pC9I17kVVNfavjDnrHIDGOyDIv764qUTynGRLpyBSDBXOpghQLMkpG/Cjn5FHE+bosaj//ngTlQ
	Tz2ZmKLwbSNjjHObQy58rpaI7Lc5UtuQJHubHFllNLiN4jF+SwEXn75EU2xqQyRihMMqE4QbBpK
	zlFzp698B3cvFmCtq4Ptiwd2tg6vXRIdzjiPUuy6GuyPO0oEqDK0S8qy2vgessRZrS5EiZCZC6i
	A8i0TGZY8CSCE27jBgCeVUS/dffuSuBuDGCIsgL2S9mqHURhVfqjxJR3paUwjFRHJL5ehpu/5sL
	xVmrdP5INYeeU3x/q1zZAWanE5ar3gqdD2DfSw+BknYFKxVRPH+8VirpAgwCQ64kZ0sH0I15O71
	3hbStttR/2uKiT1g7VNR57KEDnbvQBWE6LET3/Zv06Jf0UuoVeztH86E6+CsBjZR5PxhNXKI9GY
	9uJZnkXjGUYBhjBNNuMGbTO/aCMgrDdOnJ6s+YZdA5oCAM/7IMwU/H37nzDMkXAIKtZKqMYoF59
	KdkxGo4w2
X-Received: by 2002:a05:6402:208c:20b0:6b5:69f4:e7ce with SMTP id 4fb4d7f45d1cf-6b7c0c62bacmr1415990a12.39.1794564822367;
        Fri, 13 Nov 2026 02:13:42 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c603f4d29sm4332158f8f.35.2026.11.13.02.13.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:13:42 -0800 (PST)
Message-ID: <3546dd28b1d63c1478d391a2015fff4c1b976639.camel@amutable.com>
Subject: Re: [PATCH RFC 24/41] efivarfs: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:13:40 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-24-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-24-4c998976c6c7@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Stat-Signature: dhn35cc4f3jdjseah43dnbcw1bbyfo9n
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 33D3C180006
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1794564824-213956
X-HE-Meta: U2FsdGVkX1+5yPK5DKASkc29+H/iB/MDNbbfy6k4BQFjRVb7EqqS/Yi9DB37w7minLqDtDH9dEnpTFFqraIBo7gqd/EyMTsyb4/Y820CW/Lt7EdD8wm1M982aVSS0sB6H6AtXoD6WExuOSdX4P7kD9Y/E1oDXRMncGNAjJxZwSTpKqVNllrRK/OAE+gnW4Yk/H2z8e4nU4vCOpDjYOAQjJUyzTcw42TxOOYET/9OVcA7GQOY8sBKvskUQVSZ2VY0Rkoe/fIDEj6Mjof+cRLucYcSBqA7C9sdUN3hCYpIVm84VwYkF7AeAGkrBvR9om5lLCENO4cHr9leX5eBeanHbkQcVVb3A29JTnY1B++xgbaV42D3xsrtxm5z0tU2QKftmgyGQHHPi9dLIDIMXXBewiav0lVql2BlYbrmP0TFdLHOykqqvh2QJjBVpgjA5hem07m7D11BeD5+Py19mZMaCZ9YCvp7DMi001sV0/IcbA6bttNmNMk6kEJRZ/WTA2VBxH2obxjJjGnPPUvFRHtkaK47/lAh9o3OfyyWuFIhKPDWCiPyxg7/NKDIgSTj8tT9goTplNntw7AvXnCWZJ8AE3ctqyyhBxwFB0LJcpIRs886rQXgrqIA6CpSyAvzYftMWFxQ9EA6GGk7CPjsjGGyZw+VetfeZPogpgcLK95dkdsgy9TZ5V6nkL/9ZhaUtF3TyacyEmMmfvY8BCClFc5pPQIuu0MzUXDUxFIRI1G+gwEolGDR5Bj0RvtljpSr73Fp9HCuFXaOitYdIHEXrUnpIJGE/uStnhrMtUV41J9kdFTYVf9JgXN2fQ6dJRo1etCs49OVIPeo9JO+z3jv3+VPl9WcjZPwl2SiQhzbh0c/nJuIWaEGseoJ8FLKjIljGXHOihnIrAblGFkdOqZDxMuFC1bE5KwgB7bQhrE1T4WtH8w9plclqxLzQN3zIfjsbr+FqQh5epdhwqUZ55G4uX7
 5cUQnLAW
 bIqObzxAQfzrurdprxhxPVzZAZ9l7+bXgcdj1jjnqBX39mbZ/cqbCw/1YgCH5oCrTNKISz0uKxSpFfsYfvdF/8zqV/nouQcICA0eqZr5u7kwgs9c9DfynYDlkbDQn5CK72gjmSzK7SqyImT7S6Uq+yRfatbxVvcudIc/cBzVoetZVqRc2ir2ZJLlhlOt11r+7e4KGXQcyXCWlavpJFgUvfewJ8Tgzf3U9lPmv6S3iQeO8H4TR5WGxDi1ASN9SzeCs5UAVVwB0Lt7kWSiCi+qJhjne/DHz10ozxUPPzkei9hsvwQAs2035+sbejz16UMjv3t58donpAL9KHNY8bae0ZB7CLffqLw0h+WkeeQr7KRznz4/lJRkBLIhG6m2Nruziv8ahrERr4o64mM1QZTAtwlZoGqaM30r4UF/WCUj5CG2B2guoQFGH+QtNb1ofvrxA1scdwgtsvVSxlqUwjHjn8kchzVmHmmyr9R02WXg8geOMwmCqyb3VsgFhYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 2026-11-10 at 10:14 +0100, Christian Brauner wrote:
> Initialize efivarfs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. efivarfs never holds executables or
> device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/efivarfs/super.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
> index 12746ced6dc6..e598d42c5f42 100644
> --- a/fs/efivarfs/super.c
> +++ b/fs/efivarfs/super.c
> @@ -8,6 +8,7 @@
> =C2=A0#include <linux/efi.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/fs_parser.h>
> =C2=A0#include <linux/module.h>
> =C2=A0#include <linux/pagemap.h>
> @@ -554,6 +555,7 @@ static int efivarfs_init_fs_context(struct
> fs_context *fc)
> =C2=A0	}
> =C2=A0
> =C2=A0	fc->s_fs_info =3D sfi;
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &efivarfs_context_ops;
> =C2=A0
> =C2=A0	return 0;

