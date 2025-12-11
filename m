Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6A12D41C14
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 09:44:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 189186B0005; Thu, 11 Dec 2025 04:44:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13A856B0007; Thu, 11 Dec 2025 04:44:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04FF46B0008; Thu, 11 Dec 2025 04:44:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E22C96B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 04:44:05 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6AD0B5B3BC
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 09:44:05 +0000 (UTC)
X-FDA: 84206704050.26.FAA1EF9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id A047716000E
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 09:44:03 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765446243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ng1wwKDzcEjflrS2iXyd5XGmJYwFKfGL/1mQqln+X1A=;
	b=ZPGy5aySNtj6x6IzP69KHxUFQg7dykD444lUxT9Vu3b5BC7AZ8V82NOsSzauVXlhL4qOO8
	K4U/1U3KzhmsKG8D5PD5sbjEgm20rbx0v5P8EgdKS+GwDL60HMRvy2xo4gJL2oQUQtTVjR
	9lW52fOGSY3Kkf9sXAXIK1UWQ0SZxUs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765446243; a=rsa-sha256;
	cv=none;
	b=O6tS2KiWYxJRrKiSB3oIzdKjsE7zRap8ai62Sm4rYmQgKHi/UAt7y2YZWqIb/ZaGQisPgp
	GDI3tX8nmpt7X/003IByTRhWoSC8zgSd+ZVdMXRpGEL1qhvg/yN+prNiMe5xwF3/AVTEmI
	zuLODMKGiU5eQHjuSRPlNuJb3D8ntB8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7E1CE175D;
	Thu, 11 Dec 2025 01:43:55 -0800 (PST)
Received: from [10.57.90.205] (unknown [10.57.90.205])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 91E593F740;
	Thu, 11 Dec 2025 01:44:00 -0800 (PST)
Message-ID: <1b7e682e-86a4-4573-b423-65f9755f71ea@arm.com>
Date: Thu, 11 Dec 2025 09:43:58 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/madvise: Use set_pte() to write page tables
Content-Language: en-GB
To: Samuel Holland <samuel.holland@sifive.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Jann Horn <jannh@google.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Anshuman Khandual <anshuman.khandual@arm.com>, Gavin Shan
 <gshan@redhat.com>, Zi Yan <ziy@nvidia.com>
