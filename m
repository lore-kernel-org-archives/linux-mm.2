Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 901E0D2A54F
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 22:16:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA4396B000E; Thu,  4 Dec 2025 17:16:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C52DB6B0023; Thu,  4 Dec 2025 17:16:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B692D6B00B1; Thu,  4 Dec 2025 17:16:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A4C646B000E
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 17:16:55 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4FD6DC03DB
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 22:16:55 +0000 (UTC)
X-FDA: 84183199590.25.625DCAD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 89C68180009
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 22:16:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KBuApwTD;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764886613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sOX/TOsanFFog9S4Tjf5TWZloru62X5i8eBVTOZ0QU8=;
	b=35R3i9NUMxtYRlwR15ahTBOazaniZPrgA+GSaJLhIn6k8QfxS2SQQO0je2hL5MRn9lOmAL
	5uU81RvcEVh71inU4pBDS6FlmFBxBqX3Jjz07dg9vEZObVxC2eUbqk4ncsHYNSgmwzS5QQ
	vwnYqrWo3iGQ0xPyX+WdWbdH/K6PBOQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764886613; a=rsa-sha256;
	cv=none;
	b=jNI6xxVatA48OoxOlzSGiOQsdz8MrKWdd8ZxtJHx2xx+3vDpvNHSZs2xD6lPNpI1NzThSY
	wLYHSVGdbfPUxnQ6Vy6GS0EgZPGksbvtvDRtLENWv7H/8SyQN92vtLQrSrNS06mXcJVK60
	wHWVseTwVTSoNObpHrrocO1S3zPv9MU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KBuApwTD;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 52FBA42BA0;
	Thu,  4 Dec 2025 22:16:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D13FC4CEFB;
	Thu,  4 Dec 2025 22:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764886612;
	bh=GIuj8czK7JN8iz28EipslA6aGAVYQK/Gu9reaHBCPGc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KBuApwTDXxWWdiJtQf5qi+0VX47yor8Nk3F7562GYuC/SHmqcNeAWPL9H/c8XV8DC
	 UPqGDSIG+kiOWeBOB2NOnleo4M6fuA+1IUkD0gtnUP2MHOPxx+GRl3FHzajYTp/mdj
	 YhItdid8utmBaZBdehY95VBwYuAeXWDgyAXUqsNbvJfJVdOXTx+DdbZnmHRJ/yuemW
	 5E6TamsqebK90TLJQSk7/QyvhdNy8bmKE0UJOaQI1ovMRqWIv9iqKocBetKjbVcGlF
	 Y95h+kTKIqv9R3MRTVA4DXw+fZbKZYhZ20Diq0x07sT7jnzqNDzgkxxaVPxW3UeckK
	 /XNqUzLH3VJjw==
Message-ID: <51d8549e-b084-498e-84c0-76fd3de116cb@kernel.org>
Date: Thu, 4 Dec 2025 23:16:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "mm: fix MAX_FOLIO_ORDER on powerpc configs with
 hugetlb"
