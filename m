Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D2CAC43327
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 18:53:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CEDA6B013E; Fri, 26 Jun 2026 14:53:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0802A6B013F; Fri, 26 Jun 2026 14:53:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAF706B0141; Fri, 26 Jun 2026 14:53:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C493A6B013E
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:53:25 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 490A78F2C4
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:53:25 +0000 (UTC)
X-FDA: 84922961970.28.15E50A6
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1DF011A0005
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:53:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=FQ1r72o0;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf19.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.43 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782500003;
	b=qAhS9s80BEeCrG3pmPLhWw5RLHWDGHujBAy9H/MnGECe2VgvnS05H8MbND1HIWJxnbkLah
	09YZglwnYrgSYQxpxWLKcD8lH8bdrt4wwTW54PnavV+CDiuUFFQjt5702BigtoBYkI8m64
	iCPtXySQ8Rv2+TvArKUotvArMWB+zU4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782500003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=69VEjjKoDye+wBUZ6dmdcwCgt8H3I0Ua/NDklzX2JWs=;
	b=U06wvrwYGxMxh98zoKjrQj3XRNVPr0uERDT+veNq/v/U5Bo0zsywFjnECzbG771Xeli0un
	Fuw21eMSvIhtiY5w/iWDLLLhWHi63uXEFDnJ3VLTRUrKqkS4Y82T8NaYYlvU60jP0Ws3TK
	+AMVGLG4AfRdG12Z5zrPQuYxvRJMvkU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=FQ1r72o0;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf19.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.43 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8dd74f90e3eso12545326d6.2
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1782500002; x=1783104802; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=69VEjjKoDye+wBUZ6dmdcwCgt8H3I0Ua/NDklzX2JWs=;
        b=FQ1r72o07rcXyUAG+eaidu65ZsMMF+xj5LjaSK3HzVWPIBGbisVIecr1pQrpMzWyEy
         6KHatz1ICGh3+RbkqONU1yGApqKObQ5Pnsis89/7JuJUQsU5QaaOhBsTlypvMR+0jIkW
         qNNqJg2kh3RiaV8unsIn8Jvvkfa0hxr7N83l2C+SXYORAkSRgG63yb1ewydepz8iSjj3
         VawYcPD2I6X3t46MgF5upiJERhL5fBnYSWFmkmpzMBm+Irki1Qoak5+LY7XxFzkqXt7f
         Hhj2UfjNxVa9pzf14ggb8UugSkzMU8wPiMci8+8gwUB+bCPv0JhFdgmv5AGaUhxiBJtQ
         ip/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782500002; x=1783104802;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=69VEjjKoDye+wBUZ6dmdcwCgt8H3I0Ua/NDklzX2JWs=;
        b=rqk/AqChrr5cfp0T/W1H76qLPZIFFo4WgllJQF5StYbvXYV+m7bOd4fInzRQt5xym9
         b5BX/Byf6E0lrMg5slM5FiBoez5BgHXYcn5D+b0qPuQE2bKWKFhc1rsgvLEDBmeZefDG
         IswTQtXtPDvfuQuwxpO9D/q/hg3pKlvLybXhkPjKxpKYJ9D27GJj6xPPhj5ODy3CaN9U
         Dr5NedsX+TB41Pgfc7BreVDKDQ4l9uWRD2uY3oWsrgMXWwL9/xSX04l8y/vfj7Xov1xU
         pogFzlEYT1PXiktU3PxRxfhgvetfZLEr54xb+qTRN8YmbpAy8RAiOgICueRIHX3TGZlc
         T0Jw==
X-Forwarded-Encrypted: i=1; AHgh+RruXe4t+FA3toewb5OGVcVUlG8rzvuTJNcYv+SPYtwCWS8jZJUPsQk21A8CitLUccg5U83iNxPg0A==@kvack.org
X-Gm-Message-State: AOJu0YwAGADz8xSZWvClSwwauOzX1QUPuBAMzRMzRklSs6M3i+8IttZW
	u56XsTrKLVEHjd6ngYZkqvR3pkl8CYUzrSHqP8Cn7/j0eLlgz5v0/O4rfUS1xN/+QQw=
