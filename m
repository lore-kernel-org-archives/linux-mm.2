Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FF37C9830E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 16:57:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D8E96B0092; Fri, 25 Sep 2026 12:57:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B0A56B0093; Fri, 25 Sep 2026 12:57:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C68A6B0095; Fri, 25 Sep 2026 12:57:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 405F26B0092
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 12:57:28 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B7C0FA071A
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 16:57:27 +0000 (UTC)
X-FDA: 85252890534.13.54D5955
Received: from mail-qv2-f43.google.com (mail-qv2-f43.google.com [74.125.230.171])
	by imf20.hostedemail.com (Postfix) with ESMTP id D6C451C0002
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 16:57:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=UBtTje0G;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.171 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790355445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9bjrkiL4iEq9ZNMKHNSHheXCqmdqWwp0fVo1stfpkbA=;
	b=1eIUBbdZv5JN7JIJD7rENHPW9O6VhPf/n9F7rCxcH5ZBX6hDHKiUz6s7aGkaUPAVyNESG2
	NptEm6XLcYdhx7aXSyDHn35XBkL48ppIOfDSCPFtXUBTOeXzNufJRf/6TJDcA7zCFtr1+r
	UJ8DOpAouIDJFMc0n8wCZVy9/gBUH5I=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=UBtTje0G;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.171 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790355445;
	b=iINBg7G4PwSfZo+EFCEVA51Zs7ASxQ3m2sPz5oCotixA/A6Ae0M6fcXbOJyQGJ6weLcFNy
	or7eWEFZYyb86a5CRsQfChkVsISQrrrq3h18dkQvz0jtgFaWytZSiw7bK+xB4xxI0Mxu8j
	q7CA1/AUnpOsUPkUurSedRQRr/RvkoY=
Received: by mail-qv2-f43.google.com with SMTP id 6a1803df08f44-91439d36903so4650466d6.3
        for <linux-mm@kvack.org>; Fri, 25 Sep 2026 09:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790355445; x=1790960245; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:to:from:date:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9bjrkiL4iEq9ZNMKHNSHheXCqmdqWwp0fVo1stfpkbA=;
        b=UBtTje0GAEcHwJd+GfE/B3gl4XClKSczumOhWLcJuBiavoGE0MBXSMtHrVAcEjBUgJ
         zg62CL+qsYlzq6UwgF+zRRHby/awdH4Itnc5dUxcWs8zaO6NZsvc1AIuod48i25wTE7O
         xUR6ezpiW6uuZA8SKx4HZxFg+kagcgx9sCUZfQtOY81LfXSa83VR3N5xra5eeVBbFVDq
         /PNUEg65FKGpBJE9DbV0wXQBcApYHiKKP5yfa/Ivgl56hFjvxLTfoOaExXX9+lGVEoRz
         uF+Tgu8e/o7HX2qNwCoseQDmdOn7oRSv7fjYSDj1iczogTXoRfnnVQNaZq0KYsUYuVz6
         OExw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790355445; x=1790960245;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9bjrkiL4iEq9ZNMKHNSHheXCqmdqWwp0fVo1stfpkbA=;
        b=YlorcYVxmyKBEnJqY6RkkQ/CVJIvBGwfg1T7c9Wdmqv50vMrLtiH+T6VhUIjZBKiQo
         5g6eNZFysHNsw/LR8BJxO/ZhQeJ57/G7jQ5t6l9QVEfCnHKP87QZxzYQ3W9W2Ifb/v/r
         qEdDlh35t4EQdkfrqe20u3Y85iiOaEAaHhHNl8q6tICWhy1CQEHwb5gtpkj45T67VYq4
         n9hyOYrVFJTVJ+tgwtk41iU2hOsNaHJVu+SGf8y3c8Yduj+ccMBwdBa2ELOn9SUP2JsX
         O8HAWBUCFYh4I/mnnZQ1FE4irwE37rX7582SKrPgMdTcB1kh9o3zjobW9wqD7fki7bjg
         vHhw==
