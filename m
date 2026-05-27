Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85B2FCD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 18:14:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57B136B0149; Wed, 27 May 2026 14:14:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5052D6B014A; Wed, 27 May 2026 14:14:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CCE26B014B; Wed, 27 May 2026 14:14:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 282056B0149
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:14:07 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C08691C1E15
	for <linux-mm@kvack.org>; Wed, 27 May 2026 18:14:06 +0000 (UTC)
X-FDA: 84813998892.10.A9B0D05
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf26.hostedemail.com (Postfix) with ESMTP id A35C2140015
	for <linux-mm@kvack.org>; Wed, 27 May 2026 18:14:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=cN0ZksFR;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779905644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LwEpKAm2YrkE7cJAsX+WvqoYg3SlwB6svvqQQHAzIiI=;
	b=qtURJneffcSTwliv+TqqbtAIPllYPOu4slSbcogGlCu4aBQfnLde5nwfO+PDMcv6aX7QE/
	13dQJppFWXNfa2hajaO3SR80dvmQVa/9llszu2DNT8y/kYzNH7p/3uPrpIKTsObPUoI7jQ
	3jqT53IPvofZs+vAq3h7Q59FyFRDSnM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=cN0ZksFR;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779905644; a=rsa-sha256;
	cv=none;
	b=XtVKur1XlO62+huaniXkOlevfBTOv52USSNppHnFBCAch8wVw2CepX8jGouV/IMLekyuGy
	uSZFVKkMdjLHfieZfZkUSZMXT9CzjV5jjisaHOhKBLGfvS7bVegSgIwOC8zsbAqXLE4WrF
	TAD3DV7SXM80ZsAux+noadbRYFLKcbM=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-5164dafcf97so119560621cf.2
        for <linux-mm@kvack.org>; Wed, 27 May 2026 11:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1779905644; x=1780510444; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LwEpKAm2YrkE7cJAsX+WvqoYg3SlwB6svvqQQHAzIiI=;
        b=cN0ZksFR/4aCFeFJFE+/g4DVY7FWj5VUlhaYr932LSMQTRmSRgRy0m/Q9UOwtXvqK+
         T/34R6FPBtcyIZ8RyGl5d0nCzj5DsZYr1bl8H/1LnBsR1SatPDLOfXr85tfHfwPV48tw
         WiSofa59PSmUfYWCVGgcreJjBsM1T12E9BKw8eCiVoDcbJ8PeGMCaw3k+AWZpTnnUKAU
         gU3fAcud7rtzkGZhhYTM8sMbKkN1bv5rIkbWNYxK1Y0kejvYDTo2bRI9DzMA3TZDulTL
         st8OmHU1rahmqUdm6yrGqYF1LegE1B7yB77Cf7oM9vFCJLLEwnfeZ1NT2j0FETF+DWN0
         MQ7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779905644; x=1780510444;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LwEpKAm2YrkE7cJAsX+WvqoYg3SlwB6svvqQQHAzIiI=;
        b=Xbd1yo8CdBlaylmuw10qjo/sJyOQjT8ynz9q8AwOuXhmf7rkBNKAxDcQg4iN4t4iar
         TFvjPfpzWTS4wW+P0mc8u89VBhBPHVcpBHLXbcHNyXX/wP5cqUtfV3/GF+VEsRd62prc
         umn7AWB9tdrguRf3sg5aX46+jNrhfgPhYVtleT73CtExdZzmHA8yTrbSrSFVB7VpoRKI
         dd5Cme4WjIhQqfH1tEfCTwwZc/bdHnmlt/MYPq+t4eRMVXuhKbXwGh4g1ennvyBGbRlx
         YlMuAx9019FlrlxrakxiuluEoTfqXAANh8b96D7wXLmcA/gHvVurhBdC4rQyGkkaZkq9
         ND1g==
X-Forwarded-Encrypted: i=1; AFNElJ+4maaqm/RpXVEr9KkFbhNzwjnlpvI58ZqNGZbtJ0kMo0PVD+hKYFAoXB/N4f32VwOXao3sVSrDBg==@kvack.org
X-Gm-Message-State: AOJu0YwKWraZ0qxLAs/PYuWlekyC4/tXy3EUGUoG/yEe11UIeKBd9QV5
	VL6JFva1ZIjhA8BwCh5dnCUspFM8QPSCcD3VcxqJKD+MIjU7zsnHn0s02cPZdVE8wz8=
X-Gm-Gg: Acq92OGu9/rxW6lsWJwI17jN9Ksd3C6esMLGB70jDfU9zdy5Nwo0Vmz9WAFW/24DYN9
	goF17hAwZsYejkLDW+xFIpVwJ6+ygfpl072mAtF1afsq3x6cA5tXHfxio8MVBZ0xGdEn7L/yQi2
	sdpZ93edtn9reZlgvNf++/D5vekOpPO/YFFtFQeZegk2S0E4zC27rknU+YVIuJP6Zp8qgHcACEA
	5D2J/Nn95+9s0Rf+ZYyzlkX0617cMdUiX3KcV2XDIKOI999KH2qSxqM339gRVM/MsLjF36uIY7C
	E+MVvtQsCyyLcidU9QLwbA01Fw6RRpOJQxKY0inpnbJ2qGznEykduBtcTUnA/55Pr5/gx3k0Ikx
	YPG9fIbaN0XwjIHGU1uiXOn36IeTSa+x58LLIEIG05/QE3PPzVvL8Vyl9P/lBGOzxw1R4S1eBCj
	nPWPIJNUXQN5sMd6zXszZ5Vv+q4nD3bfFVQ+9sL327rpg6h702gOMQcNGGWfBqGeU53by/9+Yed
	ACOldztWpCPv5VxTbPows9TmvR6je8Ceg==
