Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01A23607532F
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 19:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kf5VH4Lc
Received: by kanga.kvack.org (Postfix)
	id 0F9076B05B2; Thu,  5 Nov 2026 14:49:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D4736B05B6; Thu,  5 Nov 2026 14:49:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F28216B05B7; Thu,  5 Nov 2026 14:49:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CFCC56B05B2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:49:41 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4945B80AFE
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:49:41 +0000 (UTC)
X-FDA: 85402105362.22.17CF90B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id B74D812000C
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:49:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kf5VH4Lc;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793908179;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M7KNGdpx2i/AmmS1+Byv0+ZgaBgPY2uq2xeQiT+keAU=;
	b=bDByO/xbO2AUOE5+HHOP1WBR5k4sWbefgGdbeeqgsCjvJRl+iStoVOnzWnBdbk633Rc4wS
	xTCC1mbseRIQk2CRhzOSXuiu9GyHCyoKupG+jlWO0iwgGFIH3z2qhMnPytXZb0bBe9MzHb
	+h3sxh0UJqYFQlzp/t2MiawIiFvakFM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kf5VH4Lc;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793908179;
	b=rDaopo/ArWcKmxjgMY+ZGMRLIO70IsEO8NHULZZ5JyRzr90e0tTTAC1t2bogLSaJ+zlCxZ
	YHYsfms2QlSLgvPGg9tbRSEdBWK4feCJ+QmbE9rFPVzfVpvCv4kZcXhyu+/5MzscshdQTz
	u0ATQXUWj+NAAJdc/wJZ/cwdnVSDMpM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5547460221;
	Thu,  5 Nov 2026 19:49:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 275921F008A2;
	Thu,  5 Nov 2026 19:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793908179;
	bh=M7KNGdpx2i/AmmS1+Byv0+ZgaBgPY2uq2xeQiT+keAU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Kf5VH4LctFatk6QfTSC9l2Zq5DIdDxDbiocaT53RxB5PZgnwJbYXHqXYskqa15x55
	 ivaB3B3fv8jl6A7hAuWJ6iF9gZy7wwXbs5dz5rhFLKUam6nHeRCS7IMsZRh+8qJJWZ
	 3oTfWxO8O50TI8zaNLVLummUy2H+F+f3WhDwx0BKzaSLT/yVx3UmsGnVkYw5m8Y48/
	 C8wmhXX+V1RZQdDf6orNHcGku00f/860bMGYlu8Xt0LPq5cght5qJ9ZJmC+8K8KLX2
	 T/UjpIt/kXoaf7HlsGh4+lP+LcFRCHjTGoj5qQPEMgSxlZtw1N7WNE5HwXyLGDQKKc
	 QzqmZeKavsbhQ==
Message-ID: <sashiko-outbox-200001@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 15/26] scsi: esas2r: let procfs copy the ioctl
 argument of the ATTONode file
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
In-Reply-To: <20261104-work-procfs-drivers-v2-15-245e54e87116@kernel.org>
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
 <20261104-work-procfs-drivers-v2-15-245e54e87116@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:49:36 +0000
