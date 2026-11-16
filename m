Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40A8C606A332
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 20:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nszbvx5Z
Received: by kanga.kvack.org (Postfix)
	id 237056B05B1; Mon, 16 Nov 2026 15:04:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20DAA6B05B2; Mon, 16 Nov 2026 15:04:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1236D6B05B3; Mon, 16 Nov 2026 15:04:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E51236B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:04:12 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EC863C0219
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:04:11 +0000 (UTC)
X-FDA: 85442058702.25.416D05E
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf22.hostedemail.com (Postfix) with ESMTP id E52FCC000E
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:04:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=nszbvx5Z;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794859450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FEtpE65JhLGyAYaL/FOW2ebUIws2WwBZ/4Zy8VNXUuw=;
	b=J3O1faCPBGjXPcUD2QioMmTK2+pyw1s4fG+aAss2j2iK/XisCisiCFqHQBhHM8xK2rve0l
	/pSomv+EEfMUj5kh/9Lh1tVZY01v57gneq4CDycFTYUT2WN16AfMXTnSmvrOYbAXVQrSPK
	xRC4MBCIODnc3Se+x9M4eqF7eSYoe5o=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=nszbvx5Z;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794859450;
	b=ejewQL4aWoxa/5n8LnO2IcgLRGWisnuUIxfd42VxzjlijKDsztuORm51Lk/elQRiBHr7JT
	brwrGyk1kIiacBLUKEhU9guXvJpr4SmEaNNmx5Fqg5YJAIV6KM/CCCT+/JbCFIPtSYQPRM
	RvBkO5moRsgrFtPlCAvxXJCKM4C4P64=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-48e47347279so1838159f8f.1
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:04:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794859448; cv=none;
        d=google.com; s=arc-20260327;
        b=dO/cH2mQEAqYEtjYDzyMIKk8b6MeSSCsCzsRfGQPHx449aMm3WaPUK06Yk7++QGNNB
         bZXYG0OV9TsJLcTq10yJfGsbRhi1D3AlxrUh0SK8vpxtV6b4JT/+5gyApbZE+vsyl/wI
         XbG7nl9v9uG0wIsOLqLXotBK3yh7k68JRTzB4hDNHwGad6LrZwvHrJiQhQh01up7Bfxk
         YtlZObiUv7FSnb3SiYayAFeCLVm7AaKfQxxOWfCuvamKbMl5rLMg0NKjKYboWvhGXQXw
         UVrfzGu3G7hU+zDjA4U7dVBHshN0Rka0FhbwT9xi/7+mhU0s3ZkKwMpJDZvyHbOKkFuw
         mvPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FEtpE65JhLGyAYaL/FOW2ebUIws2WwBZ/4Zy8VNXUuw=;
        fh=p79k1V/2BoqFf4kT5M4sQg7+cm7iaxQNN4qmMHfRXeA=;
        b=rvdLQaHk6CvsQTHlXQ+hUSXhhYZoPYuVciKPYxm5iIrpf6vQyPXx/wWhZzbpxpP29U
         3LqnwDK8NhE5P+fe3LA1mgKt/cB0eqHBmZWVMVWahBciZBNE7Eb8Ol/QOS6yMrleH/LO
         uX0T4j/hcEEaNo/eKRqCl3RAW9F4TdKjFfuVeCR2dUDK3JsFHgECjuAFzJ6V5olW6h55
         h7fJW+ya9s2wF5MzzqVctyqJkSlKnHRlVlTJnMyzFOlpHeoTuVhIptOYfgxHryTcsZkV
         IaqBiSKR63T2WXzOnchrgzHB2qpm7VGTIuDr/pGfheaJ9C5eiaBDyQAtOikZFkPpFazG
         5VoA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794859448; x=1795464248; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FEtpE65JhLGyAYaL/FOW2ebUIws2WwBZ/4Zy8VNXUuw=;
        b=nszbvx5ZYzUO4sOWJEiiTmmR0Z8E65w5BSu618KD0+69dPaYfHE/TlaIKJdzmCv5z1
         Rif56oBfhAagzDdMgjPjFzbOIZA+F7SHAF69X/Yyw3uTit7ZbBc2rru8jbSTXMsNEr16
         BVsrY1g8dUUaplERtUt8/nm1jfVmBLKmMXikVrq7CKrm7tk/gT8OziZhXdEcZZeTy9d3
         JV9v+yImvQWnYk6/F8YC5VezLPELQ4yOKwxiuLiucPNagu3kLXYYAhV5Nwl7mKSmNy4g
         hzMxu4eN4tR/dic9OPTXdC71aPrYY37YGvIsiM0Q8DJeaz3j0OlBaxTqgWPIn/2FWt7T
         wtgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794859448; x=1795464248;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FEtpE65JhLGyAYaL/FOW2ebUIws2WwBZ/4Zy8VNXUuw=;
        b=yvtKw3Wh/3H8Ulw/q6AOTgGk/XOh76Q6qlWaC3B+u/YV2xWAjU1ceC8cCx2ytJb7u6
         WftDjSVlJQtfai2sBlysiqBeQdNif3HcUcKgyhj7d1LWnbkDiRbZm77M8sGgqSXj/R8U
         5xLSsml3QgTn0ln95EVPx9QKklyN17IuFklSWy4e0trOX9P07b+0dX3pnlP5GQ/J2ru6
         LYaBdTWyePqWeF2NMwHprY1q42FZLWfk4ZQD8OAdL1F1gPv+7kfJKfo9LoZCR9A/QKAb
         sgiAwAuRJvw5rLlH2fVHVF8I+bSQDCUsikgBqdZm5SStIAzuCZBUAtK7/ydTb2Net71Y
         lIbQ==
