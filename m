Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EA86606A8B7
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 10:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=F/eBIuXi
Received: by kanga.kvack.org (Postfix)
	id 2AEFA6B0670; Fri, 13 Nov 2026 05:03:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 259186B0675; Fri, 13 Nov 2026 05:03:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1479F6B0677; Fri, 13 Nov 2026 05:03:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D789A6B0670
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:03:44 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6B915140597
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:03:44 +0000 (UTC)
X-FDA: 85429659168.11.5E15229
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf06.hostedemail.com (Postfix) with ESMTP id 83F3C180005
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:03:42 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b="F/eBIuXi";
	spf=pass (imf06.hostedemail.com: domain of alex@amutable.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794564222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6cN8hpP/bnwcYzPsZf0cUkd2pk5Vve+UdRh8Jmnig90=;
	b=WpVRa88Okjdpeaf7ahhPfZ0RC1fhSLWdBsIqRbyEYqvQbnaPaiADz2Qm0FkNksHonOfCCK
	d/kaGSprf+VcbJbRFz9CTD77DCO+gOzrUYEZ8Cszvg159x8W7OAqz29+d6zu6cuS4EGDEt
	M+xlzPnQgbzpxsEBHZNIiF03keIlNl0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794564222;
	b=MVYzUml4/l38oesmIil8Ym+f54my+LNClnzpQOs8GRAVnVirIFzHJ+J52eAkL1F3y1mtUj
	OOlchoH5KJNGyPVYqEOxpgiQ5FTmplWEpF98ZJ/Eu0KP+zr/EQnh8RLIu+nkR0R3Ir2I/v
	ho4oXJDDtleDzmjtdEgViy1jK/8PPnk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b="F/eBIuXi";
	spf=pass (imf06.hostedemail.com: domain of alex@amutable.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c40e30c26a4so170617666b.0
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:03:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564221; x=1795169021; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=6cN8hpP/bnwcYzPsZf0cUkd2pk5Vve+UdRh8Jmnig90=;
        b=F/eBIuXiDg7EHU/9XsQn94JYvHmCjmxmR4nW843ImT/fpxLkBCYr6QnAmytTBOpBw7
         pyIqvxTpVluDZ74YVNs80rJlVoIzRorRB4FAw7+qg3Ov9dT/xB8WqD9Eh0aOR85449cQ
         X6DkZJAaK53nt174/TuRdTqOgR56TkmakZQ5rXaa+/XtZIavsoDWUd3djhQL8V3f7UJ0
         hzyqkhoOaXuNyTxVXFXIFvgWt+XMLOvYxXo3keePMw3xdwNQgxaSQ3M91ZjxWrWcCSDc
         9u0ZXH9Ph/ReCwHClLz7by2jXNu8RZwhNe0YTlkL8pSZ+xTJmqJt17Hs361gEUlGIZPL
         OOYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564221; x=1795169021;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6cN8hpP/bnwcYzPsZf0cUkd2pk5Vve+UdRh8Jmnig90=;
        b=vaJFucFXevn+43KQsxNQp4ad0CSbjK2i3z+kBPiFwp1CdEwFfeymrJcsuZFADhOjVq
         45puyG/Ftx3g1T+PQklLvEnhpDa0zvbXzk3vW4a03vB1ZetkZHf4ncwmIlNSW3BkvU5l
         fGznLAicHgBzxoiogWtfO/SGl76ztoCXW0KMY3sQr5kz9Fen7ZGJZO3M5v2eD6LNFFet
         xvwXXJDt5chcoMY1tm190imyo/gUjCtXzE91M2T1GT4u0T4Hq4mobPmhW1jhgY6LG1qe
         Fgv1032hqBE/FHba2yHww1gW+UmVVBTyjZUthVuUuNiKu4PUDL3E6T3L2E7G7ARYTY5c
         q87A==
X-Forwarded-Encrypted: i=1; AL+hErGHKsGk++f21geg7a3ws6Hgkh3aqJmirJaVQ5sHh7Hi9nixLZNebHfwX0mmDSp3OoTg74bwjOrLog==@kvack.org
X-Gm-Message-State: APuU4Z8L+tw9/w1Dj4qX1Naf6Y9lx1V5czN+uO8I8YEVYRu8jr2Zhqt5
	2hu97LQ8765cM1PAGG2OgsWoUknRxcq4fAaQj/Dfy851EtTL1GS08n8X6AFgTk2POz5P
X-Gm-Gg: AYBFou2fRNbzC1RXpvgJAcMm0YWYf1N9wwOj4/+ApcfP98SCy1Q11irIbj1OcVISqxy
	JelJBhdkkoTOZCH9u329YIleMW1j93lw/rupvgErerCvE6rPJ5cIJ/oHE+dNuLTgdh/AmxOJHyd
	zGwJIzGCDjol/9bgktRgm3Gbj3HnpkrdvJpCsFU+Px4kdrnq7Yojww9KoHt1HKjPnZfmznjCWiD
	iBGMhznYCSB4r1jNThMym5XqRlsTcmBbyZ7tunUQA0CqP9KWOWQ9whYu4DtPAlqHHA2tQnC5DqR
	AjH2CJukknja6VO+Lem1MZ8hviGlwQYmTXVoFIVNZncDp3IMM/KgIQ84wCLYFSgr/ujzFX5kBRj
	oex5AxzYqLLNRF82qGpQU4cT2INATuTYEWedrsa9w1+QCRh08RJZ3U+Szb9ReF9TBzvM+Sc5qK8
	6d0FMDH2atJXEKGl5n5K73If0mW2rQkl6kfhTstVjOJegGx8r5wpipArmhPd0N+WzJuNmbdVhC1
	USgg5z9anr7UQJAYgGDzvqjzDJxx66g0iiMNpMcJCVK/MER4WqAyPBFw4t//gLkvnqioC9jQmpX
	iwctlwg1/zuMHfWFhAPclRMLgKKZD16rCIu828w4PifpoKoDMvy9a90JBXmalFs=
X-Received: by 2002:a17:907:7b8c:b0:c42:bc58:f21 with SMTP id a640c23a62f3a-c50963856f2mr175546966b.15.1794564221164;
        Fri, 13 Nov 2026 02:03:41 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b23b3asm74752966b.27.2026.11.13.02.03.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:03:40 -0800 (PST)
Message-ID: <cfcbef5caf7651b63774549fa1999d34981c78a4.camel@amutable.com>
Subject: Re: [PATCH RFC 09/41] bpf: use fc_init_pseudo() for bpffs
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
Date: Fri, 13 Nov 2026 11:03:39 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-9-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-9-4c998976c6c7@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Server: rspam06
X-Stat-Signature: u3n9fnd7bb81h4ftdw8ktqpn7cgyfrix
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 83F3C180005
X-Rspam-User: 
X-HE-Tag: 1794564222-703946
X-HE-Meta: U2FsdGVkX18+A8LhgYsW3sJFEBb9O0xANzKNf0y7CnmWqR5JAMGTPVNh8JpoIBLCYogdSCYTsAmGnAdVg/11mfM79eDHv+04nDKWk3AXeysaFquS+f6unkOfLPGsv/49S9wp8hpYIzqRhI7fk5zJZPBP0kkJP8TfZfnD6rqSyLdbBf0ak/7wILrvplerwc40eAsdI4v/vK5x3hd0kv68CK4GNAAir2vaYmg+fT8mX7DsH+Go4l9B3wl6Cvh6Y1mbkciE287gJ1Xv99KAieGiAfRHtacybfvODNwcIeXqDSFPJ7Rq/KlgrP43AJJxDypgYQ9rQ5dAaYvmD7Jx8FV04QqI0vorpn3XxbrIl+hxfTazm3hbKcWW9Seqd9vN+rcPnc6y0Z9/Go8MhzjFCiW4TzOTRmaGLvYeboN/ROufpf+Tu2/DjSm92o4XqHHoSoWEGi96ZonNeBoWy5W+fqFkU4qxYJMvf+U4jlf/jlXODg95uo50itYMGEbdKFqLdemFTGHjH/JXHmJa7ThRkl/K/fSRNeNcVXFNT0Kq6AQUAqF608EapJNEUQc1lzjUO40KPXviOXYXLbR/CNhdKgWBylsutqGdJ4aI8qUgHLn9Lv3bjiMWKBRDCM0MpxdwhQdXnBgGp3O30iV0QvZeL6VZ5ATJf0qctpslMk+k2VyijP6I3fI0JnnlUQtU6B4KiXkm32w7K902SBlBUkrmR5s5pzW9ig/RjZGYElnpF5kEp2lLJnyHzkE2fAwe82LgeiT2MkllVz1j6FdygFPVbHTctiebtscXxpNCfwKG+/nP4n+o8ahBC4bTu2dcMW4+mSX+n4WFQlHo66NMz6XG+J3dtzKRO/6quIYVB4oUZcQ+WaTYI7qZ/PhWMSZt5xEgRBEXdrl0wFr51/j17uow86617awcfxV8sMMvB4OpnwNcNfrzlcYg87mHEZSMj/jXKegFGif+dFVi14PnPUzS3PP
 ZXXCNlc1
 iEpVOx5QdTlvTMxL5eBlq1SfXsRLSe1vlUK9bjJtd2yKS4iXveBcwuDSOs+vsTIPNkgESvnbHeoilwcC9Mjk1/5XzKUX4GDFNBBb3/VMj/lVgq4/kGkJge30t3vZuqo4afpW96WLd1c2wKdaj8ErgNCM5yeNXmt4k5rU0M2I34giNrMnzqUDqEEH3ATgTAU6w2/3SxweahdMsP1gUnNciDhcsq3+Ou6r2K5dJWsv0xUZI0d4C05sNHMiuacF4D8g4ZBs+aA4AhMl52giDYajwJ4M2JN4VsqU/K2ku7pln5DpZPn6p4Oq0dpIDd0S0XQbesKEl4iULbORevYM3WQ/2xHuUjSNuyciZzIbWradnNrXnLt3DUguVZiaEa4zy4QbPRz4pPh4R14X43qfMBe4p5prNi1VknXnEPRQ9SwWBoIw0XZopLebRCAWe9f3GrcyyfpL9mEjYGeO1RtJ26UgzP/iOe/ItS9L/KQ9Ne9VOXCxdFv0p1tvn6DBMsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 2026-11-10 at 10:14 +0100, Christian Brauner wrote:
> Initialize bpffs as a pseudo filesystem instead of raising
> SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0kernel/bpf/inode.c | 4 ++--
> =C2=A01 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
> index c6f328e4752e..57cf3775c076 100644
> --- a/kernel/bpf/inode.c
> +++ b/kernel/bpf/inode.c
> @@ -15,6 +15,7 @@
> =C2=A0#include <linux/namei.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/fs_parser.h>
> =C2=A0#include <linux/kdev_t.h>
> =C2=A0#include <linux/filter.h>
> @@ -1197,8 +1198,6 @@ static int bpf_fill_super(struct super_block
> *sb, struct fs_context *fc)
> =C2=A0	sb->s_magic =3D BPF_FS_MAGIC;
> =C2=A0	sb->s_op =3D &bpf_super_ops;
> =C2=A0	sb->s_xattr =3D bpf_fs_xattr_handlers;
> -	sb->s_iflags |=3D SB_I_NOEXEC;
> -	sb->s_iflags |=3D SB_I_NODEV;
> =C2=A0	sb->s_time_gran =3D 1;
> =C2=A0
> =C2=A0	inode =3D bpf_get_inode(sb, NULL, S_IFDIR | 0777);
> @@ -1261,6 +1260,7 @@ static int bpf_init_fs_context(struct
> fs_context *fc)
> =C2=A0	opts->delegate_attachs =3D 0;
> =C2=A0
> =C2=A0	fc->s_fs_info =3D opts;
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &bpf_context_ops;
> =C2=A0	return 0;
> =C2=A0}

