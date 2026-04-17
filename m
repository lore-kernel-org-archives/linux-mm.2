Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B418F436A3
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 13:37:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D68D6B0107; Fri, 17 Apr 2026 09:37:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 987116B0109; Fri, 17 Apr 2026 09:37:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89E406B010A; Fri, 17 Apr 2026 09:37:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7416E6B0107
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 09:37:07 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 25249B69EC
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 13:37:07 +0000 (UTC)
X-FDA: 84668148894.19.CB8CDCF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 652D7C0002
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 13:37:05 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WWtBNl6z;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776433025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eLbu2+Py+Vtizv8vKCaMsuhMYH9vLFfSNFHPfYyH8hI=;
	b=2FGHpu9EbnMGwyfnnnhdKIkmmiovUl4rBaAOKyx4D79Lm2i4UFD0RRl9NtA4AYz4rfzHYP
	F8OAjRF3cg/Mpj0KkfHdt4qgFn/hYaAJ94r68N0twyvRN9mDssDA726/V0ciOSd9+jwWqT
	aRjbPxjg1EBG5aQHY92whAsgB4Y4vSk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WWtBNl6z;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776433025; a=rsa-sha256;
	cv=none;
	b=7MYq7vi8EkMcmYcYkPGbrxggIdc8CSexWgmbQsZAEv1cmgdozdBeAbMGzc63GehOnaBG9i
	GIAh/oHhfkfJOpKmPXhogeX9uCq98mKD9utzixvhG4QomJI3IKJ9k9PT34q79pXLqfpqLF
	F89iIsq1UR7Zddgn7wQdlwVk9mp4Vm0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CE9EF6012A;
	Fri, 17 Apr 2026 13:37:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D23ABC19425;
	Fri, 17 Apr 2026 13:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776433024;
	bh=bLtdG6vevXUfno77DQCP6rd4j5CNBbChyvGTd2cZBb8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WWtBNl6zz4PCRKe1EfzhRc1ltfJAaguYJh2j5+vbHMsP15TfqYUbyrHVChpj2mPYh
	 tzHjLWzKf4qGmLe0DVlJW5GcP15g3vMPXOr5acwCXIMrh9L23yxr26Bq5MYA5qM9/u
	 rP5Ks+3mdYPDOu8HO2McAJr/sgHCToiFxYjQZG5pOQt4Qt7sx/efo5WY59wYunlxZz
	 VSGgEWw3O0HPKZScaeVBH04hyIH086BbOn8e5oEXdxkX7DNbKcuqRJ+7tNVrfDbTCi
	 3cG/PUGAlH79glm0ieLvc/xjmTj5MsGnc/QL+MpHJghvdzNfRmbyNymvB6596Dcmzy
	 PMQ1GPO1obFlw==
Message-ID: <b6519ff8-3a8c-4add-a313-c36b13fad231@kernel.org>
Date: Fri, 17 Apr 2026 15:36:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: prepare anon_vma before swapin rmap
Content-Language: en-US
To: Matthew Wilcox <willy@infradead.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: ZhengYuan Huang <gality369@gmail.com>, akpm@linux-foundation.org,
 ljs@kernel.org, Liam.Howlett@oracle.com, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com
