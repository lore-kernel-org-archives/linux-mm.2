Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2C9460A5BEB
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 10:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=W4ERolZj
Received: by kanga.kvack.org (Postfix)
	id 01C566B0682; Fri, 13 Nov 2026 05:06:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F304C6B0684; Fri, 13 Nov 2026 05:06:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E45466B0685; Fri, 13 Nov 2026 05:06:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BFEEA6B0682
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:06:19 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 670431404C0
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:06:19 +0000 (UTC)
X-FDA: 85429665678.12.776CCED
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7901F180007
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:06:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=W4ERolZj;
	spf=pass (imf16.hostedemail.com: domain of alex@amutable.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794564377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oBVCWZMOabVq55k67Q8GIm9NBAOJHOxllLRlvncSbis=;
	b=ubZWXrm7/4zWY8MSdkbPgg80NuxQ+gCc67Xx6j0RLBHpUX12yGVnlLjYKd5Ax3hd9ekJip
	IHy3U3x5icZtuKyTc6RWK9jfZjPv+UwERCjQYTnnvKYtEGcN88ZJw4KJnb40hwCBxEWqFB
	Cbh+CJmkWyOtzDIVjhlAnM1Sy44NO9A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794564377;
	b=H73878UjUuBJJJQShjhwCWiT9lsyKiHJMisfwyZcbi7J+AjcZcWuCnc3yhfGRsI/aMP8mm
	aD8sGzfdk8+gDb+UhxFpy7Ec1JOIKJxCBEpOwe5trA4dXr8Ec2Z6WcYo8jh0dZbCW24PtR
	gmcGa6R5CyqibOdZgSi+7FiOpRrN1YQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=W4ERolZj;
	spf=pass (imf16.hostedemail.com: domain of alex@amutable.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6b6e8b6d424so1596902a12.0
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:06:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564376; x=1795169176; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=oBVCWZMOabVq55k67Q8GIm9NBAOJHOxllLRlvncSbis=;
        b=W4ERolZjSGy1IPxNXEIQb5MA5BwjlQcLm+LTf2xYZKGtdyTMiQZt8L0FpXra4efljj
         4FseTiS10WWSzQbVMxienr+9HpT87AWp3URVn6gV/DZbLwHLkCw0lTlV/xAKpeSd/8Pk
         JW3TPltV+llFMZVxNuppd8tXGuFrjxNTQlUv8+WPB0akq5C11gBuPUKkEs4rfO/n8AGp
         g3kC0PlO95q/xTMRCKqaWy5KmSVX3JspFOV4dMHOCZ4KiiTngX8zSDhI04AOg/oChHm3
         exZvPlnRMvLffWtgi9SHqh17dDW9tg6v5rmimCQAx2hnCGy73ZxkCA3TAc1fGWonPpBg
         aNGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564376; x=1795169176;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oBVCWZMOabVq55k67Q8GIm9NBAOJHOxllLRlvncSbis=;
        b=g/UdP1xl2qWp7OvY37IhSjhLuon94QR/79UKScsMRPMxnGYIq8IXFuNSBhejvMZeR5
         zaLtf8dwaFjR1r6lpG+gkEuPX/kotVO0woe4sp8d9Yp1TLniR/LidJjekO3jwUp5NNzC
         vlBwNRT8aEnEV4a/TFjGzmvcTWmQG/N9X4JI6VULAwbUoco1h+PIuasL2c/fwFAyAnLo
         kjFQl8UrQ9HTQrgUXwq10XowISg+euy+R3oeK6cMcOdDnncoB3ZoziHAoyp9GATaN9mT
         GUMe3QVtTZi2rYEYKj1rVv31QzkJDhTL8ew0r+YY8z5il8wsVSeloruhIz2xUGqbryne
         CPwA==
X-Forwarded-Encrypted: i=1; AL+hErEujEO8lyufPuvnfJloPm9HTt1JKCfrvcTZfpiyxbjizUnXv4jMGnWfwbrwl02aW4a/aBFciIw7TA==@kvack.org
X-Gm-Message-State: APuU4Z9YF5FSe1nrgS2RXMwOKvjWB4wUekQZIo9YNHB8GnaZByhCBTUD
	eaB/doDhumy5T2/oAz1ylIsNmbnpIWqSmHGKVEYeqoCMcWwGL5BVvmmWxvDDZj7XZNsf
X-Gm-Gg: AYBFou0UycInveVhlNfF7hiKrLX9Pr3a2tWB5rIHuJaMHpINYE7ty3HIZMw64jjF5Zy
	L4FCShpj+TIi7g1pniz5aZvVNFhB/tLDppGCpFx0l3k+b7apvAwHTI1wnyWYs/mxgHsa8BcK8Xl
	ru+6LSC23niVQ5fhHaMVa+3fjbTBJBtItZlC+2If7sMSoyWTVYiGw34wWIFPvcmqpXyqtkIhNy1
	S+k0o4sdtThOEXpquKzGnQCngDV3MOzja20ARXyvC6PRcWcxXLkiAXWkll7dFAFKquurGjPaDz9
	I/BYwGJmvT3masYUQS9xjR1FtWzb5tmvpXTbuJWzCA1VxWIMSOmY7JBZJ4/GTYnPyB0fDspnPCt
	QmQu4/EsGIHWie4IfCkWgXFvJ2s5Zof+IwEkoHps1u/Yam0Dp83YsT0dwEFd/syv2UuC4tNYb77
	nuQ8pLhq+BWlAlSnP890f0uOvTAVq8/TDp95ssTniIkTr2iPMEcICE7MOVDxL+nF8bndmqVVcSV
	RBW4PV4EAkoM4LYPdq60BjynGX/5B5nUTZEW13erGQUVKPD5sZmxOJhTkS2nHWGk+RDncGK70+B
	7qY6ik7lOx4EurVCGqIJEe6MhnfbSb9zZTHXbj3GUCjSBck4YVmlOazFKSzXOWE=
X-Received: by 2002:a05:6402:280d:b0:6b6:4dcd:967e with SMTP id 4fb4d7f45d1cf-6b7c0bbc394mr1685420a12.20.1794564376161;
        Fri, 13 Nov 2026 02:06:16 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b7c21b1b5asm706711a12.4.2026.11.13.02.06.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:06:15 -0800 (PST)
Message-ID: <4dfa19dd41ec1a202182284d9617926a259288a7.camel@amutable.com>
Subject: Re: [PATCH RFC 16/41] configfs: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:06:14 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-16-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-16-4c998976c6c7@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7901F180007
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: i49khf3wnknx9fdpfq1z7xnb83fhauja
X-Rspam-User: 
X-HE-Tag: 1794564377-278058
X-HE-Meta: U2FsdGVkX19ZSVLl/Zb1l5aASB1TytXwIz5GBXarXiaZAb+gKLor/AHonXyEEWEf3jZTUjQcAw2nQxkea0jKajjsOMgkeZsGVGccJqMzaGBC8/upeLbbRTBPx5jXoAHZGpC5uWJdl4XCSouAamMJJa4IJwfqXjcTMLRgcgE8qylyl1+Q9T2ijkq7M1ncVKzyqO2zUPSPvGZzT2YiAzSAzr8e1M0UCK5dinaJpGGooK/g/91zBu3eA0RHgYd7pPdnGOMbgYtiMDs91XWABeW7Y7K5vPoJv6F+TuRgVjGukqxEWtShdRKbgZlbo8Nn4URi+vOnAiZMVHjLtJK1gk5/VCjwUt9vEW0vagECCYFqGti+k+cx9IZZsChHKwnJsuaTMp8e4rHhvmUdF8vyr1QzVCZnN/qCACjjQNRhKbDMY6qmDoSZN1/rS5bfqhJabMZ0dtETH6exleBLOHGGFKfs7fXNL9NzdrPiCA9Pt5qPJLxCMEOyiKNE8Pf8S0Q71Yi1jabXCEu6TO/MDO/eKdq6UpRZe12AmgeR0zTuHXQ6nUdk3yhMJI66Twv5vg23inayGazPCXTNJceYVIHUlEhKjM20fy4e+gy+whH2Wn0EXe7sJFdnfytEpX3sOIdTxf9gwlza7FfSDx0CJHb9ntgBYz+IwFAetS8Tree5txnwXta5HtsvVbzenx67KR9nE0hi8rihMsp4DVd1jyXwqaP9EUR75+rrCj743YM6VObZ3rf5QesjTZrX1rZS0KNrialBtVqEemtiFhgHnchGlcKMk/PfKRh1Ug6PTOx1Q41vpVtHBV5Ii9uhx2uCZFNt3b9LZZeVYMNn5xcAxGrEcJt1LEyd0HJwEZ71NkbnXrd6HJWgaSsybcqpvELuTkmLv/TlMLp9R0QLwjug7XIwI/GqX3dD8MOEHmY8yKx0PYK7phNGgdiwAqK4fJym9Ln/0jDw3qxLJO6Lm45bQoGTw1H
 uM6HjVXF
 2Q8D9Mx4v/HTUdm474sQb35zvAbbhU8vL7+eteJ2TCN6MacfD8IaJSRnMWf3tSTafEvX2LXQy2qNM4xEarNfVA957fNTzFbd+2lUUQk3ggqLB9XNToT1iRfSjPBwd9uG7iaIijMfNlvBtwGI0/IG8deakjoKzxlbV19md9hM74pAhCxvZrsYEEtrRDb8RVM2XXo/2hPaC6lTmH70eGljSVKLJjgyw2k4gZN1l0ViwhZFnneMIolmW5ip+ELgWmt3tPAbD0/qfN2qbnNgoIXGEYGLcq0rYpqc5WorctEfxjSJqdpsvS6sUmXerUj55qS61w7lnNyzH3u6ffnEBcswVYQ1zWjmw8Qbgk2lClZ0GDz3cDYeeT7KK7xk4oJmdMupM8gCFMY5Ek562sUl6O4iNhlysiXSgnDufRlXhLWyzXKmImJYBdC4O3cl2dlj2VOXOLQop2KSaiDK/2Bp+zFOsz0ibXhFhSGissVzfc8cQsnFH3/t+vovM23Vw0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 2026-11-10 at 10:14 +0100, Christian Brauner wrote:
> Initialize configfs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. configfs never holds executables or
> device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/configfs/mount.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/configfs/mount.c b/fs/configfs/mount.c
> index d8cac1cbf3bd..60ba24e7ae2b 100644
> --- a/fs/configfs/mount.c
> +++ b/fs/configfs/mount.c
> @@ -13,6 +13,7 @@
> =C2=A0#include <linux/module.h>
> =C2=A0#include <linux/mount.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/pagemap.h>
> =C2=A0#include <linux/init.h>
> =C2=A0#include <linux/slab.h>
> @@ -106,6 +107,7 @@ static const struct fs_context_operations
> configfs_context_ops =3D {
> =C2=A0
> =C2=A0static int configfs_init_fs_context(struct fs_context *fc)
> =C2=A0{
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &configfs_context_ops;
> =C2=A0	return 0;
> =C2=A0}

