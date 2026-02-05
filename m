Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1B49ECD985
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 17:00:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D2566B0089; Thu,  5 Feb 2026 12:00:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 155D66B008A; Thu,  5 Feb 2026 12:00:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 037356B0092; Thu,  5 Feb 2026 12:00:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E308D6B0089
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:00:40 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A7DA859A1B
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 17:00:40 +0000 (UTC)
X-FDA: 84411017040.28.A3D4A7E
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf28.hostedemail.com (Postfix) with ESMTP id A7267C000A
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 17:00:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=A4wOBvr4;
	spf=pass (imf28.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770310838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J8t60eDb91XqoPXtsNUWKo++VUr82rAInktUECHQPR4=;
	b=Cb85qfTM1EP0mQG7yT+P80o8kWZcZZ5LLEkjDPQAUylw0sNNL3JjITVe8ybedBp/4F6lDf
	JMafoeKisri+oYSUWkoPKk9lTF4nwhfY4Ynn+oCbjcqT40hytg8hMgTlFy8pdh/wK76ukn
	BzuDHEfbouJYbi4SXONJrVP09p9dfsM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=A4wOBvr4;
	spf=pass (imf28.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770310838; a=rsa-sha256;
	cv=none;
	b=i6VI6znaNT6O88QPVAyGtypl3+v5QSWFVYxO/EeSEVXX+ISrUF3y7zKP2iCDL2MLe27lFJ
	iZW13TjvxJO4J8OzLqAOpppc7z7QiAz8wsUNrYKdyIpJM9rxt3xlK+Y8lHwS4dLVoaJcnt
	dAT9Qgxz3f5CBEYnAQdM+hv9Fc3O67A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770310838; x=1801846838;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9pLhFsK4nzGIJaAYaLfZsiDRpVWwRToOOMDoyd43otM=;
  b=A4wOBvr4ql2FgHCEULn4Tq84qln7V9iVsyxZhvPt8ptSWnVrmSLu8KaA
   7hlowmQ7Z8ZdqH7m0BSZdu1cs3iNHKBq5zB8mE2B6IM8WsoRigqMxkGGJ
   NZ1fTiA/vwTIHV4/Exq2yGWEwtU06SkjRphLGZFfkSF3hgaO1gTFiHaC8
   nZw93LG1Jo22Nhme3ZSUk6Arp4pqYvfbeBRiFJuvZtVbIbEuLb+67o4oH
   6n3arZ9gJQHe58aTmSYr8xZqP7nbpVzytS8Yy0ol3/1Xma4OlazJCwHWx
   COQZzM/O6MOpN2Vymwb3tyqmbohu69cUZXgvkkDEb6fLkaw0k2G9yzpH7
   A==;
X-CSE-ConnectionGUID: k1wqFsvtRGukrPEoHF9jXA==
X-CSE-MsgGUID: NjDi/TvsS0KP1QZv/vyYig==
X-IronPort-AV: E=McAfee;i="6800,10657,11692"; a="88936902"
X-IronPort-AV: E=Sophos;i="6.21,275,1763452800"; 
   d="scan'208";a="88936902"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2026 09:00:36 -0800
X-CSE-ConnectionGUID: SZ/zc+FZTuCLeQ/2VCBFhg==
X-CSE-MsgGUID: qZLHWbTlRJKp+O10ESL/Ww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,275,1763452800"; 
   d="scan'208";a="248191764"
Received: from tfalcon-desk.amr.corp.intel.com (HELO [10.125.111.86]) ([10.125.111.86])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2026 09:00:35 -0800
Message-ID: <1dfde42a-838c-4dc5-8ea8-0b501df37af8@intel.com>
Date: Thu, 5 Feb 2026 09:00:34 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/3] targeted TLB sync IPIs for lockless page table
To: Lance Yang <lance.yang@linux.dev>,
 "David Hildenbrand (Arm)" <david@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 aneesh.kumar@kernel.org, arnd@arndb.de, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, boris.ostrovsky@oracle.com, bp@alien8.de,
 dave.hansen@linux.intel.com, dev.jain@arm.com, hpa@zytor.com,
 hughd@google.com, ioworker0@gmail.com, jannh@google.com, jgross@suse.com,
 kvm@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, mingo@redhat.com, npache@redhat.com,
 npiggin@gmail.com, pbonzini@redhat.com, riel@surriel.com,
 ryan.roberts@arm.com, seanjc@google.com, shy828301@gmail.com,
 tglx@linutronix.de, virtualization@lists.linux.dev, will@kernel.org,
 x86@kernel.org, ypodemsk@redhat.com, ziy@nvidia.com
References: <20260202095414.GE2995752@noisy.programming.kicks-ass.net>
 <20260202110329.74397-1-lance.yang@linux.dev>
 <20260202125030.GB1395266@noisy.programming.kicks-ass.net>
 <c6fda7c2-ad54-416a-a869-1499c97c7bd7@linux.dev>
 <4700e7ba-8456-4a93-9e28-7e5a3ca2a1be@linux.dev>
 <20260202133713.GF1395266@noisy.programming.kicks-ass.net>
 <540adec9-c483-460a-a682-f2076cf015c2@linux.dev>
 <20260202150957.GD1282955@noisy.programming.kicks-ass.net>
 <d6944cd8-d3b7-4b16-ab52-a61e7dc2221c@linux.dev>
 <06d48a52-e4ec-47cd-b3fb-0fccd4dc49f4@kernel.org>
 <3026ad8d-92ad-4683-8c3e-733d4070d033@linux.dev>
 <64f3a75a-30ff-4bee-833c-be5dba05f72b@intel.com>
 <c985a8ed-37ad-415e-b7b4-18a66b4da3fe@linux.dev>
 <647cbe2e-a034-4a75-9492-21ea1708eccc@intel.com>
 <99237729-f2b0-4a7a-8213-65a2f1c57744@linux.dev>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <99237729-f2b0-4a7a-8213-65a2f1c57744@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Stat-Signature: cmkqwa136qzoxd19jqw1a4h865n9cbhy
X-Rspam-User: 
X-Rspamd-Queue-Id: A7267C000A
X-HE-Tag: 1770310837-540493
X-HE-Meta: U2FsdGVkX183C+MHnvaH7TxvzRcVr1dpqPRdylhocT+B1mr0gMRtMFkQkulG/mOvv23wMABTkrQ2jNTdNttKD+TOWP523YM/YEp359YBqK+q9kNQXevpyNwYOTzEVv/C+M244q90FBtCYCzcbj1LJICb/QTmpLrQA/94U19cwljyQwfdkS+DhcF4vSZkD4U68zOw91V2OTyBAgFk68uT2yi5oZmDmQuiX8Yct3sFAw8sualoZ/gJwsqO8MOfGfWiydusUY+SbSC/SZyYMYdcRi062gkZ8PStgHubq7XaT2rPqZeJYFMWpawM7dR7nAyrfuYV+iUT0H3+xRPI4V6wqROywiKU70QH6BMjAa/3v3M3OmULFxfOvoLCPNda82fK6kw2HHuHUKZH7lHrgE8ImCXxoEfpg7n7wGhk3fDUnmU1xDySj1Gmf4MEkZj8ZTITYwFvzVs00vrSyKY2JRbRi7v8i8V3OSA5WLon88UxirktDkVRJ95cEgL4xiPUff2AeBh7Y/oYUsX2Oonb2DnBlz27rfe7x2NIUPPvFwayDkAlWhnsy/WcR59L1SxmPCQw1yg+9HfQtNXq9v+prg43Y2bYSlCHjui0Q351UafFn5MnalES0hRJc9atvBggu3n5FURkngWYTlN1Ph/5zqMhveLYh+93BmLyV2WHsj4RmBvyNV5jr8aoefRArO8+hRBTLe6KJtR8MARME4R3EwmesA4HiBZi3M9+HOdHerlvUurOA+WxazL+JBHHXVbCKBkFyJsGL2s4eaPNnRNDCF6fp7yhrD+GWkhpqjTCswKrV32Vd/bTq8XbaXTHz+4zojVgKBbxLO9I4neExQ6Xc/CRjInUQ+Rh6a0YpXzYlxx5Fz52ugZIQjLS2T1ub+ksUSZGxOm9RFusured8YAbQ4CetC8S2iXQgCsM19zEOktQzPm8cyPm3VXuV8Y0bS2P5LRKQP48K8Ew4EPe8ra8a7Q
 YTjafN7v
 rPgYAlTVQ41IzHbHOoKMZKKsuG385HfTnt0o3y4SmH7+YnvZafLuXFwII+nhNLIky0zvQWkHfJQ8IgAT/7J/ihRpiZBG7e01YyYhTfEw5nTybJswpgQDAmu0e+OnZvu7HWgZLqk9v8Vt+y55XGGmainUs7PVWO9nmtvKj8s51dRmZ9vTUFS57Cl6eFML5IxwN22lR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/5/26 08:30, Lance Yang wrote:
...
>> Are there cases where ongoing concurrent lockless page-table walks need
>> to see the writes and they can't tolerate seeing valid but slightly
>> stale data?
> 
> The issue is we're about to free the page table (e.g.
> pmdp_collapse_flush()).
> 
> We have to ensure no walker is still doing a lockless page-table walk
> when the page directories are freed, otherwise we get use-after-free.

But isn't this already solved by the existing RCU freeing approach
documented above tlb_remove_table_smp_sync()?

This seems like a rather classic way to use RCU: wait to free until RCU
says there can't be a reader any more. You don't have to sit there and
wait for it, you just use call_rcu() which will hold off the free until
it's safe.

