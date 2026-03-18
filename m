Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A49D810775F9
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 17:35:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D644E6B02C5; Wed, 18 Mar 2026 13:35:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D190E6B02C6; Wed, 18 Mar 2026 13:35:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2B086B02C7; Wed, 18 Mar 2026 13:35:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B0A536B02C5
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 13:35:35 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 57A14C2C2A
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 17:35:35 +0000 (UTC)
X-FDA: 84559885830.30.F4A2495
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9496780010
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 17:35:33 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="q/ZCTJ5A";
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773855333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pv8QKmylS/xtF6U5UFVgGbTWxgSdd9j5rusCc7iWYpw=;
	b=DVO9cWo+0ksG3fkaOs2KhbzPGG5sAKLfF7kFOmItPV6u6PNxqgDYizCYcgdUUIh7XpHg2z
	8AB0RpxBppl2ubX0bLz2Yec/5BA2jh08j7v7Z8YFbLfQKtM6xrdPT4teNblHbKcmn4hR0k
	of2o1ZVCIaIHptDZ0fTWzLy6P8JEcHo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="q/ZCTJ5A";
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773855333; a=rsa-sha256;
	cv=none;
	b=cShKGl+8pbFNPIracnx4Ase3Jur2uGHDGPZEZ1tF9uIPxL6ISvKzzVIe3KltwGZVOpeQ3a
	6VzIRmTqjAFI06uEGOh8ylL7o+5kYh9x9/VY1f+lGgnCwNHkowskg3347TLGkEOs63CA8y
	xsznPuDmzyDSboY4GGqleHJKChWvA4o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 967D64409B;
	Wed, 18 Mar 2026 17:35:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45B54C2BC87;
	Wed, 18 Mar 2026 17:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773855332;
	bh=pv8QKmylS/xtF6U5UFVgGbTWxgSdd9j5rusCc7iWYpw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q/ZCTJ5APzS11TXeB0XSEQ0d9g+S3g8ClcxONBECuidRNMC0cA7elrU8dimSiEwKe
	 1dWX2hhR5PGFK7TJZzjAB/nIa0Zm8yu4vmzh/40If9hvUT0CBU2plLHdV52QEGx160
	 cSTTEQBEfDjofaVLyXhFvVnO7+mqRdw7rNeGgfvwjXtvef+YcoU+zdHk37stwut1fm
	 i7fvav+e4pK3KNOyGJ9F7ZTCjv/19El3vhVftE2nIU+xZ/vn0YHfx+ESm6J26dheLQ
	 HCVR3VK1o0XRBjv01KghfqJMlWkov2GZmygnZaRCNZKrOQwtauXgcoaYLN8COpxixe
	 wFp3ylkmn95vw==
Date: Wed, 18 Mar 2026 17:35:26 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: syzbot <syzbot+de14f7701c22477db718@syzkaller.appspotmail.com>, 
	david@kernel.org, ryan.roberts@arm.com, npache@redhat.com, Liam.Howlett@oracle.com, 
	ziy@nvidia.com, linux-mm@kvack.org, akpm@linux-foundation.org, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	dev.jain@arm.com
Subject: Re: [syzbot] [mm?] general protection fault in zap_huge_pmd
Message-ID: <e78736dc-b087-49d8-921a-9c3d48d9e4c0@lucifer.local>
References: <69babeba.050a0220.1b2d94.0003.GAE@google.com>
 <cfa40f51-0a39-49e3-adac-48b2709e67c8@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfa40f51-0a39-49e3-adac-48b2709e67c8@linux.dev>
