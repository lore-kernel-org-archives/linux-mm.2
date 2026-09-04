Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB968C624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 08:25:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89F566B008A; Fri,  4 Sep 2026 04:25:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8500E6B008C; Fri,  4 Sep 2026 04:25:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73F516B0092; Fri,  4 Sep 2026 04:25:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 485A16B008A
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 04:25:16 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B5827140B1D
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 08:25:15 +0000 (UTC)
X-FDA: 85175394990.26.F6E0C52
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id E567F40007
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 08:25:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jYzhgz46;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788510314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rccA36EyuXOhMqphuckpFvf8Da7GhE5PelXowHSaKKU=;
	b=ei3DoB6N8wQ1cDLWGpgNBo6RufM2kZDwvXbSkyo8aLn7eyiuWryLdalhOoSrelE/wVvWB9
	wf0/igZe3lxdGvPvs3d8uJzor+pyBL4Wt3JxkgTH9PlgNZhqB5pcSls83PibqqD4c3BbND
	9SK4Gv4/mSbkipHQKo6Okadca12ZQ7w=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jYzhgz46;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788510314;
	b=d2Mgw7NV3MzjG2OHeBlBn3El6UEj4U5f05BEMsJONwE7WPMZA5AyODMI8NCqY8LXO2uLdh
	OxCLxpxsfSxjRaCJkqE7dcCMuL8AXjeymjGt2o/Z4AGw6UnW5HT8S9B/cSbPijBNY4VWbx
	pUe5vmO34AnmuZgo/G0aX5ICzTi5BmY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 69A4840593;
	Fri,  4 Sep 2026 08:25:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F170B1F00A3D;
	Fri,  4 Sep 2026 08:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788510312;
	bh=rccA36EyuXOhMqphuckpFvf8Da7GhE5PelXowHSaKKU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jYzhgz46a22ezQusLxk9qVWzQI2UXXiD8DvEw/lOqkhOwdgrCWcO1PeVLXJQtj5a/
	 Mcfwj2o6LtGuledzus610SHt1SyAQvI86ZINLZpIhtF2VF74lauraRJIXGzwPMv6UG
	 H56+HTYNcZHd+wcjFFv+F2AxBzXaQTMeHKICum90zwAIpr+jAHb6T8t5lguaRQ9t97
	 apn1TZ22uiUV2x/KtlgbQ4IpEUbB0fxwq0HYxBD8jGWmMfM4D6uqX/5B5u3jLnn8na
	 gOZ9ym87/tUs5+GmYkYFRb9iaAs8vYA47cMEWF8pL8wyIKjDBho1F51y2u4HQvcge1
	 fe4Vbz8zJgbwg==
Message-ID: <a6ce8684-116b-42f2-a88c-154eb86bad59@kernel.org>
Date: Fri, 4 Sep 2026 10:25:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/8] mm/page_owner: Add PID/TGID/COMM and cgroup
 filtering
