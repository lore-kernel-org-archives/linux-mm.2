Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB352CCF2C9
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 18:51:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0C456B0095; Sat, 17 Oct 2026 14:51:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE3266B0096; Sat, 17 Oct 2026 14:51:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD29B6B0098; Sat, 17 Oct 2026 14:51:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7A9776B0095
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 14:51:35 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DDC8B160382
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 18:51:34 +0000 (UTC)
X-FDA: 85333011708.02.355A085
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2818F80005
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 18:51:33 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jm+M18Hk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of jic23@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jic23@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792263093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7p2v8cd8Piqf2r8JBIYxKwNid9G5UEqcxbvv8thHaUg=;
	b=SJ1fKwMLS91H8RzoxJ82g/iLrFuYRWISEe7TJyijz9Du4NTCv9/SEoQL4AiiJoUpoYaB2Y
	6Izsg1mCbtW2EcN4NkGB6+aAT2Cko1KwDi6zoM5KP8EBKopYe6dlA2EPXc0LpvRAmI+toQ
	eHJgJdWDAWoHWZGGCXHHpleqHhtPdLM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jm+M18Hk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of jic23@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jic23@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792263093;
	b=WvjHGAYoMTBVDIr5iOBYHcOZBl+P9o+lH/1U5j5d3wsbn1E/cpLj/wzeIV30SvpXKzYT/i
	NGSsgytTy5fdXqhGufaRTntJHhjrrTCbE5jSoOpqTARznz7bft0+MeFmghAaM9fiXJCWxr
	LYvz7FDyOfsEDrGnBSvK3EMdehPvkys=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 78AF0435E1;
	Sat, 17 Oct 2026 18:51:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD12E1F000C4;
	Sat, 17 Oct 2026 18:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792263092;
	bh=7p2v8cd8Piqf2r8JBIYxKwNid9G5UEqcxbvv8thHaUg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Jm+M18HkZppQqg/RREcrWCrGXHylE+GKhzJrKgu4eSkw+4c31hXYZ2PhX+qwGC8xc
	 eqm2gtYAO8klRIZE95rlvV4LHqITWTVKQFF2hP/Uv5XHKIe5OyQf1Ia3KVA0Kh5hwb
	 Hhp6QGzws/nXpRj2gMUj2yEseWibGecmuURxzTyTV0UU+TFroIQDwwZivTcpcrnAeR
	 5+CpOfbPN1RJ+CIZg1O9ffWRS1dRCImzvmeoIe6nNeDLTnDDfqq1GHbgwBfNe+Ir5p
	 rqWGQIEPfXlgMciqlPdovRGsyLC8NoXW0fWwli9l3JPhBrzl2hg/pzcFamxmP5LXUg
	 DEtpYO7DKUb2Q==
Date: Fri, 16 Oct 2026 23:18:27 +0100
From: Jonathan Cameron <jic23@kernel.org>
To: Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>, Dave Jiang <dave.jiang@intel.com>,
 Alison Schofield <alison.schofield@intel.com>, Vishal Verma
 <vishal.l.verma@intel.com>, Dan Williams <djbw@kernel.org>, Miaohe Lin
 <linmiaohe@huawei.com>, Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Breno Leitao <leitao@debian.org>, Ira
 Weiny <iweiny@kernel.org>, Li Ming <ming.li@zohomail.com>, Richard Cheng
 <icheng@nvidia.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan
 Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, David Hildenbrand
 <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, Kiryl Shutsemau
 <kas@kernel.org>, Harry Yoo <harry@kernel.org>
Subject: Re: [RFC PATCH 1/5] cxl/mbox: Add Get Poison List snapshot support
Message-ID: <20261016231827.074e0326@jic23-hlaptop>
In-Reply-To: <20261010162017.62506-2-shaikhkamal2012@gmail.com>
References: <20261010162017.62506-1-shaikhkamal2012@gmail.com>
	<20261010162017.62506-2-shaikhkamal2012@gmail.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2818F80005
