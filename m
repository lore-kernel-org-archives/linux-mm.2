Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C628CCA471
	for <linux-mm@archiver.kernel.org>; Sat,  4 Oct 2025 03:03:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 665B98E0008; Fri,  3 Oct 2025 23:03:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63D148E0002; Fri,  3 Oct 2025 23:03:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 552988E0008; Fri,  3 Oct 2025 23:03:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 437088E0002
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 23:03:27 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9EF2787F3B
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 03:03:26 +0000 (UTC)
X-FDA: 83958936012.16.52B2511
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf13.hostedemail.com (Postfix) with ESMTP id A464F20013
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 03:03:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="J5giOyR/";
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759547005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A3w0aPrtz6owLHfo4rKJJGMrd3gYAmvp7fLTky+PAPA=;
	b=Z/TpQ8l/13wkAsrHTu97d4tpmuv5nFbMl/S+ZnizAsBFFpxULPHqIOYtjaK1DvXdOmE3Bh
	kf1XNfDLXH7/IOIWu7UalTF6Q0mk7l1RP1Y++sS6aJGGRrAWi09XhcNria5tCpvh1GAmO9
	2gHuYUlwQc5DW1gdeXfGwgViCgsdUy8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="J5giOyR/";
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759547005; a=rsa-sha256;
	cv=none;
	b=VhnBrxpXZ0PjXZKEJvmWFbxD0TxvzolUCx6dFgRqjJOZULqYhpFmQdE9pgQmKiX8Vnd1JT
	1jSuOgHkqw/pU+v6PNJKC9KYtU/yQmR3Kj6rppm+yUMrivAqO0pRMb/hl/LP6iqCoubmn2
	LSjhbYGJqcX1Uw6V4HQJtIXiL2cKCoo=
Message-ID: <a36c9776-d158-4add-86d0-c41a09e4a255@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759547002;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A3w0aPrtz6owLHfo4rKJJGMrd3gYAmvp7fLTky+PAPA=;
	b=J5giOyR/se7ekCKx5d8TRoepFqoYKyM4sDqCkBMDHeM9cIW0yMp4RAR6VjFS9lcB206Qvi
	IK8YfpHIpHsq9thLfgThvt/61NZg2PZ0NrV569eO5F40KoDftwQ9QVhMGSWTBZUKpvv9Sj
	/dNa8V8JMS91Y6gcFxNwtcL5OG+VUSY=
Date: Sat, 4 Oct 2025 11:03:11 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new 2/2] mm/khugepaged: merge PTE scanning logic into a
 new helper
Content-Language: en-US
To: Dev Jain <dev.jain@arm.com>
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
 ioworker0@gmail.com, david@redhat.com, richard.weiyang@gmail.com,
 linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
 linux-mm@kvack.org, akpm@linux-foundation.org
References: <20251002073255.14867-1-lance.yang@linux.dev>
 <20251002073255.14867-3-lance.yang@linux.dev>
 <0d55d763-81ff-4b99-bb13-3dbb9af53cdc@arm.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <0d55d763-81ff-4b99-bb13-3dbb9af53cdc@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: zszhqizt81hyeih77q5am4udouzeed3e
X-Rspam-User: 
X-Rspamd-Queue-Id: A464F20013
X-Rspamd-Server: rspam04
X-HE-Tag: 1759547004-394397
X-HE-Meta: U2FsdGVkX19AIhjhLIYRlgrueerCWcsYHmSHs58HC+XyeD8DR/FK1xaazd2btBTb4P6+3QsJ7va1FcI/tRcsp5jff5FV20p9Gyen5LNBUb4ZqeaR/vukbaQHNaPvu6onFATz8amlK7rozxlq3Bg72rVnRtU7s7jo6zrnWE2cX5LbY36DaoBQS277WOEPL9lPiMK/zoBNkWXGEXlgYQ0OaD0/0RYjCWZZKM1soieE4P1svxnSLOH5JhbNxFwMHccdqG5qcpYbJf7hXsaFTCMz4MP3wyBdyHtvOFwgvyAeRn0u3QHx4enunm69638paYPPLF81fjyqFHpdYC4mfG1OBy1gizPz/9cR3Gz9F/Q+z/CdY1b7a3LgCbZY2hHSryXljPmO5LzdhdvgY7CcVcqAV0tReEFtXHoTttbuz675/gkbN0z/pS2XBU3f7KzOVORKx1LDe8plSMf5/GhIQ98HAZcGJqch3PSwlGCbkqjURRHH5KtkElWAR287A0IWR7SeKmo5M4M4DCGDw2wwNzZx7tJDpg6lMfdv3GQTeeU5Y9m2F5mXqApVRpT3kwo94+HjJRbLK5pVpj9u8nP67akWBQLx6Tbkl3y6TkOI1QTejy9p2Ww5bUY0iKp9OOnfaKT44a3r3W76wffpxHIUd3ATb1oUHPW6ia8GlLN84+RwkLxOtfiifFRnKnvrfpn3B+3k+2F1fnXcQyQQ9in8ssonj7IhFN4UuWpEgK9i+NI0eod7VTIYB/Kq00hmBHw69WxFYBE+CLJHiJpBpVuV0HtR57QqeikC+AZdPhupoNc8cjz70RNOsdy/844AweG4hy9ifb/w9FKC9gVx1SBW63EMkBYSjiEDqiiIsUk1HrzRZJJ3mSm+DpIW4zterzFgvwk4bGZZoEFdIhWoSVLI84EMOovbBkDk8nttZMWhkzMI80XUsY3tKnQZVb/4KMA2KArSNfGjOfH+nB8IJRLCD6s
 lCwdfPPQ
 LJy+OkUDAEUiCy0k3vM8ByYXNIAb0hKiMct+Ibv7c5xUZFFLsDfYGwdtJCo8xb4arA+yHvYe1TZoNivEGact4HdNHob2Zdj3wJ6lxKm67yKUtI/gK4awf9mQ8P1C4+fPxtuWxxlAfuQ96qt3HlGQjh6hXtyydKepaB2/a1ezoC2Bym+pi34T0EDN8fk2Cjw7QMo02xhfwHucBv6aHkofI+jYgTmjNM3IqPNagz3+y9CqfiyDirv4yDKfPwiyPVSySq6UgMvAzuCpidcUJC6CL3xhoruVwWQS2DAJnkyz5iPC3/7c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/4 01:05, Dev Jain wrote:
> 
> On 02/10/25 1:02 pm, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> As David suggested, the PTE scanning logic in hpage_collapse_scan_pmd()
>> and __collapse_huge_page_isolate() was almost duplicated.
>>
>> This patch cleans things up by moving all the common PTE checking logic
>> into a new shared helper, thp_collapse_check_pte().
>>
>> Suggested-by: David Hildenbrand <david@redhat.com>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
> 
> In hpage_collapse_scan_pmd(), we enter with mmap lock held, so for
> an anonymous vma, is it even possible to hit if (!folio_test_anon(folio))?

Ah, indeed :)

> In which case we can replace this with VM_BUG_ON_FOLIO and abstract away
> till the folio_maybe_mapped_shared() block?

So you meant something like this:

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 2a897cfb1d03..ef87d7fe3d50 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1374,11 +1374,7 @@ static int hpage_collapse_scan_pmd(struct 
mm_struct *mm,
                         goto out_unmap;
                 }
                 folio = page_folio(page);
-
-               if (!folio_test_anon(folio)) {
-                       result = SCAN_PAGE_ANON;
-                       goto out_unmap;
-               }
+               VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);

                 /*
                  * We treat a single page as shared if any part of the THP


