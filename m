Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B575F606A331
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 14:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ljtTrKrz
Received: by kanga.kvack.org (Postfix)
	id 128776B05BE; Tue,  3 Nov 2026 09:48:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 064556B05BF; Tue,  3 Nov 2026 09:48:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E48DD6B05C0; Tue,  3 Nov 2026 09:48:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AFF316B05BE
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:48:46 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2ED371C3A2E
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:48:46 +0000 (UTC)
X-FDA: 85394089452.17.9237C4C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 05568C0003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:48:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ljtTrKrz;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793717324;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ED7DfxpP0C+3U90pEocB+hyI9bQg1Q/rMH3eRirphfo=;
	b=MshP0CGVQIvsqaLh4IZ2DAa93bpzk+krETWKk3s3Ryoisg6Nrc16qwiXTWHYImTDTd5EaX
	/rRDHln6hesd6cQK/OiR9wjSdAAnrdvxYNMlnR9TXsryJ2BpOFUBWLEHNW+vnDKJZPjt3L
	zY/RUkyq8UL8R2iVBSwrQ8pMiJVt+9g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793717324;
	b=JEG4808qJ3bLeFrgp6Vh7ecqK/K8INPiZhmLbasWqaGc4aTfpiBdQT6W/CNzFG8/gzllVn
	kloR9WeOLzVINxuowdGIusuRyjFPR3cSWNO+0bS8NDI4Mtmwcb9kQRS6KTBP10k6pkss0t
	/cUu3ef2DrwuEV/LcVn8aNnjcNrx32o=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ljtTrKrz;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9D10860616;
	Tue,  3 Nov 2026 14:48:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E4781F000C1;
	Tue,  3 Nov 2026 14:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717323;
	bh=ED7DfxpP0C+3U90pEocB+hyI9bQg1Q/rMH3eRirphfo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ljtTrKrzjwh9bmTgB/C4QRv4lPNCmDXb0oGrnMVLkXCeEPfpYMq2XwmiskAtwQlsK
	 oR+9Ko1Pl3b/OoYpR0JTmvi3u4DF0d6V6KQt841p42E0GJwXEsp4zexEhStpCZGKot
	 pkJLfSa1M3AMrCCthqht9MFhgLn+Yh9p8Octt6Ghr3uXvq/2JhHMONBnt+SmQKq34t
	 I08bZ2ixHGY9RHmh/bJlC1bBT/o22sClyAftWhJVYpDvJ2AVldTnb++uYWhQYb014k
	 kzsT0ppwzb8VRvjDyZBpKuGuVZJ8s3MbvTiItwdFL05JRwkjFnFrqSpfLfwR7+VZN8
	 /LmgWCZM8tKSQ==
Message-ID: <sashiko-outbox-195508@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 36/38] selftests/proc: check that faulting sysctl
 accesses don't hold up removal
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
In-Reply-To: <20261102-work-procfs-bugfixes-v1-36-59422ed3e465@kernel.org>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-36-59422ed3e465@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 14:48:40 +0000
X-Rspamd-Server: rspam06
X-Stat-Signature: tw4f9ucbfphd8w7rkq3x3i8nqj4xmozk
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 05568C0003
X-Rspam-User: 
X-HE-Tag: 1793717323-155002
X-HE-Meta: U2FsdGVkX1+10YFhJdYDPG8s0mFNpGNkUUMUTixcLhM1OjAboiUxoi1JGOj5kg1xIC8hqqJM1XeQvsD3N17APrwd7CE3EmhKo6wKROz7BN3dzSnppyzfqszIfc5rQXTE6nEv3PnMGKiJ3Ees4zNwem8Gf9ems6i6+5Xsu0LXUzXvXCvOXmVQby/Qk86DvyhhQFS9/VdyF78xOyhH8iOVa8ErRpmCP55EvW3tbd2oGmr2mRfcRY95/ANNd2aqQ6ZcK0NZXApnUsjzp5kLLsEvqgGjm9aTMzAlQf1GKKcHZWLTxhoQuTwYxbGieUiaVqptjdMFhSg56JeKsim2QZv4LUStFmg2LQQZ12JHm0pRkerxRDyLHV6i5hMvxIILFOZ5vOcPoP0D3xX1+qmxsDdIKcfTDnXBRX6hILEEJJPQjJrN3xgve+K2RUg2MLsoRkmc1i0uXJssSYYJYzTiBJOELoUHBwUSz8/+FHNioYMzlmP5V+ekJ2K/syaMCneUUw6zzsvmRfa3QZFzxe7URl6AKnkUBUT2CJQtCFDlVJHKKyVLrnPAMt0xNM7vWzLLwyFWW2k+iEuP+lGk0rvvH+7RUqcb5EU7Mxylfo/pL8QxSfrTLXiQ/dArCf10LimKvQldn12zZWAkC2WQGYeGsgCtNAQzR4fHHubvdwQhL0FVByjR0DAcfLlBAw4oLKlLni+U/2KFQvTL3t9s0Ne3QW14NaLw8XUvGNeNAD0bYTpSqGxqJVDSYOFRQo/Y8YJquB7Qy1zsMulbUr6gb1XrfGezFOESd6gRKMjVax8x5QUKoKZe0NTyDdFhKIDWfOK8Zi64QUPXJt0BrxwrzWTj444yejNlOH9497URVxflqVTLAay9GYXhLxnM4W6tvPzD3MfpTsi8hWxR2qVCa7L4WLzIHB4xs45RMVFa9/gW8CydIxiJDye0ON2frJZt9b8c1RasUJIfrEu6WKUzZcyujJL
 oVY3rXdv
 Gr/VIYj/wTQccBsVRBPnHlX3NtYnSt5ujZfrw4ZiwWCIBvrapptPpSeyOaMUxG3fo81bVUTToPk/xmhLuDcKvA0fIe2lFdRj+DnWL8i6MuZanagNDb1ioZhdZ1QzfGbKM5bMhuzjDgZrLy868OnmMKnw/YsDQyuH6r6x6YJyTOZ7TW7DzleaeG5SfBTSfXJ29WwVfg23Rez/MQCYMwgrr528+QrtBvGaS++gYpQLX0BE/qnyL0+7k8XO4pCLS8hbLg047zOdALatG+BYUvQAJE+c1DqgwqQynNV2aGr8rmIZozapjnshKeiKIbCMNhuHJO9Bc76zOY3LO7/UAnTGDTgq7MxvSNJOIBcP0DJmwCA2Y9cvW8WGTJ/Az22h7usyqTG+RC6tfZPvsf25av/lAnIIISeRr6mOlaDhjJmGUG7ZuZ20/7HSCPMwEzDf7R3UVBdmlLcSd7CUkLwg/+KRwIvLsPkF1nc9wFKS457z6S7MAuUATxuVEhWqvP1NCuFDiOqvjRGV5e2C9YTi8VXzPwPesMsS5J403QqLmmBetn5lHswv1RZfvUPLtbV91TmOWr8YSf8ETB+FZGaQATt991mPWlHL/Mi35f120h0bSBHydWqSLFZxX6vQCIwPrpLeA1s8k0itL48at2Rva0SlVHKTKqi6ZlUBrIj2T
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
- [Medium] selftests/proc: getdents test faults in dir_emit_dots() before e=
ntry lookup
--

