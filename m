Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9B24606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 20:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Cuix83qB
Received: by kanga.kvack.org (Postfix)
	id 0ECB26B0369; Mon, 19 Oct 2026 16:00:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09E256B036A; Mon, 19 Oct 2026 16:00:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECE5E6B036B; Mon, 19 Oct 2026 16:00:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A66F46B0369
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 16:00:41 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 11365406A3
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 20:00:41 +0000 (UTC)
X-FDA: 85340443482.17.FD1BB49
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5F70D18000D
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 20:00:38 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Cuix83qB;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf24.hostedemail.com: domain of dave.jiang@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=dave.jiang@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792440038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ux87Or6H1qG//7PVLz/zBWhaIEX1urIy5837nD8GIWI=;
	b=U5AKLXSOhkhKz+G+YcAE037D+VST7cQre7c3SrMSG1P6Gilv+3WH7awBfTxGGuC7TUYefe
	jrkJ1xKDwMMu2VStNa+FX4Z/ulbxEemYEcY/EWgFTOrn9LMXoE4yZWTx1i40818sUqsCia
	S8GTWZNIeuokxX3v4A4dLzFkQxEaylg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Cuix83qB;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf24.hostedemail.com: domain of dave.jiang@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=dave.jiang@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792440038;
	b=n778N4UbNBakHPSAI3Oz1kZZFFXCo2y0gvhBcjCQF0vrqL10b0tJvXHxuyOzacHq3nqJ7f
	mmwkyk+FYbbcV3H6xBmFcEMKys2R1qgw6nKl/V19t9elWKlFa3o/LxjNjTBnnuuoBOL6lI
	G10eBoMUpk1sy0w9jkG7eOudPGHsNwg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792440039; x=1823976039;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vF6bNVA+qNH7VHEXonZQinzjh9XzXcyQM1oQrXK6c7E=;
  b=Cuix83qBPKG36k8xxDdpjO4A5+y5RIx1G8DdTfkmWT5+m/1QaU7Uu0l9
   OH/tRQBMfHMQoBo0TFo30664+8ToEBOSlMD9sfo++spcYZD3/AX9w+yuR
   S+u95Sw7HP4KDF9dc3DEZlfA8bBNjzCkf8/my8oKCANgjk6nikFnLK6Wl
   8LkHG4CqqR/f2f5A9CVuaH8DGiJVlSFEbqJVjxQiG1Mxd3VWjVnDewOg+
   WwBzizNJjMcQ0Vo6UO/Ov8AdHpKz9hEjqqyq7oMYESI3DiGni6A8O8MpC
   S1oUqAHTuEZUlwivdqLmv6lOKTbmFeOImIbUsntSUT4wZlmCjUVJsqV0z
   w==;
X-CSE-ConnectionGUID: my60b2N3T9GJ0LUxRhjTbg==
X-CSE-MsgGUID: ZX8uH3uASjWmlOi2xO4cFg==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="1038545"
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="1038545"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 13:00:37 -0700
X-CSE-ConnectionGUID: JmMnBhH0Q/Wbj77Ebm42pQ==
X-CSE-MsgGUID: 3zBaHN3KTyqiAj1KbEZ9AQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="2586766"
Received: from gabaabhi-mobl2.amr.corp.intel.com (HELO [10.125.111.28]) ([10.125.111.28])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 13:00:35 -0700
Message-ID: <893aaa95-5663-4a22-9c3a-1b9cf97e3dfe@intel.com>
Date: Mon, 19 Oct 2026 13:00:33 -0700
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 5/5] cxl/region: Register device poison before
 exposing RAM
To: Richard Cheng <icheng@nvidia.com>,
 Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>, Jonathan Cameron <jic23@kernel.org>,
 Alison Schofield <alison.schofield@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dan Williams <djbw@kernel.org>,
 Miaohe Lin <linmiaohe@huawei.com>, Andrew Morton
 <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>,
 Breno Leitao <leitao@debian.org>, Ira Weiny <iweiny@kernel.org>,
 Li Ming <ming.li@zohomail.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Kiryl Shutsemau <kas@kernel.org>, Harry Yoo <harry@kernel.org>
References: <20261010162017.62506-1-shaikhkamal2012@gmail.com>
 <20261010162017.62506-6-shaikhkamal2012@gmail.com>
 <atCGJHmnk8Ll8pA_@MWDK4CY14F>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <atCGJHmnk8Ll8pA_@MWDK4CY14F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5F70D18000D
