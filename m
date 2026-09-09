Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AE35C79FAA
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 07:13:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA53A6B0092; Wed,  9 Sep 2026 03:13:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7D3D6B0093; Wed,  9 Sep 2026 03:13:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D937E6B0095; Wed,  9 Sep 2026 03:13:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B90246B0092
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 03:13:46 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5782C16011D
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 07:13:44 +0000 (UTC)
X-FDA: 85193358768.03.ED9BDC0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id A1E60C0006
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 07:13:42 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=zqloceJ2;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788938022;
	b=N6AC/fmLFgbR5X3tbrD8JfQfDiqC//gQnpryfVMTKoHtbFTHVONQYavV9YacJrfOPe7uNd
	P1TombBJoAy+T7ghqvRNNJ4Uy2kn5o4dhmk1MfHi7w3NqNcQEzSxsdhapnuME/rU6Q9CeW
	euYyVpZEWj5fp1PcZMSkF9oSbbpfzIA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=zqloceJ2;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788938022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=upgrqiWmmptNwRwOA3u/+mWTxD1ZWFED978NfkXjrlI=;
	b=5T6NJObpQtYVkVlYSvkf6d52gEGqUlRiftgioC9M1ba3TnRIVS4QSm+/Yj+jkiGe4q6dMF
	yOZfEbvU9McJngEVlSQAwvOInvY2SUs8CbXmx2R8ROnqRjRLry4BOGpX/PHJKvWXp0dcWU
	wReBaxkPbPfd4SqkQcHTgPgIMVofpzw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 111BF601FE;
	Wed,  9 Sep 2026 07:13:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 862811F00A3D;
	Wed,  9 Sep 2026 07:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788938021;
	bh=upgrqiWmmptNwRwOA3u/+mWTxD1ZWFED978NfkXjrlI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=zqloceJ2NnoaNE/z83IdujWffVPp8pbfyTibAAG0UTAIRpMMogdYsCLyWxAEbhWVf
	 kEM95mtlRnyAiIK2/P28HpJrG1/JqtVkm3j225uxEhLMeJqsk3fnN+WEOST/EUFgbC
	 6CIUcYv03CtwRV33TShPygrqR12zpf3/4ymb8jr4=
Date: Wed, 9 Sep 2026 00:13:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
Cc: linux-mm@kvack.org, liam@infradead.org, ljs@kernel.org,
 bpf@vger.kernel.org, linux-kernel@vger.kernel.org, Hajime Tazaki
 <thehajime@gmail.com>
