Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6C78CCD1BB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 15:05:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12A808E0010; Wed, 22 Oct 2025 11:05:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 102158E0008; Wed, 22 Oct 2025 11:05:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0179D8E0010; Wed, 22 Oct 2025 11:05:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E59EE8E0008
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 11:05:25 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B5A7ABBC52
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 15:05:25 +0000 (UTC)
X-FDA: 84026073810.23.51AB706
Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	by imf11.hostedemail.com (Postfix) with ESMTP id B9A234000D
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 15:05:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=uQDHaWIr;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.46 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761145523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lkfsrx+l4jlC21dncenmKeHGGdvtV/ZkD7EyQedUCLY=;
	b=RUjHfJLIHsVvuATnQ5GmtcFc7W5jd7Ms4fTXL94oweOPvmN9+/RwUCiWYEIyMpKYpdDLh9
	ByjyNamrKfSTDhqQIFz7v66n+hH8yzgvbnwTgp47Fal3AD5jxeHL72JFCSWOMzeX2SnAMT
	38FLuvStFn5HHNN29zgEGwU9xt62lkE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=uQDHaWIr;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.46 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761145523; a=rsa-sha256;
	cv=none;
	b=jCXbDh4x0Crecy5VNzj1NPmZtfPOsFMUfm0Vd1xXZJdcPfnsWiuUVfUnZCSJl3PsWtHqf3
	bensn08Q2NpsZ6x+2AsafAqbFyhwR/8YQJW0IVhYz3O/7eKS6NVQgxzH5vYbkCV3GX64+p
	tB+60oU+XQPBVSTQhgiZWLALV5kyrwg=
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-9231a251c01so1940885241.1
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 08:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1761145523; x=1761750323; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Lkfsrx+l4jlC21dncenmKeHGGdvtV/ZkD7EyQedUCLY=;
        b=uQDHaWIrVnDbTTlloGmJh5tWOelWLK9FdqvhDdSwGLUf90LcvbkZt9BAElb65eqCjT
         7PSTzVvyrbxbhe3B2DDTAHi4QrDbxhJaO4Ggp8z8tr6fFGX8DDrTkItvn/c2n2pI95Oz
         4vfYyhV1T1VF8P8AtlP3ur51dl0zSyBmCLRwLAeE0RBct4BALMrXwP914VL0B9AN1iXv
         NscJ6uDTuqWTftiiZraraJ1c6UOc8RjIuXr6ZEaacgIBbkYzMewRb2Sf+znvtVWOxQn/
         GDVFzXh2tSaJ2QX7awoR4nTtJc55FmOSzjomdlu5FXwr3EXtGbmmpSxzEe4hxZ0+T8/S
         IRBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761145523; x=1761750323;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lkfsrx+l4jlC21dncenmKeHGGdvtV/ZkD7EyQedUCLY=;
        b=aL0P4NmmTSE8XG7gQAHEAQ82fTmJ39wFhp7Z3bOGk0xG6N3zTK3q2TBGWynCFSCfTl
         jc5rJMsY+sfJTofJ3mEieWL+FVbBpEHcHkwz966iMAQHrxY92d2WM+vWVRJ3J+bj7RLJ
         TVzyP4HV8wt/gX+fZoVsngc+7NkPIhUtavZVm6Do1/yWrOM+UgwX7YrcRFURsnfiQe6h
         H59Eh46Cl8Gbixc4hFHSn+s8FqPhRVT6Fb5JRzM1Ah3Tm03Hb34LsC4Roa6FKuQLBwBB
         NQbGIea8kh+ZMcMk0QXKrEigTJEaYWF2ZqZwa2IgYKWx3+7uR6Nl6hzZN6ul/xdEz/Rw
         uXwQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQpHM/jgTGH+6j0g/3d9xv6q15KWHyi2d1XXk1D/SeZRs7EIExfGx+ubEGxPa42h4sccUL+Cgz1g==@kvack.org
