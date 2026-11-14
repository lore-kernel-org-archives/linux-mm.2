Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B452A606A327
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 17:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CC4g0DhR
Received: by kanga.kvack.org (Postfix)
	id CB4046B05B9; Sat, 14 Nov 2026 12:33:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8BD26B05BA; Sat, 14 Nov 2026 12:33:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC9146B05BB; Sat, 14 Nov 2026 12:33:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A10996B05B9
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:33:11 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3A627A7032
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 17:33:11 +0000 (UTC)
X-FDA: 85434420582.02.64F382C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9CE3D180003
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 17:33:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CC4g0DhR;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794677589;
	b=Duzgom80YgOEBxiUHvJNB297lYKQwxUOwcbA+sdSHOVWHzbnGnM2SBM/r5Ro42dqf6Aeof
	A62pCiKKFqKt2d7bqzUsEmiEnwsr4iPAtTElPVcsd7jOj1Tp6I+Qrc7UyfzSR7HEab7Ajz
	vfSIcBg0LwfHx2P3QJ+vEBeoisz+rdA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CC4g0DhR;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794677589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1aF6FG/8A8GNSEhifnB76peEauYvwhc3Lhh2bB6umMo=;
	b=cLIw0xkZcb7LRZiHfDilcC5qD8mF2cwgYMqk10vnYsMNl/4UQOfSR6C1FZDddC2pQC2TYO
	tAbJ8kN+UnMl+g6FI3Ofg1pi/Z1nnll9WsbVX32X0pcPl5j5NgQZVsqoSQEGE10q1paFmb
	0DiDiHY3nIBhJXBNi//QVJ6gB98dbts=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 309C460A86;
	Sat, 14 Nov 2026 17:33:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 541151F000C4;
	Sat, 14 Nov 2026 17:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794677588;
	bh=1aF6FG/8A8GNSEhifnB76peEauYvwhc3Lhh2bB6umMo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CC4g0DhRkW0DeJDtpn706QZWi/HUMQpuW3IfDjK3Nioulri574vN0BEOuOCzLEX0I
	 hG8CHO8NhSwRLAftY6Yi/ENg6d/hbIwvjnnpPpwvOFX2J4oLQulgyLk2bHXV1QgWwc
	 3cvYrwB/d4QSZWWOP/nC57raDQvh0wenbsXW2k0Ro9PY1Ww7kQDolFpvmgCVCok4rS
	 3KyjVPCClhNm5+sFeKfLnxm5MhuiCX+MaRb6p3dZr9Pe8gHaisIFUgCTglyaY/jGqj
	 04Lz4mnvNMNToXXnifofD5WoXXNk3tC7au3I7cIlVqlA0L0QSWFZHAf5GDvqtKNiVD
	 3CRYU+nZajhhg==
Date: Sat, 14 Nov 2026 17:33:04 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: shao.mingyin@zte.com.cn
Cc: catalin.marinas@arm.com, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/kmemleak: fix scan period truncation on 32-bit
 platforms
