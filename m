Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8F15CF8562
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 09:16:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 102556B0029; Thu, 20 Nov 2025 04:16:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08C3E6B002B; Thu, 20 Nov 2025 04:16:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E95E16B002D; Thu, 20 Nov 2025 04:16:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D4F546B0029
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 04:16:33 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8A17D4EC61
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:16:33 +0000 (UTC)
X-FDA: 84130429866.08.0762B80
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id DE403A000E
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:16:31 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rhId9zEq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763630191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nn1QVxXynT1D+/FIDIIXVfzxU16tQlNwZTjqx/qGSc0=;
	b=ECL3KaaWESOofYp8j22a/T3zIKQf6nfuumz4t2vAQQTDsNXqabEV/GMmvmondOcM4ebxFe
	822A+GqTDa5nRnkur+AkYmY6UGJY/9Rb0SQH34hJmlNPIBzTYj5Amet5tGD3BIOtIbnDbb
	ZoUPp4DZ7pludmSNaGOOZjv1A/plYWo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763630191; a=rsa-sha256;
	cv=none;
	b=wh2gv2U7dD1E2Zx+aR0t8B6Zq+KPcfwYygudp7e/3mxm3zwBM1GuBdQgfmvvl9rt4/01v+
	tyWPOfKj4YW21sgvXH1PUrAHSzgZ/IBIhM7y82zjHZ83J8o/UEGi0F9ukXYdkUMiseMd3N
	zRjbaEfF80XxUNgsJhmZiX6uJGkbNis=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rhId9zEq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 165166011E;
	Thu, 20 Nov 2025 09:16:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7822C4CEF1;
	Thu, 20 Nov 2025 09:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763630190;
	bh=yky/Lz2zJ3R0r/5Dkq/qVxzk4B1hg7cVILu4O9sC09g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=rhId9zEqGKWMuFnniI4vgVgaIdoo6+BeAL+OuFUBIxDeGHypF0dFW8Ll0Lcumxz0L
	 QhH8VIC/uiwgSd2HihrMfFcANSO3JdYpw2HzxftW+2sn7VDQ6anIqtyXR3HDsOzz4j
	 baY/ot/okVIZKvFA4DZE6yQb3yGNw72UKuqa0qxwkDh9Ek33DnagQvsCoctH31aYnV
	 9sPrxDbGXmNfUBYH2KLKEN5osXAH34QvQdSF0CWqyrdvugASgSXrf0iGI1yFqgvdbC
	 Llh3LqqdZ/hP0mQmWZs7Q9ypysfffLrVAIbAzin8tSlqtCXnKnkyQr0YnSibUlgleB
	 uXvuhB7jvc8ag==
Message-ID: <6e415c85-9ccd-4029-91fe-557d3946ef51@kernel.org>
Date: Thu, 20 Nov 2025 10:16:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mremap: allow VMAs with VM_DONTEXPAND|VM_PFNMAP when
 creating new mapping
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,
 Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
References: <20251120053546.2885836-1-vivek.kasireddy@intel.com>
 <976e9916-c949-4fa0-b92e-87f6841b5cbe@lucifer.local>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <976e9916-c949-4fa0-b92e-87f6841b5cbe@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6qaz8ywq5nz8gopjrxasn9y91q5feizy