X-Stat-Signature: phpqedabz6bbbw64kboycfmmtnm5nbdw
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 9496780010
X-HE-Tag: 1773855333-74023
X-HE-Meta: U2FsdGVkX19XY05U07i1EvH7gfvFsKjRLZWUvvQCI7pW4ijZR8At9mOteM1pavrXxK/Q83ejaFPr9GD1szgDWeRl2XL2jA6QvfYWT663G7GvqfDWy9mcBJoDtuZnGtmdACDCBfZjEWWBbrAGW3q7hwARK0i6yu/xEMWg7TiYjE+i+1b/jzjoFWiw1eIUECUVWxoCxscS2dlbr2Upkbs0P3XYQLot6GMsrprCxZPnmfB94g6pHMCwS89SxvkmWv+05JLWIv4leuKLdQlfKrqXR1JuYx6VlaOEQ+38jwb/TsUwq9tIJIj3WziHrQ8+l1a6yG1G/Qdc1ysLfUDZGvjzbpD8/g5nPeahzhj3a0wxf7uRCAf6R88+OpqXcmsjGg8uHmJHSHQOQoueZqtPJISs7E8dexLDBxQ/8Bu8rwMnXqR5JRAD2komCQix8WvGTytMaUX7gWJv8H7K8J3+VEWKhl4rARG5HsFlo6Ix/ttP3v+WUeyMGPQIZOdwZS4PXgOPwJuJZjYhw7Sfq5dfFgKlklp/oyxpOuJ0FeiMZLN57SRlCQPwBc1IkkqHVeXNq+8x+JF2VUMzt3I7Ta8s0VBjj1NsC+7zFLaiM9rfu9kIOt4EkgahaZgmMupZ3aPGx5T7TCI5zWDnNP421vMXH5OnXEePIe5dAC753lOaI6nBa39shlWikAuwr+fTyKu/C+Efiu3QmoMfgpelIRiqEG1VpRZWH4ztA+BTSCxfLP41f++vMveAGgOHWNATI4JRMqkjjDmlI9/4H4lXRyLboSt48lcuI0s16QOllyLORnvhHaQN/DzyJ6oy94X98afZ+usP35Yyg9bqSL/dqTI3Qx/+iHcZrhN6M7uNPY0xVoCk3uAdF7IH5Uol3ubw/kG9GzjW8f07sWm7P56MO3jOcUmwOIhZzQtotLcuHH63FX1/7Lo2OnrOhQ7AsTzqWMVRlT6s9/pxztSc/qV8rHQD0Fa
 twto+RRl
 b+hHV97fFRyPmbtD6nHZYpyO7zkpK9wf7OJ0w5fsYep5GRgfQuIDqbOw6VyDDIgX9+IOOUk9QzzbctHqJiz0OdrTP3X4lXDKl4A6s5eMVnYR0/8vvn6f1TBIMdS+jmn/LpKyolJvUAYkzAf7bkJVLsa7J3gPOsHKODDDnesBhR9pcT5kj6DW/Cbg8GvaGiEfeGt9WRmp+ajZTBAAiyv2CNx0vJzog9zQzz6v2W+Afh4mJTRzW7m4fjDG8juSkcbs4wN2fPXAFTzYdMEJAUGrtQzzhh6cDiFvwbpoV4fFzybYDejPMx4DWQFx2sqzIkHqWCdWgfDvpzaX4q//wSfcc8BVT5fzkDvX66WQCpFgG7yuMfSxEZdO/7luuuPhqbXBrp62AEdDAkCsznopjA8Ef95Ml+Cy4RDs5DOMxKojMRHZYTHM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 12:53:46AM +0800, Lance Yang wrote:
> Looks like it hits a general protection fault in zap_huge_pmd() while
> dereferencing folio->mapping via folio_test_anon() ...
>
> zap_huge_pmd() fails to handle non-present, non-none PMD entries that
> are not valid PMD softleaf entries, leaving folio as NULL and
> dereferencing it ...
>
> For PMD-sized hugetlb mappings like the reproducer above,
> hugetlb/userfaultfd would make such PMD entries that can be
> non-present and non-none without being valid PMD softleaf entries?

Yeah, exactly :) interesting how it gets there though.

Even after I figured out this was fixed wanted to track it down!

See
https://lore.kernel.org/linux-mm/6b3d7ad7-49e1-407a-903d-3103704160d8@lucifer.local/

>
> I'll look into it :)

As per above, I already did the analysis on this monster, it's fixed already (of
course!).

I am going to send a patch to make this bit of the code more robust anyway!

Cheers, Lorenzo

