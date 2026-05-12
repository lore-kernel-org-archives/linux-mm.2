Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEE2CCD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 09:49:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 473E16B0093; Tue, 12 May 2026 05:49:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 424066B0098; Tue, 12 May 2026 05:49:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EBD26B0099; Tue, 12 May 2026 05:49:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 180E36B0093
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:49:34 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B1554A041B
	for <linux-mm@kvack.org>; Tue, 12 May 2026 09:49:33 +0000 (UTC)
X-FDA: 84758295426.10.7B48C47
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf26.hostedemail.com (Postfix) with ESMTP id E53D814000B
	for <linux-mm@kvack.org>; Tue, 12 May 2026 09:49:31 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sexRdX+4;
	spf=pass (imf26.hostedemail.com: domain of 3qvcCaggKCPsmdfnpdqejrrjoh.frpolqx0-ppnydfn.ruj@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3qvcCaggKCPsmdfnpdqejrrjoh.frpolqx0-ppnydfn.ruj@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778579372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TTZay7wWvT+jw+pLZTGznjSalODZTrGHCHJE2fs3Kfc=;
	b=drd8XSOfrC3+DkMPBLz05mILwf4PMqrPmP+lY3+Yzq6PZcsK6LjH7ZRZh5q374fA2SCZMc
	ZnDwEi97at3JDZM9SJxhOMeNi3/0pJ9sXl9nzzQyd1WsdVZp7xJSp3LkPJk44GqqzpmJ18
	NxGWfY3DoWYvItFwvDFUh7JVBGZQahU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sexRdX+4;
	spf=pass (imf26.hostedemail.com: domain of 3qvcCaggKCPsmdfnpdqejrrjoh.frpolqx0-ppnydfn.ruj@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3qvcCaggKCPsmdfnpdqejrrjoh.frpolqx0-ppnydfn.ruj@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778579372; a=rsa-sha256;
	cv=none;
	b=W/7h5Z9FbFVdXq4xsohqXPId1td8A9UFe66X0KM8bKM3OeJu2hUKDMGnyEooCzpxI0YtFn
	heGBKBc1aK/NNn/N7ltildimH7kW6acvY5GBEYommXeQpGys8+NpZ400NSX+E8UYv8k4JE
	6oOSuQy7IpK6ujG+woR32g2IERG/wNY=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48d144d3428so30838905e9.3
        for <linux-mm@kvack.org>; Tue, 12 May 2026 02:49:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778579370; x=1779184170; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TTZay7wWvT+jw+pLZTGznjSalODZTrGHCHJE2fs3Kfc=;
        b=sexRdX+4R66NjC8E+czB3RDYeuChdzCzXwXdklaaHHOV0Y66B423BcP5lLz1VR3yR2
         +1Y7aC1X3DnVnjiR/sFvAH9N4AJ/6zMKiZzPg2sBCgbUdgdL5P2zZt13m3qUnxewl9fA
         3W3RdjZFsjO8lUHjOC4luzrrG8Fx7jDwaxSowALUJlKPbYib6olsmyufERYcdPHtJYmN
         I3Jf9wetImvnSHnMLI/Bzxp/rD9MgO7jTodj5lnVBrs9PpkWiwYx1+g445HU8TpUdQwZ
         /rTrG+JCQN5tM9RaLptNSdDYTcBsbE0hWxu40d/4x4ImlT8ZpZw1L6uPDAdByaHCgywQ
         zeSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778579370; x=1779184170;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TTZay7wWvT+jw+pLZTGznjSalODZTrGHCHJE2fs3Kfc=;
        b=hAodmpa7xlAfh3XBJ9NbiRUEPtxvfwFclhJhXldM+qZ9dHcr0jyHku2rKRwyN6kC5p
         6PP3zdgi1tFbtTYD3AjUjLHMGTQpWehXLYQ+FDdkiLaecI4e282uFFonelx8envwCCu4
         qK4gqMbrsGmIB17tgiaLPJqmp4ivuRMrfJs1whfhxuStkDFkpUBGDyGoB6rcOQGkKPi7
         ZW0BH+gaG1Ozwpc94CMdbfBbvyk0cq76Vx1p9x8Sr7H+PTYgmWI91LrFK2uDo6vQgIdf
         asllP8xQBflpNO1e8rQNKw2ZHzlLDN4m1h1HDFq6YpnPA9jaIL3QIJcwXoXvyTGqJxbf
         DXmg==
X-Gm-Message-State: AOJu0Yz/meUOds10GbYIeA6ZP/QpuP5FvOV8pxFg5sd8QzX8FbCD3Kb8
	RYNpH03oMvqQWiR/AdwGnciJmYtgxLQ4ah7U+9VzRp5bXIhJ4IDpRrPhAScrWyjOlwV3qcbVDNY
	Cerf0OzYRedbI+A==
X-Received: from wmjx6.prod.google.com ([2002:a05:600c:21c6:b0:488:9c2a:aeba])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:698d:b0:489:1ba8:5be9 with SMTP id 5b1f17b1804b1-48e706f0e53mr220361675e9.29.1778579370115;
 Tue, 12 May 2026 02:49:30 -0700 (PDT)
Date: Tue, 12 May 2026 09:49:29 +0000
In-Reply-To: <3706e714-f60e-4178-afe1-c1973e43bdb3@kernel.org>
Mime-Version: 1.0
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
 <20260320-page_alloc-unmapped-v2-15-28bf1bd54f41@google.com> <3706e714-f60e-4178-afe1-c1973e43bdb3@kernel.org>
X-Mailer: aerc 0.21.0
Message-ID: <DIGLRMHDTBRH.1I38SY7Y4YFIG@google.com>
Subject: Re: [PATCH v2 15/22] mm/page_alloc: remove ifdefs from pindex helpers
From: Brendan Jackman <jackmanb@google.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Brendan Jackman <jackmanb@google.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>, 
	<rppt@kernel.org>, Sumit Garg <sumit.garg@oss.qualcomm.com>, <derkling@google.com>, 
	<reijiw@google.com>, Will Deacon <will@kernel.org>, <rientjes@google.com>, 
	<patrick.roy@linux.dev>, "Itazuri, Takahiro" <itazur@amazon.co.uk>, 
	Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>, 
	Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 6zw84ysbte9t4jzb4fu1x7hdtwc9whma
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E53D814000B
X-Rspam-User: 
X-HE-Tag: 1778579371-159678
X-HE-Meta: U2FsdGVkX195s8nWH/ADrVCczxhKJPTtx3UvQOWWK35urETZN7oJ+Elgy7zbj8eYfrIcjkbYv7+1/nfVyLEyzSAq1Vo6NU2/naoxjo8O2DAlVTnQccv2Tczhdd10m+S11Uu5W7Op9DN4FisiX8VEA0i5P33HqIDDimtr/NeCPiHtIeqLm226Nc9azI/eGhEuaKWX5FGlPwca58OwMSvzqTORKXWg0cA2TDoAl4VSi7BB0kfCtTnRJ5+AzJKdzbXZ3qSi/Sg5S2Z7dyBGpEV7qtrdcnUu9u3pKenKYGWV4ypCh0ZtUXNrkphapL3WoyhwjxVOAp64mPnBYUfgIUfTmK+5+ln2AVZD66ogHGzK+b88wKuXWlkUpW8pgNzQygs2WmZMgwSsjAe8HUYjXyyz9msWQ4JnC4DFiZ0mU8lCvVgEpgcO8Rqg7hRrwu93oP+H1jfGiJK9G6YM9gAoKA4QMkTS1wJIhcBLQb0os9gWlI2R6RgB7B0VTdIaivq2XeYoL1FRWZzEO2Y92GVtSn4ibBoiuVVzOKzG5E7JPfMga1ffsKj5CHk/XfdYifXrbeVPIWAjqGyJduJ3Kmc3yeq2W4axJTIFuEJ+VUttxKK/hDaq0VkDCDxqxMaP+6vsuVLoshgGj78oYsgld5MJOkGByZ+cwbrULIjxQm8iemP1mfntgme2xl98ZLrXiEzuibYFHPuVDNUIYqwRu4xTSkeUtWMbF6uDrfa6PRpfAG+Fq04Of4fc86Moh7w7QovNzq/pN8yJCeqWeXRXnU5CVzWAgPplN4Gdnrnjvi5RVLzOxP+Ghb/Xuv1gQMqH6clmEiv1E1Ix1KN8x3OTa3X7g5Z6lPe/aRYJLM7k7aoFs4nSpSYd6XlqiGc1gcGpySaFL+0Td7ekjlaVEqwbkrwCJxFX5m+kkBfkzHVEIbH+nsZQEXKyqzBxYh62Thi7lDRCfjY+1U3t5VCAUjf1S/AlCMX
 KriCvRiJ
 Qxx06mnoHRqYKm+AJHTWL0LrBCUUraYz/eZn3hSM8zA2dHkqCIpfuNEmRhQQiEeHV1ymkWqS20Sn5NQyYTHZde64cJvyoov8NAS2oaKNGoTpsgWkKhcZWQOd9BFzhjEQ7oNt1ny7zYahZL/PWscke428hro/FXq5GNOOYuiQjIgAR4S6paN38/fPuJTa90gpZJO8LonHhohZ2EUA+b18B6LD2VelkRQdv5XQaj1GMW+4SF136Fe6AYyh+r7JxFa8qj4KxnVIFrkzBStgaGE5sRd9e+Ou3QA5g6PLVL7kloJuvCLMglSAdy5z3a1m4gRBq0m84yHZmg4AYpwDcMVWKjaPXfbkVZAzk6PZIrh2ptnnh5K8W+TgCtobcOZZ83IRgv72BScvXIH8KGwIDRsMnSpCQQ3pDyDhrLyQjdZRVEdaumK6NjKb5mO71P8aJ2HH149TtQWh5OOl7mo6+2thtfyPHwhtFxs+oioBeKrNaDmc6dARhbEyir1B3v6E5Qjk8b/gmppVYV3hthZSGdKiYFER059PmEaap70d80S6b7nMsFedosNQrxM157HocIhnpl1Ut9SMJobyVgrMmt0cx0NeCmmyoe+b0/p2KP54xphcBU61kRVGllFfkbCCoWIF8l8q2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon May 11, 2026 at 6:30 PM UTC, Vlastimil Babka (SUSE) wrote:
> On 3/20/26 19:23, Brendan Jackman wrote:
>> The ifdefs are not technically needed here, everything used here is
>> always defined.
>> 
>> They aren't doing much harm right now but a following patch will
>> complicate these functions. Switching to IS_ENABLED() makes the code a
>> bit less tiresome to read.
>> 
>> Signed-off-by: Brendan Jackman <jackmanb@google.com>
>
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>
> Also good for prep series?

Um, shrug. I guess I will send a series with all the things that could
_arguably_ considered "cleanups", and then I will let you/David/whoever
else chimes in decide on which to pick and which ones would be "churn".

