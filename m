Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B95526076D94
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GlNn/SoM
Received: by kanga.kvack.org (Postfix)
	id D16426B05CE; Mon,  2 Nov 2026 09:51:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC6866B05D0; Mon,  2 Nov 2026 09:51:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB5D56B05D1; Mon,  2 Nov 2026 09:51:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8FBBB6B05CE
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:51:43 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1D9181A012D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:51:43 +0000 (UTC)
X-FDA: 85390468086.26.A74E2BA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 37441180004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:51:41 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GlNn/SoM";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of rafael@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rafael@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793631101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3PMBNHbf4ph/mdyR65c545+LMS26XozggfD62W0AADg=;
	b=aUk/Yl6RzpeqL2hvDGth5NzymnJmhWGEcnhSdNQ/0ODE2OaC0CWaB0sbMXCpgTwZyvoMrt
	0cVjJiuQwPRirOw899FRZDWldjIaCfFw2/1fo4eBdczbTjuoG9PsRX+NOy+JTt88JJu0/O
	NzEnvANA8vxy18XEy660J+rX2sMkgdQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GlNn/SoM";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of rafael@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rafael@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793631101;
	b=evN0tFNE7+IuimXP5e0sne7kEXUNYdB3RfHSs6cjfEQpaYjqLB3I0Nzo/T4Ny6aNMlsKDA
	IPVGtRtgp1xUa9C5MAImAB/57KDQ6X8RwMhRhDwtkc1t4yy1RpeaIziz4ObBTHABhWuN1i
	xo5zWYZWdYsFpv4VgYiRVc/PRQA9NDA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 884C643BA2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:51:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69CAC1F00A1C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793631100;
	bh=3PMBNHbf4ph/mdyR65c545+LMS26XozggfD62W0AADg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=GlNn/SoMWD5zqxxqX/eCuEquiTNPRgmYC+uyTlQFZ16kexqk/KmCRp3INGj7ss8oQ
	 VUu1KkbtGSGsG3pM3YZ4MDiwbG5YrkBKBiN14T/X9emJ88g5DPj3pIXVn3phJmyVow
	 KX2JEr2f7UDK3U8ijM+CbxeE6tC6vIkI/nKJYJzvIxjwONjYrUXdb0ed56rsLZ06JR
	 rdYISyB5bt/rhPIvfR1HgK23GVD6ypB685bMRxWVtqNBK0a9B3nWL37+brdRtxbv2s
	 OHz5HfLYY/uUgJVHbpI/TT4TXRUNjrxgB4dmkRp6j56kdwhka9W+cvSiBS0wLtgATL
	 65EIv4d24CLeA==
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5bfc9154ceaso2414896e87.2
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 06:51:40 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvByRV+wa3bUrgJyE4NPm7Om+e8Kn67KcfBmNfm16t7Lpo8gft0YK37wYTASIoE2maheRvUezYfECtg==@kvack.org
X-Gm-Message-State: APuU4Z9c0iwXhwt+xenJMkn8fQLiQrXO2604sTeO56Cq1+pea+81STUh
	+pG8BAE98QTnmHUrNF09lBT3oOIxeXG16Yhh0VeqTsDWKL0oGQwpXt/yVEtZh2QtK76H9zASfft
	Oo882AOqxtuG7iBXh+DKSyfEpoi2EhSo=
X-Received: by 2002:a05:6512:39cf:b0:5bc:b0b9:f457 with SMTP id
 2adb3069b0e04-5bfd95827e8mr3755837e87.47.1793631098488; Mon, 02 Nov 2026
 06:51:38 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org> <20261102-work-procfs-bugfixes-v1-2-59422ed3e465@kernel.org>
In-Reply-To: <20261102-work-procfs-bugfixes-v1-2-59422ed3e465@kernel.org>
From: "Rafael J. Wysocki (Intel)" <rafael@kernel.org>
Date: Mon, 2 Nov 2026 15:51:25 +0100
X-Gmail-Original-Message-ID: <CAJZ5v0gw6xykAX3dvJmjhVOQudF8qKgKLViY0oXGzUWqDsWDbg@mail.gmail.com>
X-Gm-Features: AclHuK-8h3kqhIhfKB_FBrHc69T85DQwOpvSG7VveYTuGyJayTx7vBef-7fYqkY
Message-ID: <CAJZ5v0gw6xykAX3dvJmjhVOQudF8qKgKLViY0oXGzUWqDsWDbg@mail.gmail.com>
Subject: Re: [PATCH RFC 02/38] PNP: isapnp: don't read past the end of the
 buffer on a large pread()
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, Jann Horn <jannh@google.com>, 
	Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, 
	Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, Eric Dumazet <edumazet@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, Greg Kroah-Hartman <gregkh@suse.de>, 
	Joel Granados <joel.granados@kernel.org>, Kees Cook <kees@kernel.org>, Jan Kara <jack@suse.cz>, 
	Jan Kara <jack@suse.com>, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-acpi@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-wireless@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, ntfs3@lists.linux.dev, 
	platform-driver-x86@vger.kernel.org, coreteam@netfilter.org, 
	kexec@lists.infradead.org, linux-pci@vger.kernel.org, 
	linux-sound@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, ibm-acpi-devel@lists.sourceforge.net, 
	jfs-discussion@lists.sourceforge.net, linux-alpha@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-cifs@vger.kernel.org, 
	linux-fbdev@vger.kernel.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org, 
	linux-sh@vger.kernel.org, linux-usb@vger.kernel.org, 
	samba-technical@lists.samba.org, sparclinux@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-doc@vger.kernel.org, 
	linux-serial@vger.kernel.org, linux-atm-general@lists.sourceforge.net, 
	Takashi Iwai <tiwai@suse.de>, linux-input@vger.kernel.org, linux-raid@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, 
	linux-debuggers@vger.kernel.org, Chuck Lever <cel@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 37441180004
