Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3C61C61DC2
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 12:04:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAA526B0095; Thu, 27 Aug 2026 08:04:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E33866B0096; Thu, 27 Aug 2026 08:04:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFC6A6B0098; Thu, 27 Aug 2026 08:04:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A48156B0095
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:04:19 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3A0AB1403FB
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:04:19 +0000 (UTC)
X-FDA: 85146916638.09.58990A6
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf23.hostedemail.com (Postfix) with ESMTP id 11A65140014
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:04:16 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="Dza4D/BD";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf23.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787832257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GP97XYSOxAd4mwkEh8pXHynZ3Zgb6dcRm0VHZ16u2ys=;
	b=hdVEW6alCUzaLAYvGStgxQzK79CMGzI0UFQbW/qKaHmvz0keIdr9OYWeo6boeZpEdFPAM3
	i82VWly+vQwE7L6fju45+U9/b4PsIPIn9m6LQvCaSfwbOZjB852FAyu3vqJGIdQGbFmxGt
	YUDYHGq2lok8FVT7e+/rsL04S3wcszI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="Dza4D/BD";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf23.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787832257;
	b=ZtvP2G9iu85uNdrXdfRlJa5sclNYlpA9IgssixcPU3YN4212XxI5UxCVYtmKxHkz4cGbtX
	Jxlq3inV1hzfreooxTQGmFyyQva3u5jUEcDTU4HABtaX27p9dBcxr+ulmBbOgGekdSI+fo
	aLUwgCG9YHGOla+W/cmq+cdE8ptPPSw=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-49557167508so6601915e9.1
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 05:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787832256; x=1788437056; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GP97XYSOxAd4mwkEh8pXHynZ3Zgb6dcRm0VHZ16u2ys=;
        b=Dza4D/BD31ShmYEYryc355EXKFKGlNZrO5A18Cz9BrX+meb0WzQPs44ZYLhKxxqXiy
         M6eA/192dREc7iB+5pbN2kN6htf8vObS5itqQ8rtJH6cEApO3pg7cYJTVpNwxU4b2A+F
         TQLWpaOTyYjvmboVX/hokmoSq2+RnZsh/B+4GhMndxPC64AJygHeNwc47mvnpgBG2SoW
         yIXypSTMJpm1P/cXsJsaeYJ55z+TuewfRSUG2oBi36OdQD0igfzny0+U9C2DtowrrJlO
         Ez8wql/BGFVJpZXjLZVyiQhC0f2nmbWkypEdH8PujxfUjTh3CnzRMyJfwu5uTegXa6le
         o8gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787832256; x=1788437056;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GP97XYSOxAd4mwkEh8pXHynZ3Zgb6dcRm0VHZ16u2ys=;
        b=oGnzLnR9L+sKDb2v2q/eCPa5K85f/ZtH4B+d2hiI585B8oTW5b43mSI0dRA81LNcjY
         26Ovdfw2fPKgGTVdo2Y867m59SjBa1kph6ozEjYMBw79kePASE9xJazFQcij1eYCfmWZ
         fx2sdkx8cy/ACA1g/5Wyx3KwlbymyeREgjSKz4b+lyEl4tCPcTyzvxt/eZiL7Qz/GI16
         X0w1J9EwsKlLHDKmpUsnIcgYwTj8/5o/XoEW59YPl+X4XNwMuQz58DSP+Qvu+iGabVgp
         eFytKBTQXkCbRQvJ57HB0TC5KC0X+NU6/MQ8FwCKZTotzrT+B+2zg7JRq+f6lO6rG4Fr
         rJDQ==
X-Forwarded-Encrypted: i=1; AHgh+Ronsef7cph+MdrBbwjGo/Kq8AkP13KiNf8jtx9C92ZuqNFNJkL14ksQjh6oOeAhaBZ8TwWVoYIoEw==@kvack.org
X-Gm-Message-State: AFuF++nIYdZUWXFjEXN90/TeqqPAoEOZrulIF/5f9/Xdpl4XzrmI2f9o
	dgwFqKSvZn3SJultLn+m0kQkp6Kk+D/viQ5eWoaV4MgZEqFTqcZVc1H/AknCOcvOdtkdB9KKkQ+
	1b9I1q4E=
X-Gm-Gg: AR+sD10ZvNKnPdDXFLSsKPdn9TaL6jIEfmvuPq3nDZfexn56ircPvVm1XYIm3zuBqHm
	9wChGqAIfe5iPzZxSjSFxkjLNXsXqPGi8VGVlP9ZJDNbcpdCL+OcyFmTWLDsa/htRAHWkSie4or
	FqzDiOAQhYz5aVMNMFLnNkWw1yzxsrO30dX8JfyPDbxQWDQuiecN1pk4wztbTKBChrpnU84M/af
	PtlE0dsjcfp9+xAk9Bfb1Os549smFBUF2cNaVZst2tOCmFIMIItMoExqO51Dybl1EdUWvDUA4Oh
	V7lBJGDfYzz3rmvN692Yi1+Kw/O3e/G9VekmqL6zRlplR5y9/yS6E1fBEJarHZHFSCohhKMwAfU
	ieS1C5ITSCPwb+0SDLSIKK1KMcvXgKhQQBmZmreMSxb9oWW0kAlDy2Ac22HSL9L7n9tKsnyH/Rl
	AdGnaTMiPBejsSb4866xRW+4pvk5oRE2EZdZCcSvrl5x8Arlnr/MKaH4qWMo2/afU1Gk2CtWG5g
	V7CLvpSHPAz
