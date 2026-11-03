Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2691C60A260B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 15:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lt7kWY0w
Received: by kanga.kvack.org (Postfix)
	id C365E6B05CB; Tue,  3 Nov 2026 10:19:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0E9C6B05CC; Tue,  3 Nov 2026 10:19:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4B856B05CD; Tue,  3 Nov 2026 10:19:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 885356B05CB
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:19:00 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EE3A2120461
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:18:59 +0000 (UTC)
X-FDA: 85394165598.22.E8C9F56
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 48BC540008
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:18:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lt7kWY0w;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793719138;
	b=FX/noKX73UIw5lx7JTRm+NRO+6eFKMCXlvSEclTDsRvmEiYU/hIlnUUCoV3P1I6giOh4o0
	4z/IoeGVHaD+fVr1U1VkH/NSZtQ2VvQlQQlAHTlpVXKjIkMFeXEX3yhGzUU02jqItHKd1u
	JvUd3DOzSXXnL3w+YH2kgPINSCCGyKI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lt7kWY0w;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793719138;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pXYmXnE4YnSZAwVsghhJ8qwzD8WHMLT3acK3fEE1c5w=;
	b=B/VUENjinLWz8lONw5t2fqlAx1Z6vp8ouJ/BTmhBvOs67I9nDNj/gUlwX8x7qLobmKlj2e
	j/yPbbdkElqSNG7lWxgFzllJpiZ63gu4LtYlmc0NCmb1GfL+hBiEf7qrEL17xoPd1mo7O+
	lrGjrhlT7dR6NerT2eENocCqqvLkX30=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8BD644392A;
	Tue,  3 Nov 2026 15:18:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 224A01F00A2C;
	Tue,  3 Nov 2026 15:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793719137;
	bh=pXYmXnE4YnSZAwVsghhJ8qwzD8WHMLT3acK3fEE1c5w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lt7kWY0w9ieExJiXhsRbswLZTk4I62Ut15H6kMqjEztfFu4VGWWEAsyq1h1RunGi7
	 quYJ9gon1XZinTxL/vkjGOaRSh41+Spy89HkKrIkDLVlyQ2DPkr57UTA8uNv7ZJQPX
	 Gkb+9Ork4a09lK3yz7JxXHSWqFcBarBUl6xpojcbcZ6LCj9+K0W6f0I8igzSlL1ee7
	 HOzooULSEPo6yfs5dQxOzgo+Ck2+yelQJNljZ0d/RFz7CfzGvoYCRRMJGyc+UGPBSP
	 xmtleTQuYNol2touf60/WN8WAXQ5Y7pfGj4AOYhP5EA7RtetswDsaHw6Wd78ymD48r
	 5m+hEjoe7SkUg==
Message-ID: <sashiko-outbox-195594@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 14/23] scsi: esas2r: let procfs copy the ioctl
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
In-Reply-To: <20261102-work-procfs-drivers-v1-14-a994bd4d3b1a@kernel.org>
References: <20261102-work-procfs-drivers-v1-0-a994bd4d3b1a@kernel.org>
 <20261102-work-procfs-drivers-v1-14-a994bd4d3b1a@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 15:18:54 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 48BC540008
