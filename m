Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4E3FCAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 15:02:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 128388E0005; Fri, 12 Sep 2025 11:02:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 100AF8E0002; Fri, 12 Sep 2025 11:02:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03CAE8E0005; Fri, 12 Sep 2025 11:02:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E6C718E0002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 11:02:46 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8D5E65B470
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:02:46 +0000 (UTC)
X-FDA: 83880915132.12.B429CF4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 781D64001D
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:02:44 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757689364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pjxju66cdgbuLH84lLr1f0aB2LRRyXTtvk+w4J2qi2Q=;
	b=QbW+TdgdS0jJP+WscP2WIR0VFsBg/uQ7HXEYC11vNhurUH6i2REFvwNM2rw6ymUoatGjjW
	PReZtLdZjtbz1uWmNl7pzsmiGGZuysIPtwRRwUrE/BHC9KsNLmqQbq2L8jg8n7QSkSaN60
	P6RAXSLCtAy1HOTN+s/0uxMPqFb9SUc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757689364; a=rsa-sha256;
	cv=none;
	b=1iL0HnY4GgN3rA+SFyJG01A9Mi1lTAprOoSNNXnnz2WSmAtlEydHT42EszHKm4sRWNhRhR
	CwU1cXYjG93KrjOH180qDBVjNDQcawM/gefrhYwQWKGWKhxrG6creUX/tkv8GGVeTJe3dG
	VNFWdU2BnoTlg3zhZAXXd6TSlRNeXA4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DCD5812FC;
	Fri, 12 Sep 2025 08:02:34 -0700 (PDT)
Received: from [10.57.66.147] (unknown [10.57.66.147])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 558333F694;
	Fri, 12 Sep 2025 08:02:36 -0700 (PDT)
Message-ID: <f9b0bf10-a531-484e-9679-08ec25ceb444@arm.com>
Date: Fri, 12 Sep 2025 17:02:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/7] mm: introduce local state for lazy_mmu sections
To: David Hildenbrand <david@redhat.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>,
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
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org,
 Mark Rutland <Mark.Rutland@arm.com>
References: <4b4971fd-0445-4d86-8f3a-6ba3d68d15b7@arm.com>
 <4aa28016-5678-4c66-8104-8dcc3fa2f5ce@redhat.com>
 <15d01c8b-5475-442e-9df5-ca37b0d5dc04@arm.com>
 <7953a735-6129-4d22-be65-ce736630d539@redhat.com>
 <781a6450-1c0b-4603-91cf-49f16cd78c28@arm.com>
 <a17ab4e3-627a-4989-a5a5-d430eadabb86@redhat.com>
 <9ed5441f-cc03-472a-adc6-b9d3ad525664-agordeev@linux.ibm.com>
 <74d1f275-23c3-4fd8-b665-503c7fc87df0@redhat.com>
 <248b4623-8755-4323-8a44-be4af30e4856-agordeev@linux.ibm.com>
 <b46d3430-fb84-464b-b053-490c6ea083da@redhat.com>
 <cdd9bc60-96d4-4f19-86c3-dcf598ccbd92-agordeev@linux.ibm.com>
 <852d6f8c-e167-4527-9dc9-98549124f6b1@redhat.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <852d6f8c-e167-4527-9dc9-98549124f6b1@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rx9xqe7gocn9nfbk5zfu9himxwiyxa8u
