Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD1C86071C01
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 15:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=egO6F/of
Received: by kanga.kvack.org (Postfix)
	id A40B36B05D2; Tue,  3 Nov 2026 10:01:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A199B6B05D3; Tue,  3 Nov 2026 10:01:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 930AA6B05D4; Tue,  3 Nov 2026 10:01:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6500A6B05D2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:01:32 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CF6CAA0490
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:01:30 +0000 (UTC)
X-FDA: 85394121540.23.5A2109F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1C1BD40014
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:01:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="egO6F/of";
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793718089;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HJo7uhQ8siYxDw0RZS7+3aCaFL/z+RS5DWNp/kEBIgk=;
	b=aUe513fJL8H2hX+ladEKzsMfgo3A6Y4yKq2i6kNNcZxqG2qA5J3EFRswfb3lvaylq4Jpis
	nUg3lnl5ev3IjJQbVRMGF7qvG0xt0a7yRretiUuC/8hzFbDM21GEm5pu+oScYjBGde8Pzi
	BLn16EeDnyCKXxQVhuQhOcdb5rn9DPI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793718089;
	b=PsSBnFFpqOlLhzxmqxvEpTlHZ9fcTWMn8vrDvJIqxlVzylbKnIxUPoC0AjKL61KQuMZfkG
	IN+CdosWAsQO33/c9j5y5PLAP8SF+J2bVGJwHvXD89DSFtZLmPNNZlia/1bon/9vFNZp34
	EnHJ6A2hilPftYx243OyumItljyBYcA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="egO6F/of";
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AD1F160239;
	Tue,  3 Nov 2026 15:01:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D1CB1F0093A;
	Tue,  3 Nov 2026 15:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793718088;
	bh=HJo7uhQ8siYxDw0RZS7+3aCaFL/z+RS5DWNp/kEBIgk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=egO6F/of7CpTd+PoLOWG9TxuNy/r0bVezlWWB3WedBTqIlqmwFVNqYhzt7VSoW8zF
	 L2Q3+erAo9JrU5hHInrg7k+kxzeqoaIrxxrLW7A1xtt/ncPtwSegLy4+TXN3HzG/hu
	 X8lQ7pFsFkuXEdqfkgkDg+lJrU+5qpItEyIjMQvlvx7yavCortIJIC3nuU0t33yVqs
	 dtJ+2iUHTvZB7QICHjQj8YsMjkOoP8NVFK47FEu6xrH8SbXS5x0lCNVOHCX5Bxz6mY
	 dkiORpDTzbslpgezRG4qDhAij5S0Pzc9kdghBEA/Lbr/FhFJu+yj3tH/1YEccJaQ7R
	 /D3PlZ2sc1PyQ==
Message-ID: <sashiko-outbox-195538@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 11/16] proc: let procfs copy in writes before
 pinning the entry
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
In-Reply-To: <20261102-work-procfs-core-v1-11-75df35e4f8b8@kernel.org>
References: <20261102-work-procfs-core-v1-0-75df35e4f8b8@kernel.org>
 <20261102-work-procfs-core-v1-11-75df35e4f8b8@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 15:01:26 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 9esaxzk1n6d5nfpchk6qbzenzrwis9zg
