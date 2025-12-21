Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1309E66886
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 11:33:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E09BA6B00CA; Sun, 21 Dec 2025 06:33:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB7816B00CB; Sun, 21 Dec 2025 06:33:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C98F06B00CC; Sun, 21 Dec 2025 06:33:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B60BE6B00CA
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 06:33:32 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5155AC0B2E
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 11:33:32 +0000 (UTC)
X-FDA: 84243267864.06.F3CCE2C
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8FC5318000C
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 11:33:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=oc5w5WSm;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766316810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XyEXnFxRw/dZFmCj4O9vgIzqRZfYupF5soIXzghWWeI=;
	b=SIHfq8mUKwUWGX2FHNxUKj+mZqlD4BqJrfPfPN9Zb02mL7CSCD2qdylIDnE+Fo3hrHW2QW
	HLf4myItE6ADwhQQhtva7Xwe98R16oBxlNtY64jcv3hhIpP9rNa9/wYBosYO3LM2W6hLTj
	5r3t5nRAXNPkMq6L19k6l/uIEnuDt40=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=oc5w5WSm;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766316810; a=rsa-sha256;
	cv=none;
	b=VPtSyPQXu5p0xrZt+tI89Ruiy81l5fnieVGYYyhDDuWIee2ymfvcrN6c1Vk1TkqmED6mZ/
	QwzcdJqgQ/GhUrXlXoH81tPIgGEJyjKNgqd02PVDbu9zvHwGp5+N8vHfJfqaw2AAHyEJF6
	auRN8xme95LjAhlUsBDowJOTwJeQI64=
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-8b2ec756de0so317742385a.3
        for <linux-mm@kvack.org>; Sun, 21 Dec 2025 03:33:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1766316809; x=1766921609; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XyEXnFxRw/dZFmCj4O9vgIzqRZfYupF5soIXzghWWeI=;
        b=oc5w5WSmUuyiSydJzZhQUQQEVi+LhZs9zLVpS4d1BoXsiRBp5UDYzcAssda/Z6SgK6
         Hc9hFl6DhrwjdE6yW3i+Uea4CCXDjlJWKjVdBpX+CfZTSXBz7jKglW/Opp2OwGpUKHsS
         gIJXpn6uAJR7Z9BhkqpXqqKUpnTOYXgsX3UEqonCyxJnb7Psn+ItrL5LISJDiXENl1RO
         NE809uo1e7gabcaWXdgILVLMe1A+fAfvgakWpW8AQmQgPrvAAzWZ+5ewgNPc+mOU3N7P
         tzURIyel5eUg6wNV4mLPauWeFY6WSumYROoiQ0uhrtNUTcSJLfMGuoXrLeJAS9Zos/TE
         MDnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766316809; x=1766921609;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XyEXnFxRw/dZFmCj4O9vgIzqRZfYupF5soIXzghWWeI=;
        b=D9MI13hOMn0ddhT9BQ1Dm6K2dmPmWzoljtXr78wKIQsWaq6QwO6WlKTk+fF+TQFv2e
         +ltqDQdzOZ0vNaiabB2Hk7HjBIRDmOJuO/G9eSlCQLT8P3fzuLa8t9Y7ksNzDy+nmckK
         fO5myGg5iAUoJfT876Wdeou/ZE3dyXAO0ZCXGI566eicb2fdOVVmf4EjSP+9zNo5zA4S
         S4bCt4uINKZZViQ1nDAZNNlrEZRI51FA8RISHLX9JDRCLNBAN5SgIQNaKfUexZX99DpA
         JrP4bbe504w9BdWgtXPFqpBFbdK8+JspxZ+CNLOxNVyEqGptkH/POTW3BMo2QWeQI5rU
         NKqQ==
X-Forwarded-Encrypted: i=1; AJvYcCW98WN/T0OkSzode2qAmhsGuUmZitKqmdd9xLmKJKRuQAz2sqqsUuNA8M7/dLB+kE/nA0/sj284lg==@kvack.org
X-Gm-Message-State: AOJu0Yzij6AI4W7o5sqk6kTr6MDwx9rQQ/MwuS3hsoDdOpA3o+V6QiQb
	jBpbUKcgBNv4d4qV5bDWD/vO+lIEeC1F0WVLv9gGm7HVyB4DDPmOtUpdIMg9PZlDOfP+R7qtl8y
	3Q65M
X-Gm-Gg: AY/fxX4g5I2yFIChhI0Yic/KIANIcs2h2cqlya0//VCNXVU+nI84HUhUL+hqrWtZD5x
	XgyeaWv71BbjHU2KLxIbl/KJ7HS0Q9xEbwwIIyvXZNUmr6Jc8E1UE1lDjCZK0kZSR8UUybJjnWh
	R3sfewAeplh7ysADYZCsa25h4BooxXZqBxnDXxj1OT9L4rdEH5GZt7JcbVo0upsx0HDWRTF4e+x
	3ksHFVGcXZhdip9yUzWHfJta34P7vKBCughHJJcSnX838KTtjzU8RfwNYg5CNkf0XeZIzTJX1/Z
	FPfxLqeckdCCBLmc/M4jET4upyVwykxZbHPI6Nbc8h9EE7FhiRNaEJJ6FErjFKd6UFDAKqj1Fj4
	FzXZbwU5zk9QliAI4l7AcvRTo2VxtLoD+WnuoDQyg0tbRbBk+WmeDUs94tbh27k8HBXHvCQ5GFw
	fyU93yo/CmNE2CMWxSzsSorHkt8AA9BtX4S9TvLq1WvIq7C9rRavx/roL5UPIWLQOP2MrqepmYu
	QEdDIhk