X-Stat-Signature: 8y8bfoj816typuahddinjqc1qwa5sezz
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792440038-85229
X-HE-Meta: U2FsdGVkX1+6bTCBWHAjVxU9XW2s4RdI/ohrYbwjprGWSJnRY56BYOHt2w1B1JwWKDWhkEImmNdkcwO6/jp10RTZ0h6ECkUDym1RQUIPOYwT5pxZb9v1HZ/tiA2SKp4k2XxTVujp5Jos58Boi/cHkl/SM+1I3R8l2CqJncg02FMG59NFyXl4Vs7IV1zhNqa7b887weVFiQB79UZkgiUOUfqq7/5x5i45bXJdTqXufBuvReVWhLuSmY1kAXUsoCwUYN8w4mZxA9XhCmrhpUaMJmDqij7Ppb68+URwWrcIm3id7ZzBtMKyH1/AWsiE5VTsIbDpBzieqV+b9JgbFWX7D0E/fkSUhghbNFiiWEYQAAFTRDl+1EDPKKtb0m/gItowvyzpjCEFDZnM5uAewGoM2YvkpwoU1WhCmgdLnh98h6TjXc3vxxyXru06542S2pyFWLMj0JT8F5jCIRArpGQV340ledVgUTEC06s4r8Zio5Did2W7lw2F2yChDYGSAYC0MrIeK/FKDHj4ozHSpQITZAFVIUlfIiXt4BGFj2BWwsz174H4+wKDtF407MLimrhLs6nL92t90XUHX+lfYFJtie3x6CukgD7sFLap8VToTyqN/zmuRnbmq0rrIPyqHCjhlAfiH7uuNuX4OpDrAuiVh1fmfn08zxcGQ2mQLmcwbpV3jrZtSQEM6ryoBRFfcoCi2aSfW/cuSSkNH+Kd0U5Q1RUzeQRQjG1KcYp/hi6I23/w7MKLADuUvGY6hjOY8D3SzK2Jlf1U2JqyNslgzByyVvnP9HJkOZLBFsQtl4iBdKMxTJUthFX7U626vxWFv03pN0qwubWammbi+9WtP2f+YQRknDZOkU6lltied5GIIopDSrahcf8H4WuctrYgBcT7nP937jDFoS8pZ8BTA+hROZiX4dFhWp1SToy4dKe7a1ESIPbHGsb4Sfmd4sn3Vch6+jvE+g0TObBVmO0aHZT
 eMlXA4MW
 2pXF+8UXA1xGij71+GwnuE6pMUagkWIDtk/cNgLALgZ+ytpKMVWOG257Jw4BounlfJvFHbQEGjquA91nRgvcSEQ4Vv/6Njo6qC8AailuR7JYDto8Ste4kSmEbuwHZG4cD56uZ11lHUyzQSSc/dIztCdLz7bORhGmt/k6EVj7hbeNxJ2lz0m18FTLZhbmxYArawJKpYraa8a+A+IP+9FdbT2K2TpK5L0MfZysMC0jLqBAQFxGE3SI0kS/JAofN9S8ilnTToGdlzuuZZa6oc7dAOYgdBv/EYd/2h+zOWieDxCpQlq3XZKaJLeLBx0VjlEZ6khOQOCmInCn19bjWO0DsFot3iA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/15/26 12:59 AM, Richard Cheng wrote:
