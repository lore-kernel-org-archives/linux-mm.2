Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E01EC9830C
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 13:52:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DF826B008A; Wed, 23 Sep 2026 09:52:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 390266B008C; Wed, 23 Sep 2026 09:52:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25B156B0093; Wed, 23 Sep 2026 09:52:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E8D816B008A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:52:42 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E402E807EB
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:52:41 +0000 (UTC)
X-FDA: 85245167322.04.16A9CD0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2FC364000A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:52:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=alIag8+0;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790171560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Vlns51KE3TZSNtfAm3ejn4phz9ygr88j2EuVAIFdaA=;
	b=duJWYHUDwbLWIpZDC1X22yvLB3tCFvTSqwjjVmoP9+5d9ebTkwsXF6DWATAW7Pa4Zy2abM
	cKdOwv8ngc2uAx+qdLGlT1sJGg8uIXJS0y1oV2Qe2jgzHeHMBDBmRAvYNmd7O2C8m+B4/3
	/wc5g4vDTsP07Xps4FxwWNIfasqJTCA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=alIag8+0;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790171560;
	b=gJVtKY80ajk8o27WPlR/OpxYKPPrlS+o8eWZIb+Xd+ROc6Ekttt1bFld6s591ztYgCIQ9e
	SnF/uWyntSlj3SoH90gTFAfoD1q75Ezk74wn0gvhtZzMbFwPBGfKxHEKynlhKnE+VCjQK2
	5Jr+dEyXj4vF1CDgWdKT4S8wLHF9n0s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A5E4F601FB;
	Wed, 23 Sep 2026 13:52:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66EFE1F000FF;
	Wed, 23 Sep 2026 13:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790171559;
	bh=2Vlns51KE3TZSNtfAm3ejn4phz9ygr88j2EuVAIFdaA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=alIag8+0p5LtR7xm0nxkZi97djgHwndGeQcC+01M539hZCUvpYsywIge+oLPK2dBg
	 GyEKblYRtBV9jDdfoKb2fY5Nx012XVo4DMIl6f42JF4s4GJeUjUIkaTByY5XH+lc2G
	 vhDU0WDqIYYGeGCCW/VKmLWUjv4cpFFIrgnb9enZzJh3GmXLaF80Fvuol36y1uJ46e
	 XwCUsJV+q9SZo1p3f9jKM5fZFkFSTu8HAbiCeBCc174w5MmeahZt/C0YrC5vyt1Elq
	 4tKcuoSJo2GC/sKIdAaeYjkAAvVCJmvK7KnnJmCLmPER4cWdlEnbEr4hbqmWAjkrzC
	 u5mIVn5Vom0ng==
Message-ID: <3e814778-6646-4066-8f2a-6418755c53a4@kernel.org>
Date: Wed, 23 Sep 2026 15:52:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/12] mm/collapse: separate a collapse from its
 callers
To: Andrew Morton <akpm@linux-foundation.org>,
 Kiryl Shutsemau <kirill@shutemov.name>
Cc: Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>
References: <20260916093145.4022188-1-kirill@shutemov.name>
 <20260916154826.a55591eec86b5514dab898ca@linux-foundation.org>
 <aqvcElQxmtysJwbA@thinkstation>
 <20260917151131.ececfd158627e58257ca7110@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260917151131.ececfd158627e58257ca7110@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2FC364000A
X-Stat-Signature: w54jermzshfheiawki1zgdijpisundps
X-Rspam-User: 
X-HE-Tag: 1790171560-611554
X-HE-Meta: U2FsdGVkX1+GjpVhaufaNul9R3kabnlimXVUlIhvpzfLIxuNMmTAq4NTGIxa0OpUIhjEr0KHMzNpnr8dZlA2mi8EQsi3omd2oIHjkoRvbC9lIwdXfIclQHG+LyiBo5vZI7oqmOxh07wyTpX5DUg0QKZBro9jRnojvfnmOamfmd3jb/QwEeSXYRhzOlmUqlwKRjgJ9WgVgj5jXqZBBzlgm9CGgL7AtmjExoUCa1lENhgVp1wtFL6oBjkOtyVnem5d0D7GasjpJMX5BkIwQBO6lL0U3EkvVs5VORD1EyXGvHLKMn1p4saQSwdQBVEUoeb8t/pyQ6YyMKcx9YAs0DCmx/iTp1jWBToz0oNxZ/7Miew+LBi7SD8vOB1cWacexQjyTzVL974mI79F713QIdZKtFB9IgXgNW3l4wo6Q7bIWJgzQtLDU3phC7rRMucxRZatkxtEUJuiwOSPwmo+FoO/gkZRbE/aB9aykahhBO979VidPwoEApgeMkcQmYFsU7T6U3czkZlVhFl0XgB05PpT5hP4BEaH7lAFZU1To6viyNIQ3fH2c8il8yV2hofHa0Zbm0TX79/9rX1qzVBPpxeiUTHjIijVYHEFWGas3RaW0jf63Resu3LEWQ/begQi+GiPYwwWdmViSC3icDxUNmO2Xu6+8Gv/utArWcxz3R2JPkQi/uifEX4yruO+gSVAv0t4tow7SSlETXFJ9CKZNkYfZsuqpJ2eZEXmrgtIDsm2kZxVYGBRSdkyOj3rGNkWG6q6E2fN3yAPTn0vkNCBP7I9A1X9RJP3bx9wh28DjjsOVlPpHBAmnKDltAFBPI8DIn7GNEOGbagc8lbH6x07oKnC72QJxx/0QIvSXgTmNqLdim2Axqgfl4tlaryrdSLB7eUDqY5cVzszUqJ6zpEPJ+MaIJZwfPx0vouJpG2l+OchS2smnjuQFkel1peIDAtL1xIVghFFmGOdIHrXtzJ+GpX
 M05Eu4VT
 BTaJIvVnjzerckVe6s72r9YqofEKJEi/Fs5vhJQsRTTsKVxNkB0PGhp6wSLGev4z0SEew9zJoMpPO2Kr6xuvJdwWlWxCqcSZLXmrXDqtxVcy9E6EkSbe/yuA2nO8cQJvfBfPxN2E9hSAfOJLUtOUO5EJlQPSuKCgkeFW8RwGiQs9cydIRue7IcikXER78coR2NqrmaQPwk5R0A4fFKD6xeNcKeUPt5rPAbK6o2Pk4Hk2uuPqRFWlvIVecKdgHiO2YpRmT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/18/26 00:11, Andrew Morton wrote:
> On Thu, 17 Sep 2026 13:26:51 +0100 Kiryl Shutsemau <kirill@shutemov.name> wrote:
> 
>> On Wed, Sep 16, 2026 at 03:48:26PM -0700, Andrew Morton wrote:
>>> Here's how v3 altered mm.git:
>>
>> BTW, is it helpful to append a range-diff to the cover letter on a new
>> revision of a patchset? I can do it in the future if it is useful.
> 
> I guess so - that would let people see what changed immediately rather
> than having me send it later on.  What do others think?

Ideally we'd have that for all series, such that it wouldn't be the authors
responsibility. Because even if Kiryl does that, nobody else will really do that :)

(I assume if people would use b4 we could build some automation fairly easily.
But that's wishful thinking)

-- 
Cheers,

David