X-Rspam-User: 
X-Rspamd-Queue-Id: DE403A000E
X-Rspamd-Server: rspam10
X-HE-Tag: 1763630191-883669
X-HE-Meta: U2FsdGVkX1/eZPOGux7A32BydxS9YQ2QENZTavSyggwJ9GO6h80BTlX4/+kJ0Hy+S++DT1VMUEAdteyxfDI2HmNnuZLIAYKmo/lgqCzEKYPN3EEwlFFhP6Ap4rxhV0JmElTnYsx+Sz/FA0WQ0zFRvmkMpyaWOdbF0sF8qZbmVJBEhr8MpFt7dRkhzA/4SBKDAcUfcUFPlaOjh/oS5RxnsDzsYobT3G0IcDntuYOenOIUwsyYmDUfvMGQORUptlI/ynNYTh+8BOanZ6EWrLX1igGCTGCSWIXtmOD4FTeC0afsKPgt6sj7Y/9uUCQIOYFpm3/mRqw6sFYNaIWBUVxaarhy6BtENLr4zSw9TWlRJWY1/Q3RQ7dip29j8J0v3wWq+klLcxyOVeYekChX0tVTjb1cHT1O9XKc1Z31CJ074nrDNnZk0JN2DQMn6xn4pckgsg0pKxoBPOfSjd6TM/UpotTrEA0FaVx5D8VlSbhdXOhfgrNaR+2Ex58S3gAl7eVPsQkdovQLCtr6dRoswrNL6tQLQrxDLx8bjQYWzAIprgXN4KG8CYOek5fIx4tyuxdcfNGcW5DxBm4ktl2G7zTehS4sehQTRR1PlhPHQP2cRchhyQ4Z7WDaia7zGRTR4DNW127178L4seGSipFOqY+a3AbV1HrVmf0XrmymyNGLGoX0P/ZoIO0Gsmv9hPXvQS/nXd76EdXCL33KQP3Oz8+t4f9rG42DkyMs7Yolz+AJTY5+A3vUVtYc0Q3cMPg+qFxhOsC17CaK6/A7Qnf4T5C6eWzU2cipjpIa44cHk4GVsr71qt/JjG2Xgf2xpt1VRGU/MlSYp8LsDXypW3ZymAz0TdpIat7btytLDBGQZW/blr1juNA1zkEH5uGuZuiRJaxuEu4DyQBNf2Th/HgMnGtD1iP51d8j3XocKezng1Ihd+ngXca67qq+LPNEaWKKeyzkpAJ6UDukxKqu+QfMInL
 LaHtPgBA
 va2850b+kdpCcDqrFI9f4/O6KgCAWuoxBG5pDLKWC3YsTPWdU6KhS+y7JOOlgkGllFpZA7NKEpY+3iYYeqKJN7Uv5JAdjNedDzSsju3skT/5urEgKBVvBOHpronpT6ytZx1HApvijQgbs72GhfdGqNDO9FHdfSPVgi1HC3IEhVkvlByoCYkXc9nprxqA5yMaBvkjfApr3Sygv9RTg53AwItnNRvAlXErcGuJWgKBTNc9zk92yELALJoo6d5fka7C7u+SnuMgateRPVWWdrKv+i5FrYCrXPz4EFIB1phfFzfJw8Mw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/20/25 10:04, Lorenzo Stoakes wrote:
> Hi Vivek, thanks for the patch.
> 
> In general though, let's please not make a fundamental change to mremap()
> behaviour in late -rc6. Late in cycle/during merge window we're really only
> interested in existing series, series that are less involved than this.
> 
> On Wed, Nov 19, 2025 at 09:35:46PM -0800, Vivek Kasireddy wrote:
>> When mremap is used to create a new mapping, we should not return
>> -EFAULT for VMAs with VM_DONTEXPAND or VM_PFNMAP flags set because
>> the old VMA would neither be expanded nor shrunk in this case. This
> 
> I guess you're trying to be succinct here and 'clone' each input VMA using
> the 0 source size input.
> 
> However this can't work.
> 
> This operation is not equivalent to an mmap(). It may seem to be for
> ordinary mappings but in practice it isn't:
> 
> (syscall)
> -> do_mremap()
> -> mremap_at()
> -> expand_vma()
> -> move_vma()
> -> copy_vma_and_data()
> -> copy_vma()
> 
> Essentially copying the properties of the VMA to the new region.
> 
> But this doesn't work for PFN map.
> 
> At _no point_ are you invoking the original f_op->mmap or
> f_op->mmap_prepare handler.
> 
> And these handles for PFN maps set up page tables, because PFN maps
> literally do not exist as VMAs which have properties independent of their
> page tables like this.

vfio-pci is a bit different, though, as it uses 
vmf_insert_pfn()/vmf_insert_pfn_pmd()/vmf_insert_pfn_pud() at fault time 
to insert PFNs, not at mmap time using remap_pfn_range() and friends.

(see vfio_pci_mmap_page_fault() )

Now, I have to idea if that is the main use case we want to target here 
and how we could handle it, just wanted to point it out :)

-- 
Cheers

David