X-Stat-Signature: bcg5u8acjethd6g5szw6g3mdeho6rzms
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1792263093-904743
X-HE-Meta: U2FsdGVkX18klazAyYh2Zn/1VBRmsZfobCYkSX89ZgOpUC03pKPCUaOz5nFDqp4Xwoe+QCo9nKls86KVOMIMW/oaHUg8njNPzaFXZG0DwY/FL08qAaa126xeZJ46xthPssRYindQab+ovqW/JTpikZryOyCSsI8sCOSYVhILeLrn/2VuE3bHRyetf7hg4wRNiTfefZfpEF3SKhH35MIOyubjAeYcJdVkQizPvNpMbaMbjhksKAeB8D9lUfyhh4P5k6TsUR7mXuNeO8Rjtj37meX3Ge8+mtmKMcV6pZxPXg29gP2Vlr68hSCo1Zw+6NtQKSJYTcVfNblFvJdFqAvN7tGVxL8+OA5FNoN9YWEoFkfgNuF22klc0cP6VEsIx4w+swuwVloXBQL4IswLwzdJZox1h+empRMX2Gmusk6EQ43mD+fkJhk2fh+hkGRvz4xqCKZ8gR8d1BEC3w7fCwsoi4GFW61F+JMwc75vzIxUpmr8AWJd4i5QIKf7PNZ0nQKVvBXGvUw48S7y67Q89YHr+rTbNuj7Gtm1RTo2Rv2HA03Dm8b9hjAA6rDRBSbIsmvaQ90QXjM3zUer/oXjbJGU03TGJ8++MOF14lhkfeVRD+10A/EFpYznUTDlDL05ST9fjE9PzXEJqw3XUGntgmMb48yCKy219qsY7qGtfheMj7dkzoVH7yZR5jbI4QS7TrnwpBDbITsNXSeyUa5rEun24PH7ywJRBOkh1AAtnE57AgIjs3OGe6ldpI0T6P+C4h/qsTh+uGXu1lwTHn24mK+UfCF3wzXNDFzda7P5CFFIcEjd0yEEIm74dCtecedALOm6qtG6M7dbw4dZzMHZewAE1tLjlFuxXK35YN/gewEnz0CWRBNAx0Sz7j02DGD8/f2pfj3PTL+MXJ7GbEP5UBhttg1aQSuz7Yj/FcpKkxsc6wIO7DKd+668dlSptteYg/XYdpYQg0I7NHHQ9cUv+QF
 8vtj9Jvl
 zgVNzyF9U5TcFsPifGZW+K2Ydmhq7KlpI5tv4LUkO2JoBrkEZdSdZvczpuOkDDD+esaGOOZRQh9Ayl0HGEJD0JwodHbipuWN7M9W9lyP05pCpbcofHSQ1PSt6iQeHeMqz8GX9/Kg6C06/zDg477qT8sLsYFrDpVpHPWhpAEa19hSY2dP/LjRIsj2fAgrkD4gtGToRku2ntQNyzI/BM9L8Yev+bMF0lNrmQNaBrojl9x3bpDxuZ73LmivtZScOxioIusOsjG+C/NfzUvi6b8Q+ZAMQFT76WTRSexRDU/bSTn4NRnGnTydr738MwHF5EoilSrOv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 10 Oct 2026 21:50:09 +0530
Shaikh Kamaluddin <shaikhkamal2012@gmail.com> wrote:

> cxl_mem_get_poison() uses a device-owned output buffer for each Get
> Poison List response. It traces the records before issuing the next
> command, which overwrites that buffer when the device sets the More
> Media Error Records flag. A caller therefore cannot inspect the complete
> set of collected records after the function returns.
> 
> Add a caller-owned snapshot and copy each validated mailbox response
> into it. Preserve device overflow and scan-in-progress status, and
> indicate when the host stops collection before retrieving all available
> records.
> 
> Keep cxl_mem_get_poison() as the existing trace-only wrapper so its
> current callers, including trigger_poison_list, retain their behavior.
> 
> Signed-off-by: Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
> ---
>  drivers/cxl/core/mbox.c | 137 ++++++++++++++++++++++++++++++++++++++--
>  drivers/cxl/cxlmem.h    |  25 ++++++++
>  2 files changed, 156 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index 55828a836c01..2752b46ffee2 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
> @@ -1376,14 +1376,91 @@ int cxl_set_timestamp(struct cxl_memdev_state *mds)
>  }
>  EXPORT_SYMBOL_NS_GPL(cxl_set_timestamp, "CXL");
>  
> -int cxl_mem_get_poison(struct cxl_memdev *cxlmd, u64 offset, u64 len,
> -		       struct cxl_region *cxlr)
> +int cxl_poison_snapshot_init(struct cxl_memdev *cxlmd,
> +			     struct cxl_poison_snapshot *snapshot)
> +{
> +	struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlmd->cxlds);
> +	u32 capacity = mds->poison.max_errors;
> +
> +	if (!snapshot)

