Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D943ECD4843
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 11:50:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F88B6B00AF; Mon, 11 May 2026 07:50:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A93C6B00B1; Mon, 11 May 2026 07:50:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BF9F6B00B4; Mon, 11 May 2026 07:50:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0E50F6B00AF
	for <linux-mm@kvack.org>; Mon, 11 May 2026 07:50:16 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B1AA21A06ED
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:50:15 +0000 (UTC)
X-FDA: 84754970790.15.9B01246
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 087B818000D
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:50:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VKrYqt5j;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778500214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m7yW+M0YdTiadMZS1FEXwe1l52EjJ6BllUc8Ghq9wfw=;
	b=wF1NvVcSFH3PHZdSEn/fK5JIZnFcqJwd6quA2kcOk6HczVzIjqOJYd5cUfXlbCfzwkaY48
	u0JJ197T0OBILHgtsi1LnzHX0j8iUAWpuAljcRXwJ7m1Rdy7+gFAU1h2CqdjuPU98/6qFZ
	Cqs+iP8KhtDqURvjTPjnnamRCER1/Lc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VKrYqt5j;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778500214; a=rsa-sha256;
	cv=none;
	b=M3XrlcPPKd/dBE7GpS87OT61F1gOdCyPQEt49zVGpdtJYLj2lnJsnZivoWrESdmme38ct/
	ZZN82ultvNQmgkubD8wJkjFudjI26AETJ8v4/Memi3sOwghzow6n4LYFuVtMj9HAFtcCkV
	LXyDq5hTI6t+Vm4zZDoDHdDnHZ0aHPM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7B77C60121;
	Mon, 11 May 2026 11:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F409EC2BCB0;
	Mon, 11 May 2026 11:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778500213;
	bh=iB75dfhb4fu+7jIbarv8WN6kU3hlr/3nqfnDZ8XmCUM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VKrYqt5j1WNBcVraimWDifAMr/mJg+yvi6st6hSJMhpFMGulbasH1JAIHPmg22mLf
	 SfM4wHr9M6VThKarworHqrmfr2eQMvp4dB/1YVDhv8u7ruhqUpNAyVwj5hzRqQax5f
	 oABxKuiaJh5WjUm1V9yO5jWVBnDS9toYqIxQ5VivKVNipRlk1r4lPnteR7dtr6Eoe5
	 DLtaTOmVa6hVjcf66yKc+Kx7InRklF2sRSXKUHTabpwe24oY1X7pju19pdJPfBaF0H
	 P8h7UzZ3q3/S7uovgEFffVewlsQCQP5hSTZrxDRAououlkCxcGEcP5y/1CGbq9H0QX
	 HOODyoL/cQFaQ==
Date: Mon, 11 May 2026 14:50:06 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/12] kho: add callback for table pages
Message-ID: <agHCbpn5Hn3XsEWH@kernel.org>
References: <20260429133928.850721-1-pratyush@kernel.org>
 <20260429133928.850721-5-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260429133928.850721-5-pratyush@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 087B818000D
