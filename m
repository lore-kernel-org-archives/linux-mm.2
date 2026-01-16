Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB4E2D47CD6
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 10:53:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 102676B0096; Fri, 16 Jan 2026 05:53:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0ACF56B0098; Fri, 16 Jan 2026 05:53:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF1B56B0099; Fri, 16 Jan 2026 05:53:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DF2DA6B0096
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 05:53:17 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9892A13B473
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:53:17 +0000 (UTC)
X-FDA: 84337515234.13.12B0344
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id E13F11C0004
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:53:15 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lQuoL5YJ;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768560795; a=rsa-sha256;
	cv=none;
	b=WUvDpwafjPP0XW/hJ0nT/1ayFVX7AaU12Ojk4E8t7/6KR0QBDyG1eW442T6DVuLL5Yi8eB
	i6jQiOay4ldjrHYuPXnCU9UltBdOMAlOrn6OLawQA7fL7N6O3bl/WbsNNf23KdeWQPP7hR
	uaRrKWiMMehFXoYYuEKzINr5iqAHbA0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lQuoL5YJ;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768560795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NV8TNyLA+vq93sYgYKnZwfWInb+dSVR8Fu1Wmm+jauI=;
	b=ZtinbAr3gMYy3w9ZgyUkEaUhEX6ILFIdM3L0qBaZ2VyVuUNTlBpuH0KUaO5eWXBhts32nE
	Mpwu/uwBzOiqI5DNeYSBg2+Vre4Jfz1PaP3T6ekbkqLUENlSWVJQDUDjK25MDY3VpmzJrm
	dqEUEjg9UIexHKe0HOFLEI5rNscD7kA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4AA0060193;
	Fri, 16 Jan 2026 10:53:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27808C116C6;
	Fri, 16 Jan 2026 10:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768560795;
	bh=qKTpq9+uhZ4goFZnkWfLWoqBjLmId86KT3EVnvQfuJY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lQuoL5YJUc0pvxiwtJNb4htDCSxgTlvl8/COVqMdeZkaEeFGfW19yYmnWcXIXATfz
	 vLBYa7SEUZWArovHHNYs+1D83E8qc1GAw/fatLTVbT4ZOiNqyG0Uzq9OdziIAebXGV
	 p3AHG8+3wCFhrjrCCI2K3XE0IrFitbnOzWGVO6d3PM8zEeFBEjMQLbdNYvq5F+Ovcs
	 dpPiZ7fR2E0rBngfecB5+8MdNxOe+4xSSYBwt+OEXwbYVtDLADRoE5FfBxhpRX7+qv
	 O5z0+mpE28u/Oy+498yyyZtDHkDuvlEhxsQxf8WAnKZuA4qKofwzEpLxc4CSEU2O6y
	 rQTn77Yr8Cdng==
Message-ID: <53899b11-f214-4c51-a430-e5da2bf36401@kernel.org>
Date: Fri, 16 Jan 2026 11:53:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/5] support batch checking of references and unmapping
 for large folios
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, will@kernel.org,
 ryan.roberts@arm.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, willy@infradead.org,
 baohua@kernel.org, dev.jain@arm.com, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1766631066.git.baolin.wang@linux.alibaba.com>
 <c285f2fb-b64d-4932-b9ae-ef420097728e@lucifer.local>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <c285f2fb-b64d-4932-b9ae-ef420097728e@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E13F11C0004
X-Stat-Signature: r5u81dci4ejcyeuy9kznfacezib6jex7
X-Rspam-User: 
X-HE-Tag: 1768560795-463727
X-HE-Meta: U2FsdGVkX1/b6vqkxIp/kysrquO6KdsqOFY+IfSZI4RzQKcYObt19GRb6ljCtNrq4JXE2Oz8VIxUsaQeHC1lq3bbNgWd6EvdzMbt+oVjmJVFkczI3Rch4BBgOWrgjoAp50S7qs5pDkjob+k4uIBAW3o2Xs+j43As3v8Qk60rLUNn+NsSh3VEK2/Sh9iu2j9uDlmMivuiau1J623xYZAFsWj/Uenv6NkHpoZqHR4rMNMKbzU0apHxGL6y0au/QcBJneESwB+TCBkGBQiG74agX1BjUF8kh1QQ1iWQiizBKF4JJklYeKeyFTLUuaGXsCOJ8Lfu8G/EQlN9JoGDuiDbldHWIDAqdXXqd/QZnPG7tvnPJctoxvGxTPlpKKhVkDPdhce+dgiijXj9AK/goAjOqzv2Iuqg2VKaYVTyUpz3ZRJNwSmW39Dq6Qe9AP4gxV4zwXf2qO8rtX+ABsAu0vmm+vKVTcY//P2Www4j3jk/FwCc6io1DuJdijmbNkCTLEuP5vF+LEleOLq8XLbuQBTIV+aHduobgtQZPLbnXSPwlJUaj7PnRzpyouGCkJPrkejIgj//BMztXgar1PmpCAr7HeAD6FnMNKKIVdMpR4f+p/Ojn/fHPiyVoLeNwaVgapq2g3/iJstO/dmDwgoKpbJ4h5Symy+MYUBK7csd6r6zq2trDLaqKjwcYg33Ps8Nyd5jwu7Lv3WWypO3vNiW6lxR9/XBj2EqJ19Cb4Yrc/5rBOU0vkCIJ/JCgI16Ewp+RHBc/lZ/C7CJK8LpqSYZX1kwyhFtmtAe9E8COwKfBqviAM31wV18Y6W2uLmT5ighjx2EBtqjNQ3l1Fj9kvPueV+7D76FTagryFMYtAVhK8MN4wltCgFM9q0jmw4zQmD4aYxbzsNKtvmuX9Fl9t5kZoygYdDXnQceNQ4lAYDNyuHmBxvG2b0c1veePsSbqu2JR/5vO3lsfMoIQHFoTJWtj3A
 HKYlLS9m
 n+MvK6gLah3CM29k2b1FZ5TBlZy0p7g5Wu50f0d6T0GXbdGSkeZ1iaNPoPSK0hetEJu8iQtPt56SnsvXpHAtWlyd4ODayBm0auBMmWEOLQLwx1L7QMHyUh2LDcoNlhVw2+Alj8gl2CAit9haEgw97+LDr5fcpCgL8HHHrRsAzipr9zDd79g2GorAzcekH8ThwlZGTpXEJo2SnzYz7lluv3C4XOl/YSyUUW3pGHsQjEL/NS1mbuB1KhIMdqTRqoXZwuSVm3DzcWJGefC2aWp1YWLUgaKDPz+WQS+Jf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/16/26 09:41, Lorenzo Stoakes wrote:
> Andrew -
> 
> I know this has had a lot of attention, but can we hold off on sending this
> upstream until either David or I have had a chance to review it?

Ah, I didn't read your mail before I sent mine. +1 ;)

-- 
Cheers

David

