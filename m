Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25BFAD70E0C
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 02:37:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9302A6B0088; Thu, 18 Dec 2025 21:37:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 908106B0089; Thu, 18 Dec 2025 21:37:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 834946B008A; Thu, 18 Dec 2025 21:37:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 739676B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 21:37:05 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 05E26134DA8
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 02:37:05 +0000 (UTC)
X-FDA: 84234658410.22.7090E4B
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9729380009
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 02:37:02 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Q3rR7OQv;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf02.hostedemail.com: domain of ricardo.neri-calderon@linux.intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=ricardo.neri-calderon@linux.intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766111822; a=rsa-sha256;
	cv=none;
	b=m0Jov9cZhfg+dHkGgxHQq+4rAj82GeOyI88tNttWRl4ldvXjNtj+COAdgYm07C5yqd9xV1
	cCNqp5bmx+MTA7jk9IkuUTGK7luFjP7Pf2HOxrReaMKd5AgetRdwjrQLaPV78BMSXpznUe
	1pxpq6SereXNmZ1MluowwNRz9ZgDOeU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Q3rR7OQv;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf02.hostedemail.com: domain of ricardo.neri-calderon@linux.intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=ricardo.neri-calderon@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766111822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R8WSwda8aCwUFMf9p9V9U8flnGon/LLI3QQDyLCvne4=;
	b=d1BGcD41g/B4xUmNt+VcU4PZyuZsPiG3sl4ExcWKzYnxhWyQbUtWnlk/oDsEsl2ihWBWPj
	nHAOlkDfCEbvcTudrU5ohcfhFoOeNnmOj1XvP88yNKnK7pCcMzAKcR/7P++mThwUJeTvDm
	W2EjeU6V6ghd5gMsRIGfTa0HtR6iv4Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766111823; x=1797647823;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=X+YwzWCOh60oHo8bc6TUp/24v2nNpKPQBBb0/fSOWYQ=;
  b=Q3rR7OQv6Lr5URJgk7jpYhW2YyheLHr2PZ1AQgT36KZW/5DbW4eyx+gO
   wn/PzCFZAqXAn3F2YQTyxzq0ENqiWfdnk8s5gOJSwqialvAkFvNkAQdwr
   uH+atcgHf8+HjXQtcGrYcxD/LaUyQ8FZgBX10+eDJWq/L3tyUxjUXE5pP
   tlDIxmw0j3aZNnrHpiaimqVMyY0HjlLLT4Q0FjQpF+GwKcXfrc+L5lNZO
   imKYbQgMbYn7GgzYLBCOr3tXkg+UjFxV5RffIk5t+goc1jW7iySZjhNpO
   lBTrf9+5EHDzwujm+70hXPOYmeSjj8EOKhOh4B0E3mPhA8Z961GkkRAm8
   A==;
X-CSE-ConnectionGUID: NexzWov8QVCq5Dh23762Ng==
X-CSE-MsgGUID: hQj6ILo8T0GVKLYmgZrEtQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11646"; a="78390938"
X-IronPort-AV: E=Sophos;i="6.21,159,1763452800"; 
   d="scan'208";a="78390938"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2025 18:37:02 -0800
X-CSE-ConnectionGUID: be/p+YKgQL22VTnvotngOg==
X-CSE-MsgGUID: TDawHjBaRnSr63HrEZjweA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,159,1763452800"; 
   d="scan'208";a="202918593"
Received: from ranerica-svr.sc.intel.com ([172.25.110.23])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2025 18:37:01 -0800
Date: Thu, 18 Dec 2025 18:43:41 -0800
From: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, bhe@redhat.com, rppt@kernel.org,
	jasonmiu@google.com, arnd@arndb.de, coxu@redhat.com,
	dave@vasilevsky.ca, ebiggers@google.com, graf@amazon.com,
	kees@kernel.org, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	ricardo.neri@intel.com
Subject: Re: [PATCH v2 11/13] kho: Allow kexec load before KHO finalization
Message-ID: <20251219024341.GC17600@ranerica-svr.sc.intel.com>
References: <20251114190002.3311679-1-pasha.tatashin@soleen.com>
 <20251114190002.3311679-12-pasha.tatashin@soleen.com>
 <20251218215613.GA17304@ranerica-svr.sc.intel.com>
 <CA+CK2bDucySNG7QqE87bZndgjKH-QCw61romZVExD63S2iM6og@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CK2bDucySNG7QqE87bZndgjKH-QCw61romZVExD63S2iM6og@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9729380009
