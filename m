Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F10CDC9832A
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 05:54:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED6136B0088; Tue, 29 Sep 2026 01:54:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E86C46B008A; Tue, 29 Sep 2026 01:54:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D760C6B008C; Tue, 29 Sep 2026 01:54:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B9FF06B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 01:54:38 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4A11CA456E
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 05:54:38 +0000 (UTC)
X-FDA: 85265735436.15.B7F6FEB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1A29220008
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 05:54:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=r+09+Qtn;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790661276;
	b=ATOITL7ZsxPTL8wubJxWQYirRTGMn0AhJOrt4bscyGKm+OG6RzmFXqRX0e15qWPvWIJ1TM
	HUbJfGbkxIbqTxWYJ7o7SrEmy7vBPLpnOtnNAk26vOyRqdGjpd2+SgtxXG70kl5MmMjew9
	vOz9rJQ+mkZnqz1CQzC24iaCJQuz8T4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=r+09+Qtn;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790661276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2F1RBGd7+Q2CQkiu3GaXEcWxfO2qJPquvVyl20Vkizc=;
	b=nQeTC5VokVjDcQMIG9eoEJAfuuRU3amtoOGyWzsQbmB6IF+xeBdY96nnL/WI2+EQsjKAVG
	f6aNgPYZulEuvqS+GLHbf2dorpljyf3FHMQfvxAKji9gI6RsRoPExlhUNkCV33OYafhvGk
	jK0d+2JjcGDXA6gqJAyh1vuOD9GO+rk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6BC8E1684;
	Mon, 28 Sep 2026 22:54:31 -0700 (PDT)
Received: from [10.164.19.84] (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B643C3F85F;
	Mon, 28 Sep 2026 22:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790661274; bh=8nkwXY0A5RFYOmpZpCVpTJMUESTE+g43aAvec0iYxIA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=r+09+QtnSFt+dnSfRuQGaaldiXc4mhTOPri6hVSHqcL9koINFR2ZnAgeqwsSkGa6C
	 2jPyj+B6rBWhOoUuyCIeZnxqz3AJlFX3dC5DeZAGcgotS5umquFypWyjnXgnuLFlCP
	 vxY8dFVP25lHN7cuNL79b6G/tNeBObrPUpdUQAeI=
Message-ID: <b8da4a73-296b-47f9-95dd-b8a74f3a0984@arm.com>
Date: Tue, 29 Sep 2026 11:24:28 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND 0/9] selftests/mm: improve mremap_test
To: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 John Hubbard <jhubbard@nvidia.com>, Kalesh Singh <kaleshsingh@google.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, Park Tae-sun
 <ts930@dgu.ac.kr>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260924050009.19974-1-sarthak.sharma@arm.com>
