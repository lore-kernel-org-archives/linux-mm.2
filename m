Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D60D2C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 20:57:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 402846B00AC; Tue, 30 Jun 2026 16:57:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DB1C6B00AD; Tue, 30 Jun 2026 16:57:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CA3A6B00AE; Tue, 30 Jun 2026 16:57:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 038E16B00AC
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:57:51 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 779E186090
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 20:57:51 +0000 (UTC)
X-FDA: 84937790742.19.217C301
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf21.hostedemail.com (Postfix) with ESMTP id AB7ED1C0007
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 20:57:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=FFAecgHq;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782853069;
	b=XoovtSkr1asAmwjUgVXKIkfXDHkgN2zkxH+X0KFtkAkkFJwUEdsj2yca5g4Ogld31pqLFY
	TjWey88QsgaAAMNXqXiEXFCVHLRPU/64cwr9PlLmfTGuMYTW1n68W5IgHh2+/L10EqGu/2
	1IZZ6msBA0D2H8oSXwmmLJxZTni5gGI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782853069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P+IJodXzk6nIKTwEHgsn4EfzwEPSclnTV/6cyemr0hQ=;
	b=k8xX/58AKrpPu043/3Jfslf0SarqPLlRdmhA4GQn4tk6L4RMbEMg2Zd/o0yj527aV1P3uY
	iHxuv2v+pXpRIvu3mpZ3efIL2OBlYF5aMX+AOqnmHYtV8vjcY1wZz/VyHrXu6zMJNgHG9D
	2ze4pYVxI42r4Ncgby0VLfci5PV/Aso=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=FFAecgHq;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-92e53581361so219057885a.1
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 13:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782853069; x=1783457869; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=P+IJodXzk6nIKTwEHgsn4EfzwEPSclnTV/6cyemr0hQ=;
        b=FFAecgHqOCrp9HoVVUQJP6nYYgx10Eg8peONUvqPNBJA9Ropb+rtneHN4KB4g3OVfz
         FEkhCrZEv8Y7GnE1D2C+bYCcZI1z/lFCm6atRZqgS88fVra9bCNpcFGxWn/buB6qw0ap
         MIhb2YqPoYX4SJII8ki6LLnvJJtuBXV37sxTk9XG+DNai7nAVOFz0+fjMmBxHeSo3wUg
         KRhPUtL+mGnbwdmtJhXcy0JsctQJGM+Poa9fVi2oeIKLg4wyosOQ9x9OmtjNermzoH3U
         peOH6lXF/kF/Df1452QYZtQFyJsgPNkOawxrgL2B6vU5D/P0KUJZaOyqMWbLVD6/iAzP
         UXUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782853069; x=1783457869;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P+IJodXzk6nIKTwEHgsn4EfzwEPSclnTV/6cyemr0hQ=;
        b=Ju5s6GgFailGwDNUuLt5pIvSpeeFgWKUhjb3Yg10kkcV3XEkaa0KxlyFrq66oxL5og
         zoBAgk2e2bmmnZ0Ve6asEleBiURbPcTdC0L+VLpxdgC1Qp/pcoyWztNItHNZJgRKSSlg
         llC7v+Y8kEEy2lwY4RG+83xVqHSd1pag7S1vGVxWa9z63PjUHAnindDfJxu70lmFLX7c
         YPE3EozpFRsHc0a7xO47El7ImYcYvjBcMjW6sC277xqXnEk+gPCgfSf/+aUHVFdih7td
         4zl1RZ8JZCebyvUCkMRXfwPr1a1nI0PqToP5BG18Nu1pdNvBj46Nnj1TwTU/xFOnWZHU
         z00Q==
X-Gm-Message-State: AOJu0Yx1vuqB9NoHvcvVdMrbQNSFZIhvT5EcaD+7lL2QCvEQda0SDvQg
	3zH/aR3R4Cc5JyftjJHqFeo7zkV77L1SlH9mzl8tqgAKZSVSp666E02cWbtjM2EW330=
X-Gm-Gg: AfdE7cmyw/wjs/HxC/KkM27x17rzymrMji/eEw34JW+o+hv/zZWGILvYPsBiErGKyx5
	gLUI+OfxZFJ85CKRFZca+6xQ7n1SMXLQQVJbCB0bKDHAFiYAlOx1kkrVGW2IuWds9ibq4xj5mjC
	VeC7733NEMJBp11EcfQ+uZQgsErZPfqvOPV5Vbs2R58vtoRC7CIyNpA8ySA+TxEMlOxNuTA2blh
	nciqL0l0SgH3/wFrXLRPU73d20JEZtd2aCCZtT1DDdkls2Ewo4NSM+XruVK92wxuE8Yy2pRL0cN
	t1/8JQVg2j7HXRltDZRRZK4sBSd6L3WXQfV2MXn/Hd5ZllJF6lptX4o44nyq7z73o5LYDTuDIHN
	s6g2p0Rk+39S2aHFvqmZZ6kKwPK+gdFLIYx9d35HDn/m51bwzAXcoYpL0vXA4FBD0qVhdBhjaQf
	QbPitjTyQKk+xHmL9SM93rejmY5ZhMwKkOIOeQi7xwEZy2IsGpcS6ABsSmc6+zHjWmPTQo
X-Received: by 2002:a05:620a:40d3:b0:92e:4a4a:4478 with SMTP id af79cd13be357-92e6d840616mr373996485a.31.1782853068602;
        Tue, 30 Jun 2026 13:57:48 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e622e7473sm348604085a.25.2026.06.30.13.57.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 13:57:48 -0700 (PDT)