To: Zhen Ni <zhen.ni@easystack.cn>, Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Steven Rostedt <rostedt@goodmis.org>
References: <20260903041819.1776630-1-zhen.ni@easystack.cn>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260903041819.1776630-1-zhen.ni@easystack.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xi5o6krrr5fo1rpj7x3aq5sn651whr8o
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E567F40007
X-Rspam-User: 
X-HE-Tag: 1788510313-557471
X-HE-Meta: U2FsdGVkX1/Nx23fhkS1PlWZhnkotqxHLS4DW1wIpeIh85VAGcyV0fk6x31AV0/aEfoFYdsMwcvimoqtowOMKTTKRcS2ZlhqMbu9qhq5u1YI78Zfal9weIprprEcIP1qbw3ryFYDzM0Z32uVOSI/xkCaXGrRPpl98yb8cKOf+9kGpQizxuil1LnoKhgGwBIdJ53YIyV2yAdNO3FLBqbAP0TXV+kDlIn8m+D+7jKvu1qMzaMTJyXDcEuC+OpSI7jFcNlBjdZKyMdt+mntYuEieW7jbgXTrypOtaJ4du03nrxpexeULNClX8EuPyD/R8fJ0XwlmBlm0iika6t6DUQ/k5nFtZWvj35o5gD7uoeoFA+8TXJond9ukTynEfhom2I8JV3hmRhAjYQxRsaz4C3CwFZXDO8/tDe0rjZGr2R+fy+NJ1TtWDOvTYm8XMAUitkFx4cmyykpspbI1o2GeoJ4Mp8jwXqHGK3GiDOnLegrpm/6pMGnMm1Y6n40wwaA/KsBa/DrjvL1/Nd+6zXcsEpcoJNDFBCCKEE3uOaAC6SI8sfEIJ9ZXdwGYCZlF5kPu1YA8jQOHxwt3F8tqx9FXLf0pO9StacAPcMfM0wXTS5qooI++ttIu1nJykkC8oqnEvVau1qwIkLjObGnIcTVUWMtsKA8QRhIw0f2OSPP1YfiwxQsVOfb6lkB92T0I2sxjJHZXaS7eRumDuMOs9uMfaDpcy1O4TxGf7WdmTYd3bvI4VdURj9dTe5XmKEkC9iAi5+eKyI2NoWpFH/ytovxAC2HOZZ7b+jDxtNynULOujGf8vCttJ99/5uvkgRHrFObhzCv5X1RkgnocwDJy67VKIH0Zdm819vfs6H8R77D9HKqGZep0N04kTciIY7IhBb2l7KbZyOo43TwFgYm7zEZF59PmL3edmqRhPHeSMkt6PJNFYtOhxerZ49RiHpGOikSCYNXOHrfgUEp/nzsxfMPY12
 XQx53tRc
 5+vaI4PoPFWYgnPEOIckf6EBSI1TX7eIp37QWoFE4uB6/EU4s9gMec4ApZHGdTNi3iROesQ2SpDuPrBQnAD1hleo+Y41V7j8Y+l0RyXUz0GnaXe9JGJBHLYCi1Jah315+MSZRQnoqE22IHzity7sV3wiD1tMhJxWaJ3+qmAlm4TIWIC/ZmtoDdKktnYjcOlbpPs2vTSlT23PwzneUT1jdzJixqstZt1FJd6GHa6/vmZyI4QzkmgQ19WO/mKQmLb1L+PEo9scNt/D6hDM/FxFY75IBYk+JoPOyte0vY5MalPqzF4J5mDjW8B1P4I8TXrHfzCiEWxsAbfnRVrI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/3/26 06:18, Zhen Ni wrote:
> This patch series adds process and memory cgroup filtering support to
> page_owner. Following the previous series that introduced print_mode and
> NUMA node filters:
>   https://lore.kernel.org/linux-mm/20260707115411.1714314-1-zhen.ni@easystack.cn/
> 
> This series adds filtering capabilities to page_owner, allowing users to
> filter output by specific processes and memory cgroups. Users can now
> filter page_owner output by PID, TGID, COMM (with wildcard support), and
> memory cgroup path. This makes page_owner debugging more focused and
> efficient for tracking memory allocations in specific contexts.

I wonder about the usefulness of all the new filters. In my experience
page_owner is useful to find a kernel memory leak code, and for that the
stacktraces are most useful. Dealing with things like pid/tgid/comm/cgroups
sounds more like your aim is to profile and optimize particular userspace to
use less kernel memory? In that case, isn't it rather the area of memory
allocation profiling (or maybe tracing with bpf), not page_owner?

Moreover, tracing or bpf can already do such kind of filtering and AFAIK
ftrace filters for tracepoints are nice and generic, while this is adding a
bunch of custom parsing and filtering. So that makes me somewhat sceptical.

> Targeted filtering provides significant performance benefits on large memory
> servers by reducing both execution time and output size. By filtering at the
> kernel level before reading, only relevant page allocations are processed,
> dramatically reducing the amount of data that needs to be handled in userspace.
> 
> This series extends page_owner filtering capabilities with:
> - PID filtering
> - TGID filtering
> - COMM filtering with wildcard support
> - Cgroup (memcg) filtering for containerized environments
> 
> The series is organized as follows:
> 
> Patches 1-3: Add PID, TGID, and COMM filtering support to page_owner
>   - Support filtering by process ID
>   - Support filtering by thread group ID
>   - Support filtering by command name with wildcards
> 
> Patch 4: Refactor memcg handling to prepare for cgroup filter support
> Patch 5: Add memory cgroup filtering support
> 
> Patches 6-7: Update page_owner_filter tool with corresponding features
> 
> Patch 8: Update documentation
> 
> These filters are particularly useful for:
> - Debugging memory leaks in specific processes
> - Analyzing memory usage in containerized environments
> - Isolating allocations from specific services or applications
> 

