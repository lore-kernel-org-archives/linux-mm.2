Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34F41D73E81
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 17:40:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 730C56B0088; Thu, 29 Jan 2026 12:40:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DE696B0089; Thu, 29 Jan 2026 12:40:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C01C6B008A; Thu, 29 Jan 2026 12:40:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4D58E6B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 12:40:01 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1996BD369F
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 17:40:01 +0000 (UTC)
X-FDA: 84385714602.10.21FDC16
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf17.hostedemail.com (Postfix) with ESMTP id D203C40012
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 17:39:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=c87GBSyX;
	spf=pass (imf17.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769708399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9/EHeULcqZbnKkCfvS7FIf8N1dbPW5VY16eMrhzC/k0=;
	b=wKM1ZgApRdyG99tAm5ZKkpwoThjKdTZOt+nu9Dijwm50vZFn5+EnDcFzXuItxqkF6TBz5z
	nfG3IlqvaVKVNQojgYtZVlP0RyAmuuvMz5d3xF4Xyx7gRK2+Qj9QMzA00XzCvFQ81bctK7
	jgYm/T/9jwU1Ta4iFDhO2YjD+QASeIE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=c87GBSyX;
	spf=pass (imf17.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769708399; a=rsa-sha256;
	cv=none;
	b=qnuaxXnPzW/VC98nkWHN42Kns0HW9b+lweC2EJkHx/dvz/kFJA8pnCMk3iBsXh3TX3w2Cc
	4p0Bi2pMfMAFPOXd0QPC/6Ybd7FDdEQt2EqgnekjCe+63jlsnkCRXfYr4h6g/bsKqFqb6M
	VRRRqkqcQ+0PvdVbwwfihFcBqgTbjoQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769708398; x=1801244398;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9/EHeULcqZbnKkCfvS7FIf8N1dbPW5VY16eMrhzC/k0=;
  b=c87GBSyXyr6zGdno3CdDl8vGzIhz+Jout9+0+RPZhnG6zriFMZClKbx4
   N0p5HSfgWX70BFNwWbA/SoOs/xU+RHFEJzsZFCjdNw0gZ10IOWQfJ4rF4
   qKkkae/uQllsGf2Hl6RVzc2PNsDtNhzkxw4o9zQe0D2VxeEcTWQ2fFGr0
   pS5v7RU85VwQhOzv+mNJYl6FBbmZQuFfQ3FxlPCmAsHET39MkXz3nouNR
   cOUXwQQZw7nuJijvW5mMQkhFg8+eOhZuwm8MMFHUs/ogaGg6m6XPvp5XD
   iBvelq4HJA8fRhEFV1YxjGrY6cBFHc4jQENOrEaELwj65YDo/G7xB9NAe
   Q==;
X-CSE-ConnectionGUID: wjLgOzCvQNyL34g8kETn2Q==
X-CSE-MsgGUID: P+gFuhvyTyy2UYD8rRF6eQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11686"; a="70928869"
X-IronPort-AV: E=Sophos;i="6.21,261,1763452800"; 
   d="scan'208";a="70928869"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2026 09:39:57 -0800
X-CSE-ConnectionGUID: m1QRk3fZTkyWcEM9VM/MFw==
X-CSE-MsgGUID: DGQPX5d/SC26JL5PZLjNmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,261,1763452800"; 
   d="scan'208";a="239364563"
Received: from rchatre-mobl4.amr.corp.intel.com (HELO [10.125.110.19]) ([10.125.110.19])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2026 09:39:56 -0800
Message-ID: <b7cbc2f4-6fef-44c2-a0f4-2d6895c0fd74@intel.com>
Date: Thu, 29 Jan 2026 09:39:55 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] x86/sev: Add support to unaccept memory after
 hot-remove
To: "Pratik R. Sampat" <prsampat@amd.com>, Kiryl Shutsemau <kas@kernel.org>
Cc: linux-mm@kvack.org, linux-coco@lists.linux.dev, x86@kernel.org,
 linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, ardb@kernel.org,
 akpm@linux-foundation.org, david@kernel.org, osalvador@suse.de,
 thomas.lendacky@amd.com, michael.roth@amd.com
References: <20260128204105.508855-1-prsampat@amd.com>
 <20260128204105.508855-3-prsampat@amd.com>
 <16aa84a9-83ce-4748-bc73-ccf5cb6ce376@intel.com>
 <aXs4DTXCbI_c0JPO@thinkstation>
 <097a4980-9d10-40d2-9667-d07bf19e7b86@amd.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <097a4980-9d10-40d2-9667-d07bf19e7b86@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: zwcrsxzc6f57habf1sgpe7r8eaymodty
X-Rspamd-Queue-Id: D203C40012
X-Rspam-User: 
X-HE-Tag: 1769708397-290312
X-HE-Meta: U2FsdGVkX1/g5rEsNXT+KDvERCHcbF/PqeOxq9hAdIJnxnHYPwUl3gGvZwM6coulywbOT90ZcX7ePQHD2k+tksnSuGZaCcc0PhswC5nWbBv2LLLeyUFEf1+xmic+DnXZroLb8a5m6/fonMTpqH1AIF/mQyHB4Ti3D2xh9lLdtKaX2p2VxrAto9NTxTl8HugJcUYxFnfYMHnz69S0rEmlXofIX0IC8h7dy2viHHAY9N8U6JS0t0SFW78icLeymdNh6TjGgxGosJCu59K4G3XBfXjgheSyg5MQzdJIselgbxm52JSB53h6KkC4Q994vKP6W1DqPt5NXY8z2V4CO0wYWXvONSVTICsHUs2t1Ji0Sq168cieqENW40dH9NT+UxnF4+gKbZnwnZtousuPE6ErESHqF3OiKIjDNGux5HIwRwMzsoYM+mqd9qrCEe3AQvij0CfT8w1q1sdqBYFjsil2UpYbFFpn76/aUkwCbvSnC5pLeZIVflekbhN/fjHTrV1gXdcFy6DT2Bxxbbi0JIDiaUtDoRqjkGeldlFszDmjcDThYPWc/TjxPMumQo9jXDY/sNTnkZswkUIL44+S5ZAB/ItYiuoL5JXcZr36xc/Faxu4vdy8qy9vsxm+bIK7BeXzLqdwT3oN0Uv9y21/ARA614qjAPcUftEM9V3JKNtV1/8cQQLMHb6P/qyaq+qIXZIOYeSGaQPo6yiCLF3ydxvs3cSbjhBMz44YX6y6tIC7mUCl1ggOVe7bEfM8aOk3AdHspI6geihoZPAAi9yut8vXTMVTUXAhoMi8UGUX1VeiCXNg91szOeyY9/Oy53MbWNLvYD15sr+DDOb5V4Jjcyglu87XAfqO/CQ9lPCcjcc1XRoCZm3VL1iEtadt0ZuXKWeCJA8EzwrmfC2rF/saKG1g/x7D+ITFYbolooE7qAa+S4OGAOLcX2rNfgG1VLV3FHqPyLRWULLiGgF01+Ix9SP
 AWabV5GW
 szfkggfD9XfKr9JRjOvhW9dcxJ/bVtXyob84Y2MfjGEIS6QCtYzOfTi/1Xwzc1HeXX54Q53otWS5xurKo3O635AX9VuDPMLBcbFuo/XM+N7OZDZMf3VXEgDjggGsPeqdVvTAnjw0CJJRZ+aNdyLprOOgdA4BzMKvL9X1itju33V/TydkraH9hT9WjJlfQbfhUUmt/Zqwl6YJZqJI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/29/26 09:32, Pratik R. Sampat wrote:
> In that case a fall through for TDX (with a comment explaining why) and
> panic for rest may be the way to go?

No. panic() is an absolute last resort. It's almost never the way to go.

What else can we do to ensure we never reach this code if the platform
doesn't support memory un-acceptance?

