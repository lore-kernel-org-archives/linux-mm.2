Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A7E2CCD192
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 12:50:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC2938E002C; Wed, 15 Oct 2025 08:50:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D72D18E0020; Wed, 15 Oct 2025 08:50:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C88CA8E002C; Wed, 15 Oct 2025 08:50:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B4DC68E0020
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:50:02 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 48EB91DAF28
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:50:02 +0000 (UTC)
X-FDA: 84000331044.21.3211638
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9FE8C40010
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:49:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760532600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wr9LmkwBm6Pw1FXzVq5yWJsubb3N0b4U5iudPsh+6Po=;
	b=rNA9s6nvl3VOn3IdI8WZr0PZIF93pwt36quy8OSFFYRm63x9kiOPt8WnRlmfCElq2IrWpq
	Wu30T6jg44FJjkjv7kJwaCjWyDxSjF9cLyFPaQzhzcRMZ1/uBq8azuDicXx5++2ChUC5GJ
	Z7aKrqBeIAuaU8GqJ0FIq1V6jcWrqSw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760532600; a=rsa-sha256;
	cv=none;
	b=F6TU8++UibhKn8UEfsTDhC+ThNWbyxb3JAuiRTXKvFdndEqTmfUwoL3R29BG71lIBw7ulx
	YMNMCzNQ39+Ood+w8CPTCkBtRQI9r+s99j22JwJo8r31sftUPCRSwnM6Rx5pw/L0SlNEd6
	kwRgjmuEmlpd3GYP44R5460cJEKcqXQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 827F4106F;
	Wed, 15 Oct 2025 05:49:49 -0700 (PDT)
Received: from [10.163.67.182] (unknown [10.163.67.182])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 68F7F3F6A8;
	Wed, 15 Oct 2025 05:49:55 -0700 (PDT)
Message-ID: <9c879ef7-b089-4d96-a016-f7a4a550cf9d@arm.com>
Date: Wed, 15 Oct 2025 18:19:51 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] tools/mm: use <stdbool.h> in page_owner_sort.c
To: Ye Liu <ye.liu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251015093851.109663-1-ye.liu@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20251015093851.109663-1-ye.liu@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9FE8C40010
X-Rspamd-Server: rspam03
X-Stat-Signature: 7faj8zyy18om7fprnrwhbrhp5mrr5wt8
X-HE-Tag: 1760532598-473322
X-HE-Meta: U2FsdGVkX1/7yojpAIEXKdUwdoB2pvoXgSxAcRFPZ+267Cz2FVdH7GSJr6wL4SiJ/+l5xTE1X8wE/cQEQrb2duX7KI8AzLbI6/ew8YKjUbh1qigB2aVhK5RiH5Sev4cvvDmp1g9z/OVaTqrnIuwzoRGQUG2Kplu2zpb1m3hwsFg2VyDSy33F1InftbfZ/tdvMHD8jKPAa3HDjnRnlmnAfKhPXd+jaZZ636AQN8AJrykjCPY3eJGA6/2TAlzn1q377ABbRhGpBBrVN8MGdjv/+uwUMWT1hRfnoYkuHohRMp6DQ8l9dPXyTh9RwmHhmTO09AR7AM1yH+7QGzf1iZ/fd1XHoRUbQFW7bfgQpMk/vcIYuATU5HaXCqkC29+AT1vIMB2xEOyVHay4mJ8iBLD14ONF57D9lllKfjAILMkT02VY+JO/Aa3s/F7Z+8w8DAfB77TaC1t0pO2ISR8HB+ETRbwKxB4FWJ7JUyAGem0DJef/XpsGY8ICbSsZ8xoydMTlrieISRg+dTUqV7nEguQFOYlKbU2KYQBZs2nySbFmEQGro5Qeiq/kNfoTIeSDnypmGJyuBEuBip6X9JvYseeKZoXMZHmxdhrDTTc/MGEW5KdiZl6JSulKTdK8Z30hXIOQVICy7m7xg3Fmu2N2xhG0jLq08pw+SvxwF8eJv8WUkXfOa3V/8Cklfi8QIkykUX1M+L4Eai1A/GbBAFDRnwl6hIprBfM5WYB1pVyVK/s/jguiElhXLFNOBY7pEZS6ot7S536EKs2K5tZRY5L1nq2nvylTcGChMzExMhh/ydW5jmA5XJfMHxAysITKWUsKh0XnBzLWfSa1SS80DJRJUDm3CNZ4gjj131ADh5xgnxIYI2h9bl3hC7zORoKwIJVL0erYEJ0unNItIIpmiQcOIjGkh5iR3Uvjye4qtlqTMcnMcbM5lScovgI/ePElEDuKB3ROEoGYy5DtUl6I+lO5QYV
 hK2d3TqO
 vSAp3rAofNmJI/A0eIFTLHg+K4OvNEmZ1q009WEb6hn8oxsSMRvXqBgnUDLkssFGhUxjcZQ3DSbjGrv+Ch9vEVYHqGRxxlT2VbOVXVe576ugALpa5aXi5I83dhYaqz1S0hQcfyRQq5iIfTLr62Q1NpFXX5/EiABhZowfr2fg5FXOpEg11wuFzVSx3OZUr3fUrPjF6/k8sZqYBEY2Sosw9aFI/o2uG4uhOK3fByvaG7a1sASOPbRSy7w3JgLaZ2q9h9FSvabEeMPSUc4uw7ygj9g26EojbyzbcRdja++0Co5mP0Tvva7FV4Coo5A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 15/10/25 3:08 pm, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
>
> Use standard <stdbool.h> instead of manually defining bool, true and false.
>
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> ---
>   

Reviewed-by: Dev Jain <dev.jain@arm.com>


