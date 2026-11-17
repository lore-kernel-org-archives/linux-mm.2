Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28DEF606A8B6
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 08:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=XfVmYBfJ
Received: by kanga.kvack.org (Postfix)
	id 3B0CF6B05B9; Tue, 17 Nov 2026 03:27:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 388556B05BA; Tue, 17 Nov 2026 03:27:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2780A6B05BB; Tue, 17 Nov 2026 03:27:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EF6F16B05B9
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 03:27:13 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7E97C80349
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:27:13 +0000 (UTC)
X-FDA: 85443931146.20.D7D690A
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf04.hostedemail.com (Postfix) with ESMTP id A962B40007
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:27:11 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=XfVmYBfJ;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of alex@amutable.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=alex@amutable.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794904031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o7Ds5Sp5DChQJ6GHa3pEkVZuOErJkij7LbLCUPT9+Pc=;
	b=6Fd7i8ssNJT1xFRfv5pqtSf270ncgXQ/bWHLtfxZA8VBgoaqC9n2XNiTCHkUMKrtt0XX1F
	5j5+TdsgeUwcB0Qh6je6uJepDDlbv1VmhrWMAsqjWN5UWLRg6lV4TjGLyPTijJPyCZsSWl
	yHvgW0k69jr6+oN8n7MM/nIqIb32tvU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=XfVmYBfJ;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of alex@amutable.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=alex@amutable.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794904031;
	b=i88Q1JrY0CwpBHqkMYcrwi/TYZS4Wsd7y+Hg6H7aVhvMOqYqxpqm2oBtvv5+6QJdIUrK/H
	a8QZMW/W/+gJhLWajG8hs2meuZmFLgy1kR7O4mkGCYBBb5RVoxzUAaCAYKSOA4IxXeN1Gy
	fAX5DnIiUOBYrCXgXtmk0qkL+MNZPfE=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4b467581b98so38964025e9.0
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 00:27:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794904030; x=1795508830; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=o7Ds5Sp5DChQJ6GHa3pEkVZuOErJkij7LbLCUPT9+Pc=;
        b=XfVmYBfJYqz3DrQQFoTuG26PbkCSxgztUHZmReudEo0dD3M/xlhZQxycltK6UJBfet
         0NyKTN8ESCvvOrXkDnVcJMn0ZM1bHBBzSvSW/jqjd8BQO+FhlkslAFVa7deVDnoLdPHL
         s7yRUmKrASnvs+qHD8gu4tu3/h8bQGm6SQr27TxkdeS0Mlscilp0Pyo69c4rZQsDeNyb
         o+tiKPcmHatEtCfrPT9GIVTtBOGHpH/se4jhThziDXGC+Ur0dfCDhL7GbSbKkDYqwCtg
         4PRziZxA9+fq8bE9u3VYESxRSqMQTsTeWrSJRI5wnJlcoGSLhJmr92geyVUx2T/1ooEU
         zUmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794904030; x=1795508830;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=o7Ds5Sp5DChQJ6GHa3pEkVZuOErJkij7LbLCUPT9+Pc=;
        b=xzhYSyrDt5mKfQcKFUokwhlOSd2FRKFN0uk8+niLPPzXQG6TddQZF+6lKk7xIwmj1Y
         ivhAX+4ByxSSuqK+BHGiqAUpKFtnO71MqREsfj5AeLLHvmoddBVphjgOIy8Qx9i40Tql
         8V9CPQ+K4bCqzuNNdMaKtEjUvY9xoQTKtnmjqyA4harzXe86bYS4GfFLybz8vp3EVoh/
         05FwkmHDCgtZsa8E45Vdm3LEWywfP0miw9CwsUFid4Au/O190tU4XN0MHytNNYYozCN2
         vZ9OLIJvVuLxWCI1W0B9w2vvaIqdXPCQZL53ieYR/vqZKaXR/49AwTrsC6ZbT0SZ6oZp
         aXbg==
X-Forwarded-Encrypted: i=1; AL+hErHWGSOeWK3vJXTQ+ruDmBy54DJ1JTY+u9cQsyeeXF9k9/wpuGWxThM6ZsnoIFDxU2+Zv+7TlVNcJw==@kvack.org
X-Gm-Message-State: APuU4Z+mvs47nR2qOclsW19/rba6f0spPAGYLpK2jyAZiF3lfpxPfoX8
	evf1EnD0G8ejsxDM0uXsTZfLx3s5TdXoWqcvM+KDuhOkBmJwvLAJcYppdLGO9WNMBu77