X-Google-Smtp-Source: AGHT+IHT7Xo7GrC0Uq2wqzAnpXZFuCOsTHfYSBi2I8ALDpJvOe9OgaMpw+NRwqAObVPAQlJ6Ynm9Pg==
X-Received: by 2002:a05:620a:4620:b0:82c:556:eaee with SMTP id af79cd13be357-8c08fab3ff6mr1314482185a.66.1766316809535;
        Sun, 21 Dec 2025 03:33:29 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c0973ef6bbsm607633385a.43.2025.12.21.03.33.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Dec 2025 03:33:29 -0800 (PST)
Date: Sun, 21 Dec 2025 06:32:52 -0500
From: Gregory Price <gourry@gourry.net>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
	osalvador@suse.de, rientjes@google.com, david@redhat.com,
	joshua.hahnjy@gmail.com, fvdl@google.com
Subject: Re: [PATCH v6] page_alloc: allow migration of smaller hugepages
 during contig_alloc
Message-ID: <aUfa5B_DnPP2C6pO@gourry-fedora-PF4VCD3F>
References: <20251218233804.1395835-1-gourry@gourry.net>
 <20251219000800.tnpqzvcdyeqcwryt@master>
 <aUVgoEiaXj94IBmW@gourry-fedora-PF4VCD3F>
 <7EED2D83-AE17-49CB-BDB6-954793EAFDBF@nvidia.com>
 <20251220063738.hbypivj3d34c7ffs@master>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251220063738.hbypivj3d34c7ffs@master>
X-Stat-Signature: iux7on65ra9yojm9s1776exor9a78rg4
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8FC5318000C
X-HE-Tag: 1766316810-293041
X-HE-Meta: U2FsdGVkX1+jcsBVmWZmMPLZogtA2SSaen9dl3yb5fuiahysGTgp8oFxJdqzNp9RRvmpQtGW6Er4WFGD3WdMhHvwAKmP9OmxGPIQtoIKuV4wXpnyrXL8MxA/cJlAoC2BzXoYZyiWeTs9yB5YwZb7fI89Nsj9ZklkYKyLz2fzMweXUgcXjxbQ9GXw2R3MPKyqReZ/GwuTB6rzoJESN1KKp7WUeAg5YpH5e5ycnOOSrUxSnhRNhzvYwHW9YYIOXTZvrTfQsxghLL9ukublGicwMCfwpJ2ewBaTZ5IqCwPuNzjdiOiDVuqnMp2MoBvBGdr/RDSLxUu5mONglwPUTy6zUQbNmKKqkhEIPQD9tS43aEqBjH6Qg9I7BL4JgX6MU9py7YT4KEXkFypI/cTUDtNhMEaGvq9p2P3Cs8mA0QDilVPFiwv8Woli6RQnoXCcbZcN1MD5+hG9kdWVN9Z0EFz8YsXaVQcyDCQ1+6D2dswEPB4WEo610iLRYhsOJXjf2Q21slEsXm2xKd7Jc2vSBD5iHWw/G6/3WWCNGgqYPsvYvpsDc4FjvlQGoxw0QlKGEp8jdyWBWcktNOApKEMh4rd1rY5buqQhu9hPmMN9oSgwP4vmmotefxRkKD0uH5GPynYjGGqvf+RrRIeTcqUx0mPAO08bNWDJiTa2/qrqGlKn/iL94dJnZOa/VtZ7Ox2YUFyr5cxRSe6bDJUYT/CL6qu8HSnWLNRmubySBU9DGELIAHnvxzbDHcQAMcka0eUBvjr0l5S00Fr374rl0BVTpImZKgucyQiuwYcr7nKJkXp6J+T8KSlzVw/9nbEMw3pzGiFIZjhaVHkVey0Hinw1HBSNa+p2yTX6WqoKQr/yXPxBx1mOCfhdwSK8i9lyA/iKUy9HvGBHBswB0S55dcOi8iGZt8PuA1GJVe0vXdB4BclkGFLevlc45trz4qnQuM17MUIrjGxQvNYO0/4cAjIK/nq
 1llmWlEI
 4cP45J8G+HuOqqrRkPWTskBl3USePpx3eJ0vJ4Y+ThSWc4jbmt7Tz2sc9PEjEUf0riLOJoXLdfjYhd1lU+8zIBSFWNLq+nkgeiOIUZTxm6P7MTND4OHlJXmWZk7H8EntU9A0KSZDis3Deil2LdTZsGAeg3g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Dec 20, 2025 at 06:37:38AM +0000, Wei Yang wrote:
> On Fri, Dec 19, 2025 at 03:46:25PM -0500, Zi Yan wrote:
> >
> >The sole caller of pfn_range_valid_contig(), alloc_contig_pages_noprof(),
> >scans from the beginning of a zone to the end. pfn_range_valid_contig()
> >should see head pages all the time, except it scans in the middle of
> >a 1GB hugetlb when alloc_contig_pages_noprof() is asking for a smaller
> >nr_pages, like 2MB. But in that case, the if above i += (1 << order) - 1
> >would return false without reaching it. Basically, to get to
> >i += ..., pfn_range_valid_contig() needs to search for nr_pages larger
> >than PageHuge(page) and nr_pages is always power of two based on
> >alloc_contig_pages_noprof() requirement, but that means
> >pfn_range_valid_contig() always sees such PageHuge pages as a whole
> >within nr_pages range, thus cannot see a tail PageHuge page at the
> >point of i += ....
> >
> 
> Thanks, I think you are right. For current use case, it is safe.
> 
> But I am not sure others could get it on first sight. For example, me :-)
> Do you think it would be helpful to add some comment here?
>

Can't hurt, i'll give this a v7 and collect the tags, thanks!

> Generally LGTM.
> 
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> 
> >Best Regards,
> >Yan, Zi
> 
> -- 
> Wei Yang
> Help you, Help me

