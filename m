Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6110BD1F9CD
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 11:53:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE73B6B0011; Thu,  4 Dec 2025 06:53:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B96DA6B0029; Thu,  4 Dec 2025 06:53:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A865E6B002A; Thu,  4 Dec 2025 06:53:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9300D6B0011
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 06:53:35 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 87BDE52242
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 11:53:33 +0000 (UTC)
X-FDA: 84181628706.24.D6F8651
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id E0AD480002
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 11:53:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l8F43iGu;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764849211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QVCBV6gKtnQy2rEAfBDSKKvn4qBqj1x+UGLpOf8yJyo=;
	b=g9KJOps/cSAdSCqyBWMQSdPYlrbJ0/MqUqFJKiIIy9RjydYDdz3vup7xnIsOaIL/vWUoW5
	inZLDDxos2ERO4uNexZV47UAA/9Uj4Idn46w6qvKu5ZwRdD7fQdgrJoLYzPKbWbJmfb8iT
	ro5f4KEirXEw2vBP/70eruuUvDXnus4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764849211; a=rsa-sha256;
	cv=none;
	b=7v/25QPbPdV3y5rvCZD3/6tGgHbrhZcZPqvHbRjfpyCXM0w/iMPtwfsz8ZB89GED8eegrt
	speoziA1LZ2WF4zWQw2HlDcseDIc0hxhrj3/TApzR6S+hloevmHWdmNd12cJokXIt4EeLP
	fds699N/BMZW0/hEtVFY2Aj0fVGVL88=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l8F43iGu;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 35ECD601E6;
	Thu,  4 Dec 2025 11:53:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8423DC4CEFB;
	Thu,  4 Dec 2025 11:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764849210;
	bh=Zpl414Y6vefFz+0mGA9CipSOvbTehPYA0WM0ZAZ5yEc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=l8F43iGu2V8NDUl3DIh/2+X2bfiJU3z4ZM3VULx8KpRVQtoH+xW7CH2tkww5ZTCxo
	 Z732odFWqfzHNQy5SzNM5XixZWclVhNfUhvGgJiGbPutM3AwRHmsLfNCAboCSPDTP/
	 mQ1qAy91zph5RvCXiIten7mneAop/GvZWqVrT+sRJH1n488UuXQMywvv0E8xZPYpO8
	 hem4mPeZ8WDhirZ3INCR8Hs8TJNiMUf1+2/EkXzuyFkWiHk2/yA/ki9bTau+qinvtl
	 uLvGed0JMtDUZ3H/ydu3YrDfOdvy/uR+aG5ySHHt6+QmCrIk7eopnc2uqCD/LCtR4b
	 NGvDZU/gQZlqA==
Message-ID: <0f08e893-6097-4ab1-8231-ac3304c51ee9@kernel.org>
Date: Thu, 4 Dec 2025 12:53:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 08/12] mm: enable lazy_mmu sections to nest
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 Kevin Brodsky <kevin.brodsky@arm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
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
 <2c2b3382-7bdb-41a9-b48e-4fa9a44312ba@arm.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <2c2b3382-7bdb-41a9-b48e-4fa9a44312ba@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E0AD480002
X-Stat-Signature: x19z9ki474j4ckfnooq9ohw1zci78mci
X-Rspam-User: 
X-HE-Tag: 1764849211-533182
X-HE-Meta: U2FsdGVkX18flhMPXquj/cc1qqsFhL9oAB+eJ+jW7WohwDcah8jy2pTHespTerPwW4/dLqCaO/bOhXLncamo95x8Lg5E/2JiFBvcn8KRJQ8uSWl9zXogBiVU14IEZQ+g/7VJCfXz+9pos2CqFVrJivr8chbJUGG8WlC7CvfqZW1iRgWJQqLkyLNKRp486dg+5Hf5Vslfn7OdK5P/63mXFSPm7FQAZpZXmXc1ntgTJJh6xyKyEnO7Jy1+P3i8WOq1qQy7kY2Lgz3x4ZroMSbTTLCcvmzbeeAIjSp/erIgdAsFFpXQ1yBxM2vY8h3o74EezQaaErOGbnhoUkwD7JafyxI9D6RzGmdjOwJ7F2J9DETqScNznvqZCgFfX57qrWe1TmbowuLL9ZJuT1kXmBYFXiJkfGGsKxFOJLztK2WFFlThBYHNF2v9PExAx41oolfe12SkFq0parsB6HBMw4174TemiaG/ORyJIaGjN0eJUSxc1sXVsKJJtmOnqbrFxF9jnxON45s2p8dc8DnOEj+cxb5uUbBIApXPiKHCxL+3Gmk4Ua1w0VPFA0O+NCITMBl8jjw6tRDNc72g2trubcwaIYj8oMJk9m4UR7kGbqp6Uy1OMUeX18WKKvT3G06Ivkf0a5TNDT9kmRWijdkeEykt4FiuvCwSwNUueA4oVUmz8MbJEokLwHxwfQx0hZF1g8U1k76eoMa7peaUphle+gX9HYDRmuZCtAuGaULLLkTTA0Kj4fw73DxgirFh5Y+BCgVXsvGGE6MSNDEi6tGtdKvtbo5sojbEk0i+fGvW8vW1C2eQQC4WE8BDdGW8JSAGp+KOv12KnZsie6OTRolHozItA6BR5jWTvcURgB2f+HfUiyEhsJ/q2DjQsuF7Ye5xIG+18T2xs4xquhItkdSevgsZ/nvJO1lzSGPovQoX9MXHIUBamAqNNn4TIaK6lB0UfJUAf1nU/myj2Y0N0r2cRnP
 0Y0Ljh6y
 LYOMjsfv/kcmzR+Kh3EhwmOKvqjDEdanqDry1q5JkpBIxlKXuF/kpGrpq8nA6QLTx1Y+z1INDRE2rYe5VTkWlUpbBmBOj8111JakD9DHS176PWPGDRP5ZAZ4/LVf9D+X7/aha5iWQ0Ict7ttk8VV1Nppx8MPqXijAI4o9vK+zRum3i+/P8r6dR8lPoPi2OBb4LnLuf4vtnhJvUkpec5AGjjtM7QQ/ZzD0maBr2Vw2tkDOO5d8LgvmqwWWqnylK/F2B/lz/kojWbpvA8yx5cSzsnHwHwG9HKhAopf0ybbiVB+a72MPlyOSWOvIdSpmpbXUghHMrEhkk+YjMOPhDkRX5HrMlijEfvuzEGgPrQbNzHggRhyc9vnFhum0vX4hFeyvoaTV+lBJXj5xWUk3cvIEHCyQZz77EGaodPGF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/4/25 06:25, Anshuman Khandual wrote:
> 
> 
> On 03/12/25 1:50 PM, Kevin Brodsky wrote:
>> On 28/11/2025 14:55, Alexander Gordeev wrote:
>>>> + * in_lazy_mmu_mode() can be used to check whether the lazy MMU mode is
>>>> + * currently enabled.
>>> The in_lazy_mmu_mode() name looks ambiguous to me. When the lazy MMU mode
>>> is paused are we still in lazy MMU mode? The __task_lazy_mmu_mode_active()
>>> implementation suggests we are not, while one could still assume we are,
>>> just paused.
>>>
>>> Should in_lazy_mmu_mode() be named e.g. as in_active_lazy_mmu_mode() such
>>> a confusion would not occur in the first place.
>>
>> I see your point, how about is_lazy_mmu_mode_active()?
> 
> Agreed - is_lazy_mmu_mode_active() seems better.

+1, I was scratching my head over this in previous revisions as well.

-- 
Cheers

David

