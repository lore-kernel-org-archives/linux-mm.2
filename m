Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75AD8606A323
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 23:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=A2jBML0L
Received: by kanga.kvack.org (Postfix)
	id 869946B05B0; Mon, 16 Nov 2026 18:45:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 841AE6B05B2; Mon, 16 Nov 2026 18:45:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 731ED6B05B3; Mon, 16 Nov 2026 18:45:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2E4706B05B0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:45:49 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A546B1A025A
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:45:48 +0000 (UTC)
X-FDA: 85442617176.01.D43EDA6
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	by imf29.hostedemail.com (Postfix) with ESMTP id CA8CD120005
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:45:46 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=A2jBML0L;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of shaikhkamal2012@gmail.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=shaikhkamal2012@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794872746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8io0HU9dwDVPEIPqWjgCxaStVmef8ZQiuaFzcnNz1Oc=;
	b=WTgdHDCeUxyxzp4d6ZoFQz1HF32rDjq7MRwaDnEqSgApOwin43MoVdF5dJHTg337YmqfLj
	ENRmZ9D3nKdju+x9T/UR6g9adM9VxSWqnuE+zGncan73hf11wWumKHJUeRRyx1wI71OFU/
	Xi/aJ9I5oFMqdZFcv73NI1ajAYFP0gA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=A2jBML0L;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of shaikhkamal2012@gmail.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=shaikhkamal2012@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794872746;
	b=6fwGvfdHrtNWJTMMjQwQ9TyPcS7jwBiQ+XK1eCm6crau4NIfGZ5HCNcQcfNjfFEXVs/duB
	XhGF8LtnyfRJXjbhh3dNJlAE6+EC2mhRoSke/q3rgjzlvkelCF9JrmxoEME+AycU9kpvGH
	508Ad+cMYCe90zeURKzZi65zCzQdGV8=
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-36fc0a3fe93so7696605eec.0
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:45:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794872745; x=1795477545; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8io0HU9dwDVPEIPqWjgCxaStVmef8ZQiuaFzcnNz1Oc=;
        b=A2jBML0LmnjhTv3h3SGrsQc595rxAH+wzePQTsALpBxgjsWSGudBZCENkXRC45FTN7
         4nGxPffDEc8s+HXJ1EMfY1iUCE+jngte0iOJq1IPTum7pn7QKMX7lZ2X1O19frJOpJVg
         R8gXSayIsDG8x6HW4QubeLiDabZiS+AdXQC9pSdAln3n0WdB2lEPLI5oxojGahc3mXK8
         WFXr4XSAklYrzcvyWf8KmsNP/RAlkJkesliy3jaizuIxpnefCfz09s0kX8/u3Gi3AAco
         SFM9dAIr90oe0rH6NHLdfo2t94SMGrLrRpLNCjLUg+VxQwwTIgSwKrDCQ8PK55/UewlI
         k6Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794872745; x=1795477545;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8io0HU9dwDVPEIPqWjgCxaStVmef8ZQiuaFzcnNz1Oc=;
        b=wBaJ3o2lAHoOWQEgVUXLibjoji7bf6IeZFeiXMAJyI9y696ZFpjoROzslgnnAwJUR/
         qMX/21nwCUl4zg9Zg7ZVa1nL8ovObTRP+sRQg+L4j5CQXJObmskcY0bzfHWxf/+bY+n9
         RqhM1TMRUfUq7pYOQU4xjol+NXtU23vIvp96APq3eEdw04yM1mt0EdVVtg+YfPNkDvRY
         O8daJxCG2bUpdWEuYeXyQgwMVMfCWtPG+vuJQPHyt7mH89ckccT02um4SaCQSloHFlnH
         pJPUYbcfUEWhrwyLYezJeVVl8jbgDSWMnrpAXG5hwlwuZ9PBA9zpwAPcpsiTOh5FPhHw
         6Rug==
X-Forwarded-Encrypted: i=1; AL+hErGqJuPeI81URuYcZgq659G8Q51WrzzRyc7RHVX4O+lc28pk7VONT1Qe9Lw3l5Mmc2cJuKEuqnIJSQ==@kvack.org
X-Gm-Message-State: APuU4Z9jBc+dgdgkUwI3UowLiOB6XSTIFc7r/5LvgE8YcVX5Z2pSBEEk
	idYZYBJxpnbrOxVF/Y7f5oBtpFeTIhwjWzen0QzJpGnF3vbcThd6PVnD
