Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A4A7C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 20:00:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73BAD6B008A; Mon, 31 Aug 2026 16:00:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EC0A6B008C; Mon, 31 Aug 2026 16:00:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6030E6B0092; Mon, 31 Aug 2026 16:00:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4297F6B008A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:00:36 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CA1361C185F
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 20:00:35 +0000 (UTC)
X-FDA: 85162632030.20.791BE2B
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf31.hostedemail.com (Postfix) with ESMTP id 359032000B
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 20:00:33 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="pU1g/ni1";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf31.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788206434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KD9yzIj2ChMKwwwuCxZ07mabXpAm8XFsPfqRMa8Gidg=;
	b=cs6Dj1IDeJkFNzErdU66kCG9rxIrqOAWiejvE2aglvEJmF21zTUemTNR8DMbmKjPLsvER2
	4yqK0jSI5oEQkiLpHn42fF/E1Rmpv6ierOhU6Y//L77q1b0dk5+oKgErDUStvNLAyn3qem
	OnrzyTrnyVOTpl0CJjT96wRA6+v5aVU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="pU1g/ni1";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf31.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788206434;
	b=wn47wG0TaK4YLbzgPOundKVrkxFGU/Pb/4C4sMomOVImLgJfziUWbY4J2XBzVvDJsvRjo+
	A7hR9jPAtSkJ3r7wtYdwR5Vg8P+RT4rvxlb0o6ZQvXncj0bBhQS7/nRwrSxxKtJnn2zKdk
	O5SEGuUSy4vJt7zE4wiRHQD4njrK5zc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:References:Cc:To:From:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=KD9yzIj2ChMKwwwuCxZ07mabXpAm8XFsPfqRMa8Gidg=; b=pU1g/ni1Q8VNIKWqixQp9DPlLZ
	RKgJ0VTCZG5/fQTqCP+E9gZrN7JP4xCLRo4D2f9ZMwAC3fa1MZ0YWZRIjB4u3+erb45GAWOXHh37K
	rNuE8d3hCyyAFLK5sLT2rmU/qwd3B6D/1j4p1PHPVDkNOPBWk+9uuP7oCwCY0zG2f9bdQf5XkLEqB
	eMrocPSb+a/chLMvccv29MFIUR9jyjJiNroXmQczR3R33TLmnJVeVH4nw4rEXNNYizALXhpsSBPT5
	9XOYC4VKFBPb3EAx7t750pksfaChxOEanXTp/7+i8F3k+S9c6xS+DO5ZmrEsKg0cmnW17PIkEUVCn
	xkvIsPvw==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x18BA-0000000APTS-3Euq;
	Mon, 31 Aug 2026 20:00:28 +0000
Message-ID: <107dc6ba-697e-4b25-ba3e-8ce2499cac9a@infradead.org>
Date: Mon, 31 Aug 2026 13:00:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/3] Docs/mm/damon/design: Document hugepage_mem_bp
 target metric
From: Randy Dunlap <rdunlap@infradead.org>
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Asier Gutierrez <gutierrez.asier@huawei-partners.com>,
 "Liam R. Howlett" <liam@infradead.org>, David Hildenbrand
 <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 damon@lists.linux.dev, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260831144732.80910-1-sj@kernel.org>
 <20260831144732.80910-4-sj@kernel.org>
 <f06ca3de-1cd9-4082-8c66-f6a26e417824@infradead.org>
