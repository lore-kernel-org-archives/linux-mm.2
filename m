Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BEEDCD6E7D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 13:22:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62C156B0088; Fri,  5 Jun 2026 09:22:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DCC86B008A; Fri,  5 Jun 2026 09:22:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F2596B008C; Fri,  5 Jun 2026 09:22:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3FA986B0088
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 09:22:42 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CCBCA40C06
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:22:41 +0000 (UTC)
X-FDA: 84845923722.22.74E81AA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id AED781A0004
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:22:39 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=HM8AmyCN;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780665760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a5JjsTOFCdnpxaI/KZEx2ESep2vLFlgFZHHJpz8hKT0=;
	b=FkPxMvwotF8Y89Dfg9xlelYJV65tGSWw9TQntdOXF3pB6s2mh1ejFSAXOnmn7Kiccc8yRg
	UBgnMPdNrZft/vRe0M5SIboQU9pSZ4E1X9xmidQ2HxXZFufxRQSYkBy87Bho3yBvLd9khC
	pTQwz/LqIwmtv9OwBNnWGdHb9A8NOcU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=HM8AmyCN;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780665760;
	b=hEtHGY6Li/wgSZp+EsBSCzJMu8pN/aVPIH0S9Qo62jFKT0FFObrHRkx3UH0LZfXvHWBM+2
	OOASc7zIeh6s9PGXz0ROH2Q7HfSenSoQ01wh88xEJUnLNUAaJ56ae3Jo/rj7Gc36K9Cd9K
	zNv2FArzxWTKXuyUcQNr7dKZ365mEeE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 725A01692;
	Fri,  5 Jun 2026 06:22:33 -0700 (PDT)
Received: from [10.164.19.28] (unknown [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 092E03F86F;
	Fri,  5 Jun 2026 06:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780665758; bh=93JSLib9L9YiVs9K8N6Zs08gpwZhbg2eluTU83xyxXA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HM8AmyCNFPg827MEDzq0tEw8siYTLhPiN9l/6cXevgM9xReo/OAf7Wu3qdQaVI8Ev
	 2vVMiN0P1m9u5OBifDp6lSjvmW7W03eGGpGGYWSPRAENPAYOstUmgdTTgjJ6eLEBjE
	 ubwPMkLkGmyBzJlTVNbzSDFUOsRREOXyGwlm7MrQ=
Message-ID: <cb349974-010b-48a6-bb37-f7b8985eedbd@arm.com>
Date: Fri, 5 Jun 2026 18:52:30 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-hotfixes] mm/huge_memory: use correct flags for device
 private PMD entry
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, SeongJae Park <sj@kernel.org>,
 Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260601083044.57132-1-ljs@kernel.org>
 <73762983-d48d-486f-ad5f-78015e6f95ee@arm.com> <aiKficIP-akvSQAf@lucifer>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <aiKficIP-akvSQAf@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: a4gmg3oojycmhtbm8a5hmttcoxiq9fqa
X-Rspamd-Queue-Id: AED781A0004
X-HE-Tag: 1780665759-919804
X-HE-Meta: U2FsdGVkX1+i4MxvGX+wFcDRg7sXNxhKTyHGkgkgOnvE3jeIhvWe2TAPReC8fpPC3vcCu3JilnhXJwM1X77N8MPKy2exHhWcf/xUcvcRnRV24Orn/VctYP4eGgRzAUWUqoVpYE0IZLyBHxqSL3HTpTU3RlcPT5jjDHE/j3wpNyLBL2M6CjWYvjZKeJ+3dRrXKclyCwBdKUWvNlabJW/XiiVCsDorZw0bC8WjJ7MQFt9TnCEYIMxl/7x92Cmj9SLYdn3P0kPlHF20L4skRP1tBPFuwOytBLPIevRUIXlWQVoRdcMR60htqiZb+OCojfBVEUbYBGT7fz40tHJRn4Jb682sguEDsdBILue6BX3FKVM8Fsy7m53xi3V/dawjdsJI+pbZpC9kV6Ao+S+kae50UU6WPnZIhfRGchkVQBhlV4sm75aLTUu36HZxpyZpy0Wqqze4ZaJu44OA4GK2EC3R/Yg1CMmWBcRSMImO/J/mzDjnJEN1qMqtMlAuSssJubm38gtSMT9OpiZB0A/aL3mk9/t4n+DDGJA2Ji5ehrVEf/XY+BUisKjurB0m+d4vX0/y5Bor+hOfbVhdX+LT0dHi6ENzXgNTbPWpcqPTnUmgn3Ty1ey3ojfFVu5evyBcMYyHViVmAEnjLuasVwvHFvCbYPrPvCFzUPd3bZ1MU9X4oSoqoVJYRO6Qwxf5/2apAdOWmq2CT5m1ftGjnjoVpSzYFCzBsiFBZOxQuUVgeL9oTEjKeFkVRZE7XWSQexXf26Bk8vq7SqkgCii8E1nlMFNXms12FcuaSkNM8+17Uz0+9AQHbXA8hN18xZWETofSAnVI/rrxLWOebseiil0cOJFme87ZMZmznOdHivUNnnJRjnFfvSkelAIj34hMYPDSw4FvMs46pf8+ert1kbWvc77bd6VKzKwdIztdKcjQj5NPXDFYI+imx6z9gY1TjT4xm+bT7zPJAKla6kDgZy5ya3p
 8i61xl7N
 XXZ8ACvBrnz/yeJtuH65AmTF8IDJmu6zI6RAx0A48F5QFV1WeQ3uPTtylOfLB4P5CdMnA3NqoJVwaXrR15ERZuseOVYRUqDXlPzmZzSM/5W5theYrcnhYN3SKAVZJEa6yNldj8rgAV1WfTaw6Wo84ahtgdfdmL1AuTZMIf1QWrjutB5eyGSd0n3T1m4ssGJqmiUGcTVP5mUx6ApYVZnoY/D/KDzdYyV6LuJLl7vQ12LY/52+6xvg/MCsuGkWL5M/FhinO04LElWk5OcBsy0pbUiZ19yDog3Q2qChnX6uh+sYsJPOerdA52xEJkq0QFb9KKumTq5lg7VzgX+CNqqF4HqNU7Bt7KdvFkxM060I5nBwf5S0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 05/06/26 3:37 pm, Lorenzo Stoakes wrote:
> By the way,
> 
> I think maybe the reason you didn't hit this in your work on the spurious
> warning stuff for hmm-tests is that I also had to set CONFIG_DEVICE_PRIVATE
> (as well as CONFIG_TEST_HMM) to get this to trigger.
> 
> I think the reason others maybe didn't see it is because the self tests
> will just skip the hmm tests if CONFIG_TEST_HMM is not set.

I have all of that set, still can't hit this.

Instead, I hit something else when I was doing some other work -
https://lore.kernel.org/all/3a25e7fd-84a7-49a6-92a3-96492fe5d2cc@arm.com/


> 
> Cheers, Lorenzo


