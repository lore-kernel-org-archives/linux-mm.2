Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83C56CD3424
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 23:48:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E9DA6B0088; Sun,  3 May 2026 19:48:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59A906B008A; Sun,  3 May 2026 19:48:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48A286B008C; Sun,  3 May 2026 19:48:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 33BC06B0088
	for <linux-mm@kvack.org>; Sun,  3 May 2026 19:48:48 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CD4AC1A0432
	for <linux-mm@kvack.org>; Sun,  3 May 2026 23:48:47 +0000 (UTC)
X-FDA: 84727751094.24.3CF4A1B
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf02.hostedemail.com (Postfix) with ESMTP id E288B80002
	for <linux-mm@kvack.org>; Sun,  3 May 2026 23:48:45 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=f+CtNuvH;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.128.49 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777852126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fjKx1UUmYJM1XTKV4r5selbBf51cM32x98mvuA7LrRQ=;
	b=69b38l0izVfTTDC5znH7kBRP3PP3zpkWjbTe5+6HBSZvmM+yq+dOvX6QvSODE32FzQkj9z
	xaD3BTo/eFSRe+OWo8zlJXmUJX6gmqV6YejXKyY+h4TN9CIbmOJA/BytVLCVlBHfoAVwJe
	9BLyhMj8w/NNP1kgyz1i8LJQs5/aY/U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777852126; a=rsa-sha256;
	cv=none;
	b=s8A5kApucoAd+LNHmVG/Sit2FhRm7zLBxThjCAZQmWObwNVjt+FsgJovwnXWkgTPrj5HQr
	Vb0UjlvkH5CSyZ7UM0CfNry3VA6z6dXjuNDemc+yHJs9BtqjRALOlURxSx/zlAv7JdX2TM
	EM1zZzhZdl9UQt3sVse89PH22opWYhg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=f+CtNuvH;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.128.49 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-488a14c31eeso24945425e9.0
        for <linux-mm@kvack.org>; Sun, 03 May 2026 16:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1777852124; x=1778456924; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fjKx1UUmYJM1XTKV4r5selbBf51cM32x98mvuA7LrRQ=;
        b=f+CtNuvH1NsGbAHty+n/fCGJLsr89EgaGsiWsYImPe+UdR65ZouwLkGx9skDM36Dbb
         j0NqTyAk5VedbtgXuSKHBjrZKWNnTNiAFJ/SOQBwhxHJE5k8qF5v1oBPcHBkArBU60cq
         m2vHt+3tezA01Sd9imcmogm8R4N56jJtq/SpzeYzH3rvWmLGBynShZEIeYjLFAD+B0fj
         Bf06vHSOxAL53dFBELSh4vM+v9Se1ixOtPge+l+T+uGTaNuK71TtiqsRd0dyeHF+hMEW
         Z7APXGhBvJNOIaTPUVS2uzoZc6NYKdcB3hcwAiV/g5R1v9ls+goTBhTN2YdfZrnGxt+N
         xsKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777852124; x=1778456924;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fjKx1UUmYJM1XTKV4r5selbBf51cM32x98mvuA7LrRQ=;
        b=sUfslCskmcarImsUB3juPkVV5riztORvbpK+AzCHYTJQp51p/6Nn4RZycx2gf4e+l6
         2rVOw55tURFCyBwn0dUZBwolEnWFzgUfdxidO0XBxduw+fsEHGTG6P5vgzolGTIpxHkG
         dA1QQHRpqtfCHh1p2WcZvMsbIAv/5gvlbnbpyKbGw9k/9rp6wKoFXHHBruW6QIYfEfTH
         /h2RCscjy0DzgvRRcAIIKHwz4SollrGC5VXbt4ANF9Q6pyGZ2QTQ3rCTXdxEdNSOzvA9
         2OWkZdxd7/EJgBT4dd0tDD1tLXNKSBRN0aLYPH+dXNa+2X7g+svyuBUtvOqToyzPM24a
         oQMw==
