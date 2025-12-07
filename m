Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6220D1CDC6
	for <linux-mm@archiver.kernel.org>; Sun,  7 Dec 2025 14:57:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC63A6B0005; Sun,  7 Dec 2025 09:57:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A771C6B0006; Sun,  7 Dec 2025 09:57:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98CD06B0008; Sun,  7 Dec 2025 09:57:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 85D226B0005
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 09:57:50 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 22A1C133F9C
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 14:57:50 +0000 (UTC)
X-FDA: 84192979500.17.2C28ABB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 727C3120006
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 14:57:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EnNrsX5+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765119468; a=rsa-sha256;
	cv=none;
	b=hQZsKlx5/TM0e6aB3gaPxYdWg9weDAvPgd+lTexUTUNPU4ndkLH6CrdzlhmUqtVQlsfqqC
	WDzbaCwoNZtx9NUHDjwKB1O0ACdufKZPwVFYdfY35+1iLEmI1sVv1byy7A7v4SEMcO0APY
	oyc2lHdYmO3FADQGwWs1O9seLO2m2OI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EnNrsX5+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765119468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C56MF172XY1GDwBfpRSZkCRosrc6ArxrPT0WKkTHLiE=;
	b=MZUHxLzCd5PGUfrSTGDL7kdfWG2G2xalqLCzFsYI+S1jGiWN9LMXCKX1K+AA24Jd1yxuhH
	0p2rVSZh9BSq03O9o029lSY+m5txGwCHG0iFWTQ4Qf1vYYQo1Nu43XcFEtzqubMTIvmqlb
	JdPQd9EurLrXN5ebShafxrZ0kCIcd5k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 198EE44362;
	Sun,  7 Dec 2025 14:57:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DC7AC4CEFB;
	Sun,  7 Dec 2025 14:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765119466;
	bh=enXFBL70rkMnLzna7QiJ+POgzsVU0iKhU+yZQwRZaXo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EnNrsX5+6w4sCseBHAOR0RSAs2U5X+MFEESUoz+r89S7pcYSdoaWgYgIBDgNdJ7gv
	 05PFwFSPxSh1ZBMn/4MWwJOPIRGQZd8AIVNHNqOZpmSN6p+9R8DMTUf+di5A2uWQeC
	 7/BoUJnmi/D5tHyl5D1Q0WuaUDUOggRKN9tMgKigRmMWZkk9XQyJkd1kKEV0RySINX
	 mLazr7V5s6xw+NX5sI8ScPYnI7aWn6qxuso49oliKMmsHUc5917Kgu8SHCGFZuP2Bm
	 umAZjmldgUY4QzdDrcMvadr0ZHjT342T4ozzxydqmp9Rd2B2I/asvoBVrSQAN7hUm7
	 2lhJZQYdNQ8Hw==
Date: Sun, 7 Dec 2025 16:57:38 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Usama Arif <usamaarif642@gmail.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Andrew Morton <akpm@linux-foundation.org>, kas@kernel.org,
	changyuanl@google.com, graf@amazon.com, leitao@debian.org,
	thevlad@meta.com, pratyush@kernel.org, dave.hansen@linux.intel.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v3 2/2] mm/memblock: only mark/clear KHO scratch memory
 when needed
Message-ID: <aTWV4vnTAYwoH1ZE@kernel.org>
References: <20251128173257.969322-1-usamaarif642@gmail.com>
 <20251128173257.969322-3-usamaarif642@gmail.com>
 <aSwFwMVyFcPlOR10@kernel.org>
 <CA+CK2bB+OQ-8CDdQfN3UFxUJR62ZjZkFB3dN43LYaXavewk_ng@mail.gmail.com>
 <f1ee34be-44fd-4286-8b02-f69d3a2dbd26@gmail.com>
 <aTHKaaeY7_HCswbg@kernel.org>
 <657d2356-126d-452b-ba7f-5c0761f4f832@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <657d2356-126d-452b-ba7f-5c0761f4f832@gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 727C3120006
