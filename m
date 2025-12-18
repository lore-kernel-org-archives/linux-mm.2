Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C08CFD6ACF3
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 12:02:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 371AC6B0088; Thu, 18 Dec 2025 07:02:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33F2E6B0089; Thu, 18 Dec 2025 07:02:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2732F6B008A; Thu, 18 Dec 2025 07:02:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 173076B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:02:24 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D9527136E7E
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:02:23 +0000 (UTC)
X-FDA: 84232454166.17.9779143
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1A48CA0023
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:02:21 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766059342; a=rsa-sha256;
	cv=none;
	b=iuJ9PVEmX2EsNgx3BotFLq/AGMsjhgDJgHRVh7ynQaOW0JtkltA+ZzALGXmTjyyGtvfrcP
	0N5sJDrG95kJPYXMqOLZSjPw2QMkAgUK6QHNrtxjxAwvc492bGLv/BUdQX/xpkAFUlA6Se
	Jvomo2sjzFZOMuC+LVTUrt4OZNgZJlI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766059342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lw1F1nlXJHe3DyHwSaxKqYXlRuu7iBVwkmxpbMVNBYU=;
	b=T4vXbEtmd5C5R6n1+yWT3SfNYyvYejiOyKG7NL0fh4qx0SPrMNMhij2Ui2ClXdr2YcfU0k
	OKLdJDKlHASDXIZ99yorv2Zfs6jw2E8c9CpTsMcEIDpAzdqb81mhU1SMVTzGIG0pYyoc2F
	7QJn4awVjSMFLwuUCJp4Ds+MV6zY1fk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E31C6FEC;
	Thu, 18 Dec 2025 04:02:13 -0800 (PST)
Received: from [10.1.39.180] (unknown [10.1.39.180])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 029FB3F762;
	Thu, 18 Dec 2025 04:02:15 -0800 (PST)
Message-ID: <0d08b4bf-35c5-4c63-964b-ef886b8262d9@arm.com>
Date: Thu, 18 Dec 2025 12:02:14 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] arm64: mmu: use pagetable_alloc_nolock() while
 stop_machine()
Content-Language: en-GB
To: Yeoreum Yun <yeoreum.yun@arm.com>, Michal Hocko <mhocko@suse.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
 martin.lau@linux.dev, eddyz87@gmail.com, song@kernel.org,
 yonghong.song@linux.dev, john.fastabend@gmail.com, kpsingh@kernel.org,
 sdf@fomichev.me, haoluo@google.com, jolsa@kernel.org, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, bigeasy@linutronix.de,
 clrkwllms@kernel.org, rostedt@goodmis.org, catalin.marinas@arm.com,
 will@kernel.org, kevin.brodsky@arm.com, dev.jain@arm.com,
 yang@os.amperecomputing.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, linux-arm-kernel@lists.infradead.org
References: <20251212161832.2067134-1-yeoreum.yun@arm.com>
 <20251212161832.2067134-3-yeoreum.yun@arm.com> <aUPJuZINNuNxddRX@tiehlicka>
 <aUPLCPAyxkPeBaoD@e129823.arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <aUPLCPAyxkPeBaoD@e129823.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1A48CA0023
X-Stat-Signature: sfkaszm4e1szrrb1ery48n5t8qb968pm
X-Rspam-User: 
X-HE-Tag: 1766059341-225262
X-HE-Meta: U2FsdGVkX1/6uQw0CaPCT5Zsp60VYADs7zxy67d92J7oX7IQxBQOiS1jnewqQSkOnFT1GgUPEl6IDZKfceyvGIDCJYtkhfYBoqH3kHQq3F9uBXviElxKtw6zJKU1tK+Hd0DJBVJ1FsKNvqIZp7wcER1G9lr4I1uw9WET7hRTipMwWcZGS1VXs63XQ8NTcYlileuyRMsmeJpnDfvk/DFvysHg4kI8qc2w7ptn5TEH8fwA4tn4XyKrLJRrqlGU+vZ1qXp+vWnnjx4cQrFneyt+XHThXKf999QXsFZ1woh3egDFXrSFfcakhON+OqAm3pijDKukdn5zektPlnS5B7Uu2FPZpXVkhw5j/9VQUghtcgr0MLAKkdsnf3Js79IPRNpR3SoLsKR4W/PWX159mgXjeoI7UAvG+w1PdT8uLurGlB/B+05YGyXiKTGM0cnNhejLBBS3sAPjp4BTLcV3VQJmbdIUcKnF0KNRud1sOty31JdXB9WMdAQTvCpAPv80XMrnUWUZato3zMrwtzxFTYnlK8sGh7o2kNlpl8WZO6k3czv67KLl3UbQQw+5X/c0GqGi16bxSlWdgzEbJuMUkBPic7Hc/wPXFuIrTUAq5rSy1m6JwgPsSRzLXILVLlCZhtnYSJzksa3DrkN7kaP+YS9TcFIzFF44yykrCRo+0NBBjZc6pQo/YQsqDeKuKgj0Rk01hiQl/xF8EVbLxxzgjBR+xpDa772sLAcDP0TNDw9bQ+bN7x6py00vrPjLWZoOH9e7JnRkrLcfIcACc+hcAUFF7khyfjCld4OykHwOMbDQzHNp0SR/Ys/ALMyVaICv81tQcW5zFgxi6fQYZ0bQ6SD30xCANBjpjvmIYPSS/JKbR1psEkCCjUeOtmYviwIFAJEOtMhHX1RkLM3TSaTHeHnj3byLWUpGdgjEZor19mP6opafNIGpsirHkGW51Na8DP5x5f4N70GekkUAA/f3jF2
 /J7O1YDC
 sr5PNEQe8ryCXLkbnJPd1a1CnfoMkyaIxcqOLjqaINtplaL+aNoHds5JI6bLFZvOMpmVqqXRNyfVYcCnK7lLLwHPkaOxu0q8ZX5cXf4Ym75NuGaJzUg4UZV2frzfbsX1r19H/LEIs3JdrSGzthqpzoPk7wpsPkYlBEAQnZKvqmMeCRNm74gKYwsB7SuGdXl9qyTPuSlFXQd/qYWXP4Dil3gNfA60iXPncI12usxxljQY4cVPnHH3c4+kYbk9GUoWxuIgpw2OLtSf26KA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18/12/2025 09:36, Yeoreum Yun wrote:
> Hi,
>> On Fri 12-12-25 16:18:32, Yeoreum Yun wrote:
>>> linear_map_split_to_ptes() and __kpti_install_ng_mappings()
>>> are called as callback of stop_machine().
>>> That means these functions context are preemption disabled.
>>>
>>> Unfortunately, under PREEMPT_RT, the pagetable_alloc() or
>>> __get_free_pages() couldn't be called in this context
>>> since spin lock that becomes sleepable on RT,
>>> potentially causing a sleep during page allocation.
>>>
>>> To address this, pagetable_alloc_nolock().
>>
>> As you cannot tolerate allocation failure and this is pretty much
>> permanent allocation (AFAIU) why don't you use a static allocation?
> 
> Because of when bbl2_noabort is supported, that pages doesn't need to.
> If static alloc, that would be a waste in the system where bbl2_noabort
> is supported.
> 
> When I tested, these extra pages are more than 40 in my FVP.
> So, it would be better dynamic allocation and I think since it's quite a
> early time, it's probably not failed that's why former code runs as it
> is.

The required allocation size is also a function of the size of the installed RAM
so a static worst case allocation would consume all the RAM on small systems.

> 
> --
> Sincerely,
> Yeoreum Yun


