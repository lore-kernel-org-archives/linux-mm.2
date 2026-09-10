Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6435FC79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 14:00:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 119416B008A; Thu, 10 Sep 2026 10:00:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C9BA6B008C; Thu, 10 Sep 2026 10:00:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFB426B0095; Thu, 10 Sep 2026 10:00:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B45AE6B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:00:27 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EE037140531
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:00:24 +0000 (UTC)
X-FDA: 85198012368.13.9A483F4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 01663A0005
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:00:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=blwkdE5Q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789048823;
	b=IoB1dTCZP8netjektahWQri5yQ/dDLmMqhCfbQGlSM/s4P7haEgGl4iQE+fxRLkVz4KkO4
	J0UV9AAYsFCXxSztn6x/DkoSpSa1I5xThqA2QKB9Y75rW4Ybtv6npRMe+5REUIxIJBpBsL
	UiDW9Igo43UmM7Oc0YcnXIteKpWmyog=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=blwkdE5Q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789048823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=en3cnLSz3rou/qEMJvX8ynI+F/sbMoUWhXxA8YlL6Ro=;
	b=pF22G78IUle9dnuD4FGP9uN3SbrAEs0Iq9+cgjPLBihxwbkGwXkuwDabSPAOpqKXWCRy28
	OcSluSTzEguoVrmgIvUDcK8Gt+IqF4WKUh4HoVPgd6WTN1NvI+Oxafb4R9pHjqxF9NIc00
	z+8r4silmqLQ4kNAdMFUSG5iwTFA8Sc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 55F84600CB;
	Thu, 10 Sep 2026 14:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC131F000FF;
	Thu, 10 Sep 2026 14:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789048822;
	bh=en3cnLSz3rou/qEMJvX8ynI+F/sbMoUWhXxA8YlL6Ro=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=blwkdE5QaCyKLuWw769dVAe7GqgyZGrHD9jp61Y7efv6M8KCj8uE12v4fDkaUrPMY
	 HvQzf0ChhszWc5zTCCOihSbPLfFivsmBe4jmZ0EqbUnvmOgjqugMRsoXSECB4SD3qO
	 /BXgi69/v2LxgFq6yYk8MlrrJnzW10TrVlGIc+HmH1k8viT8RdpEMwMtWz0OknlCES
	 vDY1+zDfG7X9NZHoRWvjpd50yrPjlDNT2BSSdLRL/OlVYYlqxP5SFSEDdHxoG/xFQS
	 bzfwkcR80B7EcfF8xQIZJCGvVS4IsyDj9SLCmaSXBNG6OxAcEwXKd6pbqh7WEb1d2/
	 iCZ1b4nRh/aEQ==
Message-ID: <580e45c7-7f4e-4fbd-b73d-3bbd048fbc6b@kernel.org>
Date: Thu, 10 Sep 2026 16:00:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] KVM: guest_memfd: bind backing memory to a NUMA node
To: Gregory Price <gourry@gourry.net>
Cc: Ackerley Tng <ackerleytng@google.com>, linux-mm@kvack.org,
 kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com, pbonzini@redhat.com,
 seanjc@google.com, akpm@linux-foundation.org, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 shuah@kernel.org
References: <20260902194657.79075-1-gourry@gourry.net>
 <CAEvNRgHWyBaBpZ4Bem1Eu86b-cuEA7NkyjxTJ4D3FnpGe1B2Yg@mail.gmail.com>
 <aqHkVKvons1tBs1O@gourry-fedora-PF4VCD3F>
 <0386eb30-0e0c-4d8c-abfe-86161b9e3d1f@kernel.org>
 <aqKxk2Marnz1HU4G@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aqKxk2Marnz1HU4G@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 01663A0005
