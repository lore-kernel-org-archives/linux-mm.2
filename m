Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E858606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 10:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Q4dh0ZJp
Received: by kanga.kvack.org (Postfix)
	id 267C86B0684; Fri, 13 Nov 2026 05:11:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23F386B0686; Fri, 13 Nov 2026 05:11:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 155C46B0687; Fri, 13 Nov 2026 05:11:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E30516B0684
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:10:59 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 75680140169
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:10:59 +0000 (UTC)
X-FDA: 85429677438.11.40CB002
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9381940005
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:10:57 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=Q4dh0ZJp;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of alex@amutable.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=alex@amutable.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794564657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RUn5HyOzv5zK74OCIfLVACQcizuS/sHn5qpIQd0Zvv8=;
	b=bJIqQz+u1GYRwyAyS/f7WFjZd51XgJ9pEpiBIh3xskOVL7CeeND2pw6+QqDGyuyQOZp6gz
	wXdhtPSEAZsMQe6U7k/F81u68+Cg/hgAHoddRc3CEZGkh0qUZntbO1eI56pZYdDfIWj+5p
	86hch/ZDxSHk7pbQ31NXe7bFdJEZZcs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794564657;
	b=iKomKbjJeVtchqTcxnE72x1msRQ9gjWBQ26ZWYaWW3J/qIa9aVMhjQXFs1kHojQBA6lY1L
	Tx5KWAvhzeej9VLz4QQJGYzlHAazb7So0PQdP43SPA+CG57qpP3gAvTCZF1adYhkYui8Xh
	E+WPWkJaa+6m10ZMyxku7ouYYm3S6NU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=Q4dh0ZJp;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of alex@amutable.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=alex@amutable.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-490d59c3edaso395271f8f.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:10:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564655; x=1795169455; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=RUn5HyOzv5zK74OCIfLVACQcizuS/sHn5qpIQd0Zvv8=;
        b=Q4dh0ZJp2Txj/C3hYg+IzKbpbXR6mYg5Dxj21YXUkacoeLJQZiEnlPU2FnAv5yvutI
         XeABJfsacZoOiOlojwzxwMs03ExGFGmC1zzWFaCZLo0ijbZ1czqeA+3qoShuXT00n5et
         u7YWR0bf/XC4o+og3sPrYgvtm+ognMwNXaG0M4bF4OxjhT6K6vX4ejrDT2vilgYOf8EP
         hBp+PV1ayoyPPOFuw2bG+3P6238a6m/Dk9gTa7gliL+agZUVaD3DUHYckmPcW4ctbegg
         lgra9IY1vNpuZgCdCw3iVq9JrRH4iKZ6Hf9a6ExBFGLFVhTl9ypChZsGoagfkwzSQaVs
         zCsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564655; x=1795169455;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RUn5HyOzv5zK74OCIfLVACQcizuS/sHn5qpIQd0Zvv8=;
        b=10TUJv8jineEVLxM3LV2VkOTBtYggojSUISpfUTqvWiMXsLauG9XYshFbSx2YhA69P
         Mw94ACghHVhXzrHboamyzMupbVB6nQ6RbWIEo8pqHuW9biD5T8IkwoQBfihgJ3PtSzgn
         FV0AbCDtZUraA0cqfvC3535V8ruBIKllHyG5f5sLwr3zDdhwav73eOdq+FyJZMHmDw3l
         6CdDxRI3So6zy7wK+qXbDbc403WDsu5cRK0C0TR1/GcwW3+gA5OaHjwaTUid5JXtNRcH
         3KI+wFbMz6ydnX0DfGpCqNBfmgUJZzhf9LVR8UR08BsPe3yipRzva7N4cPsoze0Hc53+
         d1hg==
X-Forwarded-Encrypted: i=1; AL+hErGX0ArnCqX5rHo1vkCLxui3TKmKYFvGDTbM5hgENUNzr6Cs4CFuO+7noays0BuCD6/GtvNGwJXm2g==@kvack.org
X-Gm-Message-State: APuU4Z/JQEil+Vl8b9ARys9Xmxm6lKUCFQ0GMmCmcnXQ0e9xhTqx1xf6
	WUftyg88aESoakLXvIiSEtY1Vq3YDPJ2UuDkgls0QdjjkSm0d9eAfJwt5GmkYkz8QQlz
X-Gm-Gg: AYBFou26gEWpdzntWbrvMvrBX9fbPzuWYmGsHMHx0h/fuVrKv5s/EIpWhqKYSweEKtC
	mM1S9NS1TqRwUacIjyVhxS/2Pp0187oa4TjeysENfKa1WAsXzb2EAuA0Da4qSzJqiJ7Ew7T/qKW
	wtKY3aHsaac6/JQ+eRYb/JexunrB3BsALVQfDyPkGPak/dYvZVfW+IXvnrBBQ1wWO29CYv33wqP
	6SY9cj0SHzgkL5jGChKKCjBiBT8J6DvYGyidLSwCcLnvoxyWCtmOp24mJjqEpQVs6Xay/GQHTQd
	mdcEoeAklOGrRPKMukHQjC0LbIrlyem8gkGmM/5UWJ9lOkBrBYNrPOtCWt4kYTQ6TrNKy8pFMd4
	+u9dCiQqJPk4BQk/U0/XU4fLZYCN1C4fWMtHopHRxnHAQ7Ns2ASlEagcB5MG/XNrTvkJAIvrASR
	0ZF99MTA2VbYdhOv1OdfmfFJOtoUdPTZFlDNl0JsulOxkMSyzXvhO0k39x39ixOUN1GfNBsLga7
	AZhZc23XHf6ie1wHoDSIMBqc3CE/rMv0bjgInxB5UtzG62KwBdMj+d8VJij2lkgcrA4qZmZM9zT
	Rf1FYQG5hkGFFw7Ra2me5U7lEOgb+IJcbjilo8qlEEQLgOY1ARNO0Mo5Ow3e0zE=
