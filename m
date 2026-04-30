Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5BB6FF8875
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 03:26:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 578FB6B00BB; Wed, 29 Apr 2026 23:26:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DB496B00BD; Wed, 29 Apr 2026 23:26:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E0896B00BE; Wed, 29 Apr 2026 23:26:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0FCEA6B00BB
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 23:26:54 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CD7CDA0294
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:26:53 +0000 (UTC)
X-FDA: 84713785506.14.D3BFE51
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 34899100007
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:26:52 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Uv2UWaUz;
	spf=pass (imf05.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777519612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+CPBc08APA4Bjo8uGnoOayzoN0W1iEMf4UGvoJoPqhI=;
	b=F4n/EaeQJExkDI91rOprw4DsymXImXR1YpysjRDxvjBQlTGfuROspcxwW7SO4gD5ZAn5vo
	kdnp0VVqghCKatLe3RiYNcM4x10OIoXf72V7VnansfrsRlywA1oT2kUvW4hYNyzoQGO7wW
	1HcMSbSl6CjLHMpPOVAbjtlOLYFVcNQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Uv2UWaUz;
	spf=pass (imf05.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777519612; a=rsa-sha256;
	cv=none;
	b=Yb1q7k0kBWdwTEOh2iO/9XPytUCCpPIQflfT8HQQBeaT7ipKcctM/K/ho25B05OSqgy3mT
	vaJV8Kee8hslzLmHMywzpADMy8F+TtD8PCzcsNXiiele2gprdbvCu3+9IqZNK5rp/O0hzi
	UayC1RJHScZDI3f7QylB5iPS1xEvmx8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AF4D761336;
	Thu, 30 Apr 2026 03:26:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62B9FC2BCB8;
	Thu, 30 Apr 2026 03:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777519611;
	bh=VshiWipAYtRyMnsD8HAzk//9Evvgk9O0E2BL+Z2O4pk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Uv2UWaUzVbUyIkgswzPmfhdYjkOpDsLPU3O/WJGYuLPii0uH5tUW/52XxirKakoWd
	 UOuM2PUB7KOW1bgwglcr822uaES5i7LcF+WBOwNRSEheCp/iesotg9S5Mycm4t3zIa
	 4fGTEdM9Oszy1Jxg1CtvOsaJoKHw4RHWDdT87crP/eIybS4+63vm+Q+Yf5sPhl9mCM
	 Z1wnh6X3nJ8a4pe5efyJsskj4Qt+XmWPzBgBT+u1lUkn4POaCvOvYYiHycXgoFQrX0
	 qfjM3O2/8DQFXcpbsAs+5P0iEHUHGEOU+izl980r9KdymeYwT/hPa2KwEk5f9WaTSj
	 GXa9J+FBhfGjQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B9DD43809A07;
	Thu, 30 Apr 2026 03:26:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv7 09/18] mm/hugetlb: Defer vmemmap population for bootmem
 hugepages
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <177751956630.2274119.12592851885920371218.git-patchwork-notify@kernel.org>
Date: Thu, 30 Apr 2026 03:26:06 +0000
References: <20260227193030.272078-9-kas@kernel.org>
In-Reply-To: <20260227193030.272078-9-kas@kernel.org>
To: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: linux-riscv@lists.infradead.org, akpm@linux-foundation.org,
 muchun.song@linux.dev, david@redhat.com, willy@infradead.org,
 usamaarif642@gmail.com, fvdl@google.com, osalvador@suse.de, rppt@kernel.org,
 vbabka@suse.cz, lorenzo.stoakes@oracle.com, ziy@nvidia.com, bhe@redhat.com,
 mhocko@suse.com, hannes@cmpxchg.org, corbet@lwn.net, chenhuacai@kernel.org,
 kernel@xen0n.name, palmer@dabbelt.com, paul.walmsley@sifive.com,
 aou@eecs.berkeley.edu, alex@ghiti.fr, kernel-team@meta.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev
X-Stat-Signature: fujx6yt7sozzdsd8chmy7j76dp1h19a4
X-Rspamd-Queue-Id: 34899100007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777519612-813040
X-HE-Meta: U2FsdGVkX1+kGYrwmHJqlezwgcNHIBUAvylXvxDO3fnxGMtz0Qr6tSTUmdZ4woBxAtVwBlHsoQzjnb+aZhkax8xdCTXuboCMYuM9xKifxuuY8KJ72q30b0qc2lzeJndTyAtBI7OQLvOtUeVLcBvwlm5V0nrgCbi+EtBJ77nFQsdzhKSOyyfP7rVvXdBZYuw3tONnbkdkv50MEZKO2gcZKUBiAVy96iHdE9qZ3NW7wVteBVXhbwY/5gaaAKuJWxw5vTbFv8j91ssKu3u1GTbiM5IGaADH6mpINhGz6+JzQoDi1EUi3NYzQYXgxJEMwgAIDR6H7OLtDhII6H2uizEg2/s0C8B+zamrNubBdflWl3PRkMl6T7wkvqdXfcG7qgq1Nkr3QpOqATakRWEXML0MnECoOuJne2KL+OHyAoEeQAWRy+FDcwxKokE6VT8DYmu4C0Lkz1hSyScpiXN9dM52cXZvKOInc5WpmVEyIZaYlEPja5XH7y/ffErE/5R/m2k0tqwlmB+y8poCrQ9R945jzLP4+roFxh6LyF+bzu41eeBZenHA6BHVfNEaS/s/w6BqxgzYEGVEurJvbb+MBFLlG1KzZtHBzG/HCXsBQnjVJvgvfenRyPMVqgG1DTmT7jlLOGZhd4JiJn9oy/x7nAtmKNka7WNrFpKgulYD8vRAuv2iD/ldVJOutDL+dgUFsjNNVzeiLTh+x8TvInj/T4CwENY6znP7vwDym8zBkGTuv4SZUE/eKuBVaSTJXWWpPjYJgom24KGngn9/XP02UpXjPTiPCY7/i//yPtoiqlj5o+ITU6tJB+f2NJOjMDxW37i4XaUT9MCX7vCpqsrdgwqTf0tGqRvAseCgCBTjtw6r5kKy+pihYJLi6xfZqFrkxwTrk851a0j6ngGOwr+PBexLCHm1dUNwGo4G1ECWpJhnWIYEk5Ekh6Y9/FWKaOF3Hetd25kIizOhCE30c9eDLDj
 B6pHFilC
 5ynubqWqiZwFvNzhHPOn84SQHmMhrCGOCfvUUQhnSRUl/cNQLw6thcy8dOYhlAm4CkMhnXm4iYiWhj7g8P+2TeCYPi+OSiUqEac1whvx04v8D8f6PS7iWsvLf+HwnuBuWE1/Ey0wzEcBaLYJPBQJcN2j6Beg7OKkszx4TVB96+eSYz6GfcE6sMLmmh8J9la8iZBFuTY0zE5x6Yx9v3NX0Ch2NgiPZ+dA4eARj/77mhcA4mAK3PfUotHojbtWvG7kNAqEj/eeRWh6UsxyNTk4hFH3Lx4zuhmRbTOf/lhsUWFpkos350V5pSiROkZt1dvSJieBMmHWIMO7RA6Kiwv3yV1bG/QO3k4uoS3TKY+lFl4hliQE3wpdC+TPw9VukWD5jRq/l3gHka8GB5qGMa9B2O8wpQaobTU3U8C+MJTEk+xON2M7j4HJYNLyQGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This patch was applied to riscv/linux.git (fixes)
by Andrew Morton <akpm@linux-foundation.org>:

On Fri, 27 Feb 2026 19:30:10 +0000 you wrote:
> Currently, the vmemmap for bootmem-allocated gigantic pages is populated
> early in hugetlb_vmemmap_init_early(). However, the zone information is
> only available after zones are initialized. If it is later discovered
> that a page spans multiple zones, the HVO mapping must be undone and
> replaced with a normal mapping using vmemmap_undo_hvo().
> 
> Defer the actual vmemmap population to hugetlb_vmemmap_init_late(). At
> this stage, zones are already initialized, so it can be checked if the
> page is valid for HVO before deciding how to populate the vmemmap.
> 
> [...]

Here is the summary with links:
  - [PATCHv7,09/18] mm/hugetlb: Defer vmemmap population for bootmem hugepages
    https://git.kernel.org/riscv/c/209e6d9eb13a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



