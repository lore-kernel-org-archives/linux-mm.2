Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70D82EC1438
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 12:57:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A33556B0181; Tue,  3 Mar 2026 07:57:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E0E36B0182; Tue,  3 Mar 2026 07:57:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C2446B0183; Tue,  3 Mar 2026 07:57:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 79AC26B0181
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 07:57:50 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 059A15685F
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 12:57:50 +0000 (UTC)
X-FDA: 84504753900.11.E285607
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2BF4F180002
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 12:57:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=rJYBl+yV;
	spf=pass (imf06.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772542668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kIb3XKow0Btqlt+PMaDiNSWvQvGqJs93pY6JvvoFo5g=;
	b=LPJNHzylrJ/cfQV9KggLgh4+oqNqhPAnXkArJw350gvONwzyyh5KRfK9Bire0ZMDLdyLPV
	382WLzPe0arqcGCC2YngwjRxOX3vCnFDcsAoSICwx4utxI4Um/eELpUNOew2d6YYQecYo4
	wWcRAib4plekN0bHR4Q5r55zGPrpYB8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772542668; a=rsa-sha256;
	cv=none;
	b=ium9/bQRu9MZaGxZN74cs8/H+PuSLB65r9M3a2tLbgaRKhizwDwKHXfkJvNFKnypR5OmRv
	AMg+nAGlzt/Kbi0zhDASDIELmCSCQRMEOSvBfrUVIFxGkwnmI8ga0vOCNF8GDzb5oR/n14
	XdQveHMHMHhiHiwVyt0u3u43qOuD6g0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=rJYBl+yV;
	spf=pass (imf06.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 725EFB30F5;
	Tue, 03 Mar 2026 12:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1772542666;
	bh=kIb3XKow0Btqlt+PMaDiNSWvQvGqJs93pY6JvvoFo5g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=rJYBl+yVoN1GXIomdl1TvEw4wtVbdCklbsEo3ffV2l7V0/8vfIFuFTpUaDU5w/pZU
	 IS+jW6l/fQDOm7o0wMBvqs7mzKfbXodWWSFfxm42ZCw5bMdmSgXuMqZ1LkhnN6j3JC
	 WitFR8/yUIDe9bPUKkzFX+YdJbYXAqSAgcIjCcwo=
Date: Tue, 3 Mar 2026 12:57:42 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Maninder Singh <maninder1.s@samsung.com>
Cc: mhocko@suse.com, rientjes@google.com, shakeel.butt@linux.dev,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mm/oom_kill.c: simpilfy rcu call with guard(rcu)
Message-ID: <aabaxkb_xpUMab0a@shell.ilvokhin.com>
References: <CGME20260303102608epcas5p159cd0ad7dfd939c4a67fab3c7ecd7bfd@epcas5p1.samsung.com>
 <20260303102600.105255-1-maninder1.s@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303102600.105255-1-maninder1.s@samsung.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2BF4F180002
X-Stat-Signature: wmgkhrsmy1wkbxh6su5jgrfeid64gkha
X-HE-Tag: 1772542667-529902
X-HE-Meta: U2FsdGVkX19OX07CEqkIkwuNScPlhNPp6Af+jfaWispDf2fb2E1e6uZ2f2LcjEsiIWvQ97Ptx+XhH+jo/mm5Y8iO6Kh+nVWuQToAC+iQgqHqZVA36wWta53nnwjZHeOrcT13oeLvxkhhk1q1+WMKO1m3iDdd36cxNUqwXT9NEyygE9Ckpg2oEgXuu87oYpS6vSks69eXT9u9I3R6B1BdsZLnDpkRnHYod4Y5ancp+i9fXYiY+3CqWzVYgIdXDEDSRvKsLaBYfOCrwQspQHiXziTcxy62Ugye0kvNu9gKMjHBrqC94uaJ0VpcqMHaEnraLN9knP5nDOdgqYxVD6INCps3FgPmjiRQIhh8ICWHhwUfM1svCcwJ4agHB6XcR9XstuqTmggk6Hs55QuYjT2WoEZXOja/wPybLle+Yxl71GATz0BNUfQwqRLl7wLvUvaOWPdUVqb5a0KZAG+QiK5Jf7XZRUjqkOu/Y8Og68U1Gk7+2vF75RsARLc4vi3/CWDeNlxs+u4H7KP1bLZEyslyBtdNnpFAb0LU31nWc5pOEIhcTA2ao2+eNbCIdWWHjcUJ30z7iFSTZhIWcQjmvwwYW8ADGbCP28y6QoaUt8J4yLV0t+YYv8vUCvLRGXms2YNm5DTTbYTUAC+jsAWiKBemI+Vxk+wFTRoRlE3ml2woLtfMm/8+ZkBgzbeSbjk6t8gq0FQbqsMgmRbm9X5m7tLcyApwaaNpNiAj3MhVb6TnxPwM7/5CqrRAy6uN3OgNpESXyg/mjJYfcxnsKvSVFA7HsTfgsM5S5PFpDwSXOo6VMGZ00DM3yUm3qsvAYTzXZ6fvo3AduX/hseTLLrjQvXczLT73p6dSkBaxGz2fLhLZoDd21E6Tt5KE/CRDuIWt+idBz0K42xSZZa85X44fwaphsRhZxbJGfC+B8kKqBIoRT8Wa5J8t3kezWW16pfrLBypRJHYjfU4fh1i5ErK+bFu
 X1Al13Xc
 HBbapJeUUKwYC7pAXv2481vW+kCpLAzTN2fAAC0x63yfH6RLLHbuFdkuWypIWQrWUojODvd9nPJKT9kwsKs9fYgd5h16AT/7wJvS2Qvjl07QZdGPMqi1VQ12SBHhcUcQN6VMJezeHN6AuDkQ0jDoaR9QffeSNXuTNVliQCluy1k288mJg4xmI6XNHjq372dTYEbqYeT6fLnYAcYGV5sPjWLc+IbmFe0ySov7Pgs+8Uf5MowSUrrEfB+QGAr2mnNrd7T90gLDlogsl4Qv30yWbJzPiM4u/l/Tkpn5yvzcMFsp7Tj9Xg+OagyebLwTLvonhMF138x9MMULaTEwz4JQI3iqzf7k3koQpz6tOiXOD+rYKmRk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 03:56:00PM +0530, Maninder Singh wrote:
> guard(rcu)() simplifies code readability and there is
> no need of extra goto labels.
> 
> Thus replacing rcu_read_lock/unlock with guard(rcu)().
> 
> Signed-off-by: Maninder Singh <maninder1.s@samsung.com>

Reviewed-by: Dmitry Ilvokhin <d@ilvokhin.com>

> ---
>  mm/oom_kill.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 5c6c95c169ee..9e3e88c06ead 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -135,19 +135,16 @@ struct task_struct *find_lock_task_mm(struct task_struct *p)
>  {
>  	struct task_struct *t;
>  
> -	rcu_read_lock();
> +	guard(rcu)();
>  
>  	for_each_thread(p, t) {
>  		task_lock(t);
>  		if (likely(t->mm))
> -			goto found;
> +			return t;
>  		task_unlock(t);
>  	}
> -	t = NULL;
> -found:
> -	rcu_read_unlock();
>  
> -	return t;
> +	return NULL;
>  }
>  
>  /*
> -- 
> 2.34.1
> 

