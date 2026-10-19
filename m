Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61BF6606A319
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 20:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=UsgKSbTW
Received: by kanga.kvack.org (Postfix)
	id 68AA46B036E; Mon, 19 Oct 2026 16:16:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 661256B0370; Mon, 19 Oct 2026 16:16:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 577966B0371; Mon, 19 Oct 2026 16:16:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 37BBB6B036E
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 16:16:43 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B49A0120833
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 20:16:42 +0000 (UTC)
X-FDA: 85340483844.27.52A20FB
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf06.hostedemail.com (Postfix) with ESMTP id E7A8418000C
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 20:16:40 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=UsgKSbTW;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792441001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S9eGMwv9EqBbEEX2MNNoILxQ3TMBAugbnnLoMrdF+dw=;
	b=3LsYsN9X4GfNtggxoZkgFpSH0GpVeMHzdTpsV1zPWW8kTjGFXlCdT+Z84Dj91hD4VmCJq4
	Y+vgVm8EcKBTXDl5ntemSxPh56yzlAafizOp1riL4Mpf9yABPKRQ6dIRAl3+RZznRLqngs
	2VLAZgXfcyAnfOBWh7hIq32jhbBa3SM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=UsgKSbTW;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792441001;
	b=VtmhYEq1/vJgguGAnAMe6Pe9iukHx4XT0DAily2sV/TyfJEU2SWIzot2iX+Myma8wsVKOe
	ooHVhsDWYa6L//TGw/Eux03LfiM4Q9zhcmsjVbw9IJjiyObjm0yJX6qEUvgZWqpEKVLszZ
	OmBqdoAY7ih1P/DVnngxQ3xvDyFmGLc=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-93f20c3aaa5so242644185a.2
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792441000; x=1793045800; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=S9eGMwv9EqBbEEX2MNNoILxQ3TMBAugbnnLoMrdF+dw=;
        b=UsgKSbTWSDb0rrB4vrr3IPqV5xwkXSvh3s2WJTD83R5Bo52JQW2TcCyCa8mu3rr1ix
         CNp2s+e8yW5dkpOoQVW+NCYF+4wewXN7F6Vapz6FApKZIvrs3jYJ8a23Akx0aQmlI0rf
         Z3wxbiddhekpGD7lQ40Ux905/Jhz0zTskDHGEcZiVMK1Z+IRqVAnl2YKTGf5DJ/uNvm8
         YatiefDAJzTukmYGN4pETDaCMCgQg/j/Nw9JMh5uVuznzs385JRXEb8PssMXpFqNLnWq
         rZLGFrQDl5C1Okf36leGt6NNT/Jgwl893xx+NUalc3N9SLLOehuec8dyT6Cu1UUMXe4z
         gKJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792441000; x=1793045800;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=S9eGMwv9EqBbEEX2MNNoILxQ3TMBAugbnnLoMrdF+dw=;
        b=GMlb+34YJOQLccjzu0gQ487BqmzHW05Or7oOCeUp1RjsNE/Gr9U5VBqy03gJtQnXVC
         FpahViJyiff3hFwhDd6XXbhAfJ0cmNb0M4aQG+/+ZzT/EDKHJzU8IblkUZgiUiuIwukj
         krYnBlXjKz38S5iMuOcPgttdhv/jS92+kZg9LpZYFm4RJZnDVBUVFZwp0fBhn7TJnpQA
         ioh7EbXXT9pz1P+Y3/LOhpVIJZDsyWIQlbReaZGGghfOSaxVtoux31nC6ICsuzvj6Bik
         woIDv9dG+nOYtP6mRxUIo27RpxvkvAKwynwQz1SrNqhHTgMC2EpDoA7NV0JJl0BH6C2b
         3BRQ==
X-Gm-Message-State: AFq9FYIspCEWq225acrMFCcD4JkkjuvsuSuByp1W83ab+v62xQrr1S10
	jmIPydkAnVzTkvql5L3SA8jNXItN3kcBMG3Tiycc4KUlAhICPd2Qg8wi2m4CD8+MLpI=
X-Gm-Gg: AYBFou2BPVk1XzI5bZAXxDAswC7UXT8THjs1IifHBFYzEYHSfeBoCOs1PA8c1roCPpv
	PNlhIoVdp3yjTNoAWdy5Fw4ZDEar+W3EuQRApzcx52Qxz5nB9tBwQit2/gb/4XYAGAuign2I4vN
	qOROUZQgv1/1F/WV6OyPCmVWIY7GGUnIKgxIrAH3GrjJsjiMwdFULcgCW/BGnIZrHErxhaULvC8
	Wte3MG9SBeQM07s62x4Tw4DRBQM/cOTeaSZXqKTi/lSCv0GUdHuyR2YQD9kMFldUDf3xJE9IAyt
	SOJ4HHpFYOWwwFu2z93m41fhDe53Wr1koxCYDGBK87vF5E0XCsDJ7+x5OA7uudUVd/GzCo9J0im
	nEaB6VMHtoSHAozh+ALsUg8PYg5lNgH7VWTCFSg45B7JONOxxxkRk3Ct6wx3olqlpGE4AywULay
	xmD5ilc0p7RlNnD5lNDR5IvpgxnpLTwEkWRsEYYdUuIF4j6AksWfoQeyM1GeDpby9CiXgEnGSXT
	+cH8Fp9qzAHTNowP88VkAYz9qyJ/sZzWd+5nhp+ir73lB6tFp/da94n
X-Received: by 2002:a05:620a:2954:b0:93f:167e:d990 with SMTP id af79cd13be357-93f29d76b1dmr1324305785a.50.1792440999939;
        Mon, 19 Oct 2026 13:16:39 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f4b05c917sm46679685a.10.2026.10.19.13.16.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 13:16:39 -0700 (PDT)
