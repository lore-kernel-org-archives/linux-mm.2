Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52725606EE90
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 15:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VEcq0ggu
Received: by kanga.kvack.org (Postfix)
	id 781226B05B9; Tue,  3 Nov 2026 10:01:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 758FD6B05D0; Tue,  3 Nov 2026 10:01:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 696686B05D1; Tue,  3 Nov 2026 10:01:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4607B6B05B9
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:01:12 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C509CC0460
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:01:11 +0000 (UTC)
X-FDA: 85394120742.03.68E7FCE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id D0E12100012
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:01:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VEcq0ggu;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793718069;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BEajqQ35phGWaUcr3y1eTDvwsu33+Nn0Y7Ck4F/8MEY=;
	b=7+4McUVNEvvuhhriVQ/F698Dm4yOudhMHbq5uqvPFZWuJxoGlBxNtkA2ynnk6KT6Pns3+n
	EtMbGDIc0SfLwzMb4KBrZT23NSdVSTuf8Z2W4b7rm2qB3w9VZAtmllOdyuM6nJ50oHRxTb
	/ytEW0PCsvwUPfz9BpJrWY6j035kYrI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793718069;
	b=gOC7oJxH9SWjUjJqWsdDZXJfKPoybqx41do5BxtifxaKfynmbHH5Py1AWJ9c2mLlBNGm+H
	un5T8hzWvCbr2dlIg35mbeDmzSJgPX2feEPJO1mvMWGSSLsjl0esBtyfT7cYml6nZWpEDm
	zxpPDio72WS6nBcrrpPcwBzr3mq9y78=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VEcq0ggu;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3FCE2609FA;
	Tue,  3 Nov 2026 15:01:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFD2F1F000C1;
	Tue,  3 Nov 2026 15:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793718068;
	bh=BEajqQ35phGWaUcr3y1eTDvwsu33+Nn0Y7Ck4F/8MEY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VEcq0gguO6/NoWa+wL6fwqCLqkldJUUFWXaU48FgopqIQWVInov4USQPNMlWECfku
	 tjmmYgoSxJFwLb8AMyTRkOEe9RIAgKCTxUsnF6zQuC56KDIfRvxTZM6B4OGZ+0RxLb
	 mh81fLroJS4nyQyOkcaBszjAOxkYEOtX3GkPZMu84uutLjUi79KxQ0Ta6LswLb4aME
	 +9R/WJkvVhkvygnNcEPN9DxaCT6J3JtUHgSP8vKYwTs6rh6No+CNqGd39rP3s8vdpa
	 CSPispydKapyfU9yanW1YMZNTbAP3BOy5UszvDaukMX2hst4qdOs00Vyn/j4PbSImA
	 6uri+styQIxoQ==
Message-ID: <sashiko-outbox-195531@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 04/16] proc: let procfs own the seq_file of seq_file
 entries
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
In-Reply-To: <20261102-work-procfs-core-v1-4-75df35e4f8b8@kernel.org>
References: <20261102-work-procfs-core-v1-0-75df35e4f8b8@kernel.org>
 <20261102-work-procfs-core-v1-4-75df35e4f8b8@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 15:01:06 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: dertopnzespnzwb4dexgfgy36giaghyp
X-Rspamd-Queue-Id: D0E12100012
X-Rspam-User: 
X-HE-Tag: 1793718069-292473
X-HE-Meta: U2FsdGVkX1/FtTOkgVYwlQvfJfzrj4q1rsvqudnQc9bIEnpOnLY/oDKyXV3qGoLmtr3SoE2nKvtgZi5sZdDJm1U4zyvoDks45K5wuP8cwSU6kmNbSsW61bpalhexIFP5ZhoG65ozs1X0kbawQ6RXm13TQY0QMx7nNIBEL1fvgJ5DsAPDcjkpBAkFKSZvPflLbmCfiDEwSCzA/pyLSf+ADfupvreLBKeSsn2UC3ViAf13tuftWUtoDFgA/jIyhgoeD1F2YG+xlqC+RalkdM6ACc2VcsGda9bd6QSzDKZBz8f9KGJIsOmXAU4ULBMXlEa6XlVeYQqe5iE8xsp2zM4LqoJoAFvgA03fe0k74dHSmC4tsWh53wHHS81J3svggHX5dXnTcgF/zKxpKCG8lTAzHGUGwihbfJd8mq/qkZsOfO36VpPeqvmFk7chwRDvktafeJxZWx9Nh9/QMjD+4WE4PkL8IL44rnMNGmx9gehM2jc0JkltNamGtBgGAl0TmWvIFnEvm8PvLK8P4i6FxFNgO0ZRj3e8/ysy+ibfkmvPIop7oS35Ty8OQuVEF0+HZWUrTrGCzeGV/0cZLBY7+60dt1fus5hGvB3S1keJde1zhnorVR6knPw1NL5ip/QJ4l5j9/WWVcAwN9kuiRqQDZwPjCnEX8JzxZ391TPYSrRTZGNqU9e1qmOyJsRbwlfiMzAU7ncgUEh9hWxLU+1pQbU/W+dk9ggUU+d4Hw3Wl1e62M3TnCPjEaKr+ytH7GGUnl4vBPAPj9QExtzxmUxfUioAhLCx/0bot46ZQdpgT9w+WWI4uENH7tqumcfDqnr6zyoD5SqALrzyvxaBiXeb1qgajNVN0w/3fTqeY9uWrzzGSfQ8k8V3NNni3wCQXUBrfbE+L0FbNXDmTyI9FKkppZSDEulW2Fxn0XowTKvSCltwU1oIN4WSnAWe3Ce4kyz83/X3HwVwBfQz/6AJgU6DaiF
 OW5jJLWo
 fM6YsRDUgDwpbENCdzWCiYAsdgdHIHEVth9wQrJXPiUmTBUTQ1Nw6WMqyRzfJ6Pz/3EKHh4joD3l+dvcbi1PX5UQW6Cxd7cvY+pjZY/thQjP+4HQx7RIrg7msFcJHAb0oMjmMO9WECfscbc9tys7bmc/RcfBI82BbqWU1czccfh48HWiWKFWqLopIEa4xpfx86y7tn8IHw/pv0jn81Gn8I3mvbr3WrdNUB2V1/rgtR5LkpC5OsL2m9QrTZuQwETJZIiP85pz9XcT+f1wdtKHWpsCMxsphLqJcIRqbkfV2CnuFo7nPpLUVflBSnQW0Bui5uGzjhBb+z4NfmUlwgOKOUR6tYTak0U3eArFdh4FZNJ3q4GNHKDkyB1fmOgnvUquHJD0Q4v/+E6yZRlbFVy19hQlDkDGeO66Nu+MpZFeoevK7DFbI89IhlzG5tcpjKy+jwpyqbryxd66LvForWbt4IVu+iTeNhGjapuFzSY9uxlPqEuzZB5XbP+rAuVZeksBT2l+S3SJ2BZagDNSmG6rDkihunfsheuLoC0vJ27lWqUSFY7BFOhmxrJj3TxfnyfkBkKfZ6qzyv/y36QGwU4c3X+T952InabwO8K6zK0crXFslrwhxFFK+RQjYJyF5Bgb35/ckyxqQEl/rNSMz4DviTN0S7d7gDpzG86WTWsChEBjmkILsoWPJUxQqzW4K4kG0vgxdSMjHERtQ7gQPl4g0OA2/RA==
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
- [High] proc: unpinned dereference of pde->seq_ops->next in pde_seq_next()
--

