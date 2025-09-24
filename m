Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7E59CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 11:31:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E91D48E0006; Wed, 24 Sep 2025 07:31:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E69708E0001; Wed, 24 Sep 2025 07:31:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA6758E0006; Wed, 24 Sep 2025 07:31:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C7CC48E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 07:31:16 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 817FE8793F
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:31:16 +0000 (UTC)
X-FDA: 83923927752.02.F0961B9
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5413820013
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:31:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Ul+x9Ewj;
	spf=pass (imf13.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758713474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=637WUc/nwWiUM+V8dhx4NgX++0S0IdJZKJNTlkNoKtU=;
	b=xncaoxP0ap498g2yK5Br4IjLKTwF6PgwiCBUtm6wwkXcTKjQjTzJyVo7Z20wr2B7wf4pub
	qMpHHSp3vBIsWOPtWwC1LgRC6yv90x828giJBcz0jU4ICxVDA4pwBb3xIfF9cTW5Ji0mU4
	LN/i+zMnAdZFtJKEjQnxb/V4/LGldC8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Ul+x9Ewj;
	spf=pass (imf13.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758713474; a=rsa-sha256;
	cv=none;
	b=bGAfMwZLsFTVqe39ximEOLrSrygKpoFFxe3r1NJngZY1nU2LOhej6dzBKoK/NxXMwA0IxL
	1YLPO0sYF250sf5zronZfpaKWsu4wPjrMNY6sQLgUy9w9jyKHeP2Pldxwzq5x3mJJ5Y7VR
	IxqWfsw4TXS26yy4HII/KHJ2TjDRo9M=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b33d2f0f5f4so45232566b.2
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 04:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1758713473; x=1759318273; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=637WUc/nwWiUM+V8dhx4NgX++0S0IdJZKJNTlkNoKtU=;
        b=Ul+x9EwjAgLkk9LlfxoQj0RbwVsloT44vCLq6QdZVnHrp1PgP7JT27ZQI/uCN3LAn3
         1eFUGO7gvnBQTpjQGRldYC2BpsLAkaP8R1krjShmyGpQevAzRFhIDnJ4g3gTA9CyfeFw
         PwTMZQMtmjtlrhYCdTwk/jfpW/eGhyV79up7mzfN80N+l1SKBTnWwHjO6VgYmZpya6td
         UEm6ttX5uZcGzqr3QOeJgrpZABdEKrDQeNwn/TXepKo81ko/JMvqBjT3GfTagf7Bnm0r
         InjV16vMpzXCKdbfg75wxyDE2OKQTdsZ1SS1W96/GcrFEUSmqkffqabWaLB1vOturs+T
         /Itg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758713473; x=1759318273;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=637WUc/nwWiUM+V8dhx4NgX++0S0IdJZKJNTlkNoKtU=;
        b=ksDwcnmttgZ5upn8GfBCB1Ds7+uQtUycBeRJBMIcDVCS+y8hbEkRq2qwpkGn/rl7DW
         48kne1oI5UeEtvMl6ys5jYkoj3SvmnwWmsWp59k5pVl8QguJZKQ80FU/mJ8BGb7YK+fk
         oeLVlI0BDswhuZrbPsFswQQP9Eh9Vfqi6DDWalrUHyicySz2OITU/URbOe1/zr35DBjd
         z3vo1w6NWXQ0UaOBZHQXBkb7qp2mFzGJk72FAQmxiUCmZJfcfBIpYGibfRAMzCZGVd8Z
         Tqt20oGw+VEsDZX4iHxrrddiXZs9+ujlrWFccXsnHVWoKFbNnCLtHFsKH2shP65p4+Rd
         sw8g==
X-Forwarded-Encrypted: i=1; AJvYcCV7MBUUBJeA1B6rsMHcU4asUSHaG6hn8t/xTVRK5HXPQvxPBVAsHcoFYcF9BIEFYGot6ieO+QnWsg==@kvack.org
X-Gm-Message-State: AOJu0YzuCdapRyYTj+QSGMZIiTUxgs/7dBna/skDSUo6pqjQ1DJCWh+6
	m2tLE8YOOsRPfn5ZHKq4DaAahBk114ceg10mlBh/L8YtQJf7JpLMwZEd7y5gRzfLxek=
X-Gm-Gg: ASbGncvpJUArNTUycPxt27RvSlnO0a8LXm6QwSkDOJIEcGYfBd2N9Zy4px4a3/6dA1D
	2ZVZl8GaCtwiPvhvjWbqGfGLVfeapgaE0NwXsiCIReD/QY9U9jvahkNVVzMo+GPs4s4rHiwk4AE
	1+exNy8MgMUNTnAihzOhol9fgicqmI7yvtafJuVSbQlr/epOKqa+j0S9mf65AX/2NM5xQQWxaFQ
	Fq3l/TyYBL7prTn+EXJ7JZDnm/aY9hCbphuPqaDJZGxTz15S+cODMGie+MJW/U0+FxzA8dbKeBY
	+MWTQDyBl1LUUwz9QtJK5y1I8kf4nHtRY1Ide8LzF41jUNeSVueIWVYCEOm6J1HVT866hfy+M5F
	tNT+5K5x6Cun2cRwAG082xjZpJo1NQAC9JA==
X-Google-Smtp-Source: AGHT+IFwqviL2x6K5KiCu69kgX1ZGMPc3DEhoWrI7DBGQxyVK+302tzYrLsoz1pxucgNK2qllIwT9g==
X-Received: by 2002:a17:906:c14c:b0:b04:2212:4211 with SMTP id a640c23a62f3a-b3027a4aa98mr602315566b.16.1758713472627;
        Wed, 24 Sep 2025 04:31:12 -0700 (PDT)
Received: from localhost (109-81-31-43.rct.o2.cz. [109.81.31.43])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b27217f616esm1136307466b.72.2025.09.24.04.31.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 04:31:12 -0700 (PDT)
Date: Wed, 24 Sep 2025 13:31:11 +0200
From: Michal Hocko <mhocko@suse.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	david@redhat.com, anshuman.khandual@arm.com, linux-mm@kvack.org,
	dev.jain@arm.com, Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH] mm/page_alloc: fix alignment for
 alloc_contig_pages_noprof()
Message-ID: <aNPWf-OfqmUn8wzk@tiehlicka>
References: <20250923001943.2479-1-richard.weiyang@gmail.com>
 <aNJMSNYflPqYMjuE@tiehlicka>
 <20250924000528.plhmkfn4qnx44a6x@master>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250924000528.plhmkfn4qnx44a6x@master>
X-Rspamd-Queue-Id: 5413820013
X-Rspamd-Server: rspam05
X-Stat-Signature: 5751iwdbonf1g6hynh4zxystz3saptwm
X-Rspam-User: 
X-HE-Tag: 1758713474-473349
X-HE-Meta: U2FsdGVkX1/cKOoO2lxFxqblvo/vSXGpsnodDIm0044wlUae0J+xEks4P4BJ6kTf9W8UMyuGXzjV4DDWLVBYaKjwpyqgYInvMP65u0WO+ZpZ7DJWnhM/wNhm4t7t+IC9gA1y5+n7FhXwCRjWN4LiuCXHkPLFqInpxTjQsJpsqIU7beCoMveeHHEBFR6Ph2MzPkJD6aOu8cHZGaCBhpI6Ros76nCJbtUGZbApm0Zi+FMAZBV6eksW9sCgtCa+ipkZ+LAoPh/27MdmulirSl3SZ7kAGcM6aRSI9jeNIgvl1O/AUwNvat8dFQv3HC+FviA/IqTPrtXQJ9bk55rTPp8qV2ysI6SwQBnzrYbPHHxDdHcKhjplAF/lHA7N8uFi5FJ+M2vl4rLwz7LrTrc0A4R1imIGIMZJWqeaqKSBv+SThmGHvVM0lSLjTYd95CsnPK8J7KGQ8vWXtgeUJ4aDyw4NcZ/9UdhVBvO+2lCMloqh4sjaiHcDfCwdD/E3V7f8giAQwqyRw5zvwnTC3R3b3359m31Bb8kBE5STC3lj5WErFTf1ENZ7/iztPkQHVUAKBLYs5+buHnVuLbh9OW3Nizb99wZxKN0krUlI4GBmId4BLwNe6P1YrT3GZGpdrHLJPCaAOafu5rPj1nOJrurA+XIPIsT+phzm/lJDLRw0U8U0hC78NYRdc9DBDq4tS8mnGcSFjekCbKPsWV+1hASn/yKoN6MuSJlsIC8NL4HOZy2AmdHUPLARuA4qi2XuXe0EbBteJQXb0eWmvLqQENbXbxP0LbH1Tq+HgXR8KGoGTs7fDsdoTIRTbzqFbrpP8KMvqmQwAUHQw+6ucjZS1OKDKyBwKw58A0xERqBLTTnpQKWVVvDyU5EjUIcnOKu5PCUFaAk7SO7PCiqprf86iELN+Ow6k0NyKuHI7JrtjuVhtky2oBG8aO2aRf8EbvT/yhbap0KnQW5fYY6jBblqSDcUbFI
 XNKv1c/j
 AmHu5IO1OEXIodA1QcxCktZzLaILEjWL/EVXHwPn9M6V3y6mVbsIenOIjSQxtPUBA6BoDcKyl7KJhWpiuoKnuqYSXa6at/gYwXejK1WnurHorYmI3buv5QMCUFMGHcoH45fEUE59g/alNElRh/I790XROeOrwbjuyi3E6UbICTGuN8BpdT2lIEPEOE/zLjV1z3ixZF8pDk9YW/Fydou4XClFBC/K4QdX5PvNIzvxMw/oBYu0RL6FRysa7IVmtj3UsNwWwl7OCinoXB4Uzq06GaE32Jb/OMdDrIpEdNf1t74Cej26+n+URuAgNBVy/KuEycg6NWZVLqjAN9emdFC5eX0+f7chSqk6cVRXqEngZT+txug1Rl7qXy4czHz2FP0X9VvKSeWOeYCCOrElHBdmhNRAfCoD1THRT+uSO5qNvjGk+a+WlLOna290y/Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 24-09-25 00:05:28, Wei Yang wrote:
> On Tue, Sep 23, 2025 at 09:29:12AM +0200, Michal Hocko wrote:
> >On Tue 23-09-25 00:19:43, Wei Yang wrote:
> >> Commit 5e27a2df03b8 ("mm/page_alloc: add alloc_contig_pages()")
> >> introduced generic method for alloc_contig_pages(). But the alignment
> >> calculation seems wrong.
> >> 
> >> Since ALIGN() only accept power of two value, while nr_pages could be
> >> any positive one, the result is not defined.
> >> 
> >> Use roundup() to calculate the correct alignment.
> >
> >What is the problem you are trying to fix here? The ALIGN is certainly
> >not well defined for nr_pages that is not power of two but does any
> >caller of alloc_contig_pages assumes any specific alignment, especially
> >when nr_pages is not power of two?
> >
> 
> There is no real problem here. The initial thought is ALIGN() don't expect
> non-power_of_two value.
> 
> The discussion above sounds reasonable, we don't need alignment for
> non-power_of_two nr_pages.
> 
> So this looks we can start iteration from zone->zone_start_pfn for
> non-power_of_two nr_pages.
> 
> IMHO, How about the change below?
> 
>     pfn = zone->zone_start_pfn;
>     if (is_power_of_2(nr_pages))
>         pfn = ALIGN(pfn, nr_pages)

Why should we do that if we claim there is no alignment enforced and
therefore it shouldn't be expected. Something like this would merely
create a confusion and subtle bugs in the worst case.
-- 
Michal Hocko
SUSE Labs

