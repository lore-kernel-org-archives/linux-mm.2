Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8FF9606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 11:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hwMqOa6K
Received: by kanga.kvack.org (Postfix)
	id E57496B05C8; Thu, 19 Nov 2026 06:51:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2E9A6B0620; Thu, 19 Nov 2026 06:51:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1E646B0621; Thu, 19 Nov 2026 06:51:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AEC356B05C8
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 06:51:30 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4543B40A37
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 11:51:30 +0000 (UTC)
X-FDA: 85451703540.11.9848AA4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8C50A18000A
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 11:51:28 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hwMqOa6K;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795089088;
	b=1Hk2hCJG+byvYQAa7MOfJOLJ0J0+cE24dxRz5dNn2QMmjzYIH6rtPGI8KkL3fiQ1uZrQum
	KNDX/NTvHbO6qhll7FvcPfekega+f07zTiPuhS2CBnqiPK5jdJWPEhWXr0TGexR5oak6Y+
	k9XPnkaaUoOIbPdu6n8aKejYuqxymBo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795089088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/UAEZicfkctJXUIdfdbsu57lxdii0JgeJVmREU84oAE=;
	b=6TVIg5+yHcm5dCwKU2P+nXWKgV/LeePV3u7UY6tb+vhfXjIqtVTOiMySNzfJrjiKmQZlGB
	8zZw3u9+hc29V3shlDpW7HWY1CqGuB3y5VMRxqnK49UF8MSomAkLLH4ZrYtVn21f+s1ajJ
	bYH8Ieyc1Z10I7I/vPtc6Z6KuLI5hYg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hwMqOa6K;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 135D6621BC;
	Thu, 19 Nov 2026 11:51:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B7AE1F000C5;
	Thu, 19 Nov 2026 11:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795089087;
	bh=/UAEZicfkctJXUIdfdbsu57lxdii0JgeJVmREU84oAE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hwMqOa6KpmsNvkmelPMkkYgP8TJTRX5EkmICVu+/QZrQZ2SCeWY+KTMIGjdfS5rhO
	 VzooIoN6LnATrRze2HHjRd9L/9iBx4EEIDUE2OBn55GadNZ4RF51/RDcRL69qg+Oa9
	 H33MpMa/lvsEkfKujPyYhJDRr2NRmtCiFBTQsF8gpg6FwysVXMI4TrqAGcxSgg2eCu
	 Bi3E3d6uXn9fJs8gM7L3pTYQMG+ZxiZvDemoAHNu+dntyXo8Ot72GxCP1iJbjpCbrS
	 uZq+eRE9a23g2ptUsIktPlAFwMQzB2fjQxLjrq5oDe0A97zg8CPbYqezTvRY9Sssf4
	 rrelgkzk+m0+A==
Message-ID: <273b84ee-8dd0-4b8f-ad43-8ac1b47722af@kernel.org>
Date: Thu, 19 Nov 2026 12:51:23 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mm_init: don't subtract managed CMA pages twice
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>, Muchun Song <muchun.song@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Chris Mason <mason@kernel.org>
References: <20261119-cma_managed-v1-1-385751505e24@kernel.org>
 <av7f6WK8zipAigbg@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <av7f6WK8zipAigbg@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: inuszd4c7kwj4aftdnf7qgpshk1be5yz
X-Rspam-User:
X-Rspamd-Queue-Id: 8C50A18000A
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795089088-958190
X-HE-Meta: U2FsdGVkX19dMykc2SGoFsbKf8vTXAYbv+u2D7vDDsnOI1u0sPG3l8cifBbBQP7tcs1lTeFlGmFZKKqZyaz3w8P4O0mF23y36uXpXMBrbHEBpCUX1cP0LnB99onJ4TFfbDwqS1vTZK1nwkeoGmXN4Fqi0svN0SXbMuS6E8P23wvwxeeAbnBuljpd/nkKg3FJWGOUUHJ6Ri3e6D2+WV+BXJWjUlf/5Ehoc0ovD2KhjVN0odCJNkvEdAfEq0SmugC9KqmwV1QDDxIEialeVMeeW8C+T3nCM48CwSe9+kAsCNB2T6r4ot7QzuXiaZyxvi0F0gfpsqk7yRoSfumRE4B83GIn4cgImy2lDIqGkkKTwL2vtZmWCpmLduJZAXNK8lC2Y3UAHZi36kzTTpSQ5ZuddC0FkxFv+VJue4mlQdv4RB5XKCiITVWuxKAlc6SJE9HeQdMg0BHWorQFiESn0+kK1rtyHK/hGmomELuoU9yOHzJpKKklTZzJY4htntxgLzxQUTzG8NFZ06ch5lU1lkmbPVwZ0Ew+63LdxYIJOvdtHhgZFKi0yQzWJfqhmunxuVs7uZSO3beiZb/zkWEJ8MPOhAvzP+/ms4FvfO9JubDq+dTaRxHoRZZLymFtRLfGhUT0eIK3NAVzgRF3u9xTFoN/Ai3RVMCO0uo1aK9GEJmLNv2zmGl6Ya4zd5HuH4ZGjI7mNY2ufJo62ccB1Zjp+gqFgf5u28wBpi/AzAonjrRIbJ3b2/DyC/tGiyAfXtfvOfgWkBqIhaxCNGE7CU800M9YuJ1N4juqsVlqwgFxWV+qu0vSUzI3hXsOWyWh2B3C1gobs2+TUE10Hc7QeBk46izgIxolXVc71cTBGc1jc9plQUPdQIjDoJqkqJ4NBRe27EBWhdhOIOkR4tK/YSPOeQe2+M8rXAro/cspn48xscWKvARxF6Tt3Mo/Y9k/o5CpeSYx0H2SYN98T/pEyGp7/iK
 P6gW9DkC
 acXBG4DEEqOnBXZPNJPZXtFRLi2ogAqE9R0lozqk7lFsTnobrOCoqgGJ3wNjOA+XOkrSKH1/7vVAKBAEbGnO/4AKvqOng4IvLeyiWq4moEsTG5Yhv5PjPBryJdCEG+7TKk/6cvaS+0t9IHuVRvt96LvG+FRx1+R30a4ZGv3N4FAkXLsQhNQF6x7lU+DVcYa3yqQx2FgYG5+fX5Kn42Kd16ba7XCMbjIeHYDLFQEe7wxMBZB6bCRejtNIC5sftwfHrn1g75wG6KHSz+bDkHMgize/R4rFgB5/YIgUo7vKQARES6yBzh7AeX/4AaWNy9suv6ckd8rDssnMI9xfd/GP6xCl/zDy11Gwj4ECeU01EN4DP2DBLFSFuGC4J+U065QZdHsK7vwfnIhhE29bxLmK8OMIkVtCRDtOPtW5IYGT2VL0HSs6J/C2zMcyJOrXqtpFQyGHn0hJL3jup6K6wxS0mOZycMCDV3rCXuDYw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/19/26 12:39, Mike Rapoport wrote:
> On Thu, Nov 19, 2026 at 12:19:06PM +0100, David Hildenbrand (Arm) wrote:
>> From: Chris Mason <mason@kernel.org>
>>
>> With hugetlb_cma_only, the "reserved" value in the "Memory:" boot message
>> can be wrong (small or underflowed).
>>
>> When mem_init_print_info() calculates the reserved memory, it assumes that
>> no CMA pages are managed yet. However, some CMA pages from hugetlb might
>> already be managed at that point, 
> 
> How about I change it to 
> 
>   However, hugetlb may have already initialized its bootmem CMA areas,

sure, why not. Thanks!

-- 
Cheers,

David

