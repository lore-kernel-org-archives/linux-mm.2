Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B829F9B5E0
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 08:32:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C67666B0088; Wed, 22 Apr 2026 04:32:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C18746B008A; Wed, 22 Apr 2026 04:32:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B07136B008C; Wed, 22 Apr 2026 04:32:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9ADBD6B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 04:32:22 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5491AE4DA6
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 08:32:22 +0000 (UTC)
X-FDA: 84685524924.14.CAC098B
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf18.hostedemail.com (Postfix) with ESMTP id 57AE91C000F
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 08:32:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QDoXgrxE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776846740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NilMrlPz33EGYo1Xi2LZqhviU9wGvBx8IHXWSsnM/W4=;
	b=ammNS0rIchdlvqfZ4yKEh7Y/nf8zrl5Gn2ro6cjjK25NN+nusqUGCKDtW8GE2+xuFb1WQ6
	aZDccgffB6efJ00agvA1XH+83vWhtd8LBISUrtCMCDWV7+y3P+LcaXxoADACeuNv/owcsH
	CHY0rMLdtnNVEewGJv8tA848foFghdU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QDoXgrxE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776846740; a=rsa-sha256;
	cv=none;
	b=OSoq+gH7jni10YYrYWU2lhccr5eiE7gwKTFizVa+1+jLBZT7ZBsoSiqT4hpl+sJXtW5Toy
	AdN1465m2/DnRHco9xHVRBLfVcoA0pvzHoAU5mZRMfEErTRiZ8w70eUksO4r7vvqKysUVb
	N8nyIkQ2RNPD3EcMpIRxQoeQ/qG0ww8=
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5a413f83226so5561514e87.1
        for <linux-mm@kvack.org>; Wed, 22 Apr 2026 01:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776846738; x=1777451538; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NilMrlPz33EGYo1Xi2LZqhviU9wGvBx8IHXWSsnM/W4=;
        b=QDoXgrxEiIqCKsfPXI+NUJK8rTyBTb6a+qWbMLzIy2F3lxVKspTMVtYxOwyHpCKcH2
         6QJb4McfFHcTJBsopiinZCuY2dYUwLfDc+6Z3yZ+hzXRexZnbgflFK7qk/xvvERyzkWo
         0g+BR/wr5WBqvEpBKjYv33/Rw58G/jUbA9479p5ZbMQXw8MIlmpz5fcsMq2wtFiArHS7
         27Xh68Ij3P97rpt78+de4lHioFE8Ex3fhQR3jM5scp7O45n5tLspJHNyX6F+L+Tm+Ciu
         IO+PGMHjbXGmdQ0HTQL/HOgorvbt2VCbnAW5iX4U7fs9DeXq7yN0rQoIXbphiZMEICmE
         GUSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776846738; x=1777451538;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NilMrlPz33EGYo1Xi2LZqhviU9wGvBx8IHXWSsnM/W4=;
        b=LQ3YnOYLlg9NCqYYNBJ0wUmb8D4DdQ56MAjLvmjETo7+WPTapszR5qYtlrZGAwjYqx
         ZCB255WyesQUqE/r66RAEqaBEJqJYr9EUAo/IJMdYGiVkWyWvXWciQgN+LST+7OEdK6P
         Kto2pVLWQguMbHzcy/+Nx6u5DflGh1DNdD/7frUJ7xw2nlx/1OqL7i/qRppAhPt5PwnI
         UeXDGXDsmOdYDBy1bx4SOa6yK18d2zIAEo4cANgrWwiCxujNx2fK6IYTjel1m7f+xe/D
         9U05uShtwGZMg0M4lYQd1YUhADLGjS7NFLbHXJnvI85Z4CMSr7GNpKv6A/TnsOb/kG62
         lsTA==
X-Forwarded-Encrypted: i=1; AFNElJ+xWXBlEyO+nzmkGdJdBtHvL0JPRISy/XzMWHpIL3yFGlytkqRKAwwgxIYRgwbS2UHrMRCbDJmSUw==@kvack.org
X-Gm-Message-State: AOJu0Yz3pamHFHtIbyrYxk+8EjfRl0umX1WUIja7QtKPlE4HOZM98dc3
	Ej4yNopk79Xr3lBmlyeT4LoBjgEFl5i5C7IxmaZCOG61uIqypYc/v/l0
X-Gm-Gg: AeBDievBRucw+GBNpuPBDjf/yjPNMpRkMjapOo2D0NcR7qYZrl32Y4EcZOGSCxNssXM
	vlrmozO5TEHwoFsen5pfj9Ru6qlK2Xli03pWzaUAEgj7fXg0I+r4UtGqwux61Q6MmD5gwTpAaxX
	AzDaugQNsgutUXyYnamrVUA4W2e9hUa4dqV/1MKGl1fK0SfN0+XKMq6I73zgWOc4yMdrZy1mx4s
	7zsQxaIx7PjETFNlXzTBIfiLrrGdEV4JGAUEI0mkpt8oXh+bv3gHyLdl4k/xICQ0m98EZRSIXa2
	DPWqiyGtvVBwbu7vuC52VnyT3zkaBMeIVAyn7q/Rgn4zVdrLUWGieJ66aMHAnlZN3mCPc3lRyCD
	Nbu/e4dCdh/qQkgOq99H36aNId+PoslAtlf4mGMQ4YMD+XfEuMHqMlh+ObxKhTKzZV6Ii1Qe81i
	c=
