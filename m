Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED149D3B7E2
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 18:15:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E6B96B000C; Mon,  8 Dec 2025 13:15:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BED06B000D; Mon,  8 Dec 2025 13:15:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D4766B000E; Mon,  8 Dec 2025 13:15:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3C1056B000C
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 13:15:30 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0652D13A336
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 18:15:30 +0000 (UTC)
X-FDA: 84197106420.21.C628B88
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf27.hostedemail.com (Postfix) with ESMTP id F37DD4000E
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 18:15:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=TdXKSt69;
	spf=pass (imf27.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765217728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sln3pvwp5otYUxdpdJdgmati+eSU2RmuymTJPmoiQpM=;
	b=WXICMtn82CIhDMvq5r9QBNj95uAQnQPEAB8NSmlk8SyoGChrxLUH7qGa4FKgRAkXeszgI+
	8jf92UEckG3rjbHQmsh4DmNFV+LR1JD86P93kLLXSbj6WSOnmu4I4cDIr1l9ZkwtH4atMw
	jCJh6ycTkbf45buPla8XnBIV4lGCR2Q=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=TdXKSt69;
	spf=pass (imf27.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765217728; a=rsa-sha256;
	cv=none;
	b=iXfxz7+iUKm5/Nt0jT4abETarP//Y8+K/+4zCYPt7z5s9Lj3IcyMPS5SGkEUDIQ+nLehHj
	kPSoq/NgflRU1oWy0CRr+/RR4rRTtYY3NqO/WqZBg3wYMUEjgSgwFNl/YrNph4PAUn8Rzt
	at4+1AGtPVJAgUPJ7j1i3vAfiR1ILnQ=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-47789cd2083so28837345e9.2
        for <linux-mm@kvack.org>; Mon, 08 Dec 2025 10:15:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765217726; x=1765822526; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Sln3pvwp5otYUxdpdJdgmati+eSU2RmuymTJPmoiQpM=;
        b=TdXKSt69dkL/cq9qv/k54XS8goBlY6ariis4TT36z1EuL30LFG5ja3I8514Z1RR+rU
         K1xilodGCO3KVHDVgq4DYCxF05lfKU6qPBCRjzxUgUgJZi7LfUaBi35rgSCaAyo8KYeV
         KUy+IaAzXxCl6/IMBe/u2AIm1VK2aBJZjVaok6dxxnyKkGJR53V8scvBiVRVrvazbRUr
         Hf98XN0F5fAD3YwK5oSmczGXEz0wJDNr4h+UVEYWmx8wGi1uX82VfaeEUO6PkAT+IwI1
         8KQusLzxyW0t0vKXzllFP9c06y6IUlMgG26kceZiWiY3yYLf2lJlG8H+CsFm019rtX4x
         8X8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765217726; x=1765822526;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Sln3pvwp5otYUxdpdJdgmati+eSU2RmuymTJPmoiQpM=;
        b=woY+MAlJdvmjDrVUQ719BQBN2BlQI1/+Ce2kylUVff2XQo74n4DviegaA3EJoMFP0e
         0bqRfKR3vqs5SfgO1uXXhkvJm051ODbuW7RDrO7dq+RRdco9Po3UObzvYtGJlrBNwEKe
         PPuiqXvdkJriTqUVlf+Dx3JggkY/l29gbNfPAa9l9AWsM1zzumRCuXJIASGiUFuQZdzO
         4oAteHGnujtf8YdQTn6FfeczxoGYlc5XRAQeDVY2cz27UkxQBWkZhD7zTFlLY3IsrkGq
         aP0yAPhst/4KD30KDgWcy/vVoMByjsXyvzftZHbZGcNaDO4yYHEZI9VtORiBGdaOeZtP
         Agyw==
X-Forwarded-Encrypted: i=1; AJvYcCWmS8uLvmQEUuycBQcf8MOkXhCnfzUCXOjiKesYTIElqoh/Me11Hwqli4ToUqANTb6h2ArF8EPQFQ==@kvack.org
X-Gm-Message-State: AOJu0YwWZxiG2e3ajmm7vUXQcKNYTPbRSi/OYobFPPzB3EEruR2sloCZ
	oAQI2qrezjeB0qmbiPAqk+GfhQr0ZoKy2C2SQH3LX/rK8nYQo/mrjvEbg0S6/I9OGBU=
X-Gm-Gg: ASbGncvdOFqZEIbGEvQ186Uc6Y1CeWYRkpTNQXHljWCCG+finujgosXWfNCLm3eOtsW
	4u9cztsjTLjdmS55nzRmlM+FWihOhsnKjIdoHzOleQEyf/u5/RQv4D4S9iEv+qSeAZ+b/RKdJkj
	GmDeLnL4BawnQJOqZzcm2oEmsp9d+rhBk19lbSso5975C3kdianuGElyljkpmhvYUEsyZjCias7
	7nwgwl0TAjSp2FcbJur0zS2WBnwyhNoYgyIJQEK35DDBlIYQw2w7ZgRfTJplL2u3omqmwVVjPm2
	DCWEWgh1WZ/uo2ZcCbQ1r9ApmUfqh8/AnEX+OhsQsesipPn4PQgAUZk0Dsshmf5a2GEvDMIntXj
	AS1j9gtg0GNde/SESUotjjVYBXVvE3JS/qcaEM0jD6W0xPVYl6gw790sdkFpfS+Duy5h3R/oesy
	iOe7Z7H/NDcuEMutOdHWJ+VsdV
X-Google-Smtp-Source: AGHT+IHb6iHzjgNSkuFH91TSV+zJDo74e7kLqQzZaPe0DRxIT7Dej3U1f8bQ3ScB0uEiS2OsyuRE0A==
X-Received: by 2002:a05:600c:4f15:b0:477:214f:bd95 with SMTP id 5b1f17b1804b1-47939e3a6dcmr85980715e9.23.1765217726486;
        Mon, 08 Dec 2025 10:15:26 -0800 (PST)
Received: from localhost (109-81-89-155.rct.o2.cz. [109.81.89.155])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-479310a6db3sm269869355e9.1.2025.12.08.10.15.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Dec 2025 10:15:25 -0800 (PST)
Date: Mon, 8 Dec 2025 19:15:24 +0100
From: Michal Hocko <mhocko@suse.com>
To: Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, gourry@gourry.net,
	david@kernel.org, vbabka@suse.cz, surenb@google.com,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_alloc: make percpu_pagelist_high_fraction reads
 lock-free
Message-ID: <aTcVvMFtKcVerNyz@tiehlicka>
References: <20251201060009.1420792-1-aboorvad@linux.ibm.com>
 <20251201094112.07eb1e588b6da2ee70c4641d@linux-foundation.org>
 <d35eca2bbdf8675c43d528571bb61c7520e669cb.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d35eca2bbdf8675c43d528571bb61c7520e669cb.camel@linux.ibm.com>
X-Stat-Signature: ye5mmnwg53h5f7yhapsi5rcbe5a697eg
X-Rspamd-Queue-Id: F37DD4000E
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1765217727-969802
X-HE-Meta: U2FsdGVkX19jaTXTsvScJcyUKuLvw4KsDbgJhvQqdXoDSIa5PcBbM84nCqGdoIYtm2AxbLU+stCxXI7zuATT2Q2DE+d+Xik7ps+29tlBht+MqNRRRd7/EzIHkRVID1nphJWFKt78ctKu3nSW30JEJQ+c9IuRsCFchXsiDXq4RNOllfowsEXisJNUY3CcMJLaar8PMn0kSMco+ch5hACWU/NXCyIvx/i8gF0mLMw1iPpv+/0Xs7j60MVXHQAZnjKzti3419DSIpgM3Aq6lo5hQ8Kyi1nYxGsOvmFxtNDBZFT+4DdOOwp49FCjjIRmtLZ0l4xk/6aBaeTnRP4O09aob87yERnDK6It/TWmaCgIwy1txNiqOHhvsmeeNVlSY6/q0WMLrQB+Z0vz+BiNJ0krfgVj+XU07iOv9apYMU207knFNus9XmV95La5UY/sAUdiOAgqTIiXwYihgva93pX4DwAJBWlBYe/hIsYW4bGweP0EFIX2vdso3hkJwWzO1cdQ1lsU+JMkX6HlSPaxpCRAvOCaW5wEK29TLAzedASafA8jbdSj15MxTosLhnmC4AuhwhkxrBi3O207/SVYSrTzzcbJ48mOJvyJAew6aC+yj+UqLiD2zuPQ1yk4LV+EgzmxpA1jK6tWBHQffUeyQ1cPPzvcda/dYGwBChpHSnI5t5nyTlHRFYxb9xqoO4fG8mia1iD7olXj3oou3zaIiL76aWMQQ3MVF6BILpfYmq8u64HBLIcptjUAnkRpYk2HbFEg/LDLjpJ2cAkatqzIExt9RBW7Yg0eqQA0eWNKJPBo6hHUA0nznCV5uqDzjk3H5buT/ZcKEU+o/MsUtt4XpB7tMbPM+kp76NGE2tx3r5RyJN8pABeUeeNiXKkytTZ7PlMopEz1S5XFFqQYayIe8YmfrOZxKT5DOGoXTiNM28qdMFPde7U6QRCPDoJVXFim0rQx0Uruuy+9LNRe46eOrrY
 S805iQ+l
 JftoShOXqAdzSxQ82TcWKklAeh7YGJ/rs0r5ptK2oeX7uF3itS/j+Su16VVvXM6fznZHW/vsRphiuEfx7A+p5H4QLWqaCSI8H1IW8FRLl4ANbz2ZQxal8kPssH90WsmhT+7mV2RmH7MrPmojUtQ3GHE19607OYau4YvTx4nZsZetMV/33HK2/ShlLJbRWQ5UZY2ZjSsojegNp+o7qvL/PNVIgRbs7y0EKSodVkdJ7cmKDa3GIhAwg4+CarRIFXkPZoVjFSk2sIDqIqk/R6+VY+X6GPFFuISLCYX2FlStje+bqHtnnrefrvFvQK/tyZ/MokhQr9DAwu8Ci8ZciPNzlm4xQaDnxqkgR4sxujKWD5xQO01+bANLeq/RfhbCrYUG3Eiu10PxU4EHEbLklEbbwD/h7LQYJo0Krxx1eelE/dy3iQHG1yrqgNuF7XsGYPqqSZmBs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 08-12-25 23:00:46, Aboorva Devarajan wrote:
> On Mon, 2025-12-01 at 09:41 -0800, Andrew Morton wrote:
> > On Mon,  1 Dec 2025 11:30:09 +0530 Aboorva Devarajan <aboorvad@linux.ibm.com> wrote:
[...]
> [83315.383433] page: refcount:2 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x4dc68
> [83315.383442] flags: 0x23ffffe00000000(node=2|zone=0|lastcpupid=0x1fffff)
> [83315.383448] page_type: f5(slab)
> [83315.383454] raw: 023ffffe00000000 c0000028e001fa00 5deadbeef0000100 5deadbeef0000122
> [83315.383462] raw: 0000000000000000 0000000001e101e1 00000002f5000000 0000000000000000
> [83315.383470] page dumped because: isolation failed
> ...
> ...
> ...
> 
> 
> Given the following statement in the documentation, should this behavior be considered
> expected?
> 
> >From Documentation/admin-guide/mm/memory-hotplug.rst:
> "Further, memory offlining might retry for a long time (or even forever), until
> aborted by the user."

This is in line with trying to offline memory blocks containing the
kernel memory as seen above. Retrying for ever on movable zones is a
different issue as discussed in other reply.

> There's also a TODO in the code that confirms this issue:
> 
> mm/memory_hotplug.c
> /*
>  * TODO: fatal migration failures should bail
>  * out
>  */
> do_migrate_range(pfn, end_pfn);
> 
> 
> A possible improvement would be to add a retry limit or timeout for pages that repeatedly
> fail isolation, returning -EBUSY after N attempts instead of looping indefinitely for
> umovable pages. This would make the behavior more predictable.

I disagree. It is trivial to implement timeout retry in the userspace.
Any retry attempts limit behavior will be much less predictable. It
could have been a matter of timing that an operation succeeds. We've had
exactly that kind of behavior before.
-- 
Michal Hocko
SUSE Labs

