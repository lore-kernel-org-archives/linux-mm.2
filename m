Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC881C531F8
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 16:53:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC0BD6B007B; Thu, 23 Jul 2026 12:53:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D97FE6B0088; Thu, 23 Jul 2026 12:53:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C899C6B008A; Thu, 23 Jul 2026 12:53:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9DB6B6B007B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 12:53:16 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1FAC8C059C
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 16:53:16 +0000 (UTC)
X-FDA: 85020636792.14.EFC3B55
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4DDAD140004
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 16:53:14 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=uAe4MPpu;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.51 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784825594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bqVE/c/eX9E/Cy6wFBhLLV7HBSbIhrEkmRJZ6Osn4Tc=;
	b=aWg0jhUd2yXwBAd2XexS+lrItOyhW1zrK2+xIMuCs1rTE0nG5lRV9nRkHnK9x2tunP5TNE
	Q4XMtzwhjIuwGuw84BMBNZnppalzwN7kYvHhAW5Q3FlVLRyA/yGQHoiyGvmfUvqAMpiqwO
	IW+E2Dh856oargiU6Hrs2KRCBFSTFHg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784825594;
	b=id9wm5El9m+Hbveh+EFV2K0aH44E9jyuWVWcu8FJYe1VwBHZcvj4NjgUG+axAIdIqPkOYo
	ju0IxGL8TOf3FAjyFdFlS5R/1dQ2YgeQHAePpVAtTznkHrHfEdaQqh7sZr/F4NDpkVeYtX
	Hfyzm1kwrQaLPEjYbTBrVvh77NodfK8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=uAe4MPpu;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.51 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-902e4af2d9dso7928986d6.0
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 09:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784825593; x=1785430393; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bqVE/c/eX9E/Cy6wFBhLLV7HBSbIhrEkmRJZ6Osn4Tc=;
        b=uAe4MPpul9f6e41DzNYNsBPSyuCqnG4f8pnS4wrX9dcROUVF4TeacX59VxWlrrTfnN
         t9d9wmglk5+K+9Wd158DOK1C+G+oYY+/n8BBxTHF0mjV8S4JuaWayx0kxFGojfQNPZvo
         rwu35WM3tqabOpQC7Zn3g/CvcvJfBeCAtawoT2oqgTc8dxrC3UIgXSLLUyTqFN8tnWQG
         aeEfzF0yhvypnV4SLzl4T7Af8WMKgE9NEfEh2uPIGgn9KqoZxFkeD+euTzErqxKB1a1Z
         Hg8H1uGDBzO9sryj19c4xqkMDJIsNwjAxeA0U7uRRm4V8WmMW+uPOCD9MvPRcUn1cGL/
         qVwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784825593; x=1785430393;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bqVE/c/eX9E/Cy6wFBhLLV7HBSbIhrEkmRJZ6Osn4Tc=;
        b=aAh9roYmKJ4gwkedNbl822pGZoDobcrT5M2+9kHFP56b4IGCvlUMGQzIO/kODd7r1h
         /O9/1/2M98dVacB03KMF1pFlGtykaR8yZI5T67RajYqURJzHKmr2t33z5ZX4tmekfhae
         ny6wgvYkjzJjMa89WkQnBPzZWNCjokgxKBethyn4drE6kXmZma6rLiv28qRgg0urLh14
         44ih7V96A09qDI7pmu1GtPQPooBaDnKIzrAKfa0wGPCBWFsJwTEgzSq9I7oJ2SdzTAK0
         3GhjIQYe3QQphD+dUqhsZexBv21c4Ui6RsJpGKvuoaog5ViTmm/EGMOh0MZ/qyYAwOQB
         JeOg==
X-Gm-Message-State: AOJu0Yz0lMler5bVnjD2OHsJ609hud1j9xuXXTihQdUw9CebmMpcVWXs
	j9ra0hAWhEIColSwTSsPuyulVBvC11o/PfyVSazOJWHvGdtardq3itlC16SMDFqlDbU=
