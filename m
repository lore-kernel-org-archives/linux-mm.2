Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EC5AC98304
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 23:07:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 247F26B0095; Wed, 23 Sep 2026 19:07:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21FF86B0096; Wed, 23 Sep 2026 19:07:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 136FF6B0098; Wed, 23 Sep 2026 19:07:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E03AD6B0095
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 19:07:08 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5A59080179
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 23:07:07 +0000 (UTC)
X-FDA: 85246564494.21.9DE4695
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf03.hostedemail.com (Postfix) with ESMTP id AE99520008
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 23:07:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mvjh7f7P;
	spf=pass (imf03.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790204825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PV4hGrIN0DDjKnpe+z8+6/ga/POcIKFya9Q0C0SA3Qs=;
	b=LmdSzMj0rRfDH61QEna1LHl12JS4iCmdkJKoavVjHHrSxn53vVd0vbLa3g4X+3fkn3iWcq
	jSggsa3mfOvkApFvu5uT8O8vmkXw0OmsdmareGtpkugjAJnaE6Hwqryci1Iq77a/EO5Z9B
	9qT9imRuaGOfrKdLRIrhDhNsh7bFV98=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mvjh7f7P;
	spf=pass (imf03.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790204825;
	b=K69napsllN0W2LBPHJPQh9eG6lTGdK1m/wVVwQrd1ZRzLRkmxbE5HaeuQxdzMvNHuz29t8
	1AxXckmkuZmbAQ9+2zb3mLT0NKDSSic4E70PmB1yZf+Z/QIDN+SsXPWHQWcFxt/4IOR424
	378JowL19AN+XqUeRhMWI/KvGgYB7X0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790204825; x=1821740825;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Ew+zaljAwfQAfT6VZB25JIASmNZAHg3G51tgKE5JB/I=;
  b=mvjh7f7Pz6eHHwPaHnPjhNCwRfJ/6sazlTm/kqoSegDxJWz48c2HoMDn
   7pVgQd3RRITUJSrhq7aYt1tOM0Ea3eHt6GRbjkogClyBZxUYTBP54ZB/+
   dZv8oyrzxg+tDS9X8tTf0OrlscRVHvgt1/VnHvHvddtcWrBaqaWi2xCzK
   RsvI5N/5EhnIlO6VEZUvGorAMqg5BP9zXkgGG4L+9P/lYPNQIfVr4ZzXH
   7HEOAHjKvOCq8XCuecDQxCucbAvCpbMuCtKlAqrO3fsyJtTiXIpoVRPZM
   ujMDWzR+NmGJw4nPMlQkJMBbfR51RDGJUkfypkkBA2/SU3NaCymLWk2XX
   A==;
X-CSE-ConnectionGUID: GTePFASRT6Ouv8Dai3Ulgw==
X-CSE-MsgGUID: Fy7kPWdrSWiyVptsiYAK0w==
X-IronPort-AV: E=McAfee;i="6800,10657,11914"; a="90077725"
X-IronPort-AV: E=Sophos;i="6.27,119,1787036400"; 
   d="scan'208";a="90077725"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 16:07:03 -0700
X-CSE-ConnectionGUID: lypd9Xt/QnyIdgWAJebIuQ==
X-CSE-MsgGUID: Z5/JGz86SbebjHM9o281yA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,119,1787036400"; 
   d="scan'208";a="300076285"
Received: from cooperst-gp06.amr.corp.intel.com (HELO [10.125.110.104]) ([10.125.110.104])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 16:07:02 -0700
Message-ID: <e1f8a64a-e4b5-4c1b-b83d-50425a7621a4@intel.com>
Date: Wed, 23 Sep 2026 16:07:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] x86/mm: Drop the page allocation from
 pud_free_pmd_page()
To: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski
 <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org
Cc: "H . Peter Anvin" <hpa@zytor.com>, Mike Rapoport <rppt@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
 Toshi Kani <toshi.kani@hpe.com>, linux-mm@kvack.org,
 regressions@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260923223116.20090-1-mikhail.v.gavrilov@gmail.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260923223116.20090-1-mikhail.v.gavrilov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AE99520008
X-Stat-Signature: fzbgec58556xwiuh7tewcrn4j6qa46io
X-Rspam-User: 
X-HE-Tag: 1790204824-976992
X-HE-Meta: U2FsdGVkX1+2hD4eNRneOmkekATgN/sCnufPMeJi5uqXa1ZHQkPIGBkqvbwaykhid0+DH/RNDzfNWYwJMbL5KD3R6jDLXW7PFBL7BK/34xBY+CcdKlbabWidm+HCtHircMs42pqSdbeghbXNyt9W0x21f8uRy/JGk/XBKw/ckLoDoTh84jpX7eHMYFVIO9S253ILkBuLdbQFPQu5CRbAYN5jOFyibOSqOC2ZGrvRz3r0kmI1l1hMpA+1ylikVcOotINALlV671d8Ry9FGNoHFJteOmbJicL/NLacR8HRtjKdMA57mCb7DtSmzIy+ZFARufuWuj9cHamdf2eE0l146mrg15Iv5bJUOb0iAvrVUSxCMtfQXi8G+2DGcokfzUWS1Gnlz8ZAkd5xO5xL6aOJ8P8hnVtVqwhmERYOlXTpMYvwCfrw+6YZqVxcbH7W4cZDPM8jusnkpYjooZR9N3LQ7lbOLyoPrxOIq6/cFlp/+BgkVFhcBbw6I9Gsu+HuBvKrEIZ6gkSxDSFBrr+ehu+ZEYmQNPBo9kTbbMX5fySj34hT3UhScBmVv7tL/xSAH7h0Eq0PUBTH9a08od/rY3QsYYoqGtBUCq0oQtwhzcJt2nw+IK1owDxXso1pET96Zm8OxsI5wZFxr63dhG+5y1oanrHnDaliPksqmwXyv+okvRVkRHXE58ZWOb+qAT4DpTTGVw2zSIp/DIKCH8+ZAAmMrvhZVO93VB29bNb+RwBrvamY68W1K8ZlCJBe1dq5mNtPlLADgsbffOyq7/gZ6U7LoS/CIBPU8X2GxwaKG2Mq7ycL7JypmV6FfXKKlOckxUG+SVC+DAD6eKsO4JtMz86aZ8xLP/hQPvkL1ub2Yp8HeXQRxHREGQKx17SlU1rUbatd/Q6gSDUpOsCXNjePS8aD6mH6gaux6TcD/hlWE+GfSfZuOC4jdEUMcJ7rSzHBLwkrnczEyGxIC2fcjHutXWf
 kgVUSg69
 9NfxyGGqQiIyBBPBlqVrP8boxOovlmWOQjdRA9lepW9VM+HPAWwBbw7SsOO3plDwbDnJ++8gSLajeKrdX5TeiPzkVhXDcgGtHKmfBhZ92MKIwcwz2MtJJn60CiyByGqXwmi0YI2WtCLL+AShx0GqTRrb8VyDCJOFddMd5RXmqGCf2xBaG+vOdZx4ECZAsX7GtlQEW85FPJWMeyDMkDFh5obXgjyh+zX6/2/fo2mhVxtOamd/tgpSQrNgHfbFTlHaQJIDJI5wBFzg1yhNktwbHj3mDxIcwcFJ+iCDWb1GWj7WUnjM4K64PM5Lkp/gi+LcSIxK9VrTUrJmotmg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/23/26 15:31, Mikhail Gavrilov wrote:
> So clear the PUD, flush, and free the PTE tables straight from the
> detached PMD table - the same order pmd_free_pte_page() uses one level
> down.  With no allocation left the cycle is gone, and so is the only way
> this function could fail.

Yeah, I basically agree with your analysis and fix.

There are a few things we need to figure out like having
pmd_free_pte_page() return 'int' when it doesn't ever fail, the
comments, and the reverse Christmas tree.

I'll dig into it a bit tomorrow and see what I come up with.

