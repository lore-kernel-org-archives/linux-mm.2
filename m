Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04C09CCF2DA
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 06:25:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBAD16B013F; Mon, 19 Oct 2026 02:25:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6BF66B0140; Mon, 19 Oct 2026 02:25:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C81C96B0141; Mon, 19 Oct 2026 02:25:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AB8C56B013F
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 02:25:25 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B1C2D1A0649
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 06:25:23 +0000 (UTC)
X-FDA: 85338388926.27.7F6E451
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id C074940002
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 06:25:21 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=PAjLuW7o;
	spf=pass (imf12.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792391122;
	b=hDbjm4cCcflWEHdLCozQZQaozkcAsjVA2Tl2uA91lVrzrW4LrkM02mdzPpZ0KCBnbQrllm
	SviWCzXKJ9S7fKYYggKu6rLtdrSRWinq7HYdvEJpJhH7X7XZpwdHmURliUHLPaM/oCpT2R
	HJ8foTsfKUOYZ+eVdle3SJkYh4powWM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=PAjLuW7o;
	spf=pass (imf12.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792391122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XN+K9d8x6X2efXo7o/Md4BoXf+qoI6rmokNsGst2jzM=;
	b=HSfc8tR11xm83P0QS4jERz67VS/glFmcS8IIVnmWyrE+z2F/sv9hewv6AXjMbE1XiZqEqf
	0XjeZcEkLAzh06rK+y8g1XLKtONRk7i0VEj1nEYPAX9rG6jAcKSdzozTBJ+YN61ulbTvBb
	GjIxpo5pfGaDFW6zC6uAcAr9cTX2QZU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7E13A1477;
	Sun, 18 Oct 2026 23:25:17 -0700 (PDT)
Received: from [10.164.19.84] (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8A8423F673;
	Sun, 18 Oct 2026 23:25:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792391120; bh=55RfTNFBQ9bYI0TDGXnU655P/5to3Zf/3l6pm2G36ns=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PAjLuW7oV1dFsO9RUkEDuhzNJVk/QIY1FdzjBlsdfuae1ojCAEHeWbysLZQS33AuL
	 91afN7as3b2wVL8PgRS7QalzNL3VJmXu5G34VBJSycUtx5kDnNHbQGuFmbHivrXfdR
	 PWNX8NdAERb2KexXuzG3pP1o8xO/AUzTHsFH5Gv0=
Message-ID: <d7b1711a-44aa-4169-a250-227a172f4125@arm.com>
Date: Mon, 19 Oct 2026 11:55:12 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: keep ksm_tests on small pages
To: Qiliang Yuan <odys.yuan@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Usama Arif <usamaarif642@gmail.com>, Yu Zhao <yuzhao@google.com>,
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261018-bug-selftests-mm-ksm-tests-nohugepage-v1-1-55ed54bdad35@gmail.com>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20261018-bug-selftests-mm-ksm-tests-nohugepage-v1-1-55ed54bdad35@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: C074940002
X-Stat-Signature: oossos95kxk91x1tzp6hkkok8jk3ncth
X-HE-Tag: 1792391121-696675
X-HE-Meta: U2FsdGVkX19TAJmLN+ppcmD2AjE8NORte1lvPlfKVnuI6nZYFePVuHgYaRYef2hTECS1wdDcarXqGpzOOb3oZkYHSLUaLnXkmsEq0SUJdusgJ+gOih1jY+fJmAJW7kLbmLKXUeLN4qXHWiRzKcmkmBOb8O4684QBIfOz36J/lJzDPS9i/pCL8k1tVm+FYnagT73W8ryTIYVmaOdSC/vOd9tgJZFOaJIVO20s1D/qFhmBfwFVtAmKn96NfBAVnpQKlj3r8n0TX8U+UwGkqscsmFHMtISOCr/adNgbrW03dR249n+EW0Mm96uUzBqW9ZQo/adRDo/iUYsPDCK/yZtRsbcMFd0wSNiA827jSZw10dZZFDenEqRBmJGlH9ni+sgwhmAsFv49WrRoDVrNQA5YnIaPqwZuoMVglWUO7TxnzuV/8Vaywqffljk9Rqla9gXvWTBWKiaNtVRl8MaCKjUDYL0z04hbx+/VokJUDa92wVz75KTS3d2UbRH5pnBmdd5hgMfnoHzL8+yv4+J4ibJAkW9IAU7LWWn3554g0LOVodsrLD+Tj+B4sQKDZpNW8NVHBgeKWHEnAy5TvoPqGjT8W4aY8njUmMmhigR4iFtt7gZgBPGRGb4wparSbRGzCk6DN9nkILiGqUE2CzPDrQeJo0+aLLYTfM+snzFiosFVN0VFaskQ+unZbimHmpzSrFiMth+6i6WIaCbZFlkEhyuvMa8M19Wq1OwjvzohdDwajGcW11N1gnOQi9PQPI3NLfnIyZxBJ/CxlCaCM4lrc1G6BRB26GJwRnIW/u6AfoHaZtEgWYXZ826XXO7Bu+dIfqtjND84ejIoLRZOjyx/TOqqKm3/o/Ru6blCt9P/RqvfroWAbhzhD+DQ16xYtdNATJiuxmRq1ccSM3/gzmtJgAHJvMEyI5sz1uhM0/2IjMuVtNY1vMTlgf9OO+oXp9ezaE6OWEhMwgHxbqaEWlvbZct
 3EGx83YF
 QtVT+KWUjTigCHnx8DCEp5PGW2QJcKlLL+N/Gw8Y/MSVf+hdaXyzoClrUZFY4/Kd7cGsL4cBuwRo4MOD7nT3w96fiNnm7AQmztQs9gELJe+JZIOS47Wln5D6/XA6gtKORhrpiao6zw3KB+BP0kjxg+1eZbMRf+rUZtyKgjDAmE4a84iPTM8hh75tcsrv3kWsep9G2NE2JNrVLEQoTxFDt2KCPbEto8zP0WofKnj7bUvaIx5EnQwIDlwdjyPdTTZN38RPcxHVrrbenhEjSPuw/hNibPPsQ+u6EGnxXRxRWTi8riaSDzIAWC2e2jklcLO4VhqP+nMELsukeo4ujZjXFQ8gUOkJGn0JpAo2i4yBmISsz/lRQk10sPmcjsC6XCNPCZwm50aDmQXepXdHopLB1EY3V2s0dg+IVRr1yDhNmmr5mGuHBDd1c9sJwZrqBckbMb+Uc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/18/26 10:23 AM, Qiliang Yuan wrote:
> ksm_tests fills regions with identical data and checks KSM's counters
> after merging them. allocate_memory() maps these regions without any
> THP hint.
> 
> With mTHP enabled the regions can be backed by large folios, which KSM
> splits before merging. Splitting an anonymous folio maps its
> zero-filled pages to the shared zeropage, so with use_zero_pages=0
> those pages never become KSM pages and "KSM zero page merging" fails
> its count. "ksm_tests -Z -p 10 -z 0", 20 runs:
> 
>   THP setup                     before    after
>   default                         0/20     0/20
>   every mTHP size "always"       20/20     0/20
> 
> Map the regions with MADV_NOHUGEPAGE, as ksm_functional_tests does.
> ksm_merge_hugepages_time() maps its own THP-backed region and is not
> affected.
> 
> Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when splitting isolated thp")
> Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
> ---
Tested the patch by enabling all mTHP sizes as mentioned. Before the
patch, the test failed and applying the patch fixed it. So:

Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>