X-Forwarded-Encrypted: i=1; AKwUvBzYhHzA0HJ6ILsGbKpcueQm5eO34h7RKr9WuwGRWvUdXV6ArTQeHWbJGlitkODisubOKyx6tcoOhQ==@kvack.org
X-Gm-Message-State: AFuF++l/wx2zDYExjUUX1iUw9S1jKmoPmHvegzwFGlxsqL7Pnw4Dt+KI
	amaWohglVI9dtNNEQ9ngvFmRyWyYriU64OwHf+en6yqYHfE88rYeKQdJ08yaji7l4tU=
X-Gm-Gg: AYBFou1DCRbt4Hn3I0AxKODeS6D5yx85q+fhDS6asAJHZ1TBe8h6BOYGjRstPL22rTw
	bnkojuMxvghGHcwZuj3Ia9dtq+SgwRQal8nOrlBnAZ6/qAYw/t59JPbLTO0LgsUh4FTKaig9Kqe
	axjH4evGxyXHMvHrKJX9hN9Q0pLdlAWRQ9lI0zi+iJaI9hk7GSg3B5w9UIyVbeTJvKkigROUv6G
	mecdscodnvVHVudIVLpPcrz5JxpGX49qHDRoeFZRgzrMOcKE75ZgWlhZ7wDBUqMnA5j6ruEsJul
	YQn2ENmlQBi1vbH8TUth2mKfseveJd5J9ZeeTmP0d+z8xnU/aPNdE5aKoUiHqb0VYn8hFKC55SQ
	YXd2fVajyPu80F+qrKpw4T76/QhGoXWlyqW3ranenB2sH+ucWGwK/HfJXmD7sZdQcBYDEg9lFJ1
	n3TeBQQcM4TuvyPtNKpwks3VDx7N6Bx5OWHawWlCpJGi+IPOrD+PH9F9A8gh+nhhlUaBidgPQht
	iAuqMDxdzdm4F6++Qc5drSDZVrmu8Y97y/Ai9kwvrrtLMzSOtZffJ3eBNzBMWOvyA==
X-Received: by 2002:a05:6214:1c8f:b0:912:517b:7be0 with SMTP id 6a1803df08f44-9142f9ba67emr60909446d6.43.1790355444970;
        Fri, 25 Sep 2026 09:57:24 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9143a7f3062sm11614896d6.8.2026.09.25.09.57.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 09:57:24 -0700 (PDT)
Date: Fri, 25 Sep 2026 12:57:22 -0400
From: Gregory Price <gourry@gourry.net>
To: SJ Park <sj@kernel.org>, Bharata B Rao <bharata@amd.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, jic23@kernel.org, dave.hansen@intel.com, 
	mgorman@techsingularity.net, mingo@redhat.com, peterz@infradead.org, raghavendra.kt@amd.com, 
	riel@surriel.com, rientjes@google.com, weixugc@google.com, willy@infradead.org, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com, nifan.cxl@gmail.com, xuezhengchu@huawei.com, 
	yiannis@zptcorp.com, akpm@linux-foundation.org, david@kernel.org, byungchul@sk.com, 
	kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com, balbirs@nvidia.com, 
	alok.rathore@samsung.com, shivankg@amd.com, donettom@linux.ibm.com
Subject: Re: [PATCH v8 0/8] mm: Hot page tracking and promotion infrastructure
Message-ID: <aranZV13vzTHR8cL@gourry-fedora-PF4VCD3F>
References: <20260925021226.52kpnmvfylw73dz4@offworld>
 <20260925095039.48831-1-sj@kernel.org>
 <20260925163051.vuh5y33xemwqgohc@offworld>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925163051.vuh5y33xemwqgohc@offworld>
