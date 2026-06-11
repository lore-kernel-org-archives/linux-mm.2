Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CA90CD8C9D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 19:33:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABDAA6B0005; Thu, 11 Jun 2026 15:33:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6E206B0088; Thu, 11 Jun 2026 15:33:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AB1B6B008C; Thu, 11 Jun 2026 15:33:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8BD096B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 15:33:45 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 31538A07BB
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 19:33:45 +0000 (UTC)
X-FDA: 84868631610.26.C70DBBB
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3F4BB40013
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 19:33:42 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Bju5tjRq;
	spf=pass (imf07.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781206423;
	b=uzbi+FU6CoXo0WaQcQC8NMy1TyoXrDI5cney8Ab5vwNKHo6ZvftLhAl6po4hAw8VGnFgEY
	i6e5GuG0IO0LAU3q4QqVbXB76qd6SJrJTKwjgcel3YfzuEQRFU1C/ro8wZvc/gluSI71CZ
	PP3By7pw9VlycN4IpOBQS2IEz7u0POU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Bju5tjRq;
	spf=pass (imf07.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781206423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TEHeKAthRBT2wnuyZ5QT1BNTuvGWUokrW9aqbOUkBG4=;
	b=si6Cw7p9C1ZKOKlUy+5rLZSCbCR4j5vG7+jB2vA3t6tAU6Q6lZ/EPHVD4cNKzhxZxRBuqD
	krvrIMClUuESSiU9foFOUcxle+Vt0GX2RIrhVopXw81zSzWr1lR9levIS1C4F8EPgqEIj6
	7Nl8Xv/rVJ5VmiAWleuKzzANrhTZxoE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781206422; x=1812742422;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NIR3HYw2JEH9d+Wwq9mB8fwmfiQAFUYzbs2IS3Faf5A=;
  b=Bju5tjRqwClXHpWEhMSr755dmdxpEFX1/9V9n5bKgIEXiVdka9P58MnB
   CaxIPqmp/3kTTuqvYTbykhdgdIoT4Ok6Ea8w23PUgqjQo3xqCW2zeBGsH
   zm2+UF/abr+GA10Nom83FgYD5S9030zexIZ8j+9v6WEbRcwpypV9ngLf7
   kfABfkfIpaJkFqyD2Amrvms5LTSB4fcj5PiaiffDtCOaFhudjRMkehQgY
   RGhMI4K8GmMvc5AUfYDlquc16usH6tFf1RN0RFPxfvqYUZGji6xrukbli
   wZHe0KjiNcfHJ+YxMLB0wlNepSw6o34BjTBLvAgPDplIJVGve8lI7PC08
   Q==;
X-CSE-ConnectionGUID: v4QPVjflTWePY1oKiRnCLg==
X-CSE-MsgGUID: IcWB5nxQRzutyoqyZq1NDg==
X-IronPort-AV: E=McAfee;i="6800,10657,11813"; a="93423637"
X-IronPort-AV: E=Sophos;i="6.24,199,1774335600"; 
   d="scan'208";a="93423637"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2026 12:33:40 -0700
X-CSE-ConnectionGUID: 0wSjZKvyRlKvpIUqpBVZeg==
X-CSE-MsgGUID: 1y256R2mT72GQJAJDpkyFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,199,1774335600"; 
   d="scan'208";a="270614781"
Received: from ettammin-mobl3.ger.corp.intel.com (HELO localhost) ([10.245.244.123])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2026 12:33:37 -0700
Date: Thu, 11 Jun 2026 22:33:35 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Petr Mladek <pmladek@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [RFC V2 0/3] lib/vsprintf: Add support for pgtable entries
Message-ID: <aisNjxHW369cbKiq@ashevche-desk.local>
References: <20260610043545.3725735-1-anshuman.khandual@arm.com>
 <aisJbeVVxxNuYxQ6@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aisJbeVVxxNuYxQ6@casper.infradead.org>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspamd-Queue-Id: 3F4BB40013
X-Stat-Signature: n71mirg1isxnewqbad3pcqtoarxyq9rm
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781206422-135958
X-HE-Meta: U2FsdGVkX19eRnHI2T/tg6wgu4FBNCwduV2sQC7iYewa9bkEJkIrCG2aaXnaWnM0sYZ7jP/vdZQTRRVbkuzFVHAHuTdFGhKwYnoQ7zNF7uDdgVkFu4bdKiv9FGWOZVq2cHvHWHrfFqJRZMVcMGsBAaaZrBPyGFAdKj/FcAlz+Xv6rpL4Ov0XbwQA0MvLdqwf3gPO+ES1HJW+ojMwH9GU9otCpMvnsn7U/i8uG8V7sMywyoI2pS/d0m1Z+ZoGqnEK3g3HmRDIu8ayyzJC74dEXo1uFNQ5PTpSqeMUhUBbAEnMegj7rmDcnTTKiEyppubdciqRT11vTMeQfmzWfpPF6o2XzRHVhJCRHuqp48wZ37uotzMomYtaMEHmYK/aOTpvv80eYtubkEGm7KyV1/LfNDGuO2AUAJoK/UwbU/+7IxoHCIow1PvssMuSzHMhtzvMLVyysDBWWK8Ja1vBUfNEwAOmwtR1QiToZ/MyzGxbPb6Ue9ed6PTqWgUqmv03uj9iu9OgH/hve2nHb4kENLM4b1D4Vi/O9RCmdP0Ew/pTpmQ/wHdAJX1BM+56/OkxFrjZV1qO+EfmfzWke1debMGfgefUrTwx5DDQnRCi5NHL0m9wSHWXF2/RCUSbb0JJC3DyQhOlNcO35XNGE1ukzOLyiEBA9T+XPY+PQ4lnN1x2z+xk1UKOboQ2zBUtrjb5ve3eZ5+NSbV0royTItUzgHjqWuUE262IrWLyCPoEQwcUzH+60Z9ml0a7TMuyV7E62HZNqNiSNi0FGPLjoHovYVk+njeERGhOumWT/moSdCKRHmhqz3zmmId7rn+7rFHtnMMUzC6t8lfkBKxcWIm1dPO7EQ7x8lBhI8f/UJM0YSkHrXssOweonKNvLudFhfG08vh0y4TRw7z+askgkTL8T+ZkcKOiY+eX8uD/0dYp6ISoQQc6Pi1F3wUQxca82tYSCdfOTyQ8cHJEsDIK/vXBVSC
 PDDel4Yf
 sdJ6FIMlaGq4NM5Sl7aJDiTw+662kRkWw5TpeR3AU61mVmC/x8qjMJW5q7JitYbyBM+HNiZMpM70yg2jWWSuWLAOj0jobF+JX7weDS5ZjVbOqMO4S98b70L+6OehO8PaC2c5OHe54Ng53stQebZ3VV61uGwPNv3vzfKFQO7fTKOJTsZiAW2LBGV3sW92oZ54r3zSUrlAXuNb3jrq6iIAGOPBTey/kYoZzBBCyE5JU0SZnmLwhHOQGtsXZXanXRBml1MiTQypvjstVpxpWyyBrZwpniA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 08:15:57PM +0100, Matthew Wilcox wrote:
> On Wed, Jun 10, 2026 at 05:35:42AM +0100, Anshuman Khandual wrote:
> > Printing page table entries has been a common requirement both in generic
> > and platform memory management for various purposes. Hence let's create a
> > dedicated printk format for such entries which will also help standardize
> > pgtable printing across different platforms.
> 
> You didn't address my objection here:
> 
> https://lore.kernel.org/linux-mm/aFQP8LzVMctf6XH5@casper.infradead.org/
> 
> ie there is now no typechecking possible.  So you've made it more
> dangerous.  I reiterate my NACK to the concept, not to the implementation.

But this is more of a global question, how do we check the validity of
the parameters of pointer extensions in the kernel? Does anybody go to
commit into GCC plugin or so for this job?

-- 
With Best Regards,
Andy Shevchenko