X-Stat-Signature: xkqc1rzbirecwdstyjrgbkz65815mej1
X-HE-Tag: 1789048822-608265
X-HE-Meta: U2FsdGVkX1+tY5XzBBUe/UAXt8jRxcdnPTU1ojstiKZuSJCbC9dQaj+nGDhZMoUc+WQlVKX45+ACpWRGLSCeBlmEp3Re15Zcwo2uNw2dS2Ljzg59OP3ZI5j5fLCcWl1UMToJb0NrU84wICzo/F339/U50chy4bb7sKbZ+ZnuaSJRBiQ5rBjODhiDxRGGNXRlHRk3zlBnM3mWn+k6fn3vacH213o3+bnoGLkDVFSilBNuJr6j4urXo2pN2vAgRakZYfpoMv41dC3JA74vq+6qkQz0R/F6g/Te3I+rXAqaxiSZnAmOgteqxRI3Ze1EsBA5F3oPytmywGcV4YNlVawgWPYFliKmX/ZYvRaGTY62k6L7IwDHkdl0C3MV8kuXQuto0F8pFK6ce+xn/uLsoyJz7N7rTESWP5yF4ZnioqKYGypicSqKsvORj+rMu34uZpsqOzcp9oN9XXbN07oA/LSx6bnXUgS1sKJL4Jzqy3jIIO5zP+4gUL6nH6KOwOFgBh74H4nXILIvy7VTi6jj2Ceh7OeiFqGaBqeHt+7kyaCIVmE39LtJcoCNR3FgpSrBqzGTAZS0Q9RKFpjf+dMU0qxsx2fuJodmX48D/woLXRajLsPbCEhTA4aqUqdhQHMQmYnAu2uj/deJ7FTtCF+xnyIZtviEFGlfU/YgzIaLydch0JIN3/sj21yJIP1Xap7MvbxEfu1RrrGym9mWesSP1diuJr+swzx/YhS4TWHL8ihbJCWQDs1tw/SGMJ3sw+9W8HMe9UOsvr3y9POlzyEvM5JLxo6A19thW8hkOQ5ggaOAsjzeZcgsDqIV2HbGKyle24RAcMnPu5+0KWJBS4KpfL9yuwRHKbig+/2htW8UO4uP9FJYnDDWsuYLjdD4qLvY2pq1vFfTD3PP9CS1dQP4pnuqqrOu76rRcYIbciKGX+nG1vi0iYaV8zK6+vnKodiH7iExqPUIlKCys0JrjbPJiMd
 8oxijxcO
 zv6x29+GVersxsN6HnKXw+WriTA9S17+QdWPoa9IUgWUpKFB6/k2WT196CjjapcBDsqwq/45h+b9iQ3JareN4PjIbgUyU44X/2OAoRU6JDisK+uiWYLAZ9fDvOTxAc3YoeDksIIGg7Dmn6HWpi3GXGlJVmYzgpRtapLpAje2qepw7fdKOt+9jqrppPsTGDTGmv0EVT/vURk9+gfx4cGy+3jAfLIMQRLubcr/ElhAgj/YHHe1UdafysCt3CNcO9RVv8/JGSiSBV7GAMQpnMDUSZxc5e+pVHyGwWll8b3K2SAr5Cl9XRRTU7lNUDglqOzdXPjUzYc6kIB5kWlsnDAJG59r8P7x+GNUj4BgRr1KVQC6NyYeVghKQHAOkhtcFECiUAFsh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/10/26 15:39, Gregory Price wrote:
> On Thu, Sep 10, 2026 at 01:32:08PM +0200, David Hildenbrand (Arm) wrote:
>>>
>>> the eventual intent is to enable this for fully confidential,
>>> host-unmapped guest, isolated to a particular memory device.
>>>
>>> Requiring a mapping to get node-placement is quite defeating the point.
>>
>> You only need a VMA, not actually mapped/faulted pages. So I don't immediately
>> see the problem?
>>
> 
> There is no VMA here - only an inode (GMEM_I), which is where the
> shared policy hangs off of.
> 
> So yeah, if there was a vma, that's i suppose the missing component
> needed to hook up userland mempolicy to all of this - but I would have
> thought creating a VMA for guest_memfd is hacky and confusing (since its
> intent is to basically not have a VMA).

The VMA is irrelevant, you just don't want to fault in the pages. In fact, you'd
only need the VMA while setting the policy. (similar to shmem)

> 
> Is there a series I missed that was proposing this?
I recall that we definitely discussed this in on of our meetings, but I don't
remember whether we decided to not fully support this case given that in-place
conversation is on the horizon.

I think you can open a private-only guest_memfd with GUEST_MEMFD_FLAG_MMAP, and
it will reject to fault-in any pages, but GUEST_MEMFD_FLAG_MMAP also changes the
way memory pages are obtained:

"When the KVM MMU performs a PFN lookup to service a guest fault and the backing
guest_memfd has the GUEST_MEMFD_FLAG_MMAP set, then the fault will always be
consumed from guest_memfd, regardless of whether it is a shared or a private fault".

For shared-only that makes perfect sense. For private-only, where shared memory
pages would come from a user VMA, this wouldn't really work.

But I don't know how your case would look like (where are shared pages? are
there any ever?)

-- 
Cheers,

David

