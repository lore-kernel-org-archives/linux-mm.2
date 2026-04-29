Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25767FF887E
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 14:57:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A99A6B009D; Wed, 29 Apr 2026 10:57:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5810B6B009E; Wed, 29 Apr 2026 10:57:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 495F36B00A0; Wed, 29 Apr 2026 10:57:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 385976B009D
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 10:57:28 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E03B11A02E6
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:57:27 +0000 (UTC)
X-FDA: 84711896934.01.36BD3FC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1E30DA0004
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:57:25 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZT7h2jKt;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777474646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xy/Uh10sx0c/Gp/UeCsZzKWC1uMjC8AZ7vAnmTqmRlM=;
	b=oGZUsfcLMhBAu2RMBuQyEmCDs11NfjNskPsnuACZmwA1fyg7KCWiBktp2rSeAQLoZqPWrH
	CS1tXc6Webx6/0PORmciwN6AcOfgLlX3T3amAq1C1cdszVzpvr1+Lf7W5HFvXq08rfhb0R
	5XthXnKxyYpe5fihgAzi4RPkgEZLVO4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZT7h2jKt;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777474646; a=rsa-sha256;
	cv=none;
	b=tF6LxwOBTnA1Rm1Y8ODHr4H+mAZjokqxje2pyawndAsSBS03hEe2nc4tgJBluLt4XTTrNL
	D6gnoex+UJYMOKPuY+dcEAfDDPzKf+6FnKppK2cxtBD0u8JrlC6Njox6/WCIDc1d6YRd1r
	tjjCHYWUdUcDqTw7CzK7iDJRa7LDZ7E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 89BF560138;
	Wed, 29 Apr 2026 14:57:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D175CC19425;
	Wed, 29 Apr 2026 14:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777474645;
	bh=NlNJ6ZE1PtVHQsujI8aiMe4rB+6XsGkXf8RSunRrXUI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ZT7h2jKtezIYqQe+ESZxeDe1Z3QaoB2gaXbMeIPypYqY+hjd31tIw/88Ipnzt94/M
	 vSWqGo4F+8jJCNVmxIe8O4Ydv5j1TPp1ez6ix3/6ErT4+WIMDGEcXYWZcy0x0dVTcF
	 SLChFWxLI7k996tm7v3moitsx9QGpD7DRfSJPw7A=
Date: Wed, 29 Apr 2026 07:57:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vineet Agarwal <agarwal.vineet2006@gmail.com>
Cc: david@kernel.org, ljs@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev
Subject: Re: [PATCH] mm/khugepaged: return -EAGAIN for SCAN_PAGE_HAS_PRIVATE
 in MADV_COLLAPSE
