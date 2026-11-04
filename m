Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52CB6606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 09:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DtCghqTk
Received: by kanga.kvack.org (Postfix)
	id 56AFF6B05B4; Wed,  4 Nov 2026 04:24:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F5346B05B5; Wed,  4 Nov 2026 04:24:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BCFE6B05BC; Wed,  4 Nov 2026 04:24:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1796E6B05B4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 04:24:23 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0DDF24065E
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:24:22 +0000 (UTC)
X-FDA: 85396900764.30.CD6BB12
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6D09A1C0002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:24:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DtCghqTk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793784260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gRXRlKwKxN+fSCr/T6i8djt87uv7sYA7hvMrxndI77U=;
	b=Qme2QFdOc3Niz39K3JPxlt5563YZRf4qBQsTW2V+uZJp5ZkpEpb7wwgNv/l8hTa3GaVBlH
	8KTBMnBYJw47UUuPCEEuQ52W02NYVkJwrzBbiRHf6dIWvNNjB7YpU/GQWOFyZQJWpbD/qC
	wIP6NRhdxw+seZWVZoo4Rmkc9UQZafM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793784260;
	b=KlFodT0JdnsFxA4awaFVnL/qzeVl2etF9oLJDgvhBWdY7w8CLowFx0MrCgyXRxKrqytJjG
	N9TBOj0jjLeA3MYvvbi2yfsfpLZHSalGMiGW5jQdiZkpPwr3nCswYk1cf/ueHQ/nkxpHO3
	3nzatREA4yPVHX9VZ5TKJmgWKyFOfVg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DtCghqTk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AAC8241A8A;
	Wed,  4 Nov 2026 09:24:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A00EB1F000C1;
	Wed,  4 Nov 2026 09:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793784259;
	bh=gRXRlKwKxN+fSCr/T6i8djt87uv7sYA7hvMrxndI77U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DtCghqTk4F1EE9ZiaGiOl/CLyemjVYDJ+E2iTwlEuHko0AF2WQqNB2tyP1et6JQZd
	 /s/kPoz0A0zF+b5fFAIFD3ImxnjD/VWhr5VSKRweQqln4RDl4AQZ0FVMn/i/yt7O88
	 Ps9wlo2Fnfedf7faqa4SwwEANP4Q/4diwjkTX3mMumkt7VPx2Dq0vxvGBgDryWLmiO
	 5lerAYpepz4/m8aYVA7ag928SM+ijqD5yy+IBJRJI2YPtpIITX1SvmPZzKqLhu/h1W
	 WugE4uZByige6JL65yaTwMSDm+rRPo4EHgbghVb7x5+GS84YvD8WL3izKpfkYLWK0G
	 hw+mR5o35+RDA==
Date: Wed, 4 Nov 2026 10:24:07 +0100
From: Christian Brauner <brauner@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	Jann Horn <jannh@google.com>, Josef Bacik <josef@toxicpanda.com>, 
	Chris Mason <mason@kernel.org>, Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, 
	Eric Dumazet <edumazet@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, 
	Greg Kroah-Hartman <gregkh@suse.de>, Joel Granados <joel.granados@kernel.org>, 
	Kees Cook <kees@kernel.org>, Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>, 
	linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, coreteam@netfilter.org, 
	kexec@lists.infradead.org, linux-pci@vger.kernel.org, linux-sound@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org, 
	linux-usb@vger.kernel.org, samba-technical@lists.samba.org, sparclinux@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-serial@vger.kernel.org, Takashi Iwai <tiwai@suse.de>, 
	linux-input@vger.kernel.org, linux-raid@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-modules@vger.kernel.org, Chuck Lever <cel@kernel.org>, tytso@mit.edu, 
	dmitry.torokhov@gmail.com, Petr Pavlu <petr.pavlu@suse.com>, 
	Anna Schumaker <anna@kernel.org>, yukuai@fygo.io, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: Re: [PATCH RFC 04/16] proc: let procfs own the seq_file of seq_file
 entries
Message-ID: <20261104-hiebe-ausmachen-express-e9c87b962865@brauner>
References: <20261102-work-procfs-core-v1-0-75df35e4f8b8@kernel.org>
 <20261102-work-procfs-core-v1-4-75df35e4f8b8@kernel.org>
 <sashiko-outbox-195531@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-195531@kernel.org>
