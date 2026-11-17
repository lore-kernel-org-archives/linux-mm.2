Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C4F1606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 01:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EnFucXqi
Received: by kanga.kvack.org (Postfix)
	id 3C6926B05B0; Mon, 16 Nov 2026 20:03:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39DE86B05B1; Mon, 16 Nov 2026 20:03:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28D036B05B2; Mon, 16 Nov 2026 20:03:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D21046B05B0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:03:26 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A46581C32D1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 01:03:25 +0000 (UTC)
X-FDA: 85442812770.19.A313480
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	by imf17.hostedemail.com (Postfix) with ESMTP id CCC2B40009
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 01:03:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=EnFucXqi;
	spf=pass (imf17.hostedemail.com: domain of shaikhkamal2012@gmail.com designates 74.125.82.180 as permitted sender) smtp.mailfrom=shaikhkamal2012@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794877403;
	b=BwbNcTaKAKhs60e+Cb+zDGs/1HiP8IBSS07Xv2o1xcHtYTDjCWHwrXbS8Ik/nm7vEeiN33
	cde6KGTadmrxT/jNgLUV/EvMScCf0gIXj5fYM02u+rFidvtE8f/3ysB+7Z8rYLe7Lh7NGI
	JUcn4wOEyKsp+upl92//QtMe1fQHTiM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=EnFucXqi;
	spf=pass (imf17.hostedemail.com: domain of shaikhkamal2012@gmail.com designates 74.125.82.180 as permitted sender) smtp.mailfrom=shaikhkamal2012@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794877403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q8xRj1Homj/VTvTcbwqPDSEFGebgrQcuNK0zuIg1sPk=;
	b=F/sN64XSgch4U0yiHS0lWHxmO3LWEpWYNNuls5euEnxaQYfJZhp8R4sbxoJz2HI3059Q9h
	N/dc0DCHsF884WCVlgJiUTquc8/whAYf924VmT8T7Bo0QhfM99Z6aiMnejofEx67pm4XUy
	PenNkc1/a82AcOHkNXCOr2UjOm2FIPQ=
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-372bdb942dbso3675157eec.1
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:03:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794877402; x=1795482202; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Q8xRj1Homj/VTvTcbwqPDSEFGebgrQcuNK0zuIg1sPk=;
        b=EnFucXqicoJpAwvTRGeYRAIMzhfV88vX6TroNalbHVZ4EmGq0ks/c1Fmx/1nbNGjEZ
         wK2ebdgUVl+sIhwWO6C/yh9tgpaJZWYwNcaVvVJvO7z7d/IL9i9YoAbLPrDGVRQU1x58
         XE0wLxhmN+8fruoaxLlUVlmbOgLxUJRDl9tT7MivSbBDOKK3W5RhTa14oisozTWnMxSC
         61EcfzDRVKM7E1o5h7z0wdOKh0NrUMlWS/pS3+0Zy2XeWSUltMwtQRZrJCjqz/FQZJt/
         gkeM/7wTcRUgyfg9AxgqN8tOOG/Hs92SEGpfc0yDQvSzIqAnl3pePB7lgl5tzk4E2VJA
         MNVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794877402; x=1795482202;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Q8xRj1Homj/VTvTcbwqPDSEFGebgrQcuNK0zuIg1sPk=;
        b=q7DjS5d3Rw7zjaQ+R8huQfQtSkbWfy6ZRPYldS8Rz1s3pEFWWxaOR0lI13rUWtUPwF
         tmsObwBApMXXuLZBJckW4OgyPS11j00Fos6oYDNHFw/2Z5TsPWsP9vhS3ybz1ANiQff5
         VsNYUN+WZq992DvMKnBoI8IbQggYauAp70qbL+CagTYJXEbSKsG6ZOEHNq3rUDbF1VQY
         XGtQfNIaw0sl/uDSQTvADcuDAkljuJt3h9zfpq/oJg2D8rvSbogRiDlMhmDF/3Xd21aH
         tFsgviLImmy0HfIQIqYtgCRMT1L0MmI6ROXjsl8rj2qLpohSCT/kFJLycKLzUiStR1jD
         Ml9w==
X-Forwarded-Encrypted: i=1; AL+hErHShbyQKVRkbgsap5B5VpUN3Q1Wwb7ZOPxrCj/0nixlzWtS5SC2jd7qf7ectCV/R8YlaMNJ1QkteQ==@kvack.org
X-Gm-Message-State: APuU4Z+tXlgoe3zGe9fZqTD7rjq+3lulo4kJNCAn7Hif9GNxvS0nQthC
	/ivE68nK8ScExl/XD6jprCQEM2yGsgmCP8W6EGAzahNfIyKvhTsogPFM
