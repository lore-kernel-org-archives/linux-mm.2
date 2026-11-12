Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C73BE606A324
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 03:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RFdDyQ0e
Received: by kanga.kvack.org (Postfix)
	id D96196B05B2; Wed, 11 Nov 2026 22:46:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D45456B05B3; Wed, 11 Nov 2026 22:46:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBF876B05B4; Wed, 11 Nov 2026 22:46:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 901426B05B2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:46:10 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B348080409
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 03:46:09 +0000 (UTC)
X-FDA: 85425078858.03.047016F
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	by imf30.hostedemail.com (Postfix) with ESMTP id BD0F680003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 03:46:07 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=RFdDyQ0e;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of shaikhkamal2012@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=shaikhkamal2012@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794455167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JdZEQXD1LnxY/7fSoWWoTeFvDJfFMcLXYTDCBTSvcT4=;
	b=z+IxlLxsckwZuiQG5zr8kPDFRdQ1cxCUP8i+npTj9hSxNHauDDP9iGpr5/W/FRHXK/BGgS
	glM4IwY7VPsSOQ77/79T7VfVK2cxlfGj4v1peDdlZeaBmlx6Ggjq/DD27HZwzH7WcAkWOy
	oj67urHhb23iomPxHrZVjkUOO4c8AFk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=RFdDyQ0e;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of shaikhkamal2012@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=shaikhkamal2012@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794455167;
	b=E+4pZmKG98G3ivN8xQYNl/MVbB6vZYmQCID3ww/YMKl8FbpQP6y4fAnRS6dET4uXfvO6Ao
	OqCw/0K6R+OpABT5Oa4MjJ9JOTRrpTkpFQKFsWIMRyEC64nCMhJguv47x5EwkwLpEInH2t
	s6oEu5FkymHiRzTZII4O6i1VovQgDvU=
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-33bf40b0c8bso2933742eec.0
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:46:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794455166; x=1795059966; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JdZEQXD1LnxY/7fSoWWoTeFvDJfFMcLXYTDCBTSvcT4=;
        b=RFdDyQ0eI35YSownCfAskhhGVkxs1EjPHOyjYjeD35h0xGxWWOvAUjqWv3Va6Xbl6f
         2V1zFw0MuNsxCexFgAngyb2cyA5FEKWRMwxQOpmu5berX3r+f9XN69bzJ+yoxd/0q5OJ
         gta6VfUZThMcwe6kwQj1+T4LTY80lgU8a1BRE/k8BiYSSfQeduITdWjkeePrMQbudhWT
         68TqEkqUeialD2NjlfxNOYysK6FOELflz6klR2g6zksaFm/eIlcN0hE7XGT8iFPRGmbw
         dk+MlX3tYeB1Br932aFqaBMSnr3HQIiC4y+C8M1BTxj523Seu234KH4MknmfkWWyIJ+o
         qP9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794455166; x=1795059966;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JdZEQXD1LnxY/7fSoWWoTeFvDJfFMcLXYTDCBTSvcT4=;
        b=Tc29Y+X8czvRVEUUvMC/kJW8S/L32q14m84NO7Pmb0oUPVHNFrVUtT3mRRjBduOF0K
         lDuvjXqJkJbfONt2BSL29WWdLUoNUbSgxpV5IDz5VNAzxNVkreLnQUvviXH+1LTwH8y3
         zNRIr9wt8CBw39tbTn8YM4tsu2E6CQSHkHk7nTMwn5KU/P2Bj+nWNih5TCumiVzmeDGe
         c0f6DdEeO6yQ1vA0EcEhM/d8Uaxe1HXqzwjgRd/4AHXs/RY1NmXCi7emQfZbqs1z4Ny3
         007f2BJIRRSPdv1TdWRh6DTDYY4D8X62OaNKu5O9gItk8pfoN86ooCfTeVASV295V56C
         UMSQ==
