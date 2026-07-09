Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72D84C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 10:11:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 649646B008C; Thu,  9 Jul 2026 06:11:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 621006B0095; Thu,  9 Jul 2026 06:11:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 538B16B0099; Thu,  9 Jul 2026 06:11:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2A99E6B008C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:11:50 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A135C168E9A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:11:49 +0000 (UTC)
X-FDA: 84968821938.21.D1134EE
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf12.hostedemail.com (Postfix) with ESMTP id 103CE40005
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:11:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TX1bARQd;
	spf=pass (imf12.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783591907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+1VRZYtTZCEZXGqmF3ZBlYJ4UGW1mZ3IE2MQArfKOZU=;
	b=57DpL2MtifHIWq7Mv9V2CAlVxWlJYDSoGczuFYPDE7fbMcSyRL084lt2F9+BwsUOcSxvQu
	nkNYSE2L6GH0eVNds8BaHVNaHsFI8eMohBymN2LYKMo0h5QCGCeb/P/GAar7cLQ9PLR2CK
	PysEqtNIdlpZhO+zFZujMShOroJWImA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TX1bARQd;
	spf=pass (imf12.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783591907;
	b=PvnyvHDl9LD2GH6iY+LX3DVEBBKu3fmmEePO7X7kghau9eQcqwz4wP2WcUVBzje6cbF7Ox
	mWS2PFIsPoz122SflsFqavuZLPnoO9NVYUV5LhA8BmPomkGpRe/JjFIM357gfGQtAaXhk1
	b7575X/kp2Bq0qvxy/B2FO+uFn30m+o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783591907; x=1815127907;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Dbwwr9k82STNamZXgOjXS9u4NcnIXxUNduxqyI391KU=;
  b=TX1bARQdtt2EwvBKzQSzTmdGZ3Z29kwx2VOXEBuDG8qtYFVobtZeofWS
   6+A9meFZqoehGkiO7tCSpdcXXJuNf6mKIV+Bhw5zFjnvfKsuZ9ARZVIdo
   PndPX+bLHXcAgVspjsUavJsKeBk50kzOAFdxI7TKIDOa5ih15as7LGJI7
   PoPdG78GandVwR9E1cNKX+keLwb/M1PGOneeX1fZVIWp5TIFBAYzwdeMH
   ACn1U49pvInP2iKA3T+HdTJNq1poAibnw9u0OUBlbX0AC+SRwhIwh593o
   TS97LfosMDPVzOI1/Krzx1Lp+KNQP3XdNhLQFyWjt+HfH0QT3a3TDmsrp
   Q==;
X-CSE-ConnectionGUID: liCv9KngR02IqrZJy6jmbA==
X-CSE-MsgGUID: 95NySo/iQju2XVcbbzSalw==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="84126090"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="84126090"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 03:11:46 -0700
X-CSE-ConnectionGUID: tRcVs3+CTk2aMSzqxpeHRA==
X-CSE-MsgGUID: fZLwjXclT++l6clJRMfZlw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="258411968"
Received: from ettammin-mobl3.ger.corp.intel.com (HELO localhost) ([10.245.245.235])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 03:11:43 -0700
Date: Thu, 9 Jul 2026 13:11:41 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Petr Mladek <pmladek@suse.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
	usama.arif@linux.dev, hughd@google.com, willy@infradead.org,
	ryan.roberts@arm.com, "David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] mm: Standardize printing for pgtable entries
Message-ID: <ak9z3ZRdRqGoOu-T@ashevche-desk.local>
References: <20260709044334.1741263-1-anshuman.khandual@arm.com>
 <ak9Qe1G7Rv3HF6ZR@ashevche-desk.local>
 <ak9mrw37kTORZXmc@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak9mrw37kTORZXmc@pathway.suse.cz>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 103CE40005
X-Stat-Signature: brq1hby5tdtu98miryf56np6jeioztxa
X-HE-Tag: 1783591906-12778
X-HE-Meta: U2FsdGVkX1/4FkOsqHxBh4+a2SFG5wvVCydYUiwWm6D0LjnTTxn0fZXskSOJKg4CKs/4oK5BrmOp2KS3fqZzBBYwnojK3PtJ5JkNjL/YbJee9XqaeYgNQuESRgRbK+tMXFiUB/YIMiA+iIa0iwaRGwVVxIoV+ZoFzZ4XSJnfZDpY5kqS2gT1ONVB3t/7cr256rHG8WF3+Iy6PKXFTHEiyCI3cKNIwqBG400Zb7SDSmcW1s70K7gy9GOoE7zWxLKwVAq5+1rZik9QH/EIOHXsTw2qrC2Kk1swq7UB6QqOOmdfHlzF/USa6ZeyM7S7uAS2YJZbZ16x/O+VTEe2eOLXf5fQTVDnWVjKx+XKdtujhcX8s3YQOXz/5hvVsvMkasVu9n/LvhRPT95c8Q0A1jVQEl4wJ01wMyj15qR+HlzYhS+QRdW5jijujuzZT22CvkyRkBPfzalXkB2tpyQf7rEDBJ+RzEjdfmPsP0bHzA+dTNQmldKr3zkHZwvFIGRyeJs0KlcIacWLB7JFoHMZdXnlX8hWaYNYanhBk6ndswSOZma/AZXNLbhzx4Ywds2HbgaSplf5bvoG036jMkyt7qTU9YtxMFElu+v5nGnXKe4acQOkZ31lm9T7iHM5XHbya+7+ljBK9w4tHOmhUzBC6UmclFdyqXq8qlUAxs0pZbzrh/rQgOpGVXsVFZcxiOot54JqXHawLZqlPCxXJk3Vve/Udn9l6TsSAK7lXY9v8NXOIoDhXJJs0gHmlBhPTuOp9Jvnhd18jDxdGzgi7KhSgYbGU9mVcWzHu27GpZlz9mE4JMG/506O6o8TZMWYgfkooek9D+oYiS0GWi6szH+KkKqe17PZ2MHCI6nafZmN//XNe1WNOqKvJjLI6xNEjM7FW8z3A+QBnFuoQTSQbcGHvkEf0wrpdKbOZRJoWrqn7bXP1aLY+XzOEYjQG5OpwyqTIkyITud+LVlGvoHa3v/uN4/
 cpLw7ArN
 gOfkrI3cqeotVytDF0LXt3H8L4mMDPRCdR7BdUhg/YoyszQaYZilBYlCENcts+UykPD4mwjxSXR1IXHJsKbpoGwSE3FoIRG1Kb1FxdYQ59pLAwDqvq0LWFhNBRXmxlP1+4y0BPdY9IPpzGuPGUAyV9eyBCImZ0uwi1SBDoa/Zcn1WoJL+6odO2E1leLBBpws1+7R5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 09, 2026 at 11:15:27AM +0200, Petr Mladek wrote:
> On Thu 2026-07-09 10:40:43, Andy Shevchenko wrote:
> > On Thu, Jul 09, 2026 at 10:13:34AM +0530, Anshuman Khandual wrote:

...

> > > +static void ptval_bytes_to_hex_str(char *buf, size_t buf_size, const void *entry, size_t entry_size)
> > > +{
> > > +	if (WARN_ON_ONCE(buf_size < entry_size * 2 + 1)) {
> > > +		snprintf(buf, buf_size, "overflow");
> > > +		return;
> > > +	}
> > > +
> > > +	switch (entry_size) {
> > > +	case sizeof(u32):
> > > +		snprintf(buf, buf_size, "%08x", *(const u32 *)entry);
> > > +		break;
> > > +	case sizeof(u64):
> > > +		snprintf(buf, buf_size, "%016llx", *(const u64 *)entry);
> > > +		break;
> > > +#if defined(__SIZEOF_INT128__)
> > > +	case sizeof(u128):
> > > +		snprintf(buf, buf_size, "%016llx%016llx",
> > > +			 (unsigned long long)(*(const u128 *)entry >> 64),
> > > +			 (unsigned long long)*(const u128 *)entry);
> > > +		break;
> > > +#endif
> > > +	default:
> > > +		snprintf(buf, buf_size, "unsupported");
> > > +		break;
> > > +	}
> > > +}
> > > +
> > > +#define ptval_to_str(buf, val)								\
> > > +	do {										\
> > > +		auto __val = (val);							\
> > > +											\
> > > +		ptval_bytes_to_hex_str((buf), sizeof(buf), &__val, sizeof(__val));	\
> > > +	} while (0)
> > > +
> > > +#if defined(__SIZEOF_INT128__)
> > > +#define PTVAL_STR_MAX	(32 + 1) /* Max 128-bit value in hex + NUL */
> > > +#else
> > > +#define PTVAL_STR_MAX	(16 + 1) /* Max 64-bit value in hex + NUL */
> > > +#endif
> > 
> > The above is quite duplicative with what we have in lib/vsprintf.c. Have you considered
> > using something from there instead? (Yes, it might require some functions to be wrapped
> > or dropped from static.)
> 
> Honestly, I can't see any reasonable way to deduplicate the code.
> 
> Most of the magic in the above macros are in the value/buffer size
> detection. I do not see anything similar in vsprintf.c. The sizes
> are handled another way there.
> 
> Also the internal API used in vsprintf.c is a bit tricky because
> the buffer size is passed via *end pointer and it counts the printed
> characters even behind the *end pointer.
> 
> But maybe you had something particular in mind.

Yes, I was thinking of a wrapper on top of special_hex_number(). It takes size
as an argument and hence will work even for 128-bit cases.

-- 
With Best Regards,
Andy Shevchenko



