Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50A5DC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 07:41:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 569C56B00A3; Thu,  9 Jul 2026 03:41:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F2EA6B00A4; Thu,  9 Jul 2026 03:41:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BD6C6B00A5; Thu,  9 Jul 2026 03:41:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 15B996B00A3
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 03:41:30 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AC20EA0402
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:41:29 +0000 (UTC)
X-FDA: 84968443098.14.40FB381
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf23.hostedemail.com (Postfix) with ESMTP id E0D79140002
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:41:26 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Rf10VFSK;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783582887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eliKrBjXOZBx2NM5dcgiJJR/dSmRZK92x1UvhJxASCQ=;
	b=fPhIB++NqN7QipzDg8oljy6J1CG31Ngh+pHI0zpAKkNuaJqljbaP4Xht+jQSKkB0Pn1tSj
	dj0ZTYbdbH6EPc5HGofaSylFiDOrkONjXXxHOsaVB7PRwYjvJAMvgLaLA0sF3UFJZXQyTS
	bB0+eVYab9MutC5lWjd7lIW22lfu/Gc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Rf10VFSK;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783582887;
	b=1i8AV7U7lctPI03/eccpY6lKEPAmmpp8CxgZ02FHzed7NYiokNVeFdOjrep/TtWdezL/GN
	3Qfz/7kVX//MlnVt+QW6ZoMLkt6y/eji+FXWJhYWk0WpCwWjrJ93DIV43FrlUV8CoiaXid
	BprsUOy1hBPum32B8zOF27z3A5rj0Ck=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783582887; x=1815118887;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xtrY4/IV1kkuKiVuakb4wYUItlYnPF71VBefCRtk66E=;
  b=Rf10VFSKbbVybAhMRqDiW6T2B0YMqXFWNTaBVN1NHhqSQd7F9YQlbl6H
   IjoIFHqA0tJdOSR1uCRldx1b4azKpwecGPpnQvjFoCYKKKt4ikexcKhKc
   4JoCyBw5rtImNvmK+CEDKB/6OeifWxvOv2MVUd3olI6vHSeLvYpUbckmn
   0WM3oo8w2hjbRKLgCvyXbvV7VCWaSyKFP3RZC/sjMn2M2rOkuySQWBdDf
   liRWeEYprCWuifi1AUIHrywiL9GH1CPDbIOpc1Y2nTC5QWk8DsyU2zzP5
   9VB17qNyhwQvUv+P8XA2v716E0X+/bPI7XoBojc8tY+HQdv2ZtGRzOYvC
   w==;
X-CSE-ConnectionGUID: MX4t0zoIQ6uPRwQTQLpY9g==
X-CSE-MsgGUID: CLFnhxKKQGaLsUWr7Yd8lQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="88172548"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="88172548"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 00:40:49 -0700
X-CSE-ConnectionGUID: P2Pvc4Y/RqezAZC3ZAWjOg==
X-CSE-MsgGUID: XdNurqyyS8uqswm62QretA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="258378238"
Received: from ettammin-mobl3.ger.corp.intel.com (HELO localhost) ([10.245.245.235])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 00:40:46 -0700
Date: Thu, 9 Jul 2026 10:40:43 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>,
	Petr Mladek <pmladek@suse.com>
Cc: linux-mm@kvack.org, usama.arif@linux.dev, hughd@google.com,
	willy@infradead.org, ryan.roberts@arm.com,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] mm: Standardize printing for pgtable entries