X-Gm-Gg: AR+sD121GXXnj7CbFywKZioSGWWjFWd0QSEhOd1UHy9/lIt8mG9INzaeGbM8WvSb22S
	L+vWwORP9zQftFYxxWoYr72pSSIFP9wsmosIU+ppCCzBrxdvTvx6XuB2EIBIXLeD4kzwvexezSV
	MA/gDsBdtRWuBBGiZ6Ofab4TVdGMZkgBDHcCR4I1siUWUn+M6za15FSognOVliaTZF5ppE5LZ60
	4djYSRJ+N63NGLMrKpvsWUy27TPSdMSMdUwOtSz/hORhSzi2RjMCQE8PH2D4C03hD9E8hyGdwge
	jOb4ejeq8ODT0FJzuGiCmWIAyYktnmc8TDmHTqdc4tgzmQpQ4mSVkpx5BCJTmn6qgpIF5kSiLe8
	kOjHIdqCo6aranRw58FB+ZFyhjc0BukpGje4p1LabUrDdypXtwCD45w5jUgFPw2nREkMhItY5S/
	gUi4dJ6jjYI0c79dLmu2s0C6+TRSjf6pj8Fk4P5+Xvn4F65laLz0LDapQcmA==
X-Received: by 2002:a05:620a:1729:b0:930:9533:5e32 with SMTP id af79cd13be357-9310468af9emr366578785a.7.1784825593202;
        Thu, 23 Jul 2026 09:53:13 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907ba9e18d4sm48785446d6.23.2026.07.23.09.53.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 09:53:12 -0700 (PDT)
Date: Thu, 23 Jul 2026 12:53:06 -0400
From: Gregory Price <gourry@gourry.net>
To: Arun George/Arun George <arun.george@samsung.com>
Cc: linux-mm@kvack.org, Zhigang.Luo@amd.com, balbirs@nvidia.com, 
	brendan.jackman@linux.dev, yuzenghui@huawei.com, apopple@nvidia.com, alucerop@amd.com, 
	matthew.brost@intel.com, akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org, 
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org, djbw@kernel.org, 
	vishal.l.verma@intel.com, dave.jiang@intel.com, alison.schofield@intel.com, 
	osandov@osandov.com, jannh@google.com, pfalcato@suse.de, jackmanb@google.com, 
	hannes@cmpxchg.org, ziy@nvidia.com, pbonzini@redhat.com, osalvador@suse.de, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com, 
	linux@rasmusvillemoes.dk, longman@redhat.com, ridong.chen@linux.dev, tj@kernel.org, 
	mkoutny@suse.com, sj@kernel.org, jgg@ziepe.ca, jhubbard@nvidia.com, 
	peterx@redhat.com, baolin.wang@linux.alibaba.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev, usama.arif@linux.dev, 
	xu.xin16@zte.com.cn, chengming.zhou@linux.dev, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	driver-core@lists.linux.dev, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-debuggers@vger.kernel.org, linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev, linux-kselftest@vger.kernel.org, 
	kernel-team@meta.com, cpgs@samsung.com
Subject: Re: [PATCH v5 00/36] Private Memory NUMA Nodes
Message-ID: <amJGUuBZ2857QjDB@gourry-fedora-PF4VCD3F>
References: <CGME20260720193443epcas5p167fa7d8490edfb4d8c0aa6a259db058f@epcas5p1.samsung.com>
 <20260720193431.3841992-1-gourry@gourry.net>
 <963815509.21784796303385.JavaMail.epsvc@epcpadp1new>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <963815509.21784796303385.JavaMail.epsvc@epcpadp1new>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4DDAD140004