X-Gm-Gg: AYBFou0EkyRCb9RNQKWEPrWcfel6h3PG2iQNN2fTKPYPsnN8xCA07sYadaYQSo8AbA0
	nIZ+NUn3boVfC15YKEvOa26b6q1UzeXY0DhN+PF+wNyVwRgCUNwWqITK3LYLei8WWzSzIqnGMzv
	mh2VejGABCgL18+q9yNm9aGCOSNF9NGmGyNPAv1CRa943yPCf1Zn5XgHGfpX3e524eDcH7x5YKv
	n71EMWn3cnWAEdHnOI5oXvdNvSPxI49dzsqKIA0ccckqbC3RMr5HidEYYwkkQ5Jp+hMt2OeLiYV
	FKHDsbFyIgRCFvviVTFcidsRiOWf2SMoXgbBM7V1glFsuD3SWpaSCShrHm1U9VUBXl546tRVEsH
	9SYIzdsApCggp+kNIPvedwzKmtf5onCzZzrTpU8yrS9vngn7rY0ITlGpxQgxawp0Ucam8MaCMNA
	KappIfvc44tEesKzUnnW3cL7WC4EcQHkcPSkas2Gc5B6w2/EDV+sA4JarwsqqjENg/4cQk31wuk
	0gzigVDOSbMNn3JtWktlg9LVuvbZp6bzhhoRU0Xl90NI4yjgFPq/dhDooWSzlnXhtt9llVxhbAj
	rDnrxyCrfpTEtwQiHIlSDNmQ7S3tt4sU3xx7EY0K8LgzEJggdauX0MaTfY/OS3RQWJhIAz5wOUz
	8FT0q65yGzxYSf3qA0ZNfBPkP3J1/tCfo2+NRJYRI/uTBP/AqkC3RIXgy
