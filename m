Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB017EC047D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 09:39:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F2666B00C8; Tue,  3 Mar 2026 04:39:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 289196B00CA; Tue,  3 Mar 2026 04:39:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B61A6B00CB; Tue,  3 Mar 2026 04:39:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0AA6D6B00C8
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 04:39:58 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A26F5B84A8
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:39:57 +0000 (UTC)
X-FDA: 84504255234.23.F205220
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id EB6E4140012
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:39:55 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FnQ0gYGU;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772530795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cAGJcLauI0n6qjsSk6kr3LEoMGqTc7b26h9G4c87s0k=;
	b=oHNkUbgL8E3a7RGa+t3Oa7tndVjiiRZMehYLAz+GRth5AThkEBW8kPdfL6rWWqvpYOyCu8
	89HFboqVSH928faipkD6xr4g1eCEXZgjmEBWMM9NkI08U2yCKCw395I8Vjx9yI5nzofFeG
	6E7G3iK053HPReVSGflNRmcPagdqcXY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772530795; a=rsa-sha256;
	cv=none;
	b=paN1Du3F7Z+qYkTm83uHu8tJdslJukkdwytVHb56UzOMsStpJyBtRA5EXDzlL4ZFxTT2KJ
	PlOnO5TAFLJ/yAZFNJHgMuHHkQsUx0bsD/dIKURGB/SBVjQ60gszZG6AryPrBnchD/+s97
	Y338TwtCfvaXf4IahvcWQA3T11Qp3Kk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FnQ0gYGU;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6204160053;
	Tue,  3 Mar 2026 09:39:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A63F4C116C6;
	Tue,  3 Mar 2026 09:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772530795;
	bh=TkaYJ0+ciE8akBpuN5ZN0VbNEJHpN3mETiZttIZKh28=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FnQ0gYGU20tf4Gl7wGSZALeK7ao+poKYVXiw2ayguP5D2cyuwCvEho8DvKbmvGwS8
	 qsZLLpnwWipwRQAlAF+hLG36qo6Ost7vllwsQtTOfUYsx/XUh3zRN3AvHcmfWxdpx6
	 wbmRhQoDvbhdwJ1e8kV4xDdg7QjAJTAR1vnJMPvv1KUKCVxWfsJ2sHHKaa6MXDTGJ8
	 Nh4R+Cv3PCvVEAo8YfwTsT7vcES4ngmMNgOvSJUdDEkLhXxaihOeVww2TNd9yXNJ13
	 dO5lzpQSFuVOKSo7wxJbH+FmzvqAyDEd2DSr78wL23bCOi+mNXQRFcqmqj4j+vl6nL
	 w9vBHbn06aBvg==
Message-ID: <ed664410-e220-4107-b207-6bb8b4b0e710@kernel.org>
Date: Tue, 3 Mar 2026 10:39:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] mm: memcontrol: use __account_obj_stock() in the
 !locked path
Content-Language: en-US
To: Johannes Weiner <hannes@cmpxchg.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Vlastimil Babka <vbabka@suse.cz>,
 Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260302195305.620713-1-hannes@cmpxchg.org>
 <20260302195305.620713-5-hannes@cmpxchg.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260302195305.620713-5-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EB6E4140012
