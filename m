Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52422C5DF71
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 06:33:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8822B6B0408; Tue,  2 Jun 2026 02:33:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 858546B040A; Tue,  2 Jun 2026 02:33:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 796A86B040C; Tue,  2 Jun 2026 02:33:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6AF826B0408
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 02:33:00 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0113F1A07E4
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 06:32:59 +0000 (UTC)
X-FDA: 84834004920.25.7CF85FB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id D0B661C0007
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 06:32:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=W8P52rqU;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780381978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ecOjdFR4HTpwpi2FheoaVYHEPZF1UGWfKv+9fr+XvSU=;
	b=4lCT1fqj2vUEyxul3ZlLgqrLRP92ESX/71GSfJSRi8LKgekW7ZBLqoskijUWOvVSHTqH/E
	VVWZ5HWN43UMjg/dQsSDUUa00E0N8INahbmo4y17hzJBVEV+kv8tTWd2BIn5BpVaHqw0tb
	kHP9rSyjk/DnEyRh+9WtM+U6AuHpllA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=W8P52rqU;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780381978;
	b=fjkqU+fCjf2s0txQLn2Q+6TN2UfzpOby1bbXcacsjU6bYpIajviC2h3n+a1yV723JSPjyf
	wqiZ7nE/ldCnb/xo+kwctNzEOdDhjB5be4r0kvINvqXx8xAwY4SngbA+kOgVYz+RsMVgiN
	iEK0HbA6IlU27iq4kPFe8jvssHnQhTM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B8C9A176C;
	Mon,  1 Jun 2026 23:32:51 -0700 (PDT)