X-Rspamd-Server: rspam06
X-Stat-Signature: 7b3npru1gw61mt4h9mygotg9dch3sm5w
X-HE-Tag: 1778500213-876953
X-HE-Meta: U2FsdGVkX186/LPvf07W7bC9lhJ1K8ir9cgJgOp8C7lLh3bYrUJszLe55WKlJrCJdC3McMLZA0dwJJyM8RiQTz4Lse5vcGyseyR3Yioqg19wpGeS726chFk3kV5dj9Jamj0EJIA8LCeMx2PmgufR0Zg2xdq2hvv4Dfc3i9KANFe+KzPtuzSoZaTm0FpqcE90qs8HodMbOvXBz8DV0oQxL/+5w9yemu0W1hfGJ2Zi6HGIgLwOOJMsUvYQAWqoXEmYIwZZsCpRXGkKqa7/mS3tRC8KwpeKI9yOvN39XRDUNe9XfQUOFPt5Ye/TfQfibMTFeu0/NswBjQUKS85gbP44BfSBaQSpkW4oI91OIvq1PYgnD/WADSFzdGdttN+q7f6A2Bylz2VSZfVrSkWXwQCsRvZTpdI3Y9x9S5TJP788FHFNvClif/CCi7gW2CpudG9Hev8wUF3hv07D46C43wp2w5DMEwR4arrAwC+RrcMNcA4q37ofZ5Gh+CCCEox+qWphtik84wjE1bem1N6R5LFUcYE/K6VcI/2Z00IGyBYCYR0BsIl1LsqbbtkKaD7wDcLvM8tZx7l9jlNudxFfS4X5hCJEjL4k3PKsB4eumtha2vJE1VV8n6/8Fpxe39aNSg3I+LPTdtgXmJH0sWGpCU0QEnQk0P8fENsgE2VfUSa3lpwwqlTd3WuEXZ/vwfm1ux3DP0uSJcFfXjEbW3Y3jr0WWfuGT8mgneefY9KfLnEhCWsPlyK3NzqNDE1IWkQYsuGitmmGumMm3L+vhB0ybC5/Fky81LeInCWtxI+MC4UdhNzxcIjhkZQDaWW1rMSLn7FTZXppjLLd2mNow7nv83neeD1VAZf/bs4MHY9wlaYJn2G3YnVr4VyV0FxKqt5rZJmSUN9MiyvwmhtTBp3w/3YFr90ZxKS5qIqf7GTl/CPSOA5RJ+/h4pygqOjsxXA0aCytpchkiGQRUMdB3kF0qMT
 2/LEB942
 z+5QRmCh8bt7V40PWHk+7Mu9wm1BI+yWIn+WtgjN0A4uaOTfd39pC1/2D9fQk4fGtEXw50jLDd8NGbHJBqG/GswY9O1X+YYAL+cBL5YG/foIIv9sPvyVf3I+mEUZyIZFie9w9Z8iFh9UWQBapR1tb+l5QIfnTsq78opyaVDhSgANKx4OJUfZU67ta7ri5VTdd0uiZHi+HkWM0/2ltsQhO99xITfVG39/H3FBk/xykwK4FU1Jn+BRr1Na5tg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 29, 2026 at 03:39:06PM +0200, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> The KHO memory preservation radix tree does not mark the table pages
> themselves as scratch. This is done to avoid a circular dependency where
> preserving a page can lead of allocating other preserved pages. This
> means any walker looking for free ranges of memory outside of scratch
> areas will ignore the table
> 
> Add a table callback that is invoked for each table page. The callback

A sentence why a table callback helps would be nice here :)

> is given the physical address of the table page.
> 
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> ---
>  include/linux/kho_radix_tree.h     |  3 +++
>  kernel/liveupdate/kexec_handover.c | 12 ++++++++++++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/include/linux/kho_radix_tree.h b/include/linux/kho_radix_tree.h
> index 030da6399d28..fe7151d89361 100644
> --- a/include/linux/kho_radix_tree.h
> +++ b/include/linux/kho_radix_tree.h
> @@ -37,12 +37,15 @@ struct kho_radix_tree {
>  /**
>   * struct kho_radix_walk_cb - Callbacks for KHO radix tree walk.
>   * @key:      Called on each present key in the radix tree.
> + * @table:    Called on each table of the radix tree itself. Receives the
> + *            physical address of the page containing the table.
>   *
>   * For each callback, a return value of 0 continues the walk and a non-zero
>   * return value is directly returned to the caller.
>   */
>  struct kho_radix_walk_cb {
>  	int (*key)(unsigned long key);
> +	int (*table)(phys_addr_t phys);

Naming is hard ;-)

>  };
>  

-- 
Sincerely yours,
Mike.

