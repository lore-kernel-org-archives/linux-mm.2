Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AAB2606EA7E
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 19:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EbrLF/GI
Received: by kanga.kvack.org (Postfix)
	id 6AC606B05CE; Thu,  5 Nov 2026 14:36:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 683396B05CF; Thu,  5 Nov 2026 14:36:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54B3D6B05D0; Thu,  5 Nov 2026 14:36:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 257A56B05CE
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:36:05 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AB66040B03
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:36:04 +0000 (UTC)
X-FDA: 85402071048.20.001A841
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0E32B1A0002
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:36:02 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="EbrLF/GI";
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793907363;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u3XH2HUDxRINO6oY1nDOxszi+5d2U3ZN+LfBIkkJykc=;
	b=nmk2rxSw643yylUSgDpDiBJTmQ3+COHtjhP1CjQdOyRuJULSgunSuXFLIMJxvix7DJwH1q
	ayIcybbZhr1zyyYlRaR/6MJ/gRw1YugBy4dGUCjBY9uPrRQfeY1Jlh+cz0kQQ0chu/kZZZ
	CkDRBsSDXWO0Fm6QPuJm8pNrivyyCQc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793907363;
	b=qpZhauP9Y05g6CoCgl0z9VSw7yjuDRb19LD1Q4fr6ok+23tYp9tZ/sAw33LApDQ8BOo8yy
	YR69Rr46CZ+0SPtfhpgrBL5kUN2zLNFlexsDJjQY4278BpPfHljcV/5MooPWaDVJH9BwEm
	7HywSAawt+bGJnuczUiXLNyp0k9w+5E=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="EbrLF/GI";
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 64D2C4190A;
	Thu,  5 Nov 2026 19:36:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CE711F0089E;
	Thu,  5 Nov 2026 19:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907362;
	bh=u3XH2HUDxRINO6oY1nDOxszi+5d2U3ZN+LfBIkkJykc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EbrLF/GI9zveLxnzZ8uxZ7LXZBqUJdqjZ/hKoCeJ+z1yLwXWHsb2qxVPJQ8BLsPOE
	 K/NM8kOHLdOX413B6qu4BxuoBVdDuZNIDosQo3lfsNG21BWE641KvfyeVALDLSFtDe
	 ESPTTOTW65bJL496sXvpAbFlSD7S31p5rbp2uYOnMbdF46/hUBlGYvOTz/9riUzRjK
	 p3f2B9HZLlYz+fkIAktgBcJKJZDL0Yykv/zheSRbg1STyFrvMiDZro6fwOyZTiGupJ
	 cJfQ/mrW1aSt0fhZWKbtOyHFZ50PXoXdNZ2u1li9/TrUnZma8Zf3atQs17wXbvbwaB
	 b0ELZzT+OQZ5w==
Message-ID: <sashiko-outbox-199952@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 22/23] proc: own the wait queue of an entry
 with a ->proc_poll()
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
In-Reply-To: <20261104-work-procfs-core-v2-22-76ace653a773@kernel.org>
References: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
 <20261104-work-procfs-core-v2-22-76ace653a773@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:35:59 +0000
X-Stat-Signature: qokehidibu7axf6ib5t36hctgqziw5s5
X-Rspamd-Queue-Id: 0E32B1A0002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793907362-349207
X-HE-Meta: U2FsdGVkX1/hgfSxqakraOc3YVdq4/CBlesDC9yNuVE2TFGCvFplEmdTJUzTaUayOT5nYU+0/Wx8nWm2QxHMkWMgTqWncibAgdoT5xfNQHSnMD9IQj4uFI/njOWfwGAkIHLfJZ2tZceDTw1eM4nbck5s2u0XsirKlXBoj/l9nylBdahK2Q0AynG+VSGti+5b09QPTSvO9vz9fYGLeuImljFk4UufYUsa75ppER3ddJMPG1GvZnlvK8aduQlTuNg22ZKpX2OJyBt3YB+f6LMbi9GikDaP+K836kTQtwocnleXMCTUYdsbZlXq4I2tfolewFewQ7ohQtyuA/0XTPjcgOUMO1K0wqhg40Y+YTQGRdl/6VHRH3foAvwrrZ7p+lL6U8QZbJQZpFPdkvfOHmxa/55tzExRH8FrwjWQVA7hu5BMqbBCAP3lQj8hs+/UQBBRLErI46TojTvCaUXrJZ9+WDFVQ0bdOLc93jbvTqIL54l7xDR4mR5UptX2smmORZA7Tw1jFahOEqrcm6ABjAxJypgmMKAb4ekTA9W07oKzufUZJA4iaN5CuYBcT23WpKazzMBULTF+VGiExxckAb1WnAaucz9XX3+MMncQkSwwxt6vHDM1ZNAVBDQFCrOVKamp1rdd8Z8mYM1DO5tilinEzqLp+t7kPZcYWGMzHy1wKgyC2N2AYmto6wrxk484+gdnc91RHaoxxhcfj46g36dsmkw+2pBqzOh6eu/BT29idIKs6Ul0ak+xA2OSAmFFgos3NBPd97FYm4ATi4eDrNXhaUyoiCFhnfxLywXNN9sBzlNSBf0CXwObDe0fEgesn4wSkCaA/yhU3Kxk9bdJ8FNM/+pv79snG29tD9KX0jKZTt14/RHnPokb31vp58M+y7l+09kD51Sa9GDYcq2q1H3TrA5QWlcj97koSkoR9ahhlnKusXGYnGKrF2M/9BR38xY0rF74hZz6czxNuy57Zm4
 Wy15hdiG
 0gxYjH/MwDpgzS/jrwu8SLE9HicdaM76FxMwHwlcbcwU32owttyW33ESip1w7GaHCD7KRehmSCY39ABAwaZlMBBL9tST9HL1PkrvgAnipAkAgoLRRLJsnQYlaVoZZayLibb3WiGWPHZ4rHHVInyZFUKXszi0wqKcDd06Xgi9q19yK/58F2WLhB+1qDog5MejEi+U/tDVyMokQhlN8c0Ht4kn7vauYe+WKFzLbXcgEEekcYH/484QyEyN0erQ4kVal1qmp8zzxvRVdiWpf2EVFCVASooDLmaV+foET4/uUh6YLPBqwUU09nZsMZRvFU4h4Tsg1/2PLl6Kv0XOwytaPIChxGJJVLFJTs0CKZP4FybBnivlItFQYjgjDXm3slxI3AI2udxwbS+c5W+zgCZsNiDNqxZNZCIs+PRjabLqd20ftVxSk/LkirY34cXPjK6U8Vd5CaoHCSFBHPibw3sSHU4p1e1un7q2uyEG8k91rDSZxDIo1nm7123Rngrrf6Jke90pwlr4zgQPu16RB15er/kD0vLLaZF7aC0wWRDkQa9sUWOEbvuN71fVOlQuBbH+o00DX00kDalS80m5ZKMAHUnrnws4ik9C9H5aVBEYxusoYL2yr9id1M7rx3+TvGmf/Wr//zB3hDAfzNuU/YbEnw64OzGvzf+XCaWaMSc//zyU0p/z0a6J0ez2QrYoXiGcYz057jU8a45IVdMMg/UbgXq1hCMgZHQUHcbsTC3INoZapZ38=
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
- [Medium] proc: dual poll_wait() calls in proc_reg_poll() break AIO poll
--

