Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2099D46617
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 21:16:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54F756B0005; Thu, 15 Jan 2026 16:16:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50F896B008A; Thu, 15 Jan 2026 16:16:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 411AC6B008C; Thu, 15 Jan 2026 16:16:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 34EAC6B0005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 16:16:20 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EB58B1AE600
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 21:16:19 +0000 (UTC)
X-FDA: 84335456478.14.CBDD442
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 03EBF180014
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 21:16:17 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j2iuKHAZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768511778; a=rsa-sha256;
	cv=none;
	b=5kvZDP3lDrLuuxt0tyivuHmaLhLb9Rwqj/vdePz4kjZ4tzjxkKAI8IWNKhiSPSJcK5AsGP
	ygRyK3SEyz5PL37EaLZyi3l1732RPh7+DhVasdEJfBt9zI+ZsO+PYiBKo9kaGBPJFCMNvu
	pX4vqHu+EKjzKxWwwPnu+57zZtHhm+I=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j2iuKHAZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768511778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H+9mozc10eWjnSy11UAmVM8jZUm8W/RHgrl10ZVwswE=;
	b=s9MX80SM3NrXpxTCdvuMjwvPy++9knD/j14qEU0ZI2yVAbNISxi/jZ0kocgjBIqUcL1Pu8
	zVyScSICabq48k+aXhpvZXcoKdJbirnxbSv1lrw44ns3XU46mvrrr0bKM0Hm3F6imeGxub
	8PMdRoJ600a/SGY7wasA6qGikQSn5H4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DA009406CF;
	Thu, 15 Jan 2026 21:16:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BFFEC116D0;
	Thu, 15 Jan 2026 21:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768511776;
	bh=NspG+wXtNY6drzI2nCNeIS13ZfZIEcVokc2K7U3gJ8w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=j2iuKHAZFgaG7i6pXaE4ZcsJpB7OEHxj+al0olrVS706a5t+TISYmwqw4HI/L8r0W
	 +zF5ffzRENrfM3nnppjlKrNSiQGLLzUP/PZiUJHgWRBLbwIS+k0cfZ4xcl7n1ZdZHJ
	 e7i4xy8WtpXgNvGVJ7SwPT0J5hoZkPZrFAguTnnLup6j6PLVEqZ2F8Y112qwxZKgs4
	 E11W6eOHEU/ffkw1kaxKc3Z4hrOJaAEq/ZF8egoR99Rc0u+kZRHeDaVjxeTuWf4nYb
	 jiFNfR7QCmoEpngPyFYCfMT/kkoVDWyY0a4A66Z4cWFx4zutdRlWiTEyzaRCctvjfO
	 ByrCgvNIVD6tQ==
