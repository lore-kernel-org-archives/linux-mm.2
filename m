Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40A76CCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 08:15:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AF108E0021; Mon, 13 Oct 2025 04:15:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 986948E0002; Mon, 13 Oct 2025 04:15:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89D3B8E0021; Mon, 13 Oct 2025 04:15:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 76D6D8E0002
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 04:15:16 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1E4951DF81E
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:15:16 +0000 (UTC)
X-FDA: 83992381032.19.1F455B3
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf03.hostedemail.com (Postfix) with ESMTP id 108CC2000D
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:15:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=H2DKGv8o;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf03.hostedemail.com: domain of daniel.vacek@suse.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=daniel.vacek@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760343314; a=rsa-sha256;
	cv=none;
	b=By7PfL/zRvXbX+x9ZqsVf2ooMBfryZrRQgKotkV5gTqDt+FZzTf0TBRlPu9lIwl/uQ+/d+
	7nq3f6uyOPNBn79UaDa9XzGx43lZ2jAKTRI3EvjVRaHIkhOJVfGj9wxx9Ny7+bYNP4Wdze
	eOo6F8G2C9zErBmAu8G/LraaC0Q9TFI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=H2DKGv8o;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf03.hostedemail.com: domain of daniel.vacek@suse.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=daniel.vacek@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760343314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R740my9A/r0yGv8JF/opdryBZzIxczQeXr2k5izULh4=;
	b=Cb1TjIdw5grmpxk1aNFmCQnQ9QkUXlsZi8z0FwCxAn69Qnc/koDnhtqqTfgv+ZT5C0bwZH
	6FIvEPerd1eTJPC1cyi2ywcSrR2o71EXHrXCEcXTUDCMH5cPmQIZgCCsq4hFpiGeYs5zqY
	NTWkHaxQCxELmLTcKbd+jKgEsc+y8Vs=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3ece1102998so2216114f8f.2
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 01:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1760343312; x=1760948112; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=R740my9A/r0yGv8JF/opdryBZzIxczQeXr2k5izULh4=;
        b=H2DKGv8oMVEyOpnbbUeupXEtR8cl8h07rKreRdqpUR1FX7PAP++KF13iXn7kvtKI+k
         LcuV6wXtiBZD/UrzEHFsmK0Jl/wV2oV/2dpV8TnB2r0xsWyQ8r1KtXzFemIcx2rFDSwG
         RqV9ocwLuINZT4YASLph7B/3wpbi2uGndGXGSnsJEgqVX1vAxkR+/sRGvyqw47TnBc0m
         XXFGteuE3frFfv3CRa0ohUcgF3oFbWkU9kvmbEu/2ZtW9l089Y1eTZI0MG7LpRXQLkb3
         5uSjTDIfQItdNDbf79VetXouFOHROES1mNsq0Lh3lnagjtlcFPTdo5xbIPH5urH//uby
         4aTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760343312; x=1760948112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R740my9A/r0yGv8JF/opdryBZzIxczQeXr2k5izULh4=;
        b=lLGfyBzMd4PdVTtESkTgh/S186OHU3EaaZ0BUsrn+yTeVVVF0H2VujWDxmyq8oW9q8
         dubfGs24++H1BvLr0hRMdyIv7eZS/U7MyaeHufoH8y9eNv/tcM9L7Do2ByqhLogikt0Q
         JsknriX22O6AS66y+Vz+e4itlHdb0IFOW8uJ9Zoz32/Z7sHOgX+UN3tG1LjCFqK+RKYa
         3/Gh2q2ItQlYsIfJ6M41XNGAyN2eYS4SMdMXHTPsGMLU4Ga+aDfZ6YcrRO+NGuNjAWOo
         5dgNKmxHYCUijlKfNwaUbTCkGS70p1+jUW3TctLYUr/PX8yi9WQW605FRkrra1dFwKzw
         HdPw==