That seems like a buggy use of the interface, so not sure we need
that defence.

> +		return -EINVAL;
> +	memset(snapshot, 0, sizeof(*snapshot));
> +
> +	if (!test_bit(CXL_POISON_ENABLED_LIST, mds->poison.enabled_cmds))
> +		return -EOPNOTSUPP;
> +
> +	if (!capacity)
> +		return -EPROTO;
> +
> +	snapshot->records = kvmalloc_array(mds->poison.max_errors,
> +					   sizeof(*snapshot->records),
> +					   GFP_KERNEL);

kvmalloc_objs()?

> +	if (!snapshot->records)
> +		return -ENOMEM;
> +
> +	snapshot->capacity = capacity;
> +
> +	return 0;
> +}
> +
> +void cxl_poison_snapshot_destroy(struct cxl_poison_snapshot *snapshot)
> +{
> +	if (!snapshot)
> +		return;
> +
> +	kvfree(snapshot->records);
> +	memset(snapshot, 0, sizeof(*snapshot));
> +}
> +
> +static int cxl_poison_snapshot_append(struct cxl_poison_snapshot *snapshot,
> +				      struct cxl_poison_record *records,
> +				      u32 count)
> +{
> +	u32 available;
> +
> +	/*
> +	 * Existing cxl_mem_get_poison() callers request tracing only and
> +	 * pass no snapshot.
> +	 */
> +
> +	if (!snapshot)
> +		return 0;
> +
> +	if (!snapshot->records)
> +		return -EINVAL;
> +
> +	if (snapshot->nr_records > snapshot->capacity)
> +		return -EOVERFLOW;
> +
> +	if (!count)
> +		return 0;
> +
> +	if (!records)
> +		return -EINVAL;
> +
> +	available = snapshot->capacity - snapshot->nr_records;
> +	if (count > available) {
> +		snapshot->truncated = true;
> +		return -ENOSPC;
> +	}
> +
> +	memcpy(&snapshot->records[snapshot->nr_records], records,
> +	       count * sizeof(*records));
> +	snapshot->nr_records += count;
> +
> +	return 0;
> +}
> +
> +static int cxl_mem_get_poison_common(struct cxl_memdev *cxlmd, u64 offset,
> +				     u64 len, struct cxl_region *cxlr,
> +				     struct cxl_poison_snapshot *snapshot)
>  {
>  	struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlmd->cxlds);
>  	struct cxl_mailbox *cxl_mbox = &cxlmd->cxlds->cxl_mbox;
>  	struct cxl_mbox_poison_out *po;
>  	struct cxl_mbox_poison_in pi;
> -	int nr_records = 0;
> +	u32 nr_records = 0;
> +	u32 count;
>  	int rc;
>  
>  	ACQUIRE(mutex_intr, lock)(&mds->poison.mutex);
> @@ -1408,29 +1485,77 @@ int cxl_mem_get_poison(struct cxl_memdev *cxlmd, u64 offset, u64 len,
>  		if (rc)
>  			break;
>  
> -		if (!le16_to_cpu(po->count)) {
> +		count = le16_to_cpu(po->count);
> +		if (!count) {
>  			dev_dbg(&cxlmd->dev, "Poison empty payload!\n");
> +
> +			if (po->flags & CXL_POISON_FLAG_MORE) {
> +				if (snapshot)
> +					snapshot->truncated = true;

Count of zero and yet more? How would that happen? This smells like
a hardware bug.  Maybe we defend against it, but that's a separate
question from the rest of this patch.

> +				rc = -EPROTO;
> +			}
> +
> +			break;
> +		}
> +
> +		if (struct_size(po, record, count) > mbox_cmd.size_out) {
> +			dev_err(&cxlmd->dev,
> +				"invalid poison record count: %u\n", count);

Also looks like broken hardware. I don't necessarily mind that sort
of defense, but not in a patch doing anything else.

> +			rc = -EPROTO;
>  			break;
>  		}
>  
> -		for (int i = 0; i < le16_to_cpu(po->count); i++)
> +		for (u32 i = 0; i < count; i++)
>  			trace_cxl_poison(cxlmd, cxlr, &po->record[i],
>  					 po->flags, po->overflow_ts,
>  					 CXL_POISON_TRACE_LIST);
>  
> +		if (snapshot && (po->flags & CXL_POISON_FLAG_OVERFLOW)) {
> +			snapshot->device_flags |= CXL_POISON_FLAG_OVERFLOW;
> +			snapshot->overflow_ts = le64_to_cpu(po->overflow_ts);
> +		}

I'm curious. What use is the overflow_ts in your scheme?  Lets keep things
minimal unless there is a reason to add data to the snapshot.

> +
> +		if (snapshot && (po->flags & CXL_POISON_FLAG_SCANNING))
> +			snapshot->device_flags |= CXL_POISON_FLAG_SCANNING;
> +
> +		rc = cxl_poison_snapshot_append(snapshot, po->record, count);
> +		if (rc)
> +			break;
> +
>  		/* Protect against an uncleared _FLAG_MORE */
> -		nr_records = nr_records + le16_to_cpu(po->count);
> +		nr_records += count;
>  		if (nr_records >= mds->poison.max_errors) {
>  			dev_dbg(&cxlmd->dev, "Max Error Records reached: %d\n",
>  				nr_records);
> +			if (snapshot && (po->flags & CXL_POISON_FLAG_MORE))
> +				snapshot->truncated = true;
> +
>  			break;
>  		}
>  	} while (po->flags & CXL_POISON_FLAG_MORE);
>  
>  	return rc;
>  }
> +
> +int cxl_mem_get_poison(struct cxl_memdev *cxlmd, u64 offset, u64 len,
> +		       struct cxl_region *cxlr)
> +{
> +	return cxl_mem_get_poison_common(cxlmd, offset, len, cxlr, NULL);
> +}
>  EXPORT_SYMBOL_NS_GPL(cxl_mem_get_poison, "CXL");
>  
> +int cxl_mem_get_poison_snapshot(struct cxl_memdev *cxlmd, u64 offset, u64 len,
> +				struct cxl_region *cxlr,
> +				struct cxl_poison_snapshot *snapshot)
> +{
> +	if (!snapshot || !snapshot->records || !snapshot->capacity)
> +		return -EINVAL;
> +
> +	if (snapshot->nr_records > snapshot->capacity)
> +		return -EOVERFLOW;
> +
> +	return cxl_mem_get_poison_common(cxlmd, offset, len, cxlr, snapshot);
> +}

