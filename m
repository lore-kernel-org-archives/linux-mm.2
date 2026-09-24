Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE188C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 14:07:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADDF36B0092; Thu, 24 Sep 2026 10:07:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A68946B0093; Thu, 24 Sep 2026 10:07:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92F006B0095; Thu, 24 Sep 2026 10:07:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6B1D26B0092
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:07:11 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D06894035B
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 14:07:10 +0000 (UTC)
X-FDA: 85248832620.08.E433450
Received: from mail-qk2-f43.google.com (mail-qk2-f43.google.com [74.125.230.235])
	by imf21.hostedemail.com (Postfix) with ESMTP id F17281C0003
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 14:07:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=anTC2sxb;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.235 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790258829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ztBx4OPk6JOhZIQ7ImRBBL50CNHJh8elF9MxANZMVE=;
	b=yuP90EAzsCRvVwZNVLqqFUC7nqJBlhHkNI+KvXbOzZwED6eJdlTfheJB+lSRMY0CKEL9Q6
	l/sYLBvIgYy4DzByGVR2blnKaDn88RHP7pQaU1f/RcrvyVSl4FHD/WbhzgOo5iqu4CMlMj
	cRZphTl6xNdxTNnDsaiBOQ5k46bxJmw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790258829;
	b=5WHrfAffTAEMei31D6eODZoNqjA1fwnDEaUaQhHbgQjMnCa3sarRwVfumWMvxY96C566cy
	TXCcfKT1rTSeH2rx+YdbUoOSui+VpECib8lsx2HHNGKdNlm6L43od15+7gtpEiQiTolrgb
	+ZkUWWf2bHl/PBXWk0q77GSGvS9AqTA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=anTC2sxb;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.235 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk2-f43.google.com with SMTP id d75a77b69052e-530d0d5ae11so20496611cf.0
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:07:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790258828; x=1790863628; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/ztBx4OPk6JOhZIQ7ImRBBL50CNHJh8elF9MxANZMVE=;
        b=anTC2sxbKsAw40QiuxHMLbj7rK//A4v4Rbuubgw4rmm76KdY7SElZYecMs0sLN92QT
         xG9vSZJIXTsp2/86+CMb08B2yhJVftyELyhkdR1QxqixpseGHFOlZheGYko8dp6+zA8j
         JJWp2tnm4ISKDjnygXccOhvhmAAaToUVdA7GsS0mLxT55W4M3xZTZGCEkBxI6o5G6YAV
         tRVRcr3FHuJGhI/ItTt8g/7XjTFmQ4SbCPGKvSUSxr64JeKV7rW6iD44hoFa0JkikGFn
         WF3BxD7FDWgfoM9i6fau6YZnbEfLkHI2pIJG7KH6ICOy0ya2q0RpBhyW5TsZ3OddHjPM
         7O6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790258828; x=1790863628;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/ztBx4OPk6JOhZIQ7ImRBBL50CNHJh8elF9MxANZMVE=;
        b=cKp4FBHC5FoPPUjlIqdz38qKbQr/hTU3Hs2PQGZmyMO+fH1B5nkUOPY26YB9sPcNvA
         +Lzw44ff8l01aunjeKlsw6hGd/khAh6sPN/9tUIrkniKWBOKxNARkp80oDWJUMkybWRV
         IFjam9OAHFizYrUlTHFi72u2rvBD3EJlXvAMMPL//IEEfcNS5ymS6/HBlbMzYouco6Up
         uP4E5oYJ1a4ioliwVrfU6vBnYlaguuI1kk/0HgDVUFl45pSr0gvtJI5mEPMywIwwp3hG
         9NJ9W3ma1aAunvCklXoeSiYYN5PmJrTWp16gARSNXcGcFxz5UlhDRegnVxfrDCrT+Z19
         L+HQ==
X-Gm-Message-State: AFuF++kcSM4xvQbwFNto6PuKe8SuUC89YZXzcObDWxdJiEe58xMnlPJV
	MgOQJN/PpnX1yYaaqUbBHI1rlMq3a1oLSyZAeUmN+w+rTRZh19MNgrFyZf6Rt6Xte5g=
X-Gm-Gg: AYBFou23lXrNkQb7Vlie4umbl24qzKncmXZSK/+/5VbwJ3Hrpx7x0azg5h22Ml2S37+
	sjgQtcAHzZVIHpSpjV1YzxW1Qz6VkBg4/fup0NYs43aF+Aq5UPQU5tqQkX1htwMYSpPEeNKYLIr
	WSIpDHv0e6Fkwp566OgTVDmIklU5nEBn1KqUQsyoe2XfzgFK26Q6YutUbmVm6MVV0IyhgkV7RUl
	bxc3SkHFD5jF9tshF72MLJIqMBIDkYGHXQmJ9HAp/ANd/Yhsi4elpuwQpDR2G4YMUm5dPdl8r8R
	Bvq+dE0mSU8m0SiiLPHyjnKXXhAPRtvfH6q/2r1HeGMZnkdD4gSG3qp7TKAkp27F4z0yCmNbgW0
	v60Ilr6REwxYdWAsD0GvByTx6e2jF5wOXfT4Px/g+xGZ1ymXS4b6adMZrQcBO0He4LU/ACEMZDo
	lKdIsvX2mfTP1wr7a+VOtuitaEmSn2L/6c24RW/0ab8j3vZuYL1r6CzZqFHUraondKRinIyBO7n
	zE4kREZvtRTBk+ObhvCs1gFmX8oHyA19roJcMLKWlFx63c4ISo2cI0=
X-Received: by 2002:a05:622a:1f8f:b0:532:bda6:a48b with SMTP id d75a77b69052e-532fea0a65cmr25291591cf.12.1790258828027;
        Thu, 24 Sep 2026 07:07:08 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532eaec185esm43147051cf.3.2026.09.24.07.07.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 07:07:07 -0700 (PDT)
