Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82DBEC61DE1
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 14:23:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CC796B008C; Sun, 30 Aug 2026 10:23:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47D696B0092; Sun, 30 Aug 2026 10:23:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 395A76B0095; Sun, 30 Aug 2026 10:23:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 146F06B008C
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 10:23:04 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7D8FE402F3
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 14:23:03 +0000 (UTC)
X-FDA: 85158152646.27.03F2790
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id D1C6B1A0008
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 14:23:01 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lHTeeJJt;
	spf=pass (imf19.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788099782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k2CnB52Tk5cRweLryWaQrcbSePVmhdv7HPuySx6iD00=;
	b=HWOz6QVjV9YI711BM1DF5ejNeSlRdlbpzLfMe7P+Jiho8r6AEsdFTL/f8ecZzrliYuaVjm
	Yxr1+WGEi5sxA+/9TXkoJ2u8HsvVzyDLpRsEG81giki36ISL6N7A9TNwcn0t3hseSXM9bL
	nU5z6/aWuIbZDkT5tZNgoSaNZPnqo4A=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lHTeeJJt;
	spf=pass (imf19.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788099782;
	b=bfo/BriEFJzSrsCJYoCguGQYrG3nmLFXheI/QnoKIqyLKw/p4rp81NiQnrfamas+5apHmv
	4wH+9FFA4oYYqFNmny5YJdcq6sxAcs6P7uDkUB9Wv1vevF4GS5DCxehs8zDOPXFuIT0oy2
	zzX+lhqHChYdx6iDnegG1D2nG3wrxQs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 58FEB41831;
	Sun, 30 Aug 2026 14:23:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C96A91F00A3D;
	Sun, 30 Aug 2026 14:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788099780;
	bh=k2CnB52Tk5cRweLryWaQrcbSePVmhdv7HPuySx6iD00=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lHTeeJJtetJ10FlpfgFKQuH6khW+G77eLdx/731U/wNZL+ULKdytVS8RD5MgvsL5y
	 /XGmxrlh1K/stjh3feuQRwxo4swiK+RvVCU8at80IKz98IJkI6M8LRIZ8x15JtnCUi
	 dKEStnxbZ1OMK5QWVWnRzWx8OXk+2b/hoFNh6DGOtpPcMt91Oixi1S33IusPNaaKEF
	 3eaj8tzVDMPY0CORKNjqu5/SSqcZeOH1bmTyey63lm/egQF1HL2nhh8+CZznVsZlvd
	 q60bTKfc9/TxfGhJD5c6VN9Rcdn0C+nafz452dBreh+KKDabovfu+n/RR2wseqtqG3
	 uRZ6l9SefqqDA==
Date: Sun, 30 Aug 2026 14:22:56 +0000
From: Harry Yoo <harry@kernel.org>
To: Longlong Xia <xialonglong2025@163.com>
Cc: vbabka@kernel.org, akpm@linux-foundation.org, hao.li@linux.dev, 
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, paulmck@kernel.org, 
	rcu@vger.kernel.org, xialonglong@kylinos.cn
Subject: Re: [PATCH v2] mm/slab_common: fix shrink budget underflow in
 kfree_rcu_shrink_scan
Message-ID: <apQsbGJDPPyXcn8R@dev>
References: <20260826075653.3304251-1-xialonglong2025@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826075653.3304251-1-xialonglong2025@163.com>
X-Stat-Signature: a5hmnd1ixk66e9ogr79g16hytudb4dme
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D1C6B1A0008
X-Rspam-User: 
X-HE-Tag: 1788099781-865972
X-HE-Meta: U2FsdGVkX18cO6Pq3JXEHMUZJIPcs/cMHnG991OdyqcrheRkHeSg6PMxgeaT7ylg9ghS6TQVoFa3bqJjU6bZpZVi7c3kS5+xYQscIrEbORfckk0PC0Fh7dCEdnD3VkmwjwaSahkP5sLriimtLSmqtDeQNwjMEY4+rqx/IdEYYZAdFxI+eevSpRBVJsQCfngQ8wspYl0wQ727zuKJBDtffcGrTm4VVnrPD1mXo+saHAlYTwONyvaGks3pTWdbijC5AwiDbwRkkOoTtlqNpWi4qBXYENxq/w9dillxhIrs7ljpIlNXe3RW+N9R/Yxb5+MpF7ZKgg5wU0uSjrZjaVM2kxNZuSFoIMth8aPOX5IARH5E41ftan6vawX4WILpIBrX8xWMRHJPJPgdBGdpXmfKETY7h/f4UnNmW27WtqzwfoT9oHPoXi9kLThOsOPK7DBEJabdfVUBKgvWOejnv9Ds8dkJYZwxyONsPozsKQOpzByFJcHeoP7XA8//A8F5mDa/NX1lQiassNrrjiJ2tkZO/JCUj9mnf8EHw1qW6uWM21K0/eYNbNCyP5ugDur2PzsVJwQprHUuN41XVa2qyWMJOvp2JwFxkXIDwYkhe4Q1TjtjNn/xnaUvJFiUlNsgr6JbyHtJQuQNGUEGI6k3JgsjKAYc6YvKArFWAJQZ2pohtAYt25BaeyMcu5TlgwyP9PDQ4nyWNae3kjWeuSkKIgnfL/qKAOHjdS7dw3jdBeaaIG/06Joi9nvmN9HCUzgL3GmufPObnGQZVvfWdB3YLYWBCQGAf031NJw8vDrCLvJTofA3Yj2H2v9b4BzVosHfhVIFpEeVceQkgMPq7H0xiidjhBILP4hylh6Z4zIsc+MFzUbK7rErU5rfKuSvPNBkbDoPR9TbjyQN4J+dCy+sElhnvXNASNP3ETgDQba7mJu/tNvUq0PfrmJJd7gUIVoVsBU6GMpz6ylyjjdax2QsEM2
 tf5FsIOJ
 xCLy+87Zk1JYE9USc5MOgcQuwNnFslIE10BE8uLvrna3suTPLDTk3eXxYOQGDhF0nKHxDUQNfYXuO8Sdk8tC6AWpEGopnXUqPJRuRo/wLW4h4lwSze5+cnVpP2yobBb0oIrxLyvxFi8QY60GqT57pC3YQcv9WjWHQRM9lAoNdNKZ/jsApbJxj7TcYvAkerJQAp7GoEZPR1xCFuRgCICyfEtb/88jN58zmD79HseSV1WIEIlzJU1LpJdaprNgGft0ot9sOgxTBK7/CLs8wrZrL4ck/BNfBcecxSzW6oWSzpVTjZ3ixHjvr7lM/wt2sRQ2/c6aooYcMK68UV/Fp0n0wHFoQru3LJ7KCLNn8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 03:56:53PM +0800, Longlong Xia wrote:
> From: Longlong Xia <xialonglong@kylinos.cn>

Hi Longlong, I have a few questions.

> The kfree_rcu shrinker decremented sc->nr_to_scan (unsigned long)
> and then tested the result with <= 0. When a single CPU's object
> count exceeds the remaining budget, the subtraction wraps to a large
> positive value and the <= 0 comparison, which is equivalent to == 0
> for an unsigned type, never fires again.

Since when (which commit) has it been broken?
If it has been undiscovered for a very long time, why is that so?

And how did you discover this?

> The scan loop then iterates
> through every possible CPU instead of honouring the reclaim budget.

Did you confirm this actually does happen? If so, how often does the
kernel end up iterating through every possible CPUs, very rarely or
almost always?

Would this affect the kernel's reclamation behavior in some way?

> Accumulate into freed and stop once freed >= nr_to_scan. The shrinker
> core treats nr_to_scan as input-only, so dropping the decrement is
> safe; freed becomes unsigned long to match the return type.
>
> Suggested-by: Hao Li <hao.li@linux.dev>
> Assisted-by: Codex:gpt-5.6-sol
> Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
> ---
> Changes in v2:
> - Rework per suggestion from Hao Li: accumulate into freed directly,
>   compare freed >= nr_to_scan instead of decrementing nr_to_scan, and
>   drop the per-CPU count local; promote freed to unsigned long.
> 
> Link: https://lore.kernel.org/all/20260824091838.1692153-1-xialonglong2025@163.com/
> ---
>  mm/slab_common.c | 13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 657fd75776ea..e227c2ef2a4e 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -2162,20 +2162,17 @@ kfree_rcu_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
>  static unsigned long
>  kfree_rcu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
>  {
> -	int cpu, freed = 0;
> +	int cpu;
> +	unsigned long freed = 0;
>  
>  	for_each_possible_cpu(cpu) {
> -		int count;
>  		struct kfree_rcu_cpu *krcp = per_cpu_ptr(&krc, cpu);
>  
> -		count = krc_count(krcp);
> -		count += drain_page_cache(krcp);
> +		freed += krc_count(krcp);
> +		freed += drain_page_cache(krcp);
>  		kfree_rcu_monitor(&krcp->monitor_work.work);
>  
> -		sc->nr_to_scan -= count;
> -		freed += count;
> -
> -		if (sc->nr_to_scan <= 0)
> +		if (freed >= sc->nr_to_scan)
>  			break;
>  	}
>  
> -- 
> 2.43.0

-- 
Cheers,
Harry / Hyeonggon

