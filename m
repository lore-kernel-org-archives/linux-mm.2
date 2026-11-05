Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1252606A6F9
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 19:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ej+uoOdy
Received: by kanga.kvack.org (Postfix)
	id 1BF496B05BC; Thu,  5 Nov 2026 14:30:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 177976B05BD; Thu,  5 Nov 2026 14:30:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 062196B05BE; Thu,  5 Nov 2026 14:30:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CFEF66B05BC
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:30:17 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6D888A0C16
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:30:17 +0000 (UTC)
X-FDA: 85402056474.02.C937DD9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id B0D10180008
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:30:15 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ej+uoOdy;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793907015;
	b=5lEvlhOFpnPlDtYuIiX0G0Tk9UkuRWXHltM0qWJLKUKw0VhYWlyRaMeLyMtBodbWyIa2VO
	U5xAuAbJDRELidw4lFiVn3PS4dnKIXYA9RshStJduMmVpgZsF5KxKoAqILBba8Y+o5pjJv
	7SwiG3JHlvOsXTKiHS5gu9EihtD5fgI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ej+uoOdy;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793907015;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7NQAKY8HY4DbdjDd6x8DZF/XgVJse33xFSaScTuQDsM=;
	b=GPBc2uBdGVHGzyDttRZXgwPRCIboOoTHcFDthqKeQU3s2CTqQAFK1zwWUxpqju4NE3CfWR
	zY0zSaX1y0uz7spVoj1Xx0tdFWEuyWJMnYsXmcZZ8Nnsg9CVbOCOUUQKf7dzRlHbO7jRFj
	1mcRKwD5kesaIWa3nuqkPuolTDuEK08=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BD698414C3;
	Thu,  5 Nov 2026 19:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F3A1F0093A;
	Thu,  5 Nov 2026 19:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907014;
	bh=7NQAKY8HY4DbdjDd6x8DZF/XgVJse33xFSaScTuQDsM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ej+uoOdyy0zraix1fQ7r25PJRrh/4Y9jENiNfRHcNQYKQbamB19zOZWAIYTZP936k
	 525AiogVEAMXoo8f3U/2wtiLHom345+woamQXZG812Wqw1iTBWxzB4lfrEhY0L2dNa
	 EJvLiN1GfSZ7KXDdLY1rJb97KQOIpQcpSkmrSySn132O264dcPg7eLs6XEwEHRR2Jx
	 kAAmy8CviFoouXet9NS4WJJqFN+2BooXsbNYrMheRfZVdZNv+l80ODw7nu/l90jVkJ
	 HWjhC78V1gjM0l/DaNa2Rbj7gbXnQcngNdr12ijFwDhs3Ny03+eY9pKEJ0LhfAJkZh
	 SgFF9W+xXiDtw==
Message-ID: <sashiko-outbox-199904@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 41/51] scsi: esas2r: bound the lengths of the
 HBA, SMP and firmware ioctls
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
In-Reply-To: <20261104-work-procfs-bugfixes-v2-41-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
 <20261104-work-procfs-bugfixes-v2-41-021c84d852e0@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:30:12 +0000