commit 443c1e3f3b75bcf766632cccb5651e0034423048
Author: Christian Brauner <brauner@kernel.org>

proc: own the wait queue of an entry with a ->proc_poll()

This commit gives procfs entries that implement ->proc_poll() a procfs-owned
wait queue in struct pde_open_node and adds proc_poll_notify() to wake poll=
ers
on that queue. proc_reg_poll() calls poll_wait() on the procfs wait queue
before invoking the entry's ->proc_poll() callback with the same poll_table.

> diff --git a/fs/proc/inode.c b/fs/proc/inode.c
> index 59de4681d8452..ab30a58879d51 100644
> --- a/fs/proc/inode.c
> +++ b/fs/proc/inode.c
[ ... ]
> @@ -555,26 +561,46 @@ static ssize_t proc_reg_write(struct file *file, co=
nst char __user *buf, size_t
>  	return rv;
>  }
> =20
> -static __poll_t pde_poll(struct proc_dir_entry *pde, struct file *file, =
struct poll_table_struct *pts)
> -{
> -	const auto poll =3D pde->proc_ops->proc_poll;
> -	if (poll)
> -		return poll(file, pts);
> -	return DEFAULT_POLLMASK;
> -}
> -
> +/*
> + * The pollers of an entry sleep on a wait queue procfs owns, which is t=
here
> + * for as long as the entry's inode is, however the entry's owner goes a=
way.
> + * The owner wakes them through proc_poll_notify(), and procfs does when=
 the
> + * entry is removed: a poll of a removed entry reports EPOLLERR | EPOLLP=
RI,
> + * like kernfs_fop_poll().
> + */
>  static __poll_t proc_reg_poll(struct file *file, struct poll_table_struc=
t *pts)
>  {
>  	struct proc_dir_entry *pde =3D PDE(file_inode(file));
>  	__poll_t rv;
> =20
> -	if (!pde_pin(pde))
> +	if (!pde_has_proc_poll(pde))
>  		return DEFAULT_POLLMASK;
> -	rv =3D pde_poll(pde, file, pts);
> +	poll_wait(file, &pde->open->poll, pts);
> +	if (!pde_pin(pde))
> +		return DEFAULT_POLLMASK | EPOLLERR | EPOLLPRI;
> +	rv =3D pde->proc_ops->proc_poll(file, pts);

[Severity: Medium]
Does calling poll_wait() on pde->open->poll in proc_reg_poll() before passi=
ng
pts to pde->proc_ops->proc_poll() break Linux AIO polling (IOCB_CMD_POLL via
io_submit()) for unconverted procfs entries?

While ->proc_poll() implementations still receive pts and call poll_wait() =
on
their own wait queues, vfs_poll() -> proc_reg_poll() ends up calling
poll_wait() twice on the same poll_table_struct: first on &pde->open->poll =
and
then on the subsystem's wait queue inside ->proc_poll().

When userspace submits an IOCB_CMD_POLL request via io_submit() on a pollab=
le
procfs file (such as /proc/pressure/*, /proc/mdstat, /proc/swaps, or
/proc/kmsg), aio_poll() sets apt.pt._qproc =3D aio_poll_queue_proc. The fir=
st
poll_wait() queues the request on &pde->open->poll and sets pt->queued =3D =
true,
and the second poll_wait() inside ->proc_poll() hits the single-waitqueue
check in fs/aio.c:aio_poll_queue_proc():

	/* multiple wait queues per file are not supported */
	if (unlikely(pt->queued)) {
		pt->error =3D -EINVAL;
		return;
	}

If the polled event is not immediately ready, aio_poll() sees apt.error =3D=
=3D
-EINVAL, removes the wait entry from &pde->open->poll, and fails the
io_submit() request with -EINVAL.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-core-v2-0-76ace653a773@kernel.org?part=3D22

