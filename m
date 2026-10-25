Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02902606A31B
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 21:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=gWkUhUFU
Received: by kanga.kvack.org (Postfix)
	id 0F8766B05B0; Sun, 25 Oct 2026 17:49:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A95B6B05B1; Sun, 25 Oct 2026 17:49:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F057B6B05B2; Sun, 25 Oct 2026 17:49:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D0A1D6B05B0
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 17:49:10 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2A2F41C0F79
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 21:48:52 +0000 (UTC)
X-FDA: 85362488904.19.E484F6A
Received: from mta1.migadu.com (out-240.mta1.migadu.com [95.215.58.240])
	by imf07.hostedemail.com (Postfix) with ESMTP id F3EFF40003
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 21:48:49 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gWkUhUFU;
	spf=pass (imf07.hostedemail.com: domain of nico.pache@linux.dev designates 95.215.58.240 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792964930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7wQNgAvrV53M6g73xXbn+Hsa5Wpgb9uHDA2CEi88MY8=;
	b=yot9ZgM260pw+zW/NKnHn5AAPU9pBn60GSc4UwfeKEIDEypNcvHcij/wuApuvnNyb2O0AO
	8yom8qqQBM0AvJwiOdYy+WoKPVQqXM0ZBOK1zdfjdS1e+YyUvIS9062kVozQNF5ZNsaZ9Q
	ldg/nLOnj30RCntAUzTCCXPPqEniUGE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792964930;
	b=zLE+LIbKhWoztDegDJOySOyk4XV3FjihaT7ii54LjPnefjZbWoCJNRjGmfi7GtrXqwScT5
	d8VRX+/YuM2U31Av4Z8PdGBXg4woUTVQcSSi8yrVm6VfBTxWOvhdpSAjGVKBQS7YOqM23f
	mOANHaDSZLoD2F+Rpjzhe/YKYGjGZIg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gWkUhUFU;
	spf=pass (imf07.hostedemail.com: domain of nico.pache@linux.dev designates 95.215.58.240 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=FW93I9g2tFhlVSvMbZvJhIsiJI9bo4PZOSNREMcmxDA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792964928; v=1; x=1793569728;
 b=gWkUhUFUyP2n9w1XqfxuzV06+ZqN3YN+wNJCYBrB4HxP5Nwf4YoA/Ifr7LPlYyKV633fnYzN
 ZQA0k94WlZsm0a64RNpARKHYrHVnMTF+ivYvmRNLgLaeOBang+tBO6hINmNWwGhQVq7MrwtftlD
 8ilzZwtbnrH9kXJ2kDI26e2M=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e5eed0b9c945e22a;
	Sun, 25 Oct 2026 21:48:48 +0000
X-Mizu-Trace-ID: e5eed0b9c945e22a
X-Migadu-Flow: FLOW_OUT
Message-ID: <e865f7f0-087c-4fe5-b729-6e6946cd20f6@linux.dev>
Date: Sun, 25 Oct 2026 15:48:43 -0600
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm/huge_memory.c: skip zero-page remapping when
 underused THP shrinker is disabled
To: Barry Song <baohua@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Yu Zhao <yuzhao@google.com>, Xu Xin <xu.xin@linux.dev>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Usama Arif <usamaarif642@gmail.com>, aarcange@redhat.com
References: <20261025-b4-ksm_fixv2-v2-0-8b61ad0491f1@linux.dev>
 <20261025-b4-ksm_fixv2-v2-1-8b61ad0491f1@linux.dev>
 <CAGsJ_4zUVpBJazRxc1CzN6u5XvpUaGnaf-_7JMz-rGK_ZTYMtw@mail.gmail.com>
Content-Language: en-US
From: Nico Pache <nico.pache@linux.dev>
In-Reply-To: <CAGsJ_4zUVpBJazRxc1CzN6u5XvpUaGnaf-_7JMz-rGK_ZTYMtw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F3EFF40003
X-Stat-Signature: wdto4kgutbjirhypghw41sgcnqozbzjd
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792964929-41254
X-HE-Meta: U2FsdGVkX184SSY5UklFgdiMVn16WBRF1HN4YOH75VnWQ9Nfl1Eif5UQ10V1JfC0TIp0QdtPI+xQSzOriGlzKzi25RAhCgcGn5jYFvoIY7NunR38qrz3MGSn3MwJHTOLxxu5nG0G/sAaZm0fKig54n9c0QL3iOJSMHfyucjLdb2P4apRZ0fb6WPrsiKUxgOKQ4C+kG0cRUiVAfLaUAnJFEHm9sPp/wkSiZhdMRBYxrn7IFn/VgAOJ6Sr7rpWU0/Jr4odEH844TCiOazoreIvog4mQfhw0m8I2QgR7/5kZUX0EuCbrrz3lSN17P9HqBGkt5bbzqWG8xBMm/vp8kKE+3Edxd9+ZYaS0c7wYrPqKdhtBj3f5cgsKZVGJ3Q34powr6uQbdI5T20VWOnwalVKE2kdd9eAvJzd1X0Fv6oXd6WY2UX2PzrjBc8PxBhiCeaM+530k/AB/a6dTQ1rdaDuXP3zT2trNkq+yZJRIqWBioqtmxlmqN1W38249GAjXJPutK6U5yhRJgMqAm5F6N/58C1uCmZyVIJLqwCWijg2SBzmCb0arjxALxSeiiLYTnGeUefdNp6/PPCS1b7c2aiFgTD1BOPbn8Al6a8uHwDnp3tPBvRL2YzQ0n9vCVFUlfXN37PWFrXQczEOvgdbA/wGkCLRS+yTrU1GC19Pr/8Qugptv1u8vex4QIQrSRDUfvd1ADaNtvohtf3DL6ky3BHNJIyAjyyzMFcOnBkvKDDBWrkH7ayGrEzhCMYCjYHzpxGxKBLs6bKKOPDyVNjEn1Uu5BvEDnHtikOfEtZB+4/7eVuYvacqXjxFlXmInhPg7YdgC2Z/8JeiKfBjh1Xelh5E6KXcq8jkTn7GQ5yeylH1xB+44WdSXM9c/GT5V6+mm3pP+iGNpbThCU0DBvyL14qu1Xn16jboLr+j2BCemhupZf9gD5o1Oa/JDPiQl7mfrV7Ol0uBvHOpu0E4pIxNH2T
 fOc+xY1A
 fugF2FSdpn4V/WXxnKS6jRi0SG/y841CjJYwm6Gyu/MCb7rjt8XgueAUlHhB8f/mstm/UCPPpRVy6PuUeV45fS/okGPH8wnKl8N5zFO+s/aAgJPSXVoBSBnrhYNVTBCRvxXtn6I/vsU6Lb0vuBUhR7Q9LczYKv0BAKpKkBVRrPNIkwJ5NMnS1YPaIVPgf/AUw5mjrGgPQudYBAh80vJp6R2vlbJ07PhPifZhN8SkjWcGFBX+rAV44SyUHnmB8UYpGqghmPoZ7zfbL0/jNfcWv+QvhRCwOVvQ5k7iANqzAl52Slk649wQvxqLLj58BKZxqu8nNQSiFdqrNhwFp5794TwohTra8KIroT4e1/C+juC/c+coA2c9gQJBt4xQ/XA3mrIt3XAI00f9RArt4/57ZWBvLRhcCeQFNwz2njVq63flrIykI3T6kFJUgEBm/xTEEwUzp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/25/26 2:28 PM, Barry Song wrote:
> On Mon, Oct 26, 2026 at 1:40 AM Nico Pache (Red Hat)
> <nico.pache@linux.dev> wrote:
>>
>> The zero-page remapping in __folio_split() was added to support the
>> underused THP shrinker. When the shrinker is disabled via
>> shrink_underused, gate TTU_USE_SHARED_ZEROPAGE on split_underused_thp
>> to avoid scanning subpages for zero content unnecessarily.
>>
>> Suggested-by: David Hildenbrand <david@kernel.org>
>> Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when splitting isolated thp")
>> Signed-off-by: Nico Pache <nico.pache@linux.dev>
> 
> is b1f202060afe a correct fixes tag? as
> commit b1f202060afe has no even "split_underused_thp" there.

I believe so. IIUC these two series were merged together. While 
81d3ff3c6f7 introduces the toggle, b1f202060afe is where the behavior 
started.

I guess you could argue that the Fixes should include both?

Not entirely sure!

-- Nico
> 
> it was introduced by 81d3ff3c6f7 ("mm: add sysfs entry to disable
> splitting underused THPs").