Blank line here

>  static void free_poison_buf(void *buf)
>  {
>  	kvfree(buf);
> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index c401e3a1af06..1d6f8d958bd2 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h
> @@ -812,6 +812,31 @@ int cxl_set_timestamp(struct cxl_memdev_state *mds);
>  int cxl_poison_state_init(struct cxl_memdev_state *mds);
>  int cxl_mem_get_poison(struct cxl_memdev *cxlmd, u64 offset, u64 len,
>  		       struct cxl_region *cxlr);
> +
> +/**
> + * struct cxl_poison_snapshot - Aggregate Get Poison List result
> + * @records: Copied Media Error Records from all mailbox responses
> + * @nr_records: Number of valid records stored in @records
> + * @capacity: Maximum number of records that @records can hold
> + * @overflow_ts: Timestamp associated with a reported device overflow
> + * @device_flags: Persistent device status observed during collection
> + * @truncated: Host stopped before collecting all available records
> + */
> +struct cxl_poison_snapshot {
> +	struct cxl_poison_record *records;

__counted_by_ptr() seems likely to apply here.
 
> +	u32 nr_records;
> +	u32 capacity;
> +	u64 overflow_ts;

As above. I'd like to ensure this only stashes what we actually need.

> +	u8 device_flags;
> +	bool truncated;
> +};
> +
> +int cxl_poison_snapshot_init(struct cxl_memdev *cxlmd,
> +			     struct cxl_poison_snapshot *snapshot);
> +void cxl_poison_snapshot_destroy(struct cxl_poison_snapshot *snapshot);
> +int cxl_mem_get_poison_snapshot(struct cxl_memdev *cxlmd, u64 offset, u64 len,
> +				struct cxl_region *cxlr,
> +				struct cxl_poison_snapshot *snapshot);
>  int cxl_trigger_poison_list(struct cxl_memdev *cxlmd);
>  int cxl_inject_poison(struct cxl_memdev *cxlmd, u64 dpa);
>  int cxl_clear_poison(struct cxl_memdev *cxlmd, u64 dpa);


