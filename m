Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BD4E606D59C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IKmf+e1g
Received: by kanga.kvack.org (Postfix)
	id B44B06B05B2; Tue, 10 Nov 2026 04:33:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF4E46B05C1; Tue, 10 Nov 2026 04:33:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E6646B05C2; Tue, 10 Nov 2026 04:33:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7A8C16B05B2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:33:41 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 05D26A0363
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:33:41 +0000 (UTC)
X-FDA: 85418697042.05.2F5830B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6934240006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:33:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IKmf+e1g;
	spf=pass (imf17.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794303219;
	b=hcsr9IpT+e0YFIUeP+YRMQO2YwZDkdR2rLefReLDdqY04SR0gPb5o1a6VZutz4Nqs9oaIE
	+LwlpkEez7t/s2INWIMaEhjgC7hcInjxUqJMWprQi/m/Y7EqpklE8DOmrrYEEu5gZM+Lob
	Ke9Hv1Gr3pP6bzonRUy7Kw+0Ib1OTnE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IKmf+e1g;
	spf=pass (imf17.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794303219;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bww7nw5bSwEPBt04rDt0/bI4su6VmPuV17HzMgP1WVA=;
	b=3WtdEAcWLbhuCJpJkQ1n048qMzAkXWqW4nCysDukr+HIx0iJ2646mJW96luql2wbMR8a1J
	lbNXJyHGd+q/9qHzDzqRgZd0r5Zg3QYKId1mRVdZDtxk7z1Gxf9grnTxi8eFUgm872prDY
	600TR5DyOAnB+TPutvsZvwxW75xG/O0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8FB194487E;
	Tue, 10 Nov 2026 09:33:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70C081F0089F;
	Tue, 10 Nov 2026 09:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794303218;
	bh=bww7nw5bSwEPBt04rDt0/bI4su6VmPuV17HzMgP1WVA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IKmf+e1gFKkj418fSwF/WvpYdm5kRAazs7jwnCLr8UBX0mWUP8DQEFBBBEZlbkXZ1
	 XI4prTk7TROigxS8fxK3H7nyiNmObFLtBmkCA0ke0HXW7pt9dEt/aaSRLKtzC4egpf
	 OEHRA7RgND8FIgqLmipqQVPz2GNvvRJE2PgE7T/NOFf640AwOp8vZiaRQth92bBap0
	 HKEfy9pnSL5/wTdbiAfkWabIrGIRQRAr+uE+2HXR6t6FbfBJFofcbxlw42H4vOVzXk
	 w77kmjm4jAJg1fdzTMQ0RDczx8gBsj6Uaq5LnRuUkl/WYcX9JduP6Rs8JOjO15ilQh
	 USFa7wOu4MpQw==
Message-ID: <sashiko-outbox-206765@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 37/41] target: fileio: refuse files on pseudo
 filesystems as backing files
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Jann Horn" <jannh@google.com>, "Chris Mason" <mason@kernel.org>, "Josef
 Bacik" <josef@toxicpanda.com>, "Christoph Hellwig" <hch@lst.de>, linux-nvme@lists.infradead.org, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Jan Kara" <jack@suse.cz>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@vger.kernel.org, apparmor@lists.ubuntu.com, linux-efi@vger.kernel.org, linux-s390@vger.kernel.org, linux-usb@vger.kernel.org, "Amir
 Goldstein" <amir73il@gmail.com>, "Chuck Lever" <cel@kernel.org>, "Jeff
 Layton" <jlayton@kernel.org>, "Anna Schumaker" <anna@kernel.org>, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Mark
 Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261110-work-loop-pseudo-v1-37-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
 <20261110-work-loop-pseudo-v1-37-4c998976c6c7@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 09:33:35 +0000
X-Stat-Signature: 3dkudjup65sse5a91j74p44ogmzr9uno
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6934240006
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1794303219-250217
X-HE-Meta: U2FsdGVkX1+lv2KvG5D6cnPIIa+O+QPB2CU4zT3+XiVeb7Nl1b0vUWEP9APIRc/eihTKiwfxmbjKxv+5e+eRdaqCLZZVNnZVUrphHjtlqSNIR8+cin3vI06gShptnoTZjaxVqPgRUZZLl9UErvuNny4U/FacbRsIwV04LZv1QctbY/GfHkIIe2PhsZQjpnL2WSh/VtNW3O13GXHmoVrh0AcmTBJGvg7QmDO0eWr9XuFPavG2sI7tDe43KQMrcAxmH+nPvPkUjP5RMpCBlHqTkbbCswWTTaGrXFQDgo4MqiFzhT+v8ETxw5GBMNxUyZ0D5i88XCJCMsq18/sFQ1PVTsqrPtCr6dzu74ThNUD8Ph86ErZgaO31qjo78rIdfwhctQAUvywi39rxEXhCevcB/+Qpt2qxL8n8V5yRnah6hTMqGJ6oG2cEkyJ8Z4UfcRkN7PnmfalWE6bTbXx84ttFbfgQLxW+fEC8bNupMAdgePPV6IXEmhABfv0Y4AHV88fNb3WwY+lx/hSx/jPL2XW3NmAced19+lPiUutxFk0RGD/a1iNMvLfXRH5jVYQhGTE9bZX9JUlY35FzOaOLVNlZVpHX1aDotLWWu/KH+iyWFnX/RLptnqsrlUN4htE9gHolhrPj0zc6EvF20FuJOl7peRd9PGY5SwuXPaQ2MN07CQE6rp0Diw96VKQt+xSxNHEoSGIikQ2t0a6j14qZQW8KniptskNkNWaTNaw1rsy/D5gyoPDZfI+rTmEAoXf6O/nPi6lrcpS02GFW6fJ6i81VXTcVXyQHNcAIIJ/nfRGgw8c3LYuYuhVkMCU9OvwICWn46+Ml1f/97HCogtCqzGTlL74ANimQzXxoVsa9jJxOkcShfjp6U2oVn4tNAWqpi+ptbTbloUJK5Vg5UYfJODdQYD/T4HtLEBPPMzzJosRFN8nBXruIcZdfLl+qq4seCcbU8vOylGiWcFeTcc+ja3S
 94AGKeKh
 mPOrWUafgHEDDncCSvg4ILpO4k1f/4yirn8Dhndhj3VHVGEQB3QtJnKQsh834m0sQKlkX0aqJEOjA2m+laB8zdigN6nN0Fbn26JYD67hr4+bub0Tb4dFvwC4Ix6RHIooH37ZJqRVumTliySdpfa5ql+cG+N+j/l5omij5K0svnMhepW2gC07zqw9pAcCJZHr8mB6mnidQlhivt9LnDCir0DuxlAJxUJxv8sjVhMUeGzwvEWZqsX9L1+kZNV045RnzR+IJ8igm3LRWVnUh/nfGzgEaUNPFqgNGti/o4irsedOj2cx5vRfgUJXBdEjmh3b3HqLmYgx+/gi6dzTjACCops3zkgdQdlT7l/+IIHObUGiOEz/KhgMo/c8e0ngF14utXljxPW3sFeF9YTXBt6vW1OjwdVozG7IeUpryH8e+88iWHnAeTKhD6rvmH8TswUCVDgKANxC33KIzTRaj06yeQ5VLwCPapGBsAo4dvltuLEkyRvp1joWdgp3RDIrqRR+TNhO0Wtzcq6B1i8EY+Dszt8gfah0gzZhHCchybYsmbT13IXcF9ciejjz2DvivJ9+D3KEml7bzULsMmpNYemYhE9kN9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] target: fileio: missing file_is_pseudo() check in
  fd_init_prot()
