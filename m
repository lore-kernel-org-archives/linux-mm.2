Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4991D606A33F
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 10:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=ZVKaUGUf
Received: by kanga.kvack.org (Postfix)
	id 370676B0664; Fri, 13 Nov 2026 05:02:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31B7A6B0667; Fri, 13 Nov 2026 05:02:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 212C16B0668; Fri, 13 Nov 2026 05:02:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E332A6B0664
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:02:54 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 774914057C
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:02:54 +0000 (UTC)
X-FDA: 85429657068.19.5E9E8A6
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9AC6820006
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:02:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=ZVKaUGUf;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of alex@amutable.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=alex@amutable.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794564172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QOKRfXbntKilXKCbQIPuMXmISRmnU6cXIBUGi5zYMoA=;
	b=R+qGpjHWCO3fFNjw7z8IXwSWXohpeFV3Y7legiZSclvvTxlBAG8M78xO1UybR0hKJ29Wav
	4JGQ+hmUMv7JTtZ8k7P5ONxFYVcNTeHwmzZAtejJ4Mg3nOJqkRxgKQf+fPpDdGZhOZgddA
	eKJ9DxIMDgN/ek7HVF/sY9vidktu5so=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=ZVKaUGUf;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of alex@amutable.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=alex@amutable.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794564172;
	b=B5RqoEcZE3e/RBHNxB6kJNzVTNHCeryCr//s92J0P8kWR/6F6hKc0f9xvKf4OwXxO+2+vF
	5tNit7Inj2JqXJFDJI8rKvCJ9adjkzJKutVaEga2b4W+BRmOHrwbeZgV6YQdq8nWl+LHxl
	x6cXxTA5MrSbE80RqXZy31KbJOm/87w=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6b408f2d936so1439713a12.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:02:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564171; x=1795168971; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=QOKRfXbntKilXKCbQIPuMXmISRmnU6cXIBUGi5zYMoA=;
        b=ZVKaUGUfNmHXbFGzPiUctfNI63zQW/Q554ZlFHC4VGNi89e2pRFc/koQeiOkAHZol1
         VCGuZjuoyymSSfJGf+Qe7vJAE8WPK0p4+PufvU1yBRFPjJZU72wTO1UCug8DhRr14S0F
         DeKAr07n6VdjMfwZSJYOOCpr2pd39QQzV4ITZRmd9c4ggkSZT75OKo6rcmGl0+YKtUQw
         CoxliEJeCt2YSvh6z2L90W4n86HugBhJ/BagyfWi4aEKwiCyuKreZc+xRdAKjHRnczUg
         JvbNOfaNt8J2tRagrWc2o9AbnvEAn5qJk14B/61ViPnhtQYJOhLAWr75lry5iMzR+8aV
         Z1vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564171; x=1795168971;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QOKRfXbntKilXKCbQIPuMXmISRmnU6cXIBUGi5zYMoA=;
        b=NuX2z8i8b7XZR92AjvnLRDa+wq2JlndcIL+8kXUSRRCvQ4XZ6O7CqB9ixWg+YQUdJg
         MfeB3CkCIAAdW86im9wIidQE9Cy20ap4wg478VI+ty1N3j06dy3BMdt3FcJXczb/rHzb
         sLKL061qnCWrYRPyVCycqPLkj8KCvSnWbOjMPpFDT+TTJxGLUobW6VkOetz7gpnfhNAM
         xucM3gRmINM84AY0V7yN+MWlT9ejCnNaRaPeuQtRQk0KKuK9ypb80UZFnSvjC6YZMGLl
         7lPbihVv+e7s9+gJ+p6ne0kY9lvF/XgUIIZWVRSH62+2jPMOWPh60eTwv/eDqF3nTpC4
         SSfw==