X-Forwarded-Encrypted: i=1; AL+hErGsrVv2mYBlg8AFAnaV+CRnDpChsTWjj5wIS/y/pWRZHyFMWjnVxovJitDBbbanX495hptqh0FyOw==@kvack.org
X-Gm-Message-State: APuU4Z8APVuO+zBSV5//dOLV08kzDI6WEHigiPhJcHw53d+z2m5WcKjE
	UlIxR/Wzgb4G/5Di2NqoPfoAjMeTxx3qiQWU/kqq1MNaadwst1vZKeHlBbkaxDjHAh/hCTndpwy
	We/rufhv9hIEovbEy+oemlSLvkq5S08Q=
X-Gm-Gg: AZFdTZd7RHz7bYnMZZFPelQJ1VLkaMrmu5p8BrSpfM6HPP8nqjis1uO5+4Rg2RG58fI
	DzD9uBpJbcpYpLpcVVVnfKTm7OMQ9bvTihujIrW34BvlsICfkDPtP6E/78noZe9kEn6a3w6egui
	wxC8wnbHpnoBfrAUGV/xmOmV5Bgko8m8v7olYsuZb3i0I+kwxKMMqBRbUVdOBotn/bXOhZA16N7
	St4M7yrjTuZoO7fZjTmBOBo8MakySbO7YV0Z/Js9eXVj0gDyGuHnAI+WkAsjqI7nLEBYbIzmx7U
	iG/kUCXQ2Va31SFw0qUkOydq8b6hxsis5AC6jlNKQFLAP8giydbtZmFNzI8S02peSuHmkvl3fvW
	PkU/8HLc80fi+sbSUGRiu1yD3AAAENTQ/7mrcyzTvuwqxoeGygP2uGP69jUnplCZ6x2PiOTMNSr
	M6UQBMQqitPQQMlOv8qcg=
X-Received: by 2002:a05:6000:4692:b0:491:3fdd:af34 with SMTP id
 ffacd0b85a97d-49d61c80db3mr13343868f8f.36.1794859448335; Mon, 16 Nov 2026
 12:04:08 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org> <20261116-work-loop-pseudo-v3-9-8cbbea1cf34f@kernel.org>
In-Reply-To: <20261116-work-loop-pseudo-v3-9-8cbbea1cf34f@kernel.org>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Mon, 16 Nov 2026 12:03:57 -0800
X-Gm-Features: Aa3M54q6P4M0RFDCKQ8HHGNCWJafItTSPdWR1qNwVGtToDAv2VOv8vDfWHzYR6A
Message-ID: <CAEf4BzbLFVawibuX0wk=8uzy0WZSYHbkgK55d7rqLab2qAM1Fg@mail.gmail.com>
Subject: Re: [PATCH RFC v3 09/44] bpf: use fc_init_pseudo() for bpffs
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>, 
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, netdev@vger.kernel.org, 
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org, 
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev, 
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-usb@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, 
	linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org, 
	Alexander Mikhalitsyn <alex@amutable.com>, Chris Down <chris@chrisdown.name>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E52FCC000E