X-Stat-Signature: ep574bz33oixt7saqgy6cfbippuwtda5
X-HE-Tag: 1784825594-997688
X-HE-Meta: U2FsdGVkX1+kGtet9KUUXRzYv3OOiQTOO5c73JzwCokyXhAH2TUjFsfPGfpt5fR9TxkPy1SERijuZkVxA76GSF5RVU8c0bT49sYZqaq3b4XU/cah7co8ff33FnGiAH5QXGPgMeIGLZ7+pullKZppP2teI6T24Cs7TnH7gPIhaE2gPkxaKkZ7q0zZGbfu2WPDwY/kI31GzFh3fS7iRTe7+zrh8QTMlmfLBxwolf7IIqAiB9qsF2aaTkBWsqRiMpoQONP/ZIo5btWZvHVt1xDIwa8X64eiRClmr8co5qCZydVFNdTjVvRJw3CXQg6JEakyvDbXKKzJMv+/OLjtt9cYToFv1MJZKaFYZuMKuG96msXKSRO+FtQ3QmIQ+arjkWZKYJqDTFJZTjI4qzlidn3ciTIUiAl/0EfXrkCWTE26DsHw4uHIBZ/oRxnfey1luj2jCexTDBe2sPzaFWqfSA39DKiHN1zjQi6Xr4K0Wj6YK1VZNdqqmVXazDbz4ApnQF7DZDE/tam5iyKEn33/mvQeN7teAtYMCTEB9MSwtR1sGq8zoDSY5k2cfy6FBrlAfiOs96u8AmcA3ZNmBvwWld3e9yd/sfY5EGqJNYr81l8hdxPZAJ/U5WPaHoxdqZtNqx/t2PL/fpkNLw9CpRWMK4l5rlJWL7LrnlDURAU/MkLpBKLdty38BQfvD20CzQm9lliHQQELTtVcP0PtAl6MN5Z8i9TZJD2E+25zyK5XMeSN7XXr3vashCJHjGRWd/DIlOCpgXvJkA9LTojY9FauYrMKGBizVAzUmkO3JigE46dl4QxKTKD8R4Ie4izy3prlPaVJW+A3Oziqj8GFkjgJHYiBtqqzN6Dw0bz83mS98mqWbHvcRaUlwx36uhlM8DplNGBsCX0XUx/yqOrIN6sUuTuWLF1Cm42rpoTtjyIiX4+tLzoWeuO4+4KNkvmjGL2qgtU77KLiql6024TqY92LPbY
 2aXRbhwG
 utnYvcP+Ogf2GNM7P4CggPwCVBwAhW5sAF7U4t9K+Vfv1g1vtgZhdtq7dmrOr/Hs3FuW8Bk1bC8Y8qbK6FDCwub6DhRf7RXzwLCv3Pm5opWdkyHAMCs61vJJOjDmAFX1QV4eiaeq1AvsVgbb02W7TjoEkfHN3pPKkqK6OoaM4lrRjgg6sz+BMQMT2IxpSlj8uWhrOkZ7UfebnYczavltTjbuU+tqqgO+yOyfy/ixl5MQ55Ocx6ONwxpYtR1HmatKBo7JBwFKBy65aYUtCCk7V2fli31cKl6GnYyrBusk6A7JPY3/2mj8HOZ0P98295mX8QQwJHQwnzYkHmnou7WQ+AVfv3yGhuapfocReWjS0tssVBBkNplIyR24SFjxyCiBMoDBVsLyHkMhgsjKunIz1JD0AlA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 02:08:31PM +0530, Arun George/Arun George wrote:
> On 21-07-2026 01:03 am, Gregory Price wrote:
> > Changes Since V4
> > ================
> >   - dropped compressed ram example from series
> >       - will submit separately if this moves forward
> 
> We intend to test this series on a compression capable CXL expander 
> hardware. Since compressed ram example (cram) is not part of this 
> series, how do you suggest to do that? Do you have a version of cram 
> module compatible with this series?
> 
> ~Arun

Hi Arun,

I dropped it from the base series because i want to try to move forward
with this without RFC.  The compressed service itself will be a separate
submission after I get decent signal on whether this will be accepted.

I plan to RFC the new setup for compressed ram this a bit later, but I
will share my working branch with you for testing.

~Gregory

