Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12848D68BC1
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 22:21:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75A8F6B0005; Wed, 17 Dec 2025 17:21:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71B8A6B0089; Wed, 17 Dec 2025 17:21:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62ABE6B008A; Wed, 17 Dec 2025 17:21:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 52B3A6B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 17:21:26 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1965D1A04ED
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 22:21:26 +0000 (UTC)
X-FDA: 84230385372.28.CE8611C
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf26.hostedemail.com (Postfix) with ESMTP id D8E3A140013
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 22:21:23 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=HqBtwNy7;
	spf=pass (imf26.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.45 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766010084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oGnYf/i4vTtA3NHOb9u9oip+bNsnJWL/dZIL0+rUq4U=;
	b=DeWF2Oo50JanaCudXRfAon2Z0PoWliVoPjnMxoD099hdMM1tvBIBKqOkBNWtKOcFj8XOpW
	clNg6vym6k7B4jP70CK09KBNVDiKgR+WeTouH2VofrWFCfyOI9f4PaFx0W3lppsUU6Rdek
	6qUtx3NxZ+cPLZ/PqtXEbmdbNgnRYr0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=HqBtwNy7;
	spf=pass (imf26.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.45 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766010084; a=rsa-sha256;
	cv=none;
	b=4FvghRaSEvx18mcdfOy6ij3pVbbS+9OOrcg1LJaQGhVhKW65a85ojWACm0Mn2m3RjHn3rh
	gyES6+lnI3fajRBrl8AEeK5HDpQj43wq0KA4JgeFdaRsSTWYYKyAt9C47UED3IJY8wIHF3
	KF2DUQ1neQ4+jL7fnP1LHR64cqAmzJs=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-88a346c284fso1466d6.3
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 14:21:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1766010083; x=1766614883; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oGnYf/i4vTtA3NHOb9u9oip+bNsnJWL/dZIL0+rUq4U=;
        b=HqBtwNy71DIR/rYj1pFyGCUt38o0W6nodcuUAUYLJMr6iMVgaEAfZpfarkNZRTjI2/
         FzUMOyj413EC6/+wcKjAOB9XYrkgvxB5lm3oTnuue4V/OaSAuWClYQmx94e0XJFIG1au
         001cKB9tG4HFLoPv2x6ZDx1uCdTbLblxqlbQDOujxEn1hDwih4Gppnzx+NXgdn28vbEK
         CYGMQspgFHYu4qUSkJUqMX/Bo0pniN2da5GshE/m4lT47YtknMquFu9a6EUwpvhHay8s
         EG903IXQn3/Vxwj5F3s0xf2ZIYSHfYLcuUBTYtzUKuBzbP04PRb0Gj1+kTsin3JU1Ley
         k6Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766010083; x=1766614883;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oGnYf/i4vTtA3NHOb9u9oip+bNsnJWL/dZIL0+rUq4U=;
        b=E5IjqTga/b5TZ5dN7dzCRyALUanms7L6h4az4IEeU+2FIZ+jv6hCy8w2sspxr2HYgw
         2a3dvy4wOL+27Ps9i5vYn3mdMVtfD3Uf9gv1j2tUsfLujhrBPm346kNwLlVTONEp1bPs
         +lZEywVl2Krem5mUNXOIaoJtjSUCuM2yyTB2/p+HHKj393POG1hQxPX88VkfUi/Ef8Q3
         rG8ldpDaYKOoVciOpYV9OQboTsWjXBa1Do1G73YumlIqUfajayAEk3HHBjDZkXpmpikm
         VBSom94xsPPTuSapBHPvTeWDLgBr5sKdgg2P0JFeiGjXpqs/TQ7OAHy54/P0B/u5HNeB
         N7sQ==
X-Forwarded-Encrypted: i=1; AJvYcCXeoe7JXGTMx+ndQqJF5J6niQu6GPMbjJSOx1so17ahmaaoPZbrBLQD7u6fKtv7UP2vuypxctzaWA==@kvack.org
X-Gm-Message-State: AOJu0YytXQ3TKaNsnYERmUSWM+xbbQRkMJQ7aILQdV17y5SEruhfzw7P
	2CpPPpPGPcWjB6twRKfpxG+RcVdvDQAwzK6xhO8gq2QWNy7wFgTtFSf3EIJkWXo7x78=
X-Gm-Gg: AY/fxX5zmrmCnyVaQsWbQ3ciWFJSoipmoTF8goP5sRjYAM/hemddbna5DnEkwtL1OD4
	oOxyTiI8qAXBKV8/Fg6fOlvgUdkUnD3/dailMjHLc+sVYVNFJquM/5JVdxhBxkDQlwHIcFFmvmB
	uDYauClHM8gbRcpnRZAv58ZFv/ohrJNnBWXQ5NEBQMvKvlmnTg/WW9ySvh2FxhpquRudeozcGyl
	FqMZO8A1w99BWZ1aCQXqh5UrqxmCHYCejZSdFj9cioSdvyactA+cL+WEAfIbLmuomk+DwXe0Eav
	WShTIOYLd/jsEBr1FgRH+zoGNnDwSj1SrpWIy6DoEmZT6epgJLZHhwzf4uOQJSF4fe8rlZfLzFC
	c/f6kBsVp/mTVgc8AHvpzJKL3fNN9dPgUkNFyuKBpcrI05kWgWnB3Zd9rdWL0td2IiC43h7pou0
	5cNZjhGZuoSA==
X-Google-Smtp-Source: AGHT+IHfFMUnVIsHh0LQ17ZWwdIizXxNoFEmOTGePXiUrA0zdLFlUhgj4/j9oZuKo5TXQd0Vyw3FBw==
X-Received: by 2002:a05:6214:3317:b0:88a:449e:81a6 with SMTP id 6a1803df08f44-88a449e8527mr119918776d6.47.1766010082918;
        Wed, 17 Dec 2025 14:21:22 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88c5dc716besm4640426d6.2.2025.12.17.14.21.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 14:21:22 -0800 (PST)
Date: Wed, 17 Dec 2025 17:21:21 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	chenridong@huaweicloud.com, mkoutny@suse.com,
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com, lance.yang@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 15/28] mm: memcontrol: prevent memory cgroup release
 in mem_cgroup_swap_full()
Message-ID: <aUMs4Qn-DCgFdB04@cmpxchg.org>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <4dd1fb48ef4367e0932dbe7265d876bd95880808.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4dd1fb48ef4367e0932dbe7265d876bd95880808.1765956025.git.zhengqi.arch@bytedance.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D8E3A140013
X-Stat-Signature: 31b7n9h3uhxxxh7uc1y14nyydssz4byf
X-Rspam-User: 
X-HE-Tag: 1766010083-353377
X-HE-Meta: U2FsdGVkX19PvLTmbjsIBQ+0bqQqdvbhKkPdIirTbsCnhTSCnLvo0Mfg+6y4miLg6AFchIhzpbbJooRw1AySoxBSRZiD0xFa7oNbGKXewMz3rY6zXJBp+bAkzTA/LWGlKDISvtXRUNNRfrbznGp+C7sg+yQ1X9T15UmEyu1iGXAkKwnYV3BmFotDnnmSOCduO8aw/dMa8A+drZa4VwLA4KZAS/03A2vOWQs7tTKv8pkPf7XLyDhB2yogbz8ySSIV42uDat+fIckL5/xypqdtxz6B2T61/u0HCcIsoIMPT1jie/l/U3JfQVriIu8dzXxItqzGaLPSJxZtLPusleoNR1jSEAp513Rp80obzVr8sZ6485riBO2rvqojbUpSjOQZU6rLrBIEdwBF9RpX3CMYKExwfjh07AYSXZvDNh0+Be8fK/BtA0prAqgVB/1tDj+2MsXDcSWsSOgj27eKIsDNxBoFAZBvOkgoYcJq8gy81XmzGowoD3XujNXlQ6MYGGlgVH/oCx/haQK0s9L3zrfAGBnHVF7D0tMH+40bJxg7Fcl3s72OrAK9hBSvK8pRU2dx0hY4qIroOaCvGQme6lN40a4LPHiO1WCvnvCmfM5PN8mDtONsTCfzLCADMaaZmCyY7H0sZZS/+3Gd4ITnP72N1in15sPcaDSo1dUGAoozKcOBwku6W86XwM8gY4pOBTBDX4Qb+SQ7q/nAkUnwiom56tMxzaCqdBFpT0S6nAxzRbCnqQOANEoPJ883RGu/Npe61rKWBoLiLQZPuItZmtz8BOT+jcl6SAdBaoLHfp8zQaml2CjHWIEX57yuSYQ8Hpbm0alzT8NorsSNe/o4z+L1HgfvvRh/vXDW+mV5UxtI2EQztaTPjphhUcFJLdElff12ujGansmtSxObI/05nYQN8HypAzWlzP+HnTKtByELIG9tLd+feTFcQ8J8RZFcXPDLr5LUUIs5bMHsa12V9FV
 D/eGawvj
 teSj5/VQveQj7NuKplpPVMjTm5FhVqvi7WTgKw/mRSuXaIGeqlsRVNSu8K6qSJQo/m+iQKrsCGP6/4QYBmEzyFwfA1QsvLQZQ3/rGXzmllQX2Z3eHnueBEJIyl7+VgEtTvQKivXzkN07EBW9E11M3Aoh1BS/BCey8wXIRgGfBOMtCxbQhwBv1XpXh8IU8g6oJKkOb1c6ghGJki5OBs4wXgMbXvdb04B/GRM8ZAArXxOF9BOUL1iaurn39J9Kmrxd3XlxYAweMUchCyO5c9I9r+QmJBIut7UrzCuwGL+cizMNWFGjpH4AaMxYJRjOuLx8Bm61OyxePVqtLzRdfg7l54hnTsfJpORBoTgSu59Au6IsK4V21K6y88plguQ3ZdPyD90U2MnUBn/bZFuYPLgLfxXq82vf/pJyO16TIOpAvluNsnXl8I5QOX1K42ys70Ep+0vrO4o9K2DBX3yl1yMArYqpjWo7+rd2P1dZjOtolaA/uD8jS6h8FawCdb0FfYQ0fqzLO3XdFqcf6dDi61I+kUHlC/vpsUJdquDrPtrLHKobWuVA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 03:27:39PM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> In the near future, a folio will no longer pin its corresponding
> memory cgroup. To ensure safety, it will only be appropriate to
> hold the rcu read lock or acquire a reference to the memory cgroup
> returned by folio_memcg(), thereby preventing it from being released.
> 
> In the current patch, the rcu read lock is employed to safeguard
> against the release of the memory cgroup in mem_cgroup_swap_full().
> 
> This serves as a preparatory measure for the reparenting of the
> LRU pages.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

