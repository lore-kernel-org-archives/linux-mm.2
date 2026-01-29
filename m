Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17AB5D46BED
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 00:37:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF8876B0088; Wed, 28 Jan 2026 19:37:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7C296B0089; Wed, 28 Jan 2026 19:37:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5D756B008A; Wed, 28 Jan 2026 19:37:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 94BCE6B0088
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 19:37:58 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E0FBED459E
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 00:37:57 +0000 (UTC)
X-FDA: 84383138994.28.60C0362
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf01.hostedemail.com (Postfix) with ESMTP id EF26A40008
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 00:37:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=fCDu3GXh;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.173 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769647076; a=rsa-sha256;
	cv=none;
	b=DSENkHiYFWUY/H6EXOptS8qe2fva4nfGol1mBSw5lOONf8NprzeQWXAb9cF3ijTNO8aZEJ
	vIL9x6zD2l9S6C8qmU2hyyaUXRzPrwmNNa5qP+NdasGGisvWOWdCvLAxzrgcFmReh2X+a4
	36O8TkR5WdNUskI0HQRLiR6ZA3HVa80=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=fCDu3GXh;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.173 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769647076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1OWzBPKnyrz01i64zQ4S/hZaAIPcGy0JKcdMQLZXMgA=;
	b=lnCKn13SI9RW13jef5vT2dNzrkrhWJJhZfsCRzfigHBPeUnKfnAG4T2Nb9p/Ddfq4Wcg9r
	I3dq2pT92itaUUky6WL86jJT37kVzgmAiA7qGdwoXL7tSPte/ySycpl1NO++rZyTERxBQf
	fUwpMsl4xLIaW1qIWSRrrZgobKU+rOs=
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-8c7146b0854so51156785a.2
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 16:37:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1769647075; x=1770251875; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1OWzBPKnyrz01i64zQ4S/hZaAIPcGy0JKcdMQLZXMgA=;
        b=fCDu3GXhaotvvxwKQp/BIHYH9WoLTm7lWFzLtakLNpg+amK07Dds9vQ8yEvYw43kiu
         EkTFDY6kXTVavDWH1Gx+9LdlhMhtUWyuOH5cTLg9VHU3IyGBoH6mhZm/Lbs6ZinL7BzA
         whMxSHX+tX4iOerFPdukZZ0cTiPvrxO+1Z90LDasfWFeJaIse/aLJOuvJtiU5Kthv5N9
         nRGEXXv/+ANpntNyZUBySeHmghvL264hGiMzmXbPhDP2IqA/up6uNGRVvT3Sac8kptym
         e4XBDrnuwQm/tV17KGY0DJ46/JoYd5qjO3GmmvJnS9gzw93JPs9reNovsGj2zPmSNVQ1
         phlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769647075; x=1770251875;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1OWzBPKnyrz01i64zQ4S/hZaAIPcGy0JKcdMQLZXMgA=;
        b=ivBdeG6GUq5j2ndSJsmGKu4CRNHrfOYhr9g2ElVlKUYSsFZ/rxwH7At32OcF1gu7Xs
         MvmTcuJn5tSRaJw0M2HeJ+MHLfXGY7xPIum8elSeal3lZRyr9KxMlPOaPU+2cLn4ba8B
         c+g3XGpVQXfe7EDjx68smJV5as3FLcr5RS4BdoqOH6Ri2oaOxfgvrGaqkGfCC5FrhgiD
         ZkvryiTsDNlUeQkv0BsFLBnSi6H/QTQFqkioY+6Y7kmXsiTW74ETSlLAKoCdFex8Ixql
         kRWwJTfBNCkkErHuPazEC6FkqMBWbVAzkv0WFTt1W08PmsGuePmcZzzkG4rUScg9ti6w
         BVAw==
X-Forwarded-Encrypted: i=1; AJvYcCWHAchHheS75Ljex70bMyOVBICN68Y+hPXwJiiSGjio1CfuJdOaKY+L0fnpmHexKW7WOXMWQ+DByA==@kvack.org
X-Gm-Message-State: AOJu0Yyr0SdA5xq7aE66llEz7L+j4lkoSulpIIZ1npBd5feJPUuXI07x
	gXFAUWwTAXYAqQ+nCvPhIt0mUreAJUMaqgSKKoZlAUr2tAFvlZgO7nqGhHSbzIE3GvI=
