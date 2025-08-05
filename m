Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96D56C87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 16:00:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9B6E8E0007; Tue,  5 Aug 2025 12:00:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D72C28E0001; Tue,  5 Aug 2025 12:00:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C88AD8E0007; Tue,  5 Aug 2025 12:00:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B81368E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:00:47 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 060325678B
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 16:00:47 +0000 (UTC)
X-FDA: 83743166934.18.7A21D18
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf15.hostedemail.com (Postfix) with ESMTP id E6B5CA001C
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 16:00:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="e/xTQe0/";
	spf=pass (imf15.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754409644; a=rsa-sha256;
	cv=none;
	b=gQmVF1ZUrtajdYCNWsU4a44HnEgWALjMM4mMXzIPX5bslKzjQUQU2ZQuI3fv52Nn1/WXRa
	IuJ2YcJKzSpsmDlfiZQfzgJ40a68W3Fvsm6H3nvL/i5tEyIvx75zJxW6ZJaYQ6U7ieEO/g
	AurR5xUhA3e3LP4yJpaMECOuLJBpTNU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="e/xTQe0/";
	spf=pass (imf15.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754409644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M2YtucqNGx2YsjI76mHZf+3Hm3gOJxCDQ+hE8UN2Hkg=;
	b=RO/fs9iMFgLUB0v07uCSlm1luCk3LtvHvLeDHMDY0Cs1D3aEuHsc0LxOA/JEve1kOnM/KS
	xQE4dY4i/bHEpiFazdPrP12d63aiHHXW2gXk5gnwlcZeACRI4UNwDg7NeNd73W6lkesLbM
	tP+prs9hWZ8i6pHcMXqL3abYRn+ifH0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754409644; x=1785945644;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=M2YtucqNGx2YsjI76mHZf+3Hm3gOJxCDQ+hE8UN2Hkg=;
  b=e/xTQe0/nnNykL/VJJOhzaP6SOGC4Lb6ay5/2mT7PHYZUCRaxbma5qi0
   SLajP4gF3NXXxPJFGcW1xFuatDNrW8flYwdHj6Tn9lH7J8Y0zto1u+3Wn
   /l8OL6+fiKywjXQKtGtPlPPMzZ/puP6J5dKIcpxPu88jct7811Ra2V/wg
   e/RLYXul/z8uBn145NTUFDP1+VUl3dEqNZV6sT1yHp/Pv67WC/39LdtqK
   vqtBH0k0Fd0imLxm2/p/CBcvaXtFFWfHdtZDdg/w6boat/Gc8G17UuV1r
   IvTo54h3dVXEX9MtQEjPMN7vRqIYr4AEmLyGjamUy6gXcX9Q3pY0J77KA
   A==;
X-CSE-ConnectionGUID: 8kw5LkASQwWgmxU0+jA+Cg==
X-CSE-MsgGUID: 8cXkeyGhQIKzR97T88Ip4w==
X-IronPort-AV: E=McAfee;i="6800,10657,11513"; a="60524269"
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="60524269"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2025 09:00:42 -0700
X-CSE-ConnectionGUID: +Up2vnUySYqq/0HXS90B2g==
X-CSE-MsgGUID: 6LXLbsqVTACJt64tAxMK4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="164852041"
Received: from inaky-mobl1.amr.corp.intel.com (HELO [10.125.110.106]) ([10.125.110.106])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2025 09:00:41 -0700
Message-ID: <c3b0adc9-e8e9-45ce-b839-cb09dcce3b50@intel.com>
Date: Tue, 5 Aug 2025 09:00:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] add static huge zero folio support
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>,
 Suren Baghdasaryan <surenb@google.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Borislav Petkov <bp@alien8.de>,
 Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>,
 Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>,
 Mike Rapoport <rppt@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>,
 Michal Hocko <mhocko@suse.com>, David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Nico Pache <npache@redhat.com>,
 Dev Jain <dev.jain@arm.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, willy@infradead.org,
 x86@kernel.org, linux-block@vger.kernel.org,
 Ritesh Harjani <ritesh.list@gmail.com>, linux-fsdevel@vger.kernel.org,
 "Darrick J . Wong" <djwong@kernel.org>, mcgrof@kernel.org,
 gost.dev@samsung.com, hch@lst.de, Pankaj Raghav <p.raghav@samsung.com>
References: <20250804121356.572917-1-kernel@pankajraghav.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20250804121356.572917-1-kernel@pankajraghav.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E6B5CA001C
X-Stat-Signature: j9bz5f3ejh5dow9fhu395o9auizsu5ht
X-HE-Tag: 1754409643-971153
X-HE-Meta: U2FsdGVkX1+vgT5nQpY1voEAjpm2ziDNcPsjULuCwZr7xlZSY6LT9f52DanazTKqSWEi5xMvNZfr7QFDmaOEbudXsw3FO18536Fa34CAB+qGqCAD6/7cMDm2WsQwRw9lkNT2893eqAZ2d8nqXig58n7o2xJA6smixKumcSGdwBap5c1+iUA8P//W6cPGNGoooyoSMK+OcOb7jMWIHfW7AcvaXT7ouCogQg88VgcAMPOiNvCgxv0qchrJ/QFlWXwAsRVLgVYDCtm1U19aG3NJFRm69EcogQyg3dKthDnfF9Jlg+gO6c7UGSGeFR9/Eme+bS5ajQhFqHpZQTnG5Q+5loU2PGh6CgDME0iFZvmSlFqhOpcJsxtMAPqUoyMn3upt1zJuUjbXm8OHQVttgfYzCSqIenTkT3p1ek/mo2OJCmn4rToXPx1oWgy+on2KhbZM5ELHcOPkHcTjxaXmJ/DxdjaI2Aq84QdFN0SrjYlon7yLOm+y6MSfSpW/0qWFkT9OtROQSGGyeSzo/IEzoalP4USil1s0M4T8JuDhoJX6QJ8h7OasIyb6NbMWaAFBTvqH1H6gBupevvVzH+YwpQiqesWPUEI1X7ZQSXsXmQtlbS4buqB9pe+Oc6+5HHnHRRlWQ8tBFHppn735N/rXwq4BHWckFKM32fSqyJxSkSlNOmYc/GVcaCkS1ZxWaAfX81YwCOHg7AER2kQnNDFCdQoT7xhjEej2ePldiUmvkfxS9BeQgmDyEKPZe6vXG59raEfa7JPh0K47lhVflu1Rg6FV/bPjGU2fP+N8HO6ieY+nSKouH9WIbWZfyFuP5PxyxAGpGp+/wQzZKGjOHfVRLlfNBmu8xOyC+X7q9IJnH6sQJqnajEXXUITHEdV9DHb87DdPC4OdBtMitY6fhTW146p6+5BP4jO+j4DGZn0TP25MiM0gM1bX9cM4Ah4R/pfiMndikGJi1lYeOOEN2uO5AsC
 BGWrhCZ3
 FIGxnEtel85Dhpic5g2FmIM1aXC+M2ljcbZKVDfg2okcSrYsNrSSZ6oRsIXb2+/zISB+33LDV+toEF/RtEJ7h1L0yAWtEZeqwVfja8PqK6ttMlhoWZzjQxIjI9qnbyFB9527ObA5Mxh3tIfu/vjFINKVEAfU3olcR3nStnu7Mr09fvs89vhou6FvUxtngNy0K3xY7oZOaMtcm9ijAtNI8MBm0MovH46KV+Z60d4Vt1tPRymN2yQAxsx3alCOh7nipVqPnl3ExD2vEhW69MV+wxeAKXA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/4/25 05:13, Pankaj Raghav (Samsung) wrote:
> Add a config option STATIC_HUGE_ZERO_FOLIO that will always allocate
> the huge_zero_folio, and it will never drop the reference.

"static" is a really odd naming choice for a dynamically allocated
structure. It's one that's never freed, sure, but it's still dynamically
allocated in the first place.