X-Forwarded-Encrypted: i=1; AL+hErEzKr+sz2BS+FtqrwCMyBxSG/dkG/lDk5N+RcE+dgi5X3QoOUfSeb15rJ9GiwZrqxZ5Sv1lXLsn4w==@kvack.org
X-Gm-Message-State: APuU4Z/N/1V9sRt+fMPj5YUpftxFAY7OglHGn3JanzDM/kmDxFHeC16Y
	7bDCg94q5Z9XBTY8d7RwDUWzjDqh7VeXtBPh1uowZHPkzZCNhr+EzrggjZLIdz8Epayk
X-Gm-Gg: AYBFou38jofgga0+XDQLNNEHUl650ipE51vOciae0IVLRN89UYGpn8R+d490PzvDhDb
	58yJdWbit+RbXGYUJWVXIdu6m19r4TyNKvxMJp4jnrMrOyWqr48Na98jtIdKn3iLTgRcjTcEUnn
	FJI4lDrLqZDI3FvCqemk7lG2Pu60cHyb8Gg8hU7rA60lG1magh4Hi9b/dNwOPwOs6oXlyTVi7PW
	/rIqsCl8Smwvc9qMOhLlC7kuQ4uEtEa7MERcKF4w3CL3rppbZ9s+++aQ7HkD39uarvUgizfA+iP
	9W3X0XbTl/NOf+YOkxt6jVWIK9C3aq9xCe+znxeIbxQQNhLzKwmtnPTiSp9PuD2PRw0VbUeww0p
	16D5Q+lIoaDJfQz3xHO5zny0D6n+PV8kVzhyj5sjz5/cEfD53EhcSP31CVTCfScaFHqJhLo3JSz
	ktYmbvEFUtFNiUBqTiuP5lwfzC4T3KSfl7XnJ+eB72JXD4g2kOhFQ1PwbtX6zR7GH/nlduTbOYd
	rBbdXUbKcetac9yyjEvj+mGusHNqkeKZ6gU6/Mo/Aneyf/xRYwG3XnbnChvx5o78mMoAr10votl
	uaiVqmPzGLF495QimDABCZB+I62bOBGhYixxlnK+lDA0sAz5xq6pjMSUgWKhxJs=
X-Received: by 2002:aa7:c842:0:b0:6b7:82cf:f69f with SMTP id 4fb4d7f45d1cf-6b7c0ceaefemr1298014a12.41.1794564171137;
        Fri, 13 Nov 2026 02:02:51 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b7c262338csm739270a12.33.2026.11.13.02.02.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:02:50 -0800 (PST)
