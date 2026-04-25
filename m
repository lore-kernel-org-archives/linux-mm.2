Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0224FF885C
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 13:54:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16EFD6B008C; Sat, 25 Apr 2026 09:54:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11FD26B0092; Sat, 25 Apr 2026 09:54:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 035796B0093; Sat, 25 Apr 2026 09:54:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E93746B008C
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 09:54:15 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ADEA7A0356
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 13:54:15 +0000 (UTC)
X-FDA: 84697222470.02.CD62CD6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0BF2914000D
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 13:54:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0kL6sRJC;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777125254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ZoQ057GgHTHJZFfIBdjhqZTkWuihzM7v63pjaY7gqg=;
	b=Lyvi7nf2TAcBq5dLjtcdYlTmlIEqHqUUOkpDL9nX2WCAMeuopsqeJDzjGYKLKEJejAVQRm
	E90x2krU7xjGJ/VkDnCq3//IIQTrgJz1g/pU4IFnRQbkCMe5KNWPRyMVDb9N+nRNL7XTAt
	rcoid2qYhS+iiaQQtwH/71/u4RfOwMM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777125254; a=rsa-sha256;
	cv=none;
	b=tWYbQknFXDmrMbH05vGSKkPX38SUvMLSOE822lBC+JmUWBhA6arbrEywetSLCu8rDm15Wk
	56TOCFiNx2TGiiSEI8ievpV3s2A8+jVy+q3iCTkEaN5U5a1FdrjGRz6XYVY/pZmDxR4+Ea
	AkO0tVhksbVOxAgjp4FYw9nWzxh8uR0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0kL6sRJC;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1E55260055;
	Sat, 25 Apr 2026 13:54:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E419C2BCB0;
	Sat, 25 Apr 2026 13:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777125252;
	bh=rUdHut0GlCu/YVEzg8W+5uhsWoukZ83p9VDTAwAPfH0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=0kL6sRJCj3dAOI67ke33l8+BZ9BD7BTS/8bUUX4bSYv2qyP59nR86sGY0UJYFpdI8
	 CKtIoCkkz/XQIszfcPPWpdeMxrWNl04RsoVZgYpU1gwoQiUUVVynMJK2i8QMptOC9o
	 UYS2TIxYAv9LpY0RdoXAn49G6V+SSxrwVa41bXhE=
Date: Sat, 25 Apr 2026 06:54:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sunny Patel <nueralspacetech@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Matthew
 Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory
 Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Balbir Singh <balbirs@nvidia.com>
Subject: Re: [PATCH] mm/migrate_device: fix spinlock leak in
 migrate_vma_insert_huge_pmd_page
Message-Id: <20260425065411.39842a941750fadab250cd79@linux-foundation.org>
In-Reply-To: <20260425133537.17463-1-nueralspacetech@gmail.com>
References: <20260425133537.17463-1-nueralspacetech@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0BF2914000D
X-Stat-Signature: rwqcb6dekaqns8gjcjx6mzreyoj99bc3
X-Rspam-User: 
X-HE-Tag: 1777125253-489021
X-HE-Meta: U2FsdGVkX19Bi942Z1Efo0wGfMAG5x9PEuQ2R6V/PZtfx9O1xA/qOpBai7G8csQhETfgczLAVKAizwW3BR3sXqO9Q6pfiDN5Wlo3geLK5+595uYjS4mdc9W2wBrzQO0icsxMF8eVMpYHP9urxPFPKomAI8H9277t6mxuCEXe+jBnQCanLehFHPBWev8E+OQy1C9rCvyJFUDyoSIAULwz8/DIeigUAMPwHaCWAX4oPptJDufxYcJ8TDW/ZXYTZzKND+QnUke5CPfca48iyMdMKOIqSi81ZthijsrxMbKb5cayJGV0cES9qUkZGBMnDWSoqVQ8WVhYx6ft47Othb2ZIrg+8kVXfWqfg7lmB4dnqj9iBsOvYmS+lCVg5dHVlhFvZomy34BQfTivDYXRtO7gNNbQbhUOvUwq+Cinphho41laR3lSlAY6B4AT3bm5lhXP2500m9wgl9mGxPnUfiJGUjeGYyHNzPVB6KAQATxBSZADqc9QHd+CR+splJXUpP+tMKdXfhV6Rwj23ZaiDhHVL5uKriRcKjagQDOzmaia32XFnEG+BYUtzP0nee6WTMB2/5qDMOhtOwHgXn+6jJM9yb+07d4dqQULgesFPUExcOtog5kcMECOuRJ1o3yDmbhI49JHWoDi9iifYtbHCwpnHbviVtAwaDz5kOyNIwiHX3Bcj6rdVayIC/G1Hr2ptbifd8HtDT8G6jM8oMzYK9Q16wXFJa+pZcKmFDW8/LdKH6ICRZWqRCabq7NIl6bEWWJ+1WRkCjIUtQK5/mBM+RS6nYZYzKzA9c6S/1mHpictHS3gFFLWIkpTQP4zqsgho/HqudC5ySlSU2G3tEzOfvsVsdhrWXGvSDFYuh5nY6UwLAvJ4zoqgErNuRKI3qbwQ6S9otA3IkRn8uWTEyCbvTwG5Cf7pFxzzS8yHmokQcy6Oy+rMkXFKGYTaTCoOBOwE3xxip34t4JdNOvP2LZU8FI
 ZPvq3G3s
 nt5JN+/R24TESMmVIJMa38uFgX0SkIuETRirhUOKBXakn1hv9qMc9bh6EzS2cYg1HLwDRJ1DEPnhI5qSoSGXa6xr+5P9u4wh5Mm8PQiOxw/DP+vjerTB52WFo07YzytzbZHdcEs5TaW1PgOiJlKCNwAOISGfcbSNSNfJ9emtJ99Cf1dn1HFxNGoORwooO0jpDk2qjUQmZe8PLRWmCeLEzImojEwCitPzXGgSYJv3aNV0KUEO6MVaVJKAUU7hRpiKxLBY99iPuALLvjImeQzSH57EEiaDG/DTwZSKeEdLDqLjYSiLsMHs8oPjloqN9CZDcXzIT8bwDxNxRjhDyzjrbKaVvT00e72f40Uus9tlJ9HjRkH3WCi7OXae7QaXnAMgF7lVAWrJWvd30oy++UeNztFTkTaKs9sgLedwr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 25 Apr 2026 19:05:27 +0530 Sunny Patel <nueralspacetech@gmail.com> wrote:

> When check_stable_address_space() fails after the PMD spinlock has
> been acquired via pmd_lock(), the code jumps directly to the abort
> label, bypassing the spin_unlock() call in unlock_abort. This causes
> the PMD spinlock to be permanently held, leading to a deadlock.
> 
> Change the goto target from abort to unlock_abort to ensure the
> spinlock is always released on this error path.
> 
> ...
>
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -850,7 +850,7 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
>  	ptl = pmd_lock(vma->vm_mm, pmdp);
>  	csa_ret = check_stable_address_space(vma->vm_mm);
>  	if (csa_ret)
> -		goto abort;
> +		goto unlock_abort;
>  
>  	/*
>  	 * Check for userfaultfd but do not deliver the fault. Instead,

whoops.

Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
Cc: <stable@vger.kernel.org>