X-Stat-Signature: xyzf6bh4k4r5jrjhduikk6wqk7oyuxs5
X-Rspam-User: 
X-HE-Tag: 1765119468-108129
X-HE-Meta: U2FsdGVkX1+22NKBHoPcyXqjhJj3vDrk1HWYL9cvBADno3+ZQOiKOyfd1xSPcWqPEtgRRaok71tD8qstUby7nw1k9ROA0/5XiLpt2zBHnXDQqJg7cNP5RVXEkEGUCtZw4mTxIqScmrDfRbf2FNoBaLHFBxnPHBd3uF2V1+ycDgo8lNfEbMSfYOZ7OhsP8r7Ixtobm4TrZBccLF+aXkCbV1WZ8IQh9UAthYhnX6DLw8/vEjV0gKSntdufbm3aOsLT2gOCR5BqG0MgyeETvZva2AiNtSipr9ZjQ2T+mXas/xcP2CZ1QaiUDA76ilkU8OOG4nP0CTLb5jBReVr5aCab5n4GkUgkXO04OL16/3Dqug6ty5pDNZU29T0lvx0gDIeqGz8jhat85ZpJhHI7bUdcxRE/7x3JJS6J+j+jGeplKkcao8kqJaxSH8qJkjcX8X0eDkjLhd0qtel3NzL77kGEVlbnixjN0EvkuE3UktjLOab3OMqKNxK/mgigSAfQwbOBaMdeBJn9RMQT2otRsnUIOF9YU1dtWwgBkwB/W0UFdEmmPe5ik07kKoMfAbpmacql7/SlzVNoxFsOWdMg8tKpbF3HDqXBsM95V7e0Fork2Chgautm4zcr30mS6Uq/PrCeAxcYHzcExHqWhlYBj49FEQS6wFxIjBsP4I801wDB3GyDY9t20m9d9X9kA9jumqOBe30sfc8Ie/Z3CquJlKq3DVB8vVq1ZHqMPT4BWIpyBpAFh4s3jsaktJ5fIVlIZsFg8YiNhOeGdc4s9y+WApBoO1/HLdlAXA7Aub3Ibwlrd+bUOqvZMkmqoYxDz/1/tq3cb7k1p0ndBA//hjeTvEDvt9ms2RGFA9I3zNfujcSgD8oQ+u53AQSbCqkVxLFE7uqS8VJto0Q8xBP57YpSoAZlNNzCcV7jgUOvXoQSEMaQbUg3AArj6XvbQzaXN9FnPkasBBnd8ZAq+KqbWYE4xff
 f3CG8MO4
 MauZm1D3W025bGRNySNtWWszqymDZepQJZM++CHyHulTPpFnxUKmnxlbl/lXhKwF4trNULiO+XQA/ck9MOcetRR/OAYicCYqLvY7O3hALtkAxBoV6XFWWjUdkBRkvcFLNVNiu5Bam2AHWL3PLTLFzyA95IsvWFIN9xOPOhLxAkU1PrCmJ9F9wm6g3ApJIpro/7GeIGNHNTOM2CQWHlEWnnMh3zF0TU7BKm+3+7GcSur8lsGLbmJttuTX2cNntUDVD47nE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 04, 2025 at 07:27:29PM +0000, Usama Arif wrote:
> On 04/12/2025 17:52, Mike Rapoport wrote:
> >>
> >> So the patch was designed to remove the memblock_mark_kho_scratch in e820__memblock_setup if not
> >> in KHO boot. But it broke memblock_mark_kho_scratch in kho_populate.
> >> Moving kho_in.fdt_phys = fdt_phys to before the memblock_mark_scratch
> >> should fix it. I dont have a setup where I can easily test KHO, but I think below
> >> should fix it?

There's a simple KHO sefltest in tools/testing/selftest/kho

> > This might, but this is too late for v6.19-rc1.
> > For now I'm dropping this series from memblock/for-next.
> > We can resume working on this after merge window closes.
> >  
> 
> Yes makes sense.
> 
> How would you like me to proceed with the fix? Should I send just the fix now,
> or these 2 patches plus the fix after the merge window closes?

The fix should come before the changes in memblock_mark_kho_scratch(), so
please resend the whole series.
 
> >> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> >> index 9dc51fab604f1..c331749e6452e 100644
> >> --- a/kernel/liveupdate/kexec_handover.c
> >> +++ b/kernel/liveupdate/kexec_handover.c
> >> @@ -1483,6 +1483,7 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
> >>                 goto out;
> >>         }
> >>  
> >> +       kho_in.fdt_phys = fdt_phys;

This should happen before the calls to memblock_mark_kho_scratch().

> >>         /*
> >>          * We pass a safe contiguous blocks of memory to use for early boot
> >>          * purporses from the previous kernel so that we can resize the
> >> @@ -1513,7 +1514,6 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
> >>          */
> >>         memblock_set_kho_scratch_only();
> >>  
> >> -       kho_in.fdt_phys = fdt_phys;
> >>         kho_in.scratch_phys = scratch_phys;
> >>         kho_scratch_cnt = scratch_cnt;
> >>         pr_info("found kexec handover data.\n");
> >> @@ -1524,7 +1524,10 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
> >>         if (scratch)
> >>                 early_memunmap(scratch, scratch_len);
> >>         if (err)
> >> +       {
> >> +               kho_in.fdt_phys = 0;
> >>                 pr_warn("disabling KHO revival: %d\n", err);
> >> +       }
> >>  }
> > 
> 

-- 
Sincerely yours,
Mike.

