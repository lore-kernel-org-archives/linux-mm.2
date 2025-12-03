Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22219D1266D
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 08:59:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69C9A6B002A; Wed,  3 Dec 2025 03:59:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 623756B002B; Wed,  3 Dec 2025 03:59:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 515196B002D; Wed,  3 Dec 2025 03:59:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3BDF26B002A
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 03:59:55 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D83BB132F63
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 08:59:54 +0000 (UTC)
X-FDA: 84177562308.08.6C93684
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf13.hostedemail.com (Postfix) with ESMTP id 07FD620006
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 08:59:52 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=cK9udqvN;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764752393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XsIHq6UBLDlwXTSMYyxxp+mXyQjlAZhBo3spwGooV9M=;
	b=w9FCWDVna8OrvnUXUItt0KMzJt56RGiATa76gql3PQ0AtK+Gtnnz7+SN1Uz+FpCYGF+viX
	TbBc4zCLKd4ESgBL43+7jibExVKl/futW1XYNpJoSC58yAqx3I/Oqq7OdyvNObmXWoPJqY
	lj5Wydw5Bz7okPqwx4PlxAUNZ2yQeXU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=cK9udqvN;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764752393; a=rsa-sha256;
	cv=none;
	b=2NqVBTa7dVvw6GyBWaEht2Fw3lCzz5wvKM2DlaG0fAb4Pq7qiJCkHcNdWyrdb6qGX15ToW
	Feq5RjhOIWxO4t4EDiC5KLSlAaesSvZzvMaHLsuGMLNvmS1jZFPEOVIrJNEY0xNZT5BC7L
	60SxgXGINE80SfKeG3EfcAjf4yPvPgA=
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-8b0f54370ecso610460185a.2
        for <linux-mm@kvack.org>; Wed, 03 Dec 2025 00:59:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1764752392; x=1765357192; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XsIHq6UBLDlwXTSMYyxxp+mXyQjlAZhBo3spwGooV9M=;
        b=cK9udqvNsvZkbXfFdyiQZ7XLm2YpIXSnzi5bq/q4rsCvNGe1XjV9i2eoxH11qU0Pfo
         IoyohbLc1a6LU6ZymPFR3VD0xJosBafE9ILQ+E2T6uGMy2bYWLf+xgxcWB4qO6c5Md2O
         ieiIz6prG21EnnzqYkN7GlxGa7r3PQh42cjjwwv32cKAKcELcsYcoVdgJUV74PyOUh/b
         Lrroq+DDXnNte9XTbKa/2mEvZ0noHlc1soM9FEm7qhoQDGrRj04tLX2d6d2rDZ9xa+uh
         /pL2YFed23Tl+SuaaO2SQPSUgE+Nj8pV4WqUFMR+JFZ4/aHRVEAk+kb2plDviFTmKi7u
         29Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764752392; x=1765357192;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XsIHq6UBLDlwXTSMYyxxp+mXyQjlAZhBo3spwGooV9M=;
        b=NtI7sQ0NrE1xf9pRqa1hZIytTWGJSgh5rSLKW/9wNVPFcpgOLRReZb05kiieKfChfd
         7R44ixmOcbxbCPrG5/26HIso4W+bKKx6qQ9zmo8aoAIq3uJN14B1mUhhpd+FK5zg0iaQ
         ubbKnV+WnfQR4NJATn3TDhzWvMvxaLej5aElV5xVv8ExwpCjbEuzXuhQRpME+ENtQoR4
         cdb6xIbcDg8gGiFbESNq3BgiXUnzLju0CEHLDZ3LQ22kThYrSPA/N3d5OLniChQCN8Hq
         OecnZGy3Qwt9mghry0Zk25thAglMHTFvZpo6QzFpfAQyj4ntBDrdRJdq52Br/F0lfUTp
         cELw==
