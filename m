Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 400E8606C851
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 14:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bqxUBmmI
Received: by kanga.kvack.org (Postfix)
	id EE37C6B05B8; Tue,  3 Nov 2026 09:48:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E946F6B05B9; Tue,  3 Nov 2026 09:48:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0F036B05BA; Tue,  3 Nov 2026 09:48:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A727A6B05B8
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:48:27 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1BD8D16046A
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:48:27 +0000 (UTC)
X-FDA: 85394088654.25.DB58E4F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 852B340003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:48:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bqxUBmmI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793717305;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c0x/bwvUTy91TeSNlshE2x6EC5UWF1SAOxo9ylrayLg=;
	b=pfP8+GrDGnt5GKclhtlRcWrGx/lKcKpy31+HZYa3FXakBqkieu162mT97dtNkEXVBs069y
	JMUKAo7lNgOp37yBawFlKb2mSYV9cHxVuK3xttZqSWf/m0WCiGIw4FhclnJZipu5K9Jfoo
	mKFsb/dmfGQJ+VX70eBwTyk65YnrsY4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793717305;
	b=0Pxs4PMwJYkMvfjwHwrAonQC6/tqhu97wM3Ew+t58mZMvvFM98xrovXNaiOxO0RA1o//Ku
	ZS8jb4ciqieXCMDCVFE8bl0EJEiuaxj/vPiDuQ+0xpPJ91WumDBSqIg6O6BdFikUPewcTl
	AU/xYZxu0J9br8Hkhu9peVB45k2Hlds=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bqxUBmmI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 23DA8609F6;
	Tue,  3 Nov 2026 14:48:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B29171F000C1;
	Tue,  3 Nov 2026 14:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717304;
	bh=c0x/bwvUTy91TeSNlshE2x6EC5UWF1SAOxo9ylrayLg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bqxUBmmIruc8WVpdDnTaZKZMybp6tbdqSNtX5Vxb8SbRLH8Zr2JWwBPY98aQ3hFcO
	 mF4KERe0Pl6zVdX7ZTe2YfvSwUDpjVOk0tXjo8nokMnupOaJWZpwf9x3s1jjDqLc7o
	 D8x2o27+nwq7964W+Sy/E0e8KLqKLtVO62ftCwu5g7mpOe3sE4UYTyU1eKEd9wvkG6
	 9ziGsoyYsjc+8FEQzGARNtSKo/GIQynC+oiEc7kqzm/+yyy218WWaRIIGwPjaGFK1d
	 0aiHWvAjGKyvLg2SLb3ZdKLVkElsDVk3YwkpAFqEpwcF1NBvaDa6WRGXNTZsB/rjMv
	 m/ZkDBbjhFEUA==
Message-ID: <sashiko-outbox-195500@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 28/38] scsi: esas2r: bound the lengths of the HBA,
 SMP and firmware ioctls
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
In-Reply-To: <20261102-work-procfs-bugfixes-v1-28-59422ed3e465@kernel.org>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-28-59422ed3e465@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 14:48:22 +0000
X-Stat-Signature: u48eq36978nc4zs18th1m13zefdycs7f
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 852B340003
X-HE-Tag: 1793717305-388675
X-HE-Meta: U2FsdGVkX18IPnCATyYICQNe4RXxkOwRshXhWK3N9LZXkq22H+lWffyhG2iLGnpILGRkd5RxClqY13wbZMy2DJiRKbhbpdQV0n/DyRCxzQ4l/WRKqqo2ePJIcER4iiqaKK4XrcZj4Fu1KBbWS6EehN1hCsq2JBzh2p3mSm6Ig6NPSSX1PVLgnHRFFMgQgG6GwW7piUSH3j1EkdxT7g5bInVf6aI9EVt9EWDq17tMW2M+QNBgLl7ZBGFCgFFG/XwRvKyWaRvyeSKN0yGCFsJPgwgNe6haRYtB74GgdrVwMkIa+stExVbR8KA2mcTYpgDFBBYuwvYCCzz6FihC9o5SWWJLMkP1R82IE8PtUJdL0wh8Dbbhfc3/ICGcAcGyTccnCA1nJjB2BJB1k3mjUOFCchVLOkCU9GlFYTKgGWbddZNMleLnnCe2pWt0s8zpKum4laHP64TY4tr7IEcZhCqLdsyDIKGsZRfH0LdfbaSZ3yTCWSbKqo7UeN3/mmVtlgGRKpgxiVsYQsINRsw1eWReXbmp/aO+A892eHtFCQXkklDGcGQHrx2NNGCXYsl2v79J5G2Ru4yLgLX9hZuMUcKO9HH5uLNA9mq0Tkp6KgHwGDfa0MP2aXUO17dOrRqKAwy2ox+9eh1NuNUQhvvdN1F5z2upCHzKA346G84eZZkkg8lp+yeccTGMYkFfj0YI2T/qIpLq8mY5hT0az2MFYQE1fEepFMCVE9uoUO0YBXajycAuX25O+/vS+YTVm8beOQ0ad4IwGDcaUlWr9xF6tsU7cZHcSBGoKdpRhGf4u3lvcs806wHgqwwU/zmN4wCCm/FYMY9AGt+obD6RmuVucVtE7uiS49WSj6WmnUQinEdSMFNrjwPrvZ0HSvW8aBqPff9cBdf8QA8l+fCFJe69H/rg4aMsuVtHDNg8ftX0NLSlz1ep5b79Vls95RMY90rky4RM3nDoVQ6y81s2wLuqKjF
 KKUiE69S
 FuoAA+zMZD6s/GZIC24rUlJh6TLpS1FJH8ba3VABkDBc8GDtkHhwj/kgpfPyRo1ZTKcPZzcxqlbXSSAKukAsbeNwU+h4RoJ/VwF4hhxNu9es3QD29KbYxT05OVdTdD5VZnfryhaz6eCr2+WXN/uG00k+eZs2XXbjC2pzN5soIbPwDL4MdkERpeaNg008wxIKMUeH+wq7liQz4AAkLMZpWnjPXvsL45xaKjtfJYUDHNimyvHkPaxKThqVOdljLygB3LOeEbvE/Ogq3TfYK5y35kkH739FOfYNttPjygXEr4xhTwqtFMjc6XNrhoUasDpDGuNYqYi+9B+ZmvS5APymrOZk+l4qQk1e0GfqWWRmUVhaodaWpuzArC0ezLsYIbTUUPShP9AX6SqditLyqs/1btcfnNGCpGBHY8nHUAd6Qz0dAtZoImGYFE9nEGZQJCu3WURM38FyaINyX+9Oh2WEKgNkChxKZPI6uw5hDbpgCFGFkxzVZGFG06wRKN+pAScyVaAFfe1jCl6PFY2QhaUFDq3FaqKkd7LnfJrNYg4JRAoNQS3pQY2AeHvUX5bV2OXiOXD/f10nP75jbsH8QHwxR+wipAHCQLn6k7O2DUwHn20sCAtho43sjToQp1Lfu9bB8w9+kzaP1XTl91oIq1oAMidyUcI2X1GsX20/9
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
- [High] scsi: esas2r: TOCTOU race on data_length in handle_hba_ioctl() via=
 read_hw()
