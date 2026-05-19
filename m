Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AB8ACD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 16:02:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 740796B008C; Tue, 19 May 2026 12:02:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 716466B0096; Tue, 19 May 2026 12:02:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62BFB6B0098; Tue, 19 May 2026 12:02:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5321A6B008C
	for <linux-mm@kvack.org>; Tue, 19 May 2026 12:02:34 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 22429C237F
	for <linux-mm@kvack.org>; Tue, 19 May 2026 16:02:34 +0000 (UTC)
X-FDA: 84784637028.20.02185AB
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf12.hostedemail.com (Postfix) with ESMTP id 508B240019
	for <linux-mm@kvack.org>; Tue, 19 May 2026 16:02:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mJD9TN+X;
	spf=pass (imf12.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779206552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7secWGcKkricFb3QwoZSGS7Stq5WOOjh1xox2jIG+wU=;
	b=FwQsQXg8HmXEmq65IDTSgGfOgs+ou4zjbNc/0sjFSozbK8IV/of2aRMXK2f2iYZioTTzPS
	kKJVRpq/5gpClDwpYBDWIs/ktoSMGscRt+pvMxpVFi7s446Rt1RB8pQprG2SkRV70PTDDx
	85FzCZ5rGD724hfegL+djZbfjYvkWnc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mJD9TN+X;
	spf=pass (imf12.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779206552; a=rsa-sha256;
	cv=none;
	b=WkXc4NRR9eHCidqN3WuzF5TJo82K1DL2ZEg4OKQiWRh19YMIAER+Z2OShvSlv7dNVEZJ16
	lSr+SlmNebrxPRfFqRkfS+r2VXY83bVbntfFKiDJayc/A0VccsPu5e75iu2soqghEU2wsG
	LRc58lbLAZPv7gwWkvV613SJqvGEC8w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779206552; x=1810742552;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=sVD9iOMyuDxOPQd6LH1AX+QOLCpwxGAoSPTso0dXrNI=;
  b=mJD9TN+XpZ+NoteQnoKbGaXC8O4M+VsVxe6SiOgXOsCKlmbLlUAz6z4/
   UwCvr2HMkhjAkoCcUkJ41P44xUtSYxORpikZIUhVg7XYMMamyBSimHRci
   gDDHz6kgcS9eG7sAgd4LHqcQxkpUQj7O02S+eX1gC51DVDAg0MR9ENNCy
   cKT/Ygc8HzEwJmrAVmve0JFblVEdhrCjmj3IrrkbkxaNPDRmwwR0G9Ugo
   ndajMHOXPrm/nhpsUNiKo5Ru46Y0Rsh3Afx7DPRc3wF1Ftqw0AV5zkrP0
   LDc9PanUK/Z9lBG2FElcxl/FwEJ+a/U5jQAberorXbiqZwSPAVSVF4tsB
   w==;
X-CSE-ConnectionGUID: qkQaJNK0RsOuunNS7LDD1A==
X-CSE-MsgGUID: HVyHWDIaR7u44hlJ8v9qBA==
X-IronPort-AV: E=McAfee;i="6800,10657,11791"; a="67618666"
X-IronPort-AV: E=Sophos;i="6.23,243,1770624000"; 
   d="scan'208";a="67618666"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2026 09:02:23 -0700
X-CSE-ConnectionGUID: ZMQsuowJTlStRdVrTb1PTg==
X-CSE-MsgGUID: vfSD41RVSgOsJOv4ILrdAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,243,1770624000"; 
   d="scan'208";a="233444490"
Received: from ssimmeri-mobl2.amr.corp.intel.com (HELO [10.125.109.111]) ([10.125.109.111])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2026 09:02:22 -0700
Message-ID: <5d00b63c-1802-450f-8e54-8da6c0aeedc2@intel.com>
Date: Tue, 19 May 2026 09:02:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/mm: fix vmemmap leak on memory hot-remove
To: Juhyung Park <qkrwngud825@gmail.com>, linux-mm@kvack.org
Cc: stable@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
 Jason Gunthorpe <jgg@nvidia.com>, David Hildenbrand <david@kernel.org>,
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Oscar Salvador <osalvador@suse.de>, Andrew Morton
 <akpm@linux-foundation.org>, Dave Hansen <dave.hansen@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dan Williams <djbw@kernel.org>,
 Dave Jiang <dave.jiang@intel.com>, Vishal Verma <vishal.l.verma@intel.com>,
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 Matthew Wilcox <willy@infradead.org>
References: <20260519151008.1399226-1-qkrwngud825@gmail.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260519151008.1399226-1-qkrwngud825@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qwc8isxz9qanntet4aprkosqcneiorkj
X-Rspamd-Queue-Id: 508B240019
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779206551-182594
X-HE-Meta: U2FsdGVkX19WaORBBwXpD3+LczNpPExMXvfMME6YX28xCaosCRbPeHhaUptI8fhWCqBtyVUBQ8JZZlVXV9KXp5TvgouRIpQw6d/0oZI8gHES92oRpVhzMpYC/UD8SQuQx/Le6hoYS0i6BjLNmyi8xT1NudnoFlgVI7vncyENAtulMC/1pDxqwbTFpyxyw8XyAjZYs4c1gwkKFhYJR5tGfw+rWSw8HJi6QOcUu+496HEbZTW/OfXSdmPzTCIJ9eGFwpcVsgHw1nLvHfx6gjvKP1ngkkhJjojHSoDRIY2ql4Nykfwk/xkCUgXPoR8Crmd2Rq/Wbfot7i7NFDvcxx5qKhjAK5jtWDCPXnFu6L4z2aRMG5uoIZQLjkFcV0OHqJxstpBuXCVqz5FWCaMoB7kO/jLwFvn3v/Q8AC+iz5pEiyzVAQKWexY/s5m5robRlunYBDr0YjOCKmQUNkj6e9B+T7sdv61ECCq1rw1BzPJSTNdxKXq0AJhgCKGIkZcWfIHXrBQwfwNJBGsCeCAkQBDChA3A9OhAYCOyCla/TP6KU7x81wi81/AjswDxutdY5iRh14arE2RzrMalQ1WgskCOxQzVo+hfGDgcwt90UDPMN0CSd85oDrmLAabHJ1am89xoJAhhJobXF5p/IKbHN6hnhaB6WnkPQ0CETV42WHley5l3IdAvDVgIqic5GCNmMbVqapOvMAZcDKIiIf0eVcYtsQmeaRISkiBx3PfuSsNUAkSDWJabHw/PRRcoEz1pU3+/p2VBP5ton04ML7QbQ+VeadHtSF7R7ds9fVJahaNXumFtSaxQLvZIgtMlS8CYyiSTumwsfAeYNezxRXXOAyMlxI1Zu5yUewmsDYlc6O5VnVoUAQ4AdGiHb2BG7Wb1tMVFWgWLoRDIRd0oSLyySTU0J02Uf1ousMDRCwwxylDAYpgO4CJ8eD4nUmBFq4aqpjbT+xa4jaqgu+T7WTOiFsy
 1jQbZSeD
 qNNnZLbg0mqLmdp5fhdD3OVq6f56XB6qpMXNt0RlbXv820PLT1bbKxGM8rrwlIMreBeIAKfDHpdC1+bdj2a+4boB8Vz+5x22JBlhQtg4mqQFWkDcqXdze0baF/Lbq1wkYanHfgF7mLGKLqaQJFzaC1M7FJQLGZlPI6C708YKf2gSAa9Nh8K0JzNVw1MikUFysAWB8HgDtsu/7jJE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/19/26 08:10, Juhyung Park wrote:
>  #endif
>  	} else {
> -		pagetable_free(page_ptdesc(page));
> +		/*
> +		 * Use __free_pages() to honor @order: vmemmap PMD leaves
> +		 * freed here are not compound pages, so pagetable_free()
> +		 * would lose leak 511 of 512 pages per 2 MB chunk.
> +		 */
> +		__free_pages(page, order);
>  	}
>  }

I find myself really wondering how much of this came from a human and
how much from the LLM. Could you share that with us?

We're trying to get _away_ from using the 'struct page' APIs on page
tables. This goes backwards. Worst case, do:

	/* vmemmap PMD leaves are not compound pages */
	for (i = 0; i < 1<<order; i++)
		pagetable_free(page_ptdesc(&page[i]));

Right?

Even better would be to *make* these compound pages.

Even better than that would be to use some 'struct ptdesc' space to
explicitly store the order, just like compound pages. But that's
probably not trivial and probably not great for a bug fix.