X-Forwarded-Encrypted: i=1; AJvYcCX2n15PAJKLkxJ1RTNWsC5pElQBIL/c0pB1bo4muzFp3U8HdYICr57nN+yfCPVWm381cyh4j4JXqA==@kvack.org
X-Gm-Message-State: AOJu0Ywmlu7PCjDzygC8EO+n+2n6wIf/V/OSVp348owI1SV+kja6xzRD
	KhsgSP+axU/F+79Yz67cS4drN2by+srnR/y+rLJG+gzj21JHbtT83+4ns4xlORNlf0I=
X-Gm-Gg: ASbGncvN75/GRGnyWuuNYAdDE7EC7KxAfk5LUpVOGMtqrEZrHbDGdVxnAT9KM9XDnZB
	8JvEh/3lGCWoqU9zk3g5AxRq2ScEBnPQLpx+JkPKmuzSOfdbxdMvZMOwM+rc40agpn4QnOOBJoh
	6F2caplEQsTlkEnvkIcp1fnybKjhB/V84WvHm8K4uLJzB7n5ACAswYEqQ08b/l9My+n8nGPP2oK
	+hthFJSPY0AmiTn+F0wvVc0kJhu3lJ1w3rX43RZH3fWbF9ylrGJdF3PkhR4c5CDi+yQz+JIL4vk
	SwnWzbFd6OF0kQAseLfbSTa2CIkh70m42coHxF4nvvCKaViRxIfOJC0znbI6BXPnNz9iIjv8bFa
	ft2wES7uRbwLDj3wosCevj8OHb/kQD9gTFO5p8J0HyO700Ua96iUyxGnEs6/4Tcph5dMK2GOVLM
	fRsJVddD+lIDrMidLQcQixzEUqR1+z3qmtdV/HThjwQzI/LmOTKvBaRmrbj/Dn733G2BvOAg==
X-Google-Smtp-Source: AGHT+IF7OCy75trqE4XZK+MiKWwJuAM/GRIvP9U9mo+1pVR/XXb6KYqnQMGq7xdWFJztfAZ87UhXAg==
X-Received: by 2002:a05:620a:1a9c:b0:8b2:e533:66f7 with SMTP id af79cd13be357-8b5e47a6f9fmr210003785a.10.1764752392105;
        Wed, 03 Dec 2025 00:59:52 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b5299a5d48sm1251362685a.12.2025.12.03.00.59.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 00:59:51 -0800 (PST)
Date: Wed, 3 Dec 2025 03:59:50 -0500
From: Gregory Price <gourry@gourry.net>
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>, vbabka@suse.cz,
	surenb@google.com, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Oscar Salvador <OSalvador@suse.com>,
	David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH] mm/page_alloc: make percpu_pagelist_high_fraction reads
 lock-free
Message-ID: <aS_8BgwR3R_geayy@gourry-fedora-PF4VCD3F>
References: <20251201060009.1420792-1-aboorvad@linux.ibm.com>
 <20251201094112.07eb1e588b6da2ee70c4641d@linux-foundation.org>
 <aS_0bgCs2qE0y1bJ@tiehlicka>
 <aS_2Z6ROtrxLQcRN@gourry-fedora-PF4VCD3F>
 <aS_4E2H5aJmSvWF7@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aS_4E2H5aJmSvWF7@tiehlicka>