--

commit 8af21917bc01e9991b2ab872e7a4c38c91a6e388
Author: Christian Brauner <brauner@kernel.org>

scsi: esas2r: bound the lengths of the HBA, SMP and firmware ioctls

This commit adds bounds checks on user-supplied lengths for the HBA, SMP,
and firmware ioctls in esas2r to prevent out-of-bounds reads and writes past
the end of struct atto_express_ioctl and a->local_atto_ioctl.

> diff --git a/drivers/scsi/esas2r/esas2r_ioctl.c b/drivers/scsi/esas2r/esa=
s2r_ioctl.c
> index 3f7c1d131ec34..f99318f61c934 100644
> --- a/drivers/scsi/esas2r/esas2r_ioctl.c
> +++ b/drivers/scsi/esas2r/esas2r_ioctl.c

[ ... ]

> @@ -1221,11 +1231,16 @@ static void hba_ioctl_done_callback(struct esas2r=
_adapter *a,
>  	}
>  }
> =20
> +/* @room is the size of the buffer that starts with @ioctl_hba. */
>  u8 handle_hba_ioctl(struct esas2r_adapter *a,
> -		    struct atto_ioctl *ioctl_hba)
> +		    struct atto_ioctl *ioctl_hba, size_t room)
>  {
>  	struct esas2r_buffered_ioctl bi;
> =20
> +	/* The data follows @ioctl_hba in the same buffer. */
> +	if (ioctl_hba->data_length > room - sizeof(struct atto_ioctl))
> +		return IOCTL_INVALID_PARAM;
> +
>  	memset(&bi, 0, sizeof(bi));
> =20
>  	bi.a =3D a;

[Severity: High]
Can a concurrent write_hw() bypass this bounds check when handle_hba_ioctl()
is called from read_hw()?

In drivers/scsi/esas2r/esas2r_main.c, read_hw() and write_hw() both operate
on the shared a->local_atto_ioctl buffer without holding a driver lock (and
kernfs only serializes per open file description via of->mutex, not across
separate file descriptors):

drivers/scsi/esas2r/esas2r_main.c:read_hw() {
	...
	if (handle_hba_ioctl(a, a->local_atto_ioctl,
			     sizeof(struct atto_ioctl)) !=3D IOCTL_SUCCESS)
		return -ENOMEM;
	...
}

drivers/scsi/esas2r/esas2r_main.c:write_hw() {
	...
	memset(a->local_atto_ioctl, 0, sizeof(struct atto_ioctl));
	memcpy(a->local_atto_ioctl, buf, length);
	...
}

Inside handle_hba_ioctl(), ioctl_hba->data_length is read twice without
synchronization:

drivers/scsi/esas2r/esas2r_ioctl.c:handle_hba_ioctl() {
	if (ioctl_hba->data_length > room - sizeof(struct atto_ioctl))
		return IOCTL_INVALID_PARAM;

	memset(&bi, 0, sizeof(bi));

	bi.a =3D a;
	bi.ioctl =3D ioctl_hba;
	bi.length =3D sizeof(struct atto_ioctl) + ioctl_hba->data_length;
	...
	return handle_buffered_ioctl(&bi);
}

If write_hw() overwrites a->local_atto_ioctl->data_length with a non-zero
value between the bounds check and the assignment to bi.length, wouldn't
handle_buffered_ioctl() still read and write bi.length bytes past the end of
a->local_atto_ioctl?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-bugfixes-v1-0-59422ed3e465@kernel.org?part=3D28

