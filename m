Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD358606A886
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 08:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=YF6+l5cZ
Received: by kanga.kvack.org (Postfix)
	id DF8C16B00EF; Tue, 17 Nov 2026 03:35:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D826A6B05B5; Tue, 17 Nov 2026 03:35:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C75176B05B6; Tue, 17 Nov 2026 03:35:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A08B16B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 03:35:13 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1F138140334
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:35:13 +0000 (UTC)
X-FDA: 85443951306.24.1B2CEF9
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4179B40004
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:35:11 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=YF6+l5cZ;
	spf=pass (imf17.hostedemail.com: domain of alex@amutable.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794904511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+cVfVc99Mj9JzDjRqkRlx7bbwk4z1TaP6S9xba6j1G0=;
	b=n+gMUk2WlnRELCAMSpgYbh1zr0sx5yWwxpbMrM/RCbq1TbGOvGeI4eqItXvIpCT/egtPco
	z8KVZ2Tau6XLMjOXneK9O8b5GqKGTaXnRFOM8B9UVTqwhKWXClmWdHgY9tG74Ei9IKjsqf
	Xdit3w0TiQi4OP/sRfCCcfqT8sUYa9U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794904511;
	b=MPC2g45xm48lxqgb/124+oLoyT2SjZl9cPlP8UPRh/tUEjtelicA6xJrCP8pmYh0O0PKVR
	zPv35nuSedhQXCT1YKw+ClCCWo1m5wj9B1Wv7/+g4Xbc3gZ19J3/m/spJqDgvS/qz49noJ
	F6GfUIpi+YJKwdGOCXRJPKCZYw3eVMs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=YF6+l5cZ;
	spf=pass (imf17.hostedemail.com: domain of alex@amutable.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-4919a880834so2252946f8f.0
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 00:35:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794904510; x=1795509310; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=+cVfVc99Mj9JzDjRqkRlx7bbwk4z1TaP6S9xba6j1G0=;
        b=YF6+l5cZfxzpbzkbl5i/67M+Ammje319GZAK+YCFW4qN0e/2CkX83zmDTbu0HnhCK3
         AmAEhOr66iofHiBRdhaeGd1cAKrE9X/26Dp7JzjSNr40DFjDVZZMp7G9Ad3Y+nS57axv
         wuGWXTOzSThEOxXjI6BiPlwqBkCV1jrQzZ70Ostes+E9PQLuBZYSGpMki3ATlcaaD/7V
         fZ+AZPDHBknkComJfZ4UpnPk7TeFa6nBV3mBmzl9YaOdz05UGULG5kI/uv1DQY4+XDuj
         5cIIwPFASztM5sHYrZ9QEirAMGInxc/1Yp70A8cQV6nVYKZTdj77gVJ61O6A1trpDIL0
         HVKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794904510; x=1795509310;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+cVfVc99Mj9JzDjRqkRlx7bbwk4z1TaP6S9xba6j1G0=;
        b=W6AfK5iM/MIfsM70X3fgo/1YPPhdwt1/RK8FUPIRwrB/qhrBVJ3KEXrVCE/MnZj72Z
         eFajdIXl5fbxP0PwfBEshghdK6oDRtGGizUlNP7z947+LL292qJRQslf8XkC4eCZcSjS
         OiNAqAm+FNP948wMrn5oLHY19I8LufUCmeh1raPu9BX8k25hkf21FRL0Gziw+evoKLkL
         c0sGI/Mz3tIos2f8gU+SIJM6Xm0MWm4VphP+cgtiCQvMvwrMXi68OBuEsglI7kk2B+4D
         bUsPoGs7a5j9z8mpc5LEcnygMgtLKICZkNbEci1y75Cqi2GLebX2UDhOwbe0Lps7BFaP
         neKQ==
X-Forwarded-Encrypted: i=1; AL+hErGQW41AyDWi0SAJVB7+UjbwhfEnzSD+6A1qh7iVDXDmvbgi3NKoym+dh9KJDtXhflLfDeV2Bm+UHg==@kvack.org
X-Gm-Message-State: APuU4Z8uu1PF5MdCLICL7E4mxTXz3a5/kzSkn1JpdmZQ3WRgOtO+x0Hu
	WaEuucp+N7HSClPLGK/m2K1Fyy8h+1K7WMJyA2d8W7nYC/yZ9l9Zhi4/yOS4F76JdLrz
X-Gm-Gg: AZFdTZfDDRxvzGq6y43d+acTQXzSWAJgVHYaBSTMFGc2+KqKXo6u/B680/PSKAKwxtL
	lP0IM2cUZ4NR/hTaYudq6uTJ4HZUkQ6M13i8+8do3gFIMJK0CYe79gbD+EWsRtAlJI/msNFJ6xX
	AdvWeBDPatwCuhGombYwsW3SGYRTBkk4teLRGLa80/rwctQDvLtQqBjizb9ZlgWKk+Szn5xEbt0
	cyKmKhPhm9yXfMm2oEZpDQZY7uVfzjsqTodF6WDiXoKW36K56LQMaGk8t0mCK6Ayl3AGA7wReMP
	EK5cNUMNbt7SP4pOhLmpNDxKmJzUUQ4b0xeBW76E4mzMIErl2DbrNrhrCydyO0P4nYY7z6AbJah
	5Cpo/9a4OiEn8satzmZ5Svq3RO5w2Acn7vE32sp8brk+wOzuky6r2mEysf5w7ZJupMpyDn3IktT
	0ah9fEJHYrg15yzH4z9yjmkf0RQDoXBu9xElUth5hmjc3XIxm1hMzzPMGbn2188I8kO+Oy0tIdS
	LHzXEwMw7u0Fsy2TXrfu1uGOWgn+HAp8EOwMiE2eDJRigdNsiqvP5w0cmQYUYSd3Wo2zsvsKd22
	PlqWB3NkdfZySeBIQL43LIWi81YEFjycsAcKIxkjrX0SYWzgn00pJFjk+yfwjx2eU+1XzEX2WgX
	IBX1co7d5UyBqjY7hnTzXb/zxvnec6Pm9sdos1VJRHzIt8Z2xMWvklVzB
X-Received: by 2002:adf:e193:0:b0:48c:7306:18e9 with SMTP id ffacd0b85a97d-49c728c6e6amr26569239f8f.43.1794904509932;
        Tue, 17 Nov 2026 00:35:09 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:de4c:6789:33ce:97c2? (p200300cf572c2800de4c678933ce97c2.dip0.t-ipconnect.de. [2003:cf:572c:2800:de4c:6789:33ce:97c2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c603f4e2esm26338505f8f.36.2026.11.17.00.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:35:09 -0800 (PST)
Message-ID: <b0ec2cd8f9b7a6a2e4a54c6df2fa897bce068cbd.camel@amutable.com>
Subject: Re: [PATCH RFC v3 28/44] ocfs2: use fc_init_pseudo() for dlmfs
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
 linux-kselftest@vger.kernel.org, Chris Down	 <chris@chrisdown.name>
Date: Tue, 17 Nov 2026 09:35:07 +0100
In-Reply-To: <20261116-work-loop-pseudo-v3-28-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
	 <20261116-work-loop-pseudo-v3-28-8cbbea1cf34f@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Stat-Signature: s47wr1ndx6tpun9iii6jw6mwotabog3b
X-Rspam-User: 
X-Rspamd-Queue-Id: 4179B40004
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794904511-547378
X-HE-Meta: U2FsdGVkX1/uT3zt2dfjWDkGnliu0bAtIBzU6PYY0hI8vQH2hyKppkuGRfsW8fupunc1XlF1gSJvhY9FeuoMZwoqGEpRoIuvWR3RzA8OwZkKVTKWW6LbyYulGoOupHzodaovaBA7gFwrlFlPldxX9vlC83jolbMf2R5XWc+elDZy3gNipUvt+2Q32FpPrznL1gzbirGQLDt0uYBCeAr2O2W3904evMDg+G2MqNtPJjZ+lN3qtXYHkTa7e9mIDOjK/lSk/cMsgOrsJSfo97WZDddG/m9X1lV57f1Po/eX5M72gGnjMO3HcJjlhHxmbLfqD3tAm2Tjht0hbOpMGmhfHfYYJbghvmpFGHf/ziZlKlBSjQvE7hf4VcZcehTuFvXSQj/xRQ2l5I/+XXr7FOOglqiz2tBzeot1LiGdTdj35GOSChRRcos3uG3IekcqroGOzsLRLYqNrRhdr3SnqCkNGm4nZFXzaW8LSJoEdWfoXmErvL/Xmp14ie9xaOFeByhgcge+9xCUb5roR27uOtZZf70xCRSUlu+aiwMs8Q6Gm7oZPeegG691huxqJhbUqu2lJf3wdMwj25oiGabE0MsH5xusELZMFMBDjTE3/UKWEoBAD0FRNLNWXXJordS58TjBCdKROIgIx1nHWeLx2kuBX/TFtNQKx/micYWqAye2LGiTmTnkR2s/5FEMWXTo2A+lXeaeobOZdzWzjMgquyoESmx+DyML+36/KTax87ciFbGC8CrnHAGhBiLMr4AZOM8sRgidCPUKBOTP/Ta9QZ/o3lPpxEzh/IwhYgb62prxVAfY6ZiZhEzo5X/1z8pEinGvAPxub8YLE9JOz719y8GHqvWUqQRIw/1AKNtdrz9jh8ZOa5auMzKVgAzAX8Z/zfWIENQLhx7pRkqeQ9dzTdhKo7DoofbYoHO68g2XhwqITEaStsdl8fY/axZVLAdlIAuwtoQprWf/L7OPECUIDEo
 XGBO0/Cc
 tG662UdRDjlNRsXSxQz9CxGFznlMcNUNqKUEXBWGGHBJTn2ndF2v1A8FC3ex1zMH5bLJ1f5MzplDdZxRtOBACrYkOnW3KEHSGnEmzMepREJ39RbAky3U/idPCnTsXDMj3CuNpiDyZxWewFb7HYJhcMW1Wg0Fen9FYH+KBTkmV+ezvnOoG3T8XV+NrS5mPIjCtjOwXnRkIFRhk70NBr1m5Jnx2hNvSOdmRUk+eaMfBHGKE+gkPqY1uJaoYW8WoWEvfM8W/AYIpdiUynLK5l2WVHNzY3WAMqHdn+E4AYz4xCMyl9euSd+VXHalXYyy//MqpuDSF60y/hGgcOUTLYdZKu3erry6h9EhbCXmypxYtVEorWEcKfac44MYYcM36X82EaRGaEidpMVx4wLVOlVdWJ1HzZrL3fnfuAOB2g867YNbckLNa8CHBCqIElgflIOTU7+auquTded+0O0+wJhTiRz25ge/MvoXz3slDhmK7PK+2y9rg5MgB5OhvF7HJGBYwRH+8DOO9B0XoCxzchgLHPUCDQ5kWHQCTZpOV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 2026-11-16 at 12:05 +0100, Christian Brauner wrote:
> Initialize dlmfs as a pseudo filesystem. This raises SB_I_PSEUDO and
> also SB_I_NOEXEC and SB_I_NODEV. dlmfs never holds executables or
> device nodes.
>=20
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Chris Down <chris@chrisdown.name>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0fs/ocfs2/dlmfs/dlmfs.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
> index d3bfcada3e3bf..1789ec96dc130 100644
> --- a/fs/ocfs2/dlmfs/dlmfs.c
> +++ b/fs/ocfs2/dlmfs/dlmfs.c
> @@ -21,6 +21,7 @@
> =C2=A0#include <linux/module.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/pagemap.h>
> =C2=A0#include <linux/types.h>
> =C2=A0#include <linux/slab.h>
> @@ -563,6 +564,7 @@ static const struct fs_context_operations
> dlmfs_context_ops =3D {
> =C2=A0
> =C2=A0static int dlmfs_init_fs_context(struct fs_context *fc)
> =C2=A0{
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &dlmfs_context_ops;
> =C2=A0
> =C2=A0	return 0;

