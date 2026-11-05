Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFD77606EA41
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 19:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MNcTfu51
Received: by kanga.kvack.org (Postfix)
	id D62616B05CC; Thu,  5 Nov 2026 14:36:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3A716B05CD; Thu,  5 Nov 2026 14:36:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C76CE6B05CE; Thu,  5 Nov 2026 14:36:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 99E6B6B05CC
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:36:00 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 86AA9140BDD
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:35:59 +0000 (UTC)
X-FDA: 85402070838.24.0883F3F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id D2D5B160002
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:35:57 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MNcTfu51;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793907357;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oYzAsF0I+e0CW5z5u7FoosueNiGCXkY4vYyESz+rdRw=;
	b=ayByYVnyyjpYN3MTX1cnAb7566Ry5ZiMQ3dkN4HMXQjLs2LJBeN4Lsk9bCaptnaofnfejs
	Eol5ANG3tWqTNg/rIvYvOx5t2ITo78dZEJYv7wsPPWPFaJvMszWfITu1agG6srlOCoRNXD
	AUAy42ZGgftgDEVMqekvvr+nam66CBU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793907357;
	b=rJ2EuwCKFtPKPjWW7uTHOzDLU5cpIl5milOp7Z3jL9q8tcq5iWFBPHVmpY5OyXllJmL0XK
	tqy3Fgn2PTc4AeFAjM64u7yUqa1vRgO9t+ALZj83iPmyeg7Sef81TWMRdqi8nYyIq1EQT8
	AwfGyPvVlivQfKupmxyejsao0+QetxI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MNcTfu51;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 719DE601DE;
	Thu,  5 Nov 2026 19:35:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CAAA1F0089E;
	Thu,  5 Nov 2026 19:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907357;
	bh=oYzAsF0I+e0CW5z5u7FoosueNiGCXkY4vYyESz+rdRw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MNcTfu51HAjp9arjwyGN1MZppN/dC3Ih6DC5avMnmUZvCl1H8KMvBU/ZZwYPTddlq
	 8PnPW4CSFGBN1dDKTDcBXSBShP3a2WX5Pp6p0nXP7btknLRFB9PL8Ncjca4QfFR7o6
	 oieIQ42NP3xLduOm0i3X+wXP5Uc/isojnKGZtzQxRcqeCltZdRDFH+n0KxLYl41RIP
	 ATkNXn2O63ucMGLH8txRIYQC8ZLHJgxM0FFautSGCwD/y0R1M9Jy2DlUyf0qiqgXBM
	 VIcI6Y0C/5lhKqfM+6+0N06nY7P1BiHq8y1ifirsgXbr9GMfqL0sos0ji0uQdTtER0
	 P0SLP3MDfXv8g==
Message-ID: <sashiko-outbox-199950@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 20/23] selftests/proc: check that a mapped
 entry can be removed
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
In-Reply-To: <20261104-work-procfs-core-v2-20-76ace653a773@kernel.org>
References: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
 <20261104-work-procfs-core-v2-20-76ace653a773@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:35:54 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: ajyxpd4du846a9bh4us4t699zetgowbf
