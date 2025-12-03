Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE818D1266D
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 09:02:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58E7D8D0003; Wed,  3 Dec 2025 04:02:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53F388D0001; Wed,  3 Dec 2025 04:02:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 455A58D0003; Wed,  3 Dec 2025 04:02:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 30CA98D0001
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 04:02:26 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D460651931
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 09:02:25 +0000 (UTC)
X-FDA: 84177568650.16.702C35A
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf28.hostedemail.com (Postfix) with ESMTP id E974DC0019
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 09:02:23 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=YKnhNKIY;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764752543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4saF+51MpcMqreRhfl2CsLn54xRQyLgAhIk0DIIYoNw=;
	b=EAg5MerfSI9Lv/ozlNrbUZ59I6MUyMSmoJ0YoYV11V6T+MitTioqE5G9dl4kAkGFW6c/A2
	5nsqqX9kWSTzRdG/RP77HdMYLcq5mAR2dtsgQOmvRyLrfObJ1hK+bjNv0D/Yb2qiHPEJ22
	Cyp6kmw9850+hfsRD+p5gAd/uM4eAG0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764752544; a=rsa-sha256;
	cv=none;
	b=o2yMvw9xbe6Q8lng5RUJ++e+1Ise9XnsXULsV6HkrByGRl04Itinj+RoV4WutOciI0Q7pz
	WQ2h8RPELOBzIbnGtr/qc709i7mx5ZtJrE73D/dsT3BfitqvUU4DudWFOSzNFu8+CBd0Ah
	X1J938s7MGROdFCj9v8EAdNFE0yUlB0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=YKnhNKIY;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8b2e530a748so555664985a.0
        for <linux-mm@kvack.org>; Wed, 03 Dec 2025 01:02:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1764752543; x=1765357343; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4saF+51MpcMqreRhfl2CsLn54xRQyLgAhIk0DIIYoNw=;
        b=YKnhNKIYqRwP7PWQC3yG9Bht/ITt4JKD2558bb+/WRQ0bKtpIiFTIfPYeFcYCLnRWv
         ttBXvQYZjTbMFZ7A2tMChAa5kAeEe/ArlZNFwTDZ2eqEETBHMqmYcF7zCEdGIT6cERyW
         6NNErOGyYwpV/0WZazNb/qE2zjkqmStJj/l2TO1kY4ZIIVJPUjppxeUXq8KEhF+tB7Ix
         txLwEB7fCCJ4a9Pm1Rg1ktS4u8xSA72/07Q3vh51/fl6t0k85KLr/yoKIMLeTb4YSiNv
         7eEPqhk6xDpeEXTU1LKpnrpDxovye7tSD701rUs1LsdBA7lzWZnNxCS8rkzVQ8oHxOk1
         cRnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764752543; x=1765357343;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4saF+51MpcMqreRhfl2CsLn54xRQyLgAhIk0DIIYoNw=;
        b=WnvOoP3dibp9wru9JEyDHdHwP2MzPsxO29TZUUcU/vAqwmNslSlo8Xvg4vm712nkRX
         3A103x3TcRE5E49CwrVFBVxQYPC+sEdi7s0HtLHRzQMfuZl9/rFOur7sanq/zqW8D+Md
         5IIfNlAtNwUrRbMWe2eRFvJX+2IjoZklQlr019XNDmo5lB2/6VYFJaTlFxvQBLzHj6Wy
         Q2RkwdzMpziR8WazIK++pqATdxlFNjTyW6Br3a9fn4Oeo8zTvwe9JzBnXUPb+7tTrG1Y
         NU2mVKU4UXOOwzGUUJU+TaK0lbXbB5cE2WYtvWhMWQ8eYp6xxs57HLD2c9ow4BK9tMLX
         cxug==
