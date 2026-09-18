Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B9CAC982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 13:59:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB54A6B0096; Fri, 18 Sep 2026 09:59:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A65CB6B0098; Fri, 18 Sep 2026 09:59:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 930166B0099; Fri, 18 Sep 2026 09:59:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 632686B0096
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:59:43 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E1555806D7
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:59:42 +0000 (UTC)
X-FDA: 85227041004.28.38257A1
Received: from mail-qv2-f43.google.com (mail-qv2-f43.google.com [74.125.230.171])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2356B40002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:59:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=mWohUwbu;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.171 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789739981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FSS2u3Aow+SobxUjbVcIwPVLjVRkiJichXhPV/h32Jg=;
	b=fOD8OfyD6L3MbtDVl1V6+VT4w89UdQAODIva6fH7BNpph33i4ZPaTLiKM0tfhmSS1CBgi/
	0TwbVNvcyEpNysW1Sg+rrVzIc2lBtY3bRA6UiYQSZqt1Y7eimJcflQ5j0ST4Cj5wRpMlgj
	w6otXGqxbNTxJRUNQsIQZk3O6Pij2V4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789739981;
	b=kqWH2G3ABzAxJpO4my+m/f7LqF/JlVrAugjzBsbMiGRsu7tCnSNJ/OteUwmbD6LLd18guX
	zWVBl0vJiz+EU8SBKNecNUL7P1oNIyaN/XVsXDWBYxQE2/bSEBbHQ49giDQWKpugNxCXDX
	mfcpT3uOsZtDg+VjC1o66k38n6yQWqw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=mWohUwbu;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.171 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qv2-f43.google.com with SMTP id 6a1803df08f44-912408b2b2dso7580876d6.2
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789739980; x=1790344780; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FSS2u3Aow+SobxUjbVcIwPVLjVRkiJichXhPV/h32Jg=;
        b=mWohUwbuMw0oln8g4avJiLlXtt/PAJQ7l+fG3bLjN4ZRn9Xeutb7QCKoGPlkgY0M2z
         Xz/4Hatyb2TUnApWdGrs7onzg4JoTIZF6gLKJ/dzJwVWAK1tqCAnv6HqvR/us2azCiSp
         BBGntAw4ULJt+/8sDlog/Tp4BNsrt43AWtC4EvZPkT7J8vLIBfwHkTesEJK6oCHzGOfW
         xq/B7SVViRyZRZQ2nJAob7d3buQP6ZnHQZUxzc5vOQWnrOeoMDP/VgD2XfPUw+N8w4+8
         oGQvrtDi3Ja6E8rSmKz0sWm7vFM4onvEATBLV1eFqFPfMl3xjBLFG5AQ8n39/F2Jf0xt
         SaYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789739980; x=1790344780;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FSS2u3Aow+SobxUjbVcIwPVLjVRkiJichXhPV/h32Jg=;
        b=P2HnnIEE2ZihjR/iPcDyVEi8Dz1mXbRqKtupiD1uG6q0y3y1PKIR9XCPhRtX39oiJe
         9ceyN6aNs8SPqGIkxCE8Ng87o+NuusTK0RHIW91kLIIYzA7SvLT8U9pW7o0mpW+IErIE
         Jvb0DUweNYWoZIvU4Bi/XkuYx7EPhLmWbSYAqbfFQVXMtUc9a8J0OnjOn9uUZBrFjwiZ
         7AwZORyENtWG+t4SfZG5bThS5n8G2OL68ON8AoLCZaUvOWo8J8HnUfFhOJhcagwQbDzY
         8nDW1oN0+QwR4wQl2S5kiLYxvUWEyXT+/1j2cBjVfLn6MVevy6vXML9flIqqD8BvUzaj
         uGmA==
X-Gm-Message-State: AFuF++njnN5vjAw0Lwg3bSYbUb4JyxYlB9C5IjBH0my9hHW4OMCfZIv6
	ccv1UjUQ7SmWjX7Iso7GVBetnIJM5wuwDun/GfjIicfv+RX0D3d1OMq3atfslt5uTYs=
X-Gm-Gg: AYBFou34ijDlOTNVnzJn0z7UIwE9K0KSL4owQIgtIDtqVNTid+OuBnEgmlj0TKriHEA
	oBqeU3TXjTAvF2VClHe0S0XdxvOsKPMBDUpnNdMj8+vrALZtPoSYRXI0CE6mqUnTow0qLxKVzfA
	8Jqa/D1+1gSV3hw2/FvTLzC9HKzV3XznCKrN3QSlPUdpxiOGsXPe3rVKuHwqcQMS8ueCySOGoOy
	2OuzfNZeyoHG9CTHqvn2n7NiUH/T09+xarjr8vaKyY3eqw9meUWmXYoJXHrYNNwguv0Qyysq5Ou
	RlkzYrNRCzv5DmzIR3YFhZ4eGpTbbH5uuBpvrOQpqqLu/WyOaWRqBqyO+M/ksSUey5hYVXHfp0u
	u+MJi2uYIctQtq3r1Lc0yIzrfabMwAFeVtyT48cwj2qyj6ea8OEtlxqbHQpCEgfF9p7EZPbvEaY
	qws7LOdRLedctfb/iwPkib14ttPss2hd1u+bz2z2xy5ctylvEwGr9z+AoEDENpp1XAzkyEbySKz
	ctFTUJmZcxrci/D3LLZd46XjCOY8GhjCstLTz79DTMt0TMxyi/HnzE=
