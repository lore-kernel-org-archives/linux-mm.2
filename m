Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAFD6CCA471
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 16:36:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29DFA8E0006; Fri,  3 Oct 2025 12:36:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24EFA8E0005; Fri,  3 Oct 2025 12:36:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 116738E0006; Fri,  3 Oct 2025 12:36:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F05778E0005
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 12:36:29 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C142B13BE13
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 16:36:29 +0000 (UTC)
X-FDA: 83957356098.03.3C82C09
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 174FDC000B
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 16:36:27 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759509388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j/NehgSaf9858s9E1S9389F8BYR9KG6IaGZWYC8wtiQ=;
	b=bE0CLbCEVTpwtXjJD3TZfD8UH2USZz+8rTzG/iHnQ4CkBf3LeLHJ+grXMPx4qMAB1gzqF+
	bck3SWnNpqpi3h0aL+xHjJfKbEYs8YAUXeJyT+4GeV5uFLooH0AfC5npmeni/Nqgc20CYR
	ZtB5CZ5yHYkVyiuYYwZK8ET8qDtJVqA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759509388; a=rsa-sha256;
	cv=none;
	b=HYg/i/Exkwo5gIKdM20UL10D/ZeWLsIKFe1y6uhYljb8XnguczMAcXaD6YBRSwhrGr1BTG
	9euWidnov+k0QOumNiqE68Ah4MUDhyW2lHG4BALk+r69yQHABcDWOh1MC8+Bso8u5pJtTH
	RCqbuLTN6C3Jb0IfT83zZxHdpptV9jM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5FC161688;
	Fri,  3 Oct 2025 09:36:19 -0700 (PDT)
Received: from [10.57.81.90] (unknown [10.57.81.90])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 34D673F5A1;
	Fri,  3 Oct 2025 09:36:25 -0700 (PDT)
Message-ID: <76cd6212-c85f-4337-99cf-67824c3abee7@arm.com>
Date: Fri, 3 Oct 2025 17:36:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] fsnotify: Pass correct offset to fsnotify_mmap_perm()
Content-Language: en-GB
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Amir Goldstein <amir73il@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20251003155238.2147410-1-ryan.roberts@arm.com>
 <nf7khbu44jzcmyx7wz3ala6ukc2iimf4vej7ffgnezpiosvxal@celav5yumfgw>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <nf7khbu44jzcmyx7wz3ala6ukc2iimf4vej7ffgnezpiosvxal@celav5yumfgw>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 174FDC000B
X-Rspamd-Server: rspam05
X-Stat-Signature: 935pcpxym95881wog8bdg8syubgefkaz
X-Rspam-User: 
X-HE-Tag: 1759509387-178974
X-HE-Meta: U2FsdGVkX18EcylhqnRmnCDQIQM0MtxkTfO76XJ8K2xS258LcJLJfcYhHsFabcy57oWXa2MoxreIQAAJavdqmvr3ENDlqfDhQftXlCOR4RB1DJJCYQutf8G82bgnU76EtpiIKqoRd5QOaOGZ9Xb0/aQT/U8I1akIhtOpPngfBR7EmC7ZjRbuRloeiIUKMTv0bTixJJjGyrRcXppLkYCdZ5i46YpbPC5J1IcE42F34OcrryGUgTH4WrxfqL1fIZ7gDTWCArBJZc1HeIjphR0P/bx7obJoDToSpMPEDduNmBgrzc6yXTFzvjkFsrRi4iZOZgOMh5NfsmPWJ+An2auNGh6chwwprCP6T/YW+kfddMLO0cTKiD78+6Z3qBTdbGdlGo7M8ZX9z4SKKMihSk2RhCa3/g9/GMNGAPnjFwi11mPb9HCsa5gf4t/22sNhU7lW4z555b1pjzCIgHMQco6346FzPtxHrmuxfhXCUeeGSQwyxG8LE62dHCdF0t1RRu84lDBmuOvaHw956Oy8/coh+C9KkMwg7iBHd7tm0dqDunAXtJonUmEtP8mCXI1ua+UNfsSLjejbd6fYwuhi6+G4upRW5xhRnzt9AZ959pBoWUAT+PHzAXROUSA7B5mDMn49obdVJVPlg27JwqgDCfCz0m0A0v4vRUyz2akFJSyMvXeheRRdDS29ncLUGCvj82CaCuLwFyAW/eYpror8hYF8sBN1J+D8wxbaixqBHC7cK7dNWOiJJJ07WbMpeoT3jCqNDtZi+RzU1osWv/qmPbFIso+v7gLZw88/GKBMc+9OKxc0MNYeriv4Q+Q8CkViUdAqxuvxADKSh9BBPbUT95SK+c7nl0OIQAEzCKijCGNdpLeH0/6Z1RZTJFOM5+etXZhc54BmwIIaQingfkcJXfSzSlgRo/jvlncJIQjjAz+p1Z1Oo5qb8RptUMd4pULn2C690elLRjKJNXdmddd3QiR
 nBfUIwFu
 HPmfRcs3gBgM216JLbpRuT7lhvr5XlxZd7YgGGYMWOgb3iE1EqdeDzeZX4qVG45xk0acqSrfjgShObxTuLUdBrwokbipFw2aWHU4XM8yKmErTEMSGO1jCZcAwrRyBp0c2cK+5uTL8bu+GxNplQn/alv2j/wePBh6IY89gn0lVxqO2lUkVi6F2DrJ4WLRS2AKuFmLZ3UU8x8nxfoxuacFP5wZEGA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03/10/2025 17:00, Kiryl Shutsemau wrote:
> On Fri, Oct 03, 2025 at 04:52:36PM +0100, Ryan Roberts wrote:
>> fsnotify_mmap_perm() requires a byte offset for the file about to be
>> mmap'ed. But it is called from vm_mmap_pgoff(), which has a page offset.
>> Previously the conversion was done incorrectly so let's fix it, being
>> careful not to overflow on 32-bit platforms.
>>
>> Discovered during code review.
> 
> Heh. Just submitted fix for the same issue:
> 
> https://lore.kernel.org/all/20251003155804.1571242-1-kirill@shutemov.name/T/#u
> 

Ha... great minds...

I notice that for your version you're just doing "pgoff << PAGE_SHIFT" without
casting pgoff.

I'm not sure if that is safe?

pgoff is unsigned long (so 32 bits on 32 bit systems). loff_t is unsigned long
long (so always 64 bits). So is it possible that you shift off the end of 32
bits and lose those bits without a cast to loff_t first?

TBH my knowledge of the exact rules is shaky...

