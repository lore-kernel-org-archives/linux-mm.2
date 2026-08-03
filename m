Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5B81C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:44:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 950CF6B00ED; Mon,  3 Aug 2026 09:44:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 901616B00EE; Mon,  3 Aug 2026 09:44:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8181F6B00EF; Mon,  3 Aug 2026 09:44:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4DA046B00ED
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:44:28 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 514C214066E
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:55:32 +0000 (UTC)
X-FDA: 85059349704.16.99D4432
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9E9E940004
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:55:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XFsASIfG;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785747330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MFYRuVGotRRV/Itr2HNCyDdiZPa8mRw+riWzrv18CkE=;
	b=bj+ypQLNsFf4p6a/Rl1sR1ZJDXhQpnmuLFpygL+hdhJ15tQEvCpF0lBsgRKoKhi4ZMhcAi
	q1nmgIp9Y3JsdwIg2DviY8LMucjvhZgB7edBCbN6BHU+xvJmixsUOx3fctRbog0ixWr5px
	gM9D4BnAssHXmJ2TuOMxeBe3BFeSWGU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785747330;
	b=XBLZHKOHBMLExoH8gpGCJFDplyU71qu8e8dHJfeZQDVi+p911wJcDxxyeMQeJ6zH3VQovU
	aHFqf/6ywFw9Z652uyr4++nBjNHcsBLEs2zfDlFWDrWK48/27829PWuOyxoxMaDgck0Ftn
	cDCXQiPwg/ytA8aoS1WpsqBguU2hg2I=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XFsASIfG;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E485760A64;
	Mon,  3 Aug 2026 08:55:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBDCF1F000E9;
	Mon,  3 Aug 2026 08:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785747329;
	bh=MFYRuVGotRRV/Itr2HNCyDdiZPa8mRw+riWzrv18CkE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XFsASIfG887MEylBFK/VV7zOG4pTZr7VkBRusfpGrMGat7arjNStYoDU4/FFoTOhw
	 o3EaUDv0YC/CES4rDGgAEkyO1A1XgXhRrWihJJqZi6fNNK1vZ7KdOTripqUyS5rcuN
	 fHSl2XK+YWLStdsn6SVuFT/LSPTxajLTOdLTLy9IYbhei7SnGc1YBXb72HK2Acw+k+
	 QZAuZZYOl549M12WWAHzbPdCnI8ZAb84rO69I4VC+eB2ogkdKZ9N92fwHqkffxKsn2
	 meCq+NUKjyyFLlKjf6H0eod/2PTP4y4CwNlwYKsNHwVyjIYiSzYapIrJMQyBmlY0uT
	 9Vb7fQ95lk2WA==
Message-ID: <0a9c8cc8-1fa7-4f4c-b7df-e847925c2b24@kernel.org>
Date: Mon, 3 Aug 2026 10:55:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: pull writability check to follow_pfnmap_start()
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: Alex Williamson <alex@shazbot.org>, Fei Li <fei1.li@intel.com>,
 Peter Xu <peterx@redhat.com>, linux-s390@vger.kernel.org,
 linux-mm@kvack.org, Sergio Lopez <slp@redhat.com>