X-Rspam-User: 
X-Rspamd-Queue-Id: 781D64001D
X-Rspamd-Server: rspam10
X-HE-Tag: 1757689364-220967
X-HE-Meta: U2FsdGVkX18J0qv6ZSKIj0AaVnIIyD1yUM0qc4TZ3KJdDqPVUXn3MXQsXOs+y+dvqfYoHHz2N2+rjxic3JaZgbJjnW2l2E6U1s6Hf/n0Y4mk8m9rezEelNS96hkh2T03p+6pU+xOnNdmYfw5vKpm4I5s158EIF5gAb/ei0eSlvlrvWeElfZsoFJpEf2hNfO+yOKs7QXvCjVC+qZX+jHy3s5JhJvOUCwfYLOGdkYWa+XzugWRvisddknj9arhERXTeZjpyqCAMBl+H+4YX6gqBLWg7Kog82FXnVDWykII05/GtV8KYVShEOHU4z+38rNNnz2sUM7btrwSY5YEhX37rFfUvRk5WupXwNCnlUa8a2zP1mdv7ybLj0lTm6tq4+NzVUA4RpLMxwcP9YUReIblp6WJYqxzjgeuUJZPMl1027wa2rsrwT0CJuneKG87UR+1vKip/uK8vR7QFlMA/7n5i8x67ysRNyWYl21ufLL0DNhyPWlKrKjee+ooti0ABcyjYvAWE7YgrEE9b9yN5W/MD6MgwlkHELn6+/ZRuRHFRfmMilZJmYcZJYrCWRwESB7BsBQ8gVVqOYXoTMcjm/mocV9eHco7DXuJXQOLDJD1FV0ntt//yk+oe4n2LMyPkgZDgoTrynMQ1ZPP46a6XWHmb6sAsb9acBMIh4GIzAzORDzKoYnpMA4Oo4H+HeToVtG11WaHMLaCbHi3EK0+e5kxyDXSS0iQnmKUQqg8FOWaQHQ1EqVZWqmGOhNykDqZlMCcuzaNzx0wa5SnNkotOkesllxVNPNo39VLvNlybQer9F3X9ms/e8QPFDyQFfTelrU968wMQ5aiH3z5PcqFb2usxkGNrGgYDU/VVo0AKGdvVIf8vyLhG7pfroFhJCS8GuYCTvXcdZSYiwZKfGEG9bVcfSMPE9aKh4+GudAxobwpxRr2eNNsEw3JBT/kdWzD66KGbjXwS5yFhxTGBigEy8k
 GsBgwM1n
 Mr7AzvlLlYeTm1g3FUc8ZhwUhmXxJEFLLX1R8+ptn4SMDnZDgehgPkR84qS7xUoMiqsKcEFRElxxuCXIvfClPmXMqY6l+2bOJEeq3eRlLHwOAUDyvMspeyBo8AFnEGcYNmTBJooFMgykWzne8RCQTc3NQp7Mwwowndx/aAECpxra2ISs+5ELGUBQ9qpWlXBQz46DBPCp/JKuC6A2U8Zqoegn/sQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/09/2025 16:25, David Hildenbrand wrote:
>
>>
>> But I do not really expect it ever, since arch_enter_lazy_mmu_mode_pte()
>> is only to be called in PTE walkers that never span more than one page
>> table and follow the pattern:
>
> Well, the cover letter here states:
>
> "Unfortunately, a corner case (DEBUG_PAGEALLOC) may still cause
> nesting to occur on arm64. Ryan proposed [2] to address that corner
> case at the generic level but this approach received pushback; [3]
> then attempted to solve the issue on arm64 only, but it was deemed too
> fragile."
>
> So I guess we should support nesting cleanly, at least on the core-mm
> side.

Nesting remains a rare occurrence though. I think it would be plausible
to require this new interface to be used in a region where no nesting
can occur, just like pause()/resume().

In fact, I think this is a requirement if we go for the approach we have
been discussing, because nested enter()/leave() calls are not meant to
call arch_enter()/arch_leave(), and I really wouldn't want to use a
different logic for this variant.

>
> I guess we could start with saying "well, s390x doesn't fully support
> nesting yet but doing so just requires changing the way we manage this
> per-nesting-level state internally".
>
> s390 is trying to do something different than the other archs here, so
> that naturally concerns me :)
>
> But if it's really just about forwarding that data and having s390
> store it somewhere (task_struct, percpu variable, etc), fine with me. 

Yes I think this is fine, with the restriction above. The extra
arguments are directly forwarded to arch code and otherwise ignored by
core code, and unless the arch defines some __HAVE_ARCH... or CONFIG,
the extended interface falls back to regular enter()/leave().

- Kevin