X-Forwarded-Encrypted: i=1; AJvYcCW/dbwU8dBaHPpqyp02agc5kyyzumzkYB8YXkox3QW5gmAKezae+B0S0qACyFeqxp3SfLzjz2laDQ==@kvack.org
X-Gm-Message-State: AOJu0YzZwMsEDwS+zpQf5Sc9Y8gBnB+rzdRrMXH5ui9DNoscqMbppwvv
	dLUABrUCxlMgEGS0vc53XmKNXbs70zKVoM/cetFujqw5kacOpCgvehRiX39en7qGwmLb+VBck8j
	q2q46
X-Gm-Gg: ASbGncuiJBcwGX17TS93Tz75FAKkIpsjOmiTLnrDfF2kAyx1kf7kBkJnyigw5nGMWbJ
	9bSw3Q1lSvpSjntS4Qai6Tj8sccy2rUaRbAbDNScc9ozzdh2cmebc5zcgk0W0NX5jmZEY3XCjHq
	XflH/jpYJ7LPJXdokZXvjK7geI//KP0KG9mATtITUKPoNLC84TwvBC83UsFlGYd8dW+zCIYLQcj
	tWeubvpJs5PMgwGzrwiFRjPnrFE45j9FV5DCt42XGSpKBKQONwC9hxi46XV2FQU3YheiEAcMq1S
	vGSx/sVFJtVcAYKKWA3pA9J19c6U6ooAXuEaofOWd/jKtpNGWOwAwr1ZIcFrc9uI3BO2x3b3kKA
	AjB5UHHOKHDPVz3IfVnERluQu/qZu9/qbJWtsARvF8H6HBZufFwbE+A+Pw1z84VaXJUzDgpbNG5
	dAIVGZLf70g2XQaFFyBuy+soGuZ03XHG2dr7SZHhpOxsbjUyOAmV+0DR1/+e6fI421gDrpsA==
X-Google-Smtp-Source: AGHT+IGTm2nWUY9JPc6rZPyJWuZPb39lBOWDSCMEk0hxE/la6Ur82Jbp5YL+S/PQyNYLAP6umf5wkQ==
X-Received: by 2002:a05:620a:372c:b0:8a7:2373:1c75 with SMTP id af79cd13be357-8b5e6c924f1mr186372385a.49.1764752543119;
        Wed, 03 Dec 2025 01:02:23 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b52a1b759esm1283219685a.31.2025.12.03.01.02.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 01:02:22 -0800 (PST)
Date: Wed, 3 Dec 2025 04:02:21 -0500
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>, vbabka@suse.cz,
	surenb@google.com, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Oscar Salvador <OSalvador@suse.com>
Subject: Re: [PATCH] mm/page_alloc: make percpu_pagelist_high_fraction reads
 lock-free
Message-ID: <aS_8ndgdVbffPYGN@gourry-fedora-PF4VCD3F>
References: <20251201060009.1420792-1-aboorvad@linux.ibm.com>
 <20251201094112.07eb1e588b6da2ee70c4641d@linux-foundation.org>
 <aS_0bgCs2qE0y1bJ@tiehlicka>
 <aS_2Z6ROtrxLQcRN@gourry-fedora-PF4VCD3F>
 <aS_4E2H5aJmSvWF7@tiehlicka>
 <47a8b4d5-f4d2-4772-b1b2-ee96bc21e742@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47a8b4d5-f4d2-4772-b1b2-ee96bc21e742@kernel.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E974DC0019
