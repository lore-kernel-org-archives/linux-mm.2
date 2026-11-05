Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9111E606EE94
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 19:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BS3XZKDa
Received: by kanga.kvack.org (Postfix)
	id AE6936B05B6; Thu,  5 Nov 2026 14:29:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABBAA6B05B7; Thu,  5 Nov 2026 14:29:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AB906B05B8; Thu,  5 Nov 2026 14:29:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7AB5F6B05B6
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:29:03 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1A1FB1C4588
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:29:03 +0000 (UTC)
X-FDA: 85402053366.21.7DD5E48
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 47451C0008
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:29:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BS3XZKDa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793906941;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bwgr0VzVaD2N9H/j3vgcXycx8H7hODk9Lndt/rv7J/s=;
	b=uycEF0y+iXB+ar69uNGaWO4V4yOTi9rAQ0zDxe+MEaODObsYRWTVZjlk1bCT4tUKGLopkg
	CRv+Q37iogL7OVEzh+ylWSSwikVuSWrhxNGKAVJQ5cWXeZOQxG0G8B4WGM/HtybQU9gXRX
	5hn7Dez3g72b+y7r9/HpV52tIGJ0NfU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793906941;
	b=Jd/RLQcojLSA0GhKbo6xUMuKfF0Vkm2+ScWmrVUOq4zxsY24j37EYNMZsXgFUcOkk7B11h
	X/e9OSXbY3eslxbX5XQ/8m6st/8T8QLE4xAI/NslMgo0MmYLzHzVR4ejD4qAgJibhhYtnG
	N3m0QyXFc6NHFscBQVdRoFc1aj/nzQQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BS3XZKDa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9619643BEE;
	Thu,  5 Nov 2026 19:29:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BECE1F00A02;
	Thu,  5 Nov 2026 19:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793906940;
	bh=bwgr0VzVaD2N9H/j3vgcXycx8H7hODk9Lndt/rv7J/s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BS3XZKDaZFqTzEkNK9cZ527vT05nQuRqIDjUKiUIf9jx85/EdPLYb0Z0y2P1F/dSr
	 cLz8PVwZTDq2+LckdmqgyJzYBdcLi6vbD+TgraxVJ/TKav0Apjdcte0M2LitavcWXu
	 31sb0JElkWITsGXKzYHHXBcox2SfnEE32gjOr2QsFbRND4hlqQRt2MMTyGa/6k8cHB
	 YEmqHkJb3KndD7l0LYWjOi4ddQ9wbEk5wPLHn/WamkFT57rjTzOkA05yE70xCSrR5q
	 981HyR3mf5h9r4lxyP6tj4pIri36VruMAV5ujmeRAKVrr3ZhUPLCXFzWwc1wxgznlM
	 PAXiCJ1oQKLsQ==
Message-ID: <sashiko-outbox-199869@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 06/51] powerpc/pseries: put the node that the
 ofdt property commands look up
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
In-Reply-To: <20261104-work-procfs-bugfixes-v2-6-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
 <20261104-work-procfs-bugfixes-v2-6-021c84d852e0@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:28:58 +0000
