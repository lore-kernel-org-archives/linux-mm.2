Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85CE2CAC597
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 06:38:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6EA528002E; Thu, 18 Sep 2025 02:38:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1F878E0093; Thu, 18 Sep 2025 02:38:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0D9628002E; Thu, 18 Sep 2025 02:38:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A97858E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 02:38:20 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5329513BB1D
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 06:38:20 +0000 (UTC)
X-FDA: 83901416760.02.1E2906B
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf08.hostedemail.com (Postfix) with ESMTP id B94A7160004
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 06:38:18 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GH3piuzu;
	spf=pass (imf08.hostedemail.com: domain of 32ajLaAsKCKYGIQKXRKeZTMMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=32ajLaAsKCKYGIQKXRKeZTMMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758177498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EhQgZCX3g/hqgKkVAO2ALoNMZAYeb5CdIihGIJQ0jtk=;
	b=ggLR49w58oMq0ZJjYMjWm1vsJ9oyYDRxxy/owFQ9Hkxc5C/rxOh+5J+2UQcL6yf/LlIeOu
	cZkuzCtq7RiyVMMIjcUeB4g7lC7thEO4zHkK1YZ9kEZNYyvwRyNrZflKv65EveStPCaRFQ
	aN+EvciPutObUcy3Jw9056L4jWW6oTI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GH3piuzu;
	spf=pass (imf08.hostedemail.com: domain of 32ajLaAsKCKYGIQKXRKeZTMMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=32ajLaAsKCKYGIQKXRKeZTMMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758177498; a=rsa-sha256;
	cv=none;
	b=hLWveyhu7urxjxDzoypPljWy/Gr5BM8rzXZ/daERf/g8qaup+XoBnqg//XHEBdRa+NOmCs
	5sqZcvlMqFdoTNIL/V47Z5K8GE6SlGTK3WEdgrCDMRsAbYpjq4HO91BkluRvEwvQBH/+ws
	EA8DXyoaXgnBXrOuU6FLXPXcKuJjy1s=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-329c76f70cbso496845a91.0
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 23:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758177497; x=1758782297; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EhQgZCX3g/hqgKkVAO2ALoNMZAYeb5CdIihGIJQ0jtk=;
        b=GH3piuzuOJVtGXzDNcwn3vYRMSkT4PhsQCmoi1Dfqxk8FROXmnq8DSbEIwYrvSYtLH
         5XO/rytqiIqUQvN2fhcfBdSzY/JHsqbNE4BKSNpjV8noveRpDXle2EVj8eozpH/Q8H+t
         VzL7Z7SzDEwY90VobCwCFlLQN1VuCdEOSnZyyPlf755wY07667aNwaouSe0dfjzo2gkh
         CLJwbRvBneh95y/eWByGfpdfjLx747JA7FUxKxGzDOx9yicGVDdlz6bjweUi1eI4O5EB
         BrZ7k0w0zOpWHGAwxRV4OM7anl1d10CpJjTzK6V3B3+catF6ijn6v/oiteARwf/UGiYN
         390Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758177497; x=1758782297;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EhQgZCX3g/hqgKkVAO2ALoNMZAYeb5CdIihGIJQ0jtk=;
        b=wXBdIhNLQyvEsvfdg9TuAWIHkO1VD3f+mEMIGfeBvfon2nc+4ibU14SQPdyu7g7BUL
         nx2dMUUOCTPSkmQFnzjvwisjRgO8QAwy3L1Nwys+/pAjB1+XA28Szm5TsJoTgj7iGMoh
         +IHEkW8sv9RvMWT6rvjaOuWvgbU7STI6g5mQpajgz5o9ZkzW3x/VoTxgOm+/sqLNyOpl
         r/gG2Wrq87kq+JqTxvgGI8vng4ewbEYba/8gDskRe7ppgNHAWPJoxW0Bd83hMjwUGKMf
         ldNkVdkYrLVwhZVqsqWfOYk3bRyMVNUOIGF4Fg5gelzfLu9sVNaSdewtlTykpZtsL7cZ
         ia4w==
X-Forwarded-Encrypted: i=1; AJvYcCVs6AeAow30sfxckDiUmoZ3oXD5cKUXmOXE4pVS/0kLmoG/WA0l83L63WxKOLRTzoAjLsy+4FrZGg==@kvack.org
X-Gm-Message-State: AOJu0YyLdt6IVR6zlbHQt6XQVMEumt1aC054lxdIPDRHwl8aBDmThdQa
	/3Iuac+6wjMC4bzLs9E8iyKd34ySs0Z8M8b7cXUPUBsuQhbhif4HpP+a+Gn2/CLgDfE2lzQF7F5
	lSMGbLo+uGl4wC/yZrEp99g1DiQ==
X-Google-Smtp-Source: AGHT+IHY8aUBQSPecvIOlTBaO7WQ/oRvPgoE9Oznnfm9prH3oA8ybxcIs1MwL4W0ClARcwmzZJztakkHVEY0YIHinA==
X-Received: from pjbpw5.prod.google.com ([2002:a17:90b:2785:b0:330:7dd8:2dc2])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2c8c:b0:324:e96a:2ada with SMTP id 98e67ed59e1d1-32ee3f2ffefmr5352489a91.21.1758177497343;
 Wed, 17 Sep 2025 23:38:17 -0700 (PDT)
Date: Thu, 18 Sep 2025 06:38:16 +0000
In-Reply-To: <20250916225528.iycrfgf4nz6bcdce@amd.com>
Mime-Version: 1.0
References: <cover.1747264138.git.ackerleytng@google.com> <b3c2da681c5bf139e2eaf0ea82c7422f972f6288.1747264138.git.ackerleytng@google.com>
 <20250916225528.iycrfgf4nz6bcdce@amd.com>
Message-ID: <diqzjz1wp8o7.fsf@google.com>
Subject: Re: [RFC PATCH v2 29/51] mm: guestmem_hugetlb: Wrap HugeTLB as an
 allocator for guest_memfd
From: Ackerley Tng <ackerleytng@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, linux-fsdevel@vger.kernel.org, aik@amd.com, 
	ajones@ventanamicro.com, akpm@linux-foundation.org, amoorthy@google.com, 
	anthony.yznaga@oracle.com, anup@brainfault.org, aou@eecs.berkeley.edu, 
	bfoster@redhat.com, binbin.wu@linux.intel.com, brauner@kernel.org, 
	catalin.marinas@arm.com, chao.p.peng@intel.com, chenhuacai@kernel.org, 
	dave.hansen@intel.com, david@redhat.com, dmatlack@google.com, 
	dwmw@amazon.co.uk, erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, 
	graf@amazon.com, haibo1.xu@intel.com, hch@infradead.org, hughd@google.com, 
	ira.weiny@intel.com, isaku.yamahata@intel.com, jack@suse.cz, 
	james.morse@arm.com, jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, 
	jhubbard@nvidia.com, jroedel@suse.de, jthoughton@google.com, 
	jun.miao@intel.com, kai.huang@intel.com, keirf@google.com, 
	kent.overstreet@linux.dev, kirill.shutemov@intel.com, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, maz@kernel.org, 
	mic@digikod.net, mpe@ellerman.id.au, muchun.song@linux.dev, nikunj@amd.com, 
	nsaenz@amazon.es, oliver.upton@linux.dev, palmer@dabbelt.com, 
	pankaj.gupta@amd.com, paul.walmsley@sifive.com, pbonzini@redhat.com, 
	pdurrant@amazon.co.uk, peterx@redhat.com, pgonda@google.com, pvorel@suse.cz, 
	qperret@google.com, quic_cvanscha@quicinc.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_tsoni@quicinc.com, richard.weiyang@gmail.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, roypat@amazon.co.uk, 
	rppt@kernel.org, seanjc@google.com, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	thomas.lendacky@amd.com, usama.arif@bytedance.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com, 
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B94A7160004
X-Stat-Signature: 9ypxc99oabe5gegkobg3a3f69ygbc4j8
X-HE-Tag: 1758177498-200372
X-HE-Meta: U2FsdGVkX18goo1rkjRkERBGvybdnzRIt5Ru4IrwboKwZNVefeok1iYThiJjz0U618GvPoRxGDnDJ1jQfXCnZJs9FEZcbbckzHcYXNMJ4jtlZWcv4VtEbuJetqUWFd1m/yYY8GfXbreBqfdsFa3So5KjodgteutStvwIdh0/7Od+Y1rbMQGp4Ag4HRi1cZemxS5FBJ6O0//RS1NIIaFyLe10QpkFUNFqurKOj1eRweFCT40K7mveHQ+SvfPVKuMYnv0XVRmh5ioS3Qo0O9vEsxg9HOi2L+2I0WrdA3K5F8rCTmz9rR4UdvrVyMKowf4YvfWWdwHozdjK/AS1yp7EFog6WEkgRJkhZJonzJKhQ4cdO7jTtbiNVIR87Or1WnxT4T7Jj4FkLa17OeeUFnvC/w9UV255123XqJ9A4DKQyJ321CCRCdN/0DB6VK1Czz5+IB/wJ2TJ6orMJAMNrUYqfYMA4BJnHP2zor++gGbd5Yf+4RZayk4XOqrCA04vOyQXio4POEcsvt5Oa8FnSvp2DPYSszOzqJryTtMm3F2t3KVDXrX/SYFzZ+XlzO+4+2CHAGCwEMxv49AwpGTEtQG18NcashvcSIXnm1wZL1o9qmpI+PvMHPSRyTbRKsmKR2WvZr+G5yi1I+iN2yDcjp+snUvVVuaScVxjY5p4rTHOTPRod4NGWdJmQ3hL42+ziiyRAErscIF/CElPxOGvO0Z6W8yXdi1nam5TKFMxo/cVvdMkph2SGFoxLyqlypQ2buBJMKlIh9lvT/tTbULO8wzDyKa2wXn0bMqbr0oPeZoP/X07unhG0v0iyych0qkOx/rmOL8JqYxufWcmm6jO3HxZRovSmWse3yuJmJtGa/xlj69t2v6RXsZE5PlgGlstdhOVbysd9YDlNze719o41HKhEgcdNrdDq2+UB/wnfFSONv7N+pn+LMoWPb/1zzmLDeDmvOjiJvxMKKF4GWQ5KNj
 gn87QkJy
 jqMf/IGynqlydKr/vPJT/W35A58+XOulDa+ZM1O4L0jViaEBt2p3Yzbn34/qEr/4ZIJtnTRtIgIlYBkPoMrNaepM/4Gn5Orstc7fjD+nUG/FpBr+PX7PWvUS6l8FCLzuaFgNg/3KBg68Qd90GPzg6+VbX/6UkIs2n8co/muY2HSIIIfAwuaJl0vEZpQy3Dz3eX/+PsHuY7Zip1hOdXDeXf2MQg44qWmWQJpHW4LSnIKf2sgGTNWv0XHyQPqJg2G1gObljM4fA4NEdgEAVEHSTxxNF1tvERH4Pnp6FU5sSBdpeN+LK+3uobDM2iV2FZH4AcyzGfTLP6RCHcdiBZuLoHxtQ8zPMpyvr989g3xIUqeDhlSJH8OTfIPPkucgfsVv6v+wMrVCP2W0ehhMdQ9Sjd/SqtR3vUWIqAi3luN20T0ZOfaAkBoB0zfwtsmeG5Ll2jGbW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Michael Roth <michael.roth@amd.com> writes:

> On Wed, May 14, 2025 at 04:42:08PM -0700, Ackerley Tng wrote:
>> 
>> [...snip...]
>> 
>> +static void *guestmem_hugetlb_setup(size_t size, u64 flags)
>> +
>> +{
>> +	struct guestmem_hugetlb_private *private;
>> +	struct hugetlb_cgroup *h_cg_rsvd = NULL;
>> +	struct hugepage_subpool *spool;
>> +	unsigned long nr_pages;
>> +	int page_size_log;
>> +	struct hstate *h;
>> +	long hpages;
>> +	int idx;
>> +	int ret;
>> +
>> +	page_size_log = (flags >> GUESTMEM_HUGETLB_FLAG_SHIFT) &
>> +			GUESTMEM_HUGETLB_FLAG_MASK;
>> +	h = hstate_sizelog(page_size_log);
>> +	if (!h)
>> +		return ERR_PTR(-EINVAL);
>> +
>> +	/*
>> +	 * Check against h because page_size_log could be 0 to request default
>> +	 * HugeTLB page size.
>> +	 */
>> +	if (!IS_ALIGNED(size, huge_page_size(h)))
>> +		return ERR_PTR(-EINVAL);
>
> For SNP testing we ended up needing to relax this to play along a little
> easier with QEMU/etc. and instead just round the size up via:
>
>   size = round_up(size, huge_page_size(h));
>
> The thinking is that since, presumably, the size would span beyond what
> we actually bind to any memslots, that KVM will simply map them as 4K
> in nested page table, and userspace already causes 4K split and inode
> size doesn't change as part of this adjustment so the extra pages would
> remain inaccessible.
>
> The accounting might get a little weird but it's probably fair to
> document that non-hugepage-aligned gmemfd sizes can result in wasted memory
> if userspace wants to fine tune around that.

Is there a specific use case where the userspace VMM must allocate some
guest_memfd file size that isn't huge_page_size(h) aligned?

Rounding up silently feels like it would be hiding errors, and feels a
little especially when we're doing so much work to save memory,
retaining HVO, removing double allocation and all.

>
> -Mike
>
>> +
>> +	private = kzalloc(sizeof(*private), GFP_KERNEL);
>> +	if (!private)
>> +		return ERR_PTR(-ENOMEM);
>> +
>> +	/* Creating a subpool makes reservations, hence charge for them now. */
>> +	idx = hstate_index(h);
>> +	nr_pages = size >> PAGE_SHIFT;
>> +	ret = hugetlb_cgroup_charge_cgroup_rsvd(idx, nr_pages, &h_cg_rsvd);
>> +	if (ret)
>> +		goto err_free;
>> +
>> +	hpages = size >> huge_page_shift(h);
>> +	spool = hugepage_new_subpool(h, hpages, hpages, false);
>> +	if (!spool)
>> +		goto err_uncharge;
>> +
>> +	private->h = h;
>> +	private->spool = spool;
>> +	private->h_cg_rsvd = h_cg_rsvd;
>> +
>> +	return private;
>> +
>> +err_uncharge:
>> +	ret = -ENOMEM;
>> +	hugetlb_cgroup_uncharge_cgroup_rsvd(idx, nr_pages, h_cg_rsvd);
>> +err_free:
>> +	kfree(private);
>> +	return ERR_PTR(ret);
>> +}
>> +
>> 
>> [...snip...]
>> 