X-Received: by 2002:a05:6000:470e:b0:499:ffd4:f519 with SMTP id ffacd0b85a97d-49b02d4c2cfmr11662822f8f.23.1794564655454;
        Fri, 13 Nov 2026 02:10:55 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5a32d336sm4988050f8f.0.2026.11.13.02.10.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:10:55 -0800 (PST)
Message-ID: <0894c601b3f3c5b92008c6c399faaa539b658307.camel@amutable.com>
Subject: Re: [PATCH RFC 17/41] securityfs: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:10:52 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-17-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-17-4c998976c6c7@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Stat-Signature: o69ae9c49t3q93dz1htjga88itub79ap
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9381940005
X-HE-Tag: 1794564657-738092
X-HE-Meta: U2FsdGVkX18zHM5e6IihcKJ9uoqoyDQxLN7IrXCWUsvjMzIn5gGt7XHtzOGvRBD35F5Rbk2FwcxCCuKs23c2wPF+ZfKg6rHo54cFYdC2LA6iWAvypOKdqdJupoJ1i28F5tb8kTbgU8fgKdWgKKwbq4hrEdNiI/HsvKyGYUYDW3c4eFNXJ2fpm2Hde/m2uzgk2wmIYS4Ef7xkS7JbVIfDLHn5DCDZ2Ty4GVu7aiZPvsaWMrjQ/XhQmuI+qGXCMdnMAEl9Jlpsk2pbfbQb7t9pp1w8L8UVWp2ask5RjVd3Wwix7ZZ5a/vKg9St9xgbmXkL+mWzIVzER5aZuQE9/wIWJooVDSlWtXYN5wFzqdzULfOjeQVz8lp9P/6ppkbBUt0eAh+FezYK2SMo6/Ko8E8xCqoFHsBJHfumteh07hPMzw7sgnFBASpFXjBRrxWkilXnKl6NAnS/NDOAqmZNx0cm+kZuTH6mqyxXDyTPvmQ9LQupRz9uyiU4Vzd+9EbSWh6bbibJkC7kNK7sag/bnN+6ud5oC+C5a+J+wLam+mjf6Gh/0VP3uBjpa5BcBY6MQ3R1Nsd6q6W08k96c67GCs+61GzHQJ+b2PQuxKH6PXxIZDxtRCk41bSMRL+1OdlGELyIcXOykBhFQZ0mKE6E1zlTWJFP4PBAjXc9qHjahdGbuPh9Uy/MExboGf07sAzqW1/WyRnlL7oBkbIQwo9o/cVzd14vnR+Vy9QXkMBn3GwwEw103ZrNHu68NbQ+b9gzc07UZIlOgH8t71Tm2GuzbYBtxvcF5QoOpvKtTVeGBMGfbrgQ4tPsNvWxoNIQNEvhtQmtqmgYY5DNZzJ5iGmxDsO7jI/NHoXhkjbJ4tPWLrQ2rWqaz7uwboelNDDr6Y/+6DZLxbAVTUQPmPHe8ymvk7MSyceweABLNqva7L677b97uz0+JbsfPMBcF/m3EeBHS50GkXjcUouGU0grsdaKzsI
 PobGJpWF
 dmNNFHZecwLmnDHgkRn8mIfZr0PIGJDtnvCAVEYsJm+YutqUD1nx9D9/vi9AtXZ/KyubRo9XGEPlXVUGfNB3RAyYreSvKeQAXj6pRWwzOSGB2Ic9K12+ObOZO7twWJX34X/yqkHx9k9WRFI4A5DWpgPghoi207rhynGsHBw1J+4IT6y/jobnQBVF0qviJbsT6bFuEAoNfLFrLpgrkaxfJvA4uMvXNCJ7b+ruX3JqOvKdzfYpoI4s4NKQLnRpqSYD9g/uY6Ay253wOoDUvCAklu4lts8DtTVQjEqmgcKRuBBqJEWK0rn3ZcnRh1XAUQkQFKH7uWjEIMre2XTCBIIRDela1ONP7mKsu2r9j4zOUNGrq3xs3q3AHa1kX+FRD0tBUcwSuLx0zqMuqc0SiC4DxmlQz+FgEk+rGFKiPbMQUYTNN6TmY6+6Ev1EmgrVB/kAV8B6BWv8mPEFsu+Zv4wU7M9kguPi3AjnBWxIun/l9FqrqqPfk3aK8YXX3Kw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 2026-11-10 at 10:14 +0100, Christian Brauner wrote:
> Initialize securityfs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. securityfs never holds executables
> or
> device nodes.
>=20
> AppArmor puts a .null device node into securityfs but only ever opens
> it via dentry_open() which doesn't care about SB_I_NODEV.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0security/inode.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/security/inode.c b/security/inode.c
> index 080402367674..93997a9f16fc 100644
> --- a/security/inode.c
> +++ b/security/inode.c
> @@ -14,6 +14,7 @@
> =C2=A0#include <linux/kobject.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/mount.h>
> =C2=A0#include <linux/pagemap.h>
> =C2=A0#include <linux/init.h>
> @@ -64,6 +65,7 @@ static const struct fs_context_operations
> securityfs_context_ops =3D {
> =C2=A0
> =C2=A0static int securityfs_init_fs_context(struct fs_context *fc)
> =C2=A0{
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &securityfs_context_ops;
> =C2=A0	return 0;
> =C2=A0}