X-Stat-Signature: r3mr8cmuxkicrhk8inus7rog8m5d9ksr
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B0D10180008
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793907015-830073
X-HE-Meta: U2FsdGVkX1/iRsAdflfWFUVvTVt8NKUB0H3KizHGDWs8TaOTsWanz/U5axCylu1naj8GMY7IRaAGe0QXPwBHLn0TTrYK8LA0IkU7ETBpEMDhuxI5qX8kMsATmNuZSgHUQWV+kc1PW9+ZG+uwsgedCL0PMnidWyit693QryvedSdbZ2JNAsa9IEek57iffHe6Cu1vszpEw4qRN80ffsdHD4fSYxqIF/PWM+h/4vwsoAzzbRtCoZ1tpVViL2K3QCSBWUHVHdEj7L2wI0c2vbWNHF+ATKHa70w2l3rHJO2lS4+VO+PcLw64/Ye3G5NKLdKQibjYX7Ykygp3yseCp2ULhlQQhfXgf2H9IfKgT+nfvgslxtt4/AWk6WsDWzFIe8Xx2mUEPRSuYH70ZLe0j9+Tm9FHi2ct0OdsvKmBUuWxq3Wx2AEoB3vqZLXiEshQ9fj42VhhoC0PlTyX8x+KN99kUWeBs1Zw/jrHXuR30SSb6AjwoUyYO12MEK+3vwbINBQs9v8R9rGstDWZ7j/OfqG1GNwN9d7Igr0pYyrwCaKpZAqvJK1nH1JNKV6NsMVDTH+zgMo5ucKVOE+8fTkEuJsGOcI62BTpqcIjo6ZYt8nT0z2LAwXLtt0NWxOQ5UCh42/9QV7bLCYAhkdf1j/vfI/NJD46YO+414G6G8ekHEDfN8pRHYteaGRjVXocbGA0oM+51IzG+VNT23tCoqESllY7opCV2KQe2TiSJMQXU03LBKy1x2J5phAzHF3PvguW7693RjwLhcwrh2Q8a3zqetgQjJGGApJNupB64J/pqqtYcEnCAK8BLoqM9VhwAh667PspeUeHjIto0mS/uy1vTh1vbWreKdKpFfbG31EOPu5JmmLzk0qcq7gq7GQIhFJNiP3GLV5G+jELV05/kdfUkG34t2d5slQlLf7APx0vkcUVgW7DeZkTQu+Dw7bSTI0ylpXC46ohk/K214Ko/ILA/Gw
 fibGUxF7
 Voo7o6d2ob8SvIdq8rZmAw5Dz3pCQRU5l5H81l+rvwDrlQN4yKwCjVRBcvGkUhe9PoSfA6B0N36q9fOjs9ZlokaTT6deS3XpC593Vw3OEeAJ3oTss3V69jyIZvWcrWccAvkSBF05swFHr9Yomz5YRjcFEn2fB+90I+Z+L88Yw1l103q3g1FcS+C3r8Q2pKcVzpzIR+gf1GBLVLERydoDfR3Jm9ZFzk/UWzMMsKHOPyzxj17IzBrxFk99uEsTynwz53XUt10y1GUhwx5zF73LZt1oJuuhQxYZXIsxCAkQl0X+v60hBRSatXdW2uKVml/am4x3f2zf9+BqeQcMejfdelpDDE9O0DHJKMZqEpkrGuEEViQFjpo5OCYLZ0S4G5ETzL8IufnzWHso9kWleYogWLgJaUGzLA94Ks93XMwgeQW7AIxoMUs7krCcUUyREKlO6tPASMizNAxWdefxJZCZdV06RS53iB5JEzy8WuBZ7FyjELe/lDtupKa6gMRh5jhysThTotNm/BXTWJGvuOcplmCSehg5vWu6cMXJzyH6FFgia41eETZL1X3B72nK9yrckYVHGAVG58kEd5xNcsaO5GugA+gmshdPfP0rfOlLW7KaixFuFwYw3mUFZxVmE8hVJv/mSlbbgNVDOenfbThYFsxREcDXix1W1OGY9
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
- [High] scsi: esas2r: double fetch of data_length in handle_hba_ioctl()
--

commit a2397b86d116881b0f288e71fe8885d678578a5f
Author: Christian Brauner <brauner@kernel.org>

scsi: esas2r: bound the lengths of the HBA, SMP and firmware ioctls

This commit bounds the lengths of the HBA, SMP, and firmware ioctls in
esas2r against the remaining room in struct atto_express_ioctl (or
sizeof(struct atto_ioctl) for read_hw()) to prevent out-of-bounds DMA buffer
reads and writes.

> diff --git a/drivers/scsi/esas2r/esas2r_ioctl.c b/drivers/scsi/esas2r/esa=
s2r_ioctl.c
> index c93d9265e1008..80ae5b9d45db1 100644
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
>  	bi.ioctl =3D ioctl_hba;
>  	bi.length =3D sizeof(struct atto_ioctl) + ioctl_hba->data_length;

[Severity: High]
As reported by Sashiko on RFC [1], in drivers/scsi/esas2r/esas2r_main.c,
read_hw() and write_hw() access the shared a->local_atto_ioctl buffer
(allocated as sizeof(struct atto_ioctl)) without any driver lock:

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

Because kernfs only serializes sysfs bin_attribute operations per open file
description, concurrent read_hw() and write_hw() calls on two separate open
file descriptors for the sysfs hw attribute can race on a->local_atto_ioctl.

In handle_hba_ioctl(), ioctl_hba->data_length is read once for the bounds
check against room - sizeof(struct atto_ioctl) and read a second time when
computing bi.length. If a concurrent write_hw() overwrites
a->local_atto_ioctl->data_length from 0 to a non-zero value between those t=
wo
reads, wouldn't handle_buffered_ioctl() still read and write bi.length bytes
past the end of a->local_atto_ioctl?

[1] https://lore.kernel.org/r/sashiko-outbox-195500@kernel.org

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-bugfixes-v2-0-021c84d852e0@kernel.org?part=3D41