X-Received: by 2002:a05:600c:3513:b0:496:bbce:fc with SMTP id 5b1f17b1804b1-499dc82c0d7mr166799585e9.12.1787832255539;
        Thu, 27 Aug 2026 05:04:15 -0700 (PDT)
Received: from localhost (109-81-32-216.rct.o2.cz. [109.81.32.216])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482e28dc134sm8549762f8f.20.2026.08.27.05.04.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 05:04:15 -0700 (PDT)
Date: Thu, 27 Aug 2026 14:04:13 +0200
From: Michal Hocko <mhocko@suse.com>
To: Hao Li <hao.li@linux.dev>
Cc: hannes@cmpxchg.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, akpm@linux-foundation.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: memcontrol: treat disabled memcg as kmem accounting
 disabled
Message-ID: <apAnveXHmeQlKJnU@tiehlicka>
References: <20260827091813.22327-1-hao.li@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827091813.22327-1-hao.li@linux.dev>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 11A65140014
X-Stat-Signature: out378b78zs3h54mz4kk894ardhde4ct
X-Rspam-User: 
X-HE-Tag: 1787832256-268956
X-HE-Meta: U2FsdGVkX1/U8mXLZij3khSoByolKxGUBdb2MrwikVGe6qOCOpwNQM3MIxE8+CFfDfzeTL4iJyaftUco8oq2TSbQQNTBfJ/7uV5i2vYKqI426KLaoLKLCCNB8pyA3Fd7Vlc6PCk0RtvPFlMYTkOtGbN/VG0scqNJomH7JnmRyMWiqeZkK+yggI+KMu+MH44mt5aHrjTt1lJwzm30h3z60rH68qzw3f+oOjb0wlxAlOurbIWCoSutOmqCyTa6oqfAMtAzlVzNwLPkGieDb3ltdiByT4K3jmDG6D56N0/DojtWFgfxdVd8aYWo9Hqq8SKfsQs7osGCinPlIpOqki059ysPoUiEC961BywMpJD9+2jCdGKuzfRUq8yumJSABUA1ogqXTY0yrSwaKQwGMuzH3OajYX5s/99sdIJaBkDIwXWut57rfJDjRyhgO1qdsLF9bT2PcGIs+L1PhzzUj9FLbPU/ITs5rph7nfETQLV/E0mEUz10aRdy1OEbdBlHotks7w/CaDJSvVi+OJPMPks+HXDccnZxQsoLDw3O0nr3X5lS3nu+P9HrsLsdGgrKm7EoqzETkPZbBefyyfUvHsRh5MmMkGvxmnyCn8kJkbOl/MMhdbXNrT3NalfFwWVJe4EwUAU509KAxaDendgRY0ypI5jXQf1HfzSs5rEmBBmRS0xjrlnDBGb3ezDkBKKyKKmNS7cXT20HWyeVmrEHKSrp84Bn+E2wHGy1atooGiHeW9rq7HbvhgOowbTemHegQBAuj+t52h+JgJU5ND8irPbkpuJs8ElB0G/Z6zmtbX0pLBRASDWiGKWqOskmn+ASClVRlfB4BFabwJnDPmAhkCs4KdRjocZycPMTxLS1ezsVulI4IVYWY41Nzp8rtt5kjQFJQUlKisMe6ngrYALfGZ0wB71tuNSNLwUMJubprXwMB7uE4v1scaRwqO8gb6h6pFTIV72ZRoNK2kd1UOfI8Nn
 /QH6jqDZ
 v3DmGjZn0aRWJyIg6ZV/CClBCCmAPkcpt2txlAAUQZvZheXf9FgO3MyoWT53X+YuM53dC/ZgK/zPOHdLVPqe7leU5h+gnQE8s5jjXZ0WrKT+oHf5aFr8SCod/D/w0pDsD8XXujzn3ZijSe61dqz98vlMqqd3xtljYJph2+Lc07VvDBuIj5nuMxi2dHkTBRvqqjbLkHE8JEmmyQMPtN23U7ul65pdW12QaQQDu3hOyrqH4p2/7qhf28ZyNAUVWxtdqnQ3iUJ6oo1nsiQndrR6cXgW/gnnVyOX92jyWKP9STSWx3eoWzYQT3Ya+nrR4FNiNU7MdO66gu+L0lAvYlcggA4vL5s99mB7MnQzW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 27-08-26 17:17:50, Hao Li wrote:
> mem_cgroup_kmem_disabled() currently only checks whether the
> "cgroup.memory=nokmem" option is specified. However, kmem accounting is
> also unavailable when memcg itself is disabled.
> 
> Check both conditions to ensure the function accurately reflects the
> kmem accounting state.

It would be really great if you could describe how we could end up with
the inconsistent memcg enabled but kmem enabled and what kind of effect
does this have.

AFAICS the inconsistency is possible and it would lead some wastage but
no functional problems but the changelog should be more descriptive.

> Signed-off-by: Hao Li <hao.li@linux.dev>
> ---
>  mm/memcontrol.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 1ebceade4021..b28f6165c354 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -132,7 +132,7 @@ static DEFINE_SPINLOCK(objcg_lock);
>  
>  bool mem_cgroup_kmem_disabled(void)
>  {
> -	return cgroup_memory_nokmem;
> +	return cgroup_memory_nokmem || mem_cgroup_disabled();
>  }
>  
>  static void memcg_uncharge(struct mem_cgroup *memcg, unsigned int nr_pages);
> -- 
> 2.54.0

-- 
Michal Hocko
SUSE Labs