Received: from [10.164.19.28] (unknown [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 342E33F632;
	Mon,  1 Jun 2026 23:32:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780381976; bh=qz05PwTA4HuRNr4ARk6c3VjCwvFC+bW1NTje/WkmVPQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=W8P52rqULy8EgMCv3VoHG/oPcN8xzFRTm0MMO+8epoLD09z1j5dUEPlnncU3kRwVu
	 meLb8U698TNe/FRFV0Os10F+xaUpB8p6DhZVBOSnFtbGb2r2bal+bxG9WlhJfvwd6L
	 cPAYBN6mNWM0vhQCfBAe1vL9kyhq4pdOA/ckIRWA=
Message-ID: <0ab810b9-8644-4562-8218-c9a1d4ddd423@arm.com>
Date: Tue, 2 Jun 2026 12:02:47 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] fs/proc/task_mmu: fix make_uffd_wp_huge_pte()
 prot-update race
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Lorenzo Stoakes <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 David Hildenbrand <david@kernel.org>, stable@vger.kernel.org,
 Sashiko AI review <sashiko-bot@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
 Muhammad Usama Anjum <usama.anjum@arm.com>,
 Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
 linux-fsdevel@vger.kernel.org
References: <20260529172331.356655-1-kas@kernel.org>
 <20260529172331.356655-2-kas@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260529172331.356655-2-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D0B661C0007
X-Stat-Signature: fef6oemw4at3yf1ngy9868xqaf9our3x
X-HE-Tag: 1780381977-482219
X-HE-Meta: U2FsdGVkX1+Ys3tIgx1n7Ubll+4mGlyn8g1Z9BRq0BoBkCgEyBqm9fmqaaL9c6kiLkUcgsE0Fycx6tuxy4d+0tQNnFe2sXBrOfl+o54k8wzdhhgGhvemn9Ql1GwPZjIRVN2DQMguq4RFCMAeFfwOnJOf0i722lQ7FddqVudzmBDPHzqaNbfdRFNnfHWj0taQBmJmW8xMnjPZPdvclbG2+ghy59QX8Jh/IV0Kw5JJ17FbODx+WgZsK6QKVhdh0AOcYQuj9IeNB+C+GX6GlAzfbcv79y9di7SR4b/dq4UoecvtColvFrF8tovqlIbiaoqvj5ifVNCItQN/SmjI9ggq1wh3Wo+TI9uoQHZBUj5YzHOVEzrvWllgARH1hAIp7nwD5PRcNLKSySgMLVT844WFrngOCzaMs+HVlFunBDte3WAfO3Iz+wXR9JLQtHA8aVxYIquHVocRVWZm+e9hRSoPXEjpXHD69Qwf22SGHphWlsOdgh6w9LTiD+wmB/ObdcIo/U8AcEmkICe/tUnLYZFNsd6HasttdZbJmcqyFMjSWu3cROyN/Yi3IJpJ1JjnPoSIbopeh71k7qvFYz22Sp+uN+TIUw9acNNbKBP03Ryqwmy02JjS7ERo3SnRQL8Dipe8/V+wnKR4WyxbD99asKBeePtTdaSMRTK+642ugG9CN0N824eQCPiezMiaWQm72Yufsf/Nw+vfej2FO5+O49QJRX6GfDpSEiGxK2lxM8f0OrnmKYQAtj4GL9txN6YK1da2oaM2bFF7sEyt/IpOemiSl/Thgbl0GSP/W1RoZGml7jpUMxCZ0ggkzUAexy9wGiGCRhSxDgFMciLt514GKuYYr9pjuGeEtq1QOAafXB6Jq0wGj5yIbZPOKt4/R/G+fqrG348SdS5ttRZjRUF+Sv3SFCrr5vRqjAU6f/Z0/XlZn7GjBUsPi/yMtIWrlkZuSkuhxJXBE7+A+suogk/msxt
 uMMJ3td/
 Po+Cxi4BnKhJJks1zXdBlPQ6PLnNnthMIXG6lidH3FNxPpA8b7xjLbuqSOKAJz7va1nOpVeo2LDGR7UYPGybPe60JPNDzVrsjUHWugk7UMKEtkMx6+OJiCIVRjpFs4yPiE+v5LHtiDAjOqI3DzVJ2Egk8aWrEhK7Keadm8ve9N8nfr8VrGR10KepXiCIClX3505VxcEGYWZV1Xnuz49TVgosfX8gYAXz5iFA5XPDlX8nvd4ekKvIzP8lLxGysnJ1OiOIBKgz/3M1xYspoxf/NR0F59ztkjaetB0RGaRw40xqNGl7eOpnhjZGt39o53Bx4KCyZvh8Oluvj26etC94B4OHlALUHC8aqXiw4HfYYJxBVaAw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 29/05/26 10:53 pm, Kiryl Shutsemau (Meta) wrote:
> make_uffd_wp_huge_pte() arms the UFFD_WP bit on a present HugeTLB PTE by
> calling huge_ptep_modify_prot_commit() with a ptent snapshot that was
> fetched without the corresponding huge_ptep_modify_prot_start(). The
> start helper is what atomically clears the entry so the kernel-owned
> snapshot stays consistent until the commit; without it, the hardware
> may set Dirty or Accessed in the live PTE between the original read
> and the commit, and huge_ptep_modify_prot_commit() (whose generic
> implementation just calls set_huge_pte_at()) then writes the stale
> snapshot back over the live hardware bits, losing the update.
> 
> The non-hugetlb sibling make_uffd_wp_pte() does this correctly via
> ptep_modify_prot_start() / ptep_modify_prot_commit(). Mirror that
> pattern for the present-PTE branch. The migration case stays as-is --
> migration entries are non-present, so there's no hardware update to
> race against.
> 
> Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
> Cc: stable@vger.kernel.org
> Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> ---

LGTM

Reviewed-by: Dev Jain <dev.jain@arm.com>


>  fs/proc/task_mmu.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 1e3a15bf46f4..e21a38ac745b 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -2610,12 +2610,16 @@ static void make_uffd_wp_huge_pte(struct vm_area_struct *vma,
>  	if (softleaf_is_hwpoison(entry) || softleaf_is_marker(entry))
>  		return;
>  
> -	if (softleaf_is_migration(entry))
> +	if (softleaf_is_migration(entry)) {
>  		set_huge_pte_at(vma->vm_mm, addr, ptep,
>  				pte_swp_mkuffd_wp(ptent), psize);
> -	else
> -		huge_ptep_modify_prot_commit(vma, addr, ptep, ptent,
> -					     huge_pte_mkuffd_wp(ptent));
> +	} else {
> +		pte_t old_pte, new_pte;
> +
> +		old_pte = huge_ptep_modify_prot_start(vma, addr, ptep);
> +		new_pte = huge_pte_mkuffd_wp(old_pte);
> +		huge_ptep_modify_prot_commit(vma, addr, ptep, old_pte, new_pte);
> +	}
>  }
>  #endif /* CONFIG_HUGETLB_PAGE */
>  


