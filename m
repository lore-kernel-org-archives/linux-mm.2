Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71E72C44501
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 11:43:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55C6C6B0088; Mon, 13 Jul 2026 07:43:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 533EF6B00A0; Mon, 13 Jul 2026 07:43:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 471E36B00A1; Mon, 13 Jul 2026 07:43:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 294D66B0088
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:43:18 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B33B486984
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 11:43:17 +0000 (UTC)
X-FDA: 84983567634.28.83302B6
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf11.hostedemail.com (Postfix) with ESMTP id EAB2040004
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 11:43:15 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="h2UBeH/1";
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf11.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.54 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783942995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SeyDTwT5eBKqoeDyITbPcULJkHcUnTXSu2CQ0OyNzGY=;
	b=vKQVOfblr8fyJtuUh6IvXPcmx7VLMSXjaj8SRA1FP/5nhMQfoh4b3mvpWGelz0tmimEWI+
	OBjsajfhnkJUe9WBKUk24CpGurjkGMrHa4tMrSa0nSnqFJoQeF3hE9iFD6vWgQM3qmKLEY
	9A4rKIZvYQuUqY+MQEHOJ2VWJx7+E/U=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="h2UBeH/1";
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf11.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.54 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783942995;
	b=ElLDcTisWY8LZ/yPoJJC0BD+g5eXERt0VlwS3tMQvsiBCU/CmkfNROKPs8uu0cryOqHgQk
	s1U2lQt3WHatRiTRN0Arz2XsNWAI2GACBljaGsKntrL+AUDSVrk9r18ETYQCAdWdBJrkVn
	jyrpeDNbK0jtB3k7rSU2bVxvCCjCPf8=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-493f60208a5so26219325e9.3
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 04:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1783942995; x=1784547795; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SeyDTwT5eBKqoeDyITbPcULJkHcUnTXSu2CQ0OyNzGY=;
        b=h2UBeH/1KbIe8wE3PPoDbXRCHvHMEwj77TtXG22l1v2Umrf3R4a20fRvt/qGGGM62q
         rv71t9kTIyFaHL/LCGvj/Q5yMcAJ0JEzTAb17rH1F2wnZG5BQj2/iZPd8ZOFyf++t0cG
         uID+ExMGltCBCUejBums0QsGXg9sP+tfyxnrrOirxMDHRtsLXV/cO1tmkewKSSmBI3jd
         1JEPr2fchZin1Dzf9bsSga+eIw4qa0b55mAHLQr7Z8hx1BaSMEuST2/0B8qa8wI5cCiJ
         XpZ9R/TOnDAKH8j9O33tRGWEBVdhc5vxAqqUKUiJRII9gxn1meESecJefPnJueAb/U1W
         vf4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783942995; x=1784547795;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SeyDTwT5eBKqoeDyITbPcULJkHcUnTXSu2CQ0OyNzGY=;
        b=HfNDWEDoIJ+9HwNl287oCZZFZv7LejEJhrJGPOJcaAGEJgCaVpFxhNPXbIa7yfT2kT
         RV1xWuBXhJcVzmROQr5jn7ICVv7UO27CW+leda2i/Dcz6whxvID/vwhNUzp8L6/GX3sE
         QQmqtJEUUKog24gsQ1+MCOII5CiSytdLUcyxnqyDIGlCV/tdVOhmUlW85lH/AZ/y5ub2
         bLTsfG50zslv1fOMwfT4eJ6w58zDT+90QqqK6btJkBpM/fuILgMywaiyjAu1vk1MPeWQ
         N6ei7+wd7rVi5OwKAJ1X23EIxiwYD8syKdU2QATBNiIXGz3Cftf3NBWl0IPOfJd+p/MR
         b69w==
X-Forwarded-Encrypted: i=1; AHgh+RrZ1wcBWhp6CqkWTry5+HTc1NKVsY4ylXUfxZ7urD05s+RbZZ5I80t5SFSqRnaXn8MDk3YdqlpAgA==@kvack.org
X-Gm-Message-State: AOJu0YwuLw0OyVmfJ0tIC6lp6l3hiAl8o6MSjh8PkeOYoQmttxhBk6Gg
	EWx5bpSESM5Y7PG/k4qbgatcx/iCg/SMP58cqWeyPH5hjQwHjFK8IuVI8Qqed36i1+8=
X-Gm-Gg: AfdE7ck1BW+tkfEK1ry6f8Mpz1Owym+8H7ceFg76cJkeRlaX4gQgxaljPdvqHXd4gKQ
	/k1ahqHJucm29CzideVF4Z3znAmtdyw0dzT9y60DmD41nwVjxLw1mbWJeJbqiIa5HQiyUIyAfxr
	Vin2gzWrKAx5z0qZkgy7EhHcPmwhew5qZs1Oc9oMzcrN3nyHoe+ZKlUXYxUltU9SVEWCVCtSNiY
	+oSN3HaOz3RHrn/f9NWQt/aWutxmSjrs3YYBOTXOMIuVlNZrS7NLXCCt+MpgEUA3xWud94GBrLt
	6OBxIxk5qDrp88qKTp2kx6i1UE+EVhnpCymsK55xBMSFBiMzUFnc0GtIrw7/cZMDOCl+DomyDhw
	9n0Jqu701u9Z+NTkgSt+u12WyDid+wq63Fm9J90unACFX1NakfWsCT4NcXGj2ESITqcsGvZdBk7
	veKGFAXf3ehv0gBh7bqZyz
