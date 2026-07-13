Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88433C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 11:37:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65FDF6B0005; Mon, 13 Jul 2026 07:36:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 611516B0088; Mon, 13 Jul 2026 07:36:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5294B6B008A; Mon, 13 Jul 2026 07:36:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2D8F26B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:36:59 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BB27D120116
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 11:36:58 +0000 (UTC)
X-FDA: 84983551716.11.5A58BC8
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf31.hostedemail.com (Postfix) with ESMTP id F1DDE20007
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 11:36:55 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UIDiebbC;
	spf=pass (imf31.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783942616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v6GzBq3LuxqUXy8baw9VZmxKu5h9isNi/tCEHcqMqrU=;
	b=vYVh8EMtwu8Rmjrr5prQnJG1zDVWWQvepGwAjVPfOPAPU89e1rJHh++RXI3tQNyr88ExlS
	s6DJ5KPhZV0SjaAHq3DhzAj0kEhgPko7oIjHKsC3idofB8BaeUAqQ4TE/SnYT4uWN+WdTI
	qc3uxvYVp7bALvQIJiIR+cP6cGeeBF0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UIDiebbC;
	spf=pass (imf31.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783942616;
	b=2DjnRBE4RH/7O+oXUmq9Rr3pBbFmcGWIwIVgMDnjKCMy3ShxBHYq7TxKHrurpzOSq+Tpdv
	OLwsSZIxH1jc8m8vkFSpu2ryv4JmxP6HAVWrs/k/jSFfBnUsT9J5anwxHtGYXdsPTTJ7y1
	JstBc+p7HaiNx+dG/9uW6ekRtU+eNt8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783942616; x=1815478616;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=n5UuU/aRZLo/pGJ5FmIUsayUkgQ1F1cb/IBnmdJ/Ahs=;
  b=UIDiebbCTXgqA7+amAWWr9drSu5vjoiCBiATVerqo1eVRhDjONTQrfwe
   EJTN0jPOh3hfozC90Mf894LIvQd3TkqaKbBo9QPekGDdl6vxsmGmFv1KT
   Wm/p/c/3O0/0uOTYs463NqCenE36UdPJiuLC04WOWWxcU5gyvj7TJ4j7e
   KC7ywA9z5hWAWPxJ8zUQPXQJPZMh6rPu6CxtK63BVuigoX4/4KrKtzU/s
   JIskUjRHlcbe3Gv/P8akmYaFmnDB2mU9qjWNpXM30f/R8BkoqQbecA5Zh
   ONXeomqDg5QRqXERt3BDu1+3IPI1GQ5GsTaz5jkiVwdqLhJrNcawZQTF9
   A==;
X-CSE-ConnectionGUID: UW19icAcToSPTqOEHpcMtw==
X-CSE-MsgGUID: Yr58Hp78QWeY0pmzfhjPUg==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="88452602"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="88452602"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2026 04:36:55 -0700
X-CSE-ConnectionGUID: UXwbby/pTku/vCRV/hTd9A==
X-CSE-MsgGUID: kNAWKrjtTQSPp5amXCCIAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="253791771"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.245.88])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2026 04:36:52 -0700
Date: Mon, 13 Jul 2026 14:36:50 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
	usama.arif@linux.dev, hughd@google.com, ryan.roberts@arm.com,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] mm: Standardize printing for pgtable entries
Message-ID: <alTN0i6XgnI_eDoh@ashevche-desk.local>
References: <20260709044334.1741263-1-anshuman.khandual@arm.com>
 <alHNjbiWFYXSPZtY@casper.infradead.org>
 <5ee8783e-4deb-48fc-a4c4-96b02d79a6cb@arm.com>
 <e0421ba6-82a5-4c88-b5db-23231c265142@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e0421ba6-82a5-4c88-b5db-23231c265142@kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F1DDE20007
