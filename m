Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DF22606B11E
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 10:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=nIh28y/H
Received: by kanga.kvack.org (Postfix)
	id 122D76B0675; Fri, 13 Nov 2026 05:03:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0ACEE6B0678; Fri, 13 Nov 2026 05:03:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDF5D6B0679; Fri, 13 Nov 2026 05:03:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C88FA6B0675
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:03:58 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 65208140572
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:03:58 +0000 (UTC)
X-FDA: 85429659756.17.EF775C9
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7964440004
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:03:56 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b="nIh28y/H";
	spf=pass (imf07.hostedemail.com: domain of alex@amutable.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794564236;
	b=6DGRWMMv36+xxOBkdJBu/Ue3geEqnT3zZ6Qo8ugMcolOt0FYrO+YmWqmwiL3OiRYnI8myA
	n6fxy+7MHv2UTKXqmd89xBlpsfqwGu1OZ0iwMHeIOsSEf4zBTCepUK3xETh/ebVB74q2JQ
	DIWy1HduB2zSeJrrhQ9IsXuqVD0fnEE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b="nIh28y/H";
	spf=pass (imf07.hostedemail.com: domain of alex@amutable.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794564236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=isfwHOSFEU1THdAtyjNR/BymwB+TGu4CpGjFt5oul8o=;
	b=ePvidp8w12Z0zJZzM2qUmi7pa3OJs/zmZijdq8LWvWh0fDm5Y+KoW4JYGFlm4nNHMbPsjj
	h3MPLufTbv7PbnKHI+RUdUkpduzMbZiiLvLYmHhv2ey9uV6NbesNdUjZ7t9qFn4EYry6gh
	IvNEk89A3kXH27NsCjje6VmqFRpa7fM=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6b704171bc9so1238362a12.0
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:03:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564235; x=1795169035; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=isfwHOSFEU1THdAtyjNR/BymwB+TGu4CpGjFt5oul8o=;
        b=nIh28y/Hnxrw/w1FJpXhcrAT7DaXfOik1jTGNoAD/x4gM9AaZuycI0mYz1XqcsxePE
         nvkQ4IqYJW6eRegezdzbJmaSxcpSSTOsCZQmyQPGLefsxbXHLinQAniAX0O/Ke30LaMY
         7GDBYyo8g9OEgPQWERtjAPZNQz44l+E0IwypDAtfNOFYRs0xsR06ux5v83Y7dpWymifI
         UgG9BNzZ856bY7XFgvqNASY7ffqJYoztx6vGCGYqpXVne+4ZIXMso/LjuTO2724x5a1a
         HjKcg7ECJ3DqTXU8H43lPbmFKpzQpBMglQzbab1iUpWRJ4aNk1q4CVR66AKzgwpQx7JI
         OWgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564235; x=1795169035;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=isfwHOSFEU1THdAtyjNR/BymwB+TGu4CpGjFt5oul8o=;
        b=xNMZm+fEG7VN+INncUThEJHvoM2t9N032ndm5AToibDN+ocoWckt0Y+4Kd39v88jFU
         lDUwOyjEY/yz7/H5NIzXI9ywSE/kRC6wsMEiov4cY/KVnAO5bVB8dKy4Do1faQtSPmfc
         tXCQ5PsQ+qH1Ado5pJxD2qZKC2OAB0VXl1LXGkcbISjvwFwjNKBv2YXW6ocnnxix+/95
         CuAfpgZr4kzJ/tSJ110ufSRAjswxXjsOZROLQyPlwVdsqnZO5QyjB2zXiQfcKu9eaCE8
         3l9nw3+tFnp7sGA29S1Xp55kJO/lIRf9497+IuooH/B3a8S77BdLxiFvWMXqauVAXgit
         N7JQ==
X-Forwarded-Encrypted: i=1; AL+hErHc8wPz4X3b6nmLlJOi3FBmczadGtPaE2KNakMmQ6OF9uLzudolxlrP0Em4cpyFt6RbAH155pswIg==@kvack.org
X-Gm-Message-State: APuU4Z80ivApdcN0dqcUrtzmwxUlb6LFeeRDsCk6nQs7vWQ1EdnBxqeh
	PGv2JdAvKlyBVGTG1txHd4+r/nplctISVMudVLQk1xKLpfwGDlU+UanG2+541iLkQTLR
X-Gm-Gg: AYBFou2bxVsNojGwY39TZwj4Dp+ayE/6xHPgO7MZ6lbDtACmTQ2nU9Uyz7spXoB71iV
	V0q33v2Gy2gv6KqLBD8VDIZPWeohdFnW0Sa+Vc0DIXOXMSuaBAs6qxk1C67X6Wyf6kEGv+XTy+6
	St878GiKl4EPvYVAxm55Z5QR8MdHESdBWd561QajNViPLLc/h2ihU7Fo0o//hnjab3TGYRjiszM
	Jzn/8lW/opQ31i6dVoonaVkmZZzeQ8WB45cCCmlsWo5oE4AgZUMFrJtfN0ZC8JfEINmq6mra7Mh
	ooEyZ925ORL3Y0hg2HSkjhdZ3N8bHnw9KtrRW0BAbX8OhxAXAMFM5VafbSBsRedYE2L0Quea7WS
	h3rYtMsg6uBFOfKKItpV11PzNEhqNlOEM7XK7ncyFhDk8G7wcwj2A9IzbCAyKxog+O+o26p46Rv
	fOQCZGNuDoUQEPVvrTkJjszN7AXwXK/Wpee4TF1PQOWH1/Qiw19Vh0NjzZbpCXlDIpMTxbCiDFl
	PQ43Sm0iPOI8NAUWsxPgo4uabJvl7LfcOehMgWWdFb6IXMRAxRSb2CXuv6/4iixQYFB1K8Jwgy8
	Z1OvCxH+HwaL218Rrgk6QM16RmusbD1Nn2skwK0vrA7MrpVdwVWNgVGArmjtzr4=
X-Received: by 2002:aa7:d556:0:b0:6b5:96e9:ae97 with SMTP id 4fb4d7f45d1cf-6b7c0ccaafdmr1234919a12.34.1794564235160;
        Fri, 13 Nov 2026 02:03:55 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b7c23611casm766458a12.9.2026.11.13.02.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:03:54 -0800 (PST)
Message-ID: <16dbddeb5cbb9613dc806b43fc681eb26aa3b0dd.camel@amutable.com>
Subject: Re: [PATCH RFC 10/41] nullfs: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:03:52 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-10-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-10-4c998976c6c7@kernel.org>
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
X-Rspamd-Queue-Id: 7964440004
X-Stat-Signature: bpcyeoaqs5nuw6qubb4u7rrjpbpam6ek
X-Rspam-User: 
X-HE-Tag: 1794564236-125882
X-HE-Meta: U2FsdGVkX19Ztmuu9hR0nu5NLBgStB9uve+I9mjGeWdgsDOXwaxAMtoXDfoUNfMPwrwzHG9bql6jLK8Dbip9Z/Pdbz4Rjh6DdQiZBVtqXLV4bKnw/7nKqXo+/1ziw/ldHG9MdRUgGn6aWoIrZXtlpO97d6lPooJf8QP/XUNwrs8VHBFSK8dqeNLt3P4R0svcp/trcRODcvb2tfUtndFTo8NeNsF+211tWvnrWC7IyqBhkQe+tWTCS6wfN/s/QGjc1qqD3KljGvRCykF9ppZpyxbEEJXbyW3ocAr8vUwl+hDz1JEZHc1GbsdJ4Nrrg3cSdTXFKmmpKdPnYUjbBnCe9UUSl/DAWRrcgjXTTUBXXXtKp8fLdKa2S1Cngg9COxPvL7QXkl9X+x2o2aDHIjm2yFW0MJk2LwRt9KScH/UDfAcKOyVTPhTq/gYogAMsxqF4fhy0PfqCl2Co4LDFsLx7dxw8jFExaz6qruaevrKw63EpyKu6ekYg0fHp0LqF4+ugf8vgtjCart9hzGKtnP6fut+QsDWZy+TCZB0qdXZVEtvt/hhaz+WZl5BDMhcik1MHKkljfBGw6Br2fct444o5WfMTT+I8Y/1L1G49X15iR4Ud9D9P/as9C7f0xAW4DWrBvLn+MSKzsJNBMR0iubveoobkfxMDUtLsmzpjabrQ9i6R502dB3/SlsbAckl9y3uej+jD9BBIe7id4rxZ6t3eadFKMkGyiHd+vqTa0FxO8nsJx4VbvnnlhW6YGauf47JLcBUkugV0Fb7kVOQZg+v2ybPFxdr1OPRuZZnBWt0JKRy/ITwswg/aqgRyYAkk6gTQ+B07rYOZwci7jEN5b5XZ3tOi5kOqoBBDVYz5x0u+lM9Jx/iubHygOYNZODFyvO0NvNurIRKJMFknIjhxmTIWneJCgHwSC6+VRt9Y/2zymJTGr7JqfUNovwHV03smWm58ddTbPDbEseYKIFIyu5I
 1DZDk81Q
 xFhcLLQ8NtTc1/TSwz7PBOxtq1Rz+fBSZWYA84sTSXiGwiJDMfvtRCR06EJlqzreGs7J3QqY7JJyyKHbrvbJIM8H8PAYcy/iKK1hpyqx6cG8DP/CE2OXdlnr1SVjThW+sNZcUWnvnSzBXJsoysU+lT40HuvUKicRxe3YiRPnw5djTsR1fyCa1tf7Q+j7XuwbKeUyRp2sJVBsjaRDS9CDDYVbEIGkabnzw9F+SYPrUVHRigGF2YO/b1YAvVwlnQwgZgthzkZe+8bcs9y25QT5cemWRrcWLudiuw3O/IcCA15kN0GsJKs6eimUkbaas236wC0ltMQE0rvyrE5la6ylJ7jbf/6tx/Kng2TGCNpw8oNA6eWZcUE6qfqOqci2KtGTaQQkVfZwCC6e95PeqkHgIyb1Pf+uhqYV4k8utvtzQHa5noIHmHTdXDI3Vzae1uyO/ipMQJYt3KQy3pv2yEH0LziBbvI02P3o/dKHvPxT1sVjmmcQYmjNj4UgeMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 2026-11-10 at 10:14 +0100, Christian Brauner wrote:
> Initialize nullfs as a pseudo filesystem instead of raising
> SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/nullfs.c | 3 ++-
> =C2=A01 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/nullfs.c b/fs/nullfs.c
> index 319c2f5c5a67..2fe24cb97160 100644
> --- a/fs/nullfs.c
> +++ b/fs/nullfs.c
> @@ -2,6 +2,7 @@
> =C2=A0/* Copyright (c) 2026 Christian Brauner <brauner@kernel.org> */
> =C2=A0#include <linux/fs/super_types.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/magic.h>
> =C2=A0#include <linux/splice.h>
> =C2=A0#include <linux/uio.h>
> @@ -174,7 +175,7 @@ static int nullfs_init_fs_context(struct
> fs_context *fc)
> =C2=A0{
> =C2=A0	fc->ops		=3D &nullfs_fs_context_ops;
> =C2=A0	fc->sb_flags	|=3D SB_NOUSER;
> -	fc->s_iflags	|=3D SB_I_NOEXEC | SB_I_NODEV;
> +	fc_init_pseudo(fc);
> =C2=A0	return 0;
> =C2=A0}
> =C2=A0