Content-Language: en-US
In-Reply-To: <f06ca3de-1cd9-4082-8c66-f6a26e417824@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 359032000B
X-Stat-Signature: q3o5ooaf9nxr4mdfp3n7ucnc7pcox1o7
X-Rspam-User: 
X-HE-Tag: 1788206433-331517
X-HE-Meta: U2FsdGVkX1+QEq0litYBHXtW+VU/5sdtxCwiVdlgF6UICjh71gjFlnh4zjXEZ0zcX9EtzDyW9DuUZvtLU3iSbQ6Bz1WLG6yWxNZMf6uLj764C3pse5u1J3U4XAIrwsWpbx0s0U/8BHctVAAXiQFX8NsE6gQuD3s6MFGy3NoLVFVm0VWER4inz3ETmtEr1TMIdAEcY3LT69/4/MGS9YiGuef3AEV9Cv13AXGLk+klMOT4HYta3JhwJQi1cfsr9wEo1g7uWUioFjSbXNpNuALZnXpEIpY/Bv0zchnqotF0YWrbpP9lMdmQC4ttSxhd7dhZ3u2+oxeTkhImTavdCJhGu6GOyK+aWNYOHPKgRXm9XYteOPDDcALBSUxd/vttk9YokloB7ZyaUF9uw/7717ESJdJo45sRkdqokkISJihM6eZhf5IlFdhLWSiQ+nipRHDrRCpArhHScJzkyabkoOw+ib0Fb+QzHczTL04CNbUwydtx9kXxsl8uwdEOAkJxou24evOCju9QDIvZZkTrszw58tE73K/MXiedcq+EpCmXanQz2sKnAENPVtHHHr8tUBLi9PrypXnSXwgi2RpwII0vunNasOCd8wgUdDGppeQDOa+x1JyEcx6Pp77w6GVJAyBHc1gFf6e8et2uctRCNIG++1MZ5LSmkIEUIavg++Ld9p3NnaOkeUFR5d6wO9tnflPVW8qDSbzU1KyB+frm/Zi4veMzMJv1QcmABsa7EqDHccXqxYOYdLsolMQiG62dukWasRCUdByfuR09M6AvXw0HUTHEmUDm0ZsbSCz8V9e20uH08tUox0TDfbnkpW22bj6H2ABBBV0JMtsBo9TyCLPE1nWB3kSZI4Ao0iyg6s3AzbT3Srcy98/ERC3K4RdJrttLPOmvB2B12SyY/PgZZbOWTxUw73RxWGWKKZffhklh4MKHq+SjeJuNlcYs2wHwsH1POpAHQGROmnFOC/eN+ev
 0ljIxUAX
 MB3TtvghUv4OaoDD+XFyY0wjN2yKChXo9+xIwtHfqB4Mk1V/FASGtqznUF3JEmvxVPXYE1gzIoVjYY5X2wb9lxwy2x2m45tW0XDocIDBGhH0t3me5OXjfr8rqSqUHqUefAPvDHCPqFQMTcHcB4+1lORY4iFYHEJQwsrxcmRCi6qcaNCQNxZJdo4fCQrkurbk/VaewCLlLolT9umCwGGE2ge9n16ggSmGmSFpoMiO+gp9dgq6tp9j2s5Dd9XUzaqw9dQaPFoACgzlYSzPWCuiwrh/urP73A6VKd0vU9igJ5RCQjpSDgQjbG3kGq2rP5yStSPE8JMflwHJsGdCusGZB9Ni6Xbl+r7Gnd9+RovKgbZjnQZDaaf9uO/fTR9xB24tTc6jf1WhDVyUoztmcev/5GnmM8chxr5+H1Lki
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/31/26 8:45 AM, Randy Dunlap wrote:
> Hi,
> 
> On 8/31/26 7:47 AM, SJ Park wrote:
>> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>>
>> Document hugepage_mem_bp metric exposed by sysfs.
>>
>> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>> Reviewed-by: SJ Park <sj@kernel.org>
>> Signed-off-by: SJ Park <sj@kernel.org>
>> ---
>>  Documentation/mm/damon/design.rst | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
>> index aed6cb1cf4831..a8c163475ef2b 100644
>> --- a/Documentation/mm/damon/design.rst
>> +++ b/Documentation/mm/damon/design.rst
>> @@ -713,6 +713,8 @@ mechanism tries to make ``current_value`` of ``target_metric`` be same to
>>    bp (1/10,000).
>>  - ``node_eligible_mem_bp``: Scheme target access pattern-eligible memory ratio
>>    of a node in bp (1/10,000).
>> +- ``hugepage_mem_bp``: Total huge page to total used memory ratio in bp
>> +  (1/10,000).
>>  
>>  ``nid`` is optionally required for ``node_mem_used_bp``, ``node_mem_free_bp``,
>>  ``node_memcg_used_bp``, ``node_memcg_free_bp`` and ``node_eligible_mem_bp`` to
> 
> I've looked thru the entire design.rst file and cannot find anything telling
> me (or anyone) what "bp" means.  Explain??

OK, I found it on the internet. I still think that it would be a
good idea to say "basis point" one time (the first time that it is used).


-- 
~Randy


