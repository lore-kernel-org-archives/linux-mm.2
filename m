Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF33E6078573
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 19:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=icO3rWLw
Received: by kanga.kvack.org (Postfix)
	id C9F346B05C6; Thu,  5 Nov 2026 14:35:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4EE86B05C7; Thu,  5 Nov 2026 14:35:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B65BE6B05C8; Thu,  5 Nov 2026 14:35:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7FB356B05C6
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:35:34 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 185F7140BEE
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:35:34 +0000 (UTC)
X-FDA: 85402069788.04.4B2F813
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 735A220004
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:35:32 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=icO3rWLw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793907332;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QnupmpJjcDSUenY+8iHhV2pDdP26FR+grPEd9BKN+Wg=;
	b=HykfkojkUAZT1TC56LBXvay4/vadYBasGzyDJPFdKK33jSuwgLxuk9KjrQyxKAtXjbzp68
	oqQ1lfQ6iNJkKA2IOCEB3/pSHWMqXhnbOWMlHdqWcmhABQ45uZnjOUtFR7rvLbqXyk80mA
	S2/ScO2+AgZ7litltjuV1F8Tk4v2EZw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=icO3rWLw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793907332;
	b=jenOIUsLv+JETLvt1DkLe3tY8pRWnaR4EKztI291R76aEbgvUNcUdzTwRoUycleld9EA2P
	NSCuRHisviZGwmgPuSXywH4mQMPJzAatfFnJ0hNSBqG6wJEx8b0B8rXpRVj+YrlLW3Xv0V
	UqBf1/v1LYquqPbUWpG4c2x/+WAc+9s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B12BC43B0A;
	Thu,  5 Nov 2026 19:35:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E09C1F008A1;
	Thu,  5 Nov 2026 19:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907331;
	bh=QnupmpJjcDSUenY+8iHhV2pDdP26FR+grPEd9BKN+Wg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=icO3rWLw6nKGObCQJgYMxAh2P6PTRzIdDeuA404d8zGUUVnEp22awIUt/ONskepjG
	 FQyNYgueaW+0iYJhp0FqJ+XOW2y+yurI0uUuh+dfsOclM2Nh3qdwIC3ytuTEQmNhzr
	 MTetr7AbbAQJrQhhBXugv5fx//leXY88njWHb3TZ3743y/bVbrU4sQkjQK81piouKz
	 MGYh6ZeJ6sFNsrOgjNWWNWno+Xud511eRRatEpGCbh1xHAr4ri1vGAQGPMtUR0YyMD
	 sstDXtwDG9/n6Jsu5U178yWJP4hODLvoqYoWfkpM7RkF01wue3ewhl7sYNSjaz7bA6
	 sSwHZw/oTnT7A==
Message-ID: <sashiko-outbox-199938@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 08/23] proc: let procfs own the seq_file of
 proc_create_seq() and friends
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
In-Reply-To: <20261104-work-procfs-core-v2-8-76ace653a773@kernel.org>
References: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
 <20261104-work-procfs-core-v2-8-76ace653a773@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:35:29 +0000
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 735A220004
X-Stat-Signature: nappsrsoee6x6pg5argyewopm7eay9r7
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793907332-641932
X-HE-Meta: U2FsdGVkX1+PtAg+sJpC+jKxaWIasL82JjKUN/nwVGBcBz9Ab8ofRgq4EIxwgHB4zQoCcv5SfOWutwl1gi1pPfhEG1o4bilAeSj6W9XyVxHgPrQbQNUw1uICau1dyhQYqb2RqjHPt4E4BzJA5OFyPEA1GPWHRnxCnf7nQqBL/N/cpmkywPaM2K53QakD3besS1tFFdc2Kp9rrSVYEy/TU/sDU1tS/uSOJh74TnmvhKdjV/MYO8Rj2WN7/5psR8wcARAxL8rk6VsncCVcJMdfb74XUPXCCwNfOq+H8l55hCMei4TV7CmLitBRUigvlvPvTGwYxtOtZWmRkzAuye+mFhAXjFmxxt/jZrVXlJSTmHBWaPzthatvvFZ8nVyaoDy5XxdfrmWetrc7LSnC08wwBByo/6IItEq0dYaNoRAUsRctNkTgZE+QIhLI0n4tJPIKIM65P59pO14m6CZOpD/b2GB9TDwsRTmAfh2u/wlHj66Cb/L/QWs0DkCDohvdug0PTST8o8ET0tTkIRSJOxipKGhb3SdFMcpv/3G5613FERqTf++FDGYPEjSU8pTd1EQLSyknVbj7IuEbQ0njk2FzyKM3w+HwXa9ox1NHpKhkk4X5+xWUaAoC6xl/Temu/Tyd28vp6PKozHtzX4J8+zv1lnyeIXFxzycfZLExFaaziCvM5MdePJu9GJSCsLnURb+FGKiKG+d3vnfLcLjwHldq+oPVSlCB0UtUmox/DwyNR6ZR8LiJTMiR0INnLUm7bJH2DRrIoLqQltp09QZqyuLjk3JEolKKLvS3vzttKZygwZsP48BYKPfUOr9GUHDyBEk14JiZD/KAYIq6Y4zhZjHlcvOZZ/PqQLO1C7LXPfTLJNrVM/ZZmnMu3310BojshGztltE+Rc/W6AbDKH6Uc0esyq3djUnZHw6tj+fhFS5W9i6ZmzxnWydnvqMVu2i4P5z/+MU/n8fXlZpln6gPSYh
 rEdz4esG
 1jUmDwu62kFWoYb9JJLrFo14mTAJgLszMu2ksSgkPp+Dza2Ro+VbS8hlaUp7P5j2VTwVf8r6DKoatOfPsNaKoFG58CwtujMboGoqKnTpdxA92/BEyMfRFuM/ka/leICz9g1HIsAIUURo/5Rur9eWjeGbzsdqJ33Gu1YDEa5T8TmNsUCPGty6t3GqNMqeRKSPs5Sgk1/S6ZivNjOk1uUcDgeM9aAC0d14UBZSMH9WpKD2Ad3Bkvt2WgoXVkNePo6FglNnrpjSaVkOMD1R8H3glg9rkegYIr4TXSZGKLFTmkD/A/S+g1+6SLlHnvSOe1GflAOmbiH35lYOpENLcf2e8+W94YGGA3kC0jeo2EW9vS3vIOAZ7Yn8NGgWs4Zd7cObMbhl74WR6L/Qr5gkiXv004bcuB8qcKd+Z/tmgP4jaWR4dpVzUW7CvBuUAKFS0Yo5zpM+PchF1lppZxec2IYLnR7MR8zCvrbQzY9mvd3PLyoq78SCzHkUkavKEf89+FO3gg0vYxB/oehLeRAfrkaBjXxHBkGig4mTcq2Oj9vSbvPklpobYZhO0R0rW0P0kRNATuepL6BY4fBnkn1eFw570K95dz5RXwqgoHye7N99cmLUfjG5wOJm9zHe9dXkBX6bfvCG7yRL5qcYWRZ+AqRoIMkNtMU1V+zgTmLUPfMSJ3A+65sSR6H8d+lSGGNb3/nZT5WxXvPrkdv3m88ptWbzK0n3bxg==
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
- [Low] proc: unused-but-set variable p in seq_open_net() when CONFIG_NET_N=
S=3Dn
--

