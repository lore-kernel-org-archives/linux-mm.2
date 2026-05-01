Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0332ECCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 20:06:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F40F6B0005; Fri,  1 May 2026 16:06:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A4D76B008A; Fri,  1 May 2026 16:06:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BA956B008C; Fri,  1 May 2026 16:06:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 08E4B6B0005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 16:06:03 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9892314023E
	for <linux-mm@kvack.org>; Fri,  1 May 2026 20:06:02 +0000 (UTC)
X-FDA: 84719932164.03.65D6435
Received: from mailbackend.panix.com (mailbackend.panix.com [166.84.1.89])
	by imf09.hostedemail.com (Postfix) with ESMTP id D06BA14001B
	for <linux-mm@kvack.org>; Fri,  1 May 2026 20:06:00 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=panix.com header.s=panix header.b=EwqJlXIY;
	dmarc=pass (policy=none) header.from=panix.com;
	spf=pass (imf09.hostedemail.com: domain of kenny@panix.com designates 166.84.1.89 as permitted sender) smtp.mailfrom=kenny@panix.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777665960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iSgZm9BLVGoG46QIgICCw65h9o87b4AOMOhkmdPIkk0=;
	b=dUSHXK/pokkIEJT6H3psy8A6PnbFrCbPaTdGdVEsIHQ4VkLSTLARxachMT+952K0LkYjrK
	P9SH4ywXV0+DNp/G0VjpTsHn3Jd2GICIH8cLDhcWrpPYlQoVfIE00BhiBLUEsp5Lynwyd5
	+rGP3PlTAS1fTPijCis7cNHJnTBpaHU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777665960; a=rsa-sha256;
	cv=none;
	b=QuqVMEOsvdHbklj51vs2+yIxxO8iAzKXrsBeOpNZEvqXZOwStHvhuZf0FoOZMq5KE1B071
	d4koQXid0IM5QYWPQeI20/J3cA9WtlNC1TyMxOmPFyyhGIadFo4DaEORQP7TvzFxphH7lm
	2JDyFkNNW7dvH6eUvaf5zXQ5DqUY9yo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=panix.com header.s=panix header.b=EwqJlXIY;
	dmarc=pass (policy=none) header.from=panix.com;
	spf=pass (imf09.hostedemail.com: domain of kenny@panix.com designates 166.84.1.89 as permitted sender) smtp.mailfrom=kenny@panix.com
Received: from [10.50.4.26] (45-31-46-51.lightspeed.sndgca.sbcglobal.net [45.31.46.51])
	by mailbackend.panix.com (Postfix) with ESMTPSA id 4g6hqp6ldbz44h5;
	Fri,  1 May 2026 16:05:58 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=panix.com; s=panix;
	t=1777665960; bh=cONm87vO6U8KoFRSYCxJ8KYqOQ0G13S1o+mPo2nLIvE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=EwqJlXIYdY4I1dS0lhxbfOj47Kt+Yj7YfgEwsGpNoNaJcRtXApRuMJuARolCq0MAm
	 VWpEKWIhLMocrLBh3MQnn6CnrtDMKQ+9JPuLriJSUm4E6j8ABb1QK90bYbIP1Meq8Y
	 8nPhy8FGQQAwgpjF3QZ84CGXq4SMvIqMQoKjEAPg=
Message-ID: <1bc0b1a7-a01f-4dc2-ad7a-3a05f975331e@panix.com>
Date: Fri, 1 May 2026 13:05:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: PATCH v4 0/6] mm, drm/ttm, drm/xe: Avoid reclaim/eviction loops
 under fragmentation
To: Matthew Brost <matthew.brost@intel.com>, airlied@gmail.com
Cc: intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260430191809.2142544-1-matthew.brost@intel.com>
 <20260430191809.2142544-3-matthew.brost@intel.com>
 <f25f27a1-bf09-44bd-9b37-49f159d82d6a@panix.com>
 <afUGSmS+jNPP8O5v@gsse-cloud1.jf.intel.com>