X-Gm-Gg: AZFdTZf7X6oGu00L8NCTo41KVWnH/U9YO3AYROJQAVnAJXZJOtNw18nMG+IdJR8fHsK
	/o1xGCTSbPJ/pzjDwvmxxg15JDsrR8iBNA0tutWqqVd0Jbk2CTmHXw0i8v+SnUGjcfYpkGzf5AV
	ND5EzR1+wO4yFxaWhPG7MjyRFQDdR1bkyEOLkj2tNy3kj4029jbSBcg9xNhuYDC6AoDuhS0XOTy
	AzdnDblVJCrrbLgKUUxQ1dko9HQ3uIWNeVJx/65NeDg3DxX7q7bpraghQLAEL58k5wlxELqGXYB
	+zQZl6RTB3744LTBkKIWbwQrnak1W/bHAxVJn4xa+GNspy1WKwvtgXRA2WSoR37nGROpMMXjsyn
	qyOaManMAmoUoDbvtGTzjw8komzmmOp47YzAnpOq3sddaq/ne8tQZxG8DDNXV3cxqN+YajIX2Jv
	C+d4zS7X+MC5+HfJUOdyDxSZmdLzaJrhC1IcJ66tSH0+3kJ3+wxhAfGL4lUlIthlh7f1QsBMCGv
	xGlyygnH7VTNR4V3NHjKbfqIN1qD9ZfO7kqEW54JGiq2+FMMNdbh/XAFJ4NRxICx3rGtWo9ytss
	X7smQsHBZ+5t30Ydo3TXP4Vwjf/k2omEI+FXi7FckSOSKa0e3h32kmE=
X-Received: by 2002:a05:693c:60d0:b0:36d:9900:bb92 with SMTP id 5a478bee46e88-37965ca8056mr12098927eec.10.1794872745408;
        Mon, 16 Nov 2026 15:45:45 -0800 (PST)
Received: from localhost ([115.99.200.166])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-379565d07b3sm36175581eec.22.2026.11.16.15.45.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 15:45:44 -0800 (PST)
Date: Tue, 17 Nov 2026 05:15:41 +0530
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
Subject: Re: [RFC PATCH 1/5] cxl/mbox: Add Get Poison List snapshot support
Message-ID: <avuVpZx_6dkch9c2@acer-nitro-anv15-41>
References: <20261010162017.62506-1-shaikhkamal2012@gmail.com>
 <20261010162017.62506-2-shaikhkamal2012@gmail.com>
 <20261016231827.074e0326@jic23-hlaptop>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261016231827.074e0326@jic23-hlaptop>
X-Stat-Signature: fjzibfo8sucwqt6dkrpqkiikd9ma47cq
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CA8CD120005
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794872746-93864
X-HE-Meta: U2FsdGVkX1+Yxqxr33sN36OqD/frVVRZG2xiydS5tLEGm9YygKjWwDpk5MMK5tDTZpo/dISyWo904ctyZkzSrAfoYsafvvNEQzf1fhjWoUifTnY9wG9b6uzY/3H4/wV/tIYv0CirEJgA5YJjW+yD9i7gLyXByaZ7v84j4XoFTjQvd5XR9PNMBk+FbTfHPN8DKennW7gJESYo457/VKuzv4xTBEKUxeabZlDEiY899/L0lfWudouezkuC5yNVjGSrwQZtDUb/oqmLz+lKa+GWiWWjy63BOm8k4OtpE7T0Ezwgzoyb9oesH9l5VlXvoiIod0aahWL7VfYIo7yrohBaSxUmtt+33vnPPA1OWtmjEqdhRkYxdchGAzzQUxZL8ND0Vg+pCz8MFSBSRlHAa0cE4INOwAhQIyy8wWQIWTJAcZfMc813aSiz3ZjKFOHpDCpR204TXb+5fuvPNGesEp4OX24Ctqgde8Z1y94SAYgkduMLYIHbOY9fvSzGzzrQSnF6njaPOoUAJUrI96TTIz3f6XRHy9wVBxvZiZ7t39/GsjQbNqzLLAyk8sf9N4DyaKu+1DzbL5YjvEdvnb/y/5aIwRpWEbdLnogj0XoN3utQjek8CvAsYwCjwAnT+U7MsXf2KeIsV+4ZhFvckU9HbVVb3wC7zi+8RJkzrtg42Y3XtSP43HjuakUNlYgrw1KGJfnEsP6q0HKRr5BOiWIY8u8zxJh2/XTJUu2rfXkVnj4PwdElxXgb+VvQ0pTBjyapiqUD3M8GScnhA/guCGmGDsPOLBrnw7Knu/kmsMo4VPIsq+uLrIdNGaawZ8Aas42oxh6S7DWkrIsGcE6dOIB1DMx9hYhXY2Et03X8Xz9l257THHS7Xj69dA9I/XNYAE0iTaP45ibPcpofRFK4QQpGDeu8aFCfNt2gXEtY1OWKlP54BgMGqt+VZUU0/6W98skNgw7PMUIG5aevVhDry+EREv9
 JVLIIyJ7
 TTBNF8zx21W4/Asgg+nCzlxX7BvfyBQzX6wS90pR/BgsjUE6/lFcNsqEZxbRX3bt8i799vahc2u6rjG61rTALdBeQo3N4ZSVp2iYERTZkdRi2e30w5vd1xF0ikaEcj2VDKRugxN7yGl4sW8gKjZB33fRmOe4H+a9CUU6PRNoDDUBGl0k059QL+0hLpAQIKHKGUDbQvt5gCtzfu16QL0ycO4IcljKIKIyPS7LqLzcb5o4aBlHDt0lW/rrANPEvSjNts8n7czXCQXvabL4KHqlJgo9JY7JWJY4kXkz29SFxPgQtKq2u4jTT+i0Jp0fwl7V2JSYRxVcAZaMJzkN5eJ4z9OC2F1eTjEpre/nBdQXbx0a0Ow5TxJRv3l6Uyzc5wdHGTmt7iKCTGOAflinTWoMtGmf76oUzOJJ4O274SAGT9B+d69Y+zgwGEeZXUoKEj1aJ9Ec6kno/64O1fA2tWKJChTjeGs4zJcywu0j3dwal26yOJ/h2+uhTHh9pqm5yRUOZFC3Rq1mCQb8IqwM3wJkQ0RA8OP1tl19hphTQDJVQ7fqdtjda2MBABCz1dC0iKpLKD1IPO/qOwFNkvlE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 16, 2026 at 11:18:27PM +0100, Jonathan Cameron wrote:
