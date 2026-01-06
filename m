Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51D23C47BE2
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 11:11:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E1AF6B008A; Tue,  6 Jan 2026 06:11:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88E8E6B0093; Tue,  6 Jan 2026 06:11:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BB426B0095; Tue,  6 Jan 2026 06:11:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6E2FB6B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 06:11:05 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 12AE51B7AB
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 11:11:05 +0000 (UTC)
X-FDA: 84301272090.01.589E49D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5E8814000D
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 11:11:03 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767697863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MR4UcKFyw6osJsKaBIwWGvru9oBOfn+ceDOkKBmh8Eg=;
	b=6GSyRnIezh1xiXmcAX50Y6O2SEjJisWmU98T3uRNPNFJd0jcFlpyj+N/riNzvN/zaklSyY
	UJ5IoRmEq8Red63iTLkvZP0Cguj/HF6yK5UYkRqfoOW9EOZu8yjs4+RXi0lEHLTL+9d83A
	+PEN4Dos1YD6wbdJCfud3HOOAUvfK9I=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767697863; a=rsa-sha256;
	cv=none;
	b=8aD6kVKHYVvu9tvYISfRU7ZgEz7qzLKhNhMcDWztuwOfV1m/uTzS85LGnk8/4biVqHqogX
	gyloMEgUeMuUJdrvV0GUIcNpAmxDS8/Bcp/GTaEFvpnwv30E+diuBTqv5UrSMuPtbbQI3q
	WS4cpSeBV54gKNiGi3FFmAeP1tv/u/Y=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 98652497;
	Tue,  6 Jan 2026 03:10:55 -0800 (PST)
Received: from [10.1.39.162] (XHFQ2J9959.cambridge.arm.com [10.1.39.162])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DB16D3F5A1;
	Tue,  6 Jan 2026 03:10:59 -0800 (PST)
Message-ID: <2d5db1da-7dc3-4ca9-85cb-1e97ba4e8925@arm.com>
Date: Tue, 6 Jan 2026 11:10:58 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/2] Free contiguous order-0 pages efficiently
Content-Language: en-GB
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Uladzislau Rezki <urezki@gmail.com>,
 "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260105161741.3952456-1-ryan.roberts@arm.com>
 <aVyRz62kQbPe5HbI@casper.infradead.org>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <aVyRz62kQbPe5HbI@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6pjzsqbqur7x71cwko81py5ibpxnskjw
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5E8814000D
X-HE-Tag: 1767697863-59406
X-HE-Meta: U2FsdGVkX18oiYqJwSuxJem0Moj6OHVy5jw5Ilh2ZVQd1JEnJk3uH2ZrHV2RZ+v4oFSPoD7EVga1nk0W1qqwEifBAQwcPKweFpn7NH0Ry+MjhiqPC2aEiyh8lutLafwH8uXUQFr4zE9ZvTUWyBNJt27pmN9RcBzpQDmle5nhpmcc8G5TOYL5uqxQzcXdVApWv+29OcUunfLn7TEADsV0/XyFsUKyduEmJFkOJiAt0RIHoJDxDOt12fvuOJQM73MFN6Sg+1QoGTJKCy4js0hLg1EXeEx8XYyqAxOh6iDyMRXHhj88uCCc+bDZL7JRJvVhHvAeLIdaeZPww5Qd5JvI380q7LsyWdtmGWkNP52sgMxXDIAiUfJJ5IexYRDlev12xlVXIQ1OL1SaxaDhuLZLPsH0C1eX93e55ObU4v2Sc6NyANgtkpmTnA9V39DTD6ZGZEqyWyPDwzdopGH9AHIrzsOrHJk4qR3IvXr3PfaxIeSRA/KYki211ci4q6vv/Sxw8CtKw3coCLQ0xlrModlI7xLuE2/THVxFKf2FUaZ/DaNDGT9Ib5km2oWLFBr5uZAyHxY6/XeAGJQWKXFq7YMxdeBQSGlLmfKVuSdn5dwbQA3LfDenRO+JgGwrWfwfDnE+pFRDMHuw7WLBe0tFpJS8iU8T56ozwm/ZExZf5pPJYPRkvQ3A5S+xdot1EegpqcthVBH3NwezDuqXnrSBrwkHHmk4b1BEsVPRhFrW0JQZdECTkBgT6wGJiLsCQZvHxYKyAbpnW+VItdSeZpCVSdAZbwwJi9T6UKHP2gQrBtw1suMdNG1eLZHYsN4UH9Rwndsad5tHJyAWTsFliarD4aJtac70A26i6aBiaxrP+TJBpBjAxmIavCri9U4GHMVE1l2HJoRVE78k4YUu2rta7Q9Bh+z7M1wlGhI9FeBQB7V8iAgLs/SYD6faFCA2qbh/K7mH/hMEw3v1yn0Aqfm3PK0
 HDJp6v+h
 O9NlB1TUHOY3WYu/UjtzB0E2OCuJ+ZcJYx6a9eV88CGODblMCMJBtFxVmtwYvXplqIhcHpN4BrH0/bEQqUkgZzzXfrKM9uguQ/K3qnFnDeEcfqELvzME0Kbihlf5pOrlfo6uDt88jW7kn2Hu3HVMaK/K3C4L/M6SHG7zlNv+Jok1ziaiwRUIe4SZA+rlmQ17RBh5OrOe+JKgR+wOig+FtNO+crdW9HxcD5lPGUnIuiGupy78FpuSqntqXFt1803kqVzzUmaa+nLcuAcqZNLcqXSv9O7GMEOKiKuVol0CaGOEmhWo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06/01/2026 04:38, Matthew Wilcox wrote:
> On Mon, Jan 05, 2026 at 04:17:36PM +0000, Ryan Roberts wrote:
>> Hi All,
>>
>> A recent change to vmalloc caused some performance benchmark regressions (see
>> [1]). I'm attempting to fix that (and at the same time signficantly improve
> 
> Unfortunately, there was no [1] ... 

Oops:

[1] https://lore.kernel.org/all/66919a28-bc81-49c9-b68f-dd7c73395a0d@arm.com/

(it's the same link as Closes: tag in patch 2).

> I'm not sure this benchmark is
> really doing anything representative. 

Yes that's probably fair, but my argument is that we should either care about
the numbers or delete the tests. It seems we don't want to delete the tests.

> But the performance improvement
> is certainly welcome; we'd deferred work on that for later.

OK, let's focus on the "performance improvement" motivation instead of the
"regression fixing" part :)

Thanks,
Ryan

