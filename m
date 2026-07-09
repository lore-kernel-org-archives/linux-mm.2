Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44173C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 10:10:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3389E6B008A; Thu,  9 Jul 2026 06:10:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30FD66B0092; Thu,  9 Jul 2026 06:10:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 226146B0095; Thu,  9 Jul 2026 06:10:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F31376B008A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:10:07 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7FB23C2DE2
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:10:07 +0000 (UTC)
X-FDA: 84968817654.11.121DB08
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf10.hostedemail.com (Postfix) with ESMTP id B1A1CC0007
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:10:04 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kETuaNPj;
	spf=pass (imf10.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783591805;
	b=UkSM+kf/1fbxdW9uYX2hBsM9ohUrAGzp/fCehBnHUtoePFyn7sPWTNT1k8cIRaCtb8zBEx
	I7R2uiZjTx/21GMSRO4CSoDymB1oW1NELKBYeCRQpGv0sOjnlbU571Ax8njQQWw/ATY4W1
	+ClLFLo45XZDvH7AWnuXdfZ7RCkjuPc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kETuaNPj;
	spf=pass (imf10.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783591805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vFlXJeXSZGYZKl1AUVPDLv2vXBPAvn2TSre8i30E0vQ=;
	b=ZGjZGgEQ8fGgnbvJFzpeYG25NGbSPY3yPVPh6ZEKcbE9vQWXpgb1OHYBPx7mwm5KN6SU3h
	TZfLgrAIBALaaYfG3u8JAOt+U0nTS8MTHyJhxNBHi5gulW6RZco1c0tE/PtCVg+wVg3cgG
	LcqYkR7Y91peesGSQwJClleTo8O4pck=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783591805; x=1815127805;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TrkqQ7zhIvszvZQqIOqflT0qGCkULvjhp3ccrpYQwsk=;
  b=kETuaNPjtKTqXSbM6ZzQPsFgfPah7nb79fKImO/ji1IM5WVsUlU9RJGo
   8nknXlUDhf69+Un5/QoAAEHDphbn2FskyOe3mUyE/x5JpvMb5BIp+641X
   WWZ+QHket+BCGX3BrEwoXFHPgiW+ab2VwoqFU792ymIsuFvmCag3msUyS
   HTcM0VEdP11fpUyb20bRlC/CGcUo4uv5u8132d1rw0hJn+/FeZX9TWdEe
   disWRF/fSoAVjFabPVa0G2dWqD/x1WNi0ZaP27ESpDqQVJnDhOckHBRz5
   YrrC3h+XGroM5Xjx8+BvpfxqOrxc753xZGkm+RgclFRN7wUtsMVqt62YN
   w==;
X-CSE-ConnectionGUID: ZNC//uJWRrmluSoUyKfAjg==
X-CSE-MsgGUID: hMsf0JnqRs2lTRCwU9QRsA==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="94915640"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="94915640"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 03:10:03 -0700
X-CSE-ConnectionGUID: IXvYTLiZTAyIwc8bXB5rHA==
X-CSE-MsgGUID: ovnBkPJvScql75QTvZzjTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="254056645"
Received: from ettammin-mobl3.ger.corp.intel.com (HELO localhost) ([10.245.245.235])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 03:10:01 -0700
Date: Thu, 9 Jul 2026 13:09:53 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Petr Mladek <pmladek@suse.com>, linux-mm@kvack.org,
	usama.arif@linux.dev, hughd@google.com, willy@infradead.org,
	ryan.roberts@arm.com, Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] mm: Standardize printing for pgtable entries
Message-ID: <ak9zcbG_WvLpCCzj@ashevche-desk.local>
References: <20260709044334.1741263-1-anshuman.khandual@arm.com>
 <ak9Qe1G7Rv3HF6ZR@ashevche-desk.local>
 <dfa83e42-4f27-4c38-8796-b64a791788d9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dfa83e42-4f27-4c38-8796-b64a791788d9@kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B1A1CC0007
X-Stat-Signature: deua7k3zjtukb5kuxp56biutgixh1z9x
X-HE-Tag: 1783591804-345990
X-HE-Meta: U2FsdGVkX192qTOBzX+VGird8jBZuOuepHRAuiRImpliLQjG2lPFqK48zWfany14YlNEO6nY6EsMhMg+nezebfSa888g+nuqHH7tP8YqQsN5irTDqZsEBfUxiVBM5INjhOIpvLZMVCKmGeZHHcq7u5AyWtUwCVXibm6EGLf2QyVi5VqYGpc5wAqJAFtKVIz4DQYmG6nSNqKP9q1CH72h6UKJTuwGWr/9/2kcR7DysQfvPjcB4HydNpf8ar9q1Ep1hbSTiGLQdmmCMQb4ZUWDjOfpQJIcs1TIj74vbyTYtcm+A950VP+0RzwlE/EwcmLKWFjXx+Gw2RIosabiCCCcRtEpUWGGlgiCWLNZNCChzImboEqsL7t6iDv4hbwAtJ+PnQimP9/dl3F8bPdGLCP17uF3mk0q15m0gwZm4hSd1Xm2ea/8RzfRjrteAPA6Q5ah0SNrRv6M1cV49yxiIRGEFhcdPyTxHXm1tUAWQoq2C8BxknV6RqNZBZK8YxftRARWRy1nJUzOaBJOEnxnlX829N9HLXkWtVcEMGCGvXIhO2KB/jTl5wqDHVUuVsjAc2vf420ldJz/IL8s6WgR34I1/aILOcPg1ExCCcItcI1rbswoenljUYf+DjG+JLrTJKgawP2xlA+AmCWbSFMg/al9eU1KzxsV3BH3etfID4K/3Dc9j2iIclEYRlWooUPJmfWS3kSDPfcXbyJ030767lk4S4bg2GQdQLNl1TUHIKwocXq9zEwSsKfnX6rYogI81bYSoqGuwwLbdVu0kwkGdvRMRWZDtaEkSKP3ANTVzISUlNQW2Rq1MQbPI5bYfin0ybfdAybYuN2+G4SuADk1KJHak1owM19uRvZzriCiXWkLLZxXIyf2sMrgEEUjaP3vqBrXmVIVqDMY5mmBCikSj1kf3XzJVzRepge/7y8I8GZHr4HJz5bpRaUZtm+dWxFsjmh07lKbREgROROjhk8wgZS
 0Ezc6sVi
 ZFod1DOjrfmGgdQ7WM267AAgF1hjee4M8UXvSGg/+R2K4Pdpol5Cj6/bCjiAKT//RMdvlDTZ6A/6vkVnIKjgvcR8F3fOyXynmZJ55l9iylYFkdEq6VY6mgvvP9W65sQsgtsOqpJ2D0QWcrOU4At9UoVTKb8R6XkGIXXdL/38HkjkUu6M9sLQRdMNU9iL3Rs0qNROCXBf7Na+NOhi0YItnTroN/bOW7RhS5xEOTIsSKB7+01f6cxbUXHP3RBSwYThmQBzhWKErKk4Wo2SjhZI/YA87qeoS4H5MRpavthtXM+tkrOj8P2YorAm9WwRc3x8Cc5MtOkX61rrk5Hc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 09, 2026 at 11:12:58AM +0200, David Hildenbrand (Arm) wrote:
> On 7/9/26 09:40, Andy Shevchenko wrote:
> > On Thu, Jul 09, 2026 at 10:13:34AM +0530, Anshuman Khandual wrote:

> >> Cc: Andrew Morton <akpm@linux-foundation.org>
> >> Cc: linux-mm@kvack.org
> >> Cc: linux-kernel@vger.kernel.org
> > 
> > FWIW, you may move these to be after...
> 
> We generally don't handle it like that in MM. Maybe one day we'll switch over
> and document it accordingly.
> 
> For now, having selected patches doing this differently is not any helpful.

Can you elaborate "differently"? Except a big noise and churn in the commit message
I do not see any benefit of doing the "old" way. Lately I saw some patch-bot messages
from Andrew, I assume he updates his scripts towards newer tooling, which may be
a good sign that the (good) changes are still possible.

[...]

> >> +static void ptval_bytes_to_hex_str(char *buf, size_t buf_size, const void *entry, size_t entry_size)
> >> +{
> >> +	if (WARN_ON_ONCE(buf_size < entry_size * 2 + 1)) {
> >> +		snprintf(buf, buf_size, "overflow");
> >> +		return;
> >> +	}
> >> +
> >> +	switch (entry_size) {
> >> +	case sizeof(u32):
> >> +		snprintf(buf, buf_size, "%08x", *(const u32 *)entry);
> >> +		break;
> >> +	case sizeof(u64):
> >> +		snprintf(buf, buf_size, "%016llx", *(const u64 *)entry);
> >> +		break;
> >> +#if defined(__SIZEOF_INT128__)
> >> +	case sizeof(u128):
> >> +		snprintf(buf, buf_size, "%016llx%016llx",
> >> +			 (unsigned long long)(*(const u128 *)entry >> 64),
> >> +			 (unsigned long long)*(const u128 *)entry);
> >> +		break;
> >> +#endif
> >> +	default:
> >> +		snprintf(buf, buf_size, "unsupported");
> >> +		break;
> >> +	}
> >> +}
> >> +
> >> +#define ptval_to_str(buf, val)								\
> >> +	do {										\
> >> +		auto __val = (val);							\
> >> +											\
> >> +		ptval_bytes_to_hex_str((buf), sizeof(buf), &__val, sizeof(__val));	\
> >> +	} while (0)
> >> +
> >> +#if defined(__SIZEOF_INT128__)
> >> +#define PTVAL_STR_MAX	(32 + 1) /* Max 128-bit value in hex + NUL */
> >> +#else
> >> +#define PTVAL_STR_MAX	(16 + 1) /* Max 64-bit value in hex + NUL */
> >> +#endif
> > 
> > The above is quite duplicative with what we have in lib/vsprintf.c. Have you considered
> > using something from there instead? (Yes, it might require some functions to be wrapped
> > or dropped from static.)
> 
> Which part in particular do you have in mind?
> 
> num_to_str() does not apply due to the u128.
> 
> We could have u128 variant that we would only provide with __SIZEOF_INT128__
> 
> int num128_to_str(char *buf, int size, u128 num, unsigned int width)
> 
> And then have the code pass the value instead of a pointer to the value. A bit
> tricky to handle this based on conditional __SIZEOF_INT128__ support, but could
> be done.
> 
> Not sure if that is really what we want here, though. ptval_bytes_to_hex_str()
> is pretty ... simple :)
> 
> I didn't immediately spot a replacement for PTVAL_STR_MAX.

I referred mostly to special_hex_number().

> So it would be good if you could clarify what you had in mind, thanks!

-- 
With Best Regards,
Andy Shevchenko



