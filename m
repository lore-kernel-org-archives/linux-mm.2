Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73E56CF64AB
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 09:50:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B90956B002C; Thu, 20 Nov 2025 04:50:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B684C6B002D; Thu, 20 Nov 2025 04:50:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA4C06B002F; Thu, 20 Nov 2025 04:50:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 98B1D6B002C
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 04:50:07 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5683C12FF89
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:50:07 +0000 (UTC)
X-FDA: 84130514454.02.3A4D413
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9A36E140008
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:50:05 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=onejGqYh;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763632205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aSgQ5zEtRb7i3/aeb0gvpnlfxLTETt2LyMq5BXYySzg=;
	b=07oTm9DmbWADVW/xiPeOsUesZvSY8EXsNa4RjENCk16neItf1d834VZQUQpmGlgPU8fnrq
	1Oodm1Y/AJhZ3g9FW9b2xuDZ1vZkpCfU2zhDeuueQ18yk/owDn7jm4gAcJRWaeyGpX7kCJ
	CC2m7rJOj2bXNi6L8nJjtaRxboZv630=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763632205; a=rsa-sha256;
	cv=none;
	b=VakakqcTivsF7ZkFaEAvNOudq6xDvqGA/C6u0TQTg7Zki3OA8QIg53MrTuGov9x6gFIV5x
	6XOGdGMPjXy1mtrT0hdk8PxLAxv2OVdsIrL+RQLRfc1jK/X3amCQIibb1kojjEg921yaSq
	gESx7kbLC7UmdLZTLjtizyKHANTRjIU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=onejGqYh;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9E5466014A;
	Thu, 20 Nov 2025 09:50:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C59CC4CEF1;
	Thu, 20 Nov 2025 09:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763632204;
	bh=RE+LhO0lyczZvT5qhMHQ6FE+hQ7tX5g/6Qs1vERjc1k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=onejGqYh2uVHAJXJQ8H1/FAX/3fROhu5GwMScc3WCVfszEmk1HrVsTw3VXhv9JGmN
	 NjOdedEv6B1jmGrWqWuGcBonEUC1DJKbI+75P5+bmRoY8XLNuThzHwCD7m3tw87Ij/
	 JzWRn12vchGW5C/s3KB4M6Uyd7EP9kg6Nse8BgdOEYJ6F3ZjApjX7YqlZZzSCWKI09
	 7seS+Aia06Ne0NurN8KvjNuzT7G6WGZnPN5J5eSEduz8eWzeDvVm6s8CFN0JPi3c7p
	 G0BJ6T9azrw7HcHqWz9ZewRPyhomhH/s8YIrPeHlIA0074XWQqAFbHYbwznVBjaiko
	 hzcSsSfvJMbgQ==
Message-ID: <584eeddb-9a21-4eff-a5c0-446204f9e59d@kernel.org>
Date: Thu, 20 Nov 2025 10:49:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mremap: allow VMAs with VM_DONTEXPAND|VM_PFNMAP when
 creating new mapping
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,
 Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
References: <20251120053546.2885836-1-vivek.kasireddy@intel.com>
 <976e9916-c949-4fa0-b92e-87f6841b5cbe@lucifer.local>
 <6e415c85-9ccd-4029-91fe-557d3946ef51@kernel.org>
 <4fdd31d7-2814-43ed-9674-d4b15b0ed780@lucifer.local>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <4fdd31d7-2814-43ed-9674-d4b15b0ed780@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9A36E140008