X-Stat-Signature: nyx6gdnohh1xxukxqq4tb9ofdq6ws9pz
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6D09A1C0002
X-HE-Tag: 1793784260-634198
X-HE-Meta: U2FsdGVkX18phZsE6unFtVpSMHSXVpx22Ob3VQNAMyEym3FBkE0fZQLSG0OVczC3oEqGkRIW6ZXtfxBbFL5GTUfvWZ6ftw5/bvIoXA9BiLbMMdgPCM8jZCRAi92gmRo4JkFRd1LyGL02XmUItF8YLpke2p9uRmBoYeu3dEBfcC3fVbAPg3o8Q1Rj4wKwfiLJ2M+dS7IbSZU47GotgLvRhmSI8B72GJdwXBlcciDTz0+6skbo6K1vGoXM7CMK7CbE70LEhhc3jxRnBwTUa7/FrWszeaOv9f1V1Zhw8wly5CW2Vypqn5tk4G+s/FglV0fIBfE037VKOqK18xx0QEhl8orFbTs+RhEmvBcxp/zU6pr5zZe1jGWgVO+MARQJs6/K0uDjXxT3xDmEeWAW+yvKbpRAEFm9bLT1TTxPNw4ylcpeS0vcCHO+6iFJXV8343VREQ2SDxNvIj5IS38NDeORxl5QYi6p0QrAORRXUm1ZeBIJYKPpbEGRzsUMIxsF6wJ3CA/BtqCDA0z/DvS3RxXZEqycvbbInyJN53htrTb3lNvQkSG1zNwjOz00NxlIixI/RJVwBsGsxQUZwE3EqN9JLE8aY9AIzzcRAvjz9UqLHT45eCqNAmyZhCOGIk3Dt+33h1yOZc9pxBy15cxp64InIMhhJgecIfiWRuWwZPNLRjTYgXGMo05lLBd6/fFJ8XBGAoO/dLpzYpFj1PdIpINSw6RzRPtG7Xd5Lnwk0JFSXvPTdNoTOFWuZECtc62vNBhvQBT4NLkH00E/dm8OymYGbOe5ffmtTDXtpaxs4w288Z1C3Kyxs1lWLYugmk9oJO6yOXLh1bqtLa+R9geq4+v+V+fAAYCPip2zbjnNISx28TtbfJsTq4oqo17bFfuIAMYLU+8rdFnJbabpZQyof2Vb50WdMniXc7A391QxWrchNjzIwmGXvelDz0+rM/Yt7l3H6Enb1aRnkRfJXRnU2WM
 FC6wsnwK
 sq3MmBLwmS+uPLKJGn1R5cO4J8xSLkgc/T4nW3GezzA4jQN2cCoZGOdGdtjUNB+i2JRzGre5Ij+UvRiYNv9Uy9XyEwW4HvsTSi78/e+TsL1CHT7N86FKQ0b7zzUwYKbhQk5lFjawCndXnnnCrRY2cAyXgJc5TlgNuZbEjv75XmNplYsfmIBGYVdtEFX7+xkCd4E71Ek7icEzjBqAannalyToTvtv/wNdJ8X7awvPPohpwW9O+HQSCgCSXnTXkfm2lbFuBBq+YLELY3gg9SreO8XY64zyyCMdkQoi0WT8mDNdGjl5vFIWO0cldTkeZW/kGMXcT2KNza5k6OewxUzsB9ywTAXD1eLYaKbClYP4CG7c7E2eKDwdy4VKFSVNrdnkIGsHz2AtecazziIF8LrIIdYc4T62y+i9vey8d+90G17Q6xtenUJUrFQNYvxs/WNj05JOT5ELRt5zty4hRHiKuGDBsKIQJJEFtvGsnAji57imbwzhfzmxKnYwtoQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 03:01:06PM +0000, sashiko-bot@kernel.org wrote:
> - [High] proc: unpinned dereference of pde->seq_ops->next in pde_seq_next()

Nothing in the tree returns ERR_PTR(-EIO) from ->next but moving the
check up would remove that possibility so yes.

