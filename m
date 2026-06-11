Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4250CD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 07:18:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFC6B6B0088; Thu, 11 Jun 2026 03:18:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAC036B008C; Thu, 11 Jun 2026 03:18:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEA016B0092; Thu, 11 Jun 2026 03:18:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D3B6E6B0088
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:18:08 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A0CC51C321C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 07:18:08 +0000 (UTC)
X-FDA: 84866777856.28.A0BEFCC
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf02.hostedemail.com (Postfix) with ESMTP id 010D48000B
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 07:18:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KZ5Vpfrz;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf02.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781162286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9xoXkR3+ToFz7IhDpRWpfOeWmUWRBN7wUMPHcqf/6FM=;
	b=L/KluDXM0rqPzrsBUQntFKquMLajXwIWTzFvC5OtIMse7NrXF2uGr1k0kPsEO/dskwUHTQ
	DgLHGiqgQgiyb/H8wAzwTG22w5RSBm2r7ZFUGdRLOzBwTtLric0oGYEYzvJ1BRLIlX25/r
	YisGlh1RfTUvR1srH/hBpCPCo2wOb34=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KZ5Vpfrz;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf02.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781162286;
	b=mSZN3tU9WgjgXh6tMTm+vIUQW1t5Irrfbt7TFfwa5Psp1ibO2fQ4+oTZ8aLxoCQ4bRWHoX
	68OHN9WigoxbzPAmhHkPcWgfu+zpwSNIS+dR7tJqKDFlZwjxX3UCmg+KN/f2mH3BreWQZp
	gkfWWEkhSKG8+SRF54LC6sjJs1gEuS0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781162286; x=1812698286;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fiVJwTu9CK0mToLiHPUfmG+jQ0/gNkGEoV4Z9N/y9xY=;
  b=KZ5VpfrzxVAdHwtgWnuYXt9LbafT+ly7oMVuUjBHEA63vslaUKi/rOoy
   TTsChVglUnH0jSlggTTTIFLr4EmuCsSWWa3XeK1O6ihCIgM9hMnSTei64
   QRPB9GLjf08HJGy9kokTHI8an5g348m7RSPLovk5tRz4/ICMqU8AfA0T1
   5x6WlaMNRP9em0tkSxVH7a/MEwh+VWHJtTqnTbwMbSz4FmPOA3deTKdO0
   N+2JcP4u32DSOR9GZiop3FS1IrpyFuh4vPtEw/3GYCzIpYehS4vLux1og
   I++6Ixj1kG/X3zKlOHKNRz+VqpXQnj0V/zrELQZWp+rhA1hJ2ZtlplWmB
   Q==;
X-CSE-ConnectionGUID: LvgiJp6WTNigtvEnDlFRFg==
X-CSE-MsgGUID: JuLUBhtoRh6dtGCd0PDAmw==
X-IronPort-AV: E=McAfee;i="6800,10657,11813"; a="92645303"
X-IronPort-AV: E=Sophos;i="6.24,198,1774335600"; 
   d="scan'208";a="92645303"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2026 00:17:55 -0700
X-CSE-ConnectionGUID: j3EipKBDSdOgy4NEcbSzHg==
X-CSE-MsgGUID: YE83BYEYQ8iyqxgnDcNDiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,198,1774335600"; 
   d="scan'208";a="284485829"
Received: from ettammin-mobl3.ger.corp.intel.com (HELO localhost) ([10.245.244.123])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2026 00:17:51 -0700
Date: Thu, 11 Jun 2026 10:17:48 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Petr Mladek <pmladek@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Andy Whitcroft <apw@canonical.com>
Subject: Re: [RFC V2 1/3] lib/vsprintf: Add support for pgtable entries
Message-ID: <aiphHAkLnG_L2kY2@ashevche-desk.local>
References: <20260610111339.2465922-1-usama.arif@linux.dev>
 <919d334b-16a3-4412-82f4-b4cd6a35be0d@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <919d334b-16a3-4412-82f4-b4cd6a35be0d@arm.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 010D48000B
