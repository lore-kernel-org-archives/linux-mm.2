Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7525CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 08:13:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 214A88E000B; Tue,  2 Sep 2025 04:13:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EBDF8E0006; Tue,  2 Sep 2025 04:13:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1297D8E000B; Tue,  2 Sep 2025 04:13:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F01008E0006
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 04:13:46 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C20D2864A0
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:13:46 +0000 (UTC)
X-FDA: 83843596452.09.EC3EACF
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf04.hostedemail.com (Postfix) with ESMTP id C422B40003
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:13:44 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Jy7CQCDj;
	spf=pass (imf04.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756800824;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9023zF9YjRSOsUPLytfDAvNSQZrPyUAwlY34V1EiUsE=;
	b=mLXsjorSyYdbWeinpkNBA9IbSKePN5absllckH/opp7CV3n2peNt0NxIcxKhROCsjg2nOP
	vEDbwC9pl2w4/yVD7aU9no+vsyfRthwQtltM1bLWzTXJUWZVqMiPLK8aMs+sF3tz2PtAwb
	zkgjizmgeTdA2gyzcYx+9atEsbED6oI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Jy7CQCDj;
	spf=pass (imf04.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756800824; a=rsa-sha256;
	cv=none;
	b=Zn7HBHoGEIXcRV2faYj3uYm+XC2Ix0dVUEjbIvzrEAku5x0ufQhhnesCFxLbkoT/ZiWSJp
	rPhSxD71xoFWjwWUR/CJgPZMeCnRzyuCKs3PL0faFhu3zmcG9nXEpYg8Q6I7lK0B7i1Kxy
	ILMxm2t9FM1Q8lOpNPBPiVB7KRWAIxE=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b042cc3954fso269846466b.0
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 01:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756800823; x=1757405623; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9023zF9YjRSOsUPLytfDAvNSQZrPyUAwlY34V1EiUsE=;
        b=Jy7CQCDjksnlIharOkxdOp7ztC9gKTvYlm6bU4XqV3WmNbo9MEV/mC4inde53JHfdp
         l8m7But6N+qaDlQWprGPHUy2FE6kzQw9M9viDsew8zEAedEaQAnoaiKV7hi1LgjQU1q6
         PmE67kq4CR0JquHqPRyL/qGUvnIBfQwRjV5MC8U9Q/zYROZ/He4tny2jg7rE8bKHVwhd
         KwYKqNYRD/A4wMKpOaMP9uxQpsm8pgqzpRSKtW43EBsj0N0CPVw5p81VyeC/QVRq7EsI
         JUJ1IUDGHSQCMNhQVZDW+ZSkzoUU+mnajC9DbKF5GD47Esypj4ekh51b2rbDdx+A4OTK
         p/wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756800823; x=1757405623;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9023zF9YjRSOsUPLytfDAvNSQZrPyUAwlY34V1EiUsE=;
        b=eZ0i1ClfJSVPl2xQK+tRBtFwBFV2nIq9ChDnZ3bEjD/mmyUg7XsoM8VLYrUGwsUmkV
         bFdHx+JJiviHenWC0VcKGLPDQRMWdn4vHiCzksUu5JR1ZQF0HhKEdgH9E89SGSGNsldU
         AYEKV71dYM2tt4vyS9yptORR1x6+Tev/RQzlWNdL4B93tRFI9YnnQjMfik2nFWWweRF2
         1iVWxex5oE5XFuFa93/c2u6gTtQb5mEaTPnz6pFqt1pdJ60ZdVlDUWtJr6dPIiC4DsqX
         Ubeb5rOOrsB15LNoArkzmPnX0vDV2Qnz+g9AmpGViMAFiSdPnS3v1S3F4YVOPdUf8iGq
         lZUQ==
X-Forwarded-Encrypted: i=1; AJvYcCWpSQXFCkzs+FUJS52vgaAgijEO2rE+CkoW91HVxtR51mFxr1mBvOnYtCYtQf4ptymO5BdddJsrOg==@kvack.org
X-Gm-Message-State: AOJu0YwzpJ3wk9W135kjuSDALrr6DXvE43xssJIhTp0vBV31ycbv/7eT
	O+9G0KdANbUiP3wjj3kL4mRr5GMncEp1YJU6JRybBMAr1cQhbBIBoinW
X-Gm-Gg: ASbGncufF2jZSBppwPtrRHTOxd4Q0uC+qbIevKPoXfuYauUOv3KAEBSgPf2cgZT21Sj
	eWOb4kVYeOJrWLAs3xycJA8YXTtlaJo6e2brFDp4KdPp9DEBVENJuiduQPE8fXwBRvDhEsLyZcx
	eBzNxsA20C9HZus4BPemRSgn9INRMYehSextDagEutYU4nc1kBU578XSDmHtBT+MrNOlynE8qTA
	xi2xIzFNTXvAC5aHXyKk7vuseybQV6AmA9BDGFlznquRbQxt9e8zhJhfiRACdmcRqIxQ2uE4Hjr
	fG9sP0C/3yyVvl2OV6FIrjT3tjfGHVEPo0cirwAHaFEMCKx5L9a/T45YGimpVP3G86uALxuAppo
	6hykygrHeLrFf6kIDmaz+z6mpkMswfwU8L/Jn
X-Google-Smtp-Source: AGHT+IHOLANPIOlqUUqaEwu94jaJxxWod+bsV1Xs0JCF3RYuGTmiVCDK4bHjkTjaBPdFyrtpJB6Q0w==
X-Received: by 2002:a17:907:5ca:b0:afe:e4d2:6d7f with SMTP id a640c23a62f3a-b01f1a0e59emr875555066b.60.1756800822806;
        Tue, 02 Sep 2025 01:13:42 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aff032125e2sm1021634766b.77.2025.09.02.01.13.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 02 Sep 2025 01:13:42 -0700 (PDT)
Date: Tue, 2 Sep 2025 08:13:42 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, Zi Yan <ziy@nvidia.com>,
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
	baolin.wang@linux.alibaba.com, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [Patch v2] selftests/mm: check content to see whether mremap
 corrupt data
Message-ID: <20250902081342.rthx5sopowmg4hyb@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250831022701.2595-1-richard.weiyang@gmail.com>
 <f8e942de-1a50-412e-9020-1bc901b4243b@redhat.com>
 <61E58B7C-23D0-49FE-8D0C-CE0B672114E2@nvidia.com>
 <0a0b0018-9427-4201-bf53-6aeb251bc482@redhat.com>
 <1D88E773-C11E-4F28-A13A-1A681898198B@nvidia.com>
 <5a796574-0a3c-4040-b0bc-3ff757402759@redhat.com>
 <20250902025112.d2n3o4imeptppctd@master>
 <dd30710a-a210-44dc-93f9-1e7ddf096251@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd30710a-a210-44dc-93f9-1e7ddf096251@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C422B40003
X-Stat-Signature: wptzhd4naokgs1ooqermo8hukncgau3f
X-Rspam-User: 
X-HE-Tag: 1756800824-165000
X-HE-Meta: U2FsdGVkX182Hxl+dF6TUHPHy79K3BsPnDFhVvJje+B73HVseCOWRDA9zZecnNObWJWR1NTPwA5tgHaz68BY0LkJqxIggkuAOMT3HgaumuBWzpHdUYgOBrVnOlwXhqS0k+O+uaqpB6kqvYiG4S/ZpeuinFnfEWazI+5ylYdy/fB2H9l1DD4eNDzuaNJKkMUtsKxK6LYpciIL6jOyO6oNO/4leTTkiMbjLHMioTbkAlyLx1RbQSquCaH79VlIbZBxOnHFoS50FVgJry7He6tZIZ2DFEjLhs+aixunU0kDgh2HU1JmKMzT3xBHNRFkY5KbQiMxRTJ6fIr8nyWNtS7htay6qrexRHMrF4Ktrb6LIlebO9WxIX1iqLIAD/3+tz9xh8y3OLll74bl/fqXDq+0zVrC3EyNtCIJID914ZzU7boGrGq6xTGunp3YlfONdnKjaV1z7ydo1OWHCEkwKxq7h3dp4hlKVBUMKZ8vfy8IY/GoxYsdlgvAdiOuMs7R0aEXvaCIHkKDugfn51FkGyx5V3C1DBXk68XUeiuEp26lPAdYXMf0S0uHtnTG/Ase4oL02c3hzoRqA/nzyMMmop3cw4cIRCxWR1AGhDHTScRxpoV5UQK0lmbL+EgVtpGu9EJwdT6oVFNa1FaEvToxYzPbi+MzAiMqfaYdjUzwbTKqD0c4Krk86Ccm4PuF/G6XfOhw0JJtr1xt3aA2RhC9LKs9pQ9BZSQvr/Indwk7yiVUEXvYmx0CUGRtp7w2MySblD8NrCvQMJrdo62ZcaQIp3L8tJPB6U0DCqXCCj6SG2Vlph+YvZNxUuwbdFwCDMUlxMpcbxa6S4KIXh6GARCQ5vUwxVtZhEdDRy+S7SM7Sob8MGyl7/FvIvUV2sqyPLCeasls89ig4Z/TcrPAAaRUjgUsloP8U225KnAavD5dW8nQ/CA12RZ6x4WEDERqSvCYfvDQ3e652bGnSJm2mW0zDqk
 Ac3J6pOf
 fkDmrE4THSAO5R/ofl0XKvbDNrcaNQPlESaCIyXy0fNB4DI+t0OIbgeBgXzhfIeIbIiBhPrUwVjFMU+e0kSg3Oszi6RSzn0bi0hoznioegwlx0vB4xPh/ESVX1PvJIw9Y2ioWU1Gr3vk42lnXByX9/L+Kd5r2n/sm7Ra2AFkB8FWzsTSE/zhL0A7QOu9W4XHwfSCLggvjzs4/R7DrpefS0tjn0S/F8WzlChh5+TZkrjeb/LEVCGdy07Fn6n7dC3qwLD6F6bdgF7lN2YiWvvHBWYrJ0+th82oa/PTzw7qGfnztu6GX3I/65VDyXbU6rURr5KAfXmjpeoe4Bt7JldMtNauwZSotEWd53nuSIcmFG4v+JwKQZCZ54Vk8V1UYidgUHqbdvPkqly3qFbLnPQS3qIDymHR9Wd4A6msrKb9IW18RkWZmPjA6/N8Ft2ZhzgK3PWa/xDJDlxJq+KNioBsYeC9Nwp/1buYIBy5f9Gt5K23OTsSnsJocRZggAEW4lzGFgUUsyi4hlpJvXoe7ZN0dvz1MlAlXZUJf3mXuCq6GQp8P6oaBujy9hqHxkwYQnDIqt6xhF+r9N4GlJYGqv8xc4m8EFE9qpqcXcfD/NmS+qblKARWtd53Z9h7fWyYEjB3LgOgEIVleYGuFmWkDNXxOzZLTOjOKe6u9XaN1ZkY7FKd4bWgexYbp4U/MKuP4wBzSUGmzNmtAIMqdOS0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 02, 2025 at 09:49:48AM +0200, David Hildenbrand wrote:
>> > +	/*
>> > +	 * To challenge spitting code, we will mremap page[x] of the
>> > +	 * thp[x] into a smaller area, and trigger the split from that
>> > +	 * smaller area. This will end up replacing the PMD mappings in
>> > +	 * the thp_area by PTE mappings first, leaving the THPs unsplit.
>> > +	 */

This confuse me a little. How about move "and trigger the split from that
smaller area" to the end? So that I know mremap convert to pte-mapping and
leave thp unsplit. Then we do the split.

>> > +	page_area = mmap(NULL, page_area_size, PROT_READ | PROT_WRITE,
>> > +			MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
>> > +	if (page_area == MAP_FAILED) {
>> > +		ksft_test_result_fail("Fail to allocate memory: %s\n", strerror(errno));
>> > +		goto out;
>> > +	}
>> > -		if (i % pagesize == 0 &&
>> > -		    !is_backed_by_folio(&pte_mapped[i], 0, pagemap_fd, kpageflags_fd))
>> > -			thp_size++;
>> > +	for (i = 0; i < nr_thps; i++) {
>> > +		tmp = mremap(thp_area + pmd_pagesize * i + pagesize * i,
>> > +			     pagesize, pagesize, MREMAP_MAYMOVE|MREMAP_FIXED,
>> > +			     page_area + pagesize * i);
>> 
>> Would this create one hole at the beginning of each 2M range and cause
>> splitting underlining THP?
>
>Yes, it will create a hole (this also happens in the old code).
>
>As the comment above it now states: "leaving the THPs unsplit"
>
>There is a check verifying that after this mremap code.
>

Thanks for clarifying. One nit to the comment above.

-- 
Wei Yang
Help you, Help me

