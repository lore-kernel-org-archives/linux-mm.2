Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3561606A32D
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 17:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ObqNUb3r
Received: by kanga.kvack.org (Postfix)
	id BEF3B6B05B5; Sat, 14 Nov 2026 12:32:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC6366B05B6; Sat, 14 Nov 2026 12:32:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B034A6B05B7; Sat, 14 Nov 2026 12:32:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8B9C36B05B5
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:32:05 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0D130C0441
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 17:32:05 +0000 (UTC)
X-FDA: 85434417810.23.A09D0CD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 747E640006
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 17:32:03 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ObqNUb3r;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794677523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AljFBfIqcD1ZWecoMIIEjM2yrPFU4geEAa8J3J+RzSI=;
	b=OleRuj0+4wIUJHVipGsRg2uz71URPZXLF0f2q81+9zCO/NB8jqTrBUuAUaODqq8rOijSLK
	rGFJ1KvpeYSmjCdNsx9Q3Z85gDmYMj6obsjN2BDGBSmBcZifhZqcHl9e/mfuGkK436VBrh
	tNNTbF8fCFpk94NN9cNaguXAl5bB/U4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794677523;
	b=GPvYsgb8xgigLaA6O118Ir9Lx+nRZROQA24fM7vwRtuhJX00ag/ZlZ7qX6A3Q8qxfhGUUM
	KdY3musLqwU7AHuGFgDk3o7a+ACikigTF0Jhty6lH9WmNNl+PH2eB9WBjVirsziW6Qeq11
	R964+Rx1/D/hGIoW6cCYKRm+8XnU6us=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ObqNUb3r;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2199D625D4;
	Sat, 14 Nov 2026 17:32:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F9E01F000C4;
	Sat, 14 Nov 2026 17:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794677521;
	bh=AljFBfIqcD1ZWecoMIIEjM2yrPFU4geEAa8J3J+RzSI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ObqNUb3rKiS4yM6Gx8oWG4UUqxI61uIvOXGmQ5kWt6uCoyS6klGsYFAfIFeZjQK7Z
	 WmodSxBw2K8Gc7zgtTpEDad5gKA+SXjpbSL8F36t3CGb2c9u4LYPinBOj4tluVSh8g
	 cZNAV50PT6+QvQFvppbopy9lIinxs1Sq3vyZ2U62s7bmDVYWa6bHKnsrOO/pBVabK/
	 myCdflNoBM5deUNg0EcV2g+NndbsfDXCR/xJalleom0x3NppP8fBJXFETJ/msTOljp
	 jV9gpvzRpQTmen093PZThK7Lmzd9W7rA1CFZAobft/EkWhvP1vxu2BOxJUvMb523HW
	 3bH9Z8rz1R7PQ==
Date: Sat, 14 Nov 2026 17:31:57 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: shao.mingyin@zte.com.cn
Cc: akpm@linux-foundation.org, david@kernel.org, linux-mm@kvack.org, 
	virtualization@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/balloon: fix NR_BALLOON_PAGES accounting on migration
 failure
Message-ID: <avia_XgVOuN_pZ72@gremlin>
References: <20261115004708909xx05JgB9nXnOCG0zL7h_K@zte.com.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261115004708909xx05JgB9nXnOCG0zL7h_K@zte.com.cn>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 747E640006
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: eody1qch1kepstjwchfm35crbatqcqma
X-Rspam-User: 
X-HE-Tag: 1794677523-289776
X-HE-Meta: U2FsdGVkX1+yV9RG45TnM0XuRsviMIix7I6mLwDLhWmkuzrcWj0d05cB3b3LIMXiDKQdc/xyfU2iGDw6PpCEVe8PJ0wFY1T9o+VPiVYAJkQOVYpOIiNkHOUjTH9ZVKuFHK2DOUwwJoVHi3Y5haZems/REBfil0+49hO6Pc3zig/tpGR4adB+UWwhkrT9T2oxH29Y0yipsBYoK9OBy2NhswDQmO4ASkoHhtNBBVyRtpUk4WYDE/zDqyYG5FwgmvTIbrtqUfpo1XTOHHA2Eu9ZqdEekmSNMYwN3x2dMphvQZ+fOeAJXBpIz5XZiBr4hxJMW5WrCnr/4b2ssPY1SRBshIrUs7mPnh708fjrqyeSK5dRS2C+TBJfw07PfSMezfQ3PljmikYLbxapUd6UB7FKd3i4uzWQVsNSYX9z/8Ei0/ANMFsDbRleQQ/CurLrSswUN4uenFxpzj6+8q5WjvOGxqgCpLTUO9QjQalrNsWVvEB8XO6oSUg+YZUHdmdbWJlnQtnCiyWrQTuwMavUGrOzOL+Ss0a6u3k8WOypppPXoU64bZ6V6shGvoLH/bU5aYRv8C613++D4KntkVAroK4b6s4zVRKoDU9WECxJkmuHKUM3RBrmBByZ/vd4sMNOLz2wXXKmdGSqPqiXTtIQXFK6AbZc6Yx0fjQ4u2MmZN1UOdkgDDEZRFseD9a0j0s4i0QTmP+LAIBz8MQ0tTEfDZq+r7tgvhkrHuvFSTS1zroR/VHVyzJdlxYnP+Va0fdV+iIwu3/WeeaJrirrL985A7OGTNbGGx1fFCf36RN7TApvbY+lxiG1t1/ih3pyb8E/Y58+e5Z9yaFTYTPMz6YxJrXmwOBMsaDUSVQGZoHjSCXAnVHGi2z49zh0WQE5U7NqKHWxqxvBiOCHxxTuL5R4B56gagI1egjAln2mMb8AgwHPhYZ3Slyy5LYyVy1eGSQPpR2pYXTPENftbTe3VjMYHa1
 uusSg65V
 bWX02B57fscOwKtIyn8UBQeGR5HkjaznMHuoyAr9dr2zVuu5I8/hc/Mo9ndqAZHb7lLzh36krUBNb54GAsRhRRFPFQq9ApTDPI/TIKFkiQvplRMNMt9Pbv2mPBnvxGYqiBKSSQ3W1xLCeftbbvOwVqwPKq9BulK/pskhakoQCpNBrkP64Vs+07Pd5W4iflyKeQL+B6H+lxQuW9m9qQT+dIXT0TjxE65YosheeX5NVObKCvFKm/3pxm8YsI7gaPaH28sZyCH6Ll7hrzQL8pCbQB8Gswtn1ZxOQKwEaJ1P+76zEWcKAYki2LyUrfliDFEEAb2Ms1dxMZNOp1MnVYm6iiDY2G+8TFqMD3g1J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 15, 2026 at 12:47:08AM +0800, shao.mingyin@zte.com.cn wrote:
> From: Shao Mingyin <shao.mingyin@zte.com.cn>
>
> mm/balloon: fix NR_BALLOON_PAGES accounting on migration failure
>
> A balloon driver's -ENOENT migration result means that the old page was
> deflated but the replacement was not inflated. vmw_balloon returns this
> when its deflate operation succeeds and the subsequent inflate fails.
>
> balloon_page_migrate() accounts the deflation and frees the old page,
> but does not decrement NR_BALLOON_PAGES. Each such failure therefore
> leaves one extra page in the per-node count, which also contributes to
> the Balloon value in /proc/meminfo.
>
> Decrement the counter on the old page's node, matching normal dequeue
> accounting.
>
> Fixes: 4d689474e1b2 ("balloon_compaction: update the NR_BALLOON_PAGES state")
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