> On Sat, Oct 10, 2026 at 09:50:13PM +0800, Shaikh Kamaluddin wrote:
>> The trigger_poison_list interface may retrieve poison after CXL memory
>> is already online, which is too late to prevent known-bad frames from
>> entering the page allocator.
>>
>> During RAM-region probe, retrieve a poison-list snapshot for each
>> participating endpoint decoder. Validate each record against the
>> decoder's assigned DPA range, translate its poisoned DPA units to HPA
>> and PFN, and collect the affected PFNs in an xarray. Coalesce consecutive
>> PFNs and register the resulting ranges with the pre-online hwpoison
>> registry before creating the DAX region.
>>
>> When Get Poison List is supported, abort region probe if the list is
>> incomplete, malformed, or cannot be translated. If volatile poison-list
>> retrieval is unsupported, preserve the existing behavior and warn that
>> poison cannot be withheld before memory onlining.
>>
>> Signed-off-by: Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
>> ---
>>  drivers/cxl/core/region.c | 322 ++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 322 insertions(+)
>>
>> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
>> index c72524923b38..e3ffa77927df 100644
>> --- a/drivers/cxl/core/region.c
>> +++ b/drivers/cxl/core/region.c
>> @@ -14,6 +14,7 @@
>>  #include <linux/string_choices.h>
>>  #include <cxlmem.h>
>>  #include <cxl.h>
>> +#include <linux/memory-failure.h>
>>  #include "core.h"
>>  #include "mce.h"
>>  
>> @@ -3038,6 +3039,323 @@ int cxl_get_poison_by_endpoint(struct cxl_port *port)
>>  	return rc;
>>  }
>>  
>> +/*
>> + * Device-reported poison is gathered at RAM-region probe, before the range
>> + * reaches dax/kmem, and registered with the pre-online registry so the
>> + * frames it covers are withheld when the memory is onlined.
>> + */
>> +static int cxl_poison_store_pfn(struct xarray *pfns, u64 hpa)
>> +{
>> +	return xa_err(xa_store(pfns, PHYS_PFN(hpa), xa_mk_value(1),
>> +			GFP_KERNEL));
>> +}
>> +
>> +static int cxl_poison_store_hpa(struct cxl_region *cxlr, struct xarray *pfns,
>> +				u64 hpa)
>> +{
>> +	struct cxl_region_params *p = &cxlr->params;
>> +	int rc;
>> +
>> +	/* Outside this region: not ours to withhold. */
>> +	if (!cxl_resource_contains_addr(p->res, hpa))
>> +		return -ERANGE;
>> +
>> +	rc = cxl_poison_store_pfn(pfns, hpa);
>> +	if (rc || !p->cache_size)
>> +		return rc;
>> +
>> +	/*
>> +	 * An extended linear cache makes the same DPA visible a second time
>> +	 * at hpa - cache_size. Match the translation used by the
>> +	 * cxl_general_media and cxl_dram trace events.
>> +	 */
>> +	if (WARN_ON_ONCE(hpa < p->res->start + p->cache_size))
>> +		return -ERANGE;
>> +
>> +	return cxl_poison_store_pfn(pfns, hpa - p->cache_size);
>> +}
>> +
>> +static int cxl_poison_record_to_pfns(struct cxl_region *cxlr,
>> +				     struct cxl_memdev *cxlmd,
>> +				     const struct cxl_poison_record *record,
>> +				     struct xarray *pfns)
>> +{
>> +	struct cxl_region_params *p = &cxlr->params;
>> +	u64 raw = le64_to_cpu(record->address);
>> +	u64 units = le32_to_cpu(record->length);
>> +	u64 dpa = raw & CXL_POISON_START_MASK;
>> +	u8 source = raw & CXL_POISON_SOURCE_MASK;
>> +	u64 length, end, step, cur;
>> +
>> +	if (!units ||
>> +	    check_mul_overflow(units, (u64)CXL_POISON_LEN_MULT, &length) ||
>> +	    check_add_overflow(dpa, length, &end))
>> +		return -EPROTO;
>> +
>> +	/*
>> +	 * A corrected error never reaches the poison list, so every record
>> +	 * is uncorrectable. Only a failure of the device's own media is
>> +	 * withheld: External poison was written by the host into healthy
>> +	 * media and a rewrite or Clear Poison recovers it, and Injected
>> +	 * poison is a test artifact. Withholding either would make a
>> +	 * recoverable state permanent.
>> +	 */
>> +	if (source != CXL_POISON_SOURCE_INTERNAL) {
>> +		dev_dbg(&cxlr->dev, "%s: dpa %#llx source %u not withheld\n",
>> +			dev_name(&cxlmd->dev), dpa, source);
>> +		return 0;
>> +	}
>> +
>> +	/*
>> +	 * Translate once per unit of HPA contiguity rather than per 64
>> +	 * bytes. Consecutive DPAs within an interleave granule map to
>> +	 * consecutive HPAs, and a granule no larger than a page lies within
>> +	 * one page, so stepping by min(granule, PAGE_SIZE) from an aligned
>> +	 * start reaches every page the record covers.
>> +	 */
>> +	step = clamp_t(u64, p->interleave_granularity, CXL_POISON_LEN_MULT,
>> +		       PAGE_SIZE);
>> +
>> +	for (cur = ALIGN_DOWN(dpa, step); cur < end; cur += step) {
>> +		u64 hpa = cxl_dpa_to_hpa(cxlr, cxlmd, max(cur, dpa));
>> +		int rc;
>> +
>> +		/* Not mapped by this region; nothing here to withhold. */
>> +		if (hpa == ULLONG_MAX)
>> +			continue;
>> +
>> +		rc = cxl_poison_store_hpa(cxlr, pfns, hpa);
>> +		if (rc)
>> +			return rc;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int cxl_region_collect_decoder_poison(struct cxl_region *cxlr,
>> +					     struct cxl_endpoint_decoder *cxled,
>> +					     struct xarray *pfns)
>> +{
>> +	struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
>> +	struct cxl_poison_snapshot snapshot;
>> +	int rc;
>> +
>> +	rc = cxl_poison_snapshot_init(cxlmd, &snapshot);
>> +	if (rc == -EOPNOTSUPP) {
>> +		dev_info(&cxlr->dev,
>> +			 "%s: no Get Poison List support, nothing withheld\n",
>> +			 dev_name(&cxlmd->dev));
>> +		return 0;
>> +	}
>> +	if (rc)
>> +		return rc;
>> +
>> +	rc = cxl_get_poison_by_decoder(cxled, &snapshot,
>> +				       CXL_POISON_QUERY_PREONLINE);
>> +	if (rc == -EFAULT) {
>> +		/*
>> +		 * The device keeps no poison list for volatile ranges, which
>> +		 * CXL r3.2 8.2.9.8.4.1 permits. Online the region as today.
>> +		 */
>> +		dev_info(&cxlr->dev,
>> +			 "%s: no volatile poison list, nothing withheld\n",
>> +			 dev_name(&cxlmd->dev));
>> +		rc = 0;
>> +		goto out;
>> +	}
>> +	if (rc)
>> +		goto out;
>> +
>> +	/*
>> +	 * Withholding from a partial list would online the region on the
>> +	 * belief that every bad frame had been named.
>> +	 */
>> +	if (snapshot.truncated ||
>> +	    (snapshot.device_flags & CXL_POISON_FLAG_OVERFLOW)) {
>> +		dev_err(&cxlr->dev, "%s: poison list incomplete\n",
>> +			dev_name(&cxlmd->dev));
>> +		rc = -EOVERFLOW;
>> +		goto out;
>> +	}
>> +	if (snapshot.device_flags & CXL_POISON_FLAG_SCANNING) {
>> +		dev_err(&cxlr->dev, "%s: media scan in progress\n",
>> +			dev_name(&cxlmd->dev));
>> +		rc = -EBUSY;
>> +		goto out;
>> +	}
>> +
>> +	for (u32 i = 0; i < snapshot.nr_records; i++) {
>> +		rc = cxl_poison_record_to_pfns(cxlr, cxlmd,
>> +					       &snapshot.records[i], pfns);
>> +		if (rc)
>> +			break;
>> +	}
>> +out:
>> +	cxl_poison_snapshot_destroy(&snapshot);
>> +	return rc;
>> +}
>> +
>> +static unsigned int cxl_count_poison_ranges(struct xarray *pfns)
>> +{
>> +	unsigned long index, previous = 0;
>> +	unsigned int nr = 0;
>> +	void *entry;
>> +	bool first = true;
>> +
>> +	xa_for_each(pfns, index, entry) {
>> +		if (first || index != previous + 1)
>> +			nr++;
>> +		first = false;
>> +		previous = index;
>> +	}
>> +	return nr;
>> +}
>> +
>> +/*
>> + * The xarray holds each PFN once and xa_for_each() walks them in ascending
>> + * order, so runs of consecutive indices are exactly the sorted,
>> + * nonoverlapping ranges preonline_hwpoison_register() requires.
>> + */
>> +static int cxl_pfns_to_ranges(struct xarray *pfns,
>> +			      struct preonline_hwpoison_range **ranges_out,
>> +			      unsigned int *nr_ranges_out)
>> +{
>> +	struct preonline_hwpoison_range *ranges;
>> +	unsigned long index, previous = 0, run_start = 0;
>> +	unsigned int nr_ranges, nr = 0;
>> +	void *entry;
>> +	bool first = true;
>> +
>> +	nr_ranges = cxl_count_poison_ranges(pfns);
>> +	if (!nr_ranges) {
>> +		*ranges_out = NULL;
>> +		*nr_ranges_out = 0;
>> +		return 0;
>> +	}
>> +
>> +	ranges = kvmalloc_array(nr_ranges, sizeof(*ranges), GFP_KERNEL);
>> +	if (!ranges)
>> +		return -ENOMEM;
>> +
>> +	xa_for_each(pfns, index, entry) {
>> +		if (first) {
>> +			run_start = index;
>> +			previous = index;
>> +			first = false;
>> +			continue;
>> +		}
>> +		if (index == previous + 1) {
>> +			previous = index;
>> +			continue;
>> +		}
>> +		ranges[nr++] = (struct preonline_hwpoison_range) {
>> +			.start_pfn = run_start,
>> +			.nr_pages = previous - run_start + 1,
>> +		};
>> +		run_start = index;
>> +		previous = index;
>> +	}
>> +	ranges[nr++] = (struct preonline_hwpoison_range){
>> +		.start_pfn = run_start,
>> +		.nr_pages = previous - run_start + 1,
>> +	};
>> +
>> +	WARN_ON_ONCE(nr != nr_ranges);
>> +	*ranges_out = ranges;
>> +	*nr_ranges_out = nr;
>> +	return 0;
>> +}
>> +
>> +static void cxl_unregister_device_poison(void *data)
>> +{
>> +	preonline_hwpoison_unregister(data);
>> +}
>> +
>> +static int cxl_region_register_device_poison(struct cxl_region *cxlr)
>> +{
>> +	struct cxl_region_params *p = &cxlr->params;
>> +	struct preonline_hwpoison_range *ranges = NULL;
>> +	struct preonline_hwpoison *handle;
>> +	unsigned int nr_ranges = 0;
>> +	unsigned long nr_frames = 0;
>> +	struct xarray pfns;
>> +	int rc = 0;
>> +
>> +	lockdep_assert_held(&cxl_rwsem.region);
>> +	lockdep_assert_held(&cxl_rwsem.dpa);
>> +
>> +	/* The region may have been decommitted while the lock was dropped. */
>> +	if (p->state < CXL_CONFIG_COMMIT)
>> +		return -ENXIO;
>> +
>> +	if (test_bit(CXL_REGION_F_NORMALIZED_ADDRESSING, &cxlr->flags)) {
>> +		dev_info(&cxlr->dev,
>> +			 "normalized addressing, poison not translated\n");
>> +		return 0;
>> +	}
>> +
>> +	xa_init(&pfns);
>> +
>> +	for (int i = 0; i < p->nr_targets; i++) {
>> +		struct cxl_endpoint_decoder *cxled = p->targets[i];
>> +
>> +		if (!cxled->dpa_res || !resource_size(cxled->dpa_res))
>> +			continue;
>> +		rc = cxl_region_collect_decoder_poison(cxlr, cxled, &pfns);
>> +		if (rc)
>> +			goto out;
>> +	}
>> +
>> +	if (xa_empty(&pfns))
>> +		goto out;
>> +
>> +	rc = cxl_pfns_to_ranges(&pfns, &ranges, &nr_ranges);
>> +	if (rc)
>> +		goto out;
>> +
>> +	rc = preonline_hwpoison_register(ranges, nr_ranges, &handle);
>> +	if (rc == -EOPNOTSUPP) {
>> +		/* No poison tracking in this kernel; nothing to withhold. */
>> +		rc = 0;
>> +		goto out;
>> +	}
>> +	if (rc)
>> +		goto out;
>> +
>> +	for (unsigned int i = 0; i < nr_ranges; i++)
>> +		nr_frames += ranges[i].nr_pages;
>> +	dev_warn(&cxlr->dev,
>> +		 "withholding %lu frame(s) reported poisoned by the device\n",
>> +		 nr_frames);
>> +
>> +	rc = devm_add_action_or_reset(&cxlr->dev, cxl_unregister_device_poison,
>> +				      handle);
> 
> Hi Shaikh,
> 
> I think you are trying to propose the architecture as the following ?
> - CXL region driver collects the device's poison info and owns the registration
> - MM use the registration to keep poisoned pages out of the page allocator
>   when memory is onlined
> - DAX/kmem adds and removes the corresponding system RAM
> 
> The registration belongs to the driver, but the memory that needs it can
> outlive the driver binding.
> 
> Unbinding the driver doesn't necessarily remove the memory. If some mem blocks
> are still online, removal of the range can fail.
> When driver cleanup removes the registration, MM loses poison info of those
> memory blocks as well.
> 
> I don't have a good idea how we should re-design the ownership here, maybe
> we can discuss about it.

Maybe MM should own the registry and keyed by physical range. Then the lifetime of the poison would match the region being put into MM? The CXL driver would only need to add entries. 

> 
> Best regards,
> Richard Cheng.
> 

