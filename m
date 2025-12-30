Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84D8BEE57C2
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 21:42:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E42516B0088; Tue, 30 Dec 2025 16:42:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEFE76B0089; Tue, 30 Dec 2025 16:42:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFC666B008A; Tue, 30 Dec 2025 16:42:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BB9FE6B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 16:42:45 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5FE541A14A4
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 21:42:45 +0000 (UTC)
X-FDA: 84277462290.17.C7E53F6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id B783F20009
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 21:42:43 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aKKAzT0A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767130963; a=rsa-sha256;
	cv=none;
	b=NVeRPLM2UCiikc3iZpdzQi0Vu6slMNFLVI6AgsNQ2RlHxHcaze1/vnCpt0b+//lFeHP/Xv
	1RYCKy7mjqwIRTZ7WCO2vq7xfUOZpfv+08jot1XgAZikQ4EMZJhq+CKgciJxqkKFAMNYG1
	srbiH7l3zeZvk0TEq5b1tAlpf4iJoPA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aKKAzT0A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767130963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5ugkGUV8DVqj0lkKmaWCPrtJ+lFCpgnk2N5eSdDf3Lg=;
	b=Hi/qC0Lz7kefcC8UYzStjcIfcJcKBL+hGNCGX4+jPvkrDy97p+ISkRneocYYg6PWiEwrcd
	k8W0Jl+LAlZZa5HqtLX8F8KGpAf9uC1o6KTghEJ06IzVwqyObyVXCQk6RiDShlbo9J2eGi
	gI1+Q2/9NUB2z1nUXEx5qN8/Pcy8Mng=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9BB0443BBB;
	Tue, 30 Dec 2025 21:42:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC5EC4CEFB;
	Tue, 30 Dec 2025 21:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767130962;
	bh=vDD527Oy8Bm4F8rGqeZpgVak3XxpV3M7Dw51XP6Clpg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=aKKAzT0AOHTF3wCukkrR5NQA3T+2n0I4882tBgClDuVnnveE8wT0QEV9WJgB3A8pf
	 5RWyZQUB+eIi6dbF3pM0E9YACVo7rg8vbCn6U0Fcuaac7+PS6a1Aeajnyj5WjX44Zu
	 zcxBuZ67DffcdsMdkOx4mobUwGke5XYjtZzavqdo8JrbNm02sOfICDifAz2G/E5Ln6
	 yQkBBzc0RNYAjMLKTKOKURwINam7LNU4kO4V5Pkjxly/S6ndVgMPLMB4IWA6w3aa1z
	 dUMzJqH0SVYoKNNt5RgV7BLxvYyNNsMUunkPyjqog5i9OywImEd9UvB2NfGiuKGvLt
	 oGPN/9m8s4gsw==
Message-ID: <a083a5ca-bac8-44b5-8604-638c5eb4102a@kernel.org>
Date: Tue, 30 Dec 2025 22:42:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH next v2 0/2] THP COW support for private executable file
 mmap
To: Matthew Wilcox <willy@infradead.org>,
 Zhang Qilong <zhangqilong3@huawei.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, corbet@lwn.net,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, wangkefeng.wang@huawei.com,
 sunnanyong@huawei.com, linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, lianux.mm@gmail.com,
 Nadav Amit <namit@vmware.com>
References: <20251226100337.4171191-1-zhangqilong3@huawei.com>
 <aVCnMI5gFLTB9UCe@casper.infradead.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <aVCnMI5gFLTB9UCe@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B783F20009