Date: Mon, 19 Oct 2026 16:16:37 -0400
From: Gregory Price <gourry@gourry.net>
To: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, Jiayuan Chen <jiayuan.chen@shopee.com>, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, akpm@linux-foundation.org, 
	vbabka@kernel.org, surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev, 
	hannes@cmpxchg.org, flyinrm@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH] mm/page_alloc: let the highest memory node recover from
 hopeless state
Message-ID: <atZ6H6IIx5gmiAkg@gourry-fedora-PF4VCD3F>
References: <20261019184850.3427905-1-gourry@gourry.net>
 <DM92ROTIF1U8.26CQNH7ZPEBG@nvidia.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM92ROTIF1U8.26CQNH7ZPEBG@nvidia.com>
X-Rspamd-Queue-Id: E7A8418000C
X-Stat-Signature: jwdpr9rzwwy3j36gk677zn6xqcohhtih
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792441000-782739
X-HE-Meta: U2FsdGVkX18834v2QCBMY56se1cKrtOywj4yJQ3Vrh5JryA+43IuEylqrF+XUaF3AkHX/LiqsNkd684QlU93jBtCnTru0pGC951gAhhIlqldN+SAxx6hGUN3ExvvR77d5QGNVexuMx3QkELlz9t7D8K9lcvQXP0eXJFDk+7Cy13Z0gmdXob5H6hVKXr/G63kY8wDQexdKW6PilftdWNP4SeJjRiyxe0twCTD69usnmwD/007X7VyuFQVxFcXXXHbIu+rcErAK3t2rK3zEHO1fo9cJCWn4xbbKOpVrV1aSVTV4oZ4qv0FLdQgCQYKYafsqBbltDbgjEKpH36rWA5Jh/2ZBoFYW2RF5fMPU8mrD6hrsMqyrTFQ+SCSpt9dDNBAVl1xMZ4UoQg8mHKxtXNBSYhYUFA8Yqa9m2LuQzuAaKw52CsWhEIBbvChVB1ChLoOEtlet8/bzHPHoJD/s5ypvm1+2CyC0SQPmdKv+trlxYLogAudYFi2KDaAwUjOw7GBC+mICLcsdvtQrUwQYr/J+XN8ciDLsYw+fjMSzDSNSZ3uZwx79R6990gywdLN1zaDvdpxsyGrQTjvv/QqEUNjS4JwLjqVJu70g7beeARCwyYE4jtuWW1V1jJe1aXPZo8d83c0riiTQI+eHbzKgO6BXa3rKxJET79Tf/eRRL0iHVF8fQDtTGes+OwJhXpXca5d3y7o5H1OabLRT/VHAGqcYEnHxl5Q54BM/AnUXLLibdi+S5gjigJPCMX4r0+yOJhRzj4IQqdxrPS3WE1llfzBrlHIOIrU1GHap74lZ1XwuZSFuGCpp028+2SiBqYG32mFueXkYt/9X902CgQhzTTXJ7DwXEFUvD/ewIopNSJaTQWUHxDeqHVlzNHC3+qKYPLU09l2Dj/nSljwsEPrVPCSgRjDxQZq8Jl3dUUMpYDukxj779A8UeK+5tkduTwp88KNrWBO0k5Jr+QHa7e0mG9
 VJAzCxT+
 2DQuLh4eIR0egd83oBVHo5QOxGclhCHOND4RDjYJ2pm9F+KNQ0smgNBKCmZhlkE5ulRLVQFEeNK6GmChZo58oQb5scWOXzEe95pqZiwAP1O7v5raGnN6KJirJXglvgvdKAFxRFDhitAPslApFzKi+Sg2dbEowAVijFdG+LemAvSIV14M0SUaxCtoNQ31HCEemWIeC+hWnz5Jgawq2EiZZQW5HziizdvSbguQOyo4RcZiHdfc3Tel9I4AxYxIu/ZMHDQmcbFqiOo39ErNLB+wZLm+6tcKGlV7kWJKUA/Uy2K+AX1R2o4G5mMaKu8DDfe04iO/JmAh1xh0XSANeptquQGRWNmFhmnFOFONHltJ8dHMEVXRFV1d8Eu1vVFtZ6khKC26a
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 03:51:27PM -0400, Zi Yan wrote:
> On Mon Oct 19, 2026 at 2:48 PM EDT, Gregory Price (Meta) wrote:
> >  		if (kswapd_test_hopeless(pgdat) &&
> > -		    next_memory_node(pgdat->node_id) < MAX_NUMNODES)
> > +		    num_node_state(N_MEMORY) > 1)
> 
> Why does a runtime behavior, clearing kswapd hopeless state, depend on a
> static memory topology (excluding memory hotadd/hotremove in this
> context)? There is nothing telling us if a fallback node has available memory.
> 
> Just reset it regardless. kswapd can go hopeless later if the node
> cannot be reclaimed.
> 

I mostly agree, but this was more of behavioral change than i was
outright willing to commit to in a stable backport.

I can send a follow up commit to drop the check altogether if you
prefer - but I'm not sure we want to drop it outright in the backport.

> BTW, LLM also points out that kswapd_try_clear_hopeless(), called by
> direct reclaim, only clears hopeless when the node is balanced, but that
> rarely happens. So hopeless state can stay much longer if there is only
> one node. Adding Jiayuna, who added kswapd_try_clear_hopeless(), to gvie
> some insight.
> 

Yeah I have some additional things in my pile on the hopeless flag, but
i haven't gotten around to them.

~Gregory

