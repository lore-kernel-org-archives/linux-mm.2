Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97864C88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 16:54:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E3D46B0088; Mon, 14 Sep 2026 12:54:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 894256B008C; Mon, 14 Sep 2026 12:54:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 765EF6B0095; Mon, 14 Sep 2026 12:54:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 46D8A6B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:54:20 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BE0181401D5
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 16:54:19 +0000 (UTC)
X-FDA: 85212965838.25.42D9FCE
Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0964980006
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 16:54:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=nhPYUUFO;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.205 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=nhPYUUFO;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.205 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789404858;
	b=aC3bcKl+xWuMbUu2vHPRyLoMLRKvET+qwCz3VbNlEMrReB/zlhOuLp0X2wvJQ3Pe29w0lr
	hMzdk4w7F9ynwgsFsZurffraIF8A90ZtMdwfezaVdHosCkypIhB3kzF8bpkbnVJJ89nGUz
	IRBNvq8Qb9VKD566F3nSFT54VUYsJUs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789404858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bhb2DGDZ1N4QDHqrTPKWFsV9rSY6+F9JQNAhuggDmIE=;
	b=RMX/JajRE4XhkBebHdtr6SQgXjimBmxq8raiJhUmEzvWCUqhkZ4MWEvGhzUI1UG8fRw9RC
	EvhT4/K3/gikXShWFFxAn3cvnkzeWLBRW3Ay33nSSaVCleTg/uG589rQi1rA0iFZKmb8cp
	KACE2CHKLqaBf23pgAtXUPj4HGyIUcs=
Received: by mail-qk2-f13.google.com with SMTP id d75a77b69052e-52fb7692a57so25450211cf.1
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789404857; x=1790009657; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bhb2DGDZ1N4QDHqrTPKWFsV9rSY6+F9JQNAhuggDmIE=;
        b=nhPYUUFOAsta1Q+9/kOe9SSNJEx2ij6YFhW4zTfF7bpJqE43ku2zLsb4JH7yd4F/MX
         XTmFBLiLRpQYKkqB5pULJRPKW2Ts1s2OI5+c4gHrPX8sw1MT9umsEQdBwAWhSPXr3pix
         TZl5YrJzV7ux1tmpsAkYkmW3NNkB2TdxgNdk8VUzoY4KQY8JOUwwSCI+c6nDf8qsfuoF
         Wcf/cPJjGGDDrrrwcKartOlnHOYLWpDCcwjrvBs8H6gG4KjIdDh4Gmn9l3K/jHNxdezo
         Y8rtuOs2rgcghpUbVdqOAZ2ZDzK+JqHTk6o/yKnTibafHHrEBgx4Mx+cMMF+iH07+3P8
         G0sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789404857; x=1790009657;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bhb2DGDZ1N4QDHqrTPKWFsV9rSY6+F9JQNAhuggDmIE=;
        b=J0Jgei+fafNAr1IvoSXqcWfz5zYsq+8FXFRAjRrZJkx0fvGWIU+VNbHM2jS0czMkgy
         hntRhq4gdmWVtwlq9RY2Mar7bdcv9b45cvFxkG/yefQImbuKDLJ65U44KiWqwfi+9/Z0
         7dbOjNpUQlYEUoM+K7szFiB3qUepd14nJ9ZgXnVlb3/i8lCwFUfrqYu+yEfKf3XB7Q9z
         ofUHF/Hl0OPowRxaf+h8xLpGhMzp/VNUeJ5eehf9m6pGWelKp3Ag4JWELxDkO5IO9Xk8
         amrEfzNyxmGekvY+it88IBA91vSIDKV0WeqDEjmh1uT8z8hLtnBVj+hMPjjK10ayQPFc
         Qb7Q==
X-Gm-Message-State: AFuF++mttNiKsYraa2CFijk/iqbFVGr5eJ144ocJWO0r/mc07m6KiPCf
	G/ZS4xv9k8od7qOhhPAmMvXUXaFoTxgAtFimj/8xcCbghD1+FbvWFLi6/zGFA8wsaE7CyNI8I9r
	R0AsQ
