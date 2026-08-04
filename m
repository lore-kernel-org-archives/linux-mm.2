Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 735DEC55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 18:34:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 385FA6B0096; Tue,  4 Aug 2026 14:34:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35CD46B0098; Tue,  4 Aug 2026 14:34:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 272706B009D; Tue,  4 Aug 2026 14:34:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E72826B0096
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:34:43 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5A944A02BA
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 18:34:43 +0000 (UTC)
X-FDA: 85064438046.06.ADF5AEE
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6E84980012
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 18:34:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Dlvu8VP7;
	spf=pass (imf30.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785868481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ScijXum+a66CRQS6+YgNdWWEeXvFLxmPU5tLv2DhgwU=;
	b=1SMLmnEIAE2Ty5+uIS6yqmfhh4+N+L8FWSO9FLv4kKpG73IuQ/P0NJV8jRpFQL0QZEl1tB
	SKtN7evqxzk3asGS1DN7vHqYkj/QEdUbFo0SEEEtU8OKkWUVBslmLx52MYhd3lkatFAkm9
	jd1u+sZSjd21lTnlp4KrHombhM8gD5k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785868481;
	b=ww1khKgsSnOciNFALss62eTuPMLzQUEqKfOBlkc8Hiqm+bD1XO2JVT9ozlmB+pIEbpxYTk
	4PeTb7kSf/F2a7jCdImIB+mu4Ez9xYXQAoz4eVKmnZsbensU3lYChKJDAyPu1MXjs17zoq
	CYd0jWF3tzTIsdr0x5iuxxWReK9Uj9I=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Dlvu8VP7;
	spf=pass (imf30.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785868480; x=1817404480;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ScijXum+a66CRQS6+YgNdWWEeXvFLxmPU5tLv2DhgwU=;
  b=Dlvu8VP7vRn1raDDhNX7zyG/ejevNP8YlHHo1Vpu7SQw3HvBe/5WkNOH
   +WVkHMNUgsAduhp5y/RE08I3zx/Fb5AUP4I4GmA/jF4ZEBqJxgTuOiXP1
   m7HWhtO2QFfsIbcAbHsvCkmp8SFeI0mX3VOqyamjar1mYkw3SxulQLLgF
   5ZFjS31LPoIXFiCT48vYKJlP5UMN3m/KCrFqEluPxWIJLyyMt4h96olVS
   +DeOeiYl9pKNSTA64+wtKDagXMfas2WV6IbVWX1SWkPLegOdJLaQKGHMd
   Q7UYwagQg9kFehV1w8hsNSPJ0MWvUYbIhzIPDwPjF5VmxC24Lm7j3DyWI
   Q==;
X-CSE-ConnectionGUID: VFCGYGtSQDOu6ZGdRdFpzw==
X-CSE-MsgGUID: S2rHZhBWQv2AeEqrvSsSaw==
X-IronPort-AV: E=McAfee;i="6800,10657,11865"; a="73966747"
X-IronPort-AV: E=Sophos;i="6.25,204,1779174000"; 
   d="scan'208";a="73966747"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2026 11:34:39 -0700
X-CSE-ConnectionGUID: p4vBjbm/RUO6q4yBdnmUmw==
X-CSE-MsgGUID: 0zuSxFFyS/yIyhCHGNQ7zQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,204,1779174000"; 
   d="scan'208";a="262167961"
Received: from jjgreens-desk24.amr.corp.intel.com (HELO [10.125.108.232]) ([10.125.108.232])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2026 11:34:39 -0700
Message-ID: <2ea2881c-7202-40e7-8fa2-f1c649c0d445@intel.com>
Date: Tue, 4 Aug 2026 11:34:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] x86/mm: DEBUG_PAGEALLOC musings
To: Peter Zijlstra <peterz@infradead.org>,
 Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
 Borislav Petkov <bp@alien8.de>, David Hildenbrand <david@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Juergen Gross <jgross@suse.com>, Kevin Tian <kevin.tian@intel.com>,
 Kiryl Shutsemau <kas@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Lu Baolu <baolu.lu@linux.intel.com>,
 Mike Rapoport <rppt@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan
 <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Toshi Kani <toshi.kani@hpe.com>, Vlastimil Babka <vbabka@kernel.org>,
 Will Deacon <will@kernel.org>, linux-mm@kvack.org, x86@kernel.org
References: <20260729110807.797920433@infradead.org>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260729110807.797920433@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6E84980012
X-Stat-Signature: fmt9gtgbed5ci35nj5m1buh1f31wirea
X-Rspam-User: 
X-HE-Tag: 1785868480-915015
X-HE-Meta: U2FsdGVkX1+7NiGGI8heJgWFQ0/X9x2pSnPYtQCjeB8C681Xw/R04gdjQawf3Sc6SzkYLaXIV2Xn2uZyC/PHzVGlE9M1r6lOepvBN1Ml+A/vxQxRdrdZgLUHiS2vkemwBP0get6iEdrBxaKFCSVzvMIRcWNeSOKemp1Q7+L0d042zCuqL72gkulosERX62VN5ulUkeXHLyLhxcDNWxhW97AnTjy3QWECmt4HBH3yO2cTCI9iYdAJlCgXxJLtDNl2/sZ0NZyUrkVAx+y6h28tsjYGvEynrwYXuRxNL3M4E+BMBkJBS2kK+RMnKy/aUbtFYbFVivA9MoSo3OddR97vShLDMR0KTAlq6jbBOkYwD2rfeG5jMBt47oTX8yFCvNyNkmcSa53ZWFKKfar2itS3CWbqni5pk1wTJlcU3rDKEnido/u1/y/UcUsBVeoodc40Fw4OYWXEnphq8Qcpc1Ti0J/EKbP7VKVOHPhVJ3N6u5NH5sKPUlxaaueP8pVSkUMy4As0FQzavQvQhqm9vHVMAkjidyezQdjWiKXAQu94TNKFNVi2wGN2KAUQsWL0R1cBI9VyVvLyoDiQRuf6kM2TzG9ZklShgUqZEwDHgDPmRHcMiCesOxZSc+QeaA+kuuoPZB9QTyc9drUiNNdz7+eRxYfSiwb2WYT3S1qwxcp9E7P2FjBC8B/ZC8b6AWc6gnIGGMSN7ub0v5dwnLfEE9OSqKOHYXskWB/pFyy6TipkoLvpDx4WBIs7qKeLS5bifpEL82B/OPIL/+Ri1v1EKmqVI7/ccR8e+Z/6ulIVNh4N0hATsRTe9pyBZvAphecYtOxStG3YCrEtHASX6m/8o4i5VNxS7fGIBbdQNOgwSg8Y/q+Nly+EAkhH5U1yC4rfOO7N6Kzo6L81qKnjKiNcpGuVnsJgesFQ53zsCf9YslAzTCZKYfIjBRzwhFOE37NQGIwIGt+bTs5BuhPqQwhxnlg
 ibc1OzJx
 HxL8PRB8wIG5egvYIXsEhbxRBTeihdSucv5QaZjpVf5tr5yXeITNg/kTTBtsUEy6RIv45s5thP4XFs9dKk5fulbx+yXW9ghCDdi4KOhQMA2VF7uR1xoODwlavnAFWfkZvDXWD961b+7Lx0zOVAK3XG0ZO6Uvn+OEiK/0H9brDZQCTNdS6CbnAf09lmw+7doydFEPIPrZ6CvYIUSIAlTlw0tGFLGYdJFYq3ExlPkW9Kw7A5gMXuBbnzz4ZCKsWO+IQcp8m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/26 04:08, Peter Zijlstra wrote:
> my take on how we should be 'fixing' this DEBUG_PAGEALLOC thing. It appears to
> boot in qemu with debug_pagealloc=on and such things.

The approach looks fine to me. The only thing we might want to do is add
a warning of some kind in the split/join paths for CPA_DEBUG_PAGEALLOC.