Subject: Re: [PATCH] mm/nommu: Reject wrapping ranges in access_remote_vm()
Message-Id: <20260909001341.6a7c3556259f7cf9a79c1da7@linux-foundation.org>
In-Reply-To: <20260909064231.18693-1-tasos.papagiannnis@gmail.com>
References: <20260909064231.18693-1-tasos.papagiannnis@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A1E60C0006
X-Stat-Signature: e9txumqqc8sfedm99fxyb51qmuafs56g
X-HE-Tag: 1788938022-47054
X-HE-Meta: U2FsdGVkX1+5Lfp4v0MgvYucp55T2qs4yCdEX8QJF/Qn9Dqhymam1G424bakkGP1wOXKEhWa99o2jplqIlfVULGmdBXVXxD2zL9vpHCpWsQj+uIfPf02N6RQT+EkjLea0+LiszdfQTOrDlHfqg23ioa5NQs36YbxUajh/QUzUIk3I8V9mNR4XCdl3FwUerkYCzZk4sqQ9gyfI14wg1RzFSAOCpsx5yOJesPT11UUqiADc9UZWH0Ev1fDesj/f+wQ0g6zwOe9WDfXVRz1jMCwwlev61KZDKELVAki8dFDReXzJRzPjwp6hDabk/YfS58r2ifp26IybjunT9B3IprTxy0MztqbHwWtmQc1uZqjXisZ7pJXEUndNNnEf6+TG3FHzdf6JELqc74R1lYhQ9CwpbbPKbcG0paHLw1h6SLMrrS5E2vnkJIjYJSxzG0qZv68XKWZHGDKi5ABsZPTyy7JQHxfQ02l4itg8IC9oZyAB76rQp9dyDWom6yt1RpTAKnsbutrpDBhuUQ9rcTXpWGmHFBd1VE0HKSvZul09gFxEJPfP2vSP71py5QRICeUNY6VM+OzCBYpaQm6Jfks/fWqK35y2b55uhnz9+WXwZY27JwfJskdMH9tesGD3eDElwCzdI6tsUvuZQRGo5lL2f4HZaiaLx3EvEQE1U6JpgEBUMfAqFdnlvJLQpnmnPv5kDcnru4BhEvAQ6xWIi19jEJBcZmicAhbYD/weY8KjKvE2qlpg1eig+C6EfF74O/0KR/4syAw+mhH3yXX6U4YebjNA8VbxfINP20ITrmkmNMKk17AoFXROecQOSAYVDDwhnlYqoiTRzY+y4ZT3CMPNbN+sDuonnAWH5udBSQKlnusZL8OSMQm0ghQkAmufUlo+X/mqUeC6tuBYc0yjiX8Ov1xmlCU5stJ3cllDf1HDhwRRpQmu2cAfpeSKdS8vJp+oO3+1rZHbU/D1s/yR9vJ/3K
 nuLHCucM
 4tGDZN9kQ1csuKodSo+/4g1RwdLzHpIMcBve/QBrL7YPcGMNHKh4nzixrd6/HTzsLIq7XtgOMKP8BsX88i0+/AaoDfVbnfh/bVMhYcajSqMn00tKhjJlSNurobEFquvfrr9iPIRkz4lNoNMYG7RU/LvXYaLLt6+nAKXtDg0ruHj09/iCnx1m2aLyGNcKxxJ3SPDKCjciWiJrsWz0BaUhaCELZfgWuhnnnPFsmYfjDwyyOkzMyhaA1kLGU7ZYl0EW+pR/85GtbplB9LIHtwvt+ucWAEJPRZ7t7tFSiyDKSSWEWcIklCry4tr6q44dwzXa876zTUF+peJ0VcaDAKc1KFHIuhN4nukSO9Rkg0YI2/rCEoxwlH0nhskGVf/VVCdkNCQHQ7hqNk8G4CYkLX7rbwXN0uPRHE0VIcB9ZOFTYpqDMBKDyw/ULpct9FbXPdgcSbw391sK+9AofleDSyNOH+x3JOpPkoFwJxVTb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  9 Sep 2026 09:42:31 +0300 Anastasios Papagiannis <tasos.papagiannnis@gmail.com> wrote:

> The NOMMU implementation of access_process_vm() rejects address ranges
> whose end wraps around, but access_remote_vm() bypasses this check even
> though both functions delegate to __access_remote_vm().
> 
> Move the wraparound check into __access_remote_vm() so it applies to
> both entry points.

lgtm, thanks.

> This is originally reported in [1].
> 
> [1] https://lore.kernel.org/bpf/4ef240a5bea36ff84df9589671367832860795159386a4c8fba546a0fa8b786f@mail.kernel.org/

Ah, bpfbot scored one.

Sashiko might have found more issues in there:
	https://sashiko.dev/#/patchset/20260909064231.18693-1-tasos.papagiannnis@gmail.com

I'll optimistically cc Hajime Tazaki, who has been doing some NOMMU
work recently.

> Fixes: f55f199b7d76 ("NOMMU: implement access_remote_vm")
> Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
> ---
>  mm/nommu.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/nommu.c b/mm/nommu.c
> index 498e01ee40b0..ed44510e3770 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -1674,6 +1674,9 @@ static int __access_remote_vm(struct mm_struct *mm, unsigned long addr,
>  	struct vm_area_struct *vma;
>  	int write = gup_flags & FOLL_WRITE;
>  
> +	if (addr + len < addr)
> +		return 0;
> +
>  	if (mmap_read_lock_killable(mm))
>  		return 0;
>  
> @@ -1727,9 +1730,6 @@ int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, in
>  {
>  	struct mm_struct *mm;
>  
> -	if (addr + len < addr)
> -		return 0;
> -
>  	mm = get_task_mm(tsk);
>  	if (!mm)
>  		return 0;
> 