X-Forwarded-Encrypted: i=1; AJvYcCWrRFx/eKSoHEAXjKNiNvc78tWWs9VBcUcs6/Jju7CEE01610O8C0xkLOnoqdHn3JKvs4IzPybSqQ==@kvack.org
X-Gm-Message-State: AOJu0YxkVlsE5Oks43RzerPmb/s9v551p7HLkoHqI/t+gll6Y6ieh0kp
	I2ZjF5SjjwsChJ8cZookkVdTIcMVQOypiYBl/jPC45oTilZAk82gwEqfA6hgGJlM6+bXCuc4y7l
	NnmO/H+YLsAC4uCNBlp7Dpmi7i8OJwZ30GPwD5C7mdA==
X-Gm-Gg: ASbGncsv7EIn1Er2kFJ8S2IIuqfWjiIEu9/vNMnULIg5Am9OQoiBMFCvR2cqbjeigb8
	Cohor2a6qOOQHbRJBABtrm6EvaXrG5dXR4D01IpPvZTVk6YJTSPrd2ZZLDbyt2uz3rDWJ1TmDau
	WLKglNcnDZNSfgLMTMjBfM5blBv7s6urlwPu7s6xNo+q/rEjswATt+mW0H3ZGZDIpgB5azr7sN0
	Czvw/b6Jp5wx/iIkbNLBgCD1ZYrcei3Lnc=
X-Google-Smtp-Source: AGHT+IEXSnK8vgh5qb4+sZ5l2hFRJWnorbBdcfDu2E4RvgYsaMIAeq5q8p6/Cp6GKDAeCkB0EX+DEBuZJrHy3pYKRvM=
X-Received: by 2002:a05:6000:430b:b0:3ed:e1d8:bd72 with SMTP id
 ffacd0b85a97d-42666da6dc9mr13043087f8f.17.1760343312390; Mon, 13 Oct 2025
 01:15:12 -0700 (PDT)
MIME-Version: 1.0
References: <20251013025808.4111128-1-hch@lst.de> <20251013025808.4111128-6-hch@lst.de>
 <65aad714-3f1d-4f4b-bb8f-6f751ff756b7@kernel.org>
In-Reply-To: <65aad714-3f1d-4f4b-bb8f-6f751ff756b7@kernel.org>
From: Daniel Vacek <neelx@suse.com>
Date: Mon, 13 Oct 2025 10:15:01 +0200
X-Gm-Features: AS18NWCgT3XSP_MN-BMfr65K92-imDhnpGub1dZ7jpbkZ5N0Fj6p03e4QIM-oxw
Message-ID: <CAPjX3FdRvkie6XMvAjSXb4=8bcjeg1qNjYVT5KOBUDrc+H=nDQ@mail.gmail.com>
Subject: Re: [PATCH 05/10] btrfs: push struct writeback_control into start_delalloc_inodes
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov <lucho@ionkov.net>, 
	Dominique Martinet <asmadeus@codewreck.org>, Christian Schoenebeck <linux_oss@crudebyte.com>, 
	Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Josef Bacik <josef@toxicpanda.com>, Jan Kara <jack@suse.cz>, linux-block@vger.kernel.org, 
	v9fs@lists.linux.dev, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	ocfs2-devel@lists.linux.dev, linux-xfs@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 108CC2000D
