Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 976A4C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 10:06:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 965D36B009F; Tue,  7 Jul 2026 06:06:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93D4A6B00A0; Tue,  7 Jul 2026 06:06:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 852F66B00A1; Tue,  7 Jul 2026 06:06:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 62BB66B009F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:06:14 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D2B5D1C3886
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 10:06:13 +0000 (UTC)
X-FDA: 84961550226.25.E6F2A4C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2026C140007
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 10:06:12 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oUHpDMan;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783418772;
	b=NmWcZtR2yuS4+JMq7ZxlGfGnjleaN2pHenLq9PiVJ4joOX3vP9g8lk9Gi6iE9cM8cKtvIb
	YWfs2mBra4ce5iMPGw9nh+AtN87h6VR2cJ0xmUZ8AydfPSRj7QGds0KCadZleVmZNGebPl
	8nUxUUS1V/zlDPe5v6yypOMeLbK4rTQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oUHpDMan;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783418772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iVAviCN7869jBAR3D9GRMf7uO9qtAANWt/58UgMTqEU=;
	b=lTVzjKIhCUe6naZaFMcgl1GMDmY9KHlZxxApP752cSrPxUbH/D41uFvpiKwQRYIEu+63uc
	UPs9F9EZQRWjZoMc8ppexYg+6DsT/zh/UOr76Dh/cABTGjwdnFsHYmNWcOizy1xXrZ3XSU
	KeV2ijFxosjbcYGTF37r0f92U3A3/Dk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A4D97618A6;
	Tue,  7 Jul 2026 10:06:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE1E91F000E9;
	Tue,  7 Jul 2026 10:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783418771;
	bh=iVAviCN7869jBAR3D9GRMf7uO9qtAANWt/58UgMTqEU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=oUHpDManRFgR4KAFjo00AhRjf6aWtaBZCylwO8VTF/Ssnnqk3BldXcjN7TMn+pR3a
	 fXmPBkJS5zHIHIEMMB8pM3hf9pVy+1es95CKqgJbPBXDD5Vul1KuQKTzxax7JN747r
	 x7dQvklu854ppcSXzmWU8vaSvUX4sqx3F1BZTPtoRLthr7nlGfpFimT/H3cEr81Nje
	 B7OvRiIdSbW8l5eCzWMnmysOsJiDYyC77/W/E8Oj6YGuM3jo0luS284kWZEXowhGUy
	 uJZia6KvK7kjbtLvkZCCrl/1/3k7LUJUFLxV75f9TWXXis+QeDGbkCQlOVIIoWd0rs
	 jLKl1tS1Xw//g==
