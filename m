Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92656D2FEF9
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 23:46:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 009E96B0089; Tue, 27 Jan 2026 18:46:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF9D36B008C; Tue, 27 Jan 2026 18:46:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDB2D6B0092; Tue, 27 Jan 2026 18:46:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CD9916B0089
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 18:46:44 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7E873C1A25
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 23:46:44 +0000 (UTC)
X-FDA: 84379381128.16.15E9243
Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com [209.85.221.178])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7D91E8000F
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 23:46:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yChUn5Xr;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf02.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.178 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769557601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3+EqNzQT9TNRk9U4Wm8Lp51VnBAV17bgK1qxop8j5Is=;
	b=Kfpbu/6gN7K/WIOfupfT6q5W9SHA17Gt5j+BTngWs8F5bPQHzXxJ5y0KMuUQOkayg0Jz6F
	GzjIxB79A68UM6Qby8VnlLBjecnxI0shBAhG8Nds9XLiK3hstYHdr2SwgtxOaNvrQYpr7X
	pJrBruPdV46LU5wUiKPqGaenNfCg5ig=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769557601; a=rsa-sha256;
	cv=pass;
	b=SLUyRFbKatcK581Zmgf6i/vnaiHgI5wV4fO3n78Z3Am8fCDnqHT2753YfFdmquRvvo/Olg
	aI3kGS+WFL1LLz6NkfoY0f5VKYcFdZJ0T4eQJOPiksGwU1qCOQuFxvQL0r8Vo0YLuA7rqd
	cr/NeIYBja1Ib3HQnjPhUDk/FpmygM0=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yChUn5Xr;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf02.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.178 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-vk1-f178.google.com with SMTP id 71dfb90a1353d-5664393d409so1239502e0c.0
        for <linux-mm@kvack.org>; Tue, 27 Jan 2026 15:46:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769557600; cv=none;
        d=google.com; s=arc-20240605;
        b=LAtXoV16iIj5XudnfS7pqXxrqSD218ZDQAnOJPneyeoXxBCCqjLuBqRdJWUCzbziGj
         +I5gXsA38ZQ14D4k4INpcnDQWdcRbzaAwHGWmxQYF2Y0KoF2dNpY4bCvrEe4tIu4/1/Y
         nS54K1b5A3B7bFberPukYTTaGhhFMDa4LFYibNyaPz1CJ9YG3XZpByn4VCma1B0c5KBz
         a3qUfhIQogy9sHG3NAAqXT2dU7kBe5wmUjBKir3i2fEmgcUp/erlrO/7mvnw+WB8KUHA
         QTXf/9B0X4g/I997fydVFiwZ4EJbNrnHWOgp/GjRpMClT+wP0vUtXKhHiJVOwmQjeRZj
         2UYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=3+EqNzQT9TNRk9U4Wm8Lp51VnBAV17bgK1qxop8j5Is=;
        fh=EL5+HVIeFRvKcjIFWWDfPBKfibRfbYc9RHjqZ9teZJE=;
        b=BBFCeJ7yNRJhM4k4OVqYiMcrOJeIcjrW8pxWV+PtzF8MUpCZv54n0eFYIcPSvM94tD
         Jcx5A0YIdMBfVu8yhlltvIlBJ4Mda3fF8q1X78G5ZYg+k5qmCD2JncI7VVyR8Fmp7gOo
         hoNRRxPdlYMpdZMsYKYz20hkwuIWCkY0xI0d2jBlvqIIX+G33yRGrCrNINuH/RzVncbD
         Y9AmfXXe8czuoQJB8Zmb4dFRR0oz+KYDSP9I1VwpSFIeDOcJXAM1MWAXYC8RqCnA0VGM
         3eMYG4wbwRxNg7fhlEVfiYBR1ECaEm30hI/m/IUoBWIbmM5fgseZlrxfGljEl5dyb08E
         kZwA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769557600; x=1770162400; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=3+EqNzQT9TNRk9U4Wm8Lp51VnBAV17bgK1qxop8j5Is=;
        b=yChUn5XrSO6589dJGsS9kiKrEhNBHrMKj3aAxiKd947OCGZAtvdvJipZR5lqxJgWFs
         8Gax4H/RB6vJyj8MoOJMcpvFVhOsEiFKY7Ad2nIZWXlAhm5mFtLzKmIT5nIl5vjSaqr+
         rwoUHsf8L6FHJNxbR/+Jw28Ktt+92ZDvjSKQYpyzMyYwB8vSVpFfeFTUAAHALrUPgjo6
         p7Y1pHzm5OsRm1iew87t6mznGcEm0ghQrFsLZxiO4LG1yyRXLo4TA0WgTn60NNzc5yTU
         EA6gbnJxLeHJgekMkP6mfGPEDvm9966KYLpUUf9P38GO5uLAR06ivnYN/0u7ixrLR9vh
         dDbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769557600; x=1770162400;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3+EqNzQT9TNRk9U4Wm8Lp51VnBAV17bgK1qxop8j5Is=;
        b=KCLbqWQNQgTl5/cc4Utvu25+hC4r3IwfvzJJxwVTmtKGSnysp7pNAHxltQgqP0fO79
         o8oR9PMsK+wZ9ia3l5Zf7RMoyiHzKtZ4+4Xunzd41xHDM05DeOyXsqFTybvqirh1hA3G
         subh15U1TWMY/Vgh4l1UJzxrRcNL0+XMIsbsP/D95LdodjFNPArt0r8U7zTpwzCVr0Sj
         jV0AAvZ3PlvVu3jXezM8SnnBkyuM8owqNxWAFc4c7A8C6RvLt+OwSb66knRccm794x7U
         XYMdMxcYr2n2qNd91sGh6fKYV17HTtJ3c5EjeUMrIN+d/qt2nxUk2hQWKObXNargO5d8
         vrTg==
