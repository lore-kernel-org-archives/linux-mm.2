Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCBA4606A88F
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 17:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=aigG+GhV
Received: by kanga.kvack.org (Postfix)
	id D5FE16B05B4; Sat, 14 Nov 2026 12:41:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEA526B05B5; Sat, 14 Nov 2026 12:41:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD88F6B05B6; Sat, 14 Nov 2026 12:41:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 971DC6B05B4
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:41:25 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1F85BA0409
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 17:41:25 +0000 (UTC)
X-FDA: 85434441330.14.EC3CBCF
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf06.hostedemail.com (Postfix) with ESMTP id 313EE180007
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 17:41:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=aigG+GhV;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.181 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794678083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Iwtan+mCqrD8UTQ6kqOmC1YvXcL9sNkfoLvCTyQCFDY=;
	b=GyPY4HOD1LD6Q0tntuQKh2KxXmGHXVhJ2GG3gFU1Z0aOfO25FCvh6B3P1+eGNz0lFLtg/S
	OGy7j4vyvcW48us6eXBPd8OSHpUvlIrhvPBWpFGcpB8uhSOpwUsQqA5XvPl/Sgt/yEqA+d
	8z4E7HPKeJCv9dk/OMKKbH09ZxFNuJ0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794678083;
	b=LMEy7jksvmjbHgQgw7302zdovd1GDEyWhlliYggfu0raziKHiyLigAzDOsLJBYVTP4JY3Y
	+0hdi0G56baM63kOG/FB0C0Y5UHM79+V6+kSTF4HpJw/sq+7qaISve17Du91/YWR4esIbx
	8vBo9fv1X8FRuV1MCY2ZRz7OLwJeCyg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=aigG+GhV;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.181 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-55c4e670fc6so5446511cf.0
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 09:41:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794678082; x=1795282882; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Iwtan+mCqrD8UTQ6kqOmC1YvXcL9sNkfoLvCTyQCFDY=;
        b=aigG+GhVkNtUwbAwkePhiyfuwxkmd4LxS9g1WQdtc5A8O5uGQxvMXc3Zj0lEC+X8f5
         nf9V0KkqdRfwK5oZ65zXz+I5DT7zpQX2+io7YV4kMMdkPRqrYg4XtHxmMrQcaa7TTT4y
         dRWHpmEcX8wOKza2dZ9DiRB+lQikAUfDTFhNIMj0ydB/lhq4bHDndov37XeMztIQ4wE9
         m6bOLTgPm//BwzMof7mUe/c7ojNEGlMN6uZ+8rJ//oGh4T1M4I7GIz3hVOaUh7P2gjvp
         kxfHOPPC1QsmN4DWKBXtHrywF5cY7v8CaDjIiRU7pbWjk4o7kfCDL7dNb8pt+HoA2TtJ
         0UJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794678082; x=1795282882;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Iwtan+mCqrD8UTQ6kqOmC1YvXcL9sNkfoLvCTyQCFDY=;
        b=uW73c8OlGDf7F38jz8QI+krSRWrdsH6f1blngSkBS/5o+tHYqGhQzciYRGhhbd/zXs
         yiHh8viVy5iI7Dt4ArDKthWeQUr01KAUaD/i8/FI0llhTGh3uZgaf4r1sXJmeDlaLir/
         QtFO51arp0rC43tXkhH50y5ATTEb/0DZMDpzrfn11x7MopYkHDDaoSo/0rBJROtMsjWZ
         U5dvsJZ0E6SoXbEmrkHfPZr/qnFPJg4RicbWKbabr6kvCy9FomWsdHA89XMiYn9ucOPs
         9mX6rDlx0d9rtYJ8IC5iWjwoycs3O0crfLXgiJW5KeZyvpFztMo3AnHmn9fUtE+XIqPD
         Zflw==