> On Sat, 10 Oct 2026 21:50:09 +0530
> Shaikh Kamaluddin <shaikhkamal2012@gmail.com> wrote:
> 
> > cxl_mem_get_poison() uses a device-owned output buffer for each Get
> > Poison List response. It traces the records before issuing the next
> > command, which overwrites that buffer when the device sets the More
> > Media Error Records flag. A caller therefore cannot inspect the complete
> > set of collected records after the function returns.
> > 
> > Add a caller-owned snapshot and copy each validated mailbox response
> > into it. Preserve device overflow and scan-in-progress status, and
> > indicate when the host stops collection before retrieving all available
> > records.
> > 
> > Keep cxl_mem_get_poison() as the existing trace-only wrapper so its
> > current callers, including trigger_poison_list, retain their behavior.
> > 
> > Signed-off-by: Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
> > ---
> >  drivers/cxl/core/mbox.c | 137 ++++++++++++++++++++++++++++++++++++++--
> >  drivers/cxl/cxlmem.h    |  25 ++++++++
> >  2 files changed, 156 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> > index 55828a836c01..2752b46ffee2 100644
> > --- a/drivers/cxl/core/mbox.c
> > +++ b/drivers/cxl/core/mbox.c
> > @@ -1376,14 +1376,91 @@ int cxl_set_timestamp(struct cxl_memdev_state *mds)
> >  }
> >  EXPORT_SYMBOL_NS_GPL(cxl_set_timestamp, "CXL");
> >  
> > -int cxl_mem_get_poison(struct cxl_memdev *cxlmd, u64 offset, u64 len,
> > -		       struct cxl_region *cxlr)
> > +int cxl_poison_snapshot_init(struct cxl_memdev *cxlmd,
> > +			     struct cxl_poison_snapshot *snapshot)
> > +{
> > +	struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlmd->cxlds);
> > +	u32 capacity = mds->poison.max_errors;
> > +

Hi Jonathan,

Thanks for review, and sorry for the late reply.

> > +	if (!snapshot)
> 
> That seems like a buggy use of the interface, so not sure we need
> that defence.
> 

Agreed, I will drop it.

> > +		return -EINVAL;
> > +	memset(snapshot, 0, sizeof(*snapshot));
> > +
> > +	if (!test_bit(CXL_POISON_ENABLED_LIST, mds->poison.enabled_cmds))
> > +		return -EOPNOTSUPP;
> > +
> > +	if (!capacity)
> > +		return -EPROTO;
> > +
> > +	snapshot->records = kvmalloc_array(mds->poison.max_errors,
> > +					   sizeof(*snapshot->records),
> > +					   GFP_KERNEL);
> 
> kvmalloc_objs()?
>

Yes, will switch.

