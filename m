Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8024CCCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 09:53:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 801BB8E000E; Tue,  7 Oct 2025 05:53:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B2228E0005; Tue,  7 Oct 2025 05:53:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C7DF8E000E; Tue,  7 Oct 2025 05:53:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5B28B8E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 05:53:33 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CEAE9C0875
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 09:53:32 +0000 (UTC)
X-FDA: 83970855864.04.2DA08E1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id A21F714000F
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 09:53:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759830811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aekVDrW2ABCQsRy///0oTao9FYiAJwzSPu/SM6UiY34=;
	b=DuuD40ru4SJrBxIETnKlOyPp8349qvfE0ux+S84VBIbC0We6Rt/Q67z334gAhH+vEMoxXY
	7hFCUR8xIaYVXNBbwMelQA9bC/CLHHaaI8OYqllTMe4Gcd3UQy2oorGPRPkWE2c6JOaztT
	ruogt7KLpzaat94IsPOmb8AnldpygsY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759830811; a=rsa-sha256;
	cv=none;
	b=0QZgOPZfy5LwW3cBsbPUXnrRfOZJb/xFulVX4BTkkwEAP0uDfcF2fyEfZ20oYqAoDPqoEy
	PAY7CvbeU16EcdIF9HATjJLRu8TvsEDg4ikfol+XbOsUZpoQlcn3IRZweyDswvFymX7Br+
	iQkMi3ySrtKWyJe7M+fYybrZqzD1LKY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 83CD91424;
	Tue,  7 Oct 2025 02:53:21 -0700 (PDT)
Received: from [10.163.65.24] (unknown [10.163.65.24])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4E2A03F59E;
	Tue,  7 Oct 2025 02:53:26 -0700 (PDT)
Message-ID: <c26dbbf7-8475-4424-8e73-b35a845a2949@arm.com>
Date: Tue, 7 Oct 2025 15:23:23 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Replace READ_ONCE() with standard page table
 accessors
To: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
References: <20251007063100.2396936-1-anshuman.khandual@arm.com>
 <584fea72-e564-4cf6-9435-ce4b03f2fd65@arm.com>
 <627da4d5-5c6b-4bf4-9544-9021062d378e@arm.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <627da4d5-5c6b-4bf4-9544-9021062d378e@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A21F714000F
X-Rspamd-Server: rspam03
X-Stat-Signature: 8j4mzrgky1tr99f5nau7tqo7ckdsq3ti
X-HE-Tag: 1759830810-281792
X-HE-Meta: U2FsdGVkX1+HhQiW77B9HSYr6mEdRWYgu9bR67Kq2BiYQuU/jqa651gJMqeOvOgVkDFfzlEqy+xVNAERP1NgOCmZtNw97B6osI9MjoBI5GssnkHPkaWwm8Olvf8QqeV21yYY8ampZugZTeXMN9hlh4ccDJVStPe+apoRsxksxhuGyE0mK8uvb1ImPfsr7IYUOUg/EH0Y+Bct0qgmX2Jg2gyBvAvXsxM1McDhZCatSS4eYjf1A1lY1x7AF3F5al0fNcGkXHmmL0fylqo8XotMnZmRKYo7GiZ0ZAG+HSL+5zsz/A7VrOv63OaGXLZePZj39mZeiDYu8RtP0vd2ef4b/H9E3ScAowTMhBoVX4XNtW6avnQYJe4FB+tKDJVsxzshDuW+csjfWmgJR+cGFfE4lIHWT0fY7W12hNzCxuZKvDzoe10Phzwm0X+fpFOBgKCDDyRtTFzaH5MbfkoQYj8Z3sD8ioL/tU+mKmkvD3bAsOV/BEdTRH8kFj6kxbyUwDF3TrHi8TCBDvdR8mxlvGY38K6nloFVfbJAxr731sRphpYZkLH8W+iS3gbz40PY7e4GxA+/961Lsap8VIFoaMhrZ5702NC9bux6PNPfBHqSItEaYDerRVXgEu/QF7+Ln6F6F5OTpULA4z3P13qYljEIKrKgxitXDxNqq07zOhxYbGkU5rqAv4WRDirfqN93M5cXkzJpmwkanpqteEX49/z2m0ekxT0pYZM+r3pTKdQdI1Cl7afaJ6RymTgDH9pGI3G75whCETQ2t20bKOsSsn+FbLNzLRXICRQ3+AdS4IQWW7AzQcowyHqxfRDIxnRTa5RT1nF4DgTF8uMY15+v2WBCfdCjSsixRfuLMzbouyFEIKTwGZ5fcDQiAKrGSjbBaOMrDMzTsph1dPw/VUjKB06TLGGDiUO6eFhF5WEA98UxFOHl0JDJzL1yHJSo8SvMGXaqqtJDGXPeN0vDvrkpvF2
 iCJ6gTMX
 xkks2XarmTnwLnwfSryGJWMg0OEZ9LlAQmudf4m/xv+AvT/b8huEHlCu6z2Hd/CEIG3It+EXk0J3lgBptL9JrRsHegaSbqyXyms/LGce1rJSetDklhMEJfnSz3klebhSXqyEBiSDMl8nhKzSoxUr1Pmz3Ud9Shwf2zIuUCDqfhnjd2xe5ruyzkdtDUPnf+JmJuqCdi0Hekkt9/q04PWfFJxiPRRH9JaWrcGqHYqlRzO6BfFhmmapOJT7NwQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 07/10/25 1:24 pm, Anshuman Khandual wrote:
>
> On 07/10/25 12:41 PM, Dev Jain wrote:
>> On 07/10/25 12:01 pm, Anshuman Khandual wrote:
>>> Replace all READ_ONCE() with a standard page table accessors i.e pxdp_get()
>>> that defaults into READ_ONCE() in cases where platform does not override.
>> Does any platform override into something else currently? The way you write
>> the description implies that.
> That's how the callbacks have been designed to be overridden when required.

What I mean is, if currently some arch is overriding into something else,
this patch will be a functional change. So it is beneficial to say
in the description that the patch is a safeguard for when the platform
chooses to override, and no functional change is intended.

Reviewed-by: Dev Jain <dev.jain@arm.com>

>>

