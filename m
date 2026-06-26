Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 277B8C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 13:56:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10CAB6B0092; Fri, 26 Jun 2026 09:56:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BE0E6B0093; Fri, 26 Jun 2026 09:56:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEFEB6B0095; Fri, 26 Jun 2026 09:56:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C4AB56B0092
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:56:17 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4F08512046C
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 13:56:17 +0000 (UTC)
X-FDA: 84922213194.02.9C54E78
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7B3C680011
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 13:56:15 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WLUWabgr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.52 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782482175;
	b=ZzxlYq70RHzmPKIuKkhD9KqW67Ln0N4ivqKW54ELly1BrtDDI1SplMZpShsKMeoq8b7w8n
	RKd28/1SAmUWvElN6THgy0n/+h0nIZWcJZmZMLTkXo4CfxyBfSygY+P8vM/rmYYCrbZSSk
	hqUGRhLthRKnnF01pJ2BXTOxGdJxAqY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782482175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3f5RmGjrL90PeH3JGsX34cT0iH3rBjCVdu823akYB8U=;
	b=KJDq8iruxIXuS1ha9ufN8NJyc9lezRV5HT+ayLqbJmFbkC7G67aYWeWsRkfQux3z3ml4zD
	Ock5YKcTUhGZ0C9rmBucXmd5PPDg/gGRny0UxN1p22ypSXGGuu7cNz5sKzBdkG0RJkuaCK
	Y8ns0g9LdpOAExmjlG0WUj07TAdkSiw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WLUWabgr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.52 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7e92cb77209so683560a34.3
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 06:56:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782482174; x=1783086974; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3f5RmGjrL90PeH3JGsX34cT0iH3rBjCVdu823akYB8U=;
        b=WLUWabgrUldjU3BnuIsgDov0p6rA/mAdJAQVOrdp1RlgRAXL6vDdVQpgfBFLpMu/3c
         iHb7k4VePvsL0XQlWUAdbM3CTyWhLmN4Ubp6MYdL+qNzUxzuLIOwI3ZByFtsifi9TprR
         nArEJTG4IIjXw7tLlthR4uWCx1o9gZtYjnwIRgawoD97nzkRi1ve4Y2lwhVkGUY+QkQi
         7gQMKUSBSD0RoaFy58hXitgkHcqknHvZD6q6SC3Ns28GGYvnmHO/JSVfLxOfyID6ryR/
         HKoEVIBmT7GHM3wBPMJVmve2MnonsP0sGWgXnBfHeJrvu2O+PooqO+FcsYzsAImwbJz9
         eDxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782482174; x=1783086974;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3f5RmGjrL90PeH3JGsX34cT0iH3rBjCVdu823akYB8U=;
        b=Ps1Rwcwxfu9vRk1O8qZmN8MGv3Qjg4Lv+6vVJAvFXiVtrr6dOI7Ck9aZG82t+Hbj1L
         eask2UI2L1BREIslshmyCw1PrDJpvsKfmmX4Dt7OqUCs2trqivUaCKj/qu9IWPMFec9S
         26MnchQuQxG+BXRg8xdPJpu6EIp29RQw/bMgaU0kSKntQzNSqzcKDYkZw82OSGva4dLF
         QgZlNNmhIgb7CA6gvOTZ0IQbZ3pPe9ZxUHyuPUhrzrbY9KqsxPZ44pqOMgEMQd690Yfq
         lyGESbV2jJ4isiFr4dnhn4lB+bG65GUK7daSEJnUk8nekGlDqmxkPR8ketxue5YLE6mB
         bpQg==
X-Forwarded-Encrypted: i=1; AFNElJ/9bpmtS76RrTwFXCmvwOzLhHhv7pw1tglazJTji0Jrae1K5O507tMrSrvpjHtRRycQy4q9wZRARA==@kvack.org
X-Gm-Message-State: AOJu0YzqNw5/Nby/AEYe6gmgUHqB/kTce/yd63T5Ft398fYWOeBENuGZ
	st0/ZIbKMEKUDNWKheCy0OJ8eiN1OMD2TUKblu/uOfphRyqqzbWFBDn0
X-Gm-Gg: AfdE7ckcC53JLZAWRygpv4GbM4g10RvmU5kSSb5aXlf6HSWGemC9p39yeorK8knATgA
	hqqdN6/2aNcwwARHfQJSDt8JUhxwSnjyZTbR44KhpbG6TI1NDEqZ8aS/5ilVfIDNx71TDFgiIyk
	m0fiN1hU7vW+oe+KorM3/ME4/atnz67KrkN7g77D0OSVDroa4BZI03QfrEruHPMlFsahHy4Dkee
	E7CbB7HhLb4lsvFlJuOrXPB6ISVAsFd1TPMcCfuRfCjNxCaQimXEml7E4GukZPIAudeFNDxIdK0
	1gepaBwTFybB5itBrzdnaezre8Y7PuHmYdAiHxOVN8RmEMxiYwZn53SD+3snBpHe5uBNm10OROA
	QduEXa9/GBGnirMiHbsVgMmFVFgHAzo6KjI89LGlC53lKs2ws32TsnmkNFaKJWaN3o3TS/1uRec
	b34vGKnFvmjSfAGf1cjdwYnLE8Y0GhaFb8QcvaWFslSBOdrtpeVXLcpg==