X-Forwarded-Encrypted: i=1; AJvYcCWliXZHV/pU6azYnFXPPbzoLLt4bPlv5rpLcu2qkrb7P8pR36EBP2RO2ny/3lWmsLS2QTWEGf3hrA==@kvack.org
X-Gm-Message-State: AOJu0YwWS6JElcgbap8DNV4p3FDprSzGxy3wx3MI7y/yUyybT5l2qyzm
	kSYZrYs8Kocjgzzk951so5jmWg4qi7dE7fAqB8vr7Zl4/Cao09Nhq6zy++czNdzsZhTG8V7zAov
	Tuu+yhbFEdE2G49R/lPZh2MVGIDR8iLUuWZf7ExFC
X-Gm-Gg: AZuq6aLaS1PveCVI846f9YPl+GE7+qjNR84RpdHDVujzD9qm2EuT9lmcP4KUcSHBSwG
	bmDhH+DtAysvl3tXs+bk/DEntL8kNpV3fidMzI4nU/w/DM4jYhKgfojSNJ0B8VPPK2Lh5093FtZ
	bIQHNCchRLWBqUcdBHRjbfC6yyN5jBn7PMDZXojUasuT+TJVmGju8nr6dZCkaT97Ii/Qu29SS10
	gN020mR5Ce8RzsLLzQpZFwqajgmbPiw+PEnEjUgHNhUtPUDeiiL1CgBB1zJq8d3QRfH8ySfCjdz
	AuhsWsYaghWNzXjLzUl+nuXq7A==
X-Received: by 2002:a05:6122:488a:b0:566:36e7:8934 with SMTP id
 71dfb90a1353d-566795c5856mr1161633e0c.16.1769557600050; Tue, 27 Jan 2026
 15:46:40 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 27 Jan 2026 15:46:39 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 27 Jan 2026 15:46:39 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <ce78da49-2525-44af-9cb8-301bf6a4658a@suse.cz>
References: <cover.1760731772.git.ackerleytng@google.com> <02aad35b728f4918e62dc6eb1d1d5546487b099e.1760731772.git.ackerleytng@google.com>
 <ce78da49-2525-44af-9cb8-301bf6a4658a@suse.cz>