X-Stat-Signature: ych6fc6gf79jkt9udjhfskydsoea8uaw
X-HE-Tag: 1783942615-313266
X-HE-Meta: U2FsdGVkX1+pmGr62GrsnU/NyDPix/JhOCv4P7RMPv94y/S1eI3AH+q4JIq9CubN7zY9MB1QEc49cndWlu63CCAeJiGLMRkoYqKEkzZ1SyDJ5GU+7b1E5GIl6LRQCuZy/yU1037wPSXvu73WMGWx7/Xi7miSKUQs4ZuJmw5wkFyc7fZOZ1UeNnZY5MbBKySUk3qKSvZNWaXtbfJv12x5a7IviAHIjr387lbM5KFUKFPYygGZ0kSrhIf4bNfrxnPKoLsSFyJNt/h0HDlr9D/XwJFnbtK04FDUDgGCVHQgt1pTjqm3nbpjDQwkavB9tAaDp+IO+4pwQfs3xIErHQET8Ge1o9OG0+ludhbd0Wbt3web2T96PmA72ILEqbQ1NGC8ZnbbLrgkfA+uyjdEWw9+loUQvjrunRLTs0w0LgdNCmCGFMu6V8Yeqzqe64lHr+n5tMvwLo9/rkw7PJUG7xVuzN+6xlnsVO64AQvBYi2+6ja5HtGJtJ46tKX9L36cvoHLfAOOSCVXxV4nmJG/47IIjQCIXwh4/sf7f6xouFOSGBFsSiE9Zj4TRXn83aIbgrPbGtoRrwCr4OiItRQ34BRRDMBgOTGaB8E4Q39t6UO+gAURdO84E/WfHDU3i5q8lzWOI610/9VlwwPsvS1O57FVCL0MGB1q0cowvb3Gs87rRsUQjUXoSf4EikEydyC75tssw2JXEAKeAvNuUW/Z+20BgumeGHBJOl0rETO3MLNrm88FbqlOfIjpaHQ86Ntbx8TXYNfN7QLnUhAhFpZy7tpL9eOmEHJE42Q2eAjME4fA/oVaJymeyAAsACY37dWeBLFyxO1LkvidxfQCrBjSf1fp0T34/K9BXqmIXXqumgFpSoxX2gAunNv+V1mMa6jMHPoKfnamfLPiMM15l7sIM778o8IrwSP01L93JmPoL/u9NRBGCYEh5z42CgqlhQG4g8TIcw2sUDMjbXIdoP0P+o/
 L1QJnUtE
 eK9nJX9evJgm+xwL42rueoV0RevzpyVdYGjsvKTBDwTyy3b+THwn9e0uASllhA62LRCqOaTKCXPLvMY09wxE4Y7JiflXM2BEpfbMfIo5vq6ItauM0Js1iLUCNUK1YRpwTK11dkr0UTvCbS4vRh+LWeOH7tSeUbtyNPh4Lu7FwFSBfj8POHEGmoDffJx/7Adnyap7H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 11:30:08AM +0200, David Hildenbrand (Arm) wrote:
> On 7/13/26 04:37, Anshuman Khandual wrote:
> > On 11/07/26 10:28 AM, Matthew Wilcox wrote:
> >> On Thu, Jul 09, 2026 at 10:13:34AM +0530, Anshuman Khandual wrote:

...

> >>>  	if (!pgd_present(*pgdp) || pgd_leaf(*pgdp)) {
> >>> -		pr_alert("pgd:%08llx\n", pgdv);
> >>> +		pr_alert("pgd:%s\n", pgd_str);
> >>
> >> Why can't we do this as:
> >>
> >> 		pr_alert("pgd:%*phN\n", sizeof(pgdv), &pgdv);
> > 
> > %*phN dumps raw memory bytes and will have different formats on little
> > vs big endian platforms which is not desired here. Debug print here is
> > expected to report pgtable entry canonical value where various platform
> > specific fields can be inspected.
> 
> If we'd want to go that route I guess we'd have to add a new specifier that will
> print the pointed number in the size specified by the second argument. We could
> start by supporting 8/16/32/64/128 bit only, no weird stuff in between.

FWIW, we have hex_dump_to_buffer() for that already.

-- 
With Best Regards,
Andy Shevchenko



