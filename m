Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBC15CD98F2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 19:29:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 991926B0005; Wed, 17 Jun 2026 15:29:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93A626B0088; Wed, 17 Jun 2026 15:29:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 828EB6B008C; Wed, 17 Jun 2026 15:29:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 591F66B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 15:29:33 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CEDBA8EBA8
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 19:29:32 +0000 (UTC)
X-FDA: 84890393784.01.4FDA7FC
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf11.hostedemail.com (Postfix) with ESMTP id E972D4000B
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 19:29:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=MtAW1IL3;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.43 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781724571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HsWWktqv2G660ewz5kGZOgi567bNOYTEL7LINQXUsWA=;
	b=JArjHDBLnYW0A+6bpdcaJ8Yh7IyGtPj2d8CCvBwxyLRbgLeebFTel9c0QAAmgAPzoMDllE
	4PNcqNY578Wmkr68XgP05VU/5vWI3YmMGj1TJhxVhbGUF9m6xq2gVMfm0LxJcvyvmcuJNE
	Q6jUlo4lUSTYQ+ErdAFYegfy2ZWlFBM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=MtAW1IL3;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.43 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781724571;
	b=ehNp0uuoJbQYap1GW9okJ1EFaS62XAdT2dn6r8KqBaqSMiX6Bqw5smN43+2U0p1iv8Qp1H
	TL+DQnqeTUxUcLmgAo1pu5MjiaAEPIDN55bZJufoxkkC8gXAbfuX1Se/Jbp4I8LixozyBE
	upso/XwxGac46ehjbzEPvjkJxEZMhjk=
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8db9f25c5acso1890096d6.0
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 12:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1781724570; x=1782329370; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HsWWktqv2G660ewz5kGZOgi567bNOYTEL7LINQXUsWA=;
        b=MtAW1IL3jjIww9M0SOS+D9maZNif2i9If8kui9yzped2Y68hGXJhAkpL/XLYP8Egrt
         0/miBMubO7j30JulTQx8N53jSNPS0tBqD8EGIYGV+dJiX5uOk8UtZGJEnnymlxZdmGLA
         FKhQ2WboMytqsZQ+KH++UqFkhaebnhC+rFTjBr9uRZpI/INeROEcqUpqWYLUyP/W8pak
         6wOInUZe1pTK2kDSL6qgoPaYJGPcB+XqTGecVm5JDVfxua2JT9MXaICRwuSb7b4VR7he
         jJbcUdu0PsJB9qc1tUwGLwxBIHKM5bkz+Gjgf7YwPpfxv2BT/k5obI96tUMDgalGgOfh
         TOmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781724570; x=1782329370;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HsWWktqv2G660ewz5kGZOgi567bNOYTEL7LINQXUsWA=;
        b=UtPnl5c1/A0ZqaPubiqMmutTPIHLZzO3aoElirrPGiBV54xpsHPNw4FFAvFYhKY12S
         YYOBhdsFUlk/X+9EQd5/lJDV07O0MRVPOYvkWIE5Ubg1ZhsTPtFquX3FQnqd91fujYYu
         FUATSPyZqnRU0rL6Altzi8CP9YADKnBGt+A/+Nm8Q2osUTTntpveaMuL1KsKC0LWsG5t
         PdOu5a/T82Xv06GDHPAheiP3h3Q84F9j4AaBVu5h0D0edlJwIbxJYfGdzy2DNwui5WBS
         Ei3ANqFcUF2LGNLDPBoU3S8xORM1hUKzltsVd/hVL/41T7vyH6MnX1AuT0N42rwkO70u
         icFA==
X-Forwarded-Encrypted: i=1; AFNElJ/HI8PLc+4luKSjMc5zTHDnfax4VEVkcT5hDcSvqJI4JYBkN9zv5Zqr8LgplrZQqbMnlw/I60TB2Q==@kvack.org
X-Gm-Message-State: AOJu0YwTVDs+0MwsVFoNrAxqhQMhTf81K514fCVfodvmVVnm+lZLAolN
	ufRHaPBFghOp1MZ2qvGkpak7/eWaXLkuSnrN9xS8/CGtBrXGckq9H0eBA2o6LHqBacY=