X-Forwarded-Encrypted: i=1; AFNElJ/CZWXh6w9XSqquYkIxvxCOIuxB+a0vwOk+ELidLr/AUPshbcYnqOSIXdVT3qQpaXRwpFYNWBuNVw==@kvack.org
X-Gm-Message-State: AOJu0YzwowH44xw52JQHdYaleMGT7uhdpBs4mmnkR6UOxIWzXSahCafn
	5xQY2Tg/H965JyEGnpN6djh6z7NxygX3KQOqVchkBcCBusQoWMfg0DWdnmhLFJAQpR8=
X-Gm-Gg: AeBDiesF1hgvWVDKIP5zQqX/Pgzy9sbmJbz5CIqwrQcXhFSLUdGfW8/ftyAnHttg2BY
	cGNKNvbxY7HGB4TqPkHfh353YpbHICMkHyWfA6RFyrRTQURZI+bPvy+ZY15IE4/SCgvDS4xbrkq
	ZO3phxSCvveAIiWvViwnYNGlokee5Pp9FXiCSeFb0p9d7xFxw3t8OzYhcXXCB8vr6BWnl6/E9ws
	tSDqZlwUNUyL9yzSmWV5gMN7NqgtvSsfMSEcWYhTORDxvwylUN5tafoCCXdFIyf769bfZwADypj
	63tPOVbEAMTdCEdMUCcoKYKlKSzWTXLmaZGsu1IwzfEsd5Dj9goFqv5okqTNkfAsLFLBnYECQOU
	ejqp59m5qyuOjYEoLpaIjRkfSxlecVjcZ+VPlbT0wBzYC8moNivyd/mFla5GAJ0IXiA6iGWpJv0
	eRAB7OYOlnJYmg7+wj0gGcGo/sUMFWR2cq2vNdF0ZYKiopfMpo9LE2t34=