X-Gm-Gg: AZuq6aKcd7o+aVpqkQeLQck8xVsZnvDiCex+lsGTN+1QV5odILg0DcYRfnsRhAW4BMI
	0jVrweiWhe6hh3vZtxGfr1zpDJTEtTZ+FHrnha+Ul4qPyA1c3OxgyowvhI8GZAQd08I4jaGO2W2
	Luuo1xbao50I11mVtAjymhPZPdgbyYtBFwUjsAaJIFtgTxNeirZtFnm32gMUodF3xbA6XlSGwob
	xU5iW8O3J3fOQOE9p8TV/f9P2G1KIAaxwLBNw96STzRhR9abTaIdhtT6dQ1iWDvo2CJFulhd1As
	lIypREejYLuK2N4CmwjQVeFcDcKpaPRkNOkFf9W+WNiTQuEnP+0Zt2bF91bzc2entVfzhdDe7yt
	ndo7R2UvcWqBQ8WDIXLgt74f4HzsnbYL0OBz4XYtjpsfJGPplQ+kr4jsPAgXb40dZ1BNaSwLYl/
	8jZm4XjBaLcJfx39+JDGxjEEpjNX6nobhXDzb0wV62XJEJfwp2hFYFyplEfESciY7YlT0=
X-Received: by 2002:ae9:c202:0:b0:8c7:126e:e901 with SMTP id af79cd13be357-8c7126eeb1amr465687985a.22.1769647074488;
        Wed, 28 Jan 2026 16:37:54 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c711d29aa2sm294243485a.35.2026.01.28.16.37.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 16:37:53 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vlG2j-00000009g5p-04Lm;
	Wed, 28 Jan 2026 20:37:53 -0400
Date: Wed, 28 Jan 2026 20:37:53 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Alexey Kardashevskiy <aik@amd.com>, cgroups@vger.kernel.org,
	kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org, x86@kernel.org,
	akpm@linux-foundation.org, binbin.wu@linux.intel.com, bp@alien8.de,
	brauner@kernel.org, chao.p.peng@intel.com, chenhuacai@kernel.org,
	corbet@lwn.net, dave.hansen@intel.com, dave.hansen@linux.intel.com,
	david@redhat.com, dmatlack@google.com, erdemaktas@google.com,
	fan.du@intel.com, fvdl@google.com, haibo1.xu@intel.com,
	hannes@cmpxchg.org, hch@infradead.org, hpa@zytor.com,
	hughd@google.com, ira.weiny@intel.com, isaku.yamahata@intel.com,
	jack@suse.cz, james.morse@arm.com, jarkko@kernel.org,
	jgowans@amazon.com, jhubbard@nvidia.com, jroedel@suse.de,
	jthoughton@google.com, jun.miao@intel.com, kai.huang@intel.com,
	keirf@google.com, kent.overstreet@linux.dev,
	liam.merwick@oracle.com, maciej.wieczor-retman@intel.com,
	mail@maciej.szmigiero.name, maobibo@loongson.cn,
	mathieu.desnoyers@efficios.com, maz@kernel.org, mhiramat@kernel.org,
	mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com,
	mingo@redhat.com, mlevitsk@redhat.com, mpe@ellerman.id.au,
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es,
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com,
	paul.walmsley@sifive.com, pbonzini@redhat.com, peterx@redhat.com,
	pgonda@google.com, prsampat@amd.com, pvorel@suse.cz,
	qperret@google.com, richard.weiyang@gmail.com,
	rick.p.edgecombe@intel.com, rientjes@google.com,
	rostedt@goodmis.org, roypat@amazon.co.uk, rppt@kernel.org,
	seanjc@google.com, shakeel.butt@linux.dev, shuah@kernel.org,
	steven.price@arm.com, steven.sistare@oracle.com,
	suzuki.poulose@arm.com, tabba@google.com, tglx@linutronix.de,
	thomas.lendacky@amd.com, vannapurve@google.com, vbabka@suse.cz,
	viro@zeniv.linux.org.uk, vkuznets@redhat.com, wei.w.wang@intel.com,
	will@kernel.org, willy@infradead.org, wyihan@google.com,
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com,
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Subject: Re: [RFC PATCH v1 05/37] KVM: guest_memfd: Wire up
 kvm_get_memory_attributes() to per-gmem attributes
Message-ID: <20260129003753.GZ1641016@ziepe.ca>
References: <cover.1760731772.git.ackerleytng@google.com>
 <071a3c6603809186e914fe5fed939edee4e11988.1760731772.git.ackerleytng@google.com>
 <07836b1d-d0d8-40f2-8f7b-7805beca31d0@amd.com>
 <CAEvNRgEuez=JbArRf2SApLAL0usv5-Q6q=nBPOFMHrHGaKAtMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEvNRgEuez=JbArRf2SApLAL0usv5-Q6q=nBPOFMHrHGaKAtMw@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EF26A40008