X-Stat-Signature: pjtqtjramoi611ebuggwd8xgytf46kcu
X-HE-Tag: 1772530795-566963
X-HE-Meta: U2FsdGVkX1/DM0NYd9GME4y+Qw18gycAtW3+OR8w1dMCJBwUSE+tbc9nqJ6Y6x54Dt1+YHi36rBD45hEC5ESXmLYkwwGginbOwk7I7CQiwOQh8+4pVm9kXDQcSvvuZka67lw2PyefTfTGfolal3bjpKm68xQG1ex2VSmlv6e2fse38GuulcncJXKuBNDWbGfIyJhA47AukcErUXLN7tvUYijpHKHK9W9rUAeE1cm3HkPm6wVQ1nh6pjHtBvi2oorex8ry8jnuvfSnV4HX3DTZ8XS238vsjs/spFmG9DA0hzKtv0poN1BWTUR6CzLaalvr4QceOeBLC7TRFG2O4KhENrGrNIn/4QkWV13LGwslGqG6uS6frVh7BaQsNrjPibI/oQM8vd+JwkiLbUVT41K2LvqftSmqBw6w3C2iRT4zZx9Tei7strrEtwe3+New5h0/4zxS9Q4H8YryIb7TDjiB7cLsXEVX4MsZxOcoZ46sfe3AoFqUQMSPo4ytDCKUHsQFzP9KRRX4FBoSNiqHRbM8lZbhN6+BYcDhXGxC7BrcB6qGlk4HTJC3rik0O5EoMCNoN+o2+4CEcMWdudZRVg3awBtzp0m48wlerRye0a7Cg1ElOpm3c6+NO0lcUmDFVCY56JBRLmO4AsBQa3Scv/HZejj6lZo+OMI/9pDVXKxp+hpsccnvZ8N81gdnz432b+1jnbMoLYimOlHc70FZuLh/OpYFFPcCL+L/2lYIxKPqK7Jwstcf4u1oGwWpIMzfm/1jl+8jMrMbF6WJQqd4pACSpjX6VT5sPRje06kqYNIkqTz9p3lcsUPc24L4RZFcLRIlGCIG9N86u9lQIAzXefFsX2/C9bjT1kBv5tOlXtcYCoZ2oXNeHEWK4L3CS+3H+q825fZU+GtlpUZ+sKc4ymmust8Ngr6/oock1vdwZZhz8PIgaJvAv7AGwdefD89q3pi19ni9yv2Hfh/SfAlCTg
 F/PFL45a
 iMg6Fg4aCNK4Teqrl7QS55Z2ONeYKgKot+TcC8qgcb8PtpohXgKIPXZ3Dg9FUu6ASA7dgaJn0qhleT0uZMtf9Um0YZhbZXUGav6zgRyTwYk+54mngE9MheyIJ/MODraHEmDumwU7xWqsPFE+NSs70tDxQ2xyQqt4ZYJyCoyQmC3hxWLWfYc/q26KsDmoYL8SEZvdd6Hwgut9DLWhNiwFT0sYJJeueWWOuqcoG+DJAmAEbUaqmt2fARs6opc64HUJXB4jT7xrl6OUxrKf7lgTuOU9CnJ6z3oTMrcYkAG++/SezMkklR9ZqB6+SQxty4Ug3LbLhnjm+0KYsqKvMsExG+JjNcDJXGmRJOsy9OVIwUn9zxqXSmFZOnqHGv5tfdE0Zj0MIUm2pDWb+YqFWfbWkBGWuKlslBSmb/xGpQzcOPt4eFRU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/2/26 20:50, Johannes Weiner wrote:
> Make __account_obj_stock() usable for the case where the local trylock
> failed. Then switch refill_obj_stock() over to it.
> 
> This consolidates the mod_objcg_mlstate() call into one place and will
> make the next patch easier to follow.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/memcontrol.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 32c09b4d520f..4f12b75743d4 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3227,6 +3227,9 @@ static void __account_obj_stock(struct obj_cgroup *objcg,
>  {
>  	int *bytes;
>  
> +	if (!stock)
> +		goto direct;
> +
>  	/*
>  	 * Save vmstat data in stock and skip vmstat array update unless
>  	 * accumulating over a page of vmstat data or when pgdat changes.
> @@ -3266,6 +3269,7 @@ static void __account_obj_stock(struct obj_cgroup *objcg,
>  			nr = 0;
>  		}
>  	}
> +direct:
>  	if (nr)
>  		mod_objcg_mlstate(objcg, pgdat, idx, nr);
>  }
> @@ -3382,7 +3386,7 @@ static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes,
>  	stock = trylock_stock();
>  	if (!stock) {
>  		if (pgdat)
> -			mod_objcg_mlstate(objcg, pgdat, idx, nr_acct);
> +			__account_obj_stock(objcg, NULL, nr_acct, pgdat, idx);
>  		nr_pages = nr_bytes >> PAGE_SHIFT;
>  		nr_bytes = nr_bytes & (PAGE_SIZE - 1);
>  		atomic_add(nr_bytes, &objcg->nr_charged_bytes);


