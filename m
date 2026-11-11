Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05F9F606A338
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 21:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=bV+bPP5V
Received: by kanga.kvack.org (Postfix)
	id 2A7DF6B05B1; Wed, 11 Nov 2026 16:36:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 257D86B05B5; Wed, 11 Nov 2026 16:36:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 171196B05B6; Wed, 11 Nov 2026 16:36:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E0E516B05B1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 16:36:43 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7564A80403
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 21:36:43 +0000 (UTC)
X-FDA: 85424147886.14.B48E4BB
Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8DA0CC0004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 21:36:41 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=bV+bPP5V;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794433001;
	b=c2W4/8TToxc4CC5TJizwzTnrOotMRT8dxvKXeaN/NoqbWn4iSerYTWqS2GRQYDlDQbPzzS
	7/KqWQEZ9An3uzIKIpbABvI0fLb1H2aPu4c3axAbOa9mIjG1jfd7SPks8mJSbF927cqCQY
	vnQ0x+2tUimhz+Is+pCF49wnxFtbeeU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794433001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0UsTtqPbFkPmIIllU2lnhMDYuxkEq5iJvf5QTXV3x/Q=;
	b=nXirbbayLz8Inbaqp+L6n8iNzZ1kRYUrnw0SwtfK7k89o59m3UYCjGn/BdrGOe3F740KL3
	Wjz8NJvn1KNPIz1t1bD7HyWF9lhfefsPw55atHfdW8XR8MrqphekANy8kyY+FNqfAwibQi
	HVlwXSD8Pyg6gASC06+2esDNejcP7uQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=bV+bPP5V;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-5eae12762c9so1281062e0c.1
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:36:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1794433001; x=1795037801; darn=kvack.org;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=0UsTtqPbFkPmIIllU2lnhMDYuxkEq5iJvf5QTXV3x/Q=;
        b=bV+bPP5VkK95dJJPEoa+E30Gq7gaBWSlm/8iFlskG+aAdKTkW25AkMGyAirWWNS/wg
         hR/GddOMakX1f9ow+luTAtZ82hXtYkSEN/PKZ1LW/RId5eC/UmaI9HVLC1LH4l5vXTBF
         ISpjJTrh4qAY/tYnryPsTPPRsmFXJVaZiO7dhrSPNqmTCu/PZD9Cg4BlZ5Cnbq2GSk8S
         DLpEyzNE2FCNkedm5L6Fl2KHNqBlx0B7h46c8eHFm8/r5uuhKmZ/tN5KLWvSHutcprah
         oLdG9HqIjiI0AhWor+tN1KjEFXP84zUBB8gllS2aJv5t7gd/cLhHxQiJkR2+pBOEKUKo
         X+1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794433001; x=1795037801;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0UsTtqPbFkPmIIllU2lnhMDYuxkEq5iJvf5QTXV3x/Q=;
        b=OgWFMjWD6r2pQG2K9uDeZaZkY9AJCHw39beId78G4VSccCiub7td5+rVz1xZnTRSz4
         wT5ywqdBqZt/QXJkyCz4GlyEmHPkMxT6/AxMc+9EFvGyDeKxQErcStadMIH4pvHyHQbS
         cl80JWizZESNJN6d7ndWmegZ/QZrnioKuC1fKbk3P/aaTKURClRT1s1sGuhbBYH6zPR6
         582TkPqOiZAaMrhjIjGusfVLhnXCHPcd1rPoqpf4g6y9Yrgs61ZaKpq8Q+v0fLOSEdAW
         z1kFs/kqEm3OBDrMM+qjgPI5GOTD0cYomF3BAU+AOaZ7dZPogGpCQqMX+khUkoi/0y/T
         Ysew==
X-Forwarded-Encrypted: i=1; AL+hErHojXCaLqoGJyB2mFkRntTrE8vwicpqJAm0syKNAUChsUKA4q8+X4iR8UIJeQt1yXH4V7Yr9KEImQ==@kvack.org
X-Gm-Message-State: APuU4Z8bdMEcLEmOVRROKl/IQPiC0Dpb2JkOu/doFLtX5gJM83mOVQbX
	eS3fLVNYKO5QDqDDmHvmqn6Cc0Pn0n65OFn0ZBrgvhZBcOYgBLJvU2FZuUwu0ZX0ZJQ=
