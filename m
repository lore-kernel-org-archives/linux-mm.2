Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA330CCFA04
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 11:33:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2E9D8E0132; Tue,  4 Nov 2025 06:33:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDFCF8E0124; Tue,  4 Nov 2025 06:33:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1D408E0132; Tue,  4 Nov 2025 06:33:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CD8858E0124
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 06:33:16 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8006D1A04AA
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 11:33:16 +0000 (UTC)
X-FDA: 84072713592.15.0A3F331
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id D214C16000B
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 11:33:14 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762255994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6WOQeTavzPrauVi8MwJO524evgvZo3Tkv1ShmH0pjuo=;
	b=2CD3qSpGokA9d5SgJKFHRKLlsB3oR1B9UsgcrdYdGsWdLCHkSdFeUmROC+pTNIgEcyjcT5
	85swIx8EHA7xiV7Slzm/beN81tleFaV7ekNTciudCeALnhABZ2mLQsCkbNDGTgpR5F8Vbn
	e9JgvKNKFEM13C39HSto+cvBI8VwCrA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762255995; a=rsa-sha256;
	cv=none;
	b=3VEEt9wHm2fYjNYkTXkC7E+w9OpOOcMr04ISZjagz8Me7qw2bC3/rHww3YnW3a4oEYgo+s
	RfgQp70xS8VQ8TAbMyWXw8/L20HHHjGsjMAB4QVZLZhdwQRUUaxdoLEng1mzo4rlaGc00X
	gtGnQBnUdq8ikqmUKJlFI5/W8PIbb+8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D06201C2B;
	Tue,  4 Nov 2025 03:33:05 -0800 (PST)
Received: from [10.1.38.100] (e126510-lin.cambridge.arm.com [10.1.38.100])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C979F3F63F;
	Tue,  4 Nov 2025 03:33:06 -0800 (PST)
Message-ID: <e3326a9c-108a-4eb2-b12e-bff2b5edd1d3@arm.com>
Date: Tue, 4 Nov 2025 11:33:03 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 09/12] powerpc/mm: replace batch->active with
 in_lazy_mmu_mode()
To: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>,
 David Woodhouse <dwmw2@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251029100909.3381140-1-kevin.brodsky@arm.com>
 <20251029100909.3381140-10-kevin.brodsky@arm.com>
 <05e2062c-1689-44e7-9cc6-697646ca075d@redhat.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <05e2062c-1689-44e7-9cc6-697646ca075d@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D214C16000B
X-Stat-Signature: maixninq3mhjykout69hu5mderodzytx
X-Rspam-User: 
X-HE-Tag: 1762255994-364415
X-HE-Meta: U2FsdGVkX1/9kRZbeJP5SdPIDC21jgQHooyiao0NzXJcJ/WlS9MFPbAaUimnpnP3p1mnwoxH6IJQBDYMNsPezXoGpx3ePEvi78fRch9dn3voXLv1xRXEFnAEYPoAiymdaLdpmMmC/6oNh443nxZucfWNC56wMKkq3KFRJoB6oNZzZxx4EFfzsHB+VtGFsjQm/mXoAOxyogUcmY7zJd3mKTN67S/7m4VZKGQRD5njuUOQ9PJnnMDpJMPeruTy0rQzjOxGVqujQgSG0KyN69NeXw4iVzX40Poz59m4DyCzmjkIW9idxPuU730kVVzJMHrXY15MgIkn4Lct6J6dKzUvl6ORH+1F744sKSbu0VJmw8+2vskw2yq6NBU8vNUwj/YceMIwnoOqnqDSt0ngwXfFI/vEQvhUuS6HiZ4SJwzqOA8ABIZOYzivbrdLC8Z009rmYRPDz7bz2OurKz861QC1k25Ypdqswk6iL21LIPyL6IPYb+c1Ajb62j7/5I25su5pAfCsa5U1nYgNHBsO/xsC0QBkQhgcTSCG7CUsVsN2tHsj9CZOyI9kRVW+/S8i2C0OWWX6KNJVzH2BKEKcFeJgdPHdNPs0S2p6EmuqG09/K9T6peXWP4kbCcGCITakt8EQv87b7HINwYv3QPVhgRuDmardCQ/Xnki8ammAKzjXcjy4RDZr8kXKzlLHvcSQqq3IRKwudfasAQZlRA4HIcQ2gJtBi4uNX+SlJvz5qoV4VMrtr9243/y/kuEdlKfgVfXq33DFZQaTv2h313e65dvE7+CArCt7WLIJH6MCp9zL6uL5/7a9itcgSrwu96gvChKTqBi0/sy6couMKMzapK/uHpBON6TDHONKewUHZW7qdjBedbrj9V3z4+HHLuWjm1asVG7c5/x2tpqbIehcNPbft02yjycWHa4Xyj2s429jL/60S9LXIVGsn36wBl9D2l8lwjCDQqDLoYAbXLOqiw8
 lAxnxe8o
 j1uf+0RxqKV4Rdiq/mP61SpQz6BUvGlM4s1IucU42gZqA6bdSlQJUawZtf653hMW+Gw6u5AE+RJTzZlw6Cz7PTTHxGe3g6gnFhivctHWbmZ2dzyQNnHEt66dS6N1cumNeEFyEqfkMCFVAnyMFfINlMfgx7dvnU3bTuF1sMm/a6MV5pndboZfQa9WXty9XPXO/EOrN5LZYXAJzWPc3dm9E2WdT3154H+2WKajsDzGWI/oS551Mhp/JmFDn8rMbAyIpOzK2e1pO2cxCNZ6I3X6WGhSuMQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03/11/2025 16:05, David Hildenbrand wrote:
> On 29.10.25 11:09, Kevin Brodsky wrote:
>> A per-CPU batch struct is activated when entering lazy MMU mode; its
>> lifetime is the same as the lazy MMU section (it is deactivated when
>> leaving the mode). Preemption is disabled in that interval to ensure
>> that the per-CPU reference remains valid.
>>
>> The generic lazy_mmu layer now tracks whether a task is in lazy MMU
>> mode. We can therefore use the generic helper in_lazy_mmu_mode()
>> to tell whether a batch struct is active instead of tracking it
>> explicitly.
>>
>> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
>> ---
>
> I suspect you were not able to test this on real HW. Some help from
> the ppc folks would be appreciated.

Indeed, it would be nice to get some testing on ppc HW that actually
uses lazy MMU (!radix_enabled()).

>
> LGTM, but the interaction with pause/resume adds a bit of complication
> on top.

Does it? This series doesn't change when arch_enter() and arch_leave()
are called, batch->active and in_lazy_mmu_mode() should coincide. 

- Kevin

