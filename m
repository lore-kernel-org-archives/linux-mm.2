Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32489CD6E5D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 08:54:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B3A96B0005; Fri,  5 Jun 2026 04:54:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 864426B0088; Fri,  5 Jun 2026 04:54:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77A816B008A; Fri,  5 Jun 2026 04:54:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6A3D96B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 04:54:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F02AC1A0A0B
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 08:54:25 +0000 (UTC)
X-FDA: 84845247690.24.A94B7E2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id B707FC0008
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 08:54:23 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Gzzb9pgK;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of suzuki.poulose@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=suzuki.poulose@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780649664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lEuH5zXvmD9QtdXA+3xoE2aKHaOUnCeUw+r6C/eGv50=;
	b=QIgFmk79XpBX0R1QeYLVC2Msis8NFRhMV3vEBxfEWpPyEk5Rq/rIDXJM/SnsmS+cHGJyFj
	uysZBua1HZJUA2rqjTYjdtxLSh1pTsBtU9GB8gwtwf8qKNlWHaErarPm+LmCZDL1/Ss+ri
	CqOQ6nnVmSPDFs2Wrn3ijK0DtFo9iVo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Gzzb9pgK;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of suzuki.poulose@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=suzuki.poulose@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780649664;
	b=2Xov4X2c6PGWQsuajWT6nGHcUCnKdo6c62O1OeCjPqfSit4AAyyD6eHxLRRRAwFNt7Drpo
	gDDYLeS6LzSa7R3vKam+VIYaaZB4u8G7mZXGueuIm3Vi/hoLwggVqZ66HEsCkMRwKNCTDv
	LKqxUkynI1lkEQGsCiSEW4mQ71pFGyI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9952C4CDF;
	Fri,  5 Jun 2026 01:54:17 -0700 (PDT)
Received: from [10.57.92.75] (unknown [10.57.92.75])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 36C5A3F632;
	Fri,  5 Jun 2026 01:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780649662; bh=za/Q5W3FetgNGBxC3/mNtBqJ6BCx8IDSiT33jjoXZNw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Gzzb9pgKm/VqzuNQWn4GqmeLpozOIVHEL4a7lpQ6LY9IuNt0PSiF4UMuyHA313reK
	 adqVfC75WvtPaiw9gE55+iUPvW+5IJFa0HDb8PCVsfPSAiOnAbMba7hYbKQPgjS02w
	 IVon2C90mRhBq/CB0loy54WttdKIcrw9FAQvra1o=
Message-ID: <3322698e-af49-4998-b619-34ab24094374@arm.com>
Date: Fri, 5 Jun 2026 09:54:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 20/42] KVM: SEV: Make 'uaddr' parameter optional for
 KVM_SEV_SNP_LAUNCH_UPDATE
Content-Language: en-GB
To: Ackerley Tng <ackerleytng@google.com>, aik@amd.com,
 andrew.jones@linux.dev, binbin.wu@linux.intel.com, brauner@kernel.org,
 chao.p.peng@linux.intel.com, david@kernel.org, ira.weiny@intel.com,
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com,
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com,
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com,
 steven.price@arm.com, tabba@google.com, willy@infradead.org,
 wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com,
 pratyush@kernel.org, aneesh.kumar@kernel.org, liam@infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
 <20260522-gmem-inplace-conversion-v7-20-2f0fae496530@google.com>
 <9d15479e-e36b-4865-804c-7d93eb339e4e@arm.com>
 <CAEvNRgF43RBv77RgM67kXRRHDnQw4L5uwQTuvkJHzkHJWB1mag@mail.gmail.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <CAEvNRgF43RBv77RgM67kXRRHDnQw4L5uwQTuvkJHzkHJWB1mag@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B707FC0008