commit 4dea51dab83a49a4131e34ad5f96bc9822052389
Author: Christian Brauner <brauner@kernel.org>

proc: let procfs own the seq_file of proc_create_seq() and friends

This commit updates proc_create_seq_private(), proc_create_single_data(), a=
nd
their network namespace variants so that procfs owns the seq_file directly =
via
PROC_ENTRY_proc_seq_ops and PROC_ENTRY_proc_show. For the network namespace
variants, ->proc_open() and ->proc_release() are simplified to only manage =
the
network namespace reference.

> diff --git a/fs/proc/proc_net.c b/fs/proc/proc_net.c
> index df5484813d5dd..9973f846c4674 100644
> --- a/fs/proc/proc_net.c
> +++ b/fs/proc/proc_net.c
> @@ -37,13 +37,13 @@ static struct net *get_proc_net(const struct inode *i=
node)
>  	return maybe_get_net(PDE_NET(PDE(inode)));
>  }
> =20
> +/* procfs opened the seq_file and allocated its state, see pde_seq_start=
() */
>  static int seq_open_net(struct inode *inode, struct file *file)
>  {
> -	unsigned int state_size =3D PDE(inode)->state_size;
> -	struct seq_net_private *p;
> +	struct seq_net_private *p =3D ((struct seq_file *)file->private_data)->=
private;
>  	struct net *net;
> =20
> -	WARN_ON_ONCE(state_size < sizeof(*p));
> +	WARN_ON_ONCE(PDE(inode)->state_size < sizeof(*p));
> =20
>  	if (file->f_mode & FMODE_WRITE && !PDE(inode)->write)
>  		return -EACCES;
> @@ -51,12 +51,6 @@ static int seq_open_net(struct inode *inode, struct fi=
le *file)
>  	net =3D get_proc_net(inode);
>  	if (!net)
>  		return -ENXIO;
> -
> -	p =3D __seq_open_private(file, PDE(inode)->seq_ops, state_size);
> -	if (!p) {
> -		put_net(net);
> -		return -ENOMEM;
> -	}
>  #ifdef CONFIG_NET_NS
>  	p->net =3D net;
>  	netns_tracker_alloc(net, &p->ns_tracker, GFP_KERNEL);

[Severity: Low]
When CONFIG_NET_NS is disabled, does initializing p unconditionally in
seq_open_net() trigger a -Wunused-but-set-variable warning?

Previously, p was assigned via __seq_open_private() and checked with if (!p)
outside the #ifdef CONFIG_NET_NS block. With that check removed, the only
remaining reference outside #ifdef CONFIG_NET_NS is sizeof(*p) in
WARN_ON_ONCE(), which is an unevaluated context and does not read the value=
 of
p.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-core-v2-0-76ace653a773@kernel.org?part=3D8