X-Rspamd-Queue-Id: 07FD620006
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: ujpqyb9rc6cxtuuogjyfyfozznqse5az
X-HE-Tag: 1764752392-344945
X-HE-Meta: U2FsdGVkX1/NLpOZopFhxeLH76SdJAh2Zp/MtSs9DLJnRChwq0hIyhXGOYgFx/m7xS73b1aQi9nEAbjfhKDnFKV3F9ju1dtFNi+XTyYGQWP6JOoNEVOlcQWH2facFaUTqc7S9U1fZ5FauW2NaVCoVdaJKSRcjwLuU4qd1LOyqK86fPySjm+okLkqYswT6+i2OUl5uk/7tYFGKz0N8W9QTW/7oSBtm9mY0T2exPFYE8WkbyUeGtFjYdnAza6MkafjhJk1ZM5pacxG4linYq0de7UbnhbWimaW4bZdFYFTAj7XCPwrXb8oTwyP4/3BuRhAib94hil9K5rg0DFQNTl2uqfrhHbe8jnz/ygt/bDNoS6SWycGC8cmax235Uy4j+AjXWw+/tJKc8KJ3196FK5LwBv/yHPC3jYM+NxN5ISBgNpSnaO5lQFmfsbgxKaXlSPqNBD/NIf92SHp4FHrP6DUStH9Ca8AQpbr5EE+HnVPpyoNG2ienitEk8MmVk9tiWUfLfvGlrovMxegZKZHoAUajpFbQ9HkggNtObdOo6oEuSoviCa5AhpVaMvJNS5fsdQ0aOgAgdS6VJ/PkvzdXdURT0b/bA7m9CA4oaOqB2dB7U6UnYddb+4F0M/2PtsCccfo0p3vyDWKplJL8SSmhywwuCFTcLS+RMkvlDOrjAlUC/mOgvfChH61HC0VPDvfVjguuP1j4ondnraPG0nN2Wnot6y8yoDeXUVFCbv6pwwDb0h58TNaiS/lEkefecrFtyBXgB1GkyYODzDGKTnJ82YJRycpkSR0HMCheD+mVh4pg7o66naWMlYWAL38BGJf4AVMaYwTCfW2aCnqYqXIGkyw/cjm0bt0S5CgV0jZzoPahrs6GopvcZ+TIkqdVGmYW0MVoe/WNd17bfKVY1TS1kkFjKSISAxk9M82ShspZZXzYmktkDVtZCreEzKB3Gt122sCa3ozyjSO7UeJXOfUdz5
 upGBir5k
 XBWwsRSaN0hVr36QPYL+91lMCiWCYYcBu6y1Q3jn7tKIqk3pqSCmronrkd881hz+6fBRgM+FbG8g7sgHti7NOoJpBf0GrUmO1kaqOTXKfp2IqAK8zfDJONIynQds/dmOjKi0LFY0T42yTlmkdvdMBw677lwnIe5tPO1QC6gzlIRIWiZni2ExA1NGPFDRzz/ooSef3kjERQDpRgQAM9AgDuL3ZfH8p+zjvp/kP3fMgd3AMiYLNvvobVtgPlTmij7Rc+9K4qXVvd/EfOjgqA+HVMu5gqeoX0nhbJEu0wtpMzWkYmNpT/W9Zkxhk9AfUj50LF4WyjtWWehM3pM/Nt6AM9PGgR+i94oihYHGdmMHql+LQi0T6CO+1vxK8/g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 03, 2025 at 09:42:59AM +0100, Michal Hocko wrote:
> On Wed 03-12-25 03:35:51, Gregory Price wrote:
> > 		if (!ret) {
> > 			/*
> > 			 * TODO: fatal migration failures should bail
> > 			 * out
> > 			 */
> > 			do_migrate_range(pfn, end_pfn);
> > 		}
> > 
> > Maybe it's time to implement the bail out?
> 
> That would be great but can we tell transient from permanent migration
> failures? Maybe long term pins could be treated as permanent failure.
> 

I see deep in migration code `migrate_pages_batch()` we would return
"Some other failure" as fatal:

	switch(rc) {
	case -ENOMEM:
		...
		/* Note: some long-term pin handing is done here */
		break;
	case -EAGAIN:
		...
		break;
	case 0:
		...
		list_move_tail(&folio->lru, &unmap_folios);
		list_add_tail(&dst->lru, &dst_folios);
		break;
	default:
		/*
		 * Permanent failure (-EBUSY, etc.):
		 * unlike -EAGAIN case, the failed folio is
		 * removed from migration folio list and not
		 * retried in the next outer loop.
		 */
		nr_failed++;
		stats->nr_thp_failed += is_thp;
		stats->nr_failed_pages += nr_pages;
		break;
	}

So at a minimum we could at least check for !(ENOMEM,EAGAIN) I suppose?

It's unclear to me based on this code here how longerm pinning would
return.  Maybe David knows.

~Gregory

