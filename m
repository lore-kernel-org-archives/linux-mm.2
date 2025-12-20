Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7DCAE6748A
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 23:13:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90F336B0088; Sat, 20 Dec 2025 18:13:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BC7B6B0089; Sat, 20 Dec 2025 18:13:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CFCF6B008A; Sat, 20 Dec 2025 18:13:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 67FCB6B0088
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 18:13:06 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D62BE13B9BB
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 23:13:05 +0000 (UTC)
X-FDA: 84241401930.14.AB5575D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 20BC140002
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 23:13:03 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BlYuQm38;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766272384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lcybuaWZP7yNm89K6p9UUOw2lVE0Ypr6+gW+AX8tkj4=;
	b=Y8SU3hESWDzsH6bnd1tH/twa3nbRv0WVKlrI8HSbQrSOnO+j8FXhHEqaYXp5G9hih0Okyd
	1gUuHAysTmRV5wi6DvgX98Ypldgfa5kNdyIbffkszGZrQTixh1w6iWPg0zZpzHS5d2wvve
	TY7c3CWCg6zz1p41DjF//mMUXhUU4hk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BlYuQm38;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766272384; a=rsa-sha256;
	cv=none;
	b=NMMjf1ArpjOFYrAWhdokzmiTG/NrMoAWCkHVvOFUPj+yc43Yxgqk8Ga+ttlRJk+4e+vmaw
	jE7qmHCgn89i4O/S6BzUX+ntRiDY6ld2MaizcNMQ3vKi7OmyblhE5V3blTiT7d9Ppr47Xw
	pOXcfDNFMmXpDXi9PIlH9enj63vym88=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1BEC640375;
	Sat, 20 Dec 2025 23:13:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD70C4CEF5;
	Sat, 20 Dec 2025 23:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766272382;
	bh=+7nk84yUjtX0ynkF4hQkbgTB2Rrscujd1NJooTAi6Fk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=BlYuQm3812gsBx6WgmIHXDSpCZ/iX8xx22AT56+umZu8ZkqhIZPTwLJwb7V6G5qiD
	 L+7XZcPOKLjYNCGMq++4T+bFyPwQDPnElMgJ0L5wCsx3P467qtD3E4q1Y7IPUEoQDb
	 V2GxbT9DwYeI4/RhpO6vZ6yCApk8BAck6+8vMZLQ=
Date: Sat, 20 Dec 2025 15:13:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jane Chu <jane.chu@oracle.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
 linmiaohe@huawei.com, jiaqiyan@google.com, william.roche@oracle.com,
 rientjes@google.com, lorenzo.stoakes@oracle.com, Liam.Howlett@Oracle.com,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/memory-failure: teach kill_accessing_process to
 accept hugetlb tail page pfn
Message-Id: <20251220151301.b0ec3c1aa6527b0b1bca1e4c@linux-foundation.org>
In-Reply-To: <20251219062819.2499399-1-jane.chu@oracle.com>
References: <20251219062819.2499399-1-jane.chu@oracle.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 9gcfj4pyyuk1g4i5k3werc6wztuudkui
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 20BC140002
X-HE-Tag: 1766272383-529810
X-HE-Meta: U2FsdGVkX19Ya8RqgBhE3unsLlLbzY6MeULF+b46iKN3vhi1hHiaotdm1ch9X9Y7jpwWo4w72SSO7UukmXliI6WdnVB3eUSEsD32CWUSzLsZM7fI2e8mMsha/hEGakt+FbE7Od8W6B5FMzCeoarBIQjKy9DxIqXOxA15wVmrV8q/I4Wy1foxfDjItuxuUrpIlU00E2iv6+/d4J063rHjcB3k1wb7FuHf5SIidRLqAXG4RJ8W5ITzp4CSKGTk7PD3QmyZ70swv3ZEIBfTrR7/6XVlSIDSUeiz8E3X/PovWjFWJgb3GmuotuF3IV0GV5hL9wb0nzOTbdM3sYrZaz7m3+UwNt/+0MUEdE0cKOuRH+Ura83cm+T0+N/jTWK5TOrmeDuTVLNyhSRuqNytEs1/++XuZUEm2rhpRxR1P0tudnDpOcLLxgTBOSnzIWBK2JukTqGNcYfhTd6RUIcJoyXnscycbmpSeHoV3DNPPFuYTS8P95+nwDIyrhvPKamxssC0FE3vJ+Szy5k+SSjGxOuWJyUZgjKDfFUwmnZa1QVqua2nZyrj8xGIQOV3UrGPaGRF9FmusPFJz1WwD2rqqYOREO91w1DZ87HmFbSybU/UZjA2sptdeJLJJ74Y8Z0tRr/r0XBM47L57m5T1wF+kzJqYGuiPMkbxSERUy5/NQi8ApINI5BdOl/6vp2oDRW+K0cFtVfB3nmHhvkW9LnOGlN/GB3O8tHkjR9MDY8uTpzcqt+9yB8mQ8z0xbKkZDYBRj9an7NA91syM5xUvfS/AWryxpU/8ahWbpVtRoAYDb/ikPSe6jeC0xNP6cGCPboUuq9OJqZJ30W2+N/3SN7S2dGutE7oldTytlJjnaJVs62WAfVk0iLw2jyGHBdBBHjGZxp4E42Hcq/a4dLMVFbLGdRGIyUsYSzWg1MSi1JUB09kR9K++J4ilY1koM7fOfyQ6fn/TpVoDekzg5IdKnu7CR+
 DN/2EB6h
 SHHzxhs71qauL/eZi2kxpq/v6oikwsd5dxceS/Mk9/ktdLoyGyDd4cgzx9hf52whTAf72VJNFtxrYRcgapF/B+rHM3mKOi6SJqBsEWItI8HLNBIl59rO86GobhVdGupRn5jxKwF3vsJDibYXN8Lws3ycMIBGWailV5UojmcuoqgcgAjbUWBApl1YjBM8XSerjXAS4Gc2YKH2BXjKmrvgT0bTVEQI6ZWywnhlJXM3uuoYMaNi/RPTiJTgcRIyU+BMiYVkjhVdA5M5z8BtIfBjW4CjwwJXa9Efgqygcy7/HklVXMOj5xTKS3jQSXbpShy7ztGol
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 18 Dec 2025 23:28:19 -0700 Jane Chu <jane.chu@oracle.com> wrote:

> When a hugetlb folio is being poisoned again, try_memory_failure_hugetlb()
> passed head pfn to kill_accessing_process(), that is not right.
> The precise pfn of the poisoned page should be used in order to
> determine the precise vaddr as the SIGBUS payload.
> 
> This issue has already been taken care of in the normal path, that is,
> hwpoison_user_mappings(), see [1][2].  Further more, for [3] to work
> correctly in the hugetlb repoisoning case, it's essential to inform
> VM the precise poisoned page, not the head page.

This conflicts with your "mm/memory-failure: fix missing ->mf_stats
count in hugetlb poison".

Also conflicts a bit with "mm: fixup pfnmap memory failure handling to
use pgoff" but that one isn't cc:stable, so this patch (which *is*
cc:stable) takes priority.

Help?

