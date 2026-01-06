Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02B6ACEFD04
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 20:04:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AE796B008A; Tue,  6 Jan 2026 15:04:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45CBE6B0092; Tue,  6 Jan 2026 15:04:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3340C6B0093; Tue,  6 Jan 2026 15:04:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1D5F86B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:04:06 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D4F3C1A0A7F
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 20:04:05 +0000 (UTC)
X-FDA: 84302615250.16.F63B849
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id E402420015
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 20:04:03 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VJJjaibs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767729844; a=rsa-sha256;
	cv=none;
	b=uAeYYi1YwUWmYG96s5P6TnmGX5zOqYcLE42gv5Zv/4x9Fa8aCwH77B+iLQWTk/RPahcJCr
	EKHsq/6D3DYUh7uS9b4jssJxI4vk5ss9RiWQYjUqbc0rHxR7H7oYNK5/Q8Itk3zWGv+CqU
	NPXYiJdFIrmmIrs9Pa1nPKV/PpIUqBU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VJJjaibs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767729844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JpvhbI/N5IToLxrIUrMGgHGqxlfmj9eZ3fPKasnbxsc=;
	b=j6pxQEkhcbvGiqmxV2nwEmEu/Jfs8m+eY77NOSrIOdvyWqdWRkxcjymogttb4yjzNF4H0O
	8YU+yAdlY1puipRzto3Xnl8dQLADDqxPY38gxYzLCsVvi41GUkM2PqmNnWgWtmkcD2ZJF8
	BuH6e6yedNyVSUyGQ8lLq3fkltH+wE4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ED1C860008;
	Tue,  6 Jan 2026 20:04:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3813BC116C6;
	Tue,  6 Jan 2026 20:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767729842;
	bh=Q6xGZJmPaIERTQ/PbYnzfWP+ZBaqkIj/1xfOlvYbOCg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VJJjaibsIHpdBm9Dc8E7uYrAZfg7FXmoqZrc0K/k2QtFykZticTsazwBOnHIMOhN1
	 JNCvpGF5V/91NM2XYkj7sAgNZOQwpYcROcU62wtvWRwwYud1tKC3dPpgZyWhC6xDDe
	 aBy2rN//OuG017ao4sgjFjv91qhvkK/umSd8ktWl0mrGZ3fPqA376MyJ7PS6zIIA5U
	 cjq13EaB6MG7z/08sa16NmgtqWzQv4TufYJMviM6VgRkYPNG0f/tEMQ/1aFqCzqvmq
	 BBsb4kDo/0AFFiKGg6VTqQv99ZPgPo+BalmB9qbIUvIWc8TWurjbJaUW+39s6CF4C3
	 PxPNyi/cORVDg==
Message-ID: <857be078-1464-4e29-979d-0459cad8508b@kernel.org>
Date: Tue, 6 Jan 2026 21:03:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/2] mm/memory hotplug: fix zone->contiguous always
 false when hotplug
To: Tianyou Li <tianyou.li@intel.com>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org, Yong Hu <yong.hu@intel.com>,
 Nanhai Zou <nanhai.zou@intel.com>, Yuan Liu <yuan1.liu@intel.com>,
 Tim Chen <tim.c.chen@linux.intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
 Yu C Chen <yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>,
 Chen Zhang <zhangchen.kidd@jd.com>, linux-kernel@vger.kernel.org
References: <20251222145807.11351-1-tianyou.li@intel.com>
 <20251222145807.11351-2-tianyou.li@intel.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20251222145807.11351-2-tianyou.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E402420015