Message-ID: <avibPHxuBtW-x-gG@gremlin>
References: <20261115004702358r2RJLihSrqbK4dr026bcI@zte.com.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261115004702358r2RJLihSrqbK4dr026bcI@zte.com.cn>
X-Stat-Signature: wahu591wtrudy9sm9b1aim8z4ue4k49m
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9CE3D180003
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794677589-126591
X-HE-Meta: U2FsdGVkX19bRF7Kho2ga1PGauxL0sJVQELt7X6s0VKd6pPa1CJVlPUg8TtgkLUs2rc6NlOJpRKeSR0Ifer0yWymibRncjO41J6+1juE+YoUYzlA35i6NJllTsycixsU3611qzT0BPuGc1vveqi2nRlatHDM5gSLBjgLMp2vsI7ZEXDBpY32f1Kd4nLQFMoAJu4DRY8caIMC3OfmvRpbLWAv5kBPawpbMeNPQCGURr5n8HR+oMcn6EPaS+q92UA6VX3fQguegU8MEUIzaBKZ1nGgJIkMtlgiAH18BiYtrIDczBySFJxQl6Ac/8IIyxbe7+AADtaC5nqFpYlpFASx2GtQTI1YC51L29/Sm4FhP6pTyJjNBuvvy6stD0RX6Vxgf3emh+mZrYwGeSCuukgLb0+Q+CEtgniO1T5aHOCZSusaQaA7YitJPeSWyAUhBhW/iBX61wNaRJ3Lcy1SNffy/RiZKjTCvKQUY/iOQ04d0lxmqvfirr1DnY2S3C5unRt2VF9C+illSfFLkWoXY/QLY+4UhnfSpyxQXuRmQV6Rj3Co5yCasC1mBDObPPpBJGGcafosrx37p7p2xROSjr94+TSuuWCNPB/L6a6F/50POTHf0mtzZ7drjIDdrfzgd+K19NOHGq/v+TWy/yxvDPerGPmQXswp0tQavEJvivueNwveL/VitJVexdjEcEzUfphZfKPnWEg/abSCTL4fnND7RcE55uYUzEcYaHJWmx94F58q4oEA3v4OmjktJvbXPt0ZHOahfrncbgjTLXGs46wIZMi69szjXSBjOQT5LDi9vyQShaR44pR1YGaqfohjY3s4OifZinZSO7i+2YJgJgdeB7uqnuZbc3m3Nij3CGETyhd6XQ+000s8mnWeCk7uprWtIvo4+IJ3ayULmzN8MhLlLn7mF1JzzvPuFbuX3fGRY0PbSJ+LY5FoDpJJDTt5ErvSmgilgwkxtbDxf0WMcSq
 +rYjWhYp
 qyHrbToI9EyaIb4y6iiG+gu3+sawdSg/LCXZw32fIMN15gmKCPZvvtR2z4u4PrOl3MhGberw6Le3rD1EBjHvyJP9MVHlbFo9CwwapebOe9GN1BYpmuD34Zsf4Ef9HtNNvzLatqf0ANoiPsOjJ37NaVTUDPF7Rm8bTn8793nXt2XNeZh3aYfXLJN9aC1koAV8eJOIFzGHokEzxKG+LQ3btkkh9u15gTflbROgfT5UTZ6DyNh5PG8bHjgTbKyXeupxTZ9PNUZszh947uzeOG4ecsGuWs5z52PenL/WJ4UOfV09i0EIt41sThLHA2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 15, 2026 at 12:47:02AM +0800, shao.mingyin@zte.com.cn wrote:
> From: Shao Mingyin <shao.mingyin@zte.com.cn>
>
> mm/kmemleak: fix scan period truncation on 32-bit platforms
>
> kmemleak_write() converts the scan period from seconds to milliseconds
> before clamping it to UINT_MAX. On 32-bit kernels, unsigned secs and
> MSEC_PER_SEC (1000L) are multiplied in a 32-bit unsigned type. The result
> wraps before the clamp can detect overflow.
>
> For example, scan=4294968 produces 704 milliseconds instead of the
> UINT_MAX millisecond limit. Perform the multiplication and keep the
> intermediate result in unsigned long long, preserving the existing
> 64-bit behavior and the later msecs_to_jiffies() clamping.
>
> Commit 54dd200c5a25 ("mm/kmemleak: fix possible wrong memory scanning
> period") added this clamp, but it cannot work after a 32-bit multiply
> has already overflowed.
>
> Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>

NAK.

this is generated by some AI slopper's script, spamming the kernel. The
patches I looked at were wrong/broken, so no to anything from this person.

They've sent 300 mails in under four weeks spanniing: ata, scsi, target,
ufs, nvme/nvmet, ubifs, ublk, zloop, dm, md, mmc, virtio-blk, mfd, gpio,
pwm, spi, PCI, ASoC, ACPI, net, vfs mount, block partitions, and now mm.

and 17 series across 7 subsystems over the past 23 hours.

We need a way to ban emails from people like this...

--
Cheers, Lorenzo