X-Received: by 2002:a05:622a:5c1a:b0:516:d66e:7b20 with SMTP id d75a77b69052e-516d66ec055mr308788571cf.36.1779905643537;
        Wed, 27 May 2026 11:14:03 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51706af43aesm49228561cf.24.2026.05.27.11.14.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 11:14:03 -0700 (PDT)
Date: Wed, 27 May 2026 14:14:01 -0400
From: Gregory Price <gourry@gourry.net>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Byungchul Park <byungchul@sk.com>,
	David Hildenbrand <david@kernel.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>,
	Jann Horn <jannh@google.com>, Kees Cook <kees@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/migrate: find_mm_struct: fix race between security
 checks and suid exec
Message-ID: <ahc0aSxLFqaZEvOb@gourry-fedora-PF4VCD3F>
References: <ahWxQ3JxdR5ff2qf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahWxQ3JxdR5ff2qf@redhat.com>
X-Stat-Signature: 1ibrzypc1gf3tjxm3rynz7fpnxh6a9n8
X-Rspamd-Queue-Id: A35C2140015
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779905644-634760
X-HE-Meta: U2FsdGVkX18/KcgofhlG+/f49TkDJCNQnS6lhL93ZYDLEqENeA4L8BkTRl404iQMPOwMt4GE4/ZPaRdK+RfrIRSES5W36q5L1Adk1UyfHKW/9POmEx0hJSk8cbGqbxyS00PzASyuD1FA9q35I6xa2OaSKH6F+VWjhuPEO0qmjZypu8Ka5a78Rs/UneEsuLVTRj+wk0DQs15Bo4pOaQS3nPKTp/MN/WjQXHFcLNQXlKQJn5fSh2zwbrgNBhEI+I+ekepnF9XISUttpJ7zNZXk82Fao9/W/rqhVNCAKD1o956/hQ/UIYKqT24ZCVXRYKllnRHTTIDJro03ZwpymxGU+k49M1nqx+3kgf/MGnK4f/CiGEB42rlW8zLCKqHa7djaMBVCnqNSpmhJBPT22BN03NBBEBU9h87ziuW03TmxpbSH5qpcPLGZKwPNuGfMrziRZG/Shnlg1BIvZVjgubEwknr387X9kYrMP5AymsGxfBQ0kzjgyOrBtMhNP8Nm7Df1EOOqHtP46pFUxKTNx0WSS0pVMrH6n7eHz+k6/bU5EWlFHxLVhTBdIrY4M9YU7z5mDXsA3boyIvDtGT/aGnL1p0XGWX0sFMD1YsOmUqpErhWcQCv7HER0FAaYydhK/W+8QRpQymjLK6yeGz3omVbriZBwyGC4JntzX43QSN307FXNVFbs18BCV6k6Aj2W3nnM7pv6+nVhmnnlWiFUY4VPntLIFhz0RKHx6+0o2HaUeRF/ON94AVnrDTP6668ZJ0octozDXsDrLsFsTXeu6F5roh4Vr2GoWPIwEKcQn/D0IFBwhGwGHlNTU6GiozjW5agSvA3H7Yyuuxg4JcL7X3Op+w3lsLnKScODaPYU3tbwGxYKnom/VwBcpUR1WKH5FO/VP6w5L71KyzJtUjNL86Sd6v5QoFto4fJB7pm4SnYMWHJHekqpcTEr8WUzi05SGlOSGJjhPlBdiPfIp4cnHvS
 SxSPNXV6
 iGUFKuHwstMFhLli2H73AJMIcIEpR5uplH64Ydxaz8sfXUNgL4xvGgm+UwOrQn+uKnSc19Xb9DSGIAofJ4NH0OlQwvi2ml0lmQvDvHQ8kQ+4CzNBNG6H31BE5W/mqntLyuh7cVYw0skIz0FQ3/0Jw1gR8dW10Ac7v3FMt0reX8uMQs0qAu+oPgRYzXRl9zsEAXPYSe2mrkNTRmMVu1AMxpDsYUqvniF6D9wYUB13vWLc2LZqJ3wqJLHvWVotQuNjpVsDXoREhGgQQcgDQnRfTUQcn34Qisec7PhA3LG/5xiSq/x+gzx7OEptXgIMrL+eXyoo2V0+UO1AqVgGe2XdG11XPlucQUdPZHl8GzLck2iSo7D0fO+aO1fvJH5d37ab37FWxYsJFUhYeIog6V3M0ooLCrKPsCS74btppSU6sk5CxQzqx95LDFAnol3qsmhOAfx8NLC2IO+R+OEjDoeMDUuf9wSwuzRKrUSgGNdb4xeZp6L1SAFUCD1Jo8bXGEs/oPeWrBGXl2GQ6zPUrv6MVm1vhsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 04:42:11PM +0200, Oleg Nesterov wrote:
> The target task can execute a setuid binary between ptrace_may_access()
> and get_task_mm(). Protect this critical section with exec_update_lock.
> 
> I don't think cpuset_mems_allowed(task) should be called under
> exec_update_lock, but this patch just tries to add the minimal fix.
>

Claude suggests this is at least safe and the correct ordering, for
which there already exists code that does the same thing:

   This ordering already exists in the exec path itself: exec_mmap()
   write-locks exec_update_lock, and subsequent memory allocations
   during exec can reach callback_lock through the page allocator's
   cpuset checks (cpuset_zone_allowed etc.).

This is inline with my experience hacking on page_alloc.c and cgroups,
the callback lock is always the inner-most lock - so lgtm.

> Perhaps we can later add a common helper which can be used by
> find_mm_struct() and kernel_migrate_pages().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Reviewed-by: Gregory Price <gourry@gourry.net>

~Gregory