X-Stat-Signature: i5tw9ozhftg9ua71t3s575du6tfefnh7
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794859449-394347
X-HE-Meta: U2FsdGVkX19OVvPx/QCL3lSYeSRTzIk0IdbGjhV1zD91MVzKntYqAL9oYZUNneWK4pkPYdLjKwMjiqU8NjxlC3Of1uks6YGfC1QSJ+0qHvwRJURfcASH/kI3LlJ1afeUWkL+8ol5tBLw9arIekUyStb8/+fhQh/T094O7ox5PHvUwRFuPZkyB6ovVCFjReGkzphb7HOhI3ujdzddQfBbBoO39CDNjVx9oj8B22wsVedbLn5D4TBXfrrNzpgccBiiY15Ax+ttjxrzxIJHLE5+vfBc37x8HIJ5+8SS3b9vH5fx+JW+OKwO/p/XIM/MvQw/f02UkqMlR02920HZxCeCb5XaAI0HnJ925tz+0KCJCCEXyOs5oA8ZFogMKbmB7nBGoVU88n7XXypnyTWAbOQ2PBl6IQqUQ5UpGo/Br8wauWhrosD4jv2qmsiXH3HEjEhDxfL7oSudFiQYsKtlsML2pSh0vippos/TaC6yiHstLA/buRLlmyUgCd+INTN0C+Hi2OAGKhTxFbd6AaDYafPLFQ9E4jIrBjygJtAzvu0qbbxK0YWu0eSieNEBJ/9blChTTFIQ4meLAJLqDev/VMQmkAjykeYsbEgHaFIx5yoYO7s0ks6hl9DqKzpGmcnowjFzkpD5w31ipHqKbivEJTLElxLc+H6WA0eDGV5TKM18kXBlo6BBlVsMSLvvEp9ofTuGwlHy8dPzD/fm17XUWBnN8938eBmZy5xASgZQZH/DVvATJnjbeRhFoRrrL3CxzHFDmea6WENRP6wPDkzkrzVDUjQ5vJRQKHQWjed/25laTT0l2fmA8MptxjfcI8LO9ftVL/t8ndcvA+M1aNN2sq4DKYU6a2OlwSspTvNP0vJfjwXMfIcTXU9DZr5NHPrPg3ao4E8TyJQ67ReIeAZqLCUMFeixW8WTMqONbFmXRfolg1BpvdKWA+hhe9ZoJtkr4V+SdssjFRU6Ennnw1ICh3/
 6Ikctysn
 tpfCjIW64GMk2OKFR4J7mWYzME8kxDoO4AlTt3AcQLR9Lx4+6omsO2a/XQxV49XJuHT2Qv/t//BJ+ORH+wSpe0JB/L+DYBV1kUBTCx9ARH91vXJgQ0ERwafZQINHrU0E7SPmhbDw0OCqpyp6ee3uVsSKMIuUd1yKOiRB4iqXx5uww1P5fjpwALLSyV5mXyC4gHDy1Z9074yLWHHzNJNNSOZPKXgSv018RM/MswbZMreE2diWuYTUg/FPicSlDI1GR94JWDWLhQ8YCSzX0NsAge7SznkzaoaUaDf1NNUkwcvP4rsp39Lih3j07C6p8zyprIa2BzxTCrqkOq+lhWNvzOl73yGTUHA8GFcxV4eH/Sl74Kc3hujZnkU/KGrO6+lEpUzEXeNBtxmUQgmIcMkTJA+td+XGKpTbvXSqrJswLZ0BnYCQHRGEUn0Cr8upin5lbaTVxE9gl09ixwP1eaFDA9EiAbZW8XZiwl/5x+8EI7id2U9cTbpbJk3rztv0VDSMvZhnU6w/t/b8YtwXTquf8p/xXXDYw1EsyYbgHGWXmZyXzb1rTk89nlgzwhkDpEauohShi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 3:21=E2=80=AFAM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> Initialize bpffs as a pseudo filesystem instead of raising
> SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
> Reviewed-by: Chris Down <chris@chrisdown.name>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  kernel/bpf/inode.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>

Acked-by: Andrii Nakryiko <andrii@kernel.org>

> diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
> index c6f328e4752e1..57cf3775c0766 100644
> --- a/kernel/bpf/inode.c
> +++ b/kernel/bpf/inode.c
> @@ -15,6 +15,7 @@
>  #include <linux/namei.h>
>  #include <linux/fs.h>
>  #include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
>  #include <linux/fs_parser.h>
>  #include <linux/kdev_t.h>
>  #include <linux/filter.h>
> @@ -1197,8 +1198,6 @@ static int bpf_fill_super(struct super_block *sb, s=
truct fs_context *fc)
>         sb->s_magic =3D BPF_FS_MAGIC;
>         sb->s_op =3D &bpf_super_ops;
>         sb->s_xattr =3D bpf_fs_xattr_handlers;
> -       sb->s_iflags |=3D SB_I_NOEXEC;
> -       sb->s_iflags |=3D SB_I_NODEV;
>         sb->s_time_gran =3D 1;
>
>         inode =3D bpf_get_inode(sb, NULL, S_IFDIR | 0777);
> @@ -1261,6 +1260,7 @@ static int bpf_init_fs_context(struct fs_context *f=
c)
>         opts->delegate_attachs =3D 0;
>
>         fc->s_fs_info =3D opts;
> +       fc_init_pseudo(fc);
>         fc->ops =3D &bpf_context_ops;
>         return 0;
>  }
>
> --
> 2.53.0
>
>