X-Stat-Signature: 5yf8xitrja1j8sjskdnx6xb979rwn83p
X-HE-Tag: 1780649663-250642
X-HE-Meta: U2FsdGVkX188r8v59M6yPT38LXbrCCFXnsT4HIYpwhv2qN1bikVnhA1xM2Ssq3hfdMkpcRVg7XkzeTc+UMpCutq3VAjlfiPOrjtCkj9O/1jSDWQnvSrBFUFjAqmRNWIDL83eBX9mcfAR4kup9c5CBZoahOF1Xc7B+rvsiL5FvXtiYRemuafpdQFtaULO7v1AkvCtFWm3zNDZiWyszCeAG4rmaVzGrv/mgQUsXgmqWA4f2lfM7qwhuy8QkvGc/imIV2EohgU25NAYwJygURLaML8zuIqjJsL42mhfcMmn7xi/jitkfwRYVTTzq6DB+vdC1aEPhLVqDVl5qsitbzMrI0mropqQRFoJwpQBEp/VSHSFSH59R5UBV0qVzvaCWG3ZHLDpo8/xVitOSn2RfUYtfp+oPhvQGUMMg+HP2ocNIHMlBwaiwTHzmIf40lflSFq37sYzsoxYthJsliXs+wp97k2LXsfw38JJVpmSJBJfw27/maguPO0BTu96hN3zfD5Jza+VqysE6rH1Wk5OwsCwImCqMK8UHiRiowxjP5HoIpOBrJy23oKVfChOtePGHusOlOerqOK9+/cQe31nUmebM/bSZiX4ZDB+UzZ7Y0xPKlDA/Q4wRdMTXegHES3U8Im6sdjpRNxIi94EwEUqlRXWJVLeLKWk/yJF7J2kOsLZToEM6lgn37WA7c99IkMF0GiNDwLn1FgH2F6jUhvyKWEEyE87c3CzJp2llOfSz0WXXxfhqkIGUMr8NyLmWMPpSJvia4zW+NBbJWPWz5QKTWL98b6cX5i0yAb9/+1+sRNG4gSvRkjRsusvM8B5V316FfTiHLyRD/LU3dU/hTJD0oxZH+x1TtPaladluXI8j2pJFU4GY3WNbfXpTG3fjvkhwXYS3QMV2M5UK06GfIwnPHCzOqlR5FVvp1JSYURrWXp06bMifTKPxkj4ZvDmlRb3gXbOzzb6oPb2he8qEzw3T3L
 uxPDB4e+
 CZ9bH+TGK9nN+tPUv87+CkdAJ0mJ7HDZk7l60OltDpl0Hcszf5+KeepgMEZomSYl2kMVrcY0RBcwgDKYzzB4Jl2x7nCw6+f+4FVz7NZ84ojvaKIh82cdU0RVIoChfYT4BXLvxjWRYc54bS1uIndRN9RjvoiQJBLcZapYSAaA+ZNAn/leTkOC2D4Hk2lgid2aXMjTxMEx0wPssPezLQ8JxEim/1DhliVZ23PXXvYmXYyF2RMo9xzyCGDu96ZCMLf1Vkr6lRxt+NxHtgjVy0Bp7wjjk87O3wEQA7GUIe2BVAhbQ5I2KeOhkjHyXyaSmA/vpGjJNkQZ1aZN5gu2WjKN+IbICvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04/06/2026 20:05, Ackerley Tng wrote:
> Suzuki K Poulose <suzuki.poulose@arm.com> writes:
> 
>>
>> [...snip...]
>>
>>> +In the case where ``type`` is KVM_SEV_SNP_PAGE_TYPE_ZERO, ``uaddr`` will be
>>> +ignored completely. Otherwise, ``uaddr`` is required if
>>> +kvm.vm_memory_attributes=1 and optional if kvm.vm_memory_attributes=0, since
>>> +in the latter case guest memory can be initialized directly from userspace
>>> +prior to converting it to private and passing the GPA range on to this
>>> +interface.
>>
>> Just to confirm, so the sev_gmem_prepare doesn't destroy the contents in
>> the process of making it "private" ? i.e., the contents of a SNP shared
>> page are preserved while transitioning to "SNP Private" (via RMP
>> update).
>>
>> Suzuki
>>
> 
> The following is the guest_memfd perspective, I didn't look at the SNP
> spec:
> 
> Do you mean specifically for KVM_SEV_SNP_PAGE_TYPE_ZERO, or for any
> type?
> 
> guest_memfd has no plans to do any special zeroing based on type.
> 
> guest_memfd decoupled zeroing from preparation a while ago (Michael had
> some patches), so zeroing is supposed to be once during folio ownership
> by guest_memfd, tracked by the uptodate flag, and preparation is tracked
> outside of guest_memfd. So far only SNP does preparation.

I am talking about the SEV SNP conversions (specifically quoted in my 
response), I will follow up on Michael's response.

Suzuki


