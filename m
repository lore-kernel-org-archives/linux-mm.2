Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3DDC607A645
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 19:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QRVwl1Yw
Received: by kanga.kvack.org (Postfix)
	id B8D5D6B05CB; Thu,  5 Nov 2026 14:35:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3E856B05CC; Thu,  5 Nov 2026 14:35:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A33A26B05CD; Thu,  5 Nov 2026 14:35:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 80BD86B05CB
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:35:55 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1F05CA0C1C
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:35:55 +0000 (UTC)
X-FDA: 85402070670.11.4B1D8D3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7BF6314000C
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:35:53 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QRVwl1Yw;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793907353;
	b=BeUE1mJVbO1/+1oIggdbU+4ZP+j4j7DW24n+hzP4LZ9FxnA2rjy8LkPCi4F1Ly5CYzk0fk
	awDJ4URO1WT7guCyzNfPvOLmrG/drHeqXU6ZxjUPI3nbE3whRY/oSAmjucoO584J2AFO9w
	zQM0JgjeS7Wc2+h80JUFqfEiS4vaNo0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QRVwl1Yw;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793907353;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eiSLs4tpW5+ooQETfUAsv7SD2u+8vxBZSNTA/E9JPSA=;
	b=zXxx3r5sodVMJqv2g+oI2GWtbHqkKjJkELvzVP7Ew2CO/M7EMYVojaTQg/Ky4J5CI2k3uQ
	nTLeb0fpWSex6XDPTVTCTD98TjJhAqE7OOGXTww2MB1rp57u+fGYECxRs4AIG25HlQoNKW
	4Xque8Wzj1THku10+iV7E6pVfV6CuEo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 17EF56014B;
	Thu,  5 Nov 2026 19:35:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A24731F008A1;
	Thu,  5 Nov 2026 19:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907352;
	bh=eiSLs4tpW5+ooQETfUAsv7SD2u+8vxBZSNTA/E9JPSA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QRVwl1Ywon7MS2C+OemnpnnRZyhhY3OqsfkA0hDxdTc+rduK6mkVEdlJDGNIGqSYy
	 a1NLTQZZqowxlMpgmKyOfh8BBgOzgFAHydYWKlFfry5yNMxiI/UD8ldqZYx8WMm7ez
	 QNVP0ICID7Qj8TKSjz1zNuhOdyu+/wENB2Pe+KXsAcn/SDnE1f4VadXGr2TU1yn/I4
	 kSqEUN6UAmPa8USnYhqhq+djAtPsBeI0nhvEXQeRMsO17pEiCgKx17axw4dL2BiiBh
	 F88Gi+dRDEKECFbv6g4fiHem3PZPjp3QB2HUifdGFOqWgr8pWyiCoUmeRakhBgXvWb
	 R9lZgeMwuUEfw==
Message-ID: <sashiko-outbox-199948@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 18/23] proc: let procfs copy ioctl arguments
 in and out
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
In-Reply-To: <20261104-work-procfs-core-v2-18-76ace653a773@kernel.org>
References: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
 <20261104-work-procfs-core-v2-18-76ace653a773@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:35:50 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7BF6314000C
