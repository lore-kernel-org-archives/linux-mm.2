Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D1F0606A326
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 16:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RMKXxT+B
Received: by kanga.kvack.org (Postfix)
	id 275996B05B6; Fri, 30 Oct 2026 12:09:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 200056B05B7; Fri, 30 Oct 2026 12:09:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EFEF6B05B8; Fri, 30 Oct 2026 12:09:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE4606B05B6
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 12:09:52 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3E02214067F
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 16:09:52 +0000 (UTC)
X-FDA: 85379778624.14.AA72ACD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id A7C8C10000C
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 16:09:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RMKXxT+B;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793376590;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Mychch7C97ZshwEL9ueE88CfYbxixMq3ZaDwvqpgks=;
	b=Cnf/boP5Q8ctkdBPV/7sOgf07DQ3QRMFIetM8/rCj8TODo2q1dHqFsKl5xDud9CYBfyx6Z
	Rbcdr3mODZDnjHvA5miZztAzoSBU0MmYpW9yEiDRXvHXPTM6G909matNKJZ3XNrZzQ5a81
	1WeuV47eXtS0D72FntjGhTLwLQd9qRw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RMKXxT+B;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793376590;
	b=g/xBvzp8V9vgVDx2DS9SjHnu5h3RvS8WfXMqcQ30raFZUDhPEgyd8hExjfc4sV9BmYkTGm
	Xx9XN88r6GAfhi98WBleRG/pWVO7mtX4z2LPCXIBNh/eYOQ2zjSkYXYsTUCTk9Awm4EWib
	eVtqMxOEDHn4fxrFcBNg2ze68QEm5DA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BF77B602CA;
	Fri, 30 Oct 2026 16:09:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E68531F0093A;
	Fri, 30 Oct 2026 16:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793376589;
	bh=/Mychch7C97ZshwEL9ueE88CfYbxixMq3ZaDwvqpgks=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RMKXxT+B4dNKzdHHvyHv7QRa6GglJeLRWrTxOikxDwc+SHMb9xEBrc8c1E9TrVOgi
	 mGRCZmfYcTpwdmiI/rDvNEsuRV9zmPLQs9306hQFzPqtnwO1tweYM6fsBJmWTJHCls
	 M60ZKwJvGWH6hZPdqx5fTZg68tpin62dI971F3w0H7Evh06LXtdzT/FuCJKVvucO4h
	 9kTAPmXgB97nIAHmjSnQLmOlFmtmqO4k81UX7OuFWTo/Ti9+6gy8rvCksSOeO5HcOA
	 nP8VIjciRIKaR9iRXnHUu4XmgWL2lJe7XKja19iNq7XFA4nJOjWleVOBosgPGKedBh
	 ZR6+8hCxaOHHQ==
Message-ID: <sashiko-outbox-191221@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 02/34] ecryptfs: fall back to a read-only lower file
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.com>
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, dsterba@suse.cz, tytso@mit.edu, "Mark
 Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-2-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-2-2f44f64f0b66@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 16:09:48 +0000
X-Rspamd-Queue-Id: A7C8C10000C
X-Stat-Signature: kk5iwp1wncahu3nh1cb66jxa1xjef6sd
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793376590-345901
X-HE-Meta: U2FsdGVkX1+9hY5pmadmHKgO1OAtaW6o6qgj2mEAsgm0Xa1AZJ6RlM9xPVflEW5HcLMZXCoZ0EUoUqYdbb5KkRIU1wKzbQ6aGYTrqioUVEltIw7L60t75oJp8tqIE4LdXpd8IWNggjf63Y5PWyVJKUGoskzrvdpO+4a5fqm16zAKWysp3ACH2JNcM4iMcC/FprZSJFoH7T8ZWHIadJv+NE2UqxGh8e0mCQvrokTnhgWXAiZuhXMsIkNhHRF9GnCDDQfbcdRougHc+rZMV85NUEjgRvtZgroI0IZWEYkEMtamGFGOIVuVrgrvOaZ+6RO7T/O7kGST7/2CvfyHON+4vY1krwHoQPv+OsguGhKUysFf5u7mVd48CuWux4KNoSlXemMT9YAk/qbebOn1plkKs77fT8yCRkx45OMa4mehYwUR6gD19mvnWF4MqfUkigiziZ5H367xIt9BwX32qhtOgkZ21ctZgm7cqC6hGzxOViW/LOJT1zwxITjKRyIW5DT2jhwimBaTHN8Mz52TD3tqEOC0VNsnLGZECmvNNEp7185mBSiYCu6R4dkPmaNifXhTznQU96ZLyGP9q89BOy+iwrp5jilihR7qSPafrbfFml8d0B8wnHQW39gEDSsvmaubcsfYJd6hhiEKvGw7xBjN7bonBxlMgzmAtxPar+0sseBEPm0lTYuwZsks7NwzwGTPCG+2WTNFyHzPOuwxrgPbcGPKpyQJ0rtKP89rSb3RMY8oBwyH31BPMly9AoJL0vZy7pS2GhOybsECVwR7xgPqsapQCxWqi+hLHu9qKf1nnUAyTcLi3NSiwq+rSGONrDpjI5gc0rX/AgD9y5QRz23TZQ4yUkxnJE5GQR8cpKqT2IRc5dUrwtPbHRiOpp+n7esj5opP/0PyGRN3PR7c9lDllYAyIeIDzAe8pzkwlDZGeIrPXOsBOIjihjcGk9Tm21swJEVM9Kk9nIw7fDck/MG
 gGWdvBC0
 kb6IdIjnqFwrKm34qwY4E9RDTjHrvOYELOVli98YdMRYZ34yzddzpJfT0y5DRNCWQqqst/Oh0YK5/Pq+U4OnBQ8UbmHGSKqg5plQzr4wwW9WBx0oDfPWAnaAIpJKg65qhC0T2MXRRxzTjwdry9rqhdjuuGaYMp9W8FrGuOWe117dRrGzCt7fSnEHqK9OPSKwE+qOMrUeZxZopYo/KF9KEWdoEK2JbZr620V6yPbKb0c8Wv7yxBjea/QLpIvThRldRXF4PXr8NSr/2E+m9c8Du6P1NONeqUZ68xOXy+1e+Sq0DfkhbJk8JAwBSPo0M4z9tH/NcnDxRO7JC8DHDXuRZ6wdvv1XP1g8Cmh4wHpf9brwuZKBFzrZRO1M0x+ZxJ/7Wk0lLwflpQPiToWbvqumnhfnEs9vQW0zHSmSU/WPAeLpfcxY0LObpM1GXY+7YkZuMboJb1O+ka/pcbVAWV9rrEAw449Py+BNqg0jjgAwjA/Dw4PM+x1gGrU0p0W9u5YA7AXziiOAQErL96JdkGmD7DKxSKgna5Hgfc+1BjXBtyAIyvosZHkSs/HI4geFbf7Jpqg/TiW6smfgymMyl2rHFGi/JRg==
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
- [Medium] ecryptfs: ECRYPTFS_KEY_VALID left set after ecryptfs_initialize_=
file() fails
--