X-Gm-Message-State: AOJu0YzIx3JeOK4+J56QMPUX7byy+79Z0rJAIk1ztEjHDcRKrioWSv5o
	QpzXF67fcAXtEYPMk+wU5kre7bptQrs+jvVdwbQnprXnKBc9F1WC62h4wAaT8zeeTaY=
X-Gm-Gg: ASbGncvDD8ch8P9uKB3hQqXloKnKp31XiplulDe3QFv3+1Z90KpjyA/P04dbt+l96hy
	m4Rz26OMVENabQ/IHkRdsNj4GKnIzp+unClH8e3lixdp/Aat6UHbhAn4l2blEsoU2L1Of9/239K
	Kz5+hZQX6DkdwBfzsL6BaI6mbuabWqQhBJo7bpzSFKKJRezJqcwWdmDfU+KNNL7OZEheYyeW1p4
	274GDMiukzXS1xgYil8+H7/vTXABKpgK4+1KHv3Oc7tX+65Y4AspRphtHMz1E+6ki1abYG9AKch
	dycIq2gj7Xic4B8FE1gSSC3kYFDOvqxcANfmIIUlWBe+pOggyFrSTT4azmGPxmCKLkfWAMB7SaH
	bEHIiAvzAPO4qOS1QghtHUJ1fMV87OtlGv7DtSAu/UVp9e3qXVRIaZHLjN0UQTwCvpqRTCvol+U
	BfF1g2pCYY/WfvOYmVRcHUET0tD2n6guqB5mwGCRo6Mnhja+/vK1a9XLChwRQ=
X-Google-Smtp-Source: AGHT+IHMiHw+ozU+ptUdJ1d41xCzcfvQEjYcMBu/Kjjs0exhxm6ev7st/P+2mBHa/ufJLrkmED76uQ==
X-Received: by 2002:a05:6122:1d8d:b0:54c:da0:f711 with SMTP id 71dfb90a1353d-5564eeeb319mr5696564e0c.7.1761145522360;
        Wed, 22 Oct 2025 08:05:22 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87cf5235384sm91023196d6.28.2025.10.22.08.05.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Oct 2025 08:05:19 -0700 (PDT)
Date: Wed, 22 Oct 2025 11:05:16 -0400
From: Gregory Price <gourry@gourry.net>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: hannes@cmpxchg.org,
	Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>,
	Wei Xu <weixugc@google.com>, David Rientjes <rientjes@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Bharata B Rao <bharata@amd.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, dave.hansen@intel.com,
	mgorman@techsingularity.net, mingo@redhat.com, peterz@infradead.org,
	raghavendra.kt@amd.com, riel@surriel.com, sj@kernel.org,
	ying.huang@linux.alibaba.com, ziy@nvidia.com, dave@stgolabs.net,
	nifan.cxl@gmail.com, xuezhengchu@huawei.com,
	akpm@linux-foundation.org, david@redhat.com, byungchul@sk.com,
	kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com,
	balbirs@nvidia.com, alok.rathore@samsung.com, yiannis@zptcorp.com,
	Adam Manzanares <a.manzanares@samsung.com>
Subject: Re: [RFC PATCH v2 0/8] mm: Hot page tracking and promotion
 infrastructure
Message-ID: <aPjyrAo5LdC5pAqv@gourry-fedora-PF4VCD3F>
References: <aNWRuKGurAntxhxG@gourry-fedora-PF4VCD3F>
 <aNzWwz5OYLOjwjLv@gourry-fedora-PF4VCD3F>
 <CAOi6=wTsY=EWt=yQ_7QJONsJpTM_3HKp0c42FKaJ8iJ2q8-n+w@mail.gmail.com>
 <aPJPnZ01Gzi533v4@gourry-fedora-PF4VCD3F>
 <20251017153613.00004940@huawei.com>
 <aPJZtQS4wJ1fkJq-@gourry-fedora-PF4VCD3F>
 <20251020150526.000078b6@huawei.com>
 <aPfWePBq8d3v979f@gourry-fedora-PF4VCD3F>
 <aPfXloRQgplusnce@gourry-fedora-PF4VCD3F>
 <20251022100950.00002785@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251022100950.00002785@huawei.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B9A234000D