X-Forwarded-Encrypted: i=1; AL+hErEi9jJxnfskd9WP7cJnEZVAEkT/DZ2loiNoEt7A9I3k51vcImo0Gn7Une2ihM7rLxTjTdgasgx7pA==@kvack.org
X-Gm-Message-State: APuU4Z9smshcvu3CesNfQ3ukY6o0OZm/PV0OJFICnkdi4Rib8Yiaxzb+
	E039DnSsoUGqVA41PkYOYJC31bmUzwT3PaDleCrefb2On9AIKea/lqYw
X-Gm-Gg: AYBFou3iYSr58F6CenD2xITSIPl3hL0t9KfgKxJpBcf8VHYPoK1XY4Gr8LIkDpjdML8
	sxWE+2DFiWrct8gbgFfhioTDez4JCxJVAUK7asMbfPC7XKs7BLe6NH9Wms3wPF30DONqVuAXNLf
	2Kc12TQiNIofH6mnNQyOgzdBl4wrXr4q/4l/3M1YUrt7uEU8OutI2itRyqYOjBMfWOxNjaFsyrs
	1C4VBcJVxF47gvFeQXSsRssoG2MjfBy/jPdSjHZT4IJz5pjmFrWYA64JUXi5MQxh7i3D/JRqWnM
	79uCqjvV4cru/PW/xw0ZsIsB8p2NhWDn796NSe3tO6BmSPE3vau2yF6Cda++h2krtFeVyNhuhjg
	4J+HOH5XlCkAQURDdteHMOCouLDZzle0qgtuGZ+y02IRiwvTC7/XO0N38T5DgaHbpYrc0LVcXzO
	CGYvygxkieBbxbsrX+Xpi7iZIPQJN6VdwTMDpDedgSuE1QYWqFhWGm5z05vJVPqDFklIh4w+3+a
	UhJAl2fahcVDhRrcnwGGWp7Mv3463YngivnfCyO3dsCEmijEUs04OudyfgRuT+dGbv8QIh0Xkls
	8q7nDvVxeMOLPDqT+kkAF7RNNwn5TA==
X-Received: by 2002:a05:7022:7e82:b0:17e:ee5f:6715 with SMTP id a92af1059eb24-1b3c0329d7emr4637526c88.27.1794455166079;
        Wed, 11 Nov 2026 19:46:06 -0800 (PST)
Received: from localhost ([27.7.22.22])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3b5b2fc09sm43137065c88.10.2026.11.11.19.46.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 19:46:04 -0800 (PST)
Date: Thu, 12 Nov 2026 09:16:01 +0530
From: Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
To: Richard Cheng <icheng@nvidia.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>,
	Jonathan Cameron <jic23@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <djbw@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Breno Leitao <leitao@debian.org>, Ira Weiny <iweiny@kernel.org>,
	Li Ming <ming.li@zohomail.com>,
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
Message-ID: <avU2eZwBnHGvSPUf@acer-nitro-anv15-41>
References: <20261010162017.62506-1-shaikhkamal2012@gmail.com>
 <20261010162017.62506-6-shaikhkamal2012@gmail.com>
 <atCGJHmnk8Ll8pA_@MWDK4CY14F>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <atCGJHmnk8Ll8pA_@MWDK4CY14F>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BD0F680003
