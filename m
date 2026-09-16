Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61B62C982C1
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 16:27:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15B366B0088; Wed, 16 Sep 2026 12:27:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10C2C6B008C; Wed, 16 Sep 2026 12:27:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3D596B0092; Wed, 16 Sep 2026 12:27:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CBB486B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:27:19 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 049F8A07A2
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 16:27:18 +0000 (UTC)
X-FDA: 85220155398.09.896B77A
Received: from mail-qk2-f42.google.com (mail-qk2-f42.google.com [74.125.230.234])
	by imf02.hostedemail.com (Postfix) with ESMTP id 38B2B8000B
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 16:27:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=TNijMdhn;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.234 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789576037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iod3dGEx4O5QNllF/Jv59fKBS+1dGXD0we4CmqbHy1M=;
	b=QywaUgYWdlQwt5WePNsZU+9zl5XE6HteoZve1KWAHa6SltKUYf8Sb5J22hC8rAcZbCWOVP
	kFkeVnirQj/0/3XZasuQXeV3H3kLSifFT4dwaWXWHUTpPNzIdKFOz23EnaQ4F23u1lDoq0
	67CmP1WeX1dm7tN8O3nMpSgGkEvTNVU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789576037;
	b=XsDLonCLd8USg2DCheTOGPSfx4NWZ3EjpwnyzAwFUDB1zWoVGTu/RSU8sPUJky9VqysB6/
	EvUXMQwX7lM5WcQUzBeXNhRG3yJUTuZowBOVZsu0u+4sUvT9fQCFbMo8/ugc+SN62adsY9
	1e2HEF2i0rO3uYFL3FbbzxIFIdvpNC8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=TNijMdhn;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.234 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk2-f42.google.com with SMTP id d75a77b69052e-52fb767cc97so10195491cf.3
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789576036; x=1790180836; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=iod3dGEx4O5QNllF/Jv59fKBS+1dGXD0we4CmqbHy1M=;
        b=TNijMdhntRMk7mSn0zZGEODzWlpKOfp47QR/5wmUxWS9vWlwzHRa2HZGlsWALLpYcn
         aehsSxNwEmDSSFMqp0PwwtbtZs0n0NoVbstum8kXYUfCaBHyQ42HC0OFVJYF1OgGF2yC
         HKsRwDomrp0tjXpCtOsQUDseie00XyCoZpRd5jx6b+y+9GNx1vXKrRpl6X/+oJQ/wS5i
         cCOd115xl8AMDFgqvPz/SqIRJ8kYuiNy/5MedXh/i/CYK5Tma8jBofTd+RZqcIOco3bc
         BWcl//aNw5AFDemGphfP0dffAcJVnFABxptOUuJ7jul0qDxziY35UYewKUrmxGGXHdQv
         07aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789576036; x=1790180836;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iod3dGEx4O5QNllF/Jv59fKBS+1dGXD0we4CmqbHy1M=;
        b=rSyrVHI7BM7w8sxqephtKNIwLhES/Mrteq0eZpbL27z3/9UH5TpCukn7RxnF2QqJBZ
         or8EaSeHfwuY/nDRxXMpSf0FoLUV2yBRB8JOBJCldpz5QIZNOsTatfmcmtWBLjTBGMFU
         7SbRcfNjqEQx9Z91yL6VTHJb+LTpDwiWzi6uiR7UrY4K3qgxqLtlQzcs7NN+CvhCVPwQ
         dKgyhpEv1RceQitROFQb7FUqPDyb1lFf+mpDSyF0FaXFWLjjZZ4TKZ1GkyTn9bhcLN7P
         jaqyKrXwJ3/V2thMqhbTiM6sXbOSvCvxftK09pCrbjx+tfdziK2EkNir3Ln67evJNqnx
         ENUQ==
X-Gm-Message-State: AFuF++keYotr1NbFjuDwHU4cngI8lI388N+aG9baU0gFjs4Y0MzkcfSF
	x+iH7425UR0UN+ibeoRJW9ctmKn/+Dx3wTMjOoAiytTcfUE25ZrRHtbvK6g6Ro4IJYw=