X-Gm-Gg: AfdE7cmJ/+or7ELfOv3wxSzMyVJGeXKGfKfY8S87tXbyTv+7OygyLwYy/1eX4awvgTT
	7YPKJrLpEsXEfZf1Y5W8b7QSFZxg3qam/G3Zy+DjgiuzUl99ukPYwzHP2zi3dXprPIWMZ3blSCI
	LjOWZ8/5Hiuy5eiJPd2ryAmhzxQEqUcSSkT4xafZ6VfrodG8GGZ5CUCPHKpfuRMnK8ag1e5bFXK
	968vdV8/bm3ufWXTKW6+4P0TgOl6vTtBs8ZyoDS5TKoE2o20HSJ/6O2JRDYe4LIw1Zerkcgt81B
	Vkx4cH6znx9g/XxCro7pnfic3KHKdDYUUom4KgCGNP3nlHTIbKfZXPDi9kiIVDmxSy5tFMCHuCO
	OS3TXOyj1twaXvPmbYvfGux+YpvQ5nz/qOgBIe+n/5OLefhfxM5a8/gGiOvAxRYDbYbzHcHdjxk
	oeIbI2OIlX7Wo=
X-Received: by 2002:a05:6214:3907:b0:8db:a79d:1f0d with SMTP id 6a1803df08f44-8e98609495amr30686266d6.31.1782500002098;
        Fri, 26 Jun 2026 11:53:22 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8df7f0180d3sm219727366d6.3.2026.06.26.11.53.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 11:53:21 -0700 (PDT)
Date: Fri, 26 Jun 2026 14:53:20 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Breno Leitao <leitao@debian.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com, stable@vger.kernel.org
Subject: Re: [PATCH] mm: memcg: initialize *locked in memcg1_oom_prepare()
 stub
Message-ID: <aj7KoDXJv3NByGUm@cmpxchg.org>
References: <20260626-memcg-oom-uninit-locked-v1-1-a00175936b39@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626-memcg-oom-uninit-locked-v1-1-a00175936b39@debian.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1DF011A0005
X-Stat-Signature: zsxakfjjibj5zujpxa3erzb4rsusgk1z
X-HE-Tag: 1782500002-687281
X-HE-Meta: U2FsdGVkX1+aCJX3VUjuPMOhVZTVY8gyZmImRBY2T1LDX6iAAKIwC58PkpsjYUi81K6n/JNLThkSDv2vjDZ5ZOR3mKskLl1edLG2wnaXRwclvw7k9EQQNdgPR/0w1nTaJQZgm+A2jqIEc0yPBF3f3XjO9qjPTHjqWlMAzgjksgShPWtKvTVQCma2SxyMctIFaolYwDp1uHQUaRfHCtva8OEE5UG7U7zzd7hvdIOgc/k8n68ahr4/t1DPH1BoDgNHGxtHDaXo+s3zQcSucmP3Iehm8G1IQMjNOVl9P4OdyT7UNvjEeSRZzhu6s+ahB2Sc9a9VrNuJyKe4U8Kzpj/pzyCZbR0b32WzM/U5IS3OLALD+mZGVSzDpNSn0D3zZTsG/o3e0i1shcHc3rWnboY69+W8D/Iibi3e5oAHdqUKlS4xViYPkzXgAaD67ePlD2A3aJKVQaU+AzfxTtw5yxQwa+YOmBepmPr/Ttf45BIFeq7rRVYDXHV7iaeVn7iKb+YV7htgArMTZkibdw+cnuETcKiv2etl5BQtnFge/Qr6nviekl90wGOqklcJetkOhRARdXs10tFmzV/qDr5xpJOn9V8MCif31mXeeXd5Z23ffOPJNGrEPMtZH8q/hKOcz8+S4IlMA2UkUBj7k1QpA6fYsV0NFDGXAmGYtv9Rc1m4DCoo+71Mj/I7VG7aBCAgNE+4a4fJ6VFHhvKMpXGHAkkX2SqoKFaLhhfq9NUBMYFnSaY/Y+v34gsS5P2nOepMonEE96YE/zeaQ84oT3ujx+4jGeuKGb5QEzwyoXFr0iPRFYU0U86B1T5VTan1apPPaDuu+3tuSV+nm85qj/NE48os881P7d7D303ll0/5CFSVJYlnV2DFH7SdCj6rDQpdyoQWgb78E2ZnKbYkQ9TPRSLsXuCilJoSC5bqqNU903ZUfd1STGfIGXMobDGkRYCubT9PJnUgiKAingfczlqOBcD
 wErUgns4
 AaX2b/A6+WiSXjE+cKlUvISGqR6W0qg7EgNj47BJpoD7NuAljvhYdUT5S5Qr9kYS+CedRp/8mBYw9hVobzCKHD9cu0m535Zu0PLIuCAesrYwk+XIzNhE1VSmZsY/aAnfxujjc8gqw8VTlwJ0bvR3mKFTD7lbaZv6CXBkw8kx4bzo00eN53xN/aIsUH/Ub8XzSKC9QS0btPSfbVrtfQrMmzyPNtKPOXUFy4xBlPEhZ/jq0LZlCj478yM1xVmGha3/GbU+NwO/YpSxsSpTesAU4SKBAPed11I1JaenihL+67ARvfks+uBzgAdTt97R1+Kl99B0jFCLLeo5WFaeQ41u9v6mmOHB8M+9roRRAprtheU09cUPOhtbyuAUBektejmJP7UrGdaEMnvYe6N4/bfV4r4z7uOnVJrjfAc4Pq2Tj6xZNVutMfc3fPuTUIzObFVv4/e1Yn4fpF6sJVgnTOyjanWbgPRd44Mt3XEQGUpgl5mLKDoD004qzR36tiP/xKpM+OVce4h/RwCWCX6fnZVNqh9/sIA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 26, 2026 at 05:43:02AM -0700, Breno Leitao wrote:
> mem_cgroup_oom() passes an uninitialized "locked" to memcg1_oom_prepare()
> and reads it back in memcg1_oom_finish():
> 
> 	bool locked, ret;
> 	...
> 	if (!memcg1_oom_prepare(memcg, &locked))
> 		return false;
> 	ret = mem_cgroup_out_of_memory(memcg, mask, order);
> 	memcg1_oom_finish(memcg, locked);
> 
> This relies on memcg1_oom_prepare() setting *locked whenever it returns
> true.  The CONFIG_MEMCG_V1=y version does, but the stub used when
> CONFIG_MEMCG_V1=n returns true without touching *locked, so
> memcg1_oom_finish() consumes an uninitialized value.  On a memcg OOM this
> is reported by UBSAN:
> 
>   UBSAN: invalid-load in mm/memcontrol.c:1932:27
>   load of value 0 is not a valid value for type 'bool' (aka '_Bool')
> 
> Initialize *locked to false in the stub; with cgroup v1 compiled out
> there is no OOM lock to take.
> 
> Fixes: e93d4166b40a ("mm: memcg: put cgroup v1-specific code under a config option")
> Cc: stable@vger.kernel.org
> Signed-off-by: Breno Leitao <leitao@debian.org>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

I prefer this way over the idea to initialize in the caller. For the
actual implementation, the protocol is that the thing is initialized
when the function returns true. This version of the fix maintains that
for the dummy as well:

> ---
>  mm/memcontrol-v1.h | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
> index f92f81108d5ed..4fa6e2bc8413f 100644
> --- a/mm/memcontrol-v1.h
> +++ b/mm/memcontrol-v1.h
> @@ -107,7 +107,11 @@ static inline void memcg1_remove_from_trees(struct mem_cgroup *memcg) {}
>  static inline void memcg1_soft_limit_reset(struct mem_cgroup *memcg) {}
>  static inline void memcg1_css_offline(struct mem_cgroup *memcg) {}
>  
> -static inline bool memcg1_oom_prepare(struct mem_cgroup *memcg, bool *locked) { return true; }
> +static inline bool memcg1_oom_prepare(struct mem_cgroup *memcg, bool *locked)
> +{
> +	*locked = false;
> +	return true;
> +}
>  static inline void memcg1_oom_finish(struct mem_cgroup *memcg, bool locked) {}
>  static inline void memcg1_oom_recover(struct mem_cgroup *memcg) {}