X-Rspamd-Server: rspam10
X-Stat-Signature: jyxt3rmfrgnznfhk88s8cqq37oo6koge
X-HE-Tag: 1767729843-456134
X-HE-Meta: U2FsdGVkX1/qgOV73J/fAmFi8YcsS790W6rar93uGv/h9SmBzkw/cAJsrs61O01DRnXzE0TfZ6hdmkQRRYUj4OFSf/rPXzNq49eCfuqRfRKQROXexmKeHg1ouu00WlRBOwNOKMHHOJRNscZ6xHB1+3mrAVD7hv+F/KS7pUnI94Cf1/SN+40617HdqAnd95KyWAaaCKPqRG4h5VxqY7tkWmx6Fiqv4CZIu9896vGDJu3C50SUb4sPcyAPKYNW3EarcpLUrStGdQoQvsxMOOGO3bcMc+ZIxzrkMSN/QUA2Td1lUQgkLeonAXo8cp2hw1EAcuuP8SMRCLIp/cjsh4IOroZPnonXDqiMqb0F7HO8C8PwC/1HihJKB9n9gOsup1VuP/uN8OOXPWPSf4sh+OuWqpVHfQDUS9X9y0LWoySFaHgkS5KtMxFuTGXBnT0JvFAQ168erBQNZPyjXarLkPfl2TX8IM3i4IZpsaFVpzNcF+9iTAAhrSX3bHv8Lsgjcqr7BkvmVda7jPcNqz2NmQMP69e137NmMxIIAdgFrKRZv4+4M8JBNq0g0tCYiOFDrA6cpay87CJf0+Af92zQjnki8mP9BKYrYFiYGrxD5c36a/2Yn2o43HlDQwQu6yqHoKDYtlLwe2ucZ8tvSmxPi+bsyVxX0A37QuE4Sev4q3mPEZW3AB0MhhdeiG90FKkTblOeLvb1P/x46JCHM+0WErQkKjiLKTRL6HI7jcuOhnMuZ8w+U4i+RgIISfF+lXjV0GYebsrNIn9eAnapN1aA9DpABMKvsCFtNSfYK5JOkaEdQkvArxyPOjsUX4tE+TM4UOalh6Fp/HgXk917Glx1lFZNxRFtpoGwXFJEjV7AjZukwOL/YhXNn8JRK5q/fGHB4d1QO9ntIfItE3DqyIuOpf0BoVVi6pXa0ZwcbZO6fuYxm75w6Y97H3JVWSPm0u7Ziw1eZgkZJZ5L9pj5Fn1R8Kq
 ehARlpPG
 WcsGvd8sZ/VvddZ+gHpz09DrcJzJH1w1jBw5hph0KGyyJTncg033iPcJVElFkc7yBH1xRwXjGhtcXAHXoSEj+DDxBgrdiybgdBqWS3kzO5p8U4OaLD5bPqviJCdTjXRTJZxQOkm8iZ46yQUZQRCmW7pNyO3buH4wjt7EYT3epMKseinvUjyVyCVaV5/tq1nLpAZACLKDeQbgbdiPWeAnelU9L/0oiGFTIcokS/+R3aqTh7Hyn0d0bAZO9bO+ibDhn+LFuJd8xYwkOjBtDWolN5QAgWYJ+ZjBYQDGj6FBk4hIhqs7VObCP1uN1xnx24ugqB14nfb/ZgLnyFqU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/22/25 15:58, Tianyou Li wrote:
> Function set_zone_contiguous used __pageblock_pfn_to_page to
> check the whole pageblock is in the same zone. One assumption is
> the memory section must online, otherwise the __pageblock_pfn_to_page
> will return NULL, then the set_zone_contiguous will be false.
> When move_pfn_range_to_zone invoked set_zone_contiguous, since the
> memory section did not online, the return value will always be false.
> 
> To fix this issue, we removed the set_zone_contiguous from the
> move_pfn_range_to_zone, and place it after memory section onlined.
> 
> Function remove_pfn_range_from_zone did not have this issue because
> memory section remains online at the time set_zone_contiguous invoked.

The description is a bit hard to follow. Let me try:


"set_zone_contiguous() uses __pageblock_pfn_to_page() to detect 
pageblocks that either do not exist (hole) or that do not belong to the 
same zone.

__pageblock_pfn_to_page(), however, relies on pfn_to_online_page(), 
effectively always returning NULL for memory ranges that were not 
onlined yet. So when called on a range-to-be-onlined, it indicates a 
memory hole to set_zone_contiguous().

Consequently, the set_zone_contiguous() call in 
move_pfn_range_to_zone(), which happens early during memory onlining, 
will never detect a zone as being contiguous. Bad.

To fix the issue, move the set_zone_contiguous() call to a later stage
in memory onlining, where pfn_to_online_page() will succeed: after we
mark the memory sections to be online"


Now, there is no need to add the handling to 
mhp_init_memmap_on_memory(). Note how mhp_init_memmap_on_memory() in 
memory_block_online() is always followed by online_pages().

So, it's sufficient to move it after the online_pages_range(). I would 
also add a comment there saying something like:

/*
  * Now that the ranges are indicated as online, check whether the whole
  * zone is contiguous.
  */


Can we find some Fixes: tag (which commit introduced the regression)? 
Likely we want to CC stable.

-- 
Cheers

David

