Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D4DED116F3
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 08:20:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8844E6B0010; Wed,  3 Dec 2025 03:20:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85BC36B002D; Wed,  3 Dec 2025 03:20:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7997E6B002E; Wed,  3 Dec 2025 03:20:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6817A6B0010
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 03:20:48 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0D0AAC0578
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 08:20:48 +0000 (UTC)
X-FDA: 84177463776.18.C69979C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 55ABBC000A
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 08:20:46 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764750046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sJurdQX8qj6ifDDdWMxroqyLo5BS65+WtQIh7u6Nuto=;
	b=xkGmIRN1XnmJ2gpA6JMG9L/+fZLDVvN45CJo4MPfm3UZFto0IflmKr2j4uZK9GRGo6i8NQ
	NbwF34IqA7YLF/qpg5XLBIltXkE9yxJdobIP6M/sLsT3/VxQVrCJwX3gtJKWz96L8uREgI
	M0tZqmg/tfw6MgaHt2YtwHI3xdk2Gv4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764750046; a=rsa-sha256;
	cv=none;
	b=IvnvdpUtnEc6EJhaVL71MVTK5VCwThTSCWxpI3ApYfV0ABI7Pw+2pwVHlZFz6WBb4sdVfd
	gchqKDPUjjluSqbwSXSKaPrv0Xqip7R3mm/C4qLzJ6D64bx2khSXt54ismpMylsppm6yMS
	T9hfiy7dApy1OM+xNIbNypmhKKQfYcE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1B547339;
	Wed,  3 Dec 2025 00:20:38 -0800 (PST)
Received: from [10.57.45.92] (unknown [10.57.45.92])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 49CE33F73B;
	Wed,  3 Dec 2025 00:20:37 -0800 (PST)
Message-ID: <51339cdd-3c73-433c-abf7-24553e0fbd6b@arm.com>
Date: Wed, 3 Dec 2025 09:20:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 06/12] mm: introduce generic lazy_mmu helpers
To: Alexander Gordeev <agordeev@linux.ibm.com>
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
 <20251124132228.622678-7-kevin.brodsky@arm.com>
 <07ffb66d-1e74-4634-bccb-75575b3862af-agordeev@linux.ibm.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <07ffb66d-1e74-4634-bccb-75575b3862af-agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 55ABBC000A
X-Stat-Signature: 8gy3piw9uftqcrmjmkayoxktf6uipyor
X-Rspam-User: 
X-HE-Tag: 1764750046-976507
X-HE-Meta: U2FsdGVkX1/dLjU8JK5QL74PejOFr/6LTfrayirqv8/zRt4YCezdllZQlkfeypW5Yq+HRtNk6bYEmStKrXd/YN1CJL5xvaYGWYDCUPNkVspNMv4xRddXxv6/WJ1OAe5JN+NBSyyDSk5EY+lR5/RgHHpTr+JJc0XK6/dTQjCji+LXEKjC+RdfLgMQrElX2zg12nciFhQMiZIUPGJBQYxfx8nGpLI2zv7T37EaCVKb8ioEuo0KBDH9CzBiL8SAAgctTlehNsJ7ckYhBMwvulPU/MdIDn7A7ytUyK+PS6fzwoHXrY8sJIeaCXArQQ9wQ8tnVLVMcmHFAQ53eUJ/6PszU/k4R7PonaDl/tJMQgTu1yxXIKyGYzuCrf7uqGwaD3WhSeWZTKMoxLawPp64nB5fuQ7Bcw7C7gd/LTL/cF5628T1kZWbHrsW2oM2irKYDCkIJdC8NZwUbNS1nfmxfkdn6ZtwiMThf3Z2AvIvpoixm/9DdZ1GcFa6Bz43u93RYWwPsabhCcVf8plc2unIb4PT7duhgCH9h/K1+GgAj+dt/8+ln7qQaVe2h6Eyhwc7fJFxJ0FMOlZtrbv7tqiyxCCuWfIjqum1q3Sa4UqcO3NFHo5ROEbV6fGNfcHQfqi1f5jujXRQA/hCJNAt/r8qJp2nhPnIAIdLEyIw0ZlT0v3XzbMMPgBxiQtX80qftiCV9yR6IwjlitVZ89+xK9WjTACmeO+9Cb36mQ9hHMqlIKKTIh3ddM9GTSi476zPhRiBNFa5HSxTeXbTuDddD2WctW3SZgNMrz9v5zwxvTyjxAERY1uuNQswjXgkbr7oS4OdAtSgz3EGVti8E+rNc15h5/iWbjBRc/d9sYNtfiWB6VWZhPaqr1yNcRmOSs0evKDQ+AueCuuRr8VNG5wXVsdbQIn73QI5rrcO03YIfSVsFvZTHdE5Cfj8C0wGjJUsX2Brbunftp2gL3tn+HsxHvBQRa9
 204ZExsz
 wo2Ap1XzErSHn3qrFSo+A5S9C/OdmigYSo2V/4nWELH2PU9MFFcEjyah8xkPFSfDlYHNNdwoyuuYSCMqTZbZobtt7Cc+j85QLFr+Lwk7Jm2j2JzmVMQFtow+9lddEb35jorG9mSodkzqfzQT2TMSzYECAydifAdAoeqgyAjBCqeoNZJ3sayoPO/UdpgKE4u0mCj8rEHYP+/sV07v3eF0T/NeROfGLzgrry5WU0MU2ZvLPsIk98m/3wJRpUWMsfgf2zk7J7z5C5e8C9LY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28/11/2025 14:50, Alexander Gordeev wrote:
> Would it make sense to explicitly describe the policy wrt sleeping while
> in lazy MMU mode? If I understand the conclusion of conversation right:
>
> * An arch implementation may disable preemption, but then it is arch
>   responsibility not to call any arch-specific code that might sleep;
> * As result, while in lazy MMU mode the generic code should never
>   call a code that might sleep;

I think that's a good summary, and I agree that the second point is not
obvious from the comment in <linux/pgtable.h>. This series it not making
any change in that respect, but I'll add a clarification in this patch
(or a separate patch).

- Kevin

