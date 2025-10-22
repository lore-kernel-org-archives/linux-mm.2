Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61843CCD1BE
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 06:20:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B51EC8E0013; Wed, 22 Oct 2025 02:20:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B29B68E0002; Wed, 22 Oct 2025 02:20:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A673A8E0013; Wed, 22 Oct 2025 02:20:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 98DEE8E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 02:20:38 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 26CC013BB66
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 06:20:38 +0000 (UTC)
X-FDA: 84024751356.03.5A63CC2
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1E19520004
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 06:20:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MUtAQiMY;
	spf=pass (imf03.hostedemail.com: domain of leon.hwang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=leon.hwang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761114036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xGUMpWlS5ys3I2gYM86ycziVMk+GyFsNzyypjhrbYGw=;
	b=GLOqs+x8FwGyw0rPq7IzXl8nvwPt+fncBdGrrHCPIOu+aFKdPDAm8ERItv5pkBAIBZAfSR
	cXJXIINYnimtZgLe9gjU+y2FThhfCgnlXaW88RRxY84ah6L9L0lPZWirwz0zzOdVfA6z6E
	IBezex8x05VroTkRi331ANHga/yhXLA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MUtAQiMY;
	spf=pass (imf03.hostedemail.com: domain of leon.hwang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=leon.hwang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761114036; a=rsa-sha256;
	cv=none;
	b=mcR4p7W7cVnr+630H3R10TYLDjGeTcglUE4LVUFdI+eNxUdbof6Bt4ijQivHBWc8y/mQYe
	OZ85IweqeHopTCBa+fgJxJ02wzNo0cnC4yeULHWH5wuGVfWrhXBoSueFC4Kiswm/fWkdVx
	qqZlqkGiCb+Sjqbtp9k+AfrP+JOo/eI=
Message-ID: <ab0c5257-bbb3-4202-bac8-3e74176fe34c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761114033;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xGUMpWlS5ys3I2gYM86ycziVMk+GyFsNzyypjhrbYGw=;
	b=MUtAQiMYKqmCmhCP9Q7CICf7/5jxigvDv1UgTtfRqFsQf91LkfNUkhPHzgdForHgB4CEQd
	vISRBTMd938WDVd5nMoItNdvfbbT2CJ5ZBsGQ9LD53KreOYKXKHlXXJCTEvVjox21Xp0xr
	VDjJ42plJloM8KBpUOONoledtci/moA=
Date: Wed, 22 Oct 2025 14:20:26 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 6.1.y] selftests/mm: Move default_huge_page_size to
 vm_util.c
Content-Language: en-US
To: Greg KH <gregkh@linuxfoundation.org>, Lance Yang <lance.yang@linux.dev>
Cc: stable@vger.kernel.org, akpm@linux-foundation.org, david@redhat.com,
 lorenzo.stoakes@oracle.com, shuah@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251022055138.375042-1-leon.hwang@linux.dev>
 <49bfd367-bb7e-4680-a859-d6ac500d1334@linux.dev>
 <2025102245-backstage-sprain-76fe@gregkh>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Leon Hwang <leon.hwang@linux.dev>
In-Reply-To: <2025102245-backstage-sprain-76fe@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 1E19520004
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 593yih68rwfmzruhxeqzhuomhac76hub
X-HE-Tag: 1761114035-712493
X-HE-Meta: U2FsdGVkX19fDNs93bcIPqgl4F65w21SuR8WTYFT685ZfoNZ71BgaEtnPTfM9wiRxNL5u3YLfeMeTgtluauYBspdV9wlAd1c3fGuszk7WRpz8hFiFFERtZN3qo4plAzTzaWWCPo/VC0kqWXzUruxM35A4KQKLgtG5ZrcS++InGz0ADpAc7C/e8RS8wER7YSlXneTHRauFJUI9to1qFxmAMKc54RR1iz0gE4i35OiHONCo4wdP/wPUkMPfxa/hSt4RM2kIBgFc9Wb5+v845PZEX1qoreGvg5KCKvjLuta+WoFKu+FR+XO9dKoHmuz3/vP/wRZ9is3gNQpw5621lDex8sqEUxBFeE3Vsy8gDpewaoVmDL0mGXk0Zmg80VHZOSe0rYZhTektkDR3XCvVzsOcIVGfKSqbsMUdxZwbJZAnCmb7+oU/2nYRFgawgg3ALripW6OVEnsUcwdss565UQfBgktb79GJRkEfHqmR5gzi5DX3XqPr8zA0YWZztMd5H7SXpUObipdKaSF7NrURMI44SixQI8iUOVaxU9ux/+J1MbN/rVsB9R4cFuVpzMisH9DhxvoGYfZY7bgAtldlGVQxEyTBXL3hIp8Znj09kEjG6grSghS1ws2r9mjD7GgE8E4Wi2xZkIHfLbLliiFYrU9HNhFw62PMGBdJNqtibhjt8XOhnPE0GhR+QM+oA5f7HRO0G7ttSTCWe1acK87KBi4CVta1sK8wQ+T5mOfDjHqX96SIPZ8JTxT9+Urbe38zdz15zzzH6aabjhMlUutj8S7/CX2pgajvm+kIFfXxqzCeoezZUgVZ5CHv2191nIn28lHHJCdWOK5dOhjch8Bw9L+/448kho1WzrM6X/Hk8w3jNzQs6MKLFGygGSgYrQ8MMkI4GEcpYsNOPvQ1E4mGIe55u6IqLi9aEi89JrcctR07EOMJwAk9opIp8KuZEX9lUenBDedXhpaL1Bi7Y8wcpi
 2TtIo6gD
 VO6VJDmN4hXIP3eFRsMcwQSyasSWmIf5RPhGwxtQkuXu0eEAZYSbJMY58Zlwk3OEJpD6A+KdQI2jc4PQOwiQt03Qq2+BrciXVzBenbWOguXeL18Oh5bY2yhA/z0elY3hAwkFaz/QfsGrxlcDZ8/pIiQUXHtjrU0tIqNI07kxF89XsZBzc44i7HTQ1tTDVwMFlQw4f8PS5aem27UF1btTB1PBwee3qaz9a5E+NT9m4VZ9kWinElYEqMBLQwMOaZx7oGHKC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 22/10/25 14:07, Greg KH wrote:
> On Wed, Oct 22, 2025 at 02:01:26PM +0800, Lance Yang wrote:
>> +Cc: Greg
> 
> I have no context here at all :(

Hi Greg,

This patch fixes a build error in the 6.1.y tree.

The mm selftests failed to build, likely because some patches were
missed during backporting. I believe it's better to fix it directly here.

Thanks,
Leon