> > +	if (!snapshot->records)
> > +		return -ENOMEM;
> > +
> > +	snapshot->capacity = capacity;
> > +
> > +	return 0;
> > +}
> > +
> > +void cxl_poison_snapshot_destroy(struct cxl_poison_snapshot *snapshot)
> > +{
> > +	if (!snapshot)
> > +		return;
> > +
> > +	kvfree(snapshot->records);
> > +	memset(snapshot, 0, sizeof(*snapshot));
> > +}
> > +
> > +static int cxl_poison_snapshot_append(struct cxl_poison_snapshot *snapshot,
> > +				      struct cxl_poison_record *records,
> > +				      u32 count)
> > +{
> > +	u32 available;
> > +
> > +	/*
> > +	 * Existing cxl_mem_get_poison() callers request tracing only and
> > +	 * pass no snapshot.
> > +	 */
> > +
> > +	if (!snapshot)
> > +		return 0;
> > +
> > +	if (!snapshot->records)
> > +		return -EINVAL;
> > +
> > +	if (snapshot->nr_records > snapshot->capacity)
> > +		return -EOVERFLOW;
> > +
> > +	if (!count)
> > +		return 0;
> > +
> > +	if (!records)
> > +		return -EINVAL;
> > +
> > +	available = snapshot->capacity - snapshot->nr_records;
> > +	if (count > available) {
> > +		snapshot->truncated = true;
> > +		return -ENOSPC;
> > +	}
> > +
> > +	memcpy(&snapshot->records[snapshot->nr_records], records,
> > +	       count * sizeof(*records));
> > +	snapshot->nr_records += count;
> > +
> > +	return 0;
> > +}
> > +
> > +static int cxl_mem_get_poison_common(struct cxl_memdev *cxlmd, u64 offset,
> > +				     u64 len, struct cxl_region *cxlr,
> > +				     struct cxl_poison_snapshot *snapshot)
> >  {
> >  	struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlmd->cxlds);
> >  	struct cxl_mailbox *cxl_mbox = &cxlmd->cxlds->cxl_mbox;
> >  	struct cxl_mbox_poison_out *po;
> >  	struct cxl_mbox_poison_in pi;
> > -	int nr_records = 0;
> > +	u32 nr_records = 0;
> > +	u32 count;
> >  	int rc;
> >  
> >  	ACQUIRE(mutex_intr, lock)(&mds->poison.mutex);
> > @@ -1408,29 +1485,77 @@ int cxl_mem_get_poison(struct cxl_memdev *cxlmd, u64 offset, u64 len,
> >  		if (rc)
> >  			break;
> >  
> > -		if (!le16_to_cpu(po->count)) {
> > +		count = le16_to_cpu(po->count);
> > +		if (!count) {
> >  			dev_dbg(&cxlmd->dev, "Poison empty payload!\n");
> > +
> > +			if (po->flags & CXL_POISON_FLAG_MORE) {
> > +				if (snapshot)
> > +					snapshot->truncated = true;
> 
> Count of zero and yet more? How would that happen? This smells like
> a hardware bug.  Maybe we defend against it, but that's a separate
> question from the rest of this patch.
>

Agreed, it would be a device bug. I would still like to handle it: the
current code breaks out and returns 0 on an empty payload even with More
set, so the snapshot's caller can't tell the list was cut short, and
region probe would online the memory on the partial list.

I will take it out this series and send it as a separate patch, so this
only adds the snapshot.

> > +				rc = -EPROTO;
> > +			}
> > +
> > +			break;
> > +		}
> > +
> > +		if (struct_size(po, record, count) > mbox_cmd.size_out) {
> > +			dev_err(&cxlmd->dev,
> > +				"invalid poison record count: %u\n", count);
> 
> Also looks like broken hardware. I don't necessarily mind that sort
> of defense, but not in a patch doing anything else.
>

Same, it guards against a count larger than the returned payload, I will
move it into that patch as well.

> > +			rc = -EPROTO;
> >  			break;
> >  		}
> >  
> > -		for (int i = 0; i < le16_to_cpu(po->count); i++)
> > +		for (u32 i = 0; i < count; i++)
> >  			trace_cxl_poison(cxlmd, cxlr, &po->record[i],
> >  					 po->flags, po->overflow_ts,
> >  					 CXL_POISON_TRACE_LIST);
> >  
> > +		if (snapshot && (po->flags & CXL_POISON_FLAG_OVERFLOW)) {
> > +			snapshot->device_flags |= CXL_POISON_FLAG_OVERFLOW;
> > +			snapshot->overflow_ts = le64_to_cpu(po->overflow_ts);
> > +		}
> 
> I'm curious. What use is the overflow_ts in your scheme?  Lets keep things
> minimal unless there is a reason to add data to the snapshot.
>

None, as it turns out. Only the overflow flag is used, to fail the probe
when the list is incomplete. I will drop overflow_ts.

> > +
> > +		if (snapshot && (po->flags & CXL_POISON_FLAG_SCANNING))
> > +			snapshot->device_flags |= CXL_POISON_FLAG_SCANNING;
> > +
> > +		rc = cxl_poison_snapshot_append(snapshot, po->record, count);
> > +		if (rc)
> > +			break;
> > +
> >  		/* Protect against an uncleared _FLAG_MORE */
> > -		nr_records = nr_records + le16_to_cpu(po->count);
> > +		nr_records += count;
> >  		if (nr_records >= mds->poison.max_errors) {
> >  			dev_dbg(&cxlmd->dev, "Max Error Records reached: %d\n",
> >  				nr_records);
> > +			if (snapshot && (po->flags & CXL_POISON_FLAG_MORE))
> > +				snapshot->truncated = true;
> > +
> >  			break;
> >  		}
> >  	} while (po->flags & CXL_POISON_FLAG_MORE);
> >  
> >  	return rc;
> >  }
> > +
> > +int cxl_mem_get_poison(struct cxl_memdev *cxlmd, u64 offset, u64 len,
> > +		       struct cxl_region *cxlr)
> > +{
> > +	return cxl_mem_get_poison_common(cxlmd, offset, len, cxlr, NULL);
> > +}
> >  EXPORT_SYMBOL_NS_GPL(cxl_mem_get_poison, "CXL");
> >  
> > +int cxl_mem_get_poison_snapshot(struct cxl_memdev *cxlmd, u64 offset, u64 len,
> > +				struct cxl_region *cxlr,
> > +				struct cxl_poison_snapshot *snapshot)
> > +{
> > +	if (!snapshot || !snapshot->records || !snapshot->capacity)
> > +		return -EINVAL;
> > +
> > +	if (snapshot->nr_records > snapshot->capacity)
> > +		return -EOVERFLOW;
> > +
> > +	return cxl_mem_get_poison_common(cxlmd, offset, len, cxlr, snapshot);
> > +}
> 
> Blank line here
>