X-Received: by 2002:a05:620a:8909:b0:933:aa0:bb83 with SMTP id af79cd13be357-93bdc747954mr358888885a.34.1789739980266;
        Fri, 18 Sep 2026 06:59:40 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93be0e508a2sm143621485a.11.2026.09.18.06.59.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 06:59:39 -0700 (PDT)
Date: Fri, 18 Sep 2026 09:59:37 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, mingo@redhat.com, 
	peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, 
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, 
	vschneid@redhat.com, kprateek.nayak@amd.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev, kas@kernel.org, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, jannh@google.com, pfalcato@suse.de, 
	osalvador@suse.de, hannes@cmpxchg.org, raghavendra.kt@amd.com, 
	stable@vger.kernel.org
Subject: Re: [PATCH v2 4/4] sched/numa: do not let VMA PID activity gate
 promotion
Message-ID: <aq1DQfuI2XPJQ54f@gourry-fedora-PF4VCD3F>
References: <20260911001826.2109390-1-gourry@gourry.net>
 <20260911001826.2109390-5-gourry@gourry.net>
 <e2695249-ea36-4a4e-a5ba-22bb5f7299d6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2695249-ea36-4a4e-a5ba-22bb5f7299d6@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2356B40002
X-Stat-Signature: bhnduyykqzj6fb3dhf737bfht6bidpaj
X-HE-Tag: 1789739980-328718
X-HE-Meta: U2FsdGVkX1+98MPnluozka6sxW8V1cExv/LQNS1qkyVavEq2Q6XJCZLj6aodMEntPc4YRGp9tNkR4pP8+faOoj0k2WRjfAvHkz3sIGOLmxdy/Pc2V7z0f1KbjISZM2LZp4alTl87A86fTXVgx13Na1iI8biEHJni5fcfok7SqSrxfmBiXRcgEw9Tu7BpxdPIy2R4pwDeBtb32LYkxO+0HzUkvOa002+i8Zjj6gAfTInMljF5yrDuStTs2OZ4T37/hBuqFvdzTSrgK3nO/M21YrrgETVl9mrlGR1EWIpw2r5TgZTyB9a9cYyLPBvcSnALYIzqALzYRC1WGMF/DSsyjmrhTDO9aw2s78V1iL3fX8IIpimnd6t0smEwM2PZWRjM6c3PRIw/uJRahs0z/kAfFMlY46/dATLeQyXHxNSVpoLqndHQ6+ulP4Qak5HthZMV5djE5grNVgnP8NlTYzDyyYTA2XGwMMbwZsru4QhiygHb4sfRfY/8WkXUxV1tDlIRDO13qwQQbCTgC1UlY8R09ezV2UMCZ/sN44MQoGSRsm/Tk5JTY5b/MrAcT6Fb0vbsAIicKVhnxPmzZ46FWsbYUDNmwvcZuzPVd3VJe/Cet3fFJNdy5V8aLzNCd8G6abNePibeHq85CjVWJpEw+GOm+n7wwcbF9I4eAgjJrGslJ40bCosDMVKfblTcyN8jxGDdsc3Y8Ba9/f7XBdkIcvCrgn9YSMvGiwA8AltTWh/5pXiL50mBs5rnOwmN91TI3KgLZ1lygLhYl23DmdaV8aONsld3uY7sUh7iFH/m4dx2Th2W1wW5gbtL68i5cJc/HPgcfF0NU+Qlar4mb0Og14JpAoPtAor/N+FNqQGQ+gzJdZvXSMT1LltSg7dhrjFg90C5XBRABl8+U3tM3Fmj8fZO0FScuLvUXkcMGK/FJEHRmv0BxykL4Zm7aeNGKgNxFBvU2soGsia+v3vY4EvhC4E
 Gi7jrq3y
 HvdOViq6pvGtfIfuo75dI6hPHK/tDZ+Rjln9MitLK3rvIBiaYxekjavW9aLk/U/oJ+5C7hOoxe3UCUaj34IFljlA41tI3vhbiZ4ZEHXNh/nqyCy5/Gjb37+5XhxYzl+Nit1XhRRgkubi4/LkDKFkKtLGdYK8hr7BqAwMVjUQbI5JXUtRupn3BCe9B3RnbPQ6A4/w2NkK3FoL6ocwa3oHQIgzH4HQAECfUytJq24aGXVS0GAiISr4mUS1sjT+Ieq5QnB5e+KEAjTvDGjUZ1he1oA4l0Dy/dsDILUdbtLnMVX99WVnkbwfFvxpe/X6qvpsh2jchSifYmnPubxXIHjuKAiu2eX3yyCde+nvWp3llWhycmNSZHpTUY/l8bKDJyLj5UMIB2Ui7ORbGAp+0TCy2o8ZB7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 03:01:34PM +0200, David Hildenbrand (Arm) wrote:
> > -		/* VMA scan is complete, do not scan until next sequence. */
> > +		/*
> > +		 * VMA scan is complete, do not scan until next sequence.  A
> > +		 * promotion-only scan reached the end of the VMA but did not
> > +		 * sample placement, so it does not count towards the starvation
> > +		 * horizon in vma_is_accessed().
> > +		 */
> >  		vma->numab_state->prev_scan_seq = mm->numa_scan_seq;
> > +		if (!promo_only)
> > +			vma->numab_state->prev_placement_scan_seq = mm->numa_scan_seq;
> 
> 
> This is all rather ... messy. I mean, just look at that promo_only() computation ...
> 
> There must be a cleaner way ;)

I tried 3 or 4 different ways, this is the least ugly thing I could come
up with :\

The scan sequence thing is particularly confusing, and numab=3 mode
(NORMAL|TIERING) makes trying to reason about this whole thing really
painful.

I can see about making it at least a bit easier on the eyes.

~Gregory