X-Gm-Gg: AYBFou0WvPIuHIMunC/EoX24pZdPjCbqADSUzncoaIHzRo9gdjzXdf0l/YvWgUvXzZT
	IgYoaNDJK00FTqI2b1gXLfP4pLGq6myV/0lZWFmCP3HZwT8vFeptRoTGQv0BTRgkjBIIeLGLBLC
	br3uwcT8Hacp96+UB1szitXV+e/sPM+ZV6Oi4HLg+vLq+/3OEElo9j4CKSbnHEdyxdHVxQsYCEC
	i9XX5rCyZTqKeXhOz+6oMGML+xd5DkQy7/cBoV8SmEdkCtrtGua55cvqBUDB2EG/jh0y/guD7mq
	VFL/VYLGjQdNpQn4Dtrf+zZEgDjt6HkavMGsYQpAgWc6VU/ZSzAb+MyUfldePblnTRbdZccNxbY
	+PGO0FlesETE446PDpOQiFVDRDmhl/zPgozKYEBAFtVa0Lds5wEf3NVtIx/bFnSYqOem2QDbjuf
	myPLan7SY/GdJhOZcd3IbVb6MzExErwsSoPAS9rQpnNPVQB4hwWuTGK0JhfdfczJUSLUBV4Ui0M
	N4aFQimihe6NOaIcWrrC/toz1ymSyX+9U6JbgLhgGs4bJUr2BFzmGGzZHJ93JVJ/Q==
X-Received: by 2002:a05:622a:1e19:b0:530:b2e4:91c3 with SMTP id d75a77b69052e-5327ef19588mr56557701cf.60.1789576036216;
        Wed, 16 Sep 2026 09:27:16 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53262091423sm25381111cf.23.2026.09.16.09.27.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 09:27:15 -0700 (PDT)
Date: Wed, 16 Sep 2026 12:27:13 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, urezki@gmail.com, chenwandun@huawei.com
Subject: Re: [PATCH 2/2] mm/mempolicy: stop copying the nodemask in the
 interleave paths
Message-ID: <aqq_yv-cQvzuxr5D@gourry-fedora-PF4VCD3F>
References: <20260829015943.1258774-1-gourry@gourry.net>
 <20260829015943.1258774-3-gourry@gourry.net>
 <d7f162eb-4214-456c-9d1b-a8623da61b45@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7f162eb-4214-456c-9d1b-a8623da61b45@kernel.org>
