Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F0B4606A323
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 21:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l8iDfR4F
Received: by kanga.kvack.org (Postfix)
	id 5BB186B05E2; Fri, 13 Nov 2026 16:37:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56AD36B05E3; Fri, 13 Nov 2026 16:37:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4337B6B05E4; Fri, 13 Nov 2026 16:37:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 172816B05E2
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:37:52 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A3CE31C2C88
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:37:51 +0000 (UTC)
X-FDA: 85431408342.24.A200C50
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id E30704000C
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:37:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l8iDfR4F;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794605870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PLiqukr56C60XaYU/sHWlWdxScdz3EOuf+dLUbwdnhA=;
	b=Kefl0VAFD9mLu/+vKa51RYC4cBYBvFeL1fDeAQHVvcxlAQz/7mFxcmF+EnwoK7RGK968iF
	1mzwpS55Fhs+/9aXOkPo1/tAuAetTzofjvOLsY4qEVVKvNxE7qFE8gQUpMxjTwWTfHqJUN
	lp5Sgkp8+7UDZatybvGW0u2iFCCYFUw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794605870;
	b=zKaI+G9MFkxKMJITmVQp0TWCJ9uiA7hx6QjIz8wnSRIKIo2hwaXDiXEYbeIzYpi2RJ6cH1
	Z0oChZPdrkw2Y9BsjGZDi/YvTRE2sBaw8ob/6rPeIF6B05r+oTVpeL/eLQaio8PZselT4z
	uEn27o+MRdQ6ktL0f7I6jastVaI9W4k=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l8iDfR4F;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7FFF063201;
	Fri, 13 Nov 2026 21:37:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A744E1F000C8;
	Fri, 13 Nov 2026 21:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794605869;
	bh=PLiqukr56C60XaYU/sHWlWdxScdz3EOuf+dLUbwdnhA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=l8iDfR4Fn+bZOr3+4kgWweW+qnLrj4VKaTg7QNEbpGu/bEFZFs5nxDoj/kJFmkOuy
	 EswQFyeO0xhnKCfhg9Fxv8R+Ji1avzOxEhknOfUoFWfFiXvnBRtnwyyyT1s1E5sLGu
	 rIPhwMSSDY/K7NBkMePLqfgNHfXEju4yXrJZUlkEDDfvGmMgZ+2xSUi5eCDJEAeMnq
	 WMzbhlrefYk1jGACsD+PV+Ez4GFWp47Mw/5VoaKhHD++z7JVYv/6kJRB9nIiu2zwJO
	 GmY07jFS33ITqgEDCXs0F5jYryk6WirTuUlUhlluTjjhZp/zdu9BtuPbQv8qObwJJe
	 2RxDNmut2VdaQ==
Message-ID: <b290d347-1cd3-4ff1-b303-3cc074667689@kernel.org>
Date: Fri, 13 Nov 2026 22:37:14 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] mm: check permissions and bounds for vm_ops->access
To: "Kuehling, Felix" <felix.kuehling@amd.com>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Chris Wilson <chris@chris-wilson.co.uk>,
 Matthew Auld <matthew.auld@intel.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>, Rik van Riel <riel@redhat.com>,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Chris Mason <mason@kernel.org>
References: <20261112-access_shite-v1-0-988a5c470db2@kernel.org>
 <20261112-access_shite-v1-5-988a5c470db2@kernel.org>
 <4b9042de-973a-4036-a6a0-2294c65a1ee1@amd.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <4b9042de-973a-4036-a6a0-2294c65a1ee1@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: ecu9dgquixwmcjkn3p93ecpnwn5ws91w
