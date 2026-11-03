Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0198606EEAD
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ArRY5tYD
Received: by kanga.kvack.org (Postfix)
	id E62AD6B05D1; Tue,  3 Nov 2026 03:42:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3A286B05D2; Tue,  3 Nov 2026 03:42:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D504E6B05D3; Tue,  3 Nov 2026 03:42:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B7ACD6B05D1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:42:08 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AC6181A0344
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:42:07 +0000 (UTC)
X-FDA: 85393165494.18.E86D973
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 22B3320002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:42:06 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ArRY5tYD;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793695326;
	b=NWssfa1zYqIxtqNHYxKAhdjt3FBKGm0mt7mU7A0dKWheXFRymn+pKV3iR8rK80uBcORuBn
	hy+vR7EyUhpBlZMwILu1547zXf0ACeP3A1EnOckoAjyx9sGtOtvLHcpRCc26SsEhGuD/kU
	xwkpGlUyphodrV3KuKJ5k4exAJefqk4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ArRY5tYD;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793695326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Mmu1SJgefq+KaAvFDsItBgRjAHi+/Cf/AJ8uC5U19o=;
	b=GKjdBh/fsaYVJPt85K8L7qtwD8/bxY8d9iM+c695Iv2PR4zd28NGhqJJwCYsGzFDc8V/LV
	A3/BPHO4Oi+Pd6Zlc1TpPyXJgu2P3AgK81HmmLoNSx6z72yHGI1qdEGuy1ojjDdaQSUcrJ
	CqxdmJNUqcNKsf/PF0uSC0mlDpnoP0A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A2A9A6021A;
	Tue,  3 Nov 2026 08:42:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8121F1F000C1;
	Tue,  3 Nov 2026 08:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793695325;
	bh=/Mmu1SJgefq+KaAvFDsItBgRjAHi+/Cf/AJ8uC5U19o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ArRY5tYDCFtc+xAoM77X7yHuc7rwLTxS1aG8aniTRKZtQGG442iT2gAjl2m+2dnnS
	 G+x+3k3jdG/f9V6Ry2EC6wMt93w+qL6UAFF3n4mG2B4dCloG5G4EwLnqrfLFnbkFJu
	 TVKZ97pmWfUobd6UGBB3rVmPxEolFi8QvwwI97bWdICu7aoijfe08s48DJ+voAL4Sr
	 Tw0HK23tCKk2+MLHCh/kPVnPF5cV8SneXBmKrRyfbWAsj4nk316I3t0Y1VXaYkys8F
	 wkP/2Fq9Ez76IMQS8TueH6Gfef4ET86iQJ5WDrGrumAkawpwZDe14gdg0mEl2dWHO8
	 BA07yDEdurjig==
Date: Tue, 3 Nov 2026 09:41:58 +0100
From: Christian Brauner <brauner@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, 
	linux-mm@kvack.org, ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
	linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 33/34] xfs: allow remounting read-only after a shutdown
Message-ID: <20261103-galgen-ehebruch-stehen-a967c14ce53e@brauner>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-33-2f44f64f0b66@kernel.org>
 <20261103054155.GB1559@lst.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261103054155.GB1559@lst.de>
X-Stat-Signature: uizxa688nr7kdkdmon3a5gydms366fou
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 22B3320002
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793695325-278662
X-HE-Meta: U2FsdGVkX1862QydQagElHzSvfIFN4R7NCks9lW2hWDsog79Hn6AzfhSiPZCgQQftinNnp/kMvGz59oWn8VjMm4Clqmc9nLEx8KO7zWPxBkiP1cxWHUAAHTagXUHw15RHk7rLe/O8YJamSYgxSGOXZdM6hSaeKhAvbpe78kcoGWm0zx3Ib/hD29muUkqZfjfRkFb7+rFwtk6IlVwFG+AQPEwH+73exJj3zEVNofm4aMI8ADYbVPcqLR/Hd9ozf8S8sD22PXAL/EfIYgrd37F67nVAKREBdCen3HXNKBQLqeY/QPu8Uf87ENxpE3Vyg25JZ4Q9pGBaWw1ESdX6yhV6uGGJh9fB9ViTtYeWf8ZRyMltNRM7kmzTjbPmj5ckVAvhLFqb/cBujADKuMOBhMa8YTNWRmGmztZz0PZjnzAJHlOgkCfxNKum6wQql4YUzv3oubXEOXS3JnMpECW7sZH9NQeJTyfL1RnqpuYqeTPCCT3hy+DPPpYIy+efkZiE1CVeoFxxmsn7t1Bf97Isb6fgdF89tJDePQ2wG9DagGl933RW1G1Wb7sdkRNuY1X6ZQmxdeCpXB5qspW5bvKTT6rxM1jL64lzWcThQYOZ6mk9UDKjXPAFK7bS3tsqKHZPGNzXF2u1dtTFlDMdaUQriwSZLklWQqv+UruwVwQPyrvshRkN3qvUVTnZwn5UFR2WrZwz48o55uByP31T/i+iKs0PMFRcAzG8A5tbDYq5Dtb+XJDiSHAI8CMSc+GprbfKDXWkrdo2S0etCuKypChHLQoo3+a4+ZRoJsGMPbay9HIB0/I5Jf/zhEQ9LqIsGLTMmIL5C4bJWW/7qhxrZTBMf4s4J3bcR+T/RvWnT/Tbnd0Y/0sZYUQx3n4mBbW+Rb2S4YUTYhgyjD/S2MYaoCMS+vg3B49yypnXZfayv9dH7sD2cTEolyTvAu1WEuNQLprHzMYwLWJxheiOdw+MgXJq6w
 pQf2noBu
 ITHGHtmhLQrG5krfYKqBkg9NjM1aL1MtMNLs2kfhcBt5awVeAJrxAhU4WKMemsXE7FKG7Z6DWGF8W+XpKeF2pQD25LsXbbSXvK8tIvI5CBKEdQgLfLypTSjkPWE9j3buAQKZiNOP0ooyVUBXye2KFf5/RNY6Ue1RDS/54bHocZZ5MSpjcjHlTiEu+pC1Bcny3Kfw1tA2ed0gt7aWeVDw69gg0/ChbgyusEdK+gJ3Ug2e8o74a01Vo1MZs64JBq4RBnECk7NyMYU8EL9JA0BtV+qQFr/WSESvW8603Y/Vfp6NEWKFpICG7zKkWgKaQgbGTNTcv7vxnL0bd9nYfXP5PFN33hg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 06:41:55AM +0100, Christoph Hellwig wrote:
> Btw, if my previous reply wasn't clear:  please add the test for this
> to xfstests where they actually get run regularly and not the kernel
> selftests which for file systems are basically unused.
> 
> Bonus points for having generic tests instead of purely file system
> specific ones.

I can drop the tests from this series but xfstests for this will be a
follow-up.

