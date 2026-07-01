Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7835C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 07:03:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88DA76B00A9; Wed,  1 Jul 2026 03:03:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 817FB6B00AB; Wed,  1 Jul 2026 03:03:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 708E56B00AC; Wed,  1 Jul 2026 03:03:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4B0006B00A9
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 03:03:12 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A80C612028C
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:03:11 +0000 (UTC)
X-FDA: 84939316182.14.7496D89
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf23.hostedemail.com (Postfix) with ESMTP id BA2FE140012
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:03:09 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=V2ubgqNn;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf23.hostedemail.com: domain of hare@suse.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=hare@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782889389;
	b=BA/RcTFjJ8U40WqG2CzkEQdXjKPEOxI5R653qAnBnH+jkreAlbtANTD9Dl5JFEtx8tcQ3K
	LwKUwaZ7PsY58BGjaCSnD+zF0iYzQeS7HczgdtoiCR5C6X+DQwb2I4MONJtmy6nQCQV/rk
	4BynUh6wlCfoaO9coi73CEkgfYz+dG4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782889389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BEOzJcjGcAIJl3Tht4vVazVfDVw0cfWuXCgpWa0S2Ng=;
	b=06YLzD7m7QWXR8khtVUeHQsiwKJZ8qFk/o8MyHE+R1rdZWXPmE9XLBCqmfW9+m2igGD8V8
	stU/U1wvFIJ9Dcacj1511cZGMiiLC4oGuY92q7f0WU0I8vsusSXd8yqdeIhmvKLz1W4Pv6
	8Hwrjs9YjawraBuWerhwlhFNbU84yrw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=V2ubgqNn;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf23.hostedemail.com: domain of hare@suse.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=hare@suse.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-493bb510ce4so1830525e9.1
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 00:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782889388; x=1783494188; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BEOzJcjGcAIJl3Tht4vVazVfDVw0cfWuXCgpWa0S2Ng=;
        b=V2ubgqNnB93b8MJmn3DquysJqWuS6CWgwSTXwEBfh5m4w7rreAipvyYhSDe+DfKq6Y
         iGuM4i8nciHr1pnPOKMDhCURvfVmPbGyVdmxYEQJvGLtlnnXVBS6q9uJaqQZvM4oBQXD
         nAPALKqK0ADqjZxJJYDDUKZ4z1vpPYUgDBbMzjbBzQUY0pm3jlFpEMwAsd0eYACaZuGV
         SOlkm/9SXjUxBVrxPc4Nq6PVitQ6KfxjDxJU8YPFi6gbFZoqB4bQgEnTgnj5TwwIblDV
         Lo+SfPj06x6vZIjNi04CRKnIhqc0PIRGKUiUovuUcBhgrlq9ceBhtrZbrLIhPAWQLorz
         QZrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782889388; x=1783494188;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BEOzJcjGcAIJl3Tht4vVazVfDVw0cfWuXCgpWa0S2Ng=;
        b=I7FjGW+nMVZ1aVDk4xq8df2oYwPzU6pcgR4wXpg8F7bBxwrUak09RVmzpqcDS/P/hJ
         Ymz3vefL5sNohGwSdLkSnCrl77mR3G3lAnE+hsjYOP93/R3Gh/P9Zre5AHHGtbN9O5aJ
         Fzp8FIeFidt+oqtHkgPi9PGf0Sgkp91Oqy9rljmG2aZHCur0w6ePfnyGRQ/Xje86s35q
         v81T0DA7PrxdenjAETVmn3/F3Zt46Mm3lfaiBYSgyB0UUxb+VjwHO2NEhmmXkCVJUHqv
         7IbIRhls6d+psvXZhfUN8D9MP0s1g97bEGFnFNKZgz98hnvTM02QEEISAXf6beXM9BKt
         RVUQ==