X-Rspamd-Queue-Id: E30704000C
X-Rspam-User: 
X-HE-Tag: 1794605869-733694
X-HE-Meta: U2FsdGVkX1+XPYcUdqzLzkoncVe43LvelBcOSGE5tGLX/nVrDI4ZY9S1MaJtjz11fAuXkfp56kIXBeKB3ry31zBUfjpg+0yWKyicGuywarpxYphIUy5kUU4U7voOfCxnioVcroodecF6N3uMrziQHddgwswBhJUofePskw92nwQZI+9kBFm3l0oIkRuB2T+MOkJnmTKcOEBItXY3MMDZtrfNsUwjnJaLR6P/6ltQQzP1yH9jkgbH4rOaxQGNgZzPJ+DA89IOwf4WyJmganpgZV+xbjV/rgf4UENblR5cXK5gvf2DZ50WqXrE+DPCOlZlo/HUtx44/W2MJ4ZAA+upPIah7ic3FeGwxP0FXDOc705y+nJGrAH4vZ/N2cX2GlBf671e4jVSBMXNUPEcB/ef8uQW/bRsEOJ9nex8bhcVNNbVHuLRtlJw5Hvx/F6Rpfeh8SUznihsuGQMjH4Gal76BJ1gKUeh/0KIqjjOpP4XQ9+xsvUguR/GZSu5CcuNRtjdVQ7tVmTkKrgQGXEsxcnaTWWbM35MqRdQhXpCIWDl3bEocq3gjobLwxrbJRLA/5I9FVSVeM+mhxW75otfOON1MQ+om7r+Ml/aszWq+azmFOZe41/1fwIlAl0bOIQRGiLbPE1V0+ZuHBFYBlT9BYJh1jzgg+F4EAblb4Si2zxMosAmZjOMGKbgf3KlWSP/OY5JjVGRSrOu/MLB0xPrWYF/6EzaUVGRUlmm3OCmcQV1PBh5qqLIPYSBmBnWMsuWZpc9MWk9CojXdxQY7qcP9M2magZWhBtBJM9IGmfAZH35wW5oj9Pq4ivs7FlVfMF9H65+i6NfBObuctl3T8O6uxII4X/VaGv73yF73kfMmsLmlOX/89pIRrAl/wGjAyt70sX15KYu0xnEqKlwETKFCZ2fJ6fVEyyozy4YrbxiXZ4PaEK8czOh/jcNamsD6obob+ZujHUsgwAON+zwXzEfFpg
 txiD87KU
 Qo/wxg+qqrC8Zp0Yq9wkxwryjhJrpErlmpz+aXseYSNAYgm8k8lMSqbZVrJMUCZmm9mhSLKvMJjw2D+vzaBlneezgbfVyWYDxH921zt4s2Jq7b6Ug6W8R4Qu9XmXVDoUNZyTxXZJR1M6/wP9Wd66q0XtU2OXbtG/ixoDdzOJXjVeOncDnIvDq2wz9OuTvreCOk2s7z0NZ6bsVjCiBHobv9uLC4tGCtLrWyOHHeGEFbY3Gc3KIQHsSaZKkwh11NWkOBVyDa46IGvAUT/5uiRYOnTmlZNnKgL1t+IQtCCKK41kN9OP3nK2vSu2p+S5gkJmxAOdTH/LyanCNAX5yXvhLNCRWvm45ATGPMjfqgIV62SAjpzvwP59Mf9TWt6t7Y8PoAM8FxvcDjOdtjhTravwoTd2idQnwMXzTX4fsKdasFTKmKuk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 21:25, Kuehling, Felix wrote:
> 
> On 2026-11-12 17:09, David Hildenbrand (Arm) wrote:
>> GUP rejects VM_IO and VM_PFNMAP mappings early. __access_remote_vm() then
>> falls back to vm_ops->access without checking VMA permissions and without
>> limiting the request to the VMA size.
>>
>> Consequently, /proc/<pid>/mem can bypass protections even without
>> FOLL_FORCE, or cross into another mapping without checking its
>> permissions.
>>
>> Check VMA permissions before calling ->access and limit each request to
>> the current VMA. Implement similar access permission checks as GUP,
>> however:
>>   (1) Reject writes to CoW mappings because the callbacks access backing
>>       memory directly and cannot handle CoW.
>>   (2) Allow forced writes to non-CoW mappings with VM_MAYWRITE.
>>
>> This intentionally breaks forced writes through legacy amdgpu PROT_NONE,
>> MAP_PRIVATE debugger mappings. The workaround in commit fa5239f2af98
>> ("drm/amdgpu: workaround failed COW checks for Thunk VMAs") cleared
>> VM_MAYWRITE to avoid CoW, but debugger writes still succeeded by
>> exploiting the missing access-permission checks fixed here. Reads remain
>> supported. Userspace must use MAP_SHARED instead; ROCm 5.5.0, released
>> in May 2023, already does so.
> 
> Thank you for considering this use case and checking the ROCm history. The patch is
> 
> Acked-by: Felix Kuehling <felix.kuehling@amd.com>

Thanks a lot for the confirmation, appreciated!

-- 
Cheers,

David