X-Stat-Signature: jmii4awiqgrmfx7ya4w35a8ghtfjq9so
X-Rspam-User: 
X-HE-Tag: 1763632205-392131
X-HE-Meta: U2FsdGVkX1+DLJ43Pbkelc6UyMqplePNt1t8x/GdriBKrxpZAhESVPDMGM5xyPEYlS+qJkappI4lnodmfBncO7D7WBoqeKYQbHebySVjYwbhT/2jX+mLWImECocjQ8MpUfQRwPSll+X7SNSBpAip7A5czWr/va070J8YMExOtNaV51mwlWcEHl+CNhQuvdUHEAd49lMKAOmfTMfKf9FoG87EwYTQdlTbPfVO3NbGfVDMH9Q78/qsCBt5KEiAuUCCXCjHle9UPUYYeFFcA/M0lnWraesIBOGEx/98FR9YrWtG05CEs7E7+VSPRTFQSd7noAgPnF1cd8zAnXJ2R/pVl/sWMZoS6LWHOc6mHqP7lsOt1c+Hpex0ZmaSiGKL8W9QGNbXy7jTN39MPVvJQjJ9jPL3vssywaGqeRicSWiyxQYQJniTOjizUWwAR+OBMiN9uQ+7lTBeFj4LhlyAn8jk5hnkChiwp9kttdUBK8wZSkcr7Ey9fB6yHvMga7yJ9YOEBFdPsGOTD4r4ZGlgOOrS/eyG2YHdXn4VjXz8kd4OPxpjwrshK7uuN7ns4Ig4GeN9vF1MZyloMfLKdCke37XGmHIq6K5X0KScbiJoP2f8s3Z/ZLBQrcRtUqq2JDlK8X5jgre8S5V0qZnag5cah3pBLX1qau/9yWr/sfc79Iv4VWR3Ep+CJl/HGdMu3p42N1VxNxbWG2N1ll98U9sdDISByt7d2Ku6w3qOzZdVYmWdG6o2SEEPZGnUsQfo2fKI4KhfKtbCacMgz5qZnrmacMZg4m/H/c7XZ8w9GdMgoWA88oSr3rHtqBhaVEqoev8PZjEEHT2bBaM89WK4LRwN8gi5KIy6OJ0Y1+LrePpObdxmjw/hX+TwSKJvp60NuW5bIMGQyG3MVZfccERqA4alMe62Z0d6vmnW97N4pU4PODuGIGeCS1xdGmWHbMFDTU1iUbjD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/20/25 10:35, Lorenzo Stoakes wrote:
> On Thu, Nov 20, 2025 at 10:16:26AM +0100, David Hildenbrand (Red Hat) wrote:
>> On 11/20/25 10:04, Lorenzo Stoakes wrote:
>>> Hi Vivek, thanks for the patch.
>>>
>>> In general though, let's please not make a fundamental change to mremap()
>>> behaviour in late -rc6. Late in cycle/during merge window we're really only
>>> interested in existing series, series that are less involved than this.
>>>
>>> On Wed, Nov 19, 2025 at 09:35:46PM -0800, Vivek Kasireddy wrote:
>>>> When mremap is used to create a new mapping, we should not return
>>>> -EFAULT for VMAs with VM_DONTEXPAND or VM_PFNMAP flags set because
>>>> the old VMA would neither be expanded nor shrunk in this case. This
>>>
>>> I guess you're trying to be succinct here and 'clone' each input VMA using
>>> the 0 source size input.
>>>
>>> However this can't work.
>>>
>>> This operation is not equivalent to an mmap(). It may seem to be for
>>> ordinary mappings but in practice it isn't:
>>>
>>> (syscall)
>>> -> do_mremap()
>>> -> mremap_at()
>>> -> expand_vma()
>>> -> move_vma()
>>> -> copy_vma_and_data()
>>> -> copy_vma()
>>>
>>> Essentially copying the properties of the VMA to the new region.
>>>
>>> But this doesn't work for PFN map.
>>>
>>> At _no point_ are you invoking the original f_op->mmap or
>>> f_op->mmap_prepare handler.
>>>
>>> And these handles for PFN maps set up page tables, because PFN maps
>>> literally do not exist as VMAs which have properties independent of their
>>> page tables like this.
>>
>> vfio-pci is a bit different, though, as it uses
>> vmf_insert_pfn()/vmf_insert_pfn_pmd()/vmf_insert_pfn_pud() at fault time to
>> insert PFNs, not at mmap time using remap_pfn_range() and friends.
>>
>> (see vfio_pci_mmap_page_fault() )
> 
> It sets VM_DONTEXPAND but is fine with being expanded? :) That sounds like a
> bug there:

Yeah, I am all confused about expansion. The example code looks like all 
it wants to do is move a VM_PFNMAP mapping.

          if (mremap(iov[i].iov_base, 0, iov[i].iov_len,
              MREMAP_FIXED | MREMAP_MAYMOVE, cur) == MAP_FAILED) {
              goto err;
          }

I guess the expansion is because of iov[i].iov_len is bigger than the 
original VMA?

Is that maybe a bug in QEMU or why are we even expanding here?

-- 
Cheers

David