X-Stat-Signature: daa9k161wbo3jr14438j6xexspo4x116
X-Rspam-User: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794455167-976939
X-HE-Meta: U2FsdGVkX1/5X6FsL08E8JgfuBFeGUr8/BiKMu6LoIbF8UNXuk5sQ3awckYj7rU49T1YfYfQa/cgBLb/EGoupAm9cWibz3ma1aOxlQOyRoFg72Ku4x4LE3bJFD4PHbH6I68VtWmn9nWj3usMXplIodAsJcqzD0GDWiTKwgy0iP+IzeV2PVp8OQdCkcUXupZUWA5sfsffBFdCgVsUgbd8uOgNrNzIYbA3VG5HlY8caLAR4qEXpQ2LE+wMqbRPv5TID1DnWydRp/Sih4YqFPB/qswirUZLsEOUhPwEg40Av25e7nBKdSlJstBrfb5RXRwVHClOhWS2r3dKXCHcEq/roYb1LdkSoZZAVC52BjekHvIL7W8OJYmShLMPZ9pvum1rmAVw6/qZFIBMz6vM+pMCtxX6vavCSq47OiH5a1vt4oUJ2ja8Iks6CRZ095NtconvdWjj4akXeBbkWEPInW5RgzUaO7Z+mKhqj7uP6PWa9rFJo3wp/R+PKfx5/04Vk7eLSx351a6GoABtjkGlSGUiGDGjYcJ3NWn3orIVJZC1YTOCwzff49V4XfO9aNc67ZY6MzNRAN417BmfLMyPpJox1kciZcy/Yek5lY/CWavb55dYZEOmWcLfVlxH13fa9/2NweNI4cGMtBzOIt5BJ05bvRoNYi4jKen/ZjCBYxyqFawwYidmqgkseCF1Gm/sl4gJ+dPvOvh3uo+OcyHI0NzbzGPOzoRuqd5tE0kU8jF5J0BXtc16zZrP/PFA9ednhLAarRN7uHsuA0vIuVK/WyLN1lsZOBVcw7CciNDE+tihJ5D+9ZgCLOPgjk0TeBZafJbZFzPevut1kRx99TukQCBkzdHXkHBWmU12zHkMGs/o3AEbzvj/9xC5J5VGUXoWBcy/c08gBRVz2r8NRrxDzWs6b+KGrVcj6s6xJvXIVskFhB6CEtRcrUAXtw5RPEKo2ooUCY7EtjNGVH3vEr0YgF0
 voGCjhmt
 pvxtGREGnUEhr0PIDvQhyIN9ownv3Mjs+AQj/pezss7c4vKVGNxXanrv+CAKbMK6pqebV7qSOCa1MxNRXM7pgqNbHCyBh2xfk50PuNm81AE5KQAdlNVzkwymOBv5b14LnxPh/o1v5rPh4LX3ld3TZKK0/NvdgiVGE5Ag68wCiPMCs1Asnsc2RqYfWgelkjtK/GLyLCwI4t/YI/E+VhCM1VyaGQe3PjpFOMTorEugaahBVlu9eU9Q+uM8ga7L3KIIwlguyRlE7kgcXOp44FhxXlqyeFZmVIP6w33kgF0rHLKn4yr95jIZmpbJc2nh7sEz6RhyazGqo2kdevgP0e7MnoUwJC2YeyWv4YfRVkxfjTKkcXinEiaPffSdIWhC72Kgsmjoa1SqyjmffqzcFJFBbQ2R6eR7DvwHqpdPd5FOU8m37vrq/7Mr8/w0YEPQRWU6t8GIlcGN8S71wfp5YGlms1cGuITl7LCbsx6GEj1rFj9nVI187kyc+NwI4qBgThtDrhmg/+gAyj/jIa3cVytxrB60GAMhUi5ZaFbvxmBoB7BfUgIoPkJWP1wpgpU/y1ZxUh7qxCBImEhEYY9k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 15, 2026 at 03:59:13PM +0800, Richard Cheng wrote:
> On Sat, Oct 10, 2026 at 09:50:13PM +0800, Shaikh Kamaluddin wrote:
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
> > +}
> > +
> > +static int cxl_poison_store_hpa(struct cxl_region *cxlr, struct xarray *pfns,
> > +				u64 hpa)
> > +{
> > +	struct cxl_region_params *p = &cxlr->params;
> > +	int rc;
> > +
> > +	/* Outside this region: not ours to withhold. */
> > +	if (!cxl_resource_contains_addr(p->res, hpa))
> > +		return -ERANGE;
> > +
> > +	rc = cxl_poison_store_pfn(pfns, hpa);
> > +	if (rc || !p->cache_size)
> > +		return rc;
> > +
> > +	/*
> > +	 * An extended linear cache makes the same DPA visible a second time
> > +	 * at hpa - cache_size. Match the translation used by the
> > +	 * cxl_general_media and cxl_dram trace events.
> > +	 */
> > +	if (WARN_ON_ONCE(hpa < p->res->start + p->cache_size))
> > +		return -ERANGE;
> > +
> > +	return cxl_poison_store_pfn(pfns, hpa - p->cache_size);
> > +}
> > +
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
> > +		 */
> > +		dev_info(&cxlr->dev,
> > +			 "%s: no volatile poison list, nothing withheld\n",
> > +			 dev_name(&cxlmd->dev));
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
> 
> Hi Shaikh,
> 
> I think you are trying to propose the architecture as the following ?
> - CXL region driver collects the device's poison info and owns the registration
> - MM use the registration to keep poisoned pages out of the page allocator
>   when memory is onlined
> - DAX/kmem adds and removes the corresponding system RAM
> 

Yes, that's how the RFC works today. If we go with Dave's suggestion below,
only the first point changes: CXL only provides the entries, and MM owns
them.

> The registration belongs to the driver, but the memory that needs it can
> outlive the driver binding.
> 
> Unbinding the driver doesn't necessarily remove the memory. If some mem blocks
> are still online, removal of the range can fail.
> When driver cleanup removes the registration, MM loses poison info of those
> memory blocks as well.
>

You're right. If any block is still online, dev_dax_kmem_remove() can't
remove the range and leaves all its blocks in place, but the devm action
still drops the entries. Blocks that were online are fine, their bad
frames are already marked. The problem is a block that was offline: it
can be onlined later, and its bad frame then goes to the buddy.

> I don't have a good idea how we should re-design the ownership here, maybe
> we can discuss about it.
>

Hand the poison info to MM when the memory is added. The driver's
registration only has to live until add_memory_driver_managed().
At that point MM copies the registered ranges inside the added
range and keeps them with the memory blocks (or the memory group
dax/kmem already registers), and frees them when the memory is
removed. After that the driver binding doesn't matter. Hook A
already makes its decision at add time, so both hooks would read
MM's copy.

Does that sound right? If so I'll do it this way in v2.

> Best regards,
> Richard Cheng.
> 
> 
> 
> 
> > +out:
> > +	kvfree(ranges);
> > +	xa_destroy(&pfns);
> > +	return rc;
> > +}
> > +
> > +static int cxl_region_scan_device_poison(struct cxl_region *cxlr)
> > +{
> > +	int rc;
> > +
> > +	/* Nothing would consume the result. */
> > +	if (!IS_ENABLED(CONFIG_MEMORY_FAILURE))
> > +		return 0;
> > +
> > +	ACQUIRE(rwsem_read_intr, region_rwsem)(&cxl_rwsem.region);
> > +	rc = ACQUIRE_ERR(rwsem_read_intr, &region_rwsem);
> > +	if (rc)
> > +		return rc;
> > +	ACQUIRE(rwsem_read_intr, dpa_rwsem)(&cxl_rwsem.dpa);
> > +	rc = ACQUIRE_ERR(rwsem_read_intr, &dpa_rwsem);
> > +	if (rc)
> > +		return rc;
> > +
> > +	return cxl_region_register_device_poison(cxlr);
> > +}
> > +
> >  struct cxl_dpa_to_region_context {
> >  	struct cxl_region *cxlr;
> >  	u64 dpa;
> > @@ -4262,6 +4580,10 @@ static int cxl_region_probe(struct device *dev)
> >  					p->res->start, p->res->end, cxlr,
> >  					is_system_ram) > 0)
> >  			return 0;
> > +		rc = cxl_region_scan_device_poison(cxlr);
> > +		if (rc)
> > +			return rc;
> > +
> >  		return devm_cxl_add_dax_region(cxlr);
> >  	default:
> >  		dev_dbg(&cxlr->dev, "unsupported region mode: %d\n",
> > -- 
> > 2.43.0
> > 

