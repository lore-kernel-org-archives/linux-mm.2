Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2F18CAC597
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 03:16:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C1A18E000E; Mon, 15 Sep 2025 23:16:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3995E8E0001; Mon, 15 Sep 2025 23:16:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D6788E000E; Mon, 15 Sep 2025 23:16:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1CB5D8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 23:16:23 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A6FD411ADBF
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 03:16:22 +0000 (UTC)
X-FDA: 83893650204.03.A026E08
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 15D6340002
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 03:16:20 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=qLiL7R0f;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757992581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=su8v0JJisc5ExLw2TdJKF8rbpdBFuukhtFLzQevQ5cw=;
	b=xRmMpY7noRpr69OaEqFWBfsVqM39CqQdkehDGc6YV4pPlid3yVEWYp65qa692QzChBK/2C
	4mpvnwqMYmsmpaVmom3MulkdnpodNMbAhlDpdqgVj7DM9d2HYIDr20nLveotzmy+BlnmbQ
	eIFE/XKe+IfCLY+1CVHZ3d7tmpOP9Eo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=qLiL7R0f;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757992581; a=rsa-sha256;
	cv=none;
	b=qpwzNk9RBIoHu4KlS/vcby9FTnVeFEv/O5+BWkvqoWxcIoFNQjh9SZrwiD9mFi6CDuOuBD
	BoSiaWLN6D5oQ4mGscphjEChlREaLbwCT5raRp6adPDxyhzB8NjTreIPs4hMVM2nSpQOgI
	iCP7PAw6xkPs38o+mkvobS6O196LNlU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 442316013B;
	Tue, 16 Sep 2025 03:16:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE8A2C4CEF0;
	Tue, 16 Sep 2025 03:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757992579;
	bh=KQgIDFeYj6BfahlWkfqkbzH/E4fZL8fqkKbPwk5VHm8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=qLiL7R0fKERFaeUDekpvnT0bCQ6X1MJ36FqoZwhuZrNzvtGm9MkQu9m08+MI4WZwM
	 TzBCMurJMdOsYoEgNdNN3ZGQpUPubYUYOjWvvM/9imNNEYhG6BNYZqtqjDxf7V2NNc
	 F/gly7u3moLwHxdh8lc10HKrP88+9PrO3jsPjU6s=
Date: Mon, 15 Sep 2025 20:16:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kyle Meyer <kyle.meyer@hpe.com>
Cc: corbet@lwn.net, david@redhat.com, linmiaohe@huawei.com,
 shuah@kernel.org, tony.luck@intel.com, jane.chu@oracle.com,
 jiaqiyan@google.com, Liam.Howlett@oracle.com, bp@alien8.de,
 hannes@cmpxchg.org, jack@suse.cz, joel.granados@kernel.org,
 laoar.shao@gmail.com, lorenzo.stoakes@oracle.com, mclapinski@google.com,
 mhocko@suse.com, nao.horiguchi@gmail.com, osalvador@suse.de,
 rafael.j.wysocki@intel.com, rppt@kernel.org, russ.anderson@hpe.com,
 shawn.fan@intel.com, surenb@google.com, vbabka@suse.cz,
 linux-acpi@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH v2] mm/memory-failure: Support disabling soft offline
 for HugeTLB pages