X-Gm-Gg: AYBFou2gbuAqgRDsLlfF++bBiXH36K7RWUqRToDIWIK9zQX8jqbKj0u77RiQIm4G9g2
	k5OHOfrEeaTmfE9YWRfpQpM8hYn+HnEoT0rSNY+W/p++5t5nTeciM/gvTN8nsny/ugZ6cdyeXZu
	mTdUY6h49cMoD8+GSecImgYJkAX6HEc2LtjGI3rRaP3PPCZKPupbMg7H/jhJnmdvvIKW7yRVScI
	La+4ml7+ImnJtDrMO7/TH6h8oiZ/R+EfaEH2PW0SPCJ6ztLq7FoCJbxyyCKhQ6IBlnsW/Pj/LWU
	E54eGs1Pk0+Rq3LrXCWwgtU34cFVMZ88HrV8CF1L29kz8ebvkeniuv7iu1v+2yBC/+wM8kcw2Y4
	qzu04Je2ycBQL4RjUf3d1RPad6BFfgWAaVIxg0wf5B8BsmaQ/RLOJHD+HeO54pm4PJCLauJdpNN
	uSvQlbfsfDEvGpEujWQFZ02iOXTTim7D5UvSYBA/Sf/v2VQqzalD0ZUi2gPUgtJraXuL2sOf/sk
	aJSDteap6Fmv0B2mZDI46DbqmiTJ9VAFH2XpE2KoWwT7iqd7LQr727MSrZ5nZs2F+IS5gkQb5ps
	TDqJcdAPj8pQ/0Lmexz+F5w5IItC8S7Jq8vFuXWlUQHLjOQxcXrhp/skw9jYNndBTExbIQRjv3J
	CPr0Uh1Zs+XD+i4xossOaEwcSmHdm
X-Received: by 2002:a05:6122:c9f:b0:5ea:c084:6f19 with SMTP id 71dfb90a1353d-5ee1c3faebbmr1420493e0c.12.1794433000673;
        Wed, 11 Nov 2026 13:36:40 -0800 (PST)
