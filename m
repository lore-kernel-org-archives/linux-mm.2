Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD91ECCF9E0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 16:09:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 291B480068; Mon, 27 Oct 2025 12:09:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2690D8000A; Mon, 27 Oct 2025 12:09:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 157DE80068; Mon, 27 Oct 2025 12:09:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 001568000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 12:09:27 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 98C29129B5D
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 16:09:27 +0000 (UTC)
X-FDA: 84044379174.09.7185778
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf18.hostedemail.com (Postfix) with ESMTP id AE5A71C000B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 16:09:25 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b="N/rN4Cii";
	spf=pass (imf18.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.180 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761581365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=anSGbOUh9PRDsyCb0fgwZTMvbpzdcHnK6psdZLJfHyQ=;
	b=WO9F5IJfIMQzOfivE2LI20VM4AdwicXQwnsWty2tAOuuKft5aGIHTPfrrkjU0LW5qnNwYn
	UvIHpNG2cmaBvzaiu0uJnk3TvYYny+f89bSVyDCejkidbjY/Mv7TBFPFxYuKJPKXwpeJDR
	MZd30EDB4Wk3CNcJ3ddQqsBp8i/brGg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b="N/rN4Cii";
	spf=pass (imf18.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.180 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761581365; a=rsa-sha256;
	cv=none;
	b=fWpoZQtn//NWDwMGw6ywZSI9Qjj3D7rHdZpccxioGkGtgOdsPR0LCVCwWUPaLOh71Tc760
	4QZtHxVN7vEiAYQ0u18GQAY0/D88grU7S0zvceZ5Pf5yBmjQGu/qkvQfcYW9BGv6Da5EQA
	mKw/wsOolxYGvuTdDG4d0OLL+ueAoM4=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-893c373500cso493733985a.0
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 09:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1761581365; x=1762186165; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=anSGbOUh9PRDsyCb0fgwZTMvbpzdcHnK6psdZLJfHyQ=;
        b=N/rN4CiiiXz7+tF0QT92eO08AnBtYt1m9Z+Q6MQk4d3y9PuiR784iB/Bl7IycSBLyk
         S/xI2oqEGRpQSEzVXP96KYkW7B+DY/5Hy9qn1HaisR7UZKs7vIfLbt4Nxt9y9iypD5cH
         b30Lb7FoFzGyR7uQYOnITOfzgGSki0t0yYsgC+eIhfP09es7CQ7zV/oU1bMcotjw/Atx
         Mxwa6nyRew74paTNAPiIHfno9eY0pP47wZZ8Hx1xgA7JeGGLBBuyF00jHkAdEPjaBeBr
         I3cdBEPYDtMsI2aiIoTd3BlmaXwTg1zILhxnD5/l8yUjJUXf8pR/dDoGA1fpRVc6cmiv
         P1/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761581365; x=1762186165;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=anSGbOUh9PRDsyCb0fgwZTMvbpzdcHnK6psdZLJfHyQ=;
        b=umQfsPfe3HLa56mg7Z58hvk4U+ZWg1nBOBeGHoNn9L02MXAvesfcTcmBOLZiKEBe3h
         R1v/aZCLqHk7RwvS7SjvzYMg1xB7nm+tG+oC1oeT6ZXY0l24WSw2cK09YQzsLT3L7Vzr
         MQMN+KtwVpfrRH9HVKNXg65+V5v7g+IOYOPdK8i8iWJrTxt5LSZ5D9mtiNngIWRywcK9
         utm23rY3Cwf2vUjkmtkODPxahlM6zmjfO7u9FjLpHxxxciMj8PU4LdN9jMEPu50Dgu6S
         KLkD9gIvN1ZeG0fOmckHH524LW3urISDDoAI9beFL95CMEMJ7MAB5PE+5pKLg6xmYY2R
         0sJw==
X-Forwarded-Encrypted: i=1; AJvYcCUR5KYTq0tU820wp+EE3EWDE2aZArvNi1FfJNPydNMoqZ+sGyOqxY65aEYByDYeWKJAlftdCkYwwQ==@kvack.org
X-Gm-Message-State: AOJu0YwW+/v3QbhqwEA0SoqqaKOztPppoNEuQOTknw4qJOf5rotfAz/R
	PZh6rFfoklrrM8TqPwCard1RZwiNV3/qNsvi4kOPEM+Sfrugj8J2LnIYSRYm+TW9s/M=
X-Gm-Gg: ASbGncu8/0FRUSDgIQmfLlx3YXTsyBNKfAM2YbqzcCwWbB1cx6wKttFADwihsX6+N3o
	gi1ke7mK466yZTMW6qM3aWezBssTu3cvN7uxqNek8U3laOy1YH3iKJIoRdu3LybVA06dqdyepcG
	7/OuOgNhBSG+tV06JvE/vNPyWcQSWPQIm8b5AnfY8r13SudDzN457rnT7/wZjx0mouYDR/YtzFb
	oL+W4i2lOzjt/CPIJ06vWEJ8RIpwpXQLPdzSsiALAwlT/NrMmyQA6i6fzRDx7VJlssS8rQidEoV
	sDwICrNvz4UeZ2PBg1TpaYu6pklxi+KMCqkwN66N39e+6q8QfBEvzF1ry6jtYC5upiRUzc5Vsdy
	7x5sId7aUl+8rFm9j2awOlJ8mkWlmiaIWOG8MrDCO4b5sb0lUBN5A8Sl4tZoxLXAGzjItVBy943
	GbLFw/T6+caJqLwH2DDfwCn49Ei/NfASqndikl5xAYj2cs1K45ijqlh5Gx
X-Google-Smtp-Source: AGHT+IHlNcX7M4ho1Hgm07pKSXRDLSWwAqfcPM4p2At44BY4PwXR6XnbKFaciXa2MkD0JUoTO3ORTg==
X-Received: by 2002:a05:620a:1aa1:b0:8a3:9a05:ec15 with SMTP id af79cd13be357-8a6d072570emr95429085a.19.1761581364508;
        Mon, 27 Oct 2025 09:09:24 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-89f25c8a34dsm624408985a.48.2025.10.27.09.09.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Oct 2025 09:09:23 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vDPmd-00000004HT9-1p2Z;
	Mon, 27 Oct 2025 13:09:23 -0300
Date: Mon, 27 Oct 2025 13:09:23 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
	Peter Xu <peterx@redhat.com>, Matthew Wilcox <willy@infradead.org>,
	Leon Romanovsky <leon@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
	kvm@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 00/12] remove is_swap_[pte, pmd]() + non-swap
 confusion
Message-ID: <20251027160923.GF760669@ziepe.ca>
References: <cover.1761288179.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1761288179.git.lorenzo.stoakes@oracle.com>
X-Stat-Signature: cn8ei59tmkz6bkxs11y49xc8u3uj5tgs
X-Rspamd-Queue-Id: AE5A71C000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761581365-375305
X-HE-Meta: U2FsdGVkX18wzx/d1TrRMk1rvKMKO/yGXPvBHAA2UYaOWpUWsy5Ci7KbWk+G+ySaExQPl1wa9/VAOsvKAm7MWaGPBeJXXgLXCAbmCIZDAKCChmd6nvABposzN4w5KTZrijJC2tXBy47bGJ7jyQ81qAIn87GiwMIcBuVh8yrxPddAiQ4eJDRxMSZqgVbsIwSoGXzlIChhicMkcNEa9WKSdAaK4A0VPPkbYGysP3o3gVF3F16H6hF0NZp4RDCIgiW1asbG5Ll15cHb2Xg5z14pCoXbLlRJ2hQFpls9ANDEEk4TzRRlpaR0jSNWjMj15aVHToEZCSo52twqAiW0hHih9i0Vf563d1mb6Yi12BgUEYrX2XIV7z6CdybyllGVrnnlL+RxVDNayMdi+t73Clu/TNGr+E/4IzS8CWdQ4ZX1GyOJO8uS8XgH6JYCWqwRNb4hxwUBu0vgw0hcCagVewtB/A3QoNMtRbT6kN+ISoPjzFkcnecPuqns4j124NApPnjNfZcjPT8eI6/oKYxNgYvnb9Pc10oT1B7Ydgf0PRsK0Aj5cgbZdoRil5d4OSFlfwtyEDKWVGzvQzkTDmfqSdtdEU2uN4Z95eNGzdPzGJMiVOGaJBmvVAgY8sS/GWAfzFyktE+5NlpP2maf46OrYPBX/+A8KfcbjKyRqfIQjFEHJpKnRFH8ll92yonCCWpIuaGT7pl06SLQUn4eFxkhbQhswwKPlcjRsRHuv5Ecrpz58izTdnrAndpvGgTx4HZEmr6XblxwJZCwtkNGbxukev9Zs46lbGIPJcw/cEBfmEMY4WtNMNsZIE5Oj+IFyV6I8WM6TZgJcIvZsZqfFz9I9TG37AQiLNgyko892KJvNU3dInQ0LWAxu04fV2Dyzgyxn4VFOPYRd0sKzO4HML1X0KMVfNSKhHwhw4yM3N9TgNLmyZc8GWPqTMD+RjgPaz+uy6Czpl3Z/g2RoHVG7x+21Z/
 L0nGfIIR
 mkIKCJgRBSB9RMtq7jFSMD6b8uFLncERUf9BKSVHx0gyOJ/5NUa754bsu9eSMKeoVZFeo+60d7+hWg9X6GskwTz6PJ/8hqyj5UarvvnTEz7x+yYsFb/sf4KXlmu8T28LfZOI2O+JgoAmflziS+pYzTaxjV+1XCmwx5BDRUCgThd0P2n9+9Wu9jtECacJtK8GaMwBmV+SaLfgqfMjpCossOwftdZiMInH8q2MZF4hEhfGUTKsW+tbX6UuMylhoWIv1sH6YcWOU6/DBxIHtXJq/kEjjAEN2nUabuX/pPuS6+YmCC/pVVO9+77pIVXaNdfpicyKu3hVbXFVRWaWPKN/I3FXg2XZVD/GYagA7LzDKq292QkD/0OWwgx7m/XwMWKeGgjb7nKPJXZClIxPabuIY1qLyNA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 08:41:16AM +0100, Lorenzo Stoakes wrote:
> There's an established convention in the kernel that we treat leaf page
> tables (so far at the PTE, PMD level) as containing 'swap entries' should
> they be neither empty (i.e. p**_none() evaluating true) nor present
> (i.e. p**_present() evaluating true).

I have to say I've never liked the none-vs-present naming either.

> This is deeply confusing, so this series goes further and eliminates the
> non_swap_entry() predicate, replacing it with is_non_present_entry() - with
> an eye to a new convention of referring to these non-swap 'swap entries' as
> non-present.

I'm not keen on is_non_present_entry(), it seems confusing again.

It looks like we are stuck with swp_entry_t as the being the handle
for a non-present pte. Oh well, not a great name, but fine..

So we think of that swp_entry_t having multiple types: swap, migration,
device private, etc, etc

Then I'd think the general pattern should be to get a swp_entry_t:

    if (pte_present(pte))
        return;
    swpent = pte_to_swp_entry(pte);

And then evaluate the type:

    if (swpent_is_swap()) {
    }


If you keep the naming as "swp_entry" indicates the multi-type value,
then "swap" can mean a swp_entry which is used by the swap subsystem.

That suggests functions like this:

swpent_is_swap()
swpent_is_migration()
..

and your higher level helpers like:

/* True if the pte is a swpent_is_swap() */
static inline bool swpent_get_swap_pte(pte_t pte, swp_entry_t *entryp)
{
   if (pte_present(pte))
        return false;
   *swpent = pte_to_swp_entry(pte);
   return swpent_is_swap(*swpent);
}

I also think it will be more readable to keep all these things under a
swpent namespace instead of using unstructured english names.

> * pte_to_swp_entry_or_zero() - allows for convenient conversion from a PTE
>   to a swap entry if present, or an empty swap entry if none. This is
>   useful as many swap entry conversions are simply checking for flags for
>   which this suffices.

I'd expect a safe function should be more like

   *swpent = pte_to_swp_entry_safe(pte);
   return swpent_is_swap(*swpent);

Where "safe" means that if the PTE is None or Present then
swpent_is_XX() == false. Ie it returns a 0 swpent and 0 swpent is
always nothing.

> * get_pte_swap_entry() - Retrieves a PTE swap entry if it truly is a swap
>   entry (i.e. not a non-present entry), returning true if so, otherwise
>   returns false. This simplifies a lot of logic that previously open-coded
>   this.

Like this is still a tortured function:

+static inline bool get_pte_swap_entry(pte_t pte, swp_entry_t *entryp)
+{
+       if (pte_present(pte))
+               return false;
+       if (pte_none(pte))
+               return false;
+
+       *entryp = pte_to_swp_entry(pte);
+       if (non_swap_entry(*entryp))
+               return false;
+
+       return true;
+}
+

static inline bool get_pte_swap_entry(pte_t pte, swp_entry_t *entryp)
{
   return swpent_is_swap(*swpent = pte_to_swp_entry_safe(pte));
}

Maybe it doesn't even need an inline at that point?

> * is_huge_pmd() - Determines if a PMD contains either a present transparent
>   huge page entry or a huge non-present entry. This again simplifies a lot
>   of logic that simply open-coded this.

is_huge_or_swpent_pmd() would be nicer, IMHO. I think it is surprising
when any of these APIs accept swap entries without being explicit

Jason