Message-Id: <20250915201618.7d9d294a6b22e0f71540884b@linux-foundation.org>
In-Reply-To: <aMiu_Uku6Y5ZbuhM@hpe.com>
References: <aMiu_Uku6Y5ZbuhM@hpe.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 15D6340002
X-Stat-Signature: maa1howeouc7u13zagrd8g94k4n5qabz
X-HE-Tag: 1757992580-185678
X-HE-Meta: U2FsdGVkX18ThPHul3oEypt6ERRdGaVOfZBgG6Ji4XZqVrIzL+sq3uoItIfkNDR2yGaICpw2AMi/1eiJfxe8+F9Eo63nsvoS8FHWjnexPuPcVkrnXi7hLW/V1w/1g/M4LmMpvAu2vxSOWumYtNFf3Ue1ia3ZMbFoKqQDHS8zIb5L7/cC1MqsB7OMlC8J2mSpRlbgBXXjmgfZbDpQlR0R9m78spbRkm53phQw6TOJodtETg4BNcP5xmqYHg17exyNnLWMDy1wdbBQ0iQ9OwO4UPWijoEejhCJl24YKsAHk3galAp/+RMWK4+qB8vxI9AQV5bd8nt0XhiJe4LXqRC6C0BUWKmSF2W4zsJD6MERzWEualHCd58dMeBcp+Mu1O/ySdPdX4Umms3EPZKc8v3Ly4pBuU7vM6W3IppEkTciUq4AW1j6YX0jlYG433g9ApxHLANL5OUVaEiwcUa7u1/3TU08KdMUqg9t5QfTzFElZwXY56p1rgvdtvPP/vTAtC2T+wrHxXDcva2RJy7mPi5BmAAuevj+tstcRXyXYwhIkeEDLJKCi1hFGPhLZJ6URoUwqHhfOA0Cp8qx3zgzCqHEDH3c4NU5AyP7LR/RPNXwSRq4RIOjxNKMqSZHm+uW9OFHVMsULT/yqvAl0/gFnB37WgWd/qtsPIJCadOsh3wwuDv3cNBpO5mWAOKkAF/fNLerWfXbnkL+hXTDAfa/cOdxgmixtt62crdUs8038v9SEpjxcQ2LuWN+AqA/zvrnhOzxzFVH083Gd2sW/D3DqCV9llSccjcxm1vdAcVwXKBhCmPgxK02CjzYgmd5F6xZb9yGjGiB2KBPpQ8a88qFsRNUYEGWlr4O2Vy+nX3sANrP417TZKcFtJoBGqyVeDFmf0etwAyHfNJIKubA7Iq60pFVD2SY/dVDr/T2OGXFsFaizuCPD3C5HI8k61aMx7TNQHpt9MOBwHAo4gl833hIg/e
 HkQ2louW
 cYMS2ucTJ1ecdp/oT0XCINMNX/TM9sEx0Tw8UmR5RgzbQeezxfST/ify2TOByc/yGoD2MUWDXJu7K1+dxTMiZdvhWpuN8nAzCFM7aVaVlCKBKSN0QveccmHF2+zlPEHk9iDkWevd8J2PwofET1jLdljCxc9OMnCvMFLtBKusgBJcKKPGBQwec7WBO/XD4J11KFkigWaorOzbq20q4xoTcBS8b4LPKeBW/IFemDPmjBvg9x1rZ1uKSotzsGT3YS6ATU98oyNEDjvj6AUhm58PyMqKjbBzudMP+SSBJWaZQEAyY3yb1Ofd6C9oVa97XTsIkCLFh576X9jKIY65obU1CCjxGwDVA+yCQEKBFfkdgeA2ZZAqHu9ivkbOi/g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 15 Sep 2025 19:27:41 -0500 Kyle Meyer <kyle.meyer@hpe.com> wrote:

> Soft offlining a HugeTLB page reduces the HugeTLB page pool.
> 
> Commit 56374430c5dfc ("mm/memory-failure: userspace controls soft-offlining pages")
> introduced the following sysctl interface to control soft offline:
> 
> /proc/sys/vm/enable_soft_offline
> 
> The interface does not distinguish between page types:
> 
>     0 - Soft offline is disabled
>     1 - Soft offline is enabled
> 
> Convert enable_soft_offline to a bitmask and support disabling soft
> offline for HugeTLB pages:
> 
> Bits:
> 
>     0 - Enable soft offline
>     1 - Disable soft offline for HugeTLB pages
> 
> Supported values:
> 
>     0 - Soft offline is disabled
>     1 - Soft offline is enabled
>     3 - Soft offline is enabled (disabled for HugeTLB pages)
> 
> Existing behavior is preserved.

um, why?  What benefit does this patch provide to our users? 
Use-cases, before-and-after scenarios, etc?

> Update documentation and HugeTLB soft offline self tests.
> 
> Reported-by: Shawn Fan <shawn.fan@intel.com>

Interesting.  What did Shawn report? (Closes:!).

> Suggested-by: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Kyle Meyer <kyle.meyer@hpe.com>
>
> ...
>
>  .../ABI/testing/sysfs-memory-page-offline     |  3 ++
>  Documentation/admin-guide/sysctl/vm.rst       | 28 ++++++++++++++++---
>  mm/memory-failure.c                           | 17 +++++++++--
>  .../selftests/mm/hugetlb-soft-offline.c       | 19 ++++++++++---
>  4 files changed, 56 insertions(+), 11 deletions(-)

I'll add it because testing, but please do explain why I added it?

