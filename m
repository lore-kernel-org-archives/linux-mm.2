Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85D44C54F52
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 19:31:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 896746B0093; Tue, 28 Jul 2026 15:31:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 847EA6B0099; Tue, 28 Jul 2026 15:31:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 737316B009D; Tue, 28 Jul 2026 15:31:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4D1256B0093
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:31:48 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D68BAC0466
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 19:31:47 +0000 (UTC)
X-FDA: 85039180254.24.E394066
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id EC9734000B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 19:31:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A0Vfw8tV;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785267106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4SFJdxikqdRNRa/qa+7AI0ytQwewWTG8FQ5aZTm6euk=;
	b=0aOrqW8mcMOySKL0nHTRvcIXPxIWFeNq+fwbiF2ydZhw8YzxZQWFOifRCDCyx/J25tcFb4
	v8E4VksCdkCHocQERX+GTvccPxvO/4tTWPiKLQqmCNU/S959DkMkdGeEu7Xc9Uj1Qz1HLC
	Xn4y0BClB4tMS68w3bX/EjVRrsSU9ng=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785267106;
	b=11CNq15Re/ymiJtPv1+zeuQDeXv2uZYj36GaYi2WPhU+h2d6TC+DZ3R4trdNDUaLpBdbKt
	z63M0bz3uDUQlVUTPzUKCi8F9sveTlrxwjkRLOEkO9WP5CKy4YWnN3v4jHx2w6D+AztvTb
	zpAa5mGBqF4wG9JBzrKqJEWjyGGayH4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A0Vfw8tV;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1DE9843FDE;
	Tue, 28 Jul 2026 19:31:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EEBC1F000E9;
	Tue, 28 Jul 2026 19:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785267105;
	bh=4SFJdxikqdRNRa/qa+7AI0ytQwewWTG8FQ5aZTm6euk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=A0Vfw8tVa40v2HKNYf8m0lH4kJCFp4ZKml4XuLziAL83lsuU3NuSm6WtLfSNK+bFv
	 wETOvtd8y/iDbskOY6eBnYJOEvP3xyv346O99TDQFUWocu/3DkP7XQOXzYVdJP1xLB
	 4iuCSkn8dCmydevlPZFnxS/EdKTD6m7/0sPqwhI8tDG8A4KWgEcB3ouoxtT1hWhpGM
	 XDIDkhyLbSJM9rNeB2mdj6Oyx3lPnqQvOwdv8KsBeUAGiaoZ8Lw+xcaQkJU8WVQMFK
	 6o0W9RAz7Ujj496o9gsZeq9waZoRWNPNpDl4RXzMGxYES7fPkGnP83pbvPY2boZKRM
	 d+4nfiE3zYnCQ==
Message-ID: <580fc92f-f146-4d76-85ce-6555cc3bc47c@kernel.org>
Date: Tue, 28 Jul 2026 21:31:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] selftests: Add missing initalization of pointer
 passed to getline
To: Chris Gellermann <christian.gellermann@codasip.com>
Cc: akpm@linux-foundation.org, brauner@kernel.org, liam@infradead.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, ljs@kernel.org, mhocko@suse.com, rppt@kernel.org,
 shuah@kernel.org, surenb@google.com, vbabka@kernel.org
References: <20260526113848.530105-1-christian.gellermann@codasip.com>
 <20260722130246.2135563-1-christian.gellermann@codasip.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260722130246.2135563-1-christian.gellermann@codasip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EC9734000B
X-Stat-Signature: dey8u34tgbif5nnt9sw73mzqxaipfmtg
X-Rspam-User: 
X-HE-Tag: 1785267105-212813
X-HE-Meta: U2FsdGVkX19Fb+OwPH7A153RTMQZALz2DeHv1l7W+Wtk+9kHgP+KdqOj7OIXtnXikTI6sV+73AUU0ZM6HVzLfE2TH62IcYiL5Vq5FKJS7OM+BFoW1KidJsr6RYAdPWecZ5k0s4c/9hrMTDkDfm+rEIQmSoDOKLkBvhQRntnSctAQMVKNh8OGuHnn/jmjkcK7VMuHRX6wHNJhoHhIDrpPjDTzFuE6x7Iz5gIYAJmevW7k7Wbhz1w3MJ4vqHgZRPG0EnCUriGH5OEahk6yKodOpO3X1UkD5SpIJHMujQtQ00O338b6fSPFx1ivRhiEMHBVnEi1FMt9u9dp9viyxhr2OScqTxP/A6sJRKPiKAoCoy6YtFmQTljAtA4xlJbGScaL30xAsFuBTCG8acUAEm1AtiwAC6UM2z0mlrfkt4qq/g3Byt0pMq8JecCJ6ov3yFoCU7mDFQqCa43tdr3iTQqNEteXY5ykpV+2lLPzabknczZlDDYgnBGlDr8VsZUzZVEod1aZPWYHZWy6H79V2816B+vkFJ3xEpafIymX1V/AchHgskDOW76obq+3hwX9rK+k6Oc88Gg8GeyLQ1JUfa12RZbcwcCdOWBPokaWxUcPtDLPU0LMP6Sxq55bS2YSUscSRWO0KmX+O8x6Z4LJVkTu4jjV42LPyol4pO5SnC6PIY7BFK3pGZRhev5B8XdG+FzjNAI7q2IS7fX6w5DJ624UmAg7yZ94hkz7F17u1t3pLzqLe4GRUmq5OBLtwtvZPSxYmNrAFCqKxqUGAqAHZU/xqHEQDIgfJq+fyHYSDHttD//nxpf8IH7m32EJRShqyZlaT7K8UeAh8aUdqzd+gvLovSrbI9C+v+yn9MYFHp58fyXpxKArLGp0daOQlj1mFG09Wkl8oP/zkbTJbhSR+V6HdvH7yaHnj6Ktq2wxDUDnSAG9TmflPs/RlZdC5Eddnpc9e5X/cxUZ/ofOsewkdJH
 nnYbuwSM
 DdVckDtkWUw+ccYS1XUYnfF6mFwOeQtqIdh9hH8YzcMt9fNW4r0sCiqLgPhjf/mOwOOZ95GnpBE0T8gHBkO7QzhXC529v8xcognXsvex0pBsHjshRFHo0570EywmHeBz9MUYCjdSt8Rb7gZD+vo4nskTSTa7M2IGwe82eqhWM6mXlSCCsaFg6LYaV7OTYEVhNNQhMnSULjtOYQIWXD7m8HOSX+LfGLuLhDZ84SuZwfbcpmD2qb66n3CLbeOpw6bOu15wM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/22/26 15:02, Chris Gellermann wrote:
> Hi there,
> 
> just a gentle ping on these patches. It has received an acked-by from David
> Hildenbrand (arm) and a reviewed-by from Lorenzo Stoakes.
> 
> I'm resending the patches as reply to this cover letter to clean up the previous situation.
> 
> Let me know if it needs any further change.

Have these been picked up in the meantime?

For future reference: don't send v2 in reply to v1, as new revisions might just
get buried in other discussions that way.

-- 
Cheers,

David