X-Stat-Signature: uggyjauddnedwbosbp9fa5wfthew9apd
X-Rspam-User: 
X-HE-Tag: 1761145523-861577
X-HE-Meta: U2FsdGVkX1/M2hz0TgiUwf/sYwsNJDBfebGuEhpRBWwrcYb2zonGhIxbzHa71YOnfhKZ1qfFOZPEJMhkKpt6IMvFOwkLBV0307I46Sa7bREHcWoGb1rQnjvtfzWTcKP0audJTUrWyNWOn1ryvCnW5De2BKR8Lv5CQEmqz5BrQ3wZJLmHs5Ges5pJAdlp4i/RN3giBiIlRz0dXQHhqAZaN8joW5Qsx7XSvpIKxopslwuEkBC5nQgEFtMRej+06tYY2G/ig100yYvpGtytbnGVjl8APOL8x48Dz5ABEM9xonkFkFKi68DkGveiCQmeQThwxB5FA7dEKR438hFWwb+E3pGBmrefnDj7FVttkxg7GH00X5XD6NSwrquinINpLpmVLZ7VjD4EBYwZ+2lu+IGCZYK6piMBFElgXR7pE1apZP0yHQjvmG4xtigxmQi6Pntn4VRSkzAR7rXDso7tdXxn5xmMqZsnOKAqxFCarPcuxFNOjLM1ofz1VIZd4PTxnGcdq1EPYyyD7NG3UxvdZCqCfXSdhKpwu20M0V/I+leG+/RnNju0FMq8XY3IQE3cadfRQeMqBnlxJ3SBe7e9XEq+FWctZg5URwWzwAfh03owO27z1hqHMOtREfJlqG4meDyq4Fd9Ym1+ouAxExdCIT8x+wKyG6dPjfByOCTnoX1mVrmPZUSSOCQWMey9cyaxk134oIT1KENP+uD+EB0+quSbcuhm/jRYGt+OJg8QAT7AKEcoLioG8VlXLstQu5HSgiz5GMNSyLXOWk9Dr/ds2ALF5zt22b3ueh7I2Mq4FwkhuNM1rIDIDasFsgMvSGN4Lw+zqDLMwuqqN+WB3e/1UFmicp2f+6zko+TUBmMDeHIJxpQXMNhIFqmL6aIhylM63cgdhut1L627Kk2yAKCW7ZKOCMCjh7mbIIMIMxqIpDUnjGewN4gnB/tksWGSMoNFv97vTfCh+6bMwdonbKgSkUf
 EPTCmAVU
 AXjQCTQf09Bsk6IcGhoo3veWCKTucdiegzubFGb8j2KO9vSRxN4XL/X9JmhYJ+KReClquN2pGKnv6nQVy60bc9l6EDs6fLn+M8cqQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 10:09:50AM +0100, Jonathan Cameron wrote:
> 
> My gut feeling is the need to do dynamic NUMA nodes will not be driven
> but this but more by large scale fabrics (if that ever happens)
> and trade offs of host PA space vs QoS in the hardware.  Those
> trade offs might put memory with very different performance
> characteristics behind one window.
> 

I can't believe we live in a world where "We have to think about the
scenario where we actually need all 256 TB of 48-bit phys-addressing"
is not a tongue in cheek joke o_o

That's a paltry 2048 128GB DIMMs... and whatever monstrosity you have to
build to host it all but that's at least a fun engineering problem :V

Bring on the 128-bit CPUs!

What do we name those x86 registers though? Slap the E back on for ERAX?

> Meh. Let's suggest people burn host PA space for now.  If anyone hits
> that limit they can solve it (crosses fingers it's not my lot :)
> 

+1

~Gregory