X-Stat-Signature: wfocxk9h94qywy8digr57uo4wksapshe
X-Rspam-User: 
X-HE-Tag: 1764752543-91305
X-HE-Meta: U2FsdGVkX18nMb1jpq8Gd7zCJYWXLBfsZ6wi7BRasipQWIkLVtXAS3d1BqimHGkV0oMAkT7sAh+jXwfVmi15IPIsaYRhRhxfN0UaYu4DHNs298V/d93vz3wvTmwzuqaH8NHPioZRWwR52bV8bMR6r1vNvKCMsfqPzAi5l1S/u/D1l3CGz9ryymGV8sxthJAKxIrNBe/4A7ElbhbHwjUq6dAGyATbuZzl3NzrlJtidl7amw0t23c2sQBsdhK6N60MR2VN97TAozWrrnAEFdXtVwNcCYxqtwbm6yEyH2PJmqkcySbsFtjysj0TW/kUHZcPtoKOufaegc3JONpjID2Ph9luBt2yYUK5bZvBS3UYe8uWBfDZFTv5pdGEnlTRAPoi1EpaMTGiY49sQcfB79rLAMRrR2KOmVF5Gs1/qMb2uQ4GBS6uSb9cG6J29Fqn3GPWbMwvmKnA2Tz7MHySc9VFcCEMWGrDF4TOzgMjFlQlDjFHm5+NABXCm+kaMYe6wtkNi/fP6Q7S/t7mKK3n/bj7Eg+tLDHGEhTVoRJpX6J+cHTTtGDAeETPV3eW1ZsW6Cq9VkK+n7pFPg7tA4tg48WEmdSyskeupfpikHLASDyqO/ZwC1Ikv9vPzNAT9mDqqoigviOKuOKqpi2BgUvGOLAlKy2I/Yd/igLz2zuQznL6G/CS3gtsLZAhAJt6phEz/Ru3SwwSbvTSwxAzS6rp4WQvmg050rDPpr/+r1Yi/O2SyPgCN4lh4fwPfxirlI8oZbon44d2osMTy79zr1D/oMNjvLI7efxNgCHBwugI75R69lxU7d8kzZRnbM3QCgDKJd/mdMxFwUgITE96o0TVouYZYLH1qNGoJY2GkvJvr48+g89Je/9wAh+EaMrAS67kavXsr/nOPWq4cY+ASFg+J7Uqrdz43d3gDR/KLFCTGuI0J975+jiNderxNd7abhh8GZ3TFeDv6LmMUJgYh4l++R4
 0YqsRDAE
 RCcXqOySUrAu0gkXy+p0Oto/+Qkln0ecRQtZnmjeC1SI9pzmoSH+TwL3puOGKccTGC1Sy+ZkrW63ppvQ+be6GvY26wx+42gWd11dunJpEST0i6l9NKoOja3fAaTVsZgYDlwNGmZ4YtPvu7P/gc1qpd2MfsRztgtkoP+OqmYDBI9wAEQWvAOVu0CS5+jpFLExkPVe8q80/L4rZjrg7hf391oIWmZLnKD6HVBxDgekj4JHQdPjxIttQloDXbTgp71Vdn+CXyE2Cntq8BW6aP/SLO5pRYYjgr0/cej62osPdLGOvAAiBo7szIkamCK3OdC2hcN4kwjz2U74V4w3O0xQNS65T4R73L1/8XooMWjMIaSjgzdCjq8Bj5MSkRA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 03, 2025 at 09:51:52AM +0100, David Hildenbrand (Red Hat) wrote:
> On 12/3/25 09:42, Michal Hocko wrote:
> > > 		if (!ret) {
> > > 			/*
> > > 			 * TODO: fatal migration failures should bail
> > > 			 * out
> > > 			 */
> > > 			do_migrate_range(pfn, end_pfn);
> > > 		}
> > > ...
> > > 
> > > Maybe it's time to implement the bail out?
> > 
> > That would be great but can we tell transient from permanent migration
> > failures? Maybe long term pins could be treated as permanent failure.
> 
> Did we try offline a ZONE_MOVABLE block or a ZONE_NORMAL block? In case of
> ZONE_MOABLE, bailing out is not really the right thing to do.
> 

My transient failure (although i'm not sure it was actually transient, i
killed it and retried after a few minutes and it succeeded immediately)
was on a ZONE_MOVABLE block.

Kind of suggested to me there was some bad condition the resolved once I
took a second to release the lock and try again.

Can't speak for Aboorva's situation.

~Gregory