Content-Language: en-US
From: Sarthak Sharma <sarthak.sharma@arm.com>
In-Reply-To: <20260924050009.19974-1-sarthak.sharma@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: g4bib44sonw5dmy968hgbobiqo3wazin
X-Rspam-User: 
X-Rspamd-Queue-Id: 1A29220008
X-HE-Tag: 1790661275-254726
X-HE-Meta: U2FsdGVkX19kCcuhPrAO0vX/DZLQH0t5lyCA5hYa24aBic+Fk76bmcGTBYHMcXhVmY5lIBjCBj90FOb+J/GEdDNv7gu/dx3rLr3VFV6+iKIrtsAXRiJoDCALR4FURSIsLKVrOLU9AVxw7W2kq8yjzFpWKno7jey0d4av46LAc3xAP8IpTpBFTH1WrcysaCXWr3Rd6tUXNIU5yO2tdPiIpAjcS5CRbrnJw4V7tCsD6R/znFv/oNIZVG7T5nxWxJxl/i5EW501VvEnQHPFaOuWbtYeNYYtV6HjWErr3tj0Zj+PS8z0xTqzRYOGW3BFg9CvSnGLybKMsSOJOLmWzLCWQm1LjpN6CWzSww5DdH0I1kUfqyyRePGkToDTM8Xa4AaMAQsveWTeh4beY6PAOM35gwyeu/3fksE5EnayB1G+FHIigyKgBZXV3rXaSWd6Bp2VU9Px/vuzgn3GvbhHgVW1HvqSuHr1xpFWl7DtLgAQDUIF0N2sF8fqcqI7izi6lkopuC/JWiybk1nl8QQfE4tqWw79EkCA/MUL+M7LVZLq6QhCpz5vgJdy0FHJdvZS1oXOeJrki/i/16mpeopuvSgolOVIICBzPF9wHkYfXFYLW61Ih4QDb5+p3QLKqtcHV9R4F5CCAJaXQs2Nb9HCr6qifNeHr8kidt6UG9xXdLeGmEDWMSCJMjw4NrXL8overtE1fRXTkNHxPAH4nc3b1gxezjHxA5x13FlpIH6ds2K7/RvXpcV/2xOIWb+eQcwyFLpu2a+G4KVLv0TuEriYWwpvFNAL647+d4Mv6NLFZncHcyvbUgIKrcxj2s2RRjDZ+XtBMxRgGmgbSah8nVuj7INTwIPGJcIt6HTdsvVizclp4RVTCeTw2b9XDYTJ+uAEuDP3VcYag4nYbUDxVDzISf0phRiltoLV/N+OJtXVCBaTadu+wPo40mJORtn7LR+DEgbmG/7xqHKYH2fieciU+eA
 xn7pHFzG
 Q9BU81YNzr66IgkfRtXTAVuw0sWXh49G1I8L4TEUmDc6p2Dkty5J9gm12zDVbp5T0bbFHvN6yvq3N304f4wFs4baJzWjSwoxhO/2Xw7fb+yoIp8KeOqIBSJ5GEGobLnyirjBtSNxehow5z4WugIEBM0Sw331n8aCXDSfK/gdVLQSjZNS/qSUlP/2jG70ijpI5DioS/TUH2sXraU74uaWhA+w4o88dzACydwKMgPSgx11TOpbO3SwWd6KCalY2uj0dedtCCoT05beKbnBk7JOOA6RKEx+FyVZ8uETIHI5G4hsiOWMjdB6I+bNZqw6vu++blmp0YLfgZh8ZhyTuvEw5Bh4gSDrZoHpbz+xP0p8jTMFbQyzWs+XXfSKV1YgqcezkhXMa84T/k2LbHRX3qv/9EMQTsahjBFSTchfZ+HIcRiwp13s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/24/26 10:30 AM, Sarthak Sharma wrote:
> This series fixes several correctness issues in mremap_test and
> simplifies and strengthens its data validation.
> 
> Patch 1 converts the mremap_test to use kselftest helpers, removes
> manual tracking of failed tests and corrects some spelling errors.
> 
> Patches 2 to 5 fix userfaultfd skipping, unexpected mremap success
> handling, multi-VMA data validation and failure reporting when data
> corruption is detected.
> 
> Patch 6 removes the randomization and uses a simple pattern based approach.
> 
> Patch 7 removes perf tests and timing infrastructure.
> 
> Patch 8 removes validation threshold and always validates complete mappings.
> 
> Patch 9 strengthens the multi VMA validation by also checking the
> mapping state of holes after remapping.

Hello everyone! Just wanted to check if someone has had a chance to look
at the series.

Also, Sashiko has a concern [1], and I had the same while posting the
series. I hope I can get some opinion from the community.

Currently, for PUD remap tests, we allocate a source mapping of 2GB. We
only fault in the first threshold_mb amount of memory, remap the whole
region, and validate the already faulted threshold_mb amount of memory,
which is, by default, equal to 4MB and can be changed by the user by
supplying a command line option.

Since we plan to remove all command line options from teh selftests, I
removed threshold_mb altogether, following some discussion on the list
[2]. This would now cause a 2GB source mapping, and its contents copied
from another 2GB buffer. This causes the process to have a 4GB RSS.
Sashiko says that this can cause OOM killing in small CI machines.

Would it be okay to keep a 4GB RSS in this case, or should we find some
other way of validating a part of the whole range instead?

[1]
https://sashiko.dev/#/patchset/20260924050009.19974-1-sarthak.sharma%40arm.com

[2]
https://lore.kernel.org/all/2e34b619-085f-4a9c-bb41-bc024fd40dd7@kernel.org/