X-Gm-Gg: AYBFou0sMh3ikEhCbIExi5/zumgiJsK5asifs1f9voje9aww1JUAIOEdJniseWCS/0x
	Hx45o0uFhRSU1uqznyTW5lqu04TawJlQybZoNLfooaTazVhQgO4gQ+7LlY7ZnXvrHMp00xVH4QY
	P0XuT9RooW9RIwMaKztdFOQ4xVjc0ak9Jez/1KF/KTVyez+ybguQWHxZJ7Argne9GxqCcbdzOv8
	dXD65qD7g0oEI+fjk7n2QIH9mwGXbdLyyqKT+/0brKDyqPfWztJWkMDvgXYF3JROH7w/bzRifDy
	q2Ywlbf+qvus9AMwYrKbopn6c5fBTIV+UZKZyCDfwbh9tCcwDtViw0BU9c1quELZRjkieGK0dia
	PP9qZHxo6qnDAWqqhlujVsMZ8KAKY4AOi0VCAcMVByUqM4XvX9WOY2uwiYe3X7d+lCPHnmMVmNc
	fk5kWMTMMuLVRCBI0toBR6oGfwfzx+IR7mbrifha88VviqkPenlm92s3BorCbhGstB8ojxArgXA
	flE0Nlv6j0UT5/VfrIWeW+s52r40Mqj6baMs0YMeO5dxprXY1cSO2kp4LrM3D41yrf/O7OKHMKa
	UiJi1w6ZybMg+F7uMZ/k5yEbAikRIeAF5A==
X-Received: by 2002:a05:7300:cc9c:b0:371:5cb0:4929 with SMTP id 5a478bee46e88-37967dd4c20mr11790852eec.25.1794877402316;
        Mon, 16 Nov 2026 17:03:22 -0800 (PST)
Received: from localhost ([115.99.200.166])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37955822d58sm37778195eec.10.2026.11.16.17.03.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 17:03:21 -0800 (PST)
Date: Tue, 17 Nov 2026 06:33:19 +0530
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
Subject: Re: [RFC PATCH 2/5] cxl/region: Factor decoder poison-list retrieval
Message-ID: <avun1x_x1UK2yWjL@acer-nitro-anv15-41>
References: <20261010162017.62506-1-shaikhkamal2012@gmail.com>
 <20261010162017.62506-3-shaikhkamal2012@gmail.com>
 <20261016232103.6497bbb2@jic23-hlaptop>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261016232103.6497bbb2@jic23-hlaptop>
X-Stat-Signature: 35398gok7dgyw3dcnhkgdx58schraop5
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CCC2B40009
X-HE-Tag: 1794877403-712377
X-HE-Meta: U2FsdGVkX19AcFXQ8zRcpeFY5iYzPhOQIlSlkwFpg/aOicwOl6ESiF885OWUINmzM2Vr/pQ7FOVAaFwSVjsfCbQgLFwdDpMVSXzBL0g+e0ESK2ErKYGsIOcWMwTA0QbtOQxHDw21cPa9gzFSFHasZ3lHInNerv2opzWw4dWUPM83DBn0WNdls+p1jLuWL5OlmIODiRoXss510SFT6+4CcPIt/jT9G6sqN4I/pnDODEmtSi5+2GgKOQ4B2YjS7CET5fxKoJcGuql8Le8PmUKsO3lT6HOyjfPGAhdhXGj9sfbRo8nwM6Mz+LDlddcW+S5QuGuFNGHAEqoGAXJJoe/ITMdrduX9Ogyqhsz4Ey2Pgdqsbc3NxGnxe1dhfGxPbfzyVZswdoicguSwcKH+BeWFDafGG0YWFMNTvgdXdmL+gM0K2Lv4suxuJqxudXxX24RMeijbjXDx2Zl6iL/4YddWV0M6cIIvoPSvpV3DxmGfcrhoJO8sEC32/bSvxFxkS+4tdSjBbwGU1m242VSguJDVQsW4zPgnsfhSxAHliXbjt6zt2ceb2EHbLPzBFolHUgVQtEqR8/zLoKZTTJxVTqE8A1IYVZCW2fVuTVU9fUU8Ad6oNy0GYWR1Hr1IRsZ3TBuPpxyORtIAm0LZDXev1eHTdMWOg1lBQl8ZV5SmKrX1nd9YflwOPINV4YUGpNXo7UfKxYkjQm+cvz5A2Td7xOBNIy0+aHVrNPIzKI0jrOTRV5zw7+9vydwlaII175iXnR4LfqfHzrN20Dn1U/gAVKFB6GpNw2TXMOiQvhFID41dwrALywIOglO5f5A9DLHR3s+I24qxg8jyS3gBokiBwmMo5j6YYUTNPq5kAMQ/+NNRjrnLZYi/p1R/IC6+42EsCzHTf/Go7o93jsvmz3rQaRP4DJfAy3zMVCkYKlA1o/5saZCpd0BKfP9W9UZJlHc5x291Dm+k6fSNrbFGcV51tan
 iCPTtKYD
 6J0fwq+E6EDXDTUxNsrZ5YBBq32a9OnsLVyde31D8760t4oTvNK3HdT3HwUtzLYR7osIAG1autN90yf28CfMcfijpyWjo1sU3p9doaTk03gnABO1EhS8eCKqBvnlyV/hl6F1jjoxQdJFisMmyQuDxE3wtToY5SoMe0EipAvgaAInZgIvv3q0lawiINO1+YYr18A/RCpKf2yayLGsWIB6sXF7yw+AJOx3Fo/3exfF6fgN6N8ES7uHgtWgvoWqUnumcWNZ5V+9SHOrInEZ2nNPWpg9DTNXcEJkksHbHk4pXJduntIHS+y+DxJYc8lYiwkx4BgrTCoFTmcFkOaAXdneyt5f6NIyGaWht9uRZ2sxCQ2V61YV1R4t80O/lv00tJcMKYLVypfWezB2OIcDw+E7G2cgCvXB3YtVP9QzJyvnu6rq6hFOHbQH58zz+w0cYHFjcOtZtNJWK9vHoDPyWz78sQEN74A8LkAx3vYryMfwsWDu+AExJ7MkFtnsHk0uPePB537UvimORQ/Wb6kiDXeX9hROH4NHqabmFGwCneJBUbVgjU/z76LhVDqe/4svUcmGTl5IIxYsK1AomrH4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 16, 2026 at 11:21:03PM +0100, Jonathan Cameron wrote:
> On Sat, 10 Oct 2026 21:50:10 +0530
> Shaikh Kamaluddin <shaikhkamal2012@gmail.com> wrote:
> 
> > poison_by_decoder() performs two different operations: it queries an
> > unmapped DPA gap preceding an endpoint decoder, then queries the DPA
> > resource assigned to that decoder and its region.
> > 
> > Factor the second operation into cxl_get_poison_by_decoder(). Give the
> > helper an optional snapshot so a later region-probe caller can retain
> > records from exactly one mapped decoder. Keep the existing endpoint
> > walk, skipped-DPA queries, partition-tail queries, -EFAULT handling, and
> > trace behavior unchanged.
> > 
> > Signed-off-by: Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
> > ---
> >  drivers/cxl/core/region.c | 41 ++++++++++++++++++++++++++++++++++-----
> >  1 file changed, 36 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> > index 75b8092e6dc2..c72524923b38 100644
> > --- a/drivers/cxl/core/region.c
> > +++ b/drivers/cxl/core/region.c
> > @@ -2940,6 +2940,40 @@ static int cxl_get_poison_unmapped(struct cxl_memdev *cxlmd,
> >  	return rc;
> >  }
> >

Hi Jonathan,

> > +enum cxl_poison_query_policy {
> > +	CXL_POISON_QUERY_DIAGNOSTIC,
> > +	CXL_POISON_QUERY_PREONLINE,
> 
> For now, perhaps focus on flags defining what you want done, not when the
> query is happening.
>

Make sense. I will drop the enum. The snapshot argument already tells
the helper what to do: NULL for trace path, a snapshot for region probe.
The helpler will return the error unchanged and each caller will handle
-EFAULT itself, as poison_by_decoder() does today.

> > +};
> > +
> > +static int cxl_get_poison_by_decoder(struct cxl_endpoint_decoder *cxled,
> > +				     struct cxl_poison_snapshot *snapshot,
> > +				     enum cxl_poison_query_policy policy)
> > +{
> > +	struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
> > +	struct cxl_dev_state *cxlds = cxlmd->cxlds;
> > +	enum cxl_partition_mode mode;
> > +	u64 offset, length;
> > +	int rc;
> > +
> > +	if (!cxled->dpa_res)
> > +		return 0;
> > +
> > +	mode = cxlds->part[cxled->part].mode;
> > +	offset = cxled->dpa_res->start;
> > +	length = resource_size(cxled->dpa_res);
> > +	if (snapshot)
> > +		rc = cxl_mem_get_poison_snapshot(cxlmd, offset, length,
> > +						 cxled->cxld.region, snapshot);
> > +	else
> > +		rc = cxl_mem_get_poison(cxlmd, offset, length,
> > +					cxled->cxld.region);
> > +
> > +	if (rc == -EFAULT && mode == CXL_PARTMODE_RAM &&
> > +	    policy == CXL_POISON_QUERY_DIAGNOSTIC)
> 
> This is becoming odd enough I'd add some comments saying why
> we are eating the error return.
> 

Will add one. A device that keeps no poison list for volatile ranges
returns Invalid Physical address for them (CXL r3.2 8.2.9.8.4.1) which
comes back as -EFAULT. The trace path treats that as "no records"
instead of failing the whole walk.

> > +		rc = 0;
> > +	return rc;
> > +}
> > +
> >  static int poison_by_decoder(struct device *dev, void *arg)
> >  {
> >  	struct cxl_poison_context *ctx = arg;
> > @@ -2971,11 +3005,8 @@ static int poison_by_decoder(struct device *dev, void *arg)
> >  			return rc;
> >  	}
> >  
> > -	offset = cxled->dpa_res->start;
> > -	length = cxled->dpa_res->end - offset + 1;
> > -	rc = cxl_mem_get_poison(cxlmd, offset, length, cxled->cxld.region);
> > -	if (rc == -EFAULT && mode == CXL_PARTMODE_RAM)
> > -		rc = 0;
> > +	rc = cxl_get_poison_by_decoder(cxled, NULL,
> > +				       CXL_POISON_QUERY_DIAGNOSTIC);
> >  	if (rc)
> >  		return rc;
> >  
> 