commit fc0ab3f791b6ab04b43d13e015f97882092d54fc
Author: Christian Brauner <brauner@kernel.org>

selftests/proc: check that faulting sysctl accesses don't hold up removal

This commit adds a proc selftest using userfaultfd and a tun device in a new
network namespace to verify that page faults during read(), write(), and
getdents64() on /proc/sys do not block sysctl table unregistration.

> diff --git a/tools/testing/selftests/proc/proc-remove-slow-sysctl.c b/too=
ls/testing/selftests/proc/proc-remove-slow-sysctl.c
> new file mode 100644
> index 0000000000000..e1b1fd19a07ab
> --- /dev/null
> +++ b/tools/testing/selftests/proc/proc-remove-slow-sysctl.c
> @@ -0,0 +1,213 @@

[ ... ]

> +TEST_F(proc_sys_slow, getdents)
> +{
> +	struct worker w =3D {
> +		.op	=3D SYSCTL_GETDENTS,
> +		.len	=3D BUF_PAGES * self->psz,
> +	};
> +
> +	w.fd =3D open(CONF_PATH, O_RDONLY | O_DIRECTORY | O_CLOEXEC);
> +	ASSERT_GE(w.fd, 0);
> +	stall_and_remove(_metadata, self, &w);
> +
> +	/* What was looked up before the removal still arrives, then nothing. */
> +	EXPECT_GT(w.ret, 0);

[Severity: Medium]
Does TEST_F(proc_sys_slow, getdents) in
tools/testing/selftests/proc/proc-remove-slow-sysctl.c actually fault on a
looked-up sysctl entry, or does it fault inside dir_emit_dots() before any
entry is looked up?

In FIXTURE_SETUP(proc_sys_slow), only the first page of self->buf is
registered with userfaultfd. When TEST_F(proc_sys_slow, getdents) opens
CONF_PATH, w.fd starts at file position 0 and is passed directly to
stall_and_remove() -> work_thread() -> getdents64().

In fs/proc/proc_sysctl.c:proc_sys_readdir(), dir_emit_dots() runs before
sysctl_dir_next():

fs/proc/proc_sysctl.c:proc_sys_readdir() {
	...
	if (!dir_emit_dots(file, ctx))
		return 0;

	if (cursor && cursor->pos =3D=3D ctx->pos) {
		err =3D sysctl_dir_next(ctl_dir, &d, cursor->name, cursor->len);
	} else {
		loff_t pos =3D 2;

		err =3D sysctl_dir_next(ctl_dir, &d, NULL, 0);
	...
}

Because ctx->pos is 0, dir_emit_dots() writes "." at the start of self->buf
and triggers the single userfaultfd page fault before sysctl_dir_next() is
called and while d.head is still NULL.

While work_thread() is sleeping in dir_emit_dots(), stall_and_remove() clos=
es
self->tun (which unregisters CONF_PATH and marks ctl_dir->header as
unregistering) and resolves the fault on the first page with UFFDIO_ZEROPAG=
E.
When work_thread() resumes, dir_emit_dots() finishes emitting "." and "..",
sysctl_dir_next() immediately returns -ENOENT, and getdents64() returns the
48 bytes from the dot entries without ever entering the entry-emission loop.

Should TEST_F(proc_sys_slow, getdents) advance w.fd past "." and ".." first
(for example with lseek(w.fd, 2, SEEK_SET)) before calling stall_and_remove=
()
so the fault occurs in dir_emit() after sysctl_dir_next() and
proc_sys_fill_dirent() have looked up an entry?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-bugfixes-v1-0-59422ed3e465@kernel.org?part=3D36