X-Gm-Gg: AYBFou1QhAJLgWpZnB2PlQvMXTuLBZ4tycaVbzKV8F2Vtb555wZZ6FxNSXCkKITzg6j
	SNR0kNL/5O9O4xoXi8u+9OrG0ErZCFDvTV/Hlhai3RBqBPSrYVFxQyQPL+neoY5WJLxbBUfr95W
	RDW/BSztutj9uTC6ijmEaXOJqLbfyIwd4LTagzj0mOXu3cpn83iAIazu+U/NmpOkSw+50DUn2Xk
	yfPcNCRka6iSGgC6yU7KntmpvMZ0qi4ZppvWACeoKL7YCo3pCpN2HKXRjsm2ggfhSk15nVPFoKU
	o5l1ATTPTk039imDf51rKMN3fsSXxFJwEeYqscKLHW546MioT67x3k4ox7/DfLjHikgEwaYwFyb
	HAOGfyJ82TYIN2087Saq66G/GpzGCf2EmVtfa9xkttt/RuLaXSJwpvYF+SoXqNXG7BtPB9dg1vM
	VJNlwvmV500znWoQPPOfOaL+8Vi7mw1nTZswCJB0Fl2zWGy6EtO7N2YFyCqSkPbRSK23g08Mj63
	Ag0SPbVPmogRmUYC8Z00GIx/zR9Myr0zc0VS1okSEVhJyvY5Mjk2qw=
X-Received: by 2002:a05:622a:111:b0:52d:844c:b0c2 with SMTP id d75a77b69052e-5310cf0aec3mr49651841cf.12.1789404857027;
        Mon, 14 Sep 2026 09:54:17 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-530ca4899dasm102065431cf.12.2026.09.14.09.54.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 09:54:16 -0700 (PDT)
Date: Mon, 14 Sep 2026 12:54:14 -0400
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org, brendan.jackman@linux.dev
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com, mhocko@suse.com, 
	hannes@cmpxchg.org, ziy@nvidia.com, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, rppt@kernel.org, baolin.wang@linux.alibaba.com, 
	nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, usama.arif@linux.dev, kas@kernel.org, matthew.brost@intel.com, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com
Subject: Re: [PATCH] mm/page_alloc: let the bulk and folio allocators carry
 alloc_flags
