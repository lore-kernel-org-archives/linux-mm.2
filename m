Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BC94CCFA05
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 11:43:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B757C8E0007; Wed,  5 Nov 2025 06:43:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4CDE8E0003; Wed,  5 Nov 2025 06:43:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A64188E0007; Wed,  5 Nov 2025 06:43:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 93B108E0003
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 06:43:57 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3F15C1A02ED
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 11:43:57 +0000 (UTC)
X-FDA: 84076369314.30.7FA1034
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id CB85E20009
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 11:43:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LGJbevnC;
	spf=pass (imf03.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762343035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=klnCOqdIdlHY6mc/bR248n8wJUIpm2Vh5Q48weSXZPE=;
	b=MaACynp39c9xBmIRbH1F1Hk3gfzpqMRJOowmIkoHv5CDBUfomSimRgDcvFEEmey3I314gZ
	cvss/8wBUHLCEyNn2iadR2fQ+mtLAN0VvmTwfTxuiqzL9OXagPwh22rzPfKnQeX4o6LEE9
	YWHOidtlFGbzM3Oqvsk8P8NoVvwfS2g=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LGJbevnC;
	spf=pass (imf03.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762343035; a=rsa-sha256;
	cv=none;
	b=W4gS2E/EvmTY4CCJJYTAv4M0GNc8vFw/BaXYnz8hr0iTrfcp6sREI96omRt+YqlQfwtpxw
	xQ84a8IjRFOgQtbpLIwA5eJOLiMCSiRqgl96m2pCyZxwyg57EoQwF/iGwzfknFk4eA9Gf6
	s3lkfSsqqpI1ZZ3SUNMxI6yjuVt6MT0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762343034;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=klnCOqdIdlHY6mc/bR248n8wJUIpm2Vh5Q48weSXZPE=;
	b=LGJbevnCt+0GbzikKP4aC7Qnxlo2zo/9J0ITKpX/i3ct+BpM2hAWlA4xh8EjtO8q4W7nvp
	rT0Hr8Eg767bnPwkP5Kim0aSa9yjN+om59Facmm7CsExzkoQ0MYJCRjjQP8ewXj8g44coX
	zQUQddxcfRIrGKLP7J/fCetR8l+PRWU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-whnhNyd5ObeL_DD9lkkyzw-1; Wed, 05 Nov 2025 06:43:53 -0500
X-MC-Unique: whnhNyd5ObeL_DD9lkkyzw-1
X-Mimecast-MFC-AGG-ID: whnhNyd5ObeL_DD9lkkyzw_1762343032
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-429cceeeb96so2112660f8f.1
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 03:43:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762343032; x=1762947832;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=klnCOqdIdlHY6mc/bR248n8wJUIpm2Vh5Q48weSXZPE=;
        b=ss+JPZDtmjGDu2kOZrSF+gB9ycYNOGXSY0TZGVpABCyVjnExqRzNOlbpGCkSomQ/2c
         xEfGgaQ1VPoqWE40lfsQ8UVLfcNty0RmiioSSud+x21JXPKcKnB99c4Hm/hZm8Ls4GUS
         2z3paHOLWE168tRRhyDmt2uiKLhV7grd/c6nlxC0fm8lkp49tSoLjsJxp1X65Heq+xYP
         dj75YJz9e85cv1qB8AVRY5QnXcCWGFE2IPOvKqm0E+AEjx43ENQPr/KqxuJMPTy3NoIt
         uM5JEtIAyNhWU4/71OUgtZjL+G8Xe73aEsIG7HOSvW++R51g6jl7C+kxznTbP3lMoCec
         qpcA==
X-Forwarded-Encrypted: i=1; AJvYcCXknpXuiHAcvf4ENar1WjHg41lSTyB0BFn7nOxyECJTobLbvOmEGis4vrPv1i5Fw9N4Op7RS/1m+g==@kvack.org
X-Gm-Message-State: AOJu0Yy+TUrY0+fJwXq7p3J5OMcgiccLoE8qQVqitAkXjOZ1koHfFapB
	rfC+K2rANd/1ubfbyX/yMztRwfP5x7Io2T8xN1L+tjWwiF8lAYPm7LMH+pNysyZyk3QisobYuJ/
	E1N76kGn073mXlbIsRcewXCCTb0RbK5gxJzOaN83AVEGzk2GAaCvE
X-Gm-Gg: ASbGncuNPDZx1THYaP197Sl6z4Bo/rXfVvgwYx8fwrenUlYNtV05O5sX1KYAnxlJvKS
	5H48v8tdvDHPJQJj8iQq8J4m97v4JNJyIyI/bi8fpk4AmSD+HmPL6x+mg2lA85tokmPwt+IoMR7
	lPpQgVrhjdHO9lncTumIkfKE3PU91aLjQgBo/QY027b1BGcmaMB4t7ruldhaLjIwsxcELNGGfAp
	BPg2O8r7sGIjnKzru2czRwtdP/UzZKyN5SafSC2r7IThZ2F9osqt9h3KzpxPLw9CQ6NjPAM+Xn3
	VaRkOxoVqOgyKb7x9FFAy3dkpxcRMvOd75fh+JVnQoAW8Q9lzK6RIutcUvSgF944kNu6Cvtxowb
	NFiDKmVeq6zOm+BagDTdwe/ISG2J8mO66vanSzNkwx1Er0sH4e3vU3cPBiicSG4lOGUgllDNhU6
	iXq1d23WoO37wWr6lo85DTYh4=
X-Received: by 2002:a5d:5d0a:0:b0:429:d2a9:5dea with SMTP id ffacd0b85a97d-429e32e1778mr2767700f8f.15.1762343031797;
        Wed, 05 Nov 2025 03:43:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFd+fmDakXbZEyKRhdg87mxQDe9DRgIxrMqS8HdOHW3oWAXWsvoavSh7hxbMrysYBkKGmrGpg==
X-Received: by 2002:a5d:5d0a:0:b0:429:d2a9:5dea with SMTP id ffacd0b85a97d-429e32e1778mr2767679f8f.15.1762343031390;
        Wed, 05 Nov 2025 03:43:51 -0800 (PST)
Received: from ?IPV6:2003:d8:2f30:b00:cea9:dee:d607:41d? (p200300d82f300b00cea90deed607041d.dip0.t-ipconnect.de. [2003:d8:2f30:b00:cea9:dee:d607:41d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429dc18efbesm10423127f8f.8.2025.11.05.03.43.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Nov 2025 03:43:50 -0800 (PST)
Message-ID: <58d3c50f-2b4a-4053-a846-613434d5bcd9@redhat.com>
Date: Wed, 5 Nov 2025 12:43:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/2] mm/hugetlb: refactor sysfs/sysctl interfaces
To: Andrew Morton <akpm@linux-foundation.org>, Hui Zhu <hui.zhu@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, Hui Zhu <zhuhui@kylinos.cn>
References: <cover.1762245157.git.zhuhui@kylinos.cn>
 <20251104150618.0606afefb2a9e226aaa6ce77@linux-foundation.org>
From: David Hildenbrand <dhildenb@redhat.com>
In-Reply-To: <20251104150618.0606afefb2a9e226aaa6ce77@linux-foundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rgUf22C4BR37Av_Bz-vcSIJ5FsvfuNFDbAUHZx0m_-Q_1762343032
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CB85E20009
X-Stat-Signature: 369z69ewss1xais1axr8pzyoikmcss9w
X-Rspam-User: 
X-HE-Tag: 1762343034-885822
X-HE-Meta: U2FsdGVkX1+LioaAekq+EFpY30ZO6GqpMx1uoNyVy8ClCDDFVCy7R61OpABRFWj/i3RwTlSq/vrlRBn6JavEo/eepgDwQir1w+6iV38XZnoIanuDuNSzHU0sVggskfZxwN7pNCGB0BneNCjsBXU+2FLePQBAMxhN1C6jZ+NeKImdG0lA30Uu5vFFLgje/HdlM2JPwd+5ldfQpG4aKPFRTQae0WN85IHAkheTlnaEgHT+iI/9pCbTgKT/q/Qzwv9/NpVXvVABiEG6BzKoDpUWx8qVXwkrdk5IBJtBuasfHldTjW3PI5YMahJJOTHTiFmqGPMW+H42oEvl0UhIK7/83InhWsT749DivRJMgxARBxmToNgwcACPnqDqtdXNN171R7LwB3ATzr9X8ywY4YQbnIzdqctcd6jUE/uWigoBhXaGu2t2U4x5qa/nh/7j4286Y2Ju/XeHpOwW1zkkpHxMHxlRocP2s96uSMlWnJiyWus6ZpVg8Hf83Moayc5O46dVzvJsvyV+vjVMCEODKUkS6wmk0RnRVW302MsmSS5K3flTuTOZ0IsJQ/oUXn+Vl7Dm32IJZ7HyRBZTz/Sb3UKFgjB70Rkr8VfE0evB+Roc2lDSisdYADD2xQUCXt7AJ26jShiKtYZlFJgQhLMYcauD57beRnTK0WpSp+HIfVugKcMoso7c7jgcxJO+7ucZMIsvu0qc6P2EhK/iiA38ZVxz5gaggJYV8Bjtchk2jK/oo0wpYJAmK34ZGjbFUX1+mzAgMYrnajRaYCnpP/AvJiO0ov5vSI26Nv06TvR2KccrOqOh+t3hsizWVqUSX2baZoK+Ne7XNQyfwA2MR8m/CNccJfKLoGFZHfvz7DGdTMTxJlIfpWsUG0qdhk9h3MFqYoWcVXPkfcofgMDwnZIrh5gg0bSRS6WTkjE435iOIr8AvGTN43L6meeyForJ2H6Fr/MGU+t5g/DSVGqTl5Pjg1P
 WcERLnR+
 qIRyUjH8CIg/sTTHzkhiAP7yGlFBNyHd6Awf7+eG0Wq0zGomWYu+lJV46/758pOIX0pH8fXjeAlxYN9gw31RmIO4zB96lBiMZoYF1y/kAmWvgPRvKoXomKv7klhTzrfEV+N038gocM3OUEHpLr8tjYTMOM2IuyQs82ZvWiOTz96+UqrKxmyTSCmzF+9Y6fJj5iu0gerBOQRo1IQ24JP4W/uDx+zAyIZswNV3W7aUpPsqDj2hRBbQiXHsyZDtn9XznqBo+4FXgje2+iQ2X8g5iGlKUFgxq2Cme4ttPAv6sYU6Kv3Ggyb1d2hSrIvo6cTHr3C+T5rWXz2JQtyNPw+ZtrrpNztllKZz7qMoFXHlqF6cCmnExk1PXsAY39w7JdcCq0tMOOno5sqTxOVv1tDuk5EsyMMu278uLtY70MYOy7xz4BRo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05.11.25 00:06, Andrew Morton wrote:
> On Tue,  4 Nov 2025 16:37:41 +0800 Hui Zhu <hui.zhu@linux.dev> wrote:
> 
>> From: Hui Zhu <zhuhui@kylinos.cn>
>>
>> The hugetlb.c file has grown significantly and become difficult to
>> maintain. This patch series extracts the sysfs and sysctl interface
>> code into separate dedicated files to improve code organization.
>>
>> The refactoring includes:
>> - Patch 1: Extract sysfs interface into mm/hugetlb_sysfs.c
>> - Patch 2: Extract sysctl interface into mm/hugetlb_sysctl.c
>>
>> No functional changes are introduced in this series. The code is moved
>> as-is, with only minor formatting adjustments for code style
>> consistency. This should make future maintenance and enhancements to
>> the hugetlb subsystem easier.
>>
>> Testing: The patch series has been compile-tested and maintains the
>> same functionality as the original code.
> 
> Thanks.
> 
>>   MAINTAINERS           |   2 +
>>   mm/Makefile           |   2 +-
>>   mm/hugetlb.c          | 852 +-----------------------------------------
>>   mm/hugetlb_internal.h | 113 ++++++
>>   mm/hugetlb_sysctl.c   | 133 +++++++
>>   mm/hugetlb_sysfs.c    | 629 +++++++++++++++++++++++++++++++
>>   6 files changed, 887 insertions(+), 844 deletions(-)
>>   create mode 100644 mm/hugetlb_internal.h
>>   create mode 100644 mm/hugetlb_sysctl.c
>>   create mode 100644 mm/hugetlb_sysfs.c
> 
> Seems a reasonable thing to do, although those who work on this code
> should have the final call.

If we limit the move to the core sysctl+sysfs code, leaving most of the 
actual logic in hugetlb.c, I assume there won't be too many conflicts in 
the near future.

Hoping for some comments from the hugetlb maintainers.

-- 
Cheers

David