MIME-Version: 1.0
Date: Tue, 27 Jan 2026 15:46:39 -0800
X-Gm-Features: AZwV_QjMPyTn9KuYIeoCwzon32JStKYHl7N-mpSbapwuTdPZlfrcWu1xEKHINOw
Message-ID: <CAEvNRgE07d_TaSVpkWO8gMfGgPsP9sBzrqMPCte8PET0THF=QA@mail.gmail.com>
Subject: Re: [RFC PATCH v1 09/37] KVM: guest_memfd: Skip LRU for guest_memfd folios
To: Vlastimil Babka <vbabka@suse.cz>, cgroups@vger.kernel.org, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, x86@kernel.org
Cc: akpm@linux-foundation.org, binbin.wu@linux.intel.com, bp@alien8.de, 
	brauner@kernel.org, chao.p.peng@intel.com, chenhuacai@kernel.org, 
	corbet@lwn.net, dave.hansen@intel.com, dave.hansen@linux.intel.com, 
	david@redhat.com, dmatlack@google.com, erdemaktas@google.com, 
	fan.du@intel.com, fvdl@google.com, haibo1.xu@intel.com, hannes@cmpxchg.org, 
	hch@infradead.org, hpa@zytor.com, hughd@google.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, jack@suse.cz, james.morse@arm.com, 
	jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, jhubbard@nvidia.com, 
	jroedel@suse.de, jthoughton@google.com, jun.miao@intel.com, 
	kai.huang@intel.com, keirf@google.com, kent.overstreet@linux.dev, 
	liam.merwick@oracle.com, maciej.wieczor-retman@intel.com, 
	mail@maciej.szmigiero.name, maobibo@loongson.cn, 
	mathieu.desnoyers@efficios.com, maz@kernel.org, mhiramat@kernel.org, 
	mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com, mingo@redhat.com, 
	mlevitsk@redhat.com, mpe@ellerman.id.au, muchun.song@linux.dev, 
	nikunj@amd.com, nsaenz@amazon.es, oliver.upton@linux.dev, palmer@dabbelt.com, 
	pankaj.gupta@amd.com, paul.walmsley@sifive.com, pbonzini@redhat.com, 
	peterx@redhat.com, pgonda@google.com, prsampat@amd.com, pvorel@suse.cz, 
	qperret@google.com, richard.weiyang@gmail.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, rostedt@goodmis.org, roypat@amazon.co.uk, 
	rppt@kernel.org, seanjc@google.com, shakeel.butt@linux.dev, shuah@kernel.org, 
	steven.price@arm.com, steven.sistare@oracle.com, suzuki.poulose@arm.com, 
	tabba@google.com, tglx@linutronix.de, thomas.lendacky@amd.com, 
	vannapurve@google.com, viro@zeniv.linux.org.uk, vkuznets@redhat.com, 
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, wyihan@google.com, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 7D91E8000F
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: chsd3yyc1ci6okg753tpuood9t4qdm5g
X-HE-Tag: 1769557601-872293
X-HE-Meta: U2FsdGVkX19oRm+6rUW0lSYJF7bTfPkFC70V2IQPSej1CQSVptUc5fQ7Y9FaC9ftagMdS+vBW4LAVhJrOdkZ/wnqnxpQ/SzSx7wHtJ0R+Iiftt+3/BRuZmLcD6lwlk88XTicAHFy5ktU3d7M/5u2JiJNeLt4yrvSAx5PdlmvvcckV4pCbLrDelot2eIGhx/1edJiQmVtTX+n36k6EWcjFUEJNGmKt44THKjrO1WMKqRehXNZIWARPOox6SJ+EfPWW/XWssQ0iEvMdQ9nwG9WQG8j/7PQUU6jpwmfvy5Gn+uE6yc/w/fo/uGyeTPt118fFPQ3I/aAl5L+ELbE6pYNB1L1S2/0F15f1KgUmCLZKg59V9ccVvQ9/cuJJbFHROy74T2bw0R1JJLvjHketMVwT9RDT+d1j4s153AwUOWny9BCa3r3iBDc3+QQn7qgCV+HocCfAllXWeUOlGXYJ3jn3vaV7v/FW+VLSgAMUWUMSYLr+pb3TsR42mRwhHVZ9Ax6QkWveMBp+0eX+Da2qqhSKISvd2UmB5Ypm2quMw0ep99MRuLvGYyqVKnUZqp6jaTm0XdOZYlLJB5fyu/uXeyHjojLZgftd2L0svT+IUY4qzEQueOHpG9ihX2ikemnlKCe5EwMSIX2uy/+9PFMYCciv6tkm9l3h6BOJ+Q29LH1uZUt1Rd3yDSDNeqb/xqupTr/IpIkStnSCfLrQxIsO0ynbAuOJrzDB+D3+Lo+z57XvLTheWr3mHFmGXyELUbmGNaO1B0qUm5ExItEOExDGIC5l4gh6VxK+h/WzwZijkv9cdIeeNxl2Y/+p/ZaqnAir3Q4jHyVOmkfH4fCpAlOj5xJDCdaVRRVHxKgzbow21SQvzvFJsb5aWJ18JB7694H/D5x22heuK9ky2vsCpb7Wss2/8FKCdB3mWTqY3GdpPChua41CzP3HFD37m9ElzYFFaLhVYiHtJYzgiv+HGlYS4Z
 06rtISg5
 rcyK0yo0hB3Qz253YUdKtyhXUFU2iuGh95ZmhsWCdKMXwpojeQ/OMdwd2RAzS/lYSnB2Su0vtZSkIiPlh8lIQfSf175KQMfC6jyuFPQJzrIgY8srD0KRD362QT9sRl2d4VSH3gsyuScTixpVJwsObdWf61c8kLFmdlY3e9lhmh5s6RK9ug5j/jPmnN5A3GU2JlFB4vAnIGCaHnWe6ZXg0z2sdPNA5bmehcnBD/LXqDrYSV0miQQJ/K/pp3mlgEgpan1I8UdxJBt8lf5I9B3n+QNUQcrFs+XbZnXuD9fFBV/29NoSiLI9PW8PVNtsfanyx/0xxblMgPmBE6E3HEmhP+HIGfZTISxJExDimTvUjMj32FbbUxhzegNEwPRuR+46+vLdLvAwRqstNhEoUh3ke5mIR08Mmo3tPGbaVWtNiUjTqJwSBTd2TB/2K0cZtPxeAolQCVmfn7oXB3sI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Vlastimil Babka <vbabka@suse.cz> writes:

> On 10/17/25 22:11, Ackerley Tng wrote:
>> filemap_add_folio(), called from filemap_grab_folio(), adds folios to
>> an LRU list. This is unnecessary for guest_memfd, which does not
>> participate in swapping.
>
> IIRC guest_memfd mappings are unevictable. That should mean they are not
> ultimately added to a list (see lruvec_add_folio()).
>
>> In addition, the LRU list takes a reference count on the folio. With
>
> IIUC the refcount is temporary while being on the percpu
> &cpu_fbatches.lru_add, added by __folio_batch_add_and_move().

Thanks for pointing this out. You're right about this, I misunderstood
this refcounting earlier.

> When flushed
> via folio_batch_move_lru(), the refcount is removed and there's only the LRU
> folio flag that remains. The fbatch flushing can be triggered if you see an
> unexpected refcount increase.

The new plan is, to update kvm_gmem_is_safe_for_conversion() to drain
the fbatch if it some elevated refcount is found:

static bool kvm_gmem_is_safe_for_conversion(struct inode *inode,
					    pgoff_t start, size_t nr_pages,
					    pgoff_t *err_index)
{
	struct address_space *mapping = inode->i_mapping;
	const int filemap_get_folios_refcount = 1;
	pgoff_t last = start + nr_pages - 1;
	struct folio_batch fbatch;
	bool lru_drained = false;
	bool safe = true;
	int i;

	folio_batch_init(&fbatch);
	while (safe && filemap_get_folios(mapping, &start, last, &fbatch)) {

		for (i = 0; i < folio_batch_count(&fbatch);) {
			struct folio *folio = fbatch.folios[i];

			safe = (folio_ref_count(folio) ==
				folio_nr_pages(folio) +
				filemap_get_folios_refcount);

			if (safe) {
				++i;
			} else if (!lru_drained) {
				lru_add_drain_all();
				lru_drained = true;
			} else {
				*err_index = folio->index;
				break;
			}
		}

		folio_batch_release(&fbatch);
	}

	return safe;
}

I hope this is what you meant!

> So it might be feasible to do without this
> patch (maybe it was already tried and there were substantial issues, in
> which case should be mentioned).
>

The patch "KVM: guest_memfd: Skip LRU for guest_memfd folios" will be
dropped from the next revision, and "KVM: guest_memfd: Don't set
FGP_ACCESSED when getting folios" is no longer a requirement for this
patch series.

>> shared-to-private memory conversions for KVM guests dependent on folio
>> refcounts, this extra reference can cause conversions to fail due to
>> unexpected refcounts.
>>
>>
>> [...snip...]
>>

