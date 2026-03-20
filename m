Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEE31109316E
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 02:15:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF14E6B0005; Thu, 19 Mar 2026 22:15:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA2066B0095; Thu, 19 Mar 2026 22:15:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB7676B009D; Thu, 19 Mar 2026 22:15:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CB11C6B0005
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 22:15:13 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 86AC914083F
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:15:13 +0000 (UTC)
X-FDA: 84564824106.11.491920C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id D3782A0016
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:15:11 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AAo3I+oZ;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773972911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TRcXeH5DniH0RubvfbrPi2+vkZ2TyZelQpko2kEpBA0=;
	b=qvChgyRA4Vm0Jj29oLxDx4WksLaJhyGthG/ZtXoQZ5xpDIuePaaTRw7L2w+itZqmS74Xhs
	HgPo9w1JCAIy1QRXx0iKDA/J6HqEVLL+jwl7CRXOAcVdcar5T2y+KC6Xuz0cseGXozSDqf
	OhvOAIvIM85F+KXl8eV3cBKui5HHUOQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AAo3I+oZ;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773972911; a=rsa-sha256;
	cv=none;
	b=2XUDlbBwYv/OMllyxq3dcKlwum0r5RFCTD9wSN3D3PlxHlLjTCgREQ2F9OPFn5Il9QY9nI
	USdBg30aQ3vCaQ2zPDg+OLVTJpyaLF+U4nsanO5YKEAIiw7AtzQA47c68+dpRn1P/50jk+
	QlW1n9EKVrgCOsvx5dWc5ioRgSu3zYY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DD832438A7;
	Fri, 20 Mar 2026 02:15:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FB85C19424;
	Fri, 20 Mar 2026 02:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773972910;
	bh=nj91OD/B3CaoGL5ifggk12G98qexNB5Stq57IP49ow8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AAo3I+oZMyMgowz7lNyCkY/wqU57k/nnBs3kw9VYAnH9pQgm3VQMuoFsKfxXemz+s
	 NIvzZOtGWwqsPwDFdj8n7r3sMFPrn1Qr+LVXyaZcNAGSbA8U+sFWoNfZF0zLVe10vE
	 BhT4Sk59E8YgWH4sRiokHiN4fvoOfe94Yi5sGkDzcyFZKuvlgpypvTr2Hie06fJYA1
	 4p0lPIh7SdYKjMnA6P7gStFCS6itCfXiVHud/OlPr4F/wk+kLdgWFmBcVreQHO+vb5
	 gVnO+I1lXRVjH+7WqvzO/umATDqc9elbphM7G1fQSrM74th5pQabkS5GqY34CQY2vi
	 XRl7oolIitQNQ==
From: SeongJae Park <sj@kernel.org>
To: Josh Law <objecting@objecting.org>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] mm/damon/sysfs: check contexts->nr in update_schemes_tried_regions
Date: Thu, 19 Mar 2026 19:15:01 -0700
Message-ID: <20260320021502.1218-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260319155742.186627-4-objecting@objecting.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D3782A0016
X-Stat-Signature: jw6x4yjcowfjmgjf77qewpncpdaws4ba
X-Rspam-User: 
X-HE-Tag: 1773972911-625453
X-HE-Meta: U2FsdGVkX1+BI6CPj3xPOkfGvxkIrUN9jCLygHbM9oYXetE+0r3oCSMY2Ba6qr+qIROELD3/Zo+hQYOkHtU0cgXqvnpR+YUlHzmbsqRMDacbUVSZJ7BtN13oAhY0HmV3TvjjDxc8ZFZyxQGW7BcQ2Q2k5scoVOmGW2oiQvByvtarcuCTLLQPhpxBUUZn/+KMIdU5nUoceDFz6X9ii4ooCx/RhiqC8YG9+A08inJYJ/aXYN/fAHl4MODY30qbY/tPNzLkPnyeKEsaOTmTgEXcqNqhNuEkrTPKruGd/0Aw4lXud0kyE2LvKyRWn1VWFq3fqgcPzlETUmCL9ADATlpJtLZvr7WyIv7EewuRx32vjX5n76Xm4HZtsLErglMoXTz+8P9A7nkGnZ5mzB9jHwnL8uG5t42hGWhBFo2sgmRZnnzSWTdzC0jiUid5w88baHCcyfQOMEPnhN1IXLRZlNfZJiDfnlVL8vBbOigF6u9ufn54gAPpTGIw9OB0PiCOZYwa4dJRD/j2a7YyPHM/ugGzOsUrnFyTeLWhuGjhY2WOgKKCEgsPDTTy1BiD3nujC0DZ+ErSlX5ttR4QkYdjDfnsmb38m6QN8TPsLOfZlY52p7DCfYlMUJ42iDuP647gsWFPF5yFkdHeuKldV905iWimvJ+76WrAW7adRd3BW9utZHfgfGp0AJz2VU3LAOTcrpnxfSzYO3AgxXOi2bzhUinMxB/9SaKlUiPzghxHwjM2kLpOxYp6t/gZ78oaE5ptYB7JUBbU+Q8zH9XzppQRXy0UyCTeX8i8bhSs66NdwGxI6BcUS/oIl4VdrbKKRdSQGLoMxo3QWiOK897s9lszvv3WZwAcn8SlSBfhEk56DVlJ6yZPU8twNe0G3//fxmSNBnxhZrsATCmbB2dPtxe8zfWnt44YnUBwMXFOBYzlYpOBikwgYSdkz3J1n8nIugfme/AkBhnhKm9IFjNKMaQf9JE
 WvjqKSk8
 F1T/3TYHw1TbQvV61y480rY5R6PJYBmEhgjqvYyypOjYcxKitVJCdjVEl/unSP1Ig/LsDwN0I9drE5H2snw2hhuYvYsOsziZ9E1Vac6iw/b6OGTJ7O0xkW3YdpMIrFYqHT+bhjEwXXffl0cr4QbLsIBWABuDKXLT38u1mXELZ6nAXKNUGNa1xT71wphUYtBXmehWwAcbdnUXmxReMrmdOsRBiEISgx657GqEjkwpvDTofANbhfCRxBfgu39yqEuN3AybV39/7FHCV/LpdZ5Aul4ORrRcFSSLOSiIc9MbU4lmWCHG5+VGMBtchJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 19 Mar 2026 15:57:41 +0000 Josh Law <objecting@objecting.org> wrote:

> damon_sysfs_update_schemes_tried_regions() and its callback
> damon_sysfs_schemes_tried_regions_upd_one() access contexts_arr[0]
> without verifying nr_contexts >= 1. This can NULL deref if damon_ctx is
> non-NULL (preserved after stop) but nr_contexts has been set to 0. Add
> the missing check.

Nice catch.  This can be triggered by privileged users.

    # cd /sys/kernel/mm/damon/admin/kdamonds/
    # echo 1 > nr_kdamonds
    # echo 1 > contexts/nr_contexts
    # echo on > state
    # echo off > state
    # echo 0 > contexts/nr_contexts
    # echo update_schemes_tried_regions > state
    # dmesg
    [...]
    [  222.362338] BUG: kernel NULL pointer dereference, address: 0000000000000000
    [...]

Weird sequence of commands, but even privileged users can make mistakes.  So I
think this deserves Fixes: and Cc: stable.

But, this is just another instance of a class of bugs that I mentioned on the
reply to the second patch of this series.  I'd suggest fixing all bugs of the
class with single fix, as I also mentioned on the second patch thread.  Let's
discuss on the thread.


Thanks,
SJ

[...]