X-Stat-Signature: tkhmkwxskwc4cia4tr867etdj5h831ps
X-Rspam-User: 
X-HE-Tag: 1766111822-547349
X-HE-Meta: U2FsdGVkX184UCcYSNwW/ln39N45LvM8faPWcOABOO5dkGXLqVbcYtKQPhqYKErZos0ckmcLkQnX/9KGwIga2m7YQddHTTGqwEqoin5IN6nlMY0L6OpMHC9C/6v2IHLqeHxdevsrC2EGGQ3spt9AHFNdQ1Bej4f64qEoKfi95KAJ+QdOvJ2IP5U9ZKdO0apeeR4kimdZJ3tqC7WxpGIZfrM4KBfmcQ3LRCd79IlEPk9bpfuNUgySScf1CZmd39vhlewHYACndBYKVv3EW7QY58A2UuUov4dw0e6E/Mram9qOrsNw4JktwqMx3rJbCdstEY9GsxUXJfAOGVvfaGaGhIPeLZXuSbxkOu8z4Plz2vMiiWYTIIhN7alVaIDSoepNwg7lLCTpjg6c5Dge3u0wuQAhYzOBKpvlHCEQxTbL6CX0HsAMGv972+35cWii8W4VktnlvJlf/hnLgouLC3eMV/azO9Vt82lLuoHnIHpR8WhTqVAETnB+bR6tuC8cLEQrbrUvt57vbFJqAG79n8vGug0fynv3ZJ/xmgY8bPKiFSrqRRA1Zy+uc1Fj+8tTOaXkeumpYkCwzuk6IL/hdepO5KhP01ihqMPnW3OtLvx30oVI7TgqalsqHYnHt9hE8bQENckD+P8T7cqXUNu0PiYxv46wR9p4rCu23f2il0UoGrR/YWCkshJdEDq2l8HqX6YUFD6ZlKSma3UiBb4IVhM4AEwg8Qbx0z0Tyrv7Vjzz9QBqFKqG14ebFs3AsMCEg5g8lJOEXN3Dr0HYRurpU1joJ+3qdtMJXpznInyzs0mDijy/8P1XJ7k+JFfWeL5kqokvn81owGZmIv76eIYhTjIAKeOA3cKXgVjQRwKUbV8+R5jVDegegFqKftehRYJhqKMO+jIhSAQA2X1HoBF09g+7uajw8qdhi5PspyIlRvbIFXWaqfP/UuLa/z7eVm8wDiTKhB7whcQoyaRqKGMg9Q8
 C+jpwR1y
 TDiezjPP7L992zC9OOcSgWZnwJpLw0i+TBKURcgaK809+Bz4vbv/PknDW3oJQTiGS91M8riFhdSrcTrf0U3TdOAx56zwl89LnNiAY8Y/Ay6nuiEhl+hv5uBjRQee6x/UChW899SOPYNuy6kKOT65q+nJHaDDe0j6L2aBoa/i5q1ESPEhe794mjXSzbWPh8HUygxyy9O9HMcuexvG5T2i8VNy3UGjVFihpeS2HsJXsKa0t4munaJB3am6xmWvCnao2ULf7FAsQk2JMh0mHzho522wC7/A3/C1Q429gq5rLnYNQ6YQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 07:26:19PM -0500, Pasha Tatashin wrote:
> On Thu, Dec 18, 2025 at 4:49 PM Ricardo Neri
> <ricardo.neri-calderon@linux.intel.com> wrote:
> >
> > On Fri, Nov 14, 2025 at 02:00:00PM -0500, Pasha Tatashin wrote:
> > > Currently, kho_fill_kimage() checks kho_out.finalized and returns
> > > early if KHO is not yet finalized. This enforces a strict ordering where
> > > userspace must finalize KHO *before* loading the kexec image.
> > >
> > > This is restrictive, as standard workflows often involve loading the
> > > target kernel early in the lifecycle and finalizing the state (FDT)
> > > only immediately before the reboot.
> > >
> > > Since the KHO FDT resides at a physical address allocated during boot
> > > (kho_init), its location is stable. We can attach this stable address
> > > to the kimage regardless of whether the content has been finalized yet.
> > >
> > > Relax the check to only require kho_enable, allowing kexec_file_load
> > > to proceed at any time.
> > >
> > > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > > Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > > Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
> > > ---
> > >  kernel/liveupdate/kexec_handover.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> > > index 461d96084c12..4596e67de832 100644
> > > --- a/kernel/liveupdate/kexec_handover.c
> > > +++ b/kernel/liveupdate/kexec_handover.c
> > > @@ -1550,7 +1550,7 @@ int kho_fill_kimage(struct kimage *image)
> > >       int err = 0;
> > >       struct kexec_buf scratch;
> > >
> > > -     if (!kho_out.finalized)
> > > +     if (!kho_enable)
> > >               return 0;
> >
> > Hi Pasha,
> >
> > Using v6.19-rc1 (which has this changeset) and with:
> >
> > CONFIG_KEXEC_HANDOVER=y
> > CONFIG_KEXEC_HANDOVER_ENABLE_DEFAULT=y
> > CONFIG_LIVEUPDATE=n (i.e., nobody calling kho_finalize())
> > no reserve_mem= entries in the kernel command line
> >
> > I omit doing
> >
> > echo 1 > /sys/kernel/debug/kho/out/finalize
> >
> > before doing
> >
> > kexec -l <kernel> --initrd=<initrd> --commandline="$(cat /proc/cmdline)"
> > kexec -e
> 
> Hi Ricardo,
> 
> Thank you for reporting this bug. I created a fix here:
> https://lore.kernel.org/lkml/20251219002355.3323896-1-pasha.tatashin@soleen.com
> 
> Please let me know if it works.

Thanks for the quick reply, Pasha. Your patch does work for me (I saw you
will post a v2).

From this patchset, I gather that kho_finalize() can be called multiple
times and in-kernel users of KHO should call it when done preparing their
subrees. Is that correct?

