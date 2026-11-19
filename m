Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CDEF606B77A
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 20:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uREuKfZf
Received: by kanga.kvack.org (Postfix)
	id 431FD6B0686; Thu, 19 Nov 2026 15:42:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BC116B068C; Thu, 19 Nov 2026 15:42:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 283A76B06CF; Thu, 19 Nov 2026 15:42:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E471D6B0686
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:42:43 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6093CC0BC4
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 20:42:43 +0000 (UTC)
X-FDA: 85453042206.16.A50F8A3
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6F1D0C000A
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 20:42:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=uREuKfZf;
	spf=pass (imf10.hostedemail.com: domain of shaikhkamal2012@gmail.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=shaikhkamal2012@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795120961;
	b=tMKxPs42pDgta+20WaLHOID0egJoVJp1G/gd+2P2WfwvXQzX9AbKhOWS8M5rdANvQYUR+G
	M7cwHajjeYcsPGJbb38E3vTcMjc7UtCB4hAGs1uF09cSBuMP0tyZQjLoqbIl0Ma7ua/Vy4
	HjRziQsNTVbJWVgdeG7nQjZhxBlb2x0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=uREuKfZf;
	spf=pass (imf10.hostedemail.com: domain of shaikhkamal2012@gmail.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=shaikhkamal2012@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795120961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZBFQR7u8Ee3YVRPu1eQVodXE/UpYLg54xCAcuhe+MAs=;
	b=ynIsPkosf5NsO57Hmu9Ma+dqR654G5xGNC8l4Gct0QpDZ3XoninqylVVT8UuRws6h8uSy9
	YufM8SUsvVnE4A8bstxEKWVDok0XNckytIMsQvBCkvVze0KlbkZs79CQz71NS6sgyuM1Dy
	eOhggY8X0CualhnwEkFaqTkYRNuU2YY=
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-372bdb942dbso168997eec.1
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 12:42:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795120960; x=1795725760; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZBFQR7u8Ee3YVRPu1eQVodXE/UpYLg54xCAcuhe+MAs=;
        b=uREuKfZfKjHoaIcJVf+REDXQ0bnGu/6FcaNXLt5OE1a6fwK9z9Jkjx1OvmHM0ka1n/
         o+z7nFkmAuJW2DbmQi9uCke0Z52nS7rZPztBx5jGl2J7qzGt7wnFXJU9K9dUrQlLgeYP
         k91uuTUAX1DGnrboNR2LA5PWTg7hwMJKB8iDvHUCCnmxbcsBbS4nAtpF4Lv+pMwBzQhT
         CakkZINLt34OyYfjdhjubDoHT+s8lsGSG9kcwmIbRlgJPZS5GmGneszhW/f2cLRQg4UR
         ZdBEh3b22u9uhIuqnziJPamOcgKWXVwyqGwZeUp7lYWmXKUhZwuq7oxOdTBC6Aq1SG+c
         +yyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795120960; x=1795725760;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZBFQR7u8Ee3YVRPu1eQVodXE/UpYLg54xCAcuhe+MAs=;
        b=ZqLE/OHMAsiaMBkZAxS3/g3l/AAbfig4PGJcsMm4vl25RxEbPp/oHyN7MyWerbpBws
         pAGADFWYHaGEwrbULtgtGxPuNTEXlXNjfSBcdHElzJdv52xv8tOtPU63BqF79z7/6HlH
         fXZCifll01iMyFjBvYxQMMhmQG0T/ifUwKcZ7LBqnBINGtcg5RLGayH4UJZ1KOeVdF66
         bWQnenS+GKehXfYjZbn8usCKcubMw0bRL95HKIM2Ybz9atSk6AncyPfg2TweWCkxqi5Q
         urPRIUhFmTz7qyPpL4qGVF9v4KBuqiOPy6s3QWhRXp2a5dx/B+8lScVZWYvOvtaMxAig
         mtbA==
X-Forwarded-Encrypted: i=1; AL+hErH6bbqoFSfCBPruDwbvx8ybjP0Ua5RunHSq0mXuNCrcMbjwnER2KkPOH78ohZ8/pyRMpev26YMviQ==@kvack.org
X-Gm-Message-State: APuU4Z9IOT8h6Tn+E/ZmIjiR7wN/U17EpADftoArg8/YLOMp491oYjSA
	fopG2v99Am8cS965+RyN6UZuUk0iCQNrib3Q6K4SVlUu7Kg6iWXJx+KX
X-Gm-Gg: AZFdTZfbs5dGnyDMSTcj3beRsvWQbKJ2a/Y3T8dLDeuX1Ph8atKHYP6tyMONbXz3SvQ
	4ghJO3/y8Z9Bl3i8zXHLZIAQNvsDiFqbpoxvrh8c6FFKNCuMQh4HXCjHTHWGA7FbkQkdMs5H8YK
	aW986EpIZQa+eBYn4lDVyd+OgXIjCm1TMI0A1NpT7jylw/UOipsogS+1wJPHEtHjNWOSP2N7Ny8
	slS4D5/B0BV1hyIntMHf97bI8GFLEpTbdW+rmcqRafNgx7IwZakaKE8tvYYPYAVvusb2ZIhfzXE
	SW4of+/Iz64hVw8IHI1XjAzDiJMfR/wr+UeJD7n2B3su8A6Rrj5bVzxrTSzyhiefHwuL4blVcH9
	797CbA0LrhetfQw/hDdbsb8HHsR90vcKkbtOmeiW2UgxAQpAhRmWgUkvnDBP4tFXa6sJk2ZHKeN
	1Dprv7eNydslrlIjSa9Y4iEBER6/SERx148cpN1XVUp2m0wlJYVU2kzAvcJHllO7zpi4LGSIzP2
	Bjb0ulEUoSCqJR/dCVHf7tLqmK3Pmrqm8VMKQsqxqoX/BkBElVrlBt6uoJ4A+p8bh3/milxWffj
	5cygOIeU1q28IRNo93Ie6LuRIHyqjMbmuA==
X-Received: by 2002:a05:7301:4306:b0:351:29c8:643 with SMTP id 5a478bee46e88-3856f65cb16mr430705eec.18.1795120959979;
        Thu, 19 Nov 2026 12:42:39 -0800 (PST)
Received: from localhost ([115.96.176.220])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385677c0c1dsm1079684eec.21.2026.11.19.12.42.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 12:42:39 -0800 (PST)
Date: Fri, 20 Nov 2026 02:12:36 +0530
From: Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>, Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <djbw@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Breno Leitao <leitao@debian.org>, Ira Weiny <iweiny@kernel.org>,
	Li Ming <ming.li@zohomail.com>, Richard Cheng <icheng@nvidia.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Kiryl Shutsemau <kas@kernel.org>, Harry Yoo <harry@kernel.org>
Subject: Re: [RFC PATCH 5/5] cxl/region: Register device poison before
 exposing RAM
Message-ID: <av9fPGZHfa8yOnq7@acer-nitro-anv15-41>
References: <20261010162017.62506-1-shaikhkamal2012@gmail.com>
 <20261010162017.62506-6-shaikhkamal2012@gmail.com>
 <20261016233532.51766fc4@jic23-hlaptop>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261016233532.51766fc4@jic23-hlaptop>
X-Stat-Signature: j7t1row6o4zmpq9gzo6xorfy9f4whwx1
X-Rspamd-Queue-Id: 6F1D0C000A
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795120961-212810
X-HE-Meta: U2FsdGVkX1+e2t0tbErXp1t5U4VpP9ZXJ8SRKtuH9kzEtxjDdFZVuARSn0/f727AGFpiLiGffdZS5/dGZL5HMhbc7s5ZFAGrNueMatqbXkzKbFg2VpbJhvp1dlgPnaIwEozckxYlMuyssZUTNQ1cEjw6X2qjgfA3VHTiapZoXgXDRY+5vnmpI7RDkc488LuWTd5+tl2KC1lypFnYEdQlDGBBQBYgfCe8HRc4HgX/k9LqM7DQcGjaupHgSJPCPPUFBW+KvjXDGB03gv5HQ9FOynIgFXTCLqt2WZ4m1AKAtCxmrFGD65WoXM8EsV5L+fH4E64rJ3P92GEcqvUx1c1WisRs0yPclMAHqQLjKwXVYxfXm9MdzjNYnP7SASjksnPpe73l0Xdb7cKvrJ9g7SFoobhO4mnXmyn+FzXG2aaf7t3ytP0IZNqnHKQKMx8kTBjhqfjFN5ocKqGcfrVUIqGA1DnKcVgGSIXWeitIBETBBt60lxI6nWZ0C6hLDxQMnBnAddyqjpUHDzjxmRKLiSaEOhjNk/rgBuvEPrnKi7Zn/09z5wmyUDBnac50bfKQgDFHYPyi6dD9gX6Yun6Bzdk3U3hM7RSLCje1nxc97HFLaSzwj+USf9KPgWCpZeXpnecU6Dg5xhA3uG3wpTT9FH/Irn2o+Zxzf3t6Npt0GUWhdXgZ5WpSP20YbaNymg95NYaJ/gAJWPgQtpkpEzaY6gadV8/q6QSlSgOiufQzXi3QOBzlWUJN7FYB4F+bx2X54KcHxIcZ7H4H68PwP/GrT3o8vGLzEakHYft8ywPsuZd3MuZMYgnwBg6kPGx3Q+7o33WIDn/Vo2TWNJQqUgV9z1hj6dGYZrc55u9BlH3fyN+C52yUIoZph7Cvtzg8gC1/bBl3+iwkddt7A6e6+GSPNkDRcTYlgZRvfUKh/YhHDb4nBzNhB9j+mfrqSK8Lnqpty7p7y03V8N0nHDtwSjqqkvF
 FzfwJFA0
 TyTbV+iVwx5oXbqgTvKS4BfDT3M422y6jfvkMSpObFlQq7IaBDtk3D2cNxRf++qVnwEHWN/jzLNVVZav99WhxC+G+c5TzRTppKQxFe7svHYFEmx2nyFVZqNTXuPtCGDWWpi6b03qyMV2PV0SnZbuImoou92lORN8jZf2Zw/0NnWfCl4EmIXUmZ5fsflTr3X77gHBB27sSGyIJGfpd5vnT7XVl95VmrOFDO1Yjv7hWUVdyWsx0BVnWZnfYg9TikzhWmgOtjIbr67VLJzu55s8FHxf4+zziSUbGgMa1QlLZiGR7TZK5+XI0GO5QNjRNZP72goA5Pw5zgfVHicRlnBOtlQwOp9M2FzAWts949rDwhT9cri6DT9XJZLk2A6WFWoocmFmb/vgggH88PwM5aQG9zzMuLAql4XZd1kScxXzUKEa0XliymgOmrdZLep4xL9doE+1KLKZAbeNye4HxqlVMlG8NgGpBpk9+93vf5UKn58In8d4jchF7X8c95m56528XCuyVhiAU4JMtm8kZAheRq3rw88cL68TV/BylCSx3LZJFWiXw6kFVCx1m5oXvcS+/MrOghNpekqrVwMw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 16, 2026 at 11:35:32PM +0100, Jonathan Cameron wrote:
> On Sat, 10 Oct 2026 21:50:13 +0530
> Shaikh Kamaluddin <shaikhkamal2012@gmail.com> wrote:
> 
> > The trigger_poison_list interface may retrieve poison after CXL memory
> > is already online, which is too late to prevent known-bad frames from
> > entering the page allocator.
> > 
> > During RAM-region probe, retrieve a poison-list snapshot for each
> > participating endpoint decoder. Validate each record against the
> > decoder's assigned DPA range, translate its poisoned DPA units to HPA
> > and PFN, and collect the affected PFNs in an xarray. Coalesce consecutive
> > PFNs and register the resulting ranges with the pre-online hwpoison
> > registry before creating the DAX region.
> > 
> > When Get Poison List is supported, abort region probe if the list is
> > incomplete, malformed, or cannot be translated. If volatile poison-list
> > retrieval is unsupported, preserve the existing behavior and warn that
> > poison cannot be withheld before memory onlining.
> > 
> > Signed-off-by: Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
> A few comments inline.  I wouldn't rush to revise this though as I think
> the whole concept needs more input from others.
> 

Hi Jonathan,

Agreed. There are open comments on the mm side too (3/5 and 4/5), so I
will get the design settled before sending v2.


> Jonathan
> 
> > ---
> >  drivers/cxl/core/region.c | 322 ++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 322 insertions(+)
> > 
> > diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> > index c72524923b38..e3ffa77927df 100644
> > --- a/drivers/cxl/core/region.c
> > +++ b/drivers/cxl/core/region.c
> > @@ -14,6 +14,7 @@
> >  #include <linux/string_choices.h>
> >  #include <cxlmem.h>
> >  #include <cxl.h>
> > +#include <linux/memory-failure.h>
> >  #include "core.h"
> >  #include "mce.h"
> >  
> > @@ -3038,6 +3039,323 @@ int cxl_get_poison_by_endpoint(struct cxl_port *port)
> >  	return rc;
> >  }
> >  
> > +/*
> > + * Device-reported poison is gathered at RAM-region probe, before the range
> > + * reaches dax/kmem, and registered with the pre-online registry so the
> > + * frames it covers are withheld when the memory is onlined.
> > + */
> > +static int cxl_poison_store_pfn(struct xarray *pfns, u64 hpa)
> > +{
> > +	return xa_err(xa_store(pfns, PHYS_PFN(hpa), xa_mk_value(1),
> > +			GFP_KERNEL));
> 
> Fix alignment of the line above. Right now it isn't visually clear
> which function call the parameter is for.
>

Will fix.

> > +}
> 
> > +static int cxl_poison_record_to_pfns(struct cxl_region *cxlr,
> > +				     struct cxl_memdev *cxlmd,
> > +				     const struct cxl_poison_record *record,
> > +				     struct xarray *pfns)
> > +{
> > +	struct cxl_region_params *p = &cxlr->params;
> > +	u64 raw = le64_to_cpu(record->address);
> > +	u64 units = le32_to_cpu(record->length);
> > +	u64 dpa = raw & CXL_POISON_START_MASK;
> > +	u8 source = raw & CXL_POISON_SOURCE_MASK;
> > +	u64 length, end, step, cur;
> > +
> > +	if (!units ||
> > +	    check_mul_overflow(units, (u64)CXL_POISON_LEN_MULT, &length) ||
> > +	    check_add_overflow(dpa, length, &end))
> > +		return -EPROTO;
> > +
> > +	/*
> > +	 * A corrected error never reaches the poison list, so every record
> > +	 * is uncorrectable. Only a failure of the device's own media is
> > +	 * withheld: External poison was written by the host into healthy
> > +	 * media and a rewrite or Clear Poison recovers it, and Injected
> > +	 * poison is a test artifact. Withholding either would make a
> > +	 * recoverable state permanent.
> 
> This reflects back to the comment I made in the cover letter.
> Device discovered poison can be ephemeral. 

Agreed. If the error was only temporary, the next write would fix it.
But nothing ever writes a withheld frame, so it stays on the list and
we keep withholding it forever.

>I'm also not sure for volatile
> where any poison record would come from if you are doing this for newly 
> powered up devices - they might scan whilst initializing but might not as
> that is very very slow to do.  Typically poison is found much later by
> patrol scrub (or synchronous read).

A real media fault is still there after a power cycle, which is why
PPR exists, at boot or at runtime. But on a volatile device the poison
list may not remember it: until patrol scrub or a read finds it again,
the list can be empty. So this mainly helps when the device stays
powered while the host restarts, like kexec or a driver re-bind, or
with a device that keeps its error records across a power cycle.

>This may be more interesting for
> persistent memory where the persistence is used, but you aren't addressing
> that as far as I can tell.
>

Agreed, that is the stronger case. Today the CXL driver doesn't feed
the poison list into the nvdimm bad ranges at all, so pmem and devdax
on CXL don't see known-bad locations either. cxl_pmem_ctl() also
returns -ENOTTY for ND_CMD_CLEAR_ERROR, so a bad block couldn't be
cleared by a write even if it were listed.

I will  look at both as a separate series: bad ranges from the poison
list at pmem region probe, plus clear-error support. kmem could then
use the same list when a pmem range becomes system RAM.

> > +	 */
> > +	if (source != CXL_POISON_SOURCE_INTERNAL) {
> > +		dev_dbg(&cxlr->dev, "%s: dpa %#llx source %u not withheld\n",
> > +			dev_name(&cxlmd->dev), dpa, source);
> > +		return 0;
> > +	}
> > +
> > +	/*
> > +	 * Translate once per unit of HPA contiguity rather than per 64
> > +	 * bytes. Consecutive DPAs within an interleave granule map to
> > +	 * consecutive HPAs, and a granule no larger than a page lies within
> > +	 * one page, so stepping by min(granule, PAGE_SIZE) from an aligned
> > +	 * start reaches every page the record covers.
> > +	 */
> > +	step = clamp_t(u64, p->interleave_granularity, CXL_POISON_LEN_MULT,
> > +		       PAGE_SIZE);
> > +
> > +	for (cur = ALIGN_DOWN(dpa, step); cur < end; cur += step) {
> > +		u64 hpa = cxl_dpa_to_hpa(cxlr, cxlmd, max(cur, dpa));
> > +		int rc;
> > +
> > +		/* Not mapped by this region; nothing here to withhold. */
> > +		if (hpa == ULLONG_MAX)
> > +			continue;
> > +
> > +		rc = cxl_poison_store_hpa(cxlr, pfns, hpa);
> > +		if (rc)
> > +			return rc;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int cxl_region_collect_decoder_poison(struct cxl_region *cxlr,
> > +					     struct cxl_endpoint_decoder *cxled,
> > +					     struct xarray *pfns)
> > +{
> > +	struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
> > +	struct cxl_poison_snapshot snapshot;
> > +	int rc;
> > +
> > +	rc = cxl_poison_snapshot_init(cxlmd, &snapshot);
> > +	if (rc == -EOPNOTSUPP) {
> > +		dev_info(&cxlr->dev,
> > +			 "%s: no Get Poison List support, nothing withheld\n",
> > +			 dev_name(&cxlmd->dev));
> > +		return 0;
> > +	}
> > +	if (rc)
> > +		return rc;
> > +
> > +	rc = cxl_get_poison_by_decoder(cxled, &snapshot,
> > +				       CXL_POISON_QUERY_PREONLINE);
> > +	if (rc == -EFAULT) {
> > +		/*
> > +		 * The device keeps no poison list for volatile ranges, which
> > +		 * CXL r3.2 8.2.9.8.4.1 permits. Online the region as today.
> 
> Use latest available spec for references (they don't make old ones easy
> to download!)
> 

Will update the latest references.

> > +		 */
> > +		dev_info(&cxlr->dev,
> > +			 "%s: no volatile poison list, nothing withheld\n",
> > +			 dev_name(&cxlmd->dev));
> too noisy.
>

Will drop it.

> > +		rc = 0;
> > +		goto out;
> > +	}
> > +	if (rc)
> > +		goto out;
> > +
> > +	/*
> > +	 * Withholding from a partial list would online the region on the
> > +	 * belief that every bad frame had been named.
> > +	 */
> > +	if (snapshot.truncated ||
> > +	    (snapshot.device_flags & CXL_POISON_FLAG_OVERFLOW)) {
> > +		dev_err(&cxlr->dev, "%s: poison list incomplete\n",
> > +			dev_name(&cxlmd->dev));
> > +		rc = -EOVERFLOW;
> > +		goto out;
> > +	}
> > +	if (snapshot.device_flags & CXL_POISON_FLAG_SCANNING) {
> 
> That one seems wrong. We don't prevent memory from coming online because
> there might be poison to be found.

Agreed, I will drop that check. Anything the scan finds later is handled
like any other poison found at runtime.

> 
> > +		dev_err(&cxlr->dev, "%s: media scan in progress\n",
> > +			dev_name(&cxlmd->dev));
> > +		rc = -EBUSY;
> > +		goto out;
> > +	}
> > +
> > +	for (u32 i = 0; i < snapshot.nr_records; i++) {
> > +		rc = cxl_poison_record_to_pfns(cxlr, cxlmd,
> > +					       &snapshot.records[i], pfns);
> > +		if (rc)
> > +			break;
> > +	}
> > +out:
> > +	cxl_poison_snapshot_destroy(&snapshot);
> > +	return rc;
> > +}
> > +
> > +static unsigned int cxl_count_poison_ranges(struct xarray *pfns)
> > +{
> > +	unsigned long index, previous = 0;
> > +	unsigned int nr = 0;
> > +	void *entry;
> > +	bool first = true;
> > +
> > +	xa_for_each(pfns, index, entry) {
> > +		if (first || index != previous + 1)
> > +			nr++;
> > +		first = false;
> > +		previous = index;
> > +	}
> > +	return nr;
> > +}
> > +
> > +/*
> > + * The xarray holds each PFN once and xa_for_each() walks them in ascending
> > + * order, so runs of consecutive indices are exactly the sorted,
> > + * nonoverlapping ranges preonline_hwpoison_register() requires.
> > + */
> > +static int cxl_pfns_to_ranges(struct xarray *pfns,
> > +			      struct preonline_hwpoison_range **ranges_out,
> > +			      unsigned int *nr_ranges_out)
> > +{
> > +	struct preonline_hwpoison_range *ranges;
> > +	unsigned long index, previous = 0, run_start = 0;
> > +	unsigned int nr_ranges, nr = 0;
> > +	void *entry;
> > +	bool first = true;
> > +
> > +	nr_ranges = cxl_count_poison_ranges(pfns);
> > +	if (!nr_ranges) {
> > +		*ranges_out = NULL;
> > +		*nr_ranges_out = 0;
> > +		return 0;
> > +	}
> > +
> > +	ranges = kvmalloc_array(nr_ranges, sizeof(*ranges), GFP_KERNEL);
> 
> kvmalloc_objs()
> 

Will switch.

Thanks,
Shaikh Kamal

> > +	if (!ranges)
> > +		return -ENOMEM;
> > +
> > +	xa_for_each(pfns, index, entry) {
> > +		if (first) {
> > +			run_start = index;
> > +			previous = index;
> > +			first = false;
> > +			continue;
> > +		}
> > +		if (index == previous + 1) {
> > +			previous = index;
> > +			continue;
> > +		}
> > +		ranges[nr++] = (struct preonline_hwpoison_range) {
> > +			.start_pfn = run_start,
> > +			.nr_pages = previous - run_start + 1,
> > +		};
> > +		run_start = index;
> > +		previous = index;
> > +	}
> > +	ranges[nr++] = (struct preonline_hwpoison_range){
> > +		.start_pfn = run_start,
> > +		.nr_pages = previous - run_start + 1,
> > +	};
> > +
> > +	WARN_ON_ONCE(nr != nr_ranges);
> > +	*ranges_out = ranges;
> > +	*nr_ranges_out = nr;
> > +	return 0;
> > +}
> > +
> > +static void cxl_unregister_device_poison(void *data)
> > +{
> > +	preonline_hwpoison_unregister(data);
> > +}
> > +
> > +static int cxl_region_register_device_poison(struct cxl_region *cxlr)
> > +{
> > +	struct cxl_region_params *p = &cxlr->params;
> > +	struct preonline_hwpoison_range *ranges = NULL;
> > +	struct preonline_hwpoison *handle;
> > +	unsigned int nr_ranges = 0;
> > +	unsigned long nr_frames = 0;
> > +	struct xarray pfns;
> > +	int rc = 0;
> > +
> > +	lockdep_assert_held(&cxl_rwsem.region);
> > +	lockdep_assert_held(&cxl_rwsem.dpa);
> > +
> > +	/* The region may have been decommitted while the lock was dropped. */
> > +	if (p->state < CXL_CONFIG_COMMIT)
> > +		return -ENXIO;
> > +
> > +	if (test_bit(CXL_REGION_F_NORMALIZED_ADDRESSING, &cxlr->flags)) {
> > +		dev_info(&cxlr->dev,
> > +			 "normalized addressing, poison not translated\n");
> > +		return 0;
> > +	}
> > +
> > +	xa_init(&pfns);
> > +
> > +	for (int i = 0; i < p->nr_targets; i++) {
> > +		struct cxl_endpoint_decoder *cxled = p->targets[i];
> > +
> > +		if (!cxled->dpa_res || !resource_size(cxled->dpa_res))
> > +			continue;
> > +		rc = cxl_region_collect_decoder_poison(cxlr, cxled, &pfns);
> > +		if (rc)
> > +			goto out;
> > +	}
> > +
> > +	if (xa_empty(&pfns))
> > +		goto out;
> > +
> > +	rc = cxl_pfns_to_ranges(&pfns, &ranges, &nr_ranges);
> > +	if (rc)
> > +		goto out;
> > +
> > +	rc = preonline_hwpoison_register(ranges, nr_ranges, &handle);
> > +	if (rc == -EOPNOTSUPP) {
> > +		/* No poison tracking in this kernel; nothing to withhold. */
> > +		rc = 0;
> > +		goto out;
> > +	}
> > +	if (rc)
> > +		goto out;
> > +
> > +	for (unsigned int i = 0; i < nr_ranges; i++)
> > +		nr_frames += ranges[i].nr_pages;
> > +	dev_warn(&cxlr->dev,
> > +		 "withholding %lu frame(s) reported poisoned by the device\n",
> > +		 nr_frames);
> > +
> > +	rc = devm_add_action_or_reset(&cxlr->dev, cxl_unregister_device_poison,
> > +				      handle);
> > +out:
> > +	kvfree(ranges);
> > +	xa_destroy(&pfns);
> > +	return rc;
> > +}
> 
> 

