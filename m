Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E1B5D711CC
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 02:27:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A07016B0088; Thu, 18 Dec 2025 21:27:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98ACA6B0089; Thu, 18 Dec 2025 21:27:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88CD56B008A; Thu, 18 Dec 2025 21:27:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 785C06B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 21:27:31 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 15D42B908F
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 02:27:31 +0000 (UTC)
X-FDA: 84234634302.04.F827A3C
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf09.hostedemail.com (Postfix) with ESMTP id 419C6140004
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 02:27:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NmJiCbKM;
	spf=pass (imf09.hostedemail.com: domain of ricardo.neri-calderon@linux.intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=ricardo.neri-calderon@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766111249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6OyrFouoL38l8VVJiTjFw4GnHbq8fo13uOm+Ly7qRpg=;
	b=Uoynj/4ZbSYfxj3nuj8kxVTblYuU3xawfnq5YAGvdbjEGS1Km3l3ROFP6FLPqKdj8XL2S5
	qsUR2jnd1wvZApWBmPhlVwTZD/E0BQ+gogwBCWbXZUS8a24+F0hXXdqMwStmwlqUsLh4in
	P2SQQCwu0JPlzCJwOwv097A8tdZGz/A=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NmJiCbKM;
	spf=pass (imf09.hostedemail.com: domain of ricardo.neri-calderon@linux.intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=ricardo.neri-calderon@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766111249; a=rsa-sha256;
	cv=none;
	b=Rm+dh0ZIRnx73yUGWAWHBtjoFrwggqaSN8S1IOJvqcodOPH2wZPLybimRsBarmr/XygLX3
	teKhiQ9VAIHQGyVZgC9SqxYUZcipGF9g5NLn3+6cH8s2Tuq1wYmSLw3wPRdvGJ+iAfovt+
	Ug7v2hNNZQ7OtuUydY9ftxvB+jmcdpw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766111248; x=1797647248;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=dgyZ1SYYxbkXsRSaMQJDEWAQojccW/3/f0lWLPaWOz4=;
  b=NmJiCbKMd7kL8HP96Nba/jfzl1D6EaQ7KJ9qTvgnJSP3v7BnYEgFefgE
   M9tyupjWaQOHsrCVRCnZNUUsO0lceYeBUkZbMHpwJhvD1426x2lCynjO6
   hpLxDtZhixLTd2oU/vZUlQG8wugVKTxgN7/G5DfzC2d18ablfxW7aiEPi
   RBC7mjxS1RDRVFJSzJq3Fo2nDOXKBVqi0+6W2VypTwFChqMG+c/ljPlnZ
   QT7fPiegNS2BrqYv7V3Xf/TbUrXQumtJLD+9Iwlo8RhX7mzzZWZe55wP1
   51IR0+6T+4au98TwLu9B1atuot+jZUWmO/j7JLRs6hd6WIbXD/1XBDu5/
   w==;
X-CSE-ConnectionGUID: TBIDfeQtQpi3/SKgxcCrdw==
X-CSE-MsgGUID: Hu1E/Zf1QwSDka98iVYXHg==
X-IronPort-AV: E=McAfee;i="6800,10657,11646"; a="78390294"
X-IronPort-AV: E=Sophos;i="6.21,159,1763452800"; 
   d="scan'208";a="78390294"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2025 18:27:27 -0800
X-CSE-ConnectionGUID: EFGqsiXkQ6KiBY6ZIPhLRA==
X-CSE-MsgGUID: JO9Z8eITTyS0SstkhI2Wiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,159,1763452800"; 
   d="scan'208";a="198645971"
Received: from ranerica-svr.sc.intel.com ([172.25.110.23])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2025 18:27:27 -0800
Date: Thu, 18 Dec 2025 18:34:08 -0800
From: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, rppt@kernel.org, graf@amazon.com,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	linux-mm@kvack.org, pratyush@kernel.org
Subject: Re: [PATCH] kho: validate preserved memory map during population
Message-ID: <20251219023408.GA17600@ranerica-svr.sc.intel.com>
References: <20251219002355.3323896-1-pasha.tatashin@soleen.com>
 <CA+CK2bAOMooH+NE5YanRyfK0KraRug2VHT_M59UpbiD5T2qu-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CK2bAOMooH+NE5YanRyfK0KraRug2VHT_M59UpbiD5T2qu-w@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Stat-Signature: w8ri3afqeyou5bkm8imr6kkhxep537y1
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 419C6140004
X-HE-Tag: 1766111248-713092
X-HE-Meta: U2FsdGVkX1/eH9tx9AL4fx7TR4Vg2F0bkPHFyd+lVZBBiFgv9TIt9VBwy/gKcgxaL/2NoEUs1ggDzbro26aIMeoOrJZd+OgOY2QwgP8dPQujpTpjc77/r6vDX8fbPyaidtJFAqeiYcIYjv144Pa91dk6P1qmVDpfiCUN35nzCLgolX/d9oQusXFP6nFpFp9ZygSs/2YkQxhWtYJQVBkqgiDMkUmpDL6edHzSWg2PQzZ/JywkbkjdKYsCBb+QoD4m+xhyk4e1/rZjGqc/gR9SgTgCJcOmqrnnCfn0uXQlRdLwRFxkGP30iUUwaWNJytHZl9umYvxLdrnJv5o0JKz1GeItgOkSXd7x3t6Z/4FaVP6W9ASh1uQzbNrBgmH2N/yHbdrx9Ppg2AgT/0ekH9PYUvn+mlQKZsRZwyd92oJb360gBjDKobtceEymBRqSzy4P5BMJ0/en7KcqAwI6lfXO7aHHxchoCxonf/SWdlJq7yidcjWZLLxbaKv4SSYhlltROOgvdSFnkeWct7swajFhMWPsWEn9yfhLBjv5MaxlFwtPdogGt/dh2A49X1vTcAe6uXqEx+foBdIVAvH+fUjUBHAznWRrgR/mj2U50VCISyTXnBJ1cInVPOc9TQf+7xF+XAjuYuwdnXQErdJ/z/gaZMShlG4Zyhy0atmTs4Y6gQ1Y4sJz4IrF+ADp50M79oMMRsLJw7V+X8qh7dBLafOyZNJ0RKZlR9cTnuOjRN84IjWqrMga6F8hfvKvoE0rX6NDkJriiKEwNAikYi3/UbNTgKb6JFMoA60WnFoCCTWmAGoXdpPrLJ3hDND0TuIHcTVbzgVtnllOK2/TYUbUtl2/PcyQbxSj4MzoaOTNPicFpZICHmMQHCgM7ZP5n1zW8KmI1ruu07D0Kp7hDHuSPBPHWen7voUWiRooD3z6+KpPqsuh6vbOvsBOLO6ESNXU0eC/F45QeZK3bhFou0zIfGA
 i7ivsFeu
 hEYj2T6k5+kJlao7Hd5zo+zHtWIJhE0T4FYTcYkQL9xRzXOLuJXx1XvzFu+OoRQk3MApByIJbDFhHwYQtXmUbuLO3bNvqBFfzK+IrbQX1PcZi0AX1E5wlxdTGzJgiABhinHQhoFO4qeNxQZ03gs3B9hNCU2r64gpm87f4Gw/uVwhS8SGa/ked4AMymvGbRSDYDlrZEDoSCuRXtszJPyc1ojE+3clYBLtlSv491u7L7VN9qBB+8rVuw1uAKK9tLxUxlzWPKspZWTEeskWmj3VAngTny6652LVcl4bdy6B2BmdRNL1oULKJv0ijtmzMKbpPX3Ao
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 07:49:11PM -0500, Pasha Tatashin wrote:
> On Thu, Dec 18, 2025 at 7:23 PM Pasha Tatashin
> <pasha.tatashin@soleen.com> wrote:
> >
> > If the previous kernel enabled KHO but did not call kho_finalize()
> > (e.g., CONFIG_LIVEUPDATE=n or userspace skipped the finalization step),
> > the 'preserved-memory-map' property in the FDT remains empty/zero.
> >
> > Previously, kho_populate() would succeed regardless of the memory map's
> > state, reserving the incoming scratch regions in memblock. However,
> > kho_memory_init() would later fail to deserialize the empty map. By that
> > time, the scratch regions were already registered, leading to partial
> > initialization and subsequent list corruption (double-free) during
> > kho_init().
> >
> > Move the validation of the preserved memory map earlier into
> > kho_populate(). If the memory map is empty/NULL:
> > 1. Abort kho_populate() immediately with -ENOENT.
> > 2. Do not register or reserve the incoming scratch memory, allowing the new
> >    kernel to reclaim those pages as standard free memory.
> > 3. Leave the global 'kho_in' state uninitialized.
> >
> > Consequently, kho_memory_init() sees no active KHO context
> > (kho_in.mem_chunks is NULL) and falls back to kho_reserve_scratch(),
> > allocating fresh scratch memory as if it were a standard cold boot.
> >
> > Fixes: de51999e687c ("kho: allow memory preservation state updates after finalization")
> > Reported-by: Ricardo <ricardo@example.com>
> > Closes: https://lore.kernel.org/all/20251218215613.GA17304@ranerica-svr.sc.intel.com
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> >  kernel/liveupdate/kexec_handover.c | 36 +++++++++++++++++-------------
> >  1 file changed, 21 insertions(+), 15 deletions(-)
> >
> > diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> > index 9dc51fab604f..96c708f753d4 100644
> > --- a/kernel/liveupdate/kexec_handover.c
> > +++ b/kernel/liveupdate/kexec_handover.c
> > @@ -460,10 +460,9 @@ static void __init deserialize_bitmap(unsigned int order,
> >         }
> >  }
> >
> > -/* Return true if memory was deserizlied */
> > -static bool __init kho_mem_deserialize(const void *fdt)
> > +/* Returns head of preserved physical memory chunks pointer from FDT */
> > +static struct khoser_mem_chunk * __init kho_get_mem_chunks(const void *fdt)
> >  {
> > -       struct khoser_mem_chunk *chunk;
> >         const void *mem_ptr;
> >         u64 mem;
> >         int len;
> > @@ -471,16 +470,16 @@ static bool __init kho_mem_deserialize(const void *fdt)
> >         mem_ptr = fdt_getprop(fdt, 0, PROP_PRESERVED_MEMORY_MAP, &len);
> >         if (!mem_ptr || len != sizeof(u64)) {
> >                 pr_err("failed to get preserved memory bitmaps\n");
> > -               return false;
> > +               return NULL;
> >         }
> >
> >         mem = get_unaligned((const u64 *)mem_ptr);
> > -       chunk = mem ? phys_to_virt(mem) : NULL;
> >
> > -       /* No preserved physical pages were passed, no deserialization */
> > -       if (!chunk)
> > -               return false;
> > +       return mem ? phys_to_virt(mem) : NULL;
> 
> I need to update this patch, phys_to_virt() should not be called from
> kho_populate() before KASLR is initialized. This causes a problem with
> my live update test. I will send a new version soon.

Thanks for the patch Pasha! FWIW, I no longer see the issue I reported.
I will test your v2 when posted.

BR,
Ricardo
> 
> Pasha

