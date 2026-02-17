Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CE4FE909BA
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 15:31:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 921D86B0005; Tue, 17 Feb 2026 10:31:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A5616B0089; Tue, 17 Feb 2026 10:31:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AD4C6B008A; Tue, 17 Feb 2026 10:31:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 679246B0005
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 10:31:10 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0CB081B3F8B
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 15:31:10 +0000 (UTC)
X-FDA: 84454337100.09.F24B72D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 27FC6140006
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 15:31:07 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qoF2bGB4;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771342268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VibcOHxUnl/NZoQHJmtE8kefvpRGSAcGan9/Dpa0Or0=;
	b=1iXVZ3KuxAXPcm18Vsu/QpRgW8NG8TAKGf6LI+Su8lImxDEos+T0ahVoCzlE5HBxKa+Afh
	eLUebFAUimwOfoCYHxTDuKW4Cwlgl+zA/fb8z2leevYuQzPTE9fZWnztc/oIwdKOdhINdM
	n4NSbnwLTg/WXF9ppmpoIjsOUpMNJX0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qoF2bGB4;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771342268; a=rsa-sha256;
	cv=none;
	b=Dk1BrhtCaulD9/y5baNdU4zhnxtGrhzPnOwVCYiLN9Cl/n1J7b080KrN66SOEJEApWoK23
	elIk/Xbu4VMibrjBKF7x9vgGB3GqqK+agRPcE54Y15lh4my1vOxCYrUbg7n0VNDn30x2/k
	z/ERSs5T7O5CoKZWoFmTM8FY3VCHMH4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EA5504195B;
	Tue, 17 Feb 2026 15:31:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E7BFC4CEF7;
	Tue, 17 Feb 2026 15:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771342266;
	bh=fqSMcax7vtm4ZgUHabaHUWlF6/dmxm7Ucda8BEDwr9A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qoF2bGB4TOpQ2SGQahjnxSiiPTt3l/CjhfM3VcPrE9zfdUGNUHZ5MoONmP6xrsz/A
	 HuS0th4xYMm8GGrVHYS04f+5fToBqo3UmpmZZIEhJBn5b3TO/3L0dkj0xcbO6HWCna
	 Y4tXZ7vizt4Rpr4G7DLZTmVCZtTVrGWANdY0nRvOPJtTylE5LNup/jdvM5h9+Cl1IW
	 zIPwkdu529QzsQ3sKTP+H69byLiMQiZddDetCvSQ2SBNzGQjgful6ZB0+LRhUFMqaC
	 RJABvnyMSVPdmrl08JxW0mYEpMJQGcbXlgtAJiSSoytjlV9CTtvVzHmBr/b7rQFN5R
	 FB6a/EZiXciLg==