Date: Tue, 30 Jun 2026 16:57:43 -0400
From: Gregory Price <gourry@gourry.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
	rppt@kernel.org, vbabka@kernel.org, mgorman@techsingularity.net,
	hannes@cmpxchg.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/vmstat: fold stranded per-cpu node stats when a
 node comes online
Message-ID: <akQtx7zhP7pxNCiy@gourry-fedora-PF4VCD3F>
References: <20260627202243.758289-1-gourry@gourry.net>
 <20260627161007.81e4533ce561c2951a69f927@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260627161007.81e4533ce561c2951a69f927@linux-foundation.org>
X-Rspam-User: 
X-Stat-Signature: sn6suw4qrrfayxy1kx6mmhj3t8bdyxe4
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AB7ED1C0007
X-HE-Tag: 1782853069-677514
X-HE-Meta: U2FsdGVkX1/OorREXIwoc8uMATQGlpZxEY1veNU9Qcxw3WeUAMdy4L6V96VFYgN2yPYmlsDgPScORzACwuZYbq4v7ihXia+Vz1H9SqvOnqTNEj+rUW9fFSJQfN0f6H9NqjjyMZptTVqhzsJqJ+khZoPbYVL4ujC76gPZv9K08dSk6lMubYFxDweuwTQihQBDMC/O2HYoinGkIid5tnfY72H4fFptcs2fUj2tfh+4G9X4fCXhVxkDaIgPx2zE4+3RJWJ4XRw4iK09B6v2Q/KrQo6THa7ntQCn/QGK23wktJxGRMaLCy3w2xdy3CQOpIuGwUfKKUuDR4cQS7DWIgpa4RW4vQpjanatlYgd5HR3zOFGUZt3ynpxegBiTSKn8JRwQ1Mc1i7r0RmqvFmXpE+kKJgRnzrdz43XMuu7CU9su15gx1ftlObzWWj5iMLu7V28HhAt6NkElzT7QGLyceWg6lkmCX/bteS11AC1Fxj4RXvcyQq6GyUkSeoX1MqRaU+Se1q4BHCMg7PtSnz3eWHCnj6x44QTwAO7XTov/dWWH5D59bumqmvc/k59cfMOHsHg6vhbvFmpY6XIQIGXmyV8AhmiZe24rxBsXDfN9WM2Rlz4XaGMp0FFCL+Y+uAT3CM/24DcUcawscnd078tR4G+T5NPzCAuX2k8PjI/BG0b7OMguook5bdHOEsM1jKj+Mnir4k/XtkYIoVTen1TrUsgIxKlJTztvXN/AlGhC2NyaOXav4AXLI9Ly/+L5exxhS7YkMyEm9ibQtUkTg1T1oshV5c7sC1vApbwO3Bwxnlu5uHktlOq3LSQIGPXaaVlpmKY/SbHAO9jRn1t4sJYpA2c4lPhWBu3uI47SrBZwH/5uPnDHuyWyW4Sk/bmkZ23jx9ABdZFsOhzqVR+f/K4PLuqmGk6gNjXFeklm64mRppAH0OxBgcSZlmrTMAlctbIoUZzJtHdjE54b1aBkAOKXFE
 CAjb3xVZ
 zO11YjrAPF86OqKymFMWV5digwJBfc55Ldi0Y/KsFPjs3OQfOqEBQ7w4KU2E/8J8Ds0RMF2+gIZddJZnu3nE7yeVrwZRLba/UU1yAA7mFAijit/o01aviigrvXbSnNrz2HwxoToxaMq3MuwLSlCeUgQ3Di1ka0Qk/hZlFCUWN18h/2NJgMAqtcbp/A59xeoUpKkL8eJSHeRQxZdqC7Nxf3J2AG0yqM22mFNv7WzcDsHSGqCFb0Qn/IM0rJnB03HX7MshPRxjuEOrbVFgsQYJOlynh5qC6kn6VZYeJ3l29x/8WMrdKpc6AixnWzjuPRZEfNLuQsohzlkV1UALv5/eqHy8Q5DaJDBKRZ+OgAd3vdzgEEbi6uUMEcDi9sPRjUSjiR0OPa3FLHVHuOQXH5Bns9PmIAlOBQWUFmI+CTfHUZ4Ac43u3wF+7A7r9kDjACMVRyef6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jun 27, 2026 at 04:10:07PM -0700, Andrew Morton wrote:
> On Sat, 27 Jun 2026 16:22:43 -0400 Gregory Price <gourry@gourry.net> wrote:
> 
> > +		struct per_cpu_nodestat *p = per_cpu_ptr(pgdat->per_cpu_nodestats, cpu);
> >  
> > -		p = per_cpu_ptr(pgdat->per_cpu_nodestats, cpu);
> > +		for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
> 
> and that's a lot of items.
> 
> I guess the overall loop count won't be large enough to cause issues,
> but it's large!
> 
> Perhaps there's some simple test we can do on the per_cpu_nodestat to
> avoid the inner loop?  Perhaps might need to add a field for this?
>

I took a look, but that would involve adding another per-cpu field and
then making sure all the races on that field are respected as well.

Not sure it's worth it for such an extremely rare event.

I can try to get clever on the folding logic if you'd like, let me know.

> btw, "for(int i..." is allowed nowadays.  It'll make this code nicer, IMO.
> 

Otherwise i can send you a respin for this.

> And... Sashiko seems to have found a pre-existing issue:
> 	https://sashiko.dev/#/patchset/20260627202243.758289-1-gourry@gourry.net
> 

Incoming patch for this shortly.  Pretty trivial.

~Gregory

