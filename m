Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91CABCD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 07:16:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05B816B0092; Tue, 12 May 2026 03:16:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 033906B0093; Tue, 12 May 2026 03:16:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB2296B0095; Tue, 12 May 2026 03:16:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DA6826B0092
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:16:41 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7EB0A1403F3
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:16:41 +0000 (UTC)
X-FDA: 84757910202.16.A91149A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id AFD94C0007
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:16:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iw4jpXeE;
	spf=pass (imf28.hostedemail.com: domain of dlemoal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778570199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TBLSwE5Enw9Fad3QZn3L13j2+aYvfA+zzUyoH7S7mbo=;
	b=OCYJtqcr4huxW3gBVAP+sOB9mYzxpj7StpMsg291fC2G+fwrjraKan5yuAxbcpmAlgCa5z
	jF4tRrWyAWRVpY4Xws+kEhpya20sEQKXa6dfapn32FzR67o7WBwDIlYNBadDShpuj6d/uq
	Kpynl2iGwQFfaw/04zK676dSm2p3ZOM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iw4jpXeE;
	spf=pass (imf28.hostedemail.com: domain of dlemoal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778570199; a=rsa-sha256;
	cv=none;
	b=FD0zwsLBth7k02tExkKkcw2pi1JMvP/z7ZZecMYpj37G4IUFMWBPGjgjs1NihkRvm4iOE1
	ER6CD2zmC7kCsRbChu7Kb2Ot5Nqt3OS9AVIZlyBKuz2GQiiDvB8RGTPoWtVetYqsUtQY/1
	mDjfLYY7S9BI6Lhf5jNdfj6Jvihlrmc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CFCEA436DD;
	Tue, 12 May 2026 07:16:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E618C2BCB0;
	Tue, 12 May 2026 07:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778570198;
	bh=nKvg9k4i7+/FdWNoLP39fTA2AIBDoli2gh2Xo3a+f/U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iw4jpXeE4iOTdRjtloaKtPRiHhRVD9YnDTRygvwHuj80w5Lt/GGuuos8S4Oa2+A4Z
	 ID/zwJQlick5hyU4VnwvCe6wnMLR7YE22/84JKPCiUWJE12TXkUBwoW0Xx2o2Y8Kbc
	 Ap/ZZWL6+KNR2fCfNMakCOH0HKbNFRfpp1IrwQXWNsRyjaMjSJeMwYfsVxKH432Az1
	 +dfRTVKY4Sm+FYuGhaV5UL3jeIxzP+M4dP/TEGsLXxEyYvgq3HndEAdgOqi/TC+AS7
	 TEKARoNX1z73Pn9qVgIaMUuNjbH5til+b8JTgFa+cH3UZwf+2RvwC+OmA8Cl38G9Nu
	 8hXejv+EqUw2Q==
Message-ID: <f34a9a4e-3d0a-405b-a3be-6400642bde44@kernel.org>
Date: Tue, 12 May 2026 16:16:32 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/12] swap,fs: move swapfile operations to struct
 file_operations
To: Christoph Hellwig <hch@lst.de>, Andrew Morton
 <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>
Cc: Christian Brauner <brauner@kernel.org>,
 "Darrick J . Wong" <djwong@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>,
 Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
 Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>,
 Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>,
 Carlos Maiolino <cem@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org,
 linux-cifs@vger.kernel.org
References: <20260512053625.2950900-1-hch@lst.de>
 <20260512053625.2950900-4-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260512053625.2950900-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AFD94C0007
X-Stat-Signature: hgpjm697jfbcfgfy8n6kkbmjwx86ny4h
X-HE-Tag: 1778570199-112489
X-HE-Meta: U2FsdGVkX19g50DH7dBRh/ruGVPzGGqpM/OcLTy9NguH/pKuYwa6RwTP5EkDmfWEvdHPit4SqgZsSv8Ot2Sdhplmi3et9Q8aDp3ulOuC6VCVpjMW+u6NzQdvVBLayxdvTpZLf9GnMXdOjJu+WiWBjqYqQH5DAwe0IWP6vGYO4aStWRI11iR0gshFZmbxVsonAUYn4fumo/mlrAlDaI600U0hOuptGr9CLeLiT67a3NsxSmuNMFWvllW0t1OOohYrlkq1XOTPG6LgeT/XTyIoxCY/OY1mESpkIdQR11Y3F/9/h0o3UYEm/TmG5xTNPeMI4wix/ez3YzEk3U6TafLZRZizEpA8BjSoUjAolI96eM1mO/a+er/VGTBRtye6ouHRennvcBnnQKMhkD9n0e/fCbLZXFbiLVu9eExBoG4bwvTLNVQ0aSz2op2S1cBfU2/UovJ9s1p5IkB1x4OURqUPbpX4NNTSw26puu7IDlj3QozJ50ILg8/6BMyuuXYUgsbr7QYapHMiTIK9dEzP6e+dJiw5gdU23mVH/N0pdW4UHZdoRzONXr83yVqXA9FtCCm6lhcKI7V1lEr2XXtviqW9i45tU2Zlhf6tlxt8krf0BKyYSMeTk9ff3DpVf3JPTbv+sLpZvs5ZERGHsw6EFrN0mRkt8AlJ4X1agqPYb5UCfGapTNp6eLo0HVfWysXvwTmkHirCFRjAlTIOQDANUxli0VdLiCbtnXkfCCV3XitwVD9zk4sWCe5qEvGk9QhbOPNTYQgbDvvyHqIRP+0+UxiV8DD9H7uPcuJT/vTgVwbhnQLLtoEdoZQoVVJAl9MXd0mXvScDGedAhH90rbVywCXPQbNGX83AHNAkUV41uIOUU+HpLgWXMWE2fTFRvbUWBAIuNQ9cZhiNnTo7ZvlUWgiHEMkG2uC60rhSaNKgew6tpUTDL5sf0XgKdDzK1M7Q/sGIgYGcdkxspcNOLAZAVDS
 fl79e4uc
 kaxwjzNMuecfe0RRtw8nvU0o7ES+sgtgLvKiAQXpDPYXToBxyyfj2uYrrRDjyYiOJ+d/jSQNKo2v9OODeA7NE8rqCcI5j8r68IzVxJnZD+mpHqzB8jpr+VPO8aKrgsjQu0KRe4t2w1tJRxTrJUEu+DLeascQ/OklghfWR8fqy6jSJp7sWZVpFeoWM3QWHqcdVNdUq/EYE3b7yJukxQppnrxPGKWwqumMLqL8Tm7eQ4FoOK1/O1YXYMHCV0hpDd39atFQeBlbeGDwUexVuQgr0bUi1VPZLb6sRQIMKbG650WGY01us0pG2AgT/cYAbNF+I3luag5arDQWZuIyPkhyRkoCPw6yAXFfOoHDaXKtuHWSYhtTqYB8xJsEbizqdVvi6IZpYfolQZH6ON0L4SP6BK2foxw+2SOwfio3y/D+ynBxCpZRVA0RY09e1Rg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/12/26 14:35, Christoph Hellwig wrote:
> The swap operations have nothing to do with the address_space, which is
> used for pagecache operations.  Move them to struct file_operations
> instead.  This will allow moving the block device special cases into
> block/fops.c subsequently.
> 
> Pass struct file first to ->swap_activate as file operations typically
> get the file or iocb as first argument and use swap_activate instead of
> swapfile_activate in all names to be consistent.
> 
> Note that while the trivial iomap wrappers are moved to a new file when
> applicable to keep them local to the file operation instances, complex
> implementation are kept in their existing place.  It might be worth to
> move them in follow-on patches if the maintainers desire so.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