X-Received: by 2002:a05:600c:3494:b0:4bb:6c71:b268 with SMTP id 5b1f17b1804b1-4bb6c71c232mr134135095e9.6.1794904030378;
        Tue, 17 Nov 2026 00:27:10 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:de4c:6789:33ce:97c2? (p200300cf572c2800de4c678933ce97c2.dip0.t-ipconnect.de. [2003:cf:572c:2800:de4c:6789:33ce:97c2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb7838c912sm45730155e9.4.2026.11.17.00.27.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:27:10 -0800 (PST)
Message-ID: <0ec7b8c90cc456b24e5b19c1db673d497ae43735.camel@amutable.com>
Subject: Re: [PATCH RFC v3 12/44] rust_binderfs: use fc_init_pseudo()
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
Date: Tue, 17 Nov 2026 09:27:08 +0100
In-Reply-To: <20261116-work-loop-pseudo-v3-12-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
	 <20261116-work-loop-pseudo-v3-12-8cbbea1cf34f@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Queue-Id: A962B40007
X-Stat-Signature: 994s4e4qr5etw7h3ixakyrfniikukfr7
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794904031-307792
X-HE-Meta: U2FsdGVkX1/kCsrAWdq1ln8gsl3zYbYQP5npMT1CxiyxWf+mxO2HTnDrsoolFulwxXsbvvQuVD78ax8bEt5w1wJpBHSkYb7K74Y7mvZxcE7NMQnNvu91mdFeJo0kgfV1cKPrKl1pRjBTEE23khje3MyCOazDEGeE+0SrG7jLGrQ+XzA6QYJcRyN09jVvd/E8d5nUXHyncFy32isw5XMjQK2DO0GN0m0sA3KlTj2m0jI3KTUV3jsOvjTq2NFf/8UbudNSbtapp7YPvBKnXcj8c2LQy1Dnr0L9jJimqVtn457yHnIu2E6pb3erMZaQR+yg3lxi4aCBv7QPQYSu1z7epB+/tD05eKHh4kwihd9qvrBfCr9Vg5Gpu52tgcJdz42eYYA1oPQrk0ClPNRDFUOi3hb5wdH2Sx8r4vIrb0+RN4i19VdMfCRHpjxNed5Wa2SPjcQohQY7hX9sx8u0IiQepZuO76pcnt5LonRdeWxTEZR3dMHBkgu+FY9Ym9Q2zuNnizAqo/cEIkEUDUm4CZALu5p51g+S7UZJl9Tnt0HwqZMUNV2ajc4j20KS8UFyaP0teCnvh+JKpk7Z93/7TuAJQJg+8BL/YiapKnjQmyPalYeAK608ic0+ZAO05Gyj3GTRcfrcDQAa1dYQ7D8yBNWJgPnbIxL+qSrZchLx5ve1zLYsMXn+yq6ui/RhOPlNVXfkBbg/0TZfXaSLqVnzkgD8KSWtMZGDI1Rz9YYMJ94dyhjEZUgwo61eFxSBUcUrOLFxGVDqV+qoUY9gZKi49bNKZ32dhH7o8ZD0PbuWnquRAwVLcBX19lZbV+lmp/53m3otI6y7cQ5Poy5WX3Ge4rSVUz0B2OK97jVNkYEwuQC1zm/qmJ8E+/a4+XknMjxlzrR+goktxRUhAhvyCbyKQ981OhZ+OmMywMRTG+/XZe7U7Vr8Yxso5EIqsjK9ZL2bweNzeWXTvoeR+JKiLonw+zd
 X/+3vMYp
 4NtNaP0eVK5ifIVqhRr/HE1Ae8SkZ88f1j9+kyOBsR+73KoywKKz90ks/NKYLLOdjnaXNbDMBeh4EidccfTDQQmspP6ZaUU/MhwCF10PCHxpfRPpWaVNK5dkvlkXJV1Pr+s8Ul7gcxZjE0mUuHBzmDU+PrqBUu5nuqgjnTYL5+S+0cxAmzcDygbRtQc8LsTuX4O3rdWz82VoFYvKu1tut1jq71qKWslw3SqfGg3C+iXzn5YmJ/eENdy5JxKDFw5zQQW6cyyn8LpMHSMwLa5W7IEcgIhBse1GIMv0I22+cFfR7bl2A31iVnhqcVKrDK8JBAXVBuAFwO+1s/dA5xio6yzje6At3i2VhYqUFlOy6cx+OTNJ1fiBiws54GwPIIPvZj4UjgI7hpmJQ2Ip+ibibz5ErbnQUAAl+euNCL8GOm2zmLwkjQC29ujqDNe6FbycMsXAmUslO3KuYMMDRm1zN3mv3TzRR3Gqx/lFv9EO2hWDIx/8rK2l7rb4mwAivucpBCZy3UWzpNQVWP2drWfENLkh9mJKVcwDanrKt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 2026-11-16 at 12:04 +0100, Christian Brauner wrote:
> Initialize binderfs as a pseudo filesystem instead of raising
> SB_I_NOEXEC
> by hand. This adds SB_I_PSEUDO. binderfs_fill_super() keeps clearing
> SB_I_NODEV for the binder device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0drivers/android/binder/rust_binderfs.c | 3 ++-
> =C2=A01 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/android/binder/rust_binderfs.c
> b/drivers/android/binder/rust_binderfs.c
> index 5f020226720db..04468c5b5c116 100644
> --- a/drivers/android/binder/rust_binderfs.c
> +++ b/drivers/android/binder/rust_binderfs.c
> @@ -3,6 +3,7 @@
> =C2=A0#include <linux/compiler_types.h>
> =C2=A0#include <linux/errno.h>
> =C2=A0#include <linux/fs.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/fsnotify.h>
> =C2=A0#include <linux/gfp.h>
> =C2=A0#include <linux/idr.h>
> @@ -667,7 +668,6 @@ static int binderfs_fill_super(struct super_block
> *sb, struct fs_context *fc)
> =C2=A0	 * necessary and safe.
> =C2=A0	 */
> =C2=A0	sb->s_iflags &=3D ~SB_I_NODEV;
> -	sb->s_iflags |=3D SB_I_NOEXEC;
> =C2=A0	sb->s_magic =3D RUST_BINDERFS_SUPER_MAGIC;
> =C2=A0	sb->s_op =3D &binderfs_super_ops;
> =C2=A0	sb->s_time_gran =3D 1;
> @@ -759,6 +759,7 @@ static int binderfs_init_fs_context(struct
> fs_context *fc)
> =C2=A0	ctx->stats_mode =3D binderfs_stats_mode_unset;
> =C2=A0
> =C2=A0	fc->fs_private =3D ctx;
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &binderfs_fs_context_ops;
> =C2=A0
> =C2=A0	return 0;

