Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83EC8606A88A
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 10:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=dhXCFfwQ
Received: by kanga.kvack.org (Postfix)
	id 73B6B6B0662; Fri, 13 Nov 2026 05:02:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EB836B0664; Fri, 13 Nov 2026 05:02:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DA606B0665; Fri, 13 Nov 2026 05:02:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2B7776B0662
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:02:43 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A084AA8291
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:02:42 +0000 (UTC)
X-FDA: 85429656564.06.6E96FA6
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf14.hostedemail.com (Postfix) with ESMTP id AE598100009
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:02:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=dhXCFfwQ;
	spf=pass (imf14.hostedemail.com: domain of alex@amutable.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794564160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8oHy35ptJ0fLQb2YrI1vdssfNtJpVRQvJ6BVJKFTHRg=;
	b=vxudGbGpIxiHm+EIjavYIJ6jIck3UH3IijbqynUtDcGxL19WKNVTMZ0oN6SFOsHBaE16QR
	Y1zPZMR0mUT6SLZNKBGWqFl4HsSkxau/C+VdcY5QF925YQbz1cYImGptMmkmc+mEymtuJf
	j4NbOz4EFhrucHT8DDzOLNTxtzgmatg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794564160;
	b=TtIJUkE1mvRw1ahGvZCyhxrLim9FHJAV7edxvuIYIljkT3EDjCcWRNe2jwF52C7BzVBo8G
	9dCGw4yQO7XP0PmfPwc2uLkpfIm1oZB83cse2eOlpYFhULfky3ZLVtsGZ7mGKK5ORAUq43
	ekwaabT6xONgUzdzDMmZePpfnDMg8ZM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=dhXCFfwQ;
	spf=pass (imf14.hostedemail.com: domain of alex@amutable.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c4d58c50743so126076866b.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:02:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564159; x=1795168959; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=8oHy35ptJ0fLQb2YrI1vdssfNtJpVRQvJ6BVJKFTHRg=;
        b=dhXCFfwQuKb7gG6fWAveu1JneViJH34k0tTCDvm2ALr81AK1DDNegKUvC5tQzlD6Fy
         LS7/XA9GIUKp/aMNQQI5m56EIgPqPtHn8Wkhl4YaMLj7Xor4b3AFXw2LbcCrybFRm8uI
         02hF6RJ4lEil/3C3MrDONP5HBr6SxaVdlgUn3ciF7wipTcw5g3FgO/pRriJZ8UHLy6RE
         0TD1yRlEdCH4oXB4CzL52KnOd8p/6NFkLIBP7yyXWGk6On6l+G1WFPdWrfAz03W0Cspe
         MSDnyhH0974duT0qQVKDkBxu5g+m7cbEv+LGUrGoCnLzviJKPo4EilWvx2ea5sC9fskR
         Vsfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564159; x=1795168959;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8oHy35ptJ0fLQb2YrI1vdssfNtJpVRQvJ6BVJKFTHRg=;
        b=mPA9ixs2pHHXibUYOT3A7H3kT+CG6MEiZ1a7O9gyfqU3RmuHAy+6xlXEgGPXWxLE9y
         wz7yiM0x1WLSmK6Ixi5YEszSuyx5IFY6Uu4u3EdzB8zRsN7blj1Y0leDhTzdbpRfgQx1
         AXFZLqgCCaJFrn1NMAqdaZJpPNSd2m2kE0OCqTKvV4Dq1ySSsg/7Uu7jIG1V1DnyGe0Q
         +pmQ6OMDNkNpDWxCshZOkkQvgRM1FGnwvQJ23n5KLuDLQ5qj6+D5/mjELM0htqzBlwo7
         HQjjeC4UqJwxkGK1ccnJko9lBjGIFyif4c4n5gvoZkR0NgaDwXB3pnQVXsiGPdoM04U7
         MNTQ==
X-Forwarded-Encrypted: i=1; AL+hErEPRlBPEliVYTG3Cw6dRtMN0iOkf8Xyo7/d4QhHKlpdRBPrCbGaN4CMG5kAs26hn+3hYaF/GmS2eQ==@kvack.org
X-Gm-Message-State: APuU4Z8VWvMldKY8X7ZBTDIdeta4ieuG0RA9pPHLOpcHiVcjjeZRHx3e
	c+DSbNxP428IZ3o+639e0qYSQ/VvoHYzxdMK/gl2B20CpGOZoHyAssPiTMFnfksCZvuT
X-Gm-Gg: AYBFou1stSsuRGMT1GAnk/av5aNj+E2Gyg57/PraNV87xz/TLkxxX/7cOlqwY6ha3+s
	dGfbeLNarAVRamj8cxgo1juq9R732CU9Hi83X6umusuwUTO7icVzsaGTk3KRDGQFfX7i98mg+Cq
	O3DE7u12ClQbTbuP7w+fn8MCEA+8p48aCfmBDTmDaxhDHV9Zvu821UzNHbgomX3CzCM+RB3R1ku
	6PfVLfWphtX6zGhRGyH8vX/Y2x+3bg6DQOUx1LqcyugOTyXV+JGRth3ByMs8HB7bsMA4uZtp6pw
	Xzmk33aejp6CMj7y4Ci7DOSkQzlWOASV7ot+/gLuLpjSiUxAf4C329cKwIU6DE4m/rO6DHGziQr
	mwQkUqSZcj1f2fDEMZJffBXSSpQoX2lhRv/xVIq869KuYKQLd/KJLnDYk10+MCDIbR82aU/hC+w
	iyZinujDl1ELOXFwYwJqaHerDc3X2oaYXDImKwSfQZNqtDEBuM/4j0FfxdWaF9RQN8b0c9EZ4uM
	mZ5KOxxoHzKwJ1teOHeK7WxdhK88IpO/YdyR2VD3rFCacrQHVpolerKfdzAQv279ezw11HzIUCR
	WdsiR7ZBI4QUNlyqhHerJgPQuVlPzzpxLko9CWw8yFLxx3t2I0ZfVblRnGTdUCg=
X-Received: by 2002:a17:907:7b93:b0:c29:f5d5:5a9c with SMTP id a640c23a62f3a-c509654de57mr163595166b.38.1794564159104;
        Fri, 13 Nov 2026 02:02:39 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b23afdsm74417566b.13.2026.11.13.02.02.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:02:38 -0800 (PST)
Message-ID: <8c51aa1ad231dea30af06ecf761a971f5958d063.camel@amutable.com>
Subject: Re: [PATCH RFC 05/41] kernfs: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:02:36 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-5-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-5-4c998976c6c7@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: zxwx7ibja6o49toe6qpighj6ggo66tjo
X-Rspamd-Queue-Id: AE598100009
X-Rspam-User: 
X-HE-Tag: 1794564160-520419
X-HE-Meta: U2FsdGVkX19IxSzMJBP8+hMi6tqiBgBlMsh9wMc/+kRyx2NNpDdTRYlXPfVIMyrVk7eXB8KXlmlycJR843j/aqWf9BK+qBgfsDRk8+Qtb/4i6+hu56myvigktc8wGXEu6ali7/w2f03NhQBrkLfoc2v+LcblstWbLRDaNAngtFntu5XL0BR2TD9arbpQjT1ryyD7Nmd+tJWjGEIuSDR+c+sW4O9s5wqrBBEzSyDbfuEOf9hOBP12F+0XDK37rvAFKax0JtElVGbLH3cgwEvZIqUCQtgmelkC5qW51q+UHuURvkkLhUn2WkEh7qpM6n0c/cze3tXujOQMDQWJ6Owi5yE8bo4VSKVswWIM8dbvs9KK4iK2fU1+RvH2eXXmwiC/0Y97tLoBA8tyCkZvCP7il0gqpIMeOmkCPt2S0iw/w6apN1VXidB6cvA7wgvWZNq3F3olb+VqSc61QeVEpnuR2hdDKlBdDLs75ebLM7iK+8t7JXwta9fubAMpPZ6U1AKiP1Grp0R0ZQp07c05f6fGPCrfFg13ofq48Ds3eESO5yVGCQ9+Tew05hNypGBj4rJ/VImyn7SxH0FoBlPdTuqwK+fKYVpAIR9+TdKjnQflk8HAUAR/jhP9wC4DVrPS+/9XE4VC9saa7QbLHnpFw8SQzbDmrE9amO+u8hqjS4QHm5kAIrb0WYhdRoDslFU9GJFxMH0ASfzf53RMp7dZhsUcYHUDmK2CeOaTbpBUYslxEsgeatEcpxbQK9+DrtV2bui00r4412SIz8MRtqLFsi89AEmiWghbn2K3Zd4XdZSPPAm1iGifbHXv4ZIynCHGwa5GKY9IohXkmj2Ql2EaeA/QbyCMcBGlkwufRXydgezPjOLcqtD3ENVtyDM01avf8UjRcXCv8enAVVyrEx+I6WBIQVck8zJ3/dFH32QZp0tp59erJ8kCdxixzHl21qZatrDTp48KocSiqnfUrQEVEIU
 kQ1Bj5H3
 BcnlmYXgfDGAgDc9Up5oirZazFHsR9+roPgN9LS2d9UmkXqtSkDuE97aXQ7a0SoIG9Rbe1Lu20CRSpRzWia81AkmnJjCjv1w3gBz5PFewD+MqMmb5/2sAjX9bHfJozG05lF8CytqTYVHtzCH+Lcrm6bD64uoXWNynH1TbbVZBNQeBOXIxC/4vUtISFxpHezx+ON7q/j4ZFlrBJRyfS6nZDGkcE67IW0GZZjuNUoJyTOFuf3ebn3bkalPpeslkUn0WMj/EOf7keq2DkVw58QGRCmfOnnnf68WA9hPzWIn0EwuAqvsKb8lHGJaLxG41JNJMDswo/Tf0QXc3xBKARAoxytwEJ8yL9wnqE8LjFBcgE270pw4XbUE1dGXRIGkPCrZbLOIi/GvA6Fm1523Li1L1feM3ctjFFA0wBzwH97iucuTZc57SajCVuOCL5T3VQbIByc/id8U/Vb8WcyxUTcOYXDIr1exPizGkfi863f6WbbhRRO4EqQeK2d36FQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 2026-11-10 at 10:14 +0100, Christian Brauner wrote:
> Initialize all kernfs based filesystems as pseudo filesystems in
> kernfs_get_tree() instead of raising SB_I_NOEXEC and SB_I_NODEV by
> hand
> in kernfs_fill_super(). This adds SB_I_PSEUDO for sysfs, cgroupfs and
> resctrl.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/kernfs/mount.c | 4 ++--
> =C2=A01 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
> index a0be784bfb06..6b60d212b003 100644
> --- a/fs/kernfs/mount.c
> +++ b/fs/kernfs/mount.c
> @@ -8,6 +8,7 @@
> =C2=A0 */
> =C2=A0
> =C2=A0#include <linux/fs.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/mount.h>
> =C2=A0#include <linux/init.h>
> =C2=A0#include <linux/magic.h>
> @@ -298,8 +299,6 @@ static int kernfs_fill_super(struct super_block
> *sb, struct kernfs_fs_context *k
> =C2=A0	struct dentry *root;
> =C2=A0
> =C2=A0	info->sb =3D sb;
> -	/* Userspace would break if executables or devices appear on
> sysfs */
> -	sb->s_iflags |=3D SB_I_NOEXEC | SB_I_NODEV;
> =C2=A0	sb->s_blocksize =3D PAGE_SIZE;
> =C2=A0	sb->s_blocksize_bits =3D PAGE_SHIFT;
> =C2=A0	sb->s_magic =3D kfc->magic;
> @@ -388,6 +387,7 @@ int kernfs_get_tree(struct fs_context *fc)
> =C2=A0	info->ns =3D kfc->ns_tag;
> =C2=A0	INIT_LIST_HEAD(&info->node);
> =C2=A0
> +	fc_init_pseudo(fc);
> =C2=A0	fc->s_fs_info =3D info;
> =C2=A0	sb =3D sget_fc(fc, kernfs_test_super, kernfs_set_super);
> =C2=A0	if (IS_ERR(sb))