X-Rspam-User: 
X-Stat-Signature: cs5jprjnjp8o7p1z9b94zc1ewwnkfpwo
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D6C451C0002
X-HE-Tag: 1790355445-999838
X-HE-Meta: U2FsdGVkX19V5iDj3bx7bOi8/M2EGjafh1sucNkCRV+5PuOH8y+8v959sP1xl1Y0UnvxvRj5nXC85BagWZKxSPNYMJz2LBQRuXkNOO9yzo7GbZH7zbs8ab1kYJOq/6+gnZOFtmu+bMG8moVoGfEhXvgj7egt5Omf72fPgYtzE/jBjsOSDFTS2NgJODjeh/Hriwj3i65XMHyDDQ2PBZrEWDRccfNYh7KU5TeQoOh43aFAMVvKvPTy3VqKZFoJz6Scw/56eaaECDJIe9an7ziYtz5lP0TVYfVjiZ2E5id03MVBTBxEFI2VdQ2WZ+fuhB//i/Jv5I2crexcxbTblrwrAD//TtWKptssCpAjMy3spQEgdTNdM0Mx3HUiobgh8wt1qrJAZCKo1COfjyLwfJKJB52xo3TXlXZk1ptbJT+K6OObqlAPaSPtmsYvUdW4fwuRVlwbvKNjDf5wJKuU8r8xkKwJ2GsPEmS/XE7GJ8yADaFIevbruW/AvKF5GuoeY8QcBC4l1QDfo0rfNqPx+WE1hj4wb7mPYpz8oQf//W/N60rewNZmlHwwUsQ/+cCjPBQr9FQgKK9/jZhgALz8bKwXuKPpt67V6ZaslITLscZo3nVzfjuwhHPJIkkGYwFdc3DKdoC5hGDzC2u4ZqY9KddZKxfj5R0Sa86LTeFhpNhSqrmVGPWDxAHIMP0b4V46C+YnxfAlymJGT/qhRMpXDFaG+64++pinc6ar3bdMkCiX8VphuqhE4KsCrgN0cbj4IoPddz47vwYl9oHSSCdaJTtxn01mDzkl3q3n7viwy3TC7+Yx2JXrBTXpf9F4IbE1bbv7r9DIAmAK/HGi37W3sDiTSkpNMPD9UFso/EhnbcsA71RlYKDc5HAVh4AKKicfS2oeZ0z/JCwHNVAQvzhKF6EaipXNCKvS/rOCw10/LoNOpwX1zzxF1IqbARoTTvGaunLzE5tGKUh0wMTMfjNgn/+
 wv7lI4dD
 iDGaDQnfp5pwsUCyIwBvfK6DipZL/2YahndOBCUlrUtfknQHihRJJJ0wBBgEBXmSiRV+3aTz6yQ7o3tn+iIIIufgN6gdVUGVbNShnBL5m3TZE2udFcynJn3pnJUnhXd9z1vytNARb9deIv/5KZTVAjKsd4E6MsTS1Z0kJHfBRl2Tul74PcIhrsd/WnytQesQUiZWfYNhuW+MgOFh2NLAZHrXoyQXs52hDlaruD10zK6DnrdwASZ8CrVYsdQvmKDkVNvzPt+YmYmS7wGEoIx7M5i52Yxubhyy0VOw2mKLg7Mp32/XcD6x1SsTUJ+ED6rcLM/X+rYBAaacPtrJoocwHRifMwIty1d5hTheUjiosBkbTAT4FrJ1dKKgYhJZm0snSfZqaKgQ3CzsouvVHI/IFGhw3hfSIr5d6TGnLkKf1Tq9qcEQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 25, 2026 at 09:30:51AM -0700, Davidlohr Bueso wrote:
> >    +/**
> >    + * damos_add_folios - Add a list of folios as highest priority target for given
> >    + *                    damos.
> >    + * @scheme:    DAMOS scheme for the specific access-aware operation.
> >    + * @folios:    List of folios to apply the access-aware operation.
> >    + *
> >    + * If a kernel component finds folios that eligible for a specific memory
> >    + * management operation (e.g., CXL-promotion or demotion), execution of the
> >    + * operation can be requested to be done by DAMOS using this function.  The
> >    + * execution of the operation will be asynchronously done by DAMOS worker
> >    + * thread.  DAMOS features for resource control (DAMOS quotas) will also be
> >    + * applied.
> >    + */
> >    +void damos_add_folios(struct damos *scheme, struct list_head *folios)
> 
> Considering chmu alone would not justify a generic mm interface, I am more and more
> inclined to go with the chmu <-> DAMON option (I recall your presentation) + do
> NUMAB async (1 and 2) and that would solve most problems in a practical manner.
> 

The major pushback on NUMAB async has been that there is no good way to
charge this work to the cgroup.  

Shakeel recently posted something that might help:
https://lore.kernel.org/linux-mm/20260924184714.912181-1-shakeel.butt@linux.dev/#t

But the approach does not generalize for everyone (see Tejun's response,
net rx).  May be worth a look for folks.

~Gregory

