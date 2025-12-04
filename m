Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64524D1D865
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 05:26:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F28D6B0008; Thu,  4 Dec 2025 00:26:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A4146B000A; Thu,  4 Dec 2025 00:26:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B8766B000E; Thu,  4 Dec 2025 00:26:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 395896B0008
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 00:26:07 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DEA7212CDA
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 05:26:06 +0000 (UTC)
X-FDA: 84180652332.17.DCCB1D7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5387114000A
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 05:26:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764825965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K0Grv1Va+x0sJ/0g9wgFwBpEp9cwhWm39UVuKbjacKw=;
	b=Txv28bDn2BltgRXCKRK9hCYoyEnlUew+ZuzN0tmKYVYKWi0EO74/Fix+bGfMEJMGkZVAnK
	jP6weunFIBmg8lmv12e+W8vF9vX3FojzpKaVqVVUu1zBDUBJ7R3pm3xqxkhrhqjeNH4wwW
	UFTzXhs4FPu2C4C3zTM94PvIU1Tj3cQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764825965; a=rsa-sha256;
	cv=none;
	b=kk3+Ei1sUYJBwf2gxYTCwDyapPlw8hRv8w6NQakXJdaKQSL1QkEgOR9Pik3a2//LEunysl
	AP6lYdA1j0Ca9wDR0w6lpuyqmHtxgwTM3jEkds6c/K8uRUi4exDg5FxfD5hL2i/ysjtcMQ
	OP2Rj9u7z1cU3SiK8ISCOR0YZ2JtRjI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EEB83339;
	Wed,  3 Dec 2025 21:25:56 -0800 (PST)
Received: from [10.164.18.78] (unknown [10.164.18.78])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 80D2B3F59E;
	Wed,  3 Dec 2025 21:25:54 -0800 (PST)
Message-ID: <2c2b3382-7bdb-41a9-b48e-4fa9a44312ba@arm.com>
Date: Thu, 4 Dec 2025 10:55:51 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 08/12] mm: enable lazy_mmu sections to nest
To: Kevin Brodsky <kevin.brodsky@arm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@redhat.com>, "David S. Miller"
 <davem@davemloft.net>, David Woodhouse <dwmw2@infradead.org>,
 "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
 Jann Horn <jannh@google.com>, Juergen Gross <jgross@suse.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Thomas Gleixner <tglx@linutronix.de>,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
 xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251124132228.622678-1-kevin.brodsky@arm.com>
 <20251124132228.622678-9-kevin.brodsky@arm.com>
 <23dcf752-0b75-45a7-84f8-25bddf97af08-agordeev@linux.ibm.com>
 <703cbee6-a813-4970-9232-34ee91ed8961@arm.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <703cbee6-a813-4970-9232-34ee91ed8961@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 5387114000A
X-Stat-Signature: oojsqqjzzysijybtsh4ok43xex36tki3
X-HE-Tag: 1764825965-641685
X-HE-Meta: U2FsdGVkX18EYVPAiakL588oiz6fYMlB8/IxplQW5vGEKIQjn/YCUKYAYY74TmKgvaAv5zIAj5Z6qHOCRpIC4DLakYqJSrzGxKrr3Vu8X8xpyw1FEtxfVLX2uxwtwSdlWY3mhZdW/JRhIiNXwCTPkg+3AGMQSMCDhP4zrQ4Cb/vj5MsALxlj9ebNffEounScSrndiLQt1gA3eDmE2woMuVlGmQF7bl30hgPbKNHuhDPUSXqLhOksUOaqgVKlmoZLwRmB5wjeyVN/W4MVUxKz4de60CmLAG+tnw51OyKWxWhjmbCJH1ZfcHNbHSudMm01BIhG5fawMkxY1UyUiZtez8Eupt4fKWVk3P8vYYh5JZ7xYmD2P4JJMMfHDlh8PDZJ2WizpIfvcwD/+t1xYx6op55HSJD+CMJaOeV2zgM+JvCTZDsZnpfIcK7FgM8OSMDWJzD+z3PQquAMGPnpk9C1JbXbt5lrOgi51HOI4gIODoC9weYwjcIGyE1bMia5WQ+PQ5HmWqnVDbt5+iReC64Ur6zkHSZau+/9ErbEY7fRnbun2k/OrhbhLlo6Djdhr86hrVsE2quZ8KRiHjajMyFIPwljQvH/hzohgrjXOAbOPIZU+gJ5iRwXtEHeKHOYaCVsp2b891QGbiCGFnbtFoXu86jPss6YDDVrkCJ3WyTlw/lwxJkPhqvW7WHuQouOLOWDn1GA3arQ8B10bOocIE8MJoDdttK30/KudPpjPPSAwbL2eblEWtQ/PMtlND4tCDq5B6m6QG5KfsHw4YzlTDik3ssgj6RGDNpWOleiSoa4kwow6hdGaaICLL5WYlKaf6cadkPdgzx9YCkkFjszYIsoYQ/x/l+YM164hvEYVV4/LfD/ChAg9GxhX5dd3pug/0UYnGp8ETdu68qf4nPRroo140Q7Ty8oIO/D4xIVIvuImCVz0uJe6C3yHud57r3OFhXgvFBJJN+/583UrsvxuI9
 7kUyaU9D
 QZ5G4Nbat+FqUhquTyuOBvUR2UQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 03/12/25 1:50 PM, Kevin Brodsky wrote:
> On 28/11/2025 14:55, Alexander Gordeev wrote:
>>> + * in_lazy_mmu_mode() can be used to check whether the lazy MMU mode is
>>> + * currently enabled.
>> The in_lazy_mmu_mode() name looks ambiguous to me. When the lazy MMU mode
>> is paused are we still in lazy MMU mode? The __task_lazy_mmu_mode_active()
>> implementation suggests we are not, while one could still assume we are,
>> just paused.
>>
>> Should in_lazy_mmu_mode() be named e.g. as in_active_lazy_mmu_mode() such
>> a confusion would not occur in the first place.
> 
> I see your point, how about is_lazy_mmu_mode_active()?

Agreed - is_lazy_mmu_mode_active() seems better.