X-Received: by 2002:a05:600c:5392:b0:490:b00c:8e6a with SMTP id 5b1f17b1804b1-493f8826bbfmr88216405e9.28.1783942994704;
        Mon, 13 Jul 2026 04:43:14 -0700 (PDT)
Received: from localhost ([2a02:8071:6401:180:d892:bf43:a0b4:83b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb6f3dcdsm349445725e9.3.2026.07.13.04.43.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 04:43:13 -0700 (PDT)
Date: Mon, 13 Jul 2026 07:43:11 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] mm: memcg-v1: make mem_cgroup_oom_notify_cb() return void
Message-ID: <20260713114311.GL276793@cmpxchg.org>
References: <20260713093737.3299646-1-guopeng.zhang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713093737.3299646-1-guopeng.zhang@linux.dev>
X-Stat-Signature: 8tb1ha658kad4pgbbyo69a9xpqrp3uuw
X-Rspamd-Queue-Id: EAB2040004
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783942995-844742
X-HE-Meta: U2FsdGVkX1+ux1oJ+ePPj8omEGN2bdY6HS+RHzLsZLBr8FcGaO+UU3p8KrqcVjebDXGKwDfANPD5/z8MkA9zyRghd2ImkXvM2uey94YEOcHqQadg03k6WwwKwx2uSGcXbf6lArmQhlq0Zxk6H14iMlDVrdnhfODq4FPEx7ngBDq3VPQ0qf4C7J1AvepLojTzAknp6GljE7BDI2cklDdQ0vPU8duQMEABxx3ZtpiOKsALKBT6GVUAQsvnwaBdNjpzYVVNdoCzhh+Vt/wULfhMwrNVx/8MZaU29CDO9L0smHwLRahrHR3nPS8SfursnZYOlUvPoLBscVDTIDI2j2b8KIPLP15KWQIB85R6+S0oBxWxIXeWpJuKmlLh1LYJOG1YqYhtnrLnt0nLILtV1u/c0WkOzNSSx7JnnoACBrCgpfw7DItvBiUe0hsHaCHcnCAJ//udC990Hjw6tv1BVNjgQ/7GpjCy2+NWwfYjnfok/PdGaEXOuLub1SAKFJ6aJIhUdPOB23wpM9gzUTF4MYRWM1/cYPFMwpvXqdfESU+xis5xxQPo9ePN/V5XtnQ3yM5AgjmNWA9KtCOiMhM2eUoTJ9dQd1OxNZsbF/1Q/7sYXhauh92K2ZQQRye9/MeqapoSOO2R0/AAepyPINOuoi3SDyZofs910dhfKZzCT3AAzj2mZGiTix5TxbY+dD10nMOmzs+yflzSE8nCWEeTBnpYfjeXvX0BXkh1tThM2gxF1WIF1hiMFW30Mm9SiTsSUbefJqWb568g+/LEmkXv6iYRsz8xD/iBI1jW97y8kyn2kGI4NAKcARGCPnNIyCpxSlBsAl7mOyEUSrzfEZKMaR3b2xaZwbCleaNPIFA/HBOm0WGnpUjL8x5p16EZ2XH596t/Gt7JDwR7lpyfd5Fudgc5FB89BhR21DB32w2XQtSlSP7KjG8CkzOMTlK4cLhqFD4EDLB6PlfxQuc0bpHkPqs
 26kC8sQl
 pGTVzt0ybgLfb60mgCIHSD4hcjn1+YdXqLIVNMDilpN43YrSZZhsXa2AqOCUZGr+QJHFAbZ0tY+GC/Ar/GUDfG4UN/GIPiYB9Pgz1Dt4MUHE5Pj3PMJElYsmAUWdt4gWS4AfOHJu5tv7AzMMVHr5bEyTa71RJQ+DSNPcjC635eN/Nfa0FBbO8g+ugkewNaxkPjxeS2jI2koeGfAOPcgPuWRh49716plyJdocwzUt8nUvQlhE4lQtri+295dhygeiVJ9lYr1ZbfMxRXQ0ojXspLZ8oWpEnAB9Y07HNOkbiXN0TO7gM3SAVzqfBByOgUw14akAIFHHZP8EikX2tdj5Bq+ifi9A4LsS+UUTZTHMNuFs7j7zcG1ElgPCOhZGeGRkod9WZdN/aFF30/BgqG23irDwM9c8JcI8kMpA24z3Z8ZkcqTIfsPrvIr9mWW6zZioptugoX5V1XG33fJwv1VVJ0mSkAGek8xJIBg4X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 05:37:37PM +0800, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> Commit 7d74b06f240f ("memcg: use for_each_mem_cgroup") replaced the
> mem_cgroup_walk_tree() call in mem_cgroup_oom_notify() with
> for_each_mem_cgroup_tree(), but left mem_cgroup_oom_notify_cb() with the
> int return type required by the old callback interface.
> 
> The function now has a single direct caller and no failure path. Make it
> return void.
> 
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

