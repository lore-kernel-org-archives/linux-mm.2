Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EAD4FF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 11:26:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0E286B0088; Wed, 29 Apr 2026 07:26:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BEE56B008A; Wed, 29 Apr 2026 07:26:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D4826B008C; Wed, 29 Apr 2026 07:26:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7CEF16B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 07:26:46 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D4AE0A0175
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 11:26:45 +0000 (UTC)
X-FDA: 84711365970.25.DAEC990
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1679D4000D
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 11:26:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ejvHWE1z;
	spf=pass (imf12.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777462004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=goNuGKh90jfzrTtcM8AQu4/qcccrIqr5mhqWXnjaDnA=;
	b=LROpAc6VUtMm5fSs180v/IPraDlXr3Rj9jWRXX+XnrGI+K8dskmfv0KevH1lYQMcdvqC4/
	P5K5n74FxuxfG2yu8oZRsIbP9a7QfmthRcISaaKcVY0bV5FRNRAB5+f6v3SspNACovEgES
	F5BRGuBOL3rRcUHxsZiJ9LqInQEirdw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ejvHWE1z;
	spf=pass (imf12.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777462004; a=rsa-sha256;
	cv=none;
	b=kbWIqgP/x47zF24DP0xEYq+ONSrmaTWk6PxnTr1fHBUrCyAdoRoC0kNZqRzXmVo4FAb92f
	xEOqfw3iXWWbSmeBFHoG7ylzu9jh5wXoX1klZyuD9N4DSws9j0YCt7u3mjCr3HHloctytW
	3dXyfmxFl86O6eeB3l6QGOf1Yefsmi4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CA92D403EB;
	Wed, 29 Apr 2026 11:26:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 158D1C19425;
	Wed, 29 Apr 2026 11:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777462002;
	bh=HgV0q/+gZ9n2giWTxhUD6P3yQ6wEmY66ZwCWQHhgQ2g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ejvHWE1zJ0tb1KwQu/gVCMj0KcNhlMqCOjLI4kQmWC01EPIO4HFDTFQg5PpNyMx2F
	 7OMWgwbyfp16yd5ZKGLwfDDMuBlWK8CK9qcSIqUHZRxyhnWE4iAN+OK+xmr5WBtr4T
	 BgqmCB7r/rsFvwFu/mT2z67QkDE/mDzOf7GDi68KHsQjYM3r7svy7TXqJDW5kWsfNa
	 xYHmkznhflijvwvOUJkH6AcM42ZHWo8kZp7k26fwbFC82N/jHC8/F/rL8GlM8z6Ksh
	 UMOZ5KVH94exo80oAIrmoHKOK/k/qke5mU8V2uOXUW3Mlxuf7JynBO/Edq8wMcfI5M
	 twwrBSWDcoLLw==
Date: Wed, 29 Apr 2026 12:26:30 +0100
From: Will Deacon <will@kernel.org>
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: Yury Norov <ynorov@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Laight <david.laight.linux@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>, linux-alpha@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-snps-arc@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org, linux-um@lists.infradead.org,
	dmaengine@vger.kernel.org, linux-efi@vger.kernel.org,
	linux-fsi@lists.ozlabs.org, amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
	linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-spi@vger.kernel.org,
	linux-media@vger.kernel.org, linux-staging@lists.linux.dev,
	linux-serial@vger.kernel.org, linux-usb@vger.kernel.org,
	xen-devel@lists.xenproject.org, linux-fsdevel@vger.kernel.org,
	ocfs2-devel@lists.linux.dev, bpf@vger.kernel.org,
	kasan-dev@googlegroups.com, linux-mm@kvack.org,
	linux-x25@vger.kernel.org, rust-for-linux@vger.kernel.org,
	linux-sound@vger.kernel.org, sound-open-firmware@alsa-project.org,
	linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org,
	loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org,
	linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org,
	linux-sh@vger.kernel.org, linux-arch@vger.kernel.org,
	catalin.marinas@arm.com
Subject: Re: [RFC PATCH v1 8/9] arm64: Add unsafe_copy_from_user()
Message-ID: <afHq5vyNUJzxVwDV@willie-the-truck>
References: <cover.1777306795.git.chleroy@kernel.org>
 <5b09e58a84c9edcfe5724db5cd57e45d96a96bfa.1777306795.git.chleroy@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b09e58a84c9edcfe5724db5cd57e45d96a96bfa.1777306795.git.chleroy@kernel.org>
X-Stat-Signature: 6ddehk6nrurzsox3juy7651wxny633sa
X-Rspamd-Queue-Id: 1679D4000D
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777462003-98613
X-HE-Meta: U2FsdGVkX1+seKXEhwbug8ZNj2LhzCi/b9lNYo3MMl15YvAY992Mw4NNrFsHWsuqwr/iWNB3aUvtm7Ajawk5W4NIR5QVw//num0z+nkG1dyWLQelNNDZZwp+mRUD+OikhbmH/SXEpV9aVLIUUreutirV0zr+FA5xlbS9eYr9bwOOMpNE3iS3R5lY/Bky/9AlFMimRszD+NxUVS1Z1l3s8/Cgju9drv4cC+9+NqtVAbJ7uG8Nr1/tvkb/3N2RW0IE4Gxmy4CPInGZdw2c7Tdhd09KudHCjPWx0Hqcc2OmI8pJo/euSOpWwW/CiU2PEjpf1JQSzwJm5vs7uQk6qI1AMQoiCcnC3kUtQisSQVC6k2JfFOMq2sagMc+uFSNcqoqa4bbiMKiO/WshjWCw/tYub+M6SS+YlsNy5jCTvBSkxoLE1A4FjFAELNQpKk5zKgA/HwH4agqaITWfKP2qym5gSbYIUyjgjy8MHEFHzcrkIvr8PL4iQ2q3CT2Fp3PfbYnqATXxuMBVEgtxoBXW/e1LJ2b1jH2POCucL5aGDsbe5hhzdK+Uhcq2pwCVwXKGfuXnmL43uz7qn6orIwh35K7evyZCQF9gD3NOO7bm0laNmFQpAFOvx5irzen0niuleGOfcGtE6hj+zTK4uR6vNSwMAHaxXHBz83rFwVH93D7hm9EzmWhySr2izGZFIP/qs7q8hG+18rdObAWjeNqm5UsaWTi86Ja3xfVHG6rrSvwzmO6i2yT/0u7CeLW92uosmOaGSYI0RlLKnWA373npN3CCTPftpHgAErO+JpUp/KMK5Jg/qRn7Ehu6x4oxlrsHXdxr2WUkKDFR4b5KJPiScS/v4B5UpuGanBiXBES8zdkDpP6DVnJGkHqy2o32soEdo4LVT6G9SagSp07ct6iZY7BlRSS4/cAnQ2oWRIli6Gd8d4aAFErVaES4YzTDvAWHgT1ou2tZ4LmbHs8OMUm2LwD
 VJ6y1aDp
 WFv9NtXnEg6Rk70C8dGOk5Z/ZGo1KTmhqAl3YysLwFCPya5itomqubReeZcThtbdCneVZkSfxJFTZfqgCoSOLr6gZgp2eYY10pThlhYXzdiiKZDS5GQ2VijB70DGiNNkjozBgr9E2Ih0n+TyrtnZzMr6OM1x8HYUmhRijh9x2AzVBICamH1RhPF0X1l25VSORn3M11P62U7aBrURyDkjKzg5UWjSBZsAsLKA76xel8+YJFwBDhUijDjxx8f62UX2lraVpW4IACxyG29jJ3qSQf1RKJGMKNkPQg+nbC576vSed2802kh2wAcZe01TzIYoJryKsFXks/+vhB3kBtljd5o7UoFvinUr63iJNbVco4cW+CZlWIIvQWf6VAB5/013E1etiQ7GmqVFV9mc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[+Catalin]

On Mon, Apr 27, 2026 at 07:13:49PM +0200, Christophe Leroy (CS GROUP) wrote:
> At the time being, x86 and arm64 are missing unsafe_copy_from_user().
> 
> Add it.
> 
> Signed-off-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
> ---
>  arch/arm64/include/asm/uaccess.h | 29 ++++++++++++++++++++++++-----
>  1 file changed, 24 insertions(+), 5 deletions(-)

Why?

And please cc the arm64 maintainers on arm64 patches next time. You've
managed to cc most of the world apart from us.

Will

