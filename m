Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 629F8C4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 17:20:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FF906B0096; Tue, 21 Jul 2026 13:20:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D5DC6B009E; Tue, 21 Jul 2026 13:20:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C7B56B00A3; Tue, 21 Jul 2026 13:20:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 017296B0096
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:20:36 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7654914024B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 17:20:36 +0000 (UTC)
X-FDA: 85013448072.20.6454B83
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf15.hostedemail.com (Postfix) with ESMTP id 00A92A000B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 17:20:33 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=OCGDcuY9;
	spf=pass (imf15.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784654434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H+kp8j8RQXqYz4HiL6BM9iRIWosOZOMzLCJGR/2Sk1c=;
	b=mF2V7ss8oKvPLNMm8OBoE64xzLLz3Odrm6/uHnnK2CzP3ZoGR8XBBRcL/Cl7MMuKErmf+Y
	MiDA4TVOGKhne/d/fW19JMeCiqOLCeLvprC59Ro0eTgq4q3sWyxak/VBm8tK605DPGt0RT
	5SV/0K70hypJpVGoIWiB+lNiQ14Ss+0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784654434;
	b=xZUkiMraxt+YQBg3kucPY2cQNh2pa0ef+16rUJp1yAr9B2JQF8eaR66H56dC1MC24l3A14
	B2ON86y1HuDd8usSpAQKv06HOSnlw4tBRfocD/9KqY4OMMODYMl1CUwIbVC00d4lpYRcos
	IEQVMjfh+Ce5VhddNUL6eGhpSGTH4ts=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=OCGDcuY9;
	spf=pass (imf15.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 65B4E40E00C3;
	Tue, 21 Jul 2026 17:20:30 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id RI_0lUk3GInp; Tue, 21 Jul 2026 17:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1784654418; bh=H+kp8j8RQXqYz4HiL6BM9iRIWosOZOMzLCJGR/2Sk1c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OCGDcuY922zK8+thN0a62DX0OJ8S/zy6csu77s+HJDg7Tiw3kuK5DaR9HV84RC1uV
	 3muM6FhgECTBD1hnQJgreOzu3oTIVap397z/IHO1OgOzVK6cFrjeUW28/6/VeYios2
	 9xp7ox94bn7q8PR/PYxTspEHEVs/es3ZexKmoUo16HiBUiLfFdshRCBDoOEcrWQZ5X
	 gk5MMg+8crrVqEUe7nSTVz7F1fjDQRHShglfx9h/aocbLPYQcmp6GosBqFk70xDh3B
	 vFl7CPkaTEBTA36WZiBsymfJjORj0ceKVFGsmJxm/OfHppSGUE9eNkgMvxt5mRVdLE
	 rBsAYl2pQKQC2N8xuA5SALvB/zZ2grhAHKMFeaX3E1wjKQeD9MCnn0iwT+iGtRJtiC
	 1pyvm1Cu8SPrZH+szL96x3eOB3+s8AnVA9sNE/F3/fekNwhMmnR9eW0ILdZLGwE+v+
	 xk9X39suV3YKAWgnLxhJ6RlvC5WN7q7PH/fhr9JeeRvlTdzEE29AX7RAcPkHsgkgZ8
	 dXZGOS2Ox1+ZbRF/n5yWDJpdNyN1PqtbqLvkitI9T1cNJEW10+XufRbq7u85XyZNuD
	 ALc9/5Rr6AHbe0zLz5I9GTdYVu4AJ2S9D9ua13A2ocklLMRv/WEp8zzXVITKSYuBkq
	 twY8CxE2QiT4H9C4DrpesDGY=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::2b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 9384340E00E6;
	Tue, 21 Jul 2026 17:19:46 +0000 (UTC)
Date: Tue, 21 Jul 2026 10:19:43 -0700
From: Borislav Petkov <bp@alien8.de>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: linux-mm@kvack.org, Albert Ou <aou@eecs.berkeley.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>, Ingo Molnar <mingo@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org, loongarch@lists.linux.dev,
	x86@kernel.org, Dave Hansen <dave.hansen@intel.com>,
	Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH RFC 00/18] arch, mm: create a generic
 set_memory/change_page_attr core
Message-ID: <20260721171943.GEal-qLx4p5YbocQNV@fat_crate.local>
References: <20260721-generic-set-memory-v0-1-v1-0-2c1fc62306b3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260721-generic-set-memory-v0-1-v1-0-2c1fc62306b3@kernel.org>
X-Rspamd-Queue-Id: 00A92A000B
X-Stat-Signature: 4cez5n6t7ij6aqb97ei8qgtj49qppgm1
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784654433-240308
X-HE-Meta: U2FsdGVkX1+xrVAkgzowvmO7J+v3afVWw/ZE5ZZmgcHmivDrmvmHmpDhvievzj+TkqGZZcRw3QWIz7skPsbqsF2o5vRqSmUgV6ViVnvup62t973kqgqqF9tHvgaCLHNy7/becFRn6cCJJJ9gV3kH+SdDn8njMcyx1rR+dVilQEV/Tw8kXorm+8D9D5R9cBOH5FzyuL3vx4qft6gQxXhWhGBlTeK6HZqRA3162BrdYEoOs2nrDiQyyommsWiSfzr7gbqRBxBtVQEwB/r8Cun/RAISc9WFn/8bAfg67hg1ObM3plk0b7WgvOftAXsR1FDJg0ZZTiqy/Wl1emtNrtFVrlq94LPGj3cXbH4O2ClNu9khIo99yFZ4hS+xhaDi6O8VHyqJf8rma0fU1FWkceakEvmxlzmc9fEOlC8HfJRjdHi4r6JN+1lYeUBn/JVQNMVuoCNtcOkKQt4LYtlWhQLSf1pNGyvbinupX0a+7IHEf/mzOq7T6gzcB3eEKZrXG1EoHeG5et4dyvwq4u+jhCRHVu8G98UAS8a4lrIERi4Xeh/C4gLpAngx3sgg0F4P7AIQ9Nt2lwXT7m+PjC+qMg0cbYjMehd/zjrNHCpxMCHVvFt2CvNBkAKm6D6oZ8+34s3NSndMOwzazMxBvF3mpX01RtVQW/7OqiNnrQPrE+NVN5ND+ygXwrLcbztIQPbK717NmAJYJyQHENqwVsDxs8GRXRkC7TxNAb4gyOvPuEKTrkNc+PyTB/1/gKEcdKkJ2mXlx7GjRwxV7FtNhrFDrn5rPE725HpH6N96XYf6nitx7akIGQkJvqedyTE8ELjbjvTYkPMmSxz0pOA69j6avFL4uePeqlk0sKvUByfQwQh1nbSXmoGS/Z+Ty9rMXKlldnUxfRF3L9dTg7Vso9h5VX3M8JHZ8jTnZBu+MUBRkGbk3Ppd12MJuIDPwi0Zj5+lvnaJOCx+RDd5f0upejoxU9k
 tlCzMxfG
 MUcSXIWq96vEKTLI7KAVmYD7y1MxDfqjtCcMIrfwp5m+h53j83jS7QeFF7kjfPpmC0Ypty8ojT2Gtzye17OO9cQWS5Io0We3ysGTyF5uSDg6zwRJFRwpXhPpObdTESQcpp1MvarwSRxfVls12DCgJSanYbGR+JO6YJQV5sSxA7FxqFDtWT693fWQm6qXDI9neRGy7iPq7793jHHbCGZZ3y9zp7Rh1PNM/LBYNHTEGP099r2BdvpWuWxXwolN/VNBLeRsRRGai82D5qUJvRAjeeA2tvu5xGFG6U0LhTkDBx9Uyx+Yl+PdyCTBAH4pegKmspGCctHryxHvJ2lRCSz8tYSZpBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 07:23:23PM +0300, Mike Rapoport (Microsoft) wrote:
> Currently there are 6 independent implementations for set_memory and
> set_direct_map APIs.

So with all mm/x86/CPA patches flying around, can we first agree on which tree
is going to collect everything?

And if I want to review patches in that area, what am I applying it ontop?
linux-next perhaps...

Let's sort out the workflow first so that we don't get lost on fruitless bug
chases and fingerpointing.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