commit f7dbc785a33f0a188b62f1d0ae6c24e5fc32a62c
Author: Christian Brauner <brauner@kernel.org>

ecryptfs: fall back to a read-only lower file

This commit falls back to opening the lower file read-only when opening it
read-write fails with EROFS, and rejects writes to a read-only lower file in
ecryptfs_write_lower() and __ecryptfs_truncate() with EROFS.

> diff --git a/fs/ecryptfs/read_write.c b/fs/ecryptfs/read_write.c
> index b3b451c2b9410..b3956ae50ff66 100644
> --- a/fs/ecryptfs/read_write.c
> +++ b/fs/ecryptfs/read_write.c
> @@ -33,6 +33,9 @@ int ecryptfs_write_lower(struct inode *ecryptfs_inode, =
char *data,
>  	lower_file =3D ecryptfs_inode_to_private(ecryptfs_inode)->lower_file;
>  	if (!lower_file)
>  		return -EIO;
> +	/* ecryptfs_open_lower() may have fallen back to a read-only file. */
> +	if (!(lower_file->f_mode & FMODE_WRITE))
> +		return -EROFS;

[Severity: Medium]
When opening an existing 0-byte lower file with O_RDONLY on a read-only low=
er
mount (or a lower filesystem in an error state) with default mount options,
ecryptfs_open() sets ECRYPTFS_POLICY_APPLIED | ECRYPTFS_ENCRYPTED on
crypt_stat->flags and calls read_or_initialize_metadata().

Because the lower file is empty, ecryptfs_read_metadata() fails and
read_or_initialize_metadata() calls ecryptfs_initialize_file():

fs/ecryptfs/inode.c:ecryptfs_initialize_file() {
	rc =3D ecryptfs_new_file_context(ecryptfs_inode);
	if (rc) {
		...
		goto out;
	}
	rc =3D ecryptfs_get_lower_file(ecryptfs_dentry, ecryptfs_inode);
	...
	rc =3D ecryptfs_write_metadata(ecryptfs_dentry, ecryptfs_inode);
	if (rc)
		printk(KERN_ERR "Error writing headers; rc =3D [%d]\n", rc);
	ecryptfs_put_lower_file(ecryptfs_inode);
out:
	return rc;
}

ecryptfs_new_file_context() sets ECRYPTFS_ENCRYPTED | ECRYPTFS_KEY_VALID in
crypt_stat->flags before ecryptfs_write_metadata() calls
ecryptfs_write_lower() and fails with -EROFS. Neither
ecryptfs_initialize_file() nor read_or_initialize_metadata() clears
ECRYPTFS_KEY_VALID (or ECRYPTFS_POLICY_APPLIED) on failure.

On a second open(O_RDONLY) or ecryptfs_setattr() on the same cached inode,
read_or_initialize_metadata() checks the flags at the start of the function:

fs/ecryptfs/file.c:read_or_initialize_metadata() {
	if (crypt_stat->flags & ECRYPTFS_POLICY_APPLIED &&
	    crypt_stat->flags & ECRYPTFS_KEY_VALID) {
		rc =3D 0;
		goto out;
	}
	...
}

Because both flags remain set from the failed initialization, does the seco=
nd
open short-circuit metadata validation and succeed on the uninitialized emp=
ty
file (and if the lower mount is later remounted read-write, allow writes us=
ing
an in-memory key whose header was never written to disk)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-fs-sb=
_rdonly-v2-0-2f44f64f0b66@kernel.org?part=3D2

