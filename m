Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C43ACD3423
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 19:08:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E605D6B0093; Fri,  1 May 2026 15:08:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE9DC6B0095; Fri,  1 May 2026 15:08:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFFD16B0096; Fri,  1 May 2026 15:08:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BB0856B0093
	for <linux-mm@kvack.org>; Fri,  1 May 2026 15:08:53 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5C9DDC1029
	for <linux-mm@kvack.org>; Fri,  1 May 2026 19:08:53 +0000 (UTC)
X-FDA: 84719788146.21.1872178
Received: from mailbackend.panix.com (mailbackend.panix.com [166.84.1.89])
	by imf30.hostedemail.com (Postfix) with ESMTP id A1D2F80003
	for <linux-mm@kvack.org>; Fri,  1 May 2026 19:08:51 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=panix.com header.s=panix header.b=uLrtLc67;
	spf=pass (imf30.hostedemail.com: domain of kenny@panix.com designates 166.84.1.89 as permitted sender) smtp.mailfrom=kenny@panix.com;
	dmarc=pass (policy=none) header.from=panix.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777662531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=avU2aeDiJudu6Ve+/fr/MPvICQS1Esrg1FU1yfrAa3A=;
	b=vlWTTTRYpGvQxKFc7P00cnVdagti0j5Iu8SiclU9TShnjhW6dZkDQJnuHgLNDws6PLav2A
	TphfnfUIWsvnx+I8OlpwJ/giOJh7j8nmlbG1BUxTaamCRnMnxuGmZzdvAaN6YLbT0tcsIr
	9EIBkMp5h16MX5LPpeBjEFWb5DoyYXY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=panix.com header.s=panix header.b=uLrtLc67;
	spf=pass (imf30.hostedemail.com: domain of kenny@panix.com designates 166.84.1.89 as permitted sender) smtp.mailfrom=kenny@panix.com;
	dmarc=pass (policy=none) header.from=panix.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777662531; a=rsa-sha256;
	cv=none;
	b=04aWMvd0nprHQvAysC9eMZhpORpZqfZcAObFWX29Gm6wiGAbxjCbiWXEUJjNgOK39uBUPx
	J5m0ueoT8dsV0hGFdSRK/buEhxzVuFteTEcjqJ3cZ79pv1jDkyLHEmOKTsLVMKnkVLO1+K
	nXR5tY/JL+QFBsTbS04AoHxohAVD9Tc=
Received: from [10.50.4.26] (45-31-46-51.lightspeed.sndgca.sbcglobal.net [45.31.46.51])
	by mailbackend.panix.com (Postfix) with ESMTPSA id 4g6gYs5wssz40Dc;
	Fri,  1 May 2026 15:08:49 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=panix.com; s=panix;
	t=1777662531; bh=l6JbYucB+9yD0k96T5o6k3yiniTY2VGeKOqZ7PJWN2I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=uLrtLc67iWq4GSqPGwTJ4rzevu63TXdyY+tNy3yIoVxzTdPx+0fPodKpQqxhC4lNc
	 QCHPB1S0lTSGcF0UU4nPVLMx1ZldiL+6j23fwwJohT2SBeEYi26JMpRWvIueKLSTyb
	 EzfKFKOXzZUJmOYybDBlTJSczHHL4DxaWkFQioyw=
Message-ID: <f25f27a1-bf09-44bd-9b37-49f159d82d6a@panix.com>
Date: Fri, 1 May 2026 12:08:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: PATCH v4 0/6] mm, drm/ttm, drm/xe: Avoid reclaim/eviction loops
 under fragmentation
To: Matthew Brost <matthew.brost@intel.com>, intel-xe@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org
Cc: =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Kenneth C <kenny@panix.com>
References: <20260430191809.2142544-1-matthew.brost@intel.com>
 <20260430191809.2142544-3-matthew.brost@intel.com>
