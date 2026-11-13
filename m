Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 284BA606A32D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 10:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=AHN0Ea8R
Received: by kanga.kvack.org (Postfix)
	id 1F4216B068A; Fri, 13 Nov 2026 05:12:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A5246B068B; Fri, 13 Nov 2026 05:12:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 093DF6B068C; Fri, 13 Nov 2026 05:12:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA19C6B068A
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:12:09 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 70FD88056A
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:12:09 +0000 (UTC)
X-FDA: 85429680378.17.1D18ED8
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf14.hostedemail.com (Postfix) with ESMTP id 96E07100005
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:12:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=AHN0Ea8R;
	spf=pass (imf14.hostedemail.com: domain of alex@amutable.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794564727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C9TZKYRayQVC7UyXoancZRI4bPIYIHY06/n7s/4tB9k=;
	b=hjCqtB2NeQf4VjZ7XO+eK2qZW9SJn/u8SU9D1qDIgPQo+dnew3MEzjB2jw+P0ZVELSZN8h
	pm7uR/BO+U8/Ke3yjTWuI9k6xDclbvtEti+eSgrDrymyp7tjpkgOJQWUoO24fcU6ZqI5q6
	WeIqKQx3mgUSL/V6sdDSlKA/rbbjBU4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=AHN0Ea8R;
	spf=pass (imf14.hostedemail.com: domain of alex@amutable.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794564727;
	b=qCloX0fYs4S+9PI/Ahc3ew5rQwLKEdRzyStRLhEa5rrHVsKX0dMqJoO53bZbguQiKLUIIH
	6Q6D+vHJ9aTXE/NC8mmyjUG77Mg+M8gPPNY4Y7L7Rjwhyc3oWh4gK3mKooVvZV4+iv+6dx
	dXyVH4Bg24sr4BULDD8gACPhKNXvzM4=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a214c5c4c0so10660845e9.3
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:12:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564726; x=1795169526; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=C9TZKYRayQVC7UyXoancZRI4bPIYIHY06/n7s/4tB9k=;
        b=AHN0Ea8RN631PY3A9acXbvD9xu7S2X7GwlMTmqebHXgBsyntDP11JAJVJob3cFRe4k
         hUY6VvqX3gJ6s/EAPyTgAOi+doRx7MJRRlu4DPBtKAj1JTTdEcL6EzXIJ4N7cLwZyMrb
         1R3uStVIQEcoOrN723NRLUbJZ4wXU3gMWRFEJhhDNF7X6GX1jGsmoIblWHGH6N7du9ZJ
         TeCL8e63EEEsYt7exOKaLT4eCe6CvAAUb94vvgPcvVBYzxqDJu4WCIWRW3KBIy2S03PZ
         BJylIzdS/OqSHvTH11ByWM4s6ztnzXr8D5i9L+BSpola/kfv7SEW2gsOYGKSWUXYnL2Y
         uucw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564726; x=1795169526;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C9TZKYRayQVC7UyXoancZRI4bPIYIHY06/n7s/4tB9k=;
        b=xiidFGBzDwqeoPZq/PQVAJmY2+Qf3qNv0TKqIOmi2bcOeVDxqa2gLWDoeCjSIJt8su
         LgsXjJwKivuh7XOMUlecZ8LQ/DYUkWsAqeMa9k8Ng5pnxvbAMIQNIvXwv3tOTRWdkp5J
         C1fJ0Hm4IrGs+PBH1lq3+BQYMV5C8ZIe3i7YOCd4dCVOyPN6oKUMNjlPg/AurbUzNNNF
         LBTS2TEcPBOk7GJd5YUIV3M0/PAbSbzCMXd1uecv2WYN990l0V8dom5u27tQ4YazDG9a
         +374aKuEsAMUxLWuEvTICzYiUJ/hbvycsuFeFA+dXCfpdWgbH2J+ioo29n0/Fp/gDuQl
         eYig==
X-Forwarded-Encrypted: i=1; AL+hErFQNCKJXyQPHnPpBTbvxZd8Y/b8lp95GA28Bgcg0irtnCEia5hXF7p9TKH+ow/tBX9bJ0ZUtYor1Q==@kvack.org
X-Gm-Message-State: APuU4Z9CtzGWiU0hy/R+goFmHbtRmkvK1GEqXlesiaX+i4eHkainLrtY
	RPiZ6Jn4Ko3kwk2Y2ePSJKyQGJOH/Rtbb18L37Dfr1J1BxznCZDJkQXjfy7KFrgqmV1v
X-Gm-Gg: AYBFou1whBbOEub+NrUA8/5xqj2kcgIT62Ru74i0uVP7rRwsApjFPbGTpdoREGBLvPt
	+mmxLTknSZJ53J+IC9VYLRxrAoMiPgC1qDcwOW6iYzBGS/qOdz+kPX3NXkUaxn/j61KxY4Uv32r
	0ZBQCyJhapM2ax5ODl7rYjl/tfz9ySBgWDyz1IPlVli+30egPi5qy4IA7pt6/fJsG/H1dmCVrot
	xXG51qpwPtrw9P58kAYe/Po9B7f8x9ZvzPYB3dr+seilmGlZUjqzFThAUOoE01QJiSsrHd66zJw
	LkEl+Vt5XDOfc0/bzj9lUGgihzmm30WKfu3y9Fekc1XDBXQc1WS1mNZlkl/Makk8LWSTLKQkjqn
	Qf8D12w1gOKh2YfKjh3tccrnmksJDa/HydUlfaiCD7Y4ZfwAcFaWtrEkZvzUeJEb9uH+SZiB+tN
	ApWK/ldC3OK5F/99MsVqhTKKOCG0NknyMpCqypvGCu1lgfUo/12I5F+BspSDIUwsdSU7JrfY8EP
	UyiRlRC680I7C16Ejn4HQRViK2njebmu+WearemW8nEVkKAn9Pk5HdysiXr3LdiGfq59PFObjR+
	WYtT+fJQDMyxr4JNtJU3FP9Eu5ujzNBnmgpsiVIyuweVIibb9UtSicQikPeayN6B0mDvOfAY0Wo
	uFPZAImSm
X-Received: by 2002:a05:600c:c4a3:b0:4a1:6992:f861 with SMTP id 5b1f17b1804b1-4bb55a02932mr40317635e9.1.1794564726124;
        Fri, 13 Nov 2026 02:12:06 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e2842e6sm142085915e9.4.2026.11.13.02.12.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:12:05 -0800 (PST)
Message-ID: <82d691d2db7579d9630bf89f73132e36124bf74e.camel@amutable.com>
Subject: Re: [PATCH RFC 19/41] smack: use fc_init_pseudo() for smackfs
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
Date: Fri, 13 Nov 2026 11:12:03 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-19-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-19-4c998976c6c7@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Stat-Signature: u9yfq9ida5ogr9smj4bocjxec7zra151
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 96E07100005
X-HE-Tag: 1794564727-558091
X-HE-Meta: U2FsdGVkX1+g4vxgRaKJPm86yLwMwOLhodpf3KbSNdEABd14dtqeSpSFlxjWm2XOinczB/CmpLo0lznk14b44GON2jzTKD6E+0XhpPt5mVgmq5DkkurjUFAn/iKw1dCBwSXXkn8CyAR0VKurOMLcjAEhWAvSvr4E7hou6T/WYUkv8X/ekQqy75OYwT10DTampCocT/kXZhYYs7jWEQFU73ExSZKrTbk1M5/6As9Uk6LmXJPNMBosE9i816w96ZV91nab52Bl1MenZz0DRNRQZ4eXp6Bqn+Tt4wp6PaTWi8+0XuCTNsCSBincS5aTDzJ8TGtcAfOCZyoadpyMSZCovS5L7P2sOpWDKZtH2X0HdPiNt56d/sU19WPlNOS33V1RWjAbUliv2ClvW+f04FOBkKsSZ/WEGHllYHPbhOvX97uL3PALMmQUj9/dC44IzDFbVz00kiibKQrFvFHS4QUDzgmKrkSMMlTSMqzEcRgDK6XOvlVpvyBvpx3VM4WRyZMGLPcyR3G1Sd5f4CMwhZtov/8TOVvNs2mMX4VlmtQrKfGCjAOie7PhqOyA+mT6TmdTDfKiDvVUb86ufXnPE1VNyw47dS4QU8z/LvHM5xBKLAxI68NhVfHxbR70rP/D+4jeFroykJRVUVQ9+b9HXPzPrEvY8nnMjr8/sDlLjWYkXjWfo5zinVz9jFkGA5TuOn5tgaOxwKj4ORS67oeePc1blkcbroRiCyoCJ/CZ0Em+PeYqetwnySX/N5VJCYaRm36kFaX3e0qjHh59F6t0YgAdGeK2BLZRqbXfW+KFWoy63pzTh56sH/q/1cazte4FGBSx2p6CJExOW6QJbMKVb9Z0vKORQy3n0p9Gdvi9jxzsN/salVyMIjRlePWAsTmrvXK5zTh3gk3dPrZ7hD0dHZIW3s14XcAkEBvaYaep93Cek61E1/o3TzISnIgBYHn7ZQ3P+/rGiuvEsHg4W7kBWNm
 vKA0j0ew
 lXdar7ryHMjv4PmA1yH+KtCZpqV4EaGqCxGhpdpr9X2msAUJR8ZN4fJhxG4WY/JEuUbK3L1uQbzhnkgFVPZg5hpvHw2s4VmMQh29ZAuXlH83QgEXpgARHtXr5Ys26WcAjswfRiJQcIi0gsNDeXJSaaSwPoJhdSGRaY7rjt/u6rYSZMCX/Avyyv5pFeYFpoUd+NJ6WYpGBMiUam8y35Jp3ufdF2/7BxxcTYacGyg3wmqpbWYswzarXRC9If8yO9thM0w+dWP0ZeXQlHyA5an2vHS2A53V+T7SrC1eV0peU5es+GkzBI3xgvwkBo4soyK+c0wzTHtgVNpG8JwrykUXZ/Ynl8WX4Hecs8vRT62CxDP8wYkAqWqjgJznnqqA1Ul48CSj/wmagtChmbo9BEHAhV02VNw7Rw6WD/cT4O0VVx+UAQIXqTpUwh78IIN4RMTRV+IP+PzhzZG7h+H5TXi5/I3yMOiSu2pVS6yIucxMwCjrWQ2MIJKbLL0ldHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 2026-11-10 at 10:14 +0100, Christian Brauner wrote:
> Initialize smackfs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. smackfs never holds executables or
> device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0security/smack/smackfs.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
> index a72bc7fabea9..4a56bbeaeca3 100644
> --- a/security/smack/smackfs.c
> +++ b/security/smack/smackfs.c
> @@ -25,6 +25,7 @@
> =C2=A0#include <linux/magic.h>
> =C2=A0#include <linux/mount.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include "smack.h"
> =C2=A0
> =C2=A0#define BEBITS	(sizeof(__be32) * 8)
> @@ -2880,6 +2881,7 @@ static const struct fs_context_operations
> smk_context_ops =3D {
> =C2=A0 */
> =C2=A0static int smk_init_fs_context(struct fs_context *fc)
> =C2=A0{
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &smk_context_ops;
> =C2=A0	return 0;
> =C2=A0}