Content-Language: en-US
From: Kenneth Crudup <kenny@panix.com>
In-Reply-To: <afUGSmS+jNPP8O5v@gsse-cloud1.jf.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D06BA14001B
X-Stat-Signature: bmxyw4ho7iafy71qyxexf9f8xzc4f3ht
X-Rspam-User: 
X-HE-Tag: 1777665960-612156
X-HE-Meta: U2FsdGVkX18VZ++EVbKemf2I+NKkW2au0bSrViG75IqdJcItgCb14wYi+x8BB/xise5j9YSbSyehcp+IxuJDAoVkyxY0+2I6UXVwuf6v6hzo8bcMfvz8cuc4bazXFDvpvqbxNh+5G8idorCHFmty6jUVXF/9BZvBx3yZiKD5FcuJZnAYLhz23+izYsKPBP9PxkP22SVyRcQ4AlGzuR4aWMfIWwsXvURmTb+Zs3jIBXohRCg4E2THq3iLPXidv1hIo/Z9f/dsTqUMGAILKxDbedsV6BdfeAn50PGSIJYtfxim9QPcgmOz/HxUK/l+ZLFs/pzkbZbqE2SMZsLXQ21P/5q+XVvXxzNY8DVZ2mXAmpgKqjTq1oxqORjJnsbjFvAY49jgRxLClxdYSR5KQfZTvb+d9lBOx6a2pWZmOHbW28qO8uIDeeDDIPMt0XSZbtC7TixMU3B8yWkG8SuKrpr9RxuXoppFkf8tCfZoh4hHXUxrLS5oQg05dvVpDbOjrgeNxpa0TLcNm/q8lstxLLBrOt1jzU5ACdoI5ikxMEKX+dKnZCj87VI0Bftq8FDXwdfcF1I8nVL68VyywK+mggOap2rO6uvh4I6tWOB4INwDvWs7C7IqVSHmGYJeYR0vfqngxBK80K6LhxJCsbxKbkTeI6xMOnTL9Tj+B169pPbLIA0NXezU5x9G3a8P3EcQCMIwwNG5Lvfl5IOM7IehwtCUrdmePMq3vt/rC7EC+YHK4ba0CasE1j96qbLQybso4UGDeZ8QM+eO+B7bFqFFdNPXYKcrTRsivONYC4vsozzPUGovgZQYf8iVMXst1aa6fHE3Fs0wqgdzlc+3YUVkFNsqB7+XXDmwxkjFmT7R5zryruG5l2IlF/+5HWeS043TdEr01GfAnGVA10wlSDx5XNDSHuATL+3tW63M3NMTR8u/I6IdcDH4eR3X0yPGLNfHKtFkR4lKdH4vm9zBsnGNOpY
 pA+woE5y
 S4iYMy43ijukGgUohvzv0g8lQ/mje6d461jkj8OoJG3xzn+mLgJQ+IQdoZRkWsl9DQaiK6nlWMwxlzFJdVz++iAciyfDbOzcTb/LDxgHK/zr22qVmE+6W2lRvNnZ2Hw5iib+VMrkFivKR/wANS+zsRlPD0GvsDS6P5S6kQ2TdB7YDbHYMc7QFYF+MU2d0j3GrdfBF8C53YcsocSeJ4OV0rIRFC4ZLRQIeOUx5uh/zahSKEdjPhmdI+ryEAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 5/1/26 13:00, Matthew Brost wrote:

> So is this 7.1-rc1? It looks like new feature to 7.1 added by Dave [1] and
> something look off here. Thanks for pointing this out.

Yeah. I grab his master branch daily (as of 6fe0be6dc7fa RN).

Is this a "shoot the messenger" thing? IOW, is the reporting off, or is 
the memory usage really that high?

(BTW, those are in 30-second intervals)

>> ----
>> SwapTotal:      33554428 kB
>> MemTotal:       32345672 kB
>> GPUActive:        652640 kB
>> GPUReclaim:       403988 kB
>>
>> SwapTotal:      33554428 kB
>> MemTotal:       32345672 kB
>> GPUActive:        651180 kB
>> GPUReclaim:       406812 kB
>>
>> SwapTotal:      33554428 kB
>> MemTotal:       32345672 kB
>> GPUActive:        659004 kB
>> GPUReclaim:       399396 kB
>>
>> SwapTotal:      33554428 kB
>> MemTotal:       32345672 kB
>> GPUActive:        666996 kB
>> GPUReclaim:       392764 kB
>>
>> <some hours later>
>> GPUActive:      91832468 kB
>> SwapTotal:      33554428 kB
>> MemTotal:       32345672 kB
>> GPUReclaim:       488000 kB
>>
>> GPUActive:      91832332 kB
>> SwapTotal:      33554428 kB
>> MemTotal:       32345672 kB
>> GPUReclaim:       487988 kB
>>
>> GPUActive:      91869376 kB
>> SwapTotal:      33554428 kB
>> MemTotal:       32345672 kB
>> GPUReclaim:       486504 kB
>> ----

-K

-- 
Kenneth R. Crudup / Sr. SW Engineer, Scott County Consulting, Orange 
County CA