Message-ID: <776663aa-3378-4c55-8c2e-3231443dfee4@kernel.org>
Date: Tue, 7 Jul 2026 12:06:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/kconfig: Drop redundant memory hotplug dependencies
To: Kaitao Cheng <kaitao.cheng@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Muchun Song <muchun.song@linux.dev>, Kaitao Cheng <chengkaitao@kylinos.cn>
References: <20260707090331.52971-1-kaitao.cheng@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260707090331.52971-1-kaitao.cheng@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2026C140007
X-Rspam-User: 
X-Stat-Signature: c4qpnyyjj1td39imuz9t9s1gz9x8tfdm
X-Rspamd-Server: rspam03
X-HE-Tag: 1783418771-800388
X-HE-Meta: U2FsdGVkX1+NVAtSyALAWGc+X6Ej4Dv0E3MEaOV63NK2kd6dIP5tAvd+NTar7hyazCjzgsxRTlorsOAK2aH8PPey1BwoBajv1pu4Qkbw/2RVK2HdfJaXV15DfBEgkVxQW7a3oj5nZGjpMYMnFSvwmhx126JfmFFCE5l9+PnSyf3cK4c7fkWLrFf935nenjO1y/w0I14ppfHcS57OTrXBR6YbCUZ5gi5IMAeV+oyQoDgAQU5m+GyYbYF0Gx7/UYVQdoUq1q22vuYJYaYV2LHLiGos0QG4YwGebzefQglc7TamIE/bh926iKCP0NBZCBXiDOjVtYLfoji0iXUMlBgvybsYHJChnpuAhb8vJTFAhns+4vhSivT1K7WBtcTzmNE7Ar7Kn63RgmanZpKI0tefhb+2biAb7yy8gi3gjbeYrOwhjkPKwafBPzDMq+xuNKCDK4ut4wbc4Orj9KYnBjYPO+rWszm8M4INYvVnCWnep/b7Ylmq6ISJK1AV1DQ9l0ocoOqHsQSMh6ReYMSvJo58fT7fgPCZCvcskQFAUqF9U/xDe2wnWat/q0/ksH+nIs5q/ldfj0Ylus36Vp7S86xpetorKdCUT+/FoyncCiifrGALxVO9lue4aHZybea18o4hfZExdffCpHK5ttMyCRh6nUjmcbUo/FGxs9id2VrOE+FfuOx0AY22N1kjtgdOuX3rT2IGqbrvMKlO4pAcPYThfyGzo8tORl6o3eIAp/CVvgdD1jm5IgvO1FFJ2PgtAwtOtuav587aKhLtA7pqPTK/pKgGKtTDjDdIqrco3hAgNRqwBoOYk889mTdSBRgUga/zEIUU0Cm7WUiHB805hmjQWUUodq2H/QQLEPVPSujSUOFK2y2X9uovwBz7LO3N9/r33BODYnEjpC1Y+OQmOTGfHppDjYo806ISwHhmZbTQATMpaXXq7p/W/c1QA54z7Y56aPQ0QuF+6GxqzI1yQc7
 rgS4O2C9
 iQ4wouUmOc5bX0+24gS3m6b6dEw+QLkOCEUoYqgAFycjtxDqZkVgzZ9+XWrrIFb0tNmwHcjYvenFhBXNKHMQBcUsVjVdQwdUiZJSxRGmv1WXLAJnDNZBzcbDkQgOaCMCgjuEALDziUMhrMIw+FqpwwVpHqLx2P1rNxwkKwopF2z5TPl81W8Sb08+uobCusU4VW/S/7VnYkcgf9KYJBIaIzLwhO30fAgfqTTOvMo/EET2y9zvoD8BIUe8RyMJi3hPngZ4eS5/y1HY1Ri7sfZhdFUJluQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/7/26 11:03, Kaitao Cheng wrote:
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> MHP_MEMMAP_ON_MEMORY is defined inside the MEMORY_HOTPLUG block, and
> MEMORY_HOTPLUG already depends on SPARSEMEM_VMEMMAP. Keep the explicit
> MEMORY_HOTPLUG dependency for local readability, but drop the redundant
> SPARSEMEM_VMEMMAP dependency.
> 
> ZONE_DEVICE depends on MEMORY_HOTREMOVE, which depends on MEMORY_HOTPLUG.
> MEMORY_HOTPLUG in turn depends on SPARSEMEM_VMEMMAP. Drop the direct
> MEMORY_HOTPLUG and SPARSEMEM_VMEMMAP dependencies from ZONE_DEVICE.
> 
> This does not change the set of valid configurations.
> 
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
> ---
>  mm/Kconfig | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 04fe5171bb8c..ff29f770d10a 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -596,7 +596,7 @@ config MEMORY_HOTREMOVE
>  
>  config MHP_MEMMAP_ON_MEMORY
>  	def_bool y
> -	depends on MEMORY_HOTPLUG && SPARSEMEM_VMEMMAP
> +	depends on MEMORY_HOTPLUG
>  	depends on ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE
>  
>  endif # MEMORY_HOTPLUG
> @@ -1235,9 +1235,7 @@ config ZONE_DMA32
>  
>  config ZONE_DEVICE
>  	bool "Device memory (pmem, HMM, etc...) hotplug support"
> -	depends on MEMORY_HOTPLUG
>  	depends on MEMORY_HOTREMOVE
> -	depends on SPARSEMEM_VMEMMAP
>  	select XARRAY_MULTI

I'm planning on merging  MEMORY_HOTPLUG and MEMORY_HOTREMOVE soon, but for now
that is good enough.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