X-Stat-Signature: bzyxfskot1kduirndmd73u8nuhz1ermw
X-Rspam-User: 
X-HE-Tag: 1793719138-876060
X-HE-Meta: U2FsdGVkX19H9vWcQJEvj6Irl4KnIrjiZ4qMpbIa1EGZU4pbaXWZYpvX53O9sAQi7+YD9N/EZP1Sq0LyvTNtBL1U4Hc1J086/i0kToYrui+yuFtPMcD4lymjgY3WYculBMNlV66hvm5SbQKA0+d8uVYN9wnulSJOFtG+/H2BxBEfAkzgdTf9oEPR4MKT4scONlNBO/yqtFYqCMTDeGtdBjOGEhWqm1tAJ/TmiQLT6dCQfKK25FmhqIPghKFEhmSgv8CRblxw0akm2hQSSeYZTGTIUf4nSSymk7rKwjjaXfj9vYAQ1qBwQufiWsdLXtMgwjnemFI9SzqCVOeiLW34USXNOYFO+Z8iLLpzjo6M37k+L7fCFw75XUglCISwzkkS5R9wrOWbkYkE87i5b+1om4qxjWgxaMGR9ZyZOgwk2uh8Wtj1ycnhTP+DE8YVwQpBv3cD+ovJOzw5hTrZLvNhSA/tibQVJ+U20CDl5pRX2emNizLd5eoXuSdNqUQagNoFe0f/doVVhkBxCpYM14BqahpAnjYEHTMu3kUXUt8rOjVoN4TGj9QZV8bQdHeg/HlKbFNr8XCYN/ySUny0P6kshoWyNUG0AikLm6+xDgZI5e6gc221BnVo1ZlCvponF6M4HDjKZX615xAs2aiqbJd8SmynJIFNoIzXF+edRhSe71Z+AJjYYxDTfcDzQGT7y6R3OE0JDvBqz62qOzOEyNOfKMx0t0ukpZ+CrO4N/xZvhuO1VWRFLoi6IpFoQL+Z+BUmi8gcyv9r3H/pcN/vul43CF2TO6GJMIx2aWBm3ycK44HxCUR3T+yQB4sV7gpWTWGdwRk6pafUDYZWFVu5dzWFoXL2TPbohsjkuiY7kmH4DIYhZVl3fQ+ka6vv63yYhm+5j4mAcSS8YDgG5waJh90xC9XdjpuiMuBhp1YvCLGrtS4P2SF2R+PfdU1MtjmiAIgVlmGn3CfiT1EMSdH0rKX
 qSsg/hcj
 hyS4eCQPCgeLjuLdonBna0wHwPinHvpdDXpi3MAiSpEYWiFOC4avt5rt0FKkDiQ3W4e+g5UuVW6WL7OLFbNzyNUdt8J0Gx/cqgLynVqkbRQHLrrUj6Xmj1YL3Ly0xLJhsKNbwuxDqEm9fPLTvKuy40icvu86a3r8Emkp9tTxiULqQNu6fImrv7CJhy26aI4urb1u7WqN6LTqejrFUxTpsLx1uC6f1kpm6pYjC/c0JseeGNLmhE3Hbiz1b1foGMr4ODoJif6DJG4Gh5RG/QFIlpckEmaaVyLdLLDfdOQ4E90nT1dqjvySJwN+h9mhdypXUNkvrZLb0sFP48U5FxXumpDRcYD8FSDvyvpWZ+mWBaKYNfelPtOtx0ruiDg/oiIK19XBXPOvqAAkNt24pRadSmIJUaFhd8Q2nsWG9rIsEHBLoz91dvVulmIPL/CmdoMFJsPLC+M+x0Y0JzBXk4fHrVUZUFSPDlCZL2LleWS/bZJVHuPMO3tiIY8Tz+w6Fmwev6otL+cohrmEnOntu82QA4hs+AvHf4bhkz0VYWpeFExKWIxpDruMpyynZqEbMnRI0XX9/tCE6okXm2497SLVU+m6vIzWQskarY7GiZMWIZQT6ITJikcgqlj+CuhYwD/EcrFPWnXJHa8yrgIMJnnK0xIO7rn1g1tKJMGvP
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

commit 0fd79b7040b09fc840e0499afbc88e68b34a3e18
Author: Christian Brauner <brauner@kernel.org>

scsi: esas2r: let procfs copy the ioctl argument of the ATTONode file

This commit factors the core logic of esas2r_ioctl_handler() into
esas2r_ioctl_buf() operating on a kernel copy of struct atto_express_ioctl,
and converts the procfs ATTONode file to use .proc_ioctl_buf and
.proc_ioctl_args so procfs handles copying the ioctl buffer in and out.

> diff --git a/drivers/scsi/esas2r/esas2r_ioctl.c b/drivers/scsi/esas2r/esa=
s2r_ioctl.c
> index f99318f61c934..eb39ba8263b31 100644
> --- a/drivers/scsi/esas2r/esas2r_ioctl.c
> +++ b/drivers/scsi/esas2r/esas2r_ioctl.c

[ ... ]

> @@ -1515,19 +1501,43 @@ int esas2r_ioctl_handler(void *hostdata, unsigned=
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
This isn't a bug, but in esas2r_ioctl_handler() in
drivers/scsi/esas2r/esas2r_ioctl.c, ioctl is declared with __free(kfree) =3D
NULL at the top of the function before the argument validation check and
assigned later via memdup_user().

Per the Cleanup API conventions, could the __free(kfree) variable definition
and initialization be combined into a single statement at the point of
allocation:

	struct atto_express_ioctl *ioctl __free(kfree) =3D
		memdup_user(arg, sizeof(struct atto_express_ioctl));

after the early return check?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-drivers-v1-0-a994bd4d3b1a@kernel.org?part=3D14