X-Stat-Signature: 53oi5qfcx6agrnb5i7wbnd7otuy4u8yu
X-HE-Tag: 1760343313-739453
X-HE-Meta: U2FsdGVkX19vOWgOEW6jQ/mTX+F2br5Od3se9ouQzePpkDFX6II5s1hmRaDX8ly2M2BFyKyYdpqRTDoAFQ5YdF0wGiL8CdhIImbr/MvGu7hyMSyYUeRIfTpz5o52N1yiAv2pK6U7TtwmyIqQB+ytMbxQNLGquadxlksb1kOJzuLE7D0DZnAkSSh2JLgDI6TBV678G936X+MwBGq20hjL+neycJYKJg7tBA8GecgwKNwHJKHwOVz/ViTvcfQToTZjiyzngxsJg1MLlcudpqj84M8hJfU1wjtX6LezzJL8Tk/qsgiB18J7LhoOzihrYvKSwgUECCPaaL9H4kDZm9dJcdrSQYe/Fu08nFqyFm+Z9iXWx833GOAIg8n6cvn1s2s3iB2Z3jLcMMJ7RU1nTpF64qhCBh1MYIoHRpw7XnglUIILdZ1+mxkSuUeMF/x2KCcTYS2fBbnnM3YbJdqwjbSFs+r3/kF2DSSKf6lKq++KAb/5sBL3ptySYzOs5+5p4C4H+QDeeuBj0qRnYjEYLAmQePVsc5Swob19nGjhs/D84JkXPbxEHacs/JUMN9j5J1Nju39zS9m9wZ/eo0Q6OlVW00ueSYe1WaD8F+9h/xzu2PZvEQ14KwOjSst8CIUlvcAF9g99UDFUs62DCNTc1FunOas09XqwnONM1JwC/LkLshM1Pa0j/YAOa5+oOn2LXDAJFgB0+E2+GzhKmlrdWkruvK3KiRumQDQXQnaR1eiZX9wwtbgG/2dsz0f05grqNDSVck1yZ3hTNIcRrPdAMM/OPRE74tta+3da29cOhBbLQqmfW34cqA2hhmlGEjGOPmCKBx/CY6zTi8Dsaczjq72HaM5IGNslfDOekYkgmZt+W6UfltRElQHAar/V4hk2uYlT9buqZ0z3JM0U80rFcTerppxSWU03mUl/QY2vQpXcySMOvagxAZyayIk7fTArEh9bOYKrzS5lHBnhRsR84aC
 eIkRYczX
 9bHFFTmCIV45IirJX7phe9sgaVfvn2oY6Kmos17WRH00fkapzN/X1zDrXx+BBKpmBi6ZSmUYl7vzFb+E8jEra9nbOFdXt1+AoHOt9lnJBXhCMJhSOmTO65K+CoBNXaqPjQU+ZUbyF2v8rOuyDOiFT7v4TTrb7WV3rpBeCenm9CKpr5KbCjjZhpxWkDQ9DeWFZLjb9sVs4/CMjBwUfOzg98OxcxJI3JfMI+gTFdyGtFLO5+Hq6JmOaEbJIXiEI8BSrdzsQ5rl/suQdq2/2Brt6iez8ufhDK9eHlILnUn71jbiFiGhF/mIi2AjYq0ae9iJ2EqKOS3Cznx+AC02eShDus5mF2BotY8BR0VP5B8xCAhDXCphjIQRh4ty3a5EKFLqBGPuhJ/3hEXq7+zY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 13 Oct 2025 at 09:56, Damien Le Moal <dlemoal@kernel.org> wrote:
>
> On 2025/10/13 11:58, Christoph Hellwig wrote:
> > In preparation for changing the filemap_fdatawrite_wbc API to not expose
> > the writeback_control to the callers, push the wbc declaration next to
> > the filemap_fdatawrite_wbc call and just pass thr nr_to_write value to
>
> s/thr/the
>
> > start_delalloc_inodes.
> >
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
>
> ...
>
> > @@ -8831,9 +8821,10 @@ int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, long nr,
> >                              &fs_info->delalloc_roots);
> >               spin_unlock(&fs_info->delalloc_root_lock);
> >
> > -             ret = start_delalloc_inodes(root, &wbc, false, in_reclaim_context);
> > +             ret = start_delalloc_inodes(root, nr_to_write, false,
> > +                             in_reclaim_context);
> >               btrfs_put_root(root);
> > -             if (ret < 0 || wbc.nr_to_write <= 0)
> > +             if (ret < 0 || nr <= 0)
>
> Before this change, wbc.nr_to_write will indicate what's remaining, not what you
> asked for. So I think you need a change like you did in start_delalloc_inodes(),
> no ?

I understand nr is updated to what's remaining using the nr_to_write
pointer in start_delalloc_inodes(). Right?

--nX

> >                       goto out;
> >               spin_lock(&fs_info->delalloc_root_lock);
> >       }
>
>
> --
> Damien Le Moal
> Western Digital Research
>