Message-ID: <2e68ef61-dcf2-46b2-913f-14980a104faf@kernel.org>
Date: Tue, 17 Feb 2026 16:30:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Per-process page size
To: Matthew Wilcox <willy@infradead.org>, Dev Jain <dev.jain@arm.com>
Cc: lsf-pc@lists.linux-foundation.org, ryan.roberts@arm.com,
 catalin.marinas@arm.com, will@kernel.org, ardb@kernel.org, hughd@google.com,
 baolin.wang@linux.alibaba.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20260217145026.3880286-1-dev.jain@arm.com>
 <aZSHvt9Trlq7k7aH@casper.infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aZSHvt9Trlq7k7aH@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8gycbmtiif1sekgmjwbjrs8hggxqkiyh
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 27FC6140006
X-HE-Tag: 1771342267-717316
X-HE-Meta: U2FsdGVkX1+7xYYzUI5dGffwd/mI8oPbea6x/9HOoRA2/NNXSIQIE5VMut0fs+SA/rtUSvMlFOY74s0ElXVfRL+JasxQpTOzl48KmGJa4Z1EVMKrhtCn4PvsCmsOYPceDS5TbE8IM+WrBndOXjxk6BzoBK0bkFPfEjK8NgcctDDMnZvD+r3ghQQMAW22TTn8PRK/3yyEImtnkZYV7n3fnTSplY37YBrMpnAujoQbtbmPEFRvKWbU3Bofh1IvBV9D3+fsGqNxx/huCyDrGlje1BugSogSDOyVN2VrLuLC6p1ZML8lJHKKTrW2/qi59wP1ehdAiMlPCnGzOChvy7uX5GWJ5a6Wf8HDGhAZmUei95XT0hLV+cb0WxOo7CuUgN0B8cxnQdDAD0mOvUhY1hztNoPK2kRy6IgZPfyKN1AKEiN2Ap7KVFbmWHPpZGm1f87hejgvNosDfvAqQAAy70pVmTtKoZiTXIgKtPP10/KnAFQovwPDow7c57PwD6papEO4hAHkfb4tDO+2iYR3paOZBIOmqGOO/cpWDMjs4VPbnMB2WE9OfLLXyXCyH6M8HuyRFrnfI3T04HOyX3Q1Q0S7E5NYJpl4o46nsZGAOM1I/e/TMuWFoDCCbG6o6u/jxea094IsEKAVfi6yUH3GW1Uy5xOe0oVVemoG2RMIBaUJOiXsTJmqA3HZ9pK+i2uSsl7gVQMcPzVG6DplaoFvD7N8ySlVqB9hWVyeRoKjOGEr4QalcaSzg7PhV7yKcRMEA5Kc1PDge0mfNlW6avgdQ/pRZpGBJ4Rxlwfus9dUKD4pp2QapmzOZ6lJWdGgdJu5EaObFnc/cqq368REG3jKpARBGLNmwypYaQphIBjY58NZ4OXTnffKlGr0FDGCk0Bfi2sS1iWFTCP9XdJ5cO3nglL0sBXQdl42rDSmwgeNpcDvTxxsJRxOLmPIXgDb/t7OtWRGEL0W2Cga98mOX8UZ0Qx
 l6ePF2jb
 QVcLJQXJB9HXgsIUily7085nPt5Ws7rPYLno1zKfok8jwfy218k/bVXJYIQ15mOrQNWJQqa1c/SJ+eAChUi20zNglqzpJVvepxTmhqclT76UW6nXeodOlKuWWJkfbIWu+kj+izc5B+p0qPkHDXHpx4Hfj5FE6qa43QKvXrbh/yL8PZ9m3GB0Ugc1yHAV9Yn1WpWGzvHTd154yCSo2Rl6VfHuSbHqU7F0YEegT6YSfUHEgkPWZGkHCu2ibNUcfbJKB/sFD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/17/26 16:22, Matthew Wilcox wrote:
> On Tue, Feb 17, 2026 at 08:20:26PM +0530, Dev Jain wrote:
>> 2. Generic Linux MM enlightenment
>> ---------------------------------
>> We enlighten the Linux MM code to always hand out memory in the granularity
> 
> Please don't use the term "enlighten".  Tht's used to describe something
> something or other with hypervisors.  Come up with a new term or use one
> that already exists.
> 
>> File memory
>> -----------
>> For a growing list of compliant file systems, large folios can already be
>> stored in the page cache. There is even a mechanism, introduced to support
>> filesystems with block sizes larger than the system page size, to set a
>> hard-minimum size for folios on a per-address-space basis. This mechanism
>> will be reused and extended to service the per-process page size requirements.
>>
>> One key reason that the 64K kernel currently consumes considerably more memory
>> than the 4K kernel is that Linux systems often have lots of small
>> configuration files which each require a page in the page cache. But these
>> small files are (likely) only used by certain processes. So, we prefer to
>> continue to cache those using a 4K page.
>> Therefore, if a process with a larger page size maps a file whose pagecache
>> contains smaller folios, we drop them and re-read the range with a folio
>> order at least that of the process order.
> 
> That's going to be messy.  I don't have a good idea for solving this
> problem, but the page cache really isn't set up to change minimum folio
> order while the inode is in use.

In a private conversation I also raised that some situations might make 
it impossible/hard to drop+re-read.

One example I cam up with if a folio is simply long-term R/O pinned. But 
I am also not quite sure how mlock might interfere here.

So yes, I think the page cache is likely the one of the most 
problematic/messy thing to handle.

-- 
Cheers,

David