Message-ID: <aqgjUJWVUS_nx20i@gourry-fedora-PF4VCD3F>
References: <20260914155115.439742-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914155115.439742-1-gourry@gourry.net>
X-Rspam-User: 
X-Rspamd-Queue-Id: 0964980006
X-Stat-Signature: jnod3hxait8f4ej5fy9j1aybbegrtyty
X-Rspamd-Server: rspam01
X-HE-Tag: 1789404857-781373
X-HE-Meta: U2FsdGVkX1811I8ToqhEdrBkLsbaWyemlyJ2y0kRAPc4z4vyQE27W/yiTA8oJ9XY/GIt3tzhjsWoi9lAfwUpuPm2K/dwIaW0OhVoJd5Ge1gVxmt1FNojZ2IOqVP0zg0Na2DLUVMZ0n3nUWVuP6dtuAOpiviORAKd1v9Bb2Z8OlKRPF5fp+PyBU+/iydcE8x5OT1Ac2b+g1C7EsVuYZiWe4UOaVw0WBeu+WTaVRGVGmOBZVWUuFu4GpwjN6NZttDcwnrcNMBuUtaRF7FPc07JMLk9B6WTOGd2/HabVcUikRlHGs20FP6MnvdMsk7wpIQiyWWFV5ZImkatQuMwIUVQse5pCYG/D+K9Y46HT1bxUsSIlYbko/p4VT3ItTkoVWTjxYHvBvb+Z2gSCKQbVVZb20Gg02D5I0LD5wg7tfhEkvPFNYHhupHFK/PxCXzKjC3mkk+AZsvKSMmpXHmpMkcymUIYQh8huI22PezfaOfs2Hi5KSu42zyFrAfeFHK3nBM/LscHiQEJNadcd9gt35JWooClHAr+QeRhpNZw8fw7qp9yWt8tflDNOcc5SYtI1BPBpSc7HDKos1y5+tFztBRrah9hNsay4DyShagHN1m5njoPGU6QZjmbzIGB+btjzCzbV/tnbY/bMGm2ImPvDTVj2eTeBIbKLP6KY6KKwQT8FBe9XL8UN2WFrh7r7USqd56htZiN9+NgjhhWJndXbQUc2UXd74gJnv9vcZulFYB75naWat5YlhPH62XpYqU9uXDJLgSjva6xkAzoFP/AT+R4N/N7SLPl3S3TgLAOREetBTfKlbp2ChXOAl8yygDH0LZ7WvKoOVai8rxHCZjSDdKIpssjmyZmfJ1OKSTOpHqnai/+YdcCX62eecgTksDA3+P0GtiKsXuwx8OxPTe2yTY/B2/DYaV/eYaph+RD7zngBguGMPB2xKTaZ+GhrM/Ci1kL/GIkuxeBLADejR/Y+dO
 PAjpgJsd
 w7frehEItH9RJWZga4jtA8nx70EOWyE1YQV2nwu/UgQe4o++0RgF+ImQizHo2DMvZFPszKtTSctI2SY/1uL59n//coIiJFb+JW4NDUbHXGDIsFXExTRYwzCSanpwwENdU1GVt3OnMXn3U4Aalzaz/PBsN4PWHmOM+pean4e8Hzb7q5n3KXzfTmqIrfd4RH1eB9uKLM5uxhG0BiFcA5jj1RI02Xxuz093o5DLgW8gW++TM9X4ITA3dYkzD/n22HUzXfgBY8qSmvWar2oD6TJfO3uKvOWP3fJq9L+fg1FCdtbY7eVJ1t4LhOUSe67sGFpdhuUTiPbclFSPJg7hQYRIZ/BsxPZ1D44Ly5jMDS0jhk2eKhavu2du4yXaegcX+RN+/T8PJ7qfYQA7gy6x1GifDv2mUe+HftUP6S+muIju6vtyTuRrfkqsEJrj8f12gkOq6og/ZYtIFsd6Ti4TOlv3bz4yfXCbieWd+WgKIUL54qeChy+rRasm8LKyGcDaPkvYTXRHFw+GYyR09glwxN9D7/bIGKb4ttRDCi4828oKBX5F4Xy4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 11:51:14AM -0400, Gregory Price wrote:
> __alloc_pages_noprof() takes an explicit alloc_flags, but the bulk and
> folio entry points do not, so callers cannot select allocator behaviour
> (e.g. an alternate zonelist) through them.
> 
> Thread alloc_flags through both, matching __alloc_pages_noprof(), and
> keep the flag-carrying primitives mm-internal (page_alloc.h) so the
> public gfp.h wrappers stay flag-free:
> 
>  - add __alloc_pages_bulk_noprof(gfp, ..., alloc_flags) in page_alloc.h
>    alloc_pages_bulk_noprof() becomes a wrapper passing ALLOC_DEFAULT
> 
>  - give __folio_alloc_noprof() an alloc_flags parameter and moves
>    __folio_alloc_node_noprof() moves into page_alloc.h
>    __folio_alloc_noprof() is no longer exported
> 
> No functional change: every caller passes ALLOC_DEFAULT.
> 
> Cc: Brendan Jackman <brendan.jackman@linux.dev>
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---
> 
> Brendan this will conflict mildly with your ALLOC_UNMAPPED work,
> because you add an init_alloc_flags call in alloc_pages_bulk_noprof :
> https://lore.kernel.org/linux-mm/20260726-page_alloc-unmapped-v3-20-6f5729aa9832@google.com/
> 
> I wanted to pull this out ahead to try to deal with the conflict.
> 

Sashiko pointed out some issues that arise from rebasing on the recent
ALLOC_NOLOCK work, and in a quick review I found a similar slow-path
fallback issue with the NOBLOCK patch separate of this patch.

Brendan, if you're alright with it, can I pull the NOBLOCK patch out
ahead into a 2-commit series and I'll add the small fixups?

~Gregory

