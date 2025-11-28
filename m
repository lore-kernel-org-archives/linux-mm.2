Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22AEDCFD376
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 10:18:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37B786B0023; Fri, 28 Nov 2025 05:18:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 353726B0029; Fri, 28 Nov 2025 05:18:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28FAA6B002C; Fri, 28 Nov 2025 05:18:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 193806B0023
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 05:18:43 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AC17F593C7
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 10:18:42 +0000 (UTC)
X-FDA: 84159616884.03.D0C07E5
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf05.hostedemail.com (Postfix) with ESMTP id BF8F610000A
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 10:18:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ntVwtbt+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764325120; a=rsa-sha256;
	cv=none;
	b=Lp0VCGzbur10LW7LwKT8Sdf3gBL+mK+yrSpvw5s5MkUugirhfyaWXrAY4b2Ps/WTxKlx83
	sgFhnmK+iSWsy5L1PjF69zrqMXusHg4lJVNBvaoHfbJ77xcWosKkGEgpoMDS3Fk2kyoVyt
	inGKV4XMWYGQ2CS4q0R62xlwQRbL+hw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ntVwtbt+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764325120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=xKbiTeUE4R3+lfUE5lplRGltmZWgZb40ftgeIyEu5hY=;
	b=QX9Zle44uFYWO8rOkKA6kg+gNCyQ7I6gQerodwAOoClx66CRUa+9UfLhz6iBFqq8wnsH/1
	kBXOYeImmzC0H0961415okyVFu6qeUHNIMW/iUHI1gWRgemqFiiYYePDZstVa0TFGQLIhk
	8/Wo0PKBIAbYVuVCT+pnziy/5R2c5Tk=
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-34374febdefso1841442a91.0
        for <linux-mm@kvack.org>; Fri, 28 Nov 2025 02:18:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764325119; x=1764929919; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xKbiTeUE4R3+lfUE5lplRGltmZWgZb40ftgeIyEu5hY=;
        b=ntVwtbt+fvWPnTTe1G+jhJ404ADXT1AhtHB/yTjl4tGbshJMHU9Pz/vFVZQ50JPx1D
         cXtzIsAaH9tc2rVET9081xlq1Io5/yna8y32XiCxtMnomqA+hb1SVxHJGwS/ylnX6O1I
         OJWkpMvW67W66pQ1Q6qBt67aKFndGEgNH0xgy9e90RfziOJyxS+v8ghIBJ0EL3tBAAE1
         F/nG2/5WdYdvtn/3BE+ygvNtox7IbETlWFbnG2qb9Z1rcRWCr9pkhxi8DGVPtaZzkpY/
         xzX1jVopna8SMKNnFNPWQlip2xSWNAIbTKGxCwgXahC/PCfGQIKDA5WyR9M/ojYoqzQe
         95vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764325119; x=1764929919;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xKbiTeUE4R3+lfUE5lplRGltmZWgZb40ftgeIyEu5hY=;
        b=NCDNsv62uD904Rvliz0Uj7hsiniSjozl1fjBljBR09Ud209EmlaNHPAqnwJCP+XIkv
         Emlo3URjaCC/NOF91+glEDq5feDAB2S9sTGe6t1+gzfkcsRd9JC3l/SO5n8YG1TnFNNd
         oiIZiozocqK+XaJzDv0RuV8zwNLpo3Ws3MVfsmxmptew58dris6uohEvzRu1/yE9L+ce
         vqddk9qs8lDD1GNo2zPTPEG/3qmalKX7F4+uOvi5glc9lnaLZL9tJlvO/U3LAXUwuOf7
         daB7WJzrrIuCFUyUWKyWQpOAYxS0PqSCwOCtmV/+XGpW1Zg+VvDmOiaErv6vR+bOrlQ+
         KUYg==
X-Gm-Message-State: AOJu0YwTT4M2XwYrGkGQAJUvnS4zsHNBnx0tSj16QZvQSdUj5PznK6WO
	/88K0is/AHZ8CPiqRizsoPojRcj0wgSWlrzMah8+LnpO0wzKBdYluCfDqyOBoYdQ
X-Gm-Gg: ASbGncu4fn/WYGlLHFKlzxrAzRWx1eNEvuZ9Jo09RysA/KgO+flKcSd6VWvTMAFa0ak
	7dKDyWScfUoWqYJUUCr+BEvO9g9P//lZM0A7ewoc+PE/aCh+EY3Tqn8PWkC2P6ETRJ+P7E0aST9
	mDkgcVnuc3axmw1w0WLXp+g2CUOM1VFm4tJZQUrdBsA0LdDTjTIadb8++cXjnwRjjGWE+E1pSMA
	LiXf95QGR5wTj7xCujukvXb0ItQbGzqChxbikl5wuoMH81SMfrUw0y0SiFPaO2TbE6NFhzRCuCI
	eyrbPPXfBVj7lR6bPBoRhHlpKn9jLZDchjzqQSba0owaTCCpoHVYj/az2qtjSu7pQALioRsmBTV
	DRWlj9rFcFqwL6+HwqzxvY6I5Y6Rh4BHnzDSR81AZ0EXoNJW7zGmshK71jm0LFm2navvcK0QOXU
	4mHT7ztg==
X-Google-Smtp-Source: AGHT+IGge2gq0mku+sItZjWCM+QW1VZVA+myW1HYnwoNnxALy8Q8T5+kveNTTgNppIT8jE40jNKyHg==
X-Received: by 2002:a17:90b:3e87:b0:343:f509:aa4a with SMTP id 98e67ed59e1d1-34733f50568mr23997342a91.36.1764325119491;
        Fri, 28 Nov 2025 02:18:39 -0800 (PST)
