Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D08BAC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 09:00:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1B686B00AB; Wed,  1 Jul 2026 05:00:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F4056B00AD; Wed,  1 Jul 2026 05:00:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E2A66B00AF; Wed,  1 Jul 2026 05:00:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6B2136B00AB
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:00:11 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DAFAD1A0246
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:00:10 +0000 (UTC)
X-FDA: 84939610980.18.FC45F0A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf03.hostedemail.com (Postfix) with ESMTP id E0DFD20017
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:00:07 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QEekwifj;
	spf=pass (imf03.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782896408;
	b=4KkNKNNLoFnNoxSSzLJQ5D9tTIU9JPmhozXfn3MxUFbXuMLPtAPSl8bVj/x42ai8qagVXv
	NY8UnCP0EijnRLZriMC5zRbAlKSAQhzVld7APKtWW0mefkGgiz4+H/3TuvDT3IuCFKyt4H
	6EgXfUgO32pEsCth+WiWotWyNKus4Lg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782896408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DXSX3FRG31xY5lf5eahGGSJyLhKORhOOgjVTyvQoAZA=;
	b=vg31QQ17Th8cmHGlA00iRwk98Kp3SzH+lsVOFUQAoowdjClJSoSdOfPni/paF1H375aE3i
	Bo4I161DxQGL0rxq4VjFfHrvUQ7+6eJDMiJHGwX8aODEaSqCMyLVliEYe9Ssm/a6D+4Gt7
	QO1oyMl+DQ1+LboTVzJ0/b9UxXZu+P8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QEekwifj;
	spf=pass (imf03.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782896408; x=1814432408;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nHgJI21HPY161RCXXPvHhSW5/EGkSu5uqE1nrC9+G4U=;
  b=QEekwifjyBRwlIwHaoDL0ce5vbavgDyydb+005QCxEH5p2ycJPJPjoRk
   4bhBUtUFZB4pE77Zv4Hxprzq0Kjem9ynkK20lIsUzzM/fdWO+C3gdbBgC
   K6bvyAbIx5hhfdLn4gJanslyWultl/d3DzbEhicnIuYPACeXmcIpDAOck
   Jg8znzIGkEyub9Z9qGFCIE0uHrL5n7ypfnZfyXZL82mJHqN55wyrwhu0o
   qNQfmfpBm0x5NGx1psPUbKvCcgP8yBVsaQrxqMxZK/54c5y9lOaWEYu9K
   jH0BcUW3tVycuSKbO9edjjxyX5I8jAukaJ6qY3cRr5rQg8OFgMHt4jCu/
   w==;
X-CSE-ConnectionGUID: gh/c760wR2KYrFKeOQ2Isw==
X-CSE-MsgGUID: 5DplrNhTT6qsao7M7NWoKQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11833"; a="109170689"
X-IronPort-AV: E=Sophos;i="6.24,235,1774335600"; 
   d="scan'208";a="109170689"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 02:00:06 -0700
X-CSE-ConnectionGUID: qmADDl3uRZuJqwO2sQFarg==
X-CSE-MsgGUID: ULkSYhUmQ0SqQeGXnXEstQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,235,1774335600"; 
   d="scan'208";a="254425816"
Received: from conormcd-mobl2.ger.corp.intel.com (HELO localhost) ([10.245.244.65])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 02:00:02 -0700
Date: Wed, 1 Jul 2026 12:00:00 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Petr Mladek <pmladek@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	Lorenzo Stoakes <ljs@kernel.org>
Subject: Re: [RFC V2 3/3] mm: Replace pgtable entry prints with new format
Message-ID: <akTXEOowxiEc0XKy@ashevche-desk.local>
References: <20260610043545.3725735-1-anshuman.khandual@arm.com>
 <20260610043545.3725735-4-anshuman.khandual@arm.com>
 <fc57bb9a-4564-489e-8da4-65068b5283ae@kernel.org>
 <4a416383-62f5-1716-8e04-a2ee1f89a864@google.com>
 <dabfd73b-d872-4267-9a40-45463fe146ac@kernel.org>
 <3afa822d-3cc9-1068-9a10-94a5f2e4d29a@google.com>
 <90b5cd31-87ed-4ef7-86cc-458b9e06b02d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90b5cd31-87ed-4ef7-86cc-458b9e06b02d@kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspamd-Queue-Id: E0DFD20017
X-Stat-Signature: kpqcrntaecous1hz9qc7tnmoj8oauuoq
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782896407-237965
X-HE-Meta: U2FsdGVkX18pUafzMlDLOqi/k0Omqm030RBhv+0NdcvEYnn/LYUdCoHC+lIeJdR8UsV+qmPu4TSGqrm3LKYIFTzl8NJhvfPqJipwnjanURNfKlagAqz1MXEUi1sVFY7+K3P0o8HUHwvE2L+cdMRw/NamIHHvN/rV5/rL5p0+uZUAzrQomeVLLsL4Z44BNhKiBw2IrgRm+7ZxZ1KURBlm+85d8hwa4HIn8nHJxMsBkBnt3xC4mgEoe7CqFuiTgnmRJwGUf1rmfU2wINun/U2ncgCrLKGQJcHyQ0rDyz9CeH22F5rB8vzkQwsOCNxnQz4MbGizujacgSUyVm6RUNeezjkhw5cO8g8hknUYDSHgnSpKYwLZdgJi+6uo4UUn6f9pI+ivhRXwvDKgQj75WTA/Zd8hTdZT8VNA8QdptsL3nn9TDnW51ZHAxAO/d88L0qCpDd3aQJZ8bVZG9aUBqaWk0kuxPKAYZyP3EnBgQx4h+Yk+LIGes6DuTB+cUH/FpLZTtlOPY70dISf6milIBsCUUiTU3x1iY7sloA3c14MSMhmjeR7oZiO/hZ2YvOG5WgouVK0wVt/r0VKgtH1voa5FmuM8EWHtadNl6XpyYho8BjF6mA5A3BQFpOHHU5SGQn4w60zopaVEP1cv6PthOVGt7nZVYzBwULBwhXDsdeKT1Zk+yvdZCzzHK1+MuJGyV7L7Bcxvcd0D9YgoiqQq6wbQUsaB2YKClY8ldQdztc5i4gfVI+ymUovyb5q9OqNIGOBLBz6xtXMM8ptv6f6OH+wfDYOqX/kLBvHVW/R/aWiUzJrObFMnaFMoQMFnopRMt07VSr0vJU+mKjM5COenIJQvb9rMKBCQSbohDv+H5tu+6BcjX1Bh3guoRMn+7QDjseXhmEzX36KHuD/6W+2KW3l9sdBpLi7CM+BpjrsWcdLRshBMSJunBopnYYrUwQsN4IGr92Y8Lq00AzdS3cUZyV4
 EhWow58d
 c0bWH95x/EwfVECrl+4IL7F2z4baP/J/bCawPSdP3zIfvJKgs2DgIe4iwh8by28sIW5LCed7WT9HxASvERic47NfVcydlgfPEBINDYUQtusXlNgV6tAdHDg0cZn9IcpI75xNEECK4fNoGAltxhvpLqWaolPBvteE0fMT4H5YwqkxeQnsdrkwjN0ZbNzuq7zuRlkrh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 03:36:58PM +0200, David Hildenbrand (Arm) wrote:
> On 6/16/26 08:19, Hugh Dickins wrote:
> > On Mon, 15 Jun 2026, David Hildenbrand (Arm) wrote:
> >> On 6/12/26 23:26, Hugh Dickins wrote:

...

> +#define PTVAL_STR_MAX	(sizeof(u64) * 4 + 1)
> +
> +static void ptval_bytes_to_str(char *buf, size_t buf_size,
> +		const void *entry, size_t entry_size)
> +{

> +	if (WARN_ON_ONCE(buf_size < entry_size * 2 + 1)) {
> +		snprintf(buf, buf_size, "overflow");
> +		return;
> +	}

If you want to make this available for dynamically allocated buffers of
the exact size, this function should return the result of snprintf()
as int along with accepting NULL, 0 case.

> +	switch (entry_size) {
> +	case sizeof(u32):
> +		snprintf(buf, buf_size, "%08x", *(const u32 *)entry);
> +		break;
> +	case sizeof(u64):
> +		snprintf(buf, buf_size, "%016llx",
> +			 (unsigned long long)*(const u64 *)entry);

Not sure why castings are needed here and below.

> +		break;
> +	case sizeof(u64) * 2: {
> +		const u64 *val = entry;
> +
> +		if (IS_ENABLED(CONFIG_CPU_BIG_ENDIAN))
> +			snprintf(buf, buf_size, "%016llx%016llx",
> +				 (unsigned long long)val[0],
> +				 (unsigned long long)val[1]);
> +		else
> +			snprintf(buf, buf_size, "%016llx%016llx",
> +				 (unsigned long long)val[1],
> +				 (unsigned long long)val[0]);
> +		break;
> +	}
> +	default:
> +		snprintf(buf, buf_size, "unsupported");
> +		break;
> +	}
> +}

-- 
With Best Regards,
Andy Shevchenko