X-Forwarded-Encrypted: i=1; AL+hErHSDlC3ilnD5a47igKE9ZMcog74Gf/TqL839BrSd23PQtnfZs3e2Nh8yOekbmcDimnVqA1OpMgNBg==@kvack.org
X-Gm-Message-State: APuU4Z8f7SLlbgOVBIlosJacK9JYOE1DNbHXDdCf275Uyt4PLOCBeTRi
	Ty/RgUkRwCxwuFg/6ZiedSs8GvrV2WgL2SWxLKUD4BQ4lJbWoeHSXTMDj02X3z9v/9w=
X-Gm-Gg: AYBFou1NWJakGIfePlONPWjzEDRCuzViEo7lT54YOXuDs56Ut+R9umDlG6VTWS+gRxB
	CPBB7GNtsDqyfWBLc/63kzGBwrPdTmtGDtnUpyITcWnmzhhTzG+A3OnsLatp/Qw6HkzLfUaHszI
	pgFVJNFom9pluxUPnTUqscBMVzBrrRRKGjaHFzus5spw6pi71B+/bbBPz/+1pUwGlVEKu74/vm5
	Th8fTXBg/CSablnnOnzHtMSX8Q/WSVO+gNE+MU+MQF4S3r6WstkGZS+EAx5xzkPgz3M1Bteti7W
	gFsc5MAzQUQBSf6hHhIxI5tyjBfSdSGHuHejMCWZVylbWhGw143jAdcD3TRObsDyNEqW8sIP88p
	gWTZ+Vc84Afd+AWZCB82xU7Rp+9xmC3jvkJ+OVOdPkire71oKWmIKkqpGDuJ5zM7qD40BMdqpt/
	sjtkvTIupOzHMhClJGz6yagPPsgci4u9l8PV0yYBQpDz5sPwSv96gJ295cAxmEoq1LXDwrcFpjB
	Y1/f470Wcp6Kz7+eM/t5/h9kcWezaTr/rIkioL+Dge4DI83c+Eou/GKwUWlbnuUPci68Q6o0ibY
	Xq03aQQk18AnSgaNC1ouRDgsTP6tORhT6LDZKY8j5JyJbdgpLFVAybq8bGlOW42DKOnCfrtVPGS
	eYlVs1zpZGHjc1EIxDRa9DmLg9L90ZA==
X-Received: by 2002:a05:622a:1214:b0:535:a5fb:645d with SMTP id d75a77b69052e-55ac9088a47mr98240481cf.72.1794678082332;
        Sat, 14 Nov 2026 09:41:22 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55ad15eb7basm44690811cf.26.2026.11.14.09.41.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 09:41:21 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 2/2] mm/mempolicy: limit shared policy ranges per inode
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
In-Reply-To: <20261113-mempolicy_limit-v1-2-16688b2644dc@kernel.org>
References: <20261113-mempolicy_limit-v1-0-16688b2644dc@kernel.org>
 <20261113-mempolicy_limit-v1-2-16688b2644dc@kernel.org>