X-Stat-Signature: gxt8bkc8d8rkb337y6sktcxuq7bfcjtw
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: B74D812000C
X-HE-Tag: 1793908179-757381
X-HE-Meta: U2FsdGVkX191GdvPz4LOtj/rVPtnakl/DpEYejkg3osr634VF6HRR+TYvYdgPASNnOh8vDUdEdjtTHtoYIFHZ9dyz0QDO6hjlNos9rSJ6Ux5IBYO9CmE70UMVAeIv1Ugu8FL9nzA6CA+Mn0pbeYxMde4G+V4+cu+V9vgA0u0pqg33hAAgSnwbPRVwB9bPXErNyXKlXWvLZIDNzs/TkUoQXvx0YMhI9miMhxXxpSDpoTOyjsFu3vjlOiR+HC2WIz3qZC6KLUO9IcwepThwtnSoMuB53dwlAWEjnBa6ksA5H8mcu7OtG/lQescKC/cnD7ciXVuc5qsQMEcCwhLs0qd98HX/TONt0Im7bcR9c8Iy7+5ZgR4roKHm1EKEOn1TNgGKvlUCGnDuIflPNk7IS9I/dG9SExGmOhXQxOSif1ZUIr1gGaDiTtEx+AielNVfvRQNOM1Zq4gz2MOi0TNL93Up+r9SvWoXraz0Rb9CT9URf78TIUxWRNZdO2YVwaSN9trzgM9O/wZcLBbt7xvziC+3UxS9SihAyJ3w0Yz/kGFNwsKgvYcjRweXAO1/QILoHAcQhrNZcDHD7NZ4TpRKu8GqhNw9vpxsNLkERVcbje4XXyfSuMm6I9kHWMIPcm+I0ogrAoRdjy0u56AigvuvYLVzjXkNwfEnCp6YaXTXl1W6348EukhnHL9b66U/ucdfUItW67Q7O2jYFdXpUVxnvio0whEkKnys6pPImZdiU4M7u4+vT/Y2vsjf31fLPdygrY1/NH198y8GHghM4iZ26F5W4OKL3XpOqzf9ev4Z3U6KR+3R8ap7kQlXiJEo5yHVrO52AjdyN3qYjheQJec10+pJQx0HFoxYdXW9RHZMyhn0sVNy/Vqe21KTqziFQgQugxUCjHJWW4mwVzMsWnuoCP0UD8eh/IK6OP4Bgfnbh2zk4NDq1HmqahcXgsEEp6yXAVHiIC5gg2RNmF7ZqOer4w
 34QyHYYu
 VC6GzsaXVjBVn65mopGqhVii85JrHPl3Z9EAl231Mta3apys4W1//tiGiLZYQnKD1C1HDUhJtUpf0D7EI7bs/+bMWNhBo58vcXU2ndhxJ8eoF/okcFIdvTAo6sQ4q/Mm/7IQjAcLs/vjYqmDrL8JuusFst6XOrqiDCbSEaHqwkhoIKrxP2DcIZ3ZlNJJMHx5sakRhfWrb4WKYoiRF1mJh129Runx63RMTdpO0k+J4q/I75D1ldjd4MEAtF4PHT9pSCS50xnyUNu85uyPsHYbCeToWqYl9yxfBghwpT/bK5dSJ9ToigwqJXm05M4tj36IGpAwUsm6gMNu1QwVWE8MK1UNauE0skohj/EYbFifz8oMo+VCFyQq87NPRfH+39Kj7juaUrcqecF9N1lLLQ33PJcXxKRHyfsyuYOTmi5EF0VO5GiZF8E8Y7PSTI4cjdzBDY3jEHMB2VQowmJGnSjVMQBmTUAew0FtNXRDKeHnBjhUi0+4tUCh4xQAmWKjsKdw73TToYC8BTT48bWgYjrWR/hzGeLSqffTQPWqrckSHS3VWE/qmZWc806gLakwh5IhckhHZp5UEc0JrPgJmX2FyZyClBhZDRHl9iCIL0/KXIjviwiEyfLJRHyJS3S2suUuHES9vbjt4pUHT/E6s+kmZBkwUENcof9Z2UnkD
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
- [Low] scsi: esas2r: split declaration and initialization of __free() vari=
able in esas2r_ioctl_handler()
--

commit 6197b49c6d17310202283a54ea188828c65f914a
Author: Christian Brauner <brauner@kernel.org>

scsi: esas2r: let procfs copy the ioctl argument of the ATTONode file

This commit factors the core ATTO ioctl handling out of esas2r_ioctl_handle=
r()
into esas2r_ioctl_buf() and wires up the procfs entry to use proc_ioctl_buf
with a table of supported commands so procfs handles copying the ioctl buff=
er
to and from userspace.

> diff --git a/drivers/scsi/esas2r/esas2r_ioctl.c b/drivers/scsi/esas2r/esa=
s2r_ioctl.c
> index 80ae5b9d45db1..901c5d40cda8c 100644
> --- a/drivers/scsi/esas2r/esas2r_ioctl.c
> +++ b/drivers/scsi/esas2r/esas2r_ioctl.c

[ ... ]

> @@ -1516,19 +1502,43 @@ int esas2r_ioctl_handler(void *hostdata, unsigned=
 int cmd, void __user *arg)
> =20
>  	}
> =20
> +	return 0;
> +}
> +
> +int esas2r_ioctl_handler(void *hostdata, unsigned int cmd, void __user *=
arg)
> +{
> +	struct atto_express_ioctl *ioctl __free(kfree) =3D NULL;
> +	int err;
> +
> +	esas2r_log(ESAS2R_LOG_DEBG, "ioctl (%p, %x, %p)", hostdata, cmd, arg);
> +
> +	if ((arg =3D=3D NULL)
> +	    || (cmd < EXPRESS_IOCTL_MIN)
> +	    || (cmd > EXPRESS_IOCTL_MAX))
> +		return -ENOTSUPP;
> +
> +	ioctl =3D memdup_user(arg, sizeof(struct atto_express_ioctl));

[Severity: Low]
As reported by Sashiko on RFC [1], this isn't a bug, but in
esas2r_ioctl_handler() in drivers/scsi/esas2r/esas2r_ioctl.c, the ioctl
pointer is declared with __free(kfree) =3D NULL at the top of the function
and then assigned via memdup_user() after the early validation check.

Per the cleanup.h conventions, could ioctl be defined and initialized in a
single statement at the memdup_user() call site instead of declaring it at
the top of the function?

[1] https://lore.kernel.org/r/20261102-work-procfs-drivers-v1-14-a994bd4d3b=
1a@kernel.org

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-drivers-v2-0-245e54e87116@kernel.org?part=3D15

