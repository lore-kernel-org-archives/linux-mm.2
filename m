Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E86A9606A337
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 10:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=qYuRZtUg
Received: by kanga.kvack.org (Postfix)
	id 1AD7C6B0689; Fri, 13 Nov 2026 05:16:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15EA46B068B; Fri, 13 Nov 2026 05:16:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 075DF6B0698; Fri, 13 Nov 2026 05:16:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D25DB6B0689
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:16:01 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 66F1FC0489
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:16:01 +0000 (UTC)
X-FDA: 85429690122.19.70C9F95
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf30.hostedemail.com (Postfix) with ESMTP id 95E9280004
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:15:59 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=qYuRZtUg;
	spf=pass (imf30.hostedemail.com: domain of alex@amutable.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794564959;
	b=G0qobjEcF1Rnz8H1mmzfVIsKEKidTDN2F+eKg2pV83kEoww07B9gBB5NebHXx3ia0FBbGT
	gf8U0Cxrt0b156j2EvmO/NEXjqyLsqLGic+Fhj+unFA968042eeUjj19LK0t+VeuU+sn1o
	jwCRBupbUADaV9KMNqdyGPPXK+5pLEI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=qYuRZtUg;
	spf=pass (imf30.hostedemail.com: domain of alex@amutable.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794564959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PfCz/38ILdxPmJBY1NDzDaIsiECcLTMyKpoKPJStEV0=;
	b=YsCh+ZiHq+x1bY9gmKzGGP/OBU/9C9nmMSMYaervseLa7Ty/BURs178ZAuXS78PdNo1Tst
	3c9O5OgsoNYdW6ezetBSXl8k8vpQZf62XMJUnJDsv7LQFDmkiwdYykY6wkaYY6y/B9zH1m
	9S4hqdmNs4Fc1KD4dmR9K6weMO5+0Ps=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c506094fd93so151136166b.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:15:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564958; x=1795169758; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=PfCz/38ILdxPmJBY1NDzDaIsiECcLTMyKpoKPJStEV0=;
        b=qYuRZtUgk6O+Pk96l9gVJKYQrxgVpirff8by/oxuAV5kMjmAlVpLCtbYd5HLRXr4xo
         2jYH1n+FHulRv0bDRSLkRBcqSw9NtvXw6OSFXwy9QAmjuVaU9siREG0o31ZCrOgj/APm
         tmtPelr91i8rj2vz1f/DuAxY5sZYkRCWkjw8oxBro/8i35icmTt3L8FMUcwtUG+6LChW
         PXWPTZ/e+UvG0Sp79RYXvqy61rrV5lI/2sqjP0eNXCnD7tp6FwA9juGOGbkoD3XFdFbk
         Ws4zjPw/1SA5kHN/22EI0vwJwyHnU7dI5MbrGr4YXHb5V0jRwGPoSBdGJlc7gHkrF47s
         peaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564958; x=1795169758;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PfCz/38ILdxPmJBY1NDzDaIsiECcLTMyKpoKPJStEV0=;
        b=IdPbhq33QZohkQUJ2xv3knP0J2XYbPALkh7PEFIyHSYobVdIF361+MPjqpRg6WUkdt
         vnYPfhDGeQukE2Tqb4ke3IF93NvloNfUIksWSDEtHIHj6lWnccmhREFgnftNIc/jbvuY
         NwwJ+0lSZ+lbhDj1PQey+OVWMTSAMeXccdnnftzU1jRnUtm6cqLSVn6ww4gzy8VuPoy9
         KfS48JFd4kjUPAOxODY68QqM765ykMkCSy0vjz38wUebGYVvSNT4ldIH6nD/CupXcZNJ
         K4v2P7XeLFm61UEsClsexCLUWoWX+eeturo15MhVBEBIFW3v2K4y1gAqc37YqrAheTbq
         q2hg==
X-Forwarded-Encrypted: i=1; AL+hErGoAz/msW2CSclDkMyQYc087ER97LNmh6yyFTWdrvb0URD0leMG/jM2oyOC1LoPzHbjPh+sHonJ2w==@kvack.org
X-Gm-Message-State: APuU4Z+BTFJkgEqHVtviozTIaG2vCs1amFPMQWNot07pCiOJ+z2lDTTM
	H9GhrDbvSKZYglizAndrq/LSdWzuehcIQpvt3Hcm5gENXAiBB9T8Zh0Av7W2BlgM0P6EJ6GVQe9
	mFBeaoPDsFTk=
X-Gm-Gg: AYBFou3dco4IGgPAt5UN7f2CmPABpelNEi+8MIj9++XEGQpK4KkCpcuHMVeygMuOR15
	zdINvVSKTgUDSMuAr7+T3vYr/M7Go3DbisyMhzQDyGiDYNF/I/hsc8v0s9uBM3ZytYd+0DMIa/E
	f290hoN65JX+b8gCq7dZ5Ony7DBRYsAI24iYADLNncw9rwNHG3xlSXTxWn4u2S+YBlfmE0BFn3W
	dhxyTsl5zhBztGEq6oQTgPP54hS0my3p393ptg0hb8Yg1Ri1RhPDt0RSQR1TUmPyc1dtc6lPF3x
	4Mt6YkH2oxMzNsZFTDpoN2C3IPoKhIWtwXelLmEOgCwenX5SxjOzLBVdU3lg/yDs9BwnWI7oLfA
	MmmuF4TUiLKmDI61EkAk3WZT6DDrBQ7gIvamT1KnIyp3nEA+bbOodFRJoofiP9zl7iva9RvFbLN
	awByjgDjkFnUBnB0tchI/NInRCsgWjt8Zf5DTXK6EV+LNdBhXdtskSrD4awmUOlR6hF90YTyOub
	VNmrrJMFBk2HW2y47qg2FCPpJXklzYibJd6zUWO1LI5Ir+/l/akIMRMvXhdqM9FysLmK/LREtzi
	pE2VldbJihccOBZrhw4wW+kToGWmf43PHHv/0SsjC4/DuRHZYg2d4tRmoi3g38M=
X-Received: by 2002:a17:906:f59c:b0:c42:102f:15f0 with SMTP id a640c23a62f3a-c509614d4c1mr171873666b.3.1794564958075;
        Fri, 13 Nov 2026 02:15:58 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b7d1b7sm75606066b.74.2026.11.13.02.15.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:15:57 -0800 (PST)
Message-ID: <c5a694991af7e9182fd475a20bf4cfd73a13e395.camel@amutable.com>
Subject: Re: [PATCH RFC 34/41] loop: refuse files on pseudo filesystems as
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
Date: Fri, 13 Nov 2026 11:15:56 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-34-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-34-4c998976c6c7@kernel.org>
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
X-Rspamd-Queue-Id: 95E9280004
X-Stat-Signature: dwgxkiojqjeop931sabiww5xwjamo13p
X-Rspam-User: 
X-HE-Tag: 1794564959-239898
X-HE-Meta: U2FsdGVkX18s1Hqy7sVar6y3PfKIOHm8E8sqYvo7xtMREmY3ccY75WlpDdgQ3wGk67hprnukTfAlHyqDydPEZNsafPGwUvWJWWQQ/gELjZg0dzwiDsdgwaOApwskXrJkYFJsRBO7bEqmpehVs1xIt18piOKF/xDwWnt1yQ0lrLHpW2PGpnsvH93fhjgwqwa9svBaPca/P+gq5K8tZZEdlVoOoCeLrnUpMuiGIKbWhVQ/kpdL820nq5qxEE0i7WcWjgMbZfXPZFUbA5fWEQuCW6ai00UsfIkbjHK6t8U0w5HaTIlh5HJh9Duy0PtzyV4FkgfjDO6JIZU+oqYA2juI22dF8GlFAa91Ach2MGhcux7lDryMAfFQ1uRzfo+2O4ivKZbp3FPgXVxTf1mnpntFZ9NeRExTItqV7wxead52q4oPr/tq84fEgEJLFKteqK+/hcvxNnzeumA9/+6x941agat3OQGb9EOyjBcApIx/Sr/8x6Xrzl7IXKewM6rZsjeXOFPGj7n/WSGDbQlsOzLqGxj1gEDTCFsU/eDgWY07Zm4WloE0+CF9gOudlYxntm5ntgLfDruHOqQFFqRvg89xMyqoQf53cuB7mkZtvKezNc2uc6iOChcf+c0RuC0/BkvxrACeGX3l5gkfLA/ieRE09kSQm6/DSECBC/x+TTuIjiAUqJ/1UwxVUDJCpiOABiZfi5jfISSv7p80wurA56nw/M07rvCQcHFyxtFycPKBmNhKscif4gWX6NTVn4SrjVIq2enpxYVgfjOiHzqSi/czMMt44IhWQhI0xmnOXrV+iPnGu/Eo3SzhaMcBsoSjadGlzND8TTLuZT8+AilH2/N7oPKW8LkaYvhncW3+mrjBSQGLhM5XUSx+fy8nd28x5JyFTLYuz+y1MS9fdnXtt6ilYAiqj3Pc7vCvwcMXOiRJrGXH2XRQ3repNCIOjv5B0UWYsIEQzLpNlULwVMKbu8q
 rvQoJ7W7
 JEQMVzqgwpQfHeFrH0nrdDH63mJtM3GAVeD+UE0QzxZ4rWQsbJAnf9jMYF5R6iHLq9/UFYSrAMDz/eJ/C3RF8TNkLEiEAHyoB+rJLsD+wu+LIstvlo0yhU2o/htTrNBlSclxP2LoKFjIQYQfbKdmMYr9h6zzvEm25d9JpzRFD8QY7WjuKTED3NTDQ5Y78NL2JAt5OVadKhSaQv/IWs5AlfoCDG5PM8VN3flp9m84Ly5VpH3w06asR53qIGYF+z6hXbZFRvWI8MYW8/KH5D9gOxKV2hRRNcSp4eXCQo1KhQJtRTBA8YuC6G2C5B+meZj36m2DG+Z9G5FPRaATxNW4H876ck9+ewGidvZiFsC5NfUiKS9Ge0+fmbw3rqpzUyuPj+0FQlUaggVoWysNqWd7vKrKociUJlNFNqPBknoOp0fxikEoH3ud5KXA6QoWyIaoHuEPs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 2026-11-10 at 10:14 +0100, Christian Brauner wrote:
> Currently loop accepts any regular file that implements ->read_iter()
> as
> a backing file and any that also implements ->write_iter() as a
> writable
> one. That includes files on procfs, sysfs and other pseudo
> filesystems.
> For example, /proc/kcore attaches read-only as a loop device the size
> of
> the kernel's virtual address space, 64 PiB with 5-level paging. sysfs
> attributes attach read-write as 4096 byte loop devices. Writing a
> block
> to the loop device of /sys/kernel/mm/transparent_hugepage/enabled
> changes the THP setting.
>=20
> That's not just nonsensical, it can be abused. Loop calls -
> >read_iter()
> and ->write_iter() of the backing file directly from its worker which
> runs with kernel credentials. But pseudo files enforce part of their
> access rules at read and write time against current. Dozens of sysfs
> ->show() and ->store() methods call capable(). Behind a loop device
> all
> of these checks are done against the loop worker instead of the task
> that opened the file. And setting up a loop device requires no
> capabilities, only access to the device nodes. So on v7.4-rc1:
>=20
> - uid 0 without any capabilities can't write to
> /sys/kernel/reboot/mode
> =C2=A0 as mode_store() requires CAP_SYS_BOOT. Writing "warm" through a
> loop
> =C2=A0 device works.
>=20
> - uid 0 without any capabilities can't read the files in
> =C2=A0 /sys/firmware/dmi/entries/*/ as dmi_sysfs_attr_show() requires
> =C2=A0 CAP_SYS_ADMIN. Reading them through a loop device works.
>=20
> - An unprivileged container that was handed a loop device can't
> change
> =C2=A0 gro_flush_timeout of its own network devices as
> =C2=A0 gro_flush_timeout_store() requires CAP_NET_ADMIN in the initial
> user
> =C2=A0 namespace. Writing it through a loop device works.
>=20
> The same goes for hard_offline_page, the md and sd attributes, rfkill
> and others.
>=20
> Refuse files on pseudo filesystems as loop backing files. Note that
> file_is_pseudo() looks through overlayfs so stacking overlayfs on top
> of
> sysfs doesn't get around this.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0drivers/block/loop.c | 3 +++
> =C2=A01 file changed, 3 insertions(+)
>=20
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index c96e35c3ef42..1482580a1979 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -537,6 +537,9 @@ static int loop_check_backing_file(struct file
> *file)
> =C2=A0	if ((file->f_mode & FMODE_WRITE) && !file->f_op->write_iter)
> =C2=A0		return -EINVAL;
> =C2=A0
> +	if (file_is_pseudo(file))
> +		return -EINVAL;
> +
> =C2=A0	return 0;
> =C2=A0}
> =C2=A0

