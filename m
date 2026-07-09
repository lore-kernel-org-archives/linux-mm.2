Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 104E9C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 00:37:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D22446B0088; Wed,  8 Jul 2026 20:37:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD3136B008A; Wed,  8 Jul 2026 20:37:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9A736B008C; Wed,  8 Jul 2026 20:37:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 90D6E6B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 20:37:41 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1AA281C81FF
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 00:37:41 +0000 (UTC)
X-FDA: 84967375122.17.30F86B7
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf12.hostedemail.com (Postfix) with ESMTP id 766F740004
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 00:37:39 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=sUET2RvG;
	spf=pass (imf12.hostedemail.com: domain of shyamsaini@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=shyamsaini@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783557459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JrOx+/apw76P7y8j1/mgdZ4vaD1KHTVdG+YsGK+HOmA=;
	b=FnAPU3uVZv9q1nc/JMSlKPORrzJljNn4yl6hIrvjjiWkk/bL0/AWs4wkDBM+I51q/1m50x
	G3RGfPencum7w+TjOfL1HZ43vpJaRpgHm77Ws44MyI6zOxEr7xFkkAry9hLWM6n8W55K/l
	s5d/bqTVZq44sgwzVxIyY8uqPcawYIc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=sUET2RvG;
	spf=pass (imf12.hostedemail.com: domain of shyamsaini@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=shyamsaini@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783557459;
	b=hAOapMtgLLzIPkP+jltWGU0d622RLUjAIL6YLLiEo95qb2GZGSSFVcNnJgYCRhN/KYIg43
	9tWoYu/aYJfMPspvW4lDmU2IPdVwj2ZEeL/8VDDYSWzqh3qEa11lQsCWE5Iq2J+XO0eSi1
	aORSOwOvl6y3kvNuH9n5dKpqRR3+xqA=
Received: by linux.microsoft.com (Postfix, from userid 1152)
	id 1D69320B716B; Wed,  8 Jul 2026 17:37:33 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 1D69320B716B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1783557453;
	bh=JrOx+/apw76P7y8j1/mgdZ4vaD1KHTVdG+YsGK+HOmA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sUET2RvGdkncNw69to87iw7S3f/NPkqwYmu6fiqYF5YEXLN//hZreIZ84xWdlX6Rc
	 vJ5eJ99cti9MekYuKW5lwMpnHKhL2V1Pq53AFnQo6/zwZu1PQaW0+hpaPMSEvB8a+0
	 rkFCuZzaFnQZwShNW3NfCM1d6kABiFMwvl8F19/Q=
Date: Wed, 8 Jul 2026 17:37:33 -0700
From: Shyam Saini <shyamsaini@linux.microsoft.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mike Rapoport <rppt@kernel.org>, ardb@kernel.org, david@kernel.org,
	will@kernel.org, linux-arm-kernel@lists.infradead.org,
	akpm@linux-foundation.org, bboscaccy@linux.microsoft.com,
	bp@alien8.de, dapeng1.mi@linux.intel.com, ebiggers@kernel.org,
	elver@google.com, enelsonmoore@gmail.com,
	feng.tang@linux.alibaba.com, gpiccoli@igalia.com, kees@kernel.org,
	kuba@kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	lirongqing@baidu.com, peterz@infradead.org, rdunlap@infradead.org,
	tgopinath@linux.microsoft.com, tony.luck@intel.com,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Hanjun Guo <guohanjun@huawei.com>,
	Sudeep Holla <sudeep.holla@kernel.org>
Subject: Re: [RFC v2 PATCH] reserve_mem: add support for static memory
Message-ID: <ak7tTVs6tWZPOln0@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20260630170911.43521-1-shyamsaini@linux.microsoft.com>
 <ak4fu1qINGyAQUEl@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak4fu1qINGyAQUEl@arm.com>
X-Stat-Signature: g85f3jhk86bo81i34w1rutm6auus9tge
X-Rspamd-Queue-Id: 766F740004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783557459-738589
X-HE-Meta: U2FsdGVkX18FcTes90wPAHgEa/26/osjXpZOYyy1TJ8cvsw5gZDHsqFqelT2LDMCR75DTNG0W9NwYP8P9qt1HcfoOSCGoN1su3x4AgXS5na1JsafLMlrSK+dH13q/ZpBxZ5SEv+qJjsMTzLoKlVlyndPX083E2XZuxQbWPMMB0Im3gB1PBHHUAH+gVV5G40A+ly8hpHrptcNYWlbYV2rH4+1q+vcEAuR0c/cLEv7RBtt9k8SbOe2DBh7MuPN03Lywztq6zTNY6wJ4OdQyd3waAxOe/7UKuk6eYLArZPQJpGqTEheUokDFJyvjfR9a2gF4vF4gVRd1i+9nT0wBbS7V9gVMaBDqcSU03ZsHDTw15vbkahYGTUdEgN2xVDNybpZRwRRnAYroP2Qf4p8eHzjbvknpVClpJXhT2YCH2ZO+nIYesQlRCP5E8peFQ8zWm1lWwk1Z4fMdnsYzpme3nsychicFMHPUXUgiFgEfyeEZQ6tc5/IsMlwRaz5KSyXrePXC4OxKRdX3xXx1ZwUlh/t/7A8VQmEDmqBMxhs2BgWF8dfcoqN9q+U/6ZGfHhRRiwklzT9XDcCBB6wlXZ3S63XeRYhNF5goTUEuskTx8hL88AIUrcqVzhTXeectguhMQP1zt2Ud2jReLnpXWZ6ZbVK/1t1COF1BRe6gd9j0St/wP6D9rLnON7TfFGdhkQ49bNL+hAg6HJttDWz7P+9hQFdKw3pOJJ5hYkM0lpaXTE4HYMNn/lQwQ7fD0XowasTXw54jKQGIVoOpKneKoJQ+4rumc7s8t96hBqF5NjzwtKpqtIKrCKA/jHLd/zW9Lpo8tR9RsQzin5Ms4usPNzz9//ViGqz/4CW6jNOoPRIc1bNxDRUHn6QtgErfQszHmMUZReuJRY3kVaHv8KZstkoYZpHykEF+wPPDQBsqkc9mduQfVtMalirn9t0K5ou4VIQjNXgJlt7zDUo9HKbpjMQKoa
 IT8UK8+e
 AqIhkc0xrxJnAYpbXNSj9JPf7b+znDXlH0T9PT+TqAPOHnpD9EGKN8VN6CVVA3tTUR3AXLtgK1WDJpXhJxiPNAwMv39hTNUuebMZz+QJqM6XsCVVY5CVfp8JRPvjf2+rvypFlOAOOkL6pP7yXSCOH46v5pixK1mMLw6Z62EVj3SRajG7yUIm92X3MjXLF+0q34NEop5SdHlf1Dj+x7fumPR2t5UfyDCh6HJEDDGOk/0s4AtxFXNE8XnINExq+MyDDcvZNUalxzuOLP2stGqCfv2SUj1JQzFRa7GuvQR8dLM5X5n0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Catalin,

On 08 Jul 2026 11:00, Catalin Marinas wrote:
> Hi Shyam,
> 
> Adding Lorenzo, Hanjun, Sudeep.
> 
> On Tue, Jun 30, 2026 at 10:09:11AM -0700, Shyam Saini wrote:
> > Following up on this, As Mike pointed that reserve_mem is best effort
> > reservation mechanism, so what is the recommended reliable Linux
> > mechanism, if any, to reserve a predetermined memory range during
> > early boot on ARM64/ACPI platforms for warm boot scenarios? KHO is
> > one option, but I'm specifically looking for a solution that preserves
> > the region across warm reboots.
> 
> If you need ramoops-like support, I think ACPI ERST is a better fit and
> we don't need any memory reservation tricks. I'll let the arm ACPI
> maintainers comment further.
> 

while this patch mentions use case of ramoops, there are other uses cases that
requires predetermined memory reservation at boot time, one of them is PMEM.
Like Mike pointed out in this [1] thread, we don't seem to have an
equivalent mechanism for reserving predetermined memory on ARM/ACPI
platforms, as is available on ARM/DTS based platforms.

Thanks,
Shyam

[1] https://lore.kernel.org/lkml/ak3v6dt_VIZTynT8@kernel.org/