X-Received: by 2002:a05:6512:2396:b0:5a4:143b:3f3e with SMTP id 2adb3069b0e04-5a416f4c297mr6613859e87.0.1776846738105;
        Wed, 22 Apr 2026 01:32:18 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-38ecb6f0b7bsm36262921fa.23.2026.04.22.01.32.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2026 01:32:17 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Wed, 22 Apr 2026 10:32:16 +0200
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Uladzislau Rezki <urezki@gmail.com>, Thomas Graf <tgraf@suug.ch>,
	oe-lkp@lists.linux.dev, lkp@intel.com, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>, Baoquan He <bhe@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@kernel.org>,
	linux-mm@kvack.org
Subject: Re: [linus:master] [mm]  c6307674ed:
 BUG:sleeping_function_called_from_invalid_context_at_mm/vmalloc.c
Message-ID: <aeiHkG7X_dieMdw5@milan>
References: <202604211323.fac1b29e-lkp@intel.com>
 <aedvSnhOGM_mauYP@milan>
 <aehdcxC14ycvY481@gondor.apana.org.au>
 <aeh2Ii9CxtgfsX_p@milan>
 <aeh_2WwIb8nAIcy2@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeh_2WwIb8nAIcy2@gondor.apana.org.au>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 57AE91C000F
X-Stat-Signature: a98454k6c56bxepwawse599ukc8xzj86
X-Rspam-User: 
X-HE-Tag: 1776846740-496794
X-HE-Meta: U2FsdGVkX1/bkhU6uUwKnWVac2FibomMj51Uz827bBmp8Gu1bgcVPfbxeu1i6IN3UFBCLfsztdZIwshgQpdxTR4f3nzlhGN3YFZQQE1FL8hUFLePJqfyjp8wgyKUKCRlusns0unKaY8k46fegR5Y0fsCupAVvh4BlrmFPgPCQuHhDsM//ol9rnKYEIjcTlA1KH/xyN4/MnWI1x/I9ilUnhzokrAers2ghFDwX+qUeiRSRq8gfoDszHKhBV0XVfM/Chq5dgvXYTwwoCa6DK9TSc+vG3L0uiFbaKz/HWi5RIvwEn2cnMBvXZuigz4HvSd7oH9cqROYrS9Z8f7ZSSX697kzSiSRJ+Bv20NvYAs9WZ2n4nV0Y1HR5n+MoOVJZSgmzvmLzjpcQzt+pXPJEOdBkDrxqjo5tTknrdP+Xu24rFVKD50glOZYQvCYjgB3RAzBPFjIM05072QmJjxe5XHt9q6FiiAmsJH+zp8DevLngQ+Ycz+qiuypqmbq65GkA5iANd7ps7g0IMV+pvbe1/rX5ucixor/CZJ7A4XKl3xG+VOXE0MtvoQSm9Jf+ggFCOH9nx8AJTElzHkVB7e+5LhO1TboYynHD/WKIA0U2EEWiixSo5SOKoYtZ7MwQ6j6NP4TgnZM/Lucc5zHGGX62wfEhF0ptlCBlxIXt7Ah9M/HG/xMjwavYlRvbF5F+1G/GbEHdw5UTFNVuQdY/9Sho+i3YR0hLTiwSPtfI4jo7KkAeHxcy3cNCLsqeTQ+sKuZhKq5T5aF/oSl1PaGOH9rclRRVvqz1u/T+igXhEgGHegQJ1ZAjPuTos1xUJasNnJ2CZk92ny47wLKnlC4VJd9qpS2px6ppjUwMTHFkcfxnmMcrAAtzx7dQc7aFkWxZIHw653t+OnyUckEtcbsKhYlwAqgcwkn/wiGTXC9R2hl1neHHxFiZbDa90fQZLyioVD6RpPOG1g4wh0+GQ66st2oKAq
 ZA9IoNPH
 9Z0BXcNK3x2NbHd/QG/NmUH6PK4XEXxltWZL+Z5GxWwGK47ktRSopVl2nCDa+oSKaC6QPjN4QOqAy4knn7uJxdZYU/z2LxlHz1B6gneykrpeH6RU4heGaGrDEp7c72MJkk0YRZhdhT0pdo5KHzmYtP+QhYQLm7FDNESO60LJ2WHrda0cyJu8RzwcCQebVOy5dtyu6k2uSeJk/wutztWE4Q/veaXI0t9+B+hThXEbplLP+q2wO/NFa4D9qZiBxtvRh5QMYe7ho544YyfLROaxxeBYp/c4Vdsq2oqyPd/AGYfYOTfS1RR06BQy58BE3yCToWWPBomPmpkRpF+w8b/X5GDuE3IxndEXcIJ7kjlGSFynaMJ37ULJ95FDOK8Wh4rO1WaykqM6bCBut03lVsZP8qXHHafSVK6Ya9amGdvn5GMriqbcuX0gI6ejiWfOZo9OQokMbGPJo3JgPqYy4KubbealQhIBuhCVS2WF5/5UtjKd5Me52l1zz19sWnkIhyufhCJX2iT44mv2AZXBTem8w7vwEQTjrXtjayFll5j/FFjTQahvYkSkhwuqNZK3H9rvPAFq5C/aAuPfp4onmXIMIoqlyNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 22, 2026 at 03:59:21PM +0800, Herbert Xu wrote:
> On Wed, Apr 22, 2026 at 09:17:54AM +0200, Uladzislau Rezki wrote:
> >
> > since your GFP_ATOMIC context allocated chunk of memory using vmalloc()
> > sense kvfree() uses vfree(). The simplest fix to free via RCU.
> 
> Why is kvmalloc returning vmalloc memory under GFP_ATOMIC?
> Is there a new GFP flag to tell it to not return vmalloc memory?
> 
> This has been working for over a decade, what changed?
> 
We have added non-sleeping flags for vmalloc() to extend kvmalloc()
functionality as folk need those.
 
Another option, would be: always use vfree_atomic() from the kvfree()
path.
 
Any thoughts?
 
--
Uladzislau Rezki

