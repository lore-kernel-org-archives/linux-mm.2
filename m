Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 632FC606A32C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 07:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=lgdmGyTL
Received: by kanga.kvack.org (Postfix)
	id 85ED76B05B2; Wed, 18 Nov 2026 02:00:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80FE96B05B3; Wed, 18 Nov 2026 02:00:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D7BC6B05B4; Wed, 18 Nov 2026 02:00:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4B0AB6B05B2
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:00:18 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 92FC1120501
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 07:00:16 +0000 (UTC)
X-FDA: 85447340832.19.DA96C85
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf24.hostedemail.com (Postfix) with ESMTP id A86E3180007
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 07:00:14 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=lgdmGyTL;
	spf=pass (imf24.hostedemail.com: domain of chris@chrisdown.name designates 209.85.215.179 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794985214;
	b=r5r+v4Bd6qZBuyANnjxOaNogPeM3xbYiN1USGUPOb2eN37dACYC+6WfxBaJerG0cqEZdA6
	QcIL5dxjqgHf7fiKLH26NcieYkKkNXjf1ShaKVNnITea04CZnyobS31KPrJk+uF2XTOUeC
	p555MJluQKCD0Pg8ertNURCHJognRe4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=lgdmGyTL;
	spf=pass (imf24.hostedemail.com: domain of chris@chrisdown.name designates 209.85.215.179 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794985214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0V4gHLbmmxLCmFwABtKMRTJRoH0Xzn0d+2gsbwvgOkM=;
	b=mlGvIh7ZhlyuxVcmDWPmbZlzSV753CfcXyshosCr6/PEuGo6uBS7ZXbAr+eUK62z1wcziI
	0H5W0m638LSlld1IOjOjQs6tHWSb6LBmhGqrtqd7PnDOVSXqbGIJKMdo9FD0wXb02jlA6M
	9N2RyjI/9wCXe8pj9z3LZyC+SHkwROw=
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-cd62c570b5dso538063a12.2
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:00:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794985213; x=1795590013; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0V4gHLbmmxLCmFwABtKMRTJRoH0Xzn0d+2gsbwvgOkM=;
        b=lgdmGyTLDf05vL997/OIs4dlTXCJltk2nIyYN/8hLBgKxpdtf4LRoJrpuTt0qnSj3c
         FoNjcHzHNuYa8Wqrt4rIQIuLxpQp3/53Ys6N1+Ct+8sNr4xvRMfPFjOO1XwKFSkRwJJ+
         oW+PLFqw9f/NPa11pprwuyLLlvhoOuY5Xtdts=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794985213; x=1795590013;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0V4gHLbmmxLCmFwABtKMRTJRoH0Xzn0d+2gsbwvgOkM=;
        b=HLT76clR/7G+uza6g7OjB5mY7OUltAmtz3H5lgpNKy+61ZYvKRylcIk6ihR5Ajb1Py
         EIRI+m2aYPSywaPg3/Wuh78QSNOt5ACLTbqB3vw+Ewfw8UQx0gor+u45G4L+VbXuw62T
         EpEXFciHDFEBFxL3WyZBUgtCMJNkHgBYnIeTElhC0zRtiVYNZ9M+F/0ttn7+bhxaLEqQ
         h3CbRGIDCO6gfy6WfdINHwH7VSyZS9GjIF3RL75iuhn3z/IeAcCpurEkYn0ZqAmCwf2w
         wo5r97PD0IPExBWN8NbVR84Smh/H1reewYAXwjF22tnHADdkG5GoHxsC3KwUSGBOTo1e
         2Hrw==
X-Forwarded-Encrypted: i=1; AL+hErHc6tyVMyKkDqSE7RRPqUm6Wv09tOBK97mtXNPBsg2hFq+TNXzLQzQFZbPLYRKvILtLAGCGv6vcQQ==@kvack.org
X-Gm-Message-State: APuU4Z9fGpeTh/37Tr5vvtqaiJB7JlxNECgcrNw9NpC0qZbjy6ev0FnF
	4mZLBcP12UH663acyiVI1FMVSsvOmA5JiENmGYBTPWr2zYgKlN11tCCRjonT4Aabw7I=
X-Gm-Gg: AYBFou0qghsGUvIVQpFRxnSkVOXZ96R1pz52tiiYvkJwxdNB8JyvCU/eKimjgQPrQuq
	ITLNwyT+qQEVFt+k9xTgpkMZNgNsrp3fJREiZ4de4uVQq4BcnijgLBiviZb+aq6rcUxVdVMYXtv
	AeTh8PC/qOWdD7XS+2h6oDrWAJa8NkM/C3MEW+ep3IcMsjJSkMGh3sj/5K1HWQzu70bosiF+f3e
	XXYdaRfbxjM81ytdcXIM4ZRVRbZa0kax9ZbMyfbI6Of2k1EgL5cmZuhcDn7dhLW6zxbu/iShYrP
	RcmhMmgaY+aPYD6rG0hAcSQGgSuYxe60H2BalHN7XqYEkHSGb7sSvjTW8/ikLfbuAyCrcru8kcB
	Iwet572ii6Z/P6vxMhCbtlDaTROMKspPgVN3paJnh4NdTo2Fk9hMtSCwXyJylG6KXvdLSyCPA9s
	/0ZwQExDhm2fqk84zrUD4VaiomUj5zUlfW0tMnB6/f4yyatbpYV5Gcp1hu1Qjq9TbJliJCy2WWq
	LtGeDLvL6eP8cjaavGPytcYv+MZOsfj4EfMZMpV53qNApwGw3SgY4HDUCj1prnlt41cSSrY2XEq
	NKFBPv3FaVkcjMMk1+eRde52PTgShxizOBwqwv68nd9mmZWBTGA3GxBAUT8LbWiA8KZQAK2QHUF
	2io61c7Q+W8ryI3LNu6GFqVriSKDDTTxVNWaBJs23jM47ABf0wHv/fYqp7TUAzDxnyilNzSWRoe
	DZuCZnN55oGLOtPAVgj1W76x81Z623dE6e9XxH7SenmfvM85mKwgoBKdnVvEheCuFY
X-Received: by 2002:a05:6a20:6a26:b0:3e1:8890:8400 with SMTP id adf61e73a8af0-3fe892fd632mr2082401637.15.1794985213105;
        Tue, 17 Nov 2026 23:00:13 -0800 (PST)
Received: from [172.20.0.2] ([172.56.235.113])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde3c4bc20asm635004a12.27.2026.11.17.23.00.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 23:00:11 -0800 (PST)
Date: Tue, 17 Nov 2026 23:00:06 -0800
From: Chris Down <chris@chrisdown.name>
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>, Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>, David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
	Joerg Roedel <joerg.roedel@amd.com>, Lu Baolu <baolu.lu@linux.intel.com>,
	Pranjal Shrivastava <praan@google.com>,
	Ketan <ketan.kishore@oss.qualcomm.com>, Mostafa Saleh <smostafa@google.com>,
	Sang-Heon Jeon <ekffu200098@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>,
	Sashiko <sashiko-bot@kernel.org>, kasan-dev@googlegroups.com,
	workflows@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 5/7] mm/page_ext: allocate page extensions early for
	SPARSEMEM
In-Reply-To: <3C50E682-848F-4788-9238-923D5E292DEE@linux.dev>
References: <20261117120627.50601-1-songmuchun@bytedance.com>
	<20261117120627.50601-6-songmuchun@bytedance.com>
	<avzsFxVqO27Vf4Db@chrisdown.name>
	<3C50E682-848F-4788-9238-923D5E292DEE@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <av1M9itGiTF1Akqi@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A86E3180007
X-Stat-Signature: fmfpajumpueo9yzu1gs1gwojjkfgrqq4
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794985214-487631
X-HE-Meta: U2FsdGVkX18zsvAg7l4t81PapZYvx6depuYXPZJS/OZTe4m1Fizke0fv2s+RdM2IOJkD+oGQj9CgQo+AreUU4ieS3e9O7vXJ0FcHs/a3T0gbyPKZVgiNFzGnx6fM/jTCPP7FNupjtoLTJxCVpIFSgc0ZPvUpcxwVmMV8WbwCv4lPaDGhlINWwKyYZCi9myrqzABRgpbPFXBV0DbSteB9vin76AoYRXNPBCJ1qAHEgD+1d5M2sGh0kF/yk3j3r8nzzdei7bo9kMWP4zkcobo3ABJF2U96y5XtU+N3apE4QtfWBsdwvCD8EIIRzFDlY5B3VVy9PSwb5yzKkH2By8edB0dfyrSzn/3w/t+WX7FGYWTBehbTmeDyPkBtfaIPMhY9o8P1O+cl27JoEtIW1kpFvAGSLJTtGEz1XfMSipvkB6MG3RcEIuZ1SR63buLdUn9VRcvNUAvE4ITcwv+VULbC8G8qrtCWAU0lkzBBaIjTjyaZQ/IWKmTxOBxpl/XAgtriGfyzvbrbEnvq8gS+QPHq2bsa3v7wN4pTqvSBeeM8PudhifMTVcj0EO1OKG0kh5Q+o1RBHkcCotvf5ORsXPSizYQIlNBMPoAucP7OKiPQYEBE8HapMwHYbzcIP+NoZb79zb04VIzDOlRw6pLxC8odlfa/2283w8yc7e5gbY7XnR7iZs/rGurX1nim22ylzLP/Pos7jeUDECg8/9Z2FPE4JeFqafIQSm1Yxat78jovCVcqjn3nwnhdhbD5kzHjquhOdycli7qua4a3vOtTGbs41CSmRoUa0o3g+EXw50mxSK80BG+aSTQ7KYSOW3iWbNm5bj+5VsjPiAHDPtqlLMz16il4o3Z9t7QxKywCqjBwmvNmOz2FOH9y898MQafwYuzgihAIvrH1vpHjv03sOB03WDTaRaksKrIOkhjjmcVrtTEr2pBimzOThKTl6PbRK9CHZx1h9NjxfDWT3gNizxs
 hms9Bh4X
 56iXXNRqUo0ejJPNqbJsKCH+TjKsVLYbjyBezKlrTIWHosdrz3zef6ifqScjTpgmyuxzpubeZCbF3zsZ2q+1my6HPRnW56VQA4VlQ0vIREH+FN1OkkttlnT50ATmtuLroPs6inx2mKwSeBibGodPJ193CHDr3zSwF/xP0+tqF2F/EYYGNTYCQTJ9FFR03KHP0iwIzYs1H8ecDoNcgQzEder7J/oD7oimFsZm4q2p2X6h3Z05tat/1ZWiPZvbloCVUg01DVpstopOllBrl2QOXnhgirdSJ3hGSJbD5tAsvWZFASuCzVudPPJJg98GcHvuCX/tKUw6726CSIliecFdXCgnbZeMwXV8s1NnmuJGU18lhNUWHo62C6+WHaNarej4GOVvrwmLNgPEbwqD3Z/gOrxCQIotMg0kY2Mc5LjYu06X22aP5pm5SFaFqeyYD1O8R21kmyAISwlS8HcSPA0YSmtbWLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Muchun,

Muchun Song writes:
>Mike's suggestion considerably simplifies the code, and early page_ext is
>only needed by optional debugging and instrumentation users. I would prefer
>to keep this approach.

You're probably right. But can I cheekily suggest something in the middle
perhaps? :-)

Given the zones are already set up before page_ext_alloc() runs, perhaps
you can pass the start of the node's ZONE_MOVABLE as max_addr to
memblock_alloc_try_nid() when the node has one. The general idea is:

     struct zone *movable = &NODE_DATA(nid)->node_zones[ZONE_MOVABLE];
     phys_addr_t max_addr = MEMBLOCK_ALLOC_ACCESSIBLE;

     if (!zone_is_empty(movable))
             max_addr = PFN_PHYS(movable->zone_start_pfn);
     addr = memblock_alloc_try_nid(size, PAGE_SIZE, __pa(MAX_DMA_ADDRESS),
                                   max_addr, nid);
     if (!addr && max_addr != MEMBLOCK_ALLOC_ACCESSIBLE)
             addr = memblock_alloc_try_nid(size, PAGE_SIZE,
                                           __pa(MAX_DMA_ADDRESS),
                                           MEMBLOCK_ALLOC_ACCESSIBLE, nid);

I briefly tried that and it seems to work quite nicely.

But I don't object to it even without that, so feel free to add either way:

Reviewed-by: Chris Down <chris@chrisdown.name>

Thanks!

Chris