X-Forwarded-Encrypted: i=1; AFNElJ9BabpSXbpdVspHCI2xiXVRKaBYyBFCttLE1q3AeencIKYzr2XN8vvdSCX2JDc+Hrj0tYDSOMxPrw==@kvack.org
X-Gm-Message-State: AOJu0YzkB5gPrHCT72mUWt0lxck849zFawTRnGaprl8prnxy3FGZw2+P
	cXI5zpYL0viEJFXkoh3PTDpCJC2zGQHprzESiivuLjpSYMWdNgF15ol6+QsrIlALGQ0=
X-Gm-Gg: AfdE7cmEZOL9V3rGPWMDSVpScz2vI5PX8Dqbwczsxe+wYGMN8taQqOop8Y3/OcQ1US4
	ULXLmZEJ+9ggEOxBjQ+p0F1mo1fQ4AQ7xOC118ahWlyxl8UJ8nptztjrYHIQRJ/CTPw8OpLDMjY
	H8s5CvCdGOToQKOOXYTdNdXyrCpxFyPuRcpromcAjWwCjvMCYUgA07OsGXnO2/3a0NsWpZa2YIJ
	8DVHKsN5pHDiJHghz+OHBlLvTNiKBtssIp/lZpmkTq5APVQ8XH3aP83CnS6KpAcjmarm7TzkePT
	Oini54/8i6Ju8lWZ5KU/Xx18oeZ7ZVH6lzSlrC6JUt7/SqHbHL9RGi8jGe84Wpr+Jlvs+1S/9DS
	WzK5eO2pKKc/bSLZk7C8dbpZW3nQRuLaIjdX8ruZTR1hheTy1az4LqpAzU98hfWfrVnGy4bAi2I
	ogYu36pC0DNPU0iA/GOT4O86GIhNvJinpj8yy/Od5fDQpCNlw=
X-Received: by 2002:a05:600c:3501:b0:490:d079:2919 with SMTP id 5b1f17b1804b1-493c2b4ce3cmr5715935e9.14.1782889388047;
        Wed, 01 Jul 2026 00:03:08 -0700 (PDT)