X-Stat-Signature: nq8yy7aydifqe6ewfjjgfgaoa7u9sq8g
X-HE-Tag: 1769647075-122237
X-HE-Meta: U2FsdGVkX1+BW3OPF04oQ9gfo2ohzc0DyTGSFh7fUhM6R6msjLYVjsQm8J5Q+mexwPcDYILh+GxP8P/6MwbNMFgvdbArCIAVv3mYOGqjuIJcAezFXWMY/FiF8xRmIkt+I5PIGca5fS00aEkvBcNn47V5KQNj8GOha/q6wpjsKRVU5rmSQSjSSv5bOYf7mCE29g/SsXFPmV7URZxJ+409ZK1Q5TECZoD+mAZ7e4COYt4q0JshcY1aCtNIyNCup/oXwxWShoMWoBZO7U7KbyZzEN/5D393Zkxy8tEbgggkCvpvmVrwecy2VJeDAx93ML73gglEIcHav/qajY9simIuas/ByzLqI2kr4IeyuR0pxKZxoYJ+z7L9c2UpXz60QmKrO9CHTBajt3J338h8MysbWxmmAuSVr9WwiAEvMMGsmm6uJRS7Gu83wUnDT0Q8GxilWrG47jqd9oj/afT3L7Ep+h/2LGcCUYZ4k5EtBWE2VoV5MCTG4MS/wYeZ409077+BJVh5aSAWplL3ZR6vUFSVaYCCdvWRtIQ33aHuhJN2YN3uENjkGgzQJnh0QK29qmR3Xf6G5FlO0vy/STxrGRz+agWsB4/7pmp+Q1zlVpu1NRurnCCkHAADJuXSS9EBNlX9tN0JqiDlLPahRjA5cW1c5bf33popOhpU0vHquguNm7IqzsFX//nUwrvB2jHCGgJFqElxsbEh1jCnJ3TowljDQshCXpuj3bamZzBagl0Ojw2VuhltKc85/gDto1SpeZOCX/s8P+9ZOSw5PbdYLKz9ARKN35XU5Di+qZV/DnyQTJLOjpJKHa+qZxvRuRKYoXakWUeIBcq4+Ep8ZD+San7QRTiPuRJU8s8Zgy/sXs1RYQJo0pjBZg8bO56oNIRU29YqZfUkJbHjU4JdBKXDAYD311Z31ijbV1nSFElImjikDxCzbKZVpYKYFL6CPhKLGs3sfxXOjTDwPecVRef0ASP
 ruafkqPx
 5s1/0HYQYs1k1ZfQdJiFxlAjQ3qGcbwrdAm0J0u0wnHjimT9wMCzAn0bR/AoQVSeZ0+PdRZl6tWdfQOb+Fvmu2Lfjcpe/dNNt2g+Ry3aNt524n8IIrZz6ueIO8BQPZT7aUYS4uXY6k9A8D/t+kWc0e3z/AT9ICkAAEra0W9SbYgBxsA3CvgYxATXYQ1ET3GKyiUCZtQ0FWpP5wB35T0wF9Z1lEQBLq0R9pVJDLc8ojPNg/ekgpE7Tw7b+Li6oM3fwRfk9hNatY9hC72htujZdvCN7TTGDU4RuhvH08KdG/CG/ia+SZz0rG+JIxhzniqRotT5kqxjBNL3ekDL3AbY7nrZ8N/4YXQJylT/IOyT8FRKHScWpYKD19C3wmh2S5uyj2EBXyXJwx/hOu4/0Qitja5Z/cGwMOXFbUeX0McrJ88S1B+o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 28, 2026 at 01:47:50PM -0800, Ackerley Tng wrote:
> Alexey Kardashevskiy <aik@amd.com> writes:
> 
> >
> > [...snip...]
> >
> >
> 
> Thanks for bringing this up!
> 
> > I am trying to make it work with TEE-IO where fd of VFIO MMIO is a dmabuf fd while the rest (guest RAM) is gmemfd. The above suggests that if there is gmemfd - then the memory attributes are handled by gmemfd which is... expected?
> >
> 
> I think this is not expected.
> 
> IIUC MMIO guest physical addresses don't have an associated memslot, but
> if you managed to get to that line in kvm_gmem_get_memory_attributes(),
> then there is an associated memslot (slot != NULL)?

I think they should have a memslot, shouldn't they? I imagine creating
a memslot from a FD and the FD can be memfd, guestmemfd, dmabuf, etc,
etc ?

> Either way, guest_memfd shouldn't store attributes for guest physical
> addresses that don't belong to some guest_memfd memslot.
> 
> I think we need a broader discussion for this on where to store memory
> attributes for MMIO addresses.
> 
> I think we should at least have line of sight to storing memory
> attributes for MMIO addresses, in case we want to design something else,
> since we're putting vm_memory_attributes on a deprecation path with this
> series.

I don't know where you want to store them in KVM long term, but they
need to come from the dmabuf itself (probably via a struct
p2pdma_provider) and currently it is OK to assume all DMABUFs are
uncachable MMIO that is safe for the VM to convert into "write
combining" (eg Normal-NC on ARM)

Jason