X-Received: by 2002:a05:6820:190c:b0:69d:f889:f55c with SMTP id 006d021491bc7-6a135208f39mr5607866eaf.27.1782482174366;
        Fri, 26 Jun 2026 06:56:14 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:40::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-44748ec8a42sm12948931fac.3.2026.06.26.06.56.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 06:56:13 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Breno Leitao <leitao@debian.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm: memcg: initialize *locked in memcg1_oom_prepare() stub
Date: Fri, 26 Jun 2026 06:56:11 -0700
Message-ID: <20260626135612.3697893-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260626-memcg-oom-uninit-locked-v1-1-a00175936b39@debian.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7B3C680011
X-Rspam-User: 
X-Stat-Signature: rb7s53dexq51zx57tzrjzthh47q39b63
X-HE-Tag: 1782482175-656423
X-HE-Meta: U2FsdGVkX18nsK8+vpSdgXYT+5Be0gQ9p9pySUrvfPa5NE4w6r4N4BCobSaKE9yaeT19H08RRApLjfwWXscs8rUrDyODS3fPbKMWaeZL8asqZzX/XJwkxaZ3adkUK4hlYLIKLAbcBa35CLTV/xYhF16OQzfrKvBLQ/VsR47zkuJRcBRiZwOGFocREfc09rhAypaHOKVCsaJB31v7GC3qBhDjw/F33+wBEZs8sgUfRB11SjiPauH1rmQw9mLgfuU/uAVHK/OovFrGBeLWt8RKYCjqkidlLipwiE9cUVNmZLkvVZ0SCDeMsq4yODQZO2Y2JbFzAwTOKfc6pQTxidGUNs9d2yucB+/d1veTG5aCyS2eTeXFBn976w3z/siCAchW7dWO8Jx38i9ipb/bRGg+j01NYlVjpMklTjCNNzTOUj1l+d+v0h8jOc9UzUR3d+DoYX+8GCVDn0FOnLwu7xablCcCm6zLJvYomWb7jwFLcJW8dk0/D8m0vkqQHg1FPCLOr+jkNVQcsNL7WZ7WeePZp22mEyBS6B50OMU+ReKR7sd/maAc4YBe5na1wacjXfH8Ea3F6mI+83POTN0oE3SsHEv5bF/MJv87mZhQgB60WugbIanskO07EircDw6prpfr4dnnqGffBnGvs7cL/HsLO/XrG6HjmJ1866KUwwQQAKSfEYr4nRvjjeMUccpNCLHyw7DYQq+PBhWTFLsLi9Jwtm81vPsUKmDZ4JpLirV3R5VZfjjj+OXh5Rm+0msPRE8TpwWzphjimZd041U5fhHW3PltSUCHRDX9Vs7HwS17XGgQn6Yg1L6aOUGi8pIvIJ6CR8pDw9Rlp2jSqTLtlnYJYi9PTC4nfwcmDfWMNfFqQE25RvODGDSdLTISuGCYFRt5rzJS5W07gfEfWjcKy5U0OF9b0Zb4YRs9LjwxP3ANOtNCK7m8u3AVmMFcA9EhmeyHwvRgK9jgjg0sX/QLwPC
 iCXHiOvm
 QDlGk1Sd9QB18UtnTE5X9gZ7gV+FYhpIpysajAUPnCDSZBYIlBheTFaXzCoE03bCg1DyAVwJKznnt3tT+PkU5ThDRd7c+nfbDcV0eX8PLZ6Vmh34wZKdCJvH4LiEyDYUBUXSzjy7FPSKVy2Ffdt5LVGlLeU1X0kTmXIqnIQdyzuom21qaagsVVfAZMrGesW66b8AzC/JmrmE1aTWi8FSeTZUwyur1F1b3vR9HNL68x2kga06BmAQ9YiEGrsO92euyhDFGOIFr6627IMq7X2NMTK9UNg4xil0cYl5zROrc5jRhpEHUtijvhsAzWxnk4FzOuVhzqhFbHuaAYbSmJQjRvE/Nk21mFITTdZXvmugXLTKT6yBdVFhMx3+Af2/SAMNrGuZjM/fsC47kVdcQeP4nzA55uuBND+knBCilzaGV76AYr/S3RB8sqIg7m6VX+mZNIRJrezC8/RdTI92Vzpg/9FSNPKZkE0WUS6iD15giJoiGfgQfGl7BpgC8PAexSLITH0OXvDZSMu/cGP9EH9cNpmIbpwq9HPHoSYQyj8Rah7bcmcNoRXFO+DGUhyuZRX2I8f0Psv/TQOxVdbR8ZESe/6Gg+5aoZ+EMubzv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Breno, I hope you are doing well : -)
Woah, thank you for finding and fixing this bug! 

> Fixes: e93d4166b40a ("mm: memcg: put cgroup v1-specific code under a config option")
> Cc: stable@vger.kernel.org
> Signed-off-by: Breno Leitao <leitao@debian.org>
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

Part of me wonders if we should just initialize locked = false in the
caller (mem_cgroup_oom) as to not make the stub have side effects,
but your chnage looks correct and this is a fix so perhaps that is
not so important.

Looks good to me! Thank you again Breno : -)

Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