Message-ID: <ak9Qe1G7Rv3HF6ZR@ashevche-desk.local>
References: <20260709044334.1741263-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260709044334.1741263-1-anshuman.khandual@arm.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspamd-Queue-Id: E0D79140002
X-Stat-Signature: n31goksidfhrapqqwfyx7py87qi3kzk6
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783582886-568753
X-HE-Meta: U2FsdGVkX1/S5E0rr52du2LwwwVDGoj2aIl4lJUiAhNSi6dvcVp4XBTB5LDsqSREHo8gOG0M7jCghwEQ4GLAFPAERTbxGQ6gov4jsazs3S+1wg2EHCoTGvC0dcx1DFnZISZ3vkO4C9Vrf3J6p4iT1XEAOL+gXgAiU501M7wOzr/5U4eop8YNhmVvfeIPAjEgpq4OC5WIMcs5CJZBCjhKYRYBj55gDnN4xiyo0J0hGLe3r/9ocH69vF0Fs+ZlV9nhPPCaZ6/3oKtXMgHa5LfUb7KvX/IVwbaMOrBkAEtLz4MMAuSOxUP7OaWH0Chyps/CVmekuzxdQVEdlnz+9mflISQhr0eJDEqmTJHSlEDTFJ991Gl/W41uZCSQK1QZUUZYuM8ebtP/zp30J4wsdofZQnWX7xLLhz+rjefIEWPCiRVSSZII5EG87fZHI7I7p/EtYGA/pn5KEcN6q4bQ8kT+mKchEnVFn6sAU6myG68oEXP6DzcnDL3nzSdGbyXtztktdWMhqeFmHQjQL3JrhKlhJ1bqd2CSJxrnmJDta/WIty8/EK+zjmydMlii2cf1eiVg90xnhbDU5iwKqlud6BDxtNK6OD8SJHnhnYE+tc0kd3HQbKJ5YDBej2GcGLpoXYqvptWjpIvhwyVV5TL7DVTbfJtckIMiPVkvKKMXEpQ1iH5qGvB8mkTsNhkqtOCuYhP3uNru/HS0Cs0/kGcUqWee+hA2AaVF17KS670VD/EZTb/aqC2e1twCEG000bSm+miRm9FzQ6tMOzX9I45chG9e+ZqFmgm+cIESLjrY+W6hlUXNR4olQgtFtN6X7T+9i4EcITAOvCRhAg0wuJ+Ky5ShB8a8Yrzr0Z+408wJ3DnkjW490tIvl3RNBeHoUjQvUCGG1x90YndI3uzMfhhG+lll86ya85rDYXmURBc14cvIkEBWVoJZKNEKo80IwPOkUVOgTUH8+3vaK4TmixrI3oY
 /27pFAQW
 EE7OcB2jLuyyK9J7igrsSDsGTKs6ktLNFYj8VpmfPKa/F9tR3Dw5saQnpZxh9YQwitLHiGkweNJ7z0E9g0bCaUxs9cuKr9j7fyd1X3IDgaL/p3xwe8ujahvOG3EjzpiAsQq7sB2ECGYlOuRnjgJYmJ5XvIha+ZkTzkrTpCSD2qIMhOVhUliTfM921wrLX8Xxdbzil+qX6y8gDspbgerHztJYlZsMtus/ZbAA10WdkdjGmm2PFRHDn+9ZzvgaBpG7ELVSEnxXK/kn+dvNWFdYDp8x27HC1BXJlYuZ1KqL5C/2GA+OcQgkyJfV+x4SUqsv5SB+u/gmLJKnxv6sdKJ8G2aWnG+vLuCuu0AifQNOsNcfjtVOaP3Lazt7+Vru+ThwJaqJobCENznGJtOc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+Petr, wondering your opinion about code dedup (see below).

On Thu, Jul 09, 2026 at 10:13:34AM +0530, Anshuman Khandual wrote:
> From: "David Hildenbrand (Arm)" <david@kernel.org>
> 
> Bad page map reporting currently stores page table entry values in an
> unsigned long long and prints them with fixed 64-bit-oriented format
> strings. This is inconsistent across call sites and does not work well for
> architectures where page table entry values are not naturally represented
> as 64-bit values, such as 32-bit or 128-bit entries.
> 
> Introduce a common helper to convert raw page table entry values into a
> fixed-width hexadecimal string based on the actual entry size. Use it for
> bad page map reporting and for dumping the page table walk in
> __print_bad_page_map_pgtable().
> 
> Pass page table entry values to the reporting path as raw bytes together
> with their size, instead of forcing them through an unsigned long long.
> It keeps the printed output consistent and avoids truncation or misleading
> formatting for non-64-bit page table entries.

> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org

FWIW, you may move these to be after...

> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> Co-developed-by: Anshuman Khandual <anshuman.khandual@arm.com>
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
... this cutter line with the same effect on the email. The bonus is that
it will eliminate the huge noise and churn in the commit message.
Note, many maintainers switched to this schema (especially those, who use
`b4` tool, which allows to handle this nicely).

...

> +static void ptval_bytes_to_hex_str(char *buf, size_t buf_size, const void *entry, size_t entry_size)
> +{
> +	if (WARN_ON_ONCE(buf_size < entry_size * 2 + 1)) {
> +		snprintf(buf, buf_size, "overflow");
> +		return;
> +	}
> +
> +	switch (entry_size) {
> +	case sizeof(u32):
> +		snprintf(buf, buf_size, "%08x", *(const u32 *)entry);
> +		break;
> +	case sizeof(u64):
> +		snprintf(buf, buf_size, "%016llx", *(const u64 *)entry);
> +		break;
> +#if defined(__SIZEOF_INT128__)
> +	case sizeof(u128):
> +		snprintf(buf, buf_size, "%016llx%016llx",
> +			 (unsigned long long)(*(const u128 *)entry >> 64),
> +			 (unsigned long long)*(const u128 *)entry);
> +		break;
> +#endif
> +	default:
> +		snprintf(buf, buf_size, "unsupported");
> +		break;
> +	}
> +}
> +
> +#define ptval_to_str(buf, val)								\
> +	do {										\
> +		auto __val = (val);							\
> +											\
> +		ptval_bytes_to_hex_str((buf), sizeof(buf), &__val, sizeof(__val));	\
> +	} while (0)
> +
> +#if defined(__SIZEOF_INT128__)
> +#define PTVAL_STR_MAX	(32 + 1) /* Max 128-bit value in hex + NUL */
> +#else
> +#define PTVAL_STR_MAX	(16 + 1) /* Max 64-bit value in hex + NUL */
> +#endif

The above is quite duplicative with what we have in lib/vsprintf.c. Have you considered
using something from there instead? (Yes, it might require some functions to be wrapped
or dropped from static.)

-- 
With Best Regards,
Andy Shevchenko