X-Stat-Signature: bhhgro3i7r17i7q6p7rz6nrxhajz8pr3
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793631101-376957
X-HE-Meta: U2FsdGVkX19T3pVP9tYZcx9ZzXj0DnmSoEdfhdAOfxLjL6LyPEFp8jVcYUEUvGp8koyy9Ad3W/o7PSsxQalmVNY+jWjT0/u46S8elT5M92dGtdGZuSgS4SOYqwRIjj2Gg28FWKVwKx7O4tsFBwOS5SN55HU7760MPgFCEt18iERUoPfgX9Q1dDJ0Gavz2eQClipIBvsgOzjlSlK5nK1GQgGeW3dNI/xiNB03JqmHBPK4hSf6yDC5AwkJQ8OA4+MBeSyl4e2pm3koIXlcqs/CEP8fqR/OIuy09p9MqREP/anYTShlFX3XYAMo0yEmaYBPxBZiAtUYzxNDwJh+HaJVkvxCWUm4A2zhWMoMNfHK69DK4C95Wu7lAg/Y5BfcZJ2HqqlIF6FUXPjHdESKQgVTxQgFR30fRa2GR/QxydPvk31LPbu4UhVGXpF9bMs70sc40o9WFfmdNdEIYBDZpd68YR7wUwMgXZ9FWrCW5uv/oZmePToWvUmtNcdt8MLAuoL45wAXqEEsWxk/omWvV3wO+U+CkaMjWuBppvACkMijjQFdbmZv7iTwrneD45NTdVWHBnDcQ/lGufmAJnpPr76B0M9HdBzWHj7Fvs7QE/wGUOu7MJdYKoaClxyBPZjrCgmg9zwAfE+kdbhOCq8THlwLDNYI5Nizn2y4CQ414dtasZEY3awQncJzpeK5fgxzHqywgD84HZ3qUqbyYqT357Jipd1dPx+nwplFhsuOc/JAgW7QrYRPLEaAfxbG2iuw9x6+wv3kkgYNrXLKsUof3U/XNaLYqjHzRwOtJo8hnI9V9JpAr8H3gh8G1mB9W9mlkIPXoMwHILtn9aDlOx0nuXZILF+pYPlbiLRsRrH+cKtpsw5cDZm9gk19I0KEcyoKAGSC4Hmin2/ZSsQERRj/4fqM1F0gmVjngAliLjyWanXR6WuA7+sH4+M0gR1WvSCTDtQ06YxNfQEjowYljaOaepA
 8e1GNYgV
 vtdjpndKTkXXALr/a7IfPZnWQPX2PbLvX3RXX9FnTIp9GYc6fZ02A/eVIqtzDNV7vBYpGz+vYeKljnbOACPvhKYv5E1TBYeUWa0ft7IPOH2SPVXXvdaCDSfX89YUBOsyB4o6FJo2xKlbDawtzDrQFZJpRvEb7FSls7j/atFDe0cByCjVOuCPWfmrmT6WsWHu8Yj5uCqosOuahqqAaLosf/5aaoLWISxecqsow3vW0JGUOeEHZ56XtuiBcwmNJy3Tqs8TNOP9QlAEn8Rul4D/mf82CdUAPeTMrvOgR5H4gpZCEDdiDqDZCowL7+hx33ezJ8/id3g4JQ/pJcviNbvbWypslQ8qwFogsKNEefOPzlBvQxPOzLg+H4RJEnA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 2, 2026 at 3:22=E2=80=AFPM Christian Brauner <brauner@kernel.or=
g> wrote:
>
> isapnp_proc_bus_read() truncates the position to an int. A pread() at
> an offset like 0xfffffc00 turns it negative, the check against the size
> of the configuration space passes, and the loop then puts everything
> from that position up to byte 256 into the reader's buffer, no matter
> how few bytes were asked for.
>
> Keep the position as a loff_t and clamp the count against what is left
> of the configuration space.
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Rafael J. Wysocki (Intel) <rafael@kernel.org>

> ---
>  drivers/pnp/isapnp/proc.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/pnp/isapnp/proc.c b/drivers/pnp/isapnp/proc.c
> index c1f6e6bd0eb2..8197c7f29743 100644
> --- a/drivers/pnp/isapnp/proc.c
> +++ b/drivers/pnp/isapnp/proc.c
> @@ -23,14 +23,12 @@ static ssize_t isapnp_proc_bus_read(struct file *file=
, char __user * buf,
>                                     size_t nbytes, loff_t * ppos)
>  {
>         struct pnp_dev *dev =3D pde_data(file_inode(file));
> -       int pos =3D *ppos;
> +       loff_t pos =3D *ppos;
>         int cnt, size =3D 256;
>
>         if (pos >=3D size)
>                 return 0;
> -       if (nbytes >=3D size)
> -               nbytes =3D size;
> -       if (pos + nbytes > size)
> +       if (nbytes > size - pos)
>                 nbytes =3D size - pos;
>         cnt =3D nbytes;
>
>
> --
> 2.53.0
>
>