To: Shuah Khan <skhan@linuxfoundation.org>, akpm@linux-foundation.org
Cc: maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com,
 christophe.leroy@csgroup.eu, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, masahiroy@kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20251204023358.54107-1-skhan@linuxfoundation.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251204023358.54107-1-skhan@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 89C68180009
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: 5mmbdtw3r4myo1r8keqs5h7hscptwq9y
X-HE-Tag: 1764886613-337024
X-HE-Meta: U2FsdGVkX1+rNhs69Z49xMEOtzeNgdf5LPQsXdpfxmpxDdd/h0pqVZnWPp9mH8EUhdQTvbazOqeRgiFBpvmTnPU0fkPRb2fwAxc34SZ1TkfBpYgt3YTzPfWcU9M+prwHUDSXcoGgydbm/wkYDTd9/JkQ5ppXwkpor4nMaRdrCknxjUTmlBQtgFWhGO5d0ZeCSROyMWH6794/86GFxcMLrqEsk9x2QH/XUuyzikGMt8TRZMtZpSsmla3hLnjtikd1hfL5Fp3hKjL28olLst3+SeicJz96dYLmb/j94Q6ZS5t1SqSKJ1F07pvcTQajWvxZHq3m9im9gCroXgugKGl/q0oYCSNAPC41t5L5eu5sZs0n+4S1ewvq5wQVI7JMcJB7ei1J76t2AD/RFA9VFFwuCwdVUqSOz2gMJTjPnXvDrLPQDKPt299Rl0w8Nz2CE0YIyXlSu6VAc7sdmSA2YOx4cLHbWdkBZEErbi/ECBZJgVlmoFROfBmIc4UnrUpz+Uml/LnU+a6jq4iaVsrqGiManmXwEL8NJbCVKD//0X8tRa10Gv19OWEbQRh1Ws0XOrp13gMx9VDxwtmVfByn/oylm466MZOdqNPjWIled8BWU2hFIScYgZSU0ZDXhQePa+PjOURgihtuTMl+q6/ztdymJ3UVXHvJL2a671wqstFhpu3L48povx9Mepo35V0wjZNcRy0y+ns3C9fWfnQAV59yKjx9RxZ56DFKHDReIStTH0rtvGRTtQzdnry12ghEV/w/djyFOg2GhbNXzXjm5rLCnMYUHYUh95Ri2wMZJUJdCXo6YckbuIDiuY2qzDL2nEMtv/7tZytxwYKnvellXFi8xoXO/bbdf8KEQLBN7EhNhs5vhOzF3JzWHRzb04l4qlUh6SqtZfnyiIYU2YvZn6CBD6tKz69CrhaqwSQHRpIk1F8UN55FZl5+cqbv1pCSBpF9l3lgSSjsPQfAoHZRaQW
 EllQzQ42
 qCrKd2v0+QkM0Uy+Nbrq7sxPjd0wYx7MJFMlnbW/FSz9Z4C9ImD27KJe+l+YxgD9kd14e5+9vJadGBNSldPKUbzfXKEuot9hFb33mD7BzJdEEVXF+d0SnDKz0IPDJnZWSettAmP/pdCNJ4N8jYcikmi3xF6SZQdaMKDKpqcItYIcw38//Z0zG9vsEnvGVmSqFTizAQvi/rFKVsKPLtnlyoe3MMvPV6kFaQEnH8a/PM1U2rDnkU585hWijEpKQ02poFcVNRUTsV+1MMnhUfI0ve776pOo+a5qqYcIeL+yMs2UjA5UoT5LUl2ugjxC377clznjBw3KIp1ffAt82piP8SsNn058FJjPuUtUkEgIgJ3SJLhOIv2zEO16L/ZGoLzJWrskViGTDLp+Ww/33MRsBbu1hl4iheZHKcXMh0DjEuDIIa6hMcE8fBotSa4B68lTqLG6v
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/4/25 03:33, Shuah Khan wrote:
> This reverts commit 39231e8d6ba7f794b566fd91ebd88c0834a23b98.
> 
> Enabling HAVE_GIGANTIC_FOLIOS broke kernel build and git clone on two
> systems. git fetch-pack fails when cloning large repos and make hangs
> or errors out of Makefile.build with Error: 139. 

Looking at the last part, "Error 139" was confirmed to be fixed in 6.18, 
right? At least reading [1] there I find

"it was issue of 6.18.0-rc6 kernel itself. After switching to default 
Arch Linux kernel build went without problem and I'm now on 6.18 stable 
kernel."

Did you mange to report the make issue you reported here [2] on 6.18 as 
well, or only pre 6.18-rc7?


[1] https://gitlab.freedesktop.org/drm/amd/-/issues/4724
[2] 
https://lore.kernel.org/all/5af4522e-30ab-4eec-a861-c2760cdabd4f@linuxfoundation.org/T/#u

-- 
Cheers

David