--

commit 4e15db58376b542897dd4203d7acdfd99df1aec4
Author: Christian Brauner <brauner@kernel.org>

target: fileio: refuse files on pseudo filesystems as backing files

This commit rejects files on pseudo filesystems in fd_configure_device() so
that SCSI initiators cannot read or write kernel interfaces such as procfs
or sysfs with kernel credentials.

> diff --git a/drivers/target/target_core_file.c b/drivers/target/target_co=
re_file.c
> index a5391e57e9aa5..7a3cf63dc979b 100644
> --- a/drivers/target/target_core_file.c
> +++ b/drivers/target/target_core_file.c
> @@ -152,6 +152,13 @@ static int fd_configure_device(struct se_device *dev)
>  		goto fail;
>  	}
> =20
> +	if (file_is_pseudo(file)) {
> +		pr_err("FILEIO: %s is on a pseudo filesystem\n",
> +		       fd_dev->fd_dev_name);
> +		ret =3D -EINVAL;
> +		goto fail;
> +	}

[Severity: Medium]
Should fd_init_prot() also check file_is_pseudo() (and ->read_iter /
->write_iter) when opening fd_dev->fd_prot_file?

When DIF protection is enabled via pi_prot_type_store(), fd_init_prot()
opens "%s.protection" by pathname without these checks.  If that path is a
symlink or bind mount to a procfs or sysfs file, fd_execute_rw_buffered() ->
fd_do_rw() will still read and write it with kernel worker credentials.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110-work-loop-=
pseudo-v1-0-4c998976c6c7@kernel.org?part=3D37

