Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C16F2C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 09:55:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B55556B0088; Tue, 15 Sep 2026 05:55:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B06BB6B008C; Tue, 15 Sep 2026 05:55:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F4C96B0095; Tue, 15 Sep 2026 05:55:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 831C46B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 05:55:15 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9B92B16034F
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 09:55:14 +0000 (UTC)
X-FDA: 85215538548.19.F6815DA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id B6F4F4000A
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 09:55:12 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=nT55uM6R;
	spf=pass (imf27.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789466113;
	b=Tsss2sl5USwuryXeTcfBdRdYpx1yAohE4MxYSc7c/Hq+refmAZtLn0x9FHvhrmEYienrUy
	ZG6LqsevDmvEvuXdqJMAeLJe+dqV9Rp4/NElV7s35MaWP8hTha5eQfqJjEBglrEYf1cz+v
	T5W0HBjYwMcaQNvE4BfaY8JoUNslOog=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=nT55uM6R;
	spf=pass (imf27.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789466113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jQ104mVg70Pm7jARX5uPqgqi2fRfOqcNVJhT3ISGlYU=;
	b=iGLMZq2pKKksb7XDxMp8d7ogrmAyiSmW/bKjs0Hksh5ugVYTphVBvP0y4ddMR/NYIiIDKi
	oPcRKOm16vK2P7kizgW4CQmtEVv5P5fsuW7U10qYrDqCRKaMRPFGsqbUqzpFmzeoBGVLzE
	ubUuF/iXzis0AKbVlRIAxgREw12qsG8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 422FF2F;
	Tue, 15 Sep 2026 02:55:08 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 456EB3F86F;
	Tue, 15 Sep 2026 02:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789466111; bh=l1ghniEQ93Ye4iFedobCshR6rPrWBA+Us5ebC1PJPek=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nT55uM6R8V9djaEveovbIJi5GECmcNNr8/CxGyfFVO+dy5IPZ9mm0pilhHcvT8Raw
	 IZ+HGhWwfvDDaiR3hD/oGdLBshAVdx4VOUbPkNX2pTOZ0qwKW1qN7t9wIlETGM4HJ3
	 TelznupwP65Jpm/hq05LEyc9Tb0mXV/AsW7SDkKY=
Date: Tue, 15 Sep 2026 10:55:06 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 2/3] kselftest: mm: replace usage of /proc/self/smaps
 for check_huge_xxx() helper
Message-ID: <aqkV-saU4BWbqu4s@e129823.arm.com>
References: <20260914-fix_split-v6-0-16ed7123800b@arm.com>
 <20260914-fix_split-v6-2-16ed7123800b@arm.com>
 <6c9727cb-6cfa-4d0a-b8d8-077cbeb5cf4f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c9727cb-6cfa-4d0a-b8d8-077cbeb5cf4f@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B6F4F4000A
X-Stat-Signature: kxrtsiqwp7a58tx98hk3ap5xgmzcr5zk
X-HE-Tag: 1789466112-340800
X-HE-Meta: U2FsdGVkX1942pLHik5Csl1zbV/BPJ6yACT/JI1r/bI7f+RPnLhgbOxpv8UaHNMrKoOx7rsEqVQYER9yaGjOBW/fehMYMbXDOcMQz40MFD0bLuCOtlq2fNPUQRKDFahD0CbB3cgodASdipyDswWA2gY3DdXeqaAPG+US0P+bFz39JPiF37eD2w9ARrzEEXX8tsO0c8YgZ8qHPwOX1b7Kx2s0SQwPa+Qj3yy2i5vB0goPS4RRnJDy0UDP+YrNqjcskAWyODBhjPoVhJqAejMHuiCDIr6MznwJIwi9xqCUsS1tt8XOhGVSpdvhgAqUTFncBuPazWxnULlvL51hMGszpP2VbcQhRIaDi5Lq5Nmha3j0k7wKgNdDSQgb/xYpPx/8xCILYsOIwuvbrjKE63+zh6gH5s2SBsdmUbu9Jaj1y+BmR0TofieTSXFA5Nio2wJIPv/ONcwX0K6hrN+XWa08+Tm1T2xid13KjE33jFdbgieu/2Ns2mp70JOzBnKO9ulVNygCRmElmi3s2nBmaFFhStU1JVBngq0xDsv/y2hGd9JcMFrQFwR1l0ZCmuLzEMSOi5b71ClrcC/JCpZIVoZJuYkguxYm1WzBvHyqaOvw/sknp2L5INDEVUncJjcgZMg5/nDxn05TEzkF1bhl+yvswu81ViarKDdjbFdADOAWb2LZuVVrNXI+r6UWBoKV4DNi21SERDUx7pcDGTMytXP7daTwB2R2lGmxz8qa8veR8eGMOZi/nE2FfiUA+gfUuzKv4BBuSsaBo7L2Aem/SEZP4UAm2Lan2liBOPLPBL/FmtlKaeUJi11M8dH7MjUajfa1QwlvCgCaMMeTdK/8bPgUKaQi0i3FLcrCzaq3E2sb2HXRvfWwNG8VF5AhY3zfDUIuKWnHpndMKAmYlIqMpjscMLDT5wzICjlWJRuXriVxlIT3bL4G9wvxlnuFX2L4kDXJtUz+ie+/4Ft6kjioD5F
 HWcm5AWu
 5bh9GSwF4p3H9XvlBBS/xQLeaJxCGTeDQ0kVaZM+Wno1v/hcYslEgCXBo0HamkpM0TsUcESw0UcXHnPGEhzdVhEw4fROmO1Ije9RWZcpTksQhxcWOYc6hpeHouwwnw4Js8crGbPqrx1vJpr/UN3ZHidzQPxXYOJf7uIlvabDrsMSxiqnpXKCg7YoBaHiUikz6ScALwv9FFP5wUNymT+Iew71N6Nde+OKaZfF1zACpsMLCFMZCvdTvJgcAJQv675YKv1nf4N0YbDNnuN+aYETO10J7LA2ayVNUNcHe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 04:10:49PM +0200, David Hildenbrand (Arm) wrote:
> 
> >  
> > -	if (hpage_size == pmd_pagesize)
> > -		return __check_pmd_huge(addr, "AnonHugePages: ", nr_hpages, hpage_size);
> > +static bool check_huge_type(uint64_t categories, uint64_t kpageflags,
> > +			    enum check_huge_type type)
> > +{
> > +	const bool file = categories & PAGE_IS_FILE;
> > +	const bool swapbacked = kpageflags & KPF_SWAPBACKED;
> > +
> > +	switch (type) {
> > +	case CHECK_HUGE_ANON:
> > +		return !file;
> > +	case CHECK_HUGE_FILE:
> > +		return file && !swapbacked;
> > +	case CHECK_HUGE_SHMEM:
> > +		return file && swapbacked;
> > +	}
> 
> I wasn't probably clear. Don't add an intermediate CHECK_HUGE_SHMEM. Make
> check_huge_shmem() simply use CHECK_HUGE_FILE and remove the function then in
> patch #3.

Okay. Thanks for clarification ;)

-- 
Sincerely,
Yeoreum Yun

