Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E3E4CD98C7
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 18:59:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3386F6B0005; Thu, 11 Jun 2026 14:59:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E9466B0088; Thu, 11 Jun 2026 14:59:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FEC86B008C; Thu, 11 Jun 2026 14:59:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 11DF96B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 14:59:15 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9119C1207F2
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 18:59:14 +0000 (UTC)
X-FDA: 84868544628.08.AC7F919
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf21.hostedemail.com (Postfix) with ESMTP id 83A6D1C0006
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 18:59:11 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OJW1yV5a;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf21.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781204352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k8dBWt/oGoh1Xn/oZrlXmV4fcwbv9YIOMebY2O4eJ6Y=;
	b=1RhFNK4l//b3n5TlVmjp73fB9bjlCFWrGAHO6TpIa4faMS5YH/0/ILKPCOiHO2ckxVj6ko
	ZE1kjv7V4WU3UfHrmEg5OU5HI7Jzk8Ks8NetcaTxgI7lBiDEAKjCn5b2LMxiZeP2aVnna5
	8pRbFV1Dy0/ABaM3qmzFKnelxE51b9E=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OJW1yV5a;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf21.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781204352;
	b=c2Lzh7wTYMdGT5ljPDMK2grLDCEvxar2ejndZ7U2lBgnv1CYYQQx9mpSReiUb0Pdk5BPrO
	T7aO9dNTBAnxqbCOuB/Xv0l916yvlbdHETez2xtmgeZkjdcaJ7auovLjSIrms/rySWHx0D
	OrhlZhT9Ukz4Cf6ZDbzt1wwsMLSYxNU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781204352; x=1812740352;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ped3/J9XwuIr0qZ0sei087J5PdhotBQSVWgj2CMhKfw=;
  b=OJW1yV5aBdMA9LGPm/SoutvKPyL1JWNv2OrpVnqR2rBktT9DqHTlIc36
   PWa2SEnlAf5Eqw1j5axxmsHrU/SFGQK0pThTqnva0O9yalUf5pSGpIaS6
   rfcbWTN4UXB5LaKt6tjFFbHkoYhPdI7D751tsZOc+FLc2j2F2d8aeyg6c
   R3SYIaD5Mmj6m2m8HTCa9lkVSNw4L92thsZdOM65cKHmgFKqwH6s6EYqo
   7yFgFCAv6OwpN9WBBZL9TnfTQumaHw43wdoiPuracxDGB3secrTOKTbuS
   FEM1VtXO3N6HWhB67AIKe9ekoWL7WGkCLX35zFA/GFyGk/qggay2IRwQ2
   g==;
X-CSE-ConnectionGUID: 1RgS18UBT3GLYGIg2FKpng==
X-CSE-MsgGUID: lYg7/pI6Qimc4qC5AaDknw==
X-IronPort-AV: E=McAfee;i="6800,10657,11813"; a="82035074"
X-IronPort-AV: E=Sophos;i="6.24,199,1774335600"; 
   d="scan'208";a="82035074"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2026 11:59:11 -0700
X-CSE-ConnectionGUID: ZSAxKem5QyWfGsJvA+FU3g==
X-CSE-MsgGUID: viKcMwSuTOW4jm/PUd5eaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,199,1774335600"; 
   d="scan'208";a="250515081"
Received: from ettammin-mobl3.ger.corp.intel.com (HELO localhost) ([10.245.244.123])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2026 11:59:06 -0700
Date: Thu, 11 Jun 2026 21:59:04 +0300
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
Message-ID: <aisFeD-VXF7JIpG-@ashevche-desk.local>
References: <20260610111339.2465922-1-usama.arif@linux.dev>
 <919d334b-16a3-4412-82f4-b4cd6a35be0d@arm.com>
 <aiphHAkLnG_L2kY2@ashevche-desk.local>
 <d41a24c1-592e-495f-8adf-dd538b769904@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d41a24c1-592e-495f-8adf-dd538b769904@arm.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 83A6D1C0006