References: <20260731160514.1101989-1-pbonzini@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260731160514.1101989-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9E9E940004
X-Stat-Signature: i5z63tf75faueg7zrteznzo55ncgcwas
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785747330-182576
X-HE-Meta: U2FsdGVkX1/lZ0epUIUN2uQl3CBWBiLtRoOVXS+ugmwjbBCbS3QD8sDU7BLjvSQprHPCBPFwFLsHtJqokQormtsyAi3MiD9LRSLdtIXPn+fKDlnhNu6zx2jOS5uWMrMZ+WjNmR1d3ZFvGAr3xOF3YHnO+wlEDgmw40k1sYQbbYpxvwl62lcN1pk5ziCsVRYJ91nDWY8jqgEXG91QQSX1nnWzXZ8KYCeitYuCHIQ8Csq0c6tAiplqjbd+VOKdL9XtyC0re/ULH/RCwtvUu3zn8XYn+9oHos5QO27bqx7mrNWhxWk4X4oTDxYpjhpKtRY0fbAZGVD1ved/RrIAZXspP6N/VY8nJ+H5nOKk+Ut+S4201EXAICVCf3bRcJwWVzLugusbTRssJaAXLFl6BmGPtgcIvdBtG1ImIPPNgF5qNE96uJ36vb5wgDjOfJgjc2gzEqXEKiegVrf4CQOzmNQyLLUzbNhsR9PMGZXoi1Yv0Hwr3aQMNVXg62iqrbYogTA04/ZGCHIBXSbvCYR4AUkdfZT9aAEeob5MA8I0eW3AmFGxLOLLtV189hWwnnPuwhrAcGDB/+GE4INzNPXOu9CxbJiQwEAy0YPNV861LWEKR9Un10LMou8I31v4ukLZ7FF7jK6PgzMHSSXy+DApsLQ5y02s+rrQocKCyKUigO5dDedjCwa55p0rIb88soGbPJX3c9BeUFm9HO0P0wgb6NjKPFe9vq1EvjvXeg3NKpvLoHfJVQ/BSGu4iMmZ7KvzTn2ZBXDBPFiGQbLr9PI3bmjfCloEOgNnVPMiD5isj9H8+loZC5edZEMAkAikWX23BWfEGWZAP6spj3wgRoyMBYz9Hp6/XsFyfNPNk4Yqs9gDQCjTQfW7ZS9fwqrCwm/taM5fsaDrQIWAJS15fR2F7tdRx2+uUY4iALUd+3scULUVFzP2Nh7Q3cM4PIYu9Vn398NnS5hNU4MBhocuWHOs1gw
 Tm76uGbL
 x7wlbXi6u+199jryWCZhnpOCK+gKVac91HyV0q5EnLCVG/kznwHO7AZIopOLF3euHlJTziL7f97pxs1PZV0jiqADMr7YyX1GZAg/baFvTuA68BM/aJm67zSkC1aZrGR/JCzrKnI1NamMMGj1FQJnl8bMwzkWWwutj8XrG42hijkkGVwv2WXeSs++gTk//KAabefXityNl3Kz6UBdyUq14I0EDMAVBVZKsO5Qp1Z1tLgt3qWhh9OaN6s+93keqIjT70cP9/7hKQeyTUxB0TvxqGLgQkQgVlE77AfKfUL+xeis9iDD+x49sGhSdWSkihIB6TgGLe8oLJVMQneDa3ivlq8zQBXseHKjtw5VMtlMwYVKwdw41qA0oThg9mdq6trMxGaGv4FSCxHAE+GpJxEJIWR3DLeewzr0UeibEFhIuyJ6unrI5eaRGBo+ypSNaBGDAmIgjcWP01mEJC6dN+f1q5Rr5mxnWmITi108Eyyr2FV3wxXA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/31/26 18:05, Paolo Bonzini wrote:
> All callers of follow_pfnmap_start() except s390_pci_mmio_write() are
> following it, if they are doing a write, with a check that args.writable
> is true; for s390_pci_mmio_write() that's a bug.  Most of them return
> -EFAULT if it is not, but because follow_pfnmap_start() returned success,
> they do not attempt to upgrade the page from read-only to read-write
> with fixup_user_fault().
> 
> Pull the check directly into follow_pfnmap_start() through another
> input parameter args.write_fault; this eliminates the need to do it in
> the caller and, for callers that do use fixup_user_fault(), lets it
> attempt to upgrade the page.
> 
> The change in return code to -EFAULT is okay:
> 
> - s390 is the only one to have a functional change in this respect;
>   but EINVAL is only documented for "Invalid length argument", while
>   "The address in mmio_addr is invalid" should already return EFAULT
>   (https://www.man7.org/linux/man-pages/man2/s390_pci_mmio_read.2.html)
> 
> - for VFIO and ACRN, -EFAULT was returned already
> 
> - for KVM, -EFAULT is eaten
> 
> - for generic_access_phys() the caller is __access_remote_vm()
>   which does not care about the error code.
> 
> Reported-by: Sergio Lopez <slp@redhat.com>

Reported-by: without Fixes: is odd.

> Link: https://lore.kernel.org/kvm/CAAiTLFU1ALsDoJoKW3d9bUvv990AozAoX=bEHmfnG54qyBAHFg@mail.gmail.com/
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

[...]

> index 485df9c2dbdd..34c79b5fcb9b 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3136,9 +3136,12 @@ struct follow_pfnmap_args {
>  	 * Inputs:
>  	 * @vma: Pointer to @vm_area_struct struct
>  	 * @address: the virtual address to walk
> +	 * @write_fault: if true, fail with -EFAULT unless the mapping is

Just wondering whether EPERM would be better.

> +	 * writable
>  	 */
>  	struct vm_area_struct *vma;
>  	unsigned long address;
> +	bool write_fault;

"write_fault" is a rather odd name for this, given that this function will not
trigger a write fault.

You want something that matches FOLL_WRITE.

"write_access" / "check_writable" maybe?

-- 
Cheers,

David

