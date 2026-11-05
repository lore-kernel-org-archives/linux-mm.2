Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B023606A6E9
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 19:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PS7EuTM4
Received: by kanga.kvack.org (Postfix)
	id A7E656B05B5; Thu,  5 Nov 2026 14:58:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A55E36B05B6; Thu,  5 Nov 2026 14:58:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96C5D6B05B7; Thu,  5 Nov 2026 14:58:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 758B76B05B5
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:58:20 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 05B5A80B81
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:58:20 +0000 (UTC)
X-FDA: 85402127160.23.E1AA4F2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6164420005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:58:18 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PS7EuTM4;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793908698;
	b=A4Jk+aHHPL/55hXic3i3dS17Cx0GJLc0GvqvOVgKv3c9E7pd+rTssfY2EtsBNReSVIRw5q
	RwoU5s2Auna1RgnWRtBPwLuw1HL1BiiunVKnGIRdMIL2CfI/wwBWbk/ujvbVVGREFPkqrC
	7SihuChs34iA1QK03ZfB1745gLEwy9A=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PS7EuTM4;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793908698;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Di4Zv2+bgkX+HhZmCpdKbhvfGlZoAaFGwpTTtNZDf1w=;
	b=47IGgsPM40R1OuwW9BoXxvsRHmUHLAtvKH8oCwIAff2kasQnZfzrIS/VQ7VEaanvb5TXA7
	/6U8HyGoACW4u0XSKz/HvhvCVNt7Yp61ep4GqXTIe16KTJQUruy+RYCBYWoLeeSLxCq8KK
	LOckIjD6bC6DAuSXrQxAgFfI30UFdwI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9F0D142B67;
	Thu,  5 Nov 2026 19:58:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E4B01F008A2;
	Thu,  5 Nov 2026 19:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908697;
	bh=Di4Zv2+bgkX+HhZmCpdKbhvfGlZoAaFGwpTTtNZDf1w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PS7EuTM4dqldTrwdAR0onQbkCjogqgjpUy8oBN5Oi/jsHPd1HPHlgSGbxScX7TULM
	 hRB6vR+pRSsaVGMqkA0T2yAO/9EP8dfTHiI3smO+XSdOQTs0WaU0CSspRWwNIygWmH
	 xxyaJ/jl5nVv4oGCeueAnyoM+i/SNOz1yePgzX6SBUyU7ID4QMKKDqnCau9Fzxv22l
	 9yUUQnAUlAQfxJYnkuFIsPSnTWbDHjOSLzPYjAQnKTCY8vnyzOnX2r4MnJUC80Xsxq
	 9G6Oxyszcx5C+PQB+DFxzoyTPD+CIGBL43AvNqSOHfSpIHjw0LBt6ISDjfycxH6Ryo
	 K9q3hUiMFf+cA==
Message-ID: <sashiko-outbox-200057@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 23/30] dyndbg: let procfs copy in writes to
 /proc/dynamic_debug/control
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>, "Jann Horn" <jannh@google.com>, "Josef
 Bacik" <josef@toxicpanda.com>, "Chris Mason" <mason@kernel.org>, "Jeff
 Layton" <jlayton@kernel.org>, NeilBrown <neil@brown.name>, "Eric Dumazet" <edumazet@kernel.org>, "Thomas
 Gleixner" <tglx@kernel.org>, "Al Viro" <viro@zeniv.linux.org.uk>, "Jonathan
 Corbet" <corbet@lwn.net>, "Christoph Hellwig" <hch@lst.de>, "Greg
 Kroah-Hartman" <gregkh@suse.de>, "Joel Granados" <joel.granados@kernel.org>, "Kees
 Cook" <kees@kernel.org>, "Jan Kara" <jack@suse.cz>, "Jan Kara" <jack@suse.com>, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, coreteam@netfilter.org, kexec@lists.infradead.org, linux-pci@vger.kernel.org, linux-sound@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org, linux-usb@vger.kernel.org, samba-technical@lists.samba.org, sparclinux@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-serial@vger.kernel.org, "Takashi
 Iwai" <tiwai@suse.de>, linux-input@vger.kernel.org, linux-raid@vger.kernel.org, linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, "Chuck
 Lever" <cel@kernel.org>, tytso@mit.edu, dmitry.torokhov@gmail.com, "Petr
 Pavlu" <petr.pavlu@suse.com>, "Anna Schumaker" <anna@kernel.org>, yukuai@fygo.io, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261104-work-procfs-fs-v2-23-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
 <20261104-work-procfs-fs-v2-23-319e0f9a8aae@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:58:14 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6164420005
