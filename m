Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C001B606A32D
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 10:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ozu7z0Kj
Received: by kanga.kvack.org (Postfix)
	id AE81B6B00EF; Sat, 14 Nov 2026 05:38:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A71976B05B0; Sat, 14 Nov 2026 05:38:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93A476B05B1; Sat, 14 Nov 2026 05:38:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6DD396B00EF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 05:38:49 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 451BBA7BC5
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 10:38:47 +0000 (UTC)
X-FDA: 85433376294.14.C84554C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id AAC7C20003
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 10:38:45 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ozu7z0Kj;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794652725;
	b=4BtEU6HmY0dc4MOV9ZugCCHidiN5InA2PMfys9RhtNHJWn1CLf+nbKac9w+TQEeXC88g0R
	tVLK4mc90F+R+Zb/o/4ypE6ksGVUm1IuTURPycVbo35zpECvGA1+GLctek7SN85g3i9mWI
	Y70SmppwejXsf5SK0n+Zdo8xNPZT92c=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ozu7z0Kj;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794652725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f0g6P6hsNAkBmmk1dhVL/yqmLVxvhNEJRF73P8Hffz8=;
	b=xgpW6a9fCBfcbomLYZdwL01PfF+Ymv548rs1tj/IVXT0TWoZgPQqgUCFqpCADea/lNZZXQ
	7aBeOfj/ccs8BlnNtsilWRjOm78AsImEyw1V/zmdUqutAjI1SittCj6P3LXno/uDXGdL5n
	kav0aPnAkkwRVBPn228LG6ERI2zbRx0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 967DE413E2;
	Sat, 14 Nov 2026 10:38:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE541F000C4;
	Sat, 14 Nov 2026 10:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794652724;
	bh=f0g6P6hsNAkBmmk1dhVL/yqmLVxvhNEJRF73P8Hffz8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ozu7z0Kj1tHIOD24bkiz6twDQ59H2LG047bnoA597yeAQD+7loV9AVNQq6/EfNxmA
	 RAV43n2Xp3rFswhwCvrdVPjCv2twIaBECTwXwjSyPBKOEecSJccYi16iPUffdcy+kX
	 2KsSYHa0TM5q3kVm9Et0sKjXOYpfJER4fjfggVZYik+Tlk8iLg4VYcTfwPq6hSWTb+
	 FqNtagBKrLecsr9nZyvU/RGWRSqwrFdabGVO12uSaA2rrQgzv6ROpsZEsD9jdN00pG
	 9AVp7r2bVcIF0aGX9qNUD3D/9g7VuGmG+jesekdRYeqNRWWlH0zjJp4ZwQJyQCg3y0
	 VLaLdAkJXNuOg==
Date: Sat, 14 Nov 2026 11:38:35 +0100
From: Christian Brauner <brauner@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>, 
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, driver-core@lists.linux.dev, linux-mm@kvack.org, 
	bpf@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, netdev@vger.kernel.org, 
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, 
	ocfs2-devel@lists.linux.dev, linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-usb@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, 
	linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH RFC 01/41] loop: refuse backing files that aren't open
 for reading
Message-ID: <20261114-erfrieren-vorher-taktieren-ef10b08e210f@brauner>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
 <20261110-work-loop-pseudo-v1-1-4c998976c6c7@kernel.org>
 <20261111145555.GA9996@lst.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261111145555.GA9996@lst.de>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AAC7C20003
X-Stat-Signature: 8n1pn3s89ozp4ekhqdgtjm56pjdb9963
X-Rspam-User: 
X-HE-Tag: 1794652725-793751
X-HE-Meta: U2FsdGVkX1+6jkUZL2ipE6bd1mOo7cS+e6Ynfi3aCwFlacjRgt2i3hxF7QJORP2ALpYMqPWLuEp+rg1blN9CtDoqH+oVH/zRb37RXfiPvuhBMVW+svPC6SherHmb5UJnXOd7GeBvN5TjK4GxjqsrzKnmljaEQBue/rRPlF90oS5psOqXzssmluzU2jQxPwG0pux9Z6TXXgjjWjD2GttLx4KclSeykKqTW+2TY51FtW297OyWf/MSsNt0iJC6USoXzpwMyVjxtm75ARZ9WT6qlSyJ/dHyXTblCxq2MCBiIxxq8tmp8LO3P/dRJDZ4Y+UsfXxtoXLlPo01bupFWiGYv7V4r9+P9CrKd7nvul7XAxU6wdupyltSb1vLxGN8t77GB5Pst2OLlewNcZN8cNnPx/oiPeZ8kRYLqX18baikxvMXH6SIwMWFRt6rrBZDIcYFkTQ7qByI5ZoYOHrDvN2DyqM330raZfps3wqiONsPXxVDmCek77NzMrMGdaO2aybRrxianK4sMwFNq5bSHVk+kaS6NQluy4ClK0O9tn9/fgEVIWo7Rl6WhRQBPw1RUeaV5Le6y1MG3HycNYhghxjc4eqAsfrKeaxvvxlA6YcwTLzwdLAYJns8nFzGl3hehlLv4NO2+p2dCLemhNCoxgRqbQwldT9rDKL1MjAOxaoPmIpCU+NjDGfL6XIJrOmvL2GSkm4MAigmaUrNd4Dlh+3px16tZVs3YEPrav5rJmRMW8T4H6KF3ohe/+z98KZ9d980+E2O/LAsnEQrknI4YJ50VyIXquC/DwBqcCwsWNx+GNZYx9d/rGkKMLhsCjbOmS5T0fovHH3noTgrhRDojtVvjBG/TRACdOufFP7HrT9WmuqCwYLTPOfvmiI0dRdisZ1cJqkaie3BszgUANfQVbuxrlRgeEvIM7v4WOnZ1BWH0LWZ23Y5wbSULEiy5XeidRM5DAqNOfQsat8erIvEwjh
 KQKBh2r/
 7BA7j9OwKFyfb4KA5JQr92Xlob44cy1WLdu8cKkM+q8QD85a7TDJhxl+/AwBlLCtWCd2wWEqe4g8n5WI8NIpl3v2uBi7vx4Ena6iziQFrbXceUmV/IkSltBCUhJqOkLrcmevpYMQhMFH3Gv06LQxSeQl/lH+HGAy0xATGRWhlqleoH1hHN6L8i2pwcM0BNvNm9aaJehOFJTzx//dLOUkjzghvhqgC7gobCM/RMEWMsXe2Fgy/G/fZR1QdooK4ER7c5VeiSJT8p3522oIlCPCjALqn9XDXZrjqO9L5de5nxlaFpBo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 03:55:55PM +0100, Christoph Hellwig wrote:
> But i wonder if we want a thin wrapper around ->read_iter/_write_iter
> to do this check so that it matches the normal read/write path?

Yes, I had thought about that as well. We could use
vfs_iocb_iter_{read,write}() for that but it's not thin at all and
brings in the LSM into these codepaths where they shouldn't meddle.

So maybe as a follow-up series with a new
vfs_iocb_iter_{read,write}_raw() or whatever. Feel free to make a
suggestion.

