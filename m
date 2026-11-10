Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E44E606A337
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 12:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Q2H6Mk4O;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=29N3zImF;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Q2H6Mk4O;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=29N3zImF
Received: by kanga.kvack.org (Postfix)
	id 3B9416B05C1; Tue, 10 Nov 2026 07:54:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 390406B05C2; Tue, 10 Nov 2026 07:54:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A6716B05C3; Tue, 10 Nov 2026 07:54:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 097A96B05C1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:54:34 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 993E4A82C9
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:54:33 +0000 (UTC)
X-FDA: 85419203226.27.5FC7DAF
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6855040003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:54:31 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Q2H6Mk4O;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=29N3zImF;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Q2H6Mk4O;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=29N3zImF;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794315271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OJ/prrn965jMvrgfLjF+vFRorAc5HNvJ6Vj8L/XmMbo=;
	b=aZviPtIJNZXxY6UFB0SGNds3EW61GySKGqE9dtZFzciRw3xfWNknRfpEPQpKENCPf47h1p
	V3PHD7cxicwdWAbi6/8FcWRnnOFvIDx6yccTG+W5WV0BRCrtgl8b3PPsxNNQX4XxdWBzT6
	jQOM40G46/NSe5uLdNpBmqCeN0Ws+6E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794315271;
	b=Zn7IBiukhPdOIQ4nBQbTujlefDEEi26oWRLZ1NfNCKq0i8r/BGrNvZW+jsavrJzJI95IJW
	4hhOjL03BTcyx7z6R1NwzCi7KO6SRIOca44RzaZlBczZpWT4AgdVyrvds4A9R28zdVrOMz
	xb1aC5o5B+e0M/kIvtHsYEbE3Bz5anY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Q2H6Mk4O;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=29N3zImF;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Q2H6Mk4O;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=29N3zImF;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5BBCB21EC3;
	Tue, 10 Nov 2026 12:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794315270; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OJ/prrn965jMvrgfLjF+vFRorAc5HNvJ6Vj8L/XmMbo=;
	b=Q2H6Mk4O1KaxEREOj5DevP2kMmH/Jidslcr1s6/vZIMu9WIDtdkSn5EG2n6fd0LuRLcdyR
	OsFZv9uv7UMWguBVt0RqvpxAGlKN3MHZdrq5jMlTWssQy62BIT2qg2AoLOn1LWDhgCr5PN
	XMWF0Y0SpbRpnTpFBSi/pSKP5wkCCts=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794315270;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OJ/prrn965jMvrgfLjF+vFRorAc5HNvJ6Vj8L/XmMbo=;
	b=29N3zImFuoXZ3FcTPq5PwxpXmvPvhMRlDBfBJL8lW84IsbdkpNdw1G7KrJbgDQqTwApVDr
	s36m1YzU5P2ufNAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794315270; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OJ/prrn965jMvrgfLjF+vFRorAc5HNvJ6Vj8L/XmMbo=;
	b=Q2H6Mk4O1KaxEREOj5DevP2kMmH/Jidslcr1s6/vZIMu9WIDtdkSn5EG2n6fd0LuRLcdyR
	OsFZv9uv7UMWguBVt0RqvpxAGlKN3MHZdrq5jMlTWssQy62BIT2qg2AoLOn1LWDhgCr5PN
	XMWF0Y0SpbRpnTpFBSi/pSKP5wkCCts=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794315270;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OJ/prrn965jMvrgfLjF+vFRorAc5HNvJ6Vj8L/XmMbo=;
	b=29N3zImFuoXZ3FcTPq5PwxpXmvPvhMRlDBfBJL8lW84IsbdkpNdw1G7KrJbgDQqTwApVDr
	s36m1YzU5P2ufNAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2EA8D1339F;
	Tue, 10 Nov 2026 12:54:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LWGGBQYU82p9QQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 10 Nov 2026 12:54:30 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id D65A3224DC; Tue, 10 Nov 2026 13:54:25 +0100 (CET)
Date: Tue, 10 Nov 2026 13:54:25 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>, 
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, apparmor@lists.ubuntu.com, 
	linux-nfs@vger.kernel.org, netdev@vger.kernel.org, fuse-devel@lists.linux.dev, 
	linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev, 
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org, 
	Amir Goldstein <amir73il@gmail.com>, linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 03/41] target: fileio: check that the backing file
 supports ->{read,write}_iter
Message-ID: <7gknb2zk5u322p4hwxmbkwko4oqnmtroz6evgxcfgaqv43e2lf@4ys3f4ojdwvu>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
 <20261110-work-loop-pseudo-v1-3-4c998976c6c7@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-work-loop-pseudo-v1-3-4c998976c6c7@kernel.org>
