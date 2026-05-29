Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14503CD6E50
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:26:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 782B46B0108; Fri, 29 May 2026 11:26:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75ABB6B010A; Fri, 29 May 2026 11:26:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6704A6B010B; Fri, 29 May 2026 11:26:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 552E26B0108
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:26:24 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 19C271C0196
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:26:24 +0000 (UTC)
X-FDA: 84820833888.26.7C962C4
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2F37916000C
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:26:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=emMQzIZH;
	spf=pass (imf08.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.169 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780068382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hXXCbhIHtRNsHen8pCYQ+YRxwoUgedEKjJY0J2w8T+s=;
	b=zNF1/htkeQMqj+lrz6UIVAm138jri4oNY2lr7JI7fEUJD4VtxJKGviTyR4sZsqOk9Im1BR
	XfkNeX6v8u9PZ3BU/KqxiFDgrGJrcHJOktqU6fFDHsRQz1gM05rvFbQmbL/LGiSTmPm7jh
	3K+7znWPY5vkvDvu127myO5VlW4oQ/o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780068382; a=rsa-sha256;
	cv=none;
	b=N/f2a05Ldf78udmXvK5JKCend08N1dWiYnraOGVcryZZDlqXfuXM2keLDSl0+oYxU9lIjt
	Oku45XftqYGejwvvmIzvZBxJUQfCo8dXekNCKQYCgRfyFJ1MGo5xY6TOmSftznwHsmEJmc
	/Gdz2c2f21gF76yVYjr7EGj5FvSqRcI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=emMQzIZH;
	spf=pass (imf08.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.169 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-479ef2b78f3so12268920b6e.2
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780068381; x=1780673181; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hXXCbhIHtRNsHen8pCYQ+YRxwoUgedEKjJY0J2w8T+s=;
        b=emMQzIZHtD2r25LPYH2Or5YlhAucyjqcvDnXXeNtAa2OJFUWBQFVsm4KVLpmulmKRo
         1cruRX6CSytuEWi+K2fjy2KQGzVlnE6AXbgYD9WHxUUv/53m7U1FuDRwyIYsSCCW8CmQ
         BegvA+3vAtnUvT/02q/3wtqcKtMZM2k1HuXs7MVANJMVEUr73a19/tYES+qre/wKQVLk
         0nEk8/HTTzQQ1S3FJ5UMAs6pofghM3A/KGnBekVVDCpNLJdGEkbIhH5lC6SM0d6g7s7f
         4ci4C2ACy3b9N3J1scKuqIUQbxuX7BLHYm31MO9iK8bvwk9KLH5IJzgkpZEySo9v93C5
         YD5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780068381; x=1780673181;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hXXCbhIHtRNsHen8pCYQ+YRxwoUgedEKjJY0J2w8T+s=;
        b=oP0o4MWY8AbDVZZtKMN6zcSKjFpeVUe7zKaap8Uauuux7QH6BCTPP6XtSogqEAs1+c
         Ot3KY9KzOEVZpiI0dkT9gM4fVBawkbkQqTuNzi6LaFjKSwOAbRGxyFhlk/EnXHMG/xUE
         PffK1U2gyAWJaSzsIwRJsqutVLD368bQx7HECyiD2cvcyQ2qkHTrWRJ3tUFT5M+Gjouh
         pX/1X85tZXB7ULjz6rOnmZbyY/lZT4Z2O8hbPtXvByo8LXWFhDdlgVwhvtJXdZzHJHMA
         MCc55vlaFH9vrI+nGgROi5YG9k3Ei5d3hVT7AhHSSuFnUxZRN2XOQe2mHal8QDbr4Gn/
         +oxA==
X-Forwarded-Encrypted: i=1; AFNElJ+UTOWJapbjNl1wa4fNg3yaiJoJN0pRe5ZkYjRMP/1h1sd7rODShnt6HUNe5I+XDPDcHs1bC9FgJg==@kvack.org
X-Gm-Message-State: AOJu0Yz3c8yImcC8u10iib7FCnt/tm5wwRs35Qpwn6NwcWk+D08jgI5Z
	iMAZADsUy58Pmv/FGTgbAceI+DupyaxsXcuB8X96lm054qXviT/6JdhU
X-Gm-Gg: Acq92OFOsiPG3TPurKKQ0ByQgXVZ8Vx949VQ4L5230b5gUiCCKfg/7OTZLi3yKNLHZn
	ROIdzJvJOX6K6BgDvnpPsVCleG//hYdr0qluujDXLr4DT8f0p7IflpK0IMcXCL3akGBTrN2NAqy
	cyyziyMIkKpujeZt+TRHgdjYGFJY0TY/LU+04HecOSsoKfYh7W59hi5SrZkJ35iOJ4oxkL2vesv
	y+++idMzj7V5S32VOTJYamZjM8E+aOEYlKPN66STB8Nn2LVUpMsztYXvZPkyGgrBeQCCSSzowwx
	TBK2aAisXQ3mxywBAAd9MkApDHzATVkcfyqmNOrteO1eUpqbpI6HJ04WNgZppJPo8XuFl1SVvHG
	kXf40vqbRU/WZ7hZnlKCdXH7JHjpqmWw6STRNR+frQ96oMEJ7AzfM6/n6eoUIA7cW77kR+9fwBr
	5VgFigOf2DvIQ2qWnOnhcMpoZz4/lNKp4T7Bh5skK6st3SpfWB+Va82SDwhWJrkO8=
X-Received: by 2002:a05:6808:170b:b0:467:254:b90 with SMTP id 5614622812f47-485e698fcb0mr1813824b6e.10.1780068381169;
        Fri, 29 May 2026 08:26:21 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:b::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-485edc5fa67sm792027b6e.6.2026.05.29.08.26.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 08:26:19 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yury Norov <ynorov@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Waiman Long <longman@redhat.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	cgroups@vger.kernel.org
Subject: Re: [PATCH] mm: don't allow empty relative nodemask in mpol_relative_nodemask()
Date: Fri, 29 May 2026 08:26:15 -0700
Message-ID: <20260529152616.2308736-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260528124133.c88c27b11a8ea0ef05e494f7@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: czy5spu5j9y5g6g4jrz5me8jotm3qx1y
X-Rspamd-Queue-Id: 2F37916000C
X-Rspam-User: 
X-HE-Tag: 1780068382-515915
X-HE-Meta: U2FsdGVkX197ZTM4oQ5jXRYbTpoWAyk2ZQBoK8cqWBoeiR2LGxDFoF1MlqJ/6Hs60OWNkzCH2c6vHArp9q1dMcKgCrNkhJvoL1ORwIJNuHcylLFWKk7son/wvDytgS47fXqJBOSLewp7IxKZXrin3bpRZStrZ+RzBwRt5NSh6yuvQ/hWwQiLxV7SHkJ6Be96UOBtUPrfhz1CEfS0BVAGczBU22p8CLdD32U8wuS/z0UAzJjW4BPh+HfEH92e2qOBl4W42/0lYLxVixysOBsabOL7nGc1KMFa5SuawazhT8kIRLk1QmcybnoH37Qa4g1QS4UtjPn3OJDwgmujqAHyzTXmrVlWkxfF9THhzKbqX9XFEcnVKyd4d1p4UIhKKrkf8kH6U8kQIib5wu7N536tFQXGw6biSw8scmVh50ROViyj/bu2aJ0GM/Nekf4WJ7D2gVcD+6Pia+lpIX0QbMtER65hDY9+U7eTWLIrQK3UgzLow2CScpQXpcgDigHQlmddVtnY8sWGPl2k5PkayzMi9quLZjVdZPzLw4I2XT6wL16M9wbNyjjMeMmgvnQ3kFZuehNlynRjsl2ZXBszRZv3qe4WlcVW+LzPdxokJ4fH7NOt9QIb1km3t6bsmkLq9VlLHDq8lpHQfBl3ZEbOB1dlMQXe39lltdApDonP/JyvaFDHkTngHGtlNX35t00tVtbXtTnkNNNK3vSwo/OJ/+NdOSLonIlKu8b1OfMhDrTlFBb+PP0FFpLcSvDQHc5TufmYHFqSPIFwYcI+/IAFxSqS7b0RCsa07rJGTl9TfLhH0FqOv+UdAC0zdQv//r/brlfeJ5i/gFWd9Dhjw3/FwY5Ri+JrdHtVww2JuzamNLCwaiKBkvuo1UQJA7HWKSTAp9uuJNcZbW11chwoh040JIq6AzIW18mKlgTA8iwhGRTQe5UudZpzEO/X1+hAxWKovM0fBsgeTNiXk3scDiPoU2u
 snyiVnA8
 NlG5Dxv/mzl/wgewhyFKH6u+5HF7yupzSXwyed1NSg0ef1D7CVW23AoOj4VatGr2NiWgrTlDYWtHDhg6PDTBJAzgB0nqHA+iziguUysdNjv+k5HlJjX+6WbFaMmSwnPytp65dQih3k2HWFDAzgFJJsuaaiGRKNXk+agENg09htEH2cNht6WdJyM9ppDFmELizZZ8cotebFRy7LzbSUc1Od1GzvQ3iNyQOhRJqQs4RWdpqH8SYuH8qvQfpdZQt4zNpgoefWj9944TDkeSwe4XETgFgehtM1+7GTvmQuP82YC4q+20QscdK6P4tHhMPBxMpPLWgAmLiTFgWbKkaL0/e7gA9Q+KOFBUqPxOa8ABsRIXfPsuioiIWAlNBvyOQpRX0VDusJilV2bqwaCg4rGMD5e2HdfWT17fxYnnTE2m972XIimTgTJfi3Xt1WiTPZpF+GMu/Q/3lNYXtdsNaMgIJIOeiNBM3ZrNXYg9pvwr9L0mMp57ZbILQ0PCvujKFD++g30AvqvrCF3ga5lDCV7feOimSBwJFEyHEsMqNUb95aAfHn58AQb2U5R/47u484UD0OsvO6PHYnQF+QYYQzuJyXncdp83/3E/V8lnLdqysDWbewXbZV+53Dl4ERRxeNCSbBoeRvBjpxtpZHGGCbPUWBh8q7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 28 May 2026 12:41:33 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 28 May 2026 15:03:37 -0400 Yury Norov <ynorov@nvidia.com> wrote:
> 
> > Reassigning nodes relative an empty user-provided nodemask is useless,
> > and triggers divide-by-zero in the function.
> > 
> > Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> > Link: https://lore.kernel.org/all/CA+0ovCgxbZkXa+OU8w3s84R3KNPNxxRfmsNR-udh+afQBbGNmw@mail.gmail.com/
> 
> Thanks both.
> 
> It looks like this is very old code, so we'll be wanting a cc:stable in
> this.
> 
> > --- a/mm/mempolicy.c
> > +++ b/mm/mempolicy.c
> > @@ -370,8 +370,13 @@ static inline int mpol_store_user_nodemask(const struct mempolicy *pol)
> >  static void mpol_relative_nodemask(nodemask_t *ret, const nodemask_t *orig,
> >  				   const nodemask_t *rel)
> >  {
> > +	unsigned int w = nodes_weight(*rel);
> >  	nodemask_t tmp;
> > -	nodes_fold(tmp, *orig, nodes_weight(*rel));
> > +
> > +	if (w == 0)
> > +		return -EINVAL;
> > +
> > +	nodes_fold(tmp, *orig, w);
> >  	nodes_onto(*ret, tmp, *rel);
> >  }
> 
> I suspect we should address this at the mpol level - it should never
> have got that far.  Hopefully the mempolicy maintainers can have a
> think.

Hello Andrew, hello Yury,

I agree with Andrew here.
mpol_relative_nodemask is called from two places, the first being
mpol_rebind_nodemask which is the calling function seen in the bug report as
well.

The other place is mpol_set_nodemask, which has a helpful comment that notes:
"mpol_set_nodemask is called after mpol_new() [...snip...] mpol_new() has
already validated the nodes parameter with respect to the policy mode and
flags".

So it seems like we are missing the big if-else if-else if block from mpol_new
in other places that should in fact have it, like mpol_rebind_nodemask.

The approach proposed here of just checking whether the node weight is 0
won't work for a few cases, namely for MPOL_DEFAULT and MPOL_PREFERRED where
empty nodemasks are actually allowed. So what should really be done here is to
do the full policy-nodemask checking section in mpol_new and call that from
mpol_set_nodemask as well.

Thank you for taking a shot at fixing the bug report, please let me know what
you think! Have a great day : -)
Joshua