X-Rspamd-Queue-Id: D2D5B160002
X-Rspam-User: 
X-HE-Tag: 1793907357-912703
X-HE-Meta: U2FsdGVkX19aOaMEFiwihN9W2iA+mXgCQ8K4IGhx2lWw6rzjsMhI6U+NxPSSwKZcHN47/M2AWolWefltsV5IyJ2vSfBzKYGYatvzjvjaqcV94lr6EPQfgzu0QzD2GBNCJeaiKMgryk8GvXIfZff40mHpUetztOU/UKAo2FOPL4oHbZWmDjXnm7Z5afHY9n4YRdttHEJlWtg4HCkxjgpgPSpaaArioEuYStOtyjWPAylX1hgR+s0C9qKj3RLcGtw92wrmnBxCxUAYYljdup6RV4RMiovF/+c6nAhfuT5unTeEXEX1VJxiFdXC724QA5lVd1tFdfZLxAr7lodyF8xMCHKJ4GwDLKqJ64cckFrXKQkLwj0pN6fM7g0X/htw5qVXVfEC6z7zIdpve6vebR5MGy3rOedE5ItwGmFMwJ84v1OAKGOc9FY/Fwd/Qcf036KZ7seTB51vQ01BnJ6iX5mMM3wnDb7RplpUvHZXYV1pQLA3uWqON6gUwi+H6XN4NfDUB7mo6H4dsGKAue3RrrSYxCQmZ3vazT3a4Et4PY/0FNrU4LKphBaWlGGONTTn9ukMlJyiTCfDw6uak6FHoJUjjREBk4zDXv142ATvo4JdpbrB992/UbgekriXPYyRXJiK62fwpi8z9oqoAnHJzxH8Rlvdp2N5Y3jWlyGJWZ6rD73PZMc7TczGF3aqAr7w3UcY+z/bsRdTArCUUa4tQbS2f7H6iT5Rsc0074wnKnG0TF7XTZ+EXrrRmlWzLPpCJZlYc0Nr5Oz1AUb5SPeZ98JInLtDdW5p2EH8N1o0Ivx9GREyRCyzArhksFpc2UI3Cdi1+9qmeYrzj6eHZZr0XPgm/j1cQY34WNHrWfCY1aHtjWH6HLQ88IQKmLbFw3rSwGDmBYWauz4WAABMUxDkMshZNIykGTr5tb3Q0fThqnOCvYhB8jjY2bIUWxfVtg5APrzuWMdMWAm9ggi79rgSNtV
 UJ4rdz4z
 BXkCKSU7KyFZ+Gq0BC9JvqPyBoHQubZI6oCEI2EKdLoA+f8aHP3x63KIfSbMcIqgvHQnBgM/vKWMkP9Z3Q28F0Sfnmy5wdwACVEsg0xVjzqZG8p/N7Wc3mwNxNbICEXtIzAmc6yPCmVqOQoqHQ21qnZGYv7zYT+9LgLfScLyNyMPTPAAve0vnlW5yuQGYP296mNBasS7oqtUfyajjiAUFM95WH4i0Flz9YmDK7Nk95j7+rNINMwM1Q87zkGmOqd86sFmtVIb16RaagfBQLgmjFQvO32HXyB1prs3XdMjXI0fsm7FVNnBV009ggXywjtvSuYR9yfPE5Xso4Gx8X8hsJGGBTDwPmMf+eKbRxdiFAXWXE7MBWMS2oSEs6DUXPPwrLxw9m6pXe8sEVfNMQADAeAZoJ4iYIwIB55DAnAeTj6qVeUuPNSPKbtF9SZ8GxaO+rmynY0ilTOvvP/Y8g33rpGARPDuIeO/3oXPqXEb7Ka4T50U/WZ95LmTvk3jhrvDwE1ETi9+lMLM/dgYxvN0o1/QwjFUHOGznYF6RmjMRcLrk509IwJd1HdN4iHgJMjnjA9IHl1TqyW3qvp80yhc8XaJmd+SBk8MnR43kJ1CICqMgjEihYuxPaKBHW/cUlA7g9n04/GYjltnIlygxyqDi9tB1EKg5cia+ffKe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] selftests/proc: 32-bit off_t truncation in proc-remove-mapped mm=
ap()
- [Low] selftests/proc: unused len parameter in mem_bar() in proc-remove-ma=
pped
--

commit df303f424b9a370ffbd0eec6c07ff2a99d0ee4ea
Author: Christian Brauner <brauner@kernel.org>

selftests/proc: check that a mapped entry can be removed

This commit adds a procfs selftest that maps a PCI device memory BAR via
/proc/bus/pci and removes the PCI device through sysfs to verify that remov=
ing
a mapped procfs entry does not block and leaves the file returning -EIO on
subsequent reads.