Received: from localhost (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ee0c5afeb2sm4730325e0c.9.2026.11.11.13.36.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2026 13:36:40 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 11 Nov 2026 16:36:39 -0500
Message-Id: <DMSPERMRYZKQ.3DKQJXYDDFRS4@soleen.com>
To: "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Chris Down"
 <chris@chrisdown.name>
Cc: <rppt@kernel.org>, <pratyush@kernel.org>, <graf@amazon.com>,
 <kexec@lists.infradead.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <kernel-team@meta.com>
Subject: Re: [PATCH] kho: Prevent reuse of preserved pages after a
 reservation failure
From: "Pasha Tatashin" <pasha.tatashin@soleen.com>
X-Mailer: aerc 0.22.0-39-g5d7784875be2
References: <avQUquBK6cO6tUUI@chrisdown.name>
 <179443248353.2329176.13720873996862751451.b4-review@b4>
In-Reply-To: <179443248353.2329176.13720873996862751451.b4-review@b4>
X-Rspamd-Queue-Id: 8DA0CC0004
X-Rspamd-Server: rspam12
X-Stat-Signature: kd96cj7m8g8ob1mbpojw9ffqhgm684ic
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794433001-246343
X-HE-Meta: U2FsdGVkX1+433e6Z0Go/RKW5eju/A2v4dVknjXbDgFKCVjRQp0vXTOQ7t8wwJ5nwhs45NgwKajqu9qBTil0FYgHUyoc6zqqCxDACHw70a6fCQQdaUiSldqAjAlCggF2ADsKrEvdqSBpE/5zfKI7RQTD+SUIniWVT88cGIRt34W9918VL5BIJQfZR3zTQKMbnNn6+LRP6dn55kupkiFTGORXGG58Jl7tvkVmoJv7QQt1YxryKDJhPAswgd1QiQTTEFuxyvKBLwAneB96uVOJRybUghm908n6zUnVRHkJ4GNhw5uXg+nS7Tt+BP93mot7jBbDuXBRIT8HbI2/aCMDVlpEgCvaQB+DnZLH44gHtD74/logvUwV4W/xw1jld8AXM684iYnspKOI6xy3WbgNXL+VX+pBImbUuWCZVHtwUZ8/9n7dt+ySCKjB5FR/3ZFmp0Cm7ipkZE1FLbiJVMTx2xi9gnLp6ukCaRnGPCNkxeAuZGOnkJUz4oaCwDLS31iH095aCTUx2eF7WmmibsU6erh3ysJCMnjNWqZgXhpzPdqIdtZfwMsr9peUs5iWA0QiT83aVF74pQXnrIe3CHEIPb3o0TL1XHSPISlv99hdZfEVGL98soZiOa6FxTVqwEHDxRGY9naOZUQnBMw1S8NVQgCvk3BXTpqH+zo+Ce9XllozYciGwv3ZQQoE/iW3DXhVMfHcZNBYnN2JLRJAIrYn+Om3wsu05lV+7EOphqRdc0caQXcTHAaPTx77diTkrCI7n0quOzDVVkF8i2NPDJ8xAHjIJ6J0802wHTrf2zDPmym3b1e8VMUJUNFW29TogWPsE2uEtCqD6+6u7QMEkLNYxvd/G3ANdalbKWRD6DXyaMvGwuzyc9j25zVm4pH3vVNeGDgc55/mN69cBHPIVi/CaaGsIr0wTIg3vS9l++wi0SFr19GNNf8/IY577GaGiIT1ovqwpjx1M1NOcHKgNem
 dUqUyOvS
 3JLMu+Hs6+ef0s93DhaBUVTIwnN9zmktf5ty5MjThePNXl0ENpXEIsGTcKXQSOMtv0NQMkzAMRu2b/TtLq5d/9LWwnuCelXztZaPsbB1W7ijswEZVxYfiv0quqQZINcL+X2IlJDq/IPbcUcVYZrWcIXCHr/VXqhZWelk40rK3Nu4G2Q/uRqnNjekFFSVXRykQuJuJrsBN2iY6aAxuYnMPH9mzQkrGTi04wGCIpMnCfU/B2UwqTBENeKmY/r/Kqfz72FBpzRGsIJs/kwzbbvxPM47FgfwidQCaBNG9HXF/H6YJM8WaCfvjcauqaferNxEKHhWkOWhCeuPI3d1BpTD4SWch24j5Ttlp604e7YS4MhfzD2eXNtykchsZCvrWnaeB0FcG1XjPuAtjSSr0DH8luYEk1IiYAh2O1Ic3zSPrBZ0hp8SOO0g3lvewR+6e1aHCW1rD+C60xuB6jkQK1KntBFV8jgU0sdpuErGlwkBX3Y4jAE1VU+vesoCGPEeAdg0JJ5u0q5sBlkJ0OApEyk82pVZtqOTnYhD3qMtMysknU8ZzWSsN9nX8baJzZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed Nov 11, 2026 at 4:28 PM EST, Pasha Tatashin wrote:
> On Tue, 10 Nov 2026 23:09:30 -0800, Chris Down <chris@chrisdown.name> wro=
te:
>> kho_preserved_memory_reserve() reserves each range of preserved memory
>> in memblock and marks it noinit, but ignores both return values. Either
>> can fail when memblock has to grow its reserved array and can't find
>> room, which at this point in boot it may only take from KHO bootmem.
>> The boot then goes on as if the range were reserved, and two things
>> can follow:
>>=20
>> [...]
>
> Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
^^^

I mixed up my review threads and replied to this one by mistake. I=20
intended to reply to: "kho: Reclaim the metadata page left reserved=20
after kexec". Regardless, we are still waiting for v2 on this patch, and=20
I will send a separate email regarding the other one.

--=20
Pasha


