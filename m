Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB1F8C9830C
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 13:06:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0FC36B009B; Wed, 23 Sep 2026 09:06:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC0BE6B009D; Wed, 23 Sep 2026 09:06:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD6486B009E; Wed, 23 Sep 2026 09:06:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AE74B6B009B
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:06:17 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 26D6180410
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:06:17 +0000 (UTC)
X-FDA: 85245050394.03.C16D57A
Received: from mail-dl2-f43.google.com (mail-dl2-f43.google.com [74.125.229.171])
	by imf15.hostedemail.com (Postfix) with ESMTP id 467D4A0004
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:06:15 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=Fw5Td87p;
	spf=pass (imf15.hostedemail.com: domain of jgg@ziepe.ca designates 74.125.229.171 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790168775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ih23spaVgrDHOFSey9aqnpQ7LFap1dWio/xJjG+h0zE=;
	b=0XEaQAhBPVI2cA6U7uc1BO5/lrQuU0g94HGGqfW8vxa4rXnCStS+YAVRUvT7vzMtX/VzN1
	mUeB8dbK4SvL7LvD4l5UKr16qyt3r21PingrtLIXZ7wo7q4Osbq7epMtIwBeRoCuBL2y5d
	1buUi3vMJhbduAsch5xgagxBFLY6JhE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790168775;
	b=rR2Odilgrs1Ck7JkoPHeohUUAGvFyWueoV/ahQ+NDZSrZ1shoL/D8i0yYZInshXdJJ3H0h
	/G6iJAqO0jXWUgDzuibzm1orR7n1viykZQN1aq6XSKZMdFcn74P75Cwf4TPyuvpClZDxPe
	U/yLHQHejCPmx1C2p0QvVOaAkTz6Dyk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=Fw5Td87p;
	spf=pass (imf15.hostedemail.com: domain of jgg@ziepe.ca designates 74.125.229.171 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
Received: by mail-dl2-f43.google.com with SMTP id a92af1059eb24-142dce6e235so660270c88.1
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:06:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1790168774; x=1790773574; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ih23spaVgrDHOFSey9aqnpQ7LFap1dWio/xJjG+h0zE=;
        b=Fw5Td87ptxI6/v7J1iKLANimJus8k0jgUldz5cFfBC5+JxQ3Giu1aMZfkPVc/1gN/R
         kbChTP01w3nRgX3bof0kb64Vib3fJ/WZGzsTOf9GuI6nek9D6GbKNPiwRbkgHkD4Buin
         XTIHDDMlRZ1tc9nysWXXEZVpzCsK9g7NtO0Rvldt6llkSwFi2KQhOaoWyLKM8BZPdSpD
         8MMqa2vJqkzlggiOXmzIZvN+Lno7DIF0jdjMHeD+Vp77mLNlfkxbgykJ+EZH7c/BKHrb
         lGahpsJnol8Cj1yudRRO69EZmr9pcL2RTpdsIDDg97IHYvc9l5dAo1kkBi0qhT/zcEES
         YQ5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790168774; x=1790773574;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ih23spaVgrDHOFSey9aqnpQ7LFap1dWio/xJjG+h0zE=;
        b=Dve6wm5gqImwQ9YIFvmSwFAXLY2eb2vDeGhaJT0OZxV6+W5bR7ssPeskH3uRvOmwhA
         xtA81dGTnhX4Y4yPSzNZndwVb24DbjN43RUD8j81YglfS0myWHHCty0rneTKAm0xaKMi
         c+lbtCSCdMXRAcfk7PZ+II3oiUNh38UumO7eZVPE3Vx8zcralzTID0DaYdUgJwPq4/61
         dIOymx2qcI7l0F73oQJu+rf6FnTZIfkAWvrITPOjC1psWf1AuRKe2fu5rWpbFw+hqrpM
         +Q3+zayqV4UnAVxRqKN13XEA9S652hWP4R/xARTSrWAg7btawzo2xVBaAGzrQ7/tRNqy
         hiAQ==
X-Forwarded-Encrypted: i=1; AKwUvBwH3ZrMqDRn3Y7WEx7WuJsC6tf0MmExkUdGfiuutMzrEUt5zQpCACjK/DrV3ko5r8AEhWRl7nn6jA==@kvack.org
X-Gm-Message-State: AFuF++k2jiPs8f8xuczUfLMjaXCCYxaVBTUIme3agVHEaJraoRsajDwa
	jDnUzt/k2kfoJOjSWLHrfI44sd07kgGBPY/SKXsBD8bHA3UGLagz0hkWowkmH9qznSM=
X-Gm-Gg: AYBFou0ZxqZMq6+g9VehpD8UHJYNdvGdz4pMX4eTKeenBu6PBc0pNhR9x0KcWLBT7bx
	tJ9NQKoO20utdll35txuH1HG2RCWzHQfK8geJ/ghLF7MLHFG+IjMK4mLWBlQeeouDe7SqY7U1iY
	8i7CPmUGavQzz6Vdg+7VL+BtxPtiFEvp+uCUqPWQEAX+7ct3BLgtAEKVXbH0KvWeZ5EoQP6caCO
	+CO7s0UvJsfofOHIhEf8cJkZ55fOx4T+nUXX+u5+jgtymvjFGAsLEgDwfN+Vj56PutSyC3IQjhM
	9sMyD1PnK6sVFLfS0JqdTWlUiBE6cy5vrC8mlgN3LHCoKGyhaBMLwEkId3sdukPP+1ZOiBpmJUX
	OW7czoz6hCT8D6oodrRkZv6iCvqAyPD195LPTTy6mtq6JUrckYW7mkBYBAJFfET7Kdlak9qwMJn
	DEcxKarlk6qlrY0y+MO39fYhOm+lQ3/KFu1+xSOMYc5Koo
X-Received: by 2002:a05:7022:1402:b0:143:2719:566c with SMTP id a92af1059eb24-144f9198b49mr2872815c88.40.1790168773123;
        Wed, 23 Sep 2026 06:06:13 -0700 (PDT)
Received: from ziepe.ca ([130.41.10.202])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-144f98a288esm10833873c88.13.2026.09.23.06.06.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 06:06:12 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1x9Mfr-0000000DZ6d-2NEP;
	Wed, 23 Sep 2026 10:06:11 -0300
Date: Wed, 23 Sep 2026 10:06:11 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
	christian.koenig@amd.com, Joerg Roedel <joro@8bytes.org>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>, Will Deacon <will@kernel.org>,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v7 02/13] mm: Add an allocator for CoCo shared memory
Message-ID: <20260923130611.GF1540250@ziepe.ca>
References: <20260921144847.501151-1-aneesh.kumar@kernel.org>
 <20260921144847.501151-3-aneesh.kumar@kernel.org>
 <arKsFofudnTYpXj1@arm.com>
 <yq5aik3w344o.fsf@kernel.org>
 <arOfD6syXOgQhZYA@arm.com>
 <yq5a5wzw2ree.fsf@kernel.org>
 <arOspFxWZ1DjgcAr@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arOspFxWZ1DjgcAr@arm.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 467D4A0004
X-Stat-Signature: mnsnbm9431wz9p8awk7yedjy4wrhxj9o
X-Rspam-User: 
X-HE-Tag: 1790168775-426937
X-HE-Meta: U2FsdGVkX19rjc3VZdnr1pH2+P1oslrk6AmpKP/OK+4vwGaf+abJ4/EokoFg96dIl7j0HsinfGMALK5OIBB1u5aixwJGEJ2tvi1H/RY2H18BLerZXwzhbeDqsSZiHrUxg/7HT8JgeSxUG1oGwPqmaC4jxJTAqbsPYAYnGZdgxtPr3E3QbwLjgEJUYwq7UOcGwqjUIlfJbtQKhcHKyR6+Fa1agdRJFI+VCcAJRSneT9hSHWU/cLwXqY8yHiApnR7lfF/ieSN//zp0m9AINHlSp0fJ6xOuSKGmZQn61enzY4+y9eVZNzHQwR8duTn1S/0LueHoeB8Yndk0ONGzOS7L2nN4j/b4au/oOH5oeVV2jlAi/OGuW8nW77qHLu4yYZRv+BJk0VkapztoytraqHRNuJxXptS99tJhkLjOYeNTuTV23CCJwtfcT5ZF5k8q5p2sEtYuhWtL+Ltorz520CZH1u/v2YtFrcEPBQi57bVUhFw6LNfm3+1DcXzkxYxgj3RAknViP380EUoJidzIBi5z1/JVxR5JxWB5JwdlDgO7il89AnwXbFNEDNdk4xpUG26EwxcsMzYDvenZPUzp8NSCd1qBP1QGE7kJOa2cmdtTkOS52yVC6Rl/AWBImCZWv1C39obdl24FXJs9E+BtvkXnpEeHvWdqvuIOy5nrqVejgjQF1dcOJdjV0/SDqBWSjzNETtjKwXaVH/NV4X+bJbriJ6FPCuUTrtaXFzOCNYUQ+BeqNy9oigm1v4t/q1jsPWnN6x3sFNZ/hMbamdQRDdsV+qfeIw28jFmkhKZGZeW9A1GXgYFG2mUcC3mB8RoehGdP/HScR1m7aqC+blfBmUVY36RnXptNelsof5KlWMznt1eY4XbE8hf7JEUZ3IzVInazx3Vx2qSTULcohStl7YAWbH0B/ydSJOOh3++SYsCI4HoAsTFXMM7r1b9iohRklfOfylDVctQfkZsA9Jw10iH
 zDuxNoGp
 DXgzikFFGVlcFKpeJewxZ1rjixBl9mT3ScMwzP6N3ohQahvelEDQJ9UC75qgpNKCGIlO5jhvPFMdL7WO0ZBKziJqZg2eQ0YWbxPhB1TS7Hi8rOUYy9iwsolRhFsOhQuVnH16sohqbWZvf36jQRCOxhnLTierEPh0YNh7sCR8EV0CxM0T+VaVrUkmVDXhL1UBclnSLpBqAwosuCeTKjn4X0QK0yJrm8QYe4SK+t9ITp1Ia8zrUJsrNYVCrF7ui/ylcugVS5C8I8TDk4TI5PJKui7HEm/0dDZSKs/Eu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 11:40:36AM +0100, Catalin Marinas wrote:

> The simplest is probably to always zero in the backend and ignore
> __GFP_ZERO to the allocator. But it's probably only marginally smaller
> than passing a CC_SHARED_ZERO flag down. Get codex to try this as well
> and compare the diffstat.

For patch ordering I would convert to use the allocator first

The semantics of the new API should be clear

If you pass GFP_ZERO then the resulting allocated memory is zero

Otherwise the allocator does Whatever The Arch Needs to not leak
private data out.

Once places are converted to the allocator lets go see what is left
and ask why it is left and what API it actually needs.

I think HCH was right that nobody should be calling this in driver
code, lets aim to unexport set_memory_decrypted as an ideal goal

Jason