Message-ID: <06b194053de4f4b65895248d1f2ba29d42a21b17.camel@amutable.com>
Subject: Re: [PATCH RFC 06/41] proc: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:02:49 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-6-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-6-4c998976c6c7@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9AC6820006
X-Stat-Signature: q5sh9r6txs4nxidcytwrafeg5kdntf44
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794564172-606271
X-HE-Meta: U2FsdGVkX19yIwLgSvGvWHKb9qKUdfmnaL20mcK7TQJhpTuhNe+5egf6MSCECfqNXdNuXzEm5RQ8DWRSKUn1cUkMu2VhWD1gleXrxOxVbZFYDBRv31ok1YVIfBeugBVVGbhihkE9GxI1wha6RGjI7cL7pdAhMmLk16yiKMmT4R6o1eyuKnp8T+PBHIhyulmwhfDtFV6fewFrPGYHmLqsDBz/EaJRfsovaJGLnQmMvSYqJjXWJpOWx67AdQvYosaWnM7nZR1uHKxCuOp9imSiC3XjfL1Mi/OydPw6NX+x2Vdsf3n5UQRv18pv/Kor6cisAZKex+LVCIctwsGcydDP1GueC+yrdLmJwDUEicsCQyfolBw1PQqq85cckEMSt/OPvmuhSF45Po5kQosOICel1kngyMUsv/SrmAID1h41ITgTQxzZ/c79B7Vd4EGQWVQqUb4Z1yNP2B+4fDgRG1TrS6PLL5quaHN/gxJhxHJTyek0QTXMLtgSCpduVmYDnE0Mnb+EGSJNCbsU+MdLIBa9wCuVRsVi2TuhJWwRCTErs3AiVAcRkbKjEUNFKRwCJA+5x8ApDUFONobT2BFZ+rF42QblVCBq60yp66TJ7hIYaSeeuGDOfd9n2+eEVyHesZ80K6grJz4x3bbo1Nl10AB8EOnFnNpQqhh40P1lWQ7F5HAYKAHsQKxBaV7ChHNlDk59uK4gd1qMC6ASv+PsZv5zFXfDVHrLhA9vAbdEvmNHVyoZF5KYZbJPtSV1moMwfc6qBCQRCOBFj3HdoX52p8nL9JMAjc79CecF0sgbHYqCNuBIwfmNkmTGFFlC/2A9qs9FhDarzJjiqp9++oNt4VjNy3zJn/0uRA+cQwyN2RU82ydJxsqXtSIwtMqT+ko50jBhmuYguEd5W2u+2Vij7dMpum8HkMRV87menSPB1lAN6BGdYms5hDEqV4fyQay25+0MfNnyoyYwSCYf8owN1l/
 JSvDQNus
 J1C1++QJtnJr49Q7ngH7I3+48nfUWg2gLXj+pO8dSSp2PLT0w7dvE2na85zNLEZSghM5JNGVwssb4m0f2dnjAeTme7uQTCBWL9hjQ+e6Ax9xjhvKpxE42tc+kFKIePnH1N8YZ0z3GYpgZ2x32RX03e7/Hry3QB5p0A4arTLuGOwaC6TWV8oWlG3h1hGnyj+Dfrc2qIIItthOXpaE/QnUhhXRyyFltpVXG9ozft0knLgwnPdpc5Qk2YQ94Q1IZ6h8pYcDv6soqCDsC9+kiPA/3N9s83lBnBADYBG9AkQVPb5pi5qIuyyaqX27306gmF99xG4IVRoPV7k4mzzSLF9yCHz6YqyC/Eu0wSQy4SiMDPNpKKAAChL59MW2TEQLz6JwFgjZFw89mz7I8HnJcbjZru3KSV1j6PO0kEYoU3oxU1yuO/q3tdj8dIYRtM0ZzKRRDKYuvjSYXaD2ms+wGOuplG78zJDdVii8y7pTOZ5dnIDXiUEbyzyoPIg4Nrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 2026-11-10 at 10:14 +0100, Christian Brauner wrote:
> Initialize procfs as a pseudo filesystem instead of raising
> SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> =C2=A0fs/proc/root.c | 4 ++--
> =C2=A01 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/proc/root.c b/fs/proc/root.c
> index 7fbbe92bf73a..ca0e75081934 100644
> --- a/fs/proc/root.c
> +++ b/fs/proc/root.c
> @@ -17,6 +17,7 @@
> =C2=A0#include <linux/bitops.h>
> =C2=A0#include <linux/user_namespace.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/mount.h>
> =C2=A0#include <linux/pid_namespace.h>
> =C2=A0#include <linux/fs_parser.h>
> @@ -265,8 +266,6 @@ static int proc_fill_super(struct super_block *s,
> struct fs_context *fc)
> =C2=A0	if (ret)
> =C2=A0		return ret;
> =C2=A0
> -	/* User space would break if executables or devices appear
> on proc */
> -	s->s_iflags |=3D SB_I_NOEXEC | SB_I_NODEV;
> =C2=A0	s->s_flags |=3D SB_NODIRATIME | SB_NOSUID | SB_NOEXEC;
> =C2=A0	s->s_blocksize =3D 1024;
> =C2=A0	s->s_blocksize_bits =3D 10;
> @@ -350,6 +349,7 @@ static int proc_init_fs_context(struct fs_context
> *fc)
> =C2=A0	put_user_ns(fc->user_ns);
> =C2=A0	fc->user_ns =3D get_user_ns(ctx->pid_ns->user_ns);
> =C2=A0	fc->fs_private =3D ctx;
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &proc_fs_context_ops;
> =C2=A0	return 0;
> =C2=A0}