X-Stat-Signature: dxcciahg8dmwmps6u185r13iko7y179f
X-Rspam-User: 
X-Rspamd-Queue-Id: 38B2B8000B
X-Rspamd-Server: rspam03
X-HE-Tag: 1789576037-934800
X-HE-Meta: U2FsdGVkX189Z2vKGpt+No1+Kgieg88OxdLgFeHAjZsHhA/qR+K+KqF1idHuqxNzEv2e2HcECi9CtE6ef9MmahaEf0MCxFZuKpIo5zyWz1bRJL5WxFdkl/OSEaifJFN9eea84oHTeS7Hev8NRK0Hvj7m1BYfDb+b5SoxeztEqm9v/8SIG6OmC5QlPcMxGHo62Re6iO9YsSGMi4QGQBnwyrUiwTX+lmv4umWHDWEBbbSJ1bu4rvp1C3I5/GIRsDajtIbgoPteJQ90buGYqEXyo4cKhhT4QhbK+YjQkDMCqk9USqHjt3enSVAT2opomsb2SNdV/loFNWGJyOi2gKtTQ215tfBepCCxuV06MhtRdDQujlCwt8eSJ/rKHolfVV1RMroeYqaueTJUb/oqNfUmPN7lDi6yHshaYSxHMntr7hZ9SAcDX/0hJZB1BXUpQmxXG571cOWsEIMHPRsQbCK9PjuyJdQW+i9ebxJyZKoOqatUeFVXj32/AM0or+uzWCJz7/PrRwxqYaIwJIe2/X9BrQnJ4aJi/UqpX76e7PNlnq4nclpxSz0SYMsEAQc4SiqndVpZqbSEGj/fik2guHT7gr+SHQSJDwbx+qmTxxGRWdCgSGt9SXZTlt0rlTFGI/i0noXdKP2gzFik1VXJ5HKJG/KnLuh8SkM++58TNcRjNQLHiZMK33yLBPRVDgaVOXNNRSpKnYjvhK13NfT+LEWzq0+rqz3Fb0IoLfYBSdMJpzVes7kshK0Fz7ZHcf3uk5wSbtEsG6yJyUonUMXwO+WQjtBvF0wU48iPfxtoISW+EruB0otezJEmyW+eXM2OcsCMnqMovAq2znWxDE4yLJzsBYsY6xmOfy6+7CGI26QsicwTDkMAkgKJVmPG6Jmm3laKCBtpY/K5DpSesjt77FzAuKURndUuDoIqlw7gM5jVV1sVwbw/jV2jZbhFvUHFOzSE2721A2FW2WB+QOK2xk8
 UsXlvRO6
 we55VQ7JwXLy77+hw+2BWxnds3SIkb4op5oEwFwDHYY6qnTaeIzcB4agTUkCaLyfTyyJe7jhCg466Ck2mv3SCKOWdVK//zPBJ+JOxEdHjAA8bshclYSNlilCCe+GRSbBvLv3vLW/L/q8IW8cvjf2Xvs05gcDfgMJFdTp9N0ZnpDXYvSxn/8MV3ep9f6fAJ4V6/wfhIyi/7jYTdVR2l/dAdwg7igjpDg46VcsLkGn+8jTW15ennmVdivRAXkzy16Mxr3/8GrFsqaSt7ZJKYfGXvESdwvDlaQuktfR2z7PQDt0VWwYxpcwG8Qc+NTP9xI89Q2AW8mjaaHR1bx47J35XE905aw01r9EOs0sf9Ui3YSTkMJOr3FTCzOKdSV5t1yqsJQUvvDfKrXtgxX111B6muZY8lA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 05:57:22PM +0200, David Hildenbrand (Arm) wrote:
> On 8/29/26 03:59, Gregory Price wrote:
> > The interleave node selectors copy pol->nodes onto the stack so the mask
> > cannot change while they walk it.  nodemask_t is 128 bytes at
> > MAX_NUMNODES=1024, and two of the three run per folio fault.
> > 
> > The copy only buys consistency between the node count and the walk.
> > Drop the consistency and just bounds check the walk instead.
> 
> I think you should document here that accessing the node bitnmap is safe (is RCU
> responsible for that? I think yes), but it can get updated concurrently.
> 

Actually, not quite.

RCU stabilizes the weights and makes accessing them safe. RCU doesn't
help us with the node bitmasks themselves (we were using a cpuset cookie
to stabilize them to take a copy - but we're killin that here).

What makes it safe is that we detect the torn read condition (check for
an empty nodemask) and otherwise don't care about weight skews in the
weighted variant.

I think it's reasonable to add a couple comments to spell out.

Are you ok if I just spin an additional commit to tack on rather than
spin a new version just for comments?

> > +	 * The target was calculated in a separate loop, and a concurrent
> > +	 * rebind can change the total number of nodes.  Clamp this loop to
> > +	 * a single pass (nnodes) to keep the walk bounded by node count.
> 
> Might want to explicitly comment here that we are looking at a moving target and
> might race with node bitmap modifications.
> 

ack.

> > -	nnodes = read_once_policy_nodemask(pol, &nodemask);
> > +	nnodes = nodes_weight(pol->nodes);
> >  	if (!nnodes)
> >  		return numa_node_id();
> >  	target = ilx % nnodes;
> > -	nid = first_node(nodemask);
> > -	for (i = 0; i < target; i++)
> > -		nid = next_node(nid, nodemask);
> > +	nid = first_node(pol->nodes);
> 
> Similarly, I wonder whether we should spell out the raciness.
>

ack.

~Gregory