Message-ID: <63201bd0-4375-48d3-8955-5925221ae241@kernel.org>
Date: Thu, 15 Jan 2026 22:16:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] mm/hugetlb: Enforce brace style
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260115211446.1429024-1-joshua.hahnjy@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260115211446.1429024-1-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 03EBF180014
X-Rspamd-Server: rspam06
X-Stat-Signature: yxnq39wdky1gkhrecqgmu8jar3qr1pgo
X-Rspam-User: 
X-HE-Tag: 1768511777-495514
X-HE-Meta: U2FsdGVkX19NEzl3jiplm1QX76yLo83gk1kEzNEnODr25MSeh/urcvgevLulVzB3NURbIVPX/Aqt3bPLtKJFkiAuYJx1033gQ7CMeUSLJRYFMzXudRHu08BTO2yej83djcLOJK04N8glwDI45uVUQUiDZy8q7RAqKIwm3OfeHvYUqFdWNJ8549h+ZW+Yt+t80dmYmPrKJoRg3iNHcfUtdMq/8EDLKT+ZhckPchg6nGDkucFF2phGjJTf8UMEOL22A/nGwhQrkLiwYarOU51a0s0ETlJYwj9qxONvc1TmRD8YE7p3ZwNbff/F3y2DHEhCw0lTJ2wppb2oYFeRpvwKvg4UOgeku/a8LwRj4MzKRtVyFPq6iPCL57GlvefM7rujWqLNYSEsLWinwyXOyRpkapuCICsvDWnSZ4OajogK/TIPZbwPR+2n3QzB3q24lgQgQYs3PipzZdlfxSuAh4S60V3SLGLnW8OSj6ZIaTQvLnQp94IJvhjjG1mYuAHvEBEUnwEM4JF8Gm5PKRL5vv+OLSOB8Yh/esZMTq4XR2h77dESqQaVgmT14gDJs9dFE9s1XZtrmQPIHQ7AVKkL7o8dnEgCRnRjXzMbBExAz/CxxJuavSwPT51WJ8JmhXoIupeE7rcRgb8okyDedg9bzj9AvL5x+WqzwihrwW+Eh/LgsIExdv/PvIdFfsNlMa7Bz/zMSICNecGPPev/GKQNPjf07xHCAjusKv1Q9wjTqB8BN8fDmgXT4B5DTcT2K0pjdXDkmDWfzt/nAnVvm+bl25+Kot5M7myE+6bMJ4iFrCFr4qr8E7a46Up0z23r340IHzhDwIhDkQmzUhh03ukXr6at6F+tXS8SbW62ZoGN+8I+AG5bmAu/ZCPFRwNqEmMjZP5qaF+UKKv+qm0cuVkLniUDBxH/OhdCUbogz9HD5nDWbgbMTyqraK+9VifDIptn/zk1bQlZqLABXFVSdTSFSB9
 bVTn2bBW
 jk2PDsaPnzte2UEJYXVaxpJXKJYvxhy6fEcgYhKrZiM003bACion9o+ytC6/iLWLjwo1D9kg+P2S15gQ6YZfjEitJ57IBS2G4/n9NSC8KOPB91KLx21XfffMrBLsEdbFqU2dUvnorxR1arBrccxxwgl6oE9c2j+0fAmxuzoQHyOj4Z4320XMX+XtJGz5HewrLvztMoDYEuvbk+aHpLDFOFHI+Og293ouixYxpUReQS714qWW1DBkeJUlbu6v9OPgF/wWCbjYYNj4MWR7Lm8MGitnQ/mUzkH35Iveh4ndsWXx4H5mDtvsZ2kiAFbz1ICtFbQQ53dbfDk2CzR/f2W7qUNO+lj3qPgigq7J9hLaYW0r8jnTkRLrWIZya3g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/15/26 22:14, Joshua Hahn wrote:
> On Thu, 15 Jan 2026 21:10:41 +0100 "David Hildenbrand (Red Hat)" <david@kernel.org> wrote:
> 
>> On 1/15/26 19:14, Joshua Hahn wrote:
>>> Documentation/process/coding-style.rst explicitly notes that if only one
>>> branch of a conditional statement is a single statement, braces should
>>> be used in both branches. Enforce this in mm/hugetlb.c.
>>>
>>> No functional change intended.
>>>
>>> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
>>> ---
>>
>> [...]
>>
>>>    		update_and_free_hugetlb_folio(h, folio, false);
>>>    		return rc;
>>> @@ -2672,11 +2675,13 @@ void restore_reserve_on_error(struct hstate *h, struct vm_area_struct *vma,
>>>    				 * be consumed on a subsequent allocation.
>>>    				 */
>>>    				folio_set_hugetlb_restore_reserve(folio);
>>> -		} else
>>> +		} else {
>>>    			/*
>>>    			 * No reservation present, do nothing
>>>    			 */
>>>    			 vma_end_reservation(h, vma, address);
>>> +
>>
>> But why the empty line? :)
> 
> Hello David,
> 
> Whoops, I totally forgot to run checkpatch on this one. I think Andrew
> also noticed this, he sent a fixlet for it. Sorry for this! I'll fix it up
> in v2.

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

with that ;)

-- 
Cheers

David