commit ae41131fe28a1e7fcf9c3b743e2a30697e315fe9
Author: Christian Brauner <brauner@kernel.org>

proc: let procfs own the seq_file of seq_file entries

This commit allows procfs to own the seq_file for seq_file and single-show
entries by wrapping their seq_operations and pinning the proc_dir_entry
only around start, next, show, and stop callbacks rather than across
userspace copies in seq_read_iter().

> diff --git a/fs/proc/inode.c b/fs/proc/inode.c
> index 66a3688757dd7..8425465aae5d7 100644
> --- a/fs/proc/inode.c
> +++ b/fs/proc/inode.c
> @@ -218,6 +218,110 @@ static void pde_unpin(struct proc_dir_entry *pde)
>  		unuse_pde(pde);
>  }
> =20

[ ... ]

> +static void pde_seq_stop_pinned(struct seq_file *m, void *v)
> +{
> +	struct proc_dir_entry *pde =3D seq_pde(m);
> +
> +	if (pde_has_proc_seq_ops(pde))
> +		pde->seq_ops->stop(m, v);
> +	pde_unpin(pde);
> +}
> +
> +static void *pde_seq_start(struct seq_file *m, loff_t *pos)
> +{
> +	struct proc_dir_entry *pde =3D seq_pde(m);
> +	void *v;
> +
> +	if (!pde_pin(pde))
> +		return ERR_PTR(-EIO);
> +	if (!pde_has_proc_seq_ops(pde))
> +		return single_start(m, pos);
> +	v =3D pde->seq_ops->start(m, pos);
> +	if (v =3D=3D ERR_PTR(-EIO))
> +		pde_seq_stop_pinned(m, v);
> +	return v;
> +}
> +
> +static void *pde_seq_next(struct seq_file *m, void *v, loff_t *pos)
> +{
> +	struct proc_dir_entry *pde =3D seq_pde(m);
> +	loff_t old =3D *pos;
> +
> +	if (!pde_has_proc_seq_ops(pde)) {
> +		++*pos;
> +		return NULL;
> +	}
> +	v =3D pde->seq_ops->next(m, v, pos);
> +	if (v =3D=3D ERR_PTR(-EIO))
> +		pde_seq_stop_pinned(m, v);
> +	/* seq_file would blame these seq_operations, blame the entry's */
> +	if (*pos =3D=3D old) {
> +		pr_info_ratelimited("buggy .next function %ps did not update position =
index\n",
> +				    pde->seq_ops->next);
> +		++*pos;
> +	}
> +	return v;
> +}

[Severity: High]
In pde_seq_next(), if pde->seq_ops->next(m, v, pos) returns ERR_PTR(-EIO)
without advancing *pos, pde_seq_stop_pinned(m, v) is called before the
if (*pos =3D=3D old) check.

Since pde_seq_stop_pinned() calls pde_unpin(pde), which decrements
pde->in_use and can complete pde->pde_unload_completion, a concurrent
remove_proc_entry() waiting in proc_entry_rundown() can finish and allow a
module to unload or free the memory backing pde->seq_ops before
pr_info_ratelimited() dereferences pde->seq_ops->next and formats it with
%ps. In addition, pde->seq_ops->stop(m, v) in pde_seq_stop_pinned() will
observe the unincremented *pos value.

Could the if (*pos =3D=3D old) check be moved ahead of the
if (v =3D=3D ERR_PTR(-EIO)) check so that pde->seq_ops->next is only access=
ed
while the entry is still pinned and *pos is updated before ->stop() is
called?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-core-v1-0-75df35e4f8b8@kernel.org?part=3D4