X-Rspamd-Queue-Id: 1C1BD40014
X-Rspam-User: 
X-HE-Tag: 1793718088-482290
X-HE-Meta: U2FsdGVkX1+WnZ8oovgbr3J2O79DuNTqRn8nECXCD9qqStWZpawNrqYJ1TZM9B6yk4fobtoycnj70shidAoXaQ8hyQC0MqXB1jUJh99fOAZ2QM31t/RNtYT96cb1Z0y1CMYSpy3E9Eg0e6/3mWB89C7fVU7Bcrs7OJC8VlpuP6cq2om3ylwp3uEYgTuI27JcRpkNUDq8KkmSus/Yy459GbwHGB/bc6SwkrHWG5LGm0igxi4OgPib5OI4n2PfB5X2ZvpJUv9Kq/9F7CJPWNkYzwG3oWun8pyJ3nBSbzzGTmojB3K5pZMXXbw6uSqni0j21uE1/MtuG1zWODJag5SCvJSt+EEHK6SAw4nuMOqLJ3XpINbsSVLtvcTFq8SfopiEFi8TK2f6ERMO0ktTBjMKlhnc00GhnM5TT9iYRE4lTJxbLVr0MoLKD8ZJG21W6RVlH3V7jpCldYx0KNZVbhS1s/3gTd9nO9hp8A4Sju6qeYh4qrn+PW9iRax8tAe8n9U6iEbTksRSUhInd1aJXVY+4S2mw6wAaF3uysj1FpjgDkKrkTR1ZdjDVFxbL/xurKH2Thq/LTZXy9/vM/fPlvGv3686sl/Ne+jinVA5K71dSGUa2dHITI2gdUic5lHO7bAW7qIHg8WShGcA2IDs7KAceUojsb9Jo1Xh2xeHb3m01EPSihfoevLkIxe3C/FIJGxiYg6Ap4E4kMPeCzZ1Xu+1dXoqImo6VIkmkLqaqKkgQnUS/gKzTTFKZQ7WeUp2JGT0qYAwqYf+PjzJEShdu6rPCAGGB/5jxCxLvZn0Bpk/JljUrrm2FQJXp/XdTdxYZFNVaWzRM0RswewPfcVi0LLezdNFndlQqmwVcf01gjmJ3xnPZl0tZHhRRsGTvCQXO3mx7a8eBz3oIlW5pkgqIVQY82znf7tFS5NPQRmV5jxjkURghe/MswODxG7dgVYPmBaTbnhBDyFVzWj2YPLL2Vc
 wZTbqmxj
 eCl92nL3lN4rNeG8xrHYo73UotgA43IAq4fKgoia8/U6ap4djDOCOoNgNykgVnewq8k+9aJpxi2wgu/oZPO2uBYwJ+LxF6sGhgcJTSNSloisQiIhjPAGwjdcTpUpeH6AiQf9GnSW/nvXInfOcYnD5ISbt3/fMmzMXYFzKNdIF5AIWoYI9Dk+sYdTPxf2/q/KJal0mc192/L7o14j4HYNdIp6Go5mxArMifmjhvi3e8Rg013Vq+8stE3UFKK+ZWHy+EEN54gCo7lMPd8ZS6M4UGABFlxefGrPlnLrH2Vd7pmGshRmiEWlXqHKImwC1944vJ1oCpYe9cysqwRIZWlV/+xUvV7OFk4cZ14OO3JAOOArIdmeI+EL6PWcd+pY8Mnu6SbBcUWhn4Ut9zrB2UqEX1gYvsZx/tbhloFmH63/n3cd3qc1lj7QbAVs9hrSHixAlPfzQslwfPesHAfkwnmKy0L9ZvBEQQc90ZGyUOZ6KNt5HOdCfpaEJItSaGpAWDXL1u3lTWNXXJM4NEKa2iRrsrDHnZWFXkg4pQHT+IjxanznIivXAaYGBL+zNalcblL22qBEW6f8PIs6hkff+vYPewYGd+FW/O98Z6pgd2MbD9iHKKxtUa958rhM5TxixIV88eImkwgnOD1Pxc3xQ3tTxTlWHq4nAmmfCcSah
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
- [Low] proc: split __free(kvfree) declaration and initialization in pde_wr=
ite_buf()
--

commit d672761b59bb5333b9344e6a78cc97135a5b70b1
Author: Christian Brauner <brauner@kernel.org>

proc: let procfs copy in writes before pinning the entry

This commit introduces ->proc_write_buf() in struct proc_ops so procfs can
copy user write buffers into a NUL-terminated kernel buffer before pinning
the proc_dir_entry, preventing page faults during user copies from blocking
remove_proc_entry().

> diff --git a/fs/proc/inode.c b/fs/proc/inode.c
> index 8425465aae5d7..c0bb40e7ff964 100644
> --- a/fs/proc/inode.c
> +++ b/fs/proc/inode.c
> @@ -440,11 +440,44 @@ static ssize_t pde_write(struct proc_dir_entry *pde=
, struct file *file, const ch
>  	return -EIO;
>  }
> =20
> +/*
> + * procfs copies in what is written before it pins the entry. A writer t=
hat
> + * faults on its buffer then doesn't hold up remove_proc_entry().
> + */
> +static ssize_t pde_write_buf(struct proc_dir_entry *pde, struct file *fi=
le,
> +			     const char __user *ubuf, size_t count, loff_t *ppos)
> +{
> +	char *buf __free(kvfree) =3D NULL;
> +	size_t size;
> +	ssize_t rv;
> +
> +	size =3D pde->write_size;
> +	if (count > size) {
> +		if (!pde_has_short_writes(pde))
> +			return -EINVAL;
> +		count =3D size;
> +	}
> +	buf =3D kvmalloc(count + 1, GFP_KERNEL);

[Severity: Low]
This isn't a bug, but in pde_write_buf() (called via proc_reg_write()),
buf is declared with __free(kvfree) =3D NULL at the top of the function and
assigned later after the count > size check.

Per the Cleanup API conventions, could buf be defined and initialized in a
single statement at the point of allocation:

	char *buf __free(kvfree) =3D kvmalloc(count + 1, GFP_KERNEL);

after the size check?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-core-v1-0-75df35e4f8b8@kernel.org?part=3D11