X-Received: by 2002:a05:600c:c082:b0:48a:5821:5ff2 with SMTP id 5b1f17b1804b1-48a9887190fmr83740685e9.8.1777852123715;
        Sun, 03 May 2026 16:48:43 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([213.147.98.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a8fed8ea0sm105655245e9.5.2026.05.03.16.48.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 May 2026 16:48:42 -0700 (PDT)
Date: Mon, 4 May 2026 00:48:39 +0100
From: Gregory Price <gourry@gourry.net>
To: Ritesh Harjani <ritesh.list@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	lsf-pc <lsf-pc@lists.linux-foundation.org>,
	Bharata B Rao <bharata@amd.com>, Donet Tom <donettom@linux.ibm.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>, linux-mm@kvack.org,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>
Subject: Re: [LSF/MM/BPF BoF Session] Numa-Aware Placement for Page Cache
 Pages
Message-ID: <affe1wM7A8hWxgUW@gourry-fedora-PF4VCD3F>
References: <h5ossmwe.ritesh.list@gmail.com>
 <afNV5wbhsFQJLzxi@casper.infradead.org>
 <afYQz3YJdWB2R-1q@gourry-fedora-PF4VCD3F>
 <afYdH4Alu9QA18CO@gourry-fedora-PF4VCD3F>
 <8qa0sc06.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8qa0sc06.ritesh.list@gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E288B80002
X-Stat-Signature: dyytwhqu3c71e5fnoyi1ku1pwdfzud1u
X-Rspam-User: 
X-HE-Tag: 1777852125-483635
X-HE-Meta: U2FsdGVkX1+qoHuAQw9nmC8OsO6sJcCGNT6d9gG4Y0mU5wGMw5FGSitb0Lk35bZi6ga+AkN8B/FA+hd4CQ0OPkXj9ySYAma4yC7ZUg7e1PxYnaJB0kj225l7aAstBLHWb0bX02rWlOYMYMmFppMsfcvROnZ4lW3YQAH2/e+r53kKTbrdPh/rCvwFwMXjOGGd4xFD8Ej4NX+g/WThMeWzmsOvy+CSE0tXL46SzdW7m/htbty0NLd+nbEmNty8FSoKWFqmqNX5/L+vKa0mUatsx/20QmfzjEwAlgN3PH8yJITN3m0zRUPwAlQMf8qCv80lKDCmKePiQXRDXdD0NLVs2UgG6Ly3qF+D4geAcnvt1/7FWoaIjurC4KJn2rJ79zoC3sn1iwIvD2h+/eDtQHfgFUeYn7y22tfBryXHx/xT4MED+dC4chbBIc3vI5TDGP9Fhq5X199Davh67IqbEAjhGxAN4MJZVEQ5iHb0wLt47YlJrghsUL6MoefcsuQFZ1ANUh/+uzRRTauwXAGvON+RzUzKYdKyWqVp3U2oO5SteGheQqVKvwRcWIQbEvXzV8NWwjeZGmuel/ST9q36a9+e+LHkZ/qWtTjTvxaTAGg7cQACaqNm9f1fmvDObkp+DaPaich4w1vL2U1jGStnJEkMmOL7cSuiMNPF4YJ2WzEZ0M0AR3AUBw2LyPxUfZpIfNR6x184/iv3BwoFKdyNBMqY2V4ckBmr7R2HEDKu28xdSljwJMfCXyH8meQr/qFb/phz9Z9m3QMgCsLDFIt04lhJqePorA/Sly+7GitxpAaVM3VS7R/7t7Xu/eUVKqQMEGAvAUsilr8EcIGiYxx6Tuxs7pdSHiRn+2ni6G/qAkuq5bAPyOE3740M7iTwocuHbm9XbaZtNgCfcECTAFQXh1K085QNVoX2Chd7SCnqGiwXHEmvb9luZXPYSp8IR4e88PUkJi0vuSRoeBDGitdgpVQ
 /TpAYfGa
 T+Ppg2GP7IxDwrAWcARFazt6KQ+3QT7njTyr/JC8uXw7s0WAXgSOttZctV96M/61xnxyGrN7sxZFIxr3hB0SMS7jmmt3jXOKxeG9yu8HDufxt71L7tKibdfvSnLmZ72IWbKfYn0ivw4WFQRVGhsy8Hj47yJGCAvDSV8PsVgjdbTO0MtYyEk3FHpm5ofw3qiBViIGokL/r4h8+HjtYAXIc6J5q+buyBFNs2ZK/PdzfQuq5M9Y8sdbwrsVz10s4aLiWoAulYirrDj3eEP0kvifC/xkHFTVjkShkDTzkpOI5SOa0CyNLnotpA3hOMyxq3W17xlVu3zdTO106n33z5oXwHGIyHVnoh9LHtTIZw3rOygCdDJdtdhZ0S037vNJWA5CLSgBbEVjGuzeir+CxNp4DN7oYYicpBKDBAHv01IeKp9s1mqiDx7NAXRF1Darl8fpL6YZAVNVR3SItNyE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 03, 2026 at 09:48:01PM +0530, Ritesh Harjani wrote:
> Gregory Price <gourry@gourry.net> writes:
> 
> MADV_POPULATE_READ_NOIO should ensure that only the cached folios
> belonging to that file are mapped into the process address space w/o
> doing any extra disk I/Os. The subsequent mbind call with MPOL_MF_MOVE,
> will then ensure that all the existing mapped folios are migrated into the
> chosen numa node. And also that any new pages which gets faulted in will
> get allocated onto the chose numa node because of MPOL_BIND policy. 
> 

This all gets rather racy with buffered I/O, I'm not sure we can make
this work the way either one of us want.  I need to chew on this.

> I believe there might be existing applications which might be facing
> this problem today. This can happen, for instance, when there is a
> workload which can run multiple times and may run across different NUMA
> nodes. Our internal test team once reported a similar performance
> regression with llama-bench on subsequent runs when running it across
> different NUMA nodes. The reason this happened was that the existing
> page cache folios of model weight file (from the previous run on a
> separate NUMA node) were not getting migrated (because they were not
> calling MADV_POPULATE_READ since it can cause a read of a large model
> weight file into the page cache all at once).
> 

There's a long standing issue of unmapped page cache files getting
trapped on lower-tier memory, i think that's an orthoganol issue to the
discussion here.

IIRC DAMON can migrate them, i think, and vmscan.c will happily demote
these folios.  So at a minimum we know they're "migratable".

> With that in mind, do we think having something like
> MADV_POPULATE_READ_NOIO make sense to address such problems? Do we have
> any other usecases of this too?
> Or do we see any problems with this, due to which it never existed?
> 
> (Note that I haven't yet given a thought for how it should behave for
> anon memory).
>

I'm not sure why this would apply to anon?  Unless the issue is
specifically anon MAP_SHARED.

~Gregory