References: <20251211081117.1126521-1-samuel.holland@sifive.com>
 <20251211081117.1126521-3-samuel.holland@sifive.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20251211081117.1126521-3-samuel.holland@sifive.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3n5s94hd8woh71qepgjqnob66bnf9jbe
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A047716000E
X-HE-Tag: 1765446243-249054
X-HE-Meta: U2FsdGVkX18UIrnxnNZvsip1/EHepgJqmPI/BFdbnR2CQSKta9xZJtsiwR5rBHsUZwzrEr0xing4YojGurQfFqX/aDQ9Rh6vVV9PJ0aV5Vwh8FQRHIwbMtusxGdVsZKViLdK6qgc9lw68O1cPC71nBspp3QaJx1jm1bFtBc3tUaJ+TjFmioyaIbC4cz/avCyiBJdFgSy2+cOPSUS5lG3pN//nrdK+5WMhNkQlY9VsOeGTQowDMNTeDV1AT6+5gsu9H3KHrgixY5MdSSmZdcMS8w1miWOFJCcRV0WdFj2RhHAVtwvg0yBd4pzttOH/l5/9tCswGWkMpjOWw6a0rHqNQ19p+QSHMK8WhCmfOrSizMEXKfnjs1fNyQ6gMJfYEurNOGiM838O0ShutBrH/yqeo8/bcksE3xiwpdKMd61g7kPw7v3l8gepwfx3mT68sxkiCuTNuo0cHqJ/Do2fzqUF/Mg7UYC63AuYl2+xjC5BRBw+MTLwvO2cn+2cejjFmrw5hNugMStyCKhAJ9eFjqozxxzJ6SIrGK5RvNQFQBwF3/QH/M57UVN+SJnm9Il7GiU1KDluy3KWlRtdeuJ+5AOcIIrfRNqeKpp/hEPRg89vguQRuPwDgXP+Lz+AFa1hYhoIMH+x0zDizSs8MwKEHU/Gx0ib1H8rJxG+zVAdgEfuRkC3/BlYx1o5jBn0PFsO7+bhZ56IJKa4bVZQF6uBjyV2mnyq9aSxXQdJHYmZIKp3tSttc7xk+9vI4kiWCSDym8qVm8dVSABWu4BEe3UFxbj2nccFE6dqCzk0SOvNLqM/56qZAYtJUSJZ/YuV9hA5JCsWUsVfwq+TQFp5KCE5nQKJDBwy6bdhbV/5iQAzjQbZczOG0BbgG/uZT8icXljmdTSfhT5zSt3PY+TAqG+lg5dfT1ok3z1+gOjDiWP/kptmreJ/jcNgCZoWzet3SaMBad5k2tfo0whEIuBxzIKGbf
 APIr+MQq
 3A102Rf9aaZJAM9sEBhxMWG1Ew1v/JkiVaUmTgFmz1hNRHOXHlULz3DiODY7H9tIOHuO14K0tXuXH0m3G6WlGudXvPkkOkey3xvp4ltzPMRVBxjJaUjdI66Zxo9EETpiryt0HIzi1fL52vmvv4QErsy26FcQ21YHaLLJQIicX+tEHo56OvvosFXLNOzgvaZ43zsicSSVdaNqjhhSaNgbocN19kYJDoyl4pnHz1tdiLejqHT0yQxvSdpOHaBeL5V52VebkoOoMB7EN/vSqpz1DGGX4JgLm30X7s26YHW25jSBo04TjdHDjoKwOQ203tSuWVxr0Clijkqgy4js=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/12/2025 08:11, Samuel Holland wrote:
> Generic code must always use the architecture-provided helper function
> to write page tables.
> 
> Fixes: 662df3e5c376 ("mm: madvise: implement lightweight guard page mechanism")
> Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
> ---
> 
>  mm/madvise.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/madvise.c b/mm/madvise.c
> index b617b1be0f535..4da9c32f8738a 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -1114,7 +1114,7 @@ static int guard_install_set_pte(unsigned long addr, unsigned long next,
>  	unsigned long *nr_pages = (unsigned long *)walk->private;
>  
>  	/* Simply install a PTE marker, this causes segfault on access. */
> -	*ptep = make_pte_marker(PTE_MARKER_GUARD);
> +	set_pte(ptep, make_pte_marker(PTE_MARKER_GUARD));

No! As I explained in my response on the other thread (which you linked in the
cover letter), it is correct as is and should not be changed to set_pte().

Copy/pasting my explanation:

| I tried "fixing" this before. But it's correct as is. ptep is pointing to a
| value on the stack. See [2].
|
| https://lore.kernel.org/linux-mm/2308a4d0-273e-4cf8-9c9f-3008c42b6d18@arm.com/

If you go look at where this function is called from, you'll see that it's a
pointer to a stack variable:


---8<---
static int walk_pte_range_inner(pte_t *pte, unsigned long addr,
				unsigned long end, struct mm_walk *walk)
{
	const struct mm_walk_ops *ops = walk->ops;
	int err = 0;

	for (;;) {
		if (ops->install_pte && pte_none(ptep_get(pte))) {
			pte_t new_pte;

			err = ops->install_pte(addr, addr + PAGE_SIZE, &new_pte,
					       walk);
---8<---

I agree that it's extremely confusing. Perhaps, at a minimum, we should come up
with some kind of naming convention for this and update this and the other
couple of places that pass pointers to stack-based pXX_t around?

e.g. instead of calling it "ptep", call it "ptevalp" or something like that?

Thanks,
Ryan


>  	(*nr_pages)++;
>  
>  	return 0;


