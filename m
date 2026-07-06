Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E630CC44500
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 17:10:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D3FE6B00BC; Mon,  6 Jul 2026 13:10:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 983CD6B00BE; Mon,  6 Jul 2026 13:10:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C1866B00C0; Mon,  6 Jul 2026 13:10:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 651946B00BC
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:10:47 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EADC21C6441
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 17:10:46 +0000 (UTC)
X-FDA: 84958991292.25.08D0DE0
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1A31740006
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 17:10:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="jp/aWUSg";
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783357845;
	b=0VNGl/CrmZMB08emyVlPSWpjMJ00+hC31kbh5zvK4EUI4nBcW2xqztTMrbcDQZgbbMl5k0
	qQvIgdHN0sbVPaINHvQ31qtfKEFAlIZOOePJta0bIP1he13kaJAJ+5lDptLBmGxGDzl8h7
	lj6qcJheZw7kLXAqN4EPFijbcs9USjM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="jp/aWUSg";
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783357845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O8B4kLd9O4yTubQHP6cxhqJtyGSLfRF2Xu8qr9txj38=;
	b=RJUyFy4wg6lgvLCbkXKUthU7i15wjd5O3f8KJMUHCRG4YGtEHZPjIIWI8rqMHHY3voOBAZ
	JV0TDqSI9tH4ULuwrvls30UvFluj3fZ1O+GrxZ6j7lY8Hh2BnHObm8ZhgW4c+kiKZSGdcY
	bMI1IMtIFxvDHiEsCMzYvygF2yu/Id4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783357843;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O8B4kLd9O4yTubQHP6cxhqJtyGSLfRF2Xu8qr9txj38=;
	b=jp/aWUSgAz66O8jyAVernzctnnaGA5zaWiqwTWPjEwmghu3+EwHNEA3IgUk4FM+7ghh5o6
	QzLKKdUmDlvGk+bUmK1Xzn15aSRkeL23VIUUMGJ8RAc8U1StucG3/xf7C9lUHANhuAbfh5
	AEqtfZIE5Pf3iXapFCqOsIqg7RzHT7o=
From: Usama Arif <usama.arif@linux.dev>
To: Nico Pache <npache@redhat.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH 3/8] mm/khugepaged: introduce a count_collapse_event() helper
Date: Mon,  6 Jul 2026 10:10:31 -0700
Message-ID: <20260706171032.3487318-1-usama.arif@linux.dev>
In-Reply-To: <20260706154500.39178-4-npache@redhat.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1A31740006
X-Stat-Signature: tfiwjo4qze9fir6anaxg4kutznogt1os
X-HE-Tag: 1783357844-11741
X-HE-Meta: U2FsdGVkX1/wwiwhx83bxUYQ2KyOdoDtTjuTGL5LI2Y5fYNcOFRskRC1l92d9YmGeMgWIxUQ4CINcmeCm9zQDDERTU1u79GBGEJpj8pu1INnU2B3uga2qaFB6o6kHyOgmwUWcgewQ2G69IAxX8DVEZdcYV2AyQS4yJqjPwIEoT4rNYrldI45SPmgkjXLDIFDP0bLbrrEeCZLKXNVo+SULRWlzWAqC5GfUBpaO4gQSOLgYiJyqs3YlTNOQF3kP7oV8bddISOrZDz15uX7cBREpmK5EmNgX/dFNlBwol16h7h+zWGwGcuOe6mQJgkNm7rfjgdlrnPQgu85NkvDOCf9ctty+4vqz36vIaaXrqZb6EK7KkpO+xpN5iymhrGR9hInSUsIELnDJbSU/Kk4hn2wv2FXNrH/J6GE7TO6jm7dkC6aB8iWZNuCRqf4VALutlxKm6W947Jo0XbW2m8hgECgIfL1pUpvjgMzbTqOLrh18cdVJIN5Rwmzw+6Scg2FG4OHuoZU3C6ZAdt8+S3LExkcMCSbPsibvA9Rfk0jHSYruLCj8F7WKGYrrAiN9atsSqMgFmFem9kUVOnFmfsrgkjhNBGkEQ6cA0crk2FSH5NOo66jqDIUvmaFVhR9QjXaVydRgyARrhjpgN0jOJ2aIg3YEmVH3pugZ4WNOAixxuq+oxTKz1m40Co/dkTnFaueZ5tixG7d93A8hR5GHaWgrniZ+lC6iD27AUfNVBapjlxasPk5El1wcS5HlvMHsLkUNjc54E29t1BU5etgy4QyIvvwV5pqhcu7kJTF8THA6GcVevlBltWVrsmelXUVxlJxAFTGTVlavpo+Vundj0NatwTWEYtSxOw5JIGEt+67rgYLH2Ady4M+erhquANzD+MVmUaFppdC2MO6oMbQDG/rjqGW4N4fgGVWWtQy94CXuBOASgh8i4gAvdWBV9QboEgixdez2C+hfuxpQV1AHk8ZT4a
 c5CawyYe
 OMJirh5zseQs+2zFkNhfacXMRKM6oee476hQ8i2/H+Pk+w5kisf6a5NXjo5RombOLUvyIUHpQF2JntFDPjIJIoibhUr4cNnUZNmmKsS4DkT/V890sv/dX6UuMn6gMY5t1p5ck3Rf+h5aBmAUHbI7ckfJ9SV9/yX6LlpdvtCeOaeXFf7ru+SdeJYtIVoNfYRVIXaDMfMivg4rsE9LeNFa4jbYur/oebWSP1JnUzb3s8ZM+Y+K12jUrtlMuavGysk/EyEpnXSQqIJiqdcE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  6 Jul 2026 09:44:50 -0600 Nico Pache <npache@redhat.com> wrote:

> Provide a simple helper function to help reduce a often used, and
> duplicate pattern across the khugepaged code.
> 
> When collapsing to a PMD we need to record a vm_event and the mTHP_stat
> event. When doing mTHP collapse we only update the mTHP stat.
> 
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 36 ++++++++++++++++++------------------
>  1 file changed, 18 insertions(+), 18 deletions(-)
> 

Acked-by: Usama Arif <usama.arif@linux.dev>
 

