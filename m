Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88057606A33A
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 10:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=nlGyQqtn
Received: by kanga.kvack.org (Postfix)
	id 9D8CB6B065B; Fri, 13 Nov 2026 05:27:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 989CE6B0693; Fri, 13 Nov 2026 05:27:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 878B76B06A5; Fri, 13 Nov 2026 05:27:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5F4C66B065B
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:27:30 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E385FA0699
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:27:29 +0000 (UTC)
X-FDA: 85429719018.16.56CA7CF
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf16.hostedemail.com (Postfix) with ESMTP id 156BA180003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:27:27 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=nlGyQqtn;
	spf=pass (imf16.hostedemail.com: domain of alex@amutable.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794565648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TXY31nY7nMCHyiOZTp7Dn0JSWYPda+tFg8CPAdTq7II=;
	b=dXNEVJSDmQnlJWlvUP8ahLTMPHG+J8m3ecmsB4L9y1/ZfQvVX8atpVoT5nfxHUM4ZqtbwS
	5FPV1jDpYKdE91uyamTRB7UqqLOoTJS+Q4pWEPaAAHl/Wmvxc9+MRoFSHCh4WnD6HIjGSi
	6bJTXFA1cFHdHS+nelN8boBQu47eE1A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794565648;
	b=tk64TwjmOF++vBkJXgF1CuqyyDOpxZdyQgL7vD/ytjSGwaaFIHhYnU0mv0mcxiwmTzyWM6
	JYOxNJ+Nu0UxjhXxoKLCca9lCBUdFRjDgpFFn7+pPi+GndRei2pz13qbExajkdEgXk7BAW
	XGcbbpoxabaSJ8uJYIeaO0Ne/3mPeE0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=nlGyQqtn;
	spf=pass (imf16.hostedemail.com: domain of alex@amutable.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-49465892f7bso822122f8f.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:27:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794565647; x=1795170447; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=TXY31nY7nMCHyiOZTp7Dn0JSWYPda+tFg8CPAdTq7II=;
        b=nlGyQqtnPmradzvi4svTib4plLKjS0cxn9vbHhLoutHE0nZQTbtpMn3Ig4wsyghPdt
         IVEpAV37zpAgT5y6zXxEYwM9ZzSSIdvZ4dfQo1V/HXx9CNMPzxqSEBoKf3JWXDkhFQVC
         GlJVb+oMzRoKC1qBHdYIdDarzwAzZi58Z2mpY6jNrQQhQAZby5cpHnVW6ZDq4aCjSMCS
         40sRFxjPNWjsWmclUCiIM4mkbg5Lol37WrK8KynOtJdx2ltaS12SacXGujMrm59Q5L4f
         jLwD+7S4YsMQ2oG2qzutXxr/8SZdRxJ9lHw/T0sOtnhGbffyiK4hYzfuqjtTskl54BlA
         S56w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794565647; x=1795170447;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TXY31nY7nMCHyiOZTp7Dn0JSWYPda+tFg8CPAdTq7II=;
        b=XOTImXXd4V/vpSwa+rvq14lLJtzRqHATFk4ctvODsJgntgTelQUI8DnW9VrUMTAnJN
         mX2b7HpKoPoQsCuTzUjlIhpsT7A/zUX+WPpnMQNTnyYsw0eUdHIf++diuvhpCjf8zIqB
         2QrX/v1TJau+OVoNk0/q7lJIwUAEedvn0x4hBvMdI664nw9hQEVSApFNndYKCzQKaAni
         I/2j08zgxaNeqZWOETuk+ZrPDOWe17NYTPmR79D9GanB6/RzymccdxBZj/Hp8AoU9eWp
         1YrakD3TkqaBY+oikR32lFxGGq0lgK4JEwrr0vwqUpH1lVz69NJrPW2cgQapikdE9V8h
         M8cw==
X-Forwarded-Encrypted: i=1; AL+hErE3dRHylVL9oYvinZ5HL8YlS/XSf3R5DfXyBMbZTuwx057iSoWvMxE2EVE5y7J9ohBZA4BumR6hrA==@kvack.org
X-Gm-Message-State: APuU4Z8o6hGs554jIAnZ0SueSG/6pckhHfdQHnHhlvngnBLVfIq8wAVF
	yOYlP9LSXlvXVCVqAj8/wUodA7DC4xKakaCGwSpsJ04Qj5r3erotPsIRv/FLN90k876T
X-Gm-Gg: AYBFou1xcgUXuKs64557RrXl697xWbuvfMFkC7b5O7KV1YFyWN7ABzoEnmN16qc0tSA
	Sjl5RxIvbrEr7pzXBvT2xQXf0RPQcc6ev50IvIgOKMW7XyNUyaSLt0IbqFa3+vGa2jMuSqOYXJA
	uN1FXrxqlqEFTu3IpQayaP+7jj/94li4MbRF6uwkF1jsk0atGFQIR9jFVdbkjghuwowJ0XIc5Dd
	F1NwUef9ffu/yYbYgvvuE0UZ6wz3eMhXX5W3UKp36x7zYHLwnmGhjDHCVOLtMFgNZMOprs/QEFv
	vPntwRD3zTCU53I6JrOd0K7i9iJy/gvRu5U1LutD5m8XZIjV7TTqqgRTPWRBIEKMuRct6Nyxf9X
	aTYvmeIRTXoYSOJCejm1O/KMMQ/k58zhXUXRrFKd2Ge7FgOHPecb0wD9y9Rc0wlTSTu/2HPyivJ
	BrR8MnNmNaO7XbAerVg+x5g4WvDRn+T6+3KP0wr88Tcifl/dUW5eR2vOHJw4HYceBdvvZxgPbbV
	M1On1RjEa3hcfQ6KzNWzTkhThTcpN6xVCUj2URmRIY8sFPpsMuW2yi8vJlsgkMxnVoNM+PvS+wR
	uokdQLIbgYilkugeFANahSH/+/BMLHBxPC/Jb0niPk+gFETaIcZONk9zE+Kz6+s=
X-Received: by 2002:a05:6000:4707:b0:498:c419:3728 with SMTP id ffacd0b85a97d-49c713ae367mr4463557f8f.22.1794565646661;
        Fri, 13 Nov 2026 02:27:26 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5a32d336sm5077482f8f.0.2026.11.13.02.27.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:27:26 -0800 (PST)
Message-ID: <0c109a58804a2d782e549af6ad13e89532d9f9d2.camel@amutable.com>
Subject: Re: [PATCH RFC 40/41] erofs: refuse files on pseudo filesystems as
 backing files
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
Date: Fri, 13 Nov 2026 11:27:24 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-40-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-40-4c998976c6c7@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 156BA180003
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: n91yxn7sdeupsnojsxnx8n5n9ynsm7ip
X-Rspam-User: 
X-HE-Tag: 1794565647-963857
X-HE-Meta: U2FsdGVkX19wGAjxvCpb/FDNmZHZwbK7wMPhCYDqIDQdP+DUcThlA5s7bt5bV/7rCH/sg+ohAjI92rQQUdx3NC4WDop369IpFbyfeyFDdrkavpAxm5pbKB0OCvRjdtGu1N7PJVt5MAj+NHdsOhBl3rN8HPXuz2gH45d/38Rll4EFF6Wc/sIUa7VGw1gn3p/7wPu2ZLnFH9YXBvro2/qtH9bkP0g0BlDje+4hKNiPzUr4u4QSWwDNKd8R0j/zAfTtJ/xduQ7gLdaG3dXgfetEyJG1+8O+fHErCLRIjPFFj0BqC5FiyYWXApkzHpn/MPVpKjNjkPzVPg52ko5BiulVFIpTrXfspPA2yW6JTS2EimfNRw+U0IX3hVUy65oDtKO1AgjTPWSy41zgLPJty2uMFrCyJhY2rgiv6Qm7BQ4bTLvX9MFv9/c0QrkaHrPqTs/rDBbrhy34ksHjHbZ44Qwv6DJJJp5QJNBEPXnfMsu1Kud5L6N/vrQR+PMudiaLragJGywfnxlkOjq5QS/0eDIEuvbXy7TvZUXtGKVz+95sonZs4JVLy6mAQTd6oPsOBqrjvvz09E+izNsPXoeC+n3+fedoIOWbQbGMAdxDVhq6qnBPiuk1TO3Bsa8XLLdnKIhdCziMUxKxBQe5iPlNZ5ttASDEpUuuwd5xDmPyfkHjrDeCo6zVmXOjV3bnBZqXnq3KUXjPMqCN3xnkgnAQBMIu3Ty6ph5k86Nl8tZaKH4KJqDgXYGi4R6XcqdLx1IP6dNJqSREGemHocZr61ZG43rnz3HDI4j+vi7TZwst9gnOHNzNcrUKv/XfgaU0yMYP2vNn1i3GMgZ4zIlESeJP5RmGutdhvMIr00uL9+MiqIrlecozh3PlJra0bRHSORvA2vy/p+MwYuXAw1lBAEy3WK3QyHN48Y2IKkg09YKJ8E+0HmPlmmhwcDmEOtGlfLHfP9jO99PnX/MubUkJmohkLX3
 zBRao9CI
 KbEu8XhmLTIbzUKOiQ47HWyGf0P3y8EuoElz1nFkMlcu8cPefbe3fYk3LeHaRO2l42e80VumBYO7maV7FRvQe4Nf50kLVvTm2iRqhN2+mP+Kr7r+1/RghivnIimBRcAOmb6JgcaAdgMSVlAWe9b3rxuyC9+v9HWBqrwsfKoRgfle4scxGorkSbx6yJz3K1VwtujybafXYZow5tLGqFfywVk/eKEg/uZxCztSL5w0khswv2+0/sjYMy2w8SGXF2TNFkQFvNHBWDYPtr3lfcmN4zfEjOBAYUdpk9idcl8cE4HJ6fDR8FQXJI37h2ys2z80MGT9nF8u1OeCCgNL2Q8mMjYHiaq5LrCFe88L6PMNl963po7MSnjMZKgF85UgpEKwZ+Kx32K8wdYFtX4ulFS9tW3MEqweYYrt08ZrP24ciGswg6JqggM3UI0h0tZ9hoyZtbl6i
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 2026-11-10 at 10:14 +0100, Christian Brauner wrote:
> File-backed mounts take any regular file as the image and the same
> goes
> for the extra devices of such a mount. erofs reads them with the
> credentials of the mounter so this doesn't hand out anything the
> mounter
> couldn't read anyway. But files on pseudo filesystems aren't images.
> Refuse them just like loop does.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/erofs/super.c | 6 +++++-
> =C2=A01 file changed, 5 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/erofs/super.c b/fs/erofs/super.c
> index ce05557bd998..980d5fc2b576 100644
> --- a/fs/erofs/super.c
> +++ b/fs/erofs/super.c
> @@ -158,7 +158,8 @@ static int erofs_init_device(struct erofs_buf
> *buf, struct super_block *sb,
> =C2=A0		if (!erofs_is_fileio_mode(sbi)) {
> =C2=A0			dif->dax_dev =3D
> fs_dax_get_by_bdev(file_bdev(file),
> =C2=A0					&dif->dax_part_off, NULL,
> NULL);
> -		} else if (!S_ISREG(file_inode(file)->i_mode)) {
> +		} else if (!S_ISREG(file_inode(file)->i_mode) ||
> +			=C2=A0=C2=A0 file_is_pseudo(file)) {
> =C2=A0			fput(file);
> =C2=A0			return -EINVAL;
> =C2=A0		}
> @@ -835,6 +836,9 @@ static int erofs_file_get_tree(struct fs_context
> *fc)
> =C2=A0{
> =C2=A0	struct erofs_sb_info *sbi =3D fc->s_fs_info;
> =C2=A0
> +	if (file_is_pseudo(sbi->dif0.file))
> +		return invalfc(fc, "source is on a pseudo
> filesystem");
> +
> =C2=A0	if (!test_opt(&sbi->opt, SUPERBLOCK_SHARE))
> =C2=A0		return get_tree_nodev(fc, erofs_fc_fill_super);
> =C2=A0