X-Stat-Signature: mqji68hdc95bu5wgimdw8jsf14y6ocd8
X-HE-Tag: 1781204351-427241
X-HE-Meta: U2FsdGVkX1+0Ktq7EOXmXtIaT2oMj0vjuGiN+V2ye91ZsRV5Igenn18qMi1pDQ4xLvzwoBjl2oDw8+/Ol2aq+DZ4qoofw9cTytaBht5Ei5PxTsMfzGc3/8NIF+Klt6z+/i6iR5E4xYcN9rvn1TbJfBExxnl68t7j/gc8CosnjFpc3nZEPpRl/D2K6UBUnHlYdSL0IHdKSezDnb8EpNte32Qe9lAopPsv47U1gy3D1fOjFxV7bXqCkkn0qOBIX6VMbtxLN+sNE87gV1Bbaaw3lGkCsn32a8MRGCZrWaG0ZAsuRg7jhy6odc9FNu3imU9uHNqQkDvn5GEo/0vFeCKLacYwLFbPbQ/HL+3mGB9v9+V5hGuqA2Yhz9iJ4fn6JFjgqBnWaQjOr3vGFMtG5hixnSxiMqKWXLT1m7Ulu+mS0IG2vJkZ+Uy/m3o7FSNYr2J7PTdBdmk48PqMn/qgX7UZSooVuFNPUqXKJ5LdarJppCdo/Jm+Mvs/8S+lDDUbYPkp8nCiw1wLckdaUU9P2TB3OLz0Eg0KplqhrcdFdt5FbLa1+L+WTiMM3Wqm2u78c8yMj7Ws4H2E0UjlPw5rd3E7pacqZkyRay0dkBZQ9PnychvJMISdDnwOPgEQIr1Z3SoubKGM7X0NoQPI29lG68upl7OrPaRHxRGwU9uhE+mzJiziUXrEKuI9UVJpOOM2KgE8IvsHPGrCXJITTvVI3fb7e1jW4Z/wJ3EArMYaBKEm9NE8IbOTZDBVLA/oN6+bXF12nSvf5BpBh9eUAqkacudRZhPoTehvTdVjBDM58DE3cybU+5eI1f+oC+LaelTAh1YT6H0BAaqml2L6/laGGg8udVUqmXdU2eEkMVQFHKaWWdkzYNtu8HDfLNQmXCkvLs1r57AmEwwYIS81awdyFhvhWv89fliBgMsiu329jdBflGgR0hKpTEmONQDpitjn+qn45kXsDEZqD2RZfG2nsYQ
 Fc/YtuN0
 pTa99wI6bvlVY9J5RpC80wpwtelFELjsXuwCok+hIntjBPrksH9H+mfprUCUffvi0/4KP5FlZNsH/cHaoG4CKmcCNUZgIXZO8d53G0YgN61nJzotyRbCoPNxuILf4yViEEpzijuwr8I+vSO/1vA19O5n9uI3ZoDCj4yE0kEhSCpGPU032syxHz+4VPlpAJ37nPE0JEi3KDx8jYt4Npf85sCkXCZ4rHYd1AdhUqdEJ5PvcqNP+xpmwwDuI9Pucvn8aNr7T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 03:20:13PM +0530, Anshuman Khandual wrote:
> On 11/06/26 12:47 PM, Andy Shevchenko wrote:
> > On Thu, Jun 11, 2026 at 10:45:01AM +0530, Anshuman Khandual wrote:
> >> On 10/06/26 4:43 PM, Usama Arif wrote:
> >>> On Wed, 10 Jun 2026 05:35:43 +0100 Anshuman Khandual <anshuman.khandual@arm.com> wrote:

...

> >>>> +		static_assert(sizeof(pte_t) == 4 ||
> >>>> +			      sizeof(pte_t) == 8,
> >>>> +			      "pte_t size must be 4 or 8 bytes");
> > 
> > Besides occupying too many lines, why are these static asserts hidden here and
> > not declared in the global space? More wide Q is why they are needed at all?
> 
> Sure, will move these static_assert just above pxd_pointer()
> These asserts ensure
> 
> - Platforms have either 32 bit or 64 bit pgtable descriptors
> - special_hex_number() can be used to print such descriptors

I understand that. My question is do we actually _need_ them? In other words
when this may be not satisfied? Any real (non-theoretical) example?

-- 
With Best Regards,
Andy Shevchenko