Message-Id: <20260429075724.a97a964003f624e47d9c0a54@linux-foundation.org>
In-Reply-To: <20260429140434.439456-1-agarwal.vineet2006@gmail.com>
References: <20260429140434.439456-1-agarwal.vineet2006@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hriu6rdof4ekwmwssyjo98uc51w3riiz
X-Rspamd-Queue-Id: 1E30DA0004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777474645-803021
X-HE-Meta: U2FsdGVkX18s1Da5hDT3NOltICi1RI0y66QjyLaH5twKzG7euSff8a+diBCGAsNXrTI7wHKqqdpr84fHcdcNQ8jVke3SpfwG3OzPQiHuURT7P6BRTO8y7aKiivzeTQqTM46xBz56jdEKScTmgAZ3PW3L8XYkcPiGdD/5w5TH2q8gLUDkSxu8Tzn7NAkwqyYfOGxtZm61g/nxRD4Cr2lsq65iKQYIRKpr/mY743Lz3p9UNKiO2VBVcMK2eIem8IXicifz9FNjMRbqbESNky/MqzkBkmYvrOXlMc4uqSHfw1e1I4h+05qoKdfdoTr1otnI9cOGslY3f1LIi+OhltNBec5KVhPLa4hqaooxI8cgzJyQcQ4yPjVNsN3vgjPFpA+Cm75+py1Nhd21zCkWetxBiQ8k2Ardvbkn93sHJkhjKVY53MxKf2f3ejRRbC7VktLAKPufmEa7YBMirsODQlf1klvzvANQkctx0vlxTCSomfuQiY+vrwTKCsbfYzPi4ga78QFTgNG6dweVLW6n3OWNemDlr6aJ3gZDfwlQJpAWy03ORhLUTPI2VjZ1sRFOMdHRIqlaTFEZ62AOuZuNxQCy3wz+/vOhjp/p5XEdksWQR6YE/3tDDlqGJ85mBWBfRBk9ONZDh0OTbcje/ZSgfYhtQW7f+S+gh2NR7dncY4i8o7KVW73vx23DQCFX09x/F9ufnM/twMlBKbk+A0WmFbuVn5XdQ6Jyye+X+3jIB1etWSfh8/FCgEsNgkg3exrgtOpK2DBFqr/iq28FlCHwIQxqPbiOfVBpxmdcaS+Y5Q2gvCz8CISrOks9YjCzm8Bh31/YSRxyUaJRlvOxam7snIXU/S2l6jICMlTJ4qQZgycAY0PQDHe8yRNxuT1Per1svfX9d9H8t/8NEivt4pEjs7bxyMbLu4OinpPzCORG+8ABmxrr0fmNVM406m63fRz6DDQ3vdf7qbqF9XlA++RruTj
 iSUbaURN
 YgrcbNzVNRUB3+ygBXAMZWcjYVqZCVTPoiFMi3lhpjhYS+rGbFUCfCkHh/hEzJJn7lhYtnD/Cgx2JUb65MmmFvBt3NypnFiLHSO/i6kbRoi9oO+n3+iqWreCx0bc4Fs28EASEkHQYEqfFEZ6KF/doj5dSRNtg9IXgKb5DGQRFHDyl+urdXDJM6dgX+CoEs3Om7l/gJDKDEDbklEsBf6OVz774lJvy6V5LnzQwXI7c/s/WHxNh09fxHY95lfHzT/SNDnGore4os3dQ02JHgw4LlbcZ7tNllOvfhlaVyZ86OOlopXSP+T67ZRbPzFtH2jp7s2l3a9WkjNtcrFvMolkRhfBbpng1DolBYLLJHSK8Aco5TzKCgLVf07iHkha8vcRh7JyhitregflWB7U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 29 Apr 2026 19:34:34 +0530 Vineet Agarwal <agarwal.vineet2006@gmail.com> wrote:

> MADV_COLLAPSE uses errno values to provide actionable feedback to
> userspace. Temporary resource constraints are mapped to -EAGAIN so the
> caller may retry, while intrinsic failures of the specified range are
> mapped to -EINVAL.
> 
> collapse_file() returns SCAN_PAGE_HAS_PRIVATE when
> filemap_release_folio() fails while isolating file-backed folios for
> collapse. This currently falls through the default case in
> madvise_collapse_errno() and is reported to userspace as -EINVAL.
> 
> However, filemap_release_folio() failure commonly reflects temporary
> folio state rather than a permanently uncollapsible range.
> 
> For example, ext4 returns false when a folio still has dirty
> journalled data, btrfs returns false for dirty or writeback folios
> before extent state release, and NFS may return false while reclaiming
> filesystem-private folio state.
> 
> In such cases, retrying MADV_COLLAPSE after writeback, reclaim or
> journal progress may succeed. This matches the existing -EAGAIN
> handling for SCAN_PAGE_DIRTY_OR_WRITEBACK and other transient collapse
> failures more closely than -EINVAL.
> 
> Therefore, map SCAN_PAGE_HAS_PRIVATE to -EAGAIN so userspace receives
> retryable feedback for this temporary failure path.

Seems very reasonable to me.

The madvise(2) manpage could be a lot more helpful here.

	EAGAIN A kernel resource was temporarily unavailable.

and that's it!