X-Stat-Signature: 84yzm1sfy8acaigxgjzyjry8hz3u6czn
X-Rspam-User: 
X-HE-Tag: 1793907353-173177
X-HE-Meta: U2FsdGVkX18+MCUbAfhXKUzYWoizPGn38F+ghX2PIH0+jUWjyNvxYzP3KfSVBWRmKF6QQfpfeFvjzy+HFFitzAz9OVTrricpaCb64ZnAepMR6JLkO1Tq7VmdCl+djcBccDEcHxDJpy+ScbGGio9sgm6mHYpfoaa2yIo6EvPlJTOH5E7afkz+Wmuv3hJpn4J+AYyv6hpvRvhQStIb84VcPm2IfiQdv0bm9G9XICYKLeRCXfBN+ThsnZs9vKNB8XljLqMqYDwuQw5HQRWZP6vggiBGb0/FmVIW95S0ioFTVwcCgB6LOZWXTmr1u7DZnAXjHNxQjurIFOXxbXB5cp9c6UOMKs8GVhwI/kFHPMX5eX0zWKSKz8GGfpWrWaMZU8Kt31WyDk+799VDStuAv16zpGDIcev1COadXjdnLgjwQNVObGfSDTU9fSvMgVtUcN9kDN+pLkShhwXq7n27x1iY9xN9HW1A40LIwjJt+SKxUQONoYRX19eSw/C3nI76T+4+lD7m3BCS5cHMcCuLJ7sXijyLGWvXn1PsrAyNea+VIFdNcUGxbo42ipTKOZWgVm+h4OPPgKCOb1QYgcHP5N4D7PpAu81UIe6kxcQj3j8nxcwSVVz6ZenWgCPl8OdCEjexvCqsoxW2JFQlJcuQYDBO5rGlwqgvv2imWc6gS3KML64LJEJU1Yv4e7lStxWtZ0Xl4FZ3OjuvDq9GFGp/nPdTcVQM0MgOIOHEQnUDDUAcw8prKl9Gg7yvqdcDG/eI8iAhlm2UiWETSEu5lBmraoCR+nlixZ1PAed6InwVrHr148k6+vkDBJiUGqwguebL33Qo2knTunBd6E63jvM6y34CWQG5sgbrSqP2zo1tjpS9k9iqVxhWCX6T+47XnJJaVqQkidOeFxYD7FQrOqWRREhUGiq5aV4Bjf9s13sjL5USOLHzRy7FXqmTQ0vj7+VZ2Kg4BDnVk1jrM4EGyZ6Pz2C
 j82+3tgf
 AJklc48r1EMYD20tfWyA6Zsq13jBpi6oS/ftu/+TmMUj3mBDCyQN1Mvpo/BVkMQrTFdP8YX5V3b3zKz9ntZvCOM0P/tEa2akPCE9UeOFbIc/Sdeu7+HNp9hCn2zTeYmTlKQ8EmkIJCrodgJz4ZP+xM/m1T6yqVSTaPcq28xAMEr7tvbkgoUY/yyA8FT9jjZ0clENye2Utiekjuo9P6sahFegBwPaJv+5HzWziXcsFZ8HBS8TwKamMt+c0H5FmvL3LXxAQjIMHSchChymavpEi6Ip0nWXZ0khZkkUinAsoqbYq1SfBYukO+OlJjRtM8TDtALXvbgaSqSVkhhIJW9n/OylYej3pYgMB6yVBdG+l/PRUcOkUyQpRpA3Rt0bErZ+NnFnxGkSdl+xIusU3Q3pwxxNQHYhMM7/i+aiXsinpJjMAI1W3tsrFklCQ1AVm7txm4XAQgLSw31h1omrrHhkALhi+4Hb7OYOfYov2/TToRbqiw+njl9BIWi6XMSssAXXoQgcg0r46Xhciz8zLnEya8JWiICg4ugFjG6qi+D3tfXixGmlMIEq6OF2593AmcLkiRKmDqAQv6UbG1oiT93kArnJ13DVtdcjxvHi8ak4re2f+ILBsBvMX+y3Xo9IaX7K9qwpcF/B2RaTqRskdJ2tY0KBJNCfRvcPEgPf9
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
- [Low] proc: __free() variable buf declared at top of pde_ioctl_buf()
--

commit 56830294f9ddc9f5679014810e7198455a39f42c
Author: Christian Brauner <brauner@kernel.org>

proc: let procfs copy ioctl arguments in and out

This commit adds support for ->proc_ioctl_buf() and ->proc_ioctl_args in
struct proc_ops so that procfs can copy ioctl arguments from and to
userspace without holding the proc_dir_entry pinned across user copies.

> diff --git a/fs/proc/inode.c b/fs/proc/inode.c
> index caa47933c233d..717cbaad65df2 100644
> --- a/fs/proc/inode.c
> +++ b/fs/proc/inode.c

[ ... ]

> @@ -548,11 +549,66 @@ static long pde_ioctl(struct proc_dir_entry *pde, s=
truct file *file, unsigned in
>  	return -ENOTTY;
>  }
> =20

[ ... ]

> +static long pde_ioctl_buf(struct proc_dir_entry *pde, struct file *file,
> +			  unsigned int cmd, void __user *uarg, unsigned long arg)
> +{
> +	void *buf __free(kvfree) =3D NULL;
> +	struct proc_ioctl_arg a;
> +	size_t size;
> +	long rv;
> +
> +	if (!pde_ioctl_arg(pde, cmd, &a))
> +		return -ENOTTY;
> +	size =3D max(a.in, a.out);
> +	if (size) {
> +		buf =3D kvzalloc(size, GFP_KERNEL);

[Severity: Low]
As reported by Sashiko on RFC [1], this isn't a bug, but in
pde_ioctl_buf() in fs/proc/inode.c, buf is declared with
__free(kvfree) =3D NULL at the top of the function and assigned later when
size is non-zero.

Since the cleanup API convention prefers defining and initializing __free()
variables in a single statement rather than initializing them to NULL at
the top of the function and assigning them later, could buf be defined and
initialized once size is known (for example via size ? kvzalloc(size,
GFP_KERNEL) : NULL)?

[1] https://lore.kernel.org/r/sashiko-outbox-195542@kernel.org

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-core-v2-0-76ace653a773@kernel.org?part=3D18