X-Gm-Gg: Acq92OHYxOoiIDpirBQh8LFdMewZ+7SyuW9Ezr166Op0uY7UfFSKXUupOsLpfscnRND
	jI3JUcgzDKpJB0cT3boEWwTFHwgZAwg9UJJmS6QzcyW3vYOuLLVS/KPOjqDvsSidP1klNVW3bYx
	+zOk6P2xql4puQd79eGxx2vByha9GB5zE7GfEFNgwZLzz3Cz6YSZgb1VNV3qQVdEOT/uX0BOaTr
	QNyuc3kwDF2AvK05KdtOkm0Lk4BO3yMlGRABeog+Xw5W9JTbjbhMuUdPaKryiP9FQDLOCld+GyC
	3B8F8d4cqRgWpuUJNh2CGDkBGyv8DmYWhy32ipRcKn9b7C/AIw+26cMz8R6nRdW95NLmKEtF4zG
	mbUgI0DTQU+Yz1P88D+69tTSPwNPVyECOoDkRFQKjR69O0PBtULYy599gAHB6MNH4CqraJ2N/h8
	yKKifvuzhYCEvL3oZVT9v7ZKoBA9tFETYQhRVJuuTCUnWtiB4ZyNGtLNMlVHgqyTs7aqc=
X-Received: by 2002:a05:622a:a54e:b0:517:5f04:f24c with SMTP id d75a77b69052e-519c6f3e9a9mr5534601cf.39.1781724569704;
        Wed, 17 Jun 2026 12:29:29 -0700 (PDT)
Received: from ziepe.ca (crbknf0213w-47-54-130-67.pppoe-dynamic.high-speed.nl.bellaliant.net. [47.54.130.67])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-517fb61e767sm175111801cf.2.2026.06.17.12.29.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2026 12:29:29 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wZvx2-00000001AOF-2emD;
	Wed, 17 Jun 2026 16:29:28 -0300
Date: Wed, 17 Jun 2026 16:29:28 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Matthew Wilcox <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>, Alex Williamson <alex@shazbot.org>,
	Anthony Pighin <anthony.pighin@nokia.com>,
	linux-kernel@vger.kernel.org,
	Kefeng Wang <wangkefeng.wang@huawei.com>, kvm@vger.kernel.org,
	linux-mm@kvack.org, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>
Subject: Re: [PATCH] vfio: Request THP-aligned mmap for device fds
Message-ID: <20260617192928.GB231643@ziepe.ca>
References: <20260616180129.160016-1-anthony.pighin@nokia.com>
 <20260616163054.77fdb61a@shazbot.org>
 <ajKtdCN0AlbmBnAj@x1.local>
 <ajLontmFa1oRXeoK@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajLontmFa1oRXeoK@casper.infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E972D4000B