Will fix.

> >  static void free_poison_buf(void *buf)
> >  {
> >  	kvfree(buf);
> > diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> > index c401e3a1af06..1d6f8d958bd2 100644
> > --- a/drivers/cxl/cxlmem.h
> > +++ b/drivers/cxl/cxlmem.h
> > @@ -812,6 +812,31 @@ int cxl_set_timestamp(struct cxl_memdev_state *mds);
> >  int cxl_poison_state_init(struct cxl_memdev_state *mds);
> >  int cxl_mem_get_poison(struct cxl_memdev *cxlmd, u64 offset, u64 len,
> >  		       struct cxl_region *cxlr);
> > +
> > +/**
> > + * struct cxl_poison_snapshot - Aggregate Get Poison List result
> > + * @records: Copied Media Error Records from all mailbox responses
> > + * @nr_records: Number of valid records stored in @records
> > + * @capacity: Maximum number of records that @records can hold
> > + * @overflow_ts: Timestamp associated with a reported device overflow
> > + * @device_flags: Persistent device status observed during collection
> > + * @truncated: Host stopped before collecting all available records
> > + */
> > +struct cxl_poison_snapshot {
> > +	struct cxl_poison_record *records;
> 
> __counted_by_ptr() seems likely to apply here.
> 

Yes. I will use __counted_by_ptr(capacity), since capacity is allocated
size and nr_records only says how much of it is filled.

> > +	u32 nr_records;
> > +	u32 capacity;
> > +	u64 overflow_ts;
> 
> As above. I'd like to ensure this only stashes what we actually need.
>

Will drop, as above.


Thanks,
Shaikh Kamal

> > +	u8 device_flags;
> > +	bool truncated;
> > +};
> > +
> > +int cxl_poison_snapshot_init(struct cxl_memdev *cxlmd,
> > +			     struct cxl_poison_snapshot *snapshot);
> > +void cxl_poison_snapshot_destroy(struct cxl_poison_snapshot *snapshot);
> > +int cxl_mem_get_poison_snapshot(struct cxl_memdev *cxlmd, u64 offset, u64 len,
> > +				struct cxl_region *cxlr,
> > +				struct cxl_poison_snapshot *snapshot);
> >  int cxl_trigger_poison_list(struct cxl_memdev *cxlmd);
> >  int cxl_inject_poison(struct cxl_memdev *cxlmd, u64 dpa);
> >  int cxl_clear_poison(struct cxl_memdev *cxlmd, u64 dpa);
> 