X-Stat-Signature: mo5u8hu8xykfwcj6314siop37t6adgmh
X-HE-Tag: 1781162285-26223
X-HE-Meta: U2FsdGVkX18fSyv/lnKMSbTIyIMXxY4EMtlcWDAMGU0TcD0uq7okbuBmLOcYWvB7oZLNpYFduBVhgroL0/QvW7m/JASYitns6VdMSsqvvcPrrrSPmOpCZmi9Qxdvsi3fWxAiNlbiyQmTIiE51fPjmsrMnYrYHBkTDM0lteIRUwT7UR2DUVrEhzucQGhQZ8iZxPq/r/FOHDxustpsZWdimvYlgsgnzNhNZ95QE+x7824E/Ff2yOceG5ZAuAmiAAopcNuZO6KA3ECmaxHSCi+Tjj+DLFRBA7OUsRXeV/kGIh5jLTX6D68tqnrFbDvyI/VsK1R9Y2TLeB1A86dnTx/g68DnnSz5MBIy+volKIEkazpx7qcfXicBK+5WdJQohnT6azShj9rC6HHUEqjsQPNnZk9bE9JVBnuzphMGzKRArhsx8H/q6I7N9P64AgD7Pq1khOPDB+t0v+KHkPrOkvj0Qvc1YNXzSgcBpzcuo7HeBsVmrS5u59LceN0qPm2RUSQWLVGfq8dXhffuezSQe83mjIU3xCSWJ1gGJttCR8eFoTpsFI8GIDjkiFIO9c88WIltBf6/+MYTGZtuI0DbxI+f9Er3tA0jbdRBxKFP2+zKoasv/H8As51P6REAGZNyz3JNwLpoG51W9bcbV5jN+SPVYRzffxI0xc9luaisr0y60M12hSJCjCgZRgk5Fby4I0OTLISYVNvner/JeYuCiK0jFz3WOr3IQPIDZ+O72bovta5kGQpoE9GWMZeXb+kTalH2d8Pm592N7NnKuXNs74JwrGp4FsWxH7AzkWOFaJz0NWNDdgIH4V0ZQcF/nJiMiEoCH5LSTTaETOD7KBjgLNyX/SyK3R1VE+IqKestkBKsKPagmAFh+3Nd7FcUxfpIeFlwz7QPOmH9CsI5UabvMKYE+4GprXF4WhnGcEvEwwJlKh5d73iiyNWAx6mp/qpmeX+fSPp1im6BtGLvgn92Lk8
 pe0hnlXf
 QvrmHvhgVkkalNY2Bk2U1SmZwXFZmvau2/6N1JvIwfkoypztqKYGqBJUlhZMX81bqKOqqPI7DTrMYU9QifRnSsxnT+JkcDnkMX8aqyCq+iBRkKlhW6g9z4yL98H3nEOWuGhAnyQwplzQUugyKB49TWvZdr749mN/kkVJyw5+8zfBRuSGd0Er6WtAptMzUZLJ3ybHTvWGEIjChbjqDOIJbF/GfWR3Z3pRqHZuKHmpeJWAijEQ91x/S29qqfHwEKKWUM4Ze
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 10:45:01AM +0530, Anshuman Khandual wrote:
> On 10/06/26 4:43 PM, Usama Arif wrote:
> > On Wed, 10 Jun 2026 05:35:43 +0100 Anshuman Khandual <anshuman.khandual@arm.com> wrote:

...

> >> +		static_assert(sizeof(pte_t) == 4 ||
> >> +			      sizeof(pte_t) == 8,
> >> +			      "pte_t size must be 4 or 8 bytes");

Besides occupying too many lines, why are these static asserts hidden here and
not declared in the global space? More wide Q is why they are needed at all?

-- 
With Best Regards,
Andy Shevchenko