Received: from ?IPV6:2001:a62:1403:d01:fcc2:cfc6:9af3:a0c1? ([2001:a62:1403:d01:fcc2:cfc6:9af3:a0c1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4756636cf98sm10981027f8f.22.2026.07.01.00.03.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jul 2026 00:03:07 -0700 (PDT)
Message-ID: <7c8f0e70-f49c-4614-af95-002fb2be11ba@suse.com>
Date: Wed, 1 Jul 2026 09:03:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] scsi: ipr: use kmalloc() to allocate IPR dump buffer
 memory
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Brian King <brking@us.ibm.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20260630-b4-scsi-v1-0-494fb37ebe7b@kernel.org>
 <20260630-b4-scsi-v1-3-494fb37ebe7b@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260630-b4-scsi-v1-3-494fb37ebe7b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BA2FE140012
X-Stat-Signature: gujqwex7mm5wwytekm9hxaqakqgwa6c4
X-HE-Tag: 1782889389-436669
X-HE-Meta: U2FsdGVkX18XlxpaWoBBA3qocAko95OwIfoVJeRiDC0kK31LSHGqNeu9bxhiYLdnkqejxuKSRfAFulSwo/gzxrnk8MyqZ6Jfi7NUmEFbcXwV8l7Lm22lY6O6LehYDwWpFfZX5LuxMkma8ZT7fQIfDXILt0+CXbJ+2K6g633Wa2z4vzRNOo7eBPEjITozcfNLafoDXyKi5UIvHBtw47HaygfmEN56nzVPkVs5+eFDpnoOPnFWH5ZYt6PrxDUt8XSITQCXL69u1U4shKE1zEb5SIZqRamm9ncCsyGOKOpPYHpB5wZoc5xF1eys0ylVnyYpPpQ+223+ufN1tycnvEicG+tv4PW3A/5+jabvO7bmkVNNNxK3fePP2GZV4/6UYL++QhGlpHjSQmqs67+Wh4ewXglAEi5Ai44OYkRzRiMItAKTcd3VlpVuRzEZ+jco5YmZO4x6+DboI8wk8Gmbf9kBdi765jh+BCzIuD8BhhsJdGXI5ocexH8IlWPYNs7CFD/HpXvxIUsTpyOdkVAHxWKD5wV1g+0VWbjHVmTksljSrX0+jmL7pljQlIqxTDLw5ikFReKhUmLtyUc2EHakGV85a3avnjN5L9/QP5nK5Q1M83Vk7q1f09lrNO7J0DT4CrCvPm3faDZL5fT0kKWdDkvOYhfzjoyj/Y/JQkd6zirgpbwpp98Ncsyykz6i1i/yLoRtPB8cVoy7lXqPywnzEWGBti8yhru8pJNgdgq8nRUpNSoFj6RQJPj1vbjR07m65XNvg+Hh+sejwJ9cW1BmTkU6UCdeAVCXuJUPFilySLFdKCPjD/4tol3TeUTSUk11nloM8jRP7USGK/ARny3K32bar9/mZIHlsz/GQvCI2ae1+M3cNTrU3hfrLNCK0Mm1H80nEh1QpZpFXtBFqWNJVbcKpawzvbnP41ft2dvrTYv7sfscrNGt6fwPG+HnIyjGKmbE9MVxNpDc5UIC0kzpCoD
 wTZlwdUP
 P9R0AjAN4du6Q2pEjtC1YwwHyRJn+mVtAjSfXM423d1MK+53vZllW9K2h9Rs524cULo+3hIbRDhRRC1uutlJ1Dqx0w8Cn9GNyACn9KgSnodsP4mHGknvKWe3ZkZZh01thNVS4/yBj2gc9y1VUWe5PEpiU2NWjten8iIZUD70hMfO0NiRZa3ewBxJqNWPG8Qg6S0cRwItfLoPZtz5IY4w8kMR/X0/TfiriIIhJnfRbWemiEUVUryKbJlDi865kewdOSyQmJ/I/fFIX5Vr779xRO6vjh/tbuvKBvuZN51/c0YDNwzzB47zWlHcUIVLH+6KAh5cuSVyPI76iPawrE7+F03PmPObjivKhZqT21GvbjLTwS2YPKSh0PCjYLunLx+vniiQqV9trHP8bKux8GdB+FJYD13XcNO88rPMjmtZ3VNGJqA89zZ4RQTlx3uAhkpF7MmGta85zX/lZrwo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/30/26 12:54 PM, Mike Rapoport (Microsoft) wrote:
> IPR dump machinery allocates memory to save adapter's crash dump using
> __get_free_page().
> 
> This memory can be allocated with kmalloc() as there's nothing special
> about it to go directly to the page allocator.
> 
> kmalloc() provides a better API that does not require ugly casts and
> kfree() does not need to know the size of the freed object.
> 
> Replace use of __get_free_page() with kmalloc().
> 
> Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>   drivers/scsi/ipr.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
> index d207e5e81afe..5a212bfdeec2 100644
> --- a/drivers/scsi/ipr.c
> +++ b/drivers/scsi/ipr.c
> @@ -2893,7 +2893,7 @@ static int ipr_sdt_copy(struct ipr_ioa_cfg *ioa_cfg,
>   	       (ioa_dump->hdr.len + bytes_copied) < max_dump_size) {
>   		if (ioa_dump->page_offset >= PAGE_SIZE ||
>   		    ioa_dump->page_offset == 0) {
> -			page = (__be32 *)__get_free_page(GFP_ATOMIC);
> +			page = kmalloc(PAGE_SIZE, GFP_ATOMIC);
>   
>   			if (!page) {
>   				ipr_trace;
> @@ -3226,7 +3226,7 @@ static void ipr_release_dump(struct kref *kref)
>   	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
>   
>   	for (i = 0; i < dump->ioa_dump.next_page_index; i++)
> -		free_page((unsigned long) dump->ioa_dump.ioa_data[i]);
> +		kfree(dump->ioa_dump.ioa_data[i]);
>   
>   	vfree(dump->ioa_dump.ioa_data);
>   	kfree(dump);
> 
I _think_ we can replace this with kvmalloc, and allocate the entire
dump buffer in one go. Once switched to kmalloc() it's kinda pointless
to allocate separate page-sized buffers here.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

