Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 637A3C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 14:30:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BAD76B007B; Tue, 28 Jul 2026 10:30:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56BA46B0088; Tue, 28 Jul 2026 10:30:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40F5B6B008A; Tue, 28 Jul 2026 10:30:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 17A3D6B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 10:30:34 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 819091603C2
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 14:30:33 +0000 (UTC)
X-FDA: 85038421146.16.41C10FD
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf24.hostedemail.com (Postfix) with ESMTP id 95CEF180009
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 14:30:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GNILmA4a;
	spf=pass (imf24.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785249031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Eu7g5oIvlAyaUuegAzG4Mg29YnsSZbpMobcMAXgcJE=;
	b=znYQW6EkeIcoFVNpxOcHCGy06fAxDzpzlEF1ZL8xc3qrZyPb4igXNrGEdvNuRtQksoPSyd
	i0cKMHddNKzdq1mhCokhkXYYGb4gnhLyTwgWnANoU1M3r+MpQ6ihQdE5eOSAI5/+yIhSs8
	kKmPDudNBNg7rQReMyPdvN/+7Nj5wfM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785249031;
	b=fW+UQccv0KLfvWiQVcPahE+TYX3KRQgKVm1mGqUE+Y2Zi7R4JV73rJwNYV8veqAbjIVHNn
	534yiH7+EGz9N1QDOoZDEqxMW0B/BtLPgSgHRjcAnUEImQtGgSPlGI8vYiu7ZYDvVNqU9U
	VarK9N0YWxEFQDJuCUPJ9BowGTZY1Q8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GNILmA4a;
	spf=pass (imf24.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785249031; x=1816785031;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7Eu7g5oIvlAyaUuegAzG4Mg29YnsSZbpMobcMAXgcJE=;
  b=GNILmA4aXtfY8xHkDWvlsC+91HJlhxAbSgplJp/r92xQJUobZ8AN4jXY
   3EJIpft5QqVjETcXwHvvl0DAb468Ls/B52cTZVNPdPTqIPBZVdBUaRr96
   H0kjBJsJ7X9KHpEpa9UgFH/Ze8lLzrs4o7x/XSC26BLxs1lHjpO6IrJRO
   l9o9U+/ZlUT9ff1HxsXhtG/sL+blZJtFXMpgkcsLG5jXZr29ZDGsX/NYg
   I0tKG41L8TJ6hKIVLIAZRhRp3yemL3OqeclM4zdurwtIqOaP76Dn9ZRJb
   vgKn6yYgJfr0H7CwqBgB5qXxnU3BWs706b2ZXqLDMXGBszrP/PZnwD05+
   A==;
X-CSE-ConnectionGUID: 64EFtO8mQW2DtGkhfMuHAQ==
X-CSE-MsgGUID: AGODZFkvRSCUbOtrU0bk+Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11859"; a="85916115"
X-IronPort-AV: E=Sophos;i="6.25,190,1779174000"; 
   d="scan'208";a="85916115"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2026 07:30:29 -0700
X-CSE-ConnectionGUID: 8Tm5Qmx+RfmTEH4MZMRbJQ==
X-CSE-MsgGUID: 6xOWW4bDQRaJ9K08Ri1piQ==
X-ExtLoop1: 1
Received: from dwoodwor-mobl2.amr.corp.intel.com (HELO [10.125.111.80]) ([10.125.111.80])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2026 07:30:27 -0700
Message-ID: <adfffb36-9943-4af7-a0ee-0e762e47fa11@intel.com>
Date: Tue, 28 Jul 2026 07:30:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] x86/mm/pat: introcude cpa_lock() and cpa_unlock()
To: Peter Zijlstra <peterz@infradead.org>,
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski
 <luto@kernel.org>, Borislav Petkov <bp@alien8.de>,
 David CARLIER <devnexen@gmail.com>, David Hildenbrand <david@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Juergen Gross <jgross@suse.com>, Kevin Tian <kevin.tian@intel.com>,
 Kiryl Shutsemau <kas@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Lu Baolu <baolu.lu@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Toshi Kani <toshi.kani@hpe.com>, Vishal Moola <vishal.moola@gmail.com>,
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 stable@vger.kernel.org, x86@kernel.org
References: <20260728-cpa-fixes-v1-0-2ed2352300b3@kernel.org>
 <20260728-cpa-fixes-v1-1-2ed2352300b3@kernel.org>
 <20260728142108.GW751831@noisy.programming.kicks-ass.net>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260728142108.GW751831@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 95CEF180009
X-Stat-Signature: sh5c9tgooxwpod98otrybsxt8aoi1im5
X-Rspam-User: 
X-HE-Tag: 1785249030-88206
X-HE-Meta: U2FsdGVkX18jqZNmKY+eZvdOQam3bF0vlVH0frCvB2GSB0+MVtT1oONq5mgVey8JNkn3P9WENX4tiUY7StTyiO1gug9BaXr+z+89SiGLXgxf1NN2WpGBsunvg3n78jXk8+CpRKPDfdouVqmcBXsQFCUzWu8tgaCk8iVN1mQjOnvTlBXtne8Yz2/8oT5+3X2cbwU+F9snYfGjHfInzebKJCwfoLTie1O3WwR6DD9b9seOFdKstS3DeC5TluCX0Fmosl0QOu+Kx+wBJ9t5m8UCd+Kvxmpks4VCTyos3VsiT+dci9s/ahPmNcpnDabl+5zhrdDDMtm1aeLc56opgohMq57Lxpi2j3OFO1C5GBntiEORDOaJzhseQRccuH58hkJMg/NytmY1u2McFrj4fUKNImOyvvJHPvNmKkru/XsF8P3mzB7OBh/Qvq1uexVPKVOM+ceJd+UZKDLYke8T+efIPFNFIzUMsltIy/LQAmtQBhdlUTyBpH6vc4a64vducan0WBkjidPe/um5cvn77OA+J0P5Hx/zk62zcOQq1dgh49Of02XqSD0CIa9OGJUO9htn+W7T/C/exet8Fb0+AzOo/ZzNPsbZBSc81gYNRwbrZ/CAUBbx546nXGnv/a986RqNUL/svxpuYma9EeOA6yf5RPttqbOvmKD5A4pv/edPzX83H69h3/qrfdwWT1Nc+I7QKmuCuOEnvX3PTT/NcrLGGBqyZ5Pzp8qpHgwG/Bz9hZtr5P7TaUN2oiqSFPb94I2dcW1pVCzfknfoHaD2GO8pInCPM+sun+bgPmTwR6Uh5GuN95uWkZHeX+MpBccAgkzHNauEamx1s36oh/e5TdKETBo8SbfnNWAc5bQKYW3EivZ5jCgSiV87vipV0k52ZgedUOeyyXJwEdsSrHUjNzwejxao4zpaCnfhtaa+iJkbJ7Y9YDLDMTRBgsHhSbnVVK6hm2EdITVp/Ebamqwqfnx
 Enybag0B
 +NkltaltX1ozVVbRcP2cY+TleY0TZcl0eO6hm4iMM0Qs+ShUhN/sibVv5IAKn7TnqFdubooyrFBkoXWRrP7V0fPAEML2wxFpzpb1ce9g2T98YtUTh0uTAFjA8FKO7dfr8g8rpn7e75E7CRKf94yDCDzXvZ3K8CwEUBnfLuSDSo8159PiLvZRIRLtiA3ncS33nm486fsatn/LhzId2M5gO/vClxaTUpYLMf3h5xWm18b5fZ26Uil1EJrhOlJJ+mbu8rgnHbYrd9Wonosqfx8q2F3vqzr0RfZ54qYuPRwi4+XqwtTk98yJJXTjV70lnxuBVDvwhmF7OHh0Iz/8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/28/26 07:21, Peter Zijlstra wrote:
> There was already a patch merged that removed the shole debug_pagealloc
> exception. Is that not better?

As I'm scanning through email this morning, there's another issue that
popped up with that patch. It's causing hangs on boot.

It's looking like debug pagealloc not taking the lock is actually
functional, not an optimization. Although, I hesitate to say
"functional" and would prefer to use much less nice words to describe it.