X-Rspamd-Server: rspam03
X-Stat-Signature: ktjingprayiidukeiu8n6kz8hcjh5xb6
X-Rspam-User: 
X-HE-Tag: 1767130963-860342
X-HE-Meta: U2FsdGVkX19vmr6m/a+hPVZG8yp1pMeZTHhr8eME51WeHuv/xfujJ9E8iLw/pqd17JRG7Nd+S4CEIYK0Zhkvu5bWwa8MTMKl8Cs+qe3Nm807TWYtMzgjUTg6S1evwP7NS1oesd9v5Tiojm+1xK5u9f4NQvvnEd7daO12MJH0iMWVl5NxgHov51x1T+IvJG+S38dfgyRosFywRkY5R0k9wi1e7M5tJo/PDynGVxHKDkmTpCD2XJiqiSLGdBzLG8UyFvaMHSVsarkZSz8iZ/+IIZw10/IpYohLJ03pgdLyKhByueMetbve03ikbeuGw0s3bbhi/Wau6Yga5XqPEvGQC+WIHtgWzY/oOg8iaIQXLo0CDCsHpHG8/XWPCRJ3aiB4ODatwiF1VCpNrH9FEzUkUSdNNi0Ip77SbaoLAqHHIs/tTRr5XBw/UTwEgZtqiQfpdCjMLD/e4qrpiukBnaF7RG3t97Y1kaM2rCaLZRCcZQAS3HxQWfXlOTh0ditbWFaiXUd+TsfT4ll21+Pq6yMOJXPLZZNWI5lKccAYy1g/CtndfmYM+iAvOpD1VhyQjxBi5Kb3NSn4KrbyThR7Ez1jAlxwl/IiG9N1r5N1/NL+QD6c7CEu8Gm3h+HV2/Eptmx2yGaHxe67uHRwIacDMV+fAXpOz/+Fxr2itF5KlrKDbjjMe3hHtHv+M0DHr4P3+Il09GuinQ8EbbBSX4XuqtvS7cSUU+plUgiTGqLcfOx/il8MJBnYMKgIZrNa4baE17aGvFUeMXcBXJ554e1aku6nNb8+W/vE81urlr9to3JGvnVeHbUkTc3bClUsaVdFwkg46EKL4gleBDJW5q5ieYZdkkq12EzrFQ/X+AbDtl8lB+ZJfwj0u0/q/ZzQEgFCFKbjguEzv29muIEUh6M1kxPWuPOmka1/1zQmC9Y5TuG8hz4JVCBznXejPCYkBGSUSWU2zG3RsfQPzsrd0JGI+CB
 bKhXy8v2
 K2BhxsIIz4bKUDacCiK2tJmlKbt15zDAUvMm+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/28/25 04:42, Matthew Wilcox wrote:
> On Fri, Dec 26, 2025 at 06:03:35PM +0800, Zhang Qilong wrote:
>> The MySQL (Ver 8.0.25) test results on AMD are as follows:
>>
>> -------------------------------------------------------------------
>>                   | Exec mmap Rss(kB)  | Measured tpmC (NewOrders) |
>> -----------------|--------------------|---------------------------|
>>   base(page COW)  |       32868        |        339686             |
>> -----------------|--------------------|---------------------------|
>>   exec THP COW    |       43516        |        371324             |
>> -------------------------------------------------------------------
>>
>> The MySQL using exec THP COW consumes an additional 10648 kB of memory
>> but achieves 9.3% performance improvement in the scenario of hotpatch.
>> Additionally, another our internal program achieves approximately a 5%
>> performance improvement as well.
>>
>> As result, using exec THP COW will consume additional memory. The
>> additional memory consumption may be negligible for the current system.
>> It's necessary to balance the memory consumption with the performance
>> impact.
> 
> I mean ... you say "negligible", I saay "32% extra".  9% performance
> gain is certainly nothing to sneer at (and is consistent with measured
> performance gains from using large folios for, eg, kernel compiles).
> But wow, that's a lot of extra memory.  My feeling is that we shouldn't
> add this functionality, but I'd welcome other opinions.

Also, I wonder whether there aren't other approaches for such code 
patching where user space is able to create THPs more effectively? 
Handling creation of a patched file version etc in user space.

E.g., I'd assume that a single "patched" version (with a single THP) for 
multiple program instances could be beneficial over one patched version 
per program instance.

Which type of code patching does hotpatch perform?

-- 
Cheers

David