References: <20260417011606.1089985-1-gality369@gmail.com>
 <66f67e51-819b-4c60-9f61-170db32362a2@kernel.org>
 <fb80d953-93de-4ce3-80c6-15cd53dd956f@kernel.org>
 <aeIviKEdw-52J7JY@casper.infradead.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <aeIviKEdw-52J7JY@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 9npxt4tz3wzt9xawsqi8rax4gon9wwty
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 652D7C0002
X-HE-Tag: 1776433025-132886
X-HE-Meta: U2FsdGVkX1+gW6tsMuslaIQSFLGuKvloQd/wj+szlO+NDepoTb4L4Hn6x4OuPi4c/8rmFfHE5DwqalfFJLoo+HUEC/ptDIIYkcbxk80wYVy/IOyqUPE/zpdZFJsUoCzx7JrJmrTQGUxfIRkj6WaxHFnm3fokgpmNbWp558sWdU2HoDbyKw03jIBjte6UAkrlipvQF9GDlST+pWppqygY+teJFipOzQOwQ9NfWmhEsEpMK1VmzpStIhK/QfcFBR4sa8sJzsnsvMhBgjrwV5fQNhfUHI9DgW2L3ftdPndQIl7PfQ2Y+lcvoN7Uxj1fVFipJ4jIWzbWtsCkltl03ez7u0koh4Sg1i8Uhpuw0FPPHBU+fRfF6qPweurgNywuZT2T9LsvQbBvt1g5CJM78PS661Wgvr9HsePEo5/N394W2lv9HvloPw2dy+wtA2GriwxsVH6beYCP/nN3TlFSFKTTRWHg+teUvsXkBV/GMc2R/hHtlDCmL1QX6mfRuOsQ39uN3yH7hbhVrjei15dWWRWBIAwcShToWch5R5qgCjtkCbo1wZEKTEr0P3odGpqM61gQNUWQTSm/6n3y8MXiGXMs+tWKC6RmdCLaNDvLIJMaXHY03aU3NE1RbW5in5OwXb5RrWBnhFGRQWHWHxwADQUA7fZcKc4nj3WuR4w3JJ1wGsB7EzP86CWEBLj30eSt1rKwFkQ4GRKVICxOoJvCatLSm7+Qi2XRqy6vN9FAskC/taTCZ07b61Og7/n5XegT8EDp5tMuR8A9o9Kmx5Q1Om8inihxwUh59VJwfkSEsC4ZT+HxbNbg1ii+h79Hb5bTNriIEwdMga7+4g/RFr0pU1vIpH1EjLpic2//f7AU74zj1+UNC17+OlAjLkvu639zCKO4t1BpLDBY2LUigT5VjGB50PZRI8ZpeLYMGWsGad2GHMiQxh+ySTaUWRBMa/2oycgxPJ5z/UT094wQp4Rbobr
 WnvuuiN3
 78jVTw73F1c5tg9bablB60n4IB/HhH4jX38174We7d3XXrGHvMutQqDk4QmskLwm1DiipHODnpZ3md6630cG7vdOTCAKBF0/oNh6pnMqD3fbjHniXY7+D+Rk0V+V7QSZEgynvTohuHc5+DNpy4BXBS6iO455QUZVUNfASOIUMGVxz3D3wBZLYfO3wd+hmqVRADhV9sfkKbm2YfOzyelRH5q3qQdbFXrmREU/RYSV/K0x/ERbsXRb5ZGDvjyfwz/Hda7MBmJQfPq0aLnisu97Jt84WXA6v9sKiIwUMblf2D7GU8AVQjAVy7LcnA6WsGNRpJS+Cj6hnNrj921ATxs3fTt+cr9Z79kyLuKqzpLP+xG7jbchJe3TLB9cOZtFnB2y0nOdv7YD4lXhp5D4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/17/26 15:03, Matthew Wilcox wrote:
> On Fri, Apr 17, 2026 at 01:57:59PM +0200, David Hildenbrand (Arm) wrote:
>> On 4/17/26 12:53, David Hildenbrand (Arm) wrote:
>> > On 4/17/26 03:16, ZhengYuan Huang wrote:
>> >> [BUG]
>> >> madvise(MADV_HWPOISON) can fault a swap entry back in through
>> >> get_user_pages_fast() and hit:
> ...
>> >> I can reproduce this issue deterministically on v6.18, but I have not
>> >> been able to reproduce it with the same setup on next-20260415.
>> 
>> Just speculating, we had
>> 
>> commit 3b617fd3d317bf9dd7e2c233e56eafef05734c9d
>> Author: Lorenzo Stoakes <ljs@kernel.org>
>> Date:   Mon Jan 5 20:11:49 2026 +0000
>> 
>>     mm/vma: enforce VMA fork limit on unfaulted,faulted mremap merge too
>> 
>> Go into v6.19.
>> 
>> Maybe there was a scenario where we could have lost vma->anon_vma during
>> a merge, resulting in a swapped page in an anon_vma.
>> 
>> If this cannot be reproduced on 6.19+,there is nothing to worry about.
> 
> ... except that 6.18 is LTS so we need a fix for that kernel version.

It's there: https://kernel.dance/#3b617fd3d317bf9dd7e2c233e56eafef05734c9d

> And maybe 6.12 as well (a373baed5a9d went into 6.9, so no need to
> go further back than that)

Not there (yet?) but it was tagged stable.