Content-Language: en-US
From: Kenneth Crudup <kenny@panix.com>
In-Reply-To: <20260430191809.2142544-3-matthew.brost@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A1D2F80003
X-Rspamd-Server: rspam06
X-Stat-Signature: crpy3m7wadasnkk9tzsb35oixkafwpec
X-HE-Tag: 1777662531-802392
X-HE-Meta: U2FsdGVkX1/b5IhUQe6/owEAc+rl3kiUVYA+oLbj9U4IjA6a7Bnw6kiClnOSUkkw1Q2+n6UZx9OKH37mUEjd9JMOAWM2mWiQkpOC5Ww+mSymifKiQpuUWcP6S3KEw+0PTCup3VvWrcafv3IvGAm0A+85+9N5EWOvIOQLfHwuT7NImImheVtr81ODkb4OIrfdM39DATugtvvpChtc7xEF0SRCZZMWqIzaCw6AOmK5AEsjRIycptStPm0gbbk6slFs8Go8n6cVaVGlNakMJ+7vKCVGZWYLj6uO2gHlu8oeq1HvTBp/eaCwU0OtiPwF69llPyvCGa9faGuPIGOrrLN7To7oUFFltQHwogo1Zg9u3Svl71y0wPFek4fbiCH97a9xSmpjoXyjnvwrYNcxArtcGWLUsXAYmtP6yZK16PYw4lWaU92EImiUltWSAR72+9zFLcNEKzXLksb8Iq7gWghazRIEnM0/k0MHRWp5/zmt1mwVL0B3TmCXtISckzgYUqMd3ro/0UixouWJjg6SwvloizZx4PKRIGNftacr8fh95JvmruO0evok1HnmXmi8Y8W9J+kFwUsVvLWjaj+vWZTHbvd35BuCbGqNR3MIpCzdK/UhWWfQ4ucFEosLcHONuRLy65ghXxl4h9741PBECxgeWWlPtJXBWX5J0/qttQD6LvhZmdIC/NQ4ncsMxQXlgZZBh5/w+k3XFzDpt629XtP3uLB/sIj3aMnvT4BQk70tAEjWOnNGisdbsNlbUA9hhuCSh83o618JaBfkFtKokUT1CRl3PWj7LAqhI63YCEC5N9MWtWVCoawuTo3u+oJtArOh4xxh5Ia9j6a5Q+9L6KurnuHx2G3dTJ4WsKErXowY9m2BhTCD6i5M2dsAd5p2oPf2YPcrnSSblL2qhGIDf2Rpkniwd9LuvfocNd788sUCILwE/I3M9ikx67xDpF9nCzQMPVkzI1M+toGvJjSqoOQ
 ZFE/BI67
 0Hphcu6CnWgZutuDYa5j4yFNL6lodRgV+JFdq+0Ld12dhMUwqFO/9n/KvVmJwzl4Saye/NtCET4Mi8q7jW0EDnLKHio46W6Oy4NmTsd0bPHn7eeTm/dCyJHD3xbOSdC0Z9oSQkrlTTEzQxELI8a/+BlEcYDn4tBFFCl5AIASmvt6u6IbiWhGxTLjZ7gI7d7PrT+tHBs2B+fPiNL9J86KEmgEWwJ/atMF+b3nYHc9P1T0tbUCtBDK0dUzqCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 4/30/26 12:18, Matthew Brost wrote:

> Introduce zone_maybe_fragmented_in_shrinker() as a lightweight helper to
> allow subsystems to make coarse decisions about reclaim behavior in the
> presence of likely fragmentation

I'm running Linus' master on my LunarLake (258v) laptop, and sometimes 
after compiling a kernel (of all things) I'd see kswapd0 thrash despite 
having quite a bit of free memory.

I finally traced it to the xe driver after seeing the "GPUActive" field 
in /proc/meminfo suddenly start rising, eventually growing larger than 
real memory by several times (see below).

This patchset fixes the issue, and I'm sure there'll be a fix going into 
Linus' master soon, but what I'M wondering is how could building a 
kernel (which is just in a KDE Konsole running on Wayland) make the 
GPActive grow from ~1.6G to > 30G (and continue to rise, RN I'm seeing 
91839848 kBs and still growing).

-Kenny

----
SwapTotal:      33554428 kB
MemTotal:       32345672 kB
GPUActive:        652640 kB
GPUReclaim:       403988 kB

SwapTotal:      33554428 kB
MemTotal:       32345672 kB
GPUActive:        651180 kB
GPUReclaim:       406812 kB

SwapTotal:      33554428 kB
MemTotal:       32345672 kB
GPUActive:        659004 kB
GPUReclaim:       399396 kB

SwapTotal:      33554428 kB
MemTotal:       32345672 kB
GPUActive:        666996 kB
GPUReclaim:       392764 kB

<some hours later>
GPUActive:      91832468 kB
SwapTotal:      33554428 kB
MemTotal:       32345672 kB
GPUReclaim:       488000 kB

GPUActive:      91832332 kB
SwapTotal:      33554428 kB
MemTotal:       32345672 kB
GPUReclaim:       487988 kB

GPUActive:      91869376 kB
SwapTotal:      33554428 kB
MemTotal:       32345672 kB
GPUReclaim:       486504 kB
----

-- 
Kenneth R. Crudup / Sr. SW Engineer, Scott County Consulting, Orange 
County CA