Received: from dw-tp ([49.207.234.175])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3476a7c2ce5sm7999198a91.14.2025.11.28.02.18.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 02:18:38 -0800 (PST)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, David Hildenbrand <david@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, stable@vger.kernel.org
Subject: Re: [PATCH v1 2/2] powerpc/pseries/cmm: adjust BALLOON_MIGRATE when migrating pages
In-Reply-To: <20251021100606.148294-3-david@redhat.com>
Date: Fri, 28 Nov 2025 15:42:00 +0530
Message-ID: <87v7iumpov.ritesh.list@gmail.com>
References: <20251021100606.148294-1-david@redhat.com> <20251021100606.148294-3-david@redhat.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BF8F610000A
X-Stat-Signature: skobwb4uw49di7pazd3gkiet6rwmng6f
X-Rspam-User: 
X-HE-Tag: 1764325120-268545
X-HE-Meta: U2FsdGVkX1+FgTnbpOMYETtBjOD51NiIFEJo8Zsy091ORqAvYR1FquR1cMvjDJXNw4ZcCycX228iZT5nfsYg8MDiiAfrRe4CnnblMU+bZ6cc5+/eigYP04xIy1g89z5AvB75SzzVsvCmjbRMkg5wwGCSv3n//YsxAEVNmnU9zbFoqBOLEYKnGB2ge24EXKEhqBfYrIOkdUIoCXQ/j8IDkjTGuRnSG53eAHo6h5+9JSDpY06BupQebO9FWZ0dp2v/Dpx4JxsP3RWSMdlOj1teETIVPgbULqqNkekPNT3O9cVTpN++5TJkb6L/VDJft62ewKUcLGuDGNQB7JfnAwRPTAkEEcsEs2wg0MB45h9oXrM8KAnDoX/hKh86C3K3zZRQseptvkMVR7x5e6St7tSGyAjJYnWsD53l2ze9ChTAXR8nzHMY3GnB6JD2eeAJxtxDwrsGqD7jCy45nUXETZP38zTEP7GG2/LD9AwsiUPLxAXbVZhMFKl+szdyyEbuZpkYTTI2+MZ72px+TWoPH5aE2IGtdsZiD+nUUPE8UlgZHzQephZaooQIUNsf6Znwjz0toV5EMtWvoI0fCF4negGm+zEa8hyTknLxXUPBZ72GZLnAXXryuP1Zicavnh10UnC/rpPXIKsJxs4V3b4VZvcIHrkDfJxIDJ+GCnuysCiQk+TAVK1gRZPVFgKqDaUo1XeKTfWKrB4TSPmn9skzMDyArr4GCiXwOH83QXRhXGA0m2T12YJa62jMo/+G3M//L5UHMiPCphpyzTdt5XRuaV7/DO09kMEF4+PuMv6B0xBmK9ZSdberU86b+7t9wvBB/Ch2QGRd4N2ZmJGfvPJ2zfFVwMO62JarHcoJhxpEEemgCSLyJB67dCGpwGXdm6oWw3HV/6IUXPnjf5apRnm1JzyXaOGXKuY0dcdvIlXPE90EFMifxxQtiXeumTdVyIc/NMgy77J86bRbBSrlfZ61Ku1
 FADxHbUx
 AgARKTlDJX/J8zIZoGcEWLesv+LRl6ITGKv1YfLAieUEioDnGwPT8YPTZ9ot2E3GeiTyUx19kQt+ckDN97u8WTy5d/+VDvD82tSEo39tVNKnvwcP6f5GhAUMIFXfTNJlUXjlDM8iqPE55gnS6611AeyEIwG9rIHyjbQUACKaNV7T7EOsp+IXmdeKEq4/V7qKQPHqMUvki6uMQNl8yX5Ap6moYg23XNtcNTyvQQZLFwgoz30ilP9aup+zQvKF11CHdawSbWnxKK2Kh8Am26JVfIiQlgQjyHVoCNhp2lX+stcB/cY48OQA1vug05DZ2UOO1Uj7C3prnh/Nbzx4xspGs5C8oXZW/WmOGWSW+aWTcV+dfYxw0CrG3TIeFAmmugTRVIghQhvCukbtiZxqqNZ5CCc5i2EaPEi0DUpvSlXs/gIOr3ROCKv4vJH7mJOfoB4b5wGWhd4AOBQmYeaofikzp9JXT48cTSLG3WlW7iOkSQbkgPH/T/JHyAyiYDmC3cU9r1FLoYzvKx0e3m+Z3puMIY45kfw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

David Hildenbrand <david@redhat.com> writes:

> Let's properly adjust BALLOON_MIGRATE like the other drivers.
>
> Note that the INFLATE/DEFLATE events are triggered from the core when
> enqueueing/dequeueing pages.
>
> Not completely sure whether really is stable material, but the fix is
> trivial so let's just CC stable.
>
> This was found by code inspection.
>
> Fixes: fe030c9b85e6 ("powerpc/pseries/cmm: Implement balloon compaction")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  arch/powerpc/platforms/pseries/cmm.c | 1 +
>  1 file changed, 1 insertion(+)

Make sense to add vmstat counter for BALLOON_MIGRATE as well.
The changes looks good to me. Please feel free to add:

Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