Date: Thu, 24 Sep 2026 10:07:05 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, mingo@redhat.com, 
	peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, 
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, 
	vschneid@redhat.com, kprateek.nayak@amd.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev, kas@kernel.org, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, jannh@google.com, pfalcato@suse.de, 
	hannes@cmpxchg.org, shy828301@gmail.com, raghavendra.kt@amd.com, 
	stable@vger.kernel.org
Subject: Re: [PATCH v3 2/7] mm: allow shared folios to be promoted to a fast
 tier
Message-ID: <arUtcPIw_FaUSPv4@gourry-fedora-PF4VCD3F>
References: <20260922182928.2199090-1-gourry@gourry.net>
 <20260922182928.2199090-3-gourry@gourry.net>
 <f0cd5c54-deca-42e7-bc85-1838dfa917f3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0cd5c54-deca-42e7-bc85-1838dfa917f3@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F17281C0003
X-Stat-Signature: 3fn5gg4uyf4kgf6qzrw3foz9rw3obcqx
X-Rspam-User: 
X-HE-Tag: 1790258828-885224
X-HE-Meta: U2FsdGVkX18vzLzqg++NSpHF45D/5bjB+FJwd7VGrtdT6ord4H/bFxBgHOnlx1OsaETx6g9eJiv029u4vHJAt1PrS3lygR4ZKZnMBXIiWQ50Ld+3/vjKDyl2L1A3knMst6PGTd56V/UzlMuWuMeyeDCSmoiWw53747CfRAa0u50Pzx4myoyw9QI/xP57V1gA83TzhTvT2DQTixVptjjB14nqK5SAt9GE6HfImobLUvaweeRYEdqrm115Ah4R/ZtfYJHmYHGhztJE0sV3BED+YX80Eb8VJCnBAAZt8KYWGYv8eZreUuMMdKHiT7V4K0aJAw5MoyjOPHYEPOOvaNaOWdJgzdDlLWQalU0RcjoltnQs/bXrqnAouu6DbOuKSatWOPQImknvGSYT7yfme0gGLnasMTr0ez0bZ3q450xP9i+EsqMCS4tq7JEcMWIJhHYXMWbmuxyukrAodcPTDQpnrsfGmDOl3+/JMKs8o8lolJKVgHorkoP04y9XAabx5CWDEpeGi6L0rGfRcCQk1KPb7oMONRrHSpGM6m/oRcVtMmqDdeY9QECjikla0+/CAsuTaC43TpKn85H3uwf8M2lJe5FA+7FNHRgPsagAm75n9smkAuyrGtizExQmCKI2v2jWnnYMX2FhRLmNZsY+vkoLuKsjmQg4k1/pDwpVxXF1lg32bGd9BvZN8K7yRjmCYCAiXWm97zOi1TM0soMC45CJcgpjkfLBA0CA5zSWNrUO5E1Y1ZgojzSP21neRVBME1pYBwg8sd68bXgrhxLpCjxQQFl+eAzdDqVwqvQlv7BF25kmt2UtI+hcnYLxkKuxkcCXeZ8xWoWSwNZ3qguNeS9aZCLZvXrDUEYr/I3vwtxvUf+e1yRYBPCkAtHjIe7IFcsZqwL1Yv6antMxCITxIwOkEXUiT9asIKrXjK8+AIwso/d4hcFQWc44IJIwh3p+rpBdnaok1Vp+A/J9h+bk71O
 lQK5Y8Kw
 XjHWHj2J0uPkqNs2yYCM4/pFctr3xvIWarxmdX1PPqAcecCbcvbkE/tTiADizUIzf5HwrdI2nau9r7Y26LhO8whkBLHppoaWQZxd7UT0HEvBWXvjm5AlQHfYPbo4qFRdnJF7r8URoJIZW130wJD202QIviSv2GCAsup7BLB2bmRIADmIoPwlRqanHT8jC70PblW4Q9wTRKt8oN9AzlFnMeZis3LmaD7RMRS3W617A08v8BLtdnvIdUPUY3HCqmoeIyIMyNEVqEfW48OGjPYcz/c/RAmEuuV6XZYyjH0VxcAgh+1YmNbLDzIzZ6fC6BUnaTadumz3kCAQTO5P+YeiKOErF9/hN99CH/50e0ECKVNs1cd+wdeIDMy70g5JsqWwl8/rR0RkO7D/9Ws3nmCPjspLH8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 01:59:15PM +0200, David Hildenbrand (Arm) wrote:
> I wonder if a better name would just make the comment above (about memory
> tiering) implicit and make more sense of the sysctl_numa_balancing_mode &
> NUMA_BALANCING_MEMORY_TIERING) check.
> 
> 	folio_promotable()
> 
> 	folio_is_promotable()
> 
> 	folio_numa_promotable()
>
> etc.
> 
> because that seems to be what we really test with both things combined.
>

maybe:  folio_numab_promotable() ?

> > -		if ((vma->vm_flags & VM_EXEC) && folio_maybe_mapped_shared(folio))
> > +		if ((vma->vm_flags & VM_EXEC) &&
> > +		    folio_maybe_mapped_shared(folio) &&
> > +		    (!folio_in_lowtier(folio) || !node_is_toptier(node)))
> >  			return -EACCES;
> >  
> >  		/*
> 
> Sashiko has some comment about anonymous shared COW folios. I think it has a
> point, but didn't look too closely.
>

its tl;dr:

`skipping this check means those folios could end up freely migrating east-west
 between slow tiers`

Which cannot happen (we only migrate to top tier, numab will never
migrate *to* a slow tier).

basically false-positive

~Gregory

