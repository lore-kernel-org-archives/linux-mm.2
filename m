Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 455CACCF2C1
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 22:21:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF5BC6B0088; Fri, 16 Oct 2026 18:21:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA5706B008A; Fri, 16 Oct 2026 18:21:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A73C16B008C; Fri, 16 Oct 2026 18:21:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 867426B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 18:21:15 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 299F81A018D
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 22:21:15 +0000 (UTC)
X-FDA: 85329911310.06.CD725C7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7AA14A0008
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 22:21:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YLutAh9h;
	spf=pass (imf15.hostedemail.com: domain of jic23@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jic23@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792189273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JbtA90jSYbvjWaAUht/ufzHaPdDcdPFD56WPRraPHlE=;
	b=e9HIRLXQBCNXcey0uATY/vIaulXsU54x982SmnAH1UkhBnupST4SW4flQSirYT3N2LAcNN
	GO4S6DB/dIDlAtmBBhjuWec3Za8OOrouMrtg21qNOxfAOnt5EZGlMiuW9P2tjaOl2jbWEc
	nLqOhlxDXC1dIMzWo7cByVFI7dMQ9GE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792189273;
	b=hGKBhcekOPlhOZPxfFu6ps4/tOWqOe3bGej1gMrCA21ArRbUKRz7gjgRg2Rb1peS7JyS8w
	zEimSDo5BtkVAGbJuny1oC8jNVxkxd+QBgOxvfBbHfd7NnGMMK1kTjihBfz9yMoSUFmdPe
	gxpLD9qntjCXGfsAgHuZIQtjbzsOr3o=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YLutAh9h;
	spf=pass (imf15.hostedemail.com: domain of jic23@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jic23@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B2C916022E;
	Fri, 16 Oct 2026 22:21:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0B971F000C6;
	Fri, 16 Oct 2026 22:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792189272;
	bh=JbtA90jSYbvjWaAUht/ufzHaPdDcdPFD56WPRraPHlE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=YLutAh9hSCOh6gtplRHRSIQlgjQ3k26KGbWzUG4uFVnvCToVBjgeiOCUZGpysnN5C
	 +w4WXEJTJ1BNR9Vr2u6wXhbiy6Oq9ama6WongS/4PHUrwyPRWFFH/FCirjbC1heIgK
	 /o7VsuTXuC5gSDJzRdKLq9PNqqWoa2LItHW0crT8mOIP4Y6WK/Nf34xKU73xB6UaJ+
	 SywUNWx1sOSxrE8zMfgbCuWlZ8bwzx8IVBp4ytcApMSBmLjMmY5uB4PaFMmtqv589h
	 J4ANggi93+r9PZAPBIIpK9dvAEjnoYbgNB1+3CPxyXsAbnX8+ksOHVZZLMVehAjeJ/
	 RVS/DaVoujrOQ==
Date: Fri, 16 Oct 2026 23:21:03 +0100
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
Subject: Re: [RFC PATCH 2/5] cxl/region: Factor decoder poison-list
 retrieval
Message-ID: <20261016232103.6497bbb2@jic23-hlaptop>
In-Reply-To: <20261010162017.62506-3-shaikhkamal2012@gmail.com>
References: <20261010162017.62506-1-shaikhkamal2012@gmail.com>
	<20261010162017.62506-3-shaikhkamal2012@gmail.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7AA14A0008
X-Stat-Signature: sjnchketgjmxsfgwm354hyskbhk45sq6
X-Rspamd-Server: rspam05
X-HE-Tag: 1792189273-849249
X-HE-Meta: U2FsdGVkX182/2+gL063kq2ApAc/gNNwHMP+m+Pym8X8L1QB+L19ZN9wPf7iyAXVt5/Cw6mo/d/9S/lbL9HqJvTeQx/g1HBgBE2srjS0wxD08h8cu0HClUXlaQJAaZLq1dC6UYtXQI+m3E0PpnoXLYUv2qMlf0/QAEHbOVN3PZRU3SfLsBnDa7ANFN6PiBfBq325Bp2/d+ZrA98hwbB6AY5w/QTFgU27jkV4vGLkUeui2xPx9PHZjrK8NVpYraIAs0r/S7Evn/DgU71qKendixTDXNp+odHVvAm1UI6f1Yje8kyFgE+CnpfyHt2NST/wgsTEPkkguNdgD2npz/lb8qFawGMcYdU/nCAMgQleeUoIx9oBbGCcXUO0ocSQrzH+UGqZAmwuARhVuoz79Pzw3wcGDjzHGwNTKQ3k/7clxtXJ5ZLa1IlXTSyd+CSJbmDvCzqKa9Z5oYrlqc1XsMEcONoSBagQ49sdMFGMT8O1dQpjt9JrbdBpsL2/GIulhzW9R0esIQ5Ug4M4iIp0rx47N/pw0fOSEJLkAorFUN8YC4e3ntG1thikGm/QQYeOiNt93UeWxfzriTwGCKBmZ5YlccUNqHTuc6RM6wFtMRroQ4RgzT6PJmrCqCSUHlPdNKi4AF0VRRp0cOEIkZ+KxYwHn+szqhkkw+mPcRyGpH/hZTtbdQ6Pbz2j67DkmR4+sApUru3HgncL4zsIKikLVL/HlZDsTlULwmVDP+dBSTkOaHsbR2hvg//K8YpjvJt3ubNQ873/zgbc1cEFwkQrHqZC3/hCCxwvzJGAfzyhhilbDtnRo182eGmHHYTxpwhA0lrwVA83HddFTHwZt/nCbGfbOygFm0TEbGeyEgM1xjr3y57iXEJN3jB5aA0w4IQk1lw7pPmBtpEKWz9iJyhhzHpMuaQAr2eAZOB91K/wRB79w3jCodvJB7ipyKv6C2215RkQj8NIt/F88GxDA/+hlgu
 NKAdIqMC
 uUZQny35GhzyPjt2w1AGrYtV3PcAIMdcxzo98Us6ECwbDi5Xj3u+fZKj8d9I/8P18uExxtGdhPZ0T+1VXPO7e2hSdI1kEhUsPb7u1/hVTYSxjzPZ8mfBvQ8RpnRJw7aqj22jSZLJZcFAMJQrD07wMVTKdAXTbiDzMQe0Glhli42mC1tizsFuhv2JIT1lpw0n2xCIsj/coTYtT2WZCuwL5dlXuLjzC1KIXxFA1e+14VfXx6U1U4zVDHOZjwdtqCYjz+d89Fxqpv6NRXgB+yyOVDYWORypLt+Ya9rmV971ruUFcnVyZVuZwEQHuSPs3cdK68NlC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 10 Oct 2026 21:50:10 +0530
Shaikh Kamaluddin <shaikhkamal2012@gmail.com> wrote:

> poison_by_decoder() performs two different operations: it queries an
> unmapped DPA gap preceding an endpoint decoder, then queries the DPA
> resource assigned to that decoder and its region.
> 
> Factor the second operation into cxl_get_poison_by_decoder(). Give the
> helper an optional snapshot so a later region-probe caller can retain
> records from exactly one mapped decoder. Keep the existing endpoint
> walk, skipped-DPA queries, partition-tail queries, -EFAULT handling, and
> trace behavior unchanged.
> 
> Signed-off-by: Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
> ---
>  drivers/cxl/core/region.c | 41 ++++++++++++++++++++++++++++++++++-----
>  1 file changed, 36 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index 75b8092e6dc2..c72524923b38 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -2940,6 +2940,40 @@ static int cxl_get_poison_unmapped(struct cxl_memdev *cxlmd,
>  	return rc;
>  }
>  
> +enum cxl_poison_query_policy {
> +	CXL_POISON_QUERY_DIAGNOSTIC,
> +	CXL_POISON_QUERY_PREONLINE,

For now, perhaps focus on flags defining what you want done, not when the
query is happening.

> +};
> +
> +static int cxl_get_poison_by_decoder(struct cxl_endpoint_decoder *cxled,
> +				     struct cxl_poison_snapshot *snapshot,
> +				     enum cxl_poison_query_policy policy)
> +{
> +	struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
> +	struct cxl_dev_state *cxlds = cxlmd->cxlds;
> +	enum cxl_partition_mode mode;
> +	u64 offset, length;
> +	int rc;
> +
> +	if (!cxled->dpa_res)
> +		return 0;
> +
> +	mode = cxlds->part[cxled->part].mode;
> +	offset = cxled->dpa_res->start;
> +	length = resource_size(cxled->dpa_res);
> +	if (snapshot)
> +		rc = cxl_mem_get_poison_snapshot(cxlmd, offset, length,
> +						 cxled->cxld.region, snapshot);
> +	else
> +		rc = cxl_mem_get_poison(cxlmd, offset, length,
> +					cxled->cxld.region);
> +
> +	if (rc == -EFAULT && mode == CXL_PARTMODE_RAM &&
> +	    policy == CXL_POISON_QUERY_DIAGNOSTIC)

This is becoming odd enough I'd add some comments saying why
we are eating the error return.

> +		rc = 0;
> +	return rc;
> +}
> +
>  static int poison_by_decoder(struct device *dev, void *arg)
>  {
>  	struct cxl_poison_context *ctx = arg;
> @@ -2971,11 +3005,8 @@ static int poison_by_decoder(struct device *dev, void *arg)
>  			return rc;
>  	}
>  
> -	offset = cxled->dpa_res->start;
> -	length = cxled->dpa_res->end - offset + 1;
> -	rc = cxl_mem_get_poison(cxlmd, offset, length, cxled->cxld.region);
> -	if (rc == -EFAULT && mode == CXL_PARTMODE_RAM)
> -		rc = 0;
> +	rc = cxl_get_poison_by_decoder(cxled, NULL,
> +				       CXL_POISON_QUERY_DIAGNOSTIC);
>  	if (rc)
>  		return rc;
>  