X-Stat-Signature: 51wst9betny3iae8z6f8c511ugoatigo
X-Rspam-User: 
X-HE-Tag: 1793908698-17621
X-HE-Meta: U2FsdGVkX1+Tl1bIyGshR5uVPKye0cWjrSK33GEi1gQHTm01Ob9O9yWXQuVH4YP6k2R4/jRf6ihQlTD1zNY/WWS2b8Dz8D8fOL0lx6lTvvLEVhVAzOQqsEopnvTIHMWQ4gxvOI6mLNrLUMYhSHYaT3U4IAIosoKROTtd2z3uCdDuXSlG96sVeceH9ct0BTG5Ix/umY4h/oxJomWogz3g8jy7NCqidqzJzIc5gdHQssZUwvkheKJGiI9fZ/yZMTz8LBobXUWRnuWNaihayAAfShUqbybH246jFF+48bk3HV4zy7cf2llV1X7PxUrJYz2RAP/htw3uyUkq8KpCIsijznulWgA4aru+NuUsPiT9DKI8yIRBDFL695yRqNNKR6dhDzs4i1grMmzV1JWEUhdrCNW2oKA44PsuOFs5GEWRmhRZom/jlPhcMuBBQXM8lhhbWNLh0T53LBwXUQcy128uT//jTBHP/K7e4/23YUVTCfyBFXNEFRuM0NYz8zJ/FzzLbBz041GDJYXao6E2hClVs/juRllAm4p3NwL5OxMz7gzjEjTFC9+B+b2JlF0/42/LGRmS7Y/ZddMyBVcob8Rg6AznE6Df4AMpeo7WHOQZPa9KpYU/oYL2YAN4RknEXhKOdRhAkcnu9TZrnT6CgUyUIW37Rfyd0XIBby8COC4jQ+qDd2/F0Vv6yRPMIxBfG5o4fVlRZA2LRee/CgzaC5iijccJ4DXsUtujs5Pexu/3GR8CxnWW92FBidI0yLgqcZfcypPF4LwlqproyjRORYNHE00AYp2I0K+NepoOCKnds3aT08muhbbDyFicQjMM/SEonJBT1BozWAv9wbJJVkhfUGEBfoaHL2YMIitWCm1XiTUIafJkmbH2EB9OV59Oag6dQ93eQ6Dr6lZxACuu9gDw2dScbKDMqzmxT6Gqs+kRt0N69CkG1jJAkgiV1QnmIbSs42eUXtR1JnLIQ+E0/OH
 4HslXfCl
 EMsRyTQ2US8a+rLh+oUpqtw+mL34mRDN3Io+usSNJxjHx2D+vETRL5DiwPHELfxYLMdm+nHx1wLKcOICrWUBWqiQgkPL90QdvGH0WkU2V2V3zWmbGFBbVhYmf/x0PXtuTHQem8F5uaJXWApqcQ11pZZ09FjcQnPih+szk4dluLb+X5JtgUowpso+zE1gtL1E0F/YhUKJGIepNv2RA2iSlPn4kNjJslUBFdl0m2NV2zP4/WEA6PdXz6knLxAGvaWNRbwTM9W8a6QndlLNiL20biJ2hLIaXm2earCbJVgk2JD3lczmVFoToW3MzvLlqsvMUTky7Obo/9ophxDxU+jCD4Ho+eXOslN5lxH7oThh/KNZYcn7Z2lWCESUwpnLEBhZGPfzxUKrawUAVKB5hmhOJwT+4Hxm4WQ7teqMYHZ0tHlsdAhaCCznP4wyoolj+uPvqegqZoiZFArfaBEdqO3kkrniBZWiCUPyV+Wzc5OMhXo0wMaN59YtH4MSON4PAHzAW+pWU1WC87x4EHljYsKMFD9LNbsLU6pFelD6XL3ZBmrQuPDV80QE2wTw1hKDXEfNgAa4jtgZprbOZwNJ+ojqhvMavZ/5H3qvBT3VGcIbUlS0V0LZ5KmWwWbItv5ryte7pLy2GTih974MWVAUduYlDaXN3h/cvDq3zmTYuNmjxtnL59J4NwZsE9vd6k6L2TVp7k4IIImO5DtVsBX0P4dFIlYMbQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] dyndbg: split declaration and assignment of __free() in ddebug_proc=
_write()
--

commit 1bfaabab91de2989a4d10ae03eef349ab77809d6
Author: Christian Brauner <brauner@kernel.org>

dyndbg: let procfs copy in writes to /proc/dynamic_debug/control

This commit factors the query execution logic out of ddebug_proc_write() in=
to
ddebug_proc_write_buf() and switches proc_fops to use .proc_write_buf and
.proc_write_size so procfs copies in the user buffer before pinning the ent=
ry.

> diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
> index 64a2112908725..1d6012c9eb41f 100644
> --- a/lib/dynamic_debug.c
> +++ b/lib/dynamic_debug.c
> @@ -1002,11 +1002,28 @@ __setup("dyndbg=3D", dyndbg_setup);

[ ... ]

>  static ssize_t ddebug_proc_write(struct file *file, const char __user *u=
buf,
>  				  size_t len, loff_t *offp)
>  {
> -	char *tmpbuf;
> -	int ret;
> +	char *tmpbuf __free(kfree) =3D NULL;
> =20
>  	if (len =3D=3D 0)
>  		return 0;
> @@ -1017,15 +1034,7 @@ static ssize_t ddebug_proc_write(struct file *file=
, const char __user *ubuf,
>  	tmpbuf =3D memdup_user_nul(ubuf, len);
>  	if (IS_ERR(tmpbuf))
>  		return PTR_ERR(tmpbuf);
> -	v2pr_info("read %zu bytes from userspace\n", len);
> -
> -	ret =3D ddebug_exec_queries(tmpbuf, NULL);
> -	kfree(tmpbuf);
> -	if (ret < 0)
> -		return ret;
> -
> -	*offp +=3D len;
> -	return len;
> +	return ddebug_proc_write_buf(file, tmpbuf, len, offp);
>  }

[Severity: Low]
In ddebug_proc_write(), tmpbuf is declared with __free(kfree) =3D NULL at t=
he
top of the function before the early length checks and then assigned later =
via
memdup_user_nul().

Per the cleanup.h guidelines, could tmpbuf be defined and initialized in a
single statement at the allocation site instead:

	char *tmpbuf __free(kfree) =3D memdup_user_nul(ubuf, len);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-fs-v2-0-319e0f9a8aae@kernel.org?part=3D23

