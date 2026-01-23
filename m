Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F9E6D7234A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 08:20:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 946C66B0436; Fri, 23 Jan 2026 03:20:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FF076B0438; Fri, 23 Jan 2026 03:20:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 829FD6B0439; Fri, 23 Jan 2026 03:20:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7094C6B0436
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 03:20:10 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3AB74D27D6
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:20:10 +0000 (UTC)
X-FDA: 84362530980.18.D36DAEF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 89FA5180007
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:20:08 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769156408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0deuW28KSaoWy7PTKK5okwioX4S3riFCZfOsngN3MNA=;
	b=v9yjI9rbnEU8Dq5UP/bUZzj1CjUzpxYKk794LHLoHyWEBNNnUwjt63b4g31SWJua4XsG12
	zNtp7+yRn1oGqSLVRVhL1WH1MOGz/yLkSHxR5sA5xzBOjFvPXkQcYIAheZGOVGjOn7xGZ8
	x/QzellKQ1ZtqZ1cfT9/RNVm1pTtJUU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769156408; a=rsa-sha256;
	cv=none;
	b=k3r+v0rC8eQoAbrgFLM+16VrDWFFpKDIUgzApI78d53EG45KJmTt4T9LcEBtvG0bEeCNft
	xIY3VKEaxVZg9neJLONkZbbLe8eUBfGrtANz+w7iyRUCA9o2K/0Kl7LWHe5ZdMm7X2X13A
	jMGhi8kYmwiRgpnfFLfEe3OE5+5sAeQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0834F1476;
	Fri, 23 Jan 2026 00:20:01 -0800 (PST)
Received: from [10.57.50.81] (unknown [10.57.50.81])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 85DAF3F740;
	Fri, 23 Jan 2026 00:20:05 -0800 (PST)
Message-ID: <2f84676e-e0c5-4355-9276-b275c75938ce@arm.com>
Date: Fri, 23 Jan 2026 09:20:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/9] selftests/mm: check that FORCE_READ() succeeded
To: Usama Anjum <usama.anjum@foss.arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Mark Brown
 <broonie@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Shuah Khan <shuah@kernel.org>
References: <20260122170224.4056513-1-kevin.brodsky@arm.com>
 <20260122170224.4056513-6-kevin.brodsky@arm.com>
 <ab021f50-60c9-4d5c-99a0-255ead6e2288@foss.arm.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <ab021f50-60c9-4d5c-99a0-255ead6e2288@foss.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 89FA5180007
X-Stat-Signature: 5qwjctgyn6qjhd1hy1h1usd6ebr11oi3
X-Rspam-User: 
X-HE-Tag: 1769156408-512600
X-HE-Meta: U2FsdGVkX19ld8VKvn5LB6iagLMR0Md6Q+NS1TbUzrA+IbgjGnbKYeSP9hhDvOVmiNotxwF+2jQJ/LYB028fid7GDNc+wsX+ceyvJxWffqugaQTEr0JE2tR/gDwdBscL5lL3B8v9hfh2zCs8lxitDNeI3jKHs8v1hBLgL7kmKmny2AHXYlAovxtxvHWcfP7GpQ1Mrhn0yWaCD0n4tOzeqDbevioFU29pAlqAnoQJB2R9spBK1dGstK+CxkmtygR1dY06Hc+1+qBAu4vngVeeDcZ8iu2KZQnkRdidp9HynMCtJ5hx7DfV8QlOZT2KoFvUyi0P0RhmzCb9jWCnNXufNuAs0y2tcRoMUoH57wiUxuQfSYo7NsAwUxcUwsfzzmMF3kzS2YCRO2xf+IHJp4gTTN/0sDruvY+ORUPEB+TQnAzr8AG3RS7BBmq7ccLNuRtHf5vJRHxvOe0nAaYU7XU+gu3FkjZfr1IVNm0nmeZ2yQ6RXJFfIcPAxg6PztLsLxAnY9BrX9d9/pVfyE8HfO75nE/w/uJUwE0ePV1+EZeWj0y+5s1uCaytyQ8PFiMWKH8hJ9oMxPAL0fxAccymwBkkItK1rODCu7QxK4xXVBghecEGhc1VZgwoTqic3udxJLtKu8qfL1RAA2O0V6bA67tb+HBBY/1sdQMsnxdJp6TeYVEjlzhV52f4Ch+/m0Q0wYk+RMd2hkV+iHaqoq0p9uN6Oc7ZKe5lhh2U3wB+s1nkRKrAC2nChx48sX05r+bCkcIPK4copSC77bn6FhyXQKwobX457jj/6pug7O7AmCOIoP0HdilWsvIshnN8kiSbGp4bjjNvDNhXEW/5LIE+bkv5KBPEpRZPbCqYwlkCAVQ0Dgna/rfDKHivfMThzNok/YhSv/VcbY78SfcaTJf62f4jBBU3wYJ1tJjrdUm/EztmRDXuSiE+oYmpwlmyul3yJv/bC6A9m8158UQrMRpQSgD
 CLfgUvAl
 Xf+i+MmGZapP8h57f7kQ3PblZM5mSDkMh531dY0tgLT6suKvEGrI/iYDRUNQOR0TctM3JYtFtR7cgzN9Di4YxB4feuSQCRY/ypNNZzIjl9ZXlEKlPM7lbbQimDX7K//WzzoJpMPm1wiXXBhtBhMWCevKsEnaomcsmYbLYPRhyOF2p3O2sEDQApXMCmmO543aSZUTJv8929KDhM2B6Uq7vuH4FSg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22/01/2026 18:36, Usama Anjum wrote:
>> +static bool populate_page_checked(char *addr)
>> +{
>> +    bool ret;
>> +
>> +    FORCE_READ(*addr);
>> +    ret = pagemap_is_populated(pagemap_fd, addr);
> Very useful. Maybe extending FORCE_READ can help the entire suite?

I considered it but one needs to have a pagemap fd around, so we'd have
to open it for every test that uses the helper. Maybe such check is not
so essential either (see David's reply).

- Kevin

