Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB1ABCD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 21:40:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F3796B0005; Fri, 15 May 2026 17:40:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A4AC6B008A; Fri, 15 May 2026 17:40:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BA156B008C; Fri, 15 May 2026 17:40:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0E1436B0005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 17:40:25 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8DCDB1A0170
	for <linux-mm@kvack.org>; Fri, 15 May 2026 21:40:24 +0000 (UTC)
X-FDA: 84770973168.19.A622A2B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9598BA000A
	for <linux-mm@kvack.org>; Fri, 15 May 2026 21:40:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qpCqy77U;
	spf=pass (imf25.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778881222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ut7AANN5nElwKGLUY0lhnbp+1RRiqivwknCkUgAInnw=;
	b=3xyphygxc8nnSYAZ/XhL2jMP4Uy2WNtp12iZn4L1elElcmZpuprs3gDpnP2znghVF8gn9H
	XE2oW8L16X3raxDVtlWBsPXyfKJvD0lEg3aRd7nMfJF+lrCdX8dpY29h+8kQVoGkLmp73g
	5JtiNSDrMC2eowEnfNvK23ZZ03GC+UM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778881222; a=rsa-sha256;
	cv=none;
	b=ZFiQjqhtYkz174X/nu1YZtqd1R79lxzEG+CxdvN743cO4IiVkVRQSBOmY4x61LsdDA7R+u
	8ijNgOwXE2R2vdlF944nqk9vc8x0CeNVdGnoOoSUW2D3lzzBrqZooxmOusX1iWAGSJ7mYi
	czmi9NtfbMNw7OGPQD5H3queGedV7Rw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qpCqy77U;
	spf=pass (imf25.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 61DE8445B4
	for <linux-mm@kvack.org>; Fri, 15 May 2026 21:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47FE2C2BCFF
	for <linux-mm@kvack.org>; Fri, 15 May 2026 21:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778881221;
	bh=yn5Ug5k2IASPmOnTWh5/NWKfju83Ji8V+BAWrGXvmqg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=qpCqy77UuxiJP5M69OT6OBhAi0drLyRIk9VrbL5PImuXKJVo+W1DGL1GTxyvwm/Ap
	 qYwzicA0HugWD3WdRdaqiY/qERdDF+qJ1yrOi80dBJMJ2lOnTNbAjGt057QXURnpdu
	 byM7OJvl/hvAMzB6gwZFP0SMXkNkbAhxODh/esykup4ZKSL6tD6QWIL7kRkgiCrvWQ
	 4c8rjPGv/7SheIbtlwMVjNkzW+2nRHjSPzGcpbRyqvRlyvup2g26IG+XkmKklpY6Od
	 D52c5rAlfSSCPy8Y7KdIS36um5pUDXFrzSJ2loLdDZtVaLknB5oRahkX+Msz7ANBRB
	 9GuEtMCHC/EQw==
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-65c5361142fso663683d50.0
        for <linux-mm@kvack.org>; Fri, 15 May 2026 14:40:21 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+nZ0SeVnwqCwFpmsmKhdLFJyVa8IgvZfgAkWnk1tsvuqVLVPItdapi2uuOd7niUbbpYLTsiSJ+zA==@kvack.org
X-Gm-Message-State: AOJu0Yy5RKS2dproB3Ehc15eMChHaD7hNHsdFjQywRc1irtLamjMHZOf
	S015ZgaO/mh0E90JaRN8J4NhiC2yG0K2LeIecbvImzh3JJdeJou6fafO3tEgJS4AljFQag5QBXD
	DVR9ppywaEMZGTsyJOc4Ms3X0uZrgxuAlmpm91Z4t4g==
X-Received: by 2002:a53:accf:0:20b0:651:d6a2:f766 with SMTP id
 956f58d0204a3-65e227bae88mr5109450d50.35.1778881220197; Fri, 15 May 2026
 14:40:20 -0700 (PDT)
MIME-Version: 1.0
References: <20260512053625.2950900-1-hch@lst.de>
In-Reply-To: <20260512053625.2950900-1-hch@lst.de>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 15 May 2026 14:40:09 -0700
X-Gmail-Original-Message-ID: <CACePvbUj0-fAd-gjRjxFXYz22hGQaT9upFL85KUqD=W=SWX+0Q@mail.gmail.com>
X-Gm-Features: AVHnY4IVYDXe6JpHvzKEq9XldjgLC8IpryDPCEhie3HNTVfz3whVFC9mf8Ia0bI
Message-ID: <CACePvbUj0-fAd-gjRjxFXYz22hGQaT9upFL85KUqD=W=SWX+0Q@mail.gmail.com>
Subject: Re: improve the swap_activate interface
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	David Sterba <dsterba@suse.com>, "Theodore Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, 
	Chao Yu <chao@kernel.org>, Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, Carlos Maiolino <cem@kernel.org>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9598BA000A
X-Rspam-User: 
X-Stat-Signature: csuf6ytxiemgr3xwcd8aposr3jb6uchb
X-HE-Tag: 1778881222-793147
X-HE-Meta: U2FsdGVkX1/Y7VOGYxKzMPMDXrMjtnp/e5qFfsiBdcVGVzUZmoUUhaCjxuoTjVXmLYsZitzhaKjhgZPTVQt7DYddCj3hTVvEHoIV7q4nuV/R93es2Pdd+abAuNZjKhXfhvPIzERAAnGghCLEdRktXfwzV55pOb8HakWLK9SnrtNOnYV9MVH5BXt92oeRREPSdAUBFFkYGFLZE+rfiV11gBU9ZpB7f2g0NtON2ljSTFVQDTBukDwSurORyPm6Q8BSuA+y5j1+Gz4AaZmHVEAsHSN6EabE3bWtEPAeXYBnAX4WRYlXqBTnI1NvJQDbz3EW8LhHVgqrCj1ED4+7pHBwCfiUscGcH709o5pjdgLtO6p9djlpU7/5w2lz5E/MQD4nuL8TPRSWsjN+ov62Gl+U99xMJc3acyRxf53tRCF4OmDBaBfbgp5B8R7wgDCkdTuzl7m3NJschzOBdPhkKg8nMvblVdmLXAhA+TtQyWFn1iJm3UQwzLgVBRdrWNucw8PwA0C/Os2E0Rr9As6I//Y09IxC4PrUZzLny5Xuj4rS1Fx1jC4xJWfsqTYfPpVFJ04xZc+mKqDeVjnNwVjOM3I+AHFny5+7c09kr3ckrChfeR9NdTb63I0+pmXmXIL4d4s40kXap1wBTEEmuf4t4q4d05AG5qV4VGgVTK/7dPEVehm/LaRl5a4WAsrblG4Y9fMcdJVlLS/ipKrqLjfuhB0OcghexytV5h6BbdeEFMlPsUnPSiwJmo1RoOyH0T60ffAfydUqkMXwE3TKczmekpsE/RbbUb4/LfziBUIJsmbLeaMsnkCWLDi6nD5RDDfmiC8kTZFlOWr8aQBtn7EW04E/MfTKJ0MgVRBXskIlZhY9J9Y2I5s0nGULY6Z8/me1Y7Pah5zSx+EC6dwoGGi4P6EElmkhn4f2DLYhM3HPPIH+L0dUqcFK3beYjHA51eTnW3Jl825syNhqA/8zVDiASl7
 /7JQeBvZ
 ZJjTBZXGcl+jqEkd2ugWC5hsSmNPjlQC19Oj5Ux63qr2MBYSzuLxYWB9bU7oJin1DBVIPNLJkU7TyEp2peZLIp18tBl29lZZlCgrtmHSPjIQoGg6qITdz+u1wYwJwpYw68+ZUg3q/JUNwLGJf2KWGyS89VG6xAgqJL9JWFGzT3C6BgV4hOBZ6J121XxIwawcZObdu1CJMHcy5SwI+5WnelHJAqZ0tx/YX2m5w6n4vVzoeUxK7oAh8OMb21PgBQZJerLMhmg1YAX/WJviMXjf2uU66Pz22jcjHzZScMOnPCUqUQXquUeXalL3+AE4YpKcOb0mWMJKI9xlbQM2oP8gdgZXfFRGJQd+0GXeKQnFLfVwEVOREX6sbiS5z6VN8nWeiVPcZtPSfZGLr84yQzpXgDW9C2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 10:36=E2=80=AFPM Christoph Hellwig <hch@lst.de> wro=
te:
>
> Hi all,
>
> Darrick recently posted iomap support for fuse-iomap, which was trivial
> but a bit ugly, which triggered me into looking how this could be done
> in a cleaner way.  The result of that is this fairly big series that
> reworks how the MM code calls into the file system to activate swap
> files to make it much cleaner and easier to use.

My first impression it looks very promising. I will need more time to
take a closer look.

BTW, I just tried it, this series conflicts with Kairui's swap table
phase IV series. Might need to coordinate the merge order with Kairui.

Chris