Date: Sat, 14 Nov 2026 12:41:21 -0500
Message-Id: <179467808112.482102.13365594235443107281.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Stat-Signature: qfztrm6sty8wqd8gqg6rsy9y6zzgm8f1
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 313EE180007
X-HE-Tag: 1794678083-549131
X-HE-Meta: U2FsdGVkX19wEOkilLJbdAiQSO2cpBJ41BNIPJTURZUqbJjRpvaFwxG1ehY028j4pSQTsPGQKnDmKU/fWrYOXq+xwCrAvKnUuMlCm8fHbsFumMb0R1QDu/qzGbb2hmM5vUc3KtSbcyv8mce6J/qQ8bssca6vvn/B2FuUrQ4jcAj5YnS+xORL5cBt/Hfw/NRADQjLf2RNVqdfKeyB5fVLqo6jimGNWsVCrgOn6fLW8gtsNwxMPu4Ww96yKdSVRMPdqlWkbFyPpYU9sH3A4pQgO3UaLOE1APrdoGnBsx1CS1y2yOOQA4Ub8+F/IQdMzYoJGAW40V5LMR1k41/U3vspL21NPDftrYIMoTfmJk+7vi+GKVpWtgNfbjFhWIHSrSRkWxmHYR5tAtujEkmUj5q5iF2czAJgphDwKM4K6WTEkwGpJBhejuYWoXmQblHBchxZ6+89xhGhuUum8Ww1xONRelFtugAq4mYyqvRRTSEa+OeipZRDqDSt45vpTHvf2605ctNLKqPEaPytxdwLA61XrlRTmcYblRT+4LEwvTMKniaz7rxnLvN4TR7LtD+UViVq1oIfmEZ3GOwbnsvzDvwcsiFYbFMN3mUOLjBSo2d5Kk1khS833cxHxQhMcae8nKpMRykXwuPdWhNKsOFhkZ4xT1Wf7dW5yoE9dacox/ZycPxZ17TkJR0eR4J14Nn5IIZuQL6h0bv0Vcy7UbBT5iCPDqedXL2eyzWBSie3H6xDlLFdz97DA8zDdgpChpNqfOukdc6Ljm3oC0LdvUJ7rhW3KiZcmn03s0ohfuq69d5ZQQJg/3iuk6uBP4PLImCaTPqMC9tLNUTRV+Q7p3X9DaFZTgLZ+L7KeUPBq5/ve+AxXm0pFmdDoO2ZpdJJbfGTmeROusEJolcOy1wKfdQT5e+fl8IHyo9wmZF2+6FTMDwIzMOZiBZdr65DGrb4jipGzTUrHCvezjzTOj2EeKl9+ny
 2SKrp2/T
 sROK9vtl6rySHIfhls0FTeYCHu/lA1vxhpWglweOC5SJf6jDF26gjKSR66izS0qfvRbXMBgvPdrMfkNReMl7NyJjB9HL/oB24UjtO8wgaYXuMuife0rj8fVzM/9KWYw6IDu5/qOSyFCjiRNunxsn9XCbVdAl5mnsOMmSPmErx/E2aBp11gRAVBPrJtJapBaj5um7HFZR/AT112aYDfbIHZFHW48BsS7B8wXSYJk1R3SyhVMPwfbv0C90mJEJNmM71RvR2wtY04MPbne8Py3KK7dlUeup0l3x6h9Xpbb+HTuq6tffMypRr2BWnp6ahkDHjGoH/aPJFzJ1HtCbpgvwtEdmjbqU6NYkDA3IB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-13 22:36 +0100, David Hildenbrand (Arm) wrote:
> Shared NUMA policy ranges can accumulate on an inode after its mappings
> are removed. Currently, these nodes are effectively unbounded (even though
> the allcoations are charged).
> 
> An unbounded tree can cause long rwlock hold times when replacing or
> freeing policies. Instead of trying to fix that, it sounds more like
> having many nodes is actually only a scenario for processes trying to
> cause trouble. Most use cases will probably only use a handful of them,
> not millions.
> 
> Add vm.max_shared_policy_count (inspired by vm.max_map_count), defaulting
> to 1024 ranges per inode. Reject updates with -ENOMEM if they would
> increase the count beyond the limit, taking merging, splitting etc.
> into account.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>


This arguably breaks userspace.

A single mapper that tries to set >1024 ranges would start getting
-ENOMEMs unexpectedly with this change.

Multi-task mappers were previously unlimited, but that seems like more
of a nasty unintended corner case - not a real feature.

A single process is already limited on the number of vmas/policies based
on `max_map_count`, so it seems natural to just use max_map_count
directly, but I took a brief look at some distros and most seem to
ship a raised `max_map_count` (>1 million) by default).

I tested that and even 1 million can cause a soft lockup.

Not sure there's an easy solution here, we might have to rework the shm
policy locks.

-- 
~Gregory