X-Stat-Signature: fu9ihtco69jqjpkoy3pyzbes7xbyr13d
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 47451C0008
X-HE-Tag: 1793906941-555360
X-HE-Meta: U2FsdGVkX1+dBS1rp0XLeakB4Xq3/Tdd/iaXYsMzMmvBGfvgK1zpMpy1wRxcqk0TCav6yfN/LANXUf2Bt4O7v/9kHX52MZGzFk1fe4gnhHPC3FNvmg6mpOYE7Luc3mgU+b7wQJ6+fgB8FT+KWaGSAlqXxaVSU2FuV9+s+QFHXeCGk2/rcHO/6AfYWRpwUt1xqj/24gVEtkkcymxDaTT/6IMOcbrZRaRCd+B8hkcyeO2F9cUDdBM7RTQWq4+C/SNKxM1M7ROEGYoINzmumTzjR8liSDMYzHhj/7vBGQ89g09T8jSwGVUlxMBnl0Cobw3eXqn8oytnRT7Wq+FMoQ7P/61hcPDw75ukSX7L1tW0iSzHw1rknM1xrHq0u+hssIZ6NPKxQdIop5q/Fza3eoQtKYgv+acTjnVajuT9aUxGHZaeKCBXo6Y/QjnuoheoOSVwOKeMjzxv9dpMN4HMOk7DdKNSEqyNDY/KR5wYa8t0/LX1VN6VK9zRdF+aNYZ25zeVjLft4aE1emXrgT9RHkLdRzIMTMvPee0i0bv+QQUtMGU5vAZpk2mQBpLfC/FabMczp8fnatjVWNOcTI3SOQE7lyJADAm/NPWRzCuh4c2+b/5zCHa8VqyDeZaLUhIOJEVmf5+Mi/MXDysZqVT5qZWqGSQ4BjMgt8rSf1ORwgnSPxyOCfAGJAhvY4u2qMrXm1Evr99GoxxIHfrSAOMG9QwxRLyZWDhL85F5Air20sjk15xEtb+sxKd664Wq/K9UT7157rR4QbMZT3nYeIcBkdwZxAjRj/Aezb2X0mbaXuVhBme0DWlww1Y5fbfMZ9T8jbm0a1G9bjlwq17z8b0bjMdyFONfIa0aaHCkxUgdHm5+l6JTNNqD7hg0JQ+/92dYxaP7uTPLQlmuYnSdwchicvNj6Z4tlchZmOxbkCx3GbkTde1KchC0RO7Fgk2jdFraxgxTo/1+CMVxNtnd+2r5mxY
 arPxy8v1
 jPRar7iflvS0jQ8119Yw1fiQXDwh5l4b1QqWQT023UWXsRKVDQ6HHxfiEi1KZLA43pRgJEOshmYmaaaj0pV08z19ojmSYjhk5u3+s7lLB4EEDEF6hnd7aPuv3fIoMRAOXujWAGdajJ8kKr2F2vy74/dWgomzTTmtHlOshOGcqMOiDo9Zpy+IMrg+sdVzVN3ShOOJIpS8ZgOPxx1lFfyuAM9sdQEWTPALdzrQnRDRhmpU6xY/t5bdgPPmBDRt/ctccCsGnP4cPOOjdiyVGMqL3R6gzRnw3HxgA2+7UeH9j00SwmVKSjPfjV5w+w0EUXubsbflft7oRzgdW+6wuUrDx6bjN1K/ZMfYHKZd9NugTOnfvZrvvQlRLf6/ohumA4YA3rtlPJumpEGe7hpIOwLGiaY2x2N1a2Di0osDsZftSTbvTaTgg1Lr3SHaknB6hHRhU1RcgpP1xXpxP5ooHav5hn9A36ZvMh3PnOlHy8tegBq8Fm8er52RqXSYIE07LvOvYI6yImWsM2uES2aexAyfQMKISCXRNhkt30wORfiCgDPgt4Y+Sfc4QsN9GtUvDnmmb+X79hle9AUnWNhTqaR//uaqtIApitlrvmKFChtYghN7UOFGN0RcwLlFsuKjCG0BEUgahuTWq1eijdtUHoJY1AOqnwsuJhCQ8iQCXwUapntMnK0rWF2Z+hR7Ug0xwLZbxSqif
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
- [Low] powerpc/pseries: __free(device_node) declared =3D NULL at top of fu=
nctions
--

commit 3c337546ce05e068449f95031255af375235286d
Author: Christian Brauner <brauner@kernel.org>

powerpc/pseries: put the node that the ofdt property commands look up

This commit uses __free(device_node) in do_add_property(),
do_remove_property(), and do_update_property() to release the device_node
reference obtained by parse_node() via of_find_node_by_phandle().

> diff --git a/arch/powerpc/platforms/pseries/reconfig.c b/arch/powerpc/pla=
tforms/pseries/reconfig.c
> index 18e3f1a036e35..5a0c9c0b6253f 100644
> --- a/arch/powerpc/platforms/pseries/reconfig.c
> +++ b/arch/powerpc/platforms/pseries/reconfig.c
> @@ -271,8 +271,8 @@ static char *parse_node(char *buf, size_t bufsize, st=
ruct device_node **npp)
> =20
>  static int do_add_property(char *buf, size_t bufsize)
>  {
> +	struct device_node *np __free(device_node) =3D NULL;
>  	struct property *prop =3D NULL;
> -	struct device_node *np;
>  	unsigned char *value;
>  	char *name, *end;
>  	int length;
> @@ -296,7 +296,7 @@ static int do_add_property(char *buf, size_t bufsize)
> =20
>  static int do_remove_property(char *buf, size_t bufsize)
>  {
> -	struct device_node *np;
> +	struct device_node *np __free(device_node) =3D NULL;
>  	char *tmp;
>  	buf =3D parse_node(buf, bufsize, &np);
> =20
> @@ -315,7 +315,7 @@ static int do_remove_property(char *buf, size_t bufsi=
ze)
> =20
>  static int do_update_property(char *buf, size_t bufsize)
>  {
> -	struct device_node *np;
> +	struct device_node *np __free(device_node) =3D NULL;

[Severity: Low]
This isn't a bug, but in do_add_property(), do_remove_property(), and
do_update_property() in arch/powerpc/platforms/pseries/reconfig.c, np is
declared with __free(device_node) =3D NULL at the top of each function and
assigned later via parse_node(buf, bufsize, &np), whereas cleanup.h
conventions require defining and initializing __free() variables in a single
statement.

Since parse_node() is a static helper only called by these three functions:

static char *parse_node(char *buf, size_t bufsize, struct device_node **npp)
{
	char *handle_str;
	phandle handle;
	*npp =3D NULL;
	...
	*npp =3D of_find_node_by_phandle(handle);
	return buf;
}

could parse_node() return struct device_node * directly (and advance char
**buf) so that struct device_node *np __free(device_node) can be defined and
initialized in one statement in each caller?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-bugfixes-v2-0-021c84d852e0@kernel.org?part=3D6

