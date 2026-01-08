Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B56AD1D48C
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 20:13:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0D0B6B0088; Thu,  8 Jan 2026 15:13:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BACE6B0089; Thu,  8 Jan 2026 15:13:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E47B6B0092; Thu,  8 Jan 2026 15:13:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7D40F6B0088
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 15:13:25 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0B684B771A
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 20:13:25 +0000 (UTC)
X-FDA: 84309896370.29.6A8CD7B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 02E7D2000D
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 20:13:22 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767903203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f8byXjPG47zjjRA4gisVK79Su6Rh5yAb1mMc6R/e1dg=;
	b=MPGWIH7v+moQqMjluSZtdnwgc3HzxSAzvX6hGafFQ+C1fOORHyWk8K0GgCW8AViuG7oeqK
	/nSC/6u3hETr7RrqYXayYRd1IRfbG9BLrSSZmy4CMPAtNMds/FdHxiXSEX9H96qxHlwupb
	N/oVvBA0lrZ/iOPJ6QflykKy9D4vV2s=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767903203; a=rsa-sha256;
	cv=none;
	b=sMZeMKRMwOzKqr92160Ernc1g6WMjuoxp3tc6wzXCny247t0AhW2O2avrVLL5S+5huT6Pz
	2ydmkzxcMzbDLnE+CyTFPqgwQNgPa2MM0XGLLamYTKQVn0vKhI80HedlEXbOs/dInmHyLj
	u4muc9HyQ6SIrii1k/gyutga1Hkw+KA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EB1A8497;
	Thu,  8 Jan 2026 12:13:14 -0800 (PST)
Received: from arm.com (arrakis.cambridge.arm.com [10.1.197.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DA72A3F5A1;
	Thu,  8 Jan 2026 12:13:15 -0800 (PST)
Date: Thu, 8 Jan 2026 20:13:11 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: kasan-dev@googlegroups.com, andreyknvl@gmail.com,
	Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: dvyukov@google.com, vincenzo.frascino@arm.com, ryabinin.a.a@gmail.com,
	glider@google.com, linux-mm@kvack.org,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Will Deacon <will@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Yang Shi <yang@os.amperecomputing.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Huang Shijie <shijie@os.amperecomputing.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Subject: Re: [PATCH v1] kasan,mm: fix incomplete tag reset in
 change_memory_common()
Message-ID: <176790294571.2289790.2180517635826904022.b4-ty@arm.com>
References: <20260104123532.272627-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260104123532.272627-1-jiayuan.chen@linux.dev>
X-Rspamd-Queue-Id: 02E7D2000D
X-Stat-Signature: fqknej1wtru18ppkpyjjhkz8argkurjd
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1767903202-79747
X-HE-Meta: U2FsdGVkX194Ste7QRdlJJjJFqPzHoOzXo0duHyf+e1unVeCP0NMYpmQvgW1WBcMQM+iLK2/2gm51Rt7oUBy5Ke2k8GJq22WhlhBKRLPLmcGpdVCgoi0ZWTmyV+ZWJW6YH/KG6YbboqQgH+7o+94Y8W9FM4MRpkXSd9r/Vug2E/rha7KhV34Sdys0dkM5VO7FSRDwiNsEV+4/kHyGFFG6GsPw58VhhL3uUAcSw+4N7XLybKqF4wsnO7ivWPWJ/Q9XndLksI0u5lp/cUYu4ZNmLW+B42sjbMnbwwZRA/uu0d2+WLBXMg5l51kJI1OfyQgW4JgPg/gBGiq5q6d6uYgHg8gFZ+Wk3l5TOQwlHc/idkdiNJMOeOCweCaBnVIp7I12VKWWgQSHRyGsqpRD7dn9vrwpvlMp3LeR1OkO/qSMNFGPziuzfuLowCyKu/Y6+weKkhOhk/orVNvNJ8mJaAW4wp6Cpj0K1bBl9HyZymODUOQwvsoy2EfJ6CZCH4ZGXDSRsSU/cWNiGW9BXaiw52AuS/lf91clug/cVhlU/w0GF218TbjP3FNCEcrfTEOOfI+gWJ5IRsYQHHc5PbUlV3mnosUclt5hIDnppF5wYnxdOt9YP8KkLk/hmL9D45Yr+2ydAfp5fSscGeUu7RafhGxzA/nfYAtuGBRyUOVtdvnqm+KCKtEaoOUwPo3qHjSHvlLJR5OxuSAxkmpE2kTqnyOywtI47L63W8RohXFD86PVWygKGEQpP5/lro3UjCyq+CnPuyUfw7BvbSWfhrDf34vRjUNqPOJwt1LpIJUqapjE1uyiJDre1Njk88EaGPk42yWfUPe9FND/UQuhcFxK7oDdtqoej0rv/8zHiJ+RZZVQ/IE95x4jdbxZDkwjiZ6Sf1Dhr8RHHgBztSxEqMGDB0jFdHns/we8UMUrlj0x4bUSGi4XzkoPt9S7J56sR4fXRrVhUIO6bjTwRfsN6FYRP/
 SYDSCUKU
 XdqKaPj9ipL+DsM6bZtrhgRhvhBD18hGZX4mAQzZmhe8vUBaIS90Rd51FQ1RklKsBmYUGP/CQK2dI6wmzgCeQdb1/0zPEOecnMPwRQKOvU4VK3kK8T0U4rjsYqZ9qndcSHWp3PWLs5yLxgBnstujEE6U16Z2hhtt5o22ufUBlzmMUzHCRDXIJ4j3s189O11kpv/b6PF0BAM53sqjnftAkdz3q9JBZaXJVr8HORHQFMqIOBGFA3ZlMb5Hf1HZgWL7GtcvJInw05gHrQ7LsDO3R1WamVg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(for some reason, I did not get this email, our server dropped it;
thanks to Will for telling me)

On Sun, 04 Jan 2026 20:35:27 +0800, Jiayuan Chen wrote:
> Running KASAN KUnit tests with {HW,SW}_TAGS mode triggers a fault in
> change_memory_common():
> 
>   Call trace:
>    change_memory_common+0x168/0x210 (P)
>    set_memory_ro+0x20/0x48
>    vmalloc_helpers_tags+0xe8/0x338
>    kunit_try_run_case+0x74/0x188
>    kunit_generic_run_threadfn_adapter+0x30/0x70
>    kthread+0x11c/0x200
>    ret_from_fork+0x10/0x20
>   ---[ end trace 0000000000000000 ]---
>       # vmalloc_helpers_tags: try faulted
>       not ok 67 vmalloc_helpers_tags
> 
> [...]

Applied to arm64 (for-next/fixes), thanks!

[1/1] kasan,mm: fix incomplete tag reset in change_memory_common()
      https://git.kernel.org/arm64/c/5fcd5513072b

-- 
Catalin

