Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 520DCC624C2
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 09:28:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95E4B6B0005; Mon,  2 Mar 2026 04:28:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 936106B0089; Mon,  2 Mar 2026 04:28:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 842496B008A; Mon,  2 Mar 2026 04:28:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 74DE36B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 04:28:02 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 27E7ABB4A5
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 09:28:02 +0000 (UTC)
X-FDA: 84500596404.16.144C04A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5F56E160003
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 09:28:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772443680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XDqqJpO6KvaRP2y+HP6XP+sqGzk+KS+e/tXhKDCvw04=;
	b=gGeSx+Hg7/Hiu7ZZPqXwrYo5DTvXExQX1+kDtO9mp2FEBWYksvCxE/1JRVVWaYgfWZJJdB
	QFWkzg9LndGnUGUI7JDpmxrSz5r/vpCNvMp9xw1VD+v/wGGRPvp+DKLu7QHZHXWK1heQM7
	Z+kJhvVtYCIqdUUjCT1Fj4jD4/uqqnE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772443680; a=rsa-sha256;
	cv=none;
	b=F9sHpiJedUNYQ0LB/ARYDJUlU/M7BkFJPIazjrJvEmRK0YUVxG/Zp6Lyfa96p3jzB/PzC9
	XFC+kgSTCb1hntHqLpBl3URe8648jVFrf/w9OlCGYkN5X3ASmLl/KahzWyj+AGy7p1i0iB
	+bNnN5mPfECIja+8SIo6iSu72c/no2g=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 290C314BF;
	Mon,  2 Mar 2026 01:27:53 -0800 (PST)
Received: from [10.57.13.119] (unknown [10.57.13.119])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3B60D3F73B;
	Mon,  2 Mar 2026 01:27:50 -0800 (PST)
Message-ID: <a5967fbf-7be7-44aa-aaae-f374ea7ea61c@arm.com>
Date: Mon, 2 Mar 2026 10:27:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 00/30] pkeys-based page table hardening
To: linux-hardening@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Andy Lutomirski <luto@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@redhat.com>, Ira Weiny <ira.weiny@intel.com>,
 Jann Horn <jannh@google.com>, Jeff Xu <jeffxu@chromium.org>,
 Joey Gouly <joey.gouly@arm.com>, Kees Cook <kees@kernel.org>,
 Linus Walleij <linus.walleij@linaro.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Marc Zyngier <maz@kernel.org>,
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Maxwell Bland <mbland@motorola.com>, "Mike Rapoport (IBM)"
 <rppt@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 Yang Shi <yang@os.amperecomputing.com>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org
References: <20260227175518.3728055-1-kevin.brodsky@arm.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20260227175518.3728055-1-kevin.brodsky@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5F56E160003
X-Stat-Signature: pgxk4umxe3ia1y8fxse6w5r1uty6qco5
X-Rspam-User: 
X-HE-Tag: 1772443680-812492
X-HE-Meta: U2FsdGVkX18cdMeEHj38dpKMfkct0HBI4RA6WdggCKQD02YfSrkt78l0rEx/zPgWFNz+utcPmgZEebgQMaSxLfvoxS+FZUp8HoOV+K+GOwMmJrDsJWyVdESHdydqs/OpgKY2rx1r3qreNRkETG1D81BhQ7EM3uI2tdIgYHkginu19xbPmfwAP5urD98xfABlEswf6vHflyYKS3DlsoZw8lG5oLWq5dtUwDq433J9zOMz7c3l1KTNkzKZBeO6FHsZtYwb2NtOya2Cixy2tP2Vi7j1UwrYLfJMRNCILjk+NNH5LIMltFBkAXIehq/GIxg3VhiZDAsUVyuVY7Rlg/02p9E6drYtD69EFSR6xDgmtc33LKqgVtpyTrDU3RMVnwxQkKP2IKKmDdWYMiwTP4ogNbH46PDpJS1UABhDpbZF+E+HJGEQduhVZFzEKevAfB56bUtdxRvn1NVYgAVDJ1WbI1MivQCIdsdou9Cy/SkeMp5W6nkV7+iGreOAe3PolBlVJH+LXiZRVqdQSqoPRJHFyGjPetQ/rxqkk7p871HWFdIzJqogmHRBAiEM7JqY38hWabPvgF3CivsuPe3+TMVGqEke2AZp4HrvCCdWFdUN0xQ33bFKUPUJNBpHABqJqSxE940iJj/GH6J+qt0FevXtQV0bMCZF2TtWOGeni1+o05BVXLZ58OVzwmFR8k41GuzsQOEMJae8fzlcrNqGb5gt01kx/7/Pj2lX4rhYEHYQvTripTocorfyl3/F2VbJ7Tefm9Yi3m3AedLrr3WimzuWHSncnueLxnUY6+UZnBKBFGj9PItjQmsT9GlGVecfn2r5kRqznHAKDUHc60IF0OzIaRipvHfBbdyzjtSLVq7wZE2V49/AjQdXOBYdJS3CaYklLCjg04zY4Yk+uLrhoRntCqyfDacK3kdm/Njd4UY9JXyWqaJ2pZoKzjiTvTjVkETsRtmZiyDw0/AsGM0wW5L
 YXzDF57e
 RiUvW+YJT83n7AkxNBRoT9Z03wFadiiC0CsWUJqWla9PH4uoIpCOm7uVCU9LtfLeaiTmxD/a3DedaZ7JOPpFUYfC7hsBSMgCuptX3mGH8oLKrm8HpSinaqBdrUoVmc5dzVafzip4WJ5/zEQw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27/02/2026 18:54, Kevin Brodsky wrote:
> NEW in v6: support for large block mappings through a dedicated page table
> allocator (patch 14-17)

To be clear, v6 is still very much an RFC - I just forgot to pass --rfc
to git format-patch...

- Kevin

