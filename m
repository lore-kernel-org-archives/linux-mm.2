Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B8DE607E06E
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 17:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=IJlmK2Jz
Received: by kanga.kvack.org (Postfix)
	id 872926B05BA; Fri, 13 Nov 2026 12:18:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84A626B05BB; Fri, 13 Nov 2026 12:18:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75F7A6B05BC; Fri, 13 Nov 2026 12:18:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 51BA36B05BA
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:18:39 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D59381A0200
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:18:38 +0000 (UTC)
X-FDA: 85430755116.17.3251395
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0270540003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:18:36 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=IJlmK2Jz;
	spf=pass (imf04.hostedemail.com: domain of chris@chrisdown.name designates 209.85.214.181 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794590317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3C8tSwHqjzI+bnh3DElyKp/N4OUqkqrYjzdrA+UxunU=;
	b=JtPVEIVxrz4Ma0Hlx8OaK76mOZYS11u4MnEufDfDanquPIqnpu175qB0IKg2HyzUMm+Dd8
	gy5clGSFOnSv5CPNhkWr6gYoMRGd14JaBRPcyhiVOBGhzmq0vsWGReUNXVoyVDZFIVBAna
	CIFroxnjdN4z07H+TjE1XRnHZ5zZTL8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794590317;
	b=V1D0/sO2vMNJZ+Il/ZQZt9iQUeq4JA+BMs02h1x0ZXxuyywvnkxcPAv22ngVJNM1YjUDqW
	VXtaWFUoXEpDBK8uU/GVh3bGa8sNWHCyDg3umwwpFXLNL+edZ8hlaJHQ/dpEaRaQ9KJXea
	ZOYcvYyMVEWw7laic2BYdU9LnidaM7U=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=IJlmK2Jz;
	spf=pass (imf04.hostedemail.com: domain of chris@chrisdown.name designates 209.85.214.181 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2e95bd1c14cso23733235ad.2
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 09:18:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794590316; x=1795195116; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3C8tSwHqjzI+bnh3DElyKp/N4OUqkqrYjzdrA+UxunU=;
        b=IJlmK2JzBNBdfl22GQAikPAM0S/YE9w1ABO84D10HiuoyepeK0/9ut56CinecWFgFz
         PKyuZRXSC88gUqGFfpOpmdxgUjwjGbP15DsIATMH1Yo3MflYDmpFdZxIZOqCr0pjuxTN
         2lqrHwQ9VTJnPXhdD2RlTLavMqf6jfeKAnQLY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794590316; x=1795195116;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3C8tSwHqjzI+bnh3DElyKp/N4OUqkqrYjzdrA+UxunU=;
        b=SQ1Kxhvf5/tV7RcXVDpB570YzHnUUhoQo9G79GmI7hu3o7ePr8Xcc6ClYqglV3hXqB
         VPkUJJed/+LPrVb7/VU/vqMOqbZ2CgNv2CATkXXMRRDM6coJ9o0dcRuy6cBHnRmQob+q
         tD5PSuHZO6TF4oQ7korSEdEppyVt8AmqTRbapffOYNkJt/KLvYMbHPIUf0a+7w5Ij7UC
         4bLJcTu0q/sHi7pnaw+9nunZcMGEYzXDiynC6uCwlkofq5nrpmzf/CzOXrOs75spgxLA
         qEJlqJK71XQWLxRceu3fz7z7djFOdnf1AcI/HIgOg4thsRy1EGJTw4Fwtcl1QSsXYkdk
         6ZkA==
X-Forwarded-Encrypted: i=1; AL+hErHbO5a6lwcpy1HIunLsD/09AHfBMX0ma+rJDF4uyJINAXa0sNkjIpaYsjBkfusDW7K6vgIO2mThVg==@kvack.org
X-Gm-Message-State: APuU4Z/6fV/rcFRsAwq6pVaBMf9yeJTiMO7vXwzRhpNCJBa+wvT3rI+N
	qi+RWkKHUK+9YwltLs21eStXJTm+rg/gn7JQvZziBMAq5pnQ4trVupQX0OQHlJdDP4g=
X-Gm-Gg: AYBFou0KXuYHPq79VOdL/lNfZp592QhbX9kGavoH9RvqBjcAd/IAHXVAkcDOLZqjCv4
	3aCCwv35QbgdMNfnlbiqcnCLFUUP4hfzLNdxHqsXMU0/Oe9kEG0oXlVllRwMVxwCa0ki0D+/DSI
	cFY8+Z3aT6wFhJrtl3urbBK7J+L36H/TtFvUT1P40deTfBsFju/zxyAQDJZy3Nv4U3DqSLtfaIU
	LxTOegEjHzJ9EwCdDzyzFxW9lIpp63EUG1v/5YnVIrY5bcfU+DHEOXduIGzVQxpBn/5G3lv2mFZ
	haskTHg5AfyBQ85c5RPmNo9jem8LIMP6AwKnD3HkYpnqrx6oCWPAxyAgUvG+CrONy08vWbeH3gj
	ZqSWnJu10uLHnNzkF6rqPfyYA/6kHaO2EnfXf00CcH78OH9iLOF8mDbmqhjdC7h4EXz5QeiJb4p
	eguANBpSlT5xjMiElG6xfCnNDLG/FQHV+CZ+ndAnSsL0+rGYg32ZAZjUGX6k+M2GHZrqb6ZVE8J
	KTq8+FhaYZVNsGOyKPtU7Ols3oSFtyZzgArLGmXCvJ5Swcr+dGPsPFLN52KfJx+bfufFXA1giWQ
	jCEhjTnw5wXZKddhqtO4G+9AxZMpZT6BEkKmE6Wdkm+O99jF544GfW4U4GMfpWgwtzuzkpBs+GY
	b+vB/8LYxYc7gtt/BSHIVb5u2KOtrswt8IadvVM9xoPbqhUqqVXkvDvGFulCnHBfGj7mSt+MKYh
	cGmh6zSIVZWAbYFHS3S1gbqHvPxisEUObh10yI7/Dg2tNmG1QawDu/Gl7f08Q=
X-Received: by 2002:a17:902:e74c:b0:2e2:d77b:e586 with SMTP id d9443c01a7336-2ee0df12481mr33259215ad.60.1794590315817;
        Fri, 13 Nov 2026 09:18:35 -0800 (PST)
Received: from [172.22.0.2] ([50.175.87.158])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ee10bdd1a4sm12923515ad.11.2026.11.13.09.18.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 09:18:35 -0800 (PST)
Date: Fri, 13 Nov 2026 09:18:33 -0800
From: Chris Down <chris@chrisdown.name>
To: Usama Arif <usama.arif@linux.dev>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net, terrelln@fb.com, dsterba@suse.com, hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, chengming.zhou@linux.dev, Andrew Morton <akpm@linux-foundation.org>, linux-crypto@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, riel@surriel.com, shakeel.butt@linux.dev, kernel-team@meta.com
Subject: Re: [PATCH 2/2] crypto: deflate - use vmalloc() for stream workspaces
In-Reply-To: <20261111153532.1036709-3-usama.arif@linux.dev>
References: <20261111153532.1036709-1-usama.arif@linux.dev> <20261111153532.1036709-3-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261113091833.6dccf0e5ea9aef18@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0270540003
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 67rkei4eridphuxi6395em488cxb4syr
X-Rspam-User: 
X-HE-Tag: 1794590316-609302
X-HE-Meta: U2FsdGVkX18jm8qeDMr7wJ3R096AzdBPAKocuBP4DWLDjFgn93yqK4CvKBNVQ13s8aS+3tnUG3hm8P4Xyzvb5seBKPVDMhZV1VKEdRYw4x1Xm1gAlmPvlwEZjOfR8tMK+Om1pbyTSy3/bKfvRdglcrmrPGGhbtEG864EEGeXvL63qKYuiXSTyvtmXdTzWewyCPWnmLyvKEZ+La8ksyyFYCEOtADLhLof79VUvRdzzJ4RIQN+iZsYXDf66kjQY3F5K24VF7LlWVlsKY8iI2Ytt3nIxHPwsZPQvsXVBLdiJRhO1DBGl7xDLj8tjBPMOHktsAWqtui+rBy9PScEcqRXDbGaXDw79Yc+90MYH9YmUnssqv7SPhH5qVsEpUgR1iETScWdNAiNKVsAGTs1lIgw/jVRVugEBzqpE7kdzje5dQss024mLXxjEyKpMW1DzVpPDjE2BuB3eswTr/gAqhqC3lEfeT8bbJ0Y5us8befk2aqAz5Y7twN7dVjwq1DfmL8RQJXc0Jbt6fjwbTP6aE1Al47rIuV8CQ62tiEIi8J7aUptd16tg+ZzHqaOUZ7kWk94ab91yjlpKGh/iarmG7EnpEoXPvLoYQcahtNxYtr9Zy7WwmWIFMb6AxeY4Yn0EhlLDaxvZPo+p9hgGAhpO39D9Dlv5MAqIa8Zy/5Flh4heX5Hyj8CpNJ1h3ffc9oIy6CoCXp+AWFGxH4pWQErW5hzv31MioeJa3Z9T4ifcH0gsf+IeT6WYm24O5Z2aCtm405Iok7PeWqzYEzpqlHjN2ZSKJRqPzqmNE76CgNwAPRe7jkmZUJPWu7J6617nRUNBmGR1rbNA+Bsqxyvzcv8kgTBjE70qD4zvismZN+JaMI1sgQFqnEIoBMGzf+ayHA32BrTg/R6Mdbix7PFfx/VPKvL3rQ+cxOwpbT9dDJu3NCS5Yv2KK6gKWjFczFWoOoEsrHBE2i1EB0ZIhgvo8natgK
 1n+93G4/
 Tx37Qz87A9AYfIoBZPW0xDaKeaa4FK0aNKVDsY+Bi4hvHIWdOc8w/l34QNjZcuMsziDuIEmaetSJCZ7nU9f9v1xVuLvl+hORGRSBjuZ6VycxVIrRgnTVxxKFC9gJF2pb9I3v5Xx2oS/azKST9ytZmB7+r/i/EA8ZvuO1HosoQYdvv1E+L5NXfB8GiY5oAnnwld0KWv4TqOLCMC0ZtDNZpSkRRKBUu8ibdVJtI9KPNDOJjdcQq61Jt9VDSU4zbrO8hkFiWJx4qndJRotduiuDaf8ErhCZOFv4mPO4mKfeZXmbX3UFxjyeJJEp6DHRiDlLqRABKT51NYQXtjrQM+6CfJILggEeBogu9dSKXOKgmqlDIzDnml20TOtuMlFAeDWwJDVDsjtn8h+ffY3tytGmDeVk+6fAXRHovmCyFeGJgMAALIelx+nN3dBJecyeV+2N9RRju/6Ls2ple9vM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Usama,

Thanks! I've tested this with zswap using deflate, and it works well.

Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>

Chris