> diff --git a/tools/testing/selftests/proc/proc-remove-mapped.c b/tools/te=
sting/selftests/proc/proc-remove-mapped.c
> new file mode 100644
> index 0000000000000..92860fb2a8f40
> --- /dev/null
> +++ b/tools/testing/selftests/proc/proc-remove-mapped.c

[ ... ]

> +/* the first memory BAR of @dev */
> +static int mem_bar(const char *dev, unsigned long long *start,
> +		   unsigned long long *len)
> +{
> +	unsigned long long s, e, flags;
> +	char path[PATH_MAX];
> +	int ret =3D -ENODEV;
> +	FILE *f;
> +
> +	snprintf(path, sizeof(path), SYSFS_DEVICES "%s/resource", dev);
> +	f =3D fopen(path, "r");
> +	if (!f)
> +		return -errno;
> +	while (fscanf(f, "%llx %llx %llx", &s, &e, &flags) =3D=3D 3) {
> +		if ((flags & IORESOURCE_MEM) && e >=3D s) {
> +			*start =3D s;
> +			*len =3D e - s + 1;
> +			ret =3D 0;
> +			break;
> +		}
> +	}
> +	fclose(f);
> +	return ret;
> +}

[ ... ]

> +TEST_F(pci, remove_while_mapped)
> +{
> +	long psz =3D sysconf(_SC_PAGESIZE);
> +	unsigned long long start =3D 0, len =3D 0;
> +	char path[PATH_MAX];
> +	volatile unsigned int *p;
> +	unsigned int v;
> +	int fd;
> +
> +	if (mem_bar(self->dev, &start, &len))
> +		SKIP(return, "%s has no memory BAR", self->dev);

[Severity: Low]
This isn't a bug, but is the len parameter in mem_bar() needed? mem_bar()
writes *len =3D e - s + 1 and remove_while_mapped() passes &len, but len is
never read afterward because mmap() maps a single page of size psz.

> +
> +	fd =3D open(self->path, O_RDONLY | O_CLOEXEC);
> +	ASSERT_GE(fd, 0);
> +	if (ioctl(fd, PCIIOC_MMAP_IS_MEM)) {
> +		/* no PCI mmap on this architecture, or locked down */
> +		if (errno =3D=3D EINVAL || errno =3D=3D EPERM) {
> +			close(fd);
> +			SKIP(return, "PCIIOC_MMAP_IS_MEM: %s", strerror(errno));
> +		}
> +		ASSERT_TRUE(false) {
> +			TH_LOG("PCIIOC_MMAP_IS_MEM: %s", strerror(errno));
> +		}
> +	}
> +	p =3D mmap(NULL, psz, PROT_READ, MAP_SHARED, fd, start);
> +	if (p =3D=3D MAP_FAILED)
> +		SKIP(return, "mmap: %s", strerror(errno));

[Severity: Medium]
On 32-bit architectures, will passing start to mmap() in remove_while_mappe=
d()
truncate or sign-extend PCI BAR addresses at or above 0x80000000?

Neither proc-remove-mapped.c nor tools/testing/selftests/proc/Makefile defi=
nes
_FILE_OFFSET_BITS to 64, so off_t is a 32-bit signed integer on 32-bit buil=
ds.
When mem_bar() parses a BAR physical address >=3D 0x80000000 into unsigned =
long
long start, converting start to a 32-bit signed off_t in mmap() either
truncates bits above 32 or produces a negative offset (which fails with EIN=
VAL
in musl, or sign-extends the page offset passed to mmap2 in glibc so
pci_mmap_fits() in proc_bus_pci_mmap() fails with ENODEV and causes the test
to skip).

Should proc-remove-mapped.c define _FILE_OFFSET_BITS 64 before including the
system headers?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-core-v2-0-76ace653a773@kernel.org?part=3D20