X-Stat-Signature: btc1q3fsc8ojed1q58re7no31oggc3ap
X-HE-Tag: 1781724570-175346
X-HE-Meta: U2FsdGVkX18VwsGuECwFQ4QtA0WitMJD92myuB4NFTN4znalamzbZ+6UjdzAw7nFjV8HRSZhI7gdbL0cfJYvRxdaxehjMoeeYxp5Tfj50o17otPfGOyoV3MlGQh/c+0rDzurZgiGf7cB3U7oJ49NT4ADYkZXy0pmcFKZZ41ClmkOBi7B7hUJSU+J47sr/h6JCK6wZUWuaGXN5vFHeSIPF2RFq2cvFOyxsIblqvbfimVghZqMf6SEdQEx1acX9slrebVQSP4j4X6kw7+ZYkMhulR/HV1WhkNqKO6LMw6N9BA5ry/ana/XldaSjPuAgRaQM0mlZHBxvNcmx4FasWES6Z7xIMjnSuYWTjsJjPZKggVRkywaV36jNyebBGSrTpEllMqNzMkbcXw2tVjVSXP8jvbRtD/gqL2r/Cc33tUF78SGqdmkcGOFrAdEdkUzIqji0B86BMRUumi7CzWC9qLFfgEucsAmPQ1JBCHZ/1l8GBfzLXxGQW7U7Buy1VAqw4MF/8fbLqVoLTJ6JuOzuFDnbHGr3hj+7X7ghlzsVvjmBcjDNQpdzDxqRgRWC/LTYgdIuZpCnUhp3iV98Fkf26BBtRDmyCSCV1Z8uO8Lhkd6qI00JMVCZU/u2/GKl7nLpARI3WBfZFjyVvkzYqxvgQnB5X5rwTp88p5UKwmfE9p6NpbJbFuOLOOwSsb0vcvFdAyl97NoFncRtssJBHbdSKntM3e8UhxLSgyjSZd5UuqGEDPM6SEjcOkFO0J60L0IoBnYJM5C1wQPnfnde2QNK7nwlJiHLq8WtaKWb6vALcXRNSdwoYou8fiPhAIGM1lD/gSqv95co6hCkoM2zLnOCvQffMTNbJMXtgTovhweVrwaHX73KtPZY+780fUx0kflHTEL+RMYRf3tqoxny0uPM/3QAU2dmFqaGOZOOn6AlorOFHAkboE1xGH5utXyrlE3nZqKQlcBu4pbx34oltTjU0j
 34EJxYVH
 xyYRMN+/IxYwXgrfQme/VyCiPRWR0s8IdhfJw0rvUCjX9ZZ6Ors7bt8KhNtr3st2RyEPbn6dMaJ4s7Z6NND08KqvatOsRmeJOKw3gU/6gL9qDNRAF6KW03hiWJBg3lP0jzsGuxH2l4hpJxpIi6YCJmINl1gVwMFngVrggZicrqv+eRltgK3O+/d8Pn18Ffb/X72pGddvuppX89Jay3Clfe9XxBQIorWGa6TYE7z66aqIugzf1szVVwhSfjurSIdDTjMVgeI9ZIjKp0m+VeeGPlEtUbhFUit4Xv7IN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 17, 2026 at 07:34:06PM +0100, Matthew Wilcox wrote:

> I don't see this as being something that drivers should be involved with
> at all.  The MM should be able to get this right without any hints from
> the file-provider.  Yes, that means I also want to get rid of the setting
> of get_unmapped_area in ext4/xfs/other filesystems.
> 
> Looking at generic_get_unmapped_area_topdown(), I think we can do this by
> making an additional call to vm_unmapped_area() before the existing two,
> setting info.align_mask and info.align_offset appropriately.
> 
> Now, what's "appropriately"?  I think it's based on length (>= PMD_SIZE,
> then >= PUD_SIZE), but we should also take CONTPTE architectures into
> account. 

The info.align_mask and info.align_offset do need information from the
driver based on what it intends to map into the VMA that is being
created.

Filesystems probably have quite different requirements than drivers
using remap_pfn() or vmf_insert_pfn() that have locked down pfn's.

A pfn driver often has a single already known physical range that it
will use for the VMA and that range should drive the alignment
decision of the VMA.

vfio in particular has common use cases where you want to mmap from
weird offsets, but we still want to achieve a VMA starting point that
has pa % PUD_SIZE == va % PUD_SIZE. It is impossible to do this if the
thing building info does not know pa.

I do think it makes sense that no file provider should be computing
the VA area itself, I think I made that case when Peter was last
working on this. Now that we have Lorenzo's mmap changes maybe we
should be talking about supporting VFIO by having a callback to obtain
the starting pfn for the VMA. Usable only by drivers like VFIO that
are working with the pfn functions.

The starting pfn and VMA size is enough for the mm to setup info
suitably.

Maybe other users would prefer a 'max order' callback and then the mm
would assume the VMA will be popoulated with pgoff aligned folios up
to that highest order?

> And maybe there's a CONTPMD architecture we should also consider?

ARM HW supports "CONTPMD" but I suppose it is not implemented..

Jason