X-Spam-Score: -16.80
X-Spam-Level: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6855040003
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: bjgmoc6w6tkooufdgt86hxky5you8q6k
X-Rspam-User: 
X-HE-Tag: 1794315271-109146
X-HE-Meta: U2FsdGVkX1+QRSRBr4XC056NC/cV5uu0jbLh29cVqHr9XvP2AAdWDCqvJKBURftvNz2hfMhd2SRqXmC1lmUDptiEOlNrxNOaFMEX+W2hE/HeQKCkFUtDwQWCIs+UAdLHXZclAyKOpFQqu3FPe0+2F1yhmHV/m1xWREa2dxmZiZNBssp4P//KmsGwX0uPHm9kRvJ8HZ1CcRNGdbVuRKDCFtRekFcBOU5q5KMnK3/TKKZKWTYbO3X1NZkm7cjKdG5/zaRFwb6Arss/PLgeUd7LUDbtMiwIDBAWDKRNfcqwuTn1+94iKWtbI2PVymF2I2BfJ1tZYNSvHhjeHrmjWMNcqcoLawXzd8bgsojJYyUZd8JnW3HyrrPC0ND/AU8rqJCWxym+8nMLxx1tH9+K7CsdOcKs49vOriq61Bnj2guXPLhMAT5haKbu5tjm7Ao+i6zNIRe0uJmCOOp/ECWbnHL0JymDLtkcGv82YQlBdna1XiltfkvBPufnrd2qcivZaxCzQ/A1hRuVnDDbnf4+oX8UcuxrZaJOCqmCHfADrrigfJ/Sd2Z1HPl7gOqUJFjksWcYxbN9I5Pbctd12Z0kGIKPflKvZmYqH0CBr8GLa3fqlKkrqgJCv185feIrERL8pW6yjEo/kBLbUeh/C8dRz1OzMQuPnn/7gSy+XwZ2HYUvO6a/sGZ6UFHL2TnyZ8GyLnpE5ZbO8NyE/ioQQA7MPJz/8mcfwYmb3toRKo8ZlTQToM+FURKAmGtM26C/Zde+hksRGgxpFwrKAFnQbXaxQhpSvHHEOc/ntORv+yYtqUQBgFRPzlVDKmAXgkn11ShA385VOQGCV1Ot4VlAbP6W/t4VX0oN0zBnYxL8VbxVlgjGMMJySBdrArQB29YFhmxLhLLQYYx1mUmct8jyguh5xGmmAClxS4SQTpgEEdK1KoOGZP/YJpHcHPJud2hwwqZ/74qpRudpPKtXFpHLD4tfY2y
 9dOu3H+n
 v9Hh0YEqrHSQPWal0/ETGNHBcZmVhYM3j8MsD5ONGaJG7EK+mk4UeqZfV6QpjV12a8XjDn03qbEQE+e5oQeCAk8/zfta0+8n9FewOo1isSkyr57RUG0JfzE4PW1b3otJWrJR+1WFpvCnu3O24kOV5mah8vH/h5sSWNFGPT7PUIMRfLyMaU1WDHpfeLy58/vXUQGqgt+vhW5R0NaflMMFHGM5D2mrg9Rkh4brFk5NwfmCQUoV8h95euBnuuxKrOppQQqEV1ud/U/307fPfex7mgJH4V79Ff7ARcydLvnnipVT5dSN0JYYOgs6VcSk4uLrMXsthpBMX3uk6/HwrTWKeWuXJMr+Ssi4yhsRjEWQLhm4rn+bQC7koKXddVD9z80vDa60rZkdNYvn7gFp9g3t9iGE+ZRA4cKpLpoQt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue 10-11-26 10:14:19, Christian Brauner wrote:
> With fd_async_io=1 the fileio backend calls ->read_iter() and
> ->write_iter() of the backing file directly. The synchronous path goes
> through vfs_iter_read() and vfs_iter_write() which check for them but
> the aio path doesn't. So a backing file without them calls a NULL
> pointer on its first I/O.
> 
> Refuse such files when configuring the device. On the synchronous path
> every read or write that needed the missing method failed with EINVAL
> anyway.
> 
> Fixes: 769031c92c8b ("scsi: target: target/file: Add support of direct and async I/O")
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  drivers/target/target_core_file.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
> index ab9824a4852f..a5391e57e9aa 100644
> --- a/drivers/target/target_core_file.c
> +++ b/drivers/target/target_core_file.c
> @@ -144,6 +144,14 @@ static int fd_configure_device(struct se_device *dev)
>  		goto fail;
>  	}
>  	fd_dev->fd_file = file;
> +
> +	if (!file->f_op->read_iter || !file->f_op->write_iter) {
> +		pr_err("FILEIO: %s lacks ->read_iter or ->write_iter\n",
> +		       fd_dev->fd_dev_name);
> +		ret = -EINVAL;
> +		goto fail;
> +	}
> +
>  	/*
>  	 * If using a block backend with this struct file, we extract
>  	 * fd_dev->fd_[block,dev]_size from struct block_device.
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

