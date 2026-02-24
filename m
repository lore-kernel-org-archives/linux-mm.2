Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7125E9B258
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 12:40:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0EBD6B0089; Tue, 24 Feb 2026 07:40:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBCB36B008A; Tue, 24 Feb 2026 07:40:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9E6F6B008C; Tue, 24 Feb 2026 07:40:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C640A6B0089
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 07:40:02 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7C9911A0597
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 12:40:02 +0000 (UTC)
X-FDA: 84479307444.15.C0653CE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 58C644000D
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 12:40:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771936800; a=rsa-sha256;
	cv=none;
	b=6/g3e3BYfHuOGGWAQLaIlZC9dzXK16TmK2+j9zPYhIPi9lr3KQ1VKpKWUKzH+CKNGiHfKX
	9fSgQM4G013Ip27vLEfdjVxebJxqR03/d/EM0bve4X6EEFITSzMzWk9Xr7hAV+CHPrNK3S
	+1SG9yTbBUa0IAFFxMuTw3a7qMyI8SE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771936800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OCCbF7zHdk06kA7PRqjz5GJ0NMMsMNJZQgWKWakcSfQ=;
	b=Gf1No1qMEWPlBQXY4ZPe2XE1wt9iP2aVAEMBXTqcp8ZJ1cbgkXu+MGcWcVzfaP1mD5U3r6
	fjCFlJSkYYwXkYNiPqCSwJLJGTIbiiBN809YZbTMDHiIhHRDDwBRbRsq742d/Pgeh6t38q
	nDhv7jljvzdxGvvktjg/h1tsGqLfpdk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EC973339;
	Tue, 24 Feb 2026 04:39:52 -0800 (PST)
Received: from [10.163.172.181] (unknown [10.163.172.181])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AF7683F62B;
	Tue, 24 Feb 2026 04:39:53 -0800 (PST)
Message-ID: <99e06029-7738-4275-829d-6d96867785be@arm.com>
Date: Tue, 24 Feb 2026 18:09:50 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V1 04/16] perf/events: Replace READ_ONCE() with standard
 pgtable accessors
To: Peter Zijlstra <peterz@infradead.org>, Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Linu Cherian <linu.cherian@arm.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, linux-perf-users@vger.kernel.org
References: <20260224051153.3150613-1-anshuman.khandual@arm.com>
 <20260224051153.3150613-5-anshuman.khandual@arm.com>
 <aZ14lUwuA86aiOH-@J2N7QTR9R3>
 <20260224104134.GW1395266@noisy.programming.kicks-ass.net>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20260224104134.GW1395266@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4wg6j61d85rwtergacg3n5cifaqgiy8t
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 58C644000D
X-HE-Tag: 1771936800-694795
X-HE-Meta: U2FsdGVkX19gi4qtyyWHiS2dUTdLLsGc4rOy3LLtS2GLgIoe1U463qVuP4+/r7fkJ/uasPsywsCd+P5uX843gL/cF/f66mBDWzmBo0XoZgkqkDggvhoI3n6z5io03CJDHlEuBkbHZghg+8YhZA+F/4FJvp6f+bQoxDahKLLSFvbrNEjepkZpWalIYBqGiWsiQR4y25N5Ge1KelzVpD3HhKFj3mGCBHyCiF6o/AVvArffWdfggaYf7kL2fynnuLEaeIgxhP2udkvK5f43yi3YmBCXg5gRILAU+wiNmerjhZCpDbcdRwBHMr1JJFnwFtyKf3zAE5LMpBPREbWJOONHXthkFRufrOEGgrW4UcsfGjdzQa/7Arz/+iOBNlnWURStgdyBEh/cgQvScGXVupu++3f4oUjHTqRjIw6DGw6cCmsLzD7RWr4QKEx4Jz0baazqXTRKI48X4DfVwcvsn43tD4odkH/dNf6fnjN3IhSjS9Pgqlpx6B91vaIC0MAqgEy+YUh4Hx+qBKbI7NmoTqFvEdFIKLUtScM29n15ntt7OLm3aGop28AHMLHqcTsTSKfmpo2qd1ZTWiy/WbExxxFxgQ5UyoRvLfq9XS56OzJYIdCLSYEeA/zezM5h78TQseDrR79pHuGyVNNspKksVdrbGSTT9TQUwk4fxzG3vSm9X1ygjQJ09pDFO4wQCTBFjciW6atamFoXTRrY188VqpZyUMViSPeJ/nXl8OXV8cUC1OtiV/cbkjryHFMTRHELuPtwTZe+s444LBrH7FCrxnaHYtOa9dDxhwGbMAIK/BViv/BgZjvt3stVvffk8LEzQB8TnvsEMQcv1r3kGJEsmzbp8N6sM4pQMLWoicdGaywH63gadqzXahGlDBXXZbwuUQ96hrduZrkdMld6OxKOFW5xyCy2wVwQ7q1Jhi4uRxbB3Ewoa8MStRIsjvRCFB16zPuTH5jYbgyS3f+DZodPH7X
 vVl0OyvM
 QfJNhGe4CZtjohVf11Jv8TzXfzqlfcjXLiC1qGCQOx7B6q2Yiuy04hNTBUkcFnb5CqUHeMiwd2EjadQpK8JFwtcyKKUOkxEUlAQehdBCfNxU25Huau/BqGQlrTJ5vaH65shERrKUfYmiG9HvMQucuN5vv+7pQuk/BkcIjOq1sznWGiMyRe4dUXSplAruR05MhTD+u
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 24/02/26 4:11 PM, Peter Zijlstra wrote:
> On Tue, Feb 24, 2026 at 10:08:21AM +0000, Mark Rutland wrote:
>> On Tue, Feb 24, 2026 at 10:41:41AM +0530, Anshuman Khandual wrote:
>>> Replace READ_ONCE() with standard page table accessors i.e pxdp_get() which
>>> anyways default into READ_ONCE() in cases where platform do not override.
>>
>> For each of the patches where you make this sort of change, please
>> explain in the commit message *why* it is necessary to do this.
>>
>> IIUC the entire point of this is that in subsequent patches, arm64 will
>> need to use something other than READ_ONCE() for all pXX levels in order
>> to support D128 translation tables.
>>
>> Spelling that out in the commit message makes it much easier for
>> reviewers to see what's going on, and to focus any discussion/questions,
>> e.g. *why* won't READ_ONCE() work?
> 
> That, and only being sent *one* patch, I have no clue what the rest of
> them are doing. Didn't even get 0/n.
> 
> I hate people sending me just one patch; just send the whole series
> already.

Sorry about that. I normally gather emails from all individual patches
in the series while creating the Cc list for the cover letter, so that
every one receives the entire series regardless of the subsystem.

But this was the only patch that did not belong either to mm or arm64.
Hence some how missed adding your email. I have already sent the entire
series to your inbox.

