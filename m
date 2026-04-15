Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B5F1FA0C21
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 03:51:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D2D56B0092; Tue, 14 Apr 2026 23:51:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 084F06B0093; Tue, 14 Apr 2026 23:51:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB4AA6B0095; Tue, 14 Apr 2026 23:51:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D877F6B0092
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 23:51:03 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7065A160361
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 03:51:03 +0000 (UTC)
X-FDA: 84659414406.25.585FD02
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf01.hostedemail.com (Postfix) with ESMTP id 80F614000D
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 03:51:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=scoZs7A7;
	spf=pass (imf01.hostedemail.com: domain of yintirui@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=yintirui@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776225061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CSbdQ1faQzUZHOG/0/OYOqVYaiEfE0LTSulo7jZNh24=;
	b=a2HFo7LSk8Z3a56CAC8B5yWpdCXR5gY4gN/VHAiofPFqxEjtSgGA8cQz8yXEJ0ASyMNXPC
	x634nR4cUp+tNvyieDOBAsNsbtCqmskrPo8jJbk+r9svfI2POLx8VnsU1/X7x4I+tkk/l5
	fYsOdX1qQ4dlHHgJdquJz4dWVgLoyEs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=scoZs7A7;
	spf=pass (imf01.hostedemail.com: domain of yintirui@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=yintirui@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776225061; a=rsa-sha256;
	cv=none;
	b=fxFo4cF5hZ3PQAW4ofJrd6Ix4EEYbnCeIJZS8WGgC05b3wtif3dBBvlOamcK70WO8AZKf2
	v1m74jGI5IFeocnlin/NLXtwlgvh2SYSMdBu3LlyMgSCle3WviBQKbh2+t/dKGNLPqWxKz
	TbiakudY/4qwwHhwOTX5oMHDl/5FwUs=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-82ce2e2880cso4060662b3a.0
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 20:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776225060; x=1776829860; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CSbdQ1faQzUZHOG/0/OYOqVYaiEfE0LTSulo7jZNh24=;
        b=scoZs7A7Cte6bXrSWvDPsrTTH5LlfyGNamkuLvHhnrwT0Sp6HIbTW5SrrKPsqGvdRc
         n+G2Uvr27hvkFLlKgg5U2pxjrC99bmkCwttVozZMSUKRSs9vbtwDw/sssdmNLO//XVuP
         cetphWOvsgyjB+hp0hQOtoqd0bYLHTfhwfh8aQrtHve23MEYrgxahaABNhGdfFRgr3Cy
         w+IGv01o8CMg6mkZOFziAylJ2eWLeNovbNFhFyH6Nw+yIeP7/cy/WZnraVdJuFKNF9CO
         tXO5sCmOYQdKZkkUPr62q4tVGTQXZsc5uTwPNHlG7KcZoegtCxxi0w+/Q4M02HlNWC+E
         tjMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776225060; x=1776829860;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CSbdQ1faQzUZHOG/0/OYOqVYaiEfE0LTSulo7jZNh24=;
        b=njEJQMc9xuV07ai2TX7tHJYNr/DKz5zOk1SavrKi25OPtpK3mySZfVLdCmGlqCgS3d
         ufNtdahUJTSy0a1ZAPdVEZ+259NzcrvdKNLb7952GlgIScT9MEHyg0l1WRUBhqFUVX6b
         x8DSUPOwfe6/CrubL/8ioAmMGGJ2pbaaS4hjFNWNYODJ7ycy5IM5TsozWrAmPwCopOU7
         SlZUghgWlq+Ip5p3K/dTUJuhgdLnW39GX7m0DNOZxQDKJ++eysYsSV0Y4NQ9AyeXZ1Le
         DxLg4qQfFzNjuT/9vckc9XK6vmVxP3zEreXry1EnE+4k5UwXJ8DjvlsGwi588SzXrkBQ
         97jA==
X-Forwarded-Encrypted: i=1; AFNElJ/iZyHJ49RoRpUB/mBfpVdUNsJd1AuUPPdtQsG0Du+U+M0pIJj6zPm3tOXc2++dO2h8S1KNddikJw==@kvack.org
X-Gm-Message-State: AOJu0Yy6xGHNfV4mRg6alzYlUG7LCYk4V3fGoqpxqOujIYJ59eIRtPkv
	70zzujYhBB26i9pD1iAldZbAbzikcCgjCvv0OaaStxZU54L8RSUfNEKw
X-Gm-Gg: AeBDieuePLo1aU28Q92snYaKO+6Ga7g2TtkjLLp8sNu/rxIVJt03pKmDY432ioDQEqt
	Gbk924Ca0KeUuX60SO6R/g4h+Ov5xDEAo3fPr117A4HAeQ1+6jNFoZS6WU+BOA/utdXIreyW6g7
	h/Gwt1Vhl5z0vPsiCrnj0kEOoCPgn964zli/kPI2Zc9DLH9jn2zrlww4JKLeKmeVYg4MWJCiQxQ
	aSyOMxAp2evoPWQIwKAJHsGGzM4bcoR8yXGANqYHAhNjLwUcrd6igEbWcTEl8LihQKHYNO2szDl
	p61PDKXH/qCgoOp6LD7CMM9miJTGDLqwMLPi0D1qyT9eBSngY/wdzWfbbYvw2eQpg8tSIagZpKi
	0W/4OJ8tYoeVGR6NLtWR04KGQuCqG5HVKjR6v0r5PPmguJflydR+lufWryuPwawqmUZO+PgjTgN
	U5Th9ojU97NSq6WDPcKXPuwHooyXT3q279elsbNg0zXbYR+9MT1PFZcnVr/temEnv6OGCMhF1Xp
	7dCdswgIi6KjvCa+cgQ2swIog==
X-Received: by 2002:a05:6a00:a217:b0:82c:d7c9:5479 with SMTP id d2e1a72fcca58-82f0c29fe3bmr21203188b3a.32.1776225060222;
        Tue, 14 Apr 2026 20:51:00 -0700 (PDT)
Received: from [127.0.0.1] (211-76-176-102.dynamic-ip.pni.tw. [211.76.176.102])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f67449c3asm544036b3a.53.2026.04.14.20.50.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2026 20:50:59 -0700 (PDT)
Message-ID: <f7f26a91-5346-40d6-aee3-3b64c3249ac4@gmail.com>
Date: Wed, 15 Apr 2026 11:50:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 13/13] mm/huge_memory: add and use
 has_deposited_pgtable()
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kiryl Shutsemau <kas@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1774029655.git.ljs@kernel.org>
 <f9db59ca90937e39913d50ecb4f662e2bad17bbb.1774029655.git.ljs@kernel.org>
 <41b1ff54-c120-42ae-8b74-54767abf3554@gmail.com>
 <fe357495-2e45-443a-93b4-52bf21d3bdff@lucifer.local>
 <c6748ac8-6dcf-41b5-a281-2f21069b1f2e@gmail.com> <adTb6_xqQoQqK74Q@lucifer>
 <2f29f66b-46db-4925-b922-4add61b633bf@gmail.com>
 <53d748d3-4150-4e7b-8c1f-4c58587e9183@kernel.org>
 <6125defb-3aa4-494c-abed-982be684f839@gmail.com>
 <6417587a-7e43-4615-9e2c-50a245842f59@kernel.org>
Content-Language: en-US
From: Yin Tirui <yintirui@gmail.com>
In-Reply-To: <6417587a-7e43-4615-9e2c-50a245842f59@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 80F614000D
X-Stat-Signature: w587tfu39brjzpphqfrauenfr6wh15xa
X-Rspam-User: 
X-HE-Tag: 1776225061-265556
X-HE-Meta: U2FsdGVkX19fSOtDr3K8ojvGqj3Hgi+ihhFnnzeaKdoLRLLdobur5UybYH6HT3b+CWHIR5oXTLsXMVcZzqVL1swCmdl92y4KsGFJ4Bz8Qz0tMVl4gVBZNbGLgSMfQkB7oGBw2rpU6Umsp+X/7de/ofkN8dKZAdSWRrI7yvr29SB1VZO7DsynhYK5FWtbxdbiZLuVSFq/zP45QNykrFjlG2Sj6AZpnUl2izV+9xzBbXfcBePQrdxhdHp1B+Wh1KwfRhQYD7HfllXyYlDegah8CvzS0BFbNWHLc+SLgc9amh9UC0hHJ1LADtiWvYF35qmKtQQ/deNomEHi/FLB8LG6UnZyviIh9bZMkSjz6qmimoUme/nJ2dhrcS/sgAJyl2xFevwgMHx6RBDrD8WgMyhIYPZksO9h9GMo0TYv2CbUBIYptGIgmvHfUG98rFi8ZJ7ZuDJi9McmNBEwN0uEXaCFUYMi8bXeRnqUd3rvuaTgJIRgXa255axBfdZjK8PcBymqDaX04Pddf3aLtwbWAVRUuhY2+fqNGl9gY5i6tts2bv0CPmGZ8jDDLQkNTHtOtzCIKv/RvCuIaa7tGnBYRRiQuBo4Z0sSkzUBuDsLSuVv/UmH2TzGYmkW67du6a7PeGeuTZnDjPxxbCe2l0yC17T3eqx45/uBRr0oPDoLwHM70VQn7uNLpWmFuTR0aJMoG1HOtBMsdDuP0uC3AEPvfxi3Jy5bj3g0GRHUwVS4m2RN4plxuCrxerwyRfXPMUZO0OC37/c/bZ0gTKtzaqLpgI9UrEsqF25Zj9sl/ZNvphk0s2M9/bRVf/bpdOKuxTh7x8P0S4R6AHBOYX3gDRXBGLukrobTU8H1jNnYxKvNU5ntvWyabbjhbMrYY/PW+FhPNFg9M35G7tyzauu/DVhYndKGcJ8HrAJ8D93kjxcwlEy+tExwnxo/Nke2SOPsxXdjMxk3Db90wgKgIN1apKISXbJ
 hRg1jL4p
 J+0D58nLbzSu9KVx5mffq1xsYmshKOSiihgIOydoGJom1sRzaXZVbusAlRS8fAeO6/oJzZ5t05SxxRzE8ZmrDeSO2klyrDHYLKIK0bQXlkeGsmDjpjtMIEs9OFa+njM7bhFPSR3jbbgMNB0NalAb9ZPMBoWBkYGO/muMbQGLT2JF/nvhxL5wtdYmF4CSb2EsDl4WMqXYYfhE1+7dpEuXXevXwsgft0NzdnPANgcbI9O1SfyY5HPVAByRm+ZTp4kYEzt32cGd6y91fYjfImKX2tgYa/NzrVDN2H60cBRhV3+PPFTiQv7/B14hAX3zn3N7APhy4DDHGclGDP1mswO7Hnf8HBzu5wqWFwgAjjXPs+Euarp2ek8vr3Hcyq3bV0KWn5H/5Su2WKl88uz7mPHL/DICcDO8J1/qOeVV/6TypAd2c9PQt1FCfk7mJXbF1DkQk+3R33b8wmFVbIMuSrHjsiqLEUaWyplF7EH6YgpPkFg/NYduvxbIxVdMEjdpSSUng4fKtsRmNL/DP50VP9FHdqXJe0Pz8QSxonZm4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

On 4/15/26 02:15, David Hildenbrand (Arm) wrote:
> On 4/14/26 17:14, Yin Tirui wrote:
>> On 4/14/26 17:44, David Hildenbrand (Arm) wrote:
>>>
>>> I mean, we need some indication to know also during folio splitting
>>> whether we can just discard the PMD, as we can refault it later, or
>>> whether we really have to install a PTE table.
>>>
>>> What if someone used remap_pfn_range() on some part of the VMA, and
>>> faults on another part?
>>>
>>> Doesn't really work.
>>>
>>> Do we have users of remap_pfn_range() that have ->fault set? If not, we
>>> should probably just disallow this combination.
>>
>> I did a quick tree-wide grep:
>> $ git grep -l "remap_pfn_range" | xargs grep -l "\.fault\s*="
>> arch/powerpc/platforms/book3s/vas-api.c
>> drivers/infiniband/hw/hfi1/file_ops.c
>> drivers/uio/uio.c
>> drivers/vfio/pci/vfio_pci_core.c
>> fs/proc/vmcore.c
>> security/selinux/selinuxfs.c
>>
>> It turns out there are two users of this "hybrid" approach in the kernel:
>> 1. fs/proc/vmcore.c: It pre-maps via remap_pfn_range() but registers
>> mmap_vmcore_fault().
>> 2. arch/powerpc/platforms/book3s/vas-api.c: It pre-maps via
>> remap_pfn_range(), but registers vas_mmap_fault().
>>
>>>
>>> Then we know for sure whether something was installed through
>>> remap_pfn_range() or through a fault handler.
>>>
>>
>> How would you suggest we proceed here?
> 
> How about we populate PMDs in remap_pfn_range() only if !fault?

Doing this would at most prevent VMAs with a ->fault() handler from
getting huge mappings, which seems to have little negative impact.

But wait, dynamic huge mappings are actually created through ->huge_fault().

I did a quick grep:
$ git grep -l "remap_pfn_range" | xargs grep -l "\.huge_fault\s*="
drivers/vfio/pci/vfio_pci_core.c

This is a false positive. There is no case in the kernel that mixes
remap_pfn_range() and ->huge_fault() on the same VMA.

What if we use !huge_fault instead, disallowing remap_pfn_range() from
populating PMDs if ->huge_fault() is provided?

Then, when we encounter a huge PMD, we know for sure whether it was
installed through remap_pfn_range() (needs a deposited pgtable) or
->huge_fault() (no deposit needed, can be refaulted).

> 
> Then, if we have !fault, we know that the PMD is from remap_pfn_range()
> and has a disposed page table.
> 
> Would that work?
> 

So for Lorenzo's `has_deposited_pgtable()` helper, we could simply use:

	/* Huge PFN map without a huge_fault handler must deposit */
	if (vma_test(vma, VMA_PFNMAP_BIT))
		return !vma->vm_ops || !vma->vm_ops->huge_fault;


By the way, while auditing this, I noticed that
drivers/gpu/drm/drm_gem_shmem_helper.c calls vmf_insert_pfn_pmd()
directly from its normal ->fault() handler instead of implementing
->huge_fault().
If we adopt the `!huge_fault` check above, this DRM driver would be
wrongly classified as needing a deposit. It seems that DRM driver needs
a minor refactoring to properly use ->huge_fault() to keep the MM
semantics clean.

-- 
Yin Tirui


